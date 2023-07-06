%ifdef COMMENT

ax + b = 0

ax = -b

Z1: a == 0

0 = -b

b == 0  =>  x nalezy do R
b != 0  =>  x nalezy do zbioru pustego

Z2: a != 0

x = -b/a

%endif

         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

         call getaddr

addr_b   dd 4 ; -18.0 ; 1  ; b
addr_a   dd 2 ; -3.14 ; 2  ; a

getaddr:

;        esp -> [addr_b][ret]

         finit  ; fpu init

         mov eax, [esp]  ; eax = *(int*)esp = addr_b

         fild dword [eax]  ; *(int*)eax = *(int*)addr_b = b -> st ; fpu load integer

;        st = [st0] = [b]  ; fpu stack

         fild dword [eax+4]  ; *(int*)(eax+4) = *(int*)addr_a = a -> st ; fpu load integer

;        st = [st0, st1] = [a, b]  ; fpu stack

         ftst  ; st0 - 0 ; C1=0 C0 C2 C3 affected ; fpu test st0

         fstsw ax  ; ax = fpu_status_word ; fpu store status word

         sahf  ; eflags(SF:ZF:0:AF:0:PF:1:CF) = ah

         jz a_zero  ; jump if zero ; jump if ZF = 1

;        x = -b/a

         sub esp, 4  ; esp = esp - 4

;        esp -> [ ][ret]

         call getaddr2
wynik1:
         db "x = %d", 0xA, 0
getaddr2:

;                       +4
;        esp -> [wynik1][ ][ret]

         fdivp st1  ; [st0, st1] => [st0, st1/st0] => [st1/st0] = [b/a]

;        st = [st0] = [b/a]

         fchs  ; [st0] => [-st0] = [-b/a] ; fpu change sign

;        st = [st0] = [-b/a]

         fistp dword [esp+4]  ; *(int*)(esp+4) <- st = -b/a ; fpu store top element and pop fpu stack

;        st = []

         jmp print

a_zero   call getaddr3

wynik2   db "x nalezy do zbioru pustego", 0xA, 0
wynik3   db "x nalezy do R", 0xA, 0

getaddr3:

;        esp -> [wynik2][addr_b][ret]

         fcomi st0, st1  ; st0 - st1 ; ZF PF CF affected

         jz b_zero  ; jump if zero   ; jump if ZF = 1

;        x nalezy do zbioru pustego

         jmp print

;        x nalezy do R

b_zero   add dword [esp], wynik3 - wynik2  ; *(int*)esp = wynik3

;        esp -> [wynik3][addr_a][ret]

print    call [ebx+3*4] ; printf(...);

         push 0         ; esp -> [0][ret]
         call [ebx+0*4] ; exit(0);
