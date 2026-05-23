/* m68kcyc.c */

/*
 *  Copyright (C) 2022-2024  Alan R. Baldwin
 *  Copyright (C) 2022-2024  Nick Downing
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
#include "m68k.h"

/*
 * Dispatcher
 */
int
mchcycles(mp, opcode, op2, x1, x2, rc, cycles)
struct mne *mp;
a_uint opcode, op2;
int x1, x2, rc;
int cycles;
{
	int rf;

	rf = mp->m_type;
	if ((rf >= 40) & (rf <= 59)) {
		cycles = mc6888xcycles(mp, opcode, op2, x1, x2, rc, cycles);
	} else {
		switch(mchtyp) {
		case M_68000:	cycles = mc68000cycles(mp, opcode, rc, cycles);	break;
		case M_68008:	cycles = mc68008cycles(mp, opcode, rc, cycles);	break;
		case M_68010:	cycles = mc68010cycles(mp, opcode, rc, cycles);	break;
		case M_68020:	cycles = mc68020cycles(mp, opcode, op2, x1, x2, rc, cycles);	break;
		default:	cycles = CYCL_NONE;	break;
		}
	}
	return(cycles);
}

/*
 * Effective Address Mode in <5:0> Of Opcode
 */
int
eamlo(opcode)
a_uint opcode;
{
	int am;

	am = (((int) opcode) & 070) >> 3;
	if (am == 7) {
		am += (((int) opcode) & 7);
	}
	return(am);
}

/*
 * Effective Address Mode in <11:6> Of Opcode
 */
int
eamhi(opcode)
a_uint opcode;
{
	int am;

	am = (((int) opcode) & 0700) >> 6;
	if (am == 7) {
		am += ((((int) opcode) & 007000) >> 9);
	}
	return(am);
}

/*
 * 68000 Instruction Addressing Mode MicroCycle Timing
 *   Taken from:
 *	The Motorola MC68000 Microprocessor Family
 *		By Thomas L. Harman and Barbara Lawson
 *		C 1985 Prentice Hall
 */

/* Table D1 Effective Address Times */
static unsigned char D1[12][2] = {
/*---*---* B  L */
/*---*---* 0  1 */
/*---*---* -  - */
	{  0, 0 },	/* Dn */
	{  0, 0 },	/* An */
	{  4, 8 },	/* (An) */
	{  4, 8 },	/* (An)+ */
	{  6,10 },	/* -(An) */
	{  8,12 },	/* d(An) */
	{ 10,14 },	/* d(An,Xi) */
	{  8,12 },	/* xxx.W */
	{ 12,16 },	/* xxx.L */
	{  8,12 },	/* d(PC) */
	{ 10,14 },	/* d(PC,Xi) */
	{  4, 8 }	/* # */
};



/* Table D2 MOVE Byte and Word Times */
static unsigned char D2[12][12] = {
/*---*---* 0  1  2  3  4  5  6  7  8  9 10 11 */
/*---*---* -  -  -  -  -  -  -  -  -  -  -  - */
	{  4, 4, 8, 8, 8,12,14,12,16, 0, 0, 0 },	/* Dn */
	{  4, 4, 8, 8, 8,12,14,12,16, 0, 0, 0 },	/* An */
	{  8, 8,12,12,12,16,18,16,20, 0, 0, 0 },	/* (An) */
	{  8, 8,12,12,12,16,18,16,20, 0, 0, 0 },	/* (An)+ */
	{ 10,10,14,14,14,18,20,18,20, 0, 0, 0 },	/* -(An) */
	{ 12,12,16,16,16,20,22,20,24, 0, 0, 0 },	/* d(An) */
	{ 14,14,18,18,18,22,24,22,26, 0, 0, 0 },	/* d(An,Xi) */
	{ 12,12,16,16,16,20,22,20,24, 0, 0, 0 },	/* xxx.W */
	{ 16,16,20,20,20,24,26,24,28, 0, 0, 0 },	/* xxx.L */
	{ 12,12,16,16,16,20,22,20,24, 0, 0, 0 },	/* d(PC) */
	{ 14,14,18,18,18,22,24,22,26, 0, 0, 0 },	/* d(PC,Xi) */
	{  8, 8,12,12,12,16,18,16,20, 0, 0, 0 }		/* # */
};

/* Table D3 MOVE Long Times */
static unsigned char D3[12][12] = {
/*---*---* 0  1  2  3  4  5  6  7  8  9 10 11 */
/*---*---* -  -  -  -  -  -  -  -  -  -  -  - */
	{  4, 4,12,12,12,16,18,16,20, 0, 0, 0 },	/* Dn */
	{  4, 4,12,12,12,16,18,16,20, 0, 0, 0 },	/* An */
	{ 12,12,20,20,20,24,26,24,28, 0, 0, 0 },	/* (An) */
	{ 12,12,20,20,20,24,26,24,28, 0, 0, 0 },	/* (An)+ */
	{ 14,14,22,22,22,26,28,26,30, 0, 0, 0 },	/* -(An) */
	{ 16,16,24,24,24,28,30,28,32, 0, 0, 0 },	/* d(An) */
	{ 18,18,26,26,26,30,32,30,34, 0, 0, 0 },	/* d(An,Xi) */
	{ 16,16,24,24,24,28,30,28,32, 0, 0, 0 },	/* xxx.W */
	{ 20,20,28,28,28,32,34,32,36, 0, 0, 0 },	/* xxx.L */
	{ 16,16,24,24,24,28,30,28,32, 0, 0, 0 },	/* d(PC) */
	{ 18,18,26,26,26,30,32,30,34, 0, 0, 0 },	/* d(PC,Xi) */
	{ 12,12,20,20,20,24,26,24,28, 0, 0, 0 }		/* # */
};

/* Table D4 Standard Execution Times */
static unsigned char D4[10][2][3] = {
/*---*---* An Dn M         An Dn M  */
/*---*---* 0  1  2         0  1  2  */
/*---*---* -  -  -         -  -  -  */
      {	{  8, 4, 8 },	{  6, 6,12 } },	/* ADD */
      {	{  0, 4, 8 },	{  0, 6,12 } },	/* AND */
      {	{  8, 4, 0 },	{  6, 6, 0 } },	/* CMP */
      {	{  0,158,0 },	{  0, 0, 0 } },	/* DIVS */
      {	{  0,140,0 },	{  0, 0, 0 } },	/* DIVU */
      {	{  0, 4, 8 },	{  0, 8,12 } },	/* EOR */
      {	{  0,70, 0 },	{  0, 0, 0 } },	/* MULS */
      {	{  0,70, 0 },	{  0, 0, 0 } },	/* MULU */
      {	{  0, 4, 8 },	{  0, 6,12 } },	/* OR */
      {	{  8, 4, 8 },	{  6, 8,12 } }	/* SUB */
};

/* Table D5 Immediate Execution Times */
static unsigned char D5[9][2][3] = {
/*---*---* Dn An M         Dn An M  */
/*---*---* 0  1  2         0  1  2  */
/*---*---* -  -  -         -  -  -  */
      {	{  8, 0,12 },	{ 16, 0,20 } },	/* ADDI */
      {	{  4, 8, 8 },	{  8, 8,12 } },	/* ADDQ */
      {	{  8, 0,12 },	{ 18, 0,20 } },	/* ANDI */
      {	{  8, 0, 8 },	{ 14, 0,12 } },	/* CMPI */
      {	{  8, 0,12 },	{ 16, 0,20 } },	/* EORI */
      {	{  0, 0, 0 },	{  4, 0, 0 } },	/* MOVEQ */
      {	{  8, 0,12 },	{ 16, 0,20 } },	/* ORI */
      {	{  8, 0,12 },	{ 16, 0,20 } },	/* SUBI */
      {	{  4, 8, 8 },	{  8, 8,12 } }	/* SUBQ */
};

/* Table D6 Single Operand Execution Times */
static unsigned char D6[8][2][2] = {
/*---*---* R  M            R  M     */
/*---*---* 0  1            0  1     */
/*---*---* -  -            -  -     */
      {	{  4, 8 },	{  6,12 } },	/* CLR */
      {	{  6, 8 },	{  0, 0 } },	/* NBCD */
      {	{  4, 8 },	{  6,12 } },	/* NEG */
      {	{  4, 8 },	{  6,12 } },	/* NEGX */
      {	{  4, 8 },	{  6,12 } },	/* NOT */
      {	{  4, 8 },	{  6, 8 } },	/* SCC */
      {	{  4,10 },	{  0, 0 } },	/* TAS */
      {	{  4, 4 },	{  4, 4 } }	/* TST */
};

/* Table D7 Shift/Rotate Execution Times */
static unsigned char D7[1][2][2] = {
/*---*---* R  M            R  M     */
/*---*---* 0  1            0  1     */
/*---*---* -  -            -  -     */
      {	{  6, 8 },	{  8, 0 } }	/* ASR,ASL,LSR,LSL,ROR,ROL,ROXR,ROXL */
};

/* Table D8 Bit Manipulation Execution Times */
static unsigned char D8[4][2][2] = {
/*---*---* BYTE            LONG     */
/*---*---* 0  1            0  1     */
/*---*---* -  -            -  -     */
      {	{  8,12 },	{  8,12 } },	/* BCHG */
      {	{  8,12 },	{ 10,14 } },	/* BCLR */
      {	{  8,12 },	{  8,12 } },	/* BSET */
      {	{  4, 8 },	{  6,10 } }	/* BTST */
};

/* Table D9 Conditional Execution Times */
static unsigned char D9[4][2] = {
/*---*---* B  W  */
/*---*---* 0  1  */
/*---*---* -  -  */
      	{ 10,12 },	/* BCC */
      	{ 10,10 },	/* BRA */
      	{ 18,18 },	/* BSR */
      	{ 12,14 }	/* DBCC */
};

/* Table D10 JMP, JSR, LEA, PEA, and MOVEM Instruction Times */
static unsigned char D10[6][12] = {
/*---*---* 0  1  2  3  4  5  6  7  8  9 10 11 */
/*---*---* -  -  -  -  -  -  -  -  -  -  -  - */
	{  0, 0, 8, 0, 0,10,14,10,12,10,14, 0 },	/* JMP */
	{  0, 0,18, 0, 0,18,22,18,20,18,22, 0 },	/* JSR */
	{  0, 0, 4, 0, 0, 8,12, 8,12, 8,12, 0 },	/* LEA */
	{  0, 0,16, 0, 0,16,20,16,20,16,20, 0 },	/* PEA */
	{  0, 0,12,12, 0,16,18,16,20,16,18, 0 },	/* MOVEM M->R */
	{  0, 0, 8, 0, 8,12,14,12,16, 0, 0, 0 },	/* MOVEM R->M */
};

/* Table D11 Multiprecision Execution Times */
static unsigned char D11[5][2][2] = {
/*---*---* DN M            DN M     */
/*---*---* 0  1            0  1     */
/*---*---* -  -            -  -     */
      {	{  8,18 },	{  8,30 } },	/* ADDX */
      {	{  0,12 },	{  0,20 } },	/* CMPM */
      {	{  4,18 },	{  8,30 } },	/* SUBX */
      {	{  6,18 },	{  0, 0 } },	/* ABCD */
      {	{  6,18 },	{  0, 0 } }	/* SBCD */
};

/* Table D12 Miscellaneous Execution Times */
static unsigned char D12[26][2] = {
/*---*---* 0  1  */
/*---*---* -  -  */
      	{ 20,20 },	/* (0) ANDI [CCR,SR] */
      	{ 10, 0 },	/* (1) CHK */
      	{ 20,20 },	/* (2) EORI [CCR,SR] */
      	{ 20,20 },	/* (3) ORI  [CCR,SR] */
      	{  6, 0 },	/* (4) EXG */
      	{  4, 4 },	/* (5) EXT */
      	{ 34, 0 },	/* (6) ILLEGAL */
      	{ 16, 0 },	/* (7) LINK */
      	{  8, 8 },	/* (8) MOVE from CCR [R,M] */
      	{ 12,12 },	/* (9) MOVE to  CCR [R,M] */
      	{  8, 8 },	/* (10) MOVE from SR [R,M] */
      	{ 12,12 },	/* (11) MOVE to   SR [R,M] */
      	{  4, 0 },	/* (12) MOVE from USP */
      	{  4, 0 },	/* (13) MOVE to USP */
      	{  4, 0 },	/* (14) NOP */
      	{132, 0 },	/* (15) RESET */
      	{ 20, 0 },	/* (16) RTE */
      	{ 20, 0 },	/* (17) RTR */
      	{ 16, 0 },	/* (18) RTS */
      	{  4, 0 },	/* (19) STOP */
      	{  4, 0 },	/* (20) SWAP */
      	{ 38, 0 },	/* (21) TRAP */
      	{ 34, 0 },	/* (22) TRAPV */
      	{ 12, 0 },	/* (23) UNLK */
      	{ 16, 0 },	/* (24) RTD */
      	{ 10,12 }	/* (25) MOVEC */
};

/* Table D13 MOVE Peripheral Execution Times */
static unsigned char D13[1][2][2] = {
/*---*---* Word            Long     */
/*---*---* 0  1            0  1     */
/*---*---* -  -            -  -     */
      {	{ 16,16 },	{ 24,24 } }	/* MOVEP */
};

/*
 * Determine Machine Cycles
 */
