#include <iostream>
#include <filesystem>
#include <fstream>
#include <iomanip>


#include "cpu.h"
#include "mem.h"

Cpu cpu;
Mem mem;

int main(int argc, char* argv[]) {

  setbuf(stdout, NULL);

  if (argc !=2){
    throw std::runtime_error("Usage : herve program.bin");
  }

  std::filesystem::path filepath = argv[1];
  if (!filepath.has_filename()) {
    throw std::runtime_error("Not a valid filename");
  }

  std::ifstream file;
  file.open(argv[1], std::ios::binary | std::ios::ate);
  if (!file.is_open()) {
    throw std::runtime_error("Could not open program file");
  }

  auto end = file.tellg();
  file.seekg(0, std::ios::beg);
  auto size = std::size_t(end - file.tellg());
  if (size > 0xFFFF) {
    throw std::runtime_error("Not enough memory");
  }

  file.read((char*)mem.ram8, size);
  file.close();
  std::cout << "Loaded " << size/4 << " words from " << filepath.filename() << " into memory" << std::endl;

  // dump of the file
  // for (uint32_t address=0; address<(uint32_t)size; address+=4){
  //   std::cerr << std::hex << std::setfill('0') << std::setw(8) << mem.get32(address) << std::endl;
  // }


  int instructionToExecute = 15;
  while (instructionToExecute--) cpu.exec(1);

  exit(EXIT_SUCCESS);
}
