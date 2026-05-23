/* m01mch.c */

/*
 *  Copyright (C) 1989-2025  Alan R. Baldwin
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
#include "m6801.h"

char	*cpu	= "Motorola 6801/6803 [Hitachi HD6303]";
char	*dsft	= "asm";

int	mchtyp;

/*
 * Opcode Cycle Definitions
 */
#define	OPCY_SDP	((char) (0xFF))
#define	OPCY_ERR	((char) (0xFE))

#define	OPCY_NONE	((char) (0x80))
#define	OPCY_MASK	((char) (0x7F))

#define	OPCY_CPU	((char) (0xFD))

#define	UN	((char) (OPCY_NONE | 0x00))

/*
 * 6801/6803 Cycle Count
 *
 *	opcycles = m01cyc[opcode]
 */
char m68cyc[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  UN, 2,UN,UN, 3, 3, 2, 2, 3, 3, 2, 2, 2, 2, 2, 2,
/*10*/   2, 2,UN,UN,UN,UN, 2, 2,UN, 2,UN, 2,UN,UN,UN,UN,
/*20*/   3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
/*30*/   3, 3, 4, 4, 3, 3, 3, 3, 5, 5, 3,10, 4,10, 9,12,
/*40*/   2,UN,UN, 2, 2,UN, 2, 2, 2, 2, 2,UN, 2, 2,UN, 2,
/*50*/   2,UN,UN, 2, 2,UN, 2, 2, 2, 2, 2,UN, 2, 2,UN, 2,
/*60*/   6,UN,UN, 6, 6,UN, 6, 6, 6, 6, 6,UN, 6, 6, 3, 6,
/*70*/   6,UN,UN, 6, 6,UN, 6, 6, 6, 6, 6,UN, 6, 6, 3, 6,
/*80*/   2, 2, 2, 4, 2, 2, 2,UN, 2, 2, 2, 2, 4, 6, 3,UN,
/*90*/   3, 3, 3, 5, 3, 3, 3, 3, 3, 3, 3, 3, 5, 5, 4, 4,
/*A0*/   4, 4, 4, 6, 4, 4, 4, 4, 4, 4, 4, 4, 6, 6, 5, 5,
/*B0*/   4, 4, 4, 6, 4, 4, 4, 4, 4, 4, 4, 4, 6, 6, 5, 5,
/*C0*/   2, 2, 2, 4, 2, 2, 2,UN, 2, 2, 2, 2, 3,UN, 3,UN,
/*D0*/   3, 3, 3, 5, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4,
/*E0*/   4, 4, 4, 6, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5,
/*F0*/   4, 4, 4, 6, 4, 4, 4, 5, 4, 4, 4, 4, 5, 5, 5, 5
};

/*
 * 6303 Cycle Count
 *
 *	opcycles = m63cyc[opcode]
 */
char m63cyc[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  UN, 1,UN,UN, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*10*/   1, 1,UN,UN,UN,UN, 1, 1, 2, 2, 4, 1,UN,UN,UN,UN,
/*20*/   3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
/*30*/   1, 3, 3, 3, 1, 1, 4, 4, 4, 5, 1,10, 5, 7, 9,12,
/*40*/   1,UN,UN, 1, 1,UN, 1, 1, 1, 1, 1,UN, 1, 1,UN, 1,
/*50*/   1,UN,UN, 1, 1,UN, 1, 1, 1, 1, 1,UN, 1, 1,UN, 1,
/*60*/   6, 7, 7, 6, 6, 7, 6, 6, 6, 6, 6, 5, 6, 4, 3, 5,
/*70*/   6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 4, 6, 4, 3, 5,
/*80*/   2, 2, 2, 3, 2, 2, 2,UN, 2, 2, 2, 2, 3, 5, 3,UN,
/*90*/   3, 3, 3, 4, 3, 3, 3, 3, 3, 3, 3, 3, 4, 5, 4, 4,
/*A0*/   4, 4, 4, 5, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5,
/*B0*/   4, 4, 4, 5, 4, 4, 4, 4, 4, 4, 4, 4, 5, 6, 5, 5,
/*C0*/   2, 2, 2, 3, 2, 2, 2,UN, 2, 2, 2, 2, 3,UN, 3,UN,
/*D0*/   3, 3, 3, 4, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4,
/*E0*/   4, 4, 4, 5, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5,
/*F0*/   4, 4, 4, 5, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5
};

