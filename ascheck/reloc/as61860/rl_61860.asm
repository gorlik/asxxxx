	.title	as61860 Relocation With Globals

	.area	RELOC

	.globl	va, vb

bgn:


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

	.nval	val,(. - bgn)

	. = . + (0x100 - val)
 
lbl3:	cal	lbl3
	cal	lbl3 + va
	cal	lbl3 + va + vb
1$:	cal	1$
	cal	.
2$:	cal	2$ + va
	cal	. + va
3$:	cal	3$ + va + vb
	cal	. + va + vb

