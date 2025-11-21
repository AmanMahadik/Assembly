
%macro read 2
    mov rax,0
    mov rdi,0
    mov rsi,%1
    mov rdx,%2
    syscall
%endmacro

%macro write 2
    mov rax,1
    mov rdi,1
    mov rsi,%1
    mov rdx,%2
    syscall
%endmacro

section .data
menu db 10,"1.String length",10,"2.String compare",10,"3.String copy",10,"4.Exit",10,"Enter choice: ",0
menulen equ $-menu

msg1 db "Enter String1: ",0
msg1_len equ $-msg1

msg2 db "Enter String2: ",0
msg2_len equ $-msg2

msg_len db "Length (hex): ",10,0
msg_len_len equ $-msg_len

msg_eq db "String equal",10,0
msg_eq_len equ $-msg_eq

msg_neq db "String not equal",10,0
msg_neq_len equ $-msg_neq

msg_copy db "Copied string: ",10,0
msg_copy_len equ $-msg_copy

section .bss
s1 resb 40
s2 resb 40
s3 resb 40
l1 resq 1
l2 resq 1
choice resb 2
buff resb 16

section .text
global _start

_start:
    write msg1,msg1_len
    read s1,40
    dec rax
    mov [l1],rax

    write msg2,msg2_len
    read s2,40
    dec rax
    mov [l2],rax

menu_loop:
    write menu,menulen
    read choice,2

    cmp byte [choice],'1'
    je do_len
    cmp byte [choice],'2'
    je do_cmp
    cmp byte [choice],'3'
    je do_copy
    cmp byte [choice],'4'
    je exit

    jmp menu_loop

do_len:
    write msg_len,msg_len_len
    mov rbx,[l1]
    call display
    jmp menu_loop

do_cmp:
    mov rbx,[l1]
    cmp rbx,[l2]
    jne not_equal
    mov rsi,s1
    mov rdi,s2
    mov rcx,[l1]
    cld
    repe cmpsb
    jne not_equal
    write msg_eq,msg_eq_len
    jmp menu_loop
not_equal:
    write msg_neq,msg_neq_len
    jmp menu_loop

do_copy:
    mov rsi,s1
    mov rdi,s3
    mov rcx,[l1]
    cld
    rep movsb
    write msg_copy,msg_copy_len
    write s3,[l1]
    jmp menu_loop

exit:
    mov rax,60
    xor rdi,rdi
    syscall

display:
    mov rsi,buff
    mov rcx,16
dloop:
    rol rbx,4
    mov dl,bl
    and dl,0Fh
    cmp dl,9
    jbe ok
    add dl,7
ok:
    add dl,'0'
    mov [rsi],dl
    inc rsi
    dec rcx
    jnz dloop
    write buff,16
    ret
