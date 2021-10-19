#include <iostream>
#include <iomanip>
#include <fstream>
#include <vector>    // breakpoints
#include <string>
#include <algorithm> // to manage breakpoints
#include <unistd.h>  // getopt

#include "cpu.h"
#include "mem.h"
#include "elf.h"

Cpu cpu;
Mem mem;

std::ostream ctrace(std::cout.rdbuf());  // trace stream

void disasm(uint32_t address, int32_t IR);   // TODO : create an header file

void printHelp(){
  std::cout << "help :\n";
  std::cout << "  - d[addr]\tdump memory from addr or PC if addr not specified\n";
  std::cout << "  - l[addr]\tdisassemble code from addr or PC if addr not specified\n";
  std::cout << "  - b[addr]\ttoggle breakpoint at addr or PC if addr not specified\n";
  std::cout << "  - s[num]\texecute num instructions or only one if num not specified\n";
  std::cout << "  - r\t\tprint registers\n";
  std::cout << "  - p\t\tprint Program Counter (PC)\n";
  std::cout << "  - c\t\tcontinue execution until next breakpoint\n";
  std::cout << "  - q\t\tquit\n";
  std::cout << "\n";
}

int main(int argc, char* argv[]) {

  setbuf(stdout, NULL);
  setbuf(stderr, NULL);

  char *programFile = nullptr;
  std::ofstream filestr;

  bool stepping = false;  // TODO : use cpu.state = STEPPING; instead

  // parse command line arguments
  int opt;
  if (optind < argc)
    programFile = argv[optind];
  while ((opt = getopt(argc, argv, "o:dtsh")) != -1) {
    switch (opt) {
      case 't':
        cpu.TRACE = true;
      break;

      case 's':
        cpu.TRACE = true;
        stepping = true;
      break;

      case 'o':
        cpu.TRACE = true;
        filestr.open(optarg);
        ctrace.rdbuf(filestr.rdbuf());
      break;

      case 'h':
      default:
        std::cout << "Usage: herve programFile [-tsh]  [-o traceFile]\n";
        std::cout << " programFile : the file (rv32 elf) to execute\n";
        std::cout << " -h  print this help\n";
        std::cout << " -t  enable execution traces\n";
        std::cout << " -s  step by step execution (implies -t)" << std::endl;
        std::cout << " -o  specifies the file where to write the execution traces (implies -t)\n";
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



    char c='s', previousC='h';
    std::string command;
    uint32_t dumpAddress = 0;
    uint32_t disasmAddress = cpu.PC;
    std::vector<uint32_t> breakpoints;




    // Enter into execution loop until CPU is halted
    while (cpu.state != HALTED) {

      // get user input
      command="0";
      std::cout << ">> ";  // prompt
      std::getline(std::cin, command);
      try {
        c = ((command.at(0)>96) && (command.at(0)<123)) ? command.at(0) : previousC;
      }
      catch(std::exception& e) {
        c = previousC;
      }

      switch (c) {  // the first caracter is the actual command


        case 'd' :  // dump memory at PC or addr if specified
          {
            uint32_t startAddress;
            try {
              startAddress = std::stoul(command.c_str() + 1, nullptr, 16);
            }
            catch(std::exception& e) {
              startAddress = dumpAddress;
            }
            startAddress -= startAddress%16;
            uint32_t endAddress = startAddress + 512;
            uint32_t address = startAddress;

            while(startAddress < RAMSIZE && startAddress < endAddress) {
              std::cout << std::hex << std::setfill('0') << std::setw(8) << address << ": ";

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
              std::cout << "\n";
              startAddress += 16;
            }
            std::cout << "\n";
            dumpAddress = startAddress;
            previousC = 'd';
          }
        break;


        case 'l' : // disasm at PC of addr if specified
          {
            uint32_t address;
            try {
              address = std::stoul(command.c_str() + 1, nullptr, 16);
            }
            catch(std::exception& e) {
              address = disasmAddress;
            }
            address -= address % 4;

            for (int i=0; i<16; i++, address+=4) {
              disasm(address, mem.get32(address));
              if (std::find(breakpoints.begin(), breakpoints.end(), address) != breakpoints.end())
                std::cout << "\t<< breakpoint";
              if (address == cpu.PC)
                std::cout << "\t<< PC";
              std::cout << std::endl;
            }
            std::cout << std::endl;
            disasmAddress = address;
            previousC = 'l';
          }
        break;


        case 's' : // execute 1 or numInstr instructions
          {
            uint32_t numInstr;
            try {
              numInstr = std::stoul(command.c_str() + 1, nullptr, 16);
            }
            catch(std::exception& e) {
              numInstr = 1;
            }
            for (uint32_t i=0; i<numInstr && cpu.state != HALTED; i++)
              cpu.exec(1);
            previousC = 's';
          }
        break;


        case 'b' :  // toggle breakpoint
          {
            uint32_t address;
            try {
              address = std::stoul(command.c_str() + 1, nullptr, 16);
            }
            catch(std::exception& e) {
              if (breakpoints.empty())
                std::cout << "no breakpoint\n";
              else {
                std::cout << "list of breakpoints :\n";
                for(auto b = std::begin(breakpoints); b!=std::end(breakpoints); b++)
                  std::cout << "\t" << std::right << std::setfill('0') << std::setw(8) << std::hex << *b << "\n";
              }
              break;
            }
            auto indice = std::find(breakpoints.begin(), breakpoints.end(), address);
            if (indice != breakpoints.end())
              breakpoints.erase(indice);
            else
              breakpoints.push_back(address);
            previousC = '0';
          }
        break;


        case 'c' :  // continue until we reach a breakpoint (if any ...) or the programm terminates
          do
            cpu.exec(1);
          while ((std::find(breakpoints.begin(), breakpoints.end(), cpu.PC) == breakpoints.end()) && (cpu.state != HALTED));
          previousC = 'c';
        break;


        case 'q' :  // quit
          std::cout << "really quit [y/N] ? ";
          std::getline(std::cin, command);
          try {
            c = command.at(0);
          }
          catch(std::exception& e) {
            c = '0';
          }
          if (c=='y' || c == 'Y')
            cpu.state = HALTED;
        break;


        case 'p' :  // print PC
          std::cout << "PC : " <<  std::right << std::setfill('0') << std::setw(8) << std::hex << cpu.PC  << std::endl;
          previousC = '0';
        break;


        case 'r' :  // print registers
          for (int i=0; i<32; i++) {
            std::cout << std::left  << std::setfill(' ') << std::setw(3) << cpu.regNames[i] << " ";
            std::cout << std::right << std::setfill('.') << std::setw(8) << std::hex << cpu.X[i]  << "  ";
            if (!((i+1)%8)) std::cout << std::endl;
          }
          std::cout << std::endl;
          previousC = '0';
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
