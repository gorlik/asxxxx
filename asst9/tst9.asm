	.title	ST9 Test

	N  = 0x12
	NN = 0x5678

	B0 = 0
	B1 = 1
	B2 = 2
	B3 = 3
	B4 = 4
	B5 = 5
	B6 = 6
	B7 = 7

	.define	M	"N + xN"
	.define	MM	"NN + xNN"

	.globl	xN, xNN
	.globl	X0, X1, X2, X3, X4, X5, X6, X7

	.nlist
	.include "t9def.asm"
	.list

	;
	; OR
	;
	; OR (byte) Register, Register
	or	y3,y7		; 02 37
	or	y3,(y5)		; 03 35
	or	Y50,Y90		; 04 90 50
	or	y3,Y90		; 04 90 D3
	or	Y50,y7		; 04 D7 50
	or	(y6),Y30	; E6 30 06
	or	(yA),y3		; E6 D3 0A
	or	Y40,(yC)	; E7 0C 40

	; OR (byte) Register, Memory
	or	Y7,(yy2)	; 72 03 07
	or	y6,(yy4)	; 72 05 D6
	or	Y5,(yy6)+	; B4 07 05
	or	y4,(yy8)+	; B4 09 D4
	or	Y3,-(yyA)	; C2 0B 03
	or	y2,-(yyC)	; C2 0D D2
	or	y1,yy8(yyE)	; 60 9E 01
	or	Y5,N(yy2)	; 7F 03 12 05
	or	yF,N(yy4)	; 7F 05 12 DF
	or	yC,NN		; C4 0C 56 78
	or	Y1,NN(yy6)	; 7F 06 56 78 01
	or	y2,NN(yy8)	; 7F 08 56 78 D2
.ifdef	GLOBAL
	or	Y5,*M(yy2)	; 7F 03 12 05		; Global -> Forced Short Form
	or	yF,*M(yy4)	; 7F 05 12 DF		; Global -> Forced Short Form
	or	Y5,M(yy2)	; 7F 02 00 12 05	; Global -> Long Form
	or	yF,M(yy4)	; 7F 04 00 12 DF	; Global -> Long Form
	or	yC,MM		; C4 0C 56 78
	or	Y1,MM(yy6)	; 7F 06 56 78 01
	or	y2,MM(yy8)	; 7F 08 56 78 D2
.endif

	; OR (byte) Memory, Register
	or	(yy0),Y50	; 72 00 50
	or	(yy2),y8	; 72 02 D8
	or	(yy4)+,Y60	; B4 04 60
	or	(yy6)+,y7	; B4 06 D7
	or	-(yy8),Y70	; C2 08 70
	or	-(yyA),y6	; C2 0A D6
	or	yyC(yyE),y5	; 60 DF 05
	or	N(yyA),Y80	; 26 0B 12 80
	or	N(yy8),y4	; 26 09 12 D4
	or	NN,y3		; C5 03 56 78
	or	NN(yy6),Y90	; 26 06 56 78 90
	or	NN(yy4),y2	; 26 04 56 78 D2
.ifdef	GLOBAL
	or	*M(yyA),Y80	; 26 0B 12 80		; Global -> Forced Short Form
	or	*M(yy8),y4	; 26 09 12 D4		; Global -> Forced Short Form
	or	M(yyA),Y80	; 26 0A 00 12 80	; Global -> Long Form
	or	M(yy8),y4	; 26 08 00 12 D4	; Global -> Long Form
	or	MM,y3		; C5 03 56 78
	or	MM(yy6),Y90	; 26 06 56 78 90
	or	MM(yy4),y2	; 26 04 56 78 D2
.endif

	; OR (byte) Memory, Memory
	or	(YY60),(yy4)	; 73 04 60
	or	(yy6),(yy8)	; 73 08 D6

	; OR (byte) All, Immediate
	or	Y70,#N		; 05 70 12
	or	yB,#N		; 05 DB 12
	or	(yy2),#N	; F3 02 12
	or	NN,#N		; 2F 01 12 56 78
.ifdef	GLOBAL
	or	Y70,#M		; 05 70 12
	or	yB,#M		; 05 DB 12
	or	(yy2),#M	; F3 02 12
	or	MM,#M		; 2F 01 12 56 78
.endif

	;
	; ORW
	;
	; OR (Word) - Register, Register
	orw	yy2,yy4		; 0E 24
	orw	YY6,YY20	; 07 20 06
	orw	yy8,YY30	; 07 30 D8
	orw	YY40,yyA	; 07 DA 40
	orw	(y0),YY50	; 96 50 00
	orw	(y1),yyC	; 96 DC 01
	orw	YY60,(y2)	; A6 02 60
	orw	yyE,(y4)	; A6 04 DE

	; OR (Word) - Register, Memory
	orw	yy0,(yy2)	; 0E 03
	orw	YY10,(yy4)	; 7E 04 10
	orw	YY20,(yy6)+	; D5 07 20
	orw	yy8,(yyA)+	; D5 0B D8
	orw	YY30,-(yyC)	; C3 0D 30
	orw	yyE,-(yy0)	; C3 01 DE
	orw	yy2,yy4(yy6)	; 60 46 02
	orw	YY40,N(yy8)	; 86 09 12 40
	orw	yyA,N(yyC)	; 86 0D 12 DA
	orw	yyE,NN		; E2 0E 56 78
	orw	YY50,NN(yy0)	; 86 00 56 78 50
	orw	yy2,NN(yy4)	; 86 04 56 78 D2
.ifdef	GLOBAL
	orw	YY40,*M(yy8)	; 86 09 12 40		; Global -> Forced Short Form
	orw	yyA,*M(yyC)	; 86 0D 12 DA		; Global -> Forced Short Form
	orw	YY40,M(yy8)	; 86 08 00 12 40	; Global -> Long Form
	orw	yyA,M(yyC)	; 86 0C 00 12 DA	; Global -> Long Form
	orw	yyE,MM		; E2 0E 56 78
	orw	YY50,MM(yy0); 86 00 56 78 50
	orw	yy2,MM(yy4)	; 86 04 56 78 D2
.endif

	; OR (Word) - Memory, Register
	orw	(yy0),yy2	; 0E 12
	orw	(yy4),YY10	; BE 05 10
	orw	(yy6)+,YY20	; D5 06 20
	orw	(yy8)+,yyA	; D5 08 DA
	orw	-(yyC),YY30	; C3 0C 30
	orw	-(yyE),yy0	; C3 0E D0
	orw	yy2(yy4),yy6	; 60 25 06
	orw	N(yy8),YY40	; 86 09 12 41
	orw	N(yyA),yyC	; 86 0B 12 DD
	orw	NN,yyC		; E2 0D 56 78
	orw	NN(yyE),YY60	; 86 0E 56 78 61
	orw	NN(yy0),yy2	; 86 00 56 78 D3
.ifdef	GLOBAL
	orw	*M(yy8),YY40	; 86 09 12 41		; Global -> Forced Short Form
	orw	*M(yyA),yyC	; 86 0B 12 DD		; Global -> Forced Short Form
	orw	M(yy8),YY40	; 86 08 00 12 41	; Global -> Long Form
	orw	M(yyA),yyC	; 86 0A 00 12 DD	; Global -> Long Form
	orw	MM,yyC		; E2 0D 56 78
	orw	MM(yyE),YY60	; 86 0E 56 78 61
	orw	MM(yy0),yy2	; 86 00 56 78 D3
.endif

	; OR (Word) - Memory, Memory
	orw	(yy0),(yy2)	; 0E 13

	; OR (Word) - All, Immediate
	orw	YY10,#NN	; 07 11 56 78
	orw	yy4,#NN		; 07 D5 56 78
	orw	(yy8),#NN	; BE 08 56 78
	orw	N(yyA),#NN	; 06 0B 12 56 78
	orw	NN(yyC),#NN	; 06 0C 56 78 56;78
	orw	NN,#NN		; 36 01 56 78 56;78
.ifdef	GLOBAL
	orw	YY10,#MM	; 07 11 56 78
	orw	yy4,#MM		; 07 D5 56 78
	orw	(yy8),#MM	; BE 08 56 78
	orw	*M(yyA),#MM	; 06 0B 12 56 78	; Global -> Forced Short Form
	orw	M(yyA),#MM	; 06 0A 00 12 56;78	; Global -> Long Form
	orw	MM(yyC),#MM	; 06 0C 56 78 56;78
	orw	MM,#MM		; 36 01 56 78 56;78
.endif

	;
	; AND
	;
	; AND (byte) Register, Register
	and	y3,y7		; 12 37
	and	y3,(y5)		; 13 35
	and	Y50,Y90		; 14 90 50
	and	y3,Y90		; 14 90 D3
	and	Y50,y7		; 14 D7 50
	and	(y6),Y30	; E6 30 16
	and	(yA),y3		; E6 D3 1A
	and	Y40,(yC)	; E7 1C 40

	; AND (byte) Register, Memory
	and	Y7,(yy2)	; 72 13 07
	and	y6,(yy4)	; 72 15 D6
	and	Y5,(yy6)+	; B4 17 05
	and	y4,(yy8)+	; B4 19 D4
	and	Y3,-(yyA)	; C2 1B 03
	and	y2,-(yyC)	; C2 1D D2
	and	y1,yy8(yyE)	; 60 9E 11
	and	Y5,N(yy2)	; 7F 13 12 05
	and	yF,N(yy4)	; 7F 15 12 DF
	and	yC,NN		; C4 1C 56 78
	and	Y1,NN(yy6)	; 7F 16 56 78 01
	and	y2,NN(yy8)	; 7F 18 56 78 D2
.ifdef	GLOBAL
	and	Y5,*M(yy2)	; 7F 13 12 05		; Global -> Forced Short Form
	and	yF,*M(yy4)	; 7F 15 12 DF		; Global -> Forced Short Form
	and	Y5,M(yy2)	; 7F 12 00 12 05	; Global -> Long Form
	and	yF,M(yy4)	; 7F 14 00 12 DF	; Global -> Long Form
	and	yC,MM		; C4 1C 56 78
	and	Y1,MM(yy6)	; 7F 16 56 78 01
	and	y2,MM(yy8)	; 7F 18 56 78 D2
.endif

	; AND (byte) Memory, Register
	and	(yy0),Y50	; 72 10 50
	and	(yy2),y8	; 72 12 D8
	and	(yy4)+,Y60	; B4 14 60
	and	(yy6)+,y7	; B4 16 D7
	and	-(yy8),Y70	; C2 18 70
	and	-(yyA),y6	; C2 1A D6
	and	yyC(yyE),y5	; 60 DF 15
	and	N(yyA),Y80	; 26 1B 12 80
	and	N(yy8),y4	; 26 19 12 D4
	and	NN,y3		; C5 13 56 78
	and	NN(yy6),Y90	; 26 16 56 78 90
	and	NN(yy4),y2	; 26 14 56 78 D2
.ifdef	GLOBAL
	and	*M(yyA),Y80	; 26 1B 12 80		; Global -> Forced Short Form
	and	*M(yy8),y4	; 26 19 12 D4		; Global -> Forced Short Form
	and	M(yyA),Y80	; 26 1A 00 12 80	; Global -> Long Form
	and	M(yy8),y4	; 26 18 00 12 D4	; Global -> Long Form
	and	MM,y3		; C5 13 56 78
	and	MM(yy6),Y90	; 26 16 56 78 90
	and	MM(yy4),y2	; 26 14 56 78 D2
.endif

	; AND (byte) Memory, Memory
	and	(YY60),(yy4)	; 73 14 60
	and	(yy6),(yy8)	; 73 18 D6

	; AND (byte) All, Immediate
	and	Y70,#N		; 15 70 12
	and	yB,#N		; 15 DB 12
	and	(yy2),#N	; F3 12 12
	and	NN,#N		; 2F 11 12 56 78
.ifdef	GLOBAL
	and	Y70,#M		; 15 70 12
	and	yB,#M		; 15 DB 12
	and	(yy2),#M	; F3 12 12
	and	MM,#M		; 2F 11 12 56 78
.endif

	;
	; ANDW
	;
	; AND (Word) - Register, Register
	andw	yy2,yy4		; 1E 24
	andw	YY6,YY20	; 17 20 06
	andw	yy8,YY30	; 17 30 D8
	andw	YY40,yyA	; 17 DA 40
	andw	(y0),YY50	; 96 50 10
	andw	(y1),yyC	; 96 DC 11
	andw	YY60,(y2)	; A6 12 60
	andw	yyE,(y4)	; A6 14 DE

	; AND (Word) - Register, Memory
	andw	yy0,(yy2)	; 1E 03
	andw	YY10,(yy4)	; 7E 14 10
	andw	YY20,(yy6)+	; D5 17 20
	andw	yy8,(yyA)+	; D5 1B D8
	andw	YY30,-(yyC)	; C3 1D 30
	andw	yyE,-(yy0)	; C3 11 DE
	andw	yy2,yy4(yy6)	; 60 46 12
	andw	YY40,N(yy8)	; 86 19 12 40
	andw	yyA,N(yyC)	; 86 1D 12 DA
	andw	yyE,NN		; E2 1E 56 78
	andw	YY50,NN(yy0)	; 86 10 56 78 50
	andw	yy2,NN(yy4)	; 86 14 56 78 D2
.ifdef	GLOBAL
	andw	YY40,*M(yy8)	; 86 19 12 40		; Global -> Forced Short Form
	andw	yyA,*M(yyC)	; 86 1D 12 DA		; Global -> Forced Short Form
	andw	YY40,M(yy8)	; 86 18 00 12 40	; Global -> Long Form
	andw	yyA,M(yyC)	; 86 1C 00 12 DA	; Global -> Long Form
	andw	yyE,MM		; E2 1E 56 78
	andw	YY50,MM(yy0)	; 86 10 56 78 50
	andw	yy2,MM(yy4)	; 86 14 56 78 D2
