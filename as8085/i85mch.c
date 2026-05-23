/* i85mch.c */

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
#include "i8085.h"

char	*cpu	= "Intel 8085";
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
 * 8080 Cycle Count
 *
 *	opcycles = i80pg1[opcode]
 */

static char  i80pg1[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   4,10, 7, 5, 5, 5, 7, 4,UN,10, 7, 5, 5, 5, 7, 4,
/*10*/  UN,10, 7, 5, 5, 5, 7, 4,UN,10, 7, 5, 5, 5, 7, 4,
/*20*/  UN,10,16, 5, 5, 5, 7, 4,UN,10,16, 5, 5, 5, 7, 4,
/*30*/  UN,10,13, 5,10,10,10, 4,UN,10,13, 5, 5, 5, 7, 4,
/*40*/   5, 5, 5, 5, 5, 5, 7, 5, 5, 5, 5, 5, 5, 5, 7, 5,
/*50*/   5, 5, 5, 5, 5, 5, 7, 5, 5, 5, 5, 5, 5, 5, 7, 5,
/*60*/   5, 5, 5, 5, 5, 5, 7, 5, 5, 5, 5, 5, 5, 5, 7, 5,
/*70*/   7, 7, 7, 7, 7, 7, 7, 7, 5, 5, 5, 5, 5, 5, 7, 5,
/*80*/   4, 4, 4, 4, 4, 4, 7, 4, 4, 4, 4, 4, 4, 4, 7, 4,
/*90*/   4, 4, 4, 4, 4, 4, 7, 4, 4, 4, 4, 4, 4, 4, 7, 4,
/*A0*/   4, 4, 4, 4, 4, 4, 7, 4, 4, 4, 4, 4, 4, 4, 7, 4,
/*B0*/   4, 4, 4, 4, 4, 4, 7, 4, 4, 4, 4, 4, 4, 4, 7, 4,
/*C0*/   5,10,10,10,11,11, 7,11, 5,10,10,UN,11,17, 7,11,
/*D0*/   5,10,10,10,11,11, 7,11, 5,UN,10,10,11,UN, 7,11,
/*E0*/   5,10,10,18,11,11, 7,11, 5, 5,10, 4,11,UN, 7,11,
/*F0*/   5,10,10, 4,11,11, 7,11, 5, 5,10, 4,11,UN, 7,11
};

/*
 * 8085 Cycle Count
 *
 *	opcycles = i85pg1[opcode]
 */
static char i85pg1[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   4,10, 7, 6, 4, 4, 7, 4,UN,10, 7, 6, 4, 4, 7, 4,
/*10*/  UN,10, 7, 6, 4, 4, 7, 4,UN,10, 7, 6, 4, 4, 7, 4,
/*20*/   4,10,16, 6, 4, 4, 7, 4,UN,10,16, 6, 4, 4, 7, 4,
/*30*/   4,10,13, 6,10,10,10, 4,UN,10,13, 6, 4, 4, 7, 4,
/*40*/   4, 4, 4, 4, 4, 4, 4, 7, 4, 4, 4, 4, 4, 4, 7, 4,
/*50*/   4, 4, 4, 4, 4, 4, 4, 7, 4, 4, 4, 4, 4, 4, 7, 4,
/*60*/   4, 4, 4, 4, 4, 4, 4, 7, 4, 4, 4, 4, 4, 4, 7, 4,
/*70*/   7, 7, 7, 7, 7, 7, 4, 7, 4, 4, 4, 4, 4, 4, 7, 4,
/*80*/   4, 4, 4, 4, 4, 4, 7, 4, 4, 4, 4, 4, 4, 4, 7, 4,
/*90*/   4, 4, 4, 4, 4, 4, 7, 4, 4, 4, 4, 4, 4, 4, 7, 4,
/*A0*/   4, 4, 4, 4, 4, 4, 7, 4, 4, 4, 4, 4, 4, 4, 7, 4,
/*B0*/   4, 4, 4, 4, 4, 4, 7, 4, 4, 4, 4, 4, 4, 4, 7, 4,
/*C0*/  12,10,10,10,18,12, 7,12,12,10,10,UN,18,18, 7,12,
/*D0*/  12,10,10,10,18,12, 7,12,12,UN,10,10,18,UN, 7,12,
/*E0*/  12,10,10,16,18,12, 7,12,12, 6,10, 4,18,UN, 7,12,
/*F0*/  12,10,10, 4,18,12, 7,12,12, 6,10, 4,18,UN, 7,12
};

/*
 * 8085x Cycle Count
 *
 *	opcycles = x85pg1[opcode]
 */
