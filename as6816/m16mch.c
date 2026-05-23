/* m16mch.c */

/*
 *  Copyright (C) 1991-2025  Alan R. Baldwin
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
#include "m6816.h"

char	*cpu	= "Motorola 68HC16";
char	*dsft	= "asm";

#define	NB	512

int	*bp;
int	bm;
int	bb[NB];

/*
 * Opcode Cycle Definitions
 */
#define	OPCY_SDP	((char) (0xFF))
#define	OPCY_ERR	((char) (0xFE))

#define	OPCY_NONE	((char) (0x80))
#define	OPCY_MASK	((char) (0x7F))

#define	UN	((char) (OPCY_NONE | 0x00))
#define	P1	((char) (OPCY_NONE | 0x01))
#define	P2	((char) (OPCY_NONE | 0x02))
#define	P3	((char) (OPCY_NONE | 0x03))

static char  m16pg0[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   8, 8, 8, 8, 8, 4, 6,UN, 8, 8,14,14, 8, 8, 8, 8,
/*10*/   8, 8, 8, 8, 8, 4, 6,P1, 8, 8,14,14, 8, 8, 8, 8,
/*20*/   8, 8, 8, 8, 8, 4, 6,P2, 8, 8,14,14, 8, 8, 8, 8,
/*30*/   8, 8, 8, 8, 4, 4,10,P3, 8, 8,14,14, 2, 2, 2, 2,
/*40*/   6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 4, 8, 6, 6, 6, 6,
/*50*/   6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 4, 8, 6, 6, 6, 6,
/*60*/   6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 4, 8, 6, 6, 6, 6,
/*70*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 6,12, 2,UN,UN,UN,
/*80*/   6, 6, 6, 6, 6, 6, 6, 6, 6,12, 4,12, 4, 4, 4, 4,
/*90*/   6, 6, 6, 6, 6, 6, 6, 6, 6,12, 4,12, 4, 4, 4, 4,
/*A0*/   6, 6, 6, 6, 6, 6, 6, 6, 6,12, 4,12, 4, 4, 4, 4,
/*B0*/   6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,
/*C0*/   6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 4,12, 6, 6, 6, 6,
/*D0*/   6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 4,12, 6, 6, 6, 6,
/*E0*/   6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 4,12, 6, 6, 6, 6,
/*F0*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2,10, 6, 2,UN,UN,UN
};

static char  m16pg1[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   8, 8, 8, 8, 8, 6, 6,UN, 8, 8,UN,UN, 8, 8, 8, 8,
/*10*/   8, 8, 8, 8, 8, 6, 6,UN, 8, 8,UN,UN, 8, 8, 8, 8,
/*20*/   8, 8, 8, 8, 8, 6, 6,UN, 8, 8,UN,UN, 8, 8, 8, 8,
/*30*/   8, 8, 8, 8, 8, 6, 6,UN,UN,UN,UN,UN, 8, 8, 8, 8,
/*40*/   6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,UN, 6, 6, 6, 6,
/*50*/   6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,UN, 6, 6, 6, 6,
/*60*/   6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,UN, 6, 6, 6, 6,
/*70*/   6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,UN, 6, 6, 6, 6,
/*80*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN, 6, 6, 6, 6,
/*90*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN, 6, 6, 6, 6,
/*A0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN, 6, 6, 6, 6,
/*B0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN, 6, 6, 6, 6,
/*C0*/   6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,UN, 6, 6, 6, 6,
/*D0*/   6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,UN, 6, 6, 6, 6,
/*E0*/   6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,UN, 6, 6, 6, 6,
/*F0*/   6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,UN, 6, 6, 6, 6
};

static char  m16pg2[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   8, 8, 8, 8, 8, 6, 6,UN,10,10,UN,UN, 8, 8, 8, 8,
/*10*/   8, 8, 8, 8, 8, 6, 6,UN,10,10,UN,UN, 8, 8, 8, 8,
/*20*/   8, 8, 8, 8, 8, 6, 6,UN,10,10,UN,UN, 8, 8, 8, 8,
/*30*/   8, 8, 8, 8, 8, 6, 6,UN,10,10,UN,UN, 8, 8, 8, 8,
/*40*/   6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 4,UN, 2, 2, 2, 2,
/*50*/   6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 4,UN, 2,UN, 2, 2,
/*60*/   6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 4,UN, 2, 2,UN, 2,
/*70*/   2, 8, 2, 8, 2, 2, 2,12, 2, 2, 2, 2, 2, 2, 2, 2,
/*80*/   6, 6, 6, 6, 6, 6, 6, 6, 6,UN, 6,UN,UN,UN,UN,UN,
/*90*/   6, 6, 6, 6, 6, 6, 6, 6, 6,UN, 6,UN,UN,UN,UN,UN,
/*A0*/   6, 6, 6, 6, 6, 6, 6, 6, 6,UN, 6,UN,UN,UN,UN,UN,
/*B0*/   8, 4, 4, 6, 6, 2, 4, 2,14,16, 4, 2,UN,UN,UN,UN,
/*C0*/   6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 4,UN,UN,UN,UN,UN,
/*D0*/   6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 4,UN,UN,UN,UN,UN,
/*E0*/   6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 4,UN,UN,UN,UN,UN,
/*F0*/   2,20, 2, 8, 2, 2, 2,12, 2,10, 2, 2, 2, 2, 2, 2
};

