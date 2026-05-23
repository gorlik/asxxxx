/* pdp11cyc.c */

/*
 *  Copyright (C) 2022-2025  Alan R. Baldwin
 *  Copyright (C) 2022-2025  Nick Downing
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
#include "pdp11.h"

/*
 * J11 Instruction Addressing Mode MicroCycle Timing
 *   Taken from:
 *	DCJ11   Microprocessor User's Guide -- EK-DCJ11-UG-PRE
 *	KDJ11-A Microprocessor User's Guide -- EK-KDJ1A-UG-001
 */

/* Table S1 Source Address Time: All Double Operand */
static char S1[64] = {
/*--*--* 0  1  2  3  4  5  6  7 */
/*--*--* -  -  -  -  -  -  -  - */
/*00*/   0, 0, 0, 0, 0, 0, 0, 0,
/*10*/   2, 2, 2, 2, 2, 2, 2, 2,
/*20*/   2, 2, 2, 2, 2, 2, 2, 1,
/*30*/   4, 4, 4, 4, 4, 4, 4, 3,
/*40*/   3, 3, 3, 3, 3, 3, 3, 6,
/*50*/   5, 5, 5, 5, 5, 5, 5, 8,
/*60*/   4, 4, 4, 4, 4, 4, 4, 4,
/*70*/   6, 6, 6, 6, 6, 6, 6, 6
};

/* Table D1 Destination Address Time: Read Only Single Operand */
static char D1[64] = {
/*--*--* 0  1  2  3  4  5  6  7 */
/*--*--* -  -  -  -  -  -  -  - */
/*00*/   0, 0, 0, 0, 0, 0, 0, 0,
/*10*/   2, 2, 2, 2, 2, 2, 2, 2,
/*20*/   2, 2, 2, 2, 2, 2, 2, 1,
/*30*/   4, 4, 4, 4, 4, 4, 4, 3,
/*40*/   3, 3, 3, 3, 3, 3, 3, 7,
/*50*/   5, 5, 5, 5, 5, 5, 5, 9,
/*60*/   4, 4, 4, 4, 4, 4, 4, 4,
/*70*/   6, 6, 6, 6, 6, 6, 6, 6
};

/* Table D2 Destination Address Time: Read Only Double Operand */
static char D2[64] = {
/*--*--* 0  1  2  3  4  5  6  7 */
/*--*--* -  -  -  -  -  -  -  - */
/*00*/   0, 0, 0, 0, 0, 0, 0, 0,
/*10*/   3, 3, 3, 3, 3, 3, 3, 3,
/*20*/   3, 3, 3, 3, 3, 3, 3, 2,
/*30*/   5, 5, 5, 5, 5, 5, 5, 4,
/*40*/   4, 4, 4, 4, 4, 4, 4, 8,
/*50*/   6, 6, 6, 6, 6, 6, 6,10,
/*60*/   5, 5, 5, 5, 5, 5, 5, 5,
/*70*/   7, 7, 7, 7, 7, 7, 7, 7
};

/* Table D3 Destination Address Time: Write Only */
static char D3[64] = {
/*--*--* 0  1  2  3  4  5  6  7 */
/*--*--* -  -  -  -  -  -  -  - */
/*00*/   0, 0, 0, 0, 0, 0, 0, 5,
/*10*/   2, 2, 2, 2, 2, 2, 2, 6,
/*20*/   2, 2, 2, 2, 2, 2, 2, 6,
/*30*/   4, 4, 4, 4, 4, 4, 4, 3,
/*40*/   3, 3, 3, 3, 3, 3, 3, 7,
/*50*/   5, 5, 5, 5, 5, 5, 5, 9,
/*60*/   4, 4, 4, 4, 4, 4, 4, 4,
/*70*/   6, 6, 6, 6, 6, 6, 6, 6
};

/* Table D4 Destination Address Time: Read Modify Write */
static char D4[64] = {
/*--*--* 0  1  2  3  4  5  6  7 */
/*--*--* -  -  -  -  -  -  -  - */
/*00*/   0, 0, 0, 0, 0, 0, 0, 5,
/*10*/   3, 3, 3, 3, 3, 3, 3, 7,
/*20*/   3, 3, 3, 3, 3, 3, 3, 7,
/*30*/   5, 5, 5, 5, 5, 5, 5, 4,
/*40*/   4, 4, 4, 4, 4, 4, 4, 8,
/*50*/   6, 6, 6, 6, 6, 6, 6,10,
/*60*/   5, 5, 5, 5, 5, 5, 5, 5,
/*70*/   7, 7, 7, 7, 7, 7, 7, 7
};

