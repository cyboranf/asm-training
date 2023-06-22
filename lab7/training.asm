         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

         call getaddr  ; push on the stack the runtime address of format and jump to getaddr
format:
         db "Podaj liczbe n = ", 0
getaddr:

;        esp -> [a][ret]

         call [ebx+3*4]

         push esp

;        esp -> [addr_a][a][ret]

         call getaddr2  ; push on the stack the runtime address of format and jump to getaddr
format2:
         db "%d", 0
getaddr2:

;        esp -> [format2][addr_a][a][ret]

         call [ebx+4*4]  ; scanf("%d");
         add esp, 2*4

;        esp -> [a][ret]

         mov eax, [esp]
         mov edx, 0
         mov ebp, 10

         div ebp     ; eax = edx:eax / ebp  ; iloraz
                     ; edx = edx:eax % ebp  ; reszta

;        div arg     ; eax = edx:eax / arg  ; iloraz
                     ; edx = edx:eax % arg  ; reszta


         push eax  ; eax -> stack

;        esp -> [eax][a][ret]

         call getaddr3  ; push on the stack the runtime address of format and jump to getaddr
format3:
         db "wynik dzielenia = %d", 0, 0xA
getaddr3:

;        esp -> [format3][eax][a][ret]

         call [ebx+3*4]  ; printf
         add esp, 2*4

;        esp -> [a][ret]

         add esp, 4

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