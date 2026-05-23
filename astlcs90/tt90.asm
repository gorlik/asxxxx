	.title	Test of TLCS-90 assembler
	; see http://www.bitsavers.org/components/toshiba/_dataBook/1988_Toshiba_TLCS-48_90_8_Bit_Microcontroller.pdf

;*****-----*****-----*****-----*****-----*****
;
; Select Argument Types
;

.ifndef	LOCAL
	LOCAL = 0
.endif
.ifndef	EXTERNAL
	EXTERNAL = 0
.endif
.ifeq	LOCAL + EXTERNAL
	LOCAL = 1
.endif

;
;	LOCAL assembled code will have the same
;	values in both the .lst and the linked
;	.rst files.
;
;	EXTERNAL assembled code will have different
;	values for the .lst and linked .rst files.
;	The values shown will be the relocated
;	values of the .rst file.	
;
;*****-----*****-----*****-----*****-----*****

.if	LOCAL

	n	=	0x20
	k	=	0xFF20
	x	=	0x20
	y	=	0x20
	w	= 	0xFF21
	mn	=	0x0584
	vw	=	0x0685


	.sbttl	Single Byte Opcode Instructions

;*****-----*****-----*****-----*****-----*****
;
; From Toshiba 8-Bit Microcontroller TLCS 48/90 Data Book, 1988
;	Appendix B  Table of Machine Instruction Codes (1/4)
;

	nop				; 00
	halt				; 01
	di				; 02
	ei				; 03
					; 04
					; 05
					; 06
	incx	(k)			; 07 20
	ex	de,hl			; 08
	ex	af,af'			; 09
	exx				; 0A
	daa	a			; 0B
	rcf				; 0C
	scf				; 0D
	ccf				; 0E
	decx	(k)			; 0F 20

	cpl	a			; 10
	neg	a			; 11
	mul	hl,n			; 12 20
	div	hl,n			; 13 20
	add	ix,mn			; 14 84 05
	add	iy,mn			; 15 84 05
	add	sp,mn			; 16 84 05
	ldar	hl,pc+y			; 17 1E 00
	djnz	pc+y			; 18 1E
	djnz	bc,pc+y			; 19 1E
	jp	mn			; 1A 84 05
	jrl	pc+y			; 1B 1E 00
	call	mn			; 1C 84 05
	calr	pc+y			; 1D 1E 00
	ret				; 1E
	reti				; 1F

	ld	a,b			; 20
	ld	a,c			; 21
	ld	a,d			; 22
	ld	a,e			; 23
	ld	a,h			; 24
	ld	a,l			; 25
	ld	a,a			; 26
	ld	a,(k)			; 27 20
	ld	b,a			; 28
	ld	c,a			; 29
	ld	d,a			; 2A
	ld	e,a			; 2B
	ld	h,a			; 2C
	ld	l,a			; 2D
	ld	a,a			; 26		; first arg a
	ld	(k),a			; 2F 20

	ld	b,n			; 30 20
	ld	c,n			; 31 20
	ld	d,n			; 32 20
	ld	e,n			; 33 20
	ld	h,n			; 34 20
	ld	l,n			; 35 20
	ld	a,n			; 36 20
	ld	(w),n			; 37 21 20
	ld	bc,mn			; 38 84 05
	ld	de,mn			; 39 84 05
	ld	hl,mn			; 3A 84 05
					; 3B
	ld	ix,mn			; 3C 84 05
	ld	iy,mn			; 3D 84 05
	ld	sp,mn			; 3E 84 05
	ldw	(k),mn			; 3F 20 84 05

	ld	hl,bc			; 40
	ld	hl,de			; 41
	ld	hl,hl			; 42
					; 43
	ld	hl,ix			; 44
	ld	hl,iy			; 45
	ld	hl,sp			; 46
	ld	hl,(k)			; 47 20
	ld	bc,hl			; 48
	ld	de,hl			; 49
	ld	hl,hl			; 42
					; 4B
	ld	ix,hl			; 4C
	ld	iy,hl			; 4D
	ld	sp,hl			; 4E
	ld	(k),hl			; 4F 20

	push	bc			; 50
	push	de			; 51
	push	hl			; 52
					; 53
	push	ix			; 54
	push	iy			; 55
	push	af			; 56
					; 57
	pop	bc			; 58
	pop	de			; 59
	pop	hl			; 5A
					; 5B
	pop	ix			; 5C
	pop	iy			; 5D
	pop	af			; 5E
					; 5F

	add	a,(k)			; 60 20
	adc	a,(k)			; 61 20
	sub	a,(k)			; 62 20
	sbc	a,(k)			; 63 20
	and	a,(k)			; 64 20
	xor	a,(k)			; 65 20
	or	a,(k)			; 66 20
	cp	a,(k)			; 67 20
	add	a,n			; 68 20
	adc	a,n			; 69 20
	sub	a,n			; 6A 20
	sbc	a,n			; 6B 20
	and	a,n			; 6C 20
	xor	a,n			; 6D 20
	or	a,n			; 6E 20
	cp	a,n			; 6F 20

	add	hl,(k)			; 70 20
	adc	hl,(k)			; 71 20
	sub	hl,(k)			; 72 20
	sbc	hl,(k)			; 73 20
	and	hl,(k)			; 74 20
	xor	hl,(k)			; 75 20
	or	hl,(k)			; 76 20
	cp	hl,(k)			; 77 20
	add	hl,mn			; 78 84 05
	adc	hl,mn			; 79 84 05
	sub	hl,mn			; 7A 84 05
	sbc	hl,mn			; 7B 84 05
	and	hl,mn			; 7C 84 05
	xor	hl,mn			; 7D 84 05
	or	hl,mn			; 7E 84 05
	cp	hl,mn			; 7F 84 05

	inc	b			; 80
	inc	c			; 81
	inc	d			; 82
	inc	e			; 83
	inc	h			; 84
	inc	l			; 85
	inc	a			; 86
	inc	(k)			; 87 20
	dec	b			; 88
	dec	c			; 89
	dec	d			; 8A
	dec	e			; 8B
	dec	h			; 8C
	dec	l			; 8D
	dec	a			; 8E
	dec	(k)			; 8F 20

	inc	bc			; 90
	inc	de			; 91
	inc	hl			; 92
					; 93
	inc	ix			; 94
	inc	iy			; 95
	inc	sp			; 96
	incw	(k)			; 97 20
	dec	bc			; 98
	dec	de			; 99
	dec	hl			; 9A
					; 9B
	dec	ix			; 9C
	dec	iy			; 9D
	dec	sp			; 9E
	decw	(k)			; 9F 20
 
	rlca				; A0
	rrca				; A1
	rla				; A2
	rra				; A3
	slaa				; A4
	sraa				; A5
	slla				; A6
	srla				; A7
	bit	0,(k)			; A8 20
	bit	1,(k)			; A9 20
	bit	2,(k)			; AA 20
	bit	3,(k)			; AB 20
	bit	4,(k)			; AC 20
	bit	5,(k)			; AD 20
	bit	6,(k)			; AE 20
	bit	7,(k)			; AF 20

	res	0,(k)			; B0 20
	res	1,(k)			; B1 20
	res	2,(k)			; B2 20
	res	3,(k)			; B3 20
	res	4,(k)			; B4 20
	res	5,(k)			; B5 20
	res	6,(k)			; B6 20
	res	7,(k)			; B7 20
	set	0,(k)			; B8 20
	set	1,(k)			; B9 20
	set	2,(k)			; BA 20
	set	3,(k)			; BB 20
	set	4,(k)			; BC 20
	set	5,(k)			; BD 20
	set	6,(k)			; BE 20
	set	7,(k)			; BF 20

	jr	F,.			; C0 FE
	jr	LT,.			; C1 FE
	jr	LE,.			; C2 FE
	jr	ULE,.			; C3 FE
	jr	PE,.			; C4 FE
	jr	M,.			; C5 FE
	jr	Z,.			; C6 FE
	jr	C,.			; C7 FE
	jr	T,.			; C8 FE
	jr	GE,.			; C9 FE
	jr	GT,.			; CA FE
	jr	UGT,.			; CB FE
	jr	PO,.			; CC FE
	jr	P,.			; CD FE
	jr	NZ,.			; CE FE
	jr	NC,.			; CF FE

					; D0 -> DF  -  NOT DEFINED

					; E0 -> E7  -  Page 2
					; E8 -> EF  -  Page 3

					; F0 -> F3  -  Page 2
					; F4 -> F7  -  Page 3
					; F8 -> FE  -  Page 4
	swi				; FF


	.sbttl	Page 2 Instructions (F8 -> FE Prefix)

