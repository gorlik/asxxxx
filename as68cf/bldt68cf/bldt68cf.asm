	.title	AS68CF Assembler Test

	.nlist
	.include "bldt68cf.mac"
	.list

	.enabl	(alt)		; Allow Alternate Instructions
	.enabl	(flt)		; Enable Coldfire Floating Point

	.nlist
	$Error = 0
	$All = 1

	.S_TYP1.  = $All + 0	; ABCD, SBCD, ADDX, SUBX
	.S_TYP2.  = $All + 0	; ADD, AND, OR, SUB
	.S_TYP3.  = $All + 0	; ADDA, CMPA, SUBA
	.S_TYP4.  = $All + 0	; ADDI, ANDI, CMPI, EORI, ORI, SUBI
	.S_TYP5.  = $All + 0	; ADDQ, SUBQ
	.S_TYP6.  = $All + 0	; DIVS, DIVU, MULS, MULU
	.S_TYP7.  = $All + 0	; CLR, TST
	.S_TYP8.  = $All + 0	; JMP, JSR, LEA, PEA
	.S_TYP9.  = $All + 0	; BYTEREV, BITREV, FF1, NEG, NEGX, NOT, SWAP, UNLK, SATS, SWAP
	.S_TAS.   = $All + 0	; TAS, WDDATA
	.S_SHFT.  = $All + 0	; ASL, ASR, LSL, LSR
	.S_BCC.   = $All + 0	; BRA, BSR, BHI, BLS, BCC, BCS, BNE, BEQ
				; BVC, BVS, BPL, BMI, BGE, BLT, BGT, BLE
				; Alternates - BHS, BLO, BHIS, BLOS
	.S_SCC.   = $All + 0	; ST,  SF,  SHI, SLS, SCC, SCS, SNE, SEQ
				; SVC, SVS, SPL, SMI, SGE, SLT, SGT, SLE
				; Alternates - SHS, SLO, SHIS, SLOS
	.S_BIT.   = $All + 0	; BCHG, BCLR, BSET, BTST
	.S_MOV3Q. = $All + 0	; MOV3Q
	.S_MOVE.  = $All + 0	; MOVE
	.S_MOVEA. = $All + 0	; MOVEA
	.S_MOVEC. = $All + 0	; MOVEC
	.S_MOVEM. = $All + 0	; MOVEM
	.S_MOVEQ. = $All + 0	; MOVEQ
	.S_MVSZ.  = $All + 0	; MVS, MVZ
	.S_EOR.   = $All + 0	; EOR
	.S_EXT.   = $All + 0	; EXT, EXTB
	.S_LINK.  = $All + 0	; LINK
	.S_STOP.  = $All + 0	; STOP
	.S_SWAP.  = $All + 0	; SWAP
	.S_TRAP.  = $All + 0	; TRAP
	.S_TPF.   = $All + 0	; TPF
	.S_UNLK.  = $All + 0	; UNLK
	.S_INH.   = $All + 0	; HALT, ILLEGAL, NOP, PULSE, RTE, RTS
	.S_CAS.   = $All + 0	; CAS
	.S_CAS2.  = $All + 0	; CAS2
	.S_CHK.   = $All + 0	; CHK
	.S_CHK2.  = $All + 0	; CHK2, CMP2
	.S_CMP.   = $All + 0	; CMP
	.S_SHL.   = $All + 0	; CPUSHL
	.S_TCH.   = $All + 0	; INTOUCH
	.S_REM.   = $All + 0	; REMS, REMU
	.S_STLD.  = $All + 0	; STRLDSR
	.S_WDB.   = $All + 0	; WDEBUG

	.B_XPC.   = $All + 0	; External Branching Tests

	; [Extended] Multiply-Accumulate Instructions

	.M_MAC.   = $All + 0	; MAC, MSAC, MAAAC, MASAC, MSAAC, MSSAC
	.M_MCLR.  = $All + 0	; MOVCLR

	; Coldfire Floating Point Instructions

	.F_TYP1.  = $All + 0	; F_TYP1: FABS, FSABS, FDABS, FINT, FINTRZ,
				;	  FNEG, FSNEG, FDNEG, FSQRT, FSSQRT, FDSQRT, 
	.F_TYP2.  = $All + 0	; F_TYP2: FADD, FSADD, FDADD, FCMP, FDIV, FSDIV, FDDIV 
        			;	  FMUL, FSMUL, FDMUL, FSUB, FSSUB, FDSUB
	.F_TST.   = $All + 0	; FTST
	.F_MOV.   = $All + 0	; FMOVE, FSMOVE, FDMOVE
	.F_MOVM.  = $All + 0	; FMOVEM
	.F_BCC.   = $All + 0	; FBCC
	.F_NOP.   = $All + 0	; FNOP
	.F_SVRS.  = $All + 0	; FSAVE, FRESTORE

	; Internal Checks

	.AMCHK.   =      + 0	; Addressing Mode Checks
	.SRCCHK.  = $All + 0	; Exhaustive Source Addressing Checks

	; Instruction Tests

	.ifne .AMCHK.
	  .list
	  .page
	.sbttl	Addressing Mode Checks
	  .nlist
