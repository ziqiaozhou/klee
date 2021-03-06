//===-- ExprPPrinter.cpp -   ----------------------------------------------===//
//
//                     The KLEE Symbolic Virtual Machine
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "klee/util/PrintContext.h"
#include "klee/util/ExprPPrinter.h"

#include "klee/Constraints.h"

#include "llvm/Support/CommandLine.h"
#include "llvm/Support/raw_ostream.h"

#include<iostream>
#include <map>
#include <vector>

using namespace klee;

namespace {
//  llvm::cl::opt<bool>
//  AvoidBindings("avoid-bindings", llvm::cl::init(false));

	llvm::cl::opt<bool>
  PCWidthAsArg("pc-width-as-arg", llvm::cl::init(true));

  llvm::cl::opt<bool>
  PCAllWidths("pc-all-widths", llvm::cl::init(false));

  llvm::cl::opt<bool>
  PCPrefixWidth("pc-prefix-width", llvm::cl::init(true));

  llvm::cl::opt<bool>
  PCMultibyteReads("pc-multibyte-reads", llvm::cl::init(true));

  llvm::cl::opt<bool>
  PCAllConstWidths("pc-all-const-widths",  llvm::cl::init(false));
}

class PPrinter : public ExprPPrinter {
public:
  std::set<const Array*> usedArrays;
 static unsigned counter;
  static unsigned updateCounter;

private:
  std::map<ref<Expr>, unsigned> bindings;
  std::map<const UpdateNode*, unsigned> updateBindings;
  std::set< ref<Expr> > couldPrint, shouldPrint;
  std::set<const UpdateNode*> couldPrintUpdates, shouldPrintUpdates;
  llvm::raw_ostream &os;
   bool hasScan;
  bool forceNoLineBreaks;
  std::string newline;

  /// shouldPrintWidth - Predicate for whether this expression should
  /// be printed with its width.
  bool shouldPrintWidth(ref<Expr> e) {
    if (PCAllWidths)
      return true;
    return e->getWidth() != Expr::Bool;
  }

  bool isVerySimple(const ref<Expr> &e) { 
    return isa<ConstantExpr>(e) || bindings.find(e)!=bindings.end();
  }

  bool isVerySimpleUpdate(const UpdateNode *un) {
    return !un || updateBindings.find(un)!=updateBindings.end();
  }


  // document me!
  bool isSimple(const ref<Expr> &e) { 
    if (isVerySimple(e)) {
      return true;
    } else if (const ReadExpr *re = dyn_cast<ReadExpr>(e)) {
      return isVerySimple(re->index) && isVerySimpleUpdate(re->updates.head);
    } else {
      Expr *ep = e.get();
      for (unsigned i=0; i<ep->getNumKids(); i++)
        if (!isVerySimple(ep->getKid(i)))
          return false;
      return true;
    }
  }

  bool hasSimpleKids(const Expr *ep) {
      for (unsigned i=0; i<ep->getNumKids(); i++)
        if (!isSimple(ep->getKid(i)))
          return false;
      return true;
  }
  
  void scanUpdate(const UpdateNode *un) {
    // FIXME: This needs to be non-recursive.
    if (un) {
      if (couldPrintUpdates.insert(un).second) {
        scanUpdate(un->next);
        scan1(un->index);
        scan1(un->value);
      } else {
        shouldPrintUpdates.insert(un);
      }
    }
  }
void printType(SymbolType type,PrintContext* PC){
  /*switch(type){
			  case TYPE_NATIVE:
				  *PC<<" others";
				  break;
			  case TYPE_SECRET:
				  *PC<<" secret";
				  break;
			  case TYPE_ATTACKER_O:
				  *PC<<" attacker observable";
				  break;
			  case TYPE_ATTACKER_C:
				  *PC<<" attacker controlled";
				  break;
		  }*/
}
  void scan1(const ref<Expr> &e) {
    if (!isa<ConstantExpr>(e)) {
      if (couldPrint.insert(e).second) {
        Expr *ep = e.get();
        for (unsigned i=0; i<ep->getNumKids(); i++)
          scan1(ep->getKid(i));
        if (const ReadExpr *re = dyn_cast<ReadExpr>(e)) {
          usedArrays.insert(re->updates.root);
          scanUpdate(re->updates.head);
        }
      } else {
        shouldPrint.insert(e);
      }
    }
  }

