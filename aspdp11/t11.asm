	.title	PDP-11 Instruction Tests

	.radix	q

	.globl	XA	; An External Address

 	X = 0q001001	; byte form = 001 002
	Y = 0q002002	; byte form = 002 004

	.area	CODE

	.sbttl	.enabl and .dsabl Directives

	.enabl	(fpt,ama,smi,awg,rtyp)
	.dsabl	(fpt,ama,smi,awg,rtyp)

	.enabl	(rtyp)


	.page
	.sbttl	Instruction Immediate Radix Options

	mov	#^B01001001,r0	; 300 025 111 000
	mov	#^O111,r0	; 300 025 111 000
	mov	#^D73,r0	; 300 025 111 000
	mov	#^X49,r0	; 300 025 111 000
	mov	#^X41+10,r0	; 300 025 111 000
	mov	#^X(41+8),r0	; 300 025 111 000

	mov	#^B 01001001,r0	; 300 025 111 000
	mov	#^O 111,r0	; 300 025 111 000
	mov	#^D 73,r0	; 300 025 111 000
	mov	#^X 49,r0	; 300 025 111 000
	mov	#^X 41+10,r0	; 300 025 111 000
	mov	#^X (41+8),r0	; 300 025 111 000
	; **********
	mov	#^C^B01001001,r0	; 300 025 266 377
	mov	#^C^O111,r0		; 300 025 266 377
	mov	#^C^D73,r0		; 300 025 266 377
	mov	#^C^X49,r0		; 300 025 266 377
	mov	#^C(^X41+10),r0		; 300 025 266 377
	mov	#^C^X(41+8),r0		; 300 025 266 377

	mov	#^C^B 01001001,r0	; 300 025 266 377
	mov	#^C^O 111,r0		; 300 025 266 377
	mov	#^C^D 73,r0		; 300 025 266 377
	mov	#^C^X 49,r0		; 300 025 266 377
	mov	#^C(^X 41+10),r0	; 300 025 266 377
	mov	#^C^X (41+8),r0		; 300 025 266 377
	; **********
	mov	#^C ^B01001001,r0	; 300 025 266 377
	mov	#^C ^O111,r0		; 300 025 266 377
	mov	#^C ^D73,r0		; 300 025 266 377
	mov	#^C ^X49,r0		; 300 025 266 377
	mov	#^C (^X41+10),r0	; 300 025 266 377
	mov	#^C ^X(41+8),r0		; 300 025 266 377

	mov	#^C ^B 01001001,r0	; 300 025 266 377
	mov	#^C ^O 111,r0		; 300 025 266 377
	mov	#^C ^D 73,r0		; 300 025 266 377
	mov	#^C ^X 49,r0		; 300 025 266 377
	mov	#^C (^X 41+10),r0	; 300 025 266 377
	mov	#^C ^X (41+8),r0	; 300 025 266 377
	; **********
	mov	#^XFF,r0		; 300 025 377 000
	mov	#^X FF,r0		; 300 025 377 000
	mov	#^XDFF,r0		; 300 025 377 015
	mov	#^X DFF,r0		; 300 025 377 015


	.page
	.sbttl	.word Radix Options

	.word	#^B01001001	; 111 000
	.word	#^O111		; 111 000
	.word	#^D73		; 111 000
	.word	#^X49		; 111 000
	.word	#^X41+10	; 111 000
	.word	#^X(41+8)	; 111 000

	.word	#^B 01001001	; 111 000
	.word	#^O 111		; 111 000
	.word	#^D 73		; 111 000
	.word	#^X 49		; 111 000
	.word	#^X 41+10	; 111 000
	.word	#^X (41+8)	; 111 000
	; **********
	.word	#^C^B01001001	; 266 377
	.word	#^C^O111	; 266 377
	.word	#^C^D73		; 266 377
	.word	#^C^X49		; 266 377
	.word	#^C(^X41+10)	; 266 377
	.word	#^C^X(41+8)	; 266 377

	.word	#^C^B 01001001	; 266 377
	.word	#^C^O 111	; 266 377
	.word	#^C^D 73	; 266 377
	.word	#^C^X 49	; 266 377
	.word	#^C(^X 41+10)	; 266 377
	.word	#^C^X (41+8)	; 266 377
	; **********
	.word	#^C ^B01001001	; 266 377
	.word	#^C ^O111	; 266 377
	.word	#^C ^D73	; 266 377
	.word	#^C ^X49	; 266 377
	.word	#^C (^X41+10)	; 266 377
	.word	#^C ^X(41+8)	; 266 377

	.word	#^C ^B 01001001	; 266 377
	.word	#^C ^O 111	; 266 377
	.word	#^C ^D 73	; 266 377
	.word	#^C ^X 49	; 266 377
	.word	#^C (^X 41+10)	; 266 377
	.word	#^C ^X (41+8)	; 266 377
	; **********
	.word	^XFF		; 377 000
	.word	^X FF		; 377 000
	.word	^XDFF		; 377 015
	.word	^X DFF		; 377 015


	.page
	.sbttl	RAD50 Directive

	.rad50	^/A/		; 100 006
	.rad50	^/A /		; 100 006
	.rad50	^/A  /		; 100 006

	.rad50	^/(1)/		; 100 006
	.rad50	^/(1) /		; 100 006
	.rad50	^/(1)  /	; 100 006

	.rad50	^/  A/		; 001 000
	.rad50	^/ A /		; 050 000
	.rad50	^/A  /		; 100 006

	.rad50	^/  (1)/	; 001 000
	.rad50	^/ (1) /	; 050 000
	.rad50	^/(1)  /	; 100 006

	.rad50	^/ABC/		; 223 006
	.rad50	^/(1)(2)(1+2)/	; 223 006

	.rad50	^/ABCABC/	; 223 006 223 006
	.rad50	^/ABCAB/	; 223 006 220 006
	.rad50	^/ABCA/		; 223 006 100 006
 
	.rad50	^/ABC/,	^/(1)/	; 223 006 100 006
	.rad50	^/ABC/	^/(1)/	; 223 006 100 006

	; **********

	.rad50	/A/		; 100 006
	.rad50	/A /		; 100 006
	.rad50	/A  /		; 100 006

	.rad50	/(1)/		; 100 006
	.rad50	/(1) /		; 100 006
	.rad50	/(1)  /		; 100 006

	.rad50	/  A/		; 001 000
	.rad50	/ A /		; 050 000
	.rad50	/A  /		; 100 006

	.rad50	/  (1)/		; 001 000
	.rad50	/ (1) /		; 050 000
	.rad50	/(1)  /		; 100 006

	.rad50	/ABC/		; 223 006
	.rad50	/(1)(2)(1+2)/	; 223 006

	.rad50	/ABCABC/	; 223 006 223 006
	.rad50	/ABCAB/		; 223 006 220 006
	.rad50	/ABCA/		; 223 006 100 006
 
	.rad50	/ABC/,	/(1)/	; 223 006 100 006
	.rad50	/ABC/	/(1)/	; 223 006 100 006


	.page
	.sbttl	Instruction Immediate RAD50 Options

	mov	#^R^/ B(3)/,r0	; 300 025 123 000
	mov	#^R/ B(3)/,r0	; 300 025 123 000
	mov	#^R B(3),r0	; 300 025 123 000

	mov	#^R^/ B(1+2)/,r0; 300 025 123 000
	mov	#^R/ B(1+2)/,r0	; 300 025 123 000
	mov	#^R B(1+2),r0	; 300 025 123 000

	mov	#^R^/ BC/,r0	; 300 025 123 000
	mov	#^R/ BC/,r0	; 300 025 123 000
	mov	#^R BC,r0	; 300 025 123 000

	mov	#^R^/ABC/,r0	; 300 025 223 006
	mov	#^R/ABC/,r0	; 300 025 223 006
	mov	#^RABC,r0	; 300 025 223 006
 

	.page
	.sbttl	Double Operand Type

	mov	r0,r0		; 000 020
	mov	r0,(r0)		; 010 020
	mov	r0,(r0)+	; 020 020
	mov	r0,@(r0)+	; 030 020
	mov	r0,-(r0)	; 040 020
	mov	r0,@-(r0)	; 050 020
	mov	r0,X(r0)	; 060 020 001 002
	mov	r0,@X(r0)	; 070 020 001 002
	mov	r0,@(r0)	; 070 020 000 000

	mov	r0,r0		; 000 020
	mov	(r0),r0		; 000 022
	mov	(r0)+,r0	; 000 024
	mov	@(r0)+,r0	; 000 026
	mov	-(r0),r0	; 000 030
	mov	@-(r0),r0	; 000 032
	mov	X(r0),r0	; 000 034 001 002
	mov	@X(r0),r0	; 000 036 001 002
	mov	@(r0),r0	; 000 036 000 000

	; Alternate Indirects

	mov	r0,@r0		; 010 020
	mov	r0,@r0+		; 020 020
	mov	@r0,r0		; 000 022
	mov	@r0+,r0		; 000 024

	; Register Alternates

	mov	%0,@r0		; 010 020
	mov	%0,@r0+		; 020 020
	mov	@%0,r0		; 000 022
	mov	@%0+,r0		; 000 024

	; Operands With Constants and Addresses

	mov	#Y,r1		; 301 025 002 004
	mov	r1,@#X		; 137 020 001 002
	mov	#Y,@#X		; 337 025 002 004
				; 001 002

	.page
	.sbttl	Single Operand Type

	tst	r0		; 300 013
	tst	(r0)		; 310 013
	tst	(r0)+		; 320 013
	tst	@(r0)+		; 330 013
	tst	-(r0)		; 340 013
	tst	@-(r0)		; 350 013
	tst	X(r0)		; 360 013 001 002
	tst	@X(r0)		; 370 013 001 002
	tst	@(r0)		; 370 013 000 000

	; Alternate Indirects

	tst	@r0		; 310 013
	tst	@r0+		; 320 013

	; Register Alternates

	tst	@%0		; 310 013
	tst	@%0+		; 320 013

	; Operands With Addresses

	tst	.		; 367 013 374 377


	.page
	.sbttl	Basic Instructions

	adc	r1		; 101 013
	adcb	r2		; 102 213

	add	r1,r2		; 102 140

	asl	r1		; 301 014
	aslb	r2		; 302 214

	asr	r3		; 203 014
	asrb	r4		; 204 214

	bcc	.		; 377 206
	bcs	.		; 377 207
	beq	.		; 377 003
	bge	.		; 377 004
	bgt	.		; 377 006
	bhi	.		; 377 202
	bhis	.		; 377 206

	bic	r1,r2		; 102 100
	bicb	r3,r4		; 304 300

	bis	r1,r2		; 102 120
	bisb	r3,r4		; 304 320

	bit	r1,r2		; 102 060
	bitb	r3,r4		; 304 260

	ble	.		; 377 007
	blo	.		; 377 207
	blos	.		; 377 203
	blt	.		; 377 005
	bmi	.		; 377 201
	bne	.		; 377 002
	bpl	.		; 377 200

	bpt			; 003 000

	br	.		; 377 001
	bvc	.		; 377 204
	bvs	.		; 377 205

	ccc			; 257 000
	clc			; 241 000
	cln			; 250 000
	clv			; 242 000
	clz			; 244 000

	cmp	r1,r2		; 102 040
	cmpb	r3,r4		; 304 240

	com	r1		; 101 012
	comb	r2		; 102 212

	dec	r1		; 301 012
	decb	r2		; 302 212

	emt	300		; 300 210

	halt			; 000 000

	inc	r1		; 201 012
	incb	r2		; 202 212

	iot			; 004 000

	jmp	@r1		; 111 000

	jsr	r1,@r2		; 112 010

	mark	#7		; 007 015

	mfpd	r1		; 101 215
	mfpi	r2		; 102 015

	mfps	r1		; 301 215
	mfpt			; 007 000

	mov	r1,r2		; 102 020
	movb	r3,r4		; 304 220

	mtpd	r1		; 201 215
	mtps	r2		; 002 215

	neg	r1		; 001 013
	negb	r2		; 002 213

	nop			; 240 000

	reset			; 005 000

	rol	r1		; 101 014
	rolb	r2		; 102 214

	ror	r1		; 001 014
	rorb	r2		; 002 214

	rti			; 002 000

	scc			; 277 000
	sec			; 261 000
	sen			; 270 000
	sev			; 262 000
	sez			; 264 000

	sob	r1,.		; 101 176

	spl	#5		; 235 000

	sub	r1,r2		; 102 340

	swab	r1		; 301 000

	sxt	r1		; 301 015

	tstset	r1		; 201 016

	trap	0300		; 300 211

	tst	r1		; 301 013
	tstb	r2		; 302 213

	wait			; 001 000

	wrtlck	r1		; 301 016

	xor	r1,r2		; 102 170


	.sbttl	EIS Instructions

	ash	.,r1		; 167 164 374 377
	ashc	.,r2		; 267 166 374 377
	div	.,r1		; 167 162 374 377
	mul	.,r2		; 267 160 374 377


	.sbttl	FIS Instructions

	fadd	r1		; 001 172
	fsub	r2		; 012 172
	fmul	r3		; 023 172
	fdiv	r4		; 034 172


	.sbttl	Single Precision  Floating Point Instructions

	absf	ac5		; 205 361
	absf	(r1)+		; 221 361

	addf	ac5,ac3		; 305 364
	addf	(r1)+,ac2	; 221 364

	cfcc			; 000 360

	clrf	ac5		; 005 361
	clrf	(r1)+		; 021 361

	cmpf	ac5,ac3		; 305 367
	cmpf	(r1)+,ac2	; 221 367

	divf	ac5,ac3		; 305 371
	divf	(r1)+,ac2	; 221 371

	ldcdf	ac5,ac3		; 305 377
	ldcdf	(r1)+,ac2	; 221 377

	ldcif	r5,ac3		; 305 376
	ldcif	(r1)+,ac2	; 221 376
	ldclf	r5,ac3		; 305 376
	ldclf	(r1)+,ac2	; 221 376

	ldexp	r5,ac3		; 305 375
	ldexp	(r1)+,ac2	; 221 375

	ldf	ac5,ac3		; 305 365
	ldf	(r1)+,ac2	; 221 365

	ldfps	r5		; 105 360
	ldfps	(r1)+		; 121 360

	modf	ac5,ac3		; 305 363
	modf	(r1)+,ac2	; 221 363

	mulf	ac5,ac3		; 305 362
	mulf	(r1)+,ac2	; 221 362

	negf	ac5		; 305 361
	negf	(r1)+		; 321 361

	setf			; 001 360
	setd			; 011 360
	seti			; 002 360
	setl			; 012 360

	stcfd	ac3,ac5		; 305 374
	stcfd	ac2,(r1)+	; 221 374

	stcfi	ac3,r5		; 305 373
	stcfi	ac2,(r1)+	; 221 373
	stcfl	ac3,r5		; 305 373
	stcfl	ac2,(r1)+	; 221 373

	stexp	ac3,r5		; 305 372
	stexp	ac2,(r1)+	; 221 372

	stfps	r3		; 203 360
	stfps	(r1)+		; 221 360

	stst	r3		; 303 360
	stst	(r1)+		; 321 360

	subf	ac5,ac3		; 305 366
	subf	(r1)+,ac2	; 221 366

	tstf	ac5		; 105 361
	tstf	(r1)+		; 121 361


	.sbttl	Double Precision  Floating Point Instructions

	absd	ac5		; 205 361
	absd	(r1)+		; 221 361

	addd	ac5,ac3		; 305 364
	addd	(r1)+,ac2	; 221 364

	clrd	ac5		; 005 361
	clrd	(r1)+		; 021 361

	cmpd	ac5,ac3		; 305 367
	cmpd	(r1)+,ac2	; 221 367

	divd	ac5,ac3		; 305 371
	divd	(r1)+,ac2	; 221 371

	ldcfd	ac5,ac3		; 305 377
	ldcfd	(r1)+,ac2	; 221 377

	ldcid	r5,ac3		; 305 376
	ldcid	(r1)+,ac2	; 221 376
	ldcld	r5,ac3		; 305 376
	ldcld	(r1)+,ac2	; 221 376

	ldd	ac5,ac3		; 305 365
	ldd	(r1)+,ac2	; 221 365

	modd	ac5,ac3		; 305 363
	modd	(r1)+,ac2	; 221 363

	muld	ac5,ac3		; 305 362
	muld	(r1)+,ac2	; 221 362

	negd	ac5		; 305 361
	negd	(r1)+		; 321 361

	stcdf	ac3,ac5		; 305 374
	stcdf	ac2,(r1)+	; 221 374

	stcdi	ac3,r5		; 305 373
	stcdi	ac2,(r1)+	; 221 373
	stcdl	ac3,r5		; 305 373
	stcdl	ac2,(r1)+	; 221 373

	subd	ac5,ac3		; 305 366
	subd	(r1)+,ac2	; 221 366

	tstd	ac5		; 105 361
	tstd	(r1)+		; 121 361

	.page
	.sbttl	.int32 and .int64 Constants

	.int32	0q000001	; 000 000 001 000
	.int32	0q100000	; 000 000 000 200
	.int32	0q177777	; 000 000 377 377
	.int32	0q200000	; 001 000 000 000
	.int32	0q377777	; 001 000 377 377
	.int32  0q400000	; 002 000 000 000
	.int32	0q20000000000	; 000 200 000 000
	.int32	0q37777777777	; 377 377 377 377

	.int32	-0q000001	; 377 377 377 377
	.int32	-0q100000	; 377 377 000 200
	.int32	-0q177777	; 377 377 001 000
	.int32	-0q200000	; 377 377 000 000
	.int32	-0q377777	; 376 377 001 000
	.int32  -0q400000	; 376 377 000 000
	.int32	-0q10000000000	; 000 300 000 000
	.int32	-0q17777777777	; 000 200 001 000

	.page
	.sbttl	16-Bit Floating Point Constants

	.flt1	00.00		; 000 000
   
	.flt1	10		; 040 102
	.flt1	10.		; 040 102
	.flt1	10.0		; 040 102
   
	.flt1	1		; 200 100
	.flt1	1.		; 200 100
	.flt1	1.0		; 200 100
   
	.flt1	.1		; 315 076
	.flt1	0.1		; 315 076
	.flt1	0.10		; 315 076
   
	.flt1	100.0		; 310 103
	.flt1	10.0		; 040 102
	.flt1	1.0		; 200 100
	.flt1	0.1		; 315 076
	.flt1	0.01		; 044 075

	.flt1	0.0		; 000 000
	.flt1	1		; 200 100

	.flt1	-100.0		; 310 303
	.flt1	-10.0		; 040 302
	.flt1	-1.0		; 200 300
	.flt1	-0.1		; 315 276
	.flt1	-0.01		; 044 275

	.flt1	-0.0		; 000 000
	.flt1	-1		; 200 300

	.flt1	1E0		; 200 100
	.flt1	1.E0		; 200 100
	.flt1	1.0E0		; 200 100
	.flt1	1.0E+0		; 200 100
   
	.flt1	100.0E-1	; 040 102
	.flt1	10.0E-0		; 040 102
	.flt1	1.0E+1		; 040 102
	.flt1	0.1E+2		; 040 102
	.flt1	0.01E+3		; 040 102

	.page

	.flt1	0.0		; 000 000
	.flt1	1.0		; 200 100
	.flt1	2.0		; 000 101
	.flt1	3.0		; 100 101
	.flt1	4.0		; 200 101
	.flt1	5.0		; 240 101
	.flt1	6.0		; 300 101
	.flt1	7.0		; 340 101
	.flt1	8.0		; 000 102
	.flt1	9.0		; 020 102

	.flt1	0.0		; 000 000
	.flt1	0.1		; 315 076
	.flt1	0.2		; 115 077
	.flt1	0.3		; 232 077
	.flt1	0.4		; 315 077
	.flt1	0.5		; 000 100
	.flt1	0.6		; 032 100
	.flt1	0.7		; 063 100
	.flt1	0.8		; 115 100
	.flt1	0.9		; 146 100

	.flt1	0.1111111111	; 344 076
	.flt1	0.2222222222	; 144 077
	.flt1	0.3333333333	; 253 077
	.flt1	0.4444444444	; 344 077
	.flt1	0.5555555555	; 016 100
	.flt1	0.6666666666	; 053 100
	.flt1	0.7777777777	; 107 100
	.flt1	0.8888888888	; 144 100
	.flt1	0.9999999999	; 200 100		; Rounded

	.enabl	(fpt)
	.flt1	0.9999999999	; 177 100		; Not Rounded
	.dsabl	(fpt)

	.page
	.sbttl	32-Bit Floating Point Constants

	.flt2	00.00		; 000 000 000 000
   
	.flt2	10		; 040 102 000 000
	.flt2	10.		; 040 102 000 000
	.flt2	10.0		; 040 102 000 000
   
	.flt2	1		; 200 100 000 000
	.flt2	1.		; 200 100 000 000
	.flt2	1.0		; 200 100 000 000
   
	.flt2	.1		; 314 076 315 314
	.flt2	0.1		; 314 076 315 314
	.flt2	0.10		; 314 076 315 314
   
	.flt2	100.0		; 310 103 000 000
	.flt2	10.0		; 040 102 000 000
	.flt2	1.0		; 200 100 000 000
	.flt2	0.1		; 314 076 315 314
	.flt2	0.01		; 043 075 012 327

	.flt2	0.0		; 000 000 000 000
	.flt2	1		; 200 100 000 000

	.flt2	-100.0		; 310 303 000 000
	.flt2	-10.0		; 040 302 000 000
	.flt2	-1.0		; 200 300 000 000
	.flt2	-0.1		; 314 276 315 314
	.flt2	-0.01		; 043 275 012 327

	.flt2	-0.0		; 000 000 000 000
	.flt2	-1		; 200 300 000 000

	.flt2	1E0		; 200 100 000 000
	.flt2	1.E0		; 200 100 000 000
	.flt2	1.0E0		; 200 100 000 000
	.flt2	1.0E+0		; 200 100 000 000
   
	.flt2	100.0E-1	; 040 102 000 000
	.flt2	10.0E-0		; 040 102 000 000
	.flt2	1.0E+1		; 040 102 000 000
	.flt2	0.1E+2		; 040 102 000 000
	.flt2	0.01E+3		; 040 102 000 000

	.page

	.flt2	0.0		; 000 000 000 000
	.flt2	1.0		; 200 100 000 000
	.flt2	2.0		; 000 101 000 000
	.flt2	3.0		; 100 101 000 000
	.flt2	4.0		; 200 101 000 000
	.flt2	5.0		; 240 101 000 000
	.flt2	6.0		; 300 101 000 000
	.flt2	7.0		; 340 101 000 000
	.flt2	8.0		; 000 102 000 000
	.flt2	9.0		; 020 102 000 000

	.flt2	0.0		; 000 000 000 000
	.flt2	0.1		; 314 076 315 314
	.flt2	0.2		; 114 077 315 314
	.flt2	0.3		; 231 077 232 231
	.flt2	0.4		; 314 077 315 314
	.flt2	0.5		; 000 100 000 000
	.flt2	0.6		; 031 100 232 231
	.flt2	0.7		; 063 100 063 063
	.flt2	0.8		; 114 100 315 314
	.flt2	0.9		; 146 100 146 146

	.flt2	0.1111111111	; 343 076 071 216
	.flt2	0.2222222222	; 143 077 071 216
	.flt2	0.3333333333	; 252 077 253 252
	.flt2	0.4444444444	; 343 077 071 216
	.flt2	0.5555555555	; 016 100 344 070
	.flt2	0.6666666666	; 052 100 253 252
	.flt2	0.7777777777	; 107 100 162 034
	.flt2	0.8888888888	; 143 100 071 216
	.flt2	0.9999999999	; 200 100 000 000	; Rounded

	.enabl	(fpt)
	.flt2	0.9999999999	; 177 100 377 377	; Not Rounded
	.dsabl	(fpt)

	.page

	.flt4	100.0		; 310 103 000 000
				; 000 000 000 000
	.flt4	10.0		; 040 102 000 000
				; 000 000 000 000
	.flt4	1.0		; 200 100 000 000
				; 000 000 000 000
	.flt4	0.1		; 314 076 314 314
				; 314 314 315 314
	.flt4	0.01		; 043 075 012 327
				; 160 075 327 243
	.flt4	0.0		; 000 000 000 000
				; 000 000 000 000
	.flt4	1		; 200 100 000 000
				; 000 000 000 000

	.flt4	-100.0		; 310 303 000 000
				; 000 000 000 000
	.flt4	-10.0		; 040 302 000 000
				; 000 000 000 000
	.flt4	-1.0		; 200 300 000 000
				; 000 000 000 000
	.flt4	-0.1		; 314 276 314 314
				; 314 314 315 314
	.flt4	-0.01		; 043 275 012 327
				; 160 075 327 243
	.flt4	-0.0		; 000 000 000 000
				; 000 000 000 000
	.flt4	-1		; 200 300 000 000
				; 000 000 000 000

	.page

	.flt4	1E0		; 200 100 000 000
				; 000 000 000 000
	.flt4	1.E0		; 200 100 000 000
				; 000 000 000 000
	.flt4	1.0E0		; 200 100 000 000
				; 000 000 000 000
	.flt4	1.0E+0		; 200 100 000 000
				; 000 000 000 000
 	.flt4	100.0E-1	; 040 102 000 000
				; 000 000 000 000
	.flt4	10.0E-0		; 040 102 000 000
				; 000 000 000 000
	.flt4	1.0E+1		; 040 102 000 000
				; 000 000 000 000
	.flt4	0.1E+2		; 040 102 000 000
				; 000 000 000 000
	.flt4	0.01E+3		; 040 102 000 000
				; 000 000 000 000

 	.flt4	0.99999999999999999999	; 200 100 000 000	; Rounded
					; 000 000 000 000

	.enabl	(fpt)
	.flt4	0.99999999999999999999	; 177 100 377 377	; Not Rounded
					; 377 377 377 377
	.dsabl	(fpt)

	.page
	.sbttl	Instructions With INT32, FLT32, INT64, Or FLT64 Constants

	; One Word Floating Point
	mov	#^F1.0,r0	; 300 025 200 100
	cmp	#^F1,#^F10E-1	; 327 045 200 100

	; S_FXXX
	tstf	#^F10.		; 127 361 040 102

	; D_FXXX
	tstd	#^F100.		; 127 361 310 103

	; S_SRCAC
	ldcif	#1,ac3		; 327 376 001 000

	ldclf	#1,ac2		; 227 376 001 000

	; S_ACDST (Self Modifying)
