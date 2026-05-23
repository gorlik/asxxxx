/* ST9.h */

/*
 *  Copyright (C) 2026  Alan R. Baldwin
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 *
 * Alan R. Baldwin
 * 721 Berkeley St.
 * Kent, Ohio  44240
 * 
 */

/*)BUILD
	$(PROGRAM) =	ASST9
	$(INCLUDE) = {
		ASXXXX.H
		ST9.H
	}
	$(FILES) = {
		ST9MCH.C
		ST9ADR.C
		ST9PST.C
		ASMAIN.C
		ASMCRO.C
		ASDBG.C
		ASLEX.C
		ASSYM.C
		ASSUBR.C
		ASEXPR.C
		ASDATA.C
		ASLIST.C
		ASOUT.C
	}
	$(STACK) = 3000
*/

/*
 * Addressing Modes - addr()
 */
/* Immediate and External */
#define	S_IMM		40
#define	S_SHORT		41
#define	S_LONG		42
/* Working Register - rn, n=0-15 */
/* r, (r), N(r), (r)+ */
/* KEEP ORDER */
#define	S_WR		43
#define	S_IWR		44
#define	S_IWRN		45
#define	S_IWRP1		46
/* Working Register Pairs - rn, n=0,2,...,14 */
/* rr, (rr), N(rr), NN(rr), (rr)+, -(rr), rr(rrx) */
/* KEEP ORDER */
#define	S_WRR		47
#define	S_IWRR		48
#define	S_IWRRNS	49
#define	S_IWRRNL	50
#define	S_IWRRP1	51
#define	S_IWRRM1	52
#define	S_IWRRX		53
/* Direct Working Register - Rn, n=0-255, except 208-222 */
/* R */
/* KEEP ORDER */
#define	S_DR		54
/* Direct Working Register - RRn, n=0-255 */
/* (R) */
#define	S_IDR		55
/* Direct Working Register Pairs - RRn, n=0,2,4,...,254, except 208-222 */
/* RR */
#define	S_DRR		56
/* Direct Working Register Pairs - RRn, n=0,2,4,...,254 */
/* N(RR), NN(RR) */
#define	S_IDRR		57
#define	S_IDRRNS	58
#define	S_IDRRNL	59

/*
 * Bit Addressing Modes - addr_b()
 */
/* r.b, r.!b */
#define	S_WRB		60
#define	S_WRBC		61
/* (rr).b, (rr).!b */
#define	S_IWRRB		62
#define	S_IWRRBC	63

/*
 * Merge Modes
 */

#define	M_SEG		0x0100		/* Segment Adressing */
#define	M_SPP		0x0200		/* SPP */
#define	M_SRP		0x0300		/* SRP, SRP0, SRP1 */
#define	M_BXXX		0x0400		/* BAND, BCPL, BLD, BOR, BRES */
					/* BSET, BTJF, BTJT, BTSET,BXOR */

/*
 * Instruction types
 */
/* OR,  AND,  SBC,  ADC,  ADD,  SUB,  XOR,  TCM,  CP,  TM */
#define	I_TYP1		40
/* ORW, ANDW, SBCW, ADCW, ADDW, SUBW, XORW, TCMW, CPW, TMW */
#define	I_TYP2		41
/* LD, LDW */
#define	I_LD		42
#define	I_LDW		43

#define	I_BAND		44
#define	I_BCPL		45
#define	I_BLD		46
#define	I_BOR		47
#define	I_BRES		48
#define	I_BSET		49
#define	I_BTSET		50
#define	I_BXOR		51
#define	I_BTJF		52
#define	I_BTJT		53

#define	I_CALL		54
#define	I_CALLS		55
#define	I_CLR		56
#define	I_CPJFI		57
#define	I_CPJTI		58
#define	I_CPL		59

#define	I_DA		60
#define	I_DEC		61
#define	I_DECW		62
#define	I_DIV		63
#define	I_DIVWS		64
#define	I_DJNZ		65
#define	I_DWJNZ		66

#define	I_EXT		67

#define	I_HALT		68

#define	I_INC		69
#define	I_INCW		70
/* CCF, DI, EI, IRET, NOP, RCF, RET, SCF, SDM, SPM */
#define	I_INH		71

#define	I_JP		72
#define	I_JPS		73
#define	I_JPCC		74
#define	I_JRCC		75


#define	I_LDPP		76
#define	I_LDDP		77
#define	I_LDPD		78
#define	I_LDDD		79
#define	I_LINK		80
#define	I_LINKU		81

#define	I_MUL		82

#define	I_PEA		83
#define	I_PEAU		84

#define	I_POP		85
#define	I_POPU		86
#define	I_POPUW		87
#define	I_POPW		88

#define	I_PUSH		89
#define	I_PUSHU		90
#define	I_PUSHUW	91
#define	I_PUSHW		92

#define	I_RETS		93
#define	I_RLC		94
#define	I_RLCW		95
#define	I_ROL		96
#define	I_ROR		97
#define	I_RRC		98
#define	I_RRCW		99

#define	I_SLA		100
#define	I_SLAW		101
#define	I_SPP		102
#define	I_SRA		103
#define	I_SRAW		104
#define	I_SRP		105
#define	I_SRP0		106
#define	I_SRP1		107
#define	I_SWAP		108

#define	I_UNLINK	109
#define	I_UNLINKU	110
#define	I_WFI		111
#define	I_XCH		112


struct adsym
{
	char	a_str[4];	/* addressing string */
	int	a_val;		/* addressing mode value */
};

extern	struct	adsym	CND[];


	/* machine dependent functions */

        /* st9adr.c */
extern	int		aindx;
extern	int		addr(struct expr *esp);
extern	int		addx(struct expr *esp);
extern	int		addr_b(struct expr *esp);
extern	int		addx_b(struct expr *esp);
extern	int		rgmode(void);
	/* st9mch.c */
extern	void		machine(struct mne *mp);
extern	int		mchpcr(struct expr *esp, int *v, int n);
extern	void		minit(void);
extern	int		valu_err(struct expr *e, int n);

