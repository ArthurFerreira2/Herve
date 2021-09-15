// riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -nostdlib test1.c -o test1.elf
// riscv32-unknown-elf-r-objcopy test.elf -O binary test.bin
// riscv32-unknown-elf-objdump -D test.elf > test.s
// riscv32-unknown-elf-readelf -h test.elf


char digit(int a) {
    return a + 48;
}

void _start() {
  volatile char* tx = (volatile char*) 0x0e000000;
  const char* hello = "Hello from Hervé !\n";
  while (*hello) {
    *tx = *hello;
    hello++;
  }

  *tx = '\n';
  *tx = digit(4);
  *tx = digit(2);
  *tx = '\n';

}
