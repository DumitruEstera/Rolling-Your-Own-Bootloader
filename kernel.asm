BITS 32
ORG 0x1000
start:
    mov ebx, kernel_msg
    call print32

    cli
    hlt

print32:
    pusha
    mov edx, 0xb8000
print32_loop:
    mov al, [ebx] 
    mov ah, 0x0f

    cmp al, 0 
    je print32_done

    mov [edx], ax 
    add ebx, 1 
    add edx, 2

    jmp print32_loop

print32_done:
    popa
    ret

kernel_msg db 'Hello from Kernel!', 0
