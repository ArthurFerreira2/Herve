You need the risc-v gnu toolchain to assemble these exemples - Here is my workflow :

helloWorld.s
```
.section .text

.global boot
.type boot, @function
boot:

	lui	t0, 0xFFFC 	# memory mapped io : putchar

	addi	t1, x0, 0x48	# H
	sw	t1, 0(t0)

	addi	t1, x0, 0x65	# e
	sw	t1, 0(t0)

	addi	t1, x0, 0x6C	# l
	sw	t1, 0(t0)

	addi	t1, x0, 0x6C	# l
	sw	t1, 0(t0)

	addi	t1, x0, 0x6F	# o
	sw	t1, 0(t0)

	addi	t1, x0, 0x0A	# Line Feed
	sw	t1, 0(t0)

finish:
	beq	t1, t1, finish

```

Assemble:
```
riscv32-unknown-elf-as -march=rv32i helloWorld.s -o helloWorld.elf
```

Convert to binary:
```
riscv32-unknown-elf-objcopy helloWorld.elf -O binary helloWorld.bin
```

Check the binary:
```
hexdump -v -e '1/4 "%08x " "\n"' helloWorld.bin
0fffc2b7
04800313
0062a023
06500313
0062a023
06c00313
0062a023
06c00313
0062a023
06f00313
0062a023
00a00313
0062a023
00630063
```

Compare it with the original assembly :
```
riscv32-unknown-elf-objdump -d helloWorld.elf

RV32I-Examples/helloWorld.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <boot>:
   0:	0fffc2b7          	lui	t0,0xfffc
   4:	04800313          	li	t1,72
   8:	0062a023          	sw	t1,0(t0) # fffc000 <finish+0xfffbfcc>
   c:	06500313          	li	t1,101
  10:	0062a023          	sw	t1,0(t0)
  14:	06c00313          	li	t1,108
  18:	0062a023          	sw	t1,0(t0)
  1c:	06c00313          	li	t1,108
  20:	0062a023          	sw	t1,0(t0)
  24:	06f00313          	li	t1,111
  28:	0062a023          	sw	t1,0(t0)
  2c:	00a00313          	li	t1,10
  30:	0062a023          	sw	t1,0(t0)

00000034 <finish>:
  34:	00630063          	beq	t1,t1,34 <finish>

```
