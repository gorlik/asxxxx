/* pdp11.h */

/*
 *  Copyright (C) 2022-2025  Alan R. Baldwin
 *  Copyright (C) 2022-2025  Nick Downing
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
 */

/*)BUILD
	$(PROGRAM) =	ASPDP11
	$(INCLUDE) = {
		ASXXXX.H
		PDP11.H
	}
	$(FILES) = {
		PDP11MCH.C
		PDP11ADR.C
		PDP11PST.C
		PDP11CYC.C
		PDP11FPP.C
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
 * Opcode Cycle Definitions
 */
#define	OPCY_SDP	0x7FFF
#define	OPCY_ERR	0x7FFE

#define	UN	CYCL_NONE

/*
 * Addressing types
 */

/*
 * Modifier to "OR" with one of the modes.
 *       (Values Are In Octal)
 */
#define	S_IND	010

#define S_REG	000
#define	S_INC	020
#define	S_DEC	040
#define S_IDX	060

/*
 * Shorthand For 7 | S_IND [ (PC)+ ]
 */
#define S_IMM	027

/*
 * Shorthand For 7 | S_IND | S_INC [ @(PC)+ ]
 */
#define S_SYM	037

/*
 * Floating Point Register Bit
 */
#define	S_FPR	010

/*
 * Basic PDP11 Instruction Types
 */
#define S_DOUBLE	50
#define S_SINGLE	51
#define S_BRANCH	52
#define S_INH		53
#define S_RXX		54	/* JSR, XOR, and EIS Instructions */
#define S_XXR		55	/* RTS and FIS Instructions */
#define	S_MARK		56
#define S_SOB		57
#define S_SPL		58
#define S_SWI		59	/* EMT and TRAP Instructions */
#define	S_CIS		60
#define	S_RTS		61
#define	S_LXDN		62

/*
 * Assembler Options
 */
#define	S_RAD50		65	/* Radix-50 Directive */

/*
 * Extended and Floating Point Instructions
 */
#define S_FXXX		70	/* FSRC or FDST */
#define	S_ACDST		71	/* AC,DST */
#define	S_SRCAC		72	/* SRC,AC */
#define	S_ACFDST	73	/* AC,FRSC */
#define	S_FSRCAC	74	/* FSRC,AC */

#define D_FXXX		75	/* FSRC or FDST */
#define	D_ACDST		76	/* AC,DST */
#define	D_SRCAC		77	/* SRC,AC */
#define	D_ACFDST	78	/* AC,FRSC */
#define	D_FSRCAC	79	/* FSRC,AC */

#define	S_FIS		80	/* FIS Instructions */

#define	S_INT32		81	/* 32-Bit Integer */

#define	W_FLT16		82	/* 16-Bit Floating Point */
#define	S_FLT32		83	/* 32-Bit Floating Point */
#define	D_FLT64		84	/* 64-Bit Floating Point */

/*
 * Alternate and Additional Instructions
 *     From Bell Laboratories V7 Unix
 */
#define S_JBR		90
#define S_JCOND		91

#define	S_MOVF		92

/*
 * Extended Addressing Modes
 */
#define	R_3BIT	0x0100	/* 3-Bit Addressing Mode */
#define	R_6BIT	0x0200	/* 6-Bit Addressing Mode */
#define	R_8BIT	0x0300	/* 8-Bit Branching Address */

/*
 * Variables
 */
struct adsym
{
	char	a_str[4];	/* addressing string */
	int	a_val;		/* addressing mode value */
};



	/* machine dependent functions */

	/* pdp11adr.c */
extern	struct adsym	reg[];
extern	int		aindx;
extern	int		pcrel;
extern	int		addr(struct expr *esp);
extern	int		rad50(void);
extern	int		tst50(int c);
extern	int		admode(struct adsym *sp);
extern	int		any(int c, char *str);
extern	int		srch(char *str);

	/* pdp11mch.c */
extern	int		rtyp;
extern	void		machine(struct mne *mp);
extern	int		mchpcr(struct expr *esp, int *v, int n);
extern	int		setbit(int b);
extern	int		getbit(void);
extern	int		mchterm(struct expr *esp);
extern	int		mchoptn(char *id, int v);
extern	void		minit(void);

	/* pdp11cyc.c */
extern	int		mchcycles(struct mne *mp, a_uint opcode, int cycles);
extern	int		mclookup(struct mne *mp);


	/* pdp11fpp.c */
extern	int		fpt;
extern	unsigned int	rslt[4];
extern	void		atowrd(void);
extern	void		atoflt(void);
extern	void		atodbl(void);
extern	int		atofd(int fd);
extern	void		fltsv(void);
extern	void		fltrs(void);
extern	void		fltls(void);
extern	void		fltm54(void);
extern	void		fltm5(void);
extern	void		fltad(void);

