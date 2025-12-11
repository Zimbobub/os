COMPILER_DIR := /home/zimbobub/opt/cross/bin

boot: boot.s
	$(COMPILER_DIR)/i686-elf-as boot.s -o build/obj/boot.o



kernel src/kernel.c: 
	$(COMPILER_DIR)/i686-elf-gcc -c src/kernel.c -o build/obj/kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra



link: boot kernel
	$(COMPILER_DIR)/i686-elf-gcc -T linker.ld -o build/iso/boot/myos.bin -ffreestanding -O2 -nostdlib build/obj/boot.o build/obj/kernel.o -lgcc


iso: link
	grub-file --is-x86-multiboot build/iso/boot/myos.bin
	grub-mkrescue -o build/myos.iso build/iso

run: iso
	qemu-system-i386 -cdrom build/myos.iso