	.title	as68cf Relocation With Globals

	.area	RELOC

	.globl	va, vb

	.enabl	(flt)

lbl1:	bra.s	lbl1
	bra.s	lbl1 + va
	bra.s	lbl1 + va + vb
1$:	bra.s	1$
	bra.s	.
2$:	bra.s	2$ + va
	bra.s	. + va
3$:	bra.s	3$ + va + vb
	bra.s	. + va + vb

lbl2:	fbeq	lbl2
	fbeq	lbl2 + va
	fbeq	lbl2 + va + vb
1$:	fbeq	1$
	fbeq	.
2$:	fbeq	2$ + va
	fbeq	. + va
3$:	fbeq	3$ + va + vb
	fbeq	. + va + vb

lbl3:	jmp	lbl3
	jmp	lbl3 + va
	jmp	lbl3 + va + vb
1$:	jmp	1$
	jmp	.
2$:	jmp	2$ + va
	jmp	. + va
3$:	jmp	3$ + va + vb
	jmp	. + va + vb

	jmp	va(pc)
	jmp	(va,pc)
	jmp	va+vb(pc)
	jmp	(va+vb,pc)
	jmp	2(pc)
	jmp	(2,pc)

	jmp	va(pc,a1)
	jmp	(va,pc,a2)
	jmp	va+vb(pc,a3)
	jmp	(va+vb,pc,a4)
	jmp	2(pc,a5)
	jmp	(2,pc,a6)

lbl4:	jsr	lbl4
	jsr	lbl4 + va
	jsr	lbl4 + va + vb
1$:	jsr	1$
	jsr	.
2$:	jsr	2$ + va
	jsr	. + va
3$:	jsr	3$ + va + vb
	jsr	. + va + vb

	jsr	va(pc)
	jsr	(va,pc)
	jsr	va+vb(pc)
	jsr	(va+vb,pc)
	jsr	2(pc)
	jsr	(2,pc)

	jsr	va(pc,a1)
	jsr	(va,pc,a2)
	jsr	va+vb(pc,a3)
	jsr	(va+vb,pc,a4)
	jsr	2(pc,a5)
	jsr	(2,pc,a6)