int
mc68000cycles(mp, opcode, rc, cycles)
struct mne *mp;
a_uint opcode;
int rc;
int cycles;
{
	a_uint op;
	int rf, sz;
	int ix1, ix2, ix3, ixv;

	ix1 = ix2 = ix3 = ixv = 0;

	op = mp->m_valu;
	rf = mp->m_type;
	sz = mp->m_flag & 0x03;

	switch (rf) {

	case S_CMPM:	/* CMPM */
	case S_TYP1:	/* ABCD, SBCD, ADDX, SUBX */
		switch(op & 0xFF00) {
		case 0xD100:	ix1 = 0;	break;	/* ADDX */
		case 0xB100:	ix1 = 1;	break;	/* CMPM */
		case 0x9100:	ix1 = 2;	break;	/* SUBX */
		case 0xC100:	ix1 = 3;	break;	/* ABCD */
		case 0x8100:	ix1 = 4;	break;	/* SBCD */
		default:	break;
		}
		ix2 = (sz == A_L) ? 1 : 0;
		ix3 = (opcode & 8) ? 1 : 0;
		cycles += (int) D11[ix1][ix2][ix3];
		break;

	case S_EOR:	/* EOR */
	case S_TYP2:	/* ADD, AND, OR, SUB */
		switch(op & 0xFF00) {
		case 0xD000:	ix1 = 0;	break;	/* ADD */
		case 0xC000:	ix1 = 1;	break;	/* AND */
		case 0xB100:	ix1 = 5;	break;	/* EOR */
		case 0x8000:	ix1 = 8;	break;	/* OR */
		case 0x9000:	ix1 = 9;	break;	/* SUB */
		default:	ix1 = -1;	break;
		}
		/* ADD, AND, OR, SUB */
		if ((ix1 == 0) || ((ix1 == 1) || (ix1 == 8) || (ix1 == 9))) {
			ix2 = (sz == A_L) ? 1 : 0;
			ix3 = (op & 0x0100) ? 1: 2;
			if ((sz == A_L) && (op & 0x0100)) {
				/* Extra Cycles For Dn,Dn Or #,Dn */
				if (((opcode & 070) == 0) || ((opcode & 077) == 074)) {
					cycles += 2;
				}
			}
			cycles += (int) D4[ix1][ix2][ix3];
			ix1 = eamlo(opcode);
			cycles += (int) D1[ix1][ix2];
		} else
		/* EOR */
		if (ix1 == 5) {
			ix2 = (sz == A_L) ? 1 : 0; 
			cycles += (int) D4[ix1][ix2][2];
			ix1 = eamlo(opcode);
			cycles += (int) D1[ix1][ix2];
		} else {
			/* Alternate Forms - ADDI, ANDI, EORI, ORI, SUBI */
			/* Alternate Forms - ADDQ, SUBQ */
			switch(op & 0xFF00) {
			case 0x0600:	ix1 = 0;	break;	/* ADDI */
			case 0x5000:	ix1 = 1;	break;	/* ADDQ */
			case 0x0200:	ix1 = 2;	break;	/* ANDI */
			case 0x0A00:	ix1 = 4;	break;	/* EORI */
			case 0x0000:	ix1 = 6;	break;	/* ORI  */
			case 0x0400:	ix1 = 7;	break;	/* SUBI */
			case 0x5100:	ix1 = 8;	break;	/* SUBQ */
			default:
				xerr('q', "Internal Cycles Error");
				break;
			}
			ixv = eamlo(opcode);
			ix2 = (sz == A_L) ? 1 : 0;
			switch(ixv) {
			case 0:		ix3 = 0;	break;
			case 1:		ix3 = 1;	break;
			default:	ix3 = 2;
				cycles += (int) D1[ixv][ix2];	break;
			}
			cycles += (int) D5[ix1][ix2][ix3];
		}
		break;

	case S_TYP3:	/* ADDA, CMPA, SUBA */
		switch(op & 0xF000) {
		case 0xD000:	ix1 = 0;	break;	/* ADDA */
		case 0xB000:	ix1 = 2;	break;	/* CMPA */
		case 0x9000:	ix1 = 9;	break;	/* SUBA */
		default:	break;
		}
		ix2 = (sz == A_L) ? 1 : 0;
		ix3 = 0;
		if (sz == A_L) {
			/* Extra Cycles For <ea>,An */
			if (((opcode & 070) == 000) || ((opcode & 070) == 010) || ((opcode & 077) == 074)) {
				cycles += 2;
			}
		}
		cycles += (int) D4[ix1][ix2][ix3];
		ix1 = eamlo(opcode);
		cycles += (int) D1[ix1][ix2];
		break;

	case S_TYP4:	/* ADDI, ANDI, CMPI, EORI, ORI, SUBI */
	case S_TYP5:	/* ADDQ, SUBQ */
	case S_MOVEQ:	/* MOVEQ */
		switch(op & 0xFF00) {
		case 0x0600:	ix1 = 0;	break;	/* ADDI */
		case 0x5000:	ix1 = 1;	break;	/* ADDQ */
		case 0x0200:	ix1 = 2;	break;	/* ANDI */
		case 0x0C00:	ix1 = 3;	break;	/* CMPI */
		case 0x0A00:	ix1 = 4;	break;	/* EORI */
		case 0x7000:	ix1 = 5;	break;	/* MOVEQ */
		case 0x0000:	ix1 = 6;	break;	/* ORI */
		case 0x0400:	ix1 = 7;	break;	/* SUBI */
		case 0x5100:	ix1 = 8;	break;	/* SUBQ */
		default:	break;
		}
		if (ix1 == 5 ) {
			cycles += (int) D5[ix1][1][0];
		} else {
			ixv = eamlo(opcode);
			ix2 = (sz == A_L) ? 1 : 0;
			switch(ixv) {
			case 0:		ix3 = 0;	break;
			case 1:		ix3 = 1;	break;
			default:	ix3 = 2;
				cycles += (int) D1[ixv][ix2];	break;
			}
			cycles += (int) D5[ix1][ix2][ix3];
		}
		break;

	case S_TYP6:	/* CHK, CMP, DIVS, DIVU, MULS, MULU */
		if (op == 0x4180) {	/* CHK */
			ix1 = eamlo(opcode);
			ix2 = 0;
			cycles += (int) D12[1][ix2] + (int) D1[ix1][ix2];
			break;
		}
		switch(op & 0xFF00) {
		case 0xB000:	ix1 = 2;	break;	/* CMP */
		case 0x8100:	ix1 = 3;	break;	/* DIVS */
		case 0x8000:	ix1 = 4;	break;	/* DIVU */
		case 0xC100:	ix1 = 6;	break;	/* MULS */
		case 0xC000:	ix1 = 7;	break;	/* MULU */
		default:	break;
		}
		ix2 = (sz == A_L) ? 1 : 0;
		cycles += (int) D4[ix1][ix2][1] + (int) D1[eamlo(opcode)][ix2];
		break;

	case S_TYP7:	/* CLR, NEG, NEGX, NOT, TST */
	case S_TYP9:	/* NBCD, TAS */
	case S_SCC:	/* SCC */
		/* Effective Address Mode Cycles */
		ix1 = eamlo(opcode);
		ix2 = (sz == A_L) ? 1 : 0;
		cycles += (int) D1[ix1][ix2];
		/* Instruction Cycles */
		ix3 = (ix1 >= 2) ? 1 : 0;
		switch(op & 0xFF00) {
		case 0x4200:	ix1 = 0;	break;	/* CLR */
		case 0x4800:	ix1 = 1;	break;	/* NBCD */
 	        case 0x4400:	ix1 = 2;	break;	/* NEG */
		case 0x4000:	ix1 = 3;	break;	/* NEGX */
		case 0x4600:	ix1 = 4;	break;	/* NOT */
		case 0x4A00:
			if (op == 0x4AC0) {
				ix1 = 6;	/* TAS */
			} else {
				ix1 = 7;	/* TST */
			}
			break;
		default:	ix1 = 5;	break;	/* SCC */
		}
		cycles += (int) D6[ix1][ix2][ix3];
		break;

	case S_MOVEM:	/* MOVEM */
	case S_TYP8:	/* JMP, JSR, LEA, PEA */
		switch(op) {
		case 0x4EC0:	ix1 = 0;	break;	/* JMP */
		case 0x4E80:	ix1 = 1;	break;	/* JSR */
		case 0x41C0:	ix1 = 2;	break;	/* LEA */
		case 0x4840:	ix1 = 3;	break;	/* PEA */
		default:	ix1 = 4;		/* MOVEM */
			ix1 += (opcode & 0x0400) ? 0 : 1;
			cycles += (sz == A_L) ? rc * 8 : rc * 4;
			break;
		}
		ix2 = eamlo(opcode);
		cycles += (int) D10[ix1][ix2];
		break;

	case S_SHFT:	/* ASL, ASR, LSL, LSR, ROL, ROR, ROXL, ROXL */
		ix1 = 0;
		if ((opcode & 0xC0) == 0xC0) {
			ix2 = 0;
			ix3 = 1;
		} else {
			ix2 = (sz == A_L) ? 1 : 0;
			ix3 = 0;
			cycles += rc * 2;
		}
		cycles += (int) D7[ix1][ix2][ix3];
		break;

	case S_BCC:	/* Bcc */
	case S_DBCC:	/* DBcc */
		if ((op & 0xFF00) == 0x6000) {	/* BRA */
			ix1 = 1;
		} else
		if ((op & 0xFF00) == 0x6100) {	/* BSR */
			ix1 = 2;
		} else
		if ((op & 0xF000) == 0x6000) {	/* BCC */
			ix1 = 0;
		} else
		if ((op & 0xF000) == 0x5000) {	/* DBCC */
			ix1 = 3;
		} else {
			xerr('q', "Internal Cycles Error");
		}
		if (sz == B_A) {
			ix2 = (opcode & 0x00FF) ? 0 : 1;
		} else {
			ix2 = (sz == B_S) ? 0 : 1;
		}
		cycles += (int) D9[ix1][ix2];
		break;

	case S_BIT:	/* BCHG, BCLR, BSET, BTST */
		if ((op & 0xFF00) == 0x0100) {
			switch(op) {
			case 0x0140:	ix1 = 0;	break;	/* BCHG */
			case 0x0180:	ix1 = 1;	break;	/* BCLR */
			case 0x01C0:	ix1 = 2;	break;	/* BSET */
			case 0x0100:	ix1 = 3;	break;	/* BTST */
			default:	break;
			}
			ix3 = 0;
		} else
		if ((opcode & 0xFF00) == 0x0800) {
			switch(opcode & 0xFFC0) {
			case 0x0840:	ix1 = 0;	break;	/* BCHG */
			case 0x0880:	ix1 = 1;	break;	/* BCLR */
			case 0x08C0:	ix1 = 2;	break;	/* BSET */
			case 0x0800:	ix1 = 3;	break;	/* BTST */
			default:	break;
			}
			ix3 = 1;
		} else {
			xerr('q', "Internal Cycles Error");
		}
		ixv =  eamlo(opcode);
		ix2 = (ixv < 1) ? 1 : 0;
		cycles +=  (int) D8[ix1][ix2][ix3];
		cycles += (int) D1[ixv][0];
		break;

	case S_MOVE:	/* MOVE */
		if ((opcode & 0xF000) == 0x4000) {
			switch(opcode & 0xFFC0) {
			case 0x42C0:	ix1 = 8;	break;	/* MOVE from CCR */
			case 0x44C0:	ix1 = 9;	break;	/* MOVE to CCR */
			case 0x40C0:	ix1 = 10;	break;	/* MOVE from SR */
			case 0x46C0:	ix1 = 11;	break;	/* MOVE to SR */
			case 0x4E40:				/* MOVE from/to USP */
				ix1 = (opcode & 0x0008) ? 12 : 13;
				break;
			default:
				xerr('q', "Internal Cycles Error");
				break;
			}
			if ((ix1 == 12) || (ix1 == 13)) {
				cycles += (int) D12[ix1][0];
				break;
			}
			ixv = eamlo(opcode);
			ix2 = (ixv > 1) ? 1 : 0;
			cycles +=  (int) D12[ix1][ix2];
			cycles += (int) D1[ixv][0];
			break;
		}
		switch(op & 0xC000) {
		case 0x0000:	/* MOVE */
			ix1 = eamlo(opcode);
			ix2 = eamhi(opcode);
			if (sz == A_L) {
				cycles += (int) D3[ix1][ix2];
			} else {
				cycles += (int) D2[ix1][ix2];
			}
			break;
		case 0x8000:	/* MOVEQ */
			cycles += (int) D5[5][1][0];
			break;
		default:
			xerr('q', "Internal Cycles Error");
			break;
		}
		break;

	case S_MOVEA:	/* MOVEA */
		ix1 = eamlo(opcode);
		cycles += (int) (sz == A_L) ? D3[ix1][1] : D2[ix1][1];
		break;

	case S_MOVEC:	/* MOVEC (68010) */
		cycles += D12[25][(int) opcode & 1];
		break;

	case S_MOVEP:	/* MOVEP */
		ix1 = 0;
		ix2 = (opcode & 0x40) ? 1 : 0;
		ix3 = (opcode & 0x80) ? 0 : 1;
		cycles += (int) D13[ix1][ix2][ix3];
		break;

	case S_MOVES:	/* MOVES Rn,<ea>  Or  MOVES <ea>,Rn (68010) */
		ix3 = eamlo(opcode);
		switch(aindx) {
		case 0:	ix1 = 0;    ix2 = ix3;	break;	/* Dn,<ea> */
		case 1:	ix1 = 1;    ix2 = ix3;	break;	/* An,<ea> */
		case 2: ix1 = ix3;  ix2 = 0;	break;	/* <ea>,Dn */
		case 3: ix1 = ix3;  ix2 = 1;	break;	/* <ea>,An */
		default:
			xerr('q', "Internal Cycles Error");
			break;
		}
		if (sz == A_L) {
			cycles += (int) D3[ix1][ix2];
		} else {
			cycles += (int) D2[ix1][ix2];
		}
		break;

	case S_CMP:	/* CMP */
		switch(op & 0xFF00) {
		case 0xB000:	ix1 = 2;	break;	/* CMP */
		case 0x0C00:	ix1 = 3;	break;	/* CMPI */
		default:	xerr('q', "Internal Cycles Error");	break;
		}
		switch(ix1) {
		case 2:	/* CMP */
			ix2 = (sz == A_L) ? 1 : 0;
			cycles += (int) D4[ix1][ix2][1] + (int) D1[eamlo(opcode)][ix2];
			break;
		case 3:	/* CMPI */
			ix2 = (sz == A_L) ? 1 : 0;
			cycles += (int) D5[ix1][ix2][0];
			break;
		default:
			break;
		}
		break;

	case S_EXG:	cycles += (int) D12[4][0];	break;	/* EXG */

	case S_EXT:	cycles += (int) D12[5][0];	break;	/* EXT */

	case S_LINK:	cycles += (int) D12[7][0];	break;	/* LINK */

	case S_STOP:
		switch(op) {
		case 0x4E72:	cycles += (int) D12[19][0];	break;	/* STOP */
		case 0x4E74:	cycles += (int) D12[24][0];	break;	/* RTD (68010) */
		default:	break;
		}
		break;

	case S_SWAP:	cycles += (int) D12[20][0];	break;	/* SWAP */

	case S_TRAP:	cycles += (int) D12[21][0];	break;	/* TRAP */

	case S_UNLK:	cycles += (int) D12[23][0];	break;	/* UNLK */
		
	case S_INH:	/* See Table D-12 */
		switch(op) {
		case 0x4AFC:	cycles += (int) D12[6][0];	break;	/* ILLEGAL */
		case 0x4E71:	cycles += (int) D12[14][0];	break;	/* NOP */
		case 0x4E70:	cycles += (int) D12[15][0];	break;	/* RESET */
		case 0x4E73:	cycles += (int) D12[16][0];	break;	/* RTE */
		case 0x4E77:	cycles += (int) D12[17][0];	break;	/* RTR */
		case 0x4E75:	cycles += (int) D12[18][0];	break;	/* RTS */
		case 0x4E76:	cycles += (int) D12[22][0];	break;	/* TRAPV */
		default:	break;
		}
		break;

	case S_M68K:	/* Verification Of Addressing Modes */
		ix1 = eamlo(opcode);
		ix2 = (sz == A_L) ? 1 : 0;
		cycles += (int) D1[ix1][ix2];
		break;

	default:
		cycles = OPCY_ERR;
		break;
	}

	return(cycles);
}

/*
 *****-----*****-----*****-----*****-----*****-----*****-----*****
 *
 * End Of 68000 Instruction Addressing Mode MicroCycle Timing
 *
 *****-----*****-----*****-----*****-----*****-----*****-----*****
 */

/*
 * 68008 Instruction Addressing Mode MicroCycle Timing
 *   Taken from:
 *	The Motorola MC68000 Microprocessor Family
 *		By Thomas L. Harman and Barbara Lawson
 *		C 1985 Prentice Hall
 */

/* Table E1 Effective Address Times */
static unsigned char E1[12][3] = {
/*---*---* B  W  L */
/*---*---* 0  1  2 */
/*---*---* -  -  - */
	{  0, 0, 0 },	/* Dn */
	{  0, 0, 0 },	/* An */
	{  4, 8,16 },	/* (An) */
	{  4, 8,16 },	/* (An)+ */
	{  6,10,18 },	/* -(An) */
	{ 12,16,24 },	/* d(An) */
	{ 14,18,26 },	/* d(An,Xi) */
	{ 12,16,24 },	/* xxx.W */
	{ 20,24,32 },	/* xxx.L */
	{ 12,16,24 },	/* d(PC) */
	{ 14,18,26 },	/* d(PC,Xi) */
	{  8, 8,16 }	/* # */
};



/* Table E2 MOVE Byte Times */
static unsigned char E2[12][12] = {
/*---*---* 0  1  2  3  4  5  6  7  8  9 10 11 */
/*---*---* -  -  -  -  -  -  -  -  -  -  -  - */
	{  8, 8,12,12,12,20,22,20,28, 0, 0, 0 },	/* Dn */
	{  8, 8,12,12,12,20,22,20,28, 0, 0, 0 },	/* An */
	{ 12,12,16,16,16,24,26,24,32, 0, 0, 0 },	/* (An) */
	{ 12,12,16,16,16,24,26,24,32, 0, 0, 0 },	/* (An)+ */
	{ 14,14,18,18,18,26,28,28,34, 0, 0, 0 },	/* -(An) */
	{ 20,20,24,24,24,32,34,32,40, 0, 0, 0 },	/* d(An) */
	{ 22,22,28,28,26,34,38,34,42, 0, 0, 0 },	/* d(An,Xi) */
	{ 20,20,24,24,24,32,34,32,40, 0, 0, 0 },	/* xxx.W */
	{ 28,28,32,32,32,40,42,40,48, 0, 0, 0 },	/* xxx.L */
	{ 20,20,24,24,24,32,34,32,40, 0, 0, 0 },	/* d(PC) */
	{ 22,22,26,26,26,34,36,34,42, 0, 0, 0 },	/* d(PC,Xi) */
	{ 16,16,20,20,20,28,20,28,36, 0, 0, 0 }		/* # */
};

/* Table E3 MOVE Word Times */
static unsigned char E3[12][12] = {
/*---*---* 0  1  2  3  4  5  6  7  8  9 10 11 */
/*---*---* -  -  -  -  -  -  -  -  -  -  -  - */
	{  8, 8,16,16,16,24,26,20,32, 0, 0, 0 },	/* Dn */
	{  8, 8,16,16,16,24,26,20,32, 0, 0, 0 },	/* An */
	{ 16,16,24,24,24,32,34,32,40, 0, 0, 0 },	/* (An) */
	{ 16,16,24,24,24,32,34,32,40, 0, 0, 0 },	/* (An)+ */
	{ 18,18,26,26,26,34,32,34,42, 0, 0, 0 },	/* -(An) */
	{ 24,24,32,32,32,40,42,40,48, 0, 0, 0 },	/* d(An) */
	{ 26,26,34,34,24,42,44,42,50, 0, 0, 0 },	/* d(An,Xi) */
	{ 24,24,32,32,32,40,42,40,48, 0, 0, 0 },	/* xxx.W */
	{ 32,32,40,40,40,48,50,48,56, 0, 0, 0 },	/* xxx.L */
	{ 24,24,32,32,32,40,42,40,48, 0, 0, 0 },	/* d(PC) */
	{ 26,26,34,34,34,42,44,42,50, 0, 0, 0 },	/* d(PC,Xi) */
	{ 16,16,24,24,24,32,34,32,40, 0, 0, 0 }		/* # */
};

/* Table E4 MOVE Long Times */
static unsigned char E4[12][12] = {
/*---*---* 0  1  2  3  4  5  6  7  8  9 10 11 */
/*---*---* -  -  -  -  -  -  -  -  -  -  -  - */
	{  8, 8,24,24,24,32,34,32,40, 0, 0, 0 },	/* Dn */
	{  8, 8,24,24,24,32,34,32,40, 0, 0, 0 },	/* An */
	{ 24,24,40,40,40,48,50,48,56, 0, 0, 0 },	/* (An) */
	{ 24,24,40,40,40,48,50,48,56, 0, 0, 0 },	/* (An)+ */
	{ 26,26,42,42,42,50,52,50,58, 0, 0, 0 },	/* -(An) */
	{ 32,32,48,48,48,56,58,56,64, 0, 0, 0 },	/* d(An) */
	{ 34,43,50,50,50,58,60,58,66, 0, 0, 0 },	/* d(An,Xi) */
	{ 32,32,48,48,48,56,58,56,64, 0, 0, 0 },	/* xxx.W */
	{ 40,40,56,56,56,64,66,54,72, 0, 0, 0 },	/* xxx.L */
	{ 32,32,48,48,48,56,58,56,64, 0, 0, 0 },	/* d(PC) */
	{ 34,34,50,50,50,58,60,58,66, 0, 0, 0 },	/* d(PC,Xi) */
	{ 24,24,40,40,40,48,50,48,56, 0, 0, 0 }		/* # */
};

/* Table E5 Standard Execution Times */
static unsigned char E5[10][3][3] = {
/*---*---* An Dn M         An Dn M         An Dn M  */
/*---*---* 0  1  2         0  1  2         0  1  2  */
/*---*---* -  -  -         -  -  -         -  -  -  */
      {	{  0, 8,12 },	{ 12, 8,16 },	{ 10,10,24 } },	/* ADD */
      {	{  0, 8,12 },	{  0, 8,16 },	{  0,10,24 } },	/* AND */
      {	{  0, 8, 0 },	{ 10, 8, 0 },	{ 10,10, 0 } },	/* CMP */
      {	{  0, 0, 0 },	{  0,162,0 },	{  0, 0, 0 } },	/* DIVS */
      {	{  0, 0, 0 },	{  0,144,0 },	{  0, 0, 0 } },	/* DIVU */
      {	{  0, 8,12 },	{  0, 8,16 },	{  0,12,24 } },	/* EOR */
      {	{  0, 0, 0 },	{  0,74, 0 },	{  0, 0, 0 } },	/* MULS */
      {	{  0, 0, 0 },	{  0,74, 0 },	{  0, 0, 0 } },	/* MULU */
      {	{  0, 8,12 },	{  0, 8,16 },	{  0,10,24 } },	/* OR */
      {	{  0, 8,12 },	{ 12, 8,16 },	{ 10,10,24 } }	/* SUB */
};

