.nlist
;****************************************************************************
;
; Compile The Assembly Code
;
;	AS89LP -loxff timers.asm
;
; To Define The timers.asm Globals Place The Following Lines In Your Code
;
;	.define _timers
;	.list	(!)	; This Inhibits The Include File Pagination
;	.include "timers.asm"
;	.list
;
;****************************************************************************

	tmr$dbg	=: 1		; Include Debug Option

	tm0$tmr	=: 1		; != 0, Create Timer 0
	tm1$tmr	=: 0		; Timer 1 Used By The Serial Port
	tm2$tmr	=: 1		; != 0, Create Timer 2

.ifne	tm0$tmr
	.define	Int$TF0
.endif

.ifne	tm1$tmr
	.define	Int$TF1
.endif

.ifne	tm2$tmr
	.define	Int$TF2
.endif

.ifndef	tmr$dbg
	tmr$dbg	=: 0		; Default To No Timer Test Code
.endif

	tmr$tmr	=: tm0$tmr + tm1$tmr + tm1$tmr

;****************************************************************************
;
; Globals In A Macro
;
	.macro	.timers.globals	arg$
	  .ifne  tm0$tmr
	    .iifne  arg$	.list	(!,src,me)
	.globl	t0$ini		; Initialize Timer
	.globl	TF0Int		; Timer 0 Interrupt Service Routine
	.globl	tm0bsy		; Timer 0 Busy Flag
	.globl	tm0ret		; Timer 0 reti/ret Flag
	.globl	st$tm0		; Timer 0 Function
	.globl	t0$msb		; Tick Counter (MSB)
	.globl	t0$lsb		; Tick Counter (LSB)
	    .nlist
	    .ifne  tmr$dbg
	      .iifne  arg$	.list	(!,src,me)
	.globl	tm0dbg		; Timer 0 Test Control
	.globl	tm0xbt		; Timer 0 Test Bit Select
	      .nlist
	    .endif
	  .endif

	  .ifne  tm1$tmr
	    .iifne  arg$	.list	(!,src,me)
	.globl	t1$ini		; Initialize Timer
	.globl	TF1Int		; Timer 1 Interrupt Service Routine
	.globl	tm1bsy		; Timer 1 Busy Flag
	.globl	tm1ret		; Timer 1 reti/ret Flag
	.globl	st$tm1		; Timer 1 Function
	.globl	t1$msb		; Tick Counter (MSB)
	.globl	t1$lsb		; Tick Counter (LSB)
	    .nlist
	    .ifne  tmr$dbg
	      .iifne  arg$	.list	(!,src,me)
	.globl	tm1dbg		; Timer 1 Test Control
	.globl	tm1xbt		; Timer 1 Test Bit Select
	      .nlist
	    .endif
	  .endif

	  .ifne  tm2$tmr
	    .iifne  arg$	.list	(!,src,me)
	.globl	t2$ini		; Initialize Timer
	.globl	TF2Int		; Timer 2 Interrupt Service Routine
	.globl	tm2bsy		; Timer 2 Busy Flag
	.globl	tm2ret		; Timer 2 reti/ret Flag
	.globl	st$tm2		; Timer 2 Function
	.globl	t2$msb		; Tick Counter (MSB)
	.globl	t2$lsb		; Tick Counter (LSB)
	    .nlist
	    .ifne  tmr$dbg
	      .iifne  arg$	.list	(!,src,me)
	.globl	tm2dbg		; Timer 2 Test Control
	.globl	tm2xbt		; Timer 2 Test Bit Select
	      .nlist
	    .endif
	  .endif

	  .ifne	tmr$tmr
	    .iifne  arg$	.list	(!,src,me)
 	.globl	timer_init
	    .nlist
	  .endif
	.endm
;
;****************************************************************************
;
;  Publics
;
.ifdef _timers
	.list	(!,src)
;	timers.asm      Globals                 Defined
	.nlist

	.timers.globals	0
