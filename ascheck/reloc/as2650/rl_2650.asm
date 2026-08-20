	.title	as2650 Relocation With globals
	.area	RELOC

	.globl	va

lbl:	bcfr	.eq.,lbl
1$:	bcfr	.eq.,1$
	bcfr	.eq.,.
	bcfr	.eq.,. + va
