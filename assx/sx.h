/* sx.h */

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
	$(PROGRAM) = ASSX
	$(INCLUDE) = {
		ASXXXX.H
		SX.H
	}
	$(FILES) = {
		SXMCH.C
		SXADR.C
		SXPST.C
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
	char	a_str[8];	/* addressing string */
	int	a_val;		/* addressing mode value */
};

/*
 * Addressing types
 */
#define	S_FRBIT		0x20		/* fr.bit addressing */
					/* 0x20 - 0x27 (32 - 39)*/
#define	S_W		40		/* W Register */
#define	S_M		41		/* Mode Register */
#define	S_MOP		42		/* MOV Options */
#define	  S_CM	0			/*  '/'  Complement */
#define	  S_MM	1			/*  '--' Decrement */
#define	  S_PP	2			/*  '++' Increment */
#define	  S_RT	3			/*  '>>' Right Shift */
#define	  S_LT	4			/*  '<<' Left Shift */
#define	  S_SN	5			/*  '<>' Swap Nibbles */
#define	S_FR		43		/* General Register Address */
#define	S_FRW		44		/* MOV fr-W Special */
#define	S_PCW		45		/* JMP PC+W */
#define	S_REG		46		/* Registers */
#define	S_NRG		47		/* Non Memory Mapped Registers */
#define S_IMM		48		/* Immediate Addressing */

/*
 * Registers
 */
#define	S_INDF		0x00		/* Indirect Addressing Register */
#define	S_RTCC		0x01		/* Real Time Clock Control */
#define	S_PC		0x02		/* PC Register */
#define	S_STATUS	0x03		/* Status Register */
#define	S_FSR		0x04		/* FSR Register */
#define	S_RA		0x05		/* Device Registers */
#define	S_RB		0x06
#define	S_RC		0x07
#define	S_RD		0x08
#define	S_RE		0x09

#define	S_OPT		0x02		/* Option Register */
#define	S_WDT		0x04		/* Watch Dog Timer */

/*
 * SX Instructions
 */
#define	S_TYP1		60
#define	S_TYP2		61
#define	S_TYP3		62
#define	S_CLR		63
#define	S_MOV		64
#define	S_MOVSZ		65
#define	S_CALL		66
#define	S_JMP		67
#define	S_RETW		68
#define	S_BNK		69
#define	S_PAG		70
#define	S_INH		71
#define	S_MODE		72
#define	S_SC		73
#define	S_SZ		74
#define	S_SKIP		75

/*
 * Extended Addressing Modes
 */
#define	R_3BIT	0x0100		/* 3-Bit Addressing Mode */
#define	R_4BIT	0x0200		/* 4-Bit Addressing Mode */
#define	R_5BIT	0x0300		/* 5-Bit Addressing Mode */
#define	R_8BIT	0x0400		/* 8-Bit Addressing Mode */
#define	R_9BIT	0x0500		/* 9-Bit Addressing Mode */
#define	R_BNK	0x0600		/* <10:8> -> (2:0) */
#define	R_PAG	0x0700		/* <11:9> -> <2:0> */
#define	R_SKIP	0x0800		/* <0> -> <8> */

/*
 * machine dependent functions
 */

	/* sxadr.c */
extern	struct	adsym	reg[];
extern	struct	adsym	nrg[];
extern	int		addr(struct expr *esp);
extern	int		admode(struct adsym *sp);
extern	int		srch(char *str);

	/* sxmch.c */
extern	void		machine(struct mne *mp);
extern	void		minit(void);

