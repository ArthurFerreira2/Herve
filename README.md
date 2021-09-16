


# Hervé, the RV simulator
a tiny RISC-V RV32I ISA Simulator in C++ under the MIT Licence

## WIP -- I have to update this readme : We now extract loads froms ELF files and can execute C code ! - [cf. README.md in the C-tests folder](C-tests/README.md)

I bought "the risc-v reader, an open architecture atlas" by D. Paterson and A. Waterman and decided to write an ISA simulator ... **Welcome to the twisted world of computer scientists**

The goal is to execute simple programs assembled with GAS (The GNU Assembler) and converted to binary files with objcopy (no elf support for the moment).

At this time I'm planning only :
- Flat memory (no MMU)
- Two memory mapped I/O : getChar and putChar until I implement ecall
- Restricted to the RV32I ISA (with fence implemented as NOP)

## loader

Our memory is only 64KiB  (who needs more ?)  
The load point is 0 : we load the binary at address 0 and further then set program counter (PC) to 0  
The heap is set right after the static area (which follows itself the text area)  
The stack should be set at address 0xFFFF and decrements - a stack underflow will overite code  

## memory mapped I/O

this is a primitive solution until I implement ecall

```C
#define GETCHAR 0x0f000000
#define PUTCHAR 0x0e000000
```
store a byte at 0x0e000000 and it will be output to stdout
keypresses will be available at address 0x0f000000

## progress update

All RV32I instructions were implemented and fully tested.

I use the test suite published at : https://github.com/riscv-software-src/riscv-tests and his short shell script to automate the testings

```shell
#!/bin/sh

for test in `ls tests/ | grep -v dump `
do
  echo -n "$test : "
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


## compile and run

### compile

```shell
make
```

you now should have an executable named herve.

### run

Please refer to README.md under the **RV32I-Examples** folder for information on how to assemble and the README.md under C-tests for information on how to compile your sources into risc-v binaries - Makefiles are also provided.


```shell

$ ./herve RV32I-Examples/helloWorld.bin 2>traces
Loaded 14 words from "helloWorld.bin" into memory
Hello

Program terminated
```

The traces of the execution were redirected into the **traces** file :

```
$ cat traces

PC  : 00000000	Instruction : 0e0002b7	U-TYPE LUI
OP : 055   F3 : 000   F7 : 000   RS1 : 00   RS2 : 00   RD : 05
x00 : 00000000	x01 : 00000000	x02 : 00000000	x03 : 00000000
x04 : 00000000	x05 : 0e000000	x06 : 00000000	x07 : 00000000
x08 : 00000000	x09 : 00000000	x10 : 00000000	x11 : 00000000
x12 : 00000000	x13 : 00000000	x14 : 00000000	x15 : 00000000
x16 : 00000000	x17 : 00000000	x18 : 00000000	x19 : 00000000
x20 : 00000000	x21 : 00000000	x22 : 00000000	x23 : 00000000
x24 : 00000000	x25 : 00000000	x26 : 00000000	x27 : 00000000
x28 : 00000000	x29 : 00000000	x30 : 00000000	x31 : 00000000

PC  : 00000004	Instruction : 04800313	I-TYPE ALU
OP : 019   F3 : 000   F7 : 000   RS1 : 00   RS2 : 00   RD : 06
x00 : 00000000	x01 : 00000000	x02 : 00000000	x03 : 00000000
x04 : 00000000	x05 : 0e000000	x06 : 00000048	x07 : 00000000
x08 : 00000000	x09 : 00000000	x10 : 00000000	x11 : 00000000
x12 : 00000000	x13 : 00000000	x14 : 00000000	x15 : 00000000
x16 : 00000000	x17 : 00000000	x18 : 00000000	x19 : 00000000
x20 : 00000000	x21 : 00000000	x22 : 00000000	x23 : 00000000
x24 : 00000000	x25 : 00000000	x26 : 00000000	x27 : 00000000
x28 : 00000000	x29 : 00000000	x30 : 00000000	x31 : 00000000

PC  : 00000008	Instruction : 0062a023	S-TYPE
OP : 035   F3 : 002   F7 : 000   RS1 : 05   RS2 : 06   RD : 06
x00 : 00000000	x01 : 00000000	x02 : 00000000	x03 : 00000000
x04 : 00000000	x05 : 0e000000	x06 : 00000048	x07 : 00000000
x08 : 00000000	x09 : 00000000	x10 : 00000000	x11 : 00000000
x12 : 00000000	x13 : 00000000	x14 : 00000000	x15 : 00000000
x16 : 00000000	x17 : 00000000	x18 : 00000000	x19 : 00000000
x20 : 00000000	x21 : 00000000	x22 : 00000000	x23 : 00000000
x24 : 00000000	x25 : 00000000	x26 : 00000000	x27 : 00000000
x28 : 00000000	x29 : 00000000	x30 : 00000000	x31 : 00000000

<...>
```


Stay tuned !
