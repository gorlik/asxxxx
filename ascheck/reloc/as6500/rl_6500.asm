	.title	as6500 Relocation With Globals

	.area	RELOC

	.globl	va, vb

lbl1:	bcc	lbl1
	bcc	lbl1 + va
	bcc	lbl1 + va + vb
1$:	bcc	1$
	bcc	.
2$:	bcc	2$ + va
	bcc	. + va
3$:	bcc	3$ + va + vb
	bcc	. + va + vb

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


