# riscv32-unknown-elf-as -march=rv32i 2-test.s -o 2-test.o
# riscv64-unknown-elf-ld -m elf32lriscv 2-test.o -o 2-test.elf 

.align 2
.globl _start

.set 		answer, 0x2a		# ascii code for '*'
.set  	cout,	0x0e000

.section .text

get_answer:
	li 	a0, answer
	nop					# checking pseudo instructions
	mv	a5, a7
	ret

_start:
	lui	t0, cout
	jal 	get_answer
	sw 	a0, 0(t0)
	jal 	end

end:
	ebreak

/*
# Pow function -- computes a^b
# Inputs: a0=a, a1=b
# Output: a0=a^b

pow:
	mv 	a2, a0 		# Saves a0 in a2
	li 	a0, 1 		# Sets a0 to 1
1:
	beqz 	a1, 1f 		# If a1 = 0 then done
	mul 	a0, a0, a2 		# Else, multiply
	addi 	a1, a1, -1 		# Decrements the counter
	j 	1b 			# Repeat
1:
	ret
*/



