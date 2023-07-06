#include <stdio.h>

int main() {
    printf("endian2.c\n\n");
    
    short x = 1;
    
    char *b = (char*)&x; // b to wskaünik na char (byte)
    
    printf("b = %p\n\n",b);
    printf("*b = %d\n\n",*b);
    
    /* test architektury  */
    if(*b == 1){
    	printf("little-endian architecture");
	} else {
		printf("big-endian architecture");
	}
        
    return 0;
}
