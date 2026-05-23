/* st6mch.c */

/*
 *  Copyright (C) 2010-2025  Alan R. Baldwin
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

#include "asxxxx.h"
#include "st6.h"

char	*cpu	= "STMicroelectronics ST6";
char	*dsft	= "asm";

/*
 * Opcode Cycle Definitions
 */
#define	OPCY_SDP	((char) (0xFF))
#define	OPCY_ERR	((char) (0xFE))
#define	OPCY_SKP	((char)	(0xFD))

#define	OPCY_NONE	((char) (0x80))
#define	OPCY_MASK	((char) (0x7F))

#define	UN	((char) (OPCY_NONE | 0x00))

/*
 * st6 Opcode Cycle Pages
 */

static char  st6pg[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   2, 4, 2, 5, 2,UN, 2, 4, 2, 4, 2, 4, 2, 4, 2, 4,
/*10*/   2, 4, 2, 5, 2, 4, 2, 4, 2, 4, 2, 4, 2, 4, 2, 4,
/*20*/   2, 4, 2, 5, 2,UN, 2, 4, 2, 4, 2, 4, 2, 4, 2, 4,
/*30*/   2, 4, 2, 5, 2, 4, 2, 4, 2, 4, 2, 4, 2, 4, 2, 4,
/*40*/   2, 4, 2, 5, 2,UN, 2, 4, 2, 4, 2, 4, 2, 2, 2, 4,
/*50*/   2, 4, 2, 5, 2, 4, 2, 4, 2, 4, 2, 4, 2, 4, 2, 4,
/*60*/   2, 4, 2, 5, 2,UN, 2, 4, 2, 4, 2, 4, 2, 2, 2, 4,
/*70*/   2, 4, 2, 5, 2, 4, 2,UN, 2, 4, 2, 4, 2, 4, 2, 4,
/*80*/   2, 4, 2, 5, 2,UN, 2, 4, 2, 4, 2, 4, 2,UN, 2, 4,
/*90*/   2, 4, 2, 5, 2, 4, 2,UN, 2, 4, 2, 4, 2, 4, 2, 4,
/*A0*/   2, 4, 2, 5, 2,UN, 2, 4, 2, 4, 2, 4, 2, 4, 2, 4,
/*B0*/   2, 4, 2, 5, 2,04, 2, 4, 2, 4, 2, 4, 2, 4, 2, 4,
/*C0*/   2, 4, 2, 5, 2,UN, 2, 4, 2, 4, 2, 4, 2, 2, 2, 4,
/*D0*/   2, 4, 2, 5, 2, 4, 2, 4, 2, 4, 2, 4, 2, 4, 2, 4,
/*E0*/   2, 4, 2, 5, 2,UN, 2, 4, 2, 4, 2, 4, 2, 2, 2, 4,
/*F0*/   2, 4, 2, 5, 2, 4, 2,UN, 2, 4, 2, 4, 2, 4, 2, 4,
};


/*
 * Process a machine op.
 */
