// debuging issues with the elf loader 


int main() {

  volatile char *echo = (volatile char*) 0x0e000000;

  const char *grettings = "let's print interger values !\n";
  while (*grettings) {
    *echo = *grettings;
    grettings++;
  }

  return 0;
}
