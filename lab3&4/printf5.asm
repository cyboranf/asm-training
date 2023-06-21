         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

a        equ 5  ; a = 5

         mov eax, a  ; eax = a

         call print  ; fastcall
addr:                ; return address

;        esp -> [ret]

         push 0          ; esp -> [0][ret]
         call [ebx+0*4]  ; exit(0);

print:

;        esp -> [addr][ret]

b        equ 9       ; b = 9
         push eax    ; eax -> stack
         mov eax, b  ; eax -> b
         push eax

;        esp -> [eax][eax][addr][ret]

         call getaddr  ; push on the stack the runtime address of format
format:
         db "b = %d", 0xA
         db "a = %d", 0xA, 0
getaddr:

;        esp -> [format][eax][addr][ret]

         call[ebx+3*4]  ; printf("a = %d\n", eax);
         add esp, 4*4   ; esp = esp + 16

;        esp -> [addr][ret]

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
