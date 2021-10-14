// ./compile.sh 4-ALU-tests && ../herve 4-ALU-tests.elf 2>4-ALU-tests.traces


char *TX = (char*) 0x0e000000;

int and(int a, int b) {
  return a & b;
}

int or(int a, int b) {
  return a | b;
}

int xor(int a, int b) {
  return a ^ b;
}

int comp(int a) {
  return ~a;
}

int not(int a) {
  return !a;
}

int shl(int a) {
  return a << 1;
}

int shr(int a) {
  return a >> 1;
}

int add(int a, int b) {
  return a + b;
}

int sub(int a, int b) {
  return a - b;
}


int main() {

  *TX = and(42, 42);
  *TX = '\n';
  *TX = or(32, 10);
  *TX = '\n';
  *TX = xor(32, 10);
  *TX = '\n';
  *TX = comp(comp(42));
  *TX = '\n';
  *TX = not(0) + 41;
  *TX = '\n';
  *TX = add(20, 22);
  *TX = '\n';
  *TX = sub(52, 10);
  *TX = '\n';
  *TX = shl(21);
  *TX = '\n';
  *TX = shr(84);
  *TX = '\n';

  __asm__ ("ebreak");
}

/*

Disassembly of section .text:

00000000 <and>:
   0:	fe010113          	addi	sp,sp,-32
   4:	00812e23          	sw	s0,28(sp)
   8:	02010413          	addi	s0,sp,32
   c:	fea42623          	sw	a0,-20(s0)
  10:	feb42423          	sw	a1,-24(s0)
  14:	fec42703          	lw	a4,-20(s0)
  18:	fe842783          	lw	a5,-24(s0)
  1c:	00f777b3          	and	a5,a4,a5
  20:	00078513          	mv	a0,a5
  24:	01c12403          	lw	s0,28(sp)
  28:	02010113          	addi	sp,sp,32
  2c:	00008067          	ret

00000030 <or>:
  30:	fe010113          	addi	sp,sp,-32
  34:	00812e23          	sw	s0,28(sp)
  38:	02010413          	addi	s0,sp,32
  3c:	fea42623          	sw	a0,-20(s0)
  40:	feb42423          	sw	a1,-24(s0)
  44:	fec42703          	lw	a4,-20(s0)
  48:	fe842783          	lw	a5,-24(s0)
  4c:	00f767b3          	or	a5,a4,a5
  50:	00078513          	mv	a0,a5
  54:	01c12403          	lw	s0,28(sp)
  58:	02010113          	addi	sp,sp,32
  5c:	00008067          	ret

00000060 <xor>:
  60:	fe010113          	addi	sp,sp,-32
  64:	00812e23          	sw	s0,28(sp)
  68:	02010413          	addi	s0,sp,32
  6c:	fea42623          	sw	a0,-20(s0)
  70:	feb42423          	sw	a1,-24(s0)
  74:	fec42703          	lw	a4,-20(s0)
  78:	fe842783          	lw	a5,-24(s0)
  7c:	00f747b3          	xor	a5,a4,a5
  80:	00078513          	mv	a0,a5
  84:	01c12403          	lw	s0,28(sp)
  88:	02010113          	addi	sp,sp,32
  8c:	00008067          	ret

00000090 <comp>:
  90:	fe010113          	addi	sp,sp,-32
  94:	00812e23          	sw	s0,28(sp)
  98:	02010413          	addi	s0,sp,32
  9c:	fea42623          	sw	a0,-20(s0)
  a0:	fec42783          	lw	a5,-20(s0)
  a4:	fff7c793          	not	a5,a5
  a8:	00078513          	mv	a0,a5
  ac:	01c12403          	lw	s0,28(sp)
  b0:	02010113          	addi	sp,sp,32
  b4:	00008067          	ret

000000b8 <not>:
  b8:	fe010113          	addi	sp,sp,-32
  bc:	00812e23          	sw	s0,28(sp)
  c0:	02010413          	addi	s0,sp,32
  c4:	fea42623          	sw	a0,-20(s0)
  c8:	fec42783          	lw	a5,-20(s0)
  cc:	0017b793          	seqz	a5,a5
  d0:	0ff7f793          	zext.b	a5,a5
  d4:	00078513          	mv	a0,a5
  d8:	01c12403          	lw	s0,28(sp)
  dc:	02010113          	addi	sp,sp,32
  e0:	00008067          	ret

000000e4 <shl>:
  e4:	fe010113          	addi	sp,sp,-32
  e8:	00812e23          	sw	s0,28(sp)
  ec:	02010413          	addi	s0,sp,32
  f0:	fea42623          	sw	a0,-20(s0)
  f4:	fec42783          	lw	a5,-20(s0)
  f8:	00179793          	slli	a5,a5,0x1
  fc:	00078513          	mv	a0,a5
 100:	01c12403          	lw	s0,28(sp)
 104:	02010113          	addi	sp,sp,32
 108:	00008067          	ret

0000010c <shr>:
 10c:	fe010113          	addi	sp,sp,-32
 110:	00812e23          	sw	s0,28(sp)
 114:	02010413          	addi	s0,sp,32
 118:	fea42623          	sw	a0,-20(s0)
 11c:	fec42783          	lw	a5,-20(s0)
 120:	4017d793          	srai	a5,a5,0x1
 124:	00078513          	mv	a0,a5
 128:	01c12403          	lw	s0,28(sp)
 12c:	02010113          	addi	sp,sp,32
 130:	00008067          	ret

00000134 <add>:
 134:	fe010113          	addi	sp,sp,-32
 138:	00812e23          	sw	s0,28(sp)
 13c:	02010413          	addi	s0,sp,32
 140:	fea42623          	sw	a0,-20(s0)
 144:	feb42423          	sw	a1,-24(s0)
 148:	fec42703          	lw	a4,-20(s0)
 14c:	fe842783          	lw	a5,-24(s0)
 150:	00f707b3          	add	a5,a4,a5
 154:	00078513          	mv	a0,a5
 158:	01c12403          	lw	s0,28(sp)
 15c:	02010113          	addi	sp,sp,32
 160:	00008067          	ret

00000164 <sub>:
 164:	fe010113          	addi	sp,sp,-32
 168:	00812e23          	sw	s0,28(sp)
 16c:	02010413          	addi	s0,sp,32
 170:	fea42623          	sw	a0,-20(s0)
 174:	feb42423          	sw	a1,-24(s0)
 178:	fec42703          	lw	a4,-20(s0)
 17c:	fe842783          	lw	a5,-24(s0)
 180:	40f707b3          	sub	a5,a4,a5
 184:	00078513          	mv	a0,a5
 188:	01c12403          	lw	s0,28(sp)
 18c:	02010113          	addi	sp,sp,32
 190:	00008067          	ret

00000194 <main>:
 194:	ff010113          	addi	sp,sp,-16
 198:	00112623          	sw	ra,12(sp)
 19c:	00812423          	sw	s0,8(sp)
 1a0:	01010413          	addi	s0,sp,16
 1a4:	02a00593          	li	a1,42
 1a8:	02a00513          	li	a0,42
 1ac:	e55ff0ef          	jal	ra,0 <and>
 1b0:	00050713          	mv	a4,a0
 1b4:	32c02783          	lw	a5,812(zero) # 32c <TX>
 1b8:	0ff77713          	zext.b	a4,a4
 1bc:	00e78023          	sb	a4,0(a5)
 1c0:	32c02783          	lw	a5,812(zero) # 32c <TX>
 1c4:	00a00713          	li	a4,10
 1c8:	00e78023          	sb	a4,0(a5)
 1cc:	00a00593          	li	a1,10
 1d0:	02000513          	li	a0,32
 1d4:	e5dff0ef          	jal	ra,30 <or>
 1d8:	00050713          	mv	a4,a0
 1dc:	32c02783          	lw	a5,812(zero) # 32c <TX>
 1e0:	0ff77713          	zext.b	a4,a4
 1e4:	00e78023          	sb	a4,0(a5)
 1e8:	32c02783          	lw	a5,812(zero) # 32c <TX>
 1ec:	00a00713          	li	a4,10
 1f0:	00e78023          	sb	a4,0(a5)
 1f4:	00a00593          	li	a1,10
 1f8:	02000513          	li	a0,32
 1fc:	e65ff0ef          	jal	ra,60 <xor>
 200:	00050713          	mv	a4,a0
 204:	32c02783          	lw	a5,812(zero) # 32c <TX>
 208:	0ff77713          	zext.b	a4,a4
 20c:	00e78023          	sb	a4,0(a5)
 210:	32c02783          	lw	a5,812(zero) # 32c <TX>
 214:	00a00713          	li	a4,10
 218:	00e78023          	sb	a4,0(a5)
 21c:	02a00513          	li	a0,42
 220:	e71ff0ef          	jal	ra,90 <comp>
 224:	00050793          	mv	a5,a0
 228:	00078513          	mv	a0,a5
 22c:	e65ff0ef          	jal	ra,90 <comp>
 230:	00050713          	mv	a4,a0
 234:	32c02783          	lw	a5,812(zero) # 32c <TX>
 238:	0ff77713          	zext.b	a4,a4
 23c:	00e78023          	sb	a4,0(a5)
 240:	32c02783          	lw	a5,812(zero) # 32c <TX>
 244:	00a00713          	li	a4,10
 248:	00e78023          	sb	a4,0(a5)
 24c:	00000513          	li	a0,0
 250:	e69ff0ef          	jal	ra,b8 <not>
 254:	00050793          	mv	a5,a0
 258:	0ff7f713          	zext.b	a4,a5
 25c:	32c02783          	lw	a5,812(zero) # 32c <TX>
 260:	02970713          	addi	a4,a4,41
 264:	0ff77713          	zext.b	a4,a4
 268:	00e78023          	sb	a4,0(a5)
 26c:	32c02783          	lw	a5,812(zero) # 32c <TX>
 270:	00a00713          	li	a4,10
 274:	00e78023          	sb	a4,0(a5)
 278:	01600593          	li	a1,22
 27c:	01400513          	li	a0,20
 280:	eb5ff0ef          	jal	ra,134 <add>
 284:	00050713          	mv	a4,a0
 288:	32c02783          	lw	a5,812(zero) # 32c <TX>
 28c:	0ff77713          	zext.b	a4,a4
 290:	00e78023          	sb	a4,0(a5)
 294:	32c02783          	lw	a5,812(zero) # 32c <TX>
 298:	00a00713          	li	a4,10
 29c:	00e78023          	sb	a4,0(a5)
 2a0:	00a00593          	li	a1,10
 2a4:	03400513          	li	a0,52
 2a8:	ebdff0ef          	jal	ra,164 <sub>
 2ac:	00050713          	mv	a4,a0
 2b0:	32c02783          	lw	a5,812(zero) # 32c <TX>
 2b4:	0ff77713          	zext.b	a4,a4
 2b8:	00e78023          	sb	a4,0(a5)
 2bc:	32c02783          	lw	a5,812(zero) # 32c <TX>
 2c0:	00a00713          	li	a4,10
 2c4:	00e78023          	sb	a4,0(a5)
 2c8:	01500513          	li	a0,21
 2cc:	e19ff0ef          	jal	ra,e4 <shl>
 2d0:	00050713          	mv	a4,a0
 2d4:	32c02783          	lw	a5,812(zero) # 32c <TX>
 2d8:	0ff77713          	zext.b	a4,a4
 2dc:	00e78023          	sb	a4,0(a5)
 2e0:	32c02783          	lw	a5,812(zero) # 32c <TX>
 2e4:	00a00713          	li	a4,10
 2e8:	00e78023          	sb	a4,0(a5)
 2ec:	05400513          	li	a0,84
 2f0:	e1dff0ef          	jal	ra,10c <shr>
 2f4:	00050713          	mv	a4,a0
 2f8:	32c02783          	lw	a5,812(zero) # 32c <TX>
 2fc:	0ff77713          	zext.b	a4,a4
 300:	00e78023          	sb	a4,0(a5)
 304:	32c02783          	lw	a5,812(zero) # 32c <TX>
 308:	00a00713          	li	a4,10
 30c:	00e78023          	sb	a4,0(a5)
 310:	00100073          	ebreak
 314:	00000793          	li	a5,0
 318:	00078513          	mv	a0,a5
 31c:	00c12083          	lw	ra,12(sp)
 320:	00812403          	lw	s0,8(sp)
 324:	01010113          	addi	sp,sp,16
 328:	00008067          	ret

*/
