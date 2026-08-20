	.title	as6100 Relocation With Globals

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


