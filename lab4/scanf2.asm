        [bits 32]

extern   _printf
extern   _exit
extern   _scanf

global   _main

section  .text

         call getaddr
format:
         db 'a = ', 0
getaddr:

;        esp -> [format][ret]

         call _printf  ; printf('a = ');

;        esp -> [a][ret] ; zmienna a, adres format nie jest juz potrzebny

         push esp  ; esp -> stack

;        esp -> [addr_a][a][ret]

         call getaddr2
format2:
         db '%d', 0
getaddr2:

;        esp -> [format2][addr_a][a][ret]

         call _scanf  ; scanf(format2, addr_a);
         add esp, 2*4 ; esp = esp + 8
;        esp -> [a][ret] ; zmienna a, adres format nie jest juz potrzebny


         call  getaddr3

format3:
         db 'a = %d', 0
getaddr3:

;        esp -> [format3][a][ret] ;

         call _printf  ; printf("a = %d\n",a)
         add esp, 2*4  ; esp = esp + 8
;        esp -> [ret] ; zmienna a, adres format nie jest juz potrzebny

         push 0      ; esp -> [0][ret]
         call _exit  ; exit(0);







%ifdef COMMENT
Kompilacja:

nasm print2.asm -o print2.o -f win32

ld print2.o -o print2.exe c:\windows\system32\msvcrt.dll -m i386pe

lub:

nasm print2.asm -o print2.o -f win32

gcc print2.o -o print2.exe -m32
%endif