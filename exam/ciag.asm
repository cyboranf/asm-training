         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

a        equ -5
b        equ 7

         mov eax, a
         mov edx, b

         cmp eax, edx
         jl  opcja2

         push edx
         push eax

         jmp print

opcja2:
         push eax
         push edx

print:

         call getaddr  ; push on the stack the runtime address of format and jump to getaddr
format:
          db '%d %d', 0xA, 0
getaddr:

;        esp -> [format][ret]

         call [ebx+3*4]  ; printf('Hello World!\n');
         add esp, 3*4      ; esp = esp + 4

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
