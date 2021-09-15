
helloWorld.elf:     file format elf32-littleriscv

Contents of section .text:
 10054 13050503 1375f50f 67800000 b7070100  .....u..g.......
 10064 9387470a b706000e 03c70700 63140702  ..G.........c...
 10074 b707000e 1307a000 2380e700 93064003  ........#.....@.
 10084 2380d700 93062003 2380d700 2380e700  #..... .#...#...
 10094 67800000 2380e600 93871700 6ff0dffc  g...#.......o...
Contents of section .rodata:
 100a4 48656c6c 6f206672 6f6d2048 657276c3  Hello from Herv.
 100b4 a920210a 00                          . !..           
Contents of section .comment:
 0000 4743433a 2028474e 55292031 312e312e  GCC: (GNU) 11.1.
 0010 3000                                 0.              
Contents of section .riscv.attributes:
 0000 411b0000 00726973 63760001 11000000  A....riscv......
 0010 04100572 76333269 32703000           ...rv32i2p0.    

Disassembly of section .text:

00010054 <digit>:
   10054:	03050513          	addi	a0,a0,48
   10058:	0ff57513          	zext.b	a0,a0
   1005c:	00008067          	ret

00010060 <_start>:
   10060:	000107b7          	lui	a5,0x10
   10064:	0a478793          	addi	a5,a5,164 # 100a4 <_start+0x44>
   10068:	0e0006b7          	lui	a3,0xe000
   1006c:	0007c703          	lbu	a4,0(a5)
   10070:	02071463          	bnez	a4,10098 <_start+0x38>
   10074:	0e0007b7          	lui	a5,0xe000
   10078:	00a00713          	li	a4,10
   1007c:	00e78023          	sb	a4,0(a5) # e000000 <__global_pointer$+0xdfee747>
   10080:	03400693          	li	a3,52
   10084:	00d78023          	sb	a3,0(a5)
   10088:	03200693          	li	a3,50
   1008c:	00d78023          	sb	a3,0(a5)
   10090:	00e78023          	sb	a4,0(a5)
   10094:	00008067          	ret
   10098:	00e68023          	sb	a4,0(a3) # e000000 <__global_pointer$+0xdfee747>
   1009c:	00178793          	addi	a5,a5,1
   100a0:	fcdff06f          	j	1006c <_start+0xc>