static char  m16pg3[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   2, 2, 2, 2, 2, 2, 2, 2, 4, 6, 2, 2, 2, 2, 2, 2,
/*10*/   2, 2, 2, 2, 2, 2, 2, 2, 4, 6, 2, 2, 2, 2, 2, 2,
/*20*/  16, 2, 2, 4,10,10, 8, 8,24,38,22,22, 2, 4,UN, 2,
/*30*/   4, 4, 4, 4, 4, 4, 4, 4, 4,UN, 4, 4, 4, 4, 4, 4,
/*40*/   6, 6, 6, 6, 6, 6, 6, 6, 4,UN, 6,UN, 2, 2, 2, 2,
/*50*/   6, 6, 6, 6, 6, 6, 6, 6, 4,UN, 6,UN, 2, 2, 2, 2,
/*60*/   6, 6, 6, 6, 6, 6, 6, 6, 4,UN, 6,UN, 2, 2, 2, 2,
/*70*/   6, 6, 6, 6, 6, 6, 6, 6, 4,UN, 6,UN, 4, 4, 4, 4,
/*80*/   6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,
/*90*/   6, 6,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN, 2, 2, 2, 2,
/*A0*/  UN,UN,UN,UN,UN,UN, 0,UN,UN,UN,UN,UN, 2, 2, 2, 2,
/*B0*/   4, 4, 4, 4, 4, 4, 4, 4, 4,UN,UN,UN, 4, 4, 4, 4,
/*C0*/   6, 6, 6, 6, 6, 6, 6, 6, 6,UN, 6,UN, 2, 2,UN,UN,
/*D0*/   6, 6, 6, 6, 6, 6, 6, 6, 6,UN, 6,UN, 2, 2,UN,UN,
/*E0*/   6, 6, 6, 6, 6, 6, 6, 6, 6,UN, 6,UN, 2, 2,UN,UN,
/*F0*/   6, 6, 6, 6, 6, 6, 6, 6, 6,UN, 6,UN, 2, 4,10,10
};

static char *Page[4] = {
    m16pg0, m16pg1, m16pg2, m16pg3
};

int MCH, BRX, IDX, IMM;

/*
 * Process a machine op.
 */
