	.title	asavr Relocation With Globals

	.area	RELOC

	.globl	va, vb

lbl1:	brcs	lbl1
	brcs	lbl1 + va
	brcs	lbl1 + va + vb
1$:	brcs	1$
	brcs	.
2$:	brcs	2$ + va
	brcs	. + va
3$:	brcs	3$ + va + vb
	brcs	. + va + vb

lbl2:	rjmp	lbl2
	rjmp	lbl2 + va
	rjmp	lbl2 + va + vb
1$:	rjmp	1$
	rjmp	.
2$:	rjmp	2$ + va
	rjmp	. + va
3$:	rjmp	3$ + va + vb
	rjmp	. + va + vb

lbl3:	rcall	lbl3
	rcall	lbl3+ va
	rcall	lbl3 + va + vb
1$:	rcall	1$
	rcall	.
2$:	rcall	2$ + va
	rcall	. + va
3$:	rcall	3$ + va + vb
	rcall	. + va + vb