/* Table E6 Immediate Execution Times */
static unsigned char E6[9][3][3] = {
/*---*---* Dn An M         Dn An M         Dn An M  */
/*---*---* 0  1  2         0  1  2         0  1  2  */
/*---*---* -  -  -         -  -  -         -  -  -  */
      {	{ 16, 0,20 },	{ 16, 0,24 },	{ 28, 0,40 } },	/* ADDI */
      {	{  8, 0,12 },	{  8,12,16 },	{ 12,12,24 } },	/* ADDQ */
      {	{ 16, 0,20 },	{ 16, 0,24 },	{ 28, 0,40 } },	/* ANDI */
      {	{ 16, 0,16 },	{ 16, 0,16 },	{ 26, 0,24 } },	/* CMPI */
      {	{ 16, 0,20 },	{ 16, 0,24 },	{ 28, 0,40 } },	/* EORI */
      {	{  0, 0, 0 },	{  0, 0, 0 },	{  8, 0, 0 } },	/* MOVEQ */
      {	{ 16, 0,20 },	{ 16, 0,24 },	{ 28, 0,40 } },	/* ORI */
      {	{ 16, 0,12 },	{ 16, 0,16 },	{ 28, 0,24 } },	/* SUBI */
      {	{  8, 0,20 },	{  8,12,24 },	{ 12,12,40 } }	/* SUBQ */
};

/* Table E7 Single Operand Execution Times */
static unsigned char E7[8][3][2] = {
/*---*---* R  M            R  M            R  M     */
/*---*---* 0  1            0  1            0  1     */
/*---*---* -  -            -  -            -  -     */
      {	{  8,12 },	{  8,16 },	{ 10,24 } },	/* CLR */
      {	{ 10,12 },	{  0, 0 },	{  0, 0 } },	/* NBCD */
      {	{  8,12 },	{  8,16 },	{ 10,24 } },	/* NEG */
      {	{  8,12 },	{  8,16 },	{ 10,24 } },	/* NEGX */
      {	{  8,12 },	{  8,16 },	{ 10,24 } },	/* NOT */
      {	{ 10,12 },	{  0, 0 },	{  0, 0 } },	/* SCC */
      {	{  8,14 },	{  0, 0 },	{  0, 0 } },	/* TAS */
      {	{  8, 8 },	{  8, 8 },	{  8, 8 } }	/* TST */
};

/* Table E8 Shift/Rotate Execution Times */
static unsigned char E8[1][3][2] = {
/*---*---* R  M            R  M            R  M     */
/*---*---* 0  1            0  1            0  1     */
/*---*---* -  -            -  -            -  -     */
      {	{ 10, 0 },	{ 10,16 },	{ 12, 0 } }	/* ASR,ASL,LSR,LSL,ROR,ROL,ROXR,ROXL */
};

/* Table E9 Bit Manipulation Execution Times */
static unsigned char E9[4][2][2] = {
/*---*---* BYTE            LONG     */
/*---*---* 0  1            0  1     */
/*---*---* -  -            -  -     */
      {	{ 12,20 },	{ 12,20 } },	/* BCHG */
      {	{ 12,20 },	{ 14,22 } },	/* BCLR */
      {	{ 12,20 },	{ 12,20 } },	/* BSET */
      {	{  8,16 },	{ 10,18 } }	/* BTST */
};

/* Table E10 Conditional Execution Times */
static unsigned char E10[4][2] = {
/*---*---* B  W  */
/*---*---* 0  1  */
/*---*---* -  -  */
      	{ 18,20 },	/* BCC */
      	{ 18,18 },	/* BRA */
      	{ 34,34 },	/* BSR */
      	{ 26,26 }	/* DBCC */
};

/* Table E11 JMP, JSR, LEA, PEA, and MOVEM Instruction Times */
static unsigned char E11[6][12] = {
/*---*---* 0  1  2  3  4  5  6  7  8  9 10 11 */
/*---*---* -  -  -  -  -  -  -  -  -  -  -  - */
	{  0, 0,16, 0, 0,18,22,18,24,18,22, 0 },	/* JMP */
	{  0, 0,32, 0, 0,34,38,34,40,34,38, 0 },	/* JSR */
	{  0, 0, 8, 0, 0,16,20,16,24,16,20, 0 },	/* LEA */
	{  0, 0,24, 0, 0,32,36,32,40,32,36, 0 },	/* PEA */
	{  0, 0,24,24, 0,32,34,32,40, 0, 0, 0 },	/* MOVEM M->R */
	{  0, 0,18, 0,16,24,26,24,32, 0, 0, 0 },	/* MOVEM R->M */
};

/* Table E12 Multiprecision Execution Times */
static unsigned char E12[5][3][2] = {
/*---*---* DN M            DN M            DN M     */
/*---*---* 0  1            0  1            0  1     */
/*---*---* -  -            -  -            -  -     */
      {	{  8,22 },	{  8,50 },	{ 12,58 } },	/* ADDX */
      {	{  0,16 },	{  0,24 },	{  0,40 } },	/* CMPM */
      {	{  8,22 },	{  8,50 },	{ 12,58 } },	/* SUBX */
      {	{  10,20 },	{  0, 0 },	{  0, 0 } },	/* ABCD */
      {	{  10,20 },	{  0, 0 },	{  0, 0 } }	/* SBCD */
};

/* Table E13 Miscellaneous Execution Times */
static unsigned char E13[24][2] = {
/*---*---* 0  1  */
/*---*---* -  -  */
      	{ 32,32 },	/* (0) ANDI [CCR,SR] */
      	{ 68, 0 },	/* (1) CHK */
      	{ 32,32 },	/* (2) EORI [CCR,SR] */
      	{ 32,32 },	/* (3) ORI  [CCR,SR] */
      	{ 10, 0 },	/* (4) EXG */
      	{  8, 8 },	/* (5) EXT */
      	{ 34, 0 },	/* (6) ILLEGAL */
      	{ 32, 0 },	/* (7) LINK */
      	{ 10,16 },	/* (8) MOVE from CCR [R,M] */
      	{ 18,18 },	/* (9) MOVE to  CCR [R,M] */
      	{ 10,16 },	/* (10) MOVE from SR [R,M] */
      	{ 18,18 },	/* (11) MOVE to   SR [R,M] */
      	{  8, 0 },	/* (12) MOVE from USP */
      	{  8, 0 },	/* (13) MOVE to USP */
      	{  8, 0 },	/* (14) NOP */
      	{132, 0 },	/* (15) RESET */
      	{ 40, 0 },	/* (16) RTE */
      	{ 40, 0 },	/* (17) RTR */
      	{ 32, 0 },	/* (18) RTS */
      	{  4, 0 },	/* (19) STOP */
      	{  8, 0 },	/* (20) SWAP */
      	{ 62, 0 },	/* (21) TRAP */
      	{ 66, 0 },	/* (22) TRAPV */
      	{ 24, 0 }	/* (23) UNLK */
};

/* Table E14 MOVE Peripheral Execution Times */
static unsigned char E14[1][2][2] = {
/*---*---* Word            Long     */
/*---*---* 0  1            0  1     */
/*---*---* -  -            -  -     */
      {	{ 24,24 },	{ 32,32 } }	/* MOVEP */
};

/*
 * Determine Machine Cycles
 */
int
mc68008cycles(mp, opcode, rc, cycles)
struct mne *mp;
a_uint opcode;
int rc;
int cycles;
{
	a_uint op;
	int rf, sz;
	int ix1, ix2, ix3, ixv;

	ix1 = ix2 = ix3 = ixv = 0;

	op = mp->m_valu;
	rf = mp->m_type;
	sz = mp->m_flag & 0x03;

	switch (rf) {

	case S_CMPM:	/* CMPM */
	case S_TYP1:	/* ABCD, SBCD, ADDX, SUBX */
		switch(op & 0xFF00) {
		case 0xD100:	ix1 = 0;	break;	/* ADDX */
		case 0xB100:	ix1 = 1;	break;	/* CMPM */
		case 0x9100:	ix1 = 2;	break;	/* SUBX */
		case 0xC100:	ix1 = 3;	break;	/* ABCD */
		case 0x8100:	ix1 = 4;	break;	/* SBCD */
		default:	break;
		}
		ix2 = sz;
		ix3 = (opcode & 8) ? 1 : 0;
		cycles = (int) E12[ix1][ix2][ix3];
		break;

	case S_EOR:	/* EOR */
	case S_TYP2:	/* ADD, AND, OR, SUB */
		switch(op & 0xFF00) {
		case 0xD000:	ix1 = 0;	break;	/* ADD */
		case 0xC000:	ix1 = 1;	break;	/* AND */
		case 0xB100:	ix1 = 5;	break;	/* EOR */
		case 0x8000:	ix1 = 8;	break;	/* OR */
		case 0x9000:	ix1 = 9;	break;	/* SUB */
		default:	ix1 = -1;	break;
		}
		/* ADD, AND, OR, SUB */
		if ((ix1 == 0) || ((ix1 == 1) || (ix1 == 8) || (ix1 == 9))) {
			ix2 = sz;
			ix3 = (op & 0x0100) ? 1: 2;
			if ((sz == A_L) && (op & 0x0100)) {
				/* Extra Cycles For Dn,Dn Or #,Dn */
				if (((opcode & 070) == 0) || ((opcode & 077) == 074)) {
					cycles = 2;
				}
			}
			cycles += (int) E5[ix1][ix2][ix3];
			ix1 = eamlo(opcode);
			cycles += (int) E1[ix1][ix2];
		} else
		/* EOR */
		if (ix1 == 5) {
			ix2 = sz; 
			cycles = (int) E5[ix1][ix2][2];
			ix1 = eamlo(opcode);
			cycles += (int) E1[ix1][ix2];
		} else {
			/* Alternate Forms - ADDI, ANDI, EORI, ORI, SUBI */
			/* Alternate Forms - ADDQ, SUBQ */
			switch(op & 0xFF00) {
			case 0x0600:	ix1 = 0;	break;	/* ADDI */
			case 0x5000:	ix1 = 1;	break;	/* ADDQ */
			case 0x0200:	ix1 = 2;	break;	/* ANDI */
			case 0x0A00:	ix1 = 4;	break;	/* EORI */
			case 0x0000:	ix1 = 6;	break;	/* ORI  */
			case 0x0400:	ix1 = 7;	break;	/* SUBI */
			case 0x5100:	ix1 = 8;	break;	/* SUBQ */
			default:
				xerr('q', "Internal Cycles Error");
				break;
			}
			ixv = eamlo(opcode);
			ix2 = sz;
			switch(ixv) {
			case 0:		ix3 = 0;	break;
			case 1:		ix3 = 1;	break;
			default:	ix3 = 2;
				cycles = (int) E1[ixv][ix2];	break;
			}
			cycles += (int) E6[ix1][ix2][ix3];
		}
		break;

	case S_TYP3:	/* ADDA, CMPA, SUBA */
		switch(op & 0xF000) {
		case 0xD000:	ix1 = 0;	break;	/* ADDA */
		case 0xB000:	ix1 = 2;	break;	/* CMPA */
		case 0x9000:	ix1 = 9;	break;	/* SUBA */
		default:	break;
		}
		ix2 = sz;
		ix3 = 0;
		if (sz == A_L) {
			/* Extra Cycles For <ea>,An */
			if (((opcode & 070) == 000) || ((opcode & 070) == 010) || ((opcode & 077) == 074)) {
				cycles = 2;
			}
		}
		cycles += (int) E5[ix1][ix2][ix3];
		ix1 = eamlo(opcode);
		cycles += (int) E1[ix1][ix2];
		break;

	case S_TYP4:	/* ADDI, ANDI, CMPI, EORI, ORI, SUBI */
	case S_TYP5:	/* ADDQ, SUBQ */
	case S_MOVEQ:	/* MOVEQ */
		switch(op & 0xFF00) {
		case 0x0600:	ix1 = 0;	break;	/* ADDI */
		case 0x5000:	ix1 = 1;	break;	/* ADDQ */
		case 0x0200:	ix1 = 2;	break;	/* ANDI */
		case 0x0C00:	ix1 = 3;	break;	/* CMPI */
		case 0x0A00:	ix1 = 4;	break;	/* EORI */
		case 0x7000:	ix1 = 5;	break;	/* MOVEQ */
		case 0x0000:	ix1 = 6;	break;	/* ORI */
		case 0x0400:	ix1 = 7;	break;	/* SUBI */
		case 0x5100:	ix1 = 8;	break;	/* SUBQ */
		default:	break;
		}
		if (ix1 == 5 ) {
			cycles = (int) E6[ix1][2][0];
		} else {
			ixv = eamlo(opcode);
			ix2 = sz;
			switch(ixv) {
			case 0:		ix3 = 0;	break;
			case 1:		ix3 = 1;	break;
			default:	ix3 = 2;
				cycles = (int) E1[ixv][ix2];	break;
			}
			cycles += (int) E6[ix1][ix2][ix3];
		}
		break;

	case S_TYP6:	/* CHK, CMP, DIVS, DIVU, MULS, MULU */
		if (op == 0x4180) {	/* CHK */
			ix1 = eamlo(opcode);
			ix2 = 0;
			cycles = (int) E13[1][ix2] + (int) E1[ix1][ix2];
			break;
		}
		switch(op & 0xFF00) {
		case 0xB000:	ix1 = 2;	break;	/* CMP */
		case 0x8100:	ix1 = 3;	break;	/* DIVS */
		case 0x8000:	ix1 = 4;	break;	/* DIVU */
		case 0xC100:	ix1 = 6;	break;	/* MULS */
		case 0xC000:	ix1 = 7;	break;	/* MULU */
		default:	break;
		}
		ix2 = sz;
		cycles = (int) E5[ix1][ix2][1] + (int) E1[eamlo(opcode)][ix2];
		break;

	case S_TYP7:	/* CLR, NEG, NEGX, NOT, TST */
	case S_TYP9:	/* NBCD, TAS */
	case S_SCC:	/* SCC */
		/* Effective Address Mode Cycles */
		ix1 = eamlo(opcode);
		ix2 = sz;
		cycles = (int) E1[ix1][ix2];
		/* Instruction Cycles */
		ix3 = (ix1 >= 2) ? 1 : 0;
		switch(op & 0xFF00) {
		case 0x4200:	ix1 = 0;	break;	/* CLR */
		case 0x4800:	ix1 = 1;	break;	/* NBCD */
 	        case 0x4400:	ix1 = 2;	break;	/* NEG */
		case 0x4000:	ix1 = 3;	break;	/* NEGX */
		case 0x4600:	ix1 = 4;	break;	/* NOT */
		case 0x4A00:
			if (op == 0x4AC0) {
				ix1 = 6;	/* TAS */
			} else {
				ix1 = 7;	/* TST */
			}
			break;
		default:	ix1 = 5;	break;	/* SCC */
		}
		cycles += (int) E7[ix1][ix2][ix3];
		break;

	case S_MOVEM:	/* MOVEM */
	case S_TYP8:	/* JMP, JSR, LEA, PEA */
		switch(op) {
		case 0x4EC0:	ix1 = 0;	break;	/* JMP */
		case 0x4E80:	ix1 = 1;	break;	/* JSR */
		case 0x41C0:	ix1 = 2;	break;	/* LEA */
		case 0x4840:	ix1 = 3;	break;	/* PEA */
		default:	ix1 = 4;		/* MOVEM */
			ix1 += (opcode & 0x0400) ? 0 : 1;
			cycles = (sz == A_L) ? rc * 8 : rc * 4;
			break;
		}
		ix2 = eamlo(opcode);
		cycles += (int) E11[ix1][ix2];
		break;

	case S_SHFT:	/* ASL, ASR, LSL, LSR, ROL, ROR, ROXL, ROXL */
		ix1 = 0;
		if ((opcode & 0xC0) == 0xC0) {
			ix2 = 1;
			ix3 = 1;
		} else {
			ix2 = sz;
			ix3 = 0;
			cycles = rc * 2;
		}
		cycles += (int) E8[ix1][ix2][ix3];
		break;

	case S_BCC:	/* Bcc */
	case S_DBCC:	/* DBcc */
		if ((op & 0xFF00) == 0x6000) {	/* BRA */
			ix1 = 1;
		} else
		if ((op & 0xFF00) == 0x6100) {	/* BSR */
			ix1 = 2;
		} else
		if ((op & 0xF000) == 0x6000) {	/* BCC */
			ix1 = 0;
		} else
		if ((op & 0xF000) == 0x5000) {	/* DBCC */
			ix1 = 3;
		} else {
			xerr('q', "Internal Cycles Error");
		}
		if (sz == B_A) {
			ix2 = (opcode & 0x00FF) ? 0 : 1;
		} else {
			ix2 = (sz == B_S) ? 0 : 1;
		}
		cycles = (int) E10[ix1][ix2];
		break;

	case S_BIT:	/* BCHG, BCLR, BSET, BTST */
		if ((op & 0xFF00) == 0x0100) {
			switch(op) {
			case 0x0140:	ix1 = 0;	break;	/* BCHG */
			case 0x0180:	ix1 = 1;	break;	/* BCLR */
			case 0x01C0:	ix1 = 2;	break;	/* BSET */
			case 0x0100:	ix1 = 3;	break;	/* BTST */
			default:	break;
			}
			ix3 = 0;
		} else
		if ((opcode & 0xFF00) == 0x0800) {
			switch(opcode & 0xFFC0) {
			case 0x0840:	ix1 = 0;	break;	/* BCHG */
			case 0x0880:	ix1 = 1;	break;	/* BCLR */
			case 0x08C0:	ix1 = 2;	break;	/* BSET */
			case 0x0800:	ix1 = 3;	break;	/* BTST */
			default:	break;
			}
			ix3 = 1;
		} else {
			xerr('q', "Internal Cycles Error");
		}
		ixv =  eamlo(opcode);
		ix2 = (ixv < 1) ? 1 : 0;
		cycles =  (int) E9[ix1][ix2][ix3];
		cycles += (int) E1[ixv][0];
		break;

	case S_MOVE:	/* MOVE */
		if ((opcode & 0xF000) == 0x4000) {
			switch(opcode & 0xFFC0) {
			case 0x42C0:	ix1 = 8;	break;	/* MOVE from CCR */
			case 0x44C0:	ix1 = 9;	break;	/* MOVE to CCR */
			case 0x40C0:	ix1 = 10;	break;	/* MOVE from SR */
			case 0x46C0:	ix1 = 11;	break;	/* MOVE to SR */
			case 0x4E40:				/* MOVE from/to USP */
				ix1 = (opcode & 0x0008) ? 12 : 13;
				break;
			default:
				xerr('q', "Internal Cycles Error");
				break;
			}
			if ((ix1 == 12) || (ix1 == 13)) {
				cycles = E13[ix1][0];
				break;
			}
			ixv = eamlo(opcode);
			ix2 = (ixv > 1) ? 1 : 0;
			cycles =  E13[ix1][ix2];
			cycles += E1[ixv][0];
			break;
		}
		switch(op & 0xC000) {
		case 0x0000:	/* MOVE */
			ix1 = eamlo(opcode);
			ix2 = eamhi(opcode);
			switch(sz) {
			default:
			case A_L:	cycles = E4[ix1][ix2];	break;
			case A_W:	cycles = E3[ix1][ix2];	break;
			case A_B:	cycles = E2[ix1][ix2];	break;
			}
			break;
		case 0x8000:	/* MOVEQ */
			cycles = (int) E6[5][2][0];
			break;
		default:
			xerr('q', "Internal Cycles Error");
			break;
		}
		break;

	case S_MOVEA:	/* MOVEA */
		ix1 = eamlo(opcode);
		switch(sz) {
		default:
		case A_L:	cycles = E4[ix1][1];	break;
		case A_W:	cycles = E3[ix1][1];	break;
		case A_B:	cycles = E2[ix1][1];	break;
		}
		break;

	case S_MOVEC:	/* MOVEC (68010) */
		if (opcode & 1) {
			cycles = 10;
		} else {
			cycles = 12;
		}
		break;

	case S_MOVEP:	/* MOVEP */
		ix1 = 0;
		ix2 = (opcode & 0x40) ? 1 : 0;
		ix3 = (opcode & 0x80) ? 0 : 1;
		cycles = (int) E14[ix1][ix2][ix3];
		break;

	case S_MOVES:	/* MOVES Rn,<ea>  Or  MOVES <ea>,Rn */
		ix3 = eamlo(opcode);
		switch(aindx) {
		case 0:	ix1 = 0;    ix2 = ix3;	break;	/* Dn,<ea> */
		case 1:	ix1 = 1;    ix2 = ix3;	break;	/* An,<ea> */
		case 2: ix1 = ix3;  ix2 = 0;	break;	/* <ea>,Dn */
		case 3: ix1 = ix3;  ix2 = 1;	break;	/* <ea>,An */
		default:
			xerr('q', "Internal Cycles Error");
			break;
		}
		switch(sz) {
		default:
		case A_L:	cycles = E4[ix1][ix2];	break;
		case A_W:	cycles = E3[ix1][ix2];	break;
		case A_B:	cycles = E2[ix1][ix2];	break;
		}
		break;

	case S_CMP:	/* CMP */
		switch(op & 0xFF00) {
		case 0xB000:	ix1 = 2;	break;	/* CMP */
		case 0x0C00:	ix1 = 3;	break;	/* CMPI */
		default:	xerr('q', "Internal Cycles Error");	break;
		}
		switch(ix1) {
		case 2:	/* CMP */
			ix2 = sz;
			cycles = (int) E5[ix1][ix2][1] + (int) E1[eamlo(opcode)][ix2];
			break;
		case 3:	/* CMPI */
			ix2 = sz;
			cycles = (int) E6[ix1][ix2][0];
			break;
		default:
			break;
		}
		break;

	case S_EXG:	cycles = (int) E13[4][0];	break;	/* EXG */

	case S_EXT:	cycles = (int) E13[5][0];	break;	/* EXT */

	case S_LINK:	cycles = (int) E13[7][0];	break;	/* LINK */

	case S_STOP:	cycles = (int) E13[19][0];	break;	/* STOP */

	case S_SWAP:	cycles = (int) E13[20][0];	break;	/* SWAP */

	case S_TRAP:	cycles = (int) E13[21][0];	break;	/* TRAP */

	case S_UNLK:	cycles = (int) E13[23][0];	break;	/* UNLK */
		
	case S_INH:	/* See Table D-12 */
		switch(op) {
		case 0x4AFC:	cycles = (int) E13[6][0];	break;	/* ILLEGAL */
		case 0x4E71:	cycles = (int) E13[14][0];	break;	/* NOP */
		case 0x4E70:	cycles = (int) E13[15][0];	break;	/* RESET */
		case 0x4E73:	cycles = (int) E13[16][0];	break;	/* RTE */
		case 0x4E77:	cycles = (int) E13[17][0];	break;	/* RTR */
		case 0x4E75:	cycles = (int) E13[18][0];	break;	/* RTS */
		case 0x4E76:	cycles = (int) E13[22][0];	break;	/* TRAPV */
		default:	break;
		}
		break;

	case S_M68K:	/* Verification Of Addressing Modes */
		ix1 = eamlo(opcode);
		ix2 = sz;
		cycles = (int) E1[ix1][ix2];
		break;

	default:
		cycles = OPCY_ERR;
		break;
	}

	return(cycles);
}

