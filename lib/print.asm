print:
    lodsb
    or      al, al                          ; check if the value is 0. this works cuz if both of them are 0, or will return 0
    jz      return
    mov     ah, 0x0e
    int     0x10
    jmp     print
