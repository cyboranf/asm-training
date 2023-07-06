         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

a        equ 4
b        equ 2
c        equ 3
d        equ 5

;        a*b + c*d = 4*2 + 3*5 = 23

         sub esp, 1*4  ; esp = esp - 8 ; make room for double type result

;        esp -> [ ][ret]

         call getaddr  ; get the runtime address of format

format   db "wynik = %d", 0xA, 0
length   equ $ - format

addr_a   dd a  ; a  ; define double word
addr_b   dd b  ; b
addr_c   dd c  ; c
addr_d   dd d  ; d

getaddr:

;        esp -> [format][ ][ret]

         finit  ; fpu init

;        st = []

         mov eax, [esp]   ; eax = *(int*)esp = format
         lea eax, [eax + length]  ; eax = eax + length = format + length = addr_a

         fild dword [eax]    ; *(int*)eax = *(int*)addr_a = a -> st      ; fpu load integer
         fild dword [eax+4]  ; *(int*)(eax+5) = *(int*)addr_b = b -> st  ; fpu load integer
         
;        st = [st0, st1] = [b, a]  ; fpu stack
         
;        faddp stn  ; stn = stn + st0 i zdejmij
;        fmulp stn  ; stn = stn * st0 i zdejmij
         fmulp st1  ; [st0, st1] => [st0, st1*st0] => [st1*st0] = [a*b]
         
         fild dword [eax+8]  ; *(int*)(eax+8) = *(int*)addr_c = c -> st  ; fpu load integer
         fild dword [eax+12] ; *(int*)(eax+12) = *(int*)addr_d = d -> st  ; fpu load integer

;        st = [st0, st1, st2] = [d, c, a*b]  ; fpu stack


         fmulp st1  ; [st0, st1, st2] => [st0, st1*st0, st2] => [st1*st0, st2] = [c*d, a*b]

;        st = [st0, st1] = [c*d, a*b]

         faddp st1  ; [st0, st1] => [st0, st1+st0] => [st1+st0] = [c*d+c*d]
         
;        st = [st0] = [c*d+c*d]

;                       +4
;        esp -> [format][ ][ret]

         fistp dword [esp+4]  ; *(int*)(esp+4) <- st = [a+b*c]  ; fpu store integer
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