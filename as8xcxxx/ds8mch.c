/* ds8mch.c */

/*
 *  Copyright (C) 1998-2023  Alan R. Baldwin
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
 *   This Assember Ported by
 *	jhartman at compuserve dot com
 *	noice at noicedebugger dot com
 *
 *   Modified from i51pst.c
 *	Bill McKinnon
 *	w_mckinnon at conknet dot com
 *
 */

#include "asxxxx.h"
#include "ds8.h"

char	*cpu	= "Dallas Semiconductor [User Defined]";
char	*dsft	= "asm";

static int amode;
static char buff[80];
static int ds8_bytes;
static int mchtyp;

/*
 * Opcode Cycle Definitions
 */
#define	OPCY_SDP	((char) (0xFF))
#define	OPCY_ERR	((char) (0xFE))

#define	OPCY_NONE	((char) (0x80))
#define	OPCY_MASK	((char) (0x7F))

#define	OPCY_CPU	((char) (0xFD))
#define	OPCY_AMODE	((char) (0xFC))
#define	OPCY_BITS	((char) (0xFB))


#define	UN	((char) (OPCY_NONE | 0x00))

/*
 * ds8xcxxx Cycle Count
 *
 *	opcycles = ds8pg1[opcode]
 */
static char ds8pg1[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   4,12,16, 4, 4, 8, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
/*10*/  12,12,16, 4, 4, 8, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
/*20*/  12,12,16, 4, 8, 8, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
/*30*/  12,12,16, 4, 8, 8, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
/*40*/  12,12, 8,12, 8, 8, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
/*50*/  12,12, 8,12, 8, 8, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
/*60*/  12,12, 8,12, 8, 8, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
/*70*/  12,12, 8,12, 8,12, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8,
/*80*/  12,12, 8,12,20,12, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8,
/*90*/  12,12, 8,12, 8, 8, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
/*A0*/   8,12, 8,12,20,UN, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8,
/*B0*/   8,12, 8, 4,16,16,16,16,16,16,16,16,16,16,16,16,
/*C0*/   8,12, 8, 4, 4, 8, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
/*D0*/   8,12, 8, 4, 4,16, 4, 4,12,12,12,12,12,12,12,12,
/*E0*/   8,12, 8, 8, 4, 8, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
/*F0*/   8,12, 8, 8, 4, 8, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4
};

/*
 * Process machine ops.
 */
VOID
machine(mp)
struct mne *mp;
{
	char *p, *str;
	char pid[NINPUT], id[NINPUT];
	int c, d, t, t1, v1;
	a_uint op;
	struct sym *sp;
	struct expr e, e1;

	/*
	 * Using Internal Format
	 * For Cycle Counting
	 */
	opcycles = OPCY_NONE;

	clrexpr(&e);
	clrexpr(&e1);

