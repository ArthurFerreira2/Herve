// as Mark Twain could have said :
// I apologize for writing such a complicated program.
// I didn't have time to write a simple one.


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

  if (argc != 2){
    std::cerr << "Usage : herve program.bin" << std::endl;
    exit(EXIT_FAILURE);
  }

  std::filesystem::path filepath = argv[1];
  if (!filepath.has_filename()) {
    std::cerr << "Not a valid filename" << std::endl;
    exit(EXIT_FAILURE);
  }

  std::ifstream file;
  file.open(argv[1], std::ios::binary | std::ios::ate);
  if (!file.is_open()) {
    std::cerr << "Can't open file" << std::endl;
    exit(EXIT_FAILURE);
  }

  auto end = file.tellg();
  file.seekg(0, std::ios::beg);
  auto size = std::size_t(end - file.tellg());
  if (size > 0xFFFF) {
    std::cerr << "Not enough memory" << std::endl;
    exit(EXIT_FAILURE);
  }

  file.read((char*)mem.ram8, size);
  file.close();
  std::cout << "Loaded " << (size << 2) << " words from " << filepath.filename() << " into memory" << std::endl;

  // dump of the file
  // for (uint32_t address=0; address<(uint32_t)size; address+=4){
  //   std::cerr << std::hex << std::setfill('0') << std::setw(8) << mem.get32(address) << std::endl;
  // }


  while (cpu.instructionCycles < 14 && cpu.state != HALTED) cpu.exec(1);

	std::cout << "\nProgram terminated" << std::endl;

  exit(EXIT_SUCCESS);
}
