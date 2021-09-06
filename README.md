

# Hervé, the RV simulator

## WIP

I bought "the risc-v reader, an open architecture atlas" from D. Paterson and A. Waterman and decided to write an ISA simulator ... **Welcome to the twisted world of computer scientists**

The goal is to execute simple programs assembled with GAS (The GNU Assembler) and converted to binary files with objcopy (no elf support).

At this time I'm planning only :
- Flat memory (no MMU)
- Two memory mapped I/O : getChar and putChar
- Restricted to this RV32I ISA subset :
  - Shifts : SRA, SRAI, SRL, SRLI, SLL, SLLI
  - Arithmetics : ADD, ADDI, SUB, LUI, AUIPC
  - Logical : AND, ANDI, OR, ORI, XOR, XORI
  - Compare : SLT, SLTI, SLTU, SLTIU
  - Jumps : JAL, JALR
  - Branches : BEQ, BNE, BLT, BGE, BLTU, BGEU
  - Environment : EBREAK
  - Loads : LB, LBU, LH, LHU, LW
  - Stores : SB, SH, SW


## loader

Our memory is only 64KiB  
The load point is 0 : we load the binary at address 0 and further and set PC to 0  
The heap is set right after the static area  
The stack should be set at address 0xFFFF and decrements - a stack underflow will overite code  

## memory mapped I/O

very primitive solution until I implement ecall

```C
#define GETCHAR 0x0f000000
#define PUTCHAR 0x0e000000
```
store a byte at 0x0e000000 and it will be output to stdout
keypresses will be available at address 0x0f000000

## progress
... so far :
```shell

$ make
g++ -std=c++17 -pedantic -Wpedantic -Wall -Werror -O3 herve.cpp cpu.cpp cpu.h mem.cpp mem.h -o herve -lstdc++fs

$ ./herve RV32I-Examples/helloWorld.bin
Loaded 14 words from "helloWorld.bin" into memory
Hello

```

Stay tuned !
