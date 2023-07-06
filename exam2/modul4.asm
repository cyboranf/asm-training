         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

         call getaddr  ; push on the stack the runtime address of format and jump to getaddr
format:
         db "liczba = ", 0
getaddr:

;        esp -> [format][ret]

         call [ebx+3*4]  ; printf("liczba = ");

;        esp -> [a][ret]

         push esp  ; esp -> stack

;        esp -> [addr_a][a][ret]

         call getaddr2  ; push on the stack the runtime address of format and jump to getaddr
format2:
         db "%d", 0
getaddr2:

;        esp -> [format2][addr_a][a][ret]

         call [ebx+4*4]  ; scanf
         add esp, 2*4    ; esp = esp + 8

;        esp -> [a][ret]

         mov eax, [esp]  ; eax = esp

         test eax, eax  ; eax = eax ?
         jl modul

         push eax  ; eax -> stack

;        esp -> [eax][a][ret]

         call getaddr3  ; push on the stack the runtime address of format and jump to getaddr
format3:
         db "modul = %d", 0xA, 0
getaddr3:

;        esp -> [format3][eax][a][ret]

         call [ebx+3*4]  ; printf
         add esp, 3*4    ; esp = esp+12

;        esp -> [ret]

         push 0          ; esp -> [0][ret]
         call [ebx+0*4]  ; exit(0);

modul:
         mov eax, [esp]  ; eax = [esp] = a
         neg eax  ; eax = -eax

         push eax  ; eax -> stack

;        esp -> [eax][a][ret]

         call getaddr4  ; push on the stack the runtime address of format and jump to getaddr
format4:
         db "modul = %d", 0xA, 0
getaddr4:

;        esp -> [format4][eax][a][ret]

         call [ebx+3*4]  ; printf
         add esp, 3*4    ; esp = esp+12

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