.else
	.list
	.title	MFM And IDE Drive Access

	.module	TIMERS

	.ifne	tmr$dbg
	  .msg	^"***** Timer Debugging Code Included *****"
	.endif

	.timers.globals	1

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
;  Externals By Inclusion
;
	.define	_macros
	.define	_btcs
	.define	_mfm
	.define	_mondeb51

	.list	(!)	; This Inhibits The Include File Pagination
	.include "macros.asm"
	.list
	.list	(!)	; This Inhibits The Include File Pagination
	.include "btcs.asm"
	.list
	.list	(!)	; This Inhibits The Include File Pagination
	.include "mfm.asm"
	.list
	.list	(!)	; This Inhibits The Include File Pagination
	.include "mondeb51.asm"
	.list
;
;****************************************************************************

	.page
	.sbttl	Bits And Bytes

;****************************************************************************
;
.ifne	0
	.define	TData  ^/Data/	; Normal Configuration
.else
	.define	TData  ^/RData/	; Alternate Uses Register Space
.endif


.ifne	tm0$tmr
	.area	Bits

tm0bsy:	.blkb	1			; A Busy Flag For Each Timer
tm0ret:	.blkb	1			; reti/ret exit flag
 .ifne	tmr$dbg
tm0dbg:	.blkb	1
tm0xbt:	.blkb	1
 .endif

	.area	TData

tcntr0:	.blkb	1			; A Byte For Each Counter
tfunc0:	.blkb	2			; A Word For Each Call Address
t0$msb:	.blkb	1			; Tick Counter (MSB)
t0$lsb:	.blkb	1			; Tick Counter (LSB)
.endif	; tmo$tmr

.ifne	tm1$tmr
	.area	Bits

tm1bsy:	.blkb	1			; A Busy Flag For Each Timer
tm1ret:	.blkb	1			; reti/ret exit flag
 .ifne	tmr$dbg
tm1dbg:	.blkb	1
tm1xbt:	.blkb	1
 .endif

	.area	TData

tcntr1:	.blkb	1			; A Byte For Each Counter
tfunc1:	.blkb	2			; A Word For Each Call Address
t1$msb:	.blkb	1			; Tick Counter (MSB)
t1$lsb:	.blkb	1			; Tick Counter (LSB)
.endif	; tm1$tmr

.ifne	tm2$tmr
	.area	Bits

tm2bsy:	.blkb	1			; A Busy Flag For Each Timer
tm2ret:	.blkb	1			; reti/ret exit flag
 .ifne	tmr$dbg
tm2dbg:	.blkb	1
tm2xbt:	.blkb	1
 .endif

	.area	TData

tcntr2:	.blkb	1			; A Byte For Each Counter
tfunc2:	.blkb	2			; A Word For Each Call Address
t2$msb:	.blkb	1			; Tick Counter (MSB)
t2$lsb:	.blkb	1			; Tick Counter (LSB)
.endif	; tm2$tmr
;
;****************************************************************************

	.page
	.sbttl	tmr$dbg Diagnostic Bits Manipulation

;****************************************************************************
;
;	The Macros
;
	.macro	.dbg	arg
	  .nlist
	  .ifne arg
	    .debug =: tmr$dbg
	  .else
	    .debug =: 0
	  .endif
	.endm
;
; Manually Disable Inclusion Of Individual Debug Routines
; By Using These Options:
;
	dbg.tm0dbg = 1	; 1 => Debug, 0 => No Debug
	dbg.tm1dbg = 1	; 1 => Debug, 0 => No Debug
	dbg.tm2dbg = 1	; 1 => Debug, 0 => No Debug
;
;****************************************************************************
;
.ifne	tmr$tmr

.ifne	tm0$tmr
	.macro	.tm0$dbg.setb	?arg1,?arg2
	  .nlist
	  .dbg	dbg.tm0dbg
	  .ifne .debug
	    .list	(!,err,loc,bin,cyc,eqt,lin,src,me)
	  jnb	tm0dbg,arg2
	  jb	tm0xbt,arg1
	  .x1setb
	  sjmp	arg2
arg1:	  .x2setb
arg2:
	   .nlist
	  .endif
	.endm

	.macro	.tm0$dbg.clrb	?arg1,?arg2
	  .nlist
	  .dbg	dbg.tm0dbg
	  .ifne .debug
	    .list	(!,err,loc,bin,cyc,eqt,lin,src,me)
	  jnb	tm0dbg,arg2
	  jb	tm0xbt,arg1
	  .x1clrb
	  sjmp	arg2
