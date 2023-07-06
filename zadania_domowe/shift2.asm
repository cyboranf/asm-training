          [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

         mov ebp, ebx  ; ebp = ebx
         
         mov ebx, 1
         mov edx, 2
         
         mov eax, ebx  ; eax = ebx
         mov ebx, edx  ; ebx = edx
         add edx, eax
         
         push edx

         call getaddr  ; push on the stack the runtime address of format and jump to getaddr
format:
         db "wynik = %d", 0xA, 0
getaddr:

;        esp -> [format][ret]

         call [ebp+3*4]  ; printf("Hello World!");

;        esp -> [ret]

         push 0          ; esp -> [0][ret]
         call [ebp+0*4]  ; exit(0);

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
