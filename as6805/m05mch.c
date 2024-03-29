/* m05mch.c */

/*
 *  Copyright (C) 1989-2023  Alan R. Baldwin
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
#include "m6805.h"

char	*cpu	= "Motorola 6805";
char	*dsft	= "asm";

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
 * 6805 Cycle Count
 *
 *	opcycles = m05cyc[opcode]
 */
char m05cyc[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,
/*10*/   7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
/*20*/   4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
/*30*/   6,UN,UN, 6, 6,UN, 6, 6, 6, 6, 6,UN, 6, 6,UN, 6,
/*40*/   4,UN,UN, 4, 4,UN, 4, 4, 4, 4, 4,UN, 4, 4,UN, 4,
/*50*/   4,UN,UN, 4, 4,UN, 4, 4, 4, 4, 4,UN, 4, 4,UN, 4,
/*60*/   7,UN,UN, 7, 7,UN, 7, 7, 7, 7, 7,UN, 7, 7,UN, 7,
/*70*/   6,UN,UN, 6, 6,UN, 6, 6, 6, 6, 6,UN, 6, 6,UN, 6,
/*80*/   9, 6,UN,11,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN, 2, 2,
/*90*/  UN,UN,UN,UN,UN,UN,UN, 2, 2, 2, 2, 2, 2, 2,UN, 2,
/*A0*/   2, 2, 2, 2, 2, 2, 2,UN, 2, 2, 2, 2,UN, 8, 2,UN,
/*B0*/   4, 4, 4, 4, 4, 4, 4, 5, 4, 4, 4, 4, 3, 7, 4, 5,
/*C0*/   5, 5, 5, 5, 5, 5, 5, 6, 5, 5, 5, 5, 4, 8, 5, 6,
/*D0*/   6, 6, 6, 6, 6, 6, 6, 7, 6, 6, 6, 6, 5, 9, 6, 7,
/*E0*/   5, 5, 5, 5, 5, 5, 5, 6, 5, 5, 5, 5, 4, 8, 5, 6,
/*F0*/   4, 4, 4, 4, 4, 4, 4, 5, 4, 4, 4, 4, 3, 7, 4, 5
};

/*
 * 146805 CMOS Cycle Count
 *
 *	opcycles = mcmcyc[opcode]
 */
char mcmcyc[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
/*10*/   5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
/*20*/   3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
/*30*/   5,UN,UN, 5, 5,UN, 5, 5, 5, 5, 5,UN, 5, 4,UN, 5,
/*40*/   3,UN,UN, 3, 3,UN, 3, 3, 3, 3, 3,UN, 3, 3,UN, 3,
/*50*/   3,UN,UN, 3, 3,UN, 3, 3, 3, 3, 3,UN, 3, 3,UN, 3,
/*60*/   6,UN,UN, 6, 6,UN, 6, 6, 6, 6, 6,UN, 6, 5,UN, 6,
/*70*/   5,UN,UN, 5, 5,UN, 5, 5, 5, 5, 5,UN, 5, 4,UN, 5,
/*80*/   9, 6,UN,10,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN, 2, 2,
/*90*/  UN,UN,UN,UN,UN,UN,UN, 2, 2, 2, 2, 2, 2, 2,UN, 2,
/*A0*/   2, 2, 2, 2, 2, 2, 2,UN, 2, 2, 2, 2,UN, 6, 2,UN,
/*B0*/   3, 3, 3, 3, 3, 3, 3, 4, 3, 3, 3, 3, 2, 5, 3, 4,
/*C0*/   4, 4, 4, 4, 4, 4, 4, 5, 4, 4, 4, 4, 3, 6, 4, 5,
/*D0*/   5, 5, 5, 5, 5, 5, 5, 6, 5, 5, 5, 5, 4, 7, 5, 6,
/*E0*/   4, 4, 4, 4, 4, 4, 4, 5, 4, 4, 4, 4, 3, 6, 4, 5,
/*F0*/   3, 3, 3, 3, 3, 3, 3, 4, 3, 3, 3, 3, 2, 5, 3, 4
};

int mchtyp;
struct area *zpg;