;*****-----*****-----*****-----*****-----*****
;
; From Toshiba 8-Bit Microcontroller TLCS 48/90 Data Book, 1988
;	Appendix B  Table of Machine Instruction Codes (2/4)
;
					;    00 -> 0F

					;    10
					;    11
	mul	hl,b			; F8 12
	div	hl,c			; F9 13
	add	ix,bc			; F8 14
	add	iy,de			; F9 15
	add	sp,ix			; FC 16
					;    17
	tset	0,b			; F8 18
	tset	1,c			; F9 19
	tset	2,d			; FA 1A
	tset	3,e			; FB 1B
	tset	4,h			; FC 1C
	tset	5,l			; FD 1D
	tset	6,a			; FE 1E
	tset	7,b			; F8 1F

					;    20 -> 2F

	ld	b,c			; F9 30
	ld	c,d			; FA 31
	ld	d,e			; FB 32
	ld	e,h			; FC 33
	ld	h,l			; FD 34
	ld	l,b			; F8 35
	ld	a,c			; 21
					;    37
	ld	bc,de			; F9 38
	ld	de,hl			; 49
	ld	hl,ix			; 44
					;    3B
	ld	ix,iy			; FD 3C
	ld	iy,sp			; FE 3D
	ld	sp,bc			; F8 3E
					;    3F

					;    40 -> 4F

					;    50 -> 57
	ldi				; FE 58
	ldir				; FE 59
	ldd				; FE 5A
	lddr				; FE 5B
	cpi				; FE 5C
	cpir				; FE 5D
	cpd				; FE 5E
	cpdr				; FE 5F

	add	a,b			; F8 60
	adc	a,c			; F9 61
	sub	a,d			; FA 62
	sbc	a,e			; FB 63
	and	a,h			; FC 64
	xor	a,l			; FD 65
	or	a,b			; F8 66
	cp	a,c			; F9 67
	add	b,n			; F8 68 20
	adc	c,n			; F9 69 20
	sub	d,n			; FA 6A 20
	sbc	e,n			; FB 6B 20
	and	h,n			; FC 6C 20
	xor	l,n			; FD 6D 20
	or	b,n			; F8 6E 20
	cp	c,n			; F9 6F 20

	add	hl,bc			; F8 70
	adc	hl,de			; F9 71
	sub	hl,hl			; FA 72
	sbc	hl,ix			; FC 73
	and	hl,iy			; FD 74
	xor	hl,sp			; FE 75
	or	hl,bc			; F8 76
	cp	hl,de			; F9 77
					;    78 -> 7F

					;    80 -> 8F
					;    90 -> 9F

	rlc	b			; F8 A0
	rrc	c			; F9 A1
	rl	d			; FA A2
	rr	e			; FB A3
	sla	h			; FC A4
	sra	l			; FD A5
	sll	a			; FE A6
	srl	b			; F8 A7
	bit	0,b			; F8 A8
	bit	1,c			; F9 A9
	bit	2,d			; FA AA
	bit	3,e			; FB AB
	bit	4,h			; FC AC
	bit	5,l			; FD AD
	bit	6,a			; FE AE
	bit	7,b			; F8 AF

	res	0,b			; F8 B0
	res	1,c			; F9 B1
	res	2,d			; FA B2
	res	3,e			; FB B3
	res	4,h			; FC B4
	res	5,l			; FD B5
	res	6,a			; FE B6
	res	7,b			; F8 B7
	set	0,b			; F8 B8
	set	1,c			; F9 B9
	set	2,d			; FA BA
	set	3,e			; FB BB
	set	4,h			; FC BC
	set	5,l			; FD BD
	set	6,a			; FE BE
	set	7,b			; F8 BF

					;    C0 -> CF

	ret	f			; FE D0
	ret	lt			; FE D1
	ret	le			; FE D2
	ret	ule			; FE D3
	ret	pe			; FE D4
	ret	m			; FE D5
	ret	z			; FE D6
	ret	c			; FE D7
	ret	t			; FE D8
	ret	ge			; FE D9
	ret	gt			; FE DA
	ret	ugt			; FE DB
	ret	po			; FE DC
	ret	p			; FE DD
	ret	nz			; FE DE
	ret	nc			; FE DF

					;    E0 -> EF
					;    F0 -> FF


	.sbttl	Page 3/4 Instructions (E0 -> E7 or F0 -> F3 Prefix)

