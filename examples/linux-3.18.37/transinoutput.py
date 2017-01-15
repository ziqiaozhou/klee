import os;
import sys;
import math
from optparse import OptionParser
from sets import Set
keywords=[];
def getlst(filename):
	lst=[]
	f=open(filename)
	for line in f:
		lst.append(line.replace("\n",""))
	f.close()
	return lst

def findkey(line):
	for key in keywords:
		if key in line:
			return key;
	return ""
def putfile(filename,new,subfix=".pc",newsubfix='.pc1',resultDir="result-"):
	f=open(filename)
	firstline=""
	declares=[]
	declares.append(new[0]+"\n")
	query=[]
	for line in f:
		line=line.replace("skb->cb","cb").replace("sk->th","th")
		if "array" in line:
			declares.append(line);
			continue;
		if "(query [" in line:
			firstline=line
			continue
		query.append(line);
	f.close()
	start=firstline.find("[")
	firstline=firstline[0:start+1]+new[1]+"\n"+firstline[start+1:]
	f=open(resultDir+filename.replace(subfix,newsubfix),'w+')
	f.write(''.join(declares)+'\n'+firstline+"".join(query))
	f.close()

def trimob(realcontent):
	lst=realcontent.split("\n")
	content=[]
	for line in lst:
		if "output_init_net" in line:
			loc=line.find("output_init_net")
			last=line.find(")",loc)
			first=line.rfind("(",0,loc)
			content.append(line[first:last+1])
			#print loc,first,last,line
	return "\n".join(content)

def classifyOb(Dir,subfix=".observable",start=0):
	obs={}
	Dir=Dir+"/"
	for filename in os.listdir(Dir):
		if filename.endswith(subfix):
			index=int(filename.replace("test","").replace(subfix,""))
			#if index<start:
			#    continue;
			f=open(Dir+filename)
			realcontent=f.read()
			content=trimob(realcontent)
			f.close()
			f=open("result-"+Dir+filename,"w+")
			f.write(content)
			f.close()
			if content not in obs:
				obs[content]=[]
			obs[content].append(filename.replace(subfix,""))
	size=math.ceil(math.log(len(obs),2))
	size=int(math.ceil(size/8)*8);
	declare="array ob["+str(size/8)+"] : w32 -> w8 = symbolic"
	obstr="(ReadLSB w"+str(size)+" 0 ob)"
	count=0;
	os.system("mkdir result-"+Dir)
	f=open("result-"+Dir+"class.txt","w+")
	for key in obs:
		f.write(str(count)+":"+" ".join(obs[key])+"\n")
		for name in obs[key]:
			putfile(Dir+name+".pc",[declare,"(Eq "+obstr+" "+str(count)+")"],'.pc','.pc1')
		count=count+1
	f.close()

def AddSA(Dir,inputfile):
	declare=[]
	query=[]
	f=open(inputfile);
	for line in f:
		if "array" in line:
			declare.append(line)
		else:
			query.append(line)
	putfile(Dir+"result.pc.clean",["".join(declare),"".join(query)],'.pc.clean','.pc.new',"")
	f.close()

def mergeDir(Dirs):
	count=0
	os.system("mkdir klee-all");
	for Dir in Dirs:
		Dir=Dir+'/'
		for filename in os.listdir(Dir):
			os.system("cp "+Dir+filename+" klee-all/"+str(count)+filename)
		count=count+1
def cleanfile(filename,newsubfix=".clean"):
	declare=Set([])
	others=[]
	constant={}
	f=open(filename)
	for line in f:
		if "array" in line:
			nameend=line.find("]")+1
			namestart=line.find("array")+6
			name=line[namestart:nameend]
			if "symbolic" not in line:
				valuestart=line.find("=")+2
				if line[valuestart:] not in constant:
					constant[line[valuestart:]]=Set([])
				constant[line[valuestart:]].add(name)
			else:
				declare.add(line)
		else:
			others.append(line)
	allstr=''.join(others)
	constantdeclare=""
	for value in constant:
		lstconstant=list(constant[value])
		constantdeclare=constantdeclare+"array "+lstconstant[0]+" : w32 -> w8 ="+value+"\n";
		name0=lstconstant[0]
		endname=name0.find("[")
		name0=name0[:endname]
		lenconstant=len(lstconstant)
		if lenconstant>1:
			for i in range(0,lenconstant):
				print lstconstant[i],lstconstant[0]
				name1=lstconstant[i]
				endname=name1.find("[")
				name1=name1[:endname]
				allstr=allstr.replace(name1,name0)
	f.close()
	f=open(filename+newsubfix,'w+')
	f.write("".join(declare)+constantdeclare)
	#for line in others:
	f.write(allstr);
	f.close()

def multiRoundSMT(round,filename,changedfile):
	#fixed=getlst(fixedfile)
	changeable=getlst(changedfile)
	cDeclare=[]
	f=open(filename)
	print changeable
	allstr=""
	for line in f:
		if "declare-fun" in line:
			arr=line.split(" ")
			name=arr[1]
			outline=line
			if name in changeable:
				for i in range(1,round):
					outline=outline+line.replace(name,name+"_"+str(i));
		else:
			outline=line
		if "(assert" in line:
			outline=line;
			for word in changeable:
				for i in range(1,round):
					outline=outline+line.replace(word,word+"_"+str(1))

		allstr=allstr+outline
	f.close()
	f=open(filename+str(round)+".smt2",'w+')
	f.write(allstr)
	f.close()
parser = OptionParser()

def multiRountOpt(option, opt_str, value, parser):
	argv=parser.rargs
	print "multi",argv
	if len(argv)==3:
		multiRoundSMT(int(argv[0]),argv[1],argv[2])
	else:
		print "error -m round file"
		return

def classifyOpt(option, opt_str, value, parser):
	argv=parser.rargs
	if len(argv)==1:
		classifyOb(argv[0],'.observable',0);
	if len(argv)==2:
		classifyOb(argv[0],'.observable',argv[1]);

def mergeOpt(option, opt_str, value, parser):
	argv=parser.rargs
	if len(argv)>=2:
		mergeDir(argv[1:])

parser.add_option("-m","--multi-round",action="callback", callback=multiRountOpt)
parser.add_option("-c","--classify",action="callback", callback=classifyOpt)
parser.add_option("-g","--merge",action="callback", callback=mergeOpt)
parser.parse_args()
"""
if len(sys.argv)==2:
	classifyOb(sys.argv[1],'.observable',0);
if len(sys.argv)>2:
	mergeDir(sys.argv[1:])
	"""
def const_clean():
	filename="result-klee-all/result.pc.new"
	f=open(filename)
	allstr=""
	name0="const_arr57"
	for line in f:
		if "array" not in line:
			if "const" in line:
				name1start=line.find("const");
				name1end=line.find(")",name1start)
				name1=line[name1start:name1end]
				line=line.replace(name1,name0)
		allstr=allstr+line
	f.close()
	f=open(filename+".clean",'w+')
	f.write(allstr)
	f.close()

#cleanfile("result-klee-all/result.pc",".clean");

"""if len(sys.argv)==1:
	for filename in os.listdir("result-klee-all/result"):
		if "subpc" in filename:
			cleanfile("result-klee-all/result/"+filename,".clean")"""
	#cleanfile("result-klee-out-126/result.pc")
#AddSA("result-klee-all/","SA.txt")
