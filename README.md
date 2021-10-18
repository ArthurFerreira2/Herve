[![C/C++ CI](https://github.com/ArthurFerreira2/Herve/actions/workflows/build.yml/badge.svg)](https://github.com/ArthurFerreira2/Herve/actions/workflows/build.yml)
[![C/C++ CI](https://github.com/ArthurFerreira2/Herve/actions/workflows/test.yml/badge.svg)](https://github.com/ArthurFerreira2/Herve/actions/workflows/test.yml)

# Hervé, the RV simulator  


A imple RISC-V RV32im ISA Simulator in C++ under the MIT Licence  

I bought "the risc-v reader, an open architecture atlas" by D. Paterson and A. Waterman and decided to write an ISA simulator... **Welcome to the twisted world of computer scientists**  

herve extract loads froms ELF files and can execute compiled C code ! - cf. [README.md](C-tests/README.md) in the C-tests folder  

It integrates a **disassembler**, step by step execution, **breakpoints**, memory dump, etc ....

NEW : **herve can interpret Forth !** - cf. [README.md](Forth/README.md) in the Forth folder


## Loader

Our memory is only 64KiB  (who needs more ?) - well, I had to increase it to be able to run the forth interpreter ... (more on the Forth folder)  

We load the binaries from the ELF into memory and set the program counter (PC) accordingly.   
The stack pointer (SP register) is set at the highest memory address.

Memory is flat : no paging, no access attributes and thus you can read, write and execute at any location.


## Memory mapped I/O

I'm using a primitive solution until I implement ecalls

```C
#define GETCHAR 0x0f000000
#define PUTCHAR 0x0e000000
```
store a byte at 0x0e000000 and it will be output to stdout
keypresses are available at address 0x0f000000


## Progress update

**2021-10-18**  
Added an integrated disassembler, support for breakpoints etc...  

If you start herve with the -s switch, you can use the following commands :
- d[addr] - dump memory from addr or PC if addr not specified
- l[addr] - disassemble code from addr or PC if addr not specified
- b[addr] - toggle breakpoint at addr or PC if addr not specified
- s[num] - execute num instructions or only one if num not specified
- r - print registers
- c - continue execution until next breakpoint
- q - quit



note to myself : write a proper documentation !

**2021-10-17**  
I started to implement the atomic instructions extention
herve can run Forth !

**2021-10-13**  
All RV32im instructions were implemented and fully tested.  
A GitHub CI action has been added to automate tests on commits - see top of the page badges, the first checks the build and the second execute all the tests.

**2021-10-01**  
added elf support - herve can execute C programs compiled by gcc  

**2021-09-05**  
all rv32i instruction are implemented and tested  

## Tests
I use the test suite published at : https://github.com/riscv-software-src/riscv-tests and a shell script to automate testings

```shell
#!/bin/bash

rm ./testsResults

for test in `cat ./testsList`
do
  echo -n "$test : " >> ./testsResults
  ../herve -t -i ./$test > ./$test.traces 2>> ./testsResults
done


TARGET=`wc -l ./testsList | cut -d " " -f 1`
REACHED=`grep 'All tests passed' ./testsResults | wc -l`

if [[ $REACHED -eq $TARGET ]]
then
  echo "All tests passed"
  exit 0
else
  echo "Some test failled"
  exit 1
fi

```

You can invoque it using make :

```shell
$ make clean && make check
rm -f *.o herve
g++ -std=c++17 -pedantic -Wpedantic -Wall -Werror -O3 -c -o cpu.o cpu.cpp
g++ -std=c++17 -pedantic -Wpedantic -Wall -Werror -O3 -c -o elf.o elf.cpp
g++ -std=c++17 -pedantic -Wpedantic -Wall -Werror -O3 -c -o herve.o herve.cpp
g++ -std=c++17 -pedantic -Wpedantic -Wall -Werror -O3 -c -o mem.o mem.cpp
g++ -std=c++17 -pedantic -Wpedantic -Wall -Werror -O3 cpu.o elf.o herve.o mem.o -o herve
cd tests && ./runTests.sh
All tests passed
```

The result for each test is logged in the testResults file :

```shell
$ cat tests/testsResults
rv32ui-p-add :  All tests passed
rv32ui-p-addi :  All tests passed
rv32ui-p-and :  All tests passed
rv32ui-p-andi :  All tests passed
rv32ui-p-auipc :  All tests passed
rv32ui-p-beq :  All tests passed
rv32ui-p-bge :  All tests passed
rv32ui-p-bgeu :  All tests passed
rv32ui-p-blt :  All tests passed
rv32ui-p-bltu :  All tests passed
rv32ui-p-bne :  All tests passed
rv32ui-p-fence_i :  All tests passed
rv32ui-p-jal :  All tests passed
rv32ui-p-jalr :  All tests passed
rv32ui-p-lb :  All tests passed
rv32ui-p-lbu :  All tests passed
rv32ui-p-lh :  All tests passed
rv32ui-p-lhu :  All tests passed
rv32ui-p-lui :  All tests passed
rv32ui-p-lw :  All tests passed
rv32ui-p-or :  All tests passed
rv32ui-p-ori :  All tests passed
rv32ui-p-sb :  All tests passed
rv32ui-p-sh :  All tests passed
rv32ui-p-simple :  All tests passed
rv32ui-p-sll :  All tests passed
rv32ui-p-slli :  All tests passed
rv32ui-p-slt :  All tests passed
rv32ui-p-slti :  All tests passed
rv32ui-p-sltiu :  All tests passed
rv32ui-p-sltu :  All tests passed
rv32ui-p-sra :  All tests passed
rv32ui-p-srai :  All tests passed
rv32ui-p-srl :  All tests passed
rv32ui-p-srli :  All tests passed
rv32ui-p-sub :  All tests passed
rv32ui-p-sw :  All tests passed
rv32ui-p-xor :  All tests passed
rv32ui-p-xori :  All tests passed
rv32um-p-div :  All tests passed
rv32um-p-divu :  All tests passed
rv32um-p-mul :  All tests passed
rv32um-p-mulh :  All tests passed
rv32um-p-mulhsu :  All tests passed
rv32um-p-mulhu :  All tests passed
rv32um-p-rem :  All tests passed
rv32um-p-remu :  All tests passed
```


## Instructions list

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
|             |                                     |             |        |
| MUL         | Multiply                            | yes         | pass   |
| MULH        | Multiply High Signed Signed         | yes         | pass   |
| MULHSU      | Multiply High Signed Unsigned       | yes         | pass   |
| MULHU       | Multiply High Unsigned Unsigned     | yes         | pass   |
| DIV         | Divide Signed                       | yes         | pass   |
| DIVU        | Divide Unsigned                     | yes         | pass   |
| REM         | Remainder Signed                    | yes         | pass   |
| REMU        | Remainder Unsigned                  | yes         | pass   |
|             |                                     |             |        |
| lr.w        | Load Reserved                       | wip         | fail   |            
| sc.w        | Store Conditional                   | wip         | fail   |
| amoswap.w   | Atomic Swap                         | wip         | fail   |
| amoadd.w    | Atomic ADD                          | wip         | fail   |
| amoand.w    | Atomic AND                          | wip         | fail   |
| amoor.w     | Atomic OR                           | wip         | fail   |
| amoxor.w    | Atomix XOR                          | wip         | fail   |
| amomax.w    | Atomic MAX                          | wip         | fail   |
| amomin.w    | Atomic MIN                          | wip         | fail   |
|             |                                     |             |        |
| EBREAK      | Environment Break                   | kind of     | yeah   |
| ECALL       | Environment Call                    | kind of     | yeah   |
| FENCE       | Memory Ordering                     | as NOP*     | n/a    |

\* Any unimplemented instrution will halt the execution so I had to implement FENCE as a NOP.  


## Usage

### Build

```shell
make
```

You now should have an executable called herve.

### Run

Please refer to the [README.md](asm-tests/README.md) under the asm-tests folder for information on how to assemble and the [README.md](C-tests/README.md) under C-tests for information on how to compile your sources into risc-v elf binaries - Makefiles/shell scripts are also provided.


```shell
$ ./herve -h
Usage: herve [-tsh] -i programFile [-o traceFile]
 -h  print this help
 -i  mandatory : specifies the file (rv32 elf) to execute
 -o  specifies the file where to write the execution traces (implies -t)
 -t  enable execution traces
 -s  step by step execution (implies -t)

$ ./herve -i asm-tests/helloWorld.elf -o asm-tests/helloWorld.traces
Hello

```

The traces of the execution were redirected into the **asm-tests/helloWorld.traces** file :

```
$ cat asm-tests/helloWorld.traces
 80000000 : lui t0,234881024
 zr .......0   ra .......0   sp 8000ffff   gp .......0   tp .......0   t0 .e000000   t1 .......0   t2 .......0  
 s0 .......0   s1 .......0   a0 .......0   a1 .......0   a2 .......0   a3 .......0   a4 .......0   a5 .......0  
 a6 .......0   a7 .......0   s2 .......0   s3 .......0   s4 .......0   s5 .......0   s6 .......0   s7 .......0  
 s8 .......0   s9 .......0  s10 .......0  s11 .......0   t3 .......0   t4 .......0   t5 .......0   t6 .......0  

 80000004 : addi t1,zr,72
 zr .......0   ra .......0   sp 8000ffff   gp .......0   tp .......0   t0 .e000000   t1 ......48   t2 .......0  
 s0 .......0   s1 .......0   a0 .......0   a1 .......0   a2 .......0   a3 .......0   a4 .......0   a5 .......0  
 a6 .......0   a7 .......0   s2 .......0   s3 .......0   s4 .......0   s5 .......0   s6 .......0   s7 .......0  
 s8 .......0   s9 .......0  s10 .......0  s11 .......0   t3 .......0   t4 .......0   t5 .......0   t6 .......0  

 80000008 : sw t1,0(t0)
 zr .......0   ra .......0   sp 8000ffff   gp .......0   tp .......0   t0 .e000000   t1 ......48   t2 .......0  
 s0 .......0   s1 .......0   a0 .......0   a1 .......0   a2 .......0   a3 .......0   a4 .......0   a5 .......0  
 a6 .......0   a7 .......0   s2 .......0   s3 .......0   s4 .......0   s5 .......0   s6 .......0   s7 .......0  
 s8 .......0   s9 .......0  s10 .......0  s11 .......0   t3 .......0   t4 .......0   t5 .......0   t6 .......0  

 8000000c : addi t1,zr,101
 zr .......0   ra .......0   sp 8000ffff   gp .......0   tp .......0   t0 .e000000   t1 ......65   t2 .......0  
 s0 .......0   s1 .......0   a0 .......0   a1 .......0   a2 .......0   a3 .......0   a4 .......0   a5 .......0  
 a6 .......0   a7 .......0   s2 .......0   s3 .......0   s4 .......0   s5 .......0   s6 .......0   s7 .......0  
 s8 .......0   s9 .......0  s10 .......0  s11 .......0   t3 .......0   t4 .......0   t5 .......0   t6 .......0  

 80000010 : sw t1,0(t0)
 zr .......0   ra .......0   sp 8000ffff   gp .......0   tp .......0   t0 .e000000   t1 ......65   t2 .......0  
 s0 .......0   s1 .......0   a0 .......0   a1 .......0   a2 .......0   a3 .......0   a4 .......0   a5 .......0  
 a6 .......0   a7 .......0   s2 .......0   s3 .......0   s4 .......0   s5 .......0   s6 .......0   s7 .......0  
 s8 .......0   s9 .......0  s10 .......0  s11 .......0   t3 .......0   t4 .......0   t5 .......0   t6 .......0  

 80000014 : addi t1,zr,108
 zr .......0   ra .......0   sp 8000ffff   gp .......0   tp .......0   t0 .e000000   t1 ......6c   t2 .......0  
 s0 .......0   s1 .......0   a0 .......0   a1 .......0   a2 .......0   a3 .......0   a4 .......0   a5 .......0  
 a6 .......0   a7 .......0   s2 .......0   s3 .......0   s4 .......0   s5 .......0   s6 .......0   s7 .......0  
 s8 .......0   s9 .......0  s10 .......0  s11 .......0   t3 .......0   t4 .......0   t5 .......0   t6 .......0  

 80000018 : sw t1,0(t0)
 zr .......0   ra .......0   sp 8000ffff   gp .......0   tp .......0   t0 .e000000   t1 ......6c   t2 .......0  
 s0 .......0   s1 .......0   a0 .......0   a1 .......0   a2 .......0   a3 .......0   a4 .......0   a5 .......0  
 a6 .......0   a7 .......0   s2 .......0   s3 .......0   s4 .......0   s5 .......0   s6 .......0   s7 .......0  
 s8 .......0   s9 .......0  s10 .......0  s11 .......0   t3 .......0   t4 .......0   t5 .......0   t6 .......0  

 8000001c : addi t1,zr,108
 zr .......0   ra .......0   sp 8000ffff   gp .......0   tp .......0   t0 .e000000   t1 ......6c   t2 .......0  
 s0 .......0   s1 .......0   a0 .......0   a1 .......0   a2 .......0   a3 .......0   a4 .......0   a5 .......0  
 a6 .......0   a7 .......0   s2 .......0   s3 .......0   s4 .......0   s5 .......0   s6 .......0   s7 .......0  
 s8 .......0   s9 .......0  s10 .......0  s11 .......0   t3 .......0   t4 .......0   t5 .......0   t6 .......0  

 80000020 : sw t1,0(t0)
 zr .......0   ra .......0   sp 8000ffff   gp .......0   tp .......0   t0 .e000000   t1 ......6c   t2 .......0  
 s0 .......0   s1 .......0   a0 .......0   a1 .......0   a2 .......0   a3 .......0   a4 .......0   a5 .......0  
 a6 .......0   a7 .......0   s2 .......0   s3 .......0   s4 .......0   s5 .......0   s6 .......0   s7 .......0  
 s8 .......0   s9 .......0  s10 .......0  s11 .......0   t3 .......0   t4 .......0   t5 .......0   t6 .......0  

 80000024 : addi t1,zr,111
 zr .......0   ra .......0   sp 8000ffff   gp .......0   tp .......0   t0 .e000000   t1 ......6f   t2 .......0  
 s0 .......0   s1 .......0   a0 .......0   a1 .......0   a2 .......0   a3 .......0   a4 .......0   a5 .......0  
 a6 .......0   a7 .......0   s2 .......0   s3 .......0   s4 .......0   s5 .......0   s6 .......0   s7 .......0  
 s8 .......0   s9 .......0  s10 .......0  s11 .......0   t3 .......0   t4 .......0   t5 .......0   t6 .......0  

 80000028 : sw t1,0(t0)
 zr .......0   ra .......0   sp 8000ffff   gp .......0   tp .......0   t0 .e000000   t1 ......6f   t2 .......0  
 s0 .......0   s1 .......0   a0 .......0   a1 .......0   a2 .......0   a3 .......0   a4 .......0   a5 .......0  
 a6 .......0   a7 .......0   s2 .......0   s3 .......0   s4 .......0   s5 .......0   s6 .......0   s7 .......0  
 s8 .......0   s9 .......0  s10 .......0  s11 .......0   t3 .......0   t4 .......0   t5 .......0   t6 .......0  

 8000002c : addi t1,zr,10
 zr .......0   ra .......0   sp 8000ffff   gp .......0   tp .......0   t0 .e000000   t1 .......a   t2 .......0  
 s0 .......0   s1 .......0   a0 .......0   a1 .......0   a2 .......0   a3 .......0   a4 .......0   a5 .......0  
 a6 .......0   a7 .......0   s2 .......0   s3 .......0   s4 .......0   s5 .......0   s6 .......0   s7 .......0  
 s8 .......0   s9 .......0  s10 .......0  s11 .......0   t3 .......0   t4 .......0   t5 .......0   t6 .......0  

 80000030 : sw t1,0(t0)
 zr .......0   ra .......0   sp 8000ffff   gp .......0   tp .......0   t0 .e000000   t1 .......a   t2 .......0  
 s0 .......0   s1 .......0   a0 .......0   a1 .......0   a2 .......0   a3 .......0   a4 .......0   a5 .......0  
 a6 .......0   a7 .......0   s2 .......0   s3 .......0   s4 .......0   s5 .......0   s6 .......0   s7 .......0  
 s8 .......0   s9 .......0  s10 .......0  s11 .......0   t3 .......0   t4 .......0   t5 .......0   t6 .......0  

 80000034 : ebreak
 zr .......0   ra .......0   sp 8000ffff   gp .......0   tp .......0   t0 .e000000   t1 .......a   t2 .......0  
 s0 .......0   s1 .......0   a0 .......0   a1 .......0   a2 .......0   a3 .......0   a4 .......0   a5 .......0  
 a6 .......0   a7 .......0   s2 .......0   s3 .......0   s4 .......0   s5 .......0   s6 .......0   s7 .......0  
 s8 .......0   s9 .......0  s10 .......0  s11 .......0   t3 .......0   t4 .......0   t5 .......0   t6 .......0  


Program halted after 14 instruction cycles
```

"*To understand a program you must become both the machine and the program.*"  
Alan Perlis
