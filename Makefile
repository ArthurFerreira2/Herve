CXX = g++
FLAGS = -std=c++17 -pedantic -Wpedantic -Wall -Werror -O3
LIBS =

%.o: %.cpp
	$(CXX) $(FLAGS) -c -o $@ $<

herve: cpu.o elf.o  herve.o  mem.o disasm.o
	$(CXX) $(FLAGS) $^ -o $@ $(LIBS)

.PHONY: clean check

clean:
	rm -f *.o herve

check: herve
	cd tests && ./runTests.sh
