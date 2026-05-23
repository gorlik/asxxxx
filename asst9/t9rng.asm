	.title	ASST9 Error Checking

	.sbttl	Branching Ranges

btjf:	btjf	r7.0,btjf	; AF 17 FD
1$:	.blkb	125
	btjf	r0.4,1$		; AF 90 80
	btjf	r1.5,2$		; AF B1 7F
	.blkb	127
2$:

btjt:	btjt	r7.0,btjt	; AF 07 FD
1$:	.blkb	125
	btjt	r0.4,1$		; AF 80 80
	btjt	r1.5,2$		; AF A1 7F
	.blkb	127
2$:

cpjfi:	cpjfi	r0,(rr2),cpjfi	; 9F 20 FD
1$:	.blkb	125
	cpjfi	r4,(rr6),1$	; 9F 64 80
	cpjfi	r8,(rr10),2$	; 9F A8 7F
	.blkb	127
2$:

cpjti:	cpjfi	r0,(rr2),cpjti	; 9F 20 FD
1$:	.blkb	125
	cpjti	r4,(rr6),1$	; 9F 74 80
	cpjti	r8,(rr10),2$	; 9F B8 7F
	.blkb	127
2$:

djnz:	djnz	r0,djnz		; 0A FE
1$:	.blkb	126
	djnz	r2,1$		; 2A 80
	djnz	r4,2$		; 4A 7F
	.blkb	127
2$:

dwjnz:	dwjnz	RR0,dwjnz	; C6 00 FD
1$:	.blkb	125
	dwjnz	RR2,1$		; C6 02 80
	dwjnz	RR4,2$		; C6 04 7F
	.blkb	127
2$:

jrc:	jrc	jrc		; 7B FE
1$:	.blkb	126
	jrc	1$		; 7B 80
	jrc	2$		; 7B 7F
	.blkb	127
2$:
