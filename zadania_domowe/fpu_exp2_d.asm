         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

a        equ __?float64?__(4.0)
b        equ __?float64?__(2.0)
c        equ __?float64?__(3.0)
d        equ __?float64?__(5.0)

;        a*b + c*d = 4*2 + 3*5 = 23

         sub esp, 2*4  ; esp = esp - 8 ; make room for double type result

;        esp -> [ ][ ][ret]

         call getaddr  ; get the runtime address of format

format   db "wynik = %f", 0xA, 0
length   equ $ - format

addr_a   dq a  ; a  ; define double word
addr_b   dq b  ; b
addr_c   dq c  ; c
addr_d   dq d  ; d

getaddr:

;        esp -> [format][ ][ret]

         finit  ; fpu init

;        st = []

         mov eax, [esp]   ; eax = *(int*)esp = format
         add eax, length  ; eax = eax + length = format + length = addr_a

         fld qword [eax]    ; *(double*)eax = *(double*)addr_a = a -> st      ; fpu load double
         fld qword [eax+8]  ; *(double*)(eax+5) = *(double*)addr_b = b -> st  ; fpu load double

;        st = [st0, st1] = [b, a]  ; fpu stack

;        faddp stn  ; stn = stn + st0 i zdejmij
;        fmulp stn  ; stn = stn * st0 i zdejmij
         fmulp st1  ; [st0, st1] => [st0, st1*st0] => [st1*st0] = [a*b]

         fld qword [eax+16]  ; *(int*)(eax+8) = *(int*)addr_c = c -> st  ; fpu load integer
         fld qword [eax+24] ; *(int*)(eax+12) = *(int*)addr_d = d -> st  ; fpu load integer

;        st = [st0, st1, st2] = [d, c, a*b]  ; fpu stack

         fmulp st1  ; [st0, st1, st2] => [st0, st1*st0, st2] => [st1*st0, st2] = [c*d, a*b]

;        st = [st0, st1] = [c*d, a*b]

         faddp st1  ; [st0, st1] => [st0, st1+st0] => [st1+st0] = [c*d+c*d]
         
;        st = [st0] = [c*d+c*d]

;                       +4
;        esp -> [format][ ][ret]

         fstp qword [esp+4]  ; *(int*)(esp+4) <- st = [a+b*c]  ; fpu store integer
                                                                ; and pop fpu stack
;        st = []  ; fpu stack

         call [ebx+3*4]  ; printf("wynik = %d\n", *(int*)(esp+4));
         add esp, 2*4    ; esp = esp + 8

;        esp -> [ret]

         push 0         ; esp -> [0][ret]
         call [ebx+0*4] ; exit(0);

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