#include <stdio.h>

int main() {
    printf("div2.c\n\n");
    
    unsigned long long a = 4294967296u; 
    unsigned int b = 3;
    
    printf("a = %u\n", a);
    printf("b = %u\n\n", b);

    unsigned int iloraz = a / b;
    unsigned int reszta = a % b;
    
    printf("iloraz = %u\n", iloraz); 
    printf("reszta = %u\n", reszta); 
    
    return 0;
}
