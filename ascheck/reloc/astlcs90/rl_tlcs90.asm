	.title	astlcs90 Relocation With Globals

	.area	RELOC

	.globl	va, vb

lbl1:	jp	lbl1
1$:	jp	1$
	jp	.
	jp	. + va
	jp	. + va + vb

lbl2:	jr	lbl2
1$:	jr	1$
	jr	.
	jr	. + va
	jr	. + va + vb

lbl3:	jrl	lbl3
1$:	jrl	1$
	jrl	.
	jrl	. + va
	jrl	. + va + vb

lbl4:	call	lbl4
1$:	call	1$
	call	.
	call	. + va
	call	. + va + vb

lbl5:	calr	lbl5
1$:	calr	1$
	calr	.
	calr	. + va
	calr	. + va + vb

lbl6:	djnz	lbl6
1$:	djnz	1$
	djnz	pc
	djnz	. + va
	djnz	. + va + vb