	op = mp->m_valu;
	switch (mp->m_type) {

	case S_CPU:
		opcycles = OPCY_CPU;
		lmode = SLIST;
		switch(op) {
		default: op = DS8XCXXX;
		case DS8XCXXX: v1 = 2; str = "DS8XCXXX"; sym[2].s_addr = X_DS8XCXXX; break;
		case DS80C310: v1 = 2; str = "DS80C310"; sym[2].s_addr = X_DS80C310; break;
		case DS80C320: v1 = 2; str = "DS80C320"; sym[2].s_addr = X_DS80C320; break;
		case DS80C323: v1 = 2; str = "DS80C323"; sym[2].s_addr = X_DS80C323; break;
		case DS80C390: v1 = 3; str = "DS80C390"; sym[2].s_addr = X_DS80C390; break;
		case DS83C520: v1 = 2; str = "DS83C520"; sym[2].s_addr = X_DS83C520; break;
		case DS83C530: v1 = 2; str = "DS83C530"; sym[2].s_addr = X_DS83C530; break;
		case DS83C550: v1 = 2; str = "DS83C550"; sym[2].s_addr = X_DS83C550; break;
		case DS87C520: v1 = 2; str = "DS87C520"; sym[2].s_addr = X_DS87C520; break;
		case DS87C530: v1 = 2; str = "DS87C530"; sym[2].s_addr = X_DS87C530; break;
		case DS87C550: v1 = 2; str = "DS87C550"; sym[2].s_addr = X_DS87C550; break;
		case DS______: v1 = 2; str = "DS______"; sym[2].s_addr = X_DS______;
			if (more()) {
				str = p = pid;
				d = getnb();
				while ((c = get()) != d) {
					if (c == '\0') {
						xerr('q', "Unquoted argument.");
					}
					if (p < &pid[sizeof(pid)-3]) {
						*p++ = c;
					} else {
						break;
					}
				}
				*p = 0;
			}
			break;
		}
		if (op != 0) {
			ds8_bytes = v1;
			exprmasks(v1);
		}
		mchtyp = (int) op;

		/* GCC 10.2.0 error [-Wformat-overflow=] ? */
		/* sprintf(id, "__%s", str); */
		  memcpy(id, "__", 2);
		  memcpy(&id[2], str, strlen(str)+1);
		sp = lookup(id);
		if (sp->s_type != S_NEW && (sp->s_flag & S_ASG) == 0) {
			err('m');
		}
		sp->s_type = S_USER;
		sp->s_addr = 1;
		sp->s_flag |= S_ASG;

		/* GCC 10.2.0 error [-Wformat-overflow=] ? */
		/* sprintf(buff, "%s %s", DS_CPU, str); */
		  t = strlen(DS_CPU);
		  memcpy(buff, DS_CPU, t);
		  memcpy(&buff[t], " ", 1);
		  t1 = strlen(str);
		  memcpy(&buff[t+1], str, t1+1);
		cpu = buff;

		sp = lookup("__SFR_BITS");
		if (sp->s_type != S_NEW && (sp->s_flag & S_ASG) == 0) {
			err('m');
		}
		sp->s_type = S_USER;
		sp->s_flag |= S_ASG;

		if (more()) {
			expr(&e, 0);
			abscheck(&e);
			sp->s_addr = e.e_addr;
		} else {
			sp->s_addr = 1;
		}
		break;

	case S_AMODE:
		opcycles = OPCY_AMODE;
		if ((mchtyp != 0) && (mchtyp != DS80C390)) {
			xerr('o', "Not a DS80C390 instruction.");
			break;
		} else
		if ((mchtyp == 0) && ((a_bytes < 2) || (a_bytes > 3))) {
			xerr('o', "Not a 16 or 24 Bit machine.");
			break;
		}
		expr(&e, 0);
		abscheck(&e);
		amode = (int) e.e_addr;
		if ((amode < 0) || (amode > 2)) {
			amode = 0;
			xerr('o', "Valid values are 0 -> 2.");
		}
		if ((c = getnb()) == ',') {
			expr(&e1, 0);
			abscheck(&e1);
			if (e1.e_addr != 0) {
/* mov	ta,#0aah */		outab(0x075);	outab(0x0C7);	outab(0x0AA);
/* mov	ta,#055h */		outab(0x075);	outab(0x0C7);	outab(0x055);
/* mov	acon,#amode */		outab(0x075);	outab(0x09D);	outab(amode);
			} else {
				lmode = SLIST;
			}
		} else {
			unget(c);
			lmode = SLIST;
		}
		break;

	case S_BITS:
		if (ds8_bytes == 0) {
			ds8_bytes = (int) op;
			exprmasks(ds8_bytes);
		} else
		if (ds8_bytes != (int) op) {
			err('m');
		}
		opcycles = OPCY_BITS;
		lmode = SLIST;
		break;

	case S_INH:
		outab(op);
		break;

	case S_JMP11:
		expr(&e, 0);
		if (amode == 2) {
			outr3bm(&e, R_PAGX3 | R_J19, op << 16);
		} else {
			outrwm(&e, R_PAGX2 | R_J11, op << 8);
		}
		break;

	case S_JMP16:
		expr(&e, 0);
		outab(op);
		if (amode == 2) {
			outr3b(&e, R_NORM);
		} else {
			outrw(&e, R_NORM);
		}
		break;

	case S_ACC:
		t = addr(&e);
		if (t != S_A)
			xerr('a', "Argument must A.");
		outab(op);
		break;

	case S_TYP1:
		/* A, direct, @R0, @R1, R0 to R7.  "INC" also allows DPTR */
		t = addr(&e);
		
		switch (t) {
		case S_A:
			outab(op + 4);
			break;

		case S_DIR:
		case S_EXT:
			/* Direct is also legal */
			outab(op + 5);
			outrb(&e, R_PAG0);
			break;

		case S_AT_R:
			outab(op + 6 + e.e_addr);
			break;

		case S_REG:
			outab(op + 8 + e.e_addr);
			break;

		case S_DPTR:
			if (op != 0)
				/* only INC (op=0) has DPTR mode */
				xerr('a', "DPTR allowed only in INC instruction.");
			else
				outab( 0xA3);
			break;

		default:
			xerr('a', "Invalid Addressing Mode.");
		}
		break;

	case S_TYP2:
		/* A,#imm; A,direct; A,@R0; A,@R1; A,R0 to A,R7 */
		t = addr(&e);
		if (t != S_A)
			xerr('a', "First argument must be A.");
		comma(1);
		t1 = addr(&e1);
		
		switch (t1) {
		case S_IMMED:
			outab(op + 4);
			outrb(&e1, R_NORM);
			break;

		case S_DIR:
		case S_EXT:
			outab(op + 5);
			outrb(&e1, R_PAG0);
			break;

		case S_AT_R:
			outab(op + 6 + e1.e_addr);
			break;

		case S_REG:
			outab(op + 8 + (e1.e_addr));
			break;

		default:
			xerr('a', "Invalid Addressing Mode.");
		}
		break;

	case S_TYP3:
		/* dir,A; dir,#imm; 
		 * A,#imm; A,direct; A,@R0; A,@R1; A,R0 to A,R7 
		 * C,direct;  C,/direct
		 */
		t = addr(&e);
		comma(1);
		t1 = addr(&e1);

		switch (t) {
		case S_DIR:
		case S_EXT:
			switch (t1) {
			case S_A:
				outab(op + 2);
				outrb(&e, R_PAG0);
				break;
			
			case S_IMMED:
				outab(op + 3);
				outrb(&e, R_PAG0);
				outrb(&e1, R_NORM);
				break;

			default:
				xerr('a', "Invalid Addressing Mode.");
			}
			break;

		case S_A:
			switch (t1) {
			case S_IMMED:
				outab(op + 4);
				outrb(&e1, R_NORM);
				break;
	
			case S_DIR:
			case S_EXT:
				outab(op + 5);
				outrb(&e1, R_PAG0);
				break;

			case S_AT_R:
				outab(op + 6 + e1.e_addr);
				break;

			case S_REG:
				outab(op + 8 + e1.e_addr);
				break;

			default:
				xerr('a', "Invalid Addressing Mode.");
			}
			break;

		case S_C:
			/* XRL has no boolean version.  Trap it */
			if (op == 0x60)
				xerr('a', "XRL does not support boolean.");

			switch (t1) {
			case S_DIR:
			case S_EXT:
				outab(op + 0x32);
				outrb(&e1, R_PAG0);
				break;
			
			case S_NOT_BIT:
				outab(op + 0x60);
				outrb(&e1, R_PAG0);
				break;
			
			default:
				xerr('a', "Invalid Addressing Mode.");
			}
			break;

		default:
			xerr('a', "Invalid Addressing Mode.");
		}
		break;

	case S_TYP4:
		/* A,direct; A,@R0; A,@R1; A,R0 to A,R7 */
		t = addr(&e);
		if (t != S_A)
			xerr('a', "First argument must be A.");
		comma(1);
		t1 = addr(&e1);

		switch (t1) {
		case S_DIR:
		case S_EXT:
			outab(op + 5);
			outrb(&e1, R_PAG0);
			break;

		case S_AT_R:
			outab(op + 6 + e1.e_addr);
			break;

		case S_REG:
			outab(op + 8 + e1.e_addr);
			break;

		default:
			xerr('a', "Invalid Addressing Mode.");
		}
		break;

	/* MOV instruction, all modes */
	case S_MOV:
		t = addr(&e);
		comma(1);
		t1 = addr(&e1);

		switch (t) {
		case S_A:
			switch (t1) {
			case S_IMMED:
				outab(0x74);
				outrb(&e1, R_NORM);
				break;
	
			case S_DIR:
			case S_EXT:
				outab(0xE5);
				outrb(&e1, R_PAG0);
				break;

			case S_AT_R:
				outab(0xE6 + e1.e_addr);
				break;

			case S_REG:
				outab(0xE8 + e1.e_addr);
				break;

			default:
				xerr('a', "Invalid Addressing Mode.");
			}
			break;

		case S_REG:
			switch (t1) {
			case S_A:
				outab(0xF8 + e.e_addr);
				break;

			case S_IMMED:
				outab(0x78 + e.e_addr);
				outrb(&e1, R_NORM);
				break;
	
			case S_DIR:
			case S_EXT:
				outab(0xA8 + e.e_addr);
				outrb(&e1, R_PAG0);
				break;

			default:
				xerr('a', "Invalid Addressing Mode.");
			}
			break;

		case S_DIR:
		case S_EXT:
			switch (t1) {
			case S_A:
				outab(0xF5);
				outrb(&e, R_PAG0);
				break;

			case S_IMMED:
				outab(0x75);
				outrb(&e, R_PAG0);
				outrb(&e1, R_NORM);
				break;
	
			case S_DIR:
			case S_EXT:
				outab(0x85);
				outrb(&e1, R_PAG0);
				outrb(&e, R_PAG0);
				break;

			case S_AT_R:
				outab(0x86 + e1.e_addr);
				outrb(&e, R_PAG0);
				break;

			case S_REG:
				outab(0x88 + e1.e_addr);
				outrb(&e, R_PAG0);
				break;

			case S_C:
				outab(0x92);
				outrb(&e, R_PAG0);
				break;

			default:
				xerr('a', "Invalid Addressing Mode.");
			}
			break;

		case S_AT_R:
			switch (t1) {
			case S_IMMED:
				outab(0x76 + e.e_addr);
				outrb(&e1, R_NORM);
				break;
	
			case S_DIR:
			case S_EXT:
				outab(0xA6 + e.e_addr);
				outrb(&e1, R_PAG0);
				break;

			case S_A:
				outab(0xF6 + e.e_addr);
				break;

			default:
				xerr('a', "Invalid Addressing Mode.");
			}
			break;

		case S_C:
			if ((t1 != S_DIR) && (t1 != S_EXT))
				xerr('a', "Second argument must be an address.");
			outab(0xA2);
			outrb(&e1, R_PAG0);
			break;

		case S_DPTR:
			if (t1 != S_IMMED)
				xerr('a', "#__ is required second argument.");
			outab(0x90);
			if (amode == 2)
				outr3b(&e1, R_NORM);
			else
				outrw(&e1, R_NORM);
			break;

		default:
			xerr('a', "Invalid Addressing Mode.");
		}
		break;

	case S_BITBR:
		/* Branch on bit set/clear */
		t = addr(&e);
		if ((t != S_DIR) && (t != S_EXT))
			xerr('a', "Argument must be an address.");
		outab(op);
		outrb(&e, R_PAG0);

		comma(1);
		expr(&e1, 0);
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

	case S_BR:
		/* Relative branch */
		outab(op);
		expr(&e1, 0);
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

	case S_CJNE:
		/* A,#;  A,dir;  @R0,#;  @R1,#;  Rn,# */
		t = addr(&e);
		comma(1);
		t1 = addr(&e1);
		switch (t) {
		case S_A:
			if (t1 == S_IMMED) {
				outab(op + 4);
				outrb(&e1, R_NORM);
			}
			else if ((t1 == S_DIR) || (t1 == S_EXT)) {
				outab(op + 5);
				outrb(&e1, R_PAG0);
			}
			else
				xerr('a', "Invalid Addressing Mode.");
			break;

		case S_AT_R:
			outab(op + 6 + e.e_addr);
			if (t1 != S_IMMED)
				xerr('a', "#__ is required second argument.");
			outrb(&e1, R_NORM);
			break;
	
		case S_REG:
			outab(op + 8 + e.e_addr);
			if (t1 != S_IMMED)
				xerr('a', "#__ is required second argument.");
			outrb(&e1, R_NORM);
			break;
	
		default:
			xerr('a', "Invalid Addressing Mode.");
		}

		/* branch destination */
		comma(1);
		expr(&e1, 0);
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

	case S_DJNZ:
		/* Dir,dest;  Reg,dest */
		t = addr(&e);
		switch (t) {

		case S_DIR:
		case S_EXT:
			outab(op + 5);
			outrb(&e, R_PAG0);
			break;
	
		case S_REG:
			outab(op + 8 + e.e_addr);
			break;

		default:
			xerr('a', "Invalid Addressing Mode.");
		}

		/* branch destination */
		comma(1);
		expr(&e1, 0);
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

	case S_JMP: 
		/* @A+DPTR */
		t = addr(&e);
		if (t != S_AT_ADP)
			xerr('a', "JMP @A+DPTR is the only allowed mode.");
		outab(op);
		break;

	case S_MOVC:
		/* A,@A+DPTR  A,@A+PC */
		t = addr(&e);
		if (t != S_A)
			xerr('a', "First argument must be A.");
		comma(1);
		t1 = addr(&e1);
		if (t1 == S_AT_ADP)
			outab(0x93);
		else if (t1 == S_AT_APC)
			outab(0x83);
		else
			xerr('a', "MOVC A,@A+DPTR; A,@A+PC are the allowed modes.");
		break;

	case S_MOVX:
		/* A,@DPTR  A,@R0  A,@R1  @DPTR,A  @R0,A  @R1,A */
		t = addr(&e);
		comma(1);
		t1 = addr(&e1);

		switch (t) {
		case S_A:
			switch (t1) {
			case S_AT_DP:
				outab(0xE0);
				break;

			case S_AT_R:
				outab(0xE2 + e1.e_addr);
				break;

			default:
				xerr('a', "Second argument must be @DPTR or @Rn.");
			}
			break;

		case S_AT_DP:
			if (t1 == S_A) {
				outab(0xF0);
			} else {
				xerr('a', "Second argument must A.");
			}
			break;

		case S_AT_R:
			if (t1 == S_A) {
				outab(0xF2 + e.e_addr);
			} else {
				xerr('a', "Second argument must A.");
			}
			break;

		default:
			xerr('a', "Invalid Addressing Mode.");
		}
		break;

	/* MUL/DIV A,B */
	case S_AB:  
		t = addr(&e);
		if (t != S_RAB)
			xerr('a', "A,B is the only valid argument.");
		outab(op);
		break;

	/* CLR or CPL:  A, C, or bit */
	case S_ACBIT:
		t = addr(&e);
		switch (t) {
		case S_A:
			if (op == 0xB2)
				outab(0xF4);
			else
				outab(0xE4);
			break;

		case S_C:
			outab(op+1);
			break;

		case S_DIR:
		case S_EXT:
			outab(op);
			outrb(&e, R_PAG0);
			break;

		default:
			xerr('a', "Invalid Addressing Mode.");
		}
		break;

	/* SETB C or bit */
	case S_SETB:
		t = addr(&e);
		switch (t) {
		case S_C:
			outab(op+1);
			break;

		case S_DIR:
		case S_EXT:
			outab(op);
			outrb(&e, R_PAG0);
			break;

		default:
			xerr('a', "Invalid Addressing Mode.");
		}
		break;

	/* direct */
	case S_DIRECT: 
		t = addr(&e);
		if ((t != S_DIR) && (t != S_EXT)) {
			xerr('a', "Argument must be an address.");
			break;
		}
		outab(op);
		outrb(&e, R_PAG0);
		break;

	/* XCHD A,@Rn */
	case S_XCHD:
		t = addr(&e);
		if (t != S_A)
			xerr('a', "First argument must A.");
		comma(1);
		t1 = addr(&e1);
		switch (t1) {
		case S_AT_R:
			outab(op + e1.e_addr);
			break;

		default:
			xerr('a', "Invalid Addressing Mode.");
		}
		break;

	default:
		opcycles = OPCY_ERR;
		xerr('o', "Internal Opcode Error.");
		break;
	}
	if (opcycles == OPCY_NONE) {
		opcycles = ds8pg1[cb[0] & 0xFF];
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
 * Machine specific initialization
 */

VOID
minit()
{
	/*
	 * Byte Order
	 */
	hilo = 1;

	amode = 0;
	if (pass == 0) {
		ds8_bytes = 0;
		mchtyp = X_DS8XCXXX;
		sym[2].s_addr = X_DS8XCXXX;
	}
}

