/* cop8mch.c */

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
#include "cop8.h"

char	*cpu	= "National Semiconductor COP800 Family";
char	*dsft	= "asm";

/*
 * Opcode Cycle Definitions
 */
#define	OPCY_SDP	((char) (0xFF))
#define	OPCY_ERR	((char) (0xFE))

#define	OPCY_NONE	((char) (0x80))
#define	OPCY_MASK	((char) (0x7F))

#define	OPCY_SKP	((char)	(0xFD))

#define	UN	((char) (OPCY_NONE | 0x00))

/*
 * COP8 Cycle Count
 *
 *	opcycles = coppg1[opcode]
 */
static char coppg1[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   7, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
/*10*/   3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
/*20*/   3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
/*30*/   5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
/*40*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*50*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*60*/   2,UN,UN,UN, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1,
/*70*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*80*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 5, 5, 5,
/*90*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 2, 2,
/*A0*/   1, 1, 2, 2, 3, 3, 1,UN, 1, 3, 2, 2, 4, 5, 1,UN,
/*B0*/   1,UN, 3, 3, 1, 1, 3,UN, 1, 1, 3, 3, 3, 4, 3,UN,
/*C0*/   3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
/*D0*/   3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
/*E0*/   3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
/*F0*/   3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3
};


struct area *zpg;
a_uint xtnd;

/*
 * Process machine ops.
 */
