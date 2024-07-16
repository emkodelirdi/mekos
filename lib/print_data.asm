; print_data.asm
; Function to print data read from disk
; Arguments:
;   si - Address of data to print
print_data:
    mov     cx, 512                     ; Number of bytes to print (1 sector = 512 bytes)

print_loop:
    lodsb                                ; Load byte at DS:SI into AL and increment SI
    cmp     al, 0x20                    ; Compare byte to space character
    jb      not_printable               ; If below space, skip printing
    cmp     al, 0x7E                    ; Compare byte to tilde (~)
    ja      not_printable               ; If above tilde, skip printing
    mov     ah, 0x0E                    ; BIOS teletype function
    int     0x10                        ; Call BIOS interrupt to print character
    jmp     print_continue              ; Continue printing

not_printable:
    mov     al, '.'                     ; Print a dot for non-printable characters
    mov     ah, 0x0E                    ; BIOS teletype function
    int     0x10                        ; Call BIOS interrupt to print character

print_continue:
    loop    print_loop                  ; Loop until all bytes are printed
    ret                                 ; Return from function
