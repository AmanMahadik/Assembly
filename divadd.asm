```
section .bss
num1   resb 20
num2   resb 20
out1   resb 40
out2   resb 40

section .data
m1 db "Enter first number: ",0
m2 db "Enter second number: ",0
mA db "Addition = ",0
mD db "Division = ",0
mZ db "Division by zero",0
nl db 10,0

section .text
global _start

_start:
    mov rax,1; write m1
    mov rdi,1
    mov rsi,m1
    mov rdx,20
    syscall

    mov rax,0; read num1
    mov rdi,0
    mov rsi,num1
    mov rdx,20
    syscall

    mov rax,1; write m2
    mov rdi,1
    mov rsi,m2
    mov rdx,20
    syscall

    mov rax,0; read num2
    mov rdi,0
    mov rsi,num2
    mov rdx,20
    syscall

    mov rsi,num1
    call atoi
    mov r8,rax
    mov rsi,num2
    call atoi
    mov r9,rax

    mov rax,1; print add header
    mov rdi,1
    mov rsi,mA
    mov rdx,11
    syscall

    mov rax,r8
    add rax,r9
    mov rdi,out1
    call itoa
    mov rax,1
    mov rdi,1
    mov rsi,out1
    call strlen
    mov rdx,rax
    mov rax,1
    mov rdi,1
    syscall

    mov rax,1; newline
    mov rdi,1
    mov rsi,nl
    mov rdx,1
    syscall

    mov rax,1; print div header
    mov rdi,1
    mov rsi,mD
    mov rdx,11
    syscall

    cmp r9,0
    je .divzero
    mov rax,r8
    cqo
    idiv r9
    mov rdi,out2
    call itoa
    mov rax,1
    mov rdi,1
    mov rsi,out2
    call strlen
    mov rdx,rax
    mov rax,1
    mov rdi,1
    syscall
    jmp .done

.divzero:
    mov rax,1
    mov rdi,1
    mov rsi,mZ
    mov rdx,16
    syscall

.done:
    mov rax,1
    mov rdi,1
    mov rsi,nl
    mov rdx,1
    syscall

    mov rax,60
    xor rdi,rdi
    syscall

atoi:
    xor rax,rax
    xor rcx,rcx
.L1:
    movzx rdx, byte [rsi+rcx]
    cmp rdx,10
    je .R
    cmp rdx,13
    je .R
    cmp rdx,0
    je .R
    sub rdx,'0'
    imul rax,rax,10
    add rax,rdx
    inc rcx
    jmp .L1
.R:
    ret

itoa:
    mov rcx,10
    lea rbx,[rdi+39]
    mov byte [rbx],0
.C1:
    xor rdx,rdx
    div rcx
    add dl,'0'
    dec rbx
    mov [rbx],dl
    test rax,rax
    jnz .C1
    mov rsi,rbx
.C2:
    mov al,[rsi]
    mov [rdi],al
    inc rsi
    inc rdi
    test al,al
    jnz .C2
    ret

strlen:
    xor rax,rax
.S1:
    cmp byte [rsi+rax],0
    je .S2
    inc rax
    jmp .S1
.S2:
    ret
```
