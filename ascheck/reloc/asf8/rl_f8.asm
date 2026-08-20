	.title	as6811 Relocation With Globals

	.area	RELOC

	.globl	va, vb

lbl1:	br7	lbl1
	br7	lbl1 + va
	br7	lbl1 + va + vb
1$:	br7	1$
	br7	.
2$:	br7	2$ + va
	br7	. + va
3$:	br7	3$ + va + vb
	br7	. + va + vb

lbl2:	bf	vb, lbl2
	bf	vb, lbl2 + va
	bf	vb, lbl2 + va + vb
1$:	bf	vb, 1$
	bf	vb, .
2$:	bf	vb, 2$ + va
	bf	vb, . + va
3$:	bf	vb, 3$ + va + vb
	bf	vb, . + va + vb

lbl3:	jmp	lbl3
	jmp	lbl3 + va
	jmp	lbl3 + va + vb
1$:	jmp	1$
	jmp	.
2$:	jmp	2$ + va
	jmp	. + va
3$:	jmp	3$ + va + vb
	jmp	. + va + vb


