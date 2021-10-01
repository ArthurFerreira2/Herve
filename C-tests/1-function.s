	.file	"1-function.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	_start
	.type	_start, @function
_start:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	li	a5,234881024
	sw	a5,-20(s0)
	li	a0,4
	call	digit
	mv	a5,a0
	mv	a4,a5
	lw	a5,-20(s0)
	sb	a4,0(a5)
	li	a0,2
	call	digit
	mv	a5,a0
	mv	a4,a5
	lw	a5,-20(s0)
	sb	a4,0(a5)
	lw	a5,-20(s0)
	li	a4,10
	sb	a4,0(a5)
	nop
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	_start, .-_start
	.align	2
	.globl	digit
	.type	digit, @function
digit:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	lw	a5,-20(s0)
	andi	a5,a5,0xff
	addi	a5,a5,48
	andi	a5,a5,0xff
	mv	a0,a5
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	digit, .-digit
	.ident	"GCC: (GNU) 11.1.0"