void
machine(struct mne *mp)
{
	int op, rf, cpg;
	struct expr e1, e2, e3;
	int t1, t2, vn;
	a_uint pc;
	INT32 of;

	/*
	 * Debug Symbols
	 */
	MCH = 0;	/* machine() Entered */
	BRX = 0;	/* mchbrcs() Addressing Debugging */
	IDX = 0;	/* mchindx() Addressing Debugging */
	IMM = 0;	/* mchimm()  Addressing Debugging */

if (MCH) fprintf(stderr, "machine(1) line = %d\n", getlnm());

	/*
	 * Using Internal Format
	 * For Cycle Counting
	 */
	opcycles = OPCY_NONE;

	clrexpr(&e1);
	clrexpr(&e2);
	clrexpr(&e3);
	if (dot.s_addr & 1) {
		dot.s_addr += 1;
	}
	pc = dot.s_addr;
	cpg = 0;
	vn = 0;
	op = (int) mp->m_valu;
	switch (rf = mp->m_type) {

	case S_SDP:
		xerr('a', "The 6816 Has No Direct Page Mode");
		opcycles = OPCY_SDP;
		break;

	case S_IMMA:
		t1 = addr(&e1);
		switch(t1) {
		case T_IMM:
			if (mchimm(&e1)) {
				outab(PAGE3);
				outab(op);
				outrw(&e1, R_SGND);
			} else {
				outab(op);
				outrb(&e1, R_SGND);
			}
			break;

		default:
			dot.s_addr += 4;
			xerr('a', "Immediate Argument Required");
			break;
		}
		break;

	case S_IMMB:
		t1 = addr(&e1);
		switch(t1) {
		case T_IMM:
			outab(op);
			sgnext8(&e1);
			outrb(&e1, R_SGND);
			break;

		default:
			dot.s_addr += 4;
			xerr('a', "Immediate Argument Required");
			break;
		}
		break;

	case S_IM16:
		t1 = addr(&e1);
		switch(t1) {
		case T_IMM:
			outab(PAGE3);
			outab(op);
			urngchk16(&e1);
			outrw(&e1, R_USGN);
			break;

		default:
			dot.s_addr += 4;
			xerr('a', "Immediate Argument Required");
			break;
		}
		break;

	case S_BIT:
		t1 = addr(&e1);
		comma(1);
		t2 = addr(&e2);
		if (t2 != T_IMM)
			xerr('a', "Last Argument Must Be Immediate");
		switch(t1) {
		case T_EXT:
			outab(op|0x30);
			urngchk8(&e2);
			outrb(&e2, R_USGN);
			urngchk16(&e1);
			outrw(&e1, R_USGN);
			break;

		default:
			if (t1 & T_INDX) {
				if (mchindx(t1, &e1)) {
					outab(op|(t1 & T_XYZ));
					outrb(&e2, R_USGN);
					outrw(&e1, R_SGND);
				} else {
					outab(PAGE1);
					outab(op|(t1 & T_XYZ));
					outrb(&e2, R_USGN);
					outrb(&e1, R_USGN);
				}
			} else {
				dot.s_addr += 4;
				xerr('a', "Invalid First Argument");
			}
			break;
		}
		break;

	case S_BITW:	/* BCLRW IND16,EXT,  BCLW EXT */
		t1 = addr(&e1);
		comma(1);
		t2 = addr(&e2);
		if (t2 != T_IMM)
			xerr('a', "Last Argument Must Be Immediate");
		switch(t1) {
		case T_EXT:
			outab(PAGE2);
			outab(op|0x30);
			urngchk16(&e1);
			outrw(&e1, R_USGN);
			urngchk16(&e2);
			outrw(&e2, R_USGN);
			break;

		default:
			if (t1 & T_INDX) {
				if (t1 & T_IND8)
					xerr('a', "X8 Indexing Is Not Allowed");
				outab(PAGE2);
				outab(op|(t1 & T_XYZ));
				sgnext16(&e1);
				outrw(&e1, R_SGND);
				urngchk16(&e2);
				outrw(&e2, R_USGN);
			} else {
				dot.s_addr += 4;
				xerr('a', "Invalid First Argument");
			}
			break;
		}
		break;

	case S_BRBT:
		t1 = addr(&e1);
		comma(1);
		t2 = addr(&e2);
		comma(1);
		addr(&e3);
		if ((t2 != T_IMM) && (t2 != T_EXT)) {
			xerr('a', "Invalid Second Argument");
		}
		switch(t1) {
		case T_EXT:
			outab(op|0x30);
			urngchk8(&e2);
			outrb(&e2, R_USGN);
			urngchk16(&e1);
			outrw(&e1, R_USGN);
			if (mchpcr(&e3)) {
				/*
				 * pc     = address of instruction
				 * offset = e3.e_addr - (pc + 6)
				 */
				of = (INT32) (e3.e_addr - (pc + 6));
				if ((of < (INT32) ~0x7FFF) || (of > (INT32) 0x7FFF))
					xerr('a', "Out Of Range Long Branch");
				outaw(of);
			} else {
				/* R_PCR is calculated relative to the
				 * PC value after the R_PCR word. This
				 * accounts for 6 of the 6 byte offset
				 * required.  Thus no offset adjustment
				 * is required.
				 */
				outrw(&e3, R_PCR);
			}
			break;

		default:
			if (t1 & T_INDX) {
				if (mchbrcs(t1,&e1,pc,&e3)) {
					/* Long Form */
					outab(op|(t1 & T_XYZ));
					urngchk8(&e2);
					outrb(&e2, R_USGN);
					outrw(&e1, R_SGND);
					if (mchpcr(&e3)) {
							/*
						 * pc     = address of instruction
						 * offset = e3.e_addr - (pc + 6)
						 */
						of = (INT32) (e3.e_addr - (pc + 6));
						if ((of < (INT32) ~0x7FFF) || (of > (INT32) 0x7FFF))
							xerr('a', "Out Of Range Long Branch");
						outaw(of);
					} else {
						/* R_PCR is calculated relative to the
						 * PC value after the R_PCR word. This
						 * accounts for 6 of the 6 byte offset
						 * required.  Thus no offset adjustment
						 * is required.
						 */
						outrw(&e3, R_PCR);
					}
				} else {
					/* Short Form */
					if (op == 0x0A)
						op = 0xCB;
					if (op == 0x0B)
						op = 0x8B;
					outab(op|(t1 & T_XYZ));
					urngchk8(&e2);
					outrb(&e2, R_USGN);
					outrb(&e1, R_SGND);
					if (mchpcr(&e3)) {
						/*
						 * pc     = address of instruction
						 * offset = e3.e_addr - (pc + 6)
						 */
						of = (INT32) (e3.e_addr - (pc + 6));
						if ((of < (INT32) ~0x7F) || (of > (INT32) 0x7F))
							xerr('a', "Out Of Range Short Branch");
						outab(of);
					} else {
						/* R_PCR is calculated relative to the
						 * PC value after the R_PCR byte. This
						 * accounts for 4 of the 6 byte offset
						 * required.  Thus a 2 byte adjustment
						 * is required.
						 */
						e3.e_addr -= 2;
						outrb(&e3, R_PCR);
					}
				}
			} else {
				dot.s_addr += 6;
				xerr('a', "Invalid First Argument");
			}
			break;
		}
		break;

	case S_LDED:
		t1 = addr(&e1);
		switch(t1) {
		case T_EXT:
			outab(PAGE2);
			outab(op);
			urngchk16(&e1);
			outrw(&e1, R_USGN);
			break;

		default:
			dot.s_addr += 4;
			xerr('a', "Invalid Argument");
			break;
		}
		break;

	case S_MAC:
		t1 = addr(&e1);
		if (more()) {
			comma(1);
			t2 = addr(&e2);
			if ((t1 != T_IMM) || !mchcon(&e1) ||
			    (t2 != T_IMM) || !mchcon(&e2))
				xerr('a', "Constant Arguments Are Required");
			outab(op);
			sgnext4(&e1);
			sgnext4(&e2);
			outab(((e1.e_addr << 4) & 0xF0) | (e2.e_addr & 0x0F));
		} else {
			if (t1 != T_IMM)
				xerr('a', "Immediate Argument Required");
			outab(op);
			urngchk8(&e1);
			outrb(&e1, R_USGN);
		}
		break;

	case S_PSHM:
		vn = 0;
		do {
			if ((t1 = admode(pshm)) == 0 || vn & t1)
				xerr('a', "Invalid Or Duplicate Argument");
			vn |= t1;
		} while (more() && comma(1));
		outab(op);
		outab(vn);
		break;

	case S_PULM:
		vn = 0;
		do {
			if ((t1 = admode(pulm)) == 0 || vn & t1)
				xerr('a', "Invalid Or Duplicate Argument");
			vn |= t1;
		} while (more() && comma(1));
		outab(op);
		outab(vn);
		break;

	case S_JXX:
		t1 = addr(&e1);
		switch(t1) {
		case T_EXT:
			if (op == 0x4B)
				outab(0x7A);
			if (op == 0x89)
				outab(0xFA);
			urngchk20(&e1);
			outr3bm(&e1, R_20BIT | R_MBRU, 0);
			break;

		default:
			if (t1 & T_INDX) {
				if (t1 & (T_IND8 | T_IND16))
					xerr('a', "A 20 Bit Indexed Instruction - Use X");
				outab(op|(t1 & T_XYZ));
				sgnext20(&e1);
				outr3bm(&e1, R_20BIT | R_MBRS, 0);
			} else {
				dot.s_addr += 4;
				xerr('a', "Invalid Argument");
			}
			break;
		}
		break;

	case S_MOV:
	case S_MOVX:
		t1 = addr(&e1);
		comma(1);
		t2 = addr(&e2);
		if((t1 == T_EXT) && (t2 == T_EXT)) {
			outab(PAGE3);
			outab(op|0xFE);
			urngchk16(&e1);
			outrw(&e1, R_USGN);
			urngchk16(&e2);
			outrw(&e2, R_USGN);
		} else
		if (rf == S_MOVX) {
			xerr('a', "Invalid Arguments For XMOVB/XMOVW");
		} else
		if((t1 & T_INDX) && (t2 == T_EXT)) {
			if (t1 & (T_Y|T_Z))
				xerr('a', "Only Index Register X Allowed For Post Indexing");
			if (t1 & T_IND16)
				xerr('a', "16-Bit Indexing Is Not Allowed");
			outab(op);
			sgnext8(&e1);
			outrb(&e1, R_SGND);
			urngchk16(&e2);
			outrw(&e2, R_USGN);
		} else
		if((t1 == T_EXT) && (t2 & T_INDX)) {
			if (t2 & (T_Y|T_Z))
				xerr('a', "Only Index Register X Allowed For Post Indexing");
			if (t2 & T_IND16)
				xerr('a', "16-Bit Indexing Is Not Allowed");
			outab(op|0x02);
			sgnext8(&e2);
			outrb(&e2, R_SGND);
			urngchk16(&e1);
			outrw(&e1, R_USGN);
		} else {
			dot.s_addr += 6;
			xerr('a', "Invalid Argument(s)");
		}
		break;

	case S_CMP:
	case S_LOAD:
	case S_STOR:
		t1 = addr(&e1);
		switch(t1) {
		case T_EXT:
			outab(PAGE1);
			outab(op|0x30);
			urngchk16(&e1);
			outrw(&e1, R_USGN);
			break;

		case T_IMM:
			outab(PAGE3);
			if (rf == S_CMP)
				outab(op|0x30);
			if (rf == S_LOAD)
				outab((op|0x30) & 0xBF);
			if (rf == S_STOR) {
				outab((op&0x0F) | 0x70);	/* Substitute CP_ */
				xerr('a', "Store Immediate Not Allowed");
			}
			sgnext16(&e1);
			outrw(&e1, R_SGND);
			break;

		default:
			if (t1 & T_INDX) {
				if (mchindx(t1, &e1)) {
					outab(PAGE1);
					outab(op|(t1 & T_XYZ));
					outrw(&e1, R_SGND);
				} else {
					outab(op|(t1 & T_XYZ));
					outrb(&e1, R_USGN);
				}
			} else {
				dot.s_addr += 4;
				xerr('a', "Invalid Argument");
			}
			break;
		}
		break;

	case S_SOPW:
		t1 = addr(&e1);
		switch(t1) {
		case T_EXT:
			outab(PAGE2);
			outab(op|0x30);
			urngchk16(&e1);
			outrw(&e1, R_USGN);
			break;

		default:
			if (t1 & T_INDX) {
				if (t1 & T_IND8)
					xerr('a', "X8 Indexing Is Not Allowed");
				outab(PAGE2);
				outab(op|(t1 & T_XYZ));
				sgnext16(&e1);
				outrw(&e1, R_SGND);
			} else {
				dot.s_addr += 4;
				xerr('a', "Invalid Argument");
			}
			break;
		}
		break;

	case S_SOP:
		t1 = addr(&e1);
		switch(t1) {
		case T_EXT:
			outab(PAGE1);
			outab(op|0x30);
			urngchk16(&e1);
			outrw(&e1, R_USGN);
			break;

		default:
			if (t1 & T_INDX) {
				if (mchindx(t1, &e1)) {
					outab(PAGE1);
					outab(op|(t1 & T_XYZ));
					outrw(&e1, R_SGND);
				} else {
					outab(op|(t1 & T_XYZ));
					outrb(&e1, R_USGN);
				}
			} else {
				dot.s_addr += 4;
				xerr('a', "Invalid Argument");
			}
			break;
		}
		break;

	case S_DOPEB:	/* ADDE.B */
		t1 = addr(&e1);
		switch(t1) {
		case T_IMM:	/* ADDE.B #ByteArg */
			outab(0x7C);
			sgnext8(&e1);
			outrb(&e1, R_SGND);
			break;

		default:
			dot.s_addr += 4;
			xerr('a', "Valid Only As ADDE.B #ByteArg");
			break;
		}
		break;

	case S_DOPE:
		t1 = addr(&e1);
		switch(t1) {
		case T_EXT:
			outab(PAGE3);
			outab(op|0x30);
			urngchk16(&e1);
			outrw(&e1, R_USGN);
			break;

		case T_IMM:
			if (op == 0x41) {
				if (mchimm(&e1)) {
					outab(PAGE3);
					outab((op|0x30)&0x3F);
					outrw(&e1, R_SGND);
				} else {
					outab(0x7C);
					outrb(&e1, R_SGND);
				}
			} else {
				if (op == 0x4A)
					xerr('a', "Store Immediate Not Allowed");
				outab(PAGE3);
				outab((op|0x30)&0x3F);
				sgnext16(&e1);
				outrw(&e1, R_SGND);
			}
			break;

		default:
			if (t1 & T_INDX) {
				if (t1 & T_IND8)
					xerr('a', "X8 Indexing Is Not Allowed");
				outab(PAGE3);
				outab(op|(t1 & T_XYZ));
				sgnext16(&e1);
				outrw(&e1, R_SGND);
			} else {
				dot.s_addr += 4;
				xerr('a', "Invalid Argument");
			}
			break;
		}
		break;

	case S_DOPDB:	/* ADDD.B */
		t1 = addr(&e1);
		switch(t1) {
		case T_IMM:	/* ADDD.B #ByteArg */
			outab(0xFC);
			sgnext8(&e1);
			outrb(&e1, R_SGND);
			break;

		default:
			dot.s_addr += 4;
			xerr('a', "Valid Only As ADDD.B #ByteArg");
			break;
		}
		break;

	case S_DOPD:
		t1 = addr(&e1);
		switch(t1) {
		case T_EXT:
			outab(PAGE3);
			outab(op|0x70);
			urngchk16(&e1);
			outrw(&e1, R_USGN);
			break;

		case T_IMM:
			if (op == 0x81) {	/* ADDD */
				if (mchimm(&e1)) {
					outab(PAGE3);
					outab(op|0x30);
					outrw(&e1, R_SGND);
				} else {
					outab(0xFC);
					outrb(&e1, R_SGND);
				}
			} else {
				if (op == 0x8A)
					xerr('a', "Store Immediate Not Allowed");
				outab(PAGE3);
				outab(op|0x30);
				sgnext16(&e1);
				outrw(&e1, R_SGND);
			}
			break;

		default:
			if (t1 & T_INDX) {
				if (mchindx(t1, &e1)) {
					outab(PAGE3);
					outab(op|0x40|(t1 & T_XYZ));
					outrw(&e1, R_SGND);
				} else {
					outab(op|(t1 & T_XYZ));
					outrb(&e1, R_USGN);
				}
			} else
			if (t1 & T_E_I) {
				outab(PAGE2);
				outab(op|(t1 & T_XYZ));
			} else {
				dot.s_addr += 4;
				xerr('a', "Invalid Argument");
			}
			break;
		}
		break;

	case S_DOP:
		t1 = addr(&e1);
		switch(t1) {
		case T_EXT:
			outab(PAGE1);
			outab(op|0x30);
			urngchk16(&e1);
			outrw(&e1, R_USGN);
			break;

		case T_IMM:
			if ((op == 0x4A) || (op == 0xCA))
				xerr('a', "Store Immediate Not Allowed");
 			outab(op|0x30);
			sgnext8(&e1);
			outrb(&e1, R_SGND);
			break;

		default:
			if (t1 & T_INDX) {
				if (mchindx(t1, &e1)) {
					outab(PAGE1);
					outab(op|(t1 & T_XYZ));
					outrw(&e1, R_SGND);
				} else {
					outab(op|(t1 & T_XYZ));
					outrb(&e1, R_USGN);
				}
			} else
			if (t1 & T_E_I) {
				outab(PAGE2);
				outab(op|(t1 & T_XYZ));
			} else {
				dot.s_addr += 4;
				xerr('a', "Invalid Argument");
			}
			break;
		}
		break;

	case S_INH37:
		cpg += PAGE3-PAGE2;

	case S_INH27:
		cpg += PAGE2;
		outab(cpg);
		outab(op);
		break;

	case S_LBRA:
		cpg += PAGE3-PAGE2;

	case S_LBSR:
		cpg += PAGE2;
		expr(&e1, 0);
		outab(cpg);
		outab(op);
		if (mchpcr(&e1)) {
			/*
			 * pc     = address of instruction
			 * offset = e1.e_addr - (pc + 6)
			 */
			of = (INT32) (e1.e_addr - (pc + 6));
			if ((of < (INT32) ~0x7FFF) || (of > (INT32) 0x7FFF))
				xerr('a', "Out Of Range Long Branch");
			outaw(of);
		} else {
			/*
			 * R_PCR is calculated relative to the
			 * PC value after the R_PCR word. This
			 * accounts for 4 of the 6 byte offset
			 * required.  Thus a 2 byte adjustment
			 * is required.
			 */
			e1.e_addr -= 2;
			outrw(&e1, R_PCR);
		}
		if (e1.e_mode != S_USER)
			rerr();
		break;

	case S_BRA:
	case S_BSR:
		expr(&e1, 0);
		outab(op);
		if (mchpcr(&e1)) {
			/*
			 * pc     = address of instruction
			 * offset = e1.e_addr - (pc + 6)
			 */
			of = (INT32) (e1.e_addr - (pc + 6));
			if ((of < (INT32) ~0x7F) || (of > (INT32) 0x7F))
				xerr('a', "Out Of Range Short Branch");
			outab(of);
		} else {
			/*
			 * R_PCR is calculated relative to the
			 * PC value after the R_PCR byte. This
			 * accounts for 2 of the 6 byte offset
			 * required.  Thus a 4 byte adjustment
			 * is required.
			 */
			e1.e_addr -= 4;
			outrb(&e1, R_PCR);
		}
		if (e1.e_mode != S_USER)
			rerr();
		break;

	default:
		opcycles = OPCY_ERR;
		xerr('o', "Internal Opcode Error.");
		break;
	}
	if (dot.s_addr & 1) {
		xerr('b', "Boundary Error Detected.");
		dot.s_addr += 1;
	}

	if (opcycles == OPCY_NONE) {
		opcycles = m16pg0[cb[0] & 0xFF];
		if ((opcycles & OPCY_NONE) && (opcycles & OPCY_MASK)) {
			opcycles = Page[opcycles & OPCY_MASK][cb[1] & 0xFF];
		}
	}
 	/*
	 * Translate To External Format
	 */
	if (opcycles == OPCY_NONE) { opcycles  =  CYCL_NONE; } else
	if (opcycles  & OPCY_NONE) { opcycles |= (CYCL_NONE | 0x3F00); }
}

