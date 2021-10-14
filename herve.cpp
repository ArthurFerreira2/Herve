#include <iostream>
#include <fstream>
#include <unistd.h>  // getopt

#include "cpu.h"
#include "mem.h"
#include "elf.h"


Cpu cpu;
Mem mem;

std::ostream ctrace(std::cout.rdbuf());  //


int main(int argc, char* argv[]) {

  setbuf(stdout, NULL);
  setbuf(stderr, NULL);

  char *programFile = nullptr;
  std::ofstream filestr;

  bool stepping = false;


  // parse command line arguments
  int opt;
  while ((opt = getopt(argc, argv, "i:o:dtsh")) != -1) {
    switch (opt) {
      case 't':
        cpu.TRACE = true;
      break;

      case 's':
        cpu.TRACE = true;
        stepping = true;
      break;

      case 'i':
        programFile = optarg;
      break;

      case 'o':
        cpu.TRACE = true;
        filestr.open(optarg);
        ctrace.rdbuf(filestr.rdbuf());
      break;

      case 'h':
      default:
        std::cout << "Usage: herve [-tsh] -i programFile [-o traceFile]\n";
        std::cout << " -h  print this help\n";
        std::cout << " -t  enable execution traces\n";
        std::cout << " -s  enable execution traces and step by step execution\n";
        exit(EXIT_SUCCESS);
      break;
    }
  }


  // Load program into memory
  int errorCode = loadElf(programFile);
  if (errorCode) {
    std::cerr << "Error " << errorCode << " - Program aborted\n";
    exit(errorCode);
  }

  // Enter into execution loop until CPU is halted
  while (cpu.state != HALTED) {
    cpu.exec(1);
    if (stepping) getchar();
  }

  // execution summary (only if traces )
  if (cpu.TRACE) ctrace << "\nProgram halted after " << std::dec << cpu.instructionCycles << " instruction cycles\n";

  filestr.close();
  exit(EXIT_SUCCESS);
}
