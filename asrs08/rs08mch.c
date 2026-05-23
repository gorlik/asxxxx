/* rs08mch.c */

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

#include "asxxxx.h"
#include "rs08.h"

char	*cpu	= "Freescale/NXP - RS08 Series";
char	*dsft	= "asm";

/*
 * Opcode Cycle Definitions
 */
#define	OPCY_SDP	((char) (0xFF))
#define	OPCY_ERR	((char) (0xFE))
#define	OPCY_CPU	((char)	(0xFD))

#define	OPCY_NONE	((char) (0x80))
#define	OPCY_MASK	((char) (0x7F))

#define	UN	((char) (OPCY_NONE | 0x00))


/*
 * RS08 Cycles
 */

static char  rs08cyc[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
/*10*/   5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
/*20*/   4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
/*30*/   3, 5,UN,UN, 3, 3, 3, 3, 1, 1, 5, 7, 5,UN, 4, 3,
/*40*/  UN, 4, 1, 1, 1, 1, 1,UN, 1, 1, 1, 4, 1,UN, 5, 1,
/*50*/   4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
/*60*/   3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
/*70*/   3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 5, 3, 3,
/*80*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*90*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*A0*/   2, 2, 2,UN, 2,UN, 2,UN, 2, 2, 2, 2, 1, 3, 2, 2,
/*B0*/   3, 3, 3,UN, 3,UN, 3, 3, 3, 3, 3, 3, 4, 4, 3, 5,
/*C0*/   3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
/*D0*/   3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
/*E0*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*F0*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
};

/*
 * Process a machine op.
 */
void
machine(struct mne *mp)
{
	int op, t1, t2, type;
	struct expr e1, e2, e3;
	int v1, v2, v3;

	/*
	 * Using Internal Format
	 * For Cycle Counting
	 */
	opcycles = OPCY_NONE;

	clrexpr(&e1);
	clrexpr(&e2);
	clrexpr(&e3);
	op = (int) mp->m_valu;
	type = mp->m_type;
	switch (type) {

	case S_BRN:
		expr(&e1, 0);
		outab(op);
		if (mchpcr(&e1, &v1, 1)) {
			if ((v1 < -128) || (v1 > 127))
				xerr('a', "Branching Range Exceeded.");
		}
		outab(0x00);
		if (e1.e_mode != S_USER)
			rerr();
		break;

	case S_BRA:	/* BRA | BRN | BCC | BHS | BCS | BLO | BNE | BEQ */
		expr(&e1, 0);
		outab(op);
		if (mchpcr(&e1, &v1, 1)) {
			if ((v1 < -128) || (v1 > 127))
				xerr('a', "Branching Range Exceeded.");
			outab(v1);
		} else {
			outrb(&e1, R_PCR);
		}
		if (e1.e_mode != S_USER)
			rerr();
		break;

	case S_JMP:	/* JMP | JSR */
		expr(&e1, 0);
		outab(op);
		outrw(&e1,0);
		break;

	case S_TYP1:	/* ADD, DEC, INC, and SUB */
		t1 = addr(&e1);
		switch(t1) {
		case S_A:
			switch(op) {
			case 0x20:	/* INC */	outab(0x4C);	break;
			case 0x50:	/* DEC */	outab(0x4A);	break;
			case 0x60:	/* ADD */
			case 0x70:	/* SUB */
			default:	break;
			}
			break;

		case S_X:	outab(op+0x0F);	break;
		case S_IX:
		case S_DIX:	outab(op+0x0E);	break;

		case S_IMM:
			switch(op) {
			case 0x60:	/* ADD */	outab(0xAB);	break;
			case 0x70:	/* SUB */	outab(0xA0);	break;
			case 0x20:	/* INC */
			case 0x50:	/* DEC */
			default:	break;
			}
			outrb(&e1, 0);
			break;

		case S_TNY:
		case S_FRC:	outrbm(&e1, R_4BIT, op);	break;
 		case S_SRT:
		case S_DIR:
		case S_EXT:
			switch(op) {
			case 0x20:	/* INC */	outab(0x3C);	break;
			case 0x50:	/* DEC */	outab(0x3A);	break;
			case 0x60:	/* ADD */	outab(0xBB);	break;
			case 0x70:	/* SUB */	outab(0xB0);	break;
			default:	break;
			}
			outrb(&e1, R_PAG0);
			break;

		default:	xerr('a', "Invalid Addressing Mode.");	break;
		}
		break;

	case S_TYP2:	/* CLR */
		t1 = addr(&e1);
		switch(t1) {
		case S_A:	outab(0x4F);	break;
 		case S_X:	outab(0x8F);	break;
 		case S_IX:
		case S_DIX:	outab(0x8E);	break;
 		case S_TNY:
		case S_SRT:
		case S_FRC:	outrbm(&e1, R_5BIT, op);	break;
 		case S_DIR:
		case S_EXT:	outab(0x3F);	outrb(&e1, R_PAG0);	break;
 		default:	xerr('a', "Invalid Addressing Mode.");	break;
		}
		break;

	case S_TYP3:	/* LDA | STA */
		t1 = addr(&e1);
		switch(t1) {
		case S_X:
			switch(op) {
			case 0xC0:	/* LDA */	outab(0xCF);	break;
			case 0xE0:	/* STA */	outab(0xEF);	break;
			default:	break;
			}
			break;

		case S_IX:
		case S_DIX:	outab(op + 0x0E);	break;
 		case S_IMM:
			switch(op) {
			case 0xC0:	/* LDA */	outab(0xA6);	break;
			case 0xE0:	/* STA */	xerr('a', "Invalid Addressing Mode.");	return;
			default:	break;
			}
			outrb(&e1, 0);
			break;

		case S_TNY:
		case S_SRT:
		case S_FRC:	outrbm(&e1, R_5BIT, op);	break;
		case S_DIR:
		case S_EXT:
			switch(op) {
			case 0xC0:	/* LDA */	outab(0xB6);	break;
			case 0xE0:	/* STA */	outab(0xB7);	break;
			default:	break;
			}
			outrb(&e1, R_PAG0);
			break;

		default:	xerr('a', "Invalid Addressing Mode.");	break;
		}
		break;

	case S_TYP4:	/* ADC | AND | CMP | EOR | ORA | SBC */
		t1 = addr(&e1);
		switch(t1) {
		case S_X:	outab(op);	outab(0x0F);	break;
		case S_IX:
		case S_DIX:	outab(op);	outab(0x0E);	break;
		case S_IMM:	outab(op & 0xAF);	outrb(&e1, 0);	break;
		case S_TNY:
		case S_SRT:
		case S_FRC:
		case S_DIR:
		case S_EXT:	outab(op);	outrb(&e1, R_PAG0);	break;
 		default:	xerr('a', "Invalid Addressing Mode.");	break;
		}
		break;

	case S_TYP5:	/* ASL | COM | LSL | LSR | ROL | ROR | SH | SL */
		t1 = addr(&e1);
		switch(t1) {
		case S_A:	outab(op);	break;
		default:	xerr('a', "Only Allowed Argument Is 'A'.");	break;
		}
		break;

	case S_BIT:	/* BCLR | BSET */
		t1 = addr(&e1);
		comma(1);
		t2 = addr(&e2);
		if (t2 != S_A && t2 != S_IMM) {
			switch(t1) {
			case S_FRC:
				if (is_abs(&e1)) {
					v1 = (int) e1.e_addr;
					outab(op | ((v1 & 0x07) << 1));
				} else {
					outrbm(&e1, R_3BIT, op);
				}
				break;
			case S_IMM:
			case S_TNY:
			case S_SRT:
			case S_DIR:
			case S_EXT:
				if (is_abs(&e1)) {
					v1 = (int) e1.e_addr;
					if (v1 & ~0x07)
						xerr('a', "Valid Bit Values Are 0 -> 7.");
					outab(op | ((v1 & 0x07) << 1));
				} else {
					outrbm(&e1, R_3BIT | R_MBRO, op);
				}
				break;
			default:
				xerr('a', "Invalid Addressing Mode.");
				return;
			}
		}
		switch(t2) {
		case S_X:	outab(0x0F);	break;
		case S_IX:
		case S_DIX:	outab(0x0E);	break;
		case S_TNY:
		case S_SRT:
		case S_FRC:
		case S_DIR:
		case S_EXT:	outrb(&e2, R_PAG0);	break;
		default:	xerr('a', "Invalid Addressing Mode.");	break;
		}
		break;


	case S_BBIT:	/* BRCLR | BRSET */
		t1 = addr(&e1);
		comma(1);
		t2 = addr(&e2);
		comma(1);
		expr(&e3, 0);
		if (t2 != S_A && t2 != S_IMM) {
			switch(t1) {
			case S_FRC:
				if (is_abs(&e1)) {
					v1 = (int) e1.e_addr;
					outab(op | ((v1 & 0x07) << 1));
				} else {
					outrbm(&e1, R_3BIT, op);
				}
				break;
			case S_IMM:
			case S_TNY:
			case S_SRT:
			case S_DIR:
			case S_EXT:
				if (is_abs(&e1)) {
					v1 = (int) e1.e_addr;
					if (v1 & ~0x07)
						xerr('a', "Valid Bit Values Are 0 -> 7.");
					outab(op | ((v1 & 0x07) << 1));
				} else {
					outrbm(&e1, R_3BIT | R_MBRO, op);
				}
				break;
			default:
				xerr('a', "Invalid Addressing Mode.");
				return;
			}
		}
		switch(t2) {
		case S_X:	outab(0x0F);	break;
		case S_IX:
		case S_DIX:	outab(0x0E);	break;
		case S_TNY:
		case S_SRT:
		case S_FRC:
		case S_DIR:
		case S_EXT:	outrb(&e2, R_PAG0);	break;
		default:	xerr('a', "Invalid Addressing Mode.");	return;
		}
		if (mchpcr(&e3, &v3, 1)) {
			if ((v3 < -128) || (v3 > 127))
				xerr('a', "Branching Range Exceeded.");
			outab(v3);
		} else {
			outrb(&e3, R_PCR);
		}
		if (e3.e_mode != S_USER)
			rerr();
		break;

	case S_CBEQX:	/* CBEQX */
		expr(&e1, 0);
		outab(op);
		outab(0x0F);
		if (mchpcr(&e1, &v1, 1)) {
			if ((v1 < -128) || (v1 > 127))
				xerr('a', "Branching Range Exceeded.");
			outab(v1);
		} else {
			outrb(&e1, R_PCR);
		}
		if (e2.e_mode != S_USER)
			rerr();
		break;

	case S_CBEQ:	/* CBEQ */
	case S_CBEQA:	/* CBEQA */
		t1 = addr(&e1);
		if (type != S_CBEQA) {
			if (t1 == S_A) {
				comma(1);
				clrexpr(&e1);
				t1 = addr(&e1);
			}
		}
		comma(1);
		expr(&e2, 0);
		switch(t1) {
		case S_X:	outab(0x31);	outab(0x0F);	break;
		case S_IX:
		case S_DIX:	outab(0x31);	outab(0x0E);	break;
		case S_IMM:	outab(0x41);	outrb(&e1, 0);	break;
		case S_TNY:
		case S_SRT:
		case S_FRC:
		case S_DIR:
		case S_EXT:	outab(0x31);	outrb(&e1, R_PAG0);	break;
		default:	xerr('a', "Invalid Addressing Mode.");	return;
		}
		if (mchpcr(&e2, &v2, 1)) {
			if ((v2 < -128) || (v2 > 127))
				xerr('a', "Branching Range Exceeded.");
			outab(v2);
		} else {
			outrb(&e2, R_PCR);
		}
		if (e2.e_mode != S_USER)
			rerr();
		break;

	case S_DBNZA:	/* DBNZA */
	case S_DBNZX:	/* DBNZX */
		expr(&e1, 0);
		switch(type) {
		case S_DBNZA:	outab(0x4B);	break;
		case S_DBNZX:	outab(0x3B);	outab(0x0F);	break;
		default:	break;
		}
		if (mchpcr(&e1, &v1, 1)) {
			if ((v1 < -128) || (v1 > 127))
				xerr('a', "Branching Range Exceeded.");
			outab(v1);
		} else {
			outrb(&e1, R_PCR);
		}
		if (e1.e_mode != S_USER)
			rerr();
		break;


	case S_DBNZ:	/* DBNZ */
		t1 = addr(&e1);
		comma(1);
		expr(&e2, 0);
		switch(t1) {
		case S_A:	outab(0x4B);	break;
		case S_X:	outab(0x3B);	outab(0x0F);	break;
		case S_IX:
		case S_DIX:	outab(0x3B);	outab(0x0E);	break;
		case S_TNY:
		case S_SRT:
		case S_FRC:
		case S_DIR:
		case S_EXT:	outab(0x3B);	outrb(&e1, R_PAG0);	break;
		default:	xerr('a', "Invalid Addressing Mode.");	return;
		}
		if (mchpcr(&e2, &v2, 1)) {
			if ((v2 < -128) || (v2 > 127))
				xerr('a', "Branching Range Exceeded.");
			outab(v2);
		} else {
			outrb(&e2, R_PCR);
		}
		if (e2.e_mode != S_USER)
			rerr();
		break;

	case S_LDX:	/* LDX */
		t1 = addr(&e1);
		switch(t1) {
		case S_X:	outab(op);	outaw(0x0F0F);	break;
		case S_IX:
		case S_DIX:	outab(op);	outaw(0x0E0F);	break;
		case S_IMM:	outab(0x3E);	outrb(&e1, 0);	outab(0x0F);	break;
		case S_TNY:
		case S_SRT:
		case S_FRC:
		case S_DIR:
		case S_EXT:	outab(op);	outrb(&e1, R_PAG0);	outab(0x0F);	break;
		default:	xerr('a', "Invalid Addressing Mode.");	break;
		}
		break;

	case S_STX:	/* STX */
		t1 = addr(&e1);
		switch(t1) {
		case S_X:	outab(op);	outaw(0x0F0F);	break;
		case S_IX:
		case S_DIX:	outab(op);	outaw(0x0F0E);	break;
		case S_TNY:
		case S_SRT:
		case S_FRC:
		case S_DIR:
		case S_EXT:	outab(op);	outab(0x0F);	outrb(&e1, R_PAG0);	break;
		default:	xerr('a', "Invalid Addressing Mode.");	break;
		}
		break;

	case S_MOV:	/* MOV */
		t1 = addr(&e1);
		comma(1);
		t2 = addr(&e2);
		switch(t1) {
		case S_X:	/* MOV x,___ */
			switch(t2) {
			case S_X:	outab(op);	outaw(0x0F0F);	break;
 			case S_IX:
			case S_DIX:	outab(op);	outaw(0x0F0E);	break;
 			case S_TNY:
			case S_SRT:
			case S_FRC:
			case S_DIR:
			case S_EXT:	outab(op);	outab(0x0F);	outrb(&e2, R_PAG0);	break;
			default:	xerr('a', "Invalid Addressing Mode.");	break;
			}
			break;

		case S_IX:	/* MOV ,x,___ */
		case S_DIX:	/* MOV D[X],___ */
			switch(t2) {
			case S_X:	outab(op); 	outaw(0x0E0F);	break;
			case S_IX:
			case S_DIX:	outab(op);	outaw(0x0E0E);	break;
			case S_TNY:
			case S_SRT:
			case S_FRC:
			case S_DIR:
			case S_EXT:	outab(0x4E);	outab(0x0E);	outrb(&e2, R_PAG0);	break;
			default:	xerr('a', "Invalid Addressing Mode.");	break;
			}
			break;

		case S_IMM:	/* MOV #,___ */
			switch(t2) {
			case S_X:	outab(0x3E);	outrb(&e1, 0);	outab(0x0F);	break;
			case S_IX:
			case S_DIX:	outab(0x3E);	outrb(&e1, 0);	outab(0x0E);	break;
			case S_TNY:
			case S_SRT:
			case S_FRC:
			case S_DIR:
			case S_EXT:	outab(0x3E);	outrb(&e1, 0);	outrb(&e2, R_PAG0);	break;
			default:	xerr('a', "Invalid Addressing Mode.");	break;
			}
			break;

		case S_TNY:	/* MOV arg,___ */
		case S_SRT:
		case S_FRC:
		case S_DIR:
		case S_EXT:
			switch(t2) {
			case S_X:	outab(op);	outrb(&e1, R_PAG0);	outab(0x0F);	break;
			case S_IX:
			case S_DIX:	outab(op);	outrb(&e1, R_PAG0);	outab(0x0E);	break;
			case S_TNY:
			case S_SRT:
			case S_FRC:
			case S_DIR:
			case S_EXT:	outab(op);	outrb(&e1, R_PAG0);	outrb(&e2, R_PAG0);	break;
			default:	xerr('a', "Invalid Addressing Mode.");	break;
			}
			break;

		default:	xerr('a', "Invalid Addressing Mode.");	break;
		}
		break;

	case S_TST:	/* TST ___ */
		t1 = addr(&e1);
		switch(t1) {
		case S_A:	outab(0xAA);	outab(0x00);	break;
		case S_X:	outab(op);	outaw(0x0F0F);	break;
		case S_IX:
		case S_DIX:	outab(op);	outaw(0x0E0E);	break;
		case S_IMM:
		case S_TNY:
		case S_SRT:
		case S_FRC:
		case S_DIR:
		case S_EXT:	outab(op);	outrb(&e1, R_PAG0);	outrb(&e1, R_PAG0); break;
		default:	xerr('a', "Invalid Addressing Mode.");	break;
		}
		break;

	case S_TSTX:	/* TSTX */
		outab(0x4E);
		outaw(0x0F0F);
		break;

	case S_INH:
		outab(op);
		break;

	case S_INH2:
		outaw(op);
		break;

	default:
		opcycles = OPCY_ERR;
		xerr('o', "Internal Opcode Error.");
		break;
	}

	if (opcycles == OPCY_NONE) {
		opcycles = rs08cyc[cb[0] & 0xFF];
	}
	/*
	 * Translate To External Format
	 */
	if (opcycles == OPCY_NONE) { opcycles  =  CYCL_NONE; } else
	if (opcycles  & OPCY_NONE) { opcycles |= (CYCL_NONE | 0x3F00); }
}

/*
 * Branch/Jump PCR Mode Check
 */
int
mchpcr(struct expr *esp, int *v, int n)
{
	if (esp->e_base.e_ap == dot.s_area) {
		if (v != NULL) {
#if 1
			/* Allows branching from top-to-bottom and bottom-to-top */
 			*v = (int) (esp->e_addr - dot.s_addr - n);
			/* only bits 'a_mask' are significant, make circular */
			if (*v & s_mask) {
				*v |= (int) ~a_mask;
			}
			else {
				*v &= (int) a_mask;
			}
#else
			/* Disallows branching from top-to-bottom and bottom-to-top */
			*v = (int) ((esp->e_addr & a_mask) - (dot.s_addr & a_mask) - n);
#endif
		}
		return(1);
	}
	if (esp->e_flag==0 && esp->e_base.e_ap==NULL) {
		/*
		 * Absolute Destination
		 *
		 * Use the global symbol '.__.ABS.'
		 * of value zero and force the assembler
		 * to use this absolute constant as the
		 * base value for the relocation.
		 */
		esp->e_flag = 1;
		esp->e_base.e_sp = &sym[1];
	}
	return(0);
}

/*
 * Machine specific initialization.
 */
void
minit(void)
{
	/*
	 * Byte Order
	 */
	hilo = 1;
}
