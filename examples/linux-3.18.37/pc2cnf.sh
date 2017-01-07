#/usr/bin/bash
kleaver -out=result.smt2 --print-smtlib $1
stp --output-CNF --disable-simplifications result.smt2
python /playpen/ziqiao/2project/klee/analyzer/SetInd.py output_0.cnf name_cnf.txt ../concern.txt ../jaccard.txt