void
machine(struct mne *mp)
{
	unsigned int op,c;
	char id[NCPS];
	struct expr e1,e2;
	struct sym *sp;
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

	if (zpg == NULL) {
		zpg = alookup("_DATA");
		outdp(zpg, &e1, 0);
	}

	icheck(op);

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
 
	case S_XTND:
		opcycles = OPCY_SKP;
		lmode = SLIST;
		if (more()) {
			expr(&e1, 0);
			xtnd = e1.e_addr;
		} else {
			xtnd = 0;
		}
		break;
		
	case S_TYP1:	/* adc, add, and, andsz, ifeq, ifne, ifgt, or, subc, xor */
		t1 = addr(&e1);
		v1 = e1.e_addr;
		comma(1);
		t2 = addr(&e2);
		v2 = e2.e_addr;
		switch(t1) {
		case S_REGA:
			if((op == 0x50) && (t2 != S_IMM)) {	/* andsz  A, #N */
 		        	xerr('a', "Only A # Allowed For Second Argument.");
 			}
			switch(t2) {
			case S_IDX:	/* A, [B] */
				if (v2 == S_IB) {
					outab(op);
				} else {
					xerr('a', "Only [B] Allowed.");
				}
				break;
			case S_IMM:	/* A, #N */
				if (op != 0xB9) {	/* != ifne */
					outab(op + 0x10);
				} else {
					outab(0x99);	/* ifne */
				}
				outrb(&e2, 0);
				break;
			case S_REGN:	/* A, MD <- (Rn | 0xF0) */
				e2.e_addr |= 0xF0;
			case S_EXT:	/* A, MD */
				outab(0xBD);
				outrb(&e2, R_PAG0);
				outab(op);
				break;
			default:
				xerr('a', "Second Argument Not [B], #, Or An MD Address.");
				break;
			}
			break;
		case S_REGN:	/* MD <- (Rn | 0xF0), ... */
			e1.e_addr |= 0xF0;
		case S_EXT:
			if ((op == 0x82) && xtnd) {	/* ifeq  MD, #N */
				if (t2 == S_IMM) {
					outab(0xA9);
					outrb(&e1, R_PAG0);
					outrb(&e2, 0);
				} else {
					xerr('a', "Second Argument Must Be A #.");
				}
			} else {
				xerr('a', "First Argument Must Be 'A'.");
			}
			break;
		default:
			if ((op == 0x82) && xtnd) {
				xerr('a', "First Argument Must Be 'A' Or A #.");
			} else {
				xerr('a', "First Argument Must Be 'A'.");
			}
			break;
		}
		break;

	case S_TYP2:	/* clr, dcor, dec, inc, rrc */
		t1 = addr(&e1);
		v1 = e1.e_addr;
		if (t1 == S_REGA) {	/* A */
			outab(op);
		} else {
			xerr('a', "Only 'A' Allowed As Argument.");
		}
		break;

	case S_TYP3:	/* ifbit, rbit, sbit */
		t1 = addr(&e1);
		v1 = e1.e_addr;
		comma(1);
		t2 = addr(&e2);
		v2 = e2.e_addr;
		switch(t1) {
		case S_EXT:	/* Treat As # */
		/*	xerr('a', "Treating Value Without # As #N.");	*/
		case S_IMM:	/* # */
			switch(t2) {
			case S_IDX:	/* #, [B] */
				if (v2 == S_IB) {
					outrbm(&e1, R_3BIT | R_MBRO, op);
				} else {
					xerr('a', "Only [B] Allowed.");
				}
				break;
			case S_REGN:	/* #, MD <- (Rn | 0xF0) */
				e2.e_addr |= 0xF0;
			case S_EXT:	/* #, MD */
				outab(0xBD);
				outrb(&e2, R_PAG0);
				outrbm(&e1, R_3BIT | R_MBRO, op);
				break;
			default:
				xerr('a', "Second Argument Not [B] Or An MD Address.");
				break;
			}
			break;
		default:
			xerr('a', "First Argument Must Be A #.");
			break;
 		}
		break;

	case S_DRSZ:	/* DRSZ */
		t1 = addr(&e1);
		v1 = e1.e_addr;
		switch(t1) {
		case S_EXT:	/* Treat As # */
		/*	xerr('a', "Treating Value Without # As #N.");	*/
		case S_REGN:	/* Register Number */
		case S_IMM:	/* # */
			if (is_abs(&e1)) {
				if (v1 & ~0x0F) {
					xerr('a', "Argument Must Be R0-R15, B, X, SP, S Or In The Range #0-#15.");
				} else {
					outab(op | v1);
				}
			} else {
				outrbm(&e1, R_4BIT | R_MBRO, op);
			}
			break;
		default:
			xerr('a', "Argument Must Be R0-R15, B, X, SP, S Or In The Range #0-#15.");
			break;
		}
		break;

	case S_IFBNE:	/* IFBNE */
		t1 = addr(&e1);
		v1 = e1.e_addr;
		switch(t1) {
		case S_EXT:	/* Treat As # */
		/*	xerr('a', "Treating Value Without # As #N.");	*/
		case S_IMM:	/* # */
			if (is_abs(&e1)) {
				if (v1 & ~0x0F) {
					xerr('a', "Argument Must Be In The Range 0 to 15.");
				} else {
					outab(op | v1);
				}
			} else {
				outrbm(&e1, R_4BIT | R_MBRO, op);
			}
			break;
		default:
			xerr('a', "Argument Must Be In The Range 0 to 15.");
			break;
		}
		break;

	case S_JMP:	/* JMP, JSR */
		t1 = addr(&e1);
		if (t1 == S_EXT) {
			setgbl(&e1);
			outrwm(&e1, R_12BIT | R_PAGX1, op);
		} else {
			xerr('a', "An Address is Required.");
		}
		break;

	case S_JMPL:	/* JMPL, JSRL */
		t1 = addr(&e1);
		if (t1 == S_EXT) {
			outab(op);
			outrw(&e1, 0);
		} else {
			xerr('a', "An Address is Required.");
		}
		break;

	case S_JP:	/* JP */
		expr(&e1, 0);
		if (mchpcr(&e1, &t1, 1)) {
			if ((t1 < -32) || (t1 > 31)) {
				xerr('a', "Branching Range Exceeded.");
			} else
			if (t1 == 0) {
				xerr('a', "Branching To Next Address Is Not Allowed.");
			} else {
				outab(t1);
			}
		} else {
			xerr('a', "Branch Address Must Be Local.");
		}
		break;

	case S_LD:	/* LD */
		t1 = addr(&e1);
		v1 = e1.e_addr;
		comma(1);
		t2 = addr(&e2);
		v2 = e2.e_addr;
		switch(t1) {
		case S_REGA:
			switch(t2) {
			case S_IDX:	/* A, [B/B+/B-/X/X+/X-] */
				outab(op | v2);
				break;
			case S_IMM:	/* A, # */
				outab(0x98);
				outrb(&e2, 0);
				break;
			case S_REGN:	/* A, MD <- (Rn | 0xF0) */
				e2.e_addr |= 0xF0;
			case S_EXT:	/* A, MD */
				outab(0x9D);
				outrb(&e2, R_PAG0);
				break;
			default:
				xerr('a', "Second Argument Must Be [..], #, Or An MD Address.");
				break;
			}
			break;
		case S_REGN:
			if (v1 == S_B) {
				switch(t2) {
				case S_EXT:	/* B, Treat As # */
					xerr('a', "Treating Value Without # As #N.");
				case S_IMM:	/* B, # */
					if (is_abs(&e2) && !(v2 & ~0x0F)) {
						/* B, # */
						outab(0x50 | (15 - v2));
					} else {
						if (xtnd) {
							/* B, # */
							outab(0x9F);
							outrb(&e2, 0);
						} else {
							/* B, # */
							outab(0xD0 | v1);
							outrb(&e2, 0);
						}
					}
					break;
				default:
					xerr('a', "Second Argument Must Be A #.");
					break;
				}
			} else {
				switch(t2) {
				case S_EXT:	/* Rn, Treat As # */
					xerr('a', "Treating Value Without # As #N.");
				case S_IMM:	/* Rn, # */
					outab(0xD0 | v1);
					outrb(&e2, 0);
					break;
				default:
					xerr('a', "Second Argument Must Be A #.");
					break;
				}
			}
			break;
		case S_IDX:
			if (!(v1 & 0x10)) {
				switch(t2) {
				case S_EXT:	/* [B/B+/B-], Treat As # */
					xerr('a', "Treating Value Without # As #N.");
				case S_IMM:	/* [B/B+/B-], # */
					outab(0x90 | v1);
					outrb(&e2, 0);
					break;
				default:
					xerr('a', "Second Argument Must Be A #.");
					break;
				}
			} else {
				xerr('a', "First Argument Must Be [B], [B+], Or {B-].");
			}
			break;
		case S_EXT:
			switch(t2) {
			case S_EXT:	/* MD, Treat As # */
				xerr('a', "Treating Value Without # As #N.");
			case S_IMM:	/* MD, # */
				outab(0xBC);
				outrb(&e1, R_PAG0);
				outrb(&e2, 0);
				break;
			default:
				xerr('a', "Second Argument Must Be A #.");
				break;
			}
			break;
		default:
			aerr();
			break;
		}
		break;

	case S_XCHNG:	/* X */
		t1 = addr(&e1);
		v1 = e1.e_addr;
		comma(1);
		t2 = addr(&e2);
		v2 = e2.e_addr;
		if (t1 == S_REGA) {
			switch(t2) {
			case S_IDX:	/* A, [B/B+/B-/X/X+/X-] */
				outab(op | (v2 & 0x17));
				break;
			case S_REGN:	/* A, MD <- (Rn | 0xF0) */
				e2.e_addr |= 0xF0;
			case S_EXT:	/* A, MD */
				outab(0x9C);
				outrb(&e2, R_PAG0);
				break;
			default:
				xerr('a', "Second Argument Must Be [..] Or An MD Address.");
				break;
			}
		} else {
			aerr();
		}
		break;

	case S_INH:	/* All Others */
		outab(op);
		break;

	default:
		opcycles = OPCY_ERR;
		xerr('o', "Internal Opcode Error.");
		break;
	}
	if (opcycles == OPCY_NONE) {
		opcycles = coppg1[cb[0] & 0xFF];
	}
	/*
	 * Translate To External Format
	 */
	if (opcycles == OPCY_NONE) { opcycles  =  CYCL_NONE; } else
	if (opcycles  & OPCY_NONE) { opcycles |= (CYCL_NONE | 0x3F00); }
}

/*
 * Preprocess Checking For Extended Instructions
 */

char errstr[80];

void
icheck(unsigned int op)
{
	char *id;

	if (xtnd == 0) {
		id = NULL;
		switch(op) {
		case 0x50:	id = "andsz";	break;
		case 0xB9:	id = "ifne";	break;
		case 0x8C:	id = "pop";	break;
		case 0x67:	id = "push";	break;
		case 0xA8:	id = "rlc";	break;
		case 0xB5:	id = "rpnd";	break;
		case 0xB4:	id = "vis";	break;
		default:			break;
		}
		if (id) {
			sprintf(errstr, "%s - Is An Extended Instruction.", id);
			xerr('o', errstr);
		}
	}
}

/*
 * Make Number Relocatable
 */
void
setgbl(struct expr *esp)
{
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
	 * (Re)Set Extended Instructions Flag
	 */
	xtnd = 0;

	/*
	 * Zero Page Area Pointer
	 */
	zpg = NULL;
}