/*
 * Sign Extend A 4 Bit Argument
 * And Check Argument Range
 */
void
sgnext4(struct expr *e1)
{
	if ((e1->e_addr & (a_uint) ~0x07) == (a_uint) 0x08)
		e1->e_addr |= (a_uint) ~0x07;
	srngchk4(e1);
}

/*
 * Signed 4 Bit Range Check
 */
void
srngchk4(struct expr *e1)
{
	if (mchcon(e1))
		if ((e1->e_addr > (a_uint) 0x07) &&
		   ((e1->e_addr & (a_uint) ~0x07) != (a_uint) ~0x07)) {
	   		xerr('a', "Out Of Range Signed Nibble Value");
	}
}

/*
 * Unsigned 4 Bit Range Check
 */
void
urngchk4(struct expr *e1)
{
	if (mchcon(e1)) {
		if ((e1->e_addr & (a_uint) ~0x0F) != (a_uint) 0)
			xerr('a', "Out Of Range Unsigned Nibble Value");
	}
}

/*
 * Sign Extend An 8 Bit Argument
 * And Check Argument Range
 */
void
sgnext8(struct expr *e1)
{
	if ((e1->e_addr & (a_uint) ~0x7F) == (a_uint) 0x80)
		e1->e_addr |= (a_uint) ~0x7F;
	srngchk8(e1);
}

