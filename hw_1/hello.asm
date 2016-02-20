; ----------------------------------------------------------------------------------------
; Writes "Hello, World" to the console using only system calls. Runs on 64-bit Linux only.
; To assemble and run:
;     nasm -felf64 hello.asm && ld hello.o && ./a.out
; View all syscalls here:
;		/usr/include/asm-generic/unistd.h
; ----------------------------------------------------------------------------------------
; intel syntax
; op dst, src

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
	; print query message
	mov eax, 4                          ; system call number (sys_write)
	mov ebx, 1                          ; file descriptor (stdout)
	mov ecx, in_mess                    ; ecx should hold the string to printout
	mov edx, len_in_mess                ; edx should hold the string length
	int 0x80                            ; call the kernel

	; read user input
	mov eax, 3                          ; system call number (sys_read)
	mov ebx, 1                          ; file descriptor (stdin)
	mov ecx, name                       ; store the input
	mov edx, 10	                        ; edx should hold input length
	int 0x80                            ; call the kernel

	; print inform message
	mov eax, 4                          ; system call number (sys_write)
	mov ebx, 1                          ; file descriptor (stdout)
	mov ecx, disp_mess                  ; ecx should hold the string to printout
	mov edx, len_disp_mess              ; edx should hold the string length
	int 0x80                            ; call the kernel

	; output the input
	mov eax, 4                          ; system call number (sys_write)
	mov ebx, 1                          ; file descriptor (stdout)
	mov ecx, name                       ; ecx should hold the item to printout
	mov edx, 10                         ; edx should hold the length of the string
	int 0x80                            ; call the kernel

	; end the program
	mov eax, 1                          ; system call number (sys_exit)
	mov ebx, 0                          ; ebx should hold an int	
	int 0x80                            ; call the kernel
