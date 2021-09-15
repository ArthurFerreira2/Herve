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
  if (address < (mem.getRamStartAddress() + RAMSIZE)) PC = address;
}


int32_t Cpu::getReg(int reg){
  if (reg > 0 && reg < 31) return X[reg];
  else return 0;
}


void Cpu::setReg(int reg, int32_t value) {
  if (reg > 0 && reg < 31) X[reg] = value;
}


void Cpu::printRegs() {

  for (int i=0; i<32; i++) {
    std::cerr << std::dec << "x" << std::setfill('0') << std::setw(2) << i << " : " << std::setfill(' ') << std::setw(8) << std::hex << X[i];
    if ((i+1)%4)
      std::cerr << "\t\t";
    else
      std::cerr << "\n";
  }
  return;
}


void Cpu::printIR() {
  std::cerr << "\nOP : "  << std::dec << std::setfill(' ') << std::setw(3) << opcode;
  std::cerr << "   F3 : "  << std::dec << std::setfill(' ') << std::setw(3) << func3;
  std::cerr << "   F7 : "  << std::dec << std::setfill(' ') << std::setw(3) << func7;
  std::cerr << "   RS1 : " << std::dec << std::setfill(' ') << std::setw(2) << rs1;
  std::cerr << "   RS2 : " << std::dec << std::setfill(' ') << std::setw(2) << rs2;
  std::cerr << "   RD : "  << std::dec << std::setfill(' ') << std::setw(2) << rd;
  std::cerr << "   IMM : "  << std::dec << std::setfill(' ') << std::setw(8) << imm << std::endl;
  return;
}


