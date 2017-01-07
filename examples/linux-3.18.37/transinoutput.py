import os;
import sys;
import math
from sets import Set
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
    f=open("result-"+filename.replace(subfix,newsubfix),'w+')
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
            if index<start:
                continue;
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
    f=open(inputfile);
    for line in f:
        if "array" in line:
            declare.append(line)
        else:
            query.append(line)
    putfile(Dir+"result.pc.clean","".join(declare)+"".join(query),'.pc.clean','.pc.new')
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
    f=open(filename)
    for line in f:
        if "array" in line:
            declare.add(line)
        else:
            others.append(line)
    f.close()
    f=open(filename+newsubfix,'w+')
    f.write(''.join(declare))
    for line in others:
        f.write(line);
    f.close()


if len(sys.argv)==2:
    classifyOb(sys.argv[1],'.observable',5678);
if len(sys.argv)>2:
    mergeDir(sys.argv[1:])
if len(sys.argv)==1:
    for filename in os.listdir("result-klee-real"):
        if "subpc" in filename:
            cleanfile("result-klee-real/"+filename,"")
    #cleanfile("result-klee-out-126/result.pc")
    #AddSA("result-klee-real","SA.txt")
