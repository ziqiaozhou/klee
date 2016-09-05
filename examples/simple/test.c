#include <stdlib.h>
#include <klee/klee.h>
#include<math.h>

int test(int x,int* o,int y,int others){
	if((x%8)+y*y<10){
		( *o)+=1;
	}
	else{
		( *o)+=2;
	}
	return *o;
}
int test1(int x,int* o,int y,int others){
	int t=x%8;
	if(t>y){
		if(y>others||others>16)
		 ( *o)+=1;
		else
		  (*o)+=3;
	}else{
		if(y-others<1){
			(*o)+=3;
		}else{
			(*o)+=4;
		}
	}
}
struct B{
	int c;
	int d;
	char e[4];
};
struct A{
	struct B * bbbbstruct;
};

int test_control(int a,int s,int * o){
	if(s<a)
	  *o=1;
	else
	  *o=2;
}

int test_data(int a,int s,int * o){
	*o=s%a;
}


int main(){
	int a,s,o;
	klee_make_symbolic(&s,sizeof(s),"secret");
	klee_make_symbolic(&a,sizeof(a),"attacker");
	test_data(s,a,&o);
	klee_make_observable("o=",o);
}