arg1:	  .x2clrb
arg2:
	   .nlist
	  .endif
	.endm
.endif	; tm0$tmr

.ifne	tm1$tmr
	.macro	.tm1$dbg.setb	?arg1,?arg2
	  .nlist
	  .dbg	dbg.tm1dbg
	  .ifne .debug
	    .list	(!,err,loc,bin,cyc,eqt,lin,src,me)
	  jnb	tm1dbg,arg2
	  jb	tm1xbt,arg1
	  .x1setb
	  sjmp	arg2
arg1:	  .x2setb
arg2:
	   .nlist
	  .endif
	.endm

	.macro	.tm1$dbg.clrb	?arg1,?arg2
	  .nlist
	  .dbg	dbg.tm1dbg
	  .ifne .debug
	    .list	(!,err,loc,bin,cyc,eqt,lin,src,me)
	  jnb	tm1dbg,arg2
	  jb	tm1xbt,arg1
	  .x1clrb
	  sjmp	arg2
arg1:	  .x2clrb
arg2:
	   .nlist
	  .endif
	.endm
.endif	; tm1$tmr

.ifne	tm2$tmr
	.macro	.tm2$dbg.setb	?arg1,?arg2
	  .nlist
	  .dbg	dbg.tm2dbg
	  .ifne .debug
	    .list	(!,err,loc,bin,cyc,eqt,lin,src,me)
	  jnb	tm2dbg,arg2
	  jb	tm2xbt,arg1
	  .x1setb
	  sjmp	arg2
arg1:	  .x2setb
arg2:
	   .nlist
	  .endif
	.endm

	.macro	.tm2$dbg.clrb	?arg1,?arg2
	  .nlist
	  .dbg	dbg.tm2dbg
	  .ifne .debug
	    .list	(!,err,loc,bin,cyc,eqt,lin,src,me)
	  jnb	tm2dbg,arg2
	  jb	tm2xbt,arg1
	  .x1clrb
	  sjmp	arg2
arg1:	  .x2clrb
arg2:
	   .nlist
	  .endif
	.endm
.endif	; tm2$tmr

;
;****************************************************************************

	.page
	.sbttl	Timer Code

;****************************************************************************
;
	.area	Code

; Initialize The Timer(s)
timer_init:
.ifne	tm0$tmr
	.msg	^"*****    Timer 0 Default: 1 ms.     *****"
	mov	dptr,#-20000
	lcall	t0$ini
.endif	; tm0$tmr
.ifne	tm1$tmr
	.msg	^"*****    Timer 1 Default: 1 ms.     *****"
	mov	dptr,#-20000
	lcall	t1$ini
.endif	; tm1$tmr
.ifne	tm2$tmr
	.msg	^"*****    Timer 2 Default: 1 ms.     *****"
	mov	dptr,#-20000
	lcall	t2$ini
.endif	; tm2$tmr
	ret

.endif
;
;****************************************************************************

	.page
	.sbttl	Timer 0 Code

;****************************************************************************
.ifne	tm0$tmr
;
; Call With DPTR Containing Timer Interval In Clock Ticks
;
t0$ini:	jbc	ea,2$			; if ea = 1 then clear ea and branch

1$:	clr	a
	mov	tcntr0,a		; clear counter
	mov	t0$msb,a		; clear ticks
	mov	t0$lsb,a
	mov	tfunc0+0,a		; clear function call
	mov	tfunc0+1,a
	mov	rl0,dpl			; load <RH0:RL0>
	mov	rh0,dph
	mov	a,tmod			; TM0 16-Bit Auto-Reload Counter
	anl	a,#0xF0
	orl	a,#0b00000001	        ; BOT <RH0:RL0> -> MAX
        mov     tmod,a
	setb	tm0bsy			; timer 0 busy
	clr	tf0			; clear overflow
	setb	tr0			; timer 0 On
	setb	et0			; Timer 0 Interrupt Enabled
	ret

2$:	lcall	1$			; now call t0$ini with ea = 0
	setb	ea			; then set ea = 1
	ret				; and exit
