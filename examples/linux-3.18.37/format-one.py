import os
import sys
Dir=sys.argv[1]
flist=[]
for filename in os.listdir("./"):
	if filename.endswith(".pc1"):
		flist.append(filename);

total=len(flist)
onesum=500
par=total/onesum
#par=6
cmd=""
finalfile=[]
for i in range(0,par):
	if i*onesum > (total-1):
		break;
	sublist=flist[i*onesum:min((1+i)*onesum,total-1)]
	linkfile='--link-pc-file='+' --link-pc-file='.join(sublist[1:])+' '
	cmd=cmd+"\n nohup "+" kleaver --evaluate-or --out=result.subpc"+str(i)+" "+linkfile+sublist[0]+" &"
	finalfile.append("result.subpc"+str(i))

#cmd+=cmd+"\n"+"echo wait finished;"

cmd2="kleaver --evaluate-or --out=result.pc  --link-pc-file="+' --link-pc-file='.join(finalfile[1:])+" "+finalfile[0]

f=open('cmd16.txt',"w+")
f.write(cmd+"\n"+cmd2)
os.system(cmd+"\n"+cmd2);
