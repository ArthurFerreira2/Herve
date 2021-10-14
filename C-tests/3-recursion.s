	.file	"3-recursion.c"
	.option nopic
	.attribute arch, "rv32i2p0_m2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.type	printInt.part.0, @function
printInt.part.0:
	lui	a3,%hi(TX)
	beq	a0,zero,.L19
	li	a5,9
	ble	a0,a5,.L3
	addi	sp,sp,-16
	addi	a2,sp,12
	li	a1,4
	li	a3,9
.L9:
	mv	a5,a0
.L4:
	addi	a5,a5,-10
	bgt	a5,a3,.L4
	addi	a5,a5,48
	mv	a4,a0
	sb	a5,0(a2)
	li	a0,0
.L8:
	addi	a4,a4,-10
	addi	a0,a0,1
	bgt	a4,a3,.L8
	addi	a4,a1,-1
	addi	a2,a2,-1
	ble	a0,a3,.L23
	mv	a1,a4
	j	.L9
.L23:
	lui	a3,%hi(TX)
	lw	a2,%lo(TX)(a3)
	addi	a5,a0,48
	addi	a4,a4,16
	andi	a5,a5,0xff
	add	a4,a4,sp
	sb	a5,0(a2)
	sb	a5,-8(a4)
	addi	a5,a1,16
	add	a5,a5,sp
	lbu	a0,-8(a5)
	lw	a2,%lo(TX)(a3)
	addi	a5,a1,1
	li	a4,5
	sb	a0,0(a2)
	beq	a5,a4,.L6
	addi	a5,a5,16
	add	a5,a5,sp
	lw	a2,%lo(TX)(a3)
	lbu	a5,-8(a5)
	addi	a1,a1,2
	sb	a5,0(a2)
	beq	a1,a4,.L6
	addi	a5,a1,16
	add	a5,a5,sp
	lbu	a2,-8(a5)
	lw	a4,%lo(TX)(a3)
	li	a5,3
	sb	a2,0(a4)
	bne	a1,a5,.L6
	lw	a5,%lo(TX)(a3)
	lbu	a4,12(sp)
	sb	a4,0(a5)
.L6:
	lw	a5,%lo(TX)(a3)
	li	a4,10
	sb	a4,0(a5)
	addi	sp,sp,16
	jr	ra
.L3:
	lui	a3,%hi(TX)
	lw	a5,%lo(TX)(a3)
	addi	a0,a0,48
	sb	a0,0(a5)
.L19:
	lw	a5,%lo(TX)(a3)
	li	a4,10
	sb	a4,0(a5)
	ret
	.size	printInt.part.0, .-printInt.part.0
	.align	2
	.globl	asciiOfNum
	.type	asciiOfNum, @function
asciiOfNum:
	addi	a0,a0,48
	andi	a0,a0,0xff
	ret
	.size	asciiOfNum, .-asciiOfNum
	.align	2
	.globl	mod
	.type	mod, @function
mod:
	bgt	a1,a0,.L30
.L27:
	sub	a0,a0,a1
	ble	a1,a0,.L27
.L30:
	ret
	.size	mod, .-mod
	.align	2
	.globl	div
	.type	div, @function
div:
	mv	a5,a0
	li	a0,0
	beq	a1,zero,.L34
	bgt	a1,a5,.L35
.L33:
	sub	a5,a5,a1
	addi	a0,a0,1
	ble	a1,a5,.L33
	ret
.L34:
	ret
.L35:
	ret
	.size	div, .-div
	.align	2
	.globl	mult
	.type	mult, @function
mult:
	beq	a0,zero,.L40
	beq	a1,zero,.L40
	blt	a0,a1,.L42
.L39:
	li	a5,1
	beq	a1,a5,.L37
	addi	a1,a1,-2
	mul	a1,a1,a0
	slli	a0,a0,1
	add	a0,a1,a0
	ret
.L40:
	li	a0,0
.L37:
	ret
.L42:
	mv	a5,a0
	mv	a0,a1
	mv	a1,a5
	j	.L39
	.size	mult, .-mult
	.align	2
	.globl	fact
	.type	fact, @function
fact:
	li	a5,1
	bgt	a0,a5,.L71
	li	a0,1
	ret
.L71:
	addi	sp,sp,-32
	sw	s0,24(sp)
	sw	s1,20(sp)
	sw	ra,28(sp)
	addi	s1,a0,-1
	sw	s2,16(sp)
	sw	s3,12(sp)
	mv	s0,a0
	li	a0,2
	bne	s1,a5,.L72
.L43:
	lw	ra,28(sp)
	lw	s0,24(sp)
	lw	s1,20(sp)
	lw	s2,16(sp)
	lw	s3,12(sp)
	addi	sp,sp,32
	jr	ra
.L72:
	addi	s2,s0,-2
	bne	s2,a5,.L73
.L45:
	addi	s1,s1,-1
	mv	a0,s0
	beq	s1,zero,.L43
.L50:
	addi	s1,s1,-1
	mul	s1,s1,a0
	lw	ra,28(sp)
	lw	s0,24(sp)
	slli	a0,a0,1
	lw	s2,16(sp)
	lw	s3,12(sp)
	add	a0,s1,a0
	lw	s1,20(sp)
	addi	sp,sp,32
	jr	ra
