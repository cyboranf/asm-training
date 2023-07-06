    [bits 32]

          call getaddr123  ; push on the stack the runtime address of format and jump to getaddr
format123:
         db 'palindrom = ', 0
getaddr123:

;        esp -> [format123][ret]

         call [ebx+3*4]  ; printf('palindrom = ');
         add esp, 4      ; esp = esp + 4

get_input:
          call [ebx+2*4]  ; eax = getchar();
          cmp eax, 0xA    ; check if the character is a newline
          jz end_program  ; if newline, end the program


         push eax  ; eax -> stack

;        esp -> [eax][ret]

         call getaddr22  ; push on the stack the runtime address of format and jump to getaddr
format22:
        db '%c', 0
getaddr22:

;        esp -> [format22][eax][ret]

         call [ebx+3*4]  ; printf('ascii = %d\n', eax);
         add esp, 2*4    ; esp = esp + 8

;        esp -> [ret]

         jmp get_input   ; jump back to get_input to continue reading characters


end_program:

         call getaddr  ; push on the stack the runtime address of format and jump to getaddr

getaddr:

;        esp -> [format1][ret]

         mov ecx, 4  ; ecx = length

         shr ecx, 1  ; ecx = ecx >> 1 = ecx / 2

         jecxz done  ; jump if ecx is zero ; jump if ecx = 0

         mov esi, [esp]               ; esi = *(int*)esp = format
         lea edi, [esi + 4 - 1]  ; edi = format + length - 1

.loop:
         mov al, [esi]  ; al = *(char*)esi
         mov ah, [edi]  ; ah = *(char*)edi

         cmp al, ah  ; compare al and ah
         jne not_palindrome  ; jump if not equal

         inc esi  ; esi++
         dec edi  ; edi--

         loop .loop

         call getaddr1
format1:
        db "to jest palindrom", 0xA, 0
getaddr1:

;        esp -> [format1][ret]

         call [ebx+3*4]  ; printf(format);
         add esp, 4      ; esp = esp + 4

;        esp -> [ret]

         push 0          ; esp -> [0][ret]
         call [ebx+0*4]  ; exit(0);

not_palindrome:
         call getaddr2
format2:
         db " to nie jest palindrom", 0xA, 0
getaddr2:

;        esp -> [format][ret]

         call [ebx+3*4]  ; printf("to nie jest palindrom\n");
         add esp, 4      ; esp = esp + 4

;        esp -> [ret]

         push 0          ; esp -> [0][ret]
         call [ebx+0*4]  ; exit(0);
done:
         call   getaddr3
format3:
         db " to jest palindrom", 0xA, 0
getaddr3:

;        esp -> [format][ret]

         call [ebx+3*4]  ; printf("Hello world!\n");
         add esp, 4      ; esp = esp + 4

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
