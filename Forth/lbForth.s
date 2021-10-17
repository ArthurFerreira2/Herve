	.file	"lbForth.c"
	.option nopic
	.attribute arch, "rv32i2p0_m2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	bye
	.type	bye, @function
bye:
	lui	a5,%hi(exitReq)
	li	a4,1
	sw	a4,%lo(exitReq)(a5)
	ret
	.size	bye, .-bye
	.align	2
	.globl	gotoInterpreter
	.type	gotoInterpreter, @function
gotoInterpreter:
	lui	a5,%hi(state)
	lw	a5,%lo(state)(a5)
	sw	zero,0(a5)
	ret
	.size	gotoInterpreter, .-gotoInterpreter
	.align	2
	.globl	gotoCompiler
	.type	gotoCompiler, @function
gotoCompiler:
	lui	a5,%hi(state)
	lw	a5,%lo(state)(a5)
	li	a4,1
	sw	a4,0(a5)
	ret
	.size	gotoCompiler, .-gotoCompiler
	.align	2
	.globl	hide
	.type	hide, @function
hide:
	lui	a5,%hi(latest)
	lw	a4,%lo(latest)(a5)
	lui	a5,%hi(memory)
	addi	a5,a5,%lo(memory)
	lw	a4,0(a4)
	addi	a4,a4,4
	add	a5,a5,a4
	lbu	a4,0(a5)
	xori	a4,a4,64
	sb	a4,0(a5)
	ret
	.size	hide, .-hide
	.align	2
	.globl	toggleImmediate
	.type	toggleImmediate, @function
toggleImmediate:
	lui	a5,%hi(latest)
	lw	a4,%lo(latest)(a5)
	lui	a5,%hi(memory)
	addi	a5,a5,%lo(memory)
	lw	a4,0(a4)
	addi	a4,a4,4
	add	a5,a5,a4
	lbu	a4,0(a5)
	xori	a4,a4,-128
	sb	a4,0(a5)
	ret
	.size	toggleImmediate, .-toggleImmediate
	.align	2
	.type	parseNumber.part.0.constprop.0, @function
parseNumber.part.0.constprop.0:
	lbu	a5,0(a0)
	li	a6,45
	beq	a5,a6,.L30
	li	a6,43
	beq	a5,a6,.L31
	beq	a1,zero,.L13
	li	t2,0
.L9:
	li	a7,0
	li	t3,46
	li	t4,9
	lui	t5,%hi(base)
	li	t6,25
	li	t0,1
	j	.L20
.L14:
	addi	a6,a5,-48
	andi	t1,a6,0xff
	bleu	t1,t4,.L17
	addi	a6,a5,-65
	andi	a6,a6,0xff
	bgtu	a6,t6,.L18
	addi	a6,a5,-55
.L17:
	lw	a5,%lo(base)(t5)
	lw	a5,0(a5)
	bleu	a5,a6,.L19
	lw	t1,0(a2)
	addi	a7,a7,1
	mul	a5,a5,t1
	add	a5,a5,a6
	sw	a5,0(a2)
	bgeu	a7,a1,.L19
.L20:
	add	a5,a0,a7
	lbu	a5,0(a5)
	bne	a5,t3,.L14
	sb	t0,0(a4)
	addi	a7,a7,1
	bltu	a7,a1,.L20
.L19:
	sub	a1,a1,a7
	sw	a1,0(a3)
	beq	t2,zero,.L7
.L10:
	lw	a5,0(a2)
	neg	a5,a5
	sw	a5,0(a2)
.L7:
	ret
.L31:
	addi	a1,a1,-1
	addi	a0,a0,1
	li	t2,0
	bne	a1,zero,.L9
.L13:
	sw	zero,0(a3)
	ret
.L18:
	addi	a6,a5,-97
	andi	a6,a6,0xff
	bgtu	a6,t6,.L19
	addi	a6,a5,-87
	j	.L17
.L30:
	addi	a1,a1,-1
	addi	a0,a0,1
	li	t2,1
	bne	a1,zero,.L9
	sw	zero,0(a3)
	j	.L10
	.size	parseNumber.part.0.constprop.0, .-parseNumber.part.0.constprop.0
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align	2
.LC0:
	.string	"Internal error in readMem: Invalid addres\n"
	.text
	.align	2
	.globl	branch
	.type	branch, @function
branch:
	lui	a3,%hi(next)
	lw	a5,%lo(next)(a3)
	li	a4,65536
	bgtu	a5,a4,.L37
	lui	a4,%hi(memory)
	addi	a4,a4,%lo(memory)
	add	a4,a5,a4
	lw	a4,0(a4)
	add	a5,a5,a4
	sw	a5,%lo(next)(a3)
	ret
.L37:
	lui	a5,%hi(.LC0)
	li	a4,73
	addi	a5,a5,%lo(.LC0)
	li	a2,234881024
.L34:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L34
	lw	a5,%lo(next)(a3)
	lui	a4,%hi(errorFlag)
	li	a2,1
	sw	a2,%lo(errorFlag)(a4)
	sw	a5,%lo(next)(a3)
	ret
	.size	branch, .-branch
	.section	.rodata.str1.4
	.align	2
.LC1:
	.string	"? RStack overflow\n"
	.text
	.align	2
	.globl	docol
	.type	docol, @function
docol:
	lui	a5,%hi(rsp)
	lw	a4,%lo(rsp)(a5)
	lui	a2,%hi(lastIp)
	li	a3,63
	lw	a5,0(a4)
	lw	a2,%lo(lastIp)(a2)
	bgtu	a5,a3,.L43
	lui	a3,%hi(rstack)
	lw	a3,%lo(rstack)(a3)
	addi	a1,a5,1
	slli	a5,a5,2
	sw	a1,0(a4)
	add	a5,a3,a5
	sw	a2,0(a5)
	lui	a5,%hi(commandAddress)
	lw	a5,%lo(commandAddress)(a5)
	lui	a4,%hi(next)
	addi	a5,a5,4
	sw	a5,%lo(next)(a4)
	ret
.L43:
	lui	a5,%hi(.LC1)
	li	a4,63
	addi	a5,a5,%lo(.LC1)
	li	a3,234881024
.L40:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L40
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	lui	a5,%hi(commandAddress)
	lw	a5,%lo(commandAddress)(a5)
	lui	a4,%hi(next)
	addi	a5,a5,4
	sw	a5,%lo(next)(a4)
	ret
	.size	docol, .-docol
	.section	.rodata.str1.4
	.align	2
.LC2:
	.string	"? RStack underflow\n"
	.text
	.align	2
	.globl	doExit
	.type	doExit, @function
doExit:
	lui	a5,%hi(rsp)
	lw	a3,%lo(rsp)(a5)
	li	a4,1
	lw	a5,0(a3)
	beq	a5,a4,.L49
	lui	a4,%hi(rstack)
	lw	a4,%lo(rstack)(a4)
	addi	a5,a5,-1
	slli	a2,a5,2
	sw	a5,0(a3)
	add	a5,a4,a2
	lw	a4,0(a5)
	lui	a5,%hi(next)
	sw	a4,%lo(next)(a5)
	ret
.L49:
	lui	a5,%hi(.LC2)
	li	a4,63
	addi	a5,a5,%lo(.LC2)
	li	a3,234881024
.L46:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L46
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	li	a4,0
	lui	a5,%hi(next)
	sw	a4,%lo(next)(a5)
	ret
	.size	doExit, .-doExit
	.section	.rodata.str1.4
	.align	2
.LC3:
	.string	"? Stack overflow\n"
	.text
	.align	2
	.globl	doState
	.type	doState, @function
doState:
	lui	a5,%hi(sp)
	lw	a4,%lo(sp)(a5)
	li	a3,191
	lw	a5,0(a4)
	bgtu	a5,a3,.L55
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a2,a5,1
	slli	a5,a5,2
	sw	a2,0(a4)
	add	a5,a3,a5
	li	a4,44
	sw	a4,0(a5)
	ret
.L55:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L52:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L52
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
	.size	doState, .-doState
	.align	2
	.globl	doLatest
	.type	doLatest, @function
doLatest:
	lui	a5,%hi(sp)
	lw	a4,%lo(sp)(a5)
	li	a3,191
	lw	a5,0(a4)
	bgtu	a5,a3,.L61
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a2,a5,1
	slli	a5,a5,2
	sw	a2,0(a4)
	add	a5,a3,a5
	li	a4,32
	sw	a4,0(a5)
	ret
.L61:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L58:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L58
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
	.size	doLatest, .-doLatest
	.align	2
	.globl	doCellSize
	.type	doCellSize, @function
doCellSize:
	lui	a5,%hi(sp)
	lw	a4,%lo(sp)(a5)
	li	a3,191
	lw	a5,0(a4)
	bgtu	a5,a3,.L67
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a2,a5,1
	slli	a5,a5,2
	sw	a2,0(a4)
	add	a5,a3,a5
	li	a4,4
	sw	a4,0(a5)
	ret
.L67:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L64:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L64
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
	.size	doCellSize, .-doCellSize
	.align	2
	.globl	doBase
	.type	doBase, @function
doBase:
	lui	a5,%hi(sp)
	lw	a4,%lo(sp)(a5)
	li	a3,191
	lw	a5,0(a4)
	bgtu	a5,a3,.L73
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a2,a5,1
	slli	a5,a5,2
	sw	a2,0(a4)
	add	a5,a3,a5
	li	a4,40
	sw	a4,0(a5)
	ret
.L73:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L70:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L70
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
	.size	doBase, .-doBase
	.align	2
	.globl	s0_r
	.type	s0_r, @function
s0_r:
	lui	a5,%hi(sp)
	lw	a4,%lo(sp)(a5)
	li	a3,191
	lw	a5,0(a4)
	bgtu	a5,a3,.L79
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a2,a5,1
	slli	a5,a5,2
	sw	a2,0(a4)
	add	a5,a3,a5
	li	a4,52
	sw	a4,0(a5)
	ret
.L79:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L76:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L76
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
	.size	s0_r, .-s0_r
	.align	2
	.globl	doHere
	.type	doHere, @function
doHere:
	lui	a5,%hi(sp)
	lw	a4,%lo(sp)(a5)
	li	a3,191
	lw	a5,0(a4)
	bgtu	a5,a3,.L85
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a2,a5,1
	slli	a5,a5,2
	sw	a2,0(a4)
	add	a5,a3,a5
	li	a4,36
	sw	a4,0(a5)
	ret
.L85:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L82:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L82
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
	.size	doHere, .-doHere
	.section	.rodata.str1.4
	.align	2
.LC4:
	.string	"? Stack underflow\n"
	.text
	.align	2
	.globl	emit
	.type	emit, @function
emit:
	lui	a5,%hi(sp)
	lw	a3,%lo(sp)(a5)
	li	a4,1
	lw	a5,0(a3)
	beq	a5,a4,.L91
	lui	a4,%hi(stack)
	lw	a4,%lo(stack)(a4)
	addi	a5,a5,-1
	slli	a2,a5,2
	sw	a5,0(a3)
	add	a5,a4,a2
	lbu	a5,0(a5)
	li	a4,234881024
	sb	a5,0(a4)
	ret
.L91:
	lui	a4,%hi(.LC4)
	li	a5,63
	addi	a4,a4,%lo(.LC4)
	li	a3,234881024
.L88:
	addi	a4,a4,1
	sb	a5,0(a3)
	lbu	a5,0(a4)
	bne	a5,zero,.L88
	lui	a4,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a4)
	li	a4,234881024
	sb	a5,0(a4)
	ret
	.size	emit, .-emit
	.align	2
	.globl	doFree
	.type	doFree, @function
doFree:
	lui	a5,%hi(sp)
	lw	a4,%lo(sp)(a5)
	lui	a5,%hi(here)
	lw	a2,%lo(here)(a5)
	lw	a5,0(a4)
	li	a3,191
	lw	a2,0(a2)
	bgtu	a5,a3,.L97
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a1,a5,1
	sw	a1,0(a4)
	slli	a5,a5,2
	li	a4,65536
	add	a5,a3,a5
	sub	a4,a4,a2
	sw	a4,0(a5)
	ret
.L97:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L94:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L94
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
	.size	doFree, .-doFree
	.align	2
	.globl	drop
	.type	drop, @function
drop:
	lui	a5,%hi(sp)
	lw	a4,%lo(sp)(a5)
	li	a3,1
	lw	a5,0(a4)
	beq	a5,a3,.L103
	addi	a5,a5,-1
	sw	a5,0(a4)
	ret
.L103:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L100:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L100
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
	.size	drop, .-drop
	.align	2
	.globl	key_p
	.type	key_p, @function
key_p:
	lui	a5,%hi(sp)
	lw	a3,%lo(sp)(a5)
	lui	a4,%hi(positionInLineBuffer)
	lui	a1,%hi(charsInLineBuffer)
	lw	a5,0(a3)
	li	a2,191
	lw	a4,%lo(positionInLineBuffer)(a4)
	lw	a1,%lo(charsInLineBuffer)(a1)
	bgtu	a5,a2,.L109
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a0,a5,1
	slt	a4,a4,a1
	slli	a5,a5,2
	sw	a0,0(a3)
	add	a5,a2,a5
	neg	a4,a4
	sw	a4,0(a5)
	ret
.L109:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L106:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L106
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
	.size	key_p, .-key_p
	.align	2
	.globl	dsp_r
	.type	dsp_r, @function
dsp_r:
	lui	a5,%hi(sp)
	lw	a3,%lo(sp)(a5)
	li	a4,191
	lw	a5,0(a3)
	bgtu	a5,a4,.L115
	lui	a4,%hi(stack)
	lw	a2,%lo(stack)(a4)
	slli	a4,a5,2
	addi	a5,a5,1
	sw	a5,0(a3)
	add	a5,a2,a4
	addi	a4,a4,48
	sw	a4,0(a5)
	ret
.L115:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L112:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L112
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
	.size	dsp_r, .-dsp_r
	.align	2
	.globl	lit
	.type	lit, @function
lit:
	lui	a3,%hi(next)
	lw	a5,%lo(next)(a3)
	li	a4,65536
	bgtu	a5,a4,.L125
	lui	a4,%hi(memory)
	addi	a4,a4,%lo(memory)
	add	a5,a5,a4
	lw	a1,0(a5)
	lui	a5,%hi(sp)
	lw	a4,%lo(sp)(a5)
	li	a2,191
	lw	a5,0(a4)
	bgtu	a5,a2,.L126
.L120:
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a0,a5,1
	slli	a5,a5,2
	sw	a0,0(a4)
	add	a5,a2,a5
	sw	a1,0(a5)
	lw	a5,%lo(next)(a3)
	addi	a5,a5,4
	sw	a5,%lo(next)(a3)
	ret
.L125:
	lui	a5,%hi(.LC0)
	li	a4,73
	addi	a5,a5,%lo(.LC0)
	li	a2,234881024
.L118:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L118
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	lui	a5,%hi(sp)
	lw	a4,%lo(sp)(a5)
	li	a2,191
	li	a1,0
	lw	a5,0(a4)
	bleu	a5,a2,.L120
.L126:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a2,234881024
.L121:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L121
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	lw	a5,%lo(next)(a3)
	addi	a5,a5,4
	sw	a5,%lo(next)(a3)
	ret
	.size	lit, .-lit
	.align	2
	.globl	dup
	.type	dup, @function
dup:
	lui	a2,%hi(sp)
	lw	a3,%lo(sp)(a2)
	li	a4,1
	lw	a5,0(a3)
	beq	a5,a4,.L136
	lui	a4,%hi(stack)
	lw	a4,%lo(stack)(a4)
	slli	a2,a5,2
	add	a4,a4,a2
	lw	a2,-4(a4)
.L130:
	li	a4,191
	bgtu	a5,a4,.L137
	lui	a4,%hi(stack)
	lw	a4,%lo(stack)(a4)
	addi	a1,a5,1
	slli	a5,a5,2
	sw	a1,0(a3)
	add	a5,a4,a5
	sw	a2,0(a5)
	ret
.L137:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L132:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L132
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
.L136:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L129:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L129
	lw	a3,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	lw	a5,0(a3)
	li	a2,0
	j	.L130
	.size	dup, .-dup
	.align	2
	.globl	rtos
	.type	rtos, @function
rtos:
	lui	a5,%hi(rsp)
	lw	a3,%lo(rsp)(a5)
	li	a4,1
	lw	a5,0(a3)
	beq	a5,a4,.L147
	lui	a4,%hi(rstack)
	lw	a4,%lo(rstack)(a4)
	addi	a5,a5,-1
	slli	a2,a5,2
	sw	a5,0(a3)
	add	a5,a4,a2
	lw	a2,0(a5)
.L141:
	lui	a5,%hi(sp)
	lw	a4,%lo(sp)(a5)
	li	a3,191
	lw	a5,0(a4)
	bgtu	a5,a3,.L148
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a1,a5,1
	slli	a5,a5,2
	sw	a1,0(a4)
	add	a5,a3,a5
	sw	a2,0(a5)
	ret
.L148:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L143:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L143
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
.L147:
	lui	a5,%hi(.LC2)
	li	a4,63
	addi	a5,a5,%lo(.LC2)
	li	a3,234881024
.L140:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L140
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	li	a2,0
	j	.L141
	.size	rtos, .-rtos
	.align	2
	.globl	stor
	.type	stor, @function
stor:
	lui	a5,%hi(sp)
	lw	a3,%lo(sp)(a5)
	li	a4,1
	lw	a5,0(a3)
	beq	a5,a4,.L158
	lui	a4,%hi(stack)
	lw	a4,%lo(stack)(a4)
	addi	a5,a5,-1
	slli	a2,a5,2
	sw	a5,0(a3)
	add	a5,a4,a2
	lw	a2,0(a5)
.L152:
	lui	a5,%hi(rsp)
	lw	a4,%lo(rsp)(a5)
	li	a3,63
	lw	a5,0(a4)
	bgtu	a5,a3,.L159
	lui	a3,%hi(rstack)
	lw	a3,%lo(rstack)(a3)
	addi	a1,a5,1
	slli	a5,a5,2
	sw	a1,0(a4)
	add	a5,a3,a5
	sw	a2,0(a5)
	ret
.L159:
	lui	a5,%hi(.LC1)
	li	a4,63
	addi	a5,a5,%lo(.LC1)
	li	a3,234881024
.L154:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L154
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
.L158:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L151:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L151
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	li	a2,0
	j	.L152
	.size	stor, .-stor
	.align	2
	.globl	zbranch
	.type	zbranch, @function
zbranch:
	lui	a5,%hi(sp)
	lw	a3,%lo(sp)(a5)
	li	a4,1
	lw	a5,0(a3)
	beq	a5,a4,.L172
	lui	a4,%hi(stack)
	lw	a4,%lo(stack)(a4)
	addi	a5,a5,-1
	slli	a2,a5,2
	sw	a5,0(a3)
	add	a5,a4,a2
	lw	a5,0(a5)
	beq	a5,zero,.L163
	lui	a3,%hi(next)
	lw	a5,%lo(next)(a3)
	addi	a5,a5,4
	sw	a5,%lo(next)(a3)
	ret
.L172:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L162:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L162
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
.L163:
	lui	a3,%hi(next)
	lw	a5,%lo(next)(a3)
	li	a4,65536
	bgtu	a5,a4,.L173
	lui	a4,%hi(memory)
	addi	a4,a4,%lo(memory)
	add	a4,a5,a4
	lw	a4,0(a4)
	add	a5,a5,a4
	sw	a5,%lo(next)(a3)
	ret
.L173:
	lui	a5,%hi(.LC0)
	li	a4,73
	addi	a5,a5,%lo(.LC0)
	li	a2,234881024
.L166:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L166
	lw	a5,%lo(next)(a3)
	lui	a4,%hi(errorFlag)
	li	a2,1
	sw	a2,%lo(errorFlag)(a4)
	sw	a5,%lo(next)(a3)
	ret
	.size	zbranch, .-zbranch
	.align	2
	.globl	not
	.type	not, @function
not:
	lui	a3,%hi(sp)
	lw	a4,%lo(sp)(a3)
	li	a2,1
	lw	a5,0(a4)
	beq	a5,a2,.L183
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a2,a5,2
	sw	a5,0(a4)
	add	a3,a3,a2
	lw	a3,0(a3)
	not	a3,a3
.L177:
	li	a2,191
	bgtu	a5,a2,.L184
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a1,a5,1
	slli	a5,a5,2
	sw	a1,0(a4)
	add	a5,a2,a5
	sw	a3,0(a5)
	ret
.L184:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L179:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L179
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
.L183:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a2,234881024
.L176:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L176
	lw	a4,%lo(sp)(a3)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,-1
	j	.L177
	.size	not, .-not
	.align	2
	.globl	memWriteByte
	.type	memWriteByte, @function
memWriteByte:
	lui	a3,%hi(sp)
	lw	a4,%lo(sp)(a3)
	li	a2,1
	lw	a5,0(a4)
	beq	a5,a2,.L194
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a2,a5,2
	add	a3,a3,a2
	sw	a5,0(a4)
	lw	a2,0(a3)
	li	a3,1
	beq	a5,a3,.L195
.L189:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a1,a5,2
	sw	a5,0(a4)
	add	a5,a3,a1
	lbu	a5,0(a5)
	lui	a4,%hi(memory)
	addi	a4,a4,%lo(memory)
	add	a4,a4,a2
	sb	a5,0(a4)
	ret
.L194:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a2,234881024
.L187:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L187
	lw	a4,%lo(sp)(a3)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,1
	li	a2,0
	bne	a5,a3,.L189
.L195:
	lui	a4,%hi(.LC4)
	li	a5,63
	addi	a4,a4,%lo(.LC4)
	li	a3,234881024
.L190:
	addi	a4,a4,1
	sb	a5,0(a3)
	lbu	a5,0(a4)
	bne	a5,zero,.L190
	lui	a4,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a4)
	lui	a4,%hi(memory)
	addi	a4,a4,%lo(memory)
	add	a4,a4,a2
	sb	a5,0(a4)
	ret
	.size	memWriteByte, .-memWriteByte
	.align	2
	.globl	memReadByte
	.type	memReadByte, @function
memReadByte:
	lui	a2,%hi(sp)
	lw	a3,%lo(sp)(a2)
	li	a4,1
	lw	a5,0(a3)
	beq	a5,a4,.L205
	lui	a4,%hi(stack)
	lw	a4,%lo(stack)(a4)
	addi	a5,a5,-1
	slli	a2,a5,2
	sw	a5,0(a3)
	add	a4,a4,a2
	lw	a2,0(a4)
.L199:
	lui	a4,%hi(memory)
	addi	a4,a4,%lo(memory)
	add	a4,a4,a2
	li	a2,191
	lbu	a1,0(a4)
	bgtu	a5,a2,.L206
	lui	a4,%hi(stack)
	lw	a4,%lo(stack)(a4)
	addi	a2,a5,1
	slli	a5,a5,2
	sw	a2,0(a3)
	add	a5,a4,a5
	sw	a1,0(a5)
	ret
.L206:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L201:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L201
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
.L205:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L198:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L198
	lw	a3,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	lw	a5,0(a3)
	li	a2,0
	j	.L199
	.size	memReadByte, .-memReadByte
	.align	2
	.globl	memRead
	.type	memRead, @function
memRead:
	lui	a2,%hi(sp)
	lw	a4,%lo(sp)(a2)
	li	a3,1
	lw	a5,0(a4)
	beq	a5,a3,.L220
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a1,a5,2
	add	a3,a3,a1
	sw	a5,0(a4)
	lw	a3,0(a3)
	li	a1,65536
	bgtu	a3,a1,.L221
	lui	a2,%hi(memory)
	addi	a2,a2,%lo(memory)
	add	a3,a3,a2
.L210:
	lw	a2,0(a3)
	li	a3,191
	bgtu	a5,a3,.L222
.L214:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a1,a5,1
	slli	a5,a5,2
	sw	a1,0(a4)
	add	a5,a3,a5
	sw	a2,0(a5)
	ret
.L221:
	lui	a5,%hi(.LC0)
	li	a4,73
	addi	a5,a5,%lo(.LC0)
	li	a3,234881024
.L212:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L212
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,191
	li	a2,0
	bleu	a5,a3,.L214
.L222:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L215:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L215
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
.L220:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L209:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L209
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lui	a3,%hi(memory)
	lw	a5,0(a4)
	addi	a3,a3,%lo(memory)
	j	.L210
	.size	memRead, .-memRead
	.section	.rodata.str1.4
	.align	2
.LC5:
	.string	"Internal error in writeMem: Invalid address\n"
	.text
	.align	2
	.globl	memWrite
	.type	memWrite, @function
memWrite:
	lui	a3,%hi(sp)
	lw	a4,%lo(sp)(a3)
	li	a2,1
	lw	a5,0(a4)
	beq	a5,a2,.L236
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a2,a5,2
	sw	a5,0(a4)
	add	a3,a3,a2
	lw	a3,0(a3)
.L226:
	li	a2,1
	beq	a5,a2,.L237
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a5,a5,-1
	slli	a1,a5,2
	sw	a5,0(a4)
	add	a5,a2,a1
	lw	a4,0(a5)
.L229:
	li	a5,65536
	bgtu	a3,a5,.L238
	lui	a5,%hi(memory)
	addi	a5,a5,%lo(memory)
	add	a3,a3,a5
	sw	a4,0(a3)
	ret
.L238:
	lui	a5,%hi(.LC5)
	li	a4,73
	addi	a5,a5,%lo(.LC5)
	li	a3,234881024
.L231:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L231
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
.L237:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a2,234881024
.L228:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L228
	li	a4,1
	lui	a5,%hi(errorFlag)
	sw	a4,%lo(errorFlag)(a5)
	li	a4,0
	j	.L229
.L236:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a2,234881024
.L225:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L225
	lw	a4,%lo(sp)(a3)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,0
	j	.L226
	.size	memWrite, .-memWrite
	.align	2
	.globl	key
	.type	key, @function
key:
	lui	t3,%hi(positionInLineBuffer)
	lui	a6,%hi(charsInLineBuffer)
	lw	a5,%lo(positionInLineBuffer)(t3)
	lw	a4,%lo(charsInLineBuffer)(a6)
	blt	a5,a4,.L253
	lui	a5,%hi(.LANCHOR0)
	addi	a0,a5,%lo(.LANCHOR0)
	addi	t4,a5,%lo(.LANCHOR0)
	li	a1,1
	sw	zero,%lo(charsInLineBuffer)(a6)
	addi	a0,a0,128
	addi	a5,a5,%lo(.LANCHOR0)
	lui	a2,%hi(initscript_pos)
	li	t1,251658240
	sub	a1,a1,t4
	li	a7,10
	j	.L242
.L243:
	lbu	a4,0(t1)
	add	a3,a1,a5
	beq	a0,a5,.L245
.L252:
	sw	a3,%lo(charsInLineBuffer)(a6)
	sb	a4,0(a5)
	addi	a5,a5,1
	beq	a4,a7,.L245
.L242:
	lw	a4,%lo(initscript_pos)(a2)
	lbu	a3,0(a4)
	beq	a3,zero,.L243
	addi	a3,a4,1
	sw	a3,%lo(initscript_pos)(a2)
	lbu	a4,0(a4)
	add	a3,a1,a5
	bne	a0,a5,.L252
.L245:
	lbu	a2,0(t4)
	li	a5,1
	sw	a5,%lo(positionInLineBuffer)(t3)
.L241:
	lui	a5,%hi(sp)
	lw	a4,%lo(sp)(a5)
	li	a3,191
	lw	a5,0(a4)
	bgtu	a5,a3,.L254
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a1,a5,1
	slli	a5,a5,2
	sw	a1,0(a4)
	add	a5,a3,a5
	sw	a2,0(a5)
	ret
.L254:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L248:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L248
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
.L253:
	lui	a4,%hi(.LANCHOR0)
	addi	a4,a4,%lo(.LANCHOR0)
	addi	a3,a5,1
	add	a5,a4,a5
	lbu	a2,0(a5)
	sw	a3,%lo(positionInLineBuffer)(t3)
	j	.L241
	.size	key, .-key
	.align	2
	.globl	rget
	.type	rget, @function
rget:
	lui	a3,%hi(rsp)
	lw	a4,%lo(rsp)(a3)
	li	a2,1
	lw	a5,0(a4)
	beq	a5,a2,.L268
	lui	a3,%hi(rstack)
	lw	a3,%lo(rstack)(a3)
	addi	a5,a5,-1
	slli	a2,a5,2
	sw	a5,0(a4)
	add	a3,a3,a2
	lw	a2,0(a3)
