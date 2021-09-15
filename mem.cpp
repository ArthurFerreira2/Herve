#include <iostream>
#include <iomanip>
#include "mem.h"


// NOTE : the way 8 and 16 bits access were implemented naturally prevent misaligned accesses


// TODO : write an exeption handler for memory violations and other unsupported events
// - dump memory address, PC value, instruction details, register status
// - and exit... or just display a nice blue screen and reboot ?



Mem::Mem() {
  ram16 = (int16_t*)*(&ram8);
  ram32 = (int32_t*)*(&ram8);
}

Mem::~Mem() {
  // nothing to dealocate
}

uint32_t Mem::getRamStartAddress() {
  return ramStartAddress;
}

void Mem::setRamStartAddress(uint32_t address) {
  ramStartAddress = address;
}

int8_t Mem::get8(uint32_t address) {
  address -= ramStartAddress;
  if (address < RAMSIZE)
    return ram8[address];
  else {
    std::cerr << "Illegal Memory Read" << std::endl;
    return 0;
  }
}

int16_t Mem::get16(uint32_t address) {
  address -= ramStartAddress;
  if (address < RAMSIZE)
    return ram16[address >> 1];
  else {
    std::cerr << "Illegal Memory Read" << std::endl;
    return 0;
  }
}

int32_t Mem::get32(uint32_t address) {
  address -= ramStartAddress;
  if (address < RAMSIZE)
    return ram32[address >> 2];
  else {
    std::cerr << "Illegal Memory Read" << std::endl;
    return 0;
  }
}

void Mem::set8(uint32_t address, int8_t value) {
  if (address == PUTCHAR) {
    std::cout << (char)value;
  }
  else {
    address -= ramStartAddress;
    if (address < RAMSIZE)
      ram8[address] = value;
    else
      std::cerr << "Illegal Memory Write" << std::endl;
  }
}

void Mem::set16(uint32_t address, int16_t value) {
  if (address == PUTCHAR) {
    std::cout << (char)value;
  }
  else {
    address -= ramStartAddress;
    if (address < RAMSIZE)
      ram16[address >> 1] = value;
    else
      std::cerr << "Illegal Memory Write" << std::endl;
  }
}

void Mem::set32(uint32_t address, int32_t value) {
  if (address == PUTCHAR) {
    std::cout << (char)value;
  }
  else {
    address -= ramStartAddress;
    if (address < RAMSIZE)
      ram32[address >> 2] = value;
    else
      std::cerr << "Illegal Memory Write" << std::endl;
  }
}
