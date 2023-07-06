         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

a        equ 4
b        equ -5
c        equ 6
d        equ -2

;        a*b + c*d = 4*(-5) + 6*(-2) = -32

;        edx:eax
;      + edi:esi
;        -------
;        edi:esi

         mov eax, a  ; eax = a
         mov ecx, b  ; ecx = b
         
         imul ecx  ; edx:eax = eax * ecx
         
;        edx:eax = a*b

         mov edi, edx  ; edi = edx
         mov esi, eax  ; esi = eax
         
;        edi:esi = a*b

         mov eax, c  ; eax = c
         mov ecx, d  ; ecx = d

         imul ecx  ; edx:eax = eax * ecx

;        imul arg  ; edx:eax = eax*arg

;        edx:eax = c*d

         add esi, eax  ; esi = esi + eax
         adc edi, edx  ; edi = edi + edx + CF

;        edi:esi = a*b + c*d

         push edi  ; edi -> stack
         push esi  ; esi -> stack

;        esp -> [esi][edi][ret]

         call getaddr  ; push on the stack the runtime address of format and jump to getaddr
format:
         db 'wynik = %lld', 0xA, 0
getaddr:

;        esp -> [format][esi][edi][ret]

         call [ebx+3*4]  ; printf('wynik = %lld\n', edi:esi);
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