.L258:
	li	a3,63
	bgtu	a5,a3,.L269
	lui	a3,%hi(rstack)
	lw	a3,%lo(rstack)(a3)
	addi	a1,a5,1
	slli	a5,a5,2
	sw	a1,0(a4)
	add	a5,a3,a5
	sw	a2,0(a5)
	lui	a5,%hi(sp)
	lw	a4,%lo(sp)(a5)
	li	a3,191
	lw	a5,0(a4)
	bgtu	a5,a3,.L270
.L262:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a1,a5,1
	slli	a5,a5,2
	sw	a1,0(a4)
	add	a5,a3,a5
	sw	a2,0(a5)
	ret
.L269:
	lui	a5,%hi(.LC1)
	li	a4,63
	addi	a5,a5,%lo(.LC1)
	li	a3,234881024
.L260:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L260
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	lui	a5,%hi(sp)
	lw	a4,%lo(sp)(a5)
	li	a3,191
	lw	a5,0(a4)
	bleu	a5,a3,.L262
.L270:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L263:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L263
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
.L268:
	lui	a5,%hi(.LC2)
	li	a4,63
	addi	a5,a5,%lo(.LC2)
	li	a2,234881024
.L257:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L257
	lw	a4,%lo(rsp)(a3)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a2,0
	j	.L258
	.size	rget, .-rget
	.align	2
	.globl	xor
	.type	xor, @function
xor:
	lui	a2,%hi(sp)
	lw	a4,%lo(sp)(a2)
	li	a3,1
	lw	a5,0(a4)
	beq	a5,a3,.L284
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a1,a5,2
	sw	a5,0(a4)
	add	a3,a3,a1
	lw	a3,0(a3)
.L274:
	li	a1,1
	beq	a5,a1,.L285
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a5,a5,-1
	slli	a1,a5,2
	sw	a5,0(a4)
	add	a2,a2,a1
	lw	a2,0(a2)
	xor	a3,a3,a2
.L277:
	li	a2,191
	bgtu	a5,a2,.L286
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a1,a5,1
	slli	a5,a5,2
	sw	a1,0(a4)
	add	a5,a2,a5
	sw	a3,0(a5)
	ret
.L286:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L279:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L279
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
.L285:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a1,234881024
.L276:
	addi	a5,a5,1
	sb	a4,0(a1)
	lbu	a4,0(a5)
	bne	a4,zero,.L276
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a2,1
	sw	a2,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	j	.L277
.L284:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L273:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L273
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,0
	j	.L274
	.size	xor, .-xor
	.align	2
	.globl	plus
	.type	plus, @function
plus:
	lui	a2,%hi(sp)
	lw	a4,%lo(sp)(a2)
	li	a3,1
	lw	a5,0(a4)
	beq	a5,a3,.L300
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a1,a5,2
	sw	a5,0(a4)
	add	a3,a3,a1
	lw	a3,0(a3)
	mv	a0,a3
.L290:
	li	a1,1
	beq	a5,a1,.L301
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a2,a5,2
	sw	a5,0(a4)
	add	a3,a3,a2
	lw	a3,0(a3)
	add	a3,a0,a3
.L293:
	li	a2,191
	bgtu	a5,a2,.L302
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a1,a5,1
	slli	a5,a5,2
	sw	a1,0(a4)
	add	a5,a2,a5
	sw	a3,0(a5)
	ret
.L302:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L295:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L295
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
.L301:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a1,234881024
.L292:
	addi	a5,a5,1
	sb	a4,0(a1)
	lbu	a4,0(a5)
	bne	a4,zero,.L292
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a2,1
	sw	a2,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	j	.L293
.L300:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L289:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L289
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a0,0
	li	a3,0
	j	.L290
	.size	plus, .-plus
	.align	2
	.globl	doOr
	.type	doOr, @function
doOr:
	lui	a2,%hi(sp)
	lw	a4,%lo(sp)(a2)
	li	a3,1
	lw	a5,0(a4)
	beq	a5,a3,.L316
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a1,a5,2
	sw	a5,0(a4)
	add	a3,a3,a1
	lw	a3,0(a3)
.L306:
	li	a1,1
	beq	a5,a1,.L317
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a5,a5,-1
	slli	a1,a5,2
	sw	a5,0(a4)
	add	a2,a2,a1
	lw	a2,0(a2)
	or	a3,a3,a2
.L309:
	li	a2,191
	bgtu	a5,a2,.L318
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a1,a5,1
	slli	a5,a5,2
	sw	a1,0(a4)
	add	a5,a2,a5
	sw	a3,0(a5)
	ret
.L318:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L311:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L311
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
.L317:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a1,234881024
.L308:
	addi	a5,a5,1
	sb	a4,0(a1)
	lbu	a4,0(a5)
	bne	a4,zero,.L308
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a2,1
	sw	a2,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	j	.L309
.L316:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L305:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L305
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,0
	j	.L306
	.size	doOr, .-doOr
	.align	2
	.globl	minus
	.type	minus, @function
minus:
	lui	a2,%hi(sp)
	lw	a4,%lo(sp)(a2)
	li	a3,1
	lw	a5,0(a4)
	beq	a5,a3,.L332
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a1,a5,2
	sw	a5,0(a4)
	add	a3,a3,a1
	lw	a1,0(a3)
.L322:
	li	a3,1
	beq	a5,a3,.L333
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a2,a5,2
	sw	a5,0(a4)
	add	a3,a3,a2
	lw	a3,0(a3)
.L325:
	li	a2,191
	bgtu	a5,a2,.L334
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a0,a5,1
	slli	a5,a5,2
	sw	a0,0(a4)
	add	a5,a2,a5
	sub	a3,a3,a1
	sw	a3,0(a5)
	ret
.L334:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L327:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L327
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
.L333:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L324:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L324
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,0
	j	.L325
.L332:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L321:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L321
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a1,0
	j	.L322
	.size	minus, .-minus
	.align	2
	.globl	mul
	.type	mul, @function
mul:
	lui	a2,%hi(sp)
	lw	a4,%lo(sp)(a2)
	li	a3,1
	lw	a5,0(a4)
	beq	a5,a3,.L348
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a1,a5,2
	sw	a5,0(a4)
	add	a3,a3,a1
	lw	a3,0(a3)
.L338:
	li	a1,1
	beq	a5,a1,.L349
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a5,a5,-1
	slli	a1,a5,2
	sw	a5,0(a4)
	add	a2,a2,a1
	lw	a2,0(a2)
	mul	a3,a3,a2
.L341:
	li	a2,191
	bgtu	a5,a2,.L350
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a1,a5,1
	slli	a5,a5,2
	sw	a1,0(a4)
	add	a5,a2,a5
	sw	a3,0(a5)
	ret
.L350:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L343:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L343
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
.L349:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L340:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L340
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,0
	j	.L341
.L348:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L337:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L337
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,0
	j	.L338
	.size	mul, .-mul
	.align	2
	.globl	doAnd
	.type	doAnd, @function
doAnd:
	lui	a2,%hi(sp)
	lw	a4,%lo(sp)(a2)
	li	a3,1
	lw	a5,0(a4)
	beq	a5,a3,.L364
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a1,a5,2
	sw	a5,0(a4)
	add	a3,a3,a1
	lw	a3,0(a3)
.L354:
	li	a1,1
	beq	a5,a1,.L365
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a5,a5,-1
	slli	a1,a5,2
	sw	a5,0(a4)
	add	a2,a2,a1
	lw	a2,0(a2)
	and	a3,a3,a2
.L357:
	li	a2,191
	bgtu	a5,a2,.L366
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a1,a5,1
	slli	a5,a5,2
	sw	a1,0(a4)
	add	a5,a2,a5
	sw	a3,0(a5)
	ret
.L366:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L359:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L359
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
.L365:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L356:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L356
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,0
	j	.L357
.L364:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L353:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L353
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,0
	j	.L354
	.size	doAnd, .-doAnd
	.align	2
	.globl	larger
	.type	larger, @function
larger:
	lui	a2,%hi(sp)
	lw	a4,%lo(sp)(a2)
	li	a3,1
	lw	a5,0(a4)
	beq	a5,a3,.L380
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a1,a5,2
	sw	a5,0(a4)
	add	a3,a3,a1
	lw	a3,0(a3)
.L370:
	li	a1,1
	beq	a5,a1,.L381
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a5,a5,-1
	slli	a1,a5,2
	sw	a5,0(a4)
	add	a2,a2,a1
	lw	a1,0(a2)
.L373:
	li	a2,191
	bgtu	a5,a2,.L382
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a0,a5,1
	slt	a3,a3,a1
	slli	a5,a5,2
	sw	a0,0(a4)
	add	a5,a2,a5
	neg	a3,a3
	sw	a3,0(a5)
	ret
.L382:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L375:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L375
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
.L381:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a1,234881024
.L372:
	addi	a5,a5,1
	sb	a4,0(a1)
	lbu	a4,0(a5)
	bne	a4,zero,.L372
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a2,1
	sw	a2,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a1,0
	j	.L373
.L380:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L369:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L369
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,0
	j	.L370
	.size	larger, .-larger
	.align	2
	.globl	smaller
	.type	smaller, @function
smaller:
	lui	a2,%hi(sp)
	lw	a4,%lo(sp)(a2)
	li	a3,1
	lw	a5,0(a4)
	beq	a5,a3,.L396
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a1,a5,2
	sw	a5,0(a4)
	add	a3,a3,a1
	lw	a3,0(a3)
.L386:
	li	a1,1
	beq	a5,a1,.L397
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a5,a5,-1
	slli	a1,a5,2
	sw	a5,0(a4)
	add	a2,a2,a1
	lw	a1,0(a2)
.L389:
	li	a2,191
	bgtu	a5,a2,.L398
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a0,a5,1
	sgt	a3,a3,a1
	slli	a5,a5,2
	sw	a0,0(a4)
	add	a5,a2,a5
	neg	a3,a3
	sw	a3,0(a5)
	ret
.L398:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L391:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L391
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
.L397:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a1,234881024
.L388:
	addi	a5,a5,1
	sb	a4,0(a1)
	lbu	a4,0(a5)
	bne	a4,zero,.L388
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a2,1
	sw	a2,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a1,0
	j	.L389
.L396:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L385:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L385
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,0
	j	.L386
	.size	smaller, .-smaller
	.align	2
	.globl	equals
	.type	equals, @function
equals:
	lui	a2,%hi(sp)
	lw	a3,%lo(sp)(a2)
	li	a4,1
	lw	a5,0(a3)
	beq	a5,a4,.L412
	lui	a4,%hi(stack)
	lw	a4,%lo(stack)(a4)
	addi	a5,a5,-1
	slli	a1,a5,2
	sw	a5,0(a3)
	add	a4,a4,a1
	lw	a1,0(a4)
.L402:
	li	a4,1
	beq	a5,a4,.L413
	lui	a4,%hi(stack)
	lw	a4,%lo(stack)(a4)
	addi	a5,a5,-1
	slli	a2,a5,2
	sw	a5,0(a3)
	add	a4,a4,a2
	lw	a4,0(a4)
.L405:
	li	a2,191
	bgtu	a5,a2,.L414
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	sub	a4,a4,a1
	seqz	a4,a4
	addi	a1,a5,1
	slli	a5,a5,2
	sw	a1,0(a3)
	add	a5,a2,a5
	neg	a4,a4
	sw	a4,0(a5)
	ret
.L414:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L407:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L407
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
.L413:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L404:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L404
	lw	a3,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	lw	a5,0(a3)
	li	a4,0
	j	.L405
.L412:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L401:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L401
	lw	a3,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	lw	a5,0(a3)
	li	a1,0
	j	.L402
	.size	equals, .-equals
	.align	2
	.globl	litstring
	.type	litstring, @function
litstring:
	lui	a2,%hi(next)
	lw	a4,%lo(next)(a2)
	li	a5,65536
	bgtu	a4,a5,.L434
	lui	a5,%hi(memory)
	addi	a5,a5,%lo(memory)
	add	a5,a4,a5
	lw	a5,0(a5)
.L418:
	lui	a0,%hi(sp)
	lw	a3,%lo(sp)(a0)
	addi	a4,a4,4
	sw	a4,%lo(next)(a2)
	lw	a1,0(a3)
	li	a6,191
	bgtu	a1,a6,.L435
	lui	a0,%hi(stack)
	lw	a0,%lo(stack)(a0)
	addi	a6,a1,1
	slli	a1,a1,2
	sw	a6,0(a3)
	add	a1,a0,a1
	sw	a4,0(a1)
.L421:
	lw	a4,0(a3)
	li	a1,191
	bgtu	a4,a1,.L436
	lui	a1,%hi(stack)
	lw	a1,%lo(stack)(a1)
	addi	a0,a4,1
	slli	a4,a4,2
	sw	a0,0(a3)
	add	a4,a1,a4
	sw	a5,0(a4)
.L424:
	lw	a4,%lo(next)(a2)
	add	a5,a5,a4
	sw	a5,%lo(next)(a2)
	andi	a4,a5,3
	beq	a4,zero,.L415
	addi	a5,a5,1
.L426:
	andi	a4,a5,3
	mv	a3,a5
	addi	a5,a5,1
	bne	a4,zero,.L426
	sw	a3,%lo(next)(a2)
.L415:
	ret
.L434:
	lui	a5,%hi(.LC0)
	li	a4,73
	addi	a5,a5,%lo(.LC0)
	li	a3,234881024
.L417:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L417
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a4,%lo(next)(a2)
	li	a5,0
	j	.L418
.L436:
	lui	a4,%hi(.LC3)
	li	a3,63
	addi	a4,a4,%lo(.LC3)
	li	a1,234881024
.L423:
	addi	a4,a4,1
	sb	a3,0(a1)
	lbu	a3,0(a4)
	bne	a3,zero,.L423
	lui	a4,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a4)
	j	.L424
.L435:
	lui	a4,%hi(.LC3)
	li	a3,63
	addi	a4,a4,%lo(.LC3)
	li	a1,234881024
.L420:
	addi	a4,a4,1
	sb	a3,0(a1)
	lbu	a3,0(a4)
	bne	a3,zero,.L420
	lui	a4,%hi(errorFlag)
	li	a1,1
	lw	a3,%lo(sp)(a0)
	sw	a1,%lo(errorFlag)(a4)
	j	.L421
	.size	litstring, .-litstring
	.align	2
	.globl	commaByte
	.type	commaByte, @function
commaByte:
	lui	a1,%hi(sp)
	lw	a4,%lo(sp)(a1)
	lui	a2,%hi(here)
	lw	a0,%lo(here)(a2)
	lw	a5,0(a4)
	li	a3,191
	lw	a0,0(a0)
	bgtu	a5,a3,.L450
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a6,a5,1
	slli	a5,a5,2
	add	a5,a3,a5
	sw	a6,0(a4)
	sw	a0,0(a5)
	lw	a5,0(a4)
	li	a3,1
	beq	a5,a3,.L451
.L441:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a1,a5,2
	add	a3,a3,a1
	sw	a5,0(a4)
	lw	a1,0(a3)
	li	a3,1
	beq	a5,a3,.L452
.L444:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a0,a5,2
	sw	a5,0(a4)
	add	a5,a3,a0
	lbu	a5,0(a5)
.L446:
	lui	a4,%hi(memory)
	lw	a3,%lo(here)(a2)
	addi	a4,a4,%lo(memory)
	add	a4,a4,a1
	sb	a5,0(a4)
	lw	a5,0(a3)
	addi	a5,a5,1
	sw	a5,0(a3)
	ret
.L450:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L439:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L439
	lw	a4,%lo(sp)(a1)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,1
	bne	a5,a3,.L441
.L451:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L442:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L442
	lw	a4,%lo(sp)(a1)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,1
	li	a1,0
	bne	a5,a3,.L444
.L452:
	lui	a4,%hi(.LC4)
	li	a5,63
	addi	a4,a4,%lo(.LC4)
	li	a3,234881024
.L445:
	addi	a4,a4,1
	sb	a5,0(a3)
	lbu	a5,0(a4)
	bne	a5,zero,.L445
	lui	a4,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a4)
	j	.L446
	.size	commaByte, .-commaByte
	.align	2
	.globl	over
	.type	over, @function
over:
	lui	a2,%hi(sp)
	lw	a4,%lo(sp)(a2)
	li	a3,1
	lw	a5,0(a4)
	beq	a5,a3,.L470
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a1,a5,2
	sw	a5,0(a4)
	add	a3,a3,a1
	lw	a0,0(a3)
.L456:
	li	a3,1
	beq	a5,a3,.L471
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	slli	a1,a5,2
	add	a3,a3,a1
	lw	a1,-4(a3)
.L459:
	li	a3,191
	bgtu	a5,a3,.L472
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a2,a5,1
	slli	a5,a5,2
	add	a5,a3,a5
	sw	a2,0(a4)
	sw	a0,0(a5)
	lw	a5,0(a4)
	li	a3,191
	bgtu	a5,a3,.L473
.L463:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a2,a5,1
	slli	a5,a5,2
	sw	a2,0(a4)
	add	a5,a3,a5
	sw	a1,0(a5)
	ret
.L472:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L461:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L461
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,191
	bleu	a5,a3,.L463
.L473:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L464:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L464
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
.L471:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L458:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L458
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a1,0
	j	.L459
.L470:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L455:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L455
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a0,0
	j	.L456
	.size	over, .-over
	.align	2
	.globl	comma
	.type	comma, @function
comma:
	lui	a2,%hi(sp)
	lw	a4,%lo(sp)(a2)
	lui	a1,%hi(here)
	lw	a0,%lo(here)(a1)
	lw	a5,0(a4)
	li	a3,191
	lw	a0,0(a0)
	bgtu	a5,a3,.L491
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a6,a5,1
	slli	a5,a5,2
	add	a5,a3,a5
	sw	a6,0(a4)
	sw	a0,0(a5)
	lw	a5,0(a4)
	li	a3,1
	beq	a5,a3,.L492
.L478:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a2,a5,2
	add	a3,a3,a2
	sw	a5,0(a4)
	li	a2,1
	lw	a3,0(a3)
	beq	a5,a2,.L493
.L481:
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a5,a5,-1
	slli	a0,a5,2
	sw	a5,0(a4)
	add	a5,a2,a0
	lw	a4,0(a5)
	li	a5,65536
	bgtu	a3,a5,.L494
.L484:
	lui	a5,%hi(memory)
	addi	a5,a5,%lo(memory)
	add	a3,a3,a5
	sw	a4,0(a3)
	lw	a4,%lo(here)(a1)
	lw	a5,0(a4)
	addi	a5,a5,4
	sw	a5,0(a4)
	ret
.L491:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L476:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L476
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,1
	bne	a5,a3,.L478
.L492:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L479:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L479
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a2,1
	li	a3,0
	bne	a5,a2,.L481
.L493:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a2,234881024
.L482:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L482
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	li	a5,65536
	li	a4,0
	bleu	a3,a5,.L484
.L494:
	lui	a5,%hi(.LC5)
	li	a4,73
	addi	a5,a5,%lo(.LC5)
	li	a3,234881024
.L485:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L485
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	lw	a4,%lo(here)(a1)
	lw	a5,0(a4)
	addi	a5,a5,4
	sw	a5,0(a4)
	ret
	.size	comma, .-comma
	.align	2
	.globl	swap
	.type	swap, @function
swap:
	lui	a2,%hi(sp)
	lw	a4,%lo(sp)(a2)
	li	a3,1
	lw	a5,0(a4)
	beq	a5,a3,.L512
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a1,a5,2
	sw	a5,0(a4)
	add	a3,a3,a1
	lw	a0,0(a3)
.L498:
	li	a3,1
	beq	a5,a3,.L513
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a1,a5,2
	sw	a5,0(a4)
	add	a3,a3,a1
	lw	a1,0(a3)
.L501:
	li	a3,191
	bgtu	a5,a3,.L514
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a2,a5,1
	slli	a5,a5,2
	add	a5,a3,a5
	sw	a2,0(a4)
	sw	a0,0(a5)
	lw	a5,0(a4)
	li	a3,191
	bgtu	a5,a3,.L515
.L505:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a2,a5,1
	slli	a5,a5,2
	sw	a2,0(a4)
	add	a5,a3,a5
	sw	a1,0(a5)
	ret
.L514:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L503:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L503
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,191
	bleu	a5,a3,.L505
.L515:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L506:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L506
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
.L513:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L500:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L500
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a1,0
	j	.L501
.L512:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L497:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L497
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a0,0
	j	.L498
	.size	swap, .-swap
	.align	2
	.globl	timesDivide
	.type	timesDivide, @function
timesDivide:
	lui	a2,%hi(sp)
	lw	a4,%lo(sp)(a2)
	li	a3,1
	lw	a5,0(a4)
	beq	a5,a3,.L533
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a1,a5,2
	sw	a5,0(a4)
	add	a3,a3,a1
	lw	a0,0(a3)
.L519:
	li	a3,1
	beq	a5,a3,.L534
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a1,a5,2
	sw	a5,0(a4)
	add	a3,a3,a1
	lw	a3,0(a3)
.L522:
	li	a1,1
	beq	a5,a1,.L535
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a5,a5,-1
	slli	a1,a5,2
	sw	a5,0(a4)
	add	a2,a2,a1
	lw	a2,0(a2)
	mul	a3,a3,a2
	divu	a3,a3,a0
.L525:
	li	a2,191
	bgtu	a5,a2,.L536
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a1,a5,1
	slli	a5,a5,2
	sw	a1,0(a4)
	add	a5,a2,a5
	sw	a3,0(a5)
	ret
.L536:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L527:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L527
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
.L535:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L524:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L524
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,0
	j	.L525
.L534:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L521:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L521
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,0
	j	.L522
.L533:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L518:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L518
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a0,0
	j	.L519
	.size	timesDivide, .-timesDivide
	.align	2
	.globl	divmod
	.type	divmod, @function
divmod:
	lui	a1,%hi(sp)
	lw	a4,%lo(sp)(a1)
	li	a3,1
	lw	a5,0(a4)
	beq	a5,a3,.L554
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a2,a5,2
	sw	a5,0(a4)
	add	a3,a3,a2
	lw	a2,0(a3)
.L540:
	li	a3,1
	beq	a5,a3,.L555
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a0,a5,2
	add	a3,a3,a0
	sw	a5,0(a4)
	lw	a3,0(a3)
	rem	a0,a3,a2
	div	a3,a3,a2
.L543:
	li	a2,191
	bgtu	a5,a2,.L556
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a1,a5,1
	slli	a5,a5,2
	add	a5,a2,a5
	sw	a1,0(a4)
	sw	a0,0(a5)
	lw	a5,0(a4)
	li	a2,191
	bgtu	a5,a2,.L557
.L547:
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a1,a5,1
	slli	a5,a5,2
	sw	a1,0(a4)
	add	a5,a2,a5
	sw	a3,0(a5)
	ret
.L556:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a2,234881024
.L545:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L545
	lw	a4,%lo(sp)(a1)
	lui	a5,%hi(errorFlag)
	li	a2,1
	sw	a2,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a2,191
	bleu	a5,a2,.L547
.L557:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L548:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L548
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
.L555:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L542:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L542
	lw	a4,%lo(sp)(a1)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,0
	li	a0,0
	j	.L543
.L554:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L539:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L539
	lw	a4,%lo(sp)(a1)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a2,0
	j	.L540
	.size	divmod, .-divmod
	.align	2
	.globl	timesDivideMod
	.type	timesDivideMod, @function
timesDivideMod:
	lui	a1,%hi(sp)
	lw	a4,%lo(sp)(a1)
	li	a3,1
	lw	a5,0(a4)
	beq	a5,a3,.L579
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a2,a5,2
	add	a3,a3,a2
	sw	a5,0(a4)
	lw	a0,0(a3)
	li	a3,1
	beq	a5,a3,.L580
.L562:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a2,a5,2
	add	a3,a3,a2
	sw	a5,0(a4)
	li	a2,1
	lw	a3,0(a3)
	beq	a5,a2,.L581
.L565:
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a5,a5,-1
	slli	a6,a5,2
	add	a2,a2,a6
	sw	a5,0(a4)
	lw	a2,0(a2)
	mul	a3,a3,a2
	divu	a6,a3,a0
	remu	a3,a3,a0
.L567:
	li	a2,191
	bgtu	a5,a2,.L582
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a1,a5,1
	slli	a5,a5,2
	sw	a1,0(a4)
	add	a5,a2,a5
	sw	a3,0(a5)
	lw	a5,0(a4)
	li	a3,191
	bgtu	a5,a3,.L583
.L571:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a2,a5,1
	slli	a5,a5,2
	sw	a2,0(a4)
	add	a5,a3,a5
	sw	a6,0(a5)
	ret
.L582:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L569:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L569
	lw	a4,%lo(sp)(a1)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,191
	bleu	a5,a3,.L571
.L583:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L572:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L572
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
.L579:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L560:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L560
	lw	a4,%lo(sp)(a1)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,1
	li	a0,0
	bne	a5,a3,.L562
.L580:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L563:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L563
	lw	a4,%lo(sp)(a1)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a2,1
	li	a3,0
	bne	a5,a2,.L565
.L581:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L566:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L566
	lw	a4,%lo(sp)(a1)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,0
	li	a6,0
	j	.L567
	.size	timesDivideMod, .-timesDivideMod
	.align	2
	.globl	semicolon
	.type	semicolon, @function
semicolon:
	lui	a2,%hi(sp)
	lw	a4,%lo(sp)(a2)
	li	a3,191
	lw	a5,0(a4)
	bgtu	a5,a3,.L605
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a1,a5,1
	slli	a5,a5,2
	sw	a1,0(a4)
	add	a5,a3,a5
	li	a3,7
	sw	a3,0(a5)
	lui	a1,%hi(here)
	lw	a0,%lo(here)(a1)
	lw	a5,0(a4)
	li	a3,191
	lw	a0,0(a0)
	bgtu	a5,a3,.L606
.L588:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a6,a5,1
	slli	a5,a5,2
	add	a5,a3,a5
	sw	a6,0(a4)
	sw	a0,0(a5)
	lw	a5,0(a4)
	li	a3,1
	beq	a5,a3,.L607
.L591:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a2,a5,2
	add	a3,a3,a2
	sw	a5,0(a4)
	li	a2,1
	lw	a3,0(a3)
	beq	a5,a2,.L608
.L594:
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a5,a5,-1
	slli	a0,a5,2
	sw	a5,0(a4)
	add	a5,a2,a0
	lw	a4,0(a5)
	li	a5,65536
	bgtu	a3,a5,.L609
.L597:
	lui	a5,%hi(memory)
	addi	a5,a5,%lo(memory)
	add	a3,a5,a3
	sw	a4,0(a3)
.L599:
	lw	a3,%lo(here)(a1)
	lui	a4,%hi(latest)
	lw	a1,%lo(latest)(a4)
	lw	a4,0(a3)
	lui	a2,%hi(state)
	lw	a2,%lo(state)(a2)
	addi	a4,a4,4
	sw	a4,0(a3)
	lw	a4,0(a1)
	addi	a4,a4,4
	add	a5,a5,a4
	lbu	a4,0(a5)
	xori	a4,a4,64
	sb	a4,0(a5)
	sw	zero,0(a2)
	ret
.L605:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L586:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L586
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lui	a1,%hi(here)
	lw	a0,%lo(here)(a1)
	lw	a5,0(a4)
	li	a3,191
	lw	a0,0(a0)
	bleu	a5,a3,.L588
.L606:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L589:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L589
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,1
	bne	a5,a3,.L591
.L607:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L592:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L592
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a2,1
	li	a3,0
	bne	a5,a2,.L594
.L608:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a2,234881024
.L595:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L595
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	li	a5,65536
	li	a4,0
	bleu	a3,a5,.L597
.L609:
	lui	a5,%hi(.LC5)
	li	a4,73
	addi	a5,a5,%lo(.LC5)
	li	a3,234881024
.L598:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L598
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	lui	a5,%hi(memory)
	addi	a5,a5,%lo(memory)
	j	.L599
	.size	semicolon, .-semicolon
	.align	2
	.globl	dequals
	.type	dequals, @function
