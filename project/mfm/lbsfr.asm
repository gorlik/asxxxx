.nlist
;****************************************************************************
;
; Compile The Logical Bit And SFR Read/Write Code
;
;	AS89LP -loxff lbsfr.asm
;
;
; To Define The LBSFR Globals Place The Following Lines In Your Code
;
;	.define _lbsfr
;	.list	(!)	; This Inhibits The Include File Pagination
;	.include "lbsfr.asm"
;	.list
;
;****************************************************************************
;
; LBSFR.ASM Globals In A Macro
;
	.macro	.lbsfr.globals	arg$
	  .iifne  arg$	.list	(!,src,me)
	  .globl	rdsfr
	  .globl	wtsfr
	  .nlist
	.endm
;
;****************************************************************************
;
.ifdef _lbsfr
	.list	(!,src)
;	lbsfr.asm       Globals                 Defined
	.nlist

	.lbsfr.globals	0
.else
	.list
	.title	Read/Write SFRs

	.module	LBSFR

	.lbsfr.globals	1

;
;****************************************************************************
;
;  Includes
;
	.list	(!)	; This Inhibits The Include File Pagination
	.include "lp3240.sfr"
	.list
	.list	(!)	; This Inhibits The Include File Pagination
	.include "ascii.def"
	.list
;
;****************************************************************************
;
; Diagnostics Are Configured In 'debug.asm'
;
	.define	_debug

	.list	(!)	; This Inhibits The Include File Pagination
	.include "debug.asm"
	.list
;
;****************************************************************************
;
;  Externals By Inclusion
;
	.define	_macros
	.define	_mondeb51

	.list	(!)	; This Inhibits The Include File Pagination
	.include "macros.asm"
	.list
	.list	(!)	; This Inhibits The Include File Pagination
	.include "mondeb51.asm"
	.list
;
;****************************************************************************

	.page
	.sbttl	Create The Read Block Macros

;****************************************************************************
;
	.macro .rdsfr	arg
	  sfr$n =: arg
	  .irp bit 1,2,4,8,16,32,64,128
	    .ifne	sfr$'arg & bit
	      .ifne sfr$n - 0xE0
	      	.list	(!,err,loc,bin,eqt,cyc,lin,src,me)
	  mov	a,sfr$n
	        .nlist
	      .else	; mov	a,a	is illegal
	      	.list	(!,err,loc,bin,eqt,cyc,lin,src,me)
	  nop
	  nop
	        .nlist
	      .endif
	      .list	(!,err,loc,bin,eqt,cyc,lin,src,me)
	  ret
	      .nlist
	    .endif
	    sfr$n = sfr$n + 1
	  .endm
	.endm

;
;****************************************************************************
;
	.macro .rdblk
	  .nlist
	  .irp	arg	0x80,0x88,0x90,0x98
	    .rdsfr	arg
	  .endm
	  .ifne	UPPER_CASE_SFR
	    .irp  arg 0xA0,0xA8,0xB0,0xB8,0xC0,0xC8
	      .rdsfr	arg
	    .endm
	    .irp  arg 0xD0,0xD8,0xE0,0xE8,0xF0,0xF8
	      .rdsfr	arg
	    .endm
	  .else
	    .irp  arg 0xa0,0xa8,0xb0,0xb8,0xc0,0xc8
	      .rdsfr	arg
	    .endm
	    .irp  arg 0xd0,0xd8,0xe0,0xe8,0xf0,0xf8
	      .rdsfr	arg
	    .endm
	  .endif
	.endm

;
;****************************************************************************

	.page
	.sbttl	Create The Write Block Macros

;****************************************************************************
;
	.macro .wtsfr	arg
	  sfr$n =: arg
	  .irp bit 1,2,4,8,16,32,64,128
	    .ifne	sfr$'arg & bit
	      .ifne sfr$n - 0xE0
	      	.list	(!,err,loc,bin,eqt,cyc,lin,src,me)
	  mov	sfr$n,a
	        .nlist
	      .else	; mov	a,a	is illegal
	      	.list	(!,err,loc,bin,eqt,cyc,lin,src,me)
	  nop
	  nop
	        .nlist
	      .endif
	      .list	(!,err,loc,bin,eqt,cyc,lin,src,me)
	  ret
	      .nlist
	    .endif
	    sfr$n = sfr$n + 1
	  .endm
	.endm

