         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

a        equ 2  ; a = 2
b        equ 3  ; b = 3
c        equ 8  ; c = 8

         mov eax, b  ; eax = b
         mov edx, c  ; edx = c

         mul edx

         mov ecx, a  ; ecx = a

         add eax, ecx  ; eax += ecx

         push eax  ; eax -> stack

;        esp -> [eax][ret]

         call getaddr  ; push on the stack the runtime address of format and jump to getaddr
format:
         db "wynik = %u", 0xA, 0
getaddr:

;        esp -> [format][eax][ret]

         call [ebx+3*4]  ; printf("wynik = %d", eax);

;        esp -> [ret]

         push 0          ; esp -> [0][ret]
         call [ebx+0*4]  ; exit(0);

; asmloader API
;
; ESP wskazuje na prawidlowy stos
; argumenty funkcji wrzucamy na stos
; EBX zawiera pointer na tablice API
;
; call [ebx + NR_FUNKCJI*4] ; wywolanie funkcji API
;
; NR_FUNKCJI:
;
; 0 - exit
; 1 - putchar
; 2 - getchar
; 3 - printf
; 4 - scanf
;
; To co funkcja zwróci jest w EAX.
; Po wywolaniu funkcji sciagamy argumenty ze stosu.
;
; https://gynvael.coldwind.pl/?id=387

%ifdef COMMENT

ebx    -> [ ][ ][ ][ ] -> exit
ebx+4  -> [ ][ ][ ][ ] -> putchar
ebx+8  -> [ ][ ][ ][ ] -> getchar
ebx+12 -> [ ][ ][ ][ ] -> printf
ebx+16 -> [ ][ ][ ][ ] -> scanf

%endif
