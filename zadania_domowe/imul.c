#include <stdio.h>

int main() {
    printf("imul.c\n\n");
    
    int a = -65535;
    int b = 2;
    
    int iloczyn = a * b;
    
    printf("a = %d\n", a);
    printf("b = %d\n", b);
    
    printf("\niloczyn = %d\n", iloczyn);
    
    return 0;
}
