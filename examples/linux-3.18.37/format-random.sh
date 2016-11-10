kleaver --evaluate-or --out=result.pc -link-pc-file=test000001.pc0 --link-pc-file=test000002.pc0 --link-pc-file=test000003.pc0 test000004.pc0
kleaver -out=result.smt2 --print-smtlib result.pc
stp --output-CNF --disable-simplifications result.smt2
python ../../../analyzer/SetInd.py output_0.cnf name_cnf.txt ../concern.txt