/* Table D5 Destination Address Time: JMP */
static char D5[64] = {
/*--*--* 0  1  2  3  4  5  6  7 */
/*--*--* -  -  -  -  -  -  -  - */
/*00*/   0, 0, 0, 0, 0, 0, 0, 0,
/*10*/   4, 4, 4, 4, 4, 4, 4, 4,
/*20*/   6, 6, 6, 6, 6, 6, 6, 6,
/*30*/   5, 5, 5, 5, 5, 5, 5, 5,
/*40*/   5, 5, 5, 5, 5, 5, 5, 5,
/*50*/   6, 6, 6, 6, 6, 6, 6, 6,
/*60*/   6, 6, 6, 6, 6, 6, 6, 5,
/*70*/   7, 7, 7, 7, 7, 7, 7, 7
};

/* Table D6 Destination Address Time: JSR */
static char D6[64] = {
/*--*--* 0  1  2  3  4  5  6  7 */
/*--*--* -  -  -  -  -  -  -  - */
/*00*/   0, 0, 0, 0, 0, 0, 0, 0,
/*10*/   9, 9, 9, 9, 9, 9, 9, 9,
/*20*/  10,10,10,10,10,10,10,10,
/*30*/  10,10,10,10,10,10,10, 9,
/*40*/  10,10,10,10,10,10,10,10,
/*50*/  11,11,11,11,11,11,11,11,
/*60*/  10,10,10,10,10,10,10, 9,
/*70*/  12,12,12,12,12,12,12,12
};

/* Table F1S Floating Source Single */
static char F1S[64] = {
/*--*--* 0  1  2  3  4  5  6  7 */
/*--*--* -  -  -  -  -  -  -  - */
/*00*/   0, 0, 0, 0, 0, 0, 0, 0,
/*10*/   3, 3, 3, 3, 3, 3, 3, 2,
/*20*/   3, 3, 3, 3, 3, 3, 3, 1,
/*30*/   4, 4, 4, 4, 4, 4, 4, 3,
/*40*/   4, 4, 4, 4, 4, 4, 4, 4,
/*50*/   5, 5, 5, 5, 5, 5, 5, 5,
/*60*/   4, 4, 4, 4, 4, 4, 4, 4,
/*70*/   6, 6, 6, 6, 6, 6, 6, 6
};

/* Table F1D Floating Source Double */
static char F1D[64] = {
/*--*--* 0  1  2  3  4  5  6  7 */
/*--*--* -  -  -  -  -  -  -  - */
/*00*/   0, 0, 0, 0, 0, 0, 0, 0,
/*10*/   5, 5, 5, 5, 5, 5, 5, 5,
/*20*/   5, 5, 5, 5, 5, 5, 5, 0,
/*30*/   6, 6, 6, 6, 6, 6, 6, 5,
/*40*/   6, 6, 6, 6, 6, 6, 6, 6,
/*50*/   7, 7, 7, 7, 7, 7, 7, 7,
/*60*/   6, 6, 6, 6, 6, 6, 6, 6,
/*70*/   8, 8, 8, 8, 8, 8, 8, 8
};

/* Table F2S Floating Destination Single */
static char F2S[64] = {
/*--*--* 0  1  2  3  4  5  6  7 */
/*--*--* -  -  -  -  -  -  -  - */
/*00*/   0, 0, 0, 0, 0, 0, 0, 0,
/*10*/   3, 3, 3, 3, 3, 3, 3, 3,
/*20*/   3, 3, 3, 3, 3, 3, 3, 1,
/*30*/   4, 4, 4, 4, 4, 4, 4, 3,
/*40*/   4, 4, 4, 4, 4, 4, 4, 4,
/*50*/   5, 5, 5, 5, 5, 5, 5, 5,
/*60*/   4, 4, 4, 4, 4, 4, 4, 4,
/*70*/   6, 6, 6, 6, 6, 6, 6, 6
};

