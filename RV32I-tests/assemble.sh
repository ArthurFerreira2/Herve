#!/bin/sh

riscv32-unknown-elf-as -march=rv32i -mabi=ilp32 $1.s -o $1.o
riscv32-unknown-elf-ld $1.o -o $1.elf

riscv32-unknown-elf-objcopy $1.elf -O binary $1.bin
riscv32-unknown-elf-objdump -d $1.dump