.endif

	; AND (Word) - Memory, Register
	andw	(yy0),yy2	; 1E 12
	andw	(yy4),YY10	; BE 15 10
	andw	(yy6)+,YY20	; D5 16 20
	andw	(yy8)+,yyA	; D5 18 DA
	andw	-(yyC),YY30	; C3 1C 30
	andw	-(yyE),yy0	; C3 1E D0
	andw	yy2(yy4),yy6	; 60 25 16
	andw	N(yy8),YY40	; 86 19 12 41
	andw	N(yyA),yyC	; 86 1B 12 DD
	andw	NN,yyC		; E2 1D 56 78
	andw	NN(yyE),YY60	; 86 1E 56 78 61
	andw	NN(yy0),yy2	; 86 10 56 78 D3
.ifdef	GLOBAL
	andw	*M(yy8),YY40	; 86 19 12 41		; Global -> Forced Short Form
	andw	*M(yyA),yyC	; 86 1B 12 DD		; Global -> Forced Short Form
	andw	M(yy8),YY40	; 86 18 00 12 41	; Global -> Long Form
	andw	M(yyA),yyC	; 86 1A 00 12 DD	; Global -> Long Form
	andw	MM,yyC		; E2 1D 56 78
	andw	MM(yyE),YY60	; 86 1E 56 78 61
	andw	MM(yy0),yy2	; 86 10 56 78 D3
.endif

	; AND (Word) - Memory, Memory
	andw	(yy0),(yy2)	; 1E 13

	; AND (Word) - All, Immediate
	andw	YY10,#NN	; 17 11 56 78
	andw	yy4,#NN		; 17 D5 56 78
	andw	(yy8),#NN	; BE 18 56 78
	andw	N(yyA),#NN	; 06 1B 12 56 78
	andw	NN(yyC),#NN	; 06 1C 56 78 56;78
	andw	NN,#NN		; 36 11 56 78 56;78
.ifdef	GLOBAL
	andw	YY10,#MM	; 17 11 56 78
	andw	yy4,#MM		; 17 D5 56 78
	andw	(yy8),#MM	; BE 18 56 78
	andw	*M(yyA),#MM	; 06 1B 12 56 78	; Global -> Forced Short Form
	andw	M(yyA),#MM	; 06 1A 00 12 56;78	; Global -> Long Form
	andw	MM(yyC),#MM	; 06 1C 56 78 56;78
	andw	MM,#MM		; 36 11 56 78 56;78
.endif

	;
	; SBC
	;
	; Subtract with carry (byte) Register, Register
	sbc	y3,y7		; 22 37
	sbc	y3,(y5)		; 23 35
	sbc	Y50,Y90		; 24 90 50
	sbc	y3,Y90		; 24 90 D3
	sbc	Y50,y7		; 24 D7 50
	sbc	(y6),Y30	; E6 30 26
	sbc	(yA),y3		; E6 D3 2A
	sbc	Y40,(yC)	; E7 2C 40

	; Subtract with carry (byte) Register, Memory
	sbc	Y7,(yy2)	; 72 23 07
	sbc	y6,(yy4)	; 72 25 D6
	sbc	Y5,(yy6)+	; B4 27 05
	sbc	y4,(yy8)+	; B4 29 D4
	sbc	Y3,-(yyA)	; C2 2B 03
	sbc	y2,-(yyC)	; C2 2D D2
	sbc	y1,yy8(yyE)	; 60 9E 21
	sbc	Y5,N(yy2)	; 7F 23 12 05
	sbc	yF,N(yy4)	; 7F 25 12 DF
	sbc	yC,NN		; C4 2C 56 78
	sbc	Y1,NN(yy6)	; 7F 26 56 78 01
	sbc	y2,NN(yy8)	; 7F 28 56 78 D2
.ifdef	GLOBAL
	sbc	Y5,*M(yy2)	; 7F 23 12 05		; Global -> Forced Short Form
	sbc	yF,*M(yy4)	; 7F 25 12 DF		; Global -> Forced Short Form
	sbc	Y5,M(yy2)	; 7F 22 00 12 05	; Global -> Long Form
	sbc	yF,M(yy4)	; 7F 24 00 12 DF	; Global -> Long Form
	sbc	yC,MM		; C4 2C 56 78
	sbc	Y1,MM(yy6)	; 7F 26 56 78 01
	sbc	y2,MM(yy8)	; 7F 28 56 78 D2
.endif

	; Subtract with carry (byte) Memory, Register
	sbc	(yy0),Y50	; 72 20 50
	sbc	(yy2),y8	; 72 22 D8
	sbc	(yy4)+,Y60	; B4 24 60
	sbc	(yy6)+,y7	; B4 26 D7
	sbc	-(yy8),Y70	; C2 28 70
	sbc	-(yyA),y6	; C2 2A D6
	sbc	yyC(yyE),y5	; 60 DF 25
	sbc	N(yyA),Y80	; 26 2B 12 80
	sbc	N(yy8),y4	; 26 29 12 D4
	sbc	NN,y3		; C5 23 56 78
	sbc	NN(yy6),Y90	; 26 26 56 78 90
	sbc	NN(yy4),y2	; 26 24 56 78 D2
.ifdef	GLOBAL
	sbc	*M(yyA),Y80	; 26 2B 12 80		; Global -> Forced Short Form
	sbc	*M(yy8),y4	; 26 29 12 D4		; Global -> Forced Short Form
	sbc	M(yyA),Y80	; 26 2A 00 12 80	; Global -> Long Form
	sbc	M(yy8),y4	; 26 28 00 12 D4	; Global -> Long Form
	sbc	MM,y3		; C5 23 56 78
	sbc	MM(yy6),Y90	; 26 26 56 78 90
	sbc	MM(yy4),y2	; 26 24 56 78 D2
.endif

	; Subtract with carry (byte) Memory, Memory
	sbc	(YY60),(yy4)	; 73 24 60
	sbc	(yy6),(yy8)	; 73 28 D6

	; Subtract with carry (byte) All, Immediate
	sbc	Y70,#N		; 25 70 12
	sbc	yB,#N		; 25 DB 12
	sbc	(yy2),#N	; F3 22 12
	sbc	NN,#N		; 2F 21 12 56 78
.ifdef	GLOBAL
	sbc	Y70,#M		; 25 70 12
	sbc	yB,#M		; 25 DB 12
	sbc	(yy2),#M	; F3 22 12
	sbc	MM,#M		; 2F 21 12 56 78
.endif

	;
	; SBCW
	;
	; Subtract With Carry (Word) - Register, Register
	sbcw	yy2,yy4		; 2E 24
	sbcw	YY6,YY20	; 27 20 06
	sbcw	yy8,YY30	; 27 30 D8
	sbcw	YY40,yyA	; 27 DA 40
	sbcw	(y0),YY50	; 96 50 20
	sbcw	(y1),yyC	; 96 DC 21
	sbcw	YY60,(y2)	; A6 22 60
	sbcw	yyE,(y4)	; A6 24 DE

	; Subtract With Carry (Word) - Register, Memory
	sbcw	yy0,(yy2)	; 2E 03
	sbcw	YY10,(yy4)	; 7E 24 10
	sbcw	YY20,(yy6)+	; D5 27 20
	sbcw	yy8,(yyA)+	; D5 2B D8
	sbcw	YY30,-(yyC)	; C3 2D 30
	sbcw	yyE,-(yy0)	; C3 21 DE
	sbcw	yy2,yy4(yy6)	; 60 46 22
	sbcw	YY40,N(yy8)	; 86 29 12 40
	sbcw	yyA,N(yyC)	; 86 2D 12 DA
	sbcw	yyE,NN		; E2 2E 56 78
	sbcw	YY50,NN(yy0)	; 86 20 56 78 50
	sbcw	yy2,NN(yy4)	; 86 24 56 78 D2
.ifdef	GLOBAL
	sbcw	YY40,*M(yy8)	; 86 29 12 40		; Global -> Forced Short Form
	sbcw	yyA,*M(yyC)	; 86 2D 12 DA		; Global -> Forced Short Form
	sbcw	YY40,M(yy8)	; 86 28 00 12 40	; Global -> Long Form
	sbcw	yyA,M(yyC)	; 86 2C 00 12 DA	; Global -> Long Form
	sbcw	yyE,MM		; E2 2E 56 78
	sbcw	YY50,MM(yy0)	; 86 20 56 78 50
	sbcw	yy2,MM(yy4)	; 86 24 56 78 D2
.endif

	; Subtract With Carry (Word) - Memory, Register
	sbcw	(yy0),yy2	; 2E 12
	sbcw	(yy4),YY10	; BE 25 10
	sbcw	(yy6)+,YY20	; D5 26 20
	sbcw	(yy8)+,yyA	; D5 28 DA
	sbcw	-(yyC),YY30	; C3 2C 30
	sbcw	-(yyE),yy0	; C3 2E D0
	sbcw	yy2(yy4),yy6	; 60 25 26
	sbcw	N(yy8),YY40	; 86 29 12 41
	sbcw	N(yyA),yyC	; 86 2B 12 DD
	sbcw	NN,yyC		; E2 2D 56 78
	sbcw	NN(yyE),YY60	; 86 2E 56 78 61
	sbcw	NN(yy0),yy2	; 86 20 56 78 D3
.ifdef	GLOBAL
	sbcw	*M(yy8),YY40	; 86 29 12 41		; Global -> Forced Short Form
	sbcw	*M(yyA),yyC	; 86 2B 12 DD		; Global -> Forced Short Form
	sbcw	M(yy8),YY40	; 86 28 00 12 41	; Global -> Long Form
	sbcw	M(yyA),yyC	; 86 2A 00 12 DD	; Global -> Long Form
	sbcw	MM,yyC		; E2 2D 56 78
	sbcw	MM(yyE),YY60	; 86 2E 56 78 61
	sbcw	MM(yy0),yy2	; 86 20 56 78 D3
.endif

	; Subtract With Carry (Word) - Memory, Memory
	sbcw	(yy0),(yy2)	; 2E 13

	; Subtract With Carry (Word) - All, Immediate
	sbcw	YY10,#NN	; 27 11 56 78
	sbcw	yy4,#NN		; 27 D5 56 78
	sbcw	(yy8),#NN	; BE 28 56 78
	sbcw	N(yyA),#NN	; 06 2B 12 56 78
	sbcw	NN(yyC),#NN	; 06 2C 56 78 56;78
	sbcw	NN,#NN		; 36 21 56 78 56;78
.ifdef	GLOBAL
	sbcw	YY10,#MM	; 27 11 56 78
	sbcw	yy4,#MM		; 27 D5 56 78
	sbcw	(yy8),#MM	; BE 28 56 78
	sbcw	*M(yyA),#MM	; 06 2B 12 56 78	; Global -> Forced Short Form
	sbcw	M(yyA),#MM	; 06 2A 00 12 56;78	; Global -> Long Form
	sbcw	MM(yyC),#MM	; 06 2C 56 78 56;78
	sbcw	MM,#MM		; 36 21 56 78 56;78
.endif

	;
	; ADC
	;
	; Add with carry (byte) Register, Register
	adc	y3,y7		; 32 37
	adc	y3,(y5)		; 33 35
	adc	Y50,Y90		; 34 90 50
	adc	y3,Y90		; 34 90 D3
	adc	Y50,y7		; 34 D7 50
	adc	(y6),Y30	; E6 30 36
	adc	(yA),y3		; E6 D3 3A
	adc	Y40,(yC)	; E7 3C 40

	; Add with carry (byte) Register, Memory
	adc	Y7,(yy2)	; 72 33 07
	adc	y6,(yy4)	; 72 35 D6
	adc	Y5,(yy6)+	; B4 37 05
	adc	y4,(yy8)+	; B4 39 D4
	adc	Y3,-(yyA)	; C2 3B 03
	adc	y2,-(yyC)	; C2 3D D2
	adc	y1,yy8(yyE)	; 60 9E 31
	adc	Y5,N(yy2)	; 7F 33 12 05
	adc	yF,N(yy4)	; 7F 35 12 DF
	adc	yC,NN		; C4 3C 56 78
	adc	Y1,NN(yy6)	; 7F 36 56 78 01
	adc	y2,NN(yy8)	; 7F 38 56 78 D2
.ifdef	GLOBAL
	adc	Y5,*M(yy2)	; 7F 33 12 05		; Global -> Forced Short Form
	adc	yF,*M(yy4)	; 7F 35 12 DF		; Global -> Forced Short Form
	adc	Y5,M(yy2)	; 7F 32 00 12 05	; Global -> Long Form
	adc	yF,M(yy4)	; 7F 34 00 12 DF	; Global -> Long Form
	adc	yC,MM		; C4 3C 56 78
	adc	Y1,MM(yy6)	; 7F 36 56 78 01
	adc	y2,MM(yy8)	; 7F 38 56 78 D2
.endif

	; Add with carry (byte) Memory, Register
	adc	(yy0),Y50	; 72 30 50
	adc	(yy2),y8	; 72 32 D8
	adc	(yy4)+,Y60	; B4 34 60
	adc	(yy6)+,y7	; B4 36 D7
	adc	-(yy8),Y70	; C2 38 70
	adc	-(yyA),y6	; C2 3A D6
	adc	yyC(yyE),y5	; 60 DF 35
	adc	N(yyA),Y80	; 26 3B 12 80
	adc	N(yy8),y4	; 26 39 12 D4
	adc	NN,y3		; C5 33 56 78
	adc	NN(yy6),Y90	; 26 36 56 78 90
	adc	NN(yy4),y2	; 26 34 56 78 D2
.ifdef	GLOBAL
	adc	*M(yyA),Y80	; 26 3B 12 80		; Global -> Forced Short Form
	adc	*M(yy8),y4	; 26 39 12 D4		; Global -> Forced Short Form
	adc	M(yyA),Y80	; 26 3A 00 12 80	; Global -> Long Form
	adc	M(yy8),y4	; 26 38 00 12 D4	; Global -> Long Form
	adc	MM,y3		; C5 33 56 78
	adc	MM(yy6),Y90	; 26 36 56 78 90
	adc	MM(yy4),y2	; 26 34 56 78 D2
