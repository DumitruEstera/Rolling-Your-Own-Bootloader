BITS 32
ORG 0x0000
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f 
start:
    call print32

    cli
    hlt

print32:
    pusha
    mov ebx, kernel_msg 
    mov edx, VIDEO_MEMORY 

print32_loop:
    mov al, [ebx] 
    mov ah, WHITE_ON_BLACK 

    cmp al, 0 
    je print32_done

    mov [edx], ax 
    add ebx, 1
    add edx, 2 

    jmp print32_loop

print32_done:
    popa
    ret

kernel_msg db 'Hello from kernel!', 0
