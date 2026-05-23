.nlist
;****************************************************************************
;
; Compile The Assembly Code
;
;	AS89LP -loxff print.asm
;
; To Include The print.asm Macros Place The Following Lines In Your Code
;
;	.define _print
;	.list	(!)	; This Inhibits The Include File Pagination
;	.include "print.asm"
;	.list
;
; The Assembled Code Is Register Bank Independent
; 
;****************************************************************************
;
; PRINT.ASM Macros In A Macro
;
.macro	.print.macros	arg$
	  .iifne  arg$	.list	(!,src,me)

;****************************************************************************
;
;	print.asm Support Macros
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
;	PUSH and POP Macros For Use Inside Macros
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.macro	.spush	arg
	  .list	(!,err,loc,bin,cyc,eqt,lin,src,me)
	  push	arg
	  .nlist
	.endm

	.macro	.spop	arg
	  .list	(!,err,loc,bin,cyc,eqt,lin,src,me)
	  pop	arg
	  .nlist
	.endm
;
;****************************************************************************
;
;	.print	- Outputs An EOS Terminated String To
;		  The Serial Port From Code Space
;

	.macro	.cprint	string,crlf,ppx$
	  .globl SP0_MCT
	  .iifnb ppx$,	.spush	dph
	  .iifnb ppx$,	.spush	dpl
	  .list	(!,err,loc,bin,eqt,cyc,lin,src,me)
	  mov	dptr,#string
	  lcall SP0_MCT
	  .nlist
	  .iifnb crlf,	.pcrlf
	  .iifnb ppx$,	.spop	dpl
	  .iifnb ppx$,	.spop	dph
	.endm	

;
;****************************************************************************
;
;	.print	- Outputs An EOS Terminated String To
;		  The Serial Port From Data/IData Space
;

	.macro	.dprint	string,crlf,ppx$
	  .globl SP0_MDT
	  .iifnb ppx$,	.spush	r0
	  .list	(!,err,loc,bin,eqt,cyc,lin,src,me)
	  mov	r0,#string
	  lcall SP0_MDT
	  .nlist
	  .iifnb crlf,	.pcrlf
	  .iifnb ppx$,	.spop	r0
	.endm	

;
;****************************************************************************
;
;	.print	- Outputs An EOS Terminated String To
;		  The Serial Port From External Ram Space
;

	.macro	.xprint	string,crlf,ppx$
	  .globl SP0_MXT
	  .iifnb ppx$,	.spush	dph
	  .iifnb ppx$,	.spush	dpl
	  .list	(!,err,loc,bin,eqt,cyc,lin,src,me)
	  mov	dptr,#string
	  lcall SP0_MXT
	  .nlist
	  .iifnb crlf,	.pcrlf
	  .iifnb ppx$,	.spop	dpl
	  .iifnb ppx$,	.spop	dph
	.endm	

;
;****************************************************************************
;
;	.print	- Outputs A CR/LF
;		  To The Serial Port
;

	.macro	.pcrlf
	  .globl m.pcrlf
	  .list	(!,err,loc,bin,eqt,cyc,lin,src,me)
	  lcall	m.pcrlf
	.endm	

;****************************************************************************
.endm

;****************************************************************************
.ifdef	_print
	.list	(!,src)
;	print.asm       Macros                  Defined
	.nlist

	.print.macros	0
.else
	.list
	.title	Print Code

	.module	PRINT

;****************************************************************************
;
;  Includes
;
	.list	(!)	; This Inhibits The Include File Pagination
	.include "lp3240.sfr"
	.list
;
;****************************************************************************

	.globl	m.pcrlf
	.globl	SP0_OUT

	.area	Code

m.pcrlf:
	push	a
	mov	a,#0x0D		; CR
	lcall	SP0_OUT
	mov	a,#0x0A		; LF
	lcall	SP0_OUT
	pop	a
	ret

;****************************************************************************

	.end

.endif	; else of _print
;
;****************************************************************************

