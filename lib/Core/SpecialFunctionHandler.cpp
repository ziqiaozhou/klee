//===-- SpecialFunctionHandler.cpp ----------------------------------------===//
//
//                     The KLEE Symbolic Virtual Machine
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "Memory.h"
#include "SpecialFunctionHandler.h"
#include "TimingSolver.h"

#include "klee/ExecutionState.h"
#include<stdlib.h>
#include<stdio.h>
#include<iostream>
#include "klee/Internal/Module/KInstruction.h"
#include "klee/Internal/Module/KModule.h"
#include "klee/Internal/Support/Debug.h"
#include "klee/Internal/Support/ErrorHandling.h"
#if MULTITHREAD
#include "Thread.h"
#endif
#include "Executor.h"
#include "MemoryManager.h"

#include "klee/CommandLine.h"

#if LLVM_VERSION_CODE >= LLVM_VERSION(3, 3)
#include "llvm/IR/Module.h"
#include "llvm/IR/LLVMContext.h"
#else
#include "llvm/Module.h"
#include "llvm/Type.h"
#include "llvm/DerivedTypes.h"
#include "llvm/InstrTypes.h"
#include "llvm/LLVMContext.h"
#endif
#include "llvm/ADT/Twine.h"

#include <errno.h>

using namespace llvm;
using namespace klee;

namespace {
  cl::opt<bool>
  ReadablePosix("readable-posix-inputs",
            cl::init(false),
            cl::desc("Prefer creation of POSIX inputs (command-line arguments, files, etc.) with human readable bytes. "
                     "Note: option is expensive when creating lots of tests (default=false)"));

  cl::opt<bool>
  SilentKleeAssume("silent-klee-assume",
                   cl::init(false),
                   cl::desc("Silently terminate paths with an infeasible "
                            "condition given to klee_assume() rather than "
                            "emitting an error (default=false)"));
}


/// \todo Almost all of the demands in this file should be replaced
/// with terminateState calls.

///



// FIXME: We are more or less committed to requiring an intrinsic
// library these days. We can move some of this stuff there,
// especially things like realloc which have complicated semantics
// w.r.t. forking. Among other things this makes delayed query
// dispatch easier to implement.
static SpecialFunctionHandler::HandlerInfo handlerInfo[] = {
#define add(name, handler, ret) { name, \
                                  &SpecialFunctionHandler::handler, \
                                  false, ret, false }
#define addDNR(name, handler) { name, \
                                &SpecialFunctionHandler::handler, \
                                true, false, false }
  addDNR("__assert_rtn", handleAssertFail),
  addDNR("__assert_fail", handleAssertFail),
  addDNR("_assert", handleAssert),
  addDNR("abort", handleAbort),
  addDNR("_exit", handleExit),
  { "exit", &SpecialFunctionHandler::handleExit, true, false, true },
  addDNR("klee_abort", handleAbort),
  addDNR("klee_silent_exit", handleSilentExit),  
  addDNR("klee_report_error", handleReportError),
#if MULTITHREAD
  addDNR("klee_thread_terminate", handleThreadTerminate),
#endif
  add("calloc", handleCalloc, true),
  add("free", handleFree, false),
  add("klee_assume", handleAssume, false),
  add("klee_check_memory_access", handleCheckMemoryAccess, false),
  add("klee_get_valuef", handleGetValue, true),
  add("klee_get_valued", handleGetValue, true),
  add("klee_get_valuel", handleGetValue, true),
  add("klee_get_valuell", handleGetValue, true),
  add("klee_get_value_i32", handleGetValue, true),
  add("klee_get_value_i64", handleGetValue, true),
  add("klee_define_fixed_object", handleDefineFixedObject, false),
  add("klee_get_obj_size", handleGetObjSize, true),
  add("klee_get_errno", handleGetErrno, true),
  add("klee_is_symbolic", handleIsSymbolic, true),
  add("klee_make_symbolic", handleMakeSymbolic, false),

  add("klee_make_attackerO", handleMakeAttackerO, false),
  add("klee_make_attackerC", handleMakeAttackerC, false),
  add("klee_make_secret", handleMakeSecret, false),
 add("klee_make_observable",handleMakeObservable,false), 
  add("klee_mark_global", handleMarkGlobal, false),
  add("klee_merge", handleMerge, false),
  add("klee_prefer_cex", handlePreferCex, false),
  add("klee_posix_prefer_cex", handlePosixPreferCex, false),
  add("klee_print_expr", handlePrintExpr, false),
  add("klee_print_range", handlePrintRange, false),
  add("klee_set_forking", handleSetForking, false),
  add("klee_stack_trace", handleStackTrace, false),
   add("klee_debug", handleDebug, false),
  add("klee_warning", handleWarning, false),
  add("klee_warning_once", handleWarningOnce, false),
  add("klee_alias_function", handleAliasFunction, false),

  add("klee_make_shared", handleMakeShared, false),
#if MULTITHREAD

  add("klee_get_context", handleGetContext, false),
  add("klee_get_wlist", handleGetWList, true),
  add("klee_thread_create", handleThreadCreate, false),
  add("klee_thread_notify", handleThreadNotify, false),
  add("klee_thread_preempt", handleThreadPreempt, false),
  add("klee_thread_sleep", handleThreadSleep, false),
