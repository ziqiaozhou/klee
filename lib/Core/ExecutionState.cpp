//===-- ExecutionState.cpp ------------------------------------------------===//
//
//                     The KLEE Symbolic Virtual Machine
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "klee/ExecutionState.h"

#include "klee/Internal/Module/Cell.h"
#include "klee/Internal/Module/InstructionInfoTable.h"
#include "klee/Internal/Module/KInstruction.h"
#include "klee/Internal/Module/KModule.h"
#include "klee/Internal/Support/ErrorHandling.h"
#include "klee/Expr.h"

#include "Memory.h"
#if LLVM_VERSION_CODE >= LLVM_VERSION(3, 3)
#include "llvm/IR/Function.h"
#else
#include "llvm/Function.h"
#endif
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/raw_ostream.h"

#include <iomanip>
#include <sstream>
#include <cassert>
#include <map>
#include <set>
#include <stdarg.h>

using namespace llvm;
using namespace klee;

namespace { 
  cl::opt<bool>
  DebugLogStateMerge("debug-log-state-merge");
}

/***/
#if !MULTITHREAD
StackFrame::StackFrame(KInstIterator _caller, KFunction *_kf)
  : caller(_caller), kf(_kf), callPathNode(0), 
    minDistToUncoveredOnReturn(0), varargs(0) {
  locals = new Cell[kf->numRegisters];
}

StackFrame::StackFrame(const StackFrame &s) 
  : caller(s.caller),
    kf(s.kf),
    callPathNode(s.callPathNode),
    allocas(s.allocas),
    minDistToUncoveredOnReturn(s.minDistToUncoveredOnReturn),
    varargs(s.varargs) {
  locals = new Cell[s.kf->numRegisters];
  for (unsigned i=0; i<s.kf->numRegisters; i++)
    locals[i] = s.locals[i];
}

StackFrame::~StackFrame() { 
  delete[] locals; 
}
#endif
/***/

ExecutionState::ExecutionState(KFunction *kf) :
#if !MULTITHREAD
	pc(kf->instructions),
    prevPC(pc),
#endif
    queryCost(0.), 
    weight(1),
    depth(0),

    instsSinceCovNew(0),
    coveredNew(false),
    forkDisabled(false),
    ptreeNode(0)
#if MULTITHREAD 
	,wlistCounter(1),
	preemptions(0),
	try_merge(false)
#endif
{
#if MULTITHREAD
	setupMain(kf);
#else
  pushFrame(0, kf);
#endif
}

ExecutionState::ExecutionState(const std::vector<ref<Expr> > &assumptions)
    : constraints(assumptions), queryCost(0.), ptreeNode(0)
#if MULTITHREAD
	  ,wlistCounter(1), preemptions(0),try_merge(false)
{
	setupMain(NULL);
}
#else
{}
#endif
#if MULTITHREAD
void ExecutionState::setupMain(KFunction *kf) {
	Thread mainThread = Thread(0, kf);
	threads.insert(std::make_pair(mainThread.tid, mainThread));
	 crtThreadIt = threads.begin();
}
#endif
ExecutionState::~ExecutionState() {
  for (unsigned int i=0; i<symbolics.size(); i++)
  {
    const MemoryObject *mo = symbolics[i].first;
    assert(mo->refCount > 0);
    mo->refCount--;
    if (mo->refCount == 0)
      delete mo;
  }
#if MULTITHREAD
  for (threads_ty::iterator it = threads.begin(); it != threads.end(); it++) {
	  Thread &t = it->second;
	  while (!t.stack.empty()) popFrame(t);
  }
#else
  while (!stack.empty()) popFrame();
#endif
}

ExecutionState::ExecutionState(const ExecutionState& state):
    fnAliases(state.fnAliases),
	try_merge(false),
#if !MULTITHREAD
	pc(state.pc),
    prevPC(state.prevPC),
    stack(state.stack),
    incomingBBIndex(state.incomingBBIndex),
#endif
    addressSpace(state.addressSpace),
    constraints(state.constraints),

    queryCost(state.queryCost),
    weight(state.weight),
    depth(state.depth),

    pathOS(state.pathOS),
    symPathOS(state.symPathOS),
    instsSinceCovNew(state.instsSinceCovNew),
    coveredNew(state.coveredNew),
    forkDisabled(state.forkDisabled),
    coveredLines(state.coveredLines),
    ptreeNode(state.ptreeNode),
	symbolics(state.symbolics),
	mergeObs(state.mergeObs),
	observables(state.observables),
#if MULTITHREAD
	arrayNames(state.arrayNames),
	threads(state.threads),
	waitingLists(state.waitingLists),
	wlistCounter(state.wlistCounter),
	preemptions(state.preemptions),
	schedulingHistory(state.schedulingHistory)
