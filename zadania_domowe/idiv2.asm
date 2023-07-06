         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

a        equ -2147483650
b        equ -3

%define  UINT_MAX 4294967295

a_l      equ a % (UINT_MAX + 1)
a_h      equ a / (UINT_MAX + 1)

         mov eax, a_l  ; eax = a_l
         mov edx, a_h  ; edx = a_h
         
;        edx:eax = a

         mov ecx, b  ; ecx = b
         
         idiv ecx     ; eax = edx:eax / ecx  ; iloraz
                     ; edx = edx:eax % ecx  ; reszta

;        idiv arg     ; eax = edx:eax / arg  ; iloraz
                     ; edx = edx:eax % arg  ; reszta

         push edx  ; edx -> stack
         push eax  ; eax -> stack
         
;        esp -> [eax][edx][ret]

         call getaddr  ; push on the stack the runtime address of format and jump to getaddr
format:
         db 'iloraz = %d', 0xA
         db 'reszta = %d', 0xA, 0
getaddr:

;        esp -> [format][eax][edx][ret]

         call [ebx+3*4]  ; printf(format, eax, edx);
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