/* Table F2D Floating Destination Double */
static char F2D[64] = {
/*--*--* 0  1  2  3  4  5  6  7 */
/*--*--* -  -  -  -  -  -  -  - */
/*00*/   0, 0, 0, 0, 0, 0, 0, 0,
/*10*/   5, 5, 5, 5, 5, 5, 5, 5,
/*20*/   5, 5, 5, 5, 5, 5, 5, 0,
/*30*/   6, 6, 6, 6, 6, 6, 6, 5,
/*40*/   6, 6, 6, 6, 6, 6, 6, 6,
/*50*/   7, 7, 7, 7, 7, 7, 7, 7,
/*60*/   6, 6, 6, 6, 6, 6, 6, 6,
/*70*/   8, 8, 8, 8, 8, 8, 8, 8
};

/* Table F3S Floating Read Modify Write Single */
static char F3S[64] = {
/*--*--* 0  1  2  3  4  5  6  7 */
/*--*--* -  -  -  -  -  -  -  - */
/*00*/   0, 0, 0, 0, 0, 0, 0, 0,
/*10*/   5, 5, 5, 5, 5, 5, 5, 5,
/*20*/   5, 5, 5, 5, 5, 5, 5, 1,
/*30*/   6, 6, 6, 6, 6, 6, 6, 5,
/*40*/   6, 6, 6, 6, 6, 6, 6, 6,
/*50*/   7, 7, 7, 7, 7, 7, 7, 7,
/*60*/   6, 6, 6, 6, 6, 6, 6, 6,
/*70*/   8, 8, 8, 8, 8, 8, 8, 8
};

/* Table F3D Floating Read Modify Write Double */
static char F3D[64] = {
/*--*--* 0  1  2  3  4  5  6  7 */
/*--*--* -  -  -  -  -  -  -  - */
/*00*/   0, 0, 0, 0, 0, 0, 0, 0,
/*10*/   9, 9, 9, 9, 9, 9, 9, 9,
/*20*/   9, 9, 9, 9, 9, 9, 9, 0,
/*30*/  10,10,10,10,10,10,10, 9,
/*40*/  10,10,10,10,10,10,10,10,
/*50*/  11,11,11,11,11,11,11,11,
/*60*/  10,10,10,10,10,10,10,10,
/*70*/  12,12,12,12,12,12,12,12
};

/* Table F4I Integer Source */
static char F4I[64] = {
/*--*--* 0  1  2  3  4  5  6  7 */
/*--*--* -  -  -  -  -  -  -  - */
/*00*/   0, 0, 0, 0, 0, 0, 0, 0,
/*10*/   2, 2, 2, 2, 2, 2, 2, 2,
/*20*/   2, 2, 2, 2, 2, 2, 2, 0,
/*30*/   3, 3, 3, 3, 3, 3, 3, 2,
/*40*/   3, 3, 3, 3, 3, 3, 3, 3,
/*50*/   4, 4, 4, 4, 4, 4, 4, 4,
/*60*/   3, 3, 3, 3, 3, 3, 3, 3,
/*70*/   5, 5, 5, 5, 5, 5, 5, 5
};

/* Table F4L Long Integer Source */
static char F4L[64] = {
/*--*--* 0  1  2  3  4  5  6  7 */
/*--*--* -  -  -  -  -  -  -  - */
/*00*/   0, 0, 0, 0, 0, 0, 0, 0,
/*10*/   4, 4, 4, 4, 4, 4, 4, 4,
/*20*/   4, 4, 4, 4, 4, 4, 4, 0,
/*30*/   5, 5, 5, 5, 5, 5, 5, 4,
/*40*/   5, 5, 5, 5, 5, 5, 5, 5,
/*50*/   6, 6, 6, 6, 6, 6, 6, 6,
/*60*/   5, 5, 5, 5, 5, 5, 5, 5,
/*70*/   7, 7, 7, 7, 7, 7, 7, 7
};

/* Table F5I Integer Destination */
static char F5I[64] = {
/*--*--* 0  1  2  3  4  5  6  7 */
/*--*--* -  -  -  -  -  -  -  - */
/*00*/   0, 0, 0, 0, 0, 0, 0, 0,
/*10*/   2, 2, 2, 2, 2, 2, 2, 2,
/*20*/   2, 2, 2, 2, 2, 2, 2, 2,
/*30*/   3, 3, 3, 3, 3, 3, 3, 2,
/*40*/   3, 3, 3, 3, 3, 3, 3, 3,
/*50*/   4, 4, 4, 4, 4, 4, 4, 4,
/*60*/   3, 3, 3, 3, 3, 3, 3, 3,
/*70*/   5, 5, 5, 5, 5, 5, 5, 5
};

