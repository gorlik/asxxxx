	.title	AS68K Assembler Test

	; BLDT68K Macro Definitions Loaded

	.area	B	(abs,ovr)	; External Labels Area
	.org	0

	.globl	xb, xw, xl

	.define barg ^/(xb+0x12)/	; Externals Plus A Constant
	.define	warg ^/(xw+0x1234)/
	.define	larg ^/(xl+0x12345678)/

	.area	A	(abs,ovr)	; Main Coding Area
	.org	0

	.68020			; Select 68020 Processor
	.68882			; Select 68882 Floating Point Co-Processor
	.enabl	(alt)		; Allow Alternate Instructions

	.sbttl	Type S_TYP1 Instructions: ABCD, SBCD, ADDX, SUBX

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_TYP1:						*
	;*	ABCD, SBCD, ADDX, SUBX				*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	abcd	D7,D2			; C5 07
	abcd	-(A5),-(A1)		; C3 0D

	abcd.b	D7,D2			; C5 07
	abcd.b	-(A5),-(A1)		; C3 0D

	sbcd	D7,D2			; 85 07
	sbcd	-(A5),-(A1)		; 83 0D

	sbcd.b	D7,D2			; 85 07
	sbcd.b	-(A5),-(A1)		; 83 0D

	addx	D7,D2			; D5 47
	addx	-(A5),-(A1)		; D3 4D

	addx.b	D7,D2			; D5 07
	addx.b	-(A5),-(A1)		; D3 0D

	addx.w	D7,D2			; D5 47
	addx.w	-(A5),-(A1)		; D3 4D

	addx.l	D7,D2			; D5 87
	addx.l	-(A5),-(A1)		; D3 8D

	subx	D7,D2			; 95 47
	subx	-(A5),-(A1)		; 93 4D

	subx.b	D7,D2			; 95 07
	subx.b	-(A5),-(A1)		; 93 0D

	subx.w	D7,D2			; 95 47
	subx.w	-(A5),-(A1)		; 93 4D

	subx.l	D7,D2			; 95 87
	subx.l	-(A5),-(A1)		; 93 8D

	.sbttl	Type S_TYP2 Instructions: ADD, AND, OR, SUB

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_TYP2:						*
	;*	ADD, AND, OR, SUB				*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	add	D7,D0			; D0 47
	add	A0,D1			; D2 48
	add	(A1),D2			; D4 51
	add	(A2)+,D3		; D6 5A
	add	-(A3),D4		; D8 63
	add	1(A4),D5		; DA 6C 00 01
	add	2(A5,D7.W),D6		; DC 75 70 02
	add	2(A5,D7.L),D6		; DC 75 78 02
	add	(0x1234).W,D7		; DE 78 12 34
	add	(0x1234).L,D7		; DE 79 00 00 12 34
	add	*0xFFFFFFF0,D0		; D0 78 FF F0
	add	 0x00010004,D1		; D2 79 00 01 00 04
	add	#7,D2			; 5E 42
	add	5(PC),D3		; D6 7A 00 03
	add	6(PC,A7.W),D4		; D8 7B F0 04
	add	6(PC,A7.L),D4		; D8 7B F8 04
	add	(0x1234,A0,D1),D0	; D0 70 11 20 12 34
	add	([2,A1,A2],4),D1	; D2 71 A1 22 00 02 00
	add	([6,A2],D3,8),D2	; D4 72 31 26 00 06 00
	add	(0x1234,PC,D1),D3	; D6 7B 11 20 12 32
	add	([2,PC,A2],4),D4	; D8 7B A1 22 00 00 00
	add	([6,PC],D3,8),D5	; DA 7B 31 26 00 04 00

	add	D1,A1			; D2 C1
	add	D2,(A1)			; D5 51
	add	D3,(A2)+		; D7 5A
	add	D4,-(A3)		; D9 63
	add	D5,1(A4)		; DB 6C 00 01
	add	D6,2(A5,D7.W)		; DD 75 70 02
	add	D6,2(A5,D7.L)		; DD 75 78 02
	add	D7,(0x1234).W		; DF 78 12 34
	add	D7,(0x1234).L		; DF 79 00 00 12 34
	add	D0,*0xFFFFFFF0		; D1 78 FF F0
	add	D0, 0x00010004		; D1 79 00 01 00 04
	add	D0,(0x1234,A0,D1)	; D1 70 11 20 12 34
	add	D1,([2,A1,A2],4)	; D3 71 A1 22 00 02 00
	add	D2,([6,A2],D3,8)	; D5 72 31 26 00 06 00

	add.b	D7,D0			; D0 07
	add.b	(A1),D2			; D4 11
	add.b	(A2)+,D3		; D6 1A
	add.b	-(A3),D4		; D8 23
	add.b	1(A4),D5		; DA 2C 00 01
	add.b	2(A5,D7.W),D6		; DC 35 70 02
	add.b	2(A5,D7.L),D6		; DC 35 78 02
	add.b	(0x1234).W,D7		; DE 38 12 34
	add.b	(0x1234).L,D7		; DE 39 00 00 12 34
	add.b	*0xFFFFFFF0,D0		; D0 38 FF F0
	add.b	 0x00010004,D1		; D2 39 00 01 00 04
	add.b	#7,D2			; 5E 02
	add.b	5(PC),D3		; D6 3A 00 03
	add.b	6(PC,A7.W),D4		; D8 3B F0 04
	add.b	6(PC,A7.L),D4		; D8 3B F8 04
	add.b	(0x1234,A0,D1),D0	; D0 30 11 20 12 34
	add.b	([2,A1,A2],4),D1	; D2 31 A1 22 00 02 00
	add.b	([6,A2],D3,8),D2	; D4 32 31 26 00 06 00
	add.b	(0x1234,PC,D1),D3	; D6 3B 11 20 12 32
	add.b	([2,PC,A2],4),D4	; D8 3B A1 22 00 00 00
	add.b	([6,PC],D3,8),D5	; DA 3B 31 26 00 04 00

	add.b	D2,(A1)			; D5 11
	add.b	D3,(A2)+		; D7 1A
	add.b	D4,-(A3)		; D9 23
	add.b	D5,1(A4)		; DB 2C 00 01
	add.b	D6,2(A5,D7.W)		; DD 35 70 02
	add.b	D6,2(A5,D7.L)		; DD 35 78 02
	add.b	D7,(0x1234).W		; DF 38 12 34
	add.b	D7,(0x1234).L		; DF 39 00 00 12 34
	add.b	D0,*0xFFFFFFF0		; D1 38 FF F0
	add.b	D0, 0x00010004		; D1 39 00 01 00 04
	add.b	D0,(0x1234,A0,D1)	; D1 30 11 20 12 34
	add.b	D1,([2,A1,A2],4)	; D3 31 A1 22 00 02 00
	add.b	D2,([6,A2],D3,8)	; D5 32 31 26 00 06 00

	add.w	D7,D0			; D0 47
	add.w	A0,D1			; D2 48
	add.w	(A1),D2			; D4 51
	add.w	(A2)+,D3		; D6 5A
	add.w	-(A3),D4		; D8 63
	add.w	1(A4),D5		; DA 6C 00 01
	add.w	2(A5,D7.W),D6		; DC 75 70 02
	add.w	2(A5,D7.L),D6		; DC 75 78 02
	add.w	(0x1234).W,D7		; DE 78 12 34
	add.w	(0x1234).L,D7		; DE 79 00 00 12 34
	add.w	*0xFFFFFFF0,D0		; D0 78 FF F0
	add.w	 0x00010004,D1		; D2 79 00 01 00 04
	add.w	#7,D2			; 5E 42
	add.w	5(PC),D3		; D6 7A 00 03
	add.w	6(PC,A7.W),D4		; D8 7B F0 04
	add.w	6(PC,A7.L),D4		; D8 7B F8 04
	add.w	(0x1234,A0,D1),D0	; D0 70 11 20 12 34
	add.w	([2,A1,A2],4),D1	; D2 71 A1 22 00 02 00
	add.w	([6,A2],D3,8),D2	; D4 72 31 26 00 06 00
	add.w	(0x1234,PC,D1),D3	; D6 7B 11 20 12 32
	add.w	([2,PC,A2],4),D4	; D8 7B A1 22 00 00 00
	add.w	([6,PC],D3,8),D5	; DA 7B 31 26 00 04 00

	add.w	D1,A1			; D2 C1
	add.w	D2,(A1)			; D5 51
	add.w	D3,(A2)+		; D7 5A
	add.w	D4,-(A3)		; D9 63
	add.w	D5,1(A4)		; DB 6C 00 01
	add.w	D6,2(A5,D7.W)		; DD 75 70 02
	add.w	D6,2(A5,D7.L)		; DD 75 78 02
	add.w	D7,(0x1234).W		; DF 78 12 34
	add.w	D7,(0x1234).L		; DF 79 00 00 12 34
	add.w	D0,*0xFFFFFFF0		; D1 78 FF F0
	add.w	D0, 0x00010004		; D1 79 00 01 00 04
	add.w	D0,(0x1234,A0,D1)	; D1 70 11 20 12 34
	add.w	D1,([2,A1,A2],4)	; D3 71 A1 22 00 02 00
	add.w	D2,([6,A2],D3,8)	; D5 72 31 26 00 06 00

	add.l	D7,D0			; D0 87
	add.l	A0,D1			; D2 88
	add.l	(A1),D2			; D4 91
	add.l	(A2)+,D3		; D6 9A
	add.l	-(A3),D4		; D8 A3
	add.l	1(A4),D5		; DA AC 00 01
	add.l	2(A5,D7.W),D6		; DC B5 70 02
	add.l	2(A5,D7.L),D6		; DC B5 78 02
	add.l	(0x1234).W,D7		; DE B8 12 34
	add.l	(0x1234).L,D7		; DE B9 00 00 12 34
	add.l	*0xFFFFFFF0,D0		; D0 B8 FF F0
	add.l	 0x00010004,D1		; D2 B9 00 01 00 04
	add.l	#7,D2			; 5E 82
	add.l	5(PC),D3		; D6 BA 00 03
	add.l	6(PC,A7.W),D4		; D8 BB F0 04
	add.l	6(PC,A7.L),D4		; D8 BB F8 04
	add.l	(0x1234,A0,D1),D0	; D0 B0 11 20 12 34
	add.l	([2,A1,A2],4),D1	; D2 B1 A1 22 00 02 00
	add.l	([6,A2],D3,8),D2	; D4 B2 31 26 00 06 00
	add.l	(0x1234,PC,D1),D3	; D6 BB 11 20 12 32
	add.l	([2,PC,A2],4),D4	; D8 BB A1 22 00 00 00
	add.l	([6,PC],D3,8),D5	; DA BB 31 26 00 04 00

	add.l	D1,A1			; D3 C1
	add.l	D2,(A1)			; D5 91
	add.l	D3,(A2)+		; D7 9A
	add.l	D4,-(A3)		; D9 A3
	add.l	D5,1(A4)		; DB AC 00 01
	add.l	D6,2(A5,D7.W)		; DD B5 70 02
	add.l	D6,2(A5,D7.L)		; DD B5 78 02
	add.l	D7,(0x1234).W		; DF B8 12 34
	add.l	D7,(0x1234).L		; DF B9 00 00 12 34
	add.l	D0,*0xFFFFFFF0		; D1 B8 FF F0
	add.l	D0, 0x00010004		; D1 B9 00 01 00 04
	add.l	D0,(0x1234,A0,D1)	; D1 B0 11 20 12 34
	add.l	D1,([2,A1,A2],4)	; D3 B1 A1 22 00 02 00
	add.l	D2,([6,A2],D3,8)	; D5 B2 31 26 00 06 00

	and	D7,D0			; C0 47
	and	(A1),D2			; C4 51
	and	(A2)+,D3		; C6 5A
	and	-(A3),D4		; C8 63
	and	1(A4),D5		; CA 6C 00 01
	and	2(A5,D7.W),D6		; CC 75 70 02
	and	2(A5,D7.L),D6		; CC 75 78 02
	and	(0x1234).W,D7		; CE 78 12 34
	and	(0x1234).L,D7		; CE 79 00 00 12 34
	and	*0xFFFFFFF0,D0		; C0 78 FF F0
	and	 0x00010004,D1		; C2 79 00 01 00 04
	and	#7,D2			; 02 42 00 07
	and	5(PC),D3		; C6 7A 00 03
	and	6(PC,A7.W),D4		; C8 7B F0 04
	and	6(PC,A7.L),D4		; C8 7B F8 04
	and	(0x1234,A0,D1),D0	; C0 70 11 20 12 34
	and	([2,A1,A2],4),D1	; C2 71 A1 22 00 02 00
	and	([6,A2],D3,8),D2	; C4 72 31 26 00 06 00
	and	(0x1234,PC,D1),D3	; C6 7B 11 20 12 32
	and	([2,PC,A2],4),D4	; C8 7B A1 22 00 00 00
	and	([6,PC],D3,8),D5	; CA 7B 31 26 00 04 00

	and	D2,(A1)			; C5 51
	and	D3,(A2)+		; C7 5A
	and	D4,-(A3)		; C9 63
	and	D5,1(A4)		; CB 6C 00 01
	and	D6,2(A5,D7.W)		; CD 75 70 02
	and	D6,2(A5,D7.L)		; CD 75 78 02
	and	D7,(0x1234).W		; CF 78 12 34
	and	D7,(0x1234).L		; CF 79 00 00 12 34
	and	D0,*0xFFFFFFF0		; C1 78 FF F0
	and	D0, 0x00010004		; C1 79 00 01 00 04
	and	D0,(0x1234,A0,D1)	; C1 70 11 20 12 34
	and	D1,([2,A1,A2],4)	; C3 71 A1 22 00 02 00
	and	D2,([6,A2],D3,8)	; C5 72 31 26 00 06 00

	and.b	D7,D0			; C0 07
	and.b	(A1),D2			; C4 11
	and.b	(A2)+,D3		; C6 1A
	and.b	-(A3),D4		; C8 23
	and.b	1(A4),D5		; CA 2C 00 01
	and.b	2(A5,D7.W),D6		; CC 35 70 02
	and.b	2(A5,D7.L),D6		; CC 35 78 02
	and.b	(0x1234).W,D7		; CE 38 12 34
	and.b	(0x1234).L,D7		; CE 39 00 00 12 34
	and.b	*0xFFFFFFF0,D0		; C0 38 FF F0
	and.b	 0x00010004,D1		; C2 39 00 01 00 04
	and.b	#7,D2			; 02 02 00 07
	and.b	5(PC),D3		; C6 3A 00 03
	and.b	6(PC,A7.W),D4		; C8 3B F0 04
	and.b	6(PC,A7.L),D4		; C8 3B F8 04
	and.b	(0x1234,A0,D1),D0	; C0 30 11 20 12 34
	and.b	([2,A1,A2],4),D1	; C2 31 A1 22 00 02 00
	and.b	([6,A2],D3,8),D2	; C4 32 31 26 00 06 00
	and.b	(0x1234,PC,D1),D3	; C6 3B 11 20 12 32
	and.b	([2,PC,A2],4),D4	; C8 3B A1 22 00 00 00
	and.b	([6,PC],D3,8),D5	; CA 3B 31 26 00 04 00

	and.b	D2,(A1)			; C5 11
	and.b	D3,(A2)+		; C7 1A
	and.b	D4,-(A3)		; C9 23
	and.b	D5,1(A4)		; CB 2C 00 01
	and.b	D6,2(A5,D7.W)		; CD 35 70 02
	and.b	D6,2(A5,D7.L)		; CD 35 78 02
	and.b	D7,(0x1234).W		; CF 38 12 34
	and.b	D7,(0x1234).L		; CF 39 00 00 12 34
	and.b	D0,*0xFFFFFFF0		; C1 38 FF F0
	and.b	D0, 0x00010004		; C1 39 00 01 00 04
	and.b	D0,(0x1234,A0,D1)	; C1 30 11 20 12 34
	and.b	D1,([2,A1,A2],4)	; C3 31 A1 22 00 02 00
	and.b	D2,([6,A2],D3,8)	; C5 32 31 26 00 06 00

	and.w	D7,D0			; C0 47
	and.w	(A1),D2			; C4 51
	and.w	(A2)+,D3		; C6 5A
	and.w	-(A3),D4		; C8 63
	and.w	1(A4),D5		; CA 6C 00 01
	and.w	2(A5,D7.W),D6		; CC 75 70 02
	and.w	2(A5,D7.L),D6		; CC 75 78 02
	and.w	(0x1234).W,D7		; CE 78 12 34
	and.w	(0x1234).L,D7		; CE 79 00 00 12 34
	and.w	*0xFFFFFFF0,D0		; C0 78 FF F0
	and.w	 0x00010004,D1		; C2 79 00 01 00 04
	and.w	#7,D2			; 02 42 00 07
	and.w	5(PC),D3		; C6 7A 00 03
	and.w	6(PC,A7.W),D4		; C8 7B F0 04
	and.w	6(PC,A7.L),D4		; C8 7B F8 04
	and.w	(0x1234,A0,D1),D0	; C0 70 11 20 12 34
	and.w	([2,A1,A2],4),D1	; C2 71 A1 22 00 02 00
	and.w	([6,A2],D3,8),D2	; C4 72 31 26 00 06 00
	and.w	(0x1234,PC,D1),D3	; C6 7B 11 20 12 32
	and.w	([2,PC,A2],4),D4	; C8 7B A1 22 00 00 00
	and.w	([6,PC],D3,8),D5	; CA 7B 31 26 00 04 00

	and.w	D2,(A1)			; C5 51
	and.w	D3,(A2)+		; C7 5A
	and.w	D4,-(A3)		; C9 63
	and.w	D5,1(A4)		; CB 6C 00 01
	and.w	D6,2(A5,D7.W)		; CD 75 70 02
	and.w	D6,2(A5,D7.L)		; CD 75 78 02
	and.w	D7,(0x1234).W		; CF 78 12 34
	and.w	D7,(0x1234).L		; CF 79 00 00 12 34
	and.w	D0,*0xFFFFFFF0		; C1 78 FF F0
	and.w	D0, 0x00010004		; C1 79 00 01 00 04
	and.w	D0,(0x1234,A0,D1)	; C1 70 11 20 12 34
	and.w	D1,([2,A1,A2],4)	; C3 71 A1 22 00 02 00
	and.w	D2,([6,A2],D3,8)	; C5 72 31 26 00 06 00

	and.l	D7,D0			; C0 87
	and.l	(A1),D2			; C4 91
	and.l	(A2)+,D3		; C6 9A
	and.l	-(A3),D4		; C8 A3
	and.l	1(A4),D5		; CA AC 00 01
	and.l	2(A5,D7.W),D6		; CC B5 70 02
	and.l	2(A5,D7.L),D6		; CC B5 78 02
	and.l	(0x1234).W,D7		; CE B8 12 34
	and.l	(0x1234).L,D7		; CE B9 00 00 12 34
	and.l	*0xFFFFFFF0,D0		; C0 B8 FF F0
	and.l	 0x00010004,D1		; C2 B9 00 01 00 04
	and.l	#7,D2			; 02 82 00 00 00 07
	and.l	5(PC),D3		; C6 BA 00 03
	and.l	6(PC,A7.W),D4		; C8 BB F0 04
	and.l	6(PC,A7.L),D4		; C8 BB F8 04
	and.l	(0x1234,A0,D1),D0	; C0 B0 11 20 12 34
	and.l	([2,A1,A2],4),D1	; C2 B1 A1 22 00 02 00
	and.l	([6,A2],D3,8),D2	; C4 B2 31 26 00 06 00
	and.l	(0x1234,PC,D1),D3	; C6 BB 11 20 12 32
	and.l	([2,PC,A2],4),D4	; C8 BB A1 22 00 00 00
	and.l	([6,PC],D3,8),D5	; CA BB 31 26 00 04 00

	and.l	D2,(A1)			; C5 91
	and.l	D3,(A2)+		; C7 9A
	and.l	D4,-(A3)		; C9 A3
	and.l	D5,1(A4)		; CB AC 00 01
	and.l	D6,2(A5,D7.W)		; CD B5 70 02
	and.l	D6,2(A5,D7.L)		; CD B5 78 02
	and.l	D7,(0x1234).W		; CF B8 12 34
	and.l	D7,(0x1234).L		; CF B9 00 00 12 34
	and.l	D0,*0xFFFFFFF0		; C1 B8 FF F0
	and.l	D0, 0x00010004		; C1 B9 00 01 00 04
	and.l	D0,(0x1234,A0,D1)	; C1 B0 11 20 12 34
	and.l	D1,([2,A1,A2],4)	; C3 B1 A1 22 00 02 00
	and.l	D2,([6,A2],D3,8)	; C5 B2 31 26 00 06 00

	or	D7,D0			; 80 47
	or	(A1),D2			; 84 51
	or	(A2)+,D3		; 86 5A
	or	-(A3),D4		; 88 63
	or	1(A4),D5		; 8A 6C 00 01
	or	2(A5,D7.W),D6		; 8C 75 70 02
	or	2(A5,D7.L),D6		; 8C 75 78 02
	or	(0x1234).W,D7		; 8E 78 12 34
	or	(0x1234).L,D7		; 8E 79 00 00 12 34
	or	*0xFFFFFFF0,D0		; 80 78 FF F0
	or	 0x00010004,D1		; 82 79 00 01 00 04
	or	#7,D2			; 00 42 00 07
	or	5(PC),D3		; 86 7A 00 03
	or	6(PC,A7.W),D4		; 88 7B F0 04
	or	6(PC,A7.L),D4		; 88 7B F8 04
	or	(0x1234,A0,D1),D0	; 80 70 11 20 12 34
	or	([2,A1,A2],4),D1	; 82 71 A1 22 00 02 00
	or	([6,A2],D3,8),D2	; 84 72 31 26 00 06 00
	or	(0x1234,PC,D1),D3	; 86 7B 11 20 12 32
	or	([2,PC,A2],4),D4	; 88 7B A1 22 00 00 00
	or	([6,PC],D3,8),D5	; 8A 7B 31 26 00 04 00

	or	D2,(A1)			; 85 51
	or	D3,(A2)+		; 87 5A
	or	D4,-(A3)		; 89 63
	or	D5,1(A4)		; 8B 6C 00 01
	or	D6,2(A5,D7.W)		; 8D 75 70 02
	or	D6,2(A5,D7.L)		; 8D 75 78 02
	or	D7,(0x1234).W		; 8F 78 12 34
	or	D7,(0x1234).L		; 8F 79 00 00 12 34
	or	D0,*0xFFFFFFF0		; 81 78 FF F0
	or	D0, 0x00010004		; 81 79 00 01 00 04
	or	D0,(0x1234,A0,D1)	; 81 70 11 20 12 34
	or	D1,([2,A1,A2],4)	; 83 71 A1 22 00 02 00
	or	D2,([6,A2],D3,8)	; 85 72 31 26 00 06 00

	or.b	D7,D0			; 80 07
	or.b	(A1),D2			; 84 11
	or.b	(A2)+,D3		; 86 1A
	or.b	-(A3),D4		; 88 23
	or.b	1(A4),D5		; 8A 2C 00 01
	or.b	2(A5,D7.W),D6		; 8C 35 70 02
	or.b	2(A5,D7.L),D6		; 8C 35 78 02
	or.b	(0x1234).W,D7		; 8E 38 12 34
	or.b	(0x1234).L,D7		; 8E 39 00 00 12 34
	or.b	*0xFFFFFFF0,D0		; 80 38 FF F0
	or.b	 0x00010004,D1		; 82 39 00 01 00 04
	or.b	#7,D2			; 00 02 00 07
	or.b	5(PC),D3		; 86 3A 00 03
	or.b	6(PC,A7.W),D4		; 88 3B F0 04
	or.b	6(PC,A7.L),D4		; 88 3B F8 04
	or.b	(0x1234,A0,D1),D0	; 80 30 11 20 12 34
	or.b	([2,A1,A2],4),D1	; 82 31 A1 22 00 02 00
	or.b	([6,A2],D3,8),D2	; 84 32 31 26 00 06 00
	or.b	(0x1234,PC,D1),D3	; 86 3B 11 20 12 32
	or.b	([2,PC,A2],4),D4	; 88 3B A1 22 00 00 00
	or.b	([6,PC],D3,8),D5	; 8A 3B 31 26 00 04 00

	or.b	D2,(A1)			; 85 11
	or.b	D3,(A2)+		; 87 1A
	or.b	D4,-(A3)		; 89 23
	or.b	D5,1(A4)		; 8B 2C 00 01
	or.b	D6,2(A5,D7.W)		; 8D 35 70 02
	or.b	D6,2(A5,D7.L)		; 8D 35 78 02
	or.b	D7,(0x1234).W		; 8F 38 12 34
	or.b	D7,(0x1234).L		; 8F 39 00 00 12 34
	or.b	D0,*0xFFFFFFF0		; 81 38 FF F0
	or.b	D0, 0x00010004		; 81 39 00 01 00 04
	or.b	D0,(0x1234,A0,D1)	; 81 30 11 20 12 34
	or.b	D1,([2,A1,A2],4)	; 83 31 A1 22 00 02 00
	or.b	D2,([6,A2],D3,8)	; 85 32 31 26 00 06 00

	or.w	D7,D0			; 80 47
	or.w	(A1),D2			; 84 51
	or.w	(A2)+,D3		; 86 5A
	or.w	-(A3),D4		; 88 63
	or.w	1(A4),D5		; 8A 6C 00 01
	or.w	2(A5,D7.W),D6		; 8C 75 70 02
	or.w	2(A5,D7.L),D6		; 8C 75 78 02
	or.w	(0x1234).W,D7		; 8E 78 12 34
	or.w	(0x1234).L,D7		; 8E 79 00 00 12 34
	or.w	*0xFFFFFFF0,D0		; 80 78 FF F0
	or.w	 0x00010004,D1		; 82 79 00 01 00 04
	or.w	#7,D2			; 00 42 00 07
	or.w	5(PC),D3		; 86 7A 00 03
	or.w	6(PC,A7.W),D4		; 88 7B F0 04
	or.w	6(PC,A7.L),D4		; 88 7B F8 04
	or.w	(0x1234,A0,D1),D0	; 80 70 11 20 12 34
	or.w	([2,A1,A2],4),D1	; 82 71 A1 22 00 02 00
	or.w	([6,A2],D3,8),D2	; 84 72 31 26 00 06 00
	or.w	(0x1234,PC,D1),D3	; 86 7B 11 20 12 32
	or.w	([2,PC,A2],4),D4	; 88 7B A1 22 00 00 00
	or.w	([6,PC],D3,8),D5	; 8A 7B 31 26 00 04 00

	or.w	D2,(A1)			; 85 51
	or.w	D3,(A2)+		; 87 5A
	or.w	D4,-(A3)		; 89 63
	or.w	D5,1(A4)		; 8B 6C 00 01
	or.w	D6,2(A5,D7.W)		; 8D 75 70 02
	or.w	D6,2(A5,D7.L)		; 8D 75 78 02
	or.w	D7,(0x1234).W		; 8F 78 12 34
	or.w	D7,(0x1234).L		; 8F 79 00 00 12 34
	or.w	D0,*0xFFFFFFF0		; 81 78 FF F0
	or.w	D0, 0x00010004		; 81 79 00 01 00 04
	or.w	D0,(0x1234,A0,D1)	; 81 70 11 20 12 34
	or.w	D1,([2,A1,A2],4)	; 83 71 A1 22 00 02 00
	or.w	D2,([6,A2],D3,8)	; 85 72 31 26 00 06 00

	or.l	D7,D0			; 80 87
	or.l	(A1),D2			; 84 91
	or.l	(A2)+,D3		; 86 9A
	or.l	-(A3),D4		; 88 A3
	or.l	1(A4),D5		; 8A AC 00 01
	or.l	2(A5,D7.W),D6		; 8C B5 70 02
	or.l	2(A5,D7.L),D6		; 8C B5 78 02
	or.l	(0x1234).W,D7		; 8E B8 12 34
	or.l	(0x1234).L,D7		; 8E B9 00 00 12 34
	or.l	*0xFFFFFFF0,D0		; 80 B8 FF F0
	or.l	 0x00010004,D1		; 82 B9 00 01 00 04
	or.l	#7,D2			; 00 82 00 00 00 07
	or.l	5(PC),D3		; 86 BA 00 03
	or.l	6(PC,A7.W),D4		; 88 BB F0 04
	or.l	6(PC,A7.L),D4		; 88 BB F8 04
	or.l	(0x1234,A0,D1),D0	; 80 B0 11 20 12 34
	or.l	([2,A1,A2],4),D1	; 82 B1 A1 22 00 02 00
	or.l	([6,A2],D3,8),D2	; 84 B2 31 26 00 06 00
	or.l	(0x1234,PC,D1),D3	; 86 BB 11 20 12 32
	or.l	([2,PC,A2],4),D4	; 88 BB A1 22 00 00 00
	or.l	([6,PC],D3,8),D5	; 8A BB 31 26 00 04 00

	or.l	D2,(A1)			; 85 91
	or.l	D3,(A2)+		; 87 9A
	or.l	D4,-(A3)		; 89 A3
	or.l	D5,1(A4)		; 8B AC 00 01
	or.l	D6,2(A5,D7.W)		; 8D B5 70 02
	or.l	D6,2(A5,D7.L)		; 8D B5 78 02
	or.l	D7,(0x1234).W		; 8F B8 12 34
	or.l	D7,(0x1234).L		; 8F B9 00 00 12 34
	or.l	D0,*0xFFFFFFF0		; 81 B8 FF F0
	or.l	D0, 0x00010004		; 81 B9 00 01 00 04
	or.l	D0,(0x1234,A0,D1)	; 81 B0 11 20 12 34
	or.l	D1,([2,A1,A2],4)	; 83 B1 A1 22 00 02 00
	or.l	D2,([6,A2],D3,8)	; 85 B2 31 26 00 06 00

	sub	D7,D0			; 90 47
	sub	A0,D1			; 92 48
	sub	(A1),D2			; 94 51
	sub	(A2)+,D3		; 96 5A
	sub	-(A3),D4		; 98 63
	sub	1(A4),D5		; 9A 6C 00 01
	sub	2(A5,D7.W),D6		; 9C 75 70 02
	sub	2(A5,D7.L),D6		; 9C 75 78 02
	sub	(0x1234).W,D7		; 9E 78 12 34
	sub	(0x1234).L,D7		; 9E 79 00 00 12 34
	sub	*0xFFFFFFF0,D0		; 90 78 FF F0
	sub	 0x00010004,D1		; 92 79 00 01 00 04
	sub	#7,D2			; 5F 42
	sub	5(PC),D3		; 96 7A 00 03
	sub	6(PC,A7.W),D4		; 98 7B F0 04
	sub	6(PC,A7.L),D4		; 98 7B F8 04
	sub	(0x1234,A0,D1),D0	; 90 70 11 20 12 34
	sub	([2,A1,A2],4),D1	; 92 71 A1 22 00 02 00
	sub	([6,A2],D3,8),D2	; 94 72 31 26 00 06 00
	sub	(0x1234,PC,D1),D3	; 96 7B 11 20 12 32
	sub	([2,PC,A2],4),D4	; 98 7B A1 22 00 00 00
	sub	([6,PC],D3,8),D5	; 9A 7B 31 26 00 04 00

	sub	D1,A1			; 92 C1
	sub	D2,(A1)			; 95 51
	sub	D3,(A2)+		; 97 5A
	sub	D4,-(A3)		; 99 63
	sub	D5,1(A4)		; 9B 6C 00 01
	sub	D6,2(A5,D7.W)		; 9D 75 70 02
	sub	D6,2(A5,D7.L)		; 9D 75 78 02
	sub	D7,(0x1234).W		; 9F 78 12 34
	sub	D7,(0x1234).L		; 9F 79 00 00 12 34
	sub	D0,*0xFFFFFFF0		; 91 78 FF F0
	sub	D0, 0x00010004		; 91 79 00 01 00 04
	sub	D0,(0x1234,A0,D1)	; 91 70 11 20 12 34
	sub	D1,([2,A1,A2],4)	; 93 71 A1 22 00 02 00
	sub	D2,([6,A2],D3,8)	; 95 72 31 26 00 06 00

	sub.b	D7,D0			; 90 07
	sub.b	(A1),D2			; 94 11
	sub.b	(A2)+,D3		; 96 1A
	sub.b	-(A3),D4		; 98 23
	sub.b	1(A4),D5		; 9A 2C 00 01
	sub.b	2(A5,D7.W),D6		; 9C 35 70 02
	sub.b	2(A5,D7.L),D6		; 9C 35 78 02
	sub.b	(0x1234).W,D7		; 9E 38 12 34
	sub.b	(0x1234).L,D7		; 9E 39 00 00 12 34
	sub.b	*0xFFFFFFF0,D0		; 90 38 FF F0
	sub.b	 0x00010004,D1		; 92 39 00 01 00 04
	sub.b	#7,D2			; 5F 02
	sub.b	5(PC),D3		; 96 3A 00 03
	sub.b	6(PC,A7.W),D4		; 98 3B F0 04
	sub.b	6(PC,A7.L),D4		; 98 3B F8 04
	sub.b	(0x1234,A0,D1),D0	; 90 30 11 20 12 34
	sub.b	([2,A1,A2],4),D1	; 92 31 A1 22 00 02 00
	sub.b	([6,A2],D3,8),D2	; 94 32 31 26 00 06 00
	sub.b	(0x1234,PC,D1),D3	; 96 3B 11 20 12 32
	sub.b	([2,PC,A2],4),D4	; 98 3B A1 22 00 00 00
	sub.b	([6,PC],D3,8),D5	; 9A 3B 31 26 00 04 00

	sub.b	D2,(A1)			; 95 11
	sub.b	D3,(A2)+		; 97 1A
	sub.b	D4,-(A3)		; 99 23
	sub.b	D5,1(A4)		; 9B 2C 00 01
	sub.b	D6,2(A5,D7.W)		; 9D 35 70 02
	sub.b	D6,2(A5,D7.L)		; 9D 35 78 02
	sub.b	D7,(0x1234).W		; 9F 38 12 34
	sub.b	D7,(0x1234).L		; 9F 39 00 00 12 34
	sub.b	D0,*0xFFFFFFF0		; 91 38 FF F0
	sub.b	D0, 0x00010004		; 91 39 00 01 00 04
	sub.b	D0,(0x1234,A0,D1)	; 91 30 11 20 12 34
	sub.b	D1,([2,A1,A2],4)	; 93 31 A1 22 00 02 00
	sub.b	D2,([6,A2],D3,8)	; 95 32 31 26 00 06 00

	sub.w	D7,D0			; 90 47
	sub.w	A0,D1			; 92 48
	sub.w	(A1),D2			; 94 51
	sub.w	(A2)+,D3		; 96 5A
	sub.w	-(A3),D4		; 98 63
	sub.w	1(A4),D5		; 9A 6C 00 01
	sub.w	2(A5,D7.W),D6		; 9C 75 70 02
	sub.w	2(A5,D7.L),D6		; 9C 75 78 02
	sub.w	(0x1234).W,D7		; 9E 78 12 34
	sub.w	(0x1234).L,D7		; 9E 79 00 00 12 34
	sub.w	*0xFFFFFFF0,D0		; 90 78 FF F0
	sub.w	 0x00010004,D1		; 92 79 00 01 00 04
	sub.w	#7,D2			; 5F 42
	sub.w	5(PC),D3		; 96 7A 00 03
	sub.w	6(PC,A7.W),D4		; 98 7B F0 04
	sub.w	6(PC,A7.L),D4		; 98 7B F8 04
	sub.w	(0x1234,A0,D1),D0	; 90 70 11 20 12 34
	sub.w	([2,A1,A2],4),D1	; 92 71 A1 22 00 02 00
	sub.w	([6,A2],D3,8),D2	; 94 72 31 26 00 06 00
	sub.w	(0x1234,PC,D1),D3	; 96 7B 11 20 12 32
	sub.w	([2,PC,A2],4),D4	; 98 7B A1 22 00 00 00
	sub.w	([6,PC],D3,8),D5	; 9A 7B 31 26 00 04 00

	sub.w	D1,A1			; 92 C1
	sub.w	D2,(A1)			; 95 51
	sub.w	D3,(A2)+		; 97 5A
	sub.w	D4,-(A3)		; 99 63
	sub.w	D5,1(A4)		; 9B 6C 00 01
	sub.w	D6,2(A5,D7.W)		; 9D 75 70 02
	sub.w	D6,2(A5,D7.L)		; 9D 75 78 02
	sub.w	D7,(0x1234).W		; 9F 78 12 34
	sub.w	D7,(0x1234).L		; 9F 79 00 00 12 34
	sub.w	D0,*0xFFFFFFF0		; 91 78 FF F0
	sub.w	D0, 0x00010004		; 91 79 00 01 00 04
	sub.w	D0,(0x1234,A0,D1)	; 91 70 11 20 12 34
	sub.w	D1,([2,A1,A2],4)	; 93 71 A1 22 00 02 00
	sub.w	D2,([6,A2],D3,8)	; 95 72 31 26 00 06 00

	sub.l	D7,D0			; 90 87
	sub.l	A0,D1			; 92 88
	sub.l	(A1),D2			; 94 91
	sub.l	(A2)+,D3		; 96 9A
	sub.l	-(A3),D4		; 98 A3
	sub.l	1(A4),D5		; 9A AC 00 01
	sub.l	2(A5,D7.W),D6		; 9C B5 70 02
	sub.l	2(A5,D7.L),D6		; 9C B5 78 02
	sub.l	(0x1234).W,D7		; 9E B8 12 34
	sub.l	(0x1234).L,D7		; 9E B9 00 00 12 34
	sub.l	*0xFFFFFFF0,D0		; 90 B8 FF F0
	sub.l	 0x00010004,D1		; 92 B9 00 01 00 04
	sub.l	#7,D2			; 5F 82
	sub.l	5(PC),D3		; 96 BA 00 03
	sub.l	6(PC,A7.W),D4		; 98 BB F0 04
	sub.l	6(PC,A7.L),D4		; 98 BB F8 04
	sub.l	(0x1234,A0,D1),D0	; 90 B0 11 20 12 34
	sub.l	([2,A1,A2],4),D1	; 92 B1 A1 22 00 02 00
	sub.l	([6,A2],D3,8),D2	; 94 B2 31 26 00 06 00
	sub.l	(0x1234,PC,D1),D3	; 96 BB 11 20 12 32
	sub.l	([2,PC,A2],4),D4	; 98 BB A1 22 00 00 00
	sub.l	([6,PC],D3,8),D5	; 9A BB 31 26 00 04 00

	sub.l	D1,A1			; 93 C1
	sub.l	D2,(A1)			; 95 91
	sub.l	D3,(A2)+		; 97 9A
	sub.l	D4,-(A3)		; 99 A3
	sub.l	D5,1(A4)		; 9B AC 00 01
	sub.l	D6,2(A5,D7.W)		; 9D B5 70 02
	sub.l	D6,2(A5,D7.L)		; 9D B5 78 02
	sub.l	D7,(0x1234).W		; 9F B8 12 34
	sub.l	D7,(0x1234).L		; 9F B9 00 00 12 34
	sub.l	D0,*0xFFFFFFF0		; 91 B8 FF F0
	sub.l	D0, 0x00010004		; 91 B9 00 01 00 04
	sub.l	D0,(0x1234,A0,D1)	; 91 B0 11 20 12 34
	sub.l	D1,([2,A1,A2],4)	; 93 B1 A1 22 00 02 00
	sub.l	D2,([6,A2],D3,8)	; 95 B2 31 26 00 06 00

	.sbttl	Type S_TYP3 Instructions: ADDA, CMPA, SUBA

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_TYP3:						*
	;*	ADDA, CMPA, SUBA				*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	adda	D7,A0			; D0 C7
	adda	A0,A1			; D2 C8
	adda	(A1),A2			; D4 D1
	adda	(A2)+,A3		; D6 DA
	adda	-(A3),A4		; D8 E3
	adda	1(A4),A5		; DA EC 00 01
	adda	2(A5,D7.W),A6		; DC F5 70 02
	adda	2(A5,D7.L),A6		; DC F5 78 02
	adda	(0x1234).W,A7		; DE F8 12 34
	adda	(0x1234).L,A7		; DE F9 00 00 12 34
	adda	*0xFFFFFFF0,A0		; D0 F8 FF F0
	adda	 0x00010004,A1		; D2 F9 00 01 00 04
	adda	#7,A2			; D4 FC 00 07
	adda	5(PC),A3		; D6 FA 00 03
	adda	6(PC,A7.W),A4		; D8 FB F0 04
	adda	6(PC,A7.L),A4		; D8 FB F8 04
	adda	(0x1234,A0,D1),A0	; D0 F0 11 20 12 34
	adda	([2,A1,A2],4),A1	; D2 F1 A1 22 00 02 00
	adda	([6,A2],D3,8),A2	; D4 F2 31 26 00 06 00
	adda	(0x1234,PC,D1),A3	; D6 FB 11 20 12 32
	adda	([2,PC,A2],4),A4	; D8 FB A1 22 00 00 00
	adda	([6,PC],D3,8),A5	; DA FB 31 26 00 04 00

	adda.w	D7,A0			; D0 C7
	adda.w	A0,A1			; D2 C8
	adda.w	(A1),A2			; D4 D1
	adda.w	(A2)+,A3		; D6 DA
	adda.w	-(A3),A4		; D8 E3
	adda.w	1(A4),A5		; DA EC 00 01
	adda.w	2(A5,D7.W),A6		; DC F5 70 02
	adda.w	2(A5,D7.L),A6		; DC F5 78 02
	adda.w	(0x1234).W,A7		; DE F8 12 34
	adda.w	(0x1234).L,A7		; DE F9 00 00 12 34
	adda.w	*0xFFFFFFF0,A0		; D0 F8 FF F0
	adda.w	 0x00010004,A1		; D2 F9 00 01 00 04
	adda.w	#7,A2			; D4 FC 00 07
	adda.w	5(PC),A3		; D6 FA 00 03
	adda.w	6(PC,A7.W),A4		; D8 FB F0 04
	adda.w	6(PC,A7.L),A4		; D8 FB F8 04
	adda.w	(0x1234,A0,D1),A0	; D0 F0 11 20 12 34
	adda.w	([2,A1,A2],4),A1	; D2 F1 A1 22 00 02 00
	adda.w	([6,A2],D3,8),A2	; D4 F2 31 26 00 06 00
	adda.w	(0x1234,PC,D1),A3	; D6 FB 11 20 12 32
	adda.w	([2,PC,A2],4),A4	; D8 FB A1 22 00 00 00
	adda.w	([6,PC],D3,8),A5	; DA FB 31 26 00 04 00

	adda.l	D7,A0			; D1 C7
	adda.l	A0,A1			; D3 C8
	adda.l	(A1),A2			; D5 D1
	adda.l	(A2)+,A3		; D7 DA
	adda.l	-(A3),A4		; D9 E3
	adda.l	1(A4),A5		; DB EC 00 01
	adda.l	2(A5,D7.W),A6		; DD F5 70 02
	adda.l	2(A5,D7.L),A6		; DD F5 78 02
	adda.l	(0x1234).W,A7		; DF F8 12 34
	adda.l	(0x1234).L,A7		; DF F9 00 00 12 34
	adda.l	*0xFFFFFFF0,A0		; D1 F8 FF F0
	adda.l	 0x00010004,A1		; D3 F9 00 01 00 04
	adda.l	#7,A2			; D5 FC 00 00 00 07
	adda.l	5(PC),A3		; D7 FA 00 03
	adda.l	6(PC,A7.W),A4		; D9 FB F0 04
	adda.l	6(PC,A7.L),A4		; D9 FB F8 04
	adda.l	(0x1234,A0,D1),A0	; D1 F0 11 20 12 34
	adda.l	([2,A1,A2],4),A1	; D3 F1 A1 22 00 02 00
	adda.l	([6,A2],D3,8),A2	; D5 F2 31 26 00 06 00
	adda.l	(0x1234,PC,D1),A3	; D7 FB 11 20 12 32
	adda.l	([2,PC,A2],4),A4	; D9 FB A1 22 00 00 00
	adda.l	([6,PC],D3,8),A5	; DB FB 31 26 00 04 00

	cmpa	D7,A0			; B0 C7
	cmpa	A0,A1			; B2 C8
	cmpa	(A1),A2			; B4 D1
	cmpa	(A2)+,A3		; B6 DA
	cmpa	-(A3),A4		; B8 E3
	cmpa	1(A4),A5		; BA EC 00 01
	cmpa	2(A5,D7.W),A6		; BC F5 70 02
	cmpa	2(A5,D7.L),A6		; BC F5 78 02
	cmpa	(0x1234).W,A7		; BE F8 12 34
	cmpa	(0x1234).L,A7		; BE F9 00 00 12 34
	cmpa	*0xFFFFFFF0,A0		; B0 F8 FF F0
	cmpa	 0x00010004,A1		; B2 F9 00 01 00 04
	cmpa	#7,A2			; B4 FC 00 07
	cmpa	5(PC),A3		; B6 FA 00 03
	cmpa	6(PC,A7.W),A4		; B8 FB F0 04
	cmpa	6(PC,A7.L),A4		; B8 FB F8 04
	cmpa	(0x1234,A0,D1),A0	; B0 F0 11 20 12 34
	cmpa	([2,A1,A2],4),A1	; B2 F1 A1 22 00 02 00
	cmpa	([6,A2],D3,8),A2	; B4 F2 31 26 00 06 00
	cmpa	(0x1234,PC,D1),A3	; B6 FB 11 20 12 32
	cmpa	([2,PC,A2],4),A4	; B8 FB A1 22 00 00 00
	cmpa	([6,PC],D3,8),A5	; BA FB 31 26 00 04 00

	cmpa.w	D7,A0			; B0 C7
	cmpa.w	A0,A1			; B2 C8
	cmpa.w	(A1),A2			; B4 D1
	cmpa.w	(A2)+,A3		; B6 DA
	cmpa.w	-(A3),A4		; B8 E3
	cmpa.w	1(A4),A5		; BA EC 00 01
	cmpa.w	2(A5,D7.W),A6		; BC F5 70 02
	cmpa.w	2(A5,D7.L),A6		; BC F5 78 02
	cmpa.w	(0x1234).W,A7		; BE F8 12 34
	cmpa.w	(0x1234).L,A7		; BE F9 00 00 12 34
	cmpa.w	*0xFFFFFFF0,A0		; B0 F8 FF F0
	cmpa.w	 0x00010004,A1		; B2 F9 00 01 00 04
	cmpa.w	#7,A2			; B4 FC 00 07
	cmpa.w	5(PC),A3		; B6 FA 00 03
	cmpa.w	6(PC,A7.W),A4		; B8 FB F0 04
	cmpa.w	6(PC,A7.L),A4		; B8 FB F8 04
	cmpa.w	(0x1234,A0,D1),A0	; B0 F0 11 20 12 34
	cmpa.w	([2,A1,A2],4),A1	; B2 F1 A1 22 00 02 00
	cmpa.w	([6,A2],D3,8),A2	; B4 F2 31 26 00 06 00
	cmpa.w	(0x1234,PC,D1),A3	; B6 FB 11 20 12 32
	cmpa.w	([2,PC,A2],4),A4	; B8 FB A1 22 00 00 00
	cmpa.w	([6,PC],D3,8),A5	; BA FB 31 26 00 04 00

	cmpa.l	D7,A0			; B1 C7
	cmpa.l	A0,A1			; B3 C8
	cmpa.l	(A1),A2			; B5 D1
	cmpa.l	(A2)+,A3		; B7 DA
	cmpa.l	-(A3),A4		; B9 E3
	cmpa.l	1(A4),A5		; BB EC 00 01
	cmpa.l	2(A5,D7.W),A6		; BD F5 70 02
	cmpa.l	2(A5,D7.L),A6		; BD F5 78 02
	cmpa.l	(0x1234).W,A7		; BF F8 12 34
	cmpa.l	(0x1234).L,A7		; BF F9 00 00 12 34
	cmpa.l	*0xFFFFFFF0,A0		; B1 F8 FF F0
	cmpa.l	 0x00010004,A1		; B3 F9 00 01 00 04
	cmpa.l	#7,A2			; B5 FC 00 00 00 07
	cmpa.l	5(PC),A3		; B7 FA 00 03
	cmpa.l	6(PC,A7.W),A4		; B9 FB F0 04
	cmpa.l	6(PC,A7.L),A4		; B9 FB F8 04
	cmpa.l	(0x1234,A0,D1),A0	; B1 F0 11 20 12 34
	cmpa.l	([2,A1,A2],4),A1	; B3 F1 A1 22 00 02 00
	cmpa.l	([6,A2],D3,8),A2	; B5 F2 31 26 00 06 00
	cmpa.l	(0x1234,PC,D1),A3	; B7 FB 11 20 12 32
	cmpa.l	([2,PC,A2],4),A4	; B9 FB A1 22 00 00 00
	cmpa.l	([6,PC],D3,8),A5	; BB FB 31 26 00 04 00

	suba	D7,A0			; 90 C7
	suba	A0,A1			; 92 C8
	suba	(A1),A2			; 94 D1
	suba	(A2)+,A3		; 96 DA
	suba	-(A3),A4		; 98 E3
	suba	1(A4),A5		; 9A EC 00 01
	suba	2(A5,D7.W),A6		; 9C F5 70 02
	suba	2(A5,D7.L),A6		; 9C F5 78 02
	suba	(0x1234).W,A7		; 9E F8 12 34
	suba	(0x1234).L,A7		; 9E F9 00 00 12 34
	suba	*0xFFFFFFF0,A0		; 90 F8 FF F0
	suba	 0x00010004,A1		; 92 F9 00 01 00 04
	suba	#7,A2			; 94 FC 00 07
	suba	5(PC),A3		; 96 FA 00 03
	suba	6(PC,A7.W),A4		; 98 FB F0 04
	suba	6(PC,A7.L),A4		; 98 FB F8 04
	suba	(0x1234,A0,D1),A0	; 90 F0 11 20 12 34
	suba	([2,A1,A2],4),A1	; 92 F1 A1 22 00 02 00
	suba	([6,A2],D3,8),A2	; 94 F2 31 26 00 06 00
	suba	(0x1234,PC,D1),A3	; 96 FB 11 20 12 32
	suba	([2,PC,A2],4),A4	; 98 FB A1 22 00 00 00
	suba	([6,PC],D3,8),A5	; 9A FB 31 26 00 04 00

	suba.w	D7,A0			; 90 C7
	suba.w	A0,A1			; 92 C8
	suba.w	(A1),A2			; 94 D1
	suba.w	(A2)+,A3		; 96 DA
	suba.w	-(A3),A4		; 98 E3
	suba.w	1(A4),A5		; 9A EC 00 01
	suba.w	2(A5,D7.W),A6		; 9C F5 70 02
	suba.w	2(A5,D7.L),A6		; 9C F5 78 02
	suba.w	(0x1234).W,A7		; 9E F8 12 34
	suba.w	(0x1234).L,A7		; 9E F9 00 00 12 34
	suba.w	*0xFFFFFFF0,A0		; 90 F8 FF F0
	suba.w	 0x00010004,A1		; 92 F9 00 01 00 04
	suba.w	#7,A2			; 94 FC 00 07
	suba.w	5(PC),A3		; 96 FA 00 03
	suba.w	6(PC,A7.W),A4		; 98 FB F0 04
	suba.w	6(PC,A7.L),A4		; 98 FB F8 04
	suba.w	(0x1234,A0,D1),A0	; 90 F0 11 20 12 34
	suba.w	([2,A1,A2],4),A1	; 92 F1 A1 22 00 02 00
	suba.w	([6,A2],D3,8),A2	; 94 F2 31 26 00 06 00
	suba.w	(0x1234,PC,D1),A3	; 96 FB 11 20 12 32
	suba.w	([2,PC,A2],4),A4	; 98 FB A1 22 00 00 00
	suba.w	([6,PC],D3,8),A5	; 9A FB 31 26 00 04 00

	suba.l	D7,A0			; 91 C7
	suba.l	A0,A1			; 93 C8
	suba.l	(A1),A2			; 95 D1
	suba.l	(A2)+,A3		; 97 DA
	suba.l	-(A3),A4		; 99 E3
	suba.l	1(A4),A5		; 9B EC 00 01
	suba.l	2(A5,D7.W),A6		; 9D F5 70 02
	suba.l	2(A5,D7.L),A6		; 9D F5 78 02
	suba.l	(0x1234).W,A7		; 9F F8 12 34
	suba.l	(0x1234).L,A7		; 9F F9 00 00 12 34
	suba.l	*0xFFFFFFF0,A0		; 91 F8 FF F0
	suba.l	 0x00010004,A1		; 93 F9 00 01 00 04
	suba.l	#7,A2			; 95 FC 00 00 00 07
	suba.l	5(PC),A3		; 97 FA 00 03
	suba.l	6(PC,A7.W),A4		; 99 FB F0 04
	suba.l	6(PC,A7.L),A4		; 99 FB F8 04
	suba.l	(0x1234,A0,D1),A0	; 91 F0 11 20 12 34
	suba.l	([2,A1,A2],4),A1	; 93 F1 A1 22 00 02 00
	suba.l	([6,A2],D3,8),A2	; 95 F2 31 26 00 06 00
	suba.l	(0x1234,PC,D1),A3	; 97 FB 11 20 12 32
	suba.l	([2,PC,A2],4),A4	; 99 FB A1 22 00 00 00
	suba.l	([6,PC],D3,8),A5	; 9B FB 31 26 00 04 00

	.sbttl	Type S_TYP4 Instructions: ADDI, ANDI, CMPI, EORI, ORI, SUBI

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_TYP4:						*
	;*	ADDI, ANDI, CMPI, EORI, ORI, SUBI		*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	addi	#0,D7			; 06 47 00 00
	addi	#1,(A1)			; 06 51 00 01
	addi	#2,(A2)+		; 06 5A 00 02
	addi	#3,-(A3)		; 06 63 00 03
	addi	#4,1(A4)		; 06 6C 00 04 00 01
	addi	#5,2(A5,D7.W)		; 06 75 00 05 70 02
	addi	#6,2(A5,D7.L)		; 06 75 00 06 78 02
	addi	#7,(0x1234).W		; 06 78 00 07 12 34
	addi	#8,(0x1234).L		; 06 79 00 08 00 00 12
	addi	#9,*0xFFFFFFF0		; 06 78 00 09 FF F0
	addi	#10, 0x00010004		; 06 79 00 0A 00 01 00
	addi	#11,(0x1234,A0,D1)	; 06 70 00 0B 11 20 12
	addi	#12,([2,A1,A2],4)	; 06 71 00 0C A1 22 00
	addi	#13,([6,A2],D3,8)	; 06 72 00 0D 31 26 00

	addi.b	#0,D7			; 06 07 00 00
	addi.b	#1,(A1)			; 06 11 00 01
	addi.b	#2,(A2)+		; 06 1A 00 02
	addi.b	#3,-(A3)		; 06 23 00 03
	addi.b	#4,1(A4)		; 06 2C 00 04 00 01
	addi.b	#5,2(A5,D7.W)		; 06 35 00 05 70 02
	addi.b	#6,2(A5,D7.L)		; 06 35 00 06 78 02
	addi.b	#7,(0x1234).W		; 06 38 00 07 12 34
	addi.b	#8,(0x1234).L		; 06 39 00 08 00 00 12
	addi.b	#9,*0xFFFFFFF0		; 06 38 00 09 FF F0
	addi.b	#10, 0x00010004		; 06 39 00 0A 00 01 00
	addi.b	#11,(0x1234,A0,D1)	; 06 30 00 0B 11 20 12
	addi.b	#12,([2,A1,A2],4)	; 06 31 00 0C A1 22 00
	addi.b	#13,([6,A2],D3,8)	; 06 32 00 0D 31 26 00

	addi.w	#0,D7			; 06 47 00 00
	addi.w	#1,(A1)			; 06 51 00 01
	addi.w	#2,(A2)+		; 06 5A 00 02
	addi.w	#3,-(A3)		; 06 63 00 03
	addi.w	#4,1(A4)		; 06 6C 00 04 00 01
	addi.w	#5,2(A5,D7.W)		; 06 75 00 05 70 02
	addi.w	#6,2(A5,D7.L)		; 06 75 00 06 78 02
	addi.w	#7,(0x1234).W		; 06 78 00 07 12 34
	addi.w	#8,(0x1234).L		; 06 79 00 08 00 00 12
	addi.w	#9,*0xFFFFFFF0		; 06 78 00 09 FF F0
	addi.w	#10, 0x00010004		; 06 79 00 0A 00 01 00
	addi.w	#11,(0x1234,A0,D1)	; 06 70 00 0B 11 20 12
	addi.w	#12,([2,A1,A2],4)	; 06 71 00 0C A1 22 00
	addi.w	#13,([6,A2],D3,8)	; 06 72 00 0D 31 26 00

	addi.l	#0,D7			; 06 87 00 00 00 00
	addi.l	#1,(A1)			; 06 91 00 00 00 01
	addi.l	#2,(A2)+		; 06 9A 00 00 00 02
	addi.l	#3,-(A3)		; 06 A3 00 00 00 03
	addi.l	#4,1(A4)		; 06 AC 00 00 00 04 00
	addi.l	#5,2(A5,D7.W)		; 06 B5 00 00 00 05 70
	addi.l	#6,2(A5,D7.L)		; 06 B5 00 00 00 06 78
	addi.l	#7,(0x1234).W		; 06 B8 00 00 00 07 12
	addi.l	#8,(0x1234).L		; 06 B9 00 00 00 08 00
	addi.l	#9,*0xFFFFFFF0		; 06 B8 00 00 00 09 FF
	addi.l	#10, 0x00010004		; 06 B9 00 00 00 0A 00
	addi.l	#11,(0x1234,A0,D1)	; 06 B0 00 00 00 0B 11
	addi.l	#12,([2,A1,A2],4)	; 06 B1 00 00 00 0C A1
	addi.l	#13,([6,A2],D3,8)	; 06 B2 00 00 00 0D 31

	andi	#0,D7			; 02 47 00 00
	andi	#1,(A1)			; 02 51 00 01
	andi	#2,(A2)+		; 02 5A 00 02
	andi	#3,-(A3)		; 02 63 00 03
	andi	#4,1(A4)		; 02 6C 00 04 00 01
	andi	#5,2(A5,D7.W)		; 02 75 00 05 70 02
	andi	#6,2(A5,D7.L)		; 02 75 00 06 78 02
	andi	#7,(0x1234).W		; 02 78 00 07 12 34
	andi	#8,(0x1234).L		; 02 79 00 08 00 00 12
	andi	#9,*0xFFFFFFF0		; 02 78 00 09 FF F0
	andi	#10, 0x00010004		; 02 79 00 0A 00 01 00
	andi	#11,(0x1234,A0,D1)	; 02 70 00 0B 11 20 12
	andi	#12,([2,A1,A2],4)	; 02 71 00 0C A1 22 00
	andi	#13,([6,A2],D3,8)	; 02 72 00 0D 31 26 00

	andi	#1,CCR			; 02 3C 00 01

	andi	#3,SR			; 02 7C 00 03

	andi.b	#0,D7			; 02 07 00 00
	andi.b	#1,(A1)			; 02 11 00 01
	andi.b	#2,(A2)+		; 02 1A 00 02
	andi.b	#3,-(A3)		; 02 23 00 03
	andi.b	#4,1(A4)		; 02 2C 00 04 00 01
	andi.b	#5,2(A5,D7.W)		; 02 35 00 05 70 02
	andi.b	#6,2(A5,D7.L)		; 02 35 00 06 78 02
	andi.b	#7,(0x1234).W		; 02 38 00 07 12 34
	andi.b	#8,(0x1234).L		; 02 39 00 08 00 00 12
	andi.b	#9,*0xFFFFFFF0		; 02 38 00 09 FF F0
	andi.b	#10, 0x00010004		; 02 39 00 0A 00 01 00
	andi.b	#11,(0x1234,A0,D1)	; 02 30 00 0B 11 20 12
	andi.b	#12,([2,A1,A2],4)	; 02 31 00 0C A1 22 00
	andi.b	#13,([6,A2],D3,8)	; 02 32 00 0D 31 26 00

	andi.b	#1,CCR			; 02 3C 00 01

	andi.w	#0,D7			; 02 47 00 00
	andi.w	#1,(A1)			; 02 51 00 01
	andi.w	#2,(A2)+		; 02 5A 00 02
	andi.w	#3,-(A3)		; 02 63 00 03
	andi.w	#4,1(A4)		; 02 6C 00 04 00 01
	andi.w	#5,2(A5,D7.W)		; 02 75 00 05 70 02
	andi.w	#6,2(A5,D7.L)		; 02 75 00 06 78 02
	andi.w	#7,(0x1234).W		; 02 78 00 07 12 34
	andi.w	#8,(0x1234).L		; 02 79 00 08 00 00 12
	andi.w	#9,*0xFFFFFFF0		; 02 78 00 09 FF F0
	andi.w	#10, 0x00010004		; 02 79 00 0A 00 01 00
	andi.w	#11,(0x1234,A0,D1)	; 02 70 00 0B 11 20 12
	andi.w	#12,([2,A1,A2],4)	; 02 71 00 0C A1 22 00
	andi.w	#13,([6,A2],D3,8)	; 02 72 00 0D 31 26 00

	andi.w	#3,SR			; 02 7C 00 03

	andi.l	#0,D7			; 02 87 00 00 00 00
	andi.l	#1,(A1)			; 02 91 00 00 00 01
	andi.l	#2,(A2)+		; 02 9A 00 00 00 02
	andi.l	#3,-(A3)		; 02 A3 00 00 00 03
	andi.l	#4,1(A4)		; 02 AC 00 00 00 04 00
	andi.l	#5,2(A5,D7.W)		; 02 B5 00 00 00 05 70
	andi.l	#6,2(A5,D7.L)		; 02 B5 00 00 00 06 78
	andi.l	#7,(0x1234).W		; 02 B8 00 00 00 07 12
	andi.l	#8,(0x1234).L		; 02 B9 00 00 00 08 00
	andi.l	#9,*0xFFFFFFF0		; 02 B8 00 00 00 09 FF
	andi.l	#10, 0x00010004		; 02 B9 00 00 00 0A 00
	andi.l	#11,(0x1234,A0,D1)	; 02 B0 00 00 00 0B 11
	andi.l	#12,([2,A1,A2],4)	; 02 B1 00 00 00 0C A1
	andi.l	#13,([6,A2],D3,8)	; 02 B2 00 00 00 0D 31

	cmpi	#0,D7			; 0C 47 00 00
	cmpi	#1,(A1)			; 0C 51 00 01
	cmpi	#2,(A2)+		; 0C 5A 00 02
	cmpi	#3,-(A3)		; 0C 63 00 03
	cmpi	#4,1(A4)		; 0C 6C 00 04 00 01
	cmpi	#5,2(A5,D7.W)		; 0C 75 00 05 70 02
	cmpi	#6,2(A5,D7.L)		; 0C 75 00 06 78 02
	cmpi	#7,(0x1234).W		; 0C 78 00 07 12 34
	cmpi	#8,(0x1234).L		; 0C 79 00 08 00 00 12
	cmpi	#9,*0xFFFFFFF0		; 0C 78 00 09 FF F0
	cmpi	#10, 0x00010004		; 0C 79 00 0A 00 01 00
	cmpi	#11,(0x1234,A0,D1)	; 0C 70 00 0B 11 20 12
	cmpi	#12,([2,A1,A2],4)	; 0C 71 00 0C A1 22 00
	cmpi	#13,([6,A2],D3,8)	; 0C 72 00 0D 31 26 00
	cmpi	#14,5(PC)		; 0C 7A 00 0E 00 01
	cmpi	#15,6(PC,A3.W)		; 0C 7B 00 0F B0 02
	cmpi	#16,6(PC,A3.L)		; 0C 7B 00 10 B8 02
	cmpi	#17,(0x1234,PC,D1)	; 0C 7B 00 11 11 20 12
	cmpi	#18,([2,PC,A2],4)	; 0C 7B 00 12 A1 22 FF
	cmpi	#19,([6,PC],D3,8)	; 0C 7B 00 13 31 26 00

	cmpi.b	#0,D7			; 0C 07 00 00
	cmpi.b	#1,(A1)			; 0C 11 00 01
	cmpi.b	#2,(A2)+		; 0C 1A 00 02
	cmpi.b	#3,-(A3)		; 0C 23 00 03
	cmpi.b	#4,1(A4)		; 0C 2C 00 04 00 01
	cmpi.b	#5,2(A5,D7.W)		; 0C 35 00 05 70 02
	cmpi.b	#6,2(A5,D7.L)		; 0C 35 00 06 78 02
	cmpi.b	#7,(0x1234).W		; 0C 38 00 07 12 34
	cmpi.b	#8,(0x1234).L		; 0C 39 00 08 00 00 12
	cmpi.b	#9,*0xFFFFFFF0		; 0C 38 00 09 FF F0
	cmpi.b	#10, 0x00010004		; 0C 39 00 0A 00 01 00
	cmpi.b	#11,(0x1234,A0,D1)	; 0C 30 00 0B 11 20 12
	cmpi.b	#12,([2,A1,A2],4)	; 0C 31 00 0C A1 22 00
	cmpi.b	#13,([6,A2],D3,8)	; 0C 32 00 0D 31 26 00
	cmpi.b	#14,5(PC)		; 0C 3A 00 0E 00 01
	cmpi.b	#15,6(PC,A3.W)		; 0C 3B 00 0F B0 02
	cmpi.b	#16,6(PC,A3.L)		; 0C 3B 00 10 B8 02
	cmpi.b	#17,(0x1234,PC,D1)	; 0C 3B 00 11 11 20 12
	cmpi.b	#18,([2,PC,A2],4)	; 0C 3B 00 12 A1 22 FF
	cmpi.b	#19,([6,PC],D3,8)	; 0C 3B 00 13 31 26 00

	cmpi.w	#0,D7			; 0C 47 00 00
	cmpi.w	#1,(A1)			; 0C 51 00 01
	cmpi.w	#2,(A2)+		; 0C 5A 00 02
	cmpi.w	#3,-(A3)		; 0C 63 00 03
	cmpi.w	#4,1(A4)		; 0C 6C 00 04 00 01
	cmpi.w	#5,2(A5,D7.W)		; 0C 75 00 05 70 02
	cmpi.w	#6,2(A5,D7.L)		; 0C 75 00 06 78 02
	cmpi.w	#7,(0x1234).W		; 0C 78 00 07 12 34
	cmpi.w	#8,(0x1234).L		; 0C 79 00 08 00 00 12
	cmpi.w	#9,*0xFFFFFFF0		; 0C 78 00 09 FF F0
	cmpi.w	#10, 0x00010004		; 0C 79 00 0A 00 01 00
	cmpi.w	#11,(0x1234,A0,D1)	; 0C 70 00 0B 11 20 12
	cmpi.w	#12,([2,A1,A2],4)	; 0C 71 00 0C A1 22 00
	cmpi.w	#13,([6,A2],D3,8)	; 0C 72 00 0D 31 26 00
	cmpi.w	#14,5(PC)		; 0C 7A 00 0E 00 01
	cmpi.w	#15,6(PC,A3.W)		; 0C 7B 00 0F B0 02
	cmpi.w	#16,6(PC,A3.L)		; 0C 7B 00 10 B8 02
	cmpi.w	#17,(0x1234,PC,D1)	; 0C 7B 00 11 11 20 12
	cmpi.w	#18,([2,PC,A2],4)	; 0C 7B 00 12 A1 22 FF
	cmpi.w	#19,([6,PC],D3,8)	; 0C 7B 00 13 31 26 00

	cmpi.l	#0,D7			; 0C 87 00 00 00 00
	cmpi.l	#1,(A1)			; 0C 91 00 00 00 01
	cmpi.l	#2,(A2)+		; 0C 9A 00 00 00 02
	cmpi.l	#3,-(A3)		; 0C A3 00 00 00 03
	cmpi.l	#4,1(A4)		; 0C AC 00 00 00 04 00
	cmpi.l	#5,2(A5,D7.W)		; 0C B5 00 00 00 05 70
	cmpi.l	#6,2(A5,D7.L)		; 0C B5 00 00 00 06 78
	cmpi.l	#7,(0x1234).W		; 0C B8 00 00 00 07 12
	cmpi.l	#8,(0x1234).L		; 0C B9 00 00 00 08 00
	cmpi.l	#9,*0xFFFFFFF0		; 0C B8 00 00 00 09 FF
	cmpi.l	#10, 0x00010004		; 0C B9 00 00 00 0A 00
	cmpi.l	#11,(0x1234,A0,D1)	; 0C B0 00 00 00 0B 11
	cmpi.l	#12,([2,A1,A2],4)	; 0C B1 00 00 00 0C A1
	cmpi.l	#13,([6,A2],D3,8)	; 0C B2 00 00 00 0D 31
	cmpi.l	#14,5(PC)		; 0C BA 00 00 00 0E FF
	cmpi.l	#15,6(PC,A3.W)		; 0C BB 00 00 00 0F B0
	cmpi.l	#16,6(PC,A3.L)		; 0C BB 00 00 00 10 B8
	cmpi.l	#17,(0x1234,PC,D1)	; 0C BB 00 00 00 11 11
	cmpi.l	#18,([2,PC,A2],4)	; 0C BB 00 00 00 12 A1
	cmpi.l	#19,([6,PC],D3,8)	; 0C BB 00 00 00 13 31

	eori	#0,D7			; 0A 47 00 00
	eori	#1,(A1)			; 0A 51 00 01
	eori	#2,(A2)+		; 0A 5A 00 02
	eori	#3,-(A3)		; 0A 63 00 03
	eori	#4,1(A4)		; 0A 6C 00 04 00 01
	eori	#5,2(A5,D7.W)		; 0A 75 00 05 70 02
	eori	#6,2(A5,D7.L)		; 0A 75 00 06 78 02
	eori	#7,(0x1234).W		; 0A 78 00 07 12 34
	eori	#8,(0x1234).L		; 0A 79 00 08 00 00 12
	eori	#9,*0xFFFFFFF0		; 0A 78 00 09 FF F0
	eori	#10, 0x00010004		; 0A 79 00 0A 00 01 00
	eori	#11,(0x1234,A0,D1)	; 0A 70 00 0B 11 20 12
	eori	#12,([2,A1,A2],4)	; 0A 71 00 0C A1 22 00
	eori	#13,([6,A2],D3,8)	; 0A 72 00 0D 31 26 00

	eori.b	#0,D7			; 0A 07 00 00
	eori.b	#1,(A1)			; 0A 11 00 01
	eori.b	#2,(A2)+		; 0A 1A 00 02
	eori.b	#3,-(A3)		; 0A 23 00 03
	eori.b	#4,1(A4)		; 0A 2C 00 04 00 01
	eori.b	#5,2(A5,D7.W)		; 0A 35 00 05 70 02
	eori.b	#6,2(A5,D7.L)		; 0A 35 00 06 78 02
	eori.b	#7,(0x1234).W		; 0A 38 00 07 12 34
	eori.b	#8,(0x1234).L		; 0A 39 00 08 00 00 12
	eori.b	#9,*0xFFFFFFF0		; 0A 38 00 09 FF F0
	eori.b	#10, 0x00010004		; 0A 39 00 0A 00 01 00
	eori.b	#11,(0x1234,A0,D1)	; 0A 30 00 0B 11 20 12
	eori.b	#12,([2,A1,A2],4)	; 0A 31 00 0C A1 22 00
	eori.b	#13,([6,A2],D3,8)	; 0A 32 00 0D 31 26 00

	eori.w	#0,D7			; 0A 47 00 00
	eori.w	#1,(A1)			; 0A 51 00 01
	eori.w	#2,(A2)+		; 0A 5A 00 02
	eori.w	#3,-(A3)		; 0A 63 00 03
	eori.w	#4,1(A4)		; 0A 6C 00 04 00 01
	eori.w	#5,2(A5,D7.W)		; 0A 75 00 05 70 02
	eori.w	#6,2(A5,D7.L)		; 0A 75 00 06 78 02
	eori.w	#7,(0x1234).W		; 0A 78 00 07 12 34
	eori.w	#8,(0x1234).L		; 0A 79 00 08 00 00 12
	eori.w	#9,*0xFFFFFFF0		; 0A 78 00 09 FF F0
	eori.w	#10, 0x00010004		; 0A 79 00 0A 00 01 00
	eori.w	#11,(0x1234,A0,D1)	; 0A 70 00 0B 11 20 12
	eori.w	#12,([2,A1,A2],4)	; 0A 71 00 0C A1 22 00
	eori.w	#13,([6,A2],D3,8)	; 0A 72 00 0D 31 26 00

	eori.l	#0,D7			; 0A 87 00 00 00 00
	eori.l	#1,(A1)			; 0A 91 00 00 00 01
	eori.l	#2,(A2)+		; 0A 9A 00 00 00 02
	eori.l	#3,-(A3)		; 0A A3 00 00 00 03
	eori.l	#4,1(A4)		; 0A AC 00 00 00 04 00
	eori.l	#5,2(A5,D7.W)		; 0A B5 00 00 00 05 70
	eori.l	#6,2(A5,D7.L)		; 0A B5 00 00 00 06 78
	eori.l	#7,(0x1234).W		; 0A B8 00 00 00 07 12
	eori.l	#8,(0x1234).L		; 0A B9 00 00 00 08 00
	eori.l	#9,*0xFFFFFFF0		; 0A B8 00 00 00 09 FF
	eori.l	#10, 0x00010004		; 0A B9 00 00 00 0A 00
	eori.l	#11,(0x1234,A0,D1)	; 0A B0 00 00 00 0B 11
	eori.l	#12,([2,A1,A2],4)	; 0A B1 00 00 00 0C A1
	eori.l	#13,([6,A2],D3,8)	; 0A B2 00 00 00 0D 31

	ori	#0,D7			; 00 47 00 00
	ori	#1,(A1)			; 00 51 00 01
	ori	#2,(A2)+		; 00 5A 00 02
	ori	#3,-(A3)		; 00 63 00 03
	ori	#4,1(A4)		; 00 6C 00 04 00 01
	ori	#5,2(A5,D7.W)		; 00 75 00 05 70 02
	ori	#6,2(A5,D7.L)		; 00 75 00 06 78 02
	ori	#7,(0x1234).W		; 00 78 00 07 12 34
	ori	#8,(0x1234).L		; 00 79 00 08 00 00 12
	ori	#9,*0xFFFFFFF0		; 00 78 00 09 FF F0
	ori	#10, 0x00010004		; 00 79 00 0A 00 01 00
	ori	#11,(0x1234,A0,D1)	; 00 70 00 0B 11 20 12
	ori	#12,([2,A1,A2],4)	; 00 71 00 0C A1 22 00
	ori	#13,([6,A2],D3,8)	; 00 72 00 0D 31 26 00

	ori.b	#0,D7			; 00 07 00 00
	ori.b	#1,(A1)			; 00 11 00 01
	ori.b	#2,(A2)+		; 00 1A 00 02
	ori.b	#3,-(A3)		; 00 23 00 03
	ori.b	#4,1(A4)		; 00 2C 00 04 00 01
	ori.b	#5,2(A5,D7.W)		; 00 35 00 05 70 02
	ori.b	#6,2(A5,D7.L)		; 00 35 00 06 78 02
	ori.b	#7,(0x1234).W		; 00 38 00 07 12 34
	ori.b	#8,(0x1234).L		; 00 39 00 08 00 00 12
	ori.b	#9,*0xFFFFFFF0		; 00 38 00 09 FF F0
	ori.b	#10, 0x00010004		; 00 39 00 0A 00 01 00
	ori.b	#11,(0x1234,A0,D1)	; 00 30 00 0B 11 20 12
	ori.b	#12,([2,A1,A2],4)	; 00 31 00 0C A1 22 00
	ori.b	#13,([6,A2],D3,8)	; 00 32 00 0D 31 26 00

	ori.w	#0,D7			; 00 47 00 00
	ori.w	#1,(A1)			; 00 51 00 01
	ori.w	#2,(A2)+		; 00 5A 00 02
	ori.w	#3,-(A3)		; 00 63 00 03
	ori.w	#4,1(A4)		; 00 6C 00 04 00 01
	ori.w	#5,2(A5,D7.W)		; 00 75 00 05 70 02
	ori.w	#6,2(A5,D7.L)		; 00 75 00 06 78 02
	ori.w	#7,(0x1234).W		; 00 78 00 07 12 34
	ori.w	#8,(0x1234).L		; 00 79 00 08 00 00 12
	ori.w	#9,*0xFFFFFFF0		; 00 78 00 09 FF F0
	ori.w	#10, 0x00010004		; 00 79 00 0A 00 01 00
	ori.w	#11,(0x1234,A0,D1)	; 00 70 00 0B 11 20 12
	ori.w	#12,([2,A1,A2],4)	; 00 71 00 0C A1 22 00
	ori.w	#13,([6,A2],D3,8)	; 00 72 00 0D 31 26 00

	ori.l	#0,D7			; 00 87 00 00 00 00
	ori.l	#1,(A1)			; 00 91 00 00 00 01
	ori.l	#2,(A2)+		; 00 9A 00 00 00 02
	ori.l	#3,-(A3)		; 00 A3 00 00 00 03
	ori.l	#4,1(A4)		; 00 AC 00 00 00 04 00
	ori.l	#5,2(A5,D7.W)		; 00 B5 00 00 00 05 70
	ori.l	#6,2(A5,D7.L)		; 00 B5 00 00 00 06 78
	ori.l	#7,(0x1234).W		; 00 B8 00 00 00 07 12
	ori.l	#8,(0x1234).L		; 00 B9 00 00 00 08 00
	ori.l	#9,*0xFFFFFFF0		; 00 B8 00 00 00 09 FF
	ori.l	#10, 0x00010004		; 00 B9 00 00 00 0A 00
	ori.l	#11,(0x1234,A0,D1)	; 00 B0 00 00 00 0B 11
	ori.l	#12,([2,A1,A2],4)	; 00 B1 00 00 00 0C A1
	ori.l	#13,([6,A2],D3,8)	; 00 B2 00 00 00 0D 31

	subi	#0,D7			; 04 47 00 00
	subi	#1,(A1)			; 04 51 00 01
	subi	#2,(A2)+		; 04 5A 00 02
	subi	#3,-(A3)		; 04 63 00 03
	subi	#4,1(A4)		; 04 6C 00 04 00 01
	subi	#5,2(A5,D7.W)		; 04 75 00 05 70 02
	subi	#6,2(A5,D7.L)		; 04 75 00 06 78 02
	subi	#7,(0x1234).W		; 04 78 00 07 12 34
	subi	#8,(0x1234).L		; 04 79 00 08 00 00 12
	subi	#9,*0xFFFFFFF0		; 04 78 00 09 FF F0
	subi	#10, 0x00010004		; 04 79 00 0A 00 01 00
	subi	#11,(0x1234,A0,D1)	; 04 70 00 0B 11 20 12
	subi	#12,([2,A1,A2],4)	; 04 71 00 0C A1 22 00
	subi	#13,([6,A2],D3,8)	; 04 72 00 0D 31 26 00

	subi.b	#0,D7			; 04 07 00 00
	subi.b	#1,(A1)			; 04 11 00 01
	subi.b	#2,(A2)+		; 04 1A 00 02
	subi.b	#3,-(A3)		; 04 23 00 03
	subi.b	#4,1(A4)		; 04 2C 00 04 00 01
	subi.b	#5,2(A5,D7.W)		; 04 35 00 05 70 02
	subi.b	#6,2(A5,D7.L)		; 04 35 00 06 78 02
	subi.b	#7,(0x1234).W		; 04 38 00 07 12 34
	subi.b	#8,(0x1234).L		; 04 39 00 08 00 00 12
	subi.b	#9,*0xFFFFFFF0		; 04 38 00 09 FF F0
	subi.b	#10, 0x00010004		; 04 39 00 0A 00 01 00
	subi.b	#11,(0x1234,A0,D1)	; 04 30 00 0B 11 20 12
	subi.b	#12,([2,A1,A2],4)	; 04 31 00 0C A1 22 00
	subi.b	#13,([6,A2],D3,8)	; 04 32 00 0D 31 26 00

	subi.w	#0,D7			; 04 47 00 00
	subi.w	#1,(A1)			; 04 51 00 01
	subi.w	#2,(A2)+		; 04 5A 00 02
	subi.w	#3,-(A3)		; 04 63 00 03
	subi.w	#4,1(A4)		; 04 6C 00 04 00 01
	subi.w	#5,2(A5,D7.W)		; 04 75 00 05 70 02
	subi.w	#6,2(A5,D7.L)		; 04 75 00 06 78 02
	subi.w	#7,(0x1234).W		; 04 78 00 07 12 34
	subi.w	#8,(0x1234).L		; 04 79 00 08 00 00 12
	subi.w	#9,*0xFFFFFFF0		; 04 78 00 09 FF F0
	subi.w	#10, 0x00010004		; 04 79 00 0A 00 01 00
	subi.w	#11,(0x1234,A0,D1)	; 04 70 00 0B 11 20 12
	subi.w	#12,([2,A1,A2],4)	; 04 71 00 0C A1 22 00
	subi.w	#13,([6,A2],D3,8)	; 04 72 00 0D 31 26 00

	subi.l	#0,D7			; 04 87 00 00 00 00
	subi.l	#1,(A1)			; 04 91 00 00 00 01
	subi.l	#2,(A2)+		; 04 9A 00 00 00 02
	subi.l	#3,-(A3)		; 04 A3 00 00 00 03
	subi.l	#4,1(A4)		; 04 AC 00 00 00 04 00
	subi.l	#5,2(A5,D7.W)		; 04 B5 00 00 00 05 70
	subi.l	#6,2(A5,D7.L)		; 04 B5 00 00 00 06 78
	subi.l	#7,(0x1234).W		; 04 B8 00 00 00 07 12
	subi.l	#8,(0x1234).L		; 04 B9 00 00 00 08 00
	subi.l	#9,*0xFFFFFFF0		; 04 B8 00 00 00 09 FF
	subi.l	#10, 0x00010004		; 04 B9 00 00 00 0A 00
	subi.l	#11,(0x1234,A0,D1)	; 04 B0 00 00 00 0B 11
	subi.l	#12,([2,A1,A2],4)	; 04 B1 00 00 00 0C A1
	subi.l	#13,([6,A2],D3,8)	; 04 B2 00 00 00 0D 31

	.sbttl	Type S_TYP5 Instructions: ADDQ, SUBQ

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_TYP5:						*
	;*	ADDQ, SUBQ					*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	addq	#8,D7			; 50 47
	addq	#1,A0			; 52 48
	addq	#2,(A1)			; 54 51
	addq	#3,(A2)+		; 56 5A
	addq	#4,-(A3)		; 58 63
	addq	#5,1(A4)		; 5A 6C 00 01
	addq	#6,2(A5,D7.W)		; 5C 75 70 02
	addq	#6,2(A5,D7.L)		; 5C 75 78 02
	addq	#7,(0x1234).W		; 5E 78 12 34
	addq	#7,(0x1234).L		; 5E 79 00 00 12 34
	addq	#8,*0xFFFFFFF0		; 50 78 FF F0
	addq	#1, 0x00010004		; 52 79 00 01 00 04
	addq	#2,(0x1234,A0,D1)	; 54 70 11 20 12 34
	addq	#3,([2,A1,A2],4)	; 56 71 A1 22 00 02 00
	addq	#4,([6,A2],D3,8)	; 58 72 31 26 00 06 00

	addq.b	#8,D7			; 50 07
	addq.b	#2,(A1)			; 54 11
	addq.b	#3,(A2)+		; 56 1A
	addq.b	#4,-(A3)		; 58 23
	addq.b	#5,1(A4)		; 5A 2C 00 01
	addq.b	#6,2(A5,D7.W)		; 5C 35 70 02
	addq.b	#6,2(A5,D7.L)		; 5C 35 78 02
	addq.b	#7,(0x1234).W		; 5E 38 12 34
	addq.b	#7,(0x1234).L		; 5E 39 00 00 12 34
	addq.b	#8,*0xFFFFFFF0		; 50 38 FF F0
	addq.b	#1, 0x00010004		; 52 39 00 01 00 04
	addq.b	#2,(0x1234,A0,D1)	; 54 30 11 20 12 34
	addq.b	#3,([2,A1,A2],4)	; 56 31 A1 22 00 02 00
	addq.b	#4,([6,A2],D3,8)	; 58 32 31 26 00 06 00

	addq.w	#8,D7			; 50 47
	addq.w	#1,A0			; 52 48
	addq.w	#2,(A1)			; 54 51
	addq.w	#3,(A2)+		; 56 5A
	addq.w	#4,-(A3)		; 58 63
	addq.w	#5,1(A4)		; 5A 6C 00 01
	addq.w	#6,2(A5,D7.W)		; 5C 75 70 02
	addq.w	#6,2(A5,D7.L)		; 5C 75 78 02
	addq.w	#7,(0x1234).W		; 5E 78 12 34
	addq.w	#7,(0x1234).L		; 5E 79 00 00 12 34
	addq.w	#8,*0xFFFFFFF0		; 50 78 FF F0
	addq.w	#1, 0x00010004		; 52 79 00 01 00 04
	addq.w	#2,(0x1234,A0,D1)	; 54 70 11 20 12 34
	addq.w	#3,([2,A1,A2],4)	; 56 71 A1 22 00 02 00
	addq.w	#4,([6,A2],D3,8)	; 58 72 31 26 00 06 00

	addq.l	#8,D7			; 50 87
	addq.l	#1,A0			; 52 88
	addq.l	#2,(A1)			; 54 91
	addq.l	#3,(A2)+		; 56 9A
	addq.l	#4,-(A3)		; 58 A3
	addq.l	#5,1(A4)		; 5A AC 00 01
	addq.l	#6,2(A5,D7.W)		; 5C B5 70 02
	addq.l	#6,2(A5,D7.L)		; 5C B5 78 02
	addq.l	#7,(0x1234).W		; 5E B8 12 34
	addq.l	#7,(0x1234).L		; 5E B9 00 00 12 34
	addq.l	#8,*0xFFFFFFF0		; 50 B8 FF F0
	addq.l	#1, 0x00010004		; 52 B9 00 01 00 04
	addq.l	#2,(0x1234,A0,D1)	; 54 B0 11 20 12 34
	addq.l	#3,([2,A1,A2],4)	; 56 B1 A1 22 00 02 00
	addq.l	#4,([6,A2],D3,8)	; 58 B2 31 26 00 06 00

	subq	#8,D7			; 51 47
	subq	#1,A0			; 53 48
	subq	#2,(A1)			; 55 51
	subq	#3,(A2)+		; 57 5A
	subq	#4,-(A3)		; 59 63
	subq	#5,1(A4)		; 5B 6C 00 01
	subq	#6,2(A5,D7.W)		; 5D 75 70 02
	subq	#6,2(A5,D7.L)		; 5D 75 78 02
	subq	#7,(0x1234).W		; 5F 78 12 34
	subq	#7,(0x1234).L		; 5F 79 00 00 12 34
	subq	#8,*0xFFFFFFF0		; 51 78 FF F0
	subq	#1, 0x00010004		; 53 79 00 01 00 04
	subq	#2,(0x1234,A0,D1)	; 55 70 11 20 12 34
	subq	#3,([2,A1,A2],4)	; 57 71 A1 22 00 02 00
	subq	#4,([6,A2],D3,8)	; 59 72 31 26 00 06 00

	subq.b	#8,D7			; 51 07
	subq.b	#2,(A1)			; 55 11
	subq.b	#3,(A2)+		; 57 1A
	subq.b	#4,-(A3)		; 59 23
	subq.b	#5,1(A4)		; 5B 2C 00 01
	subq.b	#6,2(A5,D7.W)		; 5D 35 70 02
	subq.b	#6,2(A5,D7.L)		; 5D 35 78 02
	subq.b	#7,(0x1234).W		; 5F 38 12 34
	subq.b	#7,(0x1234).L		; 5F 39 00 00 12 34
	subq.b	#8,*0xFFFFFFF0		; 51 38 FF F0
	subq.b	#1, 0x00010004		; 53 39 00 01 00 04
	subq.b	#2,(0x1234,A0,D1)	; 55 30 11 20 12 34
	subq.b	#3,([2,A1,A2],4)	; 57 31 A1 22 00 02 00
	subq.b	#4,([6,A2],D3,8)	; 59 32 31 26 00 06 00

	subq.w	#8,D7			; 51 47
	subq.w	#1,A0			; 53 48
	subq.w	#2,(A1)			; 55 51
	subq.w	#3,(A2)+		; 57 5A
	subq.w	#4,-(A3)		; 59 63
	subq.w	#5,1(A4)		; 5B 6C 00 01
	subq.w	#6,2(A5,D7.W)		; 5D 75 70 02
	subq.w	#6,2(A5,D7.L)		; 5D 75 78 02
	subq.w	#7,(0x1234).W		; 5F 78 12 34
	subq.w	#7,(0x1234).L		; 5F 79 00 00 12 34
	subq.w	#8,*0xFFFFFFF0		; 51 78 FF F0
	subq.w	#1, 0x00010004		; 53 79 00 01 00 04
	subq.w	#2,(0x1234,A0,D1)	; 55 70 11 20 12 34
	subq.w	#3,([2,A1,A2],4)	; 57 71 A1 22 00 02 00
	subq.w	#4,([6,A2],D3,8)	; 59 72 31 26 00 06 00

	subq.l	#8,D7			; 51 87
	subq.l	#1,A0			; 53 88
	subq.l	#2,(A1)			; 55 91
	subq.l	#3,(A2)+		; 57 9A
	subq.l	#4,-(A3)		; 59 A3
	subq.l	#5,1(A4)		; 5B AC 00 01
	subq.l	#6,2(A5,D7.W)		; 5D B5 70 02
	subq.l	#6,2(A5,D7.L)		; 5D B5 78 02
	subq.l	#7,(0x1234).W		; 5F B8 12 34
	subq.l	#7,(0x1234).L		; 5F B9 00 00 12 34
	subq.l	#8,*0xFFFFFFF0		; 51 B8 FF F0
	subq.l	#1, 0x00010004		; 53 B9 00 01 00 04
	subq.l	#2,(0x1234,A0,D1)	; 55 B0 11 20 12 34
	subq.l	#3,([2,A1,A2],4)	; 57 B1 A1 22 00 02 00
	subq.l	#4,([6,A2],D3,8)	; 59 B2 31 26 00 06 00

	.sbttl	Type S_TYP6 Instructions: CHK, CMP, DIVS, DIVU, MULS, MULU

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_TYP6:						*
	;*	DIVS, DIVU, MULS, MULU				*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	divs	D0,D1			; 83 C0
	divs	(A1),D2			; 85 D1
	divs	(A2)+,D3		; 87 DA
	divs	-(A3),D4		; 89 E3
	divs	1(A4),D5		; 8B EC 00 01
	divs	2(A5,D7.W),D6		; 8D F5 70 02
	divs	2(A5,D7.L),D6		; 8D F5 78 02
	divs	(0x1234).W,D7		; 8F F8 12 34
	divs	(0x1234).L,D7		; 8F F9 00 00 12 34
	divs	*0xFFFFFFF0,D0		; 81 F8 FF F0
	divs	 0x00010004,D1		; 83 F9 00 01 00 04
	divs	#7,D2			; 85 FC 00 07
	divs	5(PC),D3		; 87 FA 00 03
	divs	6(PC,A7.W),D4		; 89 FB F0 04
	divs	6(PC,A7.L),D4		; 89 FB F8 04
	divs	(0x1234,A0,D1),D0	; 81 F0 11 20 12 34
	divs	([2,A1,A2],4),D1	; 83 F1 A1 22 00 02 00
	divs	([6,A2],D3,8),D2	; 85 F2 31 26 00 06 00
	divs	(0x1234,PC,D1),D3	; 87 FB 11 20 12 32
	divs	([2,PC,A2],4),D4	; 89 FB A1 22 00 00 00
	divs	([6,PC],D3,8),D5	; 8B FB 31 26 00 04 00

	divs.w	D0,D1			; 83 C0
	divs.w	(A1),D2			; 85 D1
	divs.w	(A2)+,D3		; 87 DA
	divs.w	-(A3),D4		; 89 E3
	divs.w	1(A4),D5		; 8B EC 00 01
	divs.w	2(A5,D7.W),D6		; 8D F5 70 02
	divs.w	2(A5,D7.L),D6		; 8D F5 78 02
	divs.w	(0x1234).W,D7		; 8F F8 12 34
	divs.w	(0x1234).L,D7		; 8F F9 00 00 12 34
	divs.w	*0xFFFFFFF0,D0		; 81 F8 FF F0
	divs.w	 0x00010004,D1		; 83 F9 00 01 00 04
	divs.w	#7,D2			; 85 FC 00 07
	divs.w	5(PC),D3		; 87 FA 00 03
	divs.w	6(PC,A7.W),D4		; 89 FB F0 04
	divs.w	6(PC,A7.L),D4		; 89 FB F8 04
	divs.w	(0x1234,A0,D1),D0	; 81 F0 11 20 12 34
	divs.w	([2,A1,A2],4),D1	; 83 F1 A1 22 00 02 00
	divs.w	([6,A2],D3,8),D2	; 85 F2 31 26 00 06 00
	divs.w	(0x1234,PC,D1),D3	; 87 FB 11 20 12 32
	divs.w	([2,PC,A2],4),D4	; 89 FB A1 22 00 00 00
	divs.w	([6,PC],D3,8),D5	; 8B FB 31 26 00 04 00

	divs.l	D0,D1			; 4C 40 18 01
	divs.l	(A1),D2			; 4C 51 28 02
	divs.l	(A2)+,D3		; 4C 5A 38 03
	divs.l	-(A3),D4		; 4C 63 48 04
	divs.l	1(A4),D5		; 4C 6C 58 05 00 01
	divs.l	2(A5,D7.W),D6		; 4C 75 68 06 70 02
	divs.l	2(A5,D7.L),D6		; 4C 75 68 06 78 02
	divs.l	(0x1234).W,D7		; 4C 78 78 07 12 34
	divs.l	(0x1234).L,D7		; 4C 79 78 07 00 00 12
	divs.l	*0xFFFFFFF0,D0		; 4C 78 08 00 FF F0
	divs.l	 0x00010004,D1		; 4C 79 18 01 00 01 00
	divs.l	#7,D2			; 4C 7C 28 02 00 00 00
	divs.l	5(PC),D3		; 4C 7A 38 03 00 01
	divs.l	6(PC,A7.W),D4		; 4C 7B 48 04 F0 02
	divs.l	6(PC,A7.L),D4		; 4C 7B 48 04 F8 02
	divs.l	(A1),D2:D3		; 4C 51 3C 02
	divs.l	(0x1234,A0,D1),D0	; 4C 70 08 00 11 20 12
	divs.l	([2,A1,A2],4),D1	; 4C 71 18 01 A1 22 00
	divs.l	([6,A2],D3,8),D2	; 4C 72 28 02 31 26 00
	divs.l	(0x1234,PC,D1),D3	; 4C 7B 38 03 11 20 12
	divs.l	([2,PC,A2],4),D4	; 4C 7B 48 04 A1 22 FF
	divs.l	([6,PC],D3,8),D5	; 4C 7B 58 05 31 26 00

	divsl.l	D0,D1			; 4C 40 18 01
	divsl.l	(A1),D2			; 4C 51 28 02
	divsl.l	(A2)+,D3		; 4C 5A 38 03
	divsl.l	-(A3),D4		; 4C 63 48 04
	divsl.l	1(A4),D5		; 4C 6C 58 05 00 01
	divsl.l	2(A5,D7.W),D6		; 4C 75 68 06 70 02
	divsl.l	2(A5,D7.L),D6		; 4C 75 68 06 78 02
	divsl.l	(0x1234).W,D7		; 4C 78 78 07 12 34
	divsl.l	(0x1234).L,D7		; 4C 79 78 07 00 00 12
	divsl.l	*0xFFFFFFF0,D0		; 4C 78 08 00 FF F0
	divsl.l	 0x00010004,D1		; 4C 79 18 01 00 01 00
	divsl.l	#7,D2			; 4C 7C 28 02 00 00 00
	divsl.l	5(PC),D3		; 4C 7A 38 03 00 01
	divsl.l	6(PC,A7.W),D4		; 4C 7B 48 04 F0 02
	divsl.l	6(PC,A7.L),D4		; 4C 7B 48 04 F8 02
	divsl.l	(A1),D2:D3		; 4C 51 38 02
	divsl.l	(0x1234,A0,D1),D0	; 4C 70 08 00 11 20 12
	divsl.l	([2,A1,A2],4),D1	; 4C 71 18 01 A1 22 00
	divsl.l	([6,A2],D3,8),D2	; 4C 72 28 02 31 26 00
	divsl.l	(0x1234,PC,D1),D3	; 4C 7B 38 03 11 20 12
	divsl.l	([2,PC,A2],4),D4	; 4C 7B 48 04 A1 22 FF
	divsl.l	([6,PC],D3,8),D5	; 4C 7B 58 05 31 26 00

	divu	D0,D1			; 82 C0
	divu	(A1),D2			; 84 D1
	divu	(A2)+,D3		; 86 DA
	divu	-(A3),D4		; 88 E3
	divu	1(A4),D5		; 8A EC 00 01
	divu	2(A5,D7.W),D6		; 8C F5 70 02
	divu	2(A5,D7.L),D6		; 8C F5 78 02
	divu	(0x1234).W,D7		; 8E F8 12 34
	divu	(0x1234).L,D7		; 8E F9 00 00 12 34
	divu	*0xFFFFFFF0,D0		; 80 F8 FF F0
	divu	 0x00010004,D1		; 82 F9 00 01 00 04
	divu	#7,D2			; 84 FC 00 07
	divu	5(PC),D3		; 86 FA 00 03
	divu	6(PC,A7.W),D4		; 88 FB F0 04
	divu	6(PC,A7.L),D4		; 88 FB F8 04
	divu	(0x1234,A0,D1),D0	; 80 F0 11 20 12 34
	divu	([2,A1,A2],4),D1	; 82 F1 A1 22 00 02 00
	divu	([6,A2],D3,8),D2	; 84 F2 31 26 00 06 00
	divu	(0x1234,PC,D1),D3	; 86 FB 11 20 12 32
	divu	([2,PC,A2],4),D4	; 88 FB A1 22 00 00 00
	divu	([6,PC],D3,8),D5	; 8A FB 31 26 00 04 00

	divu.w	D0,D1			; 82 C0
	divu.w	(A1),D2			; 84 D1
	divu.w	(A2)+,D3		; 86 DA
	divu.w	-(A3),D4		; 88 E3
	divu.w	1(A4),D5		; 8A EC 00 01
	divu.w	2(A5,D7.W),D6		; 8C F5 70 02
	divu.w	2(A5,D7.L),D6		; 8C F5 78 02
	divu.w	(0x1234).W,D7		; 8E F8 12 34
	divu.w	(0x1234).L,D7		; 8E F9 00 00 12 34
	divu.w	*0xFFFFFFF0,D0		; 80 F8 FF F0
	divu.w	 0x00010004,D1		; 82 F9 00 01 00 04
	divu.w	#7,D2			; 84 FC 00 07
	divu.w	5(PC),D3		; 86 FA 00 03
	divu.w	6(PC,A7.W),D4		; 88 FB F0 04
	divu.w	6(PC,A7.L),D4		; 88 FB F8 04
	divu.w	(0x1234,A0,D1),D0	; 80 F0 11 20 12 34
	divu.w	([2,A1,A2],4),D1	; 82 F1 A1 22 00 02 00
	divu.w	([6,A2],D3,8),D2	; 84 F2 31 26 00 06 00
	divu.w	(0x1234,PC,D1),D3	; 86 FB 11 20 12 32
	divu.w	([2,PC,A2],4),D4	; 88 FB A1 22 00 00 00
	divu.w	([6,PC],D3,8),D5	; 8A FB 31 26 00 04 00

	divu.l	D0,D1			; 4C 40 10 01
	divu.l	(A1),D2			; 4C 51 20 02
	divu.l	(A2)+,D3		; 4C 5A 30 03
	divu.l	-(A3),D4		; 4C 63 40 04
	divu.l	1(A4),D5		; 4C 6C 50 05 00 01
	divu.l	2(A5,D7.W),D6		; 4C 75 60 06 70 02
	divu.l	2(A5,D7.L),D6		; 4C 75 60 06 78 02
	divu.l	(0x1234).W,D7		; 4C 78 70 07 12 34
	divu.l	(0x1234).L,D7		; 4C 79 70 07 00 00 12
	divu.l	*0xFFFFFFF0,D0		; 4C 78 00 00 FF F0
	divu.l	 0x00010004,D1		; 4C 79 10 01 00 01 00
	divu.l	#7,D2			; 4C 7C 20 02 00 00 00
	divu.l	5(PC),D3		; 4C 7A 30 03 00 01
	divu.l	6(PC,A7.W),D4		; 4C 7B 40 04 F0 02
	divu.l	6(PC,A7.L),D4		; 4C 7B 40 04 F8 02
	divu.l	(A1),D2:D3		; 4C 51 34 02
	divu.l	(0x1234,A0,D1),D0	; 4C 70 00 00 11 20 12
	divu.l	([2,A1,A2],4),D1	; 4C 71 10 01 A1 22 00
	divu.l	([6,A2],D3,8),D2	; 4C 72 20 02 31 26 00
	divu.l	(0x1234,PC,D1),D3	; 4C 7B 30 03 11 20 12
	divu.l	([2,PC,A2],4),D4	; 4C 7B 40 04 A1 22 FF
	divu.l	([6,PC],D3,8),D5	; 4C 7B 50 05 31 26 00

	divul.l	D0,D1			; 4C 40 10 01
	divul.l	(A1),D2			; 4C 51 20 02
	divul.l	(A2)+,D3		; 4C 5A 30 03
	divul.l	-(A3),D4		; 4C 63 40 04
	divul.l	1(A4),D5		; 4C 6C 50 05 00 01
	divul.l	2(A5,D7.W),D6		; 4C 75 60 06 70 02
	divul.l	2(A5,D7.L),D6		; 4C 75 60 06 78 02
	divul.l	(0x1234).W,D7		; 4C 78 70 07 12 34
	divul.l	(0x1234).L,D7		; 4C 79 70 07 00 00 12
	divul.l	*0xFFFFFFF0,D0		; 4C 78 00 00 FF F0
	divul.l	 0x00010004,D1		; 4C 79 10 01 00 01 00
	divul.l	#7,D2			; 4C 7C 20 02 00 00 00
	divul.l	5(PC),D3		; 4C 7A 30 03 00 01
	divul.l	6(PC,A7.W),D4		; 4C 7B 40 04 F0 02
	divul.l	6(PC,A7.L),D4		; 4C 7B 40 04 F8 02
	divul.l	(A1),D2:D3		; 4C 51 30 02
	divul.l	(0x1234,A0,D1),D0	; 4C 70 00 00 11 20 12
	divul.l	([2,A1,A2],4),D1	; 4C 71 10 01 A1 22 00
	divul.l	([6,A2],D3,8),D2	; 4C 72 20 02 31 26 00
	divul.l	(0x1234,PC,D1),D3	; 4C 7B 30 03 11 20 12
	divul.l	([2,PC,A2],4),D4	; 4C 7B 40 04 A1 22 FF
	divul.l	([6,PC],D3,8),D5	; 4C 7B 50 05 31 26 00

	muls	D0,D1			; C3 C0
	muls	(A1),D2			; C5 D1
	muls	(A2)+,D3		; C7 DA
	muls	-(A3),D4		; C9 E3
	muls	1(A4),D5		; CB EC 00 01
	muls	2(A5,D7.W),D6		; CD F5 70 02
	muls	2(A5,D7.L),D6		; CD F5 78 02
	muls	(0x1234).W,D7		; CF F8 12 34
	muls	(0x1234).L,D7		; CF F9 00 00 12 34
	muls	*0xFFFFFFF0,D0		; C1 F8 FF F0
	muls	 0x00010004,D1		; C3 F9 00 01 00 04
	muls	#7,D2			; C5 FC 00 07
	muls	5(PC),D3		; C7 FA 00 03
	muls	6(PC,A7.W),D4		; C9 FB F0 04
	muls	6(PC,A7.L),D4		; C9 FB F8 04
	muls	(0x1234,A0,D1),D0	; C1 F0 11 20 12 34
	muls	([2,A1,A2],4),D1	; C3 F1 A1 22 00 02 00
	muls	([6,A2],D3,8),D2	; C5 F2 31 26 00 06 00
	muls	(0x1234,PC,D1),D3	; C7 FB 11 20 12 32
	muls	([2,PC,A2],4),D4	; C9 FB A1 22 00 00 00
	muls	([6,PC],D3,8),D5	; CB FB 31 26 00 04 00

	muls.w	D0,D1			; C3 C0
	muls.w	(A1),D2			; C5 D1
	muls.w	(A2)+,D3		; C7 DA
	muls.w	-(A3),D4		; C9 E3
	muls.w	1(A4),D5		; CB EC 00 01
	muls.w	2(A5,D7.W),D6		; CD F5 70 02
	muls.w	2(A5,D7.L),D6		; CD F5 78 02
	muls.w	(0x1234).W,D7		; CF F8 12 34
	muls.w	(0x1234).L,D7		; CF F9 00 00 12 34
	muls.w	*0xFFFFFFF0,D0		; C1 F8 FF F0
	muls.w	 0x00010004,D1		; C3 F9 00 01 00 04
	muls.w	#7,D2			; C5 FC 00 07
	muls.w	5(PC),D3		; C7 FA 00 03
	muls.w	6(PC,A7.W),D4		; C9 FB F0 04
	muls.w	6(PC,A7.L),D4		; C9 FB F8 04
	muls.w	(0x1234,A0,D1),D0	; C1 F0 11 20 12 34
	muls.w	([2,A1,A2],4),D1	; C3 F1 A1 22 00 02 00
	muls.w	([6,A2],D3,8),D2	; C5 F2 31 26 00 06 00
	muls.w	(0x1234,PC,D1),D3	; C7 FB 11 20 12 32
	muls.w	([2,PC,A2],4),D4	; C9 FB A1 22 00 00 00
	muls.w	([6,PC],D3,8),D5	; CB FB 31 26 00 04 00

	muls.l	D0,D1			; 4C 00 18 01
	muls.l	(A1),D2			; 4C 11 28 02
	muls.l	(A2)+,D3		; 4C 1A 38 03
	muls.l	-(A3),D4		; 4C 23 48 04
	muls.l	1(A4),D5		; 4C 2C 58 05 00 01
	muls.l	2(A5,D7.W),D6		; 4C 35 68 06 70 02
	muls.l	2(A5,D7.L),D6		; 4C 35 68 06 78 02
	muls.l	(0x1234).W,D7		; 4C 38 78 07 12 34
	muls.l	(0x1234).L,D7		; 4C 39 78 07 00 00 12
	muls.l	*0xFFFFFFF0,D0		; 4C 38 08 00 FF F0
	muls.l	 0x00010004,D1		; 4C 39 18 01 00 01 00
	muls.l	#7,D2			; 4C 3C 28 02 00 00 00
	muls.l	5(PC),D3		; 4C 3A 38 03 00 01
	muls.l	6(PC,A7.W),D4		; 4C 3B 48 04 F0 02
	muls.l	6(PC,A7.L),D4		; 4C 3B 48 04 F8 02
	muls.l	(0x1234,A0,D1),D0	; 4C 30 08 00 11 20 12
	muls.l	([2,A1,A2],4),D1	; 4C 31 18 01 A1 22 00
	muls.l	([6,A2],D3,8),D2	; 4C 32 28 02 31 26 00
	muls.l	(0x1234,PC,D1),D3	; 4C 3B 38 03 11 20 12
	muls.l	([2,PC,A2],4),D4	; 4C 3B 48 04 A1 22 FF
	muls.l	([6,PC],D3,8),D5	; 4C 3B 58 05 31 26 00

	mulu	D0,D1			; C2 C0
	mulu	(A1),D2			; C4 D1
	mulu	(A2)+,D3		; C6 DA
	mulu	-(A3),D4		; C8 E3
	mulu	1(A4),D5		; CA EC 00 01
	mulu	2(A5,D7.W),D6		; CC F5 70 02
	mulu	2(A5,D7.L),D6		; CC F5 78 02
	mulu	(0x1234).W,D7		; CE F8 12 34
	mulu	(0x1234).L,D7		; CE F9 00 00 12 34
	mulu	*0xFFFFFFF0,D0		; C0 F8 FF F0
	mulu	 0x00010004,D1		; C2 F9 00 01 00 04
	mulu	#7,D2			; C4 FC 00 07
	mulu	5(PC),D3		; C6 FA 00 03
	mulu	6(PC,A7.W),D4		; C8 FB F0 04
	mulu	6(PC,A7.L),D4		; C8 FB F8 04
	mulu	(0x1234,A0,D1),D0	; C0 F0 11 20 12 34
	mulu	([2,A1,A2],4),D1	; C2 F1 A1 22 00 02 00
	mulu	([6,A2],D3,8),D2	; C4 F2 31 26 00 06 00
	mulu	(0x1234,PC,D1),D3	; C6 FB 11 20 12 32
	mulu	([2,PC,A2],4),D4	; C8 FB A1 22 00 00 00
	mulu	([6,PC],D3,8),D5	; CA FB 31 26 00 04 00

	mulu.w	D0,D1			; C2 C0
	mulu.w	(A1),D2			; C4 D1
	mulu.w	(A2)+,D3		; C6 DA
	mulu.w	-(A3),D4		; C8 E3
	mulu.w	1(A4),D5		; CA EC 00 01
	mulu.w	2(A5,D7.W),D6		; CC F5 70 02
	mulu.w	2(A5,D7.L),D6		; CC F5 78 02
	mulu.w	(0x1234).W,D7		; CE F8 12 34
	mulu.w	(0x1234).L,D7		; CE F9 00 00 12 34
	mulu.w	*0xFFFFFFF0,D0		; C0 F8 FF F0
	mulu.w	 0x00010004,D1		; C2 F9 00 01 00 04
	mulu.w	#7,D2			; C4 FC 00 07
	mulu.w	5(PC),D3		; C6 FA 00 03
	mulu.w	6(PC,A7.W),D4		; C8 FB F0 04
	mulu.w	6(PC,A7.L),D4		; C8 FB F8 04
	mulu.w	(0x1234,A0,D1),D0	; C0 F0 11 20 12 34
	mulu.w	([2,A1,A2],4),D1	; C2 F1 A1 22 00 02 00
	mulu.w	([6,A2],D3,8),D2	; C4 F2 31 26 00 06 00
	mulu.w	(0x1234,PC,D1),D3	; C6 FB 11 20 12 32
	mulu.w	([2,PC,A2],4),D4	; C8 FB A1 22 00 00 00
	mulu.w	([6,PC],D3,8),D5	; CA FB 31 26 00 04 00

	mulu.l	D0,D1			; 4C 00 10 01
	mulu.l	(A1),D2			; 4C 11 20 02
	mulu.l	(A2)+,D3		; 4C 1A 30 03
	mulu.l	-(A3),D4		; 4C 23 40 04
	mulu.l	1(A4),D5		; 4C 2C 50 05 00 01
	mulu.l	2(A5,D7.W),D6		; 4C 35 60 06 70 02
	mulu.l	2(A5,D7.L),D6		; 4C 35 60 06 78 02
	mulu.l	(0x1234).W,D7		; 4C 38 70 07 12 34
	mulu.l	(0x1234).L,D7		; 4C 39 70 07 00 00 12
	mulu.l	*0xFFFFFFF0,D0		; 4C 38 00 00 FF F0
	mulu.l	 0x00010004,D1		; 4C 39 10 01 00 01 00
	mulu.l	#7,D2			; 4C 3C 20 02 00 00 00
	mulu.l	5(PC),D3		; 4C 3A 30 03 00 01
	mulu.l	6(PC,A7.W),D4		; 4C 3B 40 04 F0 02
	mulu.l	6(PC,A7.L),D4		; 4C 3B 40 04 F8 02
	mulu.l	(0x1234,A0,D1),D0	; 4C 30 00 00 11 20 12
	mulu.l	([2,A1,A2],4),D1	; 4C 31 10 01 A1 22 00
	mulu.l	([6,A2],D3,8),D2	; 4C 32 20 02 31 26 00
	mulu.l	(0x1234,PC,D1),D3	; 4C 3B 30 03 11 20 12
	mulu.l	([2,PC,A2],4),D4	; 4C 3B 40 04 A1 22 FF
	mulu.l	([6,PC],D3,8),D5	; 4C 3B 50 05 31 26 00

	.sbttl	Type S_TYP7 Instructions: CLR, NEG, NEGX, NOT, TST

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_TYP7:						*
	;*	CLR, NEG, NEGX, NOT, TST			*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	clr	D7			; 42 47
	clr	(A1)			; 42 51
	clr	(A2)+			; 42 5A
	clr	-(A3)			; 42 63
	clr	1(A4)			; 42 6C 00 01
	clr	2(A5,D7.W)		; 42 75 70 02
	clr	2(A5,D7.L)		; 42 75 78 02
	clr	(0x1234).W		; 42 78 12 34
	clr	(0x1234).L		; 42 79 00 00 12 34
	clr	*0xFFFFFFF0		; 42 78 FF F0
	clr	 0x00010004		; 42 79 00 01 00 04
	clr	(0x1234,A0,D1)		; 42 70 11 20 12 34
	clr	([2,A1,A2],4)		; 42 71 A1 22 00 02 00
	clr	([6,A2],D3,8)		; 42 72 31 26 00 06 00

	clr.b	D7			; 42 07
	clr.b	(A1)			; 42 11
	clr.b	(A2)+			; 42 1A
	clr.b	-(A3)			; 42 23
	clr.b	1(A4)			; 42 2C 00 01
	clr.b	2(A5,D7.W)		; 42 35 70 02
	clr.b	2(A5,D7.L)		; 42 35 78 02
	clr.b	(0x1234).W		; 42 38 12 34
	clr.b	(0x1234).L		; 42 39 00 00 12 34
	clr.b	*0xFFFFFFF0		; 42 38 FF F0
	clr.b	 0x00010004		; 42 39 00 01 00 04
	clr.b	(0x1234,A0,D1)		; 42 30 11 20 12 34
	clr.b	([2,A1,A2],4)		; 42 31 A1 22 00 02 00
	clr.b	([6,A2],D3,8)		; 42 32 31 26 00 06 00

	clr.w	D7			; 42 47
	clr.w	(A1)			; 42 51
	clr.w	(A2)+			; 42 5A
	clr.w	-(A3)			; 42 63
	clr.w	1(A4)			; 42 6C 00 01
	clr.w	2(A5,D7.W)		; 42 75 70 02
	clr.w	2(A5,D7.L)		; 42 75 78 02
	clr.w	(0x1234).W		; 42 78 12 34
	clr.w	(0x1234).L		; 42 79 00 00 12 34
	clr.w	*0xFFFFFFF0		; 42 78 FF F0
	clr.w	 0x00010004		; 42 79 00 01 00 04
	clr.w	(0x1234,A0,D1)		; 42 70 11 20 12 34
	clr.w	([2,A1,A2],4)		; 42 71 A1 22 00 02 00
	clr.w	([6,A2],D3,8)		; 42 72 31 26 00 06 00

	clr.l	D7			; 42 87
	clr.l	(A1)			; 42 91
	clr.l	(A2)+			; 42 9A
	clr.l	-(A3)			; 42 A3
	clr.l	1(A4)			; 42 AC 00 01
	clr.l	2(A5,D7.W)		; 42 B5 70 02
	clr.l	2(A5,D7.L)		; 42 B5 78 02
	clr.l	(0x1234).W		; 42 B8 12 34
	clr.l	(0x1234).L		; 42 B9 00 00 12 34
	clr.l	*0xFFFFFFF0		; 42 B8 FF F0
	clr.l	 0x00010004		; 42 B9 00 01 00 04
	clr.l	(0x1234,A0,D1)		; 42 B0 11 20 12 34
	clr.l	([2,A1,A2],4)		; 42 B1 A1 22 00 02 00
	clr.l	([6,A2],D3,8)		; 42 B2 31 26 00 06 00

	neg	D7			; 44 47
	neg	(A1)			; 44 51
	neg	(A2)+			; 44 5A
	neg	-(A3)			; 44 63
	neg	1(A4)			; 44 6C 00 01
	neg	2(A5,D7.W)		; 44 75 70 02
	neg	2(A5,D7.L)		; 44 75 78 02
	neg	(0x1234).W		; 44 78 12 34
	neg	(0x1234).L		; 44 79 00 00 12 34
	neg	*0xFFFFFFF0		; 44 78 FF F0
	neg	 0x00010004		; 44 79 00 01 00 04
	neg	(0x1234,A0,D1)		; 44 70 11 20 12 34
	neg	([2,A1,A2],4)		; 44 71 A1 22 00 02 00
	neg	([6,A2],D3,8)		; 44 72 31 26 00 06 00

	neg.b	D7			; 44 07
	neg.b	(A1)			; 44 11
	neg.b	(A2)+			; 44 1A
	neg.b	-(A3)			; 44 23
	neg.b	1(A4)			; 44 2C 00 01
	neg.b	2(A5,D7.W)		; 44 35 70 02
	neg.b	2(A5,D7.L)		; 44 35 78 02
	neg.b	(0x1234).W		; 44 38 12 34
	neg.b	(0x1234).L		; 44 39 00 00 12 34
	neg.b	*0xFFFFFFF0		; 44 38 FF F0
	neg.b	 0x00010004		; 44 39 00 01 00 04
	neg.b	(0x1234,A0,D1)		; 44 30 11 20 12 34
	neg.b	([2,A1,A2],4)		; 44 31 A1 22 00 02 00
	neg.b	([6,A2],D3,8)		; 44 32 31 26 00 06 00

	neg.w	D7			; 44 47
	neg.w	(A1)			; 44 51
	neg.w	(A2)+			; 44 5A
	neg.w	-(A3)			; 44 63
	neg.w	1(A4)			; 44 6C 00 01
	neg.w	2(A5,D7.W)		; 44 75 70 02
	neg.w	2(A5,D7.L)		; 44 75 78 02
	neg.w	(0x1234).W		; 44 78 12 34
	neg.w	(0x1234).L		; 44 79 00 00 12 34
	neg.w	*0xFFFFFFF0		; 44 78 FF F0
	neg.w	 0x00010004		; 44 79 00 01 00 04
	neg.w	(0x1234,A0,D1)		; 44 70 11 20 12 34
	neg.w	([2,A1,A2],4)		; 44 71 A1 22 00 02 00
	neg.w	([6,A2],D3,8)		; 44 72 31 26 00 06 00

	neg.l	D7			; 44 87
	neg.l	(A1)			; 44 91
	neg.l	(A2)+			; 44 9A
	neg.l	-(A3)			; 44 A3
	neg.l	1(A4)			; 44 AC 00 01
	neg.l	2(A5,D7.W)		; 44 B5 70 02
	neg.l	2(A5,D7.L)		; 44 B5 78 02
	neg.l	(0x1234).W		; 44 B8 12 34
	neg.l	(0x1234).L		; 44 B9 00 00 12 34
	neg.l	*0xFFFFFFF0		; 44 B8 FF F0
	neg.l	 0x00010004		; 44 B9 00 01 00 04
	neg.l	(0x1234,A0,D1)		; 44 B0 11 20 12 34
	neg.l	([2,A1,A2],4)		; 44 B1 A1 22 00 02 00
	neg.l	([6,A2],D3,8)		; 44 B2 31 26 00 06 00

	negx	D7			; 40 47
	negx	(A1)			; 40 51
	negx	(A2)+			; 40 5A
	negx	-(A3)			; 40 63
	negx	1(A4)			; 40 6C 00 01
	negx	2(A5,D7.W)		; 40 75 70 02
	negx	2(A5,D7.L)		; 40 75 78 02
	negx	(0x1234).W		; 40 78 12 34
	negx	(0x1234).L		; 40 79 00 00 12 34
	negx	*0xFFFFFFF0		; 40 78 FF F0
	negx	 0x00010004		; 40 79 00 01 00 04
	negx	(0x1234,A0,D1)		; 40 70 11 20 12 34
	negx	([2,A1,A2],4)		; 40 71 A1 22 00 02 00
	negx	([6,A2],D3,8)		; 40 72 31 26 00 06 00

	negx.b	D7			; 40 07
	negx.b	(A1)			; 40 11
	negx.b	(A2)+			; 40 1A
	negx.b	-(A3)			; 40 23
	negx.b	1(A4)			; 40 2C 00 01
	negx.b	2(A5,D7.W)		; 40 35 70 02
	negx.b	2(A5,D7.L)		; 40 35 78 02
	negx.b	(0x1234).W		; 40 38 12 34
	negx.b	(0x1234).L		; 40 39 00 00 12 34
	negx.b	*0xFFFFFFF0		; 40 38 FF F0
	negx.b	 0x00010004		; 40 39 00 01 00 04
	negx.b	(0x1234,A0,D1)		; 40 30 11 20 12 34
	negx.b	([2,A1,A2],4)		; 40 31 A1 22 00 02 00
	negx.b	([6,A2],D3,8)		; 40 32 31 26 00 06 00

	negx.w	D7			; 40 47
	negx.w	(A1)			; 40 51
	negx.w	(A2)+			; 40 5A
	negx.w	-(A3)			; 40 63
	negx.w	1(A4)			; 40 6C 00 01
	negx.w	2(A5,D7.W)		; 40 75 70 02
	negx.w	2(A5,D7.L)		; 40 75 78 02
	negx.w	(0x1234).W		; 40 78 12 34
	negx.w	(0x1234).L		; 40 79 00 00 12 34
	negx.w	*0xFFFFFFF0		; 40 78 FF F0
	negx.w	 0x00010004		; 40 79 00 01 00 04
	negx.w	(0x1234,A0,D1)		; 40 70 11 20 12 34
	negx.w	([2,A1,A2],4)		; 40 71 A1 22 00 02 00
	negx.w	([6,A2],D3,8)		; 40 72 31 26 00 06 00

	negx.l	D7			; 40 87
	negx.l	(A1)			; 40 91
	negx.l	(A2)+			; 40 9A
	negx.l	-(A3)			; 40 A3
	negx.l	1(A4)			; 40 AC 00 01
	negx.l	2(A5,D7.W)		; 40 B5 70 02
	negx.l	2(A5,D7.L)		; 40 B5 78 02
	negx.l	(0x1234).W		; 40 B8 12 34
	negx.l	(0x1234).L		; 40 B9 00 00 12 34
	negx.l	*0xFFFFFFF0		; 40 B8 FF F0
	negx.l	 0x00010004		; 40 B9 00 01 00 04
	negx.l	(0x1234,A0,D1)		; 40 B0 11 20 12 34
	negx.l	([2,A1,A2],4)		; 40 B1 A1 22 00 02 00
	negx.l	([6,A2],D3,8)		; 40 B2 31 26 00 06 00

	not	D7			; 46 47
	not	(A1)			; 46 51
	not	(A2)+			; 46 5A
	not	-(A3)			; 46 63
	not	1(A4)			; 46 6C 00 01
	not	2(A5,D7.W)		; 46 75 70 02
	not	2(A5,D7.L)		; 46 75 78 02
	not	(0x1234).W		; 46 78 12 34
	not	(0x1234).L		; 46 79 00 00 12 34
	not	*0xFFFFFFF0		; 46 78 FF F0
	not	 0x00010004		; 46 79 00 01 00 04
	not	(0x1234,A0,D1)		; 46 70 11 20 12 34
	not	([2,A1,A2],4)		; 46 71 A1 22 00 02 00
	not	([6,A2],D3,8)		; 46 72 31 26 00 06 00

	not.b	D7			; 46 07
	not.b	(A1)			; 46 11
	not.b	(A2)+			; 46 1A
	not.b	-(A3)			; 46 23
	not.b	1(A4)			; 46 2C 00 01
	not.b	2(A5,D7.W)		; 46 35 70 02
	not.b	2(A5,D7.L)		; 46 35 78 02
	not.b	(0x1234).W		; 46 38 12 34
	not.b	(0x1234).L		; 46 39 00 00 12 34
	not.b	*0xFFFFFFF0		; 46 38 FF F0
	not.b	 0x00010004		; 46 39 00 01 00 04
	not.b	(0x1234,A0,D1)		; 46 30 11 20 12 34
	not.b	([2,A1,A2],4)		; 46 31 A1 22 00 02 00
	not.b	([6,A2],D3,8)		; 46 32 31 26 00 06 00

	not.w	D7			; 46 47
	not.w	(A1)			; 46 51
	not.w	(A2)+			; 46 5A
	not.w	-(A3)			; 46 63
	not.w	1(A4)			; 46 6C 00 01
	not.w	2(A5,D7.W)		; 46 75 70 02
	not.w	2(A5,D7.L)		; 46 75 78 02
	not.w	(0x1234).W		; 46 78 12 34
	not.w	(0x1234).L		; 46 79 00 00 12 34
	not.w	*0xFFFFFFF0		; 46 78 FF F0
	not.w	 0x00010004		; 46 79 00 01 00 04
	not.w	(0x1234,A0,D1)		; 46 70 11 20 12 34
	not.w	([2,A1,A2],4)		; 46 71 A1 22 00 02 00
	not.w	([6,A2],D3,8)		; 46 72 31 26 00 06 00

	not.l	D7			; 46 87
	not.l	(A1)			; 46 91
	not.l	(A2)+			; 46 9A
	not.l	-(A3)			; 46 A3
	not.l	1(A4)			; 46 AC 00 01
	not.l	2(A5,D7.W)		; 46 B5 70 02
	not.l	2(A5,D7.L)		; 46 B5 78 02
	not.l	(0x1234).W		; 46 B8 12 34
	not.l	(0x1234).L		; 46 B9 00 00 12 34
	not.l	*0xFFFFFFF0		; 46 B8 FF F0
	not.l	 0x00010004		; 46 B9 00 01 00 04
	not.l	(0x1234,A0,D1)		; 46 B0 11 20 12 34
	not.l	([2,A1,A2],4)		; 46 B1 A1 22 00 02 00
	not.l	([6,A2],D3,8)		; 46 B2 31 26 00 06 00

	tst	D7			; 4A 47
	tst	(A1)			; 4A 51
	tst	(A2)+			; 4A 5A
	tst	-(A3)			; 4A 63
	tst	1(A4)			; 4A 6C 00 01
	tst	2(A5,D7.W)		; 4A 75 70 02
	tst	2(A5,D7.L)		; 4A 75 78 02
	tst	(0x1234).W		; 4A 78 12 34
	tst	(0x1234).L		; 4A 79 00 00 12 34
	tst	*0xFFFFFFF0		; 4A 78 FF F0
	tst	 0x00010004		; 4A 79 00 01 00 04
	tst	(0x1234,A0,D1)		; 4A 70 11 20 12 34
	tst	([2,A1,A2],4)		; 4A 71 A1 22 00 02 00
	tst	([6,A2],D3,8)		; 4A 72 31 26 00 06 00
	tst	5(PC)			; 4A 7A 00 03
	tst	6(PC,A7.W)		; 4A 7B F0 04
	tst	6(PC,A7.L)		; 4A 7B F8 04
	tst	(0x1234,PC,D1)		; 4A 7B 11 20 12 32
	tst	([2,PC,A2],4)		; 4A 7B A1 22 00 00 00
	tst	([6,PC],D3,8)		; 4A 7B 31 26 00 04 00

	tst.b	D7			; 4A 07
	tst.b	(A1)			; 4A 11
	tst.b	(A2)+			; 4A 1A
	tst.b	-(A3)			; 4A 23
	tst.b	1(A4)			; 4A 2C 00 01
	tst.b	2(A5,D7.W)		; 4A 35 70 02
	tst.b	2(A5,D7.L)		; 4A 35 78 02
	tst.b	(0x1234).W		; 4A 38 12 34
	tst.b	(0x1234).L		; 4A 39 00 00 12 34
	tst.b	*0xFFFFFFF0		; 4A 38 FF F0
	tst.b	 0x00010004		; 4A 39 00 01 00 04
	tst.b	(0x1234,A0,D1)		; 4A 30 11 20 12 34
	tst.b	([2,A1,A2],4)		; 4A 31 A1 22 00 02 00
	tst.b	([6,A2],D3,8)		; 4A 32 31 26 00 06 00
	tst.b	5(PC)			; 4A 3A 00 03
	tst.b	6(PC,A7.W)		; 4A 3B F0 04
	tst.b	6(PC,A7.L)		; 4A 3B F8 04
	tst.b	(0x1234,PC,D1)		; 4A 3B 11 20 12 32
	tst.b	([2,PC,A2],4)		; 4A 3B A1 22 00 00 00
	tst.b	([6,PC],D3,8)		; 4A 3B 31 26 00 04 00

	tst.w	D7			; 4A 47
	tst.w	(A1)			; 4A 51
	tst.w	(A2)+			; 4A 5A
	tst.w	-(A3)			; 4A 63
	tst.w	1(A4)			; 4A 6C 00 01
	tst.w	2(A5,D7.W)		; 4A 75 70 02
	tst.w	2(A5,D7.L)		; 4A 75 78 02
	tst.w	(0x1234).W		; 4A 78 12 34
	tst.w	(0x1234).L		; 4A 79 00 00 12 34
	tst.w	*0xFFFFFFF0		; 4A 78 FF F0
	tst.w	 0x00010004		; 4A 79 00 01 00 04
	tst.w	(0x1234,A0,D1)		; 4A 70 11 20 12 34
	tst.w	([2,A1,A2],4)		; 4A 71 A1 22 00 02 00
	tst.w	([6,A2],D3,8)		; 4A 72 31 26 00 06 00
	tst.w	5(PC)			; 4A 7A 00 03
	tst.w	6(PC,A7.W)		; 4A 7B F0 04
	tst.w	6(PC,A7.L)		; 4A 7B F8 04
	tst.w	(0x1234,PC,D1)		; 4A 7B 11 20 12 32
	tst.w	([2,PC,A2],4)		; 4A 7B A1 22 00 00 00
	tst.w	([6,PC],D3,8)		; 4A 7B 31 26 00 04 00

	tst.l	D7			; 4A 87
	tst.l	(A1)			; 4A 91
	tst.l	(A2)+			; 4A 9A
	tst.l	-(A3)			; 4A A3
	tst.l	1(A4)			; 4A AC 00 01
	tst.l	2(A5,D7.W)		; 4A B5 70 02
	tst.l	2(A5,D7.L)		; 4A B5 78 02
	tst.l	(0x1234).W		; 4A B8 12 34
	tst.l	(0x1234).L		; 4A B9 00 00 12 34
	tst.l	*0xFFFFFFF0		; 4A B8 FF F0
	tst.l	 0x00010004		; 4A B9 00 01 00 04
	tst.l	(0x1234,A0,D1)		; 4A B0 11 20 12 34
	tst.l	([2,A1,A2],4)		; 4A B1 A1 22 00 02 00
	tst.l	([6,A2],D3,8)		; 4A B2 31 26 00 06 00
	tst.l	5(PC)			; 4A BA 00 03
	tst.l	6(PC,A7.W)		; 4A BB F0 04
	tst.l	6(PC,A7.L)		; 4A BB F8 04
	tst.l	(0x1234,PC,D1)		; 4A BB 11 20 12 32
	tst.l	([2,PC,A2],4)		; 4A BB A1 22 00 00 00
	tst.l	([6,PC],D3,8)		; 4A BB 31 26 00 04 00

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
	jmp	(0x1234).W		; 4E F8 12 34
	jmp	(0x1234).L		; 4E F9 00 00 12 34
	jmp	*0xFFFFFFF0		; 4E F8 FF F0
	jmp	 0x00010004		; 4E F9 00 01 00 04
	jmp	5(PC)			; 4E FA 00 03
	jmp	6(PC,A7.W)		; 4E FB F0 04
	jmp	6(PC,A7.L)		; 4E FB F8 04
	jmp	(0x1234,A0,D1)		; 4E F0 11 20 12 34
	jmp	([2,A1,A2],4)		; 4E F1 A1 22 00 02 00
	jmp	([6,A2],D3,8)		; 4E F2 31 26 00 06 00
	jmp	(0x1234,PC,D1)		; 4E FB 11 20 12 32
	jmp	([2,PC,A2],4)		; 4E FB A1 22 00 00 00
	jmp	([6,PC],D3,8)		; 4E FB 31 26 00 04 00

	jmp.l	(A1)			; 4E D1
	jmp.l	1(A4)			; 4E EC 00 01
	jmp.l	2(A5,D7.W)		; 4E F5 70 02
	jmp.l	2(A5,D7.L)		; 4E F5 78 02
	jmp.l	(0x1234).W		; 4E F8 12 34
	jmp.l	(0x1234).L		; 4E F9 00 00 12 34
	jmp.l	*0xFFFFFFF0		; 4E F8 FF F0
	jmp.l	 0x00010004		; 4E F9 00 01 00 04
	jmp.l	5(PC)			; 4E FA 00 03
	jmp.l	6(PC,A7.W)		; 4E FB F0 04
	jmp.l	6(PC,A7.L)		; 4E FB F8 04
	jmp.l	(0x1234,A0,D1)		; 4E F0 11 20 12 34
	jmp.l	([2,A1,A2],4)		; 4E F1 A1 22 00 02 00
	jmp.l	([6,A2],D3,8)		; 4E F2 31 26 00 06 00
	jmp.l	(0x1234,PC,D1)		; 4E FB 11 20 12 32
	jmp.l	([2,PC,A2],4)		; 4E FB A1 22 00 00 00
	jmp.l	([6,PC],D3,8)		; 4E FB 31 26 00 04 00

	jsr	(A1)			; 4E 91
	jsr	1(A4)			; 4E AC 00 01
	jsr	2(A5,D7.W)		; 4E B5 70 02
	jsr	2(A5,D7.L)		; 4E B5 78 02
	jsr	(0x1234).W		; 4E B8 12 34
	jsr	(0x1234).L		; 4E B9 00 00 12 34
	jsr	*0xFFFFFFF0		; 4E B8 FF F0
	jsr	 0x00010004		; 4E B9 00 01 00 04
	jsr	5(PC)			; 4E BA 00 03
	jsr	6(PC,A7.W)		; 4E BB F0 04
	jsr	6(PC,A7.L)		; 4E BB F8 04
	jsr	(0x1234,A0,D1)		; 4E B0 11 20 12 34
	jsr	([2,A1,A2],4)		; 4E B1 A1 22 00 02 00
	jsr	([6,A2],D3,8)		; 4E B2 31 26 00 06 00
	jsr	(0x1234,PC,D1)		; 4E BB 11 20 12 32
	jsr	([2,PC,A2],4)		; 4E BB A1 22 00 00 00
	jsr	([6,PC],D3,8)		; 4E BB 31 26 00 04 00

	jsr.l	(A1)			; 4E 91
	jsr.l	1(A4)			; 4E AC 00 01
	jsr.l	2(A5,D7.W)		; 4E B5 70 02
	jsr.l	2(A5,D7.L)		; 4E B5 78 02
	jsr.l	(0x1234).W		; 4E B8 12 34
	jsr.l	(0x1234).L		; 4E B9 00 00 12 34
	jsr.l	*0xFFFFFFF0		; 4E B8 FF F0
	jsr.l	 0x00010004		; 4E B9 00 01 00 04
	jsr.l	5(PC)			; 4E BA 00 03
	jsr.l	6(PC,A7.W)		; 4E BB F0 04
	jsr.l	6(PC,A7.L)		; 4E BB F8 04
	jsr.l	(0x1234,A0,D1)		; 4E B0 11 20 12 34
	jsr.l	([2,A1,A2],4)		; 4E B1 A1 22 00 02 00
	jsr.l	([6,A2],D3,8)		; 4E B2 31 26 00 06 00
	jsr.l	(0x1234,PC,D1)		; 4E BB 11 20 12 32
	jsr.l	([2,PC,A2],4)		; 4E BB A1 22 00 00 00
	jsr.l	([6,PC],D3,8)		; 4E BB 31 26 00 04 00

	pea	(A1)			; 48 51
	pea	1(A4)			; 48 6C 00 01
	pea	2(A5,D7.W)		; 48 75 70 02
	pea	2(A5,D7.L)		; 48 75 78 02
	pea	(0x1234).W		; 48 78 12 34
	pea	(0x1234).L		; 48 79 00 00 12 34
	pea	*0xFFFFFFF0		; 48 78 FF F0
	pea	 0x00010004		; 48 79 00 01 00 04
	pea	5(PC)			; 48 7A 00 03
	pea	6(PC,A7.W)		; 48 7B F0 04
	pea	6(PC,A7.L)		; 48 7B F8 04
	pea	(0x1234,A0,D1)		; 48 70 11 20 12 34
	pea	([2,A1,A2],4)		; 48 71 A1 22 00 02 00
	pea	([6,A2],D3,8)		; 48 72 31 26 00 06 00
	pea	(0x1234,PC,D1)		; 48 7B 11 20 12 32
	pea	([2,PC,A2],4)		; 48 7B A1 22 00 00 00
	pea	([6,PC],D3,8)		; 48 7B 31 26 00 04 00

	pea.l	(A1)			; 48 51
	pea.l	1(A4)			; 48 6C 00 01
	pea.l	2(A5,D7.W)		; 48 75 70 02
	pea.l	2(A5,D7.L)		; 48 75 78 02
	pea.l	(0x1234).W		; 48 78 12 34
	pea.l	(0x1234).L		; 48 79 00 00 12 34
	pea.l	*0xFFFFFFF0		; 48 78 FF F0
	pea.l	 0x00010004		; 48 79 00 01 00 04
	pea.l	5(PC)			; 48 7A 00 03
	pea.l	6(PC,A7.W)		; 48 7B F0 04
	pea.l	6(PC,A7.L)		; 48 7B F8 04
	pea.l	(0x1234,A0,D1)		; 48 70 11 20 12 34
	pea.l	([2,A1,A2],4)		; 48 71 A1 22 00 02 00
	pea.l	([6,A2],D3,8)		; 48 72 31 26 00 06 00
	pea.l	(0x1234,PC,D1)		; 48 7B 11 20 12 32
	pea.l	([2,PC,A2],4)		; 48 7B A1 22 00 00 00
	pea.l	([6,PC],D3,8)		; 48 7B 31 26 00 04 00

	lea	(A1),A2			; 45 D1
	lea	1(A4),A5		; 4B EC 00 01
	lea	2(A5,D7.W),A6		; 4D F5 70 02
	lea	2(A5,D7.L),A6		; 4D F5 78 02
	lea	(0x1234).W,A7		; 4F F8 12 34
	lea	(0x1234).L,A7		; 4F F9 00 00 12 34
	lea	*0xFFFFFFF0,A0		; 41 F8 FF F0
	lea	 0x00010004,A1		; 43 F9 00 01 00 04
	lea	5(PC),A3		; 47 FA 00 03
	lea	6(PC,A7.W),A4		; 49 FB F0 04
	lea	6(PC,A7.L),A4		; 49 FB F8 04
	lea	(0x1234,A0,D1),A0	; 41 F0 11 20 12 34
	lea	([2,A1,A2],4),A1	; 43 F1 A1 22 00 02 00
	lea	([6,A2],D3,8),A2	; 45 F2 31 26 00 06 00
	lea	(0x1234,PC,D1),A3	; 47 FB 11 20 12 32
	lea	([2,PC,A2],4),A4	; 49 FB A1 22 00 00 00
	lea	([6,PC],D3,8),A5	; 4B FB 31 26 00 04 00

	lea.l	(A1),A2			; 45 D1
	lea.l	1(A4),A5		; 4B EC 00 01
	lea.l	2(A5,D7.W),A6		; 4D F5 70 02
	lea.l	2(A5,D7.L),A6		; 4D F5 78 02
	lea.l	(0x1234).W,A7		; 4F F8 12 34
	lea.l	(0x1234).L,A7		; 4F F9 00 00 12 34
	lea.l	*0xFFFFFFF0,A0		; 41 F8 FF F0
	lea.l	 0x00010004,A1		; 43 F9 00 01 00 04
	lea.l	5(PC),A3		; 47 FA 00 03
	lea.l	6(PC,A7.W),A4		; 49 FB F0 04
	lea.l	6(PC,A7.L),A4		; 49 FB F8 04
	lea.l	(0x1234,A0,D1),A0	; 41 F0 11 20 12 34
	lea.l	([2,A1,A2],4),A1	; 43 F1 A1 22 00 02 00
	lea.l	([6,A2],D3,8),A2	; 45 F2 31 26 00 06 00
	lea.l	(0x1234,PC,D1),A3	; 47 FB 11 20 12 32
	lea.l	([2,PC,A2],4),A4	; 49 FB A1 22 00 00 00
	lea.l	([6,PC],D3,8),A5	; 4B FB 31 26 00 04 00

	.sbttl	Type S_TYP9 Instructions: NBCD, TAS

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_TYP9:						*
	;*	NBCD, TAS					*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	nbcd	D7			; 48 07
	nbcd	(A1)			; 48 11
	nbcd	(A2)+			; 48 1A
	nbcd	-(A3)			; 48 23
	nbcd	1(A4)			; 48 2C 00 01
	nbcd	2(A5,D7.W)		; 48 35 70 02
	nbcd	2(A5,D7.L)		; 48 35 78 02
	nbcd	(0x1234).W		; 48 38 12 34
	nbcd	(0x1234).L		; 48 39 00 00 12 34
	nbcd	*0xFFFFFFF0		; 48 38 FF F0
	nbcd	 0x00010004		; 48 39 00 01 00 04
	nbcd	(0x1234,A0,D1)		; 48 30 11 20 12 34
	nbcd	([2,A1,A2],4)		; 48 31 A1 22 00 02 00
	nbcd	([6,A2],D3,8)		; 48 32 31 26 00 06 00

	nbcd.b	D7			; 48 07
	nbcd.b	(A1)			; 48 11
	nbcd.b	(A2)+			; 48 1A
	nbcd.b	-(A3)			; 48 23
	nbcd.b	1(A4)			; 48 2C 00 01
	nbcd.b	2(A5,D7.W)		; 48 35 70 02
	nbcd.b	2(A5,D7.L)		; 48 35 78 02
	nbcd.b	(0x1234).W		; 48 38 12 34
	nbcd.b	(0x1234).L		; 48 39 00 00 12 34
	nbcd.b	*0xFFFFFFF0		; 48 38 FF F0
	nbcd.b	 0x00010004		; 48 39 00 01 00 04
	nbcd.b	(0x1234,A0,D1)		; 48 30 11 20 12 34
	nbcd.b	([2,A1,A2],4)		; 48 31 A1 22 00 02 00
	nbcd.b	([6,A2],D3,8)		; 48 32 31 26 00 06 00

	tas	D7			; 4A C7
	tas	(A1)			; 4A D1
	tas	(A2)+			; 4A DA
	tas	-(A3)			; 4A E3
	tas	1(A4)			; 4A EC 00 01
	tas	2(A5,D7.W)		; 4A F5 70 02
	tas	2(A5,D7.L)		; 4A F5 78 02
	tas	(0x1234).W		; 4A F8 12 34
	tas	(0x1234).L		; 4A F9 00 00 12 34
	tas	*0xFFFFFFF0		; 4A F8 FF F0
	tas	 0x00010004		; 4A F9 00 01 00 04
	tas	(0x1234,A0,D1)		; 4A F0 11 20 12 34
	tas	([2,A1,A2],4)		; 4A F1 A1 22 00 02 00
	tas	([6,A2],D3,8)		; 4A F2 31 26 00 06 00

	tas.b	D7			; 4A C7
	tas.b	(A1)			; 4A D1
	tas.b	(A2)+			; 4A DA
	tas.b	-(A3)			; 4A E3
	tas.b	1(A4)			; 4A EC 00 01
	tas.b	2(A5,D7.W)		; 4A F5 70 02
	tas.b	2(A5,D7.L)		; 4A F5 78 02
	tas.b	(0x1234).W		; 4A F8 12 34
	tas.b	(0x1234).L		; 4A F9 00 00 12 34
	tas.b	*0xFFFFFFF0		; 4A F8 FF F0
	tas.b	 0x00010004		; 4A F9 00 01 00 04
	tas.b	(0x1234,A0,D1)		; 4A F0 11 20 12 34
	tas.b	([2,A1,A2],4)		; 4A F1 A1 22 00 02 00
	tas.b	([6,A2],D3,8)		; 4A F2 31 26 00 06 00

	.sbttl	Type S_SHFT Instructions: ASL, ASR, LSL, LSR, ROL, ROR, ROXL, ROXL

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_SHFT:						*
	;*	ASL, ASR, LSL, LSR, ROL, ROR, ROXL, ROXL	*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	asl	D1,D2			; E3 62
	asl	#3,D3			; E7 43


	asl.b	D1,D2			; E3 22
	asl.b	#3,D3			; E7 03


	asl.w	D1,D2			; E3 62
	asl.w	#3,D3			; E7 43

	asl.w	(A1)			; E1 D1
	asl.w	(A2)+			; E1 DA
	asl.w	-(A3)			; E1 E3
	asl.w	1(A4)			; E1 EC 00 01
	asl.w	2(A5,D7.W)		; E1 F5 70 02
	asl.w	2(A5,D7.L)		; E1 F5 78 02
	asl.w	(0x1234).W		; E1 F8 12 34
	asl.w	(0x1234).L		; E1 F9 00 00 12 34
	asl.w	*0xFFFFFFF0		; E1 F8 FF F0
	asl.w	 0x00010004		; E1 F9 00 01 00 04
	asl.w	(0x1234,A0,D1)		; E1 F0 11 20 12 34
	asl.w	([2,A1,A2],4)		; E1 F1 A1 22 00 02 00
	asl.w	([6,A2],D3,8)		; E1 F2 31 26 00 06 00

	asl.l	D1,D2			; E3 A2
	asl.l	#3,D3			; E7 83


	asr	D1,D2			; E2 62
	asr	#3,D3			; E6 43


	asr.b	D1,D2			; E2 22
	asr.b	#3,D3			; E6 03


	asr.w	D1,D2			; E2 62
	asr.w	#3,D3			; E6 43

	asr.w	(A1)			; E0 D1
	asr.w	(A2)+			; E0 DA
	asr.w	-(A3)			; E0 E3
	asr.w	1(A4)			; E0 EC 00 01
	asr.w	2(A5,D7.W)		; E0 F5 70 02
	asr.w	2(A5,D7.L)		; E0 F5 78 02
	asr.w	(0x1234).W		; E0 F8 12 34
	asr.w	(0x1234).L		; E0 F9 00 00 12 34
	asr.w	*0xFFFFFFF0		; E0 F8 FF F0
	asr.w	 0x00010004		; E0 F9 00 01 00 04
	asr.w	(0x1234,A0,D1)		; E0 F0 11 20 12 34
	asr.w	([2,A1,A2],4)		; E0 F1 A1 22 00 02 00
	asr.w	([6,A2],D3,8)		; E0 F2 31 26 00 06 00

	asr.l	D1,D2			; E2 A2
	asr.l	#3,D3			; E6 83


	lsl	D1,D2			; E3 6A
	lsl	#3,D3			; E7 4B


	lsl.b	D1,D2			; E3 2A
	lsl.b	#3,D3			; E7 0B


	lsl.w	D1,D2			; E3 6A
	lsl.w	#3,D3			; E7 4B

	lsl.w	(A1)			; E3 D1
	lsl.w	(A2)+			; E3 DA
	lsl.w	-(A3)			; E3 E3
	lsl.w	1(A4)			; E3 EC 00 01
	lsl.w	2(A5,D7.W)		; E3 F5 70 02
	lsl.w	2(A5,D7.L)		; E3 F5 78 02
	lsl.w	(0x1234).W		; E3 F8 12 34
	lsl.w	(0x1234).L		; E3 F9 00 00 12 34
	lsl.w	*0xFFFFFFF0		; E3 F8 FF F0
	lsl.w	 0x00010004		; E3 F9 00 01 00 04
	lsl.w	(0x1234,A0,D1)		; E3 F0 11 20 12 34
	lsl.w	([2,A1,A2],4)		; E3 F1 A1 22 00 02 00
	lsl.w	([6,A2],D3,8)		; E3 F2 31 26 00 06 00

	lsl.l	D1,D2			; E3 AA
	lsl.l	#3,D3			; E7 8B


	lsr	D1,D2			; E2 6A
	lsr	#3,D3			; E6 4B


	lsr.b	D1,D2			; E2 2A
	lsr.b	#3,D3			; E6 0B


	lsr.w	D1,D2			; E2 6A
	lsr.w	#3,D3			; E6 4B

	lsr.w	(A1)			; E2 D1
	lsr.w	(A2)+			; E2 DA
	lsr.w	-(A3)			; E2 E3
	lsr.w	1(A4)			; E2 EC 00 01
	lsr.w	2(A5,D7.W)		; E2 F5 70 02
	lsr.w	2(A5,D7.L)		; E2 F5 78 02
	lsr.w	(0x1234).W		; E2 F8 12 34
	lsr.w	(0x1234).L		; E2 F9 00 00 12 34
	lsr.w	*0xFFFFFFF0		; E2 F8 FF F0
	lsr.w	 0x00010004		; E2 F9 00 01 00 04
	lsr.w	(0x1234,A0,D1)		; E2 F0 11 20 12 34
	lsr.w	([2,A1,A2],4)		; E2 F1 A1 22 00 02 00
	lsr.w	([6,A2],D3,8)		; E2 F2 31 26 00 06 00

	lsr.l	D1,D2			; E2 AA
	lsr.l	#3,D3			; E6 8B


	rol	D1,D2			; E3 7A
	rol	#3,D3			; E7 5B


	rol.b	D1,D2			; E3 3A
	rol.b	#3,D3			; E7 1B


	rol.w	D1,D2			; E3 7A
	rol.w	#3,D3			; E7 5B

	rol.w	(A1)			; E7 D1
	rol.w	(A2)+			; E7 DA
	rol.w	-(A3)			; E7 E3
	rol.w	1(A4)			; E7 EC 00 01
	rol.w	2(A5,D7.W)		; E7 F5 70 02
	rol.w	2(A5,D7.L)		; E7 F5 78 02
	rol.w	(0x1234).W		; E7 F8 12 34
	rol.w	(0x1234).L		; E7 F9 00 00 12 34
	rol.w	*0xFFFFFFF0		; E7 F8 FF F0
	rol.w	 0x00010004		; E7 F9 00 01 00 04
	rol.w	(0x1234,A0,D1)		; E7 F0 11 20 12 34
	rol.w	([2,A1,A2],4)		; E7 F1 A1 22 00 02 00
	rol.w	([6,A2],D3,8)		; E7 F2 31 26 00 06 00

	rol.l	D1,D2			; E3 BA
	rol.l	#3,D3			; E7 9B


	ror	D1,D2			; E2 7A
	ror	#3,D3			; E6 5B


	ror.b	D1,D2			; E2 3A
	ror.b	#3,D3			; E6 1B


	ror.w	D1,D2			; E2 7A
	ror.w	#3,D3			; E6 5B

	ror.w	(A1)			; E6 D1
	ror.w	(A2)+			; E6 DA
	ror.w	-(A3)			; E6 E3
	ror.w	1(A4)			; E6 EC 00 01
	ror.w	2(A5,D7.W)		; E6 F5 70 02
	ror.w	2(A5,D7.L)		; E6 F5 78 02
	ror.w	(0x1234).W		; E6 F8 12 34
	ror.w	(0x1234).L		; E6 F9 00 00 12 34
	ror.w	*0xFFFFFFF0		; E6 F8 FF F0
	ror.w	 0x00010004		; E6 F9 00 01 00 04
	ror.w	(0x1234,A0,D1)		; E6 F0 11 20 12 34
	ror.w	([2,A1,A2],4)		; E6 F1 A1 22 00 02 00
	ror.w	([6,A2],D3,8)		; E6 F2 31 26 00 06 00

	ror.l	D1,D2			; E2 BA
	ror.l	#3,D3			; E6 9B


	roxl	D1,D2			; E3 72
	roxl	#3,D3			; E7 53


	roxl.b	D1,D2			; E3 32
	roxl.b	#3,D3			; E7 13


	roxl.w	D1,D2			; E3 72
	roxl.w	#3,D3			; E7 53

	roxl.w	(A1)			; E5 D1
	roxl.w	(A2)+			; E5 DA
	roxl.w	-(A3)			; E5 E3
	roxl.w	1(A4)			; E5 EC 00 01
	roxl.w	2(A5,D7.W)		; E5 F5 70 02
	roxl.w	2(A5,D7.L)		; E5 F5 78 02
	roxl.w	(0x1234).W		; E5 F8 12 34
	roxl.w	(0x1234).L		; E5 F9 00 00 12 34
	roxl.w	*0xFFFFFFF0		; E5 F8 FF F0
	roxl.w	 0x00010004		; E5 F9 00 01 00 04
	roxl.w	(0x1234,A0,D1)		; E5 F0 11 20 12 34
	roxl.w	([2,A1,A2],4)		; E5 F1 A1 22 00 02 00
	roxl.w	([6,A2],D3,8)		; E5 F2 31 26 00 06 00

	roxl.l	D1,D2			; E3 B2
	roxl.l	#3,D3			; E7 93


	roxr	D1,D2			; E2 72
	roxr	#3,D3			; E6 53


	roxr.b	D1,D2			; E2 32
	roxr.b	#3,D3			; E6 13


	roxr.w	D1,D2			; E2 72
	roxr.w	#3,D3			; E6 53

	roxr.w	(A1)			; E4 D1
	roxr.w	(A2)+			; E4 DA
	roxr.w	-(A3)			; E4 E3
	roxr.w	1(A4)			; E4 EC 00 01
	roxr.w	2(A5,D7.W)		; E4 F5 70 02
	roxr.w	2(A5,D7.L)		; E4 F5 78 02
	roxr.w	(0x1234).W		; E4 F8 12 34
	roxr.w	(0x1234).L		; E4 F9 00 00 12 34
	roxr.w	*0xFFFFFFF0		; E4 F8 FF F0
	roxr.w	 0x00010004		; E4 F9 00 01 00 04
	roxr.w	(0x1234,A0,D1)		; E4 F0 11 20 12 34
	roxr.w	([2,A1,A2],4)		; E4 F1 A1 22 00 02 00
	roxr.w	([6,A2],D3,8)		; E4 F2 31 26 00 06 00

	roxr.l	D1,D2			; E2 B2
	roxr.l	#3,D3			; E6 93


	.sbttl	Type S_BCC Instructions: BRA, BSR, Plus Conditional Branches

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_BCC:						*
	;*	BRA, BSR, BHI, BLS, BCC, BCS, BNE, BEQ		*
	;*	BVC, BVS, BPL, BMI, BGE, BLT, BGT, BLE		*
	;*	BHS, BLO, BHIS, BLOS				*
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

	.sbttl	Type S_DBCC Instructions: DBT, DBF, Plus Conditional Branches

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_DBCC:						*
	;*	DBT,  DBF,  DBHI, DBLS, DBCC, DBCS, DBNE, DBEQ	*
	;*	DBVC, DBVS, DBPL, DBMI, DBGE, DBLT, DBGT, DBLE	*
	;*	Alternates - DBRA, DBHS, DBLO, DBHIS, DBLOS	*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	dbt	D0,.			; 50 C8 FF FE
	dbt	D1,. + 4		; 50 C9 00 02
	dbt	D2,. + 0x1004		; 50 CA 10 02

	dbt.w	D0,.			; 50 C8 FF FE
	dbt.w	D1,. + 4		; 50 C9 00 02
	dbt.w	D2,. + 0x1004		; 50 CA 10 02

	dbf	D0,.			; 51 C8 FF FE
	dbf	D1,. + 4		; 51 C9 00 02
	dbf	D2,. + 0x1004		; 51 CA 10 02

	dbf.w	D0,.			; 51 C8 FF FE
	dbf.w	D1,. + 4		; 51 C9 00 02
	dbf.w	D2,. + 0x1004		; 51 CA 10 02

	dbhi	D0,.			; 52 C8 FF FE
	dbhi	D1,. + 4		; 52 C9 00 02
	dbhi	D2,. + 0x1004		; 52 CA 10 02

	dbhi.w	D0,.			; 52 C8 FF FE
	dbhi.w	D1,. + 4		; 52 C9 00 02
	dbhi.w	D2,. + 0x1004		; 52 CA 10 02

	dbls	D0,.			; 53 C8 FF FE
	dbls	D1,. + 4		; 53 C9 00 02
	dbls	D2,. + 0x1004		; 53 CA 10 02

	dbls.w	D0,.			; 53 C8 FF FE
	dbls.w	D1,. + 4		; 53 C9 00 02
	dbls.w	D2,. + 0x1004		; 53 CA 10 02

	dbcc	D0,.			; 54 C8 FF FE
	dbcc	D1,. + 4		; 54 C9 00 02
	dbcc	D2,. + 0x1004		; 54 CA 10 02

	dbcc.w	D0,.			; 54 C8 FF FE
	dbcc.w	D1,. + 4		; 54 C9 00 02
	dbcc.w	D2,. + 0x1004		; 54 CA 10 02

	dbcs	D0,.			; 55 C8 FF FE
	dbcs	D1,. + 4		; 55 C9 00 02
	dbcs	D2,. + 0x1004		; 55 CA 10 02

	dbcs.w	D0,.			; 55 C8 FF FE
	dbcs.w	D1,. + 4		; 55 C9 00 02
	dbcs.w	D2,. + 0x1004		; 55 CA 10 02

	dbne	D0,.			; 56 C8 FF FE
	dbne	D1,. + 4		; 56 C9 00 02
	dbne	D2,. + 0x1004		; 56 CA 10 02

	dbne.w	D0,.			; 56 C8 FF FE
	dbne.w	D1,. + 4		; 56 C9 00 02
	dbne.w	D2,. + 0x1004		; 56 CA 10 02

	dbeq	D0,.			; 57 C8 FF FE
	dbeq	D1,. + 4		; 57 C9 00 02
	dbeq	D2,. + 0x1004		; 57 CA 10 02

	dbeq.w	D0,.			; 57 C8 FF FE
	dbeq.w	D1,. + 4		; 57 C9 00 02
	dbeq.w	D2,. + 0x1004		; 57 CA 10 02

	dbvc	D0,.			; 58 C8 FF FE
	dbvc	D1,. + 4		; 58 C9 00 02
	dbvc	D2,. + 0x1004		; 58 CA 10 02

	dbvc.w	D0,.			; 58 C8 FF FE
	dbvc.w	D1,. + 4		; 58 C9 00 02
	dbvc.w	D2,. + 0x1004		; 58 CA 10 02

	dbvs	D0,.			; 59 C8 FF FE
	dbvs	D1,. + 4		; 59 C9 00 02
	dbvs	D2,. + 0x1004		; 59 CA 10 02

	dbvs.w	D0,.			; 59 C8 FF FE
	dbvs.w	D1,. + 4		; 59 C9 00 02
	dbvs.w	D2,. + 0x1004		; 59 CA 10 02

	dbpl	D0,.			; 5A C8 FF FE
	dbpl	D1,. + 4		; 5A C9 00 02
	dbpl	D2,. + 0x1004		; 5A CA 10 02

	dbpl.w	D0,.			; 5A C8 FF FE
	dbpl.w	D1,. + 4		; 5A C9 00 02
	dbpl.w	D2,. + 0x1004		; 5A CA 10 02

	dbmi	D0,.			; 5B C8 FF FE
	dbmi	D1,. + 4		; 5B C9 00 02
	dbmi	D2,. + 0x1004		; 5B CA 10 02

	dbmi.w	D0,.			; 5B C8 FF FE
	dbmi.w	D1,. + 4		; 5B C9 00 02
	dbmi.w	D2,. + 0x1004		; 5B CA 10 02

	dbge	D0,.			; 5C C8 FF FE
	dbge	D1,. + 4		; 5C C9 00 02
	dbge	D2,. + 0x1004		; 5C CA 10 02

	dbge.w	D0,.			; 5C C8 FF FE
	dbge.w	D1,. + 4		; 5C C9 00 02
	dbge.w	D2,. + 0x1004		; 5C CA 10 02

	dblt	D0,.			; 5D C8 FF FE
	dblt	D1,. + 4		; 5D C9 00 02
	dblt	D2,. + 0x1004		; 5D CA 10 02

	dblt.w	D0,.			; 5D C8 FF FE
	dblt.w	D1,. + 4		; 5D C9 00 02
	dblt.w	D2,. + 0x1004		; 5D CA 10 02

	dbgt	D0,.			; 5E C8 FF FE
	dbgt	D1,. + 4		; 5E C9 00 02
	dbgt	D2,. + 0x1004		; 5E CA 10 02

	dbgt.w	D0,.			; 5E C8 FF FE
	dbgt.w	D1,. + 4		; 5E C9 00 02
	dbgt.w	D2,. + 0x1004		; 5E CA 10 02

	dble	D0,.			; 5F C8 FF FE
	dble	D1,. + 4		; 5F C9 00 02
	dble	D2,. + 0x1004		; 5F CA 10 02

	dble.w	D0,.			; 5F C8 FF FE
	dble.w	D1,. + 4		; 5F C9 00 02
	dble.w	D2,. + 0x1004		; 5F CA 10 02

	dbra	D0,.			; 51 C8 FF FE
	dbra	D1,. + 4		; 51 C9 00 02
	dbra	D2,. + 0x1004		; 51 CA 10 02

	dbra.w	D0,.			; 51 C8 FF FE
	dbra.w	D1,. + 4		; 51 C9 00 02
	dbra.w	D2,. + 0x1004		; 51 CA 10 02

	dbhs	D0,.			; 54 C8 FF FE
	dbhs	D1,. + 4		; 54 C9 00 02
	dbhs	D2,. + 0x1004		; 54 CA 10 02

	dbhs.w	D0,.			; 54 C8 FF FE
	dbhs.w	D1,. + 4		; 54 C9 00 02
	dbhs.w	D2,. + 0x1004		; 54 CA 10 02

	dblo	D0,.			; 55 C8 FF FE
	dblo	D1,. + 4		; 55 C9 00 02
	dblo	D2,. + 0x1004		; 55 CA 10 02

	dblo.w	D0,.			; 55 C8 FF FE
	dblo.w	D1,. + 4		; 55 C9 00 02
	dblo.w	D2,. + 0x1004		; 55 CA 10 02

	dbhis	D0,.			; 54 C8 FF FE
	dbhis	D1,. + 4		; 54 C9 00 02
	dbhis	D2,. + 0x1004		; 54 CA 10 02

	dbhis.w	D0,.			; 54 C8 FF FE
	dbhis.w	D1,. + 4		; 54 C9 00 02
	dbhis.w	D2,. + 0x1004		; 54 CA 10 02

	dblos	D0,.			; 53 C8 FF FE
	dblos	D1,. + 4		; 53 C9 00 02
	dblos	D2,. + 0x1004		; 53 CA 10 02

	dblos.w	D0,.			; 53 C8 FF FE
	dblos.w	D1,. + 4		; 53 C9 00 02
	dblos.w	D2,. + 0x1004		; 53 CA 10 02

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
	st	(A1)			; 50 D1
	st	(A2)+			; 50 DA
	st	-(A3)			; 50 E3
	st	1(A4)			; 50 EC 00 01
	st	2(A5,D7.W)		; 50 F5 70 02
	st	2(A5,D7.L)		; 50 F5 78 02
	st	(0x1234).W		; 50 F8 12 34
	st	(0x1234).L		; 50 F9 00 00 12 34
	st	*0xFFFFFFF0		; 50 F8 FF F0
	st	 0x00010004		; 50 F9 00 01 00 04
	st	(0x1234,A0,D1)		; 50 F0 11 20 12 34
	st	([2,A1,A2],4)		; 50 F1 A1 22 00 02 00
	st	([6,A2],D3,8)		; 50 F2 31 26 00 06 00

	st.b	D7			; 50 C7
	st.b	(A1)			; 50 D1
	st.b	(A2)+			; 50 DA
	st.b	-(A3)			; 50 E3
	st.b	1(A4)			; 50 EC 00 01
	st.b	2(A5,D7.W)		; 50 F5 70 02
	st.b	2(A5,D7.L)		; 50 F5 78 02
	st.b	(0x1234).W		; 50 F8 12 34
	st.b	(0x1234).L		; 50 F9 00 00 12 34
	st.b	*0xFFFFFFF0		; 50 F8 FF F0
	st.b	 0x00010004		; 50 F9 00 01 00 04
	st.b	(0x1234,A0,D1)		; 50 F0 11 20 12 34
	st.b	([2,A1,A2],4)		; 50 F1 A1 22 00 02 00
	st.b	([6,A2],D3,8)		; 50 F2 31 26 00 06 00


	sf	D7			; 51 C7
	sf	(A1)			; 51 D1
	sf	(A2)+			; 51 DA
	sf	-(A3)			; 51 E3
	sf	1(A4)			; 51 EC 00 01
	sf	2(A5,D7.W)		; 51 F5 70 02
	sf	2(A5,D7.L)		; 51 F5 78 02
	sf	(0x1234).W		; 51 F8 12 34
	sf	(0x1234).L		; 51 F9 00 00 12 34
	sf	*0xFFFFFFF0		; 51 F8 FF F0
	sf	 0x00010004		; 51 F9 00 01 00 04
	sf	(0x1234,A0,D1)		; 51 F0 11 20 12 34
	sf	([2,A1,A2],4)		; 51 F1 A1 22 00 02 00
	sf	([6,A2],D3,8)		; 51 F2 31 26 00 06 00

	sf.b	D7			; 51 C7
	sf.b	(A1)			; 51 D1
	sf.b	(A2)+			; 51 DA
	sf.b	-(A3)			; 51 E3
	sf.b	1(A4)			; 51 EC 00 01
	sf.b	2(A5,D7.W)		; 51 F5 70 02
	sf.b	2(A5,D7.L)		; 51 F5 78 02
	sf.b	(0x1234).W		; 51 F8 12 34
	sf.b	(0x1234).L		; 51 F9 00 00 12 34
	sf.b	*0xFFFFFFF0		; 51 F8 FF F0
	sf.b	 0x00010004		; 51 F9 00 01 00 04
	sf.b	(0x1234,A0,D1)		; 51 F0 11 20 12 34
	sf.b	([2,A1,A2],4)		; 51 F1 A1 22 00 02 00
	sf.b	([6,A2],D3,8)		; 51 F2 31 26 00 06 00


	shi	D7			; 52 C7
	shi	(A1)			; 52 D1
	shi	(A2)+			; 52 DA
	shi	-(A3)			; 52 E3
	shi	1(A4)			; 52 EC 00 01
	shi	2(A5,D7.W)		; 52 F5 70 02
	shi	2(A5,D7.L)		; 52 F5 78 02
	shi	(0x1234).W		; 52 F8 12 34
	shi	(0x1234).L		; 52 F9 00 00 12 34
	shi	*0xFFFFFFF0		; 52 F8 FF F0
	shi	 0x00010004		; 52 F9 00 01 00 04
	shi	(0x1234,A0,D1)		; 52 F0 11 20 12 34
	shi	([2,A1,A2],4)		; 52 F1 A1 22 00 02 00
	shi	([6,A2],D3,8)		; 52 F2 31 26 00 06 00

	shi.b	D7			; 52 C7
	shi.b	(A1)			; 52 D1
	shi.b	(A2)+			; 52 DA
	shi.b	-(A3)			; 52 E3
	shi.b	1(A4)			; 52 EC 00 01
	shi.b	2(A5,D7.W)		; 52 F5 70 02
	shi.b	2(A5,D7.L)		; 52 F5 78 02
	shi.b	(0x1234).W		; 52 F8 12 34
	shi.b	(0x1234).L		; 52 F9 00 00 12 34
	shi.b	*0xFFFFFFF0		; 52 F8 FF F0
	shi.b	 0x00010004		; 52 F9 00 01 00 04
	shi.b	(0x1234,A0,D1)		; 52 F0 11 20 12 34
	shi.b	([2,A1,A2],4)		; 52 F1 A1 22 00 02 00
	shi.b	([6,A2],D3,8)		; 52 F2 31 26 00 06 00


	sls	D7			; 53 C7
	sls	(A1)			; 53 D1
	sls	(A2)+			; 53 DA
	sls	-(A3)			; 53 E3
	sls	1(A4)			; 53 EC 00 01
	sls	2(A5,D7.W)		; 53 F5 70 02
	sls	2(A5,D7.L)		; 53 F5 78 02
	sls	(0x1234).W		; 53 F8 12 34
	sls	(0x1234).L		; 53 F9 00 00 12 34
	sls	*0xFFFFFFF0		; 53 F8 FF F0
	sls	 0x00010004		; 53 F9 00 01 00 04
	sls	(0x1234,A0,D1)		; 53 F0 11 20 12 34
	sls	([2,A1,A2],4)		; 53 F1 A1 22 00 02 00
	sls	([6,A2],D3,8)		; 53 F2 31 26 00 06 00

	sls.b	D7			; 53 C7
	sls.b	(A1)			; 53 D1
	sls.b	(A2)+			; 53 DA
	sls.b	-(A3)			; 53 E3
	sls.b	1(A4)			; 53 EC 00 01
	sls.b	2(A5,D7.W)		; 53 F5 70 02
	sls.b	2(A5,D7.L)		; 53 F5 78 02
	sls.b	(0x1234).W		; 53 F8 12 34
	sls.b	(0x1234).L		; 53 F9 00 00 12 34
	sls.b	*0xFFFFFFF0		; 53 F8 FF F0
	sls.b	 0x00010004		; 53 F9 00 01 00 04
	sls.b	(0x1234,A0,D1)		; 53 F0 11 20 12 34
	sls.b	([2,A1,A2],4)		; 53 F1 A1 22 00 02 00
	sls.b	([6,A2],D3,8)		; 53 F2 31 26 00 06 00


	scc	D7			; 54 C7
	scc	(A1)			; 54 D1
	scc	(A2)+			; 54 DA
	scc	-(A3)			; 54 E3
	scc	1(A4)			; 54 EC 00 01
	scc	2(A5,D7.W)		; 54 F5 70 02
	scc	2(A5,D7.L)		; 54 F5 78 02
	scc	(0x1234).W		; 54 F8 12 34
	scc	(0x1234).L		; 54 F9 00 00 12 34
	scc	*0xFFFFFFF0		; 54 F8 FF F0
	scc	 0x00010004		; 54 F9 00 01 00 04
	scc	(0x1234,A0,D1)		; 54 F0 11 20 12 34
	scc	([2,A1,A2],4)		; 54 F1 A1 22 00 02 00
	scc	([6,A2],D3,8)		; 54 F2 31 26 00 06 00

	scc.b	D7			; 54 C7
	scc.b	(A1)			; 54 D1
	scc.b	(A2)+			; 54 DA
	scc.b	-(A3)			; 54 E3
	scc.b	1(A4)			; 54 EC 00 01
	scc.b	2(A5,D7.W)		; 54 F5 70 02
	scc.b	2(A5,D7.L)		; 54 F5 78 02
	scc.b	(0x1234).W		; 54 F8 12 34
	scc.b	(0x1234).L		; 54 F9 00 00 12 34
	scc.b	*0xFFFFFFF0		; 54 F8 FF F0
	scc.b	 0x00010004		; 54 F9 00 01 00 04
	scc.b	(0x1234,A0,D1)		; 54 F0 11 20 12 34
	scc.b	([2,A1,A2],4)		; 54 F1 A1 22 00 02 00
	scc.b	([6,A2],D3,8)		; 54 F2 31 26 00 06 00


	scs	D7			; 55 C7
	scs	(A1)			; 55 D1
	scs	(A2)+			; 55 DA
	scs	-(A3)			; 55 E3
	scs	1(A4)			; 55 EC 00 01
	scs	2(A5,D7.W)		; 55 F5 70 02
	scs	2(A5,D7.L)		; 55 F5 78 02
	scs	(0x1234).W		; 55 F8 12 34
	scs	(0x1234).L		; 55 F9 00 00 12 34
	scs	*0xFFFFFFF0		; 55 F8 FF F0
	scs	 0x00010004		; 55 F9 00 01 00 04
	scs	(0x1234,A0,D1)		; 55 F0 11 20 12 34
	scs	([2,A1,A2],4)		; 55 F1 A1 22 00 02 00
	scs	([6,A2],D3,8)		; 55 F2 31 26 00 06 00

	scs.b	D7			; 55 C7
	scs.b	(A1)			; 55 D1
	scs.b	(A2)+			; 55 DA
	scs.b	-(A3)			; 55 E3
	scs.b	1(A4)			; 55 EC 00 01
	scs.b	2(A5,D7.W)		; 55 F5 70 02
	scs.b	2(A5,D7.L)		; 55 F5 78 02
	scs.b	(0x1234).W		; 55 F8 12 34
	scs.b	(0x1234).L		; 55 F9 00 00 12 34
	scs.b	*0xFFFFFFF0		; 55 F8 FF F0
	scs.b	 0x00010004		; 55 F9 00 01 00 04
	scs.b	(0x1234,A0,D1)		; 55 F0 11 20 12 34
	scs.b	([2,A1,A2],4)		; 55 F1 A1 22 00 02 00
	scs.b	([6,A2],D3,8)		; 55 F2 31 26 00 06 00


	sne	D7			; 56 C7
	sne	(A1)			; 56 D1
	sne	(A2)+			; 56 DA
	sne	-(A3)			; 56 E3
	sne	1(A4)			; 56 EC 00 01
	sne	2(A5,D7.W)		; 56 F5 70 02
	sne	2(A5,D7.L)		; 56 F5 78 02
	sne	(0x1234).W		; 56 F8 12 34
	sne	(0x1234).L		; 56 F9 00 00 12 34
	sne	*0xFFFFFFF0		; 56 F8 FF F0
	sne	 0x00010004		; 56 F9 00 01 00 04
	sne	(0x1234,A0,D1)		; 56 F0 11 20 12 34
	sne	([2,A1,A2],4)		; 56 F1 A1 22 00 02 00
	sne	([6,A2],D3,8)		; 56 F2 31 26 00 06 00

	sne.b	D7			; 56 C7
	sne.b	(A1)			; 56 D1
	sne.b	(A2)+			; 56 DA
	sne.b	-(A3)			; 56 E3
	sne.b	1(A4)			; 56 EC 00 01
	sne.b	2(A5,D7.W)		; 56 F5 70 02
	sne.b	2(A5,D7.L)		; 56 F5 78 02
	sne.b	(0x1234).W		; 56 F8 12 34
	sne.b	(0x1234).L		; 56 F9 00 00 12 34
	sne.b	*0xFFFFFFF0		; 56 F8 FF F0
	sne.b	 0x00010004		; 56 F9 00 01 00 04
	sne.b	(0x1234,A0,D1)		; 56 F0 11 20 12 34
	sne.b	([2,A1,A2],4)		; 56 F1 A1 22 00 02 00
	sne.b	([6,A2],D3,8)		; 56 F2 31 26 00 06 00


	seq	D7			; 57 C7
	seq	(A1)			; 57 D1
	seq	(A2)+			; 57 DA
	seq	-(A3)			; 57 E3
	seq	1(A4)			; 57 EC 00 01
	seq	2(A5,D7.W)		; 57 F5 70 02
	seq	2(A5,D7.L)		; 57 F5 78 02
	seq	(0x1234).W		; 57 F8 12 34
	seq	(0x1234).L		; 57 F9 00 00 12 34
	seq	*0xFFFFFFF0		; 57 F8 FF F0
	seq	 0x00010004		; 57 F9 00 01 00 04
	seq	(0x1234,A0,D1)		; 57 F0 11 20 12 34
	seq	([2,A1,A2],4)		; 57 F1 A1 22 00 02 00
	seq	([6,A2],D3,8)		; 57 F2 31 26 00 06 00

	seq.b	D7			; 57 C7
	seq.b	(A1)			; 57 D1
	seq.b	(A2)+			; 57 DA
	seq.b	-(A3)			; 57 E3
	seq.b	1(A4)			; 57 EC 00 01
	seq.b	2(A5,D7.W)		; 57 F5 70 02
	seq.b	2(A5,D7.L)		; 57 F5 78 02
	seq.b	(0x1234).W		; 57 F8 12 34
	seq.b	(0x1234).L		; 57 F9 00 00 12 34
	seq.b	*0xFFFFFFF0		; 57 F8 FF F0
	seq.b	 0x00010004		; 57 F9 00 01 00 04
	seq.b	(0x1234,A0,D1)		; 57 F0 11 20 12 34
	seq.b	([2,A1,A2],4)		; 57 F1 A1 22 00 02 00
	seq.b	([6,A2],D3,8)		; 57 F2 31 26 00 06 00


	svc	D7			; 58 C7
	svc	(A1)			; 58 D1
	svc	(A2)+			; 58 DA
	svc	-(A3)			; 58 E3
	svc	1(A4)			; 58 EC 00 01
	svc	2(A5,D7.W)		; 58 F5 70 02
	svc	2(A5,D7.L)		; 58 F5 78 02
	svc	(0x1234).W		; 58 F8 12 34
	svc	(0x1234).L		; 58 F9 00 00 12 34
	svc	*0xFFFFFFF0		; 58 F8 FF F0
	svc	 0x00010004		; 58 F9 00 01 00 04
	svc	(0x1234,A0,D1)		; 58 F0 11 20 12 34
	svc	([2,A1,A2],4)		; 58 F1 A1 22 00 02 00
	svc	([6,A2],D3,8)		; 58 F2 31 26 00 06 00

	svc.b	D7			; 58 C7
	svc.b	(A1)			; 58 D1
	svc.b	(A2)+			; 58 DA
	svc.b	-(A3)			; 58 E3
	svc.b	1(A4)			; 58 EC 00 01
	svc.b	2(A5,D7.W)		; 58 F5 70 02
	svc.b	2(A5,D7.L)		; 58 F5 78 02
	svc.b	(0x1234).W		; 58 F8 12 34
	svc.b	(0x1234).L		; 58 F9 00 00 12 34
	svc.b	*0xFFFFFFF0		; 58 F8 FF F0
	svc.b	 0x00010004		; 58 F9 00 01 00 04
	svc.b	(0x1234,A0,D1)		; 58 F0 11 20 12 34
	svc.b	([2,A1,A2],4)		; 58 F1 A1 22 00 02 00
	svc.b	([6,A2],D3,8)		; 58 F2 31 26 00 06 00

	svs	D7			; 59 C7
	svs	(A1)			; 59 D1
	svs	(A2)+			; 59 DA
	svs	-(A3)			; 59 E3
	svs	1(A4)			; 59 EC 00 01
	svs	2(A5,D7.W)		; 59 F5 70 02
	svs	2(A5,D7.L)		; 59 F5 78 02
	svs	(0x1234).W		; 59 F8 12 34
	svs	(0x1234).L		; 59 F9 00 00 12 34
	svs	*0xFFFFFFF0		; 59 F8 FF F0
	svs	 0x00010004		; 59 F9 00 01 00 04
	svs	(0x1234,A0,D1)		; 59 F0 11 20 12 34
	svs	([2,A1,A2],4)		; 59 F1 A1 22 00 02 00
	svs	([6,A2],D3,8)		; 59 F2 31 26 00 06 00

	svs.b	D7			; 59 C7
	svs.b	(A1)			; 59 D1
	svs.b	(A2)+			; 59 DA
	svs.b	-(A3)			; 59 E3
	svs.b	1(A4)			; 59 EC 00 01
	svs.b	2(A5,D7.W)		; 59 F5 70 02
	svs.b	2(A5,D7.L)		; 59 F5 78 02
	svs.b	(0x1234).W		; 59 F8 12 34
	svs.b	(0x1234).L		; 59 F9 00 00 12 34
	svs.b	*0xFFFFFFF0		; 59 F8 FF F0
	svs.b	 0x00010004		; 59 F9 00 01 00 04
	svs.b	(0x1234,A0,D1)		; 59 F0 11 20 12 34
	svs.b	([2,A1,A2],4)		; 59 F1 A1 22 00 02 00
	svs.b	([6,A2],D3,8)		; 59 F2 31 26 00 06 00

	spl	D7			; 5A C7
	spl	(A1)			; 5A D1
	spl	(A2)+			; 5A DA
	spl	-(A3)			; 5A E3
	spl	1(A4)			; 5A EC 00 01
	spl	2(A5,D7.W)		; 5A F5 70 02
	spl	2(A5,D7.L)		; 5A F5 78 02
	spl	(0x1234).W		; 5A F8 12 34
	spl	(0x1234).L		; 5A F9 00 00 12 34
	spl	*0xFFFFFFF0		; 5A F8 FF F0
	spl	 0x00010004		; 5A F9 00 01 00 04
	spl	(0x1234,A0,D1)		; 5A F0 11 20 12 34
	spl	([2,A1,A2],4)		; 5A F1 A1 22 00 02 00
	spl	([6,A2],D3,8)		; 5A F2 31 26 00 06 00

	spl.b	D7			; 5A C7
	spl.b	(A1)			; 5A D1
	spl.b	(A2)+			; 5A DA
	spl.b	-(A3)			; 5A E3
	spl.b	1(A4)			; 5A EC 00 01
	spl.b	2(A5,D7.W)		; 5A F5 70 02
	spl.b	2(A5,D7.L)		; 5A F5 78 02
	spl.b	(0x1234).W		; 5A F8 12 34
	spl.b	(0x1234).L		; 5A F9 00 00 12 34
	spl.b	*0xFFFFFFF0		; 5A F8 FF F0
	spl.b	 0x00010004		; 5A F9 00 01 00 04
	spl.b	(0x1234,A0,D1)		; 5A F0 11 20 12 34
	spl.b	([2,A1,A2],4)		; 5A F1 A1 22 00 02 00
	spl.b	([6,A2],D3,8)		; 5A F2 31 26 00 06 00

	smi	D7			; 5B C7
	smi	(A1)			; 5B D1
	smi	(A2)+			; 5B DA
	smi	-(A3)			; 5B E3
	smi	1(A4)			; 5B EC 00 01
	smi	2(A5,D7.W)		; 5B F5 70 02
	smi	2(A5,D7.L)		; 5B F5 78 02
	smi	(0x1234).W		; 5B F8 12 34
	smi	(0x1234).L		; 5B F9 00 00 12 34
	smi	*0xFFFFFFF0		; 5B F8 FF F0
	smi	 0x00010004		; 5B F9 00 01 00 04
	smi	(0x1234,A0,D1)		; 5B F0 11 20 12 34
	smi	([2,A1,A2],4)		; 5B F1 A1 22 00 02 00
	smi	([6,A2],D3,8)		; 5B F2 31 26 00 06 00

	smi.b	D7			; 5B C7
	smi.b	(A1)			; 5B D1
	smi.b	(A2)+			; 5B DA
	smi.b	-(A3)			; 5B E3
	smi.b	1(A4)			; 5B EC 00 01
	smi.b	2(A5,D7.W)		; 5B F5 70 02
	smi.b	2(A5,D7.L)		; 5B F5 78 02
	smi.b	(0x1234).W		; 5B F8 12 34
	smi.b	(0x1234).L		; 5B F9 00 00 12 34
	smi.b	*0xFFFFFFF0		; 5B F8 FF F0
	smi.b	 0x00010004		; 5B F9 00 01 00 04
	smi.b	(0x1234,A0,D1)		; 5B F0 11 20 12 34
	smi.b	([2,A1,A2],4)		; 5B F1 A1 22 00 02 00
	smi.b	([6,A2],D3,8)		; 5B F2 31 26 00 06 00

	sge	D7			; 5C C7
	sge	(A1)			; 5C D1
	sge	(A2)+			; 5C DA
	sge	-(A3)			; 5C E3
	sge	1(A4)			; 5C EC 00 01
	sge	2(A5,D7.W)		; 5C F5 70 02
	sge	2(A5,D7.L)		; 5C F5 78 02
	sge	(0x1234).W		; 5C F8 12 34
	sge	(0x1234).L		; 5C F9 00 00 12 34
	sge	*0xFFFFFFF0		; 5C F8 FF F0
	sge	 0x00010004		; 5C F9 00 01 00 04
	sge	(0x1234,A0,D1)		; 5C F0 11 20 12 34
	sge	([2,A1,A2],4)		; 5C F1 A1 22 00 02 00
	sge	([6,A2],D3,8)		; 5C F2 31 26 00 06 00

	sge.b	D7			; 5C C7
	sge.b	(A1)			; 5C D1
	sge.b	(A2)+			; 5C DA
	sge.b	-(A3)			; 5C E3
	sge.b	1(A4)			; 5C EC 00 01
	sge.b	2(A5,D7.W)		; 5C F5 70 02
	sge.b	2(A5,D7.L)		; 5C F5 78 02
	sge.b	(0x1234).W		; 5C F8 12 34
	sge.b	(0x1234).L		; 5C F9 00 00 12 34
	sge.b	*0xFFFFFFF0		; 5C F8 FF F0
	sge.b	 0x00010004		; 5C F9 00 01 00 04
	sge.b	(0x1234,A0,D1)		; 5C F0 11 20 12 34
	sge.b	([2,A1,A2],4)		; 5C F1 A1 22 00 02 00
	sge.b	([6,A2],D3,8)		; 5C F2 31 26 00 06 00

	slt	D7			; 5D C7
	slt	(A1)			; 5D D1
	slt	(A2)+			; 5D DA
	slt	-(A3)			; 5D E3
	slt	1(A4)			; 5D EC 00 01
	slt	2(A5,D7.W)		; 5D F5 70 02
	slt	2(A5,D7.L)		; 5D F5 78 02
	slt	(0x1234).W		; 5D F8 12 34
	slt	(0x1234).L		; 5D F9 00 00 12 34
	slt	*0xFFFFFFF0		; 5D F8 FF F0
	slt	 0x00010004		; 5D F9 00 01 00 04
	slt	(0x1234,A0,D1)		; 5D F0 11 20 12 34
	slt	([2,A1,A2],4)		; 5D F1 A1 22 00 02 00
	slt	([6,A2],D3,8)		; 5D F2 31 26 00 06 00

	slt.b	D7			; 5D C7
	slt.b	(A1)			; 5D D1
	slt.b	(A2)+			; 5D DA
	slt.b	-(A3)			; 5D E3
	slt.b	1(A4)			; 5D EC 00 01
	slt.b	2(A5,D7.W)		; 5D F5 70 02
	slt.b	2(A5,D7.L)		; 5D F5 78 02
	slt.b	(0x1234).W		; 5D F8 12 34
	slt.b	(0x1234).L		; 5D F9 00 00 12 34
	slt.b	*0xFFFFFFF0		; 5D F8 FF F0
	slt.b	 0x00010004		; 5D F9 00 01 00 04
	slt.b	(0x1234,A0,D1)		; 5D F0 11 20 12 34
	slt.b	([2,A1,A2],4)		; 5D F1 A1 22 00 02 00
	slt.b	([6,A2],D3,8)		; 5D F2 31 26 00 06 00

	sgt	D7			; 5E C7
	sgt	(A1)			; 5E D1
	sgt	(A2)+			; 5E DA
	sgt	-(A3)			; 5E E3
	sgt	1(A4)			; 5E EC 00 01
	sgt	2(A5,D7.W)		; 5E F5 70 02
	sgt	2(A5,D7.L)		; 5E F5 78 02
	sgt	(0x1234).W		; 5E F8 12 34
	sgt	(0x1234).L		; 5E F9 00 00 12 34
	sgt	*0xFFFFFFF0		; 5E F8 FF F0
	sgt	 0x00010004		; 5E F9 00 01 00 04
	sgt	(0x1234,A0,D1)		; 5E F0 11 20 12 34
	sgt	([2,A1,A2],4)		; 5E F1 A1 22 00 02 00
	sgt	([6,A2],D3,8)		; 5E F2 31 26 00 06 00

	sgt.b	D7			; 5E C7
	sgt.b	(A1)			; 5E D1
	sgt.b	(A2)+			; 5E DA
	sgt.b	-(A3)			; 5E E3
	sgt.b	1(A4)			; 5E EC 00 01
	sgt.b	2(A5,D7.W)		; 5E F5 70 02
	sgt.b	2(A5,D7.L)		; 5E F5 78 02
	sgt.b	(0x1234).W		; 5E F8 12 34
	sgt.b	(0x1234).L		; 5E F9 00 00 12 34
	sgt.b	*0xFFFFFFF0		; 5E F8 FF F0
	sgt.b	 0x00010004		; 5E F9 00 01 00 04
	sgt.b	(0x1234,A0,D1)		; 5E F0 11 20 12 34
	sgt.b	([2,A1,A2],4)		; 5E F1 A1 22 00 02 00
	sgt.b	([6,A2],D3,8)		; 5E F2 31 26 00 06 00

	sle	D7			; 5F C7
	sle	(A1)			; 5F D1
	sle	(A2)+			; 5F DA
	sle	-(A3)			; 5F E3
	sle	1(A4)			; 5F EC 00 01
	sle	2(A5,D7.W)		; 5F F5 70 02
	sle	2(A5,D7.L)		; 5F F5 78 02
	sle	(0x1234).W		; 5F F8 12 34
	sle	(0x1234).L		; 5F F9 00 00 12 34
	sle	*0xFFFFFFF0		; 5F F8 FF F0
	sle	 0x00010004		; 5F F9 00 01 00 04
	sle	(0x1234,A0,D1)		; 5F F0 11 20 12 34
	sle	([2,A1,A2],4)		; 5F F1 A1 22 00 02 00
	sle	([6,A2],D3,8)		; 5F F2 31 26 00 06 00

	sle.b	D7			; 5F C7
	sle.b	(A1)			; 5F D1
	sle.b	(A2)+			; 5F DA
	sle.b	-(A3)			; 5F E3
	sle.b	1(A4)			; 5F EC 00 01
	sle.b	2(A5,D7.W)		; 5F F5 70 02
	sle.b	2(A5,D7.L)		; 5F F5 78 02
	sle.b	(0x1234).W		; 5F F8 12 34
	sle.b	(0x1234).L		; 5F F9 00 00 12 34
	sle.b	*0xFFFFFFF0		; 5F F8 FF F0
	sle.b	 0x00010004		; 5F F9 00 01 00 04
	sle.b	(0x1234,A0,D1)		; 5F F0 11 20 12 34
	sle.b	([2,A1,A2],4)		; 5F F1 A1 22 00 02 00
	sle.b	([6,A2],D3,8)		; 5F F2 31 26 00 06 00

	shs	D7			; 54 C7
	shs	(A1)			; 54 D1
	shs	(A2)+			; 54 DA
	shs	-(A3)			; 54 E3
	shs	1(A4)			; 54 EC 00 01
	shs	2(A5,D7.W)		; 54 F5 70 02
	shs	2(A5,D7.L)		; 54 F5 78 02
	shs	(0x1234).W		; 54 F8 12 34
	shs	(0x1234).L		; 54 F9 00 00 12 34
	shs	*0xFFFFFFF0		; 54 F8 FF F0
	shs	 0x00010004		; 54 F9 00 01 00 04
	shs	(0x1234,A0,D1)		; 54 F0 11 20 12 34
	shs	([2,A1,A2],4)		; 54 F1 A1 22 00 02 00
	shs	([6,A2],D3,8)		; 54 F2 31 26 00 06 00

	shs.b	D7			; 54 C7
	shs.b	(A1)			; 54 D1
	shs.b	(A2)+			; 54 DA
	shs.b	-(A3)			; 54 E3
	shs.b	1(A4)			; 54 EC 00 01
	shs.b	2(A5,D7.W)		; 54 F5 70 02
	shs.b	2(A5,D7.L)		; 54 F5 78 02
	shs.b	(0x1234).W		; 54 F8 12 34
	shs.b	(0x1234).L		; 54 F9 00 00 12 34
	shs.b	*0xFFFFFFF0		; 54 F8 FF F0
	shs.b	 0x00010004		; 54 F9 00 01 00 04
	shs.b	(0x1234,A0,D1)		; 54 F0 11 20 12 34
	shs.b	([2,A1,A2],4)		; 54 F1 A1 22 00 02 00
	shs.b	([6,A2],D3,8)		; 54 F2 31 26 00 06 00

	slo	D7			; 55 C7
	slo	(A1)			; 55 D1
	slo	(A2)+			; 55 DA
	slo	-(A3)			; 55 E3
	slo	1(A4)			; 55 EC 00 01
	slo	2(A5,D7.W)		; 55 F5 70 02
	slo	2(A5,D7.L)		; 55 F5 78 02
	slo	(0x1234).W		; 55 F8 12 34
	slo	(0x1234).L		; 55 F9 00 00 12 34
	slo	*0xFFFFFFF0		; 55 F8 FF F0
	slo	 0x00010004		; 55 F9 00 01 00 04
	slo	(0x1234,A0,D1)		; 55 F0 11 20 12 34
	slo	([2,A1,A2],4)		; 55 F1 A1 22 00 02 00
	slo	([6,A2],D3,8)		; 55 F2 31 26 00 06 00

	slo.b	D7			; 55 C7
	slo.b	(A1)			; 55 D1
	slo.b	(A2)+			; 55 DA
	slo.b	-(A3)			; 55 E3
	slo.b	1(A4)			; 55 EC 00 01
	slo.b	2(A5,D7.W)		; 55 F5 70 02
	slo.b	2(A5,D7.L)		; 55 F5 78 02
	slo.b	(0x1234).W		; 55 F8 12 34
	slo.b	(0x1234).L		; 55 F9 00 00 12 34
	slo.b	*0xFFFFFFF0		; 55 F8 FF F0
	slo.b	 0x00010004		; 55 F9 00 01 00 04
	slo.b	(0x1234,A0,D1)		; 55 F0 11 20 12 34
	slo.b	([2,A1,A2],4)		; 55 F1 A1 22 00 02 00
	slo.b	([6,A2],D3,8)		; 55 F2 31 26 00 06 00

	shis	D7			; 54 C7
	shis	(A1)			; 54 D1
	shis	(A2)+			; 54 DA
	shis	-(A3)			; 54 E3
	shis	1(A4)			; 54 EC 00 01
	shis	2(A5,D7.W)		; 54 F5 70 02
	shis	2(A5,D7.L)		; 54 F5 78 02
	shis	(0x1234).W		; 54 F8 12 34
	shis	(0x1234).L		; 54 F9 00 00 12 34
	shis	*0xFFFFFFF0		; 54 F8 FF F0
	shis	 0x00010004		; 54 F9 00 01 00 04
	shis	(0x1234,A0,D1)		; 54 F0 11 20 12 34
	shis	([2,A1,A2],4)		; 54 F1 A1 22 00 02 00
	shis	([6,A2],D3,8)		; 54 F2 31 26 00 06 00

	shis.b	D7			; 54 C7
	shis.b	(A1)			; 54 D1
	shis.b	(A2)+			; 54 DA
	shis.b	-(A3)			; 54 E3
	shis.b	1(A4)			; 54 EC 00 01
	shis.b	2(A5,D7.W)		; 54 F5 70 02
	shis.b	2(A5,D7.L)		; 54 F5 78 02
	shis.b	(0x1234).W		; 54 F8 12 34
	shis.b	(0x1234).L		; 54 F9 00 00 12 34
	shis.b	*0xFFFFFFF0		; 54 F8 FF F0
	shis.b	 0x00010004		; 54 F9 00 01 00 04
	shis.b	(0x1234,A0,D1)		; 54 F0 11 20 12 34
	shis.b	([2,A1,A2],4)		; 54 F1 A1 22 00 02 00
	shis.b	([6,A2],D3,8)		; 54 F2 31 26 00 06 00

	slos	D7			; 53 C7
	slos	(A1)			; 53 D1
	slos	(A2)+			; 53 DA
	slos	-(A3)			; 53 E3
	slos	1(A4)			; 53 EC 00 01
	slos	2(A5,D7.W)		; 53 F5 70 02
	slos	2(A5,D7.L)		; 53 F5 78 02
	slos	(0x1234).W		; 53 F8 12 34
	slos	(0x1234).L		; 53 F9 00 00 12 34
	slos	*0xFFFFFFF0		; 53 F8 FF F0
	slos	 0x00010004		; 53 F9 00 01 00 04
	slos	(0x1234,A0,D1)		; 53 F0 11 20 12 34
	slos	([2,A1,A2],4)		; 53 F1 A1 22 00 02 00
	slos	([6,A2],D3,8)		; 53 F2 31 26 00 06 00

	slos.b	D7			; 53 C7
	slos.b	(A1)			; 53 D1
	slos.b	(A2)+			; 53 DA
	slos.b	-(A3)			; 53 E3
	slos.b	1(A4)			; 53 EC 00 01
	slos.b	2(A5,D7.W)		; 53 F5 70 02
	slos.b	2(A5,D7.L)		; 53 F5 78 02
	slos.b	(0x1234).W		; 53 F8 12 34
	slos.b	(0x1234).L		; 53 F9 00 00 12 34
	slos.b	*0xFFFFFFF0		; 53 F8 FF F0
	slos.b	 0x00010004		; 53 F9 00 01 00 04
	slos.b	(0x1234,A0,D1)		; 53 F0 11 20 12 34
	slos.b	([2,A1,A2],4)		; 53 F1 A1 22 00 02 00
	slos.b	([6,A2],D3,8)		; 53 F2 31 26 00 06 00

	.sbttl	Type S_BIT Instructions: BCHG, BCLR, BSET, BTST

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_BIT:						*
	;*	BCHG, BCLR, BSET, BTST				*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	bchg	D0,D6			; 01 46
	bchg	#5,D7			; 08 47 00 05

	bchg	D2,(A1)			; 05 51
	bchg	D3,(A2)+		; 07 5A
	bchg	D4,-(A3)		; 09 63
	bchg	D5,1(A4)		; 0B 6C 00 01
	bchg	D6,2(A5,D7.W)		; 0D 75 70 02
	bchg	D6,2(A5,D7.L)		; 0D 75 78 02
	bchg	D7,(0x1234).W		; 0F 78 12 34
	bchg	D7,(0x1234).L		; 0F 79 00 00 12 34
	bchg	D0,*0xFFFFFFF0		; 01 78 FF F0
	bchg	D0, 0x00010004		; 01 79 00 01 00 04
	bchg	D0,(0x1234,A0,D1)	; 01 70 11 20 12 34
	bchg	D1,([2,A1,A2],4)	; 03 71 A1 22 00 02 00
	bchg	D2,([6,A2],D3,8)	; 05 72 31 26 00 06 00
	bchg	#2,(A1)			; 08 51 00 02
	bchg	#3,(A2)+		; 08 5A 00 03
	bchg	#4,-(A3)		; 08 63 00 04
	bchg	#5,1(A4)		; 08 6C 00 05 00 01
	bchg	#6,2(A5,D7.W)		; 08 75 00 06 70 02
	bchg	#6,2(A5,D7.L)		; 08 75 00 06 78 02
	bchg	#7,(0x1234).W		; 08 78 00 07 12 34
	bchg	#7,(0x1234).L		; 08 79 00 07 00 00 12
	bchg	#8,*0xFFFFFFF0		; 08 78 00 08 FF F0
	bchg	#8, 0x00010004		; 08 79 00 08 00 01 00
	bchg	#9,(0x1234,A0,D1)	; 08 70 00 09 11 20 12
	bchg	#10,([2,A1,A2],4)	; 08 71 00 0A A1 22 00
	bchg	#11,([6,A2],D3,8)	; 08 72 00 0B 31 26 00
	bchg.b	D2,(A1)			; 05 51
	bchg.b	D3,(A2)+		; 07 5A
	bchg.b	D4,-(A3)		; 09 63
	bchg.b	D5,1(A4)		; 0B 6C 00 01
	bchg.b	D6,2(A5,D7.W)		; 0D 75 70 02
	bchg.b	D6,2(A5,D7.L)		; 0D 75 78 02
	bchg.b	D7,(0x1234).W		; 0F 78 12 34
	bchg.b	D7,(0x1234).L		; 0F 79 00 00 12 34
	bchg.b	D0,*0xFFFFFFF0		; 01 78 FF F0
	bchg.b	D0, 0x00010004		; 01 79 00 01 00 04
	bchg.b	D0,(0x1234,A0,D1)	; 01 70 11 20 12 34
	bchg.b	D1,([2,A1,A2],4)	; 03 71 A1 22 00 02 00
	bchg.b	D2,([6,A2],D3,8)	; 05 72 31 26 00 06 00
	bchg.b	#2,(A1)			; 08 51 00 02
	bchg.b	#3,(A2)+		; 08 5A 00 03
	bchg.b	#4,-(A3)		; 08 63 00 04
	bchg.b	#5,1(A4)		; 08 6C 00 05 00 01
	bchg.b	#6,2(A5,D7.W)		; 08 75 00 06 70 02
	bchg.b	#6,2(A5,D7.L)		; 08 75 00 06 78 02
	bchg.b	#7,(0x1234).W		; 08 78 00 07 12 34
	bchg.b	#7,(0x1234).L		; 08 79 00 07 00 00 12
	bchg.b	#8,*0xFFFFFFF0		; 08 78 00 08 FF F0
	bchg.b	#8, 0x00010004		; 08 79 00 08 00 01 00
	bchg.b	#9,(0x1234,A0,D1)	; 08 70 00 09 11 20 12
	bchg.b	#10,([2,A1,A2],4)	; 08 71 00 0A A1 22 00
	bchg.b	#11,([6,A2],D3,8)	; 08 72 00 0B 31 26 00
	bchg.l	D0,D6			; 01 46
	bchg.l	#5,D7			; 08 47 00 05

	bclr	D0,D6			; 01 86
	bclr	#5,D7			; 08 87 00 05

	bclr	D2,(A1)			; 05 91
	bclr	D3,(A2)+		; 07 9A
	bclr	D4,-(A3)		; 09 A3
	bclr	D5,1(A4)		; 0B AC 00 01
	bclr	D6,2(A5,D7.W)		; 0D B5 70 02
	bclr	D6,2(A5,D7.L)		; 0D B5 78 02
	bclr	D7,(0x1234).W		; 0F B8 12 34
	bclr	D7,(0x1234).L		; 0F B9 00 00 12 34
	bclr	D0,*0xFFFFFFF0		; 01 B8 FF F0
	bclr	D0, 0x00010004		; 01 B9 00 01 00 04
	bclr	D0,(0x1234,A0,D1)	; 01 B0 11 20 12 34
	bclr	D1,([2,A1,A2],4)	; 03 B1 A1 22 00 02 00
	bclr	D2,([6,A2],D3,8)	; 05 B2 31 26 00 06 00
	bclr	#2,(A1)			; 08 91 00 02
	bclr	#3,(A2)+		; 08 9A 00 03
	bclr	#4,-(A3)		; 08 A3 00 04
	bclr	#5,1(A4)		; 08 AC 00 05 00 01
	bclr	#6,2(A5,D7.W)		; 08 B5 00 06 70 02
	bclr	#6,2(A5,D7.L)		; 08 B5 00 06 78 02
	bclr	#7,(0x1234).W		; 08 B8 00 07 12 34
	bclr	#7,(0x1234).L		; 08 B9 00 07 00 00 12
	bclr	#8,*0xFFFFFFF0		; 08 B8 00 08 FF F0
	bclr	#8, 0x00010004		; 08 B9 00 08 00 01 00
	bclr	#9,(0x1234,A0,D1)	; 08 B0 00 09 11 20 12
	bclr	#10,([2,A1,A2],4)	; 08 B1 00 0A A1 22 00
	bclr	#11,([6,A2],D3,8)	; 08 B2 00 0B 31 26 00
	bclr.b	D2,(A1)			; 05 91
	bclr.b	D3,(A2)+		; 07 9A
	bclr.b	D4,-(A3)		; 09 A3
	bclr.b	D5,1(A4)		; 0B AC 00 01
	bclr.b	D6,2(A5,D7.W)		; 0D B5 70 02
	bclr.b	D6,2(A5,D7.L)		; 0D B5 78 02
	bclr.b	D7,(0x1234).W		; 0F B8 12 34
	bclr.b	D7,(0x1234).L		; 0F B9 00 00 12 34
	bclr.b	D0,*0xFFFFFFF0		; 01 B8 FF F0
	bclr.b	D0, 0x00010004		; 01 B9 00 01 00 04
	bclr.b	D0,(0x1234,A0,D1)	; 01 B0 11 20 12 34
	bclr.b	D1,([2,A1,A2],4)	; 03 B1 A1 22 00 02 00
	bclr.b	D2,([6,A2],D3,8)	; 05 B2 31 26 00 06 00
	bclr.b	#2,(A1)			; 08 91 00 02
	bclr.b	#3,(A2)+		; 08 9A 00 03
	bclr.b	#4,-(A3)		; 08 A3 00 04
	bclr.b	#5,1(A4)		; 08 AC 00 05 00 01
	bclr.b	#6,2(A5,D7.W)		; 08 B5 00 06 70 02
	bclr.b	#6,2(A5,D7.L)		; 08 B5 00 06 78 02
	bclr.b	#7,(0x1234).W		; 08 B8 00 07 12 34
	bclr.b	#7,(0x1234).L		; 08 B9 00 07 00 00 12
	bclr.b	#8,*0xFFFFFFF0		; 08 B8 00 08 FF F0
	bclr.b	#8, 0x00010004		; 08 B9 00 08 00 01 00
	bclr.b	#9,(0x1234,A0,D1)	; 08 B0 00 09 11 20 12
	bclr.b	#10,([2,A1,A2],4)	; 08 B1 00 0A A1 22 00
	bclr.b	#11,([6,A2],D3,8)	; 08 B2 00 0B 31 26 00
	bclr.l	D0,D6			; 01 86
	bclr.l	#5,D7			; 08 87 00 05

	bset	D0,D6			; 01 C6
	bset	#5,D7			; 08 C7 00 05

	bset	D2,(A1)			; 05 D1
	bset	D3,(A2)+		; 07 DA
	bset	D4,-(A3)		; 09 E3
	bset	D5,1(A4)		; 0B EC 00 01
	bset	D6,2(A5,D7.W)		; 0D F5 70 02
	bset	D6,2(A5,D7.L)		; 0D F5 78 02
	bset	D7,(0x1234).W		; 0F F8 12 34
	bset	D7,(0x1234).L		; 0F F9 00 00 12 34
	bset	D0,*0xFFFFFFF0		; 01 F8 FF F0
	bset	D0, 0x00010004		; 01 F9 00 01 00 04
	bset	D0,(0x1234,A0,D1)	; 01 F0 11 20 12 34
	bset	D1,([2,A1,A2],4)	; 03 F1 A1 22 00 02 00
	bset	D2,([6,A2],D3,8)	; 05 F2 31 26 00 06 00
	bset	#2,(A1)			; 08 D1 00 02
	bset	#3,(A2)+		; 08 DA 00 03
	bset	#4,-(A3)		; 08 E3 00 04
	bset	#5,1(A4)		; 08 EC 00 05 00 01
	bset	#6,2(A5,D7.W)		; 08 F5 00 06 70 02
	bset	#6,2(A5,D7.L)		; 08 F5 00 06 78 02
	bset	#7,(0x1234).W		; 08 F8 00 07 12 34
	bset	#7,(0x1234).L		; 08 F9 00 07 00 00 12
	bset	#8,*0xFFFFFFF0		; 08 F8 00 08 FF F0
	bset	#8, 0x00010004		; 08 F9 00 08 00 01 00
	bset	#9,(0x1234,A0,D1)	; 08 F0 00 09 11 20 12
	bset	#10,([2,A1,A2],4)	; 08 F1 00 0A A1 22 00
	bset	#11,([6,A2],D3,8)	; 08 F2 00 0B 31 26 00
	bset.b	D2,(A1)			; 05 D1
	bset.b	D3,(A2)+		; 07 DA
	bset.b	D4,-(A3)		; 09 E3
	bset.b	D5,1(A4)		; 0B EC 00 01
	bset.b	D6,2(A5,D7.W)		; 0D F5 70 02
	bset.b	D6,2(A5,D7.L)		; 0D F5 78 02
	bset.b	D7,(0x1234).W		; 0F F8 12 34
	bset.b	D7,(0x1234).L		; 0F F9 00 00 12 34
	bset.b	D0,*0xFFFFFFF0		; 01 F8 FF F0
	bset.b	D0, 0x00010004		; 01 F9 00 01 00 04
	bset.b	D0,(0x1234,A0,D1)	; 01 F0 11 20 12 34
	bset.b	D1,([2,A1,A2],4)	; 03 F1 A1 22 00 02 00
	bset.b	D2,([6,A2],D3,8)	; 05 F2 31 26 00 06 00
	bset.b	#2,(A1)			; 08 D1 00 02
	bset.b	#3,(A2)+		; 08 DA 00 03
	bset.b	#4,-(A3)		; 08 E3 00 04
	bset.b	#5,1(A4)		; 08 EC 00 05 00 01
	bset.b	#6,2(A5,D7.W)		; 08 F5 00 06 70 02
	bset.b	#6,2(A5,D7.L)		; 08 F5 00 06 78 02
	bset.b	#7,(0x1234).W		; 08 F8 00 07 12 34
	bset.b	#7,(0x1234).L		; 08 F9 00 07 00 00 12
	bset.b	#8,*0xFFFFFFF0		; 08 F8 00 08 FF F0
	bset.b	#8, 0x00010004		; 08 F9 00 08 00 01 00
	bset.b	#9,(0x1234,A0,D1)	; 08 F0 00 09 11 20 12
	bset.b	#10,([2,A1,A2],4)	; 08 F1 00 0A A1 22 00
	bset.b	#11,([6,A2],D3,8)	; 08 F2 00 0B 31 26 00
	bset.l	D0,D6			; 01 C6
	bset.l	#5,D7			; 08 C7 00 05

	btst	D0,D6			; 01 06
	btst	#5,D7			; 08 07 00 05

	btst	D2,(A1)			; 05 11
	btst	D3,(A2)+		; 07 1A
	btst	D4,-(A3)		; 09 23
	btst	D5,1(A4)		; 0B 2C 00 01
	btst	D6,2(A5,D7.W)		; 0D 35 70 02
	btst	D6,2(A5,D7.L)		; 0D 35 78 02
	btst	D7,(0x1234).W		; 0F 38 12 34
	btst	D7,(0x1234).L		; 0F 39 00 00 12 34
	btst	D0,*0xFFFFFFF0		; 01 38 FF F0
	btst	D0, 0x00010004		; 01 39 00 01 00 04
	btst	D0,(0x1234,A0,D1)	; 01 30 11 20 12 34
	btst	D1,([2,A1,A2],4)	; 03 31 A1 22 00 02 00
	btst	D2,([6,A2],D3,8)	; 05 32 31 26 00 06 00
	btst	D4,5(PC)		; 09 3A 00 03
	btst	D5,6(PC,A7.W)		; 0B 3B F0 04
	btst	D5,6(PC,A7.L)		; 0B 3B F8 04
	btst	D7,(0x1234,PC,D0)	; 0F 3B 01 20 12 32
	btst	D1,([2,PC,A2],4)	; 03 3B A1 22 00 00 00
	btst	D2,([6,PC],D3,8)	; 05 3B 31 26 00 04 00
	btst	#2,(A1)			; 08 11 00 02
	btst	#3,(A2)+		; 08 1A 00 03
	btst	#4,-(A3)		; 08 23 00 04
	btst	#5,1(A4)		; 08 2C 00 05 00 01
	btst	#6,2(A5,D7.W)		; 08 35 00 06 70 02
	btst	#6,2(A5,D7.L)		; 08 35 00 06 78 02
	btst	#7,(0x1234).W		; 08 38 00 07 12 34
	btst	#7,(0x1234).L		; 08 39 00 07 00 00 12
	btst	#8,*0xFFFFFFF0		; 08 38 00 08 FF F0
	btst	#8, 0x00010004		; 08 39 00 08 00 01 00
	btst	#9,(0x1234,A0,D1)	; 08 30 00 09 11 20 12
	btst	#10,([2,A1,A2],4)	; 08 31 00 0A A1 22 00
	btst	#11,([6,A2],D3,8)	; 08 32 00 0B 31 26 00
	btst	#12,5(PC)		; 08 3A 00 0C 00 03
	btst	#13,6(PC,A7.W)		; 08 3B 00 0D F0 04
	btst	#14,6(PC,A7.L)		; 08 3B 00 0E F8 04
	btst	#15,(0x1234,PC,D0)	; 08 3B 00 0F 01 20 12
	btst	#16,([2,PC,A2],4)	; 08 3B 00 10 A1 22 00
	btst	#17,([6,PC],D3,8)	; 08 3B 00 11 31 26 00
	btst.b	D2,(A1)			; 05 11
	btst.b	D3,(A2)+		; 07 1A
	btst.b	D4,-(A3)		; 09 23
	btst.b	D5,1(A4)		; 0B 2C 00 01
	btst.b	D6,2(A5,D7.W)		; 0D 35 70 02
	btst.b	D6,2(A5,D7.L)		; 0D 35 78 02
	btst.b	D7,(0x1234).W		; 0F 38 12 34
	btst.b	D7,(0x1234).L		; 0F 39 00 00 12 34
	btst.b	D0,*0xFFFFFFF0		; 01 38 FF F0
	btst.b	D0, 0x00010004		; 01 39 00 01 00 04
	btst.b	D0,(0x1234,A0,D1)	; 01 30 11 20 12 34
	btst.b	D1,([2,A1,A2],4)	; 03 31 A1 22 00 02 00
	btst.b	D2,([6,A2],D3,8)	; 05 32 31 26 00 06 00
	btst.b	D4,5(PC)		; 09 3A 00 03
	btst.b	D5,6(PC,A7.W)		; 0B 3B F0 04
	btst.b	D5,6(PC,A7.L)		; 0B 3B F8 04
	btst.b	D7,(0x1234,PC,D0)	; 0F 3B 01 20 12 32
	btst.b	D1,([2,PC,A2],4)	; 03 3B A1 22 00 00 00
	btst.b	D2,([6,PC],D3,8)	; 05 3B 31 26 00 04 00
	btst.b	#2,(A1)			; 08 11 00 02
	btst.b	#3,(A2)+		; 08 1A 00 03
	btst.b	#4,-(A3)		; 08 23 00 04
	btst.b	#5,1(A4)		; 08 2C 00 05 00 01
	btst.b	#6,2(A5,D7.W)		; 08 35 00 06 70 02
	btst.b	#6,2(A5,D7.L)		; 08 35 00 06 78 02
	btst.b	#7,(0x1234).W		; 08 38 00 07 12 34
	btst.b	#7,(0x1234).L		; 08 39 00 07 00 00 12
	btst.b	#8,*0xFFFFFFF0		; 08 38 00 08 FF F0
	btst.b	#8, 0x00010004		; 08 39 00 08 00 01 00
	btst.b	#9,(0x1234,A0,D1)	; 08 30 00 09 11 20 12
	btst.b	#10,([2,A1,A2],4)	; 08 31 00 0A A1 22 00
	btst.b	#11,([6,A2],D3,8)	; 08 32 00 0B 31 26 00
	btst.b	#12,5(PC)		; 08 3A 00 0C 00 03
	btst.b	#13,6(PC,A7.W)		; 08 3B 00 0D F0 04
	btst.b	#14,6(PC,A7.L)		; 08 3B 00 0E F8 04
	btst.b	#15,(0x1234,PC,D0)	; 08 3B 00 0F 01 20 12
	btst.b	#16,([2,PC,A2],4)	; 08 3B 00 10 A1 22 00
	btst.b	#17,([6,PC],D3,8)	; 08 3B 00 11 31 26 00
	btst.l	D0,D6			; 01 06
	btst.l	#5,D7			; 08 07 00 05

	.sbttl	Type S_MOVE Instructions: MOVE

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_MOVE:						*
	;*	MOVE						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	move	D0,CCR			; 44 C0
	move	CCR,(A0)		; 42 D0
	move	(A1)+,SR		; 46 D9
	move	SR,-(A2)		; 40 E2
	move	1(A3),CCR		; 44 EB 00 01
	move	CCR,2(A5,D7.W)		; 42 F5 70 02
	move	2(A5,D7.L),SR		; 46 F5 78 02
	move	SR,(0x1234).W		; 40 F8 12 34
	move	(0x1234).L,CCR		; 44 F9 00 00 12 34
	move	CCR,*0xFFFFFFF0		; 42 F8 FF F0
	move	 0x00010004,SR		; 46 F9 00 01 00 04
	move	SR,(0x1234,A0,D1)	; 40 F0 11 20 12 34
	move	([2,A1,A2],4),CCR	; 44 F1 A1 22 00 02 00
	move	CCR,([6,A2],D3,8)	; 42 F2 31 26 00 06 00
	move	#8,SR			; 46 FC 00 08
	move	(PC),CCR		; 44 FA FF FE
	move	2(PC,D2),SR		; 46 FB 20 00
	move	(0x1234,PC,D1),CCR	; 44 FB 11 20 12 32
	move	([2,PC,A2],4),SR	; 46 FB A1 22 00 00 00
	move	([6,PC],D3,8),CCR	; 44 FB 31 26 00 04 00
	move	A1,USP			; 4E 61
	move	USP,A2			; 4E 6A

	move	A0,2(A5,D7.L)		; 3B 88 78 02
	move	6(PC,A7.L),A0		; 30 7B F8 04
	move	6(PC,A7.W),(A1)		; 32 BB F0 04
	move	0x00010004,-(A3)	; 37 39 00 01 00 04
	move	1(A4),*0xFFFFFFF0	; 31 EC 00 01 FF F0
	move	2(A5,D7.L),2(A5,D7.W)	; 3B B5 78 02 70 02
	move	2(A5,D7.W),2(A5,D7.L)	; 3B B5 70 02 78 02
	move	(0x1234).W,(0x8765).L	; 33 F8 12 34 00 00 87
	move	(0x1234).L,(0x7654).W	; 31 F9 00 00 12 34 76
	move	*0xFFFFFFF0,1(A4)	; 39 78 FF F0 00 01
	move	-(A3),0x00010004	; 33 E3 00 01 00 04
	move	(0x1234,A0,D1),(A2)+	; 34 F0 11 20 12 34
	move	([2,A1,A2],4),(A1)	; 32 B1 A1 22 00 02 00
	move	([6,A2],D3,8),D0	; 30 32 31 26 00 06 00
	move	#7,D7			; 3E 3C 00 07
	move	5(PC),(A2)+		; 34 FA 00 03
	move	6(PC,A7.W),-(A3)	; 37 3B F0 04
	move	6(PC,A7.L),2(A4)	; 39 7B F8 04 00 02
	move	(0x1234,PC,D1),*0xFFFFFFF0	; 31 FB 11 20 12 32 FF
	move	([2,PC,A2],4),0x00010004	; 33 FB A1 22 00 00 00
	move	([6,PC],D3,8),2(A5,D7.W)	; 3B BB 31 26 00 04 00

	move.b	6(PC,A7.W),(A1)		; 12 BB F0 04
	move.b	0x00010004,-(A3)	; 17 39 00 01 00 04
	move.b	1(A4),*0xFFFFFFF0	; 11 EC 00 01 FF F0
	move.b	2(A5,D7.L),2(A5,D7.W)	; 1B B5 78 02 70 02
	move.b	2(A5,D7.W),2(A5,D7.L)	; 1B B5 70 02 78 02
	move.b	(0x1234).W,(0x8765).L	; 13 F8 12 34 00 00 87
	move.b	(0x1234).L,(0x7654).W	; 11 F9 00 00 12 34 76
	move.b	*0xFFFFFFF0,1(A4)	; 19 78 FF F0 00 01
	move.b	-(A3),0x00010004	; 13 E3 00 01 00 04
	move.b	(0x1234,A0,D1),(A2)+	; 14 F0 11 20 12 34
	move.b	([2,A1,A2],4),(A1)	; 12 B1 A1 22 00 02 00
	move.b	([6,A2],D3,8),D0	; 10 32 31 26 00 06 00
	move.b	#7,D7			; 1E 3C 00 07
	move.b	5(PC),(A2)+		; 14 FA 00 03
	move.b	6(PC,A7.W),-(A3)	; 17 3B F0 04
	move.b	6(PC,A7.L),2(A4)	; 19 7B F8 04 00 02
	move.b	(0x1234,PC,D1),*0xFFFFFFF0	; 11 FB 11 20 12 32 FF
	move.b	([2,PC,A2],4),0x00010004	; 13 FB A1 22 00 00 00
	move.b	([6,PC],D3,8),2(A5,D7.W)	; 1B BB 31 26 00 04 00
	move.w	D0,CCR			; 44 C0
	move.w	CCR,(A0)		; 42 D0
	move.w	(A1)+,SR		; 46 D9
	move.w	SR,-(A2)		; 40 E2
	move.w	1(A3),CCR		; 44 EB 00 01
	move.w	CCR,2(A5,D7.W)		; 42 F5 70 02
	move.w	2(A5,D7.L),SR		; 46 F5 78 02
	move.w	SR,(0x1234).W		; 40 F8 12 34
	move.w	(0x1234).L,CCR		; 44 F9 00 00 12 34
	move.w	CCR,*0xFFFFFFF0		; 42 F8 FF F0
	move.w	 0x00010004,SR		; 46 F9 00 01 00 04
	move.w	SR,(0x1234,A0,D1)	; 40 F0 11 20 12 34
	move.w	([2,A1,A2],4),CCR	; 44 F1 A1 22 00 02 00
	move.w	CCR,([6,A2],D3,8)	; 42 F2 31 26 00 06 00
	move.w	#8,SR			; 46 FC 00 08
	move.w	(PC),CCR		; 44 FA FF FE
	move.w	2(PC,D2),SR		; 46 FB 20 00
	move.w	(0x1234,PC,D1),CCR	; 44 FB 11 20 12 32
	move.w	([2,PC,A2],4),SR	; 46 FB A1 22 00 00 00
	move.w	([6,PC],D3,8),CCR	; 44 FB 31 26 00 04 00

	move.w	A0,2(A5,D7.L)		; 3B 88 78 02
	move.w	6(PC,A7.L),A0		; 30 7B F8 04
	move.w	6(PC,A7.W),(A1)		; 32 BB F0 04
	move.w	0x00010004,-(A3)	; 37 39 00 01 00 04
	move.w	1(A4),*0xFFFFFFF0	; 31 EC 00 01 FF F0
	move.w	2(A5,D7.L),2(A5,D7.W)	; 3B B5 78 02 70 02
	move.w	2(A5,D7.W),2(A5,D7.L)	; 3B B5 70 02 78 02
	move.w	(0x1234).W,(0x8765).L	; 33 F8 12 34 00 00 87
	move.w	(0x1234).L,(0x7654).W	; 31 F9 00 00 12 34 76
	move.w	*0xFFFFFFF0,1(A4)	; 39 78 FF F0 00 01
	move.w	-(A3),0x00010004	; 33 E3 00 01 00 04
	move.w	(0x1234,A0,D1),(A2)+	; 34 F0 11 20 12 34
	move.w	([2,A1,A2],4),(A1)	; 32 B1 A1 22 00 02 00
	move.w	([6,A2],D3,8),D0	; 30 32 31 26 00 06 00
	move.w	#7,D7			; 3E 3C 00 07
	move.w	5(PC),(A2)+		; 34 FA 00 03
	move.w	6(PC,A7.W),-(A3)	; 37 3B F0 04
	move.w	6(PC,A7.L),2(A4)	; 39 7B F8 04 00 02
	move.w	(0x1234,PC,D1),*0xFFFFFFF0	; 31 FB 11 20 12 32 FF
	move.w	([2,PC,A2],4),0x00010004	; 33 FB A1 22 00 00 00
	move.w	([6,PC],D3,8),2(A5,D7.W)	; 3B BB 31 26 00 04 00
	move.l	A1,USP			; 4E 61
	move.l	USP,A2			; 4E 6A

	move.l	A0,2(A5,D7.L)		; 2B 88 78 02
	move.l	6(PC,A7.L),A0		; 20 7B F8 04
	move.l	6(PC,A7.W),(A1)		; 22 BB F0 04
	move.l	0x00010004,-(A3)	; 27 39 00 01 00 04
	move.l	1(A4),*0xFFFFFFF0	; 21 EC 00 01 FF F0
	move.l	2(A5,D7.L),2(A5,D7.W)	; 2B B5 78 02 70 02
	move.l	2(A5,D7.W),2(A5,D7.L)	; 2B B5 70 02 78 02
	move.l	(0x1234).W,(0x8765).L	; 23 F8 12 34 00 00 87
	move.l	(0x1234).L,(0x7654).W	; 21 F9 00 00 12 34 76
	move.l	*0xFFFFFFF0,1(A4)	; 29 78 FF F0 00 01
	move.l	-(A3),0x00010004	; 23 E3 00 01 00 04
	move.l	(0x1234,A0,D1),(A2)+	; 24 F0 11 20 12 34
	move.l	([2,A1,A2],4),(A1)	; 22 B1 A1 22 00 02 00
	move.l	([6,A2],D3,8),D0	; 20 32 31 26 00 06 00
	move.l	#7,D7			; 7E 07
	move.l	5(PC),(A2)+		; 24 FA 00 03
	move.l	6(PC,A7.W),-(A3)	; 27 3B F0 04
	move.l	6(PC,A7.L),2(A4)	; 29 7B F8 04 00 02
	move.l	(0x1234,PC,D1),*0xFFFFFFF0	; 21 FB 11 20 12 32 FF
	move.l	([2,PC,A2],4),0x00010004	; 23 FB A1 22 00 00 00
	move.l	([6,PC],D3,8),2(A5,D7.W)	; 2B BB 31 26 00 04 00
	.sbttl	Type S_MOVEA Instructions: MOVEA

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_MOVEA:						*
	;*	MOVEA						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	movea	D7,A0			; 30 47
	movea	A0,A1			; 32 48
	movea	(A1),A2			; 34 51
	movea	(A2)+,A3		; 36 5A
	movea	-(A3),A4		; 38 63
	movea	1(A4),A5		; 3A 6C 00 01
	movea	2(A5,D7.W),A6		; 3C 75 70 02
	movea	2(A5,D7.L),A6		; 3C 75 78 02
	movea	(0x1234).W,A7		; 3E 78 12 34
	movea	(0x1234).L,A7		; 3E 79 00 00 12 34
	movea	*0xFFFFFFF0,A0		; 30 78 FF F0
	movea	 0x00010004,A1		; 32 79 00 01 00 04
	movea	#7,A2			; 34 7C 00 07
	movea	5(PC),A3		; 36 7A 00 03
	movea	6(PC,A7.W),A4		; 38 7B F0 04
	movea	6(PC,A7.L),A4		; 38 7B F8 04
	movea	(0x1234,A0,D1),A0	; 30 70 11 20 12 34
	movea	([2,A1,A2],4),A1	; 32 71 A1 22 00 02 00
	movea	([6,A2],D3,8),A2	; 34 72 31 26 00 06 00
	movea	(0x1234,PC,D1),A3	; 36 7B 11 20 12 32
	movea	([2,PC,A2],4),A4	; 38 7B A1 22 00 00 00
	movea	([6,PC],D3,8),A5	; 3A 7B 31 26 00 04 00

	movea.w	D7,A0			; 30 47
	movea.w	A0,A1			; 32 48
	movea.w	(A1),A2			; 34 51
	movea.w	(A2)+,A3		; 36 5A
	movea.w	-(A3),A4		; 38 63
	movea.w	1(A4),A5		; 3A 6C 00 01
	movea.w	2(A5,D7.W),A6		; 3C 75 70 02
	movea.w	2(A5,D7.L),A6		; 3C 75 78 02
	movea.w	(0x1234).W,A7		; 3E 78 12 34
	movea.w	(0x1234).L,A7		; 3E 79 00 00 12 34
	movea.w	*0xFFFFFFF0,A0		; 30 78 FF F0
	movea.w	 0x00010004,A1		; 32 79 00 01 00 04
	movea.w	#7,A2			; 34 7C 00 07
	movea.w	5(PC),A3		; 36 7A 00 03
	movea.w	6(PC,A7.W),A4		; 38 7B F0 04
	movea.w	6(PC,A7.L),A4		; 38 7B F8 04
	movea.w	(0x1234,A0,D1),A0	; 30 70 11 20 12 34
	movea.w	([2,A1,A2],4),A1	; 32 71 A1 22 00 02 00
	movea.w	([6,A2],D3,8),A2	; 34 72 31 26 00 06 00
	movea.w	(0x1234,PC,D1),A3	; 36 7B 11 20 12 32
	movea.w	([2,PC,A2],4),A4	; 38 7B A1 22 00 00 00
	movea.w	([6,PC],D3,8),A5	; 3A 7B 31 26 00 04 00

	movea.l	D7,A0			; 20 47
	movea.l	A0,A1			; 22 48
	movea.l	(A1),A2			; 24 51
	movea.l	(A2)+,A3		; 26 5A
	movea.l	-(A3),A4		; 28 63
	movea.l	1(A4),A5		; 2A 6C 00 01
	movea.l	2(A5,D7.W),A6		; 2C 75 70 02
	movea.l	2(A5,D7.L),A6		; 2C 75 78 02
	movea.l	(0x1234).W,A7		; 2E 78 12 34
	movea.l	(0x1234).L,A7		; 2E 79 00 00 12 34
	movea.l	*0xFFFFFFF0,A0		; 20 78 FF F0
	movea.l	 0x00010004,A1		; 22 79 00 01 00 04
	movea.l	#7,A2			; 24 7C 00 00 00 07
	movea.l	5(PC),A3		; 26 7A 00 03
	movea.l	6(PC,A7.W),A4		; 28 7B F0 04
	movea.l	6(PC,A7.L),A4		; 28 7B F8 04
	movea.l	(0x1234,A0,D1),A0	; 20 70 11 20 12 34
	movea.l	([2,A1,A2],4),A1	; 22 71 A1 22 00 02 00
	movea.l	([6,A2],D3,8),A2	; 24 72 31 26 00 06 00
	movea.l	(0x1234,PC,D1),A3	; 26 7B 11 20 12 32
	movea.l	([2,PC,A2],4),A4	; 28 7B A1 22 00 00 00
	movea.l	([6,PC],D3,8),A5	; 2A 7B 31 26 00 04 00

	.sbttl	Type S_MOVEM Instructions: MOVEM

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_MOVEM:						*
	;*	MOVEM						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	movem	D0,(A1)			; 48 D1 00 01
	movem	D1,-(A3)		; 48 E3 40 00
	movem	D2,1(A4)		; 48 EC 00 04 00 01
	movem	A0,2(A5,D7.W)		; 48 F5 01 00 70 02
	movem	A1,2(A5,D7.L)		; 48 F5 02 00 78 02
	movem	A2,(0x1234).W		; 48 F8 04 00 12 34
	movem	A3,(0x1234).L		; 48 F9 08 00 00 00 12
	movem	A4,*0xFFFFFFF0		; 48 F8 10 00 FF F0
	movem	A5, 0x00010004		; 48 F9 20 00 00 01 00
	movem	D3,(0x1234,A0,D1)	; 48 F0 00 08 11 20 12
	movem	D4,([2,A1,A2],4)	; 48 F1 00 10 A1 22 00
	movem	D5,([6,A2],D3,8)	; 48 F2 00 20 31 26 00

	movem	D0-D3/A0-A7,(A4)	; 48 D4 FF 0F
	movem	D0-D7/A3/A7,-(A5)	; 48 E5 FF 11

	movem	(A1),D0			; 4C D1 00 01
	movem	(A3)+,D1		; 4C DB 00 02
	movem	1(A4),D2		; 4C EC 00 04 00 01
	movem	2(A5,D7.W),A0		; 4C F5 01 00 70 02
	movem	2(A5,D7.L),A1		; 4C F5 02 00 78 02
	movem	(0x1234).W,A2		; 4C F8 04 00 12 34
	movem	(0x1234).L,A3		; 4C F9 08 00 00 00 12
	movem	*0xFFFFFFF0,A4		; 4C F8 10 00 FF F0
	movem	 0x00010004,A5		; 4C F9 20 00 00 01 00
	movem	(PC),D0			; 4C FA 00 01 FF FC
	movem	6(PC,A7.W),A1		; 4C FB 02 00 F0 02
	movem	6(PC,A7.L),D2		; 4C FB 00 04 F8 02
	movem	(0x1234,PC,D1),D2	; 4C FB 00 04 11 20 12
	movem	([2,PC,A2],4),D3	; 4C FB 00 08 A1 22 FF
	movem	([6,PC],D3,8),D4	; 4C FB 00 10 31 26 00

	movem	4(PC,A5.L),D4-D7/A0-A3	; 4C FB 0F F0 D8 00
	movem	(A4),D0-D3/A0-A7	; 4C D4 FF 0F
	movem	(A5)+,D0-D7/A3/A7	; 4C DD 88 FF

	movem.w	D0,(A1)			; 48 91 00 01
	movem.w	D1,-(A3)		; 48 A3 40 00
	movem.w	D2,1(A4)		; 48 AC 00 04 00 01
	movem.w	A0,2(A5,D7.W)		; 48 B5 01 00 70 02
	movem.w	A1,2(A5,D7.L)		; 48 B5 02 00 78 02
	movem.w	A2,(0x1234).W		; 48 B8 04 00 12 34
	movem.w	A3,(0x1234).L		; 48 B9 08 00 00 00 12
	movem.w	A4,*0xFFFFFFF0		; 48 B8 10 00 FF F0
	movem.w	A5, 0x00010004		; 48 B9 20 00 00 01 00
	movem.w	D3,(0x1234,A0,D1)	; 48 B0 00 08 11 20 12
	movem.w	D4,([2,A1,A2],4)	; 48 B1 00 10 A1 22 00
	movem.w	D5,([6,A2],D3,8)	; 48 B2 00 20 31 26 00

	movem.w	D0-D3/A0-A7,(A4)	; 48 94 FF 0F
	movem.w	D0-D7/A3/A7,-(A5)	; 48 A5 FF 11

	movem.w	(A1),D0			; 4C 91 00 01
	movem.w	(A3)+,D1		; 4C 9B 00 02
	movem.w	1(A4),D2		; 4C AC 00 04 00 01
	movem.w	2(A5,D7.W),A0		; 4C B5 01 00 70 02
	movem.w	2(A5,D7.L),A1		; 4C B5 02 00 78 02
	movem.w	(0x1234).W,A2		; 4C B8 04 00 12 34
	movem.w	(0x1234).L,A3		; 4C B9 08 00 00 00 12
	movem.w	*0xFFFFFFF0,A4		; 4C B8 10 00 FF F0
	movem.w	 0x00010004,A5		; 4C B9 20 00 00 01 00
	movem.w	(PC),D0			; 4C BA 00 01 FF FC
	movem.w	6(PC,A7.W),A1		; 4C BB 02 00 F0 02
	movem.w	6(PC,A7.L),D2		; 4C BB 00 04 F8 02
	movem.w	(0x1234,PC,D1),D2	; 4C BB 00 04 11 20 12
	movem.w	([2,PC,A2],4),D3	; 4C BB 00 08 A1 22 FF
	movem.w	([6,PC],D3,8),D4	; 4C BB 00 10 31 26 00

	movem.w	4(PC,A5.L),D4-D7/A0-A3	; 4C BB 0F F0 D8 00
	movem.w	(A4),D0-D3/A0-A7	; 4C 94 FF 0F
	movem.w	(A5)+,D0-D7/A3/A7	; 4C 9D 88 FF

	movem.l	D0,(A1)			; 48 D1 00 01
	movem.l	D1,-(A3)		; 48 E3 40 00
	movem.l	D2,1(A4)		; 48 EC 00 04 00 01
	movem.l	A0,2(A5,D7.W)		; 48 F5 01 00 70 02
	movem.l	A1,2(A5,D7.L)		; 48 F5 02 00 78 02
	movem.l	A2,(0x1234).W		; 48 F8 04 00 12 34
	movem.l	A3,(0x1234).L		; 48 F9 08 00 00 00 12
	movem.l	A4,*0xFFFFFFF0		; 48 F8 10 00 FF F0
	movem.l	A5, 0x00010004		; 48 F9 20 00 00 01 00
	movem.l	D3,(0x1234,A0,D1)	; 48 F0 00 08 11 20 12
	movem.l	D4,([2,A1,A2],4)	; 48 F1 00 10 A1 22 00
	movem.l	D5,([6,A2],D3,8)	; 48 F2 00 20 31 26 00

	movem.l	D0-D3/A0-A7,(A4)	; 48 D4 FF 0F
	movem.l	D0-D7/A3/A7,-(A5)	; 48 E5 FF 11

	movem.l	(A1),D0			; 4C D1 00 01
	movem.l	(A3)+,D1		; 4C DB 00 02
	movem.l	1(A4),D2		; 4C EC 00 04 00 01
	movem.l	2(A5,D7.W),A0		; 4C F5 01 00 70 02
	movem.l	2(A5,D7.L),A1		; 4C F5 02 00 78 02
	movem.l	(0x1234).W,A2		; 4C F8 04 00 12 34
	movem.l	(0x1234).L,A3		; 4C F9 08 00 00 00 12
	movem.l	*0xFFFFFFF0,A4		; 4C F8 10 00 FF F0
	movem.l	 0x00010004,A5		; 4C F9 20 00 00 01 00
	movem.l	(PC),D0			; 4C FA 00 01 FF FC
	movem.l	6(PC,A7.W),A1		; 4C FB 02 00 F0 02
	movem.l	6(PC,A7.L),D2		; 4C FB 00 04 F8 02
	movem.l	(0x1234,PC,D1),D2	; 4C FB 00 04 11 20 12
	movem.l	([2,PC,A2],4),D3	; 4C FB 00 08 A1 22 FF
	movem.l	([6,PC],D3,8),D4	; 4C FB 00 10 31 26 00

	movem.l	4(PC,A5.L),D4-D7/A0-A3	; 4C FB 0F F0 D8 00
	movem.l	(A4),D0-D3/A0-A7	; 4C D4 FF 0F
	movem.l	(A5)+,D0-D7/A3/A7	; 4C DD 88 FF

	.sbttl	Type S_MOVEP Instructions: MOVEP

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_MOVEP:						*
	;*	MOVEP						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	movep	D1,0x100(A2)		; 03 8A 01 00
	movep	0x200(A3),D4		; 09 0B 02 00

	movep.w	D1,0x100(A2)		; 03 8A 01 00
	movep.w	0x200(A3),D4		; 09 0B 02 00

	movep.l	D1,0x100(A2)		; 03 CA 01 00
	movep.l	0x200(A3),D4		; 09 4B 02 00

	.sbttl	Type S_MOVEQ Instructions: MOVEQ

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_MOVEQ:						*
	;*	MOVEQ						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	moveq	#0x0F,D3		; 76 0F

	.sbttl	Type S_CHK Instructions: CHK

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_CHK:						*
	;*	CHK						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	chk	D0,D1			; 43 80
	chk	(A1),D2			; 45 91
	chk	(A2)+,D3		; 47 9A
	chk	-(A3),D4		; 49 A3
	chk	1(A4),D5		; 4B AC 00 01
	chk	2(A5,D7.W),D6		; 4D B5 70 02
	chk	2(A5,D7.L),D6		; 4D B5 78 02
	chk	*0xFFFFFFF0,D7		; 4F B8 FF F0
	chk	 0x00010004,D7		; 4F B9 00 01 00 04
	chk	(PC),D0			; 41 BA FF FE
	chk	6(PC,A7.W),D1		; 43 BB F0 04
	chk	6(PC,A7.L),D1		; 43 BB F8 04
	chk	#2,D2			; 45 BC 00 02
	chk	(0x1234,A0,D1),D0	; 41 B0 11 20 12 34
	chk	([2,A1,A2],4),D1	; 43 B1 A1 22 00 02 00
	chk	([6,A2],D3,8),D2	; 45 B2 31 26 00 06 00
	chk	(0x1234,PC,D1),D3	; 47 BB 11 20 12 32
	chk	([2,PC,A2],4),D4	; 49 BB A1 22 00 00 00
	chk	([6,PC],D3,8),D5	; 4B BB 31 26 00 04 00

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
	chk.w	(0x1234,A0,D1),D0	; 41 B0 11 20 12 34
	chk.w	([2,A1,A2],4),D1	; 43 B1 A1 22 00 02 00
	chk.w	([6,A2],D3,8),D2	; 45 B2 31 26 00 06 00
	chk.w	(0x1234,PC,D1),D3	; 47 BB 11 20 12 32
	chk.w	([2,PC,A2],4),D4	; 49 BB A1 22 00 00 00
	chk.w	([6,PC],D3,8),D5	; 4B BB 31 26 00 04 00

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
	chk.l	(0x1234,A0,D1),D0	; 41 30 11 20 12 34
	chk.l	([2,A1,A2],4),D1	; 43 31 A1 22 00 02 00
	chk.l	([6,A2],D3,8),D2	; 45 32 31 26 00 06 00
	chk.l	(0x1234,PC,D1),D3	; 47 3B 11 20 12 32
	chk.l	([2,PC,A2],4),D4	; 49 3B A1 22 00 00 00
	chk.l	([6,PC],D3,8),D5	; 4B 3B 31 26 00 04 00

	.sbttl	Type S_CMP Instructions: CMP

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_CMP:						*
	;*	CMP						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	cmp	D0,D0			; B0 40
	cmp	A0,D1			; B2 48
	cmp	(A1),D2			; B4 51
	cmp	(A2)+,D3		; B6 5A
	cmp	-(A3),D4		; B8 63
	cmp	1(A4),D5		; BA 6C 00 01
	cmp	2(A5,D7.W),D6		; BC 75 70 02
	cmp	2(A5,D7.L),D6		; BC 75 78 02
	cmp	(0x1234).W,D7		; BE 78 12 34
	cmp	(0x1234).L,D7		; BE 79 00 00 12 34
	cmp	*0xFFFFFFF0,D7		; BE 78 FF F0
	cmp	 0x00010004,D7		; BE 79 00 01 00 04
	cmp	#2,D3			; 0C 43 00 02
	cmp	(PC),D0			; B0 7A FF FE
	cmp	6(PC,A7.W),D1		; B2 7B F0 04
	cmp	6(PC,A7.L),D2		; B4 7B F8 04
	cmp	(0x1234,A0,D1),D0	; B0 70 11 20 12 34
	cmp	([2,A1,A2],4),D1	; B2 71 A1 22 00 02 00
	cmp	([6,A2],D3,8),D2	; B4 72 31 26 00 06 00
	cmp	(0x1234,PC,D1),D3	; B6 7B 11 20 12 32
	cmp	([2,PC,A2],4),D4	; B8 7B A1 22 00 00 00
	cmp	([6,PC],D3,8),D5	; BA 7B 31 26 00 04 00

	cmp.b	D0,D0			; B0 00
	cmp.b	(A1),D2			; B4 11
	cmp.b	(A2)+,D3		; B6 1A
	cmp.b	-(A3),D4		; B8 23
	cmp.b	1(A4),D5		; BA 2C 00 01
	cmp.b	2(A5,D7.W),D6		; BC 35 70 02
	cmp.b	2(A5,D7.L),D6		; BC 35 78 02
	cmp.b	(0x1234).W,D7		; BE 38 12 34
	cmp.b	(0x1234).L,D7		; BE 39 00 00 12 34
	cmp.b	*0xFFFFFFF0,D7		; BE 38 FF F0
	cmp.b	 0x00010004,D7		; BE 39 00 01 00 04
	cmp.b	#2,D3			; 0C 03 00 02
	cmp.b	(PC),D0			; B0 3A FF FE
	cmp.b	6(PC,A7.W),D1		; B2 3B F0 04
	cmp.b	6(PC,A7.L),D2		; B4 3B F8 04
	cmp.b	(0x1234,A0,D1),D0	; B0 30 11 20 12 34
	cmp.b	([2,A1,A2],4),D1	; B2 31 A1 22 00 02 00
	cmp.b	([6,A2],D3,8),D2	; B4 32 31 26 00 06 00
	cmp.b	(0x1234,PC,D1),D3	; B6 3B 11 20 12 32
	cmp.b	([2,PC,A2],4),D4	; B8 3B A1 22 00 00 00
	cmp.b	([6,PC],D3,8),D5	; BA 3B 31 26 00 04 00

	cmp.w	D0,D0			; B0 40
	cmp.w	A0,D1			; B2 48
	cmp.w	(A1),D2			; B4 51
	cmp.w	(A2)+,D3		; B6 5A
	cmp.w	-(A3),D4		; B8 63
	cmp.w	1(A4),D5		; BA 6C 00 01
	cmp.w	2(A5,D7.W),D6		; BC 75 70 02
	cmp.w	2(A5,D7.L),D6		; BC 75 78 02
	cmp.w	(0x1234).W,D7		; BE 78 12 34
	cmp.w	(0x1234).L,D7		; BE 79 00 00 12 34
	cmp.w	*0xFFFFFFF0,D7		; BE 78 FF F0
	cmp.w	 0x00010004,D7		; BE 79 00 01 00 04
	cmp.w	#2,D3			; 0C 43 00 02
	cmp.w	(PC),D0			; B0 7A FF FE
	cmp.w	6(PC,A7.W),D1		; B2 7B F0 04
	cmp.w	6(PC,A7.L),D2		; B4 7B F8 04
	cmp.w	(0x1234,A0,D1),D0	; B0 70 11 20 12 34
	cmp.w	([2,A1,A2],4),D1	; B2 71 A1 22 00 02 00
	cmp.w	([6,A2],D3,8),D2	; B4 72 31 26 00 06 00
	cmp.w	(0x1234,PC,D1),D3	; B6 7B 11 20 12 32
	cmp.w	([2,PC,A2],4),D4	; B8 7B A1 22 00 00 00
	cmp.w	([6,PC],D3,8),D5	; BA 7B 31 26 00 04 00

	cmp.l	D0,D0			; B0 80
	cmp.l	A0,D1			; B2 88
	cmp.l	(A1),D2			; B4 91
	cmp.l	(A2)+,D3		; B6 9A
	cmp.l	-(A3),D4		; B8 A3
	cmp.l	1(A4),D5		; BA AC 00 01
	cmp.l	2(A5,D7.W),D6		; BC B5 70 02
	cmp.l	2(A5,D7.L),D6		; BC B5 78 02
	cmp.l	(0x1234).W,D7		; BE B8 12 34
	cmp.l	(0x1234).L,D7		; BE B9 00 00 12 34
	cmp.l	*0xFFFFFFF0,D7		; BE B8 FF F0
	cmp.l	 0x00010004,D7		; BE B9 00 01 00 04
	cmp.l	#2,D3			; 0C 83 00 00 00 02
	cmp.l	(PC),D0			; B0 BA FF FE
	cmp.l	6(PC,A7.W),D1		; B2 BB F0 04
	cmp.l	6(PC,A7.L),D2		; B4 BB F8 04
	cmp.l	(0x1234,A0,D1),D0	; B0 B0 11 20 12 34
	cmp.l	([2,A1,A2],4),D1	; B2 B1 A1 22 00 02 00
	cmp.l	([6,A2],D3,8),D2	; B4 B2 31 26 00 06 00
	cmp.l	(0x1234,PC,D1),D3	; B6 BB 11 20 12 32
	cmp.l	([2,PC,A2],4),D4	; B8 BB A1 22 00 00 00
	cmp.l	([6,PC],D3,8),D5	; BA BB 31 26 00 04 00

	.sbttl	Type S_CMPM Instructions: CMPM

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_CMPM:						*
	;*	CMPM						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	cmpm	(A1)+,(A2)+		; B5 49

	cmpm.b	(A1)+,(A2)+		; B5 09

	cmpm.w	(A1)+,(A2)+		; B5 49

	cmpm.l	(A1)+,(A2)+		; B5 89

	.sbttl	Type S_EOR Instructions: EOR

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_EOR:						*
	;*	EOR						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	eor	D0,D1			; B1 41
	eor	D2,(A1)			; B5 51
	eor	D3,(A2)+		; B7 5A
	eor	D4,-(A3)		; B9 63
	eor	D5,1(A4)		; BB 6C 00 01
	eor	D6,2(A5,D7.W)		; BD 75 70 02
	eor	D6,2(A5,D7.L)		; BD 75 78 02
	eor	D7,(0x1234).W		; BF 78 12 34
	eor	D7,(0x1234).L		; BF 79 00 00 12 34
	eor	D7,*0xFFFFFFF0		; BF 78 FF F0
	eor	D7, 0x00010004		; BF 79 00 01 00 04
	eor	#3,D2			; 0A 42 00 03
	eor	D0,(0x1234,A0,D1)	; B1 70 11 20 12 34
	eor	D1,([2,A1,A2],4)	; B3 71 A1 22 00 02 00
	eor	D2,([6,A2],D3,8)	; B5 72 31 26 00 06 00

	eor.b	D0,D1			; B1 01
	eor.b	D2,(A1)			; B5 11
	eor.b	D3,(A2)+		; B7 1A
	eor.b	D4,-(A3)		; B9 23
	eor.b	D5,1(A4)		; BB 2C 00 01
	eor.b	D6,2(A5,D7.W)		; BD 35 70 02
	eor.b	D6,2(A5,D7.L)		; BD 35 78 02
	eor.b	D7,(0x1234).W		; BF 38 12 34
	eor.b	D7,(0x1234).L		; BF 39 00 00 12 34
	eor.b	D7,*0xFFFFFFF0		; BF 38 FF F0
	eor.b	D7, 0x00010004		; BF 39 00 01 00 04
	eor.b	#3,D2			; 0A 02 00 03
	eor.b	D0,(0x1234,A0,D1)	; B1 30 11 20 12 34
	eor.b	D1,([2,A1,A2],4)	; B3 31 A1 22 00 02 00
	eor.b	D2,([6,A2],D3,8)	; B5 32 31 26 00 06 00

	eor.w	D0,D1			; B1 41
	eor.w	D2,(A1)			; B5 51
	eor.w	D3,(A2)+		; B7 5A
	eor.w	D4,-(A3)		; B9 63
	eor.w	D5,1(A4)		; BB 6C 00 01
	eor.w	D6,2(A5,D7.W)		; BD 75 70 02
	eor.w	D6,2(A5,D7.L)		; BD 75 78 02
	eor.w	D7,(0x1234).W		; BF 78 12 34
	eor.w	D7,(0x1234).L		; BF 79 00 00 12 34
	eor.w	D7,*0xFFFFFFF0		; BF 78 FF F0
	eor.w	D7, 0x00010004		; BF 79 00 01 00 04
	eor.w	#3,D2			; 0A 42 00 03
	eor.w	D0,(0x1234,A0,D1)	; B1 70 11 20 12 34
	eor.w	D1,([2,A1,A2],4)	; B3 71 A1 22 00 02 00
	eor.w	D2,([6,A2],D3,8)	; B5 72 31 26 00 06 00

	eor.l	D0,D1			; B1 81
	eor.l	D2,(A1)			; B5 91
	eor.l	D3,(A2)+		; B7 9A
	eor.l	D4,-(A3)		; B9 A3
	eor.l	D5,1(A4)		; BB AC 00 01
	eor.l	D6,2(A5,D7.W)		; BD B5 70 02
	eor.l	D6,2(A5,D7.L)		; BD B5 78 02
	eor.l	D7,(0x1234).W		; BF B8 12 34
	eor.l	D7,(0x1234).L		; BF B9 00 00 12 34
	eor.l	D7,*0xFFFFFFF0		; BF B8 FF F0
	eor.l	D7, 0x00010004		; BF B9 00 01 00 04
	eor.l	#3,D2			; 0A 82 00 00 00 03
	eor.l	D0,(0x1234,A0,D1)	; B1 B0 11 20 12 34
	eor.l	D1,([2,A1,A2],4)	; B3 B1 A1 22 00 02 00
	eor.l	D2,([6,A2],D3,8)	; B5 B2 31 26 00 06 00

	.sbttl	Type S_EXG Instructions: EXG

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_EXG:						*
	;*	EXG						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	exg	D0,D1			; C1 41
	exg	D2,A3			; C5 8B
	exg	A4,D3			; C7 8C
	exg	A5,A6			; CB 4E

	.sbttl	Type S_EXT Instructions: EXT

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_EXT:						*
	;*	EXT, EXTB					*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	ext	D0			; 48 80

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

	link.l	A1,#0x1234		; 48 09 00 00 12 34

	.sbttl	Type S_STOP Instructions: STOP

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_STOP:						*
	;*	STOP, RTD					*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	stop	#0x1234			; 4E 72 12 34

	rtd	#0x1234			; 4E 74 12 34

	.sbttl	Type S_SWAP Instructions: SWAP

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_SWAP:						*
	;*	SWAP						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	swap	D0			; 48 40

	swap.w	D0			; 48 40

	.sbttl	Type S_TRAP Instructions: TRAP

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_TRAP:						*
	;*	TRAP						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	trap	#12			; 4E 4C

	.sbttl	Type S_UNLK Instructions: UNLK

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_UNLK:						*
	;*	UNLK						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	unlk	A1			; 4E 59

	.sbttl	Type S_INH Instructions: ILLEGAL, NOP, RESET, RTE, RTR, RTA, TRAPV

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_INH:						*
	;*	ILLEGAL, NOP, RESET, RTE, RTR, RTS, TRAPV	*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	illegal				; 4A FC

	nop				; 4E 71

	reset				; 4E 70

	rte				; 4E 73

	rtr				; 4E 77

	rts				; 4E 75

	trapv				; 4E 76


	.sbttl	Type S_MOVEC Instructions: MOVEC

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_MOVEC:						*
	;*	MOVEC						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	movec	SFC,D0			; 4E 7A 00 00
	movec	DFC,A1			; 4E 7A 90 01
	movec	USP,A3			; 4E 7A B8 00
	movec	VBR,D4			; 4E 7A 48 01
	movec	D0,SFC			; 4E 7B 00 00
	movec	A1,DFC			; 4E 7B 90 01
	movec	A3,USP			; 4E 7B B8 00
	movec	D4,VBR			; 4E 7B 48 01
	movec	CACR,D2			; 4E 7A 20 02
	movec	CAAR,A5			; 4E 7A D8 02
	movec	MSP,D6			; 4E 7A 68 03
	movec	ISP,A7			; 4E 7A F8 04
	movec	D2,CACR			; 4E 7B 20 02
	movec	A5,CAAR			; 4E 7B D8 02
	movec	D6,MSP			; 4E 7B 68 03
	movec	A7,ISP			; 4E 7B F8 04

	movec.l	SFC,D0			; 4E 7A 00 00
	movec.l	DFC,A1			; 4E 7A 90 01
	movec.l	USP,A3			; 4E 7A B8 00
	movec.l	VBR,D4			; 4E 7A 48 01
	movec.l	D0,SFC			; 4E 7B 00 00
	movec.l	A1,DFC			; 4E 7B 90 01
	movec.l	A3,USP			; 4E 7B B8 00
	movec.l	D4,VBR			; 4E 7B 48 01
	movec.l	CACR,D2			; 4E 7A 20 02
	movec.l	CAAR,A5			; 4E 7A D8 02
	movec.l	MSP,D6			; 4E 7A 68 03
	movec.l	ISP,A7			; 4E 7A F8 04
	movec.l	D2,CACR			; 4E 7B 20 02
	movec.l	A5,CAAR			; 4E 7B D8 02
	movec.l	D6,MSP			; 4E 7B 68 03
	movec.l	A7,ISP			; 4E 7B F8 04

	.sbttl	Type S_MOVES Instructions: MOVES

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_MOVES:						*
	;*	MOVES						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	moves	A1,(A2)			; 0E 52 98 00
	moves	D2,(A3)+		; 0E 5B 28 00
	moves	A4,-(A5)		; 0E 65 C8 00
	moves	D6,1(A7)		; 0E 6F 68 00 00 01
	moves	A0,2(A1,D1.W)		; 0E 71 88 00 10 02
	moves	D2,2(A3,D4.L)		; 0E 73 28 00 48 02
	moves	A3,(0x1234).W		; 0E 78 B8 00 12 34
	moves	D3,(0x1234).L		; 0E 79 38 00 00 00 12
	moves	A4,*0xFFFFFFF0		; 0E 78 C8 00 FF F0
	moves	D5, 0x00010004		; 0E 79 58 00 00 01 00
	moves	A5,(0x1234,A0,D1)	; 0E 70 D8 00 11 20 12
	moves	D6,([2,A1,A2],4)	; 0E 71 68 00 A1 22 00
	moves	A6,([6,A2],D3,8)	; 0E 72 E8 00 31 26 00

	moves	(A0),D1			; 0E 50 00 00
	moves	(A2)+,A3		; 0E 5A A0 00
	moves	-(A4),D5		; 0E 64 40 00
	moves	1(A6),D7		; 0E 6E 60 00 00 01
	moves	2(A0,D1.W),A1		; 0E 70 80 00 10 02
	moves	2(A2,D3.L),D4		; 0E 72 20 00 38 02
	moves	(0x1234).W,A3		; 0E 78 80 00 12 34
	moves	D5,(0x1234).L		; 0E 79 58 00 00 00 12
	moves	*0xFFFFFFF0,A4		; 0E 78 80 00 FF F0
	moves	 0x00010004,D6		; 0E 79 10 00 00 01 00
	moves	(0x1234,A5,D7),A6	; 0E 75 D0 00 71 20 12
	moves	([2,A7,A0],4),D0	; 0E 77 70 00 81 22 00
	moves	([6,A1],D2,8),A2	; 0E 71 90 00 21 26 00

	moves.b	A1,(A2)			; 0E 12 98 00
	moves.b	D2,(A3)+		; 0E 1B 28 00
	moves.b	A4,-(A5)		; 0E 25 C8 00
	moves.b	D6,1(A7)		; 0E 2F 68 00 00 01
	moves.b	A0,2(A1,D1.W)		; 0E 31 88 00 10 02
	moves.b	D2,2(A3,D4.L)		; 0E 33 28 00 48 02
	moves.b	A3,(0x1234).W		; 0E 38 B8 00 12 34
	moves.b	D3,(0x1234).L		; 0E 39 38 00 00 00 12
	moves.b	A4,*0xFFFFFFF0		; 0E 38 C8 00 FF F0
	moves.b	D5, 0x00010004		; 0E 39 58 00 00 01 00
	moves.b	A5,(0x1234,A0,D1)	; 0E 30 D8 00 11 20 12
	moves.b	D6,([2,A1,A2],4)	; 0E 31 68 00 A1 22 00
	moves.b	A6,([6,A2],D3,8)	; 0E 32 E8 00 31 26 00

	moves.b	(A0),D1			; 0E 10 00 00
	moves.b	(A2)+,A3		; 0E 1A A0 00
	moves.b	-(A4),D5		; 0E 24 40 00
	moves.b	1(A6),D7		; 0E 2E 60 00 00 01
	moves.b	2(A0,D1.W),A1		; 0E 30 80 00 10 02
	moves.b	2(A2,D3.L),D4		; 0E 32 20 00 38 02
	moves.b	(0x1234).W,A3		; 0E 38 80 00 12 34
	moves.b	D5,(0x1234).L		; 0E 39 58 00 00 00 12
	moves.b	*0xFFFFFFF0,A4		; 0E 38 80 00 FF F0
	moves.b	 0x00010004,D6		; 0E 39 10 00 00 01 00
	moves.b	(0x1234,A5,D7),A6	; 0E 35 D0 00 71 20 12
	moves.b	([2,A7,A0],4),D0	; 0E 37 70 00 81 22 00
	moves.b	([6,A1],D2,8),A2	; 0E 31 90 00 21 26 00

	moves.w	A1,(A2)			; 0E 52 98 00
	moves.w	D2,(A3)+		; 0E 5B 28 00
	moves.w	A4,-(A5)		; 0E 65 C8 00
	moves.w	D6,1(A7)		; 0E 6F 68 00 00 01
	moves.w	A0,2(A1,D1.W)		; 0E 71 88 00 10 02
	moves.w	D2,2(A3,D4.L)		; 0E 73 28 00 48 02
	moves.w	A3,(0x1234).W		; 0E 78 B8 00 12 34
	moves.w	D3,(0x1234).L		; 0E 79 38 00 00 00 12
	moves.w	A4,*0xFFFFFFF0		; 0E 78 C8 00 FF F0
	moves.w	D5, 0x00010004		; 0E 79 58 00 00 01 00
	moves.w	A5,(0x1234,A0,D1)	; 0E 70 D8 00 11 20 12
	moves.w	D6,([2,A1,A2],4)	; 0E 71 68 00 A1 22 00
	moves.w	A6,([6,A2],D3,8)	; 0E 72 E8 00 31 26 00

	moves.w	(A0),D1			; 0E 50 00 00
	moves.w	(A2)+,A3		; 0E 5A A0 00
	moves.w	-(A4),D5		; 0E 64 40 00
	moves.w	1(A6),D7		; 0E 6E 60 00 00 01
	moves.w	2(A0,D1.W),A1		; 0E 70 80 00 10 02
	moves.w	2(A2,D3.L),D4		; 0E 72 20 00 38 02
	moves.w	(0x1234).W,A3		; 0E 78 80 00 12 34
	moves.w	D5,(0x1234).L		; 0E 79 58 00 00 00 12
	moves.w	*0xFFFFFFF0,A4		; 0E 78 80 00 FF F0
	moves.w	 0x00010004,D6		; 0E 79 10 00 00 01 00
	moves.w	(0x1234,A5,D7),A6	; 0E 75 D0 00 71 20 12
	moves.w	([2,A7,A0],4),D0	; 0E 77 70 00 81 22 00
	moves.w	([6,A1],D2,8),A2	; 0E 71 90 00 21 26 00

	moves.l	A1,(A2)			; 0E 92 98 00
	moves.l	D2,(A3)+		; 0E 9B 28 00
	moves.l	A4,-(A5)		; 0E A5 C8 00
	moves.l	D6,1(A7)		; 0E AF 68 00 00 01
	moves.l	A0,2(A1,D1.W)		; 0E B1 88 00 10 02
	moves.l	D2,2(A3,D4.L)		; 0E B3 28 00 48 02
	moves.l	A3,(0x1234).W		; 0E B8 B8 00 12 34
	moves.l	D3,(0x1234).L		; 0E B9 38 00 00 00 12
	moves.l	A4,*0xFFFFFFF0		; 0E B8 C8 00 FF F0
	moves.l	D5, 0x00010004		; 0E B9 58 00 00 01 00
	moves.l	A5,(0x1234,A0,D1)	; 0E B0 D8 00 11 20 12
	moves.l	D6,([2,A1,A2],4)	; 0E B1 68 00 A1 22 00
	moves.l	A6,([6,A2],D3,8)	; 0E B2 E8 00 31 26 00

	moves.l	(A0),D1			; 0E 90 00 00
	moves.l	(A2)+,A3		; 0E 9A A0 00
	moves.l	-(A4),D5		; 0E A4 40 00
	moves.l	1(A6),D7		; 0E AE 60 00 00 01
	moves.l	2(A0,D1.W),A1		; 0E B0 80 00 10 02
	moves.l	2(A2,D3.L),D4		; 0E B2 20 00 38 02
	moves.l	(0x1234).W,A3		; 0E B8 80 00 12 34
	moves.l	D5,(0x1234).L		; 0E B9 58 00 00 00 12
	moves.l	*0xFFFFFFF0,A4		; 0E B8 80 00 FF F0
	moves.l	 0x00010004,D6		; 0E B9 10 00 00 01 00
	moves.l	(0x1234,A5,D7),A6	; 0E B5 D0 00 71 20 12
	moves.l	([2,A7,A0],4),D0	; 0E B7 70 00 81 22 00
	moves.l	([6,A1],D2,8),A2	; 0E B1 90 00 21 26 00

	.sbttl	Type S_BF Instructions: BFCHG, BFCLR, BFEXTS, BFEXTU, BFFFO, BFINS, BFSET, BFTST

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_BF:						*
	;*	BFCHG, BFCLR, BFEXTS, BFEXTU,			*
	;*	BFFFO, BFINS, BFSET, BFTST			*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	bfchg	D0,{31:1}		; EA C0 07 C1
	bfchg	(A1),{29:3}		; EA D1 07 43
	bfchg	1(A4),{27:5}		; EA EC 06 C5 00 01
	bfchg	2(A5,D7.W),{25:7}	; EA F5 06 47 70 02
	bfchg	2(A5,D7.L),{23:9}	; EA F5 05 C9 78 02
	bfchg	(0x1234).W,{21:11}	; EA F8 05 4B 12 34
	bfchg	(0x1234).L,{19:13}	; EA F9 04 CD 00 00 12
	bfchg	*0xFFFFFFF0,{17:15}	; EA F8 04 4F FF F0
	bfchg	 0x00010004,{15:17}	; EA F9 03 D1 00 01 00
	bfchg	(0x1234,A0,D1),{13:19}	; EA F0 03 53 11 20 12
	bfchg	([2,A1,A2],4),{11:21}	; EA F1 02 D5 A1 22 00
	bfchg	([6,A2],D3,8),{9:23}	; EA F2 02 57 31 26 00

	bfclr	D0,{31:1}		; EC C0 07 C1
	bfclr	(A1),{29:3}		; EC D1 07 43
	bfclr	1(A4),{27:5}		; EC EC 06 C5 00 01
	bfclr	2(A5,D7.W),{25:7}	; EC F5 06 47 70 02
	bfclr	2(A5,D7.L),{23:9}	; EC F5 05 C9 78 02
	bfclr	(0x1234).W,{21:11}	; EC F8 05 4B 12 34
	bfclr	(0x1234).L,{19:13}	; EC F9 04 CD 00 00 12
	bfclr	*0xFFFFFFF0,{17:15}	; EC F8 04 4F FF F0
	bfclr	 0x00010004,{15:17}	; EC F9 03 D1 00 01 00
	bfclr	(0x1234,A0,D1),{13:19}	; EC F0 03 53 11 20 12
	bfclr	([2,A1,A2],4),{11:21}	; EC F1 02 D5 A1 22 00
	bfclr	([6,A2],D3,8),{9:23}	; EC F2 02 57 31 26 00

	bfset	D0,{31:1}		; EE C0 07 C1
	bfset	(A1),{29:3}		; EE D1 07 43
	bfset	1(A4),{27:5}		; EE EC 06 C5 00 01
	bfset	2(A5,D7.W),{25:7}	; EE F5 06 47 70 02
	bfset	2(A5,D7.L),{23:9}	; EE F5 05 C9 78 02
	bfset	(0x1234).W,{21:11}	; EE F8 05 4B 12 34
	bfset	(0x1234).L,{19:13}	; EE F9 04 CD 00 00 12
	bfset	*0xFFFFFFF0,{17:15}	; EE F8 04 4F FF F0
	bfset	 0x00010004,{15:17}	; EE F9 03 D1 00 01 00
	bfset	(0x1234,A0,D1),{13:19}	; EE F0 03 53 11 20 12
	bfset	([2,A1,A2],4),{11:21}	; EE F1 02 D5 A1 22 00
	bfset	([6,A2],D3,8),{9:23}	; EE F2 02 57 31 26 00

	bftst	D0,{31:1}		; E8 C0 07 C1
	bftst	(A1),{29:3}		; E8 D1 07 43
	bftst	1(A4),{27:5}		; E8 EC 06 C5 00 01
	bftst	2(A5,D7.W),{25:7}	; E8 F5 06 47 70 02
	bftst	2(A5,D7.L),{23:9}	; E8 F5 05 C9 78 02
	bftst	(0x1234).W,{21:11}	; E8 F8 05 4B 12 34
	bftst	(0x1234).L,{19:13}	; E8 F9 04 CD 00 00 12
	bftst	*0xFFFFFFF0,{17:15}	; E8 F8 04 4F FF F0
	bftst	 0x00010004,{15:17}	; E8 F9 03 D1 00 01 00
	bftst	(0x1234,A0,D1),{13:19}	; E8 F0 03 53 11 20 12
	bftst	([2,A1,A2],4),{11:21}	; E8 F1 02 D5 A1 22 00
	bftst	([6,A2],D3,8),{9:23}	; E8 F2 02 57 31 26 00
	bftst	5(PC),{5:27}		; E8 FA 01 5B 00 01
	bftst	6(PC,A7.W),{3:29}	; E8 FB 00 DD F0 02
	bftst	6(PC,A7.L),{1:31}	; E8 FB 00 5F F8 02
	bftst	(0x1234,PC,D1),{5:27}	; E8 FB 01 5B 11 20 12
	bftst	([2,PC,A2],4),{3:29}	; E8 FB 00 DD A1 22 FF
	bftst	([6,PC],D3,8),{1:31}	; E8 FB 00 5F 31 26 00

	bfexts	D0,{31:1},D0		; EB C0 07 C1
	bfexts	(A1),{29:3},D1		; EB D1 17 43
	bfexts	1(A4),{27:5},D2		; EB EC 26 C5 00 01
	bfexts	2(A5,D7.W),{25:7},D3	; EB F5 36 47 70 02
	bfexts	2(A5,D7.L),{23:9},D4	; EB F5 45 C9 78 02
	bfexts	(0x1234).W,{21:11},D5	; EB F8 55 4B 12 34
	bfexts	(0x1234).L,{19:13},D6	; EB F9 64 CD 00 00 12
	bfexts	*0xFFFFFFF0,{17:15},D7	; EB F8 74 4F FF F0
	bfexts	 0x00010004,{15:17},D0	; EB F9 03 D1 00 01 00
	bfexts	(0x1234,A0,D1),{13:19},D1	; EB F0 13 53 11 20 12
	bfexts	([2,A1,A2],4),{11:21},D2	; EB F1 22 D5 A1 22 00
	bfexts	([6,A2],D3,8),{9:23},D3	; EB F2 32 57 31 26 00
	bfexts	5(PC),{5:27},D4		; EB FA 41 5B 00 01
	bfexts	6(PC,A7.W),{3:29},D5	; EB FB 50 DD F0 02
	bfexts	6(PC,A7.L),{1:31},D6	; EB FB 60 5F F8 02
	bfexts	(0x1234,PC,D1),{5:27},D7	; EB FB 71 5B 11 20 12
	bfexts	([2,PC,A2],4),{3:29},D0	; EB FB 00 DD A1 22 FF
	bfexts	([6,PC],D3,8),{1:31},D1	; EB FB 10 5F 31 26 00

	bfextu	D0,{31:1},D0		; E9 C0 07 C1
	bfextu	(A1),{29:3},D1		; E9 D1 17 43
	bfextu	1(A4),{27:5},D2		; E9 EC 26 C5 00 01
	bfextu	2(A5,D7.W),{25:7},D3	; E9 F5 36 47 70 02
	bfextu	2(A5,D7.L),{23:9},D4	; E9 F5 45 C9 78 02
	bfextu	(0x1234).W,{21:11},D5	; E9 F8 55 4B 12 34
	bfextu	(0x1234).L,{19:13},D6	; E9 F9 64 CD 00 00 12
	bfextu	*0xFFFFFFF0,{17:15},D7	; E9 F8 74 4F FF F0
	bfextu	 0x00010004,{15:17},D0	; E9 F9 03 D1 00 01 00
	bfextu	(0x1234,A0,D1),{13:19},D1	; E9 F0 13 53 11 20 12
	bfextu	([2,A1,A2],4),{11:21},D2	; E9 F1 22 D5 A1 22 00
	bfextu	([6,A2],D3,8),{9:23},D3	; E9 F2 32 57 31 26 00
	bfextu	5(PC),{5:27},D4		; E9 FA 41 5B 00 01
	bfextu	6(PC,A7.W),{3:29},D5	; E9 FB 50 DD F0 02
	bfextu	6(PC,A7.L),{1:31},D6	; E9 FB 60 5F F8 02
	bfextu	(0x1234,PC,D1),{5:27},D7	; E9 FB 71 5B 11 20 12
	bfextu	([2,PC,A2],4),{3:29},D0	; E9 FB 00 DD A1 22 FF
	bfextu	([6,PC],D3,8),{1:31},D1	; E9 FB 10 5F 31 26 00

	bfffo	D0,{31:1},D0		; ED C0 07 C1
	bfffo	(A1),{29:3},D1		; ED D1 17 43
	bfffo	1(A4),{27:5},D2		; ED EC 26 C5 00 01
	bfffo	2(A5,D7.W),{25:7},D3	; ED F5 36 47 70 02
	bfffo	2(A5,D7.L),{23:9},D4	; ED F5 45 C9 78 02
	bfffo	(0x1234).W,{21:11},D5	; ED F8 55 4B 12 34
	bfffo	(0x1234).L,{19:13},D6	; ED F9 64 CD 00 00 12
	bfffo	*0xFFFFFFF0,{17:15},D7	; ED F8 74 4F FF F0
	bfffo	 0x00010004,{15:17},D0	; ED F9 03 D1 00 01 00
	bfffo	(0x1234,A0,D1),{13:19},D1	; ED F0 13 53 11 20 12
	bfffo	([2,A1,A2],4),{11:21},D2	; ED F1 22 D5 A1 22 00
	bfffo	([6,A2],D3,8),{9:23},D3	; ED F2 32 57 31 26 00
	bfffo	5(PC),{5:27},D4		; ED FA 41 5B 00 01
	bfffo	6(PC,A7.W),{3:29},D5	; ED FB 50 DD F0 02
	bfffo	6(PC,A7.L),{1:31},D6	; ED FB 60 5F F8 02
	bfffo	(0x1234,PC,D1),{5:27},D7	; ED FB 71 5B 11 20 12
	bfffo	([2,PC,A2],4),{3:29},D0	; ED FB 00 DD A1 22 FF
	bfffo	([6,PC],D3,8),{1:31},D1	; ED FB 10 5F 31 26 00

	bfins	D1,D0,{31:1}		; EF C0 17 C1
	bfins	D2,(A1),{29:3}		; EF D1 27 43
	bfins	D3,1(A4),{27:5}		; EF EC 36 C5 00 01
	bfins	D4,2(A5,D7.W),{25:7}	; EF F5 46 47 70 02
	bfins	D5,2(A5,D7.L),{23:9}	; EF F5 55 C9 78 02
	bfins	D6,(0x1234).W,{21:11}	; EF F8 65 4B 12 34
	bfins	D7,(0x1234).L,{19:13}	; EF F9 74 CD 00 00 12
	bfins	D0,*0xFFFFFFF0,{17:15}	; EF F8 04 4F FF F0
	bfins	D1, 0x00010004,{15:17}	; EF F9 13 D1 00 01 00
	bfins	D2,(0x1234,A0,D1),{13:19}	; EF F0 23 53 11 20 12
	bfins	D3,([2,A1,A2],4),{11:21}	; EF F1 32 D5 A1 22 00
	bfins	D4,([6,A2],D3,8),{9:23}	; EF F2 42 57 31 26 00

	.sbttl	Type S_BKPT Instructions: BKPT

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_BKPT:						*
	;*	BKPT						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	bkpt	#5			; 48 4D

	.sbttl	Type S_CALLM Instructions: CALLM

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_CALLM:						*
	;*	CALLM						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	callm	#1,(A1)			; 06 D1 00 01
	callm	#2,1(A4)		; 06 EC 00 02 00 01
	callm	#3,2(A5,D7.W)		; 06 F5 00 03 70 02
	callm	#4,2(A5,D7.L)		; 06 F5 00 04 78 02
	callm	#5,(0x1234).W		; 06 F8 00 05 12 34
	callm	#6,(0x1234).L		; 06 F9 00 06 00 00 12
	callm	#7,*0xFFFFFFF0		; 06 F8 00 07 FF F0
	callm	#8, 0x00010004		; 06 F9 00 08 00 01 00
	callm	#9,(0x1234,A0,D1)	; 06 F0 00 09 11 20 12
	callm	#10,([2,A1,A2],4)	; 06 F1 00 0A A1 22 00
	callm	#11,([6,A2],D3,8)	; 06 F2 00 0B 31 26 00
	callm	#12,(PC)		; 06 FA 00 0C FF FE
	callm	#13,6(PC,A7.W)		; 06 FB 00 0D F0 04
	callm	#14,6(PC,A7.L)		; 06 FB 00 0E F8 04
	callm	#15,(0x1234,PC,D1)	; 06 FB 00 0F 11 20 12
	callm	#16,([2,PC,A2],4)	; 06 FB 00 10 A1 22 00
	callm	#17,([6,PC],D3,8)	; 06 FB 00 11 31 26 00

	.sbttl	Type S_CAS Instructions: CAS

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_CAS:						*
	;*	CAS						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	cas	D0,D1,(A0)		; 0C D0 00 40
	cas	D2,D3,(A1)+		; 0C D9 00 C2
	cas	D4,D5,-(A2)		; 0C E2 01 44
	cas	D6,D7,(2,A3)		; 0C EB 01 C6 00 02
	cas	D4,D5,2(A5,D7.W)	; 0C F5 01 44 70 02
	cas	D6,D7,2(A5,D7.L)	; 0C F5 01 C6 78 02
	cas	D0,D1,(0x1234).W	; 0C F8 00 40 12 34
	cas	D2,D3,(0x1234).L	; 0C F9 00 C2 00 00 12
	cas	D0,D1,*0xFFFFFFF0	; 0C F8 00 40 FF F0
	cas	D2,D3, 0x00010004	; 0C F9 00 C2 00 01 00
	cas	D4,D5,(0x1234,A0,D1)	; 0C F0 01 44 11 20 12
	cas	D6,D7,([2,A1,A2],4)	; 0C F1 01 C6 A1 22 00
	cas	D0,D1,([6,A2],D3,8)	; 0C F2 00 40 31 26 00

	cas.b	D0,D1,(A0)		; 0A D0 00 40
	cas.b	D2,D3,(A1)+		; 0A D9 00 C2
	cas.b	D4,D5,-(A2)		; 0A E2 01 44
	cas.b	D6,D7,(2,A3)		; 0A EB 01 C6 00 02
	cas.b	D4,D5,2(A5,D7.W)	; 0A F5 01 44 70 02
	cas.b	D6,D7,2(A5,D7.L)	; 0A F5 01 C6 78 02
	cas.b	D0,D1,(0x1234).W	; 0A F8 00 40 12 34
	cas.b	D2,D3,(0x1234).L	; 0A F9 00 C2 00 00 12
	cas.b	D0,D1,*0xFFFFFFF0	; 0A F8 00 40 FF F0
	cas.b	D2,D3, 0x00010004	; 0A F9 00 C2 00 01 00
	cas.b	D4,D5,(0x1234,A0,D1)	; 0A F0 01 44 11 20 12
	cas.b	D6,D7,([2,A1,A2],4)	; 0A F1 01 C6 A1 22 00
	cas.b	D0,D1,([6,A2],D3,8)	; 0A F2 00 40 31 26 00

	cas.w	D0,D1,(A0)		; 0C D0 00 40
	cas.w	D2,D3,(A1)+		; 0C D9 00 C2
	cas.w	D4,D5,-(A2)		; 0C E2 01 44
	cas.w	D6,D7,(2,A3)		; 0C EB 01 C6 00 02
	cas.w	D4,D5,2(A5,D7.W)	; 0C F5 01 44 70 02
	cas.w	D6,D7,2(A5,D7.L)	; 0C F5 01 C6 78 02
	cas.w	D0,D1,(0x1234).W	; 0C F8 00 40 12 34
	cas.w	D2,D3,(0x1234).L	; 0C F9 00 C2 00 00 12
	cas.w	D0,D1,*0xFFFFFFF0	; 0C F8 00 40 FF F0
	cas.w	D2,D3, 0x00010004	; 0C F9 00 C2 00 01 00
	cas.w	D4,D5,(0x1234,A0,D1)	; 0C F0 01 44 11 20 12
	cas.w	D6,D7,([2,A1,A2],4)	; 0C F1 01 C6 A1 22 00
	cas.w	D0,D1,([6,A2],D3,8)	; 0C F2 00 40 31 26 00

	cas.l	D0,D1,(A0)		; 0E D0 00 40
	cas.l	D2,D3,(A1)+		; 0E D9 00 C2
	cas.l	D4,D5,-(A2)		; 0E E2 01 44
	cas.l	D6,D7,(2,A3)		; 0E EB 01 C6 00 02
	cas.l	D4,D5,2(A5,D7.W)	; 0E F5 01 44 70 02
	cas.l	D6,D7,2(A5,D7.L)	; 0E F5 01 C6 78 02
	cas.l	D0,D1,(0x1234).W	; 0E F8 00 40 12 34
	cas.l	D2,D3,(0x1234).L	; 0E F9 00 C2 00 00 12
	cas.l	D0,D1,*0xFFFFFFF0	; 0E F8 00 40 FF F0
	cas.l	D2,D3, 0x00010004	; 0E F9 00 C2 00 01 00
	cas.l	D4,D5,(0x1234,A0,D1)	; 0E F0 01 44 11 20 12
	cas.l	D6,D7,([2,A1,A2],4)	; 0E F1 01 C6 A1 22 00
	cas.l	D0,D1,([6,A2],D3,8)	; 0E F2 00 40 31 26 00

	.sbttl	Type S_CAS2 Instructions: CAS2

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_CAS2:						*
	;*	CAS2						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	cas2	D0:D1,D2:D3,(A0):(A1)	; 0C FC 80 80 90 C1

	cas2.w	D0:D1,D2:D3,(A0):(A1)	; 0C FC 80 80 90 C1

	cas2.l	D0:D1,D2:D3,(A0):(A1)	; 0E FC 80 80 90 C1

	.sbttl	Type S_CHK2 Instructions: CHK2, CMP2

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_CHK2:						*
	;*  S_CMP2:						*
	;*	CHK2, CMP2					*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	chk2	(A1),A2			; 02 D1 A8 00
	chk2	1(A4),D5		; 02 EC 58 00 00 01
	chk2	2(A5,D7.W),A6		; 02 F5 E8 00 70 02
	chk2	2(A5,D7.L),D6		; 02 F5 68 00 78 02
	chk2	(0x1234).W,A7		; 02 F8 F8 00 12 34
	chk2	(0x1234).L,D7		; 02 F9 78 00 00 00 12
	chk2	*0xFFFFFFF0,A7		; 02 F8 F8 00 FF F0
	chk2	 0x00010004,D7		; 02 F9 78 00 00 01 00
	chk2	(0x1234,A0,D1),A0	; 02 F0 88 00 11 20 12
	chk2	([2,A1,A2],4),A1	; 02 F1 98 00 A1 22 00
	chk2	([6,A2],D3,8),D2	; 02 F2 28 00 31 26 00
	chk2	(PC),A0			; 02 FA 88 00 FF FC
	chk2	6(PC,A7.W),D1		; 02 FB 18 00 F0 02
	chk2	6(PC,A7.L),A1		; 02 FB 98 00 F8 02
	chk2	(0x1234,PC,D1),D2	; 02 FB 28 00 11 20 12
	chk2	([2,PC,A2],4),A3	; 02 FB B8 00 A1 22 FF
	chk2	([6,PC],D3,8),D4	; 02 FB 48 00 31 26 00

	chk2.b	(A1),A2			; 00 D1 A8 00
	chk2.b	1(A4),D5		; 00 EC 58 00 00 01
	chk2.b	2(A5,D7.W),A6		; 00 F5 E8 00 70 02
	chk2.b	2(A5,D7.L),D6		; 00 F5 68 00 78 02
	chk2.b	(0x1234).W,A7		; 00 F8 F8 00 12 34
	chk2.b	(0x1234).L,D7		; 00 F9 78 00 00 00 12
	chk2.b	*0xFFFFFFF0,A7		; 00 F8 F8 00 FF F0
	chk2.b	 0x00010004,D7		; 00 F9 78 00 00 01 00
	chk2.b	(0x1234,A0,D1),A0	; 00 F0 88 00 11 20 12
	chk2.b	([2,A1,A2],4),A1	; 00 F1 98 00 A1 22 00
	chk2.b	([6,A2],D3,8),D2	; 00 F2 28 00 31 26 00
	chk2.b	(PC),A0			; 00 FA 88 00 FF FC
	chk2.b	6(PC,A7.W),D1		; 00 FB 18 00 F0 02
	chk2.b	6(PC,A7.L),A1		; 00 FB 98 00 F8 02
	chk2.b	(0x1234,PC,D1),D2	; 00 FB 28 00 11 20 12
	chk2.b	([2,PC,A2],4),A3	; 00 FB B8 00 A1 22 FF
	chk2.b	([6,PC],D3,8),D4	; 00 FB 48 00 31 26 00

	chk2.w	(A1),A2			; 02 D1 A8 00
	chk2.w	1(A4),D5		; 02 EC 58 00 00 01
	chk2.w	2(A5,D7.W),A6		; 02 F5 E8 00 70 02
	chk2.w	2(A5,D7.L),D6		; 02 F5 68 00 78 02
	chk2.w	(0x1234).W,A7		; 02 F8 F8 00 12 34
	chk2.w	(0x1234).L,D7		; 02 F9 78 00 00 00 12
	chk2.w	*0xFFFFFFF0,A7		; 02 F8 F8 00 FF F0
	chk2.w	 0x00010004,D7		; 02 F9 78 00 00 01 00
	chk2.w	(0x1234,A0,D1),A0	; 02 F0 88 00 11 20 12
	chk2.w	([2,A1,A2],4),A1	; 02 F1 98 00 A1 22 00
	chk2.w	([6,A2],D3,8),D2	; 02 F2 28 00 31 26 00
	chk2.w	(PC),A0			; 02 FA 88 00 FF FC
	chk2.w	6(PC,A7.W),D1		; 02 FB 18 00 F0 02
	chk2.w	6(PC,A7.L),A1		; 02 FB 98 00 F8 02
	chk2.w	(0x1234,PC,D1),D2	; 02 FB 28 00 11 20 12
	chk2.w	([2,PC,A2],4),A3	; 02 FB B8 00 A1 22 FF
	chk2.w	([6,PC],D3,8),D4	; 02 FB 48 00 31 26 00

	chk2.l	(A1),A2			; 04 D1 A8 00
	chk2.l	1(A4),D5		; 04 EC 58 00 00 01
	chk2.l	2(A5,D7.W),A6		; 04 F5 E8 00 70 02
	chk2.l	2(A5,D7.L),D6		; 04 F5 68 00 78 02
	chk2.l	(0x1234).W,A7		; 04 F8 F8 00 12 34
	chk2.l	(0x1234).L,D7		; 04 F9 78 00 00 00 12
	chk2.l	*0xFFFFFFF0,A7		; 04 F8 F8 00 FF F0
	chk2.l	 0x00010004,D7		; 04 F9 78 00 00 01 00
	chk2.l	(0x1234,A0,D1),A0	; 04 F0 88 00 11 20 12
	chk2.l	([2,A1,A2],4),A1	; 04 F1 98 00 A1 22 00
	chk2.l	([6,A2],D3,8),D2	; 04 F2 28 00 31 26 00
	chk2.l	(PC),A0			; 04 FA 88 00 FF FC
	chk2.l	6(PC,A7.W),D1		; 04 FB 18 00 F0 02
	chk2.l	6(PC,A7.L),A1		; 04 FB 98 00 F8 02
	chk2.l	(0x1234,PC,D1),D2	; 04 FB 28 00 11 20 12
	chk2.l	([2,PC,A2],4),A3	; 04 FB B8 00 A1 22 FF
	chk2.l	([6,PC],D3,8),D4	; 04 FB 48 00 31 26 00

	cmp2	(A1),A2			; 02 D1 A0 00
	cmp2	1(A4),D5		; 02 EC 50 00 00 01
	cmp2	2(A5,D7.W),A6		; 02 F5 E0 00 70 02
	cmp2	2(A5,D7.L),D6		; 02 F5 60 00 78 02
	cmp2	(0x1234).W,A7		; 02 F8 F0 00 12 34
	cmp2	(0x1234).L,D7		; 02 F9 70 00 00 00 12
	cmp2	*0xFFFFFFF0,A7		; 02 F8 F0 00 FF F0
	cmp2	 0x00010004,D7		; 02 F9 70 00 00 01 00
	cmp2	(0x1234,A0,D1),A0	; 02 F0 80 00 11 20 12
	cmp2	([2,A1,A2],4),A1	; 02 F1 90 00 A1 22 00
	cmp2	([6,A2],D3,8),D2	; 02 F2 20 00 31 26 00
	cmp2	(PC),A0			; 02 FA 80 00 FF FC
	cmp2	6(PC,A7.W),D1		; 02 FB 10 00 F0 02
	cmp2	6(PC,A7.L),A1		; 02 FB 90 00 F8 02
	cmp2	(0x1234,PC,D1),D2	; 02 FB 20 00 11 20 12
	cmp2	([2,PC,A2],4),A3	; 02 FB B0 00 A1 22 FF
	cmp2	([6,PC],D3,8),D4	; 02 FB 40 00 31 26 00

	cmp2.b	(A1),A2			; 00 D1 A0 00
	cmp2.b	1(A4),D5		; 00 EC 50 00 00 01
	cmp2.b	2(A5,D7.W),A6		; 00 F5 E0 00 70 02
	cmp2.b	2(A5,D7.L),D6		; 00 F5 60 00 78 02
	cmp2.b	(0x1234).W,A7		; 00 F8 F0 00 12 34
	cmp2.b	(0x1234).L,D7		; 00 F9 70 00 00 00 12
	cmp2.b	*0xFFFFFFF0,A7		; 00 F8 F0 00 FF F0
	cmp2.b	 0x00010004,D7		; 00 F9 70 00 00 01 00
	cmp2.b	(0x1234,A0,D1),A0	; 00 F0 80 00 11 20 12
	cmp2.b	([2,A1,A2],4),A1	; 00 F1 90 00 A1 22 00
	cmp2.b	([6,A2],D3,8),D2	; 00 F2 20 00 31 26 00
	cmp2.b	(PC),A0			; 00 FA 80 00 FF FC
	cmp2.b	6(PC,A7.W),D1		; 00 FB 10 00 F0 02
	cmp2.b	6(PC,A7.L),A1		; 00 FB 90 00 F8 02
	cmp2.b	(0x1234,PC,D1),D2	; 00 FB 20 00 11 20 12
	cmp2.b	([2,PC,A2],4),A3	; 00 FB B0 00 A1 22 FF
	cmp2.b	([6,PC],D3,8),D4	; 00 FB 40 00 31 26 00

	cmp2.w	(A1),A2			; 02 D1 A0 00
	cmp2.w	1(A4),D5		; 02 EC 50 00 00 01
	cmp2.w	2(A5,D7.W),A6		; 02 F5 E0 00 70 02
	cmp2.w	2(A5,D7.L),D6		; 02 F5 60 00 78 02
	cmp2.w	(0x1234).W,A7		; 02 F8 F0 00 12 34
	cmp2.w	(0x1234).L,D7		; 02 F9 70 00 00 00 12
	cmp2.w	*0xFFFFFFF0,A7		; 02 F8 F0 00 FF F0
	cmp2.w	 0x00010004,D7		; 02 F9 70 00 00 01 00
	cmp2.w	(0x1234,A0,D1),A0	; 02 F0 80 00 11 20 12
	cmp2.w	([2,A1,A2],4),A1	; 02 F1 90 00 A1 22 00
	cmp2.w	([6,A2],D3,8),D2	; 02 F2 20 00 31 26 00
	cmp2.w	(PC),A0			; 02 FA 80 00 FF FC
	cmp2.w	6(PC,A7.W),D1		; 02 FB 10 00 F0 02
	cmp2.w	6(PC,A7.L),A1		; 02 FB 90 00 F8 02
	cmp2.w	(0x1234,PC,D1),D2	; 02 FB 20 00 11 20 12
	cmp2.w	([2,PC,A2],4),A3	; 02 FB B0 00 A1 22 FF
	cmp2.w	([6,PC],D3,8),D4	; 02 FB 40 00 31 26 00

	cmp2.l	(A1),A2			; 04 D1 A0 00
	cmp2.l	1(A4),D5		; 04 EC 50 00 00 01
	cmp2.l	2(A5,D7.W),A6		; 04 F5 E0 00 70 02
	cmp2.l	2(A5,D7.L),D6		; 04 F5 60 00 78 02
	cmp2.l	(0x1234).W,A7		; 04 F8 F0 00 12 34
	cmp2.l	(0x1234).L,D7		; 04 F9 70 00 00 00 12
	cmp2.l	*0xFFFFFFF0,A7		; 04 F8 F0 00 FF F0
	cmp2.l	 0x00010004,D7		; 04 F9 70 00 00 01 00
	cmp2.l	(0x1234,A0,D1),A0	; 04 F0 80 00 11 20 12
	cmp2.l	([2,A1,A2],4),A1	; 04 F1 90 00 A1 22 00
	cmp2.l	([6,A2],D3,8),D2	; 04 F2 20 00 31 26 00
	cmp2.l	(PC),A0			; 04 FA 80 00 FF FC
	cmp2.l	6(PC,A7.W),D1		; 04 FB 10 00 F0 02
	cmp2.l	6(PC,A7.L),A1		; 04 FB 90 00 F8 02
	cmp2.l	(0x1234,PC,D1),D2	; 04 FB 20 00 11 20 12
	cmp2.l	([2,PC,A2],4),A3	; 04 FB B0 00 A1 22 FF
	cmp2.l	([6,PC],D3,8),D4	; 04 FB 40 00 31 26 00

	.sbttl	Type S_PKUK Instructions: PACK, UNPK

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_PKUK:						*
	;*	PACK, UNPK					*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	pack	-(A0),-(A1),#5		; 83 48 00 05
	pack	D2,D3,#6		; 87 42 00 06

	unpk	-(A0),-(A1),#5		; 83 88 00 05
	unpk	D2,D3,#6		; 87 82 00 06

	.sbttl	Type S_RTM Instructions: RTM

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_RTM:						*
	;*	RTM						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	rtm	D1			; 06 C1
	rtm	A1			; 06 C9

	.sbttl	Type S_TRPC Instructions: TRAPcc

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  S_TRPC:						*
	;*	TRAPT,  TRAPF,  TRAPHI, TRAPLS			*
	;*	TRAPCC, TRAPCS, TRAPNE, TRAPEQ			*
	;*	TRAPVC, TRAPVS, TRAPPL, TRAPMI			*
	;*	TRAPGE, TRAPLT, TRAPGT, TRAPLE			*
	;*	TRAPHS, TRAPLO					*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	trapt				; 50 FC
	trapt	#0x000F			; 50 FA 00 0F
	trapt	#0x000F0000		; 50 FB 00 0F 00 00

	trapt.w	#15			; 50 FA 00 0F

	trapt.l	#15			; 50 FB 00 00 00 0F

	trapf				; 51 FC
	trapf	#0x000F			; 51 FA 00 0F
	trapf	#0x000F0000		; 51 FB 00 0F 00 00

	trapf.w	#15			; 51 FA 00 0F

	trapf.l	#15			; 51 FB 00 00 00 0F

	traphi				; 52 FC
	traphi	#0x000F			; 52 FA 00 0F
	traphi	#0x000F0000		; 52 FB 00 0F 00 00

	traphi.w	#15		; 52 FA 00 0F

	traphi.l	#15		; 52 FB 00 00 00 0F

	trapls				; 53 FC
	trapls	#0x000F			; 53 FA 00 0F
	trapls	#0x000F0000		; 53 FB 00 0F 00 00

	trapls.w	#15		; 53 FA 00 0F

	trapls.l	#15		; 53 FB 00 00 00 0F

	trapcc				; 54 FC
	trapcc	#0x000F			; 54 FA 00 0F
	trapcc	#0x000F0000		; 54 FB 00 0F 00 00

	trapcc.w	#15		; 54 FA 00 0F

	trapcc.l	#15		; 54 FB 00 00 00 0F

	trapcs				; 55 FC
	trapcs	#0x000F			; 55 FA 00 0F
	trapcs	#0x000F0000		; 55 FB 00 0F 00 00

	trapcs.w	#15		; 55 FA 00 0F

	trapcs.l	#15		; 55 FB 00 00 00 0F

	trapne				; 56 FC
	trapne	#0x000F			; 56 FA 00 0F
	trapne	#0x000F0000		; 56 FB 00 0F 00 00

	trapne.w	#15		; 56 FA 00 0F

	trapne.l	#15		; 56 FB 00 00 00 0F

	trapeq				; 57 FC
	trapeq	#0x000F			; 57 FA 00 0F
	trapeq	#0x000F0000		; 57 FB 00 0F 00 00

	trapeq.w	#15		; 57 FA 00 0F

	trapeq.l	#15		; 57 FB 00 00 00 0F

	trapvc				; 58 FC
	trapvc	#0x000F			; 58 FA 00 0F
	trapvc	#0x000F0000		; 58 FB 00 0F 00 00

	trapvc.w	#15		; 58 FA 00 0F

	trapvc.l	#15		; 58 FB 00 00 00 0F

	trapvs				; 59 FC
	trapvs	#0x000F			; 59 FA 00 0F
	trapvs	#0x000F0000		; 59 FB 00 0F 00 00

	trapvs.w	#15		; 59 FA 00 0F

	trapvs.l	#15		; 59 FB 00 00 00 0F

	trappl				; 5A FC
	trappl	#0x000F			; 5A FA 00 0F
	trappl	#0x000F0000		; 5A FB 00 0F 00 00

	trappl.w	#15		; 5A FA 00 0F

	trappl.l	#15		; 5A FB 00 00 00 0F

	trapmi				; 5B FC
	trapmi	#0x000F			; 5B FA 00 0F
	trapmi	#0x000F0000		; 5B FB 00 0F 00 00

	trapmi.w	#15		; 5B FA 00 0F

	trapmi.l	#15		; 5B FB 00 00 00 0F

	trapge				; 5C FC
	trapge	#0x000F			; 5C FA 00 0F
	trapge	#0x000F0000		; 5C FB 00 0F 00 00

	trapge.w	#15		; 5C FA 00 0F

	trapge.l	#15		; 5C FB 00 00 00 0F

	traplt				; 5D FC
	traplt	#0x000F			; 5D FA 00 0F
	traplt	#0x000F0000		; 5D FB 00 0F 00 00

	traplt.w	#15		; 5D FA 00 0F

	traplt.l	#15		; 5D FB 00 00 00 0F

	trapgt				; 5E FC
	trapgt	#0x000F			; 5E FA 00 0F
	trapgt	#0x000F0000		; 5E FB 00 0F 00 00

	trapgt.w	#15		; 5E FA 00 0F

	trapgt.l	#15		; 5E FB 00 00 00 0F

	traple				; 5F FC
	traple	#0x000F			; 5F FA 00 0F
	traple	#0x000F0000		; 5F FB 00 0F 00 00

	traple.w	#15		; 5F FA 00 0F

	traple.l	#15		; 5F FB 00 00 00 0F

	traphs				; 54 FC
	traphs	#0x000F			; 54 FA 00 0F
	traphs	#0x000F0000		; 54 FB 00 0F 00 00

	traphs.w	#15		; 54 FA 00 0F

	traphs.l	#15		; 54 FB 00 00 00 0F

	traplo				; 55 FC
	traplo	#0x000F			; 55 FA 00 0F
	traplo	#0x000F0000		; 55 FB 00 0F 00 00

	traplo.w	#15		; 55 FA 00 0F

	traplo.l	#15		; 55 FB 00 00 00 0F

	.sbttl	Type F_TYP1 Instructions: FABS, ...

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  F_TYP1:						*
	;*	FINT, FSINH, FINTRZ, FSQRT, FLOGNP1, FETOXM1,	*
	;*	FTANH, FATAN, FASIN, FATANH, FSIN, FTAN, 	*
	;*	FETOX, FTWOTOX, FTENTOX, FLOGN, FLOG10, FLOG2, 	*
	;*	FABS, FCOSH, FNEG, FCOS, FACOS, FGETEXP,	*
	;*	FGETMAN, FDIV					*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	fint	FP7			; F2 00 1F 81
	fint	FP1,FP2			; F2 00 05 01

	fint	(A1),FP2		; F2 11 49 01
	fint	(A2)+,FP3		; F2 1A 49 81
	fint	-(A3),FP4		; F2 23 4A 01
	fint	1(A4),FP5		; F2 2C 4A 81 00 01
	fint	2(A5,D7.W),FP6		; F2 35 4B 01 70 02
	fint	2(A5,D7.L),FP6		; F2 35 4B 01 78 02
	fint	(0x1234).W,FP7		; F2 38 4B 81 12 34
	fint	(0x1234).L,FP7		; F2 39 4B 81 00 00 12
	fint	*0xFFFFFFF0,FP0		; F2 38 48 01 FF F0
	fint	 0x00010004,FP1		; F2 39 48 81 00 01 00
	fint	5(PC),FP3		; F2 3A 49 81 00 01
	fint	6(PC,A7.W),FP4		; F2 3B 4A 01 F0 02
	fint	6(PC,A7.L),FP4		; F2 3B 4A 01 F8 02
	fint	(0x1234,A0,D1),FP0	; F2 30 48 01 11 20 12
	fint	([2,A1,A2],4),FP1	; F2 31 48 81 A1 22 00
	fint	([6,A2],D3,8),FP2	; F2 32 49 01 31 26 00
	fint	(0x1234,PC,D1),FP3	; F2 3B 49 81 11 20 12
	fint	([2,PC,A2],4),FP4	; F2 3B 4A 01 A1 22 FF
	fint	([6,PC],D3,8),FP5	; F2 3B 4A 81 31 26 00

	fint.b	D0,FP0			; F2 00 58 01
	fint.b	(A1),FP2		; F2 11 59 01
	fint.b	(A2)+,FP3		; F2 1A 59 81
	fint.b	-(A3),FP4		; F2 23 5A 01
	fint.b	1(A4),FP5		; F2 2C 5A 81 00 01
	fint.b	2(A5,D7.W),FP6		; F2 35 5B 01 70 02
	fint.b	2(A5,D7.L),FP6		; F2 35 5B 01 78 02
	fint.b	(0x1234).W,FP7		; F2 38 5B 81 12 34
	fint.b	(0x1234).L,FP7		; F2 39 5B 81 00 00 12
	fint.b	*0xFFFFFFF0,FP0		; F2 38 58 01 FF F0
	fint.b	 0x00010004,FP1		; F2 39 58 81 00 01 00
	fint.b	#7,FP2			; F2 3C 59 01 00 07
	fint.b	5(PC),FP3		; F2 3A 59 81 00 01
	fint.b	6(PC,A7.W),FP4		; F2 3B 5A 01 F0 02
	fint.b	6(PC,A7.L),FP4		; F2 3B 5A 01 F8 02
	fint.b	(0x1234,A0,D1),FP0	; F2 30 58 01 11 20 12
	fint.b	([2,A1,A2],4),FP1	; F2 31 58 81 A1 22 00
	fint.b	([6,A2],D3,8),FP2	; F2 32 59 01 31 26 00
	fint.b	(0x1234,PC,D1),FP3	; F2 3B 59 81 11 20 12
	fint.b	([2,PC,A2],4),FP4	; F2 3B 5A 01 A1 22 FF
	fint.b	([6,PC],D3,8),FP5	; F2 3B 5A 81 31 26 00

	fint.w	D0,FP0			; F2 00 50 01
	fint.w	(A1),FP2		; F2 11 51 01
	fint.w	(A2)+,FP3		; F2 1A 51 81
	fint.w	-(A3),FP4		; F2 23 52 01
	fint.w	1(A4),FP5		; F2 2C 52 81 00 01
	fint.w	2(A5,D7.W),FP6		; F2 35 53 01 70 02
	fint.w	2(A5,D7.L),FP6		; F2 35 53 01 78 02
	fint.w	(0x1234).W,FP7		; F2 38 53 81 12 34
	fint.w	(0x1234).L,FP7		; F2 39 53 81 00 00 12
	fint.w	*0xFFFFFFF0,FP0		; F2 38 50 01 FF F0
	fint.w	 0x00010004,FP1		; F2 39 50 81 00 01 00
	fint.w	#7,FP2			; F2 3C 51 01 00 07
	fint.w	5(PC),FP3		; F2 3A 51 81 00 01
	fint.w	6(PC,A7.W),FP4		; F2 3B 52 01 F0 02
	fint.w	6(PC,A7.L),FP4		; F2 3B 52 01 F8 02
	fint.w	(0x1234,A0,D1),FP0	; F2 30 50 01 11 20 12
	fint.w	([2,A1,A2],4),FP1	; F2 31 50 81 A1 22 00
	fint.w	([6,A2],D3,8),FP2	; F2 32 51 01 31 26 00
	fint.w	(0x1234,PC,D1),FP3	; F2 3B 51 81 11 20 12
	fint.w	([2,PC,A2],4),FP4	; F2 3B 52 01 A1 22 FF
	fint.w	([6,PC],D3,8),FP5	; F2 3B 52 81 31 26 00

	fint.l	D0,FP0			; F2 00 40 01
	fint.l	(A1),FP2		; F2 11 41 01
	fint.l	(A2)+,FP3		; F2 1A 41 81
	fint.l	-(A3),FP4		; F2 23 42 01
	fint.l	1(A4),FP5		; F2 2C 42 81 00 01
	fint.l	2(A5,D7.W),FP6		; F2 35 43 01 70 02
	fint.l	2(A5,D7.L),FP6		; F2 35 43 01 78 02
	fint.l	(0x1234).W,FP7		; F2 38 43 81 12 34
	fint.l	(0x1234).L,FP7		; F2 39 43 81 00 00 12
	fint.l	*0xFFFFFFF0,FP0		; F2 38 40 01 FF F0
	fint.l	 0x00010004,FP1		; F2 39 40 81 00 01 00
	fint.l	#7,FP2			; F2 3C 41 01 00 00 00
	fint.l	5(PC),FP3		; F2 3A 41 81 00 01
	fint.l	6(PC,A7.W),FP4		; F2 3B 42 01 F0 02
	fint.l	6(PC,A7.L),FP4		; F2 3B 42 01 F8 02
	fint.l	(0x1234,A0,D1),FP0	; F2 30 40 01 11 20 12
	fint.l	([2,A1,A2],4),FP1	; F2 31 40 81 A1 22 00
	fint.l	([6,A2],D3,8),FP2	; F2 32 41 01 31 26 00
	fint.l	(0x1234,PC,D1),FP3	; F2 3B 41 81 11 20 12
	fint.l	([2,PC,A2],4),FP4	; F2 3B 42 01 A1 22 FF
	fint.l	([6,PC],D3,8),FP5	; F2 3B 42 81 31 26 00

	fint.s	D0,FP0			; F2 00 44 01
	fint.s	(A1),FP2		; F2 11 45 01
	fint.s	(A2)+,FP3		; F2 1A 45 81
	fint.s	-(A3),FP4		; F2 23 46 01
	fint.s	1(A4),FP5		; F2 2C 46 81 00 01
	fint.s	2(A5,D7.W),FP6		; F2 35 47 01 70 02
	fint.s	2(A5,D7.L),FP6		; F2 35 47 01 78 02
	fint.s	(0x1234).W,FP7		; F2 38 47 81 12 34
	fint.s	(0x1234).L,FP7		; F2 39 47 81 00 00 12
	fint.s	*0xFFFFFFF0,FP0		; F2 38 44 01 FF F0
	fint.s	 0x00010004,FP1		; F2 39 44 81 00 01 00
	fint.s	#7,FP2			; F2 3C 45 01 40 E0 00
	fint.s	5(PC),FP3		; F2 3A 45 81 00 01
	fint.s	6(PC,A7.W),FP4		; F2 3B 46 01 F0 02
	fint.s	6(PC,A7.L),FP4		; F2 3B 46 01 F8 02
	fint.s	(0x1234,A0,D1),FP0	; F2 30 44 01 11 20 12
	fint.s	([2,A1,A2],4),FP1	; F2 31 44 81 A1 22 00
	fint.s	([6,A2],D3,8),FP2	; F2 32 45 01 31 26 00
	fint.s	(0x1234,PC,D1),FP3	; F2 3B 45 81 11 20 12
	fint.s	([2,PC,A2],4),FP4	; F2 3B 46 01 A1 22 FF
	fint.s	([6,PC],D3,8),FP5	; F2 3B 46 81 31 26 00

	fint.d	(A1),FP2		; F2 11 55 01
	fint.d	(A2)+,FP3		; F2 1A 55 81
	fint.d	-(A3),FP4		; F2 23 56 01
	fint.d	1(A4),FP5		; F2 2C 56 81 00 01
	fint.d	2(A5,D7.W),FP6		; F2 35 57 01 70 02
	fint.d	2(A5,D7.L),FP6		; F2 35 57 01 78 02
	fint.d	(0x1234).W,FP7		; F2 38 57 81 12 34
	fint.d	(0x1234).L,FP7		; F2 39 57 81 00 00 12
	fint.d	*0xFFFFFFF0,FP0		; F2 38 54 01 FF F0
	fint.d	 0x00010004,FP1		; F2 39 54 81 00 01 00
	fint.d	5(PC),FP3		; F2 3A 55 81 00 01
	fint.d	6(PC,A7.W),FP4		; F2 3B 56 01 F0 02
	fint.d	6(PC,A7.L),FP4		; F2 3B 56 01 F8 02
	fint.d	(0x1234,A0,D1),FP0	; F2 30 54 01 11 20 12
	fint.d	([2,A1,A2],4),FP1	; F2 31 54 81 A1 22 00
	fint.d	([6,A2],D3,8),FP2	; F2 32 55 01 31 26 00
	fint.d	(0x1234,PC,D1),FP3	; F2 3B 55 81 11 20 12
	fint.d	([2,PC,A2],4),FP4	; F2 3B 56 01 A1 22 FF
	fint.d	([6,PC],D3,8),FP5	; F2 3B 56 81 31 26 00

	fint.x	FP7			; F2 00 1F 81
	fint.x	FP1,FP2			; F2 00 05 01

	fint.x	(A1),FP2		; F2 11 49 01
	fint.x	(A2)+,FP3		; F2 1A 49 81
	fint.x	-(A3),FP4		; F2 23 4A 01
	fint.x	1(A4),FP5		; F2 2C 4A 81 00 01
	fint.x	2(A5,D7.W),FP6		; F2 35 4B 01 70 02
	fint.x	2(A5,D7.L),FP6		; F2 35 4B 01 78 02
	fint.x	(0x1234).W,FP7		; F2 38 4B 81 12 34
	fint.x	(0x1234).L,FP7		; F2 39 4B 81 00 00 12
	fint.x	*0xFFFFFFF0,FP0		; F2 38 48 01 FF F0
	fint.x	 0x00010004,FP1		; F2 39 48 81 00 01 00
	fint.x	5(PC),FP3		; F2 3A 49 81 00 01
	fint.x	6(PC,A7.W),FP4		; F2 3B 4A 01 F0 02
	fint.x	6(PC,A7.L),FP4		; F2 3B 4A 01 F8 02
	fint.x	(0x1234,A0,D1),FP0	; F2 30 48 01 11 20 12
	fint.x	([2,A1,A2],4),FP1	; F2 31 48 81 A1 22 00
	fint.x	([6,A2],D3,8),FP2	; F2 32 49 01 31 26 00
	fint.x	(0x1234,PC,D1),FP3	; F2 3B 49 81 11 20 12
	fint.x	([2,PC,A2],4),FP4	; F2 3B 4A 01 A1 22 FF
	fint.x	([6,PC],D3,8),FP5	; F2 3B 4A 81 31 26 00

	fint.p	(A1),FP2		; F2 11 4D 01
	fint.p	(A2)+,FP3		; F2 1A 4D 81
	fint.p	-(A3),FP4		; F2 23 4E 01
	fint.p	1(A4),FP5		; F2 2C 4E 81 00 01
	fint.p	2(A5,D7.W),FP6		; F2 35 4F 01 70 02
	fint.p	2(A5,D7.L),FP6		; F2 35 4F 01 78 02
	fint.p	(0x1234).W,FP7		; F2 38 4F 81 12 34
	fint.p	(0x1234).L,FP7		; F2 39 4F 81 00 00 12
	fint.p	*0xFFFFFFF0,FP0		; F2 38 4C 01 FF F0
	fint.p	 0x00010004,FP1		; F2 39 4C 81 00 01 00
	fint.p	5(PC),FP3		; F2 3A 4D 81 00 01
	fint.p	6(PC,A7.W),FP4		; F2 3B 4E 01 F0 02
	fint.p	6(PC,A7.L),FP4		; F2 3B 4E 01 F8 02
	fint.p	(0x1234,A0,D1),FP0	; F2 30 4C 01 11 20 12
	fint.p	([2,A1,A2],4),FP1	; F2 31 4C 81 A1 22 00
	fint.p	([6,A2],D3,8),FP2	; F2 32 4D 01 31 26 00
	fint.p	(0x1234,PC,D1),FP3	; F2 3B 4D 81 11 20 12
	fint.p	([2,PC,A2],4),FP4	; F2 3B 4E 01 A1 22 FF
	fint.p	([6,PC],D3,8),FP5	; F2 3B 4E 81 31 26 00

	fsinh	FP7			; F2 00 1F 82
	fsinh	FP1,FP2			; F2 00 05 02

	fsinh	(A1),FP2		; F2 11 49 02
	fsinh	(A2)+,FP3		; F2 1A 49 82
	fsinh	-(A3),FP4		; F2 23 4A 02
	fsinh	1(A4),FP5		; F2 2C 4A 82 00 01
	fsinh	2(A5,D7.W),FP6		; F2 35 4B 02 70 02
	fsinh	2(A5,D7.L),FP6		; F2 35 4B 02 78 02
	fsinh	(0x1234).W,FP7		; F2 38 4B 82 12 34
	fsinh	(0x1234).L,FP7		; F2 39 4B 82 00 00 12
	fsinh	*0xFFFFFFF0,FP0		; F2 38 48 02 FF F0
	fsinh	 0x00010004,FP1		; F2 39 48 82 00 01 00
	fsinh	5(PC),FP3		; F2 3A 49 82 00 01
	fsinh	6(PC,A7.W),FP4		; F2 3B 4A 02 F0 02
	fsinh	6(PC,A7.L),FP4		; F2 3B 4A 02 F8 02
	fsinh	(0x1234,A0,D1),FP0	; F2 30 48 02 11 20 12
	fsinh	([2,A1,A2],4),FP1	; F2 31 48 82 A1 22 00
	fsinh	([6,A2],D3,8),FP2	; F2 32 49 02 31 26 00
	fsinh	(0x1234,PC,D1),FP3	; F2 3B 49 82 11 20 12
	fsinh	([2,PC,A2],4),FP4	; F2 3B 4A 02 A1 22 FF
	fsinh	([6,PC],D3,8),FP5	; F2 3B 4A 82 31 26 00

	fsinh.b	D0,FP0			; F2 00 58 02
	fsinh.b	(A1),FP2		; F2 11 59 02
	fsinh.b	(A2)+,FP3		; F2 1A 59 82
	fsinh.b	-(A3),FP4		; F2 23 5A 02
	fsinh.b	1(A4),FP5		; F2 2C 5A 82 00 01
	fsinh.b	2(A5,D7.W),FP6		; F2 35 5B 02 70 02
	fsinh.b	2(A5,D7.L),FP6		; F2 35 5B 02 78 02
	fsinh.b	(0x1234).W,FP7		; F2 38 5B 82 12 34
	fsinh.b	(0x1234).L,FP7		; F2 39 5B 82 00 00 12
	fsinh.b	*0xFFFFFFF0,FP0		; F2 38 58 02 FF F0
	fsinh.b	 0x00010004,FP1		; F2 39 58 82 00 01 00
	fsinh.b	#7,FP2			; F2 3C 59 02 00 07
	fsinh.b	5(PC),FP3		; F2 3A 59 82 00 01
	fsinh.b	6(PC,A7.W),FP4		; F2 3B 5A 02 F0 02
	fsinh.b	6(PC,A7.L),FP4		; F2 3B 5A 02 F8 02
	fsinh.b	(0x1234,A0,D1),FP0	; F2 30 58 02 11 20 12
	fsinh.b	([2,A1,A2],4),FP1	; F2 31 58 82 A1 22 00
	fsinh.b	([6,A2],D3,8),FP2	; F2 32 59 02 31 26 00
	fsinh.b	(0x1234,PC,D1),FP3	; F2 3B 59 82 11 20 12
	fsinh.b	([2,PC,A2],4),FP4	; F2 3B 5A 02 A1 22 FF
	fsinh.b	([6,PC],D3,8),FP5	; F2 3B 5A 82 31 26 00

	fsinh.w	D0,FP0			; F2 00 50 02
	fsinh.w	(A1),FP2		; F2 11 51 02
	fsinh.w	(A2)+,FP3		; F2 1A 51 82
	fsinh.w	-(A3),FP4		; F2 23 52 02
	fsinh.w	1(A4),FP5		; F2 2C 52 82 00 01
	fsinh.w	2(A5,D7.W),FP6		; F2 35 53 02 70 02
	fsinh.w	2(A5,D7.L),FP6		; F2 35 53 02 78 02
	fsinh.w	(0x1234).W,FP7		; F2 38 53 82 12 34
	fsinh.w	(0x1234).L,FP7		; F2 39 53 82 00 00 12
	fsinh.w	*0xFFFFFFF0,FP0		; F2 38 50 02 FF F0
	fsinh.w	 0x00010004,FP1		; F2 39 50 82 00 01 00
	fsinh.w	#7,FP2			; F2 3C 51 02 00 07
	fsinh.w	5(PC),FP3		; F2 3A 51 82 00 01
	fsinh.w	6(PC,A7.W),FP4		; F2 3B 52 02 F0 02
	fsinh.w	6(PC,A7.L),FP4		; F2 3B 52 02 F8 02
	fsinh.w	(0x1234,A0,D1),FP0	; F2 30 50 02 11 20 12
	fsinh.w	([2,A1,A2],4),FP1	; F2 31 50 82 A1 22 00
	fsinh.w	([6,A2],D3,8),FP2	; F2 32 51 02 31 26 00
	fsinh.w	(0x1234,PC,D1),FP3	; F2 3B 51 82 11 20 12
	fsinh.w	([2,PC,A2],4),FP4	; F2 3B 52 02 A1 22 FF
	fsinh.w	([6,PC],D3,8),FP5	; F2 3B 52 82 31 26 00

	fsinh.l	D0,FP0			; F2 00 40 02
	fsinh.l	(A1),FP2		; F2 11 41 02
	fsinh.l	(A2)+,FP3		; F2 1A 41 82
	fsinh.l	-(A3),FP4		; F2 23 42 02
	fsinh.l	1(A4),FP5		; F2 2C 42 82 00 01
	fsinh.l	2(A5,D7.W),FP6		; F2 35 43 02 70 02
	fsinh.l	2(A5,D7.L),FP6		; F2 35 43 02 78 02
	fsinh.l	(0x1234).W,FP7		; F2 38 43 82 12 34
	fsinh.l	(0x1234).L,FP7		; F2 39 43 82 00 00 12
	fsinh.l	*0xFFFFFFF0,FP0		; F2 38 40 02 FF F0
	fsinh.l	 0x00010004,FP1		; F2 39 40 82 00 01 00
	fsinh.l	#7,FP2			; F2 3C 41 02 00 00 00
	fsinh.l	5(PC),FP3		; F2 3A 41 82 00 01
	fsinh.l	6(PC,A7.W),FP4		; F2 3B 42 02 F0 02
	fsinh.l	6(PC,A7.L),FP4		; F2 3B 42 02 F8 02
	fsinh.l	(0x1234,A0,D1),FP0	; F2 30 40 02 11 20 12
	fsinh.l	([2,A1,A2],4),FP1	; F2 31 40 82 A1 22 00
	fsinh.l	([6,A2],D3,8),FP2	; F2 32 41 02 31 26 00
	fsinh.l	(0x1234,PC,D1),FP3	; F2 3B 41 82 11 20 12
	fsinh.l	([2,PC,A2],4),FP4	; F2 3B 42 02 A1 22 FF
	fsinh.l	([6,PC],D3,8),FP5	; F2 3B 42 82 31 26 00

	fsinh.s	D0,FP0			; F2 00 44 02
	fsinh.s	(A1),FP2		; F2 11 45 02
	fsinh.s	(A2)+,FP3		; F2 1A 45 82
	fsinh.s	-(A3),FP4		; F2 23 46 02
	fsinh.s	1(A4),FP5		; F2 2C 46 82 00 01
	fsinh.s	2(A5,D7.W),FP6		; F2 35 47 02 70 02
	fsinh.s	2(A5,D7.L),FP6		; F2 35 47 02 78 02
	fsinh.s	(0x1234).W,FP7		; F2 38 47 82 12 34
	fsinh.s	(0x1234).L,FP7		; F2 39 47 82 00 00 12
	fsinh.s	*0xFFFFFFF0,FP0		; F2 38 44 02 FF F0
	fsinh.s	 0x00010004,FP1		; F2 39 44 82 00 01 00
	fsinh.s	#7,FP2			; F2 3C 45 02 40 E0 00
	fsinh.s	5(PC),FP3		; F2 3A 45 82 00 01
	fsinh.s	6(PC,A7.W),FP4		; F2 3B 46 02 F0 02
	fsinh.s	6(PC,A7.L),FP4		; F2 3B 46 02 F8 02
	fsinh.s	(0x1234,A0,D1),FP0	; F2 30 44 02 11 20 12
	fsinh.s	([2,A1,A2],4),FP1	; F2 31 44 82 A1 22 00
	fsinh.s	([6,A2],D3,8),FP2	; F2 32 45 02 31 26 00
	fsinh.s	(0x1234,PC,D1),FP3	; F2 3B 45 82 11 20 12
	fsinh.s	([2,PC,A2],4),FP4	; F2 3B 46 02 A1 22 FF
	fsinh.s	([6,PC],D3,8),FP5	; F2 3B 46 82 31 26 00

	fsinh.d	(A1),FP2		; F2 11 55 02
	fsinh.d	(A2)+,FP3		; F2 1A 55 82
	fsinh.d	-(A3),FP4		; F2 23 56 02
	fsinh.d	1(A4),FP5		; F2 2C 56 82 00 01
	fsinh.d	2(A5,D7.W),FP6		; F2 35 57 02 70 02
	fsinh.d	2(A5,D7.L),FP6		; F2 35 57 02 78 02
	fsinh.d	(0x1234).W,FP7		; F2 38 57 82 12 34
	fsinh.d	(0x1234).L,FP7		; F2 39 57 82 00 00 12
	fsinh.d	*0xFFFFFFF0,FP0		; F2 38 54 02 FF F0
	fsinh.d	 0x00010004,FP1		; F2 39 54 82 00 01 00
	fsinh.d	5(PC),FP3		; F2 3A 55 82 00 01
	fsinh.d	6(PC,A7.W),FP4		; F2 3B 56 02 F0 02
	fsinh.d	6(PC,A7.L),FP4		; F2 3B 56 02 F8 02
	fsinh.d	(0x1234,A0,D1),FP0	; F2 30 54 02 11 20 12
	fsinh.d	([2,A1,A2],4),FP1	; F2 31 54 82 A1 22 00
	fsinh.d	([6,A2],D3,8),FP2	; F2 32 55 02 31 26 00
	fsinh.d	(0x1234,PC,D1),FP3	; F2 3B 55 82 11 20 12
	fsinh.d	([2,PC,A2],4),FP4	; F2 3B 56 02 A1 22 FF
	fsinh.d	([6,PC],D3,8),FP5	; F2 3B 56 82 31 26 00

	fsinh.x	FP7			; F2 00 1F 82
	fsinh.x	FP1,FP2			; F2 00 05 02

	fsinh.x	(A1),FP2		; F2 11 49 02
	fsinh.x	(A2)+,FP3		; F2 1A 49 82
	fsinh.x	-(A3),FP4		; F2 23 4A 02
	fsinh.x	1(A4),FP5		; F2 2C 4A 82 00 01
	fsinh.x	2(A5,D7.W),FP6		; F2 35 4B 02 70 02
	fsinh.x	2(A5,D7.L),FP6		; F2 35 4B 02 78 02
	fsinh.x	(0x1234).W,FP7		; F2 38 4B 82 12 34
	fsinh.x	(0x1234).L,FP7		; F2 39 4B 82 00 00 12
	fsinh.x	*0xFFFFFFF0,FP0		; F2 38 48 02 FF F0
	fsinh.x	 0x00010004,FP1		; F2 39 48 82 00 01 00
	fsinh.x	5(PC),FP3		; F2 3A 49 82 00 01
	fsinh.x	6(PC,A7.W),FP4		; F2 3B 4A 02 F0 02
	fsinh.x	6(PC,A7.L),FP4		; F2 3B 4A 02 F8 02
	fsinh.x	(0x1234,A0,D1),FP0	; F2 30 48 02 11 20 12
	fsinh.x	([2,A1,A2],4),FP1	; F2 31 48 82 A1 22 00
	fsinh.x	([6,A2],D3,8),FP2	; F2 32 49 02 31 26 00
	fsinh.x	(0x1234,PC,D1),FP3	; F2 3B 49 82 11 20 12
	fsinh.x	([2,PC,A2],4),FP4	; F2 3B 4A 02 A1 22 FF
	fsinh.x	([6,PC],D3,8),FP5	; F2 3B 4A 82 31 26 00

	fsinh.p	(A1),FP2		; F2 11 4D 02
	fsinh.p	(A2)+,FP3		; F2 1A 4D 82
	fsinh.p	-(A3),FP4		; F2 23 4E 02
	fsinh.p	1(A4),FP5		; F2 2C 4E 82 00 01
	fsinh.p	2(A5,D7.W),FP6		; F2 35 4F 02 70 02
	fsinh.p	2(A5,D7.L),FP6		; F2 35 4F 02 78 02
	fsinh.p	(0x1234).W,FP7		; F2 38 4F 82 12 34
	fsinh.p	(0x1234).L,FP7		; F2 39 4F 82 00 00 12
	fsinh.p	*0xFFFFFFF0,FP0		; F2 38 4C 02 FF F0
	fsinh.p	 0x00010004,FP1		; F2 39 4C 82 00 01 00
	fsinh.p	5(PC),FP3		; F2 3A 4D 82 00 01
	fsinh.p	6(PC,A7.W),FP4		; F2 3B 4E 02 F0 02
	fsinh.p	6(PC,A7.L),FP4		; F2 3B 4E 02 F8 02
	fsinh.p	(0x1234,A0,D1),FP0	; F2 30 4C 02 11 20 12
	fsinh.p	([2,A1,A2],4),FP1	; F2 31 4C 82 A1 22 00
	fsinh.p	([6,A2],D3,8),FP2	; F2 32 4D 02 31 26 00
	fsinh.p	(0x1234,PC,D1),FP3	; F2 3B 4D 82 11 20 12
	fsinh.p	([2,PC,A2],4),FP4	; F2 3B 4E 02 A1 22 FF
	fsinh.p	([6,PC],D3,8),FP5	; F2 3B 4E 82 31 26 00

	fintrz	FP7			; F2 00 1F 83
	fintrz	FP1,FP2			; F2 00 05 03

	fintrz	(A1),FP2		; F2 11 49 03
	fintrz	(A2)+,FP3		; F2 1A 49 83
	fintrz	-(A3),FP4		; F2 23 4A 03
	fintrz	1(A4),FP5		; F2 2C 4A 83 00 01
	fintrz	2(A5,D7.W),FP6		; F2 35 4B 03 70 02
	fintrz	2(A5,D7.L),FP6		; F2 35 4B 03 78 02
	fintrz	(0x1234).W,FP7		; F2 38 4B 83 12 34
	fintrz	(0x1234).L,FP7		; F2 39 4B 83 00 00 12
	fintrz	*0xFFFFFFF0,FP0		; F2 38 48 03 FF F0
	fintrz	 0x00010004,FP1		; F2 39 48 83 00 01 00
	fintrz	5(PC),FP3		; F2 3A 49 83 00 01
	fintrz	6(PC,A7.W),FP4		; F2 3B 4A 03 F0 02
	fintrz	6(PC,A7.L),FP4		; F2 3B 4A 03 F8 02
	fintrz	(0x1234,A0,D1),FP0	; F2 30 48 03 11 20 12
	fintrz	([2,A1,A2],4),FP1	; F2 31 48 83 A1 22 00
	fintrz	([6,A2],D3,8),FP2	; F2 32 49 03 31 26 00
	fintrz	(0x1234,PC,D1),FP3	; F2 3B 49 83 11 20 12
	fintrz	([2,PC,A2],4),FP4	; F2 3B 4A 03 A1 22 FF
	fintrz	([6,PC],D3,8),FP5	; F2 3B 4A 83 31 26 00

	fintrz.b	D0,FP0		; F2 00 58 03
	fintrz.b	(A1),FP2	; F2 11 59 03
	fintrz.b	(A2)+,FP3	; F2 1A 59 83
	fintrz.b	-(A3),FP4	; F2 23 5A 03
	fintrz.b	1(A4),FP5	; F2 2C 5A 83 00 01
	fintrz.b	2(A5,D7.W),FP6	; F2 35 5B 03 70 02
	fintrz.b	2(A5,D7.L),FP6	; F2 35 5B 03 78 02
	fintrz.b	(0x1234).W,FP7	; F2 38 5B 83 12 34
	fintrz.b	(0x1234).L,FP7	; F2 39 5B 83 00 00 12
	fintrz.b	*0xFFFFFFF0,FP0	; F2 38 58 03 FF F0
	fintrz.b	 0x00010004,FP1	; F2 39 58 83 00 01 00
	fintrz.b	#7,FP2		; F2 3C 59 03 00 07
	fintrz.b	5(PC),FP3	; F2 3A 59 83 00 01
	fintrz.b	6(PC,A7.W),FP4	; F2 3B 5A 03 F0 02
	fintrz.b	6(PC,A7.L),FP4	; F2 3B 5A 03 F8 02
	fintrz.b	(0x1234,A0,D1),FP0	; F2 30 58 03 11 20 12
	fintrz.b	([2,A1,A2],4),FP1	; F2 31 58 83 A1 22 00
	fintrz.b	([6,A2],D3,8),FP2	; F2 32 59 03 31 26 00
	fintrz.b	(0x1234,PC,D1),FP3	; F2 3B 59 83 11 20 12
	fintrz.b	([2,PC,A2],4),FP4	; F2 3B 5A 03 A1 22 FF
	fintrz.b	([6,PC],D3,8),FP5	; F2 3B 5A 83 31 26 00

	fintrz.w	D0,FP0		; F2 00 50 03
	fintrz.w	(A1),FP2	; F2 11 51 03
	fintrz.w	(A2)+,FP3	; F2 1A 51 83
	fintrz.w	-(A3),FP4	; F2 23 52 03
	fintrz.w	1(A4),FP5	; F2 2C 52 83 00 01
	fintrz.w	2(A5,D7.W),FP6	; F2 35 53 03 70 02
	fintrz.w	2(A5,D7.L),FP6	; F2 35 53 03 78 02
	fintrz.w	(0x1234).W,FP7	; F2 38 53 83 12 34
	fintrz.w	(0x1234).L,FP7	; F2 39 53 83 00 00 12
	fintrz.w	*0xFFFFFFF0,FP0	; F2 38 50 03 FF F0
	fintrz.w	 0x00010004,FP1	; F2 39 50 83 00 01 00
	fintrz.w	#7,FP2		; F2 3C 51 03 00 07
	fintrz.w	5(PC),FP3	; F2 3A 51 83 00 01
	fintrz.w	6(PC,A7.W),FP4	; F2 3B 52 03 F0 02
	fintrz.w	6(PC,A7.L),FP4	; F2 3B 52 03 F8 02
	fintrz.w	(0x1234,A0,D1),FP0	; F2 30 50 03 11 20 12
	fintrz.w	([2,A1,A2],4),FP1	; F2 31 50 83 A1 22 00
	fintrz.w	([6,A2],D3,8),FP2	; F2 32 51 03 31 26 00
	fintrz.w	(0x1234,PC,D1),FP3	; F2 3B 51 83 11 20 12
	fintrz.w	([2,PC,A2],4),FP4	; F2 3B 52 03 A1 22 FF
	fintrz.w	([6,PC],D3,8),FP5	; F2 3B 52 83 31 26 00

	fintrz.l	D0,FP0		; F2 00 40 03
	fintrz.l	(A1),FP2	; F2 11 41 03
	fintrz.l	(A2)+,FP3	; F2 1A 41 83
	fintrz.l	-(A3),FP4	; F2 23 42 03
	fintrz.l	1(A4),FP5	; F2 2C 42 83 00 01
	fintrz.l	2(A5,D7.W),FP6	; F2 35 43 03 70 02
	fintrz.l	2(A5,D7.L),FP6	; F2 35 43 03 78 02
	fintrz.l	(0x1234).W,FP7	; F2 38 43 83 12 34
	fintrz.l	(0x1234).L,FP7	; F2 39 43 83 00 00 12
	fintrz.l	*0xFFFFFFF0,FP0	; F2 38 40 03 FF F0
	fintrz.l	 0x00010004,FP1	; F2 39 40 83 00 01 00
	fintrz.l	#7,FP2		; F2 3C 41 03 00 00 00
	fintrz.l	5(PC),FP3	; F2 3A 41 83 00 01
	fintrz.l	6(PC,A7.W),FP4	; F2 3B 42 03 F0 02
	fintrz.l	6(PC,A7.L),FP4	; F2 3B 42 03 F8 02
	fintrz.l	(0x1234,A0,D1),FP0	; F2 30 40 03 11 20 12
	fintrz.l	([2,A1,A2],4),FP1	; F2 31 40 83 A1 22 00
	fintrz.l	([6,A2],D3,8),FP2	; F2 32 41 03 31 26 00
	fintrz.l	(0x1234,PC,D1),FP3	; F2 3B 41 83 11 20 12
	fintrz.l	([2,PC,A2],4),FP4	; F2 3B 42 03 A1 22 FF
	fintrz.l	([6,PC],D3,8),FP5	; F2 3B 42 83 31 26 00

	fintrz.s	D0,FP0		; F2 00 44 03
	fintrz.s	(A1),FP2	; F2 11 45 03
	fintrz.s	(A2)+,FP3	; F2 1A 45 83
	fintrz.s	-(A3),FP4	; F2 23 46 03
	fintrz.s	1(A4),FP5	; F2 2C 46 83 00 01
	fintrz.s	2(A5,D7.W),FP6	; F2 35 47 03 70 02
	fintrz.s	2(A5,D7.L),FP6	; F2 35 47 03 78 02
	fintrz.s	(0x1234).W,FP7	; F2 38 47 83 12 34
	fintrz.s	(0x1234).L,FP7	; F2 39 47 83 00 00 12
	fintrz.s	*0xFFFFFFF0,FP0	; F2 38 44 03 FF F0
	fintrz.s	 0x00010004,FP1	; F2 39 44 83 00 01 00
	fintrz.s	#7,FP2		; F2 3C 45 03 40 E0 00
	fintrz.s	5(PC),FP3	; F2 3A 45 83 00 01
	fintrz.s	6(PC,A7.W),FP4	; F2 3B 46 03 F0 02
	fintrz.s	6(PC,A7.L),FP4	; F2 3B 46 03 F8 02
	fintrz.s	(0x1234,A0,D1),FP0	; F2 30 44 03 11 20 12
	fintrz.s	([2,A1,A2],4),FP1	; F2 31 44 83 A1 22 00
	fintrz.s	([6,A2],D3,8),FP2	; F2 32 45 03 31 26 00
	fintrz.s	(0x1234,PC,D1),FP3	; F2 3B 45 83 11 20 12
	fintrz.s	([2,PC,A2],4),FP4	; F2 3B 46 03 A1 22 FF
	fintrz.s	([6,PC],D3,8),FP5	; F2 3B 46 83 31 26 00

	fintrz.d	(A1),FP2	; F2 11 55 03
	fintrz.d	(A2)+,FP3	; F2 1A 55 83
	fintrz.d	-(A3),FP4	; F2 23 56 03
	fintrz.d	1(A4),FP5	; F2 2C 56 83 00 01
	fintrz.d	2(A5,D7.W),FP6	; F2 35 57 03 70 02
	fintrz.d	2(A5,D7.L),FP6	; F2 35 57 03 78 02
	fintrz.d	(0x1234).W,FP7	; F2 38 57 83 12 34
	fintrz.d	(0x1234).L,FP7	; F2 39 57 83 00 00 12
	fintrz.d	*0xFFFFFFF0,FP0	; F2 38 54 03 FF F0
	fintrz.d	 0x00010004,FP1	; F2 39 54 83 00 01 00
	fintrz.d	5(PC),FP3	; F2 3A 55 83 00 01
	fintrz.d	6(PC,A7.W),FP4	; F2 3B 56 03 F0 02
	fintrz.d	6(PC,A7.L),FP4	; F2 3B 56 03 F8 02
	fintrz.d	(0x1234,A0,D1),FP0	; F2 30 54 03 11 20 12
	fintrz.d	([2,A1,A2],4),FP1	; F2 31 54 83 A1 22 00
	fintrz.d	([6,A2],D3,8),FP2	; F2 32 55 03 31 26 00
	fintrz.d	(0x1234,PC,D1),FP3	; F2 3B 55 83 11 20 12
	fintrz.d	([2,PC,A2],4),FP4	; F2 3B 56 03 A1 22 FF
	fintrz.d	([6,PC],D3,8),FP5	; F2 3B 56 83 31 26 00

	fintrz.x	FP7		; F2 00 1F 83
	fintrz.x	FP1,FP2		; F2 00 05 03

	fintrz.x	(A1),FP2	; F2 11 49 03
	fintrz.x	(A2)+,FP3	; F2 1A 49 83
	fintrz.x	-(A3),FP4	; F2 23 4A 03
	fintrz.x	1(A4),FP5	; F2 2C 4A 83 00 01
	fintrz.x	2(A5,D7.W),FP6	; F2 35 4B 03 70 02
	fintrz.x	2(A5,D7.L),FP6	; F2 35 4B 03 78 02
	fintrz.x	(0x1234).W,FP7	; F2 38 4B 83 12 34
	fintrz.x	(0x1234).L,FP7	; F2 39 4B 83 00 00 12
	fintrz.x	*0xFFFFFFF0,FP0	; F2 38 48 03 FF F0
	fintrz.x	 0x00010004,FP1	; F2 39 48 83 00 01 00
	fintrz.x	5(PC),FP3	; F2 3A 49 83 00 01
	fintrz.x	6(PC,A7.W),FP4	; F2 3B 4A 03 F0 02
	fintrz.x	6(PC,A7.L),FP4	; F2 3B 4A 03 F8 02
	fintrz.x	(0x1234,A0,D1),FP0	; F2 30 48 03 11 20 12
	fintrz.x	([2,A1,A2],4),FP1	; F2 31 48 83 A1 22 00
	fintrz.x	([6,A2],D3,8),FP2	; F2 32 49 03 31 26 00
	fintrz.x	(0x1234,PC,D1),FP3	; F2 3B 49 83 11 20 12
	fintrz.x	([2,PC,A2],4),FP4	; F2 3B 4A 03 A1 22 FF
	fintrz.x	([6,PC],D3,8),FP5	; F2 3B 4A 83 31 26 00

	fintrz.p	(A1),FP2	; F2 11 4D 03
	fintrz.p	(A2)+,FP3	; F2 1A 4D 83
	fintrz.p	-(A3),FP4	; F2 23 4E 03
	fintrz.p	1(A4),FP5	; F2 2C 4E 83 00 01
	fintrz.p	2(A5,D7.W),FP6	; F2 35 4F 03 70 02
	fintrz.p	2(A5,D7.L),FP6	; F2 35 4F 03 78 02
	fintrz.p	(0x1234).W,FP7	; F2 38 4F 83 12 34
	fintrz.p	(0x1234).L,FP7	; F2 39 4F 83 00 00 12
	fintrz.p	*0xFFFFFFF0,FP0	; F2 38 4C 03 FF F0
	fintrz.p	 0x00010004,FP1	; F2 39 4C 83 00 01 00
	fintrz.p	5(PC),FP3	; F2 3A 4D 83 00 01
	fintrz.p	6(PC,A7.W),FP4	; F2 3B 4E 03 F0 02
	fintrz.p	6(PC,A7.L),FP4	; F2 3B 4E 03 F8 02
	fintrz.p	(0x1234,A0,D1),FP0	; F2 30 4C 03 11 20 12
	fintrz.p	([2,A1,A2],4),FP1	; F2 31 4C 83 A1 22 00
	fintrz.p	([6,A2],D3,8),FP2	; F2 32 4D 03 31 26 00
	fintrz.p	(0x1234,PC,D1),FP3	; F2 3B 4D 83 11 20 12
	fintrz.p	([2,PC,A2],4),FP4	; F2 3B 4E 03 A1 22 FF
	fintrz.p	([6,PC],D3,8),FP5	; F2 3B 4E 83 31 26 00

	fsqrt	FP7			; F2 00 1F 84
	fsqrt	FP1,FP2			; F2 00 05 04

	fsqrt	(A1),FP2		; F2 11 49 04
	fsqrt	(A2)+,FP3		; F2 1A 49 84
	fsqrt	-(A3),FP4		; F2 23 4A 04
	fsqrt	1(A4),FP5		; F2 2C 4A 84 00 01
	fsqrt	2(A5,D7.W),FP6		; F2 35 4B 04 70 02
	fsqrt	2(A5,D7.L),FP6		; F2 35 4B 04 78 02
	fsqrt	(0x1234).W,FP7		; F2 38 4B 84 12 34
	fsqrt	(0x1234).L,FP7		; F2 39 4B 84 00 00 12
	fsqrt	*0xFFFFFFF0,FP0		; F2 38 48 04 FF F0
	fsqrt	 0x00010004,FP1		; F2 39 48 84 00 01 00
	fsqrt	5(PC),FP3		; F2 3A 49 84 00 01
	fsqrt	6(PC,A7.W),FP4		; F2 3B 4A 04 F0 02
	fsqrt	6(PC,A7.L),FP4		; F2 3B 4A 04 F8 02
	fsqrt	(0x1234,A0,D1),FP0	; F2 30 48 04 11 20 12
	fsqrt	([2,A1,A2],4),FP1	; F2 31 48 84 A1 22 00
	fsqrt	([6,A2],D3,8),FP2	; F2 32 49 04 31 26 00
	fsqrt	(0x1234,PC,D1),FP3	; F2 3B 49 84 11 20 12
	fsqrt	([2,PC,A2],4),FP4	; F2 3B 4A 04 A1 22 FF
	fsqrt	([6,PC],D3,8),FP5	; F2 3B 4A 84 31 26 00

	fsqrt.b	D0,FP0			; F2 00 58 04
	fsqrt.b	(A1),FP2		; F2 11 59 04
	fsqrt.b	(A2)+,FP3		; F2 1A 59 84
	fsqrt.b	-(A3),FP4		; F2 23 5A 04
	fsqrt.b	1(A4),FP5		; F2 2C 5A 84 00 01
	fsqrt.b	2(A5,D7.W),FP6		; F2 35 5B 04 70 02
	fsqrt.b	2(A5,D7.L),FP6		; F2 35 5B 04 78 02
	fsqrt.b	(0x1234).W,FP7		; F2 38 5B 84 12 34
	fsqrt.b	(0x1234).L,FP7		; F2 39 5B 84 00 00 12
	fsqrt.b	*0xFFFFFFF0,FP0		; F2 38 58 04 FF F0
	fsqrt.b	 0x00010004,FP1		; F2 39 58 84 00 01 00
	fsqrt.b	#7,FP2			; F2 3C 59 04 00 07
	fsqrt.b	5(PC),FP3		; F2 3A 59 84 00 01
	fsqrt.b	6(PC,A7.W),FP4		; F2 3B 5A 04 F0 02
	fsqrt.b	6(PC,A7.L),FP4		; F2 3B 5A 04 F8 02
	fsqrt.b	(0x1234,A0,D1),FP0	; F2 30 58 04 11 20 12
	fsqrt.b	([2,A1,A2],4),FP1	; F2 31 58 84 A1 22 00
	fsqrt.b	([6,A2],D3,8),FP2	; F2 32 59 04 31 26 00
	fsqrt.b	(0x1234,PC,D1),FP3	; F2 3B 59 84 11 20 12
	fsqrt.b	([2,PC,A2],4),FP4	; F2 3B 5A 04 A1 22 FF
	fsqrt.b	([6,PC],D3,8),FP5	; F2 3B 5A 84 31 26 00

	fsqrt.w	D0,FP0			; F2 00 50 04
	fsqrt.w	(A1),FP2		; F2 11 51 04
	fsqrt.w	(A2)+,FP3		; F2 1A 51 84
	fsqrt.w	-(A3),FP4		; F2 23 52 04
	fsqrt.w	1(A4),FP5		; F2 2C 52 84 00 01
	fsqrt.w	2(A5,D7.W),FP6		; F2 35 53 04 70 02
	fsqrt.w	2(A5,D7.L),FP6		; F2 35 53 04 78 02
	fsqrt.w	(0x1234).W,FP7		; F2 38 53 84 12 34
	fsqrt.w	(0x1234).L,FP7		; F2 39 53 84 00 00 12
	fsqrt.w	*0xFFFFFFF0,FP0		; F2 38 50 04 FF F0
	fsqrt.w	 0x00010004,FP1		; F2 39 50 84 00 01 00
	fsqrt.w	#7,FP2			; F2 3C 51 04 00 07
	fsqrt.w	5(PC),FP3		; F2 3A 51 84 00 01
	fsqrt.w	6(PC,A7.W),FP4		; F2 3B 52 04 F0 02
	fsqrt.w	6(PC,A7.L),FP4		; F2 3B 52 04 F8 02
	fsqrt.w	(0x1234,A0,D1),FP0	; F2 30 50 04 11 20 12
	fsqrt.w	([2,A1,A2],4),FP1	; F2 31 50 84 A1 22 00
	fsqrt.w	([6,A2],D3,8),FP2	; F2 32 51 04 31 26 00
	fsqrt.w	(0x1234,PC,D1),FP3	; F2 3B 51 84 11 20 12
	fsqrt.w	([2,PC,A2],4),FP4	; F2 3B 52 04 A1 22 FF
	fsqrt.w	([6,PC],D3,8),FP5	; F2 3B 52 84 31 26 00

	fsqrt.l	D0,FP0			; F2 00 40 04
	fsqrt.l	(A1),FP2		; F2 11 41 04
	fsqrt.l	(A2)+,FP3		; F2 1A 41 84
	fsqrt.l	-(A3),FP4		; F2 23 42 04
	fsqrt.l	1(A4),FP5		; F2 2C 42 84 00 01
	fsqrt.l	2(A5,D7.W),FP6		; F2 35 43 04 70 02
	fsqrt.l	2(A5,D7.L),FP6		; F2 35 43 04 78 02
	fsqrt.l	(0x1234).W,FP7		; F2 38 43 84 12 34
	fsqrt.l	(0x1234).L,FP7		; F2 39 43 84 00 00 12
	fsqrt.l	*0xFFFFFFF0,FP0		; F2 38 40 04 FF F0
	fsqrt.l	 0x00010004,FP1		; F2 39 40 84 00 01 00
	fsqrt.l	#7,FP2			; F2 3C 41 04 00 00 00
	fsqrt.l	5(PC),FP3		; F2 3A 41 84 00 01
	fsqrt.l	6(PC,A7.W),FP4		; F2 3B 42 04 F0 02
	fsqrt.l	6(PC,A7.L),FP4		; F2 3B 42 04 F8 02
	fsqrt.l	(0x1234,A0,D1),FP0	; F2 30 40 04 11 20 12
	fsqrt.l	([2,A1,A2],4),FP1	; F2 31 40 84 A1 22 00
	fsqrt.l	([6,A2],D3,8),FP2	; F2 32 41 04 31 26 00
	fsqrt.l	(0x1234,PC,D1),FP3	; F2 3B 41 84 11 20 12
	fsqrt.l	([2,PC,A2],4),FP4	; F2 3B 42 04 A1 22 FF
	fsqrt.l	([6,PC],D3,8),FP5	; F2 3B 42 84 31 26 00

	fsqrt.s	D0,FP0			; F2 00 44 04
	fsqrt.s	(A1),FP2		; F2 11 45 04
	fsqrt.s	(A2)+,FP3		; F2 1A 45 84
	fsqrt.s	-(A3),FP4		; F2 23 46 04
	fsqrt.s	1(A4),FP5		; F2 2C 46 84 00 01
	fsqrt.s	2(A5,D7.W),FP6		; F2 35 47 04 70 02
	fsqrt.s	2(A5,D7.L),FP6		; F2 35 47 04 78 02
	fsqrt.s	(0x1234).W,FP7		; F2 38 47 84 12 34
	fsqrt.s	(0x1234).L,FP7		; F2 39 47 84 00 00 12
	fsqrt.s	*0xFFFFFFF0,FP0		; F2 38 44 04 FF F0
	fsqrt.s	 0x00010004,FP1		; F2 39 44 84 00 01 00
	fsqrt.s	#7,FP2			; F2 3C 45 04 40 E0 00
	fsqrt.s	5(PC),FP3		; F2 3A 45 84 00 01
	fsqrt.s	6(PC,A7.W),FP4		; F2 3B 46 04 F0 02
	fsqrt.s	6(PC,A7.L),FP4		; F2 3B 46 04 F8 02
	fsqrt.s	(0x1234,A0,D1),FP0	; F2 30 44 04 11 20 12
	fsqrt.s	([2,A1,A2],4),FP1	; F2 31 44 84 A1 22 00
	fsqrt.s	([6,A2],D3,8),FP2	; F2 32 45 04 31 26 00
	fsqrt.s	(0x1234,PC,D1),FP3	; F2 3B 45 84 11 20 12
	fsqrt.s	([2,PC,A2],4),FP4	; F2 3B 46 04 A1 22 FF
	fsqrt.s	([6,PC],D3,8),FP5	; F2 3B 46 84 31 26 00

	fsqrt.d	(A1),FP2		; F2 11 55 04
	fsqrt.d	(A2)+,FP3		; F2 1A 55 84
	fsqrt.d	-(A3),FP4		; F2 23 56 04
	fsqrt.d	1(A4),FP5		; F2 2C 56 84 00 01
	fsqrt.d	2(A5,D7.W),FP6		; F2 35 57 04 70 02
	fsqrt.d	2(A5,D7.L),FP6		; F2 35 57 04 78 02
	fsqrt.d	(0x1234).W,FP7		; F2 38 57 84 12 34
	fsqrt.d	(0x1234).L,FP7		; F2 39 57 84 00 00 12
	fsqrt.d	*0xFFFFFFF0,FP0		; F2 38 54 04 FF F0
	fsqrt.d	 0x00010004,FP1		; F2 39 54 84 00 01 00
	fsqrt.d	5(PC),FP3		; F2 3A 55 84 00 01
	fsqrt.d	6(PC,A7.W),FP4		; F2 3B 56 04 F0 02
	fsqrt.d	6(PC,A7.L),FP4		; F2 3B 56 04 F8 02
	fsqrt.d	(0x1234,A0,D1),FP0	; F2 30 54 04 11 20 12
	fsqrt.d	([2,A1,A2],4),FP1	; F2 31 54 84 A1 22 00
	fsqrt.d	([6,A2],D3,8),FP2	; F2 32 55 04 31 26 00
	fsqrt.d	(0x1234,PC,D1),FP3	; F2 3B 55 84 11 20 12
	fsqrt.d	([2,PC,A2],4),FP4	; F2 3B 56 04 A1 22 FF
	fsqrt.d	([6,PC],D3,8),FP5	; F2 3B 56 84 31 26 00

	fsqrt.x	FP7			; F2 00 1F 84
	fsqrt.x	FP1,FP2			; F2 00 05 04

	fsqrt.x	(A1),FP2		; F2 11 49 04
	fsqrt.x	(A2)+,FP3		; F2 1A 49 84
	fsqrt.x	-(A3),FP4		; F2 23 4A 04
	fsqrt.x	1(A4),FP5		; F2 2C 4A 84 00 01
	fsqrt.x	2(A5,D7.W),FP6		; F2 35 4B 04 70 02
	fsqrt.x	2(A5,D7.L),FP6		; F2 35 4B 04 78 02
	fsqrt.x	(0x1234).W,FP7		; F2 38 4B 84 12 34
	fsqrt.x	(0x1234).L,FP7		; F2 39 4B 84 00 00 12
	fsqrt.x	*0xFFFFFFF0,FP0		; F2 38 48 04 FF F0
	fsqrt.x	 0x00010004,FP1		; F2 39 48 84 00 01 00
	fsqrt.x	5(PC),FP3		; F2 3A 49 84 00 01
	fsqrt.x	6(PC,A7.W),FP4		; F2 3B 4A 04 F0 02
	fsqrt.x	6(PC,A7.L),FP4		; F2 3B 4A 04 F8 02
	fsqrt.x	(0x1234,A0,D1),FP0	; F2 30 48 04 11 20 12
	fsqrt.x	([2,A1,A2],4),FP1	; F2 31 48 84 A1 22 00
	fsqrt.x	([6,A2],D3,8),FP2	; F2 32 49 04 31 26 00
	fsqrt.x	(0x1234,PC,D1),FP3	; F2 3B 49 84 11 20 12
	fsqrt.x	([2,PC,A2],4),FP4	; F2 3B 4A 04 A1 22 FF
	fsqrt.x	([6,PC],D3,8),FP5	; F2 3B 4A 84 31 26 00

	fsqrt.p	(A1),FP2		; F2 11 4D 04
	fsqrt.p	(A2)+,FP3		; F2 1A 4D 84
	fsqrt.p	-(A3),FP4		; F2 23 4E 04
	fsqrt.p	1(A4),FP5		; F2 2C 4E 84 00 01
	fsqrt.p	2(A5,D7.W),FP6		; F2 35 4F 04 70 02
	fsqrt.p	2(A5,D7.L),FP6		; F2 35 4F 04 78 02
	fsqrt.p	(0x1234).W,FP7		; F2 38 4F 84 12 34
	fsqrt.p	(0x1234).L,FP7		; F2 39 4F 84 00 00 12
	fsqrt.p	*0xFFFFFFF0,FP0		; F2 38 4C 04 FF F0
	fsqrt.p	 0x00010004,FP1		; F2 39 4C 84 00 01 00
	fsqrt.p	5(PC),FP3		; F2 3A 4D 84 00 01
	fsqrt.p	6(PC,A7.W),FP4		; F2 3B 4E 04 F0 02
	fsqrt.p	6(PC,A7.L),FP4		; F2 3B 4E 04 F8 02
	fsqrt.p	(0x1234,A0,D1),FP0	; F2 30 4C 04 11 20 12
	fsqrt.p	([2,A1,A2],4),FP1	; F2 31 4C 84 A1 22 00
	fsqrt.p	([6,A2],D3,8),FP2	; F2 32 4D 04 31 26 00
	fsqrt.p	(0x1234,PC,D1),FP3	; F2 3B 4D 84 11 20 12
	fsqrt.p	([2,PC,A2],4),FP4	; F2 3B 4E 04 A1 22 FF
	fsqrt.p	([6,PC],D3,8),FP5	; F2 3B 4E 84 31 26 00

	flognp1	FP7			; F2 00 1F 86
	flognp1	FP1,FP2			; F2 00 05 06

	flognp1	(A1),FP2		; F2 11 49 06
	flognp1	(A2)+,FP3		; F2 1A 49 86
	flognp1	-(A3),FP4		; F2 23 4A 06
	flognp1	1(A4),FP5		; F2 2C 4A 86 00 01
	flognp1	2(A5,D7.W),FP6		; F2 35 4B 06 70 02
	flognp1	2(A5,D7.L),FP6		; F2 35 4B 06 78 02
	flognp1	(0x1234).W,FP7		; F2 38 4B 86 12 34
	flognp1	(0x1234).L,FP7		; F2 39 4B 86 00 00 12
	flognp1	*0xFFFFFFF0,FP0		; F2 38 48 06 FF F0
	flognp1	 0x00010004,FP1		; F2 39 48 86 00 01 00
	flognp1	5(PC),FP3		; F2 3A 49 86 00 01
	flognp1	6(PC,A7.W),FP4		; F2 3B 4A 06 F0 02
	flognp1	6(PC,A7.L),FP4		; F2 3B 4A 06 F8 02
	flognp1	(0x1234,A0,D1),FP0	; F2 30 48 06 11 20 12
	flognp1	([2,A1,A2],4),FP1	; F2 31 48 86 A1 22 00
	flognp1	([6,A2],D3,8),FP2	; F2 32 49 06 31 26 00
	flognp1	(0x1234,PC,D1),FP3	; F2 3B 49 86 11 20 12
	flognp1	([2,PC,A2],4),FP4	; F2 3B 4A 06 A1 22 FF
	flognp1	([6,PC],D3,8),FP5	; F2 3B 4A 86 31 26 00

	flognp1.b	D0,FP0		; F2 00 58 06
	flognp1.b	(A1),FP2	; F2 11 59 06
	flognp1.b	(A2)+,FP3	; F2 1A 59 86
	flognp1.b	-(A3),FP4	; F2 23 5A 06
	flognp1.b	1(A4),FP5	; F2 2C 5A 86 00 01
	flognp1.b	2(A5,D7.W),FP6	; F2 35 5B 06 70 02
	flognp1.b	2(A5,D7.L),FP6	; F2 35 5B 06 78 02
	flognp1.b	(0x1234).W,FP7	; F2 38 5B 86 12 34
	flognp1.b	(0x1234).L,FP7	; F2 39 5B 86 00 00 12
	flognp1.b	*0xFFFFFFF0,FP0	; F2 38 58 06 FF F0
	flognp1.b	 0x00010004,FP1	; F2 39 58 86 00 01 00
	flognp1.b	#7,FP2		; F2 3C 59 06 00 07
	flognp1.b	5(PC),FP3	; F2 3A 59 86 00 01
	flognp1.b	6(PC,A7.W),FP4	; F2 3B 5A 06 F0 02
	flognp1.b	6(PC,A7.L),FP4	; F2 3B 5A 06 F8 02
	flognp1.b	(0x1234,A0,D1),FP0	; F2 30 58 06 11 20 12
	flognp1.b	([2,A1,A2],4),FP1	; F2 31 58 86 A1 22 00
	flognp1.b	([6,A2],D3,8),FP2	; F2 32 59 06 31 26 00
	flognp1.b	(0x1234,PC,D1),FP3	; F2 3B 59 86 11 20 12
	flognp1.b	([2,PC,A2],4),FP4	; F2 3B 5A 06 A1 22 FF
	flognp1.b	([6,PC],D3,8),FP5	; F2 3B 5A 86 31 26 00

	flognp1.w	D0,FP0		; F2 00 50 06
	flognp1.w	(A1),FP2	; F2 11 51 06
	flognp1.w	(A2)+,FP3	; F2 1A 51 86
	flognp1.w	-(A3),FP4	; F2 23 52 06
	flognp1.w	1(A4),FP5	; F2 2C 52 86 00 01
	flognp1.w	2(A5,D7.W),FP6	; F2 35 53 06 70 02
	flognp1.w	2(A5,D7.L),FP6	; F2 35 53 06 78 02
	flognp1.w	(0x1234).W,FP7	; F2 38 53 86 12 34
	flognp1.w	(0x1234).L,FP7	; F2 39 53 86 00 00 12
	flognp1.w	*0xFFFFFFF0,FP0	; F2 38 50 06 FF F0
	flognp1.w	 0x00010004,FP1	; F2 39 50 86 00 01 00
	flognp1.w	#7,FP2		; F2 3C 51 06 00 07
	flognp1.w	5(PC),FP3	; F2 3A 51 86 00 01
	flognp1.w	6(PC,A7.W),FP4	; F2 3B 52 06 F0 02
	flognp1.w	6(PC,A7.L),FP4	; F2 3B 52 06 F8 02
	flognp1.w	(0x1234,A0,D1),FP0	; F2 30 50 06 11 20 12
	flognp1.w	([2,A1,A2],4),FP1	; F2 31 50 86 A1 22 00
	flognp1.w	([6,A2],D3,8),FP2	; F2 32 51 06 31 26 00
	flognp1.w	(0x1234,PC,D1),FP3	; F2 3B 51 86 11 20 12
	flognp1.w	([2,PC,A2],4),FP4	; F2 3B 52 06 A1 22 FF
	flognp1.w	([6,PC],D3,8),FP5	; F2 3B 52 86 31 26 00

	flognp1.l	D0,FP0		; F2 00 40 06
	flognp1.l	(A1),FP2	; F2 11 41 06
	flognp1.l	(A2)+,FP3	; F2 1A 41 86
	flognp1.l	-(A3),FP4	; F2 23 42 06
	flognp1.l	1(A4),FP5	; F2 2C 42 86 00 01
	flognp1.l	2(A5,D7.W),FP6	; F2 35 43 06 70 02
	flognp1.l	2(A5,D7.L),FP6	; F2 35 43 06 78 02
	flognp1.l	(0x1234).W,FP7	; F2 38 43 86 12 34
	flognp1.l	(0x1234).L,FP7	; F2 39 43 86 00 00 12
	flognp1.l	*0xFFFFFFF0,FP0	; F2 38 40 06 FF F0
	flognp1.l	 0x00010004,FP1	; F2 39 40 86 00 01 00
	flognp1.l	#7,FP2		; F2 3C 41 06 00 00 00
	flognp1.l	5(PC),FP3	; F2 3A 41 86 00 01
	flognp1.l	6(PC,A7.W),FP4	; F2 3B 42 06 F0 02
	flognp1.l	6(PC,A7.L),FP4	; F2 3B 42 06 F8 02
	flognp1.l	(0x1234,A0,D1),FP0	; F2 30 40 06 11 20 12
	flognp1.l	([2,A1,A2],4),FP1	; F2 31 40 86 A1 22 00
	flognp1.l	([6,A2],D3,8),FP2	; F2 32 41 06 31 26 00
	flognp1.l	(0x1234,PC,D1),FP3	; F2 3B 41 86 11 20 12
	flognp1.l	([2,PC,A2],4),FP4	; F2 3B 42 06 A1 22 FF
	flognp1.l	([6,PC],D3,8),FP5	; F2 3B 42 86 31 26 00

	flognp1.s	D0,FP0		; F2 00 44 06
	flognp1.s	(A1),FP2	; F2 11 45 06
	flognp1.s	(A2)+,FP3	; F2 1A 45 86
	flognp1.s	-(A3),FP4	; F2 23 46 06
	flognp1.s	1(A4),FP5	; F2 2C 46 86 00 01
	flognp1.s	2(A5,D7.W),FP6	; F2 35 47 06 70 02
	flognp1.s	2(A5,D7.L),FP6	; F2 35 47 06 78 02
	flognp1.s	(0x1234).W,FP7	; F2 38 47 86 12 34
	flognp1.s	(0x1234).L,FP7	; F2 39 47 86 00 00 12
	flognp1.s	*0xFFFFFFF0,FP0	; F2 38 44 06 FF F0
	flognp1.s	 0x00010004,FP1	; F2 39 44 86 00 01 00
	flognp1.s	#7,FP2		; F2 3C 45 06 40 E0 00
	flognp1.s	5(PC),FP3	; F2 3A 45 86 00 01
	flognp1.s	6(PC,A7.W),FP4	; F2 3B 46 06 F0 02
	flognp1.s	6(PC,A7.L),FP4	; F2 3B 46 06 F8 02
	flognp1.s	(0x1234,A0,D1),FP0	; F2 30 44 06 11 20 12
	flognp1.s	([2,A1,A2],4),FP1	; F2 31 44 86 A1 22 00
	flognp1.s	([6,A2],D3,8),FP2	; F2 32 45 06 31 26 00
	flognp1.s	(0x1234,PC,D1),FP3	; F2 3B 45 86 11 20 12
	flognp1.s	([2,PC,A2],4),FP4	; F2 3B 46 06 A1 22 FF
	flognp1.s	([6,PC],D3,8),FP5	; F2 3B 46 86 31 26 00

	flognp1.d	(A1),FP2	; F2 11 55 06
	flognp1.d	(A2)+,FP3	; F2 1A 55 86
	flognp1.d	-(A3),FP4	; F2 23 56 06
	flognp1.d	1(A4),FP5	; F2 2C 56 86 00 01
	flognp1.d	2(A5,D7.W),FP6	; F2 35 57 06 70 02
	flognp1.d	2(A5,D7.L),FP6	; F2 35 57 06 78 02
	flognp1.d	(0x1234).W,FP7	; F2 38 57 86 12 34
	flognp1.d	(0x1234).L,FP7	; F2 39 57 86 00 00 12
	flognp1.d	*0xFFFFFFF0,FP0	; F2 38 54 06 FF F0
	flognp1.d	 0x00010004,FP1	; F2 39 54 86 00 01 00
	flognp1.d	5(PC),FP3	; F2 3A 55 86 00 01
	flognp1.d	6(PC,A7.W),FP4	; F2 3B 56 06 F0 02
	flognp1.d	6(PC,A7.L),FP4	; F2 3B 56 06 F8 02
	flognp1.d	(0x1234,A0,D1),FP0	; F2 30 54 06 11 20 12
	flognp1.d	([2,A1,A2],4),FP1	; F2 31 54 86 A1 22 00
	flognp1.d	([6,A2],D3,8),FP2	; F2 32 55 06 31 26 00
	flognp1.d	(0x1234,PC,D1),FP3	; F2 3B 55 86 11 20 12
	flognp1.d	([2,PC,A2],4),FP4	; F2 3B 56 06 A1 22 FF
	flognp1.d	([6,PC],D3,8),FP5	; F2 3B 56 86 31 26 00

	flognp1.x	FP7		; F2 00 1F 86
	flognp1.x	FP1,FP2		; F2 00 05 06

	flognp1.x	(A1),FP2	; F2 11 49 06
	flognp1.x	(A2)+,FP3	; F2 1A 49 86
	flognp1.x	-(A3),FP4	; F2 23 4A 06
	flognp1.x	1(A4),FP5	; F2 2C 4A 86 00 01
	flognp1.x	2(A5,D7.W),FP6	; F2 35 4B 06 70 02
	flognp1.x	2(A5,D7.L),FP6	; F2 35 4B 06 78 02
	flognp1.x	(0x1234).W,FP7	; F2 38 4B 86 12 34
	flognp1.x	(0x1234).L,FP7	; F2 39 4B 86 00 00 12
	flognp1.x	*0xFFFFFFF0,FP0	; F2 38 48 06 FF F0
	flognp1.x	 0x00010004,FP1	; F2 39 48 86 00 01 00
	flognp1.x	5(PC),FP3	; F2 3A 49 86 00 01
	flognp1.x	6(PC,A7.W),FP4	; F2 3B 4A 06 F0 02
	flognp1.x	6(PC,A7.L),FP4	; F2 3B 4A 06 F8 02
	flognp1.x	(0x1234,A0,D1),FP0	; F2 30 48 06 11 20 12
	flognp1.x	([2,A1,A2],4),FP1	; F2 31 48 86 A1 22 00
	flognp1.x	([6,A2],D3,8),FP2	; F2 32 49 06 31 26 00
	flognp1.x	(0x1234,PC,D1),FP3	; F2 3B 49 86 11 20 12
	flognp1.x	([2,PC,A2],4),FP4	; F2 3B 4A 06 A1 22 FF
	flognp1.x	([6,PC],D3,8),FP5	; F2 3B 4A 86 31 26 00

	flognp1.p	(A1),FP2	; F2 11 4D 06
	flognp1.p	(A2)+,FP3	; F2 1A 4D 86
	flognp1.p	-(A3),FP4	; F2 23 4E 06
	flognp1.p	1(A4),FP5	; F2 2C 4E 86 00 01
	flognp1.p	2(A5,D7.W),FP6	; F2 35 4F 06 70 02
	flognp1.p	2(A5,D7.L),FP6	; F2 35 4F 06 78 02
	flognp1.p	(0x1234).W,FP7	; F2 38 4F 86 12 34
	flognp1.p	(0x1234).L,FP7	; F2 39 4F 86 00 00 12
	flognp1.p	*0xFFFFFFF0,FP0	; F2 38 4C 06 FF F0
	flognp1.p	 0x00010004,FP1	; F2 39 4C 86 00 01 00
	flognp1.p	5(PC),FP3	; F2 3A 4D 86 00 01
	flognp1.p	6(PC,A7.W),FP4	; F2 3B 4E 06 F0 02
	flognp1.p	6(PC,A7.L),FP4	; F2 3B 4E 06 F8 02
	flognp1.p	(0x1234,A0,D1),FP0	; F2 30 4C 06 11 20 12
	flognp1.p	([2,A1,A2],4),FP1	; F2 31 4C 86 A1 22 00
	flognp1.p	([6,A2],D3,8),FP2	; F2 32 4D 06 31 26 00
	flognp1.p	(0x1234,PC,D1),FP3	; F2 3B 4D 86 11 20 12
	flognp1.p	([2,PC,A2],4),FP4	; F2 3B 4E 06 A1 22 FF
	flognp1.p	([6,PC],D3,8),FP5	; F2 3B 4E 86 31 26 00

	fetoxm1	FP7			; F2 00 1F 88
	fetoxm1	FP1,FP2			; F2 00 05 08

	fetoxm1	(A1),FP2		; F2 11 49 08
	fetoxm1	(A2)+,FP3		; F2 1A 49 88
	fetoxm1	-(A3),FP4		; F2 23 4A 08
	fetoxm1	1(A4),FP5		; F2 2C 4A 88 00 01
	fetoxm1	2(A5,D7.W),FP6		; F2 35 4B 08 70 02
	fetoxm1	2(A5,D7.L),FP6		; F2 35 4B 08 78 02
	fetoxm1	(0x1234).W,FP7		; F2 38 4B 88 12 34
	fetoxm1	(0x1234).L,FP7		; F2 39 4B 88 00 00 12
	fetoxm1	*0xFFFFFFF0,FP0		; F2 38 48 08 FF F0
	fetoxm1	 0x00010004,FP1		; F2 39 48 88 00 01 00
	fetoxm1	5(PC),FP3		; F2 3A 49 88 00 01
	fetoxm1	6(PC,A7.W),FP4		; F2 3B 4A 08 F0 02
	fetoxm1	6(PC,A7.L),FP4		; F2 3B 4A 08 F8 02
	fetoxm1	(0x1234,A0,D1),FP0	; F2 30 48 08 11 20 12
	fetoxm1	([2,A1,A2],4),FP1	; F2 31 48 88 A1 22 00
	fetoxm1	([6,A2],D3,8),FP2	; F2 32 49 08 31 26 00
	fetoxm1	(0x1234,PC,D1),FP3	; F2 3B 49 88 11 20 12
	fetoxm1	([2,PC,A2],4),FP4	; F2 3B 4A 08 A1 22 FF
	fetoxm1	([6,PC],D3,8),FP5	; F2 3B 4A 88 31 26 00

	fetoxm1.b	D0,FP0		; F2 00 58 08
	fetoxm1.b	(A1),FP2	; F2 11 59 08
	fetoxm1.b	(A2)+,FP3	; F2 1A 59 88
	fetoxm1.b	-(A3),FP4	; F2 23 5A 08
	fetoxm1.b	1(A4),FP5	; F2 2C 5A 88 00 01
	fetoxm1.b	2(A5,D7.W),FP6	; F2 35 5B 08 70 02
	fetoxm1.b	2(A5,D7.L),FP6	; F2 35 5B 08 78 02
	fetoxm1.b	(0x1234).W,FP7	; F2 38 5B 88 12 34
	fetoxm1.b	(0x1234).L,FP7	; F2 39 5B 88 00 00 12
	fetoxm1.b	*0xFFFFFFF0,FP0	; F2 38 58 08 FF F0
	fetoxm1.b	 0x00010004,FP1	; F2 39 58 88 00 01 00
	fetoxm1.b	#7,FP2		; F2 3C 59 08 00 07
	fetoxm1.b	5(PC),FP3	; F2 3A 59 88 00 01
	fetoxm1.b	6(PC,A7.W),FP4	; F2 3B 5A 08 F0 02
	fetoxm1.b	6(PC,A7.L),FP4	; F2 3B 5A 08 F8 02
	fetoxm1.b	(0x1234,A0,D1),FP0	; F2 30 58 08 11 20 12
	fetoxm1.b	([2,A1,A2],4),FP1	; F2 31 58 88 A1 22 00
	fetoxm1.b	([6,A2],D3,8),FP2	; F2 32 59 08 31 26 00
	fetoxm1.b	(0x1234,PC,D1),FP3	; F2 3B 59 88 11 20 12
	fetoxm1.b	([2,PC,A2],4),FP4	; F2 3B 5A 08 A1 22 FF
	fetoxm1.b	([6,PC],D3,8),FP5	; F2 3B 5A 88 31 26 00

	fetoxm1.w	D0,FP0		; F2 00 50 08
	fetoxm1.w	(A1),FP2	; F2 11 51 08
	fetoxm1.w	(A2)+,FP3	; F2 1A 51 88
	fetoxm1.w	-(A3),FP4	; F2 23 52 08
	fetoxm1.w	1(A4),FP5	; F2 2C 52 88 00 01
	fetoxm1.w	2(A5,D7.W),FP6	; F2 35 53 08 70 02
	fetoxm1.w	2(A5,D7.L),FP6	; F2 35 53 08 78 02
	fetoxm1.w	(0x1234).W,FP7	; F2 38 53 88 12 34
	fetoxm1.w	(0x1234).L,FP7	; F2 39 53 88 00 00 12
	fetoxm1.w	*0xFFFFFFF0,FP0	; F2 38 50 08 FF F0
	fetoxm1.w	 0x00010004,FP1	; F2 39 50 88 00 01 00
	fetoxm1.w	#7,FP2		; F2 3C 51 08 00 07
	fetoxm1.w	5(PC),FP3	; F2 3A 51 88 00 01
	fetoxm1.w	6(PC,A7.W),FP4	; F2 3B 52 08 F0 02
	fetoxm1.w	6(PC,A7.L),FP4	; F2 3B 52 08 F8 02
	fetoxm1.w	(0x1234,A0,D1),FP0	; F2 30 50 08 11 20 12
	fetoxm1.w	([2,A1,A2],4),FP1	; F2 31 50 88 A1 22 00
	fetoxm1.w	([6,A2],D3,8),FP2	; F2 32 51 08 31 26 00
	fetoxm1.w	(0x1234,PC,D1),FP3	; F2 3B 51 88 11 20 12
	fetoxm1.w	([2,PC,A2],4),FP4	; F2 3B 52 08 A1 22 FF
	fetoxm1.w	([6,PC],D3,8),FP5	; F2 3B 52 88 31 26 00

	fetoxm1.l	D0,FP0		; F2 00 40 08
	fetoxm1.l	(A1),FP2	; F2 11 41 08
	fetoxm1.l	(A2)+,FP3	; F2 1A 41 88
	fetoxm1.l	-(A3),FP4	; F2 23 42 08
	fetoxm1.l	1(A4),FP5	; F2 2C 42 88 00 01
	fetoxm1.l	2(A5,D7.W),FP6	; F2 35 43 08 70 02
	fetoxm1.l	2(A5,D7.L),FP6	; F2 35 43 08 78 02
	fetoxm1.l	(0x1234).W,FP7	; F2 38 43 88 12 34
	fetoxm1.l	(0x1234).L,FP7	; F2 39 43 88 00 00 12
	fetoxm1.l	*0xFFFFFFF0,FP0	; F2 38 40 08 FF F0
	fetoxm1.l	 0x00010004,FP1	; F2 39 40 88 00 01 00
	fetoxm1.l	#7,FP2		; F2 3C 41 08 00 00 00
	fetoxm1.l	5(PC),FP3	; F2 3A 41 88 00 01
	fetoxm1.l	6(PC,A7.W),FP4	; F2 3B 42 08 F0 02
	fetoxm1.l	6(PC,A7.L),FP4	; F2 3B 42 08 F8 02
	fetoxm1.l	(0x1234,A0,D1),FP0	; F2 30 40 08 11 20 12
	fetoxm1.l	([2,A1,A2],4),FP1	; F2 31 40 88 A1 22 00
	fetoxm1.l	([6,A2],D3,8),FP2	; F2 32 41 08 31 26 00
	fetoxm1.l	(0x1234,PC,D1),FP3	; F2 3B 41 88 11 20 12
	fetoxm1.l	([2,PC,A2],4),FP4	; F2 3B 42 08 A1 22 FF
	fetoxm1.l	([6,PC],D3,8),FP5	; F2 3B 42 88 31 26 00

	fetoxm1.s	D0,FP0		; F2 00 44 08
	fetoxm1.s	(A1),FP2	; F2 11 45 08
	fetoxm1.s	(A2)+,FP3	; F2 1A 45 88
	fetoxm1.s	-(A3),FP4	; F2 23 46 08
	fetoxm1.s	1(A4),FP5	; F2 2C 46 88 00 01
	fetoxm1.s	2(A5,D7.W),FP6	; F2 35 47 08 70 02
	fetoxm1.s	2(A5,D7.L),FP6	; F2 35 47 08 78 02
	fetoxm1.s	(0x1234).W,FP7	; F2 38 47 88 12 34
	fetoxm1.s	(0x1234).L,FP7	; F2 39 47 88 00 00 12
	fetoxm1.s	*0xFFFFFFF0,FP0	; F2 38 44 08 FF F0
	fetoxm1.s	 0x00010004,FP1	; F2 39 44 88 00 01 00
	fetoxm1.s	#7,FP2		; F2 3C 45 08 40 E0 00
	fetoxm1.s	5(PC),FP3	; F2 3A 45 88 00 01
	fetoxm1.s	6(PC,A7.W),FP4	; F2 3B 46 08 F0 02
	fetoxm1.s	6(PC,A7.L),FP4	; F2 3B 46 08 F8 02
	fetoxm1.s	(0x1234,A0,D1),FP0	; F2 30 44 08 11 20 12
	fetoxm1.s	([2,A1,A2],4),FP1	; F2 31 44 88 A1 22 00
	fetoxm1.s	([6,A2],D3,8),FP2	; F2 32 45 08 31 26 00
	fetoxm1.s	(0x1234,PC,D1),FP3	; F2 3B 45 88 11 20 12
	fetoxm1.s	([2,PC,A2],4),FP4	; F2 3B 46 08 A1 22 FF
	fetoxm1.s	([6,PC],D3,8),FP5	; F2 3B 46 88 31 26 00

	fetoxm1.d	(A1),FP2	; F2 11 55 08
	fetoxm1.d	(A2)+,FP3	; F2 1A 55 88
	fetoxm1.d	-(A3),FP4	; F2 23 56 08
	fetoxm1.d	1(A4),FP5	; F2 2C 56 88 00 01
	fetoxm1.d	2(A5,D7.W),FP6	; F2 35 57 08 70 02
	fetoxm1.d	2(A5,D7.L),FP6	; F2 35 57 08 78 02
	fetoxm1.d	(0x1234).W,FP7	; F2 38 57 88 12 34
	fetoxm1.d	(0x1234).L,FP7	; F2 39 57 88 00 00 12
	fetoxm1.d	*0xFFFFFFF0,FP0	; F2 38 54 08 FF F0
	fetoxm1.d	 0x00010004,FP1	; F2 39 54 88 00 01 00
	fetoxm1.d	5(PC),FP3	; F2 3A 55 88 00 01
	fetoxm1.d	6(PC,A7.W),FP4	; F2 3B 56 08 F0 02
	fetoxm1.d	6(PC,A7.L),FP4	; F2 3B 56 08 F8 02
	fetoxm1.d	(0x1234,A0,D1),FP0	; F2 30 54 08 11 20 12
	fetoxm1.d	([2,A1,A2],4),FP1	; F2 31 54 88 A1 22 00
	fetoxm1.d	([6,A2],D3,8),FP2	; F2 32 55 08 31 26 00
	fetoxm1.d	(0x1234,PC,D1),FP3	; F2 3B 55 88 11 20 12
	fetoxm1.d	([2,PC,A2],4),FP4	; F2 3B 56 08 A1 22 FF
	fetoxm1.d	([6,PC],D3,8),FP5	; F2 3B 56 88 31 26 00

	fetoxm1.x	FP7		; F2 00 1F 88
	fetoxm1.x	FP1,FP2		; F2 00 05 08

	fetoxm1.x	(A1),FP2	; F2 11 49 08
	fetoxm1.x	(A2)+,FP3	; F2 1A 49 88
	fetoxm1.x	-(A3),FP4	; F2 23 4A 08
	fetoxm1.x	1(A4),FP5	; F2 2C 4A 88 00 01
	fetoxm1.x	2(A5,D7.W),FP6	; F2 35 4B 08 70 02
	fetoxm1.x	2(A5,D7.L),FP6	; F2 35 4B 08 78 02
	fetoxm1.x	(0x1234).W,FP7	; F2 38 4B 88 12 34
	fetoxm1.x	(0x1234).L,FP7	; F2 39 4B 88 00 00 12
	fetoxm1.x	*0xFFFFFFF0,FP0	; F2 38 48 08 FF F0
	fetoxm1.x	 0x00010004,FP1	; F2 39 48 88 00 01 00
	fetoxm1.x	5(PC),FP3	; F2 3A 49 88 00 01
	fetoxm1.x	6(PC,A7.W),FP4	; F2 3B 4A 08 F0 02
	fetoxm1.x	6(PC,A7.L),FP4	; F2 3B 4A 08 F8 02
	fetoxm1.x	(0x1234,A0,D1),FP0	; F2 30 48 08 11 20 12
	fetoxm1.x	([2,A1,A2],4),FP1	; F2 31 48 88 A1 22 00
	fetoxm1.x	([6,A2],D3,8),FP2	; F2 32 49 08 31 26 00
	fetoxm1.x	(0x1234,PC,D1),FP3	; F2 3B 49 88 11 20 12
	fetoxm1.x	([2,PC,A2],4),FP4	; F2 3B 4A 08 A1 22 FF
	fetoxm1.x	([6,PC],D3,8),FP5	; F2 3B 4A 88 31 26 00

	fetoxm1.p	(A1),FP2	; F2 11 4D 08
	fetoxm1.p	(A2)+,FP3	; F2 1A 4D 88
	fetoxm1.p	-(A3),FP4	; F2 23 4E 08
	fetoxm1.p	1(A4),FP5	; F2 2C 4E 88 00 01
	fetoxm1.p	2(A5,D7.W),FP6	; F2 35 4F 08 70 02
	fetoxm1.p	2(A5,D7.L),FP6	; F2 35 4F 08 78 02
	fetoxm1.p	(0x1234).W,FP7	; F2 38 4F 88 12 34
	fetoxm1.p	(0x1234).L,FP7	; F2 39 4F 88 00 00 12
	fetoxm1.p	*0xFFFFFFF0,FP0	; F2 38 4C 08 FF F0
	fetoxm1.p	 0x00010004,FP1	; F2 39 4C 88 00 01 00
	fetoxm1.p	5(PC),FP3	; F2 3A 4D 88 00 01
	fetoxm1.p	6(PC,A7.W),FP4	; F2 3B 4E 08 F0 02
	fetoxm1.p	6(PC,A7.L),FP4	; F2 3B 4E 08 F8 02
	fetoxm1.p	(0x1234,A0,D1),FP0	; F2 30 4C 08 11 20 12
	fetoxm1.p	([2,A1,A2],4),FP1	; F2 31 4C 88 A1 22 00
	fetoxm1.p	([6,A2],D3,8),FP2	; F2 32 4D 08 31 26 00
	fetoxm1.p	(0x1234,PC,D1),FP3	; F2 3B 4D 88 11 20 12
	fetoxm1.p	([2,PC,A2],4),FP4	; F2 3B 4E 08 A1 22 FF
	fetoxm1.p	([6,PC],D3,8),FP5	; F2 3B 4E 88 31 26 00

	ftanh	FP7			; F2 00 1F 89
	ftanh	FP1,FP2			; F2 00 05 09

	ftanh	(A1),FP2		; F2 11 49 09
	ftanh	(A2)+,FP3		; F2 1A 49 89
	ftanh	-(A3),FP4		; F2 23 4A 09
	ftanh	1(A4),FP5		; F2 2C 4A 89 00 01
	ftanh	2(A5,D7.W),FP6		; F2 35 4B 09 70 02
	ftanh	2(A5,D7.L),FP6		; F2 35 4B 09 78 02
	ftanh	(0x1234).W,FP7		; F2 38 4B 89 12 34
	ftanh	(0x1234).L,FP7		; F2 39 4B 89 00 00 12
	ftanh	*0xFFFFFFF0,FP0		; F2 38 48 09 FF F0
	ftanh	 0x00010004,FP1		; F2 39 48 89 00 01 00
	ftanh	5(PC),FP3		; F2 3A 49 89 00 01
	ftanh	6(PC,A7.W),FP4		; F2 3B 4A 09 F0 02
	ftanh	6(PC,A7.L),FP4		; F2 3B 4A 09 F8 02
	ftanh	(0x1234,A0,D1),FP0	; F2 30 48 09 11 20 12
	ftanh	([2,A1,A2],4),FP1	; F2 31 48 89 A1 22 00
	ftanh	([6,A2],D3,8),FP2	; F2 32 49 09 31 26 00
	ftanh	(0x1234,PC,D1),FP3	; F2 3B 49 89 11 20 12
	ftanh	([2,PC,A2],4),FP4	; F2 3B 4A 09 A1 22 FF
	ftanh	([6,PC],D3,8),FP5	; F2 3B 4A 89 31 26 00

	ftanh.b	D0,FP0			; F2 00 58 09
	ftanh.b	(A1),FP2		; F2 11 59 09
	ftanh.b	(A2)+,FP3		; F2 1A 59 89
	ftanh.b	-(A3),FP4		; F2 23 5A 09
	ftanh.b	1(A4),FP5		; F2 2C 5A 89 00 01
	ftanh.b	2(A5,D7.W),FP6		; F2 35 5B 09 70 02
	ftanh.b	2(A5,D7.L),FP6		; F2 35 5B 09 78 02
	ftanh.b	(0x1234).W,FP7		; F2 38 5B 89 12 34
	ftanh.b	(0x1234).L,FP7		; F2 39 5B 89 00 00 12
	ftanh.b	*0xFFFFFFF0,FP0		; F2 38 58 09 FF F0
	ftanh.b	 0x00010004,FP1		; F2 39 58 89 00 01 00
	ftanh.b	#7,FP2			; F2 3C 59 09 00 07
	ftanh.b	5(PC),FP3		; F2 3A 59 89 00 01
	ftanh.b	6(PC,A7.W),FP4		; F2 3B 5A 09 F0 02
	ftanh.b	6(PC,A7.L),FP4		; F2 3B 5A 09 F8 02
	ftanh.b	(0x1234,A0,D1),FP0	; F2 30 58 09 11 20 12
	ftanh.b	([2,A1,A2],4),FP1	; F2 31 58 89 A1 22 00
	ftanh.b	([6,A2],D3,8),FP2	; F2 32 59 09 31 26 00
	ftanh.b	(0x1234,PC,D1),FP3	; F2 3B 59 89 11 20 12
	ftanh.b	([2,PC,A2],4),FP4	; F2 3B 5A 09 A1 22 FF
	ftanh.b	([6,PC],D3,8),FP5	; F2 3B 5A 89 31 26 00

	ftanh.w	D0,FP0			; F2 00 50 09
	ftanh.w	(A1),FP2		; F2 11 51 09
	ftanh.w	(A2)+,FP3		; F2 1A 51 89
	ftanh.w	-(A3),FP4		; F2 23 52 09
	ftanh.w	1(A4),FP5		; F2 2C 52 89 00 01
	ftanh.w	2(A5,D7.W),FP6		; F2 35 53 09 70 02
	ftanh.w	2(A5,D7.L),FP6		; F2 35 53 09 78 02
	ftanh.w	(0x1234).W,FP7		; F2 38 53 89 12 34
	ftanh.w	(0x1234).L,FP7		; F2 39 53 89 00 00 12
	ftanh.w	*0xFFFFFFF0,FP0		; F2 38 50 09 FF F0
	ftanh.w	 0x00010004,FP1		; F2 39 50 89 00 01 00
	ftanh.w	#7,FP2			; F2 3C 51 09 00 07
	ftanh.w	5(PC),FP3		; F2 3A 51 89 00 01
	ftanh.w	6(PC,A7.W),FP4		; F2 3B 52 09 F0 02
	ftanh.w	6(PC,A7.L),FP4		; F2 3B 52 09 F8 02
	ftanh.w	(0x1234,A0,D1),FP0	; F2 30 50 09 11 20 12
	ftanh.w	([2,A1,A2],4),FP1	; F2 31 50 89 A1 22 00
	ftanh.w	([6,A2],D3,8),FP2	; F2 32 51 09 31 26 00
	ftanh.w	(0x1234,PC,D1),FP3	; F2 3B 51 89 11 20 12
	ftanh.w	([2,PC,A2],4),FP4	; F2 3B 52 09 A1 22 FF
	ftanh.w	([6,PC],D3,8),FP5	; F2 3B 52 89 31 26 00

	ftanh.l	D0,FP0			; F2 00 40 09
	ftanh.l	(A1),FP2		; F2 11 41 09
	ftanh.l	(A2)+,FP3		; F2 1A 41 89
	ftanh.l	-(A3),FP4		; F2 23 42 09
	ftanh.l	1(A4),FP5		; F2 2C 42 89 00 01
	ftanh.l	2(A5,D7.W),FP6		; F2 35 43 09 70 02
	ftanh.l	2(A5,D7.L),FP6		; F2 35 43 09 78 02
	ftanh.l	(0x1234).W,FP7		; F2 38 43 89 12 34
	ftanh.l	(0x1234).L,FP7		; F2 39 43 89 00 00 12
	ftanh.l	*0xFFFFFFF0,FP0		; F2 38 40 09 FF F0
	ftanh.l	 0x00010004,FP1		; F2 39 40 89 00 01 00
	ftanh.l	#7,FP2			; F2 3C 41 09 00 00 00
	ftanh.l	5(PC),FP3		; F2 3A 41 89 00 01
	ftanh.l	6(PC,A7.W),FP4		; F2 3B 42 09 F0 02
	ftanh.l	6(PC,A7.L),FP4		; F2 3B 42 09 F8 02
	ftanh.l	(0x1234,A0,D1),FP0	; F2 30 40 09 11 20 12
	ftanh.l	([2,A1,A2],4),FP1	; F2 31 40 89 A1 22 00
	ftanh.l	([6,A2],D3,8),FP2	; F2 32 41 09 31 26 00
	ftanh.l	(0x1234,PC,D1),FP3	; F2 3B 41 89 11 20 12
	ftanh.l	([2,PC,A2],4),FP4	; F2 3B 42 09 A1 22 FF
	ftanh.l	([6,PC],D3,8),FP5	; F2 3B 42 89 31 26 00

	ftanh.s	D0,FP0			; F2 00 44 09
	ftanh.s	(A1),FP2		; F2 11 45 09
	ftanh.s	(A2)+,FP3		; F2 1A 45 89
	ftanh.s	-(A3),FP4		; F2 23 46 09
	ftanh.s	1(A4),FP5		; F2 2C 46 89 00 01
	ftanh.s	2(A5,D7.W),FP6		; F2 35 47 09 70 02
	ftanh.s	2(A5,D7.L),FP6		; F2 35 47 09 78 02
	ftanh.s	(0x1234).W,FP7		; F2 38 47 89 12 34
	ftanh.s	(0x1234).L,FP7		; F2 39 47 89 00 00 12
	ftanh.s	*0xFFFFFFF0,FP0		; F2 38 44 09 FF F0
	ftanh.s	 0x00010004,FP1		; F2 39 44 89 00 01 00
	ftanh.s	#7,FP2			; F2 3C 45 09 40 E0 00
	ftanh.s	5(PC),FP3		; F2 3A 45 89 00 01
	ftanh.s	6(PC,A7.W),FP4		; F2 3B 46 09 F0 02
	ftanh.s	6(PC,A7.L),FP4		; F2 3B 46 09 F8 02
	ftanh.s	(0x1234,A0,D1),FP0	; F2 30 44 09 11 20 12
	ftanh.s	([2,A1,A2],4),FP1	; F2 31 44 89 A1 22 00
	ftanh.s	([6,A2],D3,8),FP2	; F2 32 45 09 31 26 00
	ftanh.s	(0x1234,PC,D1),FP3	; F2 3B 45 89 11 20 12
	ftanh.s	([2,PC,A2],4),FP4	; F2 3B 46 09 A1 22 FF
	ftanh.s	([6,PC],D3,8),FP5	; F2 3B 46 89 31 26 00

	ftanh.d	(A1),FP2		; F2 11 55 09
	ftanh.d	(A2)+,FP3		; F2 1A 55 89
	ftanh.d	-(A3),FP4		; F2 23 56 09
	ftanh.d	1(A4),FP5		; F2 2C 56 89 00 01
	ftanh.d	2(A5,D7.W),FP6		; F2 35 57 09 70 02
	ftanh.d	2(A5,D7.L),FP6		; F2 35 57 09 78 02
	ftanh.d	(0x1234).W,FP7		; F2 38 57 89 12 34
	ftanh.d	(0x1234).L,FP7		; F2 39 57 89 00 00 12
	ftanh.d	*0xFFFFFFF0,FP0		; F2 38 54 09 FF F0
	ftanh.d	 0x00010004,FP1		; F2 39 54 89 00 01 00
	ftanh.d	5(PC),FP3		; F2 3A 55 89 00 01
	ftanh.d	6(PC,A7.W),FP4		; F2 3B 56 09 F0 02
	ftanh.d	6(PC,A7.L),FP4		; F2 3B 56 09 F8 02
	ftanh.d	(0x1234,A0,D1),FP0	; F2 30 54 09 11 20 12
	ftanh.d	([2,A1,A2],4),FP1	; F2 31 54 89 A1 22 00
	ftanh.d	([6,A2],D3,8),FP2	; F2 32 55 09 31 26 00
	ftanh.d	(0x1234,PC,D1),FP3	; F2 3B 55 89 11 20 12
	ftanh.d	([2,PC,A2],4),FP4	; F2 3B 56 09 A1 22 FF
	ftanh.d	([6,PC],D3,8),FP5	; F2 3B 56 89 31 26 00

	ftanh.x	FP7			; F2 00 1F 89
	ftanh.x	FP1,FP2			; F2 00 05 09

	ftanh.x	(A1),FP2		; F2 11 49 09
	ftanh.x	(A2)+,FP3		; F2 1A 49 89
	ftanh.x	-(A3),FP4		; F2 23 4A 09
	ftanh.x	1(A4),FP5		; F2 2C 4A 89 00 01
	ftanh.x	2(A5,D7.W),FP6		; F2 35 4B 09 70 02
	ftanh.x	2(A5,D7.L),FP6		; F2 35 4B 09 78 02
	ftanh.x	(0x1234).W,FP7		; F2 38 4B 89 12 34
	ftanh.x	(0x1234).L,FP7		; F2 39 4B 89 00 00 12
	ftanh.x	*0xFFFFFFF0,FP0		; F2 38 48 09 FF F0
	ftanh.x	 0x00010004,FP1		; F2 39 48 89 00 01 00
	ftanh.x	5(PC),FP3		; F2 3A 49 89 00 01
	ftanh.x	6(PC,A7.W),FP4		; F2 3B 4A 09 F0 02
	ftanh.x	6(PC,A7.L),FP4		; F2 3B 4A 09 F8 02
	ftanh.x	(0x1234,A0,D1),FP0	; F2 30 48 09 11 20 12
	ftanh.x	([2,A1,A2],4),FP1	; F2 31 48 89 A1 22 00
	ftanh.x	([6,A2],D3,8),FP2	; F2 32 49 09 31 26 00
	ftanh.x	(0x1234,PC,D1),FP3	; F2 3B 49 89 11 20 12
	ftanh.x	([2,PC,A2],4),FP4	; F2 3B 4A 09 A1 22 FF
	ftanh.x	([6,PC],D3,8),FP5	; F2 3B 4A 89 31 26 00

	ftanh.p	(A1),FP2		; F2 11 4D 09
	ftanh.p	(A2)+,FP3		; F2 1A 4D 89
	ftanh.p	-(A3),FP4		; F2 23 4E 09
	ftanh.p	1(A4),FP5		; F2 2C 4E 89 00 01
	ftanh.p	2(A5,D7.W),FP6		; F2 35 4F 09 70 02
	ftanh.p	2(A5,D7.L),FP6		; F2 35 4F 09 78 02
	ftanh.p	(0x1234).W,FP7		; F2 38 4F 89 12 34
	ftanh.p	(0x1234).L,FP7		; F2 39 4F 89 00 00 12
	ftanh.p	*0xFFFFFFF0,FP0		; F2 38 4C 09 FF F0
	ftanh.p	 0x00010004,FP1		; F2 39 4C 89 00 01 00
	ftanh.p	5(PC),FP3		; F2 3A 4D 89 00 01
	ftanh.p	6(PC,A7.W),FP4		; F2 3B 4E 09 F0 02
	ftanh.p	6(PC,A7.L),FP4		; F2 3B 4E 09 F8 02
	ftanh.p	(0x1234,A0,D1),FP0	; F2 30 4C 09 11 20 12
	ftanh.p	([2,A1,A2],4),FP1	; F2 31 4C 89 A1 22 00
	ftanh.p	([6,A2],D3,8),FP2	; F2 32 4D 09 31 26 00
	ftanh.p	(0x1234,PC,D1),FP3	; F2 3B 4D 89 11 20 12
	ftanh.p	([2,PC,A2],4),FP4	; F2 3B 4E 09 A1 22 FF
	ftanh.p	([6,PC],D3,8),FP5	; F2 3B 4E 89 31 26 00

	fatan	FP7			; F2 00 1F 8A
	fatan	FP1,FP2			; F2 00 05 0A

	fatan	(A1),FP2		; F2 11 49 0A
	fatan	(A2)+,FP3		; F2 1A 49 8A
	fatan	-(A3),FP4		; F2 23 4A 0A
	fatan	1(A4),FP5		; F2 2C 4A 8A 00 01
	fatan	2(A5,D7.W),FP6		; F2 35 4B 0A 70 02
	fatan	2(A5,D7.L),FP6		; F2 35 4B 0A 78 02
	fatan	(0x1234).W,FP7		; F2 38 4B 8A 12 34
	fatan	(0x1234).L,FP7		; F2 39 4B 8A 00 00 12
	fatan	*0xFFFFFFF0,FP0		; F2 38 48 0A FF F0
	fatan	 0x00010004,FP1		; F2 39 48 8A 00 01 00
	fatan	5(PC),FP3		; F2 3A 49 8A 00 01
	fatan	6(PC,A7.W),FP4		; F2 3B 4A 0A F0 02
	fatan	6(PC,A7.L),FP4		; F2 3B 4A 0A F8 02
	fatan	(0x1234,A0,D1),FP0	; F2 30 48 0A 11 20 12
	fatan	([2,A1,A2],4),FP1	; F2 31 48 8A A1 22 00
	fatan	([6,A2],D3,8),FP2	; F2 32 49 0A 31 26 00
	fatan	(0x1234,PC,D1),FP3	; F2 3B 49 8A 11 20 12
	fatan	([2,PC,A2],4),FP4	; F2 3B 4A 0A A1 22 FF
	fatan	([6,PC],D3,8),FP5	; F2 3B 4A 8A 31 26 00

	fatan.b	D0,FP0			; F2 00 58 0A
	fatan.b	(A1),FP2		; F2 11 59 0A
	fatan.b	(A2)+,FP3		; F2 1A 59 8A
	fatan.b	-(A3),FP4		; F2 23 5A 0A
	fatan.b	1(A4),FP5		; F2 2C 5A 8A 00 01
	fatan.b	2(A5,D7.W),FP6		; F2 35 5B 0A 70 02
	fatan.b	2(A5,D7.L),FP6		; F2 35 5B 0A 78 02
	fatan.b	(0x1234).W,FP7		; F2 38 5B 8A 12 34
	fatan.b	(0x1234).L,FP7		; F2 39 5B 8A 00 00 12
	fatan.b	*0xFFFFFFF0,FP0		; F2 38 58 0A FF F0
	fatan.b	 0x00010004,FP1		; F2 39 58 8A 00 01 00
	fatan.b	#7,FP2			; F2 3C 59 0A 00 07
	fatan.b	5(PC),FP3		; F2 3A 59 8A 00 01
	fatan.b	6(PC,A7.W),FP4		; F2 3B 5A 0A F0 02
	fatan.b	6(PC,A7.L),FP4		; F2 3B 5A 0A F8 02
	fatan.b	(0x1234,A0,D1),FP0	; F2 30 58 0A 11 20 12
	fatan.b	([2,A1,A2],4),FP1	; F2 31 58 8A A1 22 00
	fatan.b	([6,A2],D3,8),FP2	; F2 32 59 0A 31 26 00
	fatan.b	(0x1234,PC,D1),FP3	; F2 3B 59 8A 11 20 12
	fatan.b	([2,PC,A2],4),FP4	; F2 3B 5A 0A A1 22 FF
	fatan.b	([6,PC],D3,8),FP5	; F2 3B 5A 8A 31 26 00

	fatan.w	D0,FP0			; F2 00 50 0A
	fatan.w	(A1),FP2		; F2 11 51 0A
	fatan.w	(A2)+,FP3		; F2 1A 51 8A
	fatan.w	-(A3),FP4		; F2 23 52 0A
	fatan.w	1(A4),FP5		; F2 2C 52 8A 00 01
	fatan.w	2(A5,D7.W),FP6		; F2 35 53 0A 70 02
	fatan.w	2(A5,D7.L),FP6		; F2 35 53 0A 78 02
	fatan.w	(0x1234).W,FP7		; F2 38 53 8A 12 34
	fatan.w	(0x1234).L,FP7		; F2 39 53 8A 00 00 12
	fatan.w	*0xFFFFFFF0,FP0		; F2 38 50 0A FF F0
	fatan.w	 0x00010004,FP1		; F2 39 50 8A 00 01 00
	fatan.w	#7,FP2			; F2 3C 51 0A 00 07
	fatan.w	5(PC),FP3		; F2 3A 51 8A 00 01
	fatan.w	6(PC,A7.W),FP4		; F2 3B 52 0A F0 02
	fatan.w	6(PC,A7.L),FP4		; F2 3B 52 0A F8 02
	fatan.w	(0x1234,A0,D1),FP0	; F2 30 50 0A 11 20 12
	fatan.w	([2,A1,A2],4),FP1	; F2 31 50 8A A1 22 00
	fatan.w	([6,A2],D3,8),FP2	; F2 32 51 0A 31 26 00
	fatan.w	(0x1234,PC,D1),FP3	; F2 3B 51 8A 11 20 12
	fatan.w	([2,PC,A2],4),FP4	; F2 3B 52 0A A1 22 FF
	fatan.w	([6,PC],D3,8),FP5	; F2 3B 52 8A 31 26 00

	fatan.l	D0,FP0			; F2 00 40 0A
	fatan.l	(A1),FP2		; F2 11 41 0A
	fatan.l	(A2)+,FP3		; F2 1A 41 8A
	fatan.l	-(A3),FP4		; F2 23 42 0A
	fatan.l	1(A4),FP5		; F2 2C 42 8A 00 01
	fatan.l	2(A5,D7.W),FP6		; F2 35 43 0A 70 02
	fatan.l	2(A5,D7.L),FP6		; F2 35 43 0A 78 02
	fatan.l	(0x1234).W,FP7		; F2 38 43 8A 12 34
	fatan.l	(0x1234).L,FP7		; F2 39 43 8A 00 00 12
	fatan.l	*0xFFFFFFF0,FP0		; F2 38 40 0A FF F0
	fatan.l	 0x00010004,FP1		; F2 39 40 8A 00 01 00
	fatan.l	#7,FP2			; F2 3C 41 0A 00 00 00
	fatan.l	5(PC),FP3		; F2 3A 41 8A 00 01
	fatan.l	6(PC,A7.W),FP4		; F2 3B 42 0A F0 02
	fatan.l	6(PC,A7.L),FP4		; F2 3B 42 0A F8 02
	fatan.l	(0x1234,A0,D1),FP0	; F2 30 40 0A 11 20 12
	fatan.l	([2,A1,A2],4),FP1	; F2 31 40 8A A1 22 00
	fatan.l	([6,A2],D3,8),FP2	; F2 32 41 0A 31 26 00
	fatan.l	(0x1234,PC,D1),FP3	; F2 3B 41 8A 11 20 12
	fatan.l	([2,PC,A2],4),FP4	; F2 3B 42 0A A1 22 FF
	fatan.l	([6,PC],D3,8),FP5	; F2 3B 42 8A 31 26 00

	fatan.s	D0,FP0			; F2 00 44 0A
	fatan.s	(A1),FP2		; F2 11 45 0A
	fatan.s	(A2)+,FP3		; F2 1A 45 8A
	fatan.s	-(A3),FP4		; F2 23 46 0A
	fatan.s	1(A4),FP5		; F2 2C 46 8A 00 01
	fatan.s	2(A5,D7.W),FP6		; F2 35 47 0A 70 02
	fatan.s	2(A5,D7.L),FP6		; F2 35 47 0A 78 02
	fatan.s	(0x1234).W,FP7		; F2 38 47 8A 12 34
	fatan.s	(0x1234).L,FP7		; F2 39 47 8A 00 00 12
	fatan.s	*0xFFFFFFF0,FP0		; F2 38 44 0A FF F0
	fatan.s	 0x00010004,FP1		; F2 39 44 8A 00 01 00
	fatan.s	#7,FP2			; F2 3C 45 0A 40 E0 00
	fatan.s	5(PC),FP3		; F2 3A 45 8A 00 01
	fatan.s	6(PC,A7.W),FP4		; F2 3B 46 0A F0 02
	fatan.s	6(PC,A7.L),FP4		; F2 3B 46 0A F8 02
	fatan.s	(0x1234,A0,D1),FP0	; F2 30 44 0A 11 20 12
	fatan.s	([2,A1,A2],4),FP1	; F2 31 44 8A A1 22 00
	fatan.s	([6,A2],D3,8),FP2	; F2 32 45 0A 31 26 00
	fatan.s	(0x1234,PC,D1),FP3	; F2 3B 45 8A 11 20 12
	fatan.s	([2,PC,A2],4),FP4	; F2 3B 46 0A A1 22 FF
	fatan.s	([6,PC],D3,8),FP5	; F2 3B 46 8A 31 26 00

	fatan.d	(A1),FP2		; F2 11 55 0A
	fatan.d	(A2)+,FP3		; F2 1A 55 8A
	fatan.d	-(A3),FP4		; F2 23 56 0A
	fatan.d	1(A4),FP5		; F2 2C 56 8A 00 01
	fatan.d	2(A5,D7.W),FP6		; F2 35 57 0A 70 02
	fatan.d	2(A5,D7.L),FP6		; F2 35 57 0A 78 02
	fatan.d	(0x1234).W,FP7		; F2 38 57 8A 12 34
	fatan.d	(0x1234).L,FP7		; F2 39 57 8A 00 00 12
	fatan.d	*0xFFFFFFF0,FP0		; F2 38 54 0A FF F0
	fatan.d	 0x00010004,FP1		; F2 39 54 8A 00 01 00
	fatan.d	5(PC),FP3		; F2 3A 55 8A 00 01
	fatan.d	6(PC,A7.W),FP4		; F2 3B 56 0A F0 02
	fatan.d	6(PC,A7.L),FP4		; F2 3B 56 0A F8 02
	fatan.d	(0x1234,A0,D1),FP0	; F2 30 54 0A 11 20 12
	fatan.d	([2,A1,A2],4),FP1	; F2 31 54 8A A1 22 00
	fatan.d	([6,A2],D3,8),FP2	; F2 32 55 0A 31 26 00
	fatan.d	(0x1234,PC,D1),FP3	; F2 3B 55 8A 11 20 12
	fatan.d	([2,PC,A2],4),FP4	; F2 3B 56 0A A1 22 FF
	fatan.d	([6,PC],D3,8),FP5	; F2 3B 56 8A 31 26 00

	fatan.x	FP7			; F2 00 1F 8A
	fatan.x	FP1,FP2			; F2 00 05 0A

	fatan.x	(A1),FP2		; F2 11 49 0A
	fatan.x	(A2)+,FP3		; F2 1A 49 8A
	fatan.x	-(A3),FP4		; F2 23 4A 0A
	fatan.x	1(A4),FP5		; F2 2C 4A 8A 00 01
	fatan.x	2(A5,D7.W),FP6		; F2 35 4B 0A 70 02
	fatan.x	2(A5,D7.L),FP6		; F2 35 4B 0A 78 02
	fatan.x	(0x1234).W,FP7		; F2 38 4B 8A 12 34
	fatan.x	(0x1234).L,FP7		; F2 39 4B 8A 00 00 12
	fatan.x	*0xFFFFFFF0,FP0		; F2 38 48 0A FF F0
	fatan.x	 0x00010004,FP1		; F2 39 48 8A 00 01 00
	fatan.x	5(PC),FP3		; F2 3A 49 8A 00 01
	fatan.x	6(PC,A7.W),FP4		; F2 3B 4A 0A F0 02
	fatan.x	6(PC,A7.L),FP4		; F2 3B 4A 0A F8 02
	fatan.x	(0x1234,A0,D1),FP0	; F2 30 48 0A 11 20 12
	fatan.x	([2,A1,A2],4),FP1	; F2 31 48 8A A1 22 00
	fatan.x	([6,A2],D3,8),FP2	; F2 32 49 0A 31 26 00
	fatan.x	(0x1234,PC,D1),FP3	; F2 3B 49 8A 11 20 12
	fatan.x	([2,PC,A2],4),FP4	; F2 3B 4A 0A A1 22 FF
	fatan.x	([6,PC],D3,8),FP5	; F2 3B 4A 8A 31 26 00

	fatan.p	(A1),FP2		; F2 11 4D 0A
	fatan.p	(A2)+,FP3		; F2 1A 4D 8A
	fatan.p	-(A3),FP4		; F2 23 4E 0A
	fatan.p	1(A4),FP5		; F2 2C 4E 8A 00 01
	fatan.p	2(A5,D7.W),FP6		; F2 35 4F 0A 70 02
	fatan.p	2(A5,D7.L),FP6		; F2 35 4F 0A 78 02
	fatan.p	(0x1234).W,FP7		; F2 38 4F 8A 12 34
	fatan.p	(0x1234).L,FP7		; F2 39 4F 8A 00 00 12
	fatan.p	*0xFFFFFFF0,FP0		; F2 38 4C 0A FF F0
	fatan.p	 0x00010004,FP1		; F2 39 4C 8A 00 01 00
	fatan.p	5(PC),FP3		; F2 3A 4D 8A 00 01
	fatan.p	6(PC,A7.W),FP4		; F2 3B 4E 0A F0 02
	fatan.p	6(PC,A7.L),FP4		; F2 3B 4E 0A F8 02
	fatan.p	(0x1234,A0,D1),FP0	; F2 30 4C 0A 11 20 12
	fatan.p	([2,A1,A2],4),FP1	; F2 31 4C 8A A1 22 00
	fatan.p	([6,A2],D3,8),FP2	; F2 32 4D 0A 31 26 00
	fatan.p	(0x1234,PC,D1),FP3	; F2 3B 4D 8A 11 20 12
	fatan.p	([2,PC,A2],4),FP4	; F2 3B 4E 0A A1 22 FF
	fatan.p	([6,PC],D3,8),FP5	; F2 3B 4E 8A 31 26 00

	fasin	FP7			; F2 00 1F 8C
	fasin	FP1,FP2			; F2 00 05 0C

	fasin	(A1),FP2		; F2 11 49 0C
	fasin	(A2)+,FP3		; F2 1A 49 8C
	fasin	-(A3),FP4		; F2 23 4A 0C
	fasin	1(A4),FP5		; F2 2C 4A 8C 00 01
	fasin	2(A5,D7.W),FP6		; F2 35 4B 0C 70 02
	fasin	2(A5,D7.L),FP6		; F2 35 4B 0C 78 02
	fasin	(0x1234).W,FP7		; F2 38 4B 8C 12 34
	fasin	(0x1234).L,FP7		; F2 39 4B 8C 00 00 12
	fasin	*0xFFFFFFF0,FP0		; F2 38 48 0C FF F0
	fasin	 0x00010004,FP1		; F2 39 48 8C 00 01 00
	fasin	5(PC),FP3		; F2 3A 49 8C 00 01
	fasin	6(PC,A7.W),FP4		; F2 3B 4A 0C F0 02
	fasin	6(PC,A7.L),FP4		; F2 3B 4A 0C F8 02
	fasin	(0x1234,A0,D1),FP0	; F2 30 48 0C 11 20 12
	fasin	([2,A1,A2],4),FP1	; F2 31 48 8C A1 22 00
	fasin	([6,A2],D3,8),FP2	; F2 32 49 0C 31 26 00
	fasin	(0x1234,PC,D1),FP3	; F2 3B 49 8C 11 20 12
	fasin	([2,PC,A2],4),FP4	; F2 3B 4A 0C A1 22 FF
	fasin	([6,PC],D3,8),FP5	; F2 3B 4A 8C 31 26 00

	fasin.b	D0,FP0			; F2 00 58 0C
	fasin.b	(A1),FP2		; F2 11 59 0C
	fasin.b	(A2)+,FP3		; F2 1A 59 8C
	fasin.b	-(A3),FP4		; F2 23 5A 0C
	fasin.b	1(A4),FP5		; F2 2C 5A 8C 00 01
	fasin.b	2(A5,D7.W),FP6		; F2 35 5B 0C 70 02
	fasin.b	2(A5,D7.L),FP6		; F2 35 5B 0C 78 02
	fasin.b	(0x1234).W,FP7		; F2 38 5B 8C 12 34
	fasin.b	(0x1234).L,FP7		; F2 39 5B 8C 00 00 12
	fasin.b	*0xFFFFFFF0,FP0		; F2 38 58 0C FF F0
	fasin.b	 0x00010004,FP1		; F2 39 58 8C 00 01 00
	fasin.b	#7,FP2			; F2 3C 59 0C 00 07
	fasin.b	5(PC),FP3		; F2 3A 59 8C 00 01
	fasin.b	6(PC,A7.W),FP4		; F2 3B 5A 0C F0 02
	fasin.b	6(PC,A7.L),FP4		; F2 3B 5A 0C F8 02
	fasin.b	(0x1234,A0,D1),FP0	; F2 30 58 0C 11 20 12
	fasin.b	([2,A1,A2],4),FP1	; F2 31 58 8C A1 22 00
	fasin.b	([6,A2],D3,8),FP2	; F2 32 59 0C 31 26 00
	fasin.b	(0x1234,PC,D1),FP3	; F2 3B 59 8C 11 20 12
	fasin.b	([2,PC,A2],4),FP4	; F2 3B 5A 0C A1 22 FF
	fasin.b	([6,PC],D3,8),FP5	; F2 3B 5A 8C 31 26 00

	fasin.w	D0,FP0			; F2 00 50 0C
	fasin.w	(A1),FP2		; F2 11 51 0C
	fasin.w	(A2)+,FP3		; F2 1A 51 8C
	fasin.w	-(A3),FP4		; F2 23 52 0C
	fasin.w	1(A4),FP5		; F2 2C 52 8C 00 01
	fasin.w	2(A5,D7.W),FP6		; F2 35 53 0C 70 02
	fasin.w	2(A5,D7.L),FP6		; F2 35 53 0C 78 02
	fasin.w	(0x1234).W,FP7		; F2 38 53 8C 12 34
	fasin.w	(0x1234).L,FP7		; F2 39 53 8C 00 00 12
	fasin.w	*0xFFFFFFF0,FP0		; F2 38 50 0C FF F0
	fasin.w	 0x00010004,FP1		; F2 39 50 8C 00 01 00
	fasin.w	#7,FP2			; F2 3C 51 0C 00 07
	fasin.w	5(PC),FP3		; F2 3A 51 8C 00 01
	fasin.w	6(PC,A7.W),FP4		; F2 3B 52 0C F0 02
	fasin.w	6(PC,A7.L),FP4		; F2 3B 52 0C F8 02
	fasin.w	(0x1234,A0,D1),FP0	; F2 30 50 0C 11 20 12
	fasin.w	([2,A1,A2],4),FP1	; F2 31 50 8C A1 22 00
	fasin.w	([6,A2],D3,8),FP2	; F2 32 51 0C 31 26 00
	fasin.w	(0x1234,PC,D1),FP3	; F2 3B 51 8C 11 20 12
	fasin.w	([2,PC,A2],4),FP4	; F2 3B 52 0C A1 22 FF
	fasin.w	([6,PC],D3,8),FP5	; F2 3B 52 8C 31 26 00

	fasin.l	D0,FP0			; F2 00 40 0C
	fasin.l	(A1),FP2		; F2 11 41 0C
	fasin.l	(A2)+,FP3		; F2 1A 41 8C
	fasin.l	-(A3),FP4		; F2 23 42 0C
	fasin.l	1(A4),FP5		; F2 2C 42 8C 00 01
	fasin.l	2(A5,D7.W),FP6		; F2 35 43 0C 70 02
	fasin.l	2(A5,D7.L),FP6		; F2 35 43 0C 78 02
	fasin.l	(0x1234).W,FP7		; F2 38 43 8C 12 34
	fasin.l	(0x1234).L,FP7		; F2 39 43 8C 00 00 12
	fasin.l	*0xFFFFFFF0,FP0		; F2 38 40 0C FF F0
	fasin.l	 0x00010004,FP1		; F2 39 40 8C 00 01 00
	fasin.l	#7,FP2			; F2 3C 41 0C 00 00 00
	fasin.l	5(PC),FP3		; F2 3A 41 8C 00 01
	fasin.l	6(PC,A7.W),FP4		; F2 3B 42 0C F0 02
	fasin.l	6(PC,A7.L),FP4		; F2 3B 42 0C F8 02
	fasin.l	(0x1234,A0,D1),FP0	; F2 30 40 0C 11 20 12
	fasin.l	([2,A1,A2],4),FP1	; F2 31 40 8C A1 22 00
	fasin.l	([6,A2],D3,8),FP2	; F2 32 41 0C 31 26 00
	fasin.l	(0x1234,PC,D1),FP3	; F2 3B 41 8C 11 20 12
	fasin.l	([2,PC,A2],4),FP4	; F2 3B 42 0C A1 22 FF
	fasin.l	([6,PC],D3,8),FP5	; F2 3B 42 8C 31 26 00

	fasin.s	D0,FP0			; F2 00 44 0C
	fasin.s	(A1),FP2		; F2 11 45 0C
	fasin.s	(A2)+,FP3		; F2 1A 45 8C
	fasin.s	-(A3),FP4		; F2 23 46 0C
	fasin.s	1(A4),FP5		; F2 2C 46 8C 00 01
	fasin.s	2(A5,D7.W),FP6		; F2 35 47 0C 70 02
	fasin.s	2(A5,D7.L),FP6		; F2 35 47 0C 78 02
	fasin.s	(0x1234).W,FP7		; F2 38 47 8C 12 34
	fasin.s	(0x1234).L,FP7		; F2 39 47 8C 00 00 12
	fasin.s	*0xFFFFFFF0,FP0		; F2 38 44 0C FF F0
	fasin.s	 0x00010004,FP1		; F2 39 44 8C 00 01 00
	fasin.s	#7,FP2			; F2 3C 45 0C 40 E0 00
	fasin.s	5(PC),FP3		; F2 3A 45 8C 00 01
	fasin.s	6(PC,A7.W),FP4		; F2 3B 46 0C F0 02
	fasin.s	6(PC,A7.L),FP4		; F2 3B 46 0C F8 02
	fasin.s	(0x1234,A0,D1),FP0	; F2 30 44 0C 11 20 12
	fasin.s	([2,A1,A2],4),FP1	; F2 31 44 8C A1 22 00
	fasin.s	([6,A2],D3,8),FP2	; F2 32 45 0C 31 26 00
	fasin.s	(0x1234,PC,D1),FP3	; F2 3B 45 8C 11 20 12
	fasin.s	([2,PC,A2],4),FP4	; F2 3B 46 0C A1 22 FF
	fasin.s	([6,PC],D3,8),FP5	; F2 3B 46 8C 31 26 00

	fasin.d	(A1),FP2		; F2 11 55 0C
	fasin.d	(A2)+,FP3		; F2 1A 55 8C
	fasin.d	-(A3),FP4		; F2 23 56 0C
	fasin.d	1(A4),FP5		; F2 2C 56 8C 00 01
	fasin.d	2(A5,D7.W),FP6		; F2 35 57 0C 70 02
	fasin.d	2(A5,D7.L),FP6		; F2 35 57 0C 78 02
	fasin.d	(0x1234).W,FP7		; F2 38 57 8C 12 34
	fasin.d	(0x1234).L,FP7		; F2 39 57 8C 00 00 12
	fasin.d	*0xFFFFFFF0,FP0		; F2 38 54 0C FF F0
	fasin.d	 0x00010004,FP1		; F2 39 54 8C 00 01 00
	fasin.d	5(PC),FP3		; F2 3A 55 8C 00 01
	fasin.d	6(PC,A7.W),FP4		; F2 3B 56 0C F0 02
	fasin.d	6(PC,A7.L),FP4		; F2 3B 56 0C F8 02
	fasin.d	(0x1234,A0,D1),FP0	; F2 30 54 0C 11 20 12
	fasin.d	([2,A1,A2],4),FP1	; F2 31 54 8C A1 22 00
	fasin.d	([6,A2],D3,8),FP2	; F2 32 55 0C 31 26 00
	fasin.d	(0x1234,PC,D1),FP3	; F2 3B 55 8C 11 20 12
	fasin.d	([2,PC,A2],4),FP4	; F2 3B 56 0C A1 22 FF
	fasin.d	([6,PC],D3,8),FP5	; F2 3B 56 8C 31 26 00

	fasin.x	FP7			; F2 00 1F 8C
	fasin.x	FP1,FP2			; F2 00 05 0C

	fasin.x	(A1),FP2		; F2 11 49 0C
	fasin.x	(A2)+,FP3		; F2 1A 49 8C
	fasin.x	-(A3),FP4		; F2 23 4A 0C
	fasin.x	1(A4),FP5		; F2 2C 4A 8C 00 01
	fasin.x	2(A5,D7.W),FP6		; F2 35 4B 0C 70 02
	fasin.x	2(A5,D7.L),FP6		; F2 35 4B 0C 78 02
	fasin.x	(0x1234).W,FP7		; F2 38 4B 8C 12 34
	fasin.x	(0x1234).L,FP7		; F2 39 4B 8C 00 00 12
	fasin.x	*0xFFFFFFF0,FP0		; F2 38 48 0C FF F0
	fasin.x	 0x00010004,FP1		; F2 39 48 8C 00 01 00
	fasin.x	5(PC),FP3		; F2 3A 49 8C 00 01
	fasin.x	6(PC,A7.W),FP4		; F2 3B 4A 0C F0 02
	fasin.x	6(PC,A7.L),FP4		; F2 3B 4A 0C F8 02
	fasin.x	(0x1234,A0,D1),FP0	; F2 30 48 0C 11 20 12
	fasin.x	([2,A1,A2],4),FP1	; F2 31 48 8C A1 22 00
	fasin.x	([6,A2],D3,8),FP2	; F2 32 49 0C 31 26 00
	fasin.x	(0x1234,PC,D1),FP3	; F2 3B 49 8C 11 20 12
	fasin.x	([2,PC,A2],4),FP4	; F2 3B 4A 0C A1 22 FF
	fasin.x	([6,PC],D3,8),FP5	; F2 3B 4A 8C 31 26 00

	fasin.p	(A1),FP2		; F2 11 4D 0C
	fasin.p	(A2)+,FP3		; F2 1A 4D 8C
	fasin.p	-(A3),FP4		; F2 23 4E 0C
	fasin.p	1(A4),FP5		; F2 2C 4E 8C 00 01
	fasin.p	2(A5,D7.W),FP6		; F2 35 4F 0C 70 02
	fasin.p	2(A5,D7.L),FP6		; F2 35 4F 0C 78 02
	fasin.p	(0x1234).W,FP7		; F2 38 4F 8C 12 34
	fasin.p	(0x1234).L,FP7		; F2 39 4F 8C 00 00 12
	fasin.p	*0xFFFFFFF0,FP0		; F2 38 4C 0C FF F0
	fasin.p	 0x00010004,FP1		; F2 39 4C 8C 00 01 00
	fasin.p	5(PC),FP3		; F2 3A 4D 8C 00 01
	fasin.p	6(PC,A7.W),FP4		; F2 3B 4E 0C F0 02
	fasin.p	6(PC,A7.L),FP4		; F2 3B 4E 0C F8 02
	fasin.p	(0x1234,A0,D1),FP0	; F2 30 4C 0C 11 20 12
	fasin.p	([2,A1,A2],4),FP1	; F2 31 4C 8C A1 22 00
	fasin.p	([6,A2],D3,8),FP2	; F2 32 4D 0C 31 26 00
	fasin.p	(0x1234,PC,D1),FP3	; F2 3B 4D 8C 11 20 12
	fasin.p	([2,PC,A2],4),FP4	; F2 3B 4E 0C A1 22 FF
	fasin.p	([6,PC],D3,8),FP5	; F2 3B 4E 8C 31 26 00

	fatanh	FP7			; F2 00 1F 8D
	fatanh	FP1,FP2			; F2 00 05 0D

	fatanh	(A1),FP2		; F2 11 49 0D
	fatanh	(A2)+,FP3		; F2 1A 49 8D
	fatanh	-(A3),FP4		; F2 23 4A 0D
	fatanh	1(A4),FP5		; F2 2C 4A 8D 00 01
	fatanh	2(A5,D7.W),FP6		; F2 35 4B 0D 70 02
	fatanh	2(A5,D7.L),FP6		; F2 35 4B 0D 78 02
	fatanh	(0x1234).W,FP7		; F2 38 4B 8D 12 34
	fatanh	(0x1234).L,FP7		; F2 39 4B 8D 00 00 12
	fatanh	*0xFFFFFFF0,FP0		; F2 38 48 0D FF F0
	fatanh	 0x00010004,FP1		; F2 39 48 8D 00 01 00
	fatanh	5(PC),FP3		; F2 3A 49 8D 00 01
	fatanh	6(PC,A7.W),FP4		; F2 3B 4A 0D F0 02
	fatanh	6(PC,A7.L),FP4		; F2 3B 4A 0D F8 02
	fatanh	(0x1234,A0,D1),FP0	; F2 30 48 0D 11 20 12
	fatanh	([2,A1,A2],4),FP1	; F2 31 48 8D A1 22 00
	fatanh	([6,A2],D3,8),FP2	; F2 32 49 0D 31 26 00
	fatanh	(0x1234,PC,D1),FP3	; F2 3B 49 8D 11 20 12
	fatanh	([2,PC,A2],4),FP4	; F2 3B 4A 0D A1 22 FF
	fatanh	([6,PC],D3,8),FP5	; F2 3B 4A 8D 31 26 00

	fatanh.b	D0,FP0		; F2 00 58 0D
	fatanh.b	(A1),FP2	; F2 11 59 0D
	fatanh.b	(A2)+,FP3	; F2 1A 59 8D
	fatanh.b	-(A3),FP4	; F2 23 5A 0D
	fatanh.b	1(A4),FP5	; F2 2C 5A 8D 00 01
	fatanh.b	2(A5,D7.W),FP6	; F2 35 5B 0D 70 02
	fatanh.b	2(A5,D7.L),FP6	; F2 35 5B 0D 78 02
	fatanh.b	(0x1234).W,FP7	; F2 38 5B 8D 12 34
	fatanh.b	(0x1234).L,FP7	; F2 39 5B 8D 00 00 12
	fatanh.b	*0xFFFFFFF0,FP0	; F2 38 58 0D FF F0
	fatanh.b	 0x00010004,FP1	; F2 39 58 8D 00 01 00
	fatanh.b	#7,FP2		; F2 3C 59 0D 00 07
	fatanh.b	5(PC),FP3	; F2 3A 59 8D 00 01
	fatanh.b	6(PC,A7.W),FP4	; F2 3B 5A 0D F0 02
	fatanh.b	6(PC,A7.L),FP4	; F2 3B 5A 0D F8 02
	fatanh.b	(0x1234,A0,D1),FP0	; F2 30 58 0D 11 20 12
	fatanh.b	([2,A1,A2],4),FP1	; F2 31 58 8D A1 22 00
	fatanh.b	([6,A2],D3,8),FP2	; F2 32 59 0D 31 26 00
	fatanh.b	(0x1234,PC,D1),FP3	; F2 3B 59 8D 11 20 12
	fatanh.b	([2,PC,A2],4),FP4	; F2 3B 5A 0D A1 22 FF
	fatanh.b	([6,PC],D3,8),FP5	; F2 3B 5A 8D 31 26 00

	fatanh.w	D0,FP0		; F2 00 50 0D
	fatanh.w	(A1),FP2	; F2 11 51 0D
	fatanh.w	(A2)+,FP3	; F2 1A 51 8D
	fatanh.w	-(A3),FP4	; F2 23 52 0D
	fatanh.w	1(A4),FP5	; F2 2C 52 8D 00 01
	fatanh.w	2(A5,D7.W),FP6	; F2 35 53 0D 70 02
	fatanh.w	2(A5,D7.L),FP6	; F2 35 53 0D 78 02
	fatanh.w	(0x1234).W,FP7	; F2 38 53 8D 12 34
	fatanh.w	(0x1234).L,FP7	; F2 39 53 8D 00 00 12
	fatanh.w	*0xFFFFFFF0,FP0	; F2 38 50 0D FF F0
	fatanh.w	 0x00010004,FP1	; F2 39 50 8D 00 01 00
	fatanh.w	#7,FP2		; F2 3C 51 0D 00 07
	fatanh.w	5(PC),FP3	; F2 3A 51 8D 00 01
	fatanh.w	6(PC,A7.W),FP4	; F2 3B 52 0D F0 02
	fatanh.w	6(PC,A7.L),FP4	; F2 3B 52 0D F8 02
	fatanh.w	(0x1234,A0,D1),FP0	; F2 30 50 0D 11 20 12
	fatanh.w	([2,A1,A2],4),FP1	; F2 31 50 8D A1 22 00
	fatanh.w	([6,A2],D3,8),FP2	; F2 32 51 0D 31 26 00
	fatanh.w	(0x1234,PC,D1),FP3	; F2 3B 51 8D 11 20 12
	fatanh.w	([2,PC,A2],4),FP4	; F2 3B 52 0D A1 22 FF
	fatanh.w	([6,PC],D3,8),FP5	; F2 3B 52 8D 31 26 00

	fatanh.l	D0,FP0		; F2 00 40 0D
	fatanh.l	(A1),FP2	; F2 11 41 0D
	fatanh.l	(A2)+,FP3	; F2 1A 41 8D
	fatanh.l	-(A3),FP4	; F2 23 42 0D
	fatanh.l	1(A4),FP5	; F2 2C 42 8D 00 01
	fatanh.l	2(A5,D7.W),FP6	; F2 35 43 0D 70 02
	fatanh.l	2(A5,D7.L),FP6	; F2 35 43 0D 78 02
	fatanh.l	(0x1234).W,FP7	; F2 38 43 8D 12 34
	fatanh.l	(0x1234).L,FP7	; F2 39 43 8D 00 00 12
	fatanh.l	*0xFFFFFFF0,FP0	; F2 38 40 0D FF F0
	fatanh.l	 0x00010004,FP1	; F2 39 40 8D 00 01 00
	fatanh.l	#7,FP2		; F2 3C 41 0D 00 00 00
	fatanh.l	5(PC),FP3	; F2 3A 41 8D 00 01
	fatanh.l	6(PC,A7.W),FP4	; F2 3B 42 0D F0 02
	fatanh.l	6(PC,A7.L),FP4	; F2 3B 42 0D F8 02
	fatanh.l	(0x1234,A0,D1),FP0	; F2 30 40 0D 11 20 12
	fatanh.l	([2,A1,A2],4),FP1	; F2 31 40 8D A1 22 00
	fatanh.l	([6,A2],D3,8),FP2	; F2 32 41 0D 31 26 00
	fatanh.l	(0x1234,PC,D1),FP3	; F2 3B 41 8D 11 20 12
	fatanh.l	([2,PC,A2],4),FP4	; F2 3B 42 0D A1 22 FF
	fatanh.l	([6,PC],D3,8),FP5	; F2 3B 42 8D 31 26 00

	fatanh.s	D0,FP0		; F2 00 44 0D
	fatanh.s	(A1),FP2	; F2 11 45 0D
	fatanh.s	(A2)+,FP3	; F2 1A 45 8D
	fatanh.s	-(A3),FP4	; F2 23 46 0D
	fatanh.s	1(A4),FP5	; F2 2C 46 8D 00 01
	fatanh.s	2(A5,D7.W),FP6	; F2 35 47 0D 70 02
	fatanh.s	2(A5,D7.L),FP6	; F2 35 47 0D 78 02
	fatanh.s	(0x1234).W,FP7	; F2 38 47 8D 12 34
	fatanh.s	(0x1234).L,FP7	; F2 39 47 8D 00 00 12
	fatanh.s	*0xFFFFFFF0,FP0	; F2 38 44 0D FF F0
	fatanh.s	 0x00010004,FP1	; F2 39 44 8D 00 01 00
	fatanh.s	#7,FP2		; F2 3C 45 0D 40 E0 00
	fatanh.s	5(PC),FP3	; F2 3A 45 8D 00 01
	fatanh.s	6(PC,A7.W),FP4	; F2 3B 46 0D F0 02
	fatanh.s	6(PC,A7.L),FP4	; F2 3B 46 0D F8 02
	fatanh.s	(0x1234,A0,D1),FP0	; F2 30 44 0D 11 20 12
	fatanh.s	([2,A1,A2],4),FP1	; F2 31 44 8D A1 22 00
	fatanh.s	([6,A2],D3,8),FP2	; F2 32 45 0D 31 26 00
	fatanh.s	(0x1234,PC,D1),FP3	; F2 3B 45 8D 11 20 12
	fatanh.s	([2,PC,A2],4),FP4	; F2 3B 46 0D A1 22 FF
	fatanh.s	([6,PC],D3,8),FP5	; F2 3B 46 8D 31 26 00

	fatanh.d	(A1),FP2	; F2 11 55 0D
	fatanh.d	(A2)+,FP3	; F2 1A 55 8D
	fatanh.d	-(A3),FP4	; F2 23 56 0D
	fatanh.d	1(A4),FP5	; F2 2C 56 8D 00 01
	fatanh.d	2(A5,D7.W),FP6	; F2 35 57 0D 70 02
	fatanh.d	2(A5,D7.L),FP6	; F2 35 57 0D 78 02
	fatanh.d	(0x1234).W,FP7	; F2 38 57 8D 12 34
	fatanh.d	(0x1234).L,FP7	; F2 39 57 8D 00 00 12
	fatanh.d	*0xFFFFFFF0,FP0	; F2 38 54 0D FF F0
	fatanh.d	 0x00010004,FP1	; F2 39 54 8D 00 01 00
	fatanh.d	5(PC),FP3	; F2 3A 55 8D 00 01
	fatanh.d	6(PC,A7.W),FP4	; F2 3B 56 0D F0 02
	fatanh.d	6(PC,A7.L),FP4	; F2 3B 56 0D F8 02
	fatanh.d	(0x1234,A0,D1),FP0	; F2 30 54 0D 11 20 12
	fatanh.d	([2,A1,A2],4),FP1	; F2 31 54 8D A1 22 00
	fatanh.d	([6,A2],D3,8),FP2	; F2 32 55 0D 31 26 00
	fatanh.d	(0x1234,PC,D1),FP3	; F2 3B 55 8D 11 20 12
	fatanh.d	([2,PC,A2],4),FP4	; F2 3B 56 0D A1 22 FF
	fatanh.d	([6,PC],D3,8),FP5	; F2 3B 56 8D 31 26 00

	fatanh.x	FP7		; F2 00 1F 8D
	fatanh.x	FP1,FP2		; F2 00 05 0D

	fatanh.x	(A1),FP2	; F2 11 49 0D
	fatanh.x	(A2)+,FP3	; F2 1A 49 8D
	fatanh.x	-(A3),FP4	; F2 23 4A 0D
	fatanh.x	1(A4),FP5	; F2 2C 4A 8D 00 01
	fatanh.x	2(A5,D7.W),FP6	; F2 35 4B 0D 70 02
	fatanh.x	2(A5,D7.L),FP6	; F2 35 4B 0D 78 02
	fatanh.x	(0x1234).W,FP7	; F2 38 4B 8D 12 34
	fatanh.x	(0x1234).L,FP7	; F2 39 4B 8D 00 00 12
	fatanh.x	*0xFFFFFFF0,FP0	; F2 38 48 0D FF F0
	fatanh.x	 0x00010004,FP1	; F2 39 48 8D 00 01 00
	fatanh.x	5(PC),FP3	; F2 3A 49 8D 00 01
	fatanh.x	6(PC,A7.W),FP4	; F2 3B 4A 0D F0 02
	fatanh.x	6(PC,A7.L),FP4	; F2 3B 4A 0D F8 02
	fatanh.x	(0x1234,A0,D1),FP0	; F2 30 48 0D 11 20 12
	fatanh.x	([2,A1,A2],4),FP1	; F2 31 48 8D A1 22 00
	fatanh.x	([6,A2],D3,8),FP2	; F2 32 49 0D 31 26 00
	fatanh.x	(0x1234,PC,D1),FP3	; F2 3B 49 8D 11 20 12
	fatanh.x	([2,PC,A2],4),FP4	; F2 3B 4A 0D A1 22 FF
	fatanh.x	([6,PC],D3,8),FP5	; F2 3B 4A 8D 31 26 00

	fatanh.p	(A1),FP2	; F2 11 4D 0D
	fatanh.p	(A2)+,FP3	; F2 1A 4D 8D
	fatanh.p	-(A3),FP4	; F2 23 4E 0D
	fatanh.p	1(A4),FP5	; F2 2C 4E 8D 00 01
	fatanh.p	2(A5,D7.W),FP6	; F2 35 4F 0D 70 02
	fatanh.p	2(A5,D7.L),FP6	; F2 35 4F 0D 78 02
	fatanh.p	(0x1234).W,FP7	; F2 38 4F 8D 12 34
	fatanh.p	(0x1234).L,FP7	; F2 39 4F 8D 00 00 12
	fatanh.p	*0xFFFFFFF0,FP0	; F2 38 4C 0D FF F0
	fatanh.p	 0x00010004,FP1	; F2 39 4C 8D 00 01 00
	fatanh.p	5(PC),FP3	; F2 3A 4D 8D 00 01
	fatanh.p	6(PC,A7.W),FP4	; F2 3B 4E 0D F0 02
	fatanh.p	6(PC,A7.L),FP4	; F2 3B 4E 0D F8 02
	fatanh.p	(0x1234,A0,D1),FP0	; F2 30 4C 0D 11 20 12
	fatanh.p	([2,A1,A2],4),FP1	; F2 31 4C 8D A1 22 00
	fatanh.p	([6,A2],D3,8),FP2	; F2 32 4D 0D 31 26 00
	fatanh.p	(0x1234,PC,D1),FP3	; F2 3B 4D 8D 11 20 12
	fatanh.p	([2,PC,A2],4),FP4	; F2 3B 4E 0D A1 22 FF
	fatanh.p	([6,PC],D3,8),FP5	; F2 3B 4E 8D 31 26 00

	fsin	FP7			; F2 00 1F 8E
	fsin	FP1,FP2			; F2 00 05 0E

	fsin	(A1),FP2		; F2 11 49 0E
	fsin	(A2)+,FP3		; F2 1A 49 8E
	fsin	-(A3),FP4		; F2 23 4A 0E
	fsin	1(A4),FP5		; F2 2C 4A 8E 00 01
	fsin	2(A5,D7.W),FP6		; F2 35 4B 0E 70 02
	fsin	2(A5,D7.L),FP6		; F2 35 4B 0E 78 02
	fsin	(0x1234).W,FP7		; F2 38 4B 8E 12 34
	fsin	(0x1234).L,FP7		; F2 39 4B 8E 00 00 12
	fsin	*0xFFFFFFF0,FP0		; F2 38 48 0E FF F0
	fsin	 0x00010004,FP1		; F2 39 48 8E 00 01 00
	fsin	5(PC),FP3		; F2 3A 49 8E 00 01
	fsin	6(PC,A7.W),FP4		; F2 3B 4A 0E F0 02
	fsin	6(PC,A7.L),FP4		; F2 3B 4A 0E F8 02
	fsin	(0x1234,A0,D1),FP0	; F2 30 48 0E 11 20 12
	fsin	([2,A1,A2],4),FP1	; F2 31 48 8E A1 22 00
	fsin	([6,A2],D3,8),FP2	; F2 32 49 0E 31 26 00
	fsin	(0x1234,PC,D1),FP3	; F2 3B 49 8E 11 20 12
	fsin	([2,PC,A2],4),FP4	; F2 3B 4A 0E A1 22 FF
	fsin	([6,PC],D3,8),FP5	; F2 3B 4A 8E 31 26 00

	fsin.b	D0,FP0			; F2 00 58 0E
	fsin.b	(A1),FP2		; F2 11 59 0E
	fsin.b	(A2)+,FP3		; F2 1A 59 8E
	fsin.b	-(A3),FP4		; F2 23 5A 0E
	fsin.b	1(A4),FP5		; F2 2C 5A 8E 00 01
	fsin.b	2(A5,D7.W),FP6		; F2 35 5B 0E 70 02
	fsin.b	2(A5,D7.L),FP6		; F2 35 5B 0E 78 02
	fsin.b	(0x1234).W,FP7		; F2 38 5B 8E 12 34
	fsin.b	(0x1234).L,FP7		; F2 39 5B 8E 00 00 12
	fsin.b	*0xFFFFFFF0,FP0		; F2 38 58 0E FF F0
	fsin.b	 0x00010004,FP1		; F2 39 58 8E 00 01 00
	fsin.b	#7,FP2			; F2 3C 59 0E 00 07
	fsin.b	5(PC),FP3		; F2 3A 59 8E 00 01
	fsin.b	6(PC,A7.W),FP4		; F2 3B 5A 0E F0 02
	fsin.b	6(PC,A7.L),FP4		; F2 3B 5A 0E F8 02
	fsin.b	(0x1234,A0,D1),FP0	; F2 30 58 0E 11 20 12
	fsin.b	([2,A1,A2],4),FP1	; F2 31 58 8E A1 22 00
	fsin.b	([6,A2],D3,8),FP2	; F2 32 59 0E 31 26 00
	fsin.b	(0x1234,PC,D1),FP3	; F2 3B 59 8E 11 20 12
	fsin.b	([2,PC,A2],4),FP4	; F2 3B 5A 0E A1 22 FF
	fsin.b	([6,PC],D3,8),FP5	; F2 3B 5A 8E 31 26 00

	fsin.w	D0,FP0			; F2 00 50 0E
	fsin.w	(A1),FP2		; F2 11 51 0E
	fsin.w	(A2)+,FP3		; F2 1A 51 8E
	fsin.w	-(A3),FP4		; F2 23 52 0E
	fsin.w	1(A4),FP5		; F2 2C 52 8E 00 01
	fsin.w	2(A5,D7.W),FP6		; F2 35 53 0E 70 02
	fsin.w	2(A5,D7.L),FP6		; F2 35 53 0E 78 02
	fsin.w	(0x1234).W,FP7		; F2 38 53 8E 12 34
	fsin.w	(0x1234).L,FP7		; F2 39 53 8E 00 00 12
	fsin.w	*0xFFFFFFF0,FP0		; F2 38 50 0E FF F0
	fsin.w	 0x00010004,FP1		; F2 39 50 8E 00 01 00
	fsin.w	#7,FP2			; F2 3C 51 0E 00 07
	fsin.w	5(PC),FP3		; F2 3A 51 8E 00 01
	fsin.w	6(PC,A7.W),FP4		; F2 3B 52 0E F0 02
	fsin.w	6(PC,A7.L),FP4		; F2 3B 52 0E F8 02
	fsin.w	(0x1234,A0,D1),FP0	; F2 30 50 0E 11 20 12
	fsin.w	([2,A1,A2],4),FP1	; F2 31 50 8E A1 22 00
	fsin.w	([6,A2],D3,8),FP2	; F2 32 51 0E 31 26 00
	fsin.w	(0x1234,PC,D1),FP3	; F2 3B 51 8E 11 20 12
	fsin.w	([2,PC,A2],4),FP4	; F2 3B 52 0E A1 22 FF
	fsin.w	([6,PC],D3,8),FP5	; F2 3B 52 8E 31 26 00

	fsin.l	D0,FP0			; F2 00 40 0E
	fsin.l	(A1),FP2		; F2 11 41 0E
	fsin.l	(A2)+,FP3		; F2 1A 41 8E
	fsin.l	-(A3),FP4		; F2 23 42 0E
	fsin.l	1(A4),FP5		; F2 2C 42 8E 00 01
	fsin.l	2(A5,D7.W),FP6		; F2 35 43 0E 70 02
	fsin.l	2(A5,D7.L),FP6		; F2 35 43 0E 78 02
	fsin.l	(0x1234).W,FP7		; F2 38 43 8E 12 34
	fsin.l	(0x1234).L,FP7		; F2 39 43 8E 00 00 12
	fsin.l	*0xFFFFFFF0,FP0		; F2 38 40 0E FF F0
	fsin.l	 0x00010004,FP1		; F2 39 40 8E 00 01 00
	fsin.l	#7,FP2			; F2 3C 41 0E 00 00 00
	fsin.l	5(PC),FP3		; F2 3A 41 8E 00 01
	fsin.l	6(PC,A7.W),FP4		; F2 3B 42 0E F0 02
	fsin.l	6(PC,A7.L),FP4		; F2 3B 42 0E F8 02
	fsin.l	(0x1234,A0,D1),FP0	; F2 30 40 0E 11 20 12
	fsin.l	([2,A1,A2],4),FP1	; F2 31 40 8E A1 22 00
	fsin.l	([6,A2],D3,8),FP2	; F2 32 41 0E 31 26 00
	fsin.l	(0x1234,PC,D1),FP3	; F2 3B 41 8E 11 20 12
	fsin.l	([2,PC,A2],4),FP4	; F2 3B 42 0E A1 22 FF
	fsin.l	([6,PC],D3,8),FP5	; F2 3B 42 8E 31 26 00

	fsin.s	D0,FP0			; F2 00 44 0E
	fsin.s	(A1),FP2		; F2 11 45 0E
	fsin.s	(A2)+,FP3		; F2 1A 45 8E
	fsin.s	-(A3),FP4		; F2 23 46 0E
	fsin.s	1(A4),FP5		; F2 2C 46 8E 00 01
	fsin.s	2(A5,D7.W),FP6		; F2 35 47 0E 70 02
	fsin.s	2(A5,D7.L),FP6		; F2 35 47 0E 78 02
	fsin.s	(0x1234).W,FP7		; F2 38 47 8E 12 34
	fsin.s	(0x1234).L,FP7		; F2 39 47 8E 00 00 12
	fsin.s	*0xFFFFFFF0,FP0		; F2 38 44 0E FF F0
	fsin.s	 0x00010004,FP1		; F2 39 44 8E 00 01 00
	fsin.s	#7,FP2			; F2 3C 45 0E 40 E0 00
	fsin.s	5(PC),FP3		; F2 3A 45 8E 00 01
	fsin.s	6(PC,A7.W),FP4		; F2 3B 46 0E F0 02
	fsin.s	6(PC,A7.L),FP4		; F2 3B 46 0E F8 02
	fsin.s	(0x1234,A0,D1),FP0	; F2 30 44 0E 11 20 12
	fsin.s	([2,A1,A2],4),FP1	; F2 31 44 8E A1 22 00
	fsin.s	([6,A2],D3,8),FP2	; F2 32 45 0E 31 26 00
	fsin.s	(0x1234,PC,D1),FP3	; F2 3B 45 8E 11 20 12
	fsin.s	([2,PC,A2],4),FP4	; F2 3B 46 0E A1 22 FF
	fsin.s	([6,PC],D3,8),FP5	; F2 3B 46 8E 31 26 00

	fsin.d	(A1),FP2		; F2 11 55 0E
	fsin.d	(A2)+,FP3		; F2 1A 55 8E
	fsin.d	-(A3),FP4		; F2 23 56 0E
	fsin.d	1(A4),FP5		; F2 2C 56 8E 00 01
	fsin.d	2(A5,D7.W),FP6		; F2 35 57 0E 70 02
	fsin.d	2(A5,D7.L),FP6		; F2 35 57 0E 78 02
	fsin.d	(0x1234).W,FP7		; F2 38 57 8E 12 34
	fsin.d	(0x1234).L,FP7		; F2 39 57 8E 00 00 12
	fsin.d	*0xFFFFFFF0,FP0		; F2 38 54 0E FF F0
	fsin.d	 0x00010004,FP1		; F2 39 54 8E 00 01 00
	fsin.d	5(PC),FP3		; F2 3A 55 8E 00 01
	fsin.d	6(PC,A7.W),FP4		; F2 3B 56 0E F0 02
	fsin.d	6(PC,A7.L),FP4		; F2 3B 56 0E F8 02
	fsin.d	(0x1234,A0,D1),FP0	; F2 30 54 0E 11 20 12
	fsin.d	([2,A1,A2],4),FP1	; F2 31 54 8E A1 22 00
	fsin.d	([6,A2],D3,8),FP2	; F2 32 55 0E 31 26 00
	fsin.d	(0x1234,PC,D1),FP3	; F2 3B 55 8E 11 20 12
	fsin.d	([2,PC,A2],4),FP4	; F2 3B 56 0E A1 22 FF
	fsin.d	([6,PC],D3,8),FP5	; F2 3B 56 8E 31 26 00

	fsin.x	FP7			; F2 00 1F 8E
	fsin.x	FP1,FP2			; F2 00 05 0E

	fsin.x	(A1),FP2		; F2 11 49 0E
	fsin.x	(A2)+,FP3		; F2 1A 49 8E
	fsin.x	-(A3),FP4		; F2 23 4A 0E
	fsin.x	1(A4),FP5		; F2 2C 4A 8E 00 01
	fsin.x	2(A5,D7.W),FP6		; F2 35 4B 0E 70 02
	fsin.x	2(A5,D7.L),FP6		; F2 35 4B 0E 78 02
	fsin.x	(0x1234).W,FP7		; F2 38 4B 8E 12 34
	fsin.x	(0x1234).L,FP7		; F2 39 4B 8E 00 00 12
	fsin.x	*0xFFFFFFF0,FP0		; F2 38 48 0E FF F0
	fsin.x	 0x00010004,FP1		; F2 39 48 8E 00 01 00
	fsin.x	5(PC),FP3		; F2 3A 49 8E 00 01
	fsin.x	6(PC,A7.W),FP4		; F2 3B 4A 0E F0 02
	fsin.x	6(PC,A7.L),FP4		; F2 3B 4A 0E F8 02
	fsin.x	(0x1234,A0,D1),FP0	; F2 30 48 0E 11 20 12
	fsin.x	([2,A1,A2],4),FP1	; F2 31 48 8E A1 22 00
	fsin.x	([6,A2],D3,8),FP2	; F2 32 49 0E 31 26 00
	fsin.x	(0x1234,PC,D1),FP3	; F2 3B 49 8E 11 20 12
	fsin.x	([2,PC,A2],4),FP4	; F2 3B 4A 0E A1 22 FF
	fsin.x	([6,PC],D3,8),FP5	; F2 3B 4A 8E 31 26 00

	fsin.p	(A1),FP2		; F2 11 4D 0E
	fsin.p	(A2)+,FP3		; F2 1A 4D 8E
	fsin.p	-(A3),FP4		; F2 23 4E 0E
	fsin.p	1(A4),FP5		; F2 2C 4E 8E 00 01
	fsin.p	2(A5,D7.W),FP6		; F2 35 4F 0E 70 02
	fsin.p	2(A5,D7.L),FP6		; F2 35 4F 0E 78 02
	fsin.p	(0x1234).W,FP7		; F2 38 4F 8E 12 34
	fsin.p	(0x1234).L,FP7		; F2 39 4F 8E 00 00 12
	fsin.p	*0xFFFFFFF0,FP0		; F2 38 4C 0E FF F0
	fsin.p	 0x00010004,FP1		; F2 39 4C 8E 00 01 00
	fsin.p	5(PC),FP3		; F2 3A 4D 8E 00 01
	fsin.p	6(PC,A7.W),FP4		; F2 3B 4E 0E F0 02
	fsin.p	6(PC,A7.L),FP4		; F2 3B 4E 0E F8 02
	fsin.p	(0x1234,A0,D1),FP0	; F2 30 4C 0E 11 20 12
	fsin.p	([2,A1,A2],4),FP1	; F2 31 4C 8E A1 22 00
	fsin.p	([6,A2],D3,8),FP2	; F2 32 4D 0E 31 26 00
	fsin.p	(0x1234,PC,D1),FP3	; F2 3B 4D 8E 11 20 12
	fsin.p	([2,PC,A2],4),FP4	; F2 3B 4E 0E A1 22 FF
	fsin.p	([6,PC],D3,8),FP5	; F2 3B 4E 8E 31 26 00

	ftan	FP7			; F2 00 1F 8F
	ftan	FP1,FP2			; F2 00 05 0F

	ftan	(A1),FP2		; F2 11 49 0F
	ftan	(A2)+,FP3		; F2 1A 49 8F
	ftan	-(A3),FP4		; F2 23 4A 0F
	ftan	1(A4),FP5		; F2 2C 4A 8F 00 01
	ftan	2(A5,D7.W),FP6		; F2 35 4B 0F 70 02
	ftan	2(A5,D7.L),FP6		; F2 35 4B 0F 78 02
	ftan	(0x1234).W,FP7		; F2 38 4B 8F 12 34
	ftan	(0x1234).L,FP7		; F2 39 4B 8F 00 00 12
	ftan	*0xFFFFFFF0,FP0		; F2 38 48 0F FF F0
	ftan	 0x00010004,FP1		; F2 39 48 8F 00 01 00
	ftan	5(PC),FP3		; F2 3A 49 8F 00 01
	ftan	6(PC,A7.W),FP4		; F2 3B 4A 0F F0 02
	ftan	6(PC,A7.L),FP4		; F2 3B 4A 0F F8 02
	ftan	(0x1234,A0,D1),FP0	; F2 30 48 0F 11 20 12
	ftan	([2,A1,A2],4),FP1	; F2 31 48 8F A1 22 00
	ftan	([6,A2],D3,8),FP2	; F2 32 49 0F 31 26 00
	ftan	(0x1234,PC,D1),FP3	; F2 3B 49 8F 11 20 12
	ftan	([2,PC,A2],4),FP4	; F2 3B 4A 0F A1 22 FF
	ftan	([6,PC],D3,8),FP5	; F2 3B 4A 8F 31 26 00

	ftan.b	D0,FP0			; F2 00 58 0F
	ftan.b	(A1),FP2		; F2 11 59 0F
	ftan.b	(A2)+,FP3		; F2 1A 59 8F
	ftan.b	-(A3),FP4		; F2 23 5A 0F
	ftan.b	1(A4),FP5		; F2 2C 5A 8F 00 01
	ftan.b	2(A5,D7.W),FP6		; F2 35 5B 0F 70 02
	ftan.b	2(A5,D7.L),FP6		; F2 35 5B 0F 78 02
	ftan.b	(0x1234).W,FP7		; F2 38 5B 8F 12 34
	ftan.b	(0x1234).L,FP7		; F2 39 5B 8F 00 00 12
	ftan.b	*0xFFFFFFF0,FP0		; F2 38 58 0F FF F0
	ftan.b	 0x00010004,FP1		; F2 39 58 8F 00 01 00
	ftan.b	#7,FP2			; F2 3C 59 0F 00 07
	ftan.b	5(PC),FP3		; F2 3A 59 8F 00 01
	ftan.b	6(PC,A7.W),FP4		; F2 3B 5A 0F F0 02
	ftan.b	6(PC,A7.L),FP4		; F2 3B 5A 0F F8 02
	ftan.b	(0x1234,A0,D1),FP0	; F2 30 58 0F 11 20 12
	ftan.b	([2,A1,A2],4),FP1	; F2 31 58 8F A1 22 00
	ftan.b	([6,A2],D3,8),FP2	; F2 32 59 0F 31 26 00
	ftan.b	(0x1234,PC,D1),FP3	; F2 3B 59 8F 11 20 12
	ftan.b	([2,PC,A2],4),FP4	; F2 3B 5A 0F A1 22 FF
	ftan.b	([6,PC],D3,8),FP5	; F2 3B 5A 8F 31 26 00

	ftan.w	D0,FP0			; F2 00 50 0F
	ftan.w	(A1),FP2		; F2 11 51 0F
	ftan.w	(A2)+,FP3		; F2 1A 51 8F
	ftan.w	-(A3),FP4		; F2 23 52 0F
	ftan.w	1(A4),FP5		; F2 2C 52 8F 00 01
	ftan.w	2(A5,D7.W),FP6		; F2 35 53 0F 70 02
	ftan.w	2(A5,D7.L),FP6		; F2 35 53 0F 78 02
	ftan.w	(0x1234).W,FP7		; F2 38 53 8F 12 34
	ftan.w	(0x1234).L,FP7		; F2 39 53 8F 00 00 12
	ftan.w	*0xFFFFFFF0,FP0		; F2 38 50 0F FF F0
	ftan.w	 0x00010004,FP1		; F2 39 50 8F 00 01 00
	ftan.w	#7,FP2			; F2 3C 51 0F 00 07
	ftan.w	5(PC),FP3		; F2 3A 51 8F 00 01
	ftan.w	6(PC,A7.W),FP4		; F2 3B 52 0F F0 02
	ftan.w	6(PC,A7.L),FP4		; F2 3B 52 0F F8 02
	ftan.w	(0x1234,A0,D1),FP0	; F2 30 50 0F 11 20 12
	ftan.w	([2,A1,A2],4),FP1	; F2 31 50 8F A1 22 00
	ftan.w	([6,A2],D3,8),FP2	; F2 32 51 0F 31 26 00
	ftan.w	(0x1234,PC,D1),FP3	; F2 3B 51 8F 11 20 12
	ftan.w	([2,PC,A2],4),FP4	; F2 3B 52 0F A1 22 FF
	ftan.w	([6,PC],D3,8),FP5	; F2 3B 52 8F 31 26 00

	ftan.l	D0,FP0			; F2 00 40 0F
	ftan.l	(A1),FP2		; F2 11 41 0F
	ftan.l	(A2)+,FP3		; F2 1A 41 8F
	ftan.l	-(A3),FP4		; F2 23 42 0F
	ftan.l	1(A4),FP5		; F2 2C 42 8F 00 01
	ftan.l	2(A5,D7.W),FP6		; F2 35 43 0F 70 02
	ftan.l	2(A5,D7.L),FP6		; F2 35 43 0F 78 02
	ftan.l	(0x1234).W,FP7		; F2 38 43 8F 12 34
	ftan.l	(0x1234).L,FP7		; F2 39 43 8F 00 00 12
	ftan.l	*0xFFFFFFF0,FP0		; F2 38 40 0F FF F0
	ftan.l	 0x00010004,FP1		; F2 39 40 8F 00 01 00
	ftan.l	#7,FP2			; F2 3C 41 0F 00 00 00
	ftan.l	5(PC),FP3		; F2 3A 41 8F 00 01
	ftan.l	6(PC,A7.W),FP4		; F2 3B 42 0F F0 02
	ftan.l	6(PC,A7.L),FP4		; F2 3B 42 0F F8 02
	ftan.l	(0x1234,A0,D1),FP0	; F2 30 40 0F 11 20 12
	ftan.l	([2,A1,A2],4),FP1	; F2 31 40 8F A1 22 00
	ftan.l	([6,A2],D3,8),FP2	; F2 32 41 0F 31 26 00
	ftan.l	(0x1234,PC,D1),FP3	; F2 3B 41 8F 11 20 12
	ftan.l	([2,PC,A2],4),FP4	; F2 3B 42 0F A1 22 FF
	ftan.l	([6,PC],D3,8),FP5	; F2 3B 42 8F 31 26 00

	ftan.s	D0,FP0			; F2 00 44 0F
	ftan.s	(A1),FP2		; F2 11 45 0F
	ftan.s	(A2)+,FP3		; F2 1A 45 8F
	ftan.s	-(A3),FP4		; F2 23 46 0F
	ftan.s	1(A4),FP5		; F2 2C 46 8F 00 01
	ftan.s	2(A5,D7.W),FP6		; F2 35 47 0F 70 02
	ftan.s	2(A5,D7.L),FP6		; F2 35 47 0F 78 02
	ftan.s	(0x1234).W,FP7		; F2 38 47 8F 12 34
	ftan.s	(0x1234).L,FP7		; F2 39 47 8F 00 00 12
	ftan.s	*0xFFFFFFF0,FP0		; F2 38 44 0F FF F0
	ftan.s	 0x00010004,FP1		; F2 39 44 8F 00 01 00
	ftan.s	#7,FP2			; F2 3C 45 0F 40 E0 00
	ftan.s	5(PC),FP3		; F2 3A 45 8F 00 01
	ftan.s	6(PC,A7.W),FP4		; F2 3B 46 0F F0 02
	ftan.s	6(PC,A7.L),FP4		; F2 3B 46 0F F8 02
	ftan.s	(0x1234,A0,D1),FP0	; F2 30 44 0F 11 20 12
	ftan.s	([2,A1,A2],4),FP1	; F2 31 44 8F A1 22 00
	ftan.s	([6,A2],D3,8),FP2	; F2 32 45 0F 31 26 00
	ftan.s	(0x1234,PC,D1),FP3	; F2 3B 45 8F 11 20 12
	ftan.s	([2,PC,A2],4),FP4	; F2 3B 46 0F A1 22 FF
	ftan.s	([6,PC],D3,8),FP5	; F2 3B 46 8F 31 26 00

	ftan.d	(A1),FP2		; F2 11 55 0F
	ftan.d	(A2)+,FP3		; F2 1A 55 8F
	ftan.d	-(A3),FP4		; F2 23 56 0F
	ftan.d	1(A4),FP5		; F2 2C 56 8F 00 01
	ftan.d	2(A5,D7.W),FP6		; F2 35 57 0F 70 02
	ftan.d	2(A5,D7.L),FP6		; F2 35 57 0F 78 02
	ftan.d	(0x1234).W,FP7		; F2 38 57 8F 12 34
	ftan.d	(0x1234).L,FP7		; F2 39 57 8F 00 00 12
	ftan.d	*0xFFFFFFF0,FP0		; F2 38 54 0F FF F0
	ftan.d	 0x00010004,FP1		; F2 39 54 8F 00 01 00
	ftan.d	5(PC),FP3		; F2 3A 55 8F 00 01
	ftan.d	6(PC,A7.W),FP4		; F2 3B 56 0F F0 02
	ftan.d	6(PC,A7.L),FP4		; F2 3B 56 0F F8 02
	ftan.d	(0x1234,A0,D1),FP0	; F2 30 54 0F 11 20 12
	ftan.d	([2,A1,A2],4),FP1	; F2 31 54 8F A1 22 00
	ftan.d	([6,A2],D3,8),FP2	; F2 32 55 0F 31 26 00
	ftan.d	(0x1234,PC,D1),FP3	; F2 3B 55 8F 11 20 12
	ftan.d	([2,PC,A2],4),FP4	; F2 3B 56 0F A1 22 FF
	ftan.d	([6,PC],D3,8),FP5	; F2 3B 56 8F 31 26 00

	ftan.x	FP7			; F2 00 1F 8F
	ftan.x	FP1,FP2			; F2 00 05 0F

	ftan.x	(A1),FP2		; F2 11 49 0F
	ftan.x	(A2)+,FP3		; F2 1A 49 8F
	ftan.x	-(A3),FP4		; F2 23 4A 0F
	ftan.x	1(A4),FP5		; F2 2C 4A 8F 00 01
	ftan.x	2(A5,D7.W),FP6		; F2 35 4B 0F 70 02
	ftan.x	2(A5,D7.L),FP6		; F2 35 4B 0F 78 02
	ftan.x	(0x1234).W,FP7		; F2 38 4B 8F 12 34
	ftan.x	(0x1234).L,FP7		; F2 39 4B 8F 00 00 12
	ftan.x	*0xFFFFFFF0,FP0		; F2 38 48 0F FF F0
	ftan.x	 0x00010004,FP1		; F2 39 48 8F 00 01 00
	ftan.x	5(PC),FP3		; F2 3A 49 8F 00 01
	ftan.x	6(PC,A7.W),FP4		; F2 3B 4A 0F F0 02
	ftan.x	6(PC,A7.L),FP4		; F2 3B 4A 0F F8 02
	ftan.x	(0x1234,A0,D1),FP0	; F2 30 48 0F 11 20 12
	ftan.x	([2,A1,A2],4),FP1	; F2 31 48 8F A1 22 00
	ftan.x	([6,A2],D3,8),FP2	; F2 32 49 0F 31 26 00
	ftan.x	(0x1234,PC,D1),FP3	; F2 3B 49 8F 11 20 12
	ftan.x	([2,PC,A2],4),FP4	; F2 3B 4A 0F A1 22 FF
	ftan.x	([6,PC],D3,8),FP5	; F2 3B 4A 8F 31 26 00

	ftan.p	(A1),FP2		; F2 11 4D 0F
	ftan.p	(A2)+,FP3		; F2 1A 4D 8F
	ftan.p	-(A3),FP4		; F2 23 4E 0F
	ftan.p	1(A4),FP5		; F2 2C 4E 8F 00 01
	ftan.p	2(A5,D7.W),FP6		; F2 35 4F 0F 70 02
	ftan.p	2(A5,D7.L),FP6		; F2 35 4F 0F 78 02
	ftan.p	(0x1234).W,FP7		; F2 38 4F 8F 12 34
	ftan.p	(0x1234).L,FP7		; F2 39 4F 8F 00 00 12
	ftan.p	*0xFFFFFFF0,FP0		; F2 38 4C 0F FF F0
	ftan.p	 0x00010004,FP1		; F2 39 4C 8F 00 01 00
	ftan.p	5(PC),FP3		; F2 3A 4D 8F 00 01
	ftan.p	6(PC,A7.W),FP4		; F2 3B 4E 0F F0 02
	ftan.p	6(PC,A7.L),FP4		; F2 3B 4E 0F F8 02
	ftan.p	(0x1234,A0,D1),FP0	; F2 30 4C 0F 11 20 12
	ftan.p	([2,A1,A2],4),FP1	; F2 31 4C 8F A1 22 00
	ftan.p	([6,A2],D3,8),FP2	; F2 32 4D 0F 31 26 00
	ftan.p	(0x1234,PC,D1),FP3	; F2 3B 4D 8F 11 20 12
	ftan.p	([2,PC,A2],4),FP4	; F2 3B 4E 0F A1 22 FF
	ftan.p	([6,PC],D3,8),FP5	; F2 3B 4E 8F 31 26 00

	fetox	FP7			; F2 00 1F 90
	fetox	FP1,FP2			; F2 00 05 10

	fetox	(A1),FP2		; F2 11 49 10
	fetox	(A2)+,FP3		; F2 1A 49 90
	fetox	-(A3),FP4		; F2 23 4A 10
	fetox	1(A4),FP5		; F2 2C 4A 90 00 01
	fetox	2(A5,D7.W),FP6		; F2 35 4B 10 70 02
	fetox	2(A5,D7.L),FP6		; F2 35 4B 10 78 02
	fetox	(0x1234).W,FP7		; F2 38 4B 90 12 34
	fetox	(0x1234).L,FP7		; F2 39 4B 90 00 00 12
	fetox	*0xFFFFFFF0,FP0		; F2 38 48 10 FF F0
	fetox	 0x00010004,FP1		; F2 39 48 90 00 01 00
	fetox	5(PC),FP3		; F2 3A 49 90 00 01
	fetox	6(PC,A7.W),FP4		; F2 3B 4A 10 F0 02
	fetox	6(PC,A7.L),FP4		; F2 3B 4A 10 F8 02
	fetox	(0x1234,A0,D1),FP0	; F2 30 48 10 11 20 12
	fetox	([2,A1,A2],4),FP1	; F2 31 48 90 A1 22 00
	fetox	([6,A2],D3,8),FP2	; F2 32 49 10 31 26 00
	fetox	(0x1234,PC,D1),FP3	; F2 3B 49 90 11 20 12
	fetox	([2,PC,A2],4),FP4	; F2 3B 4A 10 A1 22 FF
	fetox	([6,PC],D3,8),FP5	; F2 3B 4A 90 31 26 00

	fetox.b	D0,FP0			; F2 00 58 10
	fetox.b	(A1),FP2		; F2 11 59 10
	fetox.b	(A2)+,FP3		; F2 1A 59 90
	fetox.b	-(A3),FP4		; F2 23 5A 10
	fetox.b	1(A4),FP5		; F2 2C 5A 90 00 01
	fetox.b	2(A5,D7.W),FP6		; F2 35 5B 10 70 02
	fetox.b	2(A5,D7.L),FP6		; F2 35 5B 10 78 02
	fetox.b	(0x1234).W,FP7		; F2 38 5B 90 12 34
	fetox.b	(0x1234).L,FP7		; F2 39 5B 90 00 00 12
	fetox.b	*0xFFFFFFF0,FP0		; F2 38 58 10 FF F0
	fetox.b	 0x00010004,FP1		; F2 39 58 90 00 01 00
	fetox.b	#7,FP2			; F2 3C 59 10 00 07
	fetox.b	5(PC),FP3		; F2 3A 59 90 00 01
	fetox.b	6(PC,A7.W),FP4		; F2 3B 5A 10 F0 02
	fetox.b	6(PC,A7.L),FP4		; F2 3B 5A 10 F8 02
	fetox.b	(0x1234,A0,D1),FP0	; F2 30 58 10 11 20 12
	fetox.b	([2,A1,A2],4),FP1	; F2 31 58 90 A1 22 00
	fetox.b	([6,A2],D3,8),FP2	; F2 32 59 10 31 26 00
	fetox.b	(0x1234,PC,D1),FP3	; F2 3B 59 90 11 20 12
	fetox.b	([2,PC,A2],4),FP4	; F2 3B 5A 10 A1 22 FF
	fetox.b	([6,PC],D3,8),FP5	; F2 3B 5A 90 31 26 00

	fetox.w	D0,FP0			; F2 00 50 10
	fetox.w	(A1),FP2		; F2 11 51 10
	fetox.w	(A2)+,FP3		; F2 1A 51 90
	fetox.w	-(A3),FP4		; F2 23 52 10
	fetox.w	1(A4),FP5		; F2 2C 52 90 00 01
	fetox.w	2(A5,D7.W),FP6		; F2 35 53 10 70 02
	fetox.w	2(A5,D7.L),FP6		; F2 35 53 10 78 02
	fetox.w	(0x1234).W,FP7		; F2 38 53 90 12 34
	fetox.w	(0x1234).L,FP7		; F2 39 53 90 00 00 12
	fetox.w	*0xFFFFFFF0,FP0		; F2 38 50 10 FF F0
	fetox.w	 0x00010004,FP1		; F2 39 50 90 00 01 00
	fetox.w	#7,FP2			; F2 3C 51 10 00 07
	fetox.w	5(PC),FP3		; F2 3A 51 90 00 01
	fetox.w	6(PC,A7.W),FP4		; F2 3B 52 10 F0 02
	fetox.w	6(PC,A7.L),FP4		; F2 3B 52 10 F8 02
	fetox.w	(0x1234,A0,D1),FP0	; F2 30 50 10 11 20 12
	fetox.w	([2,A1,A2],4),FP1	; F2 31 50 90 A1 22 00
	fetox.w	([6,A2],D3,8),FP2	; F2 32 51 10 31 26 00
	fetox.w	(0x1234,PC,D1),FP3	; F2 3B 51 90 11 20 12
	fetox.w	([2,PC,A2],4),FP4	; F2 3B 52 10 A1 22 FF
	fetox.w	([6,PC],D3,8),FP5	; F2 3B 52 90 31 26 00

	fetox.l	D0,FP0			; F2 00 40 10
	fetox.l	(A1),FP2		; F2 11 41 10
	fetox.l	(A2)+,FP3		; F2 1A 41 90
	fetox.l	-(A3),FP4		; F2 23 42 10
	fetox.l	1(A4),FP5		; F2 2C 42 90 00 01
	fetox.l	2(A5,D7.W),FP6		; F2 35 43 10 70 02
	fetox.l	2(A5,D7.L),FP6		; F2 35 43 10 78 02
	fetox.l	(0x1234).W,FP7		; F2 38 43 90 12 34
	fetox.l	(0x1234).L,FP7		; F2 39 43 90 00 00 12
	fetox.l	*0xFFFFFFF0,FP0		; F2 38 40 10 FF F0
	fetox.l	 0x00010004,FP1		; F2 39 40 90 00 01 00
	fetox.l	#7,FP2			; F2 3C 41 10 00 00 00
	fetox.l	5(PC),FP3		; F2 3A 41 90 00 01
	fetox.l	6(PC,A7.W),FP4		; F2 3B 42 10 F0 02
	fetox.l	6(PC,A7.L),FP4		; F2 3B 42 10 F8 02
	fetox.l	(0x1234,A0,D1),FP0	; F2 30 40 10 11 20 12
	fetox.l	([2,A1,A2],4),FP1	; F2 31 40 90 A1 22 00
	fetox.l	([6,A2],D3,8),FP2	; F2 32 41 10 31 26 00
	fetox.l	(0x1234,PC,D1),FP3	; F2 3B 41 90 11 20 12
	fetox.l	([2,PC,A2],4),FP4	; F2 3B 42 10 A1 22 FF
	fetox.l	([6,PC],D3,8),FP5	; F2 3B 42 90 31 26 00

	fetox.s	D0,FP0			; F2 00 44 10
	fetox.s	(A1),FP2		; F2 11 45 10
	fetox.s	(A2)+,FP3		; F2 1A 45 90
	fetox.s	-(A3),FP4		; F2 23 46 10
	fetox.s	1(A4),FP5		; F2 2C 46 90 00 01
	fetox.s	2(A5,D7.W),FP6		; F2 35 47 10 70 02
	fetox.s	2(A5,D7.L),FP6		; F2 35 47 10 78 02
	fetox.s	(0x1234).W,FP7		; F2 38 47 90 12 34
	fetox.s	(0x1234).L,FP7		; F2 39 47 90 00 00 12
	fetox.s	*0xFFFFFFF0,FP0		; F2 38 44 10 FF F0
	fetox.s	 0x00010004,FP1		; F2 39 44 90 00 01 00
	fetox.s	#7,FP2			; F2 3C 45 10 40 E0 00
	fetox.s	5(PC),FP3		; F2 3A 45 90 00 01
	fetox.s	6(PC,A7.W),FP4		; F2 3B 46 10 F0 02
	fetox.s	6(PC,A7.L),FP4		; F2 3B 46 10 F8 02
	fetox.s	(0x1234,A0,D1),FP0	; F2 30 44 10 11 20 12
	fetox.s	([2,A1,A2],4),FP1	; F2 31 44 90 A1 22 00
	fetox.s	([6,A2],D3,8),FP2	; F2 32 45 10 31 26 00
	fetox.s	(0x1234,PC,D1),FP3	; F2 3B 45 90 11 20 12
	fetox.s	([2,PC,A2],4),FP4	; F2 3B 46 10 A1 22 FF
	fetox.s	([6,PC],D3,8),FP5	; F2 3B 46 90 31 26 00

	fetox.d	(A1),FP2		; F2 11 55 10
	fetox.d	(A2)+,FP3		; F2 1A 55 90
	fetox.d	-(A3),FP4		; F2 23 56 10
	fetox.d	1(A4),FP5		; F2 2C 56 90 00 01
	fetox.d	2(A5,D7.W),FP6		; F2 35 57 10 70 02
	fetox.d	2(A5,D7.L),FP6		; F2 35 57 10 78 02
	fetox.d	(0x1234).W,FP7		; F2 38 57 90 12 34
	fetox.d	(0x1234).L,FP7		; F2 39 57 90 00 00 12
	fetox.d	*0xFFFFFFF0,FP0		; F2 38 54 10 FF F0
	fetox.d	 0x00010004,FP1		; F2 39 54 90 00 01 00
	fetox.d	5(PC),FP3		; F2 3A 55 90 00 01
	fetox.d	6(PC,A7.W),FP4		; F2 3B 56 10 F0 02
	fetox.d	6(PC,A7.L),FP4		; F2 3B 56 10 F8 02
	fetox.d	(0x1234,A0,D1),FP0	; F2 30 54 10 11 20 12
	fetox.d	([2,A1,A2],4),FP1	; F2 31 54 90 A1 22 00
	fetox.d	([6,A2],D3,8),FP2	; F2 32 55 10 31 26 00
	fetox.d	(0x1234,PC,D1),FP3	; F2 3B 55 90 11 20 12
	fetox.d	([2,PC,A2],4),FP4	; F2 3B 56 10 A1 22 FF
	fetox.d	([6,PC],D3,8),FP5	; F2 3B 56 90 31 26 00

	fetox.x	FP7			; F2 00 1F 90
	fetox.x	FP1,FP2			; F2 00 05 10

	fetox.x	(A1),FP2		; F2 11 49 10
	fetox.x	(A2)+,FP3		; F2 1A 49 90
	fetox.x	-(A3),FP4		; F2 23 4A 10
	fetox.x	1(A4),FP5		; F2 2C 4A 90 00 01
	fetox.x	2(A5,D7.W),FP6		; F2 35 4B 10 70 02
	fetox.x	2(A5,D7.L),FP6		; F2 35 4B 10 78 02
	fetox.x	(0x1234).W,FP7		; F2 38 4B 90 12 34
	fetox.x	(0x1234).L,FP7		; F2 39 4B 90 00 00 12
	fetox.x	*0xFFFFFFF0,FP0		; F2 38 48 10 FF F0
	fetox.x	 0x00010004,FP1		; F2 39 48 90 00 01 00
	fetox.x	5(PC),FP3		; F2 3A 49 90 00 01
	fetox.x	6(PC,A7.W),FP4		; F2 3B 4A 10 F0 02
	fetox.x	6(PC,A7.L),FP4		; F2 3B 4A 10 F8 02
	fetox.x	(0x1234,A0,D1),FP0	; F2 30 48 10 11 20 12
	fetox.x	([2,A1,A2],4),FP1	; F2 31 48 90 A1 22 00
	fetox.x	([6,A2],D3,8),FP2	; F2 32 49 10 31 26 00
	fetox.x	(0x1234,PC,D1),FP3	; F2 3B 49 90 11 20 12
	fetox.x	([2,PC,A2],4),FP4	; F2 3B 4A 10 A1 22 FF
	fetox.x	([6,PC],D3,8),FP5	; F2 3B 4A 90 31 26 00

	fetox.p	(A1),FP2		; F2 11 4D 10
	fetox.p	(A2)+,FP3		; F2 1A 4D 90
	fetox.p	-(A3),FP4		; F2 23 4E 10
	fetox.p	1(A4),FP5		; F2 2C 4E 90 00 01
	fetox.p	2(A5,D7.W),FP6		; F2 35 4F 10 70 02
	fetox.p	2(A5,D7.L),FP6		; F2 35 4F 10 78 02
	fetox.p	(0x1234).W,FP7		; F2 38 4F 90 12 34
	fetox.p	(0x1234).L,FP7		; F2 39 4F 90 00 00 12
	fetox.p	*0xFFFFFFF0,FP0		; F2 38 4C 10 FF F0
	fetox.p	 0x00010004,FP1		; F2 39 4C 90 00 01 00
	fetox.p	5(PC),FP3		; F2 3A 4D 90 00 01
	fetox.p	6(PC,A7.W),FP4		; F2 3B 4E 10 F0 02
	fetox.p	6(PC,A7.L),FP4		; F2 3B 4E 10 F8 02
	fetox.p	(0x1234,A0,D1),FP0	; F2 30 4C 10 11 20 12
	fetox.p	([2,A1,A2],4),FP1	; F2 31 4C 90 A1 22 00
	fetox.p	([6,A2],D3,8),FP2	; F2 32 4D 10 31 26 00
	fetox.p	(0x1234,PC,D1),FP3	; F2 3B 4D 90 11 20 12
	fetox.p	([2,PC,A2],4),FP4	; F2 3B 4E 10 A1 22 FF
	fetox.p	([6,PC],D3,8),FP5	; F2 3B 4E 90 31 26 00

	ftwotox	FP7			; F2 00 1F 91
	ftwotox	FP1,FP2			; F2 00 05 11

	ftwotox	(A1),FP2		; F2 11 49 11
	ftwotox	(A2)+,FP3		; F2 1A 49 91
	ftwotox	-(A3),FP4		; F2 23 4A 11
	ftwotox	1(A4),FP5		; F2 2C 4A 91 00 01
	ftwotox	2(A5,D7.W),FP6		; F2 35 4B 11 70 02
	ftwotox	2(A5,D7.L),FP6		; F2 35 4B 11 78 02
	ftwotox	(0x1234).W,FP7		; F2 38 4B 91 12 34
	ftwotox	(0x1234).L,FP7		; F2 39 4B 91 00 00 12
	ftwotox	*0xFFFFFFF0,FP0		; F2 38 48 11 FF F0
	ftwotox	 0x00010004,FP1		; F2 39 48 91 00 01 00
	ftwotox	5(PC),FP3		; F2 3A 49 91 00 01
	ftwotox	6(PC,A7.W),FP4		; F2 3B 4A 11 F0 02
	ftwotox	6(PC,A7.L),FP4		; F2 3B 4A 11 F8 02
	ftwotox	(0x1234,A0,D1),FP0	; F2 30 48 11 11 20 12
	ftwotox	([2,A1,A2],4),FP1	; F2 31 48 91 A1 22 00
	ftwotox	([6,A2],D3,8),FP2	; F2 32 49 11 31 26 00
	ftwotox	(0x1234,PC,D1),FP3	; F2 3B 49 91 11 20 12
	ftwotox	([2,PC,A2],4),FP4	; F2 3B 4A 11 A1 22 FF
	ftwotox	([6,PC],D3,8),FP5	; F2 3B 4A 91 31 26 00

	ftwotox.b	D0,FP0		; F2 00 58 11
	ftwotox.b	(A1),FP2	; F2 11 59 11
	ftwotox.b	(A2)+,FP3	; F2 1A 59 91
	ftwotox.b	-(A3),FP4	; F2 23 5A 11
	ftwotox.b	1(A4),FP5	; F2 2C 5A 91 00 01
	ftwotox.b	2(A5,D7.W),FP6	; F2 35 5B 11 70 02
	ftwotox.b	2(A5,D7.L),FP6	; F2 35 5B 11 78 02
	ftwotox.b	(0x1234).W,FP7	; F2 38 5B 91 12 34
	ftwotox.b	(0x1234).L,FP7	; F2 39 5B 91 00 00 12
	ftwotox.b	*0xFFFFFFF0,FP0	; F2 38 58 11 FF F0
	ftwotox.b	 0x00010004,FP1	; F2 39 58 91 00 01 00
	ftwotox.b	#7,FP2		; F2 3C 59 11 00 07
	ftwotox.b	5(PC),FP3	; F2 3A 59 91 00 01
	ftwotox.b	6(PC,A7.W),FP4	; F2 3B 5A 11 F0 02
	ftwotox.b	6(PC,A7.L),FP4	; F2 3B 5A 11 F8 02
	ftwotox.b	(0x1234,A0,D1),FP0	; F2 30 58 11 11 20 12
	ftwotox.b	([2,A1,A2],4),FP1	; F2 31 58 91 A1 22 00
	ftwotox.b	([6,A2],D3,8),FP2	; F2 32 59 11 31 26 00
	ftwotox.b	(0x1234,PC,D1),FP3	; F2 3B 59 91 11 20 12
	ftwotox.b	([2,PC,A2],4),FP4	; F2 3B 5A 11 A1 22 FF
	ftwotox.b	([6,PC],D3,8),FP5	; F2 3B 5A 91 31 26 00

	ftwotox.w	D0,FP0		; F2 00 50 11
	ftwotox.w	(A1),FP2	; F2 11 51 11
	ftwotox.w	(A2)+,FP3	; F2 1A 51 91
	ftwotox.w	-(A3),FP4	; F2 23 52 11
	ftwotox.w	1(A4),FP5	; F2 2C 52 91 00 01
	ftwotox.w	2(A5,D7.W),FP6	; F2 35 53 11 70 02
	ftwotox.w	2(A5,D7.L),FP6	; F2 35 53 11 78 02
	ftwotox.w	(0x1234).W,FP7	; F2 38 53 91 12 34
	ftwotox.w	(0x1234).L,FP7	; F2 39 53 91 00 00 12
	ftwotox.w	*0xFFFFFFF0,FP0	; F2 38 50 11 FF F0
	ftwotox.w	 0x00010004,FP1	; F2 39 50 91 00 01 00
	ftwotox.w	#7,FP2		; F2 3C 51 11 00 07
	ftwotox.w	5(PC),FP3	; F2 3A 51 91 00 01
	ftwotox.w	6(PC,A7.W),FP4	; F2 3B 52 11 F0 02
	ftwotox.w	6(PC,A7.L),FP4	; F2 3B 52 11 F8 02
	ftwotox.w	(0x1234,A0,D1),FP0	; F2 30 50 11 11 20 12
	ftwotox.w	([2,A1,A2],4),FP1	; F2 31 50 91 A1 22 00
	ftwotox.w	([6,A2],D3,8),FP2	; F2 32 51 11 31 26 00
	ftwotox.w	(0x1234,PC,D1),FP3	; F2 3B 51 91 11 20 12
	ftwotox.w	([2,PC,A2],4),FP4	; F2 3B 52 11 A1 22 FF
	ftwotox.w	([6,PC],D3,8),FP5	; F2 3B 52 91 31 26 00

	ftwotox.l	D0,FP0		; F2 00 40 11
	ftwotox.l	(A1),FP2	; F2 11 41 11
	ftwotox.l	(A2)+,FP3	; F2 1A 41 91
	ftwotox.l	-(A3),FP4	; F2 23 42 11
	ftwotox.l	1(A4),FP5	; F2 2C 42 91 00 01
	ftwotox.l	2(A5,D7.W),FP6	; F2 35 43 11 70 02
	ftwotox.l	2(A5,D7.L),FP6	; F2 35 43 11 78 02
	ftwotox.l	(0x1234).W,FP7	; F2 38 43 91 12 34
	ftwotox.l	(0x1234).L,FP7	; F2 39 43 91 00 00 12
	ftwotox.l	*0xFFFFFFF0,FP0	; F2 38 40 11 FF F0
	ftwotox.l	 0x00010004,FP1	; F2 39 40 91 00 01 00
	ftwotox.l	#7,FP2		; F2 3C 41 11 00 00 00
	ftwotox.l	5(PC),FP3	; F2 3A 41 91 00 01
	ftwotox.l	6(PC,A7.W),FP4	; F2 3B 42 11 F0 02
	ftwotox.l	6(PC,A7.L),FP4	; F2 3B 42 11 F8 02
	ftwotox.l	(0x1234,A0,D1),FP0	; F2 30 40 11 11 20 12
	ftwotox.l	([2,A1,A2],4),FP1	; F2 31 40 91 A1 22 00
	ftwotox.l	([6,A2],D3,8),FP2	; F2 32 41 11 31 26 00
	ftwotox.l	(0x1234,PC,D1),FP3	; F2 3B 41 91 11 20 12
	ftwotox.l	([2,PC,A2],4),FP4	; F2 3B 42 11 A1 22 FF
	ftwotox.l	([6,PC],D3,8),FP5	; F2 3B 42 91 31 26 00

	ftwotox.s	D0,FP0		; F2 00 44 11
	ftwotox.s	(A1),FP2	; F2 11 45 11
	ftwotox.s	(A2)+,FP3	; F2 1A 45 91
	ftwotox.s	-(A3),FP4	; F2 23 46 11
	ftwotox.s	1(A4),FP5	; F2 2C 46 91 00 01
	ftwotox.s	2(A5,D7.W),FP6	; F2 35 47 11 70 02
	ftwotox.s	2(A5,D7.L),FP6	; F2 35 47 11 78 02
	ftwotox.s	(0x1234).W,FP7	; F2 38 47 91 12 34
	ftwotox.s	(0x1234).L,FP7	; F2 39 47 91 00 00 12
	ftwotox.s	*0xFFFFFFF0,FP0	; F2 38 44 11 FF F0
	ftwotox.s	 0x00010004,FP1	; F2 39 44 91 00 01 00
	ftwotox.s	#7,FP2		; F2 3C 45 11 40 E0 00
	ftwotox.s	5(PC),FP3	; F2 3A 45 91 00 01
	ftwotox.s	6(PC,A7.W),FP4	; F2 3B 46 11 F0 02
	ftwotox.s	6(PC,A7.L),FP4	; F2 3B 46 11 F8 02
	ftwotox.s	(0x1234,A0,D1),FP0	; F2 30 44 11 11 20 12
	ftwotox.s	([2,A1,A2],4),FP1	; F2 31 44 91 A1 22 00
	ftwotox.s	([6,A2],D3,8),FP2	; F2 32 45 11 31 26 00
	ftwotox.s	(0x1234,PC,D1),FP3	; F2 3B 45 91 11 20 12
	ftwotox.s	([2,PC,A2],4),FP4	; F2 3B 46 11 A1 22 FF
	ftwotox.s	([6,PC],D3,8),FP5	; F2 3B 46 91 31 26 00

	ftwotox.d	(A1),FP2	; F2 11 55 11
	ftwotox.d	(A2)+,FP3	; F2 1A 55 91
	ftwotox.d	-(A3),FP4	; F2 23 56 11
	ftwotox.d	1(A4),FP5	; F2 2C 56 91 00 01
	ftwotox.d	2(A5,D7.W),FP6	; F2 35 57 11 70 02
	ftwotox.d	2(A5,D7.L),FP6	; F2 35 57 11 78 02
	ftwotox.d	(0x1234).W,FP7	; F2 38 57 91 12 34
	ftwotox.d	(0x1234).L,FP7	; F2 39 57 91 00 00 12
	ftwotox.d	*0xFFFFFFF0,FP0	; F2 38 54 11 FF F0
	ftwotox.d	 0x00010004,FP1	; F2 39 54 91 00 01 00
	ftwotox.d	5(PC),FP3	; F2 3A 55 91 00 01
	ftwotox.d	6(PC,A7.W),FP4	; F2 3B 56 11 F0 02
	ftwotox.d	6(PC,A7.L),FP4	; F2 3B 56 11 F8 02
	ftwotox.d	(0x1234,A0,D1),FP0	; F2 30 54 11 11 20 12
	ftwotox.d	([2,A1,A2],4),FP1	; F2 31 54 91 A1 22 00
	ftwotox.d	([6,A2],D3,8),FP2	; F2 32 55 11 31 26 00
	ftwotox.d	(0x1234,PC,D1),FP3	; F2 3B 55 91 11 20 12
	ftwotox.d	([2,PC,A2],4),FP4	; F2 3B 56 11 A1 22 FF
	ftwotox.d	([6,PC],D3,8),FP5	; F2 3B 56 91 31 26 00

	ftwotox.x	FP7		; F2 00 1F 91
	ftwotox.x	FP1,FP2		; F2 00 05 11

	ftwotox.x	(A1),FP2	; F2 11 49 11
	ftwotox.x	(A2)+,FP3	; F2 1A 49 91
	ftwotox.x	-(A3),FP4	; F2 23 4A 11
	ftwotox.x	1(A4),FP5	; F2 2C 4A 91 00 01
	ftwotox.x	2(A5,D7.W),FP6	; F2 35 4B 11 70 02
	ftwotox.x	2(A5,D7.L),FP6	; F2 35 4B 11 78 02
	ftwotox.x	(0x1234).W,FP7	; F2 38 4B 91 12 34
	ftwotox.x	(0x1234).L,FP7	; F2 39 4B 91 00 00 12
	ftwotox.x	*0xFFFFFFF0,FP0	; F2 38 48 11 FF F0
	ftwotox.x	 0x00010004,FP1	; F2 39 48 91 00 01 00
	ftwotox.x	5(PC),FP3	; F2 3A 49 91 00 01
	ftwotox.x	6(PC,A7.W),FP4	; F2 3B 4A 11 F0 02
	ftwotox.x	6(PC,A7.L),FP4	; F2 3B 4A 11 F8 02
	ftwotox.x	(0x1234,A0,D1),FP0	; F2 30 48 11 11 20 12
	ftwotox.x	([2,A1,A2],4),FP1	; F2 31 48 91 A1 22 00
	ftwotox.x	([6,A2],D3,8),FP2	; F2 32 49 11 31 26 00
	ftwotox.x	(0x1234,PC,D1),FP3	; F2 3B 49 91 11 20 12
	ftwotox.x	([2,PC,A2],4),FP4	; F2 3B 4A 11 A1 22 FF
	ftwotox.x	([6,PC],D3,8),FP5	; F2 3B 4A 91 31 26 00

	ftwotox.p	(A1),FP2	; F2 11 4D 11
	ftwotox.p	(A2)+,FP3	; F2 1A 4D 91
	ftwotox.p	-(A3),FP4	; F2 23 4E 11
	ftwotox.p	1(A4),FP5	; F2 2C 4E 91 00 01
	ftwotox.p	2(A5,D7.W),FP6	; F2 35 4F 11 70 02
	ftwotox.p	2(A5,D7.L),FP6	; F2 35 4F 11 78 02
	ftwotox.p	(0x1234).W,FP7	; F2 38 4F 91 12 34
	ftwotox.p	(0x1234).L,FP7	; F2 39 4F 91 00 00 12
	ftwotox.p	*0xFFFFFFF0,FP0	; F2 38 4C 11 FF F0
	ftwotox.p	 0x00010004,FP1	; F2 39 4C 91 00 01 00
	ftwotox.p	5(PC),FP3	; F2 3A 4D 91 00 01
	ftwotox.p	6(PC,A7.W),FP4	; F2 3B 4E 11 F0 02
	ftwotox.p	6(PC,A7.L),FP4	; F2 3B 4E 11 F8 02
	ftwotox.p	(0x1234,A0,D1),FP0	; F2 30 4C 11 11 20 12
	ftwotox.p	([2,A1,A2],4),FP1	; F2 31 4C 91 A1 22 00
	ftwotox.p	([6,A2],D3,8),FP2	; F2 32 4D 11 31 26 00
	ftwotox.p	(0x1234,PC,D1),FP3	; F2 3B 4D 91 11 20 12
	ftwotox.p	([2,PC,A2],4),FP4	; F2 3B 4E 11 A1 22 FF
	ftwotox.p	([6,PC],D3,8),FP5	; F2 3B 4E 91 31 26 00

	ftentox	FP7			; F2 00 1F 92
	ftentox	FP1,FP2			; F2 00 05 12

	ftentox	(A1),FP2		; F2 11 49 12
	ftentox	(A2)+,FP3		; F2 1A 49 92
	ftentox	-(A3),FP4		; F2 23 4A 12
	ftentox	1(A4),FP5		; F2 2C 4A 92 00 01
	ftentox	2(A5,D7.W),FP6		; F2 35 4B 12 70 02
	ftentox	2(A5,D7.L),FP6		; F2 35 4B 12 78 02
	ftentox	(0x1234).W,FP7		; F2 38 4B 92 12 34
	ftentox	(0x1234).L,FP7		; F2 39 4B 92 00 00 12
	ftentox	*0xFFFFFFF0,FP0		; F2 38 48 12 FF F0
	ftentox	 0x00010004,FP1		; F2 39 48 92 00 01 00
	ftentox	5(PC),FP3		; F2 3A 49 92 00 01
	ftentox	6(PC,A7.W),FP4		; F2 3B 4A 12 F0 02
	ftentox	6(PC,A7.L),FP4		; F2 3B 4A 12 F8 02
	ftentox	(0x1234,A0,D1),FP0	; F2 30 48 12 11 20 12
	ftentox	([2,A1,A2],4),FP1	; F2 31 48 92 A1 22 00
	ftentox	([6,A2],D3,8),FP2	; F2 32 49 12 31 26 00
	ftentox	(0x1234,PC,D1),FP3	; F2 3B 49 92 11 20 12
	ftentox	([2,PC,A2],4),FP4	; F2 3B 4A 12 A1 22 FF
	ftentox	([6,PC],D3,8),FP5	; F2 3B 4A 92 31 26 00

	ftentox.b	D0,FP0		; F2 00 58 12
	ftentox.b	(A1),FP2	; F2 11 59 12
	ftentox.b	(A2)+,FP3	; F2 1A 59 92
	ftentox.b	-(A3),FP4	; F2 23 5A 12
	ftentox.b	1(A4),FP5	; F2 2C 5A 92 00 01
	ftentox.b	2(A5,D7.W),FP6	; F2 35 5B 12 70 02
	ftentox.b	2(A5,D7.L),FP6	; F2 35 5B 12 78 02
	ftentox.b	(0x1234).W,FP7	; F2 38 5B 92 12 34
	ftentox.b	(0x1234).L,FP7	; F2 39 5B 92 00 00 12
	ftentox.b	*0xFFFFFFF0,FP0	; F2 38 58 12 FF F0
	ftentox.b	 0x00010004,FP1	; F2 39 58 92 00 01 00
	ftentox.b	#7,FP2		; F2 3C 59 12 00 07
	ftentox.b	5(PC),FP3	; F2 3A 59 92 00 01
	ftentox.b	6(PC,A7.W),FP4	; F2 3B 5A 12 F0 02
	ftentox.b	6(PC,A7.L),FP4	; F2 3B 5A 12 F8 02
	ftentox.b	(0x1234,A0,D1),FP0	; F2 30 58 12 11 20 12
	ftentox.b	([2,A1,A2],4),FP1	; F2 31 58 92 A1 22 00
	ftentox.b	([6,A2],D3,8),FP2	; F2 32 59 12 31 26 00
	ftentox.b	(0x1234,PC,D1),FP3	; F2 3B 59 92 11 20 12
	ftentox.b	([2,PC,A2],4),FP4	; F2 3B 5A 12 A1 22 FF
	ftentox.b	([6,PC],D3,8),FP5	; F2 3B 5A 92 31 26 00

	ftentox.w	D0,FP0		; F2 00 50 12
	ftentox.w	(A1),FP2	; F2 11 51 12
	ftentox.w	(A2)+,FP3	; F2 1A 51 92
	ftentox.w	-(A3),FP4	; F2 23 52 12
	ftentox.w	1(A4),FP5	; F2 2C 52 92 00 01
	ftentox.w	2(A5,D7.W),FP6	; F2 35 53 12 70 02
	ftentox.w	2(A5,D7.L),FP6	; F2 35 53 12 78 02
	ftentox.w	(0x1234).W,FP7	; F2 38 53 92 12 34
	ftentox.w	(0x1234).L,FP7	; F2 39 53 92 00 00 12
	ftentox.w	*0xFFFFFFF0,FP0	; F2 38 50 12 FF F0
	ftentox.w	 0x00010004,FP1	; F2 39 50 92 00 01 00
	ftentox.w	#7,FP2		; F2 3C 51 12 00 07
	ftentox.w	5(PC),FP3	; F2 3A 51 92 00 01
	ftentox.w	6(PC,A7.W),FP4	; F2 3B 52 12 F0 02
	ftentox.w	6(PC,A7.L),FP4	; F2 3B 52 12 F8 02
	ftentox.w	(0x1234,A0,D1),FP0	; F2 30 50 12 11 20 12
	ftentox.w	([2,A1,A2],4),FP1	; F2 31 50 92 A1 22 00
	ftentox.w	([6,A2],D3,8),FP2	; F2 32 51 12 31 26 00
	ftentox.w	(0x1234,PC,D1),FP3	; F2 3B 51 92 11 20 12
	ftentox.w	([2,PC,A2],4),FP4	; F2 3B 52 12 A1 22 FF
	ftentox.w	([6,PC],D3,8),FP5	; F2 3B 52 92 31 26 00

	ftentox.l	D0,FP0		; F2 00 40 12
	ftentox.l	(A1),FP2	; F2 11 41 12
	ftentox.l	(A2)+,FP3	; F2 1A 41 92
	ftentox.l	-(A3),FP4	; F2 23 42 12
	ftentox.l	1(A4),FP5	; F2 2C 42 92 00 01
	ftentox.l	2(A5,D7.W),FP6	; F2 35 43 12 70 02
	ftentox.l	2(A5,D7.L),FP6	; F2 35 43 12 78 02
	ftentox.l	(0x1234).W,FP7	; F2 38 43 92 12 34
	ftentox.l	(0x1234).L,FP7	; F2 39 43 92 00 00 12
	ftentox.l	*0xFFFFFFF0,FP0	; F2 38 40 12 FF F0
	ftentox.l	 0x00010004,FP1	; F2 39 40 92 00 01 00
	ftentox.l	#7,FP2		; F2 3C 41 12 00 00 00
	ftentox.l	5(PC),FP3	; F2 3A 41 92 00 01
	ftentox.l	6(PC,A7.W),FP4	; F2 3B 42 12 F0 02
	ftentox.l	6(PC,A7.L),FP4	; F2 3B 42 12 F8 02
	ftentox.l	(0x1234,A0,D1),FP0	; F2 30 40 12 11 20 12
	ftentox.l	([2,A1,A2],4),FP1	; F2 31 40 92 A1 22 00
	ftentox.l	([6,A2],D3,8),FP2	; F2 32 41 12 31 26 00
	ftentox.l	(0x1234,PC,D1),FP3	; F2 3B 41 92 11 20 12
	ftentox.l	([2,PC,A2],4),FP4	; F2 3B 42 12 A1 22 FF
	ftentox.l	([6,PC],D3,8),FP5	; F2 3B 42 92 31 26 00

	ftentox.s	D0,FP0		; F2 00 44 12
	ftentox.s	(A1),FP2	; F2 11 45 12
	ftentox.s	(A2)+,FP3	; F2 1A 45 92
	ftentox.s	-(A3),FP4	; F2 23 46 12
	ftentox.s	1(A4),FP5	; F2 2C 46 92 00 01
	ftentox.s	2(A5,D7.W),FP6	; F2 35 47 12 70 02
	ftentox.s	2(A5,D7.L),FP6	; F2 35 47 12 78 02
	ftentox.s	(0x1234).W,FP7	; F2 38 47 92 12 34
	ftentox.s	(0x1234).L,FP7	; F2 39 47 92 00 00 12
	ftentox.s	*0xFFFFFFF0,FP0	; F2 38 44 12 FF F0
	ftentox.s	 0x00010004,FP1	; F2 39 44 92 00 01 00
	ftentox.s	#7,FP2		; F2 3C 45 12 40 E0 00
	ftentox.s	5(PC),FP3	; F2 3A 45 92 00 01
	ftentox.s	6(PC,A7.W),FP4	; F2 3B 46 12 F0 02
	ftentox.s	6(PC,A7.L),FP4	; F2 3B 46 12 F8 02
	ftentox.s	(0x1234,A0,D1),FP0	; F2 30 44 12 11 20 12
	ftentox.s	([2,A1,A2],4),FP1	; F2 31 44 92 A1 22 00
	ftentox.s	([6,A2],D3,8),FP2	; F2 32 45 12 31 26 00
	ftentox.s	(0x1234,PC,D1),FP3	; F2 3B 45 92 11 20 12
	ftentox.s	([2,PC,A2],4),FP4	; F2 3B 46 12 A1 22 FF
	ftentox.s	([6,PC],D3,8),FP5	; F2 3B 46 92 31 26 00

	ftentox.d	(A1),FP2	; F2 11 55 12
	ftentox.d	(A2)+,FP3	; F2 1A 55 92
	ftentox.d	-(A3),FP4	; F2 23 56 12
	ftentox.d	1(A4),FP5	; F2 2C 56 92 00 01
	ftentox.d	2(A5,D7.W),FP6	; F2 35 57 12 70 02
	ftentox.d	2(A5,D7.L),FP6	; F2 35 57 12 78 02
	ftentox.d	(0x1234).W,FP7	; F2 38 57 92 12 34
	ftentox.d	(0x1234).L,FP7	; F2 39 57 92 00 00 12
	ftentox.d	*0xFFFFFFF0,FP0	; F2 38 54 12 FF F0
	ftentox.d	 0x00010004,FP1	; F2 39 54 92 00 01 00
	ftentox.d	5(PC),FP3	; F2 3A 55 92 00 01
	ftentox.d	6(PC,A7.W),FP4	; F2 3B 56 12 F0 02
	ftentox.d	6(PC,A7.L),FP4	; F2 3B 56 12 F8 02
	ftentox.d	(0x1234,A0,D1),FP0	; F2 30 54 12 11 20 12
	ftentox.d	([2,A1,A2],4),FP1	; F2 31 54 92 A1 22 00
	ftentox.d	([6,A2],D3,8),FP2	; F2 32 55 12 31 26 00
	ftentox.d	(0x1234,PC,D1),FP3	; F2 3B 55 92 11 20 12
	ftentox.d	([2,PC,A2],4),FP4	; F2 3B 56 12 A1 22 FF
	ftentox.d	([6,PC],D3,8),FP5	; F2 3B 56 92 31 26 00

	ftentox.x	FP7		; F2 00 1F 92
	ftentox.x	FP1,FP2		; F2 00 05 12

	ftentox.x	(A1),FP2	; F2 11 49 12
	ftentox.x	(A2)+,FP3	; F2 1A 49 92
	ftentox.x	-(A3),FP4	; F2 23 4A 12
	ftentox.x	1(A4),FP5	; F2 2C 4A 92 00 01
	ftentox.x	2(A5,D7.W),FP6	; F2 35 4B 12 70 02
	ftentox.x	2(A5,D7.L),FP6	; F2 35 4B 12 78 02
	ftentox.x	(0x1234).W,FP7	; F2 38 4B 92 12 34
	ftentox.x	(0x1234).L,FP7	; F2 39 4B 92 00 00 12
	ftentox.x	*0xFFFFFFF0,FP0	; F2 38 48 12 FF F0
	ftentox.x	 0x00010004,FP1	; F2 39 48 92 00 01 00
	ftentox.x	5(PC),FP3	; F2 3A 49 92 00 01
	ftentox.x	6(PC,A7.W),FP4	; F2 3B 4A 12 F0 02
	ftentox.x	6(PC,A7.L),FP4	; F2 3B 4A 12 F8 02
	ftentox.x	(0x1234,A0,D1),FP0	; F2 30 48 12 11 20 12
	ftentox.x	([2,A1,A2],4),FP1	; F2 31 48 92 A1 22 00
	ftentox.x	([6,A2],D3,8),FP2	; F2 32 49 12 31 26 00
	ftentox.x	(0x1234,PC,D1),FP3	; F2 3B 49 92 11 20 12
	ftentox.x	([2,PC,A2],4),FP4	; F2 3B 4A 12 A1 22 FF
	ftentox.x	([6,PC],D3,8),FP5	; F2 3B 4A 92 31 26 00

	ftentox.p	(A1),FP2	; F2 11 4D 12
	ftentox.p	(A2)+,FP3	; F2 1A 4D 92
	ftentox.p	-(A3),FP4	; F2 23 4E 12
	ftentox.p	1(A4),FP5	; F2 2C 4E 92 00 01
	ftentox.p	2(A5,D7.W),FP6	; F2 35 4F 12 70 02
	ftentox.p	2(A5,D7.L),FP6	; F2 35 4F 12 78 02
	ftentox.p	(0x1234).W,FP7	; F2 38 4F 92 12 34
	ftentox.p	(0x1234).L,FP7	; F2 39 4F 92 00 00 12
	ftentox.p	*0xFFFFFFF0,FP0	; F2 38 4C 12 FF F0
	ftentox.p	 0x00010004,FP1	; F2 39 4C 92 00 01 00
	ftentox.p	5(PC),FP3	; F2 3A 4D 92 00 01
	ftentox.p	6(PC,A7.W),FP4	; F2 3B 4E 12 F0 02
	ftentox.p	6(PC,A7.L),FP4	; F2 3B 4E 12 F8 02
	ftentox.p	(0x1234,A0,D1),FP0	; F2 30 4C 12 11 20 12
	ftentox.p	([2,A1,A2],4),FP1	; F2 31 4C 92 A1 22 00
	ftentox.p	([6,A2],D3,8),FP2	; F2 32 4D 12 31 26 00
	ftentox.p	(0x1234,PC,D1),FP3	; F2 3B 4D 92 11 20 12
	ftentox.p	([2,PC,A2],4),FP4	; F2 3B 4E 12 A1 22 FF
	ftentox.p	([6,PC],D3,8),FP5	; F2 3B 4E 92 31 26 00

	flogn	FP7			; F2 00 1F 94
	flogn	FP1,FP2			; F2 00 05 14

	flogn	(A1),FP2		; F2 11 49 14
	flogn	(A2)+,FP3		; F2 1A 49 94
	flogn	-(A3),FP4		; F2 23 4A 14
	flogn	1(A4),FP5		; F2 2C 4A 94 00 01
	flogn	2(A5,D7.W),FP6		; F2 35 4B 14 70 02
	flogn	2(A5,D7.L),FP6		; F2 35 4B 14 78 02
	flogn	(0x1234).W,FP7		; F2 38 4B 94 12 34
	flogn	(0x1234).L,FP7		; F2 39 4B 94 00 00 12
	flogn	*0xFFFFFFF0,FP0		; F2 38 48 14 FF F0
	flogn	 0x00010004,FP1		; F2 39 48 94 00 01 00
	flogn	5(PC),FP3		; F2 3A 49 94 00 01
	flogn	6(PC,A7.W),FP4		; F2 3B 4A 14 F0 02
	flogn	6(PC,A7.L),FP4		; F2 3B 4A 14 F8 02
	flogn	(0x1234,A0,D1),FP0	; F2 30 48 14 11 20 12
	flogn	([2,A1,A2],4),FP1	; F2 31 48 94 A1 22 00
	flogn	([6,A2],D3,8),FP2	; F2 32 49 14 31 26 00
	flogn	(0x1234,PC,D1),FP3	; F2 3B 49 94 11 20 12
	flogn	([2,PC,A2],4),FP4	; F2 3B 4A 14 A1 22 FF
	flogn	([6,PC],D3,8),FP5	; F2 3B 4A 94 31 26 00

	flogn.b	D0,FP0			; F2 00 58 14
	flogn.b	(A1),FP2		; F2 11 59 14
	flogn.b	(A2)+,FP3		; F2 1A 59 94
	flogn.b	-(A3),FP4		; F2 23 5A 14
	flogn.b	1(A4),FP5		; F2 2C 5A 94 00 01
	flogn.b	2(A5,D7.W),FP6		; F2 35 5B 14 70 02
	flogn.b	2(A5,D7.L),FP6		; F2 35 5B 14 78 02
	flogn.b	(0x1234).W,FP7		; F2 38 5B 94 12 34
	flogn.b	(0x1234).L,FP7		; F2 39 5B 94 00 00 12
	flogn.b	*0xFFFFFFF0,FP0		; F2 38 58 14 FF F0
	flogn.b	 0x00010004,FP1		; F2 39 58 94 00 01 00
	flogn.b	#7,FP2			; F2 3C 59 14 00 07
	flogn.b	5(PC),FP3		; F2 3A 59 94 00 01
	flogn.b	6(PC,A7.W),FP4		; F2 3B 5A 14 F0 02
	flogn.b	6(PC,A7.L),FP4		; F2 3B 5A 14 F8 02
	flogn.b	(0x1234,A0,D1),FP0	; F2 30 58 14 11 20 12
	flogn.b	([2,A1,A2],4),FP1	; F2 31 58 94 A1 22 00
	flogn.b	([6,A2],D3,8),FP2	; F2 32 59 14 31 26 00
	flogn.b	(0x1234,PC,D1),FP3	; F2 3B 59 94 11 20 12
	flogn.b	([2,PC,A2],4),FP4	; F2 3B 5A 14 A1 22 FF
	flogn.b	([6,PC],D3,8),FP5	; F2 3B 5A 94 31 26 00

	flogn.w	D0,FP0			; F2 00 50 14
	flogn.w	(A1),FP2		; F2 11 51 14
	flogn.w	(A2)+,FP3		; F2 1A 51 94
	flogn.w	-(A3),FP4		; F2 23 52 14
	flogn.w	1(A4),FP5		; F2 2C 52 94 00 01
	flogn.w	2(A5,D7.W),FP6		; F2 35 53 14 70 02
	flogn.w	2(A5,D7.L),FP6		; F2 35 53 14 78 02
	flogn.w	(0x1234).W,FP7		; F2 38 53 94 12 34
	flogn.w	(0x1234).L,FP7		; F2 39 53 94 00 00 12
	flogn.w	*0xFFFFFFF0,FP0		; F2 38 50 14 FF F0
	flogn.w	 0x00010004,FP1		; F2 39 50 94 00 01 00
	flogn.w	#7,FP2			; F2 3C 51 14 00 07
	flogn.w	5(PC),FP3		; F2 3A 51 94 00 01
	flogn.w	6(PC,A7.W),FP4		; F2 3B 52 14 F0 02
	flogn.w	6(PC,A7.L),FP4		; F2 3B 52 14 F8 02
	flogn.w	(0x1234,A0,D1),FP0	; F2 30 50 14 11 20 12
	flogn.w	([2,A1,A2],4),FP1	; F2 31 50 94 A1 22 00
	flogn.w	([6,A2],D3,8),FP2	; F2 32 51 14 31 26 00
	flogn.w	(0x1234,PC,D1),FP3	; F2 3B 51 94 11 20 12
	flogn.w	([2,PC,A2],4),FP4	; F2 3B 52 14 A1 22 FF
	flogn.w	([6,PC],D3,8),FP5	; F2 3B 52 94 31 26 00

	flogn.l	D0,FP0			; F2 00 40 14
	flogn.l	(A1),FP2		; F2 11 41 14
	flogn.l	(A2)+,FP3		; F2 1A 41 94
	flogn.l	-(A3),FP4		; F2 23 42 14
	flogn.l	1(A4),FP5		; F2 2C 42 94 00 01
	flogn.l	2(A5,D7.W),FP6		; F2 35 43 14 70 02
	flogn.l	2(A5,D7.L),FP6		; F2 35 43 14 78 02
	flogn.l	(0x1234).W,FP7		; F2 38 43 94 12 34
	flogn.l	(0x1234).L,FP7		; F2 39 43 94 00 00 12
	flogn.l	*0xFFFFFFF0,FP0		; F2 38 40 14 FF F0
	flogn.l	 0x00010004,FP1		; F2 39 40 94 00 01 00
	flogn.l	#7,FP2			; F2 3C 41 14 00 00 00
	flogn.l	5(PC),FP3		; F2 3A 41 94 00 01
	flogn.l	6(PC,A7.W),FP4		; F2 3B 42 14 F0 02
	flogn.l	6(PC,A7.L),FP4		; F2 3B 42 14 F8 02
	flogn.l	(0x1234,A0,D1),FP0	; F2 30 40 14 11 20 12
	flogn.l	([2,A1,A2],4),FP1	; F2 31 40 94 A1 22 00
	flogn.l	([6,A2],D3,8),FP2	; F2 32 41 14 31 26 00
	flogn.l	(0x1234,PC,D1),FP3	; F2 3B 41 94 11 20 12
	flogn.l	([2,PC,A2],4),FP4	; F2 3B 42 14 A1 22 FF
	flogn.l	([6,PC],D3,8),FP5	; F2 3B 42 94 31 26 00

	flogn.s	D0,FP0			; F2 00 44 14
	flogn.s	(A1),FP2		; F2 11 45 14
	flogn.s	(A2)+,FP3		; F2 1A 45 94
	flogn.s	-(A3),FP4		; F2 23 46 14
	flogn.s	1(A4),FP5		; F2 2C 46 94 00 01
	flogn.s	2(A5,D7.W),FP6		; F2 35 47 14 70 02
	flogn.s	2(A5,D7.L),FP6		; F2 35 47 14 78 02
	flogn.s	(0x1234).W,FP7		; F2 38 47 94 12 34
	flogn.s	(0x1234).L,FP7		; F2 39 47 94 00 00 12
	flogn.s	*0xFFFFFFF0,FP0		; F2 38 44 14 FF F0
	flogn.s	 0x00010004,FP1		; F2 39 44 94 00 01 00
	flogn.s	#7,FP2			; F2 3C 45 14 40 E0 00
	flogn.s	5(PC),FP3		; F2 3A 45 94 00 01
	flogn.s	6(PC,A7.W),FP4		; F2 3B 46 14 F0 02
	flogn.s	6(PC,A7.L),FP4		; F2 3B 46 14 F8 02
	flogn.s	(0x1234,A0,D1),FP0	; F2 30 44 14 11 20 12
	flogn.s	([2,A1,A2],4),FP1	; F2 31 44 94 A1 22 00
	flogn.s	([6,A2],D3,8),FP2	; F2 32 45 14 31 26 00
	flogn.s	(0x1234,PC,D1),FP3	; F2 3B 45 94 11 20 12
	flogn.s	([2,PC,A2],4),FP4	; F2 3B 46 14 A1 22 FF
	flogn.s	([6,PC],D3,8),FP5	; F2 3B 46 94 31 26 00

	flogn.d	(A1),FP2		; F2 11 55 14
	flogn.d	(A2)+,FP3		; F2 1A 55 94
	flogn.d	-(A3),FP4		; F2 23 56 14
	flogn.d	1(A4),FP5		; F2 2C 56 94 00 01
	flogn.d	2(A5,D7.W),FP6		; F2 35 57 14 70 02
	flogn.d	2(A5,D7.L),FP6		; F2 35 57 14 78 02
	flogn.d	(0x1234).W,FP7		; F2 38 57 94 12 34
	flogn.d	(0x1234).L,FP7		; F2 39 57 94 00 00 12
	flogn.d	*0xFFFFFFF0,FP0		; F2 38 54 14 FF F0
	flogn.d	 0x00010004,FP1		; F2 39 54 94 00 01 00
	flogn.d	5(PC),FP3		; F2 3A 55 94 00 01
	flogn.d	6(PC,A7.W),FP4		; F2 3B 56 14 F0 02
	flogn.d	6(PC,A7.L),FP4		; F2 3B 56 14 F8 02
	flogn.d	(0x1234,A0,D1),FP0	; F2 30 54 14 11 20 12
	flogn.d	([2,A1,A2],4),FP1	; F2 31 54 94 A1 22 00
	flogn.d	([6,A2],D3,8),FP2	; F2 32 55 14 31 26 00
	flogn.d	(0x1234,PC,D1),FP3	; F2 3B 55 94 11 20 12
	flogn.d	([2,PC,A2],4),FP4	; F2 3B 56 14 A1 22 FF
	flogn.d	([6,PC],D3,8),FP5	; F2 3B 56 94 31 26 00

	flogn.x	FP7			; F2 00 1F 94
	flogn.x	FP1,FP2			; F2 00 05 14

	flogn.x	(A1),FP2		; F2 11 49 14
	flogn.x	(A2)+,FP3		; F2 1A 49 94
	flogn.x	-(A3),FP4		; F2 23 4A 14
	flogn.x	1(A4),FP5		; F2 2C 4A 94 00 01
	flogn.x	2(A5,D7.W),FP6		; F2 35 4B 14 70 02
	flogn.x	2(A5,D7.L),FP6		; F2 35 4B 14 78 02
	flogn.x	(0x1234).W,FP7		; F2 38 4B 94 12 34
	flogn.x	(0x1234).L,FP7		; F2 39 4B 94 00 00 12
	flogn.x	*0xFFFFFFF0,FP0		; F2 38 48 14 FF F0
	flogn.x	 0x00010004,FP1		; F2 39 48 94 00 01 00
	flogn.x	5(PC),FP3		; F2 3A 49 94 00 01
	flogn.x	6(PC,A7.W),FP4		; F2 3B 4A 14 F0 02
	flogn.x	6(PC,A7.L),FP4		; F2 3B 4A 14 F8 02
	flogn.x	(0x1234,A0,D1),FP0	; F2 30 48 14 11 20 12
	flogn.x	([2,A1,A2],4),FP1	; F2 31 48 94 A1 22 00
	flogn.x	([6,A2],D3,8),FP2	; F2 32 49 14 31 26 00
	flogn.x	(0x1234,PC,D1),FP3	; F2 3B 49 94 11 20 12
	flogn.x	([2,PC,A2],4),FP4	; F2 3B 4A 14 A1 22 FF
	flogn.x	([6,PC],D3,8),FP5	; F2 3B 4A 94 31 26 00

	flogn.p	(A1),FP2		; F2 11 4D 14
	flogn.p	(A2)+,FP3		; F2 1A 4D 94
	flogn.p	-(A3),FP4		; F2 23 4E 14
	flogn.p	1(A4),FP5		; F2 2C 4E 94 00 01
	flogn.p	2(A5,D7.W),FP6		; F2 35 4F 14 70 02
	flogn.p	2(A5,D7.L),FP6		; F2 35 4F 14 78 02
	flogn.p	(0x1234).W,FP7		; F2 38 4F 94 12 34
	flogn.p	(0x1234).L,FP7		; F2 39 4F 94 00 00 12
	flogn.p	*0xFFFFFFF0,FP0		; F2 38 4C 14 FF F0
	flogn.p	 0x00010004,FP1		; F2 39 4C 94 00 01 00
	flogn.p	5(PC),FP3		; F2 3A 4D 94 00 01
	flogn.p	6(PC,A7.W),FP4		; F2 3B 4E 14 F0 02
	flogn.p	6(PC,A7.L),FP4		; F2 3B 4E 14 F8 02
	flogn.p	(0x1234,A0,D1),FP0	; F2 30 4C 14 11 20 12
	flogn.p	([2,A1,A2],4),FP1	; F2 31 4C 94 A1 22 00
	flogn.p	([6,A2],D3,8),FP2	; F2 32 4D 14 31 26 00
	flogn.p	(0x1234,PC,D1),FP3	; F2 3B 4D 94 11 20 12
	flogn.p	([2,PC,A2],4),FP4	; F2 3B 4E 14 A1 22 FF
	flogn.p	([6,PC],D3,8),FP5	; F2 3B 4E 94 31 26 00

	flog10	FP7			; F2 00 1F 95
	flog10	FP1,FP2			; F2 00 05 15

	flog10	(A1),FP2		; F2 11 49 15
	flog10	(A2)+,FP3		; F2 1A 49 95
	flog10	-(A3),FP4		; F2 23 4A 15
	flog10	1(A4),FP5		; F2 2C 4A 95 00 01
	flog10	2(A5,D7.W),FP6		; F2 35 4B 15 70 02
	flog10	2(A5,D7.L),FP6		; F2 35 4B 15 78 02
	flog10	(0x1234).W,FP7		; F2 38 4B 95 12 34
	flog10	(0x1234).L,FP7		; F2 39 4B 95 00 00 12
	flog10	*0xFFFFFFF0,FP0		; F2 38 48 15 FF F0
	flog10	 0x00010004,FP1		; F2 39 48 95 00 01 00
	flog10	5(PC),FP3		; F2 3A 49 95 00 01
	flog10	6(PC,A7.W),FP4		; F2 3B 4A 15 F0 02
	flog10	6(PC,A7.L),FP4		; F2 3B 4A 15 F8 02
	flog10	(0x1234,A0,D1),FP0	; F2 30 48 15 11 20 12
	flog10	([2,A1,A2],4),FP1	; F2 31 48 95 A1 22 00
	flog10	([6,A2],D3,8),FP2	; F2 32 49 15 31 26 00
	flog10	(0x1234,PC,D1),FP3	; F2 3B 49 95 11 20 12
	flog10	([2,PC,A2],4),FP4	; F2 3B 4A 15 A1 22 FF
	flog10	([6,PC],D3,8),FP5	; F2 3B 4A 95 31 26 00

	flog10.b	D0,FP0		; F2 00 58 15
	flog10.b	(A1),FP2	; F2 11 59 15
	flog10.b	(A2)+,FP3	; F2 1A 59 95
	flog10.b	-(A3),FP4	; F2 23 5A 15
	flog10.b	1(A4),FP5	; F2 2C 5A 95 00 01
	flog10.b	2(A5,D7.W),FP6	; F2 35 5B 15 70 02
	flog10.b	2(A5,D7.L),FP6	; F2 35 5B 15 78 02
	flog10.b	(0x1234).W,FP7	; F2 38 5B 95 12 34
	flog10.b	(0x1234).L,FP7	; F2 39 5B 95 00 00 12
	flog10.b	*0xFFFFFFF0,FP0	; F2 38 58 15 FF F0
	flog10.b	 0x00010004,FP1	; F2 39 58 95 00 01 00
	flog10.b	#7,FP2		; F2 3C 59 15 00 07
	flog10.b	5(PC),FP3	; F2 3A 59 95 00 01
	flog10.b	6(PC,A7.W),FP4	; F2 3B 5A 15 F0 02
	flog10.b	6(PC,A7.L),FP4	; F2 3B 5A 15 F8 02
	flog10.b	(0x1234,A0,D1),FP0	; F2 30 58 15 11 20 12
	flog10.b	([2,A1,A2],4),FP1	; F2 31 58 95 A1 22 00
	flog10.b	([6,A2],D3,8),FP2	; F2 32 59 15 31 26 00
	flog10.b	(0x1234,PC,D1),FP3	; F2 3B 59 95 11 20 12
	flog10.b	([2,PC,A2],4),FP4	; F2 3B 5A 15 A1 22 FF
	flog10.b	([6,PC],D3,8),FP5	; F2 3B 5A 95 31 26 00

	flog10.w	D0,FP0		; F2 00 50 15
	flog10.w	(A1),FP2	; F2 11 51 15
	flog10.w	(A2)+,FP3	; F2 1A 51 95
	flog10.w	-(A3),FP4	; F2 23 52 15
	flog10.w	1(A4),FP5	; F2 2C 52 95 00 01
	flog10.w	2(A5,D7.W),FP6	; F2 35 53 15 70 02
	flog10.w	2(A5,D7.L),FP6	; F2 35 53 15 78 02
	flog10.w	(0x1234).W,FP7	; F2 38 53 95 12 34
	flog10.w	(0x1234).L,FP7	; F2 39 53 95 00 00 12
	flog10.w	*0xFFFFFFF0,FP0	; F2 38 50 15 FF F0
	flog10.w	 0x00010004,FP1	; F2 39 50 95 00 01 00
	flog10.w	#7,FP2		; F2 3C 51 15 00 07
	flog10.w	5(PC),FP3	; F2 3A 51 95 00 01
	flog10.w	6(PC,A7.W),FP4	; F2 3B 52 15 F0 02
	flog10.w	6(PC,A7.L),FP4	; F2 3B 52 15 F8 02
	flog10.w	(0x1234,A0,D1),FP0	; F2 30 50 15 11 20 12
	flog10.w	([2,A1,A2],4),FP1	; F2 31 50 95 A1 22 00
	flog10.w	([6,A2],D3,8),FP2	; F2 32 51 15 31 26 00
	flog10.w	(0x1234,PC,D1),FP3	; F2 3B 51 95 11 20 12
	flog10.w	([2,PC,A2],4),FP4	; F2 3B 52 15 A1 22 FF
	flog10.w	([6,PC],D3,8),FP5	; F2 3B 52 95 31 26 00

	flog10.l	D0,FP0		; F2 00 40 15
	flog10.l	(A1),FP2	; F2 11 41 15
	flog10.l	(A2)+,FP3	; F2 1A 41 95
	flog10.l	-(A3),FP4	; F2 23 42 15
	flog10.l	1(A4),FP5	; F2 2C 42 95 00 01
	flog10.l	2(A5,D7.W),FP6	; F2 35 43 15 70 02
	flog10.l	2(A5,D7.L),FP6	; F2 35 43 15 78 02
	flog10.l	(0x1234).W,FP7	; F2 38 43 95 12 34
	flog10.l	(0x1234).L,FP7	; F2 39 43 95 00 00 12
	flog10.l	*0xFFFFFFF0,FP0	; F2 38 40 15 FF F0
	flog10.l	 0x00010004,FP1	; F2 39 40 95 00 01 00
	flog10.l	#7,FP2		; F2 3C 41 15 00 00 00
	flog10.l	5(PC),FP3	; F2 3A 41 95 00 01
	flog10.l	6(PC,A7.W),FP4	; F2 3B 42 15 F0 02
	flog10.l	6(PC,A7.L),FP4	; F2 3B 42 15 F8 02
	flog10.l	(0x1234,A0,D1),FP0	; F2 30 40 15 11 20 12
	flog10.l	([2,A1,A2],4),FP1	; F2 31 40 95 A1 22 00
	flog10.l	([6,A2],D3,8),FP2	; F2 32 41 15 31 26 00
	flog10.l	(0x1234,PC,D1),FP3	; F2 3B 41 95 11 20 12
	flog10.l	([2,PC,A2],4),FP4	; F2 3B 42 15 A1 22 FF
	flog10.l	([6,PC],D3,8),FP5	; F2 3B 42 95 31 26 00

	flog10.s	D0,FP0		; F2 00 44 15
	flog10.s	(A1),FP2	; F2 11 45 15
	flog10.s	(A2)+,FP3	; F2 1A 45 95
	flog10.s	-(A3),FP4	; F2 23 46 15
	flog10.s	1(A4),FP5	; F2 2C 46 95 00 01
	flog10.s	2(A5,D7.W),FP6	; F2 35 47 15 70 02
	flog10.s	2(A5,D7.L),FP6	; F2 35 47 15 78 02
	flog10.s	(0x1234).W,FP7	; F2 38 47 95 12 34
	flog10.s	(0x1234).L,FP7	; F2 39 47 95 00 00 12
	flog10.s	*0xFFFFFFF0,FP0	; F2 38 44 15 FF F0
	flog10.s	 0x00010004,FP1	; F2 39 44 95 00 01 00
	flog10.s	#7,FP2		; F2 3C 45 15 40 E0 00
	flog10.s	5(PC),FP3	; F2 3A 45 95 00 01
	flog10.s	6(PC,A7.W),FP4	; F2 3B 46 15 F0 02
	flog10.s	6(PC,A7.L),FP4	; F2 3B 46 15 F8 02
	flog10.s	(0x1234,A0,D1),FP0	; F2 30 44 15 11 20 12
	flog10.s	([2,A1,A2],4),FP1	; F2 31 44 95 A1 22 00
	flog10.s	([6,A2],D3,8),FP2	; F2 32 45 15 31 26 00
	flog10.s	(0x1234,PC,D1),FP3	; F2 3B 45 95 11 20 12
	flog10.s	([2,PC,A2],4),FP4	; F2 3B 46 15 A1 22 FF
	flog10.s	([6,PC],D3,8),FP5	; F2 3B 46 95 31 26 00

	flog10.d	(A1),FP2	; F2 11 55 15
	flog10.d	(A2)+,FP3	; F2 1A 55 95
	flog10.d	-(A3),FP4	; F2 23 56 15
	flog10.d	1(A4),FP5	; F2 2C 56 95 00 01
	flog10.d	2(A5,D7.W),FP6	; F2 35 57 15 70 02
	flog10.d	2(A5,D7.L),FP6	; F2 35 57 15 78 02
	flog10.d	(0x1234).W,FP7	; F2 38 57 95 12 34
	flog10.d	(0x1234).L,FP7	; F2 39 57 95 00 00 12
	flog10.d	*0xFFFFFFF0,FP0	; F2 38 54 15 FF F0
	flog10.d	 0x00010004,FP1	; F2 39 54 95 00 01 00
	flog10.d	5(PC),FP3	; F2 3A 55 95 00 01
	flog10.d	6(PC,A7.W),FP4	; F2 3B 56 15 F0 02
	flog10.d	6(PC,A7.L),FP4	; F2 3B 56 15 F8 02
	flog10.d	(0x1234,A0,D1),FP0	; F2 30 54 15 11 20 12
	flog10.d	([2,A1,A2],4),FP1	; F2 31 54 95 A1 22 00
	flog10.d	([6,A2],D3,8),FP2	; F2 32 55 15 31 26 00
	flog10.d	(0x1234,PC,D1),FP3	; F2 3B 55 95 11 20 12
	flog10.d	([2,PC,A2],4),FP4	; F2 3B 56 15 A1 22 FF
	flog10.d	([6,PC],D3,8),FP5	; F2 3B 56 95 31 26 00

	flog10.x	FP7		; F2 00 1F 95
	flog10.x	FP1,FP2		; F2 00 05 15

	flog10.x	(A1),FP2	; F2 11 49 15
	flog10.x	(A2)+,FP3	; F2 1A 49 95
	flog10.x	-(A3),FP4	; F2 23 4A 15
	flog10.x	1(A4),FP5	; F2 2C 4A 95 00 01
	flog10.x	2(A5,D7.W),FP6	; F2 35 4B 15 70 02
	flog10.x	2(A5,D7.L),FP6	; F2 35 4B 15 78 02
	flog10.x	(0x1234).W,FP7	; F2 38 4B 95 12 34
	flog10.x	(0x1234).L,FP7	; F2 39 4B 95 00 00 12
	flog10.x	*0xFFFFFFF0,FP0	; F2 38 48 15 FF F0
	flog10.x	 0x00010004,FP1	; F2 39 48 95 00 01 00
	flog10.x	5(PC),FP3	; F2 3A 49 95 00 01
	flog10.x	6(PC,A7.W),FP4	; F2 3B 4A 15 F0 02
	flog10.x	6(PC,A7.L),FP4	; F2 3B 4A 15 F8 02
	flog10.x	(0x1234,A0,D1),FP0	; F2 30 48 15 11 20 12
	flog10.x	([2,A1,A2],4),FP1	; F2 31 48 95 A1 22 00
	flog10.x	([6,A2],D3,8),FP2	; F2 32 49 15 31 26 00
	flog10.x	(0x1234,PC,D1),FP3	; F2 3B 49 95 11 20 12
	flog10.x	([2,PC,A2],4),FP4	; F2 3B 4A 15 A1 22 FF
	flog10.x	([6,PC],D3,8),FP5	; F2 3B 4A 95 31 26 00

	flog10.p	(A1),FP2	; F2 11 4D 15
	flog10.p	(A2)+,FP3	; F2 1A 4D 95
	flog10.p	-(A3),FP4	; F2 23 4E 15
	flog10.p	1(A4),FP5	; F2 2C 4E 95 00 01
	flog10.p	2(A5,D7.W),FP6	; F2 35 4F 15 70 02
	flog10.p	2(A5,D7.L),FP6	; F2 35 4F 15 78 02
	flog10.p	(0x1234).W,FP7	; F2 38 4F 95 12 34
	flog10.p	(0x1234).L,FP7	; F2 39 4F 95 00 00 12
	flog10.p	*0xFFFFFFF0,FP0	; F2 38 4C 15 FF F0
	flog10.p	 0x00010004,FP1	; F2 39 4C 95 00 01 00
	flog10.p	5(PC),FP3	; F2 3A 4D 95 00 01
	flog10.p	6(PC,A7.W),FP4	; F2 3B 4E 15 F0 02
	flog10.p	6(PC,A7.L),FP4	; F2 3B 4E 15 F8 02
	flog10.p	(0x1234,A0,D1),FP0	; F2 30 4C 15 11 20 12
	flog10.p	([2,A1,A2],4),FP1	; F2 31 4C 95 A1 22 00
	flog10.p	([6,A2],D3,8),FP2	; F2 32 4D 15 31 26 00
	flog10.p	(0x1234,PC,D1),FP3	; F2 3B 4D 95 11 20 12
	flog10.p	([2,PC,A2],4),FP4	; F2 3B 4E 15 A1 22 FF
	flog10.p	([6,PC],D3,8),FP5	; F2 3B 4E 95 31 26 00

	flog2	FP7			; F2 00 1F 96
	flog2	FP1,FP2			; F2 00 05 16

	flog2	(A1),FP2		; F2 11 49 16
	flog2	(A2)+,FP3		; F2 1A 49 96
	flog2	-(A3),FP4		; F2 23 4A 16
	flog2	1(A4),FP5		; F2 2C 4A 96 00 01
	flog2	2(A5,D7.W),FP6		; F2 35 4B 16 70 02
	flog2	2(A5,D7.L),FP6		; F2 35 4B 16 78 02
	flog2	(0x1234).W,FP7		; F2 38 4B 96 12 34
	flog2	(0x1234).L,FP7		; F2 39 4B 96 00 00 12
	flog2	*0xFFFFFFF0,FP0		; F2 38 48 16 FF F0
	flog2	 0x00010004,FP1		; F2 39 48 96 00 01 00
	flog2	5(PC),FP3		; F2 3A 49 96 00 01
	flog2	6(PC,A7.W),FP4		; F2 3B 4A 16 F0 02
	flog2	6(PC,A7.L),FP4		; F2 3B 4A 16 F8 02
	flog2	(0x1234,A0,D1),FP0	; F2 30 48 16 11 20 12
	flog2	([2,A1,A2],4),FP1	; F2 31 48 96 A1 22 00
	flog2	([6,A2],D3,8),FP2	; F2 32 49 16 31 26 00
	flog2	(0x1234,PC,D1),FP3	; F2 3B 49 96 11 20 12
	flog2	([2,PC,A2],4),FP4	; F2 3B 4A 16 A1 22 FF
	flog2	([6,PC],D3,8),FP5	; F2 3B 4A 96 31 26 00

	flog2.b	D0,FP0			; F2 00 58 16
	flog2.b	(A1),FP2		; F2 11 59 16
	flog2.b	(A2)+,FP3		; F2 1A 59 96
	flog2.b	-(A3),FP4		; F2 23 5A 16
	flog2.b	1(A4),FP5		; F2 2C 5A 96 00 01
	flog2.b	2(A5,D7.W),FP6		; F2 35 5B 16 70 02
	flog2.b	2(A5,D7.L),FP6		; F2 35 5B 16 78 02
	flog2.b	(0x1234).W,FP7		; F2 38 5B 96 12 34
	flog2.b	(0x1234).L,FP7		; F2 39 5B 96 00 00 12
	flog2.b	*0xFFFFFFF0,FP0		; F2 38 58 16 FF F0
	flog2.b	 0x00010004,FP1		; F2 39 58 96 00 01 00
	flog2.b	#7,FP2			; F2 3C 59 16 00 07
	flog2.b	5(PC),FP3		; F2 3A 59 96 00 01
	flog2.b	6(PC,A7.W),FP4		; F2 3B 5A 16 F0 02
	flog2.b	6(PC,A7.L),FP4		; F2 3B 5A 16 F8 02
	flog2.b	(0x1234,A0,D1),FP0	; F2 30 58 16 11 20 12
	flog2.b	([2,A1,A2],4),FP1	; F2 31 58 96 A1 22 00
	flog2.b	([6,A2],D3,8),FP2	; F2 32 59 16 31 26 00
	flog2.b	(0x1234,PC,D1),FP3	; F2 3B 59 96 11 20 12
	flog2.b	([2,PC,A2],4),FP4	; F2 3B 5A 16 A1 22 FF
	flog2.b	([6,PC],D3,8),FP5	; F2 3B 5A 96 31 26 00

	flog2.w	D0,FP0			; F2 00 50 16
	flog2.w	(A1),FP2		; F2 11 51 16
	flog2.w	(A2)+,FP3		; F2 1A 51 96
	flog2.w	-(A3),FP4		; F2 23 52 16
	flog2.w	1(A4),FP5		; F2 2C 52 96 00 01
	flog2.w	2(A5,D7.W),FP6		; F2 35 53 16 70 02
	flog2.w	2(A5,D7.L),FP6		; F2 35 53 16 78 02
	flog2.w	(0x1234).W,FP7		; F2 38 53 96 12 34
	flog2.w	(0x1234).L,FP7		; F2 39 53 96 00 00 12
	flog2.w	*0xFFFFFFF0,FP0		; F2 38 50 16 FF F0
	flog2.w	 0x00010004,FP1		; F2 39 50 96 00 01 00
	flog2.w	#7,FP2			; F2 3C 51 16 00 07
	flog2.w	5(PC),FP3		; F2 3A 51 96 00 01
	flog2.w	6(PC,A7.W),FP4		; F2 3B 52 16 F0 02
	flog2.w	6(PC,A7.L),FP4		; F2 3B 52 16 F8 02
	flog2.w	(0x1234,A0,D1),FP0	; F2 30 50 16 11 20 12
	flog2.w	([2,A1,A2],4),FP1	; F2 31 50 96 A1 22 00
	flog2.w	([6,A2],D3,8),FP2	; F2 32 51 16 31 26 00
	flog2.w	(0x1234,PC,D1),FP3	; F2 3B 51 96 11 20 12
	flog2.w	([2,PC,A2],4),FP4	; F2 3B 52 16 A1 22 FF
	flog2.w	([6,PC],D3,8),FP5	; F2 3B 52 96 31 26 00

	flog2.l	D0,FP0			; F2 00 40 16
	flog2.l	(A1),FP2		; F2 11 41 16
	flog2.l	(A2)+,FP3		; F2 1A 41 96
	flog2.l	-(A3),FP4		; F2 23 42 16
	flog2.l	1(A4),FP5		; F2 2C 42 96 00 01
	flog2.l	2(A5,D7.W),FP6		; F2 35 43 16 70 02
	flog2.l	2(A5,D7.L),FP6		; F2 35 43 16 78 02
	flog2.l	(0x1234).W,FP7		; F2 38 43 96 12 34
	flog2.l	(0x1234).L,FP7		; F2 39 43 96 00 00 12
	flog2.l	*0xFFFFFFF0,FP0		; F2 38 40 16 FF F0
	flog2.l	 0x00010004,FP1		; F2 39 40 96 00 01 00
	flog2.l	#7,FP2			; F2 3C 41 16 00 00 00
	flog2.l	5(PC),FP3		; F2 3A 41 96 00 01
	flog2.l	6(PC,A7.W),FP4		; F2 3B 42 16 F0 02
	flog2.l	6(PC,A7.L),FP4		; F2 3B 42 16 F8 02
	flog2.l	(0x1234,A0,D1),FP0	; F2 30 40 16 11 20 12
	flog2.l	([2,A1,A2],4),FP1	; F2 31 40 96 A1 22 00
	flog2.l	([6,A2],D3,8),FP2	; F2 32 41 16 31 26 00
	flog2.l	(0x1234,PC,D1),FP3	; F2 3B 41 96 11 20 12
	flog2.l	([2,PC,A2],4),FP4	; F2 3B 42 16 A1 22 FF
	flog2.l	([6,PC],D3,8),FP5	; F2 3B 42 96 31 26 00

	flog2.s	D0,FP0			; F2 00 44 16
	flog2.s	(A1),FP2		; F2 11 45 16
	flog2.s	(A2)+,FP3		; F2 1A 45 96
	flog2.s	-(A3),FP4		; F2 23 46 16
	flog2.s	1(A4),FP5		; F2 2C 46 96 00 01
	flog2.s	2(A5,D7.W),FP6		; F2 35 47 16 70 02
	flog2.s	2(A5,D7.L),FP6		; F2 35 47 16 78 02
	flog2.s	(0x1234).W,FP7		; F2 38 47 96 12 34
	flog2.s	(0x1234).L,FP7		; F2 39 47 96 00 00 12
	flog2.s	*0xFFFFFFF0,FP0		; F2 38 44 16 FF F0
	flog2.s	 0x00010004,FP1		; F2 39 44 96 00 01 00
	flog2.s	#7,FP2			; F2 3C 45 16 40 E0 00
	flog2.s	5(PC),FP3		; F2 3A 45 96 00 01
	flog2.s	6(PC,A7.W),FP4		; F2 3B 46 16 F0 02
	flog2.s	6(PC,A7.L),FP4		; F2 3B 46 16 F8 02
	flog2.s	(0x1234,A0,D1),FP0	; F2 30 44 16 11 20 12
	flog2.s	([2,A1,A2],4),FP1	; F2 31 44 96 A1 22 00
	flog2.s	([6,A2],D3,8),FP2	; F2 32 45 16 31 26 00
	flog2.s	(0x1234,PC,D1),FP3	; F2 3B 45 96 11 20 12
	flog2.s	([2,PC,A2],4),FP4	; F2 3B 46 16 A1 22 FF
	flog2.s	([6,PC],D3,8),FP5	; F2 3B 46 96 31 26 00

	flog2.d	(A1),FP2		; F2 11 55 16
	flog2.d	(A2)+,FP3		; F2 1A 55 96
	flog2.d	-(A3),FP4		; F2 23 56 16
	flog2.d	1(A4),FP5		; F2 2C 56 96 00 01
	flog2.d	2(A5,D7.W),FP6		; F2 35 57 16 70 02
	flog2.d	2(A5,D7.L),FP6		; F2 35 57 16 78 02
	flog2.d	(0x1234).W,FP7		; F2 38 57 96 12 34
	flog2.d	(0x1234).L,FP7		; F2 39 57 96 00 00 12
	flog2.d	*0xFFFFFFF0,FP0		; F2 38 54 16 FF F0
	flog2.d	 0x00010004,FP1		; F2 39 54 96 00 01 00
	flog2.d	5(PC),FP3		; F2 3A 55 96 00 01
	flog2.d	6(PC,A7.W),FP4		; F2 3B 56 16 F0 02
	flog2.d	6(PC,A7.L),FP4		; F2 3B 56 16 F8 02
	flog2.d	(0x1234,A0,D1),FP0	; F2 30 54 16 11 20 12
	flog2.d	([2,A1,A2],4),FP1	; F2 31 54 96 A1 22 00
	flog2.d	([6,A2],D3,8),FP2	; F2 32 55 16 31 26 00
	flog2.d	(0x1234,PC,D1),FP3	; F2 3B 55 96 11 20 12
	flog2.d	([2,PC,A2],4),FP4	; F2 3B 56 16 A1 22 FF
	flog2.d	([6,PC],D3,8),FP5	; F2 3B 56 96 31 26 00

	flog2.x	FP7			; F2 00 1F 96
	flog2.x	FP1,FP2			; F2 00 05 16

	flog2.x	(A1),FP2		; F2 11 49 16
	flog2.x	(A2)+,FP3		; F2 1A 49 96
	flog2.x	-(A3),FP4		; F2 23 4A 16
	flog2.x	1(A4),FP5		; F2 2C 4A 96 00 01
	flog2.x	2(A5,D7.W),FP6		; F2 35 4B 16 70 02
	flog2.x	2(A5,D7.L),FP6		; F2 35 4B 16 78 02
	flog2.x	(0x1234).W,FP7		; F2 38 4B 96 12 34
	flog2.x	(0x1234).L,FP7		; F2 39 4B 96 00 00 12
	flog2.x	*0xFFFFFFF0,FP0		; F2 38 48 16 FF F0
	flog2.x	 0x00010004,FP1		; F2 39 48 96 00 01 00
	flog2.x	5(PC),FP3		; F2 3A 49 96 00 01
	flog2.x	6(PC,A7.W),FP4		; F2 3B 4A 16 F0 02
	flog2.x	6(PC,A7.L),FP4		; F2 3B 4A 16 F8 02
	flog2.x	(0x1234,A0,D1),FP0	; F2 30 48 16 11 20 12
	flog2.x	([2,A1,A2],4),FP1	; F2 31 48 96 A1 22 00
	flog2.x	([6,A2],D3,8),FP2	; F2 32 49 16 31 26 00
	flog2.x	(0x1234,PC,D1),FP3	; F2 3B 49 96 11 20 12
	flog2.x	([2,PC,A2],4),FP4	; F2 3B 4A 16 A1 22 FF
	flog2.x	([6,PC],D3,8),FP5	; F2 3B 4A 96 31 26 00

	flog2.p	(A1),FP2		; F2 11 4D 16
	flog2.p	(A2)+,FP3		; F2 1A 4D 96
	flog2.p	-(A3),FP4		; F2 23 4E 16
	flog2.p	1(A4),FP5		; F2 2C 4E 96 00 01
	flog2.p	2(A5,D7.W),FP6		; F2 35 4F 16 70 02
	flog2.p	2(A5,D7.L),FP6		; F2 35 4F 16 78 02
	flog2.p	(0x1234).W,FP7		; F2 38 4F 96 12 34
	flog2.p	(0x1234).L,FP7		; F2 39 4F 96 00 00 12
	flog2.p	*0xFFFFFFF0,FP0		; F2 38 4C 16 FF F0
	flog2.p	 0x00010004,FP1		; F2 39 4C 96 00 01 00
	flog2.p	5(PC),FP3		; F2 3A 4D 96 00 01
	flog2.p	6(PC,A7.W),FP4		; F2 3B 4E 16 F0 02
	flog2.p	6(PC,A7.L),FP4		; F2 3B 4E 16 F8 02
	flog2.p	(0x1234,A0,D1),FP0	; F2 30 4C 16 11 20 12
	flog2.p	([2,A1,A2],4),FP1	; F2 31 4C 96 A1 22 00
	flog2.p	([6,A2],D3,8),FP2	; F2 32 4D 16 31 26 00
	flog2.p	(0x1234,PC,D1),FP3	; F2 3B 4D 96 11 20 12
	flog2.p	([2,PC,A2],4),FP4	; F2 3B 4E 16 A1 22 FF
	flog2.p	([6,PC],D3,8),FP5	; F2 3B 4E 96 31 26 00

	fabs	FP7			; F2 00 1F 98
	fabs	FP1,FP2			; F2 00 05 18

	fabs	(A1),FP2		; F2 11 49 18
	fabs	(A2)+,FP3		; F2 1A 49 98
	fabs	-(A3),FP4		; F2 23 4A 18
	fabs	1(A4),FP5		; F2 2C 4A 98 00 01
	fabs	2(A5,D7.W),FP6		; F2 35 4B 18 70 02
	fabs	2(A5,D7.L),FP6		; F2 35 4B 18 78 02
	fabs	(0x1234).W,FP7		; F2 38 4B 98 12 34
	fabs	(0x1234).L,FP7		; F2 39 4B 98 00 00 12
	fabs	*0xFFFFFFF0,FP0		; F2 38 48 18 FF F0
	fabs	 0x00010004,FP1		; F2 39 48 98 00 01 00
	fabs	5(PC),FP3		; F2 3A 49 98 00 01
	fabs	6(PC,A7.W),FP4		; F2 3B 4A 18 F0 02
	fabs	6(PC,A7.L),FP4		; F2 3B 4A 18 F8 02
	fabs	(0x1234,A0,D1),FP0	; F2 30 48 18 11 20 12
	fabs	([2,A1,A2],4),FP1	; F2 31 48 98 A1 22 00
	fabs	([6,A2],D3,8),FP2	; F2 32 49 18 31 26 00
	fabs	(0x1234,PC,D1),FP3	; F2 3B 49 98 11 20 12
	fabs	([2,PC,A2],4),FP4	; F2 3B 4A 18 A1 22 FF
	fabs	([6,PC],D3,8),FP5	; F2 3B 4A 98 31 26 00

	fabs.b	D0,FP0			; F2 00 58 18
	fabs.b	(A1),FP2		; F2 11 59 18
	fabs.b	(A2)+,FP3		; F2 1A 59 98
	fabs.b	-(A3),FP4		; F2 23 5A 18
	fabs.b	1(A4),FP5		; F2 2C 5A 98 00 01
	fabs.b	2(A5,D7.W),FP6		; F2 35 5B 18 70 02
	fabs.b	2(A5,D7.L),FP6		; F2 35 5B 18 78 02
	fabs.b	(0x1234).W,FP7		; F2 38 5B 98 12 34
	fabs.b	(0x1234).L,FP7		; F2 39 5B 98 00 00 12
	fabs.b	*0xFFFFFFF0,FP0		; F2 38 58 18 FF F0
	fabs.b	 0x00010004,FP1		; F2 39 58 98 00 01 00
	fabs.b	#7,FP2			; F2 3C 59 18 00 07
	fabs.b	5(PC),FP3		; F2 3A 59 98 00 01
	fabs.b	6(PC,A7.W),FP4		; F2 3B 5A 18 F0 02
	fabs.b	6(PC,A7.L),FP4		; F2 3B 5A 18 F8 02
	fabs.b	(0x1234,A0,D1),FP0	; F2 30 58 18 11 20 12
	fabs.b	([2,A1,A2],4),FP1	; F2 31 58 98 A1 22 00
	fabs.b	([6,A2],D3,8),FP2	; F2 32 59 18 31 26 00
	fabs.b	(0x1234,PC,D1),FP3	; F2 3B 59 98 11 20 12
	fabs.b	([2,PC,A2],4),FP4	; F2 3B 5A 18 A1 22 FF
	fabs.b	([6,PC],D3,8),FP5	; F2 3B 5A 98 31 26 00

	fabs.w	D0,FP0			; F2 00 50 18
	fabs.w	(A1),FP2		; F2 11 51 18
	fabs.w	(A2)+,FP3		; F2 1A 51 98
	fabs.w	-(A3),FP4		; F2 23 52 18
	fabs.w	1(A4),FP5		; F2 2C 52 98 00 01
	fabs.w	2(A5,D7.W),FP6		; F2 35 53 18 70 02
	fabs.w	2(A5,D7.L),FP6		; F2 35 53 18 78 02
	fabs.w	(0x1234).W,FP7		; F2 38 53 98 12 34
	fabs.w	(0x1234).L,FP7		; F2 39 53 98 00 00 12
	fabs.w	*0xFFFFFFF0,FP0		; F2 38 50 18 FF F0
	fabs.w	 0x00010004,FP1		; F2 39 50 98 00 01 00
	fabs.w	#7,FP2			; F2 3C 51 18 00 07
	fabs.w	5(PC),FP3		; F2 3A 51 98 00 01
	fabs.w	6(PC,A7.W),FP4		; F2 3B 52 18 F0 02
	fabs.w	6(PC,A7.L),FP4		; F2 3B 52 18 F8 02
	fabs.w	(0x1234,A0,D1),FP0	; F2 30 50 18 11 20 12
	fabs.w	([2,A1,A2],4),FP1	; F2 31 50 98 A1 22 00
	fabs.w	([6,A2],D3,8),FP2	; F2 32 51 18 31 26 00
	fabs.w	(0x1234,PC,D1),FP3	; F2 3B 51 98 11 20 12
	fabs.w	([2,PC,A2],4),FP4	; F2 3B 52 18 A1 22 FF
	fabs.w	([6,PC],D3,8),FP5	; F2 3B 52 98 31 26 00

	fabs.l	D0,FP0			; F2 00 40 18
	fabs.l	(A1),FP2		; F2 11 41 18
	fabs.l	(A2)+,FP3		; F2 1A 41 98
	fabs.l	-(A3),FP4		; F2 23 42 18
	fabs.l	1(A4),FP5		; F2 2C 42 98 00 01
	fabs.l	2(A5,D7.W),FP6		; F2 35 43 18 70 02
	fabs.l	2(A5,D7.L),FP6		; F2 35 43 18 78 02
	fabs.l	(0x1234).W,FP7		; F2 38 43 98 12 34
	fabs.l	(0x1234).L,FP7		; F2 39 43 98 00 00 12
	fabs.l	*0xFFFFFFF0,FP0		; F2 38 40 18 FF F0
	fabs.l	 0x00010004,FP1		; F2 39 40 98 00 01 00
	fabs.l	#7,FP2			; F2 3C 41 18 00 00 00
	fabs.l	5(PC),FP3		; F2 3A 41 98 00 01
	fabs.l	6(PC,A7.W),FP4		; F2 3B 42 18 F0 02
	fabs.l	6(PC,A7.L),FP4		; F2 3B 42 18 F8 02
	fabs.l	(0x1234,A0,D1),FP0	; F2 30 40 18 11 20 12
	fabs.l	([2,A1,A2],4),FP1	; F2 31 40 98 A1 22 00
	fabs.l	([6,A2],D3,8),FP2	; F2 32 41 18 31 26 00
	fabs.l	(0x1234,PC,D1),FP3	; F2 3B 41 98 11 20 12
	fabs.l	([2,PC,A2],4),FP4	; F2 3B 42 18 A1 22 FF
	fabs.l	([6,PC],D3,8),FP5	; F2 3B 42 98 31 26 00

	fabs.s	D0,FP0			; F2 00 44 18
	fabs.s	(A1),FP2		; F2 11 45 18
	fabs.s	(A2)+,FP3		; F2 1A 45 98
	fabs.s	-(A3),FP4		; F2 23 46 18
	fabs.s	1(A4),FP5		; F2 2C 46 98 00 01
	fabs.s	2(A5,D7.W),FP6		; F2 35 47 18 70 02
	fabs.s	2(A5,D7.L),FP6		; F2 35 47 18 78 02
	fabs.s	(0x1234).W,FP7		; F2 38 47 98 12 34
	fabs.s	(0x1234).L,FP7		; F2 39 47 98 00 00 12
	fabs.s	*0xFFFFFFF0,FP0		; F2 38 44 18 FF F0
	fabs.s	 0x00010004,FP1		; F2 39 44 98 00 01 00
	fabs.s	#7,FP2			; F2 3C 45 18 40 E0 00
	fabs.s	5(PC),FP3		; F2 3A 45 98 00 01
	fabs.s	6(PC,A7.W),FP4		; F2 3B 46 18 F0 02
	fabs.s	6(PC,A7.L),FP4		; F2 3B 46 18 F8 02
	fabs.s	(0x1234,A0,D1),FP0	; F2 30 44 18 11 20 12
	fabs.s	([2,A1,A2],4),FP1	; F2 31 44 98 A1 22 00
	fabs.s	([6,A2],D3,8),FP2	; F2 32 45 18 31 26 00
	fabs.s	(0x1234,PC,D1),FP3	; F2 3B 45 98 11 20 12
	fabs.s	([2,PC,A2],4),FP4	; F2 3B 46 18 A1 22 FF
	fabs.s	([6,PC],D3,8),FP5	; F2 3B 46 98 31 26 00

	fabs.d	(A1),FP2		; F2 11 55 18
	fabs.d	(A2)+,FP3		; F2 1A 55 98
	fabs.d	-(A3),FP4		; F2 23 56 18
	fabs.d	1(A4),FP5		; F2 2C 56 98 00 01
	fabs.d	2(A5,D7.W),FP6		; F2 35 57 18 70 02
	fabs.d	2(A5,D7.L),FP6		; F2 35 57 18 78 02
	fabs.d	(0x1234).W,FP7		; F2 38 57 98 12 34
	fabs.d	(0x1234).L,FP7		; F2 39 57 98 00 00 12
	fabs.d	*0xFFFFFFF0,FP0		; F2 38 54 18 FF F0
	fabs.d	 0x00010004,FP1		; F2 39 54 98 00 01 00
	fabs.d	5(PC),FP3		; F2 3A 55 98 00 01
	fabs.d	6(PC,A7.W),FP4		; F2 3B 56 18 F0 02
	fabs.d	6(PC,A7.L),FP4		; F2 3B 56 18 F8 02
	fabs.d	(0x1234,A0,D1),FP0	; F2 30 54 18 11 20 12
	fabs.d	([2,A1,A2],4),FP1	; F2 31 54 98 A1 22 00
	fabs.d	([6,A2],D3,8),FP2	; F2 32 55 18 31 26 00
	fabs.d	(0x1234,PC,D1),FP3	; F2 3B 55 98 11 20 12
	fabs.d	([2,PC,A2],4),FP4	; F2 3B 56 18 A1 22 FF
	fabs.d	([6,PC],D3,8),FP5	; F2 3B 56 98 31 26 00

	fabs.x	FP7			; F2 00 1F 98
	fabs.x	FP1,FP2			; F2 00 05 18

	fabs.x	(A1),FP2		; F2 11 49 18
	fabs.x	(A2)+,FP3		; F2 1A 49 98
	fabs.x	-(A3),FP4		; F2 23 4A 18
	fabs.x	1(A4),FP5		; F2 2C 4A 98 00 01
	fabs.x	2(A5,D7.W),FP6		; F2 35 4B 18 70 02
	fabs.x	2(A5,D7.L),FP6		; F2 35 4B 18 78 02
	fabs.x	(0x1234).W,FP7		; F2 38 4B 98 12 34
	fabs.x	(0x1234).L,FP7		; F2 39 4B 98 00 00 12
	fabs.x	*0xFFFFFFF0,FP0		; F2 38 48 18 FF F0
	fabs.x	 0x00010004,FP1		; F2 39 48 98 00 01 00
	fabs.x	5(PC),FP3		; F2 3A 49 98 00 01
	fabs.x	6(PC,A7.W),FP4		; F2 3B 4A 18 F0 02
	fabs.x	6(PC,A7.L),FP4		; F2 3B 4A 18 F8 02
	fabs.x	(0x1234,A0,D1),FP0	; F2 30 48 18 11 20 12
	fabs.x	([2,A1,A2],4),FP1	; F2 31 48 98 A1 22 00
	fabs.x	([6,A2],D3,8),FP2	; F2 32 49 18 31 26 00
	fabs.x	(0x1234,PC,D1),FP3	; F2 3B 49 98 11 20 12
	fabs.x	([2,PC,A2],4),FP4	; F2 3B 4A 18 A1 22 FF
	fabs.x	([6,PC],D3,8),FP5	; F2 3B 4A 98 31 26 00

	fabs.p	(A1),FP2		; F2 11 4D 18
	fabs.p	(A2)+,FP3		; F2 1A 4D 98
	fabs.p	-(A3),FP4		; F2 23 4E 18
	fabs.p	1(A4),FP5		; F2 2C 4E 98 00 01
	fabs.p	2(A5,D7.W),FP6		; F2 35 4F 18 70 02
	fabs.p	2(A5,D7.L),FP6		; F2 35 4F 18 78 02
	fabs.p	(0x1234).W,FP7		; F2 38 4F 98 12 34
	fabs.p	(0x1234).L,FP7		; F2 39 4F 98 00 00 12
	fabs.p	*0xFFFFFFF0,FP0		; F2 38 4C 18 FF F0
	fabs.p	 0x00010004,FP1		; F2 39 4C 98 00 01 00
	fabs.p	5(PC),FP3		; F2 3A 4D 98 00 01
	fabs.p	6(PC,A7.W),FP4		; F2 3B 4E 18 F0 02
	fabs.p	6(PC,A7.L),FP4		; F2 3B 4E 18 F8 02
	fabs.p	(0x1234,A0,D1),FP0	; F2 30 4C 18 11 20 12
	fabs.p	([2,A1,A2],4),FP1	; F2 31 4C 98 A1 22 00
	fabs.p	([6,A2],D3,8),FP2	; F2 32 4D 18 31 26 00
	fabs.p	(0x1234,PC,D1),FP3	; F2 3B 4D 98 11 20 12
	fabs.p	([2,PC,A2],4),FP4	; F2 3B 4E 18 A1 22 FF
	fabs.p	([6,PC],D3,8),FP5	; F2 3B 4E 98 31 26 00

	fcosh	FP7			; F2 00 1F 99
	fcosh	FP1,FP2			; F2 00 05 19

	fcosh	(A1),FP2		; F2 11 49 19
	fcosh	(A2)+,FP3		; F2 1A 49 99
	fcosh	-(A3),FP4		; F2 23 4A 19
	fcosh	1(A4),FP5		; F2 2C 4A 99 00 01
	fcosh	2(A5,D7.W),FP6		; F2 35 4B 19 70 02
	fcosh	2(A5,D7.L),FP6		; F2 35 4B 19 78 02
	fcosh	(0x1234).W,FP7		; F2 38 4B 99 12 34
	fcosh	(0x1234).L,FP7		; F2 39 4B 99 00 00 12
	fcosh	*0xFFFFFFF0,FP0		; F2 38 48 19 FF F0
	fcosh	 0x00010004,FP1		; F2 39 48 99 00 01 00
	fcosh	5(PC),FP3		; F2 3A 49 99 00 01
	fcosh	6(PC,A7.W),FP4		; F2 3B 4A 19 F0 02
	fcosh	6(PC,A7.L),FP4		; F2 3B 4A 19 F8 02
	fcosh	(0x1234,A0,D1),FP0	; F2 30 48 19 11 20 12
	fcosh	([2,A1,A2],4),FP1	; F2 31 48 99 A1 22 00
	fcosh	([6,A2],D3,8),FP2	; F2 32 49 19 31 26 00
	fcosh	(0x1234,PC,D1),FP3	; F2 3B 49 99 11 20 12
	fcosh	([2,PC,A2],4),FP4	; F2 3B 4A 19 A1 22 FF
	fcosh	([6,PC],D3,8),FP5	; F2 3B 4A 99 31 26 00

	fcosh.b	D0,FP0			; F2 00 58 19
	fcosh.b	(A1),FP2		; F2 11 59 19
	fcosh.b	(A2)+,FP3		; F2 1A 59 99
	fcosh.b	-(A3),FP4		; F2 23 5A 19
	fcosh.b	1(A4),FP5		; F2 2C 5A 99 00 01
	fcosh.b	2(A5,D7.W),FP6		; F2 35 5B 19 70 02
	fcosh.b	2(A5,D7.L),FP6		; F2 35 5B 19 78 02
	fcosh.b	(0x1234).W,FP7		; F2 38 5B 99 12 34
	fcosh.b	(0x1234).L,FP7		; F2 39 5B 99 00 00 12
	fcosh.b	*0xFFFFFFF0,FP0		; F2 38 58 19 FF F0
	fcosh.b	 0x00010004,FP1		; F2 39 58 99 00 01 00
	fcosh.b	#7,FP2			; F2 3C 59 19 00 07
	fcosh.b	5(PC),FP3		; F2 3A 59 99 00 01
	fcosh.b	6(PC,A7.W),FP4		; F2 3B 5A 19 F0 02
	fcosh.b	6(PC,A7.L),FP4		; F2 3B 5A 19 F8 02
	fcosh.b	(0x1234,A0,D1),FP0	; F2 30 58 19 11 20 12
	fcosh.b	([2,A1,A2],4),FP1	; F2 31 58 99 A1 22 00
	fcosh.b	([6,A2],D3,8),FP2	; F2 32 59 19 31 26 00
	fcosh.b	(0x1234,PC,D1),FP3	; F2 3B 59 99 11 20 12
	fcosh.b	([2,PC,A2],4),FP4	; F2 3B 5A 19 A1 22 FF
	fcosh.b	([6,PC],D3,8),FP5	; F2 3B 5A 99 31 26 00

	fcosh.w	D0,FP0			; F2 00 50 19
	fcosh.w	(A1),FP2		; F2 11 51 19
	fcosh.w	(A2)+,FP3		; F2 1A 51 99
	fcosh.w	-(A3),FP4		; F2 23 52 19
	fcosh.w	1(A4),FP5		; F2 2C 52 99 00 01
	fcosh.w	2(A5,D7.W),FP6		; F2 35 53 19 70 02
	fcosh.w	2(A5,D7.L),FP6		; F2 35 53 19 78 02
	fcosh.w	(0x1234).W,FP7		; F2 38 53 99 12 34
	fcosh.w	(0x1234).L,FP7		; F2 39 53 99 00 00 12
	fcosh.w	*0xFFFFFFF0,FP0		; F2 38 50 19 FF F0
	fcosh.w	 0x00010004,FP1		; F2 39 50 99 00 01 00
	fcosh.w	#7,FP2			; F2 3C 51 19 00 07
	fcosh.w	5(PC),FP3		; F2 3A 51 99 00 01
	fcosh.w	6(PC,A7.W),FP4		; F2 3B 52 19 F0 02
	fcosh.w	6(PC,A7.L),FP4		; F2 3B 52 19 F8 02
	fcosh.w	(0x1234,A0,D1),FP0	; F2 30 50 19 11 20 12
	fcosh.w	([2,A1,A2],4),FP1	; F2 31 50 99 A1 22 00
	fcosh.w	([6,A2],D3,8),FP2	; F2 32 51 19 31 26 00
	fcosh.w	(0x1234,PC,D1),FP3	; F2 3B 51 99 11 20 12
	fcosh.w	([2,PC,A2],4),FP4	; F2 3B 52 19 A1 22 FF
	fcosh.w	([6,PC],D3,8),FP5	; F2 3B 52 99 31 26 00

	fcosh.l	D0,FP0			; F2 00 40 19
	fcosh.l	(A1),FP2		; F2 11 41 19
	fcosh.l	(A2)+,FP3		; F2 1A 41 99
	fcosh.l	-(A3),FP4		; F2 23 42 19
	fcosh.l	1(A4),FP5		; F2 2C 42 99 00 01
	fcosh.l	2(A5,D7.W),FP6		; F2 35 43 19 70 02
	fcosh.l	2(A5,D7.L),FP6		; F2 35 43 19 78 02
	fcosh.l	(0x1234).W,FP7		; F2 38 43 99 12 34
	fcosh.l	(0x1234).L,FP7		; F2 39 43 99 00 00 12
	fcosh.l	*0xFFFFFFF0,FP0		; F2 38 40 19 FF F0
	fcosh.l	 0x00010004,FP1		; F2 39 40 99 00 01 00
	fcosh.l	#7,FP2			; F2 3C 41 19 00 00 00
	fcosh.l	5(PC),FP3		; F2 3A 41 99 00 01
	fcosh.l	6(PC,A7.W),FP4		; F2 3B 42 19 F0 02
	fcosh.l	6(PC,A7.L),FP4		; F2 3B 42 19 F8 02
	fcosh.l	(0x1234,A0,D1),FP0	; F2 30 40 19 11 20 12
	fcosh.l	([2,A1,A2],4),FP1	; F2 31 40 99 A1 22 00
	fcosh.l	([6,A2],D3,8),FP2	; F2 32 41 19 31 26 00
	fcosh.l	(0x1234,PC,D1),FP3	; F2 3B 41 99 11 20 12
	fcosh.l	([2,PC,A2],4),FP4	; F2 3B 42 19 A1 22 FF
	fcosh.l	([6,PC],D3,8),FP5	; F2 3B 42 99 31 26 00

	fcosh.s	D0,FP0			; F2 00 44 19
	fcosh.s	(A1),FP2		; F2 11 45 19
	fcosh.s	(A2)+,FP3		; F2 1A 45 99
	fcosh.s	-(A3),FP4		; F2 23 46 19
	fcosh.s	1(A4),FP5		; F2 2C 46 99 00 01
	fcosh.s	2(A5,D7.W),FP6		; F2 35 47 19 70 02
	fcosh.s	2(A5,D7.L),FP6		; F2 35 47 19 78 02
	fcosh.s	(0x1234).W,FP7		; F2 38 47 99 12 34
	fcosh.s	(0x1234).L,FP7		; F2 39 47 99 00 00 12
	fcosh.s	*0xFFFFFFF0,FP0		; F2 38 44 19 FF F0
	fcosh.s	 0x00010004,FP1		; F2 39 44 99 00 01 00
	fcosh.s	#7,FP2			; F2 3C 45 19 40 E0 00
	fcosh.s	5(PC),FP3		; F2 3A 45 99 00 01
	fcosh.s	6(PC,A7.W),FP4		; F2 3B 46 19 F0 02
	fcosh.s	6(PC,A7.L),FP4		; F2 3B 46 19 F8 02
	fcosh.s	(0x1234,A0,D1),FP0	; F2 30 44 19 11 20 12
	fcosh.s	([2,A1,A2],4),FP1	; F2 31 44 99 A1 22 00
	fcosh.s	([6,A2],D3,8),FP2	; F2 32 45 19 31 26 00
	fcosh.s	(0x1234,PC,D1),FP3	; F2 3B 45 99 11 20 12
	fcosh.s	([2,PC,A2],4),FP4	; F2 3B 46 19 A1 22 FF
	fcosh.s	([6,PC],D3,8),FP5	; F2 3B 46 99 31 26 00

	fcosh.d	(A1),FP2		; F2 11 55 19
	fcosh.d	(A2)+,FP3		; F2 1A 55 99
	fcosh.d	-(A3),FP4		; F2 23 56 19
	fcosh.d	1(A4),FP5		; F2 2C 56 99 00 01
	fcosh.d	2(A5,D7.W),FP6		; F2 35 57 19 70 02
	fcosh.d	2(A5,D7.L),FP6		; F2 35 57 19 78 02
	fcosh.d	(0x1234).W,FP7		; F2 38 57 99 12 34
	fcosh.d	(0x1234).L,FP7		; F2 39 57 99 00 00 12
	fcosh.d	*0xFFFFFFF0,FP0		; F2 38 54 19 FF F0
	fcosh.d	 0x00010004,FP1		; F2 39 54 99 00 01 00
	fcosh.d	5(PC),FP3		; F2 3A 55 99 00 01
	fcosh.d	6(PC,A7.W),FP4		; F2 3B 56 19 F0 02
	fcosh.d	6(PC,A7.L),FP4		; F2 3B 56 19 F8 02
	fcosh.d	(0x1234,A0,D1),FP0	; F2 30 54 19 11 20 12
	fcosh.d	([2,A1,A2],4),FP1	; F2 31 54 99 A1 22 00
	fcosh.d	([6,A2],D3,8),FP2	; F2 32 55 19 31 26 00
	fcosh.d	(0x1234,PC,D1),FP3	; F2 3B 55 99 11 20 12
	fcosh.d	([2,PC,A2],4),FP4	; F2 3B 56 19 A1 22 FF
	fcosh.d	([6,PC],D3,8),FP5	; F2 3B 56 99 31 26 00

	fcosh.x	FP7			; F2 00 1F 99
	fcosh.x	FP1,FP2			; F2 00 05 19

	fcosh.x	(A1),FP2		; F2 11 49 19
	fcosh.x	(A2)+,FP3		; F2 1A 49 99
	fcosh.x	-(A3),FP4		; F2 23 4A 19
	fcosh.x	1(A4),FP5		; F2 2C 4A 99 00 01
	fcosh.x	2(A5,D7.W),FP6		; F2 35 4B 19 70 02
	fcosh.x	2(A5,D7.L),FP6		; F2 35 4B 19 78 02
	fcosh.x	(0x1234).W,FP7		; F2 38 4B 99 12 34
	fcosh.x	(0x1234).L,FP7		; F2 39 4B 99 00 00 12
	fcosh.x	*0xFFFFFFF0,FP0		; F2 38 48 19 FF F0
	fcosh.x	 0x00010004,FP1		; F2 39 48 99 00 01 00
	fcosh.x	5(PC),FP3		; F2 3A 49 99 00 01
	fcosh.x	6(PC,A7.W),FP4		; F2 3B 4A 19 F0 02
	fcosh.x	6(PC,A7.L),FP4		; F2 3B 4A 19 F8 02
	fcosh.x	(0x1234,A0,D1),FP0	; F2 30 48 19 11 20 12
	fcosh.x	([2,A1,A2],4),FP1	; F2 31 48 99 A1 22 00
	fcosh.x	([6,A2],D3,8),FP2	; F2 32 49 19 31 26 00
	fcosh.x	(0x1234,PC,D1),FP3	; F2 3B 49 99 11 20 12
	fcosh.x	([2,PC,A2],4),FP4	; F2 3B 4A 19 A1 22 FF
	fcosh.x	([6,PC],D3,8),FP5	; F2 3B 4A 99 31 26 00

	fcosh.p	(A1),FP2		; F2 11 4D 19
	fcosh.p	(A2)+,FP3		; F2 1A 4D 99
	fcosh.p	-(A3),FP4		; F2 23 4E 19
	fcosh.p	1(A4),FP5		; F2 2C 4E 99 00 01
	fcosh.p	2(A5,D7.W),FP6		; F2 35 4F 19 70 02
	fcosh.p	2(A5,D7.L),FP6		; F2 35 4F 19 78 02
	fcosh.p	(0x1234).W,FP7		; F2 38 4F 99 12 34
	fcosh.p	(0x1234).L,FP7		; F2 39 4F 99 00 00 12
	fcosh.p	*0xFFFFFFF0,FP0		; F2 38 4C 19 FF F0
	fcosh.p	 0x00010004,FP1		; F2 39 4C 99 00 01 00
	fcosh.p	5(PC),FP3		; F2 3A 4D 99 00 01
	fcosh.p	6(PC,A7.W),FP4		; F2 3B 4E 19 F0 02
	fcosh.p	6(PC,A7.L),FP4		; F2 3B 4E 19 F8 02
	fcosh.p	(0x1234,A0,D1),FP0	; F2 30 4C 19 11 20 12
	fcosh.p	([2,A1,A2],4),FP1	; F2 31 4C 99 A1 22 00
	fcosh.p	([6,A2],D3,8),FP2	; F2 32 4D 19 31 26 00
	fcosh.p	(0x1234,PC,D1),FP3	; F2 3B 4D 99 11 20 12
	fcosh.p	([2,PC,A2],4),FP4	; F2 3B 4E 19 A1 22 FF
	fcosh.p	([6,PC],D3,8),FP5	; F2 3B 4E 99 31 26 00

	fneg	FP7			; F2 00 1F 9A
	fneg	FP1,FP2			; F2 00 05 1A

	fneg	(A1),FP2		; F2 11 49 1A
	fneg	(A2)+,FP3		; F2 1A 49 9A
	fneg	-(A3),FP4		; F2 23 4A 1A
	fneg	1(A4),FP5		; F2 2C 4A 9A 00 01
	fneg	2(A5,D7.W),FP6		; F2 35 4B 1A 70 02
	fneg	2(A5,D7.L),FP6		; F2 35 4B 1A 78 02
	fneg	(0x1234).W,FP7		; F2 38 4B 9A 12 34
	fneg	(0x1234).L,FP7		; F2 39 4B 9A 00 00 12
	fneg	*0xFFFFFFF0,FP0		; F2 38 48 1A FF F0
	fneg	 0x00010004,FP1		; F2 39 48 9A 00 01 00
	fneg	5(PC),FP3		; F2 3A 49 9A 00 01
	fneg	6(PC,A7.W),FP4		; F2 3B 4A 1A F0 02
	fneg	6(PC,A7.L),FP4		; F2 3B 4A 1A F8 02
	fneg	(0x1234,A0,D1),FP0	; F2 30 48 1A 11 20 12
	fneg	([2,A1,A2],4),FP1	; F2 31 48 9A A1 22 00
	fneg	([6,A2],D3,8),FP2	; F2 32 49 1A 31 26 00
	fneg	(0x1234,PC,D1),FP3	; F2 3B 49 9A 11 20 12
	fneg	([2,PC,A2],4),FP4	; F2 3B 4A 1A A1 22 FF
	fneg	([6,PC],D3,8),FP5	; F2 3B 4A 9A 31 26 00

	fneg.b	D0,FP0			; F2 00 58 1A
	fneg.b	(A1),FP2		; F2 11 59 1A
	fneg.b	(A2)+,FP3		; F2 1A 59 9A
	fneg.b	-(A3),FP4		; F2 23 5A 1A
	fneg.b	1(A4),FP5		; F2 2C 5A 9A 00 01
	fneg.b	2(A5,D7.W),FP6		; F2 35 5B 1A 70 02
	fneg.b	2(A5,D7.L),FP6		; F2 35 5B 1A 78 02
	fneg.b	(0x1234).W,FP7		; F2 38 5B 9A 12 34
	fneg.b	(0x1234).L,FP7		; F2 39 5B 9A 00 00 12
	fneg.b	*0xFFFFFFF0,FP0		; F2 38 58 1A FF F0
	fneg.b	 0x00010004,FP1		; F2 39 58 9A 00 01 00
	fneg.b	#7,FP2			; F2 3C 59 1A 00 07
	fneg.b	5(PC),FP3		; F2 3A 59 9A 00 01
	fneg.b	6(PC,A7.W),FP4		; F2 3B 5A 1A F0 02
	fneg.b	6(PC,A7.L),FP4		; F2 3B 5A 1A F8 02
	fneg.b	(0x1234,A0,D1),FP0	; F2 30 58 1A 11 20 12
	fneg.b	([2,A1,A2],4),FP1	; F2 31 58 9A A1 22 00
	fneg.b	([6,A2],D3,8),FP2	; F2 32 59 1A 31 26 00
	fneg.b	(0x1234,PC,D1),FP3	; F2 3B 59 9A 11 20 12
	fneg.b	([2,PC,A2],4),FP4	; F2 3B 5A 1A A1 22 FF
	fneg.b	([6,PC],D3,8),FP5	; F2 3B 5A 9A 31 26 00

	fneg.w	D0,FP0			; F2 00 50 1A
	fneg.w	(A1),FP2		; F2 11 51 1A
	fneg.w	(A2)+,FP3		; F2 1A 51 9A
	fneg.w	-(A3),FP4		; F2 23 52 1A
	fneg.w	1(A4),FP5		; F2 2C 52 9A 00 01
	fneg.w	2(A5,D7.W),FP6		; F2 35 53 1A 70 02
	fneg.w	2(A5,D7.L),FP6		; F2 35 53 1A 78 02
	fneg.w	(0x1234).W,FP7		; F2 38 53 9A 12 34
	fneg.w	(0x1234).L,FP7		; F2 39 53 9A 00 00 12
	fneg.w	*0xFFFFFFF0,FP0		; F2 38 50 1A FF F0
	fneg.w	 0x00010004,FP1		; F2 39 50 9A 00 01 00
	fneg.w	#7,FP2			; F2 3C 51 1A 00 07
	fneg.w	5(PC),FP3		; F2 3A 51 9A 00 01
	fneg.w	6(PC,A7.W),FP4		; F2 3B 52 1A F0 02
	fneg.w	6(PC,A7.L),FP4		; F2 3B 52 1A F8 02
	fneg.w	(0x1234,A0,D1),FP0	; F2 30 50 1A 11 20 12
	fneg.w	([2,A1,A2],4),FP1	; F2 31 50 9A A1 22 00
	fneg.w	([6,A2],D3,8),FP2	; F2 32 51 1A 31 26 00
	fneg.w	(0x1234,PC,D1),FP3	; F2 3B 51 9A 11 20 12
	fneg.w	([2,PC,A2],4),FP4	; F2 3B 52 1A A1 22 FF
	fneg.w	([6,PC],D3,8),FP5	; F2 3B 52 9A 31 26 00

	fneg.l	D0,FP0			; F2 00 40 1A
	fneg.l	(A1),FP2		; F2 11 41 1A
	fneg.l	(A2)+,FP3		; F2 1A 41 9A
	fneg.l	-(A3),FP4		; F2 23 42 1A
	fneg.l	1(A4),FP5		; F2 2C 42 9A 00 01
	fneg.l	2(A5,D7.W),FP6		; F2 35 43 1A 70 02
	fneg.l	2(A5,D7.L),FP6		; F2 35 43 1A 78 02
	fneg.l	(0x1234).W,FP7		; F2 38 43 9A 12 34
	fneg.l	(0x1234).L,FP7		; F2 39 43 9A 00 00 12
	fneg.l	*0xFFFFFFF0,FP0		; F2 38 40 1A FF F0
	fneg.l	 0x00010004,FP1		; F2 39 40 9A 00 01 00
	fneg.l	#7,FP2			; F2 3C 41 1A 00 00 00
	fneg.l	5(PC),FP3		; F2 3A 41 9A 00 01
	fneg.l	6(PC,A7.W),FP4		; F2 3B 42 1A F0 02
	fneg.l	6(PC,A7.L),FP4		; F2 3B 42 1A F8 02
	fneg.l	(0x1234,A0,D1),FP0	; F2 30 40 1A 11 20 12
	fneg.l	([2,A1,A2],4),FP1	; F2 31 40 9A A1 22 00
	fneg.l	([6,A2],D3,8),FP2	; F2 32 41 1A 31 26 00
	fneg.l	(0x1234,PC,D1),FP3	; F2 3B 41 9A 11 20 12
	fneg.l	([2,PC,A2],4),FP4	; F2 3B 42 1A A1 22 FF
	fneg.l	([6,PC],D3,8),FP5	; F2 3B 42 9A 31 26 00

	fneg.s	D0,FP0			; F2 00 44 1A
	fneg.s	(A1),FP2		; F2 11 45 1A
	fneg.s	(A2)+,FP3		; F2 1A 45 9A
	fneg.s	-(A3),FP4		; F2 23 46 1A
	fneg.s	1(A4),FP5		; F2 2C 46 9A 00 01
	fneg.s	2(A5,D7.W),FP6		; F2 35 47 1A 70 02
	fneg.s	2(A5,D7.L),FP6		; F2 35 47 1A 78 02
	fneg.s	(0x1234).W,FP7		; F2 38 47 9A 12 34
	fneg.s	(0x1234).L,FP7		; F2 39 47 9A 00 00 12
	fneg.s	*0xFFFFFFF0,FP0		; F2 38 44 1A FF F0
	fneg.s	 0x00010004,FP1		; F2 39 44 9A 00 01 00
	fneg.s	#7,FP2			; F2 3C 45 1A 40 E0 00
	fneg.s	5(PC),FP3		; F2 3A 45 9A 00 01
	fneg.s	6(PC,A7.W),FP4		; F2 3B 46 1A F0 02
	fneg.s	6(PC,A7.L),FP4		; F2 3B 46 1A F8 02
	fneg.s	(0x1234,A0,D1),FP0	; F2 30 44 1A 11 20 12
	fneg.s	([2,A1,A2],4),FP1	; F2 31 44 9A A1 22 00
	fneg.s	([6,A2],D3,8),FP2	; F2 32 45 1A 31 26 00
	fneg.s	(0x1234,PC,D1),FP3	; F2 3B 45 9A 11 20 12
	fneg.s	([2,PC,A2],4),FP4	; F2 3B 46 1A A1 22 FF
	fneg.s	([6,PC],D3,8),FP5	; F2 3B 46 9A 31 26 00

	fneg.d	(A1),FP2		; F2 11 55 1A
	fneg.d	(A2)+,FP3		; F2 1A 55 9A
	fneg.d	-(A3),FP4		; F2 23 56 1A
	fneg.d	1(A4),FP5		; F2 2C 56 9A 00 01
	fneg.d	2(A5,D7.W),FP6		; F2 35 57 1A 70 02
	fneg.d	2(A5,D7.L),FP6		; F2 35 57 1A 78 02
	fneg.d	(0x1234).W,FP7		; F2 38 57 9A 12 34
	fneg.d	(0x1234).L,FP7		; F2 39 57 9A 00 00 12
	fneg.d	*0xFFFFFFF0,FP0		; F2 38 54 1A FF F0
	fneg.d	 0x00010004,FP1		; F2 39 54 9A 00 01 00
	fneg.d	5(PC),FP3		; F2 3A 55 9A 00 01
	fneg.d	6(PC,A7.W),FP4		; F2 3B 56 1A F0 02
	fneg.d	6(PC,A7.L),FP4		; F2 3B 56 1A F8 02
	fneg.d	(0x1234,A0,D1),FP0	; F2 30 54 1A 11 20 12
	fneg.d	([2,A1,A2],4),FP1	; F2 31 54 9A A1 22 00
	fneg.d	([6,A2],D3,8),FP2	; F2 32 55 1A 31 26 00
	fneg.d	(0x1234,PC,D1),FP3	; F2 3B 55 9A 11 20 12
	fneg.d	([2,PC,A2],4),FP4	; F2 3B 56 1A A1 22 FF
	fneg.d	([6,PC],D3,8),FP5	; F2 3B 56 9A 31 26 00

	fneg.x	FP7			; F2 00 1F 9A
	fneg.x	FP1,FP2			; F2 00 05 1A

	fneg.x	(A1),FP2		; F2 11 49 1A
	fneg.x	(A2)+,FP3		; F2 1A 49 9A
	fneg.x	-(A3),FP4		; F2 23 4A 1A
	fneg.x	1(A4),FP5		; F2 2C 4A 9A 00 01
	fneg.x	2(A5,D7.W),FP6		; F2 35 4B 1A 70 02
	fneg.x	2(A5,D7.L),FP6		; F2 35 4B 1A 78 02
	fneg.x	(0x1234).W,FP7		; F2 38 4B 9A 12 34
	fneg.x	(0x1234).L,FP7		; F2 39 4B 9A 00 00 12
	fneg.x	*0xFFFFFFF0,FP0		; F2 38 48 1A FF F0
	fneg.x	 0x00010004,FP1		; F2 39 48 9A 00 01 00
	fneg.x	5(PC),FP3		; F2 3A 49 9A 00 01
	fneg.x	6(PC,A7.W),FP4		; F2 3B 4A 1A F0 02
	fneg.x	6(PC,A7.L),FP4		; F2 3B 4A 1A F8 02
	fneg.x	(0x1234,A0,D1),FP0	; F2 30 48 1A 11 20 12
	fneg.x	([2,A1,A2],4),FP1	; F2 31 48 9A A1 22 00
	fneg.x	([6,A2],D3,8),FP2	; F2 32 49 1A 31 26 00
	fneg.x	(0x1234,PC,D1),FP3	; F2 3B 49 9A 11 20 12
	fneg.x	([2,PC,A2],4),FP4	; F2 3B 4A 1A A1 22 FF
	fneg.x	([6,PC],D3,8),FP5	; F2 3B 4A 9A 31 26 00

	fneg.p	(A1),FP2		; F2 11 4D 1A
	fneg.p	(A2)+,FP3		; F2 1A 4D 9A
	fneg.p	-(A3),FP4		; F2 23 4E 1A
	fneg.p	1(A4),FP5		; F2 2C 4E 9A 00 01
	fneg.p	2(A5,D7.W),FP6		; F2 35 4F 1A 70 02
	fneg.p	2(A5,D7.L),FP6		; F2 35 4F 1A 78 02
	fneg.p	(0x1234).W,FP7		; F2 38 4F 9A 12 34
	fneg.p	(0x1234).L,FP7		; F2 39 4F 9A 00 00 12
	fneg.p	*0xFFFFFFF0,FP0		; F2 38 4C 1A FF F0
	fneg.p	 0x00010004,FP1		; F2 39 4C 9A 00 01 00
	fneg.p	5(PC),FP3		; F2 3A 4D 9A 00 01
	fneg.p	6(PC,A7.W),FP4		; F2 3B 4E 1A F0 02
	fneg.p	6(PC,A7.L),FP4		; F2 3B 4E 1A F8 02
	fneg.p	(0x1234,A0,D1),FP0	; F2 30 4C 1A 11 20 12
	fneg.p	([2,A1,A2],4),FP1	; F2 31 4C 9A A1 22 00
	fneg.p	([6,A2],D3,8),FP2	; F2 32 4D 1A 31 26 00
	fneg.p	(0x1234,PC,D1),FP3	; F2 3B 4D 9A 11 20 12
	fneg.p	([2,PC,A2],4),FP4	; F2 3B 4E 1A A1 22 FF
	fneg.p	([6,PC],D3,8),FP5	; F2 3B 4E 9A 31 26 00

	fcos	FP7			; F2 00 1F 9D
	fcos	FP1,FP2			; F2 00 05 1D

	fcos	(A1),FP2		; F2 11 49 1D
	fcos	(A2)+,FP3		; F2 1A 49 9D
	fcos	-(A3),FP4		; F2 23 4A 1D
	fcos	1(A4),FP5		; F2 2C 4A 9D 00 01
	fcos	2(A5,D7.W),FP6		; F2 35 4B 1D 70 02
	fcos	2(A5,D7.L),FP6		; F2 35 4B 1D 78 02
	fcos	(0x1234).W,FP7		; F2 38 4B 9D 12 34
	fcos	(0x1234).L,FP7		; F2 39 4B 9D 00 00 12
	fcos	*0xFFFFFFF0,FP0		; F2 38 48 1D FF F0
	fcos	 0x00010004,FP1		; F2 39 48 9D 00 01 00
	fcos	5(PC),FP3		; F2 3A 49 9D 00 01
	fcos	6(PC,A7.W),FP4		; F2 3B 4A 1D F0 02
	fcos	6(PC,A7.L),FP4		; F2 3B 4A 1D F8 02
	fcos	(0x1234,A0,D1),FP0	; F2 30 48 1D 11 20 12
	fcos	([2,A1,A2],4),FP1	; F2 31 48 9D A1 22 00
	fcos	([6,A2],D3,8),FP2	; F2 32 49 1D 31 26 00
	fcos	(0x1234,PC,D1),FP3	; F2 3B 49 9D 11 20 12
	fcos	([2,PC,A2],4),FP4	; F2 3B 4A 1D A1 22 FF
	fcos	([6,PC],D3,8),FP5	; F2 3B 4A 9D 31 26 00

	fcos.b	D0,FP0			; F2 00 58 1D
	fcos.b	(A1),FP2		; F2 11 59 1D
	fcos.b	(A2)+,FP3		; F2 1A 59 9D
	fcos.b	-(A3),FP4		; F2 23 5A 1D
	fcos.b	1(A4),FP5		; F2 2C 5A 9D 00 01
	fcos.b	2(A5,D7.W),FP6		; F2 35 5B 1D 70 02
	fcos.b	2(A5,D7.L),FP6		; F2 35 5B 1D 78 02
	fcos.b	(0x1234).W,FP7		; F2 38 5B 9D 12 34
	fcos.b	(0x1234).L,FP7		; F2 39 5B 9D 00 00 12
	fcos.b	*0xFFFFFFF0,FP0		; F2 38 58 1D FF F0
	fcos.b	 0x00010004,FP1		; F2 39 58 9D 00 01 00
	fcos.b	#7,FP2			; F2 3C 59 1D 00 07
	fcos.b	5(PC),FP3		; F2 3A 59 9D 00 01
	fcos.b	6(PC,A7.W),FP4		; F2 3B 5A 1D F0 02
	fcos.b	6(PC,A7.L),FP4		; F2 3B 5A 1D F8 02
	fcos.b	(0x1234,A0,D1),FP0	; F2 30 58 1D 11 20 12
	fcos.b	([2,A1,A2],4),FP1	; F2 31 58 9D A1 22 00
	fcos.b	([6,A2],D3,8),FP2	; F2 32 59 1D 31 26 00
	fcos.b	(0x1234,PC,D1),FP3	; F2 3B 59 9D 11 20 12
	fcos.b	([2,PC,A2],4),FP4	; F2 3B 5A 1D A1 22 FF
	fcos.b	([6,PC],D3,8),FP5	; F2 3B 5A 9D 31 26 00

	fcos.w	D0,FP0			; F2 00 50 1D
	fcos.w	(A1),FP2		; F2 11 51 1D
	fcos.w	(A2)+,FP3		; F2 1A 51 9D
	fcos.w	-(A3),FP4		; F2 23 52 1D
	fcos.w	1(A4),FP5		; F2 2C 52 9D 00 01
	fcos.w	2(A5,D7.W),FP6		; F2 35 53 1D 70 02
	fcos.w	2(A5,D7.L),FP6		; F2 35 53 1D 78 02
	fcos.w	(0x1234).W,FP7		; F2 38 53 9D 12 34
	fcos.w	(0x1234).L,FP7		; F2 39 53 9D 00 00 12
	fcos.w	*0xFFFFFFF0,FP0		; F2 38 50 1D FF F0
	fcos.w	 0x00010004,FP1		; F2 39 50 9D 00 01 00
	fcos.w	#7,FP2			; F2 3C 51 1D 00 07
	fcos.w	5(PC),FP3		; F2 3A 51 9D 00 01
	fcos.w	6(PC,A7.W),FP4		; F2 3B 52 1D F0 02
	fcos.w	6(PC,A7.L),FP4		; F2 3B 52 1D F8 02
	fcos.w	(0x1234,A0,D1),FP0	; F2 30 50 1D 11 20 12
	fcos.w	([2,A1,A2],4),FP1	; F2 31 50 9D A1 22 00
	fcos.w	([6,A2],D3,8),FP2	; F2 32 51 1D 31 26 00
	fcos.w	(0x1234,PC,D1),FP3	; F2 3B 51 9D 11 20 12
	fcos.w	([2,PC,A2],4),FP4	; F2 3B 52 1D A1 22 FF
	fcos.w	([6,PC],D3,8),FP5	; F2 3B 52 9D 31 26 00

	fcos.l	D0,FP0			; F2 00 40 1D
	fcos.l	(A1),FP2		; F2 11 41 1D
	fcos.l	(A2)+,FP3		; F2 1A 41 9D
	fcos.l	-(A3),FP4		; F2 23 42 1D
	fcos.l	1(A4),FP5		; F2 2C 42 9D 00 01
	fcos.l	2(A5,D7.W),FP6		; F2 35 43 1D 70 02
	fcos.l	2(A5,D7.L),FP6		; F2 35 43 1D 78 02
	fcos.l	(0x1234).W,FP7		; F2 38 43 9D 12 34
	fcos.l	(0x1234).L,FP7		; F2 39 43 9D 00 00 12
	fcos.l	*0xFFFFFFF0,FP0		; F2 38 40 1D FF F0
	fcos.l	 0x00010004,FP1		; F2 39 40 9D 00 01 00
	fcos.l	#7,FP2			; F2 3C 41 1D 00 00 00
	fcos.l	5(PC),FP3		; F2 3A 41 9D 00 01
	fcos.l	6(PC,A7.W),FP4		; F2 3B 42 1D F0 02
	fcos.l	6(PC,A7.L),FP4		; F2 3B 42 1D F8 02
	fcos.l	(0x1234,A0,D1),FP0	; F2 30 40 1D 11 20 12
	fcos.l	([2,A1,A2],4),FP1	; F2 31 40 9D A1 22 00
	fcos.l	([6,A2],D3,8),FP2	; F2 32 41 1D 31 26 00
	fcos.l	(0x1234,PC,D1),FP3	; F2 3B 41 9D 11 20 12
	fcos.l	([2,PC,A2],4),FP4	; F2 3B 42 1D A1 22 FF
	fcos.l	([6,PC],D3,8),FP5	; F2 3B 42 9D 31 26 00

	fcos.s	D0,FP0			; F2 00 44 1D
	fcos.s	(A1),FP2		; F2 11 45 1D
	fcos.s	(A2)+,FP3		; F2 1A 45 9D
	fcos.s	-(A3),FP4		; F2 23 46 1D
	fcos.s	1(A4),FP5		; F2 2C 46 9D 00 01
	fcos.s	2(A5,D7.W),FP6		; F2 35 47 1D 70 02
	fcos.s	2(A5,D7.L),FP6		; F2 35 47 1D 78 02
	fcos.s	(0x1234).W,FP7		; F2 38 47 9D 12 34
	fcos.s	(0x1234).L,FP7		; F2 39 47 9D 00 00 12
	fcos.s	*0xFFFFFFF0,FP0		; F2 38 44 1D FF F0
	fcos.s	 0x00010004,FP1		; F2 39 44 9D 00 01 00
	fcos.s	#7,FP2			; F2 3C 45 1D 40 E0 00
	fcos.s	5(PC),FP3		; F2 3A 45 9D 00 01
	fcos.s	6(PC,A7.W),FP4		; F2 3B 46 1D F0 02
	fcos.s	6(PC,A7.L),FP4		; F2 3B 46 1D F8 02
	fcos.s	(0x1234,A0,D1),FP0	; F2 30 44 1D 11 20 12
	fcos.s	([2,A1,A2],4),FP1	; F2 31 44 9D A1 22 00
	fcos.s	([6,A2],D3,8),FP2	; F2 32 45 1D 31 26 00
	fcos.s	(0x1234,PC,D1),FP3	; F2 3B 45 9D 11 20 12
	fcos.s	([2,PC,A2],4),FP4	; F2 3B 46 1D A1 22 FF
	fcos.s	([6,PC],D3,8),FP5	; F2 3B 46 9D 31 26 00

	fcos.d	(A1),FP2		; F2 11 55 1D
	fcos.d	(A2)+,FP3		; F2 1A 55 9D
	fcos.d	-(A3),FP4		; F2 23 56 1D
	fcos.d	1(A4),FP5		; F2 2C 56 9D 00 01
	fcos.d	2(A5,D7.W),FP6		; F2 35 57 1D 70 02
	fcos.d	2(A5,D7.L),FP6		; F2 35 57 1D 78 02
	fcos.d	(0x1234).W,FP7		; F2 38 57 9D 12 34
	fcos.d	(0x1234).L,FP7		; F2 39 57 9D 00 00 12
	fcos.d	*0xFFFFFFF0,FP0		; F2 38 54 1D FF F0
	fcos.d	 0x00010004,FP1		; F2 39 54 9D 00 01 00
	fcos.d	5(PC),FP3		; F2 3A 55 9D 00 01
	fcos.d	6(PC,A7.W),FP4		; F2 3B 56 1D F0 02
	fcos.d	6(PC,A7.L),FP4		; F2 3B 56 1D F8 02
	fcos.d	(0x1234,A0,D1),FP0	; F2 30 54 1D 11 20 12
	fcos.d	([2,A1,A2],4),FP1	; F2 31 54 9D A1 22 00
	fcos.d	([6,A2],D3,8),FP2	; F2 32 55 1D 31 26 00
	fcos.d	(0x1234,PC,D1),FP3	; F2 3B 55 9D 11 20 12
	fcos.d	([2,PC,A2],4),FP4	; F2 3B 56 1D A1 22 FF
	fcos.d	([6,PC],D3,8),FP5	; F2 3B 56 9D 31 26 00

	fcos.x	FP7			; F2 00 1F 9D
	fcos.x	FP1,FP2			; F2 00 05 1D

	fcos.x	(A1),FP2		; F2 11 49 1D
	fcos.x	(A2)+,FP3		; F2 1A 49 9D
	fcos.x	-(A3),FP4		; F2 23 4A 1D
	fcos.x	1(A4),FP5		; F2 2C 4A 9D 00 01
	fcos.x	2(A5,D7.W),FP6		; F2 35 4B 1D 70 02
	fcos.x	2(A5,D7.L),FP6		; F2 35 4B 1D 78 02
	fcos.x	(0x1234).W,FP7		; F2 38 4B 9D 12 34
	fcos.x	(0x1234).L,FP7		; F2 39 4B 9D 00 00 12
	fcos.x	*0xFFFFFFF0,FP0		; F2 38 48 1D FF F0
	fcos.x	 0x00010004,FP1		; F2 39 48 9D 00 01 00
	fcos.x	5(PC),FP3		; F2 3A 49 9D 00 01
	fcos.x	6(PC,A7.W),FP4		; F2 3B 4A 1D F0 02
	fcos.x	6(PC,A7.L),FP4		; F2 3B 4A 1D F8 02
	fcos.x	(0x1234,A0,D1),FP0	; F2 30 48 1D 11 20 12
	fcos.x	([2,A1,A2],4),FP1	; F2 31 48 9D A1 22 00
	fcos.x	([6,A2],D3,8),FP2	; F2 32 49 1D 31 26 00
	fcos.x	(0x1234,PC,D1),FP3	; F2 3B 49 9D 11 20 12
	fcos.x	([2,PC,A2],4),FP4	; F2 3B 4A 1D A1 22 FF
	fcos.x	([6,PC],D3,8),FP5	; F2 3B 4A 9D 31 26 00

	fcos.p	(A1),FP2		; F2 11 4D 1D
	fcos.p	(A2)+,FP3		; F2 1A 4D 9D
	fcos.p	-(A3),FP4		; F2 23 4E 1D
	fcos.p	1(A4),FP5		; F2 2C 4E 9D 00 01
	fcos.p	2(A5,D7.W),FP6		; F2 35 4F 1D 70 02
	fcos.p	2(A5,D7.L),FP6		; F2 35 4F 1D 78 02
	fcos.p	(0x1234).W,FP7		; F2 38 4F 9D 12 34
	fcos.p	(0x1234).L,FP7		; F2 39 4F 9D 00 00 12
	fcos.p	*0xFFFFFFF0,FP0		; F2 38 4C 1D FF F0
	fcos.p	 0x00010004,FP1		; F2 39 4C 9D 00 01 00
	fcos.p	5(PC),FP3		; F2 3A 4D 9D 00 01
	fcos.p	6(PC,A7.W),FP4		; F2 3B 4E 1D F0 02
	fcos.p	6(PC,A7.L),FP4		; F2 3B 4E 1D F8 02
	fcos.p	(0x1234,A0,D1),FP0	; F2 30 4C 1D 11 20 12
	fcos.p	([2,A1,A2],4),FP1	; F2 31 4C 9D A1 22 00
	fcos.p	([6,A2],D3,8),FP2	; F2 32 4D 1D 31 26 00
	fcos.p	(0x1234,PC,D1),FP3	; F2 3B 4D 9D 11 20 12
	fcos.p	([2,PC,A2],4),FP4	; F2 3B 4E 1D A1 22 FF
	fcos.p	([6,PC],D3,8),FP5	; F2 3B 4E 9D 31 26 00

	facos	FP7			; F2 00 1F 9C
	facos	FP1,FP2			; F2 00 05 1C

	facos	(A1),FP2		; F2 11 49 1C
	facos	(A2)+,FP3		; F2 1A 49 9C
	facos	-(A3),FP4		; F2 23 4A 1C
	facos	1(A4),FP5		; F2 2C 4A 9C 00 01
	facos	2(A5,D7.W),FP6		; F2 35 4B 1C 70 02
	facos	2(A5,D7.L),FP6		; F2 35 4B 1C 78 02
	facos	(0x1234).W,FP7		; F2 38 4B 9C 12 34
	facos	(0x1234).L,FP7		; F2 39 4B 9C 00 00 12
	facos	*0xFFFFFFF0,FP0		; F2 38 48 1C FF F0
	facos	 0x00010004,FP1		; F2 39 48 9C 00 01 00
	facos	5(PC),FP3		; F2 3A 49 9C 00 01
	facos	6(PC,A7.W),FP4		; F2 3B 4A 1C F0 02
	facos	6(PC,A7.L),FP4		; F2 3B 4A 1C F8 02
	facos	(0x1234,A0,D1),FP0	; F2 30 48 1C 11 20 12
	facos	([2,A1,A2],4),FP1	; F2 31 48 9C A1 22 00
	facos	([6,A2],D3,8),FP2	; F2 32 49 1C 31 26 00
	facos	(0x1234,PC,D1),FP3	; F2 3B 49 9C 11 20 12
	facos	([2,PC,A2],4),FP4	; F2 3B 4A 1C A1 22 FF
	facos	([6,PC],D3,8),FP5	; F2 3B 4A 9C 31 26 00

	facos.b	D0,FP0			; F2 00 58 1C
	facos.b	(A1),FP2		; F2 11 59 1C
	facos.b	(A2)+,FP3		; F2 1A 59 9C
	facos.b	-(A3),FP4		; F2 23 5A 1C
	facos.b	1(A4),FP5		; F2 2C 5A 9C 00 01
	facos.b	2(A5,D7.W),FP6		; F2 35 5B 1C 70 02
	facos.b	2(A5,D7.L),FP6		; F2 35 5B 1C 78 02
	facos.b	(0x1234).W,FP7		; F2 38 5B 9C 12 34
	facos.b	(0x1234).L,FP7		; F2 39 5B 9C 00 00 12
	facos.b	*0xFFFFFFF0,FP0		; F2 38 58 1C FF F0
	facos.b	 0x00010004,FP1		; F2 39 58 9C 00 01 00
	facos.b	#7,FP2			; F2 3C 59 1C 00 07
	facos.b	5(PC),FP3		; F2 3A 59 9C 00 01
	facos.b	6(PC,A7.W),FP4		; F2 3B 5A 1C F0 02
	facos.b	6(PC,A7.L),FP4		; F2 3B 5A 1C F8 02
	facos.b	(0x1234,A0,D1),FP0	; F2 30 58 1C 11 20 12
	facos.b	([2,A1,A2],4),FP1	; F2 31 58 9C A1 22 00
	facos.b	([6,A2],D3,8),FP2	; F2 32 59 1C 31 26 00
	facos.b	(0x1234,PC,D1),FP3	; F2 3B 59 9C 11 20 12
	facos.b	([2,PC,A2],4),FP4	; F2 3B 5A 1C A1 22 FF
	facos.b	([6,PC],D3,8),FP5	; F2 3B 5A 9C 31 26 00

	facos.w	D0,FP0			; F2 00 50 1C
	facos.w	(A1),FP2		; F2 11 51 1C
	facos.w	(A2)+,FP3		; F2 1A 51 9C
	facos.w	-(A3),FP4		; F2 23 52 1C
	facos.w	1(A4),FP5		; F2 2C 52 9C 00 01
	facos.w	2(A5,D7.W),FP6		; F2 35 53 1C 70 02
	facos.w	2(A5,D7.L),FP6		; F2 35 53 1C 78 02
	facos.w	(0x1234).W,FP7		; F2 38 53 9C 12 34
	facos.w	(0x1234).L,FP7		; F2 39 53 9C 00 00 12
	facos.w	*0xFFFFFFF0,FP0		; F2 38 50 1C FF F0
	facos.w	 0x00010004,FP1		; F2 39 50 9C 00 01 00
	facos.w	#7,FP2			; F2 3C 51 1C 00 07
	facos.w	5(PC),FP3		; F2 3A 51 9C 00 01
	facos.w	6(PC,A7.W),FP4		; F2 3B 52 1C F0 02
	facos.w	6(PC,A7.L),FP4		; F2 3B 52 1C F8 02
	facos.w	(0x1234,A0,D1),FP0	; F2 30 50 1C 11 20 12
	facos.w	([2,A1,A2],4),FP1	; F2 31 50 9C A1 22 00
	facos.w	([6,A2],D3,8),FP2	; F2 32 51 1C 31 26 00
	facos.w	(0x1234,PC,D1),FP3	; F2 3B 51 9C 11 20 12
	facos.w	([2,PC,A2],4),FP4	; F2 3B 52 1C A1 22 FF
	facos.w	([6,PC],D3,8),FP5	; F2 3B 52 9C 31 26 00

	facos.l	D0,FP0			; F2 00 40 1C
	facos.l	(A1),FP2		; F2 11 41 1C
	facos.l	(A2)+,FP3		; F2 1A 41 9C
	facos.l	-(A3),FP4		; F2 23 42 1C
	facos.l	1(A4),FP5		; F2 2C 42 9C 00 01
	facos.l	2(A5,D7.W),FP6		; F2 35 43 1C 70 02
	facos.l	2(A5,D7.L),FP6		; F2 35 43 1C 78 02
	facos.l	(0x1234).W,FP7		; F2 38 43 9C 12 34
	facos.l	(0x1234).L,FP7		; F2 39 43 9C 00 00 12
	facos.l	*0xFFFFFFF0,FP0		; F2 38 40 1C FF F0
	facos.l	 0x00010004,FP1		; F2 39 40 9C 00 01 00
	facos.l	#7,FP2			; F2 3C 41 1C 00 00 00
	facos.l	5(PC),FP3		; F2 3A 41 9C 00 01
	facos.l	6(PC,A7.W),FP4		; F2 3B 42 1C F0 02
	facos.l	6(PC,A7.L),FP4		; F2 3B 42 1C F8 02
	facos.l	(0x1234,A0,D1),FP0	; F2 30 40 1C 11 20 12
	facos.l	([2,A1,A2],4),FP1	; F2 31 40 9C A1 22 00
	facos.l	([6,A2],D3,8),FP2	; F2 32 41 1C 31 26 00
	facos.l	(0x1234,PC,D1),FP3	; F2 3B 41 9C 11 20 12
	facos.l	([2,PC,A2],4),FP4	; F2 3B 42 1C A1 22 FF
	facos.l	([6,PC],D3,8),FP5	; F2 3B 42 9C 31 26 00

	facos.s	D0,FP0			; F2 00 44 1C
	facos.s	(A1),FP2		; F2 11 45 1C
	facos.s	(A2)+,FP3		; F2 1A 45 9C
	facos.s	-(A3),FP4		; F2 23 46 1C
	facos.s	1(A4),FP5		; F2 2C 46 9C 00 01
	facos.s	2(A5,D7.W),FP6		; F2 35 47 1C 70 02
	facos.s	2(A5,D7.L),FP6		; F2 35 47 1C 78 02
	facos.s	(0x1234).W,FP7		; F2 38 47 9C 12 34
	facos.s	(0x1234).L,FP7		; F2 39 47 9C 00 00 12
	facos.s	*0xFFFFFFF0,FP0		; F2 38 44 1C FF F0
	facos.s	 0x00010004,FP1		; F2 39 44 9C 00 01 00
	facos.s	#7,FP2			; F2 3C 45 1C 40 E0 00
	facos.s	5(PC),FP3		; F2 3A 45 9C 00 01
	facos.s	6(PC,A7.W),FP4		; F2 3B 46 1C F0 02
	facos.s	6(PC,A7.L),FP4		; F2 3B 46 1C F8 02
	facos.s	(0x1234,A0,D1),FP0	; F2 30 44 1C 11 20 12
	facos.s	([2,A1,A2],4),FP1	; F2 31 44 9C A1 22 00
	facos.s	([6,A2],D3,8),FP2	; F2 32 45 1C 31 26 00
	facos.s	(0x1234,PC,D1),FP3	; F2 3B 45 9C 11 20 12
	facos.s	([2,PC,A2],4),FP4	; F2 3B 46 1C A1 22 FF
	facos.s	([6,PC],D3,8),FP5	; F2 3B 46 9C 31 26 00

	facos.d	(A1),FP2		; F2 11 55 1C
	facos.d	(A2)+,FP3		; F2 1A 55 9C
	facos.d	-(A3),FP4		; F2 23 56 1C
	facos.d	1(A4),FP5		; F2 2C 56 9C 00 01
	facos.d	2(A5,D7.W),FP6		; F2 35 57 1C 70 02
	facos.d	2(A5,D7.L),FP6		; F2 35 57 1C 78 02
	facos.d	(0x1234).W,FP7		; F2 38 57 9C 12 34
	facos.d	(0x1234).L,FP7		; F2 39 57 9C 00 00 12
	facos.d	*0xFFFFFFF0,FP0		; F2 38 54 1C FF F0
	facos.d	 0x00010004,FP1		; F2 39 54 9C 00 01 00
	facos.d	5(PC),FP3		; F2 3A 55 9C 00 01
	facos.d	6(PC,A7.W),FP4		; F2 3B 56 1C F0 02
	facos.d	6(PC,A7.L),FP4		; F2 3B 56 1C F8 02
	facos.d	(0x1234,A0,D1),FP0	; F2 30 54 1C 11 20 12
	facos.d	([2,A1,A2],4),FP1	; F2 31 54 9C A1 22 00
	facos.d	([6,A2],D3,8),FP2	; F2 32 55 1C 31 26 00
	facos.d	(0x1234,PC,D1),FP3	; F2 3B 55 9C 11 20 12
	facos.d	([2,PC,A2],4),FP4	; F2 3B 56 1C A1 22 FF
	facos.d	([6,PC],D3,8),FP5	; F2 3B 56 9C 31 26 00

	facos.x	FP7			; F2 00 1F 9C
	facos.x	FP1,FP2			; F2 00 05 1C

	facos.x	(A1),FP2		; F2 11 49 1C
	facos.x	(A2)+,FP3		; F2 1A 49 9C
	facos.x	-(A3),FP4		; F2 23 4A 1C
	facos.x	1(A4),FP5		; F2 2C 4A 9C 00 01
	facos.x	2(A5,D7.W),FP6		; F2 35 4B 1C 70 02
	facos.x	2(A5,D7.L),FP6		; F2 35 4B 1C 78 02
	facos.x	(0x1234).W,FP7		; F2 38 4B 9C 12 34
	facos.x	(0x1234).L,FP7		; F2 39 4B 9C 00 00 12
	facos.x	*0xFFFFFFF0,FP0		; F2 38 48 1C FF F0
	facos.x	 0x00010004,FP1		; F2 39 48 9C 00 01 00
	facos.x	5(PC),FP3		; F2 3A 49 9C 00 01
	facos.x	6(PC,A7.W),FP4		; F2 3B 4A 1C F0 02
	facos.x	6(PC,A7.L),FP4		; F2 3B 4A 1C F8 02
	facos.x	(0x1234,A0,D1),FP0	; F2 30 48 1C 11 20 12
	facos.x	([2,A1,A2],4),FP1	; F2 31 48 9C A1 22 00
	facos.x	([6,A2],D3,8),FP2	; F2 32 49 1C 31 26 00
	facos.x	(0x1234,PC,D1),FP3	; F2 3B 49 9C 11 20 12
	facos.x	([2,PC,A2],4),FP4	; F2 3B 4A 1C A1 22 FF
	facos.x	([6,PC],D3,8),FP5	; F2 3B 4A 9C 31 26 00

	facos.p	(A1),FP2		; F2 11 4D 1C
	facos.p	(A2)+,FP3		; F2 1A 4D 9C
	facos.p	-(A3),FP4		; F2 23 4E 1C
	facos.p	1(A4),FP5		; F2 2C 4E 9C 00 01
	facos.p	2(A5,D7.W),FP6		; F2 35 4F 1C 70 02
	facos.p	2(A5,D7.L),FP6		; F2 35 4F 1C 78 02
	facos.p	(0x1234).W,FP7		; F2 38 4F 9C 12 34
	facos.p	(0x1234).L,FP7		; F2 39 4F 9C 00 00 12
	facos.p	*0xFFFFFFF0,FP0		; F2 38 4C 1C FF F0
	facos.p	 0x00010004,FP1		; F2 39 4C 9C 00 01 00
	facos.p	5(PC),FP3		; F2 3A 4D 9C 00 01
	facos.p	6(PC,A7.W),FP4		; F2 3B 4E 1C F0 02
	facos.p	6(PC,A7.L),FP4		; F2 3B 4E 1C F8 02
	facos.p	(0x1234,A0,D1),FP0	; F2 30 4C 1C 11 20 12
	facos.p	([2,A1,A2],4),FP1	; F2 31 4C 9C A1 22 00
	facos.p	([6,A2],D3,8),FP2	; F2 32 4D 1C 31 26 00
	facos.p	(0x1234,PC,D1),FP3	; F2 3B 4D 9C 11 20 12
	facos.p	([2,PC,A2],4),FP4	; F2 3B 4E 1C A1 22 FF
	facos.p	([6,PC],D3,8),FP5	; F2 3B 4E 9C 31 26 00

	fgetexp	FP7			; F2 00 1F 9E
	fgetexp	FP1,FP2			; F2 00 05 1E

	fgetexp	(A1),FP2		; F2 11 49 1E
	fgetexp	(A2)+,FP3		; F2 1A 49 9E
	fgetexp	-(A3),FP4		; F2 23 4A 1E
	fgetexp	1(A4),FP5		; F2 2C 4A 9E 00 01
	fgetexp	2(A5,D7.W),FP6		; F2 35 4B 1E 70 02
	fgetexp	2(A5,D7.L),FP6		; F2 35 4B 1E 78 02
	fgetexp	(0x1234).W,FP7		; F2 38 4B 9E 12 34
	fgetexp	(0x1234).L,FP7		; F2 39 4B 9E 00 00 12
	fgetexp	*0xFFFFFFF0,FP0		; F2 38 48 1E FF F0
	fgetexp	 0x00010004,FP1		; F2 39 48 9E 00 01 00
	fgetexp	5(PC),FP3		; F2 3A 49 9E 00 01
	fgetexp	6(PC,A7.W),FP4		; F2 3B 4A 1E F0 02
	fgetexp	6(PC,A7.L),FP4		; F2 3B 4A 1E F8 02
	fgetexp	(0x1234,A0,D1),FP0	; F2 30 48 1E 11 20 12
	fgetexp	([2,A1,A2],4),FP1	; F2 31 48 9E A1 22 00
	fgetexp	([6,A2],D3,8),FP2	; F2 32 49 1E 31 26 00
	fgetexp	(0x1234,PC,D1),FP3	; F2 3B 49 9E 11 20 12
	fgetexp	([2,PC,A2],4),FP4	; F2 3B 4A 1E A1 22 FF
	fgetexp	([6,PC],D3,8),FP5	; F2 3B 4A 9E 31 26 00

	fgetexp.b	D0,FP0		; F2 00 58 1E
	fgetexp.b	(A1),FP2	; F2 11 59 1E
	fgetexp.b	(A2)+,FP3	; F2 1A 59 9E
	fgetexp.b	-(A3),FP4	; F2 23 5A 1E
	fgetexp.b	1(A4),FP5	; F2 2C 5A 9E 00 01
	fgetexp.b	2(A5,D7.W),FP6	; F2 35 5B 1E 70 02
	fgetexp.b	2(A5,D7.L),FP6	; F2 35 5B 1E 78 02
	fgetexp.b	(0x1234).W,FP7	; F2 38 5B 9E 12 34
	fgetexp.b	(0x1234).L,FP7	; F2 39 5B 9E 00 00 12
	fgetexp.b	*0xFFFFFFF0,FP0	; F2 38 58 1E FF F0
	fgetexp.b	 0x00010004,FP1	; F2 39 58 9E 00 01 00
	fgetexp.b	#7,FP2		; F2 3C 59 1E 00 07
	fgetexp.b	5(PC),FP3	; F2 3A 59 9E 00 01
	fgetexp.b	6(PC,A7.W),FP4	; F2 3B 5A 1E F0 02
	fgetexp.b	6(PC,A7.L),FP4	; F2 3B 5A 1E F8 02
	fgetexp.b	(0x1234,A0,D1),FP0	; F2 30 58 1E 11 20 12
	fgetexp.b	([2,A1,A2],4),FP1	; F2 31 58 9E A1 22 00
	fgetexp.b	([6,A2],D3,8),FP2	; F2 32 59 1E 31 26 00
	fgetexp.b	(0x1234,PC,D1),FP3	; F2 3B 59 9E 11 20 12
	fgetexp.b	([2,PC,A2],4),FP4	; F2 3B 5A 1E A1 22 FF
	fgetexp.b	([6,PC],D3,8),FP5	; F2 3B 5A 9E 31 26 00

	fgetexp.w	D0,FP0		; F2 00 50 1E
	fgetexp.w	(A1),FP2	; F2 11 51 1E
	fgetexp.w	(A2)+,FP3	; F2 1A 51 9E
	fgetexp.w	-(A3),FP4	; F2 23 52 1E
	fgetexp.w	1(A4),FP5	; F2 2C 52 9E 00 01
	fgetexp.w	2(A5,D7.W),FP6	; F2 35 53 1E 70 02
	fgetexp.w	2(A5,D7.L),FP6	; F2 35 53 1E 78 02
	fgetexp.w	(0x1234).W,FP7	; F2 38 53 9E 12 34
	fgetexp.w	(0x1234).L,FP7	; F2 39 53 9E 00 00 12
	fgetexp.w	*0xFFFFFFF0,FP0	; F2 38 50 1E FF F0
	fgetexp.w	 0x00010004,FP1	; F2 39 50 9E 00 01 00
	fgetexp.w	#7,FP2		; F2 3C 51 1E 00 07
	fgetexp.w	5(PC),FP3	; F2 3A 51 9E 00 01
	fgetexp.w	6(PC,A7.W),FP4	; F2 3B 52 1E F0 02
	fgetexp.w	6(PC,A7.L),FP4	; F2 3B 52 1E F8 02
	fgetexp.w	(0x1234,A0,D1),FP0	; F2 30 50 1E 11 20 12
	fgetexp.w	([2,A1,A2],4),FP1	; F2 31 50 9E A1 22 00
	fgetexp.w	([6,A2],D3,8),FP2	; F2 32 51 1E 31 26 00
	fgetexp.w	(0x1234,PC,D1),FP3	; F2 3B 51 9E 11 20 12
	fgetexp.w	([2,PC,A2],4),FP4	; F2 3B 52 1E A1 22 FF
	fgetexp.w	([6,PC],D3,8),FP5	; F2 3B 52 9E 31 26 00

	fgetexp.l	D0,FP0		; F2 00 40 1E
	fgetexp.l	(A1),FP2	; F2 11 41 1E
	fgetexp.l	(A2)+,FP3	; F2 1A 41 9E
	fgetexp.l	-(A3),FP4	; F2 23 42 1E
	fgetexp.l	1(A4),FP5	; F2 2C 42 9E 00 01
	fgetexp.l	2(A5,D7.W),FP6	; F2 35 43 1E 70 02
	fgetexp.l	2(A5,D7.L),FP6	; F2 35 43 1E 78 02
	fgetexp.l	(0x1234).W,FP7	; F2 38 43 9E 12 34
	fgetexp.l	(0x1234).L,FP7	; F2 39 43 9E 00 00 12
	fgetexp.l	*0xFFFFFFF0,FP0	; F2 38 40 1E FF F0
	fgetexp.l	 0x00010004,FP1	; F2 39 40 9E 00 01 00
	fgetexp.l	#7,FP2		; F2 3C 41 1E 00 00 00
	fgetexp.l	5(PC),FP3	; F2 3A 41 9E 00 01
	fgetexp.l	6(PC,A7.W),FP4	; F2 3B 42 1E F0 02
	fgetexp.l	6(PC,A7.L),FP4	; F2 3B 42 1E F8 02
	fgetexp.l	(0x1234,A0,D1),FP0	; F2 30 40 1E 11 20 12
	fgetexp.l	([2,A1,A2],4),FP1	; F2 31 40 9E A1 22 00
	fgetexp.l	([6,A2],D3,8),FP2	; F2 32 41 1E 31 26 00
	fgetexp.l	(0x1234,PC,D1),FP3	; F2 3B 41 9E 11 20 12
	fgetexp.l	([2,PC,A2],4),FP4	; F2 3B 42 1E A1 22 FF
	fgetexp.l	([6,PC],D3,8),FP5	; F2 3B 42 9E 31 26 00

	fgetexp.s	D0,FP0		; F2 00 44 1E
	fgetexp.s	(A1),FP2	; F2 11 45 1E
	fgetexp.s	(A2)+,FP3	; F2 1A 45 9E
	fgetexp.s	-(A3),FP4	; F2 23 46 1E
	fgetexp.s	1(A4),FP5	; F2 2C 46 9E 00 01
	fgetexp.s	2(A5,D7.W),FP6	; F2 35 47 1E 70 02
	fgetexp.s	2(A5,D7.L),FP6	; F2 35 47 1E 78 02
	fgetexp.s	(0x1234).W,FP7	; F2 38 47 9E 12 34
	fgetexp.s	(0x1234).L,FP7	; F2 39 47 9E 00 00 12
	fgetexp.s	*0xFFFFFFF0,FP0	; F2 38 44 1E FF F0
	fgetexp.s	 0x00010004,FP1	; F2 39 44 9E 00 01 00
	fgetexp.s	#7,FP2		; F2 3C 45 1E 40 E0 00
	fgetexp.s	5(PC),FP3	; F2 3A 45 9E 00 01
	fgetexp.s	6(PC,A7.W),FP4	; F2 3B 46 1E F0 02
	fgetexp.s	6(PC,A7.L),FP4	; F2 3B 46 1E F8 02
	fgetexp.s	(0x1234,A0,D1),FP0	; F2 30 44 1E 11 20 12
	fgetexp.s	([2,A1,A2],4),FP1	; F2 31 44 9E A1 22 00
	fgetexp.s	([6,A2],D3,8),FP2	; F2 32 45 1E 31 26 00
	fgetexp.s	(0x1234,PC,D1),FP3	; F2 3B 45 9E 11 20 12
	fgetexp.s	([2,PC,A2],4),FP4	; F2 3B 46 1E A1 22 FF
	fgetexp.s	([6,PC],D3,8),FP5	; F2 3B 46 9E 31 26 00

	fgetexp.d	(A1),FP2	; F2 11 55 1E
	fgetexp.d	(A2)+,FP3	; F2 1A 55 9E
	fgetexp.d	-(A3),FP4	; F2 23 56 1E
	fgetexp.d	1(A4),FP5	; F2 2C 56 9E 00 01
	fgetexp.d	2(A5,D7.W),FP6	; F2 35 57 1E 70 02
	fgetexp.d	2(A5,D7.L),FP6	; F2 35 57 1E 78 02
	fgetexp.d	(0x1234).W,FP7	; F2 38 57 9E 12 34
	fgetexp.d	(0x1234).L,FP7	; F2 39 57 9E 00 00 12
	fgetexp.d	*0xFFFFFFF0,FP0	; F2 38 54 1E FF F0
	fgetexp.d	 0x00010004,FP1	; F2 39 54 9E 00 01 00
	fgetexp.d	5(PC),FP3	; F2 3A 55 9E 00 01
	fgetexp.d	6(PC,A7.W),FP4	; F2 3B 56 1E F0 02
	fgetexp.d	6(PC,A7.L),FP4	; F2 3B 56 1E F8 02
	fgetexp.d	(0x1234,A0,D1),FP0	; F2 30 54 1E 11 20 12
	fgetexp.d	([2,A1,A2],4),FP1	; F2 31 54 9E A1 22 00
	fgetexp.d	([6,A2],D3,8),FP2	; F2 32 55 1E 31 26 00
	fgetexp.d	(0x1234,PC,D1),FP3	; F2 3B 55 9E 11 20 12
	fgetexp.d	([2,PC,A2],4),FP4	; F2 3B 56 1E A1 22 FF
	fgetexp.d	([6,PC],D3,8),FP5	; F2 3B 56 9E 31 26 00

	fgetexp.x	FP7		; F2 00 1F 9E
	fgetexp.x	FP1,FP2		; F2 00 05 1E

	fgetexp.x	(A1),FP2	; F2 11 49 1E
	fgetexp.x	(A2)+,FP3	; F2 1A 49 9E
	fgetexp.x	-(A3),FP4	; F2 23 4A 1E
	fgetexp.x	1(A4),FP5	; F2 2C 4A 9E 00 01
	fgetexp.x	2(A5,D7.W),FP6	; F2 35 4B 1E 70 02
	fgetexp.x	2(A5,D7.L),FP6	; F2 35 4B 1E 78 02
	fgetexp.x	(0x1234).W,FP7	; F2 38 4B 9E 12 34
	fgetexp.x	(0x1234).L,FP7	; F2 39 4B 9E 00 00 12
	fgetexp.x	*0xFFFFFFF0,FP0	; F2 38 48 1E FF F0
	fgetexp.x	 0x00010004,FP1	; F2 39 48 9E 00 01 00
	fgetexp.x	5(PC),FP3	; F2 3A 49 9E 00 01
	fgetexp.x	6(PC,A7.W),FP4	; F2 3B 4A 1E F0 02
	fgetexp.x	6(PC,A7.L),FP4	; F2 3B 4A 1E F8 02
	fgetexp.x	(0x1234,A0,D1),FP0	; F2 30 48 1E 11 20 12
	fgetexp.x	([2,A1,A2],4),FP1	; F2 31 48 9E A1 22 00
	fgetexp.x	([6,A2],D3,8),FP2	; F2 32 49 1E 31 26 00
	fgetexp.x	(0x1234,PC,D1),FP3	; F2 3B 49 9E 11 20 12
	fgetexp.x	([2,PC,A2],4),FP4	; F2 3B 4A 1E A1 22 FF
	fgetexp.x	([6,PC],D3,8),FP5	; F2 3B 4A 9E 31 26 00

	fgetexp.p	(A1),FP2	; F2 11 4D 1E
	fgetexp.p	(A2)+,FP3	; F2 1A 4D 9E
	fgetexp.p	-(A3),FP4	; F2 23 4E 1E
	fgetexp.p	1(A4),FP5	; F2 2C 4E 9E 00 01
	fgetexp.p	2(A5,D7.W),FP6	; F2 35 4F 1E 70 02
	fgetexp.p	2(A5,D7.L),FP6	; F2 35 4F 1E 78 02
	fgetexp.p	(0x1234).W,FP7	; F2 38 4F 9E 12 34
	fgetexp.p	(0x1234).L,FP7	; F2 39 4F 9E 00 00 12
	fgetexp.p	*0xFFFFFFF0,FP0	; F2 38 4C 1E FF F0
	fgetexp.p	 0x00010004,FP1	; F2 39 4C 9E 00 01 00
	fgetexp.p	5(PC),FP3	; F2 3A 4D 9E 00 01
	fgetexp.p	6(PC,A7.W),FP4	; F2 3B 4E 1E F0 02
	fgetexp.p	6(PC,A7.L),FP4	; F2 3B 4E 1E F8 02
	fgetexp.p	(0x1234,A0,D1),FP0	; F2 30 4C 1E 11 20 12
	fgetexp.p	([2,A1,A2],4),FP1	; F2 31 4C 9E A1 22 00
	fgetexp.p	([6,A2],D3,8),FP2	; F2 32 4D 1E 31 26 00
	fgetexp.p	(0x1234,PC,D1),FP3	; F2 3B 4D 9E 11 20 12
	fgetexp.p	([2,PC,A2],4),FP4	; F2 3B 4E 1E A1 22 FF
	fgetexp.p	([6,PC],D3,8),FP5	; F2 3B 4E 9E 31 26 00

	fgetman	FP7			; F2 00 1F 9F
	fgetman	FP1,FP2			; F2 00 05 1F

	fgetman	(A1),FP2		; F2 11 49 1F
	fgetman	(A2)+,FP3		; F2 1A 49 9F
	fgetman	-(A3),FP4		; F2 23 4A 1F
	fgetman	1(A4),FP5		; F2 2C 4A 9F 00 01
	fgetman	2(A5,D7.W),FP6		; F2 35 4B 1F 70 02
	fgetman	2(A5,D7.L),FP6		; F2 35 4B 1F 78 02
	fgetman	(0x1234).W,FP7		; F2 38 4B 9F 12 34
	fgetman	(0x1234).L,FP7		; F2 39 4B 9F 00 00 12
	fgetman	*0xFFFFFFF0,FP0		; F2 38 48 1F FF F0
	fgetman	 0x00010004,FP1		; F2 39 48 9F 00 01 00
	fgetman	5(PC),FP3		; F2 3A 49 9F 00 01
	fgetman	6(PC,A7.W),FP4		; F2 3B 4A 1F F0 02
	fgetman	6(PC,A7.L),FP4		; F2 3B 4A 1F F8 02
	fgetman	(0x1234,A0,D1),FP0	; F2 30 48 1F 11 20 12
	fgetman	([2,A1,A2],4),FP1	; F2 31 48 9F A1 22 00
	fgetman	([6,A2],D3,8),FP2	; F2 32 49 1F 31 26 00
	fgetman	(0x1234,PC,D1),FP3	; F2 3B 49 9F 11 20 12
	fgetman	([2,PC,A2],4),FP4	; F2 3B 4A 1F A1 22 FF
	fgetman	([6,PC],D3,8),FP5	; F2 3B 4A 9F 31 26 00

	fgetman.b	D0,FP0		; F2 00 58 1F
	fgetman.b	(A1),FP2	; F2 11 59 1F
	fgetman.b	(A2)+,FP3	; F2 1A 59 9F
	fgetman.b	-(A3),FP4	; F2 23 5A 1F
	fgetman.b	1(A4),FP5	; F2 2C 5A 9F 00 01
	fgetman.b	2(A5,D7.W),FP6	; F2 35 5B 1F 70 02
	fgetman.b	2(A5,D7.L),FP6	; F2 35 5B 1F 78 02
	fgetman.b	(0x1234).W,FP7	; F2 38 5B 9F 12 34
	fgetman.b	(0x1234).L,FP7	; F2 39 5B 9F 00 00 12
	fgetman.b	*0xFFFFFFF0,FP0	; F2 38 58 1F FF F0
	fgetman.b	 0x00010004,FP1	; F2 39 58 9F 00 01 00
	fgetman.b	#7,FP2		; F2 3C 59 1F 00 07
	fgetman.b	5(PC),FP3	; F2 3A 59 9F 00 01
	fgetman.b	6(PC,A7.W),FP4	; F2 3B 5A 1F F0 02
	fgetman.b	6(PC,A7.L),FP4	; F2 3B 5A 1F F8 02
	fgetman.b	(0x1234,A0,D1),FP0	; F2 30 58 1F 11 20 12
	fgetman.b	([2,A1,A2],4),FP1	; F2 31 58 9F A1 22 00
	fgetman.b	([6,A2],D3,8),FP2	; F2 32 59 1F 31 26 00
	fgetman.b	(0x1234,PC,D1),FP3	; F2 3B 59 9F 11 20 12
	fgetman.b	([2,PC,A2],4),FP4	; F2 3B 5A 1F A1 22 FF
	fgetman.b	([6,PC],D3,8),FP5	; F2 3B 5A 9F 31 26 00

	fgetman.w	D0,FP0		; F2 00 50 1F
	fgetman.w	(A1),FP2	; F2 11 51 1F
	fgetman.w	(A2)+,FP3	; F2 1A 51 9F
	fgetman.w	-(A3),FP4	; F2 23 52 1F
	fgetman.w	1(A4),FP5	; F2 2C 52 9F 00 01
	fgetman.w	2(A5,D7.W),FP6	; F2 35 53 1F 70 02
	fgetman.w	2(A5,D7.L),FP6	; F2 35 53 1F 78 02
	fgetman.w	(0x1234).W,FP7	; F2 38 53 9F 12 34
	fgetman.w	(0x1234).L,FP7	; F2 39 53 9F 00 00 12
	fgetman.w	*0xFFFFFFF0,FP0	; F2 38 50 1F FF F0
	fgetman.w	 0x00010004,FP1	; F2 39 50 9F 00 01 00
	fgetman.w	#7,FP2		; F2 3C 51 1F 00 07
	fgetman.w	5(PC),FP3	; F2 3A 51 9F 00 01
	fgetman.w	6(PC,A7.W),FP4	; F2 3B 52 1F F0 02
	fgetman.w	6(PC,A7.L),FP4	; F2 3B 52 1F F8 02
	fgetman.w	(0x1234,A0,D1),FP0	; F2 30 50 1F 11 20 12
	fgetman.w	([2,A1,A2],4),FP1	; F2 31 50 9F A1 22 00
	fgetman.w	([6,A2],D3,8),FP2	; F2 32 51 1F 31 26 00
	fgetman.w	(0x1234,PC,D1),FP3	; F2 3B 51 9F 11 20 12
	fgetman.w	([2,PC,A2],4),FP4	; F2 3B 52 1F A1 22 FF
	fgetman.w	([6,PC],D3,8),FP5	; F2 3B 52 9F 31 26 00

	fgetman.l	D0,FP0		; F2 00 40 1F
	fgetman.l	(A1),FP2	; F2 11 41 1F
	fgetman.l	(A2)+,FP3	; F2 1A 41 9F
	fgetman.l	-(A3),FP4	; F2 23 42 1F
	fgetman.l	1(A4),FP5	; F2 2C 42 9F 00 01
	fgetman.l	2(A5,D7.W),FP6	; F2 35 43 1F 70 02
	fgetman.l	2(A5,D7.L),FP6	; F2 35 43 1F 78 02
	fgetman.l	(0x1234).W,FP7	; F2 38 43 9F 12 34
	fgetman.l	(0x1234).L,FP7	; F2 39 43 9F 00 00 12
	fgetman.l	*0xFFFFFFF0,FP0	; F2 38 40 1F FF F0
	fgetman.l	 0x00010004,FP1	; F2 39 40 9F 00 01 00
	fgetman.l	#7,FP2		; F2 3C 41 1F 00 00 00
	fgetman.l	5(PC),FP3	; F2 3A 41 9F 00 01
	fgetman.l	6(PC,A7.W),FP4	; F2 3B 42 1F F0 02
	fgetman.l	6(PC,A7.L),FP4	; F2 3B 42 1F F8 02
	fgetman.l	(0x1234,A0,D1),FP0	; F2 30 40 1F 11 20 12
	fgetman.l	([2,A1,A2],4),FP1	; F2 31 40 9F A1 22 00
	fgetman.l	([6,A2],D3,8),FP2	; F2 32 41 1F 31 26 00
	fgetman.l	(0x1234,PC,D1),FP3	; F2 3B 41 9F 11 20 12
	fgetman.l	([2,PC,A2],4),FP4	; F2 3B 42 1F A1 22 FF
	fgetman.l	([6,PC],D3,8),FP5	; F2 3B 42 9F 31 26 00

	fgetman.s	D0,FP0		; F2 00 44 1F
	fgetman.s	(A1),FP2	; F2 11 45 1F
	fgetman.s	(A2)+,FP3	; F2 1A 45 9F
	fgetman.s	-(A3),FP4	; F2 23 46 1F
	fgetman.s	1(A4),FP5	; F2 2C 46 9F 00 01
	fgetman.s	2(A5,D7.W),FP6	; F2 35 47 1F 70 02
	fgetman.s	2(A5,D7.L),FP6	; F2 35 47 1F 78 02
	fgetman.s	(0x1234).W,FP7	; F2 38 47 9F 12 34
	fgetman.s	(0x1234).L,FP7	; F2 39 47 9F 00 00 12
	fgetman.s	*0xFFFFFFF0,FP0	; F2 38 44 1F FF F0
	fgetman.s	 0x00010004,FP1	; F2 39 44 9F 00 01 00
	fgetman.s	#7,FP2		; F2 3C 45 1F 40 E0 00
	fgetman.s	5(PC),FP3	; F2 3A 45 9F 00 01
	fgetman.s	6(PC,A7.W),FP4	; F2 3B 46 1F F0 02
	fgetman.s	6(PC,A7.L),FP4	; F2 3B 46 1F F8 02
	fgetman.s	(0x1234,A0,D1),FP0	; F2 30 44 1F 11 20 12
	fgetman.s	([2,A1,A2],4),FP1	; F2 31 44 9F A1 22 00
	fgetman.s	([6,A2],D3,8),FP2	; F2 32 45 1F 31 26 00
	fgetman.s	(0x1234,PC,D1),FP3	; F2 3B 45 9F 11 20 12
	fgetman.s	([2,PC,A2],4),FP4	; F2 3B 46 1F A1 22 FF
	fgetman.s	([6,PC],D3,8),FP5	; F2 3B 46 9F 31 26 00

	fgetman.d	(A1),FP2	; F2 11 55 1F
	fgetman.d	(A2)+,FP3	; F2 1A 55 9F
	fgetman.d	-(A3),FP4	; F2 23 56 1F
	fgetman.d	1(A4),FP5	; F2 2C 56 9F 00 01
	fgetman.d	2(A5,D7.W),FP6	; F2 35 57 1F 70 02
	fgetman.d	2(A5,D7.L),FP6	; F2 35 57 1F 78 02
	fgetman.d	(0x1234).W,FP7	; F2 38 57 9F 12 34
	fgetman.d	(0x1234).L,FP7	; F2 39 57 9F 00 00 12
	fgetman.d	*0xFFFFFFF0,FP0	; F2 38 54 1F FF F0
	fgetman.d	 0x00010004,FP1	; F2 39 54 9F 00 01 00
	fgetman.d	5(PC),FP3	; F2 3A 55 9F 00 01
	fgetman.d	6(PC,A7.W),FP4	; F2 3B 56 1F F0 02
	fgetman.d	6(PC,A7.L),FP4	; F2 3B 56 1F F8 02
	fgetman.d	(0x1234,A0,D1),FP0	; F2 30 54 1F 11 20 12
	fgetman.d	([2,A1,A2],4),FP1	; F2 31 54 9F A1 22 00
	fgetman.d	([6,A2],D3,8),FP2	; F2 32 55 1F 31 26 00
	fgetman.d	(0x1234,PC,D1),FP3	; F2 3B 55 9F 11 20 12
	fgetman.d	([2,PC,A2],4),FP4	; F2 3B 56 1F A1 22 FF
	fgetman.d	([6,PC],D3,8),FP5	; F2 3B 56 9F 31 26 00

	fgetman.x	FP7		; F2 00 1F 9F
	fgetman.x	FP1,FP2		; F2 00 05 1F

	fgetman.x	(A1),FP2	; F2 11 49 1F
	fgetman.x	(A2)+,FP3	; F2 1A 49 9F
	fgetman.x	-(A3),FP4	; F2 23 4A 1F
	fgetman.x	1(A4),FP5	; F2 2C 4A 9F 00 01
	fgetman.x	2(A5,D7.W),FP6	; F2 35 4B 1F 70 02
	fgetman.x	2(A5,D7.L),FP6	; F2 35 4B 1F 78 02
	fgetman.x	(0x1234).W,FP7	; F2 38 4B 9F 12 34
	fgetman.x	(0x1234).L,FP7	; F2 39 4B 9F 00 00 12
	fgetman.x	*0xFFFFFFF0,FP0	; F2 38 48 1F FF F0
	fgetman.x	 0x00010004,FP1	; F2 39 48 9F 00 01 00
	fgetman.x	5(PC),FP3	; F2 3A 49 9F 00 01
	fgetman.x	6(PC,A7.W),FP4	; F2 3B 4A 1F F0 02
	fgetman.x	6(PC,A7.L),FP4	; F2 3B 4A 1F F8 02
	fgetman.x	(0x1234,A0,D1),FP0	; F2 30 48 1F 11 20 12
	fgetman.x	([2,A1,A2],4),FP1	; F2 31 48 9F A1 22 00
	fgetman.x	([6,A2],D3,8),FP2	; F2 32 49 1F 31 26 00
	fgetman.x	(0x1234,PC,D1),FP3	; F2 3B 49 9F 11 20 12
	fgetman.x	([2,PC,A2],4),FP4	; F2 3B 4A 1F A1 22 FF
	fgetman.x	([6,PC],D3,8),FP5	; F2 3B 4A 9F 31 26 00

	fgetman.p	(A1),FP2	; F2 11 4D 1F
	fgetman.p	(A2)+,FP3	; F2 1A 4D 9F
	fgetman.p	-(A3),FP4	; F2 23 4E 1F
	fgetman.p	1(A4),FP5	; F2 2C 4E 9F 00 01
	fgetman.p	2(A5,D7.W),FP6	; F2 35 4F 1F 70 02
	fgetman.p	2(A5,D7.L),FP6	; F2 35 4F 1F 78 02
	fgetman.p	(0x1234).W,FP7	; F2 38 4F 9F 12 34
	fgetman.p	(0x1234).L,FP7	; F2 39 4F 9F 00 00 12
	fgetman.p	*0xFFFFFFF0,FP0	; F2 38 4C 1F FF F0
	fgetman.p	 0x00010004,FP1	; F2 39 4C 9F 00 01 00
	fgetman.p	5(PC),FP3	; F2 3A 4D 9F 00 01
	fgetman.p	6(PC,A7.W),FP4	; F2 3B 4E 1F F0 02
	fgetman.p	6(PC,A7.L),FP4	; F2 3B 4E 1F F8 02
	fgetman.p	(0x1234,A0,D1),FP0	; F2 30 4C 1F 11 20 12
	fgetman.p	([2,A1,A2],4),FP1	; F2 31 4C 9F A1 22 00
	fgetman.p	([6,A2],D3,8),FP2	; F2 32 4D 1F 31 26 00
	fgetman.p	(0x1234,PC,D1),FP3	; F2 3B 4D 9F 11 20 12
	fgetman.p	([2,PC,A2],4),FP4	; F2 3B 4E 1F A1 22 FF
	fgetman.p	([6,PC],D3,8),FP5	; F2 3B 4E 9F 31 26 00

	fdiv	FP7			; F2 00 1F A0
	fdiv	FP1,FP2			; F2 00 05 20

	fdiv	(A1),FP2		; F2 11 49 20
	fdiv	(A2)+,FP3		; F2 1A 49 A0
	fdiv	-(A3),FP4		; F2 23 4A 20
	fdiv	1(A4),FP5		; F2 2C 4A A0 00 01
	fdiv	2(A5,D7.W),FP6		; F2 35 4B 20 70 02
	fdiv	2(A5,D7.L),FP6		; F2 35 4B 20 78 02
	fdiv	(0x1234).W,FP7		; F2 38 4B A0 12 34
	fdiv	(0x1234).L,FP7		; F2 39 4B A0 00 00 12
	fdiv	*0xFFFFFFF0,FP0		; F2 38 48 20 FF F0
	fdiv	 0x00010004,FP1		; F2 39 48 A0 00 01 00
	fdiv	5(PC),FP3		; F2 3A 49 A0 00 01
	fdiv	6(PC,A7.W),FP4		; F2 3B 4A 20 F0 02
	fdiv	6(PC,A7.L),FP4		; F2 3B 4A 20 F8 02
	fdiv	(0x1234,A0,D1),FP0	; F2 30 48 20 11 20 12
	fdiv	([2,A1,A2],4),FP1	; F2 31 48 A0 A1 22 00
	fdiv	([6,A2],D3,8),FP2	; F2 32 49 20 31 26 00
	fdiv	(0x1234,PC,D1),FP3	; F2 3B 49 A0 11 20 12
	fdiv	([2,PC,A2],4),FP4	; F2 3B 4A 20 A1 22 FF
	fdiv	([6,PC],D3,8),FP5	; F2 3B 4A A0 31 26 00

	fdiv.b	D0,FP0			; F2 00 58 20
	fdiv.b	(A1),FP2		; F2 11 59 20
	fdiv.b	(A2)+,FP3		; F2 1A 59 A0
	fdiv.b	-(A3),FP4		; F2 23 5A 20
	fdiv.b	1(A4),FP5		; F2 2C 5A A0 00 01
	fdiv.b	2(A5,D7.W),FP6		; F2 35 5B 20 70 02
	fdiv.b	2(A5,D7.L),FP6		; F2 35 5B 20 78 02
	fdiv.b	(0x1234).W,FP7		; F2 38 5B A0 12 34
	fdiv.b	(0x1234).L,FP7		; F2 39 5B A0 00 00 12
	fdiv.b	*0xFFFFFFF0,FP0		; F2 38 58 20 FF F0
	fdiv.b	 0x00010004,FP1		; F2 39 58 A0 00 01 00
	fdiv.b	#7,FP2			; F2 3C 59 20 00 07
	fdiv.b	5(PC),FP3		; F2 3A 59 A0 00 01
	fdiv.b	6(PC,A7.W),FP4		; F2 3B 5A 20 F0 02
	fdiv.b	6(PC,A7.L),FP4		; F2 3B 5A 20 F8 02
	fdiv.b	(0x1234,A0,D1),FP0	; F2 30 58 20 11 20 12
	fdiv.b	([2,A1,A2],4),FP1	; F2 31 58 A0 A1 22 00
	fdiv.b	([6,A2],D3,8),FP2	; F2 32 59 20 31 26 00
	fdiv.b	(0x1234,PC,D1),FP3	; F2 3B 59 A0 11 20 12
	fdiv.b	([2,PC,A2],4),FP4	; F2 3B 5A 20 A1 22 FF
	fdiv.b	([6,PC],D3,8),FP5	; F2 3B 5A A0 31 26 00

	fdiv.w	D0,FP0			; F2 00 50 20
	fdiv.w	(A1),FP2		; F2 11 51 20
	fdiv.w	(A2)+,FP3		; F2 1A 51 A0
	fdiv.w	-(A3),FP4		; F2 23 52 20
	fdiv.w	1(A4),FP5		; F2 2C 52 A0 00 01
	fdiv.w	2(A5,D7.W),FP6		; F2 35 53 20 70 02
	fdiv.w	2(A5,D7.L),FP6		; F2 35 53 20 78 02
	fdiv.w	(0x1234).W,FP7		; F2 38 53 A0 12 34
	fdiv.w	(0x1234).L,FP7		; F2 39 53 A0 00 00 12
	fdiv.w	*0xFFFFFFF0,FP0		; F2 38 50 20 FF F0
	fdiv.w	 0x00010004,FP1		; F2 39 50 A0 00 01 00
	fdiv.w	#7,FP2			; F2 3C 51 20 00 07
	fdiv.w	5(PC),FP3		; F2 3A 51 A0 00 01
	fdiv.w	6(PC,A7.W),FP4		; F2 3B 52 20 F0 02
	fdiv.w	6(PC,A7.L),FP4		; F2 3B 52 20 F8 02
	fdiv.w	(0x1234,A0,D1),FP0	; F2 30 50 20 11 20 12
	fdiv.w	([2,A1,A2],4),FP1	; F2 31 50 A0 A1 22 00
	fdiv.w	([6,A2],D3,8),FP2	; F2 32 51 20 31 26 00
	fdiv.w	(0x1234,PC,D1),FP3	; F2 3B 51 A0 11 20 12
	fdiv.w	([2,PC,A2],4),FP4	; F2 3B 52 20 A1 22 FF
	fdiv.w	([6,PC],D3,8),FP5	; F2 3B 52 A0 31 26 00

	fdiv.l	D0,FP0			; F2 00 40 20
	fdiv.l	(A1),FP2		; F2 11 41 20
	fdiv.l	(A2)+,FP3		; F2 1A 41 A0
	fdiv.l	-(A3),FP4		; F2 23 42 20
	fdiv.l	1(A4),FP5		; F2 2C 42 A0 00 01
	fdiv.l	2(A5,D7.W),FP6		; F2 35 43 20 70 02
	fdiv.l	2(A5,D7.L),FP6		; F2 35 43 20 78 02
	fdiv.l	(0x1234).W,FP7		; F2 38 43 A0 12 34
	fdiv.l	(0x1234).L,FP7		; F2 39 43 A0 00 00 12
	fdiv.l	*0xFFFFFFF0,FP0		; F2 38 40 20 FF F0
	fdiv.l	 0x00010004,FP1		; F2 39 40 A0 00 01 00
	fdiv.l	#7,FP2			; F2 3C 41 20 00 00 00
	fdiv.l	5(PC),FP3		; F2 3A 41 A0 00 01
	fdiv.l	6(PC,A7.W),FP4		; F2 3B 42 20 F0 02
	fdiv.l	6(PC,A7.L),FP4		; F2 3B 42 20 F8 02
	fdiv.l	(0x1234,A0,D1),FP0	; F2 30 40 20 11 20 12
	fdiv.l	([2,A1,A2],4),FP1	; F2 31 40 A0 A1 22 00
	fdiv.l	([6,A2],D3,8),FP2	; F2 32 41 20 31 26 00
	fdiv.l	(0x1234,PC,D1),FP3	; F2 3B 41 A0 11 20 12
	fdiv.l	([2,PC,A2],4),FP4	; F2 3B 42 20 A1 22 FF
	fdiv.l	([6,PC],D3,8),FP5	; F2 3B 42 A0 31 26 00

	fdiv.s	D0,FP0			; F2 00 44 20
	fdiv.s	(A1),FP2		; F2 11 45 20
	fdiv.s	(A2)+,FP3		; F2 1A 45 A0
	fdiv.s	-(A3),FP4		; F2 23 46 20
	fdiv.s	1(A4),FP5		; F2 2C 46 A0 00 01
	fdiv.s	2(A5,D7.W),FP6		; F2 35 47 20 70 02
	fdiv.s	2(A5,D7.L),FP6		; F2 35 47 20 78 02
	fdiv.s	(0x1234).W,FP7		; F2 38 47 A0 12 34
	fdiv.s	(0x1234).L,FP7		; F2 39 47 A0 00 00 12
	fdiv.s	*0xFFFFFFF0,FP0		; F2 38 44 20 FF F0
	fdiv.s	 0x00010004,FP1		; F2 39 44 A0 00 01 00
	fdiv.s	#7,FP2			; F2 3C 45 20 40 E0 00
	fdiv.s	5(PC),FP3		; F2 3A 45 A0 00 01
	fdiv.s	6(PC,A7.W),FP4		; F2 3B 46 20 F0 02
	fdiv.s	6(PC,A7.L),FP4		; F2 3B 46 20 F8 02
	fdiv.s	(0x1234,A0,D1),FP0	; F2 30 44 20 11 20 12
	fdiv.s	([2,A1,A2],4),FP1	; F2 31 44 A0 A1 22 00
	fdiv.s	([6,A2],D3,8),FP2	; F2 32 45 20 31 26 00
	fdiv.s	(0x1234,PC,D1),FP3	; F2 3B 45 A0 11 20 12
	fdiv.s	([2,PC,A2],4),FP4	; F2 3B 46 20 A1 22 FF
	fdiv.s	([6,PC],D3,8),FP5	; F2 3B 46 A0 31 26 00

	fdiv.d	(A1),FP2		; F2 11 55 20
	fdiv.d	(A2)+,FP3		; F2 1A 55 A0
	fdiv.d	-(A3),FP4		; F2 23 56 20
	fdiv.d	1(A4),FP5		; F2 2C 56 A0 00 01
	fdiv.d	2(A5,D7.W),FP6		; F2 35 57 20 70 02
	fdiv.d	2(A5,D7.L),FP6		; F2 35 57 20 78 02
	fdiv.d	(0x1234).W,FP7		; F2 38 57 A0 12 34
	fdiv.d	(0x1234).L,FP7		; F2 39 57 A0 00 00 12
	fdiv.d	*0xFFFFFFF0,FP0		; F2 38 54 20 FF F0
	fdiv.d	 0x00010004,FP1		; F2 39 54 A0 00 01 00
	fdiv.d	5(PC),FP3		; F2 3A 55 A0 00 01
	fdiv.d	6(PC,A7.W),FP4		; F2 3B 56 20 F0 02
	fdiv.d	6(PC,A7.L),FP4		; F2 3B 56 20 F8 02
	fdiv.d	(0x1234,A0,D1),FP0	; F2 30 54 20 11 20 12
	fdiv.d	([2,A1,A2],4),FP1	; F2 31 54 A0 A1 22 00
	fdiv.d	([6,A2],D3,8),FP2	; F2 32 55 20 31 26 00
	fdiv.d	(0x1234,PC,D1),FP3	; F2 3B 55 A0 11 20 12
	fdiv.d	([2,PC,A2],4),FP4	; F2 3B 56 20 A1 22 FF
	fdiv.d	([6,PC],D3,8),FP5	; F2 3B 56 A0 31 26 00

	fdiv.x	FP7			; F2 00 1F A0
	fdiv.x	FP1,FP2			; F2 00 05 20

	fdiv.x	(A1),FP2		; F2 11 49 20
	fdiv.x	(A2)+,FP3		; F2 1A 49 A0
	fdiv.x	-(A3),FP4		; F2 23 4A 20
	fdiv.x	1(A4),FP5		; F2 2C 4A A0 00 01
	fdiv.x	2(A5,D7.W),FP6		; F2 35 4B 20 70 02
	fdiv.x	2(A5,D7.L),FP6		; F2 35 4B 20 78 02
	fdiv.x	(0x1234).W,FP7		; F2 38 4B A0 12 34
	fdiv.x	(0x1234).L,FP7		; F2 39 4B A0 00 00 12
	fdiv.x	*0xFFFFFFF0,FP0		; F2 38 48 20 FF F0
	fdiv.x	 0x00010004,FP1		; F2 39 48 A0 00 01 00
	fdiv.x	5(PC),FP3		; F2 3A 49 A0 00 01
	fdiv.x	6(PC,A7.W),FP4		; F2 3B 4A 20 F0 02
	fdiv.x	6(PC,A7.L),FP4		; F2 3B 4A 20 F8 02
	fdiv.x	(0x1234,A0,D1),FP0	; F2 30 48 20 11 20 12
	fdiv.x	([2,A1,A2],4),FP1	; F2 31 48 A0 A1 22 00
	fdiv.x	([6,A2],D3,8),FP2	; F2 32 49 20 31 26 00
	fdiv.x	(0x1234,PC,D1),FP3	; F2 3B 49 A0 11 20 12
	fdiv.x	([2,PC,A2],4),FP4	; F2 3B 4A 20 A1 22 FF
	fdiv.x	([6,PC],D3,8),FP5	; F2 3B 4A A0 31 26 00

	fdiv.p	(A1),FP2		; F2 11 4D 20
	fdiv.p	(A2)+,FP3		; F2 1A 4D A0
	fdiv.p	-(A3),FP4		; F2 23 4E 20
	fdiv.p	1(A4),FP5		; F2 2C 4E A0 00 01
	fdiv.p	2(A5,D7.W),FP6		; F2 35 4F 20 70 02
	fdiv.p	2(A5,D7.L),FP6		; F2 35 4F 20 78 02
	fdiv.p	(0x1234).W,FP7		; F2 38 4F A0 12 34
	fdiv.p	(0x1234).L,FP7		; F2 39 4F A0 00 00 12
	fdiv.p	*0xFFFFFFF0,FP0		; F2 38 4C 20 FF F0
	fdiv.p	 0x00010004,FP1		; F2 39 4C A0 00 01 00
	fdiv.p	5(PC),FP3		; F2 3A 4D A0 00 01
	fdiv.p	6(PC,A7.W),FP4		; F2 3B 4E 20 F0 02
	fdiv.p	6(PC,A7.L),FP4		; F2 3B 4E 20 F8 02
	fdiv.p	(0x1234,A0,D1),FP0	; F2 30 4C 20 11 20 12
	fdiv.p	([2,A1,A2],4),FP1	; F2 31 4C A0 A1 22 00
	fdiv.p	([6,A2],D3,8),FP2	; F2 32 4D 20 31 26 00
	fdiv.p	(0x1234,PC,D1),FP3	; F2 3B 4D A0 11 20 12
	fdiv.p	([2,PC,A2],4),FP4	; F2 3B 4E 20 A1 22 FF
	fdiv.p	([6,PC],D3,8),FP5	; F2 3B 4E A0 31 26 00

	.sbttl	Type F_TYP2 Instructions: FMOD, ...

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  F_TYP2:						*
	;*	FMOD, FADD, FMUL, FSGLDIV,			*
	;*	FREM, FSCALE, FSGLMUL, FSUB,  FCMP		*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	fmod	FP1,FP2			; F2 00 05 21

	fmod	(A1),FP2		; F2 11 49 21
	fmod	(A2)+,FP3		; F2 1A 49 A1
	fmod	-(A3),FP4		; F2 23 4A 21
	fmod	1(A4),FP5		; F2 2C 4A A1 00 01
	fmod	2(A5,D7.W),FP6		; F2 35 4B 21 70 02
	fmod	2(A5,D7.L),FP6		; F2 35 4B 21 78 02
	fmod	(0x1234).W,FP7		; F2 38 4B A1 12 34
	fmod	(0x1234).L,FP7		; F2 39 4B A1 00 00 12
	fmod	*0xFFFFFFF0,FP0		; F2 38 48 21 FF F0
	fmod	 0x00010004,FP1		; F2 39 48 A1 00 01 00
	fmod	5(PC),FP3		; F2 3A 49 A1 00 01
	fmod	6(PC,A7.W),FP4		; F2 3B 4A 21 F0 02
	fmod	6(PC,A7.L),FP4		; F2 3B 4A 21 F8 02
	fmod	(0x1234,A0,D1),FP0	; F2 30 48 21 11 20 12
	fmod	([2,A1,A2],4),FP1	; F2 31 48 A1 A1 22 00
	fmod	([6,A2],D3,8),FP2	; F2 32 49 21 31 26 00
	fmod	(0x1234,PC,D1),FP3	; F2 3B 49 A1 11 20 12
	fmod	([2,PC,A2],4),FP4	; F2 3B 4A 21 A1 22 FF
	fmod	([6,PC],D3,8),FP5	; F2 3B 4A A1 31 26 00

	fmod.b	D0,FP0			; F2 00 58 21
	fmod.b	(A1),FP2		; F2 11 59 21
	fmod.b	(A2)+,FP3		; F2 1A 59 A1
	fmod.b	-(A3),FP4		; F2 23 5A 21
	fmod.b	1(A4),FP5		; F2 2C 5A A1 00 01
	fmod.b	2(A5,D7.W),FP6		; F2 35 5B 21 70 02
	fmod.b	2(A5,D7.L),FP6		; F2 35 5B 21 78 02
	fmod.b	(0x1234).W,FP7		; F2 38 5B A1 12 34
	fmod.b	(0x1234).L,FP7		; F2 39 5B A1 00 00 12
	fmod.b	*0xFFFFFFF0,FP0		; F2 38 58 21 FF F0
	fmod.b	 0x00010004,FP1		; F2 39 58 A1 00 01 00
	fmod.b	#7,FP2			; F2 3C 59 21 00 07
	fmod.b	5(PC),FP3		; F2 3A 59 A1 00 01
	fmod.b	6(PC,A7.W),FP4		; F2 3B 5A 21 F0 02
	fmod.b	6(PC,A7.L),FP4		; F2 3B 5A 21 F8 02
	fmod.b	(0x1234,A0,D1),FP0	; F2 30 58 21 11 20 12
	fmod.b	([2,A1,A2],4),FP1	; F2 31 58 A1 A1 22 00
	fmod.b	([6,A2],D3,8),FP2	; F2 32 59 21 31 26 00
	fmod.b	(0x1234,PC,D1),FP3	; F2 3B 59 A1 11 20 12
	fmod.b	([2,PC,A2],4),FP4	; F2 3B 5A 21 A1 22 FF
	fmod.b	([6,PC],D3,8),FP5	; F2 3B 5A A1 31 26 00

	fmod.w	D0,FP0			; F2 00 50 21
	fmod.w	(A1),FP2		; F2 11 51 21
	fmod.w	(A2)+,FP3		; F2 1A 51 A1
	fmod.w	-(A3),FP4		; F2 23 52 21
	fmod.w	1(A4),FP5		; F2 2C 52 A1 00 01
	fmod.w	2(A5,D7.W),FP6		; F2 35 53 21 70 02
	fmod.w	2(A5,D7.L),FP6		; F2 35 53 21 78 02
	fmod.w	(0x1234).W,FP7		; F2 38 53 A1 12 34
	fmod.w	(0x1234).L,FP7		; F2 39 53 A1 00 00 12
	fmod.w	*0xFFFFFFF0,FP0		; F2 38 50 21 FF F0
	fmod.w	 0x00010004,FP1		; F2 39 50 A1 00 01 00
	fmod.w	#7,FP2			; F2 3C 51 21 00 07
	fmod.w	5(PC),FP3		; F2 3A 51 A1 00 01
	fmod.w	6(PC,A7.W),FP4		; F2 3B 52 21 F0 02
	fmod.w	6(PC,A7.L),FP4		; F2 3B 52 21 F8 02
	fmod.w	(0x1234,A0,D1),FP0	; F2 30 50 21 11 20 12
	fmod.w	([2,A1,A2],4),FP1	; F2 31 50 A1 A1 22 00
	fmod.w	([6,A2],D3,8),FP2	; F2 32 51 21 31 26 00
	fmod.w	(0x1234,PC,D1),FP3	; F2 3B 51 A1 11 20 12
	fmod.w	([2,PC,A2],4),FP4	; F2 3B 52 21 A1 22 FF
	fmod.w	([6,PC],D3,8),FP5	; F2 3B 52 A1 31 26 00

	fmod.l	D0,FP0			; F2 00 40 21
	fmod.l	(A1),FP2		; F2 11 41 21
	fmod.l	(A2)+,FP3		; F2 1A 41 A1
	fmod.l	-(A3),FP4		; F2 23 42 21
	fmod.l	1(A4),FP5		; F2 2C 42 A1 00 01
	fmod.l	2(A5,D7.W),FP6		; F2 35 43 21 70 02
	fmod.l	2(A5,D7.L),FP6		; F2 35 43 21 78 02
	fmod.l	(0x1234).W,FP7		; F2 38 43 A1 12 34
	fmod.l	(0x1234).L,FP7		; F2 39 43 A1 00 00 12
	fmod.l	*0xFFFFFFF0,FP0		; F2 38 40 21 FF F0
	fmod.l	 0x00010004,FP1		; F2 39 40 A1 00 01 00
	fmod.l	#7,FP2			; F2 3C 41 21 00 00 00
	fmod.l	5(PC),FP3		; F2 3A 41 A1 00 01
	fmod.l	6(PC,A7.W),FP4		; F2 3B 42 21 F0 02
	fmod.l	6(PC,A7.L),FP4		; F2 3B 42 21 F8 02
	fmod.l	(0x1234,A0,D1),FP0	; F2 30 40 21 11 20 12
	fmod.l	([2,A1,A2],4),FP1	; F2 31 40 A1 A1 22 00
	fmod.l	([6,A2],D3,8),FP2	; F2 32 41 21 31 26 00
	fmod.l	(0x1234,PC,D1),FP3	; F2 3B 41 A1 11 20 12
	fmod.l	([2,PC,A2],4),FP4	; F2 3B 42 21 A1 22 FF
	fmod.l	([6,PC],D3,8),FP5	; F2 3B 42 A1 31 26 00

	fmod.s	D0,FP0			; F2 00 44 21
	fmod.s	(A1),FP2		; F2 11 45 21
	fmod.s	(A2)+,FP3		; F2 1A 45 A1
	fmod.s	-(A3),FP4		; F2 23 46 21
	fmod.s	1(A4),FP5		; F2 2C 46 A1 00 01
	fmod.s	2(A5,D7.W),FP6		; F2 35 47 21 70 02
	fmod.s	2(A5,D7.L),FP6		; F2 35 47 21 78 02
	fmod.s	(0x1234).W,FP7		; F2 38 47 A1 12 34
	fmod.s	(0x1234).L,FP7		; F2 39 47 A1 00 00 12
	fmod.s	*0xFFFFFFF0,FP0		; F2 38 44 21 FF F0
	fmod.s	 0x00010004,FP1		; F2 39 44 A1 00 01 00
	fmod.s	#7,FP2			; F2 3C 45 21 40 E0 00
	fmod.s	5(PC),FP3		; F2 3A 45 A1 00 01
	fmod.s	6(PC,A7.W),FP4		; F2 3B 46 21 F0 02
	fmod.s	6(PC,A7.L),FP4		; F2 3B 46 21 F8 02
	fmod.s	(0x1234,A0,D1),FP0	; F2 30 44 21 11 20 12
	fmod.s	([2,A1,A2],4),FP1	; F2 31 44 A1 A1 22 00
	fmod.s	([6,A2],D3,8),FP2	; F2 32 45 21 31 26 00
	fmod.s	(0x1234,PC,D1),FP3	; F2 3B 45 A1 11 20 12
	fmod.s	([2,PC,A2],4),FP4	; F2 3B 46 21 A1 22 FF
	fmod.s	([6,PC],D3,8),FP5	; F2 3B 46 A1 31 26 00

	fmod.d	(A1),FP2		; F2 11 55 21
	fmod.d	(A2)+,FP3		; F2 1A 55 A1
	fmod.d	-(A3),FP4		; F2 23 56 21
	fmod.d	1(A4),FP5		; F2 2C 56 A1 00 01
	fmod.d	2(A5,D7.W),FP6		; F2 35 57 21 70 02
	fmod.d	2(A5,D7.L),FP6		; F2 35 57 21 78 02
	fmod.d	(0x1234).W,FP7		; F2 38 57 A1 12 34
	fmod.d	(0x1234).L,FP7		; F2 39 57 A1 00 00 12
	fmod.d	*0xFFFFFFF0,FP0		; F2 38 54 21 FF F0
	fmod.d	 0x00010004,FP1		; F2 39 54 A1 00 01 00
	fmod.d	5(PC),FP3		; F2 3A 55 A1 00 01
	fmod.d	6(PC,A7.W),FP4		; F2 3B 56 21 F0 02
	fmod.d	6(PC,A7.L),FP4		; F2 3B 56 21 F8 02
	fmod.d	(0x1234,A0,D1),FP0	; F2 30 54 21 11 20 12
	fmod.d	([2,A1,A2],4),FP1	; F2 31 54 A1 A1 22 00
	fmod.d	([6,A2],D3,8),FP2	; F2 32 55 21 31 26 00
	fmod.d	(0x1234,PC,D1),FP3	; F2 3B 55 A1 11 20 12
	fmod.d	([2,PC,A2],4),FP4	; F2 3B 56 21 A1 22 FF
	fmod.d	([6,PC],D3,8),FP5	; F2 3B 56 A1 31 26 00

	fmod.x	FP1,FP2			; F2 00 05 21

	fmod.x	(A1),FP2		; F2 11 49 21
	fmod.x	(A2)+,FP3		; F2 1A 49 A1
	fmod.x	-(A3),FP4		; F2 23 4A 21
	fmod.x	1(A4),FP5		; F2 2C 4A A1 00 01
	fmod.x	2(A5,D7.W),FP6		; F2 35 4B 21 70 02
	fmod.x	2(A5,D7.L),FP6		; F2 35 4B 21 78 02
	fmod.x	(0x1234).W,FP7		; F2 38 4B A1 12 34
	fmod.x	(0x1234).L,FP7		; F2 39 4B A1 00 00 12
	fmod.x	*0xFFFFFFF0,FP0		; F2 38 48 21 FF F0
	fmod.x	 0x00010004,FP1		; F2 39 48 A1 00 01 00
	fmod.x	5(PC),FP3		; F2 3A 49 A1 00 01
	fmod.x	6(PC,A7.W),FP4		; F2 3B 4A 21 F0 02
	fmod.x	6(PC,A7.L),FP4		; F2 3B 4A 21 F8 02
	fmod.x	(0x1234,A0,D1),FP0	; F2 30 48 21 11 20 12
	fmod.x	([2,A1,A2],4),FP1	; F2 31 48 A1 A1 22 00
	fmod.x	([6,A2],D3,8),FP2	; F2 32 49 21 31 26 00
	fmod.x	(0x1234,PC,D1),FP3	; F2 3B 49 A1 11 20 12
	fmod.x	([2,PC,A2],4),FP4	; F2 3B 4A 21 A1 22 FF
	fmod.x	([6,PC],D3,8),FP5	; F2 3B 4A A1 31 26 00

	fmod.p	(A1),FP2		; F2 11 4D 21
	fmod.p	(A2)+,FP3		; F2 1A 4D A1
	fmod.p	-(A3),FP4		; F2 23 4E 21
	fmod.p	1(A4),FP5		; F2 2C 4E A1 00 01
	fmod.p	2(A5,D7.W),FP6		; F2 35 4F 21 70 02
	fmod.p	2(A5,D7.L),FP6		; F2 35 4F 21 78 02
	fmod.p	(0x1234).W,FP7		; F2 38 4F A1 12 34
	fmod.p	(0x1234).L,FP7		; F2 39 4F A1 00 00 12
	fmod.p	*0xFFFFFFF0,FP0		; F2 38 4C 21 FF F0
	fmod.p	 0x00010004,FP1		; F2 39 4C A1 00 01 00
	fmod.p	5(PC),FP3		; F2 3A 4D A1 00 01
	fmod.p	6(PC,A7.W),FP4		; F2 3B 4E 21 F0 02
	fmod.p	6(PC,A7.L),FP4		; F2 3B 4E 21 F8 02
	fmod.p	(0x1234,A0,D1),FP0	; F2 30 4C 21 11 20 12
	fmod.p	([2,A1,A2],4),FP1	; F2 31 4C A1 A1 22 00
	fmod.p	([6,A2],D3,8),FP2	; F2 32 4D 21 31 26 00
	fmod.p	(0x1234,PC,D1),FP3	; F2 3B 4D A1 11 20 12
	fmod.p	([2,PC,A2],4),FP4	; F2 3B 4E 21 A1 22 FF
	fmod.p	([6,PC],D3,8),FP5	; F2 3B 4E A1 31 26 00

	fadd	FP1,FP2			; F2 00 05 22

	fadd	(A1),FP2		; F2 11 49 22
	fadd	(A2)+,FP3		; F2 1A 49 A2
	fadd	-(A3),FP4		; F2 23 4A 22
	fadd	1(A4),FP5		; F2 2C 4A A2 00 01
	fadd	2(A5,D7.W),FP6		; F2 35 4B 22 70 02
	fadd	2(A5,D7.L),FP6		; F2 35 4B 22 78 02
	fadd	(0x1234).W,FP7		; F2 38 4B A2 12 34
	fadd	(0x1234).L,FP7		; F2 39 4B A2 00 00 12
	fadd	*0xFFFFFFF0,FP0		; F2 38 48 22 FF F0
	fadd	 0x00010004,FP1		; F2 39 48 A2 00 01 00
	fadd	5(PC),FP3		; F2 3A 49 A2 00 01
	fadd	6(PC,A7.W),FP4		; F2 3B 4A 22 F0 02
	fadd	6(PC,A7.L),FP4		; F2 3B 4A 22 F8 02
	fadd	(0x1234,A0,D1),FP0	; F2 30 48 22 11 20 12
	fadd	([2,A1,A2],4),FP1	; F2 31 48 A2 A1 22 00
	fadd	([6,A2],D3,8),FP2	; F2 32 49 22 31 26 00
	fadd	(0x1234,PC,D1),FP3	; F2 3B 49 A2 11 20 12
	fadd	([2,PC,A2],4),FP4	; F2 3B 4A 22 A1 22 FF
	fadd	([6,PC],D3,8),FP5	; F2 3B 4A A2 31 26 00

	fadd.b	D0,FP0			; F2 00 58 22
	fadd.b	(A1),FP2		; F2 11 59 22
	fadd.b	(A2)+,FP3		; F2 1A 59 A2
	fadd.b	-(A3),FP4		; F2 23 5A 22
	fadd.b	1(A4),FP5		; F2 2C 5A A2 00 01
	fadd.b	2(A5,D7.W),FP6		; F2 35 5B 22 70 02
	fadd.b	2(A5,D7.L),FP6		; F2 35 5B 22 78 02
	fadd.b	(0x1234).W,FP7		; F2 38 5B A2 12 34
	fadd.b	(0x1234).L,FP7		; F2 39 5B A2 00 00 12
	fadd.b	*0xFFFFFFF0,FP0		; F2 38 58 22 FF F0
	fadd.b	 0x00010004,FP1		; F2 39 58 A2 00 01 00
	fadd.b	#7,FP2			; F2 3C 59 22 00 07
	fadd.b	5(PC),FP3		; F2 3A 59 A2 00 01
	fadd.b	6(PC,A7.W),FP4		; F2 3B 5A 22 F0 02
	fadd.b	6(PC,A7.L),FP4		; F2 3B 5A 22 F8 02
	fadd.b	(0x1234,A0,D1),FP0	; F2 30 58 22 11 20 12
	fadd.b	([2,A1,A2],4),FP1	; F2 31 58 A2 A1 22 00
	fadd.b	([6,A2],D3,8),FP2	; F2 32 59 22 31 26 00
	fadd.b	(0x1234,PC,D1),FP3	; F2 3B 59 A2 11 20 12
	fadd.b	([2,PC,A2],4),FP4	; F2 3B 5A 22 A1 22 FF
	fadd.b	([6,PC],D3,8),FP5	; F2 3B 5A A2 31 26 00

	fadd.w	D0,FP0			; F2 00 50 22
	fadd.w	(A1),FP2		; F2 11 51 22
	fadd.w	(A2)+,FP3		; F2 1A 51 A2
	fadd.w	-(A3),FP4		; F2 23 52 22
	fadd.w	1(A4),FP5		; F2 2C 52 A2 00 01
	fadd.w	2(A5,D7.W),FP6		; F2 35 53 22 70 02
	fadd.w	2(A5,D7.L),FP6		; F2 35 53 22 78 02
	fadd.w	(0x1234).W,FP7		; F2 38 53 A2 12 34
	fadd.w	(0x1234).L,FP7		; F2 39 53 A2 00 00 12
	fadd.w	*0xFFFFFFF0,FP0		; F2 38 50 22 FF F0
	fadd.w	 0x00010004,FP1		; F2 39 50 A2 00 01 00
	fadd.w	#7,FP2			; F2 3C 51 22 00 07
	fadd.w	5(PC),FP3		; F2 3A 51 A2 00 01
	fadd.w	6(PC,A7.W),FP4		; F2 3B 52 22 F0 02
	fadd.w	6(PC,A7.L),FP4		; F2 3B 52 22 F8 02
	fadd.w	(0x1234,A0,D1),FP0	; F2 30 50 22 11 20 12
	fadd.w	([2,A1,A2],4),FP1	; F2 31 50 A2 A1 22 00
	fadd.w	([6,A2],D3,8),FP2	; F2 32 51 22 31 26 00
	fadd.w	(0x1234,PC,D1),FP3	; F2 3B 51 A2 11 20 12
	fadd.w	([2,PC,A2],4),FP4	; F2 3B 52 22 A1 22 FF
	fadd.w	([6,PC],D3,8),FP5	; F2 3B 52 A2 31 26 00

	fadd.l	D0,FP0			; F2 00 40 22
	fadd.l	(A1),FP2		; F2 11 41 22
	fadd.l	(A2)+,FP3		; F2 1A 41 A2
	fadd.l	-(A3),FP4		; F2 23 42 22
	fadd.l	1(A4),FP5		; F2 2C 42 A2 00 01
	fadd.l	2(A5,D7.W),FP6		; F2 35 43 22 70 02
	fadd.l	2(A5,D7.L),FP6		; F2 35 43 22 78 02
	fadd.l	(0x1234).W,FP7		; F2 38 43 A2 12 34
	fadd.l	(0x1234).L,FP7		; F2 39 43 A2 00 00 12
	fadd.l	*0xFFFFFFF0,FP0		; F2 38 40 22 FF F0
	fadd.l	 0x00010004,FP1		; F2 39 40 A2 00 01 00
	fadd.l	#7,FP2			; F2 3C 41 22 00 00 00
	fadd.l	5(PC),FP3		; F2 3A 41 A2 00 01
	fadd.l	6(PC,A7.W),FP4		; F2 3B 42 22 F0 02
	fadd.l	6(PC,A7.L),FP4		; F2 3B 42 22 F8 02
	fadd.l	(0x1234,A0,D1),FP0	; F2 30 40 22 11 20 12
	fadd.l	([2,A1,A2],4),FP1	; F2 31 40 A2 A1 22 00
	fadd.l	([6,A2],D3,8),FP2	; F2 32 41 22 31 26 00
	fadd.l	(0x1234,PC,D1),FP3	; F2 3B 41 A2 11 20 12
	fadd.l	([2,PC,A2],4),FP4	; F2 3B 42 22 A1 22 FF
	fadd.l	([6,PC],D3,8),FP5	; F2 3B 42 A2 31 26 00

	fadd.s	D0,FP0			; F2 00 44 22
	fadd.s	(A1),FP2		; F2 11 45 22
	fadd.s	(A2)+,FP3		; F2 1A 45 A2
	fadd.s	-(A3),FP4		; F2 23 46 22
	fadd.s	1(A4),FP5		; F2 2C 46 A2 00 01
	fadd.s	2(A5,D7.W),FP6		; F2 35 47 22 70 02
	fadd.s	2(A5,D7.L),FP6		; F2 35 47 22 78 02
	fadd.s	(0x1234).W,FP7		; F2 38 47 A2 12 34
	fadd.s	(0x1234).L,FP7		; F2 39 47 A2 00 00 12
	fadd.s	*0xFFFFFFF0,FP0		; F2 38 44 22 FF F0
	fadd.s	 0x00010004,FP1		; F2 39 44 A2 00 01 00
	fadd.s	#7,FP2			; F2 3C 45 22 40 E0 00
	fadd.s	5(PC),FP3		; F2 3A 45 A2 00 01
	fadd.s	6(PC,A7.W),FP4		; F2 3B 46 22 F0 02
	fadd.s	6(PC,A7.L),FP4		; F2 3B 46 22 F8 02
	fadd.s	(0x1234,A0,D1),FP0	; F2 30 44 22 11 20 12
	fadd.s	([2,A1,A2],4),FP1	; F2 31 44 A2 A1 22 00
	fadd.s	([6,A2],D3,8),FP2	; F2 32 45 22 31 26 00
	fadd.s	(0x1234,PC,D1),FP3	; F2 3B 45 A2 11 20 12
	fadd.s	([2,PC,A2],4),FP4	; F2 3B 46 22 A1 22 FF
	fadd.s	([6,PC],D3,8),FP5	; F2 3B 46 A2 31 26 00

	fadd.d	(A1),FP2		; F2 11 55 22
	fadd.d	(A2)+,FP3		; F2 1A 55 A2
	fadd.d	-(A3),FP4		; F2 23 56 22
	fadd.d	1(A4),FP5		; F2 2C 56 A2 00 01
	fadd.d	2(A5,D7.W),FP6		; F2 35 57 22 70 02
	fadd.d	2(A5,D7.L),FP6		; F2 35 57 22 78 02
	fadd.d	(0x1234).W,FP7		; F2 38 57 A2 12 34
	fadd.d	(0x1234).L,FP7		; F2 39 57 A2 00 00 12
	fadd.d	*0xFFFFFFF0,FP0		; F2 38 54 22 FF F0
	fadd.d	 0x00010004,FP1		; F2 39 54 A2 00 01 00
	fadd.d	5(PC),FP3		; F2 3A 55 A2 00 01
	fadd.d	6(PC,A7.W),FP4		; F2 3B 56 22 F0 02
	fadd.d	6(PC,A7.L),FP4		; F2 3B 56 22 F8 02
	fadd.d	(0x1234,A0,D1),FP0	; F2 30 54 22 11 20 12
	fadd.d	([2,A1,A2],4),FP1	; F2 31 54 A2 A1 22 00
	fadd.d	([6,A2],D3,8),FP2	; F2 32 55 22 31 26 00
	fadd.d	(0x1234,PC,D1),FP3	; F2 3B 55 A2 11 20 12
	fadd.d	([2,PC,A2],4),FP4	; F2 3B 56 22 A1 22 FF
	fadd.d	([6,PC],D3,8),FP5	; F2 3B 56 A2 31 26 00

	fadd.x	FP1,FP2			; F2 00 05 22

	fadd.x	(A1),FP2		; F2 11 49 22
	fadd.x	(A2)+,FP3		; F2 1A 49 A2
	fadd.x	-(A3),FP4		; F2 23 4A 22
	fadd.x	1(A4),FP5		; F2 2C 4A A2 00 01
	fadd.x	2(A5,D7.W),FP6		; F2 35 4B 22 70 02
	fadd.x	2(A5,D7.L),FP6		; F2 35 4B 22 78 02
	fadd.x	(0x1234).W,FP7		; F2 38 4B A2 12 34
	fadd.x	(0x1234).L,FP7		; F2 39 4B A2 00 00 12
	fadd.x	*0xFFFFFFF0,FP0		; F2 38 48 22 FF F0
	fadd.x	 0x00010004,FP1		; F2 39 48 A2 00 01 00
	fadd.x	5(PC),FP3		; F2 3A 49 A2 00 01
	fadd.x	6(PC,A7.W),FP4		; F2 3B 4A 22 F0 02
	fadd.x	6(PC,A7.L),FP4		; F2 3B 4A 22 F8 02
	fadd.x	(0x1234,A0,D1),FP0	; F2 30 48 22 11 20 12
	fadd.x	([2,A1,A2],4),FP1	; F2 31 48 A2 A1 22 00
	fadd.x	([6,A2],D3,8),FP2	; F2 32 49 22 31 26 00
	fadd.x	(0x1234,PC,D1),FP3	; F2 3B 49 A2 11 20 12
	fadd.x	([2,PC,A2],4),FP4	; F2 3B 4A 22 A1 22 FF
	fadd.x	([6,PC],D3,8),FP5	; F2 3B 4A A2 31 26 00

	fadd.p	(A1),FP2		; F2 11 4D 22
	fadd.p	(A2)+,FP3		; F2 1A 4D A2
	fadd.p	-(A3),FP4		; F2 23 4E 22
	fadd.p	1(A4),FP5		; F2 2C 4E A2 00 01
	fadd.p	2(A5,D7.W),FP6		; F2 35 4F 22 70 02
	fadd.p	2(A5,D7.L),FP6		; F2 35 4F 22 78 02
	fadd.p	(0x1234).W,FP7		; F2 38 4F A2 12 34
	fadd.p	(0x1234).L,FP7		; F2 39 4F A2 00 00 12
	fadd.p	*0xFFFFFFF0,FP0		; F2 38 4C 22 FF F0
	fadd.p	 0x00010004,FP1		; F2 39 4C A2 00 01 00
	fadd.p	5(PC),FP3		; F2 3A 4D A2 00 01
	fadd.p	6(PC,A7.W),FP4		; F2 3B 4E 22 F0 02
	fadd.p	6(PC,A7.L),FP4		; F2 3B 4E 22 F8 02
	fadd.p	(0x1234,A0,D1),FP0	; F2 30 4C 22 11 20 12
	fadd.p	([2,A1,A2],4),FP1	; F2 31 4C A2 A1 22 00
	fadd.p	([6,A2],D3,8),FP2	; F2 32 4D 22 31 26 00
	fadd.p	(0x1234,PC,D1),FP3	; F2 3B 4D A2 11 20 12
	fadd.p	([2,PC,A2],4),FP4	; F2 3B 4E 22 A1 22 FF
	fadd.p	([6,PC],D3,8),FP5	; F2 3B 4E A2 31 26 00

	fmul	FP1,FP2			; F2 00 05 23

	fmul	(A1),FP2		; F2 11 49 23
	fmul	(A2)+,FP3		; F2 1A 49 A3
	fmul	-(A3),FP4		; F2 23 4A 23
	fmul	1(A4),FP5		; F2 2C 4A A3 00 01
	fmul	2(A5,D7.W),FP6		; F2 35 4B 23 70 02
	fmul	2(A5,D7.L),FP6		; F2 35 4B 23 78 02
	fmul	(0x1234).W,FP7		; F2 38 4B A3 12 34
	fmul	(0x1234).L,FP7		; F2 39 4B A3 00 00 12
	fmul	*0xFFFFFFF0,FP0		; F2 38 48 23 FF F0
	fmul	 0x00010004,FP1		; F2 39 48 A3 00 01 00
	fmul	5(PC),FP3		; F2 3A 49 A3 00 01
	fmul	6(PC,A7.W),FP4		; F2 3B 4A 23 F0 02
	fmul	6(PC,A7.L),FP4		; F2 3B 4A 23 F8 02
	fmul	(0x1234,A0,D1),FP0	; F2 30 48 23 11 20 12
	fmul	([2,A1,A2],4),FP1	; F2 31 48 A3 A1 22 00
	fmul	([6,A2],D3,8),FP2	; F2 32 49 23 31 26 00
	fmul	(0x1234,PC,D1),FP3	; F2 3B 49 A3 11 20 12
	fmul	([2,PC,A2],4),FP4	; F2 3B 4A 23 A1 22 FF
	fmul	([6,PC],D3,8),FP5	; F2 3B 4A A3 31 26 00

	fmul.b	D0,FP0			; F2 00 58 23
	fmul.b	(A1),FP2		; F2 11 59 23
	fmul.b	(A2)+,FP3		; F2 1A 59 A3
	fmul.b	-(A3),FP4		; F2 23 5A 23
	fmul.b	1(A4),FP5		; F2 2C 5A A3 00 01
	fmul.b	2(A5,D7.W),FP6		; F2 35 5B 23 70 02
	fmul.b	2(A5,D7.L),FP6		; F2 35 5B 23 78 02
	fmul.b	(0x1234).W,FP7		; F2 38 5B A3 12 34
	fmul.b	(0x1234).L,FP7		; F2 39 5B A3 00 00 12
	fmul.b	*0xFFFFFFF0,FP0		; F2 38 58 23 FF F0
	fmul.b	 0x00010004,FP1		; F2 39 58 A3 00 01 00
	fmul.b	#7,FP2			; F2 3C 59 23 00 07
	fmul.b	5(PC),FP3		; F2 3A 59 A3 00 01
	fmul.b	6(PC,A7.W),FP4		; F2 3B 5A 23 F0 02
	fmul.b	6(PC,A7.L),FP4		; F2 3B 5A 23 F8 02
	fmul.b	(0x1234,A0,D1),FP0	; F2 30 58 23 11 20 12
	fmul.b	([2,A1,A2],4),FP1	; F2 31 58 A3 A1 22 00
	fmul.b	([6,A2],D3,8),FP2	; F2 32 59 23 31 26 00
	fmul.b	(0x1234,PC,D1),FP3	; F2 3B 59 A3 11 20 12
	fmul.b	([2,PC,A2],4),FP4	; F2 3B 5A 23 A1 22 FF
	fmul.b	([6,PC],D3,8),FP5	; F2 3B 5A A3 31 26 00

	fmul.w	D0,FP0			; F2 00 50 23
	fmul.w	(A1),FP2		; F2 11 51 23
	fmul.w	(A2)+,FP3		; F2 1A 51 A3
	fmul.w	-(A3),FP4		; F2 23 52 23
	fmul.w	1(A4),FP5		; F2 2C 52 A3 00 01
	fmul.w	2(A5,D7.W),FP6		; F2 35 53 23 70 02
	fmul.w	2(A5,D7.L),FP6		; F2 35 53 23 78 02
	fmul.w	(0x1234).W,FP7		; F2 38 53 A3 12 34
	fmul.w	(0x1234).L,FP7		; F2 39 53 A3 00 00 12
	fmul.w	*0xFFFFFFF0,FP0		; F2 38 50 23 FF F0
	fmul.w	 0x00010004,FP1		; F2 39 50 A3 00 01 00
	fmul.w	#7,FP2			; F2 3C 51 23 00 07
	fmul.w	5(PC),FP3		; F2 3A 51 A3 00 01
	fmul.w	6(PC,A7.W),FP4		; F2 3B 52 23 F0 02
	fmul.w	6(PC,A7.L),FP4		; F2 3B 52 23 F8 02
	fmul.w	(0x1234,A0,D1),FP0	; F2 30 50 23 11 20 12
	fmul.w	([2,A1,A2],4),FP1	; F2 31 50 A3 A1 22 00
	fmul.w	([6,A2],D3,8),FP2	; F2 32 51 23 31 26 00
	fmul.w	(0x1234,PC,D1),FP3	; F2 3B 51 A3 11 20 12
	fmul.w	([2,PC,A2],4),FP4	; F2 3B 52 23 A1 22 FF
	fmul.w	([6,PC],D3,8),FP5	; F2 3B 52 A3 31 26 00

	fmul.l	D0,FP0			; F2 00 40 23
	fmul.l	(A1),FP2		; F2 11 41 23
	fmul.l	(A2)+,FP3		; F2 1A 41 A3
	fmul.l	-(A3),FP4		; F2 23 42 23
	fmul.l	1(A4),FP5		; F2 2C 42 A3 00 01
	fmul.l	2(A5,D7.W),FP6		; F2 35 43 23 70 02
	fmul.l	2(A5,D7.L),FP6		; F2 35 43 23 78 02
	fmul.l	(0x1234).W,FP7		; F2 38 43 A3 12 34
	fmul.l	(0x1234).L,FP7		; F2 39 43 A3 00 00 12
	fmul.l	*0xFFFFFFF0,FP0		; F2 38 40 23 FF F0
	fmul.l	 0x00010004,FP1		; F2 39 40 A3 00 01 00
	fmul.l	#7,FP2			; F2 3C 41 23 00 00 00
	fmul.l	5(PC),FP3		; F2 3A 41 A3 00 01
	fmul.l	6(PC,A7.W),FP4		; F2 3B 42 23 F0 02
	fmul.l	6(PC,A7.L),FP4		; F2 3B 42 23 F8 02
	fmul.l	(0x1234,A0,D1),FP0	; F2 30 40 23 11 20 12
	fmul.l	([2,A1,A2],4),FP1	; F2 31 40 A3 A1 22 00
	fmul.l	([6,A2],D3,8),FP2	; F2 32 41 23 31 26 00
	fmul.l	(0x1234,PC,D1),FP3	; F2 3B 41 A3 11 20 12
	fmul.l	([2,PC,A2],4),FP4	; F2 3B 42 23 A1 22 FF
	fmul.l	([6,PC],D3,8),FP5	; F2 3B 42 A3 31 26 00

	fmul.s	D0,FP0			; F2 00 44 23
	fmul.s	(A1),FP2		; F2 11 45 23
	fmul.s	(A2)+,FP3		; F2 1A 45 A3
	fmul.s	-(A3),FP4		; F2 23 46 23
	fmul.s	1(A4),FP5		; F2 2C 46 A3 00 01
	fmul.s	2(A5,D7.W),FP6		; F2 35 47 23 70 02
	fmul.s	2(A5,D7.L),FP6		; F2 35 47 23 78 02
	fmul.s	(0x1234).W,FP7		; F2 38 47 A3 12 34
	fmul.s	(0x1234).L,FP7		; F2 39 47 A3 00 00 12
	fmul.s	*0xFFFFFFF0,FP0		; F2 38 44 23 FF F0
	fmul.s	 0x00010004,FP1		; F2 39 44 A3 00 01 00
	fmul.s	#7,FP2			; F2 3C 45 23 40 E0 00
	fmul.s	5(PC),FP3		; F2 3A 45 A3 00 01
	fmul.s	6(PC,A7.W),FP4		; F2 3B 46 23 F0 02
	fmul.s	6(PC,A7.L),FP4		; F2 3B 46 23 F8 02
	fmul.s	(0x1234,A0,D1),FP0	; F2 30 44 23 11 20 12
	fmul.s	([2,A1,A2],4),FP1	; F2 31 44 A3 A1 22 00
	fmul.s	([6,A2],D3,8),FP2	; F2 32 45 23 31 26 00
	fmul.s	(0x1234,PC,D1),FP3	; F2 3B 45 A3 11 20 12
	fmul.s	([2,PC,A2],4),FP4	; F2 3B 46 23 A1 22 FF
	fmul.s	([6,PC],D3,8),FP5	; F2 3B 46 A3 31 26 00

	fmul.d	(A1),FP2		; F2 11 55 23
	fmul.d	(A2)+,FP3		; F2 1A 55 A3
	fmul.d	-(A3),FP4		; F2 23 56 23
	fmul.d	1(A4),FP5		; F2 2C 56 A3 00 01
	fmul.d	2(A5,D7.W),FP6		; F2 35 57 23 70 02
	fmul.d	2(A5,D7.L),FP6		; F2 35 57 23 78 02
	fmul.d	(0x1234).W,FP7		; F2 38 57 A3 12 34
	fmul.d	(0x1234).L,FP7		; F2 39 57 A3 00 00 12
	fmul.d	*0xFFFFFFF0,FP0		; F2 38 54 23 FF F0
	fmul.d	 0x00010004,FP1		; F2 39 54 A3 00 01 00
	fmul.d	5(PC),FP3		; F2 3A 55 A3 00 01
	fmul.d	6(PC,A7.W),FP4		; F2 3B 56 23 F0 02
	fmul.d	6(PC,A7.L),FP4		; F2 3B 56 23 F8 02
	fmul.d	(0x1234,A0,D1),FP0	; F2 30 54 23 11 20 12
	fmul.d	([2,A1,A2],4),FP1	; F2 31 54 A3 A1 22 00
	fmul.d	([6,A2],D3,8),FP2	; F2 32 55 23 31 26 00
	fmul.d	(0x1234,PC,D1),FP3	; F2 3B 55 A3 11 20 12
	fmul.d	([2,PC,A2],4),FP4	; F2 3B 56 23 A1 22 FF
	fmul.d	([6,PC],D3,8),FP5	; F2 3B 56 A3 31 26 00

	fmul.x	FP1,FP2			; F2 00 05 23

	fmul.x	(A1),FP2		; F2 11 49 23
	fmul.x	(A2)+,FP3		; F2 1A 49 A3
	fmul.x	-(A3),FP4		; F2 23 4A 23
	fmul.x	1(A4),FP5		; F2 2C 4A A3 00 01
	fmul.x	2(A5,D7.W),FP6		; F2 35 4B 23 70 02
	fmul.x	2(A5,D7.L),FP6		; F2 35 4B 23 78 02
	fmul.x	(0x1234).W,FP7		; F2 38 4B A3 12 34
	fmul.x	(0x1234).L,FP7		; F2 39 4B A3 00 00 12
	fmul.x	*0xFFFFFFF0,FP0		; F2 38 48 23 FF F0
	fmul.x	 0x00010004,FP1		; F2 39 48 A3 00 01 00
	fmul.x	5(PC),FP3		; F2 3A 49 A3 00 01
	fmul.x	6(PC,A7.W),FP4		; F2 3B 4A 23 F0 02
	fmul.x	6(PC,A7.L),FP4		; F2 3B 4A 23 F8 02
	fmul.x	(0x1234,A0,D1),FP0	; F2 30 48 23 11 20 12
	fmul.x	([2,A1,A2],4),FP1	; F2 31 48 A3 A1 22 00
	fmul.x	([6,A2],D3,8),FP2	; F2 32 49 23 31 26 00
	fmul.x	(0x1234,PC,D1),FP3	; F2 3B 49 A3 11 20 12
	fmul.x	([2,PC,A2],4),FP4	; F2 3B 4A 23 A1 22 FF
	fmul.x	([6,PC],D3,8),FP5	; F2 3B 4A A3 31 26 00

	fmul.p	(A1),FP2		; F2 11 4D 23
	fmul.p	(A2)+,FP3		; F2 1A 4D A3
	fmul.p	-(A3),FP4		; F2 23 4E 23
	fmul.p	1(A4),FP5		; F2 2C 4E A3 00 01
	fmul.p	2(A5,D7.W),FP6		; F2 35 4F 23 70 02
	fmul.p	2(A5,D7.L),FP6		; F2 35 4F 23 78 02
	fmul.p	(0x1234).W,FP7		; F2 38 4F A3 12 34
	fmul.p	(0x1234).L,FP7		; F2 39 4F A3 00 00 12
	fmul.p	*0xFFFFFFF0,FP0		; F2 38 4C 23 FF F0
	fmul.p	 0x00010004,FP1		; F2 39 4C A3 00 01 00
	fmul.p	5(PC),FP3		; F2 3A 4D A3 00 01
	fmul.p	6(PC,A7.W),FP4		; F2 3B 4E 23 F0 02
	fmul.p	6(PC,A7.L),FP4		; F2 3B 4E 23 F8 02
	fmul.p	(0x1234,A0,D1),FP0	; F2 30 4C 23 11 20 12
	fmul.p	([2,A1,A2],4),FP1	; F2 31 4C A3 A1 22 00
	fmul.p	([6,A2],D3,8),FP2	; F2 32 4D 23 31 26 00
	fmul.p	(0x1234,PC,D1),FP3	; F2 3B 4D A3 11 20 12
	fmul.p	([2,PC,A2],4),FP4	; F2 3B 4E 23 A1 22 FF
	fmul.p	([6,PC],D3,8),FP5	; F2 3B 4E A3 31 26 00

	fsgldiv	FP1,FP2			; F2 00 05 24

	fsgldiv	(A1),FP2		; F2 11 49 24
	fsgldiv	(A2)+,FP3		; F2 1A 49 A4
	fsgldiv	-(A3),FP4		; F2 23 4A 24
	fsgldiv	1(A4),FP5		; F2 2C 4A A4 00 01
	fsgldiv	2(A5,D7.W),FP6		; F2 35 4B 24 70 02
	fsgldiv	2(A5,D7.L),FP6		; F2 35 4B 24 78 02
	fsgldiv	(0x1234).W,FP7		; F2 38 4B A4 12 34
	fsgldiv	(0x1234).L,FP7		; F2 39 4B A4 00 00 12
	fsgldiv	*0xFFFFFFF0,FP0		; F2 38 48 24 FF F0
	fsgldiv	 0x00010004,FP1		; F2 39 48 A4 00 01 00
	fsgldiv	5(PC),FP3		; F2 3A 49 A4 00 01
	fsgldiv	6(PC,A7.W),FP4		; F2 3B 4A 24 F0 02
	fsgldiv	6(PC,A7.L),FP4		; F2 3B 4A 24 F8 02
	fsgldiv	(0x1234,A0,D1),FP0	; F2 30 48 24 11 20 12
	fsgldiv	([2,A1,A2],4),FP1	; F2 31 48 A4 A1 22 00
	fsgldiv	([6,A2],D3,8),FP2	; F2 32 49 24 31 26 00
	fsgldiv	(0x1234,PC,D1),FP3	; F2 3B 49 A4 11 20 12
	fsgldiv	([2,PC,A2],4),FP4	; F2 3B 4A 24 A1 22 FF
	fsgldiv	([6,PC],D3,8),FP5	; F2 3B 4A A4 31 26 00

	fsgldiv.b	D0,FP0		; F2 00 58 24
	fsgldiv.b	(A1),FP2	; F2 11 59 24
	fsgldiv.b	(A2)+,FP3	; F2 1A 59 A4
	fsgldiv.b	-(A3),FP4	; F2 23 5A 24
	fsgldiv.b	1(A4),FP5	; F2 2C 5A A4 00 01
	fsgldiv.b	2(A5,D7.W),FP6	; F2 35 5B 24 70 02
	fsgldiv.b	2(A5,D7.L),FP6	; F2 35 5B 24 78 02
	fsgldiv.b	(0x1234).W,FP7	; F2 38 5B A4 12 34
	fsgldiv.b	(0x1234).L,FP7	; F2 39 5B A4 00 00 12
	fsgldiv.b	*0xFFFFFFF0,FP0	; F2 38 58 24 FF F0
	fsgldiv.b	 0x00010004,FP1	; F2 39 58 A4 00 01 00
	fsgldiv.b	#7,FP2		; F2 3C 59 24 00 07
	fsgldiv.b	5(PC),FP3	; F2 3A 59 A4 00 01
	fsgldiv.b	6(PC,A7.W),FP4	; F2 3B 5A 24 F0 02
	fsgldiv.b	6(PC,A7.L),FP4	; F2 3B 5A 24 F8 02
	fsgldiv.b	(0x1234,A0,D1),FP0	; F2 30 58 24 11 20 12
	fsgldiv.b	([2,A1,A2],4),FP1	; F2 31 58 A4 A1 22 00
	fsgldiv.b	([6,A2],D3,8),FP2	; F2 32 59 24 31 26 00
	fsgldiv.b	(0x1234,PC,D1),FP3	; F2 3B 59 A4 11 20 12
	fsgldiv.b	([2,PC,A2],4),FP4	; F2 3B 5A 24 A1 22 FF
	fsgldiv.b	([6,PC],D3,8),FP5	; F2 3B 5A A4 31 26 00

	fsgldiv.w	D0,FP0		; F2 00 50 24
	fsgldiv.w	(A1),FP2	; F2 11 51 24
	fsgldiv.w	(A2)+,FP3	; F2 1A 51 A4
	fsgldiv.w	-(A3),FP4	; F2 23 52 24
	fsgldiv.w	1(A4),FP5	; F2 2C 52 A4 00 01
	fsgldiv.w	2(A5,D7.W),FP6	; F2 35 53 24 70 02
	fsgldiv.w	2(A5,D7.L),FP6	; F2 35 53 24 78 02
	fsgldiv.w	(0x1234).W,FP7	; F2 38 53 A4 12 34
	fsgldiv.w	(0x1234).L,FP7	; F2 39 53 A4 00 00 12
	fsgldiv.w	*0xFFFFFFF0,FP0	; F2 38 50 24 FF F0
	fsgldiv.w	 0x00010004,FP1	; F2 39 50 A4 00 01 00
	fsgldiv.w	#7,FP2		; F2 3C 51 24 00 07
	fsgldiv.w	5(PC),FP3	; F2 3A 51 A4 00 01
	fsgldiv.w	6(PC,A7.W),FP4	; F2 3B 52 24 F0 02
	fsgldiv.w	6(PC,A7.L),FP4	; F2 3B 52 24 F8 02
	fsgldiv.w	(0x1234,A0,D1),FP0	; F2 30 50 24 11 20 12
	fsgldiv.w	([2,A1,A2],4),FP1	; F2 31 50 A4 A1 22 00
	fsgldiv.w	([6,A2],D3,8),FP2	; F2 32 51 24 31 26 00
	fsgldiv.w	(0x1234,PC,D1),FP3	; F2 3B 51 A4 11 20 12
	fsgldiv.w	([2,PC,A2],4),FP4	; F2 3B 52 24 A1 22 FF
	fsgldiv.w	([6,PC],D3,8),FP5	; F2 3B 52 A4 31 26 00

	fsgldiv.l	D0,FP0		; F2 00 40 24
	fsgldiv.l	(A1),FP2	; F2 11 41 24
	fsgldiv.l	(A2)+,FP3	; F2 1A 41 A4
	fsgldiv.l	-(A3),FP4	; F2 23 42 24
	fsgldiv.l	1(A4),FP5	; F2 2C 42 A4 00 01
	fsgldiv.l	2(A5,D7.W),FP6	; F2 35 43 24 70 02
	fsgldiv.l	2(A5,D7.L),FP6	; F2 35 43 24 78 02
	fsgldiv.l	(0x1234).W,FP7	; F2 38 43 A4 12 34
	fsgldiv.l	(0x1234).L,FP7	; F2 39 43 A4 00 00 12
	fsgldiv.l	*0xFFFFFFF0,FP0	; F2 38 40 24 FF F0
	fsgldiv.l	 0x00010004,FP1	; F2 39 40 A4 00 01 00
	fsgldiv.l	#7,FP2		; F2 3C 41 24 00 00 00
	fsgldiv.l	5(PC),FP3	; F2 3A 41 A4 00 01
	fsgldiv.l	6(PC,A7.W),FP4	; F2 3B 42 24 F0 02
	fsgldiv.l	6(PC,A7.L),FP4	; F2 3B 42 24 F8 02
	fsgldiv.l	(0x1234,A0,D1),FP0	; F2 30 40 24 11 20 12
	fsgldiv.l	([2,A1,A2],4),FP1	; F2 31 40 A4 A1 22 00
	fsgldiv.l	([6,A2],D3,8),FP2	; F2 32 41 24 31 26 00
	fsgldiv.l	(0x1234,PC,D1),FP3	; F2 3B 41 A4 11 20 12
	fsgldiv.l	([2,PC,A2],4),FP4	; F2 3B 42 24 A1 22 FF
	fsgldiv.l	([6,PC],D3,8),FP5	; F2 3B 42 A4 31 26 00

	fsgldiv.s	D0,FP0		; F2 00 44 24
	fsgldiv.s	(A1),FP2	; F2 11 45 24
	fsgldiv.s	(A2)+,FP3	; F2 1A 45 A4
	fsgldiv.s	-(A3),FP4	; F2 23 46 24
	fsgldiv.s	1(A4),FP5	; F2 2C 46 A4 00 01
	fsgldiv.s	2(A5,D7.W),FP6	; F2 35 47 24 70 02
	fsgldiv.s	2(A5,D7.L),FP6	; F2 35 47 24 78 02
	fsgldiv.s	(0x1234).W,FP7	; F2 38 47 A4 12 34
	fsgldiv.s	(0x1234).L,FP7	; F2 39 47 A4 00 00 12
	fsgldiv.s	*0xFFFFFFF0,FP0	; F2 38 44 24 FF F0
	fsgldiv.s	 0x00010004,FP1	; F2 39 44 A4 00 01 00
	fsgldiv.s	#7,FP2		; F2 3C 45 24 40 E0 00
	fsgldiv.s	5(PC),FP3	; F2 3A 45 A4 00 01
	fsgldiv.s	6(PC,A7.W),FP4	; F2 3B 46 24 F0 02
	fsgldiv.s	6(PC,A7.L),FP4	; F2 3B 46 24 F8 02
	fsgldiv.s	(0x1234,A0,D1),FP0	; F2 30 44 24 11 20 12
	fsgldiv.s	([2,A1,A2],4),FP1	; F2 31 44 A4 A1 22 00
	fsgldiv.s	([6,A2],D3,8),FP2	; F2 32 45 24 31 26 00
	fsgldiv.s	(0x1234,PC,D1),FP3	; F2 3B 45 A4 11 20 12
	fsgldiv.s	([2,PC,A2],4),FP4	; F2 3B 46 24 A1 22 FF
	fsgldiv.s	([6,PC],D3,8),FP5	; F2 3B 46 A4 31 26 00

	fsgldiv.d	(A1),FP2	; F2 11 55 24
	fsgldiv.d	(A2)+,FP3	; F2 1A 55 A4
	fsgldiv.d	-(A3),FP4	; F2 23 56 24
	fsgldiv.d	1(A4),FP5	; F2 2C 56 A4 00 01
	fsgldiv.d	2(A5,D7.W),FP6	; F2 35 57 24 70 02
	fsgldiv.d	2(A5,D7.L),FP6	; F2 35 57 24 78 02
	fsgldiv.d	(0x1234).W,FP7	; F2 38 57 A4 12 34
	fsgldiv.d	(0x1234).L,FP7	; F2 39 57 A4 00 00 12
	fsgldiv.d	*0xFFFFFFF0,FP0	; F2 38 54 24 FF F0
	fsgldiv.d	 0x00010004,FP1	; F2 39 54 A4 00 01 00
	fsgldiv.d	5(PC),FP3	; F2 3A 55 A4 00 01
	fsgldiv.d	6(PC,A7.W),FP4	; F2 3B 56 24 F0 02
	fsgldiv.d	6(PC,A7.L),FP4	; F2 3B 56 24 F8 02
	fsgldiv.d	(0x1234,A0,D1),FP0	; F2 30 54 24 11 20 12
	fsgldiv.d	([2,A1,A2],4),FP1	; F2 31 54 A4 A1 22 00
	fsgldiv.d	([6,A2],D3,8),FP2	; F2 32 55 24 31 26 00
	fsgldiv.d	(0x1234,PC,D1),FP3	; F2 3B 55 A4 11 20 12
	fsgldiv.d	([2,PC,A2],4),FP4	; F2 3B 56 24 A1 22 FF
	fsgldiv.d	([6,PC],D3,8),FP5	; F2 3B 56 A4 31 26 00

	fsgldiv.x	FP1,FP2		; F2 00 05 24

	fsgldiv.x	(A1),FP2	; F2 11 49 24
	fsgldiv.x	(A2)+,FP3	; F2 1A 49 A4
	fsgldiv.x	-(A3),FP4	; F2 23 4A 24
	fsgldiv.x	1(A4),FP5	; F2 2C 4A A4 00 01
	fsgldiv.x	2(A5,D7.W),FP6	; F2 35 4B 24 70 02
	fsgldiv.x	2(A5,D7.L),FP6	; F2 35 4B 24 78 02
	fsgldiv.x	(0x1234).W,FP7	; F2 38 4B A4 12 34
	fsgldiv.x	(0x1234).L,FP7	; F2 39 4B A4 00 00 12
	fsgldiv.x	*0xFFFFFFF0,FP0	; F2 38 48 24 FF F0
	fsgldiv.x	 0x00010004,FP1	; F2 39 48 A4 00 01 00
	fsgldiv.x	5(PC),FP3	; F2 3A 49 A4 00 01
	fsgldiv.x	6(PC,A7.W),FP4	; F2 3B 4A 24 F0 02
	fsgldiv.x	6(PC,A7.L),FP4	; F2 3B 4A 24 F8 02
	fsgldiv.x	(0x1234,A0,D1),FP0	; F2 30 48 24 11 20 12
	fsgldiv.x	([2,A1,A2],4),FP1	; F2 31 48 A4 A1 22 00
	fsgldiv.x	([6,A2],D3,8),FP2	; F2 32 49 24 31 26 00
	fsgldiv.x	(0x1234,PC,D1),FP3	; F2 3B 49 A4 11 20 12
	fsgldiv.x	([2,PC,A2],4),FP4	; F2 3B 4A 24 A1 22 FF
	fsgldiv.x	([6,PC],D3,8),FP5	; F2 3B 4A A4 31 26 00

	fsgldiv.p	(A1),FP2	; F2 11 4D 24
	fsgldiv.p	(A2)+,FP3	; F2 1A 4D A4
	fsgldiv.p	-(A3),FP4	; F2 23 4E 24
	fsgldiv.p	1(A4),FP5	; F2 2C 4E A4 00 01
	fsgldiv.p	2(A5,D7.W),FP6	; F2 35 4F 24 70 02
	fsgldiv.p	2(A5,D7.L),FP6	; F2 35 4F 24 78 02
	fsgldiv.p	(0x1234).W,FP7	; F2 38 4F A4 12 34
	fsgldiv.p	(0x1234).L,FP7	; F2 39 4F A4 00 00 12
	fsgldiv.p	*0xFFFFFFF0,FP0	; F2 38 4C 24 FF F0
	fsgldiv.p	 0x00010004,FP1	; F2 39 4C A4 00 01 00
	fsgldiv.p	5(PC),FP3	; F2 3A 4D A4 00 01
	fsgldiv.p	6(PC,A7.W),FP4	; F2 3B 4E 24 F0 02
	fsgldiv.p	6(PC,A7.L),FP4	; F2 3B 4E 24 F8 02
	fsgldiv.p	(0x1234,A0,D1),FP0	; F2 30 4C 24 11 20 12
	fsgldiv.p	([2,A1,A2],4),FP1	; F2 31 4C A4 A1 22 00
	fsgldiv.p	([6,A2],D3,8),FP2	; F2 32 4D 24 31 26 00
	fsgldiv.p	(0x1234,PC,D1),FP3	; F2 3B 4D A4 11 20 12
	fsgldiv.p	([2,PC,A2],4),FP4	; F2 3B 4E 24 A1 22 FF
	fsgldiv.p	([6,PC],D3,8),FP5	; F2 3B 4E A4 31 26 00

	frem	FP1,FP2			; F2 00 05 25

	frem	(A1),FP2		; F2 11 49 25
	frem	(A2)+,FP3		; F2 1A 49 A5
	frem	-(A3),FP4		; F2 23 4A 25
	frem	1(A4),FP5		; F2 2C 4A A5 00 01
	frem	2(A5,D7.W),FP6		; F2 35 4B 25 70 02
	frem	2(A5,D7.L),FP6		; F2 35 4B 25 78 02
	frem	(0x1234).W,FP7		; F2 38 4B A5 12 34
	frem	(0x1234).L,FP7		; F2 39 4B A5 00 00 12
	frem	*0xFFFFFFF0,FP0		; F2 38 48 25 FF F0
	frem	 0x00010004,FP1		; F2 39 48 A5 00 01 00
	frem	5(PC),FP3		; F2 3A 49 A5 00 01
	frem	6(PC,A7.W),FP4		; F2 3B 4A 25 F0 02
	frem	6(PC,A7.L),FP4		; F2 3B 4A 25 F8 02
	frem	(0x1234,A0,D1),FP0	; F2 30 48 25 11 20 12
	frem	([2,A1,A2],4),FP1	; F2 31 48 A5 A1 22 00
	frem	([6,A2],D3,8),FP2	; F2 32 49 25 31 26 00
	frem	(0x1234,PC,D1),FP3	; F2 3B 49 A5 11 20 12
	frem	([2,PC,A2],4),FP4	; F2 3B 4A 25 A1 22 FF
	frem	([6,PC],D3,8),FP5	; F2 3B 4A A5 31 26 00

	frem.b	D0,FP0			; F2 00 58 25
	frem.b	(A1),FP2		; F2 11 59 25
	frem.b	(A2)+,FP3		; F2 1A 59 A5
	frem.b	-(A3),FP4		; F2 23 5A 25
	frem.b	1(A4),FP5		; F2 2C 5A A5 00 01
	frem.b	2(A5,D7.W),FP6		; F2 35 5B 25 70 02
	frem.b	2(A5,D7.L),FP6		; F2 35 5B 25 78 02
	frem.b	(0x1234).W,FP7		; F2 38 5B A5 12 34
	frem.b	(0x1234).L,FP7		; F2 39 5B A5 00 00 12
	frem.b	*0xFFFFFFF0,FP0		; F2 38 58 25 FF F0
	frem.b	 0x00010004,FP1		; F2 39 58 A5 00 01 00
	frem.b	#7,FP2			; F2 3C 59 25 00 07
	frem.b	5(PC),FP3		; F2 3A 59 A5 00 01
	frem.b	6(PC,A7.W),FP4		; F2 3B 5A 25 F0 02
	frem.b	6(PC,A7.L),FP4		; F2 3B 5A 25 F8 02
	frem.b	(0x1234,A0,D1),FP0	; F2 30 58 25 11 20 12
	frem.b	([2,A1,A2],4),FP1	; F2 31 58 A5 A1 22 00
	frem.b	([6,A2],D3,8),FP2	; F2 32 59 25 31 26 00
	frem.b	(0x1234,PC,D1),FP3	; F2 3B 59 A5 11 20 12
	frem.b	([2,PC,A2],4),FP4	; F2 3B 5A 25 A1 22 FF
	frem.b	([6,PC],D3,8),FP5	; F2 3B 5A A5 31 26 00

	frem.w	D0,FP0			; F2 00 50 25
	frem.w	(A1),FP2		; F2 11 51 25
	frem.w	(A2)+,FP3		; F2 1A 51 A5
	frem.w	-(A3),FP4		; F2 23 52 25
	frem.w	1(A4),FP5		; F2 2C 52 A5 00 01
	frem.w	2(A5,D7.W),FP6		; F2 35 53 25 70 02
	frem.w	2(A5,D7.L),FP6		; F2 35 53 25 78 02
	frem.w	(0x1234).W,FP7		; F2 38 53 A5 12 34
	frem.w	(0x1234).L,FP7		; F2 39 53 A5 00 00 12
	frem.w	*0xFFFFFFF0,FP0		; F2 38 50 25 FF F0
	frem.w	 0x00010004,FP1		; F2 39 50 A5 00 01 00
	frem.w	#7,FP2			; F2 3C 51 25 00 07
	frem.w	5(PC),FP3		; F2 3A 51 A5 00 01
	frem.w	6(PC,A7.W),FP4		; F2 3B 52 25 F0 02
	frem.w	6(PC,A7.L),FP4		; F2 3B 52 25 F8 02
	frem.w	(0x1234,A0,D1),FP0	; F2 30 50 25 11 20 12
	frem.w	([2,A1,A2],4),FP1	; F2 31 50 A5 A1 22 00
	frem.w	([6,A2],D3,8),FP2	; F2 32 51 25 31 26 00
	frem.w	(0x1234,PC,D1),FP3	; F2 3B 51 A5 11 20 12
	frem.w	([2,PC,A2],4),FP4	; F2 3B 52 25 A1 22 FF
	frem.w	([6,PC],D3,8),FP5	; F2 3B 52 A5 31 26 00

	frem.l	D0,FP0			; F2 00 40 25
	frem.l	(A1),FP2		; F2 11 41 25
	frem.l	(A2)+,FP3		; F2 1A 41 A5
	frem.l	-(A3),FP4		; F2 23 42 25
	frem.l	1(A4),FP5		; F2 2C 42 A5 00 01
	frem.l	2(A5,D7.W),FP6		; F2 35 43 25 70 02
	frem.l	2(A5,D7.L),FP6		; F2 35 43 25 78 02
	frem.l	(0x1234).W,FP7		; F2 38 43 A5 12 34
	frem.l	(0x1234).L,FP7		; F2 39 43 A5 00 00 12
	frem.l	*0xFFFFFFF0,FP0		; F2 38 40 25 FF F0
	frem.l	 0x00010004,FP1		; F2 39 40 A5 00 01 00
	frem.l	#7,FP2			; F2 3C 41 25 00 00 00
	frem.l	5(PC),FP3		; F2 3A 41 A5 00 01
	frem.l	6(PC,A7.W),FP4		; F2 3B 42 25 F0 02
	frem.l	6(PC,A7.L),FP4		; F2 3B 42 25 F8 02
	frem.l	(0x1234,A0,D1),FP0	; F2 30 40 25 11 20 12
	frem.l	([2,A1,A2],4),FP1	; F2 31 40 A5 A1 22 00
	frem.l	([6,A2],D3,8),FP2	; F2 32 41 25 31 26 00
	frem.l	(0x1234,PC,D1),FP3	; F2 3B 41 A5 11 20 12
	frem.l	([2,PC,A2],4),FP4	; F2 3B 42 25 A1 22 FF
	frem.l	([6,PC],D3,8),FP5	; F2 3B 42 A5 31 26 00

	frem.s	D0,FP0			; F2 00 44 25
	frem.s	(A1),FP2		; F2 11 45 25
	frem.s	(A2)+,FP3		; F2 1A 45 A5
	frem.s	-(A3),FP4		; F2 23 46 25
	frem.s	1(A4),FP5		; F2 2C 46 A5 00 01
	frem.s	2(A5,D7.W),FP6		; F2 35 47 25 70 02
	frem.s	2(A5,D7.L),FP6		; F2 35 47 25 78 02
	frem.s	(0x1234).W,FP7		; F2 38 47 A5 12 34
	frem.s	(0x1234).L,FP7		; F2 39 47 A5 00 00 12
	frem.s	*0xFFFFFFF0,FP0		; F2 38 44 25 FF F0
	frem.s	 0x00010004,FP1		; F2 39 44 A5 00 01 00
	frem.s	#7,FP2			; F2 3C 45 25 40 E0 00
	frem.s	5(PC),FP3		; F2 3A 45 A5 00 01
	frem.s	6(PC,A7.W),FP4		; F2 3B 46 25 F0 02
	frem.s	6(PC,A7.L),FP4		; F2 3B 46 25 F8 02
	frem.s	(0x1234,A0,D1),FP0	; F2 30 44 25 11 20 12
	frem.s	([2,A1,A2],4),FP1	; F2 31 44 A5 A1 22 00
	frem.s	([6,A2],D3,8),FP2	; F2 32 45 25 31 26 00
	frem.s	(0x1234,PC,D1),FP3	; F2 3B 45 A5 11 20 12
	frem.s	([2,PC,A2],4),FP4	; F2 3B 46 25 A1 22 FF
	frem.s	([6,PC],D3,8),FP5	; F2 3B 46 A5 31 26 00

	frem.d	(A1),FP2		; F2 11 55 25
	frem.d	(A2)+,FP3		; F2 1A 55 A5
	frem.d	-(A3),FP4		; F2 23 56 25
	frem.d	1(A4),FP5		; F2 2C 56 A5 00 01
	frem.d	2(A5,D7.W),FP6		; F2 35 57 25 70 02
	frem.d	2(A5,D7.L),FP6		; F2 35 57 25 78 02
	frem.d	(0x1234).W,FP7		; F2 38 57 A5 12 34
	frem.d	(0x1234).L,FP7		; F2 39 57 A5 00 00 12
	frem.d	*0xFFFFFFF0,FP0		; F2 38 54 25 FF F0
	frem.d	 0x00010004,FP1		; F2 39 54 A5 00 01 00
	frem.d	5(PC),FP3		; F2 3A 55 A5 00 01
	frem.d	6(PC,A7.W),FP4		; F2 3B 56 25 F0 02
	frem.d	6(PC,A7.L),FP4		; F2 3B 56 25 F8 02
	frem.d	(0x1234,A0,D1),FP0	; F2 30 54 25 11 20 12
	frem.d	([2,A1,A2],4),FP1	; F2 31 54 A5 A1 22 00
	frem.d	([6,A2],D3,8),FP2	; F2 32 55 25 31 26 00
	frem.d	(0x1234,PC,D1),FP3	; F2 3B 55 A5 11 20 12
	frem.d	([2,PC,A2],4),FP4	; F2 3B 56 25 A1 22 FF
	frem.d	([6,PC],D3,8),FP5	; F2 3B 56 A5 31 26 00

	frem.x	FP1,FP2			; F2 00 05 25

	frem.x	(A1),FP2		; F2 11 49 25
	frem.x	(A2)+,FP3		; F2 1A 49 A5
	frem.x	-(A3),FP4		; F2 23 4A 25
	frem.x	1(A4),FP5		; F2 2C 4A A5 00 01
	frem.x	2(A5,D7.W),FP6		; F2 35 4B 25 70 02
	frem.x	2(A5,D7.L),FP6		; F2 35 4B 25 78 02
	frem.x	(0x1234).W,FP7		; F2 38 4B A5 12 34
	frem.x	(0x1234).L,FP7		; F2 39 4B A5 00 00 12
	frem.x	*0xFFFFFFF0,FP0		; F2 38 48 25 FF F0
	frem.x	 0x00010004,FP1		; F2 39 48 A5 00 01 00
	frem.x	5(PC),FP3		; F2 3A 49 A5 00 01
	frem.x	6(PC,A7.W),FP4		; F2 3B 4A 25 F0 02
	frem.x	6(PC,A7.L),FP4		; F2 3B 4A 25 F8 02
	frem.x	(0x1234,A0,D1),FP0	; F2 30 48 25 11 20 12
	frem.x	([2,A1,A2],4),FP1	; F2 31 48 A5 A1 22 00
	frem.x	([6,A2],D3,8),FP2	; F2 32 49 25 31 26 00
	frem.x	(0x1234,PC,D1),FP3	; F2 3B 49 A5 11 20 12
	frem.x	([2,PC,A2],4),FP4	; F2 3B 4A 25 A1 22 FF
	frem.x	([6,PC],D3,8),FP5	; F2 3B 4A A5 31 26 00

	frem.p	(A1),FP2		; F2 11 4D 25
	frem.p	(A2)+,FP3		; F2 1A 4D A5
	frem.p	-(A3),FP4		; F2 23 4E 25
	frem.p	1(A4),FP5		; F2 2C 4E A5 00 01
	frem.p	2(A5,D7.W),FP6		; F2 35 4F 25 70 02
	frem.p	2(A5,D7.L),FP6		; F2 35 4F 25 78 02
	frem.p	(0x1234).W,FP7		; F2 38 4F A5 12 34
	frem.p	(0x1234).L,FP7		; F2 39 4F A5 00 00 12
	frem.p	*0xFFFFFFF0,FP0		; F2 38 4C 25 FF F0
	frem.p	 0x00010004,FP1		; F2 39 4C A5 00 01 00
	frem.p	5(PC),FP3		; F2 3A 4D A5 00 01
	frem.p	6(PC,A7.W),FP4		; F2 3B 4E 25 F0 02
	frem.p	6(PC,A7.L),FP4		; F2 3B 4E 25 F8 02
	frem.p	(0x1234,A0,D1),FP0	; F2 30 4C 25 11 20 12
	frem.p	([2,A1,A2],4),FP1	; F2 31 4C A5 A1 22 00
	frem.p	([6,A2],D3,8),FP2	; F2 32 4D 25 31 26 00
	frem.p	(0x1234,PC,D1),FP3	; F2 3B 4D A5 11 20 12
	frem.p	([2,PC,A2],4),FP4	; F2 3B 4E 25 A1 22 FF
	frem.p	([6,PC],D3,8),FP5	; F2 3B 4E A5 31 26 00

	fscale	FP1,FP2			; F2 00 05 26

	fscale	(A1),FP2		; F2 11 49 26
	fscale	(A2)+,FP3		; F2 1A 49 A6
	fscale	-(A3),FP4		; F2 23 4A 26
	fscale	1(A4),FP5		; F2 2C 4A A6 00 01
	fscale	2(A5,D7.W),FP6		; F2 35 4B 26 70 02
	fscale	2(A5,D7.L),FP6		; F2 35 4B 26 78 02
	fscale	(0x1234).W,FP7		; F2 38 4B A6 12 34
	fscale	(0x1234).L,FP7		; F2 39 4B A6 00 00 12
	fscale	*0xFFFFFFF0,FP0		; F2 38 48 26 FF F0
	fscale	 0x00010004,FP1		; F2 39 48 A6 00 01 00
	fscale	5(PC),FP3		; F2 3A 49 A6 00 01
	fscale	6(PC,A7.W),FP4		; F2 3B 4A 26 F0 02
	fscale	6(PC,A7.L),FP4		; F2 3B 4A 26 F8 02
	fscale	(0x1234,A0,D1),FP0	; F2 30 48 26 11 20 12
	fscale	([2,A1,A2],4),FP1	; F2 31 48 A6 A1 22 00
	fscale	([6,A2],D3,8),FP2	; F2 32 49 26 31 26 00
	fscale	(0x1234,PC,D1),FP3	; F2 3B 49 A6 11 20 12
	fscale	([2,PC,A2],4),FP4	; F2 3B 4A 26 A1 22 FF
	fscale	([6,PC],D3,8),FP5	; F2 3B 4A A6 31 26 00

	fscale.b	D0,FP0		; F2 00 58 26
	fscale.b	(A1),FP2	; F2 11 59 26
	fscale.b	(A2)+,FP3	; F2 1A 59 A6
	fscale.b	-(A3),FP4	; F2 23 5A 26
	fscale.b	1(A4),FP5	; F2 2C 5A A6 00 01
	fscale.b	2(A5,D7.W),FP6	; F2 35 5B 26 70 02
	fscale.b	2(A5,D7.L),FP6	; F2 35 5B 26 78 02
	fscale.b	(0x1234).W,FP7	; F2 38 5B A6 12 34
	fscale.b	(0x1234).L,FP7	; F2 39 5B A6 00 00 12
	fscale.b	*0xFFFFFFF0,FP0	; F2 38 58 26 FF F0
	fscale.b	 0x00010004,FP1	; F2 39 58 A6 00 01 00
	fscale.b	#7,FP2		; F2 3C 59 26 00 07
	fscale.b	5(PC),FP3	; F2 3A 59 A6 00 01
	fscale.b	6(PC,A7.W),FP4	; F2 3B 5A 26 F0 02
	fscale.b	6(PC,A7.L),FP4	; F2 3B 5A 26 F8 02
	fscale.b	(0x1234,A0,D1),FP0	; F2 30 58 26 11 20 12
	fscale.b	([2,A1,A2],4),FP1	; F2 31 58 A6 A1 22 00
	fscale.b	([6,A2],D3,8),FP2	; F2 32 59 26 31 26 00
	fscale.b	(0x1234,PC,D1),FP3	; F2 3B 59 A6 11 20 12
	fscale.b	([2,PC,A2],4),FP4	; F2 3B 5A 26 A1 22 FF
	fscale.b	([6,PC],D3,8),FP5	; F2 3B 5A A6 31 26 00

	fscale.w	D0,FP0		; F2 00 50 26
	fscale.w	(A1),FP2	; F2 11 51 26
	fscale.w	(A2)+,FP3	; F2 1A 51 A6
	fscale.w	-(A3),FP4	; F2 23 52 26
	fscale.w	1(A4),FP5	; F2 2C 52 A6 00 01
	fscale.w	2(A5,D7.W),FP6	; F2 35 53 26 70 02
	fscale.w	2(A5,D7.L),FP6	; F2 35 53 26 78 02
	fscale.w	(0x1234).W,FP7	; F2 38 53 A6 12 34
	fscale.w	(0x1234).L,FP7	; F2 39 53 A6 00 00 12
	fscale.w	*0xFFFFFFF0,FP0	; F2 38 50 26 FF F0
	fscale.w	 0x00010004,FP1	; F2 39 50 A6 00 01 00
	fscale.w	#7,FP2		; F2 3C 51 26 00 07
	fscale.w	5(PC),FP3	; F2 3A 51 A6 00 01
	fscale.w	6(PC,A7.W),FP4	; F2 3B 52 26 F0 02
	fscale.w	6(PC,A7.L),FP4	; F2 3B 52 26 F8 02
	fscale.w	(0x1234,A0,D1),FP0	; F2 30 50 26 11 20 12
	fscale.w	([2,A1,A2],4),FP1	; F2 31 50 A6 A1 22 00
	fscale.w	([6,A2],D3,8),FP2	; F2 32 51 26 31 26 00
	fscale.w	(0x1234,PC,D1),FP3	; F2 3B 51 A6 11 20 12
	fscale.w	([2,PC,A2],4),FP4	; F2 3B 52 26 A1 22 FF
	fscale.w	([6,PC],D3,8),FP5	; F2 3B 52 A6 31 26 00

	fscale.l	D0,FP0		; F2 00 40 26
	fscale.l	(A1),FP2	; F2 11 41 26
	fscale.l	(A2)+,FP3	; F2 1A 41 A6
	fscale.l	-(A3),FP4	; F2 23 42 26
	fscale.l	1(A4),FP5	; F2 2C 42 A6 00 01
	fscale.l	2(A5,D7.W),FP6	; F2 35 43 26 70 02
	fscale.l	2(A5,D7.L),FP6	; F2 35 43 26 78 02
	fscale.l	(0x1234).W,FP7	; F2 38 43 A6 12 34
	fscale.l	(0x1234).L,FP7	; F2 39 43 A6 00 00 12
	fscale.l	*0xFFFFFFF0,FP0	; F2 38 40 26 FF F0
	fscale.l	 0x00010004,FP1	; F2 39 40 A6 00 01 00
	fscale.l	#7,FP2		; F2 3C 41 26 00 00 00
	fscale.l	5(PC),FP3	; F2 3A 41 A6 00 01
	fscale.l	6(PC,A7.W),FP4	; F2 3B 42 26 F0 02
	fscale.l	6(PC,A7.L),FP4	; F2 3B 42 26 F8 02
	fscale.l	(0x1234,A0,D1),FP0	; F2 30 40 26 11 20 12
	fscale.l	([2,A1,A2],4),FP1	; F2 31 40 A6 A1 22 00
	fscale.l	([6,A2],D3,8),FP2	; F2 32 41 26 31 26 00
	fscale.l	(0x1234,PC,D1),FP3	; F2 3B 41 A6 11 20 12
	fscale.l	([2,PC,A2],4),FP4	; F2 3B 42 26 A1 22 FF
	fscale.l	([6,PC],D3,8),FP5	; F2 3B 42 A6 31 26 00

	fscale.s	D0,FP0		; F2 00 44 26
	fscale.s	(A1),FP2	; F2 11 45 26
	fscale.s	(A2)+,FP3	; F2 1A 45 A6
	fscale.s	-(A3),FP4	; F2 23 46 26
	fscale.s	1(A4),FP5	; F2 2C 46 A6 00 01
	fscale.s	2(A5,D7.W),FP6	; F2 35 47 26 70 02
	fscale.s	2(A5,D7.L),FP6	; F2 35 47 26 78 02
	fscale.s	(0x1234).W,FP7	; F2 38 47 A6 12 34
	fscale.s	(0x1234).L,FP7	; F2 39 47 A6 00 00 12
	fscale.s	*0xFFFFFFF0,FP0	; F2 38 44 26 FF F0
	fscale.s	 0x00010004,FP1	; F2 39 44 A6 00 01 00
	fscale.s	#7,FP2		; F2 3C 45 26 40 E0 00
	fscale.s	5(PC),FP3	; F2 3A 45 A6 00 01
	fscale.s	6(PC,A7.W),FP4	; F2 3B 46 26 F0 02
	fscale.s	6(PC,A7.L),FP4	; F2 3B 46 26 F8 02
	fscale.s	(0x1234,A0,D1),FP0	; F2 30 44 26 11 20 12
	fscale.s	([2,A1,A2],4),FP1	; F2 31 44 A6 A1 22 00
	fscale.s	([6,A2],D3,8),FP2	; F2 32 45 26 31 26 00
	fscale.s	(0x1234,PC,D1),FP3	; F2 3B 45 A6 11 20 12
	fscale.s	([2,PC,A2],4),FP4	; F2 3B 46 26 A1 22 FF
	fscale.s	([6,PC],D3,8),FP5	; F2 3B 46 A6 31 26 00

	fscale.d	(A1),FP2	; F2 11 55 26
	fscale.d	(A2)+,FP3	; F2 1A 55 A6
	fscale.d	-(A3),FP4	; F2 23 56 26
	fscale.d	1(A4),FP5	; F2 2C 56 A6 00 01
	fscale.d	2(A5,D7.W),FP6	; F2 35 57 26 70 02
	fscale.d	2(A5,D7.L),FP6	; F2 35 57 26 78 02
	fscale.d	(0x1234).W,FP7	; F2 38 57 A6 12 34
	fscale.d	(0x1234).L,FP7	; F2 39 57 A6 00 00 12
	fscale.d	*0xFFFFFFF0,FP0	; F2 38 54 26 FF F0
	fscale.d	 0x00010004,FP1	; F2 39 54 A6 00 01 00
	fscale.d	5(PC),FP3	; F2 3A 55 A6 00 01
	fscale.d	6(PC,A7.W),FP4	; F2 3B 56 26 F0 02
	fscale.d	6(PC,A7.L),FP4	; F2 3B 56 26 F8 02
	fscale.d	(0x1234,A0,D1),FP0	; F2 30 54 26 11 20 12
	fscale.d	([2,A1,A2],4),FP1	; F2 31 54 A6 A1 22 00
	fscale.d	([6,A2],D3,8),FP2	; F2 32 55 26 31 26 00
	fscale.d	(0x1234,PC,D1),FP3	; F2 3B 55 A6 11 20 12
	fscale.d	([2,PC,A2],4),FP4	; F2 3B 56 26 A1 22 FF
	fscale.d	([6,PC],D3,8),FP5	; F2 3B 56 A6 31 26 00

	fscale.x	FP1,FP2		; F2 00 05 26

	fscale.x	(A1),FP2	; F2 11 49 26
	fscale.x	(A2)+,FP3	; F2 1A 49 A6
	fscale.x	-(A3),FP4	; F2 23 4A 26
	fscale.x	1(A4),FP5	; F2 2C 4A A6 00 01
	fscale.x	2(A5,D7.W),FP6	; F2 35 4B 26 70 02
	fscale.x	2(A5,D7.L),FP6	; F2 35 4B 26 78 02
	fscale.x	(0x1234).W,FP7	; F2 38 4B A6 12 34
	fscale.x	(0x1234).L,FP7	; F2 39 4B A6 00 00 12
	fscale.x	*0xFFFFFFF0,FP0	; F2 38 48 26 FF F0
	fscale.x	 0x00010004,FP1	; F2 39 48 A6 00 01 00
	fscale.x	5(PC),FP3	; F2 3A 49 A6 00 01
	fscale.x	6(PC,A7.W),FP4	; F2 3B 4A 26 F0 02
	fscale.x	6(PC,A7.L),FP4	; F2 3B 4A 26 F8 02
	fscale.x	(0x1234,A0,D1),FP0	; F2 30 48 26 11 20 12
	fscale.x	([2,A1,A2],4),FP1	; F2 31 48 A6 A1 22 00
	fscale.x	([6,A2],D3,8),FP2	; F2 32 49 26 31 26 00
	fscale.x	(0x1234,PC,D1),FP3	; F2 3B 49 A6 11 20 12
	fscale.x	([2,PC,A2],4),FP4	; F2 3B 4A 26 A1 22 FF
	fscale.x	([6,PC],D3,8),FP5	; F2 3B 4A A6 31 26 00

	fscale.p	(A1),FP2	; F2 11 4D 26
	fscale.p	(A2)+,FP3	; F2 1A 4D A6
	fscale.p	-(A3),FP4	; F2 23 4E 26
	fscale.p	1(A4),FP5	; F2 2C 4E A6 00 01
	fscale.p	2(A5,D7.W),FP6	; F2 35 4F 26 70 02
	fscale.p	2(A5,D7.L),FP6	; F2 35 4F 26 78 02
	fscale.p	(0x1234).W,FP7	; F2 38 4F A6 12 34
	fscale.p	(0x1234).L,FP7	; F2 39 4F A6 00 00 12
	fscale.p	*0xFFFFFFF0,FP0	; F2 38 4C 26 FF F0
	fscale.p	 0x00010004,FP1	; F2 39 4C A6 00 01 00
	fscale.p	5(PC),FP3	; F2 3A 4D A6 00 01
	fscale.p	6(PC,A7.W),FP4	; F2 3B 4E 26 F0 02
	fscale.p	6(PC,A7.L),FP4	; F2 3B 4E 26 F8 02
	fscale.p	(0x1234,A0,D1),FP0	; F2 30 4C 26 11 20 12
	fscale.p	([2,A1,A2],4),FP1	; F2 31 4C A6 A1 22 00
	fscale.p	([6,A2],D3,8),FP2	; F2 32 4D 26 31 26 00
	fscale.p	(0x1234,PC,D1),FP3	; F2 3B 4D A6 11 20 12
	fscale.p	([2,PC,A2],4),FP4	; F2 3B 4E 26 A1 22 FF
	fscale.p	([6,PC],D3,8),FP5	; F2 3B 4E A6 31 26 00

	fsglmul	FP1,FP2			; F2 00 05 27

	fsglmul	(A1),FP2		; F2 11 49 27
	fsglmul	(A2)+,FP3		; F2 1A 49 A7
	fsglmul	-(A3),FP4		; F2 23 4A 27
	fsglmul	1(A4),FP5		; F2 2C 4A A7 00 01
	fsglmul	2(A5,D7.W),FP6		; F2 35 4B 27 70 02
	fsglmul	2(A5,D7.L),FP6		; F2 35 4B 27 78 02
	fsglmul	(0x1234).W,FP7		; F2 38 4B A7 12 34
	fsglmul	(0x1234).L,FP7		; F2 39 4B A7 00 00 12
	fsglmul	*0xFFFFFFF0,FP0		; F2 38 48 27 FF F0
	fsglmul	 0x00010004,FP1		; F2 39 48 A7 00 01 00
	fsglmul	5(PC),FP3		; F2 3A 49 A7 00 01
	fsglmul	6(PC,A7.W),FP4		; F2 3B 4A 27 F0 02
	fsglmul	6(PC,A7.L),FP4		; F2 3B 4A 27 F8 02
	fsglmul	(0x1234,A0,D1),FP0	; F2 30 48 27 11 20 12
	fsglmul	([2,A1,A2],4),FP1	; F2 31 48 A7 A1 22 00
	fsglmul	([6,A2],D3,8),FP2	; F2 32 49 27 31 26 00
	fsglmul	(0x1234,PC,D1),FP3	; F2 3B 49 A7 11 20 12
	fsglmul	([2,PC,A2],4),FP4	; F2 3B 4A 27 A1 22 FF
	fsglmul	([6,PC],D3,8),FP5	; F2 3B 4A A7 31 26 00

	fsglmul.b	D0,FP0		; F2 00 58 27
	fsglmul.b	(A1),FP2	; F2 11 59 27
	fsglmul.b	(A2)+,FP3	; F2 1A 59 A7
	fsglmul.b	-(A3),FP4	; F2 23 5A 27
	fsglmul.b	1(A4),FP5	; F2 2C 5A A7 00 01
	fsglmul.b	2(A5,D7.W),FP6	; F2 35 5B 27 70 02
	fsglmul.b	2(A5,D7.L),FP6	; F2 35 5B 27 78 02
	fsglmul.b	(0x1234).W,FP7	; F2 38 5B A7 12 34
	fsglmul.b	(0x1234).L,FP7	; F2 39 5B A7 00 00 12
	fsglmul.b	*0xFFFFFFF0,FP0	; F2 38 58 27 FF F0
	fsglmul.b	 0x00010004,FP1	; F2 39 58 A7 00 01 00
	fsglmul.b	#7,FP2		; F2 3C 59 27 00 07
	fsglmul.b	5(PC),FP3	; F2 3A 59 A7 00 01
	fsglmul.b	6(PC,A7.W),FP4	; F2 3B 5A 27 F0 02
	fsglmul.b	6(PC,A7.L),FP4	; F2 3B 5A 27 F8 02
	fsglmul.b	(0x1234,A0,D1),FP0	; F2 30 58 27 11 20 12
	fsglmul.b	([2,A1,A2],4),FP1	; F2 31 58 A7 A1 22 00
	fsglmul.b	([6,A2],D3,8),FP2	; F2 32 59 27 31 26 00
	fsglmul.b	(0x1234,PC,D1),FP3	; F2 3B 59 A7 11 20 12
	fsglmul.b	([2,PC,A2],4),FP4	; F2 3B 5A 27 A1 22 FF
	fsglmul.b	([6,PC],D3,8),FP5	; F2 3B 5A A7 31 26 00

	fsglmul.w	D0,FP0		; F2 00 50 27
	fsglmul.w	(A1),FP2	; F2 11 51 27
	fsglmul.w	(A2)+,FP3	; F2 1A 51 A7
	fsglmul.w	-(A3),FP4	; F2 23 52 27
	fsglmul.w	1(A4),FP5	; F2 2C 52 A7 00 01
	fsglmul.w	2(A5,D7.W),FP6	; F2 35 53 27 70 02
	fsglmul.w	2(A5,D7.L),FP6	; F2 35 53 27 78 02
	fsglmul.w	(0x1234).W,FP7	; F2 38 53 A7 12 34
	fsglmul.w	(0x1234).L,FP7	; F2 39 53 A7 00 00 12
	fsglmul.w	*0xFFFFFFF0,FP0	; F2 38 50 27 FF F0
	fsglmul.w	 0x00010004,FP1	; F2 39 50 A7 00 01 00
	fsglmul.w	#7,FP2		; F2 3C 51 27 00 07
	fsglmul.w	5(PC),FP3	; F2 3A 51 A7 00 01
	fsglmul.w	6(PC,A7.W),FP4	; F2 3B 52 27 F0 02
	fsglmul.w	6(PC,A7.L),FP4	; F2 3B 52 27 F8 02
	fsglmul.w	(0x1234,A0,D1),FP0	; F2 30 50 27 11 20 12
	fsglmul.w	([2,A1,A2],4),FP1	; F2 31 50 A7 A1 22 00
	fsglmul.w	([6,A2],D3,8),FP2	; F2 32 51 27 31 26 00
	fsglmul.w	(0x1234,PC,D1),FP3	; F2 3B 51 A7 11 20 12
	fsglmul.w	([2,PC,A2],4),FP4	; F2 3B 52 27 A1 22 FF
	fsglmul.w	([6,PC],D3,8),FP5	; F2 3B 52 A7 31 26 00

	fsglmul.l	D0,FP0		; F2 00 40 27
	fsglmul.l	(A1),FP2	; F2 11 41 27
	fsglmul.l	(A2)+,FP3	; F2 1A 41 A7
	fsglmul.l	-(A3),FP4	; F2 23 42 27
	fsglmul.l	1(A4),FP5	; F2 2C 42 A7 00 01
	fsglmul.l	2(A5,D7.W),FP6	; F2 35 43 27 70 02
	fsglmul.l	2(A5,D7.L),FP6	; F2 35 43 27 78 02
	fsglmul.l	(0x1234).W,FP7	; F2 38 43 A7 12 34
	fsglmul.l	(0x1234).L,FP7	; F2 39 43 A7 00 00 12
	fsglmul.l	*0xFFFFFFF0,FP0	; F2 38 40 27 FF F0
	fsglmul.l	 0x00010004,FP1	; F2 39 40 A7 00 01 00
	fsglmul.l	#7,FP2		; F2 3C 41 27 00 00 00
	fsglmul.l	5(PC),FP3	; F2 3A 41 A7 00 01
	fsglmul.l	6(PC,A7.W),FP4	; F2 3B 42 27 F0 02
	fsglmul.l	6(PC,A7.L),FP4	; F2 3B 42 27 F8 02
	fsglmul.l	(0x1234,A0,D1),FP0	; F2 30 40 27 11 20 12
	fsglmul.l	([2,A1,A2],4),FP1	; F2 31 40 A7 A1 22 00
	fsglmul.l	([6,A2],D3,8),FP2	; F2 32 41 27 31 26 00
	fsglmul.l	(0x1234,PC,D1),FP3	; F2 3B 41 A7 11 20 12
	fsglmul.l	([2,PC,A2],4),FP4	; F2 3B 42 27 A1 22 FF
	fsglmul.l	([6,PC],D3,8),FP5	; F2 3B 42 A7 31 26 00

	fsglmul.s	D0,FP0		; F2 00 44 27
	fsglmul.s	(A1),FP2	; F2 11 45 27
	fsglmul.s	(A2)+,FP3	; F2 1A 45 A7
	fsglmul.s	-(A3),FP4	; F2 23 46 27
	fsglmul.s	1(A4),FP5	; F2 2C 46 A7 00 01
	fsglmul.s	2(A5,D7.W),FP6	; F2 35 47 27 70 02
	fsglmul.s	2(A5,D7.L),FP6	; F2 35 47 27 78 02
	fsglmul.s	(0x1234).W,FP7	; F2 38 47 A7 12 34
	fsglmul.s	(0x1234).L,FP7	; F2 39 47 A7 00 00 12
	fsglmul.s	*0xFFFFFFF0,FP0	; F2 38 44 27 FF F0
	fsglmul.s	 0x00010004,FP1	; F2 39 44 A7 00 01 00
	fsglmul.s	#7,FP2		; F2 3C 45 27 40 E0 00
	fsglmul.s	5(PC),FP3	; F2 3A 45 A7 00 01
	fsglmul.s	6(PC,A7.W),FP4	; F2 3B 46 27 F0 02
	fsglmul.s	6(PC,A7.L),FP4	; F2 3B 46 27 F8 02
	fsglmul.s	(0x1234,A0,D1),FP0	; F2 30 44 27 11 20 12
	fsglmul.s	([2,A1,A2],4),FP1	; F2 31 44 A7 A1 22 00
	fsglmul.s	([6,A2],D3,8),FP2	; F2 32 45 27 31 26 00
	fsglmul.s	(0x1234,PC,D1),FP3	; F2 3B 45 A7 11 20 12
	fsglmul.s	([2,PC,A2],4),FP4	; F2 3B 46 27 A1 22 FF
	fsglmul.s	([6,PC],D3,8),FP5	; F2 3B 46 A7 31 26 00

	fsglmul.d	(A1),FP2	; F2 11 55 27
	fsglmul.d	(A2)+,FP3	; F2 1A 55 A7
	fsglmul.d	-(A3),FP4	; F2 23 56 27
	fsglmul.d	1(A4),FP5	; F2 2C 56 A7 00 01
	fsglmul.d	2(A5,D7.W),FP6	; F2 35 57 27 70 02
	fsglmul.d	2(A5,D7.L),FP6	; F2 35 57 27 78 02
	fsglmul.d	(0x1234).W,FP7	; F2 38 57 A7 12 34
	fsglmul.d	(0x1234).L,FP7	; F2 39 57 A7 00 00 12
	fsglmul.d	*0xFFFFFFF0,FP0	; F2 38 54 27 FF F0
	fsglmul.d	 0x00010004,FP1	; F2 39 54 A7 00 01 00
	fsglmul.d	5(PC),FP3	; F2 3A 55 A7 00 01
	fsglmul.d	6(PC,A7.W),FP4	; F2 3B 56 27 F0 02
	fsglmul.d	6(PC,A7.L),FP4	; F2 3B 56 27 F8 02
	fsglmul.d	(0x1234,A0,D1),FP0	; F2 30 54 27 11 20 12
	fsglmul.d	([2,A1,A2],4),FP1	; F2 31 54 A7 A1 22 00
	fsglmul.d	([6,A2],D3,8),FP2	; F2 32 55 27 31 26 00
	fsglmul.d	(0x1234,PC,D1),FP3	; F2 3B 55 A7 11 20 12
	fsglmul.d	([2,PC,A2],4),FP4	; F2 3B 56 27 A1 22 FF
	fsglmul.d	([6,PC],D3,8),FP5	; F2 3B 56 A7 31 26 00

	fsglmul.x	FP1,FP2		; F2 00 05 27

	fsglmul.x	(A1),FP2	; F2 11 49 27
	fsglmul.x	(A2)+,FP3	; F2 1A 49 A7
	fsglmul.x	-(A3),FP4	; F2 23 4A 27
	fsglmul.x	1(A4),FP5	; F2 2C 4A A7 00 01
	fsglmul.x	2(A5,D7.W),FP6	; F2 35 4B 27 70 02
	fsglmul.x	2(A5,D7.L),FP6	; F2 35 4B 27 78 02
	fsglmul.x	(0x1234).W,FP7	; F2 38 4B A7 12 34
	fsglmul.x	(0x1234).L,FP7	; F2 39 4B A7 00 00 12
	fsglmul.x	*0xFFFFFFF0,FP0	; F2 38 48 27 FF F0
	fsglmul.x	 0x00010004,FP1	; F2 39 48 A7 00 01 00
	fsglmul.x	5(PC),FP3	; F2 3A 49 A7 00 01
	fsglmul.x	6(PC,A7.W),FP4	; F2 3B 4A 27 F0 02
	fsglmul.x	6(PC,A7.L),FP4	; F2 3B 4A 27 F8 02
	fsglmul.x	(0x1234,A0,D1),FP0	; F2 30 48 27 11 20 12
	fsglmul.x	([2,A1,A2],4),FP1	; F2 31 48 A7 A1 22 00
	fsglmul.x	([6,A2],D3,8),FP2	; F2 32 49 27 31 26 00
	fsglmul.x	(0x1234,PC,D1),FP3	; F2 3B 49 A7 11 20 12
	fsglmul.x	([2,PC,A2],4),FP4	; F2 3B 4A 27 A1 22 FF
	fsglmul.x	([6,PC],D3,8),FP5	; F2 3B 4A A7 31 26 00

	fsglmul.p	(A1),FP2	; F2 11 4D 27
	fsglmul.p	(A2)+,FP3	; F2 1A 4D A7
	fsglmul.p	-(A3),FP4	; F2 23 4E 27
	fsglmul.p	1(A4),FP5	; F2 2C 4E A7 00 01
	fsglmul.p	2(A5,D7.W),FP6	; F2 35 4F 27 70 02
	fsglmul.p	2(A5,D7.L),FP6	; F2 35 4F 27 78 02
	fsglmul.p	(0x1234).W,FP7	; F2 38 4F A7 12 34
	fsglmul.p	(0x1234).L,FP7	; F2 39 4F A7 00 00 12
	fsglmul.p	*0xFFFFFFF0,FP0	; F2 38 4C 27 FF F0
	fsglmul.p	 0x00010004,FP1	; F2 39 4C A7 00 01 00
	fsglmul.p	5(PC),FP3	; F2 3A 4D A7 00 01
	fsglmul.p	6(PC,A7.W),FP4	; F2 3B 4E 27 F0 02
	fsglmul.p	6(PC,A7.L),FP4	; F2 3B 4E 27 F8 02
	fsglmul.p	(0x1234,A0,D1),FP0	; F2 30 4C 27 11 20 12
	fsglmul.p	([2,A1,A2],4),FP1	; F2 31 4C A7 A1 22 00
	fsglmul.p	([6,A2],D3,8),FP2	; F2 32 4D 27 31 26 00
	fsglmul.p	(0x1234,PC,D1),FP3	; F2 3B 4D A7 11 20 12
	fsglmul.p	([2,PC,A2],4),FP4	; F2 3B 4E 27 A1 22 FF
	fsglmul.p	([6,PC],D3,8),FP5	; F2 3B 4E A7 31 26 00

	fsub	FP1,FP2			; F2 00 05 28

	fsub	(A1),FP2		; F2 11 49 28
	fsub	(A2)+,FP3		; F2 1A 49 A8
	fsub	-(A3),FP4		; F2 23 4A 28
	fsub	1(A4),FP5		; F2 2C 4A A8 00 01
	fsub	2(A5,D7.W),FP6		; F2 35 4B 28 70 02
	fsub	2(A5,D7.L),FP6		; F2 35 4B 28 78 02
	fsub	(0x1234).W,FP7		; F2 38 4B A8 12 34
	fsub	(0x1234).L,FP7		; F2 39 4B A8 00 00 12
	fsub	*0xFFFFFFF0,FP0		; F2 38 48 28 FF F0
	fsub	 0x00010004,FP1		; F2 39 48 A8 00 01 00
	fsub	5(PC),FP3		; F2 3A 49 A8 00 01
	fsub	6(PC,A7.W),FP4		; F2 3B 4A 28 F0 02
	fsub	6(PC,A7.L),FP4		; F2 3B 4A 28 F8 02
	fsub	(0x1234,A0,D1),FP0	; F2 30 48 28 11 20 12
	fsub	([2,A1,A2],4),FP1	; F2 31 48 A8 A1 22 00
	fsub	([6,A2],D3,8),FP2	; F2 32 49 28 31 26 00
	fsub	(0x1234,PC,D1),FP3	; F2 3B 49 A8 11 20 12
	fsub	([2,PC,A2],4),FP4	; F2 3B 4A 28 A1 22 FF
	fsub	([6,PC],D3,8),FP5	; F2 3B 4A A8 31 26 00

	fsub.b	D0,FP0			; F2 00 58 28
	fsub.b	(A1),FP2		; F2 11 59 28
	fsub.b	(A2)+,FP3		; F2 1A 59 A8
	fsub.b	-(A3),FP4		; F2 23 5A 28
	fsub.b	1(A4),FP5		; F2 2C 5A A8 00 01
	fsub.b	2(A5,D7.W),FP6		; F2 35 5B 28 70 02
	fsub.b	2(A5,D7.L),FP6		; F2 35 5B 28 78 02
	fsub.b	(0x1234).W,FP7		; F2 38 5B A8 12 34
	fsub.b	(0x1234).L,FP7		; F2 39 5B A8 00 00 12
	fsub.b	*0xFFFFFFF0,FP0		; F2 38 58 28 FF F0
	fsub.b	 0x00010004,FP1		; F2 39 58 A8 00 01 00
	fsub.b	#7,FP2			; F2 3C 59 28 00 07
	fsub.b	5(PC),FP3		; F2 3A 59 A8 00 01
	fsub.b	6(PC,A7.W),FP4		; F2 3B 5A 28 F0 02
	fsub.b	6(PC,A7.L),FP4		; F2 3B 5A 28 F8 02
	fsub.b	(0x1234,A0,D1),FP0	; F2 30 58 28 11 20 12
	fsub.b	([2,A1,A2],4),FP1	; F2 31 58 A8 A1 22 00
	fsub.b	([6,A2],D3,8),FP2	; F2 32 59 28 31 26 00
	fsub.b	(0x1234,PC,D1),FP3	; F2 3B 59 A8 11 20 12
	fsub.b	([2,PC,A2],4),FP4	; F2 3B 5A 28 A1 22 FF
	fsub.b	([6,PC],D3,8),FP5	; F2 3B 5A A8 31 26 00

	fsub.w	D0,FP0			; F2 00 50 28
	fsub.w	(A1),FP2		; F2 11 51 28
	fsub.w	(A2)+,FP3		; F2 1A 51 A8
	fsub.w	-(A3),FP4		; F2 23 52 28
	fsub.w	1(A4),FP5		; F2 2C 52 A8 00 01
	fsub.w	2(A5,D7.W),FP6		; F2 35 53 28 70 02
	fsub.w	2(A5,D7.L),FP6		; F2 35 53 28 78 02
	fsub.w	(0x1234).W,FP7		; F2 38 53 A8 12 34
	fsub.w	(0x1234).L,FP7		; F2 39 53 A8 00 00 12
	fsub.w	*0xFFFFFFF0,FP0		; F2 38 50 28 FF F0
	fsub.w	 0x00010004,FP1		; F2 39 50 A8 00 01 00
	fsub.w	#7,FP2			; F2 3C 51 28 00 07
	fsub.w	5(PC),FP3		; F2 3A 51 A8 00 01
	fsub.w	6(PC,A7.W),FP4		; F2 3B 52 28 F0 02
	fsub.w	6(PC,A7.L),FP4		; F2 3B 52 28 F8 02
	fsub.w	(0x1234,A0,D1),FP0	; F2 30 50 28 11 20 12
	fsub.w	([2,A1,A2],4),FP1	; F2 31 50 A8 A1 22 00
	fsub.w	([6,A2],D3,8),FP2	; F2 32 51 28 31 26 00
	fsub.w	(0x1234,PC,D1),FP3	; F2 3B 51 A8 11 20 12
	fsub.w	([2,PC,A2],4),FP4	; F2 3B 52 28 A1 22 FF
	fsub.w	([6,PC],D3,8),FP5	; F2 3B 52 A8 31 26 00

	fsub.l	D0,FP0			; F2 00 40 28
	fsub.l	(A1),FP2		; F2 11 41 28
	fsub.l	(A2)+,FP3		; F2 1A 41 A8
	fsub.l	-(A3),FP4		; F2 23 42 28
	fsub.l	1(A4),FP5		; F2 2C 42 A8 00 01
	fsub.l	2(A5,D7.W),FP6		; F2 35 43 28 70 02
	fsub.l	2(A5,D7.L),FP6		; F2 35 43 28 78 02
	fsub.l	(0x1234).W,FP7		; F2 38 43 A8 12 34
	fsub.l	(0x1234).L,FP7		; F2 39 43 A8 00 00 12
	fsub.l	*0xFFFFFFF0,FP0		; F2 38 40 28 FF F0
	fsub.l	 0x00010004,FP1		; F2 39 40 A8 00 01 00
	fsub.l	#7,FP2			; F2 3C 41 28 00 00 00
	fsub.l	5(PC),FP3		; F2 3A 41 A8 00 01
	fsub.l	6(PC,A7.W),FP4		; F2 3B 42 28 F0 02
	fsub.l	6(PC,A7.L),FP4		; F2 3B 42 28 F8 02
	fsub.l	(0x1234,A0,D1),FP0	; F2 30 40 28 11 20 12
	fsub.l	([2,A1,A2],4),FP1	; F2 31 40 A8 A1 22 00
	fsub.l	([6,A2],D3,8),FP2	; F2 32 41 28 31 26 00
	fsub.l	(0x1234,PC,D1),FP3	; F2 3B 41 A8 11 20 12
	fsub.l	([2,PC,A2],4),FP4	; F2 3B 42 28 A1 22 FF
	fsub.l	([6,PC],D3,8),FP5	; F2 3B 42 A8 31 26 00

	fsub.s	D0,FP0			; F2 00 44 28
	fsub.s	(A1),FP2		; F2 11 45 28
	fsub.s	(A2)+,FP3		; F2 1A 45 A8
	fsub.s	-(A3),FP4		; F2 23 46 28
	fsub.s	1(A4),FP5		; F2 2C 46 A8 00 01
	fsub.s	2(A5,D7.W),FP6		; F2 35 47 28 70 02
	fsub.s	2(A5,D7.L),FP6		; F2 35 47 28 78 02
	fsub.s	(0x1234).W,FP7		; F2 38 47 A8 12 34
	fsub.s	(0x1234).L,FP7		; F2 39 47 A8 00 00 12
	fsub.s	*0xFFFFFFF0,FP0		; F2 38 44 28 FF F0
	fsub.s	 0x00010004,FP1		; F2 39 44 A8 00 01 00
	fsub.s	#7,FP2			; F2 3C 45 28 40 E0 00
	fsub.s	5(PC),FP3		; F2 3A 45 A8 00 01
	fsub.s	6(PC,A7.W),FP4		; F2 3B 46 28 F0 02
	fsub.s	6(PC,A7.L),FP4		; F2 3B 46 28 F8 02
	fsub.s	(0x1234,A0,D1),FP0	; F2 30 44 28 11 20 12
	fsub.s	([2,A1,A2],4),FP1	; F2 31 44 A8 A1 22 00
	fsub.s	([6,A2],D3,8),FP2	; F2 32 45 28 31 26 00
	fsub.s	(0x1234,PC,D1),FP3	; F2 3B 45 A8 11 20 12
	fsub.s	([2,PC,A2],4),FP4	; F2 3B 46 28 A1 22 FF
	fsub.s	([6,PC],D3,8),FP5	; F2 3B 46 A8 31 26 00

	fsub.d	(A1),FP2		; F2 11 55 28
	fsub.d	(A2)+,FP3		; F2 1A 55 A8
	fsub.d	-(A3),FP4		; F2 23 56 28
	fsub.d	1(A4),FP5		; F2 2C 56 A8 00 01
	fsub.d	2(A5,D7.W),FP6		; F2 35 57 28 70 02
	fsub.d	2(A5,D7.L),FP6		; F2 35 57 28 78 02
	fsub.d	(0x1234).W,FP7		; F2 38 57 A8 12 34
	fsub.d	(0x1234).L,FP7		; F2 39 57 A8 00 00 12
	fsub.d	*0xFFFFFFF0,FP0		; F2 38 54 28 FF F0
	fsub.d	 0x00010004,FP1		; F2 39 54 A8 00 01 00
	fsub.d	5(PC),FP3		; F2 3A 55 A8 00 01
	fsub.d	6(PC,A7.W),FP4		; F2 3B 56 28 F0 02
	fsub.d	6(PC,A7.L),FP4		; F2 3B 56 28 F8 02
	fsub.d	(0x1234,A0,D1),FP0	; F2 30 54 28 11 20 12
	fsub.d	([2,A1,A2],4),FP1	; F2 31 54 A8 A1 22 00
	fsub.d	([6,A2],D3,8),FP2	; F2 32 55 28 31 26 00
	fsub.d	(0x1234,PC,D1),FP3	; F2 3B 55 A8 11 20 12
	fsub.d	([2,PC,A2],4),FP4	; F2 3B 56 28 A1 22 FF
	fsub.d	([6,PC],D3,8),FP5	; F2 3B 56 A8 31 26 00

	fsub.x	FP1,FP2			; F2 00 05 28

	fsub.x	(A1),FP2		; F2 11 49 28
	fsub.x	(A2)+,FP3		; F2 1A 49 A8
	fsub.x	-(A3),FP4		; F2 23 4A 28
	fsub.x	1(A4),FP5		; F2 2C 4A A8 00 01
	fsub.x	2(A5,D7.W),FP6		; F2 35 4B 28 70 02
	fsub.x	2(A5,D7.L),FP6		; F2 35 4B 28 78 02
	fsub.x	(0x1234).W,FP7		; F2 38 4B A8 12 34
	fsub.x	(0x1234).L,FP7		; F2 39 4B A8 00 00 12
	fsub.x	*0xFFFFFFF0,FP0		; F2 38 48 28 FF F0
	fsub.x	 0x00010004,FP1		; F2 39 48 A8 00 01 00
	fsub.x	5(PC),FP3		; F2 3A 49 A8 00 01
	fsub.x	6(PC,A7.W),FP4		; F2 3B 4A 28 F0 02
	fsub.x	6(PC,A7.L),FP4		; F2 3B 4A 28 F8 02
	fsub.x	(0x1234,A0,D1),FP0	; F2 30 48 28 11 20 12
	fsub.x	([2,A1,A2],4),FP1	; F2 31 48 A8 A1 22 00
	fsub.x	([6,A2],D3,8),FP2	; F2 32 49 28 31 26 00
	fsub.x	(0x1234,PC,D1),FP3	; F2 3B 49 A8 11 20 12
	fsub.x	([2,PC,A2],4),FP4	; F2 3B 4A 28 A1 22 FF
	fsub.x	([6,PC],D3,8),FP5	; F2 3B 4A A8 31 26 00

	fsub.p	(A1),FP2		; F2 11 4D 28
	fsub.p	(A2)+,FP3		; F2 1A 4D A8
	fsub.p	-(A3),FP4		; F2 23 4E 28
	fsub.p	1(A4),FP5		; F2 2C 4E A8 00 01
	fsub.p	2(A5,D7.W),FP6		; F2 35 4F 28 70 02
	fsub.p	2(A5,D7.L),FP6		; F2 35 4F 28 78 02
	fsub.p	(0x1234).W,FP7		; F2 38 4F A8 12 34
	fsub.p	(0x1234).L,FP7		; F2 39 4F A8 00 00 12
	fsub.p	*0xFFFFFFF0,FP0		; F2 38 4C 28 FF F0
	fsub.p	 0x00010004,FP1		; F2 39 4C A8 00 01 00
	fsub.p	5(PC),FP3		; F2 3A 4D A8 00 01
	fsub.p	6(PC,A7.W),FP4		; F2 3B 4E 28 F0 02
	fsub.p	6(PC,A7.L),FP4		; F2 3B 4E 28 F8 02
	fsub.p	(0x1234,A0,D1),FP0	; F2 30 4C 28 11 20 12
	fsub.p	([2,A1,A2],4),FP1	; F2 31 4C A8 A1 22 00
	fsub.p	([6,A2],D3,8),FP2	; F2 32 4D 28 31 26 00
	fsub.p	(0x1234,PC,D1),FP3	; F2 3B 4D A8 11 20 12
	fsub.p	([2,PC,A2],4),FP4	; F2 3B 4E 28 A1 22 FF
	fsub.p	([6,PC],D3,8),FP5	; F2 3B 4E A8 31 26 00

	fcmp	FP1,FP2			; F2 00 05 38

	fcmp	(A1),FP2		; F2 11 49 38
	fcmp	(A2)+,FP3		; F2 1A 49 B8
	fcmp	-(A3),FP4		; F2 23 4A 38
	fcmp	1(A4),FP5		; F2 2C 4A B8 00 01
	fcmp	2(A5,D7.W),FP6		; F2 35 4B 38 70 02
	fcmp	2(A5,D7.L),FP6		; F2 35 4B 38 78 02
	fcmp	(0x1234).W,FP7		; F2 38 4B B8 12 34
	fcmp	(0x1234).L,FP7		; F2 39 4B B8 00 00 12
	fcmp	*0xFFFFFFF0,FP0		; F2 38 48 38 FF F0
	fcmp	 0x00010004,FP1		; F2 39 48 B8 00 01 00
	fcmp	5(PC),FP3		; F2 3A 49 B8 00 01
	fcmp	6(PC,A7.W),FP4		; F2 3B 4A 38 F0 02
	fcmp	6(PC,A7.L),FP4		; F2 3B 4A 38 F8 02
	fcmp	(0x1234,A0,D1),FP0	; F2 30 48 38 11 20 12
	fcmp	([2,A1,A2],4),FP1	; F2 31 48 B8 A1 22 00
	fcmp	([6,A2],D3,8),FP2	; F2 32 49 38 31 26 00
	fcmp	(0x1234,PC,D1),FP3	; F2 3B 49 B8 11 20 12
	fcmp	([2,PC,A2],4),FP4	; F2 3B 4A 38 A1 22 FF
	fcmp	([6,PC],D3,8),FP5	; F2 3B 4A B8 31 26 00

	fcmp.b	D0,FP0			; F2 00 58 38
	fcmp.b	(A1),FP2		; F2 11 59 38
	fcmp.b	(A2)+,FP3		; F2 1A 59 B8
	fcmp.b	-(A3),FP4		; F2 23 5A 38
	fcmp.b	1(A4),FP5		; F2 2C 5A B8 00 01
	fcmp.b	2(A5,D7.W),FP6		; F2 35 5B 38 70 02
	fcmp.b	2(A5,D7.L),FP6		; F2 35 5B 38 78 02
	fcmp.b	(0x1234).W,FP7		; F2 38 5B B8 12 34
	fcmp.b	(0x1234).L,FP7		; F2 39 5B B8 00 00 12
	fcmp.b	*0xFFFFFFF0,FP0		; F2 38 58 38 FF F0
	fcmp.b	 0x00010004,FP1		; F2 39 58 B8 00 01 00
	fcmp.b	#7,FP2			; F2 3C 59 38 00 07
	fcmp.b	5(PC),FP3		; F2 3A 59 B8 00 01
	fcmp.b	6(PC,A7.W),FP4		; F2 3B 5A 38 F0 02
	fcmp.b	6(PC,A7.L),FP4		; F2 3B 5A 38 F8 02
	fcmp.b	(0x1234,A0,D1),FP0	; F2 30 58 38 11 20 12
	fcmp.b	([2,A1,A2],4),FP1	; F2 31 58 B8 A1 22 00
	fcmp.b	([6,A2],D3,8),FP2	; F2 32 59 38 31 26 00
	fcmp.b	(0x1234,PC,D1),FP3	; F2 3B 59 B8 11 20 12
	fcmp.b	([2,PC,A2],4),FP4	; F2 3B 5A 38 A1 22 FF
	fcmp.b	([6,PC],D3,8),FP5	; F2 3B 5A B8 31 26 00

	fcmp.w	D0,FP0			; F2 00 50 38
	fcmp.w	(A1),FP2		; F2 11 51 38
	fcmp.w	(A2)+,FP3		; F2 1A 51 B8
	fcmp.w	-(A3),FP4		; F2 23 52 38
	fcmp.w	1(A4),FP5		; F2 2C 52 B8 00 01
	fcmp.w	2(A5,D7.W),FP6		; F2 35 53 38 70 02
	fcmp.w	2(A5,D7.L),FP6		; F2 35 53 38 78 02
	fcmp.w	(0x1234).W,FP7		; F2 38 53 B8 12 34
	fcmp.w	(0x1234).L,FP7		; F2 39 53 B8 00 00 12
	fcmp.w	*0xFFFFFFF0,FP0		; F2 38 50 38 FF F0
	fcmp.w	 0x00010004,FP1		; F2 39 50 B8 00 01 00
	fcmp.w	#7,FP2			; F2 3C 51 38 00 07
	fcmp.w	5(PC),FP3		; F2 3A 51 B8 00 01
	fcmp.w	6(PC,A7.W),FP4		; F2 3B 52 38 F0 02
	fcmp.w	6(PC,A7.L),FP4		; F2 3B 52 38 F8 02
	fcmp.w	(0x1234,A0,D1),FP0	; F2 30 50 38 11 20 12
	fcmp.w	([2,A1,A2],4),FP1	; F2 31 50 B8 A1 22 00
	fcmp.w	([6,A2],D3,8),FP2	; F2 32 51 38 31 26 00
	fcmp.w	(0x1234,PC,D1),FP3	; F2 3B 51 B8 11 20 12
	fcmp.w	([2,PC,A2],4),FP4	; F2 3B 52 38 A1 22 FF
	fcmp.w	([6,PC],D3,8),FP5	; F2 3B 52 B8 31 26 00

	fcmp.l	D0,FP0			; F2 00 40 38
	fcmp.l	(A1),FP2		; F2 11 41 38
	fcmp.l	(A2)+,FP3		; F2 1A 41 B8
	fcmp.l	-(A3),FP4		; F2 23 42 38
	fcmp.l	1(A4),FP5		; F2 2C 42 B8 00 01
	fcmp.l	2(A5,D7.W),FP6		; F2 35 43 38 70 02
	fcmp.l	2(A5,D7.L),FP6		; F2 35 43 38 78 02
	fcmp.l	(0x1234).W,FP7		; F2 38 43 B8 12 34
	fcmp.l	(0x1234).L,FP7		; F2 39 43 B8 00 00 12
	fcmp.l	*0xFFFFFFF0,FP0		; F2 38 40 38 FF F0
	fcmp.l	 0x00010004,FP1		; F2 39 40 B8 00 01 00
	fcmp.l	#7,FP2			; F2 3C 41 38 00 00 00
	fcmp.l	5(PC),FP3		; F2 3A 41 B8 00 01
	fcmp.l	6(PC,A7.W),FP4		; F2 3B 42 38 F0 02
	fcmp.l	6(PC,A7.L),FP4		; F2 3B 42 38 F8 02
	fcmp.l	(0x1234,A0,D1),FP0	; F2 30 40 38 11 20 12
	fcmp.l	([2,A1,A2],4),FP1	; F2 31 40 B8 A1 22 00
	fcmp.l	([6,A2],D3,8),FP2	; F2 32 41 38 31 26 00
	fcmp.l	(0x1234,PC,D1),FP3	; F2 3B 41 B8 11 20 12
	fcmp.l	([2,PC,A2],4),FP4	; F2 3B 42 38 A1 22 FF
	fcmp.l	([6,PC],D3,8),FP5	; F2 3B 42 B8 31 26 00

	fcmp.s	D0,FP0			; F2 00 44 38
	fcmp.s	(A1),FP2		; F2 11 45 38
	fcmp.s	(A2)+,FP3		; F2 1A 45 B8
	fcmp.s	-(A3),FP4		; F2 23 46 38
	fcmp.s	1(A4),FP5		; F2 2C 46 B8 00 01
	fcmp.s	2(A5,D7.W),FP6		; F2 35 47 38 70 02
	fcmp.s	2(A5,D7.L),FP6		; F2 35 47 38 78 02
	fcmp.s	(0x1234).W,FP7		; F2 38 47 B8 12 34
	fcmp.s	(0x1234).L,FP7		; F2 39 47 B8 00 00 12
	fcmp.s	*0xFFFFFFF0,FP0		; F2 38 44 38 FF F0
	fcmp.s	 0x00010004,FP1		; F2 39 44 B8 00 01 00
	fcmp.s	#7,FP2			; F2 3C 45 38 40 E0 00
	fcmp.s	5(PC),FP3		; F2 3A 45 B8 00 01
	fcmp.s	6(PC,A7.W),FP4		; F2 3B 46 38 F0 02
	fcmp.s	6(PC,A7.L),FP4		; F2 3B 46 38 F8 02
	fcmp.s	(0x1234,A0,D1),FP0	; F2 30 44 38 11 20 12
	fcmp.s	([2,A1,A2],4),FP1	; F2 31 44 B8 A1 22 00
	fcmp.s	([6,A2],D3,8),FP2	; F2 32 45 38 31 26 00
	fcmp.s	(0x1234,PC,D1),FP3	; F2 3B 45 B8 11 20 12
	fcmp.s	([2,PC,A2],4),FP4	; F2 3B 46 38 A1 22 FF
	fcmp.s	([6,PC],D3,8),FP5	; F2 3B 46 B8 31 26 00

	fcmp.d	(A1),FP2		; F2 11 55 38
	fcmp.d	(A2)+,FP3		; F2 1A 55 B8
	fcmp.d	-(A3),FP4		; F2 23 56 38
	fcmp.d	1(A4),FP5		; F2 2C 56 B8 00 01
	fcmp.d	2(A5,D7.W),FP6		; F2 35 57 38 70 02
	fcmp.d	2(A5,D7.L),FP6		; F2 35 57 38 78 02
	fcmp.d	(0x1234).W,FP7		; F2 38 57 B8 12 34
	fcmp.d	(0x1234).L,FP7		; F2 39 57 B8 00 00 12
	fcmp.d	*0xFFFFFFF0,FP0		; F2 38 54 38 FF F0
	fcmp.d	 0x00010004,FP1		; F2 39 54 B8 00 01 00
	fcmp.d	5(PC),FP3		; F2 3A 55 B8 00 01
	fcmp.d	6(PC,A7.W),FP4		; F2 3B 56 38 F0 02
	fcmp.d	6(PC,A7.L),FP4		; F2 3B 56 38 F8 02
	fcmp.d	(0x1234,A0,D1),FP0	; F2 30 54 38 11 20 12
	fcmp.d	([2,A1,A2],4),FP1	; F2 31 54 B8 A1 22 00
	fcmp.d	([6,A2],D3,8),FP2	; F2 32 55 38 31 26 00
	fcmp.d	(0x1234,PC,D1),FP3	; F2 3B 55 B8 11 20 12
	fcmp.d	([2,PC,A2],4),FP4	; F2 3B 56 38 A1 22 FF
	fcmp.d	([6,PC],D3,8),FP5	; F2 3B 56 B8 31 26 00

	fcmp.x	FP1,FP2			; F2 00 05 38

	fcmp.x	(A1),FP2		; F2 11 49 38
	fcmp.x	(A2)+,FP3		; F2 1A 49 B8
	fcmp.x	-(A3),FP4		; F2 23 4A 38
	fcmp.x	1(A4),FP5		; F2 2C 4A B8 00 01
	fcmp.x	2(A5,D7.W),FP6		; F2 35 4B 38 70 02
	fcmp.x	2(A5,D7.L),FP6		; F2 35 4B 38 78 02
	fcmp.x	(0x1234).W,FP7		; F2 38 4B B8 12 34
	fcmp.x	(0x1234).L,FP7		; F2 39 4B B8 00 00 12
	fcmp.x	*0xFFFFFFF0,FP0		; F2 38 48 38 FF F0
	fcmp.x	 0x00010004,FP1		; F2 39 48 B8 00 01 00
	fcmp.x	5(PC),FP3		; F2 3A 49 B8 00 01
	fcmp.x	6(PC,A7.W),FP4		; F2 3B 4A 38 F0 02
	fcmp.x	6(PC,A7.L),FP4		; F2 3B 4A 38 F8 02
	fcmp.x	(0x1234,A0,D1),FP0	; F2 30 48 38 11 20 12
	fcmp.x	([2,A1,A2],4),FP1	; F2 31 48 B8 A1 22 00
	fcmp.x	([6,A2],D3,8),FP2	; F2 32 49 38 31 26 00
	fcmp.x	(0x1234,PC,D1),FP3	; F2 3B 49 B8 11 20 12
	fcmp.x	([2,PC,A2],4),FP4	; F2 3B 4A 38 A1 22 FF
	fcmp.x	([6,PC],D3,8),FP5	; F2 3B 4A B8 31 26 00

	fcmp.p	(A1),FP2		; F2 11 4D 38
	fcmp.p	(A2)+,FP3		; F2 1A 4D B8
	fcmp.p	-(A3),FP4		; F2 23 4E 38
	fcmp.p	1(A4),FP5		; F2 2C 4E B8 00 01
	fcmp.p	2(A5,D7.W),FP6		; F2 35 4F 38 70 02
	fcmp.p	2(A5,D7.L),FP6		; F2 35 4F 38 78 02
	fcmp.p	(0x1234).W,FP7		; F2 38 4F B8 12 34
	fcmp.p	(0x1234).L,FP7		; F2 39 4F B8 00 00 12
	fcmp.p	*0xFFFFFFF0,FP0		; F2 38 4C 38 FF F0
	fcmp.p	 0x00010004,FP1		; F2 39 4C B8 00 01 00
	fcmp.p	5(PC),FP3		; F2 3A 4D B8 00 01
	fcmp.p	6(PC,A7.W),FP4		; F2 3B 4E 38 F0 02
	fcmp.p	6(PC,A7.L),FP4		; F2 3B 4E 38 F8 02
	fcmp.p	(0x1234,A0,D1),FP0	; F2 30 4C 38 11 20 12
	fcmp.p	([2,A1,A2],4),FP1	; F2 31 4C B8 A1 22 00
	fcmp.p	([6,A2],D3,8),FP2	; F2 32 4D 38 31 26 00
	fcmp.p	(0x1234,PC,D1),FP3	; F2 3B 4D B8 11 20 12
	fcmp.p	([2,PC,A2],4),FP4	; F2 3B 4E 38 A1 22 FF
	fcmp.p	([6,PC],D3,8),FP5	; F2 3B 4E B8 31 26 00

	.sbttl	Type F_SNCS Instructions: FSINCOS

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  F_SNCS:						*
	;*	FSINCOS						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	fsincos	FP0,FP1:FP2		; F2 00 01 31
	fsincos	FP1,FP6:FP7		; F2 00 07 B6

	fsincos	(A1),FP2:FP1		; F2 11 48 B2
	fsincos	(A2)+,FP3:FP2		; F2 1A 49 33
	fsincos	-(A3),FP4:FP3		; F2 23 49 B4
	fsincos	1(A4),FP5:FP4		; F2 2C 4A 35 00 01
	fsincos	2(A5,D7.W),FP6:FP5	; F2 35 4A B6 70 02
	fsincos	2(A5,D7.L),FP6:FP5	; F2 35 4A B6 78 02
	fsincos	(0x1234).W,FP7:FP0	; F2 38 48 37 12 34
	fsincos	(0x1234).L,FP7:FP0	; F2 39 48 37 00 00 12
	fsincos	*0xFFFFFFF0,FP0:FP7	; F2 38 4B B0 FF F0
	fsincos	 0x00010004,FP1:FP0	; F2 39 48 31 00 01 00
	fsincos	5(PC),FP3:FP2		; F2 3A 49 33 00 01
	fsincos	6(PC,A7.W),FP4:FP3	; F2 3B 49 B4 F0 02
	fsincos	6(PC,A7.L),FP4:FP3	; F2 3B 49 B4 F8 02
	fsincos	(0x1234,A0,D1),FP0:FP7	; F2 30 4B B0 11 20 12
	fsincos	([2,A1,A2],4),FP1:FP0	; F2 31 48 31 A1 22 00
	fsincos	([6,A2],D3,8),FP2:FP1	; F2 32 48 B2 31 26 00
	fsincos	(0x1234,PC,D1),FP3:FP2	; F2 3B 49 33 11 20 12
	fsincos	([2,PC,A2],4),FP4:FP3	; F2 3B 49 B4 A1 22 FF
	fsincos	([6,PC],D3,8),FP5:FP4	; F2 3B 4A 35 31 26 00

	fsincos.b	D0,FP1:FP0	; F2 00 58 31
	fsincos.b	(A1),FP2:FP1	; F2 11 58 B2
	fsincos.b	(A2)+,FP3:FP2	; F2 1A 59 33
	fsincos.b	-(A3),FP4:FP3	; F2 23 59 B4
	fsincos.b	1(A4),FP5:FP4	; F2 2C 5A 35 00 01
	fsincos.b	2(A5,D7.W),FP6:FP5	; F2 35 5A B6 70 02
	fsincos.b	2(A5,D7.L),FP6:FP5	; F2 35 5A B6 78 02
	fsincos.b	(0x1234).W,FP7:FP0	; F2 38 58 37 12 34
	fsincos.b	(0x1234).L,FP7:FP0	; F2 39 58 37 00 00 12
	fsincos.b	*0xFFFFFFF0,FP0:FP7	; F2 38 5B B0 FF F0
	fsincos.b	 0x00010004,FP1:FP0	; F2 39 58 31 00 01 00
	fsincos.b	#7,FP2:FP1	; F2 3C 58 B2 00 07
	fsincos.b	5(PC),FP3:FP2	; F2 3A 59 33 00 01
	fsincos.b	6(PC,A7.W),FP4:FP3	; F2 3B 59 B4 F0 02
	fsincos.b	6(PC,A7.L),FP4:FP3	; F2 3B 59 B4 F8 02
	fsincos.b	(0x1234,A0,D1),FP0:FP7	; F2 30 5B B0 11 20 12
	fsincos.b	([2,A1,A2],4),FP1:FP0	; F2 31 58 31 A1 22 00
	fsincos.b	([6,A2],D3,8),FP2:FP1	; F2 32 58 B2 31 26 00
	fsincos.b	(0x1234,PC,D1),FP3:FP2	; F2 3B 59 33 11 20 12
	fsincos.b	([2,PC,A2],4),FP4:FP3	; F2 3B 59 B4 A1 22 FF
	fsincos.b	([6,PC],D3,8),FP5:FP4	; F2 3B 5A 35 31 26 00

	fsincos.w	D0,FP1:FP0	; F2 00 50 31
	fsincos.w	(A1),FP2:FP1	; F2 11 50 B2
	fsincos.w	(A2)+,FP3:FP2	; F2 1A 51 33
	fsincos.w	-(A3),FP4:FP3	; F2 23 51 B4
	fsincos.w	1(A4),FP5:FP4	; F2 2C 52 35 00 01
	fsincos.w	2(A5,D7.W),FP6:FP5	; F2 35 52 B6 70 02
	fsincos.w	2(A5,D7.L),FP6:FP5	; F2 35 52 B6 78 02
	fsincos.w	(0x1234).W,FP7:FP0	; F2 38 50 37 12 34
	fsincos.w	(0x1234).L,FP7:FP0	; F2 39 50 37 00 00 12
	fsincos.w	*0xFFFFFFF0,FP0:FP7	; F2 38 53 B0 FF F0
	fsincos.w	 0x00010004,FP1:FP0	; F2 39 50 31 00 01 00
	fsincos.w	#7,FP2:FP1	; F2 3C 50 B2 00 07
	fsincos.w	5(PC),FP3:FP2	; F2 3A 51 33 00 01
	fsincos.w	6(PC,A7.W),FP4:FP3	; F2 3B 51 B4 F0 02
	fsincos.w	6(PC,A7.L),FP4:FP3	; F2 3B 51 B4 F8 02
	fsincos.w	(0x1234,A0,D1),FP0:FP7	; F2 30 53 B0 11 20 12
	fsincos.w	([2,A1,A2],4),FP1:FP0	; F2 31 50 31 A1 22 00
	fsincos.w	([6,A2],D3,8),FP2:FP1	; F2 32 50 B2 31 26 00
	fsincos.w	(0x1234,PC,D1),FP3:FP2	; F2 3B 51 33 11 20 12
	fsincos.w	([2,PC,A2],4),FP4:FP3	; F2 3B 51 B4 A1 22 FF
	fsincos.w	([6,PC],D3,8),FP5:FP4	; F2 3B 52 35 31 26 00

	fsincos.l	D0,FP1:FP0	; F2 00 40 31
	fsincos.l	(A1),FP2:FP1	; F2 11 40 B2
	fsincos.l	(A2)+,FP3:FP2	; F2 1A 41 33
	fsincos.l	-(A3),FP4:FP3	; F2 23 41 B4
	fsincos.l	1(A4),FP5:FP4	; F2 2C 42 35 00 01
	fsincos.l	2(A5,D7.W),FP6:FP5	; F2 35 42 B6 70 02
	fsincos.l	2(A5,D7.L),FP6:FP5	; F2 35 42 B6 78 02
	fsincos.l	(0x1234).W,FP7:FP0	; F2 38 40 37 12 34
	fsincos.l	(0x1234).L,FP7:FP0	; F2 39 40 37 00 00 12
	fsincos.l	*0xFFFFFFF0,FP0:FP7	; F2 38 43 B0 FF F0
	fsincos.l	 0x00010004,FP1:FP0	; F2 39 40 31 00 01 00
	fsincos.l	#7,FP2:FP1	; F2 3C 40 B2 00 00 00
	fsincos.l	5(PC),FP3:FP2	; F2 3A 41 33 00 01
	fsincos.l	6(PC,A7.W),FP4:FP3	; F2 3B 41 B4 F0 02
	fsincos.l	6(PC,A7.L),FP4:FP3	; F2 3B 41 B4 F8 02
	fsincos.l	(0x1234,A0,D1),FP0:FP7	; F2 30 43 B0 11 20 12
	fsincos.l	([2,A1,A2],4),FP1:FP0	; F2 31 40 31 A1 22 00
	fsincos.l	([6,A2],D3,8),FP2:FP1	; F2 32 40 B2 31 26 00
	fsincos.l	(0x1234,PC,D1),FP3:FP2	; F2 3B 41 33 11 20 12
	fsincos.l	([2,PC,A2],4),FP4:FP3	; F2 3B 41 B4 A1 22 FF
	fsincos.l	([6,PC],D3,8),FP5:FP4	; F2 3B 42 35 31 26 00

	fsincos.s	D0,FP1:FP0	; F2 00 44 31
	fsincos.s	(A1),FP2:FP1	; F2 11 44 B2
	fsincos.s	(A2)+,FP3:FP2	; F2 1A 45 33
	fsincos.s	-(A3),FP4:FP3	; F2 23 45 B4
	fsincos.s	1(A4),FP5:FP4	; F2 2C 46 35 00 01
	fsincos.s	2(A5,D7.W),FP6:FP5	; F2 35 46 B6 70 02
	fsincos.s	2(A5,D7.L),FP6:FP5	; F2 35 46 B6 78 02
	fsincos.s	(0x1234).W,FP7:FP0	; F2 38 44 37 12 34
	fsincos.s	(0x1234).L,FP7:FP0	; F2 39 44 37 00 00 12
	fsincos.s	*0xFFFFFFF0,FP0:FP7	; F2 38 47 B0 FF F0
	fsincos.s	 0x00010004,FP1:FP0	; F2 39 44 31 00 01 00
	fsincos.s	#7,FP2:FP1	; F2 3C 44 B2 40 E0 00
	fsincos.s	5(PC),FP3:FP2	; F2 3A 45 33 00 01
	fsincos.s	6(PC,A7.W),FP4:FP3	; F2 3B 45 B4 F0 02
	fsincos.s	6(PC,A7.L),FP4:FP3	; F2 3B 45 B4 F8 02
	fsincos.s	(0x1234,A0,D1),FP0:FP7	; F2 30 47 B0 11 20 12
	fsincos.s	([2,A1,A2],4),FP1:FP0	; F2 31 44 31 A1 22 00
	fsincos.s	([6,A2],D3,8),FP2:FP1	; F2 32 44 B2 31 26 00
	fsincos.s	(0x1234,PC,D1),FP3:FP2	; F2 3B 45 33 11 20 12
	fsincos.s	([2,PC,A2],4),FP4:FP3	; F2 3B 45 B4 A1 22 FF
	fsincos.s	([6,PC],D3,8),FP5:FP4	; F2 3B 46 35 31 26 00

	fsincos.d	(A1),FP2:FP1	; F2 11 54 B2
	fsincos.d	(A2)+,FP3:FP2	; F2 1A 55 33
	fsincos.d	-(A3),FP4:FP3	; F2 23 55 B4
	fsincos.d	1(A4),FP5:FP4	; F2 2C 56 35 00 01
	fsincos.d	2(A5,D7.W),FP6:FP5	; F2 35 56 B6 70 02
	fsincos.d	2(A5,D7.L),FP6:FP5	; F2 35 56 B6 78 02
	fsincos.d	(0x1234).W,FP7:FP0	; F2 38 54 37 12 34
	fsincos.d	(0x1234).L,FP7:FP0	; F2 39 54 37 00 00 12
	fsincos.d	*0xFFFFFFF0,FP0:FP7	; F2 38 57 B0 FF F0
	fsincos.d	 0x00010004,FP1:FP0	; F2 39 54 31 00 01 00
	fsincos.d	5(PC),FP3:FP2	; F2 3A 55 33 00 01
	fsincos.d	6(PC,A7.W),FP4:FP3	; F2 3B 55 B4 F0 02
	fsincos.d	6(PC,A7.L),FP4:FP3	; F2 3B 55 B4 F8 02
	fsincos.d	(0x1234,A0,D1),FP0:FP7	; F2 30 57 B0 11 20 12
	fsincos.d	([2,A1,A2],4),FP1:FP0	; F2 31 54 31 A1 22 00
	fsincos.d	([6,A2],D3,8),FP2:FP1	; F2 32 54 B2 31 26 00
	fsincos.d	(0x1234,PC,D1),FP3:FP2	; F2 3B 55 33 11 20 12
	fsincos.d	([2,PC,A2],4),FP4:FP3	; F2 3B 55 B4 A1 22 FF
	fsincos.d	([6,PC],D3,8),FP5:FP4	; F2 3B 56 35 31 26 00

	fsincos.x	FP0,FP1:FP2	; F2 00 01 31
	fsincos.x	FP1,FP6:FP7	; F2 00 07 B6

	fsincos.x	(A1),FP2:FP1	; F2 11 48 B2
	fsincos.x	(A2)+,FP3:FP2	; F2 1A 49 33
	fsincos.x	-(A3),FP4:FP3	; F2 23 49 B4
	fsincos.x	1(A4),FP5:FP4	; F2 2C 4A 35 00 01
	fsincos.x	2(A5,D7.W),FP6:FP5	; F2 35 4A B6 70 02
	fsincos.x	2(A5,D7.L),FP6:FP5	; F2 35 4A B6 78 02
	fsincos.x	(0x1234).W,FP7:FP0	; F2 38 48 37 12 34
	fsincos.x	(0x1234).L,FP7:FP0	; F2 39 48 37 00 00 12
	fsincos.x	*0xFFFFFFF0,FP0:FP7	; F2 38 4B B0 FF F0
	fsincos.x	 0x00010004,FP1:FP0	; F2 39 48 31 00 01 00
	fsincos.x	5(PC),FP3:FP2	; F2 3A 49 33 00 01
	fsincos.x	6(PC,A7.W),FP4:FP3	; F2 3B 49 B4 F0 02
	fsincos.x	6(PC,A7.L),FP4:FP3	; F2 3B 49 B4 F8 02
	fsincos.x	(0x1234,A0,D1),FP0:FP7	; F2 30 4B B0 11 20 12
	fsincos.x	([2,A1,A2],4),FP1:FP0	; F2 31 48 31 A1 22 00
	fsincos.x	([6,A2],D3,8),FP2:FP1	; F2 32 48 B2 31 26 00
	fsincos.x	(0x1234,PC,D1),FP3:FP2	; F2 3B 49 33 11 20 12
	fsincos.x	([2,PC,A2],4),FP4:FP3	; F2 3B 49 B4 A1 22 FF
	fsincos.x	([6,PC],D3,8),FP5:FP4	; F2 3B 4A 35 31 26 00

	fsincos.p	(A1),FP2:FP1	; F2 11 4C B2
	fsincos.p	(A2)+,FP3:FP2	; F2 1A 4D 33
	fsincos.p	-(A3),FP4:FP3	; F2 23 4D B4
	fsincos.p	1(A4),FP5:FP4	; F2 2C 4E 35 00 01
	fsincos.p	2(A5,D7.W),FP6:FP5	; F2 35 4E B6 70 02
	fsincos.p	2(A5,D7.L),FP6:FP5	; F2 35 4E B6 78 02
	fsincos.p	(0x1234).W,FP7:FP0	; F2 38 4C 37 12 34
	fsincos.p	(0x1234).L,FP7:FP0	; F2 39 4C 37 00 00 12
	fsincos.p	*0xFFFFFFF0,FP0:FP7	; F2 38 4F B0 FF F0
	fsincos.p	 0x00010004,FP1:FP0	; F2 39 4C 31 00 01 00
	fsincos.p	5(PC),FP3:FP2	; F2 3A 4D 33 00 01
	fsincos.p	6(PC,A7.W),FP4:FP3	; F2 3B 4D B4 F0 02
	fsincos.p	6(PC,A7.L),FP4:FP3	; F2 3B 4D B4 F8 02
	fsincos.p	(0x1234,A0,D1),FP0:FP7	; F2 30 4F B0 11 20 12
	fsincos.p	([2,A1,A2],4),FP1:FP0	; F2 31 4C 31 A1 22 00
	fsincos.p	([6,A2],D3,8),FP2:FP1	; F2 32 4C B2 31 26 00
	fsincos.p	(0x1234,PC,D1),FP3:FP2	; F2 3B 4D 33 11 20 12
	fsincos.p	([2,PC,A2],4),FP4:FP3	; F2 3B 4D B4 A1 22 FF
	fsincos.p	([6,PC],D3,8),FP5:FP4	; F2 3B 4E 35 31 26 00

	.sbttl	Type F_TST Instructions: FTST

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  F_TST:						*
	;*	FTST						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	ftst	FP7			; F2 00 1C 3A

	ftst	(A0)			; F2 10 48 3A
	ftst	(A1)+			; F2 19 48 3A
	ftst	-(A2)			; F2 22 48 3A
	ftst	(1,A3)			; F2 2B 48 3A 00 01
	ftst	(2,A1,D2)		; F2 31 48 3A 20 02
	ftst	(0x1234).W		; F2 38 48 3A 12 34
	ftst	(0x1234).L		; F2 39 48 3A 00 00 12
	ftst	*0xFFFFFFF0		; F2 38 48 3A FF F0
	ftst	 0x00010004		; F2 39 48 3A 00 01 00
	ftst	(0x1234,A0,D1)		; F2 30 48 3A 11 20 12
	ftst	([2,A1,A2],4)		; F2 31 48 3A A1 22 00
	ftst	([6,A2],D3,8)		; F2 32 48 3A 31 26 00
	ftst	(2,PC)			; F2 3A 48 3A FF FE
	ftst	(4,PC,A2)		; F2 3B 48 3A A0 00
	ftst	(0x1234,PC,D1)		; F2 3B 48 3A 11 20 12
	ftst	([2,PC,A2],4)		; F2 3B 48 3A A1 22 FF
	ftst	([6,PC],D3,8)		; F2 3B 48 3A 31 26 00

	ftst.b	D0			; F2 00 58 3A
	ftst.b	(A0)			; F2 10 58 3A
	ftst.b	(A1)+			; F2 19 58 3A
	ftst.b	-(A2)			; F2 22 58 3A
	ftst.b	(1,A3)			; F2 2B 58 3A 00 01
	ftst.b	(2,A1,D2)		; F2 31 58 3A 20 02
	ftst.b	(0x1234).W		; F2 38 58 3A 12 34
	ftst.b	(0x1234).L		; F2 39 58 3A 00 00 12
	ftst.b	*0xFFFFFFF0		; F2 38 58 3A FF F0
	ftst.b	 0x00010004		; F2 39 58 3A 00 01 00
	ftst.b	(0x1234,A0,D1)		; F2 30 58 3A 11 20 12
	ftst.b	([2,A1,A2],4)		; F2 31 58 3A A1 22 00
	ftst.b	([6,A2],D3,8)		; F2 32 58 3A 31 26 00
	ftst.b	#3			; F2 3C 58 3A 00 03
	ftst.b	(2,PC)			; F2 3A 58 3A FF FE
	ftst.b	(4,PC,A2)		; F2 3B 58 3A A0 00
	ftst.b	(0x1234,PC,D1)		; F2 3B 58 3A 11 20 12
	ftst.b	([2,PC,A2],4)		; F2 3B 58 3A A1 22 FF
	ftst.b	([6,PC],D3,8)		; F2 3B 58 3A 31 26 00

	ftst.w	D0			; F2 00 50 3A
	ftst.w	(A0)			; F2 10 50 3A
	ftst.w	(A1)+			; F2 19 50 3A
	ftst.w	-(A2)			; F2 22 50 3A
	ftst.w	(1,A3)			; F2 2B 50 3A 00 01
	ftst.w	(2,A1,D2)		; F2 31 50 3A 20 02
	ftst.w	(0x1234).W		; F2 38 50 3A 12 34
	ftst.w	(0x1234).L		; F2 39 50 3A 00 00 12
	ftst.w	*0xFFFFFFF0		; F2 38 50 3A FF F0
	ftst.w	 0x00010004		; F2 39 50 3A 00 01 00
	ftst.w	(0x1234,A0,D1)		; F2 30 50 3A 11 20 12
	ftst.w	([2,A1,A2],4)		; F2 31 50 3A A1 22 00
	ftst.w	([6,A2],D3,8)		; F2 32 50 3A 31 26 00
	ftst.w	#3			; F2 3C 50 3A 00 03
	ftst.w	(2,PC)			; F2 3A 50 3A FF FE
	ftst.w	(4,PC,A2)		; F2 3B 50 3A A0 00
	ftst.w	(0x1234,PC,D1)		; F2 3B 50 3A 11 20 12
	ftst.w	([2,PC,A2],4)		; F2 3B 50 3A A1 22 FF
	ftst.w	([6,PC],D3,8)		; F2 3B 50 3A 31 26 00

	ftst.l	D0			; F2 00 40 3A
	ftst.l	(A0)			; F2 10 40 3A
	ftst.l	(A1)+			; F2 19 40 3A
	ftst.l	-(A2)			; F2 22 40 3A
	ftst.l	(1,A3)			; F2 2B 40 3A 00 01
	ftst.l	(2,A1,D2)		; F2 31 40 3A 20 02
	ftst.l	(0x1234).W		; F2 38 40 3A 12 34
	ftst.l	(0x1234).L		; F2 39 40 3A 00 00 12
	ftst.l	*0xFFFFFFF0		; F2 38 40 3A FF F0
	ftst.l	 0x00010004		; F2 39 40 3A 00 01 00
	ftst.l	(0x1234,A0,D1)		; F2 30 40 3A 11 20 12
	ftst.l	([2,A1,A2],4)		; F2 31 40 3A A1 22 00
	ftst.l	([6,A2],D3,8)		; F2 32 40 3A 31 26 00
	ftst.l	#3			; F2 3C 40 3A 00 00 00
	ftst.l	(2,PC)			; F2 3A 40 3A FF FE
	ftst.l	(4,PC,A2)		; F2 3B 40 3A A0 00
	ftst.l	(0x1234,PC,D1)		; F2 3B 40 3A 11 20 12
	ftst.l	([2,PC,A2],4)		; F2 3B 40 3A A1 22 FF
	ftst.l	([6,PC],D3,8)		; F2 3B 40 3A 31 26 00

	ftst.s	D0			; F2 00 44 3A
	ftst.s	(A0)			; F2 10 44 3A
	ftst.s	(A1)+			; F2 19 44 3A
	ftst.s	-(A2)			; F2 22 44 3A
	ftst.s	(1,A3)			; F2 2B 44 3A 00 01
	ftst.s	(2,A1,D2)		; F2 31 44 3A 20 02
	ftst.s	(0x1234).W		; F2 38 44 3A 12 34
	ftst.s	(0x1234).L		; F2 39 44 3A 00 00 12
	ftst.s	*0xFFFFFFF0		; F2 38 44 3A FF F0
	ftst.s	 0x00010004		; F2 39 44 3A 00 01 00
	ftst.s	(0x1234,A0,D1)		; F2 30 44 3A 11 20 12
	ftst.s	([2,A1,A2],4)		; F2 31 44 3A A1 22 00
	ftst.s	([6,A2],D3,8)		; F2 32 44 3A 31 26 00
	ftst.s	#3			; F2 3C 44 3A 40 40 00
	ftst.s	(2,PC)			; F2 3A 44 3A FF FE
	ftst.s	(4,PC,A2)		; F2 3B 44 3A A0 00
	ftst.s	(0x1234,PC,D1)		; F2 3B 44 3A 11 20 12
	ftst.s	([2,PC,A2],4)		; F2 3B 44 3A A1 22 FF
	ftst.s	([6,PC],D3,8)		; F2 3B 44 3A 31 26 00

	ftst.d	(A0)			; F2 10 54 3A
	ftst.d	(A1)+			; F2 19 54 3A
	ftst.d	-(A2)			; F2 22 54 3A
	ftst.d	(1,A3)			; F2 2B 54 3A 00 01
	ftst.d	(2,A1,D2)		; F2 31 54 3A 20 02
	ftst.d	(0x1234).W		; F2 38 54 3A 12 34
	ftst.d	(0x1234).L		; F2 39 54 3A 00 00 12
	ftst.d	*0xFFFFFFF0		; F2 38 54 3A FF F0
	ftst.d	 0x00010004		; F2 39 54 3A 00 01 00
	ftst.d	(0x1234,A0,D1)		; F2 30 54 3A 11 20 12
	ftst.d	([2,A1,A2],4)		; F2 31 54 3A A1 22 00
	ftst.d	([6,A2],D3,8)		; F2 32 54 3A 31 26 00
	ftst.d	(2,PC)			; F2 3A 54 3A FF FE
	ftst.d	(4,PC,A2)		; F2 3B 54 3A A0 00
	ftst.d	(0x1234,PC,D1)		; F2 3B 54 3A 11 20 12
	ftst.d	([2,PC,A2],4)		; F2 3B 54 3A A1 22 FF
	ftst.d	([6,PC],D3,8)		; F2 3B 54 3A 31 26 00

	ftst.x	FP7			; F2 00 1C 3A

	ftst.x	(A0)			; F2 10 48 3A
	ftst.x	(A1)+			; F2 19 48 3A
	ftst.x	-(A2)			; F2 22 48 3A
	ftst.x	(1,A3)			; F2 2B 48 3A 00 01
	ftst.x	(2,A1,D2)		; F2 31 48 3A 20 02
	ftst.x	(0x1234).W		; F2 38 48 3A 12 34
	ftst.x	(0x1234).L		; F2 39 48 3A 00 00 12
	ftst.x	*0xFFFFFFF0		; F2 38 48 3A FF F0
	ftst.x	 0x00010004		; F2 39 48 3A 00 01 00
	ftst.x	(0x1234,A0,D1)		; F2 30 48 3A 11 20 12
	ftst.x	([2,A1,A2],4)		; F2 31 48 3A A1 22 00
	ftst.x	([6,A2],D3,8)		; F2 32 48 3A 31 26 00
	ftst.x	(2,PC)			; F2 3A 48 3A FF FE
	ftst.x	(4,PC,A2)		; F2 3B 48 3A A0 00
	ftst.x	(0x1234,PC,D1)		; F2 3B 48 3A 11 20 12
	ftst.x	([2,PC,A2],4)		; F2 3B 48 3A A1 22 FF
	ftst.x	([6,PC],D3,8)		; F2 3B 48 3A 31 26 00

	ftst.p	(A0)			; F2 10 4C 3A
	ftst.p	(A1)+			; F2 19 4C 3A
	ftst.p	-(A2)			; F2 22 4C 3A
	ftst.p	(1,A3)			; F2 2B 4C 3A 00 01
	ftst.p	(2,A1,D2)		; F2 31 4C 3A 20 02
	ftst.p	(0x1234).W		; F2 38 4C 3A 12 34
	ftst.p	(0x1234).L		; F2 39 4C 3A 00 00 12
	ftst.p	*0xFFFFFFF0		; F2 38 4C 3A FF F0
	ftst.p	 0x00010004		; F2 39 4C 3A 00 01 00
	ftst.p	(0x1234,A0,D1)		; F2 30 4C 3A 11 20 12
	ftst.p	([2,A1,A2],4)		; F2 31 4C 3A A1 22 00
	ftst.p	([6,A2],D3,8)		; F2 32 4C 3A 31 26 00
	ftst.p	(2,PC)			; F2 3A 4C 3A FF FE
	ftst.p	(4,PC,A2)		; F2 3B 4C 3A A0 00
	ftst.p	(0x1234,PC,D1)		; F2 3B 4C 3A 11 20 12
	ftst.p	([2,PC,A2],4)		; F2 3B 4C 3A A1 22 FF
	ftst.p	([6,PC],D3,8)		; F2 3B 4C 3A 31 26 00

	.sbttl	Type F_MOV Instructions: FMOVE

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  F_MOV:						*
	;*	FMOVE						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	fmove	D0,FPCR			; F2 00 90 00
	fmove	FPIAR,A0		; F2 08 A4 00
	fmove	FPSR,(A0)		; F2 10 A8 00
	fmove	(A1)+,FPCR		; F2 19 90 00
	fmove	FPSR,-(A2)		; F2 22 A8 00
	fmove	1(A3),FPSR		; F2 2B 88 00 00 01
	fmove	FPCR,2(A5,D7.W)		; F2 35 B0 00 70 02
	fmove	2(A5,D7.L),FPCR		; F2 35 90 00 78 02
	fmove	FPSR,(0x1234).W		; F2 38 A8 00 12 34
	fmove	(0x1234).L,FPSR		; F2 39 88 00 00 00 12
	fmove	FPCR,*0xFFFFFFF0	; F2 38 B0 00 FF F0
	fmove	 0x00010004,FPSR	; F2 39 88 00 00 01 00
	fmove	FPSR,(0x1234,A0,D1)	; F2 30 A8 00 11 20 12
	fmove	([2,A1,A2],4),FPCR	; F2 31 90 00 A1 22 00
	fmove	FPCR,([6,A2],D3,8)	; F2 32 B0 00 31 26 00
	fmove	#5,FPSR			; F2 3C 88 00 00 00 00
	fmove	(PC),FPCR		; F2 3A 90 00 FF FC
	fmove	2(PC,D2),FPSR		; F2 3B 88 00 20 FE
	fmove	(0x1234,PC,D1),FPCR	; F2 3B 90 00 11 20 12
	fmove	([2,PC,A2],4),FPSR	; F2 3B 88 00 A1 22 FF
	fmove	([6,PC],D3,8),FPCR	; F2 3B 90 00 31 26 00

	fmove	(A0),FP1		; F2 10 48 80
	fmove	(A1)+,FP2		; F2 19 49 00
	fmove	-(A2),FP3		; F2 22 49 80
	fmove	0x1234(A3),FP4		; F2 2B 4A 00 12 34
	fmove	(2,A4,D2.W),FP5		; F2 34 4A 80 20 02
	fmove	(2,A5,D4.L),FP6		; F2 35 4B 00 48 02
	fmove	(0x1024).W,FP7		; F2 38 4B 80 10 24
	fmove	(0x1234).L,FP0		; F2 39 48 00 00 00 12
	fmove	*0xFFFFFFF0,FP1		; F2 38 48 80 FF F0
	fmove	 0x00010004,FP2		; F2 39 49 00 00 01 00
	fmove	(0x1234,A0,D1),FP3	; F2 30 49 80 11 20 12
	fmove	([2,A1,A2],4),FP4	; F2 31 4A 00 A1 22 00
	fmove	([6,A2],D3,8),FP5	; F2 32 4A 80 31 26 00
	fmove	0x1234(PC),FP4		; F2 3A 4A 00 12 30
	fmove	(2,PC,D2.W),FP5		; F2 3B 4A 80 20 FE
	fmove	(2,PC,D4.L),FP6		; F2 3B 4B 00 48 FE
	fmove	(0x1234,PC,D1),FP7	; F2 3B 4B 80 11 20 12
	fmove	([2,PC,A2],4),FP0	; F2 3B 48 00 A1 22 FF
	fmove	([6,PC],D3,8),FP1	; F2 3B 48 80 31 26 00

	fmove	FP1,(A0)		; F2 10 68 80
	fmove	FP2,(A1)+		; F2 19 69 00
	fmove	FP3,-(A2)		; F2 22 69 80
	fmove	FP4,0x1234(A3)		; F2 2B 6A 00 12 34
	fmove	FP5,(2,A4,D2.W)		; F2 34 6A 80 20 02
	fmove	FP6,(2,A5,D4.L)		; F2 35 6B 00 48 02
	fmove	FP7,(0x1234).W		; F2 38 6B 80 12 34
	fmove	FP0,(0x1234).L		; F2 39 68 00 00 00 12
	fmove	FP1,*0xFFFFFFF0		; F2 38 68 80 FF F0
	fmove	FP2, 0x00010004		; F2 39 69 00 00 01 00
	fmove	FP3,(0x1234,A0,D1)	; F2 30 69 80 11 20 12
	fmove	FP4,([2,A1,A2],4)	; F2 31 6A 00 A1 22 00
	fmove	FP5,([6,A2],D3,8)	; F2 32 6A 80 31 26 00

	fmove.b	D0,FP0			; F2 00 58 00
	fmove.b	(A0),FP1		; F2 10 58 80
	fmove.b	(A1)+,FP2		; F2 19 59 00
	fmove.b	-(A2),FP3		; F2 22 59 80
	fmove.b	0x1234(A3),FP4		; F2 2B 5A 00 12 34
	fmove.b	(2,A4,D2.W),FP5		; F2 34 5A 80 20 02
	fmove.b	(2,A5,D4.L),FP6		; F2 35 5B 00 48 02
	fmove.b	(0x1024).W,FP7		; F2 38 5B 80 10 24
	fmove.b	(0x1234).L,FP0		; F2 39 58 00 00 00 12
	fmove.b	*0xFFFFFFF0,FP1		; F2 38 58 80 FF F0
	fmove.b	 0x00010004,FP2		; F2 39 59 00 00 01 00
	fmove.b	(0x1234,A0,D1),FP3	; F2 30 59 80 11 20 12
	fmove.b	([2,A1,A2],4),FP4	; F2 31 5A 00 A1 22 00
	fmove.b	([6,A2],D3,8),FP5	; F2 32 5A 80 31 26 00
	fmove.b	#1024.,FP6		; F2 3C 5B 00 00 00
	fmove.b	0x1234(PC),FP4		; F2 3A 5A 00 12 30
	fmove.b	(2,PC,D2.W),FP5		; F2 3B 5A 80 20 FE
	fmove.b	(2,PC,D4.L),FP6		; F2 3B 5B 00 48 FE
	fmove.b	(0x1234,PC,D1),FP7	; F2 3B 5B 80 11 20 12
	fmove.b	([2,PC,A2],4),FP0	; F2 3B 58 00 A1 22 FF
	fmove.b	([6,PC],D3,8),FP1	; F2 3B 58 80 31 26 00

	fmove.b	FP0,D0			; F2 00 78 00
	fmove.b	FP1,(A0)		; F2 10 78 80
	fmove.b	FP2,(A1)+		; F2 19 79 00
	fmove.b	FP3,-(A2)		; F2 22 79 80
	fmove.b	FP4,0x1234(A3)		; F2 2B 7A 00 12 34
	fmove.b	FP5,(2,A4,D2.W)		; F2 34 7A 80 20 02
	fmove.b	FP6,(2,A5,D4.L)		; F2 35 7B 00 48 02
	fmove.b	FP7,(0x1234).W		; F2 38 7B 80 12 34
	fmove.b	FP0,(0x1234).L		; F2 39 78 00 00 00 12
	fmove.b	FP1,*0xFFFFFFF0		; F2 38 78 80 FF F0
	fmove.b	FP2, 0x00010004		; F2 39 79 00 00 01 00
	fmove.b	FP3,(0x1234,A0,D1)	; F2 30 79 80 11 20 12
	fmove.b	FP4,([2,A1,A2],4)	; F2 31 7A 00 A1 22 00
	fmove.b	FP5,([6,A2],D3,8)	; F2 32 7A 80 31 26 00

	fmove.w	D0,FP0			; F2 00 50 00
	fmove.w	(A0),FP1		; F2 10 50 80
	fmove.w	(A1)+,FP2		; F2 19 51 00
	fmove.w	-(A2),FP3		; F2 22 51 80
	fmove.w	0x1234(A3),FP4		; F2 2B 52 00 12 34
	fmove.w	(2,A4,D2.W),FP5		; F2 34 52 80 20 02
	fmove.w	(2,A5,D4.L),FP6		; F2 35 53 00 48 02
	fmove.w	(0x1024).W,FP7		; F2 38 53 80 10 24
	fmove.w	(0x1234).L,FP0		; F2 39 50 00 00 00 12
	fmove.w	*0xFFFFFFF0,FP1		; F2 38 50 80 FF F0
	fmove.w	 0x00010004,FP2		; F2 39 51 00 00 01 00
	fmove.w	(0x1234,A0,D1),FP3	; F2 30 51 80 11 20 12
	fmove.w	([2,A1,A2],4),FP4	; F2 31 52 00 A1 22 00
	fmove.w	([6,A2],D3,8),FP5	; F2 32 52 80 31 26 00
	fmove.w	#1024.,FP6		; F2 3C 53 00 04 00
	fmove.w	0x1234(PC),FP4		; F2 3A 52 00 12 30
	fmove.w	(2,PC,D2.W),FP5		; F2 3B 52 80 20 FE
	fmove.w	(2,PC,D4.L),FP6		; F2 3B 53 00 48 FE
	fmove.w	(0x1234,PC,D1),FP7	; F2 3B 53 80 11 20 12
	fmove.w	([2,PC,A2],4),FP0	; F2 3B 50 00 A1 22 FF
	fmove.w	([6,PC],D3,8),FP1	; F2 3B 50 80 31 26 00

	fmove.w	FP0,D0			; F2 00 70 00
	fmove.w	FP1,(A0)		; F2 10 70 80
	fmove.w	FP2,(A1)+		; F2 19 71 00
	fmove.w	FP3,-(A2)		; F2 22 71 80
	fmove.w	FP4,0x1234(A3)		; F2 2B 72 00 12 34
	fmove.w	FP5,(2,A4,D2.W)		; F2 34 72 80 20 02
	fmove.w	FP6,(2,A5,D4.L)		; F2 35 73 00 48 02
	fmove.w	FP7,(0x1234).W		; F2 38 73 80 12 34
	fmove.w	FP0,(0x1234).L		; F2 39 70 00 00 00 12
	fmove.w	FP1,*0xFFFFFFF0		; F2 38 70 80 FF F0
	fmove.w	FP2, 0x00010004		; F2 39 71 00 00 01 00
	fmove.w	FP3,(0x1234,A0,D1)	; F2 30 71 80 11 20 12
	fmove.w	FP4,([2,A1,A2],4)	; F2 31 72 00 A1 22 00
	fmove.w	FP5,([6,A2],D3,8)	; F2 32 72 80 31 26 00

	fmove.l	D0,FPCR			; F2 00 90 00
	fmove.l	FPIAR,A0		; F2 08 A4 00
	fmove.l	FPSR,(A0)		; F2 10 A8 00
	fmove.l	(A1)+,FPCR		; F2 19 90 00
	fmove.l	FPSR,-(A2)		; F2 22 A8 00
	fmove.l	1(A3),FPSR		; F2 2B 88 00 00 01
	fmove.l	FPCR,2(A5,D7.W)		; F2 35 B0 00 70 02
	fmove.l	2(A5,D7.L),FPCR		; F2 35 90 00 78 02
	fmove.l	FPSR,(0x1234).W		; F2 38 A8 00 12 34
	fmove.l	(0x1234).L,FPSR		; F2 39 88 00 00 00 12
	fmove.l	FPCR,*0xFFFFFFF0	; F2 38 B0 00 FF F0
	fmove.l	 0x00010004,FPSR	; F2 39 88 00 00 01 00
	fmove.l	FPSR,(0x1234,A0,D1)	; F2 30 A8 00 11 20 12
	fmove.l	([2,A1,A2],4),FPCR	; F2 31 90 00 A1 22 00
	fmove.l	FPCR,([6,A2],D3,8)	; F2 32 B0 00 31 26 00
	fmove.l	#5,FPSR			; F2 3C 88 00 00 00 00
	fmove.l	(PC),FPCR		; F2 3A 90 00 FF FC
	fmove.l	2(PC,D2),FPSR		; F2 3B 88 00 20 FE
	fmove.l	(0x1234,PC,D1),FPCR	; F2 3B 90 00 11 20 12
	fmove.l	([2,PC,A2],4),FPSR	; F2 3B 88 00 A1 22 FF
	fmove.l	([6,PC],D3,8),FPCR	; F2 3B 90 00 31 26 00

	fmove.l	D0,FP0			; F2 00 40 00
	fmove.l	(A0),FP1		; F2 10 40 80
	fmove.l	(A1)+,FP2		; F2 19 41 00
	fmove.l	-(A2),FP3		; F2 22 41 80
	fmove.l	0x1234(A3),FP4		; F2 2B 42 00 12 34
	fmove.l	(2,A4,D2.W),FP5		; F2 34 42 80 20 02
	fmove.l	(2,A5,D4.L),FP6		; F2 35 43 00 48 02
	fmove.l	(0x1024).W,FP7		; F2 38 43 80 10 24
	fmove.l	(0x1234).L,FP0		; F2 39 40 00 00 00 12
	fmove.l	*0xFFFFFFF0,FP1		; F2 38 40 80 FF F0
	fmove.l	 0x00010004,FP2		; F2 39 41 00 00 01 00
	fmove.l	(0x1234,A0,D1),FP3	; F2 30 41 80 11 20 12
	fmove.l	([2,A1,A2],4),FP4	; F2 31 42 00 A1 22 00
	fmove.l	([6,A2],D3,8),FP5	; F2 32 42 80 31 26 00
	fmove.l	#1024.,FP6		; F2 3C 43 00 00 00 04
	fmove.l	0x1234(PC),FP4		; F2 3A 42 00 12 30
	fmove.l	(2,PC,D2.W),FP5		; F2 3B 42 80 20 FE
	fmove.l	(2,PC,D4.L),FP6		; F2 3B 43 00 48 FE
	fmove.l	(0x1234,PC,D1),FP7	; F2 3B 43 80 11 20 12
	fmove.l	([2,PC,A2],4),FP0	; F2 3B 40 00 A1 22 FF
	fmove.l	([6,PC],D3,8),FP1	; F2 3B 40 80 31 26 00

	fmove.l	FP0,D0			; F2 00 60 00
	fmove.l	FP1,(A0)		; F2 10 60 80
	fmove.l	FP2,(A1)+		; F2 19 61 00
	fmove.l	FP3,-(A2)		; F2 22 61 80
	fmove.l	FP4,0x1234(A3)		; F2 2B 62 00 12 34
	fmove.l	FP5,(2,A4,D2.W)		; F2 34 62 80 20 02
	fmove.l	FP6,(2,A5,D4.L)		; F2 35 63 00 48 02
	fmove.l	FP7,(0x1234).W		; F2 38 63 80 12 34
	fmove.l	FP0,(0x1234).L		; F2 39 60 00 00 00 12
	fmove.l	FP1,*0xFFFFFFF0		; F2 38 60 80 FF F0
	fmove.l	FP2, 0x00010004		; F2 39 61 00 00 01 00
	fmove.l	FP3,(0x1234,A0,D1)	; F2 30 61 80 11 20 12
	fmove.l	FP4,([2,A1,A2],4)	; F2 31 62 00 A1 22 00
	fmove.l	FP5,([6,A2],D3,8)	; F2 32 62 80 31 26 00

	fmove.s	D0,FP0			; F2 00 44 00
	fmove.s	(A0),FP1		; F2 10 44 80
	fmove.s	(A1)+,FP2		; F2 19 45 00
	fmove.s	-(A2),FP3		; F2 22 45 80
	fmove.s	0x1234(A3),FP4		; F2 2B 46 00 12 34
	fmove.s	(2,A4,D2.W),FP5		; F2 34 46 80 20 02
	fmove.s	(2,A5,D4.L),FP6		; F2 35 47 00 48 02
	fmove.s	(0x1024).W,FP7		; F2 38 47 80 10 24
	fmove.s	(0x1234).L,FP0		; F2 39 44 00 00 00 12
	fmove.s	*0xFFFFFFF0,FP1		; F2 38 44 80 FF F0
	fmove.s	 0x00010004,FP2		; F2 39 45 00 00 01 00
	fmove.s	(0x1234,A0,D1),FP3	; F2 30 45 80 11 20 12
	fmove.s	([2,A1,A2],4),FP4	; F2 31 46 00 A1 22 00
	fmove.s	([6,A2],D3,8),FP5	; F2 32 46 80 31 26 00
	fmove.s	#1024.,FP6		; F2 3C 47 00 44 80 00
	fmove.s	0x1234(PC),FP4		; F2 3A 46 00 12 30
	fmove.s	(2,PC,D2.W),FP5		; F2 3B 46 80 20 FE
	fmove.s	(2,PC,D4.L),FP6		; F2 3B 47 00 48 FE
	fmove.s	(0x1234,PC,D1),FP7	; F2 3B 47 80 11 20 12
	fmove.s	([2,PC,A2],4),FP0	; F2 3B 44 00 A1 22 FF
	fmove.s	([6,PC],D3,8),FP1	; F2 3B 44 80 31 26 00

	fmove.s	FP0,D0			; F2 00 64 00
	fmove.s	FP1,(A0)		; F2 10 64 80
	fmove.s	FP2,(A1)+		; F2 19 65 00
	fmove.s	FP3,-(A2)		; F2 22 65 80
	fmove.s	FP4,0x1234(A3)		; F2 2B 66 00 12 34
	fmove.s	FP5,(2,A4,D2.W)		; F2 34 66 80 20 02
	fmove.s	FP6,(2,A5,D4.L)		; F2 35 67 00 48 02
	fmove.s	FP7,(0x1234).W		; F2 38 67 80 12 34
	fmove.s	FP0,(0x1234).L		; F2 39 64 00 00 00 12
	fmove.s	FP1,*0xFFFFFFF0		; F2 38 64 80 FF F0
	fmove.s	FP2, 0x00010004		; F2 39 65 00 00 01 00
	fmove.s	FP3,(0x1234,A0,D1)	; F2 30 65 80 11 20 12
	fmove.s	FP4,([2,A1,A2],4)	; F2 31 66 00 A1 22 00
	fmove.s	FP5,([6,A2],D3,8)	; F2 32 66 80 31 26 00

	fmove.d	(A0),FP1		; F2 10 54 80
	fmove.d	(A1)+,FP2		; F2 19 55 00
	fmove.d	-(A2),FP3		; F2 22 55 80
	fmove.d	0x1234(A3),FP4		; F2 2B 56 00 12 34
	fmove.d	(2,A4,D2.W),FP5		; F2 34 56 80 20 02
	fmove.d	(2,A5,D4.L),FP6		; F2 35 57 00 48 02
	fmove.d	(0x1024).W,FP7		; F2 38 57 80 10 24
	fmove.d	(0x1234).L,FP0		; F2 39 54 00 00 00 12
	fmove.d	*0xFFFFFFF0,FP1		; F2 38 54 80 FF F0
	fmove.d	 0x00010004,FP2		; F2 39 55 00 00 01 00
	fmove.d	(0x1234,A0,D1),FP3	; F2 30 55 80 11 20 12
	fmove.d	([2,A1,A2],4),FP4	; F2 31 56 00 A1 22 00
	fmove.d	([6,A2],D3,8),FP5	; F2 32 56 80 31 26 00
	fmove.d	0x1234(PC),FP4		; F2 3A 56 00 12 30
	fmove.d	(2,PC,D2.W),FP5		; F2 3B 56 80 20 FE
	fmove.d	(2,PC,D4.L),FP6		; F2 3B 57 00 48 FE
	fmove.d	(0x1234,PC,D1),FP7	; F2 3B 57 80 11 20 12
	fmove.d	([2,PC,A2],4),FP0	; F2 3B 54 00 A1 22 FF
	fmove.d	([6,PC],D3,8),FP1	; F2 3B 54 80 31 26 00

	fmove.d	FP1,(A0)		; F2 10 74 80
	fmove.d	FP2,(A1)+		; F2 19 75 00
	fmove.d	FP3,-(A2)		; F2 22 75 80
	fmove.d	FP4,0x1234(A3)		; F2 2B 76 00 12 34
	fmove.d	FP5,(2,A4,D2.W)		; F2 34 76 80 20 02
	fmove.d	FP6,(2,A5,D4.L)		; F2 35 77 00 48 02
	fmove.d	FP7,(0x1234).W		; F2 38 77 80 12 34
	fmove.d	FP0,(0x1234).L		; F2 39 74 00 00 00 12
	fmove.d	FP1,*0xFFFFFFF0		; F2 38 74 80 FF F0
	fmove.d	FP2, 0x00010004		; F2 39 75 00 00 01 00
	fmove.d	FP3,(0x1234,A0,D1)	; F2 30 75 80 11 20 12
	fmove.d	FP4,([2,A1,A2],4)	; F2 31 76 00 A1 22 00
	fmove.d	FP5,([6,A2],D3,8)	; F2 32 76 80 31 26 00

	fmove.x	(A0),FP1		; F2 10 48 80
	fmove.x	(A1)+,FP2		; F2 19 49 00
	fmove.x	-(A2),FP3		; F2 22 49 80
	fmove.x	0x1234(A3),FP4		; F2 2B 4A 00 12 34
	fmove.x	(2,A4,D2.W),FP5		; F2 34 4A 80 20 02
	fmove.x	(2,A5,D4.L),FP6		; F2 35 4B 00 48 02
	fmove.x	(0x1024).W,FP7		; F2 38 4B 80 10 24
	fmove.x	(0x1234).L,FP0		; F2 39 48 00 00 00 12
	fmove.x	*0xFFFFFFF0,FP1		; F2 38 48 80 FF F0
	fmove.x	 0x00010004,FP2		; F2 39 49 00 00 01 00
	fmove.x	(0x1234,A0,D1),FP3	; F2 30 49 80 11 20 12
	fmove.x	([2,A1,A2],4),FP4	; F2 31 4A 00 A1 22 00
	fmove.x	([6,A2],D3,8),FP5	; F2 32 4A 80 31 26 00
	fmove.x	0x1234(PC),FP4		; F2 3A 4A 00 12 30
	fmove.x	(2,PC,D2.W),FP5		; F2 3B 4A 80 20 FE
	fmove.x	(2,PC,D4.L),FP6		; F2 3B 4B 00 48 FE
	fmove.x	(0x1234,PC,D1),FP7	; F2 3B 4B 80 11 20 12
	fmove.x	([2,PC,A2],4),FP0	; F2 3B 48 00 A1 22 FF
	fmove.x	([6,PC],D3,8),FP1	; F2 3B 48 80 31 26 00

	fmove.x	FP1,(A0)		; F2 10 68 80
	fmove.x	FP2,(A1)+		; F2 19 69 00
	fmove.x	FP3,-(A2)		; F2 22 69 80
	fmove.x	FP4,0x1234(A3)		; F2 2B 6A 00 12 34
	fmove.x	FP5,(2,A4,D2.W)		; F2 34 6A 80 20 02
	fmove.x	FP6,(2,A5,D4.L)		; F2 35 6B 00 48 02
	fmove.x	FP7,(0x1234).W		; F2 38 6B 80 12 34
	fmove.x	FP0,(0x1234).L		; F2 39 68 00 00 00 12
	fmove.x	FP1,*0xFFFFFFF0		; F2 38 68 80 FF F0
	fmove.x	FP2, 0x00010004		; F2 39 69 00 00 01 00
	fmove.x	FP3,(0x1234,A0,D1)	; F2 30 69 80 11 20 12
	fmove.x	FP4,([2,A1,A2],4)	; F2 31 6A 00 A1 22 00
	fmove.x	FP5,([6,A2],D3,8)	; F2 32 6A 80 31 26 00

	fmove.p	FP1,(A0){D0}		; F2 10 7C 80
	fmove.p	FP2,(A1)+{#0}		; F2 19 6D 00
	fmove.p	FP3,-(A2){D1}		; F2 22 7D 90
	fmove.p	FP4,0x1234(A3){#1}	; F2 2B 6E 01 12 34
	fmove.p	FP5,(2,A4,D2.W){D3}	; F2 34 7E B0 20 02
	fmove.p	FP6,(2,A5,D4.L){#2}	; F2 35 6F 02 48 02
	fmove.p	FP7,*0xFFFFFFF0{D4}	; F2 38 7F C0 FF F0
	fmove.p	FP0, 0x00010004{#3}	; F2 39 6C 03 00 01 00
	fmove.p	FP1,(0x1024).W{D5}	; F2 38 7C D0 10 24
	fmove.p	FP2,(0x1024).L{#4}	; F2 39 6D 04 00 00 10
	fmove.p	FP3,(0x1234,A0,D1){D6}	; F2 30 7D E0 11 20 12
	fmove.p	FP4,([2,A1,A2],4){#5}	; F2 31 6E 05 A1 22 00
	fmove.p	FP5,([6,A2],D3,8){D7}	; F2 32 7E F0 31 26 00

	fmove.p	(A0),FP1		; F2 10 4C 80
	fmove.p	(A1)+,FP2		; F2 19 4D 00
	fmove.p	-(A2),FP3		; F2 22 4D 80
	fmove.p	0x1234(A3),FP4		; F2 2B 4E 00 12 34
	fmove.p	(2,A4,D2.W),FP5		; F2 34 4E 80 20 02
	fmove.p	(2,A5,D4.L),FP6		; F2 35 4F 00 48 02
	fmove.p	(0x1024).W,FP7		; F2 38 4F 80 10 24
	fmove.p	(0x1234).L,FP0		; F2 39 4C 00 00 00 12
	fmove.p	*0xFFFFFFF0,FP1		; F2 38 4C 80 FF F0
	fmove.p	 0x00010004,FP2		; F2 39 4D 00 00 01 00
	fmove.p	(0x1234,A0,D1),FP3	; F2 30 4D 80 11 20 12
	fmove.p	([2,A1,A2],4),FP4	; F2 31 4E 00 A1 22 00
	fmove.p	([6,A2],D3,8),FP5	; F2 32 4E 80 31 26 00
	fmove.p	0x1234(PC),FP4		; F2 3A 4E 00 12 30
	fmove.p	(2,PC,D2.W),FP5		; F2 3B 4E 80 20 FE
	fmove.p	(2,PC,D4.L),FP6		; F2 3B 4F 00 48 FE
	fmove.p	(0x1234,PC,D1),FP7	; F2 3B 4F 80 11 20 12
	fmove.p	([2,PC,A2],4),FP0	; F2 3B 4C 00 A1 22 FF
	fmove.p	([6,PC],D3,8),FP1	; F2 3B 4C 80 31 26 00

	fmove.p	FP1,(A0)		; F2 10 6C 80
	fmove.p	FP2,(A1)+		; F2 19 6D 00
	fmove.p	FP3,-(A2)		; F2 22 6D 80
	fmove.p	FP4,0x1234(A3)		; F2 2B 6E 00 12 34
	fmove.p	FP5,(2,A4,D2.W)		; F2 34 6E 80 20 02
	fmove.p	FP6,(2,A5,D4.L)		; F2 35 6F 00 48 02
	fmove.p	FP7,(0x1234).W		; F2 38 6F 80 12 34
	fmove.p	FP0,(0x1234).L		; F2 39 6C 00 00 00 12
	fmove.p	FP1,*0xFFFFFFF0		; F2 38 6C 80 FF F0
	fmove.p	FP2, 0x00010004		; F2 39 6D 00 00 01 00
	fmove.p	FP3,(0x1234,A0,D1)	; F2 30 6D 80 11 20 12
	fmove.p	FP4,([2,A1,A2],4)	; F2 31 6E 00 A1 22 00
	fmove.p	FP5,([6,A2],D3,8)	; F2 32 6E 80 31 26 00

	.sbttl	Type F_MVCR Instructions: FMOVECR

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  F_MVCR:						*
	;*	FMOVECR						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	fmovecr	#0x0F,FP1		; F2 00 5C 8F

	fmovecr.x	#0x0F,FP1	; F2 00 5C 8F

	.sbttl	Type F_MOVM Instructions: FMOVEM

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  F_MOVM:						*
	;*	FMOVEM						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	fmovem	FPCR,D0			; F2 00 B0 00
	fmovem	FPIAR,A1		; F2 09 A4 00
	fmovem	FPSR,(A2)		; F2 12 A8 00
	fmovem	FPCR/FPSR,(A3)+		; F2 1B B8 00
	fmovem	FPCR/FPSR/FPIAR,-(A4)	; F2 24 BC 00
	fmovem	FPCR/FPIAR,1(A5)	; F2 2D B4 00 00 01
	fmovem	FPSR/FPIAR,6(A6,D7.W)	; F2 36 AC 00 70 06
	fmovem	FPSR/FPIAR,6(A6,D7.L)	; F2 36 AC 00 78 06
	fmovem	FPCR/FPIAR,(0x1234).W	; F2 38 B4 00 12 34
	fmovem	FPCR/FPIAR,(0x1234).L	; F2 39 B4 00 00 00 12
	fmovem	FPCR/FPSR/FPIAR,*0xFFFFFFF0	; F2 38 BC 00 FF F0
	fmovem	FPCR/FPSR/FPIAR, 0x00010004	; F2 39 BC 00 00 01 00
	fmovem	FPCR/FPSR,(0x1234,A0,D1)	; F2 30 B8 00 11 20 12
	fmovem	FPSR/FPIAR,([2,A1,A2],4)	; F2 31 AC 00 A1 22 00
	fmovem	FPCR/FPSR/FPIAR,([6,A2],D3,8)	; F2 32 BC 00 31 26 00

	fmovem	D0,FPCR			; F2 00 90 00
	fmovem	A1,FPIAR		; F2 09 84 00
	fmovem	(A2),FPSR		; F2 12 88 00
	fmovem	(A3)+,FPCR/FPSR		; F2 1B 98 00
	fmovem	-(A4),FPCR/FPSR/FPIAR	; F2 24 9C 00
	fmovem	1(A5),FPCR/FPIAR	; F2 2D 94 00 00 01
	fmovem	6(A6,D7.W),FPSR/FPIAR	; F2 36 8C 00 70 06
	fmovem	6(A6,D7.L),FPSR/FPIAR	; F2 36 8C 00 78 06
	fmovem	(0x1234).W,FPCR/FPIAR	; F2 38 94 00 12 34
	fmovem	(0x1234).L,FPCR/FPIAR	; F2 39 94 00 00 00 12
	fmovem	*0xFFFFFFF0,FPCR/FPSR/FPIAR	; F2 38 9C 00 FF F0
	fmovem	 0x00010004,FPCR/FPSR/FPIAR	; F2 39 9C 00 00 01 00
	fmovem	(0x1234,A0,D1),FPCR/FPSR	; F2 30 98 00 11 20 12
	fmovem	([2,A1,A2],4),FPSR/FPIAR	; F2 31 8C 00 A1 22 00
	fmovem	([6,A2],D3,8),FPCR/FPSR/FPIAR	; F2 32 9C 00 31 26 00
	fmovem	#7,FPSR			; F2 3C 88 00 00 00 00
	fmovem	1(PC),FPCR/FPIAR	; F2 3A 94 00 FF FD
	fmovem	6(PC,D7.W),FPCR/FPIAR	; F2 3B 94 00 70 02
	fmovem	6(PC,D7.L),FPCR/FPIAR	; F2 3B 94 00 78 02
	fmovem	(0x1234,PC,D1),FPCR/FPSR	; F2 3B 98 00 11 20 12
	fmovem	([2,PC,A2],4),FPSR/FPIAR	; F2 3B 8C 00 A1 22 FF
	fmovem	([6,PC],D3,8),FPCR/FPSR/FPIAR	; F2 3B 9C 00 31 26 00

	fmovem	FP0,(A2)		; F2 12 F0 80
	fmovem	FP1/FP2,-(A4)		; F2 24 E0 06
	fmovem	FP1-FP3,1(A5)		; F2 2D F0 70 00 01
	fmovem	FP5-FP7/FP0,6(A6,D7.W)	; F2 36 F0 87 70 06
	fmovem	FP1-FP3/FP5-FP7,6(A6,D7.L)	; F2 36 F0 77 78 06
	fmovem	FP0/FP2/FP4/FP6,(0x1234).W	; F2 38 F0 AA 12 34
	fmovem	FP0/FP2/FP4/FP6,(0x1234).L	; F2 39 F0 AA 00 00 12
	fmovem	FP0-FP7,*0xFFFFFFF0	; F2 38 F0 FF FF F0
	fmovem	FP7/FP6/FP5, 0x00010004	; F2 39 F0 07 00 01 00
	fmovem	FP7/FP5/FP0-FP3,(0x1234,A0,D1)	; F2 30 F0 F5 11 20 12
	fmovem	FP0-FP7,([2,A1,A2],4)	; F2 31 F0 FF A1 22 00
	fmovem	FP1-FP3/FP5-FP7,([6,A2],D3,8)	; F2 32 F0 77 31 26 00

	fmovem	(A2),FP0		; F2 12 D0 80
	fmovem	(A3)+,FP1/FP2		; F2 1B D0 60
	fmovem	1(A5),FP1-FP3		; F2 2D D0 70
	fmovem	6(A6,D7.W),FP5-FP7/FP0	; F2 36 D0 87
	fmovem	6(A6,D7.L),FP1-FP3/FP5-FP7	; F2 36 D0 77
	fmovem	(0x1234).W,FP0/FP2/FP4/FP6	; F2 38 D0 AA
	fmovem	(0x1234).L,FP0/FP2/FP4/FP6	; F2 39 D0 AA
	fmovem	*0xFFFFFFF0,FP0-FP7	; F2 38 D0 FF
	fmovem	 0x00010004,FP7/FP6/FP5	; F2 39 D0 07
	fmovem	(0x1234,A0,D1),FP1-FP3/FP5-FP7	; F2 30 D0 77
	fmovem	([2,A1,A2],4),FP0/FP2/FP4/FP6	; F2 31 D0 AA
	fmovem	([6,A2],D3,8),FP7/FP6/FP5	; F2 32 D0 07
	fmovem	1(PC),FP1/FP2		; F2 3A D0 60
	fmovem	6(PC,D7.W),FP1-FP3	; F2 3B D0 70
	fmovem	6(PC,D7.L),FP5-FP7/FP0	; F2 3B D0 87
	fmovem	(0x1234,PC,D1),FP1/FP2	; F2 3B D0 60
	fmovem	([2,PC,A2],4),FP1-FP3	; F2 3B D0 70
	fmovem	([6,PC],D3,8),FP5-FP7/FP0	; F2 3B D0 87

	fmovem	D0,(A2)			; F2 12 F8 00
	fmovem	D1,-(A4)		; F2 24 E8 80
	fmovem	D2,1(A5)		; F2 2D F8 02 00 01
	fmovem	D3,6(A6,D7.W)		; F2 36 F8 03 70 06
	fmovem	D3,6(A6,D7.L)		; F2 36 F8 03 78 06
	fmovem	D4,(0x1234).W		; F2 38 F8 04 12 34
	fmovem	D4,(0x1234).L		; F2 39 F8 04 00 00 12
	fmovem	D5,*0xFFFFFFF0		; F2 38 F8 05 FF F0
	fmovem	D6, 0x00010004		; F2 39 F8 06 00 01 00
	fmovem	D7,(0x1234,A0,D1)	; F2 30 F8 07 11 20 12
	fmovem	D0,([2,A1,A2],4)	; F2 31 F8 00 A1 22 00
	fmovem	D1,([6,A2],D3,8)	; F2 32 F8 01 31 26 00

	fmovem	(A2),D0			; F2 12 D8 00
	fmovem	(A3)+,D1		; F2 1B D8 01
	fmovem	1(A5),D2		; F2 2D D8 02
	fmovem	6(A6,D7.W),D3		; F2 36 D8 03
	fmovem	6(A6,D7.L),D3		; F2 36 D8 03
	fmovem	(0x1234).W,D4		; F2 38 D8 04
	fmovem	(0x1234).L,D4		; F2 39 D8 04
	fmovem	*0xFFFFFFF0,D5		; F2 38 D8 05
	fmovem	 0x00010004,D6		; F2 39 D8 06
	fmovem	(0x1234,A0,D1),D7	; F2 30 D8 07
	fmovem	([2,A1,A2],4),D0	; F2 31 D8 00
	fmovem	([6,A2],D3,8),D1	; F2 32 D8 01
	fmovem	1(PC),D3		; F2 3A D8 03
	fmovem	6(PC,D7.W),D4		; F2 3B D8 04
	fmovem	6(PC,D7.L),D4		; F2 3B D8 04
	fmovem	(0x1234,PC,D1),D5	; F2 3B D8 05
	fmovem	([2,PC,A2],4),D6	; F2 3B D8 06
	fmovem	([6,PC],D3,8),D7	; F2 3B D8 07

	fmovem.l	FPCR,D0		; F2 00 B0 00
	fmovem.l	FPIAR,A1	; F2 09 A4 00
	fmovem.l	FPSR,(A2)	; F2 12 A8 00
	fmovem.l	FPCR/FPSR,(A3)+	; F2 1B B8 00
	fmovem.l	FPCR/FPSR/FPIAR,-(A4)	; F2 24 BC 00
	fmovem.l	FPCR/FPIAR,1(A5)	; F2 2D B4 00 00 01
	fmovem.l	FPSR/FPIAR,6(A6,D7.W)	; F2 36 AC 00 70 06
	fmovem.l	FPSR/FPIAR,6(A6,D7.L)	; F2 36 AC 00 78 06
	fmovem.l	FPCR/FPIAR,(0x1234).W	; F2 38 B4 00 12 34
	fmovem.l	FPCR/FPIAR,(0x1234).L	; F2 39 B4 00 00 00 12
	fmovem.l	FPCR/FPSR/FPIAR,*0xFFFFFFF0	; F2 38 BC 00 FF F0
	fmovem.l	FPCR/FPSR/FPIAR, 0x00010004	; F2 39 BC 00 00 01 00
	fmovem.l	FPCR/FPSR,(0x1234,A0,D1)	; F2 30 B8 00 11 20 12
	fmovem.l	FPSR/FPIAR,([2,A1,A2],4)	; F2 31 AC 00 A1 22 00
	fmovem.l	FPCR/FPSR/FPIAR,([6,A2],D3,8)	; F2 32 BC 00 31 26 00

	fmovem.l	D0,FPCR		; F2 00 90 00
	fmovem.l	A1,FPIAR	; F2 09 84 00
	fmovem.l	(A2),FPSR	; F2 12 88 00
	fmovem.l	(A3)+,FPCR/FPSR	; F2 1B 98 00
	fmovem.l	-(A4),FPCR/FPSR/FPIAR	; F2 24 9C 00
	fmovem.l	1(A5),FPCR/FPIAR	; F2 2D 94 00 00 01
	fmovem.l	6(A6,D7.W),FPSR/FPIAR	; F2 36 8C 00 70 06
	fmovem.l	6(A6,D7.L),FPSR/FPIAR	; F2 36 8C 00 78 06
	fmovem.l	(0x1234).W,FPCR/FPIAR	; F2 38 94 00 12 34
	fmovem.l	(0x1234).L,FPCR/FPIAR	; F2 39 94 00 00 00 12
	fmovem.l	*0xFFFFFFF0,FPCR/FPSR/FPIAR	; F2 38 9C 00 FF F0
	fmovem.l	 0x00010004,FPCR/FPSR/FPIAR	; F2 39 9C 00 00 01 00
	fmovem.l	(0x1234,A0,D1),FPCR/FPSR	; F2 30 98 00 11 20 12
	fmovem.l	([2,A1,A2],4),FPSR/FPIAR	; F2 31 8C 00 A1 22 00
	fmovem.l	([6,A2],D3,8),FPCR/FPSR/FPIAR	; F2 32 9C 00 31 26 00
	fmovem.l	#7,FPSR		; F2 3C 88 00 00 00 00
	fmovem.l	1(PC),FPCR/FPIAR	; F2 3A 94 00 FF FD
	fmovem.l	6(PC,D7.W),FPCR/FPIAR	; F2 3B 94 00 70 02
	fmovem.l	6(PC,D7.L),FPCR/FPIAR	; F2 3B 94 00 78 02
	fmovem.l	(0x1234,PC,D1),FPCR/FPSR	; F2 3B 98 00 11 20 12
	fmovem.l	([2,PC,A2],4),FPSR/FPIAR	; F2 3B 8C 00 A1 22 FF
	fmovem.l	([6,PC],D3,8),FPCR/FPSR/FPIAR	; F2 3B 9C 00 31 26 00

	fmovem.x	FP0,(A2)	; F2 12 F0 80
	fmovem.x	FP1/FP2,-(A4)	; F2 24 E0 06
	fmovem.x	FP1-FP3,1(A5)	; F2 2D F0 70 00 01
	fmovem.x	FP5-FP7/FP0,6(A6,D7.W)	; F2 36 F0 87 70 06
	fmovem.x	FP1-FP3/FP5-FP7,6(A6,D7.L)	; F2 36 F0 77 78 06
	fmovem.x	FP0/FP2/FP4/FP6,(0x1234).W	; F2 38 F0 AA 12 34
	fmovem.x	FP0/FP2/FP4/FP6,(0x1234).L	; F2 39 F0 AA 00 00 12
	fmovem.x	FP0-FP7,*0xFFFFFFF0	; F2 38 F0 FF FF F0
	fmovem.x	FP7/FP6/FP5, 0x00010004		; F2 39 F0 07 00 01 00
	fmovem.x	FP7/FP5/FP0-FP3,(0x1234,A0,D1)	; F2 30 F0 F5 11 20 12
	fmovem.x	FP0-FP7,([2,A1,A2],4)	; F2 31 F0 FF A1 22 00
	fmovem.x	FP1-FP3/FP5-FP7,([6,A2],D3,8)	; F2 32 F0 77 31 26 00

	fmovem.x	(A2),FP0	; F2 12 D0 80
	fmovem.x	(A3)+,FP1/FP2	; F2 1B D0 60
	fmovem.x	1(A5),FP1-FP3	; F2 2D D0 70
	fmovem.x	6(A6,D7.W),FP5-FP7/FP0	; F2 36 D0 87
	fmovem.x	6(A6,D7.L),FP1-FP3/FP5-FP7	; F2 36 D0 77
	fmovem.x	(0x1234).W,FP0/FP2/FP4/FP6	; F2 38 D0 AA
	fmovem.x	(0x1234).L,FP0/FP2/FP4/FP6	; F2 39 D0 AA
	fmovem.x	*0xFFFFFFF0,FP0-FP7	; F2 38 D0 FF
	fmovem.x	 0x00010004,FP7/FP6/FP5		; F2 39 D0 07
	fmovem.x	(0x1234,A0,D1),FP1-FP3/FP5-FP7	; F2 30 D0 77
	fmovem.x	([2,A1,A2],4),FP0/FP2/FP4/FP6	; F2 31 D0 AA
	fmovem.x	([6,A2],D3,8),FP7/FP6/FP5	; F2 32 D0 07
	fmovem.x	1(PC),FP1/FP2	; F2 3A D0 60
	fmovem.x	6(PC,D7.W),FP1-FP3	; F2 3B D0 70
	fmovem.x	6(PC,D7.L),FP5-FP7/FP0	; F2 3B D0 87
	fmovem.x	(0x1234,PC,D1),FP1/FP2	; F2 3B D0 60
	fmovem.x	([2,PC,A2],4),FP1-FP3	; F2 3B D0 70
	fmovem.x	([6,PC],D3,8),FP5-FP7/FP0	; F2 3B D0 87

	fmovem.x	D0,(A2)		; F2 12 F8 00
	fmovem.x	D1,-(A4)	; F2 24 E8 80
	fmovem.x	D2,1(A5)	; F2 2D F8 02 00 01
	fmovem.x	D3,6(A6,D7.W)	; F2 36 F8 03 70 06
	fmovem.x	D3,6(A6,D7.L)	; F2 36 F8 03 78 06
	fmovem.x	D4,(0x1234).W	; F2 38 F8 04 12 34
	fmovem.x	D4,(0x1234).L	; F2 39 F8 04 00 00 12
	fmovem.x	D5,*0xFFFFFFF0	; F2 38 F8 05 FF F0
	fmovem.x	D6, 0x00010004	; F2 39 F8 06 00 01 00
	fmovem.x	D7,(0x1234,A0,D1)	; F2 30 F8 07 11 20 12
	fmovem.x	D0,([2,A1,A2],4)	; F2 31 F8 00 A1 22 00
	fmovem.x	D1,([6,A2],D3,8)	; F2 32 F8 01 31 26 00

	fmovem.x	(A2),D0		; F2 12 D8 00
	fmovem.x	(A3)+,D1	; F2 1B D8 01
	fmovem.x	1(A5),D2	; F2 2D D8 02
	fmovem.x	6(A6,D7.W),D3	; F2 36 D8 03
	fmovem.x	6(A6,D7.L),D3	; F2 36 D8 03
	fmovem.x	(0x1234).W,D4	; F2 38 D8 04
	fmovem.x	(0x1234).L,D4	; F2 39 D8 04
	fmovem.x	*0xFFFFFFF0,D5	; F2 38 D8 05
	fmovem.x	 0x00010004,D6	; F2 39 D8 06
	fmovem.x	(0x1234,A0,D1),D7	; F2 30 D8 07
	fmovem.x	([2,A1,A2],4),D0	; F2 31 D8 00
	fmovem.x	([6,A2],D3,8),D1	; F2 32 D8 01
	fmovem.x	1(PC),D3	; F2 3A D8 03
	fmovem.x	6(PC,D7.W),D4	; F2 3B D8 04
	fmovem.x	6(PC,D7.L),D4	; F2 3B D8 04
	fmovem.x	(0x1234,PC,D1),D5	; F2 3B D8 05
	fmovem.x	([2,PC,A2],4),D6	; F2 3B D8 06
	fmovem.x	([6,PC],D3,8),D7	; F2 3B D8 07

	.sbttl	Type F_SCC Instructions: FScc, ...

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  F_SCC:						*
	;*	FSF, FSEQ, FSOGT, FSOGE,			*
	;*	FSOLT, FSOLE, FSOGL, FSOR			*
	;*	FSUN, FSUEQ, FSUGT, FSUGE,			*
	;*	FSULT, FSULE, FSNE, FST,			*
	;*	FSSF,FSSEQ,FSGT,FSGE,				*
	;*	FSLT,FSLE,FSGL,FSGLE,				*
	;*	FSNGLE,FSNGL,FSNLE,FSNLT,			*
	;*	FSNGE,FSNGT,FSSNE,FSST				*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	fsf	D7			; F2 47 00 00
	fsf	(A1)			; F2 51 00 00
	fsf	(A2)+			; F2 5A 00 00
	fsf	-(A3)			; F2 63 00 00
	fsf	1(A4)			; F2 6C 00 00 00 01
	fsf	2(A5,D7.W)		; F2 75 00 00 70 02
	fsf	2(A5,D7.L)		; F2 75 00 00 78 02
	fsf	(0x1234).W		; F2 78 00 00 12 34
	fsf	(0x1234).L		; F2 79 00 00 00 00 12
	fsf	*0xFFFFFFF0		; F2 78 00 00 FF F0
	fsf	 0x00010004		; F2 79 00 00 00 01 00
	fsf	(0x1234,A0,D1)		; F2 70 00 00 11 20 12
	fsf	([2,A1,A2],4)		; F2 71 00 00 A1 22 00
	fsf	([6,A2],D3,8)		; F2 72 00 00 31 26 00

	fsf.b	D7			; F2 47 00 00
	fsf.b	(A1)			; F2 51 00 00
	fsf.b	(A2)+			; F2 5A 00 00
	fsf.b	-(A3)			; F2 63 00 00
	fsf.b	1(A4)			; F2 6C 00 00 00 01
	fsf.b	2(A5,D7.W)		; F2 75 00 00 70 02
	fsf.b	2(A5,D7.L)		; F2 75 00 00 78 02
	fsf.b	(0x1234).W		; F2 78 00 00 12 34
	fsf.b	(0x1234).L		; F2 79 00 00 00 00 12
	fsf.b	*0xFFFFFFF0		; F2 78 00 00 FF F0
	fsf.b	 0x00010004		; F2 79 00 00 00 01 00
	fsf.b	(0x1234,A0,D1)		; F2 70 00 00 11 20 12
	fsf.b	([2,A1,A2],4)		; F2 71 00 00 A1 22 00
	fsf.b	([6,A2],D3,8)		; F2 72 00 00 31 26 00

	fseq	D7			; F2 47 00 01
	fseq	(A1)			; F2 51 00 01
	fseq	(A2)+			; F2 5A 00 01
	fseq	-(A3)			; F2 63 00 01
	fseq	1(A4)			; F2 6C 00 01 00 01
	fseq	2(A5,D7.W)		; F2 75 00 01 70 02
	fseq	2(A5,D7.L)		; F2 75 00 01 78 02
	fseq	(0x1234).W		; F2 78 00 01 12 34
	fseq	(0x1234).L		; F2 79 00 01 00 00 12
	fseq	*0xFFFFFFF0		; F2 78 00 01 FF F0
	fseq	 0x00010004		; F2 79 00 01 00 01 00
	fseq	(0x1234,A0,D1)		; F2 70 00 01 11 20 12
	fseq	([2,A1,A2],4)		; F2 71 00 01 A1 22 00
	fseq	([6,A2],D3,8)		; F2 72 00 01 31 26 00

	fseq.b	D7			; F2 47 00 01
	fseq.b	(A1)			; F2 51 00 01
	fseq.b	(A2)+			; F2 5A 00 01
	fseq.b	-(A3)			; F2 63 00 01
	fseq.b	1(A4)			; F2 6C 00 01 00 01
	fseq.b	2(A5,D7.W)		; F2 75 00 01 70 02
	fseq.b	2(A5,D7.L)		; F2 75 00 01 78 02
	fseq.b	(0x1234).W		; F2 78 00 01 12 34
	fseq.b	(0x1234).L		; F2 79 00 01 00 00 12
	fseq.b	*0xFFFFFFF0		; F2 78 00 01 FF F0
	fseq.b	 0x00010004		; F2 79 00 01 00 01 00
	fseq.b	(0x1234,A0,D1)		; F2 70 00 01 11 20 12
	fseq.b	([2,A1,A2],4)		; F2 71 00 01 A1 22 00
	fseq.b	([6,A2],D3,8)		; F2 72 00 01 31 26 00

	fsogt	D7			; F2 47 00 02
	fsogt	(A1)			; F2 51 00 02
	fsogt	(A2)+			; F2 5A 00 02
	fsogt	-(A3)			; F2 63 00 02
	fsogt	1(A4)			; F2 6C 00 02 00 01
	fsogt	2(A5,D7.W)		; F2 75 00 02 70 02
	fsogt	2(A5,D7.L)		; F2 75 00 02 78 02
	fsogt	(0x1234).W		; F2 78 00 02 12 34
	fsogt	(0x1234).L		; F2 79 00 02 00 00 12
	fsogt	*0xFFFFFFF0		; F2 78 00 02 FF F0
	fsogt	 0x00010004		; F2 79 00 02 00 01 00
	fsogt	(0x1234,A0,D1)		; F2 70 00 02 11 20 12
	fsogt	([2,A1,A2],4)		; F2 71 00 02 A1 22 00
	fsogt	([6,A2],D3,8)		; F2 72 00 02 31 26 00

	fsogt.b	D7			; F2 47 00 02
	fsogt.b	(A1)			; F2 51 00 02
	fsogt.b	(A2)+			; F2 5A 00 02
	fsogt.b	-(A3)			; F2 63 00 02
	fsogt.b	1(A4)			; F2 6C 00 02 00 01
	fsogt.b	2(A5,D7.W)		; F2 75 00 02 70 02
	fsogt.b	2(A5,D7.L)		; F2 75 00 02 78 02
	fsogt.b	(0x1234).W		; F2 78 00 02 12 34
	fsogt.b	(0x1234).L		; F2 79 00 02 00 00 12
	fsogt.b	*0xFFFFFFF0		; F2 78 00 02 FF F0
	fsogt.b	 0x00010004		; F2 79 00 02 00 01 00
	fsogt.b	(0x1234,A0,D1)		; F2 70 00 02 11 20 12
	fsogt.b	([2,A1,A2],4)		; F2 71 00 02 A1 22 00
	fsogt.b	([6,A2],D3,8)		; F2 72 00 02 31 26 00

	fsoge	D7			; F2 47 00 03
	fsoge	(A1)			; F2 51 00 03
	fsoge	(A2)+			; F2 5A 00 03
	fsoge	-(A3)			; F2 63 00 03
	fsoge	1(A4)			; F2 6C 00 03 00 01
	fsoge	2(A5,D7.W)		; F2 75 00 03 70 02
	fsoge	2(A5,D7.L)		; F2 75 00 03 78 02
	fsoge	(0x1234).W		; F2 78 00 03 12 34
	fsoge	(0x1234).L		; F2 79 00 03 00 00 12
	fsoge	*0xFFFFFFF0		; F2 78 00 03 FF F0
	fsoge	 0x00010004		; F2 79 00 03 00 01 00
	fsoge	(0x1234,A0,D1)		; F2 70 00 03 11 20 12
	fsoge	([2,A1,A2],4)		; F2 71 00 03 A1 22 00
	fsoge	([6,A2],D3,8)		; F2 72 00 03 31 26 00

	fsoge.b	D7			; F2 47 00 03
	fsoge.b	(A1)			; F2 51 00 03
	fsoge.b	(A2)+			; F2 5A 00 03
	fsoge.b	-(A3)			; F2 63 00 03
	fsoge.b	1(A4)			; F2 6C 00 03 00 01
	fsoge.b	2(A5,D7.W)		; F2 75 00 03 70 02
	fsoge.b	2(A5,D7.L)		; F2 75 00 03 78 02
	fsoge.b	(0x1234).W		; F2 78 00 03 12 34
	fsoge.b	(0x1234).L		; F2 79 00 03 00 00 12
	fsoge.b	*0xFFFFFFF0		; F2 78 00 03 FF F0
	fsoge.b	 0x00010004		; F2 79 00 03 00 01 00
	fsoge.b	(0x1234,A0,D1)		; F2 70 00 03 11 20 12
	fsoge.b	([2,A1,A2],4)		; F2 71 00 03 A1 22 00
	fsoge.b	([6,A2],D3,8)		; F2 72 00 03 31 26 00

	fsolt	D7			; F2 47 00 04
	fsolt	(A1)			; F2 51 00 04
	fsolt	(A2)+			; F2 5A 00 04
	fsolt	-(A3)			; F2 63 00 04
	fsolt	1(A4)			; F2 6C 00 04 00 01
	fsolt	2(A5,D7.W)		; F2 75 00 04 70 02
	fsolt	2(A5,D7.L)		; F2 75 00 04 78 02
	fsolt	(0x1234).W		; F2 78 00 04 12 34
	fsolt	(0x1234).L		; F2 79 00 04 00 00 12
	fsolt	*0xFFFFFFF0		; F2 78 00 04 FF F0
	fsolt	 0x00010004		; F2 79 00 04 00 01 00
	fsolt	(0x1234,A0,D1)		; F2 70 00 04 11 20 12
	fsolt	([2,A1,A2],4)		; F2 71 00 04 A1 22 00
	fsolt	([6,A2],D3,8)		; F2 72 00 04 31 26 00

	fsolt.b	D7			; F2 47 00 04
	fsolt.b	(A1)			; F2 51 00 04
	fsolt.b	(A2)+			; F2 5A 00 04
	fsolt.b	-(A3)			; F2 63 00 04
	fsolt.b	1(A4)			; F2 6C 00 04 00 01
	fsolt.b	2(A5,D7.W)		; F2 75 00 04 70 02
	fsolt.b	2(A5,D7.L)		; F2 75 00 04 78 02
	fsolt.b	(0x1234).W		; F2 78 00 04 12 34
	fsolt.b	(0x1234).L		; F2 79 00 04 00 00 12
	fsolt.b	*0xFFFFFFF0		; F2 78 00 04 FF F0
	fsolt.b	 0x00010004		; F2 79 00 04 00 01 00
	fsolt.b	(0x1234,A0,D1)		; F2 70 00 04 11 20 12
	fsolt.b	([2,A1,A2],4)		; F2 71 00 04 A1 22 00
	fsolt.b	([6,A2],D3,8)		; F2 72 00 04 31 26 00

	fsole	D7			; F2 47 00 05
	fsole	(A1)			; F2 51 00 05
	fsole	(A2)+			; F2 5A 00 05
	fsole	-(A3)			; F2 63 00 05
	fsole	1(A4)			; F2 6C 00 05 00 01
	fsole	2(A5,D7.W)		; F2 75 00 05 70 02
	fsole	2(A5,D7.L)		; F2 75 00 05 78 02
	fsole	(0x1234).W		; F2 78 00 05 12 34
	fsole	(0x1234).L		; F2 79 00 05 00 00 12
	fsole	*0xFFFFFFF0		; F2 78 00 05 FF F0
	fsole	 0x00010004		; F2 79 00 05 00 01 00
	fsole	(0x1234,A0,D1)		; F2 70 00 05 11 20 12
	fsole	([2,A1,A2],4)		; F2 71 00 05 A1 22 00
	fsole	([6,A2],D3,8)		; F2 72 00 05 31 26 00

	fsole.b	D7			; F2 47 00 05
	fsole.b	(A1)			; F2 51 00 05
	fsole.b	(A2)+			; F2 5A 00 05
	fsole.b	-(A3)			; F2 63 00 05
	fsole.b	1(A4)			; F2 6C 00 05 00 01
	fsole.b	2(A5,D7.W)		; F2 75 00 05 70 02
	fsole.b	2(A5,D7.L)		; F2 75 00 05 78 02
	fsole.b	(0x1234).W		; F2 78 00 05 12 34
	fsole.b	(0x1234).L		; F2 79 00 05 00 00 12
	fsole.b	*0xFFFFFFF0		; F2 78 00 05 FF F0
	fsole.b	 0x00010004		; F2 79 00 05 00 01 00
	fsole.b	(0x1234,A0,D1)		; F2 70 00 05 11 20 12
	fsole.b	([2,A1,A2],4)		; F2 71 00 05 A1 22 00
	fsole.b	([6,A2],D3,8)		; F2 72 00 05 31 26 00

	fsogl	D7			; F2 47 00 06
	fsogl	(A1)			; F2 51 00 06
	fsogl	(A2)+			; F2 5A 00 06
	fsogl	-(A3)			; F2 63 00 06
	fsogl	1(A4)			; F2 6C 00 06 00 01
	fsogl	2(A5,D7.W)		; F2 75 00 06 70 02
	fsogl	2(A5,D7.L)		; F2 75 00 06 78 02
	fsogl	(0x1234).W		; F2 78 00 06 12 34
	fsogl	(0x1234).L		; F2 79 00 06 00 00 12
	fsogl	*0xFFFFFFF0		; F2 78 00 06 FF F0
	fsogl	 0x00010004		; F2 79 00 06 00 01 00
	fsogl	(0x1234,A0,D1)		; F2 70 00 06 11 20 12
	fsogl	([2,A1,A2],4)		; F2 71 00 06 A1 22 00
	fsogl	([6,A2],D3,8)		; F2 72 00 06 31 26 00

	fsogl.b	D7			; F2 47 00 06
	fsogl.b	(A1)			; F2 51 00 06
	fsogl.b	(A2)+			; F2 5A 00 06
	fsogl.b	-(A3)			; F2 63 00 06
	fsogl.b	1(A4)			; F2 6C 00 06 00 01
	fsogl.b	2(A5,D7.W)		; F2 75 00 06 70 02
	fsogl.b	2(A5,D7.L)		; F2 75 00 06 78 02
	fsogl.b	(0x1234).W		; F2 78 00 06 12 34
	fsogl.b	(0x1234).L		; F2 79 00 06 00 00 12
	fsogl.b	*0xFFFFFFF0		; F2 78 00 06 FF F0
	fsogl.b	 0x00010004		; F2 79 00 06 00 01 00
	fsogl.b	(0x1234,A0,D1)		; F2 70 00 06 11 20 12
	fsogl.b	([2,A1,A2],4)		; F2 71 00 06 A1 22 00
	fsogl.b	([6,A2],D3,8)		; F2 72 00 06 31 26 00

	fsor	D7			; F2 47 00 07
	fsor	(A1)			; F2 51 00 07
	fsor	(A2)+			; F2 5A 00 07
	fsor	-(A3)			; F2 63 00 07
	fsor	1(A4)			; F2 6C 00 07 00 01
	fsor	2(A5,D7.W)		; F2 75 00 07 70 02
	fsor	2(A5,D7.L)		; F2 75 00 07 78 02
	fsor	(0x1234).W		; F2 78 00 07 12 34
	fsor	(0x1234).L		; F2 79 00 07 00 00 12
	fsor	*0xFFFFFFF0		; F2 78 00 07 FF F0
	fsor	 0x00010004		; F2 79 00 07 00 01 00
	fsor	(0x1234,A0,D1)		; F2 70 00 07 11 20 12
	fsor	([2,A1,A2],4)		; F2 71 00 07 A1 22 00
	fsor	([6,A2],D3,8)		; F2 72 00 07 31 26 00

	fsor.b	D7			; F2 47 00 07
	fsor.b	(A1)			; F2 51 00 07
	fsor.b	(A2)+			; F2 5A 00 07
	fsor.b	-(A3)			; F2 63 00 07
	fsor.b	1(A4)			; F2 6C 00 07 00 01
	fsor.b	2(A5,D7.W)		; F2 75 00 07 70 02
	fsor.b	2(A5,D7.L)		; F2 75 00 07 78 02
	fsor.b	(0x1234).W		; F2 78 00 07 12 34
	fsor.b	(0x1234).L		; F2 79 00 07 00 00 12
	fsor.b	*0xFFFFFFF0		; F2 78 00 07 FF F0
	fsor.b	 0x00010004		; F2 79 00 07 00 01 00
	fsor.b	(0x1234,A0,D1)		; F2 70 00 07 11 20 12
	fsor.b	([2,A1,A2],4)		; F2 71 00 07 A1 22 00
	fsor.b	([6,A2],D3,8)		; F2 72 00 07 31 26 00

	fsun	D7			; F2 47 00 08
	fsun	(A1)			; F2 51 00 08
	fsun	(A2)+			; F2 5A 00 08
	fsun	-(A3)			; F2 63 00 08
	fsun	1(A4)			; F2 6C 00 08 00 01
	fsun	2(A5,D7.W)		; F2 75 00 08 70 02
	fsun	2(A5,D7.L)		; F2 75 00 08 78 02
	fsun	(0x1234).W		; F2 78 00 08 12 34
	fsun	(0x1234).L		; F2 79 00 08 00 00 12
	fsun	*0xFFFFFFF0		; F2 78 00 08 FF F0
	fsun	 0x00010004		; F2 79 00 08 00 01 00
	fsun	(0x1234,A0,D1)		; F2 70 00 08 11 20 12
	fsun	([2,A1,A2],4)		; F2 71 00 08 A1 22 00
	fsun	([6,A2],D3,8)		; F2 72 00 08 31 26 00

	fsun.b	D7			; F2 47 00 08
	fsun.b	(A1)			; F2 51 00 08
	fsun.b	(A2)+			; F2 5A 00 08
	fsun.b	-(A3)			; F2 63 00 08
	fsun.b	1(A4)			; F2 6C 00 08 00 01
	fsun.b	2(A5,D7.W)		; F2 75 00 08 70 02
	fsun.b	2(A5,D7.L)		; F2 75 00 08 78 02
	fsun.b	(0x1234).W		; F2 78 00 08 12 34
	fsun.b	(0x1234).L		; F2 79 00 08 00 00 12
	fsun.b	*0xFFFFFFF0		; F2 78 00 08 FF F0
	fsun.b	 0x00010004		; F2 79 00 08 00 01 00
	fsun.b	(0x1234,A0,D1)		; F2 70 00 08 11 20 12
	fsun.b	([2,A1,A2],4)		; F2 71 00 08 A1 22 00
	fsun.b	([6,A2],D3,8)		; F2 72 00 08 31 26 00

	fsueq	D7			; F2 47 00 09
	fsueq	(A1)			; F2 51 00 09
	fsueq	(A2)+			; F2 5A 00 09
	fsueq	-(A3)			; F2 63 00 09
	fsueq	1(A4)			; F2 6C 00 09 00 01
	fsueq	2(A5,D7.W)		; F2 75 00 09 70 02
	fsueq	2(A5,D7.L)		; F2 75 00 09 78 02
	fsueq	(0x1234).W		; F2 78 00 09 12 34
	fsueq	(0x1234).L		; F2 79 00 09 00 00 12
	fsueq	*0xFFFFFFF0		; F2 78 00 09 FF F0
	fsueq	 0x00010004		; F2 79 00 09 00 01 00
	fsueq	(0x1234,A0,D1)		; F2 70 00 09 11 20 12
	fsueq	([2,A1,A2],4)		; F2 71 00 09 A1 22 00
	fsueq	([6,A2],D3,8)		; F2 72 00 09 31 26 00

	fsueq.b	D7			; F2 47 00 09
	fsueq.b	(A1)			; F2 51 00 09
	fsueq.b	(A2)+			; F2 5A 00 09
	fsueq.b	-(A3)			; F2 63 00 09
	fsueq.b	1(A4)			; F2 6C 00 09 00 01
	fsueq.b	2(A5,D7.W)		; F2 75 00 09 70 02
	fsueq.b	2(A5,D7.L)		; F2 75 00 09 78 02
	fsueq.b	(0x1234).W		; F2 78 00 09 12 34
	fsueq.b	(0x1234).L		; F2 79 00 09 00 00 12
	fsueq.b	*0xFFFFFFF0		; F2 78 00 09 FF F0
	fsueq.b	 0x00010004		; F2 79 00 09 00 01 00
	fsueq.b	(0x1234,A0,D1)		; F2 70 00 09 11 20 12
	fsueq.b	([2,A1,A2],4)		; F2 71 00 09 A1 22 00
	fsueq.b	([6,A2],D3,8)		; F2 72 00 09 31 26 00

	fsugt	D7			; F2 47 00 0A
	fsugt	(A1)			; F2 51 00 0A
	fsugt	(A2)+			; F2 5A 00 0A
	fsugt	-(A3)			; F2 63 00 0A
	fsugt	1(A4)			; F2 6C 00 0A 00 01
	fsugt	2(A5,D7.W)		; F2 75 00 0A 70 02
	fsugt	2(A5,D7.L)		; F2 75 00 0A 78 02
	fsugt	(0x1234).W		; F2 78 00 0A 12 34
	fsugt	(0x1234).L		; F2 79 00 0A 00 00 12
	fsugt	*0xFFFFFFF0		; F2 78 00 0A FF F0
	fsugt	 0x00010004		; F2 79 00 0A 00 01 00
	fsugt	(0x1234,A0,D1)		; F2 70 00 0A 11 20 12
	fsugt	([2,A1,A2],4)		; F2 71 00 0A A1 22 00
	fsugt	([6,A2],D3,8)		; F2 72 00 0A 31 26 00

	fsugt.b	D7			; F2 47 00 0A
	fsugt.b	(A1)			; F2 51 00 0A
	fsugt.b	(A2)+			; F2 5A 00 0A
	fsugt.b	-(A3)			; F2 63 00 0A
	fsugt.b	1(A4)			; F2 6C 00 0A 00 01
	fsugt.b	2(A5,D7.W)		; F2 75 00 0A 70 02
	fsugt.b	2(A5,D7.L)		; F2 75 00 0A 78 02
	fsugt.b	(0x1234).W		; F2 78 00 0A 12 34
	fsugt.b	(0x1234).L		; F2 79 00 0A 00 00 12
	fsugt.b	*0xFFFFFFF0		; F2 78 00 0A FF F0
	fsugt.b	 0x00010004		; F2 79 00 0A 00 01 00
	fsugt.b	(0x1234,A0,D1)		; F2 70 00 0A 11 20 12
	fsugt.b	([2,A1,A2],4)		; F2 71 00 0A A1 22 00
	fsugt.b	([6,A2],D3,8)		; F2 72 00 0A 31 26 00

	fsuge	D7			; F2 47 00 0B
	fsuge	(A1)			; F2 51 00 0B
	fsuge	(A2)+			; F2 5A 00 0B
	fsuge	-(A3)			; F2 63 00 0B
	fsuge	1(A4)			; F2 6C 00 0B 00 01
	fsuge	2(A5,D7.W)		; F2 75 00 0B 70 02
	fsuge	2(A5,D7.L)		; F2 75 00 0B 78 02
	fsuge	(0x1234).W		; F2 78 00 0B 12 34
	fsuge	(0x1234).L		; F2 79 00 0B 00 00 12
	fsuge	*0xFFFFFFF0		; F2 78 00 0B FF F0
	fsuge	 0x00010004		; F2 79 00 0B 00 01 00
	fsuge	(0x1234,A0,D1)		; F2 70 00 0B 11 20 12
	fsuge	([2,A1,A2],4)		; F2 71 00 0B A1 22 00
	fsuge	([6,A2],D3,8)		; F2 72 00 0B 31 26 00

	fsuge.b	D7			; F2 47 00 0B
	fsuge.b	(A1)			; F2 51 00 0B
	fsuge.b	(A2)+			; F2 5A 00 0B
	fsuge.b	-(A3)			; F2 63 00 0B
	fsuge.b	1(A4)			; F2 6C 00 0B 00 01
	fsuge.b	2(A5,D7.W)		; F2 75 00 0B 70 02
	fsuge.b	2(A5,D7.L)		; F2 75 00 0B 78 02
	fsuge.b	(0x1234).W		; F2 78 00 0B 12 34
	fsuge.b	(0x1234).L		; F2 79 00 0B 00 00 12
	fsuge.b	*0xFFFFFFF0		; F2 78 00 0B FF F0
	fsuge.b	 0x00010004		; F2 79 00 0B 00 01 00
	fsuge.b	(0x1234,A0,D1)		; F2 70 00 0B 11 20 12
	fsuge.b	([2,A1,A2],4)		; F2 71 00 0B A1 22 00
	fsuge.b	([6,A2],D3,8)		; F2 72 00 0B 31 26 00

	fsult	D7			; F2 47 00 0C
	fsult	(A1)			; F2 51 00 0C
	fsult	(A2)+			; F2 5A 00 0C
	fsult	-(A3)			; F2 63 00 0C
	fsult	1(A4)			; F2 6C 00 0C 00 01
	fsult	2(A5,D7.W)		; F2 75 00 0C 70 02
	fsult	2(A5,D7.L)		; F2 75 00 0C 78 02
	fsult	(0x1234).W		; F2 78 00 0C 12 34
	fsult	(0x1234).L		; F2 79 00 0C 00 00 12
	fsult	*0xFFFFFFF0		; F2 78 00 0C FF F0
	fsult	 0x00010004		; F2 79 00 0C 00 01 00
	fsult	(0x1234,A0,D1)		; F2 70 00 0C 11 20 12
	fsult	([2,A1,A2],4)		; F2 71 00 0C A1 22 00
	fsult	([6,A2],D3,8)		; F2 72 00 0C 31 26 00

	fsult.b	D7			; F2 47 00 0C
	fsult.b	(A1)			; F2 51 00 0C
	fsult.b	(A2)+			; F2 5A 00 0C
	fsult.b	-(A3)			; F2 63 00 0C
	fsult.b	1(A4)			; F2 6C 00 0C 00 01
	fsult.b	2(A5,D7.W)		; F2 75 00 0C 70 02
	fsult.b	2(A5,D7.L)		; F2 75 00 0C 78 02
	fsult.b	(0x1234).W		; F2 78 00 0C 12 34
	fsult.b	(0x1234).L		; F2 79 00 0C 00 00 12
	fsult.b	*0xFFFFFFF0		; F2 78 00 0C FF F0
	fsult.b	 0x00010004		; F2 79 00 0C 00 01 00
	fsult.b	(0x1234,A0,D1)		; F2 70 00 0C 11 20 12
	fsult.b	([2,A1,A2],4)		; F2 71 00 0C A1 22 00
	fsult.b	([6,A2],D3,8)		; F2 72 00 0C 31 26 00

	fsule	D7			; F2 47 00 0D
	fsule	(A1)			; F2 51 00 0D
	fsule	(A2)+			; F2 5A 00 0D
	fsule	-(A3)			; F2 63 00 0D
	fsule	1(A4)			; F2 6C 00 0D 00 01
	fsule	2(A5,D7.W)		; F2 75 00 0D 70 02
	fsule	2(A5,D7.L)		; F2 75 00 0D 78 02
	fsule	(0x1234).W		; F2 78 00 0D 12 34
	fsule	(0x1234).L		; F2 79 00 0D 00 00 12
	fsule	*0xFFFFFFF0		; F2 78 00 0D FF F0
	fsule	 0x00010004		; F2 79 00 0D 00 01 00
	fsule	(0x1234,A0,D1)		; F2 70 00 0D 11 20 12
	fsule	([2,A1,A2],4)		; F2 71 00 0D A1 22 00
	fsule	([6,A2],D3,8)		; F2 72 00 0D 31 26 00

	fsule.b	D7			; F2 47 00 0D
	fsule.b	(A1)			; F2 51 00 0D
	fsule.b	(A2)+			; F2 5A 00 0D
	fsule.b	-(A3)			; F2 63 00 0D
	fsule.b	1(A4)			; F2 6C 00 0D 00 01
	fsule.b	2(A5,D7.W)		; F2 75 00 0D 70 02
	fsule.b	2(A5,D7.L)		; F2 75 00 0D 78 02
	fsule.b	(0x1234).W		; F2 78 00 0D 12 34
	fsule.b	(0x1234).L		; F2 79 00 0D 00 00 12
	fsule.b	*0xFFFFFFF0		; F2 78 00 0D FF F0
	fsule.b	 0x00010004		; F2 79 00 0D 00 01 00
	fsule.b	(0x1234,A0,D1)		; F2 70 00 0D 11 20 12
	fsule.b	([2,A1,A2],4)		; F2 71 00 0D A1 22 00
	fsule.b	([6,A2],D3,8)		; F2 72 00 0D 31 26 00

	fsne	D7			; F2 47 00 0E
	fsne	(A1)			; F2 51 00 0E
	fsne	(A2)+			; F2 5A 00 0E
	fsne	-(A3)			; F2 63 00 0E
	fsne	1(A4)			; F2 6C 00 0E 00 01
	fsne	2(A5,D7.W)		; F2 75 00 0E 70 02
	fsne	2(A5,D7.L)		; F2 75 00 0E 78 02
	fsne	(0x1234).W		; F2 78 00 0E 12 34
	fsne	(0x1234).L		; F2 79 00 0E 00 00 12
	fsne	*0xFFFFFFF0		; F2 78 00 0E FF F0
	fsne	 0x00010004		; F2 79 00 0E 00 01 00
	fsne	(0x1234,A0,D1)		; F2 70 00 0E 11 20 12
	fsne	([2,A1,A2],4)		; F2 71 00 0E A1 22 00
	fsne	([6,A2],D3,8)		; F2 72 00 0E 31 26 00

	fsne.b	D7			; F2 47 00 0E
	fsne.b	(A1)			; F2 51 00 0E
	fsne.b	(A2)+			; F2 5A 00 0E
	fsne.b	-(A3)			; F2 63 00 0E
	fsne.b	1(A4)			; F2 6C 00 0E 00 01
	fsne.b	2(A5,D7.W)		; F2 75 00 0E 70 02
	fsne.b	2(A5,D7.L)		; F2 75 00 0E 78 02
	fsne.b	(0x1234).W		; F2 78 00 0E 12 34
	fsne.b	(0x1234).L		; F2 79 00 0E 00 00 12
	fsne.b	*0xFFFFFFF0		; F2 78 00 0E FF F0
	fsne.b	 0x00010004		; F2 79 00 0E 00 01 00
	fsne.b	(0x1234,A0,D1)		; F2 70 00 0E 11 20 12
	fsne.b	([2,A1,A2],4)		; F2 71 00 0E A1 22 00
	fsne.b	([6,A2],D3,8)		; F2 72 00 0E 31 26 00

	fst	D7			; F2 47 00 0F
	fst	(A1)			; F2 51 00 0F
	fst	(A2)+			; F2 5A 00 0F
	fst	-(A3)			; F2 63 00 0F
	fst	1(A4)			; F2 6C 00 0F 00 01
	fst	2(A5,D7.W)		; F2 75 00 0F 70 02
	fst	2(A5,D7.L)		; F2 75 00 0F 78 02
	fst	(0x1234).W		; F2 78 00 0F 12 34
	fst	(0x1234).L		; F2 79 00 0F 00 00 12
	fst	*0xFFFFFFF0		; F2 78 00 0F FF F0
	fst	 0x00010004		; F2 79 00 0F 00 01 00
	fst	(0x1234,A0,D1)		; F2 70 00 0F 11 20 12
	fst	([2,A1,A2],4)		; F2 71 00 0F A1 22 00
	fst	([6,A2],D3,8)		; F2 72 00 0F 31 26 00

	fst.b	D7			; F2 47 00 0F
	fst.b	(A1)			; F2 51 00 0F
	fst.b	(A2)+			; F2 5A 00 0F
	fst.b	-(A3)			; F2 63 00 0F
	fst.b	1(A4)			; F2 6C 00 0F 00 01
	fst.b	2(A5,D7.W)		; F2 75 00 0F 70 02
	fst.b	2(A5,D7.L)		; F2 75 00 0F 78 02
	fst.b	(0x1234).W		; F2 78 00 0F 12 34
	fst.b	(0x1234).L		; F2 79 00 0F 00 00 12
	fst.b	*0xFFFFFFF0		; F2 78 00 0F FF F0
	fst.b	 0x00010004		; F2 79 00 0F 00 01 00
	fst.b	(0x1234,A0,D1)		; F2 70 00 0F 11 20 12
	fst.b	([2,A1,A2],4)		; F2 71 00 0F A1 22 00
	fst.b	([6,A2],D3,8)		; F2 72 00 0F 31 26 00

	fssf	D7			; F2 47 00 10
	fssf	(A1)			; F2 51 00 10
	fssf	(A2)+			; F2 5A 00 10
	fssf	-(A3)			; F2 63 00 10
	fssf	1(A4)			; F2 6C 00 10 00 01
	fssf	2(A5,D7.W)		; F2 75 00 10 70 02
	fssf	2(A5,D7.L)		; F2 75 00 10 78 02
	fssf	(0x1234).W		; F2 78 00 10 12 34
	fssf	(0x1234).L		; F2 79 00 10 00 00 12
	fssf	*0xFFFFFFF0		; F2 78 00 10 FF F0
	fssf	 0x00010004		; F2 79 00 10 00 01 00
	fssf	(0x1234,A0,D1)		; F2 70 00 10 11 20 12
	fssf	([2,A1,A2],4)		; F2 71 00 10 A1 22 00
	fssf	([6,A2],D3,8)		; F2 72 00 10 31 26 00

	fssf.b	D7			; F2 47 00 10
	fssf.b	(A1)			; F2 51 00 10
	fssf.b	(A2)+			; F2 5A 00 10
	fssf.b	-(A3)			; F2 63 00 10
	fssf.b	1(A4)			; F2 6C 00 10 00 01
	fssf.b	2(A5,D7.W)		; F2 75 00 10 70 02
	fssf.b	2(A5,D7.L)		; F2 75 00 10 78 02
	fssf.b	(0x1234).W		; F2 78 00 10 12 34
	fssf.b	(0x1234).L		; F2 79 00 10 00 00 12
	fssf.b	*0xFFFFFFF0		; F2 78 00 10 FF F0
	fssf.b	 0x00010004		; F2 79 00 10 00 01 00
	fssf.b	(0x1234,A0,D1)		; F2 70 00 10 11 20 12
	fssf.b	([2,A1,A2],4)		; F2 71 00 10 A1 22 00
	fssf.b	([6,A2],D3,8)		; F2 72 00 10 31 26 00

	fsseq	D7			; F2 47 00 11
	fsseq	(A1)			; F2 51 00 11
	fsseq	(A2)+			; F2 5A 00 11
	fsseq	-(A3)			; F2 63 00 11
	fsseq	1(A4)			; F2 6C 00 11 00 01
	fsseq	2(A5,D7.W)		; F2 75 00 11 70 02
	fsseq	2(A5,D7.L)		; F2 75 00 11 78 02
	fsseq	(0x1234).W		; F2 78 00 11 12 34
	fsseq	(0x1234).L		; F2 79 00 11 00 00 12
	fsseq	*0xFFFFFFF0		; F2 78 00 11 FF F0
	fsseq	 0x00010004		; F2 79 00 11 00 01 00
	fsseq	(0x1234,A0,D1)		; F2 70 00 11 11 20 12
	fsseq	([2,A1,A2],4)		; F2 71 00 11 A1 22 00
	fsseq	([6,A2],D3,8)		; F2 72 00 11 31 26 00

	fsseq.b	D7			; F2 47 00 11
	fsseq.b	(A1)			; F2 51 00 11
	fsseq.b	(A2)+			; F2 5A 00 11
	fsseq.b	-(A3)			; F2 63 00 11
	fsseq.b	1(A4)			; F2 6C 00 11 00 01
	fsseq.b	2(A5,D7.W)		; F2 75 00 11 70 02
	fsseq.b	2(A5,D7.L)		; F2 75 00 11 78 02
	fsseq.b	(0x1234).W		; F2 78 00 11 12 34
	fsseq.b	(0x1234).L		; F2 79 00 11 00 00 12
	fsseq.b	*0xFFFFFFF0		; F2 78 00 11 FF F0
	fsseq.b	 0x00010004		; F2 79 00 11 00 01 00
	fsseq.b	(0x1234,A0,D1)		; F2 70 00 11 11 20 12
	fsseq.b	([2,A1,A2],4)		; F2 71 00 11 A1 22 00
	fsseq.b	([6,A2],D3,8)		; F2 72 00 11 31 26 00

	fsgt	D7			; F2 47 00 12
	fsgt	(A1)			; F2 51 00 12
	fsgt	(A2)+			; F2 5A 00 12
	fsgt	-(A3)			; F2 63 00 12
	fsgt	1(A4)			; F2 6C 00 12 00 01
	fsgt	2(A5,D7.W)		; F2 75 00 12 70 02
	fsgt	2(A5,D7.L)		; F2 75 00 12 78 02
	fsgt	(0x1234).W		; F2 78 00 12 12 34
	fsgt	(0x1234).L		; F2 79 00 12 00 00 12
	fsgt	*0xFFFFFFF0		; F2 78 00 12 FF F0
	fsgt	 0x00010004		; F2 79 00 12 00 01 00
	fsgt	(0x1234,A0,D1)		; F2 70 00 12 11 20 12
	fsgt	([2,A1,A2],4)		; F2 71 00 12 A1 22 00
	fsgt	([6,A2],D3,8)		; F2 72 00 12 31 26 00

	fsgt.b	D7			; F2 47 00 12
	fsgt.b	(A1)			; F2 51 00 12
	fsgt.b	(A2)+			; F2 5A 00 12
	fsgt.b	-(A3)			; F2 63 00 12
	fsgt.b	1(A4)			; F2 6C 00 12 00 01
	fsgt.b	2(A5,D7.W)		; F2 75 00 12 70 02
	fsgt.b	2(A5,D7.L)		; F2 75 00 12 78 02
	fsgt.b	(0x1234).W		; F2 78 00 12 12 34
	fsgt.b	(0x1234).L		; F2 79 00 12 00 00 12
	fsgt.b	*0xFFFFFFF0		; F2 78 00 12 FF F0
	fsgt.b	 0x00010004		; F2 79 00 12 00 01 00
	fsgt.b	(0x1234,A0,D1)		; F2 70 00 12 11 20 12
	fsgt.b	([2,A1,A2],4)		; F2 71 00 12 A1 22 00
	fsgt.b	([6,A2],D3,8)		; F2 72 00 12 31 26 00

	fsge	D7			; F2 47 00 13
	fsge	(A1)			; F2 51 00 13
	fsge	(A2)+			; F2 5A 00 13
	fsge	-(A3)			; F2 63 00 13
	fsge	1(A4)			; F2 6C 00 13 00 01
	fsge	2(A5,D7.W)		; F2 75 00 13 70 02
	fsge	2(A5,D7.L)		; F2 75 00 13 78 02
	fsge	(0x1234).W		; F2 78 00 13 12 34
	fsge	(0x1234).L		; F2 79 00 13 00 00 12
	fsge	*0xFFFFFFF0		; F2 78 00 13 FF F0
	fsge	 0x00010004		; F2 79 00 13 00 01 00
	fsge	(0x1234,A0,D1)		; F2 70 00 13 11 20 12
	fsge	([2,A1,A2],4)		; F2 71 00 13 A1 22 00
	fsge	([6,A2],D3,8)		; F2 72 00 13 31 26 00

	fsge.b	D7			; F2 47 00 13
	fsge.b	(A1)			; F2 51 00 13
	fsge.b	(A2)+			; F2 5A 00 13
	fsge.b	-(A3)			; F2 63 00 13
	fsge.b	1(A4)			; F2 6C 00 13 00 01
	fsge.b	2(A5,D7.W)		; F2 75 00 13 70 02
	fsge.b	2(A5,D7.L)		; F2 75 00 13 78 02
	fsge.b	(0x1234).W		; F2 78 00 13 12 34
	fsge.b	(0x1234).L		; F2 79 00 13 00 00 12
	fsge.b	*0xFFFFFFF0		; F2 78 00 13 FF F0
	fsge.b	 0x00010004		; F2 79 00 13 00 01 00
	fsge.b	(0x1234,A0,D1)		; F2 70 00 13 11 20 12
	fsge.b	([2,A1,A2],4)		; F2 71 00 13 A1 22 00
	fsge.b	([6,A2],D3,8)		; F2 72 00 13 31 26 00

	fslt	D7			; F2 47 00 14
	fslt	(A1)			; F2 51 00 14
	fslt	(A2)+			; F2 5A 00 14
	fslt	-(A3)			; F2 63 00 14
	fslt	1(A4)			; F2 6C 00 14 00 01
	fslt	2(A5,D7.W)		; F2 75 00 14 70 02
	fslt	2(A5,D7.L)		; F2 75 00 14 78 02
	fslt	(0x1234).W		; F2 78 00 14 12 34
	fslt	(0x1234).L		; F2 79 00 14 00 00 12
	fslt	*0xFFFFFFF0		; F2 78 00 14 FF F0
	fslt	 0x00010004		; F2 79 00 14 00 01 00
	fslt	(0x1234,A0,D1)		; F2 70 00 14 11 20 12
	fslt	([2,A1,A2],4)		; F2 71 00 14 A1 22 00
	fslt	([6,A2],D3,8)		; F2 72 00 14 31 26 00

	fslt.b	D7			; F2 47 00 14
	fslt.b	(A1)			; F2 51 00 14
	fslt.b	(A2)+			; F2 5A 00 14
	fslt.b	-(A3)			; F2 63 00 14
	fslt.b	1(A4)			; F2 6C 00 14 00 01
	fslt.b	2(A5,D7.W)		; F2 75 00 14 70 02
	fslt.b	2(A5,D7.L)		; F2 75 00 14 78 02
	fslt.b	(0x1234).W		; F2 78 00 14 12 34
	fslt.b	(0x1234).L		; F2 79 00 14 00 00 12
	fslt.b	*0xFFFFFFF0		; F2 78 00 14 FF F0
	fslt.b	 0x00010004		; F2 79 00 14 00 01 00
	fslt.b	(0x1234,A0,D1)		; F2 70 00 14 11 20 12
	fslt.b	([2,A1,A2],4)		; F2 71 00 14 A1 22 00
	fslt.b	([6,A2],D3,8)		; F2 72 00 14 31 26 00

	fsle	D7			; F2 47 00 15
	fsle	(A1)			; F2 51 00 15
	fsle	(A2)+			; F2 5A 00 15
	fsle	-(A3)			; F2 63 00 15
	fsle	1(A4)			; F2 6C 00 15 00 01
	fsle	2(A5,D7.W)		; F2 75 00 15 70 02
	fsle	2(A5,D7.L)		; F2 75 00 15 78 02
	fsle	(0x1234).W		; F2 78 00 15 12 34
	fsle	(0x1234).L		; F2 79 00 15 00 00 12
	fsle	*0xFFFFFFF0		; F2 78 00 15 FF F0
	fsle	 0x00010004		; F2 79 00 15 00 01 00
	fsle	(0x1234,A0,D1)		; F2 70 00 15 11 20 12
	fsle	([2,A1,A2],4)		; F2 71 00 15 A1 22 00
	fsle	([6,A2],D3,8)		; F2 72 00 15 31 26 00

	fsle.b	D7			; F2 47 00 15
	fsle.b	(A1)			; F2 51 00 15
	fsle.b	(A2)+			; F2 5A 00 15
	fsle.b	-(A3)			; F2 63 00 15
	fsle.b	1(A4)			; F2 6C 00 15 00 01
	fsle.b	2(A5,D7.W)		; F2 75 00 15 70 02
	fsle.b	2(A5,D7.L)		; F2 75 00 15 78 02
	fsle.b	(0x1234).W		; F2 78 00 15 12 34
	fsle.b	(0x1234).L		; F2 79 00 15 00 00 12
	fsle.b	*0xFFFFFFF0		; F2 78 00 15 FF F0
	fsle.b	 0x00010004		; F2 79 00 15 00 01 00
	fsle.b	(0x1234,A0,D1)		; F2 70 00 15 11 20 12
	fsle.b	([2,A1,A2],4)		; F2 71 00 15 A1 22 00
	fsle.b	([6,A2],D3,8)		; F2 72 00 15 31 26 00

	fsgl	D7			; F2 47 00 16
	fsgl	(A1)			; F2 51 00 16
	fsgl	(A2)+			; F2 5A 00 16
	fsgl	-(A3)			; F2 63 00 16
	fsgl	1(A4)			; F2 6C 00 16 00 01
	fsgl	2(A5,D7.W)		; F2 75 00 16 70 02
	fsgl	2(A5,D7.L)		; F2 75 00 16 78 02
	fsgl	(0x1234).W		; F2 78 00 16 12 34
	fsgl	(0x1234).L		; F2 79 00 16 00 00 12
	fsgl	*0xFFFFFFF0		; F2 78 00 16 FF F0
	fsgl	 0x00010004		; F2 79 00 16 00 01 00
	fsgl	(0x1234,A0,D1)		; F2 70 00 16 11 20 12
	fsgl	([2,A1,A2],4)		; F2 71 00 16 A1 22 00
	fsgl	([6,A2],D3,8)		; F2 72 00 16 31 26 00

	fsgl.b	D7			; F2 47 00 16
	fsgl.b	(A1)			; F2 51 00 16
	fsgl.b	(A2)+			; F2 5A 00 16
	fsgl.b	-(A3)			; F2 63 00 16
	fsgl.b	1(A4)			; F2 6C 00 16 00 01
	fsgl.b	2(A5,D7.W)		; F2 75 00 16 70 02
	fsgl.b	2(A5,D7.L)		; F2 75 00 16 78 02
	fsgl.b	(0x1234).W		; F2 78 00 16 12 34
	fsgl.b	(0x1234).L		; F2 79 00 16 00 00 12
	fsgl.b	*0xFFFFFFF0		; F2 78 00 16 FF F0
	fsgl.b	 0x00010004		; F2 79 00 16 00 01 00
	fsgl.b	(0x1234,A0,D1)		; F2 70 00 16 11 20 12
	fsgl.b	([2,A1,A2],4)		; F2 71 00 16 A1 22 00
	fsgl.b	([6,A2],D3,8)		; F2 72 00 16 31 26 00

	fsgle	D7			; F2 47 00 17
	fsgle	(A1)			; F2 51 00 17
	fsgle	(A2)+			; F2 5A 00 17
	fsgle	-(A3)			; F2 63 00 17
	fsgle	1(A4)			; F2 6C 00 17 00 01
	fsgle	2(A5,D7.W)		; F2 75 00 17 70 02
	fsgle	2(A5,D7.L)		; F2 75 00 17 78 02
	fsgle	(0x1234).W		; F2 78 00 17 12 34
	fsgle	(0x1234).L		; F2 79 00 17 00 00 12
	fsgle	*0xFFFFFFF0		; F2 78 00 17 FF F0
	fsgle	 0x00010004		; F2 79 00 17 00 01 00
	fsgle	(0x1234,A0,D1)		; F2 70 00 17 11 20 12
	fsgle	([2,A1,A2],4)		; F2 71 00 17 A1 22 00
	fsgle	([6,A2],D3,8)		; F2 72 00 17 31 26 00

	fsgle.b	D7			; F2 47 00 17
	fsgle.b	(A1)			; F2 51 00 17
	fsgle.b	(A2)+			; F2 5A 00 17
	fsgle.b	-(A3)			; F2 63 00 17
	fsgle.b	1(A4)			; F2 6C 00 17 00 01
	fsgle.b	2(A5,D7.W)		; F2 75 00 17 70 02
	fsgle.b	2(A5,D7.L)		; F2 75 00 17 78 02
	fsgle.b	(0x1234).W		; F2 78 00 17 12 34
	fsgle.b	(0x1234).L		; F2 79 00 17 00 00 12
	fsgle.b	*0xFFFFFFF0		; F2 78 00 17 FF F0
	fsgle.b	 0x00010004		; F2 79 00 17 00 01 00
	fsgle.b	(0x1234,A0,D1)		; F2 70 00 17 11 20 12
	fsgle.b	([2,A1,A2],4)		; F2 71 00 17 A1 22 00
	fsgle.b	([6,A2],D3,8)		; F2 72 00 17 31 26 00

	fsngle	D7			; F2 47 00 18
	fsngle	(A1)			; F2 51 00 18
	fsngle	(A2)+			; F2 5A 00 18
	fsngle	-(A3)			; F2 63 00 18
	fsngle	1(A4)			; F2 6C 00 18 00 01
	fsngle	2(A5,D7.W)		; F2 75 00 18 70 02
	fsngle	2(A5,D7.L)		; F2 75 00 18 78 02
	fsngle	(0x1234).W		; F2 78 00 18 12 34
	fsngle	(0x1234).L		; F2 79 00 18 00 00 12
	fsngle	*0xFFFFFFF0		; F2 78 00 18 FF F0
	fsngle	 0x00010004		; F2 79 00 18 00 01 00
	fsngle	(0x1234,A0,D1)		; F2 70 00 18 11 20 12
	fsngle	([2,A1,A2],4)		; F2 71 00 18 A1 22 00
	fsngle	([6,A2],D3,8)		; F2 72 00 18 31 26 00

	fsngle.b	D7		; F2 47 00 18
	fsngle.b	(A1)		; F2 51 00 18
	fsngle.b	(A2)+		; F2 5A 00 18
	fsngle.b	-(A3)		; F2 63 00 18
	fsngle.b	1(A4)		; F2 6C 00 18 00 01
	fsngle.b	2(A5,D7.W)	; F2 75 00 18 70 02
	fsngle.b	2(A5,D7.L)	; F2 75 00 18 78 02
	fsngle.b	(0x1234).W	; F2 78 00 18 12 34
	fsngle.b	(0x1234).L	; F2 79 00 18 00 00 12
	fsngle.b	*0xFFFFFFF0	; F2 78 00 18 FF F0
	fsngle.b	 0x00010004	; F2 79 00 18 00 01 00
	fsngle.b	(0x1234,A0,D1)	; F2 70 00 18 11 20 12
	fsngle.b	([2,A1,A2],4)	; F2 71 00 18 A1 22 00
	fsngle.b	([6,A2],D3,8)	; F2 72 00 18 31 26 00

	fsngl	D7			; F2 47 00 19
	fsngl	(A1)			; F2 51 00 19
	fsngl	(A2)+			; F2 5A 00 19
	fsngl	-(A3)			; F2 63 00 19
	fsngl	1(A4)			; F2 6C 00 19 00 01
	fsngl	2(A5,D7.W)		; F2 75 00 19 70 02
	fsngl	2(A5,D7.L)		; F2 75 00 19 78 02
	fsngl	(0x1234).W		; F2 78 00 19 12 34
	fsngl	(0x1234).L		; F2 79 00 19 00 00 12
	fsngl	*0xFFFFFFF0		; F2 78 00 19 FF F0
	fsngl	 0x00010004		; F2 79 00 19 00 01 00
	fsngl	(0x1234,A0,D1)		; F2 70 00 19 11 20 12
	fsngl	([2,A1,A2],4)		; F2 71 00 19 A1 22 00
	fsngl	([6,A2],D3,8)		; F2 72 00 19 31 26 00

	fsngl.b	D7			; F2 47 00 19
	fsngl.b	(A1)			; F2 51 00 19
	fsngl.b	(A2)+			; F2 5A 00 19
	fsngl.b	-(A3)			; F2 63 00 19
	fsngl.b	1(A4)			; F2 6C 00 19 00 01
	fsngl.b	2(A5,D7.W)		; F2 75 00 19 70 02
	fsngl.b	2(A5,D7.L)		; F2 75 00 19 78 02
	fsngl.b	(0x1234).W		; F2 78 00 19 12 34
	fsngl.b	(0x1234).L		; F2 79 00 19 00 00 12
	fsngl.b	*0xFFFFFFF0		; F2 78 00 19 FF F0
	fsngl.b	 0x00010004		; F2 79 00 19 00 01 00
	fsngl.b	(0x1234,A0,D1)		; F2 70 00 19 11 20 12
	fsngl.b	([2,A1,A2],4)		; F2 71 00 19 A1 22 00
	fsngl.b	([6,A2],D3,8)		; F2 72 00 19 31 26 00

	fsnle	D7			; F2 47 00 1A
	fsnle	(A1)			; F2 51 00 1A
	fsnle	(A2)+			; F2 5A 00 1A
	fsnle	-(A3)			; F2 63 00 1A
	fsnle	1(A4)			; F2 6C 00 1A 00 01
	fsnle	2(A5,D7.W)		; F2 75 00 1A 70 02
	fsnle	2(A5,D7.L)		; F2 75 00 1A 78 02
	fsnle	(0x1234).W		; F2 78 00 1A 12 34
	fsnle	(0x1234).L		; F2 79 00 1A 00 00 12
	fsnle	*0xFFFFFFF0		; F2 78 00 1A FF F0
	fsnle	 0x00010004		; F2 79 00 1A 00 01 00
	fsnle	(0x1234,A0,D1)		; F2 70 00 1A 11 20 12
	fsnle	([2,A1,A2],4)		; F2 71 00 1A A1 22 00
	fsnle	([6,A2],D3,8)		; F2 72 00 1A 31 26 00

	fsnle.b	D7			; F2 47 00 1A
	fsnle.b	(A1)			; F2 51 00 1A
	fsnle.b	(A2)+			; F2 5A 00 1A
	fsnle.b	-(A3)			; F2 63 00 1A
	fsnle.b	1(A4)			; F2 6C 00 1A 00 01
	fsnle.b	2(A5,D7.W)		; F2 75 00 1A 70 02
	fsnle.b	2(A5,D7.L)		; F2 75 00 1A 78 02
	fsnle.b	(0x1234).W		; F2 78 00 1A 12 34
	fsnle.b	(0x1234).L		; F2 79 00 1A 00 00 12
	fsnle.b	*0xFFFFFFF0		; F2 78 00 1A FF F0
	fsnle.b	 0x00010004		; F2 79 00 1A 00 01 00
	fsnle.b	(0x1234,A0,D1)		; F2 70 00 1A 11 20 12
	fsnle.b	([2,A1,A2],4)		; F2 71 00 1A A1 22 00
	fsnle.b	([6,A2],D3,8)		; F2 72 00 1A 31 26 00

	fsnlt	D7			; F2 47 00 1B
	fsnlt	(A1)			; F2 51 00 1B
	fsnlt	(A2)+			; F2 5A 00 1B
	fsnlt	-(A3)			; F2 63 00 1B
	fsnlt	1(A4)			; F2 6C 00 1B 00 01
	fsnlt	2(A5,D7.W)		; F2 75 00 1B 70 02
	fsnlt	2(A5,D7.L)		; F2 75 00 1B 78 02
	fsnlt	(0x1234).W		; F2 78 00 1B 12 34
	fsnlt	(0x1234).L		; F2 79 00 1B 00 00 12
	fsnlt	*0xFFFFFFF0		; F2 78 00 1B FF F0
	fsnlt	 0x00010004		; F2 79 00 1B 00 01 00
	fsnlt	(0x1234,A0,D1)		; F2 70 00 1B 11 20 12
	fsnlt	([2,A1,A2],4)		; F2 71 00 1B A1 22 00
	fsnlt	([6,A2],D3,8)		; F2 72 00 1B 31 26 00

	fsnlt.b	D7			; F2 47 00 1B
	fsnlt.b	(A1)			; F2 51 00 1B
	fsnlt.b	(A2)+			; F2 5A 00 1B
	fsnlt.b	-(A3)			; F2 63 00 1B
	fsnlt.b	1(A4)			; F2 6C 00 1B 00 01
	fsnlt.b	2(A5,D7.W)		; F2 75 00 1B 70 02
	fsnlt.b	2(A5,D7.L)		; F2 75 00 1B 78 02
	fsnlt.b	(0x1234).W		; F2 78 00 1B 12 34
	fsnlt.b	(0x1234).L		; F2 79 00 1B 00 00 12
	fsnlt.b	*0xFFFFFFF0		; F2 78 00 1B FF F0
	fsnlt.b	 0x00010004		; F2 79 00 1B 00 01 00
	fsnlt.b	(0x1234,A0,D1)		; F2 70 00 1B 11 20 12
	fsnlt.b	([2,A1,A2],4)		; F2 71 00 1B A1 22 00
	fsnlt.b	([6,A2],D3,8)		; F2 72 00 1B 31 26 00

	fsnge	D7			; F2 47 00 1C
	fsnge	(A1)			; F2 51 00 1C
	fsnge	(A2)+			; F2 5A 00 1C
	fsnge	-(A3)			; F2 63 00 1C
	fsnge	1(A4)			; F2 6C 00 1C 00 01
	fsnge	2(A5,D7.W)		; F2 75 00 1C 70 02
	fsnge	2(A5,D7.L)		; F2 75 00 1C 78 02
	fsnge	(0x1234).W		; F2 78 00 1C 12 34
	fsnge	(0x1234).L		; F2 79 00 1C 00 00 12
	fsnge	*0xFFFFFFF0		; F2 78 00 1C FF F0
	fsnge	 0x00010004		; F2 79 00 1C 00 01 00
	fsnge	(0x1234,A0,D1)		; F2 70 00 1C 11 20 12
	fsnge	([2,A1,A2],4)		; F2 71 00 1C A1 22 00
	fsnge	([6,A2],D3,8)		; F2 72 00 1C 31 26 00

	fsnge.b	D7			; F2 47 00 1C
	fsnge.b	(A1)			; F2 51 00 1C
	fsnge.b	(A2)+			; F2 5A 00 1C
	fsnge.b	-(A3)			; F2 63 00 1C
	fsnge.b	1(A4)			; F2 6C 00 1C 00 01
	fsnge.b	2(A5,D7.W)		; F2 75 00 1C 70 02
	fsnge.b	2(A5,D7.L)		; F2 75 00 1C 78 02
	fsnge.b	(0x1234).W		; F2 78 00 1C 12 34
	fsnge.b	(0x1234).L		; F2 79 00 1C 00 00 12
	fsnge.b	*0xFFFFFFF0		; F2 78 00 1C FF F0
	fsnge.b	 0x00010004		; F2 79 00 1C 00 01 00
	fsnge.b	(0x1234,A0,D1)		; F2 70 00 1C 11 20 12
	fsnge.b	([2,A1,A2],4)		; F2 71 00 1C A1 22 00
	fsnge.b	([6,A2],D3,8)		; F2 72 00 1C 31 26 00

	fsngt	D7			; F2 47 00 1D
	fsngt	(A1)			; F2 51 00 1D
	fsngt	(A2)+			; F2 5A 00 1D
	fsngt	-(A3)			; F2 63 00 1D
	fsngt	1(A4)			; F2 6C 00 1D 00 01
	fsngt	2(A5,D7.W)		; F2 75 00 1D 70 02
	fsngt	2(A5,D7.L)		; F2 75 00 1D 78 02
	fsngt	(0x1234).W		; F2 78 00 1D 12 34
	fsngt	(0x1234).L		; F2 79 00 1D 00 00 12
	fsngt	*0xFFFFFFF0		; F2 78 00 1D FF F0
	fsngt	 0x00010004		; F2 79 00 1D 00 01 00
	fsngt	(0x1234,A0,D1)		; F2 70 00 1D 11 20 12
	fsngt	([2,A1,A2],4)		; F2 71 00 1D A1 22 00
	fsngt	([6,A2],D3,8)		; F2 72 00 1D 31 26 00

	fsngt.b	D7			; F2 47 00 1D
	fsngt.b	(A1)			; F2 51 00 1D
	fsngt.b	(A2)+			; F2 5A 00 1D
	fsngt.b	-(A3)			; F2 63 00 1D
	fsngt.b	1(A4)			; F2 6C 00 1D 00 01
	fsngt.b	2(A5,D7.W)		; F2 75 00 1D 70 02
	fsngt.b	2(A5,D7.L)		; F2 75 00 1D 78 02
	fsngt.b	(0x1234).W		; F2 78 00 1D 12 34
	fsngt.b	(0x1234).L		; F2 79 00 1D 00 00 12
	fsngt.b	*0xFFFFFFF0		; F2 78 00 1D FF F0
	fsngt.b	 0x00010004		; F2 79 00 1D 00 01 00
	fsngt.b	(0x1234,A0,D1)		; F2 70 00 1D 11 20 12
	fsngt.b	([2,A1,A2],4)		; F2 71 00 1D A1 22 00
	fsngt.b	([6,A2],D3,8)		; F2 72 00 1D 31 26 00

	fssne	D7			; F2 47 00 1E
	fssne	(A1)			; F2 51 00 1E
	fssne	(A2)+			; F2 5A 00 1E
	fssne	-(A3)			; F2 63 00 1E
	fssne	1(A4)			; F2 6C 00 1E 00 01
	fssne	2(A5,D7.W)		; F2 75 00 1E 70 02
	fssne	2(A5,D7.L)		; F2 75 00 1E 78 02
	fssne	(0x1234).W		; F2 78 00 1E 12 34
	fssne	(0x1234).L		; F2 79 00 1E 00 00 12
	fssne	*0xFFFFFFF0		; F2 78 00 1E FF F0
	fssne	 0x00010004		; F2 79 00 1E 00 01 00
	fssne	(0x1234,A0,D1)		; F2 70 00 1E 11 20 12
	fssne	([2,A1,A2],4)		; F2 71 00 1E A1 22 00
	fssne	([6,A2],D3,8)		; F2 72 00 1E 31 26 00

	fssne.b	D7			; F2 47 00 1E
	fssne.b	(A1)			; F2 51 00 1E
	fssne.b	(A2)+			; F2 5A 00 1E
	fssne.b	-(A3)			; F2 63 00 1E
	fssne.b	1(A4)			; F2 6C 00 1E 00 01
	fssne.b	2(A5,D7.W)		; F2 75 00 1E 70 02
	fssne.b	2(A5,D7.L)		; F2 75 00 1E 78 02
	fssne.b	(0x1234).W		; F2 78 00 1E 12 34
	fssne.b	(0x1234).L		; F2 79 00 1E 00 00 12
	fssne.b	*0xFFFFFFF0		; F2 78 00 1E FF F0
	fssne.b	 0x00010004		; F2 79 00 1E 00 01 00
	fssne.b	(0x1234,A0,D1)		; F2 70 00 1E 11 20 12
	fssne.b	([2,A1,A2],4)		; F2 71 00 1E A1 22 00
	fssne.b	([6,A2],D3,8)		; F2 72 00 1E 31 26 00

	fsst	D7			; F2 47 00 1F
	fsst	(A1)			; F2 51 00 1F
	fsst	(A2)+			; F2 5A 00 1F
	fsst	-(A3)			; F2 63 00 1F
	fsst	1(A4)			; F2 6C 00 1F 00 01
	fsst	2(A5,D7.W)		; F2 75 00 1F 70 02
	fsst	2(A5,D7.L)		; F2 75 00 1F 78 02
	fsst	(0x1234).W		; F2 78 00 1F 12 34
	fsst	(0x1234).L		; F2 79 00 1F 00 00 12
	fsst	*0xFFFFFFF0		; F2 78 00 1F FF F0
	fsst	 0x00010004		; F2 79 00 1F 00 01 00
	fsst	(0x1234,A0,D1)		; F2 70 00 1F 11 20 12
	fsst	([2,A1,A2],4)		; F2 71 00 1F A1 22 00
	fsst	([6,A2],D3,8)		; F2 72 00 1F 31 26 00

	fsst.b	D7			; F2 47 00 1F
	fsst.b	(A1)			; F2 51 00 1F
	fsst.b	(A2)+			; F2 5A 00 1F
	fsst.b	-(A3)			; F2 63 00 1F
	fsst.b	1(A4)			; F2 6C 00 1F 00 01
	fsst.b	2(A5,D7.W)		; F2 75 00 1F 70 02
	fsst.b	2(A5,D7.L)		; F2 75 00 1F 78 02
	fsst.b	(0x1234).W		; F2 78 00 1F 12 34
	fsst.b	(0x1234).L		; F2 79 00 1F 00 00 12
	fsst.b	*0xFFFFFFF0		; F2 78 00 1F FF F0
	fsst.b	 0x00010004		; F2 79 00 1F 00 01 00
	fsst.b	(0x1234,A0,D1)		; F2 70 00 1F 11 20 12
	fsst.b	([2,A1,A2],4)		; F2 71 00 1F A1 22 00
	fsst.b	([6,A2],D3,8)		; F2 72 00 1F 31 26 00

	.sbttl	Type F_DCC Instructions: FDBcc, ...

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  F_DBCC:						*
	;*	FDBF, FDBEQ, FDBOGT, FDBOGE, 			*
	;*	FDBOLT, FDBOLE, FDBOGL, FDBOR,			*
	;*	FDBUN, FDBUEQ, FDBUGT, FDBUGE,			*
	;*	FDBULT, FDBULE, FDBNE, FDBT,			*
	;*	FDBSF, FDBSEQ, FDBGT, FDBGE,			*
	;*	FDBLT, FDBLE, FDBGL, FDBGLE,			*
	;*	FDBNGLE,FDBNGL, FDBNLE, FDBNLT,			*
	;*	FDBNGE, FDBNGT, FDBSNE, FDBST			*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	fdbf	D0,.			; F2 48 00 00 FF FC
	fdbf	D1,. + 0x02		; F2 49 00 00 FF FE
	fdbf	D2,. + 0x1002		; F2 4A 00 00 0F FE
	fdbf.w	D3,. + 0x12		; F2 4B 00 00 00 0E
	fdbf.w	D4,. + 0x1002		; F2 4C 00 00 0F FE

	fdbeq	D0,.			; F2 48 00 01 FF FC
	fdbeq	D1,. + 0x02		; F2 49 00 01 FF FE
	fdbeq	D2,. + 0x1002		; F2 4A 00 01 0F FE
	fdbeq.w	D3,. + 0x12		; F2 4B 00 01 00 0E
	fdbeq.w	D4,. + 0x1002		; F2 4C 00 01 0F FE

	fdbogt	D0,.			; F2 48 00 02 FF FC
	fdbogt	D1,. + 0x02		; F2 49 00 02 FF FE
	fdbogt	D2,. + 0x1002		; F2 4A 00 02 0F FE
	fdbogt.w	D3,. + 0x12	; F2 4B 00 02 00 0E
	fdbogt.w	D4,. + 0x1002	; F2 4C 00 02 0F FE

	fdboge	D0,.			; F2 48 00 03 FF FC
	fdboge	D1,. + 0x02		; F2 49 00 03 FF FE
	fdboge	D2,. + 0x1002		; F2 4A 00 03 0F FE
	fdboge.w	D3,. + 0x12	; F2 4B 00 03 00 0E
	fdboge.w	D4,. + 0x1002	; F2 4C 00 03 0F FE

	fdbolt	D0,.			; F2 48 00 04 FF FC
	fdbolt	D1,. + 0x02		; F2 49 00 04 FF FE
	fdbolt	D2,. + 0x1002		; F2 4A 00 04 0F FE
	fdbolt.w	D3,. + 0x12	; F2 4B 00 04 00 0E
	fdbolt.w	D4,. + 0x1002	; F2 4C 00 04 0F FE

	fdbole	D0,.			; F2 48 00 05 FF FC
	fdbole	D1,. + 0x02		; F2 49 00 05 FF FE
	fdbole	D2,. + 0x1002		; F2 4A 00 05 0F FE
	fdbole.w	D3,. + 0x12	; F2 4B 00 05 00 0E
	fdbole.w	D4,. + 0x1002	; F2 4C 00 05 0F FE

	fdbogl	D0,.			; F2 48 00 06 FF FC
	fdbogl	D1,. + 0x02		; F2 49 00 06 FF FE
	fdbogl	D2,. + 0x1002		; F2 4A 00 06 0F FE
	fdbogl.w	D3,. + 0x12	; F2 4B 00 06 00 0E
	fdbogl.w	D4,. + 0x1002	; F2 4C 00 06 0F FE

	fdbor	D0,.			; F2 48 00 07 FF FC
	fdbor	D1,. + 0x02		; F2 49 00 07 FF FE
	fdbor	D2,. + 0x1002		; F2 4A 00 07 0F FE
	fdbor.w	D3,. + 0x12		; F2 4B 00 07 00 0E
	fdbor.w	D4,. + 0x1002		; F2 4C 00 07 0F FE

	fdbun	D0,.			; F2 48 00 08 FF FC
	fdbun	D1,. + 0x02		; F2 49 00 08 FF FE
	fdbun	D2,. + 0x1002		; F2 4A 00 08 0F FE
	fdbun.w	D3,. + 0x12		; F2 4B 00 08 00 0E
	fdbun.w	D4,. + 0x1002		; F2 4C 00 08 0F FE

	fdbueq	D0,.			; F2 48 00 09 FF FC
	fdbueq	D1,. + 0x02		; F2 49 00 09 FF FE
	fdbueq	D2,. + 0x1002		; F2 4A 00 09 0F FE
	fdbueq.w	D3,. + 0x12	; F2 4B 00 09 00 0E
	fdbueq.w	D4,. + 0x1002	; F2 4C 00 09 0F FE

	fdbugt	D0,.			; F2 48 00 0A FF FC
	fdbugt	D1,. + 0x02		; F2 49 00 0A FF FE
	fdbugt	D2,. + 0x1002		; F2 4A 00 0A 0F FE
	fdbugt.w	D3,. + 0x12	; F2 4B 00 0A 00 0E
	fdbugt.w	D4,. + 0x1002	; F2 4C 00 0A 0F FE

	fdbuge	D0,.			; F2 48 00 0B FF FC
	fdbuge	D1,. + 0x02		; F2 49 00 0B FF FE
	fdbuge	D2,. + 0x1002		; F2 4A 00 0B 0F FE
	fdbuge.w	D3,. + 0x12	; F2 4B 00 0B 00 0E
	fdbuge.w	D4,. + 0x1002	; F2 4C 00 0B 0F FE

	fdbult	D0,.			; F2 48 00 0C FF FC
	fdbult	D1,. + 0x02		; F2 49 00 0C FF FE
	fdbult	D2,. + 0x1002		; F2 4A 00 0C 0F FE
	fdbult.w	D3,. + 0x12	; F2 4B 00 0C 00 0E
	fdbult.w	D4,. + 0x1002	; F2 4C 00 0C 0F FE

	fdbule	D0,.			; F2 48 00 0D FF FC
	fdbule	D1,. + 0x02		; F2 49 00 0D FF FE
	fdbule	D2,. + 0x1002		; F2 4A 00 0D 0F FE
	fdbule.w	D3,. + 0x12	; F2 4B 00 0D 00 0E
	fdbule.w	D4,. + 0x1002	; F2 4C 00 0D 0F FE

	fdbne	D0,.			; F2 48 00 0E FF FC
	fdbne	D1,. + 0x02		; F2 49 00 0E FF FE
	fdbne	D2,. + 0x1002		; F2 4A 00 0E 0F FE
	fdbne.w	D3,. + 0x12		; F2 4B 00 0E 00 0E
	fdbne.w	D4,. + 0x1002		; F2 4C 00 0E 0F FE

	fdbt	D0,.			; F2 48 00 0F FF FC
	fdbt	D1,. + 0x02		; F2 49 00 0F FF FE
	fdbt	D2,. + 0x1002		; F2 4A 00 0F 0F FE
	fdbt.w	D3,. + 0x12		; F2 4B 00 0F 00 0E
	fdbt.w	D4,. + 0x1002		; F2 4C 00 0F 0F FE

	fdbsf	D0,.			; F2 48 00 10 FF FC
	fdbsf	D1,. + 0x02		; F2 49 00 10 FF FE
	fdbsf	D2,. + 0x1002		; F2 4A 00 10 0F FE
	fdbsf.w	D3,. + 0x12		; F2 4B 00 10 00 0E
	fdbsf.w	D4,. + 0x1002		; F2 4C 00 10 0F FE

	fdbseq	D0,.			; F2 48 00 11 FF FC
	fdbseq	D1,. + 0x02		; F2 49 00 11 FF FE
	fdbseq	D2,. + 0x1002		; F2 4A 00 11 0F FE
	fdbseq.w	D3,. + 0x12	; F2 4B 00 11 00 0E
	fdbseq.w	D4,. + 0x1002	; F2 4C 00 11 0F FE

	fdbgt	D0,.			; F2 48 00 12 FF FC
	fdbgt	D1,. + 0x02		; F2 49 00 12 FF FE
	fdbgt	D2,. + 0x1002		; F2 4A 00 12 0F FE
	fdbgt.w	D3,. + 0x12		; F2 4B 00 12 00 0E
	fdbgt.w	D4,. + 0x1002		; F2 4C 00 12 0F FE

	fdbge	D0,.			; F2 48 00 13 FF FC
	fdbge	D1,. + 0x02		; F2 49 00 13 FF FE
	fdbge	D2,. + 0x1002		; F2 4A 00 13 0F FE
	fdbge.w	D3,. + 0x12		; F2 4B 00 13 00 0E
	fdbge.w	D4,. + 0x1002		; F2 4C 00 13 0F FE

	fdblt	D0,.			; F2 48 00 14 FF FC
	fdblt	D1,. + 0x02		; F2 49 00 14 FF FE
	fdblt	D2,. + 0x1002		; F2 4A 00 14 0F FE
	fdblt.w	D3,. + 0x12		; F2 4B 00 14 00 0E
	fdblt.w	D4,. + 0x1002		; F2 4C 00 14 0F FE

	fdble	D0,.			; F2 48 00 15 FF FC
	fdble	D1,. + 0x02		; F2 49 00 15 FF FE
	fdble	D2,. + 0x1002		; F2 4A 00 15 0F FE
	fdble.w	D3,. + 0x12		; F2 4B 00 15 00 0E
	fdble.w	D4,. + 0x1002		; F2 4C 00 15 0F FE

	fdbgl	D0,.			; F2 48 00 16 FF FC
	fdbgl	D1,. + 0x02		; F2 49 00 16 FF FE
	fdbgl	D2,. + 0x1002		; F2 4A 00 16 0F FE
	fdbgl.w	D3,. + 0x12		; F2 4B 00 16 00 0E
	fdbgl.w	D4,. + 0x1002		; F2 4C 00 16 0F FE

	fdbgle	D0,.			; F2 48 00 17 FF FC
	fdbgle	D1,. + 0x02		; F2 49 00 17 FF FE
	fdbgle	D2,. + 0x1002		; F2 4A 00 17 0F FE
	fdbgle.w	D3,. + 0x12	; F2 4B 00 17 00 0E
	fdbgle.w	D4,. + 0x1002	; F2 4C 00 17 0F FE

	fdbngle	D0,.			; F2 48 00 18 FF FC
	fdbngle	D1,. + 0x02		; F2 49 00 18 FF FE
	fdbngle	D2,. + 0x1002		; F2 4A 00 18 0F FE
	fdbngle.w	D3,. + 0x12	; F2 4B 00 18 00 0E
	fdbngle.w	D4,. + 0x1002	; F2 4C 00 18 0F FE

	fdbngl	D0,.			; F2 48 00 19 FF FC
	fdbngl	D1,. + 0x02		; F2 49 00 19 FF FE
	fdbngl	D2,. + 0x1002		; F2 4A 00 19 0F FE
	fdbngl.w	D3,. + 0x12	; F2 4B 00 19 00 0E
	fdbngl.w	D4,. + 0x1002	; F2 4C 00 19 0F FE

	fdbnle	D0,.			; F2 48 00 1A FF FC
	fdbnle	D1,. + 0x02		; F2 49 00 1A FF FE
	fdbnle	D2,. + 0x1002		; F2 4A 00 1A 0F FE
	fdbnle.w	D3,. + 0x12	; F2 4B 00 1A 00 0E
	fdbnle.w	D4,. + 0x1002	; F2 4C 00 1A 0F FE

	fdbnlt	D0,.			; F2 48 00 1B FF FC
	fdbnlt	D1,. + 0x02		; F2 49 00 1B FF FE
	fdbnlt	D2,. + 0x1002		; F2 4A 00 1B 0F FE
	fdbnlt.w	D3,. + 0x12	; F2 4B 00 1B 00 0E
	fdbnlt.w	D4,. + 0x1002	; F2 4C 00 1B 0F FE

	fdbnge	D0,.			; F2 48 00 1C FF FC
	fdbnge	D1,. + 0x02		; F2 49 00 1C FF FE
	fdbnge	D2,. + 0x1002		; F2 4A 00 1C 0F FE
	fdbnge.w	D3,. + 0x12	; F2 4B 00 1C 00 0E
	fdbnge.w	D4,. + 0x1002	; F2 4C 00 1C 0F FE

	fdbngt	D0,.			; F2 48 00 1D FF FC
	fdbngt	D1,. + 0x02		; F2 49 00 1D FF FE
	fdbngt	D2,. + 0x1002		; F2 4A 00 1D 0F FE
	fdbngt.w	D3,. + 0x12	; F2 4B 00 1D 00 0E
	fdbngt.w	D4,. + 0x1002	; F2 4C 00 1D 0F FE

	fdbsne	D0,.			; F2 48 00 1E FF FC
	fdbsne	D1,. + 0x02		; F2 49 00 1E FF FE
	fdbsne	D2,. + 0x1002		; F2 4A 00 1E 0F FE
	fdbsne.w	D3,. + 0x12	; F2 4B 00 1E 00 0E
	fdbsne.w	D4,. + 0x1002	; F2 4C 00 1E 0F FE

	fdbst	D0,.			; F2 48 00 1F FF FC
	fdbst	D1,. + 0x02		; F2 49 00 1F FF FE
	fdbst	D2,. + 0x1002		; F2 4A 00 1F 0F FE
	fdbst.w	D3,. + 0x12		; F2 4B 00 1F 00 0E
	fdbst.w	D4,. + 0x1002		; F2 4C 00 1F 0F FE

	.sbttl	Type F_TCC Instructions: FTcc, ...

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  F_TCC:						*
	;*	FTRAPF, FTRAPEQ, FTRAPOGT, FTRAPOGE, 		*
	;*	FTRAPOLT, FTRAPOLE, FTRAPOGL, FTRAPOR,		*
	;*	FTRAPUN, FTRAPUEQ, FTRAPUGT, FTRAPUGE,		*
	;*	FTRAPULT, FTRAPULE, FTRAPNE, FTRAPT,		*
	;*	FTRAPSF, FTRAPSEQ, FTRAPGT, FTRAPGE,		*
	;*	FTRAPLT, FTRAPLE, FTRAPGL, FTRAPGLE,		*
	;*	FTRAPNGLE,FTRAPNGL, FTRAPNLE, FTRAPNLT,		*
	;*	FTRAPNGE, FTRAPNGT, FTRAPSNE, FTRAPST		*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****


	ftrapf				; F2 7C 00 00
	ftrapf	#0x000F			; F2 7A 00 00 00 0F
	ftrapf	#0x000F0000		; F2 7B 00 00 00 0F 00

	ftrapf.w	#15		; F2 7A 00 00 00 0F

	ftrapf.l	#15		; F2 7B 00 00 00 00 00

	ftrapeq				; F2 7C 00 01
	ftrapeq	#0x000F			; F2 7A 00 01 00 0F
	ftrapeq	#0x000F0000		; F2 7B 00 01 00 0F 00

	ftrapeq.w	#15		; F2 7A 00 01 00 0F

	ftrapeq.l	#15		; F2 7B 00 01 00 00 00

	ftrapogt			; F2 7C 00 02
	ftrapogt	#0x000F		; F2 7A 00 02 00 0F
	ftrapogt	#0x000F0000	; F2 7B 00 02 00 0F 00

	ftrapogt.w	#15		; F2 7A 00 02 00 0F

	ftrapogt.l	#15		; F2 7B 00 02 00 00 00

	ftrapoge			; F2 7C 00 03
	ftrapoge	#0x000F		; F2 7A 00 03 00 0F
	ftrapoge	#0x000F0000	; F2 7B 00 03 00 0F 00

	ftrapoge.w	#15		; F2 7A 00 03 00 0F

	ftrapoge.l	#15		; F2 7B 00 03 00 00 00

	ftrapolt			; F2 7C 00 04
	ftrapolt	#0x000F		; F2 7A 00 04 00 0F
	ftrapolt	#0x000F0000	; F2 7B 00 04 00 0F 00

	ftrapolt.w	#15		; F2 7A 00 04 00 0F

	ftrapolt.l	#15		; F2 7B 00 04 00 00 00

	ftrapole			; F2 7C 00 05
	ftrapole	#0x000F		; F2 7A 00 05 00 0F
	ftrapole	#0x000F0000	; F2 7B 00 05 00 0F 00

	ftrapole.w	#15		; F2 7A 00 05 00 0F

	ftrapole.l	#15		; F2 7B 00 05 00 00 00

	ftrapogl			; F2 7C 00 06
	ftrapogl	#0x000F		; F2 7A 00 06 00 0F
	ftrapogl	#0x000F0000	; F2 7B 00 06 00 0F 00

	ftrapogl.w	#15		; F2 7A 00 06 00 0F

	ftrapogl.l	#15		; F2 7B 00 06 00 00 00

	ftrapor				; F2 7C 00 07
	ftrapor	#0x000F			; F2 7A 00 07 00 0F
	ftrapor	#0x000F0000		; F2 7B 00 07 00 0F 00

	ftrapor.w	#15		; F2 7A 00 07 00 0F

	ftrapor.l	#15		; F2 7B 00 07 00 00 00

	ftrapun				; F2 7C 00 08
	ftrapun	#0x000F			; F2 7A 00 08 00 0F
	ftrapun	#0x000F0000		; F2 7B 00 08 00 0F 00

	ftrapun.w	#15		; F2 7A 00 08 00 0F

	ftrapun.l	#15		; F2 7B 00 08 00 00 00

	ftrapueq			; F2 7C 00 09
	ftrapueq	#0x000F		; F2 7A 00 09 00 0F
	ftrapueq	#0x000F0000	; F2 7B 00 09 00 0F 00

	ftrapueq.w	#15		; F2 7A 00 09 00 0F

	ftrapueq.l	#15		; F2 7B 00 09 00 00 00

	ftrapugt			; F2 7C 00 0A
	ftrapugt	#0x000F		; F2 7A 00 0A 00 0F
	ftrapugt	#0x000F0000	; F2 7B 00 0A 00 0F 00

	ftrapugt.w	#15		; F2 7A 00 0A 00 0F

	ftrapugt.l	#15		; F2 7B 00 0A 00 00 00

	ftrapuge			; F2 7C 00 0B
	ftrapuge	#0x000F		; F2 7A 00 0B 00 0F
	ftrapuge	#0x000F0000	; F2 7B 00 0B 00 0F 00

	ftrapuge.w	#15		; F2 7A 00 0B 00 0F

	ftrapuge.l	#15		; F2 7B 00 0B 00 00 00

	ftrapult			; F2 7C 00 0C
	ftrapult	#0x000F		; F2 7A 00 0C 00 0F
	ftrapult	#0x000F0000	; F2 7B 00 0C 00 0F 00

	ftrapult.w	#15		; F2 7A 00 0C 00 0F

	ftrapult.l	#15		; F2 7B 00 0C 00 00 00

	ftrapule			; F2 7C 00 0D
	ftrapule	#0x000F		; F2 7A 00 0D 00 0F
	ftrapule	#0x000F0000	; F2 7B 00 0D 00 0F 00

	ftrapule.w	#15		; F2 7A 00 0D 00 0F

	ftrapule.l	#15		; F2 7B 00 0D 00 00 00

	ftrapne				; F2 7C 00 0E
	ftrapne	#0x000F			; F2 7A 00 0E 00 0F
	ftrapne	#0x000F0000		; F2 7B 00 0E 00 0F 00

	ftrapne.w	#15		; F2 7A 00 0E 00 0F

	ftrapne.l	#15		; F2 7B 00 0E 00 00 00

	ftrapt				; F2 7C 00 0F
	ftrapt	#0x000F			; F2 7A 00 0F 00 0F
	ftrapt	#0x000F0000		; F2 7B 00 0F 00 0F 00

	ftrapt.w	#15		; F2 7A 00 0F 00 0F

	ftrapt.l	#15		; F2 7B 00 0F 00 00 00

	ftrapsf				; F2 7C 00 10
	ftrapsf	#0x000F			; F2 7A 00 10 00 0F
	ftrapsf	#0x000F0000		; F2 7B 00 10 00 0F 00

	ftrapsf.w	#15		; F2 7A 00 10 00 0F

	ftrapsf.l	#15		; F2 7B 00 10 00 00 00

	ftrapseq			; F2 7C 00 11
	ftrapseq	#0x000F		; F2 7A 00 11 00 0F
	ftrapseq	#0x000F0000	; F2 7B 00 11 00 0F 00

	ftrapseq.w	#15		; F2 7A 00 11 00 0F

	ftrapseq.l	#15		; F2 7B 00 11 00 00 00

	ftrapgt				; F2 7C 00 12
	ftrapgt	#0x000F			; F2 7A 00 12 00 0F
	ftrapgt	#0x000F0000		; F2 7B 00 12 00 0F 00

	ftrapgt.w	#15		; F2 7A 00 12 00 0F

	ftrapgt.l	#15		; F2 7B 00 12 00 00 00

	ftrapge				; F2 7C 00 13
	ftrapge	#0x000F			; F2 7A 00 13 00 0F
	ftrapge	#0x000F0000		; F2 7B 00 13 00 0F 00

	ftrapge.w	#15		; F2 7A 00 13 00 0F

	ftrapge.l	#15		; F2 7B 00 13 00 00 00

	ftraplt				; F2 7C 00 14
	ftraplt	#0x000F			; F2 7A 00 14 00 0F
	ftraplt	#0x000F0000		; F2 7B 00 14 00 0F 00

	ftraplt.w	#15		; F2 7A 00 14 00 0F

	ftraplt.l	#15		; F2 7B 00 14 00 00 00

	ftraple				; F2 7C 00 15
	ftraple	#0x000F			; F2 7A 00 15 00 0F
	ftraple	#0x000F0000		; F2 7B 00 15 00 0F 00

	ftraple.w	#15		; F2 7A 00 15 00 0F

	ftraple.l	#15		; F2 7B 00 15 00 00 00

	ftrapgl				; F2 7C 00 16
	ftrapgl	#0x000F			; F2 7A 00 16 00 0F
	ftrapgl	#0x000F0000		; F2 7B 00 16 00 0F 00

	ftrapgl.w	#15		; F2 7A 00 16 00 0F

	ftrapgl.l	#15		; F2 7B 00 16 00 00 00

	ftrapgle			; F2 7C 00 17
	ftrapgle	#0x000F		; F2 7A 00 17 00 0F
	ftrapgle	#0x000F0000	; F2 7B 00 17 00 0F 00

	ftrapgle.w	#15		; F2 7A 00 17 00 0F

	ftrapgle.l	#15		; F2 7B 00 17 00 00 00

	ftrapngle			; F2 7C 00 18
	ftrapngle	#0x000F		; F2 7A 00 18 00 0F
	ftrapngle	#0x000F0000	; F2 7B 00 18 00 0F 00

	ftrapngle.w	#15		; F2 7A 00 18 00 0F

	ftrapngle.l	#15		; F2 7B 00 18 00 00 00

	ftrapngl			; F2 7C 00 19
	ftrapngl	#0x000F		; F2 7A 00 19 00 0F
	ftrapngl	#0x000F0000	; F2 7B 00 19 00 0F 00

	ftrapngl.w	#15		; F2 7A 00 19 00 0F

	ftrapngl.l	#15		; F2 7B 00 19 00 00 00

	ftrapnle			; F2 7C 00 1A
	ftrapnle	#0x000F		; F2 7A 00 1A 00 0F
	ftrapnle	#0x000F0000	; F2 7B 00 1A 00 0F 00

	ftrapnle.w	#15		; F2 7A 00 1A 00 0F

	ftrapnle.l	#15		; F2 7B 00 1A 00 00 00

	ftrapnlt			; F2 7C 00 1B
	ftrapnlt	#0x000F		; F2 7A 00 1B 00 0F
	ftrapnlt	#0x000F0000	; F2 7B 00 1B 00 0F 00

	ftrapnlt.w	#15		; F2 7A 00 1B 00 0F

	ftrapnlt.l	#15		; F2 7B 00 1B 00 00 00

	ftrapnge			; F2 7C 00 1C
	ftrapnge	#0x000F		; F2 7A 00 1C 00 0F
	ftrapnge	#0x000F0000	; F2 7B 00 1C 00 0F 00

	ftrapnge.w	#15		; F2 7A 00 1C 00 0F

	ftrapnge.l	#15		; F2 7B 00 1C 00 00 00

	ftrapngt			; F2 7C 00 1D
	ftrapngt	#0x000F		; F2 7A 00 1D 00 0F
	ftrapngt	#0x000F0000	; F2 7B 00 1D 00 0F 00

	ftrapngt.w	#15		; F2 7A 00 1D 00 0F

	ftrapngt.l	#15		; F2 7B 00 1D 00 00 00

	ftrapsne			; F2 7C 00 1E
	ftrapsne	#0x000F		; F2 7A 00 1E 00 0F
	ftrapsne	#0x000F0000	; F2 7B 00 1E 00 0F 00

	ftrapsne.w	#15		; F2 7A 00 1E 00 0F

	ftrapsne.l	#15		; F2 7B 00 1E 00 00 00

	ftrapst				; F2 7C 00 1F
	ftrapst	#0x000F			; F2 7A 00 1F 00 0F
	ftrapst	#0x000F0000		; F2 7B 00 1F 00 0F 00

	ftrapst.w	#15		; F2 7A 00 1F 00 0F

	ftrapst.l	#15		; F2 7B 00 1F 00 00 00

	.sbttl	Type F_NOP Instructions: FNOP

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  F_NOP:						*
	;*	FNOP						*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	fnop				; F2 80 00 00

	.sbttl	Type F_BCC Instructions: FBCC, ...

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

	fboge	.			; F2 86 FF FE
	fboge	. + 0x02		; F2 86 00 00
	fboge	. + 0x1002		; F2 86 10 00
	fboge	. + 0x20002		; F2 C6 00 02 00 00
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

	fboge	.			; F2 86 FF FE
	fboge	. + 0x02		; F2 86 00 00
	fboge	. + 0x1002		; F2 86 10 00
	fboge	. + 0x20002		; F2 C6 00 02 00 00
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

	.sbttl	Type F_SVRS Instructions: FSAVE, FRESTORE

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  F_SVRS:						*
	;*	FSAVE, FRESTORE					*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	fsave	(A1)			; F3 11
	fsave	(A2)			; F3 12
	fsave	-(A3)			; F3 23
	fsave	1(A4)			; F3 2C 00 01
	fsave	2(A5,D7.W)		; F3 35 70 02
	fsave	2(A5,D7.L)		; F3 35 78 02
	fsave	(0x1234).W		; F3 38 12 34
	fsave	(0x1234).L		; F3 39 00 00 12 34
	fsave	*0xFFFFFFF0		; F3 38 FF F0
	fsave	 0x00010004		; F3 39 00 01 00 04
	fsave	(0x1234,A0,D1)		; F3 30 11 20 12 34
	fsave	([2,A1,A2],4)		; F3 31 A1 22 00 02 00
	fsave	([6,A2],D3,8)		; F3 32 31 26 00 06 00

	frestore	(A1)		; F3 51
	frestore	(A2)+		; F3 5A
	frestore	1(A4)		; F3 6C 00 01
	frestore	2(A5,D7.W)	; F3 75 70 02
	frestore	2(A5,D7.L)	; F3 75 78 02
	frestore	(0x1234).W	; F3 78 12 34
	frestore	(0x1234).L	; F3 79 00 00 12 34
	frestore	*0xFFFFFFF0	; F3 78 FF F0
	frestore	 0x00010004	; F3 79 00 01 00 04
	frestore	(0x1234,A0,D1)	; F3 70 11 20 12 34
	frestore	([2,A1,A2],4)	; F3 71 A1 22 00 02 00
	frestore	([6,A2],D3,8)	; F3 72 31 26 00 06 00
	frestore	5(PC)		; F3 7A 00 03
	frestore	6(PC,A7.W)	; F3 7B F0 04
	frestore	6(PC,A7.L)	; F3 7B F8 04
	frestore	(0x1234,PC,D1)	; F3 7B 11 20 12 32
	frestore	([2,PC,A2],4)	; F3 7B A1 22 00 00 00
	frestore	([6,PC],D3,8)	; F3 7B 31 26 00 04 00

	.sbttl	Floating Point Constants

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;* Floating Point:					*
	;*	.flt16, .flt32, .flt64, .flt96, .fltpk		*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

	.flt16	111.11111		; 42 DE
	.flt32	111.11111		; 42 DE 38 E3
	.flt64	111.11111		; 40 5B C7 1C 6D 1E 10
				; 8C
	.flt96	111.11111		; 40 05 00 00 DE 38 E3
				;
	.fltpk	111.11111		; 00 02 00 01 11 11 11
				;

	.sbttl	Source Addressing Mode Checks

	  ; Dn

	cmp	D0,D1			; B2 40

	  ; An

	cmp	A1,D2			; B4 49

	  ; (An)

	cmp	(A2),D3			; B6 52

	  ; (An)+

	cmp	(A3)+,D4		; B8 5B

	  ; -(An)

	cmp	-(A4),D5		; BA 64

	  ; d16(An) / (d16,An)

	cmp	0x0012(A5),D6		; BC 6D 00 12
	cmp	0x1234(A5),D6		; BC 6D 12 34
	cmp	(0x0012,A5),D7		; BE 6D 00 12
	cmp	(0x1234,A5),D7		; BE 6D 12 34

	  ; d8(An,Xn) / (d8,An,Xn)

	cmp	4(A6,D1.W),D0		; B0 76 10 04
	cmp	4(A6,A7.L),D1		; B2 76 F8 04
	cmp	(4,A6,D1.W),D2		; B4 76 10 04
	cmp	(4,A6,A7.L),D3		; B6 76 F8 04

	  ;
	  ; Addressimg Modes Of Type ([bd,An,Xn],od)
	  ;
	  ; ([An]) / ([bd.W,An]) / ([bd.L,An])

	cmp	([A1]),D1		; B2 71 01 51
	cmp	([0x1234,A1]),D1	; B2 71 01 61 12 34
	cmp	([0x12345678,A1]),D1	; B2 71 01 71 12 34 56

	  ; ([An,Xn]) / ([An,Xn.W]) / ([An,Xn.L])

	cmp	([A1,D1]),D2		; B4 71 11 11
	cmp	([A1,A2]),D2		; B4 71 A1 11
	cmp	([A1,D1.W]),D2		; B4 71 11 11
	cmp	([A1,A2.L]),D2		; B4 71 A9 11
	cmp	([A1,D1.W*2]),D2	; B4 71 13 11
	cmp	([A1,A2.L*4]),D2	; B4 71 AD 11

	  ; ([bd.W,An,Xn]) / ([bd.W,An,Xn.W]) / ([bd.W,An,Xn.L])

	cmp	([0x1234,A1,D1]),D3	; B6 71 11 21 12 34
	cmp	([0x1234,A1,A2]),D3	; B6 71 A1 21 12 34
	cmp	([0x1234,A1,D1.W]),D3	; B6 71 11 21 12 34
	cmp	([0x1234,A1,A2.L]),D3	; B6 71 A9 21 12 34
	cmp	([0x1234,A1,D1.W*2]),D3	; B6 71 13 21 12 34
	cmp	([0x1234,A1,A2.L*4]),D3	; B6 71 AD 21 12 34

	  ; ([bd.L,An,Xn]) / ([bd.L,An,Xn.W]) / ([bd.L,An,Xn.L])

	cmp	([0x12345678,A1,D1]),D4	; B8 71 11 31 12 34 56
	cmp	([0x12345678,A1,A2]),D4	; B8 71 A1 31 12 34 56
	cmp	([0x12345678,A1,D1.W]),D4	; B8 71 11 31 12 34 56
	cmp	([0x12345678,A1,A2.L]),D4	; B8 71 A9 31 12 34 56
	cmp	([0x12345678,A1,D1.W*2]),D4	; B8 71 13 31 12 34 56
	cmp	([0x12345678,A1,A2.L*4]),D4	; B8 71 AD 31 12 34 56

	  ; ([An],od.W) / ([bd.W,An],od.W) / ([bd.L,An],od.W)

	cmp	([A1],0x4321),D1	; B2 71 01 52 43 21
	cmp	([0x1234,A1],0x4321),D1	; B2 71 01 62 12 34 43
	cmp	([0x12345678,A1],0x4321),D1	; B2 71 01 72 12 34 56

	  ; ([An,Xn],od.W) / ([An,Xn.W(SC)],od.W) / ([An,Xn.L(SC)],od.W

	cmp	([A1,D1],0x4321),D2	; B4 71 11 12 43 21
	cmp	([A1,A2],0x4321),D2	; B4 71 A1 12 43 21
	cmp	([A1,D1.W],0x4321),D2	; B4 71 11 12 43 21
	cmp	([A1,A2.L],0x4321),D2	; B4 71 A9 12 43 21
	cmp	([A1,D1.W*2],0x4321),D2	; B4 71 13 12 43 21
	cmp	([A1,A2.L*4],0x4321),D2	; B4 71 AD 12 43 21

	  ; ([bd.W,An,Xn],od.W) / ([bd.W,An,Xn.W(SC)],od.W) / ([bd.W,An,Xn.L(SC)],od.W

	cmp	([0x1234,A1,D1],0x4321),D3	; B6 71 11 22 12 34 43
	cmp	([0x1234,A1,A2],0x4321),D3	; B6 71 A1 22 12 34 43
	cmp	([0x1234,A1,D1.W],0x4321),D3	; B6 71 11 22 12 34 43
	cmp	([0x1234,A1,A2.L],0x4321),D3	; B6 71 A9 22 12 34 43
	cmp	([0x1234,A1,D1.W*2],0x4321),D3	; B6 71 13 22 12 34 43
	cmp	([0x1234,A1,A2.L*4],0x4321),D3	; B6 71 AD 22 12 34 43

	  ; ([bd.L,An,Xn],od.W) / ([bd.L,An,Xn.W(SC)],od.W) / ([bd.L,An,Xn.L(SC)],od.W

	cmp	([0x12345678,A1,D1],0x4321),D4	; B8 71 11 32 12 34 56
	cmp	([0x12345678,A1,A2],0x4321),D4	; B8 71 A1 32 12 34 56
	cmp	([0x12345678,A1,D1.W],0x4321),D4	; B8 71 11 32 12 34 56
	cmp	([0x12345678,A1,A2.L],0x4321),D4	; B8 71 A9 32 12 34 56
	cmp	([0x12345678,A1,D1.W*2],0x4321),D4	; B8 71 13 32 12 34 56
	cmp	([0x12345678,A1,A2.L*4],0x4321),D4	; B8 71 AD 32 12 34 56

	  ; ([An],od.L) / ([bd.W,An],od.L) / ([bd.L,An],od.L

	cmp	([A1],0x87654321),D1	; B2 71 01 53 87 65 43
	cmp	([0x1234,A1],0x87654321),D1	; B2 71 01 63 12 34 87
	cmp	([0x12345678,A1],0x87654321),D1		; B2 71 01 73 12 34 56

	  ; ([An,Xn],od.L) / ([An,Xn.W(SC)],od.L) / ([An,Xn.L(SC)],od.L

	cmp	([A1,D1],0x87654321),D2	; B4 71 11 13 87 65 43
	cmp	([A1,A2],0x87654321),D2	; B4 71 A1 13 87 65 43
	cmp	([A1,D1.W],0x87654321),D2	; B4 71 11 13 87 65 43
	cmp	([A1,A2.L],0x87654321),D2	; B4 71 A9 13 87 65 43
	cmp	([A1,D1.W*2],0x87654321),D2	; B4 71 13 13 87 65 43
	cmp	([A1,A2.L*4],0x87654321),D2	; B4 71 AD 13 87 65 43

	  ; ([bd.W,An,Xn],od.L) / ([bd.W,An,Xn.W(SC)],od.L) / ([bd.W,An,Xn.L(SC)],od.L

	cmp	([0x1234,A1,D1],0x87654321),D3	; B6 71 11 23 12 34 87
	cmp	([0x1234,A1,A2],0x87654321),D3	; B6 71 A1 23 12 34 87
	cmp	([0x1234,A1,D1.W],0x87654321),D3	; B6 71 11 23 12 34 87
	cmp	([0x1234,A1,A2.L],0x87654321),D3	; B6 71 A9 23 12 34 87
	cmp	([0x1234,A1,D1.W*2],0x87654321),D3	; B6 71 13 23 12 34 87
	cmp	([0x1234,A1,A2.L*4],0x87654321),D3	; B6 71 AD 23 12 34 87

	  ; ([bd.L,An,Xn],od.L) / ([bd.L,An,Xn.W(SC)],od.L) / ([bd.L,An,Xn.L(SC)],od.L

	cmp	([0x12345678,A1,D1],0x87654321),D4	; B8 71 11 33 12 34 56
	cmp	([0x12345678,A1,A2],0x87654321),D4	; B8 71 A1 33 12 34 56
	cmp	([0x12345678,A1,D1.W],0x87654321),D4	; B8 71 11 33 12 34 56
	cmp	([0x12345678,A1,A2.L],0x87654321),D4	; B8 71 A9 33 12 34 56
	cmp	([0x12345678,A1,D1.W*2],0x87654321),D4	; B8 71 13 33 12 34 56
	cmp	([0x12345678,A1,A2.L*4],0x87654321),D4	; B8 71 AD 33 12 34 56

	  ;
	  ; Addressimg Modes Of Type ([bd,An,Xn],od)
	  ; Testing For Blank Arguments And Optional Commas
	  ;
	  ; ([An]) / ([bd.W,An]) / ([bd.L,An])

	cmp	([,A1,],),D1		; B2 71 01 51
	cmp	([0x1234,A1,],),D1	; B2 71 01 61 12 34
	cmp	([0x12345678,A1,],),D1	; B2 71 01 71 12 34 56

	  ; ([An,Xn]) / ([An,Xn.W]) / ([An,Xn.L])

	cmp	([,A1,D1],),D2		; B4 71 11 11
	cmp	([,A1,A2],),D2		; B4 71 A1 11
	cmp	([,A1,D1.W],),D2	; B4 71 11 11
	cmp	([,A1,A2.L],),D2	; B4 71 A9 11
	cmp	([,A1,D1.W*2],),D2	; B4 71 13 11
	cmp	([,A1,A2.L*4],),D2	; B4 71 AD 11

	  ; ([bd.W,An,Xn]) / ([bd.W,An,Xn.W]) / ([bd.W,An,Xn.L])

	cmp	([0x1234,A1,D1],),D3	; B6 71 11 21 12 34
	cmp	([0x1234,A1,A2],),D3	; B6 71 A1 21 12 34
	cmp	([0x1234,A1,D1.W],),D3	; B6 71 11 21 12 34
	cmp	([0x1234,A1,A2.L],),D3	; B6 71 A9 21 12 34
	cmp	([0x1234,A1,D1.W*2],),D3	; B6 71 13 21 12 34
	cmp	([0x1234,A1,A2.L*4],),D3	; B6 71 AD 21 12 34

	  ; ([bd.L,An,Xn]) / ([bd.L,An,Xn.W]) / ([bd.L,An,Xn.L])

	cmp	([0x12345678,A1,D1],),D4	; B8 71 11 31 12 34 56
	cmp	([0x12345678,A1,A2],),D4	; B8 71 A1 31 12 34 56
	cmp	([0x12345678,A1,D1.W],),D4	; B8 71 11 31 12 34 56
	cmp	([0x12345678,A1,A2.L],),D4	; B8 71 A9 31 12 34 56
	cmp	([0x12345678,A1,D1.W*2],),D4	; B8 71 13 31 12 34 56
	cmp	([0x12345678,A1,A2.L*4],),D4	; B8 71 AD 31 12 34 56

	  ; ([An],od.W) / ([bd.W,An],od.W) / ([bd.L,An],od.W)

	cmp	([,A1,],0x4321),D1	; B2 71 01 52 43 21
	cmp	([0x1234,A1]0x4321),D1	; B2 71 01 62 12 34 43
	cmp	([0x12345678,A1,]0x4321),D1	; B2 71 01 72 12 34 56

	  ; ([An,Xn],od.W) / ([An,Xn.W(SC)],od.W) / ([An,Xn.L(SC)],od.W

	cmp	([,A1,D1],0x4321),D2	; B4 71 11 12 43 21
	cmp	([,A1,A2],0x4321),D2	; B4 71 A1 12 43 21
	cmp	([,A1,D1.W]0x4321),D2	; B4 71 11 12 43 21
	cmp	([,A1,A2.L]0x4321),D2	; B4 71 A9 12 43 21
	cmp	([,A1,D1.W*2]0x4321),D2	; B4 71 13 12 43 21
	cmp	([,A1,A2.L*4]0x4321),D2	; B4 71 AD 12 43 21

	  ; ([bd.W,An,Xn],od.W) / ([bd.W,An,Xn.W(SC)],od.W) / ([bd.W,An,Xn.L(SC)],od.W

	cmp	([0x1234,A1,D1]0x4321),D3	; B6 71 11 22 12 34 43
	cmp	([0x1234,A1,A2]0x4321),D3	; B6 71 A1 22 12 34 43
	cmp	([0x1234,A1,D1.W]0x4321),D3	; B6 71 11 22 12 34 43
	cmp	([0x1234,A1,A2.L]0x4321),D3	; B6 71 A9 22 12 34 43
	cmp	([0x1234,A1,D1.W*2]0x4321),D3	; B6 71 13 22 12 34 43
	cmp	([0x1234,A1,A2.L*4]0x4321),D3	; B6 71 AD 22 12 34 43

	  ; ([bd.L,An,Xn],od.W) / ([bd.L,An,Xn.W(SC)],od.W) / ([bd.L,An,Xn.L(SC)],od.W

	cmp	([0x12345678,A1,D1]0x4321),D4	; B8 71 11 32 12 34 56
	cmp	([0x12345678,A1,A2]0x4321),D4	; B8 71 A1 32 12 34 56
	cmp	([0x12345678,A1,D1.W]0x4321),D4		; B8 71 11 32 12 34 56
	cmp	([0x12345678,A1,A2.L]0x4321),D4		; B8 71 A9 32 12 34 56
	cmp	([0x12345678,A1,D1.W*2]0x4321),D4	; B8 71 13 32 12 34 56
	cmp	([0x12345678,A1,A2.L*4]0x4321),D4	; B8 71 AD 32 12 34 56

	  ; ([An],od.L) / ([bd.W,An],od.L) / ([bd.L,An],od.L

	cmp	([,A1,]0x87654321),D1	; B2 71 01 53 87 65 43
	cmp	([0x1234,A1,]0x87654321),D1	; B2 71 01 63 12 34 87
	cmp	([0x12345678,A1,]0x87654321),D1		; B2 71 01 73 12 34 56

	  ; ([An,Xn],od.L) / ([An,Xn.W(SC)],od.L) / ([An,Xn.L(SC)],od.L

	cmp	([,A1,D1]0x87654321),D2	; B4 71 11 13 87 65 43
	cmp	([,A1,A2]0x87654321),D2	; B4 71 A1 13 87 65 43
	cmp	([,A1,D1.W]0x87654321),D2	; B4 71 11 13 87 65 43
	cmp	([,A1,A2.L]0x87654321),D2	; B4 71 A9 13 87 65 43
	cmp	([,A1,D1.W*2]0x87654321),D2	; B4 71 13 13 87 65 43
	cmp	([,A1,A2.L*4]0x87654321),D2	; B4 71 AD 13 87 65 43

	  ; ([bd.W,An,Xn],od.L) / ([bd.W,An,Xn.W(SC)],od.L) / ([bd.W,An,Xn.L(SC)],od.L

	cmp	([0x1234,A1,D1]0x87654321),D3	; B6 71 11 23 12 34 87
	cmp	([0x1234,A1,A2]0x87654321),D3	; B6 71 A1 23 12 34 87
	cmp	([0x1234,A1,D1.W]0x87654321),D3		; B6 71 11 23 12 34 87
	cmp	([0x1234,A1,A2.L]0x87654321),D3		; B6 71 A9 23 12 34 87
	cmp	([0x1234,A1,D1.W*2]0x87654321),D3	; B6 71 13 23 12 34 87
	cmp	([0x1234,A1,A2.L*4]0x87654321),D3	; B6 71 AD 23 12 34 87

	  ; ([bd.L,An,Xn],od.L) / ([bd.L,An,Xn.W(SC)],od.L) / ([bd.L,An,Xn.L(SC)],od.L

	cmp	([0x12345678,A1,D1]0x87654321),D4	; B8 71 11 33 12 34 56
	cmp	([0x12345678,A1,A2]0x87654321),D4	; B8 71 A1 33 12 34 56
	cmp	([0x12345678,A1,D1.W]0x87654321),D4	; B8 71 11 33 12 34 56
	cmp	([0x12345678,A1,A2.L]0x87654321),D4	; B8 71 A9 33 12 34 56
	cmp	([0x12345678,A1,D1.W*2]0x87654321),D4	; B8 71 13 33 12 34 56
	cmp	([0x12345678,A1,A2.L*4]0x87654321),D4	; B8 71 AD 33 12 34 56

	  ; *addr / addr / (addr).W / (addr).L

	cmp	*0xFFFFFFF0,D5		; BA 78 FF F0
	cmp	 0x00000004,D5		; BA 78 00 04
	cmp	 0x00010004,D5		; BA 79 00 01 00 04
	cmp	(0x1234).W,D5		; BA 78 12 34
	cmp	(0x1234).L,D5		; BA 79 00 00 12 34

	  ; #

	cmp	#0x00000007,D6		; 0C 46 00 07
	cmp.w	#0x00007007,D6		; 0C 46 70 07
	cmp.l	#0x00070007,D6		; 0C 86 00 07 00 07

	  ; d16(PC) / (d16,PC)

	cmp	0x0012(PC),D6		; BC 7A 00 10
	cmp	0x1234(PC),D6		; BC 7A 12 32
	cmp	(0x0012,PC),D7		; BE 7A 00 10
	cmp	(0x1234,PC),D7		; BE 7A 12 32

	  ; d8(PC,Xn) / (d8,PC,Xn)

	cmp	4(PC,D1.W),D0		; B0 7B 10 02
	cmp	4(PC,A7.L),D1		; B2 7B F8 02
	cmp	(4,PC,D1.W),D2		; B4 7B 10 02
	cmp	(4,PC,A7.L),D3		; B6 7B F8 02

	  ;
	  ; Addressimg Modes Of Type ([bd,PC,Xn],od)
	  ;
	  ; ([PC]) / ([bd.W,PC]) / ([bd.L,PC])

	cmp	([PC]),D1		; B2 7B 01 51
	cmp	([0x1234,PC]),D1	; B2 7B 01 61 12 32
	cmp	([0x12345678,PC]),D1	; B2 7B 01 71 12 34 56

	  ; ([PC,Xn]) / ([PC,Xn.W]) / ([PC,Xn.L])

	cmp	([PC,D1]),D2		; B4 7B 11 11
	cmp	([PC,A2]),D2		; B4 7B A1 11
	cmp	([PC,D1.W]),D2		; B4 7B 11 11
	cmp	([PC,A2.L]),D2		; B4 7B A9 11
	cmp	([PC,D1.W*2]),D2	; B4 7B 13 11
	cmp	([PC,A2.L*4]),D2	; B4 7B AD 11

	  ; ([bd.W,PC,Xn]) / ([bd.W,PC,Xn.W]) / ([bd.W,PC,Xn.L])

	cmp	([0x1234,PC,D1]),D3	; B6 7B 11 21 12 32
	cmp	([0x1234,PC,A2]),D3	; B6 7B A1 21 12 32
	cmp	([0x1234,PC,D1.W]),D3	; B6 7B 11 21 12 32
	cmp	([0x1234,PC,A2.L]),D3	; B6 7B A9 21 12 32
	cmp	([0x1234,PC,D1.W*2]),D3	; B6 7B 13 21 12 32
	cmp	([0x1234,PC,A2.L*4]),D3	; B6 7B AD 21 12 32

	  ; ([bd.L,PC,Xn]) / ([bd.L,PC,Xn.W]) / ([bd.L,PC,Xn.L])

	cmp	([0x12345678,PC,D1]),D4	; B8 7B 11 31 12 34 56
	cmp	([0x12345678,PC,A2]),D4	; B8 7B A1 31 12 34 56
	cmp	([0x12345678,PC,D1.W]),D4	; B8 7B 11 31 12 34 56
	cmp	([0x12345678,PC,A2.L]),D4	; B8 7B A9 31 12 34 56
	cmp	([0x12345678,PC,D1.W*2]),D4	; B8 7B 13 31 12 34 56
	cmp	([0x12345678,PC,A2.L*4]),D4	; B8 7B AD 31 12 34 56

	  ; ([PC],od.W) / ([bd.W,PC],od.W) / ([bd.L,PC],od.W)

	cmp	([PC],0x4321),D1	; B2 7B 01 52 43 21
	cmp	([0x1234,PC],0x4321),D1	; B2 7B 01 62 12 32 43
	cmp	([0x12345678,PC],0x4321),D1	; B2 7B 01 72 12 34 56

	  ; ([PC,Xn],od.W) / ([PC,Xn.W(SC)],od.W) / ([PC,Xn.L(SC)],od.W

	cmp	([PC,D1],0x4321),D2	; B4 7B 11 12 43 21
	cmp	([PC,A2],0x4321),D2	; B4 7B A1 12 43 21
	cmp	([PC,D1.W],0x4321),D2	; B4 7B 11 12 43 21
	cmp	([PC,A2.L],0x4321),D2	; B4 7B A9 12 43 21
	cmp	([PC,D1.W*2],0x4321),D2	; B4 7B 13 12 43 21
	cmp	([PC,A2.L*4],0x4321),D2	; B4 7B AD 12 43 21

	  ; ([bd.W,PC,Xn],od.W) / ([bd.W,PC,Xn.W(SC)],od.W) / ([bd.W,PC,Xn.L(SC)],od.W

	cmp	([0x1234,PC,D1],0x4321),D3	; B6 7B 11 22 12 32 43
	cmp	([0x1234,PC,A2],0x4321),D3	; B6 7B A1 22 12 32 43
	cmp	([0x1234,PC,D1.W],0x4321),D3	; B6 7B 11 22 12 32 43
	cmp	([0x1234,PC,A2.L],0x4321),D3	; B6 7B A9 22 12 32 43
	cmp	([0x1234,PC,D1.W*2],0x4321),D3	; B6 7B 13 22 12 32 43
	cmp	([0x1234,PC,A2.L*4],0x4321),D3	; B6 7B AD 22 12 32 43

	  ; ([bd.L,PC,Xn],od.W) / ([bd.L,PC,Xn.W(SC)],od.W) / ([bd.L,PC,Xn.L(SC)],od.W

	cmp	([0x12345678,PC,D1],0x4321),D4	; B8 7B 11 32 12 34 56
	cmp	([0x12345678,PC,A2],0x4321),D4	; B8 7B A1 32 12 34 56
	cmp	([0x12345678,PC,D1.W],0x4321),D4	; B8 7B 11 32 12 34 56
	cmp	([0x12345678,PC,A2.L],0x4321),D4	; B8 7B A9 32 12 34 56
	cmp	([0x12345678,PC,D1.W*2],0x4321),D4	; B8 7B 13 32 12 34 56
	cmp	([0x12345678,PC,A2.L*4],0x4321),D4	; B8 7B AD 32 12 34 56

	  ; ([PC],od.L) / ([bd.W,PC],od.L) / ([bd.L,PC],od.L

	cmp	([PC],0x87654321),D1	; B2 7B 01 53 87 65 43
	cmp	([0x1234,PC],0x87654321),D1	; B2 7B 01 63 12 32 87
	cmp	([0x12345678,PC],0x87654321),D1		; B2 7B 01 73 12 34 56

	  ; ([PC,Xn],od.L) / ([PC,Xn.W(SC)],od.L) / ([PC,Xn.L(SC)],od.L

	cmp	([PC,D1],0x87654321),D2	; B4 7B 11 13 87 65 43
	cmp	([PC,A2],0x87654321),D2	; B4 7B A1 13 87 65 43
	cmp	([PC,D1.W],0x87654321),D2	; B4 7B 11 13 87 65 43
	cmp	([PC,A2.L],0x87654321),D2	; B4 7B A9 13 87 65 43
	cmp	([PC,D1.W*2],0x87654321),D2	; B4 7B 13 13 87 65 43
	cmp	([PC,A2.L*4],0x87654321),D2	; B4 7B AD 13 87 65 43

	  ; ([bd.W,PC,Xn],od.L) / ([bd.W,PC,Xn.W(SC)],od.L) / ([bd.W,PC,Xn.L(SC)],od.L

	cmp	([0x1234,PC,D1],0x87654321),D3	; B6 7B 11 23 12 32 87
	cmp	([0x1234,PC,A2],0x87654321),D3	; B6 7B A1 23 12 32 87
	cmp	([0x1234,PC,D1.W],0x87654321),D3	; B6 7B 11 23 12 32 87
	cmp	([0x1234,PC,A2.L],0x87654321),D3	; B6 7B A9 23 12 32 87
	cmp	([0x1234,PC,D1.W*2],0x87654321),D3	; B6 7B 13 23 12 32 87
	cmp	([0x1234,PC,A2.L*4],0x87654321),D3	; B6 7B AD 23 12 32 87

	  ; ([bd.L,PC,Xn],od.L) / ([bd.L,PC,Xn.W(SC)],od.L) / ([bd.L,PC,Xn.L(SC)],od.L

	cmp	([0x12345678,PC,D1],0x87654321),D4	; B8 7B 11 33 12 34 56
	cmp	([0x12345678,PC,A2],0x87654321),D4	; B8 7B A1 33 12 34 56
	cmp	([0x12345678,PC,D1.W],0x87654321),D4	; B8 7B 11 33 12 34 56
	cmp	([0x12345678,PC,A2.L],0x87654321),D4	; B8 7B A9 33 12 34 56
	cmp	([0x12345678,PC,D1.W*2],0x87654321),D4	; B8 7B 13 33 12 34 56
	cmp	([0x12345678,PC,A2.L*4],0x87654321),D4	; B8 7B AD 33 12 34 56

	  ;
	  ; Addressimg Modes Of Type ([bd,PC,Xn],od)
	  ; Testing For Blank Arguments And Optional Commas
	  ;
	  ; ([PC]) / ([bd.W,PC]) / ([bd.L,PC])

	cmp	([,PC,],),D1		; B2 7B 01 51
	cmp	([0x1234,PC,],),D1	; B2 7B 01 61 12 32
	cmp	([0x12345678,PC,],),D1	; B2 7B 01 71 12 34 56

	  ; ([PC,Xn]) / ([PC,Xn.W]) / ([PC,Xn.L])

	cmp	([,PC,D1],),D2		; B4 7B 11 11
	cmp	([,PC,A2],),D2		; B4 7B A1 11
	cmp	([,PC,D1.W],),D2	; B4 7B 11 11
	cmp	([,PC,A2.L],),D2	; B4 7B A9 11
	cmp	([,PC,D1.W*2],),D2	; B4 7B 13 11
	cmp	([,PC,A2.L*4],),D2	; B4 7B AD 11

	  ; ([bd.W,PC,Xn]) / ([bd.W,PC,Xn.W]) / ([bd.W,PC,Xn.L])

	cmp	([0x1234,PC,D1],),D3	; B6 7B 11 21 12 32
	cmp	([0x1234,PC,A2],),D3	; B6 7B A1 21 12 32
	cmp	([0x1234,PC,D1.W],),D3	; B6 7B 11 21 12 32
	cmp	([0x1234,PC,A2.L],),D3	; B6 7B A9 21 12 32
	cmp	([0x1234,PC,D1.W*2],),D3	; B6 7B 13 21 12 32
	cmp	([0x1234,PC,A2.L*4]),D3	; B6 7B AD 21 12 32

	  ; ([bd.L,PC,Xn]) / ([bd.L,PC,Xn.W]) / ([bd.L,PC,Xn.L])

	cmp	([0x12345678,PC,D1],),D4	; B8 7B 11 31 12 34 56
	cmp	([0x12345678,PC,A2],),D4	; B8 7B A1 31 12 34 56
	cmp	([0x12345678,PC,D1.W],),D4	; B8 7B 11 31 12 34 56
	cmp	([0x12345678,PC,A2.L],),D4	; B8 7B A9 31 12 34 56
	cmp	([0x12345678,PC,D1.W*2],),D4	; B8 7B 13 31 12 34 56
	cmp	([0x12345678,PC,A2.L*4],),D4	; B8 7B AD 31 12 34 56

	  ; ([PC],od.W) / ([bd.W,PC],od.W) / ([bd.L,PC],od.W)

	cmp	([,PC,]0x4321),D1	; B2 7B 01 52 43 21
	cmp	([0x1234,PC,]0x4321),D1	; B2 7B 01 62 12 32 43
	cmp	([0x12345678,PC,]0x4321),D1	; B2 7B 01 72 12 34 56

	  ; ([PC,Xn],od.W) / ([PC,Xn.W(SC)],od.W) / ([PC,Xn.L(SC)],od.W

	cmp	([PC,D1,]0x4321),D2	; B4 7B 11 12 43 21
	cmp	([PC,A2,]0x4321),D2	; B4 7B A1 12 43 21
	cmp	([PC,D1.W,]0x4321),D2	; B4 7B 11 12 43 21
	cmp	([PC,A2.L,]0x4321),D2	; B4 7B A9 12 43 21
	cmp	([PC,D1.W*2,]0x4321),D2	; B4 7B 13 12 43 21
	cmp	([PC,A2.L*4,]0x4321),D2	; B4 7B AD 12 43 21

	  ; ([bd.W,PC,Xn],od.W) / ([bd.W,PC,Xn.W(SC)],od.W) / ([bd.W,PC,Xn.L(SC)],od.W

	cmp	([0x1234,PC,D1]0x4321),D3	; B6 7B 11 22 12 32 43
	cmp	([0x1234,PC,A2]0x4321),D3	; B6 7B A1 22 12 32 43
	cmp	([0x1234,PC,D1.W]0x4321),D3	; B6 7B 11 22 12 32 43
	cmp	([0x1234,PC,A2.L]0x4321),D3	; B6 7B A9 22 12 32 43
	cmp	([0x1234,PC,D1.W*2]0x4321),D3	; B6 7B 13 22 12 32 43
	cmp	([0x1234,PC,A2.L*4]0x4321),D3	; B6 7B AD 22 12 32 43

	  ; ([bd.L,PC,Xn],od.W) / ([bd.L,PC,Xn.W(SC)],od.W) / ([bd.L,PC,Xn.L(SC)],od.W

	cmp	([0x12345678,PC,D1]0x4321),D4	; B8 7B 11 32 12 34 56
	cmp	([0x12345678,PC,A2]0x4321),D4	; B8 7B A1 32 12 34 56
	cmp	([0x12345678,PC,D1.W]0x4321),D4		; B8 7B 11 32 12 34 56
	cmp	([0x12345678,PC,A2.L]0x4321),D4		; B8 7B A9 32 12 34 56
	cmp	([0x12345678,PC,D1.W*2]0x4321),D4	; B8 7B 13 32 12 34 56
	cmp	([0x12345678,PC,A2.L*4]0x4321),D4	; B8 7B AD 32 12 34 56

	  ; ([PC],od.L) / ([bd.W,PC],od.L) / ([bd.L,PC],od.L

	cmp	([,PC,]0x87654321),D1	; B2 7B 01 53 87 65 43
	cmp	([0x1234,PC,]0x87654321),D1	; B2 7B 01 63 12 32 87
	cmp	([0x12345678,PC,]0x87654321),D1		; B2 7B 01 73 12 34 56

	  ; ([PC,Xn],od.L) / ([PC,Xn.W(SC)],od.L) / ([PC,Xn.L(SC)],od.L

	cmp	([,PC,D1]0x87654321),D2	; B4 7B 11 13 87 65 43
	cmp	([,PC,A2]0x87654321),D2	; B4 7B A1 13 87 65 43
	cmp	([,PC,D1.W]0x87654321),D2	; B4 7B 11 13 87 65 43
	cmp	([,PC,A2.L]0x87654321),D2	; B4 7B A9 13 87 65 43
	cmp	([,PC,D1.W*2]0x87654321),D2	; B4 7B 13 13 87 65 43
	cmp	([,PC,A2.L*4]0x87654321),D2	; B4 7B AD 13 87 65 43

	  ; ([bd.W,PC,Xn],od.L) / ([bd.W,PC,Xn.W(SC)],od.L) / ([bd.W,PC,Xn.L(SC)],od.L

	cmp	([0x1234,PC,D1]0x87654321),D3	; B6 7B 11 23 12 32 87
	cmp	([0x1234,PC,A2]0x87654321),D3	; B6 7B A1 23 12 32 87
	cmp	([0x1234,PC,D1.W]0x87654321),D3		; B6 7B 11 23 12 32 87
	cmp	([0x1234,PC,A2.L]0x87654321),D3		; B6 7B A9 23 12 32 87
	cmp	([0x1234,PC,D1.W*2]0x87654321),D3	; B6 7B 13 23 12 32 87
	cmp	([0x1234,PC,A2.L*4]0x87654321),D3	; B6 7B AD 23 12 32 87

	  ; ([bd.L,PC,Xn],od.L) / ([bd.L,PC,Xn.W(SC)],od.L) / ([bd.L,PC,Xn.L(SC)],od.L

	cmp	([0x12345678,PC,D1]0x87654321),D4	; B8 7B 11 33 12 34 56
	cmp	([0x12345678,PC,A2]0x87654321),D4	; B8 7B A1 33 12 34 56
	cmp	([0x12345678,PC,D1.W]0x87654321),D4	; B8 7B 11 33 12 34 56
	cmp	([0x12345678,PC,A2.L]0x87654321),D4	; B8 7B A9 33 12 34 56
	cmp	([0x12345678,PC,D1.W*2]0x87654321),D4	; B8 7B 13 33 12 34 56
	cmp	([0x12345678,PC,A2.L*4]0x87654321),D4	; B8 7B AD 33 12 34 56

	  ;
	  ; External Addressing
	  ;

	  ; d16(An) / (d16,An)

	cmp	(xb+0x12)(A5),D6	; BC 6D 01 70 00 00 00
	cmp	(xw+0x1234)(A5),D6	; BC 6D 01 70 00 00 12
	cmp	((xb+0x12),A5),D7	; BE 6D 01 70 00 00 00
	cmp	((xw+0x1234),A5),D7	; BE 6D 01 70 00 00 12

	  ; d8(An,Xn) / (d8,An,Xn)

	cmp	(xb+0x12)(A6,D1.W),D0	; B0 76 11 30 00 00 00
	cmp	(xb+0x12)(A6,A7.L),D1	; B2 76 F9 30 00 00 00
	cmp	((xb+0x12),A6,D1.W),D2	; B4 76 11 30 00 00 00
	cmp	((xb+0x12),A6,A7.L),D3	; B6 76 F9 30 00 00 00

	  ;
	  ; Addressimg Modes Of Type ([bd,An,Xn],od)
	  ;

	cmp	([A1]),D1		; B2 71 01 51
	cmp	([A1],(xb+0x12)),D1	; B2 71 01 53 00 00 00
	cmp	([A1],(xw+0x1234)),D1	; B2 71 01 53 00 00 12
	cmp	([A1],(xl+0x12345678)),D1	; B2 71 01 53 12 34 56

	cmp	([(xb+0x12),A1]),D1	; B2 71 01 71 00 00 00
	cmp	([(xb+0x12),A1],(xb+0x12)),D1	; B2 71 01 73 00 00 00
	cmp	([(xb+0x12),A1],(xw+0x1234)),D1		; B2 71 01 73 00 00 00
	cmp	([(xb+0x12),A1],(xl+0x12345678)),D1	; B2 71 01 73 00 00 00

	cmp	([(xw+0x1234),A1]),D1	; B2 71 01 71 00 00 12
	cmp	([(xw+0x1234),A1],(xb+0x12)),D1		; B2 71 01 73 00 00 12
	cmp	([(xw+0x1234),A1],(xw+0x1234)),D1	; B2 71 01 73 00 00 12
	cmp	([(xw+0x1234),A1],(xl+0x12345678)),D1	; B2 71 01 73 00 00 12

	cmp	([(xl+0x12345678),A1]),D1	; B2 71 01 71 12 34 56
	cmp	([(xl+0x12345678),A1],(xb+0x12)),D1	; B2 71 01 73 12 34 56
	cmp	([(xl+0x12345678),A1],(xw+0x1234)),D1	; B2 71 01 73 12 34 56
	cmp	([(xl+0x12345678),A1],(xl+0x12345678)),D1	; B2 71 01 73 12 34 56

	cmp	([A1,A7]),D1		; B2 71 F1 11
	cmp	([A1,A7],(xb+0x12)),D1	; B2 71 F1 13 00 00 00
	cmp	([A1,A7],(xw+0x1234)),D1	; B2 71 F1 13 00 00 12
	cmp	([A1,A7],(xl+0x12345678)),D1	; B2 71 F1 13 12 34 56

	cmp	([(xb+0x12),A1,A7]),D1	; B2 71 F1 31 00 00 00
	cmp	([(xb+0x12),A1,A7],(xb+0x12)),D1	; B2 71 F1 33 00 00 00
	cmp	([(xb+0x12),A1,A7],(xw+0x1234)),D1	; B2 71 F1 33 00 00 00
	cmp	([(xb+0x12),A1,A7],(xl+0x12345678)),D1	; B2 71 F1 33 00 00 00

	cmp	([(xw+0x1234),A1,A7]),D1	; B2 71 F1 31 00 00 12
	cmp	([(xw+0x1234),A1,A7],(xb+0x12)),D1	; B2 71 F1 33 00 00 12
	cmp	([(xw+0x1234),A1,A7],(xw+0x1234)),D1	; B2 71 F1 33 00 00 12
	cmp	([(xw+0x1234),A1,A7],(xl+0x12345678)),D1	; B2 71 F1 33 00 00 12

	cmp	([(xl+0x12345678),A1,A7]),D1	; B2 71 F1 31 12 34 56
	cmp	([(xl+0x12345678),A1,A7],(xb+0x12)),D1	; B2 71 F1 33 12 34 56
	cmp	([(xl+0x12345678),A1,A7],(xw+0x1234)),D1	; B2 71 F1 33 12 34 56
	cmp	([(xl+0x12345678),A1,A7],(xl+0x12345678)),D1	; B2 71 F1 33 12 34 56

	cmp	([A1],A7),D1		; B2 71 F1 15
	cmp	([A1],A7,(xb+0x12)),D1	; B2 71 F1 17 00 00 00
	cmp	([A1],A7,(xw+0x1234)),D1	; B2 71 F1 17 00 00 12
	cmp	([A1],A7,(xl+0x12345678)),D1	; B2 71 F1 17 12 34 56

	cmp	([(xb+0x12),A1],A7),D1	; B2 71 F1 35 00 00 00
	cmp	([(xb+0x12),A1],A7,(xb+0x12)),D1	; B2 71 F1 37 00 00 00
	cmp	([(xb+0x12),A1],A7,(xw+0x1234)),D1	; B2 71 F1 37 00 00 00
	cmp	([(xb+0x12),A1],A7,(xl+0x12345678)),D1	; B2 71 F1 37 00 00 00

	cmp	([(xw+0x1234),A1],A7),D1	; B2 71 F1 35 00 00 12
	cmp	([(xw+0x1234),A1],A7,(xb+0x12)),D1	; B2 71 F1 37 00 00 12
	cmp	([(xw+0x1234),A1],A7,(xw+0x1234)),D1	; B2 71 F1 37 00 00 12
	cmp	([(xw+0x1234),A1],A7,(xl+0x12345678)),D1	; B2 71 F1 37 00 00 12

	cmp	([(xl+0x12345678),A1],A7),D1	; B2 71 F1 35 12 34 56
	cmp	([(xl+0x12345678),A1],A7,(xb+0x12)),D1	; B2 71 F1 37 12 34 56
	cmp	([(xl+0x12345678),A1],A7,(xw+0x1234)),D1	; B2 71 F1 37 12 34 56
	cmp	([(xl+0x12345678),A1],A7,(xl+0x12345678)),D1	; B2 71 F1 37 12 34 56

	  ; d16(PC) / (d16,PC)

	cmp	(xb+0x12)(PC),D6	; BC 7A 01 70 FF FE CA
	cmp	(xw+0x1234)(PC),D6	; BC 7A 01 70 FF FE DC
	cmp	((xb+0x12),PC),D7	; BE 7A 01 70 FF FE CA
	cmp	((xw+0x1234),PC),D7	; BE 7A 01 70 FF FE DC

	  ; d8(An,Xn) / (d8,An,Xn)

	cmp	(xb+0x12)(PC,D1.W),D0	; B0 7B 11 30 FF FE CA
	cmp	(xb+0x12)(PC,A7.L),D1	; B2 7B F9 30 FF FE CA
	cmp	((xb+0x12),PC,D1.W),D2	; B4 7B 11 30 FF FE CA
	cmp	((xb+0x12),PC,A7.L),D3	; B6 7B F9 30 FF FE CA

	  ;
	  ; Addressimg Modes Of Type ([bd,An,Xn],od)
	  ;

	cmp	([PC]),D1		; B2 7B 01 51
	cmp	([PC],(xb+0x12)),D1	; B2 7B 01 53 00 00 00
	cmp	([PC],(xw+0x1234)),D1	; B2 7B 01 53 00 00 12
	cmp	([PC],(xl+0x12345678)),D1	; B2 7B 01 53 12 34 56

	cmp	([(xb+0x12),PC]),D1	; B2 7B 01 71 FF FE CA
	cmp	([(xb+0x12),PC],(xb+0x12)),D1	; B2 7B 01 73 FF FE C9
	cmp	([(xb+0x12),PC],(xw+0x1234)),D1		; B2 7B 01 73 FF FE C9
	cmp	([(xb+0x12),PC],(xl+0x12345678)),D1	; B2 7B 01 73 FF FE C9

	cmp	([(xw+0x1234),PC]),D1	; B2 7B 01 71 FF FE DB
	cmp	([(xw+0x1234),PC],(xb+0x12)),D1		; B2 7B 01 73 FF FE DB
	cmp	([(xw+0x1234),PC],(xw+0x1234)),D1	; B2 7B 01 73 FF FE DB
	cmp	([(xw+0x1234),PC],(xl+0x12345678)),D1	; B2 7B 01 73 FF FE DB

	cmp	([(xl+0x12345678),PC]),D1	; B2 7B 01 71 12 33 20
	cmp	([(xl+0x12345678),PC],(xb+0x12)),D1	; B2 7B 01 73 12 33 20
	cmp	([(xl+0x12345678),PC],(xw+0x1234)),D1	; B2 7B 01 73 12 33 1F
	cmp	([(xl+0x12345678),PC],(xl+0x12345678)),D1	; B2 7B 01 73 12 33 1F

	cmp	([PC,A7]),D1		; B2 7B F1 11
	cmp	([PC,A7],(xb+0x12)),D1	; B2 7B F1 13 00 00 00
	cmp	([PC,A7],(xw+0x1234)),D1	; B2 7B F1 13 00 00 12
	cmp	([PC,A7],(xl+0x12345678)),D1	; B2 7B F1 13 12 34 56

	cmp	([(xb+0x12),PC,A7]),D1	; B2 7B F1 31 FF FE C9
	cmp	([(xb+0x12),PC,A7],(xb+0x12)),D1	; B2 7B F1 33 FF FE C9
	cmp	([(xb+0x12),PC,A7],(xw+0x1234)),D1	; B2 7B F1 33 FF FE C9
	cmp	([(xb+0x12),PC,A7],(xl+0x12345678)),D1	; B2 7B F1 33 FF FE C9

	cmp	([(xw+0x1234),PC,A7]),D1	; B2 7B F1 31 FF FE DB
	cmp	([(xw+0x1234),PC,A7],(xb+0x12)),D1	; B2 7B F1 33 FF FE DB
	cmp	([(xw+0x1234),PC,A7],(xw+0x1234)),D1	; B2 7B F1 33 FF FE DB
	cmp	([(xw+0x1234),PC,A7],(xl+0x12345678)),D1	; B2 7B F1 33 FF FE DB

	cmp	([(xl+0x12345678),PC,A7]),D1	; B2 7B F1 31 12 33 1F
	cmp	([(xl+0x12345678),PC,A7],(xb+0x12)),D1	; B2 7B F1 33 12 33 1F
	cmp	([(xl+0x12345678),PC,A7],(xw+0x1234)),D1	; B2 7B F1 33 12 33 1F
	cmp	([(xl+0x12345678),PC,A7],(xl+0x12345678)),D1	; B2 7B F1 33 12 33 1F

	cmp	([PC],A7),D1		; B2 7B F1 15
	cmp	([PC],A7,(xb+0x12)),D1	; B2 7B F1 17 00 00 00
	cmp	([PC],A7,(xw+0x1234)),D1	; B2 7B F1 17 00 00 12
	cmp	([PC],A7,(xl+0x12345678)),D1	; B2 7B F1 17 12 34 56

	cmp	([(xb+0x12),PC],A7),D1	; B2 7B F1 35 FF FE C8
	cmp	([(xb+0x12),PC],A7,(xb+0x12)),D1	; B2 7B F1 37 FF FE C8
	cmp	([(xb+0x12),PC],A7,(xw+0x1234)),D1	; B2 7B F1 37 FF FE C8
	cmp	([(xb+0x12),PC],A7,(xl+0x12345678)),D1	; B2 7B F1 37 FF FE C8

	cmp	([(xw+0x1234),PC],A7),D1	; B2 7B F1 35 FF FE DA
	cmp	([(xw+0x1234),PC],A7,(xb+0x12)),D1	; B2 7B F1 37 FF FE DA
	cmp	([(xw+0x1234),PC],A7,(xw+0x1234)),D1	; B2 7B F1 37 FF FE DA
	cmp	([(xw+0x1234),PC],A7,(xl+0x12345678)),D1	; B2 7B F1 37 FF FE DA

	cmp	([(xl+0x12345678),PC],A7),D1	; B2 7B F1 35 12 33 1E
	cmp	([(xl+0x12345678),PC],A7,(xb+0x12)),D1	; B2 7B F1 37 12 33 1E
	cmp	([(xl+0x12345678),PC],A7,(xw+0x1234)),D1	; B2 7B F1 37 12 33 1E
	cmp	([(xl+0x12345678),PC],A7,(xl+0x12345678)),D1	; B2 7B F1 37 12 33 1E

	.sbttl	Branch External Addressing

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  B_XPC:						*
	;*	External Branching Test				*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

10020$:	bra	10020$			; 60 FE

		.nval	New_B_Org, .
		.area	B
		.org	New_B_Org
y1::
		.area	A

	bra	y1			; 60 FF FF FF FF FE

		.nval	New_B_Org, .
		.area	B
		.org	New_B_Org
y1S::
		.area	A

	bra.b	y1S			; 60 FE

		.nval	New_B_Org, .
		.area	B
		.org	New_B_Org
y1W::
		.area	A

	bra.w	y1W			; 60 00 FF FE

10021$:	bra	10021$ + 0x200		; 60 00 01 FE

		.nval	New_B_Org, .
		.area	B
		.org	New_B_Org
y2::
		.area	A

	bra	y2 + 0x200		; 60 FF 00 00 01 FE

		.nval	New_B_Org, .
		.area	B
		.org	New_B_Org
y2W::
		.area	A

	bra.w	y2W + 0x200		; 60 00 01 FE

10022$:	bra	10022$ + 0x20000	; 60 FF 00 01 FF FE

		.nval	New_B_Org, .
		.area	B
		.org	New_B_Org
y3::
		.area	A

	bra	y3 + 0x20000		; 60 FF 00 01 FF FE

		.nval	New_B_Org, .
		.area	B
		.org	New_B_Org
y3L::
		.area	A

	bra.l	y3L + 0x20000		; 60 FF 00 01 FF FE

10023$:	bsr	10023$			; 61 FE

		.nval	New_B_Org, .
		.area	B
		.org	New_B_Org
y4::
		.area	A

	bsr	y4			; 61 FF FF FF FF FE

		.nval	New_B_Org, .
		.area	B
		.org	New_B_Org
y4S::
		.area	A

	bsr.b	y4S			; 61 FE

		.nval	New_B_Org, .
		.area	B
		.org	New_B_Org
y4W::
		.area	A

	bsr.w	y4W			; 61 00 FF FE

10024$:	bsr	10024$ + 0x200		; 61 00 01 FE

		.nval	New_B_Org, .
		.area	B
		.org	New_B_Org
y5::
		.area	A

	bsr	y5 + 0x200		; 61 FF 00 00 01 FE

		.nval	New_B_Org, .
		.area	B
		.org	New_B_Org
y5W::
		.area	A

	bsr.w	y5W + 0x200		; 61 00 01 FE

10025$:	bsr	10025$ + 0x20000	; 61 FF 00 01 FF FE

		.nval	New_B_Org, .
		.area	B
		.org	New_B_Org
y6::
		.area	A

	bsr	y6 + 0x20000		; 61 FF 00 01 FF FE

		.nval	New_B_Org, .
		.area	B
		.org	New_B_Org
y6L::
		.area	A

	bsr.l	y6L + 0x20000		; 61 FF 00 01 FF FE

10026$:	bcc	10026$			; 64 FE

		.nval	New_B_Org, .
		.area	B
		.org	New_B_Org
y7::
		.area	A

	bcc	y7			; 64 FF FF FF FF FE

		.nval	New_B_Org, .
		.area	B
		.org	New_B_Org
y7S::
		.area	A

	bcc.b	y7S			; 64 FE

		.nval	New_B_Org, .
		.area	B
		.org	New_B_Org
y7W::
		.area	A

	bcc.w	y7W			; 64 00 FF FE

10027$:	bcc	10027$ + 0x200		; 64 00 01 FE

		.nval	New_B_Org, .
		.area	B
		.org	New_B_Org
y8::
		.area	A

	bcc	y8 + 0x200		; 64 FF 00 00 01 FE

		.nval	New_B_Org, .
		.area	B
		.org	New_B_Org
y8W::
		.area	A

	bcc.w	y8W + 0x200		; 64 00 01 FE

10028$:	bcc	10028$ + 0x20000	; 64 FF 00 01 FF FE

		.nval	New_B_Org, .
		.area	B
		.org	New_B_Org
y9::
		.area	A

	bcc	y9 + 0x20000		; 64 FF 00 01 FF FE

		.nval	New_B_Org, .
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

	.sbttl	FBcc Branch External Addressing

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  F_FBcc:						*
	;*	External Branching Test				*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

10029$:	FBT	10029$ + 0x200		; F2 8F 01 FE

		.nval	New_B_Org, .
		.area	B
		.org	New_B_Org
b1::
		.area	A

	FBT	b1 + 0x200		; F2 CF 00 00 01 FE

		.nval	New_B_Org, .
		.area	B
		.org	New_B_Org
b1W::
		.area	A

	FBT.w	b1W + 0x200		; F2 8F 01 FE

		.nval	New_B_Org, .
		.area	B
		.org	New_B_Org
b1L::
		.area	A

	FBT.l	b1L + 0x200		; F2 CF 00 00 01 FE

10030$:	FBT	10030$ + 0x20000	; F2 CF 00 01 FF FE

		.nval	New_B_Org, .
		.area	B
		.org	New_B_Org
b2::
		.area	A

	FBT	b2 + 0x20000		; F2 CF 00 01 FF FE

		.nval	New_B_Org, .
		.area	B
		.org	New_B_Org
b2L::
		.area	A

	FBT.l	b2L + 0x20000		; F2 CF 00 01 FF FE

	.sbttl	FDBcc Branch External Addressing

	;******-----*****-----*****-----*****-----*****-----*****
	;*							*
	;*  F_FBcc:						*
	;*	External Branching Test				*
	;*							*
	;******-----*****-----*****-----*****-----*****-----*****

10031$:	FDBT	D1,10031$ + 0x200	; F2 49 00 0F 01 FC

		.nval	New_B_Org, .
		.area	B
		.org	New_B_Org
db1::
		.area	A

	FDBT	D2,db1 + 0x200		; F2 4A 00 0F 01 FC

		.nval	New_B_Org, .
		.area	B
		.org	New_B_Org
db1W::
		.area	A

	FDBT.w	D3,db1W + 0x200		; F2 4B 00 0F 01 FC

	.end
