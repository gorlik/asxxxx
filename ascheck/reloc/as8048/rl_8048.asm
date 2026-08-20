	.title	as8048 Relocation With Globals

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

lbl2:	jz	lbl2
	jz	lbl2 + va
	jz	lbl2 + va + vb
1$:	jz	1$
	jz	.
2$:	jz	2$ + va
	jz	. + va
3$:	jz	3$ + va + vb
	jz	. + va + vb

lbl3:	call	lbl3
	call	lbl3 + va
	call	lbl3 + va + vb
1$:	call	1$
	call	.
2$:	call	2$ + va
	call	. + va
3$:	call	3$ + va + vb
	call	. + va + vb

lbl4:	djnz	r1, lbl4
	djnz	r1, lbl4 + va
	djnz	r1, lbl4 + va + vb
1$:	djnz	r1, 1$
	djnz	r1, .
2$:	djnz	r1, 2$ + va
	djnz	r1, . + va
3$:	djnz	r1, 3$ + va + vb
	djnz	r1, . + va + vb


