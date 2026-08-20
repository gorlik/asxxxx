	.title	asst7 Relocation With Globals

	.area	RELOC

	.globl	va, vb

lbl1:	call	lbl1
	call	lbl1 + va
	call	lbl1 + va + vb
1$:	call	1$
	call	.
2$:	call	2$ + va
	call	. + va
3$:	call	3$ + va + vb
	call	. + va + vb

lbl2:	callr	lbl2
	callr	lbl2 + va
	callr	lbl2 + va + vb
1$:	callr	1$
	callr	.
2$:	callr	2$ + va
	callr	. + va
3$:	callr	3$ + va + vb
	callr	. + va + vb

lbl3:	jp	lbl3
	jp	lbl3 + va
	jp	lbl3 + va + vb
1$:	jp	1$
	jp	.
2$:	jp	2$ + va
	jp	. + va
3$:	jp	3$ + va + vb
	jp	. + va + vb

lbl4:	jra	lbl4
	jra	lbl4 + va
	jra	lbl4 + va + vb
1$:	jra	1$
	jra	.
2$:	jra	2$ + va
	jra	. + va
3$:	jra	3$ + va + vb
	jra	. + va + vb

lbl5:	jreq	lbl5
	jreq	lbl5 + va
	jreq	lbl5 + va + vb
1$:	jreq	1$
	jreq	.
2$:	jreq	2$ + va
	jreq	. + va
3$:	jreq	3$ + va + vb
	jreq	. + va + vb

lbl6:	btjt	va, #vb, lbl6
	btjt	va, #vb, lbl6 + va
	btjt	va, #vb, lbl6 + va + vb
1$:	btjt	va, #vb, 1$
	btjt	va, #vb, .
2$:	btjt	va, #vb, 2$ + va
	btjt	va, #vb, . + va
3$:	btjt	va, #vb, 3$ + va + vb
	btjt	va, #vb, . + va + vb

