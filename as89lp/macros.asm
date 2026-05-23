.nlist
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
; Compile The Macro Support Code
;
;	AS89LP -loxff macros
;
; To Define The macro.asm Macros Place The Following Lines In Your Code
;
;	.define _macros
;	.list	(!)	; This Inhibits The Include File Pagination
;	.include "macros.asm"
;	.list
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
.ifdef	_macros
	.list	(src)
;	macros.asm      Macros/Globals          Defined
	.nlist
.else
	.list
	.title	Macro Definitions

	.module	MACROS

;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
;	Support Macro Summary
;					| B/W |	| Source |   | Destination |
;					-------	----------   ---------------
;	.lb_r	Load Byte (R)		   B      IDATA		DATA/SFR
;	.lbi_r	Load Byte Indirect (R)	   B	 [IDATA]	DATA/SFR
;
;	.lb_rx	Load Byte (R)		   B	  XDATA	        DATA/SFR
;	.lbi_rx	Load Byte Indirect (R)	   B	 [XDATA]	DATA/SFR
;
;	.lb_x	Load Byte (X)		   B	  XDATA		DATA/SFR
;	.lbi_x	Load Byte Indirect (X)	   B	 [XDATA]	DATA/SFR
;
;	.lb_c	Load Byte (C)		   B	  CODE		DATA/SFR
;
;---------------------------------------------------------------------------
;
;	.sb_r	Store Byte (R)		   B      DATA/SFR	DATA/IDATA
;	.sbi_r	Store Byte Indirect (R)	   B	  DATA/SFR	DATA/IDATA
;
;	.sb_rx	Store Byte (R)		   B	  DATA/SFR      XDATA
;	.sbi_rx	Store Byte Indirect (R)	   B	  DATA/SFR	XDATA
;
;	.sb_x	Store Byte (X)		   B	  DATA/SFR	XDATA
;	.sbi_x	Store Byte Indirect (X)	   B	  DATA/SFR	XDATA
;
;---------------------------------------------------------------------------
;
;	.incb_rx  Increment Byte (R)	   B  			XDATA
;	.incb_x   Increment Byte (R)	   B			XDATA
;
;	.decb_rx  Decrement Byte (R)	   B  			XDATA
;	.decb_x   Decrament Byte (R)	   B			XDATA
;
;	.cmpb_rx  Compare Bytes (R)	   B	  XDATA		XDATA
;	.cmpw_rx  Compare Words (R)	   W	  XDATA		XDATA
;
;---------------------------------------------------------------------------
;
;	.mvb_rr	Move 1-Byte (R)		   B	  DATA/IDATA	DATA/IDATA
;	.mvw_rr	Move 1-Word (R)		   W	  DATA/IDATA	DATA/IDATA
;
;	.mvb_xx	Move 1-Byte (X)		   B	  XDATA		XDATA
;	.mvw_xx	Move 1-Word (X)		   W	  XDATA		XDATA
;
;	.mvb_rx	Move 1-Byte (R)		   B	  XDATA		XDATA
;	.mvw_rx	Move 1-Word (R)		   W	  XDATA		XDATA
;
;	.mvb_ix	Move 1-Byte (R)		   B	  DATA/IDATA	XDATA
;	.mvw_ix	Move 1-Word (R)		   W	  DATA/IDATA	XDATA
;
;	.mvb_xi	Move 1-Byte (R)		   B	  XDATA		DATA/IDATA
;	.mvw_xi	Move 1-Word (R)		   W	  XDATA		DATA/IDATA
;
;---------------------------------------------------------------------------
;
;	.djnz_rx  Decrement, Jump # 0	   B			XDATA
;	.djnz_x   Decrement, Jump # 0	   W			XDATA
;
;---------------------------------------------------------------------------
;
;	.ldptr	  Load DPTR		   W	  DATA/SFR	DPTR
;	.ldptr_r  Load DPTR (R)		   W	  DATA/IDATA	DPTR
;	.ldptr_rx Load DPTR (R)		   W	  XDATA		DPTR
;	.ldptr_x  Load DPTR (X)		   W	  XDATA		DPTR
;
;	.sdptr    Store DPTR		   W	  DPTR		DATA/SFR
;	.sdptr_r  Store DPTR (R)	   W	  DPTR		DATA/IDATA
;	.sdptr_rx Store DPTR (R)	   W	  DPTR		XDATA
;	.sdptr_x  Store DPTR (X)	   W	  DPTR		XDATA
;
;---------------------------------------------------------------------------
;
;	.pshreg	  Push Registers dpl, dph, a, b,
;		  r0, r1, r2, r3, r4, r5, r6, and r7 Onto The Stack
;	.popreg	  Pop Registers r7, r6, r5, r4, r3, r2, r1, r0,
;		  b, a, dph, and dpl From The Stack
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
;	General Macro Argument Nomenclature
;
;	dst$        - is a destination argumment
;	src$        - is a source argument
;	reg$        - is an optional argument
;	              specifying R0 or R1
;	ppa$        - is a dumby argument which enables
;	              pushing and popping the a register
;	ppr$        - is a dumby argument which enables
;	              pushing and popping the r register
;	ppx$        - is a dumby argument which enables
;	              pushing and popping the dptr/rn register(s)
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.nlist
.endif	; .else of _macros

