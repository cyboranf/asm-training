         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

x        equ __?float64?__(10.0)

         sub esp, 2*4

         call getaddr  ; push on the stack the runtime address of format and jump to getaddr
format   db "liczba cyfr = %f", 0xA, 0
length   equ $ - format

addr_y   dq 1.0
addr_x   dq x
getaddr:

;        esp -> [format][][][ret]

         finit
         
         mov eax, [esp]
         add eax,length
         
         fld qword [eax]

         fldlg2
         
         fld qword [eax]

         fld qword [eax+8]

         ftst
         
         fstsw ax
         
         sahf
         
         jz zero
         
         fabs
         
         fyl2x
         
         fmulp st1
         
         frndint
         
         faddp st1
         
         jmp koniec
         
zero     : finit

         fldz

koniec:
       fstp qword [esp+4]

         call [ebx+3*4]  ; printf("Hello World!");

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
