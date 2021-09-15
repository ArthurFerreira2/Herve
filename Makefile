CXX = g++
FLAGS = -std=c++17 -pedantic -Wpedantic -Wall -Werror -O3
LIBS = 

herve: herve.cpp cpu.cpp mem.cpp
	$(CXX) $(FLAGS) $^ -o $@ $(LIBS)

.PHONY: clean

clean:
	rm -f herve