.iifndef  _macros	.list
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
;	PUSH and POP Macros For Use Inside Macros
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.macro	.push	arg
	  .list	(!,err,loc,bin,cyc,eqt,src,me)
	  push	arg
	  .nlist
	.endm

	.macro	.pop	arg
	  .list	(!,err,loc,bin,cyc,eqt,src,me)
	  pop	arg
	  .nlist
	.endm
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
;	R0 and R1 Check Macro For Use Inside Macros
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.macro	.chkr01	reg$
	  .ifnb	reg$
	    ; Check Register For R0 Or R1
	    ld$err = 4
	    .iifdif reg$,r1	ld$err = ld$err - 1
	    .iifdif reg$,r0	ld$err = ld$err - 1
	    .iifdif reg$,R1	ld$err = ld$err - 1
	    .iifdif reg$,R0	ld$err = ld$err - 1
	    .ifeq ld$err
	      .list	(!,err,loc,bin,cyc,eqt,src,me)
	  .error 1	; reg Required To Be R0 Or R1
	      .nlist
	    .endif
	  .endif
	.endm
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
;	r0-r7/R0-R7 Value Check Macro For Use Inside Macros
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.macro	.m$val	arg
	  m$equ	=: 0
	  m$val =: 0
	  ; Lower Case Register Check
	  .irp	reg$	r0,r1,r2,r3,r4,r5,r6,r7
	    .ifidn	reg$,arg
	      m$equ = 1
	      .mexit
	    .endif
	  .endm
	  .ifne		m$equ
	    .mexit
	  .endif
	  ; Upper Case Register Check
	  .irp reg$	R0,R1,R2,R3,R4,R5,R6,R7
	    .ifidn	reg$,arg
	      m$equ = 1
	      .mexit
	    .endif
	  .endm
	  .ifne		m$equ
	    .mexit
	  .endif
	  .nval		m$val,arg
	.endm
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
;	Macro Performs A load Byte From IData Ram
;	Data Element (0x00-0x7F) <<== IData Element (0x80-0xFF)
;				Or
;	SFR  Element (0x80-0xFF) <<== IData Element (0x80-0xFF)
;
;	Arguments:
;		dst$	- Destination Address		Required
;		src$	- Source Address		Required
;		ppr$	- Push/Pop reg If Non-Blank	Optional
;		ppa$	- Push/Pop  a  If Non-Blank	Optional
;		reg$	- Index Register R0/R1		Optional
;
;		The Default Index Register Is R1
;		ACC Is The SFR Address For A
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.macro	.lb_r	dst$,src$,ppr$,ppa$,reg$
	  .nlist
	  .iifidn dst$,dptr	.error	; DPTR Is Not A Byte Destination
	  .ifb	reg$
	    m$lb_r	dst$,src$,ppr$,ppa$,r1
	  .else
	    m$lb_r	dst$,src$,ppr$,ppa$,reg$
	  .endif
	.endm

	.macro	m$lb_r	dst$,src$,ppr$,ppa$,reg$
	  .chkr01	reg$
	  .iifnb ppr$,		.push	reg$
          .ifdif	a,dst$
	    ; "dst$" value != "a" use long form
	    .m$val	dst$
	    .ifne	ACC-m$val
	      .iifnb ppa$,	.push	a
	      .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	reg$,#src$
	  mov	dst$,@reg$
	      .nlist
	      .iifnb ppa$,	.pop	a
	    .else
	      .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	reg$,#src$
	  mov	a,@reg$
	      .nlist
	    .endif
	  .else
	    ; if "dst$" value == "a" then use short form
	    .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	reg$,#src$
	  mov	a,@reg$
	    .nlist
	  .endif
	  .iifnb ppr$,		.pop	reg$
	.endm
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
;	Macro Performs An Indirect Load Byte From IData Ram
;	Data Element (0x00-0x7F) <<== [IData Element (0x80-0xFF)]
;				Or
;	SFR  Element (0x80-0xFF) <<== [IData Element (0x80-0xFF)]
;
;	Arguments:
;		dst$	- Destination Address		Required
;		src$	- Source Address		Required
;		ppr$	- Push/Pop reg If Non-Blank	Optional
;		ppa$	- Push/Pop  a  If Non-Blank	Optional
;		reg$	- Index Register R0/R1		Optional
;
;		The Default Index Register Usage Is R1/R0 When Blank
;			Then:	R1	<<== #src$
;				R0	<<== [src$], An Address
;				dst$	<<== [R0]
;
;		When Index Register R0 Is Specified
;			Then:	R0	<<== #src$
;				R0	<<== [src$], An Address
;				dst$	<<== [R0]
;
;		When Index Register R1 Is Specified
;			Then:	R1	<<== #src$
;				R1	<<== [src$], An Address
;				dst$	<<== [R1]
;
;		When The Destination Is A, ppa$ Is Ignored
;		ACC Is The SFR Address For A
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.macro	.lbi_r	dst$,src$,ppr$,ppa$,reg$
	  .nlist
	  .chkr01	reg$
	  .iifidn dst$,dptr	.error	; DPTR Is Not A Byte Destination
	  .ifb	reg$
	    m$lbi_rx	dst$,src$,ppr$,ppa$,r1,r0
	  .else
	    m$lbi_rx	dst$,src$,ppr$,ppa$,reg$,reg$
	  .endif
	.endm

	.macro	m$lbi_r	dst$,src$,ppr$,ppa$,reg1$,reg0$
	  .ifidn reg1$,reg0$
	    .iifnb ppr$,	.push	reg1$
	  .else
	    .iifnb ppr$,	.push	reg1$
	    .iifnb ppr$,	.push	reg0$
	  .endif
          .ifdif	a,dst$
	    ; "dst$" != "a" use long form
	    .m$val	dst$
	    .ifne	ACC-m$val
	      .iifnb ppa$,	.push	a
	    .endif
	    .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	reg1$,#src$
	  mov	a,@reg1$
	  mov	reg0$,a
	    .nlist
	    .ifne	ACC-m$val
	      .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	dst$,@reg0$
	      .nlist
	      .iifnb ppa$,	.pop	a
	    .else
	      .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	a,@reg0$
	      .nlist
	    .endif
	  .else
	    ; if "dst$" == "a" then use short form
	    .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	reg1$,#src$
	  mov	a,@reg1$
	  mov	reg0$,a
	  mov	a,@reg0$
	    .nlist
	  .endif
	  .ifidn reg1$,reg0$
	    .iifnb ppr$,	.pop	reg1$
	  .else
	    .iifnb ppr$,	.pop	reg0$
	    .iifnb ppr$,	.pop	reg1$
	  .endif
	.endm
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
;	Macro Performs A load Byte From XData Ram
;	Data Element (0x00-0x7F) <<== XData Element (0x00-0xFF)
;				Or
;	SFR  Element (0x80-0xFF) <<== XData Element (0x00-0xFF)
;
;	Arguments:
;		dst$	- Destination Address		Required
;		src$	- Source Address		Required
;		ppr$	- Push/Pop reg If Non-Blank	Optional
;		ppa$	- Push/Pop  a  If Non-Blank	Optional
;		reg$	- Index Register R0/R1		Optional
;
;		The Default Index Register Is R1
;		ACC Is The SFR Address For A
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.macro	.lb_rx	dst$,src$,ppr$,ppa$,reg$
	  .nlist
	  .iifidn dst$,dptr	.error	; DPTR Is Not A Byte Destination
	  .ifb	reg$
	    m$lb_rx	dst$,src$,ppr$,ppa$,r1
	  .else
	    m$lb_rx	dst$,src$,ppr$,ppa$,reg$
	  .endif
	.endm

	.macro	m$lb_rx	dst$,src$,ppr$,ppa$,reg$
	  .chkr01	reg$
	  .iifnb ppr$,		.push	reg$
          .ifdif	a,dst$
	    ; "dst$" != "a" use long form
	    .m$val	dst$
	    .ifne	ACC-m$val
	      .iifnb ppa$,	.push	a
	    .endif
	    .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	reg$,#src$
	  movx	a,@reg$
	    .nlist
	    .ifne	ACC-m$val
	      .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	dst$,a
	      .nlist
	      .iifnb ppa$,	.pop	a
	    .endif
	  .else
	    ; if "dst$" == "a" then use short form
	    .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	reg$,#src$
	  movx	a,@reg$
	    .nlist
	  .endif
	  .iifnb ppr$,		.pop	reg$
	.endm
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
;	Macro Performs An Indirect Load Byte From XData Ram
;	Data Element (0x00-0xFF) <<== [XData Element (0x00-0xFF)]
;				Or
;	SFR  Element (0x80-0xFF) <<== [XData Element (0x00-0xFF)]
;
;	Arguments:
;		dst$	- Destination Address		Required
;		src$	- Source Address		Required
;		ppr$	- Push/Pop reg If Non-Blank	Optional
;		ppa$	- Push/Pop  a  If Non-Blank	Optional
;		reg$	- Index Register R0/R1		Optional
;
;		The Default Index Register Usage Is R1/R0 When Blank
;			Then:	R1	<<== #src$
;				R0	<<== [src$], An Address
;				dst$	<<== [R0]
;
;		When Index Register R0 Is Specified
;			Then:	R0	<<== #src$
;				R0	<<== [src$], An Address
;				dst$	<<== [R0]
;
;		When Index Register R1 Is Specified
;			Then:	R1	<<== #src$
;				R1	<<== [src$], An Address
;				dst$	<<== [R1]
;
;		When The Destination Is A, ppa$ Is Ignored
;		ACC Is The SFR Address For A
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.macro	.lbi_rx	dst$,src$,ppr$,ppa$,reg$
	  .nlist
	  .chkr01	reg$
	  .iifidn dst$,dptr	.error	; DPTR Is Not A Byte Destination
	  .ifb	reg$
	    m$lbi_rx	dst$,src$,ppr$,ppa$,r1,r0
	  .else
	    m$lbi_rx	dst$,src$,ppr$,ppa$,reg$,reg$
	  .endif
	.endm

	.macro	m$lbi_rx	dst$,src$,ppr$,ppa$,reg1$,reg0$
	  .ifidn reg1$,reg0$
	    .iifnb ppr$,	.push	reg1$
	  .else
	    .iifnb ppr$,	.push	reg1$
	    .iifnb ppr$,	.push	reg0$
	  .endif
          .ifdif	a,dst$
	    ; "dst$" != "a" use long form
	    .m$val	dst$
	    .ifne	ACC-m$val
	      .iifnb ppa$,	.push	a
	    .endif
	    .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	reg1$,#src$
	  movx	a,@reg1$
	  mov	reg0$,a
	    .nlist
	    .ifne	ACC-m$val
	      .list	(!,err,loc,bin,cyc,eqt,src,me)
	  movx	a,@reg0$
	  mov	dst$,a
	      .nlist
	      .iifnb ppa$,	.pop	a
	    .else
	      .list	(!,err,loc,bin,cyc,eqt,src,me)
	  movx	a,@reg0$
	      .nlist
	    .endif
	  .else
	    ; if "dst$" == "a" then use short form
	    .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	reg1$,#src$
	  movx	a,@reg1$
	  mov	reg0$,a
	  movx	a,@reg0$
	    .nlist
	  .endif
	  .ifidn reg1$,reg0$
	    .iifnb ppr$,	.pop	reg1$
	  .else
	    .iifnb ppr$,	.pop	reg0$
	    .iifnb ppr$,	.pop	reg1$
	  .endif
	.endm
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
;	Macro Performs A Byte Load From XData Ram
;	Data Element (0x00-0x7F) <<== XData Element (0x0000-0xFFFF)
;				Or
;	SFR  Element (0x80-0xFF) <<== XData Element (0x0000-0xFFFF)
;
;	Arguments:
;		dst$	- Destination Address		Required
;		src$	- Source Address		Required
;		ppr$	- Push/Pop DPTR If Non-Blank	Optional
;		ppa$	- Push/Pop  a   If Non-Blank	Optional
;
;		The Temp Register Is A
;		If The Destination Is DPH/DPL ppr$ Is Ignored
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.macro	.lb_x	dst$,src$,ppr$,ppa$
	  .nlist
	  .iifidn dst$,dptr	.error	; DPTR Is Not A Byte Destination
	  .ifidn dst$,dph	; Special Case [DPH,DPL] of DPTR
	    m$lb_x	dph,src$,ppa$
	    .mexit
	  .endif
	  .ifidn dst$,dpl	; Special Case [DPH,DPL] of DPTR
	    m$lb_x	dpl,src$,ppa$
	    .mexit
	  .endif
	  .iifnb ppr$,		.push	dph
	  .iifnb ppr$,		.push	dpl
          .ifdif	a,dst$
	    ; "dst$" != "a" use long form
	    .iifnb ppa$,	.push	a
	    .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	dptr,#src$
	  movx	a,@dptr
	  mov	dst$,a
	    .nlist
	    .iifnb ppa$,	.pop	a
	  .else
	    ; "dst$" == "a" use short form
	    .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	dptr,#src$
	  movx	a,@dptr
	    .nlist
	  .endif
	  .iifnb ppr$,		.push	dpl
	  .iifnb ppr$,		.push	dph
	.endm

	.macro	m$lb_x	dp,src$,ppa$
	  .iifidn dp,dph	.push	dpl
	  .iifidn dp,dpl	.push	dph
	  .iifnb ppa$,		.push	a
	  .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	dptr,#src$
	  movx	a,@dptr
	  mov	dp,a
	  .nlist
	  .iifnb ppa$,		.pop	a
	  .iifidn dp,dpl	.pop	dph
	  .iifidn dp,dph	.pop	dpl
	.endm
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
;	Macro Performs An Indirect Load Byte From XData Ram
;	Data Element (0x00-0xFF) <<== [XData Element (0x0000-0xFFFF)]
;				Or
;	SFR  Element (0x80-0xFF) <<== [XData Element (0x0000-0xFFFF)]
;
;	Arguments:
;		dst$	- Destination Address		Required
;		src$	- Source Address		Required
;		ppx$	- Push/Pop dptr If Non-Blank	Optional
;		ppa$	- Push/Pop  a   If Non-Blank	Optional
;
;		The Default Index Register Usage Is R1/R0 When Blank
;			Then:	DPTR	<<== #src$
;				DPTR	<<== [DPTR], An Address
;				dst$	<<== [DPTR]
;
;		When The Destination Is A, ppa$ Is Ignored
;		ACC Is The SFR Address For A
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.macro	.lbi_x	dst$,src$,ppx$,ppa$
	  .nlist
	  .iifidn dst$,dptr	.error	; DPTR Is Not A Byte Destination
	  .iifnb ppx$,	.push	dpl
	  .iifnb ppx$,	.push	dph
          .ifdif	a,dst$
	    ; "dst$" != "a" use long form
	    .m$val	dst$
	    .ifne	ACC-m$val
	      .iifnb ppa$,	.push	a
	    .endif
	    .list	(!,err,loc,bin,cyc,eqt,src,me)
	  lcall	m$lbi_x
	    .nlist
	    .ifne	ACC-m$val
	   mov	dst$,a
	      .iifnb ppa$,	.pop	a
	    .endif
	  .else
	    ; if "dst$" == "a" then use short form
	    .list	(!,err,loc,bin,cyc,eqt,src,me)
	  lcall	m$lbi_x
	    .nlist
	  .endif
	  .iifnb ppx$,	.pop	dph
	  .iifnb ppx$,	.pop	dpl
	.endm

