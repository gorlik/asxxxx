/* t90mch.c */

/*
 *  Copyright (C) 2026 Alan R. Baldwin
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
 */

#include <limits.h>
#include "asxxxx.h"
#include "t90.h"

char *cpu = "Toshiba TLCS90 Series";
char *dsft = "asm";

/*
 * Opcode Cycle Definitions
 */
#define OPCY_SDP	((char) (0xFF))
#define OPCY_ERR	((char) (0xFE))

#define OPCY_NONE	((char) (0x80))
#define OPCY_MASK	((char) (0x7F))

#define UN	((char) (OPCY_NONE | 0x00))
#define	P1	((char) (OPCY_NONE | 0x01))
#define P2	((char) (OPCY_NONE | 0x02))
#define P3	((char) (OPCY_NONE | 0x03))
#define P4	((char) (OPCY_NONE | 0x04))
#define P5	((char) (OPCY_NONE | 0x05))
#define P6	((char) (OPCY_NONE | 0x06))

/*
 * TLCS-90 Opcode Cycle Pages (Always Maximum Cycles)
 */

static char  t90pg0[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   2, 4, 2, 2,UN,UN,UN,10, 2, 2, 2, 4, 2, 2, 2,10,
/*10*/   2, 2,16,16, 6, 6, 6, 8,10,10, 8,10,14,16,10,14,
/*20*/   2, 2, 2, 2, 2, 2, 2, 8, 2, 2, 2, 2, 2, 2, 2, 8,
/*30*/   4, 4, 4, 4, 4, 4, 4,10, 6, 6, 6,UN, 6, 6, 6,14,
/*40*/   4, 4, 4,UN, 4, 4, 4,10, 4, 4, 4,UN, 4, 4, 4,10,
/*50*/   8, 8, 8,UN, 8, 8, 8,UN,10,10,10,UN,10,10,10,UN,
/*60*/   8, 8, 8, 8, 8, 8, 8, 8, 4, 4, 4, 4, 4, 4, 4, 4,
/*70*/  10,10,10,10,10,10,10,10, 6, 6, 6, 6, 6, 6, 6, 6,
/*80*/   2, 2, 2, 2, 2, 2, 2,10, 2, 2, 2, 2, 2, 2, 2,10,
/*90*/   4, 4, 4,UN, 4, 4, 4,14, 4, 4, 4,UN, 4, 4, 4,14,
/*A0*/   2, 2, 2, 2, 2, 2, 2, 2, 8, 8, 8, 8, 8, 8, 8, 8,
/*B0*/  12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,
/*C0*/   8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8,
/*D0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*E0*/  P2,P2,P2,P3,P2,P2,P2,P4,P2,P2,P2,P3,P2,P2,P2,P4,
/*F0*/  P5,P5,P5,P6,P5,P5,P5,P6,P1,P1,P1,P1,P1,P1,P1,20
};

