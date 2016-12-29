import os;
import sys;
import math

keywords=[];
def findkey(line):
    for key in keywords:
        if key in line:
            return key;
    return ""
def putfile(filename,new,subfix=".pc",newsubfix='.pc1'):
    f=open(filename)
    firstline=""
    declares=[]
    declares.append(new[0])
    query=[]
    for line in f:
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
    f=open("result-"+filename.replace(subfix,newsubfix),'w+')
    f.write(''.join(declares)+'\n'+firstline+"".join(query))
    f.close()

def classifyOb(Dir,subfix=".observable"):
    obs={}
    Dir=Dir+"/"
    for filename in os.listdir(Dir):
        if filename.endswith(subfix):
            f=open(Dir+filename)
            content=f.read()
            if content not in obs:
                obs[content]=[]
            obs[content].append(filename.replace(subfix,""))
            f.close()
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

def mergeDir(Dirs):
    count=0
    os.system("mkdir klee-all");
    for Dir in Dirs:
        Dir=Dir+'/'
        for filename in os.listdir(Dir):
            os.system("cp "+Dir+filename+" klee-all/"+str(count)+filename)
        count=count+1

if len(sys.argv)==2:
    classifyOb(sys.argv[1]);

if len(sys.argv)>2:
    mergeDir(sys.argv[1:])
