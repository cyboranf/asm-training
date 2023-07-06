         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

a        equ -4  ; a = -4

         mov eax, a  ; eax = -4

         push eax  ; eax -> stack

;        esp -> [eax][ret]

         call getaddr  ; push on the stack the runtime address of format and jump to getaddr
format:
         db "liczba = %d", 0xA, 0
getaddr:

;        esp -> [format][eax][ret]

         call[ebx+3*4]  ; printf
         add esp, 2*4   ; esp = esp +8

         mov eax, a  ; eax = a

         cmp eax, 0  ; eax = 0
         jl modul    ; jump if less

         push eax  ; eax -> stack

;        esp -> [eax][ret]

         call getaddr2  ; push on the stack the runtime address of format and jump to getaddr
format2:
         db "modul = %d", 0xA, 0
getaddr2:

;        esp -> [format2][eax][ret]

         call [ebx+3*4]  ; printf("Hello World!");
         add esp, 2*4    ; esp = esp + 8

;        esp -> [ret]

modul:
         neg eax   ; eax = -eax
         push eax  ; eax -> stack

;        esp -> [eax][ret]

         call getaddr3  ; push on the stack the runtime address of format and jump to getaddr
format3:
         db "modul = %d", 0xA, 0
getaddr3:

;        esp -> [format3][eax][ret]

         call [ebx+3*4]  ; printf
         add esp, 2*4    ; esp = esp+ 8

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