.ifndef	_macros

	.globl	m$lbi_x

	.area	Code

m$lbi_x:
	movx	a,@dptr		; assume MSB is first
	push	a
	inc	dptr
	movx	a,@dptr		; assume LSB is second
	mov	dpl,a
	pop	dph
	movx	a,@dptr		; get byte @[dptr]
	ret
.endif
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
;	Macro Performs A Byte Load From Code ROM
;	Data Element (0x00-0x7F) <<== Code Element (0x0000-0xFFFF)
;				Or
;	SFR  Element (0x80-0xFF) <<== Code Element (0x0000-0xFFFF)
;
;	Arguments:
;		dst$	- Destination Address		Required
;		src$	- Source Address		Required
;		ppr$	- Push/Pop DPTR If Non-Blank	Optional
;		ppa$	- Push/Pop  a   If Non-Blank	Optional
;
;		The Temp Register Is A
;		If The Destination Is DPH/DPL ppr$ Is Ignored
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.macro	.lb_c	dst$,src$,ppr$,ppa$
	  .nlist
	  .iifidn dst$,dptr	.error	; DPTR Is Not A Byte Destination
	  .ifidn dst$,dph	; Special Case [DPH,DPL] of DPTR
	    m$lb_c	dph,src$,ppa$
	    .mexit
	  .endif
	  .ifidn dst$,dpl	; Special Case [DPH,DPL] of DPTR
	    m$lb_c	dpl,src$,ppa$
	    .mexit
	  .endif
	  .iifnb ppr$,		.push	dph
	  .iifnb ppr$,		.push	dpl
          .ifdif	a,dst$
	    ; "dst$" != "a" use long form
	    .iifnb ppa$,	.push	a
	    .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	dptr,#src$
	  clr	a
	  movc	a,@a+dptr
	  mov	dst$,a
	    .nlist
	    .iifnb ppa$,	.pop	a
	  .else
	    ; "dst$" == "a" use short form
	    .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	dptr,#src$
	  clr	a
	  movc	a,@a+dptr
	    .nlist
	  .endif
	  .iifnb ppr$,		.push	dpl
	  .iifnb ppr$,		.push	dph
	.endm

	.macro	m$lb_c	dp,src$,ppa$
	  .iifidn dp,dph	.push	dpl
	  .iifidn dp,dpl	.push	dph
	  .iifnb ppa$,		.push	a
	  .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	dptr,#src$
	  clr	a
	  movc	a,@a+dptr
	  mov	dp,a
	  .nlist
	  .iifnb ppa$,		.pop	a
	  .iifidn dp,dpl	.pop	dph
	  .iifidn dp,dph	.pop	dpl
	.endm
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
;	Macro Performs A Store Byte To IData Ram
;	IData Element (0x80-0xFF) <<== Data Element (0x00-0x7F)
;				Or
;	IData Element (0x80-0xFF) <<== SFR  Element (0x80-0xFF)
;
;	Arguments:
;		dst$	- Destination Address		Required
;		src$	- Source Address		Required
;		ppr$	- Push/Pop reg If Non-Blank	Optional
;		ppa$	- Push/Pop  a  If Non-Blank	Optional
;		reg$	- Index Register R0/R1		Optional
;
;		The Default Index Register Is R1
;		ACC Is The SFR Address For A
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.macro	.sb_r	dst$,src$,ppr$,ppa$,reg$
	  .nlist
	  .iifidn src$,dptr	.error	; DPTR Is Not A Byte Source
	  .ifb	reg$
	    m$sb_r	dst$,src$,ppr$,ppa$,r1
	  .else
	    m$sb_r	dst$,src$,ppr$,ppa$,reg$
	  .endif
	.endm

	.macro	m$sb_r	dst$,src$,ppr$,ppa$,reg$
	  .chkr01	reg$
	  .iifnb ppr$,		.push	reg$
          .ifdif	a,src$
	    ; "src$" != "a" use long form
	    .m$val	dst$
	    .ifne	ACC-m$val
	      .iifnb ppa$,	.push	a
	      .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	reg$,#dst$
	  mov	@reg$,src$
	      .nlist
	      .iifnb ppa$,	.pop	a
	    .else
	      .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	reg$,#dst$
	  mov	@reg$,a
	      .nlist
	    .endif
	  .else
	    ; if "src$" == "a" then use short form
	    .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	reg$,#dst$
	  mov	@reg$,a
	    .nlist
	  .endif
	  .iifnb ppr$,		.pop	reg$
	.endm
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
;	Macro Performs A Store Byte Indirectly To IData Ram
;	[Data/IData Element (0x00-0xFF)] <<== Data Element (0x00-0xFF)
;				Or
;	[Data/IData Element (0x00-0xFF)] <<== SFR  Element (0x80-0xFF)
;
;	Both The Address and [Address] Are In The Data/IData Region
;
;	Arguments:
;		dst$	- Destination Address		Required
;		src$	- Source Address		Required
;		ppr$	- Push/Pop reg If Non-Blank	Optional
;		ppa$	- Push/Pop  a  If Non-Blank	Optional
;		reg$	- Index Register R0/R1		Optional
;
;		The Default Index Register Usage Is R1/R0 When Blank
;			Then:	R1	<<== #src$
;				R0	<<== [src$], An Address
;				[R0]	<<== dst$
;
;		When Index Register R0 Is Specified
;			Then:	R0	<<== #src$
;				R0	<<== [src$], An Address
;				[R0]	<<== dst$
;
;		When Index Register R1 Is Specified
;			Then:	R1	<<== #src$
;				R1	<<== [src$], An Address
;				[R1]	<<== dst$
;
;		When The Destination Is A, ppa$ Is Ignored
;		ACC Is The SFR Address For A
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.macro	.sbi_r	dst$,src$,ppr$,ppa$,reg$
	  .nlist
	  .chkr01	reg$
	  .iifidn src$,dptr	.error	; DPTR Is Not A Byte Source
	  .ifb	reg$
	    m$sbi_r	dst$,src$,ppr$,ppa$,r1,r0
	  .else
	    m$sbi_r	dst$,src$,ppr$,ppa$,reg$,reg$
	  .endif
	.endm

	.macro	m$sbi_r	dst$,src$,ppr$,ppa$,reg1$,reg0$
	  .ifidn reg1$,reg0$
	    .iifnb ppr$,	.push	reg1$
	  .else
	    .iifnb ppr$,	.push	reg1$
	    .iifnb ppr$,	.push	reg0$
	  .endif
          .ifdif	a,src$
	    ; "src$" != "a" use long form
	    .m$val	dst$
	    .ifne	ACC-m$val
	      .iifnb ppa$,	.push	a
	    .else
	      .list	(!,err,loc,bin,cyc,eqt,src,me)
	  push	a
	      .nlist
	    .endif
	    .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	reg1$,#dst$
	  mov	a,@reg1$
	  mov	reg0$,a
	    .nlist
	    .ifne	ACC-m$val
	      .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	a,src$
	  mov	@reg0$,a
	      .nlist
	      .ifne	ACC-m$val
	        .iifnb ppa$,	.pop	a
	      .endif
	    .else
	      .list	(!,err,loc,bin,cyc,eqt,src,me)
	  pop	a
	  mov	@reg0$,a
	      .nlist
	    .endif
	  .else
	    ; if "src$" == "a" then use short form
	    .list	(!,err,loc,bin,cyc,eqt,src,me)
	  push	a
	  mov	reg1$,#ACC
	  mov	a,@reg1$
	  mov	reg0$,a
	  pop	a
	  mov	@reg0$,a
	    .nlist
	  .endif
	  .ifidn reg1$,reg0$
	    .iifnb ppr$,	.pop	reg1$
	  .else
	    .iifnb ppr$,	.pop	reg0$
	    .iifnb ppr$,	.pop	reg1$
	  .endif
	.endm
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
;	Macro Performs A Store Byte To XData Ram
;	XData Element (0x00-0xFF) <<== Data Element (0x00-0x7F)
;				Or
;	XData Element (0x00-0xFF) <<== SFR  Element (0x80-0xFF)
;
;	Arguments:
;		dst$	- Destination Address		Required
;		src$	- Source Address		Required
;		ppr$	- Push/Pop reg If Non-Blank	Optional
;		ppa$	- Push/Pop  a  If Non-Blank	Optional
;		reg$	- Index Register R0/R1		Optional
;
;		The Default Index Register Is R1
;		When The Source Is A, ppa$ Is Ignored
;		ACC Is The SFR Address For A
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.macro	.sb_rx	dst$,src$,ppr$,ppa$,reg$
	  .nlist
	  .iifidn src$,dptr	.error	; DPTR Is Not A Byte Source
	  .ifb	reg$
	    m$sb_rx	dst$,src$,ppr$,ppa$,r1
	  .else
	    m$sb_rx	dst$,src$,ppr$,ppa$,reg$
	  .endif
	.endm

	.macro	m$sb_rx	dst$,src$,ppr$,ppa$,reg$
	  .chkr01	reg$
	  .iifnb ppr$,		.push	reg$
          .ifdif	a,src$
	    ; "src$" != "a" use long form
	    .m$val	dst$
	    .ifne	ACC-m$val
	      .iifnb ppa$,	.push	a
	      .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	reg$,#dst$
	  mov	a,src$
	  movx	@reg$,a
	      .nlist
	      .iifnb ppa$,	.pop	a
	    .else
	      .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	reg$,#dst$
	  movx	@reg$,a
	      .nlist
	    .endif
	  .else
	    ; if "src$" == "a" then use short form
	    .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	reg$,#dst$
	  movx	@reg$,a
	    .nlist
	  .endif
	  .iifnb ppr$,		.pop	reg$
	.endm
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
;	Macro Performs A Store Byte Indirectly To IData Ram
;	[Data/IData Element (0x00-0xFF)] <<== Data Element (0x00-0x7F)
;				Or
;	[Data/IData Element (0x00-0xFF)] <<== SFR  Element (0x80-0xFF)
;
;	Both The Address and [Address] Are In The Data/IData Region
;
;	Arguments:
;		dst$	- Destination Address		Required
;		src$	- Source Address		Required
;		ppr$	- Push/Pop reg If Non-Blank	Optional
;		ppa$	- Push/Pop  a  If Non-Blank	Optional
;		reg$	- Index Register R0/R1		Optional
;
;		The Default Index Register Usage Is R1/R0 When Blank
;			Then:	R1	<<== #src$
;				R0	<<== [src$], An Address
;				[R0]	<<== dst$
;
;		When Index Register R0 Is Specified
;			Then:	R0	<<== #src$
;				R0	<<== [src$], An Address
;				[R0]	<<== dst$
;
;		When Index Register R1 Is Specified
;			Then:	R1	<<== #src$
;				R1	<<== [src$], An Address
;				[R1]	<<== dst$
;
;		The Default Index Register Is R1
;		When The Destination Is A, ppa$ Is Ignored
;		ACC Is The SFR Address For A
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.macro	.sbi_rx	dst$,src$,ppr$,ppa$,reg$
	  .nlist
	  .chkr01	reg$
	  .iifidn src$,dptr	.error	; DPTR Is Not A Byte Source
	  .ifb	reg$
	    m$sbi_rx	dst$,src$,ppr$,ppa$,r1,r0
	  .else
	    m$sbi_rx	dst$,src$,ppr$,ppa$,reg$,reg$
	  .endif
	.endm

	.macro	m$sbi_rx	dst$,src$,ppr$,ppa$,reg1$,reg0$
	  .ifidn reg1$,reg0$
	    .iifnb ppr$,	.push	reg1$
	  .else
	    .iifnb ppr$,	.push	reg1$
	    .iifnb ppr$,	.push	reg0$
	  .endif
          .ifdif	a,src$
	    ; "src$" != "a" use long form
	    .m$val	dst$
	    .ifne	ACC-m$val
	      .iifnb ppa$,	.push	a
	    .else
	      .list	(!,err,loc,bin,cyc,eqt,src,me)
	  push	a
	      .nlist
	    .endif
	    .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	reg1$,#dst$
	  movx	a,@reg1$
	  mov	reg0$,a
	    .nlist
	    .ifne	ACC-m$val
	      .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	a,src$
	  movx	@reg0$,a
	      .nlist
	      .ifne	ACC-m$val
	        .iifnb ppa$,	.pop	a
	      .endif
	    .else
	      .list	(!,err,loc,bin,cyc,eqt,src,me)
	  pop	a
	  movx	@reg0$,a
	      .nlist
	    .endif
	  .else
	    ; if "src$" == "a" then use short form
	    .list	(!,err,loc,bin,cyc,eqt,src,me)
	  push	a
	  mov	reg1$,#ACC
	  movx	a,@reg1$
	  mov	reg0$,a
	  pop	a
	  movx	@reg0$,a
	    .nlist
	  .endif
	  .ifidn reg1$,reg0$
	    .iifnb ppr$,	.pop	reg1$
	  .else
	    .iifnb ppr$,	.pop	reg0$
	    .iifnb ppr$,	.pop	reg1$
	  .endif
	.endm
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
;	Macro Performs A Store Byte To XData Ram
;	XData Element (0x0000-0xFFFF) <<== Data Element (0x00-0x7F)
;				Or
;	XData Element (0x0000-0xFFFF) <<== SFR  Element (0x80-0xFF)
;
;	Arguments:
;		dst$	- Destination Address		Required
;		src$	- Source Address		Required
;		ppx$	- Push/Pop dptr If Non-Blank	Optional
;		ppa$	- Push/Pop  a   If Non-Blank	Optional
;
;		The XDATA Address Byte Order is MSB:LSB
;		When The Source Is A, ppa$ Is Ignored
;		ACC Is The SFR Address For A
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.macro	.sb_x	dst$,src$,ppx$,ppa$
	  .iifnb ppx$,		.push	dph
	  .iifnb ppx$,		.push	dpl
          .ifdif	a,src$
	    ; "src$" != "a" use long form
	    .m$val	dst$
	    .ifne	ACC-m$val
	      .iifnb ppa$,	.push	a
	      .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	dptr,#dst$
	  mov	a,src$
	  movx	@dptr,a
	      .nlist
	      .iifnb ppa$,	.pop	a
	    .else
	      .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	dptr,#dst$
	  mov	@dptr,a
	      .nlist
	    .endif
	  .else
	    ; if "src$" == "a" then use short form
	    .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	dptr,#dst$
	  movx	@dptr,a
	    .nlist
	  .endif
	  .iifnb ppx$,		.pop	dpl
	  .iifnb ppx$,		.pop	dph
	.endm
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
;	Macro Performs An Indirect Store Byte To XData Ram
;	[XData Element (0x0000-0xFFFF)] <<== Data Element (0x00-0xFF)
;				Or
;	[XData Element (0x0000-0xFFFF)] <<== SFR  Element (0x80-0xFF)
;
;	Arguments:
;		dst$	- Destination Address		Required
;		src$	- Source Address		Required
;		ppx$	- Push/Pop dptr If Non-Blank	Optional
;		ppa$	- Push/Pop  a   If Non-Blank	Optional
;
;		The Default Index Register Usage Is R1/R0 When Blank
;			Then:	DPTR	<<== #src$
;				DPTR	<<== [DPTR], An Address
;				[DPTR]	<<== src
;
;		The XDATA Address Byte Order is MSB:LSB
;		When The Source Is A, ppa$ Is Ignored
;		ACC Is The SFR Address For A
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.macro	.sbi_x	dst$,src$,ppx$,ppa$
	  .iifnb ppx$,		.push	dph
	  .iifnb ppx$,		.push	dpl
	  .iifidn src$,dptr	.error	; DPTR Is Not A Byte Source
          .ifdif	a,src$
	    ; "src$" != "a" use long form
	    .m$val	src$
	    .ifne	ACC-m$val
	      .iifnb ppa$,	.push	a
	      mov	a,src$
	    .endif
	    .list	(!,err,loc,bin,cyc,eqt,src,me)
	  lcall	m$sbi_x
	    .nlist
	    .ifne	ACC-m$val
	      .iifnb ppa$,	.pop	a
	    .endif
	  .else
	    ; if "src$" == "a" then use short form
	    .list	(!,err,loc,bin,cyc,eqt,src,me)
	  lcall	m$sbi_x
	    .nlist
	  .endif
	  .iifnb ppx$,	.pop	dpl
	  .iifnb ppx$,	.pop	dph
	.endm

