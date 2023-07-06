         [bits 32]

extern   _printf
extern   _scanf
extern   _exit

global   _main

section  .text

_main:

;        esp -> [ret]  ; return address

         push format   ; *(int*)(esp-4) = format ; esp = esp - 4

;        esp -> [format][ret]

         call _printf  ; printf("a = ");
         
;        esp -> [a][ret]

         push esp  ; esp -> stack
         
;        esp -> [addr_a][a][ret]

         push format2
         
;        esp -> [format2][addr_a][a][ret]

         call _scanf     ; scanf(format2, addr_a)
         add esp, 2*4    ; esp = esp + 8
         
;        esp -> [a][ret]

         push format3
         
;        esp -> [format3][a][ret]

         call _printf  ; printf("a = %d\n", a)
         add esp, 2*4    ; esp = esp + 8
;        esp -> [ret]

         push 0       ; esp -> [0][ret]
         call _exit   ; exit(0);
         
format   db "a = ", 0
format2  db "%d", 0
format3  db "a = %d", 0xA, 0


%ifdef COMMENT
Kompilacja:

nasm scanf2.asm -o scanf2.o -f win32

ld scanf2.o -o scanf2.exe c:\windows\system32\msvcrt.dll -m i386pe

lub:

nasm scanf2.asm -o scanf2.o -f win32

gcc scanf2.o -o scanf2.exe -m32
%endif
