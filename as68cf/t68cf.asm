	.title	AS68CF Assembler Test

	; BLDT68CF Macro Definitions Loaded

	.area	B	(abs,ovr)	; External Labels Area
	.org	0

	.globl	xb, xw, xl

	.define barg ^/(xb+0x12)/	; Externals Plus A Constant
	.define	warg ^/(xw+0x1234)/
	.define	larg ^/(xl+0x12345678)/

	.area	A	(abs,ovr)	; Main Coding Area
	.org	0

	.enabl	(alt)		; Allow Alternate Instructions
	.enabl	(flt)		; Enable Coldfire Floating Point

	.sbttl	Type S_TYP1 Instructions: ABCD, SBCD, ADDX, SUBX

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_TYP1:						*
	;*	ADDX, SUBX					*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	addx	D7,D2			; D5 87

	addx.l	D7,D2			; D5 87

	subx	D7,D2			; 95 87

	subx.l	D7,D2			; 95 87

	.sbttl	Type S_TYP2 Instructions: ADD, AND, OR, SUB

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_TYP2:						*
	;*	ADD, AND, OR, SUB				*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	add	D7,D0			; D0 87
	add	A0,D1			; D2 88
	add	(A1),D2			; D4 91
	add	(A2)+,D3		; D6 9A
	add	-(A3),D4		; D8 A3
	add	1(A4),D5		; DA AC 00 01
	add	2(A5,D7.W),D6		; DC B5 70 02
	add	2(A5,D7.L),D6		; DC B5 78 02
	add	*0xFFFFFFF0,D3		; D6 B8 FF F0
	add	 0x00010004,D3		; D6 B9 00 01 00 04
	add	5(PC),D4		; D8 BA 00 03
	add	6(PC,A7.W),D5		; DA BB F0 04
	add	6(PC,A7.L),D5		; DA BB F8 04
	add	#7,D6			; 5E 86
	add	#9,D6			; 06 86 00 00 00 09

	add	D0,D7			; DE 80
	add	D1,A0			; D1 C1
	add	D2,(A1)			; D5 91
	add	D3,(A2)+		; D7 9A
	add	D4,-(A3)		; D9 A3
	add	D5,1(A4)		; DB AC 00 01
	add	D6,2(A5,D7.W)		; DD B5 70 02
	add	D6,2(A5,D7.L)		; DD B5 78 02
	add	D3,*0xFFFFFFF0		; D7 B8 FF F0
	add	D3, 0x00010004		; D7 B9 00 01 00 04

	add.l	D7,D0			; D0 87
	add.l	A0,D1			; D2 88
	add.l	(A1),D2			; D4 91
	add.l	(A2)+,D3		; D6 9A
	add.l	-(A3),D4		; D8 A3
	add.l	1(A4),D5		; DA AC 00 01
	add.l	2(A5,D7.W),D6		; DC B5 70 02
	add.l	2(A5,D7.L),D6		; DC B5 78 02
	add.l	*0xFFFFFFF0,D3		; D6 B8 FF F0
	add.l	 0x00010004,D3		; D6 B9 00 01 00 04
	add.l	5(PC),D4		; D8 BA 00 03
	add.l	6(PC,A7.W),D5		; DA BB F0 04
	add.l	6(PC,A7.L),D5		; DA BB F8 04
	add.l	#7,D6			; 5E 86
	add.l	#9,D6			; 06 86 00 00 00 09

	add.l	D0,D7			; DE 80
	add.l	D1,A0			; D1 C1
	add.l	D2,(A1)			; D5 91
	add.l	D3,(A2)+		; D7 9A
	add.l	D4,-(A3)		; D9 A3
	add.l	D5,1(A4)		; DB AC 00 01
	add.l	D6,2(A5,D7.W)		; DD B5 70 02
	add.l	D6,2(A5,D7.L)		; DD B5 78 02
	add.l	D3,*0xFFFFFFF0		; D7 B8 FF F0
	add.l	D3, 0x00010004		; D7 B9 00 01 00 04

	and	D7,D0			; C0 87
	and	(A1),D2			; C4 91
	and	(A2)+,D3		; C6 9A
	and	-(A3),D4		; C8 A3
	and	1(A4),D5		; CA AC 00 01
	and	2(A5,D7.W),D6		; CC B5 70 02
	and	2(A5,D7.L),D6		; CC B5 78 02
	and	*0xFFFFFFF0,D3		; C6 B8 FF F0
	and	 0x00010004,D3		; C6 B9 00 01 00 04
	and	5(PC),D4		; C8 BA 00 03
	and	6(PC,A7.W),D5		; CA BB F0 04
	and	6(PC,A7.L),D5		; CA BB F8 04
	and	#7,D6			; 02 86 00 00 00 07
	and	#9,D6			; 02 86 00 00 00 09

	and	D0,D7			; CE 80
	and	D2,(A1)			; C5 91
	and	D3,(A2)+		; C7 9A
	and	D4,-(A3)		; C9 A3
	and	D5,1(A4)		; CB AC 00 01
	and	D6,2(A5,D7.W)		; CD B5 70 02
	and	D6,2(A5,D7.L)		; CD B5 78 02
	and	D3,*0xFFFFFFF0		; C7 B8 FF F0
	and	D3, 0x00010004		; C7 B9 00 01 00 04

	and.l	D7,D0			; C0 87
	and.l	(A1),D2			; C4 91
	and.l	(A2)+,D3		; C6 9A
	and.l	-(A3),D4		; C8 A3
	and.l	1(A4),D5		; CA AC 00 01
	and.l	2(A5,D7.W),D6		; CC B5 70 02
	and.l	2(A5,D7.L),D6		; CC B5 78 02
	and.l	*0xFFFFFFF0,D3		; C6 B8 FF F0
	and.l	 0x00010004,D3		; C6 B9 00 01 00 04
	and.l	5(PC),D4		; C8 BA 00 03
	and.l	6(PC,A7.W),D5		; CA BB F0 04
	and.l	6(PC,A7.L),D5		; CA BB F8 04
	and.l	#7,D6			; 02 86 00 00 00 07
	and.l	#9,D6			; 02 86 00 00 00 09

	and.l	D0,D7			; CE 80
	and.l	D2,(A1)			; C5 91
	and.l	D3,(A2)+		; C7 9A
	and.l	D4,-(A3)		; C9 A3
	and.l	D5,1(A4)		; CB AC 00 01
	and.l	D6,2(A5,D7.W)		; CD B5 70 02
	and.l	D6,2(A5,D7.L)		; CD B5 78 02
	and.l	D3,*0xFFFFFFF0		; C7 B8 FF F0
	and.l	D3, 0x00010004		; C7 B9 00 01 00 04

	or	D7,D0			; 80 87
	or	(A1),D2			; 84 91
	or	(A2)+,D3		; 86 9A
	or	-(A3),D4		; 88 A3
	or	1(A4),D5		; 8A AC 00 01
	or	2(A5,D7.W),D6		; 8C B5 70 02
	or	2(A5,D7.L),D6		; 8C B5 78 02
	or	*0xFFFFFFF0,D3		; 86 B8 FF F0
	or	 0x00010004,D3		; 86 B9 00 01 00 04
	or	5(PC),D4		; 88 BA 00 03
	or	6(PC,A7.W),D5		; 8A BB F0 04
	or	6(PC,A7.L),D5		; 8A BB F8 04
	or	#7,D6			; 00 86 00 00 00 07
	or	#9,D6			; 00 86 00 00 00 09

	or	D0,D7			; 8E 80
	or	D2,(A1)			; 85 91
	or	D3,(A2)+		; 87 9A
	or	D4,-(A3)		; 89 A3
	or	D5,1(A4)		; 8B AC 00 01
	or	D6,2(A5,D7.W)		; 8D B5 70 02
	or	D6,2(A5,D7.L)		; 8D B5 78 02
	or	D3,*0xFFFFFFF0		; 87 B8 FF F0
	or	D3, 0x00010004		; 87 B9 00 01 00 04

	or.l	D7,D0			; 80 87
	or.l	(A1),D2			; 84 91
	or.l	(A2)+,D3		; 86 9A
	or.l	-(A3),D4		; 88 A3
	or.l	1(A4),D5		; 8A AC 00 01
	or.l	2(A5,D7.W),D6		; 8C B5 70 02
	or.l	2(A5,D7.L),D6		; 8C B5 78 02
	or.l	*0xFFFFFFF0,D3		; 86 B8 FF F0
	or.l	 0x00010004,D3		; 86 B9 00 01 00 04
	or.l	5(PC),D4		; 88 BA 00 03
	or.l	6(PC,A7.W),D5		; 8A BB F0 04
	or.l	6(PC,A7.L),D5		; 8A BB F8 04
	or.l	#7,D6			; 00 86 00 00 00 07
	or.l	#9,D6			; 00 86 00 00 00 09

	or.l	D0,D7			; 8E 80
	or.l	D2,(A1)			; 85 91
	or.l	D3,(A2)+		; 87 9A
	or.l	D4,-(A3)		; 89 A3
	or.l	D5,1(A4)		; 8B AC 00 01
	or.l	D6,2(A5,D7.W)		; 8D B5 70 02
	or.l	D6,2(A5,D7.L)		; 8D B5 78 02
	or.l	D3,*0xFFFFFFF0		; 87 B8 FF F0
	or.l	D3, 0x00010004		; 87 B9 00 01 00 04

	sub	D7,D0			; 90 87
	sub	A0,D1			; 92 88
	sub	(A1),D2			; 94 91
	sub	(A2)+,D3		; 96 9A
	sub	-(A3),D4		; 98 A3
	sub	1(A4),D5		; 9A AC 00 01
	sub	2(A5,D7.W),D6		; 9C B5 70 02
	sub	2(A5,D7.L),D6		; 9C B5 78 02
	sub	*0xFFFFFFF0,D3		; 96 B8 FF F0
	sub	 0x00010004,D3		; 96 B9 00 01 00 04
	sub	5(PC),D4		; 98 BA 00 03
	sub	6(PC,A7.W),D5		; 9A BB F0 04
	sub	6(PC,A7.L),D5		; 9A BB F8 04
	sub	#7,D6			; 5F 86
	sub	#9,D6			; 04 86 00 00 00 09

	sub	D0,D7			; 9E 80
	sub	D1,A0			; 91 C1
	sub	D2,(A1)			; 95 91
	sub	D3,(A2)+		; 97 9A
	sub	D4,-(A3)		; 99 A3
	sub	D5,1(A4)		; 9B AC 00 01
	sub	D6,2(A5,D7.W)		; 9D B5 70 02
	sub	D6,2(A5,D7.L)		; 9D B5 78 02
	sub	D3,*0xFFFFFFF0		; 97 B8 FF F0
	sub	D3, 0x00010004		; 97 B9 00 01 00 04

	sub.l	D7,D0			; 90 87
	sub.l	A0,D1			; 92 88
	sub.l	(A1),D2			; 94 91
	sub.l	(A2)+,D3		; 96 9A
	sub.l	-(A3),D4		; 98 A3
	sub.l	1(A4),D5		; 9A AC 00 01
	sub.l	2(A5,D7.W),D6		; 9C B5 70 02
	sub.l	2(A5,D7.L),D6		; 9C B5 78 02
	sub.l	*0xFFFFFFF0,D3		; 96 B8 FF F0
	sub.l	 0x00010004,D3		; 96 B9 00 01 00 04
	sub.l	5(PC),D4		; 98 BA 00 03
	sub.l	6(PC,A7.W),D5		; 9A BB F0 04
	sub.l	6(PC,A7.L),D5		; 9A BB F8 04
	sub.l	#7,D6			; 5F 86
	sub.l	#9,D6			; 04 86 00 00 00 09

	sub.l	D0,D7			; 9E 80
	sub.l	D1,A0			; 91 C1
	sub.l	D2,(A1)			; 95 91
	sub.l	D3,(A2)+		; 97 9A
	sub.l	D4,-(A3)		; 99 A3
	sub.l	D5,1(A4)		; 9B AC 00 01
	sub.l	D6,2(A5,D7.W)		; 9D B5 70 02
	sub.l	D6,2(A5,D7.L)		; 9D B5 78 02
	sub.l	D3,*0xFFFFFFF0		; 97 B8 FF F0
	sub.l	D3, 0x00010004		; 97 B9 00 01 00 04

	.sbttl	Type S_TYP3 Instructions: ADDA, CMPA, SUBA

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_TYP3:						*
	;*	ADDA, CMPA, SUBA				*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	adda	D0,A0			; D1 C0
	adda	A0,A1			; D3 C8
	adda	(A1),A2			; D5 D1
	adda	(A2)+,A3		; D7 DA
	adda	-(A3),A4		; D9 E3
	adda	1(A4),A5		; DB EC 00 01
	adda	2(A5,D7.W),A6		; DD F5 70 02
	adda	2(A5,D7.L),A6		; DD F5 78 02
	adda	*0xFFFFFFF0,A3		; D7 F8 FF F0
	adda	 0x00010004,A3		; D7 F9 00 01 00 04
	adda	5(PC),A4		; D9 FA 00 03
	adda	6(PC,A3.W),A5		; DB FB B0 04
	adda	6(PC,A3.L),A5		; DB FB B8 04
	adda	#7,A6			; DD FC 00 00 00 07

	adda.l	D0,A0			; D1 C0
	adda.l	A0,A1			; D3 C8
	adda.l	(A1),A2			; D5 D1
	adda.l	(A2)+,A3		; D7 DA
	adda.l	-(A3),A4		; D9 E3
	adda.l	1(A4),A5		; DB EC 00 01
	adda.l	2(A5,D7.W),A6		; DD F5 70 02
	adda.l	2(A5,D7.L),A6		; DD F5 78 02
	adda.l	*0xFFFFFFF0,A3		; D7 F8 FF F0
	adda.l	 0x00010004,A3		; D7 F9 00 01 00 04
	adda.l	5(PC),A4		; D9 FA 00 03
	adda.l	6(PC,A3.W),A5		; DB FB B0 04
	adda.l	6(PC,A3.L),A5		; DB FB B8 04
	adda.l	#7,A6			; DD FC 00 00 00 07

	cmpa	D0,A0			; B1 C0
	cmpa	A0,A1			; B3 C8
	cmpa	(A1),A2			; B5 D1
	cmpa	(A2)+,A3		; B7 DA
	cmpa	-(A3),A4		; B9 E3
	cmpa	1(A4),A5		; BB EC 00 01
	cmpa	2(A5,D7.W),A6		; BD F5 70 02
	cmpa	2(A5,D7.L),A6		; BD F5 78 02
	cmpa	*0xFFFFFFF0,A3		; B7 F8 FF F0
	cmpa	 0x00010004,A3		; B7 F9 00 01 00 04
	cmpa	5(PC),A4		; B9 FA 00 03
	cmpa	6(PC,A3.W),A5		; BB FB B0 04
	cmpa	6(PC,A3.L),A5		; BB FB B8 04
	cmpa	#7,A6			; BD FC 00 00 00 07

	cmpa.w	D0,A0			; B0 C0
	cmpa.w	A0,A1			; B2 C8
	cmpa.w	(A1),A2			; B4 D1
	cmpa.w	(A2)+,A3		; B6 DA
	cmpa.w	-(A3),A4		; B8 E3
	cmpa.w	1(A4),A5		; BA EC 00 01
	cmpa.w	2(A5,D7.W),A6		; BC F5 70 02
	cmpa.w	2(A5,D7.L),A6		; BC F5 78 02
	cmpa.w	*0xFFFFFFF0,A3		; B6 F8 FF F0
	cmpa.w	 0x00010004,A3		; B6 F9 00 01 00 04
	cmpa.w	5(PC),A4		; B8 FA 00 03
	cmpa.w	6(PC,A3.W),A5		; BA FB B0 04
	cmpa.w	6(PC,A3.L),A5		; BA FB B8 04
	cmpa.w	#7,A6			; BC FC 00 07

	cmpa.l	D0,A0			; B1 C0
	cmpa.l	A0,A1			; B3 C8
	cmpa.l	(A1),A2			; B5 D1
	cmpa.l	(A2)+,A3		; B7 DA
	cmpa.l	-(A3),A4		; B9 E3
	cmpa.l	1(A4),A5		; BB EC 00 01
	cmpa.l	2(A5,D7.W),A6		; BD F5 70 02
	cmpa.l	2(A5,D7.L),A6		; BD F5 78 02
	cmpa.l	*0xFFFFFFF0,A3		; B7 F8 FF F0
	cmpa.l	 0x00010004,A3		; B7 F9 00 01 00 04
	cmpa.l	5(PC),A4		; B9 FA 00 03
	cmpa.l	6(PC,A3.W),A5		; BB FB B0 04
	cmpa.l	6(PC,A3.L),A5		; BB FB B8 04
	cmpa.l	#7,A6			; BD FC 00 00 00 07

	suba	D0,A0			; 91 C0
	suba	A0,A1			; 93 C8
	suba	(A1),A2			; 95 D1
	suba	(A2)+,A3		; 97 DA
	suba	-(A3),A4		; 99 E3
	suba	1(A4),A5		; 9B EC 00 01
	suba	2(A5,D7.W),A6		; 9D F5 70 02
	suba	2(A5,D7.L),A6		; 9D F5 78 02
	suba	*0xFFFFFFF0,A3		; 97 F8 FF F0
	suba	 0x00010004,A3		; 97 F9 00 01 00 04
	suba	5(PC),A4		; 99 FA 00 03
	suba	6(PC,A3.W),A5		; 9B FB B0 04
	suba	6(PC,A3.L),A5		; 9B FB B8 04
	suba	#7,A6			; 9D FC 00 00 00 07

	suba.l	D0,A0			; 91 C0
	suba.l	A0,A1			; 93 C8
	suba.l	(A1),A2			; 95 D1
	suba.l	(A2)+,A3		; 97 DA
	suba.l	-(A3),A4		; 99 E3
	suba.l	1(A4),A5		; 9B EC 00 01
	suba.l	2(A5,D7.W),A6		; 9D F5 70 02
	suba.l	2(A5,D7.L),A6		; 9D F5 78 02
	suba.l	*0xFFFFFFF0,A3		; 97 F8 FF F0
	suba.l	 0x00010004,A3		; 97 F9 00 01 00 04
	suba.l	5(PC),A4		; 99 FA 00 03
	suba.l	6(PC,A3.W),A5		; 9B FB B0 04
	suba.l	6(PC,A3.L),A5		; 9B FB B8 04
	suba.l	#7,A6			; 9D FC 00 00 00 07

	.sbttl	Type S_TYP4 Instructions: ADDI, ANDI, CMPI, EORI, ORI, SUBI

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_TYP4:						*
	;*	ADDI, ANDI, CMPI, EORI, ORI, SUBI		*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	addi	#0,D7			; 06 87 00 00 00 00


	andi	#0,D7			; 02 87 00 00 00 00


	cmpi	#0,D7			; 0C 87 00 00 00 00


	eori	#0,D7			; 0A 87 00 00 00 00


	ori	#0,D7			; 00 87 00 00 00 00


	subi	#0,D7			; 04 87 00 00 00 00


	.sbttl	Type S_TYP5 Instructions: ADDQ, SUBQ

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_TYP5:						*
	;*	ADDQ, SUBQ					*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	addq	#8,D7			; 50 87
	addq	#2,(A1)			; 54 91
	addq	#3,(A2)+		; 56 9A
	addq	#4,-(A3)		; 58 A3
	addq	#5,1(A4)		; 5A AC 00 01
	addq	#6,2(A5,D7.W)		; 5C B5 70 02
	addq	#6,2(A5,D7.L)		; 5C B5 78 02
	addq	#3,*0xFFFFFFF0		; 56 B8 FF F0
	addq	#3, 0x00010004		; 56 B9 00 01 00 04


	addq.l	#8,D7			; 50 87
	addq.l	#2,(A1)			; 54 91
	addq.l	#3,(A2)+		; 56 9A
	addq.l	#4,-(A3)		; 58 A3
	addq.l	#5,1(A4)		; 5A AC 00 01
	addq.l	#6,2(A5,D7.W)		; 5C B5 70 02
	addq.l	#6,2(A5,D7.L)		; 5C B5 78 02
	addq.l	#3,*0xFFFFFFF0		; 56 B8 FF F0
	addq.l	#3, 0x00010004		; 56 B9 00 01 00 04


	subq	#8,D7			; 51 87
	subq	#2,(A1)			; 55 91
	subq	#3,(A2)+		; 57 9A
	subq	#4,-(A3)		; 59 A3
	subq	#5,1(A4)		; 5B AC 00 01
	subq	#6,2(A5,D7.W)		; 5D B5 70 02
	subq	#6,2(A5,D7.L)		; 5D B5 78 02
	subq	#3,*0xFFFFFFF0		; 57 B8 FF F0
	subq	#3, 0x00010004		; 57 B9 00 01 00 04


	subq.l	#8,D7			; 51 87
	subq.l	#2,(A1)			; 55 91
	subq.l	#3,(A2)+		; 57 9A
	subq.l	#4,-(A3)		; 59 A3
	subq.l	#5,1(A4)		; 5B AC 00 01
	subq.l	#6,2(A5,D7.W)		; 5D B5 70 02
	subq.l	#6,2(A5,D7.L)		; 5D B5 78 02
	subq.l	#3,*0xFFFFFFF0		; 57 B8 FF F0
	subq.l	#3, 0x00010004		; 57 B9 00 01 00 04


	.sbttl	Type S_TYP6 Instructions: DIVS, DIVU, MULS, MULU

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_TYP6:						*
	;*	DIVS, DIVU, MULS, MULU				*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	divs	D0,D1			; 4C 40 18 01
	divs	(A1),D2			; 4C 51 28 02
	divs	(A2)+,D3		; 4C 5A 38 03
	divs	-(A3),D4		; 4C 63 48 04
	divs	1(A4),D5		; 4C 6C 58 05 00 01

	divs.w	D0,D1			; 83 C0
	divs.w	(A1),D2			; 85 D1
	divs.w	(A2)+,D3		; 87 DA
	divs.w	-(A3),D4		; 89 E3
	divs.w	1(A4),D5		; 8B EC 00 01
	divs.w	2(A5,D7.W),D6		; 8D F5 70 02
	divs.w	2(A5,D7.L),D6		; 8D F5 78 02
	divs.w	*0xFFFFFFF0,D3		; 87 F8 FF F0
	divs.w	 0x00010004,D3		; 87 F9 00 01 00 04
	divs.w	5(PC),D4		; 89 FA 00 03
	divs.w	6(PC,A7.W),D5		; 8B FB F0 04
	divs.w	6(PC,A7.L),D5		; 8B FB F8 04
	divs.w	#7,D6			; 8D FC 00 07

	divs.l	D0,D1			; 4C 40 18 01
	divs.l	(A1),D2			; 4C 51 28 02
	divs.l	(A2)+,D3		; 4C 5A 38 03
	divs.l	-(A3),D4		; 4C 63 48 04
	divs.l	1(A4),D5		; 4C 6C 58 05 00 01

	divu	D0,D1			; 4C 40 10 01
	divu	(A1),D2			; 4C 51 20 02
	divu	(A2)+,D3		; 4C 5A 30 03
	divu	-(A3),D4		; 4C 63 40 04
	divu	1(A4),D5		; 4C 6C 50 05 00 01

	divu.w	D0,D1			; 82 C0
	divu.w	(A1),D2			; 84 D1
	divu.w	(A2)+,D3		; 86 DA
	divu.w	-(A3),D4		; 88 E3
	divu.w	1(A4),D5		; 8A EC 00 01
	divu.w	2(A5,D7.W),D6		; 8C F5 70 02
	divu.w	2(A5,D7.L),D6		; 8C F5 78 02
	divu.w	*0xFFFFFFF0,D3		; 86 F8 FF F0
	divu.w	 0x00010004,D3		; 86 F9 00 01 00 04
	divu.w	5(PC),D4		; 88 FA 00 03
	divu.w	6(PC,A7.W),D5		; 8A FB F0 04
	divu.w	6(PC,A7.L),D5		; 8A FB F8 04
	divu.w	#7,D6			; 8C FC 00 07

	divu.l	D0,D1			; 4C 40 10 01
	divu.l	(A1),D2			; 4C 51 20 02
	divu.l	(A2)+,D3		; 4C 5A 30 03
	divu.l	-(A3),D4		; 4C 63 40 04
	divu.l	1(A4),D5		; 4C 6C 50 05 00 01

	muls	D0,D1			; 4C 00 18 01
	muls	(A1),D2			; 4C 11 28 02
	muls	(A2)+,D3		; 4C 1A 38 03
	muls	-(A3),D4		; 4C 23 48 04
	muls	1(A4),D5		; 4C 2C 58 05 00 01

	muls.w	D0,D1			; C3 C0
	muls.w	(A1),D2			; C5 D1
	muls.w	(A2)+,D3		; C7 DA
	muls.w	-(A3),D4		; C9 E3
	muls.w	1(A4),D5		; CB EC 00 01
	muls.w	2(A5,D7.W),D6		; CD F5 70 02
	muls.w	2(A5,D7.L),D6		; CD F5 78 02
	muls.w	*0xFFFFFFF0,D3		; C7 F8 FF F0
	muls.w	 0x00010004,D3		; C7 F9 00 01 00 04
	muls.w	5(PC),D4		; C9 FA 00 03
	muls.w	6(PC,A7.W),D5		; CB FB F0 04
	muls.w	6(PC,A7.L),D5		; CB FB F8 04
	muls.w	#7,D6			; CD FC 00 07

	muls.l	D0,D1			; 4C 00 18 01
	muls.l	(A1),D2			; 4C 11 28 02
	muls.l	(A2)+,D3		; 4C 1A 38 03
	muls.l	-(A3),D4		; 4C 23 48 04
	muls.l	1(A4),D5		; 4C 2C 58 05 00 01

	mulu	D0,D1			; 4C 00 10 01
	mulu	(A1),D2			; 4C 11 20 02
	mulu	(A2)+,D3		; 4C 1A 30 03
	mulu	-(A3),D4		; 4C 23 40 04
	mulu	1(A4),D5		; 4C 2C 50 05 00 01

	mulu.w	D0,D1			; C2 C0
	mulu.w	(A1),D2			; C4 D1
	mulu.w	(A2)+,D3		; C6 DA
	mulu.w	-(A3),D4		; C8 E3
	mulu.w	1(A4),D5		; CA EC 00 01
	mulu.w	2(A5,D7.W),D6		; CC F5 70 02
	mulu.w	2(A5,D7.L),D6		; CC F5 78 02
	mulu.w	*0xFFFFFFF0,D3		; C6 F8 FF F0
	mulu.w	 0x00010004,D3		; C6 F9 00 01 00 04
	mulu.w	5(PC),D4		; C8 FA 00 03
	mulu.w	6(PC,A7.W),D5		; CA FB F0 04
	mulu.w	6(PC,A7.L),D5		; CA FB F8 04
	mulu.w	#7,D6			; CC FC 00 07

	mulu.l	D0,D1			; 4C 00 10 01
	mulu.l	(A1),D2			; 4C 11 20 02
	mulu.l	(A2)+,D3		; 4C 1A 30 03
	mulu.l	-(A3),D4		; 4C 23 40 04
	mulu.l	1(A4),D5		; 4C 2C 50 05 00 01

	.sbttl	Type S_TYP7 Instructions: CLR, TST

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_TYP7:						*
	;*	CLR, TST					*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	clr	D7			; 42 87
	clr	(A1)			; 42 91
	clr	(A2)+			; 42 9A
	clr	-(A3)			; 42 A3
	clr	1(A4)			; 42 AC 00 01
	clr	2(A5,D7.W)		; 42 B5 70 02
	clr	2(A5,D7.L)		; 42 B5 78 02
	clr	*0xFFFFFFF0		; 42 B8 FF F0
	clr	 0x00010004		; 42 B9 00 01 00 04

	clr.b	D7			; 42 07
	clr.b	(A1)			; 42 11
	clr.b	(A2)+			; 42 1A
	clr.b	-(A3)			; 42 23
	clr.b	1(A4)			; 42 2C 00 01
	clr.b	2(A5,D7.W)		; 42 35 70 02
	clr.b	2(A5,D7.L)		; 42 35 78 02
	clr.b	*0xFFFFFFF0		; 42 38 FF F0
	clr.b	 0x00010004		; 42 39 00 01 00 04

	clr.w	D7			; 42 47
	clr.w	(A1)			; 42 51
	clr.w	(A2)+			; 42 5A
	clr.w	-(A3)			; 42 63
	clr.w	1(A4)			; 42 6C 00 01
	clr.w	2(A5,D7.W)		; 42 75 70 02
	clr.w	2(A5,D7.L)		; 42 75 78 02
	clr.w	*0xFFFFFFF0		; 42 78 FF F0
	clr.w	 0x00010004		; 42 79 00 01 00 04

	clr.l	D7			; 42 87
	clr.l	(A1)			; 42 91
	clr.l	(A2)+			; 42 9A
	clr.l	-(A3)			; 42 A3
	clr.l	1(A4)			; 42 AC 00 01
	clr.l	2(A5,D7.W)		; 42 B5 70 02
	clr.l	2(A5,D7.L)		; 42 B5 78 02
	clr.l	*0xFFFFFFF0		; 42 B8 FF F0
	clr.l	 0x00010004		; 42 B9 00 01 00 04

	tst	D7			; 4A C7
	tst	A0			; 4A C8
	tst	(A1)			; 4A D1
	tst	(A2)+			; 4A DA
	tst	-(A3)			; 4A E3
	tst	1(A4)			; 4A EC 00 01
	tst	2(A5,D7.W)		; 4A F5 70 02
	tst	2(A5,D7.L)		; 4A F5 78 02
	tst	*0xFFFFFFF0		; 4A F8 FF F0
	tst	 0x00010004		; 4A F9 00 01 00 04
	tst	5(PC)			; 4A FA 00 03
	tst	6(PC,A7.W)		; 4A FB F0 04
	tst	6(PC,A7.L)		; 4A FB F8 04
	tst	#7			; 4A FC 00 00 00 07

	tst.b	D7			; 4A 07
	tst.b	(A1)			; 4A 11
	tst.b	(A2)+			; 4A 1A
	tst.b	-(A3)			; 4A 23
	tst.b	1(A4)			; 4A 2C 00 01
	tst.b	2(A5,D7.W)		; 4A 35 70 02
	tst.b	2(A5,D7.L)		; 4A 35 78 02
	tst.b	*0xFFFFFFF0		; 4A 38 FF F0
	tst.b	 0x00010004		; 4A 39 00 01 00 04
	tst.b	5(PC)			; 4A 3A 00 03
	tst.b	6(PC,A7.W)		; 4A 3B F0 04
	tst.b	6(PC,A7.L)		; 4A 3B F8 04
	tst.b	#7			; 4A 3C 00 07

	tst.w	D7			; 4A 47
	tst.w	(A1)			; 4A 51
	tst.w	(A2)+			; 4A 5A
	tst.w	-(A3)			; 4A 63
	tst.w	1(A4)			; 4A 6C 00 01
	tst.w	2(A5,D7.W)		; 4A 75 70 02
	tst.w	2(A5,D7.L)		; 4A 75 78 02
	tst.w	*0xFFFFFFF0		; 4A 78 FF F0
	tst.w	 0x00010004		; 4A 79 00 01 00 04
	tst.w	5(PC)			; 4A 7A 00 03
	tst.w	6(PC,A7.W)		; 4A 7B F0 04
	tst.w	6(PC,A7.L)		; 4A 7B F8 04
	tst.w	#7			; 4A 7C 00 07

	tst.l	D7			; 4A 87
	tst.l	A0			; 4A 88
	tst.l	(A1)			; 4A 91
	tst.l	(A2)+			; 4A 9A
	tst.l	-(A3)			; 4A A3
	tst.l	1(A4)			; 4A AC 00 01
	tst.l	2(A5,D7.W)		; 4A B5 70 02
	tst.l	2(A5,D7.L)		; 4A B5 78 02
	tst.l	*0xFFFFFFF0		; 4A B8 FF F0
	tst.l	 0x00010004		; 4A B9 00 01 00 04
	tst.l	5(PC)			; 4A BA 00 03
	tst.l	6(PC,A7.W)		; 4A BB F0 04
	tst.l	6(PC,A7.L)		; 4A BB F8 04
	tst.l	#7			; 4A BC 00 00 00 07

	.sbttl	Type S_TYP8 Instructions: JMP, JSR, LEA, PEA

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_TYP8:						*
	;*	JMP, JSR, LEA, PEA				*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	jmp	(A1)			; 4E D1
	jmp	1(A4)			; 4E EC 00 01
	jmp	2(A5,D7.W)		; 4E F5 70 02
	jmp	2(A5,D7.L)		; 4E F5 78 02
	jmp	*0xFFFFFFF0		; 4E F8 FF F0
	jmp	 0x00010004		; 4E F9 00 01 00 04
	jmp	5(PC)			; 4E FA 00 03
	jmp	6(PC,A7.W)		; 4E FB F0 04
	jmp	6(PC,A7.L)		; 4E FB F8 04

	jmp.l	(A1)			; 4E D1
	jmp.l	1(A4)			; 4E EC 00 01
	jmp.l	2(A5,D7.W)		; 4E F5 70 02
	jmp.l	2(A5,D7.L)		; 4E F5 78 02
	jmp.l	*0xFFFFFFF0		; 4E F8 FF F0
	jmp.l	 0x00010004		; 4E F9 00 01 00 04
	jmp.l	5(PC)			; 4E FA 00 03
	jmp.l	6(PC,A7.W)		; 4E FB F0 04
	jmp.l	6(PC,A7.L)		; 4E FB F8 04

	jsr	(A1)			; 4E 91
	jsr	1(A4)			; 4E AC 00 01
	jsr	2(A5,D7.W)		; 4E B5 70 02
	jsr	2(A5,D7.L)		; 4E B5 78 02
	jsr	*0xFFFFFFF0		; 4E B8 FF F0
	jsr	 0x00010004		; 4E B9 00 01 00 04
	jsr	5(PC)			; 4E BA 00 03
	jsr	6(PC,A7.W)		; 4E BB F0 04
	jsr	6(PC,A7.L)		; 4E BB F8 04

	jsr.l	(A1)			; 4E 91
	jsr.l	1(A4)			; 4E AC 00 01
	jsr.l	2(A5,D7.W)		; 4E B5 70 02
	jsr.l	2(A5,D7.L)		; 4E B5 78 02
	jsr.l	*0xFFFFFFF0		; 4E B8 FF F0
	jsr.l	 0x00010004		; 4E B9 00 01 00 04
	jsr.l	5(PC)			; 4E BA 00 03
	jsr.l	6(PC,A7.W)		; 4E BB F0 04
	jsr.l	6(PC,A7.L)		; 4E BB F8 04

	pea	(A1)			; 48 51
	pea	1(A4)			; 48 6C 00 01
	pea	2(A5,D7.W)		; 48 75 70 02
	pea	2(A5,D7.L)		; 48 75 78 02
	pea	*0xFFFFFFF0		; 48 78 FF F0
	pea	 0x00010004		; 48 79 00 01 00 04
	pea	5(PC)			; 48 7A 00 03
	pea	6(PC,A7.W)		; 48 7B F0 04
	pea	6(PC,A7.L)		; 48 7B F8 04

	pea.l	(A1)			; 48 51
	pea.l	1(A4)			; 48 6C 00 01
	pea.l	2(A5,D7.W)		; 48 75 70 02
	pea.l	2(A5,D7.L)		; 48 75 78 02
	pea.l	*0xFFFFFFF0		; 48 78 FF F0
	pea.l	 0x00010004		; 48 79 00 01 00 04
	pea.l	5(PC)			; 48 7A 00 03
	pea.l	6(PC,A7.W)		; 48 7B F0 04
	pea.l	6(PC,A7.L)		; 48 7B F8 04

	lea	(A1),A0			; 41 D1
	lea	1(A4),A0		; 41 EC 00 01
	lea	2(A5,D7.W),A1		; 43 F5 70 02
	lea	2(A5,D7.L),A2		; 45 F5 78 02
	lea	*0xFFFFFFF0,A3		; 47 F8 FF F0
	lea	 0x00010004,A4		; 49 F9 00 01 00 04
	lea	5(PC),A5		; 4B FA 00 03
	lea	6(PC,A7.W),A6		; 4D FB F0 04
	lea	6(PC,A7.L),A7		; 4F FB F8 04

	lea.l	(A1),A0			; 41 D1
	lea.l	1(A4),A0		; 41 EC 00 01
	lea.l	2(A5,D7.W),A1		; 43 F5 70 02
	lea.l	2(A5,D7.L),A2		; 45 F5 78 02
	lea.l	*0xFFFFFFF0,A3		; 47 F8 FF F0
	lea.l	 0x00010004,A4		; 49 F9 00 01 00 04
	lea.l	5(PC),A5		; 4B FA 00 03
	lea.l	6(PC,A7.W),A6		; 4D FB F0 04
	lea.l	6(PC,A7.L),A7		; 4F FB F8 04

	.sbttl	Type S_TYP9 Instructions: BYTEREV, BITREV, FF1, NEG, NEGX, NOT, SATS, SWAP

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_TYP9:						*
	;*	BYTEREV, BITREV, FF1				*
	;*	NEG, NEGX, NOT, SATS, SWAP			*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	bitrev	D0			; 00 C0
	bitrev	D7			; 00 C7

	bitrev.l	D0		; 00 C0
	bitrev.l	D7		; 00 C7

	byterev	D0			; 02 C0
	byterev	D7			; 02 C7

	byterev.l	D0		; 02 C0
	byterev.l	D7		; 02 C7

	ff1	D0			; 04 C0
	ff1	D7			; 04 C7

	ff1.l	D0			; 04 C0
	ff1.l	D7			; 04 C7

	neg	D0			; 44 80
	neg	D7			; 44 87

	neg.l	D0			; 44 80
	neg.l	D7			; 44 87

	negx	D0			; 40 80
	negx	D7			; 40 87

	negx.l	D0			; 40 80
	negx.l	D7			; 40 87

	not	D0			; 46 80
	not	D7			; 46 87

	not.l	D0			; 46 80
	not.l	D7			; 46 87

	sats	D0			; 4C 80
	sats	D7			; 4C 87

	sats.l	D0			; 4C 80
	sats.l	D7			; 4C 87

	swap	D0			; 48 40
	swap	D7			; 48 47

	swap.w	D0			; 48 40
	swap.w	D7			; 48 47

	.sbttl	Type S_TAS Instructions: TAS, WDDATA

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_TAS:						*
	;*	TAS, WDDATA					*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	tas	(A1)			; 4A D1
	tas	(A2)+			; 4A DA
	tas	-(A3)			; 4A E3
	tas	1(A4)			; 4A EC 00 01
	tas	2(A5,D7.W)		; 4A F5 70 02
	tas	2(A5,D7.L)		; 4A F5 78 02
	tas	*0xFFFFFFF0		; 4A F8 FF F0
	tas	 0x00010004		; 4A F9 00 01 00 04

	tas.b	(A1)			; 4A D1
	tas.b	(A2)+			; 4A DA
	tas.b	-(A3)			; 4A E3
	tas.b	1(A4)			; 4A EC 00 01
	tas.b	2(A5,D7.W)		; 4A F5 70 02
	tas.b	2(A5,D7.L)		; 4A F5 78 02
	tas.b	*0xFFFFFFF0		; 4A F8 FF F0
	tas.b	 0x00010004		; 4A F9 00 01 00 04

	wddata	(A1)			; FB 91
	wddata	(A2)+			; FB 9A
	wddata	-(A3)			; FB A3
	wddata	1(A4)			; FB AC 00 01
	wddata	2(A5,D7.W)		; FB B5 70 02
	wddata	2(A5,D7.L)		; FB B5 78 02
	wddata	*0xFFFFFFF0		; FB B8 FF F0
	wddata	 0x00010004		; FB B9 00 01 00 04

	wddata.b	(A1)		; FB 11
	wddata.b	(A2)+		; FB 1A
	wddata.b	-(A3)		; FB 23
	wddata.b	1(A4)		; FB 2C 00 01
	wddata.b	2(A5,D7.W)	; FB 35 70 02
	wddata.b	2(A5,D7.L)	; FB 35 78 02
	wddata.b	*0xFFFFFFF0	; FB 38 FF F0
	wddata.b	 0x00010004	; FB 39 00 01 00 04

	wddata.w	(A1)		; FB 51
	wddata.w	(A2)+		; FB 5A
	wddata.w	-(A3)		; FB 63
	wddata.w	1(A4)		; FB 6C 00 01
	wddata.w	2(A5,D7.W)	; FB 75 70 02
	wddata.w	2(A5,D7.L)	; FB 75 78 02
	wddata.w	*0xFFFFFFF0	; FB 78 FF F0
	wddata.w	 0x00010004	; FB 79 00 01 00 04

	wddata.l	(A1)		; FB 91
	wddata.l	(A2)+		; FB 9A
	wddata.l	-(A3)		; FB A3
	wddata.l	1(A4)		; FB AC 00 01
	wddata.l	2(A5,D7.W)	; FB B5 70 02
	wddata.l	2(A5,D7.L)	; FB B5 78 02
	wddata.l	*0xFFFFFFF0	; FB B8 FF F0
	wddata.l	 0x00010004	; FB B9 00 01 00 04

	.sbttl	Type S_SHFT Instructions: ASL, ASR, LSL, LSR

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_SHFT:						*
	;*	ASL, ASR, LSL, LSR				*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	asl	D7,D0			; EF A0
	asl	#7,D5			; EF 85

	asl.l	D7,D0			; EF A0
	asl.l	#7,D5			; EF 85

	asr	D7,D0			; EE A0
	asr	#7,D5			; EE 85

	asr.l	D7,D0			; EE A0
	asr.l	#7,D5			; EE 85

	lsl	D7,D0			; EF A8
	lsl	#7,D5			; EF 8D

	lsl.l	D7,D0			; EF A8
	lsl.l	#7,D5			; EF 8D

	lsr	D7,D0			; EE A8
	lsr	#7,D5			; EE 8D

	lsr.l	D7,D0			; EE A8
	lsr.l	#7,D5			; EE 8D

	.sbttl	Type S_BCC Instructions: BRA, BSR, Plus Conditional Branches

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_BCC:						*
	;*	BRA, BSR, BHI, BLS, BCC, BCS, BNE, BEQ		*
	;*	BVC, BVS, BPL, BMI, BGE, BLT, BGT, BLE		*
	;*	Alternates - BHS, BLO, BHIS, BLOS		*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	bra	10000$			; 60 02
	bra	. - 0x7E		; 60 80