/*
 *****-----*****-----*****-----*****-----*****-----*****-----*****
 *
 * End Of 68008 Instruction Addressing Mode MicroCycle Timing
 *
 *****-----*****-----*****-----*****-----*****-----*****-----*****
 */

/*
 * 68010 Instruction Addressing Mode MicroCycle Timing
 *   Taken from:
 *	The Motorola MC68000 Microprocessor Family
 *		By Thomas L. Harman and Barbara Lawson
 *		C 1985 Prentice Hall
 */

/* Table F1 Effective Address Times */
static unsigned char F1[12][2] = {
/*---*---* B  L */
/*---*---* 0  1 */
/*---*---* -  - */
	{  0, 0 },	/* Dn */
	{  0, 0 },	/* An */
	{  4, 8 },	/* (An) */
	{  4, 8 },	/* (An)+ */
	{  6,10 },	/* -(An) */
	{  8,12 },	/* d(An) */
	{ 10,14 },	/* d(An,Xi) */
	{  8,12 },	/* xxx.W */
	{ 12,16 },	/* xxx.L */
	{  8,12 },	/* d(PC) */
	{ 10,14 },	/* d(PC,Xi) */
	{  4, 8 }	/* # */
};



/* Table F2 MOVE Byte and Word Times */
static unsigned char F2[12][12] = {
/*---*---* 0  1  2  3  4  5  6  7  8  9 10 11 */
/*---*---* -  -  -  -  -  -  -  -  -  -  -  - */
	{  4, 4, 8, 8, 8,12,14,12,16, 0, 0, 0 },	/* Dn */
	{  4, 4, 8, 8, 8,12,14,12,16, 0, 0, 0 },	/* An */
	{  8, 8,12,12,12,16,18,16,20, 0, 0, 0 },	/* (An) */
	{  8, 8,12,12,12,16,18,16,20, 0, 0, 0 },	/* (An)+ */
	{ 10,10,14,14,14,18,20,18,22, 0, 0, 0 },	/* -(An) */
	{ 12,12,16,16,16,20,22,20,24, 0, 0, 0 },	/* d(An) */
	{ 14,14,18,18,18,22,24,22,26, 0, 0, 0 },	/* d(An,Xi) */
	{ 12,12,16,16,16,20,22,20,24, 0, 0, 0 },	/* xxx.W */
	{ 16,16,20,20,20,24,26,24,28, 0, 0, 0 },	/* xxx.L */
	{ 12,12,16,16,16,20,22,20,24, 0, 0, 0 },	/* d(PC) */
	{ 14,14,18,18,18,22,24,24,26, 0, 0, 0 },	/* d(PC,Xi) */
	{  8, 8,12,12,12,16,18,16,20, 0, 0, 0 }		/* # */
};

/* Table F4 MOVE Long Times */
static unsigned char F4[12][12] = {
/*---*---* 0  1  2  3  4  5  6  7  8  9 10 11 */
/*---*---* -  -  -  -  -  -  -  -  -  -  -  - */
	{  4, 4,12,12,14,16,18,16,20, 0, 0, 0 },	/* Dn */
	{  4, 4,12,12,14,16,18,16,20, 0, 0, 0 },	/* An */
	{ 12,12,20,20,20,24,26,24,28, 0, 0, 0 },	/* (An) */
	{ 12,12,20,20,20,24,26,24,28, 0, 0, 0 },	/* (An)+ */
	{ 14,14,22,22,22,26,28,26,30, 0, 0, 0 },	/* -(An) */
	{ 16,16,24,24,24,28,30,28,32, 0, 0, 0 },	/* d(An) */
	{ 18,18,26,26,26,30,32,30,34, 0, 0, 0 },	/* d(An,Xi) */
	{ 16,16,24,24,24,28,30,28,32, 0, 0, 0 },	/* xxx.W */
	{ 20,20,28,28,28,32,34,32,36, 0, 0, 0 },	/* xxx.L */
	{ 16,16,24,24,24,28,30,28,32, 0, 0, 0 },	/* d(PC) */
	{ 18,18,26,26,26,30,32,30,34, 0, 0, 0 },	/* d(PC,Xi) */
	{ 12,12,20,20,20,24,26,24,28, 0, 0, 0 }		/* # */
};

/* Table F6 Standard Execution Times */
static unsigned char F6[10][2][3] = {
/*---*---* An Dn M         An Dn M  */
/*---*---* 0  1  2         0  1  2  */
/*---*---* -  -  -         -  -  -  */
      {	{  8, 4, 8 },	{  6, 6,12 } },	/* ADD */
      {	{  0, 4, 8 },	{  0, 6,12 } },	/* AND */
      {	{  8, 4, 0 },	{  6, 6, 0 } },	/* CMP */
      {	{  0,122,0 },	{  0, 0, 0 } },	/* DIVS */
      {	{  0,108,0 },	{  0, 0, 0 } },	/* DIVU */
      {	{  0, 4, 8 },	{  0, 6,12 } },	/* EOR */
      {	{  0,42, 0 },	{  0, 0, 0 } },	/* MULS */
      {	{  0,40, 0 },	{  0, 0, 0 } },	/* MULU */
      {	{  0, 4, 8 },	{  0, 6,12 } },	/* OR */
      {	{  8, 4, 8 },	{  6, 6,12 } }	/* SUB */
};

/* Table F8 Immediate Execution Times */
static unsigned char F8[9][2][3] = {
/*---*---* Dn An M         Dn An M  */
/*---*---* 0  1  2         0  1  2  */
/*---*---* -  -  -         -  -  -  */
      {	{  8, 0,12 },	{ 14, 0,20 } },	/* ADDI */
      {	{  4, 8, 8 },	{  8, 8,12 } },	/* ADDQ */
      {	{  8, 0,12 },	{ 14, 0,20 } },	/* ANDI */
      {	{  8, 0, 8 },	{ 12, 0,12 } },	/* CMPI */
      {	{  8, 0,12 },	{ 14, 0,20 } },	/* EORI */
      {	{  0, 0, 0 },	{  4, 0, 0 } },	/* MOVEQ */
      {	{  8, 0,12 },	{ 14, 0,20 } },	/* ORI */
      {	{  8, 0,12 },	{ 14, 0,20 } },	/* SUBI */
      {	{  4, 8, 8 },	{  8, 8,12 } }	/* SUBQ */
};

/* Table F9 Single Operand Execution Times */
static unsigned char F9[8][2][2] = {
/*---*---* R  M            R  M     */
/*---*---* 0  1            0  1     */
/*---*---* -  -            -  -     */
      {	{  4, 8 },	{  6,12 } },	/* CLR */
      {	{  6, 8 },	{  0, 0 } },	/* NBCD */
      {	{  4, 8 },	{  6,12 } },	/* NEG */
      {	{  4, 8 },	{  6,12 } },	/* NEGX */
      {	{  4, 8 },	{  6,12 } },	/* NOT */
      {	{  4, 8 },	{  0, 0 } },	/* SCC */
      {	{  4,14 },	{  0, 0 } },	/* TAS */
      {	{  4, 4 },	{  4, 4 } }	/* TST */
};

/* Table F12 Shift/Rotate Execution Times */
static unsigned char F12[1][2][2] = {
/*---*---* R  M            R  M     */
/*---*---* 0  1            0  1     */
/*---*---* -  -            -  -     */
      {	{  6, 8 },	{  8, 0 } }	/* ASR,ASL,LSR,LSL,ROR,ROL,ROXR,ROXL */
};

/* Table F14 Bit Manipulation Execution Times */
static unsigned char F14[4][2][2] = {
/*---*---* BYTE            LONG     */
/*---*---* 0  1            0  1     */
/*---*---* -  -            -  -     */
      {	{  8,12 },	{  8,12 } },	/* BCHG */
      {	{ 10,14 },	{ 10,14 } },	/* BCLR */
      {	{  8,12 },	{  8,12 } },	/* BSET */
      {	{  4, 8 },	{  6,10 } }	/* BTST */
};

/* Table F15 Conditional Execution Times */
static unsigned char F15[4][2] = {
/*---*---* B  W  */
/*---*---* 0  1  */
/*---*---* -  -  */
      	{ 10,10 },	/* BCC */
      	{ 10,10 },	/* BRA */
      	{ 18,18 },	/* BSR */
      	{ 16,16 }	/* DBCC */
};

/* Table F16 JMP, JSR, LEA, PEA, and MOVEM Instruction Times */
static unsigned char F16[6][12] = {
/*---*---* 0  1  2  3  4  5  6  7  8  9 10 11 */
/*---*---* -  -  -  -  -  -  -  -  -  -  -  - */
	{  0, 0, 8, 0, 0,10,14,10,12,10,14, 0 },	/* JMP */
	{  0, 0,18, 0, 0,18,22,18,20,18,22, 0 },	/* JSR */
	{  0, 0, 4, 0, 0, 8,12, 8,12, 8,12, 0 },	/* LEA */
	{  0, 0,12, 0, 0,16,20,16,20,16,20, 0 },	/* PEA */
	{  0, 0,12,12, 0,16,18,16,20,16,18, 0 },	/* MOVEM M->R */
	{  0, 0, 8, 0, 8,12,14,12,16, 0, 0, 0 },	/* MOVEM R->M */
};

/* Table F17 Multiprecision Execution Times */
static unsigned char F17[5][2][2] = {
/*---*---* DN M            DN M     */
/*---*---* 0  1            0  1     */
/*---*---* -  -            -  -     */
      {	{  4,18 },	{  6,30 } },	/* ADDX */
      {	{  0,12 },	{  0,20 } },	/* CMPM */
      {	{  4,18 },	{  6,30 } },	/* SUBX */
      {	{  6,18 },	{  0, 0 } },	/* ABCD */
      {	{  6,18 },	{  0, 0 } }	/* SBCD */
};

/* Table F18 Miscellaneous Execution Times */
static unsigned char F18[26][2] = {
/*---*---* 0  1  */
/*---*---* -  -  */
      	{ 16,16 },	/* (0) ANDI [CCR,SR] */
      	{  8, 0 },	/* (1) CHK */
      	{ 16,16 },	/* (2) EORI [CCR,SR] */
      	{ 16,16 },	/* (3) ORI  [CCR,SR] */
      	{  6, 0 },	/* (4) EXG */
      	{  4, 4 },	/* (5) EXT */
      	{ 38, 0 },	/* (6) ILLEGAL */
      	{ 16, 0 },	/* (7) LINK */
      	{  4, 8 },	/* (8) MOVE from CCR [R,M] */
      	{ 12,12 },	/* (9) MOVE to  CCR [R,M] */
      	{  4, 8 },	/* (10) MOVE from SR [R,M] */
      	{ 12,12 },	/* (11) MOVE to   SR [R,M] */
      	{  6, 0 },	/* (12) MOVE from USP */
      	{  6, 0 },	/* (13) MOVE to USP */
      	{  4, 0 },	/* (14) NOP */
      	{130, 0 },	/* (15) RESET */
      	{112, 0 },	/* (16) RTE */
      	{ 20, 0 },	/* (17) RTR */
      	{ 16, 0 },	/* (18) RTS */
      	{  4, 0 },	/* (19) STOP */
      	{  4, 0 },	/* (20) SWAP */
      	{ 38, 0 },	/* (21) TRAP */
      	{ 40, 0 },	/* (22) TRAPV */
      	{ 12, 0 },	/* (23) UNLK */
      	{ 16, 0 },	/* (24) RTD */
      	{ 10,12 }	/* (25) MOVEC */
};

/* Table F20 MOVE Peripheral Execution Times */
static unsigned char F20[1][2][2] = {
/*---*---* Word            Long     */
/*---*---* 0  1            0  1     */
/*---*---* -  -            -  -     */
      {	{ 16,16 },	{ 24,24 } }	/* MOVEP */
};

/*
 * Determine Machine Cycles
 */