#endif
#if EXTERNAL_SUPPORT
  /*cloud 9 function*/

  add("klee_get_context", handleGetContext, false),
  add("klee_get_wlist", handleGetWList, true),
  add("klee_thread_preempt", handleThreadPreempt, false),
  add("klee_thread_sleep", handleThreadSleep, false),
  add("klee_thread_notify", handleThreadNotify, false),
  add("klee_thread_create", handleThreadCreate, false),
  add("klee_process_fork", handleProcessFork, true),
  add("klee_branch", handleBranch, true),
  add("klee_process_fork", handleProcessFork, true),
  add("klee_get_time", handleGetTime, true),
  add("klee_set_time", handleSetTime, false),
  add("klee_begin_checked", handleBeginChecked, false),
  add("klee_end_checked", handleEndChecked, false),
  add("klee_memcmp", handleMemCmp, true),
#endif
/**************************************/
  add("malloc", handleMalloc, true),
  add("realloc", handleRealloc, true),
  // operator delete[](void*)
  add("_ZdaPv", handleDeleteArray, false),
  // operator delete(void*)
  add("_ZdlPv", handleDelete, false),

  // operator new[](unsigned int)
  add("_Znaj", handleNewArray, true),
  // operator new(unsigned int)
  add("_Znwj", handleNew, true),

  // FIXME-64: This is wrong for 64-bit long...

  // operator new[](unsigned long)
  add("_Znam", handleNewArray, true),
  // operator new(unsigned long)
  add("_Znwm", handleNew, true),

  // clang -fsanitize=unsigned-integer-overflow
  add("__ubsan_handle_add_overflow", handleAddOverflow, false),
  add("__ubsan_handle_sub_overflow", handleSubOverflow, false),
  add("__ubsan_handle_mul_overflow", handleMulOverflow, false),
  add("__ubsan_handle_divrem_overflow", handleDivRemOverflow, false),

#undef addDNR
#undef add  
};

SpecialFunctionHandler::const_iterator SpecialFunctionHandler::begin() {
  return SpecialFunctionHandler::const_iterator(handlerInfo);
}

SpecialFunctionHandler::const_iterator SpecialFunctionHandler::end() {
  // NULL pointer is sentinel
  return SpecialFunctionHandler::const_iterator(0);
}

SpecialFunctionHandler::const_iterator& SpecialFunctionHandler::const_iterator::operator++() {
  ++index;
  if ( index >= SpecialFunctionHandler::size())
  {
    // Out of range, return .end()
    base=0; // Sentinel
    index=0;
  }

  return *this;
}

int SpecialFunctionHandler::size() {
	return sizeof(handlerInfo)/sizeof(handlerInfo[0]);
}

SpecialFunctionHandler::SpecialFunctionHandler(Executor &_executor) 
  : executor(_executor) {}


void SpecialFunctionHandler::prepare() {
  unsigned N = size();

  for (unsigned i=0; i<N; ++i) {
    HandlerInfo &hi = handlerInfo[i];
    Function *f = executor.kmodule->module->getFunction(hi.name);
    
    // No need to create if the function doesn't exist, since it cannot
    // be called in that case.
  
    if (f && (!hi.doNotOverride || f->isDeclaration())) {
      // Make sure NoReturn attribute is set, for optimization and
      // coverage counting.
      if (hi.doesNotReturn)
#if LLVM_VERSION_CODE >= LLVM_VERSION(3, 3)
        f->addFnAttr(Attribute::NoReturn);
#elif LLVM_VERSION_CODE >= LLVM_VERSION(3, 2)
        f->addFnAttr(Attributes::NoReturn);
#else
        f->addFnAttr(Attribute::NoReturn);
#endif

      // Change to a declaration since we handle internally (simplifies
      // module and allows deleting dead code).
      if (!f->isDeclaration())
        f->deleteBody();
    }
  }
}

void SpecialFunctionHandler::bind() {
  unsigned N = sizeof(handlerInfo)/sizeof(handlerInfo[0]);

  for (unsigned i=0; i<N; ++i) {
    HandlerInfo &hi = handlerInfo[i];
    Function *f = executor.kmodule->module->getFunction(hi.name);
    
    if (f && (!hi.doNotOverride || f->isDeclaration()))
      handlers[f] = std::make_pair(hi.handler, hi.hasReturnValue);
  }
}


bool SpecialFunctionHandler::handle(ExecutionState &state, 
                                    Function *f,
                                    KInstruction *target,
                                    std::vector< ref<Expr> > &arguments) {
  handlers_ty::iterator it = handlers.find(f);
  if (it != handlers.end()) {    
    Handler h = it->second.first;
    bool hasReturnValue = it->second.second;
     // FIXME: Check this... add test?
    if (!hasReturnValue && !target->inst->use_empty()) {
      executor.terminateStateOnExecError(state, 
                                         "expected return value from void special function");
    } else {
      (this->*h)(state, target, arguments);
    }
    return true;
  } else {
    return false;
  }
}

/****/

// reads a concrete string from memory
std::string 
SpecialFunctionHandler::readStringAtAddress(ExecutionState &state, 
                                            ref<Expr> addressExpr) {
  ObjectPair op;
  addressExpr = executor.toUnique(state, addressExpr);
  ref<ConstantExpr> address = cast<ConstantExpr>(addressExpr);
  if (!state.addressSpace.resolveOne(address, op))
    assert(0 && "XXX out of bounds / multiple resolution unhandled");
  bool res __attribute__ ((unused));
  assert(executor.solver->mustBeTrue(state, 
                                     EqExpr::create(address, 
                                                    op.first->getBaseExpr()),
                                     res) &&
         res &&
         "XXX interior pointer unhandled");
  const MemoryObject *mo = op.first;
  const ObjectState *os = op.second;

  char *buf = new char[mo->size];

  unsigned i;
  for (i = 0; i < mo->size - 1; i++) {
    ref<Expr> cur = os->read8(i);
    cur = executor.toUnique(state, cur);
    assert(isa<ConstantExpr>(cur) && 
           "hit symbolic char while reading concrete string");
    buf[i] = cast<ConstantExpr>(cur)->getZExtValue(8);
  }
  buf[i] = 0;
  
  std::string result(buf);
  delete[] buf;
  return result;
}