;*****-----*****-----*****-----*****-----*****
;
; From Toshiba 8-Bit Microcontroller TLCS 48/90 Data Book, 1988
;	Appendix B  Table of Machine Instruction Codes (3/4 and 4/4))
;
;	Note: Page 4/4 Byte Codes 0x38->0x3B and 0x3C->0x3E are invalid.
;

					;    00 -> 0F

	rld	(de)			; E1 10
	rrd	(de)			; E1 11

	rld	(iy+x)			; F1 20 10
	rrd	(iy+x)			; F1 20 11

	rld	(hl+a)			; F3 10
	rrd	(hl+a)			; F3 11

	rld	(mn)			; E3 84 05 10
	rrd	(mn)			; E3 84 05 11

	rld	(k)			; E7 20 10
	rrd	(k)			; E7 20 11

	mul	hl,(de)			; E1 12
	div	hl,(bc)			; E0 13

	mul	hl,(iy+x)		; F1 20 12
	div	hl,(sp+x)		; F2 20 13

	mul	hl,(hl+a)		; F3 12
	div	hl,(hl+a)		; F3 13

	mul	hl,(mn)			; E3 84 05 12
	div	hl,(mn)			; E3 84 05 13

	mul	hl,(k)			; E7 20 12
	div	hl,(k)			; E7 20 13

	add	ix,(bc)			; E0 14
	add	iy,(de)			; E1 15
	add	sp,(hl)			; E2 16

	add	ix,(iy+x)		; F1 20 14
	add	iy,(sp+x)		; F2 20 15
	add	sp,(ix+x)		; F0 20 16

	add	ix,(hl+a)		; F3 14
	add	iy,(hl+a)		; F3 15
	add	sp,(hl+a)		; F3 16

	add	ix,(mn)			; E3 84 05 14
	add	iy,(mn)			; E3 84 05 15
	add	sp,(mn)			; E3 84 05 16

					;    17

	tset	0,(sp)			; E6 18
	tset	1,(iy)			; E5 19
	tset	2,(ix)			; E4 1A
	tset	3,(hl)			; E2 1B
	tset	4,(de)			; E1 1C
	tset	5,(bc)			; E0 1D
	tset	6,(sp)			; E6 1E
	tset	7,(iy)			; E5 1F

	tset	0,(ix+x)		; F0 20 18
	tset	1,(iy+x)		; F1 20 19
	tset	2,(sp+x)		; F2 20 1A
	tset	3,(hl+a)		; F3 1B
	tset	4,(ix+x)		; F0 20 1C
	tset	5,(iy+x)		; F1 20 1D
	tset	6,(sp+x)		; F2 20 1E
	tset	7,(hl+a)		; F3 1F

	tset	0,(mn)			; E3 84 05 18
	tset	1,(mn)			; E3 84 05 19
	tset	2,(mn)			; E3 84 05 1A
	tset	3,(mn)			; E3 84 05 1B
	tset	4,(mn)			; E3 84 05 1C
	tset	5,(mn)			; E3 84 05 1D
	tset	6,(mn)			; E3 84 05 1E
	tset	7,(mn)			; E3 84 05 1F

	tset	0,(k)			; E7 20 18
	tset	1,(k)			; E7 20 19
	tset	2,(k)			; E7 20 1A
	tset	3,(k)			; E7 20 1B
	tset	4,(k)			; E7 20 1C
	tset	5,(k)			; E7 20 1D
	tset	6,(k)			; E7 20 1E
	tset	7,(k)			; E7 20 1F

	ld	(de),b			; E9 20
	ld	(hl),c			; EA 21
	ld	(ix),d			; EC 22
	ld	(iy),e			; ED 23
	ld	(sp),h			; EE 24
	ld	(bc),l			; E8 25
	ld	(de),a			; E9 26
					;    27

	ld	(ix+x),b		; F4 20 20
	ld	(iy+x),c		; F5 20 21
	ld	(sp+x),d		; F6 20 22
	ld	(ix+x),e		; F4 20 23
	ld	(iy+x),h		; F5 20 24
	ld	(sp+x),l		; F6 20 25
	ld	(ix+x),a		; F4 20 26
					;       27

	ld	(hl+a),b		; F7 20
	ld	(hl+a),c		; F7 21
	ld	(hl+a),d		; F7 22
	ld	(hl+a),e		; F7 23
	ld	(hl+a),h		; F7 24
	ld	(hl+a),l		; F7 25
	ld	(hl+a),a		; F7 26
					;    27

	ld	(mn),b			; EB 84 05 20
	ld	(mn),c			; EB 84 05 21
	ld	(mn),d			; EB 84 05 22
	ld	(mn),e			; EB 84 05 23
	ld	(mn),h			; EB 84 05 24
	ld	(mn),l			; EB 84 05 25
	ld	(mn),a			; EB 84 05 26
					;          27

	ld	(k),b			; EF 20 20
	ld	(k),c			; EF 20 21
	ld	(k),d			; EF 20 22
	ld	(k),e			; EF 20 23
	ld	(k),h			; EF 20 24
	ld	(k),l			; EF 20 25
	ld	(k),a			; 2F 20
					;       27

	ld	b,(sp)			; E6 28
	ld	c,(iy)			; E5 29
	ld	d,(ix)			; E4 2A
	ld	e,(hl)			; E2 2B
	ld	h,(de)			; E1 2C
	ld	l,(bc)			; E0 2D
	ld	a,(sp)			; E6 2E
					;    2F

	ld	b,(ix+x)		; F0 20 28
	ld	c,(iy+x)		; F1 20 29
	ld	d,(sp+x)		; F2 20 2A
	ld	e,(hl+a)		; F3 2B
	ld	h,(ix+x)		; F0 20 2C
	ld	l,(iy+x)		; F1 20 2D
	ld	a,(sp+x)		; F2 20 2E
					;       2F

	ld	b,(mn)			; E3 84 05 28
	ld	c,(mn)			; E3 84 05 29
	ld	d,(mn)			; E3 84 05 2A
	ld	e,(mn)			; E3 84 05 2B
	ld	h,(mn)			; E3 84 05 2C
	ld	l,(mn)			; E3 84 05 2D
	ld	a,(mn)			; E3 84 05 2E
					;          2F

	ld	b,(k)			; EF 20 28
	ld	c,(k)			; EF 20 29
	ld	d,(k)			; EF 20 2A
	ld	e,(k)			; EF 20 2B
	ld	h,(k)			; EF 20 2C
	ld	l,(k)			; EF 20 2D
	ld	a,(k)			; 27 20
					;       2F

					;    30 -> 36
	ld	(bc),n			; E8 37 20
	ld	(iy+x),n		; F5 20 37 20
	ld	(hl+a),n		; F7 37 20
	ld	(mn),n			; EB 84 05 37 20
	ld	(w),n			; 37 21 20
					; 38 -> 3E
	ldw	(bc),mn			; E8 3F 84 05
	ldw	(iy+x),mn		; F5 20 3F 84 05
	ldw	(hl+a),mn		; F7 3F 84 05
	ldw	(vw),mn			; EB 85 06 3F 84 05
	ldw	(w),mn			; 3F 21 84 05

	ld	(de),bc			; E9 40
	ld	(ix+x),de		; F4 20 41
	ld	(hl+a),hl		; F7 42
					;    43
	ld	(mn),ix			; EB 84 05 44
	ld	(k),iy			; EF 20 45
	ld	(bc),sp			; E8 46
					;    47

	ld	bc,(sp)			; E6 48
	ld	de,(iy)			; E5 49
	ld	hl,(ix)			; E4 4A
					;    4B
	ld	ix,(hl)			; E2 4C
	ld	iy,(de)			; E1 4D
	ld	sp,(bc)			; E0 4E
					;    4F

	ld	bc,(ix+x)		; F0 20 48
	ld	de,(iy+x)		; F1 20 49
	ld	hl,(sp+x)		; F2 20 4A
					;       4B
	ld	ix,(ix+x)		; F0 20 4C
	ld	iy,(iy+x)		; F1 20 4D
	ld	sp,(sp+x)		; F2 20 4E
					;       4F

	ld	bc,(hl+a)		; F3 48
	ld	de,(hl+a)		; F3 49
	ld	hl,(hl+a)		; F3 4A
					;    4B
	ld	ix,(hl+a)		; F3 4C
	ld	iy,(hl+a)		; F3 4D
	ld	sp,(hl+a)		; F3 4E
					;    4F

	ld	bc,(mn)			; E3 84 05 48
	ld	de,(mn)			; E3 84 05 49
	ld	hl,(mn)			; E3 84 05 4A
					;          4B
	ld	ix,(mn)			; E3 84 05 4C
	ld	iy,(mn)			; E3 84 05 4D
	ld	sp,(mn)			; E3 84 05 4E
					;          4F

	ld	bc,(k)			; E7 20 48
	ld	de,(k)			; E7 20 49
	ld	hl,(k)			; 47 20
					;       4B
	ld	ix,(k)			; E7 20 4C
	ld	iy,(k)			; E7 20 4D
	ld	sp,(k)			; E7 20 4E
					;       4F

	ex	(de),bc			; E1 50
	ex	(hl),de			; E2 51
	ex	(ix),hl			; E4 52
					;    53
	ex	(iy),ix			; E5 54
	ex	(sp),iy			; E6 55
	ex	(bc),sp			; E0 56
					;    57

	ex	(ix+x),bc		; F0 20 50
	ex	(iy+x),de		; F1 20 51
	ex	(sp+x),hl		; F2 20 52
					;       53
	ex	(iy+x),ix		; F1 20 54
	ex	(ix+x),iy		; F0 20 55
	ex	(iy+x),sp		; F1 20 56
					;       57

	ex	(hl+a),bc		; F3 50
	ex	(hl+a),de		; F3 51
	ex	(hl+a),hl		; F3 52
					; F3 53
	ex	(hl+a),ix		; F3 54
	ex	(hl+a),iy		; F3 55
	ex	(hl+a),sp		; F3 56
					; F3 57

	ex	(mn),bc			; E3 84 05 50
	ex	(mn),de			; E3 84 05 51
	ex	(mn),hl			; E3 84 05 52
					;          53
	ex	(mn),ix			; E3 84 05 54
	ex	(mn),iy			; E3 84 05 55
	ex	(mn),sp			; E3 84 05 56
					;          57

	ex	(k),bc			; E7 20 50
	ex	(k),de			; E7 20 51
	ex	(k),hl			; E7 20 52
					;       53
	ex	(k),ix			; E7 20 54
	ex	(k),iy			; E7 20 55
	ex	(k),sp			; E7 20 56
					;       57

					; 58 -> 5F

	add	a,(sp)			; E6 60
	adc	a,(iy)			; E5 61
	sub	a,(ix)			; E4 62
	sbc	a,(hl)			; E2 63
	and	a,(de)			; E1 64
	xor	a,(bc)			; E0 65
	or	a,(sp)			; E6 66
	cp	a,(iy)			; E5 67

	add	a,(sp+x)		; F2 20 60
	adc	a,(iy+x)		; F1 20 61
	sub	a,(ix+x)		; F0 20 62
	sbc	a,(sp+x)		; F2 20 63
	and	a,(iy+x)		; F1 20 64
	xor	a,(ix+x)		; F0 20 65
	or	a,(sp+x)		; F2 20 66
	cp	a,(iy+x)		; F1 20 67

	add	a,(hl+a)		; F3 60
	adc	a,(hl+a)		; F3 61
	sub	a,(hl+a)		; F3 62
	sbc	a,(hl+a)		; F3 63
	and	a,(hl+a)		; F3 64
	xor	a,(hl+a)		; F3 65
	or	a,(hl+a)		; F3 66
	cp	a,(hl+a)		; F3 67

	add	a,(mn)			; E3 84 05 60
	adc	a,(mn)			; E3 84 05 61
	sub	a,(mn)			; E3 84 05 62
	sbc	a,(mn)			; E3 84 05 63
	and	a,(mn)			; E3 84 05 64
	xor	a,(mn)			; E3 84 05 65
	or	a,(mn)			; E3 84 05 66
	cp	a,(mn)			; E3 84 05 67

	add	(sp),n			; EE 68 20
	adc	(iy),n			; ED 69 20
	sub	(ix),n			; EC 6A 20
	sbc	(hl),n			; EA 6B 20
	and	(de),n			; E9 6C 20
	xor	(bc),n			; E8 6D 20
	or	(sp),n			; EE 6E 20
	cp	(iy),n			; ED 6F 20

	add	(sp+x),n		; F6 20 68 20
	adc	(iy+x),n		; F5 20 69 20
	sub	(ix+x),n		; F4 20 6A 20
	sbc	(sp+x),n		; F6 20 6B 20
	and	(iy+x),n		; F5 20 6C 20
	xor	(ix+x),n		; F4 20 6D 20
	or	(sp+x),n		; F6 20 6E 20
	cp	(iy+x),n		; F5 20 6F 20

	add	(hl+a),n		; F7 68 20
	adc	(hl+a),n		; F7 69 20
	sub	(hl+a),n		; F7 6A 20
	sbc	(hl+a),n		; F7 6B 20
	and	(hl+a),n		; F7 6C 20
	xor	(hl+a),n		; F7 6D 20
	or	(hl+a),n		; F7 6E 20
	cp	(hl+a),n		; F7 6F 20

	add	(mn),n			; EB 84 05 68 20
	adc	(mn),n			; EB 84 05 69 20
	sub	(mn),n			; EB 84 05 6A 20
	sbc	(mn),n			; EB 84 05 6B 20
	and	(mn),n			; EB 84 05 6C 20
	xor	(mn),n			; EB 84 05 6D 20
	or	(mn),n			; EB 84 05 6E 20
	cp	(mn),n			; EB 84 05 6F 20

	add	(w),n			; EF 21 68 20
	adc	(w),n			; EF 21 69 20
	sub	(w),n			; EF 21 6A 20
	sbc	(w),n			; EF 21 6B 20
	and	(w),n			; EF 21 6C 20
	xor	(w),n			; EF 21 6D 20
	or	(w),n			; EF 21 6E 20
	cp	(w),n			; EF 21 6F 20

	add	hl,(sp)			; E6 70
	adc	hl,(iy)			; E5 71
	sub	hl,(ix)			; E4 72
	sbc	hl,(hl)			; E2 73
	and	hl,(de)			; E1 74
	xor	hl,(bc)			; E0 75
	or	hl,(sp)			; E6 76
	cp	hl,(iy)			; E5 77

	add	hl,(sp+x)		; F2 20 70
	adc	hl,(iy+x)		; F1 20 71
	sub	hl,(ix+x)		; F0 20 72
	sbc	hl,(sp+x)		; F2 20 73
	and	hl,(iy+x)		; F1 20 74
	xor	hl,(ix+x)		; F0 20 75
	or	hl,(sp+x)		; F2 20 76
	cp	hl,(iy+x)		; F1 20 77

	add	hl,(hl+a)		; F3 70
	adc	hl,(hl+a)		; F3 71
	sub	hl,(hl+a)		; F3 72
	sbc	hl,(hl+a)		; F3 73
	and	hl,(hl+a)		; F3 74
	xor	hl,(hl+a)		; F3 75
	or	hl,(hl+a)		; F3 76
	cp	hl,(hl+a)		; F3 77

	add	hl,(mn)			; E3 84 05 70
	adc	hl,(mn)			; E3 84 05 71
	sub	hl,(mn)			; E3 84 05 72
	sbc	hl,(mn)			; E3 84 05 73
	and	hl,(mn)			; E3 84 05 74
	xor	hl,(mn)			; E3 84 05 75
	or	hl,(mn)			; E3 84 05 76
	cp	hl,(mn)			; E3 84 05 77

					;    78 -> 7F

					;    80 -> 86

	inc	(bc)			; E0 87
	inc	(ix+x)			; F0 20 87
	inc	(hl+a)			; F3 87
	inc	(mn)			; E3 84 05 87

					;    88 -> 8E

	dec	(de)			; E1 8F
	dec	(iy+x)			; F1 20 8F
	dec	(hl+a)			; F3 8F
	dec	(mn)			; E3 84 05 8F

					;    90 -> 96

	incw	(bc)			; E0 97
	incw	(ix+x)			; F0 20 97
	incw	(hl+a)			; F3 97
	incw	(mn)			; E3 84 05 97

					;    98 -> 9E

	decw	(de)			; E1 9F
	decw	(iy+x)			; F1 20 9F
	decw	(hl+a)			; F3 9F
	decw	(mn)			; E3 84 05 9F

	rlc	(sp)			; E6 A0
	rrc	(iy)			; E5 A1
	rl	(ix)			; E4 A2
	rr	(hl)			; E2 A3
	sla	(de)			; E1 A4
	sra	(bc)			; E0 A5
	sll	(sp)			; E6 A6
	srl	(iy)			; E5 A7

	rlc	(ix+x)			; F0 20 A0
	rrc	(iy+x)			; F1 20 A1
	rl	(sp+x)			; F2 20 A2
	rr	(hl+a)			; F3 A3
	sla	(ix+x)			; F0 20 A4
	sra	(iy+x)			; F1 20 A5
	sll	(sp+x)			; F2 20 A6
	srl	(hl+a)			; F3 A7

	rlc	(mn)			; E3 84 05 A0
	rrc	(mn)			; E3 84 05 A1
	rl	(mn)			; E3 84 05 A2
	rr	(mn)			; E3 84 05 A3
	sla	(mn)			; E3 84 05 A4
	sra	(mn)			; E3 84 05 A5
	sll	(mn)			; E3 84 05 A6
	srl	(mn)			; E3 84 05 A7

	rlc	(k)			; E7 20 A0
	rrc	(k)			; E7 20 A1
	rl	(k)			; E7 20 A2
	rr	(k)			; E7 20 A3
	sla	(k)			; E7 20 A4
	sra	(k)			; E7 20 A5
	sll	(k)			; E7 20 A6
	srl	(k)			; E7 20 A7

	bit	0,(sp)			; E6 A8
	bit	1,(iy)			; E5 A9
	bit	2,(ix)			; E4 AA
	bit	3,(hl)			; E2 AB
	bit	4,(de)			; E1 AC
	bit	5,(bc)			; E0 AD
	bit	6,(sp)			; E6 AE
	bit	7,(iy)			; E5 AF

	bit	0,(ix+x)		; F0 20 A8
	bit	1,(iy+x)		; F1 20 A9
	bit	2,(sp+x)		; F2 20 AA
	bit	3,(hl+a)		; F3 AB
	bit	4,(ix+x)		; F0 20 AC
	bit	5,(iy+x)		; F1 20 AD
	bit	6,(sp+x)		; F2 20 AE
	bit	7,(hl+a)		; F3 AF

	bit	0,(mn)			; E3 84 05 A8
	bit	1,(mn)			; E3 84 05 A9
	bit	2,(mn)			; E3 84 05 AA
	bit	3,(mn)			; E3 84 05 AB
	bit	4,(mn)			; E3 84 05 AC
	bit	5,(mn)			; E3 84 05 AD
	bit	6,(mn)			; E3 84 05 AE
	bit	7,(mn)			; E3 84 05 AF

	res	0,(sp)			; E6 B0
	res	1,(iy)			; E5 B1
	res	2,(ix)			; E4 B2
	res	3,(hl)			; E2 B3
	res	4,(de)			; E1 B4
	res	5,(bc)			; E0 B5
	res	6,(sp)			; E6 B6
	res	7,(iy)			; E5 B7

	res	0,(ix+x)		; F0 20 B0
	res	1,(iy+x)		; F1 20 B1
	res	2,(sp+x)		; F2 20 B2
	res	3,(hl+a)		; F3 B3
	res	4,(ix+x)		; F0 20 B4
	res	5,(iy+x)		; F1 20 B5
	res	6,(sp+x)		; F2 20 B6
	res	7,(hl+a)		; F3 B7

	res	0,(mn)			; E3 84 05 B0
	res	1,(mn)			; E3 84 05 B1
	res	2,(mn)			; E3 84 05 B2
	res	3,(mn)			; E3 84 05 B3
	res	4,(mn)			; E3 84 05 B4
	res	5,(mn)			; E3 84 05 B5
	res	6,(mn)			; E3 84 05 B6
	res	7,(mn)			; E3 84 05 B7

	set	0,(sp)			; E6 B8
	set	1,(iy)			; E5 B9
	set	2,(ix)			; E4 BA
	set	3,(hl)			; E2 BB
	set	4,(de)			; E1 BC
	set	5,(bc)			; E0 BD
	set	6,(sp)			; E6 BE
	set	7,(iy)			; E5 BF

	set	0,(ix+x)		; F0 20 B8
	set	1,(iy+x)		; F1 20 B9
	set	2,(sp+x)		; F2 20 BA
	set	3,(hl+a)		; F3 BB
	set	4,(ix+x)		; F0 20 BC
	set	5,(iy+x)		; F1 20 BD
	set	6,(sp+x)		; F2 20 BE
	set	7,(hl+a)		; F3 BF

	set	0,(mn)			; E3 84 05 B8
	set	1,(mn)			; E3 84 05 B9
	set	2,(mn)			; E3 84 05 BA
	set	3,(mn)			; E3 84 05 BB
	set	4,(mn)			; E3 84 05 BC
	set	5,(mn)			; E3 84 05 BD
	set	6,(mn)			; E3 84 05 BE
	set	7,(mn)			; E3 84 05 BF

	jp	f,bc			; E8 C0
	jp	lt,ix+x			; F4 20 C1
	jp	le,hl+a			; F7 C2
	jp	ule,mn			; EB 84 05 C3
	jp	pe,de			; E9 C4
	jp	m,iy+x			; F5 20 C5
	jp	z,hl+a			; F7 C6
	jp	c,mn			; EB 84 05 C7
	jp	t,hl			; EA C8
	jp	ge,sp+x			; F6 20 C9
	jp	gt,hl+a			; F7 CA
	jp	ugt,mn			; EB 84 05 CB
	jp	po,ix			; EC CC
	jp	p,ix+x			; F4 20 CD
	jp	nz,hl+a			; F7 CE
	jp	nc,mn			; EB 84 05 CF

	call	f,bc			; E8 D0
	call	lt,ix+x			; F4 20 D1
	call	le,hl+a			; F7 D2
	call	ule,mn			; EB 84 05 D3
	call	pe,de			; E9 D4
	call	m,iy+x			; F5 20 D5
	call	z,hl+a			; F7 D6
	call	c,mn			; EB 84 05 D7
	call	t,hl			; EA D8
	call	ge,sp+x			; F6 20 D9
	call	gt,hl+a			; F7 DA
	call	ugt,mn			; EB 84 05 DB
	call	po,ix			; EC DC
	call	p,ix+x			; F4 20 DD
	call	nz,hl+a			; F7 DE
	call	nc,mn			; EB 84 05 DF

					; E0 -> EF

					; F0 -> FF
