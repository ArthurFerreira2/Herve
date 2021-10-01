// Only works if I put the program entry point firsts ....
// I need a loader that make some initializations and jump to main ... and then ebreak

char digit(int a);

void _start() {
  char* tx = (char*) 0x0e000000;

  *tx = digit(4);
  *tx = digit(2);
  *tx = '\n';
}

char digit(int a) {
    return a + 48;
}


/*

kilo [ C-tests ]$ ./compile.sh 1-function

1-function.elf:     file format elf32-littleriscv

Contents of section .text:
 0000 130101fe 232e1100 232c8100 13040102  ....#...#,......
 0010 b707000e 2326f4fe 13054000 ef00c004  ....#&....@.....
 0020 93070500 13870700 8327c4fe 2380e700  .........'..#...
 0030 13052000 ef004003 93070500 13870700  .. ...@.........
 0040 8327c4fe 2380e700 8327c4fe 1307a000  .'..#....'......
 0050 2380e700 13000000 8320c101 03248101  #........ ...$..
 0060 13010102 67800000 130101fe 232e8100  ....g.......#...
 0070 13040102 2326a4fe 8327c4fe 93f7f70f  ....#&...'......
 0080 93870703 93f7f70f 13850700 0324c101  .............$..
 0090 13010102 67800000                    ....g...
Contents of section .comment:
 0000 4743433a 2028474e 55292031 312e312e  GCC: (GNU) 11.1.
 0010 3000                                 0.
Contents of section .riscv.attributes:
 0000 411b0000 00726973 63760001 11000000  A....riscv......
 0010 04100572 76333269 32703000           ...rv32i2p0.

Disassembly of section .text:

00000000 <_start>:
   0:	fe010113          	addi	sp,sp,-32
   4:	00112e23          	sw	ra,28(sp)
   8:	00812c23          	sw	s0,24(sp)
   c:	02010413          	addi	s0,sp,32
  10:	0e0007b7          	lui	a5,0xe000
  14:	fef42623          	sw	a5,-20(s0)
  18:	00400513          	li	a0,4
  1c:	04c000ef          	jal	ra,68 <digit>
  20:	00050793          	mv	a5,a0
  24:	00078713          	mv	a4,a5
  28:	fec42783          	lw	a5,-20(s0)
  2c:	00e78023          	sb	a4,0(a5) # e000000 <digit+0xdffff98>
  30:	00200513          	li	a0,2
  34:	034000ef          	jal	ra,68 <digit>
  38:	00050793          	mv	a5,a0
  3c:	00078713          	mv	a4,a5
  40:	fec42783          	lw	a5,-20(s0)
  44:	00e78023          	sb	a4,0(a5)
  48:	fec42783          	lw	a5,-20(s0)
  4c:	00a00713          	li	a4,10
  50:	00e78023          	sb	a4,0(a5)
  54:	00000013          	nop
  58:	01c12083          	lw	ra,28(sp)
  5c:	01812403          	lw	s0,24(sp)
  60:	02010113          	addi	sp,sp,32
  64:	00008067          	ret

00000068 <digit>:
  68:	fe010113          	addi	sp,sp,-32
  6c:	00812e23          	sw	s0,28(sp)
  70:	02010413          	addi	s0,sp,32
  74:	fea42623          	sw	a0,-20(s0)
  78:	fec42783          	lw	a5,-20(s0)
  7c:	0ff7f793          	zext.b	a5,a5
  80:	03078793          	addi	a5,a5,48
  84:	0ff7f793          	zext.b	a5,a5
  88:	00078513          	mv	a0,a5
  8c:	01c12403          	lw	s0,28(sp)
  90:	02010113          	addi	sp,sp,32
  94:	00008067          	ret

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
  Entry point address:               0x0
  Start of program headers:          52 (bytes into file)
  Start of section headers:          4496 (bytes into file)
  Flags:                             0x0
  Size of this header:               52 (bytes)
  Size of program headers:           32 (bytes)
  Number of program headers:         1
  Size of section headers:           40 (bytes)
  Number of section headers:         7
  Section header string table index: 6

~~~ SEGMENTS :

Elf file type is EXEC (Executable file)
Entry point 0x0
There is 1 program header, starting at offset 52

Program Headers:
  Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
  LOAD           0x001000 0x00000000 0x00000000 0x00098 0x00098 R E 0x1000

 Section to Segment mapping:
  Segment Sections...
   00     .text

~~~ SECTIONS :

There are 7 section headers, starting at offset 0x1190:

Section Headers:
  [Nr] Name              Type            Addr     Off    Size   ES Flg Lk Inf Al
  [ 0]                   NULL            00000000 000000 000000 00      0   0  0
  [ 1] .text             PROGBITS        00000000 001000 000098 00  AX  0   0  4
  [ 2] .comment          PROGBITS        00000000 001098 000012 01  MS  0   0  1
  [ 3] .riscv.attributes RISCV_ATTRIBUTE 00000000 0010aa 00001c 00      0   0  1
  [ 4] .symtab           SYMTAB          00000000 0010c8 000070 10      5   5  4
  [ 5] .strtab           STRTAB          00000000 001138 00001b 00      0   0  1
  [ 6] .shstrtab         STRTAB          00000000 001153 00003c 00      0   0  1
Key to Flags:
  W (write), A (alloc), X (execute), M (merge), S (strings), I (info),
  L (link order), O (extra OS processing required), G (group), T (TLS),
  C (compressed), x (unknown), o (OS specific), E (exclude),
  D (mbind), p (processor specific)

~~~ HD BIN DUMP :

00000000  13 01 01 fe 23 2e 11 00  23 2c 81 00 13 04 01 02  |....#...#,......|
00000010  b7 07 00 0e 23 26 f4 fe  13 05 40 00 ef 00 c0 04  |....#&....@.....|
00000020  93 07 05 00 13 87 07 00  83 27 c4 fe 23 80 e7 00  |.........'..#...|
00000030  13 05 20 00 ef 00 40 03  93 07 05 00 13 87 07 00  |.. ...@.........|
00000040  83 27 c4 fe 23 80 e7 00  83 27 c4 fe 13 07 a0 00  |.'..#....'......|
00000050  23 80 e7 00 13 00 00 00  83 20 c1 01 03 24 81 01  |#........ ...$..|
00000060  13 01 01 02 67 80 00 00  13 01 01 fe 23 2e 81 00  |....g.......#...|
00000070  13 04 01 02 23 26 a4 fe  83 27 c4 fe 93 f7 f7 0f  |....#&...'......|
00000080  93 87 07 03 93 f7 f7 0f  13 85 07 00 03 24 c1 01  |.............$..|
00000090  13 01 01 02 67 80 00 00                           |....g...|
00000098

*/
