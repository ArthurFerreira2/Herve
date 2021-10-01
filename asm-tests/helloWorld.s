
.globl _start
.align 2
.section .text

_start:
	lui	t0,0xe000
	li	t1,72
	sw	t1,0(t0)
	li	t1,101
	sw	t1,0(t0)
	li	t1,108
	sw	t1,0(t0)
	li	t1,108
	sw	t1,0(t0)
	li	t1,111
	sw	t1,0(t0)
	li	t1,10
	sw	t1,0(t0)

end:	ebreak