10000$:	bra	.			; 60 FE
	bra	. + 0x04		; 60 02
	bra	. + 0x80		; 60 7E
	bra	. + 0x82		; 60 00 00 80
	bra	. + 0x1002		; 60 00 10 00
	bra	. + 0x20002		; 60 FF 00 02 00 00
	bra.b	. + 0x12		; 60 10
	bra.w	. + 0x12		; 60 00 00 10
	bra.l	. + 0x12		; 60 FF 00 00 00 10
	bra.w	. + 0x1002		; 60 00 10 00
	bra.l	. + 0x1002		; 60 FF 00 00 10 00
	bra.l	. + 0x20002		; 60 FF 00 02 00 00

	bsr	10001$			; 61 02
	bsr	. - 0x7E		; 61 80
10001$:	bsr	.			; 61 FE
	bsr	. + 0x04		; 61 02
	bsr	. + 0x80		; 61 7E
	bsr	. + 0x82		; 61 00 00 80
	bsr	. + 0x1002		; 61 00 10 00
	bsr	. + 0x20002		; 61 FF 00 02 00 00
	bsr.b	. + 0x12		; 61 10
	bsr.w	. + 0x12		; 61 00 00 10
	bsr.l	. + 0x12		; 61 FF 00 00 00 10
	bsr.w	. + 0x1002		; 61 00 10 00
	bsr.l	. + 0x1002		; 61 FF 00 00 10 00
	bsr.l	. + 0x20002		; 61 FF 00 02 00 00

	bhi	10002$			; 62 02
	bhi	. - 0x7E		; 62 80
10002$:	bhi	.			; 62 FE
	bhi	. + 0x04		; 62 02
	bhi	. + 0x80		; 62 7E
	bhi	. + 0x82		; 62 00 00 80
	bhi	. + 0x1002		; 62 00 10 00
	bhi	. + 0x20002		; 62 FF 00 02 00 00
	bhi.b	. + 0x12		; 62 10
	bhi.w	. + 0x12		; 62 00 00 10
	bhi.l	. + 0x12		; 62 FF 00 00 00 10
	bhi.w	. + 0x1002		; 62 00 10 00
	bhi.l	. + 0x1002		; 62 FF 00 00 10 00
	bhi.l	. + 0x20002		; 62 FF 00 02 00 00

	bls	10003$			; 63 02
	bls	. - 0x7E		; 63 80
10003$:	bls	.			; 63 FE
	bls	. + 0x04		; 63 02
	bls	. + 0x80		; 63 7E
	bls	. + 0x82		; 63 00 00 80
	bls	. + 0x1002		; 63 00 10 00
	bls	. + 0x20002		; 63 FF 00 02 00 00
	bls.b	. + 0x12		; 63 10
	bls.w	. + 0x12		; 63 00 00 10
	bls.l	. + 0x12		; 63 FF 00 00 00 10
	bls.w	. + 0x1002		; 63 00 10 00
	bls.l	. + 0x1002		; 63 FF 00 00 10 00
	bls.l	. + 0x20002		; 63 FF 00 02 00 00

	bcc	10004$			; 64 02
	bcc	. - 0x7E		; 64 80
10004$:	bcc	.			; 64 FE
	bcc	. + 0x04		; 64 02
	bcc	. + 0x80		; 64 7E
	bcc	. + 0x82		; 64 00 00 80
	bcc	. + 0x1002		; 64 00 10 00
	bcc	. + 0x20002		; 64 FF 00 02 00 00
	bcc.b	. + 0x12		; 64 10
	bcc.w	. + 0x12		; 64 00 00 10
	bcc.l	. + 0x12		; 64 FF 00 00 00 10
	bcc.w	. + 0x1002		; 64 00 10 00
	bcc.l	. + 0x1002		; 64 FF 00 00 10 00
	bcc.l	. + 0x20002		; 64 FF 00 02 00 00

	bcs	10005$			; 65 02
	bcs	. - 0x7E		; 65 80
10005$:	bcs	.			; 65 FE
	bcs	. + 0x04		; 65 02
	bcs	. + 0x80		; 65 7E
	bcs	. + 0x82		; 65 00 00 80
	bcs	. + 0x1002		; 65 00 10 00
	bcs	. + 0x20002		; 65 FF 00 02 00 00
	bcs.b	. + 0x12		; 65 10
	bcs.w	. + 0x12		; 65 00 00 10
	bcs.l	. + 0x12		; 65 FF 00 00 00 10
	bcs.w	. + 0x1002		; 65 00 10 00
	bcs.l	. + 0x1002		; 65 FF 00 00 10 00
	bcs.l	. + 0x20002		; 65 FF 00 02 00 00

	bne	10006$			; 66 02
	bne	. - 0x7E		; 66 80
10006$:	bne	.			; 66 FE
	bne	. + 0x04		; 66 02
	bne	. + 0x80		; 66 7E
	bne	. + 0x82		; 66 00 00 80
	bne	. + 0x1002		; 66 00 10 00
	bne	. + 0x20002		; 66 FF 00 02 00 00
	bne.b	. + 0x12		; 66 10
	bne.w	. + 0x12		; 66 00 00 10
	bne.l	. + 0x12		; 66 FF 00 00 00 10
	bne.w	. + 0x1002		; 66 00 10 00
	bne.l	. + 0x1002		; 66 FF 00 00 10 00
	bne.l	. + 0x20002		; 66 FF 00 02 00 00

	beq	10007$			; 67 02
	beq	. - 0x7E		; 67 80
10007$:	beq	.			; 67 FE
	beq	. + 0x04		; 67 02
	beq	. + 0x80		; 67 7E
	beq	. + 0x82		; 67 00 00 80
	beq	. + 0x1002		; 67 00 10 00
	beq	. + 0x20002		; 67 FF 00 02 00 00
	beq.b	. + 0x12		; 67 10
	beq.w	. + 0x12		; 67 00 00 10
	beq.l	. + 0x12		; 67 FF 00 00 00 10
	beq.w	. + 0x1002		; 67 00 10 00
	beq.l	. + 0x1002		; 67 FF 00 00 10 00
	beq.l	. + 0x20002		; 67 FF 00 02 00 00

	bvc	10008$			; 68 02
	bvc	. - 0x7E		; 68 80
10008$:	bvc	.			; 68 FE
	bvc	. + 0x04		; 68 02
	bvc	. + 0x80		; 68 7E
	bvc	. + 0x82		; 68 00 00 80
	bvc	. + 0x1002		; 68 00 10 00
	bvc	. + 0x20002		; 68 FF 00 02 00 00
	bvc.b	. + 0x12		; 68 10
	bvc.w	. + 0x12		; 68 00 00 10
	bvc.l	. + 0x12		; 68 FF 00 00 00 10
	bvc.w	. + 0x1002		; 68 00 10 00
	bvc.l	. + 0x1002		; 68 FF 00 00 10 00
	bvc.l	. + 0x20002		; 68 FF 00 02 00 00

	bvs	10009$			; 69 02
	bvs	. - 0x7E		; 69 80
10009$:	bvs	.			; 69 FE
	bvs	. + 0x04		; 69 02
	bvs	. + 0x80		; 69 7E
	bvs	. + 0x82		; 69 00 00 80
	bvs	. + 0x1002		; 69 00 10 00
	bvs	. + 0x20002		; 69 FF 00 02 00 00
	bvs.b	. + 0x12		; 69 10
	bvs.w	. + 0x12		; 69 00 00 10
	bvs.l	. + 0x12		; 69 FF 00 00 00 10
	bvs.w	. + 0x1002		; 69 00 10 00
	bvs.l	. + 0x1002		; 69 FF 00 00 10 00
	bvs.l	. + 0x20002		; 69 FF 00 02 00 00

	bpl	10010$			; 6A 02
	bpl	. - 0x7E		; 6A 80
10010$:	bpl	.			; 6A FE
	bpl	. + 0x04		; 6A 02
	bpl	. + 0x80		; 6A 7E
	bpl	. + 0x82		; 6A 00 00 80
	bpl	. + 0x1002		; 6A 00 10 00
	bpl	. + 0x20002		; 6A FF 00 02 00 00
	bpl.b	. + 0x12		; 6A 10
	bpl.w	. + 0x12		; 6A 00 00 10
	bpl.l	. + 0x12		; 6A FF 00 00 00 10
	bpl.w	. + 0x1002		; 6A 00 10 00
	bpl.l	. + 0x1002		; 6A FF 00 00 10 00
	bpl.l	. + 0x20002		; 6A FF 00 02 00 00

	bmi	10011$			; 6B 02
	bmi	. - 0x7E		; 6B 80
10011$:	bmi	.			; 6B FE
	bmi	. + 0x04		; 6B 02
	bmi	. + 0x80		; 6B 7E
	bmi	. + 0x82		; 6B 00 00 80
	bmi	. + 0x1002		; 6B 00 10 00
	bmi	. + 0x20002		; 6B FF 00 02 00 00
	bmi.b	. + 0x12		; 6B 10
	bmi.w	. + 0x12		; 6B 00 00 10
	bmi.l	. + 0x12		; 6B FF 00 00 00 10
	bmi.w	. + 0x1002		; 6B 00 10 00
	bmi.l	. + 0x1002		; 6B FF 00 00 10 00
	bmi.l	. + 0x20002		; 6B FF 00 02 00 00

	bge	10012$			; 6C 02
	bge	. - 0x7E		; 6C 80
10012$:	bge	.			; 6C FE
	bge	. + 0x04		; 6C 02
	bge	. + 0x80		; 6C 7E
	bge	. + 0x82		; 6C 00 00 80
	bge	. + 0x1002		; 6C 00 10 00
	bge	. + 0x20002		; 6C FF 00 02 00 00
	bge.b	. + 0x12		; 6C 10
	bge.w	. + 0x12		; 6C 00 00 10
	bge.l	. + 0x12		; 6C FF 00 00 00 10
	bge.w	. + 0x1002		; 6C 00 10 00
	bge.l	. + 0x1002		; 6C FF 00 00 10 00
	bge.l	. + 0x20002		; 6C FF 00 02 00 00

	blt	10013$			; 6D 02
	blt	. - 0x7E		; 6D 80
10013$:	blt	.			; 6D FE
	blt	. + 0x04		; 6D 02
	blt	. + 0x80		; 6D 7E
	blt	. + 0x82		; 6D 00 00 80
	blt	. + 0x1002		; 6D 00 10 00
	blt	. + 0x20002		; 6D FF 00 02 00 00
	blt.b	. + 0x12		; 6D 10
	blt.w	. + 0x12		; 6D 00 00 10
	blt.l	. + 0x12		; 6D FF 00 00 00 10
	blt.w	. + 0x1002		; 6D 00 10 00
	blt.l	. + 0x1002		; 6D FF 00 00 10 00
	blt.l	. + 0x20002		; 6D FF 00 02 00 00

	bgt	10014$			; 6E 02
	bgt	. - 0x7E		; 6E 80
10014$:	bgt	.			; 6E FE
	bgt	. + 0x04		; 6E 02
	bgt	. + 0x80		; 6E 7E
	bgt	. + 0x82		; 6E 00 00 80
	bgt	. + 0x1002		; 6E 00 10 00
	bgt	. + 0x20002		; 6E FF 00 02 00 00
	bgt.b	. + 0x12		; 6E 10
	bgt.w	. + 0x12		; 6E 00 00 10
	bgt.l	. + 0x12		; 6E FF 00 00 00 10
	bgt.w	. + 0x1002		; 6E 00 10 00
	bgt.l	. + 0x1002		; 6E FF 00 00 10 00
	bgt.l	. + 0x20002		; 6E FF 00 02 00 00

	ble	10015$			; 6F 02
	ble	. - 0x7E		; 6F 80
10015$:	ble	.			; 6F FE
	ble	. + 0x04		; 6F 02
	ble	. + 0x80		; 6F 7E
	ble	. + 0x82		; 6F 00 00 80
	ble	. + 0x1002		; 6F 00 10 00
	ble	. + 0x20002		; 6F FF 00 02 00 00
	ble.b	. + 0x12		; 6F 10
	ble.w	. + 0x12		; 6F 00 00 10
	ble.l	. + 0x12		; 6F FF 00 00 00 10
	ble.w	. + 0x1002		; 6F 00 10 00
	ble.l	. + 0x1002		; 6F FF 00 00 10 00
	ble.l	. + 0x20002		; 6F FF 00 02 00 00

	bhs	10016$			; 64 02
	bhs	. - 0x7E		; 64 80
10016$:	bhs	.			; 64 FE
	bhs	. + 0x04		; 64 02
	bhs	. + 0x80		; 64 7E
	bhs	. + 0x82		; 64 00 00 80
	bhs	. + 0x1002		; 64 00 10 00
	bhs	. + 0x20002		; 64 FF 00 02 00 00
	bhs.b	. + 0x12		; 64 10
	bhs.w	. + 0x12		; 64 00 00 10
	bhs.l	. + 0x12		; 64 FF 00 00 00 10
	bhs.w	. + 0x1002		; 64 00 10 00
	bhs.l	. + 0x1002		; 64 FF 00 00 10 00
	bhs.l	. + 0x20002		; 64 FF 00 02 00 00

	blo	10017$			; 65 02
	blo	. - 0x7E		; 65 80
10017$:	blo	.			; 65 FE
	blo	. + 0x04		; 65 02
	blo	. + 0x80		; 65 7E
	blo	. + 0x82		; 65 00 00 80
	blo	. + 0x1002		; 65 00 10 00
	blo	. + 0x20002		; 65 FF 00 02 00 00
	blo.b	. + 0x12		; 65 10
	blo.w	. + 0x12		; 65 00 00 10
	blo.l	. + 0x12		; 65 FF 00 00 00 10
	blo.w	. + 0x1002		; 65 00 10 00
	blo.l	. + 0x1002		; 65 FF 00 00 10 00
	blo.l	. + 0x20002		; 65 FF 00 02 00 00

	bhis	10018$			; 64 02
	bhis	. - 0x7E		; 64 80
10018$:	bhis	.			; 64 FE
	bhis	. + 0x04		; 64 02
	bhis	. + 0x80		; 64 7E
	bhis	. + 0x82		; 64 00 00 80
	bhis	. + 0x1002		; 64 00 10 00
	bhis	. + 0x20002		; 64 FF 00 02 00 00
	bhis.b	. + 0x12		; 64 10
	bhis.w	. + 0x12		; 64 00 00 10
	bhis.l	. + 0x12		; 64 FF 00 00 00 10
	bhis.w	. + 0x1002		; 64 00 10 00
	bhis.l	. + 0x1002		; 64 FF 00 00 10 00
	bhis.l	. + 0x20002		; 64 FF 00 02 00 00

	blos	10019$			; 63 02
	blos	. - 0x7E		; 63 80
