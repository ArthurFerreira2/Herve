.section .text

.global boot
.type boot, @function
boot:

	lui	t0, 0xE000 	# memory mapped io : putchar

	addi	t1, x0, 0x48	# H
	sw	t1, 0(t0)

	addi	t1, x0, 0x65	# e
	sw	t1, 0(t0)

	addi	t1, x0, 0x6C	# l
	sw	t1, 0(t0)

	addi	t1, x0, 0x6C	# l
	sw	t1, 0(t0)

	addi	t1, x0, 0x6F	# o
	sw	t1, 0(t0)

	addi	t1, x0, 0x0A	# Line Feed
	sw	t1, 0(t0)

finish:
	beq	t1, t1, finish
