	.title	asz280 Relocation With Globals

	.area	RELOC

	.globl	va, vb

lbl1:	djnz	lbl1
	djnz	lbl1 + va
	djnz	lbl1 + va + vb
1$:	djnz	1$
	djnz	.
2$:	djnz	2$ + va
	djnz	. + va
3$:	djnz	3$ + va + vb
	djnz	. + va + vb

lbl2:	jr	lbl2
	jr	lbl2 + va
	jr	lbl2 + va + vb
1$:	jr	1$
	jr	.
2$:	jr	2$ + va
	jr	. + va
3$:	jr	3$ + va + vb
	jr	. + va + vb

lbl3:	jr	z, lbl3
	jr	z, lbl3 + va
	jr	z, lbl3 + va + vb
1$:	jr	z, 1$
	jr	z, .
2$:	jr	z, 2$ + va
	jr	z, . + va
3$:	jr	z, 3$ + va + vb
	jr	z, . + va + vb


