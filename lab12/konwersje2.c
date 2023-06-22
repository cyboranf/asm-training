#include <stdio.h>
#include <limits.h>

char hexDigit(int x) {
    if (0 <= x && x <= 9) return '0' + x;
    
    if (10 <= x && x <= 15) return 'A' + x - 10; 
}

char hexDigit2(int x) {
    char digits[] = "0123456789ABCDEF";
    
    return digits[x];
}

void byte2hex(unsigned char byte) {
    char hex[2];
    
    char maska = 1 + 2 + 4 + 8; // 00001111
    
    hex[1] = hexDigit(byte & maska);
    
    byte = byte >> 4;
    
    hex[0] = hexDigit(byte);
    
    printf("%c%c", hex[0], hex[1]);
} 

void main() {
    printf("konwersje2.c\n\n");

    int n = 15; // n = 0..15
    
    printf("hexDigit (%u) = %c\n", n, hexDigit(n));
    printf("hexDigit2(%u) = %c\n", n, hexDigit2(n));
    
    unsigned char byte = 128; // byte = 0..255 
    
    printf("byte2hex(%u) = ", byte); byte2hex(byte);  printf("\n");
    
    return 0;
}