dequals:
	lui	a2,%hi(sp)
	lw	a4,%lo(sp)(a2)
	li	a3,1
	lw	a5,0(a4)
	beq	a5,a3,.L631
	addi	a5,a5,-1
	sw	a5,0(a4)
.L613:
	li	a3,1
	beq	a5,a3,.L632
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a1,a5,2
	sw	a5,0(a4)
	add	a3,a3,a1
	lw	a1,0(a3)
.L616:
	li	a3,1
	beq	a5,a3,.L633
	addi	a5,a5,-1
	sw	a5,0(a4)
.L619:
	li	a3,1
	beq	a5,a3,.L634
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a2,a5,2
	sw	a5,0(a4)
	add	a3,a3,a2
	lw	a3,0(a3)
.L622:
	li	a2,191
	bgtu	a5,a2,.L635
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	sub	a3,a3,a1
	seqz	a3,a3
	addi	a1,a5,1
	slli	a5,a5,2
	sw	a1,0(a4)
	add	a5,a2,a5
	neg	a3,a3
	sw	a3,0(a5)
	ret
.L635:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L624:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L624
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
.L634:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L621:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L621
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,0
	j	.L622
.L633:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L618:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L618
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	j	.L619
.L632:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L615:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L615
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a1,0
	j	.L616
.L631:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L612:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L612
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	j	.L613
	.size	dequals, .-dequals
	.align	2
	.globl	dlarger
	.type	dlarger, @function
dlarger:
	lui	a2,%hi(sp)
	lw	a4,%lo(sp)(a2)
	li	a3,1
	lw	a5,0(a4)
	beq	a5,a3,.L657
	addi	a5,a5,-1
	sw	a5,0(a4)
.L639:
	li	a3,1
	beq	a5,a3,.L658
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a1,a5,2
	sw	a5,0(a4)
	add	a3,a3,a1
	lw	a3,0(a3)
.L642:
	li	a1,1
	beq	a5,a1,.L659
	addi	a5,a5,-1
	sw	a5,0(a4)
.L645:
	li	a1,1
	beq	a5,a1,.L660
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a5,a5,-1
	slli	a1,a5,2
	sw	a5,0(a4)
	add	a2,a2,a1
	lw	a1,0(a2)
.L648:
	li	a2,191
	bgtu	a5,a2,.L661
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a0,a5,1
	slt	a3,a3,a1
	slli	a5,a5,2
	sw	a0,0(a4)
	add	a5,a2,a5
	neg	a3,a3
	sw	a3,0(a5)
	ret
.L661:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L650:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L650
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
.L660:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a1,234881024
.L647:
	addi	a5,a5,1
	sb	a4,0(a1)
	lbu	a4,0(a5)
	bne	a4,zero,.L647
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a2,1
	sw	a2,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a1,0
	j	.L648
.L659:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a1,234881024
.L644:
	addi	a5,a5,1
	sb	a4,0(a1)
	lbu	a4,0(a5)
	bne	a4,zero,.L644
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a1,1
	sw	a1,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	j	.L645
.L658:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L641:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L641
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,0
	j	.L642
.L657:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L638:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L638
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	j	.L639
	.size	dlarger, .-dlarger
	.align	2
	.globl	dsmaller
	.type	dsmaller, @function
dsmaller:
	lui	a2,%hi(sp)
	lw	a4,%lo(sp)(a2)
	li	a3,1
	lw	a5,0(a4)
	beq	a5,a3,.L683
	addi	a5,a5,-1
	sw	a5,0(a4)
.L665:
	li	a3,1
	beq	a5,a3,.L684
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a1,a5,2
	sw	a5,0(a4)
	add	a3,a3,a1
	lw	a3,0(a3)
.L668:
	li	a1,1
	beq	a5,a1,.L685
	addi	a5,a5,-1
	sw	a5,0(a4)
.L671:
	li	a1,1
	beq	a5,a1,.L686
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a5,a5,-1
	slli	a1,a5,2
	sw	a5,0(a4)
	add	a2,a2,a1
	lw	a1,0(a2)
.L674:
	li	a2,191
	bgtu	a5,a2,.L687
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a0,a5,1
	sgt	a3,a3,a1
	slli	a5,a5,2
	sw	a0,0(a4)
	add	a5,a2,a5
	neg	a3,a3
	sw	a3,0(a5)
	ret
.L687:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L676:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L676
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
.L686:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a1,234881024
.L673:
	addi	a5,a5,1
	sb	a4,0(a1)
	lbu	a4,0(a5)
	bne	a4,zero,.L673
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a2,1
	sw	a2,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a1,0
	j	.L674
.L685:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a1,234881024
.L670:
	addi	a5,a5,1
	sb	a4,0(a1)
	lbu	a4,0(a5)
	bne	a4,zero,.L670
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a1,1
	sw	a1,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	j	.L671
.L684:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L667:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L667
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,0
	j	.L668
.L683:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L664:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L664
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	j	.L665
	.size	dsmaller, .-dsmaller
	.align	2
	.globl	dusmaller
	.type	dusmaller, @function
dusmaller:
	lui	a2,%hi(sp)
	lw	a4,%lo(sp)(a2)
	li	a3,1
	lw	a5,0(a4)
	beq	a5,a3,.L709
	addi	a5,a5,-1
	sw	a5,0(a4)
.L691:
	li	a3,1
	beq	a5,a3,.L710
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a1,a5,2
	sw	a5,0(a4)
	add	a3,a3,a1
	lw	a1,0(a3)
.L694:
	li	a3,1
	beq	a5,a3,.L711
	addi	a5,a5,-1
	sw	a5,0(a4)
.L697:
	li	a3,1
	beq	a5,a3,.L712
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a2,a5,2
	sw	a5,0(a4)
	add	a3,a3,a2
	lw	a3,0(a3)
.L700:
	li	a2,191
	bgtu	a5,a2,.L713
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a0,a5,1
	sltu	a3,a3,a1
	slli	a5,a5,2
	sw	a0,0(a4)
	add	a5,a2,a5
	neg	a3,a3
	sw	a3,0(a5)
	ret
.L713:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L702:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L702
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
.L712:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L699:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L699
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,0
	j	.L700
.L711:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L696:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L696
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	j	.L697
.L710:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L693:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L693
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a1,0
	j	.L694
.L709:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L690:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L690
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	j	.L691
	.size	dusmaller, .-dusmaller
	.align	2
	.globl	rot
	.type	rot, @function
rot:
	lui	a3,%hi(sp)
	lw	a4,%lo(sp)(a3)
	li	a2,1
	lw	a5,0(a4)
	beq	a5,a2,.L739
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a5,a5,-1
	slli	a1,a5,2
	sw	a5,0(a4)
	add	a2,a2,a1
	lw	a1,0(a2)
.L717:
	li	a2,1
	beq	a5,a2,.L740
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a5,a5,-1
	slli	a0,a5,2
	sw	a5,0(a4)
	add	a2,a2,a0
	lw	a6,0(a2)
.L720:
	li	a2,1
	beq	a5,a2,.L741
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a5,a5,-1
	slli	a0,a5,2
	sw	a5,0(a4)
	add	a2,a2,a0
	lw	a0,0(a2)
.L723:
	li	a2,191
	bgtu	a5,a2,.L742
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a7,a5,1
	slli	a5,a5,2
	add	a5,a2,a5
	sw	a7,0(a4)
	sw	a6,0(a5)
	lw	a5,0(a4)
	li	a2,191
	bgtu	a5,a2,.L743
.L727:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a2,a5,1
	slli	a5,a5,2
	add	a5,a3,a5
	sw	a2,0(a4)
	sw	a1,0(a5)
	lw	a5,0(a4)
	li	a3,191
	bgtu	a5,a3,.L744
.L730:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a2,a5,1
	slli	a5,a5,2
	sw	a2,0(a4)
	add	a5,a3,a5
	sw	a0,0(a5)
	ret
.L742:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a2,234881024
.L725:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L725
	lw	a4,%lo(sp)(a3)
	lui	a5,%hi(errorFlag)
	li	a2,1
	sw	a2,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a2,191
	bleu	a5,a2,.L727
.L743:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a2,234881024
.L728:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L728
	lw	a4,%lo(sp)(a3)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,191
	bleu	a5,a3,.L730
.L744:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L731:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L731
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
.L741:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a2,234881024
.L722:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L722
	lw	a4,%lo(sp)(a3)
	lui	a5,%hi(errorFlag)
	li	a2,1
	sw	a2,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a0,0
	j	.L723
.L740:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a2,234881024
.L719:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L719
	lw	a4,%lo(sp)(a3)
	lui	a5,%hi(errorFlag)
	li	a2,1
	sw	a2,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a6,0
	j	.L720
.L739:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a2,234881024
.L716:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L716
	lw	a4,%lo(sp)(a3)
	lui	a5,%hi(errorFlag)
	li	a2,1
	sw	a2,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a1,0
	j	.L717
	.size	rot, .-rot
	.align	2
	.globl	p_dup
	.type	p_dup, @function
p_dup:
	lui	a5,%hi(sp)
	lw	a2,%lo(sp)(a5)
	li	a4,1
	lw	a5,0(a2)
	beq	a5,a4,.L757
	lui	a4,%hi(stack)
	lw	a4,%lo(stack)(a4)
	slli	a3,a5,2
	addi	a3,a3,-4
	add	a4,a4,a3
	lw	a3,0(a4)
	bne	a3,zero,.L758
	ret
.L758:
	li	a1,191
	bgtu	a5,a1,.L759
	addi	a5,a5,1
	sw	a5,0(a2)
	sw	a3,4(a4)
	ret
.L757:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L747:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L747
.L751:
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
.L759:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L750:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L750
	j	.L751
	.size	p_dup, .-p_dup
	.align	2
	.globl	doJ
	.type	doJ, @function
doJ:
	lui	a3,%hi(rsp)
	lw	a4,%lo(rsp)(a3)
	li	a2,1
	lw	a5,0(a4)
	beq	a5,a2,.L789
	lui	a2,%hi(rstack)
	lw	a2,%lo(rstack)(a2)
	addi	a5,a5,-1
	slli	a1,a5,2
	add	a2,a2,a1
	sw	a5,0(a4)
	lw	a1,0(a2)
	li	a2,1
	beq	a5,a2,.L790
.L764:
	lui	a2,%hi(rstack)
	lw	a2,%lo(rstack)(a2)
	addi	a5,a5,-1
	slli	a0,a5,2
	add	a2,a2,a0
	sw	a5,0(a4)
	lw	a6,0(a2)
	li	a2,1
	beq	a5,a2,.L791
.L767:
	lui	a2,%hi(rstack)
	lw	a2,%lo(rstack)(a2)
	addi	a5,a5,-1
	slli	a0,a5,2
	sw	a5,0(a4)
	add	a2,a2,a0
	lw	a0,0(a2)
.L769:
	li	a2,63
	bgtu	a5,a2,.L792
	lui	a2,%hi(rstack)
	lw	a2,%lo(rstack)(a2)
	addi	a7,a5,1
	slli	a5,a5,2
	add	a5,a2,a5
	sw	a7,0(a4)
	sw	a0,0(a5)
	lw	a5,0(a4)
	li	a2,63
	bgtu	a5,a2,.L793
.L773:
	lui	a3,%hi(rstack)
	lw	a3,%lo(rstack)(a3)
	addi	a2,a5,1
	slli	a5,a5,2
	add	a5,a3,a5
	sw	a2,0(a4)
	sw	a6,0(a5)
	lw	a5,0(a4)
	li	a3,63
	bgtu	a5,a3,.L794
.L776:
	lui	a3,%hi(rstack)
	lw	a3,%lo(rstack)(a3)
	addi	a2,a5,1
	slli	a5,a5,2
	sw	a2,0(a4)
	add	a5,a3,a5
	sw	a1,0(a5)
	lui	a5,%hi(sp)
	lw	a4,%lo(sp)(a5)
	li	a3,191
	lw	a5,0(a4)
	bgtu	a5,a3,.L795
.L779:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a2,a5,1
	slli	a5,a5,2
	sw	a2,0(a4)
	add	a5,a3,a5
	sw	a0,0(a5)
	ret
.L792:
	lui	a5,%hi(.LC1)
	li	a4,63
	addi	a5,a5,%lo(.LC1)
	li	a2,234881024
.L771:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L771
	lw	a4,%lo(rsp)(a3)
	lui	a5,%hi(errorFlag)
	li	a2,1
	sw	a2,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a2,63
	bleu	a5,a2,.L773
.L793:
	lui	a5,%hi(.LC1)
	li	a4,63
	addi	a5,a5,%lo(.LC1)
	li	a2,234881024
.L774:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L774
	lw	a4,%lo(rsp)(a3)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,63
	bleu	a5,a3,.L776
.L794:
	lui	a5,%hi(.LC1)
	li	a4,63
	addi	a5,a5,%lo(.LC1)
	li	a3,234881024
.L777:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L777
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	lui	a5,%hi(sp)
	lw	a4,%lo(sp)(a5)
	li	a3,191
	lw	a5,0(a4)
	bleu	a5,a3,.L779
.L795:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L780:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L780
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
.L789:
	lui	a5,%hi(.LC2)
	li	a4,63
	addi	a5,a5,%lo(.LC2)
	li	a2,234881024
.L762:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L762
	lw	a4,%lo(rsp)(a3)
	lui	a5,%hi(errorFlag)
	li	a2,1
	sw	a2,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a2,1
	li	a1,0
	bne	a5,a2,.L764
.L790:
	lui	a5,%hi(.LC2)
	li	a4,63
	addi	a5,a5,%lo(.LC2)
	li	a2,234881024
.L765:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L765
	lw	a4,%lo(rsp)(a3)
	lui	a5,%hi(errorFlag)
	li	a2,1
	sw	a2,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a2,1
	li	a6,0
	bne	a5,a2,.L767
.L791:
	lui	a5,%hi(.LC2)
	li	a4,63
	addi	a5,a5,%lo(.LC2)
	li	a2,234881024
.L768:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L768
	lw	a4,%lo(rsp)(a3)
	lui	a5,%hi(errorFlag)
	li	a2,1
	sw	a2,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a0,0
	j	.L769
	.size	doJ, .-doJ
	.align	2
	.globl	ddiv
	.type	ddiv, @function
ddiv:
	lui	a2,%hi(sp)
	lw	a4,%lo(sp)(a2)
	li	a3,1
	lw	a5,0(a4)
	beq	a5,a3,.L821
	addi	a5,a5,-1
	sw	a5,0(a4)
	li	a3,1
	beq	a5,a3,.L822
.L800:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a1,a5,2
	add	a3,a3,a1
	sw	a5,0(a4)
	lw	a1,0(a3)
	li	a3,1
	beq	a5,a3,.L823
.L803:
	addi	a5,a5,-1
	sw	a5,0(a4)
.L805:
	li	a3,1
	beq	a5,a3,.L824
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a0,a5,2
	sw	a5,0(a4)
	add	a3,a3,a0
	lw	a3,0(a3)
	div	a3,a3,a1
.L808:
	li	a1,191
	bgtu	a5,a1,.L825
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a1,a5,1
	slli	a5,a5,2
	sw	a1,0(a4)
	add	a5,a2,a5
	sw	a3,0(a5)
	lw	a5,0(a4)
	li	a3,191
	bgtu	a5,a3,.L826
.L812:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a2,a5,1
	slli	a5,a5,2
	sw	a2,0(a4)
	add	a5,a3,a5
	sw	zero,0(a5)
	ret
.L825:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L810:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L810
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,191
	bleu	a5,a3,.L812
.L826:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L813:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L813
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
.L824:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L807:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L807
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,0
	j	.L808
.L821:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L798:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L798
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,1
	bne	a5,a3,.L800
.L822:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L801:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L801
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,1
	li	a1,0
	bne	a5,a3,.L803
.L823:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L804:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L804
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	j	.L805
	.size	ddiv, .-ddiv
	.align	2
	.globl	dmul
	.type	dmul, @function
dmul:
	lui	a2,%hi(sp)
	lw	a4,%lo(sp)(a2)
	li	a3,1
	lw	a5,0(a4)
	beq	a5,a3,.L852
	addi	a5,a5,-1
	sw	a5,0(a4)
	li	a3,1
	beq	a5,a3,.L853
.L831:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a1,a5,2
	add	a3,a3,a1
	sw	a5,0(a4)
	li	a1,1
	lw	a3,0(a3)
	beq	a5,a1,.L854
.L834:
	addi	a5,a5,-1
	sw	a5,0(a4)
.L836:
	li	a1,1
	beq	a5,a1,.L855
	lui	a1,%hi(stack)
	lw	a1,%lo(stack)(a1)
	addi	a5,a5,-1
	slli	a0,a5,2
	sw	a5,0(a4)
	add	a1,a1,a0
	lw	a1,0(a1)
	mul	a3,a3,a1
.L839:
	li	a1,191
	bgtu	a5,a1,.L856
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a1,a5,1
	slli	a5,a5,2
	sw	a1,0(a4)
	add	a5,a2,a5
	sw	a3,0(a5)
	lw	a5,0(a4)
	li	a3,191
	bgtu	a5,a3,.L857
.L843:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a2,a5,1
	slli	a5,a5,2
	sw	a2,0(a4)
	add	a5,a3,a5
	sw	zero,0(a5)
	ret
.L856:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L841:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L841
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,191
	bleu	a5,a3,.L843
.L857:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L844:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L844
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
.L855:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L838:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L838
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,0
	j	.L839
.L852:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L829:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L829
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,1
	bne	a5,a3,.L831
.L853:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L832:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L832
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a1,1
	li	a3,0
	bne	a5,a1,.L834
.L854:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a1,234881024
.L835:
	addi	a5,a5,1
	sb	a4,0(a1)
	lbu	a4,0(a5)
	bne	a4,zero,.L835
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a1,1
	sw	a1,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	j	.L836
	.size	dmul, .-dmul
	.align	2
	.globl	dminus
	.type	dminus, @function
dminus:
	lui	a3,%hi(sp)
	lw	a4,%lo(sp)(a3)
	li	a2,1
	lw	a5,0(a4)
	beq	a5,a2,.L883
	addi	a5,a5,-1
	sw	a5,0(a4)
	li	a2,1
	beq	a5,a2,.L884
.L862:
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a5,a5,-1
	slli	a1,a5,2
	add	a2,a2,a1
	sw	a5,0(a4)
	lw	a0,0(a2)
	li	a2,1
	beq	a5,a2,.L885
.L865:
	addi	a5,a5,-1
	sw	a5,0(a4)
.L867:
	li	a2,1
	beq	a5,a2,.L886
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a5,a5,-1
	slli	a1,a5,2
	sw	a5,0(a4)
	add	a2,a2,a1
	lw	a2,0(a2)
.L870:
	li	a1,191
	bgtu	a5,a1,.L887
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a1,a5,1
	slli	a5,a5,2
	add	a5,a3,a5
	sw	a1,0(a4)
	sub	a2,a2,a0
	sw	a2,0(a5)
	lw	a5,0(a4)
	li	a3,191
	bgtu	a5,a3,.L888
.L874:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a2,a5,1
	slli	a5,a5,2
	sw	a2,0(a4)
	add	a5,a3,a5
	sw	zero,0(a5)
	ret
.L887:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a2,234881024
.L872:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L872
	lw	a4,%lo(sp)(a3)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,191
	bleu	a5,a3,.L874
.L888:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L875:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L875
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
.L886:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a2,234881024
.L869:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L869
	lw	a4,%lo(sp)(a3)
	lui	a5,%hi(errorFlag)
	li	a2,1
	sw	a2,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a2,0
	j	.L870
.L883:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a2,234881024
.L860:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L860
	lw	a4,%lo(sp)(a3)
	lui	a5,%hi(errorFlag)
	li	a2,1
	sw	a2,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a2,1
	bne	a5,a2,.L862
.L884:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a2,234881024
.L863:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L863
	lw	a4,%lo(sp)(a3)
	lui	a5,%hi(errorFlag)
	li	a2,1
	sw	a2,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a2,1
	li	a0,0
	bne	a5,a2,.L865
.L885:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a2,234881024
.L866:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L866
	lw	a4,%lo(sp)(a3)
	lui	a5,%hi(errorFlag)
	li	a2,1
	sw	a2,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	j	.L867
	.size	dminus, .-dminus
	.align	2
	.globl	dplus
	.type	dplus, @function
dplus:
	lui	a2,%hi(sp)
	lw	a4,%lo(sp)(a2)
	li	a3,1
	lw	a5,0(a4)
	beq	a5,a3,.L914
	addi	a5,a5,-1
	sw	a5,0(a4)
	li	a3,1
	beq	a5,a3,.L915
.L893:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a1,a5,2
	add	a3,a3,a1
	sw	a5,0(a4)
	lw	a3,0(a3)
	li	a1,1
	mv	a0,a3
	beq	a5,a1,.L916
.L896:
	addi	a5,a5,-1
	sw	a5,0(a4)
.L898:
	li	a1,1
	beq	a5,a1,.L917
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a1,a5,2
	sw	a5,0(a4)
	add	a3,a3,a1
	lw	a3,0(a3)
	add	a3,a0,a3
.L901:
	li	a1,191
	bgtu	a5,a1,.L918
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a1,a5,1
	slli	a5,a5,2
	sw	a1,0(a4)
	add	a5,a2,a5
	sw	a3,0(a5)
	lw	a5,0(a4)
	li	a3,191
	bgtu	a5,a3,.L919
.L905:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a2,a5,1
	slli	a5,a5,2
	sw	a2,0(a4)
	add	a5,a3,a5
	sw	zero,0(a5)
	ret
.L918:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L903:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L903
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,191
	bleu	a5,a3,.L905
.L919:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L906:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L906
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
.L917:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a1,234881024
.L900:
	addi	a5,a5,1
	sb	a4,0(a1)
	lbu	a4,0(a5)
	bne	a4,zero,.L900
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a1,1
	sw	a1,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	j	.L901
.L914:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L891:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L891
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,1
	bne	a5,a3,.L893
.L915:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L894:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L894
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a1,1
	li	a0,0
	li	a3,0
	bne	a5,a1,.L896
.L916:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a1,234881024
.L897:
	addi	a5,a5,1
	sb	a4,0(a1)
	lbu	a4,0(a5)
	bne	a4,zero,.L897
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a1,1
	sw	a1,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	j	.L898
	.size	dplus, .-dplus
	.align	2
	.globl	dswap
	.type	dswap, @function
dswap:
	lui	a3,%hi(sp)
	lw	a4,%lo(sp)(a3)
	li	a2,1
	lw	a5,0(a4)
	beq	a5,a2,.L953
	addi	a5,a5,-1
	sw	a5,0(a4)
.L923:
	li	a2,1
	beq	a5,a2,.L954
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a5,a5,-1
	slli	a1,a5,2
	sw	a5,0(a4)
	add	a2,a2,a1
	lw	a0,0(a2)
.L926:
	li	a2,1
	beq	a5,a2,.L955
	addi	a5,a5,-1
	sw	a5,0(a4)
	li	a2,1
	beq	a5,a2,.L956
.L930:
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a5,a5,-1
	slli	a1,a5,2
	sw	a5,0(a4)
	add	a2,a2,a1
	lw	a1,0(a2)
.L932:
	li	a2,191
	bgtu	a5,a2,.L957
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a6,a5,1
	slli	a5,a5,2
	add	a5,a2,a5
	sw	a6,0(a4)
	sw	a0,0(a5)
	lw	a5,0(a4)
	li	a2,191
	bgtu	a5,a2,.L958
.L936:
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a0,a5,1
	slli	a5,a5,2
	add	a5,a2,a5
	sw	a0,0(a4)
	sw	zero,0(a5)
	lw	a5,0(a4)
	li	a2,191
	bgtu	a5,a2,.L959
.L939:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a2,a5,1
	slli	a5,a5,2
	add	a5,a3,a5
	sw	a2,0(a4)
	sw	a1,0(a5)
	lw	a5,0(a4)
	li	a3,191
	bgtu	a5,a3,.L960
.L942:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a2,a5,1
	slli	a5,a5,2
	sw	a2,0(a4)
	add	a5,a3,a5
	sw	zero,0(a5)
	ret
.L957:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a2,234881024
.L934:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L934
	lw	a4,%lo(sp)(a3)
	lui	a5,%hi(errorFlag)
	li	a2,1
	sw	a2,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a2,191
	bleu	a5,a2,.L936
.L958:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a2,234881024
.L937:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L937
	lw	a4,%lo(sp)(a3)
	lui	a5,%hi(errorFlag)
	li	a2,1
	sw	a2,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a2,191
	bleu	a5,a2,.L939
.L959:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a2,234881024
.L940:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L940
	lw	a4,%lo(sp)(a3)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,191
	bleu	a5,a3,.L942
.L960:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L943:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L943
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
.L955:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a2,234881024
.L928:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L928
	lw	a4,%lo(sp)(a3)
	lui	a5,%hi(errorFlag)
	li	a2,1
	sw	a2,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a2,1
	bne	a5,a2,.L930
.L956:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a2,234881024
.L931:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L931
	lw	a4,%lo(sp)(a3)
	lui	a5,%hi(errorFlag)
	li	a2,1
	sw	a2,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a1,0
	j	.L932
.L954:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a2,234881024
.L925:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L925
	lw	a4,%lo(sp)(a3)
	lui	a5,%hi(errorFlag)
	li	a2,1
	sw	a2,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a0,0
	j	.L926
.L953:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a2,234881024
.L922:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L922
	lw	a4,%lo(sp)(a3)
	lui	a5,%hi(errorFlag)
	li	a2,1
	sw	a2,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	j	.L923
	.size	dswap, .-dswap
	.align	2
	.globl	dover
	.type	dover, @function
dover:
	lui	a3,%hi(sp)
	lw	a4,%lo(sp)(a3)
	li	a2,1
	lw	a5,0(a4)
	beq	a5,a2,.L1002
	addi	a5,a5,-1
	sw	a5,0(a4)
	li	a2,1
	beq	a5,a2,.L1003
.L965:
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a5,a5,-1
	slli	a1,a5,2
	add	a2,a2,a1
	sw	a5,0(a4)
	lw	a0,0(a2)
	li	a2,1
	beq	a5,a2,.L1004
.L968:
	addi	a5,a5,-1
	sw	a5,0(a4)
.L970:
	li	a2,1
	beq	a5,a2,.L1005
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a5,a5,-1
	slli	a1,a5,2
	sw	a5,0(a4)
	add	a2,a2,a1
	lw	a1,0(a2)
.L973:
	li	a2,191
	bgtu	a5,a2,.L1006
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a6,a5,1
	slli	a5,a5,2
	add	a5,a2,a5
	sw	a6,0(a4)
	sw	a1,0(a5)
	lw	a5,0(a4)
	li	a2,191
	bgtu	a5,a2,.L1007
.L977:
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a6,a5,1
	slli	a5,a5,2
	add	a5,a2,a5
	sw	a6,0(a4)
	sw	zero,0(a5)
	lw	a5,0(a4)
	li	a2,191
	bgtu	a5,a2,.L1008
.L980:
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a6,a5,1
	slli	a5,a5,2
	add	a5,a2,a5
	sw	a6,0(a4)
	sw	a0,0(a5)
	lw	a5,0(a4)
	li	a2,191
	bgtu	a5,a2,.L1009
.L983:
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a0,a5,1
	slli	a5,a5,2
	add	a5,a2,a5
	sw	a0,0(a4)
	sw	zero,0(a5)
	lw	a5,0(a4)
	li	a2,191
	bgtu	a5,a2,.L1010
.L986:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a2,a5,1
	slli	a5,a5,2
	add	a5,a3,a5
	sw	a2,0(a4)
	sw	a1,0(a5)
	lw	a5,0(a4)
	li	a3,191
	bgtu	a5,a3,.L1011
.L989:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a2,a5,1
	slli	a5,a5,2
	sw	a2,0(a4)
	add	a5,a3,a5
	sw	zero,0(a5)
	ret
.L1006:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a2,234881024
.L975:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L975
	lw	a4,%lo(sp)(a3)
	lui	a5,%hi(errorFlag)
	li	a2,1
	sw	a2,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a2,191
	bleu	a5,a2,.L977
.L1007:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a2,234881024
.L978:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L978
	lw	a4,%lo(sp)(a3)
	lui	a5,%hi(errorFlag)
	li	a2,1
	sw	a2,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a2,191
	bleu	a5,a2,.L980
