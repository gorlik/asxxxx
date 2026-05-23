/* cop4.h */

/*
 *  Copyright (C) 2023-2025  Alan R. Baldwin
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
	$(PROGRAM) =	ASCOP4
	$(INCLUDE) = {
		ASXXXX.H
		COP4.H
	}
	$(FILES) = {
		COP4MCH.C
		COP4PST.C
		COP4ADR.C
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
#define	S_INH1	40		/* Single Byte Inherent Instructions */
#define	S_INH2	41		/* Double Byte Inherent Instructions */
#define	S_IMY1	42		/* Single Byte Immediate Instructions */
#define	S_IMY2	43		/* Double Byte Immediate Instructions */
#define	S_RAM1	44		/* Single Byte RAM Access Instructions */
#define	S_RAM2	45		/* Double Byte RAM Access Instructions */
#define	S_SKZ1	46		/* Single Byte Skip On Z Instructions */
#define	S_SKZ2	47		/* Double Byte Skip On Z Instructions */
#define	S_JMP	48		/* JMP Instruction */
#define	S_JP	49		/* Jump Within Current Page */
#define	S_JP23	50		/* Jump Within Current Pages 2 and 3 */
#define	S_JSR	51		/* JSR Instruction */
#define	S_JSRP	52		/* JSR To A Page 2 Subroutine */
#define	S_RMB	53		/* Reset RAM Bit */
#define	S_SMB	54		/* Clear RAM Bit */
#define	S_LBI	55		/* Load B Immediate */

/*
 * Special XAD Format
 */
#define	S_XAD	56

/*
 * Set Direct Pointer
 */
#define	S_SPG	90

/*
 * Set CPU Type
 */
#define	S_COP	91

/*
 * ROM Types
 */
#define	S_ROM	92
#define	S_256	0		/* 256	Byte ROM */
#define	S_512	1		/* 512	Byte ROM */
#define	S_1024	2		/* 1024	Byte ROM */
#define	S_2048	3		/* 2048	Byte ROM (Default) */

/*
 * Addressing Modes
 */
#define	S_IMM	30
#define	S_REG	31
#define	S_EXT	32

/*
 * Extended Addressing Modes
 */
#define	R_2BIT	0x0100		/* --xx---- */
#define	R_4BIT	0x0200		/* ----xxxx */
#define	R_6BIT	0x0300		/* --xxxxxx */
#define R_7BIT	0x0400		/* -xxxxxxx */
#define R_8BIT	0x0500		/* xxxxxxxx */
#define	R_9BIT	0x0600		/* -------xxxxxxxxx */
#define	R_10BIT	0x0700		/* ------xxxxxxxxxx */
#define	R_11BIT	0x0800		/* -----xxxxxxxxxxx */

/*
 * Processor Core Dependent Instructions
 */
#ifdef	LONGINT
	  /* Arithmetic */
#define	I_ADT	0x00000001l	
#define	I_CASC	0x00000002l
#define	I_OR	0x00000004l
	  /* Transfer */
#define	I_HALT	0x00000008l
#define	I_IT	0x00000010l
	  /* Memory */
#define	I_CEMA	0x00000020l
#define	I_CAME	0x00000040l
#define	I_CTMA	0x00000080l
#define	I_CAMT	0x00000100l
#define	I_CQMA	0x00000200l
#define	I_LDD	0x00000400l
#define	I_LID	0x00000800l
#define	I_LQID	0x00001000l
#define	I_XAD	0x00002000l
	  /*  Register */
#define	I_XABR	0x00002000l
#define	I_XAN	0x00004000l
	  /* Test */
#define	I_SKT	0x00008000l
#define	I_SKSZ	0x00010000l
	  /* Input/Output */
#define	I_CAMR	0x00020000l
#define	I_INH	0x00040000l
#define	I_ININ	0x00080000l
#define	I_INIL	0x00100000l
#define	I_INR	0x00200000l
#define	I_OMH	0x00400000l

#else
	  /* Arithmetic */
#define	I_ADT	0x00000001	
#define	I_CASC	0x00000002
#define	I_OR	0x00000004
	  /* Transfer */
#define	I_HALT	0x00000008
#define	I_IT	0x00000010
	  /* Memory */
#define	I_CEMA	0x00000020
#define	I_CAME	0x00000040
#define	I_CTMA	0x00000080
#define	I_CAMT	0x00000100
#define	I_CQMA	0x00000200
#define	I_LDD	0x00000400
#define	I_LID	0x00000800
#define	I_LQID	0x00001000
#define	I_XAD	0x00002000
	  /* Register */
#define	I_XABR	0x00004000
#define	I_XAN	0x00008000
	  /* Test */
#define	I_SKT	0x00010000
#define	I_SKSZ	0x00020000
	  /* Input/Output */
#define	I_CAMR	0x00040000
#define	I_INH	0x00080000
#define	I_ININ	0x00100000
#define	I_INIL	0x00200000
#define	I_INR	0x00400000
#define	I_OMH	0x00800000
#endif

struct cop
{
	char *	a_str;		/* CPU Type String */
	a_uint	a_val;		/* Invalid Instruction Specification */
	int	a_size;		/* CPU ROM Size */
};

struct adsym
{
	char	a_str[6];	/* addressing string */
	int	a_val;		/* addressing mode value */
};

	/* machine dependent functions */

	/* cop4adr.c */
extern	struct adsym	reg[];
extern	int		addr(struct expr *esp);
extern	int		admode(struct adsym *sp);
extern	int		srch(char *str);

	/* cop4pst.c */
extern	struct cop	cop[];

	/* cop4mch.c */
extern	int		coptype(void);
extern	void		icheck(unsigned int op);
extern	void		machine(struct mne *mp);
extern	void		minit(void);
extern	void		setgbl(struct expr *esp);
extern	void		setpgl(int pmsk);

