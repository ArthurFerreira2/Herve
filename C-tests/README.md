



# Developping in C for Herve :

You need the risc-v gnu toolchain to compile these exemples - Here is my workflow :


We use **_start** as program entry point and not **main**  
We don't use the stdlib

helloWorld.c
```C
char digit(int a) {
    return a + 48;
}

void _start() {
  volatile char* tx = (volatile char*) 0x0e000000;
  const char* hello = "Hello from Hervé !\n";
  while (*hello) {
    *tx = *hello;
    hello++;
  }

  *tx = '\n';
  *tx = digit(4);
  *tx = digit(2);
  *tx = '\n';
}
```


## Compilation
```shell
riscv32-unknown-elf-gcc -march=rv32i -mabi=ilp32 -Os -nostdlib -Wall -Werror helloWorld.c -o helloWorld.elf
```




## de-assembly
```shell
riscv32-unknown-elf-objdump -ds helloWorld.elf > helloWorld.s
```

cat helloWorld.s

```
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
```

## Inspection

### Header
```
riscv32-unknown-elf-readelf -h helloWorld.elf

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
  Entry point address:               0x10060
  Start of program headers:          52 (bytes into file)
  Start of section headers:          648 (bytes into file)
  Flags:                             0x0
  Size of this header:               52 (bytes)
  Size of program headers:           32 (bytes)
  Number of program headers:         1
  Size of section headers:           40 (bytes)
  Number of section headers:         8
  Section header string table index: 7

```

### Segments
```
riscv32-unknown-elf-readelf --segments helloWorld.elf

Elf file type is EXEC (Executable file)
Entry point 0x10060
There is 1 program header, starting at offset 52

Program Headers:
  Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Align
  LOAD           0x000000 0x00010000 0x00010000 0x000b9 0x000b9 R E 0x1000

 Section to Segment mapping:
  Segment Sections...
   00     .text .rodata
```

### Sections
```
riscv32-unknown-elf-readelf --sections helloWorld.elf

There are 8 section headers, starting at offset 0x288:

Section Headers:
  [Nr] Name              Type            Addr     Off    Size   ES Flg Lk Inf Al
  [ 0]                   NULL            00000000 000000 000000 00      0   0  0
  [ 1] .text             PROGBITS        00010054 000054 000050 00  AX  0   0  4
  [ 2] .rodata           PROGBITS        000100a4 0000a4 000015 01 AMS  0   0  4
  [ 3] .comment          PROGBITS        00000000 0000b9 000012 01  MS  0   0  1
  [ 4] .riscv.attributes RISCV_ATTRIBUTE 00000000 0000cb 00001c 00      0   0  1
  [ 5] .symtab           SYMTAB          00000000 0000e8 0000f0 10      6   6  4
  [ 6] .strtab           STRTAB          00000000 0001d8 000069 00      0   0  1
  [ 7] .shstrtab         STRTAB          00000000 000241 000044 00      0   0  1
Key to Flags:
  W (write), A (alloc), X (execute), M (merge), S (strings), I (info),
  L (link order), O (extra OS processing required), G (group), T (TLS),
  C (compressed), x (unknown), o (OS specific), E (exclude),
  D (mbind), p (processor specific)
```

### Binary dumps

```shell
riscv32-unknown-elf-objcopy helloWorld.elf  -O binary helloWorld.bin
```

```
hd helloWorld.bin

00000000  13 05 05 03 13 75 f5 0f  67 80 00 00 b7 07 01 00  |.....u..g.......|
00000010  93 87 47 0a b7 06 00 0e  03 c7 07 00 63 14 07 02  |..G.........c...|
00000020  b7 07 00 0e 13 07 a0 00  23 80 e7 00 93 06 40 03  |........#.....@.|
00000030  23 80 d7 00 93 06 20 03  23 80 d7 00 23 80 e7 00  |#..... .#...#...|
00000040  67 80 00 00 23 80 e6 00  93 87 17 00 6f f0 df fc  |g...#.......o...|
00000050  48 65 6c 6c 6f 20 66 72  6f 6d 20 48 65 72 76 c3  |Hello from Herv.|
00000060  a9 20 21 0a 00                                    |. !..|
00000065
```

