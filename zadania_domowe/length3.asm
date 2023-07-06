         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

x        equ __?float64?__(10.0)

         sub esp, 2*4  ; esp = esp - 8 ; make room for double type result

;        esp -> [ ][ ][ret]

         call getaddr  ; get the runtime address of format

format   db "liczba cyfr = %f", 0xA, 0
length   equ $ - format

addr_y   dq 1.0  ; y  ; define quad word
addr_x   dq x    ; x

getaddr:

;        esp -> [format][ ][ ][ret]

         finit  ; fpu init

;        st = []

         mov eax, [esp]   ; eax = *(int*)esp = format
         add eax, length  ; eax = eax + length = format + length = addr_y

         fld qword [eax]  ; *(double*)eax = *(double*)addr_y = 1.0 -> st  ; fpu load floating-point

;        st = [st0] = [1.0]  ; fpu stack

         fldlg2  ; log10(2) -> st
         
;        st = [st0, st1] = [log10(2), 1.0]  ; fpu stack

         fld qword [eax]  ; *(double*)eax = *(double*)addr_y = 1.0 -> st  ; fpu load floating-point

;        st = [st0, st1, st2] = [1.0, log10(2), 1.0]  ; fpu stack

         fld qword [eax+8]  ; *(double*)(eax+8) = *(double*)addr_x = x -> st  ; fpu load floating-point

;        st = [st0, st1, st2, st3] = [x, 1.0, log10(2), 1.0]  ; fpu stack
             
         ftst  ; st0 - 0 ; C1=0 C0 C2 C3 affected ; fpu test st0

         fstsw ax  ; ax = fpu_status_word ; fpu store status word

         sahf  ; eflags(SF:ZF:0:AF:0:PF:1:CF) = ah

         jz zero  ; jump if zero ; jump if ZF = 1

         fabs  ; st = [st0, st1, st2, st3] = [|x|, 1.0, log10(2), 1.0]

;        fyl2x  ; st(1) := st(1)*log2[st(0)] i zdejmij
         fyl2x  ; [st0, st1, st2, st3] => [st0, st1*log2(st(0)), st2, st3] => [st1*log2(st(0)), st2, st3] = [log2(x), st2, st3]

;        st = [st0, st1, st2] = [log2(x), log10(2), 1.0]

;        fmulp stn  ; stn = stn * st0 i zdejmij
         fmulp st1  ; [st0, st1, st2] => [st0, st1*st0, st2] => [st1*st0, 1.0] = [log10(x), 1.0]

;        st = [st0, st1] = [log10(x), 1.0]

         frndint  ; st(0) = (int)st(0)  ; rzutowanie na int
         
         faddp st1  ; st1 = st1 + st0 i zdejmij

;        st = [st0] = [(int)log10(|x|) + 1.0]
         jmp koniec

zero:    finit  ; fpu init

;        st = []

         fldz
koniec:
;                       +4
;        esp -> [format][ ][ ][ret]
 
         fstp qword [esp+4]  ; *(double*)(esp+4) <- st = [log10(x)]  ; fpu store top element
                                                                     ; and pop fpu stack
;        st = []  ; fpu stack

         call [ebx+3*4]  ; printf("log10 = %f\n", *(double*)(esp+4));
         add esp, 3*4    ; esp = esp + 12

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