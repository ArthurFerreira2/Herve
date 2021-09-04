#ifndef __MEM__
#define __MEM__

#include <cstdint>

#define RAMSIZE 0x10000
#define GETCHAR 0xFFF8
#define PUTCHAR 0xFFFC

class Mem {
  public:
    uint8_t ram8[RAMSIZE] = {0};
    uint32_t *ram32;
    uint16_t *ram16;

    Mem() {
      // ram = new std::array<uint8_t, RAMSIZE>
      ram16 = (uint16_t*)*(&ram8);
      ram32 = (uint32_t*)*(&ram8);
    }
    ~Mem() {}

    uint8_t get8(uint32_t address);
    uint16_t get16(uint32_t address);
    uint32_t get32(uint32_t address);

    void set8(uint32_t address, uint8_t value);
    void set16(uint32_t address, uint16_t value);
    void set32(uint32_t address, uint32_t value);
};

#endif
