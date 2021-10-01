#!/bin/sh

riscv32-unknown-elf-gcc -nostdlib -nostartfiles -T link.ld  $1.s -o $1.elf
riscv32-unknown-elf-objcopy $1.elf -O binary $1.bin
riscv32-unknown-elf-objdump -d $1.elf > $1.dump