10019$:	blos	.			; 63 FE
	blos	. + 0x04		; 63 02
	blos	. + 0x80		; 63 7E
	blos	. + 0x82		; 63 00 00 80
	blos	. + 0x1002		; 63 00 10 00
	blos	. + 0x20002		; 63 FF 00 02 00 00
	blos.b	. + 0x12		; 63 10
	blos.w	. + 0x12		; 63 00 00 10
	blos.l	. + 0x12		; 63 FF 00 00 00 10
	blos.w	. + 0x1002		; 63 00 10 00
	blos.l	. + 0x1002		; 63 FF 00 00 10 00
	blos.l	. + 0x20002		; 63 FF 00 02 00 00

	.sbttl	Type S_SCC Instructions: ST, SF, Plus Conditional Branches

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_SCC:						*
	;*	ST,  SF,  SHI, SLS, SCC, SCS, SNE, SEQ		*
	;*	SVC, SVS, SPL, SMI, SGE, SLT, SGT, SLE		*
	;*	Alternates - SHS, SLO, SHIS, SLOS		*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	st	D7			; 50 C7

	st.b	D7			; 50 C7


	sf	D7			; 51 C7

	sf.b	D7			; 51 C7


	shi	D7			; 52 C7

	shi.b	D7			; 52 C7


	sls	D7			; 53 C7

	sls.b	D7			; 53 C7


	scc	D7			; 54 C7

	scc.b	D7			; 54 C7


	scs	D7			; 55 C7

	scs.b	D7			; 55 C7


	sne	D7			; 56 C7

	sne.b	D7			; 56 C7


	seq	D7			; 57 C7

	seq.b	D7			; 57 C7


	svc	D7			; 58 C7

	svc.b	D7			; 58 C7

	svs	D7			; 59 C7

	svs.b	D7			; 59 C7

	spl	D7			; 5A C7

	spl.b	D7			; 5A C7

	smi	D7			; 5B C7

	smi.b	D7			; 5B C7

	sge	D7			; 5C C7

	sge.b	D7			; 5C C7

	slt	D7			; 5D C7

	slt.b	D7			; 5D C7

	sgt	D7			; 5E C7

	sgt.b	D7			; 5E C7

	sle	D7			; 5F C7

	sle.b	D7			; 5F C7

	shs	D7			; 54 C7

	shs.b	D7			; 54 C7

	slo	D7			; 55 C7

	slo.b	D7			; 55 C7

	shis	D7			; 54 C7

	shis.b	D7			; 54 C7

	slos	D7			; 53 C7

	slos.b	D7			; 53 C7

	.sbttl	Type S_BIT Instructions: BCHG, BCLR, BSET, BTST

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_BIT:						*
	;*	BCHG, BCLR, BSET, BTST				*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	bchg	D0,D7			; 01 47
	bchg	D2,(A1)			; 05 51
	bchg	D3,(A2)+		; 07 5A
	bchg	D4,-(A3)		; 09 63
	bchg	D5,1(A4)		; 0B 6C 00 01
	bchg	D6,2(A5,D7.W)		; 0D 75 70 02
	bchg	D6,2(A5,D7.L)		; 0D 75 78 02
	bchg	D3,*0xFFFFFFF0		; 07 78 FF F0
	bchg	D3, 0x00010004		; 07 79 00 01 00 04

	bchg	#0,D7			; 09 47 00 00
	bchg	#2,(A1)			; 09 51 00 02
	bchg	#3,(A2)+		; 09 5A 00 03
	bchg	#4,-(A3)		; 09 63 00 04
	bchg	#5,1(A4)		; 09 6C 00 05 00 01

	bchg.b	D2,(A1)			; 05 51
	bchg.b	D3,(A2)+		; 07 5A
	bchg.b	D4,-(A3)		; 09 63
	bchg.b	D5,1(A4)		; 0B 6C 00 01
	bchg.b	D6,2(A5,D7.W)		; 0D 75 70 02
	bchg.b	D6,2(A5,D7.L)		; 0D 75 78 02
	bchg.b	D3,*0xFFFFFFF0		; 07 78 FF F0
	bchg.b	D3, 0x00010004		; 07 79 00 01 00 04

	bchg.b	#2,(A1)			; 09 51 00 02
	bchg.b	#3,(A2)+		; 09 5A 00 03
	bchg.b	#4,-(A3)		; 09 63 00 04
	bchg.b	#5,1(A4)		; 09 6C 00 05 00 01

	bchg.l	D0,D7			; 01 47

	bclr	D0,D7			; 01 87
	bclr	D2,(A1)			; 05 91
	bclr	D3,(A2)+		; 07 9A
	bclr	D4,-(A3)		; 09 A3
	bclr	D5,1(A4)		; 0B AC 00 01
	bclr	D6,2(A5,D7.W)		; 0D B5 70 02
	bclr	D6,2(A5,D7.L)		; 0D B5 78 02
	bclr	D3,*0xFFFFFFF0		; 07 B8 FF F0
	bclr	D3, 0x00010004		; 07 B9 00 01 00 04

	bclr	#0,D7			; 09 87 00 00
	bclr	#2,(A1)			; 09 91 00 02
	bclr	#3,(A2)+		; 09 9A 00 03
	bclr	#4,-(A3)		; 09 A3 00 04
	bclr	#5,1(A4)		; 09 AC 00 05 00 01

	bclr.b	D2,(A1)			; 05 91
	bclr.b	D3,(A2)+		; 07 9A
	bclr.b	D4,-(A3)		; 09 A3
	bclr.b	D5,1(A4)		; 0B AC 00 01
	bclr.b	D6,2(A5,D7.W)		; 0D B5 70 02
	bclr.b	D6,2(A5,D7.L)		; 0D B5 78 02
	bclr.b	D3,*0xFFFFFFF0		; 07 B8 FF F0
	bclr.b	D3, 0x00010004		; 07 B9 00 01 00 04

	bclr.b	#2,(A1)			; 09 91 00 02
	bclr.b	#3,(A2)+		; 09 9A 00 03
	bclr.b	#4,-(A3)		; 09 A3 00 04
	bclr.b	#5,1(A4)		; 09 AC 00 05 00 01

	bclr.l	D0,D7			; 01 87

	bset	D0,D7			; 01 C7
	bset	D2,(A1)			; 05 D1
	bset	D3,(A2)+		; 07 DA
	bset	D4,-(A3)		; 09 E3
	bset	D5,1(A4)		; 0B EC 00 01
	bset	D6,2(A5,D7.W)		; 0D F5 70 02
	bset	D6,2(A5,D7.L)		; 0D F5 78 02
	bset	D3,*0xFFFFFFF0		; 07 F8 FF F0
	bset	D3, 0x00010004		; 07 F9 00 01 00 04

	bset	#0,D7			; 09 C7 00 00
	bset	#2,(A1)			; 09 D1 00 02
	bset	#3,(A2)+		; 09 DA 00 03
	bset	#4,-(A3)		; 09 E3 00 04
	bset	#5,1(A4)		; 09 EC 00 05 00 01

	bset.b	D2,(A1)			; 05 D1
	bset.b	D3,(A2)+		; 07 DA
	bset.b	D4,-(A3)		; 09 E3
	bset.b	D5,1(A4)		; 0B EC 00 01
	bset.b	D6,2(A5,D7.W)		; 0D F5 70 02
	bset.b	D6,2(A5,D7.L)		; 0D F5 78 02
	bset.b	D3,*0xFFFFFFF0		; 07 F8 FF F0
	bset.b	D3, 0x00010004		; 07 F9 00 01 00 04

	bset.b	#2,(A1)			; 09 D1 00 02
	bset.b	#3,(A2)+		; 09 DA 00 03
	bset.b	#4,-(A3)		; 09 E3 00 04
	bset.b	#5,1(A4)		; 09 EC 00 05 00 01

	bset.l	D0,D7			; 01 C7

	btst	D0,D7			; 01 07
	btst	D2,(A1)			; 05 11
	btst	D3,(A2)+		; 07 1A
	btst	D4,-(A3)		; 09 23
	btst	D5,1(A4)		; 0B 2C 00 01
	btst	D6,2(A5,D7.W)		; 0D 35 70 02
	btst	D6,2(A5,D7.L)		; 0D 35 78 02
	btst	D3,*0xFFFFFFF0		; 07 38 FF F0
	btst	D3, 0x00010004		; 07 39 00 01 00 04
	btst	D4,5(PC)		; 09 3A 00 03
	btst	D5,6(PC,A7.W)		; 0B 3B F0 04
	btst	D5,6(PC,A7.L)		; 0B 3B F8 04

	btst	#0,D7			; 09 07 00 00
	btst	#2,(A1)			; 09 11 00 02
	btst	#3,(A2)+		; 09 1A 00 03
	btst	#4,-(A3)		; 09 23 00 04
	btst	#5,1(A4)		; 09 2C 00 05 00 01

	btst.b	D2,(A1)			; 05 11
	btst.b	D3,(A2)+		; 07 1A
	btst.b	D4,-(A3)		; 09 23
	btst.b	D5,1(A4)		; 0B 2C 00 01
	btst.b	D6,2(A5,D7.W)		; 0D 35 70 02
	btst.b	D6,2(A5,D7.L)		; 0D 35 78 02
	btst.b	D3,*0xFFFFFFF0		; 07 38 FF F0
	btst.b	D3, 0x00010004		; 07 39 00 01 00 04
	btst.b	D4,5(PC)		; 09 3A 00 03
	btst.b	D5,6(PC,A7.W)		; 0B 3B F0 04
	btst.b	D5,6(PC,A7.L)		; 0B 3B F8 04

	btst.b	#2,(A1)			; 09 11 00 02
	btst.b	#3,(A2)+		; 09 1A 00 03
	btst.b	#4,-(A3)		; 09 23 00 04
	btst.b	#5,1(A4)		; 09 2C 00 05 00 01

	btst.l	D0,D7			; 01 07

	.sbttl	Type S_MOV3Q Instructions: MOV3Q

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_MOV3Q:						*
	;*	MOV3Q						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	mov3q	#-1,D7			; A1 47
	mov3q	#1,A0			; A3 48
	mov3q	#2,(A1)			; A5 51
	mov3q	#3,(A2)+		; A7 5A
	mov3q	#4,-(A3)		; A9 63
	mov3q	#5,1(A4)		; AB 6C 00 01
	mov3q	#6,2(A5,D7.W)		; AD 75 70 02
	mov3q	#6,2(A5,D7.L)		; AD 75 78 02
	mov3q	#7,*0xFFFFFFF0		; AF 78 FF F0
	mov3q	#7, 0x00010004		; AF 79 00 01 00 04

	mov3q.l	#-1,D7			; A1 47
	mov3q.l	#1,A0			; A3 48
	mov3q.l	#2,(A1)			; A5 51
	mov3q.l	#3,(A2)+		; A7 5A
	mov3q.l	#4,-(A3)		; A9 63
	mov3q.l	#5,1(A4)		; AB 6C 00 01
	mov3q.l	#6,2(A5,D7.W)		; AD 75 70 02
	mov3q.l	#6,2(A5,D7.L)		; AD 75 78 02
	mov3q.l	#7,*0xFFFFFFF0		; AF 78 FF F0
	mov3q.l	#7, 0x00010004		; AF 79 00 01 00 04

	.sbttl	Type S_MOVE Instructions: MOVE

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_MOVE:						*
	;*	MOVE						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	; Basic MOVE Instruction Addressing
	move	D0,(A0)			; 20 80
	move	A1,(A1)			; 22 89
	move	(A2),(A2)		; 24 92
	move	(A3)+,(A3)		; 26 9B
	move	-(A4),(A4)		; 28 A4
	move	(9,A5),(A5)		; 2A AD 00 09
	move	(9,A6,D1),(A6)		; 2C B6 10 09
	move	*0xFFFFFFF0,(A7)	; 2E B8 FF F0
	move	 0x00010004,(A0)	; 20 B9 00 01 00 04
	move	(8,PC),(A1)		; 22 BA 00 06
	move	(8,PC,D2),(A2)		; 24 BB 20 06
	move	#7,(A3)			; 26 BC 00 00 00 07

	move	#0,D0			; 70 00
	move	#2,(A2)			; 24 BC 00 00 00 02
	move	#3,(A3)+		; 26 FC 00 00 00 03
	move	#4,-(A4)		; 29 3C 00 00 00 04

	; CCR, SR And USP Registers
	move	D0,CCR			; 44 C0
	move	#3,CCR			; 44 FC 00 00 00 03

	move	CCR,D0			; 42 C0

	move	D1,SR			; 46 C1
	move	#4,SR			; 46 FC 00 00 00 04

	move	SR,D1			; 40 C1

	move	USP,A0			; 4E 68
	move	A0,USP			; 4E 60

	.enabl	(MAC)

	; Multiply-Accumulate Registers
	move	ACC,D0			; A1 80
	move	ACC,A0			; A1 88
	move	MACSR,D1		; A9 81
	move	MACSR,A1		; A9 89
	move	MASK,D2			; AD 82
	move	MASK,A2			; AD 8A
	move	MACSR,CCR		; A9 C0

	move	D3,ACC			; A1 03
	move	A3,ACC			; A1 0B
	move	#3,ACC			; A1 3C 00 00 00 03
	move	D4,MACSR		; A9 04
	move	A4,MACSR		; A9 0C
	move	#4,MACSR		; A9 3C 00 00 00 04
	move	D3,MASK			; AD 03
	move	A5,MASK			; AD 0D
	move	#5,MASK			; AD 3C 00 00 00 05

	.dsabl	(MAC)
	.enabl	(EMAC)

	; Extended Multiply-Accumulate Registers
	move	ACC0,D0			; A1 80
	move	ACC3,A0			; A7 88
	move	ACCext01,D1		; AB 81
	move	ACCext23,A1		; AF 89
	move	MACSR,D2		; A9 82
	move	MACSR,A2		; A9 8A
	move	MASK,D3			; AD 83
	move	MASK,A3			; AD 8B
	move	MACSR,CCR		; A9 C0

	move	D2,ACC1			; A3 02
	move	A2,ACC2			; A5 0A
	move	#2,ACC3			; A7 3C 00 00 00 02
	move	D3,ACCext01		; AB 03
	move	A3,ACCext23		; AF 0B
	move	#3,ACCext01		; AB 3C 00 00 00 03
	move	D4,MACSR		; A9 04
	move	A4,MACSR		; A9 0C
	move	#4,MACSR		; A9 3C 00 00 00 04
	move	D3,MASK			; AD 03
	move	A5,MASK			; AD 0D
	move	#5,MASK			; AD 3C 00 00 00 05
	move	ACC0,ACC3		; A7 10

	.dsabl	(EMAC)

	; Basic MOVE Instruction Addressing
	move.b	D0,(A0)			; 10 80
	move.b	A1,(A1)			; 12 89
	move.b	(A2),(A2)		; 14 92
	move.b	(A3)+,(A3)		; 16 9B
	move.b	-(A4),(A4)		; 18 A4
	move.b	(9,A5),(A5)		; 1A AD 00 09
	move.b	(9,A6,D1),(A6)		; 1C B6 10 09
	move.b	*0xFFFFFFF0,(A7)	; 1E B8 FF F0
	move.b	 0x00010004,(A0)	; 10 B9 00 01 00 04
	move.b	(8,PC),(A1)		; 12 BA 00 06
	move.b	(8,PC,D2),(A2)		; 14 BB 20 06
	move.b	#7,(A3)			; 16 BC 00 07

	move.b	#0,D0			; 10 3C 00 00
	move.b	#2,(A2)			; 14 BC 00 02
	move.b	#3,(A3)+		; 16 FC 00 03
	move.b	#4,-(A4)		; 19 3C 00 04
	move.b	#5,(9,A5)		; 1B 7C 00 05 00 09
	move.b	#6,(9,A6,D1)		; 1D BC 00 06 10 09
	move.b	#7,*0xFFFFFFF0		; 11 FC 00 07 FF F0

	; CCR, SR And USP Registers
	move.b	D0,CCR			; 44 C0
	move.b	#3,CCR			; 44 FC 00 03

	.enabl	(MAC)

	.dsabl	(MAC)
	.enabl	(EMAC)

	.dsabl	(EMAC)

	; Basic MOVE Instruction Addressing
	move.w	D0,(A0)			; 30 80
	move.w	A1,(A1)			; 32 89
	move.w	(A2),(A2)		; 34 92
	move.w	(A3)+,(A3)		; 36 9B
	move.w	-(A4),(A4)		; 38 A4
	move.w	(9,A5),(A5)		; 3A AD 00 09
	move.w	(9,A6,D1),(A6)		; 3C B6 10 09
	move.w	*0xFFFFFFF0,(A7)	; 3E B8 FF F0
	move.w	 0x00010004,(A0)	; 30 B9 00 01 00 04
	move.w	(8,PC),(A1)		; 32 BA 00 06
	move.w	(8,PC,D2),(A2)		; 34 BB 20 06
	move.w	#7,(A3)			; 36 BC 00 07

	move.w	#0,D0			; 30 3C 00 00
	move.w	#2,(A2)			; 34 BC 00 02
	move.w	#3,(A3)+		; 36 FC 00 03
	move.w	#4,-(A4)		; 39 3C 00 04
	move.w	#5,(9,A5)		; 3B 7C 00 05 00 09
	move.w	#6,(9,A6,D1)		; 3D BC 00 06 10 09
	move.w	#7,*0xFFFFFFF0		; 31 FC 00 07 FF F0

	; CCR, SR And USP Registers
	move.w	CCR,D0			; 42 C0

	move.w	D1,SR			; 46 C1
	move.w	#4,SR			; 46 FC 00 04

	move.w	SR,D1			; 40 C1

	.enabl	(MAC)

	.dsabl	(MAC)
	.enabl	(EMAC)

	.dsabl	(EMAC)

	; Basic MOVE Instruction Addressing
	move.l	D0,(A0)			; 20 80
	move.l	A1,(A1)			; 22 89
	move.l	(A2),(A2)		; 24 92
	move.l	(A3)+,(A3)		; 26 9B
	move.l	-(A4),(A4)		; 28 A4
	move.l	(9,A5),(A5)		; 2A AD 00 09
	move.l	(9,A6,D1),(A6)		; 2C B6 10 09
	move.l	*0xFFFFFFF0,(A7)	; 2E B8 FF F0
	move.l	 0x00010004,(A0)	; 20 B9 00 01 00 04
	move.l	(8,PC),(A1)		; 22 BA 00 06
	move.l	(8,PC,D2),(A2)		; 24 BB 20 06
	move.l	#7,(A3)			; 26 BC 00 00 00 07

	move.l	#0,D0			; 70 00
	move.l	#2,(A2)			; 24 BC 00 00 00 02
	move.l	#3,(A3)+		; 26 FC 00 00 00 03
	move.l	#4,-(A4)		; 29 3C 00 00 00 04

	; CCR, SR And USP Registers
	move.l	USP,A0			; 4E 68
	move.l	A0,USP			; 4E 60

	.enabl	(MAC)

	; Multiply-Accumulate Registers
	move.l	ACC,D0			; A1 80
	move.l	ACC,A0			; A1 88
	move.l	MACSR,D1		; A9 81
	move.l	MACSR,A1		; A9 89
	move.l	MASK,D2			; AD 82
	move.l	MASK,A2			; AD 8A
	move.l	MACSR,CCR		; A9 C0

	move.l	D3,ACC			; A1 03
	move.l	A3,ACC			; A1 0B
	move.l	#3,ACC			; A1 3C 00 00 00 03
	move.l	D4,MACSR		; A9 04
	move.l	A4,MACSR		; A9 0C
	move.l	#4,MACSR		; A9 3C 00 00 00 04
	move.l	D3,MASK			; AD 03
	move.l	A5,MASK			; AD 0D
	move.l	#5,MASK			; AD 3C 00 00 00 05

	.dsabl	(MAC)
	.enabl	(EMAC)

	; Extended Multiply-Accumulate Registers
	move.l	ACC0,D0			; A1 80
	move.l	ACC3,A0			; A7 88
	move.l	ACCext01,D1		; AB 81
	move.l	ACCext23,A1		; AF 89
	move.l	MACSR,D2		; A9 82
	move.l	MACSR,A2		; A9 8A
	move.l	MASK,D3			; AD 83
	move.l	MASK,A3			; AD 8B
	move.l	MACSR,CCR		; A9 C0

	move.l	D2,ACC1			; A3 02
	move.l	A2,ACC2			; A5 0A
	move.l	#2,ACC3			; A7 3C 00 00 00 02
	move.l	D3,ACCext01		; AB 03
	move.l	A3,ACCext23		; AF 0B
	move.l	#3,ACCext01		; AB 3C 00 00 00 03
	move.l	D4,MACSR		; A9 04
	move.l	A4,MACSR		; A9 0C
	move.l	#4,MACSR		; A9 3C 00 00 00 04
	move.l	D3,MASK			; AD 03
	move.l	A5,MASK			; AD 0D
	move.l	#5,MASK			; AD 3C 00 00 00 05
	move.l	ACC0,ACC3		; A7 10

	.dsabl	(EMAC)

	.sbttl	Type S_MOVEA Instructions: MOVEA

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_MOVEA:						*
	;*	MOVEA						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	movea	D7,A0			; 20 47
	movea	A0,A1			; 22 48
	movea	(A1),A2			; 24 51
	movea	(A2)+,A3		; 26 5A
	movea	-(A3),A4		; 28 63
	movea	1(A4),A5		; 2A 6C 00 01
	movea	2(A5,D7.W),A6		; 2C 75 70 02
	movea	2(A5,D7.L),A6		; 2C 75 78 02
	movea	*0xFFFFFFF0,A7		; 2E 78 FF F0
	movea	 0x00010004,A7		; 2E 79 00 01 00 04
	movea	5(PC),A0		; 20 7A 00 03
	movea	6(PC,A7.W),A1		; 22 7B F0 04
	movea	6(PC,A7.L),A2		; 24 7B F8 04
	movea	#7,A3			; 26 7C 00 00 00 07

	movea.w	D7,A0			; 30 47
	movea.w	A0,A1			; 32 48
	movea.w	(A1),A2			; 34 51
	movea.w	(A2)+,A3		; 36 5A
	movea.w	-(A3),A4		; 38 63
	movea.w	1(A4),A5		; 3A 6C 00 01
	movea.w	2(A5,D7.W),A6		; 3C 75 70 02
	movea.w	2(A5,D7.L),A6		; 3C 75 78 02
	movea.w	*0xFFFFFFF0,A7		; 3E 78 FF F0
	movea.w	 0x00010004,A7		; 3E 79 00 01 00 04
	movea.w	5(PC),A0		; 30 7A 00 03
	movea.w	6(PC,A7.W),A1		; 32 7B F0 04
	movea.w	6(PC,A7.L),A2		; 34 7B F8 04
	movea.w	#7,A3			; 36 7C 00 07

	movea.l	D7,A0			; 20 47
	movea.l	A0,A1			; 22 48
	movea.l	(A1),A2			; 24 51
	movea.l	(A2)+,A3		; 26 5A
	movea.l	-(A3),A4		; 28 63
	movea.l	1(A4),A5		; 2A 6C 00 01
	movea.l	2(A5,D7.W),A6		; 2C 75 70 02
	movea.l	2(A5,D7.L),A6		; 2C 75 78 02
	movea.l	*0xFFFFFFF0,A7		; 2E 78 FF F0
	movea.l	 0x00010004,A7		; 2E 79 00 01 00 04
	movea.l	5(PC),A0		; 20 7A 00 03
	movea.l	6(PC,A7.W),A1		; 22 7B F0 04
	movea.l	6(PC,A7.L),A2		; 24 7B F8 04
	movea.l	#7,A3			; 26 7C 00 00 00 07

	.sbttl	Type S_MOVEC Instructions: MOVEC

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_MOVEC:						*
	;*	MOVEC						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	movec	D0,CACR			; 4E 7B 00 02
	movec	D0,ASID			; 4E 7B 00 03
	movec	D0,ACR0			; 4E 7B 00 04
	movec	D0,ACR1			; 4E 7B 00 05
	movec	D0,ACR2			; 4E 7B 00 06
	movec	D0,ACR3			; 4E 7B 00 07
	movec	D0,MMUBAR		; 4E 7B 00 08
	movec	D0,VBR			; 4E 7B 08 01
	movec	D0,PC			; 4E 7B 08 0F

	movec	D1,ROMBAR0		; 4E 7B 1C 00
	movec	D1,ROMBAR1		; 4E 7B 1C 01
	movec	D1,RAMBAR0		; 4E 7B 1C 04
	movec	D1,RAMBAR1		; 4E 7B 1C 05
	movec	D1,MPCR			; 4E 7B 1C 0C
	movec	D1,EDRAMBAR		; 4E 7B 1C 0D
	movec	D1,SECMBAR		; 4E 7B 1C 0E
	movec	D1,MBAR			; 4E 7B 1C 0F

	movec	D2,PCR1U0		; 4E 7B 2D 02
	movec	D2,PCR1L0		; 4E 7B 2D 03
	movec	D2,PCR2U0		; 4E 7B 2D 04
	movec	D2,PCR2L0		; 4E 7B 2D 05
	movec	D2,PCR3U0		; 4E 7B 2D 06
	movec	D2,PCR3L0		; 4E 7B 2D 07

	movec	D3,PCR1U1		; 4E 7B 3D 0A
	movec	D3,PCR1L1		; 4E 7B 3D 0B
	movec	D3,PCR2U1		; 4E 7B 3D 0C
	movec	D3,PCR2L1		; 4E 7B 3D 0D
	movec	D3,PCR3U1		; 4E 7B 3D 0E
	movec	D3,PCR3L1		; 4E 7B 3D 0F

	movec	A0,CACR			; 4E 7B 80 02
	movec	A0,ASID			; 4E 7B 80 03
	movec	A0,ACR0			; 4E 7B 80 04
	movec	A0,ACR1			; 4E 7B 80 05
	movec	A0,ACR2			; 4E 7B 80 06
	movec	A0,ACR3			; 4E 7B 80 07
	movec	A0,MMUBAR		; 4E 7B 80 08
	movec	A0,VBR			; 4E 7B 88 01
	movec	A0,PC			; 4E 7B 88 0F

	movec	A1,ROMBAR0		; 4E 7B 9C 00
	movec	A1,ROMBAR1		; 4E 7B 9C 01
	movec	A1,RAMBAR0		; 4E 7B 9C 04
	movec	A1,RAMBAR1		; 4E 7B 9C 05
	movec	A1,MPCR			; 4E 7B 9C 0C
	movec	A1,EDRAMBAR		; 4E 7B 9C 0D
	movec	A1,SECMBAR		; 4E 7B 9C 0E
	movec	A1,MBAR			; 4E 7B 9C 0F

	movec	A2,PCR1U0		; 4E 7B AD 02
	movec	A2,PCR1L0		; 4E 7B AD 03
	movec	A2,PCR2U0		; 4E 7B AD 04
	movec	A2,PCR2L0		; 4E 7B AD 05
	movec	A2,PCR3U0		; 4E 7B AD 06
	movec	A2,PCR3L0		; 4E 7B AD 07

	movec	A3,PCR1U1		; 4E 7B BD 0A
	movec	A3,PCR1L1		; 4E 7B BD 0B
	movec	A3,PCR2U1		; 4E 7B BD 0C
	movec	A3,PCR2L1		; 4E 7B BD 0D
	movec	A3,PCR3U1		; 4E 7B BD 0E
	movec	A3,PCR3L1		; 4E 7B BD 0F

	movec.l	D0,CACR			; 4E 7B 00 02
	movec.l	D0,ASID			; 4E 7B 00 03
	movec.l	D0,ACR0			; 4E 7B 00 04
	movec.l	D0,ACR1			; 4E 7B 00 05
	movec.l	D0,ACR2			; 4E 7B 00 06
	movec.l	D0,ACR3			; 4E 7B 00 07
	movec.l	D0,MMUBAR		; 4E 7B 00 08
	movec.l	D0,VBR			; 4E 7B 08 01
	movec.l	D0,PC			; 4E 7B 08 0F

	movec.l	D1,ROMBAR0		; 4E 7B 1C 00
	movec.l	D1,ROMBAR1		; 4E 7B 1C 01
	movec.l	D1,RAMBAR0		; 4E 7B 1C 04
	movec.l	D1,RAMBAR1		; 4E 7B 1C 05
	movec.l	D1,MPCR			; 4E 7B 1C 0C
	movec.l	D1,EDRAMBAR		; 4E 7B 1C 0D
	movec.l	D1,SECMBAR		; 4E 7B 1C 0E
	movec.l	D1,MBAR			; 4E 7B 1C 0F

	movec.l	D2,PCR1U0		; 4E 7B 2D 02
	movec.l	D2,PCR1L0		; 4E 7B 2D 03
	movec.l	D2,PCR2U0		; 4E 7B 2D 04
	movec.l	D2,PCR2L0		; 4E 7B 2D 05
	movec.l	D2,PCR3U0		; 4E 7B 2D 06
	movec.l	D2,PCR3L0		; 4E 7B 2D 07

	movec.l	D3,PCR1U1		; 4E 7B 3D 0A
	movec.l	D3,PCR1L1		; 4E 7B 3D 0B
	movec.l	D3,PCR2U1		; 4E 7B 3D 0C
	movec.l	D3,PCR2L1		; 4E 7B 3D 0D
	movec.l	D3,PCR3U1		; 4E 7B 3D 0E
	movec.l	D3,PCR3L1		; 4E 7B 3D 0F

	movec.l	A0,CACR			; 4E 7B 80 02
	movec.l	A0,ASID			; 4E 7B 80 03
	movec.l	A0,ACR0			; 4E 7B 80 04
	movec.l	A0,ACR1			; 4E 7B 80 05
	movec.l	A0,ACR2			; 4E 7B 80 06
	movec.l	A0,ACR3			; 4E 7B 80 07
	movec.l	A0,MMUBAR		; 4E 7B 80 08
	movec.l	A0,VBR			; 4E 7B 88 01
	movec.l	A0,PC			; 4E 7B 88 0F

	movec.l	A1,ROMBAR0		; 4E 7B 9C 00
	movec.l	A1,ROMBAR1		; 4E 7B 9C 01
	movec.l	A1,RAMBAR0		; 4E 7B 9C 04
	movec.l	A1,RAMBAR1		; 4E 7B 9C 05
	movec.l	A1,MPCR			; 4E 7B 9C 0C
	movec.l	A1,EDRAMBAR		; 4E 7B 9C 0D
	movec.l	A1,SECMBAR		; 4E 7B 9C 0E
	movec.l	A1,MBAR			; 4E 7B 9C 0F

	movec.l	A2,PCR1U0		; 4E 7B AD 02
	movec.l	A2,PCR1L0		; 4E 7B AD 03
	movec.l	A2,PCR2U0		; 4E 7B AD 04
	movec.l	A2,PCR2L0		; 4E 7B AD 05
	movec.l	A2,PCR3U0		; 4E 7B AD 06
	movec.l	A2,PCR3L0		; 4E 7B AD 07

	movec.l	A3,PCR1U1		; 4E 7B BD 0A
	movec.l	A3,PCR1L1		; 4E 7B BD 0B
	movec.l	A3,PCR2U1		; 4E 7B BD 0C
	movec.l	A3,PCR2L1		; 4E 7B BD 0D
	movec.l	A3,PCR3U1		; 4E 7B BD 0E
	movec.l	A3,PCR3L1		; 4E 7B BD 0F

	.sbttl	Type S_MOVEM Instructions: MOVEM

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_MOVEM:						*
	;*	MOVEM						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	movem	#A7/D0,(A2)		; 48 D2 80 01
	movem	#A7/D0,(9,A5)		; 48 ED 80 01 00 09

	movem	(A2),#A7/D0		; 4C D2 80 01
	movem	(9,A5),#A7/D0		; 4C ED 80 01 00 09

	movem.l	#A7/D0,(A2)		; 48 D2 80 01
	movem.l	#A7/D0,(9,A5)		; 48 ED 80 01 00 09

	movem.l	(A2),#A7/D0		; 4C D2 80 01
	movem.l	(9,A5),#A7/D0		; 4C ED 80 01 00 09

	.sbttl	Type S_MOVEQ Instructions: MOVEQ

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_MOVEQ:						*
	;*	MOVEQ				*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	moveq	#0x0F,D3		; 76 0F

	moveq.l	#0x0F,D3		; 76 0F

	.sbttl	Type S_MVSZ Instructions: MVS, MVZ

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_MVSZ:						*
	;*	MVS, MVZ					*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	mvs	D7,D0			; 71 47
	mvs	A1,D1			; 73 49
	mvs	(A2),D2			; 75 52
	mvs	(A3)+,D3		; 77 5B
	mvs	-(A4),D4		; 79 64
	mvs	1(A5),D5		; 7B 6D 00 01
	mvs	2(A6,D6.W),D6		; 7D 76 60 02
	mvs	2(A6,D6.L),D7		; 7F 76 68 02
	mvs	*0xFFFFFFF0,D0		; 71 78 FF F0
	mvs	 0x00010004,D1		; 73 79 00 01 00 04
	mvs	5(PC),D2		; 75 7A 00 03
	mvs	6(PC,A7.W),D3		; 77 7B F0 04
	mvs	6(PC,A7.L),D3		; 77 7B F8 04
	mvs	#7,D4			; 79 7C 00 07

	mvs.b	D7,D0			; 71 07
	mvs.b	A1,D1			; 73 09
	mvs.b	(A2),D2			; 75 12
	mvs.b	(A3)+,D3		; 77 1B
	mvs.b	-(A4),D4		; 79 24
	mvs.b	1(A5),D5		; 7B 2D 00 01
	mvs.b	2(A6,D6.W),D6		; 7D 36 60 02
	mvs.b	2(A6,D6.L),D7		; 7F 36 68 02
	mvs.b	*0xFFFFFFF0,D0		; 71 38 FF F0
	mvs.b	 0x00010004,D1		; 73 39 00 01 00 04
	mvs.b	5(PC),D2		; 75 3A 00 03
	mvs.b	6(PC,A7.W),D3		; 77 3B F0 04
	mvs.b	6(PC,A7.L),D3		; 77 3B F8 04
	mvs.b	#7,D4			; 79 3C 00 07

	mvs.w	D7,D0			; 71 47
	mvs.w	A1,D1			; 73 49
	mvs.w	(A2),D2			; 75 52
	mvs.w	(A3)+,D3		; 77 5B
	mvs.w	-(A4),D4		; 79 64
	mvs.w	1(A5),D5		; 7B 6D 00 01
	mvs.w	2(A6,D6.W),D6		; 7D 76 60 02
	mvs.w	2(A6,D6.L),D7		; 7F 76 68 02
	mvs.w	*0xFFFFFFF0,D0		; 71 78 FF F0
	mvs.w	 0x00010004,D1		; 73 79 00 01 00 04
	mvs.w	5(PC),D2		; 75 7A 00 03
	mvs.w	6(PC,A7.W),D3		; 77 7B F0 04
	mvs.w	6(PC,A7.L),D3		; 77 7B F8 04
	mvs.w	#7,D4			; 79 7C 00 07

	mvz	D7,D0			; 71 C7
	mvz	A1,D1			; 73 C9
	mvz	(A2),D2			; 75 D2
	mvz	(A3)+,D3		; 77 DB
	mvz	-(A4),D4		; 79 E4
	mvz	1(A5),D5		; 7B ED 00 01
	mvz	2(A6,D6.W),D6		; 7D F6 60 02
	mvz	2(A6,D6.L),D7		; 7F F6 68 02
	mvz	*0xFFFFFFF0,D0		; 71 F8 FF F0
	mvz	 0x00010004,D1		; 73 F9 00 01 00 04
	mvz	5(PC),D2		; 75 FA 00 03
	mvz	6(PC,A7.W),D3		; 77 FB F0 04
	mvz	6(PC,A7.L),D3		; 77 FB F8 04
	mvz	#7,D4			; 79 FC 00 07

	mvz.b	D7,D0			; 71 87
	mvz.b	A1,D1			; 73 89
	mvz.b	(A2),D2			; 75 92
	mvz.b	(A3)+,D3		; 77 9B
	mvz.b	-(A4),D4		; 79 A4
	mvz.b	1(A5),D5		; 7B AD 00 01
	mvz.b	2(A6,D6.W),D6		; 7D B6 60 02
	mvz.b	2(A6,D6.L),D7		; 7F B6 68 02
	mvz.b	*0xFFFFFFF0,D0		; 71 B8 FF F0
	mvz.b	 0x00010004,D1		; 73 B9 00 01 00 04
	mvz.b	5(PC),D2		; 75 BA 00 03
	mvz.b	6(PC,A7.W),D3		; 77 BB F0 04
	mvz.b	6(PC,A7.L),D3		; 77 BB F8 04
	mvz.b	#7,D4			; 79 BC 00 07

	mvz.w	D7,D0			; 71 C7
	mvz.w	A1,D1			; 73 C9
	mvz.w	(A2),D2			; 75 D2
	mvz.w	(A3)+,D3		; 77 DB
	mvz.w	-(A4),D4		; 79 E4
	mvz.w	1(A5),D5		; 7B ED 00 01
	mvz.w	2(A6,D6.W),D6		; 7D F6 60 02
	mvz.w	2(A6,D6.L),D7		; 7F F6 68 02
	mvz.w	*0xFFFFFFF0,D0		; 71 F8 FF F0
	mvz.w	 0x00010004,D1		; 73 F9 00 01 00 04
	mvz.w	5(PC),D2		; 75 FA 00 03
	mvz.w	6(PC,A7.W),D3		; 77 FB F0 04
	mvz.w	6(PC,A7.L),D3		; 77 FB F8 04
	mvz.w	#7,D4			; 79 FC 00 07

	.sbttl	Type S_EOR Instructions: EOR

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_EOR:						*
	;*	EOR						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	eor	D0,D1			; B1 81
	eor	D2,(A1)			; B5 91
	eor	D3,(A2)+		; B7 9A
	eor	D4,-(A3)		; B9 A3
	eor	D5,1(A4)		; BB AC 00 01
	eor	D6,2(A5,D7.W)		; BD B5 70 02
	eor	D6,2(A5,D7.L)		; BD B5 78 02
	eor	D7,*0xFFFFFFF0		; BF B8 FF F0
	eor	D7, 0x00010004		; BF B9 00 01 00 04
	eor	#3,D2			; 0A 82 00 00 00 03

	eor.l	D0,D1			; B1 81
	eor.l	D2,(A1)			; B5 91
	eor.l	D3,(A2)+		; B7 9A
	eor.l	D4,-(A3)		; B9 A3
	eor.l	D5,1(A4)		; BB AC 00 01
	eor.l	D6,2(A5,D7.W)		; BD B5 70 02
	eor.l	D6,2(A5,D7.L)		; BD B5 78 02
	eor.l	D7,*0xFFFFFFF0		; BF B8 FF F0
	eor.l	D7, 0x00010004		; BF B9 00 01 00 04
	eor.l	#3,D2			; 0A 82 00 00 00 03

	.sbttl	Type S_EXT Instructions: EXT

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_EXT:						*
	;*	EXT, EXTB					*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	ext	D0			; 48 C0

	ext.w	D0			; 48 80

	ext.l	D0			; 48 C0

	extb	D0			; 49 C0

	extb.l	D0			; 49 C0

	.sbttl	Type S_LINK Instructions: LINK

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_LINK:						*
	;*	LINK						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	link	A1,#0x1234		; 4E 51 12 34

	link.w	A1,#0x1234		; 4E 51 12 34

	.sbttl	Type S_STOP Instructions: STOP

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_STOP:						*
	;*	STOP						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	stop	#0x1234			; 4E 72 12 34

	.sbttl	Type S_TRAP Instructions: TRAP

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_TRAP:						*
	;*	TRAP						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	trap	#12			; 4E 4C

	.sbttl	Type S_TPF Instructions: TPF

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_TPF:						*
	;*	TPF						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	tpf				; 51 FC
	tpf	#12			; 51 FA 00 0C

	tpf.w				; 51 FA
	tpf.w	#12			; 51 FA 00 0C

	tpf.l				; 51 FB
	tpf.l	#12			; 51 FB 00 00 00 0C

	.sbttl	Type S_UNLK Instructions: UNLK

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_UNLK:						*
	;*	UNLK						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	unlk	A1			; 4E 59

	.sbttl	Type S_INH Instructions: HALT, ILLEGAL, NOP, PULSE, RTE, RTS

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_INH:						*
	;*	ILLEGAL, NOP, RESET, RTE, RTR, RTS		*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	halt				; 4A C8

	illegal				; 4A FC

	nop				; 4E 71

	pulse				; 4A CC

	rte				; 4E 73

	rts				; 4E 75

	.sbttl	Type S_CAS Instructions: CAS

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_CAS:						*
	;*	CAS						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	cas	D0,D1,(A0)		; 0E D0 00 40
	cas	D2,D3,(A1)+		; 0E D9 00 C2
	cas	D4,D5,-(A2)		; 0E E2 01 44
	cas	D6,D7,(2,A3)		; 0E EB 01 C6 00 02

	cas.b	D0,D1,(A0)		; 0A D0 00 40
	cas.b	D2,D3,(A1)+		; 0A D9 00 C2
	cas.b	D4,D5,-(A2)		; 0A E2 01 44
	cas.b	D6,D7,(2,A3)		; 0A EB 01 C6 00 02

	cas.w	D0,D1,(A0)		; 0C D0 00 40
	cas.w	D2,D3,(A1)+		; 0C D9 00 C2
	cas.w	D4,D5,-(A2)		; 0C E2 01 44
	cas.w	D6,D7,(2,A3)		; 0C EB 01 C6 00 02

	cas.l	D0,D1,(A0)		; 0E D0 00 40
	cas.l	D2,D3,(A1)+		; 0E D9 00 C2
	cas.l	D4,D5,-(A2)		; 0E E2 01 44
	cas.l	D6,D7,(2,A3)		; 0E EB 01 C6 00 02

	.sbttl	Type S_CAS2 Instructions: CAS2

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_CAS2:						*
	;*	CAS2						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	cas2	D0:D1,D2:D3,(A0):(A1)	; 0E FC 80 80 90 C1

	cas2.w	D0:D1,D2:D3,(A0):(A1)	; 0C FC 80 80 90 C1

	cas2.l	D0:D1,D2:D3,(A0):(A1)	; 0E FC 80 80 90 C1

	.sbttl	Type S_CHK Instructions: CHK

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_CHK:						*
	;*	CHK						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	chk	D0,D1			; 43 00
	chk	(A1),D2			; 45 11
	chk	(A2)+,D3		; 47 1A
	chk	-(A3),D4		; 49 23
	chk	1(A4),D5		; 4B 2C 00 01
	chk	2(A5,D7.W),D6		; 4D 35 70 02
	chk	2(A5,D7.L),D6		; 4D 35 78 02
	chk	*0xFFFFFFF0,D7		; 4F 38 FF F0
	chk	 0x00010004,D7		; 4F 39 00 01 00 04
	chk	(PC),D0			; 41 3A FF FE
	chk	6(PC,A7.W),D1		; 43 3B F0 04
	chk	6(PC,A7.L),D1		; 43 3B F8 04
	chk	#2,D2			; 45 3C 00 00 00 02

	chk.w	D0,D1			; 43 80
	chk.w	(A1),D2			; 45 91
	chk.w	(A2)+,D3		; 47 9A
	chk.w	-(A3),D4		; 49 A3
	chk.w	1(A4),D5		; 4B AC 00 01
	chk.w	2(A5,D7.W),D6		; 4D B5 70 02
	chk.w	2(A5,D7.L),D6		; 4D B5 78 02
	chk.w	*0xFFFFFFF0,D7		; 4F B8 FF F0
	chk.w	 0x00010004,D7		; 4F B9 00 01 00 04
	chk.w	(PC),D0			; 41 BA FF FE
	chk.w	6(PC,A7.W),D1		; 43 BB F0 04
	chk.w	6(PC,A7.L),D1		; 43 BB F8 04
	chk.w	#2,D2			; 45 BC 00 02

	chk.l	D0,D1			; 43 00
	chk.l	(A1),D2			; 45 11
	chk.l	(A2)+,D3		; 47 1A
	chk.l	-(A3),D4		; 49 23
	chk.l	1(A4),D5		; 4B 2C 00 01
	chk.l	2(A5,D7.W),D6		; 4D 35 70 02
	chk.l	2(A5,D7.L),D6		; 4D 35 78 02
	chk.l	*0xFFFFFFF0,D7		; 4F 38 FF F0
	chk.l	 0x00010004,D7		; 4F 39 00 01 00 04
	chk.l	(PC),D0			; 41 3A FF FE
	chk.l	6(PC,A7.W),D1		; 43 3B F0 04
	chk.l	6(PC,A7.L),D1		; 43 3B F8 04
	chk.l	#2,D2			; 45 3C 00 00 00 02

	.sbttl	Type S_CHK2 Instructions: CHK2

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_CHK2:						*
	;*	CHK2, CMP2					*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	chk2	(A1),D2			; 02 D1 28 00
	chk2	1(A3),A5		; 02 EB D8 00 00 01
	chk2	2(A5,D7.W),D6		; 02 F5 68 00 70 02
	chk2	2(A5,D7.L),A6		; 02 F5 E8 00 78 02
	chk2	(PC),D0			; 02 FA 08 00 FF FC
	chk2	6(PC,A7.W),A1		; 02 FB 98 00 F0 02
	chk2	6(PC,A7.L),D1		; 02 FB 18 00 F8 02

	chk2.b	(A1),D2			; 00 D1 28 00
	chk2.b	1(A3),A5		; 00 EB D8 00 00 01
	chk2.b	2(A5,D7.W),D6		; 00 F5 68 00 70 02
	chk2.b	2(A5,D7.L),A6		; 00 F5 E8 00 78 02
	chk2.b	(PC),D0			; 00 FA 08 00 FF FC
	chk2.b	6(PC,A7.W),A1		; 00 FB 98 00 F0 02
	chk2.b	6(PC,A7.L),D1		; 00 FB 18 00 F8 02

	chk2.w	(A1),D2			; 02 D1 28 00
	chk2.w	1(A3),A5		; 02 EB D8 00 00 01
	chk2.w	2(A5,D7.W),D6		; 02 F5 68 00 70 02
	chk2.w	2(A5,D7.L),A6		; 02 F5 E8 00 78 02
	chk2.w	(PC),D0			; 02 FA 08 00 FF FC
	chk2.w	6(PC,A7.W),A1		; 02 FB 98 00 F0 02
	chk2.w	6(PC,A7.L),D1		; 02 FB 18 00 F8 02

	chk2.l	(A1),D2			; 04 D1 28 00
	chk2.l	1(A3),A5		; 04 EB D8 00 00 01
	chk2.l	2(A5,D7.W),D6		; 04 F5 68 00 70 02
	chk2.l	2(A5,D7.L),A6		; 04 F5 E8 00 78 02
	chk2.l	(PC),D0			; 04 FA 08 00 FF FC
	chk2.l	6(PC,A7.W),A1		; 04 FB 98 00 F0 02
	chk2.l	6(PC,A7.L),D1		; 04 FB 18 00 F8 02

	cmp2	(A1),D2			; 02 D1 20 00
	cmp2	1(A3),A5		; 02 EB D0 00 00 01
	cmp2	2(A5,D7.W),D6		; 02 F5 60 00 70 02
	cmp2	2(A5,D7.L),A6		; 02 F5 E0 00 78 02
	cmp2	(PC),D0			; 02 FA 00 00 FF FC
	cmp2	6(PC,A7.W),A1		; 02 FB 90 00 F0 02
	cmp2	6(PC,A7.L),D1		; 02 FB 10 00 F8 02

	cmp2.b	(A1),D2			; 00 D1 20 00
	cmp2.b	1(A3),A5		; 00 EB D0 00 00 01
	cmp2.b	2(A5,D7.W),D6		; 00 F5 60 00 70 02
	cmp2.b	2(A5,D7.L),A6		; 00 F5 E0 00 78 02
	cmp2.b	(PC),D0			; 00 FA 00 00 FF FC
	cmp2.b	6(PC,A7.W),A1		; 00 FB 90 00 F0 02
	cmp2.b	6(PC,A7.L),D1		; 00 FB 10 00 F8 02

	cmp2.w	(A1),D2			; 02 D1 20 00
	cmp2.w	1(A3),A5		; 02 EB D0 00 00 01
	cmp2.w	2(A5,D7.W),D6		; 02 F5 60 00 70 02
	cmp2.w	2(A5,D7.L),A6		; 02 F5 E0 00 78 02
	cmp2.w	(PC),D0			; 02 FA 00 00 FF FC
	cmp2.w	6(PC,A7.W),A1		; 02 FB 90 00 F0 02
	cmp2.w	6(PC,A7.L),D1		; 02 FB 10 00 F8 02

	cmp2.l	(A1),D2			; 04 D1 20 00
	cmp2.l	1(A3),A5		; 04 EB D0 00 00 01
	cmp2.l	2(A5,D7.W),D6		; 04 F5 60 00 70 02
	cmp2.l	2(A5,D7.L),A6		; 04 F5 E0 00 78 02
	cmp2.l	(PC),D0			; 04 FA 00 00 FF FC
	cmp2.l	6(PC,A7.W),A1		; 04 FB 90 00 F0 02
	cmp2.l	6(PC,A7.L),D1		; 04 FB 10 00 F8 02

	.sbttl	Type S_CMP Instructions: CMP

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_CMP:						*
	;*	CMP						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	cmp	D0,D0			; B0 80
	cmp	A0,D1			; B2 88
	cmp	(A1),D2			; B4 91
	cmp	(A2)+,D3		; B6 9A
	cmp	-(A3),D4		; B8 A3
	cmp	1(A4),D5		; BA AC 00 01
	cmp	2(A5,D7.W),D6		; BC B5 70 02
	cmp	2(A5,D7.L),D6		; BC B5 78 02
	cmp	*0xFFFFFFF0,D7		; BE B8 FF F0
	cmp	 0x00010004,D7		; BE B9 00 01 00 04
	cmp	(PC),D0			; B0 BA FF FE
	cmp	6(PC,A7.W),D1		; B2 BB F0 04
	cmp	6(PC,A7.L),D2		; B4 BB F8 04
	cmp	#2,D3			; 0C 83 00 00 00 02

	cmp.b	D0,D0			; B0 00
	cmp.b	A0,D1			; B2 08
	cmp.b	(A1),D2			; B4 11
	cmp.b	(A2)+,D3		; B6 1A
	cmp.b	-(A3),D4		; B8 23
	cmp.b	1(A4),D5		; BA 2C 00 01
	cmp.b	2(A5,D7.W),D6		; BC 35 70 02
	cmp.b	2(A5,D7.L),D6		; BC 35 78 02
	cmp.b	*0xFFFFFFF0,D7		; BE 38 FF F0
	cmp.b	 0x00010004,D7		; BE 39 00 01 00 04
	cmp.b	(PC),D0			; B0 3A FF FE
	cmp.b	6(PC,A7.W),D1		; B2 3B F0 04
	cmp.b	6(PC,A7.L),D2		; B4 3B F8 04
	cmp.b	#2,D3			; 0C 03 00 02

	cmp.w	D0,D0			; B0 40
	cmp.w	A0,D1			; B2 48
	cmp.w	(A1),D2			; B4 51
	cmp.w	(A2)+,D3		; B6 5A
	cmp.w	-(A3),D4		; B8 63
	cmp.w	1(A4),D5		; BA 6C 00 01
	cmp.w	2(A5,D7.W),D6		; BC 75 70 02
	cmp.w	2(A5,D7.L),D6		; BC 75 78 02
	cmp.w	*0xFFFFFFF0,D7		; BE 78 FF F0
	cmp.w	 0x00010004,D7		; BE 79 00 01 00 04
	cmp.w	(PC),D0			; B0 7A FF FE
	cmp.w	6(PC,A7.W),D1		; B2 7B F0 04
	cmp.w	6(PC,A7.L),D2		; B4 7B F8 04
	cmp.w	#2,D3			; 0C 43 00 02

	cmp.l	D0,D0			; B0 80
	cmp.l	A0,D1			; B2 88
	cmp.l	(A1),D2			; B4 91
	cmp.l	(A2)+,D3		; B6 9A
	cmp.l	-(A3),D4		; B8 A3
	cmp.l	1(A4),D5		; BA AC 00 01
	cmp.l	2(A5,D7.W),D6		; BC B5 70 02
	cmp.l	2(A5,D7.L),D6		; BC B5 78 02
	cmp.l	*0xFFFFFFF0,D7		; BE B8 FF F0
	cmp.l	 0x00010004,D7		; BE B9 00 01 00 04
	cmp.l	(PC),D0			; B0 BA FF FE
	cmp.l	6(PC,A7.W),D1		; B2 BB F0 04
	cmp.l	6(PC,A7.L),D2		; B4 BB F8 04
	cmp.l	#2,D3			; 0C 83 00 00 00 02

	.sbttl	Type S_SHL Instructions: CPUSHL

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_SHL:						*
	;*	CPUSHL						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	cpushl	DC,(A0)			; F4 68
	cpushl	IC,(A1)			; F4 A9
	cpushl	BC,(A2)			; F4 EA

	.sbttl	Type S_TCH Instructions: INTOUCH

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_TCH:						*
	;*	INTOUCH						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	intouch	(A0)			; F4 28

	.sbttl	Type S_REMS Instructions: REMS, REMU

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_REM:						*
	;*	REMS, REMU					*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	rems	D0,D1:D2		; 4C 40 28 01
	rems	(A1),D3:D4		; 4C 51 48 03
	rems	(A2)+,D5:D6		; 4C 5A 68 05
	rems	-(A3),D7:D0		; 4C 63 08 07
	rems	1(A4),D0:D1		; 4C 6C 18 00 00 01

	rems.l	D0,D1:D2		; 4C 40 28 01
	rems.l	(A1),D3:D4		; 4C 51 48 03
	rems.l	(A2)+,D5:D6		; 4C 5A 68 05
	rems.l	-(A3),D7:D0		; 4C 63 08 07
	rems.l	1(A4),D0:D1		; 4C 6C 18 00 00 01

	remu	D0,D1:D2		; 4C 40 20 01
	remu	(A1),D3:D4		; 4C 51 40 03
	remu	(A2)+,D5:D6		; 4C 5A 60 05
	remu	-(A3),D7:D0		; 4C 63 00 07
	remu	1(A4),D0:D1		; 4C 6C 10 00 00 01

	remu.l	D0,D1:D2		; 4C 40 20 01
	remu.l	(A1),D3:D4		; 4C 51 40 03
	remu.l	(A2)+,D5:D6		; 4C 5A 60 05
	remu.l	-(A3),D7:D0		; 4C 63 00 07
	remu.l	1(A4),D0:D1		; 4C 6C 10 00 00 01

	.sbttl	Type S_STLD Instructions: STRLDR

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_STLD:						*
	;*	STRLDSR						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	strldsr	#3			; 40 E7 46 FC 00 03

	strldsr.w	#3		; 40 E7 46 FC 00 03

	.sbttl	Type S_WDB Instructions: WDEBUG

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_WDB:						*
	;*	WDEBUG						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	wdebug	(A0)			; FB D0 00 03
	wdebug	(1,A1)			; FB E9 00 03 00 01

	.sbttl	External Label Branching Tests

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  B_XPC:						*
	;*	External Branching Test				*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

