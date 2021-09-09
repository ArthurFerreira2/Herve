

# Hervé, the RV simulator
a tiny RISC-V RV32I ISA Simulator in C++ under the MIT Licence

## WIP

I bought "the risc-v reader, an open architecture atlas" from D. Paterson and A. Waterman and decided to write an ISA simulator ... **Welcome to the twisted world of computer scientists**

The goal is to execute simple programs assembled with GAS (The GNU Assembler) and converted to binary files with objcopy (no elf support for the moment).

At this time I'm planning only :
- Flat memory (no MMU)
- Two memory mapped I/O : getChar and putChar until I implement ecall
- Restricted to this RV32I ISA (no fence)

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

## progress

All RV32I instructions were implemented but Itested only a few of them.


| Instruction | Description                         | implemented | Tested |
|-------------|-------------------------------------|:-----------:|:------:|
| LUI         | Load Upper Immediate                | yes         | yes    |
| AUIPC       | Add Upper Immediate to PC           | yes         | no     |
| JAL         | Jump And Link                       | yes         | no     |
| JALR        | Jump And Link Register              | yes         | no     |
| BEQ         | Branch Equal                        | yes         | yes    |
| BNE         | Branch Not Equal                    | yes         | no     |
| BLT         | Branch Less Than                    | yes         | no     |
| BGE         | Branch Greater or Equal             | yes         | no     |
| BLTU        | Branch Less Than Unsigned           | yes         | no     |
| BGEU        | Branch Greater or Equal Unsigned    | yes         | no     |
| LB          | Load Byte                           | yes         | no     |
| LH          | Load Half word                      | yes         | no     |
| LW          | Load Word                           | yes         | no     |
| LBU         | Load Byte Unsigned                  | yes         | no     |
| LHU         | Load Half word Unsigned             | yes         | no     |
| SB          | Store Byte                          | yes         | no     |
| SH          | Store Half Word                     | yes         | no     |
| SW          | Store Word                          | yes         | yes    |
| ADDI        | ADD Immediate                       | yes         | yes    |
| SLTI        | Set Less Than Immediate             | yes         | no     |
| SLTIU       | Set Less Than Immediate Unsigned    | yes         | no     |
| XORI        | XOR Immediate                       | yes         | no     |
| ORI         | OR Immediate                        | yes         | no     |
| ANDI        | AND Immediate                       | yes         | no     |
| SLLI        | Shift Left Logical Immediate        | yes         | no     |
| SRAI        | Shift Right Arithmetical Immediate  | yes         | no     |
| SRLI        | Shift Right Logical Immediate       | yes         | no     |
| ADD         | Addition                            | yes         | no     |
| SUB         | Substraction                        | yes         | no     |
| SLL         | Shift Left Logical                  | yes         | no     |
| SLT         | Set Less Than                       | yes         | no     |
| SLTU        | Set Less Than Unsigned              | yes         | no     |
| XOR         | Logic XOR                           | yes         | no     |
| SRA         | Shift Right Arithmetical            | yes         | no     |
| SRL         | Shift Right Logical                 | yes         | no     |
| OR          | Logic OR                            | yes         | no     |
| AND         | Logic AND                           | yes         | no     |
| EBREAK      | Environment Break                   | yes         | no     |
| ECALL       | Environment Call                    | yes         | no     |
| FENCE*      | Memory Ordering                     | no          | no     |

\* Any unimplemented instrution will halt the execution so I might have to implement FENCE as a NOP.

## compile and run

please refer to README.md under the **RV32I-Examples** folder for information on how to compile / assemble and convert your sources into an appropriate binary file - a Makefile is also provided.



```shell

$ make clean && make && ./herve RV32I-Examples/helloWorld.bin 2>traces
rm -f herve
g++ -std=c++17 -pedantic -Wpedantic -Wall -Werror -O3 herve.cpp cpu.cpp mem.cpp -o herve -lstdc++fs
Loaded 224 words from "helloWorld.bin" into memory
Hello

Program terminated
```

The traces of the execution were redirected into the **trace** file :

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