  void printUpdateList(const UpdateList &updates, PrintContext &PC) {
    const UpdateNode *head = updates.head;

    // Special case empty list.
    if (!head) {
      // FIXME: We need to do something (assert, mangle, etc.) so that printing
      // distinct arrays with the same name doesn't fail.
      PC << updates.root->name;
      return;
    }

    // FIXME: Explain this breaking policy.
    bool openedList = false, nextShouldBreak = false;
    unsigned outerIndent = PC.pos;
    unsigned middleIndent = 0;
    for (const UpdateNode *un = head; un; un = un->next) {      
      // We are done if we hit the cache.
      std::map<const UpdateNode*, unsigned>::iterator it = 
        updateBindings.find(un);
      if ((it!=updateBindings.end() )&& (!AvoidBindings)) {
        if (openedList)
          PC << "] @ ";
        PC << "U" << it->second;
        return;
      } else if ((!hasScan || shouldPrintUpdates.count(un)) && (!AvoidBindings)) {
        if (openedList)
          PC << "] @";
        if (un != head)
          PC.breakLine(outerIndent);
        PC << "U" << updateCounter << ":"; 
        updateBindings.insert(std::make_pair(un, updateCounter++));
        openedList = nextShouldBreak = false;
     }
    
      if (!openedList) {
        openedList = 1;
        PC << '[';
        middleIndent = PC.pos;
      } else {
        PC << ',';
        printSeparator(PC, !nextShouldBreak, middleIndent);
      }
      //PC << "(=";
      //unsigned innerIndent = PC.pos;
      print(un->index, PC);
      //printSeparator(PC, isSimple(un->index), innerIndent);
      PC << "=";
      print(un->value, PC);
      //PC << ')';
      
      nextShouldBreak = !(isa<ConstantExpr>(un->index) && 
                          isa<ConstantExpr>(un->value));
    }

    if (openedList)
      PC << ']';

    PC << " @ " << updates.root->name;
  }

  void printWidth(PrintContext &PC, ref<Expr> e) {
    if (!shouldPrintWidth(e))
      return;

    if (PCWidthAsArg) {
      PC << ' ';
      if (PCPrefixWidth)
        PC << 'w';
    }

    PC << e->getWidth();
  }

  
  bool isReadExprAtOffset(ref<Expr> e, const ReadExpr *base, ref<Expr> offset) {
    const ReadExpr *re = dyn_cast<ReadExpr>(e.get());
      
    // right now, all Reads are byte reads but some
    // transformations might change this
    if (!re || (re->getWidth() != Expr::Int8))
      return false;
      
    // Check if the index follows the stride. 
    // FIXME: How aggressive should this be simplified. The
    // canonicalizing builder is probably the right choice, but this
    // is yet another area where we would really prefer it to be
    // global or else use static methods.
    return SubExpr::create(re->index, base->index) == offset;
  }
  
  
  /// hasOrderedReads: \arg e must be a ConcatExpr, \arg stride must
  /// be 1 or -1.  
  ///
  /// If all children of this Concat are reads or concats of reads
  /// with consecutive offsets according to the given \arg stride, it
  /// returns the base ReadExpr according to \arg stride: first Read
  /// for 1 (MSB), last Read for -1 (LSB).  Otherwise, it returns
  /// null.
  const ReadExpr* hasOrderedReads(ref<Expr> e, int stride) {
    assert(e->getKind() == Expr::Concat);
    assert(stride == 1 || stride == -1);
    
    const ReadExpr *base = dyn_cast<ReadExpr>(e->getKid(0));
    
    // right now, all Reads are byte reads but some
    // transformations might change this
    if (!base || base->getWidth() != Expr::Int8)
      return NULL;
    
    // Get stride expr in proper index width.
    Expr::Width idxWidth = base->index->getWidth();
    ref<Expr> strideExpr = ConstantExpr::alloc(stride, idxWidth);
    ref<Expr> offset = ConstantExpr::create(0, idxWidth);
    
    e = e->getKid(1);
    
    // concat chains are unbalanced to the right
    while (e->getKind() == Expr::Concat) {
      offset = AddExpr::create(offset, strideExpr);
      if (!isReadExprAtOffset(e->getKid(0), base, offset))
	return NULL;
      
      e = e->getKid(1);
    }
    
    offset = AddExpr::create(offset, strideExpr);
    if (!isReadExprAtOffset(e, base, offset))
      return NULL;
    
    if (stride == -1)
      return cast<ReadExpr>(e.get());
    else return base;
  }

#if 0
  /// hasAllByteReads - True iff all children are byte level reads or
  /// concats of byte level reads.
  bool hasAllByteReads(const Expr *ep) {
    switch (ep->kind) {
      Expr::Read: {
	// right now, all Reads are byte reads but some
	// transformations might change this
	return ep->getWidth() == Expr::Int8;
      }
      Expr::Concat: {
	for (unsigned i=0; i<ep->getNumKids(); ++i) {
	  if (!hashAllByteReads(ep->getKid(i)))
	    return false;
	}
      }
    default: return false;
    }
  }
#endif

