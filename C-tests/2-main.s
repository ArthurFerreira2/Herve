	.file	"2-main.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align	2
.LC0:
	.string	"Hello World !\n"
	.section	.text.startup,"ax",@progbits
	.align	2
	.globl	main
	.type	main, @function
main:
	lui	a5,%hi(.LC0)
	addi	a5,a5,%lo(.LC0)
	li	a4,72
	li	a3,234881024
.L2:
	sb	a4,0(a3)
	lbu	a4,1(a5)
	addi	a5,a5,1
	bne	a4,zero,.L2
	li	a0,0
	ret
	.size	main, .-main
	.ident	"GCC: (GNU) 11.1.0"
