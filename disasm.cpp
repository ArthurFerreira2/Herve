#include <iostream>
#include <iomanip>

void disasm(uint32_t address, int32_t IR) {

  const char* regNames[32] = {"zr", "ra", "sp", "gp", "tp", "t0", "t1", "t2", "s0", "s1", "a0", "a1", "a2", "a3", "a4", "a5", "a6", "a7", "s2", "s3", "s4", "s5", "s6", "s7", "s8", "s9", "s10", "s11", "t3", "t4", "t5", "t6"};

  std::cout << std::hex << std::setfill('0') << std::setw(8) << address << ":\t" << std::dec;

  int32_t imm;
  uint32_t func3, func5, func7, func12, rd, rs1, rs2, shamt;
  uint32_t opcode = IR & 0b1111111;

  switch(opcode) {

    case 0b0110111:
        rd = (IR >> 7) & 0b11111;
        imm = IR & 0xFFFFF000;
        std::cout << "lui\t" << regNames[rd] << "," << imm;
    break;


    case 0b0010111:
        rd = (IR >> 7) & 0b11111;
        imm = IR & 0xFFFFF000;
        std::cout << "auipc\t" << regNames[rd] << "," << imm;
    break;


    case 0b1101111:
        rd = (IR >> 7) & 0b11111;
        imm = (IR & 0x000FF000UL) | ((IR & 0x7FE00000) >> 20);
        if ((int32_t)IR < 0)
          imm |= 0xFFF00000;
        if (IR & 0x100000)
          imm |= 0x00000800UL;
        else
          imm &= 0xFFFFF7FF;

        std::cout << "jal\t" << regNames[rd] << "," << imm;
    break;


    case 0b1100111:
        func3 = (IR >> 12) & 0b111;
        rd = (IR >> 7) & 0b11111;
        rs1 = (IR >> 15) & 0b11111;
        imm = IR >> 20;

        switch (func3) {
          case 0b000:
            std::cout << "jalr\t" << regNames[rd] << ","  << regNames[rs1] << "," << imm;
          break;

          default:
            std::cout << "Illegal I-type instruction";
          break;
        }
    break;


    case 0b1100011:
        func3 = (IR >> 12) & 0b111;
        rs1 = (IR >> 15) & 0b11111;
        rs2 = (IR >> 20) & 0b11111;

        imm = ((IR >> 20) & 0xFFFFFFE0) | ((IR >> 7) & 0b11110);
        if (IR & 0x80)
          imm |= 0x00000800L;  // branch forward
        else
          imm &= 0xFFFFF7FF; // branch backward

        switch (func3) {
          case 0b000:
            std::cout << "beq\t" << regNames[rs1] << ","  << regNames[rs2] << "," << (int32_t)imm;
          break;

          case 0b001:
            std::cout << "bne\t" << regNames[rs1] << ","  << regNames[rs2] << "," << (int32_t)imm;
          break;

          case 0b100:
            std::cout << "blt\t" << regNames[rs1] << ","  << regNames[rs2] << "," << (int32_t)imm;
          break;

          case 0b101:
            std::cout << "bge\t" << regNames[rs1] << ","  << regNames[rs2] << "," << (int32_t)imm;
          break;

          case 0b110:
            std::cout << "bltu\t" << regNames[rs1] << ","  << regNames[rs2] << "," << (int32_t)imm;
          break;

          case 0b111:
            std::cout << "bgeu\t" << regNames[rs1] << ","  << regNames[rs2] << "," << (int32_t)imm;
          break;

          default:
            std::cout << "Illegal B-type instruction";
          break;
        }
    break;


    case 0b0000011:
        func3 = (IR >> 12) & 0b111;
        rd = (IR >> 7) & 0b11111;
        rs1 = (IR >> 15) & 0b11111;
        imm = IR >> 20;

        switch (func3) {
          case 0b000:
            std::cout << "lb\t" << regNames[rd] << "," << imm << "(" << regNames[rs1] << ")";
          break;

          case 0b001:
            std::cout << "lh\t" << regNames[rd] << "," << imm << "(" << regNames[rs1] << ")";
          break;

          case 0b010:
            std::cout << "lw\t" << regNames[rd] << "," << imm << "(" << regNames[rs1] << ")";
          break;

          case 0b100:
            std::cout << "lbu\t" << regNames[rd] << "," << imm << "(" << regNames[rs1] << ")";
          break;

          case 0b101:
            std::cout << "lhu\t" << regNames[rd] << "," << imm << "(" << regNames[rs1] << ")";
          break;

          default:
            std::cout << "Illegal I-type instruction";
          break;
        }
    break;


    case 0b0100011:
        func3 = (IR >> 12) & 0b111;
        rs1 = (IR >> 15) & 0b11111;
        rs2 = (IR >> 20) & 0b11111;
        imm = ((IR >> 20)  & 0xFFFFFFE0) | ((IR >> 7) & 0x0000001FL);

        switch (func3) {
          case 0b000:
            std::cout << "sb\t" << regNames[rs2] << "," << imm << "(" << regNames[rs1] << ")";
          break;

          case 0b001:
            std::cout << "sh\t" << regNames[rs2] << "," << imm << "(" << regNames[rs1] << ")";
          break;

          case 0b010:
            std::cout << "sw\t" << regNames[rs2] << "," << imm << "(" << regNames[rs1] << ")";
          break;

          default:
            std::cout << "Illegal S-type instruction";
          break;
        }
    break;


    case 0b0010011:
        func7 = (IR >> 25) & 0b1111111;
        func3 = (IR >> 12) & 0b111;
        rd = (IR >> 7) & 0b11111;
        rs1 = (IR >> 15) & 0b11111;
        imm = IR >> 20;

        switch (func3) {
          case 0b000:
            std::cout << "addi\t" << regNames[rd] << "," << regNames[rs1] << "," <<  imm;
          break;

          case 0b010:
            std::cout << "slti\t" << regNames[rd] << "," << regNames[rs1] << "," <<  imm;
          break;

          case 0b011:
            std::cout << "sltiu\t" << regNames[rd] << "," << regNames[rs1] << "," <<  imm;
          break;

          case 0b100:
            std::cout << "xori\t" << regNames[rd] << "," << regNames[rs1] << "," <<  imm;
          break;

          case 0b110:
            std::cout << "ori\t" << regNames[rd] << "," << regNames[rs1] << "," <<  imm;
          break;

          case 0b111:
            std::cout << "andi\t" << regNames[rd] << "," << regNames[rs1] << "," <<  imm;
          break;

          case 0b001:
            shamt = (IR >> 20) & 0b11111;
            std::cout << "slli\t" << regNames[rd] << "," << regNames[rs1] << "," <<  shamt;
          break;

          case 0b101:
            shamt = (IR >> 20) & 0b11111;
            if (func7 == 0x20)
              std::cout << "srai\t" << regNames[rd] << "," << regNames[rs1] << "," <<  shamt;
            else
              std::cout << "srli\t" << regNames[rd] << "," << regNames[rs1] << "," <<  shamt;
          break;

          default:
            std::cout << "Illegal I-type instruction";
          break;
        }
    break;


    case 0b0110011:
        func7 = (IR >> 25) & 0b1111111;
        func3 = (IR >> 12) & 0b111;
        rd =  (IR >> 7)  & 0b11111;
        rs1 = (IR >> 15) & 0b11111;
        rs2 = (IR >> 20) & 0b11111;

        if (func7 == 1) {

          switch (func3) {
            case 0b000:
              std::cout << "mul\t" << regNames[rd] << "," << regNames[rs1] << "," << regNames[rs2];
            break;

            case 0b001:
              std::cout << "mulh\t" << regNames[rd] << "," << regNames[rs1] << "," << regNames[rs2];
            break;

            case 0b010:
              std::cout << "mulhsu\t" << regNames[rd] << "," << regNames[rs1] << "," << regNames[rs2];
            break;

            case 0b011:
              std::cout << "mulhu\t" << regNames[rd] << "," << regNames[rs1] << "," << regNames[rs2];
            break;

            case 0b100:
              std::cout << "div\t" << regNames[rd] << "," << regNames[rs1] << "," << regNames[rs2];
            break;

            case 0b101:
              std::cout << "divu\t" << regNames[rd] << "," << regNames[rs1] << "," << regNames[rs2];
            break;

            case 0b110:
              std::cout << "rem\t" << regNames[rd] << "," << regNames[rs1] << "," << regNames[rs2];
            break;

            case 0b111:
              std::cout << "remu\t" << regNames[rd] << "," << regNames[rs1] << "," << regNames[rs2];
            break;
          }

        }

        else {

          switch (func3) {
            case 0b000:
              if (func7 == 0x20)
                std::cout << "sub\t" << regNames[rd] << "," << regNames[rs1] << "," << regNames[rs2];
              else
                std::cout << "add\t" << regNames[rd] << "," << regNames[rs1] << "," << regNames[rs2];
            break;

            case 0b001:
              std::cout << "sll\t" << regNames[rd] << "," << regNames[rs1] << "," << regNames[rs2];
            break;

            case 0b010:
              std::cout << "slt\t" << regNames[rd] << "," << regNames[rs1] << "," << regNames[rs2];
            break;

            case 0b011:
              std::cout << "sltu\t" << regNames[rd] << "," << regNames[rs1] << "," << regNames[rs2];
            break;

            case 0b100:
              std::cout << "xor\t" << regNames[rd] << "," << regNames[rs1] << "," << regNames[rs2];
            break;

            case 0b101:
              if (func7 == 0x20)
                std::cout << "sra\t" << regNames[rd] << "," << regNames[rs1] << "," << regNames[rs2];
              else
                std::cout << "srl\t" << regNames[rd] << "," << regNames[rs1] << "," << regNames[rs2];
            break;

            case 0b110:
              std::cout << "or\t" << regNames[rd] << "," << regNames[rs1] << "," << regNames[rs2];
            break;

            case 0b111:
              std::cout << "and\t" << regNames[rd] << "," << regNames[rs1] << "," << regNames[rs2];
            break;

            default:
              std::cout << "Illegal R-type instruction";
            break;
          }
        }
    break;


    case 0b0001111:
        func3 = (IR >> 12) & 0b111;
        // rd =  (IR >> 7)  & 0b11111;
        // rs1 = (IR >> 15) & 0b11111;

        switch (func3) {
          case 0b000:
            std::cout << "fence";

          break;

          case 0b001:
            std::cout << "fence.i";

          break;

          default:
            std::cout << "Illegal fence instruction";
          break;
        }
    break;


    case 0b0101111:
      func3 = (IR >> 12) & 0b111;

      if (func3 == 0x2) {
        func5 = (IR >> 27)  & 0b11111;

        rd = (IR >> 7)  & 0b11111;
        rs1 = (IR >> 15) & 0b11111;
        rs2 = (IR >> 20) & 0b11111;

        switch (func5) {
          case 0x00:

          break;

          case 0x01:

          break;

          case 0x02:

          break;

          case 0x03:

          break;

          case 0x04:

          break;

          case 0x0a:

          break;

          case 0x0c:

          break;

          case 0x10:

          break;

          case 0x14:

          break;

          case 0x18:

          break;

          case 0x1c:

          break;

          default:
            std::cout << "Illegal Atomic instruction";
          break;
        }
      }
    break;


    case 0b1110011:
        func3 = (IR >> 12) & 0b111;
        rd =  (IR >> 7)  & 0b11111;
        rs1 = (IR >> 15) & 0b11111;
        func12 = (IR >> 20) & 0xFFF;

        switch (func3) {
          case 0b000:
            if (func12 == 1)
              std::cout << "ebreak";
          break;

          default:
            std::cout << "ecall";
          break;
        }
    break;


    default:
        std::cout << "Illegal instruction";
    break;
  }

}
