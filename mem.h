#ifndef __MEM__
#define __MEM__

#include <cstdint>

class Mem {
  public:
    uint32_t ram[0x10000] = {0};  // 64K of RAM - who needs more ?
    uint32_t rom[0x100] = {0};    // 256 bytes of ROM ... for a future monitor

    Mem() {reset();};
    ~Mem() {};

    void reset();
};

#endif
