/* sxmch.c */

/*
 *  Copyright (C) 2022-2025  Alan R. Baldwin
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
#include "sx.h"

char *cpu  = "Ubicom SX Family";
char *dsft = "asm";

/*
 * Opcode Cycle Definitions
 */
#define	OPCY_SDP	((char) (0xFF))
#define	OPCY_ERR	((char) (0xFE))

#define	OPCY_NONE	((char) (0x80))
#define	OPCY_MASK	((char) (0x7F))

#define	OPCY_SKP	((char) (0xFD))

/*
 * Process a machine op.
 */
void
machine(struct mne *mp)
{
	int op, rf;
	int t1, t2, v1, v2;
	struct expr e1, e2;
	char *p;

	/*
	 * Using Internal Format
	 * For Cycle Counting
	 */
	opcycles = OPCY_NONE;

	clrexpr(&e1);
	clrexpr(&e2);
	op = (int) mp->m_valu;
	rf = (int) mp->m_type;
	switch (rf) {

	case S_TYP1:	/* ADD, AND, OR, SUB, XOR */
		t1 = addr(&e1);
		comma(1);
		t2 = addr(&e2);
		if ((t1 == S_W) && (t2 == S_FR)) {	/* mne W,fr */
			if (op == 0x0A0) {	/* SUB */
				aerr();
			}
			outrwm(&e2, R_5BIT, op);
			break;
		} else
		if ((t1 == S_FR) && (t2 == S_W)) {	/* mne fr,W */
			switch(op) {
			case 0x1C0:	op = 0x1F0;	break;	/* ADD */
			case 0x140:	op = 0x160;	break;	/* AND */
			case 0x100:	op = 0x120;	break;	/* OR */
			case 0x180:	op = 0x1A0;	break;	/* XOR */
			case 0x0A0:			break;	/* SUB */
			default:	aerr();		break;
			}
			outrwm(&e1, R_5BIT, op);
 		        break;
		} else
		if ((t1 == S_W) && (t2 == S_IMM)) {
			switch(op) {
			case 0x140:	op = 0xE00;	break;	/* AND */
			case 0x100:	op = 0xD00;	break;	/* OR */
			case 0x180:	op = 0xF00;	break;	/* XOR */
			case 0x1C0:			break;	/* ADD */
			case 0x0A0:			break;	/* SUB */
			default:	aerr();		break;
			}
			outrwm(&e2, R_8BIT, op);
 		        break;
		} else {
			aerr();
		}
		break;

	case S_TYP2:	/* NOT, DEC, DECSZ, INC, INCSZ, RL, RR, SWAP, TEST */
		t1 = addr(&e1);
		if ((t1 == S_W) && (op == 0x260)) {	/* NOT W */
			outaw(0xFFF);
		} else
		if (t1 == S_FR) {
			outrwm(&e1, R_5BIT, op);
		} else {
			aerr();
		}
		break;

	case S_TYP3:	/* CLRB, SB, SETB, SNB */
		t1 = addr(&e1);
		if ((t1 & 0xF8) == S_FRBIT) {
			outrwm(&e1, R_5BIT, op | ((t1 & 0x07) << 5));
		} else {
			aerr();
		}
		break;

	case S_CLR:
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		if (t1 == S_FR) {			/* CLR fr */
			outrwm(&e1, R_5BIT, 0x060);
		} else
		if (t1 == S_W) {			/* CLR W */
			outaw(0x040);
		} else
		if ((t1 == S_NRG) && (v1 == S_WDT)) {	/* CLR !WDT */
			outaw(0x004);
		} else {
			aerr();
		}
		break;

	case S_MOV:
		t1 = addr(&e1);
		comma(1);
		t2 = addr(&e2);
		v2 = (int) e2.e_addr;
		if ((t1 == S_FR) && (t2 == S_W)) {	/* MOV fr,W */
			outrwm(&e1, R_5BIT, 0x020);
			break;
		}
		if ((t1 == S_M) && (t2 == S_W)) { 	/* MOV M,W */
			outaw(0x043);
			break;
		}
		if ((t1 == S_M) && (t2 == S_IMM)) {	/* MOV M,# */
			outrwm(&e2, R_4BIT, 0x050);
			break;
		}
		if ((t1 == S_NRG) && (t2 == S_W)) {	/* MOV !rx,W */
			outrwm(&e1, R_4BIT, 0x000);	/* MOV !OPTION,W */
			break;
		}
		if (t1 == S_W) {
			switch(t2) {
			case S_FR:			/* MOV W,fr */
				outrwm(&e2, R_5BIT, 0x200);
				break;
			case S_FRW:			/* MOV W, fr-W */
				outrwm(&e2, R_5BIT, 0x080);
				break;
			case S_IMM:			/* MOV W,# */
				outrwm(&e2, R_8BIT, 0xC00);
				break;
			case S_MOP:			/* MOV W,'op'fr */
				switch(v2) {
				case S_CM:	op = 0x240;	break;	/* MOV W,/fr */
				case S_MM:	op = 0x0C0;	break;	/* MOV W,--fr */
				case S_PP:	op = 0x280;	break;	/* MOV W,++fr */
				case S_LT:	op = 0x340;	break;	/* MOV W,<<fr */
				case S_RT:	op = 0x300;	break;	/* MOV W,>>fr */
				case S_SN:	op = 0x380;	break;	/* MOV W,<>fr */
				default:	break;
				}
				clrexpr(&e2);
				expr(&e2, 0);
				outrwm(&e2, R_5BIT, op);
				break;
			case S_M:			/* MOV W,M */
				outaw(0x042);
				break;
			default:
				aerr();
				break;
			}
			break;
		}
		aerr();
		break;

	case S_MOVSZ:
		t1 = addr(&e1);
		comma(1);
		t2 = addr(&e2);
		v2 = (int) e2.e_addr;
		if ((t1 == S_W) && (t2 == S_MOP)) {
			if (v2 == S_MM) {
				op = 0x2C0;	/* MOVSZ W,--fr */
			} else
			if (v2 == S_PP) {
				op = 0x3C0;	/* MOVSZ W,++fr */
			} else {
				aerr();
				break;
			}
			clrexpr(&e2);
			expr(&e2, 0);
			outrwm(&e2, R_5BIT, op);
			break;
		}
		aerr();
		break;


	case S_CALL:
		expr(&e1, 0);
		outrwm(&e1, R_8BIT, op);
		break;

	case S_JMP:
		t1 = addr(&e1);
		switch(t1) {
		case S_W:	/* JMP W -> MOV 0x02,W */
			outaw(0x0022);
			break;
		case S_PCW:	/* JMP PC+W -> ADD 0x02,W */
			outaw(0x01E2);
			break;
		case S_FR:	/* JMP	addr */
			outrwm(&e1, R_9BIT, op);
			break;
		default:
			aerr();
		}
		break;

	case S_RETW:
		expr(&e1, 0);
		outrwm(&e1, R_8BIT, op);
		break;

	case S_BNK:
		expr(&e1, 0);
		if (is_abs(&e1) && ((e1.e_addr & ~0x07) == 0)) {
			outaw(op | (int) e1.e_addr);
		} else {
			outrwm(&e1, R_BNK, op);
		}
		break;

	case S_PAG:
		expr(&e1, 0);
		if (is_abs(&e1) && ((e1.e_addr & ~0x07) == 0)) {
			outaw(op | (int) e1.e_addr);
		} else {
			outrwm(&e1, R_PAG, op);
		}
		break;

	case S_MODE:
		expr(&e1, 0);
		outrwm(&e1, R_4BIT, op);
		break;

	case S_SC:
		outaw(op + 0x03);
		break;

	case S_SZ:
		outaw(op + 0x43);
		break;

	case S_SKIP:
		p = ip;
		ip = ". + 1";
		expr(&e1, 0);
		ip = p;
		outrwm(&e1, R_SKIP, op + 2);
		break;

	case S_INH:
		outaw(op);
		break;

	default:
		opcycles = OPCY_ERR;
		xerr('o', "Internal Opcode Error.");
		break;
	}
	if (opcycles == OPCY_NONE) {
		switch(op) {
		default: opcycles = 1;	break;
		case 0x2E0:	/* DECSZ */
		case 0x3E0:	/* INCSZ */
		case 0x700:	/* SB */
		case 0x600:	/* SNB */
		case 0x2C0:	/* MOVSZ */
		case 0x3C0:	/* MOVSZ */
			opcycles = 2;	break;
		case 0x900:	/* CALL */
		case 0xA00:	/* JMP */
		case 0x00C:	/* RET */
		case 0x00D:	/* RETP */
		case 0x00E:	/* RETI */
		case 0x00F:	/* RETIW */
		case 0x800:	/* RETW */
			opcycles = 3;	break;
		case 0x041:	/* IREAD */
			opcycles = 4;	break;
		}
	}
	/*
	 * Translate To External Format
	 */
	if (opcycles == OPCY_NONE) { opcycles  =  CYCL_NONE; } else
	if (opcycles  & OPCY_NONE) { opcycles |= (CYCL_NONE | 0x3F00); }
}

