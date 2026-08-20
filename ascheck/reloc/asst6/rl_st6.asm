	.title	asst6 Relocation With Globals

	.area	RELOC

	.globl	va, vb

lbl1:	jp	lbl1
	jp	lbl1 + va
	jp	lbl1 + va + vb
1$:	jp	1$
	jp	.
2$:	jp	2$ + va
	jp	. + va
3$:	jp	3$ + va + vb
	jp	. + va + vb

lbl2:	call	lbl2
	call	lbl2 + va
	call	lbl2 + va + vb
1$:	call	1$
	call	.
2$:	call	2$ + va
	call	. + va
3$:	call	3$ + va + vb
	call	. + va + vb

lbl3:	jrc	lbl3
	jrc	lbl3 + va
	jrc	lbl3 + va + vb
1$:	jrc	1$
	jrc	.
2$:	jrc	2$ + va
	jrc	. + va
3$:	jrc	3$ + va + vb
	jrc	. + va + vb

lbl4:	jrr	vb, va+vb, lbl4
	jrr	vb, va+vb, lbl4 + va
	jrr	vb, va+vb, lbl4 + va + vb
1$:	jrr	vb, va+vb, 1$
	jrr	vb, va+vb, .
2$:	jrr	vb, va+vb, 2$ + va
	jrr	vb, va+vb, . + va
3$:	jrr	vb, va+vb, 3$ + va + vb
	jrr	vb, va+vb, . + va + vb

