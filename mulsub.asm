section .bss
num1   resb 20
num2   resb 20
out1   resb 40
out2   resb 40

section .data
msg1 db "Enter first 64-bit HEX number: ",0
msg2 db "Enter second 64-bit HEX number: ",0
msgM db "Multiplication = ",0
msgS db "Subtraction = ",0
nl db 10,0

section .text
global _start

_start:
    mov rax,1
    mov rdi,1
    mov rsi,msg1
    mov rdx,30
    syscall

    mov rax,0
    mov rdi,0
    mov rsi,num1
    mov rdx,20
    syscall

    mov rax,1
    mov rdi,1
    mov rsi,msg2
    mov rdx,30
    syscall

    mov rax,0
    mov rdi,0
    mov rsi,num2
    mov rdx,20
    syscall

    mov rsi,num1
    call atoi_hex
    mov r8,rax

    mov rsi,num2
    call atoi_hex
    mov r9,rax

    mov rax,1
    mov rdi,1
    mov rsi,msgM
    mov rdx,15
    syscall

    mov rax,r8
    mul r9
    mov rdi,out1
    mov rbx,rdx
    call itoa_hex
    mov rax,1
    mov rdi,1
    mov rsi,out1
    call slen
    mov rdx,rax
    mov rax,1
    mov rdi,1
    syscall

    mov rax,1
    mov rdi,1
    mov rsi,nl
    mov rdx,1
    syscall

    mov rax,1
    mov rdi,1
    mov rsi,msgS
    mov rdx,14
    syscall

    mov rbx,r8
    sub rbx,r9
    mov rdi,out2
    call itoa_hex

    mov rax,1
    mov rdi,1
    mov rsi,out2
    call slen
    mov rdx,rax
    mov rax,1
    mov rdi,1
    syscall

    mov rax,1
    mov rdi,1
    mov rsi,nl
    mov rdx,1
    syscall

    mov rax,60
    xor rdi,rdi
    syscall


atoi_hex:
    xor rax,rax
    xor rcx,rcx
.L1:
    mov dl,[rsi+rcx]
    cmp dl,10
    je .R
    cmp dl,13
    je .R
    cmp dl,0
    je .R
    shl rax,4
    cmp dl,'9'
    jbe .D
    sub dl,7
.D:
    sub dl,'0'
    add rax,rdx
    inc rcx
    jmp .L1
.R:
    ret

itoa_hex:
    mov rcx,16
    lea rsi,[rdi+31]
    mov byte[rsi],0
.L2:
    mov rax,rbx
    rol rbx,4
    and al,0xF
    cmp al,9
    jbe .A
    add al,7
.A:
    add al,'0'
    dec rsi
    mov [rsi],al
    loop .L2
    mov rdi,rdi
    mov rsi,rsi
    mov rbx,rsi
.C:
    mov al,[rbx]
    mov [rdi],al
    inc rbx
    inc rdi
    test al,al
    jnz .C
    ret

slen:
    xor rax,rax
.X:
    cmp byte[rsi+rax],0
    je .Y
    inc rax
    jmp .X
.Y:
    ret