struct area *zpg;

/*
 * Process a machine op.
 */
void
machine(struct mne *mp)
{
	int op, t1;
	struct expr e1, e2;
	struct sym *sp;
	char id[NCPS];
	int c, v1, reg;

	/*
	 * Using Internal Format
	 * For Cycle Counting
	 */
	opcycles = OPCY_NONE;

	reg = 0;
	clrexpr(&e1);
	clrexpr(&e2);
	op = (int) mp->m_valu;
	switch (mp->m_type) {

	case S_SDP:
		opcycles = OPCY_SDP;
		zpg = dot.s_area;
		if (more()) {
			expr(&e1, 0);
			if (e1.e_flag == 0 && e1.e_base.e_ap == NULL) {
				if (e1.e_addr) {
					e1.e_addr = 0;
					xerr('b', "Only Page 0 Allowed.");
				}
			}
			if ((c = getnb()) == ',') {
				getid(id, -1);
				zpg = alookup(id);
				if (zpg == NULL) {
					zpg = dot.s_area;
					xerr('u', "Undefined Area.");
				}
			} else {
				unget(c);
			}
		}
		outdp(zpg, &e1, 0);
		lmode = SLIST;
		break;

	case S_PGD:
		do {
			getid(id, -1);
			sp = lookup(id);
			sp->s_flag &= ~S_LCL;
			sp->s_flag |=  S_GBL;
			sp->s_area = (zpg != NULL) ? zpg : dot.s_area;
 		} while (comma(0));
		lmode = SLIST;
		break;
 
	case S_CPU:
		opcycles = OPCY_CPU;
		mchtyp = op;
		sym[2].s_addr = op;
		lmode = SLIST;
		break;

	case S_INH63:
		if (mchtyp == X_6801) {
			xerr('o', "Invalid 6801 Instruction");
			break;
		}

	case S_INH:
		outab(op);
		break;

	case S_TYP63:
		if (mchtyp == X_6801) {
			xerr('o', "Invalid 6801 Instruction");
			break;
		}
		if (getnb() != '#')
			xerr('a', "Immediate (#) number required.");
		expr(&e2, 0);
		comma(1);
		t1 = addr(&e1);
		if (t1 == S_DIR) {
			outab(op|0x10);
			outrb(&e2, 0);
			outrb(&e1, R_PAG0);
			break;
		}
		if (t1 == S_INDX) {
			outab(op);
			outrb(&e2, 0);
			outrb(&e1, R_USGN);
			break;
		}
		xerr('a', "Invalid Addressing Mode.");
		break;

	case S_PUL:
		v1 = admode(abdx);
		if (v1 == S_A) {
			outab(op);
			break;
		}
		if (v1 == S_B) {
			outab(op+1);
			break;
		}
		if (v1 == S_X) {
			outab(op+6);
			break;
		}
		xerr('a', "Invalid Addressing Mode.");
		break;

	case S_BRA:
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

	case S_TYP1:
		t1 = addr(&e1);
		if (t1 == S_A) {
			outab(op|A);
			break;
		}
		if (t1 == S_B) {
			outab(op|B);
			break;
		}
		if (t1 == S_D) {
			if (op == 0x44) {
				outab(0x04);
				break;
			}
			if (op == 0x48) {
				outab(0x05);
				break;
			}
			xerr('a', "Only LSR D and LSR D are allowed.");
			break;
		}
		if (t1 == S_INDX) {
			outab(op|X);
			outrb(&e1, R_USGN);
			break;
		}
		if (t1 == S_DIR) {
			outab(op|0x30);
			outrw(&e1, 0);
			xerr('a', "Direct Mode is not supported.");
			break;
		}
		if (t1 == S_EXT) {
			outab(op|0x30);
			outrw(&e1, 0);
			break;
		}
		xerr('a', "Invalid Addressing Mode.");
		break;

	case S_TYP2:
	case S_TYP3:
		if (((reg = admode(abdx)) == 0) && (mp->m_type == S_TYP2))
			xerr('a', "Register A, B, Or D required.");
		if (!reg) {
			reg = op & 0x40;
		} else if (reg == S_A) {
			reg = 0x00;
		} else if (reg == S_B) {
			reg = 0x40;
		} else if (reg == S_D) {
			if (op == 0x80) {
				op = 0x83;
			} else
			if (op == 0x8B) {
				op = 0xC3;
			} else {
				xerr('a', "Only ADDD and SUBD are allowed.");
			}
			reg = 0x00;
		} else {
			xerr('a', "Register A, B, Or D required.");
			reg = 0x00;
		}
		t1 = addr(&e1);
		if (t1 == S_IMMED) {
			if ((op|0x40) == 0xC7)
				xerr('a', "STA #__ and STB #__ are invalid.");
			if (op == 0x83 || op == 0xC3) {
				outab(op|reg);
				outrw(&e1, 0);
			} else {
				outab(op|reg);
				outrb(&e1, 0);
			}
			break;
		}
		if (t1 == S_DIR) {
			outab(op|reg|0x10);
			outrb(&e1, R_PAG0);
			break;
		}
		if (t1 == S_INDX) {
			outab(op|reg|0x20);
			outrb(&e1, R_USGN);
			break;
		}
		if (t1 == S_EXT) {
			outab(op|reg|0x30);
			outrw(&e1, 0);
			break;
		}
		xerr('a', "Invalid Addressing Mode.");
		break;

	case S_TYP4:
		t1 = addr(&e1);
		if (t1 == S_IMMED) {
			if ((op&0x0D) == 0x0D)
				xerr('a', "STS #__ and STX #__ are invalid.");
			outab(op);
			outrw(&e1, 0);
			break;
		}
		if (t1 == S_DIR) {
			outab(op|0x10);
			outrb(&e1, R_PAG0);
			break;
		}
		if (t1 == S_INDX) {
			outab(op|0x20);
			outrb(&e1, R_USGN);
			break;
		}
		if (t1 == S_EXT) {
			outab(op|0x30);
			outrw(&e1, 0);
			break;
		}
		xerr('a', "Invalid Addressing Mode.");
		break;

	case S_TYP5:
		t1 = addr(&e1);
		if (t1 == S_INDX) {
			outab(op);
			outrb(&e1, R_USGN);
			break;
		}
		if (t1 == S_DIR) {
			outab(op|0x10);
			outrw(&e1, 0);
			xerr('a', "Direct Mode is not supported.");
			break;
		}
		if (t1 == S_EXT) {
			outab(op|0x10);
			outrw(&e1, 0);
			break;
		}
		xerr('a', "Invalid Addressing Mode.");
		break;

	default:
		opcycles = OPCY_ERR;
		xerr('o', "Internal Opcode Error.");
		break;
	}

	if (opcycles == OPCY_NONE) {
		if (mchtyp == X_6801) {
			opcycles = m63cyc[cb[0] & 0xFF];
		} else {
			opcycles = m68cyc[cb[0] & 0xFF];
		}
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
 * Machine dependent initialization
 */
void
minit(void)
{
	/*
	 * Byte Order
	 */
	hilo = 1;

	/*
	 * Zero Page
	 */
	zpg = NULL;

	mchtyp = X_6801;
	sym[2].s_addr = X_6801;
}
