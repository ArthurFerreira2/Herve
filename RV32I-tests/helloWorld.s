
helloWorld.elf:     file format elf32-littleriscv


Disassembly of section .text:

00010054 <_start>:
   10054:	0e0002b7          	lui	t0,0xe000
   10058:	04800313          	li	t1,72
   1005c:	0062a023          	sw	t1,0(t0) # e000000 <__global_pointer$+0xdfee774>
   10060:	06500313          	li	t1,101
   10064:	0062a023          	sw	t1,0(t0)
   10068:	06c00313          	li	t1,108
   1006c:	0062a023          	sw	t1,0(t0)
   10070:	06c00313          	li	t1,108
   10074:	0062a023          	sw	t1,0(t0)
   10078:	06f00313          	li	t1,111
   1007c:	0062a023          	sw	t1,0(t0)
   10080:	00a00313          	li	t1,10
   10084:	0062a023          	sw	t1,0(t0)

00010088 <finish>:
   10088:	00630063          	beq	t1,t1,10088 <finish>

Disassembly of section .riscv.attributes:

00000000 <.riscv.attributes>:
   0:	1941                	addi	s2,s2,-16
   2:	0000                	unimp
   4:	7200                	flw	fs0,32(a2)
   6:	7369                	lui	t1,0xffffa
   8:	01007663          	bgeu	zero,a6,14 <_start-0x10040>
   c:	0000000f          	fence	unknown,unknown
  10:	7205                	lui	tp,0xfffe1
  12:	3376                	fld	ft6,376(sp)
  14:	6932                	flw	fs2,12(sp)
  16:	7032                	flw	ft0,44(sp)
  18:	0030                	addi	a2,sp,8