1$:	AMCHK	$Error
	.endif

	.ifne .S_TYP1.
	  .list
	  .page
	.sbttl	Type S_TYP1 Instructions: ABCD, SBCD, ADDX, SUBX
	  .nlist
2$:	S_TYP1	$Error
	.endif

	.ifne .S_TYP2.
	  .list
	  .page
	.sbttl	Type S_TYP2 Instructions: ADD, AND, OR, SUB
	  .nlist
3$:	S_TYP2	$Error
	.endif

	.ifne .S_TYP3.
	  .list
	  .page
	.sbttl	Type S_TYP3 Instructions: ADDA, CMPA, SUBA
	  .nlist
4$:	S_TYP3	$Error
	.endif

	.ifne .S_TYP4.
	  .list
	  .page
	.sbttl	Type S_TYP4 Instructions: ADDI, ANDI, CMPI, EORI, ORI, SUBI
  	  .nlist
5$:	S_TYP4	$Error
	.endif

	.ifne .S_TYP5.
	  .list
	  .page
	.sbttl	Type S_TYP5 Instructions: ADDQ, SUBQ
	  .nlist
6$:	S_TYP5	$Error
	.endif

	.ifne .S_TYP6.
	  .list
	  .page
	.sbttl	Type S_TYP6 Instructions: DIVS, DIVU, MULS, MULU
    	  .nlist
7$:	S_TYP6	$Error
	.endif

	.ifne .S_TYP7.
	  .list
	  .page
	.sbttl	Type S_TYP7 Instructions: CLR, TST
	  .nlist
8$:	S_TYP7	$Error
	.endif

	.ifne .S_TYP8.
	  .list
	  .page
	.sbttl	Type S_TYP8 Instructions: JMP, JSR, LEA, PEA
	  .nlist
9$:	S_TYP8	$Error
	.endif

	.ifne .S_TYP9.
	  .list
	  .page
	.sbttl	Type S_TYP9 Instructions: BYTEREV, BITREV, FF1, NEG, NEGX, NOT, SATS, SWAP
	  .nlist
10$:	S_TYP9	$Error
	.endif

	.ifne .S_TAS.
	  .list
	  .page
	.sbttl	Type S_TAS Instructions: TAS, WDDATA
	  .nlist
11$:	S_TAS	$Error
	.endif

	.ifne .S_SHFT.
	  .list
	  .page
	.sbttl	Type S_SHFT Instructions: ASL, ASR, LSL, LSR
	  .nlist
12$:	S_SHFT	$Error
	.endif

	.ifne .S_BCC.
	  .list
	  .page
	.sbttl	Type S_BCC Instructions: BRA, BSR, Plus Conditional Branches
	  .nlist