.ifndef	_macros

	.globl	m$sbi_x

	.area	Code

m$sbi_x:
	push	a
	movx	a,@dptr		; assume MSB is first
	push	a
	inc	dptr
	movx	a,@dptr		; assume LSB is second
	mov	dpl,a
	pop	dph
	pop	a
	movx	@dptr,a		; put byte @[dptr]
	ret
.endif
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
;	Macro To Clear A Data/IData Element (R Indirect)
;
;	Arguments:
;		dst$	- Destination Address		Required
;		ppr$	- Push/Pop reg If Non-Blank	Optional
;		ppa$	- Push/Pop  a  If Non-Blank	Optional
;		reg$	- Index Register R0/R1		Optional
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.macro	.clrb_r		dst$,ppr$,ppa$,reg$
	  .nlist
	  .ifb	reg$
	    .iifnb ppa$,	.push	a
	    .iifnb ppr$,	.push	r1
	    .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	r1,#dst$
	  mov	@r1,#0
	    .nlist
	    .iifnb ppr$,	.pop	r1
	    .iifnb ppa$,	.pop	a
	  .else
	    .chkr01 reg$
	    .iifnb ppa$,	.push	a
	    .iifnb ppr$,	.push	reg$
	    .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	reg$,#dst$
	  mov	@reg$,#0
	    .nlist
	    .iifnb ppr$,	.pop	reg$
	    .iifnb ppa$,	.pop	a
	  .endif
	.endm
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
;	Macro To Clear An EData Element (R Indirect)
;
;	Arguments:
;		dst$	- Destination Address		Required
;		ppr$	- Push/Pop reg If Non-Blank	Optional
;		ppa$	- Push/Pop  a  If Non-Blank	Optional
;		reg$	- Index Register R0/R1		Optional
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.macro	.clrb_rx	dst$,ppr$,ppa$,reg$
	  .nlist
	  .ifb	reg$
	    .iifnb ppa$,	.push	a
	    .iifnb ppr$,	.push	r1
	    .list	(!,err,loc,bin,cyc,eqt,src,me)
	  clr	a
	  mov	r1,#dst$
	  movx	@r1,a
	    .nlist
	    .iifnb ppr$,	.pop	r1
	    .iifnb ppa$,	.pop	a
	  .else
	    .chkr01 reg$
	    .iifnb ppa$,	.push	a
	    .iifnb ppr$,	.push	reg$
	    .list	(!,err,loc,bin,cyc,eqt,src,me)
	  clr	a
	  mov	reg$,#dst$
	  movx	@reg$,a
	    .nlist
	    .iifnb ppr$,	.pop	reg$
	    .iifnb ppa$,	.pop	a
	  .endif
	.endm
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
;	Macro To Clear An EData Element (DPTR Indireect)
;
;	Arguments:
;		dst$	- Destination Address		Required
;		ppx$	- Push/Pop dptr If Non-Blank	Optional
;		ppa$	- Push/Pop  a   If Non-Blank	Optional
;		reg$	- Index Register R0/R1		Optional
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.macro	.clrb_x	dst$,ppx$,ppa$
	  .nlist
	  .iifnb ppa$,	.push	a
	  .iifnb ppx$,	.push	dph
	  .iifnb ppx$,	.push	dpl
	  .list	(!,err,loc,bin,cyc,eqt,src,me)
	  clr	a
	  mov	dptr,#dst$
	  movx	@dptr,a
	  .nlist
	  .iifnb ppx$,	.pop	dpl
	  .iifnb ppx$,	.pop	dph
	  .iifnb ppa$,	.pop	a
	.endm
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
;	Macro To Increment A Data/IData Element (R Indirect)
;
;	Arguments:
;		dst$	- Destination Address		Required
;		ppr$	- Push/Pop reg If Non-Blank	Optional
;		ppa$	- Push/Pop  a  If Non-Blank	Optional
;		reg$	- Index Register R0/R1		Optional
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.macro	.incb_r		dst$,ppr$,ppa$,reg$
	  .nlist
	  .iifnb ppa$,		.push	a
	  .ifb	reg$
	    .iifnb ppr$,	.push	r1
	    .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	r1,#dst$
	  inc	@r1
	    .nlist
	    .iifnb ppr$,	.pop	r1
	  .else
	    .chkr01 reg$
	    .iifnb ppr$,	.push	reg$
	    .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	reg$,#dst$
	  inc	@reg$
	    .nlist
	    .iifnb ppr$,	.pop	reg$
	  .endif
	  .iifnb ppa$,		.pop	a
	.endm
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
;	Macro To Increment An EData Element (R Indirect)
;
;	Arguments:
;		dst$	- Destination Address		Required
;		ppr$	- Push/Pop reg If Non-Blank	Optional
;		ppa$	- Push/Pop  a  If Non-Blank	Optional
;		reg$	- Index Register R0/R1		Optional
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.macro	.incb_rx	dst$,ppr$,ppa$,reg$
	  .nlist
	  .iifnb ppa$,		.push	a
	  .ifb	reg$
	    .iifnb ppr$,	.push	r1
	    .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	r1,#dst$
	  movx	a,@r1
	  inc	a
	  movx	@r1,a
	    .nlist
	    .iifnb ppr$,	.pop	r1
	  .else
	    .chkr01 reg$
	    .iifnb ppr$,	.push	reg$
	    .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	reg$,#dst$
	  movx	a,@reg$
	  inc	a
	  movx	@reg$,a
	    .nlist
	    .iifnb ppr$,	.pop	reg$
	  .endif
	  .iifnb ppa$,		.pop	a
	.endm
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
;	Macro To Increment An EData Element (DPTR Indirect)
;
;	Arguments:
;		dst$	- Destination Address		Required
;		ppx$	- Push/Pop dptr If Non-Blank	Optional
;		ppa$	- Push/Pop  a   If Non-Blank	Optional
;		reg$	- Index Register R0/R1		Optional
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.macro	.incb_x	dst$,ppx$,ppa$
	  .nlist
	  .iifnb ppa$,		.push	a
	  .iifnb ppx$,		.push	dph
	  .iifnb ppx$,		.push	dpl
	  .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	dptr,#dst$
	  movx	a,@dptr
	  inc	a
	  movx	@dptr,a
	  .nlist
	  .iifnb ppx$,		.pop	dpl
	  .iifnb ppx$,		.pop	dph
	  .iifnb ppa$,		.pop	a
	.endm
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
;	Macro To Decrement A Data/IData Element (R Indirect)
;
;	Arguments:
;		dst$	- Destination Address		Required
;		ppr$	- Push/Pop reg If Non-Blank	Optional
;		ppa$	- Push/Pop  a  If Non-Blank	Optional
;		reg$	- Index Register R0/R1		Optional
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.macro	.decb_r		dst$,ppr$,ppa$,reg$
	  .nlist
	  .iifnb ppa$,		.push	a
	  .ifb	reg$
	    .iifnb ppr$,	.push	r1
	    .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	r1,#dst$
	  dec	@r1
	    .nlist
	    .iifnb ppr$,	.pop	r1
	  .else
	    .chkr01 reg$
	    .iifnb ppr$,	.push	reg$
	    .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	reg$,#dst$
	  dec	@reg$
	    .nlist
	    .iifnb ppr$,	.pop	reg$
	  .endif
	  .iifnb ppa$,		.pop	a
	.endm
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
;	Macro To Decrement An EData Element (R Indirect)
;
;	Arguments:
;		dst$	- Destination Address		Required
;		ppr$	- Push/Pop reg If Non-Blank	Optional
;		ppa$	- Push/Pop  a  If Non-Blank	Optional
;		reg$	- Index Register R0/R1		Optional
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.macro	.decb_rx	dst$,ppr$,ppa$,reg$
	  .nlist
	  .iifnb ppa$,		.push	a
	  .ifb	reg$
	    .iifnb ppr$,	.push	r1
	    .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	r1,#dst$
	  movx	a,@r1
	  dec	a
	  movx	@r1,a
	    .nlist
	    .iifnb ppr$,	.pop	r1
	  .else
	    .chkr01 reg$
	    .iifnb ppr$,	.push	reg$
	    .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	reg$,#dst$
	  movx	a,@reg$
	  dec	a
	  movx	@reg$,a
	    .nlist
	    .iifnb ppr$,	.pop	reg$
	  .endif
	  .iifnb ppa$,		.pop	a
	.endm
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
;	Macro To Decrement An EData Element (DPTR Indirect)
;
;	Arguments:
;		dst$	- Destination Address		Required
;		ppx$	- Push/Pop dptr If Non-Blank	Optional
;		ppa$	- Push/Pop  a   If Non-Blank	Optional
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.macro	.decb_x	dst$,ppx$,ppa$
	  .nlist
	  .iifnb ppa$,		.push	a
	  .iifnb ppx$,		.push	dph
	  .iifnb ppx$,		.push	dpl
	  .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	dptr,#dst$
	  movx	a,@dptr
	  dec	a
	  movx	@dptr,a
	  .nlist
	  .iifnb ppx$,		.pop	dpl
	  .iifnb ppx$,		.pop	dph
	  .iifnb ppa$,		.pop	a
	.endm
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
;	Macro To Compare Two 1-Byte XData Elements (R Indirect)
;
;	Arguments:
;		dst$	- Destination Address		Required
;		src$	- Source Address		Required
;		ppr$	- Push/Pop reg If Non-Blank	Optional
;		ppa$	- Push/Pop a/b If Non-Blank	Optional
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;

	.macro	.cmpb_rx	dst$,src$,ppr$,ppa$
	  .nlist
	  .globl m$cmpb_rx
	  .iifnb ppa$,		.push	a
	  .iifnb ppa$,		.push	b
	  .iifnb ppr$,		.push	r0
	  .iifnb ppr$,		.push	r1
	  .iifnb ppr$,		.push	r2
	  .src$imm = 0
	  .irpc		c,src$
	    .ifidn	#,c
	      .error	1	; Argument May Not Be A #
	    .endif
	    .mexit
	  .endm
	  .dst$imm = 0
	  .irpc		c,dst$
	    .ifidn	#,c
	      .error	1	; Argument May Not Be A #
	    .endif
	    .mexit
	  .endm
	; Case #3 : Neither Source (src$) Or Destination (dst$) Are #s
	  .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	r1,#dst$
	  mov	r0,#src$
	  lcall	m$cmpb_rx
	  .nlist
	  .iifnb ppr$,		.pop	r2
	  .iifnb ppr$,		.pop	r1
	  .iifnb ppr$,		.pop	r0
	  .iifnb ppa$,		.pop	b
	  .iifnb ppa$,		.pop	a
	.endm

