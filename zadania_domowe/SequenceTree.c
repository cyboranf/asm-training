#include <stdio.h>

int f(int n) {
	if (n == 1) return 3;
	if (n == 2) return 4;	
	return 0.5*f(n-1) + 2*f(n-2); 
}

int seq(int n) {
    static int wywolanie;
    
    wywolanie++;
    
    printf("seq%d(%d) = %d\n", wywolanie, n, f(n));
    
	if (n == 1) return 3;
	if (n == 2) return 4;	
	return 0.5*seq(n-1) + 2*seq(n-2); 
}

int main() {
    printf("SequenceTree.c\n\n");
    
    int n = 4;
    
    seq(n);
    
    return 0;
}
