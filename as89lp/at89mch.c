/* at89mch.c */

/*
 *  Copyright (C) 2019-2025  Alan R. Baldwin
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
#include "at89.h"

char	*cpu	= "Microchip[Atmel] AT89 Series Micropocessors";
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
#define	P1	((char) (OPCY_NONE | 0x01))

/*
 * AT89 Cycle Count
 *
 *	opcycles = at89pg0[opcode]
 */
static char at89pg0[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   1, 3, 4, 1, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1,
/*10*/   4, 5, 6, 1, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1,
/*20*/   4, 3, 5, 1, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1,
/*30*/   4, 5, 5, 1, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1,
/*40*/   3, 3, 2, 3, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1,
/*50*/   3, 5, 2, 3, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1,
/*60*/   3, 3, 2, 3, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1,
/*70*/   3, 5, 2, 2, 2, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*80*/   3, 3, 2, 3, 4, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*90*/   3, 5, 2, 3, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1,
/*A0*/   2, 3, 2, 2, 2,P1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*B0*/   2, 5, 2, 1, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
/*C0*/   3, 3, 2, 1, 1, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1,
/*D0*/   3, 5, 2, 1, 1, 4, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3,
/*E0*/   4, 3, 2, 2, 1, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1,
/*F0*/   4, 5, 2, 2, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
};

static char  at89pg1[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   2,UN,UN, 2,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*10*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*20*/  UN,UN,UN, 2,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*30*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*40*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*50*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*60*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*70*/  UN,UN,UN, 3,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*80*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*90*/   4,UN,UN, 4,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*A0*/  UN,UN,UN, 3, 9,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*B0*/  UN,UN,UN,UN,UN,UN, 4, 4,UN,UN,UN,UN,UN,UN,UN,UN,
/*C0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*D0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*E0*/   5,UN,UN,UN, 2,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*F0*/   5,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN
};

static char *Page[2] = {
    at89pg0, at89pg1
};

int at89lp;
a_uint regbnk;

/*
 * Process machine ops.
 */
