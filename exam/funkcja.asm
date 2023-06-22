         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

a        equ __?float64?__(2.1)
b        equ __?float64?__(3.3)
x        equ __?float64?__(5.2)

         call getaddr  ; push on the stack the runtime address of format and jump to getaddr
addr_x   dq x
addr_a   dq a
addr_b   dq b
getaddr:
         finit

         mov eax, [esp]
         fld qword [eax]
         fld qword [eax+8]

         fmul

         fld qword [eax+16]
         
         fadd
         
         fstp qword [esp]

         call getaddr2
format   db "wynik =  %0.2f", 0xA, 0
getaddr2:

;        esp -> [format][ret]

         call [ebx+3*4]  ; printf('Hello World!\n');
         add esp, 2*4      ; esp = esp + 4

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
