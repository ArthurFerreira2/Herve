


# Hervé, the RV simulator
a tiny RISC-V RV32I ISA Simulator in C++ under the MIT Licence

I bought "the risc-v reader, an open architecture atlas" by D. Paterson and A. Waterman and decided to write an ISA simulator ... **Welcome to the twisted world of computer scientists**


Herve now extract loads froms ELF files and can execute compiled C code ! - cf. [README.md](C-tests/README.md) in the C-tests folder


## loader

Our memory is only 64KiB  (who needs more ?)  
we load the binaries from the ELF into memory and set the program counter (PC).   
The stack is set at address 0xFFFF

Memory is flat : no paging, no access attributes and thus you can read, write and execute at any location.

## memory mapped I/O

this is a primitive solution until I implement ecalls

```C
#define GETCHAR 0x0f000000
#define PUTCHAR 0x0e000000
```
store a byte at 0x0e000000 and it will be output to stdout
keypresses **will** be available at address 0x0f000000

## progress update

All RV32I instructions were implemented and fully tested.

I use the test suite published at : https://github.com/riscv-software-src/riscv-tests and this short shell script to automate the testings

```shell
#!/bin/sh

for test in `ls tests/ | grep -v dump | grep -v traces`
do
  echo -n "$test\t: "
  ./herve ./tests/$test 2> tests/$test.traces
done
```

| Instruction | Description                         | Implemented | Tested |
|-------------|-------------------------------------|:-----------:|:------:|
| LUI         | Load Upper Immediate                | yes         | pass   |
| AUIPC       | Add Upper Immediate to PC           | yes         | pass   |
| JAL         | Jump And Link                       | yes         | pass   |
| JALR        | Jump And Link Register              | yes         | pass   |
| BEQ         | Branch Equal                        | yes         | pass   |
| BNE         | Branch Not Equal                    | yes         | pass   |
| BLT         | Branch Less Than                    | yes         | pass   |
| BGE         | Branch Greater or Equal             | yes         | pass   |
| BLTU        | Branch Less Than Unsigned           | yes         | pass   |
| BGEU        | Branch Greater or Equal Unsigned    | yes         | pass   |
| LB          | Load Byte                           | yes         | pass   |
| LH          | Load Half word                      | yes         | pass   |
| LW          | Load Word                           | yes         | pass   |
| LBU         | Load Byte Unsigned                  | yes         | pass   |
| LHU         | Load Half word Unsigned             | yes         | pass   |
| SB          | Store Byte                          | yes         | pass   |
| SH          | Store Half Word                     | yes         | pass   |
| SW          | Store Word                          | yes         | pass   |
| ADDI        | ADD Immediate                       | yes         | pass   |
| SLTI        | Set Less Than Immediate             | yes         | pass   |
| SLTIU       | Set Less Than Immediate Unsigned    | yes         | pass   |
| XORI        | XOR Immediate                       | yes         | pass   |
| ORI         | OR Immediate                        | yes         | pass   |
| ANDI        | AND Immediate                       | yes         | pass   |
| SLLI        | Shift Left Logical Immediate        | yes         | pass   |
| SRAI        | Shift Right Arithmetical Immediate  | yes         | pass   |
| SRLI        | Shift Right Logical Immediate       | yes         | pass   |
| ADD         | Addition                            | yes         | pass   |
| SUB         | Substraction                        | yes         | pass   |
| SLL         | Shift Left Logical                  | yes         | pass   |
| SLT         | Set Less Than                       | yes         | pass   |
| SLTU        | Set Less Than Unsigned              | yes         | pass   |
| XOR         | Logic XOR                           | yes         | pass   |
| SRA         | Shift Right Arithmetical            | yes         | pass   |
| SRL         | Shift Right Logical                 | yes         | pass   |
| OR          | Logic OR                            | yes         | pass   |
| AND         | Logic AND                           | yes         | pass   |
| EBREAK      | Environment Break                   | kind of     | yeah   |
| ECALL       | Environment Call                    | kind of     | yeah   |
| FENCE       | Memory Ordering                     | as NOP*     | n/a    |

\* Any unimplemented instrution will halt the execution so I had to implement FENCE as a NOP.  


## Usage

### build

```shell
make
```

You now should have an executable called herve.

### run