.endif

	; Add with carry (byte) Memory, Memory
	adc	(YY60),(yy4)	; 73 34 60
	adc	(yy6),(yy8)	; 73 38 D6

	; Add with carry (byte) All, Immediate
	adc	Y70,#N		; 35 70 12
	adc	yB,#N		; 35 DB 12
	adc	(yy2),#N	; F3 32 12
	adc	NN,#N		; 2F 31 12 56 78
.ifdef	GLOBAL
	adc	Y70,#M		; 35 70 12
	adc	yB,#M		; 35 DB 12
	adc	(yy2),#M	; F3 32 12
	adc	MM,#M		; 2F 31 12 56 78
.endif

	;
	; ADCW
	;
	; Add With Carry (Word) - Register, Register
	adcw	yy2,yy4		; 3E 24
	adcw	YY6,YY20	; 37 20 06
	adcw	yy8,YY30	; 37 30 D8
	adcw	YY40,yyA	; 37 DA 40
	adcw	(y0),YY50	; 96 50 30
	adcw	(y1),yyC	; 96 DC 31
	adcw	YY60,(y2)	; A6 32 60
	adcw	yyE,(y4)	; A6 34 DE

	; Add With Carry (Word) - Register, Memory
	adcw	yy0,(yy2)	; 3E 03
	adcw	YY10,(yy4)	; 7E 34 10
	adcw	YY20,(yy6)+	; D5 37 20
	adcw	yy8,(yyA)+	; D5 3B D8
	adcw	YY30,-(yyC)	; C3 3D 30
	adcw	yyE,-(yy0)	; C3 31 DE
	adcw	yy2,yy4(yy6)	; 60 46 32
	adcw	YY40,N(yy8)	; 86 39 12 40
	adcw	yyA,N(yyC)	; 86 3D 12 DA
	adcw	yyE,NN		; E2 3E 56 78
	adcw	YY50,NN(yy0)	; 86 30 56 78 50
	adcw	yy2,NN(yy4)	; 86 34 56 78 D2
.ifdef	GLOBAL
	adcw	YY40,*M(yy8)	; 86 39 12 40		; Global -> Forced Short Form
	adcw	yyA,*M(yyC)	; 86 3D 12 DA		; Global -> Forced Short Form
	adcw	YY40,M(yy8)	; 86 38 00 12 40	; Global -> Long Form
	adcw	yyA,M(yyC)	; 86 3C 00 12 DA	; Global -> Long Form
	adcw	yyE,MM		; E2 3E 56 78
	adcw	YY50,MM(yy0)	; 86 30 56 78 50
	adcw	yy2,MM(yy4)	; 86 34 56 78 D2
.endif

	; Add With Carry (Word) - Memory, Register
	adcw	(yy0),yy2	; 3E 12
	adcw	(yy4),YY10	; BE 35 10
	adcw	(yy6)+,YY20	; D5 36 20
	adcw	(yy8)+,yyA	; D5 38 DA
	adcw	-(yyC),YY30	; C3 3C 30
	adcw	-(yyE),yy0	; C3 3E D0
	adcw	yy2(yy4),yy6	; 60 25 36
	adcw	N(yy8),YY40	; 86 39 12 41
	adcw	N(yyA),yyC	; 86 3B 12 DD
	adcw	NN,yyC		; E2 3D 56 78
	adcw	NN(yyE),YY60	; 86 3E 56 78 61
	adcw	NN(yy0),yy2	; 86 30 56 78 D3
.ifdef	GLOBAL
	adcw	*M(yy8),YY40	; 86 39 12 41		; Global -> Forced Short Form
	adcw	*M(yyA),yyC	; 86 3B 12 DD		; Global -> Forced Short Form
	adcw	M(yy8),YY40	; 86 38 00 12 41	; Global -> Long Form
	adcw	M(yyA),yyC	; 86 3A 00 12 DD	; Global -> Long Form
	adcw	MM,yyC		; E2 3D 56 78
	adcw	MM(yyE),YY60	; 86 3E 56 78 61
	adcw	MM(yy0),yy2	; 86 30 56 78 D3
.endif

	; Add With Carry (Word) - Memory, Memory
	adcw	(yy0),(yy2)	; 3E 13

	; Add With Carry (Word) - All, Immediate
	adcw	YY10,#NN	; 37 11 56 78
	adcw	yy4,#NN		; 37 D5 56 78
	adcw	(yy8),#NN	; BE 38 56 78
	adcw	N(yyA),#NN	; 06 3B 12 56 78
	adcw	NN(yyC),#NN	; 06 3C 56 78 56;78
	adcw	NN,#NN		; 36 31 56 78 56;78
.ifdef	GLOBAL
	adcw	YY10,#MM	; 37 11 56 78
	adcw	yy4,#MM		; 37 D5 56 78
	adcw	(yy8),#MM	; BE 38 56 78
	adcw	*M(yyA),#MM	; 06 3B 12 56 78	; Global -> Forced Short Form
	adcw	M(yyA),#MM	; 06 3A 00 12 56;78	; Global -> Long Form
	adcw	MM(yyC),#MM	; 06 3C 56 78 56;78
	adcw	MM,#MM		; 36 31 56 78 56;78
.endif

	;
	; ADD
	;
	; Add (byte) Register, Register
	add	y3,y7		; 42 37
	add	y3,(y5)		; 43 35
	add	Y50,Y90		; 44 90 50
	add	y3,Y90		; 44 90 D3
	add	Y50,y7		; 44 D7 50
	add	(y6),Y30	; E6 30 46
	add	(yA),y3		; E6 D3 4A
	add	Y40,(yC)	; E7 4C 40

	; Add (byte) Register, Memory
	add	Y7,(yy2)	; 72 43 07
	add	y6,(yy4)	; 72 45 D6
	add	Y5,(yy6)+	; B4 47 05
	add	y4,(yy8)+	; B4 49 D4
	add	Y3,-(yyA)	; C2 4B 03
	add	y2,-(yyC)	; C2 4D D2
	add	y1,yy8(yyE)	; 60 9E 41
	add	Y5,N(yy2)	; 7F 43 12 05
	add	yF,N(yy4)	; 7F 45 12 DF
	add	yC,NN		; C4 4C 56 78
	add	Y1,NN(yy6)	; 7F 46 56 78 01
	add	y2,NN(yy8)	; 7F 48 56 78 D2
.ifdef	GLOBAL
	add	Y5,*M(yy2)	; 7F 43 12 05		; Global -> Forced Short Form
	add	yF,*M(yy4)	; 7F 45 12 DF		; Global -> Forced Short Form
	add	Y5,M(yy2)	; 7F 42 00 12 05	; Global -> Long Form
	add	yF,M(yy4)	; 7F 44 00 12 DF	; Global -> Long Form
	add	yC,MM		; C4 4C 56 78
	add	Y1,MM(yy6)	; 7F 46 56 78 01
	add	y2,MM(yy8)	; 7F 48 56 78 D2
.endif

	; Add (byte) Memory, Register
	add	(yy0),Y50	; 72 40 50
	add	(yy2),y8	; 72 42 D8
	add	(yy4)+,Y60	; B4 44 60
	add	(yy6)+,y7	; B4 46 D7
	add	-(yy8),Y70	; C2 48 70
	add	-(yyA),y6	; C2 4A D6
	add	yyC(yyE),y5	; 60 DF 45
	add	N(yyA),Y80	; 26 4B 12 80
	add	N(yy8),y4	; 26 49 12 D4
	add	NN,y3		; C5 43 56 78
	add	NN(yy6),Y90	; 26 46 56 78 90
	add	NN(yy4),y2	; 26 44 56 78 D2
.ifdef	GLOBAL
	add	*M(yyA),Y80	; 26 4B 12 80		; Global -> Forced Short Form
	add	*M(yy8),y4	; 26 49 12 D4		; Global -> Forced Short Form
	add	M(yyA),Y80	; 26 4A 00 12 80	; Global -> Long Form
	add	M(yy8),y4	; 26 48 00 12 D4	; Global -> Long Form
	add	MM,y3		; C5 43 56 78
	add	MM(yy6),Y90	; 26 46 56 78 90
	add	MM(yy4),y2	; 26 44 56 78 D2
.endif

	; Add (byte) Memory, Memory
	add	(YY60),(yy4)	; 73 44 60
	add	(yy6),(yy8)	; 73 48 D6

	; Add (byte) All, Immediate
	add	Y70,#N		; 45 70 12
	add	yB,#N		; 45 DB 12
	add	(yy2),#N	; F3 42 12
	add	NN,#N		; 2F 41 12 56 78
.ifdef	GLOBAL
	add	Y70,#M		; 45 70 12
	add	yB,#M		; 45 DB 12
	add	(yy2),#M	; F3 42 12
	add	MM,#M		; 2F 41 12 56 78
.endif

	;
	; ADDW
	;
	; Add (Word) - Register, Register
	addw	yy2,yy4		; 4E 24
	addw	YY6,YY20	; 47 20 06
	addw	yy8,YY30	; 47 30 D8
	addw	YY40,yyA	; 47 DA 40
	addw	(y0),YY50	; 96 50 40
	addw	(y1),yyC	; 96 DC 41
	addw	YY60,(y2)	; A6 42 60
	addw	yyE,(y4)	; A6 44 DE

	; Add (Word) - Register, Memory
	addw	yy0,(yy2)	; 4E 03
	addw	YY10,(yy4)	; 7E 44 10
	addw	YY20,(yy6)+	; D5 47 20
	addw	yy8,(yyA)+	; D5 4B D8
	addw	YY30,-(yyC)	; C3 4D 30
	addw	yyE,-(yy0)	; C3 41 DE
	addw	yy2,yy4(yy6)	; 60 46 42
	addw	YY40,N(yy8)	; 86 49 12 40
	addw	yyA,N(yyC)	; 86 4D 12 DA
	addw	yyE,NN		; E2 4E 56 78
	addw	YY50,NN(yy0)	; 86 40 56 78 50
	addw	yy2,NN(yy4)	; 86 44 56 78 D2
.ifdef	GLOBAL
	addw	YY40,*M(yy8)	; 86 49 12 40		; Global -> Forced Short Form
	addw	yyA,*M(yyC)	; 86 4D 12 DA		; Global -> Forced Short Form
	addw	YY40,M(yy8)	; 86 48 00 12 40	; Global -> Long Form
	addw	yyA,M(yyC)	; 86 4C 00 12 DA	; Global -> Long Form
	addw	yyE,MM		; E2 4E 56 78
	addw	YY50,MM(yy0); 86 40 56 78 50
	addw	yy2,MM(yy4)	; 86 44 56 78 D2
.endif

	; Add (Word) - Memory, Register
	addw	(yy0),yy2	; 4E 12
	addw	(yy4),YY10	; BE 45 10
	addw	(yy6)+,YY20	; D5 46 20
	addw	(yy8)+,yyA	; D5 48 DA
	addw	-(yyC),YY30	; C3 4C 30
	addw	-(yyE),yy0	; C3 4E D0
	addw	yy2(yy4),yy6	; 60 25 46
	addw	N(yy8),YY40	; 86 49 12 41
	addw	N(yyA),yyC	; 86 4B 12 DD
	addw	NN,yyC		; E2 4D 56 78
	addw	NN(yyE),YY60	; 86 4E 56 78 61
	addw	NN(yy0),yy2	; 86 40 56 78 D3
.ifdef	GLOBAL
	addw	*M(yy8),YY40	; 86 49 12 41		; Global -> Forced Short Form
	addw	*M(yyA),yyC	; 86 4B 12 DD		; Global -> Forced Short Form
	addw	M(yy8),YY40	; 86 48 00 12 41	; Global -> Long Form
	addw	M(yyA),yyC	; 86 4A 00 12 DD	; Global -> Long Form
	addw	MM,yyC		; E2 4D 56 78
	addw	MM(yyE),YY60	; 86 4E 56 78 61
	addw	MM(yy0),yy2	; 86 40 56 78 D3
.endif

	; Add (Word) - Memory, Memory
	addw	(yy0),(yy2)	; 4E 13

	; Add (Word) - All, Immediate
	addw	YY10,#NN	; 47 11 56 78
	addw	yy4,#NN		; 47 D5 56 78
	addw	(yy8),#NN	; BE 48 56 78
	addw	N(yyA),#NN	; 06 4B 12 56 78
	addw	NN(yyC),#NN	; 06 4C 56 78 56;78
	addw	NN,#NN		; 36 41 56 78 56;78
.ifdef	GLOBAL
	addw	YY10,#MM	; 47 11 56 78
	addw	yy4,#MM		; 47 D5 56 78
	addw	(yy8),#MM	; BE 48 56 78
	addw	*M(yyA),#MM	; 06 4B 12 56 78	; Global -> Forced Short Form
	addw	M(yyA),#MM	; 06 4A 00 12 56;78	; Global -> Long Form
	addw	MM(yyC),#MM	; 06 4C 56 78 56;78
	addw	MM,#MM		; 36 41 56 78 56;78
.endif

	;
	; SUB
	;
	; Subtract (byte) Register, Register
	sub	y3,y7		; 52 37
	sub	y3,(y5)		; 53 35
	sub	Y50,Y90		; 54 90 50
	sub	y3,Y90		; 54 90 D3
	sub	Y50,y7		; 54 D7 50
	sub	(y6),Y30	; E6 30 56
	sub	(yA),y3		; E6 D3 5A
	sub	Y40,(yC)	; E7 5C 40

	; Subtract (byte) Register, Memory
	sub	Y7,(yy2)	; 72 53 07
	sub	y6,(yy4)	; 72 55 D6
	sub	Y5,(yy6)+	; B4 57 05
	sub	y4,(yy8)+	; B4 59 D4
	sub	Y3,-(yyA)	; C2 5B 03
	sub	y2,-(yyC)	; C2 5D D2
	sub	y1,yy8(yyE)	; 60 9E 51
	sub	Y5,N(yy2)	; 7F 53 12 05
	sub	yF,N(yy4)	; 7F 55 12 DF
	sub	yC,NN		; C4 5C 56 78
	sub	Y1,NN(yy6)	; 7F 56 56 78 01
	sub	y2,NN(yy8)	; 7F 58 56 78 D2
