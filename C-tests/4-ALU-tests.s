	.file	"4-ALU-tests.c"
	.option nopic
	.attribute arch, "rv32i2p0_m2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	and
	.type	and, @function
and:
	and	a0,a0,a1
	ret
	.size	and, .-and
	.align	2
	.globl	or
	.type	or, @function
or:
	or	a0,a0,a1
	ret
	.size	or, .-or
	.align	2
	.globl	xor
	.type	xor, @function
xor:
	xor	a0,a0,a1
	ret
	.size	xor, .-xor
	.align	2
	.globl	comp
	.type	comp, @function
comp:
	not	a0,a0
	ret
	.size	comp, .-comp
	.align	2
	.globl	not
	.type	not, @function
not:
	seqz	a0,a0
	ret
	.size	not, .-not
	.align	2
	.globl	shl
	.type	shl, @function
shl:
	slli	a0,a0,1
	ret
	.size	shl, .-shl
	.align	2
	.globl	shr
	.type	shr, @function
shr:
	srai	a0,a0,1
	ret
	.size	shr, .-shr
	.align	2
	.globl	add
	.type	add, @function
add:
	add	a0,a0,a1
	ret
	.size	add, .-add
	.align	2
	.globl	sub
	.type	sub, @function
sub:
	sub	a0,a0,a1
	ret
	.size	sub, .-sub
	.section	.text.startup,"ax",@progbits
	.align	2
	.globl	main
	.type	main, @function
main:
	lui	a5,%hi(TX)
	lw	a2,%lo(TX)(a5)
	li	a3,42
	li	a4,10
	sb	a3,0(a2)
	lw	a2,%lo(TX)(a5)
	sb	a4,0(a2)
	lw	a2,%lo(TX)(a5)
	sb	a3,0(a2)
	lw	a2,%lo(TX)(a5)
	sb	a4,0(a2)
	lw	a2,%lo(TX)(a5)
	sb	a3,0(a2)
	lw	a2,%lo(TX)(a5)
	sb	a4,0(a2)
	lw	a2,%lo(TX)(a5)
	sb	a3,0(a2)
	lw	a2,%lo(TX)(a5)
	sb	a4,0(a2)
	lw	a2,%lo(TX)(a5)
	sb	a3,0(a2)
	lw	a2,%lo(TX)(a5)
	sb	a4,0(a2)
	lw	a2,%lo(TX)(a5)
	sb	a3,0(a2)
	lw	a2,%lo(TX)(a5)
	sb	a4,0(a2)
	lw	a2,%lo(TX)(a5)
	sb	a3,0(a2)
	lw	a2,%lo(TX)(a5)
	sb	a4,0(a2)
	lw	a2,%lo(TX)(a5)
	sb	a3,0(a2)
	lw	a2,%lo(TX)(a5)
	sb	a4,0(a2)
	lw	a2,%lo(TX)(a5)
	sb	a3,0(a2)
	lw	a5,%lo(TX)(a5)
	sb	a4,0(a5)
 #APP
# 64 "4-ALU-tests.c" 1
	ebreak
# 0 "" 2
 #NO_APP
	li	a0,0
	ret
	.size	main, .-main
	.globl	TX
	.section	.sdata,"aw"
	.align	2
	.type	TX, @object
	.size	TX, 4
TX:
	.word	234881024
	.ident	"GCC: (GNU) 11.1.0"
