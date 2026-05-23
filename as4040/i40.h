/* i40.h */

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
	$(PROGRAM) =	AS4040
	$(INCLUDE) = {
		ASXXXX.H
		I40.H
	}
	$(FILES) = {
		I40MCH.C
		I40PST.C
		I40ADR.C
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
 * Symbol types.
 */
#define	S_I04	40		/* Single Byte 4004 Instructions */
#define	S_JCN	41		/* Jump On Condition */
#define	S_FIM	42		/* Fetch Immediate */
#define	S_SRC	43		/* Send Register Control */
#define	S_FIN	44		/* Fetch Indirect From ROM */
#define	S_JIN	45		/* Jump Indirect */
#define	S_JUN	46		/* Jump Unconditional */
#define	S_JMS	47		/* Jump To Subroutine */
#define	S_INC	48		/* Increment */
#define	S_ISZ	49		/* Increment And Skip Jump On Zero */
#define	S_ADD	50		/* Add Register To Accumulator */
#define	S_SUB	51		/* Subtract Register From Accumulator */
#define	S_LD	52		/* Load Accumulator From Register */
#define	S_XCH	53		/* Exchange Register With Accumulator */
#define	S_BBL	54		/* Return From Subroutine and Load Accumulator */
#define	S_LDM	55		/* Load Accumulator With Data */
#define	S_JCC	56		/* Optional Jump On Condition */

#define	S_I40	57		/* Single Byte 4040 Instructions */

/*
 * CPU Types
 */
#define	S_CPU	58		/* CPU Type */
#define	S_4040	0		/* 4040 Processor */
#define	S_4004	1		/* 4004 Processor */

/*
 * Addressing Modes
 */
#define	S_IMM	30
#define	S_REG	31
#define	S_REGP	32
#define	S_EXT	33
#define	S_CC	34

/*
 * Extended Addressing Modes
 */
#define	R_3BIT	0x0100		/* ------------xxx- */
#define	R_4BIT	0x0200		/* ------------xxxx */
#define	R_12BIT	0x0300		/* ----xxxxxxxxxxxx */


struct adsym
{
	char	a_str[6];	/* addressing string */
	int	a_val;		/* addressing mode value */
};

	/* machine dependent functions */

	/* i40adr.c */
extern	struct adsym	reg[];
extern	struct adsym	regp[];
extern	struct adsym	cc[];
extern	int		addr(struct expr *esp);
extern	int		admode(struct adsym *sp);
extern	int		srch(char *str);

	/* i40mch.c */
extern	int		cputype;
extern	void		machine(struct mne *mp);
extern	void		minit(void);

