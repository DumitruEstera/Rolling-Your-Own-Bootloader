BITS 16
ORG 0x0000

start:
    mov si, kernel_msg
    call print_string


    cli
    hlt

print_string:
    mov ah, 0x0E     
.print_char:
    lodsb            ; Load byte at DS:SI into AL and increment SI
    cmp al, 0
    je .done
    int 0x10         
    jmp .print_char
.done:
    ret

kernel_msg db 'Hello from kernel!', 0
