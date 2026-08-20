/* m370mch.c */

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
#include "m370.h"

char	*cpu	= "Texas Instruments TMS370 Series";
char	*dsft	= "asm";

/*
 * Opcode Cycle Definitions
 */
#define	OPCY_SDP	((char) (0xFF))
#define	OPCY_ERR	((char) (0xFE))

#define	OPCY_NONE	((char) (0x80))
#define	OPCY_MASK	((char) (0x7F))


#define	UN	((char) (OPCY_NONE | 0x00))

/*
 * tms370 Cycle Count
 *
 *	opcycles = tms370[opcode]
 */
static char tms370[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   9, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
/*10*/  UN,UN, 7, 7, 7, 7,11,11, 7, 7, 7, 7,46, 7, 9, 9,
/*20*/  UN, 8, 6, 6, 6, 6,10,10, 6, 6, 6, 6,45, 6, 8, 8,
/*30*/  UN,UN, 7, 7, 7, 7,11,11, 7, 7, 7, 7,46, 7, 9, 9,
/*40*/  UN,UN, 9, 9, 9, 9,13,13, 9, 9, 9, 9,48, 9,11,11,
/*50*/  UN, 8, 6, 6, 6, 6,10,10, 6, 6, 6, 6,45, 6, 8, 8,
/*60*/  UN,UN, 8, 8, 8, 8,12,12, 8, 8, 8, 8,47, 8,10,10,
/*70*/  11,10, 8, 8, 8, 8,12,12, 8, 8, 8, 8,47, 8,10,10,
/*80*/   8,UN,UN, 9, 9, 9,13,12,13, 9,10,10,11,11,13,15,
/*90*/  UN, 7,UN, 9, 9, 9,12,12,12, 8, 9, 9,10,10,12,14,
/*A0*/  UN,UN,10,10,10,10,13,13,15,10,12,12,13,13,15,17,
/*B0*/   9,UN, 8, 8, 8, 8,10,11, 9, 9,12, 8, 8, 8, 8, 8,
/*C0*/   9,UN, 8, 8, 8, 8,10,11, 9, 9,12, 8, 8, 8, 8, 8,
/*D0*/   7, 7, 6, 6, 6, 6, 8, 9, 7, 7,10,10, 6, 6, 6, 6,
/*E0*/  14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,
/*F0*/   6, 7, 7, 8,UN,UN, 6,10, 7, 9,12, 8, 8, 7, 8, 7
};

/*
 * Process machine ops.
 */