.L73:
	addi	s3,s0,-3
	mv	a0,s3
	call	fact
	beq	a0,zero,.L43
	blt	s2,a0,.L46
	addi	s3,a0,-1
	beq	s3,zero,.L47
	mv	a0,s2
.L46:
	addi	s3,s3,-1
	mul	s3,s3,a0
	slli	a0,a0,1
	add	a0,a0,s3
	beq	a0,zero,.L43
	bge	s1,a0,.L74
.L48:
	addi	s2,s2,-1
	mul	s2,s2,a0
	slli	a0,a0,1
	add	a0,s2,a0
	beq	a0,zero,.L43
.L49:
	blt	s0,a0,.L50
	mv	s1,a0
	j	.L45
.L74:
	mv	s2,a0
.L47:
	addi	s2,s2,-1
	mv	a0,s1
	bne	s2,zero,.L48
	j	.L49
	.size	fact, .-fact
	.align	2
	.globl	printInt
	.type	printInt, @function
printInt:
	li	a5,98304
	addi	a4,a0,-1
	addi	a5,a5,1694
	bgtu	a4,a5,.L92
	li	a5,9
	ble	a0,a5,.L77
	addi	sp,sp,-16
	addi	a2,sp,12
	li	a1,4
	li	a3,9
.L83:
	mv	a5,a0
.L78:
	addi	a5,a5,-10
	bgt	a5,a3,.L78
	addi	a5,a5,48
	mv	a4,a0
	sb	a5,0(a2)
	li	a0,0
.L82:
	addi	a4,a4,-10
	addi	a0,a0,1
	bgt	a4,a3,.L82
	addi	a4,a1,-1
	addi	a2,a2,-1
	ble	a0,a3,.L96
	mv	a1,a4
	j	.L83
.L96:
	lui	a3,%hi(TX)
	lw	a2,%lo(TX)(a3)
	addi	a5,a0,48
	addi	a4,a4,16
	andi	a5,a5,0xff
	add	a4,a4,sp
	sb	a5,0(a2)
	sb	a5,-8(a4)
	addi	a5,a1,16
	add	a5,a5,sp
	lbu	a0,-8(a5)
	lw	a2,%lo(TX)(a3)
	addi	a5,a1,1
	li	a4,5
	sb	a0,0(a2)
	beq	a5,a4,.L80
	addi	a5,a5,16
	add	a5,a5,sp
	lw	a2,%lo(TX)(a3)
	lbu	a5,-8(a5)
	addi	a1,a1,2
	sb	a5,0(a2)
	beq	a1,a4,.L80
	addi	a5,a1,16
	add	a5,a5,sp
	lbu	a2,-8(a5)
	lw	a4,%lo(TX)(a3)
	li	a5,3
	sb	a2,0(a4)
	bne	a1,a5,.L80
	lw	a5,%lo(TX)(a3)
	lbu	a4,12(sp)
	sb	a4,0(a5)
.L80:
	lw	a5,%lo(TX)(a3)
	li	a4,10
	sb	a4,0(a5)
	addi	sp,sp,16
	jr	ra
.L77:
	lui	a3,%hi(TX)
	lw	a5,%lo(TX)(a3)
	addi	a0,a0,48
	li	a4,10
	sb	a0,0(a5)
	lw	a5,%lo(TX)(a3)
	sb	a4,0(a5)
.L92:
	ret
	.size	printInt, .-printInt
	.align	2
	.globl	printStr
	.type	printStr, @function
printStr:
	lbu	a5,0(a0)
	beq	a5,zero,.L97
	lui	a3,%hi(TX)
.L99:
	lw	a4,%lo(TX)(a3)
	addi	a0,a0,1
	sb	a5,0(a4)
	lbu	a5,0(a0)
	bne	a5,zero,.L99
.L97:
	ret
	.size	printStr, .-printStr
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align	2
.LC0:
	.string	"let's print some interger values !\n"
	.section	.text.startup,"ax",@progbits
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-16
	lui	a5,%hi(.LC0)
	sw	ra,12(sp)
	addi	a5,a5,%lo(.LC0)
	li	a4,108
	lui	a2,%hi(TX)
.L105:
	lw	a3,%lo(TX)(a2)
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L105
	li	a0,1972
	call	printInt.part.0
	li	a0,63
	call	printInt.part.0
	li	a0,5
	call	fact
	beq	a0,zero,.L106
	li	a5,6
	bgt	a0,a5,.L117
	addi	a5,a0,-1
	li	a0,6
	beq	a5,zero,.L118
.L108:
	addi	a5,a5,1
	mul	a0,a5,a0
	li	a4,7
	li	a5,98304
	addi	a5,a5,1694
	mul	a0,a0,a4
	addi	a4,a0,-1
	bgtu	a4,a5,.L106
.L109:
	call	printInt.part.0
.L106:
 #APP
# 92 "3-recursion.c" 1
	ebreak
# 0 "" 2
 #NO_APP
	lw	ra,12(sp)
	li	a0,0
	addi	sp,sp,16
	jr	ra
.L117:
	li	a5,5
	j	.L108
.L118:
	li	a0,42
	j	.L109
	.size	main, .-main
	.globl	TX
	.section	.sdata,"aw"
	.align	2
	.type	TX, @object
	.size	TX, 4
TX:
	.word	234881024
	.ident	"GCC: (GNU) 11.1.0"