static char  t90pg1[256] = {  /* P1 == F8 -> FE */
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*10*/  UN,UN,18,18, 8, 8, 8,UN, 8, 8, 8, 8, 8, 8, 8, 8,
/*20*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*30*/   4, 4, 4, 4, 4, 4, 4,UN, 6, 6, 6,UN, 6, 6, 6,UN,
/*40*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*50*/  UN,UN,UN,UN,UN,UN,UN,UN,14,18,14,18,14,18,14,18,
/*60*/   4, 4, 4, 4, 4, 4, 4, 4, 6, 6, 6, 6, 6, 6, 6, 6,
/*70*/   8, 8, 8, 8, 8, 8, 8, 8,UN,UN,UN,UN,UN,UN,UN,UN,
/*80*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*90*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*A0*/   4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
/*B0*/   4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
/*C0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*D0*/  14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,
/*E0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*F0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN
};

static char  t90pg2[256] = {  /* P2 == E0->E2 / E4->E6 / E8->EA / EC->EE [(rr)] */
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*10*/  12,12,18,18, 8, 8, 8,UN,12,12,12,12,12,12,12,12,
/*20*/   6, 6, 6, 6, 6, 6, 6,UN, 6, 6, 6, 6, 6, 6, 6, 6,
/*30*/  UN,UN,UN,UN,UN,UN,UN, 8,UN,UN,UN,UN,UN,UN,UN,12,
/*40*/   8, 8, 8,UN, 8, 8, 8,UN, 8, 8, 8,UN, 8, 8, 8,UN,
/*50*/  14,14,14,UN,14,14,14,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*60*/   6, 6, 6, 6, 6, 6, 6, 6,10,10,10,10,10,10,10,10,
/*70*/   8, 8, 8, 8, 8, 8, 8, 8,UN,UN,UN,UN,UN,UN,UN,UN,
/*80*/  UN,UN,UN,UN,UN,UN,UN, 8,UN,UN,UN,UN,UN,UN,UN, 8,
/*90*/  UN,UN,UN,UN,UN,UN,UN,12,UN,UN,UN,UN,UN,UN,UN,12,
/*A0*/   8, 8, 8, 8, 8, 8, 8, 8, 6, 6, 6, 6, 6, 6, 6, 6,
/*B0*/  10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,
/*C0*/   8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8,
/*D0*/  14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,
/*E0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*F0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN
};

static char  t90pg3[256] = {  /* P3 == E3 / EB [(mn)] */
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*10*/  16,16,22,22,12,12,12,UN,16,16,16,16,16,16,16,16,
/*20*/  10,10,10,10,10,10,10,UN,10,10,10,10,10,10,10,10,
/*30*/  UN,UN,UN,UN,UN,UN,UN,12,UN,UN,UN,UN,UN,UN,UN,16,
/*40*/  12,12,12,UN,12,12,12,UN,12,12,12,UN,12,12,12,UN,
/*50*/  18,18,18,UN,18,18,18,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*60*/  10,10,10,10,10,10,10,10,14,14,14,14,14,14,14,14,
/*70*/  12,12,12,12,12,12,12,12,UN,UN,UN,UN,UN,UN,UN,UN,
/*80*/  UN,UN,UN,UN,UN,UN,UN,12,UN,UN,UN,UN,UN,UN,UN,12,
/*90*/  UN,UN,UN,UN,UN,UN,UN,16,UN,UN,UN,UN,UN,UN,UN,16,
/*A0*/  12,12,12,12,12,12,12,12,10,10,10,10,10,10,10,10,
/*B0*/  14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,
/*C0*/  12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,
/*D0*/  18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,
/*E0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*F0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN
};

static char  t90pg4[256] = {  /* P4 == E7 / EF [(n)] */
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*10*/  14,14,20,20,UN,UN,UN,UN,14,14,14,14,14,14,14,14,
/*20*/   8, 8, 8, 8, 8, 8, 8,UN, 8, 8, 8, 8, 8, 8, 8, 8,
/*30*/  UN,UN,UN,UN,UN,UN,UN,10,UN,UN,UN,UN,UN,UN,UN,14,
/*40*/  10,10,10,UN,10,10,10,UN,10,10,10,UN,10,10,10,UN,
/*50*/  16,16,16,UN,16,16,16,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*60*/  UN,UN,UN,UN,UN,UN,UN,UN,12,12,12,12,12,12,12,12,
/*70*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*80*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*90*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*A0*/  10,10,10,10,10,10,10,10,UN,UN,UN,UN,UN,UN,UN,UN,
/*B0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*C0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*D0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*E0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*F0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN
};

static char  t90pg5[256] = {  /* P6 == F0->F3 / F4->F6 [(IX+d)] */
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*10*/  16,16,22,22,12,12,12,UN,16,16,16,16,16,16,16,16,
/*20*/  10,10,10,10,10,10,10,UN,10,10,10,10,10,10,10,10,
/*30*/  UN,UN,UN,UN,UN,UN,UN,12,UN,UN,UN,UN,UN,UN,UN,16,
/*40*/  12,12,12,UN,12,12,12,UN,12,12,12,UN,12,12,12,UN,
/*50*/  18,18,18,UN,18,18,18,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*60*/  10,10,10,10,10,10,10,10,14,14,14,14,14,14,14,14,
/*70*/  12,12,12,12,12,12,12,12,UN,UN,UN,UN,UN,UN,UN,UN,
/*80*/  UN,UN,UN,UN,UN,UN,UN,12,UN,UN,UN,UN,UN,UN,UN,12,
/*90*/  UN,UN,UN,UN,UN,UN,UN,16,UN,UN,UN,UN,UN,UN,UN,16,
/*A0*/  12,12,12,12,12,12,12,12,10,10,10,10,10,10,10,10,
/*B0*/  14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,
/*C0*/  12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,
/*D0*/  18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,
/*E0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*F0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN
};

static char  t90pg6[256] = {  /* P6 == F3 / F7 [(HL+A)] */
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*10*/  20,20,26,26,16,16,16,UN,20,20,20,20,20,20,20,20,
/*20*/  14,14,14,14,14,14,14,UN,14,14,14,14,14,14,14,14,
/*30*/  UN,UN,UN,UN,UN,UN,UN,16,UN,UN,UN,UN,UN,UN,UN,20,
/*40*/  16,16,16,UN,16,16,16,UN,16,16,16,UN,16,16,16,UN,
/*50*/  22,22,22,UN,22,22,22,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*60*/  14,14,14,14,14,14,14,14,18,18,18,18,18,18,18,18,
/*70*/  16,16,16,16,16,16,16,16,UN,UN,UN,UN,UN,UN,UN,UN,
/*80*/  UN,UN,UN,UN,UN,UN,UN,16,UN,UN,UN,UN,UN,UN,UN,16,
/*90*/  UN,UN,UN,UN,UN,UN,UN,20,UN,UN,UN,UN,UN,UN,UN,20,
/*A0*/  16,16,16,16,16,16,16,16,14,14,14,14,14,14,14,14,
/*B0*/  18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,18,
/*C0*/  16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,16,
/*D0*/  22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,
/*E0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*F0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN
};

static char *t90Page[7] = {
  t90pg0,
  t90pg1, t90pg2, t90pg3,
  t90pg4, t90pg5, t90pg6
};

struct area *zpg;

void
machine(struct mne *mp)
{
	int op, t1, t2;
	int rf, v1, v2;
	struct expr e1, e2;
	int c;
	char id[NCPS];
	char *p;

	/*
	 * Using Internal Format
	 * For Cycle Counting
	 */
	opcycles = OPCY_NONE;

	clrexpr(&e1);
	clrexpr(&e2);

	op = (int) mp->m_valu;
	rf = mp->m_type;

	switch(rf) {

	case S_SDP:
		opcycles = OPCY_SDP;
		e1.e_addr = 0xFF00;
		zpg = dot.s_area;
		if (more()) {
			expr(&e1, 0);
			if (e1.e_flag == 0 && e1.e_base.e_ap == NULL) {
				if (e1.e_addr != 0xFF00) {
					e1.e_addr = 0xFF00;
					xerr('b', "Direct Page = 0xFF00");
				}
			}
			if ((c = getnb()) == ',') {
				getid(id, -1);
				zpg = alookup(id);
				if (zpg == NULL) {
					zpg = dot.s_area;
					xerr('u', "Undefined Area");
				}
			} else {
				unget(c);
			}
		}
		outdp(zpg, &e1, 0);
		lmode = SLIST;
		break;


	case S_LD:	/* LD */
		t1 = addr(&e1);
		v1 = aindx;
		comma(1);
		t2 = addr(&e2);
		v2 = aindx;

		/* ld r,r */
		if ((t1 == S_R8) && (t2 == S_R8)) {
			if (v1 == A) {
				op = 0x20 | v2;
			} else
			if (v2 == A) {
				op = 0x28 | v1;
			} else {
				op = 0x30 | v1;
				outab(0xF8 | v2);
			}
			outab(op);
			break;
		}
		/* ld r,n */
		if ((t1 == S_R8) && (t2 == S_MN)) {
			outab((op = 0x30 | v1));
			outrb(&e2, 0);
			break;
		}
		/* ld A,(n) */
		if ((t1 == S_R8) && (v1 == A)) {
			if (t2 == S_IN) {
				outab((op = 0x27));
				outab(e2.e_addr);
				break;
			}
			if (t2 == S_INPG) {
				outab((op = 0x27));
				outrb(&e2, R_PAGN);
				break;
			}
		}
		/* ld (n),A */
		if ((t2 == S_R8) && (v2 == A)) {
			if (t1 == S_IN) {
				outab((op = 0x2F));
				outab(e1.e_addr);
				break;
			}
			if (t1 == S_INPG) {
				outab((op = 0x2F));
				outrb(&e1, R_PAGN);
				break;
			}
		}
		/* ld rr,rr */
		if ((t1 == S_R16) && (t2 == S_R16)) {
			if (v1 == HL) {
				op = 0x40 | v2;
			} else
			if (v2 == HL) {
				op = 0x48 | v1;
			} else {
				op = 0x38 | v1;
				outab(0xF8 | v2);
			}
			outab(op);
			break;
		}
		/* ld rr,mn */
		if ((t1 == S_R16) && (t2 == S_MN)) {
			outab((op = 0x38 | v1));
			outrw(&e2, 0);
			break;
		}
		/* ld HL,(n) */
		if ((t1 == S_R16) && (v1 == HL)) {
			if (t2 == S_IN) {
				outab((op = 0x47));
				outab(e2.e_addr);
				break;
			}
			if (t2 == S_INPG) {
				outab((op = 0x47));
				outrb(&e2, R_PAGN);
				break;
			}
		}
		/* ld (n),HL */
		if ((t2 == S_R16) && (v2 == HL)) {
			if (t1 == S_IN) {
				outab((op = 0x4F));
				outab(e1.e_addr);
				break;
			}
			if (t1 == S_INPG) {
				outab((op = 0x4F));
				outrb(&e1, R_PAGN);
				break;
			}
		}
		/* Set Opcode */

		if (t1 == S_R8)  { op = 0x28 | v1;  } else
		if (t2 == S_R8)  { op = 0x20 | v2;  } else
		if (t1 == S_R16) { op = 0x48 | v1; } else
		if (t2 == S_R16) { op = 0x40 | v2; }

		if ((t1 == S_R8) || (t1 == S_R16)) {
			switch(t2) {
			case S_IR16:	outab(0xE0 | v2);	break;
			case S_IXYS:	outab(0xF0 | (v2 & XYSMASK));	outrb(&e2, 0);	break;
			case S_IHLA:	outab(0xF3);	break;
			case S_IMN:	outab(0xE3);	outrw(&e2, 0);	break;
			case S_IN:
			case S_INPG:
				if (t1 == S_R8)    outab(0xEF);
				if (t1 == S_R16)   outab(0xE7);
				if (t2 == S_IN)    outab(e2.e_addr);
				if (t2 == S_INPG)  outrb(&e2, R_PAGN);
				break;
			default:	qerr();		break;
			}
			outab(op);
		} else
		if ((t2 == S_R8) || (t2 == S_R16)) {
			switch(t1) {
			case S_IR16:	outab(0xE8 | v1);	break;
			case S_IXYS:	outab(0xF4 | (v1 & XYSMASK));	outrb(&e1, 0);	break;
			case S_IHLA:	outab(0xF7);	break;
			case S_IMN:	outab(0xEB);	outrw(&e1, 0);	break;
			case S_IN:	outab(0xEF);	outab(e1.e_addr);	break;
			case S_INPG:	outab(0xEF);	outrb(&e1, R_PAGN);	break;
			default:	qerr();		break;
			}
			outab(op);
		} else {
			if (t2 != S_MN) {
				xerr('a', "Second argument must be immediate");
				qerr();
			}
			switch(t1) {
			case S_IR16:	outab(0xE8 | v1);	break;
			case S_IXYS:	outab(0xF4 | (v1 & XYSMASK));	outrb(&e1, 0);	break;
			case S_IHLA:	outab(0xF7);	break;
			case S_IMN:	outab(0xEB);	outrw(&e1, 0);	break;
			case S_IN:	break;
			case S_INPG:	break;
			default:	qerr();		break;
			}
			outab((op = 0x37));
			if (t1 == S_IN)    outab(e1.e_addr);
			if (t1 == S_INPG)  outrb(&e1, R_PAGN);
			outrb(&e2, 0);
		}
		break;


	case S_LDW:	/* LDW */
		t1 = addr(&e1);
		v1 = aindx;
		comma(1);
		t2 = addr(&e2);
		v2 = aindx;

		if (t2 != S_MN) {
			xerr('a', "Second argument must be immediate");
			qerr();
		}
		switch(t1) {
		case S_IR16:	outab(0xE8 | v1);	break;
		case S_IXYS:	outab(0xF4 | (v1 & XYSMASK));	outrb(&e1, R_SGND);	break;
		case S_IHLA:	outab(0xF7);	break;
		case S_IMN:	outab(0xEB);	outrw(&e1, 0);	break;
		case S_IN:	break;
		case S_INPG:	break;
		default:	qerr();		break;
		}
		outab(op);
		if (t1 == S_IN)   outab(e1.e_addr);
		if (t1 == S_INPG) outrb(&e1, R_PAGN);
		outrw(&e2, 0);
		break;


	case S_PUSH: /* PUSH / POP */
		if (admode(R16A) != 0) {
			op |= aindx; outab(op);
		} else {
			xerr('a', "Only BC,DE,HL,IX,IY, and AF allowed");
		}
		break;


	case S_LDA:	/* LDA */
		t1 = addr(&e1);
		v1 = aindx;
		comma(1);
		t2 = addr(&e2);
		v2 = aindx;

		if (t1 != S_R16) {
			xerr('a', "Requires BC,DE,HL,IX,IY, or SP as first argument");
			qerr();
		}
		switch(t2) {
		case S_IXYS:	/* rr,[IX+d, IY+d, SP+d] */
			outab(0xF4 | (v2 & XYSMASK));
			outrb(&e2, R_SGND);
			break;
		case S_IHLA:	/* rr,(HL+A) */
			outab(0xF7);
		        break;
		default:
			xerr('a', "Requires HL+A, IX+d, IY+d, or SP+d as second argument");
			qerr();
			break;
		}
		op |= v1; outab(op);
		break;

	case S_EX:	/* EX */
		p = ip;
		if (admode(R16EX) != 0) {
			v1 = aindx;
			comma(1);
			if (admode(R16EX) != 0) {
				v2 = aindx;
				if ((v1 == DE && v2 == HL) || (v1 == HL && v2 == DE)) {		/* ex DE,HL or HL,DE*/
					outab((op = 0x08));
					break;
				} else
				if ((v1 == AF && v2 == AFP) || (v1 == AFP && v2 == AF)) {	/* ex AF,AF' or AF',AF */
					outab((op = 0x09));
					break;
				}
			}
		}
		ip = p;

		t1 = addr(&e1);
		v1 = aindx;
		comma(1);
		t2 = addr(&e2);
		v2 = aindx;

		if (t2 != S_R16) {
			xerr('a', "Second Argument must be BC,DE,HL,IX,IY, or SP");
			qerr();
		}
		switch(t1) {
		case S_IR16:	outab(0xE0 | v1);	break;
		case S_IXYS:	outab(0xF0 | (v1 & XYSMASK));	outrb(&e1, 0);	break;
		case S_IHLA:	outab(0xF3);	break;
		case S_IMN:	outab(0xE3);	outrw(&e1, 0);	break;
		case S_IN:	outab(0xE7);	outab(e1.e_addr);	break;
		case S_INPG:	outab(0xE7);	outrb(&e1, R_PAGN);	break;
		default:	qerr();		break;
		}
		op |= v2; outab(op);
		break;


	case S_INH2:	/* Double Byte OP */
		outab(0xFE);
	case S_INH1:	/* Singe Byte OP */
		outab(op);
		if (more()) {
			if (ccase[c = getnb()] != 'a') { unget(c); }
		}
		break;


	case S_TYP1:	/* ADD,ADC,SUB,SBC,AND,OR,XOR,CP */
		t1 = addr(&e1);
		v1 = aindx;
		comma(1);
		t2 = addr(&e2);
		v2 = aindx;

		if ((t2 == S_MN) && (t1 != S_R16)) {
			switch(t1) {
			case S_R8:	if (v1 != A) { outab(0xF8 | v1); }	break;
			case S_IR16:	outab(0xE8 | v1);	break;
			case S_IXYS:	outab(0xF4 | (v1 & XYSMASK));	outrb(&e1, R_SGND);	break;
			case S_IHLA:	outab(0xF7);	break;
			case S_IMN:	outab(0xEB);	outrw(&e1, 0);	break;
			case S_IN:	outab(0xEF);	outab(e1.e_addr);	break;
			case S_INPG:	outab(0xEF);	outrb(&e1, R_PAGN);	break;
			default:	qerr();	break;
			}
			op |= 0x08; outab(op);
			outrb(&e2, 0);
		} else
		if ((t1 == S_R8) && (v1 == A)) {
			if (t2 == S_IN)   { outab(op);	outab(e2.e_addr);	break; }
			if (t2 == S_INPG) { outab(op);	outrb(&e2, R_PAGN);	break; }
			switch(t2) {
			case S_R8:	outab(0xF8 | v2);	break;
			case S_IR16:	outab(0xE0 | v2);	break;
			case S_IXYS:	outab(0xF0 | (v2 & XYSMASK));	outrb(&e2, R_SGND);	break;
			case S_IHLA:	outab(0xF3);	break;
			case S_IMN:	outab(0xE3);	outrw(&e2, 0);	break;
			case S_IN:	outab(e2.e_addr);	break;
			case S_INPG:	outrb(&e2, R_PAGN);	break;
			default:	qerr();		break;
			}
			outab(op);
		} else
		if ((t1 == S_R16) && (v1 >= HL)) {
			if ((op != 0x60) && (v1 > HL)) qerr();
			if (v1 == HL) { op += 0x10; } else { op = 0x14 | v1; }
			switch(t2) {
			case S_R16:	outab(0xF8 | v2);	break;
			case S_MN:	if (v1 == HL) { op |= 0x08; }	break;
			case S_IR16:	outab(0xE0 | v2);	break;
			case S_IXYS:	outab(0xF0 | (v2 & XYSMASK));	outrb(&e2, R_SGND);	break;
			case S_IHLA:	outab(0xF3);	break;
			case S_IMN:	outab(0xE3);	outrw(&e2, 0);	break;
			case S_IN:	break;
			case S_INPG:	break;
			default:	qerr();		break;
			}
			outab(op);
			switch(t2) {
			case S_MN:	outrw(&e2, 0);		break;
			case S_IN:	outab(e2.e_addr);	break;
			case S_INPG:	outrb(&e2, R_PAGN);	break;
			default:	break;
			}
		} else {
			qerr();
		}
		break;


	case S_DEC:	/* DEC */
	case S_INC:	/* INC */
	case S_DECW:	/* DECW */
	case S_INCW:	/* INCW */
		t1 = addr(&e1);
		v1 = aindx;

		switch(t1) {
		case S_R8:
			switch(rf) {
			case S_INC:	op = 0x80 + v1;	break;
			case S_DEC:	op = 0x88 + v1;	break;
			default:	xerr('a', "INCW/DECW r not allowed");	qerr();	break;
			}
			break;
		case S_R16:
			switch(rf) {
			case S_INC:	op = 0x90 + v1;	break;
			case S_DEC:	op = 0x98 + v1;	break;
			default:	xerr('a', "INCW/DECW rr not allowed");	qerr();	break;
			}
			break;
		case S_IR16:	outab(0xE0 | v1);	break;
		case S_IXYS:	outab(0xF0 + (v1 & XYSMASK));	outrb(&e1, R_SGND);	break;
		case S_IHLA:	outab(0xF3);	break;
		case S_IMN:	outab(0xE3);	outrw(&e1, 0);	break;
		case S_IN:	break;
		case S_INPG:	break;
		default:	qerr();		break;
		}
		outab(op);
		if (t1 == S_IN)   { outab(e1.e_addr); }
		if (t1 == S_INPG) { outrb(&e1, R_PAGN); }
		break;

	case S_TYP2:	/* DECX / INCX */
		t1 = addr(&e1);

		switch(t1) {
		case S_IN:
			outab(op);
			outab(e1.e_addr);
			break;
		case S_INPG:
			outab(op);
			outrb(&e1, R_PAGN);
			break;
		case S_IMN:
			outab(op);
			outrb(&e1, R_PAGN);
			break;
		default:
			aerr();
			break;
		}
		break;


	case S_MLDV:	/* MUL / DIV */
		t1 = addr(&e1);
		v1 = aindx;
		comma(1);
		t2 = addr(&e2);
		v2 = aindx;

		if ((t1 != S_R16) || (v1 != HL)) {
			xerr('a', "HL must be first argument");
			qerr();
		}
		if (t2 == S_MN) {	/* n */
			outab(op);
			outrb(&e2, 0);
			break;
		}
		switch(t2) {
		case S_R8:	outab(0xF8 | v2);	break;
		case S_IR16:	outab(0xE0 | v2);	break;
		case S_IXYS:	outab(0xF0 | (v2 & XYSMASK));	outrb(&e2, 0);	break;
		case S_IHLA:	outab(0xF3);	break;
		case S_IMN:	outab(0xE3);	outrw(&e2, 0);	break;
		case S_IN:	outab(0xE7);	outab(e2.e_addr);	break;
		case S_INPG:	outab(0xE7);	outrb(&e2, R_PAGN);	break;
		default:	qerr();		break;
		}
		outab(op);
		break;


	case S_RLD:	/* RLD */
	case S_RRD:	/* RRD */
	case S_SHRO:	/* RLC,RRC,RL,RR,SLA,SRA,SLL,SRL */
		t1 = addr(&e1);
		v1 = aindx;

		switch(t1) {
		case S_R8:
			if ((rf == S_RLD) || (rf == S_RRD)) {
				xerr('a', "RLD and RRD do not support the 8-bit registers");
				qerr();
			} else {
				outab(0xF8 | v1);
			}
			break;
		case S_IR16:	outab(0xE0 | v1);	break; 
		case S_IXYS:	outab(0xF0 | (v1 & XYSMASK));	outrb(&e1, 0);	break;
		case S_IHLA:	outab(0xF3);	break;
		case S_IMN:	outab(0xE3);	outrw(&e1, 0);	break;
		case S_IN:	outab(0xE7);	outab(e1.e_addr);	break;
		case S_INPG:	outab(0xE7);	outrb(&e1, R_PAGN);	break;
		default:	qerr();		break;
		}
		outab(op);
		break;


	case S_BIT:	/* BIT */
	case S_RES:	/* RES */
	case S_SET:	/* SET */
	case S_TSET:	/* TEST == TSET */
		expr(&e1, 0);
		comma(1);
		t2 = addr(&e2);
		v2 = aindx;

		op |= (e1.e_addr & BTMASK);
		if (t2 == S_IN) {
			if (rf == S_TSET) {
				outab(0xE7);
				outab(e2.e_addr);
				outab(op);
			} else {
				outab(op);
				outab(e2.e_addr);
			}
			break;
		}
		if (t2 == S_INPG) {
			if (rf == S_TSET) {
				outab(0xE7);
				outrb(&e2, R_PAGN);
				outab(op);
			} else {
				outab(op);
				outrb(&e2, R_PAGN);
			}
			break;
		}
		switch(t2) {
		case S_R8:	outab(0xF8 | v2);	break;
		case S_IR16:	outab(0xE0 | v2);	break;
		case S_IXYS:	outab(0xF0 | (v2 & XYSMASK));	outrb(&e2, 0);	break;
		case S_IHLA:	outab(0xF3);	break;
		case S_IMN:	outab(0xE3);	outrw(&e2, 0);	break;
		default:	qerr();		break;
		}
		outab(op);
		break;


	case S_JP:	/* JP */
	case S_CALL:	/* CALL */
		if (admode(CND) != 0) {
			v1 = aindx;
			comma(1);
			t2 = addr(&e2);
			v2 = aindx;
			switch(t2) {
			case S_R16:	outab(0xE8 | v2);	break;
			case S_XYS:	outab(0xF4 | (v2 & XYSMASK));	outrb(&e2, R_SGND);	break;
			case S_HLA:	outab(0xF7);	break;
			case S_MN:	outab(0xEB);	outrw(&e2, 0);	break;
			default:	xerr('a', "Invalid 2nd argument");	qerr();	break;
			}
			if (rf == S_JP)   outab((op = 0xC0 | v1));
			if (rf == S_CALL) outab((op = 0xD0 | v1));
		} else {	/* mn */ 
			expr(&e2, 0);
			outab(op);
			outrw(&e2, 0);
		}
		break;


	case S_LDAR:	/* LDAR */
		if (admode(R16) && (aindx == HL)) { comma(1); } else { qerr(); }
	case S_CALR:	/* CALR */
	case S_JRL:	/* JRL */
		if (admode(PC) != 0) { *--ip = ' '; *--ip = '.'; }
		expr(&e2, 0);

		outab(op);
		if (mchpcr(&e2, &v2, 1)) {
			outaw(v2);
		} else {
			e2.e_addr += 1;
			outrw(&e2, R_PCR);
		}
		if (e2.e_mode != S_USER)
			rerr();
		break;


	case S_JR:	/* JR */
		if (admode(CND) != 0) {
			v1 = aindx;
			comma(1);
		} else {
			v1 = T;
		}
		if (admode(PC) != 0) { *--ip = ' '; *--ip = '.'; }
		expr(&e2, 0);

		op |= v1; outab(op);
		if (mchpcr(&e2, &v2, 1)) {
			if ((v2 < -128) || (v2 > 127))
				xerr('a', "Short Relative Address Is Out Of Range");
			outab(v2);
		} else {
			outrb(&e2, R_PCR);
		}
		if (e2.e_mode != S_USER)
			rerr();
		break;


	case S_DJNZ:	/* DJNZ */
		if (admode(R16) != 0) {
			if (aindx != BC) {
				xerr('a', "Only BC allowed");
				qerr();
			}
			op += 1;
			comma(1);
		}
		if (admode(PC) != 0) { *--ip = ' '; *--ip = '.'; }
		expr(&e2, 0);

		outab(op);
		if (mchpcr(&e2, &v2, 1)) {
			if ((v2 < -128) || (v2 > 127))
				xerr('a', "Short Relative Address Is Out Of Range");
			outab(v2);
		} else {
			outrb(&e2, R_PCR);
		}
		if (e2.e_mode != S_USER)
			rerr();
		break;


	case S_RET:	/* RET */
		if (more()) {	/* ret cc */
			if (admode(CND) != 0) {
				op = 0xD0 | aindx;
				outab(0xFE);
			} else 	{
				qerr();
			}
		}
		outab(op);
		break;


	default:
		opcycles = OPCY_ERR;
		err('o');
		break;
	}

	if (opcycles == OPCY_NONE) {
		opcycles = t90pg0[cb[0] & 0xFF];
		if ((opcycles & OPCY_NONE) && (opcycles & OPCY_MASK)) {
			opcycles = t90Page[opcycles & OPCY_MASK][op];
		}
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
 * Machine dependent initialization
 */

void
minit(void)
{
	struct expr e1;

	/*
	 * Byte Order
	 */
	hilo = 0;

	/*
	 * Default Zero Page
	 */
	clrexpr(&e1);
	e1.e_addr = 0xFF00;
	outdp(dot.s_area, &e1, 0);
}

