#include <iostream>
#include <iomanip>

#include "cpu.h"
#include "mem.h"

extern Mem mem;
extern Cpu cpu;


void disasm(uint32_t address) {

  std::cout << std::hex << std::setfill('0') << std::setw(8) << address << ":\t" << std::dec;

  uint32_t func3, func5, func7, func12, rd, rs1, rs2, imm, shamt;
  uint32_t IR = mem.get32(address);
  uint32_t opcode = IR & 0b1111111;

  switch(opcode) {

    case 0b0110111:
        rd =  (IR >> 7) & 0b11111;
        imm = IR & 0xFFFFF000;
        std::cout << "lui\t" << cpu.regNames[rd] << "," << imm;
    break;


    case 0b0010111:
        rd =  (IR >> 7) & 0b11111;
        imm = IR & 0xFFFFF000;
        std::cout << "auipc\t" << cpu.regNames[rd] << "," << imm;
    break;


    case 0b1101111:
        rd =  (IR >> 7) & 0b11111;
        imm = (IR & 0x000FF000UL) | ((IR & 0x7FE00000) >> 20);
        if ((int32_t)IR < 0)
          imm |= 0xFFF00000;
        if (IR & 0x100000)
          imm |= 0x00000800UL;
        else
          imm &= 0xFFFFF7FF;

        std::cout << "jal\t" << cpu.regNames[rd] << "," << imm;
    break;


    case 0b1100111:
        func3 = (IR >> 12) & 0b111;
        rd = (IR >> 7) & 0b11111;
        rs1 = (IR >> 15) & 0b11111;
        imm = IR >> 20;

        switch (func3) {
          case 0b000:
            std::cout << "jalr\t" << cpu.regNames[rd] << ","  << cpu.regNames[rs1] << "," << imm;
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
          imm |= 0x00000800L;
        else
          imm &= 0xFFFFF7FF;

        switch (func3) {
          case 0b000:
            std::cout << "beq\t" << cpu.regNames[rs1] << ","  << cpu.regNames[rs2] << "," << imm;
          break;

          case 0b001:
            std::cout << "bne\t" << cpu.regNames[rs1] << ","  << cpu.regNames[rs2] << "," << imm;
          break;

          case 0b100:
            std::cout << "blt\t" << cpu.regNames[rs1] << ","  << cpu.regNames[rs2] << "," << imm;
          break;

          case 0b101:
            std::cout << "bge\t" << cpu.regNames[rs1] << ","  << cpu.regNames[rs2] << "," << imm;
          break;

          case 0b110:
            std::cout << "bltu\t" << cpu.regNames[rs1] << ","  << cpu.regNames[rs2] << "," << imm;
          break;

          case 0b111:
            std::cout << "bgeu\t" << cpu.regNames[rs1] << ","  << cpu.regNames[rs2] << "," << imm;
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
            std::cout << "lb\t" << cpu.regNames[rd] << "," << imm << "(" << cpu.regNames[rs1] << ")";
          break;

          case 0b001:
            std::cout << "lh\t" << cpu.regNames[rd] << "," << imm << "(" << cpu.regNames[rs1] << ")";
          break;

          case 0b010:
            std::cout << "lw\t" << cpu.regNames[rd] << "," << imm << "(" << cpu.regNames[rs1] << ")";
          break;

          case 0b100:
            std::cout << "lbu\t" << cpu.regNames[rd] << "," << imm << "(" << cpu.regNames[rs1] << ")";
          break;

          case 0b101:
            std::cout << "lhu\t" << cpu.regNames[rd] << "," << imm << "(" << cpu.regNames[rs1] << ")";
          break;

          default:
            std::cout << "Illegal I-type instruction";
          break;
        }
    break;


    case 0b0100011:
        func3 = (IR >> 12) & 0b111;
        rs1 =   (IR >> 15) & 0b11111;
        rs2 =   (IR >> 20) & 0b11111;
        imm =  ((IR >> 20)  & 0xFFFFFFE0) | ((IR >> 7) & 0x0000001FL);

        switch (func3) {
          case 0b000:
            std::cout << "sb\t" << cpu.regNames[rs2] << "," << imm << "(" << cpu.regNames[rs1] << ")";
          break;

          case 0b001:
            std::cout << "sh\t" << cpu.regNames[rs2] << "," << imm << "(" << cpu.regNames[rs1] << ")";
          break;

          case 0b010:
            std::cout << "sw\t" << cpu.regNames[rs2] << "," << imm << "(" << cpu.regNames[rs1] << ")";
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
            std::cout << "addi\t" << cpu.regNames[rd] << "," << cpu.regNames[rs1] << "," <<  imm;
          break;

          case 0b010:
            std::cout << "slti\t" << cpu.regNames[rd] << "," << cpu.regNames[rs1] << "," <<  imm;
          break;

          case 0b011:
            std::cout << "sltiu\t" << cpu.regNames[rd] << "," << cpu.regNames[rs1] << "," <<  imm;
          break;

          case 0b100:
            std::cout << "xori\t" << cpu.regNames[rd] << "," << cpu.regNames[rs1] << "," <<  imm;
          break;

          case 0b110:
            std::cout << "ori\t" << cpu.regNames[rd] << "," << cpu.regNames[rs1] << "," <<  imm;
          break;

          case 0b111:
            std::cout << "andi\t" << cpu.regNames[rd] << "," << cpu.regNames[rs1] << "," <<  imm;
          break;

          case 0b001:
            shamt = (IR >> 20) & 0b11111;
            std::cout << "slli\t" << cpu.regNames[rd] << "," << cpu.regNames[rs1] << "," <<  shamt;
          break;

          case 0b101:
            shamt = (IR >> 20) & 0b11111;
            if (func7 == 0x20)
              std::cout << "srai\t" << cpu.regNames[rd] << "," << cpu.regNames[rs1] << "," <<  shamt;
            else
              std::cout << "srli\t" << cpu.regNames[rd] << "," << cpu.regNames[rs1] << "," <<  shamt;
          break;

          default:
            std::cout << "Illegal I-type instruction";
          break;
        }
    break;


    case 0b0110011:
        func7 = (IR >> 25) & 0b1111111;
        func3 = (IR >> 12) & 0b111;
        rd =    (IR >> 7)  & 0b11111;
        rs1 =   (IR >> 15) & 0b11111;
        rs2 =   (IR >> 20) & 0b11111;

        if (func7 == 1) {

          switch (func3) {
            case 0b000:
              std::cout << "mul\t" << cpu.regNames[rd] << "," << cpu.regNames[rs1] << "," << cpu.regNames[rs2];
            break;

            case 0b001:
              std::cout << "mulh\t" << cpu.regNames[rd] << "," << cpu.regNames[rs1] << "," << cpu.regNames[rs2];
            break;

            case 0b010:
              std::cout << "mulhsu\t" << cpu.regNames[rd] << "," << cpu.regNames[rs1] << "," << cpu.regNames[rs2];
            break;

            case 0b011:
              std::cout << "mulhu\t" << cpu.regNames[rd] << "," << cpu.regNames[rs1] << "," << cpu.regNames[rs2];
            break;

            case 0b100:
              std::cout << "div\t" << cpu.regNames[rd] << "," << cpu.regNames[rs1] << "," << cpu.regNames[rs2];
            break;

            case 0b101:
              std::cout << "divu\t" << cpu.regNames[rd] << "," << cpu.regNames[rs1] << "," << cpu.regNames[rs2];
            break;

            case 0b110:
              std::cout << "rem\t" << cpu.regNames[rd] << "," << cpu.regNames[rs1] << "," << cpu.regNames[rs2];
            break;

            case 0b111:
              std::cout << "remu\t" << cpu.regNames[rd] << "," << cpu.regNames[rs1] << "," << cpu.regNames[rs2];
            break;
          }

        }
        else {

          switch (func3) {
            case 0b000:
              if (func7 == 0x20)
                std::cout << "sub\t" << cpu.regNames[rd] << "," << cpu.regNames[rs1] << "," << cpu.regNames[rs2];
              else
                std::cout << "add\t" << cpu.regNames[rd] << "," << cpu.regNames[rs1] << "," << cpu.regNames[rs2];
            break;

            case 0b001:
              std::cout << "sll\t" << cpu.regNames[rd] << "," << cpu.regNames[rs1] << "," << cpu.regNames[rs2];
            break;

            case 0b010:
              std::cout << "slt\t" << cpu.regNames[rd] << "," << cpu.regNames[rs1] << "," << cpu.regNames[rs2];
            break;

            case 0b011:
              std::cout << "sltu\t" << cpu.regNames[rd] << "," << cpu.regNames[rs1] << "," << cpu.regNames[rs2];
            break;

            case 0b100:
              std::cout << "xor\t" << cpu.regNames[rd] << "," << cpu.regNames[rs1] << "," << cpu.regNames[rs2];
            break;

            case 0b101:
              if (func7 == 0x20)
                std::cout << "sra\t" << cpu.regNames[rd] << "," << cpu.regNames[rs1] << "," << cpu.regNames[rs2];
              else
                std::cout << "srl\t" << cpu.regNames[rd] << "," << cpu.regNames[rs1] << "," << cpu.regNames[rs2];
            break;

            case 0b110:
              std::cout << "or\t" << cpu.regNames[rd] << "," << cpu.regNames[rs1] << "," << cpu.regNames[rs2];
            break;

            case 0b111:
              std::cout << "and\t" << cpu.regNames[rd] << "," << cpu.regNames[rs1] << "," << cpu.regNames[rs2];
            break;

            default:
              std::cout << "Illegal R-type instruction";
            break;
          }
        }
    break;


    case 0b0001111:
        func3 = (IR >> 12) & 0b111;
        rd =    (IR >> 7)  & 0b11111;
        rs1 =   (IR >> 15) & 0b11111;

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
        rd =    (IR >> 7)  & 0b11111;
        rs1 =   (IR >> 15) & 0b11111;
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