.ifdef	GLOBAL
	sub	Y5,*M(yy2)	; 7F 53 12 05		; Global -> Forced Short Form
	sub	yF,*M(yy4)	; 7F 55 12 DF		; Global -> Forced Short Form
	sub	Y5,M(yy2)	; 7F 52 00 12 05	; Global -> Long Form
	sub	yF,M(yy4)	; 7F 54 00 12 DF	; Global -> Long Form
	sub	yC,MM		; C4 5C 56 78
	sub	Y1,MM(yy6)	; 7F 56 56 78 01
	sub	y2,MM(yy8)	; 7F 58 56 78 D2
.endif

	; Subtract (byte) Memory, Register
	sub	(yy0),Y50	; 72 50 50
	sub	(yy2),y8	; 72 52 D8
	sub	(yy4)+,Y60	; B4 54 60
	sub	(yy6)+,y7	; B4 56 D7
	sub	-(yy8),Y70	; C2 58 70
	sub	-(yyA),y6	; C2 5A D6
	sub	yyC(yyE),y5	; 60 DF 55
	sub	N(yyA),Y80	; 26 5B 12 80
	sub	N(yy8),y4	; 26 59 12 D4
	sub	NN,y3		; C5 53 56 78
	sub	NN(yy6),Y90	; 26 56 56 78 90
	sub	NN(yy4),y2	; 26 54 56 78 D2
.ifdef	GLOBAL
	sub	*M(yyA),Y80	; 26 5B 12 80		; Global -> Forced Short Form
	sub	*M(yy8),y4	; 26 59 12 D4		; Global -> Forced Short Form
	sub	M(yyA),Y80	; 26 5A 00 12 80	; Global -> Long Form
	sub	M(yy8),y4	; 26 58 00 12 D4	; Global -> Long Form
	sub	MM,y3		; C5 53 56 78
	sub	MM(yy6),Y90	; 26 56 56 78 90
	sub	MM(yy4),y2	; 26 54 56 78 D2
.endif

	; Subtract (byte) Memory, Memory
	sub	(YY60),(yy4)	; 73 54 60
	sub	(yy6),(yy8)	; 73 58 D6

	; Subtract (byte) All, Immediate
	sub	Y70,#N		; 55 70 12
	sub	yB,#N		; 55 DB 12
	sub	(yy2),#N	; F3 52 12
	sub	NN,#N		; 2F 51 12 56 78
.ifdef	GLOBAL
	sub	Y70,#M		; 55 70 12
	sub	yB,#M		; 55 DB 12
	sub	(yy2),#M	; F3 52 12
	sub	MM,#M		; 2F 51 12 56 78
.endif

	;
	; SUBW
	;
	; Subtract (Word) - Register, Register
	subw	yy2,yy4		; 5E 24
	subw	YY6,YY20	; 57 20 06
	subw	yy8,YY30	; 57 30 D8
	subw	YY40,yyA	; 57 DA 40
	subw	(y0),YY50	; 96 50 50
	subw	(y1),yyC	; 96 DC 51
	subw	YY60,(y2)	; A6 52 60
	subw	yyE,(y4)	; A6 54 DE

	; Subtract (Word) - Register, Memory
	subw	yy0,(yy2)	; 5E 03
	subw	YY10,(yy4)	; 7E 54 10
	subw	YY20,(yy6)+	; D5 57 20
	subw	yy8,(yyA)+	; D5 5B D8
	subw	YY30,-(yyC)	; C3 5D 30
	subw	yyE,-(yy0)	; C3 51 DE
	subw	yy2,yy4(yy6)	; 60 46 52
	subw	YY40,N(yy8)	; 86 59 12 40
	subw	yyA,N(yyC)	; 86 5D 12 DA
	subw	yyE,NN		; E2 5E 56 78
	subw	YY50,NN(yy0)	; 86 50 56 78 50
	subw	yy2,NN(yy4)	; 86 54 56 78 D2
.ifdef	GLOBAL
	subw	YY40,*M(yy8)	; 86 59 12 40		; Global -> Forced Short Form
	subw	yyA,*M(yyC)	; 86 5D 12 DA		; Global -> Forced Short Form
	subw	YY40,M(yy8)	; 86 58 00 12 40	; Global -> Long Form
	subw	yyA,M(yyC)	; 86 5C 00 12 DA	; Global -> Long Form
	subw	yyE,MM		; E2 5E 56 78
	subw	YY50,MM(yy0)	; 86 50 56 78 50
	subw	yy2,MM(yy4)	; 86 54 56 78 D2
.endif

	; Subtract (Word) - Memory, Register
	subw	(yy0),yy2	; 5E 12
	subw	(yy4),YY10	; BE 55 10
	subw	(yy6)+,YY20	; D5 56 20
	subw	(yy8)+,yyA	; D5 58 DA
	subw	-(yyC),YY30	; C3 5C 30
	subw	-(yyE),yy0	; C3 5E D0
	subw	yy2(yy4),yy6	; 60 25 56
	subw	N(yy8),YY40	; 86 59 12 41
	subw	N(yyA),yyC	; 86 5B 12 DD
	subw	NN,yyC		; E2 5D 56 78
	subw	NN(yyE),YY60	; 86 5E 56 78 61
	subw	NN(yy0),yy2	; 86 50 56 78 D3
.ifdef	GLOBAL
	subw	*M(yy8),YY40	; 86 59 12 41		; Global -> Forced Short Form
	subw	*M(yyA),yyC	; 86 5B 12 DD		; Global -> Forced Short Form
	subw	M(yy8),YY40	; 86 58 00 12 41	; Global -> Long Form
	subw	M(yyA),yyC	; 86 5A 00 12 DD	; Global -> Long Form
	subw	MM,yyC		; E2 5D 56 78
	subw	MM(yyE),YY60	; 86 5E 56 78 61
	subw	MM(yy0),yy2	; 86 50 56 78 D3
.endif

	; SSubtract (Word) - Memory, Memory
	subw	(yy0),(yy2)	; 5E 13

	; Subtract (Word) - All, Immediate
	subw	YY10,#NN	; 57 11 56 78
	subw	yy4,#NN		; 57 D5 56 78
	subw	(yy8),#NN	; BE 58 56 78
	subw	N(yyA),#NN	; 06 5B 12 56 78
	subw	NN(yyC),#NN	; 06 5C 56 78 56;78
	subw	NN,#NN		; 36 51 56 78 56;78
.ifdef	GLOBAL
	subw	*M(yyA),#MM	; 06 5B 12 56 78
	subw	YY10,#MM	; 57 11 56 78
	subw	yy4,#MM		; 57 D5 56 78
	subw	(yy8),#MM	; BE 58 56 78
	subw	*M(yyA),#MM	; 06 5B 12 56 78	; Global -> Forced Short Form
	subw	M(yyA),#MM	; 06 5A 00 12 56;78	; Global -> Long Form
	subw	MM(yyC),#MM	; 06 5C 56 78 56;78
	subw	MM,#MM		; 36 51 56 78 56;78
.endif

	;
	; XOR
	;
	; Exclusive OR (byte) Register, Register
	xor	y3,y7		; 62 37
	xor	y3,(y5)		; 63 35
	xor	Y50,Y90		; 64 90 50
	xor	y3,Y90		; 64 90 D3
	xor	Y50,y7		; 64 D7 50
	xor	(y6),Y30	; E6 30 66
	xor	(yA),y3		; E6 D3 6A
	xor	Y40,(yC)	; E7 6C 40

	; XOR (byte) Register, Memory
	xor	Y7,(yy2)	; 72 63 07
	xor	y6,(yy4)	; 72 65 D6
	xor	Y5,(yy6)+	; B4 67 05
	xor	y4,(yy8)+	; B4 69 D4
	xor	Y3,-(yyA)	; C2 6B 03
	xor	y2,-(yyC)	; C2 6D D2
	xor	y1,yy8(yyE)	; 60 9E 61
	xor	Y5,N(yy2)	; 7F 63 12 05
	xor	yF,N(yy4)	; 7F 65 12 DF
	xor	yC,NN		; C4 6C 56 78
	xor	Y1,NN(yy6)	; 7F 66 56 78 01
	xor	y2,NN(yy8)	; 7F 68 56 78 D2
.ifdef	GLOBAL
	xor	Y5,*M(yy2)	; 7F 63 12 05		; Global -> Forced Short Form
	xor	yF,*M(yy4)	; 7F 65 12 DF		; Global -> Forced Short Form
	xor	Y5,M(yy2)	; 7F 62 00 12 05	; Global -> Long Form
	xor	yF,M(yy4)	; 7F 64 00 12 DF	; Global -> Long Form
	xor	yC,MM		; C4 6C 56 78
	xor	Y1,MM(yy6)	; 7F 66 56 78 01
	xor	y2,MM(yy8)	; 7F 68 56 78 D2
.endif

	; XOR (byte) Memory, Register
	xor	(yy0),Y50	; 72 60 50
	xor	(yy2),y8	; 72 62 D8
	xor	(yy4)+,Y60	; B4 64 60
	xor	(yy6)+,y7	; B4 66 D7
	xor	-(yy8),Y70	; C2 68 70
	xor	-(yyA),y6	; C2 6A D6
	xor	yyC(yyE),y5	; 60 DF 65
	xor	N(yyA),Y80	; 26 6B 12 80
	xor	N(yy8),y4	; 26 69 12 D4
	xor	NN,y3		; C5 63 56 78
	xor	NN(yy6),Y90	; 26 66 56 78 90
	xor	NN(yy4),y2	; 26 64 56 78 D2
.ifdef	GLOBAL
	xor	*M(yyA),Y80	; 26 6B 12 80		; Global -> Forced Short Form
	xor	*M(yy8),y4	; 26 69 12 D4		; Global -> Forced Short Form
	xor	M(yyA),Y80	; 26 6A 00 12 80	; Global -> Long Form
	xor	M(yy8),y4	; 26 68 00 12 D4	; Global -> Long Form
	xor	MM,y3		; C5 63 56 78
	xor	MM(yy6),Y90	; 26 66 56 78 90
	xor	MM(yy4),y2	; 26 64 56 78 D2
.endif

	; XOR (byte) Memory, Memory
	xor	(YY60),(yy4)	; 73 64 60
	xor	(yy6),(yy8)	; 73 68 D6

	; XOR (byte) All, Immediate
	xor	Y70,#N		; 65 70 12
	xor	yB,#N		; 65 DB 12
	xor	(yy2),#N	; F3 62 12
	xor	NN,#N		; 2F 61 12 56 78
.ifdef	GLOBAL
	xor	Y70,#M		; 65 70 12
	xor	yB,#M		; 65 DB 12
	xor	(yy2),#M	; F3 62 12
	xor	MM,#M		; 2F 61 12 56 78
.endif

	;
	; XORW
	;
	; XOR (Word) - Register, Register
	xorw	yy2,yy4		; 6E 24
	xorw	YY6,YY20	; 67 20 06
	xorw	yy8,YY30	; 67 30 D8
	xorw	YY40,yyA	; 67 DA 40
	xorw	(y0),YY50	; 96 50 60
	xorw	(y1),yyC	; 96 DC 61
	xorw	YY60,(y2)	; A6 62 60
	xorw	yyE,(y4)	; A6 64 DE

	; XOR (Word) - Register, Memory
	xorw	yy0,(yy2)	; 6E 03
	xorw	YY10,(yy4)	; 7E 64 10
	xorw	YY20,(yy6)+	; D5 67 20
	xorw	yy8,(yyA)+	; D5 6B D8
	xorw	YY30,-(yyC)	; C3 6D 30
	xorw	yyE,-(yy0)	; C3 61 DE
	xorw	yy2,yy4(yy6)	; 60 46 62
	xorw	YY40,N(yy8)	; 86 69 12 40
	xorw	yyA,N(yyC)	; 86 6D 12 DA
	xorw	yyE,NN		; E2 6E 56 78
	xorw	YY50,NN(yy0)	; 86 60 56 78 50
	xorw	yy2,NN(yy4)	; 86 64 56 78 D2
.ifdef	GLOBAL
	xorw	YY40,*M(yy8)	; 86 69 12 40		; Global -> Forced Short Form
	xorw	yyA,*M(yyC)	; 86 6D 12 DA		; Global -> Forced Short Form
	xorw	YY40,M(yy8)	; 86 68 00 12 40	; Global -> Long Form
	xorw	yyA,M(yyC)	; 86 6C 00 12 DA	; Global -> Long Form
	xorw	yyE,MM		; E2 6E 56 78
	xorw	YY50,MM(yy0)	; 86 60 56 78 50
	xorw	yy2,MM(yy4)	; 86 64 56 78 D2
.endif

	; XOR (Word) - Memory, Register
	xorw	(yy0),yy2	; 6E 12
	xorw	(yy4),YY10	; BE 65 10
	xorw	(yy6)+,YY20	; D5 66 20
	xorw	(yy8)+,yyA	; D5 68 DA
	xorw	-(yyC),YY30	; C3 6C 30
	xorw	-(yyE),yy0	; C3 6E D0
	xorw	yy2(yy4),yy6	; 60 25 66
	xorw	N(yy8),YY40	; 86 69 12 41
	xorw	N(yyA),yyC	; 86 6B 12 DD
	xorw	NN,yyC		; E2 6D 56 78
	xorw	NN(yyE),YY60	; 86 6E 56 78 61
	xorw	NN(yy0),yy2	; 86 60 56 78 D3
.ifdef	GLOBAL
	xorw	*M(yy8),YY40	; 86 69 12 41		; Global -> Forced Short Form
	xorw	*M(yyA),yyC	; 86 6B 12 DD		; Global -> Forced Short Form
	xorw	M(yy8),YY40	; 86 68 00 12 41	; Global -> Long Form
	xorw	M(yyA),yyC	; 86 6A 00 12 DD	; Global -> Long Form
	xorw	MM,yyC		; E2 6D 56 78
	xorw	MM(yyE),YY60	; 86 6E 56 78 61
	xorw	MM(yy0),yy2	; 86 60 56 78 D3
