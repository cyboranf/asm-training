#include <stdio.h>
#include <stdlib.h>

/*

- jak¹ maksymaln¹ liczbê binarn¹ mo¿na zapisaæ przy pomocy typu int?

UINT_MAX = 4294967295
INT_MAX  = 2147483647
UBIN_MAX = 1111111111 } branie typu bez znaku nie zmieni rozmiaru max liczby binarnej 

Odp: Przy pomocy typu int maksymalnie mo¿na zapisaæ liczbê binarn¹ 1111111111

INT_MIN = -2147483648
INT_MAX = 2147483647

- jaka jest wartoœæ dziesiêtna maksymalnej liczby binarnej, jak¹ mo¿na zapisaæ przy pomocy typu int?
    
	       9876543210
UBIN_MAX = 1111111111 = 2^10 - 1 = 1023

Odp: Wartoœæ dziesiêtna maksymalnej liczby binarnej mo¿liwej do zapisania przy pomocy typu int to 1023

*/

/*

11 / 2 = 5  r0 = 1
5 / 2 = 2   r1 = 1
2 / 2 = 1   r2 = 0
1 / 2 = 0   r3 = 1

11 = 1011 = 1*10^0 + 1*10^1 + 0*10^2 + 1*10^3

*/

int dec2bin(int x){  
    int suma = 0;
    int pow = 1; //10^0
    
    while (x > 0){
        suma = suma + x%2 * pow;
        
        x = x/2;
        
        pow = pow * 10;
    }
    
    return suma;
}

int bin2dec(int x){
	int sum = 0;
	int pow = 1; // 2^0
	
	while (x > 0){
		sum = sum + x%10 * pow; // ostatnia cyfra razy potêga
		
		x = x / 10;
		
		pow = pow * 2;
	}
	
	return sum;
}

void dec2byte(unsigned int x){ // reprezentacja little-endian
	int pow = 1; // 256^0
	
	int temp; //zmienna pomocnicza
	
	printf("dec2byte(%u) = ", x);
	
	//while(x > 0){
	int i;
	for(i = 0; i < 4; i++){
		unsigned int pom = x % 256;
		
		printf("[");
		
		if(pom < 10) printf("00"); // dopisanie zer
		else if (pom < 100) printf("0");
		
		printf("%d]", pom * pow);
		
		x = x / 256;
	}
}

int main() {
    printf("konwersje.c\n\n");
    
    int dec1 = 16; // dec1 = 0..1023
    printf("dec2bin(%d) = %d\n", dec1, dec2bin(dec1));
    
    //dec2bin(1023) = 1111111111

    int bin1 = 1111111111;
    printf("bin2dec(%d) = %d\n", bin1, bin2dec(bin1));
    
    
    unsigned int dec2 = 1023;
    
    printf("dec2byte(%u) = ", dec2);
    dec2byte(dec2);
    
    /*
    
    Odp: Powy¿sze funkcje bêd¹ dzia³aæ poprawnie dla parametrów aktualnych nie przekraczaj¹cych
    	 maksymaln¹ wartoœæ binarn¹ mo¿liw¹ do zapisania za pomoc¹ typu int. Czyli takie, których 
    	 wartoœæ w systemie dziesiêtnym nie bêdzie wiêksza ni¿ 1023.
    
    */
    
    return 0;
}