.endif


	.sbttl	External Arguments

.if EXTERNAL

;*****-----*****-----*****-----*****-----*****
;
;	PC+d Instructions
;
	.globl	djnz,  jr,  jrl,  calr,  ldar
	.globl	djnzx, jrx, jrlx, calrx, ldarx

1$:	djnz	pc			; 18 FE
	djnz	.			; 18 FE
	djnz	1$			; 18 FA
djnz:	djnz	djnz			; 18 FE
	djnz	djnzx			; 18 FE

2$:	jr	pc			; C8 FE
	jr	.			; C8 FE
	jr	2$			; C8 FA
jr:	jr	jr			; C8 FE
	jr	jrx			; C8 FE

3$:	jrl	pc			; 1B FE FF
	jrl	.			; 1B FE FF
	jrl	3$			; 1B F8 FF
jrl:	jrl	jrl			; 1B FE FF
	jrl	jrlx			; 1B FE FF

4$:	calr	pc			; 1D FE FF
	calr	.			; 1D FE FF
	calr	4$			; 1D F8 FF
calr:	calr	calr			; 1D FE FF
	calr	calrx			; 1D FE FF

5$:	ldar	hl,pc			; 17 FE FF
	ldar	hl,.			; 17 FE FF
	ldar	hl,5$			; 17 F8 FF
ldar:	ldar	hl,ldar			; 17 FE FF
	ldar	hl,ldarx		; 17 FE FF


	.sbttl	Direct Page Tests With Local And External Arguments

