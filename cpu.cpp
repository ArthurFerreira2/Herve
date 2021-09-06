#include <iostream>
#include <iomanip>
#include "cpu.h"
#include "mem.h"

#define TRACE


extern Mem mem;

uint32_t Cpu::getPC() {
  return PC;
}

void Cpu::setPC(uint32_t address) {
  if (address < RAMSIZE) PC = address;
}

int32_t Cpu::getReg(int reg){
  if (reg > 0 && reg < 31) return X[reg];
  else return 0;
}

void Cpu::setReg(int reg, int32_t value) {
  if (reg > 0 && reg < 31) X[reg] = value;
}


void Cpu::printRegs() {
  std::cout << "PC : 0x" << std::hex << std::setfill('0') << std::setw(8) << PC << std::endl;

  for (int i=0; i<32; i++) {
    std::cout << std::dec << "x" << std::setfill('0') << std::setw(2) << i << " : 0x" << std::setw(8) << std::hex << X[i];
    if ((i+1)%4)
      std::cout << "\t";
    else
      std::cout << "\n";
  }
  return;
}

void Cpu::printIR() {
  std::cout << "\nOP : "  << std::dec << std::setfill('0') << std::setw(3) << opcode;
  std::cout << "\tRD : "  << std::dec << std::setfill('0') << std::setw(2) << rd;
  std::cout << "\tRS1 : " << std::dec << std::setfill('0') << std::setw(2) << rs1;
  std::cout << "\tRS2 : " << std::dec << std::setfill('0') << std::setw(2) << rs2;
  std::cout << "\tF3 : "  << std::dec << std::setfill('0') << std::setw(3) << func3;
  std::cout << "\tF7 : "  << std::dec << std::setfill('0') << std::setw(3) << func7 << std::endl;
  return;
}

int Cpu::exec(int cyclesCount){

  // FETCH
  IR = mem.get32(PC);  // instruction register
#ifdef TRACE
  std::cout << "\nInstruction : 0x" << std::hex << std::setfill('0') << std::setw(8) << IR << "\t";
#endif

  // DECODE &  EXECUTE

  opcode = IR & 0b1111111;


  // R-TYPE
  if (opcode == 0b0110011) {
#ifdef TRACE
    std::cout << "R-TYPE ";
#endif
    func3 = (IR >> 12) & 0b111;
    rd =    (IR >> 7)  & 0b11111;
    rs1 =   (IR >> 15) & 0b11111;
    rs2 =   (IR >> 20) & 0b11111;

    printRegs();

    switch (func3) {
      case (0b000):
        func7 = (IR >> 25) & 0b1111111;
        if (func7 == 0b0000000) X[rd] = X[rs1] + X[rs2];                        // add
        if (func7 == 0b0100000) X[rd] = X[rs1] - X[rs2];                        // sub - substract
      break;

      case (0b001):                                                             // sll - Shift Left Logical
        X[rd] = X[rs1] << X[rs2%32];
      break;

      case (0b010):                                                             // slt - Set Less Than
        X[rd] = ((int32_t)X[rs1] < (int32_t)X[rs2]) ? (int32_t)1 : (int32_t)0;
      break;

      case (0b011):                                                             // sltu - Set Less Than Unsigned
        X[rd] = (X[rs1] < X[rs2]) ? 1 : 0;
      break;

    }
  }                                                                             // end of r-type


  // I-TYPE
  if (opcode == 0b0010011) {
#ifdef TRACE
    std::cout << "I-TYPE ";
#endif
    func3 = (IR >> 12) & 0b111;
    imm =   (IR >> 20);
    rd =    (IR >> 7)  & 0b11111;
    rs1 =   (IR >> 15) & 0b11111;

    switch (func3) {
      case (0b000):                                                             // addi - Add Immediate
        X[rd] = X[rs1] + imm;
      break;
    }
  }


  // S-TYPE
  if (opcode == 0b0100011) {
#ifdef TRACE
    std::cout << "S-TYPE ";
#endif
    func3 = (IR >> 12) & 0b111;
    imm =  ((IR >> 7)  & 0b11111) | (((IR >> 25) & 0b1111111) << 7);  // Sign and Zero Extension ???
    rd =    (IR >> 7)  & 0b11111;
    rs1 =   (IR >> 15) & 0b11111;
    rs2 =   (IR >> 20) & 0b11111;

    switch (func3) {
      case (0b000):                                                             // sb - Store Byte
        mem.set8(imm + X[rs1], X[rs2] & 0xFF);
      break;

      case (0b001):                                                             // sh - Store Half Word
        mem.set16(imm + X[rs1], X[rs2] & 0xFFFF);
      break;

      case (0b010):                                                             // sw - Store Word
        mem.set32(imm + X[rs1], X[rs2]);
      break;
    }
  }


  // U-TYPE
  if (opcode == 0b0110111) {                                                    // lui - Load Upper Immediate
#ifdef TRACE
    std::cout << "U-TYPE ";
#endif
    imm = IR & 0b11111111111111111111000000000000;
    rd =  (IR >> 7) & 0b11111;
    X[rd] = imm;
  }

#ifdef TRACE
  printIR();
  printRegs();
#endif
  PC += 0x04;

  return ++instructionCycles;
}
