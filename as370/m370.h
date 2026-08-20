/* m370.h */

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
	$(PROGRAM) =	ASxxxx
	$(INCLUDE) = {
		ASXXXX.H
		M370.H
	}
	$(FILES) = {
		M370MCH.C
		M370PST.C
		M370ADR.C
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
 * Addressing Types
 */
#define	S_A	35		/* A */
#define	S_B	36		/* B */
#define	S_SP	37		/* SP */
#define	S_ST	38		/* ST */
#define	S_NB	39		/*  N(B) /  Label(B) */
#define	S_ANB	40		/* *N(B) / *Label(B) */
#define	S_NSP	41		/* N(SP) */
#define	S_ILL	42		/* Illegal */
#define	S_R	43		/* Rn, n = 0-255 */
#define	S_P	44		/* Pn, n = 0-255 */
#define	S_IR	45		/* @Rn */
#define	S_NR	46		/* N(Rn) */
#define	S_IMM	47		/* #__ */
#define	S_EXT	48		/*  N or  Label */
#define	S_AEXT	49		/* *N or *Label */

/*
 * Instruction types.
 */
#define	I_TYP1	50		/* AND, OR, XOR, BTJO, BTJZ */
#define	I_TYP2	51		/* ADD, ADC, DUB, SBB, MPY, CMP, DAC, DSB */
#define	I_TYP3	52		/* DEC, INC, INV, CLR, XCHB, SWAP, PUSH */		
				/* POP, DJNZ, COMPL, RR, RRC, RL, RLC */
#define	I_MOV	53		/* MOV */
#define	I_MOVW	54		/* MOVW */
#define	I_DIV	55		/* DIV */
#define	I_INCW	56		/* INCW */
#define	I_JMP	57		/* JMP, JN, JEQ, JZ, JC, JP, JPZ, JNE, JNZ */
				/* JNC, JV, JL, JLE, JHS, JNV, JGE, JG, JLO */
#define	I_CALL	58		/* CALL, BR */
#define	I_CALLR	59		/* CALLR, JMPL */
#define	I_TRAP	60		/* TRAP */
#define	I_LDST	61		/* LDST */
#define	I_BITS	62		/* SBIT0, SBIT1, CMPBIT, JBIT1, JBIT0 */
#define	I_INH	63		/* CLRC, TSTA, IDLE, SETC, RTS, RTI */
				/* LDSP, STSP, NOP */
#define	I_INH2	64		/* DINT, EINT, EINTH, EINTL */

/*
 * Extended Addressing Modes
 */
#define	M_TRAP	0x0100		/* TRAP */


struct adsym
{
	char	a_str[4];	/* addressing string */
	int	a_val;		/* addressing mode value */
};

extern	struct	adsym	reg[];


	/* machine dependent functions */

	/* m370mch.c */
extern	void		exprps(char *pre, struct expr *esp, char *suf);
extern	void		machine(struct mne *mp);
extern	int		mchpcr(struct expr *esp, int *v, int n);
extern	void		minit(void);

	/* m370adr.c */
extern	int		addr(struct expr *esp);
extern	int		aindx;
extern	int		Rn(void);
extern	int		Pn(void);
extern	int		RnPn(int rp);
extern	int		admode(struct adsym *sp);
extern	int		srch(char *str);

