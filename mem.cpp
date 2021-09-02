#include "mem.h"

void Mem::reset() {
  for (int i = 0; i<0x10000; i++){
    ram[i] = 0;
  }
  return;
}
