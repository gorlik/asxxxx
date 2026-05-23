/* i40mch.c */

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
#include "i40.h"

char	*cpu	= "Intel 4040/4004 MCS-4";
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
 * 4040 Cycle Count
 *
 *	opcycles = i40pg1[opcode]
 */
static char i40pg1[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8,UN,
/*10*/  16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,
/*20*/   8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8,
/*30*/   8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8,
/*40*/  16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,
/*50*/  16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,
/*60*/   8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8,
/*70*/  16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,
/*80*/   8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8,
/*90*/   8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8,
/*A0*/   8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8,
/*B0*/   8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8,
/*C0*/   8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8,
/*D0*/   8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8,
/*E0*/   8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8,
/*F0*/   8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8,UN,UN
};

int cputype;

/*
 * Process machine ops.
 */
void
machine(struct mne *mp)
{
	unsigned int op;
	struct expr e1,e2;
	int t1,t2;
	a_uint v1,v2;

	/*
	 * Using Internal Format
	 * For Cycle Counting
	 */
	opcycles = OPCY_NONE;

	clrexpr(&e1);
	clrexpr(&e2);
	t1 = t2 = 0;
	v1 = v2 = 0;
	op = (int) mp->m_valu;
	switch (mp->m_type) {

	case S_CPU:
		sym[2].s_addr = op;
		break;

	case S_I04:
		outab(op);
		break;

	case S_I40:
		if (sym[2].s_addr == S_4040) {
			outab(op);
		} else {
			xerr('o', "Not A 4004 Instruction.");
		}
		break;

	case S_ADD:
	case S_SUB:
	case S_LD:
	case S_XCH:
	case S_INC:
	case S_ISZ:
		t1 = addr(&e1);
		v1 = e1.e_addr;
		if (mp->m_type == S_ISZ) {
			comma(1);
			t2 = addr(&e2);
			v2 = e2.e_addr;
		}
		switch(t1) {
		case S_REG:
			outab(op | v1);
			break;
		case S_EXT:
			if (is_abs(&e1)) {
				if (e1.e_addr & ~0x0F) {
					xerr('a', "Valid Register Is 0 -> 15.");
				}
				outab(op | (v1 & 0x0F));
			} else {
				outrbm(&e1, R_4BIT | R_MBRO, op);
			}
			break;
		default:
			xerr('a', "RPn And #n Are Invalid Arguments.");
			break;
		}
		if (mp->m_type == S_ISZ) {
			switch(t2) {
			case S_EXT:
				outrb(&e2, R_PAGX1);
				break;
			default:
				xerr('a', "Rn, RPn And #n Are Invalid Second Arguments.");
				break;
			}
		}
		break;

	case S_FIM:
	case S_SRC:
	case S_FIN:
	case S_JIN:
		t1 = addr(&e1);
		v1 = e1.e_addr;
		if (mp->m_type == S_FIM) {
			comma(1);
			t2 = addr(&e2);
			v2 = e2.e_addr;
		}
		switch(t1) {
		case S_REGP:
			outab(op | (v1 << 1));
			break;
		case S_REG:
			if (v1 & 0x01) {
				xerr('a', "Rn Must Be Even.");
			}
			outab(op | (v1 & 0x0E));
			break;
		case S_EXT:
			if (is_abs(&e1)) {
				if (e1.e_addr & ~0x07) {
					xerr('a', "Valid Register Pair Is 0 -> 7.");
				}
				outab(op | (v1 << 1));
			} else {
				outrbm(&e1, R_3BIT | R_MBRO, op);
			}
			break;
		default:
			xerr('a', "#n Is An Invalid Argument.");
			break;
		}
		if (mp->m_type == S_FIM) {
			switch(t2) {
			case S_IMM:
			case S_EXT:
				if (is_abs(&e2)) {
					outab(v2);
				} else {
					outrb(&e2, 0);
				}
				break;
			default:
				xerr('a', "Rn And RPn Are Invalid Second Arguments.");
				break;
			}
		}
		break;

	case S_JCN:
		t1 = addr(&e1);
		v1 = e1.e_addr;
		comma(1);
		t2 = addr(&e2);
		v2 = e2.e_addr;
		switch(t1) {
		case S_IMM:
		case S_EXT:
			if (is_abs(&e1)) {
				v2 = 0;
				if (v1 & 0x10) v2++;
				if (v1 & 0x20) v2++;
				if (v1 & 0x40) v2++;
				if (v2 > 1) {
					xerr('a', "Argument Contains Conflicting Conditions.");
				}
				outab(op | (v1 & 0x0F));
			} else {
				outrbm(&e1, R_4BIT | R_MBRO, op);
			}
			break;
		default:
			xerr('a', "Rn And RPn Are Invalid Arguments.");
			break;
		}
		switch(t2) {
		case S_EXT:
			outrb(&e2, R_PAGX1);
			break;
		default:
			xerr('a', "Rn, RPn And #n Are Invalid Arguments.");
			break;
		}
		break;

	case S_JCC:
		t1 = addr(&e1);
		v1 = e1.e_addr;
		outab(op);
		switch(t1) {
		case S_EXT:
			outrb(&e1, R_PAGX1);
			break;
		default:
			xerr('a', "Rn, RPn, #n, And Condition Codes Are Invalid Arguments.");
			break;
		}
		break;

	case S_JUN:
	case S_JMS:
		t1 = addr(&e1);
		v1 = e1.e_addr;
		switch(t1) {
		case S_EXT:
			if (is_abs(&e1)) {
				outaw((op << 8) | (v1 & 0x0FFF));
			} else {
				outrwm(&e1, R_12BIT | R_MBRO, (op << 8));
			}
			break;
		default:
			xerr('a', "Rn, RPn, And #n Are Invalid Arguments.");
			break;
		}
		break;

	case S_BBL:
	case S_LDM:
		t1 = addr(&e1);
		v1 = e1.e_addr;
		switch(t1) {
		case S_IMM:
		case S_EXT:
			if (is_abs(&e1)) {
				outab(op | (v1 & 0x0F));
			} else {
				outrbm(&e1, R_4BIT, op);
			}
			break;
		default:
			xerr('a', "Rn And RPn Are Invalid Arguments.");
			break;
		}
		break;

	default:
		opcycles = OPCY_ERR;
		xerr('o', "Internal Opcode Error.");
		break;
	}
	if (opcycles == OPCY_NONE) {
		if ((sym[2].s_addr == S_4004) && (mp->m_type == S_I40))  {
			/* Not 4004 Instructions */
		} else
		if (mp->m_type == S_FIM) {
			opcycles = 16;
		} else {
			opcycles = i40pg1[cb[0] & 0xFF];
		}
	}
 	/*
	 * Translate To External Format
	 */
	if (opcycles == OPCY_NONE) { opcycles  =  CYCL_NONE; } else
	if (opcycles  & OPCY_NONE) { opcycles |= (CYCL_NONE | 0x3F00); }
}

/*
 *Machine specific initialization.
 */

void
minit(void)
{
	/*
	 * Byte Order
	 */
	hilo = 1;

	/*
	 * CPU Type
	 */
	sym[2].s_addr = S_4040;
}


