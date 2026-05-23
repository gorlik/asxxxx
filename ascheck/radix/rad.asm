	.title	Radix Tests

	.globl	D, X, Q, B

	.word	^B(100)
	.word	^Q(40)
	.word	^X(40)
	.word	^Q(^X(40) + 40)
	.word	^B(^Q(^X(40) + 40) + 100)
	.word	^D(^B(^Q(^X(40) + 40) + 100) - 100)

	.word	^B(B)
	.word	^Q(Q)
	.word	^X(X)
	.word	^Q(^X(X) + Q)
	.word	^B(^Q(^X(X) + Q) + B)
	.word	^D(^B(^Q(^X(X) + Q) + B) - D)
