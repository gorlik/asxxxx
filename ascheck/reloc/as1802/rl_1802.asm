	.title	as1802 Relocation With Branching

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

