#include <iostream>
#include <iomanip>
#include <cstdlib>

#include "cpu.h"
#include "mem.h"
#include "elf.h"

extern Cpu cpu;
extern Mem mem;

#define ELF_DEBUG 0

// TODO: stop re-inventing the wheel and use libELF

int loadElf(char *filename) {

  // try to open the file in read-only/binary mode
  FILE* ElfFile = fopen(filename, "rb");
  if (ElfFile == NULL) {
    std::cerr << "Can't open file " << filename << std::endl;
    return 3001;
  }

  // read the ELF header
  Elf32Header header;
  if (fread(&header, 1, sizeof(header), ElfFile) != sizeof(header)) {
    std::cerr << "Could not load the ELF header (file too small ?)\n";
    return 3002;
  }

  // check the magic #
  if (header.e_ident[0] != 0x7F || header.e_ident[1] != 'E'
   || header.e_ident[2] != 'L' || header.e_ident[3] != 'F') {
    std::cerr << "Not an ELF file\n";
    return 3003;
  }

  // check class
  if (header.e_ident[4] != 1) {
    std::cerr << "Not a 32 bits ELF file\n";
    return 3004;
  }

  // check our ELF header struct size matches the one in the ELF file
  if (header.e_ehsize != sizeof(header)) {
    std::cerr << "ELF header sizes inconsistency\n";
    return 3005;
  }

  // check enfianness
  if (header.e_ident[5] != 1) {
    std::cerr << "Not a Little Endian encoded binary\n";
    return 3006;
  }

  // check type of binary
  if ((header.e_type == 0) || (header.e_type > 3)) {
    std::cerr << "Not an executable ELF file\n";
    return 3007;
  }

  // check architecture
  if (header.e_machine != 0xF3) {
    std::cerr << "Not a RISC-V ELF file\n";
    return 3008;
  }


  // header looks fine so far... let's read the program table entries
  // read the program headers : we expect only one - but might be more


  Elf32ProgramHeader pHeader;

  // check we have at least one .text segment (program)
  if (header.e_phoff == 0) {
    std::cerr << "No executable found in ELF file " << filename << std::endl;
    return 3009;
  }

  // check program header size against the ELF file header
  if (header.e_phentsize != sizeof(pHeader)) {
    std::cerr << "Segment header sizes inconsistency\n";
    return 3010;
  }

  // now, we know there are "header.e_phnum" segments of "header.e_phentsize" bytes each

  // move the file cursor into the first segment header
  if (header.e_phoff != header.e_ehsize) {
    if (ELF_DEBUG) std::cout << "Moving to the first entry in the segment table\n";
    if (fseek(ElfFile, (long)(header.e_phoff - header.e_ehsize), SEEK_CUR) != 0) {
      std::cerr << "Can't seek into segment table position\n";
      return 3011;
    }
  }

  long nextPHeaderPosition = {0};

  if (ELF_DEBUG) std::cout << "Number of segments : " << header.e_phnum << std::endl;

  // lets read all of them into memory (we expect only one but might be more ...)
  for (int segmentNum = 0; segmentNum < header.e_phnum; segmentNum++) {

    nextPHeaderPosition = 0;


    if (fread(&pHeader, 1, sizeof(pHeader), ElfFile) != sizeof(pHeader)) {
      std::cerr << "Error while reading Program Header # " << segmentNum << std::endl;
      return 3012;
    }

    // check segment type
    if (pHeader.type != 1){
      if (ELF_DEBUG) std::cout << "This segment is not a valid load\n";
      // return 3013;
      continue;  // move to next segment
    }

    // if the segment is not right after this program header
    if (pHeader.offset != 0) {

      // save the file position, for the next segment header
      nextPHeaderPosition = ftell(ElfFile);
      if (nextPHeaderPosition < 0) {
        std::cerr << "Can't save cursor position in file " << filename << std::endl;
        return 3014;
      }

      // and move up to the segment itsELF
      if (fseek(ElfFile, pHeader.offset, SEEK_SET) != 0) {
        std::cerr << "Can't seek into segment #" << segmentNum << std::endl;
        return 3015;
      }
    }

    // display some information about the segment we are about to load
    if (ELF_DEBUG) {
      std::cout << std::hex;
      std::cout << "\nLoading segment  : 0x" << segmentNum << std::endl;
      std::cout << "Flags            : 0x" << pHeader.flags << std::endl;
      std::cout << "Size in file     : 0x" << pHeader.filesz << std::endl;
      std::cout << "Size in memory   : 0x" << pHeader.memsz << std::endl;
      std::cout << std::setfill('0') << std::setw(8);
      std::cout << "Physical address : 0x" << pHeader.paddr << std::endl;
      std::cout << "Virtual address  : 0x" << pHeader.vaddr << std::endl;
    }

    // check we have enough memory
    if (pHeader.memsz > RAMSIZE) {
      std::cerr << "Can't fit segment #" << segmentNum << " into memory\n";
      return 3016;
    }

    if (segmentNum == 0) {
      // initialize virtual address
      mem.setRamStartAddress(pHeader.paddr);
      if (ELF_DEBUG) std::cout << "start of memory  : 0x" << mem.getRamStartAddress() << std::endl;


      // initialise program counter
      cpu.setPC(header.e_entry);
      // cpu.setPC(pHeader.paddr);
      if (ELF_DEBUG) std::cout << "Entry point      : 0x" << cpu.getPC() << std::endl;

      // initialise stack pointer
      cpu.setReg(2, mem.getRamStartAddress() + RAMSIZE - 1);  // set SP to last address in RAM
      if (ELF_DEBUG) std::cout << "Stack Pointer    : 0x" << cpu.getReg(2) << std::endl;
    }

    // read the segment into memory
    if (fread(mem.ram8 + (int)(pHeader.paddr - mem.getRamStartAddress()), 1, pHeader.filesz, ElfFile) != pHeader.filesz) {
      std::cerr << "Can't load segment #" << segmentNum << "into RAM\n";
      return 3017;
    }

    // reset the un-initialized data into memory (arrays, etc...)
    for (uint32_t i = 0; i < (pHeader.memsz - pHeader.filesz); i++) {
      mem.set8(pHeader.filesz + i , 0);
    }

    // restore the file cursor for the next segment header
    if (nextPHeaderPosition != 0) {
      if (fseek(ElfFile, nextPHeaderPosition, SEEK_SET) != 0) {
        std::cerr << "can't restore cursor position in file " << filename << std::endl;
        return 3018;
      }
    }


    // dump the memory - debug
    if (ELF_DEBUG) {
      for (uint32_t address = pHeader.paddr; address < pHeader.paddr+pHeader.memsz; address += 4) {
        std::cout << std::setfill('0') << std::setw(8) << address << " ";
        std::cout << std::setfill('0') << std::setw(8) << mem.get32(address) << std::endl;
      }
    }
  }

  return 0;
}
