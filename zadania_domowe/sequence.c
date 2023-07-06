#include <stdio.h>

/*

r1  r2  r3
|---|---|       .
1   2   3   4   5   6   7    indeksy
3   4   8   12  22             wartoœci
    |---|---|
    r1  r2  r3
    
seq(4) = 0.5*seq(3) + 2*seq(2) = 0.5*8 + 2*4 = 4 + 8 = 12

Przesuniêcie ramki w prawo:

r1 = r2
r2 = r3
r3 = 0.5*r2 + 2*r1

*/

/*
- ile razy nale¿y przesun¹æ ramkê w prawo, 
aby wyznaczyæ wartoœæ n-tego wyrazu ci¹gu w funkcji seq dla n >= 3 ?

n-3 razy
*/


int seq1(int n) {
    int r1 = 3;
    int r2 = 4;
    int r3 = 0.5 * r2 + 2 * r1;
    
    if (n == 1) return r1;
    if (n == 2) return r2;
    if (n == 3) return r3;
    
    int i;
    for (i = 1; i <= n-3; i++) {
        r1 = r2;
        r2 = r3;
        r3 = 0.5 * r2 + 2 * r1;
    } 
    
    return r3;
}

/*
- dokonaj analizy wywo³ania seq1(4).

*seq1(4) = 12
 r1 = 3
 r2 = 4
 r3 = 0.5*4 + 2*3 = 2 + 6 = 8
 
 i
 i = 1
 1 <= 1   r1 = 4
 		  r2 = 8
 		  r3 = 0.5*8 + 2*4 = 12   i = 2
 2 <= 1   false
 
 return r3 = 12

*/

/*
-  narysuj graf obliczeñ dla seq1(4)

f(1)  f(2)    f(3)
        \   /  
         f(4)  
*/

int seq2(int n) {
	int r1 = 3;
    int r2 = 4;
    
    if (n == 1) return r1;
    if (n == 2) return r2;
    
    int i;
    for (i = 1; i <= n-2; i++) {
        int pom = r1;
        r1 = r2;
        r2 = 0.5 * r1 + 2 * pom;
    }
    
    return r2;
}

/*
- dokonaj analizy wywo³ania seq2(4).

*seq2(4) = 12
 r1 = 3
 r2 = 4
 
 i
 i = 1
 1 <= 2   pom = 3
 		  r1 = 4
 		  r2 = 0.5*4 + 2*3 = 8   i = 2
 2 <= 2   pom = 4
 		  r1 = 8
 		  r2 = 0.5*8 + 2*4 = 12  i = 3
 3 <= 2   false
 
 return r3 = 12
*/

/*
- narysuj graf obliczeñ dla seq2(4)    

f(1)     f(2)
    \   /  |
     f(3)  |
        \  |
         f(4)  	  	       
*/

/*
- która funkcja ma mniejsz¹ z³o¿onoœæ obliczeniow¹ seq1 czy seq2 ?

Mniejsz¹ z³o¿onoœæ obliczeniow¹ ma funkcja seq1 poniewa¿ pêtla wykona siê mniej razy
*/

int main() {
    printf("sequence.c\n\n");
    
    int n = 4;
    
    printf("seq1(%d) = %d\n", n, seq1(n));
    printf("seq2(%d) = %d\n", n, seq2(n));
    
    return 0;
}
