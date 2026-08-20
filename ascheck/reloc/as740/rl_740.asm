	.title	as740 Relocation With Globals

	.area	RELOC

	.globl	va, vb

lbl1:	bra	lbl1
	bra	lbl1 + va
	bra	lbl1 + va + vb
1$:	bra	1$
	bra	.
2$:	bra	2$ + va
	bra	. + va
3$:	bra	3$ + va + vb
	bra	. + va + vb

lbl2:	jmp	lbl2
	jmp	lbl2 + va
	jmp	lbl2 + va + vb
1$:	jmp	1$
	jmp	.
2$:	jmp	2$ + va
	jmp	. + va
3$:	jmp	3$ + va + vb
	jmp	. + va + vb

lbl3:	jsr	lbl3
	jsr	lbl3 + va
	jsr	lbl3 + va + vb
1$:	jsr	1$
	jsr	.
2$:	jsr	2$ + va
	jsr	. + va
3$:	jsr	3$ + va + vb
	jsr	. + va + vb


