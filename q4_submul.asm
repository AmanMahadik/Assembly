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
    msgM db "Multiplication =",10
    lenM equ $-msgM
    msgS db "Subtraction =",10
    lenS equ $-msgS

section .bss
    buff resb 17
    num1 resq 1
    num2 resq 1
    ans  resq 1
    temp resb 16

section .text
global _start

_start:
    WRITE msg1,len1
    READ buff,17
    dec rax
    mov rcx,rax
    call accept
    mov [num1],rbx

    WRITE msg2,len2
    READ buff,17
    dec rax
    mov rcx,rax
    call accept
    mov [num2],rbx

    mov rax,[num1]
    mov rbx,[num2]
    xor rdx,rdx
    mul rbx
    mov [ans],rax
    WRITE msgM,lenM
    mov rbx,[ans]
    call display

    mov rax,[num1]
    mov rbx,[num2]
    sub rax,rbx
    mov [ans],rax
    WRITE msgS,lenS
    mov rbx,[ans]
    call display

    mov rax,60
    xor rdi,rdi
    syscall

accept:
    mov rsi,buff
    mov rbx,0
n1:
    mov dl,[rsi]
    cmp dl,10
    je n2
    shl rbx,4
    cmp dl,'9'
    jbe n0
    sub dl,7
n0:
    sub dl,48
    add rbx,rdx
    inc rsi
    loop n1
n2:
    ret

display:
    mov rsi,temp
    mov rcx,16
d1:
    rol rbx,4
    mov dl,bl
    and dl,0Fh
    cmp dl,9
    jbe d2
    add dl,7
d2:
    add dl,48
    mov [rsi],dl
    inc rsi
    loop d1
    WRITE temp,16
    ret
