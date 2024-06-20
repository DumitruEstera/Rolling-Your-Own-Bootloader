BITS 16           
ORG 0x7C00      

start:
    mov ax, 0x07C0
    add ax, 288      ; stack pointer
    mov ss, ax
    mov sp, 0x0100

    ; afisare mesaj 
    mov si, loading_msg
    call print_string

    ; incarcam kernelul la 0x1000:0x0000
    mov bx, 0x1000   
    call load_kernel

    ; sare la adresa kernelului
    jmp 0x1000:0x0000

load_kernel:
    mov ah, 0x02     
    mov al, 3        ; nr de sectoare
    mov ch, 0        ; cilindrul 0
    mov dh, 0        ; head 0
    mov cl, 2        ; incepem sa citim din al doilea sector
    mov dl, 0        ; floppy
    int 0x13  
    jc disk_error   

    ret

disk_error:
    ; afiseaza mesaj de eroare
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

loading_msg db 'Loading kernel...', 0
error_msg db 'Disk read error!', 0

times 510-($-$$) db 0  
dw 0xAA55            