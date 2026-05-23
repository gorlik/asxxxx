/* t90.h */

/*
 *  Copyright (C) 2026  Alan R. Baldwin
 *
 *  A rewrite of the
 *    Port to the SDAS fork of ASxxxx by Rainer Keuchel (C) 2013
 *    Port to ASxxxx from the SDASTLCS90 by Philip Klaus Krause 2025
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

/*
 * Extensions: P. Felber
 */

/*
 * Indirect Addressing delimeters
 */
#define	LFIND	'('
#define RTIND	')'

/*
 * Registers
 */
#define B	0
#define C	1
#define D	2
#define E	3
#define H	4
#define L	5
#define A	6

#define BC	0
#define DE	1
#define HL	2
#define IX	4
#define IY	5
#define SP	6

#define AF	6
#define AFP	7

/*
 * Masks
 */
#define	XYSMASK	0x03
#define	IXIYSP	0x04
#define	BTMASK	0x07

/*
 * Conditional definitions
 */

/*
 *	F	always False
 *	T	always True
 *	Z	Z = 1 Result zero
 *	NE / NZ	Z = 0 Result not zero
 *	C	C = 1 Carry is Set
 *	NC	C = 0 Carry is not Set
 *	PL / P	S = 0 Result positive; >= 0
 *	MI / M	S = 1 Result negative; < 0
 *	NE	Z = 0 Result not zero
 *	EQ / Z	Z = 1 Result zero
 *	OV	P/V = 1 Overflow ocurred
 *	NOV	P/V = 0 Overflow didn't occur
 *	PE	P/V = 1 Result has even Parity
 *	PO	P/V = 0 Result has odd Parity
 *	GE	(S xor P/V) = 0 Result (signed) is >= 0
 *	LT	(S xor P/V) = 1 Result (signed) is < 0
 *	GT	[Z or (S xor P/V)] = 0 Result (signed) is > 0
 *	LE	[Z or (S xor P/V)] = 1 Result (signed) is <= 0
 *	UGE	C = 0 Result (unsigned) is >= 0
 *	ULT	C = 1 Result (unsigned) is < 0
 *	UGT	(C or Z) = 0 Result (unsigned) is > 0
 *	ULE	(C or Z) = 1 Result (unsigned) is <= 0
 */

#define	F	0x0
#define LT	0x1
#define LE	0x2
#define ULE	0x3
#define OV	0x4
#define MI	0x5
#define EQ	0x6
#define CS	0x7
#define T	0x8
#define GE	0x9
#define GT	0xA
#define UGT	0xB
#define NOV	0xC
#define PL	0xD
#define NE	0xE
#define NC	0xF

#define PE	0x4
#define PO	0xC

#define M	0x5
#define P	0xD

#define Z	0x6
#define NZ	0xE

#define ULT	0x7
#define UGE	0xF

/*
 * Simple Argument Types
 */
#define	S_R8	41
#define	S_R16	42
#define S_XYS	43
#define	S_HLA	44
#define	S_MN	45

#define	S_R16A	46
#define	S_CND	47

/*
 * Indexed Argument Types
 */
#define	S_IR8	50
#define	S_IR16	51
#define	S_IXYS	52
#define	S_IHLA	53
#define	S_IMN	54

#define	S_IN	55
#define	S_INPG	56

/*
 * Specials
 */
#define	S_SDP	59

/*
 * Instruction types
 */
#define	S_LD	60
#define	S_LDW	61
#define	S_PUSH	62
#define	S_LDA	63
#define	S_EX	64
#define	S_INH2	65
#define	S_INH1	66
#define	S_TYP1	67
#define	S_INC	68
#define	S_DEC	69
#define	S_INCW  70
#define	S_DECW  71
#define	S_TYP2	72
#define	S_LDAR	73
#define	S_MLDV	74
#define	S_SHRO	75
#define	S_RLD	76
#define	S_RRD	77
#define	S_BIT	78
#define	S_SET	79
#define	S_RES	80
#define	S_TSET	81
#define	S_JP	82
#define	S_CALL	83
#define S_CALR	84
#define	S_JR	85
#define	S_JRL	86
#define	S_DJNZ	87
#define	S_RET	88


struct adsym {
	char a_str[4];	/* addressing string */
	int	a_val;	/* addressing mode value */
};

extern	struct	adsym	R8[];
extern	struct	adsym	R16[];
extern	struct	adsym	R16A[];
extern	struct	adsym	R16EX[];
extern	struct	adsym	PC[];
extern	struct	adsym	CND[];

	/* machine dependent functions */
	
	/* t90adr.c */
extern	int		aindx;
extern	int		addr(struct expr *esp);
extern	int		admode(struct adsym *sp);
extern	int		srch(char *str);

	/* t90mch.c */
extern	void		machine(struct mne *mp);
extern	int		mchpcr(struct expr *esp, int *v, int n);
extern	void		minit(void);