/****/

void SpecialFunctionHandler::handleAbort(ExecutionState &state,
                           KInstruction *target,
                           std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==0 && "invalid number of arguments to abort");
  executor.terminateStateOnError(state, "abort failure", "abort.err");
}

void SpecialFunctionHandler::handleExit(ExecutionState &state,
                           KInstruction *target,
                           std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==1 && "invalid number of arguments to exit");
  executor.terminateStateOnExit(state);
}

void SpecialFunctionHandler::handleSilentExit(ExecutionState &state,
                                              KInstruction *target,
                                              std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==1 && "invalid number of arguments to exit");
  executor.terminateState(state);
}

void SpecialFunctionHandler::handleAliasFunction(ExecutionState &state,
						 KInstruction *target,
						 std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==2 && 
         "invalid number of arguments to klee_alias_function");
  std::string old_fn = readStringAtAddress(state, arguments[0]);
  std::string new_fn = readStringAtAddress(state, arguments[1]);
  KLEE_DEBUG_WITH_TYPE("alias_handling", llvm::errs() << "Replacing " << old_fn
                                           << "() with " << new_fn << "()\n");
  if (old_fn == new_fn)
    state.removeFnAlias(old_fn);
  else state.addFnAlias(old_fn, new_fn);
}

void SpecialFunctionHandler::handleAssert(ExecutionState &state,
                                          KInstruction *target,
                                          std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==3 && "invalid number of arguments to _assert");  
  executor.terminateStateOnError(state,
				 "ASSERTION FAIL: " + readStringAtAddress(state, arguments[0]),
				 "assert.err");
}

void SpecialFunctionHandler::handleAssertFail(ExecutionState &state,
                                              KInstruction *target,
                                              std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==4 && "invalid number of arguments to __assert_fail");
  executor.terminateStateOnError(state,
				 "ASSERTION FAIL: " + readStringAtAddress(state, arguments[0]),
				 "assert.err");
}

void SpecialFunctionHandler::handleReportError(ExecutionState &state,
                                               KInstruction *target,
                                               std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==4 && "invalid number of arguments to klee_report_error");
  
  // arguments[0], arguments[1] are file, line
  executor.terminateStateOnError(state,
				 readStringAtAddress(state, arguments[2]),
				 readStringAtAddress(state, arguments[3]).c_str());
}

void SpecialFunctionHandler::handleMerge(ExecutionState &state,
                           KInstruction *target,
                           std::vector<ref<Expr> > &arguments) {
  // nop
}

void SpecialFunctionHandler::handleNew(ExecutionState &state,
                         KInstruction *target,
                         std::vector<ref<Expr> > &arguments) {
  // XXX should type check args
  assert(arguments.size()==1 && "invalid number of arguments to new");

  executor.executeAlloc(state, arguments[0], false, target);
}

void SpecialFunctionHandler::handleDelete(ExecutionState &state,
                            KInstruction *target,
                            std::vector<ref<Expr> > &arguments) {
  // FIXME: Should check proper pairing with allocation type (malloc/free,
  // new/delete, new[]/delete[]).

  // XXX should type check args
  assert(arguments.size()==1 && "invalid number of arguments to delete");
  executor.executeFree(state, arguments[0]);
}

void SpecialFunctionHandler::handleNewArray(ExecutionState &state,
                              KInstruction *target,
                              std::vector<ref<Expr> > &arguments) {
  // XXX should type check args
  assert(arguments.size()==1 && "invalid number of arguments to new[]");
  executor.executeAlloc(state, arguments[0], false, target);
}

void SpecialFunctionHandler::handleDeleteArray(ExecutionState &state,
                                 KInstruction *target,
                                 std::vector<ref<Expr> > &arguments) {
  // XXX should type check args
  assert(arguments.size()==1 && "invalid number of arguments to delete[]");
  executor.executeFree(state, arguments[0]);
}

void SpecialFunctionHandler::handleMalloc(ExecutionState &state,
                                  KInstruction *target,
                                  std::vector<ref<Expr> > &arguments) {
  // XXX should type check args
  klee_warning("size=%d",arguments.size());
  //assert(arguments.size()==1 && "invalid number of arguments to malloc");
  executor.executeAlloc(state, arguments[0], false, target);
}
void SpecialFunctionHandler::handleAssume(ExecutionState &state,
                            KInstruction *target,
                            std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==1 && "invalid number of arguments to klee_assume");
  
  ref<Expr> e = arguments[0];
  
  if (e->getWidth() != Expr::Bool)
    e = NeExpr::create(e, ConstantExpr::create(0, e->getWidth()));
  
  bool res;
  bool success __attribute__ ((unused)) = executor.solver->mustBeFalse(state, e, res);
  assert(success && "FIXME: Unhandled solver failure");
  if (res) {
    if (SilentKleeAssume) {
      executor.terminateState(state);
    } else {
      executor.terminateStateOnError(state,
                                     "invalid klee_assume call (provably false)",
                                     "user.err");
    }
  } else {
    executor.addConstraint(state, e);
  }
}

void SpecialFunctionHandler::handleIsSymbolic(ExecutionState &state,
                                KInstruction *target,
                                std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==1 && "invalid number of arguments to klee_is_symbolic");

  executor.bindLocal(target, state, 
                     ConstantExpr::create(!isa<ConstantExpr>(arguments[0]),
                                          Expr::Int32));
}

