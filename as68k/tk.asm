	.68020			; Select 68020 Processor
	.68882			; Select 68882 Floating Point Co-Processor
	.enabl	(alt)		; Allow Alternate Instructions

	.area	Test	(rel,con)

	.globl	xb, xw
	.globl	xtrn1, xtrn2

	  ;
	  ; External Addressing
	  ;

	  ; d16(An) / (d16,An)

	cmp	(xb+0x12)(A5),D6	; BC 6D 01 70 00 00 00
	cmp	(xw+0x1234)(A5),D6	; BC 6D 01 70 00 00 12
;	cmp	((xb+0x12),A5),D7	; BE 6D 01 70 00 00 00
;	cmp	((xw+0x1234),A5),D7	; BE 6D 01 70 00 00 12

	xtrn1	= 0x14
	xtrn2	= . + 2

	.word	xtrn1
	.word	xtrn2