void
machine(struct mne *mp)
{
	int op, ofst;
	struct expr e1, e2, e3;
	int t1, v1, t2, v2;

	/*
	 * Using Internal Format
	 * For Cycle Counting
	 */
	opcycles = OPCY_NONE;

	clrexpr(&e1);
	clrexpr(&e2);
	clrexpr(&e3);
	op = (int) mp->m_valu;
	switch (mp->m_type) {

	/* AND, OR, XOR, BTJO, BTJZ */
	case I_TYP1:
		t1 = addr(&e1);
		v1 = aindx;
		comma(1);
		t2 = addr(&e2);
		v2 = aindx;
		if ((op == 0x16) || (op == 0x17)) {	/* BTJO, BTJZ */
			comma(1);
			expr(&e3);
		}
		switch(0) {
		case 0:
			if ((t1 == S_R) && (t2 == S_A)) {	/* Rn,A */
				outab(op + 0x00);
				outab(v1);
				break;
			}
			if ((t1 == S_IMM) && (t2 == S_A)) {	/* #N,A */
				outab(op + 0x10);
				outrb(&e1, R_OVRF);
				break;
			}
			if ((t1 == S_R) && (t2 == S_B)) {	/* Rn,B */
				outab(op + 0x20);
				outab(v1);
				break;
			}
			if ((t1 == S_R) && (t2 == S_R)) {	/* Rn,Rn */
				outab(op + 0x30);
				outab(v1);
				outab(v2);
				break;
			}
			if ((t1 == S_IMM) && (t2 == S_B)) {	/* #N,A */
				outab(op + 0x40);
				outrb(&e1, R_OVRF);
				break;
			}
			if ((t1 == S_B) && (t2 == S_A)) {	/* B,A */
				outab(op + 0x50);
				break;
			}
			if ((t1 == S_IMM) && (t2 == S_R)) {	/* #N,Rn */
				outab(op + 0x60);
				outrb(&e1, R_OVRF);
				outab(v2);
				break;
			}
			if ((t1 == S_A) && (t2 == S_P)) {	/* A,Pn */
				outab(op + 0x70);
				outab(v2);
				break;
			}
			if ((t1 == S_B) && (t2 == S_P)) {	/* B,Pn */
				outab(op + 0x80);
				outab(v2);
				break;
			}
			if ((t1 == S_IMM) && (t2 == S_P)) {	/* #N,Pn */
				outab(op + 0x90);
				outrb(&e1, R_OVRF);
				outab(v2);
				break;
			}
			aerr();
			break;
				
		default:	aerr();		break;
		}
		if ((op == 0x16) || (op == 0x17)) {	/* BTJO, BTJZ */
			if (mchpcr(&e3, &ofst, 1)) {
				if ((ofst < -128) || (ofst > 127))
					xerr('a', "Short Relative Address Is Out Of Range");
				outab(ofst);
			} else {
				outrb(&e3, R_PCR);
			}
			if (e3.e_mode != S_USER)
				rerr();
		}
		break;


	/* ADD, ADC, DUB, SBB, MPY, CMP, DAC, DSB */
	case I_TYP2:
		t1 = addr(&e1);
		v1 = aindx;
		comma(1);
		t2 = addr(&e2);
		v2 = aindx;
		if ((t1 == S_R) && (t2 == S_A)) {	/* Rn,A */
			outab(op + 0x00);
			outab(v1);
			break;
		}
		if ((t1 == S_IMM) && (t2 == S_A)) {	/* #N,A */
			outab(op + 0x10);
			outrb(&e1, R_OVRF);
			break;
		}
		if ((t1 == S_R) && (t2 == S_B)) {	/* Rn,B */
			outab(op + 0x20);
			outab(v1);
			break;
		}
		if ((t1 == S_R) && (t2 == S_R)) {	/* Rn,Rn */
			outab(op + 0x30);
			outab(v1);
			outab(v2);
			break;
		}
		if ((t1 == S_IMM) && (t2 == S_B)) {	/* #N,B */
			outab(op + 0x40);
			outrb(&e1, R_OVRF);
			break;
		}
		if ((t1 == S_B) && (t2 == S_A)) {	/* B,A */
			outab(op + 0x50);
			break;
		}
		if ((t1 == S_IMM) && (t2 == S_R)) {	/* #N,Rn */
			outab(op + 0x60);
			outrb(&e1, R_OVRF);
			outab(v2);
			break;
		}
		if (op == 0x1D) {	/* CMP ---,--- */
			if ((t1 == S_EXT) && (t2 == S_A)) {	/* N,A */
				outab(op + 0x70);
				outrw(&e1, 0);
				break;
			}
			if ((t1 == S_IR) && (t2 == S_A)) {	/* (Rn),A */
				outab(op + 0x80);
				outab(v1);
				break;
			}
			if ((t1 == S_NB) && (t2 == S_A)) {	/* N(B),A */
				outab(op + 0x90);	
				outrw(&e1,0);
				break;
			}
			if ((t1 == S_NSP) && (t2 == S_A)) {	/* N(SP),A */
				outab(0xF3);
				outrb(&e1, R_OVRF);
				break;
			}
			if ((t1 == S_IR) && (t2 == S_A)) {	/* @Rn,A */
				outaw(0xF4ED);	opcycles = 18;
				outab(v1);	break;
			}
			if ((t1 == S_NR) && (t2 == S_A)) {	/* N(Rn),A */
				outaw(0xF4ED);	opcycles = 18;
				outrb(&e1, R_OVRF);
				outab(v1);	break;
			}
		}
		aerr();
		break;


	/* DEC, INC, INV, CLR, XCHB, SWAP, PUSH */
	/* POP, DJNZ, COMPL, RR, RRC, RL, RLC */
	case I_TYP3:
		t1 = addr(&e1);
		v1 = aindx;
		if (op == 0xBA) {	/* DJNZ */
			comma(1);
			expr(&e2);
		}
		switch(t1) {
		case S_A:	outab(op + 0x00);	break;
		case S_B:	outab(op + 0x10);	break;
		case S_ST:
			if (op == 0xB8) {	/* PUSH ST */
				op = 0xFB;
				outab(op);	break;
			}
			if (op == 0xB9) {	/* POP ST */
				op = 0xFC;
				outab(op);	break;
			}
			xerr('a', "Only PUSH ST and POP ST are Legal");
			break;
		case S_R:	outab(op + 0x20);
				outab(v1);		break;
		default:	aerr();			break;
		}
		if (op == 0xBA) {	/* DJNZ */
			if (mchpcr(&e2, &ofst, 1)) {
				if ((ofst < -128) || (ofst > 127))
					xerr('a', "Short Relative Address Is Out Of Range");
				outab(ofst);
			} else {
				outrb(&e2, R_PCR);
			}
			if (e2.e_mode != S_USER)
				rerr();
			break;
		}
		break;

	/* MOV */
	case I_MOV:
		t1 = addr(&e1);
		v1 = aindx;
		comma(1);
		t2 = addr(&e2);
		v2 = aindx;
		if (t1 == S_A) {
			if (t2 == S_B) {	/* A,B */
				outab(0xC0);	break;
			}
			if (t2 == S_R) {	/* A,Rn */
				outab(0xD0);
				outab(v2);	break;
			}
			if (t2 == S_P) {	/* A,Pn */
				outab(0x21);
				outab(v2);	break;
			}
			if (t2 == S_IR) {	/* A,@Rn */
				outab(0x9B);
				outab(v2);	break;
			}
			if (t2 == S_EXT) {	/* A,label */
				outab(0x8B);
				outrw(&e2, 0);	break;
			}
			if (t2 == S_NB) {	/* A,N(B) */
				outab(0xAB);
				outrw(&e2, 0);	break;
			}
			if (t2 == S_NSP) {	/* A,N(SP) */
				outab(0xF2);
				outrb(&e2, R_SGND);	break;
			}
			if (t2 == S_NR) {	/* A,N(Rn) */
				outaw(0xF4EB);	opcycles = 16;
				outrb(&e2, R_SGND);
				outab(v2);	break;
			}
			aerr();
			break;
		}
		if (t2 == S_A) {
			if (t1 == S_B) {	/* B,A */
				outab(0x62);	break;
			}
			if (t1 == S_R) {	/* Rn,A */
				outab(0x12);
				outab(v1);	break;
			}
			if (t1 == S_IMM) {	/* #N,A */
				outab(0x22);
				outrb(&e1, R_SGND);	break;
			}
			if (t1 == S_P) {	/* Pn,A */
				outab(0x80);
				outab(v1);	break;
			}
			if (t1 == S_IR) {	/* @Rn,A */
				outab(0x9A);
				outab(v1);	break;
			}
			if (t1 == S_EXT) {	/* label,A */
				outab(0x8A);
				outrw(&e1, 0);	break;
			}
			if (t1 == S_NB) {	/* N(B),A */
				outab(0xAA);
				outrw(&e1, 0);	break;
			}
			if (t1 == S_NSP) {	/* off8(SP),A */
				outab(0xF1);
				outrb(&e1, R_SGND);	break;
			}
			if (t1 == S_NR) {	/* off8(Rn),A */
				outaw(0xF4EA);	opcycles = 17;
				outrb(&e1, R_OVRF);
				outab(v1);	break;
			}
			aerr();
			break;
		}
		if (t1 == S_B) {
			if (t2 == S_R) {	/* B,Rn */
				outab(0xD1);
				outab(v2);	break;
			}
			if (t2 == S_P) {	/* B,Pn */
				outab(0x51);
				outab(v2);	break;
			}
			aerr();
			break;
		}
		if (t2 == S_B) {
			if (t1 == S_R) {	/* Rn,B */
				outab(0x32);
				outab(v1);	break;
			}
			if (t1 == S_IMM) {	/* #N,B */
				outab(0x52);
				outrb(&e1, R_OVRF);	break;
			}
			if (t1 == S_P) {	/* Pn,B */
				outab(0x91);
				outab(v1);	break;
			}
			aerr();
			break;
		}
		if (t2 == S_R) {
			if (t1 == S_R) {	/* Rn,Rn */
				outab(0x42);
				outab(v1);	outab(v2);	break;
			}
			if (t1 == S_IMM) {	/* #N,Rn */
				outab(0x72);
				outrb(&e1, R_OVRF);
				outab(v2);	break;
			}
			if (t1 == S_P) {	/* Pn,Rn */
				outab(0xA2);	/* Reverse Arguments */
				outab(v2);	outab(v1);	break;
			}
			aerr();
			break;
		}
		if (t2 == S_P) {
			if (t1 == S_R) {	/* Rn,Pn */
				outab(0x71);	/* Reverse Arguments */
				outab(v2);	outab(v1);	break;
			}
			if (t1 == S_IMM) {	/* #N,Pn */
				outab(0xF7);
				outrb(&e1, R_OVRF);
				outab(v2);	break;
			}
			aerr();
			break;
		}
		aerr();
		break;

	/* MOVW */
	case I_MOVW:
		t1 = addr(&e1);
		v1 = aindx;
		comma(1);
		t2 = addr(&e2);
		v2 = aindx;
		if (t2 == S_R) {
			switch(t1) {
			case S_IMM:	/* MOVW #N,Rn */
				outab(op + 0x00);
				outrw(&e1, 0);
				outab(v2);
				break;
			case S_R:	/* MOVW Rn,Rn */
				outab(op + 0x10);
				outab(v1);
				outab(v2);
				break;
			case S_NB:	/* MOVW #N(B),Rn */
				outab(op + 0x20);
				outrw(&e1, 0);
				outab(v2);
				break;
			case S_NR:	/* MOVW #N(Rn),Rn */
				outaw(0xF4E8);	opcycles = 20;
				outrb(&e1, R_OVRF);	outab(v1);
				outab(v2);
				break;
			default:
				aerr();
				break;
			}
			break;
		}
		aerr();
		break;

	/* DIV */
	case I_DIV:	/* Rn,A */
		t1 = addr(&e1);
		v1 = aindx;
		comma(1);
		t2 = addr(&e2);
		v2 = aindx;
		if ((t1 == S_R) && (t2 == S_A)) {
			outaw(op);	opcycles = 63;
			outab(v1);
			break;
		}
		aerr();
		break;

 	/* INCW */
	case I_INCW:	/* #N,Rn */
		t1 = addr(&e1);
		v1 = aindx;
		comma(1);
		t2 = addr(&e2);
		v2 = aindx;
		if ((t1 == S_IMM) && (t2 == S_R)) {
			outab(op);
			outrb(&e1, R_OVRF);
			outab(v2);
			break;
		}
		aerr();
		break;

	/* JMP, JN, JEQ, JZ, JC, JP, JPZ, JNE, JNZ */
	/* JNC, JV, JL, JLE, JHS, JNV, JGE, JG, JLO */
	case I_JMP:	/* off8 */
		expr(&e1);
		outab(op);
		if (mchpcr(&e1, &ofst, 1)) {
			if ((ofst < -128) || (ofst > 127))
				xerr('a', "Short Relative Address Is Out Of Range");
			outab(ofst);
		} else {
			outrb(&e1, R_PCR);
		}
		if (e1.e_mode != S_USER)
			rerr();
		break;

	/* CALL, BR */
	case I_CALL:
		t1 = addr(&e1);
		v1 = aindx;
		switch(t1) {
		case S_EXT:	/* Label */
			outab(op + 0x00);
			outrw(&e1, 0);
			break;
		case S_IR:	/* @Rn */
			outab(op + 0x10);
			outab(v1);
			break;
		case S_NB:	/* Label(B) */
			outab(op + 0x20);
			outrw(&e1, 0);
			break;
		case S_NR:	/* off8(Rn) */
			if (op == 0x8C) {	/* BR */
				outaw(0xF4EC);	opcycles = 16;
			}
			if (op == 0x8E) {	/* CALL */
				outaw(0xF4EE);	opcycles = 20;
			}
			outrb(&e1, R_SGND);
			outab(v1);
			break;
		default:
			aerr();
			break;
		}
		break;

	/* CALLR, JMPL */
	case I_CALLR:
		t1 = addr(&e1);
		v1 = aindx;
		switch(t1) {
		case S_EXT:	/* N    / Label    */
		case S_NB:	/* N(B) / Label(B) */
			if (t1 == S_EXT) outab(op + 0x00);
			if (t1 == S_NB)  outab(op + 0x20);
			if (mchpcr(&e1, &ofst, 2)) {
				outaw(ofst);
			} else {
				outrw(&e1, R_PCR);
			}
			break;
		case S_IMM:	/* #N    / #Label    */
		case S_AEXT:	/* *N    / *Label    */
		case S_ANB:	/* *N(B) / *Label(B) */
			if (t1 == S_IMM)  outab(op + 0x00);
			if (t1 == S_AEXT) outab(op + 0x00);
			if (t1 == S_ANB)  outab(op + 0x20);
			outrw(&e1, 0);
			break;
		case S_IR:	/* @Rn */
			outab(op + 0x10);
			outab(v1);
			break;
		case S_NR:	/* off8(Rn) */
			switch(op) {
			case 0x89:	outaw(0xF4E9);	/* JMPL */
					opcycles = 16;	 break;
			case 0x8F:	outaw(0xF4EF);	/* CALLR */
					opcycles = 22;	break;
			default:	break;
			}
			outrb(&e1, R_SGND);
			outab(v1);
			break;
		default:
			aerr();
			break;
		}
		break;

	/* TRAP */
	case I_TRAP:
		/* Make Argument Globally Compatible */
		exprps("15 - (", &e1, ")");
		/* Output Result */
		outrbm(&e1, M_TRAP | R_MBRO, op);
		break;

	/* LDST */
	case I_LDST:
		expr(&e1);
		outab(op);
		outrb(&e1, R_USGN);
		break;

	/* CLRC, TSTA, IDLE, SETC, RTS, RTI */
	/* LDSP, STSP, NOP */
	case I_INH:
		outab(op);
		break;

	/* DINT, EINT, EINTH, EINTL */
	case I_INH2:
		outaw(op);
		break;

	/* SBIT0, SBIT1, CMPBIT  #iop8,Rn / #iop8,Pn */
	/* JBIT1, JBIT0  #iop8,Rn,label / #iop8,Pn,label */
	case I_BITS:
		/* Make Argument Globally Compatible */
		if (op == 0x03) {	/* SBIT0 */
			exprps("~(1 << ((", &e1, ") & 7))");
		} else {		/* SBIT1, CMPBIT, JBIT0, JBIT1 */
			exprps("1 << ((", &e1, ") & 7)");
		}
		comma(1);
		t2 = addr(&e2);
		v2 = aindx;
		/* JBIT0, JBIT1 */
		if ((op == 0x06) || (op == 0x07)) {
			comma(1);
			expr(&e3);
		}
		switch(t2) {
		case S_R:	outab(op | 0x70);	break;
		case S_P:	outab(op | 0xA0);	break;
		default:	aerr();			break;
		}
		outrb(&e1, 0);
		outab(v2);
		/* JBIT0, JBIT1 */
		if ((op == 0x06) || (op == 0x07)) {
			if (mchpcr(&e3, &ofst, 1)) {
				outab(ofst);
			} else {
				outrb(&e3, R_PCR);
			}
		}
		break;

	default:
		opcycles = OPCY_ERR;
		xerr('o', "Internal Opcode Error.");
		break;
	}
	if (opcycles == OPCY_NONE) {
		opcycles = tms370[cb[0] & 0xFF];
	}
	/*
	 * Translate To External Format
	 */
	if (opcycles == OPCY_NONE) { opcycles  =  CYCL_NONE; } else
	if (opcycles  & OPCY_NONE) { opcycles |= (CYCL_NONE | 0x3F00); }
}

/*
 * Expression with Prefix and Suffix
 */
void
exprps(char *pre, struct expr *esp, char *suf)
{
	int c;
	char pbufr[NCPS];
	char *p;

	/* Copy Prefix To String Buffer */
	strcpy(pbufr, pre);

	/* Append Input Argument To String */
	p = pbufr + strlen(pbufr);
	unget(getnb());
	while (((c = get()) != 0) && (c != ';') && (c != ',')) *p++ = c;
	*p = 0;
	unget(c);
	/* Trim Argument String */
	while ((*(--p) == ' ') || (*p == '\t')) *p = 0;

	/* Append Suffix To String */
	strcat(p, suf);

	/* Process Created Argument String */
	p = ip;
	ip = pbufr;
	expr(esp);
	ip = p;
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
 * Machine Specific Initialization
 */
void
minit(void)
{
	/*
	 * Byte Order
	 */
	hilo = 1;
}
