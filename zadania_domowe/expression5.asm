         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

a        equ 4
b        equ 5
c        equ 6
d        equ 5

;        edi:esi = a*b
;        edx:eax = c*d

;        edi:esi
;      + edx:eax
;        -------
;        edx:eax

;        a*b + c*d = 4*5 + 6*5 = 50

         mov eax, a  ; eax = a
         mov ecx, b  ; ecx = b
         
         mul ecx  ; edx:eax = eax * ecx

;        mul arg  ; edx:eax = eax*arg

;        edx:eax = a*b

         mov edi, edx  ; edi = edx
         mov esi, eax  ; esi = eax
         
;        edi:esi = a*b

         mov eax, c  ; eax = a
         mov ecx, d  ; ecx = b
         
         mul ecx  ; edx:eax = eax*ecx
         
;        edx:eax = c*d
         
         add eax, esi  ; eax = eax + esi
         add edx, edi  ; edx = edx + edi
         
;        eax:edx = a*b + c*d

         push edx  ; edx -> stack
         push eax  ; eax -> stack

;        esp -> [eax][edx][ret]

         call getaddr  ; push on the stack the runtime address of format and jump to getaddr
format:
         db 'wynik = %llu', 0xA, 0
getaddr:

;        esp -> [format][eax][edx][ret]

         call [ebx+3*4]  ; printf('wynik = %u\n', eax);
         add esp, 3*4    ; esp = esp + 12

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
; To co funkcja zwr�ci jest w EAX.
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
