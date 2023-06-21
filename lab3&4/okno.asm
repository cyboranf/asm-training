         [bits 32]

dol      equ 18
gora     equ 99

;        esp -> [ret]  ; ret - adres powrotu do asmloader

         call getaddr  ; push on the stack the runtime address of format and jump to getaddr
format:
         db "Podaj liczbe a ja powiem ci czy nalezy ona do przedzialu [18, 99]: ", 0
getaddr:

;        esp -> [format][ret]

         call [ebx+3*4]  ; printf("Podaj liczbe a ja powiem ci czy nalezy ona do przedzialu [18, 99]: ");

;        esp -> [a][ret]

         push esp

;        esp -> [addr_a][a][ret]

         call getaddr2  ; push on the stack the runtime address of format and jump to getaddr
format2:
         db "%d", 0, 0xA
getaddr2:

;        esp -> [format2][addr_a][a][ret]

         call [ebx+4*4]  ; scanf("%d", a);
         add esp, 2*4

;        esp -> [a][ret]

         mov eax, [esp]

         cmp eax, dol
         jge wieksza1  ; jump if greater or equal
         jne koniec2

koniec2:
         call getaddr4  ; push on the stack the runtime address of format and jump to getaddr
format4:
         db "Liczba: %d, nie nalezy do przedzialu.", 0, 0xA
getaddr4:

;        esp -> [format4][a][ret]

         call [ebx+3*4]  ; printf("Liczba: %d, nie nalezy do przedzialu.", a);
         add esp, 2*4
         call konieckoniec

wieksza1:
         cmp eax, gora
         jle koniec1


koniec1:
         call getaddr3  ; push on the stack the runtime address of format and jump to getaddr
format3:
         db "Liczba: %d, nalezy do przedzialu.", 0, 0xA
getaddr3:

;        esp -> [format3][a][ret]

         call [ebx+3*4]  ; printf("Liczba: %d, nalezy do przedzialu.", a);
         add esp, 2*4

konieckoniec:
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
