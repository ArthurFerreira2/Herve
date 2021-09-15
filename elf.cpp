#include <iostream>
#include <iomanip>
#include <cstdio>
#include <cstdlib>

#include "cpu.h"
#include "mem.h"
#include "elf.h"

extern Cpu cpu;
extern Mem mem;


int loadElf(char* filename) {

  // try to open the file in read-only/binary mode
  FILE* ElfFile = fopen(filename, "rb");
  if (ElfFile == NULL) {
    std::cerr << "Can't open file " << filename << std::endl;
    return 1;
  }

  // read the ELF header
  Elf32Header header;
  if (fread(&header, 1, sizeof(header), ElfFile) != sizeof(header)) {
    std::cerr << "Could not load the ELF header (file too small ?)\n";
    return 2;
  }

  // check the magic #
  if (header.e_ident[0] != 0x7F || header.e_ident[1] != 'E'
   || header.e_ident[2] != 'L' || header.e_ident[3] != 'F') {
    std::cerr << "Not an ELF file\n";
    return 3;
  }

  // check class
  if (header.e_ident[4] != 1) {
    std::cerr << "Not a 32 bits ELF file\n";
    return 4;
  }

  if (header.e_ehsize != sizeof(header)) {
    std::cerr << "ELF header sizes inconsistency\n";
    return 5;
  }

  // check enfianness
  if (header.e_ident[5] != 1) {
    std::cerr << "Not a Little Endian encoded binary\n";
    return 6;
  }

  // check type of binary
  if ((header.e_type == 0) || (header.e_type > 3)) {
    std::cerr << "Not an executable ELF file\n";
    return 7;
  }

  // check architecture
  if (header.e_machine != 0xF3) {
    std::cerr << "Not a RISC-V ELF file\n";
    return 8;
  }

  // read the program headers : we expect only one - but might be more
  Elf32ProgramHeader pHeader;

  // check we have at least one .text segment (program)
  if (header.e_phoff == 0) {
    std::cerr << "No executable found in ELF file " << filename << std::endl;
    return 9;
  }

  // check program header size against the elf file header
  if (header.e_phentsize != sizeof(pHeader)) {
    std::cerr << "Segment header sizes inconsistency\n";
    return 10;
  }

  // now, we know there are "header.e_phnum" segments of "header.e_phentsize" bytes each

  // move the file cursor into the first segment header
  if (header.e_phoff != header.e_ehsize) {
    std::cerr << "Moving to the first entry in the segment table\n";
    if (fseek(ElfFile, (long)(header.e_phoff - header.e_ehsize), SEEK_CUR) != 0) {
      std::cerr << "Can't seek into segment table position\n";
      return 11;
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
      return 12;
    }

    // check segment type
    if (pHeader.type != 1){
      std::cerr << "This segment is not a valid load\n";
      // return 13;
      continue;  // move to next segment
    }

    // if the segment is not right after this program header
    if (pHeader.offset != 0) {

      // save the file position, for the next segment header
      nextPHeaderPosition = ftell(ElfFile);
      if (nextPHeaderPosition < 0) {
        std::cerr << "Can't save cursor position in file " << filename << std::endl;
        return 14;
      }

      // and move up to the segment itself
      if (fseek(ElfFile, pHeader.offset, SEEK_CUR) != 0) {
        std::cerr << "Can't seek into segment #" << segmentNum << std::endl;
        return 15;
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
      return 16;
    }

    // read the segment into memory
    if (fread(mem.ram8, 1, pHeader.filesz, ElfFile) != pHeader.filesz) {
      std::cerr << "Can't load segment #" << segmentNum << "into RAM\n";
      return 17;
    }

    // reset the un-initialized data into memory (arrays, etc...)
    for (uint32_t i = 0; i < (pHeader.memsz - pHeader.filesz); i++) {
      mem.set8(pHeader.filesz + i , 0);
    }

    // restore the file cursor for the next segment header
    if (nextPHeaderPosition != 0) {
      if (fseek(ElfFile, nextPHeaderPosition, SEEK_SET) != 0) {
        std::cerr << "can't restore cursor position in file " << filename << std::endl;
        return 18;
      }
    }

    // This part need a full review


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

  return 0;
}
