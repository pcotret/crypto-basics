#include <stdio.h>
#include <stdint.h>

void tean(long *v,long *k,long N)
{
    unsigned long y=v[0],z=v[1],DELTA=0x9e3779b9;
    if(N>0) 
    {
        /* Encryption, 32 rounds recommended */
        unsigned long limit=DELTA*N,sum=0;
        while(sum!=limit)
        {
            y+=((z<<4)^(z>>5)) + z^sum + k[sum&3];
            sum+=DELTA;
            z+=((y<<4)^(y>>5)) + y^sum + k[sum>>11&3];
        }
    }
    else
    {
        /* Decryption */
        unsigned long sum=DELTA*(-N);
        while(sum)
        {
            z-=((y<<4)^(y>>5)) + y^sum + k[sum>>11&3];
            sum-=DELTA;
            y-=((z<<4)^(z>>5)) + z^sum + k[sum&3];
        }
    }
    v[0]=y;
    v[1]=z;
}
int main()
{
    long v[] = {0xb4cf3351, 0x84132dba};
    long k[] = {0xde61e45c, 0x40573f4b, 0xbba9ebaf, 0xfe342544};
    printf(" Original: ");
    printf(" [ %X %X ]", v[0], v[1]);
	printf(" [ %X %X %X %X ]", k[0], k[1], k[2], k[3]);
    tean(v,k,32);
    printf("\n Encrypted: ");
    printf("[ %X %X ]", v[0], v[1]);
    tean(v,k,-32);
    printf("\n Decrypted: ");
    printf("[ %X %X ]", v[0], v[1]);
    printf("\n");
    return 0;
}