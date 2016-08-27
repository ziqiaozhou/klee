#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#define get8bits(d) (*((const uint8_t *) (d)))
#define bitwidth 8
typedef uint8_t bittype;
char *int2bin(int a, char *buffer, int buf_size) {
	    memset(buffer,0,buf_size);
			buffer += (buf_size - 1);

		    for (int i = 31; i >= 0; i--) {
				        *buffer-- = (a & 1) + '0';

						        a >>= 1;
								    }

			    return buffer;
}

#define BUF_SIZE 33

char * hash(char* result0,char * key0,char * data0,int n,int m){

	bittype * key=key0;
	bittype* data=data0;
	bittype* result=result0;
	if (n <= 0 || data == NULL) return 0;
	int i,j,k,l;

	bittype onebit,aAndy,axory,aAndy0,axory1;
 char buffer[BUF_SIZE];
     buffer[BUF_SIZE - 1] = '\0';
//	printf("n=%d,m=%d",n,m);

	 for (i=0;i*bitwidth<m;i++){
		bittype * result_i_ptr=&result[i];
		memset(result_i_ptr,0,bitwidth/8);
		int base=i*bitwidth,max=(i+1)*bitwidth;
		for(k=0;k+base<max && k+base<m;k++){
			axory=(0x1&data[0]);
			for(l=0;l<n;l++){
				bittype y=data[l];
				bittype a=key[(k+8*i)*4+l];
				int2bin(a,buffer,BUF_SIZE-1);
				printf("%d,%d,%d,%s & ",i,k,l,buffer);
				int2bin(y,buffer,BUF_SIZE-1);
				printf("%s =",buffer);
				aAndy=(a&y);
				int2bin(aAndy,buffer,BUF_SIZE-1);
				printf("%s\n",buffer);
				for(j=0;j<bitwidth;j++){
					axory^=aAndy&1;
					aAndy>>=1;
				}
			}
			printf("xor=%d,",axory);
			(*result_i_ptr)|=axory<<k;
			printf("result_i=%d\n",axory);
		}
}
}

#define Mval 5
int main(int argc,char **argv){
	int n=4,m=Mval;
//	m=atoi(argv[1]);
	char key[Mval*8*4];
	int len=Mval*8*4;
	bittype * keyb=key;
	//28, 9-10=0
	unsigned int x=0b101010101010101010010101010101;
	int i;
	klee_make_symbolic(&m,sizeof(int),"msize");
	klee_prefer_cex(&m,m<28 && m>2);

		klee_make_symbolic(key,len,"key");
	char data[4];
	unsigned long result=0;
	unsigned int idata=0;//=x;
	klee_make_symbolic(&idata,4,"y");
	hash(&result,key,&idata,n*8/bitwidth,m);
	printf("%lx",result);	
	if(result>1 && result<10){
		printf("result alert");
		return 1;
	}else{
		printf("result not alert");
		printf("%lx",result);
	}
	//	klee_make_observable("result=",result);
//	klee_print_expr("result",result);
	return 1;

}
