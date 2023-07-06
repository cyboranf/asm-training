         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

a        equ 15  ; a = 15

pprzedzialu1  equ 5   ; pprzedzialu1 = 5
kprzedzialu1  equ 19  ; kprzedzialu1 = 19

pprzedzialu2  equ 12  ; pprzedzialu2 = 12
kprzedzialu2  equ 24  ; kprzedzialu2 = 24

%ifdef COMMENT

Napisz program okna.asm sprawdzaj¹cy, czy liczba x nale¿y do przedzia³u (a,b) lub (c,d). Dane wejœciowe podajemy jako sta³e. Przyk³adowe dwie sesje:

15 nalezy do (5, 19)
15 nalezy do (12, 24)

3 nie nalezy do (5, 19) i (12, 24)

%endif

%ifdef COMMENT
* Liczby ze znakiem

         <  jl jnge       l less
         <= jng jle       g greater
         == je jz         e equal
         != jne jnz       n not
         >  jg jnle
         >= jnl jge

%endif

sprawdz:
         mov eax, a  ; eax = a

         cmp eax, pprzedzialu1  ; eax = pprzedzialu1 ?
         jge mozeNalezy1  ; jump if greater or equa; to mozeNalezy1

mozeNalezy1:
         cmp eax, kprzedzialu1  ; eax = kprzedzialu1 ?
         jle nalezy1  ; jump if less

         mov ecx, pprzedzialu1  ; ecx = pprzedzialu1
         mov edx, kprzedzialu1  ; edx = kprzedzailu1

         push edx  ; edx -> stack
         push ecx  ; ecx -> stack
         push eax  ; eax -> stack

;        esp -> [eax][ecx][edx][ret]

         call getaddr  ; push on the stack the runtime address of format and jump to getaddr
format:
         db "%d nie nalezy do (%d, %d)", 0xA, 0
getaddr:

;        esp -> [format][eax][ecx][edx][ret]

         call[ebx+3*4]  ; printf("%d nie nalezy do (%d, %d)");
         add esp, 4*4   ; esp = esp+16

;        esp -> [ret]

         mov eax, a  ; eax = a
         cmp eax, pprzedzialu2  ; eax = pprzedzialu2 ?
         jge mozeNalezy2

mozeNalezy2:
         cmp eax, kprzedzialu2  ; eax = kprzedzialu2 ?
         jle nalezy2  ; jump if less or equal to nalezy 2

         mov ecx, pprzedzialu2  ; ecx = pprzedzialu2
         mov edx, kprzedzialu2  ; edx = kprzedzialu2

         push edx  ; edx -> stack
         push ecx  ; ecx -> stack
         push eax  ; eax -> stack

;        esp -> [eax][ecx][edx][ret]

         call getaddr1  ; push on the stack the runtime address of format and jump to getaddr
format1:
         db "%d nie nalezy do (%d, %d)", 0xA, 0
getaddr1:

;        esp -> [format1][eax][ecx][edx][ret]

         call [ebx+3*4]  ; printf
         add esp, 4*4    ; esp = esp + 16

nalezy2:
         mov ecx, pprzedzialu2  ; ecx = pprzedzialu2
         mov edx, kprzedzialu2  ; edx = kprzedzialu2

         push edx  ; edx -> stack
         push ecx  ; ecx -> stack
         push eax  ; eax -> stack

;        esp -> [eax][ecx][edx][ret]

         call getaddr2  ; push on the stack the runtime address of format and jump to getaddr
format2:
         db "%d nalezy do (%d, %d)", 0xA, 0
getaddr2:

;        esp -> [format2][eax][ecx][edx][ret]

         call[ebx+3*4]  ; print("%d nalezy do (%d, %d)");
         add esp, 4*4   ; esp = esp + 16

;        esp -> [ret]

         push 0          ; esp -> [0][ret]
         call [ebx+0*4]  ; exit(0);

nalezy1:
         mov ecx, pprzedzialu1  ; ecx = pprzedzialu1
         mov edx, kprzedzialu1  ; edx = kprzedzialu1

         push edx  ; edx -> stack
         push ecx  ; ecx -> stack
         push eax  ; eax -> stack

;        esp -> [eax][ecx][edx][ret]

         call getaddr3  ; push on the stack the runtime address of format and jump to getaddr
format3:
         db "%d nalezy do (%d, %d)", 0xA, 0
getaddr3:

;        esp -> [format3][eax][ecx][edx][ret]

         call [ebx+3*4]  ; printf("%d nalezy do (%d, %d)");
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
