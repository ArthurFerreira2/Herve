#ifndef __MEM__
#define __MEM__

#include <cstdint>

#define RAMSIZE 0x10000

class Mem {
  public:
    int8_t ram[RAMSIZE] = {0};   // 64K of RAM - who needs more ?

    Mem() {
      reset();
    }
    ~Mem() {}

    void reset();
    int32_t getInt32(uint32_t address);
};

#endif