void
machine(struct mne *mp)
{
	int op;
	int t1, t2, v1, v2;
	struct expr e1, e2;

	/*
	 * Using Internal Format
	 * For Cycle Counting
	 */
	opcycles = OPCY_NONE;

	clrexpr(&e1);
	clrexpr(&e2);

	op = (int) mp->m_valu;
	switch (mp->m_type) {

	case S_AT89LP:
		opcycles = OPCY_CPU;
		sym[2].s_addr = op	;	/* Machine Type */
		sym[4].s_addr = mp->m_flag;	/* Machine Extensions */
		at89lp = mp->m_flag;
		lmode = SLIST;
		break;

	case S_RBNK:
		regbnk = 0;
		if (more()) {
			regbnk = absexpr();
			if (regbnk > 3) {
				xerr('a', "Register Banks Are 0-3");
				regbnk = 0;
 			}
		}
		regbnk <<= regbnk;
		lmode = SLIST;
		break;

	case S_MOP:
		if (addr(&e1) != S_M)
			xerr('a', "Required Argument Is M");
	case S_BRK:
		if ((at89lp & EX_BRK) == 0)
			xerr('a', "Unsupported Instruction");
		outab(0xA5);
		outab(op);
		break;

	case S_MAC:	/* AB */
		if ((at89lp & EX_MAC) == 0)
			xerr('o', "Unsupported Instruction");
		if (addr(&e1) != S_AB)
			xerr('a', "Required Argument Is AB");
		outab(0xA5);
		outab(op);
		break;

	case S_INH:
		outab(op);
		break;

	case S_JMP11:
		/*
		 * 11 bit destination.
		 * Top 3 bits become the MSBs of the op-code.
		 */
		expr(&e1, 0);
		outrwm(&e1, R_PAGX2 | R_J11, op << 8);
		break;

	case S_JMP16:
		expr(&e1, 0);
		outab(op);
		outrw(&e1, R_NORM);
		break;

	case S_ACC:	/* A */
		t1 = addr(&e1);
		switch(t1) {
		case S_DIR:
		case S_EXT:
			if (is_abs(&e1) && (e1.e_addr == 0xE0)) {
				/*
				 * DIR/EXT == Address Of A
				 * Fall Through To case S_A
				 */
			} else {
				xerr('a', "Required Argument Is A");
				break;
			}

		case S_A:	/* A */
			outab(op);
			break;

		default:
			xerr('a', "Required Argument Is A");
		}
		break;

	case S_TYP1:
		/* A; direct; @R0; @R1; R0 to R7;  "INC" also allows DPTR and /DPTR */
		t1 = addr(&e1);
		
		switch (t1) {
		case S_DIR:	/* direct */
		case S_EXT:	/* extended */
			if (is_abs(&e1) && (e1.e_addr == 0xE0)) {
				/*
				 * DIR/EXT == Address Of A
				 * Fall Through To case S_A
				 */
			} else {
				outab(op + 5);
				outrb(&e1, R_PAG0);
				break;
			}

		case S_A:	/* A */
			outab(op + 4);
			break;

		case S_AT_R:	/* @R0 @R1 */
			outab(op + 6 + e1.e_addr);
			break;

		case S_REG:	/* R0 to R7 */
			outab(op + 8 + e1.e_addr);
			break;

		case S_NDPTR:	/* /DPTR */
			if ((at89lp & EX_DPTR) == 0)
				xerr('o', "Unsupported Instruction");
			outab(0xA5);
		case S_DPTR:	/* DPTR */
			outab( 0xA3);
			if (op != 0)	/* only INC (op=0) has DPTR and /DPTR modes */
				xerr('o', "Only INC Has This Addressing Mode");
			break;

		default:
			xerr('a', "Invalid Argument");
		}
		break;

	case S_TYP2:
		/* A,#imm; A,direct; A,@R0; A,@R1; A,R0 to A,R7 */
		t1 = addr(&e1);
		if (t1 != S_A)
			xerr('a', "First Argument Must Be A");
		comma(1);
		t2 = addr(&e2);
		
		switch (t2) {
		case S_IMMED:	/* A,#imm */
			outab(op + 4);
			outrb(&e2, R_NORM);
			break;

		case S_A:	/* A,A */ /* A Direct Mode */
			outab(op + 5);
			outab(0xE0);
			break;

		case S_DIR:	/* A,direct */
		case S_EXT:	/* A,extended */
			outab(op + 5);
			outrb(&e2, R_PAG0);
			break;

		case S_AT_R:	/* A,@R0 A,@R1 */
			outab(op + 6 + e2.e_addr);
			break;

		case S_REG:	/* A,R0 to A,R7 */
			outab(op + 8 + (e2.e_addr));
			break;

		default:
			xerr('a', "Invalid Second Argument");
		}
		break;

	case S_TYP3:
		/* dir,A; dir,#imm; 
		 * A,#imm; A,direct; A,@R0; A,@R1; A,R0 to A,R7 
		 * C,direct;  C,/direct
		 */
		t1 = addr(&e1);
		comma(1);
		t2 = addr(&e2);

		switch (t1) {
		case S_REG:	/* Rn,A */ /* A Direct Mode */
			switch (t2) {
			case S_A:	/* Rn,A */
				outab(op + 2);
				outab((int) (regbnk + e1.e_addr));
				break;

			case S_IMMED:	/* Rn,#imm */
				outab(op + 3);
				outab((int) (regbnk + e1.e_addr));
				outrb(&e2, R_NORM);
				break;

			case S_DIR:	/* Rn,ACC */
			case S_EXT:
				if (is_abs(&e2) && (e2.e_addr == 0xE0)) {
					outab(op + 2);
					outab((int) (regbnk + e1.e_addr));
					break;
				}

			default:
				xerr('a', "Invalid Second Argument");
			}
			break;

		case S_DIR:	/* direct,A */
		case S_EXT:	/* extended,A */
			if (is_abs(&e1) && (e1.e_addr == 0xE0)) {
				/*
				 * DIR/EXT == Address Of A
				 */
				switch (t2) {
				case S_A:	/* A,A */ /* A Direct Mode */
					outab(op + 5);
					outab(0xE0);
					break;

				case S_IMMED:	/* A,#imm */
					outab(op + 4);
					outrb(&e2, R_NORM);
					break;

				default:
					xerr('a', "Invalid Second Argument");
				}
			} else {
				switch (t2) {
				case S_A:	/* dir,A */
					outab(op + 2);
					outrb(&e1, R_PAG0);
					break;
			
				case S_IMMED:	/* direct,#imm */
					outab(op + 3);
					outrb(&e1, R_PAG0);
					outrb(&e2, R_NORM);
					break;

				default:
					xerr('a', "Invalid Second Argument");
				}
			}
			break;

		case S_A:	/* A,... */
			switch (t2) {
			case S_IMMED:	/* A,#imm */
				outab(op + 4);
				outrb(&e2, R_NORM);
				break;

			case S_A:	/* A,A */ /* A Direct Mode */
				outab(op + 5);
				outab(0xE0);
				break;

			case S_DIR:	/* A,dir */
			case S_EXT:
				outab(op + 5);
				outrb(&e2, R_PAG0);
				break;

			case S_AT_R:	/* A,@R0 A,@R1 */
				outab(op + 6 + e2.e_addr);
				break;

			case S_REG:	/* A,R0 to A,R7 */
				outab(op + 8 + e2.e_addr);
				break;

			default:
				xerr('a', "Invalid Second Argument");
			}
			break;

		case S_C:	/* C,... */
			/* XRL has no boolean version.  Trap it */
			if (op == 0x60)
				xerr('o', "XRL Has No Boolean Version");

			switch (t2) {
			case S_DIR:	/* C,dir */
			case S_EXT:
				outab(op + 0x32);
				outrb(&e2, R_PAG0);
				break;
			
			case S_NOT_BIT:	/* C,/dir */
				outab(op + 0x60);
				outrb(&e2, R_PAG0);
				break;
			
			default:
				xerr('a', "Invalid Second Argument");
			}
			break;

		default:
			xerr('a', "Invalid First Argument");
		}
		break;

	case S_TYP4:
		/* A,direct; A,@R0; A,@R1; A,R0 to A,R7 */
		t1 = addr(&e1);
		if (t1 != S_A)
			xerr('a', "First Argument Must Be A");
		comma(1);
		t2 = addr(&e2);

		switch (t2) {
		case S_A:	/* A,A */ /* A direct Mode */
			outab(op + 5);
			outab(0xE0);
			break;

		case S_DIR:	/* A,dir */
		case S_EXT:
			outab(op + 5);
			outrb(&e2, R_PAG0);
			break;

		case S_AT_R:	/* A,@R0 A,@R1 */
			outab(op + 6 + e2.e_addr);
			break;

		case S_REG:	/* A,R0 to A,R7 */
			outab(op + 8 + e2.e_addr);
			break;

		default:
			xerr('a', "Invalid Second Argument");
		}
		break;

	/* MOV instruction, all modes */
	case S_MOV:
		t1 = addr(&e1);
		comma(1);
		t2 = addr(&e2);

		switch (t1) {
		case S_REG:
			switch (t2) {
			case S_IMMED:	/* R0,#imm to R7,#imm */
				outab(0x78 + e1.e_addr);
				outrb(&e2, R_NORM);
				break;

			case S_REG:	/* R0,Rn to R7,Rn */ /* A Direct Mode */
				outab(0xA8 + e1.e_addr);
				outab((int) (regbnk + e2.e_addr));
				break;

			case S_AT_R:	/* R0,@R0/@R1 to R7,@R0/@R1 */ /* An InDirect Mode */
				outab(0x86 + e2.e_addr);
				outab((int) (regbnk + e1.e_addr));
				break;

			case S_DIR:	/* R0,dir to R7,dir */
			case S_EXT:
				if (is_abs(&e2) && (e2.e_addr == 0xE0)) {
					/*
					 * DIR/EXT == Address Of A
					 * Fall Through To case S_A
					 */
				} else {
					outab(0xA8 + e1.e_addr);
					outrb(&e2, R_PAG0);
					break;
				}

			case S_A:	/* R0,A to R7,A */
				outab(0xF8 + e1.e_addr);
				break;

			default:
				xerr('a', "Invalid Second Argument");
			}
			break;

		case S_DIR:
		case S_EXT:
			if (t2 == S_C) {
				outab(0x92);
				outrb(&e1, R_PAG0);
				break;
			}
			if (is_abs(&e1) && (e1.e_addr == 0xE0)) {
				/*
				 * DIR/EXT == Address Of A
				 * Fall Through To case S_A
				 */
			} else {
				switch (t2) {
				case S_IMMED:	/* dir,#imm */
					outab(0x75);
					outrb(&e1, R_PAG0);
					outrb(&e2, R_NORM);
					break;
	
				case S_DIR:	/* dir,dir */
				case S_EXT:
					outab(0x85);
					outrb(&e2, R_PAG0);
					outrb(&e1, R_PAG0);
					break;

				case S_A:	/* dir,A */
					outab(0xF5);
					outrb(&e1, R_PAG0);
					break;

				case S_AT_R:	/* dir,@R0 dir,@R1 */
					outab(0x86 + e2.e_addr);
					outrb(&e1, R_PAG0);
					break;

				case S_REG:	/* dir,R0 to dir,R7 */
					outab(0x88 + e2.e_addr);
					outrb(&e1, R_PAG0);
					break;

				default:
					xerr('a', "Invalid Second Argument");
				}
				break;
			}

		case S_A:
			switch (t2) {
			case S_IMMED:	/* A,#imm */
				outab(0x74);
				outrb(&e2, R_NORM);
				break;
	
			case S_DIR:	/* A,dir */
			case S_EXT:
				if (is_abs(&e2) && (e2.e_addr == 0xE0)) {
					/*
					 * DIR/EXT == Address Of A
					 * Fall Through To case S_A
					 */
				} else {
					outab(0xE5);
					outrb(&e2, R_PAG0);
					break;
				}

			case S_A:
				xerr('a', "MOV A,A Is Not Allowed");
				break;

			case S_AT_R:	/* A,@R0 A,@R1 */
				outab(0xE6 + e2.e_addr);
				break;

			case S_REG:	/* A,R0 to A,R7 */
				outab(0xE8 + e2.e_addr);
				break;

			case S_AT_DP:	/* A,@DPTR */
				xerr('a', "Should This Be 'MOVX  A,@DPTR' ?");
				break;

			case S_AT_NDP:	/* A,@/DPTR */
				if ((at89lp & EX_DPTR) == 0)
					xerr('o', "Unsupported Instruction");
				xerr('a', "Should This Be 'MOVX  A,@/DPTR' ?");
				break;

			case S_AT_A_DP:	/* A,@A+DPTR */
				xerr('a', "Should This Be 'MOVC  A,@A+DPTR' ?");
				break;

			case S_AT_A_NDP:/* A,@A+/DPTR */
				if ((at89lp & EX_DPTR) == 0)
					xerr('o', "Unsupported Instruction");
				xerr('a', "Should This Be 'MOVC  A,@A+/DPTR' ?");
				break;

			case S_AT_A_PC:	/* A,@A+PC */
				xerr('a', "Should This Be 'MOVC  A,@A+PC' ?");
				break;

			default:
				xerr('a', "Invalid Second Argument");
			}
			break;

		case S_AT_R:
			switch (t2) {
			case S_IMMED:	/* @R0,#imm @R1,#imm */
				outab(0x76 + e1.e_addr);
				outrb(&e2, R_NORM);
				break;

			case S_REG:	/* @R0,Rn  @R1,Rn */ /* A Direct Mode */
				outab(0xA6 + e1.e_addr);
				outab((int) (regbnk + e2.e_addr));
				break;

			case S_DIR:	/* @R0,dir @R1,dir */
			case S_EXT:
				if (is_abs(&e2) && (e2.e_addr == 0xE0)) {
					/*
					 * DIR/EXT == Address Of A
					 * Fall Through To case S_A
					 */
				} else {
					outab(0xA6 + e1.e_addr);
					outrb(&e2, R_PAG0);
					break;
				}

			case S_A:	/* @R0,A @R1,A */
				outab(0xF6 + e1.e_addr);
				break;

			default:
				xerr('a', "Invalid Second Argument");
			}
			break;

		case S_C:	/* C,dir C,extended */
			if ((t2 != S_DIR) && (t2 != S_EXT))
				xerr('a', "Invalid Second Argument");
			outab(0xA2);
			outrb(&e2, R_PAG0);
			break;

		case S_NDPTR:	/* /DPTR,#imm */
			if ((at89lp & EX_DPTR) == 0)
				xerr('o', "Unsupported Instruction");
			outab(0xA5);
		case S_DPTR:	/* DPTR,#imm */
			if (t2 != S_IMMED)
				xerr('a', "An Immediate Second Argument Is Required");
			outab(0x90);
			outrw(&e2, R_NORM);
			break;

		case S_AT_DP:	/* @DPTR,A */
			xerr('a', "Should This Be 'MOVX  @DPTR,A' ?");
			break;

		case S_AT_NDP:	/* @/DPTR,A */
			xerr('a', "Should This Be 'MOVX  @/DPTR,A' ?");
			break;


		default:
			xerr('a', "Invalid Second Argument");
		}
		break;

	case S_BITBR:   /* JB, JBC, JNB bit,rel */
		/* Branch on bit set/clear */
		t1 = addr(&e1);
		if ((t1 != S_DIR) && (t1 != S_EXT))
			xerr('a', "Invalid First Argument");

		comma(1);
		expr(&e2, 0);

		outab(op);
		outrb(&e1, R_PAG0);

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

	case S_BR:  /* JC, JNC, JZ, JNZ */
		/* Relative branch */
		expr(&e1, 0);
		outab(op);

		if (mchpcr(&e1, &v1, 1)) {
			if ((v1 < -128) || (v1 > 127))
				xerr('a', "Short Relative Address Is Out Of Range");
			outab(v1);
		} else {
			outrb(&e1, R_PCR);
		}
		if (e1.e_mode != S_USER)
			rerr();
		break;

	case S_CJNE:
		/* A,#;  A,dir;  A,@R0;  A,@R1;  @R0,#;  @R1,#;  Rn,# */
		t1 = addr(&e1);
		comma(1);
		t2 = addr(&e2);
		comma(1);
		switch (t1) {
		case S_A:
			clrexpr(&e1);
			expr(&e1, 0);
			switch(t2) {
			case S_IMMED:	/* A,#imm */
				outab(op + 4);
				outrb(&e2, R_NORM);
				break;

			case S_REG:	/* A,Rn */ /* A Direct Mode */
				outab(op + 5);
				outab((int) (regbnk + e2.e_addr));
				break;

			case S_DIR:	/* A,dir */
			case S_EXT:
				outab(op + 5);
				outrb(&e2, R_PAG0);
				break;

			case S_A:	/* A,A */
				outab(op + 5);
				outab(0xE0);
				break;

			case S_AT_R:	/* A,@R0 A,@R1 */
				if ((at89lp & EX_CJNE) == 0)
					xerr('o', "Unsupported Instruction");
				outab(0xA5);
				outab(op + 6 + (int) e2.e_addr);
				break;

			default:
				xerr('a', "Invalid Second Argument");
				break;
			}
			break;

		case S_AT_R:	/* @R0,#imm @R1,#imm */
			op = (op + 6 + (int) e1.e_addr);
			clrexpr(&e1);
			expr(&e1, 0);
			outab(op);
			if (t2 != S_IMMED)
				xerr('a', "An Immediate Second Argument Is Required");
			outrb(&e2, R_NORM);
			break;
	
		case S_REG:	/* R0,#imm to R7,#imm */
			op = (op + 8 + (int) e1.e_addr);
			clrexpr(&e1);
			expr(&e1, 0);
			outab(op);
			if (t2 != S_IMMED)
				xerr('a', "An Immediate Second Argument Is Required");
			outrb(&e2, R_NORM);
			break;
	
		default:
			xerr('a', "Invalid First Argument");
			break;
		}

		/* branch destination */
		if (mchpcr(&e1, &v1, 1)) {
			if ((v1 < -128) || (v1 > 127))
				xerr('a', "Short Relative Address Is Out Of Range");
			outab(v1);
		} else {
			outrb(&e1, R_PCR);
		}
		if (e1.e_mode != S_USER)
			rerr();
		break;

	case S_DJNZ:
		/* Dir,dest;  Reg,dest */
		t1 = addr(&e1);
		comma(1);
		expr(&e2, 0);

		switch (t1) {
		case S_A:	/* A */ /* A Direct Mode */
			outab(op + 5);
			outab(0xE0);
			break;

		case S_DIR:	/* dir */
		case S_EXT:
			outab(op + 5);
			outrb(&e1, R_PAG0);
			break;

		case S_REG:	/* R0 to R7 */
			outab(op + 8 + e1.e_addr);
			break;

		default:
			xerr('a', "Invalid First Argument");
		}

		/* branch destination */
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

	case S_JMP:	/* @A+DPTR @A+PC */
		t1 = addr(&e1);
		switch(t1) {
		case S_AT_A_PC:		/* @A+PC */
			if ((at89lp & EX_JMP) == 0)
				xerr('o', "Unsupported Instruction");
			outab(0xA5);
		case S_AT_A_DP:		/* @A+DPTR */
			outab(op);
			break;
		default:
			xerr('a', "Invalid Argument");
			break;
		}
		break;

	case S_MOVC:
		/* A,@A+DPTR  A,@A+/DPTR  A,@A+PC */
		t1 = addr(&e1);
		if (t1 != S_A)
			xerr('a', "First Argument Must Be A");
		comma(1);
		t2 = addr(&e2);
		switch(t2) {
		case S_AT_A_NDP:	/* A,@A+/DPTR */
			if ((at89lp & EX_DPTR) == 0)
				xerr('a', "Unsupported Instruction");
			outab(0xA5);
		case S_AT_A_DP:		/* A,@A+@DPTR */
			outab(0x93);
			break;

		case S_AT_A_PC:		/* A,@A+PC */
			outab(0x83);
			break;

		default:
			xerr('a', "Invalid Second Argument");
			break;
		}
		break;

	case S_MOVX:
		/* A,@DPTR  A,@/DPTR  A,@R0  A,@R1  @DPTR,A  @/DPTR,A   @R0,A  @R1,A */
		t1 = addr(&e1);
		comma(1);
		t2 = addr(&e2);

		switch (t1) {
		case S_A:
			switch (t2) {
			case S_AT_NDP:	/* A,@/DPTR */
				if ((at89lp & EX_DPTR) == 0)
					xerr('o', "Unsupported Instruction");
				outab(0xA5);
			case S_AT_DP:	/* A,@DPTR */
				outab(0xE0);
				break;

			case S_AT_R:	/* A,@R0 A,@R1 */
				outab(0xE2 + e2.e_addr);
				break;

			default:
				xerr('a', "Invalid Second Argument");
			}
			break;

		case S_AT_NDP:	/* @/DPTR */
			if ((at89lp & EX_DPTR) == 0)
				xerr('a', "Unsupported Instruction");
			outab(0xA5);
		case S_AT_DP:	/* @DPTR,A */
			outab(0xF0);
			if (t2 != S_A)
				xerr('a', "Second Argument Must Be A");
			break;

		case S_AT_R:
			outab(0xF2 + e1.e_addr);
			if (t2 != S_A)
				xerr('a', "Second Argument Must Be A");
			break;

		default:
			xerr('a', "Invalid First Argument");
		}
		break;

	/* MUL/DIV AB */
	case S_MLDV:  
		t1 = addr(&e1);
		if (t1 != S_AB)
			xerr('a', "Required Argument is AB");
		outab(op);
		break;

	/* CLR or CPL:  A, C, M or bit */
	case S_ACBIT:
		t1 = addr(&e1);
		switch (t1) {
		case S_A:	/* A */
			if (op == 0xB2)
				outab(0xF4);
			else
				outab(0xE4);
			break;

		case S_C:	/* C */
			outab(op+1);
			break;

		case S_DIR:	/* dir */
		case S_EXT:
			outab(op);
			outrb(&e1, R_PAG0);
			break;

		case S_M:	/* M */
			if (op != 0xC2)
				xerr('a', "Invalid Argument For CPL");
			if ((at89lp & EX_DPTR) == 0)
				xerr('o', "Unsupported Instruction");
			outab(0xA5);
			outab(0xE4);
			break;

		default:
			xerr('a', "Invalid Argument");
			break;
		}
		break;

	/* SETB C or bit */
	case S_SETB:
		t1 = addr(&e1);
		switch (t1) {
		case S_C:	/* C */
			outab(op+1);
			break;

		case S_DIR:	/* dir */
		case S_EXT:
			outab(op);
			outrb(&e1, R_PAG0);
			break;

		default:
			xerr('a', "Invalid Argument");
		}
		break;

	/* direct */
	case S_DIRECT: 
		t1 = addr(&e1);
		switch(t1) {
		case S_A:	/* A */ /* A Direct Mode */
			outab(op);
			outab(0xE0);
			break;

		case S_REG:	/* Rn */ /* A Direct Mode */
			outab(op);
			outab((int) (regbnk + e1.e_addr));
			break;

		case S_DIR:
		case S_EXT:
			outab(op);
			outrb(&e1, R_PAG0);
			break;

		default:
			xerr('a', "Invalid Argument");
			break;
		}
		break;

	/* XCHD A,@Rn */
	case S_XCHD:
		t1 = addr(&e1);
		if (t1 != S_A)
			xerr('a', "First Argument Must Be A");
		comma(1);
		t2 = addr(&e2);
		switch (t2) {
		case S_AT_R:
			outab(op + e2.e_addr);
			break;

		default:
			xerr('a', "Invalid Second Argument");
		}
		break;

	default:
		opcycles = OPCY_ERR;
		xerr('o', "Internal Opcode Error.");
		break;
	}
	if (opcycles == OPCY_NONE) {
		opcycles = at89pg0[cb[0] & 0xFF];
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
 * Machine specific initialization
 */
void
minit(void)
{
	/*
	 * Byte Order
	 */
	hilo = 1;
	/*
	 * Reset MCU Type
	 */
	at89lp = 0;
	/*
	 * Register Bank
	 */
	regbnk = 0;
}