;	stcdi	ac3,#1		; 327 373 001 000

	; D_ACDST (Self Modifying)
;	stcdl	ac2,#1		; 227 373 000 000

	;S_ACFDST (Self Modifying)
;	stf	ac1,#0.1	; 127 370 314 076

 	;D_ACFDST (Self Modifying)
;	stcfd	ac0,#0.01	; 027 374 043 075

	;S_FSRCAC
	addf	#^F10.,ac3	; 327 364 040 102

	;D_FSRCAC
	cmpd	#^F100.,ac2	; 227 367 310 103

	.page
	.sbttl	Local Program Counter Addressing

.ifdef	.lst
	.bank	LOCAL (base=0600)
	.area	LOCAL (bank=LOCAL)

A:	mov	#A,r0		; 300 025r000s000
	mov	(pc)+,r0	; 300 025
	  .word	A		;r000s000

	mov	@#A,r0		; 300 027r000s000
	mov	@(pc)+,r0	; 300 027
	  .word	#A		;r000s000

	mov	A,r0		; 300 035 354 377
	mov	A(pc),r0	; 300 035r000s000

	mov	@A,r0		; 300 037 344 377
	mov	@A(pc),r0	; 300 037r000s000

	mov	#^R B(3),r0	; 300 025 123 000

	mov	r0,@#A		; 037 020r000s000
	mov	r0,@(pc)+	; 037 020
	  .word	#A		;r000s000

	mov	r0,A		; 067 020 320 377
	mov	r0,A(pc)	; 067 020r000s000

	mov	r0,@A		; 077 020 310 377
	mov	r0,@A(pc)	; 077 020r000s000

	.enabl	(ama)		; A and @A ==>> @#A

	mov	r0,A		; 037 020r000s000
	mov	r0,A(pc)	; 067 020r000s000

	.dsabl	(ama)

	mov	#^C1,r0		; 300 025 376 377