;
; Timer Interrupt Processing
;
TF0Int:	;clr	tf0	; auto cleared	; clear overflow

	push	psw			; save status register
	push	a

	clr	a			; update clock ticks
	inc	t0$lsb
	cjne	a,t0$lsb,1$
	inc	t0$msb

1$:	jb	tm0bsy,TF0rti		; on busy skip
	push	dph			; save minimal registers
	push	dpl

	.tm0$dbg.setb
	;
	; Timer 0 Function Processing Beginning
	;
TF0tm0:	clr	tm0ret			; normal reti exit flag
	mov	a,tcntr0		; load tm0 counter
	jz	3$			; if 0, then timed out earlier
	dec	a			; count off 1 tick
	mov	tcntr0,a		; and save
	jnz	3$			; if tcntr is not 0 then exit
	mov	dph,tfunc0+0		; get external function address
	mov	dpl,tfunc0+1
	clr	a			; on a NULL address
	cjne	a,dph,2$		; do nothing
	cjne	a,dpl,2$		; else prepare to call function
	sjmp	3$			; (function may allow interrupts)
1$:	jmp	@a+dptr			; call function
2$:	setb	tm0bsy			; set busy flag and
	lcall	1$			; setup return address
3$:	; *****
	; The timer interrupt normally is processed at interrupt
	; level which blocks all other interrupts at the timer
	; interrupt priority.  To run the service process and
	; allow interrupts the called routine must perform a
	; fake reti to reset the interrupt logic:
	;
	;		sjmp	2$
	;	1$:	setb	tm0ret	; use non-interrupt return
	;		reti		; return from interrupt
	;	2$:	lcall	1$	; call the fake interrupt return
	;
	;	-- service routine --
	;
	; The service routine always exits normally:
	;
	;		ret
	; *****
	;
	; Timer 0 Function Processing Finished
	;
	.tm0$dbg.clrb

	pop	dpl			; restore registers
	pop	dph

	jb	tm0ret,TF0ret
TF0rti:	pop	a
	pop	psw			; restore status register
	reti				; take normal reti exit
TF0ret:	pop	a
	pop	psw			; restore status register
	ret				; take an ret exit

;
; Timer Function #0
;
st$tm0:	jbc	ea,2$			; if ea = 1 then clear ea and branch

1$:	clr	tm0bsy			; reset timer busy flag
	mov	tcntr0,a		; save count down in ticks
	mov	tfunc0+0,dph		; save call address
	mov	tfunc0+1,dpl
;	mov	tl0,rl0			; reset counter
;	mov	th0,rh0
	clr	tf0			; clear overflow
	setb	et0			; enable timer interrupt
	ret

2$:	lcall	1$			; now call routine  with ea = 0
	setb	ea			; then set ea = 1
	ret				; and exit
.endif	; tm0$tmr
;
;****************************************************************************

	.page
	.sbttl	Timer 1 Code

;****************************************************************************
.ifne	tm1$tmr
;
; Call With DPTR Containing Timer Interval In Clock Ticks
;
t1$ini:	jbc	ea,2$			; if ea = 1 then clear ea and branch

1$:	clr	a
	mov	tcntr1,a		; clear counter
	mov	t1$msb,a		; clear ticks
	mov	t1$lsb,a
	mov	tfunc1+0,a		; clear function call
	mov	tfunc1+1,a
	mov	rl1,dpl			; load <RH0:RL0>
	mov	rh1,dph
	mov	a,tmod			; TM0 16-Bit Auto-Reload Counter
	anl	a,#0x0F
	orl	a,#0b00010000	        ; BOT <RH1:RL1> -> MAX
        mov     tmod,a
	setb	tm1bsy			; timer 1 busy
	clr	tf1			; clear overflow
	setb	tr1			; timer 1 On
	setb	et1			; Timer 1 Interrupt Enabled
	ret

2$:	lcall	1$			; now call t1$ini with ea = 0
	setb	ea			; then set ea = 1
	ret				; and exit
;
; Timer Interrupt Processing
;
TF1Int:	;clr	tf1	; auto cleared	; clear overflow

	push	psw			; save status register
	push	a

	clr	a			; update clock ticks
	inc	t1$lsb
	cjne	a,t1$lsb,1$
	inc	t1$msb

