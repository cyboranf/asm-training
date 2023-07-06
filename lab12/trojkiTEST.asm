         [bits 32]

n        equ 13
         
         mov eax, n

         mov ecx, 1  ; a = 1 (odpowiednik a z programu .c)
         mov esi, 1
         mov edx, 1

.not_found:
;        Increment c and loop
         inc esi  ; Increment a and loop
         cmp esi, eax
         jle .loop_c
         inc edx  ; Increment b and loop
         cmp edx, eax
         jl .loop_b
         inc ecx  ; Increment a and loop
         cmp ecx, eax
         jl .loop_a
         
.loop_a:
         mov edx, ecx  ; b = a
         add edx, 1    ; b = a + 1

.loop_b:
         mov esi, edx  ; c = b
         add esi, 1    ; b = a + 1

.loop_c:
         mov eax, ecx   ; Check if a*a + b*b  == c*c
         imul eax, eax  ; eax = a*a
         mov edi, edx   ; <- Zmiana z ebx na edi
         imul edi, edi  ; edi = b*b
         add eax, edi   ; eax = a*a
         mov edi, esi   ; <- Zmiana z ebx na edi
         imul edi, edi  ; edi = c*c
         cmp eax, edi
         jne .not_found

;        Print the triple
         push esi  ; push c on the stack
         push edx  ; push b on the stack
         push ecx  ; push a on the stack

         call getaddr4
format4:
         db "%d %d %d", 0xA, 0
getaddr4:
         call [ebx+3*4]  ; printf ("%d %d %d\n", a, b, c);
         add esp, 4*4    ; Clean up the stack

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
