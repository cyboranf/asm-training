         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

x        equ 25
a        equ 18
b        equ 99

         mov eax, x  ; eax = x
         mov ecx, a  ; ecx = a
         mov edx, b  ; edx = b

         push b  ; edx -> stack
         push a  ; ecx -> stack
         push x  ; eax -> stack

;        esp -> [eax][ecx][edx][ret]

 %ifdef COMMENT
* Liczby ze znakiem

         <  jl jnge       l less
         <= jng jle       g greater
         == je jz         e equal
         != jne jnz       n not
         >  jg jnle
         >= jnl jge
%endif
         cmp eax, ecx  ; eax - ecx                  ; OF SF ZF AF PF CF affected
         jl nie  ; jump if less

         cmp eax, edx  ; eax - edx
         jg nie
         
         call getaddr  ; push on the stack the runtime address of format and jump to getaddr
format:
         db '%d nalezy do [%d, %d]', 0xA, 0
getaddr:
;        esp -> [format][eax][ecx][edx][ret]

         call [ebx+3*4]  ; printf(format, eax, ecx, edx);
         add esp, 4*4    ; esp = esp + 16
         
;        esp -> [ret]
         
         jmp koniec

nie:
;        esp -> [eax][ecx][edx][ret]

         call getaddr2  ; push on the stack the runtime address of format and jump to getaddr
format2:
          db '%d nie nalezy do [%d, %d]', 0xA, 0
getaddr2:
;        esp -> [format2][eax][ecx][edx][ret]

         call [ebx+3*4]  ; printf(format, eax, ecx, edx);
         add esp, 4*4    ; esp = esp + 16

;        esp -> [ret]

koniec:
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
