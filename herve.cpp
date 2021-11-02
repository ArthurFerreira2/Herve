#include <iostream>
#include <iomanip>
#include <fstream>
#include <vector>    // breakpoints
#include <algorithm> // to manage breakpoints
#include <string>
#include <unistd.h>  // getopt

#include "cpu.h"
#include "mem.h"
#include "elf.h"
#include "disasm.h"



Cpu cpu;
Mem mem;

std::ostream ctrace(std::cout.rdbuf());  // trace stream



void printHelp() {
  std::cout << "help :\n";
  std::cout << "  d[addr]  dump memory from last dumped memory address or from addr\n";
  std::cout << "  l[addr]  disassemble code from last disassembled address or from addr\n";
  std::cout << "  b[addr]  list breakpoints or toggle breakpoint at addr\n";
  std::cout << "  s[num]   execute one or num instructions\n";
  std::cout << "  c        continue execution until next breakpoint\n";
  std::cout << "  r        print registers\n";
  std::cout << "  p        print Program Counter\n";
  std::cout << "  j        set Program Counter (jump)\n";
  std::cout << "  h        print this help\n";
  std::cout << "  a        about\n";
  std::cout << "  q        quit\n\n";
}


void printUsage() {
  std::cout << "Usage: herve [-tsh] [-o traceFile] programFile\n";
  std::cout << "Where programFile is the file (rv32 elf) to execute\n";
  std::cout << " -h  print this help\n";
  std::cout << " -t  enable execution traces\n";
  std::cout << " -s  step by step execution (implies -t)" << std::endl;
  std::cout << " -o  specifies the file where to write the execution traces (implies -t)\n";
}



