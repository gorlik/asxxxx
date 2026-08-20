/* ms40mch.c */

/*
 *  Copyright (C) 2026  Alan R. Baldwin
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
#include "ms40.h"

char	*cpu	= "OKI OLMS-40 SERIES";
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
 * MSM5840 Cycle Count
 *
 *	opcycles = pg5840[op]
 */
static char pg5840[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*10*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*20*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*30*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*40*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,UN,
/*50*/   1,UN, 1, 1, 1, 1, 1, 1, 1, 2, 1,UN, 1, 1, 1,UN,
/*60*/   1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1,UN, 1, 1, 1,
/*70*/  17, 2, 1, 1, 1, 1, 1,UN,UN,UN, 1, 1, 1, 1, 1, 1,
/*80*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*90*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*A0*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*B0*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*C0*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*D0*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*E0*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*F0*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
};

/*
 * MSM5842 Cycle Count
 *
 *	opcycles = pg5842[op]
 */
static char pg5842[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*10*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*20*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*30*/   2, 2, 2, 2,UN,UN,UN,UN, 2, 2, 2, 2,UN,UN,UN,UN,
/*40*/   1, 1, 1, 1,UN,UN,UN, 1,UN,UN,UN,UN, 1,UN, 1,UN,
/*50*/   1,UN,UN,UN, 1, 1, 1, 1, 1, 2, 1,UN, 1, 1, 1,UN,
/*60*/   1, 1,UN,UN,UN,UN,UN,UN, 1,UN,UN,UN,UN,UN,UN,UN,
/*70*/  UN, 2, 1, 1, 1,UN, 1,UN,UN,UN, 1, 1, 1,UN,UN,UN,
/*80*/   1,UN,UN,UN, 1,UN,UN,UN, 1,UN,UN,UN,UN,UN,UN,UN,
/*90*/   1,UN,UN,UN, 1,UN,UN,UN, 1,UN,UN,UN,UN,UN,UN,UN,
/*A0*/   1, 1, 1, 1, 1, 1, 1, 1,UN,UN,UN,UN, 1,UN, 1,UN,
/*B0*/  UN,UN,UN,UN,UN,UN,UN,UN, 1, 1, 1, 1, 1, 1, 1, 1,
/*C0*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*D0*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*E0*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*F0*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
};

/*
 * MSM58421 And MSM58422 Cycle Count
 *
 *	opcycles = pg5842x[op]
 */
static char pg5842x[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*10*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*20*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*30*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*40*/   1, 1, 1, 1,UN,UN,UN, 1,UN,UN,UN,UN, 1,UN, 1,UN,
/*50*/   1,UN,UN,UN, 1, 1, 1, 1, 1, 2, 1,UN, 1, 1, 1,UN,
/*60*/   1, 1, 1, 1, 1, 1, 1, 1, 1,UN,UN,UN,UN,UN,UN,UN,
/*70*/  UN, 2, 1, 1, 1,UN, 1,UN,UN,UN, 1, 1, 1,UN,UN,UN,
/*80*/   1,UN,UN,UN, 1,UN,UN,UN, 1,UN,UN,UN,UN,UN,UN,UN,
/*90*/   1,UN,UN,UN, 1,UN,UN,UN, 1,UN,UN,UN,UN,UN,UN,UN,
/*A0*/   1, 1, 1, 1, 1, 1, 1, 1,UN,UN,UN,UN, 1,UN, 1,UN,
/*B0*/  UN,UN,UN,UN,UN,UN,UN,UN, 1, 1, 1, 1, 1, 1, 1, 1,
/*C0*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*D0*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*E0*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*F0*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
};

static char *cpupag[4] = {
    pg5840, pg5842, pg5842x, pg5842x
};

int cputyp;

/*
 * Process machine ops.
 */
void
machine(struct mne *mp)
{
	int op;
	struct expr e;
	char *jp;

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
		cputyp = op;
		sym[2].s_addr = op;
		lmode = SLIST;
		break;


	/* J, CAL */
	case I_ADR11:
		if (addr(&e) != S_EXT) {
			xerr('w', "Argument should be an address - not #N");
		}
		if (cputyp == MSM5842) {
			outrwm(&e, M_ADR9 | R_MBRO, op << 8);
		} else {
			outrwm(&e, M_ADR11 | R_MBRO, op << 8);
		}
		if (is_abs(&e)) {
			switch(cputyp) {
			case MSM5840:
				if (e.e_addr > 4095) xerr('a', "MSM5840 Memory Range Exceeded");
				break;
			case MSM5842:
				if (e.e_addr > 767) xerr('a', "MSM5842 Memory Range Exceeded");
				break;
			case MSM58421:
				if (e.e_addr > 1535) xerr('a', "MSM58421 Memory Range Exceeded");
				break;
			case MSM58422:
				if (e.e_addr > 1535) xerr('a', "MSM58422 Memory Range Exceeded");
				break;
			default:
				break;
			}
		}
		break;

	/* JC */
	case I_ADR6:
		/* Save Argument Pointer */
		jp = ip;
		/* Output The Current Page On The Fly */
		ip = ". & ~0x3F";
		expr(&e);
		outdp(dot.s_area, &e, 0);
		/* Restore The Argument Pointer */
		ip = jp;
		/* Process Argument */
		clrexpr(&e);
		if (addr(&e) != S_EXT) {
			xerr('w', "Argument should be an address - not #N");
		}
		outrbm(&e, M_ADR6 | R_PAGN, op);
		break;

	/* AIS, LAI, LLI */
	case I_IMM4:
		if (addr(&e) != S_IMMED) {
			xerr('w', "Argument should be #N - not an address");
		}
		outrbm(&e, M_IMM4 | R_MBRO, op);
		break;

	/* LHI */
	case I_IMM3:
		if (addr(&e) != S_IMMED) {
			xerr('w', "Argument should be #N - not an address");
		}
		if (cputyp == MSM5842) {
			outrbm(&e, M_IMM1 | R_MBRO, op);
		} else {
			outrbm(&e, M_IMM3 | R_MBRO, op);
		}
		break;

	/* SMI, LM, XM, TAB, TMB, TKB, SPB, RPB, SMB, RMB */
	case I_IMM2:
		if (addr(&e) != S_IMMED) {
			xerr('w', "Argument should be #N - not an address");
		}
		outrbm(&e, M_IMM2 | R_MBRO, op);
		break;

	/* THB */
	case I_IMM1:
		if (addr(&e) != S_IMMED) {
			xerr('w', "Argument should be #N - not an address");
		}
		outrbm(&e, M_IMM1 | R_MBRO,op);
		break;

	/* LTI */
	case I_LTI:
		outab(op);
		if (cputyp == MSM5840) {
			if (addr(&e) != S_IMMED) {
				xerr('w', "Argument should be #N - not an address");
			}
			outrb(&e, R_OVRF);
		}
		break;

	case I_INH:
		outab(op);
		break;

	default:
		opcycles = OPCY_ERR;
		xerr('o', "Internal Opcode Error.");
		break;
	}
	if (opcycles == OPCY_NONE) {
		opcycles = cpupag[cputyp][cb[0] & 0xFF];

		if (opcycles == UN) {
			switch(cputyp) {
			case MSM5840:
				xerr('x', "Invalid Or Unsupported MSM5840 Instruction");
				break;
			case MSM5842:
				xerr('x', "Invalid Or Unsupported MSM5842 Instruction");
				break;
			case MSM58421:
				xerr('x', "Invalid Or Unsupported MSM58421 Instruction");
				break;
			case MSM58422:
				xerr('x', "Invalid Or Unsupported MSM58422 Instruction");
				break;
			default:
				break;
			}
		}
	}
	/*
	 * Translate To External Format
	 */
	if (opcycles == OPCY_NONE) { opcycles  =  CYCL_NONE; } else
	if (opcycles  & OPCY_NONE) { opcycles |= (CYCL_NONE | 0x3F00); }
}

/*
 * Machine Specific Initialization
 */
void
minit(void)
{
	/*
	 * Byte Order
	 */
	hilo = 1;
	/*
	 * Select MSM5840 As Default CPU
	 */
	cputyp = MSM5840;
	sym[2].s_addr = MSM5840;
	/*
	 * Set Page Mask To 64 Bytes
	 */
	p_mask = 0x3F;
}
