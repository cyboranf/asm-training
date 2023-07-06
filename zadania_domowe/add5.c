#include <stdio.h>

int main() {
    printf("add4.c\n\n");
    
    int a = -2147483648;
    int b = -1;
    
    long long suma = (long long)a + b;
    
    printf("a = %d\n", a);
    printf("b = %d\n", b);
    
    printf("\nsuma = %lld\n", suma);
    
    return 0;
}
