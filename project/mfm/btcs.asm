.nlist
;****************************************************************************
;
; Compile The Assembly Code
;
;	AS89LP -loxff btcs.asm
;
; To Define The btcs.asm Globals Place The Following Lines In Your Code
;
;	.define _btcs
;	.list	(!)	; This Inhibits The Include File Pagination
;	.include "btcs.asm"
;	.list
;
;****************************************************************************
;
; BTCS.ASM Globals In A Macro
;
	.macro	.btcs.globals	arg$
	  .iifne  arg$	.list	(!,src,me)
  	  .globl	x1clrb,	x1setb,	x2clrb,	x2setb
	  .nlist
	.endm
;
;****************************************************************************
;
;	Macro Implementation
;
	.macro	.x1setb
	  .list	(!,err,loc,bin,cyc,eqt,lin,src,me)
	  mov	dptr,#xtbits
	  mov	a,#(x1.btwt | x1.btx1)
	  movx	@dptr,a
	  .nlist
	.endm

	.macro	.x1clrb
	  .list	(!,err,loc,bin,cyc,eqt,lin,src,me)
	  mov	dptr,#xtbits
	  mov	a,#(x1.btwt | 0)
	  movx	@dptr,a
	  .nlist
	.endm

	.macro	.x2setb
	  .list	(!,err,loc,bin,cyc,eqt,lin,src,me)
	  mov	dptr,#xtbits
	  mov	a,#(x2.btwt | x2.btx2)
	  movx	@dptr,a
	  .nlist
	.endm

	.macro	.x2clrb
	  .list	(!,err,loc,bin,cyc,eqt,lin,src,me)
	  mov	dptr,#xtbits
	  mov	a,#(x2.btwt | 0)
	  movx	@dptr,a
	  .nlist
	.endm
;
;****************************************************************************
;
.ifdef _btcs
	.list	(!,src)
;	btcs.asm        Globals                 Defined
	.nlist

	.btcs.globals	0
.else
	.list
	.title	Diagnostic Pin Bit Clr/Set

	.module	BTCS

	.btcs.globals	1

;
;****************************************************************************
;
; Include SFR, Global, And System Definitions
;
	.list	(!)	; This Inhibits The Include File Pagination
	.include "lp3240.sfr"
	.list
	.list	(!)	; This Inhibits The Include File Pagination
	.include "ascii.def"
	.list
	.list	(!)	; This Inhibits The Include File Pagination
	.include "ioreg.def"
	.list
;
;****************************************************************************
;
	.area	Debug

;
;	Set X1 Bit
;
x1setb:	.x1setb
	ret
;
;	Clear X1 Bit
;
x1clrb:	.x1clrb
	ret
;
;	Set X2 Bit
;
x2setb:	.x2setb
	ret
;
;	Clear X2 Bit
;
x2clrb:	.x2clrb
	ret

.endif
