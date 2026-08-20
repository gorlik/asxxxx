	.title	asgb Relocation With Globals

	.area	RELOC

	.globl	va, vb

lbl1:	jp	lbl1
	jp	lbl1 + va
	jp	lbl1 + va + vb
1$:	jp	1$
	jp	.
2$:	jp	2$ + va
	jp	. + va
3$:	jp	3$ + va + vb
	jp	. + va + vb

lbl2:	jp	nz, lbl2
	jp	nz, lbl2 + va
	jp	nz, lbl2 + va + vb
1$:	jp	nz, 1$
	jp	nz, .
2$:	jp	nz, 2$ + va
	jp	nz, . + va
3$:	jp	nz, 3$ + va + vb
	jp	nz, . + va + vb

lbl3:	jr	lbl3
	jr	lbl3 + va
	jr	lbl3 + va + vb
1$:	jr	1$
	jr	.
2$:	jr	2$ + va
	jr	. + va
3$:	jr	3$ + va + vb
	jr	. + va + vb

lbl4:	jr	nc, lbl4
	jr	nc, lbl4 + va
	jr	nc, lbl4 + va + vb
1$:	jr	nc, 1$
	jr	nc, .
2$:	jr	nc, 2$ + va
	jr	nc, . + va
3$:	jr	nc, 3$ + va + vb
	jr	nc, . + va + vb

lbl5:	call	lbl5
	call	lbl5 + va
	call	lbl5 + va + vb
1$:	call	1$
	call	.
2$:	call	2$ + va
	call	. + va
3$:	call	3$ + va + vb
	call	. + va + vb

lbl6:	call	z, lbl6
	call	z, lbl6 + va
	call	z, lbl6 + va + vb
1$:	call	z, 1$
	call	z, .
2$:	call	z, 2$ + va
	call	z, . + va
3$:	call	z, 3$ + va + vb
	call	z, . + va + vb


