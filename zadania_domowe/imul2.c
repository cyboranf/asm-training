#include <stdio.h>

int main() {
    printf("imul2.c\n\n");
    
    int a = -2147483647;
    int b = 2;
    
    long long iloczyn = (long long)a * b;
    
    printf("a = %d\n", a);
    printf("b = %d\n", b);
    
    printf("\niloczyn = %lld\n", iloczyn);
    
    return 0;
}
