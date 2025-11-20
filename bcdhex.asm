section .data
msg1 db "Enter 64-bit BCD number: ",0
msg1_len equ $-msg1
msg2 db "HEX = ",0
msg2_len equ $-msg2
nl db 10

section .bss
input  resb 32
len    resq 1

section .text
global _start

_start:
    ; Ask for BCD input
    mov rax,1
    mov rdi,1
    mov rsi,msg1
    mov rdx,msg1_len
    syscall

    ; Read decimal number
    mov rax,0
    mov rdi,0
    mov rsi,input
    mov rdx,32
    syscall
    dec rax
    mov [len],rax

    ; Convert ASCII decimal → binary (rbx)
    mov rsi,input
    mov rcx,[len]
    xor rbx,rbx

bcd_loop:
    movzx rax,byte [rsi]
    sub rax,'0'
    imul rbx,rbx,10
    add rbx,rax
    inc rsi
    loop bcd_loop

    ; Print "HEX = "
    mov rax,1
    mov rdi,1
    mov rsi,msg2
    mov rdx,msg2_len
    syscall

    ; Convert binary rbx → hex ASCII
    mov rax,rbx
    mov rcx,16
    mov rsi,input

hex_print:
    rol rax,4
    mov dl,al
    and dl,0x0F

    cmp dl,9
    jbe digit
    add dl,7
digit:
    add dl,'0'

    mov [rsi],dl
    inc rsi
    loop hex_print

    ; Print hex
    mov rax,1
    mov rdi,1
    mov rsi,input
    mov rdx,16
    syscall

    ; newline
    mov rax,1
    mov rdi,1
    mov rsi,nl
    mov rdx,1
    syscall

    ; exit
    mov rax,60
    xor rdi,rdi
    syscall