int main(int argc, char* argv[]) {

  setbuf(stdout, NULL);
  setbuf(stderr, NULL);

  // parse command line arguments
  char *programFile = nullptr;
  char *dumpFile = nullptr;
  std::ofstream filestr;
  bool stepping = false;  // TODO : use cpu.state = STEPPING; instead
  int opt;

  while ((opt = getopt(argc, argv, "o:tsh")) != -1) {
    switch (opt) {
      case 'o':
      cpu.TRACE = true;
      dumpFile = optarg;
      break;

      case 't':
        cpu.TRACE = true;
      break;

      case 's':
        // cpu.TRACE = true;
        stepping = true;
      break;

      case 'h':
      default:
        printUsage();
        exit(EXIT_SUCCESS);
      break;
    }
  }

  if (optind < argc)
    programFile = argv[optind];
  else {
    printUsage();
    exit(EXIT_SUCCESS);
  }


  // Load programFile into memory
  int errorCode = loadElf(programFile);
  if (errorCode != 0)
    exit(errorCode);


  if(!stepping) {  // -s option takes precedence and cancels trace dumps to file ...
    // TODO : ask confirmation to overwrite dumpFile if it already exists
    filestr.open(dumpFile);
    ctrace.rdbuf(filestr.rdbuf());
  }


  // CLI
  if (stepping) {

    std::cout << "\n"  // https://texteditor.com/multiline-text-art/
    "\t ▀██                                  \n"
    "\t  ██ ▄▄    ▄▄▄▄ ▄▄▄ ▄▄ ▄▄▄▄ ▄▄▄  ▄▄▄▄ \n"
    "\t  ██▀ ██ ▄█▄▄▄██ ██▀ ▀▀ ▀█▄  █ ▄█▄▄▄██\n"
    "\t  ██  ██ ██      ██      ▀█▄█  ██     \n"
    "\t ▄██▄ ██▄ ▀█▄▄▄▀▄██▄      ▀█    ▀█▄▄▄▀\n"
    "\t               RISC-V RV32im simulator\n"
    "\n";

    printHelp();

    std::cout << "\n\n" << programFile;
    std::cout << " loaded at " << std::hex << std::setfill('0') << std::setw(8) << mem.getRamStartAddress() << "\n";
    std::cout << "PC set at " << std::hex << std::setfill('0') << std::setw(8) << cpu.getPC() << "\n";
    std::cout << "SP set at " << std::hex << std::setfill('0') << std::setw(8) << cpu.getReg(2) << "\n";
    std::cout << std::endl;

    char c='0', previousC='0';
    std::string command;
    uint32_t dumpAddress = 0;
    std::vector<uint32_t> breakpoints;
    uint32_t address, startAddress, endAddress, numInstr;


    // Enter into execution loop until CPU is halted
    while (cpu.state != HALTED) {

      // get user input
      std::cout << ">> ";
      std::getline(std::cin, command);
      try {
        c = command.at(0);
      }
      catch(std::exception& e) {
        c = previousC;
      }

      switch (c) {  // the first caracter is the actual command

        case 'd' :  // dump memory at PC or addr if specified
          try {
            startAddress = std::stoul(command.c_str() + 1, nullptr, 16);
          }
          catch(std::exception& e) {
            startAddress = dumpAddress;
          }
          startAddress -= startAddress%16;
          endAddress = startAddress + 512;
          address = startAddress;

          while((startAddress < RAMSIZE) && (startAddress < endAddress)) {
            std::cout << std::hex << std::setfill('0') << std::setw(8) << address << ": ";

            for (int i=0; i<16; i++) {
              uint16_t b = mem.get8(address) & 0xFF;
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
          previousC = c;
        break;


        case 'c' :  // continue until we reach a breakpoint (if any ...) or the programm terminates
        case 's' :  // execute 1 or numInstr instructions
          try {
            numInstr = std::stoul(command.c_str() + 1, nullptr, 16);
          }
          catch(std::exception& e) {
            numInstr = 1;
          }
          do
            cpu.exec(1);
          while ((std::find(breakpoints.begin(), breakpoints.end(), cpu.getPC()) == breakpoints.end()) && (cpu.state != HALTED) && ((c=='c') || --numInstr > 0));

        case 'l' : // disasm at PC of addr if specified
          if(cpu.state != HALTED) {
            if (c == 'l') {
              try {
                address = std::stoul(command.c_str() + 1, nullptr, 16);
              }
              catch(std::exception& e) {
                address = cpu.getPC() > 8 ? cpu.getPC() - 8 : 0;
              }
            }
            else
              address = (cpu.getPC() > 8) ? cpu.getPC() - 8 : 0;

            address -= address % 4;

            for (int i=0; i<16; i++, address+=4) {
              disasm(address, mem.get32(address));
              if (std::find(breakpoints.begin(), breakpoints.end(), address) != breakpoints.end())
                std::cout << "\t<< breakpoint";
              if (address == cpu.getPC())
                std::cout << "\t<< PC";
              std::cout << std::endl;
            }
            std::cout << std::endl;
            previousC = c;
          }
        break;

        case 'b' :  // toggle breakpoint
        {
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
            std::cout << std::endl;
            break;
          }
          if (address%4) {break;} // provided address is not valid
          auto indice = std::find(breakpoints.begin(), breakpoints.end(), address);
          if (indice != breakpoints.end())
            breakpoints.erase(indice);
          else
            breakpoints.push_back(address);
          previousC = '0';
          std::cout << std::endl;
        }
        break;

        case 'j' :  // set PC (jump)
          try {
            address = std::stoul(command.c_str() + 1, nullptr, 16);
            cpu.setPC(address);
          }
          catch(std::exception& e) {
            std::cout << "Invalid address\n";
            break;
          }
          cpu.setPC(cpu.getPC() - (cpu.getPC() % 4));

        case 'p' :  // print PC
          std::cout << "PC : " << std::right << std::setfill('0') << std::setw(8) << std::hex << cpu.getPC()  << "\n\n";
          previousC = '0';
        break;

        case 'r' :  // print registers
          for (int i=0; i<32; i++) {
            std::cout << std::left  << std::setfill(' ') << std::setw(3) << cpu.regNames[i];
            std::cout << std::right << std::setfill('.') << std::setw(8) << std::hex << cpu.getReg(i);
            if (!((i+1)%8))
              std::cout << std::endl;
            else
              std::cout << "  ";
          }
          std::cout << std::endl;
          previousC = '0';
        break;

        case 'h' :  // print help
          printHelp();
        break;

        case 'a' :  // print about
          std::cout << "herve is a simple risc-v RV32im ISA simulator\n";
          std::cout << "open source, under the MIT lisence\n";
          std::cout << "more at : https://github.com/ArthurFerreira2/Herve\n";
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
          if ((c=='y') || (c == 'Y'))
            cpu.state = HALTED;
        break;

        default:
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