Please refer to the [README.md](asm-tests/README.md) under the asm-tests folder for information on how to assemble and the [README.md](C-tests/README.md) under C-tests for information on how to compile your sources into risc-v elf binaries - Makefiles/shell scripts are also provided.


```shell
$ ./herve asm-tests/helloWorld.elf 2>traces
Hello


Program halted after 14 instruction cycles
```

The traces of the execution were redirected into the **traces** file :

```
$ cat traces
Number of segments : 1
Seg: 0  moving cursor to 4096

Loading segment  : 0x0
Flags            : 0x5
Size in file     : 0x38
Size in memory   : 0x38
Physical address : 0x80000000
Virtual address  : 0x80000000
start of memory  : 0x80000000
Entry point      : 0x80000000
Stack Pointer    : 0x8000ffff
80000000 0e0002b7
80000004 04800313
80000008 0062a023
8000000c 06500313
80000010 0062a023
80000014 06c00313
80000018 0062a023
8000001c 06c00313
80000020 0062a023
80000024 06f00313
80000028 0062a023
8000002c 00a00313
80000030 0062a023
80000034 00100073

PC  : 80000000	Instruction : 0e0002b7	U-TYPE LUI
OP :  37   F3 : 0   F7 :   0   RS1 : zr    RS2 : zr    RD : t0    IMM :  e000000
zr  00000000 | ra  00000000 | sp  8000ffff | gp  00000000 | tp  00000000 | t0  0e000000 | t1  00000000 | t2  00000000 |
s0  00000000 | s1  00000000 | a0  00000000 | a1  00000000 | a2  00000000 | a3  00000000 | a4  00000000 | a5  00000000 |
a6  00000000 | a7  00000000 | s2  00000000 | s3  00000000 | s4  00000000 | s5  00000000 | s6  00000000 | s7  00000000 |
s8  00000000 | s9  00000000 | s10 00000000 | s11 00000000 | t3  00000000 | t4  00000000 | t5  00000000 | t6  00000000 |


PC  : 80000004	Instruction : 04800313	I-TYPE ALU
OP :  13   F3 : 0   F7 :   0   RS1 : zr    RS2 : zr    RD : t1    IMM :       48
zr  00000000 | ra  00000000 | sp  8000ffff | gp  00000000 | tp  00000000 | t0  0e000000 | t1  00000048 | t2  00000000 |
s0  00000000 | s1  00000000 | a0  00000000 | a1  00000000 | a2  00000000 | a3  00000000 | a4  00000000 | a5  00000000 |
a6  00000000 | a7  00000000 | s2  00000000 | s3  00000000 | s4  00000000 | s5  00000000 | s6  00000000 | s7  00000000 |
s8  00000000 | s9  00000000 | s10 00000000 | s11 00000000 | t3  00000000 | t4  00000000 | t5  00000000 | t6  00000000 |


PC  : 80000008	Instruction : 0062a023	S-TYPE
OP :  23   F3 : 2   F7 :   0   RS1 : t0    RS2 : t1    RD : t1    IMM :        0
zr  00000000 | ra  00000000 | sp  8000ffff | gp  00000000 | tp  00000000 | t0  0e000000 | t1  00000048 | t2  00000000 |
s0  00000000 | s1  00000000 | a0  00000000 | a1  00000000 | a2  00000000 | a3  00000000 | a4  00000000 | a5  00000000 |
a6  00000000 | a7  00000000 | s2  00000000 | s3  00000000 | s4  00000000 | s5  00000000 | s6  00000000 | s7  00000000 |
s8  00000000 | s9  00000000 | s10 00000000 | s11 00000000 | t3  00000000 | t4  00000000 | t5  00000000 | t6  00000000 |


PC  : 8000000c	Instruction : 06500313	I-TYPE ALU
OP :  13   F3 : 0   F7 :   0   RS1 : zr    RS2 : t1    RD : t1    IMM :       65
zr  00000000 | ra  00000000 | sp  8000ffff | gp  00000000 | tp  00000000 | t0  0e000000 | t1  00000065 | t2  00000000 |
s0  00000000 | s1  00000000 | a0  00000000 | a1  00000000 | a2  00000000 | a3  00000000 | a4  00000000 | a5  00000000 |
a6  00000000 | a7  00000000 | s2  00000000 | s3  00000000 | s4  00000000 | s5  00000000 | s6  00000000 | s7  00000000 |
s8  00000000 | s9  00000000 | s10 00000000 | s11 00000000 | t3  00000000 | t4  00000000 | t5  00000000 | t6  00000000 |


PC  : 80000010	Instruction : 0062a023	S-TYPE
OP :  23   F3 : 2   F7 :   0   RS1 : t0    RS2 : t1    RD : t1    IMM :        0
zr  00000000 | ra  00000000 | sp  8000ffff | gp  00000000 | tp  00000000 | t0  0e000000 | t1  00000065 | t2  00000000 |
s0  00000000 | s1  00000000 | a0  00000000 | a1  00000000 | a2  00000000 | a3  00000000 | a4  00000000 | a5  00000000 |
a6  00000000 | a7  00000000 | s2  00000000 | s3  00000000 | s4  00000000 | s5  00000000 | s6  00000000 | s7  00000000 |
s8  00000000 | s9  00000000 | s10 00000000 | s11 00000000 | t3  00000000 | t4  00000000 | t5  00000000 | t6  00000000 |


PC  : 80000014	Instruction : 06c00313	I-TYPE ALU
OP :  13   F3 : 0   F7 :   0   RS1 : zr    RS2 : t1    RD : t1    IMM :       6c
zr  00000000 | ra  00000000 | sp  8000ffff | gp  00000000 | tp  00000000 | t0  0e000000 | t1  0000006c | t2  00000000 |
s0  00000000 | s1  00000000 | a0  00000000 | a1  00000000 | a2  00000000 | a3  00000000 | a4  00000000 | a5  00000000 |
a6  00000000 | a7  00000000 | s2  00000000 | s3  00000000 | s4  00000000 | s5  00000000 | s6  00000000 | s7  00000000 |
s8  00000000 | s9  00000000 | s10 00000000 | s11 00000000 | t3  00000000 | t4  00000000 | t5  00000000 | t6  00000000 |


PC  : 80000018	Instruction : 0062a023	S-TYPE
OP :  23   F3 : 2   F7 :   0   RS1 : t0    RS2 : t1    RD : t1    IMM :        0
zr  00000000 | ra  00000000 | sp  8000ffff | gp  00000000 | tp  00000000 | t0  0e000000 | t1  0000006c | t2  00000000 |
s0  00000000 | s1  00000000 | a0  00000000 | a1  00000000 | a2  00000000 | a3  00000000 | a4  00000000 | a5  00000000 |
a6  00000000 | a7  00000000 | s2  00000000 | s3  00000000 | s4  00000000 | s5  00000000 | s6  00000000 | s7  00000000 |
s8  00000000 | s9  00000000 | s10 00000000 | s11 00000000 | t3  00000000 | t4  00000000 | t5  00000000 | t6  00000000 |


PC  : 8000001c	Instruction : 06c00313	I-TYPE ALU
OP :  13   F3 : 0   F7 :   0   RS1 : zr    RS2 : t1    RD : t1    IMM :       6c
zr  00000000 | ra  00000000 | sp  8000ffff | gp  00000000 | tp  00000000 | t0  0e000000 | t1  0000006c | t2  00000000 |
s0  00000000 | s1  00000000 | a0  00000000 | a1  00000000 | a2  00000000 | a3  00000000 | a4  00000000 | a5  00000000 |
a6  00000000 | a7  00000000 | s2  00000000 | s3  00000000 | s4  00000000 | s5  00000000 | s6  00000000 | s7  00000000 |
s8  00000000 | s9  00000000 | s10 00000000 | s11 00000000 | t3  00000000 | t4  00000000 | t5  00000000 | t6  00000000 |


PC  : 80000020	Instruction : 0062a023	S-TYPE
OP :  23   F3 : 2   F7 :   0   RS1 : t0    RS2 : t1    RD : t1    IMM :        0
zr  00000000 | ra  00000000 | sp  8000ffff | gp  00000000 | tp  00000000 | t0  0e000000 | t1  0000006c | t2  00000000 |
s0  00000000 | s1  00000000 | a0  00000000 | a1  00000000 | a2  00000000 | a3  00000000 | a4  00000000 | a5  00000000 |
a6  00000000 | a7  00000000 | s2  00000000 | s3  00000000 | s4  00000000 | s5  00000000 | s6  00000000 | s7  00000000 |
s8  00000000 | s9  00000000 | s10 00000000 | s11 00000000 | t3  00000000 | t4  00000000 | t5  00000000 | t6  00000000 |


PC  : 80000024	Instruction : 06f00313	I-TYPE ALU
OP :  13   F3 : 0   F7 :   0   RS1 : zr    RS2 : t1    RD : t1    IMM :       6f
zr  00000000 | ra  00000000 | sp  8000ffff | gp  00000000 | tp  00000000 | t0  0e000000 | t1  0000006f | t2  00000000 |
s0  00000000 | s1  00000000 | a0  00000000 | a1  00000000 | a2  00000000 | a3  00000000 | a4  00000000 | a5  00000000 |
a6  00000000 | a7  00000000 | s2  00000000 | s3  00000000 | s4  00000000 | s5  00000000 | s6  00000000 | s7  00000000 |
s8  00000000 | s9  00000000 | s10 00000000 | s11 00000000 | t3  00000000 | t4  00000000 | t5  00000000 | t6  00000000 |


PC  : 80000028	Instruction : 0062a023	S-TYPE
OP :  23   F3 : 2   F7 :   0   RS1 : t0    RS2 : t1    RD : t1    IMM :        0
zr  00000000 | ra  00000000 | sp  8000ffff | gp  00000000 | tp  00000000 | t0  0e000000 | t1  0000006f | t2  00000000 |
s0  00000000 | s1  00000000 | a0  00000000 | a1  00000000 | a2  00000000 | a3  00000000 | a4  00000000 | a5  00000000 |
a6  00000000 | a7  00000000 | s2  00000000 | s3  00000000 | s4  00000000 | s5  00000000 | s6  00000000 | s7  00000000 |
s8  00000000 | s9  00000000 | s10 00000000 | s11 00000000 | t3  00000000 | t4  00000000 | t5  00000000 | t6  00000000 |


PC  : 8000002c	Instruction : 00a00313	I-TYPE ALU
OP :  13   F3 : 0   F7 :   0   RS1 : zr    RS2 : t1    RD : t1    IMM :        a
zr  00000000 | ra  00000000 | sp  8000ffff | gp  00000000 | tp  00000000 | t0  0e000000 | t1  0000000a | t2  00000000 |
s0  00000000 | s1  00000000 | a0  00000000 | a1  00000000 | a2  00000000 | a3  00000000 | a4  00000000 | a5  00000000 |
a6  00000000 | a7  00000000 | s2  00000000 | s3  00000000 | s4  00000000 | s5  00000000 | s6  00000000 | s7  00000000 |
s8  00000000 | s9  00000000 | s10 00000000 | s11 00000000 | t3  00000000 | t4  00000000 | t5  00000000 | t6  00000000 |


PC  : 80000030	Instruction : 0062a023	S-TYPE
OP :  23   F3 : 2   F7 :   0   RS1 : t0    RS2 : t1    RD : t1    IMM :        0
zr  00000000 | ra  00000000 | sp  8000ffff | gp  00000000 | tp  00000000 | t0  0e000000 | t1  0000000a | t2  00000000 |
s0  00000000 | s1  00000000 | a0  00000000 | a1  00000000 | a2  00000000 | a3  00000000 | a4  00000000 | a5  00000000 |
a6  00000000 | a7  00000000 | s2  00000000 | s3  00000000 | s4  00000000 | s5  00000000 | s6  00000000 | s7  00000000 |
s8  00000000 | s9  00000000 | s10 00000000 | s11 00000000 | t3  00000000 | t4  00000000 | t5  00000000 | t6  00000000 |


PC  : 80000034	Instruction : 00100073	E-TYPE
OP :  73   F3 : 0   F7 :   0   RS1 : zr    RS2 : t1    RD : zr    IMM :        0
zr  00000000 | ra  00000000 | sp  8000ffff | gp  00000000 | tp  00000000 | t0  0e000000 | t1  0000000a | t2  00000000 |
s0  00000000 | s1  00000000 | a0  00000000 | a1  00000000 | a2  00000000 | a3  00000000 | a4  00000000 | a5  00000000 |
a6  00000000 | a7  00000000 | s2  00000000 | s3  00000000 | s4  00000000 | s5  00000000 | s6  00000000 | s7  00000000 |
s8  00000000 | s9  00000000 | s10 00000000 | s11 00000000 | t3  00000000 | t4  00000000 | t5  00000000 | t6  00000000 |
```


Stay tuned !
