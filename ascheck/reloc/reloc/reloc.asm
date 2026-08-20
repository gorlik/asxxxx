	.title	reloc Relocation With Globals

	.area	RELOC

	.radix	X

.if 1
	.globl	va, vb
	.local	x

	.word	~#vb

	x = 10
	.define		x "va*2 + 10"
	.word	x + va
	.undefine	x

	x == . + 20
	.word	x + vb

	.define		x "vb/2 + 20 + 1000"
	;
	.byte	x + vb
	.word	x + vb
	;
	.byte	>(x + vb)
	.word	>(x + vb)
	;
	.byte	<(x + vb)
	.word	<(x + vb)
	;
	.undefine	x
.endif