/*
 * Memory Mapped Register Symbols
 */

struct adsym	regsym[] = {	/* registers */
	{	"indf",		S_INDF	},
	{	"rtcc",		S_RTCC	},
	{	"pc",		S_PC	},
	{	"status",	S_STATUS},
	{	"fsr",		S_FSR	},
	{	"ra",		S_RA	},
	{	"rb",		S_RB	},
	{	"rc",		S_RC	},
	{	"rd",		S_RD	},
	{	"re",		S_RE	},
	/* ----- */
	{	"INDF",		S_INDF	},
	{	"RTCC",		S_RTCC	},
	{	"PC",		S_PC	},
	{	"STATUS",	S_STATUS},
	{	"FSR",		S_FSR	},
	{	"RA",		S_RA	},
	{	"RB",		S_RB	},
	{	"RC",		S_RC	},
	{	"RD",		S_RD	},
	{	"RE",		S_RE	},
	{	"",		0x00	}
};

char errstr[NCPS];

/*
 * Machine dependent initialization
 */
void
minit(void)
{
	int i;
	struct sym *sp;

	/*
	 * Byte Order
	 */
	hilo = 1;
	/*
	 * Define Register Symbols
	 */
	for (i=0; *regsym[i].a_str; i++) {
		sp = lookup(regsym[i].a_str);
		if (pass == 2) {
			if (sp->s_addr != (a_uint) regsym[i].a_val) {
				printf("?ASSX-Error: Register symbol %s value changed to %u\n", regsym[i].a_str, sp->s_addr);
			}
		}
		sp->s_addr = regsym[i].a_val;
		sp->s_type = S_USER;
		sp->s_area = NULL;
	}
}

