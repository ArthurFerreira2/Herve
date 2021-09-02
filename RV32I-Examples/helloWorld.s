.section .text

.global boot
.type boot, @function
boot:

	lui	t0, 0xFFFC 	# memory mapped io : putchar

	addi	t1, x0, 72
	sw	t1, 0(t0)

	addi	t1, x0, 101
	sw	t1, 0(t0)

	addi	t1, x0, 108
	sw	t1, 0(t0)

	addi	t1, x0, 108
	sw	t1, 0(t0)

	addi	t1, x0, 111
	sw	t1, 0(t0)

	addi	t1, x0, 10
	sw	t1, 0(t0)

finish:
	beq	t1, t1, finish
