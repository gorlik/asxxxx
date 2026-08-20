	.title	asrab Relocation With jpnching

	.area	RELOC

	.globl	va, vb

rx:

	lcall va >> 12, va | 0xf000
	lcall vb >> 12, vb | 0xf000
	lcall rx >> 12, rx | 0xf000
	lcall rx >> (12), rx | (0xf000)
	lcall 10$ >> 12, 2$ | 0xf000
	lcall ry >> 12, ry | 0xf000

	lcall ry >> va, ry | vb

	lcall 10$ >> va, ry | 0xf000

	.nval	v,.
	. = . - v + 0x9090

10$:	.blkb	1
2$:
	. = . + 4
ry:
	lcall rx >> 12, rx | 0xf000
	lcall 100$ >> 12, 2$ | 0xf000

100$:	.blkb	1
2$:

lbl1:	jp	lbl1
	jp	lbl1 + va
	jp	lbl1 + va + vb
1$:	jp	1$
	jp	.
2$:	jp	2$ + va
	jp	. + va
3$:	jp	3$ + va + vb
	jp	. + va + vb

lbl2:	jp	nc, lbl2
	jp	nc, lbl2 + va
	jp	nc, lbl2 + va + vb
1$:	jp	nc, 1$
	jp	nc, .
2$:	jp	nc, 2$ + va
	jp	nc, . + va
3$:	jp	nc, 3$ + va + vb
	jp	nc, . + va + vb

lbl3:	jr	lbl3
	jr	lbl3 + va
	jr	lbl3 + va + vb
1$:	jr	1$
	jr	.
2$:	jr	2$ + va
	jr	. + va
3$:	jr	3$ + va + vb
	jr	. + va + vb

lbl4:	jr	nz, lbl4
	jr	nz, lbl4 + va
	jr	nz, lbl4 + va + vb
1$:	jr	nz, 1$
	jr	nz, .
2$:	jr	nz, 2$ + va
	jr	nz, . + va
3$:	jr	nz, 3$ + va + vb
	jr	nz, . + va + vb

lbl5:	call	lbl5
	call	lbl5 + va
	call	lbl5 + va + vb
1$:	call	1$
	call	.
2$:	call	2$ + va
	call	. + va
3$:	call	3$ + va + vb
	call	. + va + vb

lbl6:	djnz	lbl6
	djnz	lbl6 + va
	djnz	lbl6 + va + vb
1$:	djnz	1$
	djnz	.
2$:	djnz	2$ + va
	djnz	. + va
3$:	djnz	3$ + va + vb
	djnz	. + va + vb