int
mc68010cycles(mp, opcode, rc, cycles)
struct mne *mp;
a_uint opcode;
int rc;
int cycles;
{
	a_uint op;
	int rf, sz;
	int ix1, ix2, ix3, ixv;

	ix1 = ix2 = ix3 = ixv = 0;

	op = mp->m_valu;
	rf = mp->m_type;
	sz = mp->m_flag & 0x03;

	switch (rf) {

	case S_CMPM:	/* CMPM */
	case S_TYP1:	/* ABCD, SBCD, ADDX, SUBX */
		switch(op & 0xFF00) {
		case 0xD100:	ix1 = 0;	break;	/* ADDX */
		case 0xB100:	ix1 = 1;	break;	/* CMPM */
		case 0x9100:	ix1 = 2;	break;	/* SUBX */
		case 0xC100:	ix1 = 3;	break;	/* ABCD */
		case 0x8100:	ix1 = 4;	break;	/* SBCD */
		default:	break;
		}
		ix2 = (sz == A_L) ? 1 : 0;
		ix3 = (opcode & 8) ? 1 : 0;
		cycles += (int) F17[ix1][ix2][ix3];
		break;

	case S_EOR:	/* EOR */
	case S_TYP2:	/* ADD, AND, OR, SUB */
		switch(op & 0xFF00) {
		case 0xD000:	ix1 = 0;	break;	/* ADD */
		case 0xC000:	ix1 = 1;	break;	/* AND */
		case 0xB100:	ix1 = 5;	break;	/* EOR */
		case 0x8000:	ix1 = 8;	break;	/* OR */
		case 0x9000:	ix1 = 9;	break;	/* SUB */
		default:	ix1 = -1;	break;
		}
		/* ADD, AND, OR, SUB */
		if ((ix1 == 0) || ((ix1 == 1) || (ix1 == 8) || (ix1 == 9))) {
			ix2 = (sz == A_L) ? 1 : 0;
			ix3 = (op & 0x0100) ? 1: 2;
			if ((sz == A_L) && (op & 0x0100)) {
				/* Extra Cycles For Dn,Dn Or #,Dn */
				if (((opcode & 070) == 0) || ((opcode & 077) == 074)) {
					cycles += 2;
				}
			}
			cycles += (int) F6[ix1][ix2][ix3];
			ix1 = eamlo(opcode);
			cycles += (int) F1[ix1][ix2];
		} else
		/* EOR */
		if (ix1 == 5) {
			ix2 = (sz == A_L) ? 1 : 0; 
			cycles += (int) F6[ix1][ix2][2];
			ix1 = eamlo(opcode);
			cycles += (int) F1[ix1][ix2];
		} else {
			/* Alternate Forms - ADDI, ANDI, EORI, ORI, SUBI */
			/* Alternate Forms - ADDQ, SUBQ */
			switch(op & 0xFF00) {
			case 0x0600:	ix1 = 0;	break;	/* ADDI */
			case 0x5000:	ix1 = 1;	break;	/* ADDQ */
			case 0x0200:	ix1 = 2;	break;	/* ANDI */
			case 0x0A00:	ix1 = 4;	break;	/* EORI */
			case 0x0000:	ix1 = 6;	break;	/* ORI  */
			case 0x0400:	ix1 = 7;	break;	/* SUBI */
			case 0x5100:	ix1 = 8;	break;	/* SUBQ */
			default:
				xerr('q', "Internal Cycles Error");
				break;
			}
			ixv = eamlo(opcode);
			ix2 = (sz == A_L) ? 1 : 0;
			switch(ixv) {
			case 0:		ix3 = 0;	break;
			case 1:		ix3 = 1;	break;
			default:	ix3 = 2;
				cycles += (int) F1[ixv][ix2];	break;
			}
			cycles += (int) F8[ix1][ix2][ix3];
		}
		break;

	case S_TYP3:	/* ADDA, CMPA, SUBA */
		switch(op & 0xF000) {
		case 0xD000:	ix1 = 0;	break;	/* ADDA */
		case 0xB000:	ix1 = 2;	break;	/* CMPA */
		case 0x9000:	ix1 = 9;	break;	/* SUBA */
		default:	break;
		}
		ix2 = (sz == A_L) ? 1 : 0;
		ix3 = 0;
		if (sz == A_L) {
			/* Extra Cycles For <ea>,An */
			if (((opcode & 070) == 000) || ((opcode & 070) == 010) || ((opcode & 077) == 074)) {
				cycles += 2;
			}
		}
		cycles += (int) F6[ix1][ix2][ix3];
		ix1 = eamlo(opcode);
		cycles += (int) F1[ix1][ix2];
		break;

	case S_TYP4:	/* ADDI, ANDI, CMPI, EORI, ORI, SUBI */
	case S_TYP5:	/* ADDQ, SUBQ */
	case S_MOVEQ:	/* MOVEQ */
		switch(op & 0xFF00) {
		case 0x0600:	ix1 = 0;	break;	/* ADDI */
		case 0x5000:	ix1 = 1;	break;	/* ADDQ */
		case 0x0200:	ix1 = 2;	break;	/* ANDI */
		case 0x0C00:	ix1 = 3;	break;	/* CMPI */
		case 0x0A00:	ix1 = 4;	break;	/* EORI */
		case 0x7000:	ix1 = 5;	break;	/* MOVEQ */
		case 0x0000:	ix1 = 6;	break;	/* ORI */
		case 0x0400:	ix1 = 7;	break;	/* SUBI */
		case 0x5100:	ix1 = 8;	break;	/* SUBQ */
		default:	break;
		}
		if (ix1 == 5 ) {
			cycles += (int) F8[ix1][1][0];
		} else {
			ixv = eamlo(opcode);
			ix2 = (sz == A_L) ? 1 : 0;
			switch(ixv) {
			case 0:		ix3 = 0;	break;
			case 1:		ix3 = 1;	break;
			default:	ix3 = 2;
				cycles += (int) F1[ixv][ix2];	break;
			}
			cycles += (int) F8[ix1][ix2][ix3];
		}
		break;

	case S_TYP6:	/* CHK, CMP, DIVS, DIVU, MULS, MULU */
		if (op == 0x4180) {	/* CHK */
			ix1 = eamlo(opcode);
			ix2 = 0;
			cycles += (int) F18[1][ix2] + (int) F1[ix1][ix2];
			break;
		}
		switch(op & 0xFF00) {
		case 0xB000:	ix1 = 2;	break;	/* CMP */
		case 0x8100:	ix1 = 3;	break;	/* DIVS */
		case 0x8000:	ix1 = 4;	break;	/* DIVU */
		case 0xC100:	ix1 = 6;	break;	/* MULS */
		case 0xC000:	ix1 = 7;	break;	/* MULU */
		default:	break;
		}
		ix2 = (sz == A_L) ? 1 : 0;
		cycles += (int) F6[ix1][ix2][1] + (int) F1[eamlo(opcode)][ix2];
		break;

	case S_TYP7:	/* CLR, NEG, NEGX, NOT, TST */
	case S_TYP9:	/* NBCD, TAS */
	case S_SCC:	/* SCC */
		/* Effective Address Mode Cycles */
		ix1 = eamlo(opcode);
		ix2 = (sz == A_L) ? 1 : 0;
		cycles += (int) F1[ix1][ix2];
		/* Instruction Cycles */
		ix3 = (ix1 >= 2) ? 1 : 0;
		switch(op & 0xFF00) {
		case 0x4200:	ix1 = 0;	break;	/* CLR */
		case 0x4800:	ix1 = 1;	break;	/* NBCD */
 	        case 0x4400:	ix1 = 2;	break;	/* NEG */
		case 0x4000:	ix1 = 3;	break;	/* NEGX */
		case 0x4600:	ix1 = 4;	break;	/* NOT */
		case 0x4A00:
			if (op == 0x4AC0) {
				ix1 = 6;	/* TAS */
			} else {
				ix1 = 7;	/* TST */
			}
			break;
		default:	ix1 = 5;	break;	/* SCC */
		}
		cycles += (int) F9[ix1][ix2][ix3];
		break;

	case S_MOVEM:	/* MOVEM */
	case S_TYP8:	/* JMP, JSR, LEA, PEA */
		switch(op) {
		case 0x4EC0:	ix1 = 0;	break;	/* JMP */
		case 0x4E80:	ix1 = 1;	break;	/* JSR */
		case 0x41C0:	ix1 = 2;	break;	/* LEA */
		case 0x4840:	ix1 = 3;	break;	/* PEA */
		default:	ix1 = 4;		/* MOVEM */
			ix1 += (opcode & 0x0400) ? 0 : 1;
			cycles += (sz == A_L) ? rc * 8 : rc * 4;
			break;
		}
		ix2 = eamlo(opcode);
		cycles += (int) F16[ix1][ix2];
		break;

	case S_SHFT:	/* ASL, ASR, LSL, LSR, ROL, ROR, ROXL, ROXL */
		ix1 = 0;
		if ((opcode & 0xC0) == 0xC0) {
			ix2 = 0;
			ix3 = 1;
		} else {
			ix2 = (sz == A_L) ? 1 : 0;
			ix3 = 0;
			cycles += rc * 2;
		}
		cycles += (int) F12[ix1][ix2][ix3];
		break;

	case S_BCC:	/* Bcc */
	case S_DBCC:	/* DBcc */
		if ((op & 0xFF00) == 0x6000) {	/* BRA */
			ix1 = 1;
		} else
		if ((op & 0xFF00) == 0x6100) {	/* BSR */
			ix1 = 2;
		} else
		if ((op & 0xF000) == 0x6000) {	/* BCC */
			ix1 = 0;
		} else
		if ((op & 0xF000) == 0x5000) {	/* DBCC */
			ix1 = 3;
		} else {
			xerr('q', "Internal Cycles Error");
		}
		if (sz == B_A) {
			ix2 = (opcode & 0x00FF) ? 0 : 1;
		} else {
			ix2 = (sz == B_S) ? 0 : 1;
		}
		cycles += (int) F15[ix1][ix2];
		break;

	case S_BIT:	/* BCHG, BCLR, BSET, BTST */
		if ((op & 0xFF00) == 0x0100) {
			switch(op) {
			case 0x0140:	ix1 = 0;	break;	/* BCHG */
			case 0x0180:	ix1 = 1;	break;	/* BCLR */
			case 0x01C0:	ix1 = 2;	break;	/* BSET */
			case 0x0100:	ix1 = 3;	break;	/* BTST */
			default:	break;
			}
			ix3 = 0;
		} else
		if ((opcode & 0xFF00) == 0x0800) {
			switch(opcode & 0xFFC0) {
			case 0x0840:	ix1 = 0;	break;	/* BCHG */
			case 0x0880:	ix1 = 1;	break;	/* BCLR */
			case 0x08C0:	ix1 = 2;	break;	/* BSET */
			case 0x0800:	ix1 = 3;	break;	/* BTST */
			default:	break;
			}
			ix3 = 1;
		} else {
			xerr('q', "Internal Cycles Error");
		}
		ixv =  eamlo(opcode);
		ix2 = (ixv < 1) ? 1 : 0;
		cycles +=  (int) F14[ix1][ix2][ix3];
		cycles += (int) F1[ixv][0];
		break;

	case S_MOVE:	/* MOVE */
		if ((opcode & 0xF000) == 0x4000) {
			switch(opcode & 0xFFC0) {
			case 0x42C0:	ix1 = 8;	break;	/* MOVE from CCR (68010) */
			case 0x44C0:	ix1 = 9;	break;	/* MOVE to CCR */
			case 0x40C0:	ix1 = 10;	break;	/* MOVE from SR (68010) */
			case 0x46C0:	ix1 = 11;	break;	/* MOVE to SR */
			case 0x4E40:				/* MOVE from/to USP */
				ix1 = (opcode & 0x0008) ? 12 : 13;
				break;
			default:
				xerr('q', "Internal Cycles Error");
				break;
			}
			if ((ix1 == 12) || (ix1 == 13)) {
				cycles += (int) F18[ix1][0];
				break;
			}
			ixv = eamlo(opcode);
			ix2 = (ixv > 1) ? 1 : 0;
			cycles +=  (int) F18[ix1][ix2];
			cycles += (int) F1[ixv][0];
			break;
		}
		switch(op & 0xC000) {
		case 0x0000:	/* MOVE */
			ix1 = eamlo(opcode);
			ix2 = eamhi(opcode);
			if (sz == A_L) {
				cycles += (int) F4[ix1][ix2];
			} else {
				cycles += (int) F2[ix1][ix2];
			}
			break;
		case 0x8000:	/* MOVEQ */
			cycles += (int) F8[5][1][0];
			break;
		default:
			xerr('q', "Internal Cycles Error");
			break;
		}
		break;

	case S_MOVEA:	/* MOVEA */
		ix1 = eamlo(opcode);
		cycles += (int) (sz == A_L) ? F4[ix1][1] : F2[ix1][1];
		break;

	case S_MOVEC:	/* MOVEC (68010) */
		cycles += F18[25][(int) opcode & 1];
		break;

	case S_MOVEP:	/* MOVEP */
		ix1 = 0;
		ix2 = (opcode & 0x40) ? 1 : 0;
		ix3 = (opcode & 0x80) ? 0 : 1;
		cycles += (int) F20[ix1][ix2][ix3];
		break;

	case S_MOVES:	/* MOVES Rn,<ea>  Or  MOVES <ea>,Rn (68010) */
		ix3 = eamlo(opcode);
		switch(aindx) {
		case 0:	ix1 = 0;    ix2 = ix3;	break;	/* Dn,<ea> */
		case 1:	ix1 = 1;    ix2 = ix3;	break;	/* An,<ea> */
		case 2: ix1 = ix3;  ix2 = 0;	break;	/* <ea>,Dn */
		case 3: ix1 = ix3;  ix2 = 1;	break;	/* <ea>,An */
		default:
			xerr('q', "Internal Cycles Error");
			break;
		}
		if (sz == A_L) {
			cycles += (int) F4[ix1][ix2];
		} else {
			cycles += (int) F2[ix1][ix2];
		}
		break;

	case S_CMP:	/* CMP */
		switch(op & 0xFF00) {
		case 0xB000:	ix1 = 2;	break;	/* CMP */
		case 0x0C00:	ix1 = 3;	break;	/* CMPI */
		default:	xerr('q', "Internal Cycles Error");	break;
		}
		switch(ix1) {
		case 2:	/* CMP */
			ix2 = (sz == A_L) ? 1 : 0;
			cycles += (int) F6[ix1][ix2][1] + (int) F1[eamlo(opcode)][ix2];
			break;
		case 3:	/* CMPI */
			ix2 = (sz == A_L) ? 1 : 0;
			cycles += (int) F8[ix1][ix2][0];
			break;
		default:
			break;
		}
		break;

	case S_EXG:	cycles += (int) F18[4][0];	break;	/* EXG */

	case S_EXT:	cycles += (int) F18[5][0];	break;	/* EXT */

	case S_LINK:	cycles += (int) F18[7][0];	break;	/* LINK */

	case S_STOP:
		switch(op) {
		case 0x4E72:	cycles += (int) F18[19][0];	break;	/* STOP */
		case 0x4E74:	cycles += (int) F18[24][0];	break;	/* RTD (68010) */
		default:	break;
		}
		break;

	case S_SWAP:	cycles += (int) F18[20][0];	break;	/* SWAP */

	case S_TRAP:	cycles += (int) F18[21][0];	break;	/* TRAP */

	case S_UNLK:	cycles += (int) F18[23][0];	break;	/* UNLK */
		
	case S_INH:	/* See Table D-12 */
		switch(op) {
		case 0x4AFC:	cycles += (int) F18[6][0];	break;	/* ILLEGAL */
		case 0x4E71:	cycles += (int) F18[14][0];	break;	/* NOP */
		case 0x4E70:	cycles += (int) F18[15][0];	break;	/* RESET */
		case 0x4E73:	cycles += (int) F18[16][0];	break;	/* RTE */
		case 0x4E77:	cycles += (int) F18[17][0];	break;	/* RTR */
		case 0x4E75:	cycles += (int) F18[18][0];	break;	/* RTS */
		case 0x4E76:	cycles += (int) F18[22][0];	break;	/* TRAPV */
		default:	break;
		}
		break;

	case S_M68K:	/* Verification Of Addressing Modes */
		ix1 = eamlo(opcode);
		ix2 = (sz == A_L) ? 1 : 0;
		cycles += (int) F1[ix1][ix2];
		break;

	default:
		cycles = OPCY_ERR;
		break;
	}

	return(cycles);
}

/*
 *****-----*****-----*****-----*****-----*****-----*****-----*****
 *
 * End Of 68010 Instruction Addressing Mode MicroCycle Timing
 *
 *****-----*****-----*****-----*****-----*****-----*****-----*****
 */

/*
 * 68020 Instruction Addressing Mode MicroCycle Timing
 *   Taken from:
 *	MC68020 32-Bit Microproessor User's Manual
 *	Second Edition
 *	C 1985, 1984 by Motorola Inc.
 */

/*
 * Decoding Matrix
 */
static unsigned char efamtx[4][8] = {
/* INDEX */   /* 0    1    2    3    4    5    6    7 */
/* BDSIZ */   /* -    -    -    -    -    -    -    - */
/*   0   */  {  12,   0,   0,   0,   0,   0,   0,   0  },
/*   1   */  {  13,  16,  17,  18,   0,  16,  17,  18  },
/*   2   */  {  14,  19,  20,  21,   0,  19,  20,  21  },
/*   3   */  {  15,  22,  23,  24,   0,  22,  23,  24  }
};

int
xefaindx(ea, sz, x)
int ea, sz, x;
{
	int indx;
	int t, v, bs, is;

	indx = 0;
	t = ea & 000070;
	v = ea & 000007;
	bs = (x & 0x0030) >> 4;
	is = (x & 0x0007);
	switch(t) {
	default:
	case S_Dn:	indx = 0;	break;
	case S_An:	indx = 1;	break;
	case S_ARI:	indx = 2;	break;
	case S_AINC:	indx = 3;	break;
	case S_ADEC:	indx = 4;	break;
	case S_ARID:	indx = 5;	break;
	case 000060:
		if ((x & 0x0100) == 0) {
			indx = 11;
		} else {
			indx = efamtx[bs][is];
		}
		break;
	case 000070:
		switch(t | v) {
		case S_SHRT:	indx = 6;	break;
		case S_LONG:	indx = 7;	break;
		case S_IMM:
			switch(sz) {
			default:
			case A_L:	indx = 10;	break;
			case A_W:	indx = 9;	break;
			case A_B:	indx = 8;	break;
			}
			break;
		case S_PCID:	indx = 5;	break;
		case 000073:
			if ((x & 0x0100) == 0) {
				indx = 11;
			} else {
				indx = efamtx[bs][is];
			}
			break;
		default:
			xerr('w', "Internal 'xefaindx()' Error");
			break;
		}
	}

	return(indx);
}

int
xefacycles(tbl, ea, sz, x)
unsigned char *tbl;
int ea, sz, x;
{
	return(tbl[xefaindx(ea, sz, x)]);
}

/*
 * Fetch Effective Address Cycles
 * (Worst Case)
 */
static unsigned char fefa[25] = {
/*  0 */   0,	/* Dn */
/*  1 */   0,	/* An */
/*  2 */   4,	/* (An) */
/*  3 */   4,	/* (An)+ */
/*  4 */   5,	/* -(An) */
/*  5 */   6,	/* d16(An), (d16,An), d16(PC), or (d16,PC) */
/*  6 */   6,	/* (xxx).W */
/*  7 */   7,	/* (xxx).L */
/*  8 */   3,	/* #<data>.B */
/*  9 */   3,	/* #<data>.W */
/* 10 */   5,	/* #<data>.L */
/* 11 */   8,	/* d8(An,Xn), (d8,An,Xn), d8(PC,Xn), or (d8(PC,Xn) */
/* 12 */   9,	/* (d16,An,Xn) or (d16,PC,Xn) */
/*
 * B = Base Address; Blank, An, PC, Xn, An + Xn, or PC + Xn
 * I = Index Suppress; Blank or Xn
 */
/* 13 */   9,	/* (B) */
/* 14 */  12,	/* (d16,B) */
/* 15 */  16,	/* (d32,B) */
/* 16 */  13,	/* ([B],I) */
/* 17 */  16,	/* ([B],I,d16) */
/* 18 */  17,	/* ([B],I,d32) */
/* 19 */  16,	/* ([d16,B],I) */
/* 20 */  19,	/* ([d16,B],I,d16) */
/* 21 */  20,	/* ([d16,B],I,d32) */
/* 22 */  20,	/* ([d32,B],I) */
/* 23 */  22,	/* ([d32,B],I,d16) */
/* 24 */  24	/* ([d32,B],I,d32) */
};