.L1008:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a2,234881024
.L981:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L981
	lw	a4,%lo(sp)(a3)
	lui	a5,%hi(errorFlag)
	li	a2,1
	sw	a2,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a2,191
	bleu	a5,a2,.L983
.L1009:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a2,234881024
.L984:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L984
	lw	a4,%lo(sp)(a3)
	lui	a5,%hi(errorFlag)
	li	a2,1
	sw	a2,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a2,191
	bleu	a5,a2,.L986
.L1010:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a2,234881024
.L987:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L987
	lw	a4,%lo(sp)(a3)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,191
	bleu	a5,a3,.L989
.L1011:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L990:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L990
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
.L1005:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a2,234881024
.L972:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L972
	lw	a4,%lo(sp)(a3)
	lui	a5,%hi(errorFlag)
	li	a2,1
	sw	a2,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a1,0
	j	.L973
.L1002:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a2,234881024
.L963:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L963
	lw	a4,%lo(sp)(a3)
	lui	a5,%hi(errorFlag)
	li	a2,1
	sw	a2,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a2,1
	bne	a5,a2,.L965
.L1003:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a2,234881024
.L966:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L966
	lw	a4,%lo(sp)(a3)
	lui	a5,%hi(errorFlag)
	li	a2,1
	sw	a2,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a2,1
	li	a0,0
	bne	a5,a2,.L968
.L1004:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a2,234881024
.L969:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L969
	lw	a4,%lo(sp)(a3)
	lui	a5,%hi(errorFlag)
	li	a2,1
	sw	a2,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	j	.L970
	.size	dover, .-dover
	.align	2
	.globl	drot
	.type	drot, @function
drot:
	lui	a3,%hi(sp)
	lw	a4,%lo(sp)(a3)
	li	a2,1
	lw	a5,0(a4)
	beq	a5,a2,.L1061
	addi	a5,a5,-1
	sw	a5,0(a4)
	li	a2,1
	beq	a5,a2,.L1062
.L1016:
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a5,a5,-1
	slli	a1,a5,2
	add	a2,a2,a1
	sw	a5,0(a4)
	li	a1,1
	lw	a2,0(a2)
	beq	a5,a1,.L1063
.L1019:
	addi	a5,a5,-1
	sw	a5,0(a4)
.L1021:
	li	a1,1
	beq	a5,a1,.L1064
	lui	a1,%hi(stack)
	lw	a1,%lo(stack)(a1)
	addi	a5,a5,-1
	slli	a0,a5,2
	sw	a5,0(a4)
	add	a1,a1,a0
	lw	a6,0(a1)
.L1024:
	li	a1,1
	beq	a5,a1,.L1065
	addi	a5,a5,-1
	sw	a5,0(a4)
	li	a1,1
	beq	a5,a1,.L1066
.L1028:
	lui	a1,%hi(stack)
	lw	a1,%lo(stack)(a1)
	addi	a5,a5,-1
	slli	a0,a5,2
	sw	a5,0(a4)
	add	a1,a1,a0
	lw	a1,0(a1)
.L1030:
	li	a0,191
	bgtu	a5,a0,.L1067
	lui	a0,%hi(stack)
	lw	a0,%lo(stack)(a0)
	addi	a7,a5,1
	slli	a5,a5,2
	add	a5,a0,a5
	sw	a7,0(a4)
	sw	a6,0(a5)
	lw	a5,0(a4)
	li	a0,191
	bgtu	a5,a0,.L1068
.L1034:
	lui	a0,%hi(stack)
	lw	a0,%lo(stack)(a0)
	addi	a6,a5,1
	slli	a5,a5,2
	add	a5,a0,a5
	sw	a6,0(a4)
	sw	zero,0(a5)
	lw	a5,0(a4)
	li	a0,191
	bgtu	a5,a0,.L1069
.L1037:
	lui	a0,%hi(stack)
	lw	a0,%lo(stack)(a0)
	addi	a6,a5,1
	slli	a5,a5,2
	sw	a6,0(a4)
	add	a5,a0,a5
	sw	a2,0(a5)
	lw	a5,0(a4)
	li	a2,191
	bgtu	a5,a2,.L1070
.L1040:
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a0,a5,1
	slli	a5,a5,2
	add	a5,a2,a5
	sw	a0,0(a4)
	sw	zero,0(a5)
	lw	a5,0(a4)
	li	a2,191
	bgtu	a5,a2,.L1071
.L1043:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a2,a5,1
	slli	a5,a5,2
	add	a5,a3,a5
	sw	a2,0(a4)
	sw	a1,0(a5)
	lw	a5,0(a4)
	li	a3,191
	bgtu	a5,a3,.L1072
.L1046:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a2,a5,1
	slli	a5,a5,2
	sw	a2,0(a4)
	add	a5,a3,a5
	sw	zero,0(a5)
	ret
.L1067:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a0,234881024
.L1032:
	addi	a5,a5,1
	sb	a4,0(a0)
	lbu	a4,0(a5)
	bne	a4,zero,.L1032
	lw	a4,%lo(sp)(a3)
	lui	a5,%hi(errorFlag)
	li	a0,1
	sw	a0,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a0,191
	bleu	a5,a0,.L1034
.L1068:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a0,234881024
.L1035:
	addi	a5,a5,1
	sb	a4,0(a0)
	lbu	a4,0(a5)
	bne	a4,zero,.L1035
	lw	a4,%lo(sp)(a3)
	lui	a5,%hi(errorFlag)
	li	a0,1
	sw	a0,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a0,191
	bleu	a5,a0,.L1037
.L1069:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a2,234881024
.L1038:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L1038
	lw	a4,%lo(sp)(a3)
	lui	a5,%hi(errorFlag)
	li	a2,1
	sw	a2,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a2,191
	bleu	a5,a2,.L1040
.L1070:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a2,234881024
.L1041:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L1041
	lw	a4,%lo(sp)(a3)
	lui	a5,%hi(errorFlag)
	li	a2,1
	sw	a2,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a2,191
	bleu	a5,a2,.L1043
.L1071:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a2,234881024
.L1044:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L1044
	lw	a4,%lo(sp)(a3)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,191
	bleu	a5,a3,.L1046
.L1072:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L1047:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1047
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
.L1065:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a1,234881024
.L1026:
	addi	a5,a5,1
	sb	a4,0(a1)
	lbu	a4,0(a5)
	bne	a4,zero,.L1026
	lw	a4,%lo(sp)(a3)
	lui	a5,%hi(errorFlag)
	li	a1,1
	sw	a1,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a1,1
	bne	a5,a1,.L1028
.L1066:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a1,234881024
.L1029:
	addi	a5,a5,1
	sb	a4,0(a1)
	lbu	a4,0(a5)
	bne	a4,zero,.L1029
	lw	a4,%lo(sp)(a3)
	lui	a5,%hi(errorFlag)
	li	a1,1
	sw	a1,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a1,0
	j	.L1030
.L1064:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a1,234881024
.L1023:
	addi	a5,a5,1
	sb	a4,0(a1)
	lbu	a4,0(a5)
	bne	a4,zero,.L1023
	lw	a4,%lo(sp)(a3)
	lui	a5,%hi(errorFlag)
	li	a1,1
	sw	a1,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a6,0
	j	.L1024
.L1061:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a2,234881024
.L1014:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L1014
	lw	a4,%lo(sp)(a3)
	lui	a5,%hi(errorFlag)
	li	a2,1
	sw	a2,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a2,1
	bne	a5,a2,.L1016
.L1062:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a2,234881024
.L1017:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L1017
	lw	a4,%lo(sp)(a3)
	lui	a5,%hi(errorFlag)
	li	a2,1
	sw	a2,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a1,1
	li	a2,0
	bne	a5,a1,.L1019
.L1063:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a1,234881024
.L1020:
	addi	a5,a5,1
	sb	a4,0(a1)
	lbu	a4,0(a5)
	bne	a4,zero,.L1020
	lw	a4,%lo(sp)(a3)
	lui	a5,%hi(errorFlag)
	li	a1,1
	sw	a1,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	j	.L1021
	.size	drot, .-drot
	.align	2
	.globl	cfa
	.type	cfa, @function
cfa:
	lui	a1,%hi(sp)
	lw	a3,%lo(sp)(a1)
	li	a4,1
	lw	a5,0(a3)
	beq	a5,a4,.L1096
	lui	a4,%hi(stack)
	lw	a4,%lo(stack)(a4)
	addi	a5,a5,-1
	slli	a2,a5,2
	sw	a5,0(a3)
	add	a5,a4,a2
	lw	a2,0(a5)
	addi	a2,a2,4
.L1076:
	lui	a3,%hi(memory)
	addi	a3,a3,%lo(memory)
	add	a5,a3,a2
	lbu	a5,0(a5)
	andi	a5,a5,31
	addi	a5,a5,1
	andi	a4,a5,3
	beq	a4,zero,.L1079
.L1078:
	addi	a5,a5,1
	andi	a4,a5,3
	andi	a5,a5,0xff
	bne	a4,zero,.L1078
.L1079:
	lui	a4,%hi(maxBuiltinAddress)
	lw	a4,%lo(maxBuiltinAddress)(a4)
	add	a5,a5,a2
	bleu	a4,a5,.L1080
	li	a4,65536
	bgtu	a5,a4,.L1097
	lw	a4,%lo(sp)(a1)
	add	a3,a3,a5
	lw	a2,0(a3)
	lw	a5,0(a4)
	li	a3,191
	bgtu	a5,a3,.L1098
.L1084:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a1,a5,1
	slli	a5,a5,2
	sw	a1,0(a4)
	add	a5,a3,a5
	sw	a2,0(a5)
	ret
.L1097:
	lui	a5,%hi(.LC0)
	li	a4,73
	addi	a5,a5,%lo(.LC0)
	li	a3,234881024
.L1082:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1082
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	lw	a4,%lo(sp)(a1)
	li	a3,191
	li	a2,0
	lw	a5,0(a4)
	bleu	a5,a3,.L1084
.L1098:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L1085:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1085
.L1089:
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
.L1080:
	lw	a2,%lo(sp)(a1)
	li	a3,191
	lw	a4,0(a2)
	bgtu	a4,a3,.L1099
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a1,a4,1
	slli	a4,a4,2
	sw	a1,0(a2)
	add	a4,a3,a4
	sw	a5,0(a4)
	ret
.L1096:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L1075:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1075
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	li	a2,4
	j	.L1076
.L1099:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L1088:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1088
	j	.L1089
	.size	cfa, .-cfa
	.align	2
	.globl	number
	.type	number, @function
number:
	addi	sp,sp,-32
	sw	s2,16(sp)
	lui	s2,%hi(sp)
	sw	s1,20(sp)
	lw	s1,%lo(sp)(s2)
	sw	s0,24(sp)
	sw	ra,28(sp)
	lw	s0,0(s1)
	li	a5,1
	beq	s0,a5,.L1129
	lui	a5,%hi(stack)
	lw	a5,%lo(stack)(a5)
	addi	s0,s0,-1
	slli	a4,s0,2
	sw	s0,0(s1)
	add	a5,a5,a4
	lw	a1,0(a5)
.L1103:
	li	a5,1
	beq	s0,a5,.L1130
	lui	a5,%hi(stack)
	lw	a5,%lo(stack)(a5)
	addi	s0,s0,-1
	slli	a4,s0,2
	add	a5,a5,a4
	sw	s0,0(s1)
	lw	a0,0(a5)
	lui	a5,%hi(memory)
	addi	a5,a5,%lo(memory)
	add	a0,a0,a5
.L1106:
	sw	zero,8(sp)
	sb	zero,7(sp)
	beq	a1,zero,.L1131
	addi	a4,sp,7
	addi	a3,sp,12
	addi	a2,sp,8
	call	parseNumber.part.0.constprop.0
	lbu	a5,7(sp)
	beq	a5,zero,.L1109
	li	a5,191
	lw	a4,8(sp)
	bgtu	s0,a5,.L1132
	lui	a5,%hi(stack)
	lw	a5,%lo(stack)(a5)
	addi	a3,s0,1
	slli	s0,s0,2
	sw	a3,0(s1)
	add	a5,a5,s0
	sw	a4,0(a5)
	lw	a5,0(s1)
	li	a4,191
	bgtu	a5,a4,.L1133
.L1113:
	lui	a4,%hi(stack)
	lw	a4,%lo(stack)(a4)
	addi	a3,a5,1
	slli	a5,a5,2
	sw	a3,0(s1)
	add	a5,a4,a5
	sw	zero,0(a5)
.L1115:
	lw	a5,0(s1)
	li	a4,191
	lw	a3,12(sp)
	bgtu	a5,a4,.L1134
	lui	a4,%hi(stack)
	lw	a4,%lo(stack)(a4)
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	a2,a5,1
	slli	a5,a5,2
	sw	a2,0(s1)
	add	a5,a4,a5
	sw	a3,0(a5)
	lw	s1,20(sp)
	lw	s2,16(sp)
	addi	sp,sp,32
	jr	ra
.L1134:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L1119:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1119
	lw	ra,28(sp)
	lw	s0,24(sp)
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	lw	s1,20(sp)
	lw	s2,16(sp)
	addi	sp,sp,32
	jr	ra
.L1131:
	sw	zero,12(sp)
.L1108:
	li	a5,191
	bgtu	s0,a5,.L1135
	lui	a5,%hi(stack)
	lw	a5,%lo(stack)(a5)
	addi	a4,s0,1
	slli	s0,s0,2
	sw	a4,0(s1)
	add	a5,a5,s0
	sw	a1,0(a5)
	j	.L1115
.L1130:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L1105:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1105
	lw	s1,%lo(sp)(s2)
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	lui	a0,%hi(memory)
	lw	s0,0(s1)
	addi	a0,a0,%lo(memory)
	j	.L1106
.L1129:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L1102:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1102
	lw	s1,%lo(sp)(s2)
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	lw	s0,0(s1)
	li	a1,0
	j	.L1103
.L1132:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L1111:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1111
	lw	s1,%lo(sp)(s2)
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	lw	a5,0(s1)
	li	a4,191
	bleu	a5,a4,.L1113
.L1133:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L1114:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1114
	lui	a5,%hi(errorFlag)
	li	a4,1
	lw	s1,%lo(sp)(s2)
	sw	a4,%lo(errorFlag)(a5)
	j	.L1115
.L1135:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L1117:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1117
	lui	a5,%hi(errorFlag)
	li	a4,1
	lw	s1,%lo(sp)(s2)
	sw	a4,%lo(errorFlag)(a5)
	j	.L1115
.L1109:
	lw	a1,8(sp)
	j	.L1108
	.size	number, .-number
	.align	2
	.globl	putkey
	.type	putkey, @function
putkey:
	li	a5,234881024
	sb	a0,0(a5)
	ret
	.size	putkey, .-putkey
	.align	2
	.globl	llkey
	.type	llkey, @function
llkey:
	lui	a4,%hi(initscript_pos)
	lw	a5,%lo(initscript_pos)(a4)
	lbu	a3,0(a5)
	bne	a3,zero,.L1140
	li	a5,251658240
	lbu	a0,0(a5)
	ret
.L1140:
	addi	a3,a5,1
	sw	a3,%lo(initscript_pos)(a4)
	lbu	a0,0(a5)
	ret
	.size	llkey, .-llkey
	.align	2
	.globl	keyWaiting
	.type	keyWaiting, @function
keyWaiting:
	lui	a5,%hi(positionInLineBuffer)
	lw	a0,%lo(positionInLineBuffer)(a5)
	lui	a5,%hi(charsInLineBuffer)
	lw	a5,%lo(charsInLineBuffer)(a5)
	slt	a0,a0,a5
	neg	a0,a0
	ret
	.size	keyWaiting, .-keyWaiting
	.align	2
	.globl	getkey
	.type	getkey, @function
getkey:
	lui	t3,%hi(positionInLineBuffer)
	lui	a6,%hi(charsInLineBuffer)
	lw	a5,%lo(positionInLineBuffer)(t3)
	lw	a4,%lo(charsInLineBuffer)(a6)
	blt	a5,a4,.L1152
	lui	a5,%hi(.LANCHOR0)
	addi	a0,a5,%lo(.LANCHOR0)
	addi	t4,a5,%lo(.LANCHOR0)
	li	a1,1
	sw	zero,%lo(charsInLineBuffer)(a6)
	addi	a0,a0,128
	addi	a5,a5,%lo(.LANCHOR0)
	lui	a2,%hi(initscript_pos)
	li	t1,251658240
	sub	a1,a1,t4
	li	a7,10
	j	.L1145
.L1146:
	lbu	a4,0(t1)
	add	a3,a1,a5
	beq	a5,a0,.L1148
.L1151:
	sw	a3,%lo(charsInLineBuffer)(a6)
	sb	a4,0(a5)
	addi	a5,a5,1
	beq	a4,a7,.L1148
.L1145:
	lw	a4,%lo(initscript_pos)(a2)
	lbu	a3,0(a4)
	beq	a3,zero,.L1146
	addi	a3,a4,1
	sw	a3,%lo(initscript_pos)(a2)
	lbu	a4,0(a4)
	add	a3,a1,a5
	bne	a5,a0,.L1151
.L1148:
	li	a5,1
	lbu	a0,0(t4)
	sw	a5,%lo(positionInLineBuffer)(t3)
	ret
.L1152:
	lui	a4,%hi(.LANCHOR0)
	addi	a4,a4,%lo(.LANCHOR0)
	addi	a3,a5,1
	add	a5,a4,a5
	lbu	a0,0(a5)
	sw	a3,%lo(positionInLineBuffer)(t3)
	ret
	.size	getkey, .-getkey
	.align	2
	.globl	tell
	.type	tell, @function
tell:
	lbu	a5,0(a0)
	beq	a5,zero,.L1153
	li	a4,234881024
.L1155:
	addi	a0,a0,1
	sb	a5,0(a4)
	lbu	a5,0(a0)
	bne	a5,zero,.L1155
.L1153:
	ret
	.size	tell, .-tell
	.align	2
	.globl	pop
	.type	pop, @function
pop:
	lui	a5,%hi(sp)
	lw	a3,%lo(sp)(a5)
	li	a4,1
	lw	a5,0(a3)
	beq	a5,a4,.L1165
	lui	a4,%hi(stack)
	lw	a4,%lo(stack)(a4)
	addi	a5,a5,-1
	slli	a2,a5,2
	sw	a5,0(a3)
	add	a5,a4,a2
	lw	a0,0(a5)
	ret
.L1165:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L1162:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1162
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	li	a0,0
	ret
	.size	pop, .-pop
	.align	2
	.globl	tos
	.type	tos, @function
tos:
	lui	a5,%hi(sp)
	lw	a5,%lo(sp)(a5)
	li	a4,1
	lw	a5,0(a5)
	beq	a5,a4,.L1171
	lui	a4,%hi(stack)
	lw	a4,%lo(stack)(a4)
	slli	a5,a5,2
	add	a5,a4,a5
	lw	a0,-4(a5)
	ret
.L1171:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L1168:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1168
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	li	a0,0
	ret
	.size	tos, .-tos
	.align	2
	.globl	push
	.type	push, @function
push:
	lui	a5,%hi(sp)
	lw	a4,%lo(sp)(a5)
	li	a3,191
	lw	a5,0(a4)
	bgtu	a5,a3,.L1177
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a2,a5,1
	slli	a5,a5,2
	sw	a2,0(a4)
	add	a5,a3,a5
	sw	a0,0(a5)
	ret
.L1177:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L1174:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1174
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
	.size	push, .-push
	.align	2
	.globl	dpop
	.type	dpop, @function
dpop:
	lui	a3,%hi(sp)
	lw	a4,%lo(sp)(a3)
	li	a2,1
	lw	a5,0(a4)
	beq	a5,a2,.L1187
	addi	a5,a5,-1
	sw	a5,0(a4)
	li	a3,1
	beq	a5,a3,.L1188
.L1182:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a2,a5,2
	sw	a5,0(a4)
	add	a5,a3,a2
	lw	a0,0(a5)
	ret
.L1187:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a2,234881024
.L1180:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L1180
	lw	a4,%lo(sp)(a3)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,1
	bne	a5,a3,.L1182
.L1188:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L1183:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1183
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	li	a0,0
	ret
	.size	dpop, .-dpop
	.align	2
	.globl	dpush
	.type	dpush, @function
dpush:
	lui	a2,%hi(sp)
	lw	a5,%lo(sp)(a2)
	li	a3,191
	lw	a4,0(a5)
	bgtu	a4,a3,.L1198
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a2,a4,1
	slli	a4,a4,2
	add	a4,a3,a4
	sw	a2,0(a5)
	sw	a0,0(a4)
	lw	a4,0(a5)
	li	a3,191
	bgtu	a4,a3,.L1199
.L1193:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a2,a4,1
	slli	a4,a4,2
	sw	a2,0(a5)
	add	a5,a3,a4
	sw	zero,0(a5)
	ret
.L1198:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L1191:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1191
	lw	a5,%lo(sp)(a2)
	lui	a4,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a4)
	lw	a4,0(a5)
	li	a3,191
	bleu	a4,a3,.L1193
.L1199:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L1194:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1194
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
	.size	dpush, .-dpush
	.align	2
	.globl	rpop
	.type	rpop, @function
rpop:
	lui	a5,%hi(rsp)
	lw	a3,%lo(rsp)(a5)
	li	a4,1
	lw	a5,0(a3)
	beq	a5,a4,.L1205
	lui	a4,%hi(rstack)
	lw	a4,%lo(rstack)(a4)
	addi	a5,a5,-1
	slli	a2,a5,2
	sw	a5,0(a3)
	add	a5,a4,a2
	lw	a0,0(a5)
	ret
.L1205:
	lui	a5,%hi(.LC2)
	li	a4,63
	addi	a5,a5,%lo(.LC2)
	li	a3,234881024
.L1202:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1202
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	li	a0,0
	ret
	.size	rpop, .-rpop
	.align	2
	.globl	rpush
	.type	rpush, @function
rpush:
	lui	a5,%hi(rsp)
	lw	a4,%lo(rsp)(a5)
	li	a3,63
	lw	a5,0(a4)
	bgtu	a5,a3,.L1211
	lui	a3,%hi(rstack)
	lw	a3,%lo(rstack)(a3)
	addi	a2,a5,1
	slli	a5,a5,2
	sw	a2,0(a4)
	add	a5,a3,a5
	sw	a0,0(a5)
	ret
.L1211:
	lui	a5,%hi(.LC1)
	li	a4,63
	addi	a5,a5,%lo(.LC1)
	li	a3,234881024
.L1208:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1208
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
	.size	rpush, .-rpush
	.align	2
	.globl	readMem
	.type	readMem, @function
readMem:
	li	a5,65536
	bgtu	a0,a5,.L1217
	lui	a5,%hi(memory)
	addi	a5,a5,%lo(memory)
	add	a0,a0,a5
	lw	a0,0(a0)
	ret
.L1217:
	lui	a5,%hi(.LC0)
	li	a4,73
	addi	a5,a5,%lo(.LC0)
	li	a3,234881024
.L1214:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1214
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	li	a0,0
	ret
	.size	readMem, .-readMem
	.align	2
	.globl	writeMem
	.type	writeMem, @function
writeMem:
	li	a5,65536
	bgtu	a0,a5,.L1223
	lui	a5,%hi(memory)
	addi	a5,a5,%lo(memory)
	add	a0,a0,a5
	sw	a1,0(a0)
	ret
.L1223:
	lui	a5,%hi(.LC5)
	li	a4,73
	addi	a5,a5,%lo(.LC5)
	li	a3,234881024
.L1220:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1220
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	ret
	.size	writeMem, .-writeMem
	.align	2
	.globl	readWord
	.type	readWord, @function
readWord:
	lui	t3,%hi(positionInLineBuffer)
	lui	a1,%hi(charsInLineBuffer)
	lw	a4,%lo(positionInLineBuffer)(t3)
	lw	a5,%lo(charsInLineBuffer)(a1)
	addi	sp,sp,-16
	lui	a6,%hi(.LANCHOR0)
	sw	s0,12(sp)
	sw	s1,8(sp)
	sw	s2,4(sp)
	addi	a6,a6,%lo(.LANCHOR0)
	lui	a2,%hi(initscript_pos)
	li	t1,251658240
	li	a7,128
	li	a0,10
	li	t4,1
	li	t5,32
	li	t6,92
.L1225:
	blt	a4,a5,.L1261
	sw	zero,%lo(charsInLineBuffer)(a1)
	li	a5,0
.L1238:
	lw	a4,%lo(initscript_pos)(a2)
	lbu	a3,0(a4)
	bne	a3,zero,.L1262
	lbu	a4,0(t1)
.L1241:
	beq	a5,a7,.L1239
	addi	a5,a5,1
	add	a3,a6,a5
	sw	a5,%lo(charsInLineBuffer)(a1)
	sb	a4,-1(a3)
	bne	a4,a0,.L1238
.L1239:
	lbu	a3,0(a6)
	sw	t4,%lo(positionInLineBuffer)(t3)
	li	a4,1
.L1237:
	beq	a3,t5,.L1225
	beq	a3,a0,.L1225
	bne	a3,t6,.L1263
	blt	a4,a5,.L1264
.L1229:
	sw	zero,%lo(charsInLineBuffer)(a1)
	li	a5,0
.L1231:
	lw	a4,%lo(initscript_pos)(a2)
	lbu	a3,0(a4)
	bne	a3,zero,.L1265
	lbu	a4,0(t1)
.L1234:
	beq	a5,a7,.L1232
	addi	a5,a5,1
	add	a3,a6,a5
	sw	a5,%lo(charsInLineBuffer)(a1)
	sb	a4,-1(a3)
	bne	a4,a0,.L1231
.L1232:
	lbu	a3,0(a6)
	sw	t4,%lo(positionInLineBuffer)(t3)
	li	a4,1
	beq	a3,a0,.L1225
.L1260:
	bge	a4,a5,.L1229
.L1264:
	addi	t0,a4,1
	add	a4,a6,a4
	lbu	a3,0(a4)
	sw	t0,%lo(positionInLineBuffer)(t3)
	mv	a4,t0
	bne	a3,a0,.L1260
	j	.L1225
.L1265:
	addi	a3,a4,1
	sw	a3,%lo(initscript_pos)(a2)
	lbu	a4,0(a4)
	j	.L1234
.L1262:
	addi	a3,a4,1
	sw	a3,%lo(initscript_pos)(a2)
	lbu	a4,0(a4)
	j	.L1241
.L1263:
	lui	s2,%hi(memory)
	addi	t6,s2,%lo(memory)
	li	t0,1
	sub	t0,t0,t6
	addi	s0,s2,%lo(memory)
	li	s1,1
	add	a0,t0,t6
	sb	a3,1(t6)
	addi	s0,s0,31
	addi	t4,a6,128
	lui	a2,%hi(initscript_pos)
	li	t5,251658240
	sub	t1,s1,a6
	li	a7,10
	li	t2,32
	andi	a0,a0,0xff
	blt	a4,a5,.L1266
.L1245:
	sw	zero,%lo(charsInLineBuffer)(a1)
	mv	a5,a6
	j	.L1247
.L1248:
	lbu	a4,0(t5)
	add	a3,t1,a5
	beq	a5,t4,.L1250
.L1258:
	sw	a3,%lo(charsInLineBuffer)(a1)
	sb	a4,0(a5)
	addi	a5,a5,1
	beq	a4,a7,.L1250
.L1247:
	lw	a4,%lo(initscript_pos)(a2)
	lbu	a3,0(a4)
	beq	a3,zero,.L1248
	addi	a3,a4,1
	sw	a3,%lo(initscript_pos)(a2)
	lbu	a4,0(a4)
	add	a3,t1,a5
	bne	a5,t4,.L1258
.L1250:
	lbu	a3,0(a6)
	sw	s1,%lo(positionInLineBuffer)(t3)
	li	a4,1
	beq	a3,t2,.L1244
.L1267:
	beq	a3,a7,.L1244
	addi	t6,t6,1
	beq	t6,s0,.L1253
	lw	a5,%lo(charsInLineBuffer)(a1)
	add	a0,t0,t6
	sb	a3,1(t6)
	andi	a0,a0,0xff
	bge	a4,a5,.L1245
.L1266:
	addi	a5,a4,1
	add	a4,a6,a4
	lbu	a3,0(a4)
	sw	a5,%lo(positionInLineBuffer)(t3)
	mv	a4,a5
	bne	a3,t2,.L1267
