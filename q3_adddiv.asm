%macro READ 2
    mov rax,0
    mov rdi,0
    mov rsi,%1
    mov rdx,%2
    syscall
%endmacro

%macro WRITE 2
    mov rax,1
    mov rdi,1
    mov rsi,%1
    mov rdx,%2
    syscall
%endmacro

section .data
    msg1 db "Enter 1st 64-bit HEX number:",10
    len1 equ $-msg1
    msg2 db "Enter 2nd 64-bit HEX number:",10
    len2 equ $-msg2
    msgA db "Addition =",10
    lenA equ $-msgA
    msgD db "Division =",10
    lenD equ $-msgD

section .bss
    buff    resb 17
    num1    resq 1
    num2    resq 1
    ans     resq 1
    temp    resb 16

section .text
global _start

_start:
    WRITE msg1, len1
    READ buff, 17
    dec rax
    mov rcx,rax
    call accept
    mov [num1],rbx

    WRITE msg2, len2
    READ buff, 17
    dec rax
    mov rcx,rax
    call accept
    mov [num2],rbx

    mov rax,[num1]
    mov rbx,[num2]
    add rax,rbx
    mov [ans],rax
    WRITE msgA, lenA
    mov rbx,[ans]
    call display

    mov rax,[num1]
    mov rbx,[num2]
    xor rdx,rdx
    div rbx
    mov [ans],rax
    WRITE msgD, lenD
    mov rbx,[ans]
    call display

    mov rax,60
    xor rdi,rdi
    syscall

accept:
    mov rsi,buff
    mov rbx,0
next_digit:
    mov dl,[rsi]
    cmp dl,10
    je done
    shl rbx,4
    cmp dl,'9'
    jbe digit
    sub dl,7
digit:
    sub dl,48
    add rbx,rdx
    inc rsi
    loop next_digit
done:
    ret

display:
    mov rsi,temp
    mov rcx,16
hexloop:
    rol rbx,4
    mov dl,bl
    and dl,0Fh
    cmp dl,9
    jbe ok
    add dl,7
ok:
    add dl,48
    mov [rsi],dl
    inc rsi
    loop hexloop
    WRITE temp,16
    ret
