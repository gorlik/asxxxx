	.title	asscmp Relocation With Globals

	.area	RELOC

	.globl	va, vb

lbl1:	add	lbl1
	add	lbl1 + va
	add	lbl1 + va + vb
1$:	add	1$
	add	.
2$:	add	2$ + va
	add	. + va
3$:	add	3$ + va + vb
	add	. + va + vb

lbl2:	jmp	lbl2
	jmp	lbl2 + va
	jmp	lbl2 + va + vb
1$:	jmp	1$
	jmp	.
2$:	jmp	2$ + va
	jmp	. + va
3$:	jmp	3$ + va + vb
	jmp	. + va + vb