.endif

.ifdef	.rst
	.bank	LOCAL (base=0600)
	.area	LOCAL (bank=LOCAL)

A:	mov	#A,r0		; 300 025 200 001
	mov	(pc)+,r0	; 300 025
	  .word	A		; 200 001

	mov	@#A,r0		; 300 027 200 001
	mov	@(pc)+,r0	; 300 027
	  .word	#A		; 200 001

	mov	A,r0		; 300 035 354 377
	mov	A(pc),r0	; 300 035 200 001

	mov	@A,r0		; 300 037 344 377
	mov	@A(pc),r0	; 300 037 200 001

	mov	#^R B(3),r0	; 300 025 123 000

	mov	r0,@#A		; 037 020 200 001
	mov	r0,@(pc)+	; 037 020
	  .word	#A		; 200 001

	mov	r0,A		; 067 020 320 377
	mov	r0,A(pc)	; 067 020 200 001

	mov	r0,@A		; 077 020 310 377
	mov	r0,@A(pc)	; 077 020 200 001

	.enabl	(ama)		; A and @A ==>> @#A

	mov	r0,A		; 037 020 200 001
	mov	r0,A(pc)	; 067 020 200 001

	.dsabl	(ama)

	mov	#^C1,r0		; 300 025 376 377
.endif


	.page
	.sbttl	External Program Counter Addressing

