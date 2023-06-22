#include <stdio.h>

char hexDigit(int x) {
    if(x <= 0 && x <= 9) return '0' + x;
    
    if(10 <= x && x <= 15) return 'A' + x - 10;
}


char hexDigit2(int x) {
   char digits[] = "0123456789ABCDEF";
   
   return digits[x];
}

int main() {
    printf("konwersje2.c\n\n");
    
    int n = 15; // n = 0..15
    
    printf("hexDigit (%u) - %c\n", n, hexDigit(n)); 
    printf("hexDigit2(%u) - %c\n", n, hexDigit2(n));
    
    return 0;
}