void
machine(struct mne *mp)
{
	struct expr e1, e2, e3;
	int t1, t2;
	int v1, v2, v3;
	int op, rf;

	/*
	 * Using Internal Format
	 * For Cycle Counting
	 */
	opcycles = OPCY_NONE;

	clrexpr(&e1);
	clrexpr(&e2);
	clrexpr(&e3);
	op = (int) mp->m_valu;
	rf = mp->m_type;

	switch (rf) {
	/*
	 * S_AOP:
	 *	ADD, AND, CP, SUB
	 */
	case S_AOP:
		t2 = addr(&e2);
		v2 = rcode;
		comma(1);
		t1 = addr(&e1);
		v1 = rcode;
		if ((t2 == S_REG) && (v2 == A)) {
			switch(t1) {
			case S_REG:
				outab(op | 0x18);
				outab(v1);
				break;
			case S_VAL:
				outab(op | 0x18);
				outrb(&e1, R_USGN);
				break;
			case S_IX:
				switch(v1) {
				case X:		outab(op);		break;
				case Y:		outab(op | 0x08);	break;
				default:
					xerr('a', "Addressing mode supports only X and Y.");
					break;
				}
				break;
			case S_IMM:
				outab(op | 0x10);
				outrb(&e1, R_NORM);
				if (valu_err(&e1, 1))
					xerr('a', "First argument: Value < 128 or > 255.");
				break;
			default:
				xerr('a', "Invalid Addressing Mode.");
				break;
			}
		} else {
			xerr('a', "Invalid Addressing Mode.");
		}
		break;

	/*
	 * S_OPI:
	 *	ADDI, ANDI, CPI, SUBI
	 */
	case S_OPI:
		t2 = addr(&e2);
		v2 = rcode;
		comma(1);
		t1 = addr(&e1);
		v1 = rcode;
		if ((t2 == S_REG) && (v2 == A)) {
			switch(t1) {
			case S_IMM:
			case S_VAL:
				outab(op | 0x10);
				outrb(&e1, R_NORM);
				if (valu_err(&e1, 1))
					xerr('a', "First argument: Value < 128 or > 255.");
				break;
			default:
				xerr('a', "First argument not a #__ or value.");
				break;
			}
		} else {
			xerr('a', "Invalid Addressing Mode.");
		}
		break;

	/*
	 * S_BOP:
	 *	DEC, INC
	 */
	case S_BOP:
		t1 = addr(&e1);
		v1 = rcode;
		switch(t1) {
		case S_REG:
			if (v1 == A) {
				outab(op | 0x18);
				outab(0xFF);
			} else
			if (op == 0xE7) {	/* DEC */
				switch(v1) {
				case X:		outab(0x1D);	break;
				case Y:		outab(0x5D);	break;
				case V:		outab(0x9D);	break;
				case W:		outab(0xDD);	break;
				default:			break;
				}
			} else
			if (op == 0x67) {	/* INC */
				switch(v1) {
				case X:		outab(0x15);	break;
				case Y:		outab(0x55);	break;
				case V:		outab(0x95);	break;
				case W:		outab(0xD5);	break;
				default:			break;
				}
			} else {
				xerr('a', "Internal Opcode Error.");
			}
			break;
		case S_VAL:
			outab(op | 0x18);
			outrb(&e1, R_USGN);
			break;
		case S_IX:
			switch(v1) {
			case X:		outab(op);		break;
			case Y:		outab(op | 0x08);	break;
			default:
				xerr('a', "Addressing mode supports only X and Y.");
				break;
			}
			break;
		default:
			xerr('a', "Invalid Addressing Mode.");
			break;
		}
		break;

	/*
	 * S_LD:
	 *	LD  A,---
	 *	LD  ---,A
	 */
	case S_LD:
		t1 = addr(&e1);
		v1 = rcode;
		comma(1);
		t2 = addr(&e2);
		v2 = rcode;
		/*
		 * LD  A,---
		 */
		if ((t1 == S_REG) && (v1 == A)) {
			op = 0x07;
			switch(t2) {
			case S_REG:
				switch(v2) {
				case A:		outab(op | 0x18);
						outab(0xFF);	break;
				case X:		outab(0x35);	break;
				case Y:		outab(0x75);	break;
				case V:		outab(0xB5);	break;
				case W:		outab(0xF5);	break;
				default:			break;
				}
				break;
			case S_VAL:
				outab(op | 0x18);
				outrb(&e2, R_USGN);
				break;
			case S_IX:
				switch(v2) {
				case X:		outab(op);		break;
				case Y:		outab(op | 0x08);	break;
				default:
					xerr('a', "Addressing mode supports only X and Y.");
					break;
				}
				break;
			case S_IMM:
				outab	(op | 0x10);
				outrb(&e2, R_NORM);
				if (valu_err(&e2, 1))
					xerr('a', "Second argument: Value < 128 or > 255.");
				break;
			default:
				xerr('a', "Invalid Addressing Mode.");
				break;
			}
		} else
		/*
		 * LD  ---,A
		 */
		if ((t2 == S_REG) && (v2 == A)) {
			op = 0x87;
			switch(t1) {
			case S_REG:
				switch(v1) {
				case A:		outab(op | 0x18);
						outab(0xFF);	break;
				case X:		outab(0x3D);	break;
				case Y:		outab(0x7D);	break;
				case V:		outab(0xBD);	break;
				case W:		outab(0xFD);	break;
				default:			break;
				}
				break;
			case S_VAL:
				outab(op | 0x18);
				outrb(&e1, R_USGN);
				break;
			case S_IX:
				switch(v1) {
				case X:		outab(op);		break;
				case Y:		outab(op | 0x08);	break;
				default:
					xerr('a', "Addressing mode supports only X and Y.");
					break;
				}
				break;
			default:
				xerr('a', "Invalid Addressing Mode.");
				break;
			}
		} else {
			xerr('a', "Invalid Addressing Mode.");
		}
		break;

	/*
	 * S_LDI:
	 *	LDI  REG,#
	 *	LDI  ---,#
	 */
	case S_LDI:
		t1 = addr(&e1);
		v1 = rcode;
		comma(1);
		t2 = addr(&e2);
		v2 = rcode;
		switch(t2) {
		case S_IMM:
		case S_VAL:
			switch(t1) {
			case S_REG:
				if (v1 == A) {
					outab(op | 0x10);
				} else {
					outab(0x0D);
					outab(v1);
				}
				outrb(&e2, R_NORM);
				if (valu_err(&e2, 1))
					xerr('a', "Second argument: Value < 128 or > 255.");
				break;
			case S_VAL:
				outab(0x0D);
				outrb(&e1, R_USGN);
				outrb(&e2, R_NORM);
				if (valu_err(&e2, 1))
					xerr('a', "Second argument: Value < 128 or > 255.");
				break;
			default:
				xerr('a', "Invalid Addressing Mode.");
				break;
			}
			break;
		default:
			xerr('a', "Invalid Addressing Mode.");
			break;
		}
		break;

	/*
	 * S_CLJP:
	 *	CALL, JP
	 */
	case S_CLJP:
		expr(&e1, 0);
		outrwm(&e1, R_CLJP, op);
		break;

	/*
	 * S_JR:
	 *	JRC, JRNC
	 *	JRZ, JRNZ
	 */
	case S_JR:
		expr(&e1, 0);
		if (mchpcr(&e1, &v1, 1)) {
			if ((v1 < -16) || (v1 > 15))
				xerr('a', "Branching Range Exceeded.");
			outab(op | ((v1 & 0x1F) << 3));
		} else {
			outrbm(&e1, R_5BIT | R_PCR, op);
		}
		if (e1.e_mode != S_USER) {
			rerr();
		}
		break;

	/*
	 * S_JRB:
	 *	JRS, JRR
	 */
	case S_JRB:
		expr(&e1, 0);
		comma(1);
		expr(&e2, 0);
		comma(1);
		expr(&e3, 0);
		outrbm(&e1, R_3BIT | R_USGN, op);
		outrb(&e2, R_USGN);
		if (mchpcr(&e3, &v3, 1)) {
			if ((v3 < -128) || (v3 > 127))
				xerr('a', "Branching Range Exceeded.");
			outab(v3);
		} else {
			outrb(&e3, R_PCR);
		}
		if (e3.e_mode != S_USER) {
			rerr();
		}
		break;

	/*
	 * S_BRS:
	 *	RES, SET
	 */
	case S_BRS:
		expr(&e1, 0);
		comma(1);
		expr(&e2, 0);
		outrbm(&e1, R_3BIT | R_USGN, op);
		outrb(&e2, R_USGN);
		break;

	/*
	 * S_INH:
	 *	RET, RETI, STOP, WAIT
	 */
	case S_INH:
		outab(op);
		break;

	/*
	 * S_INHA:
	 *	COM, RCL
	 */
	case S_INHA:
		t1 = addr(&e1);
		v1 = rcode;
		if (v1 == A) {
			outab(op);
		} else {
			xerr('a', "Argument must be A.");
		}
		break;

	default:
		opcycles = OPCY_ERR;
		xerr('o', "Internal Opcode Error.");
		break;
	}

	if (opcycles == OPCY_NONE) {
		opcycles = st6pg[cb[0] & 0xFF];
	}
	/*
	 * Translate To External Format
	 */
	if (opcycles == OPCY_NONE) { opcycles  =  CYCL_NONE; } else
	if (opcycles  & OPCY_NONE) { opcycles |= (CYCL_NONE | 0x3F00); }
}

