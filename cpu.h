#ifndef __CPU__
#define __CPU__

#include <cstdint>

class Cpu {
  public:
    uint32_t x[32] = {0};
    uint32_t pc = 0;

    Cpu() {};
    ~Cpu() {};
    void reset();
    int exec(int cycles);
};

#endif
