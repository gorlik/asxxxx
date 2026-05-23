	.sbttl	External . Test

	.area	XTRNL	(rel,con)

	.blkb	10

	const = .+2
	const1 = .+4
	.word	a/0
	.word	a%0
	.word	2/0
	.word	2/e
tk:	bra	.+a
	.word	(^B(1010 + ^O(12 + ^D(10 + ^X(0A + ^B(1010 + ^O(12 + ^D(10 + ^X(0A)))))))))

;1$:	.word	1$ + a - . + 101 + tk; + 1$ + b
;tk::
;	.word	$1$ + a

.if 0
	.word	a

	.word	a<<b, a*b, a+b, b/a

	.word	a^4

	.word	.+2

.endif

	.globl	a, b, c, d, e

.if 0

	.globl	xtrn1, xtrn2, xtrn3, xtrn4, local

	xtrn1 = 2 * 4
	xtrn2 = 16 / 8
	xtrn3 = 2
	xtrn4 = a			; err - global argument not allowed

;.if 0
	.word	a<<4
	.word	(((a<<4) + 2) * 2<<b)

	.word	(^B(1010 + ^O(12 + ^D(10 + ^X(0A + ^B(1010 + ^O(12 + ^D(10 + ^X(0A)))))))))

;	val = 4

	.word	^B1010 - d
	.word	^O12
	.word	^D10
	.word	^Xa
	.word	10000
	.word	(^B1010*^O12*^D10*^Xa)

	.word	^B1010*10		; 000 100
	.word	^B(1010*10)		; 000 020
	.word	^B(1010*10)*10		; 000 200
	.word	^X(^B(1010*10)*10)	; 001 064

	.word	^B(1010*^X(a+0)		; error - missing ')'

	.word	^B1010*10		; 000 100
	.word	^B(1010*10)		; 000 020
	.word	^B(1010*10)*10		; 000 200
	.word	^X(^B(1010*10)*10)	; 001 064
.endif
