; highly documented bootloader incoming !!
[org 0x7c00]                                ; offset everyhing

jmp start                                   ; start code

start:
    cli                                     ; clear interrupts
    mov     ax, 0                           ; set ax to 0
    mov     bx, 0                           ; set bx to 0
    mov     cx, 0                           ; set cx to 0
    mov     dx, 0                           ; set dx to 0
    mov     sp, 0x7C00                      ; set stack pointer
    sti                                     ; start interrupts

    mov     si, var_StartUp                ; move the value of this to the source index (for strings)
    call    print

    mov     bx, 0x8000
    call    loaddisk

    mov     si, 0x8000
    call    printh

hang:
    jmp     hang

%include "lib/print.asm"
%include "lib/hprint.asm"

loaddisk:
    mov     ah, 0x02                        ; read mode
    mov     al, 1                           ; number of sectors to read
    mov     ch, 0                           ; cylinder number to 0
    mov     cl, 2                           ; sector number 2, 1 is usually boot
    mov     dh, 0                           ; sets head to 0
    mov     dl, 0x80                        ; sets drive to the first one
    int     0x13                            ; the interrupt for read
    jc      diskerror
    ret

diskerror:
    mov     si, var_DiskError             ; move error message to si
    call    print                          ; print the error message
    jmp     hang

return:
    ret

var_StartUp db "Welcome to Mekos", 10, 13, "Check my github: https://github.com/emkodelirdi", 10, 13, "This is solely a passion project I made out of my amazement for low level coding, this code is not perfect and will never be perfect", 10, 13, 0
var_DiskError db "Disk read error", 10, 13, 0

times 510-($-$$) db 0                       ; Fill the rest of the sector with zeros
dw 0xAA55                                   ; Boot sector signature
times 256 dw 0xdada                         ; sector 2 = 512 bytes
times 256 dw 0xface                         ; they are all 512 bytes