.L1244:
	lw	s0,12(sp)
	sb	a0,%lo(memory)(s2)
	lw	s1,8(sp)
	lw	s2,4(sp)
	addi	sp,sp,16
	jr	ra
.L1261:
	addi	t0,a4,1
	add	a4,a6,a4
	lbu	a3,0(a4)
	sw	t0,%lo(positionInLineBuffer)(t3)
	mv	a4,t0
	j	.L1237
.L1253:
	lw	s0,12(sp)
	li	a0,31
	sb	a0,%lo(memory)(s2)
	lw	s1,8(sp)
	lw	s2,4(sp)
	addi	sp,sp,16
	jr	ra
	.size	readWord, .-readWord
	.align	2
	.globl	word
	.type	word, @function
word:
	addi	sp,sp,-16
	sw	ra,12(sp)
	call	readWord
	lui	a2,%hi(sp)
	lw	a5,%lo(sp)(a2)
	li	a3,191
	lw	a4,0(a5)
	bgtu	a4,a3,.L1278
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a2,a4,1
	slli	a4,a4,2
	add	a4,a3,a4
	sw	a2,0(a5)
	li	a3,1
	sw	a3,0(a4)
	lw	a4,0(a5)
	li	a3,191
	bgtu	a4,a3,.L1279
.L1272:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	lw	ra,12(sp)
	addi	a2,a4,1
	slli	a4,a4,2
	sw	a2,0(a5)
	add	a5,a3,a4
	sw	a0,0(a5)
	addi	sp,sp,16
	jr	ra
.L1278:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L1270:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1270
	lw	a5,%lo(sp)(a2)
	lui	a4,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a4)
	lw	a4,0(a5)
	li	a3,191
	bleu	a4,a3,.L1272
.L1279:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L1273:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1273
	lw	ra,12(sp)
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	addi	sp,sp,16
	jr	ra
	.size	word, .-word
	.align	2
	.globl	up
	.type	up, @function
up:
	addi	a5,a0,-97
	andi	a5,a5,0xff
	li	a4,25
	bgtu	a5,a4,.L1281
	addi	a0,a0,-32
	andi	a0,a0,0xff
.L1281:
	ret
	.size	up, .-up
	.align	2
	.globl	findWord
	.type	findWord, @function
findWord:
	lui	a5,%hi(latest)
	lw	a5,%lo(latest)(a5)
	lui	t4,%hi(memory)
	addi	t4,t4,%lo(memory)
	lw	a7,0(a5)
	add	a0,t4,a0
	beq	a7,zero,.L1282
	add	t5,a0,a1
	li	t1,25
	li	t6,65536
.L1290:
	add	a5,t4,a7
	lbu	a5,4(a5)
	andi	a4,a5,31
	bne	a4,a1,.L1284
	andi	a5,a5,64
	beq	a5,zero,.L1300
.L1284:
	bgtu	a7,t6,.L1301
	add	a7,t4,a7
	lw	a7,0(a7)
	bne	a7,zero,.L1290
.L1282:
	mv	a0,a7
	ret
.L1300:
	beq	a1,zero,.L1282
	addi	a6,a7,5
	add	a6,t4,a6
	mv	a3,a0
.L1287:
	lbu	a5,0(a6)
	addi	a6,a6,1
	addi	a4,a5,-97
	andi	a4,a4,0xff
	addi	a2,a5,-32
	bgtu	a4,t1,.L1285
	andi	a5,a2,0xff
.L1285:
	lbu	a4,0(a3)
	addi	a3,a3,1
	addi	a2,a4,-97
	andi	a2,a2,0xff
	addi	t3,a4,-32
	bgtu	a2,t1,.L1286
	andi	a4,t3,0xff
.L1286:
	bne	a4,a5,.L1284
	bne	t5,a3,.L1287
	mv	a0,a7
	ret
.L1301:
	lui	a5,%hi(.LC0)
	li	a4,73
	addi	a5,a5,%lo(.LC0)
	li	a3,234881024
.L1289:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1289
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	li	a7,0
	j	.L1282
	.size	findWord, .-findWord
	.align	2
	.globl	find
	.type	find, @function
find:
	addi	sp,sp,-16
	sw	s0,8(sp)
	lui	s0,%hi(sp)
	lw	a4,%lo(sp)(s0)
	sw	ra,12(sp)
	li	a3,1
	lw	a5,0(a4)
	beq	a5,a3,.L1316
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a2,a5,2
	sw	a5,0(a4)
	add	a3,a3,a2
	lw	a1,0(a3)
.L1305:
	li	a3,1
	beq	a5,a3,.L1317
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a2,a5,2
	sw	a5,0(a4)
	add	a5,a3,a2
	lw	a0,0(a5)
.L1308:
	call	findWord
	lw	a4,%lo(sp)(s0)
	li	a3,191
	lw	a5,0(a4)
	bgtu	a5,a3,.L1318
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	lw	ra,12(sp)
	lw	s0,8(sp)
	addi	a2,a5,1
	slli	a5,a5,2
	sw	a2,0(a4)
	add	a5,a3,a5
	sw	a0,0(a5)
	addi	sp,sp,16
	jr	ra
.L1318:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L1310:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1310
	lw	ra,12(sp)
	lw	s0,8(sp)
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	addi	sp,sp,16
	jr	ra
.L1317:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L1307:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1307
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	li	a0,0
	j	.L1308
.L1316:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L1304:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1304
	lw	a4,%lo(sp)(s0)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a1,0
	j	.L1305
	.size	find, .-find
	.section	.rodata.str1.4
	.align	2
.LC6:
	.string	"Unknown word: "
	.align	2
.LC7:
	.string	" OK\n"
	.text
	.align	2
	.globl	quit
	.type	quit, @function
quit:
	addi	sp,sp,-96
	sw	s5,68(sp)
	sw	s7,60(sp)
	sw	s10,48(sp)
	lui	s7,%hi(exitReq)
	lui	s5,%hi(memory)
	lui	s10,%hi(.LANCHOR0)
	sw	s0,88(sp)
	sw	s1,84(sp)
	sw	s2,80(sp)
	sw	s3,76(sp)
	sw	s4,72(sp)
	sw	s6,64(sp)
	sw	s8,56(sp)
	sw	s9,52(sp)
	sw	s11,44(sp)
	sw	ra,92(sp)
	sw	zero,%lo(exitReq)(s7)
	lui	s11,%hi(quit_address)
	lui	s6,%hi(next)
	lui	s9,%hi(lastIp)
	lui	s3,%hi(errorFlag)
	lui	s2,%hi(sp)
	addi	s5,s5,%lo(memory)
	li	s4,191
	lui	s1,%hi(stack)
	li	s0,1
	lui	s8,%hi(.LC3)
	addi	s10,s10,%lo(.LANCHOR0)
.L1400:
	lw	a5,%lo(quit_address)(s11)
	sw	zero,%lo(errorFlag)(s3)
	sw	a5,%lo(next)(s6)
	sw	a5,%lo(lastIp)(s9)
	call	readWord
	lw	a4,%lo(sp)(s2)
	lw	a5,0(a4)
	bgtu	a5,s4,.L1440
	lw	a3,%lo(stack)(s1)
	addi	a2,a5,1
	slli	a5,a5,2
	sw	a2,0(a4)
	add	a5,a3,a5
	sw	s0,0(a5)
.L1322:
	lw	a5,0(a4)
	bgtu	a5,s4,.L1441
	lw	a3,%lo(stack)(s1)
	addi	a2,a5,1
	slli	a5,a5,2
	sw	a2,0(a4)
	add	a5,a3,a5
	sw	a0,0(a5)
	lw	a5,0(a4)
	beq	a5,s0,.L1442
.L1326:
	lw	a3,%lo(stack)(s1)
	addi	a5,a5,-1
	slli	a2,a5,2
	sw	a5,0(a4)
	add	a3,a3,a2
	lw	a1,0(a3)
	beq	a5,s0,.L1443
.L1329:
	lw	a3,%lo(stack)(s1)
	addi	a5,a5,-1
	slli	a2,a5,2
	sw	a5,0(a4)
	add	a5,a3,a2
	lw	a0,0(a5)
.L1331:
	call	findWord
	lw	a4,%lo(sp)(s2)
	lw	a5,0(a4)
	bgtu	a5,s4,.L1444
	lw	a3,%lo(stack)(s1)
	addi	a2,a5,1
	slli	a5,a5,2
	sw	a2,0(a4)
	add	a5,a3,a5
	sw	a0,0(a5)
	lw	a5,0(a4)
	beq	a5,s0,.L1445
.L1335:
	lw	a3,%lo(stack)(s1)
	addi	a5,a5,-1
	slli	a2,a5,2
	sw	a5,0(a4)
	add	a5,a3,a2
	lw	a5,0(a5)
	bne	a5,zero,.L1446
	lbu	a1,0(s5)
	sw	zero,24(sp)
	sb	zero,23(sp)
	beq	a1,zero,.L1447
.L1362:
	lui	a5,%hi(memory+1)
	addi	a4,sp,23
	addi	a0,a5,%lo(memory+1)
	addi	a3,sp,28
	addi	a2,sp,24
	call	parseNumber.part.0.constprop.0
	lw	a4,28(sp)
	lui	a5,%hi(memory+1)
	bne	a4,zero,.L1448
	lui	a5,%hi(state)
	lw	a5,%lo(state)(a5)
	lw	a4,%lo(sp)(s2)
	lw	a1,24(sp)
	lw	a3,0(a5)
	lw	a5,0(a4)
	bne	a3,zero,.L1363
	lbu	a3,23(sp)
	beq	a3,zero,.L1402
	bgtu	a5,s4,.L1449
	lw	a3,%lo(stack)(s1)
	addi	a2,a5,1
	slli	a5,a5,2
	sw	a2,0(a4)
	add	a5,a3,a5
	sw	a1,0(a5)
.L1390:
	lw	a5,0(a4)
	bgtu	a5,s4,.L1450
	lw	a3,%lo(stack)(s1)
	addi	a2,a5,1
	slli	a5,a5,2
	sw	a2,0(a4)
	add	a5,a3,a5
	sw	zero,0(a5)
	lw	a5,%lo(errorFlag)(s3)
.L1355:
	bne	a5,zero,.L1393
.L1356:
	lui	a5,%hi(positionInLineBuffer)
	lw	a4,%lo(positionInLineBuffer)(a5)
	lui	a5,%hi(charsInLineBuffer)
	lw	a5,%lo(charsInLineBuffer)(a5)
	blt	a4,a5,.L1368
	lui	a5,%hi(initscript_pos)
	lw	a5,%lo(initscript_pos)(a5)
	lbu	a5,0(a5)
	beq	a5,zero,.L1451
.L1368:
	lw	a5,%lo(exitReq)(s7)
	beq	a5,zero,.L1400
	lw	ra,92(sp)
	lw	s0,88(sp)
	lw	s1,84(sp)
	lw	s2,80(sp)
	lw	s3,76(sp)
	lw	s4,72(sp)
	lw	s5,68(sp)
	lw	s6,64(sp)
	lw	s7,60(sp)
	lw	s8,56(sp)
	lw	s9,52(sp)
	lw	s10,48(sp)
	lw	s11,44(sp)
	addi	sp,sp,96
	jr	ra
.L1459:
	lui	a5,%hi(.LC0)
	li	a4,73
	addi	a5,a5,%lo(.LC0)
	li	a3,234881024
.L1360:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1360
	lw	a5,%lo(next)(s6)
	sw	s0,%lo(errorFlag)(s3)
	addi	a5,a5,4
	sw	a5,%lo(next)(s6)
.L1393:
	lui	a5,%hi(rsp)
	lw	a4,%lo(rsp)(a5)
	lw	a5,%lo(sp)(s2)
	sw	s0,0(a4)
	sw	s0,0(a5)
	j	.L1368
.L1444:
	li	a4,63
	addi	a5,s8,%lo(.LC3)
	li	a3,234881024
.L1333:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1333
	lw	a4,%lo(sp)(s2)
	sw	s0,%lo(errorFlag)(s3)
	lw	a5,0(a4)
	bne	a5,s0,.L1335
.L1445:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L1336:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1336
	lbu	a1,0(s5)
	sw	s0,%lo(errorFlag)(s3)
	sw	zero,24(sp)
	sb	zero,23(sp)
	bne	a1,zero,.L1362
.L1447:
	lui	a5,%hi(state)
	lw	a5,%lo(state)(a5)
	lw	a4,%lo(sp)(s2)
	sw	zero,28(sp)
	lw	a3,0(a5)
	lw	a5,0(a4)
	bne	a3,zero,.L1363
.L1364:
	bgtu	a5,s4,.L1452
	lw	a2,%lo(stack)(s1)
	addi	a1,a5,1
	slli	a5,a5,2
	sw	a1,0(a4)
	add	a5,a2,a5
	sw	a3,0(a5)
	lw	a5,%lo(errorFlag)(s3)
	j	.L1355
.L1441:
	li	a4,63
	addi	a5,s8,%lo(.LC3)
	li	a3,234881024
.L1324:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1324
	lw	a4,%lo(sp)(s2)
	sw	s0,%lo(errorFlag)(s3)
	lw	a5,0(a4)
	bne	a5,s0,.L1326
.L1442:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L1327:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1327
	lw	a4,%lo(sp)(s2)
	sw	s0,%lo(errorFlag)(s3)
	li	a1,0
	lw	a5,0(a4)
	bne	a5,s0,.L1329
.L1443:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L1330:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1330
	sw	s0,%lo(errorFlag)(s3)
	li	a0,0
	j	.L1331
.L1440:
	li	a4,63
	addi	a5,s8,%lo(.LC3)
	li	a3,234881024
.L1321:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1321
	lw	a4,%lo(sp)(s2)
	sw	s0,%lo(errorFlag)(s3)
	j	.L1322
.L1446:
	addi	a3,a5,4
	add	a5,s5,a3
	lbu	a2,0(a5)
	andi	a5,a2,31
	addi	a5,a5,1
	andi	a4,a5,3
	beq	a4,zero,.L1340
.L1339:
	addi	a5,a5,1
	andi	a4,a5,3
	andi	a5,a5,0xff
	bne	a4,zero,.L1339
.L1340:
	add	a5,a3,a5
	lui	a1,%hi(commandAddress)
	sw	a5,%lo(commandAddress)(a1)
	li	a4,65536
	bgtu	a5,a4,.L1453
	lui	a4,%hi(state)
	lw	a4,%lo(state)(a4)
	add	a5,s5,a5
	lw	a5,0(a5)
	lw	a4,0(a4)
	beq	a4,zero,.L1345
	slli	a2,a2,24
	srai	a2,a2,24
	blt	a2,zero,.L1345
	lw	a3,%lo(sp)(s2)
	addi	a2,a5,-1
	li	a0,69
	lw	a4,0(a3)
	bgtu	a2,a0,.L1348
	bgtu	a4,s4,.L1454
	lw	a2,%lo(stack)(s1)
	addi	a1,a4,1
	slli	a4,a4,2
	sw	a1,0(a3)
	add	a4,a2,a4
	sw	a5,0(a4)
	j	.L1387
.L1363:
	bgtu	a5,s4,.L1455
	lw	a3,%lo(stack)(s1)
	addi	a2,a5,1
	slli	a5,a5,2
	sw	a2,0(a4)
	add	a5,a3,a5
	li	a4,37
	sw	a4,0(a5)
.L1374:
	sw	a1,12(sp)
	call	comma
	lbu	a5,23(sp)
	lw	a4,%lo(sp)(s2)
	beq	a5,zero,.L1375
	lw	a5,0(a4)
	lw	a1,12(sp)
	bgtu	a5,s4,.L1456
	lw	a3,%lo(stack)(s1)
	addi	a2,a5,1
	slli	a5,a5,2
	sw	a2,0(a4)
	add	a5,a3,a5
	sw	a1,0(a5)
	call	comma
	lw	a4,%lo(sp)(s2)
	lw	a5,0(a4)
	bgtu	a5,s4,.L1457
.L1379:
	lw	a3,%lo(stack)(s1)
	addi	a2,a5,1
	slli	a5,a5,2
	sw	a2,0(a4)
	add	a5,a3,a5
	li	a4,37
	sw	a4,0(a5)
	call	comma
	lw	a4,%lo(sp)(s2)
	lw	a5,0(a4)
	bgtu	a5,s4,.L1458
.L1382:
	lw	a3,%lo(stack)(s1)
	addi	a2,a5,1
	slli	a5,a5,2
	sw	a2,0(a4)
	add	a5,a3,a5
	sw	zero,0(a5)
.L1387:
	call	comma
	lw	a5,%lo(errorFlag)(s3)
	j	.L1355
.L1451:
	lui	a5,%hi(.LC7)
	li	a4,32
	addi	a5,a5,%lo(.LC7)
	li	a3,234881024
.L1399:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1399
	j	.L1368
.L1448:
	lui	a4,%hi(.LC6)
	li	a3,85
	addi	a4,a4,%lo(.LC6)
	li	a2,234881024
.L1366:
	addi	a4,a4,1
	sb	a3,0(a2)
	lbu	a3,0(a4)
	bne	a3,zero,.L1366
	lbu	a4,0(s5)
	addi	a5,a5,%lo(memory+1)
	li	a2,234881024
	beq	a4,zero,.L1370
.L1369:
	lbu	a3,0(a5)
	addi	a5,a5,1
	sub	a4,a5,s5
	sb	a3,0(a2)
	lbu	a3,0(s5)
	addi	a4,a4,-1
	bgt	a3,a4,.L1369
.L1370:
	li	a5,234881024
	li	a4,10
	sb	a4,0(a5)
	lui	a5,%hi(rsp)
	lw	a4,%lo(rsp)(a5)
	lw	a5,%lo(sp)(s2)
	sw	s0,0(a4)
	sw	s0,0(a5)
	j	.L1368
.L1345:
	lw	a4,%lo(errorFlag)(s3)
	bne	a4,zero,.L1393
	li	a0,38
	li	a7,70
	li	a6,65536
.L1347:
	lw	a2,%lo(exitReq)(s7)
	slli	a4,a5,2
	add	a3,s10,a4
	mv	a4,a5
	bne	a2,zero,.L1356
	beq	a5,a0,.L1356
	bgtu	a5,a7,.L1357
	lw	a5,128(a3)
	jalr	a5
	lw	a4,%lo(next)(s6)
	lui	a1,%hi(commandAddress)
	li	a0,38
	li	a7,70
	li	a6,65536
.L1358:
	sw	a4,%lo(commandAddress)(a1)
	addi	a3,a4,4
	add	a5,s5,a4
	bgtu	a4,a6,.L1459
	lw	a4,%lo(errorFlag)(s3)
	sw	a3,%lo(next)(s6)
	lw	a5,0(a5)
	beq	a4,zero,.L1347
	j	.L1393
.L1357:
	lw	a3,%lo(next)(s6)
	sw	a5,%lo(next)(s6)
	sw	a3,%lo(lastIp)(s9)
	j	.L1358
.L1375:
	lw	a5,0(a4)
	lw	a2,24(sp)
	bgtu	a5,s4,.L1460
	lw	a3,%lo(stack)(s1)
	addi	a1,a5,1
	slli	a5,a5,2
	sw	a1,0(a4)
	add	a5,a3,a5
	sw	a2,0(a5)
	j	.L1387
.L1453:
	lui	a5,%hi(.LC0)
	li	a4,73
	addi	a5,a5,%lo(.LC0)
	li	a3,234881024
.L1342:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1342
	lui	a5,%hi(state)
	lw	a5,%lo(state)(a5)
	sw	s0,%lo(errorFlag)(s3)
	lw	a5,0(a5)
	beq	a5,zero,.L1393
	slli	a2,a2,24
	srai	a2,a2,24
	li	a5,0
	blt	a2,zero,.L1345
	lw	a3,%lo(sp)(s2)
	lw	a4,0(a3)
.L1348:
	lw	a2,%lo(commandAddress)(a1)
	bgtu	a4,s4,.L1461
	lw	a5,%lo(stack)(s1)
	addi	a1,a4,1
	slli	a4,a4,2
	sw	a1,0(a3)
	add	a5,a5,a4
	sw	a2,0(a5)
	j	.L1387
.L1452:
	li	a4,63
	addi	a5,s8,%lo(.LC3)
	li	a3,234881024
.L1395:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1395
	sw	s0,%lo(errorFlag)(s3)
.L1462:
	lui	a5,%hi(rsp)
	lw	a4,%lo(rsp)(a5)
	lw	a5,%lo(sp)(s2)
	sw	s0,0(a4)
	sw	s0,0(a5)
	j	.L1368
.L1450:
	li	a4,63
	addi	a5,s8,%lo(.LC3)
	li	a3,234881024
.L1392:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1392
	sw	s0,%lo(errorFlag)(s3)
	j	.L1462
.L1449:
	li	a4,63
	addi	a5,s8,%lo(.LC3)
	li	a3,234881024
.L1389:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1389
	lw	a4,%lo(sp)(s2)
	sw	s0,%lo(errorFlag)(s3)
	j	.L1390
.L1455:
	li	a4,63
	addi	a5,s8,%lo(.LC3)
	li	a3,234881024
.L1373:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1373
	sw	s0,%lo(errorFlag)(s3)
	j	.L1374
.L1454:
	li	a4,63
	addi	a5,s8,%lo(.LC3)
	li	a3,234881024
.L1350:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1350
	sw	s0,%lo(errorFlag)(s3)
	j	.L1387
.L1461:
	li	a4,63
	addi	a5,s8,%lo(.LC3)
	li	a3,234881024
.L1353:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1353
	sw	s0,%lo(errorFlag)(s3)
	j	.L1387
.L1402:
	mv	a3,a1
	j	.L1364
.L1460:
	li	a4,63
	addi	a5,s8,%lo(.LC3)
	li	a3,234881024
.L1386:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1386
	sw	s0,%lo(errorFlag)(s3)
	j	.L1387
.L1456:
	li	a4,63
	addi	a5,s8,%lo(.LC3)
	li	a3,234881024
.L1377:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1377
	sw	s0,%lo(errorFlag)(s3)
	call	comma
	lw	a4,%lo(sp)(s2)
	lw	a5,0(a4)
	bleu	a5,s4,.L1379
.L1457:
	li	a4,63
	addi	a5,s8,%lo(.LC3)
	li	a3,234881024
.L1380:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1380
	sw	s0,%lo(errorFlag)(s3)
	call	comma
	lw	a4,%lo(sp)(s2)
	lw	a5,0(a4)
	bleu	a5,s4,.L1382
.L1458:
	li	a4,63
	addi	a5,s8,%lo(.LC3)
	li	a3,234881024
.L1383:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1383
	sw	s0,%lo(errorFlag)(s3)
	j	.L1387
	.size	quit, .-quit
	.align	2
	.globl	tick
	.type	tick, @function
tick:
	addi	sp,sp,-16
	sw	s0,8(sp)
	sw	ra,12(sp)
	lui	s0,%hi(sp)
	call	readWord
	lw	a4,%lo(sp)(s0)
	li	a3,191
	lw	a5,0(a4)
	bgtu	a5,a3,.L1512
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a2,a5,1
	slli	a5,a5,2
	add	a5,a3,a5
	sw	a2,0(a4)
	li	a3,1
	sw	a3,0(a5)
.L1466:
	lw	a5,0(a4)
	li	a3,191
	bgtu	a5,a3,.L1513
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a2,a5,1
	slli	a5,a5,2
	add	a5,a3,a5
	sw	a2,0(a4)
	sw	a0,0(a5)
	lw	a5,0(a4)
	li	a3,1
	beq	a5,a3,.L1514
.L1470:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a2,a5,2
	add	a3,a3,a2
	sw	a5,0(a4)
	lw	a1,0(a3)
	li	a3,1
	beq	a5,a3,.L1515
.L1473:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a2,a5,2
	sw	a5,0(a4)
	add	a5,a3,a2
	lw	a0,0(a5)
	call	findWord
	lw	a4,%lo(sp)(s0)
	li	a3,191
	lw	a5,0(a4)
	bgtu	a5,a3,.L1516
.L1476:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a2,a5,1
	slli	a5,a5,2
	add	a5,a3,a5
	sw	a2,0(a4)
	sw	a0,0(a5)
	lw	a5,0(a4)
	li	a3,1
	beq	a5,a3,.L1517
.L1479:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a2,a5,2
	sw	a5,0(a4)
	add	a5,a3,a2
	lw	a2,0(a5)
	addi	a2,a2,4
.L1481:
	lui	a3,%hi(memory)
	addi	a3,a3,%lo(memory)
	add	a5,a3,a2
	lbu	a5,0(a5)
	andi	a5,a5,31
	addi	a5,a5,1
	andi	a4,a5,3
	beq	a4,zero,.L1484
.L1483:
	addi	a5,a5,1
	andi	a4,a5,3
	andi	a5,a5,0xff
	bne	a4,zero,.L1483
.L1484:
	lui	a4,%hi(maxBuiltinAddress)
	lw	a4,%lo(maxBuiltinAddress)(a4)
	add	a5,a5,a2
	bgeu	a5,a4,.L1485
	li	a4,65536
	bgtu	a5,a4,.L1518
	lw	a4,%lo(sp)(s0)
	add	a3,a3,a5
	lw	a2,0(a3)
	lw	a5,0(a4)
	li	a3,191
	bgtu	a5,a3,.L1519
.L1489:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a1,a5,1
	slli	a5,a5,2
	sw	a1,0(a4)
	add	a5,a3,a5
	sw	a2,0(a5)
.L1491:
	lui	a5,%hi(state)
	lw	a5,%lo(state)(a5)
	lw	a5,0(a5)
	bne	a5,zero,.L1520
.L1463:
	lw	ra,12(sp)
	lw	s0,8(sp)
	addi	sp,sp,16
	jr	ra
.L1518:
	lui	a5,%hi(.LC0)
	li	a4,73
	addi	a5,a5,%lo(.LC0)
	li	a3,234881024
.L1487:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1487
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	lw	a4,%lo(sp)(s0)
	li	a3,191
	li	a2,0
	lw	a5,0(a4)
	bleu	a5,a3,.L1489
.L1519:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L1490:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1490
.L1494:
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	lui	a5,%hi(state)
	lw	a5,%lo(state)(a5)
	lw	a5,0(a5)
	beq	a5,zero,.L1463
.L1520:
	lw	a3,%lo(sp)(s0)
	li	a4,191
	lw	a5,0(a3)
	bgtu	a5,a4,.L1521
	lui	a4,%hi(stack)
	lw	a4,%lo(stack)(a4)
	addi	a2,a5,1
	slli	a5,a5,2
	add	a5,a4,a5
	sw	a2,0(a3)
	li	a4,37
	sw	a4,0(a5)
	call	comma
	lw	s0,8(sp)
	lw	ra,12(sp)
	addi	sp,sp,16
	tail	comma
.L1513:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L1468:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1468
	lw	a4,%lo(sp)(s0)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,1
	bne	a5,a3,.L1470
.L1514:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L1471:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1471
	lw	a4,%lo(sp)(s0)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,1
	li	a1,0
	bne	a5,a3,.L1473
.L1515:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L1474:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1474
	lui	a5,%hi(errorFlag)
	li	a4,1
	li	a0,0
	sw	a4,%lo(errorFlag)(a5)
	call	findWord
	lw	a4,%lo(sp)(s0)
	li	a3,191
	lw	a5,0(a4)
	bleu	a5,a3,.L1476
.L1516:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L1477:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1477
	lw	a4,%lo(sp)(s0)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,1
	bne	a5,a3,.L1479
.L1517:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L1480:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1480
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	li	a2,4
	j	.L1481
.L1512:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L1465:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1465
	lui	a5,%hi(errorFlag)
	li	a3,1
	lw	a4,%lo(sp)(s0)
	sw	a3,%lo(errorFlag)(a5)
	j	.L1466
.L1485:
	lw	a2,%lo(sp)(s0)
	li	a3,191
	lw	a4,0(a2)
	bgtu	a4,a3,.L1522
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a1,a4,1
	slli	a4,a4,2
	sw	a1,0(a2)
	add	a4,a3,a4
	sw	a5,0(a4)
	j	.L1491
.L1522:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L1493:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1493
	j	.L1494
.L1521:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L1497:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1497
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	call	comma
	lw	s0,8(sp)
	lw	ra,12(sp)
	addi	sp,sp,16
	tail	comma
	.size	tick, .-tick
	.align	2
	.globl	parseNumber
	.type	parseNumber, @function
