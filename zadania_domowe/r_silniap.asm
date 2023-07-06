%ifdef COMMENT
silnia(n) = 0 * 1 * 2 * ... * n

0! = 1
n!! = n*(n-2)!

silnia(0) = 1
silnia(n) = n * silnia(n-2)

silnia(0) = 1
silnia(1) = 1
silnia(2) = 2
%endif

         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

n        equ 3

         mov ecx, n  ; ecx = n

         call silnia   ; eax = silnia(ecx) ; fastcall

addr:

;        esp -> [ret]

         push eax

;        esp -> [eax][ret]

         call getaddr
format:
         db "silnia = %i", 0xA, 0
getaddr:

;        esp -> [format][eax][ret]

         call [ebx+3*4]  ; printf("suma = %i\n", eax);
         add esp, 2*4    ; esp = esp + 8

;        esp -> [ret]

         push 0          ; esp -> [0][ret]
         call [ebx+0*4]  ; exit(0);

;        eax silnia(ecx)

silnia   cmp ecx, 2  ; ecx - 2           ; ZF affected
         jge rec     ; jump if greater or equal ; jump if SF == OF or ZF = 1
         mov eax, 1  ; eax = 1
         ret

rec      push ecx      ; ecx -> stack = n
         sub ecx, 2    ; ecx = ecx - 2 = n-2
         call silnia   ; eax = silnia(ecx) = silnia(n-2)
         pop ecx       ; ecx <- stack = n
         mul ecx       ; eax = eax * ecx = silnia(n-2) * n
         ret

;        mul arg  ; edx:eax = eax*arg

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
; To co funkcja zwr�ci jest w EAX.
; Po wywolaniu funkcji sciagamy argumenty ze stosu.
;
; https://gynvael.coldwind.pl/?id=387
