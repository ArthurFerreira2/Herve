#include "cpu.h"


void Cpu::reset() {
  for (int i = 0; i<32; i++){
    x[i] = 0;
  }
  pc = 0;
  return;
}

int Cpu::exec(int cycles){
  static int cyclesToRun = 10;
  return --cyclesToRun;
}
