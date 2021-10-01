You need the risc-v gnu toolchain to assemble these exemples - Here is my workflow :

helloWorld.s
```
.globl _start
.align 2
.section .text

_start:
	lui	t0,0xe000
	li	t1,72
	sw	t1,0(t0)
	li	t1,101
	sw	t1,0(t0)
	li	t1,108
	sw	t1,0(t0)
	li	t1,108
	sw	t1,0(t0)
	li	t1,111
	sw	t1,0(t0)
	li	t1,10
	sw	t1,0(t0)

end:	ebreak

```

Assemble:
```
riscv32-unknown-elf-gcc -nostdlib -nostartfiles -T link.ld  helloWorld.s -o helloWorld.elf
```

Convert to binary:
```
riscv32-unknown-elf-objcopy helloWorld.elf -O binary helloWorld.bin
```

Check the binary:
```
hexdump -v -e '1/4 "%08x " "\n"' helloWorld.bin

0e0002b7
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
00100073
```

Compare it with the original assembly :
```
riscv32-unknown-elf-objdump -d helloWorld.elf

helloWorld.elf:     file format elf32-littleriscv


Disassembly of section .text:

80000000 <_start>:
80000000:	0e0002b7          	lui	t0,0xe000
80000004:	04800313          	li	t1,72
80000008:	0062a023          	sw	t1,0(t0) # e000000 <_start-0x72000000>
8000000c:	06500313          	li	t1,101
80000010:	0062a023          	sw	t1,0(t0)
80000014:	06c00313          	li	t1,108
80000018:	0062a023          	sw	t1,0(t0)
8000001c:	06c00313          	li	t1,108
80000020:	0062a023          	sw	t1,0(t0)
80000024:	06f00313          	li	t1,111
80000028:	0062a023          	sw	t1,0(t0)
8000002c:	00a00313          	li	t1,10
80000030:	0062a023          	sw	t1,0(t0)

80000034 <end>:
80000034:	00100073          	ebreak
```