.ifdef	.lst	; Values Before Linking
	.bank	XA (base=0000)
	.area	XA (bank=XA)

	mov	#XA,r0		; 300 025r000s000
	mov	(pc)+,r0	; 300 025
	  .word	XA		;r000s000

	mov	@#XA,r0		; 300 027r000s000
	mov	@(pc)+,r0	; 300 027
	  .word	#XA		;r000s000

	mov	XA,r0		; 300 035p000q000
	mov	XA(pc),r0	; 300 035r000s000

	mov	@XA,r0		; 300 037p000q000
	mov	@XA(pc),r0	; 300 037r000s000

	mov	#^RABC,r0	; 300 025 223 006
	mov	#^C2,r0		; 300 025 375 377

	mov	#^CXA,r0	; 300 025r000s000
	mov	#^C(XA),r0	; 300 025r000s000

	.word	#^CXA		;r000s000
	.word	#^C(XA)		;r000s000
.endif

.ifdef	.rst	; Values After Linking
	.bank	XA (base=0000)
	.area	XA (bank=XA)

	mov	#XA,r0		; 300 025r000s000
	mov	(pc)+,r0	; 300 025
	  .word	XA		;r000s000

	mov	@#XA,r0		; 300 027r000s000
	mov	@(pc)+,r0	; 300 027
	  .word	#XA		;r000s000

	mov	XA,r0		; 300 035 354 377
	mov	XA(pc),r0	; 300 035 000 000

	mov	@XA,r0		; 300 037 344 377
	mov	@XA(pc),r0	; 300 037 000 000

	mov	#^RABC,r0	; 300 025 223 006
	mov	#^C2,r0		; 300 025 375 377

	mov	#^CXA,r0	; 300 025r377s377
	mov	#^C(XA),r0	; 300 025r377s377

	.word	#^CXA		;r377s377
	.word	#^C(XA)		;r377s377