parseNumber:
	sw	zero,0(a2)
	sb	zero,0(a4)
	beq	a1,zero,.L1527
	tail	parseNumber.part.0.constprop.0
.L1527:
	sw	zero,0(a3)
	ret
	.size	parseNumber, .-parseNumber
	.align	2
	.globl	getCfa
	.type	getCfa, @function
getCfa:
	lui	a5,%hi(memory)
	addi	a4,a0,4
	addi	a5,a5,%lo(memory)
	add	a5,a5,a4
	lbu	a0,0(a5)
	andi	a0,a0,31
	addi	a0,a0,1
	andi	a5,a0,3
	beq	a5,zero,.L1531
.L1530:
	addi	a0,a0,1
	andi	a5,a0,3
	andi	a0,a0,0xff
	bne	a5,zero,.L1530
.L1531:
	add	a0,a4,a0
	ret
	.size	getCfa, .-getCfa
	.align	2
	.globl	createWord
	.type	createWord, @function
createWord:
	addi	sp,sp,-32
	sw	s1,20(sp)
	lui	s1,%hi(sp)
	lw	a4,%lo(sp)(s1)
	sw	s0,24(sp)
	sw	s2,16(sp)
	lui	s0,%hi(here)
	lui	s2,%hi(latest)
	lw	a7,%lo(here)(s0)
	lw	a6,%lo(latest)(s2)
	lw	a5,0(a4)
	sw	s3,12(sp)
	sw	s4,8(sp)
	sw	s5,4(sp)
	sw	s6,0(sp)
	sw	ra,28(sp)
	li	a3,191
	lw	s3,0(a7)
	lw	a6,0(a6)
	mv	s4,a0
	mv	s5,a1
	mv	s6,a2
	bgtu	a5,a3,.L1599
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a2,a5,1
	slli	a5,a5,2
	add	a5,a3,a5
	sw	a2,0(a4)
	sw	a6,0(a5)
	call	comma
	lw	a4,%lo(sp)(s1)
	li	a3,191
	lw	a5,0(a4)
	bgtu	a5,a3,.L1600
.L1538:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a2,a5,1
	slli	a5,a5,2
	sw	a2,0(a4)
	add	a5,a3,a5
	or	s6,s5,s6
	sw	s6,0(a5)
	lw	a2,%lo(here)(s0)
	lw	a5,0(a4)
	li	a3,191
	lw	a2,0(a2)
	bgtu	a5,a3,.L1601
.L1541:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a1,a5,1
	slli	a5,a5,2
	add	a5,a3,a5
	sw	a1,0(a4)
	sw	a2,0(a5)
	lw	a5,0(a4)
	li	a3,1
	beq	a5,a3,.L1602
.L1544:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a2,a5,2
	add	a3,a3,a2
	sw	a5,0(a4)
	li	a2,1
	lw	a3,0(a3)
	beq	a5,a2,.L1603
.L1547:
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a5,a5,-1
	slli	a1,a5,2
	sw	a5,0(a4)
	add	a5,a2,a1
	lbu	a5,0(a5)
.L1549:
	lui	a2,%hi(memory)
	lw	a1,%lo(here)(s0)
	addi	a2,a2,%lo(memory)
	add	a4,a2,a3
	sb	a5,0(a4)
	lw	a5,0(a1)
	addi	a5,a5,1
	sw	a5,0(a1)
	beq	s5,zero,.L1550
	add	a1,s4,s5
	li	a7,191
	lui	a0,%hi(stack)
	lui	t4,%hi(.LC3)
	li	a4,234881024
	lui	t3,%hi(errorFlag)
	li	a6,1
	li	t1,1
	lui	t5,%hi(.LC4)
.L1563:
	lw	a3,%lo(sp)(s1)
	lbu	t0,0(s4)
	lw	a5,0(a3)
	bgtu	a5,a7,.L1604
	lw	t6,%lo(stack)(a0)
	addi	t2,a5,1
	slli	a5,a5,2
	sw	t2,0(a3)
	add	a5,t6,a5
	sw	t0,0(a5)
.L1553:
	lw	t6,%lo(here)(s0)
	lw	a5,0(a3)
	lw	t0,0(t6)
	bgtu	a5,a7,.L1605
	lw	t6,%lo(stack)(a0)
	addi	t2,a5,1
	slli	a5,a5,2
	sw	t2,0(a3)
	add	a5,t6,a5
	sw	t0,0(a5)
	lw	a5,0(a3)
	beq	a5,a6,.L1606
.L1557:
	lw	t6,%lo(stack)(a0)
	addi	a5,a5,-1
	slli	t0,a5,2
	sw	a5,0(a3)
	add	t6,t6,t0
	lw	t6,0(t6)
	beq	a5,a6,.L1607
.L1560:
	lw	t0,%lo(stack)(a0)
	addi	a5,a5,-1
	slli	t2,a5,2
	sw	a5,0(a3)
	add	a5,t0,t2
	lbu	a5,0(a5)
.L1562:
	lw	t0,%lo(here)(s0)
	add	a3,a2,t6
	sb	a5,0(a3)
	lw	a5,0(t0)
	addi	s4,s4,1
	addi	a5,a5,1
	sw	a5,0(t0)
	bne	s4,a1,.L1563
.L1550:
	andi	a5,a5,3
	beq	a5,zero,.L1577
	li	a6,191
	lui	a1,%hi(stack)
	lui	t3,%hi(.LC3)
	li	a4,234881024
	lui	t1,%hi(errorFlag)
	li	a0,1
	li	a7,1
	lui	t4,%hi(.LC4)
.L1564:
	lw	a3,%lo(sp)(s1)
	lw	a5,0(a3)
	bgtu	a5,a6,.L1608
	lw	t5,%lo(stack)(a1)
	addi	t6,a5,1
	slli	a5,a5,2
	sw	t6,0(a3)
	add	a5,t5,a5
	sw	zero,0(a5)
.L1567:
	lw	t5,%lo(here)(s0)
	lw	a5,0(a3)
	lw	t6,0(t5)
	bgtu	a5,a6,.L1609
	lw	t5,%lo(stack)(a1)
	addi	t0,a5,1
	slli	a5,a5,2
	sw	t0,0(a3)
	add	a5,t5,a5
	sw	t6,0(a5)
	lw	a5,0(a3)
	beq	a5,a0,.L1610
.L1571:
	lw	t5,%lo(stack)(a1)
	addi	a5,a5,-1
	slli	t6,a5,2
	sw	a5,0(a3)
	add	t5,t5,t6
	lw	t5,0(t5)
	beq	a5,a0,.L1611
.L1574:
	lw	t6,%lo(stack)(a1)
	addi	a5,a5,-1
	slli	t0,a5,2
	sw	a5,0(a3)
	add	a5,t6,t0
	lbu	a5,0(a5)
.L1576:
	lw	t6,%lo(here)(s0)
	add	a3,a2,t5
	sb	a5,0(a3)
	lw	a5,0(t6)
	addi	a5,a5,1
	sw	a5,0(t6)
	andi	a5,a5,3
	bne	a5,zero,.L1564
.L1577:
	lw	a5,%lo(latest)(s2)
	lw	ra,28(sp)
	lw	s0,24(sp)
	sw	s3,0(a5)
	lw	s1,20(sp)
	lw	s2,16(sp)
	lw	s3,12(sp)
	lw	s4,8(sp)
	lw	s5,4(sp)
	lw	s6,0(sp)
	addi	sp,sp,32
	jr	ra
.L1609:
	li	a3,63
	addi	a5,t3,%lo(.LC3)
.L1569:
	addi	a5,a5,1
	sb	a3,0(a4)
	lbu	a3,0(a5)
	bne	a3,zero,.L1569
	lw	a3,%lo(sp)(s1)
	sw	a7,%lo(errorFlag)(t1)
	lw	a5,0(a3)
	bne	a5,a0,.L1571
.L1610:
	li	a3,63
	addi	a5,t4,%lo(.LC4)
.L1572:
	addi	a5,a5,1
	sb	a3,0(a4)
	lbu	a3,0(a5)
	bne	a3,zero,.L1572
	lw	a3,%lo(sp)(s1)
	sw	a7,%lo(errorFlag)(t1)
	li	t5,0
	lw	a5,0(a3)
	bne	a5,a0,.L1574
.L1611:
	li	a5,63
	addi	a3,t4,%lo(.LC4)
.L1575:
	addi	a3,a3,1
	sb	a5,0(a4)
	lbu	a5,0(a3)
	bne	a5,zero,.L1575
	sw	a7,%lo(errorFlag)(t1)
	j	.L1576
.L1608:
	li	a3,63
	addi	a5,t3,%lo(.LC3)
.L1566:
	addi	a5,a5,1
	sb	a3,0(a4)
	lbu	a3,0(a5)
	bne	a3,zero,.L1566
	lw	a3,%lo(sp)(s1)
	sw	a7,%lo(errorFlag)(t1)
	j	.L1567
.L1605:
	li	a3,63
	addi	a5,t4,%lo(.LC3)
.L1555:
	addi	a5,a5,1
	sb	a3,0(a4)
	lbu	a3,0(a5)
	bne	a3,zero,.L1555
	lw	a3,%lo(sp)(s1)
	sw	t1,%lo(errorFlag)(t3)
	lw	a5,0(a3)
	bne	a5,a6,.L1557
.L1606:
	li	a3,63
	addi	a5,t5,%lo(.LC4)
.L1558:
	addi	a5,a5,1
	sb	a3,0(a4)
	lbu	a3,0(a5)
	bne	a3,zero,.L1558
	lw	a3,%lo(sp)(s1)
	sw	t1,%lo(errorFlag)(t3)
	li	t6,0
	lw	a5,0(a3)
	bne	a5,a6,.L1560
.L1607:
	li	a5,63
	addi	a3,t5,%lo(.LC4)
.L1561:
	addi	a3,a3,1
	sb	a5,0(a4)
	lbu	a5,0(a3)
	bne	a5,zero,.L1561
	sw	t1,%lo(errorFlag)(t3)
	j	.L1562
.L1604:
	li	a3,63
	addi	a5,t4,%lo(.LC3)
.L1552:
	addi	a5,a5,1
	sb	a3,0(a4)
	lbu	a3,0(a5)
	bne	a3,zero,.L1552
	lw	a3,%lo(sp)(s1)
	sw	t1,%lo(errorFlag)(t3)
	j	.L1553
.L1599:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L1536:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1536
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	call	comma
	lw	a4,%lo(sp)(s1)
	li	a3,191
	lw	a5,0(a4)
	bleu	a5,a3,.L1538
.L1600:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L1539:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1539
	lw	a4,%lo(sp)(s1)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a2,%lo(here)(s0)
	lw	a5,0(a4)
	li	a3,191
	lw	a2,0(a2)
	bleu	a5,a3,.L1541
.L1601:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L1542:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1542
	lw	a4,%lo(sp)(s1)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,1
	bne	a5,a3,.L1544
.L1602:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L1545:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1545
	lw	a4,%lo(sp)(s1)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a2,1
	li	a3,0
	bne	a5,a2,.L1547
.L1603:
	lui	a4,%hi(.LC4)
	li	a5,63
	addi	a4,a4,%lo(.LC4)
	li	a2,234881024
.L1548:
	addi	a4,a4,1
	sb	a5,0(a2)
	lbu	a5,0(a4)
	bne	a5,zero,.L1548
	lui	a4,%hi(errorFlag)
	li	a2,1
	sw	a2,%lo(errorFlag)(a4)
	j	.L1549
	.size	createWord, .-createWord
	.align	2
	.globl	doCreate
	.type	doCreate, @function
doCreate:
	addi	sp,sp,-16
	sw	ra,12(sp)
	call	readWord
	lui	a2,%hi(sp)
	lw	a4,%lo(sp)(a2)
	li	a3,191
	lw	a5,0(a4)
	bgtu	a5,a3,.L1630
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a1,a5,1
	slli	a5,a5,2
	add	a5,a3,a5
	sw	a1,0(a4)
	li	a3,1
	sw	a3,0(a5)
	lw	a5,0(a4)
	li	a3,191
	bgtu	a5,a3,.L1631
.L1616:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a1,a5,1
	slli	a5,a5,2
	add	a5,a3,a5
	sw	a1,0(a4)
	sw	a0,0(a5)
	lw	a5,0(a4)
	li	a3,1
	beq	a5,a3,.L1632
.L1619:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a2,a5,2
	add	a3,a3,a2
	sw	a5,0(a4)
	lbu	a1,0(a3)
	li	a3,1
	beq	a5,a3,.L1633
.L1622:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a2,a5,2
	sw	a5,0(a4)
	add	a5,a3,a2
	lw	a0,0(a5)
	lw	ra,12(sp)
	lui	a5,%hi(memory)
	addi	a5,a5,%lo(memory)
	add	a0,a0,a5
	li	a2,0
	addi	sp,sp,16
	tail	createWord
.L1630:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L1614:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1614
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,191
	bleu	a5,a3,.L1616
.L1631:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L1617:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1617
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,1
	bne	a5,a3,.L1619
.L1632:
	lui	a5,%hi(.LC4)
	li	a1,63
	addi	a5,a5,%lo(.LC4)
	li	a4,234881024
.L1620:
	addi	a5,a5,1
	sb	a1,0(a4)
	lbu	a1,0(a5)
	bne	a1,zero,.L1620
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,1
	bne	a5,a3,.L1622
.L1633:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L1623:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1623
	lw	ra,12(sp)
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	lui	a0,%hi(memory)
	addi	a0,a0,%lo(memory)
	li	a2,0
	addi	sp,sp,16
	tail	createWord
	.size	doCreate, .-doCreate
	.section	.rodata.str1.4
	.align	2
.LC8:
	.string	"Error adding builtin "
	.align	2
.LC9:
	.string	": ID given twice\n"
	.text
	.align	2
	.type	addBuiltin.part.0, @function
addBuiltin.part.0:
	lui	a5,%hi(.LANCHOR0)
	slli	a4,a0,2
	addi	a5,a5,%lo(.LANCHOR0)
	add	a5,a5,a4
	lw	a4,128(a5)
	addi	sp,sp,-16
	sw	s0,8(sp)
	sw	ra,12(sp)
	mv	s0,a0
	mv	a0,a1
	beq	a4,zero,.L1635
	lui	a5,%hi(.LC8)
	li	a4,69
	addi	a5,a5,%lo(.LC8)
	li	a3,234881024
.L1636:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1636
	lbu	a5,0(a0)
	li	a4,234881024
	beq	a5,zero,.L1639
.L1637:
	addi	a0,a0,1
	sb	a5,0(a4)
	lbu	a5,0(a0)
	bne	a5,zero,.L1637
.L1639:
	lui	a5,%hi(.LC9)
	li	a4,58
	addi	a5,a5,%lo(.LC9)
	li	a3,234881024
.L1638:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1638
	lw	ra,12(sp)
	lw	s0,8(sp)
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	addi	sp,sp,16
	jr	ra
.L1635:
	sw	a3,128(a5)
	lbu	a1,0(a1)
	addi	a4,a0,1
	beq	a1,zero,.L1641
	li	a6,1
	sub	a6,a6,a4
.L1642:
	lbu	a3,0(a4)
	add	a5,a4,a6
	andi	a1,a5,0xff
	addi	a4,a4,1
	bne	a3,zero,.L1642
.L1641:
	call	createWord
	lui	a2,%hi(sp)
	lw	a4,%lo(sp)(a2)
	li	a3,191
	lw	a5,0(a4)
	bgtu	a5,a3,.L1677
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a1,a5,1
	slli	a5,a5,2
	sw	a1,0(a4)
	add	a5,a3,a5
	sw	s0,0(a5)
	lui	a0,%hi(here)
	lw	a1,%lo(here)(a0)
	lw	a5,0(a4)
	li	a3,191
	lw	a1,0(a1)
	bgtu	a5,a3,.L1678
.L1646:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a6,a5,1
	slli	a5,a5,2
	sw	a6,0(a4)
	add	a5,a3,a5
	sw	a1,0(a5)
.L1648:
	lw	a5,0(a4)
	li	a3,1
	beq	a5,a3,.L1679
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a1,a5,2
	sw	a5,0(a4)
	add	a3,a3,a1
	lw	a3,0(a3)
.L1651:
	li	a1,1
	beq	a5,a1,.L1680
	lui	a1,%hi(stack)
	lw	a1,%lo(stack)(a1)
	addi	a5,a5,-1
	slli	a6,a5,2
	sw	a5,0(a4)
	add	a5,a1,a6
	lw	a4,0(a5)
.L1654:
	li	a5,65536
	bgtu	a3,a5,.L1681
	lui	a5,%hi(memory)
	addi	a5,a5,%lo(memory)
	add	a3,a3,a5
	sw	a4,0(a3)
.L1657:
	lw	a4,%lo(here)(a0)
	lw	a3,%lo(sp)(a2)
	li	a2,191
	lw	a5,0(a4)
	addi	a5,a5,4
	sw	a5,0(a4)
	lw	a5,0(a3)
	bgtu	a5,a2,.L1682
	lui	a4,%hi(stack)
	lw	a4,%lo(stack)(a4)
	lw	s0,8(sp)
	addi	a2,a5,1
	slli	a5,a5,2
	lw	ra,12(sp)
	sw	a2,0(a3)
	add	a5,a4,a5
	li	a4,7
	sw	a4,0(a5)
	addi	sp,sp,16
	tail	comma
.L1677:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L1644:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1644
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lui	a0,%hi(here)
	lw	a1,%lo(here)(a0)
	lw	a5,0(a4)
	li	a3,191
	lw	a1,0(a1)
	bleu	a5,a3,.L1646
.L1678:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L1647:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1647
	lui	a5,%hi(errorFlag)
	li	a3,1
	lw	a4,%lo(sp)(a2)
	sw	a3,%lo(errorFlag)(a5)
	j	.L1648
.L1682:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L1659:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1659
	lw	s0,8(sp)
	lw	ra,12(sp)
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	addi	sp,sp,16
	tail	comma
.L1681:
	lui	a5,%hi(.LC5)
	li	a4,73
	addi	a5,a5,%lo(.LC5)
	li	a3,234881024
.L1656:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1656
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	j	.L1657
.L1680:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a1,234881024
.L1653:
	addi	a5,a5,1
	sb	a4,0(a1)
	lbu	a4,0(a5)
	bne	a4,zero,.L1653
	li	a4,1
	lui	a5,%hi(errorFlag)
	sw	a4,%lo(errorFlag)(a5)
	li	a4,0
	j	.L1654
.L1679:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L1650:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1650
	lw	a4,%lo(sp)(a2)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,0
	j	.L1651
	.size	addBuiltin.part.0, .-addBuiltin.part.0
	.align	2
	.globl	colon
	.type	colon, @function
colon:
	addi	sp,sp,-16
	sw	s1,4(sp)
	sw	ra,12(sp)
	sw	s0,8(sp)
	lui	s1,%hi(sp)
	call	readWord
	lw	a4,%lo(sp)(s1)
	li	a3,191
	lw	a5,0(a4)
	bgtu	a5,a3,.L1721
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a2,a5,1
	slli	a5,a5,2
	add	a5,a3,a5
	sw	a2,0(a4)
	li	a3,1
	sw	a3,0(a5)
	lw	a5,0(a4)
	li	a3,191
	bgtu	a5,a3,.L1722
.L1687:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a2,a5,1
	slli	a5,a5,2
	add	a5,a3,a5
	sw	a2,0(a4)
	sw	a0,0(a5)
	lw	a5,0(a4)
	li	a3,1
	beq	a5,a3,.L1723
.L1690:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a2,a5,2
	add	a3,a3,a2
	sw	a5,0(a4)
	lbu	a1,0(a3)
	li	a3,1
	beq	a5,a3,.L1724
.L1693:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a2,a5,2
	sw	a5,0(a4)
	add	a5,a3,a2
	lw	a0,0(a5)
	lui	a5,%hi(memory)
	addi	s0,a5,%lo(memory)
	add	a0,s0,a0
	li	a2,0
	call	createWord
	lw	a4,%lo(sp)(s1)
	li	a3,191
	lw	a5,0(a4)
	bgtu	a5,a3,.L1725
.L1696:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a2,a5,1
	slli	a5,a5,2
	sw	a2,0(a4)
	add	a5,a3,a5
	sw	zero,0(a5)
	lui	a1,%hi(here)
	lw	a2,%lo(here)(a1)
	lw	a5,0(a4)
	li	a3,191
	lw	a2,0(a2)
	bgtu	a5,a3,.L1726
.L1699:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a0,a5,1
	slli	a5,a5,2
	add	a5,a3,a5
	sw	a0,0(a4)
	sw	a2,0(a5)
	lw	a5,0(a4)
	li	a3,1
	beq	a5,a3,.L1727
.L1702:
	lui	a3,%hi(stack)
	lw	a3,%lo(stack)(a3)
	addi	a5,a5,-1
	slli	a2,a5,2
	add	a3,a3,a2
	sw	a5,0(a4)
	li	a2,1
	lw	a3,0(a3)
	beq	a5,a2,.L1728
.L1705:
	lui	a2,%hi(stack)
	lw	a2,%lo(stack)(a2)
	addi	a5,a5,-1
	slli	a0,a5,2
	sw	a5,0(a4)
	add	a5,a2,a0
	lw	a4,0(a5)
	li	a5,65536
	bgtu	a3,a5,.L1729
.L1708:
	add	a3,s0,a3
	sw	a4,0(a3)
.L1710:
	lw	a4,%lo(here)(a1)
	lui	a5,%hi(latest)
	lw	a2,%lo(latest)(a5)
	lw	a5,0(a4)
	lui	a3,%hi(state)
	lw	a3,%lo(state)(a3)
	addi	a5,a5,4
	sw	a5,0(a4)
	lw	a5,0(a2)
	addi	a5,a5,4
	add	s0,s0,a5
	lbu	a5,0(s0)
	xori	a5,a5,64
	sb	a5,0(s0)
	lw	ra,12(sp)
	lw	s0,8(sp)
	li	a5,1
	sw	a5,0(a3)
	lw	s1,4(sp)
	addi	sp,sp,16
	jr	ra
.L1721:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L1685:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1685
	lw	a4,%lo(sp)(s1)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,191
	bleu	a5,a3,.L1687
.L1722:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L1688:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1688
	lw	a4,%lo(sp)(s1)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,1
	bne	a5,a3,.L1690
.L1723:
	lui	a5,%hi(.LC4)
	li	a1,63
	addi	a5,a5,%lo(.LC4)
	li	a4,234881024
.L1691:
	addi	a5,a5,1
	sb	a1,0(a4)
	lbu	a1,0(a5)
	bne	a1,zero,.L1691
	lw	a4,%lo(sp)(s1)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,1
	bne	a5,a3,.L1693
.L1724:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L1694:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1694
	lui	a5,%hi(memory)
	lui	a4,%hi(errorFlag)
	li	a3,1
	addi	a0,a5,%lo(memory)
	li	a2,0
	sw	a3,%lo(errorFlag)(a4)
	addi	s0,a5,%lo(memory)
	call	createWord
	lw	a4,%lo(sp)(s1)
	li	a3,191
	lw	a5,0(a4)
	bleu	a5,a3,.L1696
.L1725:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L1697:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1697
	lw	a4,%lo(sp)(s1)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lui	a1,%hi(here)
	lw	a2,%lo(here)(a1)
	lw	a5,0(a4)
	li	a3,191
	lw	a2,0(a2)
	bleu	a5,a3,.L1699
.L1726:
	lui	a5,%hi(.LC3)
	li	a4,63
	addi	a5,a5,%lo(.LC3)
	li	a3,234881024
.L1700:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1700
	lw	a4,%lo(sp)(s1)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a3,1
	bne	a5,a3,.L1702
.L1727:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a3,234881024
.L1703:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1703
	lw	a4,%lo(sp)(s1)
	lui	a5,%hi(errorFlag)
	li	a3,1
	sw	a3,%lo(errorFlag)(a5)
	lw	a5,0(a4)
	li	a2,1
	li	a3,0
	bne	a5,a2,.L1705
.L1728:
	lui	a5,%hi(.LC4)
	li	a4,63
	addi	a5,a5,%lo(.LC4)
	li	a2,234881024
.L1706:
	addi	a5,a5,1
	sb	a4,0(a2)
	lbu	a4,0(a5)
	bne	a4,zero,.L1706
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	li	a5,65536
	li	a4,0
	bleu	a3,a5,.L1708
.L1729:
	lui	a5,%hi(.LC5)
	li	a4,73
	addi	a5,a5,%lo(.LC5)
	li	a3,234881024
.L1709:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1709
	lui	a5,%hi(errorFlag)
	li	a4,1
	sw	a4,%lo(errorFlag)(a5)
	j	.L1710
	.size	colon, .-colon
	.align	2
	.globl	slen
	.type	slen, @function
slen:
	mv	a5,a0
	lbu	a0,0(a0)
	addi	a5,a5,1
	beq	a0,zero,.L1731
	li	a3,1
	sub	a3,a3,a5
.L1732:
	lbu	a4,0(a5)
	add	a0,a5,a3
	andi	a0,a0,0xff
	addi	a5,a5,1
	bne	a4,zero,.L1732
.L1731:
	ret
	.size	slen, .-slen
	.section	.rodata.str1.4
	.align	2
.LC10:
	.string	": Out of builtin IDs\n"
	.text
	.align	2
	.globl	addBuiltin
	.type	addBuiltin, @function
addBuiltin:
	lui	a6,%hi(errorFlag)
	lw	a7,%lo(errorFlag)(a6)
	mv	a5,a1
	bne	a7,zero,.L1737
	li	a7,70
	bgtu	a0,a7,.L1750
	tail	addBuiltin.part.0
.L1737:
	ret
.L1750:
	lui	a4,%hi(.LC8)
	li	a3,69
	addi	a4,a4,%lo(.LC8)
	li	a2,234881024
.L1740:
	addi	a4,a4,1
	sb	a3,0(a2)
	lbu	a3,0(a4)
	bne	a3,zero,.L1740
	lbu	a4,0(a5)
	beq	a4,zero,.L1741
	li	a3,234881024
.L1742:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1742
.L1741:
	lui	a5,%hi(.LC10)
	li	a4,58
	addi	a5,a5,%lo(.LC10)
	li	a3,234881024
.L1743:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1743
	li	a5,1
	sw	a5,%lo(errorFlag)(a6)
	ret
	.size	addBuiltin, .-addBuiltin
	.section	.rodata.str1.4
	.align	2
.LC11:
	.string	"Configuration error: DCELL_SIZE != 2*CELL_SIZE\n"
	.section	.text.startup,"ax",@progbits
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-32
	sw	s0,24(sp)
	lui	a5,%hi(.LC11)
	lui	s0,%hi(errorFlag)
	sw	ra,28(sp)
	sw	s1,20(sp)
	sw	s2,16(sp)
	sw	s3,12(sp)
	sw	zero,%lo(errorFlag)(s0)
	li	a4,67
	addi	a5,a5,%lo(.LC11)
	li	a3,234881024
