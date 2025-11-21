%macro WRITE 2
	mov rax,1
	mov rdi,1
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

%macro READ 2
	mov rax,0
	mov rdi,0
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

%macro EXIT 0
	mov rax,60
	mov rdi,1
	syscall
%endmacro

section .data
	
	msg1 db "Enter the HEX number : ",
	len1 equ $-msg1
	msg2 db "The BCD Equivalent : "
	len2 equ $-msg2
	msg3 db " ",10
	len3 equ $-msg3
	
section .bss
	char_buff resb 17
	ans resq 1
	cnt resb 1
	
section .text
	global _start
	
_start:
	WRITE msg1, len1
	READ char_buff, 17
	call accept
	WRITE msg2, len2
	mov rcx, 00
	mov rax, rbx
     l1:mov rdx, 00
	mov rbx, 0Ah
	div rbx
	push rdx
	inc rcx
	cmp rax, 00
	jnz l1
	mov byte[cnt], cl
     l2:pop rbx
	cmp bl, 09H
	jbe l3
	add bl, 07H
     l3:add bl, 30H
	mov byte[ans], bl
	WRITE ans, 01
	dec byte[cnt]
	jnz l2
	
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
	mov rsi, char_buff
	mov rcx, 16
    up2:rol rbx, 04
	mov dl, bl
	and dl, 0FH
	cmp dl, 09H
	jbe add30
	add dl, 07H
  add30:add dl, 30H
	mov byte[rsi], dl
	inc rsi
	dec rcx
	jnz up2
	WRITE char_buff, 16
	ret