.endif


	.page
	.sbttl	LxDn Instructions

	l2dn	r0		; 020 174
	l2dn	r1		; 021 174
	l2dn	r2		; 022 174
	l2dn	r3		; 023 174
	l2dn	r4		; 024 174
	l2dn	r5		; 025 174
	l2dn	r6		; 026 174
	l2dn	r7		; 027 174

	l2d0			; 020 174
	l2d1			; 021 174
	l2d2			; 022 174
	l2d3			; 023 174
	l2d4			; 024 174
	l2d5			; 025 174
	l2d6			; 026 174
	l2d7			; 027 174

	l3dn	r0		; 060 174
	l3dn	r1		; 061 174
	l3dn	r2		; 062 174
	l3dn	r3		; 063 174
	l3dn	r4		; 064 174
	l3dn	r5		; 065 174
	l3dn	r6		; 066 174
	l3dn	r7		; 067 174

	l3d0			; 060 174
	l3d1			; 061 174
	l3d2			; 062 174
	l3d3			; 063 174
	l3d4			; 064 174
	l3d5			; 065 174
	l3d6			; 066 174
	l3d7			; 067 174

	.page
	.sbttl	Unix V7 Assembler Alternate Instruction Mnemonics

	.area	CODE

	bec	.		; 377 206	; bcc	.
	bes	.		; 377 207	; bcs	.

	als	r1,.		; 167 164 374 377	; ash	r1,.
	alsc	r2,.		; 267 166 374 377	; ashc	r2,.
	dvd	.,r1		; 167 162 374 377	; div	.,r1
	mpy	.,r1		; 167 160 374 377	; mul	.,r1

	movf	(r0),ac1	; 110 365	; ldf	(r0),ac1
	movf	ac2,(r0)+	; 220 370	; stf	ac2,(r0)+
	movf	ac1,ac2		; 102 370	; stf	ac1,ac2
	movf	ac4,ac1		; 104 365	; ldf	ac4,ac1
	movf	ac2,ac5		; 205 370	; stf	ac2,ac5

	movif	r5,ac3		; 305 376	; ldcif	r5,ac3
	movfi	ac3,r5		; 305 373	; stcfi	ac3,r5
	movof	ac5,ac3		; 305 377 	; ldcdf	ac5,ac3
	movfo	ac3,ac5		; 305 374	; stcdf	ac3,ac5
	movie	r5,ac3		; 305 375	; ldexp	r5,ac3
	movei	ac3,r5		; 305 372	; stexp	ac3,r5

	.page

