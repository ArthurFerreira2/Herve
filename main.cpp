#include <iostream>
#include <filesystem>
#include <string>

#include "cpu.h"
#include "mem.h"



int main(int argc, char* argv[]) {

  if (argc !=2){
    exit(EXIT_FAILURE);
  }

  std::filesystem::path p = argv[1];

  if (p.has_filename()) {
    std::cout << p.filename() << std::endl;;
  }

  Cpu cpu;
  Mem mem;

  cpu.reset();
  mem.reset();


  while (cpu.exec(1));

  exit(EXIT_SUCCESS);
}
