        .global start
start:
        addi    x1, x0, 1	# x1 = 1
loop:
        addi    x2, x1, 1
        addi    x3, x2, 1
        addi    x4, x3, 1
        addi    x5, x4, 1
        addi    x6, x5, 1
        addi    x7, x6, 1
        addi    x8, x7, 1
        addi    x9, x8, 1
        addi    x10, x9, 1
        addi    x11, x10, 1
        addi    x12, x11, 1
        addi    x13, x12, 1
        addi    x14, x13, 1
        addi    x15, x14, 1
        addi    x16, x15, 1
        addi    x17, x16, 1
        addi    x18, x17, 1
        addi    x19, x18, 1
        addi    x20, x19, 1
        addi    x21, x20, 1
        addi    x22, x21, 1
        addi    x23, x22, 1
        addi    x24, x23, 1
        addi    x25, x24, 1
        addi    x26, x25, 1
        addi    x27, x26, 1
        addi    x28, x27, 1
        addi    x29, x28, 1
        addi    x30, x29, 1
        addi    x31, x30, 1
        # addi    x1, x1, 1	# increment x1
	slli    x1, x1, 1	# x1 <<= 1 or x1 *=2
        beq	x1, x0, end	# we shifted 32 times and x1 is now equal to 0
	jal     x0, loop  	# we give x0 as return address to not change x[1..31] values
end:	ebreak
