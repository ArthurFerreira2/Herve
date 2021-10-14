	.file	"1-function.c"
	.option nopic
	.attribute arch, "rv32i2p0_m2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	_start
	.type	_start, @function
_start:
	li	a5,234881024
	li	a4,10
	sb	a4,0(a5)
	ret
	.size	_start, .-_start
	.align	2
	.globl	digit
	.type	digit, @function
digit:
	addi	a0,a0,48
	andi	a0,a0,0xff
	ret
	.size	digit, .-digit
	.ident	"GCC: (GNU) 11.1.0"
