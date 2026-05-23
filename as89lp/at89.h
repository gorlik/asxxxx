/* at89.h */

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
 *
 */

/*)BUILD
	$(PROGRAM) =	AS89LP
	$(INCLUDE) = {
		ASXXXX.H
		AT89.H
	}
	$(FILES) = {
		AT89MCH.C
		AT89ADR.C
		AT89PST.C
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
 * Symbol types.
 */
#define	S_INH		60	/* One byte inherent */
#define	S_JMP11		61	/* Jump and call 11 bit. */
#define	S_JMP16		62	/* Jump and call 16 bit */
#define	S_ACC		63	/* Accumulator */
#define	S_TYP1		64	/* Type 1 (inc and dec) */
#define	S_TYP2		65	/* Type 2 (arith ops) */
#define	S_TYP3		66	/* Type 3 (logic ops) */
#define	S_TYP4		67	/* Type 4 (XCH) */
#define	S_MOV		68	/* MOV */
#define	S_BITBR		69	/* bit branch */
#define	S_BR		70	/* branch */
#define	S_ACBIT		71	/* CLR, CPL */
#define	S_CJNE		72	/* CJNE */
#define	S_DJNZ		73	/* DJNZ */
#define S_JMP		74	/* JMP */
#define S_MOVC		75	/* MOVC */
#define S_MOVX		76	/* MOVX */
#define S_MLDV		77	/* MUL and DIV */
#define S_SETB		78	/* SETB */
#define S_DIRECT	79	/* DIRECT (pusha and pop) */
#define S_XCHD		80	/* XCHD */
#define	S_BRK		81	/* BREAK */
#define	S_MOP		82	/* ASR M, CLR M, LSR M */
#define	S_MAC		83	/* MAC */

#define	S_AT89LP	84	/* MCU Type */

#define	S_RBNK		85	/* .regbnk */

/* Addressing modes */
#define S_A		30	/* A */
#define S_C		31	/* C (carry) */
#define S_AB		32	/* AB */
#define	S_DPTR		33	/* DPTR */
#define	S_NDPTR		34	/* /DPTR */
#define	S_REG		35	/* Register R0-R7 */
#define S_IMMED		36	/* immediate */
#define S_DIR		37	/* direct */
#define S_EXT		38	/* extended */
#define S_PC		39	/* PC (for addressing mode) */
#define	S_M		40	/* M */

#define S_AT_R		50 	/* @R0 or @R1 */
#define S_AT_DP		51 	/* @DPTR */
#define	S_AT_NDP	52	/* @/DPTR */
#define S_AT_A_PC	53	/* @A+PC */
#define S_AT_A_DP	54	/* @A+DPTR */
#define S_AT_A_NDP	55	/* @A+/DPTR */
#define S_NOT_BIT	56	/* /BIT (/DIR) */

/* Extended Instruction Options */
/*
 * MAC	AB
 * CLR	M
 * ASR	M
 * LSL	M
 */
#define	EX_MAC		0x01
/*
 * INC	/DPTR,#
 * MOV	/DPTR,#
 * MOV	@A+/DPTR
 * MOVX	A,@/DPTR
 * MOVX	@/DPTR,A
 */
#define	EX_DPTR		0x02
/*
 * JMP	@A+PC
 */
#define	EX_JMP		0x04
/*
 * CJNE	A,@R0,rel
 * CJNE	A,@R1,rel
 */
#define	EX_CJNE		0x08
/*
 * BREAK
 */
#define	EX_BRK		0x10

/*
 * MCU Types
 */
#define	LP2052		0
#define	LP213						EX_JMP			|	EX_BRK
#define	LP214						EX_JMP			|	EX_BRK
#define	LP216						EX_JMP			|	EX_BRK
#define	LP3240		EX_MAC	|	EX_DPTR	|	EX_JMP	|	EX_CJNE	|	EX_BRK
#define	LP4052		0
#define	LP428				EX_DPTR	|	EX_JMP	|	EX_CJNE	|	EX_BRK
#define	LP51				EX_DPTR	|	EX_JMP	|	EX_CJNE
#define	LP51ED2		EX_MAC	|	EX_DPTR	|	EX_JMP	|	EX_CJNE
#define	LP51IC2		EX_MAC	|	EX_DPTR	|	EX_JMP	|	EX_CJNE
#define	LP51ID2		EX_MAC	|	EX_DPTR	|	EX_JMP	|	EX_CJNE
#define	LP51RB2		EX_MAC	|	EX_DPTR	|	EX_JMP	|	EX_CJNE
#define	LP51RC2		EX_MAC	|	EX_DPTR	|	EX_JMP	|	EX_CJNE
#define	LP51RD2		EX_MAC	|	EX_DPTR	|	EX_JMP	|	EX_CJNE
#define	LP52				EX_DPTR	|	EX_JMP	|	EX_CJNE
#define	LP6440		EX_MAC	|	EX_DPTR	|	EX_JMP	|	EX_CJNE	|	EX_BRK
#define	LP828				EX_DPTR	|	EX_JMP	|	EX_CJNE	|	EX_BRK

/*
 * Registers.
 */
#define R0      0
#define R1      1
#define R2      2
#define R3      3
#define R4      4
#define R5      5
#define R6      6
#define R7      7
#define A       0xFF		/* dummy number for register ID only */
#define DPTR    0xFE		/* dummy number for register ID only */
#define PC      0xFD		/* dummy number for register ID only */
#define AB      0xFC		/* dummy number for register ID only */
#define C       0xFB		/* dummy number for register ID only */
#define M       0xFA		/* dummy number for register ID only */

struct adsym
{
	char	a_str[5];	/* addressing string (length for DPTR+null)*/
	int	a_val;		/* addressing mode value */
};

/*
 * Extended Addressing Modes
 */
#define	R_J11	0x0100		/* 11-Bit Addressing Mode */


	/* machine dependent functions */

	/* at89adr.c */
extern	struct	adsym	reg89[];
extern	int		addr(struct expr *esp);
extern	int		admode(struct adsym *sp);
extern	int		srch(char *str);
extern	int		reg(void);

	/* at89mch.c */
extern	void		machine(struct mne *mp);
extern	int		mchpcr(struct expr *esp, int *v, int n);
extern	void		minit(void);

