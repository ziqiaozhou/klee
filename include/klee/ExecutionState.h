//===-- ExecutionState.h ----------------------------------------*- C++ -*-===//
//
//                     The KLEE Symbolic Virtual Machine
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef KLEE_EXECUTIONSTATE_H
#define KLEE_EXECUTIONSTATE_H

#include "klee/Constraints.h"
#include "klee/Expr.h"
#include "klee/Internal/ADT/TreeStream.h"
#include "Config/Version.h"
// FIXME: We do not want to be exposing these? :(
#include "../../lib/Core/AddressSpace.h"
#include "klee/Internal/Module/KInstIterator.h"
#if MULTITHREAD
#include "../../lib/Core/Thread.h"
#endif
#include "llvm/IR/Type.h"
#include <map>
#include <set>
#include <vector>
#include <tuple>
#include <functional>
#include<iostream>
namespace klee {
class Array;
class CallPathNode;
struct Cell;
struct KFunction;
struct KInstruction;
class MemoryObject;
class PTreeNode;
struct InstructionInfo;

llvm::raw_ostream &operator<<(llvm::raw_ostream &os, const MemoryMap &mm);
#if !MULTITHREAD
struct StackFrame {
  KInstIterator caller;
  KFunction *kf;
  CallPathNode *callPathNode;

  std::vector<const MemoryObject *> allocas;
  Cell *locals;

  /// Minimum distance to an uncovered instruction once the function
  /// returns. This is not a good place for this but is used to
  /// quickly compute the context sensitive minimum distance to an
  /// uncovered instruction. This value is updated by the StatsTracker
  /// periodically.
  unsigned minDistToUncoveredOnReturn;

  // For vararg functions: arguments not passed via parameter are
  // stored (packed tightly) in a local (alloca) memory object. This
  // is setup to match the way the front-end generates vaarg code (it
  // does not pass vaarg through as expected). VACopy is lowered inside
  // of intrinsic lowering.
  MemoryObject *varargs;

  StackFrame(KInstIterator caller, KFunction *kf);
  StackFrame(const StackFrame &s);
  ~StackFrame();
};
#endif
/// @brief ExecutionState representing a path under exploration
class ExecutionState {
	public:

#if MULTITHREAD
		typedef std::map<Thread::thread_id_t, Thread> threads_ty;
		typedef std::map<Thread::wlist_id_t, std::set<Thread::thread_id_t> > wlists_ty;
#else

		typedef std::vector<StackFrame> stack_ty;
#endif
private:
  // unsupported, use copy constructor
  ExecutionState &operator=(const ExecutionState &);

  std::map<std::string, std::string> fnAliases;

public:
  // Execution - Control Flow specific

  std::vector<std::tuple<std::string,ref<Expr>>> observables;
  /// @brief Pointer to instruction to be executed after the current
  /// instruction
#if MULTITHREAD
  KInstIterator& pc() { return crtThread().pc; }
  const KInstIterator& pc() const { return crtThread().pc; }
KInstIterator& prevPC() { return crtThread().prevPC; }
const KInstIterator& prevPC() const { return crtThread().prevPC; }
Thread::stack_ty& stack() { return crtThread().stack; }
const Thread::stack_ty& stack() const { return crtThread().stack; }
unsigned incomingBBIndex() { return crtThread().incomingBBIndex; };
void incomingBBIndex(unsigned ibbi) { crtThread().incomingBBIndex = ibbi; }
#else
  KInstIterator pc;
  /// @brief Pointer to instruction which is currently executed
  KInstIterator prevPC;
  /// @brief Stack representing the current instruction stream
  
  stack_ty stack;

  /// @brief Remember from which Basic Block control flow arrived
  /// (i.e. to select the right phi values)
  unsigned incomingBBIndex;
#endif
  // Overall state of the state - Data specific

  /// @brief Address space used by this state (e.g. Global and Heap)
  AddressSpace addressSpace;

  /// @brief Constraints collected so far
  ConstraintManager constraints;

  /// Statistics and information

  /// @brief Costs for all queries issued for this state, in seconds
  mutable double queryCost;

  /// @brief Weight assigned for importance of this state.  Can be
  /// used for searchers to decide what paths to explore
  double weight;

  /// @brief Exploration depth, i.e., number of times KLEE branched for this state
  unsigned depth;

