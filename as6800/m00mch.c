/* m00mch.c */

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
#include "m6800.h"

char	*cpu	= "Motorola 6800/6802/6808";
char	*dsft	= "asm";

/*
 * Opcode Cycle Definitions
 */
#define	OPCY_SDP	((char) (0xFF))
#define	OPCY_ERR	((char) (0xFE))

#define	OPCY_NONE	((char) (0x80))
#define	OPCY_MASK	((char) (0x7F))

#define	UN	((char) (OPCY_NONE | 0x00))

/*
 * 6800 Cycle Count
 *
 *	opcycles = m00cyc[opcode]
 */
char m00cyc[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  UN, 2,UN,UN,UN,UN, 2, 2, 4, 4, 2, 2, 2, 2, 2, 2,
/*10*/   2, 2,UN,UN,UN,UN, 2, 2,UN, 2,UN, 2,UN,UN,UN,UN,
/*20*/   4,UN, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
/*30*/   4, 4, 4, 4, 4, 4, 4, 4,UN, 5,UN,10,UN,UN, 9,12,
/*40*/   2,UN,UN, 2, 2,UN, 2, 2, 2, 2, 2,UN, 2, 2,UN, 2,
/*50*/   2,UN,UN, 2, 2,UN, 2, 2, 2, 2, 2,UN, 2, 2,UN, 2,
/*60*/   7,UN,UN, 7, 7,UN, 7, 7, 7, 7, 7,UN, 7, 7, 4, 7,
/*70*/   6,UN,UN, 6, 6,UN, 6, 6, 6, 6, 6,UN, 6, 6, 3, 6,
/*80*/   2, 2, 2,UN, 2, 2, 2,UN, 2, 2, 2, 2, 3, 8, 3,UN,
/*90*/   3, 3, 3,UN, 3, 3, 3, 4, 3, 3, 3, 3, 4,UN, 4, 5,
/*A0*/   5, 5, 5,UN, 5, 5, 5, 6, 5, 5, 5, 5, 6, 8, 6, 7,
/*B0*/   4, 4, 4,UN, 4, 4, 4, 5, 4, 4, 4, 4, 5, 9, 5, 6,
/*C0*/   2, 2, 2,UN, 2, 2, 2,UN, 2, 2, 2, 2,UN,UN, 3,UN,
/*D0*/   3, 3, 3,UN, 3, 3, 3, 4, 3, 3, 3, 3,UN,UN, 4, 5,
/*E0*/   5, 5, 5,UN, 5, 5, 5, 6, 5, 5, 5, 5,UN,UN, 6, 7,
/*F0*/   4, 4, 4,UN, 4, 4, 4, 5, 4, 4, 4, 4,UN,UN, 5, 6
};

struct area *zpg;

/*
 * Process a machine op.
 */
void
machine(struct mne *mp)
{
	int op, t1;
	struct expr e1;
	struct sym *sp;
	char id[NCPS];
	int c, v1, reg;

	/*
	 * Using Internal Format
	 * For Cycle Counting
	 */
	opcycles = OPCY_NONE;

	clrexpr(&e1);
	reg = 0;
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
 
	case S_INH:
		outab(op);
		break;

	case S_PUL:
		v1 = admode(abx);
		if (v1 == S_A) {
			outab(op);
			break;
		}
		if (v1 == S_B) {
			outab(op+1);
			break;
		}
		xerr('a', "Register X Is Invalid.");
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
		if ((t1 == S_EXT) || (t1 == S_DIR)) {
			outab(op|0x30);
			outrw(&e1, 0);
			break;
		}
		if (t1 == S_INDX) {
			outab(op|X);
			outrb(&e1, R_USGN);
			break;
		}
		xerr('a', "Invalid Addressing Mode.");
		break;

	case S_TYP2:
		if ((reg = admode(abx)) == 0)
			xerr('a', "Register A, B, or X required.");

	case S_TYP3:
		if (!reg) {
			reg = op & 0x40;
		} else if (reg == S_A) {
			reg = 0x00;
		} else if (reg == S_B) {
			reg = 0x40;
		} else {
			xerr('a', "Register X is not allowed.");
			reg = 0x00;
		}
		t1 = addr(&e1);
		if (t1 == S_IMMED) {
			if ((op|0x40) == 0xC7)
				xerr('a', "STA #__ and STB #__ are invalid.");
			outab(op|reg);
			outrb(&e1, 0);
			break;
		}
		if (t1 == S_EXT) {
			outab(op|reg|0x30);
			outrw(&e1, 0);
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
		if (t1 == S_EXT) {
			outab(op|0x30);
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
		xerr('a', "Invalid Addressing Mode.");
		break;

	case S_TYP5:
		t1 = addr(&e1);
		if ((t1 == S_EXT) || (t1 == S_DIR)) {
			outab(op|0x10);
			outrw(&e1, 0);
			break;
		}
		if (t1 == S_INDX) {
			outab(op);
			outrb(&e1, R_USGN);
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
		opcycles = m00cyc[cb[0] & 0xFF];
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
	 * Zero Page Area Pointer
	 */
	zpg = NULL;
}
