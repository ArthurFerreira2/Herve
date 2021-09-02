#ifndef __CPU__
#define __CPU__

#include <cstdint>

class Cpu {
  public:
    int32_t x[32] = {0};
    uint32_t pc = 0;

    Cpu() {reset();};
    ~Cpu() {};
    void reset();
    int exec(int cyclesCount);

    void setPC(uint32_t address);
    uint32_t getPC();

    int32_t getReg(int r);
    void setReg(int reg, int32_t value);

    void printRegs();
};

#endif
