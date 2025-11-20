section .bss
num1 resb 20
num2 resb 20
res  resb 40

section .data
menu db 10,"1.Addition",10,"2.Division",10,"Enter choice: ",0
menu_len equ $-menu
msg1 db "Enter first number: ",0
msg2 db "Enter second number: ",0
msgA db "Addition = ",0
msgQ db "Quotient = ",0
msgR db "Remainder = ",0
nl db 10,0

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

section .text
global _start

_start:
    WRITE menu,menu_len
    READ num1,2
    cmp byte [num1],'1'
    je add_op
    cmp byte [num1],'2'
    je div_op
    jmp _start

read_nums:
    WRITE msg1,20
    READ num1,20
    mov rsi,num1
    call atoi
    mov rax,rax
    mov rbx,rax
    WRITE msg2,20
    READ num2,20
    mov rsi,num2
    call atoi
    xchg rax,rbx
    ret

add_op:
    call read_nums
    add rax,rbx
    mov rdi,res
    call itoa
    WRITE msgA,12
    mov rsi,res
    call slen
    mov rdx,rax
    WRITE res,rdx
    jmp exit_prog

div_op:
    call read_nums
    xor rdx,rdx
    idiv rbx
    mov rdi,res
    call itoa
    WRITE msgQ,11
    mov rsi,res
    call slen
    mov rdx,rax
    WRITE res,rdx
    mov rax,rdx
    xor rdx,rdx
    idiv rbx
    mov rdi,res
    call itoa
    WRITE msgR,12
    mov rsi,res
    call slen
    mov rdx,rax
    WRITE res,rdx
    jmp exit_prog

atoi:
    xor rax,rax
    xor rcx,rcx
.next:
    movzx rdx,byte [rsi+rcx]
    cmp rdx,10
    je .done
    cmp rdx,13
    je .done
    cmp rdx,0
    je .done
    sub rdx,'0'
    imul rax,rax,10
    add rax,rdx
    inc rcx
    jmp .next
.done:
    ret

itoa:
    mov rcx,10
    lea rbx,[rdi+39]
    mov byte [rbx],0
.conv:
    xor rdx,rdx
    div rcx
    add dl,'0'
    dec rbx
    mov [rbx],dl
    test rax,rax
    jnz .conv
    mov rsi,rbx
.copy:
    mov al,[rsi]
    mov [rdi],al
    inc rsi
    inc rdi
    test al,al
    jnz .copy
    ret

slen:
    xor rax,rax
.lenloop:
    cmp byte [rsi+rax],0
    je .done
    inc rax
    jmp .lenloop
.done:
    ret

exit_prog:
    mov rax,60
    xor rdi,rdi
    syscall

