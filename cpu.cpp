#include <iostream>
#include <iomanip>

#include "cpu.h"
#include "mem.h"

extern Mem mem;

void Cpu::reset() {
  for (int i = 0; i<32; i++){
    x[i] = 0;
  }
  pc = 0;
  return;
}

uint32_t Cpu::getPC() {
  return pc;
}

void Cpu::setPC(uint32_t address) {
  pc = address;
  return;
}

int32_t Cpu::getReg(int reg){
	return x[reg];
}

void Cpu::setReg(int reg, int32_t value) {
	if (reg > 0 && reg < 32) x[reg] = value;
  return;
}

void Cpu::printRegs() {
  for (int i=0; i<32; i++) {
    std::cout << std::dec << "x" << std::setfill('0') << std::setw(2) << i << " : 0x" << std::setw(8) << std::hex << x[i];
    if ((i+1)%4)
      std::cout << "   ";
    else
      std::cout << "\n";
  }
  std::cout << "PC -> 0x" << std::hex << std::setfill('0') << std::setw(8) << pc << std::endl;
  return;
}

int Cpu::exec(int cyclesCount){

  int32_t instruction = mem.getInt32(pc);

  std::cout << "\nInstruction : 0x" << std::setfill('0') << std::setw(8) << instruction << std::endl;
  printRegs();
  static int cyclesToRun = 2;
  pc += 0x04;
  return --cyclesToRun;


}

//  3         2         1         0
// 10987654321098765432109876543210
// PC control
// SSSSSSSSSSSSSSSSSSSSRRRRR0110111 lui rd,imm                     #  LUI
// OOOOOOOOOOOOOOOOOOOORRRRR0010111 auipc rd,offset                #  AUIPC
// jumps
// OOOOOOOOOOOOOOOOOOOORRRRR1101111 jal rd,offset                  #  JAL
// OOOOOOOOOOOORRRRR000RRRRR1100111 jalr rd,rs1,offset             #  JALR
// branches
// OOOOOOORRRRRRRRRR000OOOOO1100011 beq rs1,rs2,offset             #  BEQ
// OOOOOOORRRRRRRRRR001OOOOO1100011 bne rs1,rs2,offset             #  BNE
// OOOOOOORRRRRRRRRR100OOOOO1100011 blt rs1,rs2,offset             #  BLT
// OOOOOOORRRRRRRRRR101OOOOO1100011 bge rs1,rs2,offset             #  BGE
// OOOOOOORRRRRRRRRR110OOOOO1100011 bltu rs1,rs2,offset            #  BLTU
// OOOOOOORRRRRRRRRR111OOOOO1100011 bgeu rs1,rs2,offset            #  BGEU
// load and store
// OOOOOOOOOOOORRRRR000RRRRR0000011 lb rd,offset(rs1)              #  LB
// OOOOOOOOOOOORRRRR001RRRRR0000011 lh rd,offset(rs1)              #  LH
// OOOOOOOOOOOORRRRR010RRRRR0000011 lw rd,offset(rs1)              #  LW
// OOOOOOOOOOOORRRRR100RRRRR0000011 lbu rd,offset(rs1)             #  LBU
// OOOOOOOOOOOORRRRR101RRRRR0000011 lhu rd,offset(rs1)             #  LHU
// OOOOOOORRRRRRRRRR000OOOOO0100011 sb rs2,offset(rs1)             #  SB
// OOOOOOORRRRRRRRRR001OOOOO0100011 sh rs2,offset(rs1)             #  SH
// OOOOOOORRRRRRRRRR010OOOOO0100011 sw rs2,offset(rs1)             #  SW
// immediate operations
// SSSSSSSSSSSSRRRRR000RRRRR0010011 addi rd,rs1,imm                #  ADDI
// SSSSSSSSSSSSRRRRR010RRRRR0010011 slti rd,rs1,imm                #  SLTI
// SSSSSSSSSSSSRRRRR011RRRRR0010011 sltiu rd,rs1,imm               #  SLTIU
// SSSSSSSSSSSSRRRRR100RRRRR0010011 xori rd,rs1,imm                #  XORI
// SSSSSSSSSSSSRRRRR110RRRRR0010011 ori rd,rs1,imm                 #  ORI
// SSSSSSSSSSSSRRRRR111RRRRR0010011 andi rd,rs1,imm                #  ANDI
// 00000UUUUUUURRRRR001RRRRR0010011 slli rd,rs1,imm                #  SLLI
// 00000UUUUUUURRRRR101RRRRR0010011 srli rd,rs1,imm                #  SRLI
// 01000UUUUUUURRRRR101RRRRR0010011 srai rd,rs1,imm                #  SRAI
// register operations
// 0000000RRRRRRRRRR000RRRRR0110011 add rd,rs1,rs2                 #  ADD
// 0100000RRRRRRRRRR000RRRRR0110011 sub rd,rs1,rs2                 #  SUB
// 0000000RRRRRRRRRR001RRRRR0110011 sll rd,rs1,rs2                 #  SLL
// 0000000RRRRRRRRRR010RRRRR0110011 slt rd,rs1,rs2                 #  SLT
// 0000000RRRRRRRRRR011RRRRR0110011 sltu rd,rs1,rs2                #  SLTU
// 0000000RRRRRRRRRR100RRRRR0110011 xor rd,rs1,rs2                 #  XOR
// 0000000RRRRRRRRRR101RRRRR0110011 srl rd,rs1,rs2                 #  SRL
// 0100000RRRRRRRRRR101RRRRR0110011 sra rd,rs1,rs2                 #  SRA
// 0000000RRRRRRRRRR110RRRRR0110011 or rd,rs1,rs2                  #  OR
// 0000000RRRRRRRRRR111RRRRR0110011 and rd,rs1,rs2                 #  AND
