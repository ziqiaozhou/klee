str=''
for file in $(ls |grep .pc1)
do
	if [ "$file" = "0test000001.pc1" ]
	then continue;
	fi
	str=$str'-link-pc-file='$file' '
done
echo "str="$str
kleaver --evaluate-or --out=result.pc $str 0test000001.pc1
kleaver -out=result.smt2 --print-smtlib result.pc
stp --output-CNF --disable-simplifications result.smt2
python /playpen/ziqiao/2project/klee/analyzer/SetInd.py output_0.cnf name_cnf.txt ../concern.txt ../jaccard.txt
