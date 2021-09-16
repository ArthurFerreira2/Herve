#!/bin/sh

riscv32-unknown-elf-gcc -march=rv32i -mabi=ilp32 -Os -nostdlib -Wall -Werror $1.c -o $1.elf
# riscv32-unknown-elf-gcc -march=rv32i -mabi=ilp32 -Os -Wall -Werror $1.c -o $1.elf

riscv32-unknown-elf-objcopy $1.elf  -O binary $1.bin

riscv32-unknown-elf-objdump -ds $1.elf > $1.s

# echo "\n~~~ HEADER :"
# riscv32-unknown-elf-readelf -h $1.elf
#
# echo "\n~~~ SEGMENTS :"
# riscv32-unknown-elf-readelf --segments $1.elf
#
# echo "\n~~~ SECTIONS :\n"
# riscv32-unknown-elf-readelf --sections $1.elf
#
# echo "\n~~~ HD BIN DUMP :\n"
# hd $1.bin
#
# echo "\n~~~ XXD BIN DUMP :\n"
# xxd -p $1.bin
