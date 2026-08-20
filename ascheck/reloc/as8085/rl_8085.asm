	.title	as8085 Relocation With Globals

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

lbl2:	call	lbl2
	call	lbl2 + va
	call	lbl2 + va + vb
1$:	call	1$
	call	.
2$:	call	2$ + va
	call	. + va
3$:	call	3$ + va + vb
	call	. + va + vb

lbl3:	jc	lbl3
	jc	lbl3 + va
	jc	lbl3 + va + vb
1$:	jc	1$
	jc	.
2$:	jc	2$ + va
	jc	. + va
3$:	jc	3$ + va + vb
	jc	. + va + vb

lbl4:	cc	lbl4
	cc	lbl4 + va
	cc	lbl4 + va + vb
1$:	cc	1$
	cc	.
2$:	cc	2$ + va
	cc	. + va
3$:	cc	3$ + va + vb
	cc	. + va + vb


