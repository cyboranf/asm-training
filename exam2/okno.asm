         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

a        equ -6  ; a = 25

pprzedzialu  equ 18  ; pprzedzialu = 18
kprzedzialu  equ 99  ; kprzedzialu = 99

%ifdef COMMENT
* Liczby ze znakiem

         <  jl jnge       l less
         <= jng jle       g greater
         == je jz         e equal
         != jne jnz       n not
         >  jg jnle
         >= jnl jge
%endif

         mov ebp, ebx  ; ebp = ebx

         mov eax, a  ; eax = a

         cmp eax, pprzedzialu  ; eax = pprzedzialu ?
         jl nienalezy  ; jump if less to nienalezy
         cmp eax, kprzedzialu  ; eax = kprzedzialu ?
         jg nienalezy

         mov ecx, pprzedzialu  ; ecx = pprzedzialu
         mov edx, kprzedzialu  ; edx = kprzedzialu

         push edx  ; edx -> stack
         push ecx  ; ecx -> stack
         push eax  ; eax -> stack

;        esp -> [eax][ecx][edx][ret]

         call getaddr  ; push on the stack the runtime address of format and jump to getaddr
format:
         db "%d nalezy do [%d, %d]", 0xA, 0
getaddr:

;        esp -> [format][eax][ecx][edx][ret]

         call [ebp+3*4]  ; printf("%d nalezy do [%d, %d]");
         add esp, 4*4  ; esp = esp + 16

;        esp -> [ret]

         push 0          ; esp -> [0][ret]
         call [ebp+0*4]  ; exit(0);

nienalezy:
         mov ecx, pprzedzialu  ; ecx = pprzedzialu
         mov edx, kprzedzialu  ; edx = kprzedzialu

         push edx  ; edx -> stack
         push ecx  ; ecx -> stack
         push eax  ; eax -> stack

;        esp -> [format][eax][ecx][edx][ret]

          call getaddr2  ; push on the stack the runtime address of format and jump to getaddr
format2:
         db "%d nie nalezy do [%d, %d]", 0xA, 0
getaddr2:

;        esp -> [format][eax][ecx][edx][ret]

         call [ebx+3*4]  ; printf("%d nalezy do [%d, %d]");
         add esp, 4*4  ; esp = esp + 16

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
