# Developping in C for Herve :

You need the risc-v gnu toolchain to compile these exemples  
In this folder, you will find some example C source,
a simple linker script,
and a shell script to help compiling your source into risc-v elf

## Compilation

```
./compile.sh <basename of your source file>
```

### Example :

```
$ ./compile.sh 3-recursion

~~~ HEADER :
ELF Header:
  Magic:   7f 45 4c 46 01 01 01 00 00 00 00 00 00 00 00 00
  Class:                             ELF32
  Data:                              2's complement, little endian
  Version:                           1 (current)
  OS/ABI:                            UNIX - System V
  ABI Version:                       0
  Type:                              EXEC (Executable file)
  Machine:                           RISC-V
  Version:                           0x1
  Entry point address:               0x334
  Start of program headers:          52 (bytes into file)
  Start of section headers:          5532 (bytes into file)
  Flags:                             0x0
  Size of this header:               52 (bytes)
  Size of program headers:           32 (bytes)
  Number of program headers:         1
  Size of section headers:           40 (bytes)
  Number of section headers:         9
  Section header string table index: 8

~~~ SEGMENTS :

Elf file type is EXEC (Executable file)
Entry point 0x334
There is 1 program header, starting at offset 52

Program Headers:
  Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
  LOAD           0x001000 0x00000000 0x00000000 0x003c4 0x003c4 RWE 0x1000

 Section to Segment mapping:
  Segment Sections...
   00     .text .rodata .sdata

~~~ SECTIONS :

There are 9 section headers, starting at offset 0x159c:

Section Headers:
  [Nr] Name              Type            Addr     Off    Size   ES Flg Lk Inf Al
  [ 0]                   NULL            00000000 000000 000000 00      0   0  0
  [ 1] .text             PROGBITS        00000000 001000 00039c 00  AX  0   0  4
  [ 2] .rodata           PROGBITS        0000039c 00139c 000024 00   A  0   0  4
  [ 3] .sdata            PROGBITS        000003c0 0013c0 000004 00  WA  0   0  4
  [ 4] .comment          PROGBITS        00000000 0013c4 000012 01  MS  0   0  1
  [ 5] .riscv.attributes RISCV_ATTRIBUTE 00000000 0013d6 00001c 00      0   0  1
  [ 6] .symtab           SYMTAB          00000000 0013f4 000110 10      7   7  4
  [ 7] .strtab           STRTAB          00000000 001504 00004d 00      0   0  1
  [ 8] .shstrtab         STRTAB          00000000 001551 00004b 00      0   0  1
Key to Flags:
  W (write), A (alloc), X (execute), M (merge), S (strings), I (info),
  L (link order), O (extra OS processing required), G (group), T (TLS),
  C (compressed), x (unknown), o (OS specific), E (exclude),
  D (mbind), p (processor specific)

~~~ DUMP :


3-recursion.elf:     file format elf32-littleriscv

Contents of section .text:
 0000 130101fe 232e8100 13040102 2326a4fe  ....#.......#&..
 0010 8327c4fe 93f7f70f 93870703 93f7f70f  .'..............
 0020 13850700 0324c101 13010102 67800000  .....$......g...
 0030 130101fe 232e8100 13040102 2326a4fe  ....#.......#&..
 0040 2324b4fe 6f004001 0327c4fe 832784fe  #$..o.@..'...'..
 0050 b307f740 2326f4fe 0327c4fe 832784fe  ...@#&...'...'..
 0060 e354f7fe 8327c4fe 13850700 0324c101  .T...'.......$..
 0070 13010102 67800000 130101fd 23268102  ....g.......#&..
 0080 13040103 232ea4fc 232cb4fc 832784fd  ....#...#,...'..
 0090 63960700 93070000 6f008003 232604fe  c.......o...#&..
 00a0 6f000002 0327c4fd 832784fd b307f740  o....'...'.....@
 00b0 232ef4fc 8327c4fe 93871700 2326f4fe  #....'......#&..
 00c0 0327c4fd 832784fd e35ef7fc 8327c4fe  .'...'...^...'..
 00d0 13850700 0324c102 13010103 67800000  .....$......g...
 00e0 130101fd 23268102 13040103 232ea4fc  ....#&......#...
 00f0 232cb4fc 8327c4fd 93b71700 13f7f70f  #,...'..........
 0100 832784fd 93b71700 93f7f70f b367f700  .'...........g..
 0110 93f7f70f 63860700 93070000 6f004007  ....c.......o.@.
 0120 0327c4fd 832784fd 635af702 0327c4fd  .'...'..cZ...'..
 0130 832784fd b347f700 232ef4fc 032784fd  .'...G..#....'..
 0140 8327c4fd b347f700 232cf4fc 0327c4fd  .'...G..#,...'..
 0150 832784fd b347f700 232ef4fc 8327c4fd  .'...G..#....'..
 0160 2326f4fe 6f004001 0327c4fe 8327c4fd  #&..o.@..'...'..
 0170 b307f700 2326f4fe 832784fd 9387f7ff  ....#&...'......
 0180 232cf4fc 832784fd e39007fe 8327c4fe  #,...'.......'..
 0190 13850700 0324c102 13010103 67800000  .....$......g...
 01a0 130101fe 232e1100 232c8100 13040102  ....#...#,......
 01b0 2326a4fe 0327c4fe 93071000 63c6e700  #&...'......c...
 01c0 93071000 6f008002 8327c4fe 9387f7ff  ....o....'......
 01d0 13850700 eff0dffc 93070500 93850700  ................
 01e0 0325c4fe eff0dfef 93070500 13850700  .%..............
 01f0 8320c101 03248101 13010102 67800000  . ...$......g...
 0200 130101fd 23261102 23248102 13040103  ....#&..#$......
 0210 232ea4fc 8327c4fd 635cf00a 0327c4fd  #....'..c\...'..
 0220 b7870100 9387f769 63c4e70a 93075000  .......ic.....P.
 0230 2326f4fe 6f000005 8327c4fe 9387f7ff  #&..o....'......
 0240 2326f4fe 9305a000 0325c4fd eff05fde  #&.......%...._.
 0250 2324a4fe 032584fe eff09fda 93070500  #$...%..........
 0260 13870700 8327c4fe 938707ff b3878700  .....'..........
 0270 2388e7fe 9305a000 0325c4fd eff0dfdf  #........%......
 0280 232ea4fc 8327c4fd e348f0fa 6f008002  #....'...H..o...
 0290 8327003c 0327c4fe 130707ff 33078700  .'.<.'......3...
 02a0 034707ff 2380e700 8327c4fe 93871700  .G..#....'......
 02b0 2326f4fe 0327c4fe 93074000 e3dae7fc  #&...'....@.....
 02c0 8327003c 1307a000 2380e700 6f008000  .'.<....#...o...
 02d0 13000000 8320c102 03248102 13010103  ..... ...$......
 02e0 67800000 130101fe 232e8100 13040102  g.......#.......
 02f0 2326a4fe 6f000002 8327003c 0327c4fe  #&..o....'.<.'..
 0300 03470700 2380e700 8327c4fe 93871700  .G..#....'......
 0310 2326f4fe 8327c4fe 83c70700 e39e07fc  #&...'..........
 0320 13000000 13000000 0324c101 13010102  .........$......
 0330 67800000 130101ff 23261100 23248100  g.......#&..#$..
 0340 13040101 1305c039 eff0dff9 1305407b  .......9......@{
 0350 eff01feb 93057000 13059000 eff05fd8  ......p......._.
 0360 93070500 13850700 eff09fe9 13057000  ..............p.
 0370 eff01fe3 93070500 13850700 eff05fe8  .............._.
 0380 73001000 93070000 13850700 8320c100  s............ ..
 0390 03248100 13010101 67800000           .$......g...    
Contents of section .rodata:
 039c 6c657427 73207072 696e7420 736f6d65  let's print some
 03ac 20696e74 65726765 72207661 6c756573   interger values
 03bc 20210a00                              !..            
Contents of section .sdata:
 03c0 0000000e                             ....            
Contents of section .comment:
 0000 4743433a 2028474e 55292031 312e312e  GCC: (GNU) 11.1.
 0010 3000                                 0.              
Contents of section .riscv.attributes:
 0000 411b0000 00726973 63760001 11000000  A....riscv......
 0010 04100572 76333269 32703000           ...rv32i2p0.    

Disassembly of section .text:

00000000 <asciiOfNum>:
   0:	fe010113          	addi	sp,sp,-32
   4:	00812e23          	sw	s0,28(sp)
   8:	02010413          	addi	s0,sp,32
   c:	fea42623          	sw	a0,-20(s0)
  10:	fec42783          	lw	a5,-20(s0)
  14:	0ff7f793          	zext.b	a5,a5
  18:	03078793          	addi	a5,a5,48
  1c:	0ff7f793          	zext.b	a5,a5
  20:	00078513          	mv	a0,a5
  24:	01c12403          	lw	s0,28(sp)
  28:	02010113          	addi	sp,sp,32
  2c:	00008067          	ret

00000030 <mod>:
  30:	fe010113          	addi	sp,sp,-32
  34:	00812e23          	sw	s0,28(sp)
  38:	02010413          	addi	s0,sp,32
  3c:	fea42623          	sw	a0,-20(s0)
  40:	feb42423          	sw	a1,-24(s0)
  44:	0140006f          	j	58 <mod+0x28>
  48:	fec42703          	lw	a4,-20(s0)
  4c:	fe842783          	lw	a5,-24(s0)
  50:	40f707b3          	sub	a5,a4,a5
  54:	fef42623          	sw	a5,-20(s0)
  58:	fec42703          	lw	a4,-20(s0)
  5c:	fe842783          	lw	a5,-24(s0)
  60:	fef754e3          	bge	a4,a5,48 <mod+0x18>
  64:	fec42783          	lw	a5,-20(s0)
  68:	00078513          	mv	a0,a5
  6c:	01c12403          	lw	s0,28(sp)
  70:	02010113          	addi	sp,sp,32
  74:	00008067          	ret

00000078 <div>:
  78:	fd010113          	addi	sp,sp,-48
  7c:	02812623          	sw	s0,44(sp)
  80:	03010413          	addi	s0,sp,48
  84:	fca42e23          	sw	a0,-36(s0)
  88:	fcb42c23          	sw	a1,-40(s0)
  8c:	fd842783          	lw	a5,-40(s0)
  90:	00079663          	bnez	a5,9c <div+0x24>
  94:	00000793          	li	a5,0
  98:	0380006f          	j	d0 <div+0x58>
  9c:	fe042623          	sw	zero,-20(s0)
  a0:	0200006f          	j	c0 <div+0x48>
  a4:	fdc42703          	lw	a4,-36(s0)
  a8:	fd842783          	lw	a5,-40(s0)
  ac:	40f707b3          	sub	a5,a4,a5
  b0:	fcf42e23          	sw	a5,-36(s0)
  b4:	fec42783          	lw	a5,-20(s0)
  b8:	00178793          	addi	a5,a5,1
  bc:	fef42623          	sw	a5,-20(s0)
  c0:	fdc42703          	lw	a4,-36(s0)
  c4:	fd842783          	lw	a5,-40(s0)
  c8:	fcf75ee3          	bge	a4,a5,a4 <div+0x2c>
  cc:	fec42783          	lw	a5,-20(s0)
  d0:	00078513          	mv	a0,a5
  d4:	02c12403          	lw	s0,44(sp)
  d8:	03010113          	addi	sp,sp,48
  dc:	00008067          	ret

000000e0 <mult>:
  e0:	fd010113          	addi	sp,sp,-48
  e4:	02812623          	sw	s0,44(sp)
  e8:	03010413          	addi	s0,sp,48
  ec:	fca42e23          	sw	a0,-36(s0)
  f0:	fcb42c23          	sw	a1,-40(s0)
  f4:	fdc42783          	lw	a5,-36(s0)
  f8:	0017b793          	seqz	a5,a5
  fc:	0ff7f713          	zext.b	a4,a5
 100:	fd842783          	lw	a5,-40(s0)
 104:	0017b793          	seqz	a5,a5
 108:	0ff7f793          	zext.b	a5,a5
 10c:	00f767b3          	or	a5,a4,a5
 110:	0ff7f793          	zext.b	a5,a5
 114:	00078663          	beqz	a5,120 <mult+0x40>
 118:	00000793          	li	a5,0
 11c:	0740006f          	j	190 <mult+0xb0>
 120:	fdc42703          	lw	a4,-36(s0)
 124:	fd842783          	lw	a5,-40(s0)
 128:	02f75a63          	bge	a4,a5,15c <mult+0x7c>
 12c:	fdc42703          	lw	a4,-36(s0)
 130:	fd842783          	lw	a5,-40(s0)
 134:	00f747b3          	xor	a5,a4,a5
 138:	fcf42e23          	sw	a5,-36(s0)
 13c:	fd842703          	lw	a4,-40(s0)
 140:	fdc42783          	lw	a5,-36(s0)
 144:	00f747b3          	xor	a5,a4,a5
 148:	fcf42c23          	sw	a5,-40(s0)
 14c:	fdc42703          	lw	a4,-36(s0)
 150:	fd842783          	lw	a5,-40(s0)
 154:	00f747b3          	xor	a5,a4,a5
 158:	fcf42e23          	sw	a5,-36(s0)
 15c:	fdc42783          	lw	a5,-36(s0)
 160:	fef42623          	sw	a5,-20(s0)
 164:	0140006f          	j	178 <mult+0x98>
 168:	fec42703          	lw	a4,-20(s0)
 16c:	fdc42783          	lw	a5,-36(s0)
 170:	00f707b3          	add	a5,a4,a5
 174:	fef42623          	sw	a5,-20(s0)
 178:	fd842783          	lw	a5,-40(s0)
 17c:	fff78793          	addi	a5,a5,-1
 180:	fcf42c23          	sw	a5,-40(s0)
 184:	fd842783          	lw	a5,-40(s0)
 188:	fe0790e3          	bnez	a5,168 <mult+0x88>
 18c:	fec42783          	lw	a5,-20(s0)
 190:	00078513          	mv	a0,a5
 194:	02c12403          	lw	s0,44(sp)
 198:	03010113          	addi	sp,sp,48
 19c:	00008067          	ret

000001a0 <fact>:
 1a0:	fe010113          	addi	sp,sp,-32
 1a4:	00112e23          	sw	ra,28(sp)
 1a8:	00812c23          	sw	s0,24(sp)
 1ac:	02010413          	addi	s0,sp,32
 1b0:	fea42623          	sw	a0,-20(s0)
 1b4:	fec42703          	lw	a4,-20(s0)
 1b8:	00100793          	li	a5,1
 1bc:	00e7c663          	blt	a5,a4,1c8 <fact+0x28>
 1c0:	00100793          	li	a5,1
 1c4:	0280006f          	j	1ec <fact+0x4c>
 1c8:	fec42783          	lw	a5,-20(s0)
 1cc:	fff78793          	addi	a5,a5,-1
 1d0:	00078513          	mv	a0,a5
 1d4:	fcdff0ef          	jal	ra,1a0 <fact>
 1d8:	00050793          	mv	a5,a0
 1dc:	00078593          	mv	a1,a5
 1e0:	fec42503          	lw	a0,-20(s0)
 1e4:	efdff0ef          	jal	ra,e0 <mult>
 1e8:	00050793          	mv	a5,a0
 1ec:	00078513          	mv	a0,a5
 1f0:	01c12083          	lw	ra,28(sp)
 1f4:	01812403          	lw	s0,24(sp)
 1f8:	02010113          	addi	sp,sp,32
 1fc:	00008067          	ret

00000200 <printInt>:
 200:	fd010113          	addi	sp,sp,-48
 204:	02112623          	sw	ra,44(sp)
 208:	02812423          	sw	s0,40(sp)
 20c:	03010413          	addi	s0,sp,48
 210:	fca42e23          	sw	a0,-36(s0)
 214:	fdc42783          	lw	a5,-36(s0)
 218:	0af05c63          	blez	a5,2d0 <printInt+0xd0>
 21c:	fdc42703          	lw	a4,-36(s0)
 220:	000187b7          	lui	a5,0x18
 224:	69f78793          	addi	a5,a5,1695 # 1869f <TX+0x182df>
 228:	0ae7c463          	blt	a5,a4,2d0 <printInt+0xd0>
 22c:	00500793          	li	a5,5
 230:	fef42623          	sw	a5,-20(s0)
 234:	0500006f          	j	284 <printInt+0x84>
 238:	fec42783          	lw	a5,-20(s0)
 23c:	fff78793          	addi	a5,a5,-1
 240:	fef42623          	sw	a5,-20(s0)
 244:	00a00593          	li	a1,10
 248:	fdc42503          	lw	a0,-36(s0)
 24c:	de5ff0ef          	jal	ra,30 <mod>
 250:	fea42423          	sw	a0,-24(s0)
 254:	fe842503          	lw	a0,-24(s0)
 258:	da9ff0ef          	jal	ra,0 <asciiOfNum>
 25c:	00050793          	mv	a5,a0
 260:	00078713          	mv	a4,a5
 264:	fec42783          	lw	a5,-20(s0)
 268:	ff078793          	addi	a5,a5,-16
 26c:	008787b3          	add	a5,a5,s0
 270:	fee78823          	sb	a4,-16(a5)
 274:	00a00593          	li	a1,10
 278:	fdc42503          	lw	a0,-36(s0)
 27c:	dfdff0ef          	jal	ra,78 <div>
 280:	fca42e23          	sw	a0,-36(s0)
 284:	fdc42783          	lw	a5,-36(s0)
 288:	faf048e3          	bgtz	a5,238 <printInt+0x38>
 28c:	0280006f          	j	2b4 <printInt+0xb4>
 290:	3c002783          	lw	a5,960(zero) # 3c0 <TX>
 294:	fec42703          	lw	a4,-20(s0)
 298:	ff070713          	addi	a4,a4,-16
 29c:	00870733          	add	a4,a4,s0
 2a0:	ff074703          	lbu	a4,-16(a4)
 2a4:	00e78023          	sb	a4,0(a5)
 2a8:	fec42783          	lw	a5,-20(s0)
 2ac:	00178793          	addi	a5,a5,1
 2b0:	fef42623          	sw	a5,-20(s0)
 2b4:	fec42703          	lw	a4,-20(s0)
 2b8:	00400793          	li	a5,4
 2bc:	fce7dae3          	bge	a5,a4,290 <printInt+0x90>
 2c0:	3c002783          	lw	a5,960(zero) # 3c0 <TX>
 2c4:	00a00713          	li	a4,10
 2c8:	00e78023          	sb	a4,0(a5)
 2cc:	0080006f          	j	2d4 <printInt+0xd4>
 2d0:	00000013          	nop
 2d4:	02c12083          	lw	ra,44(sp)
 2d8:	02812403          	lw	s0,40(sp)
 2dc:	03010113          	addi	sp,sp,48
 2e0:	00008067          	ret

000002e4 <printStr>:
 2e4:	fe010113          	addi	sp,sp,-32
 2e8:	00812e23          	sw	s0,28(sp)
 2ec:	02010413          	addi	s0,sp,32
 2f0:	fea42623          	sw	a0,-20(s0)
 2f4:	0200006f          	j	314 <printStr+0x30>
 2f8:	3c002783          	lw	a5,960(zero) # 3c0 <TX>
 2fc:	fec42703          	lw	a4,-20(s0)
 300:	00074703          	lbu	a4,0(a4)
 304:	00e78023          	sb	a4,0(a5)
 308:	fec42783          	lw	a5,-20(s0)
 30c:	00178793          	addi	a5,a5,1
 310:	fef42623          	sw	a5,-20(s0)
 314:	fec42783          	lw	a5,-20(s0)
 318:	0007c783          	lbu	a5,0(a5)
 31c:	fc079ee3          	bnez	a5,2f8 <printStr+0x14>
 320:	00000013          	nop
 324:	00000013          	nop
 328:	01c12403          	lw	s0,28(sp)
 32c:	02010113          	addi	sp,sp,32
 330:	00008067          	ret

00000334 <main>:
 334:	ff010113          	addi	sp,sp,-16
 338:	00112623          	sw	ra,12(sp)
 33c:	00812423          	sw	s0,8(sp)
 340:	01010413          	addi	s0,sp,16
 344:	39c00513          	li	a0,924
 348:	f9dff0ef          	jal	ra,2e4 <printStr>
 34c:	7b400513          	li	a0,1972
 350:	eb1ff0ef          	jal	ra,200 <printInt>
 354:	00700593          	li	a1,7
 358:	00900513          	li	a0,9
 35c:	d85ff0ef          	jal	ra,e0 <mult>
 360:	00050793          	mv	a5,a0
 364:	00078513          	mv	a0,a5
 368:	e99ff0ef          	jal	ra,200 <printInt>
 36c:	00700513          	li	a0,7
 370:	e31ff0ef          	jal	ra,1a0 <fact>
 374:	00050793          	mv	a5,a0
 378:	00078513          	mv	a0,a5
 37c:	e85ff0ef          	jal	ra,200 <printInt>
 380:	00100073          	ebreak
 384:	00000793          	li	a5,0
 388:	00078513          	mv	a0,a5
 38c:	00c12083          	lw	ra,12(sp)
 390:	00812403          	lw	s0,8(sp)
 394:	01010113          	addi	sp,sp,16
 398:	00008067          	ret

```