int
fefacycles(ea, sz, x)
int ea, sz, x;
{
	return(xefacycles(fefa, ea, sz, x));
}

/*
 * Calculate Effective Address Cycles
 * (Worst Case)
 */
static unsigned char cefa[25] = {
/*  0 */   0,	/* Dn */
/*  1 */   0,	/* An */
/*  2 */   2,	/* (An) */
/*  3 */   2,	/* (An)+ */
/*  4 */   2,	/* -(An) */
/*  5 */   3,	/* d16(An), (d16,An), d16(PC), or (d16,PC) */
/*  6 */   0,	/* (xxx).W */
/*  7 */   0,	/* (xxx).L */
/*  8 */   3,	/* #<data>.B */
/*  9 */   3,	/* #<data>.W */
/* 10 */   5,	/* #<data>.L */
/* 11 */   5,	/* d8(An,Xn), (d8,An,Xn), d8(PC,Xn), or (d8(PC,Xn) */
/* 12 */   7,	/* (d16,An,Xn) or (d16,PC,Xn) */
/*
 * B = Base Address; Blank, An, PC, Xn, An + Xn, or PC + Xn
 * I = Index Suppress; Blank or Xn
 */
/* 13 */   7,	/* (B) */
/* 14 */  10,	/* (d16,B) */
/* 15 */  15,	/* (d32,B) */
/* 16 */  12,	/* ([B],I) */
/* 17 */  15,	/* ([B],I,d16) */
/* 18 */  16,	/* ([B],I,d32) */
/* 19 */  15,	/* ([d16,B],I) */
/* 20 */  18,	/* ([d16,B],I,d16) */
/* 21 */  19,	/* ([d16,B],I,d32) */
/* 22 */  19,	/* ([d32,B],I) */
/* 23 */  21,	/* ([d32,B],I,d16) */
/* 24 */  24	/* ([d32,B],I,d32) */
};

int
cefacycles(ea, sz, x)
int ea, sz, x;
{
	return(xefacycles(cefa, ea, sz, x));
}

/*
 * Fetch Immediate Word Effective Address Cycles
 * (Worst Case)
 */
static unsigned char fiwefa[25] = {
/*  0 */   3,	/* Dn */
/*  1 */   3,	/* An */
/*  2 */   4,	/* (An) */
/*  3 */   7,	/* (An)+ */
/*  4 */   6,	/* -(An) */
/*  5 */   7,	/* d16(An) Or (d16,An) */
/*  6 */   7,	/* (xxx).W */
/*  7 */   7,	/* (xxx).L */
/*  8 */   6,	/* #<data>.B */
/*  9 */   6,	/* #<data>.W */
/* 10 */   8,	/* #<data>.L */
/* 11 */  11,	/* d8(An,Xn), (d8,An,Xn), d8(PC,Xn), or (d8(PC,Xn) */
/* 12 */  12,	/* (d16,An,Xn) or (d16,PC,Xn) */
/*
 * B = Base Address; Blank, An, PC, Xn, An + Xn, or PC + Xn
 * I = Index Suppress; Blank or Xn
 */
/* 13 */  12,	/* (B) */
/* 14 */  15,	/* (d16,B) */	/* For PC Add 4 */
/* 15 */  19,	/* (d32,B) */
/* 16 */  16,	/* ([B],I) */
/* 17 */  19,	/* ([B],I,d16) */
/* 18 */  20,	/* ([B],I,d32) */
/* 19 */  19,	/* ([d16,B],I) */
/* 20 */  22,	/* ([d16,B],I,d16) */
/* 21 */  23,	/* ([d16,B],I,d32) */
/* 22 */  23,	/* ([d32,B],I) */
/* 23 */  25,	/* ([d32,B],I,d16) */
/* 24 */  27	/* ([d32,B],I,d32) */
};

/*
 * Fetch Immediate Long Effective Address Cycles
 * (Worst Case)
 */
static unsigned char filefa[25] = {
/*  0 */   5,	/* Dn */
/*  1 */   5,	/* An */
/*  2 */   7,	/* (An) */
/*  3 */   9,	/* (An)+ */
/*  4 */   8,	/* -(An) */
/*  5 */  10,	/* d16(An) Or (d16,An) */
/*  6 */  10,	/* (xxx).W */
/*  7 */  12,	/* (xxx).L */
/*  8 */   8,	/* #<data>.B */
/*  9 */   8,	/* #<data>.W */
/* 10 */  10,	/* #<data>.L */
/* 11 */  13,	/* d8(An,Xn), (d8,An,Xn), d8(PC,Xn), or (d8(PC,Xn) */
/* 12 */  15,	/* (d16,An,Xn) or (d16,PC,Xn) */
/*
 * B = Base Address; Blank, An, PC, Xn, An + Xn, or PC + Xn
 * I = Index Suppress; Blank or Xn
 */
/* 13 */  14,	/* (B) */
/* 14 */  17,	/* (d16,B) */	/* For PC Add 4 */
/* 15 */  21,	/* (d32,B) */
/* 16 */  18,	/* ([B],I) */
/* 17 */  21,	/* ([B],I,d16) */
/* 18 */  22,	/* ([B],I,d32) */
/* 19 */  21,	/* ([d16,B],I) */
/* 20 */  24,	/* ([d16,B],I,d16) */
/* 21 */  25,	/* ([d16,B],I,d32) */
/* 22 */  25,	/* ([d32,B],I) */
/* 23 */  27,	/* ([d32,B],I,d16) */
/* 24 */  29	/* ([d32,B],I,d32) */
};

int
fiwefacycles(ea, sz, x)
int ea, sz, x;
{
	int cycles;

	cycles = xefacycles(fiwefa, ea, sz, x);
	if ((ea & 000077) == 000072) {	/* Fix (d,PC) */
		cycles += 4;
	}
	return(cycles);
}

int
filefacycles(ea, sz, x)
int ea, sz, x;
{
	int cycles;

	cycles = xefacycles(filefa, ea, sz, x);
	if ((ea & 000077) == 000072) {	/* Fix (d,PC) */
		cycles += 4;
	}
	return(cycles);
}

int
fiefacycles(ea, sz, x)
int ea, sz, x;
{
	int cycles;

	if (sz == A_L) {
		cycles = filefacycles(ea, sz, x);
	} else {
		cycles = fiwefacycles(ea, sz, x);
	}
	return(cycles);
}

/*
 * Calculate Immediate Word Effective Address Cycles
 * (Worst Case)
 */
static unsigned char ciwefa[25] = {
/*  0 */   3,	/* Dn */
/*  1 */   3,	/* An */
/*  2 */   3,	/* (An) */
/*  3 */   5,	/* (An)+ */
/*  4 */   4,	/* -(An) */
/*  5 */   5,	/* d16(An) Or (d16,An) */
/*  6 */   5,	/* (xxx).W */
/*  7 */   6,	/* (xxx).L */
/*  8 */   4,	/* #<data>.B */
/*  9 */   4,	/* #<data>.W */
/* 10 */   6,	/* #<data>.L */
/* 11 */   8,	/* d8(An,Xn), (d8,An,Xn), d8(PC,Xn), or (d8(PC,Xn) */
/* 12 */  10,	/* (d16,An,Xn) or (d16,PC,Xn) */
/*
 * B = Base Address; Blank, An, PC, Xn, An + Xn, or PC + Xn
 * I = Index Suppress; Blank or Xn
 */
/* 13 */  12,	/* (B) */
/* 14 */  13,	/* (d16,B) */	/* For PC Add 5 */
/* 15 */  18,	/* (d32,B) */
/* 16 */  15,	/* ([B],I) */
/* 17 */  18,	/* ([B],I,d16) */
/* 18 */  29,	/* ([B],I,d32) */
/* 19 */  18,	/* ([d16,B],I) */
/* 20 */  21,	/* ([d16,B],I,d16) */
/* 21 */  22,	/* ([d16,B],I,d32) */
/* 22 */  22,	/* ([d32,B],I) */
/* 23 */  24,	/* ([d32,B],I,d16) */
/* 24 */  24	/* ([d32,B],I,d32) */
};

/*
 * Calculate Immediate Long Effective Address Cycles
 * (Worst Case)
 */
static unsigned char cilefa[25] = {
/*  0 */   5,	/* Dn */
/*  1 */   5,	/* An */
/*  2 */   5,	/* (An) */
/*  3 */   7,	/* (An)+ */
/*  4 */   6,	/* -(An) */
/*  5 */   8,	/* d16(An) Or (d16,An) */
/*  6 */   8,	/* (xxx).W */
/*  7 */  10,	/* (xxx).L */
/*  8 */   6,	/* #<data>.B */
/*  9 */   6,	/* #<data>.W */
/* 10 */   8,	/* #<data>.L */
/* 11 */  10,	/* d8(An,Xn), (d8,An,Xn), d8(PC,Xn), or (d8(PC,Xn) */
/* 12 */  12,	/* (d16,An,Xn) or (d16,PC,Xn) */
/*
 * B = Base Address; Blank, An, PC, Xn, An + Xn, or PC + Xn
 * I = Index Suppress; Blank or Xn
 */
/* 13 */  12,	/* (B) */
/* 14 */  15,	/* (d16,B) */	/* For PC Add 4 */
/* 15 */  20,	/* (d32,B) */
/* 16 */  17,	/* ([B],I) */
/* 17 */  20,	/* ([B],I,d16) */
/* 18 */  21,	/* ([B],I,d32) */
/* 19 */  20,	/* ([d16,B],I) */
/* 20 */  23,	/* ([d16,B],I,d16) */
/* 21 */  24,	/* ([d16,B],I,d32) */
/* 22 */  24,	/* ([d32,B],I) */
/* 23 */  26,	/* ([d32,B],I,d16) */
/* 24 */  29	/* ([d32,B],I,d32) */
};

int
ciwefacycles(ea, sz, x)
int ea, sz, x;
{
	int cycles;

	cycles = xefacycles(ciwefa, ea, sz, x);
	if ((ea & 000077) == 000072) {	/* Fix (d,PC) */
		cycles += 4;
	}
	return(cycles);
}

int
cilefacycles(ea, sz, x)
int ea, sz, x;
{
	int cycles;

	cycles = xefacycles(cilefa, ea, sz, x);
	if ((ea & 000077) == 000072) {	/* Fix (d,PC) */
		cycles += 4;
	}
	return(cycles);
}

int
ciefacycles(ea, sz, x)
int ea, sz, x;
{
	int cycles;

	if (sz == A_L) {
		cycles = cilefacycles(ea, sz, x);
	} else {
		cycles = ciwefacycles(ea, sz, x);
	}
	return(cycles);
}

/*
 * Jump Effective Address Cycles
 * (Worst Case)
 */
static unsigned char jefa[25] = {
/*  0 */   0,	/* Dn */
/*  1 */   0,	/* An */
/*  2 */   2,	/* (An) */
/*  3 */   0,	/* (An)+ */
/*  4 */   0,	/* -(An) */
/*  5 */   4,	/* d16(An) Or (d16,An) */
/*  6 */   2,	/* (xxx).W */
/*  7 */   2,	/* (xxx).L */
/*  8 */   0,	/* #<data>.B */
/*  9 */   0,	/* #<data>.W */
/* 10 */   0,	/* #<data>.L */
/* 11 */   6,	/* d8(An,Xn), (d8,An,Xn), d8(PC,Xn), or (d8(PC,Xn) */
/* 12 */   6,	/* (d16,An,Xn) or (d16,PC,Xn) */
/*
 * B = Base Address; Blank, An, PC, Xn, An + Xn, or PC + Xn
 * I = Index Suppress; Blank or Xn
 */
/* 13 */   6,	/* (B) */
/* 14 */   6,	/* (d16,B) */
/* 15 */  12,	/* (d32,B) */
/* 16 */  11,	/* ([B],I) */
/* 17 */  14,	/* ([B],I,d16) */
/* 18 */  14,	/* ([B],I,d32) */
/* 19 */  14,	/* ([d16,B],I) */
/* 20 */  17,	/* ([d16,B],I,d16) */
/* 21 */  17,	/* ([d16,B],I,d32) */
/* 22 */  19,	/* ([d32,B],I) */
/* 23 */  21,	/* ([d32,B],I,d16) */
/* 24 */  23	/* ([d32,B],I,d32) */
};

int
jefacycles(ea, sz, x)
int ea, sz, x;
{
	return(xefacycles(jefa, ea, sz, x));
}

/*
 * MOVE And MOVEA Effective Address Cycles
 * (Worst Case)
 */
static unsigned char mvefa[25][25] = {
/* dst */ /* 0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 */
/* src */ /* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*  0 */  {  3, 3, 5, 5, 6, 7, 7, 9, 0, 0, 0, 9,12,10,14,19,14,17,20,17,20,23,22,25,27 },  /* Dn */
/*  1 */  {  3, 3, 5, 5, 6, 7, 7, 9, 0, 0, 0, 9,12,10,14,19,14,17,20,17,20,23,22,25,27 },  /* An */
/*  2 */  {  7, 7, 9, 9, 9,11,11,13, 0, 0, 0,11,14,12,16,21,12,19,22,19,22,25,24,27,29 },  /* (An) */
/*  3 */  {  7, 7, 9, 9, 9,11,11,13, 0, 0, 0,11,14,12,16,21,12,19,22,19,22,25,24,27,29 },  /* (An)+ */
/*  4 */  {  8, 8,10,10,10,12,12,14, 0, 0, 0,12,15,13,17,22,13,20,23,20,23,26,25,28,30 },  /* -(An) */
/*  5 */  {  9, 9,11,11,10,13,13,15, 0, 0, 0,13,16,14,18,23,14,21,23,21,24,27,26,29,32 },  /* d16(An) Or (d16,An) */
/*  6 */  {  8, 8,10,10,10,12,12,14, 0, 0, 0,12,15,13,17,22,13,20,25,20,23,26,27,28,33 },  /* (xxx).W */
/*  7 */  { 10,10,12,12,12,14,14,16, 0, 0, 0,14,17,15,19,24,15,22,26,22,25,28,29,30,34 },  /* (xxx).L */
/*  8 */  {  3, 3, 5, 8, 6, 7, 7, 9, 0, 0, 0, 9,12,10,14,19,14,17,20,17,20,23,22,25,27 },  /* #<data>.B */
/*  9 */  {  3, 3, 5, 8, 6, 7, 7, 9, 0, 0, 0, 9,12,10,14,19,14,17,20,17,20,23,22,25,27 },  /* #<data>.W */
/* 10 */  {  5, 5, 7, 7, 8, 9, 9,11, 0, 0, 0,11,14,12,16,21,16,19,22,19,22,25,24,27,29 },  /* #<data>.L */
/* 11 */  { 11,11,13,13,13,15,15,17, 0, 0, 0,15,18,16,20,25,16,23,26,23,26,29,30,31,33 },  /* d8(An,Xn), (d8,An,Xn), d8(PC,Xn), or (d8(PC,Xn) */
/* 12 */  { 12,12,14,14,14,16,16,18, 0, 0, 0,16,19,17,21,26,17,24,27,24,27,30,31,32,34 },  /* (d16,An,Xn) or (d16,PC,Xn) */ 
/*
 * B = Base Address; Blank, An, PC, Xn, An + Xn, or PC + Xn
 * I = Index Suppress; Blank or Xn
 */
/* 13 */  { 12,12,14,14,14,16,16,18, 0, 0, 0,16,19,17,21,26,17,24,27,24,27,30,31,32,34 },  /* (B) */
/* 14 */  { 15,15,17,17,17,19,19,21, 0, 0, 0,19,22,20,24,29,20,27,30,27,30,33,34,35,37 },  /* (d16,B) */
/* 15 */  { 19,19,21,21,21,23,23,25, 0, 0, 0,23,26,24,28,33,24,31,34,31,34,37,38,39,41 },  /* (d32,B) */
/* 16 */  { 16,16,18,18,18,20,20,22, 0, 0, 0,20,23,21,25,30,21,28,31,28,31,34,35,36,38 },  /* ([B],I) */
/* 17 */  { 19,19,21,21,21,23,23,25, 0, 0, 0,23,26,24,28,33,24,31,34,31,34,37,38,39,41 },  /* ([B],I,d16) */
/* 18 */  { 20,20,22,22,22,24,24,26, 0, 0, 0,24,27,25,29,34,25,32,35,32,45,38,39,40,42 },  /* ([B],I,d32) */
/* 19 */  { 19,19,21,21,21,23,23,25, 0, 0, 0,23,26,24,28,33,24,31,34,31,34,38,38,39,41 },  /* ([d16,B],I) */
/* 20 */  { 22,22,24,24,24,26,26,28, 0, 0, 0,26,29,27,31,36,27,34,37,34,37,41,41,42,44 },  /* ([d16,B],I,d16) */
/* 21 */  { 23,23,25,25,25,27,27,29, 0, 0, 0,27,30,28,32,37,28,35,38,35,38,42,42,43,45 },  /* ([d16,B],I,d32) */
/* 22 */  { 23,23,26,25,25,27,27,29, 0, 0, 0,27,30,28,32,37,28,35,38,35,38,41,42,43,45 },  /* ([d32,B],I) */
/* 23 */  { 25,25,27,27,27,29,29,31, 0, 0, 0,29,32,30,34,39,30,37,40,37,40,43,44,45,47 },  /* ([d32,B],I,d16) */
/* 24 */  { 27,27,29,29,27,31,31,33, 0, 0, 0,31,34,32,36,41,32,39,42,39,42,45,46,47,49 }   /* ([d32,B],I,d32) */
};

/*
 * Shift/Rotate Cycles
 */