.endif

	; XOR (Word) - Memory, Memory
	xorw	(yy0),(yy2)	; 6E 13

	; XOR (Word) - All, Immediate
	xorw	YY10,#NN	; 67 11 56 78
	xorw	yy4,#NN		; 67 D5 56 78
	xorw	(yy8),#NN	; BE 68 56 78
	xorw	N(yyA),#NN	; 06 6B 12 56 78
	xorw	NN(yyC),#NN	; 06 6C 56 78 56;78
	xorw	NN,#NN		; 36 61 56 78 56;78
.ifdef	GLOBAL
	xorw	YY10,#MM	; 67 11 56 78
	xorw	yy4,#MM		; 67 D5 56 78
	xorw	(yy8),#MM	; BE 68 56 78
	xorw	*M(yyA),#NN	; 06 6B 12 56 78	; Global -> Forced Short Form
	xorw	M(yyA),#MM	; 06 6A 00 12 56;78	; Global -> Long Form
	xorw	MM(yyC),#MM	; 06 6C 56 78 56;78
	xorw	MM,#MM		; 36 61 56 78 56;78
.endif

	;
	; TCM
	;
	; Test complement under mask (byte) Register, Register
	tcm	y3,y7		; 82 37
	tcm	y3,(y5)		; 83 35
	tcm	Y50,Y90		; 84 90 50
	tcm	y3,Y90		; 84 90 D3
	tcm	Y50,y7		; 84 D7 50
	tcm	(y6),Y30	; E6 30 86
	tcm	(yA),y3		; E6 D3 8A
	tcm	Y40,(yC)	; E7 8C 40

	; Test complement under mask (byte) Register, Memory
	tcm	Y7,(yy2)	; 72 83 07
	tcm	y6,(yy4)	; 72 85 D6
	tcm	Y5,(yy6)+	; B4 87 05
	tcm	y4,(yy8)+	; B4 89 D4
	tcm	Y3,-(yyA)	; C2 8B 03
	tcm	y2,-(yyC)	; C2 8D D2
	tcm	y1,yy8(yyE)	; 60 9E 81
	tcm	Y5,N(yy2)	; 7F 83 12 05
	tcm	yF,N(yy4)	; 7F 85 12 DF
	tcm	yC,NN		; C4 8C 56 78
	tcm	Y1,NN(yy6)	; 7F 86 56 78 01
	tcm	y2,NN(yy8)	; 7F 88 56 78 D2
.ifdef	GLOBAL
	tcm	Y5,*M(yy2)	; 7F 83 12 05		; Global -> Forced Short Form
	tcm	yF,*M(yy4)	; 7F 85 12 DF		; Global -> Forced Short Form
	tcm	Y5,M(yy2)	; 7F 82 00 12 05	; Global -> Long Form
	tcm	yF,M(yy4)	; 7F 84 00 12 DF	; Global -> Long Form
	tcm	yC,MM		; C4 8C 56 78
	tcm	Y1,MM(yy6)	; 7F 86 56 78 01
	tcm	y2,MM(yy8)	; 7F 88 56 78 D2
.endif

	; Test complement under mask (byte) Memory, Register
	tcm	(yy0),Y50	; 72 80 50
	tcm	(yy2),y8	; 72 82 D8
	tcm	(yy4)+,Y60	; B4 84 60
	tcm	(yy6)+,y7	; B4 86 D7
	tcm	-(yy8),Y70	; C2 88 70
	tcm	-(yyA),y6	; C2 8A D6
	tcm	yyC(yyE),y5	; 60 DF 85
	tcm	N(yyA),Y80	; 26 8B 12 80
	tcm	N(yy8),y4	; 26 89 12 D4
	tcm	MM,y3		; C5 83 56 78
	tcm	MM(yy6),Y90	; 26 86 56 78 90
	tcm	MM(yy4),y2	; 26 84 56 78 D2
.ifdef	GLOBAL
	tcm	*M(yyA),Y80	; 26 8B 12 80		; Global -> Forced Short Form
	tcm	*M(yy8),y4	; 26 89 12 D4		; Global -> Forced Short Form
	tcm	M(yyA),Y80	; 26 8A 00 12 80	; Global -> Long Form
	tcm	M(yy8),y4	; 26 88 00 12 D4	; Global -> Long Form
	tcm	MM,y3		; C5 83 56 78
	tcm	MM(yy6),Y90	; 26 86 56 78 90
	tcm	MM(yy4),y2	; 26 84 56 78 D2
.endif

	; Test complement under mask (byte) Memory, Memory
	tcm	(YY60),(yy4)	; 73 84 60
	tcm	(yy6),(yy8)	; 73 88 D6

	; Test complement under mask (byte) All, Immediate
	tcm	Y70,#N		; 85 70 12
	tcm	yB,#N		; 85 DB 12
	tcm	(yy2),#N	; F3 82 12
	tcm	NN,#N		; 2F 81 12 56 78
.ifdef	GLOBAL
	tcm	Y70,#M		; 85 70 12
	tcm	yB,#M		; 85 DB 12
	tcm	(yy2),#M	; F3 82 12
	tcm	MM,#M		; 2F 81 12 56 78
.endif

	;
	; TCMW
	;
	;  Test Complement Under Mask (Word) - Register, Register
	tcmw	yy2,yy4		; 8E 24
	tcmw	YY6,YY20	; 87 20 06
	tcmw	yy8,YY30	; 87 30 D8
	tcmw	YY40,yyA	; 87 DA 40
	tcmw	(y0),YY50	; 96 50 80
	tcmw	(y1),yyC	; 96 DC 81
	tcmw	YY60,(y2)	; A6 82 60
	tcmw	yyE,(y4)	; A6 84 DE

	; Test Complement Under Mask (Word) - Register, Memory
	tcmw	yy0,(yy2)	; 8E 03
	tcmw	YY10,(yy4)	; 7E 84 10
	tcmw	YY20,(yy6)+	; D5 87 20
	tcmw	yy8,(yyA)+	; D5 8B D8
	tcmw	YY30,-(yyC)	; C3 8D 30
	tcmw	yyE,-(yy0)	; C3 81 DE
	tcmw	yy2,yy4(yy6)	; 60 46 82
	tcmw	YY40,N(yy8)	; 86 89 12 40
	tcmw	yyA,N(yyC)	; 86 8D 12 DA
	tcmw	yyE,NN		; E2 8E 56 78
	tcmw	YY50,NN(yy0)	; 86 80 56 78 50
	tcmw	yy2,NN(yy4)	; 86 84 56 78 D2
.ifdef	GLOBAL
	tcmw	YY40,*M(yy8)	; 86 89 12 40		; Global -> Forced Short Form
	tcmw	yyA,*M(yyC)	; 86 8D 12 DA		; Global -> Forced Short Form
	tcmw	YY40,M(yy8)	; 86 88 00 12 40	; Global -> Long Form
	tcmw	yyA,M(yyC)	; 86 8C 00 12 DA	; Global -> Long Form
	tcmw	yyE,MM		; E2 8E 56 78
	tcmw	YY50,MM(yy0)	; 86 80 56 78 50
	tcmw	yy2,MM(yy4)	; 86 84 56 78 D2
.endif

	; Test Complement Under Mask (Word) - Memory, Register
	tcmw	(yy0),yy2	; 8E 12
	tcmw	(yy4),YY10	; BE 85 10
	tcmw	(yy6)+,YY20	; D5 86 20
	tcmw	(yy8)+,yyA	; D5 88 DA
	tcmw	-(yyC),YY30	; C3 8C 30
	tcmw	-(yyE),yy0	; C3 8E D0
	tcmw	yy2(yy4),yy6	; 60 25 86
	tcmw	N(yy8),YY40	; 86 89 12 41
	tcmw	N(yyA),yyC	; 86 8B 12 DD
	tcmw	NN,yyC		; E2 8D 56 78
	tcmw	NN(yyE),YY60	; 86 8E 56 78 61
	tcmw	NN(yy0),yy2	; 86 80 56 78 D3
.ifdef	GLOBAL
	tcmw	*M(yy8),YY40	; 86 89 12 41		; Global -> Forced Short Form
	tcmw	*M(yyA),yyC	; 86 8B 12 DD		; Global -> Forced Short Form
	tcmw	M(yy8),YY40	; 86 88 00 12 41	; Global -> Long Form
	tcmw	M(yyA),yyC	; 86 8A 00 12 DD	; Global -> Long Form
	tcmw	MM,yyC		; E2 8D 56 78
	tcmw	MM(yyE),YY60	; 86 8E 56 78 61
	tcmw	MM(yy0),yy2	; 86 80 56 78 D3
.endif

	; Test Complement Under Mask (Word) - Memory, Memory
	tcmw	(yy0),(yy2)	; 8E 13

	; Test Complement Under Mask (Word) - All, Immediate
	tcmw	YY10,#NN	; 87 11 56 78
	tcmw	yy4,#NN		; 87 D5 56 78
	tcmw	(yy8),#NN	; BE 88 56 78
	tcmw	N(yyA),#NN	; 06 8B 12 56 78
	tcmw	NN(yyC),#NN	; 06 8C 56 78 56;78
	tcmw	NN,#NN		; 36 81 56 78 56;78
.ifdef	GLOBAL
	tcmw	YY10,#MM	; 87 11 56 78
	tcmw	yy4,#MM		; 87 D5 56 78
	tcmw	(yy8),#MM	; BE 88 56 78
	tcmw	*M(yyA),#NN	; 06 8B 12 56 78	; Global -> Forced Short Form
	tcmw	M(yyA),#MM	; 06 8A 00 12 56;78	; Global -> Long Form
	tcmw	MM(yyC),#MM	; 06 8C 56 78 56;78
	tcmw	MM,#MM		; 36 81 56 78 56;78
.endif

	;
	; CP
	;
	; CP (byte) Register, Register
	cp	y3,y7		; 92 37
	cp	y3,(y5)		; 93 35
	cp	Y50,Y90		; 94 90 50
	cp	y3,Y90		; 94 90 D3
	cp	Y50,y7		; 94 D7 50
	cp	(y6),Y30	; E6 30 96
	cp	(yA),y3		; E6 D3 9A
	cp	Y40,(yC)	; E7 9C 40

	; CP (byte) Register, Memory
	cp	Y7,(yy2)	; 72 93 07
	cp	y6,(yy4)	; 72 95 D6
	cp	Y5,(yy6)+	; B4 97 05
	cp	y4,(yy8)+	; B4 99 D4
	cp	Y3,-(yyA)	; C2 9B 03
	cp	y2,-(yyC)	; C2 9D D2
	cp	y1,yy8(yyE)	; 60 9E 91
	cp	Y5,N(yy2)	; 7F 93 12 05
	cp	yF,N(yy4)	; 7F 95 12 DF
	cp	yC,NN		; C4 9C 56 78
	cp	Y1,NN(yy6)	; 7F 96 56 78 01
	cp	y2,NN(yy8)	; 7F 98 56 78 D2
.ifdef	GLOBAL
	cp	Y5,*M(yy2)	; 7F 93 12 05		; Global -> Forced Short Form
	cp	yF,*M(yy4)	; 7F 95 12 DF		; Global -> Forced Short Form
	cp	Y5,M(yy2)	; 7F 92 00 12 05	; Global -> Long Form
	cp	yF,M(yy4)	; 7F 94 00 12 DF	; Global -> Long Form
	cp	yC,MM		; C4 9C 56 78
	cp	Y1,MM(yy6)	; 7F 96 56 78 01
	cp	y2,MM(yy8)	; 7F 98 56 78 D2
.endif

	; CP (byte) Memory, Register
	cp	(yy0),Y50	; 72 90 50
	cp	(yy2),y8	; 72 92 D8
	cp	(yy4)+,Y60	; B4 94 60
	cp	(yy6)+,y7	; B4 96 D7
	cp	-(yy8),Y70	; C2 98 70
	cp	-(yyA),y6	; C2 9A D6
	cp	yyC(yyE),y5	; 60 DF 95
	cp	N(yyA),Y80	; 26 9B 12 80
	cp	N(yy8),y4	; 26 99 12 D4
	cp	NN,y3		; C5 93 56 78
	cp	NN(yy6),Y90	; 26 96 56 78 90
	cp	NN(yy4),y2	; 26 94 56 78 D2
.ifdef	GLOBAL
	cp	*M(yyA),Y80	; 26 9B 12 80		; Global -> Forced Short Form
	cp	*M(yy8),y4	; 26 99 12 D4		; Global -> Forced Short Form
	cp	M(yyA),Y80	; 26 9A 00 12 80	; Global -> Long Form
	cp	M(yy8),y4	; 26 98 00 12 D4	; Global -> Long Form
	cp	MM,y3		; C5 93 56 78
	cp	MM(yy6),Y90	; 26 96 56 78 90
	cp	MM(yy4),y2	; 26 94 56 78 D2
.endif

	; CP (byte) Memory, Memory
	cp	(YY60),(yy4)	; 73 94 60
	cp	(yy6),(yy8)	; 73 98 D6

	; CP (byte) All, Immediate
	cp	Y70,#N		; 95 70 12
	cp	yB,#N		; 95 DB 12
	cp	(yy2),#N	; F3 92 12
	cp	NN,#N		; 2F 91 12 56 78
.ifdef	GLOBAL
	cp	Y70,#M		; 95 70 12
	cp	yB,#M		; 95 DB 12
	cp	(yy2),#M	; F3 92 12
	cp	MM,#M		; 2F 91 12 56 78
