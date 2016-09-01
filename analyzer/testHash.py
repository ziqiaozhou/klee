from joblib import Parallel, delayed
import types
import copy_reg
import multiprocessing
import numpy
import subprocess
import copy
import random
import sys
import time
import math
import os
from pyparsing import nestedExpr
import filecmp
import itertools
from modelCount import WeightMC
def LOG(filename,str):
    f=open(filename,'a+')
    f.write(str)
    f.close()
def findsubsets(S,m):
    return set(itertools.combinations(S, m))
def getPCbyNum(num,numPC,numIndex):
    PC=[]
    base=numIndex-numPC
    old=-1
    for i in range(0,numPC):
        one=i+int(num%base)
        #if one<=old:
         #   return PC
        PC.append(one)
        num=int(num/base)
        old=one
    return PC
def nCr(n,r):
    f = math.factorial
    return f(n) / f(r) / f(n-r)
def _pickle_method(m):
    if m.im_self is None:
        return getattr, (m.im_class, m.im_func.func_name)
    else:
        return getattr, (m.im_self, m.im_func.func_name)

copy_reg.pickle(types.MethodType, _pickle_method)


def pause():
        programPause = raw_input("Press the <ENTER> key to continue...")
class Parser:
    symbol_type={}
    linuxfolder=""
    pathDir=''
    starters=['Eq','Ne','Ult','Ule','Ugt','Uge','Slt','Sle','Sgt','Sge']
    logic={'And':[2,3], 'Or':[2,3], 'Xor':[2,3], 'Shl':[2], 'LShr':[2], 'AShr':[2]}
    readKey=['ReadLSB','Read','ReadMSB']
    structs={}
    readKeys=['ReadLSB','Read','ReadMSB']
    typewidths=[64,32]
    def is_int(self,s):
        try: 
            int(str(s))
            return True
        except ValueError:
            return False

    def loadDef(self,def_name):
        def_file=open(def_name);
        def_type={}
        for line in def_file:
            lst = line.split(":")
            def_type[lst[0]]=lst[1]
        def_file.close()
        return def_type

    def loadStruct(self,struct):
        structname=struct.strip("struct").strip(" ").strip("\n");
        f=open(self.structDir+structname+".struct");
        elements={}
        for line in f:
            line=line.split();
            offset=int(line[0])
            if not elements.has_key(offset):
                elements[offset]=[]
            elements[offset].append((line[1],line[2]));
        f.close()
        return elements

    def isBranch(self,one):
        for key in self.starters:
            if one.startswith("['"+key+"'"):
                return True
        return False
    def isQuery(self,one):
        return one.startswith("['"+'query'+"'")
    def isLogic(self,one):
        for key in self.logic.keys():
            if str(one).startswith("['"+key+"'"):
                return key
        return ""

    def isRead(self,one):
        for key in self.readKeys:
            if str(one).startswith("['"+key+"'"):
                return True
        return False
                
    def findIndex(self,val,sortedlst):
        index=0
        while index<len(sortedlst):
            if val==sortedlst[index]:
                return index
            elif val<sortedlst[index]:
                return index-1
            index=index+1
        return index

    def findPrefix(self,prefix,new):
        newprefix=[]
        for index in range(0,len(prefix)):
            if not prefix[index]==new[index]:
                break;
            newprefix.append(prefix[index])
        return newprefix

    def findDiff(self,prefix,old):
        diff=[]
        return old[len(prefix):]

    def convertOffset2Field(self,one,nest,index):
       
        if self.isRead(one):
            readwidth=int(one[1][1:])
            readoffset=one[2]
            readobj=one[3]
            if index<len(nest)-1 and index>0:
                prev=str(nest[index-1])
                nextone=str(nest[index+1])
                if prev[len(prev)-1]=='=' and (nextone.split()[0]==',' or nextone.split()[0]==']'):
                    prevs=prev.split('=')
                    writeoffset=prevs[0]
                    findstart=writeoffset.find('[')+1
                    if findstart>0:
                        writeoffset=writeoffset[findstart:]
                    if int(writeoffset)==int(readoffset):
                        nest[index-1]=prevs[0][0:findstart]
                    if not nextone.split()[0]==']':
                        nest[index+1]=""
                        return ''
            allname=[]
            if self.symbol_type.has_key(str(readobj)):
                symbol=str(readobj)
                stype=self.symbol_type[symbol]
                if not self.structs.has_key(stype):
                    self.structs[stype]=self.loadStruct(stype);
                structdic=self.structs[stype]
                offsets=structdic.keys()
                offsets.sort();
                readoffset=int(readoffset)*8
                cindex=self.findIndex(readoffset,offsets)
                #pause();
                #print stype,offsets,readoffset,cindex
                sindex=0
                while cindex+sindex<len(offsets) and (int(offsets[cindex+sindex])-int(offsets[cindex])<readwidth):
                    index=cindex+sindex
                    offset=offsets[index]
                    name_type=structdic[offset];
                    names=[]
                    simplename=[]
                    prefix=name_type[0][0].split('.')
                    for candidate in name_type:
                        name=candidate[0].split('.')
                        prefix=self.findPrefix(prefix,name)
                        names.append(name)
                    for nameset in names:
                        nameset=self.findDiff(prefix,nameset)
                        namestr='.'.join(list(nameset))
                        simplename.append(namestr)
                    namestr=symbol+'.'+'('+'.'.join(prefix)+')'+'/'.join(simplename)
                    allname.append(namestr);
                    sindex=sindex+1
                one=[','.join(allname)]
        return one


    def convertDec2Hex(self,one):
        key=self.isLogic(one)
        if not key=="":
            for pos in self.logic[key]:
                if len(one)>pos:
                    if self.is_int(one[pos]):
                        one[pos]=str(hex(int(one[pos])))
        return one
    def printNested(self,of,nest,isPrint=True,convert2Field=False):
        for index in range(0,len(nest)):
            one=nest[index]
            alreadyOne=False
            if isinstance(one,list):
                for oneone in one:
                    if isinstance(oneone,list) and not alreadyOne:
                        alreadyOne=True
                        one=self.printNested(of,one,isPrint,convert2Field)
            one=self.convertDec2Hex(one)
            if convert2Field:
                one=self.convertOffset2Field(one,nest,index)
            nest[index]=one
        if isPrint and self.isQuery(str(nest)):
            for one in nest:
                of.write(str(one)+'\n')
        if '' in nest:
            nest=filter(lambda a: a!='', nest)
        return nest

    def parsePC(self,path_str):
        start=path_str.find('(query')
        path_str=path_str[start:];
        path_str=path_str.replace("\n","")
        result=nestedExpr(opener='(',closer=')').parseString(path_str).asList()
        return result



    def parsePath(self,pathfile,symbolfile,linuxfolder):
        pathf=open(pathfile);
        pathc=pathf.read();
        whole=pathc;
        outfile=pathfile.replace('.pc','.pc.new')
        exprfile=pathfile.replace('.pc','.pc.expr')
        print outfile,exprfile
        of=open(outfile,'w+')
        exprof=open(exprfile,'w+')
        exprs=self.parsePC(whole)
        of.write(str(exprs))
       # print exprs
        exprs=self.printNested(exprof,exprs,True,False)
        of.close();
        exprof.close()

    def parseAll(self):
        for pathfile in os.listdir(self.pathDir):
            if pathfile.endswith(".pc"):
                self.parsePath(self.pathDir+pathfile,self.symbolfile,self.linuxfolder);

    def __init__(self,pathDir0,symbolfile0,linuxfolder0,structDir):
        self.pathDir=pathDir0
        self.outDir=self.pathDir+"result/"
        self.mergedDir=self.outDir+'merged/'
        os.system('mkdir '+self.outDir)
        os.system('mkdir '+self.mergedDir)
        self.symbolfile=symbolfile0
        self.structDir=structDir
        self.symbol_type=self.loadDef(self.symbolfile)
        self.linuxfolder=linuxfolder0

    def parseOb(self,obpath):
        outpath=obpath.replace('.observable','.ob')
        obpath=self.pathDir+obpath;
        outpath=self.outDir+outpath;
        if os.path.exists(outpath):
            return
        obfile=open(obpath)
        
        of=open(outpath,'w+')
        
        allline=[]
        for line in obfile:
            allline.append(line)
        count={}
        assignment={}
        index=1
        while index <len(allline):
            line=allline[index]
            while line.count('(')>line.count(')'):
                index=index+1
                line=line+" "+allline[index]
            pair=line.split(': ')
            index=index+1
            if count.has_key(pair[0]):
                count[pair[0]]=count[pair[0]]+1
            else:
                count[pair[0]]=0
            key=pair[0]+'['+str(count[pair[0]])+']'
            #print pair[1]
            path_str=pair[1].replace('\n',' ')
            exprs=nestedExpr(opener='(',closer=')').parseString(path_str).asList()
            result=self.printNested(of,exprs,False,True)
            result0=result[0][0]
            result0=result0.replace('(','').replace(')','')
            if not result0.startswith(key):
                of.write(key+":"+str(result[0])+"\n")
        obfile.close()
        of.close()

    def parseResultPal(self,lst):
        for pathfile in lst:
            self.parseOb(self.outDir+pathfile)
    def parseResult(self):
        num_cores = multiprocessing.cpu_count() 
        allpaths=[]
        for pathfile in os.listdir(self.pathDir):
            if pathfile.endswith(".observable"):
                allpaths.append(pathfile)
        Parallel(n_jobs=num_cores)(delayed(self.parseOb)(pathfile) for pathfile in allpaths)

    def legalName(self,name):
        new=str(name);
        new=new.replace(' ','').replace(',','').replace('$','').replace('->','.')
        return new
        
    def formatOne(self,path,suffix):
        f=open(path)
        of=open(path.replace(suffix,suffix+'0'),'w+')
        newlines=f.read();
        index=-1
        f.close()
        f=open(path)
        for line in f:
            index=index+1
            if line.startswith("array"):
                symbolName=line[line.find(' ')+1:line.find('[')]
                legal=self.legalName(symbolName)
                if not legal==symbolName:
                    print symbolName,legal
                    newlines=newlines.replace(symbolName,legal)
            else:
                break
        of.write(newlines)
        f.close()
        of.close()

    def formatAll(self,Dir,suffix):
        for pathfile in os.listdir(Dir):
            if pathfile.endswith(suffix):
                self.formatOne(Dir+pathfile,suffix)

    def changeKey(self,one):
        one=one.replace("KEYVAL",str(random.randint(0,int(math.pow(2,64)))))
        return one;


    def showTime(self,alltime):
        f=open('timeHashtest.txt','w+')
        for key in alltime.keys():
            valid=alltime[key]
            widths=valid.keys()
            widths.sort()
            for width in widths:
                avg=numpy.mean(valid[width])
                std=numpy.std(valid[width])
                diff=max(valid[width])-min(valid[width])
                f.write(str(key)+" "+str(width)+" "+str(avg)+" "+str(std)+" "+str(diff)+"\n")

        f.close()



    def testKleaver(self,path,count):
        f=open(self.structDir+'hash.pc')
        allline0=[]
        for line in f:
            line=line.replace("\n","")
            allline0.append(line);
        outpath="hash.pc"

        alltime={}
        ValidTime={}
        InValidTime={}
        maxWidthAttacker=int(math.pow(2,32))
        maxWidth=int(math.pow(2,8))#maxWidth is dependent on m for hash function
        for i in range(0,int(count)):
            for attackerVal in range(maxWidthAttacker/8+1,maxWidthAttacker/2,maxWidthAttacker/8):
                for width in range(2,maxWidth/8,maxWidth/128):
                    allline=[]
                    low=random.randint(0,maxWidth-width)
                    pair=[low,low+width]
                    for line in allline0:
                        line=line.replace("UPPERBOUND",str(pair[1])).replace("LOWERBOUND",str(pair[0]))
                        line=self.changeKey(line)
                        line=line.replace("ATTACKERVAL",str(attackerVal))
                        allline.append(line)
                    of=open(outpath,'w+')
                    of.write('\n'.join(allline));
                    of.close()
                    start = time.clock()
                    result=subprocess.check_output("kleaver --use-cache=0 -use-cex-cache=0 -link-pc-file="+path+' '+outpath,shell=True)
                    end=time.clock()
                    if not 'INVALID' in result:
                        LOG('time.log','VALID '+str(width)+' '+str(end-start)+"\n")
                        if not ValidTime.has_key(width):
                            ValidTime[width]=[]
                        ValidTime[width].append(end-start)
                    else:
                        LOG('time.log','INVALID '+str(width)+' ['+str(pair[0])+':'+str(pair[1])+'] '+str(attackerVal)+' '+str(end-start)+'\n')
                        if not InValidTime.has_key(width):
                            InValidTime[width]=[]
                        InValidTime[width].append(end-start)
        alltime['VALID']=ValidTime
        alltime['INVALID']=InValidTime

        self.showTime(alltime)
   
    Class=[]

    def checkClass(self,Dir,filename):
        count=len(self.Class)
        for i in range(0,count):
            candidate=Dir+self.Class[i][0]+'.ob'
            if filecmp.cmp(candidate,Dir+filename):
                self.Class[i].append(filename.replace('.ob',''))
                return True
        return False

    def classifyOb(self,printAll=False):
        Dir=self.pathDir+"result/"
        for pathfile in os.listdir(Dir):
            if pathfile.endswith('.ob'):
                if not self.checkClass(Dir,pathfile):
                    self.Class.append([pathfile.replace('.ob','')])
        classfile=Dir+"result.class"
        cf=open(classfile,'w+')
        if(printALL):
            cf.write('\n'.join([' '.join(one)+":"+str(open(self.outDir+one[0]+'.ob').read()) for one in self.Class]))
        else:
            cf.write('\n'.join([' '.join(one) for one in self.Class]))
        cf.close()
    allIndex=[]

    def mergePC(self,suffix):
        f=open(self.outDir+'result.class')
        allObs=[]
        for line in f:
            obfiles=line.split()
            allObs.append(obfiles)
        f.close()
        mainfile=allObs[0]
        for index in range(0,len(allObs)):
            obfiles=allObs[index]
            numOb=len(obfiles)
            iterative=0
            hasError=True
            while hasError and iterative<numOb:
                iterative=iterative+1
                command='kleaver -builder=simplify -evaluate-or'
                tested=range(0,numOb)
                tested.remove(iterative-1)
                for k in tested:
                    ob=obfiles[k]
                    pcindex=int(ob.replace('test','').replace(':',''))
                    pcfile=str(pcindex)+suffix
                    command=command+" -link-pc-file="+self.outDir+pcfile
                    result=subprocess.check_output('kleaver -evaluate-or -out='+ob+'.tmp'+' '+self.outDir+pcfile,stderr=subprocess.STDOUT,shell=True)
                    #result=subprocess.check_output('kleaver -evaluate '+ob+'.tmp',stderr=subprocess.STDOUT,shell=True)
                    if result.find("Error")>0:
                        print "allert"
                mergedfile=self.mergedDir+str(index)+'.mergedpc'
                command=command+' -out='+self.mergedDir+str(index)+'.mergedpc'+' '+self.outDir+str(int(obfiles[iterative-1].replace('test','')))+suffix
                result=subprocess.check_output(command,shell=True)
                f=open(mergedfile)
                declare=[]
                query=[]
                for line in f:
                    if line.startswith('array'):
                        declare.append(line)
                        setdeclare=set(declare)
                    else:
                        query.append(line)
                f.close()
                f=open(mergedfile,'w')
                f.write(''.join(list(setdeclare))+''.join(query))
                f.close()
                hasError=False
                '''  try:
                    result=subprocess.check_output('kleaver -evaluate '+mergedfile,stderr=subprocess.STDOUT,shell=True)
                    if result.find("Error")>0:
                        hasError=True
                        print mergedfile,'!!!error!!!'
                        print command
                    else:
                        hasError=False;
                        print "good"
                except:
                    hasError=True
                   # pause();
                    print 'bad'+command'''
    def createPCstoSolveAttacker(self,secretFile,Dir,suffix='.attacker',Individual=True):
        f=open(secretFile)
        nonsecretSym=[]
        index=0
        allIndex=self.allIndex
        for line in f:
            nonsecretSym.append(line.strip())
        print nonsecretSym
        f.close()
        for pcfile in os.listdir(self.pathDir):
            if pcfile.endswith('.pc'):
                f=open(self.pathDir+pcfile)
                index=int(pcfile[len('test'):pcfile.find('.pc')])
                fstr=f.read();
                f.close();
                f=open(self.pathDir+pcfile)
                attackers=[]
                for line in f:
                    if line.startswith('array'):
                        symbolName=line[line.find(' ')+1:line.find('[')]
                        legal=self.legalName(symbolName)
                        if not legal==symbolName:
                            fstr=fstr.replace(symbolName,legal)
                        sym=legal
                        if not sym in nonsecretSym:
                           # print sym, sym+str(index)
                            if Individual:
                                fstr=fstr.replace(sym,sym+str(index))
                        else:
                            attackers.append(sym)
                    else:
                        break
                last=fstr.rfind(')')
                fstr=fstr[:last]+" [] ["+' '.join(attackers)+'] '+fstr[last:]
                allIndex.append(index);
                nf=open(Dir+str(index)+suffix,'w+')
                nf.write(fstr)
                nf.close();
                f.close()


    def solveOne(self,solvablePCs,suffix='.attacker0'):
        logf=open(self.outDir+'attacker.log','a+')
        runcommand="kleaver -builder=simplify"
        for index in solvablePCs[1:]:
            runcommand+=" -link-pc-file="+self.outDir+str(index)+suffix
        runcommand=runcommand+" "+self.outDir+str(index)+suffix
        start = time.clock()
        #print runcommand
        maxnum=len(solvablePCs)
        result=subprocess.check_output(runcommand,shell=True)
        end=time.clock()
        newSolvablePCs=solvablePCs
        if 'INVALID' in result:
            num=len(newsolvablePCs)
            maxnum=max([maxnum,num]);          
            logf.close()
            return [maxnum,False,newSolvablePCs]
        else:
            num=len(solvablePCs)
            logf.write(str(num)+':'+str(solvablePCs)+'\n'); 
            maxnum=max([num,maxnum]);
            newSolvablePCs=solvablePCs
        logf.close()
        print [maxnum,maxnum<=len(solvablePCs),newSolvablePCs]
        return [maxnum,maxnum<=len(solvablePCs),newSolvablePCs]

    def solveAttacker(self,solvablePCs,allIndex,leftIndexs,suffix='.attacker0'):
        logf=open(self.outDir+'attacker.log','a+')
        maxnum=len(solvablePCs)
        if len(leftIndexs)==1 :
            pcindex=leftIndexs[0]
            newsolvablePCs=list(solvablePCs)
            newsolvablePCs.append(pcindex);
            result=self.solveOne(newsolvablePCs,suffix)
            logf.write(str(result[0])+" "+str(result[2])+'\n');
            logf.close();

            return result;
        newsolvablePCs=solvablePCs;
        for pcindex in leftIndexs:
            newleftIndexs=list(leftIndexs)
            if pcindex<max(solvablePCs):
                newleftIndexs.remove(pcindex)
                continue
            pcfile=self.outDir+str(pcindex)+suffix

            newleftIndexs.remove(pcindex)
            newSolvablePCs=list(solvablePCs)
            newSolvablePCs.append(pcindex)
            higherresult=self.solveAttacker(newSolvablePCs,allIndex,newleftIndexs,suffix)
            num=higherresult[0]
            IsFalse=higherresult[1]
            newsolvablePCs=higherresult[2]
            if not IsFalse:
                continue
            result=self.solveOne(newsolvablePCs,suffix)
            maxnum=max(maxnum,result[0])
            if not result[1]:
                return result;
            else:
                pcindex=solvablePCs[len(solvablePCs)-1]
                pcfile=self.outDir+str(pcindex)+suffix
                for pcindex in solvablePCs: 
                    oldsolvablePCs=list(solvablePCs)
                    oldsolvablePCs.remove(pcindex)
                    result=self.solveOne(oldsolvablePCs,suffix)
                    if not result[1]:
                        continue;
                    else:
                        return [maxnum,True,oldsolvablePCs];
            if maxnum>=len(allIndex):
                return maxnum;
        logf.close();
        return [maxnum,True,solvablePCs]
    NSATrecorder=[]
    def checkNSAT(self,PCs):
        for nsat in self.NSATrecorder:
            if set(PCs)>=set(nsat):
                print "false check"
                return False
        return True
    def solveA(self,suffix='.attacker0'):
        allIndex=[]
        for pcfile in os.listdir(self.outDir):
            if pcfile.endswith(suffix):
                allIndex.append(int(pcfile[0:pcfile.find('.')]))
        command="kleaver -builder=simplify"
        maxnum=0
        allIndex.sort()
        numPC=len(allIndex)/2
        step=numPC/2;
        numIndex=len(allIndex)
        while numPC>0 and numPC<len(allIndex) and step>1:
           # allComb=findsubsets(allIndex,numPC)
            print "allcomb"
            notExist=True
            nPossible=nCr(numIndex,numPC)
            base=numIndex-numPC
            nF=math.pow(base,numPC)
            #print numPC
            #pause()
            #start=math.factorial(numIndex-1)/math.factorial(numPC)
            pcNum=0
            PCs=getPCbyNum(pcNum,numPC,numIndex)
            while pcNum<nF:
                print len(set(PCs))
                if len(set(PCs))==numPC and  self.checkNSAT(PCs):
                    print PCs
                    result=(self.solveOne(PCs,suffix))
                    if not result[1]:
                        nonExist=False;
                        numPC=numPC+step
                        solvablePCs=PCs
                        break;
                    else:
                        self.NSATrecorder.append(list(PCs))
                pos=0
                while pos<len(PCs)-1:
                    if PCs[pos+1]-PCs[pos]>1:
                        break
                    pos=pos+1
                #print pos
                #pause()
                pcNum=pcNum+int(math.pow(base,pos))
                PCs[pos]=PCs[pos]+1
                if(PCs[pos]>=numIndex):
                    break
            if notExist:
                numPC=numPC-step;
            step=step/2
        print numPC, sovablePCs

    def wrong(self,suffix):
        for pcindex in allIndex:
            newleftIndexs=list(allIndex)
            newleftIndexs.remove(pcindex)
            solvablePC=[]
            solvablePC.append(pcindex)
            num=self.solveAttacker(solvablePC,allIndex,newleftIndexs,suffix)
            maxnum=maxnum([num,maxnum])
            if maxnum>=len(allIndex):
                break;
        return maxnum


    def formatHashFile(self):
        for hashfile in os.listdir(self.structDir):
            if hashfile.endswith('.pc') and hashfile.startswith('hash_'):
                    index=int(hashfile.replace('hash_','').replace('.pc',''))
                    mlen=math.ceil(index/8.0)
                    f=open(self.structDir+hashfile)
                    read=f.read()
                    f.close()
                    if not read.find('array tk[1656]')>=0:
                        read='array tk[1656]: w32 -> w8 = symbolic'+'\n'+'array skb.cb[40]: w32 -> w8 = symbolic\n'+read

                    read=read.replace('Ult 0','Eq ALPHA').replace('(Ult N0 2)','').replace('array key[160]','array key['+str(int(mlen*8*4))+']')
                    querystart=read.find('[',read.find('query'))
                    if not read.find('(Eq (ReadLSB w32 1140 tk) (ReadLSB w32 0 y))')>=0:
                        end=read[querystart+1:]
                        read=read[:querystart+1]+'(Eq (ReadLSB w32 1140 tk) (ReadLSB w32 0 y))\n'
                        offset=0
                        while offset<index*4:
                            read=read+'(Eq (ReadLSB w64 '+str(int(offset))+' key) KEYVAL)\n'
                            offset=offset+8
                        read=read+'(Eq (ReadLSB w32 16 skb.cb) ATTACKERVAL)'+end
                    read=read.replace('Eq false','Eq true')
                    resultstart=read.rfind('false')+5
                    if read[resultstart:].find('y ')<0:
                        if read[resultstart:].find('[')<0:
                            read=read[:read.rfind(')')]+' [] [y])'
                    f=open(self.structDir+hashfile,'w')
                    f.write(read)
                    f.close()

 
if len(sys.argv)>1:
    parse=Parser("/playpen/ziqiao/2project/klee/examples/linux-3.18.37/klee-last/","symbol.def","/playpen/ziqiao/2project/klee/examples/linux-3.18.37/","linux/")
    parse.mergePC('.pc0')
    parse.formatHashFile()
    count=WeightMC(parse.mergedDir+'3.mergedpc',int(math.pow(2,31)+math.pow(2,30)))
   # parse.createPCstoSolveAttacker('linux/assignAttacker.pc',parse.outDir,'.attacker',True);
    #parse.createPCstoSolveAttacker('linux/assignAttacker.pc',parse.outDir,'.pc0',False);
    #parse.formatAll(parse.outDir,'.attacker');
   # parse.testKleaver(parse.outDir+'50.pc0',50)
    #parse.parseOb('test000095.observable')
    #parse.solveA('.attacker0');
    #parse.parseResult()
    #parse.classifyOb()
   #parse.parseAll()

        
