

# Hervé, the RV simulator

### WIP

I bought "the risc-v reader, an open architecture atlas" from D. Paterson and A. Waterman and decided to write an ISA simulator ... **Welcome to the twisted world of computer scientists**

The goal is to execute simple programs assembled with GAS (The GNU Assembler) and converted to binary files with objcopy (no elf support).

At this time I'm planning only :
- Flat memory (no MMU)
- Two memory mapped I/O : getChar and setChar
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

Stay tuned !
