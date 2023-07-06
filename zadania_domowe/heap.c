#include <stdio.h>
#include <stdlib.h>

int main() {
    printf("heap.c\n\n");
    
    int *x = malloc(sizeof(int));
    int *y = malloc(sizeof(int));
    
    printf("x = %p\n", x);
    printf("y = %p\n", y);
    
    *x = 1;
    *y = 2;
    
    printf("*x = %d\n", *x);
    printf("*y = %d\n", *y);
    
    /*
     	     [ ][ ][ ][ ]
        	 [ ][ ][ ][ ]
         	 [ ][ ][ ][ ]
    00BD1650 [2][0][0][0]   *y
    
          	 [ ][ ][ ][ ]
          	 [ ][ ][ ][ ]
          	 [ ][ ][ ][ ]
    00BD1640 [1][0][0][0]   *x
    
    Odp: Adresy s� zgodne z map� pami�ci, poniewa� zapisywane s� na stercie, 
    kt�ra adresowana jest od do�u.

    */
    
    printf("\n\n");
    
    void *a = malloc(sizeof(char));
    void *b = malloc(sizeof(char));
    
    printf("Obszar pami�ci przydzielanej na stercie: %d", b-a);
    
    /*
	
	Odp: Najmniejszym obszarem pami�ci przydzielanym na stercie jest:
	- dla kodu 32 bitowego : 16
	- dla kodu 64 bitowego : 32
	
	*/
    
    return 0;
}