13$:	S_BCC	$Error
	.endif

	.ifne .S_SCC.
	  .list
	  .page
	.sbttl	Type S_SCC Instructions: ST, SF, Plus Conditional Branches
	  .nlist
14$:	S_SCC	$Error
	.endif

	.ifne .S_BIT.
	  .list
	  .page
	.sbttl	Type S_BIT Instructions: BCHG, BCLR, BSET, BTST
	  .nlist
15$:	S_BIT	$Error
	.endif

	.ifne .S_MOV3Q.
	  .list
	  .page
	.sbttl	Type S_MOV3Q Instructions: MOV3Q
	  .nlist
16$:	S_MOV3Q	$Error
	.endif

	.ifne .S_MOVE.
	  .list
	  .page
	.sbttl	Type S_MOVE Instructions: MOVE
	  .nlist
17$:	S_MOVE	$Error
	.endif

	.ifne .S_MOVEA.
	  .list
	  .page
	.sbttl	Type S_MOVEA Instructions: MOVEA
	  .nlist
18$:	S_MOVEA	$Error
	.endif

	.ifne .S_MOVEC.
	  .list
	  .page
	.sbttl	Type S_MOVEC Instructions: MOVEC
	  .nlist
19$:	S_MOVEC	$Error
	.endif

	.ifne .S_MOVEM.
	  .list
	  .page
	.sbttl	Type S_MOVEM Instructions: MOVEM
	  .nlist
20$:	S_MOVEM	$Error
	.endif

	.ifne .S_MOVEQ.
	  .list
	  .page
	.sbttl	Type S_MOVEQ Instructions: MOVEQ
	  .nlist
21$:	S_MOVEQ	$Error
	.endif

	.ifne .S_MVSZ.
	  .list
	  .page
	.sbttl	Type S_MVSZ Instructions: MVS, MVZ
	  .nlist
22$:	S_MVSZ	$Error
	.endif

	.ifne .S_EOR.
	  .list
	  .page
	.sbttl	Type S_EOR Instructions: EOR
	  .nlist
23$:	S_EOR	$Error
	.endif

	.ifne .S_EXT.
	  .list
	  .page
	.sbttl	Type S_EXT Instructions: EXT
	  .nlist
24$:	S_EXT	$Error
	.endif

	.ifne .S_LINK.
	  .list
	  .page
	.sbttl	Type S_LINK Instructions: LINK
	  .nlist
25$:	S_LINK	$Error
	.endif

	.ifne .S_STOP.
	  .list
	  .page
	.sbttl	Type S_STOP Instructions: STOP
 	  .nlist
26$:	S_STOP	$Error
	.endif

	.ifne .S_TRAP.
	  .list
	  .page
	.sbttl	Type S_TRAP Instructions: TRAP
	  .nlist
27$:	S_TRAP	$Error
	.endif

	.ifne .S_TPF.
	  .list
	  .page
	.sbttl	Type S_TPF Instructions: TPF
	  .nlist
29$:	S_TPF	$Error
	.endif

	.ifne .S_UNLK.
	  .list
	  .page
	.sbttl	Type S_UNLK Instructions: UNLK
	  .nlist
30$:	S_UNLK	$Error
	.endif

	.ifne .S_INH.
	  .list
	  .page
	.sbttl	Type S_INH Instructions: HALT, ILLEGAL, NOP, PULSE, RTE, RTS
	  .nlist
31$:	S_INH	$Error
	.endif

	.ifne .S_CAS.
	  .list
	  .page
	.sbttl	Type S_CAS Instructions: CAS
	  .nlist
32$:	S_CAS	$Error
	.endif

	.ifne .S_CAS2.
	  .list
	  .page
	.sbttl	Type S_CAS2 Instructions: CAS2
	  .nlist
