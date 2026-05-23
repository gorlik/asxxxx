/* ez8.h */

/*
 *  Copyright (C) 2022-2025  Alan R. Baldwin
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
	$(PROGRAM) =	ASEZ8
	$(INCLUDE) = {
		ASXXXX.H
		EZ8.H
	}
	$(FILES) = {
		EZ8MCH.C
		EZ8ADR.C
		EZ8PST.C
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
 * Indirect Addressing delimeters
 */
#define	LFIND	'('
#define RTIND	')'

/*
 * Offset Indexing modes
 */
#define	S_OFR		0x10
/*
 *	S_OFR0		0x10	==>>	16
 *	S_OFR1		0x11
 *	...
 *	S_OFR14		0x1E
 *	S_OFR15		0x1F	==>>	31
 */
#define	S_OFRR		0x20
/*
 *	S_OFRR0		0x20	==>>	32
 *	S_OFRR1		0x21
 *	...
 *	S_OFRR14	0x2E
 *	S_OFRR15	0x2F	==>>	47
 */
#define	S_INDM	0xF0

/*
 * Symbol types
 */
#define	S_IMMED	50
#define	S_R	51
#define	S_RR	52

#define	S_IR	53
#define	S_IRR	54
#define	S_IRRR	55
#define	S_INDX	56

#define	S_EXT	57

/*
 * Basic Z8 Instruction types
 */
#define	S_SOP	60
#define	S_DOP	61
#define	S_INC	62
#define	S_INCW	63
#define	S_DECW	64
#define	S_LD	65
#define	S_LDCE	66
#define	S_LDCEI	67
#define	S_DJNZ	68
#define	S_JR	69
#define	S_JP	70
#define	S_CALL	71
#define	S_SRP	72
#define	S_INH	73

/*
 * Additional eZ8 Instruction types
 */
#define	S_PUPOX	80
#define	S_DOPX	81
#define	S_LDX	82
#define	S_LDWX	83
#define	S_LEA	84
#define	S_BIT	85
#define  O_BIT 0
#define	 O_CLR 1
#define	 O_SET 2
#define	S_BSWAP	86
#define	S_TRAP	87
#define	S_MUL	88
#define	S_BTJ	89
#define	 O_BTJ 0
#define	 O_NZ  1
#define	 O_Z   2

/*
 * eZ8 Page 2 Definition
 */
#define	 O_PG2 0x1F

/*
 * Merge Modes
 */
#define	R_L1U7	0x0100		/* Low  1 Bit  Up 7 Bits */
#define	R_3BIT	0x0200		/* Mask 3 Bits */
#define	R_L3U4	0x0300		/* Low  3 Bits Up 4 Bits */
#define	R_7BIT	0x0400		/* Mask 7 Bits */
#define	R_L12	0x0500		/* Low 12 Bits */
#define	R_LU8	0x0600		/* Low  8 Bits To Upper  8 Bits */
#define	R_LU12	0x0700		/* Low 12 Bits To Upper 12 Bits */


struct adsym
{
	char	a_str[8];	/* addressing string */
	int	a_val;		/* addressing mode value */
};

extern	struct	adsym	R[];
extern	struct	adsym	RR[];
extern	struct	adsym	RRR[];
extern	struct	adsym	CND[];

	/* machine dependent functions */

	/* ez8adr.c */
extern	int		addr(struct expr *esp);
extern	int		admode(struct adsym *sp);
extern	int		srch(char *str);

	/* ez8mch.c */
extern	void		argchk(int a, int v, int r);
extern	void		machine(struct mne *mp);
extern	int		mchpcr(struct expr *esp, int *v, int n);
extern	int		mchoptn(char *id, int v);
extern	void		minit(void);