/*
 * Return 1 if the absolute value is not
 * a valid unsigned or signed value.
 * Else return 0.
 */
int
valu_err(struct expr *e, int n)
{
	a_uint v;

	if (is_abs(e)) {
		v = e->e_addr;
		switch(n) {
		default:
#ifdef	LONGINT
		case 1:	if ((v & ~0x000000FFl) && ((v & ~0x000000FFl) != ~0x000000FFl)) return(1);
		case 2:	if ((v & ~0x0000FFFFl) && ((v & ~0x0000FFFFl) != ~0x0000FFFFl)) return(1);
		case 3:	if ((v & ~0x00FFFFFFl) && ((v & ~0x00FFFFFFl) != ~0x00FFFFFFl)) return(1);
		case 4:	if ((v & ~0xFFFFFFFFl) && ((v & ~0xFFFFFFFFl) != ~0xFFFFFFFFl)) return(1);
#else
		case 1:	if ((v & ~0x000000FF) && ((v & ~0x000000FF) != ~0x000000FF)) return(1);
		case 2:	if ((v & ~0x0000FFFF) && ((v & ~0x0000FFFF) != ~0x0000FFFF)) return(1);
		case 3:	if ((v & ~0x00FFFFFF) && ((v & ~0x00FFFFFF) != ~0x00FFFFFF)) return(1);
		case 4:	if ((v & ~0xFFFFFFFF) && ((v & ~0xFFFFFFFF) != ~0xFFFFFFFF)) return(1);
#endif
		}
	}
	return(0);
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