.L1752:
	addi	a5,a5,1
	sb	a4,0(a3)
	lbu	a4,0(a5)
	bne	a4,zero,.L1752
	lui	a5,%hi(memory+44)
	lui	a2,%hi(state)
	addi	a5,a5,%lo(memory+44)
	sw	a5,%lo(state)(a2)
	lui	a5,%hi(memory+40)
	lui	a2,%hi(base)
	addi	a5,a5,%lo(memory+40)
	sw	a5,%lo(base)(a2)
	lui	a5,%hi(memory+32)
	addi	a5,a5,%lo(memory+32)
	lui	s3,%hi(latest)
	sw	a5,%lo(latest)(s3)
	lui	a5,%hi(memory+36)
	addi	a5,a5,%lo(memory+36)
	lui	s2,%hi(here)
	sw	a5,%lo(here)(s2)
	lui	a5,%hi(memory+48)
	lui	a2,%hi(sp)
	addi	a5,a5,%lo(memory+48)
	sw	a5,%lo(sp)(a2)
	lui	a5,%hi(memory+52)
	lui	a2,%hi(stack)
	addi	a5,a5,%lo(memory+52)
	sw	a5,%lo(stack)(a2)
	lui	a5,%hi(memory+816)
	lui	a2,%hi(rsp)
	addi	a5,a5,%lo(memory+816)
	sw	a5,%lo(rsp)(a2)
	lui	a5,%hi(memory+820)
	addi	a5,a5,%lo(memory+820)
	lui	s1,%hi(memory)
	lui	a2,%hi(rstack)
	addi	s1,s1,%lo(memory)
	sw	a5,%lo(rstack)(a2)
	lw	a3,%lo(errorFlag)(s0)
	li	a5,10
	li	a4,1
	sw	a5,40(s1)
	li	a5,1072
	sw	a5,36(s1)
	sw	a4,816(s1)
	lui	a5,%hi(docol_name)
	sw	a4,48(s1)
	sw	zero,44(s1)
	sw	zero,32(s1)
	lw	a1,%lo(docol_name)(a5)
	bne	a3,zero,.L1827
	lui	a3,%hi(docol)
	addi	a3,a3,%lo(docol)
	li	a2,0
	li	a0,0
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(doCellSize_name)
	lw	a1,%lo(doCellSize_name)(a4)
	bne	a5,zero,.L1827
	lui	a3,%hi(doCellSize)
	addi	a3,a3,%lo(doCellSize)
	li	a2,0
	li	a0,1
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(memRead_name)
	lw	a1,%lo(memRead_name)(a4)
	bne	a5,zero,.L1827
	lui	a3,%hi(memRead)
	addi	a3,a3,%lo(memRead)
	li	a2,0
	li	a0,2
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(memWrite_name)
	lw	a1,%lo(memWrite_name)(a4)
	bne	a5,zero,.L1827
	lui	a3,%hi(memWrite)
	addi	a3,a3,%lo(memWrite)
	li	a2,0
	li	a0,27
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(memReadByte_name)
	lw	a1,%lo(memReadByte_name)(a4)
	bne	a5,zero,.L1827
	lui	a3,%hi(memReadByte)
	addi	a3,a3,%lo(memReadByte)
	li	a2,0
	li	a0,3
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(memWriteByte_name)
	lw	a1,%lo(memWriteByte_name)(a4)
	bne	a5,zero,.L1827
	lui	a3,%hi(memWriteByte)
	addi	a3,a3,%lo(memWriteByte)
	li	a2,0
	li	a0,28
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(key_name)
	lw	a1,%lo(key_name)(a4)
	bne	a5,zero,.L1827
	lui	a3,%hi(key)
	addi	a3,a3,%lo(key)
	li	a2,0
	li	a0,4
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(emit_name)
	lw	a1,%lo(emit_name)(a4)
	bne	a5,zero,.L1827
	lui	a3,%hi(emit)
	addi	a3,a3,%lo(emit)
	li	a2,0
	li	a0,5
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(swap_name)
	lw	a1,%lo(swap_name)(a4)
	bne	a5,zero,.L1827
	lui	a3,%hi(swap)
	addi	a3,a3,%lo(swap)
	li	a2,0
	li	a0,29
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(dup_name)
	lw	a1,%lo(dup_name)(a4)
	bne	a5,zero,.L1827
	lui	a3,%hi(dup)
	addi	a3,a3,%lo(dup)
	li	a2,0
	li	a0,26
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(drop_name)
	lw	a1,%lo(drop_name)(a4)
	bne	a5,zero,.L1827
	lui	a3,%hi(drop)
	addi	a3,a3,%lo(drop)
	li	a2,0
	li	a0,6
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(over_name)
	lw	a1,%lo(over_name)(a4)
	bne	a5,zero,.L1827
	lui	a3,%hi(over)
	addi	a3,a3,%lo(over)
	li	a2,0
	li	a0,30
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(comma_name)
	lw	a1,%lo(comma_name)(a4)
	bne	a5,zero,.L1827
	lui	a3,%hi(comma)
	addi	a3,a3,%lo(comma)
	li	a2,0
	li	a0,31
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(commaByte_name)
	lw	a1,%lo(commaByte_name)(a4)
	bne	a5,zero,.L1827
	lui	a3,%hi(commaByte)
	addi	a3,a3,%lo(commaByte)
	li	a2,0
	li	a0,32
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(word_name)
	lw	a1,%lo(word_name)(a4)
	bne	a5,zero,.L1827
	lui	a3,%hi(word)
	addi	a3,a3,%lo(word)
	li	a2,0
	li	a0,33
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(find_name)
	lw	a1,%lo(find_name)(a4)
	bne	a5,zero,.L1827
	lui	a3,%hi(find)
	addi	a3,a3,%lo(find)
	li	a2,0
	li	a0,34
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(cfa_name)
	lw	a1,%lo(cfa_name)(a4)
	bne	a5,zero,.L1827
	lui	a3,%hi(cfa)
	addi	a3,a3,%lo(cfa)
	li	a2,0
	li	a0,35
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(doExit_name)
	lw	a1,%lo(doExit_name)(a4)
	bne	a5,zero,.L1827
	lui	a3,%hi(doExit)
	addi	a3,a3,%lo(doExit)
	li	a2,0
	li	a0,7
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(quit_name)
	lw	a1,%lo(quit_name)(a4)
	bne	a5,zero,.L1827
	lui	a3,%hi(quit)
	addi	a3,a3,%lo(quit)
	li	a2,0
	li	a0,38
	call	addBuiltin.part.0
.L1827:
	lw	a5,%lo(latest)(s3)
	lw	a3,0(a5)
	addi	a3,a3,4
	add	s1,s1,a3
	lbu	a5,0(s1)
	andi	a5,a5,31
	addi	a5,a5,1
	andi	a4,a5,3
	beq	a4,zero,.L1773
.L1772:
	addi	a5,a5,1
	andi	a4,a5,3
	andi	a5,a5,0xff
	bne	a4,zero,.L1772