int Cpu::exec(int cyclesCount){

  // FETCH
  IR = mem.get32(PC);  // instruction register


  #ifdef TRACE
  std::cerr << "\nPC  : " << std::hex << std::setfill('0') << std::setw(8) << PC;
  std::cerr << "\tInstruction : " << std::hex << std::setfill('0') << std::setw(8) << IR << "\t";
  #endif


  // Increment Program Counter
  PC += 4;  // might be useless - in some case this has to be undo ... keeping for better readability


  // the opcode is not always sufficient to decode the instruction - func3 and sometimes func7 are also necessary
  // but it already gives us the format of the instruction which allows further decoding
  opcode = IR & 0b1111111;



  // U-TYPE (upper immediate)

  if (opcode == 0b0110111) {                                                    // LUI - Load Upper Immediate

    #ifdef TRACE
    std::cerr << "U-TYPE LUI";
    #endif

    rd =  (IR >> 7) & 0b11111;
    imm = IR & 0xFFFFF000;

    if (rd != 0) X[rd] = imm;
  }


  else if (opcode == 0b0010111) {                                               // AUIPC - Add Upper Immediate to PC

    #ifdef TRACE
    std::cerr << "U-TYPE AUIPC";
    #endif

    rd =  (IR >> 7) & 0b11111;
    imm = IR & 0xFFFFF000;

    if (rd != 0) X[rd] = PC - 4 + imm;
  }



  // J-TYPE (jumps)

  else if (opcode == 0b1101111) {                                               // JAL - Jump And Link

    #ifdef TRACE
    std::cerr << "J-TYPE JAL ";
    #endif

    rd =  (IR >> 7) & 0b11111;
    imm = (IR & 0x000FF000UL) | ((IR & 0x7FE00000) >> 20);

    if ((int32_t)IR < 0)    // sign extention  if IR < 0 imm = -imm;
      imm |= 0xFFF00000;    // negative

    if (IR & 0x100000)      // if the 20th bit of IR is set
      imm |= 0x00000800UL;    // we set the 11th bit of imm
    else
      imm &= 0xFFFFF7FF;    // otherwise we unset the 11th bit of imm

    if (rd != 0) X[rd] =  PC;  // return address
    PC = (PC - 4 + imm);    // jump relative to PC
  }


  else if (opcode == 0b1100111) {                                               // JALR - Jump And Link Register

    #ifdef TRACE
    std::cerr << "I-TYPE JALR";
    #endif

    func3 = (IR >> 12) & 0b111;
    rd = (IR >> 7) & 0b11111;
    rs1 = (IR >> 15) & 0b11111;
    imm = IR >> 20;  // naturally sign extended

    switch (func3) {                                                            // Only one case in RV32I
      case (0b000):
        if (rd != 0) X[rd] = PC;
        PC = (X[rs1] + imm) & 0xFFFFFFFE; // be sure we won't get into any odd address
      break;

    default:
      std::cerr << "Illegal I-type instruction" << std::endl;
      state = HALTED;
    }
  }



  // B-TYPE (branches)

  else if (opcode == 0b1100011) {
    #ifdef TRACE
    std::cerr << "B-TYPE ";
    #endif

    func3 = (IR >> 12) & 0b111;
    rs1 = (IR >> 15) & 0b11111;
    rs2 = (IR >> 20) & 0b11111;

    imm = (IR >> 21) | ((IR >> 7) & 0b11110);  // sign extended - bit0 = 0
    if (IR & 0x80)        // if the 7th bit of IR is set
      imm |= 0x00000800UL;  // we set the 11th bit of imm
    else
      imm &= 0xFFFFF7FF;  // otherwise we unset the 11th bit of imm

    switch (func3) {
      case (0b000):                                                             // BEQ - Branch Equal
        if (X[rs1] == X[rs2]) PC = PC - 4 + imm;
      break;

      case (0b001):                                                             // BNE - Branch Not Equal
        if (X[rs1] != X[rs2]) PC = PC - 4 + imm;
      break;

      case (0b100):                                                             // BLT - Branch Less Than
        if (X[rs1] < X[rs2]) PC = PC - 4 + imm;
      break;

      case (0b101):                                                             // BGE - Branch Greater or Equal
        if (X[rs1] >= X[rs2]) PC = PC - 4 + imm;
      break;

      case (0b110):                                                             // BLTU - Branch Less Than Unsigned
        if ((uint32_t)X[rs1] < (uint32_t)X[rs2]) PC = PC - 4 + imm;
      break;

      case (0b111):                                                             // BGEU - Branch Greater or Equal Unsigned
        if ((uint32_t)X[rs1] >= (uint32_t)X[rs2]) PC = PC - 4 + imm;
      break;

      default:
        std::cerr << "Illegal B-type instruction" << std::endl;
        state = HALTED;
    }
  }



  // I-TYPE (immediate Loads)

  else if (opcode == 0b0000011) {

    #ifdef TRACE
    std::cerr << "I-TYPE LOADS";
    #endif

    func3 = (IR >> 12) & 0b111;
    rd = (IR >> 7) & 0b11111;
    rs1 = (IR >> 15) & 0b11111;
    imm = IR >> 20;  // naturally sign extended

    switch (func3) {
      case (0b000):                                                             // LB - Load Byte
        if (rd != 0) X[rd] = mem.get8(X[rs1] + imm);
        if (X[rd] & 0x80) // is negative
          X[rd] |= 0xFFFFFF00;  // sign extention
      break;

      case (0b001):                                                             // LH - Load Half word
        if (rd != 0) X[rd] = mem.get16(X[rs1] + imm);
        if (X[rd] & 0x8000) // is negative
          X[rd] |= 0xFFFF0000;  // sign extention
      break;

      case (0b010):                                                             // LW - Load Word
        if (rd != 0) X[rd] = mem.get32(X[rs1] + imm);
      break;

      case (0b100):                                                             // LBU - Load Byte Unsigned
        if (rd != 0) X[rd] = mem.get8(X[rs1] + imm);
      break;

      case (0b101):                                                             // LHU - Load Half word Unsigned
        if (rd != 0) X[rd] = mem.get16(X[rs1] + imm);
      break;

      default:
        std::cerr << "Illegal I-type instruction" << std::endl;
        state = HALTED;
    }
  }


  // S-TYPE (stores)

  else if (opcode == 0b0100011) {

    #ifdef TRACE
    std::cerr << "S-TYPE ";
    #endif

    func3 = (IR >> 12) & 0b111;
    rs1 =   (IR >> 15) & 0b11111;
    rs2 =   (IR >> 20) & 0b11111;
    imm =  ((IR >> 25)  & 0xFFFFFFE0) | ((IR >> 7) & 0x0000001FUL);

    switch (func3) {
      case (0b000):                                                             // SB - Store Byte
        mem.set8(imm + X[rs1], X[rs2] & 0xFF);
      break;

      case (0b001):                                                             // SH - Store Half Word
        mem.set16(imm + X[rs1], X[rs2] & 0xFFFF);
      break;

      case (0b010):                                                             // SW - Store Word
        mem.set32(imm + X[rs1], X[rs2]);
      break;

      default:
        std::cerr << "Illegal S-type instruction" << std::endl;
        state = HALTED;
    }
  }



  // I-TYPE (immediate) ALU

  else if (opcode == 0b0010011) {

    #ifdef TRACE
    std::cerr << "I-TYPE ALU";
    #endif

    func3 = (IR >> 12) & 0b111;
    rd = (IR >> 7) & 0b11111;
    rs1 = (IR >> 15) & 0b11111;
    imm = IR >> 20;  // naturally sign extended

    switch (func3) {
      case (0b000):                                                             // ADDI - ADD Immediate
        if (rd != 0) X[rd] = X[rs1] + imm;
      break;

      case (0b010):                                                             // SLTI - Set Less Than Immediate
        if (rd != 0) X[rd] = (X[rs1] < imm) ? 1 : 0;
      break;

      case (0b011):                                                             // SLTIU - Set Less Than Immediate Unsigned
        if (rd != 0) X[rd] = (uint32_t)X[rs1] < (uint32_t)imm ? 1 : 0;
      break;

      case (0b100):                                                             // XORI - XOR Immediate
        if (rd != 0) X[rd] = X[rs1] ^ imm;
      break;

      case (0b110):                                                             // ORI - OR Immediate
        if (rd != 0) X[rd] = X[rs1] | imm;
      break;

      case (0b111):                                                             // ANDI - AND Immediate
        if (rd != 0) X[rd] = X[rs1] & imm;
      break;

      case (0b001):                                                             // SLLI - Shift Left Logical Immediate
        shamt = (IR >> 20) & 0b11111;
        if (rd != 0) X[rd] = X[rs1] << shamt;
      break;

      case (0b101):
        shamt = (IR >> 20) & 0b11111;
        if (IR & 40000000) {  // if 30th bit of IR is set                       // SRAI - Shift Right Arithmetical Immediate
          if (rd != 0) X[rd] = X[rs1] >> shamt;
        }
        else {                                                                    // SRLI - Shift Right Logical Immediate
          if (rd != 0) X[rd] = (uint32_t)X[rs1] >> shamt;
        }
      break;


      default:
        std::cerr << "Illegal I-type instruction" << std::endl;
        state = HALTED;
    }
  }


  // ***********  ABOVE : DONE AND VERIFIED - BELOW : TO BE CHECKED  ***********

  // R-TYPE (register to register)

  else if (opcode == 0b0110011) {

    #ifdef TRACE
    std::cerr << "R-TYPE ";
    #endif

    func3 = (IR >> 12) & 0b111;
    rd =    (IR >> 7)  & 0b11111;
    rs1 =   (IR >> 15) & 0b11111;
    rs2 =   (IR >> 20) & 0b11111;

    switch (func3) {
      case (0b000):
        if (IR & 40000000) { // if 30th bit of IR is set
          if (rd != 0) X[rd] = X[rs1] - X[rs2];                                 // SUB - substract
        }
        else {
          if (rd != 0) X[rd] = X[rs1] + X[rs2];                                 // ADD
        }
      break;

      case (0b001):                                                             // SLL - Shift Left Logical
        if (rd != 0) X[rd] = X[rs1] << (X[rs2]%32);
      break;

      case (0b010):                                                             // SLT - Set Less Than
        if (rd != 0) X[rd] = (X[rs1] < X[rs2]) ? 1 : 0;
      break;

      case (0b011):                                                             // SLTU - Set Less Than Unsigned
        if (rd != 0) X[rd] = (uint32_t)X[rs1] < (uint32_t)X[rs2] ? 1 : 0;
      break;

      case (0b100):                                                             // XOR
        if (rd != 0) X[rd] = X[rs1] ^ X[rs2];
      break;

      case (0b101):
        if (IR & 40000000) { // if 30th bit of IR is set
          if (rd != 0) X[rd] = X[rs1] >> (X[rs2]%32);                            // SRA - Shift Right Arithmetical
        }
        else {
          if (rd != 0) X[rd] = (uint32_t)X[rs1] >> (X[rs2]%32);                  // SRL - Shift Right Logical
        }
      break;

      case (0b110):                                                             // OR
        if (rd != 0) X[rd] = X[rs1] | X[rs2];
      break;

      case (0b111):                                                             // AND
        if (rd != 0) X[rd] = X[rs1] & X[rs2];
      break;

      default:
        std::cerr << "Illegal R-type instruction" << std::endl;
        state = HALTED;
    }
  }


  // FENCE

  else if (opcode == 0b0001111) {

    #ifdef TRACE
    std::cerr << "FENCE";
    #endif

    func3 = (IR >> 12) & 0b111;
    rd =    (IR >> 7)  & 0b11111;
    rs1 =   (IR >> 15) & 0b11111;

    switch (func3) {
      case (0b000):
         // no operation
      break;

      default:
        std::cerr << "Illegal Fence instruction" << std::endl;
        state = HALTED;
    }
  }


  // E-TYPE (Enviroment)

  else if (opcode == 0b1110011) {

    #ifdef TRACE
    std::cerr << "E-TYPE";
    #endif

    func3 = (IR >> 12) & 0b111;
    rd =    (IR >> 7)  & 0b11111;
    rs1 =   (IR >> 15) & 0b11111;
    func12 = (IR >> 20) & 0xFFF;

    switch (func3) {
      case (0b000):
        if (func12 == 1)                                                        // EBREAK - Environment Break
          state = HALTED;
        if (func12 == 0) {                                                      // ECALL - Environment Call
          std::cerr << "Illegal System Call" << std::endl;
          state = HALTED;
        }
      break;

      default:
        std::cerr << "Illegal E-type instruction" << std::endl;
        state = HALTED;
    }
  }


  else {
    std::cerr << "Illegal instruction" << std::endl;
    state = HALTED;
  }

  #ifdef TRACE
  printIR();
  printRegs();
  #endif

  return ++instructionCycles;
}
