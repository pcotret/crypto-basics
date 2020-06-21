#include <stdio.h>
#include <stdint.h>

void encrypt(long *v,long *k) {
  unsigned long y=v[0], z=v[1], sum=0, /* set up */
  delta=0x9e3779b9, /* a key schedule constant */
  n=32;
  while(n-->0) { /* basic cycle start */
    sum += delta;
    y += ((z<<4) + k[0]) ^ (z + sum) ^ ((z>>5) + k[1]);
    z += ((y<<4) + k[2]) ^ (y + sum) ^ ((y>>5) + k[3]);  
  } /* end cycle */
  v[0]=y; v[1]=z;
}   

void decrypt(long *v,long *k) {
  unsigned long n=32, sum, y=v[0], z=v[1],
  delta=0x9e3779b9;
  sum=delta<<5;
  while(n-->0) { /* start cycle */
    z -= ((y<<4) + k[2]) ^ (y + sum) ^ ((y>>5) + k[3]);  
    y -= ((z<<4) + k[0]) ^ (z + sum) ^ ((z>>5) + k[1]);
    sum -= delta;
  } /* end cycle */
  v[0]=y; v[1]=z;
}  

int main()
{
  long v[] = {0xb4cf3351, 0x84132dba};
  long k[] = {0xde61e45c, 0x40573f4b, 0xbba9ebaf, 0xfe342544};
	printf(" Original: ");
	printf(" [ %lu %lu ]", v[0], v[1]);
	printf(" [ %lu %lu %lu %lu ]", k[0], k[1], k[2], k[3]);
  encrypt(v,k);
  printf("\n Encrypted: ");
  printf("[ %lu %lu ]", v[0], v[1]);
  decrypt(v,k);
  printf("\n Decrypted: ");
  printf("[ %lu %lu ]", v[0], v[1]);
  printf("\n");
  return 0;
}