10020$:	bra	10020$			; 60 FE

		.nval	New_B_Org,.
		.area	B
		.org	New_B_Org
y1::
		.area	A

	bra	y1			; 60 FF FF FF FF FE

		.nval	New_B_Org,.
		.area	B
		.org	New_B_Org
y1S::
		.area	A

	bra.b	y1S			; 60 FE

		.nval	New_B_Org,.
		.area	B
		.org	New_B_Org
y1W::
		.area	A

	bra.w	y1W			; 60 00 FF FE

		.nval	New_B_Org,.
		.area	B
		.org	New_B_Org
y1L::
		.area	A

	bra.l	y1L			; 60 FF FF FF FF FE

10021$:	bra	10021$ + 0x200		; 60 00 01 FE

		.nval	New_B_Org,.
		.area	B
		.org	New_B_Org
y2::
		.area	A

	bra	y2 + 0x200		; 60 FF 00 00 01 FE

		.nval	New_B_Org,.
		.area	B
		.org	New_B_Org
y2W::
		.area	A

	bra.w	y2W + 0x200		; 60 00 01 FE

		.nval	New_B_Org,.
		.area	B
		.org	New_B_Org
y2L::
		.area	A

	bra.l	y2L + 0x200		; 60 FF 00 00 01 FE

10022$:	bra	10022$ + 0x20000	; 60 FF 00 01 FF FE

		.nval	New_B_Org,.
		.area	B
		.org	New_B_Org
y3::
		.area	A

	bra	y3 + 0x20000		; 60 FF 00 01 FF FE

		.nval	New_B_Org,.
		.area	B
		.org	New_B_Org
y3L::
		.area	A

	bra.l	y3L + 0x20000		; 60 FF 00 01 FF FE

10023$:	bsr	10023$			; 61 FE

		.nval	New_B_Org,.
		.area	B
		.org	New_B_Org
y4::
		.area	A

	bsr	y4			; 61 FF FF FF FF FE

		.nval	New_B_Org,.
		.area	B
		.org	New_B_Org
y4S::
		.area	A

	bsr.b	y4S			; 61 FE

		.nval	New_B_Org,.
		.area	B
		.org	New_B_Org
y4W::
		.area	A

	bsr.w	y4W			; 61 00 FF FE

		.nval	New_B_Org,.
		.area	B
		.org	New_B_Org
y4L::
		.area	A

	bsr.l	y4L			; 61 FF FF FF FF FE

10024$:	bsr	10024$ + 0x200		; 61 00 01 FE

		.nval	New_B_Org,.
		.area	B
		.org	New_B_Org
y5::
		.area	A

	bsr	y5 + 0x200		; 61 FF 00 00 01 FE

		.nval	New_B_Org,.
		.area	B
		.org	New_B_Org
y5W::
		.area	A

	bsr.w	y5W + 0x200		; 61 00 01 FE

		.nval	New_B_Org,.
		.area	B
		.org	New_B_Org
y5L::
		.area	A

	bsr.l	y5L + 0x200		; 61 FF 00 00 01 FE

10025$:	bsr	10025$ + 0x20000	; 61 FF 00 01 FF FE

		.nval	New_B_Org,.
		.area	B
		.org	New_B_Org