```
xxd -p helloWorld.bin

130505031375f50f67800000b70701009387470ab706000e03c707006314
0702b707000e1307a0002380e700930640032380d700930620032380d700
2380e700678000002380e600938717006ff0dffc48656c6c6f2066726f6d
2048657276c3a920210a00
```

## Execution:

for better readability, we route stderr to the traces file

```
./herve C-tests/helloWorld.elf 2> traces
```

output:

```
Hello from Hervé !

42
```

Full traces:
```
Number of segments : 1
Loading segment #0 into memory
Flags            : 0x5
Size in file     : 0xb9
Size in memory   : 0xb9
Physical address : 0x10000
Virtual address  : 0x10000
10054 :    03050513
10058 :    0ff57513
1005c :    00008067
10060 :    000107b7
10064 :    0a478793
10068 :    0e0006b7
1006c :    0007c703
10070 :    02071463
10074 :    0e0007b7
10078 :    00a00713
1007c :    00e78023
10080 :    03400693
10084 :    00d78023
10088 :    03200693
1008c :    00d78023
10090 :    00e78023
10094 :    00008067
10098 :    00e68023
1009c :    00178793
100a0 :    fcdff06f
100a4 :    6c6c6548
100a8 :    7266206f
100ac :    48206d6f
100b0 :    c3767265
100b4 :    0a2120a9
100b8 :    43434700
100bc :    4728203a
100c0 :    2029554e
100c4 :    312e3131
100c8 :    4100302e
100cc :    0000001b
100d0 :    63736972
100d4 :    11010076
100d8 :    04000000
100dc :    76720510
100e0 :    32693233
100e4 :    00003070
100e8 :    00000000
100ec :    00000000
100f0 :    00000000
100f4 :    00000000
100f8 :    00000000
100fc :    00010054
10100 :    00000000
10104 :    00010003
10108 :    00000000
1010c :    000000a4

PC  : 00010060	Instruction : 000107b7	U-TYPE LUI
OP :  55   F3 :   0   F7 :   0   RS1 :  0   RS2 :  0   RD : 15   IMM :    65536
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :        0		x14 :        0		x15 :    10000
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010064	Instruction : 0a478793	I-TYPE ALU
OP :  19   F3 :   0   F7 :   0   RS1 : 15   RS2 :  0   RD : 15   IMM :      164
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :        0		x14 :        0		x15 :    100a4
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010068	Instruction : 0e0006b7	U-TYPE LUI
OP :  55   F3 :   0   F7 :   0   RS1 : 15   RS2 :  0   RD : 13   IMM : 234881024
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :        0		x15 :    100a4
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001006c	Instruction : 0007c703	I-TYPE LOADS
OP :   3   F3 :   4   F7 :   0   RS1 : 15   RS2 :  0   RD : 14   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       48		x15 :    100a4
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010070	Instruction : 02071463	B-TYPE
OP :  99   F3 :   1   F7 :   0   RS1 : 14   RS2 :  0   RD : 14   IMM :       40
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       48		x15 :    100a4
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010098	Instruction : 00e68023	S-TYPE
OP :  35   F3 :   0   F7 :   0   RS1 : 13   RS2 : 14   RD : 14   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       48		x15 :    100a4
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001009c	Instruction : 00178793	I-TYPE ALU
OP :  19   F3 :   0   F7 :   0   RS1 : 15   RS2 : 14   RD : 15   IMM :        1
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       48		x15 :    100a5
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 000100a0	Instruction : fcdff06f	J-TYPE JAL
OP : 111   F3 :   0   F7 :   0   RS1 : 15   RS2 : 14   RD :  0   IMM :      -52
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       48		x15 :    100a5
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001006c	Instruction : 0007c703	I-TYPE LOADS
OP :   3   F3 :   4   F7 :   0   RS1 : 15   RS2 : 14   RD : 14   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       65		x15 :    100a5
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010070	Instruction : 02071463	B-TYPE
OP :  99   F3 :   1   F7 :   0   RS1 : 14   RS2 :  0   RD : 14   IMM :       40
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       65		x15 :    100a5
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010098	Instruction : 00e68023	S-TYPE
OP :  35   F3 :   0   F7 :   0   RS1 : 13   RS2 : 14   RD : 14   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       65		x15 :    100a5
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001009c	Instruction : 00178793	I-TYPE ALU
OP :  19   F3 :   0   F7 :   0   RS1 : 15   RS2 : 14   RD : 15   IMM :        1
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       65		x15 :    100a6
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 000100a0	Instruction : fcdff06f	J-TYPE JAL
OP : 111   F3 :   0   F7 :   0   RS1 : 15   RS2 : 14   RD :  0   IMM :      -52
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       65		x15 :    100a6
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001006c	Instruction : 0007c703	I-TYPE LOADS
OP :   3   F3 :   4   F7 :   0   RS1 : 15   RS2 : 14   RD : 14   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       6c		x15 :    100a6
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010070	Instruction : 02071463	B-TYPE
OP :  99   F3 :   1   F7 :   0   RS1 : 14   RS2 :  0   RD : 14   IMM :       40
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       6c		x15 :    100a6
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010098	Instruction : 00e68023	S-TYPE
OP :  35   F3 :   0   F7 :   0   RS1 : 13   RS2 : 14   RD : 14   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       6c		x15 :    100a6
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001009c	Instruction : 00178793	I-TYPE ALU
OP :  19   F3 :   0   F7 :   0   RS1 : 15   RS2 : 14   RD : 15   IMM :        1
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       6c		x15 :    100a7
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 000100a0	Instruction : fcdff06f	J-TYPE JAL
OP : 111   F3 :   0   F7 :   0   RS1 : 15   RS2 : 14   RD :  0   IMM :      -52
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       6c		x15 :    100a7
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001006c	Instruction : 0007c703	I-TYPE LOADS
OP :   3   F3 :   4   F7 :   0   RS1 : 15   RS2 : 14   RD : 14   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       6c		x15 :    100a7
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010070	Instruction : 02071463	B-TYPE
OP :  99   F3 :   1   F7 :   0   RS1 : 14   RS2 :  0   RD : 14   IMM :       40
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       6c		x15 :    100a7
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010098	Instruction : 00e68023	S-TYPE
OP :  35   F3 :   0   F7 :   0   RS1 : 13   RS2 : 14   RD : 14   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       6c		x15 :    100a7
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001009c	Instruction : 00178793	I-TYPE ALU
OP :  19   F3 :   0   F7 :   0   RS1 : 15   RS2 : 14   RD : 15   IMM :        1
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       6c		x15 :    100a8
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 000100a0	Instruction : fcdff06f	J-TYPE JAL
OP : 111   F3 :   0   F7 :   0   RS1 : 15   RS2 : 14   RD :  0   IMM :      -52
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       6c		x15 :    100a8
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001006c	Instruction : 0007c703	I-TYPE LOADS
OP :   3   F3 :   4   F7 :   0   RS1 : 15   RS2 : 14   RD : 14   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       6f		x15 :    100a8
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010070	Instruction : 02071463	B-TYPE
OP :  99   F3 :   1   F7 :   0   RS1 : 14   RS2 :  0   RD : 14   IMM :       40
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       6f		x15 :    100a8
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010098	Instruction : 00e68023	S-TYPE
OP :  35   F3 :   0   F7 :   0   RS1 : 13   RS2 : 14   RD : 14   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       6f		x15 :    100a8
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001009c	Instruction : 00178793	I-TYPE ALU
OP :  19   F3 :   0   F7 :   0   RS1 : 15   RS2 : 14   RD : 15   IMM :        1
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       6f		x15 :    100a9
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 000100a0	Instruction : fcdff06f	J-TYPE JAL
OP : 111   F3 :   0   F7 :   0   RS1 : 15   RS2 : 14   RD :  0   IMM :      -52
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       6f		x15 :    100a9
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001006c	Instruction : 0007c703	I-TYPE LOADS
OP :   3   F3 :   4   F7 :   0   RS1 : 15   RS2 : 14   RD : 14   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       20		x15 :    100a9
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010070	Instruction : 02071463	B-TYPE
OP :  99   F3 :   1   F7 :   0   RS1 : 14   RS2 :  0   RD : 14   IMM :       40
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       20		x15 :    100a9
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010098	Instruction : 00e68023	S-TYPE
OP :  35   F3 :   0   F7 :   0   RS1 : 13   RS2 : 14   RD : 14   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       20		x15 :    100a9
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001009c	Instruction : 00178793	I-TYPE ALU
OP :  19   F3 :   0   F7 :   0   RS1 : 15   RS2 : 14   RD : 15   IMM :        1
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       20		x15 :    100aa
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 000100a0	Instruction : fcdff06f	J-TYPE JAL
OP : 111   F3 :   0   F7 :   0   RS1 : 15   RS2 : 14   RD :  0   IMM :      -52
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       20		x15 :    100aa
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001006c	Instruction : 0007c703	I-TYPE LOADS
OP :   3   F3 :   4   F7 :   0   RS1 : 15   RS2 : 14   RD : 14   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       66		x15 :    100aa
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010070	Instruction : 02071463	B-TYPE
OP :  99   F3 :   1   F7 :   0   RS1 : 14   RS2 :  0   RD : 14   IMM :       40
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       66		x15 :    100aa
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010098	Instruction : 00e68023	S-TYPE
OP :  35   F3 :   0   F7 :   0   RS1 : 13   RS2 : 14   RD : 14   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       66		x15 :    100aa
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001009c	Instruction : 00178793	I-TYPE ALU
OP :  19   F3 :   0   F7 :   0   RS1 : 15   RS2 : 14   RD : 15   IMM :        1
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       66		x15 :    100ab
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 000100a0	Instruction : fcdff06f	J-TYPE JAL
OP : 111   F3 :   0   F7 :   0   RS1 : 15   RS2 : 14   RD :  0   IMM :      -52
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       66		x15 :    100ab
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001006c	Instruction : 0007c703	I-TYPE LOADS
OP :   3   F3 :   4   F7 :   0   RS1 : 15   RS2 : 14   RD : 14   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       72		x15 :    100ab
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010070	Instruction : 02071463	B-TYPE
OP :  99   F3 :   1   F7 :   0   RS1 : 14   RS2 :  0   RD : 14   IMM :       40
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       72		x15 :    100ab
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010098	Instruction : 00e68023	S-TYPE
OP :  35   F3 :   0   F7 :   0   RS1 : 13   RS2 : 14   RD : 14   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       72		x15 :    100ab
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001009c	Instruction : 00178793	I-TYPE ALU
OP :  19   F3 :   0   F7 :   0   RS1 : 15   RS2 : 14   RD : 15   IMM :        1
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       72		x15 :    100ac
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 000100a0	Instruction : fcdff06f	J-TYPE JAL
OP : 111   F3 :   0   F7 :   0   RS1 : 15   RS2 : 14   RD :  0   IMM :      -52
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       72		x15 :    100ac
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001006c	Instruction : 0007c703	I-TYPE LOADS
OP :   3   F3 :   4   F7 :   0   RS1 : 15   RS2 : 14   RD : 14   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       6f		x15 :    100ac
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010070	Instruction : 02071463	B-TYPE
OP :  99   F3 :   1   F7 :   0   RS1 : 14   RS2 :  0   RD : 14   IMM :       40
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       6f		x15 :    100ac
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010098	Instruction : 00e68023	S-TYPE
OP :  35   F3 :   0   F7 :   0   RS1 : 13   RS2 : 14   RD : 14   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       6f		x15 :    100ac
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001009c	Instruction : 00178793	I-TYPE ALU
OP :  19   F3 :   0   F7 :   0   RS1 : 15   RS2 : 14   RD : 15   IMM :        1
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       6f		x15 :    100ad
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 000100a0	Instruction : fcdff06f	J-TYPE JAL
OP : 111   F3 :   0   F7 :   0   RS1 : 15   RS2 : 14   RD :  0   IMM :      -52
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       6f		x15 :    100ad
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001006c	Instruction : 0007c703	I-TYPE LOADS
OP :   3   F3 :   4   F7 :   0   RS1 : 15   RS2 : 14   RD : 14   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       6d		x15 :    100ad
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010070	Instruction : 02071463	B-TYPE
OP :  99   F3 :   1   F7 :   0   RS1 : 14   RS2 :  0   RD : 14   IMM :       40
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       6d		x15 :    100ad
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010098	Instruction : 00e68023	S-TYPE
OP :  35   F3 :   0   F7 :   0   RS1 : 13   RS2 : 14   RD : 14   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       6d		x15 :    100ad
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001009c	Instruction : 00178793	I-TYPE ALU
OP :  19   F3 :   0   F7 :   0   RS1 : 15   RS2 : 14   RD : 15   IMM :        1
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       6d		x15 :    100ae
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 000100a0	Instruction : fcdff06f	J-TYPE JAL
OP : 111   F3 :   0   F7 :   0   RS1 : 15   RS2 : 14   RD :  0   IMM :      -52
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       6d		x15 :    100ae
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001006c	Instruction : 0007c703	I-TYPE LOADS
OP :   3   F3 :   4   F7 :   0   RS1 : 15   RS2 : 14   RD : 14   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       20		x15 :    100ae
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010070	Instruction : 02071463	B-TYPE
OP :  99   F3 :   1   F7 :   0   RS1 : 14   RS2 :  0   RD : 14   IMM :       40
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       20		x15 :    100ae
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010098	Instruction : 00e68023	S-TYPE
OP :  35   F3 :   0   F7 :   0   RS1 : 13   RS2 : 14   RD : 14   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       20		x15 :    100ae
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001009c	Instruction : 00178793	I-TYPE ALU
OP :  19   F3 :   0   F7 :   0   RS1 : 15   RS2 : 14   RD : 15   IMM :        1
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       20		x15 :    100af
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 000100a0	Instruction : fcdff06f	J-TYPE JAL
OP : 111   F3 :   0   F7 :   0   RS1 : 15   RS2 : 14   RD :  0   IMM :      -52
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       20		x15 :    100af
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001006c	Instruction : 0007c703	I-TYPE LOADS
OP :   3   F3 :   4   F7 :   0   RS1 : 15   RS2 : 14   RD : 14   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       48		x15 :    100af
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010070	Instruction : 02071463	B-TYPE
OP :  99   F3 :   1   F7 :   0   RS1 : 14   RS2 :  0   RD : 14   IMM :       40
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       48		x15 :    100af
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010098	Instruction : 00e68023	S-TYPE
OP :  35   F3 :   0   F7 :   0   RS1 : 13   RS2 : 14   RD : 14   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       48		x15 :    100af
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001009c	Instruction : 00178793	I-TYPE ALU
OP :  19   F3 :   0   F7 :   0   RS1 : 15   RS2 : 14   RD : 15   IMM :        1
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       48		x15 :    100b0
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 000100a0	Instruction : fcdff06f	J-TYPE JAL
OP : 111   F3 :   0   F7 :   0   RS1 : 15   RS2 : 14   RD :  0   IMM :      -52
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       48		x15 :    100b0
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001006c	Instruction : 0007c703	I-TYPE LOADS
OP :   3   F3 :   4   F7 :   0   RS1 : 15   RS2 : 14   RD : 14   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       65		x15 :    100b0
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010070	Instruction : 02071463	B-TYPE
OP :  99   F3 :   1   F7 :   0   RS1 : 14   RS2 :  0   RD : 14   IMM :       40
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       65		x15 :    100b0
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010098	Instruction : 00e68023	S-TYPE
OP :  35   F3 :   0   F7 :   0   RS1 : 13   RS2 : 14   RD : 14   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       65		x15 :    100b0
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001009c	Instruction : 00178793	I-TYPE ALU
OP :  19   F3 :   0   F7 :   0   RS1 : 15   RS2 : 14   RD : 15   IMM :        1
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       65		x15 :    100b1
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 000100a0	Instruction : fcdff06f	J-TYPE JAL
OP : 111   F3 :   0   F7 :   0   RS1 : 15   RS2 : 14   RD :  0   IMM :      -52
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       65		x15 :    100b1
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001006c	Instruction : 0007c703	I-TYPE LOADS
OP :   3   F3 :   4   F7 :   0   RS1 : 15   RS2 : 14   RD : 14   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       72		x15 :    100b1
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010070	Instruction : 02071463	B-TYPE
OP :  99   F3 :   1   F7 :   0   RS1 : 14   RS2 :  0   RD : 14   IMM :       40
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       72		x15 :    100b1
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010098	Instruction : 00e68023	S-TYPE
OP :  35   F3 :   0   F7 :   0   RS1 : 13   RS2 : 14   RD : 14   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       72		x15 :    100b1
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001009c	Instruction : 00178793	I-TYPE ALU
OP :  19   F3 :   0   F7 :   0   RS1 : 15   RS2 : 14   RD : 15   IMM :        1
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       72		x15 :    100b2
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 000100a0	Instruction : fcdff06f	J-TYPE JAL
OP : 111   F3 :   0   F7 :   0   RS1 : 15   RS2 : 14   RD :  0   IMM :      -52
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       72		x15 :    100b2
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001006c	Instruction : 0007c703	I-TYPE LOADS
OP :   3   F3 :   4   F7 :   0   RS1 : 15   RS2 : 14   RD : 14   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       76		x15 :    100b2
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010070	Instruction : 02071463	B-TYPE
OP :  99   F3 :   1   F7 :   0   RS1 : 14   RS2 :  0   RD : 14   IMM :       40
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       76		x15 :    100b2
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010098	Instruction : 00e68023	S-TYPE
OP :  35   F3 :   0   F7 :   0   RS1 : 13   RS2 : 14   RD : 14   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       76		x15 :    100b2
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001009c	Instruction : 00178793	I-TYPE ALU
OP :  19   F3 :   0   F7 :   0   RS1 : 15   RS2 : 14   RD : 15   IMM :        1
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       76		x15 :    100b3
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 000100a0	Instruction : fcdff06f	J-TYPE JAL
OP : 111   F3 :   0   F7 :   0   RS1 : 15   RS2 : 14   RD :  0   IMM :      -52
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       76		x15 :    100b3
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001006c	Instruction : 0007c703	I-TYPE LOADS
OP :   3   F3 :   4   F7 :   0   RS1 : 15   RS2 : 14   RD : 14   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 : ffffffc3		x15 :    100b3
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010070	Instruction : 02071463	B-TYPE
OP :  99   F3 :   1   F7 :   0   RS1 : 14   RS2 :  0   RD : 14   IMM :       40
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 : ffffffc3		x15 :    100b3
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010098	Instruction : 00e68023	S-TYPE
OP :  35   F3 :   0   F7 :   0   RS1 : 13   RS2 : 14   RD : 14   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 : ffffffc3		x15 :    100b3
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001009c	Instruction : 00178793	I-TYPE ALU
OP :  19   F3 :   0   F7 :   0   RS1 : 15   RS2 : 14   RD : 15   IMM :        1
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 : ffffffc3		x15 :    100b4
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 000100a0	Instruction : fcdff06f	J-TYPE JAL
OP : 111   F3 :   0   F7 :   0   RS1 : 15   RS2 : 14   RD :  0   IMM :      -52
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 : ffffffc3		x15 :    100b4
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001006c	Instruction : 0007c703	I-TYPE LOADS
OP :   3   F3 :   4   F7 :   0   RS1 : 15   RS2 : 14   RD : 14   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 : ffffffa9		x15 :    100b4
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010070	Instruction : 02071463	B-TYPE
OP :  99   F3 :   1   F7 :   0   RS1 : 14   RS2 :  0   RD : 14   IMM :       40
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 : ffffffa9		x15 :    100b4
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010098	Instruction : 00e68023	S-TYPE
OP :  35   F3 :   0   F7 :   0   RS1 : 13   RS2 : 14   RD : 14   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 : ffffffa9		x15 :    100b4
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001009c	Instruction : 00178793	I-TYPE ALU
OP :  19   F3 :   0   F7 :   0   RS1 : 15   RS2 : 14   RD : 15   IMM :        1
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 : ffffffa9		x15 :    100b5
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 000100a0	Instruction : fcdff06f	J-TYPE JAL
OP : 111   F3 :   0   F7 :   0   RS1 : 15   RS2 : 14   RD :  0   IMM :      -52
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 : ffffffa9		x15 :    100b5
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001006c	Instruction : 0007c703	I-TYPE LOADS
OP :   3   F3 :   4   F7 :   0   RS1 : 15   RS2 : 14   RD : 14   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       20		x15 :    100b5
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010070	Instruction : 02071463	B-TYPE
OP :  99   F3 :   1   F7 :   0   RS1 : 14   RS2 :  0   RD : 14   IMM :       40
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       20		x15 :    100b5
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010098	Instruction : 00e68023	S-TYPE
OP :  35   F3 :   0   F7 :   0   RS1 : 13   RS2 : 14   RD : 14   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       20		x15 :    100b5
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001009c	Instruction : 00178793	I-TYPE ALU
OP :  19   F3 :   0   F7 :   0   RS1 : 15   RS2 : 14   RD : 15   IMM :        1
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       20		x15 :    100b6
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 000100a0	Instruction : fcdff06f	J-TYPE JAL
OP : 111   F3 :   0   F7 :   0   RS1 : 15   RS2 : 14   RD :  0   IMM :      -52
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       20		x15 :    100b6
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001006c	Instruction : 0007c703	I-TYPE LOADS
OP :   3   F3 :   4   F7 :   0   RS1 : 15   RS2 : 14   RD : 14   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       21		x15 :    100b6
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010070	Instruction : 02071463	B-TYPE
OP :  99   F3 :   1   F7 :   0   RS1 : 14   RS2 :  0   RD : 14   IMM :       40
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       21		x15 :    100b6
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010098	Instruction : 00e68023	S-TYPE
OP :  35   F3 :   0   F7 :   0   RS1 : 13   RS2 : 14   RD : 14   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       21		x15 :    100b6
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001009c	Instruction : 00178793	I-TYPE ALU
OP :  19   F3 :   0   F7 :   0   RS1 : 15   RS2 : 14   RD : 15   IMM :        1
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       21		x15 :    100b7
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 000100a0	Instruction : fcdff06f	J-TYPE JAL
OP : 111   F3 :   0   F7 :   0   RS1 : 15   RS2 : 14   RD :  0   IMM :      -52
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :       21		x15 :    100b7
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001006c	Instruction : 0007c703	I-TYPE LOADS
OP :   3   F3 :   4   F7 :   0   RS1 : 15   RS2 : 14   RD : 14   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :        a		x15 :    100b7
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010070	Instruction : 02071463	B-TYPE
OP :  99   F3 :   1   F7 :   0   RS1 : 14   RS2 :  0   RD : 14   IMM :       40
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :        a		x15 :    100b7
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010098	Instruction : 00e68023	S-TYPE
OP :  35   F3 :   0   F7 :   0   RS1 : 13   RS2 : 14   RD : 14   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :        a		x15 :    100b7
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001009c	Instruction : 00178793	I-TYPE ALU
OP :  19   F3 :   0   F7 :   0   RS1 : 15   RS2 : 14   RD : 15   IMM :        1
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :        a		x15 :    100b8
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 000100a0	Instruction : fcdff06f	J-TYPE JAL
OP : 111   F3 :   0   F7 :   0   RS1 : 15   RS2 : 14   RD :  0   IMM :      -52
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :        a		x15 :    100b8
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001006c	Instruction : 0007c703	I-TYPE LOADS
OP :   3   F3 :   4   F7 :   0   RS1 : 15   RS2 : 14   RD : 14   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :        0		x15 :    100b8
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010070	Instruction : 02071463	B-TYPE
OP :  99   F3 :   1   F7 :   0   RS1 : 14   RS2 :  0   RD : 14   IMM :       40
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :        0		x15 :    100b8
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010074	Instruction : 0e0007b7	U-TYPE LUI
OP :  55   F3 :   1   F7 :   0   RS1 : 14   RS2 :  0   RD : 15   IMM : 234881024
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :        0		x15 :  e000000
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010078	Instruction : 00a00713	I-TYPE ALU
OP :  19   F3 :   0   F7 :   0   RS1 :  0   RS2 :  0   RD : 14   IMM :       10
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :        a		x15 :  e000000
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001007c	Instruction : 00e78023	S-TYPE
OP :  35   F3 :   0   F7 :   0   RS1 : 15   RS2 : 14   RD : 14   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :  e000000		x14 :        a		x15 :  e000000
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010080	Instruction : 03400693	I-TYPE ALU
OP :  19   F3 :   0   F7 :   0   RS1 :  0   RS2 : 14   RD : 13   IMM :       52
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :       34		x14 :        a		x15 :  e000000
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010084	Instruction : 00d78023	S-TYPE
OP :  35   F3 :   0   F7 :   0   RS1 : 15   RS2 : 13   RD : 13   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :       34		x14 :        a		x15 :  e000000
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010088	Instruction : 03200693	I-TYPE ALU
OP :  19   F3 :   0   F7 :   0   RS1 :  0   RS2 : 13   RD : 13   IMM :       50
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :       32		x14 :        a		x15 :  e000000
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 0001008c	Instruction : 00d78023	S-TYPE
OP :  35   F3 :   0   F7 :   0   RS1 : 15   RS2 : 13   RD : 13   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :       32		x14 :        a		x15 :  e000000
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010090	Instruction : 00e78023	S-TYPE
OP :  35   F3 :   0   F7 :   0   RS1 : 15   RS2 : 14   RD : 13   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :       32		x14 :        a		x15 :  e000000
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0

PC  : 00010094	Instruction : 00008067	I-TYPE JALR
OP : 103   F3 :   0   F7 :   0   RS1 :  1   RS2 : 14   RD :  0   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :       32		x14 :        a		x15 :  e000000
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0
Illegal Memory Read

PC  : 00000000	Instruction : 00000000	Illegal instruction

OP :   0   F3 :   0   F7 :   0   RS1 :  1   RS2 : 14   RD :  0   IMM :        0
x00 :        0		x01 :        0		x02 :    20053		x03 :        0
x04 :        0		x05 :        0		x06 :        0		x07 :        0
x08 :        0		x09 :        0		x10 :        0		x11 :        0
x12 :        0		x13 :       32		x14 :        a		x15 :  e000000
x16 :        0		x17 :        0		x18 :        0		x19 :        0
x20 :        0		x21 :        0		x22 :        0		x23 :        0
x24 :        0		x25 :        0		x26 :        0		x27 :        0
x28 :        0		x29 :        0		x30 :        0		x31 :        0


Program terminated
After executing 115 instructions

```
