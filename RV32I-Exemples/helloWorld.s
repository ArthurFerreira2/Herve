.section .text, "ax", @progbits
.global boot
.type boot, @function
boot:

	lui	t0, 0xFFFF 	# memory mapped putchar

	andi	t1, t1, 0
	addi	t1, t1, 72
	sw	t1, 0(t0)

	andi	t1, t1, 0
	addi	t1, t1, 101
	sw	t1, 0(t0)

	andi	t1, t1, 0
	addi	t1, t1, 108
	sw	t1, 0(t0)

	andi	t1, t1, 0
	addi	t1, t1, 108
	sw	t1, 0(t0)

	andi	t1, t1, 0
	addi	t1, t1, 111
	sw	t1, 0(t0)

	andi	t1, t1, 0
	addi	t1, t1, 10
	sw	t1, 0(t0)

finish:
	beq	t1, t1, finish
