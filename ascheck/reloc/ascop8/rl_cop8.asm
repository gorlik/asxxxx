	.title	ascop8 Relocation With Globals

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

lbl2:	jmpl	lbl2
	jmpl	lbl2 + va
	jmpl	lbl2 + va + vb
1$:	jmpl	1$
	jmpl	.
2$:	jmpl	2$ + va
	jmpl	. + va
3$:	jmpl	3$ + va + vb
	jmpl	. + va + vb

lbl3:	jsr	lbl3
	jsr	lbl3 + va
	jsr	lbl3 + va + vb
1$:	jsr	1$
	jsr	.
2$:	jsr	2$ + va
	jsr	. + va
3$:	jsr	3$ + va + vb
	jsr	. + va + vb

lbl4:	jsrl	lbl4
	jsrl	lbl4 + va
	jsrl	lbl4 + va + vb
1$:	jsrl	1$
	jsrl	.
2$:	jsrl	2$ + va
	jsrl	. + va
3$:	jsrl	3$ + va + vb
	jsrl	. + va + vb