  void printRead(const ReadExpr *re, PrintContext &PC, unsigned indent) {
    print(re->index, PC);
    printSeparator(PC, isVerySimple(re->index), indent);
    printUpdateList(re->updates, PC);
  }

  void printExtract(const ExtractExpr *ee, PrintContext &PC, unsigned indent) {
    PC << ee->offset << ' ';
    print(ee->expr, PC);
  }

  void printExpr(const Expr *ep, PrintContext &PC, unsigned indent, bool printConstWidth=false) {
    bool simple = hasSimpleKids(ep);
    print(ep->getKid(0), PC,printConstWidth);
    for (unsigned i=1; i<ep->getNumKids(); i++) {
      printSeparator(PC, simple, indent);
      print(ep->getKid(i), PC, printConstWidth);
    }
  }

public:
  PPrinter(llvm::raw_ostream &_os) : os(_os), newline("\n") {
    reset();
  }

  void setNewline(const std::string &_newline) {
    newline = _newline;
  }

  void setForceNoLineBreaks(bool _forceNoLineBreaks) {
    forceNoLineBreaks = _forceNoLineBreaks;
  }

  void reset() {
    //counter = 0;
    //updateCounter = 0;
    hasScan = false;
    forceNoLineBreaks = false;
    bindings.clear();
    updateBindings.clear();
    couldPrint.clear();
    shouldPrint.clear();
    couldPrintUpdates.clear();
    shouldPrintUpdates.clear();
  }

  void scan(const ref<Expr> &e) {
    hasScan = true;
    scan1(e);
  }

  void print(const ref<Expr> &e, unsigned level=0) {
    PrintContext PC(os);
    PC.pos = level;
    print(e, PC);
  }

  void printConst(const ref<ConstantExpr> &e, PrintContext &PC, 
                  bool printWidth) {
    if (e->getWidth() == Expr::Bool)
      PC << (e->isTrue() ? "true" : "false");
    else {
      if (PCAllConstWidths)
	printWidth = true;
    
      if (printWidth)
	PC << "(w" << e->getWidth() << " ";

      if (e->getWidth() <= 64) {
        PC << e->getZExtValue();
      } else {
        std::string S;
        e->toString(S);
        PC << S;
      }

      if (printWidth)
	PC << ")";
    }    
  }