1$:	jb	tm1bsy,TF1rti		; on busy skip
	push	dph			; save minimal registers
	push	dpl

	.tm1$dbg.setb
	;
	; Timer 1 Function Processing Beginning
	;
TF1tm1:	clr	tm1ret			; normal reti exit flag
	mov	a,tcntr1		; load tm1 counter
	jz	3$			; if 0, then timed out earlier
	dec	a			; count off 1 tick
	mov	tcntr1,a		; and save
	jnz	3$			; if tcntr is not 0 then exit
	mov	dph,tfunc1+0		; get external function address
	mov	dpl,tfunc1+1
	clr	a			; on a NULL address
	cjne	a,dph,2$		; do nothing
	cjne	a,dpl,2$		; else prepare to call function
	sjmp	3$			; (function may allow interrupts)
1$:	jmp	@a+dptr			; call function
2$:	setb	tm1bsy			; set busy flag and
	lcall	1$			; setup return address
3$:	; *****
	; The timer interrupt normally is processed at interrupt
	; level which blocks all other interrupts at the timer
	; interrupt priority.  To run the service process and
	; allow interrupts the called routine must perform a
	; fake reti to reset the interrupt logic:
	;
	;		sjmp	2$
	;	1$:	setb	tm1ret	; use non-interrupt return
	;		reti		; return from interrupt
	;	2$:	lcall	1$	; call the fake interrupt return
	;
	;	-- service routine --
	;
	; The service routine always exits normally:
	;
	;		ret
	; *****
	;
	; Timer 1 Function Processing Finished
	;
	.tm1$dbg.clrb

	pop	dpl			; restore registers
	pop	dph

	jb	tm1ret,TF1ret
TF1rti:	pop	a
	pop	psw			; restore status register
	reti				; take normal reti exit
TF1ret:	pop	a
	pop	psw			; restore status register
	ret				; take an ret exit

;
; Timer Function #1
;
st$tm1:	jbc	ea,2$			; if ea = 1 then clear ea and branch

1$:	clr	tm1bsy			; reset timer busy flag
	mov	tcntr1,a		; save count down in ticks
	mov	tfunc1+0,dph		; save call address
	mov	tfunc1+1,dpl
;	mov	tl1,rl1			; reset counter
;	mov	th0,rh1
	clr	tf1			; clear overflow
	setb	et1			; enable timer interrupt
	ret

2$:	lcall	1$			; now call st$tm1 with ea = 0
	setb	ea			; then set ea = 1
	ret				; and exit
.endif	; tm1$tmr
;
;****************************************************************************

	.page
	.sbttl	Timer 2 Code

;****************************************************************************
.ifne	tm2$tmr
;
; Call With DPTR Containing Timer Interval In Clock Ticks
;
t2$ini:	jbc	ea,2$			; if ea = 1 then clear ea and branch

1$:	clr	a
	mov	tcntr2,a		; clear counter
	mov	t2$msb,a		; clear ticks
	mov	t2$lsb,a
	mov	tfunc2+0,a		; clear function call
	mov	tfunc2+1,a
	mov	rcap2l,dpl		; load <RCAPH:RCAPL>
	mov	rcap2h,dph
        mov     t2mod,a			; TM2 16-Bit Auto-Reload Counter
	clr	tf2			; clear overflow
	setb	tr2			; timer 2 On
	setb	et2			; Timer 2 Interrupt Enabled
	ret

2$:	lcall	1$			; now call t2$ini with ea = 0
	setb	ea			; then set ea = 1
	ret				; and exit
;
; Timer Interrupt Processing
;
TF2Int:	clr	tf2			; clear overflow

	push	psw			; save status register
	push	a

	clr	a			; update clock ticks
	inc	t2$lsb
	cjne	a,t2$lsb,1$
	inc	t2$msb

1$:	jb	tm2bsy,TF2rti		; on busy skip
	push	dph			; save minimal registers
	push	dpl

	.tm2$dbg.setb
 	;
	; Timer 2 Function Processing Beginning
	;
