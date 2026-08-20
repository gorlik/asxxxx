	.title	asm8c Relocation With Globals

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

lbl2:	lcall	lbl2
	lcall	lbl2 + va
	lcall	lbl2 + va + vb
1$:	lcall	1$
	lcall	.
2$:	lcall	2$ + va
	lcall	. + va
3$:	lcall	3$ + va + vb
	lcall	. + va + vb

lbl3:	jmp	lbl3
	jmp	lbl3 + va
	jmp	lbl3 + va + vb
1$:	jmp	1$
	jmp	.
2$:	jmp	2$ + va
	jmp	. + va
3$:	jmp	3$ + va + vb
	jmp	. + va + vb

lbl4:	ljmp	lbl4
	ljmp	lbl4 + va
	ljmp	lbl4 + va + vb
1$:	ljmp	1$
	ljmp	.
2$:	ljmp	2$ + va
	ljmp	. + va
3$:	ljmp	3$ + va + vb
	ljmp	. + va + vb

lbl5:	jacc	lbl5
	jacc	lbl5 + va
	jacc	lbl5 + va + vb
1$:	jacc	1$
	jacc	.
2$:	jacc	2$ + va
	jacc	. + va
3$:	jacc	3$ + va + vb
	jacc	. + va + vb

lbl6:	jz	lbl6
	jz	lbl6 + va
	jz	lbl6 + va + vb
1$:	jz	1$
	jz	.
2$:	jz	2$ + va
	jz	. + va
3$:	jz	3$ + va + vb
	jz	. + va + vb


