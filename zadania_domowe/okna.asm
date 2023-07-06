         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

x        equ 12

a        equ 5
b        equ 19

c        equ 12
d        equ 24

         mov eax, x  ; eax = x

 %ifdef COMMENT
* Liczby ze znakiem

         <  jl jnge       l less
         <= jng jle       g greater
         == je jz         e equal
         != jne jnz       n not
         >  jg jnle
         >= jnl jge
%endif

         cmp eax, a  ; eax - a                  ; OF SF ZF AF PF CF affected
         jl pierwszynie  ; jump if less

         cmp eax, b  ; eax - b
         jg pierwszynie  ; jump if greater
         
         ;nalezy do pierwszego
         push b  ; b -> stack
         push a  ; a -> stack
         push eax  ; eax -> stack

;        esp -> [eax][a][b][ret]

         call getaddr  ; push on the stack the runtime address of format and jump to getaddr
format:
         db '%d nalezy do [%d, %d]', 0xA, 0
getaddr:
;        esp -> [format][eax][a][b][ret]

         call [ebx+3*4]  ; printf(format, eax, a, b);
         add esp, 4*4    ; esp = esp + 16
         
;        esp -> [ret]

         mov eax, x
         push d  ; d -> stack
         push c  ; c -> stack
         push eax  ; eax -> stack

;        esp -> [eax][c][d][ret]

         ;czy drugi tez
         cmp eax, c  ; eax - c
         jl drugijuznie
         
         cmp eax, d  ; eax - d
         jg drugijuznie

         ; drugi tez nalezy  

         call getaddr2  ; push on the stack the runtime address of format and jump to getaddr
format2:
         db '%d nalezy do [%d, %d]', 0xA, 0
getaddr2:
;        esp -> [format2][eax][c][d][ret]

         call [ebx+3*4]  ; printf(format2, eax, c, d);
         add esp, 4*4    ; esp = esp + 16
         
;        esp -> [ret]

         jmp koniec

drugijuznie:
;        esp -> [eax][c][d][ret]

         call getaddr3  ; push on the stack the runtime address of format and jump to getaddr
format3:
          db '%d nie nalezy do [%d, %d]', 0xA, 0
getaddr3:
;        esp -> [format3][eax][c][d][ret]

         call [ebx+3*4]  ; printf(format, eax, ecx, edx);
         add esp, 4*4    ; esp = esp + 16

;        esp -> [ret]
         jmp koniec

pierwszynie:
;        esp -> [ret]

         ;jedyna nadzieja w drugim

         cmp eax, c  ; eax - c
         jl zaden

         cmp eax, d  ; eax - d
         jg zaden
         
         ; pierwszy nie, drugi tak

         push d  ; d -> stack
         push c  ; c -> stack
         push eax
         push b  ; b -> stack
         push a  ; a -> stack
         push eax  ; eax -> stack

;        esp -> [eax][a][b][eax][c][d][ret]

         call getaddr5  ; push on the stack the runtime address of format and jump to getaddr
format5:
          db '%d nie nalezy do [%d, %d]', 0xA
          db '%d nalezy do [%d, %d]', 0xA, 0
getaddr5:
;        esp -> [format5][eax][a][b][eax][c][d][ret]

         call [ebx+3*4]  ; printf(format, eax, ecx, edx);
         add esp, 6*4    ; esp = esp + 24

;        esp -> [ret]

         jmp koniec

zaden:
         push d  ; d -> esp
         push c  ; c -> esp
         push b  ; b -> esp
         push a  ; a -> esp
         push eax  ;  eax -> esp

;        esp -> [eax][a][b][c][d][ret]

         call getaddr6
format6:
         db '%d nie nalezy do (%d, %d) i (%d, %d)', 0xA, 0
getaddr6:
;        esp -> [format6][eax][a][b][c][d][ret]

         call [ebx+3*4]  ; printf(format, eax, a, b, c, d);
         add esp, 6*4    ; esp = esp + 24

koniec:
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