  void print(const ref<Expr> &e, PrintContext &PC, bool printConstWidth=false) {
    if (ConstantExpr *CE = dyn_cast<ConstantExpr>(e))
      printConst(CE, PC, printConstWidth);
    else {
      std::map<ref<Expr>, unsigned>::iterator it = bindings.find(e);
      if (it!=bindings.end() &&(!AvoidBindings)) {
        PC << 'N' << it->second;
      } else {
        if ((!hasScan || shouldPrint.count(e)) &&(!AvoidBindings)) {
          PC << 'N' << counter << ':';
          bindings.insert(std::make_pair(e, counter++));
        }

        // Detect multibyte reads.
        // FIXME: Hrm. One problem with doing this is that we are
        // masking the sharing of the indices which aren't
		// visible. Need to think if this matters... probably not
		// because if they are offset reads then its either constant,
		// or they are (base + offset) and base will get printed with
		// a declaration.
		if (PCMultibyteReads && e->getKind() == Expr::Concat) {
			const ReadExpr *base = hasOrderedReads(e, -1);
			int isLSB = (base != NULL);
			if (!isLSB)
			  base = hasOrderedReads(e, 1);
			if (base) {
				PC << "(Read" << (isLSB ? "LSB" : "MSB");
				printWidth(PC, e);
				PC << ' ';
				printRead(base, PC, PC.pos);
				printType(base->updates.root->type,&PC);
				PC << ')';
				return;
			}
		}

		PC << '(' << e->getKind();
		printWidth(PC, e);
		PC << ' ';

		// Indent at first argument and dispatch to appropriate print
		// routine for exprs which require special handling.
		unsigned indent = PC.pos;
		if (const ReadExpr *re = dyn_cast<ReadExpr>(e)) {
			printRead(re, PC, indent);
		} else if (const ExtractExpr *ee = dyn_cast<ExtractExpr>(e)) {
			printExtract(ee, PC, indent);
		} else if (e->getKind() == Expr::Concat || e->getKind() == Expr::SExt)
		  printExpr(e.get(), PC, indent, true);
		else
		  printExpr(e.get(), PC, indent);	
		PC << ")";
	  }
	}
  }

/* Public utility functions */

void printSeparator(PrintContext &PC, bool simple, unsigned indent) {
	if (simple || forceNoLineBreaks) {
		PC << ' ';
    } else {
      PC.breakLine(indent);
    }
  }
};
unsigned PPrinter::counter=0;
unsigned PPrinter::updateCounter=0;

ExprPPrinter *klee::ExprPPrinter::create(llvm::raw_ostream &os) {
  return new PPrinter(os);
}

void ExprPPrinter::printOne(llvm::raw_ostream &os,
                            const char *message, 
                            const ref<Expr> &e) {
  PPrinter p(os);
  p.scan(e);

  // FIXME: Need to figure out what to do here. Probably print as a
  // "forward declaration" with whatever syntax we pick for that.
  PrintContext PC(os);
  PC << message << ": ";
  p.print(e, PC);
  PC.breakLine();
}

void ExprPPrinter::printSingleExpr(llvm::raw_ostream &os, const ref<Expr> &e) {
  PPrinter p(os);
  p.scan(e);
  // FIXME: Need to figure out what to do here. Probably print as a
  // "forward declaration" with whatever syntax we pick for that.
  //AvoidBindings=true;
  PrintContext PC(os);
  p.print(e, PC);
  //AvoidBindings=false;
}
 void ExprPPrinter::printAnalyzedConstraints(llvm::raw_ostream &os,
                                    const ConstraintManager &constraints) {
  printAnalyzedQuery(os, constraints, ConstantExpr::alloc(false, Expr::Bool));
}

void ExprPPrinter::printConstraints(llvm::raw_ostream &os,
                                    const ConstraintManager &constraints) {
  printQuery(os, constraints, ConstantExpr::alloc(false, Expr::Bool));
}

namespace {

struct ArrayPtrsByName {
  bool operator()(const Array *a1, const Array *a2) const {
    return a1->name < a2->name;
  }
};
}