void SpecialFunctionHandler::handlePreferCex(ExecutionState &state,
                                             KInstruction *target,
                                             std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==2 &&
         "invalid number of arguments to klee_prefex_cex");

  ref<Expr> cond = arguments[1];
  if (cond->getWidth() != Expr::Bool)
    cond = NeExpr::create(cond, ConstantExpr::alloc(0, cond->getWidth()));

  Executor::ExactResolutionList rl;
  executor.resolveExact(state, arguments[0], rl, "prefex_cex");
  
  assert(rl.size() == 1 &&
         "prefer_cex target must resolve to precisely one object");

  rl[0].first.first->cexPreferences.push_back(cond);
}

void SpecialFunctionHandler::handlePosixPreferCex(ExecutionState &state,
                                             KInstruction *target,
                                             std::vector<ref<Expr> > &arguments) {
  if (ReadablePosix)
    return handlePreferCex(state, target, arguments);
}

void SpecialFunctionHandler::handlePrintExpr(ExecutionState &state,
                                  KInstruction *target,
                                  std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==2 &&
         "invalid number of arguments to klee_print_expr");

  std::string msg_str = readStringAtAddress(state, arguments[0]);
  llvm::errs() << msg_str << ":" << arguments[1] << "\n";
  //executor.printObservable(msg_str,arguments[1]);
}

void SpecialFunctionHandler::handleSetForking(ExecutionState &state,
                                              KInstruction *target,
                                              std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==1 &&
         "invalid number of arguments to klee_set_forking");
  ref<Expr> value = executor.toUnique(state, arguments[0]);
  
  if (ConstantExpr *CE = dyn_cast<ConstantExpr>(value)) {
    state.forkDisabled = CE->isZero();
  } else {
    executor.terminateStateOnError(state, 
                                   "klee_set_forking requires a constant arg",
                                   "user.err");
  }
}

void SpecialFunctionHandler::handleStackTrace(ExecutionState &state,
                                              KInstruction *target,
                                              std::vector<ref<Expr> > &arguments) {
  state.dumpStack(outs());
}

void SpecialFunctionHandler::handleDebug(ExecutionState &state,
			                                           KInstruction *target,
													                                              std::vector<ref<Expr> > &arguments) {
	  assert(arguments.size() >= 1 && "invalid number of arguments to klee_debug");

	    std::string formatStr = readStringAtAddress(state, arguments[0]);
		 if (arguments.size() == 2 && arguments[1]->getWidth() == sizeof(long)*8) {
			  std::string paramStr = readStringAtAddress(state, arguments[1]);

			      fprintf(stderr, formatStr.c_str(), paramStr.c_str());
				      return;
					    }

		   std::vector<int> args;

		     for (unsigned int i = 1; i < arguments.size(); i++) {
				     if (!isa<ConstantExpr>(arguments[i])) {
						       fprintf(stderr, "%s: %s\n", formatStr.c_str(), "<nonconst args>");
							         return;
									     }

					     ref<ConstantExpr> arg = cast<ConstantExpr>(arguments[i]);

						     if (arg->getWidth() != sizeof(int)*8) {
								       fprintf(stderr, "%s: %s\n", formatStr.c_str(), "<non-32-bit args>");
									         return;
											     }

							     args.push_back((int)arg->getZExtValue());
								   }
			 switch (args.size()) {
				   case 0:
					       fprintf(stderr, "%s", formatStr.c_str());
						       break;
							     case 1:
							       fprintf(stderr, formatStr.c_str(), args[0]);
								       break;
									     case 2:
									       fprintf(stderr, formatStr.c_str(), args[0], args[1]);
										       break;
											     case 3:
											       fprintf(stderr, formatStr.c_str(), args[0], args[1], args[2]);
												       break;
													     default:
													       executor.terminateStateOnError(state, "klee_debug allows up to 3 arguments", "user.err");
														       return;
															     }
}
void SpecialFunctionHandler::handleWarning(ExecutionState &state,
                                           KInstruction *target,
                                           std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==1 && "invalid number of arguments to klee_warning");

  std::string msg_str = readStringAtAddress(state, arguments[0]);
#if MULTITHREAD
  klee_warning("%s: %s", state.stack().back().kf->function->getName().data(), 
			            		                 msg_str.c_str());
#else
  klee_warning("%s: %s", state.stack.back().kf->function->getName().data(), 
               msg_str.c_str());
#endif
}

void SpecialFunctionHandler::handleWarningOnce(ExecutionState &state,
                                               KInstruction *target,
                                               std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==1 &&
         "invalid number of arguments to klee_warning_once");

  std::string msg_str = readStringAtAddress(state, arguments[0]);
#if MULTITHREAD
  klee_warning_once(0, "%s: %s", state.stack().back().kf->function->getName().data(),
#else
  klee_warning_once(0, "%s: %s", state.stack.back().kf->function->getName().data(),
#endif
	  msg_str.c_str());
}