y6::
		.area	A

	bsr	y6 + 0x20000		; 61 FF 00 01 FF FE

		.nval	New_B_Org,.
		.area	B
		.org	New_B_Org
y6L::
		.area	A

	bsr.l	y6L + 0x20000		; 61 FF 00 01 FF FE

10026$:	bcc	10026$			; 64 FE

		.nval	New_B_Org,.
		.area	B
		.org	New_B_Org
y7::
		.area	A

	bcc	y7			; 64 FF FF FF FF FE

		.nval	New_B_Org,.
		.area	B
		.org	New_B_Org
y7S::
		.area	A

	bcc.b	y7S			; 64 FE

		.nval	New_B_Org,.
		.area	B
		.org	New_B_Org
y7W::
		.area	A

	bcc.w	y7W			; 64 00 FF FE

		.nval	New_B_Org,.
		.area	B
		.org	New_B_Org
y7L::
		.area	A

	bcc.l	y7L			; 64 FF FF FF FF FE

10027$:	bcc	10027$ + 0x200		; 64 00 01 FE

		.nval	New_B_Org,.
		.area	B
		.org	New_B_Org
y8::
		.area	A

	bcc	y8 + 0x200		; 64 FF 00 00 01 FE

		.nval	New_B_Org,.
		.area	B
		.org	New_B_Org
y8W::
		.area	A

	bcc.w	y8W + 0x200		; 64 00 01 FE

		.nval	New_B_Org,.
		.area	B
		.org	New_B_Org
y8L::
		.area	A

	bcc.l	y8L + 0x200		; 64 FF 00 00 01 FE

10028$:	bcc	10028$ + 0x20000	; 64 FF 00 01 FF FE

		.nval	New_B_Org,.
		.area	B
		.org	New_B_Org
y9::
		.area	A

	bcc	y9 + 0x20000		; 64 FF 00 01 FF FE

		.nval	New_B_Org,.
		.area	B
		.org	New_B_Org