TF2tm2:	clr	tm2ret			; normal reti exit flag
	mov	a,tcntr2		; load tm2 counter
	jz	3$			; if 0, then timed out earlier
	dec	a			; count off 1 tick
	mov	tcntr2,a		; and save
	jnz	3$			; if tcntr is not 0 then exit
	mov	dph,tfunc2+0		; get external function address
	mov	dpl,tfunc2+1
	clr	a			; on a NULL address
	cjne	a,dph,2$		; do nothing
	cjne	a,dpl,2$		; else prepare to call function
	sjmp	3$			; (function may allow interrupts)
1$:	jmp	@a+dptr			; call function
2$:	setb	tm2bsy			; set busy flag and
	lcall	1$			; setup return address
3$:	; *****
	; The timer interrupt normally is processed at interrupt
	; level which blocks all other interrupts at the timer
	; interrupt priority.  To run the service process and
	; allow interrupts the called routine must perform a
	; fake reti to reset the interrupt logic:
	;
	;		sjmp	2$
	;	1$:	setb	tm0ret	; use non-interrupt return
	;		reti		; return from interrupt
	;	2$:	lcall	1$	; call the fake interrupt return
	;
	;	-- service routine --
	;
	; The service routine always exits normally:
	;
	;		ret
	; *****
	;
	; Timer 2 Function Processing Finished
	;
	.tm2$dbg.clrb

	pop	dpl			; restore registers
	pop	dph

	jb	tm2ret,TF2ret
TF2rti:	pop	a
	pop	psw			; restore status register
	reti				; take normal reti exit
TF2ret:	pop	a
	pop	psw			; restore status register
	ret				; take an ret exit
;
; Timer Function #2
;
st$tm2:	jbc	ea,2$			; if ea = 1 then clear ea and branch

1$:	clr	tm2bsy			; clear timer busy flag
	mov	tcntr2,a		; save count down in ticks
	mov	tfunc2+0,dph		; save call address
	mov	tfunc2+1,dpl
;	mov	tl2,rcap2l		; reset counter
;	mov	th2,rcap2h
	clr	tf2			; clear overflow
	setb	et2			; enable timer interrupt
	ret

2$:	lcall	1$			; now call st$tm2 with ea = 0
	setb	ea			; then set ea = 1
	ret				; and exit
.endif	; tm2$tmr
;
;****************************************************************************

	.page
	.sbttl	TMR$DBG Functions

;****************************************************************************
;
.ifne	tmr$dbg
 .ifne	tmr$tmr

	; Command Table Entries

	.area	CmdTbl

	ljmp	tmrdbg

;
;****************************************************************************
;
	; Command List Entries 

	.area	CmdLst

	.ascii	/TMRDBG/	; debug testing
	.byte	cr

;
;****************************************************************************
;
	; Command Option List Entries

	.area	OptLst

;
;****************************************************************************
;
	; Extended Help String Pointers

	.area	X_Ptrs

	.word	$tmrdbg

;
;****************************************************************************
;
	; Extended Help Strings

	.area	X_Strs

$tmrdbg:
	.ascii	" TM[RDBG]  M  N  : Observe Timer Processing Interval(s)"
	.byte	cr,lf
	.ascii	"   TM[RDBG]"
	.byte	cr,lf
	.ascii	"     Blank Terminates Test(s)"
	.byte	cr,lf
	.ascii	"   TM[RDBG]  M  : Terminates Timer M Test"
	.byte	cr,lf
	.ascii	"     M   0/1/2  : Timer Select (Not All May Be Available)"
	.byte	cr,lf
	.ascii	"   TM[RDBG]  M  N  : Enables Timer M Test Using Pin N"
	.byte	cr,lf
	.ascii	"     M   0/1/2  : Timer Select (Not All May Be Available)"
	.byte	cr,lf
	.ascii	"     N    1/2   : Strobe Pin X1/X2"
	.byte	eot

;
;****************************************************************************
;
	.area	Debug
;
;****************************************************************************
;
	; Get Timer Number
tmrdbg:	lcall	number		; get timer number
	jb	a.7,2$		; bad syntax
	jnz	3$		; not blank

	; Stop Debugging In All Timers
 
.ifne	tm0$tmr
	clr	tm0dbg		; Disable
	clr	tm0xbt
