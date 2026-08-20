	.title	TMS370 Test

	M  = 0x55
	MM = 0x1234

	.ifdef	XTRNL
	  .define	N,"(M + xa)"
	  .define	NN,"(MM + xa)"
	  .define	BIT0,"0 + xa"
	  .define	BIT1,"1 + xa"
	  .define	BIT2,"2 + xa"
	  .define	BIT3,"3 + xa"
	  .define	BIT4,"4 + xa"
	  .define	BIT5,"5 + xa"
	  .define	BIT6,"6 + xa"
	  .define	BIT7,"7 + xa"
	  .define	dot,"(. + xa)"
	  .define	label,"(0x1000 + a0x20 + xa)"
	.else
	  .define	N,"M"
	  .define	NN,"MM"
	  .define	BIT0,"0"
	  .define	BIT1,"1"
	  .define	BIT2,"2"
	  .define	BIT3,"3"
	  .define	BIT4,"4"
	  .define	BIT5,"5"
	  .define	BIT6,"6"
	  .define	BIT7,"7"
	  .define	dot,"."
	  .define	label,"(0x1000 + a0x20)"
	.endif

	.globl	xa

	jmp	dot		; 00 FE
	jn	dot		; 01 FE
	jz	dot		; 02 FE
	jc	dot		; 03 FE
	jp	dot		; 04 FE
	jpz	dot		; 05 FE
	jnz	dot		; 06 FE
	jnc	dot		; 07 FE
	jv	dot		; 08 FE
	jl	dot		; 09 FE
	jle	dot		; 0A FE
	jhs	dot		; 0B FE
	jnv	dot		; 0C FE
	jge	dot		; 0D FE
	jg	dot		; 0E FE
	jlo	dot		; 0F FE