/*
 * Signed 8 Bit Range Check
 */
void
srngchk8(struct expr *e1)
{
	if (mchcon(e1))
		if ((e1->e_addr > (a_uint) 0x7F) &&
		   ((e1->e_addr & (a_uint) ~0x7F) != (a_uint) ~0x7F)) {
	   		xerr('a', "Out Of Range Signed Byte Value");
	}
}

/*
 * Unsigned 8 Bit Range Check
 */
void
urngchk8(struct expr *e1)
{
	if (mchcon(e1)) {
		if ((e1->e_addr & (a_uint) ~0xFF) != (a_uint) 0)
	   		xerr('a', "Out Of Range Unsigned Byte Value");
	}
}

/*
 * Sign Extend 16 Bit Argument
 * And Check Argument Range
 */
void
sgnext16(struct expr *e1)
{
	if ((e1->e_addr & (a_uint) ~0x7FFF) == (a_uint) 0x8000)
		e1->e_addr |= (a_uint) ~0x7FFF;
	srngchk16(e1);
}

/*
 * Signed 16 Bit Range Check
 */
void
srngchk16(struct expr *e1)
{
	if (mchcon(e1)) {
		if ((e1->e_addr > (a_uint) 0x7FFF) &&
		   ((e1->e_addr & (a_uint) ~0x7FFF) != (a_uint) ~0x7FFF))
	   		xerr('a', "Out Of Range Signed Word Value");
	}
}

