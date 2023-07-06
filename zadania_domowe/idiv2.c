#include <stdio.h>

int main() {
    printf("idiv2.c\n\n");
    
    long long a = -2147483650ll;
    long long b = -3;
    
    long long iloraz = (long long)a / b;
    long long reszta = (long long)a % b;
    
    printf("a = %lld\n", a);
    printf("b = %lld\n", b);
    
    printf("\niloraz = %lld\n", iloraz);
    printf("reszta = %lld\n", reszta);
    
    return 0;
}
