#include <stdio.h>

int main() {
    printf("mul2.c\n\n");
    
    unsigned int a = 4294967295;
    unsigned int b = 2;
    
    unsigned long long iloczyn = (unsigned long long)a * b;
    
    printf("a = %u\n", a);
    printf("b = %u\n", b);
    
    printf("\niloczyn = %llu\n", iloczyn);
    
    return 0;
}