#else
arrayNames(state.arrayNames)
#endif
{
  for (unsigned int i=0; i<symbolics.size(); i++)
    symbolics[i].first->refCount++;

}

ExecutionState *ExecutionState::branch() {
  depth++;

  ExecutionState *falseState = new ExecutionState(*this);
  falseState->coveredNew = false;
  falseState->coveredLines.clear();

  weight *= .5;
  falseState->weight -= weight;

  return falseState;
}

void ExecutionState::pushFrame(KInstIterator caller, KFunction *kf) {
#if MULTITHREAD
	stack().push_back(StackFrame(caller,kf));
#else
	stack.push_back(StackFrame(caller,kf));
#endif
}

void ExecutionState::popFrame() {
#if MULTITHREAD
	popFrame(crtThread());
#else
	StackFrame &sf = stack.back();
	for (std::vector<const MemoryObject*>::iterator it = sf.allocas.begin(), 
				ie = sf.allocas.end(); it != ie; ++it)
	  addressSpace.unbindObject(*it);
	stack.pop_back();
#endif
}

void ExecutionState::addSymbolic(const MemoryObject *mo, const Array *array) { 
	mo->refCount++;
	symbolics.push_back(std::make_pair(mo, array));
}
///
#if MULTITHREAD
void ExecutionState::popFrame(Thread &t) {
	StackFrame &sf = t.stack.back();
	for (std::vector<const MemoryObject*>::iterator it = sf.allocas.begin(),
				ie = sf.allocas.end(); it != ie; ++it)
	  addressSpace.unbindObject(*it);
	t.stack.pop_back();
}
Thread& ExecutionState::createThread(Thread::thread_id_t tid, KFunction *kf) {
	Thread newThread = Thread(tid,  kf);
	threads.insert(std::make_pair(newThread.tid, newThread));
	return threads.find(tid)->second;
}

void ExecutionState::terminateThread(threads_ty::iterator thrIt) {
	assert(threads.size() > 1);
	assert(thrIt != crtThreadIt); 
	assert(!thrIt->second.enabled);
	assert(thrIt->second.waitingList == 0);
	threads.erase(thrIt);
}

void ExecutionState::sleepThread(Thread::wlist_id_t wlist) {
	assert(crtThread().enabled);
	assert(wlist > 0);

	crtThread().enabled = false;
	crtThread().waitingList = wlist;

	std::set<Thread::thread_id_t> &wl = waitingLists[wlist];

	wl.insert(crtThread().tid);
}

void ExecutionState::notifyOne(Thread::wlist_id_t wlist, Thread::thread_id_t tid) {
	assert(wlist > 0);

	std::set<Thread::thread_id_t> &wl = waitingLists[wlist];

	if (wl.erase(tid) != 1) {
		assert(0 && "thread was not waiting");
	}

	Thread &thread = threads.find(tid)->second;
	assert(!thread.enabled);
	thread.enabled = true;
	thread.waitingList = 0;

	if (wl.size() == 0)
	  waitingLists.erase(wlist);
}

void ExecutionState::notifyAll(Thread::wlist_id_t wlist) {
	assert(wlist > 0);

	std::set<Thread::thread_id_t> &wl = waitingLists[wlist];

	if (wl.size() > 0) {
		for (std::set<Thread::thread_id_t>::iterator it = wl.begin(); it != wl.end(); it++) {
			Thread &thread = threads.find(*it)->second;
			thread.enabled = true;
			thread.waitingList = 0;
		}

		wl.clear();
	}

	waitingLists.erase(wlist);
}
#endif

std::string ExecutionState::getFnAlias(std::string fn) {
  std::map < std::string, std::string >::iterator it = fnAliases.find(fn);
  if (it != fnAliases.end())
    return it->second;
  else return "";
}

void ExecutionState::addFnAlias(std::string old_fn, std::string new_fn) {
  fnAliases[old_fn] = new_fn;
}

void ExecutionState::removeFnAlias(std::string fn) {
  fnAliases.erase(fn);
}

/**/

llvm::raw_ostream &klee::operator<<(llvm::raw_ostream &os, const MemoryMap &mm) {
  os << "{";
  MemoryMap::iterator it = mm.begin();
  MemoryMap::iterator ie = mm.end();
  if (it!=ie) {
    os << "MO" << it->first->id << ":" << it->second;
    for (++it; it!=ie; ++it)
      os << ", MO" << it->first->id << ":" << it->second;
  }
  os << "}";
  return os;
}