;
;****************************************************************************
;
	.macro .wtblk
	  .nlist
	  .irp	arg	0x80,0x88,0x90,0x98
	    .wtsfr	arg
	  .endm
	  .ifne	UPPER_CASE_SFR
	    .irp  arg 0xA0,0xA8,0xB0,0xB8,0xC0,0xC8
	      .wtsfr	arg
	    .endm
	    .irp  arg 0xD0,0xD8,0xE0,0xE8,0xF0,0xF8
	      .wtsfr	arg
	    .endm
	  .else
	    .irp  arg 0xa0,0xa8,0xb0,0xb8,0xc0,0xc8
	      .wtsfr	arg
	    .endm
	    .irp  arg 0xd0,0xd8,0xe0,0xe8,0xf0,0xf8
	      .wtsfr	arg
	    .endm
	  .endif
	.endm

;
;****************************************************************************

	.page
	.sbttl	Table Entries

;****************************************************************************
;

	; Command Table Entries

	.area	CmdTbl

	ljmp	lbclr
	ljmp	lbset
	ljmp	lbval
	ljmp	rdsfr
	ljmp	wtsfr

	; Command List Entries 

	.area	CmdLst

	.ascii	/LBCLR/		; clear logical bit variable
	.byte	cr
	.ascii	/LBSET/		; set logical bit variable
	.byte	cr
	.ascii	/LBVALUE/	; display logical bit value
	.byte	cr
	.ascii	/SFR/		; SFR Read
	.byte	cr
	.ascii	/SFW/		; SFR Write
	.byte	cr

	; Extended Help String Pointers

	.area	X_Ptrs

	.word	$lbclr
	.word	$lbset
	.word	$lbval
	.word	$rdsfr
	.word	$wtsfr

	; Extended Help Strings

	.area	X_Strs

$lbclr:
	.ascii	" LBC[LR] N  Clear Logical Bit N"
	.byte	eot

$lbset:
	.ascii	" LBS[ET] N  Set Logical Bit N"
	.byte	eot

$lbval:
	.ascii	" LBV[ALUE] N  Display Value Of Logical Bit N"
	.byte	eot

$rdsfr:
	.ascii	" SFR N  Read value of SFR N"
	.byte	eot

$wtsfr:
	.ascii	" SFW N V  Write to SFR N the value V"
	.byte	cr,lf
	.ascii	"   SFW shows the SFR value before and after the write operation"
	.byte	eot

;
;****************************************************************************

	.page
	.sbttl	SFR Register Bit Table

;****************************************************************************
;
	; Each Non-Zero Bit Signifies The Existance Of An SFR Register
	; And An Entry In The SFR Access Block Table

	.area	MBits

rwsfr:	.blkb	1	; Primary Read(0)/Write(1) Flag
sfrflg:	.blkb	1	; Process Read(0)/Write(1) Flag

bitflg:	.blkb	1	; clr/set logical bits flag
bitval:	.blkb	1	; display logical bit value

	.area	LBSFR

	.ifne	UPPER_CASE_SFR
	  .list
sfrbit:	  .byte	sfr$0x80, sfr$0x88, sfr$0x90, sfr$0x98
	  .byte	sfr$0xA0, sfr$0xA8, sfr$0xB0, sfr$0xB8
	  .byte	sfr$0xC0, sfr$0xC8, sfr$0xD0, sfr$0xD8
	  .byte	sfr$0xE0, sfr$0xE8, sfr$0xF0, sfr$0xF8
	  .nlist
	.else
	  .list
sfrbit:	  .byte	sfr$0x80, sfr$0x88, sfr$0x90, sfr$0x98
	  .byte	sfr$0xa0, sfr$0xa8, sfr$0xb0, sfr$0xb8
	  .byte	sfr$0xc0, sfr$0xc8, sfr$0xd0, sfr$0xd8
	  .byte	sfr$0xe0, sfr$0xe8, sfr$0xf0, sfr$0xf8
	  .nlist
	.endif

	.list

rdfnc:	.rdblk

wtfnc:	.wtblk

	.page
	.sbttl	Read/Write SFRs

;****************************************************************************
;
; SFR Read/Write Functions
;

rdsfr:	clr	rwsfr		; read flag
	sjmp	sfr

wtsfr:	setb	rwsfr		; write flag
;	sjmp	sfr

sfr:	lcall	nmdptr
	mov	a,dph
	jnz	5$		; address must be in
	mov	a,dpl
	jnb	a.7,5$		; the range 0x80-0xFF

	jnb	rwsfr,1$
	lcall	number		; get that value
	jb	a.7,4$		; its	required
	jz	4$

1$:	lcall	sfr_rd
	jnc	6$

	jnb	rwsfr,2$
	push	a		; save SFR value
	.lb_rx	a,nbrlo		; get value to write
	lcall	sfr_wt		; write the byte
	lcall	sfr_rd		; read it back
	.sb_rx	nbrlo,a		; and save
	pop	a		; original value

2$:	push	a		; save SFR value
	lcall	outsp		; output a preceeding space
	mov	b,dph		; address
	mov	a,dpl
	lcall	out2by		; type address
	lcall	outeq		; type '='
	pop	b		; recover SFR value
	lcall	out1by		; type it

	jnb	rwsfr,3$
	mov	dptr,#10$
	lcall	outstr
	.lb_rx	b,nbrlo		; get value after write
	lcall	out1by		; type it
