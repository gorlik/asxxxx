	.title	asz8 Relocation With Globals

	.area	RELOC

	.globl	va, vb

lbl1:	call	lbl1
	call	lbl1 + va
	call	lbl1 + va + vb
1$:	call	1$
	call	.
2$:	call	2$ + va
	call	. + va
3$:	call	3$ + va + vb
	call	. + va + vb

lbl2:	call	lbl2
	call	lbl2 + va
	call	lbl2 + va + vb
1$:	call	1$
	call	.
2$:	call	2$ + va
	call	. + va
3$:	call	3$ + va + vb
	call	. + va + vb


lbl3:	djnz	r0, lbl3
	djnz	r0, lbl3 + va
	djnz	r0, lbl3 + va + vb
1$:	djnz	r0, 1$
	djnz	r0, .
2$:	djnz	r0, 2$ + va
	djnz	r0, . + va
3$:	djnz	r0, 3$ + va + vb
	djnz	r0, . + va + vb

lbl4:	jp	lbl4
	jp	lbl4 + va
	jp	lbl4 + va + vb
1$:	jp	1$
	jp	.
2$:	jp	2$ + va
	jp	. + va
3$:	jp	3$ + va + vb
	jp	. + va + vb

lbl5:	jp	z, lbl5
	jp	z, lbl5 + va
	jp	z, lbl5 + va + vb
1$:	jp	z, 1$
	jp	z, .
2$:	jp	z, 2$ + va
	jp	z, . + va
3$:	jp	z, 3$ + va + vb
	jp	z, . + va + vb

lbl6:	jr	lbl6
	jr	lbl6 + va
	jr	lbl6 + va + vb
1$:	jr	1$
	jr	.
2$:	jr	2$ + va
	jr	. + va
3$:	jr	3$ + va + vb
	jr	. + va + vb

lbl7:	jr	z, lbl7
	jr	z, lbl7 + va
	jr	z, lbl7 + va + vb
1$:	jr	z, 1$
	jr	z, .
2$:	jr	z, 2$ + va
	jr	z, . + va
3$:	jr	z, 3$ + va + vb
	jr	z, . + va + vb


