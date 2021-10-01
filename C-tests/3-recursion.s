	.file	"3-recursion.c"
	.option nopic
	.attribute arch, "rv32i2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.globl	TX
	.section	.sdata,"aw"
	.align	2
	.type	TX, @object
	.size	TX, 4
TX:
	.word	234881024
	.text
	.align	2
	.globl	asciiOfNum
	.type	asciiOfNum, @function
asciiOfNum:
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
	.size	asciiOfNum, .-asciiOfNum
	.align	2
	.globl	mod
	.type	mod, @function
mod:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	sw	a1,-24(s0)
	j	.L4
.L5:
	lw	a4,-20(s0)
	lw	a5,-24(s0)
	sub	a5,a4,a5
	sw	a5,-20(s0)
.L4:
	lw	a4,-20(s0)
	lw	a5,-24(s0)
	bge	a4,a5,.L5
	lw	a5,-20(s0)
	mv	a0,a5
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	mod, .-mod
	.align	2
	.globl	div
	.type	div, @function
div:
	addi	sp,sp,-48
	sw	s0,44(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	lw	a5,-40(s0)
	bne	a5,zero,.L8
	li	a5,0
	j	.L9
.L8:
	sw	zero,-20(s0)
	j	.L10
.L11:
	lw	a4,-36(s0)
	lw	a5,-40(s0)
	sub	a5,a4,a5
	sw	a5,-36(s0)
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L10:
	lw	a4,-36(s0)
	lw	a5,-40(s0)
	bge	a4,a5,.L11
	lw	a5,-20(s0)
.L9:
	mv	a0,a5
	lw	s0,44(sp)
	addi	sp,sp,48
	jr	ra
	.size	div, .-div
	.align	2
	.globl	mult
	.type	mult, @function
mult:
	addi	sp,sp,-48
	sw	s0,44(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	lw	a5,-36(s0)
	seqz	a5,a5
	andi	a4,a5,0xff
	lw	a5,-40(s0)
	seqz	a5,a5
	andi	a5,a5,0xff
	or	a5,a4,a5
	andi	a5,a5,0xff
	beq	a5,zero,.L13
	li	a5,0
	j	.L14
.L13:
	lw	a4,-36(s0)
	lw	a5,-40(s0)
	bge	a4,a5,.L15
	lw	a4,-36(s0)
	lw	a5,-40(s0)
	xor	a5,a4,a5
	sw	a5,-36(s0)
	lw	a4,-40(s0)
	lw	a5,-36(s0)
	xor	a5,a4,a5
	sw	a5,-40(s0)
	lw	a4,-36(s0)
	lw	a5,-40(s0)
	xor	a5,a4,a5
	sw	a5,-36(s0)
.L15:
	lw	a5,-36(s0)
	sw	a5,-20(s0)
	j	.L16
.L17:
	lw	a4,-20(s0)
	lw	a5,-36(s0)
	add	a5,a4,a5
	sw	a5,-20(s0)
.L16:
	lw	a5,-40(s0)
	addi	a5,a5,-1
	sw	a5,-40(s0)
	lw	a5,-40(s0)
	bne	a5,zero,.L17
	lw	a5,-20(s0)
.L14:
	mv	a0,a5
	lw	s0,44(sp)
	addi	sp,sp,48
	jr	ra
	.size	mult, .-mult
	.align	2
	.globl	fact
	.type	fact, @function
fact:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	lw	a4,-20(s0)
	li	a5,1
	bgt	a4,a5,.L19
	li	a5,1
	j	.L20
.L19:
	lw	a5,-20(s0)
	addi	a5,a5,-1
	mv	a0,a5
	call	fact
	mv	a5,a0
	mv	a1,a5
	lw	a0,-20(s0)
	call	mult
	mv	a5,a0
.L20:
	mv	a0,a5
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	fact, .-fact
	.align	2
	.globl	printInt
	.type	printInt, @function
printInt:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	lw	a5,-36(s0)
	ble	a5,zero,.L29
	lw	a4,-36(s0)
	li	a5,98304
	addi	a5,a5,1695
	bgt	a4,a5,.L29
	li	a5,5
	sw	a5,-20(s0)
	j	.L25
.L26:
	lw	a5,-20(s0)
	addi	a5,a5,-1
	sw	a5,-20(s0)
	li	a1,10
	lw	a0,-36(s0)
	call	mod
	sw	a0,-24(s0)
	lw	a0,-24(s0)
	call	asciiOfNum
	mv	a5,a0
	mv	a4,a5
	lw	a5,-20(s0)
	addi	a5,a5,-16
	add	a5,a5,s0
	sb	a4,-16(a5)
	li	a1,10
	lw	a0,-36(s0)
	call	div
	sw	a0,-36(s0)
.L25:
	lw	a5,-36(s0)
	bgt	a5,zero,.L26
	j	.L27
.L28:
	lui	a5,%hi(TX)
	lw	a5,%lo(TX)(a5)
	lw	a4,-20(s0)
	addi	a4,a4,-16
	add	a4,a4,s0
	lbu	a4,-16(a4)
	sb	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L27:
	lw	a4,-20(s0)
	li	a5,4
	ble	a4,a5,.L28
	lui	a5,%hi(TX)
	lw	a5,%lo(TX)(a5)
	li	a4,10
	sb	a4,0(a5)
	j	.L21
.L29:
	nop
.L21:
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	printInt, .-printInt
	.align	2
	.globl	printStr
	.type	printStr, @function
printStr:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	j	.L31
.L32:
	lui	a5,%hi(TX)
	lw	a5,%lo(TX)(a5)
	lw	a4,-20(s0)
	lbu	a4,0(a4)
	sb	a4,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L31:
	lw	a5,-20(s0)
	lbu	a5,0(a5)
	bne	a5,zero,.L32
	nop
	nop
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	printStr, .-printStr
	.section	.rodata
	.align	2
.LC0:
	.string	"let's print some interger values !\n"
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-16
	sw	ra,12(sp)
	sw	s0,8(sp)
	addi	s0,sp,16
	lui	a5,%hi(.LC0)
	addi	a0,a5,%lo(.LC0)
	call	printStr
	li	a0,1972
	call	printInt
	li	a1,7
	li	a0,9
	call	mult
	mv	a5,a0
	mv	a0,a5
	call	printInt
	li	a0,7
	call	fact
	mv	a5,a0
	mv	a0,a5
	call	printInt
 #APP
# 92 "3-recursion.c" 1
	ebreak
# 0 "" 2
 #NO_APP
	li	a5,0
	mv	a0,a5
	lw	ra,12(sp)
	lw	s0,8(sp)
	addi	sp,sp,16
	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU) 11.1.0"
