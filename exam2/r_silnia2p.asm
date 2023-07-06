         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

%ifdef COMMENT
silnia(n) = 0 * 1 * 2 * ... * n

0! = 1
n!! = n*(n-2)!

silnia(0) = 0
silnia(n) = n * silnia(n-1)

silnia(0) = 1
silnia(1) = 1
silnia(2) = 2
%endif

n        equ 4  ; n = 3

         mov ecx, n  ; ecx = n

         call silnia
         
addr:
         
         push eax  ; eax -> stack
         
;        esp -> [eax][ret]

         call getaddr  ; push on the stack the runtime address of format and jump to getaddr
format:
         db "wynik = %i", 0xA, 0
getaddr:

;        esp -> [format][eax][ret]

         call [ebx+3*4]  ; printf("Hello World!");
         add esp, 2*4

;        esp -> [ret]

         push 0          ; esp -> [0][ret]
         call [ebx+0*4]  ; exit(0);

silnia:
       cmp ecx, 2  ; ecx = 2
       jge rec
       mov eax, 1  ; eax = 1
       ret

rec:
       sub ecx, 2  ; ecx = ecx - 2
       call silnia
       add ecx, 2  ; ecx = ecx + 2  
       mul ecx
       ret



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
