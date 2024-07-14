mkdir -p build
nasm -f bin main.asm -o build/main.bin
qemu-system-x86_64 build/main.bin