static char x85pg1[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   4,10, 7, 6, 4, 4, 7, 4,10,10, 7, 6, 4, 4, 7, 4,
/*10*/   7,10, 7, 6, 4, 4, 7, 4,10,10, 7, 6, 4, 4, 7, 4,
/*20*/   4,10,16, 6, 4, 4, 7, 4,10,10,16, 6, 4, 4, 7, 4,
/*30*/   4,10,13, 6,10,10,10, 4,10,10,13, 6, 4, 4, 7, 4,
/*40*/   4, 4, 4, 4, 4, 4, 4, 7, 4, 4, 4, 4, 4, 4, 7, 4,
/*50*/   4, 4, 4, 4, 4, 4, 4, 7, 4, 4, 4, 4, 4, 4, 7, 4,
/*60*/   4, 4, 4, 4, 4, 4, 4, 7, 4, 4, 4, 4, 4, 4, 7, 4,
/*70*/   7, 7, 7, 7, 7, 7, 4, 7, 4, 4, 4, 4, 4, 4, 7, 4,
/*80*/   4, 4, 4, 4, 4, 4, 7, 4, 4, 4, 4, 4, 4, 4, 7, 4,
/*90*/   4, 4, 4, 4, 4, 4, 7, 4, 4, 4, 4, 4, 4, 4, 7, 4,
/*A0*/   4, 4, 4, 4, 4, 4, 7, 4, 4, 4, 4, 4, 4, 4, 7, 4,
/*B0*/   4, 4, 4, 4, 4, 4, 7, 4, 4, 4, 4, 4, 4, 4, 7, 4,
/*C0*/  12,10,10,10,18,12, 7,12,12,10,10,12,18,18, 7,12,
/*D0*/  12,10,10,10,18,12, 7,12,12,10,10,10,18,10, 7,12,
/*E0*/  12,10,10,16,18,12, 7,12,12, 6,10, 4,18,10, 7,12,
/*F0*/  12,10,10, 4,18,12, 7,12,12, 6,10, 4,18,10, 7,12
};

/*
 * Process machine ops.
 */
void
machine(struct mne *mp)
{
	unsigned op, rd, rs;
	struct expr e;

	/*
	 * Using Internal Format
	 * For Cycle Counting
	 */
	opcycles = OPCY_NONE;

	clrexpr(&e);
	op = (int) mp->m_valu;

	switch (mp->m_type) {
	case S_CPU:
		opcycles = OPCY_CPU;
		mchtyp = op;
		sym[2].s_addr = op;
		lmode = SLIST;
		break;

	case S_INH:
		outab(op);
		break;

	case S_RST:
		rd = (int) absexpr();
		if (rd > 7)
			xerr('a', "Valid values are 0 -> 7.");
		out3(op, rd);
		break;

	case S_ADI:
		expr(&e, 0);
		outab(op);
		outrb(&e, 0);
		break;

	case S_ADD:
		rd = reg();
		if (rd > A)
			xerr('a', "SP and PSW are invalid.");
		outab(op | rd);
		break;

	case S_JMP:
		expr(&e, 0);
		outab(op);
		outrw(&e, 0);
		break;

	case S_INR:
		rd = reg();
		if (rd > A)
			xerr('a', "SP and PSW are invalid.");
		out3(op, rd);
		break;

	case S_LXI:
		rd = reg();
		comma(1);
		expr(&e, 0);
		out3(op, regpair(rd, SP));
		outrw(&e, 0);
		break;

	case S_LDAX:
		rd = reg();
		if (rd!=B && rd!=D)
			xerr('a', "Only B or D are valid.");
		out3(op, rd);
		break;

	case S_INX:
		rd = reg();
		out3(op, regpair(rd, SP));
		break;

	case S_PUSH:
		rd = reg();
		out3(op, regpair(rd, PSW));
		break;

	case S_MOV:
		rd = reg();
		comma(1);
		rs = reg();
		if (rs>A || rd>A)
			xerr('a', "SP and PSW are invalid.");
		outab(op | rs | (rd<<3));
		break;

	case S_MVI:
		rd = reg();
		comma(1);
		expr(&e, 0);
		if (rd > A)
			xerr('a', "SP and PSW are invalid.");
		out3(op, rd);
		outrb(&e, 0);
		break;

	default:
		opcycles = OPCY_ERR;
		xerr('o', "Internal Opcode Error.");
		break;
	}

	if ((mchtyp == X_8080) && (mp->m_type != S_CPU)) {
		if ((i80pg1[cb[0] & 0xFF]) == UN)
			xerr('o', "Not an 8080 instruction.");
	}

	if ((mchtyp == X_8085) && (mp->m_type != S_CPU)) {
		if ((i85pg1[cb[0] & 0xFF]) == UN)
			xerr('o', "Not a standard 8085 instruction.");
	}

	if (opcycles == OPCY_NONE) {
		switch(mchtyp) {
		default:
		case X_8080:
			opcycles = i80pg1[cb[0] & 0xFF];
			break;

		case X_8085:
			opcycles = i85pg1[cb[0] & 0xFF];
			break;

		case X_8085X:
			opcycles = x85pg1[cb[0] & 0xFF];
			break;
		}
	}
 	/*
	 * Translate To External Format
	 */
	if (opcycles == OPCY_NONE) { opcycles  =  CYCL_NONE; } else
	if (opcycles  & OPCY_NONE) { opcycles |= (CYCL_NONE | 0x3F00); }
}

/*
 * Output a | (b<<3);
 */
void
out3(int a, int b)
{
	outab(a | (b<<3));
}

/*
 * Make sure that `r' is usable as a
 * register pair specifier. The extra
 * register (code 3) is `s'.
 */
int
regpair(int r, int s)
{
	if (r < M) {
		if (r&01)
			xerr('a', "Not part of a register pair.");
	} else
	if (r == s) {
		r = 6;
	} else {
		xerr('a', "Not a register pair.");
	}
	return (r);
}

/*
 * Read a register name.
 */
int
reg()
{
	struct mne *mp;
	char id[NCPS];

	getid(id, -1);
	if ((mp = mlookup(id))==NULL || mp->m_type!=S_REG) {
		xerr('a', "Not a register.");
		return (0);
	}
	return ((int) mp->m_valu);
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
	hilo = 0;

	/*
	 * Default Machine Type
	 */
	mchtyp = X_8085;
	sym[2].s_addr = X_8085;
}
