#include <iostream>
#include <iomanip>
#include <fstream>
#include <vector>
#include <algorithm>
#include <unistd.h>  // getopt

#include "cpu.h"
#include "mem.h"
#include "elf.h"

Cpu cpu;
Mem mem;

std::ostream ctrace(std::cout.rdbuf());  //

void disasm(uint32_t address);

void printHelp(){
  std::cout << "help :\n";
  std::cout << "  - d[addr]\tdump memory from addr or PC if addr not specified\n";
  std::cout << "  - l[addr]\tdisassemble code from addr or PC if addr not specified\n";
  std::cout << "  - b[addr]\ttoggle breakpoint at addr or PC if addr not specified\n";
  std::cout << "  - s[num]\texecute num instructions or only one if num not specified\n";
  std::cout << "  - r\t\tprint registers\n";
  std::cout << "  - c\t\tcontinue execution until next breakpoint\n";
  std::cout << "  - q\t\tquit\n";
  std::cout << "\n";
}

int main(int argc, char* argv[]) {

  setbuf(stdout, NULL);
  setbuf(stderr, NULL);

  char *programFile = nullptr;
  std::ofstream filestr;

  bool stepping = false;

  // parse command line arguments
  if (optind < argc){
    programFile  = argv[optind];
  }
  int opt;
  while ((opt = getopt(argc, argv, "o:dtsh")) != -1) {
    switch (opt) {
      case 't':
        cpu.TRACE = true;
      break;

      case 's':
        cpu.TRACE = true;
        stepping = true;
      break;

      // case 'i':
      //   programFile = optarg;
      // break;

      case 'o':
        cpu.TRACE = true;
        filestr.open(optarg);
        ctrace.rdbuf(filestr.rdbuf());
      break;

      case 'h':
      default:
        std::cout << "Usage: herve [-tsh] -i programFile [-o traceFile]\n";
        std::cout << " -h  print this help\n";
        std::cout << " -i  mandatory : specifies the file (rv32 elf) to execute\n";
        std::cout << " -o  specifies the file where to write the execution traces (implies -t)\n";
        std::cout << " -t  enable execution traces\n";
        std::cout << " -s  step by step execution (implies -t)" << std::endl;
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


  if (stepping) {

    std::cout << "\t _\n";
    std::cout << "\t| |__    ___  _ __ __   __ ___ \n";
    std::cout << "\t| '_ \\  / _ \\| '__|\\ \\ / // _ \\\n";
    std::cout << "\t| | | ||  __/| |    \\ V /|  __/\n";
    std::cout << "\t|_| |_| \\___||_|     \\_/  \\___|\n";
    std::cout << "\t     RISC-V RV32im simulator\n\n";

    printHelp();

    std::cout << "\n" << programFile << "Loaded at " << std::hex << std::setfill('0') << std::setw(8) << mem.getRamStartAddress() << "\n";
    std::cout << "PC set at " << std::hex << std::setfill('0') << std::setw(8) << cpu.PC << "\n";
    std::cout << "SP set at " << std::hex << std::setfill('0') << std::setw(8) << cpu.getReg(2) << "\n\n";

    char c, oldC='s', command[256];
    std::vector<uint32_t> breakpoints;

    // Enter into execution loop until CPU is halted
    while (cpu.state != HALTED) {
      std::cout << ">> ";
      std::cin >> command;
      c = ((command[0]>96) && (command[0]<123)) ? command[0] : oldC;
      oldC = c;

      switch (c) {
        case 'd' :  // dump memory
          {
            uint32_t startAddress;
            try {
              startAddress = std::stoul(command + 1, nullptr, 16);
            }
            catch(std::exception& e) {
              startAddress = cpu.PC;
            }
            startAddress -= startAddress%16;
            uint32_t endAddress = startAddress + 512;
            uint32_t address = startAddress;
            while(startAddress < RAMSIZE && startAddress < endAddress) {
              std::cout << "\n" << std::hex << std::setfill('0') << std::setw(8) << address << ": ";

              for (int i=0; i<16; i++) {
                uint16_t b = mem.get8(address) & 0xF;
                std::cout  << std::setfill('0') << std::setw(2) << std::hex << b << " ";
                address++;
              }
              address = startAddress;
              std::cout << std::dec << "| ";
              for (int i=0; i<16; i++) {
                char c = (char)mem.get8(address);
                if (c < 32) c = '.';
                std::cout << c;
                address++;
              }
              startAddress += 16;
            }
            std::cout << "\n\n";
          }
        break;

        case 'l' : // list code
          {
            uint32_t address;
            try {
              address = std::stoul(command + 1, nullptr, 16);
            }
            catch(std::exception& e) {
              address = cpu.PC;
            }
            address -= address%4;

            for (int i=0; i<16; i++, address+=4) {
              disasm(address);
              if (std::find(breakpoints.begin(), breakpoints.end(), address) != breakpoints.end())
                std::cout << "\t<< breakpoint";
              if (address == cpu.PC)
                std::cout << "\t<< PC";
              std::cout << std::endl;
            }
            std::cout << std::endl;
          }
        break;

        case 's' : // step
          {
            uint32_t numInstr;
            try {
              numInstr = std::stoul(command + 1, nullptr, 16);
            }
            catch(std::exception& e) {
              numInstr = 1;
            }
            for (uint32_t i=0; i<numInstr; i++) {
              if (cpu.state != HALTED) {
                cpu.exec(1);
                // std::cout << std::endl;
              }
            }
          }
        break;

        case 'b' :
          {
            uint32_t address;
            try {
              address = std::stoul(command + 1, nullptr, 16);
            }
            catch(std::exception& e) {
              address = cpu.PC;
            }
             // check if the breakpoint was already set
            if(std::find(breakpoints.begin(), breakpoints.end(), address) != breakpoints.end()) {
              breakpoints.erase(std::remove(breakpoints.begin(), breakpoints.end(), address), breakpoints.end());  // remove it if this is the case
            }
            else {
              breakpoints.push_back(address);                // otherwise set it
            }
          }
        break;

        case 'c' : // continue until next breakpoint
          do {
            cpu.exec(1);
            // std::cout << std::endl;
          } while ((std::find(breakpoints.begin(), breakpoints.end(), cpu.PC) == breakpoints.end()) && (cpu.state != HALTED));
        break;

        case 'q' : // quit
          cpu.state = HALTED;
        break;

        case 'r' : // print registers
          for (int i=0; i<32; i++) {
            std::cout << std::left  << std::setfill(' ') << std::setw(3) << cpu.regNames[i] << " ";
            std::cout << std::right << std::setfill('.') << std::setw(8) << std::hex << cpu.X[i]  << "  ";
            if (!((i+1)%8)) std::cout << "\n";
          }
          std::cout << std::endl;
        break;

        default:
          printHelp();
        break;
      }
    }
  }
  else
    while (cpu.state != HALTED)
      cpu.exec(1);

  // execution summary (only if trace is enabled)
  if (cpu.TRACE) ctrace << "\nProgram halted after " << std::dec << cpu.instructionCycles << " instruction cycles\n";

  filestr.close();
  exit(EXIT_SUCCESS);
}