ConstraintManager::ConstaintType ConstraintManager::getConstraintType(ref<Expr> exprp,unsigned _index){
	unsigned index=_index;
	int nKids=exprp->getNumKids();
	if(this->ExprBindings.count(exprp)){
		unsigned int re_index=this->ExprBindings[exprp];
		if(index==0){
			index=re_index;
			(this->TypeBindings[re_index])|=TYPE_NATIVE;
		}
		if(re_index!=index){
			for(ConstraintManager::ExprBindingIter  element= this->ExprBindings.begin();element!=this->ExprBindings.end();element++){  
				if(element->second==re_index){
					element->second=index; 
				}
			}
			this->TypeBindings[index]|=this->TypeBindings[re_index];   
		}
		return index;
	}
	if(nKids==1)
	{
		if(exprp->getKind()==Expr::Read){
			ReadExpr * re=cast<ReadExpr>(exprp);
			unsigned int re_index;
			if(re->updates.root->isSymbolicArray()){
				if(this->ExprBindings.count(re))
				{
					re_index=this->ExprBindings[exprp];
					if(index){
						if(index!=re_index){
							for(ConstraintManager::ExprBindingIter  element= this->ExprBindings.begin();element!=this->ExprBindings.end();element++){  
								if(element->second==re_index){
									element->second=index; 
								}
							}

							this->TypeBindings[index]|=this->TypeBindings[re_index];
						}
					}else
					{	index=re_index;
						this->TypeBindings[re_index]|=TYPE_NATIVE;
					}
				}else{
					unsigned re_index=this->TypeBindings.size()+1;
					this->TypeBindings.insert(std::pair<unsigned,ConstaintType>(re_index,re->type));
					this->ExprBindings.insert(std::pair<ref<Expr>,unsigned>(re,re_index));
				}
			}
		}
		return index;
	}
	else
	  for(int i=0;i<nKids;i++){
		  ref<Expr> subexprp=exprp->getKid(i);
		  index=getConstraintType(subexprp,index);
	  }
	return index;
}
void ExprPPrinter::printAnalyzedQuery(llvm::raw_ostream &os,
                              const ConstraintManager &constraints,
                              const ref<Expr> &q,
                              const ref<Expr> *evalExprsBegin,
                              const ref<Expr> *evalExprsEnd,
                              const Array * const *evalArraysBegin,
                              const Array * const *evalArraysEnd,
                              bool printArrayDecls) {

	PPrinter p(os);
  for (ConstraintManager::const_iterator it = constraints.begin(),
         ie = constraints.end(); it != ie; ++it)
    p.scan(*it);
  p.scan(q);

  for (const ref<Expr> *it = evalExprsBegin; it != evalExprsEnd; ++it)
    p.scan(*it);

  PrintContext PC(os);
  
  // Print array declarations.
  if (printArrayDecls) {
    for (const Array * const* it = evalArraysBegin; it != evalArraysEnd; ++it)
      p.usedArrays.insert(*it);
    std::vector<const Array *> sortedArray(p.usedArrays.begin(),
                                           p.usedArrays.end());
    std::sort(sortedArray.begin(), sortedArray.end(), ArrayPtrsByName());
    for (std::vector<const Array *>::iterator it = sortedArray.begin(),
                                              ie = sortedArray.end();
         it != ie; ++it) {
      const Array *A = *it;
      PC << "array " << A->name << "[" << A->size << "]"
         << " : w" << A->domain << " -> w" << A->range << " = ";
      if (A->isSymbolicArray()) {
	/*	  switch(A->type){
			  case TYPE_NATIVE:
				  break;
			  case TYPE_SECRET:
				  PC<<" secret";
				  break;
			  case TYPE_ATTACKER_O:
				  PC<<" attacker observable";
				  break;
			  case TYPE_ATTACKER_C:
				  PC<<" attacker controlled";
				  break;
		  }
     */   PC << "symbolic";
      } else {
        PC << "[";
        for (unsigned i = 0, e = A->size; i != e; ++i) {
          if (i)
            PC << " ";
          PC << A->constantValues[i];
        }
        PC << "]";
      }
      PC.breakLine();
    }
  }

  PC << "(query [";
#define Y(X,PC) PC<<#X;
  // Ident at constraint list;
  unsigned indent = PC.pos;
  for (ConstraintManager::const_iterator it = constraints.begin(),
			  ie = constraints.end(); it != ie;) {
	  ref<Expr> expr=*it;
	  ConstraintManager* c=( ConstraintManager*)&constraints;
	  unsigned index=c->getConstraintType(expr);
	  Y(constraints.TypeBindings[index],PC);
	  PC<<"||||";
	  
  }
  for (ConstraintManager::const_iterator it = constraints.begin(),
         ie = constraints.end(); it != ie;) {
	  p.print(*it, PC);
    ++it;
    if (it != ie)
      PC.breakLine(indent);
  }
  PC << ']';

  p.printSeparator(PC, constraints.empty(), indent-1);
  p.print(q, PC);

  // Print expressions to obtain values for, if any.
  if (evalExprsBegin != evalExprsEnd) {
    p.printSeparator(PC, q->isFalse(), indent-1);
    PC << '[';
    for (const ref<Expr> *it = evalExprsBegin; it != evalExprsEnd; ++it) {
      p.print(*it, PC, /*printConstWidth*/true);
      if (it + 1 != evalExprsEnd)
        PC.breakLine(indent);
    }
    PC << ']';
  }

  // Print arrays to obtain values for, if any.
  if (evalArraysBegin != evalArraysEnd) {
    if (evalExprsBegin == evalExprsEnd)
      PC << " []";

    PC.breakLine(indent - 1);
    PC << '[';
    for (const Array * const* it = evalArraysBegin; it != evalArraysEnd; ++it) {
      PC << (*it)->name;
      if (it + 1 != evalArraysEnd)
        PC.breakLine(indent);
    }
    PC << ']';
  }

  PC << ')';
  PC.breakLine();
}
void ExprPPrinter::printQuery(llvm::raw_ostream &os,
                              const ConstraintManager &constraints,
                              const ref<Expr> &q,
                              const ref<Expr> *evalExprsBegin,
                              const ref<Expr> *evalExprsEnd,
                              const Array * const *evalArraysBegin,
                              const Array * const *evalArraysEnd,
                              bool printArrayDecls) {
  PPrinter p(os);
  
  for (ConstraintManager::const_iterator it = constraints.begin(),
         ie = constraints.end(); it != ie; ++it)
    p.scan(*it);
  p.scan(q);

  for (const ref<Expr> *it = evalExprsBegin; it != evalExprsEnd; ++it)
    p.scan(*it);

  PrintContext PC(os);
  
  // Print array declarations.
  if (printArrayDecls) {
    for (const Array * const* it = evalArraysBegin; it != evalArraysEnd; ++it)
      p.usedArrays.insert(*it);
    std::vector<const Array *> sortedArray(p.usedArrays.begin(),
                                           p.usedArrays.end());
    std::sort(sortedArray.begin(), sortedArray.end(), ArrayPtrsByName());
    for (std::vector<const Array *>::iterator it = sortedArray.begin(),
                                              ie = sortedArray.end();
         it != ie; ++it) {
      const Array *A = *it;
      PC << "array " << A->name << "[" << A->size << "]"
         << " : w" << A->domain << " -> w" << A->range << " = ";
      if (A->isSymbolicArray()) {
        PC << "symbolic";
      } else {
        PC << "[";
        for (unsigned i = 0, e = A->size; i != e; ++i) {
          if (i)
            PC << " ";
          PC << A->constantValues[i];
        }
        PC << "]";
      }
      PC.breakLine();
    }
  }

  PC << "(query [";
  
  // Ident at constraint list;
  unsigned indent = PC.pos;
  for (ConstraintManager::const_iterator it = constraints.begin(),
         ie = constraints.end(); it != ie;) {
    p.print(*it, PC);
    ++it;
    if (it != ie)
      PC.breakLine(indent);
  }
  PC << ']';

  p.printSeparator(PC, constraints.empty(), indent-1);
  p.print(q, PC);

  // Print expressions to obtain values for, if any.
  if (evalExprsBegin != evalExprsEnd) {
    p.printSeparator(PC, q->isFalse(), indent-1);
    PC << '[';
    for (const ref<Expr> *it = evalExprsBegin; it != evalExprsEnd; ++it) {
      p.print(*it, PC, /*printConstWidth*/true);
      if (it + 1 != evalExprsEnd)
        PC.breakLine(indent);
    }
    PC << ']';
  }

  // Print arrays to obtain values for, if any.
  if (evalArraysBegin != evalArraysEnd) {
    if (evalExprsBegin == evalExprsEnd)
      PC << " []";

    PC.breakLine(indent - 1);
    PC << '[';
    for (const Array * const* it = evalArraysBegin; it != evalArraysEnd; ++it) {
      PC << (*it)->name;
      if (it + 1 != evalArraysEnd)
        PC.breakLine(indent);
    }
    PC << ']';
  }

  PC << ')';
  PC.breakLine();
}