.ifndef	_macros

	.globl	m$cmpb_rx

	.area	Code

m$cmpb_rx:
	movx	a,@r1
	mov	b,a
	movx	a,@r0
	clr	c
	subb	a,b
	jnz	1$
	setb	c
	ret
1$:	clr	c
	ret
.endif
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
;	Macro To Compare Two 2-Byte XData Elements (R Indirect)
;
;	Arguments:
;		dst$	- Destination Address		Required
;		src$	- Source Address		Required
;		ppr$	- Push/Pop reg If Non-Blank	Optional
;		ppa$	- Push/Pop a/b If Non-Blank	Optional
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;

	.macro	.cmpw_rx	dst$,src$,ppr$,ppa$
	  .nlist
	  .globl m$cmpw_rx
	  .iifnb ppa$,		.push	a
	  .iifnb ppa$,		.push	b
	  .iifnb ppr$,		.push	r0
	  .iifnb ppr$,		.push	r1
	  .iifnb ppr$,		.push	r2
	  .src$imm = 0
	  .irpc		c,src$
	    .ifidn	#,c
	      .error	1	; Argument May Not Be A #
	    .endif
	    .mexit
	  .endm
	  .dst$imm = 0
	  .irpc		c,dst$
	    .ifidn	#,c
	      .error	1	; Argument May Not Be A #
	    .endif
	    .mexit
	  .endm
	; Case #3 : Neither Source (src$) Or Destination (dst$) Are #s
	  .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	r1,#dst$
	  mov	r0,#src$
	  lcall	m$cmpw_rx
	  .nlist
	  .iifnb ppr$,		.pop	r2
	  .iifnb ppr$,		.pop	r1
	  .iifnb ppr$,		.pop	r0
	  .iifnb ppa$,		.pop	b
	  .iifnb ppa$,		.pop	a
	.endm

