         [bits 32]

%ifdef COMMENT

       INT_MIN = -2147483648
       INT_MAX = 2147483647

%endif

a        equ -2147483648
b        equ -1

;        edx:eax
;        edi:esi +
;        -------
;        edi:esi

         mov eax, a  ; eax = a

         cdq  ; edx:eax = eax  ; signed conversion

         mov edi, edx  ; edi = edx
         mov esi, eax  ; esi = eax
         
         mov eax, b  ; eax = b
         
         cdq  ; edx:eax = eax  ; signed conversion
         
         add esi, eax  ; esi = esi + eax
         adc edi, edx  ; edi = edi + edx + CF

         push edi  ; edi -> stack
         push esi  ; esi -> stack

;        esp -> [esi][edi][ret]

         call getaddr  ; push on the stack the runtime address of format and jump to getaddr
format:
         db 'suma = %lld', 0xA, 0
getaddr:

;        esp -> [format][esi][edi][ret]

         call [ebx+3*4]  ; printf('suma = %llu\n', edi:esi);
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
