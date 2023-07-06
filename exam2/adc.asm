         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

a        equ 40  ; a = 40
b        equ 29  ; b = 29

         clc  ; CF = 0

         mov eax, a  ; eax = a
         mov ecx, b  ; ecx = b

         adc eax, ecx  ; eax = eax + ecx + CF

         push eax  ; eax -> stack

;        esp -> [eax][ret]

         call getaddr  ; push on the stack the runtime address of format and jump to getaddr
format:
         db "eax + ecx + CF(clc) = %d", 0xA, 0
getaddr:

;        esp -> [format][eax][ret]

         call [ebx+3*4]  ; printf("eax + ecx + CF(clc) = %d");
         add esp, 2*4    ; esp = esp + 8

;        esp -> [ret]

         stc  ; CF = 1

         mov eax, a  ; eax = a
         mov ecx, b  ; ecx = b

         adc eax, ecx  ; eax = eax + ecx + CF

         push eax  ; eax -> stack

;        esp -> [eax][ret]

         call getaddr2  ; push on the stack the runtime address of format and jump to getaddr
format2:
         db "eax + ecx + CF(stc) = %d", 0xA, 0
getaddr2:

;        esp -> [format2][eax][ret]

         call [ebx+3*4]  ; printf("eax + ecx + CF(stc) = %d");
         add esp, 2*4    ; esp = esp + 8

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