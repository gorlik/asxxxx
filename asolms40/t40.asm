	.title	OKI OLMS-40 Series Test

	; .msm5840	default

	.globl	xa

	.ifdef	EXTRN
	  .define	_a	"+ xa"
	.else
	  .define	_a	""
	.endif

	nop			; 00
	ina			; 01

	ais	#0x0	_a	; 00
	ais	#0x1	_a	; 01
	ais	#0x2	_a	; 02
	ais	#0x3	_a	; 03
	ais	#0x4	_a	; 04
	ais	#0x5	_a	; 05
	ais	#0x6	_a	; 06
	ais	#0x7	_a	; 07
	ais	#0x8	_a	; 08
	ais	#0x9	_a	; 09
	ais	#0xA	_a	; 0A
	ais	#0xB	_a	; 0B
	ais	#0xC	_a	; 0C
	ais	#0xD	_a	; 0D
	ais	#0xE	_a	; 0E
	ais	#0xF	_a	; 0F

	dca			; 0F
	cla			; 10

	lai	#0x0	_a	; 10
	lai	#0x1	_a	; 11
	lai	#0x2	_a	; 12
	lai	#0x3	_a	; 13
	lai	#0x4	_a	; 14
	lai	#0x5	_a	; 15
	lai	#0x6	_a	; 16
	lai	#0x7	_a	; 17
	lai	#0x8	_a	; 18
	lai	#0x9	_a	; 19
	lai	#0xA	_a	; 1A
	lai	#0xB	_a	; 1B
	lai	#0xC	_a	; 1C
	lai	#0xD	_a	; 1D
	lai	#0xE	_a	; 1E
	lai	#0xF	_a	; 1F

	cll			; 20

	lli	#0x0	_a	; 20
	lli	#0x1	_a	; 21
	lli	#0x2	_a	; 22
	lli	#0x3	_a	; 23
	lli	#0x4	_a	; 24
	lli	#0x5	_a	; 25
	lli	#0x6	_a	; 26
	lli	#0x7	_a	; 27
	lli	#0x8	_a	; 28
	lli	#0x9	_a	; 29
	lli	#0xA	_a	; 2A
	lli	#0xB	_a	; 2B
	lli	#0xC	_a	; 2C
	lli	#0xD	_a	; 2D
	lli	#0xE	_a	; 2E
	lli	#0xF	_a	; 2F
	J	0x000F	_a	; 30 0F
	J	0x010E	_a	; 31 0E
	J	0x020D	_a	; 32 0D
	J	0x030C	_a	; 33 0C
	J	0x040B	_a	; 34 0B
	J	0x050A	_a	; 35 0A
	J	0x0609	_a	; 36 09
	J	0x0708	_a	; 37 08
	cal	0x0007	_a	; 38 07
	cal	0x0106	_a	; 39 06
	cal	0x0205	_a	; 3A 05
	cal	0x0304	_a	; 3B 04
	cal	0x0403	_a	; 3C 03
	cal	0x0502	_a	; 3D 02
	cal	0x0601	_a	; 3E 01
	cal	0x0700	_a	; 3F 00
	sc			; 40
	rc			; 41
	tc			; 42
	ja			; 43
	and			; 44
	or			; 45
	xor			; 46
	ral			; 47
	xch			; 48
	xa			; 49
	xl			; 4A
	xax			; 4B
	ac			; 4C
	acs			; 4D
	as			; 4E
				; 4F
	cao			; 50
				; 51
	di			; 52
	ei			; 53
	lla			; 54
	lal			; 55
	dcl			; 56
	inl			; 57
	lpa			; 58
	rt			; 59
	das			; 5A
				; 5B
	dcm			; 5C
	inm			; 5D
	cm			; 5E
				; 5F

	clh			; 60

	lhi	#0	_a	; 60
	lhi	#1	_a	; 61
	lhi	#2	_a	; 62
	lhi	#3	_a	; 63
	lhi	#4	_a	; 64
	lhi	#5	_a	; 65
	lhi	#6	_a	; 66
	lhi	#7	_a	; 67
	lti	#0xAA	_a	; 68 AA
	exp			; 69
	rth			; 6A
	rtl			; 6B
				; 6C
	hlt			; 6D
	dt			; 6E
	et			; 6F
	obs			; 70
	otd			; 71
	oa			; 72
	ob			; 73
	op			; 74
	oab			; 75
	opm			; 76
				; 77
				; 78
				; 79
	ia			; 7A
	ib			; 7B
	ik			; 7C
	iab			; 7D
	dct			; 7E
	ect			; 7F
	lwa			; 80
	lxa			; 81
	lya			; 82
	lza			; 83
	law			; 84
	lax			; 85
	lay			; 86
	laz			; 87
	inw			; 88
	inx			; 89
	iny			; 8A
	inz			; 8B
	dcw			; 8C
	dcx			; 8D
	dcy			; 8E
	dcz			; 8F

	si			; 90

	smi	#0	_a	; 90
	smi	#1	_a	; 91
	smi	#2	_a	; 92
	smi	#3	_a	; 93

	l			; 94

	lm	#0	_a	; 94
	lm	#1	_a	; 95
	lm	#2	_a	; 96
	lm	#3	_a	; 97

	x			; 98

	xm	#0	_a	; 98
	xm	#1	_a	; 99
	xm	#2	_a	; 9A
	xm	#3	_a	; 9B
	aws			; 9C
	axs			; 9D
	ays			; 9E
	azs			; 9F
	tab	#0	_a	; A0
	tab	#1	_a	; A1
	tab	#2	_a	; A2
	tab	#3	_a	; A3
	tmb	#0	_a	; A4
	tmb	#1	_a	; A5
	tmb	#2	_a	; A6
	tmb	#3	_a	; A7
	tkb	#0	_a	; A8
	tkb	#1	_a	; A9
	tkb	#2	_a	; AA
	tkb	#3	_a	; AB
	thb	#0	_a	; AC
	thb	#1	_a	; AD
	ttm			; AE
	ti			; AF
	spb	#0	_a	; B0
	spb	#1	_a	; B1
	spb	#2	_a	; B2
	spb	#3	_a	; B3
	rpb	#0	_a	; B4
	rpb	#1	_a	; B5
	rpb	#2	_a	; B6
	rpb	#3	_a	; B7
	smb	#0	_a	; B8
	smb	#1	_a	; B9
	smb	#2	_a	; BA
	smb	#3	_a	; BB
	rmb	#0	_a	; BC
	rmb	#1	_a	; BD
	rmb	#2	_a	; BE
	rmb	#3	_a	; BF

	.bndry	0x40