.ifndef	_macros

	.globl	m$cmpw_rx

	.area	Code

m$cmpw_rx:
	mov	r2,#2

1$:	movx	a,@r1
	mov	b,a
	movx	a,@r0
	clr	c
	subb	a,b
	jnz	2$
	inc	r1
	inc	r0
	djnz	r2,1$
	setb	c
	ret
2$:	clr	c
	ret
.endif
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
;	Macro To Move An XData Byte To Another XData Byte (R Indirect)
;
;	Arguments:
;		dst$	- Destination Address		Required
;		src$	- Source Address		Required
;		ppr$	- Push/Pop reg If Non-Blank	Optional
;		ppa$	- Push/Pop  a  If Non-Blank	Optional
;		reg$	- Index Register R0/R1		Optional
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.macro	.mvb_rx	dst$,src$,ppr$,ppa$,reg$
	  .nlist
	  .iifnb ppa$,		.push	a
	  .ifb	reg$
	    .iifnb ppr$,	.push	r1
	    .lb_rx	a,src$,,,r1
	    .sb_rx	dst$,a,,,r1
	    .iifnb ppr$,	.pop	r1
	  .else
	    .iifnb ppr$,	.push	reg$
	    .lb_rx	a,src$,,,reg$
	    .sb_rx	dst$,a,,,reg$
	    .iifnb ppr$,	.pop	reg$
	  .endif
	  .iifnb ppa$,		.pop	a
	.endm
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
;	Macro To Move An EData Word To Another EData Word (R Indirect)
;
;	Arguments:
;		dst$	- Destination Address		Required
;		src$	- Source Address		Required
;		ppr$	- Push/Pop reg If Non-Blank	Optional
;		ppa$	- Push/Pop  a  If Non-Blank	Optional
;		reg$	- Index Register R0/R1		Optional
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;

	.macro	.mvw_rx	dst$,src$,ppr$,ppa$,reg$
	  .nlist
	  ; reg$ Not Used
	  .globl m$mvw_rx
	  .iifnb ppa$,		.push	a
	  .iifnb ppr$,		.push	r1
	  .iifnb ppr$,		.push	r0
	  .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	r0,#dst$
	  mov	r1,#src$
	  lcall	m$mvw_rx
	  .nlist
	  .iifnb ppr$,		.pop	r0
	  .iifnb ppr$,		.pop	r1
	  .iifnb ppr$,		.pop	a
	.endm

.ifndef	_macros

	.globl	m$mvw_rx

	.area	Code

