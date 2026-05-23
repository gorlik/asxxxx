	.title	TT90 Direct Page

;*****-----*****-----*****-----*****-----*****
;
;	Creating A Direct Page Area
;
;	This Area Must Be Relocated To 0xFF00
;

	.globl	dpa0, dpa1, dpa2, dpa3, dpa4
	.globl	dpa5, dpa6, dpa7, dpa8, dpa9


	.area	DP_Area		(rel,con)

dpa0:	.blkb	1
dpa1 = .
	.blkb	1
dpa2:	.blkb	1
dpa3 = .
	.blkb	1
dpa4:	.blkb	1
dpa5 = .
	.blkb	1
dpa6:	.blkb	1
dpa7 = .
	.blkb	1
dpa8:	.blkb	1
dpa9 = .

	.end
