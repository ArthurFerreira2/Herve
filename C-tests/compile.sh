#!/bin/sh

riscv32-unknown-elf-gcc -march=rv32i -mabi=ilp32 -nostdlib -Wall -Werror -S $1.c -o $1.s
riscv32-unknown-elf-as  -mabi=ilp32 -march=rv32i  $1.s -o $1.o
riscv32-unknown-elf-ld  -m elf32lriscv -T link.ld $1.o -o $1.elf
riscv32-unknown-elf-objcopy $1.elf -O binary $1.bin

echo "\n~~~ HEADER :"
riscv32-unknown-elf-readelf -h $1.elf

echo "\n~~~ SEGMENTS :"
riscv32-unknown-elf-readelf --segments $1.elf

echo "\n~~~ SECTIONS :\n"
riscv32-unknown-elf-readelf --sections $1.elf

echo "\n~~~ DUMP :\n"
riscv32-unknown-elf-objdump -ds $1.elf