.endif

	;
	; CPW
	;
	; CP (Word) - Register, Register
	cpw	yy2,yy4		; 9E 24
	cpw	YY6,YY20	; 97 20 06
	cpw	yy8,YY30	; 97 30 D8
	cpw	YY40,yyA	; 97 DA 40
	cpw	(y0),YY50	; 96 50 90
	cpw	(y1),yyC	; 96 DC 91
	cpw	YY60,(y2)	; A6 92 60
	cpw	yyE,(y4)	; A6 94 DE

	; CP (Word) - Register, Memory
	cpw	yy0,(yy2)	; 9E 03
	cpw	YY10,(yy4)	; 7E 94 10
	cpw	YY20,(yy6)+	; D5 97 20
	cpw	yy8,(yyA)+	; D5 9B D8
	cpw	YY30,-(yyC)	; C3 9D 30
	cpw	yyE,-(yy0)	; C3 91 DE
	cpw	yy2,yy4(yy6)	; 60 46 92
	cpw	YY40,N(yy8)	; 86 99 12 40
	cpw	yyA,N(yyC)	; 86 9D 12 DA
	cpw	yyE,NN		; E2 9E 56 78
	cpw	YY50,NN(yy0)	; 86 90 56 78 50
	cpw	yy2,NN(yy4)	; 86 94 56 78 D2
.ifdef	GLOBAL
	cpw	YY40,*M(yy8)	; 86 99 12 40		; Global -> Forced Short Form
	cpw	yyA,*M(yyC)	; 86 9D 12 DA		; Global -> Forced Short Form
	cpw	YY40,M(yy8)	; 86 98 00 12 40	; Global -> Long Form
	cpw	yyA,M(yyC)	; 86 9C 00 12 DA	; Global -> Long Form
	cpw	yyE,MM		; E2 9E 56 78
	cpw	YY50,MM(yy0)	; 86 90 56 78 50
	cpw	yy2,MM(yy4)	; 86 94 56 78 D2
.endif

	; CP (Word) - Memory, Register
	cpw	(yy0),yy2	; 9E 12
	cpw	(yy4),YY10	; BE 95 10
	cpw	(yy6)+,YY20	; D5 96 20
	cpw	(yy8)+,yyA	; D5 98 DA
	cpw	-(yyC),YY30	; C3 9C 30
	cpw	-(yyE),yy0	; C3 9E D0
	cpw	yy2(yy4),yy6	; 60 25 96
	cpw	N(yy8),YY40	; 86 99 12 41
	cpw	N(yyA),yyC	; 86 9B 12 DD
	cpw	NN,yyC		; E2 9D 56 78
	cpw	NN(yyE),YY60	; 86 9E 56 78 61
	cpw	NN(yy0),yy2	; 86 90 56 78 D3
.ifdef	GLOBAL
	cpw	*M(yy8),YY40	; 86 99 12 41		; Global -> Forced Short Form
	cpw	*M(yyA),yyC	; 86 9B 12 DD		; Global -> Forced Short Form
	cpw	M(yy8),YY40	; 86 98 00 12 41	; Global -> Long Form
	cpw	M(yyA),yyC	; 86 9A 00 12 DD	; Global -> Long Form
	cpw	MM,yyC		; E2 9D 56 78
	cpw	MM(yyE),YY60	; 86 9E 56 78 61
	cpw	MM(yy0),yy2	; 86 90 56 78 D3
.endif

	; CP (Word) - Memory, Memory
	cpw	(yy0),(yy2)	; 9E 13

	; CP (Word) - All, Immediate
	cpw	YY10,#NN	; 97 11 56 78
	cpw	yy4,#NN		; 97 D5 56 78
	cpw	(yy8),#NN	; BE 98 56 78
	cpw	N(yyA),#NN	; 06 9B 12 56 78
	cpw	NN(yyC),#NN	; 06 9C 56 78 56;78
	cpw	NN,#NN		; 36 91 56 78 56;78
.ifdef	GLOBAL
	cpw	YY10,#MM	; 97 11 56 78
	cpw	yy4,#MM		; 97 D5 56 78
	cpw	(yy8),#MM	; BE 98 56 78
	cpw	*M(yyA),#MM	; 06 9B 12 56 78	; Global -> Forced Short Form
	cpw	M(yyA),#MM	; 06 9A 00 12 56;78	; Global -> Long Form
	cpw	MM(yyC),#MM	; 06 9C 56 78 56;78
	cpw	MM,#MM		; 36 91 56 78 56;78
.endif

	;
	; TM
	;
	; Test under mask (byte) Register, Register
	tm	y3,y7		; A2 37
	tm	y3,(y5)		; A3 35
	tm	Y50,Y90		; A4 90 50
	tm	y3,Y90		; A4 90 D3
	tm	Y50,y7		; A4 D7 50
	tm	(y6),Y30	; E6 30 A6
	tm	(yA),y3		; E6 D3 AA
	tm	Y40,(yC)	; E7 AC 40

	; Test under mask (byte) Register, Memory
	tm	Y7,(yy2)	; 72 A3 07
	tm	y6,(yy4)	; 72 A5 D6
	tm	Y5,(yy6)+	; B4 A7 05
	tm	y4,(yy8)+	; B4 A9 D4
	tm	Y3,-(yyA)	; C2 AB 03
	tm	y2,-(yyC)	; C2 AD D2
	tm	y1,yy8(yyE)	; 60 9E A1
	tm	Y5,N(yy2)	; 7F A3 12 05
	tm	yF,N(yy4)	; 7F A5 12 DF
	tm	yC,NN		; C4 AC 56 78
	tm	Y1,NN(yy6)	; 7F A6 56 78 01
	tm	y2,NN(yy8)	; 7F A8 56 78 D2
.ifdef	GLOBAL
	tm	Y5,*M(yy2)	; 7F A3 12 05		; Global -> Forced Short Form
	tm	yF,*M(yy4)	; 7F A5 12 DF		; Global -> Forced Short Form
	tm	Y5,M(yy2)	; 7F A2 00 12 05	; Global -> Long Form
	tm	yF,M(yy4)	; 7F A4 00 12 DF	; Global -> Long Form
	tm	yC,MM		; C4 AC 56 78
	tm	Y1,MM(yy6)	; 7F A6 56 78 01
	tm	y2,MM(yy8)	; 7F A8 56 78 D2
.endif

	; Test under mask (byte) Memory, Register
	tm	(yy0),Y50	; 72 A0 50
	tm	(yy2),y8	; 72 A2 D8
	tm	(yy4)+,Y60	; B4 A4 60
	tm	(yy6)+,y7	; B4 A6 D7
	tm	-(yy8),Y70	; C2 A8 70
	tm	-(yyA),y6	; C2 AA D6
	tm	yyC(yyE),y5	; 60 DF A5
	tm	N(yyA),Y80	; 26 AB 12 80
	tm	N(yy8),y4	; 26 A9 12 D4
	tm	NN,y3		; C5 A3 56 78
	tm	NN(yy6),Y90	; 26 A6 56 78 90
	tm	NN(yy4),y2	; 26 A4 56 78 D2
.ifdef	GLOBAL
	tm	*M(yyA),Y80	; 26 AB 12 80		; Global -> Forced Short Form
	tm	*M(yy8),y4	; 26 A9 12 D4		; Global -> Forced Short Form
	tm	M(yyA),Y80	; 26 AA 00 12 80	; Global -> Long Form
	tm	M(yy8),y4	; 26 A8 00 12 D4	; Global -> Long Form
	tm	MM,y3		; C5 A3 56 78
	tm	MM(yy6),Y90	; 26 A6 56 78 90
	tm	MM(yy4),y2	; 26 A4 56 78 D2
.endif

	; Test under mask (byte) Memory, Memory
	tm	(YY60),(yy4)	; 73 A4 60
	tm	(yy6),(yy8)	; 73 A8 D6

	; Test under mask (byte) All, Immediate
	tm	Y70,#N		; A5 70 12
	tm	yB,#N		; A5 DB 12
	tm	(yy2),#N	; F3 A2 12
	tm	NN,#N		; 2F A1 12 56 78
.ifdef	GLOBAL
	tm	Y70,#M		; A5 70 12
	tm	yB,#M		; A5 DB 12
	tm	(yy2),#M	; F3 A2 12
	tm	MM,#M		; 2F A1 12 56 78
.endif

	;
	; TMW
	;
	; Test Under Mask (Word) - Register, Register
	tmw	yy2,yy4		; AE 24
	tmw	YY6,YY20	; A7 20 06
	tmw	yy8,YY30	; A7 30 D8
	tmw	YY40,yyA	; A7 DA 40
	tmw	(y0),YY50	; 96 50 A0
	tmw	(y1),yyC	; 96 DC A1
	tmw	YY60,(y2)	; A6 A2 60
	tmw	yyE,(y4)	; A6 A4 DE

	; Test Under Mask (Word) - Register, Memory
	tmw	yy0,(yy2)	; AE 03
	tmw	YY10,(yy4)	; 7E A4 10
	tmw	YY20,(yy6)+	; D5 A7 20
	tmw	yy8,(yyA)+	; D5 AB D8
	tmw	YY30,-(yyC)	; C3 AD 30
	tmw	yyE,-(yy0)	; C3 A1 DE
	tmw	yy2,yy4(yy6)	; 60 46 A2
	tmw	YY40,N(yy8)	; 86 A9 12 40
	tmw	yyA,N(yyC)	; 86 AD 12 DA
	tmw	yyE,NN		; E2 AE 56 78
	tmw	YY50,NN(yy0)	; 86 A0 56 78 50
	tmw	yy2,NN(yy4)	; 86 A4 56 78 D2
.ifdef	GLOBAL
	tmw	YY40,*M(yy8)	; 86 A9 12 40		; Global -> Forced Short Form
	tmw	yyA,*M(yyC)	; 86 AD 12 DA		; Global -> Forced Short Form
	tmw	YY40,M(yy8)	; 86 A8 00 12 40	; Global -> Long Form
	tmw	yyA,M(yyC)	; 86 AC 00 12 DA	; Global -> Long Form
	tmw	yyE,MM		; E2 AE 56 78
	tmw	YY50,MM(yy0)	; 86 A0 56 78 50
	tmw	yy2,MM(yy4)	; 86 A4 56 78 D2
.endif

	; Test Under Mask (Word) - Memory, Register
	tmw	(yy0),yy2	; AE 12
	tmw	(yy4),YY10	; BE A5 10
	tmw	(yy6)+,YY20	; D5 A6 20
	tmw	(yy8)+,yyA	; D5 A8 DA
	tmw	-(yyC),YY30	; C3 AC 30
	tmw	-(yyE),yy0	; C3 AE D0
	tmw	yy2(yy4),yy6	; 60 25 A6
	tmw	N(yy8),YY40	; 86 A9 12 41
	tmw	N(yyA),yyC	; 86 AB 12 DD
	tmw	NN,yyC		; E2 AD 56 78
	tmw	NN(yyE),YY60	; 86 AE 56 78 61
	tmw	NN(yy0),yy2	; 86 A0 56 78 D3
.ifdef	GLOBAL
	tmw	*M(yy8),YY40	; 86 A9 12 41		; Global -> Forced Short Form
	tmw	*M(yyA),yyC	; 86 AB 12 DD		; Global -> Forced Short Form
	tmw	M(yy8),YY40	; 86 A8 00 12 41	; Global -> Long Form
	tmw	M(yyA),yyC	; 86 AA 00 12 DD	; Global -> Long Form
	tmw	MM,yyC		; E2 AD 56 78
	tmw	MM(yyE),YY60	; 86 AE 56 78 61
	tmw	MM(yy0),yy2	; 86 A0 56 78 D3
.endif

	; Test Under Mask (Word) - Memory, Memory
	tmw	(yy0),(yy2)	; AE 13

	; Test Under Mask (Word) - All, Immediate
	tmw	YY10,#NN	; A7 11 56 78
	tmw	yy4,#NN		; A7 D5 56 78
	tmw	(yy8),#NN	; BE A8 56 78
	tmw	N(yyA),#NN	; 06 AB 12 56 78
	tmw	NN(yyC),#NN	; 06 AC 56 78 56;78
	tmw	NN,#NN		; 36 A1 56 78 56;78
.ifdef	GLOBAL
	tmw	YY10,#MM	; A7 11 56 78
	tmw	yy4,#MM		; A7 D5 56 78
	tmw	(yy8),#MM	; BE A8 56 78
	tmw	*M(yyA),#MM	; 06 AB 12 56 78	; Global -> Forced Short Form
	tmw	M(yyA),#MM	; 06 AA 00 12 56;78	; Global -> Long Form
	tmw	MM(yyC),#MM	; 06 AC 56 78 56;78
	tmw	MM,#MM		; 36 A1 56 78 56;78
.endif

	;
	; LD
	;
	; Load (byte) Register, Register
	ld	y1,Y7		; 18 07
	ld	y2,y7		; 28 D7
	ld	YA,y6		; 69 0A
	ld	(y3),y8		; E6 38
	ld	y9,(y4)		; E4 94
	ld	(y7),Y40	; E6 40 F7
	ld	Y50,(y1)	; E7 F1 50
	ld	N(y5),y3	; B2 35 12
	ld	y2,N(y4)	; B3 24 12
	ld	Y4,Y90		; F4 90 04

	; Load (byte) Register, Memory
	ld	y3,(yy6)	; B5 36
	ld	(y1)+,(yy2)+	; D7 13
	ld	Y20,(yy4)+	; B4 F5 20
	ld	y3,(yy6)+	; B4 F7 D3
	ld	Y30,-(yy0)	; C2 F1 30
	ld	Y3,-(yy2)	; C2 F3 03
	ld	Y40,(yy4)	; 72 F5 40
	ld	y1,yy8(yy6)	; 60 96 F1
	ld	Y2,N(yyA)	; 7F FB 12 02
	ld	y3,N(yy8)	; 7F F9 12 D3
	ld	y5,NN		; C4 F5 56 78
	ld	Y7,NN(yy2)	; 7F F2 56 78 07
	ld	y1,NN(yy6)	; 7F F6 56 78 D1
.ifdef	GLOBAL
	ld	Y2,*M(yyA)	; 7F FB 12 02		; Global -> Forced Short Form
	ld	y3,*M(yy8)	; 7F F9 12 D3		; Global -> Forced Short Form
	ld	Y2,M(yyA)	; 7F FA 00 12 02	; Global -> Long Form
	ld	y3,M(yy8)	; 7F F8 00 12 D3	; Global -> Long Form
	ld	y5,MM		; C4 F5 56 78
	ld	Y7,MM(yy2)	; 7F F2 56 78 07
	ld	y1,MM(yy6)	; 7F F6 56 78 D1
