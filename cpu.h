#ifndef __CPU_H__
#define __CPU_H__

#include <cstdint>

#define HALTED 0
#define RUNNING 1
#define PAUSED 2
#define STEPPING 3


extern std::ostream ctrace;

class Cpu {
public:

  bool TRACE = false;
  uint32_t instructionCycles = 0;

  const char* regNames[32] = {"zr", "ra", "sp", "gp", "tp", "t0", "t1", "t2", "s0", "s1", "a0", "a1", "a2", "a3", "a4", "a5", "a6", "a7", "s2", "s3", "s4", "s5", "s6", "s7", "s8", "s9", "s10", "s11", "t3", "t4", "t5", "t6"};
  int state = RUNNING;

  int32_t X[32] = {0};
  uint32_t PC = 0;

  Cpu() {};
  ~Cpu() {};

  int32_t getReg(int r);
  void setReg(int reg, int32_t value);

  void setPC(uint32_t address);
  uint32_t getPC();

  int exec(int cyclesCount);
};

#endif