/* Table F5L Long Integer Destination */
static char F5L[64] = {
/*--*--* 0  1  2  3  4  5  6  7 */
/*--*--* -  -  -  -  -  -  -  - */
/*00*/   0, 0, 0, 0, 0, 0, 0, 0,
/*10*/   4, 4, 4, 4, 4, 4, 4, 4,
/*20*/   4, 4, 4, 4, 4, 4, 4, 2,
/*30*/   5, 5, 5, 5, 5, 5, 5, 4,
/*40*/   5, 5, 5, 5, 5, 5, 5, 5,
/*50*/   6, 6, 6, 6, 6, 6, 6, 6,
/*60*/   5, 5, 5, 5, 5, 5, 5, 5,
/*70*/   7, 7, 7, 7, 7, 7, 7, 7
};

/*
 * Determine Machine Cycles
 */
int
mchcycles(struct mne *mp, a_uint opcode, int cycles)
{
	a_uint op;
	int rf;
	int v1, v2;

	v1 =  ((int) opcode) & 077;
	v2 = (((int) opcode) >> 6) & 077;

	op = mp->m_valu;
	rf = mp->m_type;
	switch(rf) {
	/*
	 * Basic PDP11 Instructions
	 */
	default:
		switch(op) {
		/*
		 * Table D1 Single Operand Instructions
		 */
		case 0070000:	/* mul */
		case 0071000:	/* div */
		case 0072000:	/* ash */
		case 0073000:	/* ashc */
		case 0006500:	/* mfpi */
		case 0106500:	/* mfpd */
		case 0106400:	/* mtps */
		case 0007000:	/* csm */
			cycles += D1[v1];
			break;
		/*
		 * Table D3 Single Operand Instructions
		 */
		case 0005000:	/* clr */
		case 0105000:	/* clrb */
		case 0006700:	/* sxt */
			cycles += D3[v1];
			break;
		/*
		 * Table D4 Single Operand Instructions
		 */
		case 0000300:	/* swab */
		case 0005100:	/* com */
		case 0105100:	/* comb */
		case 0005200:	/* inc */
		case 0105200:	/* incb */
		case 0005300:	/* dec */
		case 0105300:	/* decb */
		case 0005400:	/* neg */
		case 0105400:	/* negb */
		case 0005500:	/* adc */
		case 0105500:	/* adcb */
		case 0005600:	/* sbc */
		case 0105600:	/* sbcb */
		case 0005700:	/* tst */
		case 0105700:	/* tstb */
		case 0006000:	/* ror */
		case 0106000:	/* rorb */
		case 0006100:	/* rol */
		case 0106100:	/* rolb */
		case 0006200:	/* asr */
		case 0106200:	/* asrb */
		case 0006300:	/* asl */
		case 0106300:	/* aslb */
		case 0007200:	/* tstset */
		case 0007600:	/* wrtlck */
		case 0074000:	/* xor */
			cycles += D4[v1];
			break;
		/*
		 * Table D5 JMP
		 */
		case 0000100:	/* jmp */
			cycles += D5[v1];
			break;
		/*
		 * Table D6 JSR
		 */
		case 0004000:	/* jsr */
			cycles += D6[v1];
			break;
		/*
		 * Tables S1/D2 Double Operand
		 */
		case 003000:	/* bit */
		case 013000:	/* bitb */
		case 002000:	/* cmp */
		case 012000:	/* cmpb */
			cycles += S1[v2] + D2[v1];
			break;
		/*
		 * Tables S1/D3 Double Operand
		 */
		case 0010000:	/* mov */
		case 0110000:	/* movb */
			cycles += S1[v2] + D3[v1];
			break;
		/*
		 * Tables S1/D4 Double Operand
		 */
		case 0040000:	/* bic */
		case 0140000:	/* bicb */
		case 0050000:	/* bis */
		case 0150000:	/* bisb */
		case 0060000:	/* add */
		case 0160000:	/* sub */
			cycles += S1[v2] + D4[v1];
			break;
		/*
		 * Floating Point Support Instructions
		 */
		case 017010:	/* ldfps */
			cycles += F4I[v1];
			break;
		case 0170200:	/* stfps */
		case 0170300:	/* stst */
			cycles += F5I[v1];
			break;
		/*
		 * Inherent Timing Instructions
		 */
		default:
			break;
		}
		break;
	/*
	 * Single Precision Floating Point
	 */
	case S_FXXX:
		switch(op) {
		case 0170600:	/* absf */
	        case 0170700:	/* negf */
			cycles += F3S[v1];
			break;
		case 0170400: 	/* clrf */
			cycles += F2S[v1];
			break;
		case 0170500:	/* tstf */
			cycles += F1S[v1];
			break;
		default:
			break;
		}
		break;
	case S_ACDST:
		/* stcfi, stcfl, stexp */
		cycles += F5I[v1];
		break;
	case S_SRCAC:
		/* ldcfi, ldcfl, ldexp */
		cycles += F4I[v1];
		break;
	case S_ACFDST:
		/* stcdf, stf */
   		cycles += F2S[v1];
		break;
	case S_FSRCAC:
		/* addf, cmpf, subf, ldcdf */
		/* divf, modf, mulf */
		cycles += F1S[v1];
		break;
	/*
	 * Double Precision Floating Point
	 */
	case D_FXXX:
		switch(op) {
		case 0170600:	/* absf */
	        case 0170700:	/* negf */
			cycles += F3D[v1];
			if (v1 == 027) {
				cycles -= 2;
			}
			break;
		case 0170400: 	/* clrf */
			cycles += F2D[v1];
			break;
		case 0170500:	/* tstf */
			cycles += F1D[v1];
			break;
		default:
			break;
		}
		break;
	case D_ACDST:
		/* stcfi, stcfl, stexp */
		cycles += F5L[v1];
		break;
	case D_SRCAC:
		/* ldcfi, ldcfl, ldexp */
		cycles += F4L[v1];
		break;
	case D_ACFDST:
		/* stcdf, stf */
		cycles += F2D[v1];
		if (v1 == 027) {
			cycles -= 1;
		}
		break;
	case D_FSRCAC:
		/* addf, cmpf, subf, ldcdf */
		/* divf, modf, mulf */
		cycles += F1D[v1];
		break;
	/*
	 * CIS Instructions (Unknown Cycles)
	 */
	case S_CIS:
		break;
	/*
	 * Other Instructions
	 */
	case S_JBR:
		switch(opcode) {
		case 000137:	cycles = D5[037];	break;
		case 000167:	cycles = D5[067];	break;
		default:	break;
		}
		break;
	case S_JCOND:
		switch(opcode) {
		case 000137:	cycles = D5[037] + 2;	break;
		case 000167:	cycles = D5[067] + 2;	break;
		default:	break;
		}
		break;
	/*
	 * Non Instructions
	 */
	case S_RAD50:
	case S_INT32:
	case W_FLT16:
	case S_FLT32:
	case D_FLT64:
		break;
	}

	return(cycles);
}


