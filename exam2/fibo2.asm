         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

%ifdef COMMENT
0   1   2   3   4   5   6    indeksy

a   b   d
|---|---|
1   1   2   3   5   8   13   wartosci
    |---|---|
    a   b   d

Przesuniecie ramki:

a = b              ; a = 1
b = d              ; b = 2
d = a + b = d + a  ; d = 2 + 1 = 3
%endif

a        equ 1  ; a = 1
b        equ 1  ; b = 1

n        equ 5  ; n = 5  ; n-ty wyraz ciagu Fibo

         mov ebp, ebx  ; ebp = ebx



         mov esi, 1  ; esi = 0
         mov eax, a  ; eax = a
         mov ebx, b  ; ebx = b
         mov edx, 2
petla:

         inc esi  ; esi ++
         mov eax, ebx
         mov ebx, edx
         add edx, eax

         cmp esi, n-1  ; esi = n ?
         jne petla   ;jump if not equal to petla

         push edx  ; edx -> stack
         
;        esp -> [edx][ret]

         call getaddr  ; push on the stack the runtime address of format and jump to getaddr
format:
         db "Fibo = %d", 0xA, 0
getaddr:

;        esp -> [format][edx][ret]

         call [ebp+3*4]  ; printf("Hello World!");

;        esp -> [ret]

         push 0          ; esp -> [0][ret]
         call [ebp+0*4]  ; exit(0);

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