/*
 * Process a machine op.
 */
VOID
machine(mp)
struct mne *mp;
{
	int op, t1, t2, type;
	struct expr e1, e2, e3;
	struct sym *sp;
	char id[NCPS];
	int c, v1, v3;

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

	case S_INH:
		outab(op);
		break;

	case S_BRA:
		expr(&e1, 0);
		outab(op);
		if (e1.e_base.e_ap == dot.s_area) {
			v1 = (int) (e1.e_addr - dot.s_addr - 1);
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
			outab(op+0x10);
			break;
		}
		if (t1 == S_X) {
			outab(op+0x20);
			break;
		}
		if (t1 == S_DIR || t1 == S_EXT) {
			outab(op);
			outrb(&e1, R_PAG0);
			break;
		}
		if (t1 == S_IX) {
			outab(op+0x40);
			break;
		}
		if (t1 == S_I8X || t1 == S_INDX) {
			outab(op+0x30);
			outrb(&e1, R_USGN);
			break;
		}
		xerr('a', "Invalid Addressing Mode.");
		break;

	case S_TYP2:
		t1 = addr(&e1);
		if (t1 == S_IMMED) {
			if ((op == 0xA7) ||
			    (op == 0xAC) ||
			    (op == 0xAF))
				aerr();
			outab(op);
			outrb(&e1, 0);
			break;
		}
		if (t1 == S_DIR) {
			outab(op+0x10);
			outrb(&e1, R_PAG0);
			break;
		}
		if (t1 == S_EXT) {
			outab(op+0x20);
			outrw(&e1, 0);
			break;
		}
		if (t1 == S_IX) {
			outab(op+0x50);
			break;
		}
		if (t1 == S_I8X) {
			outab(op+0x40);
			outrb(&e1, R_USGN);
			break;
		}
		if (t1 == S_INDX) {
			outab(op+0x30);
			outrw(&e1, 0);
			break;
		}
		xerr('a', "Invalid Addressing Mode.");
		break;

	case S_TYP3:
		t1 = addr(&e1);
		if (t1 != S_IMMED)
			xerr('a', "Require Immediate(#) For First Argument.");
		comma(1);
		t2 = addr(&e2);
		if (t2 != S_DIR)
			xerr('a', "Require Direct Mode For Second Argument.");
		if (is_abs(&e1)) {
			v1 = (int) e1.e_addr;
			if (v1 & ~0x07)
				xerr('a', "Valid Bit Values Are 0 -> 7.");
			outab(op | ((v1 & 0x07) << 1));
		} else {
			outrbm(&e1, R_MBRO | R_3BIT, op);
		}
		outrb(&e2, R_PAG0);
		break;

	case S_TYP4:
		t1 = addr(&e1);
		if (t1 != S_IMMED)
			xerr('a', "Require Immediate(#) For First Argument.");
		comma(1);
		t2 = addr(&e2);
		if (t2 != S_DIR)
			xerr('a', "Require Direct Mode For Second Argument.");
		comma(1);
		expr(&e3, 0);
		if (is_abs(&e1)) {
			v1 = (int) e1.e_addr;
			if (v1 & ~0x07)
				xerr('a', "Valid Bit Values Are 0 -> 7.");
			outab(op | ((v1 & 0x07) << 1));
		} else {
			outrbm(&e1, R_MBRO | R_3BIT, op);
		}
		outrb(&e2, R_PAG0);
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

	default:
		opcycles = OPCY_ERR;
		xerr('o', "Internal Opcode Error.");
		break;
	}

	if (opcycles == OPCY_NONE) {
		if (mchtyp != 0) {
			opcycles = mcmcyc[cb[0] & 0xFF];
		} else {
			opcycles = m05cyc[cb[0] & 0xFF];
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
mchpcr(esp, v, n)
struct expr *esp;
int *v;
int n;
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
VOID
minit()
{
	/*
	 * Byte Order
	 */
	hilo = 1;

	/*
	 * Zero Page
	 */
	zpg = NULL;

	mchtyp = X_6805;
	sym[2].s_addr = X_6805;
}