/*
 * Unsigned 16 Bit Range Check
 */
void
urngchk16(struct expr *e1)
{
	if (mchcon(e1)) {
#ifdef	LONGINT
		if ((e1->e_addr & (a_uint) ~0x0FFFFl) != (a_uint) 0)
#else
		if ((e1->e_addr & (a_uint) ~0x0FFFF) != (a_uint) 0)
#endif
	   		xerr('a', "Out Of Range Unsigned Word Value");
	}
}

/*
 * Sign Extend 20 Bit Argument
 * And Check Argument Range
 */
void
sgnext20(struct expr *e1)
{
#ifdef	LONGINT
		if ((e1->e_addr & (a_uint) ~0x7FFFFl) == (a_uint) 0x80000l)
			e1->e_addr |= (a_uint) ~0x7FFFFl;
#else
		if ((e1->e_addr & (a_uint) ~0x7FFFF) == (a_uint) 0x80000)
			e1->e_addr |= (a_uint) ~0x7FFFF;
#endif
	srngchk20(e1);
}

/*
 * Signed 20 Bit Range Check
 */
void
srngchk20(struct expr *e1)
{
	if (mchcon(e1)) {
#ifdef	LONGINT
		if ((e1->e_addr > (a_uint) 0x7FFFFl) &&
		   ((e1->e_addr & (a_uint) ~0x7FFFFl) != (a_uint) ~0x7FFFFl))
#else
		if ((e1->e_addr > (a_uint) 0x7FFFF) &&
		   ((e1->e_addr & (a_uint) ~0x7FFFF) != (a_uint) ~0x7FFFF))
#endif
	   		xerr('a', "Out Of Range Signed 20 Bit Value");
	}
}

