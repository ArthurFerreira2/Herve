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

  // check an executable has been provided as 1st argument
  if (argc != 2){
    std::cerr << "Usage : herve program.bin\n";
    exit(EXIT_FAILURE);
  }

  // try to open the file in read-only/binary mode
  FILE* ElfFile = fopen(argv[1], "rb");
  if (ElfFile == NULL) {
    std::cerr << "Can't open file " << argv[1] << std::endl;
    exit(EXIT_FAILURE);
  }

  // read the ELF header
  Elf32Header header;
  if (fread(&header, 1, sizeof(header), ElfFile) != sizeof(header)) {
    std::cerr << "Could not load the ELF header (file too small ?)\n";
    exit(EXIT_FAILURE);
  }

  // check the magic #
  if (header.e_ident[0] != 0x7F || header.e_ident[1] != 'E'
   || header.e_ident[2] != 'L' || header.e_ident[3] != 'F') {
    std::cerr << "Not an ELF file\n";
    exit(EXIT_FAILURE);
  }

  // check class
  if (header.e_ident[4] != 1) {
    std::cerr << "Not a 32 bits ELF file\n";
    exit(EXIT_FAILURE);
  }

  if (header.e_ehsize != sizeof(header)) {
    std::cerr << "ELF header sizes inconsistency\n";
    exit(EXIT_FAILURE);
  }

  // check enfianness
  if (header.e_ident[5] != 1) {
    std::cerr << "Not a Little Endian encoded binary\n";
    exit(EXIT_FAILURE);
  }

  // check type of binary
  if ((header.e_type == 0) || (header.e_type > 3)) {
    std::cerr << "Not an executable ELF file\n";
    exit(EXIT_FAILURE);
  }

  // check architecture
  if (header.e_machine != 0xF3) {
    std::cerr << "Not a RISC-V ELF file\n";
    exit(EXIT_FAILURE);
  }

  // read the program headers : we expect only one - but might be more
  Elf32ProgramHeader pHeader;

  // check we have at least one .text segment (program)
  if (header.e_phoff == 0) {
    std::cerr << "No executable found in ELF file " << argv[1] << std::endl;
    exit(EXIT_FAILURE);
  }

  // check program header size against the elf file header
  if (header.e_phentsize != sizeof(pHeader)) {
    std::cerr << "Segment header sizes inconsistency\n";
    exit(EXIT_FAILURE);
  }

  // now, we know there are "header.e_phnum" segments of "header.e_phentsize" bytes each

  // move the file cursor into the first segment header
  if (header.e_phoff != header.e_ehsize) {
    std::cerr << "Moving to the first entry in the segment table\n";
    if (fseek(ElfFile, (long)(header.e_phoff - header.e_ehsize), SEEK_CUR) != 0) {
      std::cerr << "Can't seek into segment table position\n";
      exit(EXIT_FAILURE);
    }
  }

  long nextPHeaderPosition = {0};

  std::cerr << "Number of segments : " << header.e_phnum << std::endl;

  // lets read all of them into memory (we expect only one but might be more ...)
  for (int segmentNum = 0; segmentNum < header.e_phnum; segmentNum++) {

    nextPHeaderPosition = 0;

    std::cerr << "Loading segment #" << segmentNum << " into memory\n";

    if (fread(&pHeader, 1, sizeof(pHeader), ElfFile) != sizeof(pHeader)) {
      std::cerr << "Error while reading Program Header # " << segmentNum << std::endl;
      exit(EXIT_FAILURE);
    }

    // check segment type
    if (pHeader.type != 1){
      std::cerr << "This segment is not a valid load\n";
      // exit(EXIT_FAILURE);
      continue;  // move to next segment
    }

    // if the segment is not right after this program header
    if (pHeader.offset != 0) {

      // save the file position, for the next segment header
      nextPHeaderPosition = ftell(ElfFile);
      if (nextPHeaderPosition < 0) {
        std::cerr << "Can't save cursor position in file " << argv[1] << std::endl;
        exit(EXIT_FAILURE);
      }

      // and move up to the segment itself
      if (fseek(ElfFile, pHeader.offset, SEEK_CUR) != 0) {
        std::cerr << "Can't seek into segment #" << segmentNum << std::endl;
        exit(EXIT_FAILURE);
      }
    }

    // display some information about the segment we are about to load
    std::cerr << std::hex;
    std::cerr << "Flags            : 0x" << pHeader.flags << std::endl;
    std::cerr << "Size in file     : 0x" << pHeader.filesz << std::endl;
    std::cerr << "Size in memory   : 0x" << pHeader.memsz << std::endl;
    std::cerr << std::setfill('0') << std::setw(8);
    std::cerr << "Physical address : 0x" << pHeader.paddr << std::endl;
    std::cerr << "Virtual address  : 0x" << pHeader.vaddr << std::endl;

    // check we have enough memory
    if (pHeader.memsz > RAMSIZE) {
      std::cerr << "Can't fit segment #" << segmentNum << " into memory\n";
      exit(EXIT_FAILURE);
    }

    // read the segment into memory
    if (fread(mem.ram8, 1, pHeader.filesz, ElfFile) != pHeader.filesz) {
      std::cerr << "Can't load segment #" << segmentNum << "into RAM\n";
      exit(EXIT_FAILURE);
    }

    // reset the un-initialized data into memory (arrays, etc...)
    for (uint32_t i = 0; i < (pHeader.memsz - pHeader.filesz); i++) {
      mem.set8(pHeader.filesz + i , 0);
    }

    // restore the file cursor for the next segment header
    if (nextPHeaderPosition != 0) {
      if (fseek(ElfFile, nextPHeaderPosition, SEEK_SET) != 0) {
        std::cerr << "can't restore cursor position in file " << argv[1] << std::endl;
        exit(EXIT_FAILURE);
      }
    }


    // FIXME : take into account the 32bits alignment
    mem.programByteSize = pHeader.filesz;

    // FIXME : seems like the addresses are starting at beg. of elf file ???
    mem.setRamStartAddress(pHeader.paddr + header.e_ehsize + header.e_phentsize); // !@!@#!!!@

    // initialise program counter
    cpu.setPC(header.e_entry);
    // initialise stack pointer
    cpu.setReg(2, mem.getRamStartAddress() + RAMSIZE - 1);  // set SP to last address in RAM


    // dump the memory
    for (uint32_t address = mem.getRamStartAddress(); address < mem.getRamStartAddress() + mem.programByteSize; address += 4){
      std::cerr << address << " :    ";
      std::cerr << std::setfill('0') << std::setw(8) << mem.get32(address) << std::endl;
    }

  }




  while (cpu.state != HALTED) {
    cpu.exec(1);
    // getchar();
  }

  std::cerr << "\n\nProgram terminated\n";
  std::cerr << "After executing " << std::dec << cpu.instructionCycles << " instructions\n";

  exit(EXIT_SUCCESS);
}
