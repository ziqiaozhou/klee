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

structDir='/playpen/ziqiao/2project/klee/analyzer/linux/'
def mergeHashfile(i,pcfile,val):
	f=open(structDir+'hash_'+str(index)+'.pc')
	allline0=[]
	for line in f:
		line=line.replace("\n","")
		allline0.append(line);
	outpath=pcfile.tmp
	allline=[]
	low=random.randint(0,maxWidth-width)
	pair=[val-1,val+1]
	for line in allline0:
		line=line.replace("UPPERBOUND",str(pair[1])).replace("LOWERBOUND",str(pair[0]))
		line=self.changeKey(line)
		line=line.replace("ATTACKERVAL",str(attackerVal))
		allline.append(line)
	of=open(outpath,'w+')
	of.write('\n'.join(allline));
	of.close()
	return outpath


def solve(pcfile):
    runcommand='kleaver -evaluate '+pcfile
    result=subprocess.check_output(runcommand,stderr=subprocess.STDOUT,shell=True)
    if result.find('INVALID')>0:
        example={}
        constraints=[]
        lines=result.split('\n')
        for line in lines:
            tokens=line.split()
            if tokens[0]='Array':
                assign=token[2]
                start=assign.find('[')
                end=assign.find(']')
                sym=assign[:start]
                if sym=='y':
                    constraints=""
                    valstr=assign[start+1:end]
                    vals=valstr.split(',')
                    for i in range(0,len(vals)):
                        final=vals[i]*math.pow(2,8*i)
                    constraints=' (Eq '+final+' (ReadLSB w32 '+str(offset*4)+' '+sym+'))'
                    return [vals,constraints]
                    break
        return 'UNSAT'
    else if result.find('VALID')>0:
        return 'UNSAT'
    else:
        return 'ERROR'

def weight(y):
    if type(y) is list:
        return len(y)
    return 1
				
def BSAT(pcfile,pivot,r,wmax,S):
    wmin=wmax/r
    wtotal=0
    Y=[]
    newpcfile=pcfile
    while wtotal/(wmin*r)<=pivot:
        result=solve(pcfile)
        if result=='UNSAT' or result=='ERROR':
            break
        y=result[0]
        addBlock=result[1]
        Y.append(y)
        f=open(pcfile)
        r=f.read()
        f.close()
        index=r.find(']',r.find('query'))
        r=r[:index]+'\n'+addBlock+r[index:]
        f.open(pcfile,'w')
        f.write(r)
        f.close()
        w=weight(y)
        wtotal=wtotal+w
        wmin=min(wmin,w)
    return [Y,wmin*r]

def WeightMCCore(pcfile,S,pivot,r,wmax):
    newpcfile=pcfile+'.tmp'
	os.system('cp '+pcfile+' '+newpcfile)
	pcfile=newpcfile
	[Y,wmax]=BSAT(pcfile,pivot, r,wmax,S)
    wY=weight(Y)
	newpcfile=pcfile+'.tmp'
    if wY/wmax<=pivot:
        return wY
    else:
        i=0
        while not ((wY/wmax<=pivot and wY>0) or i==n):
            i=i+1
            hashfile=structDir+'hash_'+str(i)+'.pc'
            alpha=int(rand.getrandbits(i))
			command='kleaver -evaluate-more -out='+newpcfile+' -link-pc-file='+pcfile+' '+hashfile
            [Y,wmax]=BSAT(pcfile,pivot,r,wmax,S)
			wY=weight(Y)

		if wY==0 or wY/wmax>pivot:
			return [-1,wmax]
		else:
			return [wY*math.pow(2,i-1)/wmax,wmax]

def WeightMC(pcfile,epsilon=0.8,sigma=0.2,S=[],r=1):
	count=0
	C=[]
	wmax=1
	pivot=2*math.exp(1.5)*math.pow((1+1/epsilon),2)
	t=35*math.log(3/sigma,2)
	t=int(t)
	for counter in range(0,t):
		[c,wmax]=WeightMCCore(pcfile,S,pivot,r,wmax)
		print c, wmax
		if c>=0:
			C.append(c)
	finalCount=numpy.median(C)
	print finalCount

		