## Execution

```
$ ../herve 3-recursion.elf 2>3-recursion.traces
let's print some interger values !
1972
63
5040
```

### Tracing

The execution traces were redirected into the file 3-recursion.traces :

```
$ less 3-recursion.traces
Number of segments : 1
Seg: 0  moving cursor to 4096

Loading segment  : 0x0
Flags            : 0x7
Size in file     : 0x3c4
Size in memory   : 0x3c4
Physical address : 0x0
Virtual address  : 0x0
start of memory  : 0x0
Entry point      : 0x334
Stack Pointer    : 0xffff
00000000 fe010113
00000004 00812e23
00000008 02010413
0000000c fea42623
00000010 fec42783
00000014 0ff7f793
00000018 03078793
0000001c 0ff7f793
00000020 00078513
00000024 01c12403
00000028 02010113
0000002c 00008067
00000030 fe010113

<OUTPUT OMITTED>

000003a8 656d6f73
000003ac 746e6920
000003b0 65677265
000003b4 61762072
000003b8 7365756c
000003bc 000a2120
000003c0 0e000000

PC  : 00000334  Instruction : ff010113  I-TYPE ALU
OP :  13   F3 : 0   F7 :   0   RS1 : sp    RS2 : zr    RD : sp    IMM : fffffff0
zr  00000000 | ra  00000000 | sp  0000ffef | gp  00000000 | tp  00000000 | t0  00000000 | t1  00000000 | t2  00000000 |
s0  00000000 | s1  00000000 | a0  00000000 | a1  00000000 | a2  00000000 | a3  00000000 | a4  00000000 | a5  00000000 |
a6  00000000 | a7  00000000 | s2  00000000 | s3  00000000 | s4  00000000 | s5  00000000 | s6  00000000 | s7  00000000 |
s8  00000000 | s9  00000000 | s10 00000000 | s11 00000000 | t3  00000000 | t4  00000000 | t5  00000000 | t6  00000000 |


PC  : 00000338  Instruction : 00112623  S-TYPE
OP :  23   F3 : 2   F7 :   0   RS1 : sp    RS2 : ra    RD : sp    IMM :        c
zr  00000000 | ra  00000000 | sp  0000ffef | gp  00000000 | tp  00000000 | t0  00000000 | t1  00000000 | t2  00000000 |
s0  00000000 | s1  00000000 | a0  00000000 | a1  00000000 | a2  00000000 | a3  00000000 | a4  00000000 | a5  00000000 |
a6  00000000 | a7  00000000 | s2  00000000 | s3  00000000 | s4  00000000 | s5  00000000 | s6  00000000 | s7  00000000 |
s8  00000000 | s9  00000000 | s10 00000000 | s11 00000000 | t3  00000000 | t4  00000000 | t5  00000000 | t6  00000000 |


PC  : 0000033c  Instruction : 00812423  S-TYPE
OP :  23   F3 : 2   F7 :   0   RS1 : sp    RS2 : s0    RD : sp    IMM :        8
zr  00000000 | ra  00000000 | sp  0000ffef | gp  00000000 | tp  00000000 | t0  00000000 | t1  00000000 | t2  00000000 |
s0  00000000 | s1  00000000 | a0  00000000 | a1  00000000 | a2  00000000 | a3  00000000 | a4  00000000 | a5  00000000 |
a6  00000000 | a7  00000000 | s2  00000000 | s3  00000000 | s4  00000000 | s5  00000000 | s6  00000000 | s7  00000000 |
s8  00000000 | s9  00000000 | s10 00000000 | s11 00000000 | t3  00000000 | t4  00000000 | t5  00000000 | t6  00000000 |

<OUTPUT OMITTED>

PC  : 00000380	Instruction : 00100073	E-TYPE
OP :  73   F3 : 0   F7 :   0   RS1 : zr    RS2 : a4    RD : zr    IMM :        0
zr  00000000 | ra  00000380 | sp  0000ffef | gp  00000000 | tp  00000000 | t0  00000000 | t1  00000000 | t2  00000000 |
s0  0000ffff | s1  00000000 | a0  00000000 | a1  0000000a | a2  00000000 | a3  00000000 | a4  0000000a | a5  0e000000 |
a6  00000000 | a7  00000000 | s2  00000000 | s3  00000000 | s4  00000000 | s5  00000000 | s6  00000000 | s7  00000000 |
s8  00000000 | s9  00000000 | s10 00000000 | s11 00000000 | t3  00000000 | t4  00000000 | t5  00000000 | t6  00000000 |



Program halted after 15151 instruction cycles
```
