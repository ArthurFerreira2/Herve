#include <iostream>
#include <filesystem>
#include <fstream>
#include <string>

#include "cpu.h"
#include "mem.h"


int main(int argc, char* argv[]) {

  Cpu cpu;
  Mem mem;

  if (argc !=2){
    std::cout << "Usage : Herve program.bin" << std::endl;;
    exit(EXIT_FAILURE);
  }

  std::filesystem::path filepath = argv[1];

  if (!filepath.has_filename()) {
    std::cout << argv[1] << " is not a valid filename"<< std::endl;;
    exit(EXIT_FAILURE);
  }

  std::ifstream file;
  file.open(argv[1], std::ios::binary | std::ios::ate);

  if (!file.is_open()) {
    std::cout << "Could not open " << argv[1] << std::endl;
    exit(EXIT_FAILURE);
  }

  auto end = file.tellg();
  file.seekg(0, std::ios::beg);
  auto size = std::size_t(end - file.tellg());
  if (size > 0xFFFF) {
    std::cout << "Not enouth memory (" << size << " bytes) to load " << argv[1] <<  std::endl;
    exit(EXIT_FAILURE);
  }

  std::cout << "Loading " << size/4 << " words from "<< filepath.filename() << " into memory" << std::endl;

  file.read((char*)mem.ram, size);
  file.close();

  for (int i=0; i<((int)size/4); i++){
    std::cout << std::hex << mem.ram[i] << " ";
  }
  std::cout << std::endl;

  while (cpu.exec(1));

  exit(EXIT_SUCCESS);
}
