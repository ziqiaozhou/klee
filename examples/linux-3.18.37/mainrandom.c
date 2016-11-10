#include<stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <klee/klee.h>
#define cpu_to_le32(x)  (x)
#define CHACHA20_BLOCK_SIZE     64
#define u32 unsigned int
#define u8 char
#define __u32 unsigned int
#define __u8 u8
static inline u32 rotl32(u32 v, u8 n){
	return (v << n) | (v >> (sizeof(v) * 8 - n));
}
struct crng_state {
	  __u32           state[16];
};
static inline bool arch_get_random_long(unsigned long *v){
	return  false;
}

void chacha20_block(u32 *state, void *stream)                            
{                               
	u32 x[16], *out = stream;                   
	int i;                      
	for (i = 0; i < 16; i++)                
	  x[i] = state[i];             
	for (i = 0; i < 20; i += 2) {             
		x[0]  += x[4];    x[12] = rotl32(x[12] ^ x[0],  16);  
		x[1]  += x[5];    x[13] = rotl32(x[13] ^ x[1],  16);  
		x[2]  += x[6];    x[14] = rotl32(x[14] ^ x[2],  16);  
		x[3]  += x[7];    x[15] = rotl32(x[15] ^ x[3],  16);  

		x[8]  += x[12];   x[4]  = rotl32(x[4]  ^ x[8],  12); 
		x[9]  += x[13];   x[5]  = rotl32(x[5]  ^ x[9],  12); 
		x[10] += x[14];   x[6]  = rotl32(x[6]  ^ x[10], 12);   
		x[11] += x[15];   x[7]  = rotl32(x[7]  ^ x[11], 12);   

		x[0]  += x[4];    x[12] = rotl32(x[12] ^ x[0],   8); 
		x[1]  += x[5];    x[13] = rotl32(x[13] ^ x[1],   8); 
		x[2]  += x[6];    x[14] = rotl32(x[14] ^ x[2],   8); 
		x[3]  += x[7];    x[15] = rotl32(x[15] ^ x[3],   8); 

		x[8]  += x[12];   x[4]  = rotl32(x[4]  ^ x[8],   7);
		x[9]  += x[13];   x[5]  = rotl32(x[5]  ^ x[9],   7);
		x[10] += x[14];   x[6]  = rotl32(x[6]  ^ x[10],  7);  
		x[11] += x[15];   x[7]  = rotl32(x[7]  ^ x[11],  7);  

		x[0]  += x[5];    x[15] = rotl32(x[15] ^ x[0],  16);  
		x[1]  += x[6];    x[12] = rotl32(x[12] ^ x[1],  16);  
		x[2]  += x[7];    x[13] = rotl32(x[13] ^ x[2],  16);  
		x[3]  += x[4];    x[14] = rotl32(x[14] ^ x[3],  16);  

		x[10] += x[15];   x[5]  = rotl32(x[5]  ^ x[10], 12);   
		x[11] += x[12];   x[6]  = rotl32(x[6]  ^ x[11], 12);   
		x[8]  += x[13];   x[7]  = rotl32(x[7]  ^ x[8],  12); 
		x[9]  += x[14];   x[4]  = rotl32(x[4]  ^ x[9],  12); 

		x[0]  += x[5];    x[15] = rotl32(x[15] ^ x[0],   8); 
		x[1]  += x[6];    x[12] = rotl32(x[12] ^ x[1],   8); 
		x[2]  += x[7];    x[13] = rotl32(x[13] ^ x[2],   8); 
		x[3]  += x[4];    x[14] = rotl32(x[14] ^ x[3],   8); 

		x[10] += x[15];   x[5]  = rotl32(x[5]  ^ x[10],  7);  
		x[11] += x[12];   x[6]  = rotl32(x[6]  ^ x[11],  7);  
		x[8]  += x[13];   x[7]  = rotl32(x[7]  ^ x[8],   7);
		x[9]  += x[14];   x[4]  = rotl32(x[4]  ^ x[9],   7);
	}                       

	for (i = 0; i < 16; i++)                
	  out[i] = cpu_to_le32(x[i] + state[i]);           
	state[12]++;                       
}   

void _extract_crng(struct crng_state *crng,__u8 out[CHACHA20_BLOCK_SIZE]){
	 unsigned long v;
	if (arch_get_random_long(&v))
	  crng->state[14] ^= v;
	chacha20_block(&crng->state[0], out);
	if (crng->state[12] == 0)
	  crng->state[13]++;
}


int main(){

	struct crng_state primary_crng;
	__u8 out1[CHACHA20_BLOCK_SIZE],out2[CHACHA20_BLOCK_SIZE],out3[CHACHA20_BLOCK_SIZE];
	klee_make_symbolic(&primary_crng,sizeof(struct crng_state),"state");
	//	int * iout1=out1, * iout2=out2,*iout3=out3;
	__u8 iout1,iout2,iout3;
	__u8 iout[4];
	klee_make_symbolic(&iout1,sizeof(__u8),"out");
//	klee_make_symbolic(&iout2,sizeof(__u8),"out2");
//	klee_make_symbolic(&iout3,sizeof(__u8),"out3");
//	klee_make_symbolic(&iout1,sizeof(__u8),"out1_output");
//	klee_make_symbolic(&iout2,sizeof(__u8),"out2_output");
	klee_make_symbolic(&iout3,sizeof(__u8),"out_output");


	_extract_crng(&primary_crng,out1);
	_extract_crng(&primary_crng,out2);
	_extract_crng(&primary_crng,out3);
	unsigned mask=31;
	iout[0]=out1[0]&mask;
	iout[1]=out2[0]&mask;
	iout[2]=out3[0]&mask;
	iout[3]=0;
	int allout;
	memcpy(&allout,iout,4);
	int i;
	for( i=0;i<1;i++){
		char left[100];
		sprintf(left,"(ReadLSB w32 %d out_output)",i*4);
		klee_make_observable(left,allout);
	}
/*
	for( i=0;i<1;i++){
		char left[100];
		sprintf(left,"(ReadLSB w32 %d out1_output)",i*4);
		klee_make_observable(left,iout1);
	}
	for(i=0;i<1;i++){
		char left[100];
		sprintf(left,"(ReadLSB w32 %d out2_output)",i*4);
		klee_make_observable(left,iout2);
	}
	for(i=0;i<1;i++){
		char left[100];
		sprintf(left,"(ReadLSB w32 %d out3_output)",i*4);
		klee_make_observable(left,iout3);
	}
*/
}
