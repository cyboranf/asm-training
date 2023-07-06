#include <stdio.h>

int main() {
	printf("data.c\n\n");
	
	int a = 1, b = 2;
	int c, d;
	int e = 3, f;
	int g, h = 4;
	
	/* adresy zmiennych */
	printf("&a = %p\n", &a);
	printf("&b = %p\n", &b);
	printf("&c = %p\n", &c);
	printf("&d = %p\n", &d);
	printf("&e = %p\n", &e);
	printf("&f = %p\n", &f);
	printf("&g = %p\n", &g);
	printf("&h = %p\n", &h);
	
	printf("\n");
	
	/* warto�ci zmiennych */
	printf("a = %p\n", a);
	printf("b = %p\n", b);
	printf("c = %p\n", c);
	printf("d = %p\n", d);
	printf("e = %p\n", e);
	printf("f = %p\n", f);
	printf("g = %p\n", g);
	printf("h = %p\n", h);
	
	/*
	
	0061FE9C [01][00][00][00]   a
	0061FE98 [02][00][00][00]   b
	0061FE94 [00][00][00][00]   c
	0061FE90 [60][1F][40][00]   d
	                         
	0061FE8C [03][00][00][00]   e	
	0061FE88 [A8][FE][61][00]   f
	0061FE84 [90][15][AC][00]   g
	0061FE80 [04][00][00][00]   h

	*/
	
	/*
	
	Gdy zmiennie nie s� zainicjowane, jako warto�� przypisane jest 0 lub �mieci z pami�ci
	
	Adresy zmiennych s� zgodne z map� pami�ci, poniewa� przechowywane s� one na stosie. 
	Zmienne zadeklarowane wcze�niej maj� adresy o wy�szych warto�ciach.
	Adresowanie rozpoczynane od high memory.
	
	*/
	
	return 0;
}
