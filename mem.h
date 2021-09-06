#ifndef __MEM__
#define __MEM__

#include <cstdint>

#define RAMSIZE 0x10000

// temporarely using memory mapped I/O until ecall is implemented...
#define GETCHAR 0x0f000000
#define PUTCHAR 0x0e000000

class Mem {
  public:
    int8_t ram8[RAMSIZE] = {0};
    int16_t *ram16;
    int32_t *ram32;

    Mem() {
      // ram = new std::array<uint8_t, RAMSIZE>
      ram16 = (int16_t*)*(&ram8);
      ram32 = (int32_t*)*(&ram8);
    }
    ~Mem() {}

    int8_t get8(uint32_t address);
    int16_t get16(uint32_t address);
    int32_t get32(uint32_t address);

    void set8(uint32_t address, int8_t value);
    void set16(uint32_t address, int16_t value);
    void set32(uint32_t address, int32_t value);
};

#endif