/*
 * Base Cycles Structure
 */
struct	cyc
{
	char	*m_id;
	int	m_cyc;
};

struct	cyc	cyc[] = {

	/* Machine Specific Directives */

    {	".save",	UN	},
    {	".restore",	UN	},
    {	".ifdf",	UN	},
    {	".ifndf",	UN	},
    {	".iifdf",	UN	},
    {	".iifndf",	UN	},
    {	".endc",	UN	},
    {	".endr",	UN	},

    {	".enabl",	UN	},
    {	".dsabl",	UN	},

    {	".rad50",	UN	},

    {	".int32",	UN	},
    {	".flt16",	UN	},
    {	".flt32",	UN	},
    {	".flt64",	UN	},
    {	".flt1",	UN	},
    {	".flt2",	UN	},
    {	".flt4",	UN	},

	/* Double Operand */

    {	"mov",		1	},
    {	"movb",		1	},
    {	"cmp",		1	},
    {	"cmpb",		1	},
    {	"bit",		1	},
    {	"bitb",		1	},
    {	"bic",		1	},
    {	"bicb",		1	},
    {	"bis",		1	},
    {	"bisb",		1	},
    {	"add",		1	},
    {	"sub",		1	},

	/* RXX Argument */

    {	"jsr",		0	},
    {	"xor",		1	},

	/* Single Operand */