.endif

	; Load (byte) Memory, Register
	ld	(yy2)+,(y7)+	; D7 72
	ld	(yy6),y3	; B5 37
	ld	(yy8)+,Y30	; B4 F8 30
	ld	(yyA)+,y9	; B4 FA D9
	ld	-(yy4),Y40	; C2 F4 40
	ld	-(yyC),y0	; C2 FC D0
	ld	(yy2),Y60	; 72 F2 60
	ld	yy6(yy8),y3	; 60 79 F3
	ld	N(yy4),Y10	; 26 F5 12 10
	ld	N(yy8),yA	; 26 F9 12 DA
	ld	NN,y7		; C5 F7 56 78
	ld	NN(yy6),Y70	; 26 F6 56 78 70
	ld	NN(yy2),r7	; 26 F2 56 78 D7
.ifdef	GLOBAL
	ld	*M(yy4),Y10	; 26 F5 12 10		; Global -> Forced Short Form
	ld	*M(yy8),yA	; 26 F9 12 DA		; Global -> Forced Short Form
	ld	M(yy4),Y10	; 26 F4 00 12 10	; Global -> Long Form
	ld	M(yy8),yA	; 26 F8 00 12 DA	; Global -> Long Form
	ld	MM,y7		; C5 F7 56 78
	ld	MM(yy6),Y70	; 26 F6 56 78 70
	ld	MM(yy2),r7	; 26 F2 56 78 D7
.endif

	; Load (Byte) Memory, Memory
	ld	(YY50),(yy4)	; 73 F4 50
	ld	(yy6),(yy8)	; 73 F8 D6

	; Load (Byte) All, Immediate
	ld	y1,#N		; 1C 12
	ld	R7,#N		; F5 07 12
	ld	(yy4),#N	; F3 F4 12
	ld	NN,#N		; 2F F1 12 56 78
.ifdef	GLOBAL
	ld	y1,#M		; 1C 12
	ld	R7,#M		; F5 07 12
	ld	(yy4),#M	; F3 F4 12
	ld	MM,#M		; 2F F1 12 56 78
.endif

	;
	; LDW
	;
	; Load (Word) Register, Register
	ldw	yy4,yy6		; E3 46
	ldw	(y1),YY20	; 96 20 F1
	ldw	(y3),yy4	; 96 D4 F3
	ldw	YY50,(y5)	; A6 F5 50
	ldw	yy6,(y1)	; A6 F1 D6
	ldw	N(y1),yy8	; DE 91 12
	ldw	yy2,N(y3)	; DE 23 12
	ldw	YY30,YY80	; EF 80 30
	ldw	yy6,YY40	; EF 40 D6
	ldw	YY70,yy2	; EF D2 70
.ifdef	GLOBAL
	ldw	*M(y1),yy8	; DE 91 12		; Global -> Always Short Form
	ldw	yy2,*M(y3)	; DE 23 12		; Global -> Always Short Form
	ldw	M(y1),yy8	; DE 91 12		; Global -> Always Short Form
	ldw	yy2,M(y3)	; DE 23 12		; Global -> Always Short Form
.endif

	; Load (Word) Register, Memory
	ldw	yy2,(yy4)	; E3 25
	ldw	YY40,(yy2)+	; D5 F3 40
	ldw	yy6,(yyA)+	; D5 FB D6
	ldw	YY30,-(yy6)	; C3 F7 30
	ldw	yy2,-(yy8)	; C3 F9 D2
	ldw	YY50,(yyC)	; 7E FC 50
	ldw	yy8,yy2(yy4)	; 60 24 F8
	ldw	YY40,N(yy0)	; 86 F1 12 40
	ldw	yy4,N(yy2)	; 86 F3 12 D4
	ldw	yy2,NN		; E2 F2 56 78
	ldw	YY60,NN(yy6)	; 86 F6 56 78 60
	ldw	yy8,NN(yyA)	; 86 FA 56 78 D8
.ifdef	GLOBAL
	ldw	YY40,*M(yy0)	; 86 F1 12 40		; Global -> Forced Short Form
	ldw	yy4,*M(yy2)	; 86 F3 12 D4		; Global -> Forced Short Form
	ldw	YY40,M(yy0)	; 86 F0 00 12 40	; Global -> Long Form
	ldw	yy4,M(yy2)	; 86 F2 00 12 D4	; Global -> Long Form
	ldw	yy2,MM		; E2 F2 56 78
	ldw	YY60,MM(yy6)	; 86 F6 56 78 60
	ldw	yy8,MM(yyA)	; 86 FA 56 78 D8
.endif

	; Load (Word) Memory, Register
	ldw	(yy2),yy4	; E3 34
	ldw	(yy0)+,YY40	; D5 F0 40
	ldw	(yy4)+,yy0	; D5 F4 D0
	ldw	-(yy6),YY60	; C3 F6 60
	ldw	-(yy8),yy2	; C3 F8 D2
	ldw	(yyA),YY50	; BE FB 50
	ldw	yy2(yy4),yy6	; 60 25 F6
	ldw	N(yy2),YY20	; 86 F3 12 21
	ldw	N(yy4),yy6	; 86 F5 12 D7
	ldw	NN,yy0		; E2 F1 56 78
	ldw	NN(yy4),YY80	; 86 F4 56 78 81
	ldw	NN(yy6),yy8	; 86 F6 56 78 D9
.ifdef	GLOBAL
	ldw	*M(yy2),YY20	; 86 F3 12 21		; Global -> Forced Short Form
	ldw	*M(yy4),yy6	; 86 F5 12 D7		; Global -> Forced Short Form
	ldw	M(yy2),YY20	; 86 F2 00 12 21	; Global -> Long Form
	ldw	M(yy4),yy6	; 86 F4 00 12 D7	; Global -> Long Form
	ldw	MM,yy0		; E2 F1 56 78
	ldw	MM(yy4),YY80	; 86 F4 56 78 81
	ldw	MM(yy6),yy8	; 86 F6 56 78 D9
.endif

	; Load (Word) Memory, Memory
	ldw	(yy0),(yy2)	; E3 13

	; Load (Word) All, Immediate
	ldw	YY20,#NN	; BF 20 56 78
	ldw	yy4,#NN		; BF D4 56 78
	ldw	(yy6),#NN	; BF F6 56 78
	ldw	N(yy8),#NN	; 06 F9 12 56 78
	ldw	NN(yy2),#NN	; 06 F2 56 78 56 78
	ldw	NN,#NN		; 36 F1 56 78 56 78
.ifdef	GLOBAL
	ldw	YY20,#MM	; BF 20 56 78
	ldw	yy4,#MM		; BF D4 56 78
	ldw	(yy6),#MM	; BF F6 56 78
	ldw	*M(yy8),#MM	; 06 F9 12 56 78	; Global -> Forced Short Form
	ldw	M(yy8),#MM	; 06 F8 00 12 56;78	; Global -> Long Form
	ldw	MM(yy2),#MM	; 06 F2 56 78 56;78
	ldw	MM,#MM		; 36 F1 56 78 56;78
.endif

	;
	; BAND
	;
	; Bit AND
	band	r4.7,r10.4	; 1F F4 9A
	band	r8.2,r6.!4	; 1F 58 86
	band	r3.3,r2.B5	; 1F 73 B2
	band	r0.1,r5.!B5	; 1F 30 A5
.ifdef	GLOBAL
	band	r3.3,r2.X5	; 1F 73 B2
	band	r0.1,r5.!X5	; 1F 30 A5
.endif
	;
	; BCPL
	;
	; Bit Complment
	bcpl	r2.6		; 6F C2
	bcpl	r4.B5		; 6F A4
.ifdef	GLOBAL
	bcpl	r4.X5		; 6F A4
.endif

	;
	; BLD
	;
	; Bit Load
	bld	r8.3,r5.1	; F2 35 68
	bld	r7.2,r3.!5	; F2 B3 57
	bld	r8.3,r5.B1	; F2 35 68
	bld	r7.2,r3.!B5	; F2 B3 57
.ifdef	GLOBAL
	bld	r8.3,r5.X1	; F2 35 68
	bld	r7.2,r3.!X5	; F2 B3 57
.endif

	;
	; BOR
	;
	; Bit OR
	bor	r9.0,r14.3	; 0F 19 6E
	bor	r10.1,r2.!6	; 0F 3A D2
	bor	r9.0,r14.B3	; 0F 19 6E
	bor	r10.1,r2.!B6	; 0F 3A D2
.ifdef	GLOBAL
	bor	r9.0,r14.X3	; 0F 19 6E
	bor	r10.1,r2.!X6	; 0F 3A D2
.endif

	;
	; BRES
	;
	; Bit Reset
	bres	r3.4		; 1F 83
	bres	r3.B4		; 1F 83
.ifdef	GLOBAL
	bres	r3.X4		; 1F 83
.endif

	;
	; BSET
	;
	; Bit Set
	bset	r7.5		; 0F A7
	bset	r7.B5		; 0F A7
.ifdef	GLOBAL
	bset	r7.X5		; 0F A7
.endif

	;
	; BTJF / BRJT
	;
	; Bit Test And Jump
	btjf	r4.5,.		; AF B4 FD
	btjt	r6.7,.		; AF E6 FD
	btjf	r4.B5,.		; AF B4 FD
	btjt	r6.B7,.		; AF E6 FD
.ifdef	GLOBAL
	btjf	r4.X5,.		; AF B4 FD
	btjt	r6.X7,.		; AF E6 FD
.endif

	btjf	r4.5,.+N	; AF B4 0F
	btjt	r6.7,.+N	; AF E6 0F
	btjf	r4.B5,.+N	; AF B4 0F
	btjt	r6.B7,.+N	; AF E6 0F
.ifdef	GLOBAL
	btjf	r4.X5,.+N	; AF B4 0F
	btjt	r6.X7,.+N	; AF E6 0F
.endif

btjf:	btjf	r4.5,btjf	; AF B4 FD
	btjt	r6.7,btjf	; AF E6 FA
.ifdef	GLOBAL
	btjf	r4.5,.+M	; AF B4 0F
	btjt	r6.7,.+M	; AF E6 0F
	btjf	r4.X5,.+M	; AF B4 0F
	btjt	r6.X7,.+M	; AF E6 0F
.endif

	;
	; BTSET
	;
	; Bit Test And Set
	btset	r7.2		; F2 47
	btset	(rr8).2		; F6 48
	btset	r7.B2		; F2 47
	btset	(rr8).B2	; F6 48
.ifdef	GLOBAL
	btset	r7.X2		; F2 47
	btset	(rr8).X2	; F6 48
.endif

	;
	; BXOR
	;
	; Bit XOR
	bxor	r2.3,r7.5	; 6F 72 A7
	bxor	r9.3,r4.!6	; 6F 79 D4
	bxor	r2.3,r7.B5	; 6F 72 A7
	bxor	r9.3,r4.!B6	; 6F 79 D4
.ifdef	GLOBAL
	bxor	r2.3,r7.X5	; 6F 72 A7
	bxor	r9.3,r4.!X6	; 6F 79 D4
.endif

	;
	; CALL, CALLS
	;
	; Unconditional Call (Segment)
	call	(YY50)		; 74 51
	call	(yy8)		; 74 D9
	call	NN		; D2 56 78
.ifdef	GLOBAL
	call	MM		; D2 56 78
.endif
	calls	N,NN		; 3F 52 56 78
.ifdef	GLOBAL
	calls	M,MM		; 3F 52 56 78
.endif
	calls	(Y20),(yy6)	; 73 D7 20
	calls	(y3),(yyA)	; 73 DB D3
	;
	; CCF
	;
	; Complement Cary Flag
	ccf			; 61

	;
	; CLR
	;
	; Clear Register
	clr	Y30		; 90 30
	clr	y5		; 90 D5
	clr	(Y40)		; 91 40
	clr	(y2)		; 91 D2

	; 
	; CPJFI, CPJTI
	;
	; Compare And Jump False/True Otherwise Post-Increment
	cpjfi	y3,(yyA),.	; 9F A3 FD
	cpjti	y4,(yyC),.	; 9F D4 FD

	cpjfi	y3,(yyA),.+N	; 9F A3 0F
	cpjti	y4,(yyC),.+N	; 9F D4 0F

cpjfi:	cpjfi	y3,(yyA),cpjfi	; 9F A3 FD
	cpjti	y4,(yyC),cpjfi	; 9F D4 FA
.ifdef	GLOBAL
	cpjfi	y3,(yyA),.+M	; 9F A3 0F
	cpjti	y4,(yyC),.+M	; 9F D4 0F
