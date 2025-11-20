%macro WRITE 2
	mov rax, 01
	mov rdi, 01
	mov rsi, %1
	mov rdx, %2
	syscall 
%endmacro 


%macro READ 2
        mov rax, 00
        mov rdi, 00
        mov rsi, %1
        mov rdx, %2
        syscall 
%endmacro 

%macro EXIT 00
	mov rax, 60
	mov rdi, 00
	syscall
%endmacro 

section .data

	msg1 db "Enter two numbers : ",10 
	len1 equ $-msg1
	msg2 db "Multiplication by Shift & Add : " 
	len2 equ $-msg2
	msg3 db " ",10 
	len3 equ $-msg3


section .bss 
	char_buff resb 17
	actl resq 1
	m resq 1 
	n resq 1
	ans resq 1 
	A resq 1 
	B resq 1 
	Q resq 1 

section .text 
	global _start 

_start: 
        WRITE msg1, len1 
	READ char_buff, 17 
	call accept
	mov [m], rbx
	READ char_buff ,17 
	call accept 
	mov [n], rbx


	mov qword[A], 00H
	mov rbx, qword[m]
	mov qword[B], rbx
	mov rbx, qword[n]
	mov qword[Q], rbx
	mov rcx, 64
     l2:mov rbx, [Q]
	AND rbx, 01H
	jz ShiftAQ
	mov rbx, [B]
	add [A], rbx
ShiftAQ:shr qword [Q], 01H
	mov rbx, [A]
	AND rbx, 01
	jz ShiftA
	mov rbx, 01
	ror rbx, 01
	OR [Q], rbx
ShiftA:shr qword[A], 01
	dec rcx
	jnz l2
	WRITE msg2, len2
	mov rbx, [A]
	call display
	mov rbx, [Q]
	call display
	
	WRITE msg3, len3
	EXIT

accept:
	dec rax
	mov rsi,char_buff
	mov rbx,00
     up:mov rdx,00H
	mov dl,byte[rsi]
	cmp dl,39H
	jbe sub30
	sub dl,07H
  sub30:sub dl,30H
        shl rbx,04H
	add rbx,rdx
	inc rsi
	dec rax
	jnz up
	ret
	
display:
	mov rax,16
	mov rsi,char_buff
  above:rol rbx,04H
	mov dl,bl
	and dl,0FH
	cmp dl,09H
	jbe add30
	add dl,07H
  add30:add dl,30H
	mov byte[rsi],dl
	inc rsi
	dec rax
	jnz above
	WRITE char_buff,16
	ret

	inc rsi
	dec rcx
	jnz above
	WRITE char_buff, 16
	ret
