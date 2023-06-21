         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

a        equ 5   ; a = 5
b        equ -9  ; b = -9

         mov eax, a  ; eax = a

         clc  ; CF = 0

         sbb eax, b  ; eax = eax - b - CF

         push eax  ; eax -> stack
         
;        esp -> [eax][ret]

         call getaddr  ; push on the stack the runtime address of format and jump to getaddr
format:
         db "Roznica = %d", 0xA, 0
getaddr:

;        esp -> [format][eax][ret]

         call [ebx+3*4]  ; printf("Roznica = %d", eax);

;        esp -> [ret]

         mov eax, a  ; eax = a

         stc  ; CF = 1

         sbb eax, b  ; eax = eax - b - CF

         push eax  ; eax -> stack
         
;        esp -> [eax][ret]

         call getaddr2
format2:
         db "Roznica = %d", 0xA, 0
getaddr2:

;        esp -> [format][eax][ret]

         call [ebx+3*4]  ; printf("Roznica = %d", eax);

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
; To co funkcja zwr�ci jest w EAX.
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
