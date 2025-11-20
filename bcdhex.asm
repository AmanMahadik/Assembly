; ======================================================
; HEX ??? BCD Conversion in x86-64 Assembly (Linux, NASM)
; ======================================================

section .data
menu db 10, "1. BCD To HEX", 10, \
          "2. HEX To BCD", 10, \
          "3. Exit", 10, \
          "Enter your choice: "
menulen equ $ - menu

msg1 db 10, "Enter BCD number: "
msg1_end:
msg2 db 10, "Enter HEX number: "
msg2_end:
msg3 db 10, "Result: "
msg3_end:
newline db 10

; ======================================================
; Macros for I/O
; ======================================================
%macro READ 2
    mov rax, 0          ; syscall: read
    mov rdi, 0          ; stdin
    mov rsi, %1         ; buffer
    mov rdx, %2         ; length
    syscall
%endmacro

%macro WRITE 2
    mov rax, 1          ; syscall: write
    mov rdi, 1          ; stdout
    mov rsi, %1         ; message
    mov rdx, %2         ; length
    syscall
%endmacro

; ======================================================
section .bss
input  resb  20
len    resq  1
choice resb  2
num    resq  1

; ======================================================
section .text
global _start

_start:
menu_loop:
    WRITE menu, menulen
    READ choice, 2

    cmp byte [choice], '1'
    je bcdtohex
    cmp byte [choice], '2'
    je hextobcd
    cmp byte [choice], '3'
    je exit_program
    jmp menu_loop

; ======================================================
; BCD ??? HEX
; ======================================================
bcdtohex:
    WRITE msg1, msg1_end - msg1
    READ input, 20
    dec rax                   ; remove newline
    mov [len], rax

    xor rbx, rbx
    mov rax, [len]
    mov rcx, rax
    mov rsi, input

bcd_loop:
    movzx rax, byte [rsi]
    sub rax, '0'
    imul rbx, rbx, 10
    add rbx, rax
    inc rsi
    loop bcd_loop

    WRITE msg3, msg3_end - msg3
    mov rax, rbx
    call print_hex
    jmp menu_loop

; ======================================================
; HEX ??? BCD
; ======================================================
hextobcd:
    WRITE msg2, msg2_end - msg2
    READ input, 20
    dec rax
    mov [len], rax

    mov rcx, [len]
    call accept
    
    WRITE msg3, msg3_end - msg3
    
    ; Now convert the number in rbx to BCD and print
    mov rcx, 0
    mov rax, rbx

l1:
    mov rdx, 0
    mov rbx, 0Ah
    div rbx
    push rdx
    inc rcx
    cmp rax, 0
    jnz l1
    
    mov byte[len], cl

l2:
    pop rbx
    cmp bl, 09H
    jbe l3
    add bl, 07H

l3:
    add bl, 30H
    mov byte[input], bl
    WRITE input, 1
    dec byte[len]
    jnz l2
    
    WRITE newline, 1
    jmp menu_loop

; ======================================================
; accept (ASCII HEX ??? number)
; ======================================================
accept:
    mov rsi, input
    mov rbx, 0H
    mov rcx, [len]

up:
    mov rdx, 0H
    mov dl, byte[rsi]
    cmp dl, 39H           ; Compare with '9'
    jbe sub30
    sub dl, 07H           ; Subtract 7 for A-F

sub30:
    sub dl, 30H           ; Subtract '0'
    shl rbx, 04H          ; Shift left by 4 bits
    add rbx, rdx          ; Add the digit
    inc rsi
    dec rcx
    jnz up
    
    mov [num], rbx
    ret

; ======================================================
; print_hex
; ======================================================
print_hex:
    mov rsi, input
    mov rcx, 16           ; 16 hex digits for 64-bit number
    mov rbx, rax

up2:
    rol rbx, 04           ; Rotate left by 4 bits
    mov dl, bl
    and dl, 0FH           ; Mask lower 4 bits
    
    ; Convert to ASCII
    cmp dl, 09H
    jbe add30
    add dl, 07H           ; Adjust for A-F

add30:
    add dl, 30H
    mov byte[rsi], dl
    inc rsi
    dec rcx
    jnz up2

    WRITE input, 16
    WRITE newline, 1
    ret

; ======================================================
; print_bcd
; ======================================================
print_bcd:
    mov rbx, 10
    xor rcx, rcx

.divide_loop:
    xor rdx, rdx
    div rbx
    add dl, '0'
    push rdx
    inc rcx
    test rax, rax
    jnz .divide_loop

.print_loop:
    pop rax
    mov [input], al
    WRITE input, 1
    dec rcx
    jnz .print_loop
    WRITE newline, 1
    ret

; ======================================================
; Exit
; ======================================================
exit_program:
    mov rax, 60
    xor rdi, rdi
    syscall
