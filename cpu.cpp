#include <iostream>
#include <iomanip>

#include "cpu.h"
#include "mem.h"

extern Mem mem;


uint32_t Cpu::getPC() {
  return PC;
}


void Cpu::setPC(uint32_t address) {
  if (address < (mem.getRamStartAddress() + RAMSIZE)) PC = address;
}


int32_t Cpu::getReg(int reg){
  return (reg > 0 && reg < 31) ? X[reg] : 0;
}


void Cpu::setReg(int reg, int32_t value) {
  if (reg > 0 && reg < 31) X[reg] = value;
}


int Cpu::exec(int cyclesCount){

  int32_t temp;
                                                            // INSTRUCTION FETCH
  IR = mem.get32(PC);  // Instruction Register

  if (TRACE) ctrace << " " << std::hex << std::setfill('0') << std::setw(8) << PC << " : " << std::dec;

  // increment Program Counter
  // might be useless - in some case this has to be undo ... leaving as is for better readability
  PC += 4;

  // the opcode is not always sufficient to decode the instruction - func3 and sometimes func7 are also necessary
  // but it already gives us the format of the instruction which allows further decoding
  opcode = IR & 0b1111111;


  switch(opcode) {

    case 0b0110111:                                  // U-TYPE (upper immediate)
        rd =  (IR >> 7) & 0b11111;
        imm = IR & 0xFFFFF000;

        if (TRACE) ctrace << "lui " << regNames[rd] << "," << imm;

        if (rd != 0)                                                            // LUI - Load Upper Immediate
          X[rd] = imm;
    break;


    case 0b0010111:                                  // U-TYPE (upper immediate)
        rd =  (IR >> 7) & 0b11111;
        imm = IR & 0xFFFFF000;

        if (TRACE) ctrace << "auipc " << regNames[rd] << "," << imm;

        if (rd != 0)                                                            // AUIPC - Add Upper Immediate to PC
          X[rd] = PC - 4 + imm;
    break;


    case 0b1101111:                                            // J-TYPE (jumps)
        rd =  (IR >> 7) & 0b11111;                                              // JAL - Jump And Link
        imm = (IR & 0x000FF000UL) | ((IR & 0x7FE00000) >> 20);
        if ((int32_t)IR < 0)                                                    // sign extention  if IR < 0 imm = -imm;
          imm |= 0xFFF00000;                                                    // negative
        if (IR & 0x100000)                                                      // if the 20th bit of IR is set
          imm |= 0x00000800UL;                                                  // we set the 11th bit of imm
        else
          imm &= 0xFFFFF7FF;                                                    // otherwise we unset the 11th bit of imm

        if (TRACE) ctrace << "jal " << regNames[rd] << "," << imm;

        if (rd != 0)
          X[rd] =  PC;                                                          // return address
        PC = (PC - 4 + imm);                                                    // jump relative to PC
    break;


    case 0b1100111:                                            // UJ-TYPE (jumps)
        func3 = (IR >> 12) & 0b111;
        rd = (IR >> 7) & 0b11111;
        rs1 = (IR >> 15) & 0b11111;
        imm = IR >> 20;                                                         // naturally sign extended
        temp = PC;

        switch (func3) {
          case 0b000:                                                           // JALR - Jump And Link Register
            if (TRACE) ctrace << "jalr " << regNames[rd] << ","  << regNames[rs1] << "," << imm;
            PC = (X[rs1] + imm) & 0xFFFFFFFE;                                   // never odd address
            if (rd != 0)
              X[rd] = temp;
          break;

        default:
          std::cerr << "Illegal I-type instruction\n";
          state = HALTED;
        break;
        }
    break;


    case 0b1100011:                                         // B-TYPE (branches)
        func3 = (IR >> 12) & 0b111;
        rs1 = (IR >> 15) & 0b11111;
        rs2 = (IR >> 20) & 0b11111;

        imm = ((IR >> 20) & 0xFFFFFFE0) | ((IR >> 7) & 0b11110);                // sign extended and bit0 = 0
        if (IR & 0x80)                                                          // if the 7th bit of IR is set
          imm |= 0x00000800L;                                                   // we set the 11th bit of imm
        else
          imm &= 0xFFFFF7FF;                                                    // otherwise we unset the 11th bit of imm

        switch (func3) {
          case 0b000:                                                           // BEQ - Branch Equal
            if (TRACE) ctrace << "beq " << regNames[rs1] << ","  << regNames[rs2] << "," << imm;
            if (X[rs1] == X[rs2])
              PC = PC - 4 + imm;
          break;

          case 0b001:                                                           // BNE - Branch Not Equal
            if (TRACE) ctrace << "bne " << regNames[rs1] << ","  << regNames[rs2] << "," << imm;
            if (X[rs1] != X[rs2])
              PC = PC - 4 + imm;
          break;

          case 0b100:                                                           // BLT - Branch Less Than
            if (TRACE) ctrace << "blt " << regNames[rs1] << ","  << regNames[rs2] << "," << imm;
            if (X[rs1] < X[rs2])
              PC = PC - 4 + imm;
          break;

          case 0b101:                                                           // BGE - Branch Greater or Equal
            if (TRACE) ctrace << "bge " << regNames[rs1] << ","  << regNames[rs2] << "," << imm;
            if (X[rs1] >= X[rs2])
              PC = PC - 4 + imm;
          break;

          case 0b110:                                                           // BLTU - Branch Less Than Unsigned
            if (TRACE) ctrace << "bltu " << regNames[rs1] << ","  << regNames[rs2] << "," << imm;
            if ((uint32_t)X[rs1] < (uint32_t)X[rs2])
              PC = PC - 4 + imm;
          break;

          case 0b111:                                                           // BGEU - Branch Greater or Equal Unsigned
            if (TRACE) ctrace << "bgeu " << regNames[rs1] << ","  << regNames[rs2] << "," << imm;
            if ((uint32_t)X[rs1] >= (uint32_t)X[rs2])
              PC = PC - 4 + imm;
          break;

          default:
            std::cerr << "Illegal B-type instruction\n";
            state = HALTED;
          break;
        }
    break;


    case 0b0000011:                                  // I-TYPE (immediate Loads)
        func3 = (IR >> 12) & 0b111;
        rd = (IR >> 7) & 0b11111;
        rs1 = (IR >> 15) & 0b11111;
        imm = IR >> 20;                                                         // naturally sign extended

        switch (func3) {
          case 0b000:                                                           // LB - Load Byte
            if (TRACE) ctrace << "lb " << regNames[rd] << "," << imm << "(" << regNames[rs1] << ")";
            if (rd != 0) X[rd] = mem.get8(X[rs1] + imm);
            if (X[rd] & 0x80)                                                   // is negative
              X[rd] |= 0xFFFFFF00;                                              // sign extention
          break;

          case 0b001:                                                           // LH - Load Half word
            if (TRACE) ctrace << "lh " << regNames[rd] << "," << imm << "(" << regNames[rs1] << ")";
            if (rd != 0)
              X[rd] = mem.get16(X[rs1] + imm);
            if (X[rd] & 0x8000)                                                 // is negative
              X[rd] |= 0xFFFF0000;                                              // sign extention
          break;

          case 0b010:                                                           // LW - Load Word
            if (TRACE) ctrace << "lw " << regNames[rd] << "," << imm << "(" << regNames[rs1] << ")";
            if (rd != 0)
              X[rd] = mem.get32(X[rs1] + imm);
          break;

          case 0b100:                                                           // LBU - Load Byte Unsigned
            if (TRACE) ctrace << "lbu " << regNames[rd] << "," << imm << "(" << regNames[rs1] << ")";
            if (rd != 0)
              X[rd] = (uint8_t)mem.get8(X[rs1] + imm);
          break;

          case 0b101:                                                           // LHU - Load Half word Unsigned
            if (TRACE) ctrace << "lhu " << regNames[rd] << "," << imm << "(" << regNames[rs1] << ")";
            if (rd != 0)
              X[rd] = (uint16_t)mem.get16(X[rs1] + imm);
          break;

          default:
            std::cerr << "Illegal I-type instruction\n";
            state = HALTED;
          break;
        }
    break;


    case 0b0100011:                                           // S-TYPE (stores)
        func3 = (IR >> 12) & 0b111;
        rs1 =   (IR >> 15) & 0b11111;
        rs2 =   (IR >> 20) & 0b11111;
        imm =  ((IR >> 20)  & 0xFFFFFFE0) | ((IR >> 7) & 0x0000001FL);

        switch (func3) {
          case 0b000:                                                           // SB - Store Byte
            if (TRACE) ctrace << "sb " << regNames[rs2] << "," << imm << "(" << regNames[rs1] << ")";
            mem.set8(imm + X[rs1], X[rs2] & 0xFF);
          break;

          case 0b001:                                                           // SH - Store Half Word
            if (TRACE) ctrace << "sh " << regNames[rs2] << "," << imm << "(" << regNames[rs1] << ")";
            mem.set16(imm + X[rs1], X[rs2] & 0xFFFF);
          break;

          case 0b010:                                                           // SW - Store Word
            if (TRACE) ctrace << "sw " << regNames[rs2] << "," << imm << "(" << regNames[rs1] << ")";
            mem.set32(imm + X[rs1], X[rs2]);
          break;

          default:
            std::cerr << "Illegal S-type instruction\n";
            state = HALTED;
          break;
        }
    break;



    case 0b0010011:                                    // I-TYPE (immediate) ALU
        func7 = (IR >> 25) & 0b1111111;
        func3 = (IR >> 12) & 0b111;
        rd = (IR >> 7) & 0b11111;
        rs1 = (IR >> 15) & 0b11111;
        imm = IR >> 20;                                                         // naturally sign extended

        switch (func3) {
          case 0b000:                                                           // ADDI - ADD Immediate
            if (TRACE) ctrace << "addi " << regNames[rd] << "," << regNames[rs1] << "," <<  imm;
            if (rd != 0)
              X[rd] = X[rs1] + imm;
          break;

          case 0b010:                                                           // SLTI - Set Less Than Immediate
            if (TRACE) ctrace << "slti " << regNames[rd] << "," << regNames[rs1] << "," <<  imm;
            if (rd != 0)
              X[rd] = (X[rs1] < imm) ? 1 : 0;
          break;

          case 0b011:                                                           // SLTIU - Set Less Than Immediate Unsigned
            if (TRACE) ctrace << "sltiu " << regNames[rd] << "," << regNames[rs1] << "," <<  imm;
            if (rd != 0)
              X[rd] = (uint32_t)X[rs1] < (uint32_t)imm ? 1 : 0;
          break;

          case 0b100:                                                           // XORI - XOR Immediate
            if (TRACE) ctrace << "xori " << regNames[rd] << "," << regNames[rs1] << "," <<  imm;
            if (rd != 0)
              X[rd] = X[rs1] ^ imm;
          break;

          case 0b110:                                                           // ORI - OR Immediate
            if (TRACE) ctrace << "ori " << regNames[rd] << "," << regNames[rs1] << "," <<  imm;
            if (rd != 0)
              X[rd] = X[rs1] | imm;
          break;

          case 0b111:                                                           // ANDI - AND Immediate
            if (TRACE) ctrace << "andi " << regNames[rd] << "," << regNames[rs1] << "," <<  imm;
            if (rd != 0)
              X[rd] = X[rs1] & imm;
          break;

          case 0b001:                                                           // SLLI - Shift Left Logical Immediate
            shamt = (IR >> 20) & 0b11111;
            if (TRACE) ctrace << "slli " << regNames[rd] << "," << regNames[rs1] << "," <<  shamt;
            if (rd != 0)
              X[rd] = X[rs1] << shamt;
          break;

          case 0b101:
            shamt = (IR >> 20) & 0b11111;
            if (func7 == 0x20) {                                              // SRAI - Shift Right Arithmetical Immediate
              if (TRACE) ctrace << "srai " << regNames[rd] << "," << regNames[rs1] << "," <<  shamt;
              if (rd != 0)
                X[rd] = X[rs1] >> shamt;
            }
            else {                                                              // SRLI - Shift Right Logical Immediate
              if (TRACE) ctrace << "srli " << regNames[rd] << "," << regNames[rs1] << "," <<  shamt;
              if (rd != 0)
                X[rd] = (uint32_t)X[rs1] >> shamt;
            }
          break;

          default:
            std::cerr << "Illegal I-type instruction\n";
            state = HALTED;
          break;
        }
    break;


    case 0b0110011:                             // R-TYPE (register to register)
        func7 = (IR >> 25) & 0b1111111;
        func3 = (IR >> 12) & 0b111;
        rd =    (IR >> 7)  & 0b11111;
        rs1 =   (IR >> 15) & 0b11111;
        rs2 =   (IR >> 20) & 0b11111;

        if (func7 == 1) {

          switch (func3) {
            case 0b000:                                                         // MUL
              if (TRACE) ctrace << "mul " << regNames[rd] << "," << regNames[rs1] << "," << regNames[rs2];
              if (rd != 0)
                X[rd] = (int32_t)(X[rs1] * X[rs2]);
            break;

            case 0b001:                                                         // MULH
              if (TRACE) ctrace << "mulh " << regNames[rd] << "," << regNames[rs1] << "," << regNames[rs2];
              if (rd != 0)
                X[rd] = (int32_t)(((int64_t)X[rs1] * (int64_t)X[rs2]) >> 32);
            break;

            case 0b010:                                                         // MULHSU
              if (TRACE) ctrace << "mulhsu " << regNames[rd] << "," << regNames[rs1] << "," << regNames[rs2];
              if (rd != 0)
                X[rd] = ((int64_t)((int32_t)X[rs1]) * (uint64_t)((uint32_t)X[rs2])) >> 32;
            break;

            case 0b011:                                                         // MULHU
              if (TRACE) ctrace << "mulhu " << regNames[rd] << "," << regNames[rs1] << "," << regNames[rs2];
              if (rd != 0)
                X[rd] = ((uint64_t)((uint32_t)X[rs1]) * (uint64_t)((uint32_t)X[rs2])) >> 32;
            break;

            case 0b100:                                                         // DIV
              if (TRACE) ctrace << "div " << regNames[rd] << "," << regNames[rs1] << "," << regNames[rs2];
              if (rd != 0) {
                if ((X[rs1] == ((int32_t)1 << 31)) && (X[rs2] == -1))
                  X[rd] = X[rs1];
                else if (X[rs2] != 0)
                  X[rd] = (int32_t)(X[rs1] / X[rs2]);
                else
                  X[rd] = -1;
              }
            break;

            case 0b101:                                                         // DIVU
              if (TRACE) ctrace << "divu " << regNames[rd] << "," << regNames[rs1] << "," << regNames[rs2];
              if (rd != 0) {
                if (X[rs2] != 0)
                  X[rd] = (uint32_t)((uint32_t)X[rs1] / (uint32_t)X[rs2]);
                else
                  X[rd] = -1;
              }
            break;

            case 0b110:                                                         // REM
              if (TRACE) ctrace << "rem " << regNames[rd] << "," << regNames[rs1] << "," << regNames[rs2];
              if (rd != 0) {
                if ((X[rs1] == ((int32_t)1 << 31)) && (X[rs2] == -1))
                  X[rd] = 0;
                else if (X[rs2] != 0)
                  X[rd] = (int32_t)((int32_t)X[rs1] % (int32_t)X[rs2]);
                else
                  X[rd] = X[rs1];
              }
            break;

            case 0b111:                                                         // REMU
              if (TRACE) ctrace << "remu " << regNames[rd] << "," << regNames[rs1] << "," << regNames[rs2];
              if (rd != 0) {
                if (X[rs2] != 0)
                  X[rd] = (uint32_t)((uint32_t)X[rs1] % (uint32_t)X[rs2]);
                else
                  X[rd] = X[rs1];
              }
            break;
          }

        }
        else {

          switch (func3) {
            case 0b000:
              if (func7 == 0x20) {                                              // SUB - substract
                if (TRACE) ctrace << "sub " << regNames[rd] << "," << regNames[rs1] << "," << regNames[rs2];
                if (rd != 0)
                  X[rd] = X[rs1] - X[rs2];
              }
              else {                                                              // ADD
                if (TRACE) ctrace << "add " << regNames[rd] << "," << regNames[rs1] << "," << regNames[rs2];
                if (rd != 0)
                  X[rd] = X[rs1] + X[rs2];
              }
            break;

            case 0b001:                                                           // SLL - Shift Left Logical
              if (TRACE) ctrace << "sll " << regNames[rd] << "," << regNames[rs1] << "," << regNames[rs2];
              if (rd != 0)
                X[rd] = X[rs1] << (X[rs2]%32);
            break;

            case 0b010:                                                           // SLT - Set Less Than
              if (TRACE) ctrace << "slt " << regNames[rd] << "," << regNames[rs1] << "," << regNames[rs2];
              if (rd != 0)
                X[rd] = (X[rs1] < X[rs2]) ? 1 : 0;
            break;

            case 0b011:                                                           // SLTU - Set Less Than Unsigned
              if (TRACE) ctrace << "sltu " << regNames[rd] << "," << regNames[rs1] << "," << regNames[rs2];
              if (rd != 0)
                X[rd] = (uint32_t)X[rs1] < (uint32_t)X[rs2] ? 1 : 0;
            break;

            case 0b100:                                                           // XOR
              if (TRACE) ctrace << "xor " << regNames[rd] << "," << regNames[rs1] << "," << regNames[rs2];
              if (rd != 0)
                X[rd] = X[rs1] ^ X[rs2];
            break;

            case 0b101:
              if (func7 == 0x20) {                                              // SRA - Shift Right Arithmetical
                if (TRACE) ctrace << "sra " << regNames[rd] << "," << regNames[rs1] << "," << regNames[rs2];
                if (rd != 0)
                  X[rd] = X[rs1] >> (X[rs2]%32);
              }
              else {                                                              // SRL - Shift Right Logical
                if (TRACE) ctrace << "srl " << regNames[rd] << "," << regNames[rs1] << "," << regNames[rs2];
                if (rd != 0)
                  X[rd] = (uint32_t)X[rs1] >> (X[rs2]%32);
              }
            break;

            case 0b110:                                                           // OR
              if (TRACE) ctrace << "or " << regNames[rd] << "," << regNames[rs1] << "," << regNames[rs2];
              if (rd != 0)
                X[rd] = X[rs1] | X[rs2];
            break;

            case 0b111:                                                           // AND
              if (TRACE) ctrace << "and " << regNames[rd] << "," << regNames[rs1] << "," << regNames[rs2];
              if (rd != 0)
                X[rd] = X[rs1] & X[rs2];
            break;

            default:
              std::cerr << "Illegal R-type instruction\n";
              state = HALTED;
            break;
          }
        }
    break;


    case 0b0001111:                                                     // FENCE
        func3 = (IR >> 12) & 0b111;
        rd =    (IR >> 7)  & 0b11111;
        rs1 =   (IR >> 15) & 0b11111;

        switch (func3) {
          case 0b000:
            if (TRACE) ctrace << "fence";
            // no operation
          break;

          case 0b001:
            if (TRACE) ctrace << "fence.i";
            // no operation
          break;

          default:
            std::cerr << "Illegal fence instruction\n";
            state = HALTED;
          break;
        }
    break;

    case 0b0101111:                                                    // ATOMIC
      func3 = (IR >> 12) & 0b111;

      if (func3 == 0x2) {
        func5 = (IR >> 27)  & 0b11111;
        // rl = (IR>>25) *0b1;
        // aq = (IR>>26) *0b1;
        // int32_t M= {0};
        rd = (IR >> 7)  & 0b11111;
        rs1 = (IR >> 15) & 0b11111;
        rs2 = (IR >> 20) & 0b11111;

        switch (func5) {
          case 0x00:                                                            // amoadd.w

          break;

          case 0x01:                                                            // amoswap.w

          break;

          case 0x02:                                                            // lr.w

          break;

          case 0x03:                                                            // sc.w

          break;

          case 0x04:                                                            // amoxor.w

          break;

          case 0x0a:                                                            // amoor.w

          break;

          case 0x0c:                                                            // amoand.w

          break;

          case 0x10:                                                            // amomin.w

          break;

          case 0x14:                                                            // amomax.w

          break;

          case 0x18:                                                            // amominu.w

          break;

          case 0x1c:                                                            // amomaxu.w

          break;

          default:
            std::cerr << "Illegal Atomic instruction\n";
            state = HALTED;
          break;
        }
      }
    break;


    case 0b1110011:                                      // E-TYPE (Environment)
        func3 = (IR >> 12) & 0b111;
        rd =    (IR >> 7)  & 0b11111;
        rs1 =   (IR >> 15) & 0b11111;
        func12 = (IR >> 20) & 0xFFF;

        switch (func3) {
          case 0b000:
            if (func12 == 1) {                                                  // EBREAK - Environment Break
              if (TRACE) ctrace << "ebreak";
              state = HALTED;
            }
            else if (func12 == 0) {                                             // ECALL - Environment Call
              if (X[17] == 93) {                                                // convention for instruction tests
                if (X[10] == 0)
                  std::cerr << "All tests passed\n";
                else
                 std::cerr << "test # " << X[14] << " failled\n";
              }
              else
                std::cerr << "Non implemented System Call\n";

              state = HALTED;
            }
          break;

          default:
            // std::cerr << "Illegal E-type instruction\n";
            // state = HALTED;  // we ignore them for now...
          break;
        }
    break;


    default:                                                        // CATCH ALL
        std::cerr << "Illegal instruction\n";
        state = HALTED;
    break;

  } // switch(opcode)

  // Instruction Register breakout - debug
  // if (TRACE) {
  //   ctrace << std::hex;
  //   ctrace << "\n ir : " << std::hex << std::setfill('0') << std::setw(8) << IR;
  //   ctrace << "    op: "  << opcode;
  //   ctrace << "    f3: "  << func3;
  //   ctrace << "    f7: "  << func7;
  //   ctrace << "    rs1: " << regNames[rs1];
  //   ctrace << "    rs2: " << regNames[rs2];
  //   ctrace << "    rd: "  << regNames[rd];
  //   ctrace << "    imm: " << imm;  printRegs();
  // }

  if (TRACE) {
    ctrace << "\n";
    for (int i=0; i<32; i++) {
      ctrace << std::setfill(' ') << std::setw(3) << regNames[i] << " ";
      ctrace << std::setfill('.') << std::setw(8) << std::hex << X[i]  << "  ";
      if (!((i+1)%8)) ctrace << "\n";
    }
    ctrace << std::endl;
  }

  return ++instructionCycles;
}