m$mvw_rx:
	movx	a,@r1
	movx	@r0,a
	inc	r1
	inc	r0
	movx	a,@r1
	movx	@r0,a
	ret
.endif
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
;	Macro To Move An EData Element To Another EData Element (DPTR Indirect)
;
;	Arguments:
;		dst$	- Destination Address		Required
;		src$	- Source Address		Required
;		ppx$	- Push/Pop dptr If Non-Blank	Optional
;		ppa$	- Push/Pop  a   If Non-Blank	Optional
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.macro	.mvb_xx	dst$,src$,ppx$,ppa$
	  .nlist
	  .iifnb ppa$,		.push	a
	  .iifnb ppx$,		.push	dph
	  .iifnb ppx$,		.push	dpl
	  .lb_x	a,src$
	  .sb_x	dst$,a
	  .iifnb ppx$,		.pop	dpl
	  .iifnb ppx$,		.pop	dph
	  .iifnb ppa$,		.pop	a
	.endm
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
;	Macro To Move A 2-Byte EData Element To A 2-Byte EData Element (DPTR Indirect)
;
;	Arguments:
;		dst$	- Destination Address		Required
;		src$	- Source Address		Required
;		ppx$	- Push/Pop dptr If Non-Blank	Optional
;		ppa$	- Push/Pop  a   If Non-Blank	Optional
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.macro	.mvw_xx	dst$,src$,ppx$,ppa$
	  .nlist
	  .iifnb ppa$,		.push	a
	  .iifnb ppx$,		.push	dph
	  .iifnb ppx$,		.push	dpl
	  .lb_x	a,src$
	  .sb_x	dst$,a
	  .lb_x	a,src$+1
	  .sb_x	dst$+1,a
	  .iifnb ppx$,		.pop	dpl
	  .iifnb ppx$,		.pop	dph
	  .iifnb ppa$,		.pop	a
	.endm
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
;	Macro To Move An EData Element To An IData Element (DPTR/R Indirect)
;
;	Arguments:
;		dst$	- Destination Address		Required
;		src$	- Source Address		Required
;		ppx$	- Push/Pop reg If Non-Blank	Optional
;		ppa$	- Push/Pop  a  If Non-Blank	Optional
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.macro	.mvb_ix	dst$,src$,ppx$,ppa$
	  .nlist
	  .iifnb ppa$,		.push	a
	  .lb_x	a,src$,ppx,ppa
	  .sb_r	dst$,a,ppx,ppa
	  .iifnb ppa$,		.pop	a
	.endm
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
;	Macro To Move A 2-Byte EData Element To A 2-Byte IData Element (DPTR/R Indirect)
;
;	Arguments:
;		dst$	- Destination Address		Required
;		src$	- Source Address		Required
;		ppx$	- Push/Pop reg If Non-Blank	Optional
;		ppa$	- Push/Pop  a  If Non-Blank	Optional
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.macro	.mvw_ix	dst$,src$,ppx$,ppa$
	  .nlist
	  .iifnb ppa$,		.push	a
	  .iifnb ppx$,		.push	r1
	  .iifnb ppx$,		.push	dph
	  .iifnb ppx$,		.push	dpl
	  .lb_x	a,src$
	  .sb_r dst$,a
	  .lb_x	a,src$+1
	  .sb_r dst$+1,a
	  .iifnb ppx$,		.pop	dpl
	  .iifnb ppx$,		.pop	dph
	  .iifnb ppx$,		.pop	r1
	  .iifnb ppa$,		.pop	a
	.endm
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
;	Macro To Move An IData Element To An EData Element (R/DPTR Indirect)
;
;	Arguments:
;		dst$	- Destination Address		Required
;		src$	- Source Address		Required
;		ppx$	- Push/Pop reg If Non-Blank	Optional
;		ppa$	- Push/Pop  a  If Non-Blank	Optional
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.macro	.mvb_xi	dst$,src$,ppx$,ppa$
	  .nlist
	  .iifnb ppa$,		.push	a
	  .lb_r a,src$,ppx,ppa
	  .sb_x	dst$,a,ppx,ppa
	  .iifnb ppa$,		.pop	a
	.endm
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
;	Macro To Move A 2-Byte IData Element To A 2-Byte EData Element (R/DPTR Indirect)
;
;	Arguments:
;		dst$	- Destination Address		Required
;		src$	- Source Address		Required
;		ppx$	- Push/Pop reg If Non-Blank	Optional
;		ppa$	- Push/Pop  a  If Non-Blank	Optional
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.macro	.mvw_xi	dst$,src$,ppx$,ppa$
	  .nlist
	  .iifnb ppa$,		.push	a
	  .iifnb ppx$,		.push	r1
	  .iifnb ppx$,		.push	dph
	  .iifnb ppx$,		.push	dpl
	  .lb_r a,src$
	  .sb_x	dst$,a
	  .lb_r a,src$+1
	  .sb_x	dst$+1,a
	  .iifnb ppx$,		.pop	dpl
	  .iifnb ppx$,		.pop	dph
	  .iifnb ppx$,		.pop	r1
	  .iifnb ppa$,		.pop	a
	.endm
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
;	DJNZ Macro For An EData Element (R Indirect)
;
;	Arguments:
;		src$	- Source Address		Required
;		jmp$	- Jump Address			Required
;		ppr$	- Push/Pop reg If Non-Blank	Optional
;		ppa$	- Push/Pop  a  If Non-Blank	Optional
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.macro	.djnz_rx  adr$,jmp$,ppr$,ppa$,reg$
	  .nlist
	  .iifnb ppa$,		.push	a
	  .ifb	reg$
	    .iifnb ppr$,	.push	r1
	    .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	r1,#adr$
	  movx	a,@r1
	  dec	a
	  movx	@r1,a
	  add	a,#0xFF
	    .nlist
	    .iifnb ppr$,	.pop	r1
	  .else
	    .iifnb ppr$,	.push	reg$
	    .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	reg$,#adr$
	  movx	a,@reg$
	  dec	a
	  movx	@reg$,a
	  add	a,#0xFF
	    .nlist
	    .iifnb ppr$,	.pop	reg$
	  .endif
	  .iifnb ppa$,	.pop	a
	  .list	(!,err,loc,bin,cyc,eqt,src,me)
	  jc	jmp$
	  .nlist
	.endm
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
;	DJNZ Macro For An EData Element (DPTR Indirect)
;
;	Arguments:
;		adr$	- Source Address		Required
;		jmp$	- Jump Address			Required
;		ppx$	- Push/Pop dptr If Non-Blank	Optional
;		ppa$	- Push/Pop  a   If Non-Blank	Optional
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.macro	.djnz_x	adr$,jmp$,ppx$,ppa$
	  .nlist
	  .iifnb ppa$,	.push	a
	  .ifb	reg$
	  .iifnb ppx$,	.push	dph
	  .iifnb ppx$,	.push	dpl
	  .list	(!,err,loc,bin,cyc,eqt,src,me)
	  mov	dptr,#adr$
	  movx	a,@dptr
	  dec	a
	  movx	@dptr,a
	  add	a,#0xFF
	  .nlist
	  .iifnb ppx$,	.pop	dpl
	  .iifnb ppx$,	.pop	dph
	  .iifnb ppa$,	.pop	a
	  .list	(!,err,loc,bin,cyc,eqt,src,me)
	  jc	jmp$
	  .nlist
	.endm
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
; .ldptr  adr		For Data Memory 0x0000 - 0x007F
;
; Load DPTR Supports Two Options
;
;	.ldptr #arg	Where The Immediate Value #arg => dptr
;	.ldptr  arg	Where The Contents Of Location arg => dptr
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.macro	.ldptr		src$
	  .nlist
	  .ld$imm =: 0
	  .irpc		c,src$
	    .ifidn	#,c
	      .ld$imm =: 1
	    .endif
	    .mexit
	  .endm
	  .ifne	.ld$imm
	    .list	(!,err,loc,bin,eqt,cyc,src,me)
	  mov	dptr,src$
	    .nlist
	  .else
	    .list	(!,err,loc,bin,eqt,cyc,src,me)
	  mov	dph,src$
	  mov	dpl,src$+1
	    .nlist
	  .endif
	.endm
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
; .ldptr_r  src$	For Data Memory 0x00 - 0x7F
;			And SFR  Memory 0x80 - 0xFF
;
; Load DPTR Supports One Option
;
;	.ldptr_r  src$		Where The Contents Of Location src$ => dptr
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;

	.macro	.ldptr_r	src$,ppr$
	  .nlist
	  .globl m$ldptr_r
	  .iifnb ppr$,	.push	r1
	  .list	(!,err,loc,bin,eqt,cyc,src,me)
	  mov	r1,#src$
	  lcall	m$ldptr_r
	  .nlist
	  .iifnb ppr$,	.pop	r1
	.endm