  /// @brief History of complete path: represents branches taken to
  /// reach/create this state (both concrete and symbolic)
  TreeOStream pathOS;

  /// @brief History of symbolic path: represents symbolic branches
  /// taken to reach/create this state
  TreeOStream symPathOS;

  /// @brief Counts how many instructions were executed since the last new
  /// instruction was covered.
  unsigned instsSinceCovNew;

  /// @brief Whether a new instruction was covered in this state
  bool coveredNew;

  /// @brief Disables forking for this state. Set by user code
  bool forkDisabled;

  /// @brief Set containing which lines in which files are covered by this state
  std::map<const std::string *, std::set<unsigned> > coveredLines;

  /// @brief Pointer to the process tree of the current state
  PTreeNode *ptreeNode;

  /// @brief Ordered list of symbolics: used to generate test cases.
  //
  // FIXME: Move to a shared list structure (not critical).
  std::vector<std::pair<const MemoryObject *, const Array *> > symbolics;

  /// @brief Set of used array names for this state.  Used to avoid collisions.
  std::set<std::string> arrayNames;
#if EXTERNAL_SUPPORT
  /// @brief For a multi threaded ExecutionState
  threads_ty threads;
  processes_ty processes;

  wlists_ty waitingLists;
  wlist_id_t wlistCounter;
#endif
  std::string getFnAlias(std::string fn);
  void addFnAlias(std::string old_fn, std::string new_fn);
  void removeFnAlias(std::string fn);
#if MULTITHREAD
  threads_ty threads;
  // @brief Pointer to current thread
  threads_ty::iterator crtThreadIt;
  Thread &crtThread() { return crtThreadIt->second; }
  const Thread &crtThread() const { return crtThreadIt->second; }

  // @brief Waiting lists to block threads
  wlists_ty waitingLists;
  Thread::wlist_id_t wlistCounter;

  // @brief Accumulated preemptions
  unsigned int preemptions;

  // @brief List of context switches performed
  std::vector<Thread::thread_id_t> schedulingHistory;

  // @brief Create a new thread in the state
  Thread& createThread(Thread::thread_id_t tid, KFunction *kf);

  // @brief Terminate the specified thread
  void terminateThread(threads_ty::iterator it);

  // @brief Get next thread to be scheduled (round robin)
  threads_ty::iterator nextThread(threads_ty::iterator it) {
	  if (it == threads.end())
		it = threads.begin();
	  else {
		  it++;
		  if (it == threads.end())
			it = threads.begin();
	  }
	  return it;
  }

  // @brief Set thread as active thread
  void scheduleNext(threads_ty::iterator it) {
	  assert(it != threads.end());
	  crtThreadIt = it;
	  schedulingHistory.push_back(crtThread().tid);
  }
std::set<Thread::thread_id_t> enabledThreadIds() {
    std::set<Thread::thread_id_t> enabled;
    for (threads_ty::iterator it = threads.begin();
         it != threads.end();  it++)
      if (it->second.enabled)
        enabled.insert(it->second.tid);
    return enabled;
  }

  // @brief Generate a new waiting list
  Thread::wlist_id_t getWaitingList() { return wlistCounter++; }


  void sleepThread(Thread::wlist_id_t wlist);
  void notifyOne(Thread::wlist_id_t wlist, Thread::thread_id_t tid);
  void notifyAll(Thread::wlist_id_t wlist);
void setupMain(KFunction *kf);
 void popFrame(Thread &t);
#endif 
private:
  ExecutionState() : ptreeNode(0) {}

public:
  ExecutionState(KFunction *kf);

  // XXX total hack, just used to make a state so solver can
  // use on structure
  ExecutionState(const std::vector<ref<Expr> > &assumptions);

  ExecutionState(const ExecutionState &state);

  ~ExecutionState();

  ExecutionState *branch();

  void pushFrame(KInstIterator caller, KFunction *kf);
  void popFrame();
  void pushOb(std::string name,ref<Expr>expr){
	  observables.push_back(std::make_tuple(name,expr));
  }
 
  void addSymbolic(const MemoryObject *mo, const Array *array);
  void addConstraint(ref<Expr> e) { constraints.addConstraint(e); }

  bool merge(const ExecutionState &b);
  void dumpStack(llvm::raw_ostream &out) const;
};
}

#endif