static unsigned char shrocyc[8][2] = {
/* ---- */  /* Dn Mem  */
/* ---- */  /*  -   -  */
/* ASR  */   {  6,  6  },
/* LSR  */   {  4,  6  },
/* ROXR */   { 12,  6  },
/* ROR  */   {  8,  7  },
/* ASL  */   {  8,  7  },
/* LSL  */   {  4,  6  },
/* ROXL */   { 12,  6  },
/* ROL  */   {  8,  7  }
};

/*
 * Determine Machine Cycles
 */
int
mc68020cycles(mp, op1, op2, x1, x2, rc, cycles)
struct mne *mp;
a_uint op1, op2;
int x1, x2, rc;
int cycles;
{
	a_uint op;
	int opcode;
	int rf, sz;
	unsigned int ix1, ix2;

	ix1 = ix2 = 0;

	opcode = (int) op1;
	op = mp->m_valu;
	rf = mp->m_type;
	sz = mp->m_flag & 0x03;

	switch (rf) {

	case S_TYP1:	/* ABCD, SBCD, ADDX, SUBX */
		if (opcode & 0x0008) {		/* -(Ay),-(Ax) */
			if (opcode & 0x1000) {	/* ADDX, SUBX */
				cycles += 13;
			} else {		/* ABCD, SBCD */
				cycles += 17;
			}
		} else {			/* Dn,Dn */
			if (opcode & 0x1000) {	/* ADDX, SUBX */
				cycles += 3;
			} else {		/* ABCD, SBCD */
				cycles += 5;
			}
		}
		break;

	case S_TYP2:	/* ADD, AND, OR, SUB */
		if ((opcode == 0x023C) || (opcode == 0x027C) ||	/* ANDI #,CCR/SR */
		    (opcode == 0x003C) || (opcode == 0x007C)) {	/* ORI #,CCR/SR */
			cycles += 15;
			break;
		}
		ix1 = opcode & 0xF0C0;
		if ((ix1 == 0xD0C0) || (ix1 == 0x90C0)) {	/* ADDA / SUBA */
			cycles += (opcode & 0x0060) ? 6 : 3;
			if (opcode & 0x0100) {	/* LONG */
				cycles += fefacycles(opcode, A_L, x1);
			} else {		/* WORD */
				cycles += fefacycles(opcode, A_W, x1);
			}
			break;
		}
		ix1 = (int) op & 0xFF00;
		if ((ix1 == 0x5000) || (ix1 == 0x5100)) {	/* ADDQ / SUBQ */
			if (opcode & 000060) {	/* #,Mem */
				cycles += 6 + fefacycles(opcode, sz, x2);
			} else {		/* #,Dn */
				cycles += 3;
			}
			break;
		}
		if ((ix1 == 0x0600) || (ix1 == 0x0200) ||	/* ADDI / ANDI */
		    (ix1 == 0x0000) || (ix1 == 0x0400)) {	/* ORI  / SUBI */
			cycles += (opcode & 0x00060) ? 6 : 3;
			cycles += fiefacycles(opcode, sz, x2);
			break;
		}
		ix1 = (int) op & 0xF000;
		if ((ix1 == 0xD000) || (ix1 == 0xC000) ||	/* ADD / AND */
		    (ix1 == 0x8000) || (ix1 == 0x9000)) {	/* OR  / SUB */
			cycles += (opcode & 0x0100) ? 6 : 3;
			cycles += fiefacycles(opcode, sz, x2);
			break;
		}
		xerr('c', "Internal Cycles Error (TYP2)");
		break;

	case S_EOR:	/* EOR */
		if ((opcode == 0x0A3C) || (opcode == 0x0A7C)) {	/* EORI #,CCR/SR */
			cycles += 15;
			break;
		}
		if ((opcode & 0xFF00) == 0x0A00) {	/* EORI #,<ea> */
			cycles += (opcode & 000070) ? 6 : 3;	/* Dn,Mem / Dn,Dn */
			cycles += fiefacycles(opcode, sz, x2);
			break;
		}
		cycles += (opcode & 000070) ? 6 : 3;	/* Dn,Mem / Dn,Dn */
		cycles += fefacycles(opcode, sz, x2);
		break;

	case S_TYP3:	/* ADDA, CMPA, SUBA */
		cycles += 3 + fefacycles(opcode, sz, x1);
		if ((op & 0xF000) == 0x9000) {	/* SUBA */
			cycles += 1;
		}
		break;

	case S_TYP4:	/* ADDI, ANDI, CMPI, EORI, ORI, SUBI */
		cycles += 3;
		if (opcode & 070) {	/* <ea> != Dn */
			cycles += 3;
		}
		cycles += fiefacycles(opcode, sz, x2);
		break;

	case S_TYP5:	/* ADDQ, SUBQ */
		cycles += 3;
		if (opcode & 060) {	/* <ea> != Dn or An */
			cycles += 3 + fefacycles(opcode, sz, x1);
		}
		break;

	case S_TYP6:	/* DIVS, DIVU, MULS, MULU */
		if (sz == A_L) {
			switch(op & 0xFF00) {
			case 0x8100:	cycles = 90;	break;	/* DIVS.W */
			case 0x8000:	cycles = 78;	break;	/* DIVU.W */
			case 0xC100:	cycles = 44;	break;	/* MULS.W */
			case 0xC000:	cycles = 44;	break;	/* MULU.W */
			default:	break;
			}
			cycles += fiefacycles(opcode, sz, x1);
		} else {
			switch(op & 0xFF00) {
			case 0x8100:	cycles = 56;	break;	/* DIVS.W */
			case 0x8000:	cycles = 44;	break;	/* DIVU.W */
			case 0xC100:	cycles = 28;	break;	/* MULS.W */
			case 0xC000:	cycles = 28;	break;	/* MULU.W */
			default:	break;
			}
			cycles += fefacycles(opcode, sz, x1);
		}
		break;

	case S_TYP7:	/* CLR, NEG, NEGX, NOT, TST */
	case S_TYP9:	/* NBCD, TAS */
	case S_SCC:	/* SCC */
		if ((op & 0xFF00) == 0x4200) {	/* CLR */
			cycles += 3;
			if (opcode & 000070) {
				cycles += 3 + cefacycles(opcode, sz, x1);
			}
			break;
		}
		if ((op & 0xF0C0) == 0x50C0) {	/* Scc */
			cycles += 4;
			if (opcode & 000070) {
				cycles += 2 + cefacycles(opcode, sz, x1);
			}
			break;
		}
		if (op == 0x4AC0) {		/* TAS */
			cycles += 4;
			if (opcode & 000070) {
				cycles += 9 + cefacycles(opcode, sz, x1);
			}
			break;
		}
		switch(op & 0xFF00) {
		case 0x4800:	/* NBCD */
			cycles += 6 +fefacycles(opcode, sz,x1);
			break;
 	        case 0x4400:	/* NEG */
		case 0x4000:	/* NEGX */
		case 0x4600:	/* NOT */
			cycles += 3;
			if (opcode & 000070) {
				cycles += 3 + fefacycles(opcode, sz, x1);
			}
			break;
		case 0x4A00:	/* TST */
			cycles += 3 + fefacycles(opcode, sz, x1);
			break;
		}
		break;

	case S_TYP8:	/* JMP, JSR, LEA, PEA */
		switch(op) {
		case 0x4E80:	cycles += 4;	/* JSR - 11 */
		case 0x4EC0:	cycles += 7;	/* JMP - 7 */
			cycles += jefacycles(opcode, sz, x1);
			break;
		case 0x4840:	cycles += 3;	/* PEA - 6 */
		case 0x41C0:	cycles += 3;	/* LEA - 3 */
			cycles += cefacycles(opcode, sz, x1);
			break;
		}

	case S_SHFT:	/* ASL, ASR, LSL, LSR, ROL, ROR, ROXL, ROXL */
		if ((opcode & 0x00C0) == 0x00C0) {	/* Memory Shifts */
			cycles += fefacycles(opcode, sz, x1);
			ix1 = ((opcode & 0x0600) >> 9) | ((opcode & 0x0100) >> 6);
			ix2 = 1;
		} else {				/* Register Shifts */
			if ((opcode & 0x0038) == 0x0028) {
				cycles += 2;		/* LSL/LSR Dynamic */
			}
			ix1 = ((opcode & 0x0100) >> 6) | ((opcode & 0x0018) >> 3);
			ix2 = 0;
		}
		cycles += shrocyc[ix1][ix2];
		break;

	case S_BCC:	/* Bcc */
	case S_DBCC:	/* DBcc */
		if ((op & 0xFF00) == 0x6000) {	/* BRA */
			cycles += 9;
		} else
		if ((op & 0xFF00) == 0x6100) {	/* BSR */
			cycles += 13;
		} else
		if ((op & 0xF000) == 0x6000) {	/* BCC */
			cycles += 9;
		} else
		if ((op & 0xF000) == 0x5000) {	/* DBCC */
			cycles += 10;
		} else {
			xerr('q', "Internal Cycles Error");
		}
		break;

	case S_BIT:	/* BCHG, BCLR, BSET, BTST */
		cycles += 5;
		if ((opcode & 000070) != 0) {	/* X,<ea> */
			if (opcode & 0x0100) {	/* Dn,<ea> */
				cycles += fefacycles(opcode, sz, x2);
			} else {		/* #,<ea> */
				cycles += fiwefacycles(opcode, sz, x2);
			}
		}
		break;

	case S_MOVE:	/* MOVE */
		if ((opcode & 0xFFF0) == 0x4E60) {	/* MOVE USP */
			cycles += 3;
			break;
		}
		ix1 = opcode & 0xFFC0;
		if (ix1 == 0x42C0) {	/* MOVE From CCR */
			cycles += 5 + fefacycles(opcode, sz, x2);
			break;
		}
		if (ix1 == 0x44C0) {	/* MOVE To CCR */
			cycles += 5 + fefacycles(opcode, sz, x1);
			break;
		}
		if (ix1 == 0x40C0) {	/* MOVE From SR */
			cycles += 11 + fefacycles(opcode, sz, x2);
			break;
		}
		if (ix1 == 0x46C0) {	/* MOVE To SR */
			cycles += 11 + fefacycles(opcode, sz, x1);
			break;
		}
		/* MOVE <ea><ea> Fall Through */
	case S_MOVEA:	/* MOVEA */
		ix1 = xefaindx(opcode, sz, x1);		/* SRC */
		/* Reorder DST (Reg/Mode => Mode/Reg) */
		ix2 = xefaindx(((opcode & 0x0E00) >> 9) | ((opcode & 0x01C0) >> 3), sz, x2);	/* DST */
		cycles += mvefa[ix1][ix2];
		break;

	case S_MOVEC:	/* MOVEC */
		if (opcode & 1) {
			cycles += 13;
		} else {
			cycles += 7;
		}
		break;

	case S_MOVEM:	/* MOVEM */
		if (opcode & 0x0400) {	/* MOVEM list,<ea> */
			cycles += 5 + (3 * rc) + cefacycles(opcode, sz, x2);
		} else {		/* MOVEM <ea>,list */
			cycles += 9 + (4 * rc) + cefacycles(opcode, sz, x1);
		}
		break;

	case S_MOVEP:	/* MOVEP */
		switch(opcode & 0x00C0) {
		case 0x0000:	cycles += 12;	break;	/* MOVEP.W (d16,An),Dn */
		case 0x0040:	cycles += 18;	break;	/* MOVEP.L (d16,An),Dn */
		case 0x0080:	cycles += 11;	break;	/* MOVEP.W Dn,(d16,An) */
		case 0x00C0:	cycles += 17;	break;	/* MOVEP.L Dn,(d16,An) */
		}
		break;

	case S_MOVEQ:	/* MOVEQ */
		cycles += 3;
		break;

	case S_MOVES:	/* MOVES Rn,<ea>  Or  MOVES <ea>,Rn */
		if (op2 & 0x0800) {
			cycles += 7 + cefacycles(opcode, sz, x2);
		} else {
			cycles += 8 + cefacycles(opcode, sz, x1);
		}
		break;

	case S_CMP:	/* CMP */
		if ((opcode & 0xF0C0) == 0xB0C0) {	/* CMPA */
			cycles += 4 + fefacycles(opcode, sz, x1);
			break;
		}
		if ((opcode & 0xF138) == 0xB108) {	/* CMPM */
			cycles += 3 + 2*fefacycles(0x08, sz, 0);
			break;
		}
		if ((opcode & 0xFF00) == 0x0C00) {	/* CMPI */
			cycles += 3 + fiefacycles(opcode, sz, x2);
			break;
		}
		cycles += 3 + fefacycles(opcode, sz , x1);
		break;

	case S_CMPM:	/* CMPM */
		cycles += 10;
		break;

	case S_PKUK:	/* PACK, UNPK */
		switch(opcode & 0xF1F8) {
		case 0x8140:	cycles += 7;	break;	/* PACK Dx,Dy,# */
		case 0x8148:	cycles += 13;	break;	/* PACK -(Ax),-(Ay),# */
		case 0x8180:	cycles += 9;	break;	/* UNPK Dx,Dy,# */
		case 0x8188:	cycles += 13;	break;	/* UNPK -(Ax),-(Ay),# */
		}
		break;

	case S_BF:	/* BF... <ea> {X:X} */
		switch(opcode & 0xFFC0) {
		case 0xE8C0:	/* BFTST */
			cycles += 7;
			if (opcode & 000070) {
				cycles += 9 + ciefacycles(opcode, sz, x1);
			}
			break;
		case 0xEAC0:	/* BFCHG */
		case 0xECC0:	/* BFCLR */
		case 0xEEC0:	/* BFSET */
			cycles += 12;
			if (opcode & 000070) {
				cycles += 12 + ciefacycles(opcode, sz, x1);
			}
			break;
		case 0xE9C0:	/* BFEXTU */
		case 0xEBC0:	/* BFEXTS */
			cycles += 8;
			if (opcode & 000070) {
				cycles += 10;
			}
			break;
		case 0xEDC0:	/* BFFFO */
			cycles += 18;
			if (opcode & 000070) {
				cycles += 14;
			}
			break;
		case 0xEFC0:	/* BFINS */
			cycles += 10;
			if (opcode & 000070) {
				cycles += 11;
			}
			break;
		}
		break;

	case S_CAS:	/* CAS */
		cycles += 16 + ciefacycles(opcode, sz, x1);
		break;

	case S_CHK:	/* CHK */
		cycles += 8 + fefacycles(opcode, sz, x1);
		break;

	case S_CHK2:	/* CHK2 */
		cycles += 18 + fiefacycles(opcode, sz, x1);
		break;

	case S_CMP2:
		break;

	case S_CALLM:	cycles += 71;	break;	/* CALLM */

	case S_CAS2:	cycles += 28;	break;	/* CAS */

	case S_BKPT:	cycles += 10;	break;	/* BKPT */

	case S_EXG:	cycles += 3;	break;	/* EXG */

	case S_EXTB:				/* EXTB */
	case S_EXT:	cycles += 4;	break;	/* EXT */

	case S_LINK:	cycles += (sz == A_L) ? 10 : 7;	break;	/* LINK */

	case S_RTM:	cycles += 35;	break;	/* RTM */

	case S_STOP:	cycles += 8;	break;	/* STOP */

	case S_SWAP:	cycles += 4;	break;	/* SWAP */

	case S_TRAP:	cycles += 27;	break;	/* TRAP */

	case S_TRPC:	cycles += 33;	break;	/* TRAPcc */

	case S_UNLK:	cycles += 7;	break;	/* UNLK */
		
	case S_INH:
		switch(op) {
		case 0x4AFC:	cycles += 27;	break;	/* ILLEGAL */
		case 0x4E71:	cycles += 3;	break;	/* NOP */
		case 0x4E70:	cycles += 519;	break;	/* RESET */
		case 0x4E74:	cycles += 12;	break;	/* RTD */
		case 0x4E73:	cycles += 24;	break;	/* RTE */
		case 0x4E77:	cycles += 15;	break;	/* RTR */
		case 0x4E75:	cycles += 12;	break;	/* RTS */
		case 0x4E76:	cycles += 32;	break;	/* TRAPV */
		default:	break;
		}
		break;

	case S_M68K:	/* Verification Of Addressing Modes */
		cycles += fefacycles(opcode, sz, x2);
		break;

	default:
		cycles = OPCY_ERR;
		break;
	}

	return(cycles);
}

/*
 *****-----*****-----*****-----*****-----*****-----*****-----*****
 *
 * End Of 68020 Instruction Addressing Mode MicroCycle Timing
 *
 *****-----*****-----*****-----*****-----*****-----*****-----*****
 */

/*
 * 68881/68882 Instruction Addressing Mode MicroCycle Timing
 *   Taken from:
 *		MC68881/MC68882 Floating-Point
 *		Coprocessor User's Manual
 *		Second Edition
 *		Motorola, Inc, C 1989
 */

/*
 * Floating Point Effective Address Times
 * (Worst Case)
 */
static unsigned char T8_1[23] = {
/*  0 */   0,	/* Dn */
/*  1 */   0,	/* An */
/*  2 */   2,	/* (An) */
/*  3 */   6,	/* (An)+ */
/*  4 */   6,	/* -(An) */
/*  5 */   3,	/* d16(An), (d16,An), d16(PC), or (d16,PC) */
/*  6 */   3,	/* (xxx).W */
/*  7 */   5,	/* (xxx).L */
/*  8 */   0,	/* #<data> */
/*  9 */   5,	/* d8(An,Xn), (d8,An,Xn), d8(PC,Xn), or (d8(PC,Xn) */
/* 10 */   7,	/* (d16,An,Xn) or (d16,PC,Xn) */
/*
 * B = Base Address; 0, An, PC, Xn, An + Xn, or PC + Xn
 * I = Insex; 0 or Xn
 */
/* 11 */   7,	/* (B) */
/* 12 */   9,	/* (d16,B) */
/* 13 */  16,	/* (d32,B) */
/* 14 */  12,	/* ([B],I) */
/* 15 */  12,	/* ([B],I,d16) */
/* 16 */  15,	/* ([B],I,d32) */
/* 17 */  14,	/* ([d16,B],I) */
/* 18 */  15,	/* ([d16,B],I,d16) */
/* 19 */  17,	/* ([d16,B],I,d32) */
/* 20 */  21,	/* ([d32,B],I) */
/* 21 */  21,	/* ([d32,B],I,d16) */
/* 22 */  24	/* ([d32,B],I,d32) */
};

/*
 * Decoding Matrix
 */