void SpecialFunctionHandler::handlePrintRange(ExecutionState &state,
                                  KInstruction *target,
                                  std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==2 &&
         "invalid number of arguments to klee_print_range");

  std::string msg_str = readStringAtAddress(state, arguments[0]);
  llvm::errs() << msg_str << ":" << arguments[1];
  if (!isa<ConstantExpr>(arguments[1])) {
    // FIXME: Pull into a unique value method?
    ref<ConstantExpr> value;
    bool success __attribute__ ((unused)) = executor.solver->getValue(state, arguments[1], value);
    assert(success && "FIXME: Unhandled solver failure");
    bool res;
    success = executor.solver->mustBeTrue(state, 
                                          EqExpr::create(arguments[1], value), 
                                          res);
    assert(success && "FIXME: Unhandled solver failure");
    if (res) {
      llvm::errs() << " == " << value;
    } else { 
      llvm::errs() << " ~= " << value;
      std::pair< ref<Expr>, ref<Expr> > res =
        executor.solver->getRange(state, arguments[1]);
      llvm::errs() << " (in [" << res.first << ", " << res.second <<"])";
    }
  }
  llvm::errs() << "\n";
}

void SpecialFunctionHandler::handleGetObjSize(ExecutionState &state,
                                  KInstruction *target,
                                  std::vector<ref<Expr> > &arguments) {
  // XXX should type check args
  assert(arguments.size()==1 &&
         "invalid number of arguments to klee_get_obj_size");
  Executor::ExactResolutionList rl;
  executor.resolveExact(state, arguments[0], rl, "klee_get_obj_size");
  for (Executor::ExactResolutionList::iterator it = rl.begin(), 
         ie = rl.end(); it != ie; ++it) {
    executor.bindLocal(target, *it->second, 
                       ConstantExpr::create(it->first.first->size, Expr::Int32));
  }
}

void SpecialFunctionHandler::handleGetErrno(ExecutionState &state,
                                            KInstruction *target,
                                            std::vector<ref<Expr> > &arguments) {
  // XXX should type check args
  assert(arguments.size()==0 &&
         "invalid number of arguments to klee_get_errno");
  executor.bindLocal(target, state,
                     ConstantExpr::create(errno, Expr::Int32));
}

void SpecialFunctionHandler::handleCalloc(ExecutionState &state,
                            KInstruction *target,
                            std::vector<ref<Expr> > &arguments) {
  // XXX should type check args
  assert(arguments.size()==2 &&
         "invalid number of arguments to calloc");

  ref<Expr> size = MulExpr::create(arguments[0],
                                   arguments[1]);
  executor.executeAlloc(state, size, false, target, true);
}

void SpecialFunctionHandler::handleRealloc(ExecutionState &state,
                            KInstruction *target,
                            std::vector<ref<Expr> > &arguments) {
  // XXX should type check args
  assert(arguments.size()==2 &&
         "invalid number of arguments to realloc");
  ref<Expr> address = arguments[0];
  ref<Expr> size = arguments[1];

  Executor::StatePair zeroSize = executor.fork(state, 
                                               Expr::createIsZero(size), 
                                               true);
  
  if (zeroSize.first) { // size == 0
    executor.executeFree(*zeroSize.first, address, target);   
  }
  if (zeroSize.second) { // size != 0
    Executor::StatePair zeroPointer = executor.fork(*zeroSize.second, 
                                                    Expr::createIsZero(address), 
                                                    true);
    
    if (zeroPointer.first) { // address == 0
      executor.executeAlloc(*zeroPointer.first, size, false, target);
    } 
    if (zeroPointer.second) { // address != 0
      Executor::ExactResolutionList rl;
      executor.resolveExact(*zeroPointer.second, address, rl, "realloc");
      
      for (Executor::ExactResolutionList::iterator it = rl.begin(), 
             ie = rl.end(); it != ie; ++it) {
        executor.executeAlloc(*it->second, size, false, target, false, 
                              it->first.second);
      }
    }
  }
}

void SpecialFunctionHandler::handleFree(ExecutionState &state,
                          KInstruction *target,
                          std::vector<ref<Expr> > &arguments) {
  // XXX should type check args
  assert(arguments.size()==1 &&
         "invalid number of arguments to free");
  executor.executeFree(state, arguments[0]);
}

void SpecialFunctionHandler::handleCheckMemoryAccess(ExecutionState &state,
                                                     KInstruction *target,
                                                     std::vector<ref<Expr> > 
                                                       &arguments) {
  assert(arguments.size()==2 &&
         "invalid number of arguments to klee_check_memory_access");

  ref<Expr> address = executor.toUnique(state, arguments[0]);
  ref<Expr> size = executor.toUnique(state, arguments[1]);
  if (!isa<ConstantExpr>(address) || !isa<ConstantExpr>(size)) {
    executor.terminateStateOnError(state, 
                                   "check_memory_access requires constant args",
                                   "user.err");
  } else {
    ObjectPair op;

    if (!state.addressSpace.resolveOne(cast<ConstantExpr>(address), op)) {
      executor.terminateStateOnError(state,
                                     "check_memory_access: memory error",
                                     "ptr.err",
                                     executor.getAddressInfo(state, address));
    } else {
      ref<Expr> chk = 
        op.first->getBoundsCheckPointer(address, 
                                        cast<ConstantExpr>(size)->getZExtValue());
      if (!chk->isTrue()) {
        executor.terminateStateOnError(state,
                                       "check_memory_access: memory error",
                                       "ptr.err",
                                       executor.getAddressInfo(state, address));
      }
    }
  }
}

void SpecialFunctionHandler::handleGetValue(ExecutionState &state,
                                            KInstruction *target,
                                            std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==1 &&
         "invalid number of arguments to klee_get_value");

  executor.executeGetValue(state, arguments[0], target);
}

