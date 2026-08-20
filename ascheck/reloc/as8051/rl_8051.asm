	.title	as8051 Relocation With Globals

	.area	RELOC

	.globl	va, vb

lbl1:	ajmp	lbl1
	ajmp	lbl1 + va
	ajmp	lbl1 + va + vb
1$:	ajmp	1$
	ajmp	.
2$:	ajmp	2$ + va
	ajmp	. + va
3$:	ajmp	3$ + va + vb
	ajmp	. + va + vb

lbl2:	ljmp	lbl2
	ljmp	lbl2 + va
	ljmp	lbl2 + va + vb
1$:	ljmp	1$
	ljmp	.
2$:	ljmp	2$ + va
	ljmp	. + va
3$:	ljmp	3$ + va + vb
	ljmp	. + va + vb

lbl3:	sjmp	lbl3
	sjmp	lbl3 + va
	sjmp	lbl3 + va + vb
1$:	sjmp	1$
	sjmp	.
2$:	sjmp	2$ + va
	sjmp	. + va
3$:	sjmp	3$ + va + vb
	sjmp	. + va + vb

lbl4:	jc	lbl4
	jc	lbl4 + va
	jc	lbl4+ va + vb
1$:	jc	1$
	jc	.
2$:	jc	2$ + va
	jc	. + va
3$:	jc	3$ + va + vb
	jc	. + va + vb

lbl5:	acall	lbl5
	acall	lbl5 + va
	acall	lbl5 + va + vb
1$:	acall	1$
	acall	.
2$:	acall	2$ + va
	acall	. + va
3$:	acall	3$ + va + vb
	acall	. + va + vb

lbl6:	lcall	lbl6
	lcall	lbl6 + va
	lcall	lbl6 + va + vb
1$:	lcall	1$
	lcall	.
2$:	lcall	2$ + va
	lcall	. + va
3$:	lcall	3$ + va + vb
	lcall	. + va + vb

lbl7:	cjne	r1, #10, lbl7
	cjne	r1, #10, lbl7 + va
	cjne	r1, #10, lbl7 + va + vb
1$:	cjne	r1, #10, 1$
	cjne	r1, #10, .
2$:	cjne	r1, #10, 2$ + va
	cjne	r1, #10, . + va
3$:	cjne	r1, #10, 3$ + va + vb
	cjne	r1, #10, . + va + vb

lbl8:	djnz	r1, lbl8
	djnz	r1, lbl8 + va
	djnz	r1, lbl8 + va + vb
1$:	djnz	r1, 1$
	djnz	r1, .
2$:	djnz	r1, 2$ + va
	djnz	r1, . + va
3$:	djnz	r1, 3$ + va + vb
	djnz	r1, . + va + vb


