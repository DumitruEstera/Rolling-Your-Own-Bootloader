[BITS 16]
[ORG 0x7C00]

mov [BOOT_DRIVE], dl 
mov bp, 0x9000
mov sp, bp

start:
    mov ax, 0x07C0
    add ax, 288      ; stack pointer
    mov ss, ax
    mov sp, 0x0100

    ; Display message 
    mov si, loading_msg
    call print_string

    ; Load kernel at 0x1000:0x0000
    mov bx, 0x1000  
    call load_kernel

    ; Message that kernel loaded
    mov si, debugg_msg
    call print_string

    ; Enable A20 bit
    in al, 0x92
    or al, 2
    out 0x92, al

    mov si, debugg_msg2     ; Loading gdt...
    call print_string   

    mov si, debugg_msg3     ; switching to 32 bit protected mode
    call print_string

switch_to_32bit:
    cli ; 1. disable interrupts
    lgdt [gdt_descriptor] ; 2. load the GDT descriptor
    mov eax, cr0
    or eax, 0x1 ; 3. set 32-bit mode bit in cr0
    mov cr0, eax
    jmp CODE_SEG:init_32bit ; 4. far jump by using a different segment

    jmp $

[bits 32]
init_32bit:
    mov ax, DATA_SEG ; 5. update the segment registers
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000 ; 6. update the stack right at the top of the free space
    mov esp, ebp

    call BEGIN_32BIT
    
    jmp $

BEGIN_32BIT:
    call 0x1000    ;Give control to the kernel
    jmp $

[bits 16]   
load_kernel:
    mov ah, 0x02     
    mov al, 3        ; nr de sectoare
    mov ch, 0        ; cilindrul 0
    mov dh, 0        ; head 0
    mov cl, 2        ; incepem sa citim din al doilea sector
    mov dl, [BOOT_DRIVE]  ; use the boot drive
    int 0x13  
    jc disk_error   
    
    ret

disk_error:
    ; Display error message
    mov si, error_msg
    call print_string
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

print_in_32_bit:
[bits 32] 

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

loading_msg db 'Loading kernel...', 0
debugg_msg db 'Kernel loaded.', 0
debugg_msg2 db 'Loading GDT...', 0
debugg_msg3 db 'Switching to 32-bit mode...', 0
error_msg db 'Disk read error!', 0

%include 'gdt.asm'
BOOT_DRIVE db 0
times 510-($-$$) db 0  
dw 0xAA55 
