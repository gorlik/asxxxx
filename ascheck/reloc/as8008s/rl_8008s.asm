	.title	as8008s Relocation With Globals

	.area	RELOC

	.globl	va, vb

lbl1:	jmp	lbl1
	jmp	lbl1 + va
	jmp	lbl1 + va + vb
1$:	jmp	1$
	jmp	.
2$:	jmp	2$ + va
	jmp	. + va
3$:	jmp	3$ + va + vb
	jmp	. + va + vb

lbl2:	jfc	lbl2
	jfc	lbl2 + va
	jfc	lbl2 + va + vb
1$:	jfc	1$
	jfc	.
2$:	jfc	2$ + va
	jfc	. + va
3$:	jfc	3$ + va + vb
	jfc	. + va + vb

lbl3:	cal	lbl3
	cal	lbl3 + va
	cal	lbl3 + va + vb
1$:	cal	1$
	cal	.
2$:	cal	2$ + va
	cal	. + va
3$:	cal	3$ + va + vb
	cal	. + va + vb

lbl4:	ctc	lbl4
	ctc	lbl4 + va
	ctc	lbl4 + va + vb
1$:	ctc	1$
	ctc	.
2$:	ctc	2$ + va
	ctc	. + va
3$:	ctc	3$ + va + vb
	ctc	. + va + vb


