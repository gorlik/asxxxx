/* cop8.h */

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
	$(PROGRAM) =	ASCOP8
	$(INCLUDE) = {
		ASXXXX.H
		COP8.H
	}
	$(FILES) = {
		COP8MCH.C
		COP8PST.C
		COP8ADR.C
		ASMAIN.C
		ASDBG.C
		ASLEX.C
		ASSYM.C
		ASSUBR.C
		ASEXPR.C
		ASMCRO.C
		ASDATA.C
		ASLIST.C
		ASOUT.C
	}
	$(STACK) = 3000
*/

/*
 * Symbol Types
 */
#define	S_TYP1	40		/* ADD, ... */
#define	S_TYP2	41		/* CLR, ... */
#define	S_TYP3	42		/* IFBIT, ... */
#define	S_DRSZ	43		/* DRSZ */
#define	S_IFBNE	44		/* IFBNE */
#define	S_JMP	45		/* JMP, ... */
#define	S_JMPL	46		/* JMPL, ... */
#define	S_JP	47		/* JP */
#define	S_LD	48		/* LD */
#define	S_XCHNG	49		/* X */
#define	S_INH	50		/* Inherent */

/*
 * Addressing Modes
 */
#define	S_IMM	60
#define	S_REGA	61
#define	S_REGN	62
#define	S_IDX	63
#define	S_EXT	64

/*
 * Registers
 */
#define	S_A	0		/* A */
#define	S_X	12		/* X */
#define	S_SP	13		/* SP */
#define	S_B	14		/* B */
#define	S_S	15		/* S */

/*
 * Indexed Registers: [ ]
 */
#define	S_IBP1	0x0A		/* B+ */
#define	S_IBM1	0x0B		/* B- */
#define	S_IB	0x0E		/* B */
#define	S_IXP1	0x1A		/* X+ */
#define	S_IXM1	0x1B		/* X- */
#define	S_IX	0x1E		/* X */

/*
 * Set Direct Pointer
 */
#define	S_SDP	90
#define	S_PGD	91

/*
 * Extended Instructions
 */
#define	S_XTND	92

/*
 * Extended Addressing Modes
 */
#define	R_3BIT	0x0100		/* -----xxx */
#define	R_4BIT	0x0200		/* ----xxxx */
#define	R_12BIT	0x0300		/* ----xxxxxxxxxxxx */

struct adsym
{
	char	a_str[6];	/* addressing string */
	int	a_val;		/* addressing mode value */
};

	/* machine dependent functions */

	/* cop8adr.c */
extern	struct adsym	rega[];
extern	struct adsym	regn[];
extern	struct adsym	regx[];
extern	int		addr(struct expr *esp);
extern	int		admode(struct adsym *sp);
extern	int		srch(char *str);

	/* cop8mch.c */
extern	void		icheck(unsigned int op);
extern	void		machine(struct mne *mp);
extern	int		mchpcr(struct expr *esp, int *v, int n);
extern	void		minit(void);
extern	void		setgbl(struct expr *esp);

