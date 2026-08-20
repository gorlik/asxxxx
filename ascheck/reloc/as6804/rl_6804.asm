	.title	as6804 Relocation With Globals

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

.if 0
lbl2:	bsr	lbl2
	bsr	lbl2 + va
	bsr	lbl2 + va + vb
1$:	bsr	1$
	bsr	.
2$:	bsr	2$ + va
	bsr	. + va
3$:	bsr	3$ + va + vb
	bsr	. + va + vb
.endif

lbl3:	jmp	lbl3
	jmp	lbl3 + va
	jmp	lbl3 + va + vb
1$:	jmp	1$
	jmp	.
2$:	jmp	2$ + va
	jmp	. + va
3$:	jmp	3$ + va + vb
	jmp	. + va + vb

lbl4:	jsr	lbl4
	jsr	lbl4 + va
	jsr	lbl4 + va + vb
1$:	jsr	1$
	jsr	.
2$:	jsr	2$ + va
	jsr	. + va
3$:	jsr	3$ + va + vb
	jsr	. + va + vb