    {	"jmp",		0	},
    {	"swab",		1	},
    {	"clr",		1	},
    {	"clrb",		1	},
    {	"com",		1	},
    {	"comb",		1	},
    {	"inc",		1	},
    {	"incb",		1	},
    {	"dec",		1	},
    {	"decb",		1	},
    {	"neg",		1	},
    {	"negb",		1	},
    {	"adc",		1	},
    {	"adcb",		1	},
    {	"sbc",		1	},
    {	"sbcb",		1	},
    {	"tst",		1	},
    {	"tstb",		1	},
    {	"ror",		1	},
    {	"rorb",		1	},
    {	"rol",		1	},
    {	"rolb",		1	},
    {	"asr",		1	},
    {	"asrb",		1	},
    {	"asl",		1	},
    {	"aslb",		1	},
    {	"mtps",		8	},
    {	"mfpi",		5	},
    {	"mfpd",		5	},
    {	"mtpi",		3	},
    {	"mtpd",		3	},
    {	"sxt",		1	},
    {	"mfps",		1	},
    {	"csm",		28	},
    {	"tstset",	5	},
    {	"wrtlck",	4	},

	/* Branch */

    {	"br",		4	},
    {	"bra",		4	},
    {	"bne",		4	},
    {	"beq",		4	},
    {	"bge",		4	},
    {	"blt",		4	},
    {	"bgt",		4	},
    {	"ble",		4	},
    {	"bpl",		4	},
    {	"bmi",		4	},
    {	"bhi",		4	},
    {	"blos",		4	},
    {	"bvc",		4	},
    {	"bvs",		4	},
    {	"bhis",		4	},
    {	"bcc",		4	},
    {	"blo",		4	},
    {	"bcs",		4	},
    {	"sob",		5	},

	/* Special Operands */

    {	"emt",		20	},
    {	"trap",		20	},
    {	"spl",		7	},
    {	"rts",		5	},
    {	"mark",		10	},

	/* Control Instructions */

    {	"halt",		UN	},
    {	"wait",		UN	},
    {	"rti",		9	},
    {	"bpt",		20	},
    {	"iot",		20	},
    {	"reset",	UN	},
    {	"rtt",		9	},
    {	"mfpt",		2	},

	/* Flag-Setting */

    {	"nop",		3	},
    {	"clc",		3	},
    {	"clv",		3	},
    {	"clz",		3	},
    {	"cln",		3	},
    {	"ccc",		3	},
    {	"sec",		3	},
    {	"sev",		3	},
    {	"sez",		3	},
    {	"sen",		3	},
    {	"scc",		3	},

    	/* EIS Instructions */

    {	"mul",		22	},
    {	"div",		34	},
    {	"ash",		4	},
    {	"ashc",		5	},

    	/* FIS Instructions */

    {	"fadd",		35	},
    {	"fsub",		41	},
    {	"fmul",		61	},
    {	"fdiv",		63	},

	/* Floating Point Support Instructions */

    {	"cfcc",		5	},
    {	"setf",		6	},
    {	"setd",		6	},
    {	"seti",		6	},
    {	"setl",		6	},
    {	"stfps",	9	},
    {	"stst",		7	},
    {	"ldfps",	6	},

	/* Single Precision FP11 Instructions */

    {	"absf",		20	},
    {	"addf",		35	},
    {	"clrf",		12	},
    {	"cmpf",		19	},
    {	"divf",		63	},
    {	"ldcid",	42	},
    {	"ldcif",	36	},
    {	"ldcfd",	21	},
    {	"ldexp",	18	},
    {	"ldf",		13	},
    {	"modf",		115	},
    {	"mulf",		61	},
    {	"negf",		19	},
    {	"stcdf",	20	},
    {	"stcdi",	38	},
    {	"stf",		8	},
    {	"stcfi",	35	},
    {	"stexp",	16	},
    {	"subf",		104	},
    {	"tstf",		10	},

	/* Double Precision FP11 Instructions */

    {	"absd",		24	},
    {	"addd",		119	},
    {	"clrd",		14	},
    {	"cmpd",		25	},
    {	"divd",		167	},
    {	"ldcdf",	26	},
    {	"ldcld",	52	},
    {	"ldclf",	44	},
    {	"ldd",		17	},
    {	"modd",		217	},
    {	"muld",		173	},
    {	"negd",		23	},
    {	"stcfd",	20	},
    {	"stcfl",	51	},
    {	"std",		12	},
    {	"stcdl",	54	},
    {	"subd",		122	},
    {	"tstd",		12	},

    	/* Commercial Instruction Set (CIS) */

