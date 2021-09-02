WIP

I bought "the risc-v reader, an open architecture atlas" from D. Paterson and A. Waterman and decided to write an ISA simulator.

The goal is to execute simple programs assembled with GAS (The GNU Assembler) and converted to binary files with objdump (no elf support).

At this time I'm planning only : Flat memory (no MMU) with two memory mapped I/O : readkey and putchar using 8 bits extended ASCII. And restricted to the RV32I ISA :

- Arithmetics: ADD, ADDI, SUB
- Logical: AND, ANDI, OR, ORI, XOR, XORI
- Sets: SLT, SLTI, SLTU, SLTIU
- Shifts: SRA, SRAI, SRL, SRLISLL, SLLI
- Memory: LW, SW, LB, SB
- PC: LUI, AUIPC
- Jumps: JAL, JALR
- Branches: BEQ, BNE, BLT, BGE, BLTU, BGEU
- Control : HLT

Stay tuned !