void SpecialFunctionHandler::handleDefineFixedObject(ExecutionState &state,
                                                     KInstruction *target,
                                                     std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==2 &&
         "invalid number of arguments to klee_define_fixed_object");
  assert(isa<ConstantExpr>(arguments[0]) &&
         "expect constant address argument to klee_define_fixed_object");
  assert(isa<ConstantExpr>(arguments[1]) &&
         "expect constant size argument to klee_define_fixed_object");
  
  uint64_t address = cast<ConstantExpr>(arguments[0])->getZExtValue();
  uint64_t size = cast<ConstantExpr>(arguments[1])->getZExtValue();
#if MULTITHREAD
  MemoryObject *mo = executor.memory->allocateFixed(address, size, state.prevPC()->inst);
#else
  MemoryObject *mo = executor.memory->allocateFixed(address, size, state.prevPC->inst);
#endif
  executor.bindObjectInState(state, mo, false);
  mo->isUserSpecified = true; // XXX hack;
}
void SpecialFunctionHandler::handleMakeType(SymbolType type,ExecutionState &state,
                                                KInstruction *target,
                                                std::vector<ref<Expr> > &arguments) {
  std::string name;
  // FIXME: For backwards compatibility, we should eventually enforce the
  // correct arguments.
  if (arguments.size() == 2) {
    name = "unnamed";
  } else {
    // FIXME: Should be a user.err, not an assert.
	  assert(arguments.size()==3 &&
				  "invalid number of arguments to klee_make_secret");  
	  name = readStringAtAddress(state, arguments[2]);
  }
  std::cout<<"type"<<type<<name;
  Executor::ExactResolutionList rl;
  executor.resolveExact(state, arguments[0], rl, "make_secret");

  for (Executor::ExactResolutionList::iterator it = rl.begin(), 
			  ie = rl.end(); it != ie; ++it) {
	  const MemoryObject *mo = it->first.first;
	  mo->setName(name);
	  mo->setType(type); 
	  const ObjectState *old = it->first.second;
	  ExecutionState *s = it->second;
	  // FIXME: Type coercion should be done consistently somewhere.
	  bool res;
	  bool success __attribute__ ((unused)) =
		  executor.solver->mustBeTrue(*s, 
					  EqExpr::create(ZExtExpr::create(arguments[1],
							  Context::get().getPointerWidth()),
						  mo->getSizeExpr()),
					  res);
	  assert(success && "FIXME: Unhandled solver failure");

	  if (res) {
		  executor.executeMakeSymbolic(*s, mo, name);
	  } else {      
		  executor.terminateStateOnError(*s, 
					  "wrong size given to klee_make_secret[_name]", 
					  "user.err");
	  }
  }
}
void  SpecialFunctionHandler::handleMakeSecret(ExecutionState &state,
                                                KInstruction *target,
                                                std::vector<ref<Expr> > &arguments) {
	handleMakeType(TYPE_SECRET,state,target,arguments);
}
void SpecialFunctionHandler::handleMakeObservable(ExecutionState &state,
                                                KInstruction *target,
                                                std::vector<ref<Expr> > &arguments) {
 assert(arguments.size()==2 &&
           "invalid number of arguments to klee_make_observable");
 std::string name=readStringAtAddress(state,arguments[0]);
state.pushOb(name,arguments[1]);
//llvm::raw_ostream *f = executor.interpreterHandler->openTestFile("ob", executor.interpreterHandler->getNumTestCases());
//klee_warning("observable=%d",state.observables.size());
//*f<<name<<" :"<<arguments[1]<<"\n";
//delete f;
}
void  SpecialFunctionHandler::handleMakeAttackerO(ExecutionState &state,
                                                KInstruction *target,
                                                std::vector<ref<Expr> > &arguments) {
	handleMakeType(TYPE_ATTACKER_O,state,target,arguments);
}
void  SpecialFunctionHandler::handleMakeAttackerC(ExecutionState &state,
                                                KInstruction *target,
                                                std::vector<ref<Expr> > &arguments) {
	handleMakeType(TYPE_ATTACKER_C,state,target,arguments);
}
void SpecialFunctionHandler::handleMakeShared(ExecutionState &state,
			KInstruction *target,
                                                std::vector<ref<Expr> > &arguments) {
  std::string name;

  // FIXME: For backwards compatibility, we should eventually enforce the
  // correct arguments.
  if (arguments.size() == 2) {
	  name = "unnamed";
  } else {
	  // FIXME: Should be a user.err, not an assert.
	  assert(arguments.size()==3 &&
				  "invalid number of arguments to klee_make_shared");  
  }

  Executor::ExactResolutionList rl;
  executor.resolveExact(state, arguments[0], rl, "make_shared");
  for (Executor::ExactResolutionList::iterator it = rl.begin(), 
			  ie = rl.end(); it != ie; ++it) {
	  const MemoryObject *mo = it->first.first;
	  mo->setName(name);
	  const ObjectState *os = it->first.second;
	  ExecutionState *s = it->second;

	  if (mo->isLocal) {
		  executor.terminateStateOnError(*s, 
					  "cannot make share local object ", 
					  "user.err");
		  return;
	  }
	  //ObjectState *newOS = state.addressSpace.getWriteable(mo, os);
	  //mo->isGlobal = true;
	  // Now bind this object in the other address spaces
  }
}
#if MULTITHREAD
void SpecialFunctionHandler::handleThreadCreate(ExecutionState &state,
                                                KInstruction *target,
                                                std::vector<ref<Expr> > &arguments) {
  assert(arguments.size() == 3 && "invalid number of arguments to klee_thread_create");

  ref<Expr> tid = executor.toUnique(state, arguments[0]);

  if (!isa<ConstantExpr>(tid)) {
    executor.terminateStateOnError(state, "klee_thread_create", "user.err");
    return;
  }

  executor.executeThreadCreate(state, cast<ConstantExpr>(tid)->getZExtValue(),
                               arguments[1], arguments[2]);
}

