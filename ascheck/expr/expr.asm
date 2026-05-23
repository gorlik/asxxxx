	.title	Verify expr() Processing

	; compile with -x option (HEX Listing)

	.radix	D		; default radix
	.hilo			; hi byte / lo byte

	;*****-----*****-----*****-----*****-----*****
	; Constants Via Radix
	;
	.radix	B
	.word	01000000	; 00 40		; Binary

	.radix	Q
	.word	100		; 00 40		; Octal

	.radix	D
	.word	64		; 00 40		; Decimal

	.radix	X
	.word	40		; 00 40		; Hexadecimal
	;
	;*****-----*****-----*****-----*****-----*****

	.radix	D		; default radix

	;*****-----*****-----*****-----*****-----*****
	; Constants Via '^' Radix
	;
	.word	^B01000000	; 00 40		; Binary
	.word	^B 01000000	; 00 40
	.word	^B (01000000)	; 00 40

	.word	^Q100		; 00 40		; Octal
	.word	^Q 100		; 00 40
	.word	^Q (100)	; 00 40

	.word	^D64		; 00 40		; Decimal
	.word	^D 64		; 00 40
	.word	^D (64)		; 00 40

	.word	^X40		; 00 40		; Hexadecimal
	.word	^X 40		; 00 40
	.word	^X (40)		; 00 40
	;
	;*****-----*****-----*****-----*****-----*****

	;*****-----*****-----*****-----*****-----*****
	; Constants Via '$' Radix
	;
	.word	$%01000000	; 00 40		; Binary
	.word	$% 01000000	; 00 40
	.word	$% (01000000)	; 00 40

	.word	$&100		; 00 40		; Octal
	.word	$& 100		; 00 40
	.word	$& (100)	; 00 40

	.word	$#64		; 00 40		; Decimal
	.word	$# 64		; 00 40
	.word	$# (64)		; 00 40

	.word	$@40		; 00 40		; Hexadecimal
	.word	$@ 40		; 00 40
	.word	$@ (40)		; 00 40
	;
	;*****-----*****-----*****-----*****-----*****

	.radix	X		; default radix

	;*****-----*****-----*****-----*****-----*****
	; Constants Via '^' Radix
	;
	.word	^B01000000	+ A	; 00 4A		; Binary
	.word	^B 01000000	+ A	; 00 4A
	.word	^B (01000000)	+ A	; 00 4A

	.word	^Q100		+ A	; 00 4A		; Octal
	.word	^Q 100		+ A	; 00 4A
	.word	^Q (100)	+ A	; 00 4A

	.word	^D64		+ A	; 00 4A		; Decimal
	.word	^D 64		+ A	; 00 4A
	.word	^D (64)		+ A	; 00 4A

	.word	^X40		+ A	; 00 4A		; Hexadecimal
	.word	^X 40		+ A	; 00 4A
	.word	^X (40)		+ A	; 00 4A
	;
	;*****-----*****-----*****-----*****-----*****

	;*****-----*****-----*****-----*****-----*****
	; Constants Via '$' Radix
	;
	.word	$%01000000	+ A	; 00 4A		; Binary
	.word	$% 01000000	+ A	; 00 4A
	.word	$% (01000000)	+ A	; 00 4A

	.word	$&100		+ A	; 00 4A		; Octal
	.word	$& 100		+ A	; 00 4A
	.word	$& (100)	+ A	; 00 4A

	.word	$#64		+ A	; 00 4A		; Decimal
	.word	$# 64		+ A	; 00 4A
	.word	$# (64)		+ A	; 00 4A

	.word	$@40		+ A	; 00 4A		; Hexadecimal
	.word	$@ 40		+ A	; 00 4A
	.word	$@ (40)		+ A	; 00 4A
	;
	;*****-----*****-----*****-----*****-----*****

	dd = 0xAA		; local value

	;*****-----*****-----*****-----*****-----*****
	; Constants Via '^' Radix
	;
	.word	^B (01000000 + dd)	; 00 EA		; Binary

	.word	^Q (100 + dd)		; 00 EA		; Octal

	.word	^D (64 + dd)		; 00 EA		; Decimal

	.word	^X (40 + dd)		; 00 EA		; Hexadecimal
	;
	;*****-----*****-----*****-----*****-----*****

	;*****-----*****-----*****-----*****-----*****
	; Constants Via '$' Radix
	;
	.word	$% (01000000 + dd)	; 00 EA		; Binary

	.word	$& (100 + dd)		; 00 EA		; Octal

	.word	$# (64 + dd)		; 00 EA		; Decimal

	.word	$@ (40 + dd)		; 00 EA		; Hexadecimal
	;
	;*****-----*****-----*****-----*****-----*****

	.globl	cc	; global value

	;*****-----*****-----*****-----*****-----*****
	; Constant + Global Via '^' Radix
	;
	.word	^B (01000000 + cc)	; 00 EB		; Binary

	.word	^Q (100 + cc)		; 00 EB		; Octal

	.word	^D (64 + cc)		; 00 EB		; Decimal

	.word	^X (40 + cc)		; 00 EB		; Hexadecimal
	;
	;*****-----*****-----*****-----*****-----*****

	;*****-----*****-----*****-----*****-----*****
	; Constant + Global Via '$' Radix
	;
	.word	$% (01000000 + cc)	; 00 EB		; Binary

	.word	$& (100 + cc)		; 00 EB		; Octal

	.word	$# (64 + cc)		; 00 EB		; Decimal

	.word	$@ (40 + cc)		; 00 EB		; Hexadecimal
	;
	;*****-----*****-----*****-----*****-----*****

	.globl	two	; global value

	;*****-----*****-----*****-----*****-----*****
	; Complex Argument Via '^' Radix
	;
	.word	^B (01000000 * two)	; 00 80		; Binary

	.word	^Q (100 * two)		; 00 80		; Octal

	.word	^D (64 * two)		; 00 80		; Decimal

	.word	^X (40 * two)		; 00 80		; Hexadecimal
	;
	;*****-----*****-----*****-----*****-----*****

	;*****-----*****-----*****-----*****-----*****
	; Complex Argument Via '$' Radix
	;
	.word	$% (01000000 * two)	; 00 80		; Binary

	.word	$& (100 * two)		; 00 80		; Octal

	.word	$# (64 * two)		; 00 80		; Decimal

	.word	$@ (40 * two)		; 00 80		; Hexadecimal
	;
	;*****-----*****-----*****-----*****-----*****

	;*****-----*****-----*****-----*****-----*****
	; Program Counter & Temporary Symbols
	;
	.nval	dot, .
1$:	.word	. - dot + 1		; 00 01

	dot = .
2$:	.word	. - dot + 1		; 00 01

3$:	.word	. - 3$ + 1		; 00 01

4$:	.word	(. - 4$ + 1) * two	; 00 02
	;
	;*****-----*****-----*****-----*****-----*****

	;*****-----*****-----*****-----*****-----*****
	; Program Counter & Permanent Symbols
	;
	.nval	dot, p1$
p1$:	.word	. - dot + 1		; 00 01

	dot = p2$
p2$:	.word	. - dot	+ 1		; 00 01

p3$:	.word	. - p3$ + 1		; 00 01

p4$:	.word	(. - p4$ + 1) * two	; 00 02
	;
	;*****-----*****-----*****-----*****-----*****

