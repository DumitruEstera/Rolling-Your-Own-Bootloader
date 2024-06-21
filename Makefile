# Variables
NASM = nasm
DD = dd
RM = rm
QEMU = qemu-system-x86_64

# Files
BOOTLOADER_SRC = bootloader.asm
KERNEL_SRC = kernel.asm
BOOTLOADER_BIN = bootloader.bin
KERNEL_BIN = kernel.bin
DISK_IMG = disk.img

# Rules
all: $(DISK_IMG)

$(BOOTLOADER_BIN): $(BOOTLOADER_SRC)
	$(NASM) -f bin -o $(BOOTLOADER_BIN) $(BOOTLOADER_SRC)

$(KERNEL_BIN): $(KERNEL_SRC)
	$(NASM) -f bin -o $(KERNEL_BIN) $(KERNEL_SRC)

$(DISK_IMG): $(BOOTLOADER_BIN) $(KERNEL_BIN)
	$(DD) if=/dev/zero of=$(DISK_IMG) bs=512 count=2880
	$(DD) if=$(BOOTLOADER_BIN) of=$(DISK_IMG) bs=512 count=1 conv=notrunc
	$(DD) if=$(KERNEL_BIN) of=$(DISK_IMG) bs=512 seek=1 conv=notrunc

clean:
	$(RM) $(BOOTLOADER_BIN) $(KERNEL_BIN) $(DISK_IMG)

run: all
	$(QEMU) -drive format=raw,file=$(DISK_IMG),index=0,if=floppy

.PHONY: all clean run