static unsigned char fidx[4][8] = {
/* INDEX */   /* 0    1    2    3    4    5    6    7 */
/* BDSIZ */   /* -    -    -    -    -    -    -    - */
/*   0   */  {  10,   0,   0,   0,   0,   0,   0,   0  },
/*   1   */  {  11,  14,  15,  16,   0,  14,  15,  16  },
/*   2   */  {  12,  17,  18,  19,   0,  17,  18,  19  },
/*   3   */  {  13,  20,  21,  22,   0,  20,  21,  22  }
};

int
feacycles(xop, x1, x2)
int xop;
int x1, x2;
{
	int cycles;
	int t, v, x, bs, is;

	cycles = 0;
	t = xop & 070;
	v = xop & 007;
	x = x1 | x2;
	bs = (x & 0x0030) >> 4;
	is = (x & 0x0007);
	switch(t) {
	default:
	case S_Dn:	cycles = T8_1[0];	break;
	case S_An:	cycles = T8_1[1];	break;
	case S_ARI:	cycles = T8_1[2];	break;
	case S_AINC:	cycles = T8_1[3];	break;
	case S_ADEC:	cycles = T8_1[4];	break;
	case S_ARID:	cycles = T8_1[5];	break;
	case 0x0060:
		if ((x & 0x0100) == 0) {
			cycles = T8_1[9];
		} else {
			cycles = T8_1[fidx[bs][is]];
		}
		break;
	case 0x0070:
		switch(t | v) {
		case S_SHRT:	cycles = T8_1[6];	break;
		case S_LONG:	cycles = T8_1[7];	break;
		case S_IMM:	cycles = T8_1[8];	break;
		case S_PCID:	cycles = T8_1[5];	break;
		case 0x0073:
			if ((x & 0x0100) == 0) {
				cycles = T8_1[9];
			} else {
				cycles = T8_1[fidx[bs][is]];
			}
			break;
		default:
			xerr('q', "Internal 'feacycles()' Error");
			break;
		}
	}

	return(cycles);
}

/*
 * MC68881 Floating Point Execution Cycles
 */
static unsigned short T8_2[64][6] = {
/*  0 */  {	33,	60,	52,	58,	56,	870	},	/* FMOVE To FPn */
/*  1 */  {	55,	82,	74,	80,	78,	892	},	/* FINT */
/*  2 */  {	687,	714,	706,	712,	710,	1524	},	/* FSINH */
/*  3 */  {	55,	82,	74,	80,	78,	892	},	/* FINTRZ */
/*  4 */  {	107,	134,	126,	132,	130,	944	},	/* FSQRT */
/*  5 */  {	0,	0,	0,	0,	0,	0	},
/*  6 */  {	571,	598,	590,	596,	594,	1408	},	/* FLOGNP1 */
/*  7 */  {	0,	0,	0,	0,	0,	0	},
/*  8 */  {	545,	572,	564,	570,	568,	1382	},	/* FETOXM1 */
/*  9 */  {	661,	688,	680,	686,	684,	1498	},	/* FTANH */
/* 10 */  {	403,	430,	422,	428,	426,	1240	},	/* FATAN */
/* 11 */  {	0,	0,	0,	0,	0,	0	},
/* 12 */  {	581,	608,	600,	606,	604,	1418	},	/* FASIN */
/* 13 */  {	693,	720,	712,	718,	716,	1530	},	/* FATANH */
/* 14 */  {	391,	418,	410,	416,	414,	1228	},	/* FSIN */
/* 15 */  {	473,	500,	492,	498,	496,	1310	},	/* FTAN */
/* 16 */  {	497,	524,	516,	522,	520,	1334	},	/* FETOX */
/* 17 */  {	567,	594,	586,	592,	590,	1404	},	/* FTWOTOX */
/* 18 */  {	567,	594,	586,	592,	590,	1404	},	/* FTENTOX */
/* 19 */  {	0,	0,	0,	0,	0,	0	},
/* 20 */  {	525,	552,	544,	550,	548,	1362	},	/* FLOGN */
/* 21 */  {	581,	608,	600,	606,	604,	1418	},	/* FLOG10 */
/* 22 */  {	581,	608,	600,	606,	604,	1418	},	/* FLOG2 */
/* 23 */  {	0,	0,	0,	0,	0,	0	},
/* 24 */  {	35,	62,	54,	60,	58,	872	},	/* FABS */
/* 25 */  {	607,	634,	626,	632,	630,	1444	},	/* FCOSH */
/* 26 */  {	35,	62,	54,	60,	58,	872	},	/* FNEG */
/* 27 */  {	0,	0,	0,	0,	0,	0	},
/* 28 */  {	625,	652,	644,	650,	648,	1462	},	/* FACOS */
/* 29 */  {	391,	418,	410,	416,	414,	1228	},	/* FCOS */
/* 30 */  {	45,	72,	64,	70,	68,	882	},	/* FGETEXP */
/* 31 */  {	31,	58,	50,	56,	54,	868	},	/* FGETMAN */
/* 32 */  {	103,	132,	124,	130,	128,	940	},	/* FDIV */
/* 33 */  {	70,	99,	91,	97,	95,	907	},	/* FMOD */
/* 34 */  {	52,	80,	72,	78,	76,	888	},	/* FADD */
/* 35 */  {	71,	100,	92,	98,	96,	908	},	/* FMUL */
/* 36 */  {	69,	98,	90,	96,	94,	906	},	/* FSGLDIV */
/* 37 */  {	100,	129,	121,	127,	125,	937	},	/* FREM */
/* 38 */  {	41,	70,	62,	68,	66,	878	},	/* FSCALE */
/* 39 */  {	59,	88,	80,	86,	84,	896	},	/* FSGLMUL */
/* 40 */  {	51,	80,	72,	78,	76,	888	},	/* FSUB */
/* 41 */  {	292,	0,	0,	0,	0,	0	},	/* FRESTORE */
/* 42 */  {	288,	0,	0,	0,	0,	0	},	/* FSAVE */
/* 43 */  {	23,	0,	0,	0,	0,	0	},	/* FBcc */
/* 44 */  {	32,	0,	0,	0,	0,	0	},	/* FDBcc */
/* 45 */  {	25,	0,	0,	0,	0,	0	},	/* FScc */
/* 46 */  {	52,	0,	0,	0,	0,	0	},	/* FTRAPcc */
/* 47 */  {	19,	0,	0,	0,	0,	0	},	/* FNOP */
/* 48 */  {	451,	478,	470,	476,	474,	1288	},	/* FSINCOS */
/* 49 */  {	451,	478,	470,	476,	474,	1288	},	/* FSINCOS */
/* 50 */  {	451,	478,	470,	476,	474,	1288	},	/* FSINCOS */
/* 51 */  {	451,	478,	470,	476,	474,	1288	},	/* FSINCOS */
/* 52 */  {	451,	478,	470,	476,	474,	1288	},	/* FSINCOS */
/* 53 */  {	451,	478,	470,	476,	474,	1288	},	/* FSINCOS */
/* 54 */  {	451,	478,	470,	476,	474,	1288	},	/* FSINCOS */
/* 55 */  {	451,	478,	470,	476,	474,	1288	},	/* FSINCOS */
/* 56 */  {	33,	62,	54,	60,	58,	870	},	/* FCMP */
/* 57 */  {	0,	0,	0,	0,	0,	0	},
/* 58 */  {	33,	60,	52,	58,	56,	870	},	/* FTST */
/* 59 */  {	0,	0,	0,	0,	0,	0	},
/* 60 */  {	0,	0,	0,	0,	0,	0	},
/* 61 */  {	0,	100,	80,	86,	72,	2002	},	/* FMOVE To Memory */
/* 62 */  {	29,	0,	0,	0,	0,	0	},	/* FMOVECR */
/* 63 */  {	0,	0,	0,	0,	0,	0	}
};

/*
 * MC68882 Floating Point Execution Cycles
 */
static unsigned short T8_3[64][6] = {
/*  0 */  {	21,	48,	34,	40,	46,	891	},	/* FMOVE To FPn */
/*  1 */  {	58,	88,	71,	77,	83,	913	},	/* FINT */
/*  2 */  {	690,	720,	703,	709,	715,	1545	},	/* FSINH */
/*  3 */  {	58,	88,	71,	77,	83,	913	},	/* FINTRZ */
/*  4 */  {	110,	140,	123,	129,	135,	965	},	/* FSQRT */
/*  5 */  {	0,	0,	0,	0,	0,	0	},
/*  6 */  {	574,	604,	587,	593,	599,	1429	},	/* FLOGNP1 */
/*  7 */  {	0,	0,	0,	0,	0,	0	},
/*  8 */  {	548,	578,	561,	567,	573,	1403	},	/* FETOXM1 */
/*  9 */  {	664,	694,	677,	683,	689,	1519	},	/* FTANH */
/* 10 */  {	406,	436,	419,	425,	431,	1261	},	/* FATAN */
/* 11 */  {	0,	0,	0,	0,	0,	0	},
/* 12 */  {	584,	614,	597,	603,	609,	1439	},	/* FASIN */
/* 13 */  {	696,	726,	709,	715,	721,	1551	},	/* FATANH */
/* 14 */  {	394,	424,	407,	413,	419,	1249	},	/* FSIN */
/* 15 */  {	476,	506,	489,	495,	501,	1331	},	/* FTAN */
/* 16 */  {	500,	530,	513,	519,	525,	1355	},	/* FETOX */
/* 17 */  {	570,	600,	583,	589,	595,	1425	},	/* FTWOTOX */
/* 18 */  {	570,	600,	583,	589,	596,	1425	},	/* FTENTOX */
/* 19 */  {	0,	0,	0,	0,	0,	0	},
/* 20 */  {	528,	558,	541,	547,	553,	1383	},	/* FLOGN */
/* 21 */  {	584,	614,	597,	603,	609,	1439	},	/* FLOG10 */
/* 22 */  {	584,	614,	597,	603,	609,	1439	},	/* FLOG2 */
/* 23 */  {	0,	0,	0,	0,	0,	0	},
/* 24 */  {	38,	68,	51,	57,	63,	893	},	/* FABS */
/* 25 */  {	610,	640,	623,	629,	635,	1465	},	/* FCOSH */
/* 26 */  {	38,	68,	51,	57,	63,	893	},	/* FNEG */
/* 27 */  {	0,	0,	0,	0,	0,	0	},
/* 28 */  {	628,	658,	641,	647,	653,	1483	},	/* FACOS */
/* 29 */  {	394,	424,	407,	413,	419,	1249	},	/* FCOS */
/* 30 */  {	48,	78,	61,	67,	73,	9030	},	/* FGETEXP */
/* 31 */  {	34,	64,	47,	53,	59,	889	},	/* FGETMAN */
/* 32 */  {	108,	146,	121,	127,	133,	961	},	/* FDIV */
/* 33 */  {	75,	113,	88,	94,	100,	928	},	/* FMOD */
/* 34 */  {	56,	94,	69,	75,	81,	909	},	/* FADD */
/* 35 */  {	76,	114,	89,	95,	101,	929	},	/* FMUL */
/* 36 */  {	74,	112,	87,	93,	99,	927	},	/* FSGLDIV */
/* 37 */  {	105,	143,	118,	124,	130,	958	},	/* FREM */
/* 38 */  {	46,	84,	59,	65,	71,	899	},	/* FSCALE */
/* 39 */  {	64,	102,	77,	83,	90,	917	},	/* FSGLMUL */
/* 40 */  {	56,	94,	69,	75,	81,	909	},	/* FSUB */
/* 41 */  {	340,	0,	0,	0,	0,	0	},	/* FRESTORE */
/* 42 */  {	336,	0,	0,	0,	0,	0	},	/* FSAVE */
/* 43 */  {	23,	0,	0,	0,	0,	0	},	/* FBcc */
/* 44 */  {	32,	0,	0,	0,	0,	0	},	/* FDBcc */
/* 45 */  {	25,	0,	0,	0,	0,	0	},	/* FScc */
/* 46 */  {	52,	0,	0,	0,	0,	0	},	/* FTRAPcc */
/* 47 */  {	19,	0,	0,	0,	0,	0	},	/* FNOP */
/* 48 */  {	454,	484,	467,	473,	479,	1309	},	/* FSINCOS */
/* 49 */  {	454,	484,	467,	473,	479,	1309	},	/* FSINCOS */
/* 50 */  {	454,	484,	467,	473,	479,	1309	},	/* FSINCOS */
/* 51 */  {	454,	484,	467,	473,	479,	1309	},	/* FSINCOS */
/* 52 */  {	454,	484,	467,	473,	479,	1309	},	/* FSINCOS */
/* 53 */  {	454,	484,	467,	473,	479,	1309	},	/* FSINCOS */
/* 54 */  {	454,	484,	467,	473,	479,	1309	},	/* FSINCOS */
/* 55 */  {	454,	484,	467,	473,	479,	1309	},	/* FSINCOS */
/* 56 */  {	38,	76,	51,	57,	63,	891	},	/* FCMP */
/* 57 */  {	0,	0,	0,	0,	0,	0	},
/* 58 */  {	36,	66,	49,	55,	61,	891	},	/* FTST */
/* 59 */  {	0,	0,	0,	0,	0,	0	},
/* 60 */  {	0,	0,	0,	0,	0,	0	},
/* 61 */  {	0,	110,	38,	44,	50,	2006	},	/* FMOVE To Memory */
/* 62 */  {	32,	0,	0,	0,	0,	0	},	/* FMOVECR */
/* 63 */  {	0,	0,	0,	0,	0,	0	}
};

int
fppcycles(xop)
int xop;
{
	int cycles, src;

	if (xop & 0x4000) {
		switch((xop & 0x1C00) >> 10) {
		default:
		case F_B:
		case F_W:
		case F_L:	src = 1;	break;
		case F_S:	src = 2;	break;
		case F_D:	src = 3;	break;
		case F_X:	src = 4;	break;
		case F_P:	src = 5;	break;
		}
	} else {
		src = 0;
	}
	switch(flttyp) {
	default:
	case M_68881:	cycles = T8_2[xop & 0x007F][src];	break;
	case M_68882:	cycles = T8_3[xop & 0x007F][src];	break;
	}
	return(cycles);
}

/*
 * Determine Machine Cycles (Worst Case)
 */
int
mc6888xcycles(mp, op1, op2, x1, x2, rc, cycles)
struct mne *mp;
a_uint op1, op2;
int x1, x2, rc;
int cycles;
{
	int rf;
	int xop1, xop2;

	xop1 = (int) op1;
	xop2 = (int) op2;
	rf = mp->m_type;
	switch(rf) {

	case F_TYP1:	/* FABS <ea>,FPn  /  FPm,FPn  /  Fpn */
	case F_TYP2:	/* FADD <ea>,Fpn  /  FPm,FPn */
	case F_TST:	/* FTST <ea> / FPn */
	case F_SNCS:	/* FSINCOS <ea>,FPc:FPs  /  FSINCOC FPn,FPc:FPs */
		cycles += fppcycles(xop2);
		cycles += feacycles(xop1, x1, x2);
		break;

	case F_MOV:
		if (((xop1 & 0xF100) == 0xF000) && ((xop2 & 0xC000) == 0x8000)) {
			/* FMOVE.L <ea>,FPcr  /  FPcr,<ea> */
			cycles += fppcycles((F_L << 10) | 62);
			cycles += feacycles(xop1, x1, x2);
			break;
		} else {
			/* FMOVE <ea>,FPn  /  FPn,<ea> */
			if (xop2 & 0x2000) {
				cycles += fppcycles(xop2 | 61);	/* Fpn,<ea> */
			} else {
				cycles += fppcycles(xop2);	/* <ea>,FPn */
			}
			cycles += feacycles(xop1, x1, x2);
		}
		break;

	case F_MVCR:	/* FMOVECR.X  #ccc,FPn */
		switch(flttyp) {
		default:
		case M_68881:	cycles += T8_2[62][0];	break;
		case M_68882:	cycles += T8_3[62][0];	break;
		}
		break;

	case F_MOVM:	/* FMOVEM */
		if ((xop2 & 0xC000) == 0x8000) {
			cycles += (30 + rc);
		} else {
			cycles += (54 + (3 * rc));
		}
		cycles += feacycles(xop2, x1, x2);
		break;

	case F_SCC:	/* FScc <ea> */
		switch(flttyp) {
		default:
		case M_68881:	cycles += T8_2[44][0];	break;
		case M_68882:	cycles += T8_3[44][0];	break;
		}
		cycles += feacycles(xop1, x1, x2);
		break;

	case F_DCC:	/* FDBcc Dn,Label */
		switch(flttyp) {
		default:
		case M_68881:	cycles += T8_2[45][0];	break;
		case M_68882:	cycles += T8_3[45][0];	break;
		}
		cycles += feacycles(xop1, x1, x2);
		break;

	case F_TCC:	/* FTRAPcc Label */
		switch(flttyp) {
		default:
		case M_68881:	cycles += T8_2[46][0];	break;
		case M_68882:	cycles += T8_3[46][0];	break;
		}
		break;

	case F_BCC:	/* FBcc Label */
		switch(flttyp) {
		default:
		case M_68881:	cycles += T8_2[43][0];	break;
		case M_68882:	cycles += T8_3[43][0];	break;
		}
		break;

	case F_NOP:	/* FNOP */
		switch(flttyp) {
		default:
		case M_68881:	cycles += T8_2[47][0];	break;
		case M_68882:	cycles += T8_3[47][0];	break;
		}
		break;

	case F_SVRS:	/* FSAVE / FRESTORE */
		switch(mp->m_valu) {
		default:
		case 0xF140:	/* FRESTORE */
			switch(flttyp) {
			default:
			case M_68881:	cycles += T8_2[41][0];	break;
			case M_68882:	cycles += T8_3[41][0];	break;
			}
			break;
		case 0xF100:	/* FSAVE */
			switch(flttyp) {
			default:
			case M_68881:	cycles += T8_2[42][0];	break;
			case M_68882:	cycles += T8_3[42][0];	break;
			}
			break;
		}
		/* eacycles() */
		break;

	default:
		opcycles = OPCY_ERR;
		xerr('o', "Internal Cycles Error");
		break;
	}

	return(cycles);
}

/*
 *****-----*****-----*****-----*****-----*****-----*****-----*****
 *
 * End Of 68881/68882 Instruction Addressing Mode MicroCycle Timing
 *
 *****-----*****-----*****-----*****-----*****-----*****-----*****
 */