void SpecialFunctionHandler::handleThreadTerminate(ExecutionState &state,
                                                   KInstruction *target,
                                                   std::vector<ref<Expr> > &arguments) {
  assert(arguments.empty() && "invalid number of arguments to klee_thread_terminate");

  executor.executeThreadExit(state);
}

void SpecialFunctionHandler::handleThreadPreempt(ExecutionState &state,
                                                 KInstruction *target,
                                                 std::vector<ref<Expr> > &arguments) {
  assert(arguments.size() == 1 && "invalid number of arguments to klee_thread_preempt");

  if (!isa<ConstantExpr>(arguments[0])) {
    executor.terminateStateOnError(state, "klee_thread_preempt", "user.err");
  }

  executor.schedule(state, !arguments[0]->isZero(), false);
}

void SpecialFunctionHandler::handleThreadSleep(ExecutionState &state,
                                               KInstruction *target,
                                               std::vector<ref<Expr> > &arguments) {

  assert(arguments.size() == 1 && "invalid number of arguments to klee_thread_sleep");

  ref<Expr> wlistExpr = executor.toUnique(state, arguments[0]);

  if (!isa<ConstantExpr>(wlistExpr)) {
    executor.terminateStateOnError(state, "klee_thread_sleep", "user.err");
    return;
  }

  state.sleepThread(cast<ConstantExpr>(wlistExpr)->getZExtValue());
  executor.schedule(state, false, false);
}

void SpecialFunctionHandler::handleThreadNotify(ExecutionState &state,
                                                KInstruction *target,
                                                std::vector<ref<Expr> > &arguments) {
  assert(arguments.size() == 2 && "invalid number of arguments to klee_thread_notify");

  ref<Expr> wlist = executor.toUnique(state, arguments[0]);
  ref<Expr> all = executor.toUnique(state, arguments[1]);

  if (!isa<ConstantExpr>(wlist) || !isa<ConstantExpr>(all)) {
    executor.terminateStateOnError(state, "klee_thread_notify", "user.err");
    return;
  }

  if (all->isZero()) {
    executor.executeThreadNotifyOne(state, cast<ConstantExpr>(wlist)->getZExtValue());
  } else {
    // It's simple enough such that it can be handled by the state class itself
    state.notifyAll(cast<ConstantExpr>(wlist)->getZExtValue());
  }
}

void SpecialFunctionHandler::handleGetTime(ExecutionState &state,
                                           KInstruction *target,
                                           std::vector<ref<Expr> > &arguments) {
  assert(arguments.empty() && "invalid number of arguments to klee_get_time");
/*
  executor.bindLocal(target, state, ConstantExpr::create(state.stateTime,
                     executor.getWidthForLLVMType(target->inst->getType())));
*/
					}

void SpecialFunctionHandler::handleSetTime(ExecutionState &state,
                                           KInstruction *target,
                                           std::vector<ref<Expr> > &arguments) {
  assert(arguments.size() == 1 && "invalid number of arguments to klee_set_time");
/*
  if (!isa<ConstantExpr>(arguments[0])) {
    executor.terminateStateOnError(state, "klee_set_time requires a constant argument", "user.err");
    return;
  }

  state.stateTime = cast<ConstantExpr>(arguments[0])->getZExtValue();
*/
  }


void SpecialFunctionHandler::handleGetWList(ExecutionState &state,
                                            KInstruction *target,
                                            std::vector<ref<Expr> > &arguments) {
  assert(arguments.empty() && "invalid number of arguments to klee_get_wlist");

  Thread::wlist_id_t id = state.getWaitingList();

  executor.bindLocal(target, state, ConstantExpr::create(id,
                     executor.getWidthForLLVMType(target->inst->getType())));
}

void SpecialFunctionHandler::handleGetContext(ExecutionState &state,
                                              KInstruction *target,
                                              std::vector<ref<Expr> > &arguments) {
  assert(arguments.size() == 1 && "invalid number of arguments to klee_get_context");

  ref<Expr> tidAddr = executor.toUnique(state, arguments[0]);

  if (!isa<ConstantExpr>(tidAddr)) {
    executor.terminateStateOnError(state, "klee_get_context requires constant args",
                                   "user.err");
    return;
  }

  if (!tidAddr->isZero()) {
    if (!writeConcreteValue(state, tidAddr, state.crtThread().getTid(),
         executor.getWidthForLLVMType(Type::getInt64Ty(getGlobalContext()))))
      return;
  }
}

bool SpecialFunctionHandler::writeConcreteValue(ExecutionState &state,
                                                ref<Expr> address, uint64_t value,
                                                Expr::Width width) {
  ObjectPair op;

  if (!state.addressSpace.resolveOne(cast<ConstantExpr>(address), op)) {
    executor.terminateStateOnError(state, "invalid pointer for writing concrete value into", "user.err");
    return false;
  }

  ObjectState *os = state.addressSpace.getWriteable(op.first, op.second);
  os->write(op.first->getOffsetExpr(address), ConstantExpr::create(value, width));

  return true;
}
#endif
#if EXTERNAL_SUPPORT

void SpecialFunctionHandler::handleGetWList(ExecutionState &state,
			KInstruction *target,
			std::vector<ref<Expr> > &arguments) {
	assert(arguments.empty() && "invalid number of arguments to klee_get_wlist");
	wlist_id_t id = state.getWaitingList();
	executor.bindLocal(target, state, ConstantExpr::create(id,
					executor.getWidthForLLVMType(target->inst->getType())));
}