3$:	ljmp	nomore
4$:	ljmp	badsyn

5$:	mov	dptr,#8$
	sjmp	7$
6$:	mov	dptr,#9$
7$:	lcall	outstr
	ljmp	nomore

8$:	.ascii	/ SFR address range: 0x80 - 0xFF/
	.byte	eot
9$:	.ascii	/ undefined SFR/
	.byte	eot
10$:	.ascii	/ => /
	.byte	eot

;
;****************************************************************************
;

sfr_rd:	clr	sfrflg
	sjmp	sfr_rw

sfr_wt:	setb	sfrflg
;	sjmp	sfr_rw

sfr_rw:	push	dph		; save address
	push	dpl
	push	b
	push	a		; save write value

	mov	a,dph
	jnz	10$		; address must be in
	mov	a,dpl
	jnb	a.7,10$		; the range 0x80-0xFF

	add	a,#0x80		; range now 0x00-0x7F
	mov	r0,a		; save as loop count
	mov	r1,#0		; SFR function entry number

	mov	dptr,#sfrbit	; SFR bit table
1$:	mov	b,#8		; bit counter
	clr	a
	movc	a,@a+dptr	; get SFR bit table byte

2$:	cjne	r0,#0,3$
	sjmp	5$
3$:	jnb	a.0,4$
	inc	r1
4$:	rr	a		; next SFR bit entry
	dec	r0
	djnz	b,2$
	inc	dptr		; on to next bit table byte
	sjmp	1$

5$:	jnb	a.0,10$		; invalid SFR
	mov	a,r1		; get index to function
	mov	b,#3		; each entry uses 3 bytes
	mul	ab
	jb	sfrflg,6$

	mov	dptr,#rdfnc	; SFR read function table
	sjmp	7$

6$:	mov	dptr,#wtfnc	; SFR write function table
;	sjmp	7$

7$:	add	a,dpl		; add product of ab to dptr
	mov	dpl,a
	mov	a,b
	addc	a,dph
	mov	dph,a
	sjmp	9$

8$:	push	dpl		; push	dptr as a return address
	push	dph		; and go to rd/wt SFR function
	ret

9$:	pop	a		; SFR write value (overwritten if a read)
	lcall	8$		; push return address
				; rd/wt SFR function returns here
	setb	c		; operation complete
	sjmp	11$

10$:	pop	a		; restore a 
	clr	c		; address invalid
;	sjmp	11$

11$:	pop	b
	pop	dpl		; restore address
	pop	dph
	ret

;
;*******************************************************************************

	.page
	.sbttl	Logical Bit CLR/SET/VALUE

;****************************************************************************
;
; logical bit set / clear
;

lbclr:	clr	bitflg
	clr	bitval
	sjmp	1$

lbset=.
	setb	bitflg
	clr	bitval
	sjmp	1$

lbval=.
	setb	bitval
;	sjmp	1$

1$:	lcall	number		; get bit value
	jb	a.7,9$		; its required
	jz	9$

	.lb_rx	a,nbrhi		; only 0x00-0x7F allowed
	jnz	9$
	.lb_rx	a,nbrlo		; get bit number
	jb	a.7,9$

	mov	b,#8		; 0x00-0x7F are logical bits
	div	ab		; compute a byte offset
	add	a,#0x20		; add bit variable base address
	mov	r1,a		; its an address
				; bit # in b
	inc	b
	mov	a,#1		; now position bit
	sjmp	3$
2$:	rl	a
3$:	djnz	b,2$

	jb	bitval,5$	; skip on display

	jb	bitflg,4$	; clear bit, else skip
	cpl	a		; complement bit
	anl	a,@r1		; mask bit
	mov	@r1,a		; and save
	sjmp	8$

4$:	orl	a,@r1		; set bit
	mov	@r1,a
	sjmp	8$

5$:	anl	a,@r1		; tst bit
	jnz	6$
	mov	a,#'0
	sjmp	7$
6$:	mov	a,#'1
;	sjmp	7$

7$:	push	a		; save value
	lcall	outsp		; output a preceeding space
	.lb_rx	b,nbrlo		; get bit number
	lcall	out1by		; type address
	lcall	outeq		; type '='
	pop	a		; recover value
	lcall	outchr		; type it
	lcall	docrlf
8$:	ljmp	nomore

9$:	mov	dptr,#10$
	lcall	outstr
	ljmp	nomore

10$:	.ascii	/ LB address range: 0x00 - 0x7F/
	.byte	eot

;
;*******************************************************************************

.endif	; .else of _lbsfr

	.end