.endif

	;
	; CPL
	;
	; Complement Register
	cpl	Y60		; 80 60
	cpl	y9		; 80 D9
	cpl	(Y70)		; 81 70
	cpl	(y1)		; 81 D1

	;
	; DA
	;
	; Decimal Adjust
	;
	da	Y30		; 70 30
	da	y7		; 70 D7
	da	(Y40)		; 71 40
	da	(y2)		; 71 D2

	;
	; DEC, DECW
	;
	; Decrement Register (Word Register
	dec	Y20		; 40 20
	dec	yE		; 40 DE
	dec	(Y80)		; 41 80
	dec	(yF)		; 41 DF

	decw	YY30		; CF 30
	decw	yy4		; CF D4

	;
	; DI
	;
	; Disable Interrupts
	di			; 10

	;
	; DIV
	;
	; Divide (16/8)
	div	yyA,y1		; 5F A1

	;
	; DIVWS
	;
	; Divide Word Stepped (32/16)
	divws	yy2,yy0,YY10	; 56 10 20
	divws	yy6,yy4,yy0	; 56 D0 64

	;
	; DJNZ
	;
	; Decrement And Jump If Not Zero
	djnz	y1,.		; 1A FE
	djnz	y2,.+N		; 2A 10

djnz:	djnz	y3,djnz		; 3A FE
	djnz	y4,djnz		; 4A FC
.ifdef	GLOBAL
	djnz	y3,.+M		; 3A 10
.endif

	;
	; DWJNZ
	;
	; Decrement Word And Jump If Not Zero
	dwjnz	YY90,.		; C6 90 FD
	dwjnz	yy4,.		; C6 D4 FD

	dwjnz	YY90,.+N	; C6 90 0F
	dwjnz	yy4,.+N		; C6 D4 0F

dwjnz:	dwjnz	YY90,dwjnz	; C6 90 FD
	dwjnz	yy4,dwjnz	; C6 D4 FA
.ifdef	GLOBAL
	dwjnz	YY90,.+M	; C6 90 0F
.endif

	;
	; EI
	;
	; Enable Global Interrupts
	ei			; 00

	;
	; EXT
	;
	; Sign Extend
	ext	YY40		; C6 41
	ext	yy6		; C6 D7

	;
	; HALT
	;
	; Halt
	halt			; BF 01

	;
	; INC, INCW
	;
	; Increment Register (Word)
	inc	Y30		; 50 30
	inc	y5		; 50 D5
	inc	(Y20)		; 51 20
	inc	(y3)		; 51 D3

	incw	YY40		; DF 40
	incw	yy8		; DF D8

	;
	; IRET
	;
	; Interrupt Return
	iret			; D3

	;
	; JP
	;
	; Unconditional Jump
	jp	(YY70)		; D4 70
	jp	(yy2)		; D4 D2

	jp	N		; 8D 00 12
	jp	NN		; 8D 56 78
.ifdef	GLOBAL
	jp	M		; 8D 00 12
	jp	MM		; 8D 56 78
.endif

	;
	; JPS
	;
	; Unconditional Jump Segment
	jps	(y1),(yy4)	; 73 C5 D1
	jps	(YA),(yy6)	; 73 C7 0A
	jps	N,NN		; 3F D2 56 78
.ifdef	GLOBAL
	jps	M,MM		; 3F D2 56 78
.endif

	;
	; JPcc
	;   f	0x0
	;   t	0x8
	;   c	0x7
	;   nc	0xF
	;   z	0x6
	;   nz	0xE
	;   pl	0xD
	;   mi	0x5
	;   ov	0x4
	;   nov	0xC
	;   eq	0x6
	;   ne	0xE
	;   ge	0x9
	;   lt	0x1
	;   gt	0xA
	;   le	0x2
	;   uge	0xF
	;   ult	0x7
	;   ugt	0xB
	;   ule	0x3
	;
	; Conditional Jump
	jpf	NN		; 0D 56 78
	jpt	N		; 8D 00 12
	jpc	NN		; 7D 56 78
	jpnc	N		; FD 00 12
	jpz	NN		; 6D 56 78
	jpnz	N		; ED 00 12
	jppl	NN		; DD 56 78
	jpmi	N		; 5D 00 12
	jpov	NN		; 4D 56 78
	jpnov	N		; CD 00 12
	jpeq	NN		; 6D 56 78
	jpne	N		; ED 00 12
	jpge	NN		; 9D 56 78
	jplt	N		; 1D 00 12
	jpgt	NN		; AD 56 78
	jple	N		; 2D 00 12
	jpuge	NN		; FD 56 78
	jpult	N		; 7D 00 12
	jpugt	NN		; BD 56 78
	jpule	N		; 3D 00 12

.ifdef	GLOBAL
	jpf	MM		; 0D 56 78
	jpt	M		; 8D 00 12
.endif

	;
	; Jrcc
	;   f	0x0
	;   t	0x8
	;   c	0x7
	;   nc	0xF
	;   z	0x6
	;   nz	0xE
	;   pl	0xD
	;   mi	0x5
	;   ov	0x4
	;   nov	0xC
	;   eq	0x6
	;   ne	0xE
	;   ge	0x9
	;   lt	0x1
	;   gt	0xA
	;   le	0x2
	;   uge	0xF
	;   ult	0x7
	;   ugt	0xB
	;   ule	0x3
	;
	; Conditional Jump Relative
	jrf	.		; 0B FE
	jrt	.		; 8B FE
	jrc	.		; 7B FE
	jrnc	.		; FB FE
	jrz	.		; 6B FE
	jrnz	.		; EB FE
	jrpl	.		; DB FE
	jrmi	.		; 5B FE
	jrov	.		; 4B FE
	jrnov	.		; CB FE
	jreq	.		; 6B FE
	jrne	.		; EB FE
	jrge	.		; 9B FE
	jrlt	.		; 1B FE
	jrgt	.		; AB FE
	jrle	.		; 2B FE
	jruge	.		; FB FE
	jrult	.		; 7B FE
	jrugt	.		; BB FE
	jrule	.		; 3B FE

jrcc:	jrt	jrcc		; 8B FE
	jrt	jrcc		; 8B FC
	jrt	.+N		; 8B 10
.ifdef	GLOBAL
	jrt	.+M		; 8B 10
.endif

	;
	; link. linku
	;
	; Link code
	link	YY20,#N		; D4 21 12
	linku	yy2,#N		; B6 D3 12
.ifdef	GLOBAL
	link	YY20,#M		; D4 21 12
	linku	yy2,#M		; B6 D3 12
.endif

	;
	; MUL
	;
	; Multiply (8x8)
	mul	yy0,y3		; 4F 03

	;
	; NOP
	;
	; No Operation
	nop			; FF

	;
	; PEA
	;
	; Push Effective Address on System Stack
	pea	N(YY10)		; BF 01 10 12
	pea	N(yyA)		; BF 01 DA 12
	pea	NN(YY20)	; BF 01 21 56 78
	pea	NN(yy4)		; BF 01 D5 56 78
.ifdef	GLOBAL
	pea	*M(YY10)	; BF 01 10 12		; Global -> Forced Short Form
	pea	*M(yyA)		; BF 01 DA 12		; Global -> Forced Short Form
	pea	M(YY10)		; BF 01 11 00 12	; Global -> Long Form
	pea	M(yyA)		; BF 01 DB 00 12	; Global -> Long Form
	pea	MM(YY20)	; BF 01 21 56 78
	pea	MM(yy4)		; BF 01 D5 56 78
.endif

	;
	; PEAU
	;
	; 	Push Effective Address on User Stack
	peau	N(YY10)		; BF 03 10 12
	peau	N(yyA)		; BF 03 DA 12
	peau	NN(YY20)	; BF 03 21 56 78
	peau	NN(yy4)		; BF 03 D5 56 78
.ifdef	GLOBAL
	peau	*M(YY10)	; BF 03 10 12		; Global -> Forced Short Form
	peau	*M(yyA)		; BF 03 DA 12		; Global -> Forced Short Form
	peau	M(YY10)		; BF 03 11 00 12	; Global -> Long Form
	peau	M(yyA)		; BF 03 DB 00 12	; Global -> Long Form
	peau	MM(YY20)	; BF 03 21 56 78
	peau	MM(yy4)		; BF 03 D5 56 78
.endif

	;
	; POP
	;
	; Pop Byte from System Stack
	pop	Y30		; 76 30
	pop	y4		; 76 D4
	pop	(Y50)		; 77 50
	pop	(y8)		; 77 D8

	;
	; POPU
	;
	; Pop Byte from User Stack
	popu	Y40		; 20 40
	popu	y6		; 20 D6
	popu	(Y60)		; 21 60
	popu	(y2)		; 21 D2

	;
	; POPUW
	;
	; Pop Word from User Stack
	popuw	YY90		; B7 90
	popuw	yy0		; B7 D0

	;
	; POPW
	;
	; Pop Word from System Stack
	popw	YY10		; 75 10
	popw	yyC		; 75 DC

	;
	; PUSH
	;
	; Push Byte on System Stack
	push	YA		; 66 0A
	push	yB		; 66 DB
	push	(Y8)		; F7 08
	push	(y4)		; F7 D4
	push	#N		; BF F1 12
.ifdef	GLOBAL
	push	#M		; BF F1 12
.endif

	;
	; PUSHU
	;
	; Push Byte on User Stack
	pushu	Y70		; 30 70
	pushu	y5		; 30 D5
	pushu	(Y60)		; 31 60
	pushu	(y3)		; 31 D3
	pushu	#N		; BF F3 12
.ifdef	GLOBAL
	pushu	#M		; BF F3 12
.endif

	;
	; PUSHUW
	;
	; Push Word on User Stack
	pushuw	YY20		; B6 20
	pushuw	yy8		; B6 D8
	pushuw	#NN		; BF C3 56 78
.ifdef GLOBAL
	pushuw	#MM		; BF C3 56 78
.endif
	;
	; PUSHW
	;
	; Push Word on System Stack
	pushw	YY40		; 74 40
	pushw	yy6		; 74 D6
	pushw	#NN		; BF C1 56 78
.ifdef	G:OBAL
	pushw	#MM		; BF C1 56 78
.endif

	;
	; RCF
	;
	; Reset Carry Flag
	rcf			; 11

	;
	; RET
	;
	; Return From Subroutine
	ret			; 46

	;
	; RETS
	;
	; Return From Far Subroutine
	rets			; F6 01

	;
	; RLC
	;
	; Rotate Left Through Carry
	rlc	YF		; B0 0F
	rlc	y9		; B0 D9
	rlc	(YE)		; B1 0E
	rlc	(y8)		; B1 D8

	;
	; RLCW
	;
	; Rotate Left Through Carry Word
	rlcw	YY40		; BF 40
	rlcw	yy6		; BF D6

	;
	; ROL
	;
	; Rotate Left Byte
	rol	YC		; A0 0C
	rol	yA		; A0 DA
	rol	(Y70)		; A1 70
	rol	(y4)		; A1 D4

	;
	; ROR
	;
	; Rotate Right Byte
	ror	Y0		; C0 00
	ror	y7		; C0 D7
	ror	(Y9)		; C1 09
	ror	(y7)		; C1 D7

	;
	; RRC
	;
	; Rotate Right Through Carry Byte
	rrc	Y30		; D0 30
	rrc	y2		; D0 D2
	rrc	(Y40)		; D1 40
	rrc	(y6)		; D1 D6

	;
	; RRCW
	;
	; Rotate Right Through Carry Word
	rrcw	YY80		; 36 80
	rrcw	yy4		; 36 D4

	; SCF
	;
	; Set Carry Flag
	scf			; 01

	;
	; SDM
	;
	; Set Data Memory
	sdm			; FE

	;
	; SLA
	;
	; Shift Left Arithmetic (Byte)
	sla	y3		; 42 33
	sla	Y30		; 44 30 30
	sla	(yy6)		; 73 46 D6

	;
	; SLAW
	;
	; Shift Left Arithmetic Word
	slaw	yy8		; 4E 88
	slaw	YY50		; 47 50 50
	slaw	(yy2)		; 4E D3 D3

	;
	; SPM
	;
	; Set Program Memory
	spm			; EE

	;
	; SPP
	;
	; Set Page Pointer
	spp	#N		; C7 4A
.ifdef	GLOBAL
	spp	#M		; C7 4A
.endif

	;
	; SRA
	;
	; Shift Right Arithmetic Byte
	sra	Y20		; E0 20
	sra	y7		; E0 D7
	sra	(Y40)		; E1 40
	sra	(y4)		; E1 D4

	;
	; SRAW
	;
	; Shift Right Arithmetic Word
	sraw	YY6		; 2F 06
	sraw	yyA		; 2F DA

	;
	; SRP
	;
	; Set Register Pointer (,0,1)
	srp	#N		; C7 90
	srp0	#N		; C7 94
	srp1	#N		; C7 95
.ifdef	GLOBAL
	srp	#M		; C7 90
	srp0	#M		; C7 94
	srp1	#M		; C7 95
.endif

	;
	; SWAP
	;
	; Swap Nibbles
	swap	Y10		; F0 10
	swap	yB		; F0 DB
	swap	(Y30)		; F1 30
	swap	(y7)		; F1 D7

	;
	; UNLINK
	;
	; Unlink code
	unlink	YY60		; 75 61
	unlink	yy4		; 75 D5

	;
	; UNLINKU
	;
	; Unlink code
	unlinku	YY40		; 87 41
	unlinku	yy8		; 87 D9

	;
	; WFI
	;
	; Wait For Interrupt
	wfi			; EF 01

	;
	; XCH
	;
	; Exchange Registers
	xch	Y1,Y80		; 16 80 01
	xch	Y2,y8		; 16 D8 02
	xch	y1,Y70		; 16 70 D1
	xch	y2,yA		; 16 DA D2


	.sbttl	Branching Range Extremes

btjfx:	btjf	r7.0,btjfx	; AF 17 FD
1$:	.blkb	125
	btjf	r0.4,1$		; AF 90 80
	btjf	r1.5,2$		; AF B1 7F
	.blkb	127
2$:

btjtx:	btjt	r7.0,btjtx	; AF 07 FD
1$:	.blkb	125
	btjt	r0.4,1$		; AF 80 80
	btjt	r1.5,2$		; AF A1 7F
	.blkb	127
2$:

cpjfix:	cpjfi	r0,(rr2),cpjfix	; 9F 20 FD
1$:	.blkb	125
	cpjfi	r4,(rr6),1$	; 9F 64 80
	cpjfi	r8,(rr10),2$	; 9F A8 7F
	.blkb	127
2$:

cpjtix:	cpjfi	r0,(rr2),cpjtix	; 9F 20 FD
1$:	.blkb	125
	cpjti	r4,(rr6),1$	; 9F 74 80
	cpjti	r8,(rr10),2$	; 9F B8 7F
	.blkb	127
2$:

djnzx:	djnz	r0,djnzx	; 0A FE
1$:	.blkb	126
	djnz	r2,1$		; 2A 80
	djnz	r4,2$		; 4A 7F
	.blkb	127
2$:

dwjnzx:	dwjnz	RR0,dwjnzx	; C6 00 FD
1$:	.blkb	125
	dwjnz	RR2,1$		; C6 02 80
	dwjnz	RR4,2$		; C6 04 7F
	.blkb	127
2$:

jrcx:	jrc	jrcx		; 7B FE
1$:	.blkb	126
	jrc	1$		; 7B 80
	jrc	2$		; 7B 7F
	.blkb	127
2$:


