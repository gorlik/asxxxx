	.title	asf2mc8 Relocation With Globals

	.area	RELOC

	.globl	va, vb

lbl1:	bbs	va:va|vb, lbl1
	bbs	va:va|vb, lbl1 + va
	bbs	va:va|vb, lbl1 + va + vb
1$:	bbs	va:va|vb, 1$
	bbs	va:va|vb, .
2$:	bbs	va:va|vb, 2$ + va
	bbs	va:va|vb, . + va
3$:	bbs	va:va|vb, 3$ + va + vb
	bbs	va:va|vb, . + va + vb

lbl2:	bc	lbl2
	bc	lbl2 + va
	bc	lbl2 + va + vb
1$:	bc	1$
	bc	.
2$:	bc	2$ + va
	bc	. + va
3$:	bc	3$ + va + vb
	bc	. + va + vb

lbl3:	jmp	lbl3
	jmp	lbl3 + va
	jmp	lbl3 + va + vb
1$:	jmp	1$
	jmp	.
2$:	jmp	2$ + va
	jmp	. + va
3$:	jmp	3$ + va + vb
	jmp	. + va + vb

lbl4:	call	lbl4
	call	lbl4 + va
	call	lbl4 + va + vb
1$:	call	1$
	call	.
2$:	call	2$ + va
	call	. + va
3$:	call	3$ + va + vb
	call	. + va + vb