y9L::
		.area	A

	bcc.l	y9L + 0x20000		; 64 FF 00 01 FF FE

	jmp	(xb+0x12)		; 4E F9 00 00 00 12
	jmp	(xw+0x1234)		; 4E F9 00 00 12 34
	jmp	(xl+0x12345678)		; 4E F9 12 34 56 78
	jsr	(xb+0x12)		; 4E B9 00 00 00 12
	jsr	(xw+0x1234)		; 4E B9 00 00 12 34
	jsr	(xl+0x12345678)		; 4E B9 12 34 56 78

	.sbttl	Type M_MAC Instructions: MAC, MSAC, MAAAC, MASAC, MSAAC, MSSAC

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  M_MAC:						*
	;*	MAC, MSAC, MAAAC, MASAC, MSAAC, MSSAC		*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	;
	; Multiply-Accumulate - MAC, MSAC
	;
	.enabl  (mac)

	mac	D0,A0			; A0 40 08 00
	mac	A1,D1<<			; A2 09 0A 00
	mac	D2,A2>>			; A4 42 0E 00

	mac	D0,A0,(A3),D4		; A8 93 88 00
	mac	A1,D1<<,(A4)+,A5	; AA DC 1A 09
	mac	D2,A2>>,-(A5),D6	; AC A5 AE 02
	mac	D0,A0,(2,A6),A7		; AE EE 88 00 00 02

	mac	D0,A0,(A3)&,D4		; A8 93 88 20
	mac	A1,D1<<,(A4)+&,A5	; AA DC 1A 29
	mac	D2,A2>>,-(A5)&,D6	; AC A5 AE 22
	mac	D0,A0,(2,A6)&,A7	; AE EE 88 20 00 02

	mac.l	D0,A0			; A0 40 08 00
	mac.l	A1,D1<<			; A2 09 0A 00
	mac.l	D2,A2>>			; A4 42 0E 00

	mac.l	D0,A0,(A3),D4		; A8 93 88 00
	mac.l	A1,D1<<,(A4)+,A5	; AA DC 1A 09
	mac.l	D2,A2>>,-(A5),D6	; AC A5 AE 02
	mac.l	D0,A0,(2,A6),A7		; AE EE 88 00 00 02

	mac.l	D0,A0,(A3)&,D4		; A8 93 88 20
	mac.l	A1,D1<<,(A4)+&,A5	; AA DC 1A 29
	mac.l	D2,A2>>,-(A5)&,D6	; AC A5 AE 22
	mac.l	D0,A0,(2,A6)&,A7	; AE EE 88 20 00 02

	mac.w	D0.L,A1.L		; A2 40 00 00
	mac.w	D2.U,A3.L		; A6 42 00 40
	mac.w	D4.L,A5.U<<		; AA 44 02 80
	mac.w	D6.U,A7.U>>		; AE 46 06 C0

	mac.w	D0.L,A1.L,(A3),D4	; A8 93 90 00
	mac.w	D2.U,A3.L,(A4)+,A5	; AA DC B0 42
	mac.w	D4.L,A5.U<<,-(A5),D6	; AC A5 D2 84
	mac.w	D6.U,A7.U>>,(2,A6),A7	; AE EE F6 C6 00 02

	mac.w	D0.L,A1.L,(A3)&,D4	; A8 93 90 20
	mac.w	D2.U,A3.L,(A4)+&,A5	; AA DC B0 62
	mac.w	D4.L,A5.U<<,-(A5)&,D6	; AC A5 D2 A4
	mac.w	D6.U,A7.U>>,(2,A6)&,A7	; AE EE F6 E6 00 02

	msac	D0,A0			; A0 40 09 00
	msac	A1,D1<<			; A2 09 0B 00
	msac	D2,A2>>			; A4 42 0F 00

	msac	D0,A0,(A3),D4		; A8 93 89 00
	msac	A1,D1<<,(A4)+,A5	; AA DC 1B 09
	msac	D2,A2>>,-(A5),D6	; AC A5 AF 02
	msac	D0,A0,(2,A6),A7		; AE EE 89 00 00 02

	msac	D0,A0,(A3)&,D4		; A8 93 89 20
	msac	A1,D1<<,(A4)+&,A5	; AA DC 1B 29
	msac	D2,A2>>,-(A5)&,D6	; AC A5 AF 22
	msac	D0,A0,(2,A6)&,A7	; AE EE 89 20 00 02

	msac.l	D0,A0			; A0 40 09 00
	msac.l	A1,D1<<			; A2 09 0B 00
	msac.l	D2,A2>>			; A4 42 0F 00

	msac.l	D0,A0,(A3),D4		; A8 93 89 00
	msac.l	A1,D1<<,(A4)+,A5	; AA DC 1B 09
	msac.l	D2,A2>>,-(A5),D6	; AC A5 AF 02
	msac.l	D0,A0,(2,A6),A7		; AE EE 89 00 00 02

	msac.l	D0,A0,(A3)&,D4		; A8 93 89 20
	msac.l	A1,D1<<,(A4)+&,A5	; AA DC 1B 29
	msac.l	D2,A2>>,-(A5)&,D6	; AC A5 AF 22
	msac.l	D0,A0,(2,A6)&,A7	; AE EE 89 20 00 02

	msac.w	D0.L,A1.L		; A2 40 01 00
	msac.w	D2.U,A3.L		; A6 42 01 40
	msac.w	D4.L,A5.U<<		; AA 44 03 80
	msac.w	D6.U,A7.U>>		; AE 46 07 C0

	msac.w	D0.L,A1.L,(A3),D4	; A8 93 91 00
	msac.w	D2.U,A3.L,(A4)+,A5	; AA DC B1 42
	msac.w	D4.L,A5.U<<,-(A5),D6	; AC A5 D3 84
	msac.w	D6.U,A7.U>>,(2,A6),A7	; AE EE F7 C6 00 02

	msac.w	D0.L,A1.L,(A3)&,D4	; A8 93 91 20
	msac.w	D2.U,A3.L,(A4)+&,A5	; AA DC B1 62
	msac.w	D4.L,A5.U<<,-(A5)&,D6	; AC A5 D3 A4
	msac.w	D6.U,A7.U>>,(2,A6)&,A7	; AE EE F7 E6 00 02

	.dsabl  (mac)

	;
	; Extended Multiply-Accumulate - MAC, MSAC
	;
	  .enabl  (emac)

	mac	D0,A0,ACC0		; A0 40 08 00
	mac	A1,D1<<,ACC1		; A2 89 0A 00
	mac	D2,A2>>,ACC2		; A4 42 0E 10

	mac	D0,A0,(A3),D4,ACC0	; A8 13 88 00
	mac	A1,D1<<,(A4)+,A5,ACC1	; AA DC 1A 09
	mac	D2,A2>>,-(A5),D6,ACC2	; AC 25 AE 12
	mac	D0,A0,(2,A6),A7,ACC3	; AE EE 88 10 00 02

	mac	D0,A0,(A3)&,D4,ACC0	; A8 13 88 20
	mac	A1,D1<<,(A4)+&,A5,ACC1	; AA DC 1A 29
	mac	D2,A2>>,-(A5)&,D6,ACC2	; AC 25 AE 32
	mac	D0,A0,(2,A6)&,A7,ACC3	; AE EE 88 30 00 02

	mac.l	D0,A0,ACC0		; A0 40 08 00
	mac.l	A1,D1<<,ACC1		; A2 89 0A 00
	mac.l	D2,A2>>,ACC2		; A4 42 0E 10

	mac.l	D0,A0,(A3),D4,ACC0	; A8 13 88 00
	mac.l	A1,D1<<,(A4)+,A5,ACC1	; AA DC 1A 09
	mac.l	D2,A2>>,-(A5),D6,ACC2	; AC 25 AE 12
	mac.l	D0,A0,(2,A6),A7,ACC3	; AE EE 88 10 00 02

	mac.l	D0,A0,(A3)&,D4,ACC0	; A8 13 88 20
	mac.l	A1,D1<<,(A4)+&,A5,ACC1	; AA DC 1A 29
	mac.l	D2,A2>>,-(A5)&,D6,ACC2	; AC 25 AE 32
	mac.l	D0,A0,(2,A6)&,A7,ACC3	; AE EE 88 30 00 02

	mac.w	D0.L,A1.L,ACC0		; A2 40 00 00
	mac.w	D2.U,A3.L,ACC1		; A6 C2 00 40
	mac.w	D4.L,A5.U<<,ACC2	; AA 44 02 90
	mac.w	D6.U,A7.U>>,ACC3	; AE C6 06 D0

	mac.w	D0.L,A1.L,(A3),D4,ACC0	; A8 13 90 00
	mac.w	D2.U,A3.L,(A4)+,A5,ACC1	; AA DC B0 42
	mac.w	D4.L,A5.U<<,-(A5),D6,ACC2	; AC 25 D2 94
	mac.w	D6.U,A7.U>>,(2,A6),A7,ACC3	; AE EE F6 D6 00 02

	mac.w	D0.L,A1.L,(A3)&,D4,ACC0	; A8 13 90 20
	mac.w	D2.U,A3.L,(A4)+&,A5,ACC1	; AA DC B0 62
	mac.w	D4.L,A5.U<<,-(A5)&,D6,ACC2	; AC 25 D2 B4
	mac.w	D6.U,A7.U>>,(2,A6)&,A7,ACC3	; AE EE F6 F6 00 02

	msac	D0,A0,ACC0		; A0 40 09 00
	msac	A1,D1<<,ACC1		; A2 89 0B 00
	msac	D2,A2>>,ACC2		; A4 42 0F 10

	msac	D0,A0,(A3),D4,ACC0	; A8 13 89 00
	msac	A1,D1<<,(A4)+,A5,ACC1	; AA DC 1B 09
	msac	D2,A2>>,-(A5),D6,ACC2	; AC 25 AF 12
	msac	D0,A0,(2,A6),A7,ACC3	; AE EE 89 10 00 02

	msac	D0,A0,(A3)&,D4,ACC0	; A8 13 89 20
	msac	A1,D1<<,(A4)+&,A5,ACC1	; AA DC 1B 29
	msac	D2,A2>>,-(A5)&,D6,ACC2	; AC 25 AF 32
	msac	D0,A0,(2,A6)&,A7,ACC3	; AE EE 89 30 00 02

	msac.l	D0,A0,ACC0		; A0 40 09 00
	msac.l	A1,D1<<,ACC1		; A2 89 0B 00
	msac.l	D2,A2>>,ACC2		; A4 42 0F 10

	msac.l	D0,A0,(A3),D4,ACC0	; A8 13 89 00
	msac.l	A1,D1<<,(A4)+,A5,ACC1	; AA DC 1B 09
	msac.l	D2,A2>>,-(A5),D6,ACC2	; AC 25 AF 12
	msac.l	D0,A0,(2,A6),A7,ACC3	; AE EE 89 10 00 02

	msac.l	D0,A0,(A3)&,D4,ACC0	; A8 13 89 20
	msac.l	A1,D1<<,(A4)+&,A5,ACC1	; AA DC 1B 29
	msac.l	D2,A2>>,-(A5)&,D6,ACC2	; AC 25 AF 32
	msac.l	D0,A0,(2,A6)&,A7,ACC3	; AE EE 89 30 00 02

	msac.w	D0.L,A1.L,ACC0		; A2 40 01 00
	msac.w	D2.U,A3.L,ACC1		; A6 C2 01 40
	msac.w	D4.L,A5.U<<,ACC2	; AA 44 03 90
	msac.w	D6.U,A7.U>>,ACC3	; AE C6 07 D0

	msac.w	D0.L,A1.L,(A3),D4,ACC0	; A8 13 91 00
	msac.w	D2.U,A3.L,(A4)+,A5,ACC1	; AA DC B1 42
	msac.w	D4.L,A5.U<<,-(A5),D6,ACC2	; AC 25 D3 94
	msac.w	D6.U,A7.U>>,(2,A6),A7,ACC3	; AE EE F7 D6 00 02

	msac.w	D0.L,A1.L,(A3)&,D4,ACC0	; A8 13 91 20
	msac.w	D2.U,A3.L,(A4)+&,A5,ACC1	; AA DC B1 62
	msac.w	D4.L,A5.U<<,-(A5)&,D6,ACC2	; AC 25 D3 B4
	msac.w	D6.U,A7.U>>,(2,A6)&,A7,ACC3	; AE EE F7 F6 00 02

	;
	; Extended Multiply-Accumulate - MAAAAC, MASAC, MSAAC, MSSAC
	;
	maaac	D0,A0,ACC0,ACC1		; A0 C0 08 05
	maaac	A1,D1<<,ACC2,ACC3	; A2 89 0A 1D
	maaac	D2,A2>>,ACC0,ACC3	; A4 C2 0E 0D

	maaac.l	D0,A0,ACC0,ACC1		; A0 C0 08 05
	maaac.l	A1,D1<<,ACC2,ACC3	; A2 89 0A 1D
	maaac.l	D2,A2>>,ACC0,ACC3	; A4 C2 0E 0D

	maaac.w	D0.L,A1.L,ACC0,ACC1	; A2 C0 00 05
	maaac.w	D2.U,A3.L,ACC2,ACC3	; A6 C2 00 5D
	maaac.w	D4.L,A5.U<<,ACC0,ACC3	; AA C4 02 8D
	maaac.w	D6.U,A7.U>>,ACC1,ACC2	; AE 46 06 C9

	masac	D0,A0,ACC0,ACC1		; A0 C0 08 07
	masac	A1,D1<<,ACC2,ACC3	; A2 89 0A 1F
	masac	D2,A2>>,ACC0,ACC3	; A4 C2 0E 0F

	masac.l	D0,A0,ACC0,ACC1		; A0 C0 08 07
	masac.l	A1,D1<<,ACC2,ACC3	; A2 89 0A 1F
	masac.l	D2,A2>>,ACC0,ACC3	; A4 C2 0E 0F

	masac.w	D0.L,A1.L,ACC0,ACC1	; A2 C0 00 07
	masac.w	D2.U,A3.L,ACC2,ACC3	; A6 C2 00 5F
	masac.w	D4.L,A5.U<<,ACC0,ACC3	; AA C4 02 8F
	masac.w	D6.U,A7.U>>,ACC1,ACC2	; AE 46 06 CB

	msaac	D0,A0,ACC0,ACC1		; A0 C0 09 05
	msaac	A1,D1<<,ACC2,ACC3	; A2 89 0B 1D
	msaac	D2,A2>>,ACC0,ACC3	; A4 C2 0F 0D

	msaac.l	D0,A0,ACC0,ACC1		; A0 C0 09 05
	msaac.l	A1,D1<<,ACC2,ACC3	; A2 89 0B 1D
	msaac.l	D2,A2>>,ACC0,ACC3	; A4 C2 0F 0D

	msaac.w	D0.L,A1.L,ACC0,ACC1	; A2 C0 01 05
	msaac.w	D2.U,A3.L,ACC2,ACC3	; A6 C2 01 5D
	msaac.w	D4.L,A5.U<<,ACC0,ACC3	; AA C4 03 8D
	msaac.w	D6.U,A7.U>>,ACC1,ACC2	; AE 46 07 C9

	mssac	D0,A0,ACC0,ACC1		; A0 C0 09 07
	mssac	A1,D1<<,ACC2,ACC3	; A2 89 0B 1F
	mssac	D2,A2>>,ACC0,ACC3	; A4 C2 0F 0F

	mssac.l	D0,A0,ACC0,ACC1		; A0 C0 09 07
	mssac.l	A1,D1<<,ACC2,ACC3	; A2 89 0B 1F
	mssac.l	D2,A2>>,ACC0,ACC3	; A4 C2 0F 0F

	mssac.w	D0.L,A1.L,ACC0,ACC1	; A2 C0 01 07
	mssac.w	D2.U,A3.L,ACC2,ACC3	; A6 C2 01 5F
	mssac.w	D4.L,A5.U<<,ACC0,ACC3	; AA C4 03 8F
	mssac.w	D6.U,A7.U>>,ACC1,ACC2	; AE 46 07 CB

	.dsabl  (emac)

	.sbttl	Type M_MCLR Instructions: MOVCLR

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  M_MCLR:						*
	;*	MOVCLR						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****
	.enabl  (emac)

	movclr	ACC0,D7			; A1 C7
	movclr	ACC3,A7			; A7 CF

	movclr.l	ACC0,D7		; A1 C7
	movclr.l	ACC3,A7		; A7 CF

	.dsabl  (mac)

	.sbttl	Type F_TYP1 Instructions: FABS, FINT, FINTRZ, FNEG, FSQRT

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  F_TYP1:						*
	;*	FABS, FINT, FINTRZ, FNEG, FSQRT			*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	;
	; FTYP1 - FABS, FINT, FINTRZ, FNEG, And FSQRT
	;

	fabs	FP7			; F2 07 17 98
	fabs	FP1,FP2			; F2 01 15 18

	fabs.d	FP7			; F2 07 17 98
	fabs.d	FP1,FP2			; F2 01 15 18

	fsabs	FP7			; F2 07 17 D8
	fsabs	FP1,FP2			; F2 01 15 58

	fsabs.d	FP7			; F2 07 17 D8
	fsabs.d	FP1,FP2			; F2 01 15 58

	fdabs	FP7			; F2 07 17 DC
	fdabs	FP1,FP2			; F2 01 15 5C

	fdabs.d	FP7			; F2 07 17 DC
	fdabs.d	FP1,FP2			; F2 01 15 5C

	fint	FP7			; F2 07 17 81
	fint	FP1,FP2			; F2 01 15 01

	fint.d	FP7			; F2 07 17 81
	fint.d	FP1,FP2			; F2 01 15 01

	fintrz	FP7			; F2 07 17 83
	fintrz	FP1,FP2			; F2 01 15 03

	fintrz.d	FP7		; F2 07 17 83
	fintrz.d	FP1,FP2		; F2 01 15 03

	fneg	FP7			; F2 07 17 9A
	fneg	FP1,FP2			; F2 01 15 1A

	fneg.d	FP7			; F2 07 17 9A
	fneg.d	FP1,FP2			; F2 01 15 1A

	fsneg	FP7			; F2 07 17 DA
	fsneg	FP1,FP2			; F2 01 15 5A

	fsneg.d	FP7			; F2 07 17 DA
	fsneg.d	FP1,FP2			; F2 01 15 5A

	fdneg	FP7			; F2 07 17 DE
	fdneg	FP1,FP2			; F2 01 15 5E

	fdneg.d	FP7			; F2 07 17 DE
	fdneg.d	FP1,FP2			; F2 01 15 5E

	fsqrt	FP7			; F2 07 17 84
	fsqrt	FP1,FP2			; F2 01 15 04

	fsqrt.d	FP7			; F2 07 17 84
	fsqrt.d	FP1,FP2			; F2 01 15 04

	fssqrt	FP7			; F2 07 17 C1
	fssqrt	FP1,FP2			; F2 01 15 41

	fssqrt.d	FP7		; F2 07 17 C1
	fssqrt.d	FP1,FP2		; F2 01 15 41

	fdsqrt	FP7			; F2 07 17 C5
	fdsqrt	FP1,FP2			; F2 01 15 45

	fdsqrt.d	FP7		; F2 07 17 C5
	fdsqrt.d	FP1,FP2		; F2 01 15 45

	fabs	(A0),FP1		; F2 10 54 98
	fabs	(A1)+,FP2		; F2 19 55 18
	fabs	-(A2),FP3		; F2 22 55 98
	fabs	(1,A3),FP4		; F2 2B 56 18 00 01
	fabs	(2,PC),FP5		; F2 3A 56 98 FF FE

	fabs.b	D0,FP0			; F2 00 58 18
	fabs.b	(A0),FP1		; F2 10 58 98
	fabs.b	(A1)+,FP2		; F2 19 59 18
	fabs.b	-(A2),FP3		; F2 22 59 98
	fabs.b	(1,A3),FP4		; F2 2B 5A 18 00 01
	fabs.b	(2,PC),FP5		; F2 3A 5A 98 FF FE

	fabs.w	D0,FP0			; F2 00 50 18
	fabs.w	(A0),FP1		; F2 10 50 98
	fabs.w	(A1)+,FP2		; F2 19 51 18
	fabs.w	-(A2),FP3		; F2 22 51 98
	fabs.w	(1,A3),FP4		; F2 2B 52 18 00 01
	fabs.w	(2,PC),FP5		; F2 3A 52 98 FF FE

	fabs.l	D0,FP0			; F2 00 40 18
	fabs.l	(A0),FP1		; F2 10 40 98
	fabs.l	(A1)+,FP2		; F2 19 41 18
	fabs.l	-(A2),FP3		; F2 22 41 98
	fabs.l	(1,A3),FP4		; F2 2B 42 18 00 01
	fabs.l	(2,PC),FP5		; F2 3A 42 98 FF FE

	fabs.s	D0,FP0			; F2 00 44 18
	fabs.s	(A0),FP1		; F2 10 44 98
	fabs.s	(A1)+,FP2		; F2 19 45 18
	fabs.s	-(A2),FP3		; F2 22 45 98
	fabs.s	(1,A3),FP4		; F2 2B 46 18 00 01
	fabs.s	(2,PC),FP5		; F2 3A 46 98 FF FE

	fabs.d	(A0),FP1		; F2 10 54 98
	fabs.d	(A1)+,FP2		; F2 19 55 18
	fabs.d	-(A2),FP3		; F2 22 55 98
	fabs.d	(1,A3),FP4		; F2 2B 56 18 00 01
	fabs.d	(2,PC),FP5		; F2 3A 56 98 FF FE

	fsabs	(A0),FP1		; F2 10 54 D8
	fsabs	(A1)+,FP2		; F2 19 55 58
	fsabs	-(A2),FP3		; F2 22 55 D8
	fsabs	(1,A3),FP4		; F2 2B 56 58 00 01
	fsabs	(2,PC),FP5		; F2 3A 56 D8 FF FE

	fsabs.b	D0,FP0			; F2 00 58 58
	fsabs.b	(A0),FP1		; F2 10 58 D8
	fsabs.b	(A1)+,FP2		; F2 19 59 58
	fsabs.b	-(A2),FP3		; F2 22 59 D8
	fsabs.b	(1,A3),FP4		; F2 2B 5A 58 00 01
	fsabs.b	(2,PC),FP5		; F2 3A 5A D8 FF FE

	fsabs.w	D0,FP0			; F2 00 50 58
	fsabs.w	(A0),FP1		; F2 10 50 D8
	fsabs.w	(A1)+,FP2		; F2 19 51 58
	fsabs.w	-(A2),FP3		; F2 22 51 D8
	fsabs.w	(1,A3),FP4		; F2 2B 52 58 00 01
	fsabs.w	(2,PC),FP5		; F2 3A 52 D8 FF FE

	fsabs.l	D0,FP0			; F2 00 40 58
	fsabs.l	(A0),FP1		; F2 10 40 D8
	fsabs.l	(A1)+,FP2		; F2 19 41 58
	fsabs.l	-(A2),FP3		; F2 22 41 D8
	fsabs.l	(1,A3),FP4		; F2 2B 42 58 00 01
	fsabs.l	(2,PC),FP5		; F2 3A 42 D8 FF FE

	fsabs.s	D0,FP0			; F2 00 44 58
	fsabs.s	(A0),FP1		; F2 10 44 D8
	fsabs.s	(A1)+,FP2		; F2 19 45 58
	fsabs.s	-(A2),FP3		; F2 22 45 D8
	fsabs.s	(1,A3),FP4		; F2 2B 46 58 00 01
	fsabs.s	(2,PC),FP5		; F2 3A 46 D8 FF FE

	fsabs.d	(A0),FP1		; F2 10 54 D8
	fsabs.d	(A1)+,FP2		; F2 19 55 58
	fsabs.d	-(A2),FP3		; F2 22 55 D8
	fsabs.d	(1,A3),FP4		; F2 2B 56 58 00 01
	fsabs.d	(2,PC),FP5		; F2 3A 56 D8 FF FE

	fdabs	(A0),FP1		; F2 10 54 DC
	fdabs	(A1)+,FP2		; F2 19 55 5C
	fdabs	-(A2),FP3		; F2 22 55 DC
	fdabs	(1,A3),FP4		; F2 2B 56 5C 00 01
	fdabs	(2,PC),FP5		; F2 3A 56 DC FF FE

	fdabs.b	D0,FP0			; F2 00 58 5C
	fdabs.b	(A0),FP1		; F2 10 58 DC
	fdabs.b	(A1)+,FP2		; F2 19 59 5C
	fdabs.b	-(A2),FP3		; F2 22 59 DC
	fdabs.b	(1,A3),FP4		; F2 2B 5A 5C 00 01
	fdabs.b	(2,PC),FP5		; F2 3A 5A DC FF FE

	fdabs.w	D0,FP0			; F2 00 50 5C
	fdabs.w	(A0),FP1		; F2 10 50 DC
	fdabs.w	(A1)+,FP2		; F2 19 51 5C
	fdabs.w	-(A2),FP3		; F2 22 51 DC
	fdabs.w	(1,A3),FP4		; F2 2B 52 5C 00 01
	fdabs.w	(2,PC),FP5		; F2 3A 52 DC FF FE

	fdabs.l	D0,FP0			; F2 00 40 5C
	fdabs.l	(A0),FP1		; F2 10 40 DC
	fdabs.l	(A1)+,FP2		; F2 19 41 5C
	fdabs.l	-(A2),FP3		; F2 22 41 DC
	fdabs.l	(1,A3),FP4		; F2 2B 42 5C 00 01
	fdabs.l	(2,PC),FP5		; F2 3A 42 DC FF FE

	fdabs.s	D0,FP0			; F2 00 44 5C
	fdabs.s	(A0),FP1		; F2 10 44 DC
	fdabs.s	(A1)+,FP2		; F2 19 45 5C
	fdabs.s	-(A2),FP3		; F2 22 45 DC
	fdabs.s	(1,A3),FP4		; F2 2B 46 5C 00 01
	fdabs.s	(2,PC),FP5		; F2 3A 46 DC FF FE

	fdabs.d	(A0),FP1		; F2 10 54 DC
	fdabs.d	(A1)+,FP2		; F2 19 55 5C
	fdabs.d	-(A2),FP3		; F2 22 55 DC
	fdabs.d	(1,A3),FP4		; F2 2B 56 5C 00 01
	fdabs.d	(2,PC),FP5		; F2 3A 56 DC FF FE

	fint	(A0),FP1		; F2 10 54 81
	fint	(A1)+,FP2		; F2 19 55 01
	fint	-(A2),FP3		; F2 22 55 81
	fint	(1,A3),FP4		; F2 2B 56 01 00 01
	fint	(2,PC),FP5		; F2 3A 56 81 FF FE

	fint.b	D0,FP0			; F2 00 58 01
	fint.b	(A0),FP1		; F2 10 58 81
	fint.b	(A1)+,FP2		; F2 19 59 01
	fint.b	-(A2),FP3		; F2 22 59 81
	fint.b	(1,A3),FP4		; F2 2B 5A 01 00 01
	fint.b	(2,PC),FP5		; F2 3A 5A 81 FF FE

	fint.w	D0,FP0			; F2 00 50 01
	fint.w	(A0),FP1		; F2 10 50 81
	fint.w	(A1)+,FP2		; F2 19 51 01
	fint.w	-(A2),FP3		; F2 22 51 81
	fint.w	(1,A3),FP4		; F2 2B 52 01 00 01
	fint.w	(2,PC),FP5		; F2 3A 52 81 FF FE

	fint.l	D0,FP0			; F2 00 40 01
	fint.l	(A0),FP1		; F2 10 40 81
	fint.l	(A1)+,FP2		; F2 19 41 01
	fint.l	-(A2),FP3		; F2 22 41 81
	fint.l	(1,A3),FP4		; F2 2B 42 01 00 01
	fint.l	(2,PC),FP5		; F2 3A 42 81 FF FE

	fint.s	D0,FP0			; F2 00 44 01
	fint.s	(A0),FP1		; F2 10 44 81
	fint.s	(A1)+,FP2		; F2 19 45 01
	fint.s	-(A2),FP3		; F2 22 45 81
	fint.s	(1,A3),FP4		; F2 2B 46 01 00 01
	fint.s	(2,PC),FP5		; F2 3A 46 81 FF FE

	fint.d	(A0),FP1		; F2 10 54 81
	fint.d	(A1)+,FP2		; F2 19 55 01
	fint.d	-(A2),FP3		; F2 22 55 81
	fint.d	(1,A3),FP4		; F2 2B 56 01 00 01
	fint.d	(2,PC),FP5		; F2 3A 56 81 FF FE

	fintrz	(A0),FP1		; F2 10 54 83
	fintrz	(A1)+,FP2		; F2 19 55 03
	fintrz	-(A2),FP3		; F2 22 55 83
	fintrz	(1,A3),FP4		; F2 2B 56 03 00 01
	fintrz	(2,PC),FP5		; F2 3A 56 83 FF FE

	fintrz.b	D0,FP0		; F2 00 58 03
	fintrz.b	(A0),FP1	; F2 10 58 83
	fintrz.b	(A1)+,FP2	; F2 19 59 03
	fintrz.b	-(A2),FP3	; F2 22 59 83
	fintrz.b	(1,A3),FP4	; F2 2B 5A 03 00 01
	fintrz.b	(2,PC),FP5	; F2 3A 5A 83 FF FE

	fintrz.w	D0,FP0		; F2 00 50 03
	fintrz.w	(A0),FP1	; F2 10 50 83
	fintrz.w	(A1)+,FP2	; F2 19 51 03
	fintrz.w	-(A2),FP3	; F2 22 51 83
	fintrz.w	(1,A3),FP4	; F2 2B 52 03 00 01
	fintrz.w	(2,PC),FP5	; F2 3A 52 83 FF FE

	fintrz.l	D0,FP0		; F2 00 40 03
	fintrz.l	(A0),FP1	; F2 10 40 83
	fintrz.l	(A1)+,FP2	; F2 19 41 03
	fintrz.l	-(A2),FP3	; F2 22 41 83
	fintrz.l	(1,A3),FP4	; F2 2B 42 03 00 01
	fintrz.l	(2,PC),FP5	; F2 3A 42 83 FF FE

	fintrz.s	D0,FP0		; F2 00 44 03
	fintrz.s	(A0),FP1	; F2 10 44 83
	fintrz.s	(A1)+,FP2	; F2 19 45 03
	fintrz.s	-(A2),FP3	; F2 22 45 83
	fintrz.s	(1,A3),FP4	; F2 2B 46 03 00 01
	fintrz.s	(2,PC),FP5	; F2 3A 46 83 FF FE

	fintrz.d	(A0),FP1	; F2 10 54 83
	fintrz.d	(A1)+,FP2	; F2 19 55 03
	fintrz.d	-(A2),FP3	; F2 22 55 83
	fintrz.d	(1,A3),FP4	; F2 2B 56 03 00 01
	fintrz.d	(2,PC),FP5	; F2 3A 56 83 FF FE

	fneg	(A0),FP1		; F2 10 54 9A
	fneg	(A1)+,FP2		; F2 19 55 1A
	fneg	-(A2),FP3		; F2 22 55 9A
	fneg	(1,A3),FP4		; F2 2B 56 1A 00 01
	fneg	(2,PC),FP5		; F2 3A 56 9A FF FE

	fneg.b	D0,FP0			; F2 00 58 1A
	fneg.b	(A0),FP1		; F2 10 58 9A
	fneg.b	(A1)+,FP2		; F2 19 59 1A
	fneg.b	-(A2),FP3		; F2 22 59 9A
	fneg.b	(1,A3),FP4		; F2 2B 5A 1A 00 01
	fneg.b	(2,PC),FP5		; F2 3A 5A 9A FF FE

	fneg.w	D0,FP0			; F2 00 50 1A
	fneg.w	(A0),FP1		; F2 10 50 9A
	fneg.w	(A1)+,FP2		; F2 19 51 1A
	fneg.w	-(A2),FP3		; F2 22 51 9A
	fneg.w	(1,A3),FP4		; F2 2B 52 1A 00 01
	fneg.w	(2,PC),FP5		; F2 3A 52 9A FF FE

	fneg.l	D0,FP0			; F2 00 40 1A
	fneg.l	(A0),FP1		; F2 10 40 9A
	fneg.l	(A1)+,FP2		; F2 19 41 1A
	fneg.l	-(A2),FP3		; F2 22 41 9A
	fneg.l	(1,A3),FP4		; F2 2B 42 1A 00 01
	fneg.l	(2,PC),FP5		; F2 3A 42 9A FF FE

	fneg.s	D0,FP0			; F2 00 44 1A
	fneg.s	(A0),FP1		; F2 10 44 9A
	fneg.s	(A1)+,FP2		; F2 19 45 1A
	fneg.s	-(A2),FP3		; F2 22 45 9A
	fneg.s	(1,A3),FP4		; F2 2B 46 1A 00 01
	fneg.s	(2,PC),FP5		; F2 3A 46 9A FF FE

	fneg.d	(A0),FP1		; F2 10 54 9A
	fneg.d	(A1)+,FP2		; F2 19 55 1A
	fneg.d	-(A2),FP3		; F2 22 55 9A
	fneg.d	(1,A3),FP4		; F2 2B 56 1A 00 01
	fneg.d	(2,PC),FP5		; F2 3A 56 9A FF FE

	fsneg	(A0),FP1		; F2 10 54 DA
	fsneg	(A1)+,FP2		; F2 19 55 5A
	fsneg	-(A2),FP3		; F2 22 55 DA
	fsneg	(1,A3),FP4		; F2 2B 56 5A 00 01
	fsneg	(2,PC),FP5		; F2 3A 56 DA FF FE

	fsneg.b	D0,FP0			; F2 00 58 5A
	fsneg.b	(A0),FP1		; F2 10 58 DA
	fsneg.b	(A1)+,FP2		; F2 19 59 5A
	fsneg.b	-(A2),FP3		; F2 22 59 DA
	fsneg.b	(1,A3),FP4		; F2 2B 5A 5A 00 01
	fsneg.b	(2,PC),FP5		; F2 3A 5A DA FF FE

	fsneg.w	D0,FP0			; F2 00 50 5A
	fsneg.w	(A0),FP1		; F2 10 50 DA
	fsneg.w	(A1)+,FP2		; F2 19 51 5A
	fsneg.w	-(A2),FP3		; F2 22 51 DA
	fsneg.w	(1,A3),FP4		; F2 2B 52 5A 00 01
	fsneg.w	(2,PC),FP5		; F2 3A 52 DA FF FE

	fsneg.l	D0,FP0			; F2 00 40 5A
	fsneg.l	(A0),FP1		; F2 10 40 DA
	fsneg.l	(A1)+,FP2		; F2 19 41 5A
	fsneg.l	-(A2),FP3		; F2 22 41 DA
	fsneg.l	(1,A3),FP4		; F2 2B 42 5A 00 01
	fsneg.l	(2,PC),FP5		; F2 3A 42 DA FF FE

	fsneg.s	D0,FP0			; F2 00 44 5A
	fsneg.s	(A0),FP1		; F2 10 44 DA
	fsneg.s	(A1)+,FP2		; F2 19 45 5A
	fsneg.s	-(A2),FP3		; F2 22 45 DA
	fsneg.s	(1,A3),FP4		; F2 2B 46 5A 00 01
	fsneg.s	(2,PC),FP5		; F2 3A 46 DA FF FE

	fsneg.d	(A0),FP1		; F2 10 54 DA
	fsneg.d	(A1)+,FP2		; F2 19 55 5A
	fsneg.d	-(A2),FP3		; F2 22 55 DA
	fsneg.d	(1,A3),FP4		; F2 2B 56 5A 00 01
	fsneg.d	(2,PC),FP5		; F2 3A 56 DA FF FE

	fdneg	(A0),FP1		; F2 10 54 DE
	fdneg	(A1)+,FP2		; F2 19 55 5E
	fdneg	-(A2),FP3		; F2 22 55 DE
	fdneg	(1,A3),FP4		; F2 2B 56 5E 00 01
	fdneg	(2,PC),FP5		; F2 3A 56 DE FF FE

	fdneg.b	D0,FP0			; F2 00 58 5E
	fdneg.b	(A0),FP1		; F2 10 58 DE
	fdneg.b	(A1)+,FP2		; F2 19 59 5E
	fdneg.b	-(A2),FP3		; F2 22 59 DE
	fdneg.b	(1,A3),FP4		; F2 2B 5A 5E 00 01
	fdneg.b	(2,PC),FP5		; F2 3A 5A DE FF FE

	fdneg.w	D0,FP0			; F2 00 50 5E
	fdneg.w	(A0),FP1		; F2 10 50 DE
	fdneg.w	(A1)+,FP2		; F2 19 51 5E
	fdneg.w	-(A2),FP3		; F2 22 51 DE
	fdneg.w	(1,A3),FP4		; F2 2B 52 5E 00 01
	fdneg.w	(2,PC),FP5		; F2 3A 52 DE FF FE

	fdneg.l	D0,FP0			; F2 00 40 5E
	fdneg.l	(A0),FP1		; F2 10 40 DE
	fdneg.l	(A1)+,FP2		; F2 19 41 5E
	fdneg.l	-(A2),FP3		; F2 22 41 DE
	fdneg.l	(1,A3),FP4		; F2 2B 42 5E 00 01
	fdneg.l	(2,PC),FP5		; F2 3A 42 DE FF FE

	fdneg.s	D0,FP0			; F2 00 44 5E
	fdneg.s	(A0),FP1		; F2 10 44 DE
	fdneg.s	(A1)+,FP2		; F2 19 45 5E
	fdneg.s	-(A2),FP3		; F2 22 45 DE
	fdneg.s	(1,A3),FP4		; F2 2B 46 5E 00 01
	fdneg.s	(2,PC),FP5		; F2 3A 46 DE FF FE

	fdneg.d	(A0),FP1		; F2 10 54 DE
	fdneg.d	(A1)+,FP2		; F2 19 55 5E
	fdneg.d	-(A2),FP3		; F2 22 55 DE
	fdneg.d	(1,A3),FP4		; F2 2B 56 5E 00 01
	fdneg.d	(2,PC),FP5		; F2 3A 56 DE FF FE

	fsqrt	(A0),FP1		; F2 10 54 84
	fsqrt	(A1)+,FP2		; F2 19 55 04
	fsqrt	-(A2),FP3		; F2 22 55 84
	fsqrt	(1,A3),FP4		; F2 2B 56 04 00 01
	fsqrt	(2,PC),FP5		; F2 3A 56 84 FF FE

	fsqrt.b	D0,FP0			; F2 00 58 04
	fsqrt.b	(A0),FP1		; F2 10 58 84
	fsqrt.b	(A1)+,FP2		; F2 19 59 04
	fsqrt.b	-(A2),FP3		; F2 22 59 84
	fsqrt.b	(1,A3),FP4		; F2 2B 5A 04 00 01
	fsqrt.b	(2,PC),FP5		; F2 3A 5A 84 FF FE

	fsqrt.w	D0,FP0			; F2 00 50 04
	fsqrt.w	(A0),FP1		; F2 10 50 84
	fsqrt.w	(A1)+,FP2		; F2 19 51 04
	fsqrt.w	-(A2),FP3		; F2 22 51 84
	fsqrt.w	(1,A3),FP4		; F2 2B 52 04 00 01
	fsqrt.w	(2,PC),FP5		; F2 3A 52 84 FF FE

	fsqrt.l	D0,FP0			; F2 00 40 04
	fsqrt.l	(A0),FP1		; F2 10 40 84
	fsqrt.l	(A1)+,FP2		; F2 19 41 04
	fsqrt.l	-(A2),FP3		; F2 22 41 84
	fsqrt.l	(1,A3),FP4		; F2 2B 42 04 00 01
	fsqrt.l	(2,PC),FP5		; F2 3A 42 84 FF FE

	fsqrt.s	D0,FP0			; F2 00 44 04
	fsqrt.s	(A0),FP1		; F2 10 44 84
	fsqrt.s	(A1)+,FP2		; F2 19 45 04
	fsqrt.s	-(A2),FP3		; F2 22 45 84
	fsqrt.s	(1,A3),FP4		; F2 2B 46 04 00 01
	fsqrt.s	(2,PC),FP5		; F2 3A 46 84 FF FE

	fsqrt.d	(A0),FP1		; F2 10 54 84
	fsqrt.d	(A1)+,FP2		; F2 19 55 04
	fsqrt.d	-(A2),FP3		; F2 22 55 84
	fsqrt.d	(1,A3),FP4		; F2 2B 56 04 00 01
	fsqrt.d	(2,PC),FP5		; F2 3A 56 84 FF FE

	fssqrt	(A0),FP1		; F2 10 54 C1
	fssqrt	(A1)+,FP2		; F2 19 55 41
	fssqrt	-(A2),FP3		; F2 22 55 C1
	fssqrt	(1,A3),FP4		; F2 2B 56 41 00 01
	fssqrt	(2,PC),FP5		; F2 3A 56 C1 FF FE

	fssqrt.b	D0,FP0		; F2 00 58 41
	fssqrt.b	(A0),FP1	; F2 10 58 C1
	fssqrt.b	(A1)+,FP2	; F2 19 59 41
	fssqrt.b	-(A2),FP3	; F2 22 59 C1
	fssqrt.b	(1,A3),FP4	; F2 2B 5A 41 00 01
	fssqrt.b	(2,PC),FP5	; F2 3A 5A C1 FF FE

	fssqrt.w	D0,FP0		; F2 00 50 41
	fssqrt.w	(A0),FP1	; F2 10 50 C1
	fssqrt.w	(A1)+,FP2	; F2 19 51 41
	fssqrt.w	-(A2),FP3	; F2 22 51 C1
	fssqrt.w	(1,A3),FP4	; F2 2B 52 41 00 01
	fssqrt.w	(2,PC),FP5	; F2 3A 52 C1 FF FE

	fssqrt.l	D0,FP0		; F2 00 40 41
	fssqrt.l	(A0),FP1	; F2 10 40 C1
	fssqrt.l	(A1)+,FP2	; F2 19 41 41
	fssqrt.l	-(A2),FP3	; F2 22 41 C1
	fssqrt.l	(1,A3),FP4	; F2 2B 42 41 00 01
	fssqrt.l	(2,PC),FP5	; F2 3A 42 C1 FF FE

	fssqrt.s	D0,FP0		; F2 00 44 41
	fssqrt.s	(A0),FP1	; F2 10 44 C1
	fssqrt.s	(A1)+,FP2	; F2 19 45 41
	fssqrt.s	-(A2),FP3	; F2 22 45 C1
	fssqrt.s	(1,A3),FP4	; F2 2B 46 41 00 01
	fssqrt.s	(2,PC),FP5	; F2 3A 46 C1 FF FE

	fssqrt.d	(A0),FP1	; F2 10 54 C1
	fssqrt.d	(A1)+,FP2	; F2 19 55 41
	fssqrt.d	-(A2),FP3	; F2 22 55 C1
	fssqrt.d	(1,A3),FP4	; F2 2B 56 41 00 01
	fssqrt.d	(2,PC),FP5	; F2 3A 56 C1 FF FE

	fdsqrt	(A0),FP1		; F2 10 54 C5
	fdsqrt	(A1)+,FP2		; F2 19 55 45
	fdsqrt	-(A2),FP3		; F2 22 55 C5
	fdsqrt	(1,A3),FP4		; F2 2B 56 45 00 01
	fdsqrt	(2,PC),FP5		; F2 3A 56 C5 FF FE

	fdsqrt.b	D0,FP0		; F2 00 58 45
	fdsqrt.b	(A0),FP1	; F2 10 58 C5
	fdsqrt.b	(A1)+,FP2	; F2 19 59 45
	fdsqrt.b	-(A2),FP3	; F2 22 59 C5
	fdsqrt.b	(1,A3),FP4	; F2 2B 5A 45 00 01
	fdsqrt.b	(2,PC),FP5	; F2 3A 5A C5 FF FE

	fdsqrt.w	D0,FP0		; F2 00 50 45
	fdsqrt.w	(A0),FP1	; F2 10 50 C5
	fdsqrt.w	(A1)+,FP2	; F2 19 51 45
	fdsqrt.w	-(A2),FP3	; F2 22 51 C5
	fdsqrt.w	(1,A3),FP4	; F2 2B 52 45 00 01
	fdsqrt.w	(2,PC),FP5	; F2 3A 52 C5 FF FE

	fdsqrt.l	D0,FP0		; F2 00 40 45
	fdsqrt.l	(A0),FP1	; F2 10 40 C5
	fdsqrt.l	(A1)+,FP2	; F2 19 41 45
	fdsqrt.l	-(A2),FP3	; F2 22 41 C5
	fdsqrt.l	(1,A3),FP4	; F2 2B 42 45 00 01
	fdsqrt.l	(2,PC),FP5	; F2 3A 42 C5 FF FE

	fdsqrt.s	D0,FP0		; F2 00 44 45
	fdsqrt.s	(A0),FP1	; F2 10 44 C5
	fdsqrt.s	(A1)+,FP2	; F2 19 45 45
	fdsqrt.s	-(A2),FP3	; F2 22 45 C5
	fdsqrt.s	(1,A3),FP4	; F2 2B 46 45 00 01
	fdsqrt.s	(2,PC),FP5	; F2 3A 46 C5 FF FE

	fdsqrt.d	(A0),FP1	; F2 10 54 C5
	fdsqrt.d	(A1)+,FP2	; F2 19 55 45
	fdsqrt.d	-(A2),FP3	; F2 22 55 C5
	fdsqrt.d	(1,A3),FP4	; F2 2B 56 45 00 01
	fdsqrt.d	(2,PC),FP5	; F2 3A 56 C5 FF FE


	.sbttl	Type F_TYP2 Instructions: FADD, FCMP, FDIV, FMUL, FSUB

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  F_TYP2:						*
	;*	FADD, FCMP, FDIV, FMUL, FSUB			*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	fadd	FP1,FP2			; F2 01 15 22

	fadd.d	FP1,FP2			; F2 01 15 22

	fsadd	FP1,FP2			; F2 01 15 62

	fsadd.d	FP1,FP2			; F2 01 15 62

	fdadd	FP1,FP2			; F2 01 15 66

	fdadd.d	FP1,FP2			; F2 01 15 66

	fcmp	FP1,FP2			; F2 01 15 38

	fcmp.d	FP1,FP2			; F2 01 15 38

	fdiv	FP1,FP2			; F2 01 15 20

	fdiv.d	FP1,FP2			; F2 01 15 20

	fsdiv	FP1,FP2			; F2 01 15 60

	fsdiv.d	FP1,FP2			; F2 01 15 60

	fddiv	FP1,FP2			; F2 01 15 64

	fddiv.d	FP1,FP2			; F2 01 15 64

	fmul	FP1,FP2			; F2 01 15 23

	fmul.d	FP1,FP2			; F2 01 15 23

	fsmul	FP1,FP2			; F2 01 15 63

	fsmul.d	FP1,FP2			; F2 01 15 63

	fdmul	FP1,FP2			; F2 01 15 67

	fdmul.d	FP1,FP2			; F2 01 15 67

	fsub	FP1,FP2			; F2 01 15 28

	fsub.d	FP1,FP2			; F2 01 15 28

	fssub	FP1,FP2			; F2 01 15 68

	fssub.d	FP1,FP2			; F2 01 15 68

	fdsub	FP1,FP2			; F2 01 15 6C

	fdsub.d	FP1,FP2			; F2 01 15 6C

	fadd	(A0),FP1		; F2 10 54 A2
	fadd	(A1)+,FP2		; F2 19 55 22
	fadd	-(A2),FP3		; F2 22 55 A2
	fadd	(1,A3),FP4		; F2 2B 56 22 00 01
	fadd	(2,PC),FP5		; F2 3A 56 A2 FF FE

	fadd.b	D0,FP0			; F2 00 58 22
	fadd.b	(A0),FP1		; F2 10 58 A2
	fadd.b	(A1)+,FP2		; F2 19 59 22
	fadd.b	-(A2),FP3		; F2 22 59 A2
	fadd.b	(1,A3),FP4		; F2 2B 5A 22 00 01
	fadd.b	(2,PC),FP5		; F2 3A 5A A2 FF FE

	fadd.w	D0,FP0			; F2 00 50 22
	fadd.w	(A0),FP1		; F2 10 50 A2
	fadd.w	(A1)+,FP2		; F2 19 51 22
	fadd.w	-(A2),FP3		; F2 22 51 A2
	fadd.w	(1,A3),FP4		; F2 2B 52 22 00 01
	fadd.w	(2,PC),FP5		; F2 3A 52 A2 FF FE

	fadd.l	D0,FP0			; F2 00 40 22
	fadd.l	(A0),FP1		; F2 10 40 A2
	fadd.l	(A1)+,FP2		; F2 19 41 22
	fadd.l	-(A2),FP3		; F2 22 41 A2
	fadd.l	(1,A3),FP4		; F2 2B 42 22 00 01
	fadd.l	(2,PC),FP5		; F2 3A 42 A2 FF FE

	fadd.s	D0,FP0			; F2 00 44 22
	fadd.s	(A0),FP1		; F2 10 44 A2
	fadd.s	(A1)+,FP2		; F2 19 45 22
	fadd.s	-(A2),FP3		; F2 22 45 A2
	fadd.s	(1,A3),FP4		; F2 2B 46 22 00 01
	fadd.s	(2,PC),FP5		; F2 3A 46 A2 FF FE

	fadd.d	(A0),FP1		; F2 10 54 A2
	fadd.d	(A1)+,FP2		; F2 19 55 22
	fadd.d	-(A2),FP3		; F2 22 55 A2
	fadd.d	(1,A3),FP4		; F2 2B 56 22 00 01
	fadd.d	(2,PC),FP5		; F2 3A 56 A2 FF FE

	fsadd	(A0),FP1		; F2 10 54 E2
	fsadd	(A1)+,FP2		; F2 19 55 62
	fsadd	-(A2),FP3		; F2 22 55 E2
	fsadd	(1,A3),FP4		; F2 2B 56 62 00 01
	fsadd	(2,PC),FP5		; F2 3A 56 E2 FF FE

	fsadd.b	D0,FP0			; F2 00 58 62
	fsadd.b	(A0),FP1		; F2 10 58 E2
	fsadd.b	(A1)+,FP2		; F2 19 59 62
	fsadd.b	-(A2),FP3		; F2 22 59 E2
	fsadd.b	(1,A3),FP4		; F2 2B 5A 62 00 01
	fsadd.b	(2,PC),FP5		; F2 3A 5A E2 FF FE

	fsadd.w	D0,FP0			; F2 00 50 62
	fsadd.w	(A0),FP1		; F2 10 50 E2
	fsadd.w	(A1)+,FP2		; F2 19 51 62
	fsadd.w	-(A2),FP3		; F2 22 51 E2
	fsadd.w	(1,A3),FP4		; F2 2B 52 62 00 01
	fsadd.w	(2,PC),FP5		; F2 3A 52 E2 FF FE

	fsadd.l	D0,FP0			; F2 00 40 62
	fsadd.l	(A0),FP1		; F2 10 40 E2
	fsadd.l	(A1)+,FP2		; F2 19 41 62
	fsadd.l	-(A2),FP3		; F2 22 41 E2
	fsadd.l	(1,A3),FP4		; F2 2B 42 62 00 01
	fsadd.l	(2,PC),FP5		; F2 3A 42 E2 FF FE

	fsadd.s	D0,FP0			; F2 00 44 62
	fsadd.s	(A0),FP1		; F2 10 44 E2
	fsadd.s	(A1)+,FP2		; F2 19 45 62
	fsadd.s	-(A2),FP3		; F2 22 45 E2
	fsadd.s	(1,A3),FP4		; F2 2B 46 62 00 01
	fsadd.s	(2,PC),FP5		; F2 3A 46 E2 FF FE

	fsadd.d	(A0),FP1		; F2 10 54 E2
	fsadd.d	(A1)+,FP2		; F2 19 55 62
	fsadd.d	-(A2),FP3		; F2 22 55 E2
	fsadd.d	(1,A3),FP4		; F2 2B 56 62 00 01
	fsadd.d	(2,PC),FP5		; F2 3A 56 E2 FF FE

	fdadd	(A0),FP1		; F2 10 54 E6
	fdadd	(A1)+,FP2		; F2 19 55 66
	fdadd	-(A2),FP3		; F2 22 55 E6
	fdadd	(1,A3),FP4		; F2 2B 56 66 00 01
	fdadd	(2,PC),FP5		; F2 3A 56 E6 FF FE

	fdadd.b	D0,FP0			; F2 00 58 66
	fdadd.b	(A0),FP1		; F2 10 58 E6
	fdadd.b	(A1)+,FP2		; F2 19 59 66
	fdadd.b	-(A2),FP3		; F2 22 59 E6
	fdadd.b	(1,A3),FP4		; F2 2B 5A 66 00 01
	fdadd.b	(2,PC),FP5		; F2 3A 5A E6 FF FE

	fdadd.w	D0,FP0			; F2 00 50 66
	fdadd.w	(A0),FP1		; F2 10 50 E6
	fdadd.w	(A1)+,FP2		; F2 19 51 66
	fdadd.w	-(A2),FP3		; F2 22 51 E6
	fdadd.w	(1,A3),FP4		; F2 2B 52 66 00 01
	fdadd.w	(2,PC),FP5		; F2 3A 52 E6 FF FE

	fdadd.l	D0,FP0			; F2 00 40 66
	fdadd.l	(A0),FP1		; F2 10 40 E6
	fdadd.l	(A1)+,FP2		; F2 19 41 66
	fdadd.l	-(A2),FP3		; F2 22 41 E6
	fdadd.l	(1,A3),FP4		; F2 2B 42 66 00 01
	fdadd.l	(2,PC),FP5		; F2 3A 42 E6 FF FE

	fdadd.s	D0,FP0			; F2 00 44 66
	fdadd.s	(A0),FP1		; F2 10 44 E6
	fdadd.s	(A1)+,FP2		; F2 19 45 66
	fdadd.s	-(A2),FP3		; F2 22 45 E6
	fdadd.s	(1,A3),FP4		; F2 2B 46 66 00 01
	fdadd.s	(2,PC),FP5		; F2 3A 46 E6 FF FE

	fdadd.d	(A0),FP1		; F2 10 54 E6
	fdadd.d	(A1)+,FP2		; F2 19 55 66
	fdadd.d	-(A2),FP3		; F2 22 55 E6
	fdadd.d	(1,A3),FP4		; F2 2B 56 66 00 01
	fdadd.d	(2,PC),FP5		; F2 3A 56 E6 FF FE

	fcmp	(A0),FP1		; F2 10 54 B8
	fcmp	(A1)+,FP2		; F2 19 55 38
	fcmp	-(A2),FP3		; F2 22 55 B8
	fcmp	(1,A3),FP4		; F2 2B 56 38 00 01
	fcmp	(2,PC),FP5		; F2 3A 56 B8 FF FE

	fcmp.b	D0,FP0			; F2 00 58 38
	fcmp.b	(A0),FP1		; F2 10 58 B8
	fcmp.b	(A1)+,FP2		; F2 19 59 38
	fcmp.b	-(A2),FP3		; F2 22 59 B8
	fcmp.b	(1,A3),FP4		; F2 2B 5A 38 00 01
	fcmp.b	(2,PC),FP5		; F2 3A 5A B8 FF FE

	fcmp.w	D0,FP0			; F2 00 50 38
	fcmp.w	(A0),FP1		; F2 10 50 B8
	fcmp.w	(A1)+,FP2		; F2 19 51 38
	fcmp.w	-(A2),FP3		; F2 22 51 B8
	fcmp.w	(1,A3),FP4		; F2 2B 52 38 00 01
	fcmp.w	(2,PC),FP5		; F2 3A 52 B8 FF FE

	fcmp.l	D0,FP0			; F2 00 40 38
	fcmp.l	(A0),FP1		; F2 10 40 B8
	fcmp.l	(A1)+,FP2		; F2 19 41 38
	fcmp.l	-(A2),FP3		; F2 22 41 B8
	fcmp.l	(1,A3),FP4		; F2 2B 42 38 00 01
	fcmp.l	(2,PC),FP5		; F2 3A 42 B8 FF FE

	fcmp.s	D0,FP0			; F2 00 44 38
	fcmp.s	(A0),FP1		; F2 10 44 B8
	fcmp.s	(A1)+,FP2		; F2 19 45 38
	fcmp.s	-(A2),FP3		; F2 22 45 B8
	fcmp.s	(1,A3),FP4		; F2 2B 46 38 00 01
	fcmp.s	(2,PC),FP5		; F2 3A 46 B8 FF FE

	fcmp.d	(A0),FP1		; F2 10 54 B8
	fcmp.d	(A1)+,FP2		; F2 19 55 38
	fcmp.d	-(A2),FP3		; F2 22 55 B8
	fcmp.d	(1,A3),FP4		; F2 2B 56 38 00 01
	fcmp.d	(2,PC),FP5		; F2 3A 56 B8 FF FE

	fdiv	(A0),FP1		; F2 10 54 A0
	fdiv	(A1)+,FP2		; F2 19 55 20
	fdiv	-(A2),FP3		; F2 22 55 A0
	fdiv	(1,A3),FP4		; F2 2B 56 20 00 01
	fdiv	(2,PC),FP5		; F2 3A 56 A0 FF FE

	fdiv.b	D0,FP0			; F2 00 58 20
	fdiv.b	(A0),FP1		; F2 10 58 A0
	fdiv.b	(A1)+,FP2		; F2 19 59 20
	fdiv.b	-(A2),FP3		; F2 22 59 A0
	fdiv.b	(1,A3),FP4		; F2 2B 5A 20 00 01
	fdiv.b	(2,PC),FP5		; F2 3A 5A A0 FF FE

	fdiv.w	D0,FP0			; F2 00 50 20
	fdiv.w	(A0),FP1		; F2 10 50 A0
	fdiv.w	(A1)+,FP2		; F2 19 51 20
	fdiv.w	-(A2),FP3		; F2 22 51 A0
	fdiv.w	(1,A3),FP4		; F2 2B 52 20 00 01
	fdiv.w	(2,PC),FP5		; F2 3A 52 A0 FF FE

	fdiv.l	D0,FP0			; F2 00 40 20
	fdiv.l	(A0),FP1		; F2 10 40 A0
	fdiv.l	(A1)+,FP2		; F2 19 41 20
	fdiv.l	-(A2),FP3		; F2 22 41 A0
	fdiv.l	(1,A3),FP4		; F2 2B 42 20 00 01
	fdiv.l	(2,PC),FP5		; F2 3A 42 A0 FF FE

	fdiv.s	D0,FP0			; F2 00 44 20
	fdiv.s	(A0),FP1		; F2 10 44 A0
	fdiv.s	(A1)+,FP2		; F2 19 45 20
	fdiv.s	-(A2),FP3		; F2 22 45 A0
	fdiv.s	(1,A3),FP4		; F2 2B 46 20 00 01
	fdiv.s	(2,PC),FP5		; F2 3A 46 A0 FF FE

	fdiv.d	(A0),FP1		; F2 10 54 A0
	fdiv.d	(A1)+,FP2		; F2 19 55 20
	fdiv.d	-(A2),FP3		; F2 22 55 A0
	fdiv.d	(1,A3),FP4		; F2 2B 56 20 00 01
	fdiv.d	(2,PC),FP5		; F2 3A 56 A0 FF FE

	fsdiv	(A0),FP1		; F2 10 54 E0
	fsdiv	(A1)+,FP2		; F2 19 55 60
	fsdiv	-(A2),FP3		; F2 22 55 E0
	fsdiv	(1,A3),FP4		; F2 2B 56 60 00 01
	fsdiv	(2,PC),FP5		; F2 3A 56 E0 FF FE

	fsdiv.b	D0,FP0			; F2 00 58 60
	fsdiv.b	(A0),FP1		; F2 10 58 E0
	fsdiv.b	(A1)+,FP2		; F2 19 59 60
	fsdiv.b	-(A2),FP3		; F2 22 59 E0
	fsdiv.b	(1,A3),FP4		; F2 2B 5A 60 00 01
	fsdiv.b	(2,PC),FP5		; F2 3A 5A E0 FF FE

	fsdiv.w	D0,FP0			; F2 00 50 60
	fsdiv.w	(A0),FP1		; F2 10 50 E0
	fsdiv.w	(A1)+,FP2		; F2 19 51 60
	fsdiv.w	-(A2),FP3		; F2 22 51 E0
	fsdiv.w	(1,A3),FP4		; F2 2B 52 60 00 01
	fsdiv.w	(2,PC),FP5		; F2 3A 52 E0 FF FE

	fsdiv.l	D0,FP0			; F2 00 40 60
	fsdiv.l	(A0),FP1		; F2 10 40 E0
	fsdiv.l	(A1)+,FP2		; F2 19 41 60
	fsdiv.l	-(A2),FP3		; F2 22 41 E0
	fsdiv.l	(1,A3),FP4		; F2 2B 42 60 00 01
	fsdiv.l	(2,PC),FP5		; F2 3A 42 E0 FF FE

	fsdiv.s	D0,FP0			; F2 00 44 60
	fsdiv.s	(A0),FP1		; F2 10 44 E0
	fsdiv.s	(A1)+,FP2		; F2 19 45 60
	fsdiv.s	-(A2),FP3		; F2 22 45 E0
	fsdiv.s	(1,A3),FP4		; F2 2B 46 60 00 01
	fsdiv.s	(2,PC),FP5		; F2 3A 46 E0 FF FE

	fsdiv.d	(A0),FP1		; F2 10 54 E0
	fsdiv.d	(A1)+,FP2		; F2 19 55 60
	fsdiv.d	-(A2),FP3		; F2 22 55 E0
	fsdiv.d	(1,A3),FP4		; F2 2B 56 60 00 01
	fsdiv.d	(2,PC),FP5		; F2 3A 56 E0 FF FE

	fddiv	(A0),FP1		; F2 10 54 E4
	fddiv	(A1)+,FP2		; F2 19 55 64
	fddiv	-(A2),FP3		; F2 22 55 E4
	fddiv	(1,A3),FP4		; F2 2B 56 64 00 01
	fddiv	(2,PC),FP5		; F2 3A 56 E4 FF FE

	fddiv.b	D0,FP0			; F2 00 58 64
	fddiv.b	(A0),FP1		; F2 10 58 E4
	fddiv.b	(A1)+,FP2		; F2 19 59 64
	fddiv.b	-(A2),FP3		; F2 22 59 E4
	fddiv.b	(1,A3),FP4		; F2 2B 5A 64 00 01
	fddiv.b	(2,PC),FP5		; F2 3A 5A E4 FF FE

	fddiv.w	D0,FP0			; F2 00 50 64
	fddiv.w	(A0),FP1		; F2 10 50 E4
	fddiv.w	(A1)+,FP2		; F2 19 51 64
	fddiv.w	-(A2),FP3		; F2 22 51 E4
	fddiv.w	(1,A3),FP4		; F2 2B 52 64 00 01
	fddiv.w	(2,PC),FP5		; F2 3A 52 E4 FF FE

	fddiv.l	D0,FP0			; F2 00 40 64
	fddiv.l	(A0),FP1		; F2 10 40 E4
	fddiv.l	(A1)+,FP2		; F2 19 41 64
	fddiv.l	-(A2),FP3		; F2 22 41 E4
	fddiv.l	(1,A3),FP4		; F2 2B 42 64 00 01
	fddiv.l	(2,PC),FP5		; F2 3A 42 E4 FF FE

	fddiv.s	D0,FP0			; F2 00 44 64
	fddiv.s	(A0),FP1		; F2 10 44 E4
	fddiv.s	(A1)+,FP2		; F2 19 45 64
	fddiv.s	-(A2),FP3		; F2 22 45 E4
	fddiv.s	(1,A3),FP4		; F2 2B 46 64 00 01
	fddiv.s	(2,PC),FP5		; F2 3A 46 E4 FF FE

	fddiv.d	(A0),FP1		; F2 10 54 E4
	fddiv.d	(A1)+,FP2		; F2 19 55 64
	fddiv.d	-(A2),FP3		; F2 22 55 E4
	fddiv.d	(1,A3),FP4		; F2 2B 56 64 00 01
	fddiv.d	(2,PC),FP5		; F2 3A 56 E4 FF FE

	fmul	(A0),FP1		; F2 10 54 A3
	fmul	(A1)+,FP2		; F2 19 55 23
	fmul	-(A2),FP3		; F2 22 55 A3
	fmul	(1,A3),FP4		; F2 2B 56 23 00 01
	fmul	(2,PC),FP5		; F2 3A 56 A3 FF FE

	fmul.b	D0,FP0			; F2 00 58 23
	fmul.b	(A0),FP1		; F2 10 58 A3
	fmul.b	(A1)+,FP2		; F2 19 59 23
	fmul.b	-(A2),FP3		; F2 22 59 A3
	fmul.b	(1,A3),FP4		; F2 2B 5A 23 00 01
	fmul.b	(2,PC),FP5		; F2 3A 5A A3 FF FE

	fmul.w	D0,FP0			; F2 00 50 23
	fmul.w	(A0),FP1		; F2 10 50 A3
	fmul.w	(A1)+,FP2		; F2 19 51 23
	fmul.w	-(A2),FP3		; F2 22 51 A3
	fmul.w	(1,A3),FP4		; F2 2B 52 23 00 01
	fmul.w	(2,PC),FP5		; F2 3A 52 A3 FF FE

	fmul.l	D0,FP0			; F2 00 40 23
	fmul.l	(A0),FP1		; F2 10 40 A3
	fmul.l	(A1)+,FP2		; F2 19 41 23
	fmul.l	-(A2),FP3		; F2 22 41 A3
	fmul.l	(1,A3),FP4		; F2 2B 42 23 00 01
	fmul.l	(2,PC),FP5		; F2 3A 42 A3 FF FE

	fmul.s	D0,FP0			; F2 00 44 23
	fmul.s	(A0),FP1		; F2 10 44 A3
	fmul.s	(A1)+,FP2		; F2 19 45 23
	fmul.s	-(A2),FP3		; F2 22 45 A3
	fmul.s	(1,A3),FP4		; F2 2B 46 23 00 01
	fmul.s	(2,PC),FP5		; F2 3A 46 A3 FF FE

	fmul.d	(A0),FP1		; F2 10 54 A3
	fmul.d	(A1)+,FP2		; F2 19 55 23
	fmul.d	-(A2),FP3		; F2 22 55 A3
	fmul.d	(1,A3),FP4		; F2 2B 56 23 00 01
	fmul.d	(2,PC),FP5		; F2 3A 56 A3 FF FE

	fsmul	(A0),FP1		; F2 10 54 E3
	fsmul	(A1)+,FP2		; F2 19 55 63
	fsmul	-(A2),FP3		; F2 22 55 E3
	fsmul	(1,A3),FP4		; F2 2B 56 63 00 01
	fsmul	(2,PC),FP5		; F2 3A 56 E3 FF FE

	fsmul.b	D0,FP0			; F2 00 58 63
	fsmul.b	(A0),FP1		; F2 10 58 E3
	fsmul.b	(A1)+,FP2		; F2 19 59 63
	fsmul.b	-(A2),FP3		; F2 22 59 E3
	fsmul.b	(1,A3),FP4		; F2 2B 5A 63 00 01
	fsmul.b	(2,PC),FP5		; F2 3A 5A E3 FF FE

	fsmul.w	D0,FP0			; F2 00 50 63
	fsmul.w	(A0),FP1		; F2 10 50 E3
	fsmul.w	(A1)+,FP2		; F2 19 51 63
	fsmul.w	-(A2),FP3		; F2 22 51 E3
	fsmul.w	(1,A3),FP4		; F2 2B 52 63 00 01
	fsmul.w	(2,PC),FP5		; F2 3A 52 E3 FF FE

	fsmul.l	D0,FP0			; F2 00 40 63
	fsmul.l	(A0),FP1		; F2 10 40 E3
	fsmul.l	(A1)+,FP2		; F2 19 41 63
	fsmul.l	-(A2),FP3		; F2 22 41 E3
	fsmul.l	(1,A3),FP4		; F2 2B 42 63 00 01
	fsmul.l	(2,PC),FP5		; F2 3A 42 E3 FF FE

	fsmul.s	D0,FP0			; F2 00 44 63
	fsmul.s	(A0),FP1		; F2 10 44 E3
	fsmul.s	(A1)+,FP2		; F2 19 45 63
	fsmul.s	-(A2),FP3		; F2 22 45 E3
	fsmul.s	(1,A3),FP4		; F2 2B 46 63 00 01
	fsmul.s	(2,PC),FP5		; F2 3A 46 E3 FF FE

	fsmul.d	(A0),FP1		; F2 10 54 E3
	fsmul.d	(A1)+,FP2		; F2 19 55 63
	fsmul.d	-(A2),FP3		; F2 22 55 E3
	fsmul.d	(1,A3),FP4		; F2 2B 56 63 00 01
	fsmul.d	(2,PC),FP5		; F2 3A 56 E3 FF FE

	fdmul	(A0),FP1		; F2 10 54 E7
	fdmul	(A1)+,FP2		; F2 19 55 67
	fdmul	-(A2),FP3		; F2 22 55 E7
	fdmul	(1,A3),FP4		; F2 2B 56 67 00 01
	fdmul	(2,PC),FP5		; F2 3A 56 E7 FF FE

	fdmul.b	D0,FP0			; F2 00 58 67
	fdmul.b	(A0),FP1		; F2 10 58 E7
	fdmul.b	(A1)+,FP2		; F2 19 59 67
	fdmul.b	-(A2),FP3		; F2 22 59 E7
	fdmul.b	(1,A3),FP4		; F2 2B 5A 67 00 01
	fdmul.b	(2,PC),FP5		; F2 3A 5A E7 FF FE

	fdmul.w	D0,FP0			; F2 00 50 67
	fdmul.w	(A0),FP1		; F2 10 50 E7
	fdmul.w	(A1)+,FP2		; F2 19 51 67
	fdmul.w	-(A2),FP3		; F2 22 51 E7
	fdmul.w	(1,A3),FP4		; F2 2B 52 67 00 01
	fdmul.w	(2,PC),FP5		; F2 3A 52 E7 FF FE

	fdmul.l	D0,FP0			; F2 00 40 67
	fdmul.l	(A0),FP1		; F2 10 40 E7
	fdmul.l	(A1)+,FP2		; F2 19 41 67
	fdmul.l	-(A2),FP3		; F2 22 41 E7
	fdmul.l	(1,A3),FP4		; F2 2B 42 67 00 01
	fdmul.l	(2,PC),FP5		; F2 3A 42 E7 FF FE

	fdmul.s	D0,FP0			; F2 00 44 67
	fdmul.s	(A0),FP1		; F2 10 44 E7
	fdmul.s	(A1)+,FP2		; F2 19 45 67
	fdmul.s	-(A2),FP3		; F2 22 45 E7
	fdmul.s	(1,A3),FP4		; F2 2B 46 67 00 01
	fdmul.s	(2,PC),FP5		; F2 3A 46 E7 FF FE

	fdmul.d	(A0),FP1		; F2 10 54 E7
	fdmul.d	(A1)+,FP2		; F2 19 55 67
	fdmul.d	-(A2),FP3		; F2 22 55 E7
	fdmul.d	(1,A3),FP4		; F2 2B 56 67 00 01
	fdmul.d	(2,PC),FP5		; F2 3A 56 E7 FF FE

	fsub	(A0),FP1		; F2 10 54 A8
	fsub	(A1)+,FP2		; F2 19 55 28
	fsub	-(A2),FP3		; F2 22 55 A8
	fsub	(1,A3),FP4		; F2 2B 56 28 00 01
	fsub	(2,PC),FP5		; F2 3A 56 A8 FF FE

	fsub.b	D0,FP0			; F2 00 58 28
	fsub.b	(A0),FP1		; F2 10 58 A8
	fsub.b	(A1)+,FP2		; F2 19 59 28
	fsub.b	-(A2),FP3		; F2 22 59 A8
	fsub.b	(1,A3),FP4		; F2 2B 5A 28 00 01
	fsub.b	(2,PC),FP5		; F2 3A 5A A8 FF FE

	fsub.w	D0,FP0			; F2 00 50 28
	fsub.w	(A0),FP1		; F2 10 50 A8
	fsub.w	(A1)+,FP2		; F2 19 51 28
	fsub.w	-(A2),FP3		; F2 22 51 A8
	fsub.w	(1,A3),FP4		; F2 2B 52 28 00 01
	fsub.w	(2,PC),FP5		; F2 3A 52 A8 FF FE

	fsub.l	D0,FP0			; F2 00 40 28
	fsub.l	(A0),FP1		; F2 10 40 A8
	fsub.l	(A1)+,FP2		; F2 19 41 28
	fsub.l	-(A2),FP3		; F2 22 41 A8
	fsub.l	(1,A3),FP4		; F2 2B 42 28 00 01
	fsub.l	(2,PC),FP5		; F2 3A 42 A8 FF FE

	fsub.s	D0,FP0			; F2 00 44 28
	fsub.s	(A0),FP1		; F2 10 44 A8
	fsub.s	(A1)+,FP2		; F2 19 45 28
	fsub.s	-(A2),FP3		; F2 22 45 A8
	fsub.s	(1,A3),FP4		; F2 2B 46 28 00 01
	fsub.s	(2,PC),FP5		; F2 3A 46 A8 FF FE

	fsub.d	(A0),FP1		; F2 10 54 A8
	fsub.d	(A1)+,FP2		; F2 19 55 28
	fsub.d	-(A2),FP3		; F2 22 55 A8
	fsub.d	(1,A3),FP4		; F2 2B 56 28 00 01
	fsub.d	(2,PC),FP5		; F2 3A 56 A8 FF FE

	fssub	(A0),FP1		; F2 10 54 E8
	fssub	(A1)+,FP2		; F2 19 55 68
	fssub	-(A2),FP3		; F2 22 55 E8
	fssub	(1,A3),FP4		; F2 2B 56 68 00 01
	fssub	(2,PC),FP5		; F2 3A 56 E8 FF FE

	fssub.b	D0,FP0			; F2 00 58 68
	fssub.b	(A0),FP1		; F2 10 58 E8
	fssub.b	(A1)+,FP2		; F2 19 59 68
	fssub.b	-(A2),FP3		; F2 22 59 E8
	fssub.b	(1,A3),FP4		; F2 2B 5A 68 00 01
	fssub.b	(2,PC),FP5		; F2 3A 5A E8 FF FE

	fssub.w	D0,FP0			; F2 00 50 68
	fssub.w	(A0),FP1		; F2 10 50 E8
	fssub.w	(A1)+,FP2		; F2 19 51 68
	fssub.w	-(A2),FP3		; F2 22 51 E8
	fssub.w	(1,A3),FP4		; F2 2B 52 68 00 01
	fssub.w	(2,PC),FP5		; F2 3A 52 E8 FF FE

	fssub.l	D0,FP0			; F2 00 40 68
	fssub.l	(A0),FP1		; F2 10 40 E8
	fssub.l	(A1)+,FP2		; F2 19 41 68
	fssub.l	-(A2),FP3		; F2 22 41 E8
	fssub.l	(1,A3),FP4		; F2 2B 42 68 00 01
	fssub.l	(2,PC),FP5		; F2 3A 42 E8 FF FE

	fssub.s	D0,FP0			; F2 00 44 68
	fssub.s	(A0),FP1		; F2 10 44 E8
	fssub.s	(A1)+,FP2		; F2 19 45 68
	fssub.s	-(A2),FP3		; F2 22 45 E8
	fssub.s	(1,A3),FP4		; F2 2B 46 68 00 01
	fssub.s	(2,PC),FP5		; F2 3A 46 E8 FF FE

	fssub.d	(A0),FP1		; F2 10 54 E8
	fssub.d	(A1)+,FP2		; F2 19 55 68
	fssub.d	-(A2),FP3		; F2 22 55 E8
	fssub.d	(1,A3),FP4		; F2 2B 56 68 00 01
	fssub.d	(2,PC),FP5		; F2 3A 56 E8 FF FE

	fdsub	(A0),FP1		; F2 10 54 EC
	fdsub	(A1)+,FP2		; F2 19 55 6C
	fdsub	-(A2),FP3		; F2 22 55 EC
	fdsub	(1,A3),FP4		; F2 2B 56 6C 00 01
	fdsub	(2,PC),FP5		; F2 3A 56 EC FF FE

	fdsub.b	D0,FP0			; F2 00 58 6C
	fdsub.b	(A0),FP1		; F2 10 58 EC
	fdsub.b	(A1)+,FP2		; F2 19 59 6C
	fdsub.b	-(A2),FP3		; F2 22 59 EC
	fdsub.b	(1,A3),FP4		; F2 2B 5A 6C 00 01
	fdsub.b	(2,PC),FP5		; F2 3A 5A EC FF FE

	fdsub.w	D0,FP0			; F2 00 50 6C
	fdsub.w	(A0),FP1		; F2 10 50 EC
	fdsub.w	(A1)+,FP2		; F2 19 51 6C
	fdsub.w	-(A2),FP3		; F2 22 51 EC
	fdsub.w	(1,A3),FP4		; F2 2B 52 6C 00 01
	fdsub.w	(2,PC),FP5		; F2 3A 52 EC FF FE

	fdsub.l	D0,FP0			; F2 00 40 6C
	fdsub.l	(A0),FP1		; F2 10 40 EC
	fdsub.l	(A1)+,FP2		; F2 19 41 6C
	fdsub.l	-(A2),FP3		; F2 22 41 EC
	fdsub.l	(1,A3),FP4		; F2 2B 42 6C 00 01
	fdsub.l	(2,PC),FP5		; F2 3A 42 EC FF FE

	fdsub.s	D0,FP0			; F2 00 44 6C
	fdsub.s	(A0),FP1		; F2 10 44 EC
	fdsub.s	(A1)+,FP2		; F2 19 45 6C
	fdsub.s	-(A2),FP3		; F2 22 45 EC
	fdsub.s	(1,A3),FP4		; F2 2B 46 6C 00 01
	fdsub.s	(2,PC),FP5		; F2 3A 46 EC FF FE

	fdsub.d	(A0),FP1		; F2 10 54 EC
	fdsub.d	(A1)+,FP2		; F2 19 55 6C
	fdsub.d	-(A2),FP3		; F2 22 55 EC
	fdsub.d	(1,A3),FP4		; F2 2B 56 6C 00 01
	fdsub.d	(2,PC),FP5		; F2 3A 56 EC FF FE


	.sbttl	Type F_TST Instructions: FTST

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  F_TST:						*
	;*	FTST						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	ftst.d	FP0			; F2 00 00 3A

	ftst	(A0)			; F2 10 54 3A
	ftst	(A1)+			; F2 19 54 3A
	ftst	-(A2)			; F2 22 54 3A
	ftst	(1,A3)			; F2 2B 54 3A 00 01
	ftst	(2,PC)			; F2 3A 54 3A FF FE

	ftst.b	D0			; F2 00 58 3A
	ftst.b	(A0)			; F2 10 58 3A
	ftst.b	(A1)+			; F2 19 58 3A
	ftst.b	-(A2)			; F2 22 58 3A
	ftst.b	(1,A3)			; F2 2B 58 3A 00 01
	ftst.b	(2,PC)			; F2 3A 58 3A FF FE

	ftst.w	D0			; F2 00 50 3A
	ftst.w	(A0)			; F2 10 50 3A
	ftst.w	(A1)+			; F2 19 50 3A
	ftst.w	-(A2)			; F2 22 50 3A
	ftst.w	(1,A3)			; F2 2B 50 3A 00 01
	ftst.w	(2,PC)			; F2 3A 50 3A FF FE

	ftst.l	D0			; F2 00 40 3A
	ftst.l	(A0)			; F2 10 40 3A
	ftst.l	(A1)+			; F2 19 40 3A
	ftst.l	-(A2)			; F2 22 40 3A
	ftst.l	(1,A3)			; F2 2B 40 3A 00 01
	ftst.l	(2,PC)			; F2 3A 40 3A FF FE

	ftst.s	D0			; F2 00 44 3A
	ftst.s	(A0)			; F2 10 44 3A
	ftst.s	(A1)+			; F2 19 44 3A
	ftst.s	-(A2)			; F2 22 44 3A
	ftst.s	(1,A3)			; F2 2B 44 3A 00 01
	ftst.s	(2,PC)			; F2 3A 44 3A FF FE

	ftst.d	(A0)			; F2 10 54 3A
	ftst.d	(A1)+			; F2 19 54 3A
	ftst.d	-(A2)			; F2 22 54 3A
	ftst.d	(1,A3)			; F2 2B 54 3A 00 01
	ftst.d	(2,PC)			; F2 3A 54 3A FF FE


	.sbttl	Type F_MOV Instructions: FMOVE

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  F_MOV:						*
	;*	FMOVE						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	fmove	FP0,FP1			; F2 00 00 80

	fmove.d	FP0,FP1			; F2 00 00 80

	fsmove	FP0,FP1			; F2 00 00 C0

	fsmove.d	FP0,FP1		; F2 00 00 C0

	fdmove	FP0,FP1			; F2 00 00 C4

	fdmove.d	FP0,FP1		; F2 00 00 C4

	fmove	(A0),FP1		; F2 10 54 80
	fmove	(A1)+,FP2		; F2 19 55 00
	fmove	-(A2),FP3		; F2 22 55 80
	fmove	(1,A3),FP4		; F2 2B 56 00 00 01
	fmove	(2,PC),FP5		; F2 3A 56 80 FF FE

	fmove.b	D0,FP0			; F2 00 58 00
	fmove.b	(A0),FP1		; F2 10 58 80
	fmove.b	(A1)+,FP2		; F2 19 59 00
	fmove.b	-(A2),FP3		; F2 22 59 80
	fmove.b	(1,A3),FP4		; F2 2B 5A 00 00 01
	fmove.b	(2,PC),FP5		; F2 3A 5A 80 FF FE

	fmove.w	D0,FP0			; F2 00 50 00
	fmove.w	(A0),FP1		; F2 10 50 80
	fmove.w	(A1)+,FP2		; F2 19 51 00
	fmove.w	-(A2),FP3		; F2 22 51 80
	fmove.w	(1,A3),FP4		; F2 2B 52 00 00 01
	fmove.w	(2,PC),FP5		; F2 3A 52 80 FF FE

	fmove.l	D0,FP0			; F2 00 40 00
	fmove.l	(A0),FP1		; F2 10 40 80
	fmove.l	(A1)+,FP2		; F2 19 41 00
	fmove.l	-(A2),FP3		; F2 22 41 80
	fmove.l	(1,A3),FP4		; F2 2B 42 00 00 01
	fmove.l	(2,PC),FP5		; F2 3A 42 80 FF FE

	fmove.s	D0,FP0			; F2 00 44 00
	fmove.s	(A0),FP1		; F2 10 44 80
	fmove.s	(A1)+,FP2		; F2 19 45 00
	fmove.s	-(A2),FP3		; F2 22 45 80
	fmove.s	(1,A3),FP4		; F2 2B 46 00 00 01
	fmove.s	(2,PC),FP5		; F2 3A 46 80 FF FE

	fmove.d	(A0),FP1		; F2 10 54 80
	fmove.d	(A1)+,FP2		; F2 19 55 00
	fmove.d	-(A2),FP3		; F2 22 55 80
	fmove.d	(1,A3),FP4		; F2 2B 56 00 00 01
	fmove.d	(2,PC),FP5		; F2 3A 56 80 FF FE

	fsmove	(A0),FP1		; F2 10 54 C0
	fsmove	(A1)+,FP2		; F2 19 55 40
	fsmove	-(A2),FP3		; F2 22 55 C0
	fsmove	(1,A3),FP4		; F2 2B 56 40 00 01
	fsmove	(2,PC),FP5		; F2 3A 56 C0 FF FE

	fsmove.b	D0,FP0		; F2 00 58 40
	fsmove.b	(A0),FP1	; F2 10 58 C0
	fsmove.b	(A1)+,FP2	; F2 19 59 40
	fsmove.b	-(A2),FP3	; F2 22 59 C0
	fsmove.b	(1,A3),FP4	; F2 2B 5A 40 00 01
	fsmove.b	(2,PC),FP5	; F2 3A 5A C0 FF FE

	fsmove.w	D0,FP0		; F2 00 50 40
	fsmove.w	(A0),FP1	; F2 10 50 C0
	fsmove.w	(A1)+,FP2	; F2 19 51 40
	fsmove.w	-(A2),FP3	; F2 22 51 C0
	fsmove.w	(1,A3),FP4	; F2 2B 52 40 00 01
	fsmove.w	(2,PC),FP5	; F2 3A 52 C0 FF FE

	fsmove.l	D0,FP0		; F2 00 40 40
	fsmove.l	(A0),FP1	; F2 10 40 C0
	fsmove.l	(A1)+,FP2	; F2 19 41 40
	fsmove.l	-(A2),FP3	; F2 22 41 C0
	fsmove.l	(1,A3),FP4	; F2 2B 42 40 00 01
	fsmove.l	(2,PC),FP5	; F2 3A 42 C0 FF FE

	fsmove.s	D0,FP0		; F2 00 44 40
	fsmove.s	(A0),FP1	; F2 10 44 C0
	fsmove.s	(A1)+,FP2	; F2 19 45 40
	fsmove.s	-(A2),FP3	; F2 22 45 C0
	fsmove.s	(1,A3),FP4	; F2 2B 46 40 00 01
	fsmove.s	(2,PC),FP5	; F2 3A 46 C0 FF FE

	fsmove.d	(A0),FP1	; F2 10 54 C0
	fsmove.d	(A1)+,FP2	; F2 19 55 40
	fsmove.d	-(A2),FP3	; F2 22 55 C0
	fsmove.d	(1,A3),FP4	; F2 2B 56 40 00 01
	fsmove.d	(2,PC),FP5	; F2 3A 56 C0 FF FE

	fdmove	(A0),FP1		; F2 10 54 C4
	fdmove	(A1)+,FP2		; F2 19 55 44
	fdmove	-(A2),FP3		; F2 22 55 C4
	fdmove	(1,A3),FP4		; F2 2B 56 44 00 01
	fdmove	(2,PC),FP5		; F2 3A 56 C4 FF FE

	fdmove.b	D0,FP0		; F2 00 58 44
	fdmove.b	(A0),FP1	; F2 10 58 C4
	fdmove.b	(A1)+,FP2	; F2 19 59 44
	fdmove.b	-(A2),FP3	; F2 22 59 C4
	fdmove.b	(1,A3),FP4	; F2 2B 5A 44 00 01
	fdmove.b	(2,PC),FP5	; F2 3A 5A C4 FF FE

	fdmove.w	D0,FP0		; F2 00 50 44
	fdmove.w	(A0),FP1	; F2 10 50 C4
	fdmove.w	(A1)+,FP2	; F2 19 51 44
	fdmove.w	-(A2),FP3	; F2 22 51 C4
	fdmove.w	(1,A3),FP4	; F2 2B 52 44 00 01
	fdmove.w	(2,PC),FP5	; F2 3A 52 C4 FF FE

	fdmove.l	D0,FP0		; F2 00 40 44
	fdmove.l	(A0),FP1	; F2 10 40 C4
	fdmove.l	(A1)+,FP2	; F2 19 41 44
	fdmove.l	-(A2),FP3	; F2 22 41 C4
	fdmove.l	(1,A3),FP4	; F2 2B 42 44 00 01
	fdmove.l	(2,PC),FP5	; F2 3A 42 C4 FF FE

	fdmove.s	D0,FP0		; F2 00 44 44
	fdmove.s	(A0),FP1	; F2 10 44 C4
	fdmove.s	(A1)+,FP2	; F2 19 45 44
	fdmove.s	-(A2),FP3	; F2 22 45 C4
	fdmove.s	(1,A3),FP4	; F2 2B 46 44 00 01
	fdmove.s	(2,PC),FP5	; F2 3A 46 C4 FF FE

	fdmove.d	(A0),FP1	; F2 10 54 C4
	fdmove.d	(A1)+,FP2	; F2 19 55 44
	fdmove.d	-(A2),FP3	; F2 22 55 C4
	fdmove.d	(1,A3),FP4	; F2 2B 56 44 00 01
	fdmove.d	(2,PC),FP5	; F2 3A 56 C4 FF FE

	fmove	FP1,(A0)		; F2 10 74 80
	fmove	FP2,(A1)+		; F2 19 75 00
	fmove	FP3,-(A2)		; F2 22 75 80
	fmove	FP4,(1,A3)		; F2 2B 76 00

	fmove.b	FP0,D0			; F2 00 78 00
	fmove.b	FP1,(A0)		; F2 10 78 80
	fmove.b	FP2,(A1)+		; F2 19 79 00
	fmove.b	FP3,-(A2)		; F2 22 79 80
	fmove.b	FP4,(1,A3)		; F2 2B 7A 00

	fmove.w	FP0,D0			; F2 00 70 00
	fmove.w	FP1,(A0)		; F2 10 70 80
	fmove.w	FP2,(A1)+		; F2 19 71 00
	fmove.w	FP3,-(A2)		; F2 22 71 80
	fmove.w	FP4,(1,A3)		; F2 2B 72 00

	fmove.l	FP0,D0			; F2 00 60 00
	fmove.l	FP1,(A0)		; F2 10 60 80
	fmove.l	FP2,(A1)+		; F2 19 61 00
	fmove.l	FP3,-(A2)		; F2 22 61 80
	fmove.l	FP4,(1,A3)		; F2 2B 62 00

	fmove.s	FP0,D0			; F2 00 64 00
	fmove.s	FP1,(A0)		; F2 10 64 80
	fmove.s	FP2,(A1)+		; F2 19 65 00
	fmove.s	FP3,-(A2)		; F2 22 65 80
	fmove.s	FP4,(1,A3)		; F2 2B 66 00

	fmove.d	FP1,(A0)		; F2 10 74 80
	fmove.d	FP2,(A1)+		; F2 19 75 00
	fmove.d	FP3,-(A2)		; F2 22 75 80
	fmove.d	FP4,(1,A3)		; F2 2B 76 00

	fmove.l	FPCR,D0			; F2 00 B0 00
	fmove.l	FPIAR,A0		; F2 08 A4 00
	fmove.l	FPSR,(A1)		; F2 11 A8 00
	fmove.l	FPCR,(A2)+		; F2 1A B0 00
	fmove.l	FPIAR,-(A3)		; F2 23 A4 00
	fmove.l	FPSR,(2,A4)		; F2 2C A8 00 00 02

	fmove.l	D0,FPCR			; F2 00 90 00
	fmove.l	A0,FPIAR		; F2 08 84 00
	fmove.l	(A1),FPSR		; F2 11 88 00
	fmove.l	(A2)+,FPCR		; F2 1A 90 00
	fmove.l	-(A3),FPIAR		; F2 23 84 00
	fmove.l	(2,A4),FPSR		; F2 2C 88 00 00 02
	fmove.l	(4,PC),FPCR		; F2 3A 90 00 00 00


	.sbttl	Type F_MOVM Instructions: FMOVEM

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  F_MOVM:						*
	;*	FMOVEM						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	fmovem	(A0),#FP0/FP2		; F2 10 D0 A0
	fmovem	(2,A1),#FP1-FP3		; F2 29 D0 70 00 02
	fmovem	(4,PC),#FP0-FP1/FP3	; F2 3A D0 D0 00 00

	fmovem	#FP0/FP2,(A0)		; F2 10 F0 A0
	fmovem	#FP1-FP3,(2,A1)		; F2 29 F0 70 00 02

	fmovem.d	(A0),#FP0/FP2	; F2 10 D0 A0
	fmovem.d	(2,A1),#FP1-FP3	; F2 29 D0 70 00 02
	fmovem.d	(4,PC),#FP0-FP1/FP3	; F2 3A D0 D0 00 00

	fmovem.d	#FP0/FP2,(A0)	; F2 10 F0 A0
	fmovem.d	#FP1-FP3,(2,A1)	; F2 29 F0 70 00 02


	.sbttl	Type F_BCC Instructions: FBcc

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  F_BCC:						*
	;*	FBF, FBEQ, FBOGT, FBOGE, 			*
	;*	FBOLT, FBOLE, FBOGL, FBOR,			*
	;*	FBUN, FBUEQ, FBUGT, FBUGE,			*
	;*	FBULT, FBULE, FBNE, FBT,			*
	;*	FBSF, FBSEQ, FBGT, FBGE,			*
	;*	FBLT, FBLE, FBGL, FBGLE,			*
	;*	FBNGLE,FBNGL, FBNLE, FBNLT,			*
	;*	FBNGE, FBNGT, FBSNE, FBST			*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	fbf	.			; F2 80 FF FE
	fbf	. + 0x02		; F2 80 00 00
	fbf	. + 0x1002		; F2 80 10 00
	fbf	. + 0x20002		; F2 C0 00 02 00 00
	fbf.w	. + 0x12		; F2 80 00 10
	fbf.l	. + 0x12		; F2 C0 00 00 00 10
	fbf.w	. + 0x1002		; F2 80 10 00
	fbf.l	. + 0x1002		; F2 C0 00 00 10 00
	fbf.l	. + 0x20002		; F2 C0 00 02 00 00

	fbeq	.			; F2 81 FF FE
	fbeq	. + 0x02		; F2 81 00 00
	fbeq	. + 0x1002		; F2 81 10 00
	fbeq	. + 0x20002		; F2 C1 00 02 00 00
	fbeq.w	. + 0x12		; F2 81 00 10
	fbeq.l	. + 0x12		; F2 C1 00 00 00 10
	fbeq.w	. + 0x1002		; F2 81 10 00
	fbeq.l	. + 0x1002		; F2 C1 00 00 10 00
	fbeq.l	. + 0x20002		; F2 C1 00 02 00 00

	fbogt	.			; F2 82 FF FE
	fbogt	. + 0x02		; F2 82 00 00
	fbogt	. + 0x1002		; F2 82 10 00
	fbogt	. + 0x20002		; F2 C2 00 02 00 00
	fbogt.w	. + 0x12		; F2 82 00 10
	fbogt.l	. + 0x12		; F2 C2 00 00 00 10
	fbogt.w	. + 0x1002		; F2 82 10 00
	fbogt.l	. + 0x1002		; F2 C2 00 00 10 00
	fbogt.l	. + 0x20002		; F2 C2 00 02 00 00

	fboge	.			; F2 83 FF FE
	fboge	. + 0x02		; F2 83 00 00
	fboge	. + 0x1002		; F2 83 10 00
	fboge	. + 0x20002		; F2 C3 00 02 00 00
	fboge.w	. + 0x12		; F2 86 00 10
	fboge.l	. + 0x12		; F2 C6 00 00 00 10
	fboge.w	. + 0x1002		; F2 86 10 00
	fboge.l	. + 0x1002		; F2 C6 00 00 10 00
	fboge.l	. + 0x20002		; F2 C6 00 02 00 00

	fbolt	.			; F2 84 FF FE
	fbolt	. + 0x02		; F2 84 00 00
	fbolt	. + 0x1002		; F2 84 10 00
	fbolt	. + 0x20002		; F2 C4 00 02 00 00
	fbolt.w	. + 0x12		; F2 84 00 10
	fbolt.l	. + 0x12		; F2 C4 00 00 00 10
	fbolt.w	. + 0x1002		; F2 84 10 00
	fbolt.l	. + 0x1002		; F2 C4 00 00 10 00
	fbolt.l	. + 0x20002		; F2 C4 00 02 00 00

	fbole	.			; F2 85 FF FE
	fbole	. + 0x02		; F2 85 00 00
	fbole	. + 0x1002		; F2 85 10 00
	fbole	. + 0x20002		; F2 C5 00 02 00 00
	fbole.w	. + 0x12		; F2 85 00 10
	fbole.l	. + 0x12		; F2 C5 00 00 00 10
	fbole.w	. + 0x1002		; F2 85 10 00
	fbole.l	. + 0x1002		; F2 C5 00 00 10 00
	fbole.l	. + 0x20002		; F2 C5 00 02 00 00

	fboge	.			; F2 83 FF FE
	fboge	. + 0x02		; F2 83 00 00
	fboge	. + 0x1002		; F2 83 10 00
	fboge	. + 0x20002		; F2 C3 00 02 00 00
	fboge.w	. + 0x12		; F2 86 00 10
	fboge.l	. + 0x12		; F2 C6 00 00 00 10
	fboge.w	. + 0x1002		; F2 86 10 00
	fboge.l	. + 0x1002		; F2 C6 00 00 10 00
	fboge.l	. + 0x20002		; F2 C6 00 02 00 00

	fbor	.			; F2 87 FF FE
	fbor	. + 0x02		; F2 87 00 00
	fbor	. + 0x1002		; F2 87 10 00
	fbor	. + 0x20002		; F2 C7 00 02 00 00
	fbor.w	. + 0x12		; F2 87 00 10
	fbor.l	. + 0x12		; F2 C7 00 00 00 10
	fbor.w	. + 0x1002		; F2 87 10 00
	fbor.l	. + 0x1002		; F2 C7 00 00 10 00
	fbor.l	. + 0x20002		; F2 C7 00 02 00 00

	fbun	.			; F2 88 FF FE
	fbun	. + 0x02		; F2 88 00 00
	fbun	. + 0x1002		; F2 88 10 00
	fbun	. + 0x20002		; F2 C8 00 02 00 00
	fbun.w	. + 0x12		; F2 88 00 10
	fbun.l	. + 0x12		; F2 C8 00 00 00 10
	fbun.w	. + 0x1002		; F2 88 10 00
	fbun.l	. + 0x1002		; F2 C8 00 00 10 00
	fbun.l	. + 0x20002		; F2 C8 00 02 00 00

	fbueq	.			; F2 89 FF FE
	fbueq	. + 0x02		; F2 89 00 00
	fbueq	. + 0x1002		; F2 89 10 00
	fbueq	. + 0x20002		; F2 C9 00 02 00 00
	fbueq.w	. + 0x12		; F2 89 00 10
	fbueq.l	. + 0x12		; F2 C9 00 00 00 10
	fbueq.w	. + 0x1002		; F2 89 10 00
	fbueq.l	. + 0x1002		; F2 C9 00 00 10 00
	fbueq.l	. + 0x20002		; F2 C9 00 02 00 00

	fbugt	.			; F2 8A FF FE
	fbugt	. + 0x02		; F2 8A 00 00
	fbugt	. + 0x1002		; F2 8A 10 00
	fbugt	. + 0x20002		; F2 CA 00 02 00 00
	fbugt.w	. + 0x12		; F2 8A 00 10
	fbugt.l	. + 0x12		; F2 CA 00 00 00 10
	fbugt.w	. + 0x1002		; F2 8A 10 00
	fbugt.l	. + 0x1002		; F2 CA 00 00 10 00
	fbugt.l	. + 0x20002		; F2 CA 00 02 00 00

	fbuge	.			; F2 8B FF FE
	fbuge	. + 0x02		; F2 8B 00 00
	fbuge	. + 0x1002		; F2 8B 10 00
	fbuge	. + 0x20002		; F2 CB 00 02 00 00
	fbuge.w	. + 0x12		; F2 8B 00 10
	fbuge.l	. + 0x12		; F2 CB 00 00 00 10
	fbuge.w	. + 0x1002		; F2 8B 10 00
	fbuge.l	. + 0x1002		; F2 CB 00 00 10 00
	fbuge.l	. + 0x20002		; F2 CB 00 02 00 00

	fbult	.			; F2 8C FF FE
	fbult	. + 0x02		; F2 8C 00 00
	fbult	. + 0x1002		; F2 8C 10 00
	fbult	. + 0x20002		; F2 CC 00 02 00 00
	fbult.w	. + 0x12		; F2 8C 00 10
	fbult.l	. + 0x12		; F2 CC 00 00 00 10
	fbult.w	. + 0x1002		; F2 8C 10 00
	fbult.l	. + 0x1002		; F2 CC 00 00 10 00
	fbult.l	. + 0x20002		; F2 CC 00 02 00 00

	fbule	.			; F2 8D FF FE
	fbule	. + 0x02		; F2 8D 00 00
	fbule	. + 0x1002		; F2 8D 10 00
	fbule	. + 0x20002		; F2 CD 00 02 00 00
	fbule.w	. + 0x12		; F2 8D 00 10
	fbule.l	. + 0x12		; F2 CD 00 00 00 10
	fbule.w	. + 0x1002		; F2 8D 10 00
	fbule.l	. + 0x1002		; F2 CD 00 00 10 00
	fbule.l	. + 0x20002		; F2 CD 00 02 00 00

	fbne	.			; F2 8E FF FE
	fbne	. + 0x02		; F2 8E 00 00
	fbne	. + 0x1002		; F2 8E 10 00
	fbne	. + 0x20002		; F2 CE 00 02 00 00
	fbne.w	. + 0x12		; F2 8E 00 10
	fbne.l	. + 0x12		; F2 CE 00 00 00 10
	fbne.w	. + 0x1002		; F2 8E 10 00
	fbne.l	. + 0x1002		; F2 CE 00 00 10 00
	fbne.l	. + 0x20002		; F2 CE 00 02 00 00

	fbt	.			; F2 8F FF FE
	fbt	. + 0x02		; F2 8F 00 00
	fbt	. + 0x1002		; F2 8F 10 00
	fbt	. + 0x20002		; F2 CF 00 02 00 00
	fbt.w	. + 0x12		; F2 8F 00 10
	fbt.l	. + 0x12		; F2 CF 00 00 00 10
	fbt.w	. + 0x1002		; F2 8F 10 00
	fbt.l	. + 0x1002		; F2 CF 00 00 10 00
	fbt.l	. + 0x20002		; F2 CF 00 02 00 00

	fbsf	.			; F2 90 FF FE
	fbsf	. + 0x02		; F2 90 00 00
	fbsf	. + 0x1002		; F2 90 10 00
	fbsf	. + 0x20002		; F2 D0 00 02 00 00
	fbsf.w	. + 0x12		; F2 90 00 10
	fbsf.l	. + 0x12		; F2 D0 00 00 00 10
	fbsf.w	. + 0x1002		; F2 90 10 00
	fbsf.l	. + 0x1002		; F2 D0 00 00 10 00
	fbsf.l	. + 0x20002		; F2 D0 00 02 00 00

	fbseq	.			; F2 91 FF FE
	fbseq	. + 0x02		; F2 91 00 00
	fbseq	. + 0x1002		; F2 91 10 00
	fbseq	. + 0x20002		; F2 D1 00 02 00 00
	fbseq.w	. + 0x12		; F2 91 00 10
	fbseq.l	. + 0x12		; F2 D1 00 00 00 10
	fbseq.w	. + 0x1002		; F2 91 10 00
	fbseq.l	. + 0x1002		; F2 D1 00 00 10 00
	fbseq.l	. + 0x20002		; F2 D1 00 02 00 00

	fbgt	.			; F2 92 FF FE
	fbgt	. + 0x02		; F2 92 00 00
	fbgt	. + 0x1002		; F2 92 10 00
	fbgt	. + 0x20002		; F2 D2 00 02 00 00
	fbgt.w	. + 0x12		; F2 92 00 10
	fbgt.l	. + 0x12		; F2 D2 00 00 00 10
	fbgt.w	. + 0x1002		; F2 92 10 00
	fbgt.l	. + 0x1002		; F2 D2 00 00 10 00
	fbgt.l	. + 0x20002		; F2 D2 00 02 00 00

	fbge	.			; F2 93 FF FE
	fbge	. + 0x02		; F2 93 00 00
	fbge	. + 0x1002		; F2 93 10 00
	fbge	. + 0x20002		; F2 D3 00 02 00 00
	fbge.w	. + 0x12		; F2 93 00 10
	fbge.l	. + 0x12		; F2 D3 00 00 00 10
	fbge.w	. + 0x1002		; F2 93 10 00
	fbge.l	. + 0x1002		; F2 D3 00 00 10 00
	fbge.l	. + 0x20002		; F2 D3 00 02 00 00

	fblt	.			; F2 94 FF FE
	fblt	. + 0x02		; F2 94 00 00
	fblt	. + 0x1002		; F2 94 10 00
	fblt	. + 0x20002		; F2 D4 00 02 00 00
	fblt.w	. + 0x12		; F2 94 00 10
	fblt.l	. + 0x12		; F2 D4 00 00 00 10
	fblt.w	. + 0x1002		; F2 94 10 00
	fblt.l	. + 0x1002		; F2 D4 00 00 10 00
	fblt.l	. + 0x20002		; F2 D4 00 02 00 00

	fble	.			; F2 95 FF FE
	fble	. + 0x02		; F2 95 00 00
	fble	. + 0x1002		; F2 95 10 00
	fble	. + 0x20002		; F2 D5 00 02 00 00
	fble.w	. + 0x12		; F2 95 00 10
	fble.l	. + 0x12		; F2 D5 00 00 00 10
	fble.w	. + 0x1002		; F2 95 10 00
	fble.l	. + 0x1002		; F2 D5 00 00 10 00
	fble.l	. + 0x20002		; F2 D5 00 02 00 00

	fbgl	.			; F2 96 FF FE
	fbgl	. + 0x02		; F2 96 00 00
	fbgl	. + 0x1002		; F2 96 10 00
	fbgl	. + 0x20002		; F2 D6 00 02 00 00
	fbgl.w	. + 0x12		; F2 96 00 10
	fbgl.l	. + 0x12		; F2 D6 00 00 00 10
	fbgl.w	. + 0x1002		; F2 96 10 00
	fbgl.l	. + 0x1002		; F2 D6 00 00 10 00
	fbgl.l	. + 0x20002		; F2 D6 00 02 00 00

	fbgle	.			; F2 97 FF FE
	fbgle	. + 0x02		; F2 97 00 00
	fbgle	. + 0x1002		; F2 97 10 00
	fbgle	. + 0x20002		; F2 D7 00 02 00 00
	fbgle.w	. + 0x12		; F2 97 00 10
	fbgle.l	. + 0x12		; F2 D7 00 00 00 10
	fbgle.w	. + 0x1002		; F2 97 10 00
	fbgle.l	. + 0x1002		; F2 D7 00 00 10 00
	fbgle.l	. + 0x20002		; F2 D7 00 02 00 00

	fbngle	.			; F2 98 FF FE
	fbngle	. + 0x02		; F2 98 00 00
	fbngle	. + 0x1002		; F2 98 10 00
	fbngle	. + 0x20002		; F2 D8 00 02 00 00
	fbngle.w	. + 0x12	; F2 98 00 10
	fbngle.l	. + 0x12	; F2 D8 00 00 00 10
	fbngle.w	. + 0x1002	; F2 98 10 00
	fbngle.l	. + 0x1002	; F2 D8 00 00 10 00
	fbngle.l	. + 0x20002	; F2 D8 00 02 00 00

	fbngl	.			; F2 99 FF FE
	fbngl	. + 0x02		; F2 99 00 00
	fbngl	. + 0x1002		; F2 99 10 00
	fbngl	. + 0x20002		; F2 D9 00 02 00 00
	fbngl.w	. + 0x12		; F2 99 00 10
	fbngl.l	. + 0x12		; F2 D9 00 00 00 10
	fbngl.w	. + 0x1002		; F2 99 10 00
	fbngl.l	. + 0x1002		; F2 D9 00 00 10 00
	fbngl.l	. + 0x20002		; F2 D9 00 02 00 00

	fbnle	.			; F2 9A FF FE
	fbnle	. + 0x02		; F2 9A 00 00
	fbnle	. + 0x1002		; F2 9A 10 00
	fbnle	. + 0x20002		; F2 DA 00 02 00 00
	fbnle.w	. + 0x12		; F2 9A 00 10
	fbnle.l	. + 0x12		; F2 DA 00 00 00 10
	fbnle.w	. + 0x1002		; F2 9A 10 00
	fbnle.l	. + 0x1002		; F2 DA 00 00 10 00
	fbnle.l	. + 0x20002		; F2 DA 00 02 00 00

	fbnlt	.			; F2 9B FF FE
	fbnlt	. + 0x02		; F2 9B 00 00
	fbnlt	. + 0x1002		; F2 9B 10 00
	fbnlt	. + 0x20002		; F2 DB 00 02 00 00
	fbnlt.w	. + 0x12		; F2 9B 00 10
	fbnlt.l	. + 0x12		; F2 DB 00 00 00 10
	fbnlt.w	. + 0x1002		; F2 9B 10 00
	fbnlt.l	. + 0x1002		; F2 DB 00 00 10 00
	fbnlt.l	. + 0x20002		; F2 DB 00 02 00 00

	fbnge	.			; F2 9C FF FE
	fbnge	. + 0x02		; F2 9C 00 00
	fbnge	. + 0x1002		; F2 9C 10 00
	fbnge	. + 0x20002		; F2 DC 00 02 00 00
	fbnge.w	. + 0x12		; F2 9C 00 10
	fbnge.l	. + 0x12		; F2 DC 00 00 00 10
	fbnge.w	. + 0x1002		; F2 9C 10 00
	fbnge.l	. + 0x1002		; F2 DC 00 00 10 00
	fbnge.l	. + 0x20002		; F2 DC 00 02 00 00

	fbngt	.			; F2 9D FF FE
	fbngt	. + 0x02		; F2 9D 00 00
	fbngt	. + 0x1002		; F2 9D 10 00
	fbngt	. + 0x20002		; F2 DD 00 02 00 00
	fbngt.w	. + 0x12		; F2 9D 00 10
	fbngt.l	. + 0x12		; F2 DD 00 00 00 10
	fbngt.w	. + 0x1002		; F2 9D 10 00
	fbngt.l	. + 0x1002		; F2 DD 00 00 10 00
	fbngt.l	. + 0x20002		; F2 DD 00 02 00 00

	fbsne	.			; F2 9E FF FE
	fbsne	. + 0x02		; F2 9E 00 00
	fbsne	. + 0x1002		; F2 9E 10 00
	fbsne	. + 0x20002		; F2 DE 00 02 00 00
	fbsne.w	. + 0x12		; F2 9E 00 10
	fbsne.l	. + 0x12		; F2 DE 00 00 00 10
	fbsne.w	. + 0x1002		; F2 9E 10 00
	fbsne.l	. + 0x1002		; F2 DE 00 00 10 00
	fbsne.l	. + 0x20002		; F2 DE 00 02 00 00

	fbst	.			; F2 9F FF FE
	fbst	. + 0x02		; F2 9F 00 00
	fbst	. + 0x1002		; F2 9F 10 00
	fbst	. + 0x20002		; F2 DF 00 02 00 00
	fbst.w	. + 0x12		; F2 9F 00 10
	fbst.l	. + 0x12		; F2 DF 00 00 00 10
	fbst.w	. + 0x1002		; F2 9F 10 00
	fbst.l	. + 0x1002		; F2 DF 00 00 10 00
	fbst.l	. + 0x20002		; F2 DF 00 02 00 00


	.sbttl	Type F_NOP Instructions: FNOP

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  F_NOP:						*
	;*	FNOP						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	fnop				; F2 80 00 00


	.sbttl	Type F_SVRS Instructions: FSAVE, FRESTORE

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  F_SVRS:						*
	;*	FSAVE, FRESTORE					*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	fsave	(A0)			; F3 10
	fsave	(2,A1)			; F3 29 00 02

	frestore	(A0)		; F3 50
	frestore	(2,A1)		; F3 69 00 02
	frestore	(2,PC)		; F3 7A 00 00


	.sbttl	Source Addressing Mode Checks

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*	Exhaustice Addressing Mode Checks		*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	  ; Dn

	cmp	D0,D1			; B2 80

	  ; An

	cmp	A1,D2			; B4 89

	  ; (An)

	cmp	(A2),D3			; B6 92

	  ; (An)+

	cmp	(A3)+,D4		; B8 9B

	  ; -(An)

	cmp	-(A4),D5		; BA A4

	  ; d16(An) / (d16,An)

	cmp	0x0012(A5),D6		; BC AD 00 12
	cmp	0x1234(A5),D6		; BC AD 12 34
	cmp	(0x0012,A5),D7		; BE AD 00 12
	cmp	(0x1234,A5),D7		; BE AD 12 34

	  ; d8(An,Xn) / (d8,An,Xn)

	cmp	4(A6,D1.W),D0		; B0 B6 10 04
	cmp	4(A6,A7.L),D1		; B2 B6 F8 04
	cmp	(4,A6,D1.W),D2		; B4 B6 10 04
	cmp	(4,A6,A7.L),D3		; B6 B6 F8 04

	  ; *addr / addr / (addr).W / (addr).L

	cmp	*0xFFFFFFF0,D5		; BA B8 FF F0
	cmp	 0x00000004,D5		; BA B8 00 04
	cmp	 0x00010004,D5		; BA B9 00 01 00 04
	cmp	(0x1234).W,D5		; BA B8 12 34
	cmp	(0x1234).L,D5		; BA B9 00 00 12 34

	  ; #

	cmp	#0x00000007,D6		; 0C 86 00 00 00 07
	cmp.w	#0x00007007,D6		; 0C 46 70 07
	cmp.l	#0x00070007,D6		; 0C 86 00 07 00 07

	  ; d16(PC) / (d16,PC)

	cmp	0x0012(PC),D6		; BC BA 00 10
	cmp	0x1234(PC),D6		; BC BA 12 32
	cmp	(0x0012,PC),D7		; BE BA 00 10
	cmp	(0x1234,PC),D7		; BE BA 12 32

	  ; d8(PC,Xn) / (d8,PC,Xn)

	cmp	4(PC,D1.W),D0		; B0 BB 10 02
	cmp	4(PC,A7.L),D1		; B2 BB F8 02
	cmp	(4,PC,D1.W),D2		; B4 BB 10 02
	cmp	(4,PC,A7.L),D3		; B6 BB F8 02

