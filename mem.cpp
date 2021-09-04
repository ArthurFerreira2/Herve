#include <iostream>
#include <iomanip>

#include "mem.h"

uint8_t Mem::get8(uint32_t address) {
  if (address < RAMSIZE)
    return ram8[address];
  else
    return 0;
}

uint16_t Mem::get16(uint32_t address) {
  if (address < RAMSIZE)
    return ram16[address >> 1];
  else
    return 0;
}

uint32_t Mem::get32(uint32_t address) {
  if (address < RAMSIZE)
    return ram32[address >> 2];
  else
    return 0;
}

void Mem::set8(uint32_t address, uint8_t value) {
  if (address == PUTCHAR) {
    std::cout << (char)value;
  }
  else if (address < RAMSIZE)
    ram8[address] = value;
}

void Mem::set16(uint32_t address, uint16_t value) {
  if (address == PUTCHAR) {
    std::cout << (char)value;
  }
  else if (address < RAMSIZE)
    ram16[address >> 1] = value;
}

void Mem::set32(uint32_t address, uint32_t value) {
  if (address == PUTCHAR) {
    std::cout << (char)value;
  }
  else if (address < RAMSIZE)
    ram32[address >> 2] = value;
}