.ifndef	_macros

	.globl	m$ldptr_r

	.area	Code

m$ldptr_r:
	push	a		; save a and b
	mov	a,@r1		; get new dph value
	mov	dph,a
	inc	r1		; next adress
	mov	a,@r1		; get new dpl value
	mov	dpl,a
	pop	a
	ret
.endif
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
; .ldptr_rx  src$	For Data Memory 0x0080 - 0x00FF
;
; Load DPTR Supports One Option
;
;	.ldptr_rx  src$		Where The Contents Of Location src$ => dptr
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;

	.macro	.ldptr_rx	src$,ppr$
	  .nlist
	  .globl m$ldptr_rx
	  .iifnb ppr$,	.push	r1
	  .list	(!,err,loc,bin,eqt,cyc,src,me)
	  mov	r1,#src$
	  lcall	m$ldptr_rx
	  .nlist
	  .iifnb ppr$,	.pop	r1
	.endm

.ifndef	_macros

	.globl	m$ldptr_rx

	.area	Code

m$ldptr_rx:
	push	a		; save a
	movx	a,@r1		; get new dph value
	mov	dph,a
	inc	r1		; next adress
	movx	a,@r1		; get new dpl value
	mov	dpl,a
	pop	a
	ret
.endif
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
; .ldptr_x  src$	For EData Memory 0x0000 - 0xFFFF
;
; Load DPTR Supports One Option
;
;	.ldptr_x  src$		Where The Contents Of Location src$ => dptr
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;

	.macro	.ldptr_x	src$
	  .nlist
	  .globl m$ldptr_x
	  .list	(!,err,loc,bin,eqt,cyc,src,me)
	  mov	dptr,#src$
	  lcall	m$ldptr_x
	  .nlist
	.endm

.ifndef	_macros

	.globl	m$ldptr_x

	.area	Code

m$ldptr_x:
	push	a		; save a and b
	push	b
	movx	a,@dptr		; get new dph value
	mov	b,a		; save in b
	inc	dptr		; next adress
	movx	a,@dptr		; get new dpl value
	mov	dph,b		; load dptr
	mov	dpl,a
	pop	b		; restore a and b
	pop	a
	ret
.endif
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
; .sdptr  dst$		For Data Memory 0x0000 - 0x007F
;
; Store DPTR Supports One Option
;
;	.sdptr  dst$		Where The Contents Of dptr => dst$
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.macro	.sdptr	dst$
	  .list	(!,err,loc,bin,eqt,cyc,src,me)
	  mov	dst$,dph
	  mov	dst$+1,dpl
	  .nlist
	.endm
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
; .sdptr_r  adr		For IData Memory 0x0080 - 0x007F
;
; Store DPTR Supports One Option
;
;	.sdptr_r  dst$,ppr$,ppa$,reg$		Where The Contents Of dptr => adr
;		dst$   - IData Memory Address
;		ppr$   - Optional Register R0/R1, Left Blank Defaults To R1
;		ppa$   - Dumby Argument Signifies Push/Pop Used Registers
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.macro	.sdptr_r	dst$,ppr$,ppa$,reg$
	  .nlist
	  .iifnb ppa$,	.push	a
	  .ifb	reg$
	    .iifnb ppr$,	.push	r1
	    .list	(!,err,loc,bin,eqt,cyc,src,me)
	  mov	r1,#dst$
	  mov	@r1,dph
	  inc	r1
	  mov	@r1,dpl
	    .nlist
	    .iifnb ppr$,	.pop	r1
	  .else
	    .chkr01 reg$
	    .iifnb ppr$,	.push	reg$
	    .list	(!,err,loc,bin,eqt,cyc,src,me)
	  mov	reg$,#dst$
	  mov	@reg$,dph
	  inc	reg$
	  mov	@reg$,dpl
	    .nlist
	    .iifnb ppr$,	.pop	reg$
	  .endif
	  .iifnb ppa$,	.pop	a
	.endm
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
; .sdptr_rx  dst$	For XData Memory 0x0000 - 0x00FF
;
; Store DPTR Supports One Option
;
;	.sdptr_rx  dst$,ppr$,ppa$,reg$		Where The Contents Of dptr => dst$
;		dst$   - IData Memory Address
;		ppr$   - Dumby Argument Signifies Push/Pop of R1 (or reg$)
;		ppa$   - Dumby Argument Signifies Push/Pop of A
;		reg$   - Optional Register R0/R1, Left Blank Defaults To R1
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.macro	.sdptr_rx	dst$,ppr$,ppa$,reg$
	  .nlist
	  .iifnb ppa$,	.push	a
	  .ifb	reg$
	    .iifnb ppr$,	.push	r1
	    .list	(!,err,loc,bin,eqt,cyc,src,me)
	  mov	r1,#dst$
	  mov	a,dph
	  movx	@r1,a
	  inc	r1
	  mov	a,dpl
	  movx	@r1,a
	    .nlist
	    .iifnb ppr$,	.pop	r1
	  .else
	    .chkr01 reg$
	    .iifnb ppr$,	.push	reg$
	    .list	(!,err,loc,bin,eqt,cyc,src,me)
	  mov	reg$,#dst$
	  mov	a,dph
	  movx	@reg$,a
	  inc	reg$
	  mov	a,dpl
	  movx	@reg$,a
	    .nlist
	    .iifnb ppr$,	.pop	reg$
	  .endif
	  .iifnb ppa$,	.pop	a
	.endm
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
; .sdptr_x  dst$		For EData Memory 0x0000 - 0xFFFF
;
; Store DPTR Supports One Option
;
;	.sdptr_x  dst$		Where The Contents Of dptr => dst$
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;

	.macro	.sdptr_x	dst$
	  .nlist
	  .globl m$sdptr_x
	  .list	(!,err,loc,bin,eqt,cyc,src,me)
	  sjmp	.+0d16
	  push	a		; save registers
	  push	b
	  push	dpl
	  push	dph
	  mov	dptr,#dst$	; load EData address
	  ljmp	m$sdptr_x
	  lcall .-0d14		; stack return address
				; st_dptrx returns here
	  .nlist
	.endm

.ifndef	_macros

	.globl	m$sdptr_x

	.area	Code

m$sdptr_x:
	pop	a		; a <= dph
	movx	@dptr,a		; dph => adr+0
	mov	b,a		; save dph
	inc	dptr		; next location
	pop	a		; a <= dpl
	movx	@dptr,a		; dpl => adr+1
	mov	dpl,a		; restore registers
	mov	dph,b
	pop	b
	pop	a
	ret
.endif
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
; .ad_dptr  val
;
; Add To DPTR Supports One Mode
;
;	.ad_dptr  #val		Where The Contents Of dptr <= dptr + #val
;
;				Val Can Be A Positive Or Negative Number
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.macro	.ad_dptr	val
	  .list	(!,err,loc,bin,eqt,cyc,src,me)
	  push	a
	  mov	a,dpl
	  add	a,<val
	  mov	dpl,a
	  mov	a,dph
	  addc	a,>val
	  mov	dph,a
	  pop	a
	  .nlist
	.endm
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
; pshreg
;
; Push	dpl, dph, a, b,
;	r0, r1, r2, r3, r4, r5, r6, and r7
;	onto stack
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.macro	.pshreg		ppx$
	  .nlist
	  .globl psh$reg
	  .list	(!,err,loc,bin,eqt,cyc,src,me)
	  push	dpl
	  push	dph
	  lcall	psh$reg
	  .nlist
	.endm

.ifndef	_macros

	.globl	psh$reg

	.area	Code

psh$reg:
	pop	dph		; pop return address
	pop	dpl
	push	a
	push	b
	push	r0
	push	r1
	push	r2
	push	r3
	push	r4
	push	r5
	push	r6
	push	r7
	push	dpl		; push return address
	push	dph
	ret			; return
.endif
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
; popreg
;
; Pop	r7, r6, r5, r4, r3, r2, r1, r0
;	b, a, dph, and dpl
;	from stack
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****
;
	.macro	.popreg
	  .nlist
	  .globl pop$reg
	  .list	(!,err,loc,bin,eqt,cyc,src,me)
	  lcall	pop$reg
	  pop	dph
	  pop	dpl
	.endm

.ifndef	_macros

	.globl	pop$reg

	.area	Code

pop$reg:
	pop	dph		; pop return address
	pop	dpl
	pop	r7
	pop	r6
	pop	r5
	pop	r4
	pop	r3
	pop	r2
	pop	r1
	pop	r0
	pop	b
	pop	a
	push	dpl		; restore return address
	push	dph
	ret			; return
.endif
;
; *****-----*****-----*****-----*****-----*****-----*****-----*****

	.end

