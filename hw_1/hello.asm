; ----------------------------------------------------------------------------------------
; Writes "Hello, World" to the console using only system calls. Runs on 64-bit Linux only.
; To assemble and run:
;     nasm -felf64 hello.asm && ld hello.o && ./a.out
; View all syscalls here:
;		/usr/include/asm-generic/unistd.h
; ----------------------------------------------------------------------------------------
; intel syntax
; op dst, src
; Improvements:
;  - Uses syscalls
;  - Outputs all of the input correctly

section .data                           ; data segment	
	in_mess db 'What is your name? '    ; query user message
	len_in_mess equ $-in_mess           ; length of the query message
	disp_mess db 'Hello,  '             ; inform user message
	len_disp_mess equ $-disp_mess       ; length of inform message

section .bss                            ; uninitialized data
	name resb 10                        ; declare uninitialized data; the user input that is at most 5 bytes
                                        ; resb is a pseudo-instruction in nasm that is equ for uninitialized data

section .text                           ; code segment
	global  _start

_start:
	; print query message write(1, message, 13)
	mov rax, 1                          ; system call number (sys_write)
	mov rdi, 1                          ; file handle (stdout)
	mov rsi, in_mess                    ; rsi should hold the string to printout
	mov rdx, len_in_mess                ; edx should hold the string length
	syscall	

	; read user input
	mov rax, 0                          ; system call number (sys_read)
	mov rdi, 1                          ; file descriptor (stdin)
	mov ecx, name                       ; store the input
	mov edx, 10	                        ; edx should hold input length
	syscall	

	; print inform message
	mov eax, 4                          ; system call number (sys_write)
	mov ebx, 1                          ; file descriptor (stdout)
	mov ecx, disp_mess                  ; ecx should hold the string to printout
	mov edx, len_disp_mess              ; edx should hold the string length
	syscall 	

	; output the input
	mov eax, 4                          ; system call number (sys_write)
	mov ebx, 1                          ; file descriptor (stdout)
	mov ecx, name                       ; ecx should hold the item to printout
	mov edx, 0 ; prepare for strlen
	;mov edx, 10                         ; edx should hold the length of the string
	syscall	

	; end the program
	mov eax, 60                         ; system call number (sys_exit)
	xor rdi, rdi                        ;invoke operating system to exit
	syscall
; assume the string is in ecx, save the length in edx
strlen:
	cmp [ecx], 0 ; get one byte of ecx
	jz strlen_done
	inc edx ; increment counter
 	inc ecx ; next char of string
	jump strlen
strlen_done:
	ret