/*
 * Unsigned 20 Bit Range Check
 */
void
urngchk20(struct expr *e1)
{
	if (mchcon(e1)) {
#ifdef	LONGINT
		if ((e1->e_addr & (a_uint) ~0xFFFFFl) != (a_uint) 0)
#else
		if ((e1->e_addr & (a_uint) ~0xFFFFF) != (a_uint) 0)
#endif
	   		xerr('a', "Out Of Range Unsigned 20 Bit Value");
	}
}

/*
 * Check if argument is a constant
 */
int
mchcon(struct expr *e1)
{
	if (e1->e_base.e_ap == NULL && e1->e_flag == 0) {
		return(1);
	}
	return(0);
}

/*
 * Configure Mode For BRCLR/BRSET (Signed 16/8 Bit and Long/Short Branch))
 */
int
mchbrcs(int t1, struct expr *e1, a_uint pc, struct expr *e2)
{
	int flag, flaga, flagb;
	INT32 of;

if (BRX) fprintf(stderr, "mchbrcs(1) e_addr(1) = %8X, line = %d\n", e1->e_addr, getlnm());
	sgnext16(e1);
if (BRX) fprintf(stderr, "mchbrcs(2) sgnext16(e_addr(1)) = %8X\n", e1->e_addr);
	if (t1 & T_IND8) {
		flag = 0;
	} else
	if (t1 & T_IND16) {
		flag = 1;
	} else
	if (pass == 0) {
		flag = 1;
	} else
	if (pass == 1) {
if (BRX) fprintf(stderr, "mchbrcs(3) e_addr(1) = %8X,  e_addr(2) = %8X\n", e1->e_addr, e2->e_addr);
		flag = 0;
		flaga = 0;
		flagb = 0;
		if (mchcon(e1)) {
			/* Check Address Range */
			if ((((INT32) e1->e_addr) > 127) ||
			    (((INT32) e1->e_addr) < -128) ||
			       e1->e_flag || e1->e_base.e_ap) {
				flaga = 1;
			}
		} else {
			flaga = 1;
		}
if (BRX) fprintf(stderr, "mchbrcs(4) Address Range flag is %d\n", flaga);
		if (e2->e_base.e_ap == dot.s_area) {
			/* Check Branch Range */
			/*
			 * pc     = address of instruction
			 * offset = e2->e_addr - (pc + 6)
			 */
			of = (INT32) (e2->e_addr - (pc + 6));
			if ((of < (INT32) ~0x7F) || (of > (INT32) 0x7F))
				flagb = 1;
		} else {
			flagb = 1;
		}
if (BRX) fprintf(stderr, "mchbrcs(5) Branch Range flag is %d\n", flagb);
		if (setbit(flaga | flagb))
			flag = 1;
	} else {
		flag = getbit();
	}
if (BRX) fprintf(stderr, "mchbrcs(6) flag = %d\n", flag);
	if (flag == 0) {
		sgnext8(e1);
		srngchk8(e1);
	}
	return(flag);
}