a0x20:	jeq	dot		; 02 FE
	jne	dot		; 06 FE

	; Invalid Opcode	; 10
	; Invalid Opcode	; 11
	mov	r16,a		; 12 10
	and	r16,a		; 13 10
	or	r16,a		; 14 10
	xor	r16,a		; 15 10
	btjo	r16,a,	dot	; 16 10 FD
	btjz	r16,a,	dot	; 17 10 FD
	add	r16,a		; 18 10
	adc	r16,a		; 19 10
	sub	r16,a		; 1A 10
	sbb	r16,a		; 1B 10
	mpy	r16,a		; 1C 10
	cmp	r16,a		; 1D 10
	dac	r16,a		; 1E 10
	dsb	r16,a		; 1F 10

	; Invalid Opcode	; 20
	mov	a,p16		; 21 10
	mov	#N,a		; 22 55
	and	#N,a		; 23 55
	or	#N,a		; 24 55
	xor	#N,a		; 25 55
	btjo	#N,a,	dot	; 26 55 FD
	btjz	#N,a,	dot	; 27 55 FD
	add	#N,a		; 28 55
	adc	#N,a		; 29 55
	sub	#N,a		; 2A 55
	sbb	#N,a		; 2B 55
	mpy	#N,a		; 2C 55
	cmp	#N,a		; 2D 55
	dac	#N,a		; 2E 55
	dsb	#N,a		; 2F 55

	; Invalid Opcode	; 30
	; Invalid Opcode	; 31
	mov	r16,b		; 32 10
	and	r16,b		; 33 10
	or	r16,b		; 34 10
	xor	r16,b		; 35 10
	btjo	r16,b,	dot	; 36 10 FD
	btjz	r16,b,	dot	; 37 10 FD
	add	r16,b		; 38 10
	adc	r16,b		; 39 10
	sub	r16,b		; 3A 10
	sbb	r16,b		; 3B 10
	mpy	r16,b		; 3C 10
	cmp	r16,b		; 3D 10
	dac	r16,b		; 3E 10
	dsb	r16,b		; 3F 10

	; Invalid Opcode	; 40
	; Invalid Opcode	; 41
	mov	r16,r32		; 42 10 20
	and	r16,r32		; 43 10 20
	or	r16,r32		; 44 10 20
	xor	r16,r32		; 45 10 20
	btjo	r16,r32,dot	; 46 10 20 FC
	btjz	r16,r32,dot	; 47 10 20 FC
	add	r16,r32		; 48 10 20
	adc	r16,r32		; 49 10 20
	sub	r16,r32		; 4A 10 20
	sbb	r16,r32		; 4B 10 20
	mpy	r16,r32		; 4C 10 20
	cmp	r16,r32		; 4D 10 20
	dac	r16,r32		; 4E 10 20
	dsb	r16,r32		; 4F 10 20

	; Invalid Opcode	; 50
	mov	b,p16		; 51 10
	mov	#N,b		; 52 55
	and	#N,b		; 53 55
	or	#N,b		; 54 55
	xor	#N,b		; 55 55
	btjo	#N,b,	dot	; 56 55 FD
	btjz	#N,b,	dot	; 57 55 FD
	add	#N,b		; 58 55
	adc	#N,b		; 59 55
	sub	#N,b		; 5A 55
	sbb	#N,b		; 5B 55
	mpy	#N,b		; 5C 55
	cmp	#N,b		; 5D 55
	dac	#N,b		; 5E 55
	dsb	#N,b		; 5F 55

	; Invalid Opcode	; 60
	; Invalid Opcode	; 61
	mov	b,a		; 62
	and	b,a		; 63
	or	b,a		; 64
	xor	b,a		; 65
	btjo	b,a,	dot	; 66 FE
	btjz	b,a,	dot	; 67 FE
	add	b,a		; 68
	adc	b,a		; 69
	sub	b,a		; 6A
	sbb	b,a		; 6B
	mpy	b,a		; 6C
	cmp	b,a		; 6D
	dac	b,a		; 6E
	dsb	b,a		; 6F

	incw	#N,r32		; 70 55 20
	mov	r32,p16		; 71 10 20
	mov	#N,r32		; 72 55 20
	and	#N,r32		; 73 55 20
	or	#N,r32		; 74 55 20
	xor	#N,r32		; 75 55 20
	btjo	#N,r32,	dot	; 76 55 20 FC
	btjz	#N,r32,	dot	; 77 55 20 FC
	add	#N,r32		; 78 55 20
	adc	#N,r32		; 79 55 20
	sub	#N,r32		; 7A 55 20
	sbb	#N,r32		; 7B 55 20
	mpy	#N,r32		; 7C 55 20
	cmp	#N,r32		; 7D 55 20
	dac	#N,r32		; 7E 55 20
	dsb	#N,r32		; 7F 55 20

	mov	p16,a		; 80 10
	; Invalid Opcode	; 81
	; Invalid Opcode	; 82
	and	a,p32		; 83 20
	or	a,p32		; 84 20
	xor	a,p32		; 85 20
	btjo	a,p32,	dot	; 86 20 FD
	btjz	a,p32,	dot	; 87 20 FD
	movw	#NN,r16		; 88 12 34 10
	jmpl	dot		; 89 FF FD
	;
	jmpl	*NN		; 89 12 34
	;
	mov	label,a		; 8A 10 20
	mov	a,label		; 8B 10 20
	br	label		; 8C 10 20
	cmp	label,a		; 8D 10 20
	call	label		; 8E 10 20
	callr	dot		; 8F FF FD
	;
	callr	*NN		; 8F 12 34
	;

	; Invalid Opcode	; 90
	mov	p16,b		; 91 10
	; Invalid Opcode	; 92
	and	b,p32		; 93 20
	or	b,p32		; 94 20
	xor	b,p32		; 95 20
	btjo	b,p32,	dot	; 96 20 FD
	btjz	b,p32,	dot	; 97 20 FD
	movw	r32,r16		; 98 20 10
	jmpl	@r48		; 99 30
	mov	@r32,a		; 9A 20
	mov	a,@r48		; 9B 30
	br	@r64		; 9C 40
	cmp	@r32,a		; 9D 20
	call	@r48		; 9E 30
	callr	@r16		; 9F 10

	; Invalid Opcode	; A0
	; Invalid Opcode	; A1
	mov	p16,r32		; A2 20 10
	and	#N,p32		; A3 55 20
	or	#N,p32		; A4 55 20
	xor	#N,p32		; A5 55 20
	btjo	#N,p32,	dot	; A6 55 20 FC
	btjz	#N,p32,	dot	; A7 55 20 FC
	movw	#NN(b),r16	; A8 12 34 10
	jmpl	dot(b)		; A9 FF FD
	;
	jmpl	1$(b)		; A9 00 00
1$:	jmpl	*NN(b)		; A9 12 34
	;
	mov	label(b),a	; AA 10 20
	mov	a,label(b)	; AB 10 20
	br	label(b)	; AC 10 20
	cmp	label(b),a	; AD 10 20
	call	label(b)	; AE 10 20
	callr	dot(b)		; AF FF FD
	;
	callr	2$(b)		; AF 00 00
