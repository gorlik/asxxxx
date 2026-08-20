	.title	as430 Relocation With Globals

	.area	RELOC

	.globl	va, vb

lbl1:	jnz	lbl1
	jnz	lbl1 + va
	jnz	lbl1 + va + vb
1$:	jnz	1$
	jnz	.
2$:	jnz	2$ + va
	jnz	. + va
3$:	jnz	3$ + va + vb
	jnz	. + va + vb

lbl2:	jmp	lbl2
	jmp	lbl2 + va
	jmp	lbl2 + va + vb
1$:	jmp	1$
	jmp	.
2$:	jmp	2$ + va
	jmp	. + va
3$:	jmp	3$ + va + vb
	jmp	. + va + vb

lbl3:	call	lbl3
	call	lbl3 + va
	call	lbl3 + va + vb
1$:	call	1$
	call	.
2$:	call	2$ + va
	call	. + va
3$:	call	3$ + va + vb
	call	. + va + vb