/*
 * Check Index Mode (Signed 16 Bit or Unsigned 8 Bit)
 */
int
mchindx(int t1, struct expr *e1)
{
	int flag;

if (IDX) fprintf(stderr, "mchindx(1) e_addr = %8X, line = %d\n", e1->e_addr, getlnm());
	sgnext16(e1);
if (IDX) fprintf(stderr, "mchindx(2) e_addr = %8X\n", e1->e_addr);
	if (t1 & T_IND8) {
		flag = 0;
	} else
	if (t1 & T_IND16) {
		flag = 1;
	} else
	if (pass == 0) {
		flag = 1;
	} else
	if (pass == 1) {
if (IDX) fprintf(stderr, "mchindx(3) e_addr = %8X\n", e1->e_addr);
		flag = 0;
		if ((e1->e_addr > (a_uint) 0xFF) || e1->e_flag || e1->e_base.e_ap)
			flag = 1;
		if (setbit(flag))
			flag = 1;
if (IDX) fprintf(stderr, "mchindx(4) flag set = %d\n", flag);
	} else {
		flag = getbit();
	}
if (IDX) fprintf(stderr, "mchindx(5) flag = %d\n", flag);
	if (flag == 0) {
		urngchk8(e1);
	}
	return(flag);
}

/*
 * Check Signed Immediate Range (16 or 8 Bit)
 */
int
mchimm(struct expr *e1)
{
	int flag;

if (IMM) fprintf(stderr, "mchimm(1) e_addr = %8X, line = %d\n", e1->e_addr, getlnm());
	sgnext16(e1);
if (IMM) fprintf(stderr, "mchimm(2) e_addr = %8X\n", e1->e_addr);
	if (pass == 0) {
		flag = 1;
	} else
	if (pass == 1) {
if (IMM) fprintf(stderr, "mchimm(3) e_addr = %8X\n", e1->e_addr);
		flag = 0;
		/* Check 16 Bit Range Within (a_uint) */
		if ((((INT32) e1->e_addr) > 127) ||
		    (((INT32) e1->e_addr) < -128) ||
		       e1->e_flag || e1->e_base.e_ap) {
			flag = 1;
		}
if (IMM) fprintf(stderr, "mchimm(4) flag set = %d\n", flag);
		if (setbit(flag))
			flag = 1;
	} else {
		flag = getbit();
	}
if (IMM) fprintf(stderr, "mchimm(5) flag = %d\n", flag);
	if (flag == 0) {
		srngchk8(e1);
	}
	return(flag);
}

/*
 * Machine specific initialization.
 * Set up the bit table.
 */
void
minit(void)
{
	/*
	 * 24-Bit Machine
	 */
	exprmasks(3);

	/*
	 * Byte Order
	 */
	hilo = 1;

	bp = bb;
	bm = 1;
}

/*
 * Store `b' in the next slot of the bit table.
 * If no room, force the longer form of the offset.
 */
int
setbit(int b)
{
	if (bp >= &bb[NB])
		return(1);
	if (b)
		*bp |= bm;
	bm <<= 1;
	if (bm == 0) {
		bm = 1;
		++bp;
	}
	return(b);
}

/*
 * Get the next bit from the bit table.
 * If none left, return a `1'.
 * This will force the longer form of the offset.
 */
int
getbit(void)
{
	int f;

	if (bp >= &bb[NB])
		return (1);
	f = *bp & bm;
	bm <<= 1;
	if (bm == 0) {
		bm = 1;
		++bp;
	}
	return (f ? 1 : 0);
}

/*
 * Branch/Jump PCR Mode Check
 */
int
mchpcr(struct expr *esp)
{
	if (esp->e_base.e_ap == dot.s_area) {
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

