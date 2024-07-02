[org 0x7c00]
  mov ah, 0x0e
  mov bx, bootVar

print:
  mov al, [bx]
  cmp al, 0 
  je end
  int 0x10
  inc bx
  jmp print
end:

input:
  mov ah, 0 
  int 0x16 
  cmp al, 8
  je deletelastchar
  cmp al, 0xe0
  je arrowkey
  mov ah, 0x0e
  int 0x10
  jmp input
deletelastchar:
  mov ah, 0x0e 
  mov al, 0 
  int 0x10
  mov al, 8
  int 0x10
  jmp input
arrowkey:
  int 0x16
  cmp al, 0x4b
  je backarrow
  cmp al, 0x4d
  je forwardarrow
  jmp input
backarrow:
  mov ah, 0x0e
  mov al, 8
  int 0x10
  jmp input
forwardarrow:
  mov ah, 0x0e
  mov al, 127
  int 0x10
  jmp input

bootVar:
  db "Welcome to MekOs, the operating system made by meko/emkodelirdi!", 10, 13, 0

  times 510-($-$$) db 0 
  dw 0xaa55
  jmp $