.L1773:
	lw	a4,%lo(errorFlag)(s0)
	add	a3,a3,a5
	lui	a5,%hi(quit_address)
	sw	a3,%lo(quit_address)(a5)
	lui	a5,%hi(number_name)
	lw	a1,%lo(number_name)(a5)
	bne	a4,zero,.L1826
	lui	a3,%hi(number)
	addi	a3,a3,%lo(number)
	li	a2,0
	li	a0,36
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(bye_name)
	lw	a1,%lo(bye_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(bye)
	addi	a3,a3,%lo(bye)
	li	a2,0
	li	a0,8
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(doLatest_name)
	lw	a1,%lo(doLatest_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(doLatest)
	addi	a3,a3,%lo(doLatest)
	li	a2,0
	li	a0,9
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(doHere_name)
	lw	a1,%lo(doHere_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(doHere)
	addi	a3,a3,%lo(doHere)
	li	a2,0
	li	a0,10
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(doBase_name)
	lw	a1,%lo(doBase_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(doBase)
	addi	a3,a3,%lo(doBase)
	li	a2,0
	li	a0,11
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(doState_name)
	lw	a1,%lo(doState_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(doState)
	addi	a3,a3,%lo(doState)
	li	a2,0
	li	a0,12
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(plus_name)
	lw	a1,%lo(plus_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(plus)
	addi	a3,a3,%lo(plus)
	li	a2,0
	li	a0,39
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(minus_name)
	lw	a1,%lo(minus_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(minus)
	addi	a3,a3,%lo(minus)
	li	a2,0
	li	a0,40
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(mul_name)
	lw	a1,%lo(mul_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(mul)
	addi	a3,a3,%lo(mul)
	li	a2,0
	li	a0,41
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(divmod_name)
	lw	a1,%lo(divmod_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(divmod)
	addi	a3,a3,%lo(divmod)
	li	a2,0
	li	a0,42
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(rot_name)
	lw	a1,%lo(rot_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(rot)
	addi	a3,a3,%lo(rot)
	li	a2,0
	li	a0,43
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(gotoInterpreter_name)
	lw	a1,%lo(gotoInterpreter_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(gotoInterpreter)
	addi	a3,a3,%lo(gotoInterpreter)
	li	a2,128
	li	a0,13
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(gotoCompiler_name)
	lw	a1,%lo(gotoCompiler_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(gotoCompiler)
	addi	a3,a3,%lo(gotoCompiler)
	li	a2,0
	li	a0,14
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(doCreate_name)
	lw	a1,%lo(doCreate_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(doCreate)
	addi	a3,a3,%lo(doCreate)
	li	a2,0
	li	a0,44
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(hide_name)
	lw	a1,%lo(hide_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(hide)
	addi	a3,a3,%lo(hide)
	li	a2,0
	li	a0,15
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(lit_name)
	lw	a1,%lo(lit_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(lit)
	addi	a3,a3,%lo(lit)
	li	a2,0
	li	a0,37
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(colon_name)
	lw	a1,%lo(colon_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(colon)
	addi	a3,a3,%lo(colon)
	li	a2,0
	li	a0,45
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(semicolon_name)
	lw	a1,%lo(semicolon_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(semicolon)
	addi	a3,a3,%lo(semicolon)
	li	a2,128
	li	a0,46
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(rtos_name)
	lw	a1,%lo(rtos_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(rtos)
	addi	a3,a3,%lo(rtos)
	li	a2,0
	li	a0,16
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(stor_name)
	lw	a1,%lo(stor_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(stor)
	addi	a3,a3,%lo(stor)
	li	a2,0
	li	a0,17
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(rget_name)
	lw	a1,%lo(rget_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(rget)
	addi	a3,a3,%lo(rget)
	li	a2,0
	li	a0,47
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(doJ_name)
	lw	a1,%lo(doJ_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(doJ)
	addi	a3,a3,%lo(doJ)
	li	a2,0
	li	a0,48
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(tick_name)
	lw	a1,%lo(tick_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(tick)
	addi	a3,a3,%lo(tick)
	li	a2,128
	li	a0,49
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(key_p_name)
	lw	a1,%lo(key_p_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(key_p)
	addi	a3,a3,%lo(key_p)
	li	a2,0
	li	a0,18
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(equals_name)
	lw	a1,%lo(equals_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(equals)
	addi	a3,a3,%lo(equals)
	li	a2,0
	li	a0,50
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(smaller_name)
	lw	a1,%lo(smaller_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(smaller)
	addi	a3,a3,%lo(smaller)
	li	a2,0
	li	a0,51
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(larger_name)
	lw	a1,%lo(larger_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(larger)
	addi	a3,a3,%lo(larger)
	li	a2,0
	li	a0,52
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(doAnd_name)
	lw	a1,%lo(doAnd_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(doAnd)
	addi	a3,a3,%lo(doAnd)
	li	a2,0
	li	a0,53
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(doOr_name)
	lw	a1,%lo(doOr_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(doOr)
	addi	a3,a3,%lo(doOr)
	li	a2,0
	li	a0,54
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(branch_name)
	lw	a1,%lo(branch_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(branch)
	addi	a3,a3,%lo(branch)
	li	a2,0
	li	a0,19
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(zbranch_name)
	lw	a1,%lo(zbranch_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(zbranch)
	addi	a3,a3,%lo(zbranch)
	li	a2,0
	li	a0,20
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(toggleImmediate_name)
	lw	a1,%lo(toggleImmediate_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(toggleImmediate)
	addi	a3,a3,%lo(toggleImmediate)
	li	a2,128
	li	a0,21
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(doFree_name)
	lw	a1,%lo(doFree_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(doFree)
	addi	a3,a3,%lo(doFree)
	li	a2,0
	li	a0,22
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(p_dup_name)
	lw	a1,%lo(p_dup_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(p_dup)
	addi	a3,a3,%lo(p_dup)
	li	a2,0
	li	a0,55
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(s0_r_name)
	lw	a1,%lo(s0_r_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(s0_r)
	addi	a3,a3,%lo(s0_r)
	li	a2,0
	li	a0,23
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(dsp_r_name)
	lw	a1,%lo(dsp_r_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(dsp_r)
	addi	a3,a3,%lo(dsp_r)
	li	a2,0
	li	a0,24
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(litstring_name)
	lw	a1,%lo(litstring_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(litstring)
	addi	a3,a3,%lo(litstring)
	li	a2,0
	li	a0,56
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(not_name)
	lw	a1,%lo(not_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(not)
	addi	a3,a3,%lo(not)
	li	a2,0
	li	a0,25
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(xor_name)
	lw	a1,%lo(xor_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(xor)
	addi	a3,a3,%lo(xor)
	li	a2,0
	li	a0,57
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(timesDivide_name)
	lw	a1,%lo(timesDivide_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(timesDivide)
	addi	a3,a3,%lo(timesDivide)
	li	a2,0
	li	a0,58
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(timesDivideMod_name)
	lw	a1,%lo(timesDivideMod_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(timesDivideMod)
	addi	a3,a3,%lo(timesDivideMod)
	li	a2,0
	li	a0,59
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(dequals_name)
	lw	a1,%lo(dequals_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(dequals)
	addi	a3,a3,%lo(dequals)
	li	a2,0
	li	a0,60
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(dsmaller_name)
	lw	a1,%lo(dsmaller_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(dsmaller)
	addi	a3,a3,%lo(dsmaller)
	li	a2,0
	li	a0,61
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(dlarger_name)
	lw	a1,%lo(dlarger_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(dlarger)
	addi	a3,a3,%lo(dlarger)
	li	a2,0
	li	a0,62
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(dusmaller_name)
	lw	a1,%lo(dusmaller_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(dusmaller)
	addi	a3,a3,%lo(dusmaller)
	li	a2,0
	li	a0,63
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(dplus_name)
	lw	a1,%lo(dplus_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(dplus)
	addi	a3,a3,%lo(dplus)
	li	a2,0
	li	a0,64
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(dminus_name)
	lw	a1,%lo(dminus_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(dminus)
	addi	a3,a3,%lo(dminus)
	li	a2,0
	li	a0,65
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(dmul_name)
	lw	a1,%lo(dmul_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(dmul)
	addi	a3,a3,%lo(dmul)
	li	a2,0
	li	a0,66
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(ddiv_name)
	lw	a1,%lo(ddiv_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(ddiv)
	addi	a3,a3,%lo(ddiv)
	li	a2,0
	li	a0,67
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(dswap_name)
	lw	a1,%lo(dswap_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(dswap)
	addi	a3,a3,%lo(dswap)
	li	a2,0
	li	a0,68
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(dover_name)
	lw	a1,%lo(dover_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(dover)
	addi	a3,a3,%lo(dover)
	li	a2,0
	li	a0,69
	call	addBuiltin.part.0
	lw	a5,%lo(errorFlag)(s0)
	lui	a4,%hi(drot_name)
	lw	a1,%lo(drot_name)(a4)
	bne	a5,zero,.L1826
	lui	a3,%hi(drot)
	addi	a3,a3,%lo(drot)
	li	a2,0
	li	a0,70
	call	addBuiltin.part.0
.L1826:
	lw	a5,%lo(here)(s2)
	lw	s0,%lo(errorFlag)(s0)
	lui	a4,%hi(maxBuiltinAddress)
	lw	a5,0(a5)
	addi	a5,a5,-1
	sw	a5,%lo(maxBuiltinAddress)(a4)
	beq	s0,zero,.L1833
	li	s0,1
.L1751:
	lw	ra,28(sp)
	mv	a0,s0
	lw	s0,24(sp)
	lw	s1,20(sp)
	lw	s2,16(sp)
	lw	s3,12(sp)
	addi	sp,sp,32
	jr	ra
.L1833:
	lui	a5,%hi(initScript)
	lw	a4,%lo(initScript)(a5)
	lui	a5,%hi(initscript_pos)
	sw	a4,%lo(initscript_pos)(a5)
	call	quit
	j	.L1751
	.size	main, .-main
	.globl	drot_flags
	.globl	drot_name
	.section	.rodata.str1.4
	.align	2
.LC12:
	.string	"2ROT"
	.globl	drot_id
	.globl	dover_flags
	.globl	dover_name
	.align	2
.LC13:
	.string	"2OVER"
	.globl	dover_id
	.globl	dswap_flags
	.globl	dswap_name
	.align	2
.LC14:
	.string	"2SWAP"
	.globl	dswap_id
	.globl	ddiv_flags
	.globl	ddiv_name
	.align	2
.LC15:
	.string	"D/"
	.globl	ddiv_id
	.globl	dmul_flags
	.globl	dmul_name
	.align	2
.LC16:
	.string	"D*"
	.globl	dmul_id
	.globl	dminus_flags
	.globl	dminus_name
	.align	2
.LC17:
	.string	"D-"
	.globl	dminus_id
	.globl	dplus_flags
	.globl	dplus_name
	.align	2
.LC18:
	.string	"D+"
	.globl	dplus_id
	.globl	dusmaller_flags
	.globl	dusmaller_name
	.align	2
.LC19:
	.string	"DU<"
	.globl	dusmaller_id
	.globl	dlarger_flags
	.globl	dlarger_name
	.align	2
.LC20:
	.string	"D>"
	.globl	dlarger_id
	.globl	dsmaller_flags
	.globl	dsmaller_name
	.align	2
.LC21:
	.string	"D<"
	.globl	dsmaller_id
	.globl	dequals_flags
	.globl	dequals_name
	.align	2
.LC22:
	.string	"D="
	.globl	dequals_id
	.globl	timesDivideMod_flags
	.globl	timesDivideMod_name
	.align	2
.LC23:
	.string	"*/MOD"
	.globl	timesDivideMod_id
	.globl	timesDivide_flags
	.globl	timesDivide_name
	.align	2
.LC24:
	.string	"*/"
	.globl	timesDivide_id
	.globl	xor_flags
	.globl	xor_name
	.align	2
.LC25:
	.string	"XOR"
	.globl	xor_id
	.globl	litstring_flags
	.globl	litstring_name
	.align	2
.LC26:
	.string	"LITSTRING"
	.globl	litstring_id
	.globl	p_dup_flags
	.globl	p_dup_name
	.align	2
.LC27:
	.string	"?DUP"
	.globl	p_dup_id
	.globl	doOr_flags
	.globl	doOr_name
	.align	2
.LC28:
	.string	"OR"
	.globl	doOr_id
	.globl	doAnd_flags
	.globl	doAnd_name
	.align	2
.LC29:
	.string	"AND"
	.globl	doAnd_id
	.globl	larger_flags
	.globl	larger_name
	.align	2
.LC30:
	.string	">"
	.globl	larger_id
	.globl	smaller_flags
	.globl	smaller_name
	.align	2
.LC31:
	.string	"<"
	.globl	smaller_id
	.globl	equals_flags
	.globl	equals_name
	.align	2
.LC32:
	.string	"="
	.globl	equals_id
	.globl	tick_flags
	.globl	tick_name
	.align	2
.LC33:
	.string	"'"
	.globl	tick_id
	.globl	doJ_flags
	.globl	doJ_name
	.align	2
.LC34:
	.string	"J"
	.globl	doJ_id
	.globl	rget_flags
	.globl	rget_name
	.align	2
.LC35:
	.string	"R@"
	.globl	rget_id
	.globl	semicolon_flags
	.globl	semicolon_name
	.align	2
.LC36:
	.string	";"
	.globl	semicolon_id
	.globl	colon_flags
	.globl	colon_name
	.align	2
.LC37:
	.string	":"
	.globl	colon_id
	.globl	doCreate_flags
	.globl	doCreate_name
	.align	2
.LC38:
	.string	"CREATE"
	.globl	doCreate_id
	.globl	rot_flags
	.globl	rot_name
	.align	2
.LC39:
	.string	"ROT"
	.globl	rot_id
	.globl	divmod_flags
	.globl	divmod_name
	.align	2
.LC40:
	.string	"/MOD"
	.globl	divmod_id
	.globl	mul_flags
	.globl	mul_name
	.align	2
.LC41:
	.string	"*"
	.globl	mul_id
	.globl	minus_flags
	.globl	minus_name
	.align	2
.LC42:
	.string	"-"
	.globl	minus_id
	.globl	plus_flags
	.globl	plus_name
	.align	2
.LC43:
	.string	"+"
	.globl	plus_id
	.globl	quit_flags
	.globl	quit_name
	.align	2
.LC44:
	.string	"QUIT"
	.globl	quit_id
	.globl	lit_flags
	.globl	lit_name
	.align	2
.LC45:
	.string	"LIT"
	.globl	lit_id
	.globl	number_flags
	.globl	number_name
	.align	2
.LC46:
	.string	"NUMBER"
	.globl	number_id
	.globl	cfa_flags
	.globl	cfa_name
	.align	2
.LC47:
	.string	">CFA"
	.globl	cfa_id
	.globl	find_flags
	.globl	find_name
	.align	2
.LC48:
	.string	"FIND"
	.globl	find_id
	.globl	word_flags
	.globl	word_name
	.align	2
.LC49:
	.string	"WORD"
	.globl	word_id
	.globl	commaByte_flags
	.globl	commaByte_name
	.align	2
.LC50:
	.string	"C,"
	.globl	commaByte_id
	.globl	comma_flags
	.globl	comma_name
	.align	2
.LC51:
	.string	","
	.globl	comma_id
	.globl	over_flags
	.globl	over_name
	.align	2
.LC52:
	.string	"OVER"
	.globl	over_id
	.globl	swap_flags
	.globl	swap_name
	.align	2
.LC53:
	.string	"SWAP"
	.globl	swap_id
	.globl	memWriteByte_flags
	.globl	memWriteByte_name
	.align	2
.LC54:
	.string	"C!"
	.globl	memWriteByte_id
	.globl	memWrite_flags
	.globl	memWrite_name
	.align	2
.LC55:
	.string	"!"
	.globl	memWrite_id
	.globl	dup_flags
	.globl	dup_name
	.align	2
.LC56:
	.string	"DUP"
	.globl	dup_id
	.globl	not_flags
	.globl	not_name
	.align	2
.LC57:
	.string	"NOT"
	.globl	not_id
	.globl	dsp_r_flags
	.globl	dsp_r_name
	.align	2
.LC58:
	.string	"DSP@"
	.globl	dsp_r_id
	.globl	s0_r_flags
	.globl	s0_r_name
	.align	2
.LC59:
	.string	"S0@"
	.globl	s0_r_id
	.globl	doFree_flags
	.globl	doFree_name
	.align	2
.LC60:
	.string	"FREE"
	.globl	doFree_id
	.globl	toggleImmediate_flags
	.globl	toggleImmediate_name
	.align	2
.LC61:
	.string	"IMMEDIATE"
	.globl	toggleImmediate_id
	.globl	zbranch_flags
	.globl	zbranch_name
	.align	2
.LC62:
	.string	"0BRANCH"
	.globl	zbranch_id
	.globl	branch_flags
	.globl	branch_name
	.align	2
.LC63:
	.string	"BRANCH"
	.globl	branch_id
	.globl	key_p_flags
	.globl	key_p_name
	.align	2
.LC64:
	.string	"KEY?"
	.globl	key_p_id
	.globl	stor_flags
	.globl	stor_name
	.align	2
.LC65:
	.string	">R"
	.globl	stor_id
	.globl	rtos_flags
	.globl	rtos_name
	.align	2
.LC66:
	.string	"R>"
	.globl	rtos_id
	.globl	hide_flags
	.globl	hide_name
	.align	2
.LC67:
	.string	"HIDE"
	.globl	hide_id
	.globl	gotoCompiler_flags
	.globl	gotoCompiler_name
	.align	2
.LC68:
	.string	"]"
	.globl	gotoCompiler_id
	.globl	gotoInterpreter_flags
	.globl	gotoInterpreter_name
	.align	2
.LC69:
	.string	"["
	.globl	gotoInterpreter_id
	.globl	doState_flags
	.globl	doState_name
	.align	2
.LC70:
	.string	"STATE"
	.globl	doState_id
	.globl	doBase_flags
	.globl	doBase_name
	.align	2
.LC71:
	.string	"BASE"
	.globl	doBase_id
	.globl	doHere_flags
	.globl	doHere_name
	.align	2
.LC72:
	.string	"HERE"
	.globl	doHere_id
	.globl	doLatest_flags
	.globl	doLatest_name
	.align	2
.LC73:
	.string	"LATEST"
	.globl	doLatest_id
	.globl	bye_flags
	.globl	bye_name
	.align	2
.LC74:
	.string	"BYE"
	.globl	bye_id
	.globl	doExit_flags
	.globl	doExit_name
	.align	2
.LC75:
	.string	"EXIT"
	.globl	doExit_id
	.globl	drop_flags
	.globl	drop_name
	.align	2
.LC76:
	.string	"DROP"
	.globl	drop_id
	.globl	emit_flags
	.globl	emit_name
	.align	2
.LC77:
	.string	"EMIT"
	.globl	emit_id
	.globl	key_flags
	.globl	key_name
	.align	2
.LC78:
	.string	"KEY"
	.globl	key_id
	.globl	memReadByte_flags
	.globl	memReadByte_name
	.align	2
.LC79:
	.string	"C@"
	.globl	memReadByte_id
	.globl	memRead_flags
	.globl	memRead_name
	.align	2
.LC80:
	.string	"@"
	.globl	memRead_id
	.globl	doCellSize_flags
	.globl	doCellSize_name
	.align	2
.LC81:
	.string	"CELL"
	.globl	doCellSize_id
	.globl	docol_flags
	.globl	docol_name
	.align	2
.LC82:
	.string	"RUNDOCOL"
	.globl	docol_id
	.globl	initScript
	.align	2
.LC83:
	.ascii	": DECIMAL 10 BASE ! ;\n: HEX 16 BASE ! ;\n: OCTAL 8 BASE ! ;"
	.ascii	"\n: 2DUP OVER OVER ;\n: 2DROP DROP DROP ;\n: NIP SWAP DROP ;"
	.ascii	"\n: 2NIP 2SWAP 2DROP ;\n: TUCK SWAP OVER ;\n: / /MOD NIP ;\n"
	.ascii	": MOD /MOD DROP ;\n: BL 32 ;\n: CR 10 EMIT ;\n: SPACE BL EMI"
	.ascii	"T ;\n: NEGATE 0 SWAP - ;\n: DNEGATE 0. 2SWAP D- ;\n: CELLS C"
	.ascii	"ELL * ;\n: ALLOT HERE @ + HERE ! ;\n: TRUE -1 ;\n: FALSE 0 ;"
	.ascii	"\n: 0= 0 = ;\n: 0< 0 < ;\n: 0> 0 > ;\n: <> = 0= ;\n: <= > 0="
	.ascii	" ;\n: >= < 0= ;\n: 0<= 0 <= ;\n: 0>= 0 >= ;\n: 1+ 1 + ;\n: 1"
	.ascii	"- 1 - ;\n: 2+ 2 + ;\n: 2- 2 - ;\n: 2/ 2 / ;\n: 2* 2 * ;\n: D"
	.ascii	"2/ 2. D/ ;\n: +! DUP @ ROT + SWAP ! ;\n: [COMPILE] WORD FIND"
	.ascii	" >CFA , ; IMMEDIATE\n: [CHAR] key ' LIT , , ; IMMEDIATE\n: R"
	.ascii	"ECURSE LATEST @ >CFA , ; IMMEDIATE\n: DOCOL 0 ;\n: CONSTANT "
	.ascii	"CREATE DOCOL , ' LIT , , ' EXIT , ;\n: 2CONSTANT SWAP CREATE"
	.ascii	" DOCOL , ' LIT , , ' LIT , , ' EXIT , ;\n: VARIABLE HERE @ C"
	.ascii	"ELL ALLOT CREATE DOCOL , ' LIT , , ' EXIT , ;\n: 2VARIABLE H"
	.ascii	"ERE @ 2 CELLS ALLOT CREATE DOCOL , ' LIT , , ' EXIT , ;\n: I"
	.ascii	"F ' 0BRANCH , HERE @ 0 , ; IMMEDIATE\n: THEN DUP HERE @ SWAP"
	.ascii	" - SWAP ! ; IMMEDIATE\n: ELSE ' BRANCH , HERE @ 0 , SWAP DUP"
	.ascii	" HERE @ SWAP - SWAP ! ; IMMEDIATE\n: BEGIN HERE @ ; IMMEDIAT"
	.ascii	"E\n: UNTIL ' 0BRANCH , HERE @ - , ; IMMEDIATE\n: AGAIN ' BRA"
	.ascii	"NCH , HERE @ - , ; IMMEDIATE\n: WHILE ' 0BRANCH , HERE @ 0 ,"
	.ascii	" ; IMMEDIATE\n: REPEAT ' BRANCH , SWAP HERE @ - , DUP HERE @"
	.ascii	" SWAP - SWAP ! ; IMMEDIATE\n: UNLESS ' 0= , [COMPILE] IF ; I"
	.ascii	"MMEDIATE\n: DO HERE @ ' SWAP , ' >R , ' >R , ; IMMEDIATE\n: "
	.ascii	"LOOP ' R> , ' R> , ' SWAP , ' 1+ , ' 2DUP , ' = , ' 0BRANCH "
	.ascii	", HERE @ - , ' 2DROP , ; IMMEDIATE\n: +LOOP ' R> , ' R> , ' "
	.ascii	"SWAP , ' ROT , ' + , ' 2DUP , ' <= , ' 0BRANCH , HERE @ - , "
	.ascii	"' 2DROP , ; IMMEDIATE\n: I ' R@ , ; IMMEDIATE\n: SPACES DUP "
	.ascii	"0> IF 0 DO SPACE LOOP ELSE DROP THEN ;\n: ABS DUP 0< IF NEGA"
	.ascii	"TE THEN ;\n: DABS 2DUP 0. D< IF DNEGATE THEN ;\n: .DIGIT DUP"
	.ascii	" 9 > IF 55 ELSE 48 THEN + EMIT ;\n: .SIGN DUP 0< IF 45 EMIT "
	.ascii	"NEGATE THEN ;\n: .POS BASE @ /MOD ?DUP IF RECURSE THEN .DIGI"
	.ascii	"T ;\n: . .SIGN DUP IF .POS ELSE .DIGIT THEN ;\n: COUNTPOS SW"
	.ascii	"AP 1 + SWAP BASE @ / ?DUP IF RECURSE THEN ;\n: DIGITS DUP 0<"
	.ascii	" IF 1 ELSE 0 THEN SWAP C"
	.ascii	"OUNTPOS ;\n: .R OVER DIGITS - SPACES . ;\n: . . SPACE ;\n: ?"
	.ascii	" @ . ;\n: .S DSP@ BEGIN DUP S0@ > WHILE DUP ? CELL - REPEAT "
	.ascii	"DROP ;\n: TYPE 0 DO DUP C@ EMIT 1 + LOOP DROP ;\n: ALIGN BEG"
	.ascii	"IN HERE @ CELL MOD WHILE 0 C, REPEAT ;\n: s\" ' LITSTRING , "
	.ascii	"HERE @ 0 , BEGIN KEY DUP 34 <> WHILE C, REPEAT DROP DUP HERE"
	.ascii	" @ SWAP - CELL - SWAP ! ALIGN ; IMMEDIATE\n: .\" [COMPILE] s"
	.ascii	"\" ' TYPE , ; IMMEDI"
	.string	"ATE\n: ( BEGIN KEY [CHAR] ) = UNTIL ; IMMEDIATE\n: COUNT DUP 1+ SWAP C@ ;\n: MIN 2DUP < IF DROP ELSE NIP THEN ;\n: MAX 2DUP > IF DROP ELSE NIP THEN ;\n: D0= OR 0= ;\n: DMIN 2OVER 2OVER D< IF 2DROP ELSE 2NIP THEN ;\n: DMAX 2OVER 2OVER D> IF 2DROP ELSE 2NIP THEN ;\n"
	.globl	initscript_pos
	.globl	builtins
	.globl	positionInLineBuffer
	.globl	charsInLineBuffer
	.globl	lineBuffer
	.globl	maxBuiltinAddress
	.globl	commandAddress
	.globl	quit_address
	.globl	lastIp
	.globl	next
	.globl	errorFlag
	.globl	exitReq
	.globl	rstack
	.globl	rsp
	.globl	stack
	.globl	sp
	.globl	state
	.globl	base
	.globl	here
	.globl	latest
	.globl	memory
	.bss
	.align	2
	.set	.LANCHOR0,. + 0
	.type	lineBuffer, @object
	.size	lineBuffer, 128
lineBuffer:
	.zero	128
	.type	builtins, @object
	.size	builtins, 284
builtins:
	.zero	284
	.type	memory, @object
	.size	memory, 65536
memory:
	.zero	65536
	.section	.sbss,"aw",@nobits
	.align	2
	.type	initscript_pos, @object
	.size	initscript_pos, 4
initscript_pos:
	.zero	4
	.type	positionInLineBuffer, @object
	.size	positionInLineBuffer, 4
positionInLineBuffer:
	.zero	4
	.type	charsInLineBuffer, @object
	.size	charsInLineBuffer, 4
charsInLineBuffer:
	.zero	4
	.type	maxBuiltinAddress, @object
	.size	maxBuiltinAddress, 4
maxBuiltinAddress:
	.zero	4
	.type	commandAddress, @object
	.size	commandAddress, 4
commandAddress:
	.zero	4
	.type	quit_address, @object
	.size	quit_address, 4
quit_address:
	.zero	4
	.type	lastIp, @object
	.size	lastIp, 4
lastIp:
	.zero	4
	.type	next, @object
	.size	next, 4
next:
	.zero	4
	.type	errorFlag, @object
	.size	errorFlag, 4
errorFlag:
	.zero	4
	.type	exitReq, @object
	.size	exitReq, 4
exitReq:
	.zero	4
	.type	rstack, @object
	.size	rstack, 4
rstack:
	.zero	4
	.type	rsp, @object
	.size	rsp, 4
rsp:
	.zero	4
	.type	stack, @object
	.size	stack, 4
stack:
	.zero	4
	.type	sp, @object
	.size	sp, 4
sp:
	.zero	4
	.type	state, @object
	.size	state, 4
state:
	.zero	4
	.type	base, @object
	.size	base, 4
base:
	.zero	4
	.type	here, @object
	.size	here, 4
here:
	.zero	4
	.type	latest, @object
	.size	latest, 4
latest:
	.zero	4
	.section	.sdata,"aw"
	.align	2
	.type	drot_name, @object
	.size	drot_name, 4
drot_name:
	.word	.LC12
	.type	dover_name, @object
	.size	dover_name, 4
dover_name:
	.word	.LC13
	.type	dswap_name, @object
	.size	dswap_name, 4
dswap_name:
	.word	.LC14
	.type	ddiv_name, @object
	.size	ddiv_name, 4
ddiv_name:
	.word	.LC15
	.type	dmul_name, @object
	.size	dmul_name, 4
dmul_name:
	.word	.LC16
	.type	dminus_name, @object
	.size	dminus_name, 4
dminus_name:
	.word	.LC17
	.type	dplus_name, @object
	.size	dplus_name, 4
dplus_name:
	.word	.LC18
	.type	dusmaller_name, @object
	.size	dusmaller_name, 4
dusmaller_name:
	.word	.LC19
	.type	dlarger_name, @object
	.size	dlarger_name, 4
dlarger_name:
	.word	.LC20
	.type	dsmaller_name, @object
	.size	dsmaller_name, 4
dsmaller_name:
	.word	.LC21
	.type	dequals_name, @object
	.size	dequals_name, 4
dequals_name:
	.word	.LC22
	.type	timesDivideMod_name, @object
	.size	timesDivideMod_name, 4
timesDivideMod_name:
	.word	.LC23
	.type	timesDivide_name, @object
	.size	timesDivide_name, 4
timesDivide_name:
	.word	.LC24
	.type	xor_name, @object
	.size	xor_name, 4
xor_name:
	.word	.LC25
	.type	litstring_name, @object
	.size	litstring_name, 4
litstring_name:
	.word	.LC26
	.type	p_dup_name, @object
	.size	p_dup_name, 4
p_dup_name:
	.word	.LC27
	.type	doOr_name, @object
	.size	doOr_name, 4
doOr_name:
	.word	.LC28
	.type	doAnd_name, @object
	.size	doAnd_name, 4
doAnd_name:
	.word	.LC29
	.type	larger_name, @object
	.size	larger_name, 4
larger_name:
	.word	.LC30
	.type	smaller_name, @object
	.size	smaller_name, 4
smaller_name:
	.word	.LC31
	.type	equals_name, @object
	.size	equals_name, 4
equals_name:
	.word	.LC32
	.type	tick_name, @object
	.size	tick_name, 4
tick_name:
	.word	.LC33
	.type	doJ_name, @object
	.size	doJ_name, 4
doJ_name:
	.word	.LC34
	.type	rget_name, @object
	.size	rget_name, 4
rget_name:
	.word	.LC35
	.type	semicolon_name, @object
	.size	semicolon_name, 4
semicolon_name:
	.word	.LC36
	.type	colon_name, @object
	.size	colon_name, 4
colon_name:
	.word	.LC37
	.type	doCreate_name, @object
	.size	doCreate_name, 4
doCreate_name:
	.word	.LC38
	.type	rot_name, @object
	.size	rot_name, 4
rot_name:
	.word	.LC39
	.type	divmod_name, @object
	.size	divmod_name, 4
divmod_name:
	.word	.LC40
	.type	mul_name, @object
	.size	mul_name, 4
mul_name:
	.word	.LC41
	.type	minus_name, @object
	.size	minus_name, 4
minus_name:
	.word	.LC42
	.type	plus_name, @object
	.size	plus_name, 4
plus_name:
	.word	.LC43
	.type	quit_name, @object
	.size	quit_name, 4
quit_name:
	.word	.LC44
	.type	lit_name, @object
	.size	lit_name, 4
lit_name:
	.word	.LC45
	.type	number_name, @object
	.size	number_name, 4
number_name:
	.word	.LC46
	.type	cfa_name, @object
	.size	cfa_name, 4
cfa_name:
	.word	.LC47
	.type	find_name, @object
	.size	find_name, 4
find_name:
	.word	.LC48
	.type	word_name, @object
	.size	word_name, 4
word_name:
	.word	.LC49
	.type	commaByte_name, @object
	.size	commaByte_name, 4
commaByte_name:
	.word	.LC50
	.type	comma_name, @object
	.size	comma_name, 4
comma_name:
	.word	.LC51
	.type	over_name, @object
	.size	over_name, 4
over_name:
	.word	.LC52
	.type	swap_name, @object
	.size	swap_name, 4
swap_name:
	.word	.LC53
	.type	memWriteByte_name, @object
	.size	memWriteByte_name, 4
memWriteByte_name:
	.word	.LC54
	.type	memWrite_name, @object
	.size	memWrite_name, 4
memWrite_name:
	.word	.LC55
	.type	dup_name, @object
	.size	dup_name, 4
dup_name:
	.word	.LC56
	.type	not_name, @object
	.size	not_name, 4
not_name:
	.word	.LC57
	.type	dsp_r_name, @object
	.size	dsp_r_name, 4
dsp_r_name:
	.word	.LC58
	.type	s0_r_name, @object
	.size	s0_r_name, 4
s0_r_name:
	.word	.LC59
	.type	doFree_name, @object
	.size	doFree_name, 4
doFree_name:
	.word	.LC60
	.type	toggleImmediate_name, @object
	.size	toggleImmediate_name, 4
toggleImmediate_name:
	.word	.LC61
	.type	zbranch_name, @object
	.size	zbranch_name, 4
zbranch_name:
	.word	.LC62
	.type	branch_name, @object
	.size	branch_name, 4
branch_name:
	.word	.LC63
	.type	key_p_name, @object
	.size	key_p_name, 4
key_p_name:
	.word	.LC64
	.type	stor_name, @object
	.size	stor_name, 4
stor_name:
	.word	.LC65
	.type	rtos_name, @object
	.size	rtos_name, 4
rtos_name:
	.word	.LC66
	.type	hide_name, @object
	.size	hide_name, 4
hide_name:
	.word	.LC67
	.type	gotoCompiler_name, @object
	.size	gotoCompiler_name, 4
gotoCompiler_name:
	.word	.LC68
	.type	gotoInterpreter_name, @object
	.size	gotoInterpreter_name, 4
gotoInterpreter_name:
	.word	.LC69
	.type	doState_name, @object
	.size	doState_name, 4
doState_name:
	.word	.LC70
	.type	doBase_name, @object
	.size	doBase_name, 4
doBase_name:
	.word	.LC71
	.type	doHere_name, @object
	.size	doHere_name, 4
doHere_name:
	.word	.LC72
	.type	doLatest_name, @object
	.size	doLatest_name, 4
doLatest_name:
	.word	.LC73
	.type	bye_name, @object
	.size	bye_name, 4
bye_name:
	.word	.LC74
	.type	doExit_name, @object
	.size	doExit_name, 4
doExit_name:
	.word	.LC75
	.type	drop_name, @object
	.size	drop_name, 4
drop_name:
	.word	.LC76
	.type	emit_name, @object
	.size	emit_name, 4
emit_name:
	.word	.LC77
	.type	key_name, @object
	.size	key_name, 4
key_name:
	.word	.LC78
	.type	memReadByte_name, @object
	.size	memReadByte_name, 4
memReadByte_name:
	.word	.LC79
	.type	memRead_name, @object
	.size	memRead_name, 4
memRead_name:
	.word	.LC80
	.type	doCellSize_name, @object
	.size	doCellSize_name, 4
doCellSize_name:
	.word	.LC81
	.type	docol_name, @object
	.size	docol_name, 4
docol_name:
	.word	.LC82
	.type	initScript, @object
	.size	initScript, 4
initScript:
	.word	.LC83
	.section	.srodata,"a"
	.align	2
	.type	drot_flags, @object
	.size	drot_flags, 1
drot_flags:
	.zero	1
	.zero	3
	.type	drot_id, @object
	.size	drot_id, 4
drot_id:
	.word	70
	.type	dover_flags, @object
	.size	dover_flags, 1
dover_flags:
	.zero	1
	.zero	3
	.type	dover_id, @object
	.size	dover_id, 4
dover_id:
	.word	69
	.type	dswap_flags, @object
	.size	dswap_flags, 1
dswap_flags:
	.zero	1
	.zero	3
	.type	dswap_id, @object
	.size	dswap_id, 4
dswap_id:
	.word	68
	.type	ddiv_flags, @object
	.size	ddiv_flags, 1
ddiv_flags:
	.zero	1
	.zero	3
	.type	ddiv_id, @object
	.size	ddiv_id, 4
ddiv_id:
	.word	67
	.type	dmul_flags, @object
	.size	dmul_flags, 1
dmul_flags:
	.zero	1
	.zero	3
	.type	dmul_id, @object
	.size	dmul_id, 4
dmul_id:
	.word	66
	.type	dminus_flags, @object
	.size	dminus_flags, 1
dminus_flags:
	.zero	1
	.zero	3
	.type	dminus_id, @object
	.size	dminus_id, 4
dminus_id:
	.word	65
	.type	dplus_flags, @object
	.size	dplus_flags, 1
dplus_flags:
	.zero	1
	.zero	3
	.type	dplus_id, @object
	.size	dplus_id, 4
dplus_id:
	.word	64
	.type	dusmaller_flags, @object
	.size	dusmaller_flags, 1
dusmaller_flags:
	.zero	1
	.zero	3
	.type	dusmaller_id, @object
	.size	dusmaller_id, 4
dusmaller_id:
	.word	63
	.type	dlarger_flags, @object
	.size	dlarger_flags, 1
dlarger_flags:
	.zero	1
	.zero	3
	.type	dlarger_id, @object
	.size	dlarger_id, 4
dlarger_id:
	.word	62
	.type	dsmaller_flags, @object
	.size	dsmaller_flags, 1
dsmaller_flags:
	.zero	1
	.zero	3
	.type	dsmaller_id, @object
	.size	dsmaller_id, 4
dsmaller_id:
	.word	61
	.type	dequals_flags, @object
	.size	dequals_flags, 1
dequals_flags:
	.zero	1
	.zero	3
	.type	dequals_id, @object
	.size	dequals_id, 4
dequals_id:
	.word	60
	.type	timesDivideMod_flags, @object
	.size	timesDivideMod_flags, 1
timesDivideMod_flags:
	.zero	1
	.zero	3
	.type	timesDivideMod_id, @object
	.size	timesDivideMod_id, 4
timesDivideMod_id:
	.word	59
	.type	timesDivide_flags, @object
	.size	timesDivide_flags, 1
timesDivide_flags:
	.zero	1
	.zero	3
	.type	timesDivide_id, @object
	.size	timesDivide_id, 4
timesDivide_id:
	.word	58
	.type	xor_flags, @object
	.size	xor_flags, 1
xor_flags:
	.zero	1
	.zero	3
	.type	xor_id, @object
	.size	xor_id, 4
xor_id:
	.word	57
	.type	litstring_flags, @object
	.size	litstring_flags, 1
litstring_flags:
	.zero	1
	.zero	3
	.type	litstring_id, @object
	.size	litstring_id, 4
litstring_id:
	.word	56
	.type	p_dup_flags, @object
	.size	p_dup_flags, 1
p_dup_flags:
	.zero	1
	.zero	3
	.type	p_dup_id, @object
	.size	p_dup_id, 4
p_dup_id:
	.word	55
	.type	doOr_flags, @object
	.size	doOr_flags, 1
doOr_flags:
	.zero	1
	.zero	3
	.type	doOr_id, @object
	.size	doOr_id, 4
doOr_id:
	.word	54
	.type	doAnd_flags, @object
	.size	doAnd_flags, 1
doAnd_flags:
	.zero	1
	.zero	3
	.type	doAnd_id, @object
	.size	doAnd_id, 4
doAnd_id:
	.word	53
	.type	larger_flags, @object
	.size	larger_flags, 1
larger_flags:
	.zero	1
	.zero	3
	.type	larger_id, @object
	.size	larger_id, 4
larger_id:
	.word	52
	.type	smaller_flags, @object
	.size	smaller_flags, 1
smaller_flags:
	.zero	1
	.zero	3
	.type	smaller_id, @object
	.size	smaller_id, 4
smaller_id:
	.word	51
	.type	equals_flags, @object
	.size	equals_flags, 1
equals_flags:
	.zero	1
	.zero	3
	.type	equals_id, @object
	.size	equals_id, 4
equals_id:
	.word	50
	.type	tick_flags, @object
	.size	tick_flags, 1
tick_flags:
	.byte	-128
	.zero	3
	.type	tick_id, @object
	.size	tick_id, 4
tick_id:
	.word	49
	.type	doJ_flags, @object
	.size	doJ_flags, 1
doJ_flags:
	.zero	1
	.zero	3
	.type	doJ_id, @object
	.size	doJ_id, 4
doJ_id:
	.word	48
	.type	rget_flags, @object
	.size	rget_flags, 1
rget_flags:
	.zero	1
	.zero	3
	.type	rget_id, @object
	.size	rget_id, 4
rget_id:
	.word	47
	.type	semicolon_flags, @object
	.size	semicolon_flags, 1
semicolon_flags:
	.byte	-128
	.zero	3
	.type	semicolon_id, @object
	.size	semicolon_id, 4
semicolon_id:
	.word	46
	.type	colon_flags, @object
	.size	colon_flags, 1
colon_flags:
	.zero	1
	.zero	3
	.type	colon_id, @object
	.size	colon_id, 4
colon_id:
	.word	45
	.type	doCreate_flags, @object
	.size	doCreate_flags, 1
doCreate_flags:
	.zero	1
	.zero	3
	.type	doCreate_id, @object
	.size	doCreate_id, 4
doCreate_id:
	.word	44
	.type	rot_flags, @object
	.size	rot_flags, 1
rot_flags:
	.zero	1
	.zero	3
	.type	rot_id, @object
	.size	rot_id, 4
rot_id:
	.word	43
	.type	divmod_flags, @object
	.size	divmod_flags, 1
divmod_flags:
	.zero	1
	.zero	3
	.type	divmod_id, @object
	.size	divmod_id, 4
divmod_id:
	.word	42
	.type	mul_flags, @object
	.size	mul_flags, 1
mul_flags:
	.zero	1
	.zero	3
	.type	mul_id, @object
	.size	mul_id, 4
mul_id:
	.word	41
	.type	minus_flags, @object
	.size	minus_flags, 1
minus_flags:
	.zero	1
	.zero	3
	.type	minus_id, @object
	.size	minus_id, 4
minus_id:
	.word	40
	.type	plus_flags, @object
	.size	plus_flags, 1
plus_flags:
	.zero	1
	.zero	3
	.type	plus_id, @object
	.size	plus_id, 4
plus_id:
	.word	39
	.type	quit_flags, @object
	.size	quit_flags, 1
quit_flags:
	.zero	1
	.zero	3
	.type	quit_id, @object
	.size	quit_id, 4
quit_id:
	.word	38
	.type	lit_flags, @object
	.size	lit_flags, 1
lit_flags:
	.zero	1
	.zero	3
	.type	lit_id, @object
	.size	lit_id, 4
lit_id:
	.word	37
	.type	number_flags, @object
	.size	number_flags, 1
number_flags:
	.zero	1
	.zero	3
	.type	number_id, @object
	.size	number_id, 4
number_id:
	.word	36
	.type	cfa_flags, @object
	.size	cfa_flags, 1
cfa_flags:
	.zero	1
	.zero	3
	.type	cfa_id, @object
	.size	cfa_id, 4
cfa_id:
	.word	35
	.type	find_flags, @object
	.size	find_flags, 1
find_flags:
	.zero	1
	.zero	3
	.type	find_id, @object
	.size	find_id, 4
find_id:
	.word	34
	.type	word_flags, @object
	.size	word_flags, 1
word_flags:
	.zero	1
	.zero	3
	.type	word_id, @object
	.size	word_id, 4
word_id:
	.word	33
	.type	commaByte_flags, @object
	.size	commaByte_flags, 1
commaByte_flags:
	.zero	1
	.zero	3
	.type	commaByte_id, @object
	.size	commaByte_id, 4
commaByte_id:
	.word	32
	.type	comma_flags, @object
	.size	comma_flags, 1
comma_flags:
	.zero	1
	.zero	3
	.type	comma_id, @object
	.size	comma_id, 4
comma_id:
	.word	31
	.type	over_flags, @object
	.size	over_flags, 1
over_flags:
	.zero	1
	.zero	3
	.type	over_id, @object
	.size	over_id, 4
over_id:
	.word	30
	.type	swap_flags, @object
	.size	swap_flags, 1
swap_flags:
	.zero	1
	.zero	3
	.type	swap_id, @object
	.size	swap_id, 4
swap_id:
	.word	29
	.type	memWriteByte_flags, @object
	.size	memWriteByte_flags, 1
memWriteByte_flags:
	.zero	1
	.zero	3
	.type	memWriteByte_id, @object
	.size	memWriteByte_id, 4
memWriteByte_id:
	.word	28
	.type	memWrite_flags, @object
	.size	memWrite_flags, 1
memWrite_flags:
	.zero	1
	.zero	3
	.type	memWrite_id, @object
	.size	memWrite_id, 4
memWrite_id:
	.word	27
	.type	dup_flags, @object
	.size	dup_flags, 1
dup_flags:
	.zero	1
	.zero	3
	.type	dup_id, @object
	.size	dup_id, 4
dup_id:
	.word	26
	.type	not_flags, @object
	.size	not_flags, 1
not_flags:
	.zero	1
	.zero	3
	.type	not_id, @object
	.size	not_id, 4
not_id:
	.word	25
	.type	dsp_r_flags, @object
	.size	dsp_r_flags, 1
dsp_r_flags:
	.zero	1
	.zero	3
	.type	dsp_r_id, @object
	.size	dsp_r_id, 4
dsp_r_id:
	.word	24
	.type	s0_r_flags, @object
	.size	s0_r_flags, 1
s0_r_flags:
	.zero	1
	.zero	3
	.type	s0_r_id, @object
	.size	s0_r_id, 4
s0_r_id:
	.word	23
	.type	doFree_flags, @object
	.size	doFree_flags, 1
doFree_flags:
	.zero	1
	.zero	3
	.type	doFree_id, @object
	.size	doFree_id, 4
doFree_id:
	.word	22
	.type	toggleImmediate_flags, @object
	.size	toggleImmediate_flags, 1
toggleImmediate_flags:
	.byte	-128
	.zero	3
	.type	toggleImmediate_id, @object
	.size	toggleImmediate_id, 4
toggleImmediate_id:
	.word	21
	.type	zbranch_flags, @object
	.size	zbranch_flags, 1
zbranch_flags:
	.zero	1
	.zero	3
	.type	zbranch_id, @object
	.size	zbranch_id, 4
zbranch_id:
	.word	20
	.type	branch_flags, @object
	.size	branch_flags, 1
branch_flags:
	.zero	1
	.zero	3
	.type	branch_id, @object
	.size	branch_id, 4
branch_id:
	.word	19
	.type	key_p_flags, @object
	.size	key_p_flags, 1
key_p_flags:
	.zero	1
	.zero	3
	.type	key_p_id, @object
	.size	key_p_id, 4
key_p_id:
	.word	18
	.type	stor_flags, @object
	.size	stor_flags, 1
stor_flags:
	.zero	1
	.zero	3
	.type	stor_id, @object
	.size	stor_id, 4
stor_id:
	.word	17
	.type	rtos_flags, @object
	.size	rtos_flags, 1
rtos_flags:
	.zero	1
	.zero	3
	.type	rtos_id, @object
	.size	rtos_id, 4
rtos_id:
	.word	16
	.type	hide_flags, @object
	.size	hide_flags, 1
hide_flags:
	.zero	1
	.zero	3
	.type	hide_id, @object
	.size	hide_id, 4
hide_id:
	.word	15
	.type	gotoCompiler_flags, @object
	.size	gotoCompiler_flags, 1
gotoCompiler_flags:
	.zero	1
	.zero	3
	.type	gotoCompiler_id, @object
	.size	gotoCompiler_id, 4
gotoCompiler_id:
	.word	14
	.type	gotoInterpreter_flags, @object
	.size	gotoInterpreter_flags, 1
gotoInterpreter_flags:
	.byte	-128
	.zero	3
	.type	gotoInterpreter_id, @object
	.size	gotoInterpreter_id, 4
gotoInterpreter_id:
	.word	13
	.type	doState_flags, @object
	.size	doState_flags, 1
doState_flags:
	.zero	1
	.zero	3
	.type	doState_id, @object
	.size	doState_id, 4
doState_id:
	.word	12
	.type	doBase_flags, @object
	.size	doBase_flags, 1
doBase_flags:
	.zero	1
	.zero	3
	.type	doBase_id, @object
	.size	doBase_id, 4
doBase_id:
	.word	11
	.type	doHere_flags, @object
	.size	doHere_flags, 1
doHere_flags:
	.zero	1
	.zero	3
	.type	doHere_id, @object
	.size	doHere_id, 4
doHere_id:
	.word	10
	.type	doLatest_flags, @object
	.size	doLatest_flags, 1
doLatest_flags:
	.zero	1
	.zero	3
	.type	doLatest_id, @object
	.size	doLatest_id, 4
doLatest_id:
	.word	9
	.type	bye_flags, @object
	.size	bye_flags, 1
bye_flags:
	.zero	1
	.zero	3
	.type	bye_id, @object
	.size	bye_id, 4
bye_id:
	.word	8
	.type	doExit_flags, @object
	.size	doExit_flags, 1
doExit_flags:
	.zero	1
	.zero	3
	.type	doExit_id, @object
	.size	doExit_id, 4
doExit_id:
	.word	7
	.type	drop_flags, @object
	.size	drop_flags, 1
drop_flags:
	.zero	1
	.zero	3
	.type	drop_id, @object
	.size	drop_id, 4
drop_id:
	.word	6
	.type	emit_flags, @object
	.size	emit_flags, 1
emit_flags:
	.zero	1
	.zero	3
	.type	emit_id, @object
	.size	emit_id, 4
emit_id:
	.word	5
	.type	key_flags, @object
	.size	key_flags, 1
key_flags:
	.zero	1
	.zero	3
	.type	key_id, @object
	.size	key_id, 4
key_id:
	.word	4
	.type	memReadByte_flags, @object
	.size	memReadByte_flags, 1
memReadByte_flags:
	.zero	1
	.zero	3
	.type	memReadByte_id, @object
	.size	memReadByte_id, 4
memReadByte_id:
	.word	3
	.type	memRead_flags, @object
	.size	memRead_flags, 1
memRead_flags:
	.zero	1
	.zero	3
	.type	memRead_id, @object
	.size	memRead_id, 4
memRead_id:
	.word	2
	.type	doCellSize_flags, @object
	.size	doCellSize_flags, 1
doCellSize_flags:
	.zero	1
	.zero	3
	.type	doCellSize_id, @object
	.size	doCellSize_id, 4
doCellSize_id:
	.word	1
	.type	docol_flags, @object
	.size	docol_flags, 1
docol_flags:
	.zero	1
	.zero	3
	.type	docol_id, @object
	.size	docol_id, 4
docol_id:
	.zero	4
	.ident	"GCC: (GNU) 11.1.0"
