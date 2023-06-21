         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

         call getaddr  ; push on the stack the runtime address of format and jump to getaddr
format:
         db "liczba = ", 0
getaddr:

;        esp -> [format][ret]

         call [ebx+3*4]  ; printf("liczba = ");

;        esp -> [a][ret]

         push esp

;        esp -> [addr_a][a][ret]

         call getaddr2  ; push on the stack the runtime address of format and jump to getaddr
format2:
         db "%d", 0
getaddr2:

;        esp -> [format2][addr_a][a][ret]

         call [ebx+4*4]  ; scanf
         add esp, 2*4

;        esp -> [a][ret]

         mov edx, [esp]  ; edx = eax

         test [esp], edx
         jge nieujemna  ; jump if greater or equal

         neg edx

nieujemna:
          push edx  ; edx -> stack

;        esp -> [edx][a][ret]

         call getaddr3  ; push on the stack the runtime address of format and jump to getaddr
format3:
         db "modul = %d", 0xA, 0
getaddr3:

;        esp -> [format3][edx][a][ret]

         call [ebx+3*4]  ; printf
         add esp, 2*4

;        esp -> [a][ret]

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