.endif	; tm0$tmr
.ifne	tm1$tmr
	clr	tm1dbg		; Disable
	clr	tm1xbt
.endif	; tm1$tmr
.ifne	tm2$tmr
	clr	tm2dbg		; Disable
	clr	tm2xbt
.endif	; tm2$tmr
1$:	ljmp	nomore
2$:	ljmp	badsyn

	; Check For Timer Existance

3$:	.lb_rx	a,nbrlo		; load timer number
.ifne	tm0$tmr
	cjne	a,#0,4$		; Not Timer 0 - skip
	sjmp	7$
4$:
.endif	; tm0$tmr
.ifne	tm1$tmr
	cjne	a,#1,5$		; Not Timer 1 - skip
	sjmp	7$
5$:
.endif	; tm1$tmr
.ifne	tm2$tmr
	cjne	a,#2,6$		; Not Timer 2 - skip
	sjmp	7$
6$:
.endif	; tm2$tmr
	sjmp	2$
7$:	push	a		; save

	; Get Strobe Pin

	lcall	number		; get strobe pin number
	pop	b		; restore
	jb	a.7,2$		; bad syntax
	jnz	12$		; not blank

	; Stop Debugging Of Selected Timer

	mov	a,b		; position
.ifne	tm0$tmr
	cjne	a,#0,8$		; Not Timer 0 - skip
	clr	tm0dbg		; Disable
	clr	tm0xbt
	sjmp	1$
8$:
.endif	; tm0$tmr
.ifne	tm1$tmr
	cjne	a,#1,9$		; Not Timer 1 - skip
	clr	tm1dbg		; Disable
	clr	tm1xbt
	sjmp	1$
9$:
.endif	; tm1$tmr
.ifne	tm2$tmr
	cjne	a,#2,10$	; Not Timer 2 - skip
	clr	tm2dbg		; Disable
	clr	tm2xbt
	sjmp	1$
10$:
.endif	; tm2$tmr
	sjmp	2$

	; Setup Debugging Timer

12$:	.lb_rx	a,nbrlo		; load pin number
	xch	a,b		; a == Timer Number, b == Pin Number

.ifne	tm0$tmr
	cjne	a,#0,13$	; Not Timer 0 - skip
	mov	a,b		; restore
	sjmp	dbgtm0
13$:
.endif	; tm0$tmr
.ifne	tm1$tmr
	cjne	a,#1,14$	; Not Timer 1 - skip
	mov	a,b		; restore
	sjmp	dbgtm1
14$:
.endif	; tm1$tmr
.ifne	tm2$tmr
	cjne	a,#2,15$	; Not Timer 2 - skip
	mov	a,b		; restore
	sjmp	dbgtm2
15$:
.endif	; tm2$tmr
	sjmp	2$

.ifne	tm0$tmr
dbgtm0:	cjne	a,#1,1$		; Not X1 - skip
	clr	tm0xbt
	sjmp	2$
1$:	cjne	a,#2,3$		; Not X2 - Error
	setb	tm0xbt
;	sjmp	2$
2$:	setb	tm0dbg		; Enable
	ljmp	nomore
3$:	ljmp	badsyn
.endif	; tm0$tmr

.ifne	tm1$tmr
dbgtm1:	cjne	a,#1,1$		; Not X1 - skip
	clr	tm1xbt
	sjmp	2$
1$:	cjne	a,#2,3$		; Not X2 - Error
	setb	tm1xbt
;	sjmp	2$
2$:	setb	tm1dbg		; Enable
	ljmp	nomore
3$:	ljmp	badsyn
.endif	; tm1$tmr

.ifne	tm2$tmr
dbgtm2:	cjne	a,#1,1$		; Not X1 - skip
	clr	tm2xbt
	sjmp	2$
1$:	cjne	a,#2,3$		; Not X2 - Error
	setb	tm2xbt
;	sjmp	2$
2$:	setb	tm2dbg		; Enable
	ljmp	nomore
3$:	ljmp	badsyn
.endif	; tm2$tmr

  .endif; tmr$tmr
.endif	; tmr$dbg
;
;****************************************************************************

.endif	; .else of _timers

	.end



