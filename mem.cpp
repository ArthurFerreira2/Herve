#include <iostream>
#include <iomanip>

#include "mem.h"


void Mem::reset() {
  for (int address = 0; address<RAMSIZE; address++){
    ram[address] = 0;
  }
  return;
}

int32_t Mem::getInt32(uint32_t address) {

  if (address > RAMSIZE - 5)
    return 0;

   int32_t value = 0;
   value |= ((uint8_t)ram[address]);
   value |= ((uint8_t)(ram[address+1]) << 8);
   value |= ((uint8_t)(ram[address+2]) << 16);
   value |= ((uint8_t)(ram[address+3]) << 24);

  return value;
}
