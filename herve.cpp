#include <iostream>
#include <iomanip>
#include <cstdio>
#include <cstdlib>

#include "cpu.h"
#include "mem.h"
#include "elf.h"


Cpu cpu;
Mem mem;

int main(int argc, char* argv[]) {

  setbuf(stdout, NULL);
  setbuf(stderr, NULL);

  // Check a program has been provided as 1st argument
  if (argc != 2){
    std::cerr << "Usage : herve program\n";
    exit(EXIT_FAILURE);
  }

  // Load program into memory
  int errorCode = loadElf(argv[1]);
  if(errorCode) {
    std::cerr << "Program borted\n";
    exit(errorCode);
  }

  // Enter into execution loop until CPU is halted
  while (cpu.state != HALTED) {
    cpu.exec(1);
    // getchar();
  }

  // Quitting
  std::cerr << "\n\nProgram halted after " << std::dec << cpu.instructionCycles << " instruction cycles\n";

  exit(EXIT_SUCCESS);
}
