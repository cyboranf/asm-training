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

         mov eax, [esp]  ; eax = a
         mov edx, eax    ; edx = eax

         test eax, eax  ;                  ; OF SF ZF AF PF CF affected
         jge nieujemna  ; jump if greater or equal ; jump if SF == OF or ZF = 1

         neg edx  ; edx = -edx
         
nieujemna:

         push edx  ; edx -> stack
         push eax  ; eax -> stack
         
;        esp -> [eax][edx][ret]

         push format3
         

         
;        esp -> [format3][eax][edx][ret]

         call _printf  ; printf(format, eax, edx)
         add esp, 2*4  ; esp = esp + 8
;        esp -> [ret]

         push 0       ; esp -> [0][ret]
         call _exit   ; exit(0);
         
format   db "a = ", 0
format2  db "%d", 0
format3  db 'Liczba = %d', 0xA
         db 'Modul = %d', 0xA, 0


%ifdef COMMENT
Kompilacja:

nasm modul4.asm -o modul4.o -f win32

ld modul4.o -o modul4.exe c:\windows\system32\msvcrt.dll -m i386pe

lub:

nasm modul4.asm -o modul4.o -f win32

gcc modul4.o -o modul4.exe -m32
%endif