2$:	callr	*NN(b)		; AF 12 34
	;

	clrc			; B0
	; Invalid Opcode	; B1
	dec	a		; B2
	inc	a		; B3
	inv	a		; B4
	clr	a		; B5
	xchb	a		; B6
	swap	a		; B7
	push	a		; B8
	pop	a		; B9
	djnz	a,	dot	; BA FE
	compl	a		; BB
	rr	a		; BC
	rrc	a		; BD
	rl	a		; BE
	rlc	a		; BF

	mov	a,b		; C0
	; Invalid Opcode	; C1
	dec	b		; C2
	inc	b		; C3
	inv	b		; C4
	clr	b		; C5
	xchb	b		; C6
	swap	b		; C7
	push	b		; C8
	pop	b		; C9
	djnz	b,	dot	; CA FE
	compl	b		; CB
	rr	b		; CC
	rrc	b		; CD
	rl	b		; CE
	rlc	b		; CF

	mov	a,r16		; D0 10
	mov	b,r32		; D1 20
	dec	r16		; D2 10
	inc	r16		; D3 10
	inv	r16		; D4 10
	clr	r16		; D5 10
	xchb	r16		; D6 10
	swap	r16		; D7 10
	push	r16		; D8 10
	pop	r16		; D9 10
	djnz	r16,	dot	; DA 10 FD
	compl	r16		; DB 10
	rr	r16		; DC 10
	rrc	r16		; DD 10
	rl	r16		; DE 10
	rlc	r16		; DF 10

	trap	15		; E0
	trap	14		; E1
	trap	13		; E2
	trap	12		; E3
	trap	11		; E4
	trap	10		; E5
	trap	9		; E6
	trap	8		; E7
	trap	7		; E8
	trap	6		; E9
	trap	5		; EA
	trap	4		; EB
	trap	3		; EC
	trap	2		; ED
	trap	1		; EE
	trap	xa		; EF

	ldst	N		; F0 55
	mov	N(sp),a		; F1 55
	mov	a,N(sp)		; F2 55
	cmp	N(sp),a		; F3 55

	movw	N(r16),r32	; F4 E8 55 10 20
	jmpl	N(r48)		; F4 E9 55 30
	mov	N(r64),a	; F4 EA 55 40
	mov	a,N(r80)	; F4 EB 55 50
	br	N(r96)		; F4 EC 55 60
	cmp	N(r112),a	; F4 ED 55 70
	call	N(r128)		; F4 EE 55 80
	callr	N(r144)		; F4 EF 55 90
	div	r160,a		; F4 F8 A0

	; Invalid Opcode	; F5
	idle			; F6
	mov	#N,p32		; F7 55 20
	setc			; F8
	rts			; F9
	rti			; FA
	push	st		; FB
	pop	st		; FC
	ldsp			; FD
	stsp			; FE
	nop			; FF

	;
	; Other Instructions
	;

	div	r32,a		; F4 F8 20

	;
	; Derived Instructions
	;

	sbit0	BIT7,r16	; 73 7F 10
	sbit1	BIT6,r15	; 74 40 0F
	cmpbit	BIT5,r14	; 75 20 0E
	jbit1	BIT4,r13,dot	; 76 10 0D FC
	jbit0	BIT3,r12,dot	; 77 08 0C FC

	sbit0	BIT0,p8		; A3 FE 08
	sbit1	BIT1,p9		; A4 02 09
	cmpbit	BIT2,p10	; A5 04 0A
	jbit1	BIT3,p11,dot	; A6 08 0B FC
	jbit0	BIT4,p12,dot	; A7 10 0C FC

	;
	; Madeup Instruction(s)
	;
	.define	SETBIT	"sbit1"
	.define	THEBIT	"BIT0,r7"
 
	SETBIT	THEBIT		; 74 01 07

	;
	; Macro Instructions
	; Replace Existing Instructions
	;

	.macro	sbit1	arg1,arg2
	  .list	(!,mel,cyc)
	  or	#(1 << ((arg1) & 7)),arg2
	.endm

	; sbit1 - Macro Machine Mnemonic
	sbit1	^?BIT7?,p8	; A4 80 08

	.mdelete sbit1		; Delete Macro

	; sbit1 - Machine Mnemonic
	sbit1	BIT7,p8		; A4 80 08

	; sbit1 - Long Form
	or	#(1 << ((BIT7) & 7)),p8	;

