#ifndef __CPU__
#define __CPU__

#include <cstdint>

class Cpu {
  public:
    int32_t X[32] = {0};
    uint32_t PC = 0;

    uint32_t instructionCount = 0;

    uint32_t IR = 0;  // instruction register
    uint32_t opcode, func3, func7, imm;
    int rd, rs1, rs2;

    Cpu() {};
    ~Cpu() {};

    int exec(int cyclesCount);

    void setPC(uint32_t address);
    uint32_t getPC();

    int32_t getReg(int r);
    void setReg(int reg, int32_t value);

    void printRegs();
    void printIR();
};

#endif