    {	"addn",		UN	},
    {	"addni",	UN	},
    {	"addp",		UN	},
    {	"addpi",	UN	},
    {	"ashn",		UN	},
    {	"ashni",	UN	},
    {	"ashp",		UN	},
    {	"ashpi",	UN	},
    {	"cmpc",		UN	},
    {	"cmpci",	UN	},
    {	"cmpn",		UN	},
    {	"cmpni",	UN	},
    {	"cmpp",		UN	},
    {	"cmppi",	UN	},
    {	"cvtln",	UN	},
    {	"cvtlni",	UN	},
    {	"cvtlp",	UN	},
    {	"cvtlpi",	UN	},
    {	"cvtnl",	UN	},
    {	"cvtnli",	UN	},
    {	"cvtnp",	UN	},
    {	"cvtnpi",	UN	},
    {	"cvtpl",	UN	},
    {	"cvtpli",	UN	},
    {	"cvtpn",	UN	},
    {	"cvtpni",	UN	},
    {	"divp",		UN	},
    {	"divpi",	UN	},
    {	"locc",		UN	},
    {	"locci",	UN	},
    {	"l2dn",		UN	},
    {	"l2d0",		UN	},
    {	"l2d1",		UN	},
    {	"l2d2",		UN	},
    {	"l2d3",		UN	},
    {	"l2d4",		UN	},
    {	"l2d5",		UN	},
    {	"l2d6",		UN	},
    {	"l2d7",		UN	},
    {	"l3dn",		UN	},
    {	"l3d0",		UN	},
    {	"l3d1",		UN	},
    {	"l3d2",		UN	},
    {	"l3d3",		UN	},
    {	"l3d4",		UN	},
    {	"l3d5",		UN	},
    {	"l3d6",		UN	},
    {	"l3d7",		UN	},
    {	"matc",		UN	},
    {	"matci",	UN	},
    {	"movc",		UN	},
    {	"movci",	UN	},
    {	"movrc",	UN	},
    {	"movrci",	UN	},
    {	"movtc",	UN	},
    {	"movtci",	UN	},
    {	"mulp",		UN	},
    {	"mulpi",	UN	},
    {	"scanc",	UN	},
    {	"scanci",	UN	},
    {	"skpc",		UN	},
    {	"skpci",	UN	},
    {	"spanc",	UN	},
    {	"spanci",	UN	},
    {	"subn",		UN	},
    {	"subni",	UN	},
    {	"subp",		UN	},
    {	"subpi",	UN	},

	/* Alternate and Additional Instructions */
	/*     From Bell Laboratories V7 Unix    */

    {	"sys",		20	},	/* trap */

	/* Branch Instructions */

    {	"bec",		4	},	/* Branch On Error Clear, C=0 */
    {	"bes",		4	},	/* Branch On Error Set,   C=1 */

	/* Long Branch Instructions */

    {	"jbr",		4	},
    {	"jne",		4	},
    {	"jeq",		4	},
    {	"jge",		4	},
    {	"jlt",		4	},
    {	"jgt",		4	},
    {	"jle",		4	},
    {	"jpl",		4	},
    {	"jmi",		4	},
    {	"jhi",		4	},
    {	"jlos",		4	},
    {	"jvc",		4	},
    {	"jvs",		4	},
    {	"jhis",		4	},
    {	"jec",		4	},
    {	"jcc",		4	},
    {	"jlo",		4	},
    {	"jcs",		4	},
    {	"jes",		4	},

	/* Alternate EIS Instructions */

    {	"mpy",		22	},
    {	"dvd",		34	},
    {	"als",		4	},
    {	"alsc",		5	},

	/* Alternate FP11 Instructoins */

    {	"movf",		0	},	/* ldf or stf */
    {	"movif",	36	},	/* ldcif */
    {	"movfi",	35	},	/* stcfi */
    {	"movof",	26	},	/* ldcdf */
    {	"movfo",	20	},	/* stcdf */
    {	"movie",	18	},	/* ldexp */
    {	"movei",	16	},	/* stexp */

	/* Termination */

    {	NULL,		0	}
};

/*
 * Function To Get Base Cycle Count
 */
int
mclookup(struct mne *mp)
{
	int i;
	struct cyc *mc;

	for (i=0; ;i++) {
		mc = &cyc[i];
		if (mc->m_id == NULL) break;
		if(symeq(mc->m_id, mp->m_id, 1)) {
			return (mc->m_cyc);
		}
	}
	fprintf(stderr, "Internal Cycles Lookup Error\n");
	return(0);
}

