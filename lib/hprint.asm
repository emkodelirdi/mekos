printh:
    pusha
    mov ah, 0x0e ; Teletype Output
    mov al, "0"
    int 0x10
    mov al, "x"
    int 0x10

    mov cx, 16
    .charLoop:
        call print
        sub cx, 4
        mov bx, dx
        shr bx, cl
        and bx, 0x000f
        mov al, [bx + var_hextable]
        int 0x10 ; Video Services
        or cx, cx
        jne .charLoop

    mov al, 0x0d ; CR
    int 0x10 ; Video Services
    mov al, 0x0a ; LF
    int 0x10 ; Video Services
    popa
    ret
var_hextable db "0123456789abcdef"
