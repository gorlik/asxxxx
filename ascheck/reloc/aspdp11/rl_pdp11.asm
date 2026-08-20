	.title	as6811 Relocation With Globals

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

lbl2:	sob	r0, lbl2
	sob	r0, lbl2 + 0
	sob	r0, lbl2 + 0 + 2
1$:	sob	r0, 1$
	sob	r0, .
2$:	sob	r0, 2$ + 0
	sob	r0, . + 0
3$:	sob	r0, 3$ + 0 + 2
	sob	r0, . + 0 + 2

lbl3:	jmp	lbl3
	jmp	lbl3 + va
	jmp	lbl3 + va + vb
1$:	jmp	1$
	jmp	.
2$:	jmp	2$ + va
	jmp	. + va
3$:	jmp	3$ + va + vb
	jmp	. + va + vb

lbl4:	jsr	r7, lbl4
	jsr	r7, lbl4 + va
	jsr	r7, lbl4 + va + vb
1$:	jsr	r7, 1$
	jsr	r7, .
2$:	jsr	r7, 2$ + va
	jsr	r7, . + va
3$:	jsr	r7, 3$ + va + vb
	jsr	r7, . + va + vb