;*****-----*****-----*****-----*****-----*****
;
;	The direct page addresses are 0xFF00 -> 0xFFFF.
;
;	The TLCS90 assembler syntax for direct addressing
;	is (k) where k is 0x0000->0x00FF or 0xFF00->0xFFFF
;	for absolute numbers. if n is an external global then
;	by default the assembled form becomes (mn), a 16-bit
;	address.
;

	.globl	xk, xw
	.globl	xn, xx, xy1, xy2, xmn, xvw

	.define	n	^/0x20 + xn/
	.define	k	^/* 0xFF20 + xk/; external - force direct page
	.define	x	^/0x20 + xx/
	.define	pc	^//		; PC relative global
	.define	y1	^/0x1E + xy1/	; PC relative global
	.define	y2	^/0x1E + xy2/	; PC relative global
	.define	w	^/* 0xFF21 + xw/; external - force direct page
	.define	mn	^/0x0584 + xmn/
	.define	vw	^/0x0685 + xvw/



	.sbttl	Single Byte Opcode Instructions

;*****-----*****-----*****-----*****-----*****
;
; From Toshiba 8-Bit Microcontroller TLCS 48/90 Data Book, 1988
;	Appendix B  Table of Machine Instruction Codes (1/4)
;

	nop				; 00
	halt				; 01
	di				; 02
	ei				; 03
					; 04
					; 05
					; 06
	incx	(k)			; 07 20
	ex	de,hl			; 08
	ex	af,af'			; 09
	exx				; 0A
	daa	a			; 0B
	rcf				; 0C
	scf				; 0D
	ccf				; 0E
	decx	(k)			; 0F 20

	cpl	a			; 10
	neg	a			; 11
	mul	hl,n			; 12 20
	div	hl,n			; 13 20
	add	ix,mn			; 14 84 05
	add	iy,mn			; 15 84 05
	add	sp,mn			; 16 84 05
	ldar	hl,mn			; 17 23 05	; relative to an absolute address
djnz1::	djnz	pc+y1			; 18 1E
djnz2::	djnz	bc,pc+y2		; 19 1E
	jp	mn			; 1A 84 05
	jrl	mn			; 1B 19 05	; relative to an absolute address
	call	mn			; 1C 84 05
	calr	mn			; 1D 13 05	; relative to an absolute address
	ret				; 1E
	reti				; 1F

	ld	a,b			; 20
	ld	a,c			; 21
	ld	a,d			; 22
	ld	a,e			; 23
	ld	a,h			; 24
	ld	a,l			; 25
	ld	a,a			; 26
	ld	a,(k)			; 27 20
	ld	b,a			; 28
	ld	c,a			; 29
	ld	d,a			; 2A
	ld	e,a			; 2B
	ld	h,a			; 2C
	ld	l,a			; 2D
	ld	a,a			; 26		; first arg a
	ld	(k),a			; 2F 20

	ld	b,n			; 30 20
	ld	c,n			; 31 20
	ld	d,n			; 32 20
	ld	e,n			; 33 20
	ld	h,n			; 34 20
	ld	l,n			; 35 20
	ld	a,n			; 36 20
	ld	(w),n			; 37 21 20
	ld	bc,mn			; 38 84 05
	ld	de,mn			; 39 84 05
	ld	hl,mn			; 3A 84 05
					; 3B
	ld	ix,mn			; 3C 84 05
	ld	iy,mn			; 3D 84 05
	ld	sp,mn			; 3E 84 05
	ldw	(k),mn			; 3F 20 84 05

	ld	hl,bc			; 40
	ld	hl,de			; 41
	ld	hl,hl			; 42
					; 43
	ld	hl,ix			; 44
	ld	hl,iy			; 45
	ld	hl,sp			; 46
	ld	hl,(k)			; 47 20
	ld	bc,hl			; 48
	ld	de,hl			; 49
	ld	hl,hl			; 42
					; 4B
	ld	ix,hl			; 4C
	ld	iy,hl			; 4D
	ld	sp,hl			; 4E
	ld	(k),hl			; 4F 20

	push	bc			; 50
	push	de			; 51
	push	hl			; 52
					; 53
	push	ix			; 54
	push	iy			; 55
	push	af			; 56
					; 57
	pop	bc			; 58
	pop	de			; 59
	pop	hl			; 5A
					; 5B
	pop	ix			; 5C
	pop	iy			; 5D
	pop	af			; 5E
					; 5F

	add	a,(k)			; 60 20
	adc	a,(k)			; 61 20
	sub	a,(k)			; 62 20
	sbc	a,(k)			; 63 20
	and	a,(k)			; 64 20
	xor	a,(k)			; 65 20
	or	a,(k)			; 66 20
	cp	a,(k)			; 67 20
	add	a,n			; 68 20
	adc	a,n			; 69 20
	sub	a,n			; 6A 20
	sbc	a,n			; 6B 20
	and	a,n			; 6C 20
	xor	a,n			; 6D 20
	or	a,n			; 6E 20
	cp	a,n			; 6F 20

	add	hl,(k)			; 70 20
	adc	hl,(k)			; 71 20
	sub	hl,(k)			; 72 20
	sbc	hl,(k)			; 73 20
	and	hl,(k)			; 74 20
	xor	hl,(k)			; 75 20
	or	hl,(k)			; 76 20
	cp	hl,(k)			; 77 20
	add	hl,mn			; 78 84 05
	adc	hl,mn			; 79 84 05
	sub	hl,mn			; 7A 84 05
	sbc	hl,mn			; 7B 84 05
	and	hl,mn			; 7C 84 05
	xor	hl,mn			; 7D 84 05
	or	hl,mn			; 7E 84 05
	cp	hl,mn			; 7F 84 05

	inc	b			; 80
	inc	c			; 81
	inc	d			; 82
	inc	e			; 83
	inc	h			; 84
	inc	l			; 85
	inc	a			; 86
	inc	(k)			; 87 20
	dec	b			; 88
	dec	c			; 89
	dec	d			; 8A
	dec	e			; 8B
	dec	h			; 8C
	dec	l			; 8D
	dec	a			; 8E
	dec	(k)			; 8F 20

	inc	bc			; 90
	inc	de			; 91
	inc	hl			; 92
					; 93
	inc	ix			; 94
	inc	iy			; 95
	inc	sp			; 96
	incw	(k)			; 97 20
	dec	bc			; 98
	dec	de			; 99
	dec	hl			; 9A
					; 9B
	dec	ix			; 9C
	dec	iy			; 9D
	dec	sp			; 9E
	decw	(k)			; 9F 20
 
	rlca				; A0
	rrca				; A1
	rla				; A2
	rra				; A3
	slaa				; A4
	sraa				; A5
	slla				; A6
	srla				; A7
	bit	0,(k)			; A8 20
	bit	1,(k)			; A9 20
	bit	2,(k)			; AA 20
	bit	3,(k)			; AB 20
	bit	4,(k)			; AC 20
	bit	5,(k)			; AD 20
	bit	6,(k)			; AE 20
	bit	7,(k)			; AF 20

	res	0,(k)			; B0 20
	res	1,(k)			; B1 20
	res	2,(k)			; B2 20
	res	3,(k)			; B3 20
	res	4,(k)			; B4 20
	res	5,(k)			; B5 20
	res	6,(k)			; B6 20
	res	7,(k)			; B7 20
	set	0,(k)			; B8 20
	set	1,(k)			; B9 20
	set	2,(k)			; BA 20
	set	3,(k)			; BB 20
	set	4,(k)			; BC 20
	set	5,(k)			; BD 20
	set	6,(k)			; BE 20
	set	7,(k)			; BF 20

	jr	F,.			; C0 FE
	jr	LT,.			; C1 FE
	jr	LE,.			; C2 FE
	jr	ULE,.			; C3 FE
	jr	PE,.			; C4 FE
	jr	M,.			; C5 FE
	jr	Z,.			; C6 FE
	jr	C,.			; C7 FE
	jr	T,.			; C8 FE
	jr	GE,.			; C9 FE
	jr	GT,.			; CA FE
	jr	UGT,.			; CB FE
	jr	PO,.			; CC FE
	jr	P,.			; CD FE
	jr	NZ,.			; CE FE
	jr	NC,.			; CF FE

					; D0 -> DF  -  NOT DEFINED

					; E0 -> E7  -  Page 2
					; E8 -> EF  -  Page 3

					; F0 -> F3  -  Page 2
					; F4 -> F7  -  Page 3
					; F8 -> FE  -  Page 4
	swi				; FF


	.sbttl	Page 2 Instructions (F8 -> FE Prefix)

;*****-----*****-----*****-----*****-----*****
;
; From Toshiba 8-Bit Microcontroller TLCS 48/90 Data Book, 1988
;	Appendix B  Table of Machine Instruction Codes (2/4)
;
					;    00 -> 0F

					;    10
					;    11
	mul	hl,b			; F8 12
	div	hl,c			; F9 13
	add	ix,bc			; F8 14
	add	iy,de			; F9 15
	add	sp,ix			; FC 16
					;    17
	tset	0,b			; F8 18
	tset	1,c			; F9 19
	tset	2,d			; FA 1A
	tset	3,e			; FB 1B
	tset	4,h			; FC 1C
	tset	5,l			; FD 1D
	tset	6,a			; FE 1E
	tset	7,b			; F8 1F

					;    20 -> 2F

	ld	b,c			; F9 30
	ld	c,d			; FA 31
	ld	d,e			; FB 32
	ld	e,h			; FC 33
	ld	h,l			; FD 34
	ld	l,b			; F8 35
	ld	a,c			; 21
					;    37
	ld	bc,de			; F9 38
	ld	de,hl			; 49
	ld	hl,ix			; 44
					;    3B
	ld	ix,iy			; FD 3C
	ld	iy,sp			; FE 3D
	ld	sp,bc			; F8 3E
					;    3F

					;    40 -> 4F

					;    50 -> 57
	ldi				; FE 58
	ldir				; FE 59
	ldd				; FE 5A
	lddr				; FE 5B
	cpi				; FE 5C
	cpir				; FE 5D
	cpd				; FE 5E
	cpdr				; FE 5F

	add	a,b			; F8 60
	adc	a,c			; F9 61
	sub	a,d			; FA 62
	sbc	a,e			; FB 63
	and	a,h			; FC 64
	xor	a,l			; FD 65
	or	a,b			; F8 66
	cp	a,c			; F9 67
	add	b,n			; F8 68 20
	adc	c,n			; F9 69 20
	sub	d,n			; FA 6A 20
	sbc	e,n			; FB 6B 20
	and	h,n			; FC 6C 20
	xor	l,n			; FD 6D 20
	or	b,n			; F8 6E 20
	cp	c,n			; F9 6F 20

	add	hl,bc			; F8 70
	adc	hl,de			; F9 71
	sub	hl,hl			; FA 72
	sbc	hl,ix			; FC 73
	and	hl,iy			; FD 74
	xor	hl,sp			; FE 75
	or	hl,bc			; F8 76
	cp	hl,de			; F9 77
					;    78 -> 7F

					;    80 -> 8F
					;    90 -> 9F

	rlc	b			; F8 A0
	rrc	c			; F9 A1
	rl	d			; FA A2
	rr	e			; FB A3
	sla	h			; FC A4
	sra	l			; FD A5
	sll	a			; FE A6
	srl	b			; F8 A7
	bit	0,b			; F8 A8
	bit	1,c			; F9 A9
	bit	2,d			; FA AA
	bit	3,e			; FB AB
	bit	4,h			; FC AC
	bit	5,l			; FD AD
	bit	6,a			; FE AE
	bit	7,b			; F8 AF

	res	0,b			; F8 B0
	res	1,c			; F9 B1
	res	2,d			; FA B2
	res	3,e			; FB B3
	res	4,h			; FC B4
	res	5,l			; FD B5
	res	6,a			; FE B6
	res	7,b			; F8 B7
	set	0,b			; F8 B8
	set	1,c			; F9 B9
	set	2,d			; FA BA
	set	3,e			; FB BB
	set	4,h			; FC BC
	set	5,l			; FD BD
	set	6,a			; FE BE
	set	7,b			; F8 BF

					;    C0 -> CF

	ret	f			; FE D0
	ret	lt			; FE D1
	ret	le			; FE D2
	ret	ule			; FE D3
	ret	pe			; FE D4
	ret	m			; FE D5
	ret	z			; FE D6
	ret	c			; FE D7
	ret	t			; FE D8
	ret	ge			; FE D9
	ret	gt			; FE DA
	ret	ugt			; FE DB
	ret	po			; FE DC
	ret	p			; FE DD
	ret	nz			; FE DE
	ret	nc			; FE DF

					;    E0 -> EF
					;    F0 -> FF


	.sbttl	Page 3/4 Instructions (E0 -> E7 or F0 -> F3 Prefix)

;*****-----*****-----*****-----*****-----*****
;
; From Toshiba 8-Bit Microcontroller TLCS 48/90 Data Book, 1988
;	Appendix B  Table of Machine Instruction Codes (3/4 and 4/4))
;
;	Note: Page 4/4 Byte Codes 0x38->0x3B and 0x3C->0x3E are invalid.
;

					;    00 -> 0F

	rld	(de)			; E1 10
	rrd	(de)			; E1 11

	rld	(iy+x)			; F1 20 10
	rrd	(iy+x)			; F1 20 11

	rld	(hl+a)			; F3 10
	rrd	(hl+a)			; F3 11

	rld	(mn)			; E3 84 05 10
	rrd	(mn)			; E3 84 05 11

	rld	(k)			; E7 20 10
	rrd	(k)			; E7 20 11

	mul	hl,(de)			; E1 12
	div	hl,(bc)			; E0 13

	mul	hl,(iy+x)		; F1 20 12
	div	hl,(sp+x)		; F2 20 13

	mul	hl,(hl+a)		; F3 12
	div	hl,(hl+a)		; F3 13

	mul	hl,(mn)			; E3 84 05 12
	div	hl,(mn)			; E3 84 05 13

	mul	hl,(k)			; E7 20 12
	div	hl,(k)			; E7 20 13

	add	ix,(bc)			; E0 14
	add	iy,(de)			; E1 15
	add	sp,(hl)			; E2 16

	add	ix,(iy+x)		; F1 20 14
	add	iy,(sp+x)		; F2 20 15
	add	sp,(ix+x)		; F0 20 16

	add	ix,(hl+a)		; F3 14
	add	iy,(hl+a)		; F3 15
	add	sp,(hl+a)		; F3 16

	add	ix,(mn)			; E3 84 05 14
	add	iy,(mn)			; E3 84 05 15
	add	sp,(mn)			; E3 84 05 16

					;    17

	tset	0,(sp)			; E6 18
	tset	1,(iy)			; E5 19
	tset	2,(ix)			; E4 1A
	tset	3,(hl)			; E2 1B
	tset	4,(de)			; E1 1C
	tset	5,(bc)			; E0 1D
	tset	6,(sp)			; E6 1E
	tset	7,(iy)			; E5 1F

	tset	0,(ix+x)		; F0 20 18
	tset	1,(iy+x)		; F1 20 19
	tset	2,(sp+x)		; F2 20 1A
	tset	3,(hl+a)		; F3 1B
	tset	4,(ix+x)		; F0 20 1C
	tset	5,(iy+x)		; F1 20 1D
	tset	6,(sp+x)		; F2 20 1E
	tset	7,(hl+a)		; F3 1F

	tset	0,(mn)			; E3 84 05 18
	tset	1,(mn)			; E3 84 05 19
	tset	2,(mn)			; E3 84 05 1A
	tset	3,(mn)			; E3 84 05 1B
	tset	4,(mn)			; E3 84 05 1C
	tset	5,(mn)			; E3 84 05 1D
	tset	6,(mn)			; E3 84 05 1E
	tset	7,(mn)			; E3 84 05 1F

	tset	0,(k)			; E7 20 18
	tset	1,(k)			; E7 20 19
	tset	2,(k)			; E7 20 1A
	tset	3,(k)			; E7 20 1B
	tset	4,(k)			; E7 20 1C
	tset	5,(k)			; E7 20 1D
	tset	6,(k)			; E7 20 1E
	tset	7,(k)			; E7 20 1F

	ld	(de),b			; E9 20
	ld	(hl),c			; EA 21
	ld	(ix),d			; EC 22
	ld	(iy),e			; ED 23
	ld	(sp),h			; EE 24
	ld	(bc),l			; E8 25
	ld	(de),a			; E9 26
					;    27

	ld	(ix+x),b		; F4 20 20
	ld	(iy+x),c		; F5 20 21
	ld	(sp+x),d		; F6 20 22
	ld	(ix+x),e		; F4 20 23
	ld	(iy+x),h		; F5 20 24
	ld	(sp+x),l		; F6 20 25
	ld	(ix+x),a		; F4 20 26
					;       27

	ld	(hl+a),b		; F7 20
	ld	(hl+a),c		; F7 21
	ld	(hl+a),d		; F7 22
	ld	(hl+a),e		; F7 23
	ld	(hl+a),h		; F7 24
	ld	(hl+a),l		; F7 25
	ld	(hl+a),a		; F7 26
					;    27

	ld	(mn),b			; EB 84 05 20
	ld	(mn),c			; EB 84 05 21
	ld	(mn),d			; EB 84 05 22
	ld	(mn),e			; EB 84 05 23
	ld	(mn),h			; EB 84 05 24
	ld	(mn),l			; EB 84 05 25
	ld	(mn),a			; EB 84 05 26
					;          27

	ld	(k),b			; EF 20 20
	ld	(k),c			; EF 20 21
	ld	(k),d			; EF 20 22
	ld	(k),e			; EF 20 23
	ld	(k),h			; EF 20 24
	ld	(k),l			; EF 20 25
	ld	(k),a			; 2F 20
					;       27

	ld	b,(sp)			; E6 28
	ld	c,(iy)			; E5 29
	ld	d,(ix)			; E4 2A
	ld	e,(hl)			; E2 2B
	ld	h,(de)			; E1 2C
	ld	l,(bc)			; E0 2D
	ld	a,(sp)			; E6 2E
					;    2F

	ld	b,(ix+x)		; F0 20 28
	ld	c,(iy+x)		; F1 20 29
	ld	d,(sp+x)		; F2 20 2A
	ld	e,(hl+a)		; F3 2B
	ld	h,(ix+x)		; F0 20 2C
	ld	l,(iy+x)		; F1 20 2D
	ld	a,(sp+x)		; F2 20 2E
					;       2F

	ld	b,(mn)			; E3 84 05 28
	ld	c,(mn)			; E3 84 05 29
	ld	d,(mn)			; E3 84 05 2A
	ld	e,(mn)			; E3 84 05 2B
	ld	h,(mn)			; E3 84 05 2C
	ld	l,(mn)			; E3 84 05 2D
	ld	a,(mn)			; E3 84 05 2E
					;          2F

	ld	b,(k)			; EF 20 28
	ld	c,(k)			; EF 20 29
	ld	d,(k)			; EF 20 2A
	ld	e,(k)			; EF 20 2B
	ld	h,(k)			; EF 20 2C
	ld	l,(k)			; EF 20 2D
	ld	a,(k)			; 27 20
					;       2F

					;    30 -> 36
	ld	(bc),n			; E8 37 20
	ld	(iy+x),n		; F5 20 37 20
	ld	(hl+a),n		; F7 37 20
	ld	(mn),n			; EB 84 05 37 20
	ld	(w),n			; 37 21 20
					; 38 -> 3E
	ldw	(bc),mn			; E8 3F 84 05
	ldw	(iy+x),mn		; F5 20 3F 84 05
	ldw	(hl+a),mn		; F7 3F 84 05
	ldw	(vw),mn			; EB 85 06 3F 84 05
	ldw	(w),mn			; 3F 21 84 05

	ld	(de),bc			; E9 40
	ld	(ix+x),de		; F4 20 41
	ld	(hl+a),hl		; F7 42
					;    43
	ld	(mn),ix			; EB 84 05 44
	ld	(k),iy			; EF 20 45
	ld	(bc),sp			; E8 46
					;    47

	ld	bc,(sp)			; E6 48
	ld	de,(iy)			; E5 49
	ld	hl,(ix)			; E4 4A
					;    4B
	ld	ix,(hl)			; E2 4C
	ld	iy,(de)			; E1 4D
	ld	sp,(bc)			; E0 4E
					;    4F

	ld	bc,(ix+x)		; F0 20 48
	ld	de,(iy+x)		; F1 20 49
	ld	hl,(sp+x)		; F2 20 4A
					;       4B
	ld	ix,(ix+x)		; F0 20 4C
	ld	iy,(iy+x)		; F1 20 4D
	ld	sp,(sp+x)		; F2 20 4E
					;       4F

	ld	bc,(hl+a)		; F3 48
	ld	de,(hl+a)		; F3 49
	ld	hl,(hl+a)		; F3 4A
					;    4B
	ld	ix,(hl+a)		; F3 4C
	ld	iy,(hl+a)		; F3 4D
	ld	sp,(hl+a)		; F3 4E
					;    4F

	ld	bc,(mn)			; E3 84 05 48
	ld	de,(mn)			; E3 84 05 49
	ld	hl,(mn)			; E3 84 05 4A
					;          4B
	ld	ix,(mn)			; E3 84 05 4C
	ld	iy,(mn)			; E3 84 05 4D
	ld	sp,(mn)			; E3 84 05 4E
					;          4F

	ld	bc,(k)			; E7 20 48
	ld	de,(k)			; E7 20 49
	ld	hl,(k)			; 47 20
					;       4B
	ld	ix,(k)			; E7 20 4C
	ld	iy,(k)			; E7 20 4D
	ld	sp,(k)			; E7 20 4E
					;       4F

	ex	(de),bc			; E1 50
	ex	(hl),de			; E2 51
	ex	(ix),hl			; E4 52
					;    53
	ex	(iy),ix			; E5 54
	ex	(sp),iy			; E6 55
	ex	(bc),sp			; E0 56
					;    57

	ex	(ix+x),bc		; F0 20 50
	ex	(iy+x),de		; F1 20 51
	ex	(sp+x),hl		; F2 20 52
					;       53
	ex	(iy+x),ix		; F1 20 54
	ex	(ix+x),iy		; F0 20 55
	ex	(iy+x),sp		; F1 20 56
					;       57

	ex	(hl+a),bc		; F3 50
	ex	(hl+a),de		; F3 51
	ex	(hl+a),hl		; F3 52
					; F3 53
	ex	(hl+a),ix		; F3 54
	ex	(hl+a),iy		; F3 55
	ex	(hl+a),sp		; F3 56
					; F3 57

	ex	(mn),bc			; E3 84 05 50
	ex	(mn),de			; E3 84 05 51
	ex	(mn),hl			; E3 84 05 52
					;          53
	ex	(mn),ix			; E3 84 05 54
	ex	(mn),iy			; E3 84 05 55
	ex	(mn),sp			; E3 84 05 56
					;          57

	ex	(k),bc			; E7 20 50
	ex	(k),de			; E7 20 51
	ex	(k),hl			; E7 20 52
					;       53
	ex	(k),ix			; E7 20 54
	ex	(k),iy			; E7 20 55
	ex	(k),sp			; E7 20 56
					;       57

					; 58 -> 5F

	add	a,(sp)			; E6 60
	adc	a,(iy)			; E5 61
	sub	a,(ix)			; E4 62
	sbc	a,(hl)			; E2 63
	and	a,(de)			; E1 64
	xor	a,(bc)			; E0 65
	or	a,(sp)			; E6 66
	cp	a,(iy)			; E5 67

	add	a,(sp+x)		; F2 20 60
	adc	a,(iy+x)		; F1 20 61
	sub	a,(ix+x)		; F0 20 62
	sbc	a,(sp+x)		; F2 20 63
	and	a,(iy+x)		; F1 20 64
	xor	a,(ix+x)		; F0 20 65
	or	a,(sp+x)		; F2 20 66
	cp	a,(iy+x)		; F1 20 67

	add	a,(hl+a)		; F3 60
	adc	a,(hl+a)		; F3 61
	sub	a,(hl+a)		; F3 62
	sbc	a,(hl+a)		; F3 63
	and	a,(hl+a)		; F3 64
	xor	a,(hl+a)		; F3 65
	or	a,(hl+a)		; F3 66
	cp	a,(hl+a)		; F3 67

	add	a,(mn)			; E3 84 05 60
	adc	a,(mn)			; E3 84 05 61
	sub	a,(mn)			; E3 84 05 62
	sbc	a,(mn)			; E3 84 05 63
	and	a,(mn)			; E3 84 05 64
	xor	a,(mn)			; E3 84 05 65
	or	a,(mn)			; E3 84 05 66
	cp	a,(mn)			; E3 84 05 67

	add	(sp),n			; EE 68 20
	adc	(iy),n			; ED 69 20
	sub	(ix),n			; EC 6A 20
	sbc	(hl),n			; EA 6B 20
	and	(de),n			; E9 6C 20
	xor	(bc),n			; E8 6D 20
	or	(sp),n			; EE 6E 20
	cp	(iy),n			; ED 6F 20

	add	(sp+x),n		; F6 20 68 20
	adc	(iy+x),n		; F5 20 69 20
	sub	(ix+x),n		; F4 20 6A 20
	sbc	(sp+x),n		; F6 20 6B 20
	and	(iy+x),n		; F5 20 6C 20
	xor	(ix+x),n		; F4 20 6D 20
	or	(sp+x),n		; F6 20 6E 20
	cp	(iy+x),n		; F5 20 6F 20

	add	(hl+a),n		; F7 68 20
	adc	(hl+a),n		; F7 69 20
	sub	(hl+a),n		; F7 6A 20
	sbc	(hl+a),n		; F7 6B 20
	and	(hl+a),n		; F7 6C 20
	xor	(hl+a),n		; F7 6D 20
	or	(hl+a),n		; F7 6E 20
	cp	(hl+a),n		; F7 6F 20

	add	(mn),n			; EB 84 05 68 20
	adc	(mn),n			; EB 84 05 69 20
	sub	(mn),n			; EB 84 05 6A 20
	sbc	(mn),n			; EB 84 05 6B 20
	and	(mn),n			; EB 84 05 6C 20
	xor	(mn),n			; EB 84 05 6D 20
	or	(mn),n			; EB 84 05 6E 20
	cp	(mn),n			; EB 84 05 6F 20

	add	(w),n			; EF 21 68 20
	adc	(w),n			; EF 21 69 20
	sub	(w),n			; EF 21 6A 20
	sbc	(w),n			; EF 21 6B 20
	and	(w),n			; EF 21 6C 20
	xor	(w),n			; EF 21 6D 20
	or	(w),n			; EF 21 6E 20
	cp	(w),n			; EF 21 6F 20

	add	hl,(sp)			; E6 70
	adc	hl,(iy)			; E5 71
	sub	hl,(ix)			; E4 72
	sbc	hl,(hl)			; E2 73
	and	hl,(de)			; E1 74
	xor	hl,(bc)			; E0 75
	or	hl,(sp)			; E6 76
	cp	hl,(iy)			; E5 77

	add	hl,(sp+x)		; F2 20 70
	adc	hl,(iy+x)		; F1 20 71
	sub	hl,(ix+x)		; F0 20 72
	sbc	hl,(sp+x)		; F2 20 73
	and	hl,(iy+x)		; F1 20 74
	xor	hl,(ix+x)		; F0 20 75
	or	hl,(sp+x)		; F2 20 76
	cp	hl,(iy+x)		; F1 20 77

	add	hl,(hl+a)		; F3 70
	adc	hl,(hl+a)		; F3 71
	sub	hl,(hl+a)		; F3 72
	sbc	hl,(hl+a)		; F3 73
	and	hl,(hl+a)		; F3 74
	xor	hl,(hl+a)		; F3 75
	or	hl,(hl+a)		; F3 76
	cp	hl,(hl+a)		; F3 77

	add	hl,(mn)			; E3 84 05 70
	adc	hl,(mn)			; E3 84 05 71
	sub	hl,(mn)			; E3 84 05 72
	sbc	hl,(mn)			; E3 84 05 73
	and	hl,(mn)			; E3 84 05 74
	xor	hl,(mn)			; E3 84 05 75
	or	hl,(mn)			; E3 84 05 76
	cp	hl,(mn)			; E3 84 05 77

					;    78 -> 7F

					;    80 -> 86

	inc	(bc)			; E0 87
	inc	(ix+x)			; F0 20 87
	inc	(hl+a)			; F3 87
	inc	(mn)			; E3 84 05 87

					;    88 -> 8E

	dec	(de)			; E1 8F
	dec	(iy+x)			; F1 20 8F
	dec	(hl+a)			; F3 8F
	dec	(mn)			; E3 84 05 8F

					;    90 -> 96

	incw	(bc)			; E0 97
	incw	(ix+x)			; F0 20 97
	incw	(hl+a)			; F3 97
	incw	(mn)			; E3 84 05 97

					;    98 -> 9E

	decw	(de)			; E1 9F
	decw	(iy+x)			; F1 20 9F
	decw	(hl+a)			; F3 9F
	decw	(mn)			; E3 84 05 9F

	rlc	(sp)			; E6 A0
	rrc	(iy)			; E5 A1
	rl	(ix)			; E4 A2
	rr	(hl)			; E2 A3
	sla	(de)			; E1 A4
	sra	(bc)			; E0 A5
	sll	(sp)			; E6 A6
	srl	(iy)			; E5 A7

	rlc	(ix+x)			; F0 20 A0
	rrc	(iy+x)			; F1 20 A1
	rl	(sp+x)			; F2 20 A2
	rr	(hl+a)			; F3 A3
	sla	(ix+x)			; F0 20 A4
	sra	(iy+x)			; F1 20 A5
	sll	(sp+x)			; F2 20 A6
	srl	(hl+a)			; F3 A7

	rlc	(mn)			; E3 84 05 A0
	rrc	(mn)			; E3 84 05 A1
	rl	(mn)			; E3 84 05 A2
	rr	(mn)			; E3 84 05 A3
	sla	(mn)			; E3 84 05 A4
	sra	(mn)			; E3 84 05 A5
	sll	(mn)			; E3 84 05 A6
	srl	(mn)			; E3 84 05 A7

	rlc	(k)			; E7 20 A0
	rrc	(k)			; E7 20 A1
	rl	(k)			; E7 20 A2
	rr	(k)			; E7 20 A3
	sla	(k)			; E7 20 A4
	sra	(k)			; E7 20 A5
	sll	(k)			; E7 20 A6
	srl	(k)			; E7 20 A7

	bit	0,(sp)			; E6 A8
	bit	1,(iy)			; E5 A9
	bit	2,(ix)			; E4 AA
	bit	3,(hl)			; E2 AB
	bit	4,(de)			; E1 AC
	bit	5,(bc)			; E0 AD
	bit	6,(sp)			; E6 AE
	bit	7,(iy)			; E5 AF

	bit	0,(ix+x)		; F0 20 A8
	bit	1,(iy+x)		; F1 20 A9
	bit	2,(sp+x)		; F2 20 AA
	bit	3,(hl+a)		; F3 AB
	bit	4,(ix+x)		; F0 20 AC
	bit	5,(iy+x)		; F1 20 AD
	bit	6,(sp+x)		; F2 20 AE
	bit	7,(hl+a)		; F3 AF

	bit	0,(mn)			; E3 84 05 A8
	bit	1,(mn)			; E3 84 05 A9
	bit	2,(mn)			; E3 84 05 AA
	bit	3,(mn)			; E3 84 05 AB
	bit	4,(mn)			; E3 84 05 AC
	bit	5,(mn)			; E3 84 05 AD
	bit	6,(mn)			; E3 84 05 AE
	bit	7,(mn)			; E3 84 05 AF

	res	0,(sp)			; E6 B0
	res	1,(iy)			; E5 B1
	res	2,(ix)			; E4 B2
	res	3,(hl)			; E2 B3
	res	4,(de)			; E1 B4
	res	5,(bc)			; E0 B5
	res	6,(sp)			; E6 B6
	res	7,(iy)			; E5 B7

	res	0,(ix+x)		; F0 20 B0
	res	1,(iy+x)		; F1 20 B1
	res	2,(sp+x)		; F2 20 B2
	res	3,(hl+a)		; F3 B3
	res	4,(ix+x)		; F0 20 B4
	res	5,(iy+x)		; F1 20 B5
	res	6,(sp+x)		; F2 20 B6
	res	7,(hl+a)		; F3 B7

	res	0,(mn)			; E3 84 05 B0
	res	1,(mn)			; E3 84 05 B1
	res	2,(mn)			; E3 84 05 B2
	res	3,(mn)			; E3 84 05 B3
	res	4,(mn)			; E3 84 05 B4
	res	5,(mn)			; E3 84 05 B5
	res	6,(mn)			; E3 84 05 B6
	res	7,(mn)			; E3 84 05 B7

	set	0,(sp)			; E6 B8
	set	1,(iy)			; E5 B9
	set	2,(ix)			; E4 BA
	set	3,(hl)			; E2 BB
	set	4,(de)			; E1 BC
	set	5,(bc)			; E0 BD
	set	6,(sp)			; E6 BE
	set	7,(iy)			; E5 BF

	set	0,(ix+x)		; F0 20 B8
	set	1,(iy+x)		; F1 20 B9
	set	2,(sp+x)		; F2 20 BA
	set	3,(hl+a)		; F3 BB
	set	4,(ix+x)		; F0 20 BC
	set	5,(iy+x)		; F1 20 BD
	set	6,(sp+x)		; F2 20 BE
	set	7,(hl+a)		; F3 BF

	set	0,(mn)			; E3 84 05 B8
	set	1,(mn)			; E3 84 05 B9
	set	2,(mn)			; E3 84 05 BA
	set	3,(mn)			; E3 84 05 BB
	set	4,(mn)			; E3 84 05 BC
	set	5,(mn)			; E3 84 05 BD
	set	6,(mn)			; E3 84 05 BE
	set	7,(mn)			; E3 84 05 BF

	jp	f,bc			; E8 C0
	jp	lt,ix+x			; F4 20 C1
	jp	le,hl+a			; F7 C2
	jp	ule,mn			; EB 84 05 C3
	jp	pe,de			; E9 C4
	jp	m,iy+x			; F5 20 C5
	jp	z,hl+a			; F7 C6
	jp	c,mn			; EB 84 05 C7
	jp	t,hl			; EA C8
	jp	ge,sp+x			; F6 20 C9
	jp	gt,hl+a			; F7 CA
	jp	ugt,mn			; EB 84 05 CB
	jp	po,ix			; EC CC
	jp	p,ix+x			; F4 20 CD
	jp	nz,hl+a			; F7 CE
	jp	nc,mn			; EB 84 05 CF

	call	f,bc			; E8 D0
	call	lt,ix+x			; F4 20 D1
	call	le,hl+a			; F7 D2
	call	ule,mn			; EB 84 05 D3
	call	pe,de			; E9 D4
	call	m,iy+x			; F5 20 D5
	call	z,hl+a			; F7 D6
	call	c,mn			; EB 84 05 D7
	call	t,hl			; EA D8
	call	ge,sp+x			; F6 20 D9
	call	gt,hl+a			; F7 DA
	call	ugt,mn			; EB 84 05 DB
	call	po,ix			; EC DC
	call	p,ix+x			; F4 20 DD
	call	nz,hl+a			; F7 DE
	call	nc,mn			; EB 84 05 DF

					; E0 -> EF

					; F0 -> FF

;*****-----*****-----*****-----*****-----*****
;
;	Access Direct Page
;

	.globl	dpa0, dpa1, dpa2, dpa3, dpa4
	.globl	dpa5, dpa6, dpa7, dpa8, dpa9

	.word	dpa0, dpa1		; 00 FF 01 FF
	.word	dpa2, dpa3		; 02 FF 03 FF
	.word	dpa4, dpa5		; 04 FF 05 FF
	.word	dpa6, dpa7		; 06 FF 07 FF
	.word	dpa8, dpa9		; 08 FF 09 FF

	tset	7,(dpa0)		; E3 00 FF 1F
	rl	(0)			; E3 00 00 A2
	rl	(*dpa0)			; E7 00 A2
	rl	(*0)			; E7 00 A2

	jp	dpa3			; 1A 03 FF
					; pc+cd = dpa5 - (. + 2)
	jrl	dpa5			; 1B 33 F7


;*****-----*****-----*****-----*****-----*****
;
;	Other Tests
;
;	Alternate forms for (ix+d)

	add	ix,(iy+x)		; F1 20 14
	add	iy,(sp+x+1)		; F2 21 15
	add	sp,(ix+1+x)		; F0 21 16

	add	ix,(iy+(x))		; F1 20 14
	add	iy,(sp+(x+1))		; F2 21 15
	add	sp,(ix+(1+x))		; F0 21 16

	add	ix,x(iy)		; F1 20 14
	add	iy,x+1(sp)		; F2 21 15
	add	sp,1+x(ix)		; F0 21 16

	add	ix,(x)(iy)		; F1 20 14
	add	iy,(x+1)(sp)		; F2 21 15
	add	sp,(1+x)(ix)		; F0 21 16

	add	(ix+x),n		; F4 20 68 20
	add	(iy+x+1),n		; F5 21 68 20
	add	(sp+1+x),n		; F6 21 68 20

	add	(ix+(x)),n		; F4 20 68 20
	add	(iy+(x+1)),n		; F5 21 68 20
	add	(sp+(1+x)),n		; F6 21 68 20

	add	x(ix),n			; F4 20 68 20
	add	x+1(iy),n		; F5 21 68 20
	add	1+x(sp),n		; F6 21 68 20

	add	(x)(ix),n		; F4 20 68 20
	add	(x+1)(iy),n		; F5 21 68 20
	add	(1+x)(sp),n		; F6 21 68 20

.endif

	.end
