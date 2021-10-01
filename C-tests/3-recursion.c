// some experiments... and only experiments
// please use better algorithms to implement these functions
// the goal here is to test and break Mr Herve
// function calls, recursion, arithmetical operations, etc ...


char *TX = (char*) 0x0e000000;


char asciiOfNum(int a) {
    return (char)(a + 48);
}


int mod(int number, int divisor){
  while(number >= divisor)
    number -= divisor;
  return number;
}


int div(int dividend, int divisor) {
  if (divisor == 0) return 0;
  int quotient = 0;
  while (dividend >= divisor) {
      dividend -= divisor;
      quotient++;
  }
  return quotient;
}


int mult(int a, int b) {
  if ((a==0) | (b==0)) return 0;
  if (a < b) {
    a = a ^ b;
    b = a ^ b;
    a = a ^ b;
  }
  int result = a;
  while (--b) result += a;
  return result;
}


int fact(int n) {
  if (n <= 1)
    return 1;
  else
    return mult(n , fact(n - 1));
}


void printInt(int number) {
  // works only if (number >= 1 && number <= 99999)
  if(number<1 || number >99999)
    return;

  int unit;
  char StringOfNumber[5];
  int cursor = 5;

  while(number > 0) {
    cursor--;
    unit = mod(number, 10);
    StringOfNumber[cursor] = asciiOfNum(unit);
    number = div(number, 10);
  }

  while (cursor < 5) {
    *TX = StringOfNumber[cursor];
    cursor++;
  }
  *TX = '\n';
}


void printStr(char *str) {
  while (*str) {
    *TX = *str;
    str++;
  }
}

int main() {

  printStr("let's print some interger values !\n");
  printInt(1972);
  printInt(mult(9, 7));
  printInt(fact(7));

  __asm__ ("ebreak"); // dirty fix until I implement ecalls
}
