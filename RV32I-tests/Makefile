TOOLCHAIN = riscv32-unknown-elf

helloWorld.bin: helloWorld.s
	$(TOOLCHAIN)-as -march=rv32i -mabi=ilp32 helloWorld.s -o helloWorld.elf
	$(TOOLCHAIN)-objcopy helloWorld.elf -O binary helloWorld.bin

add.bin: add.s
	$(TOOLCHAIN)-as -march=rv32i -mabi=ilp32 add.s -o add.elf
	$(TOOLCHAIN)-objcopy add.elf -O binary add.bin

.PHONY: all clean elfdump bindump

elfdump:
	$(TOOLCHAIN)-objdump -d helloWorld.elf

bindump:
	hexdump -v -e '1/4 "%08x " "\n"' helloWorld.bin

all: helloWorld.bin elfdump bindump

clean:
	rm helloWorld.elf helloWorld.bin