void SpecialFunctionHandler::handleThreadPreempt(ExecutionState &state,
			                    KInstruction *target,
								                    std::vector<ref<Expr> > &arguments) {
	  assert(arguments.size() == 1 && "invalid number of arguments to klee_thread_preempt");

	    if (!isa<ConstantExpr>(arguments[0])) {
			    executor.terminateStateOnError(state, "klee_thread_preempt", "user.err");
				  }

		  executor.schedule(state, !arguments[0]->isZero());
}
void SpecialFunctionHandler::handleThreadSleep(ExecutionState &state,
			                    KInstruction *target,
								                    std::vector<ref<Expr> > &arguments) {

	  assert(arguments.size() == 1 && "invalid number of arguments to klee_thread_sleep");

	    ref<Expr> wlistExpr = executor.toUnique(state, arguments[0]);

		  if (!isa<ConstantExpr>(wlistExpr)) {
			      executor.terminateStateOnError(state, "klee_thread_sleep", "user.err");
				      return;
					    }

		  state.sleepThread(cast<ConstantExpr>(wlistExpr)->getZExtValue());
		  executor.schedule(state, false);
}
void SpecialFunctionHandler::handleThreadNotify(ExecutionState &state,
			KInstruction *target,
			std::vector<ref<Expr> > &arguments) {
	assert(arguments.size() == 2 && "invalid number of arguments to klee_thread_notify");

	ref<Expr> wlist = executor.toUnique(state, arguments[0]);
	ref<Expr> all = executor.toUnique(state, arguments[1]);

	if (!isa<ConstantExpr>(wlist) || !isa<ConstantExpr>(all)) {
		executor.terminateStateOnError(state, "klee_thread_notify", "user.err");
		return;
	}

	if (all->isZero()) {
		executor.executeThreadNotifyOne(state, cast<ConstantExpr>(wlist)->getZExtValue());
	} else {
		// It's simple enough such that it can be handled by the state class itself
		state.notifyAll(cast<ConstantExpr>(wlist)->getZExtValue());
	}
}
#endif 
void SpecialFunctionHandler::handleMakeSymbolic(ExecutionState &state,
			KInstruction *target,
                                                std::vector<ref<Expr> > &arguments) {
  std::string name;

  // FIXME: For backwards compatibility, we should eventually enforce the
  // correct arguments.
  if (arguments.size() == 2) {
    name = "unnamed";
  } else {
    // FIXME: Should be a user.err, not an assert.
    assert(arguments.size()==3 &&
           "invalid number of arguments to klee_make_symbolic");  
    name = readStringAtAddress(state, arguments[2]);
  }

  Executor::ExactResolutionList rl;
  executor.resolveExact(state, arguments[0], rl, "make_symbolic");
  
  for (Executor::ExactResolutionList::iterator it = rl.begin(), 
         ie = rl.end(); it != ie; ++it) {
    const MemoryObject *mo = it->first.first;
    mo->setName(name);
    
    const ObjectState *old = it->first.second;
    ExecutionState *s = it->second;
    
    if (old->readOnly) {
      executor.terminateStateOnError(*s, 
                                     "cannot make readonly object symbolic", 
                                     "user.err");
      return;
    } 

    // FIXME: Type coercion should be done consistently somewhere.
    bool res;
    bool success __attribute__ ((unused)) =
      executor.solver->mustBeTrue(*s, 
                                  EqExpr::create(ZExtExpr::create(arguments[1],
                                                                  Context::get().getPointerWidth()),
                                                 mo->getSizeExpr()),
                                  res);
    assert(success && "FIXME: Unhandled solver failure");
    
    if (res) {
      executor.executeMakeSymbolic(*s, mo, name);
    } else {      
      executor.terminateStateOnError(*s, 
                                     "wrong size given to klee_make_symbolic[_name]", 
                                     "user.err");
    }
  }
}

void SpecialFunctionHandler::handleMarkGlobal(ExecutionState &state,
                                              KInstruction *target,
                                              std::vector<ref<Expr> > &arguments) {
  assert(arguments.size()==1 &&
         "invalid number of arguments to klee_mark_global");  

  Executor::ExactResolutionList rl;
  executor.resolveExact(state, arguments[0], rl, "mark_global");
  
  for (Executor::ExactResolutionList::iterator it = rl.begin(), 
         ie = rl.end(); it != ie; ++it) {
    const MemoryObject *mo = it->first.first;
    assert(!mo->isLocal);
    mo->isGlobal = true;
  }
}

void SpecialFunctionHandler::handleAddOverflow(ExecutionState &state,
                                               KInstruction *target,
                                               std::vector<ref<Expr> > &arguments) {
  executor.terminateStateOnError(state,
                                 "overflow on unsigned addition",
                                 "overflow.err");
}

void SpecialFunctionHandler::handleSubOverflow(ExecutionState &state,
                                               KInstruction *target,
                                               std::vector<ref<Expr> > &arguments) {
  executor.terminateStateOnError(state,
                                 "overflow on unsigned subtraction",
                                 "overflow.err");
}

void SpecialFunctionHandler::handleMulOverflow(ExecutionState &state,
                                               KInstruction *target,
                                               std::vector<ref<Expr> > &arguments) {
  executor.terminateStateOnError(state,
                                 "overflow on unsigned multiplication",
                                 "overflow.err");
}

void SpecialFunctionHandler::handleDivRemOverflow(ExecutionState &state,
                                               KInstruction *target,
                                               std::vector<ref<Expr> > &arguments) {
  executor.terminateStateOnError(state,
                                 "overflow on division or remainder",
                                 "overflow.err");
}