jc:	jc	jc+0x00	_a	; C0
	jc	jc+0x01	_a	; C1
	jc	jc+0x02	_a	; C2
	jc	jc+0x03	_a	; C3
	jc	jc+0x04	_a	; C4
	jc	jc+0x05	_a	; C5
	jc	jc+0x06	_a	; C6
	jc	jc+0x07	_a	; C7
	jc	jc+0x08	_a	; C8
	jc	jc+0x09	_a	; C9
	jc	jc+0x0A	_a	; CA
	jc	jc+0x0B	_a	; CB
	jc	jc+0x0C	_a	; CC
	jc	jc+0x0D	_a	; CD
	jc	jc+0x0E	_a	; CE
	jc	jc+0x0F	_a	; CF
	jc	jc+0x10	_a	; D0
	jc	jc+0x11	_a	; D1
	jc	jc+0x12	_a	; D2
	jc	jc+0x13	_a	; D3
	jc	jc+0x14	_a	; D4
	jc	jc+0x15	_a	; D5
	jc	jc+0x16	_a	; D6
	jc	jc+0x17	_a	; D7
	jc	jc+0x18	_a	; D8
	jc	jc+0x19	_a	; D9
	jc	jc+0x1A	_a	; DA
	jc	jc+0x1B	_a	; DB
	jc	jc+0x1C	_a	; DC
	jc	jc+0x1D	_a	; DD
	jc	jc+0x1E	_a	; DE
	jc	jc+0x1F	_a	; DF
	jc	jc+0x20	_a	; E0
	jc	jc+0x21	_a	; E1
	jc	jc+0x22	_a	; E2
	jc	jc+0x23	_a	; E3
	jc	jc+0x24	_a	; E4
	jc	jc+0x25	_a	; E5
	jc	jc+0x26	_a	; E6
	jc	jc+0x27	_a	; E7
	jc	jc+0x28	_a	; E8
	jc	jc+0x29	_a	; E9
	jc	jc+0x2A	_a	; EA
	jc	jc+0x2B	_a	; EB
	jc	jc+0x2C	_a	; EC
	jc	jc+0x2D	_a	; ED
	jc	jc+0x2E	_a	; EE
	jc	jc+0x2F	_a	; EF
	jc	jc+0x30	_a	; F0
	jc	jc+0x31	_a	; F1
	jc	jc+0x32	_a	; F2
	jc	jc+0x33	_a	; F3
	jc	jc+0x34	_a	; F4
	jc	jc+0x35	_a	; F5
	jc	jc+0x36	_a	; F6
	jc	jc+0x37	_a	; F7
	jc	jc+0x38	_a	; F8
	jc	jc+0x39	_a	; F9
	jc	jc+0x3A	_a	; FA
	jc	jc+0x3B	_a	; FB
	jc	jc+0x3C	_a	; FC
	jc	jc+0x3D	_a	; FD
	jc	jc+0x3E	_a	; FE
	jc	jc+0x3F	_a	; FF

.ifdef	BNDRY
	.bndry	0x40
	. = . + 0x37
1$:
	.bndry	0x40
	jc	1$		;		; Below Page Boundary
	. = . + 0x3E
	jc	2$		;		; Above Page Boundary
2$:
.endif

