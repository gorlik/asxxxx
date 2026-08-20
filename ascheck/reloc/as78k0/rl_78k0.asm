	.title	as78k0 Relocation With Globals

	.area	RELOC

	.globl	va, vb

lbl1:	br	lbl1
	br	lbl1 + va
	br	lbl1 + va + vb
1$:	br	1$
	br	.
2$:	br	2$ + va
	br	. + va
3$:	br	3$ + va + vb
	br	. + va + vb

lbl2:	bc	lbl2
	bc	lbl2 + va
	bc	lbl2 + va + vb
1$:	bc	1$
	bc	.
2$:	bc	2$ + va
	bc	. + va
3$:	bc	3$ + va + vb
	bc	. + va + vb

lbl3:	call	lbl3
	call	lbl3 + va
	call	lbl3 + va + vb
1$:	call	1$
	call	.
2$:	call	2$ + va
	call	. + va
3$:	call	3$ + va + vb
	call	. + va + vb

lbl4:	br	!lbl4
	br	!lbl4 + va
	br	!lbl4 + va + vb
1$:	br	!1$
	br	!.
2$:	br	!2$ + va
	br	!. + va
3$:	br	!3$ + va + vb
	br	!. + va + vb


