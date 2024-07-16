[org 0x7c00]                             ; Offset everything

jmp start                                ; Jump to the start of the bootloader

start:
    cli                                  ; Clear interrupts
    mov     ax, 0                        ; Set ax to 0
    mov     bx, 0                        ; Set bx to 0
    mov     cx, 0                        ; Set cx to 0
    mov     dx, 0                        ; Set dx to 0
    mov     sp, 0x7C00                   ; Set stack pointer
    sti                                  ; Start interrupts

    ; Call the function to read a sector from disk
    mov     al, 0x01                    ; Number of sectors to read (1 sector)
    mov     ch, 0x00                    ; Cylinder number
    mov     cl, 0x02                    ; Sector number (2, for example)
    mov     dh, 0x00                    ; Head number
    mov     dl, 0x80                    ; Drive number (0x80 = first hard disk)
    mov     bx, 0x1000                  ; Memory location to read into (0x1000 is just an example)
    call    read_sector                 ; Call the disk read function

    ; Check for disk read error
    jc      read_error                  ; Jump if carry flag is set (indicates error)

    ; Print success message
    mov     si, var_ReadSuccess         ; Load address of success message
    call    print                        ; Call print function
    jmp     hang                         ; Hang if successful

read_error:
    ; Print error message
    mov     si, var_ReadError           ; Load address of error message
    call    print                        ; Call print function

hang:
    jmp     hang                         ; Infinite loop to halt execution

; Disk read function
; Arguments:
;   al - number of sectors to read
;   ch - cylinder number
;   cl - sector number
;   dh - head number
;   dl - drive number
;   bx - memory address to read into
read_sector:
    mov     ah, 0x02                    ; BIOS read sector function
    int     0x13                        ; Call BIOS disk interrupt
    ret                                 ; Return from function

%include "lib/print.asm"                  ; Include print function

return:
    ret

; Data section
var_StartUp db "Welcome to Mekos", 10, 13, "Check my github: https://github.com/emkodelirdi", 10, 13, "This is solely a passion project I made out of my amazement for low level coding, this code is not perfect and will never be perfect", 10, 13, 0
var_ReadSuccess db "Disk read successful!", 10, 13, 0
var_ReadError db "Disk read error!", 10, 13, 0

times 510-($-$$) db 0                    ; Fill the rest of the sector with zeros
dw 0xAA55                                ; Boot sector signature
