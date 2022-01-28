; Execrsie 1 - "Hello_World" : 


;when programming in NASM (assembly x86). the first thing to do is to define the sections
;sections are necessary for this program to run. and the syntax to do that is the word "section" after that the section must be specified. (see line 7)

section .data									    ; all the defined variables that we will use in the program.
		variable db "Hello World!", 0x0a 0x00		; [db] define the byte. 8 bits | [0x0a] is equal to decimal 10 number which is new line in ASCII (\n) | [0x00] is equal to NULL.
		variable_length equ $ - variable			; specifies the length of the variable - in our case the length is equal ot the variable's length.	
					
					
section .text						; all the program instructions are defined here. (the actual code we need to run). 				
		global main					; defines a function. in our case called 'main'
		
main:								; the function.
		mov eax, 4 					; [4] (0x04) represents the 'write' syscall. the code means move 0x4 and place it in eax register.
		mov ebx, 1 					; use stdout (output). [used to print the file output]
		mov ecx, variable			; uses the variable as the buffer. [stores the variable in ecx]
		mov edx, variable_length	; supplys the variable length.
		int 0x80 					; [0x80] is the identefier (hex value) for running the syscall. it closes the code block and will allow reusing of the registers.

		mov eax, 1					; [1] (0x01) represents the 'exit' syscall.
		mov ebx, 0 					; the 'exit' syscall needs a return value . 0 means executed successfuly.
		int 0x80					; (refer to line 14)
		
; so we have 2 syscalls in the 'main' function. 
; first syscall is [4-write]. which takes 3 argumenst ( int file descriptor, char __user *buf, size_t count); these arguments are presented in ebx,ecx,edx (refer to line 17-19).
; second syscall is [1-exit]. which takes 1 argument (int error_code), the argument is presented in ebx (refer to line 23).	

; Exercise 2 - "User Input In Assembly" : 

section .data
		variable1 db "Hello Student, what is your name?", 0x0a 0x00
		variable1_length equ $ - variable1

		variable2 db "[*] I Know This Was useful, RIGHT?, Hope You Like It! "
		variable2_length equ $ - variable2



section .bss					; used to reserves a specified amount of space in the memory.
		input_var resb 10		; [resb] = reserve bytes. defines 10 bytes for the input_var input.


section .text
		global main
		
main:
		mov eax, 0x04
		mov ebx, 0x01
		mov ecx, variable1
		mov edx, variable1_length
		int 0x80
		
		mov eax, 0x03			; [0x03] (3) represents the 'read' syscall. which will read the 'variable2' value.
		mov ebx, 0x00			; [0x000 (0) represents the 'restart syscall'. which will restart in case of error. 
		mov ecx, input_var		; storing the input_var parameter in ecx register.
		mov edx, 10				; storing the input_var value in the edx register.
		int 0x080
		
		;this block will print the message "was this useful? :" which is the value of variable2
		mov eax, 0x04
		mov ebx, 0x01
		mov ecx, variable2
		mov edx, variable2_length
		int 0x80
		
		;this block will print the input.
		mov eax, 0x04		; notice now we have 'write' syscall, this will write the input to eax.	
		mov ebx, 0x01			 
		mov ecx, input_var		
		mov edx, 10				
		int 0x080
		
		mov eax, 0x01		; exit.
		int 0x80
	
; in this code we have 4 syscalls.
; 'write' syscall - already explained and its arguments.
; 'read' syscall [0x03 or 3]. which takes the same arguments as the 'write' (refer to line 27).
; 'restart_syscall' [0x00 or 0]. takes no arguments. (refer to line 106).
; 'exit' syscall - already explained. 
