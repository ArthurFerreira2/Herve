You need the risc-v gnu toolchain to assemble these exemples - Here is my workflow :

helloWorld.s
```
.section .text

.global boot
.type boot, @function
boot:

	lui	t0, 0xFFFF 	# memory mapped putchar

	andi	t1, t1, 0
	addi	t1, t1, 72  # H
	sw	t1, 0(t0)

	andi	t1, t1, 0
	addi	t1, t1, 101 # e
	sw	t1, 0(t0)

	andi	t1, t1, 0
	addi	t1, t1, 108 # l
	sw	t1, 0(t0)

	andi	t1, t1, 0
	addi	t1, t1, 108 # l
	sw	t1, 0(t0)

	andi	t1, t1, 0
	addi	t1, t1, 111 # O
	sw	t1, 0(t0)

	andi	t1, t1, 0
	addi	t1, t1, 10 # Line Feed
	sw	t1, 0(t0)

finish:
	beq	t1, t1, finish # endless loop
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
0ffff2b7
00037313
04830313
0062a023
00037313
06530313
0062a023
00037313
06c30313
0062a023
00037313
06c30313
0062a023
00037313
06f30313
0062a023
00037313
00a30313
0062a023
00630063
```

Compare it with the original assembly :
```
riscv32-unknown-elf-objdump -d helloWorld.elf

helloWorld.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <boot>:
   0:	0ffff2b7          	lui	t0,0xffff
   4:	00037313          	andi	t1,t1,0
   8:	04830313          	addi	t1,t1,72
   c:	0062a023          	sw	t1,0(t0) # ffff000 <finish+0xfffefb4>
  10:	00037313          	andi	t1,t1,0
  14:	06530313          	addi	t1,t1,101
  18:	0062a023          	sw	t1,0(t0)
  1c:	00037313          	andi	t1,t1,0
  20:	06c30313          	addi	t1,t1,108
  24:	0062a023          	sw	t1,0(t0)
  28:	00037313          	andi	t1,t1,0
  2c:	06c30313          	addi	t1,t1,108
  30:	0062a023          	sw	t1,0(t0)
  34:	00037313          	andi	t1,t1,0
  38:	06f30313          	addi	t1,t1,111
  3c:	0062a023          	sw	t1,0(t0)
  40:	00037313          	andi	t1,t1,0
  44:	00a30313          	addi	t1,t1,10
  48:	0062a023          	sw	t1,0(t0)

0000004c <finish>:
  4c:	00630063          	beq	t1,t1,4c <finish>
```