bool ExecutionState::merge(const ExecutionState &b) {
  if (DebugLogStateMerge)
    llvm::errs() << "-- attempting merge of A:" << this << " with B:" << &b
                 << "--\n";
#if MULTITHREAD
  if (pc() != b.pc())
	return false;
  if (threads.size() != 1 || b.threads.size() != 1)
	return false;
  if (crtThread().tid != b.crtThread().tid) // No merge if different thread
	return false;
#else
  if (pc != b.pc)
    return false;
#endif
  // XXX is it even possible for these to differ? does it matter? probably
  // implies difference in object states?
  if (symbolics!=b.symbolics)
    return false;

  if(b.mergeObs.size()!=mergeObs.size()){
	  return false;
  }

  //klee_warning("check observable %d",mergeObs.size());
  for (unsigned int i=0; i<mergeObs.size(); i++){
	 	  const MemoryObject * ma=mergeObs[i].second;
		  const MemoryObject * mb=b.mergeObs[i].second;
		  const ObjectState *os = addressSpace.findObject(ma);
		  const ObjectState *otherOS = b.addressSpace.findObject(ma);
		  for(unsigned i=0;i<ma->size;++i){
			  /* std::string obstr="";
				 llvm::raw_string_ostream obstrs(obstr);

				 obstrs  <<os->read8(i)<<",";
				 obstrs<<otherOS->read8(i)<<"\n";
				 klee_warning("%s",obstrs.str().c_str());
				 */
			  if(os->read8(i)!=otherOS->read8(i)){
				  klee_warning("ob value differs\n");
				  return false;
			  }
		  }
  }

  {
#if MULTITHREAD
	   std::vector<StackFrame>::const_iterator itA = stack().begin();
	   std::vector<StackFrame>::const_iterator itB = b.stack().begin();
	    while (itA!=stack().end() && itB!=b.stack().end()) {
#else
	  std::vector<StackFrame>::const_iterator itA = stack.begin();
    std::vector<StackFrame>::const_iterator itB = b.stack.begin();
    while (itA!=stack.end() && itB!=b.stack.end()) {
#endif
		// XXX vaargs?
      if (itA->caller!=itB->caller || itA->kf!=itB->kf)
        return false;
      ++itA;
      ++itB;
    }
#if MULTITHREAD
	if (itA!=stack().end() || itB!=b.stack().end())
#else 
    if (itA!=stack.end() || itB!=b.stack.end())
#endif
	  return false;
  }

  std::set< ref<Expr> > aConstraints(constraints.begin(), constraints.end());
  std::set< ref<Expr> > bConstraints(b.constraints.begin(), 
                                     b.constraints.end());
  std::set< ref<Expr> > commonConstraints, aSuffix, bSuffix;
  std::set_intersection(aConstraints.begin(), aConstraints.end(),
                        bConstraints.begin(), bConstraints.end(),
                        std::inserter(commonConstraints, commonConstraints.begin()));
  std::set_difference(aConstraints.begin(), aConstraints.end(),
                      commonConstraints.begin(), commonConstraints.end(),
                      std::inserter(aSuffix, aSuffix.end()));
  std::set_difference(bConstraints.begin(), bConstraints.end(),
                      commonConstraints.begin(), commonConstraints.end(),
                      std::inserter(bSuffix, bSuffix.end()));
  if (DebugLogStateMerge) {
    llvm::errs() << "\tconstraint prefix: [";
    for (std::set<ref<Expr> >::iterator it = commonConstraints.begin(),
                                        ie = commonConstraints.end();
         it != ie; ++it)
      llvm::errs() << *it << ", ";
    llvm::errs() << "]\n";
    llvm::errs() << "\tA suffix: [";
    for (std::set<ref<Expr> >::iterator it = aSuffix.begin(),
                                        ie = aSuffix.end();
         it != ie; ++it)
      llvm::errs() << *it << ", ";
    llvm::errs() << "]\n";
    llvm::errs() << "\tB suffix: [";
    for (std::set<ref<Expr> >::iterator it = bSuffix.begin(),
                                        ie = bSuffix.end();
         it != ie; ++it)
      llvm::errs() << *it << ", ";
    llvm::errs() << "]\n";
  }

  // We cannot merge if addresses would resolve differently in the
  // states. This means:
  // 
  // 1. Any objects created since the branch in either object must
  // have been free'd.
  //
  // 2. We cannot have free'd any pre-existing object in one state
  // and not the other

  if (DebugLogStateMerge) {
    llvm::errs() << "\tchecking object states\n";
    llvm::errs() << "A: " << addressSpace.objects << "\n";
    llvm::errs() << "B: " << b.addressSpace.objects << "\n";
  }
    
  std::set<const MemoryObject*> mutated;
  MemoryMap::iterator ai = addressSpace.objects.begin();
  MemoryMap::iterator bi = b.addressSpace.objects.begin();
  MemoryMap::iterator ae = addressSpace.objects.end();
  MemoryMap::iterator be = b.addressSpace.objects.end();
  for (; ai!=ae && bi!=be; ++ai, ++bi) {
    if (ai->first != bi->first) {
      if (DebugLogStateMerge) {
        if (ai->first < bi->first) {
          llvm::errs() << "\t\tB misses binding for: " << ai->first->id << "\n";
        } else {
          llvm::errs() << "\t\tA misses binding for: " << bi->first->id << "\n";
        }
      }
      return false;
    }
    if (ai->second != bi->second) {
      if (DebugLogStateMerge)
        llvm::errs() << "\t\tmutated: " << ai->first->id << "\n";
      mutated.insert(ai->first);
    }
  }
  if (ai!=ae || bi!=be) {
    if (DebugLogStateMerge)
      llvm::errs() << "\t\tmappings differ\n";
    return false;
  }
 
  // merge stack

  ref<Expr> inA = ConstantExpr::alloc(1, Expr::Bool);
  ref<Expr> inB = ConstantExpr::alloc(1, Expr::Bool);
  for (std::set< ref<Expr> >::iterator it = aSuffix.begin(), 
         ie = aSuffix.end(); it != ie; ++it)
    inA = AndExpr::create(inA, *it);
  for (std::set< ref<Expr> >::iterator it = bSuffix.begin(), 
         ie = bSuffix.end(); it != ie; ++it)
    inB = AndExpr::create(inB, *it);

  // XXX should we have a preference as to which predicate to use?
  // it seems like it can make a difference, even though logically
  // they must contradict each other and so inA => !inB
#if MULTITHREAD
  std::vector<StackFrame>::iterator itA = stack().begin();
  std::vector<StackFrame>::const_iterator itB = b.stack().begin();
  for (; itA!=stack().end(); ++itA, ++itB) {
#else
  std::vector<StackFrame>::iterator itA = stack.begin();
  std::vector<StackFrame>::const_iterator itB = b.stack.begin();
  for (; itA!=stack.end(); ++itA, ++itB) {
#endif
	  StackFrame &af = *itA;
    const StackFrame &bf = *itB;
    for (unsigned i=0; i<af.kf->numRegisters; i++) {
      ref<Expr> &av = af.locals[i].value;
      const ref<Expr> &bv = bf.locals[i].value;
      if (av.isNull() || bv.isNull()) {
        // if one is null then by implication (we are at same pc)
        // we cannot reuse this local, so just ignore
      } else {
        av = SelectExpr::create(inA, av, bv);
      }
    }
  }

  for (std::set<const MemoryObject*>::iterator it = mutated.begin(), 
         ie = mutated.end(); it != ie; ++it) {
    const MemoryObject *mo = *it;
    const ObjectState *os = addressSpace.findObject(mo);
    const ObjectState *otherOS = b.addressSpace.findObject(mo);
    assert(os && !os->readOnly && 
           "objects mutated but not writable in merging state");
    assert(otherOS);

    ObjectState *wos = addressSpace.getWriteable(mo, os);
    for (unsigned i=0; i<mo->size; i++) {
      ref<Expr> av = wos->read8(i);
      ref<Expr> bv = otherOS->read8(i);
      wos->write(i, SelectExpr::create(inA, av, bv));
    }
  }

  constraints = ConstraintManager();
  for (std::set< ref<Expr> >::iterator it = commonConstraints.begin(), 
         ie = commonConstraints.end(); it != ie; ++it)
    constraints.addConstraint(*it);
  constraints.addConstraint(OrExpr::create(inA, inB));

  return true;
}

void ExecutionState::dumpStack(llvm::raw_ostream &out) const {
  unsigned idx = 0;
#if MULTITHREAD
  const KInstruction *target = prevPC();
  for (Thread::stack_ty::const_reverse_iterator
			  it = stack().rbegin(), ie = stack().rend();
#else
  const KInstruction *target = prevPC;
  for (ExecutionState::stack_ty::const_reverse_iterator
         it = stack.rbegin(), ie = stack.rend();
#endif
       it != ie; ++it) {
    const StackFrame &sf = *it;
    Function *f = sf.kf->function;
    const InstructionInfo &ii = *target->info;
    out << "\t#" << idx++;
    std::stringstream AssStream;
    AssStream << std::setw(8) << std::setfill('0') << ii.assemblyLine;
    out << AssStream.str();
    out << " in " << f->getName().str() << " (";
    // Yawn, we could go up and print varargs if we wanted to.
    unsigned index = 0;
    for (Function::arg_iterator ai = f->arg_begin(), ae = f->arg_end();
         ai != ae; ++ai) {
      if (ai!=f->arg_begin()) out << ", ";

      out << ai->getName().str();
      // XXX should go through function
      ref<Expr> value = sf.locals[sf.kf->getArgRegister(index++)].value; 
      if (isa<ConstantExpr>(value))
        out << "=" << value;
    }
    out << ")";
    if (ii.file != "")
      out << " at " << ii.file << ":" << ii.line;
    out << "\n";
    target = sf.caller;
  }
}