33$:	S_CAS2	$Error
	.endif

	.ifne .S_CHK.
	  .list
	  .page
	.sbttl	Type S_CHK Instructions: CHK
	  .nlist
34$:	S_CHK	$Error
	.endif

	.ifne .S_CHK2.
	  .list
	  .page
	.sbttl	Type S_CHK2 Instructions: CHK2
	  .nlist
35$:	S_CHK2	$Error
	.endif

	.ifne .S_CMP.
	  .list
	  .page
	.sbttl	Type S_CMP Instructions: CMP
	  .nlist
36$:	S_CMP	$Error
	.endif

	.ifne .S_SHL.
	  .list
	  .page
	.sbttl	Type S_SHL Instructions: CPUSHL
	  .nlist
37$:	S_SHL	$Error
	.endif

	.ifne .S_TCH.
	  .list
	  .page
	.sbttl	Type S_TCH Instructions: INTOUCH
	  .nlist
38$:	S_TCH	$Error
	.endif

	.ifne .S_REM.
	  .list
	  .page
	.sbttl	Type S_REMS Instructions: REMS, REMU
	  .nlist
39$:	S_REM	$Error
	.endif

	.ifne .S_STLD.
	  .list
	  .page
	.sbttl	Type S_STLD Instructions: STRLDR
	  .nlist
40$:	S_STLD	$Error
	.endif

	.ifne .S_WDB.
	  .list
	  .page
	.sbttl	Type S_WDB Instructions: WDEBUG
	  .nlist
41$:	S_WDB	$Error
	.endif

	.ifne .B_XPC.
	  .list
	  .page
	.sbttl	External Label Branching Tests
	  .nlist
42$:	B_XPC	$Error
	.endif

	.ifne .M_MAC.
	  .list
	  .page
	.sbttl	Type M_MAC Instructions: MAC, MSAC, MAAAC, MASAC, MSAAC, MSSAC
	  .nlist
43$:	M_MAC	$Error
	.endif

	.ifne .M_MCLR.
	  .list
	  .page
	.sbttl	Type M_MCLR Instructions: MOVCLR
	  .nlist
44$:	M_MCLR	$Error
	.endif

	.ifne .F_TYP1.
	  .list
	  .page
	.sbttl	Type F_TYP1 Instructions: FABS, FINT, FINTRZ, FNEG, FSQRT
	  .nlist
45$:	F_TYP1	$Error
	.endif

	.ifne .F_TYP2.
	  .list
	  .page
	.sbttl	Type F_TYP2 Instructions: FADD, FCMP, FDIV, FMUL, FSUB
	  .nlist
46$:	F_TYP2	$Error
	.endif

	.ifne .F_TST.
	  .list
	  .page
	.sbttl	Type F_TST Instructions: FTST
	  .nlist
47$:	F_TST	$Error
	.endif

	.ifne .F_MOV.
	  .list
	  .page
	.sbttl	Type F_MOV Instructions: FMOVE
	  .nlist
48$:	F_MOV	$Error
	.endif

	.ifne .F_MOVM.
	  .list
	  .page
	.sbttl	Type F_MOVM Instructions: FMOVEM
	  .nlist
49$:	F_MOVM	$Error
	.endif

	.ifne .F_BCC.
	  .list
	  .page
	.sbttl	Type F_BCC Instructions: FBcc
	  .nlist
50$:	F_BCC	$Error
	.endif

	.ifne .F_NOP.
	  .list
	  .page
	.sbttl	Type F_NOP Instructions: FNOP
	  .nlist
51$:	F_NOP	$Error
	.endif

	.ifne .F_SVRS.
	  .list
	  .page
	.sbttl	Type F_SVRS Instructions: FSAVE, FRESTORE
	  .nlist
52$:	F_SVRS	$Error
	.endif

	.ifne .SRCCHK.
	  .list
	  .page
	.sbttl	Source Addressing Mode Checks
	  .nlist
53$:	SRCCHK
	.endif

	.end
