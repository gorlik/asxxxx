	.title	as6811 Relocation With Globals

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

lbl2:	jp	lbl2
	jp	lbl2 + va
	jp	lbl2 + va + vb
1$:	jp	1$
	jp	.
2$:	jp	2$ + va
	jp	. + va
3$:	jp	3$ + va + vb
	jp	. + va + vb

lbl3:	jsr	lbl3
	jsr	lbl3 + va
	jsr	lbl3 + va + vb
1$:	jsr	1$
	jsr	.
2$:	jsr	2$ + va
	jsr	. + va
3$:	jsr	3$ + va + vb
	jsr	. + va + vb


