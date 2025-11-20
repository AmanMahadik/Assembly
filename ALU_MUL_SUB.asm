;===========================================
;   MACROS
;===========================================
%macro write 2
    mov rax, 1
    mov rdi, 1
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

%macro read 2
    mov rax, 0
    mov rdi, 0
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro


;===========================================
;   DATA SECTION
;===========================================
section .data
msg1    db "Enter first 64-bit HEX number: ",0
msg1l   equ $-msg1

msg2    db "Enter second 64-bit HEX number: ",0
msg2l   equ $-msg2

msgmul  db "Multiplication = ",0
msgmull equ $-msgmul

msgsub  db "Subtraction   = ",0
msgsubl equ $-msgsub

num1    times 17 db 0
num2    times 17 db 0
buff    times 17 db 0

ccnt    dq 16


;===========================================
;   ASCII → INT (HEX → 64-bit RBX)
;===========================================
accept:
    mov rbx, 0
    mov rsi, rdi
    mov rcx, 16
next_dig:
    shl rbx, 4
    mov dl, [rsi]

    cmp dl, '9'
    jbe dig0_9
    sub dl, 7

dig0_9:
    sub dl, '0'
    add rbx, rdx

    inc rsi
    loop next_dig
    ret


;===========================================
;   INT → ASCII (RBX → HEX 16 chars)
;===========================================
disp:
    mov rsi, buff
    mov rcx, 16

next_out:
    rol rbx, 4
    mov dl, bl
    and dl, 0Fh

    cmp dl, 9
    jbe make_ascii
    add dl, 7

make_ascii:
    add dl, '0'
    mov [rsi], dl
    inc rsi
    loop next_out

    write buff, 16
    ret


;===========================================
;     CODE SECTION
;===========================================
section .text
global _start

_start:

    ;---------------------------------------
    ; INPUT FIRST NUMBER
    ;---------------------------------------
    write msg1, msg1l
    read num1, 16

    mov rdi, num1
    call accept
    mov r8, rbx


    ;---------------------------------------
    ; INPUT SECOND NUMBER
    ;---------------------------------------
    write msg2, msg2l
    read num2, 16

    mov rdi, num2
    call accept
    mov r9, rbx


    ;---------------------------------------
    ; MULTIPLICATION
    ;---------------------------------------
    write msgmul, msgmull

    mov rax, r8
    mov rbx, r9
    mul rbx

    mov rbx, rdx
    call disp

    write buff, 1

    mov rbx, rax
    call disp

    write 10, 1


    ;---------------------------------------
    ; SUBTRACTION
    ;---------------------------------------
    write msgsub, msgsubl

    mov rbx, r8
    sub rbx, r9

    call disp
    write 10, 1


    ;---------------------------------------
    ; EXIT
    ;---------------------------------------
    mov rax, 60
    xor rdi, rdi
    syscall
