/* rs08.h */

/*
 *  Copyright (C) 2021-2025  Alan R. Baldwin
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
	$(PROGRAM) =	ASRS08
	$(INCLUDE) = {
		ASXXXX.H
		RS08.H
	}
	$(FILES) = {
		RS08MCH.C
		RS08ADR.C
		RS08PST.C
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

struct adsym
{
	char	a_str[4];	/* addressing string */
	int	a_val;		/* addressing mode value */
};

/*
 * Addressing types
 */
#define	S_A	40
#define	S_X	41
#define	S_IX	42
#define	S_DIX	43
#define	S_IMM	44
#define	S_TNY	45
#define	S_SRT	46
#define	S_FRC	47
#define	S_DIR	48
#define	S_EXT	49

/*
 * Instruction types
 */
#define	S_TYP1	50
#define	S_TYP2	51
#define	S_TYP3	52
#define	S_TYP4	53
#define	S_BRA	54
#define	S_BRN	55
#define S_JMP	56
#define	S_BIT	57
#define	S_BBIT	58
#define	S_CBEQ	59
#define	S_CBEQA	60
#define	S_CBEQX	61
#define	S_DBNZ	62
#define	S_DBNZA	63
#define	S_DBNZX	64
#define	S_MOV	65
#define	S_LDX	66
#define	S_STX	67
#define	S_TST	68
#define	S_TSTX	69
#define	S_INH	70
#define	S_INH2	71
#define	S_TYP5	72

/*
 * Extended Addressing Modes
 */
#define	R_3BIT	0x0100		/* 3-Bit Addressing Mode */
#define	R_4BIT	0x0200		/* 4-Bit Addressing Mode */
#define	R_5BIT	0x0300		/* 5-Bit Addressing Mode */

	/* machine dependent functions */

	/* rs08adr.c */
extern	struct	adsym	ax[];
extern	int		addr(struct expr *esp);
extern	int		admode(struct adsym *sp);
extern	int		srch(char *str);

	/* rs08mch.c */
extern	void		machine(struct mne *mp);
extern	int		mchpcr(struct expr *esp, int *v, int n);
extern	void		minit(void);