.ifdef	.lst
 	.bank	JA (base=0400)
	.area	JA (bank=JA)

JA:	jbr	JA		; 377 001		; br	JA
	.blkw	0d126
	jbr	JA		; 200 001		; br	JA
	jbr	JA		; 167 000 374 376	; jmp	JA 
	jbr	JB		; 167 000p000q000	; jmp	@#JB
	jbr	XA		; 167 000p000q000	; jmp	@#XA

	.bank	JB (base=01000)
	.area	JB (bank=JB)

JB:	jbr	JB		; 377 001		; br	JB
	.blkw	0d126
	jeq	JB		; 200 003		; beq	JB
	jeq	JB		; 002 002 167 000	; bne	.+2  /  jmp   JB	; 372 376
	jeq	JA		; 002 002 167 000	; bne	.+2  /  jmp   @#JA	;p000q000
	jeq	XA		; 002 002 167 000	; bne	.+2  /  jmp   @#XA	;p000q000
.endif

.ifdef	.rst
 	.bank	JA (base=0400)
	.area	JA (bank=JA)

JA:	jbr	JA		; 377 001		; br	JA
	.blkw	0d126
	jbr	JA		; 200 001		; br	JA
	jbr	JA		; 167 000 374 376	; jmp	JA 
	jbr	JB		; 167 000 370 377	; jmp	JB
	jbr	XA		; 167 000 364 375	; jmp	XA

	.bank	JB (base=01000)
	.area	JB (bank=JB)

JB:	jbr	JB		; 377 001		; br	JB
	.blkw	0d126
	jeq	JB		; 200 003		; beq	JB
	jeq	JB		; 002 002 167 000	; bne	.+2  /  jmp   JB	; 372 376
	jeq	JA		; 002 002 167 000	; bne	.+2  /  jmp   JA	; 366 375
	jeq	XA		; 002 002 167 000	; bne	.+2  /  jmp   XA	; 360 374
.endif

	.end
