/* m68cfmch.c */

/*
 *  Copyright (C) 2023-2024  Alan R. Baldwin
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
#include "m68cf.h"


char	*cpu	= "Motorola ColdFire";
char	*dsft	= "asm";

int	m68k;	/* Machine Type */
int	mac;	/* Multiply-Accumulate Unit */
int	emac;	/* Extended Multiply-Accumulate Unit */
int	flt;	/* Floating Point */
int	coid;	/* Floating Point ID */

int	rc;	/* Register Count For Instructions */
int	sz;	/* Mnemonic Instruction Size */
int	fsz;	/* Floating Instruction Size */

int	alt;	/* Substitute Alternate Instruction */

/*
 * setbit() / getbit() Parameter Space
 * 4096 is sufficient for 1MB of code
 */
#define	NB	4096

int	*bp;
int	bm;
int	bb[NB];

/*
 * Direct Page Areas
 */
struct area *zpg;
struct area *dpglo;
struct area *dpghi;

int autodpcnst;	/* Automatic Direct Page Addressing For Constants */
int autodpsmbl;	/* Automatic Direct Page Addressing For Symbols */

a_uint	pc;	/* Beginning Address Of Current Operation */

/*
 * Process a machine op.
 */
VOID
machine(mp)
struct mne *mp;
{
	a_uint op, opcode, op2;
	int c, rf, scl;
	struct expr e1, e2;
	struct sym *sp;
	int t1, t2, v1, v2, a1, a2, p1, p2, x1, x2;
	int vimm;
	char id[NCPS];
	INT32 dsplcmnt;
	char *p;

	clrexpr(&e1);
	clrexpr(&e2);

	pc = dot.s_addr;
	op = mp->m_valu;
	opcode = op;
	scl = 0;
	t1 = t2 = v1 = v2 = a1 = a2 = p1 = p2 = x1 = x2 = 0;
	rc = 0;
	sz =  mp->m_flag & 0x03;
	fsz = mp->m_flag & 0x07;
	rf = mp->m_type;

	if (!flt && (rf >= 40) && (rf <= 49)) {
		xerr('q', "Floating Point Not Enabled");
	}
	if (!mac && !emac && (rf >= 50) && (rf <= 59)) {
		xerr('q', "[Extended] Multiply-Accumulate Not Enabled");
	}

	switch (rf) {

 	case S_M68K:
		t1 = addr(&e1, sz, &v1, &p1, &x1);
		outab(t1 >> 3);
		outab(v1);
		ea(&e1, t1, p1, x1, 2, opcode, 0);
		break;

	case S_SDP:
		opcycles = OPCY_SDP;
		zpg = dot.s_area;
		if (more()) {
			expr(&e1, 0);
			if (e1.e_flag == 0 && e1.e_base.e_ap == NULL) {
				if (!(e1.e_addr == 0) && !(e1.e_addr == ~0x7FFF)) {
					e1.e_addr = 0;
					xerr('b', "Only Pages 0 or 0xFFFF8000 Allowed");
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
		if (e1.e_addr == 0) {
			dpglo = zpg;
		} else {
			dpghi = zpg;
		}
		p_mask = 0x7FFF;
		outdp(zpg, &e1, 0);
		lmode = SLIST;
		break;

	case S_PGD:
		do {
			getid(id, -1);
			sp = lookup(id);
			sp->s_flag &= ~S_LCL;
			sp->s_flag |=  S_GBL;
			if ((mp->m_flag == 1) && (dpglo != NULL)) {
				sp->s_area = dpglo;
			} else
			if ((mp->m_flag == 2) && (dpghi != NULL)) {
				sp->s_area = dpghi;
			} else {
				sp->s_area = dot.s_area;
			}
 		} while (comma(0));
		lmode = SLIST;
		break;

	/*
	 * The Coldfire Processor
	 */

	case S_TYP1:	/* ADDX, SUBX */
		/* xxx  Dy,Dx */
		t1 = addr(&e1, sz, &v1, &p1, &x1);
		comma(1);
		t2 = addr(&e2, sz, &v2, &p2, &x2);

		/* xxx  Dy, Dx */
		if ((t1 == S_Dn) && (t2 == S_Dn)) {
			opcode |= ((v2 << 9) | v1);
			outaw(opcode);
		} else {
			xerr('q', "Unsupported Addressing Mode");
		}
		break;

	case S_TYP2:	/* ADD, AND, OR, SUB */
		/* xxx Dn,<ea>  or xxx <ea>,Dn */
		t1 = addr(&e1, sz, &v1, &p1, &x1);
		comma(1);
		t2 = addr(&e2, sz, &v2, &p2, &x2);

		/* xxx <ea>,An */
		if (alt && (t2 == S_An)) {
			/* Use xxxA <ea>,An */
			switch((op >> 8) & 0xFF) {
			case 0xD0:	/* ADD */
			case 0x90:	/* SUB */
				opcode = (op & ~0xFF) | (v2 << 9) | (7 << 6) | t1 | v1;
				break;
			case 0xC0:	/* AND */
			case 0x80:	/* OR */
				xerr('q', "Only ADD/SUB Support 'An' As Destination");
				break;
			default:
				xerr('q', "m68cfmch.c Internal Error");
				break;
			}
			ea(&e1, t1, p1, x1, 2, opcode, 1);
		} else
		/* xxx #,<ea> */
		if (alt && (t1 == S_IMM)) {
			/* Use xxxI,Q #,<ea> */
			switch(t2) {
			case S_An:
			case S_PCID:
			case S_PCIDX:
			case S_IMM:
				xerr('a', "Invalid Addressing Mode");
				break;
			default:
				/* Use xxxQ #,<ea> */
				v1 = (int) ((op >> 8) & 0xFF);
				if (is_abs(&e1) && ((v1 == 0xD0) || (v1 == 0x90))) {
					vimm = (int) e1.e_addr;
					if ((1 <= vimm) && (vimm <= 8)) {
						switch((op >> 8) & 0xFF) {
						case 0xD0:	/* ADDQ */	op = 0x5000;	break;
						case 0x90:	/* SUBQ */	op = 0x5100;	break;
						default:	break;
						}
						opcode = op | (((vimm & 7) << 9) | (sz << 6) | t2 | v2);
						ea(&e2, t2, p2, x2, 2, opcode, 1);
						break;
					}
				}
				/* Use xxxI #,<ea> */
				switch((op >> 8) & 0xFF) {
				case 0xD0:	/* ADDI */	op = 0x0600;	break;
				case 0xC0:	/* ANDI */	op = 0x0200;	break;
	 			case 0x80:	/* ORI */	op = 0x0000;	break;
				case 0x90:	/* SUBI */	op = 0x0400;	break;
				default:	xerr('q',  "m68kmch.c Internal Error");
				}
	 			opcode = op | (sz << 6) | t2 | v2;
				im(&e1, opcode, 1);
				ea(&e2, t2, p2, x2, dot.s_addr - pc, opcode, 0);
				break;
			}
		} else
		/* xxx <ea>,Dn */
		if (t2 == S_Dn) {
			/* xxx An,Dn */
			if (t1 == S_An) {
				switch((op >> 8) & 0xFF) {
				case 0xD0:	/* ADD */
				case 0x90:	/* SUB */
					break;
				case 0xC0:	/* AND */
				case 0x80:	/* OR */
					xerr('q', "This Instruction Does Not Support 'An' As First Argument");
					break;
				default:
					xerr('q', "m68cfmch.c Internal Error");
					break;
				}
			}
			opcode = (op & ~0xFF) | (v2 << 9) | (sz << 6) | t1 | v1;
			ea(&e1, t1, p1, x1, 2, opcode, 1);
		} else
		/* xxx Dn,<ea> */
		if (t1 == S_Dn) {
			switch(t2) {
			case S_Dn: /* can't happen */
			case S_An: /* can't happen if alt is true */
			case S_PCID:
			case S_PCIDX:
			case S_IMM:
				xerr('q', "Invalid Destination Mode");
			default:
				opcode = (op & ~0xFF) | (v1 << 9) | ((sz | 4) << 6) | t2 | v2;
				ea(&e2, t2, p2, x2, 2, opcode, 1);
				break;
			}
		} else {
			xerr('q', "One Of The Arguments Must Be Dn");
		}
		break;

	case S_TYP3:	/* ADDA, CMPA, SUBA */
		/* xxx <ea>,An */
		t1 = addr(&e1, sz, &v1, &p1, &x1);
		comma(1);

		/* xxx <ea>,An */
		if (admode(An)) {
			opcode |= ((aindx << 9) | t1 | v1);
			ea(&e1, t1, p1, x1, 2, opcode, 1);
			break;
		} else {
			xerr('a', "Second Argument Must Be An");
		}
		break;

	case S_TYP4:	/* ADDI, ANDI, CMPI, EORI, ORI, SUBI */
		/* xxx IMM,An */
		t1 = addr(&e1, sz, &v1, &p1, &x1);
		if (t1 != S_IMM) {
			xerr('q', "First Armument Must Be A #");
		}
		comma(1);
		t2 = addr(&e2, sz, &v2, &p2, &x2);
		if (t2 != S_Dn) {
			xerr('q', "Second Armument Must Be Dn");
		}
		opcode |= ((sz << 6) | t2 | v2);
		im(&e1, opcode, 1);
		break;

	case S_TYP5:	/* ADDQ, SUBQ */
		/* xxx #,An */
		t1 = addr(&e1, sz, &v1, &p1, &x1);
		comma(1);
		t2 = addr(&e2, sz, &v2, &p2, &x2);

		if (t1 != S_IMM) {
			xerr('q', " First Argument Must Be A #");
		}
		switch(t2) {
		case S_PCID:
		case S_PCIDX:
		case S_IMM:
			xerr('q', "Invalid Addressing Mode");
			break;
		default:
			if (is_abs(&e1)) {
				vimm = (int) e1.e_addr;
				if ((1 <= vimm) && (vimm <=8)) {
					opcode |= (((vimm & 7) << 9) | (sz << 6) | t2 | v2);
					ea(&e2, t2, p2, x2, pc, opcode, 1);
				} else {
					xerr('q', "Argument Has Range Of 1-8");
				}
			} else {
				opcode |= ((sz << 6) | t2 | v2);
				outrwm(&e2, R_QBITS, opcode);
				ea(&e2, t2, p2, x2, 2, opcode, 0);
			}
			break;
		}
		break;

	case S_TYP6:	/* DIVS, DIVU, MULS, MULU */
		/* xxx <ea>,Dn */
		t1 = addr(&e1, sz, &v1, &p1, &x1);
		comma(1);

		if (admode(Dn)) {
			if (t1 == S_An) {
				xerr('q', "First Argument Must Not Be An");
			}
			a1 = a2 = aindx;
			switch(sz) {
			default:
			case A_W:	/* DIVS.W, DIVU.W, MULS.W, MULU.W */
				opcode |= ((a1 << 9) | t1 | v1);
				ea(&e1, t1, p1, x1, 2, opcode, 1);
				break;
			case A_L:	/* DIVS.L, DIVU.L, MULS.L, MULU.L */
				switch(t1) {
				case S_Dn:
				case S_ARI:
				case S_AINC:
				case S_ADEC:
				case S_ARID:
					break;
				default:
					xerr('q', "Invalid Addressing Mode With .L");
					break;
				}
				switch(op) {
				default:
				case 0x81C0:	/* DIVS.L */
					opcode = 0x4C40;
					a1 |= 0x0800 | (a2 << 12);
					break;
				case 0x80C0:	/* DIVU.L */
					opcode = 0x4C40;
					a1 |= 0x0000 | (a2 << 12);
					break;
				case 0xC1C0:	/* MULS.L */
					opcode = 0x4C00;
					a1 |= 0x0800 | (a2 << 12);
					break;
				case 0xC0C0:	/* MULU.L */
					opcode = 0x4C00;
					a1 |= 0x0000 | (a2 << 12);
					break;
				}
			        outaw(opcode |= t1 | v1);
				outaw(a1);
				ea(&e1, t1, p1, x1, 4, opcode, 0);
			}
		} else {
			xerr('q', "Second Argument Must Be Dn");
		}
		break;

	case S_TYP7:	/* CLR, TST */
		/* xxx <ea> */
		t1 = addr(&e1, sz, &v1, &p1, &x1);

		switch(t1) {
		case S_An:
		case S_IMM:
		case S_PCID:
		case S_PCIDX:
			if (op == 0x4200) {
				xerr('q', "Invalid Addressing Mode");
			}
		default:
			break;
		}
		opcode |= ((sz << 6) | t1 | v1);
		ea(&e1, t1, p1, x1, 2, opcode, 1);
		break;

	case S_TYP8:	/* JMP, JSR, LEA, PEA */
		t1 = addr(&e1, sz, &v1, &p1, &x1);

		switch(t1) {
		case S_Dn:
		case S_An:
		case S_AINC:
		case S_ADEC:
		case S_IMM:
			xerr('q', "Invalid Addressing Mode");
			break;
		default:
			if (op == 0x41C0) {
				/* LEA */
				comma(1);
				t2 = addr(&e2, sz, &v2, &p2, &x2);

				if (t2 != S_An) {
					xerr('q', "Second Argument Must Be An");
				}
				opcode |= ((v2 << 9) | t1 | v1);

			} else {
				/* JMP, JSR, PEA */
				opcode |= (t1 | v1);
			}
			ea(&e1, t1, p1, x1, 2, opcode, 1);
		}
		break;

	case S_TYP9:	/* BYTEREV, BITREV, FF1, NEG, NEGX, NOT, SATS, SCC, SWAP */
		if (admode(Dn)) {
			outaw(opcode |= aindx);
		} else {
			xerr('q', "Invalid Addressing Mode");
		}
		break;

	case S_TAS:	/* TAS, WDDATA */
		t1 = addr(&e1, sz, &v1, &p1, &x1);

		switch(t1) {
		case S_Dn:
		case S_An:
		case S_PCID:
		case S_PCIDX:
		case S_IMM:
			xerr('q', "Invalid Addressing Mode");
			break;
		default:
			opcode |= (sz << 6) | (t1 | v1);
			ea(&e1, t1, p1, x1, 2, opcode, 1);
			break;
		}
		break;

	case S_SHFT:	/* ASL, ASR, LSL, LSR */
		t1 = addr(&e1, sz, &v1, &p1, &x1);
		comma(1);
		t2 = addr(&e2, sz, &v2, &p2, &x2);

		/* ___ Dn,Dn */
		if ((t1 == S_Dn) && (t2 == S_Dn)) {
			opcode |= ((v1 << 9) | 0x20 | v2);
			outaw(opcode);
		} else
		/* ___ #,Dn */
		if ((t1 == S_IMM) && (t2 == S_Dn)) {
			if (is_abs(&e1)) {
				vimm = (int) e1.e_addr;
				if ((vimm < 1) || (vimm > 8)) {
					xerr('q', "1 <= Shift Count <= 8 Required");
				}
				rc = vimm;
				opcode |= (((vimm & 7) << 9) | 0x00 | v2);
				outaw(opcode);
			} else {
				opcode |= ((sz << 6) | 0x00 | v2);
				outrwm(&e1, R_QBITS, opcode);
			}
		} else {
			xerr('q', "First Argument Was Not A # Or Dn");
		}
		break;

	case S_BCC:	/* Bcc Label */
		expr(&e1, 0);
		dsplcmnt = (INT32) (e1.e_addr - dot.s_addr - 2);
		opcode = op;
		switch(sz) {
		case B_A:	/* Bcc Auto Sized */
			if (pass == 0) {
				dot.s_addr += 6;
			} else
			if (pass == 1) {
				if (e1.e_addr >= dot.s_addr) {
					dsplcmnt -= fuzz;
				}
				if (mchpcr(&e1)) {
					/* At This Point A Zero Displacement Cannot Be Detected */
					/* And The Exact Range Is 'fuzzy' */
					if (setbit((dsplcmnt < -128) || (dsplcmnt > 127))) {
						dot.s_addr += 2;
#ifdef LONGINT
						if (setbit((dsplcmnt < -32768l) || (dsplcmnt > 32767l))) {
#else
						if (setbit((dsplcmnt < -32768) || (dsplcmnt > 32767))) {
#endif
							dot.s_addr += 2;
						}
					}
					dot.s_addr += 2;
				} else {
					dot.s_addr += 6;
				}
			} else
			if (mchpcr(&e1)) {
				if (getbit() == 0) {
					if ((dsplcmnt < -128) || (dsplcmnt > 127)) {
						xerr('a', "8-Bit Branching Range Exceeded");
					} else
					if (dsplcmnt == 0x00) {
						xerr('a', "Bxx.B To .+2 Not Allowed - Use .W Form");
					} else
					if (dsplcmnt == 0xFF) {
						xerr('a', "Bxx.B To .+129 Not Allowed - Use .W Form");
					}
					outaw(opcode |= (dsplcmnt & 0x00FF));
					sz = B_B;
				} else
				if (getbit() == 0) {
#ifdef LONGINT
					if ((dsplcmnt < -32768l) || (dsplcmnt > 32767l)) {
#else
					if ((dsplcmnt < -32768) || (dsplcmnt > 32767)) {
#endif
						xerr('a', "16-Bit Branching Range Exceeded");
					}
					outaw(op);
					outaw(dsplcmnt);
					sz = B_W;
				} else {
					outaw(op | 0x00FF);
					outa4b(dsplcmnt);
					sz = B_L;
				}
			} else {
				outaw(op | 0x00FF);
				e1.e_addr += dot.s_addr - pc + 2;
				outr4b(&e1, R_PCR);
				sz = B_L;
			}
			break;
		case B_B:	/* Bcc.b Short Mode */
			if (mchpcr(&e1)) {
				if ((dsplcmnt < -128) || (dsplcmnt > 127)) {
					xerr('a', "8-Bit Branching Range Exceeded");
				} else
				if (dsplcmnt == 0) {
					xerr('a', "Branch To Next Instruction Not Allowed");
				}
				outaw(opcode |= (dsplcmnt & 0x00FF));
			} else {
				outab(op >> 8);
				outrb(&e1, R_PCR);
			}
			break;		
		case B_W:	/* Bcc.w Word Mode */
			if (mchpcr(&e1)) {
#ifdef LONGINT
				if ((dsplcmnt < -32768l) || (dsplcmnt > 32767l)) {
#else
				if ((dsplcmnt < -32768) || (dsplcmnt > 32767)) {
#endif
					xerr('a', "16-Bit Branching Range Exceeded");
				}
				outaw(op);
				outaw(dsplcmnt);
			} else {
				outaw(op);
				e1.e_addr += dot.s_addr - pc;
				outrw(&e1, R_PCR);
			}
			break;
		case B_L:	/* Bcc.L Long Mode */
			if (mchpcr(&e1)) {
				outaw(op | 0x00FF);
				outa4b(dsplcmnt);
			} else {
				outaw(op | 0x00FF);
				e1.e_addr += dot.s_addr - pc + 2;
				outr4b(&e1, R_PCR);
			}
			break;
		default:
			break;
		}
		if (e1.e_mode != S_USER)
			rerr();
		break;

	case S_BIT:	/* bchg, bclr, bset, btst */
		/* xxx Dn,<ea>  or  xxx #,<ea> */
		t1 = addr(&e1, sz, &v1, &p1, &x1);
		comma(1);
		t2 = addr(&e2, sz, &v2, &p2, &x2);

		/* suffix is redundant, but some code uses it, validate */
		if (!(mp->m_flag & A_A)) {
			switch(sz) {
			case A_B: /* .B */
				if (t2 == S_Dn)
					xerr('q', "Register Operand Must Be Long");
				break;
			case A_L: /* .L */
				if (t2 != S_Dn)
					xerr('q', "Memory Operand Must Be Byte");
				break;
			default:
				xerr('q', "Invalid Instruction Size");
				break;
			}
		}
		/* xxx Dn,<ea> */
		if (t1 == S_Dn) {
			switch(t2) {
			case S_PCID:
			case S_PCIDX:
				if (op == 0x0100) break;
			case S_An:
			case S_IMM:
				xerr('q', "Invalid Addressing Mode");
				break;
			default:
				break;
			}
			opcode |= ((v1 << 9) | t2 | v2);
			ea(&e2, t2, p2, x2, 2, opcode, 1);
		} else
		/* xxx #,<ea> */
		if (t1 == S_IMM) {
			switch(t2) {
			case S_Dn:
			case S_ARI:
			case S_AINC:
			case S_ADEC:
			case S_ARID:
				break;
			default:
				xerr('q', "Invalid Addressing Mode");
				break;
			}
			opcode |= (op & ~0xFEFF) | 0x0800 | (t2 | v2);
			outaw(opcode);
			outab(0);
			outrb(&e1, 0);
			ea(&e2, t2, p2, x2, 2, opcode, 0);
		} else {
				xerr('q', "Invalid Addressing Mode");
		}
		break;

	case S_CAS:
		if (admode(Dn) && comma(0)) {
			a1 = aindx;
		} else {
			xerr('q', "First Argument Must Be Dc");
		}
		if (admode(Dn) && comma(0)) {
			a1 |= aindx << 6;
		} else {
			xerr('q', "Second Argument Must Be Du");
		}
		t1 = addr(&e1, sz, &v1, &p1, &x1);
		switch(t1) {
		case S_ARI:
		case S_AINC:
		case S_ADEC:
		case S_ARID:
			break;
		default:
			xerr('a', "Invalid Addressing Mode");
			break;
		}
		outaw(opcode |= ((sz + 1) << 9) | t1 | v1);
		outaw(a1);
		ea(&e1, t1, p1, x1, 4, opcode, 0);
		break;

	case S_CAS2:
		if (admode(Dn) && (getnb() == ':')) {
			a1 = aindx;
			if (admode(Dn)) {
				a2 = aindx;
			}
		}
		if (!comma(0)) {
			xerr('q', "First Register Pair 'Dc1:Dc2,' Is Invalid");
		}
		if (admode(Dn) && (getnb() == ':')) {
			a1 |= (aindx << 6);
			if (admode(Dn)) {
				a2 |= (aindx << 6);
			}
		}
		if (!comma(0)) {
			xerr('q', "Second Register Pair 'Du1:Du2,' Is Invalid");
		}
		if (getnb() == '(') {
			if (admode(An) && (getnb() == ')') && (getnb() == ':') && (getnb() == '(')) {
				a1 |= 0x8000 | (aindx << 12);
				if (admode(An)) {
					a2 |= 0x8000 | (aindx << 12);
				} else
				if (admode(Dn)) {
					a2 |= 0x0000 | (aindx << 12);
				}
			} else
			if (admode(Dn) && (getnb() == ')') && (getnb() == ':') && (getnb() == '(')) {
				a1 |= 0x0000 | (aindx << 12);
				if (admode(An)) {
					a2 |= 0x8000 | (aindx << 12);
				} else
				if (admode(Dn)) {
					a2 |= 0x0000 | (aindx << 12);
				}
			}
		}
		if (getnb() != ')') {
			xerr('q', "Register Pair '(Rn1):(Rn2)' Is Invalid");
		}
		outaw(opcode |= ((sz + 1) << 9));
		outaw(a1);
		outaw(a2);
		break;

	case S_CHK:	/* CHK */
		/* CHK <ea>,Dn */
		t1 = addr(&e1, sz, &v1, &p1, &x1);
		if (t1 == S_An) {
			xerr('q', "First Argument Must Not Be An");
		}
		comma(1);

		if (admode(Dn)) {
			opcode |= (aindx << 9) | t1 | v1;
			ea(&e1, t1, p1, x1, 2, opcode, 1);
		} else {
			xerr('q', "Second Argument Must Be Dn");
		}
		break;

	case S_CHK2:
	case S_CMP2:
		t1 = addr(&e1, sz, &v1, &p1, &x1);
		switch(t1) {
		case S_Dn:
		case S_An:
		case S_AINC:
		case S_ADEC:
		case S_IMM:
		case S_SHRT:
		case S_LONG:
			xerr('q', "Invalid Addressing Mode");
			break;
		default:
			break;
		}
		comma(1);
		if (admode(An)) {
			a1 = 0x8000 | (aindx << 12);
		} else
		if (admode(Dn)) {
			a1 = 0x0000 | (aindx << 12);
		} else {
			xerr('q', "Second Argument Must Be An Or Dn");
		}
		if (rf == S_CHK2) {
			a1 |= 0x0800;
		}
		outaw(opcode |= (sz << 9) | t1 | v1);
		outaw(a1);
		ea(&e1, t1, p1, x1, 4, opcode, 0);
		break;

	case S_MOVE:	/* MOVE ___,___ */
		/* [Extended] Multiply-Accumulate */
		if ((mac || emac) && admode(MACR)) {
			if (sz != A_L) {
				xerr('w', "MOVE.L Required For [Extended] Multiply-Accumulate");
			}
			a1 = aindx;
			comma(1);
			if (emac && (a1 <= 3) && admode(MACR)) {
				a2 = aindx;
				if (a2 <= 3) {
					outaw(opcode = 0xA110 | (a2 << 9) | a1);
					break;
				} else {
					xerr('q', "Only MOVE.L ACCn,ACCn Allowed");
				}
			} else
			if (admode(Dn)) {
				a2 = 0x00 | aindx;
			} else
			if (admode(An)) {
				a2 = 0x08 | aindx;
			} else
			if (admode(Sreg)) {
				if ((a1 == 7) && (aindx == S_CCR)) {
					outaw(opcode = 0xA9C0);
					break;
				} else {
					xerr('q', "Only MOVE.L MACSR,CCR Allowed");
				}
			} else {
				xerr('q', "Second Argument Must Be Dn Or An");
			}
			if (mac) {	/* Multiply-Accumulate */
				switch(a1) {
				case 0:						/* MOVE.L  ACC0,Rn */
				case 6:	outaw(opcode = 0xA180 | a2);	break;	/* MOVE.L  ACC,Rn */
				case 7:	outaw(opcode = 0xA980 | a2);	break;	/* MOVE.L  MACSR,Rn */
				case 8: outaw(opcode = 0xAD80 | a2);	break;	/* MOVE.L  MASK,Rn */
				default:
					xerr('q', "Extended Multiply-Accumulate Not Enabled");
					break;
				}
			} else {	/* Extended Multiply-Accumulate */
				switch(a1) {
				case 4:	outaw(opcode = 0xAB80 | a2);	break;	/* MOVE.L  ACCext01,Rn */
				case 5:	outaw(opcode = 0xAF80 | a2);	break;	/* MOVE.L  ACCext23,Rn */
				case 7:	outaw(opcode = 0xA980 | a2);	break;	/* MOVE.L  MACSR,Rn */
				case 8: outaw(opcode = 0xAD80 | a2);	break;	/* MOVE.L  MASK,Rn */
				case 6:	a1 = 0;					/* MOVE.L  ACC(0),Rn */
				default:
					outaw(opcode = 0xA180 | (a1 << 9) | a2);/* MOVE.L  ACCn,Rn */
					break;
				}
			}	
			break;
		}
 		/* MOVE (CCR,SR,USP),Dn */
		if (admode(Sreg)) {
			v1 = aindx;
			comma(1);

			switch(v1) {
			case S_CCR:
				if (admode(Dn) && ((sz == A_W) || (mp->m_flag & A_U))) {
					outaw(opcode = 0x42C0 | aindx);
				} else {
					xerr('q', "MOVE.W CCR,Dn Required");
 				}
				break;
			case S_SR:
				if (admode(Dn) && ((sz == A_W) || (mp->m_flag & A_U))) {
					outaw(opcode = 0x40C0 | aindx);
				} else {
					xerr('q', "MOVE.W SR,Dn Required");
 				}
				break;
			case S_USP:
				if (admode(An) && ((sz == A_L) || (mp->m_flag & A_U))) {
					outaw(opcode = 0x4E68 | aindx);
				} else {
					xerr('q', "MOVE.L USP,An Required");
				}
				break;
			default:
				xerr('q', "Internal Error");
				break;
			}
			break;
		} else {
			t1 = addr(&e1, sz, &v1, &p1, &x1);
		}
		comma(1);
		/* [Extended] Multiply-Accumulate */
		if ((mac || emac) && ((t1 == S_Dn) || (t1 == S_An) || (t1 == S_IMM)) && admode(MACR)) {
			a2 = aindx;
			if (sz != A_L) {
				xerr('w', "MOVE.L Required For [Extended] Multiply-Accumulate");
			}
			switch(a2) {
			case 6:  a2 = 0;					/* MOVE.L   ___,ACC */
			default: opcode = 0xA100 | (a2 << 9) | t1 | v1;	break;	/* MOVE.L   ___,ACCn */
		        case 4:  opcode = 0xAB00 | t1 | v1;		break;	/* MOVE.L   ___,ACCext01 */
			case 5:  opcode = 0xAF00 | t1 | v1;		break;	/* MOVE.L   ___,ACCext23 */
			case 7:  opcode = 0xA900 | t1 | v1;		break;	/* MOVE.L   ___,MACSR */
			case 8:  opcode = 0xAD00 | t1 | v1;		break;	/* MOVE.L   ___,MASK */
			}
			if (mac && (aindx >= 1) && (aindx <= 5)) {
				xerr('q', "Extended Multiply-Accumulate Is Not Enabled");
			}
			ea(&e1, t1, p1, x1, 2, opcode, 1);
			break;
		}
		/* MOVE <ea>,(CCR,SR,USP) */
		if (admode(Sreg)) {
			v2 = aindx;
			switch(v2) {
			case S_USP:
				if (t1 == S_An) {
					if (sz != A_L) {
						xerr('w', "Only MOVE.L Allowed");
					}
					outaw(opcode = 0x4E60 | (0 << 3) | v1);
 			        } else {
					xerr('q', "Only MOVE.L An,USP Allowed");
				}
				break;
			default:
				switch(t1) {
				default:
					xerr('q', "Invalid Destination Addressing Mode");
					break;
				case S_Dn:
				case S_IMM:
					switch(v2) {
					case S_CCR:
						if (!(sz == A_B) && !(mp->m_flag & A_U)) {
							xerr('a', "Only MOVE.B Allowed");
						}
						opcode = 0x44C0 | t1 | v1;	break;
					case S_SR:
						if (!(sz == A_W) && !(mp->m_flag & A_U)) {
							xerr('a', "Only MOVE.W Allowed");
						}
						opcode = 0x46C0 | t1 | v1;	break;
					default:
						xerr('q', "Internal Error");
					}
					ea(&e1, t1, p1, x1, 2, opcode, 1);
					break;
				}
				break;
			}
			break;
		} else {
			t2 = addr(&e2, sz, &v2, &p2, &x2);
		}
		/* MOVE <ea>,<ea> */
		switch(t2) {
		case S_An:
#if 0			/* Conflict In Reference Manuals */
			if (sz == A_B) {
				xerr('q', "MOVEA.B Is Not Supported");
			}
#endif
			if (alt) {
				/* MOVE <ea>,An ==>> MOVEA <ea>,An */
				/* note: we don't need t2 & 070 in this case */
				opcode |= ((v2 << 9) | (t2 << 3) | t1 | v1);
				ea(&e1, t1, p1, x1, 2, opcode, 1);
				break;
			}
			/* Fall Through */
		case S_PCID:
		case S_PCIDX:
		case S_IMM:
			xerr('q', "Invalid Destination Addressing Mode");
			break;
		default:
#if 0			/* Conflict In Reference Manuals */
			if ((t1 == S_An) && (sz == A_B)) {
				xerr('q', "MOVEA.B Is Not Supported");
			}
#endif
			if (alt && (sz == A_L) && (t1 == S_IMM) && (t2 == S_Dn)) {
				if (is_abs(&e1)) {
					vimm = (int) e1.e_addr;
					if ((vimm >= -128) && (vimm <= 127)) {
						op = 0x7000;	/* MOVE #,Dn ==>> MOVEQ #,Dn */
						opcode = op | ((v2 << 9) | (vimm & 0xFF));
						outaw(opcode);
						break;
					}
				}
			}
			/*
			 * note: destination reverses register and mode fields;
			 * we do this by shifting them differently, but if mode
			 * t2 == 07x then we need to mask off the x to avoid
			 * corrupting the register field of the source -- in
			 * this case we rely on v2 == x, see the addr() routine
			 */
			opcode |= ((v2 << 9) | ((t2 & 070) << 3) | t1 | v1);
			ea(&e1, t1, p1, x1, 2, opcode, 1);
			ea(&e2, t2, p2, x2, dot.s_addr - pc, opcode, 0);
			if ((dot.s_addr - pc) > 6) {
				xerr('q', "Invalid Combination Of Addressing Modes");
			}
			break;
		}
		break;

	case S_MOVEA:	/* MOVEA <ea>,An */
		t1 = addr(&e1, sz, &v1, &p1, &x1);
		comma(1);
		t2 = addr(&e2, sz, &v2, &p2, &x2);

		if (t2 == S_An) {
#if 0			/* Conflict In Reference Manuals */
			if (sz == A_B) {
				xerr('q', "MOVEA.B Is Not Supported");
			}
#endif
			opcode |= ((v2 << 9) | t1 | v1);
			ea(&e1, t1, p1, x1, 2, opcode, 1);
		} else {
			xerr('q', "Second Argument Must Be An");
		}
		break;

	case S_MOVEC:	/* MOVEC Ry,Rc */
		if (sz != A_L) {
			xerr('q', "MOVEC Has Only A Long Form");
		}
		/* MOVEC Ry,Rc */
		t1 = addr(&e1, sz, &v1, &p1, &x1);
		comma(1);

		if ((t1 == S_Dn) || (t1 == S_An)) {
			/*
			 * Allow Direct Definitions To
			 * Override Internal Definitions
			*/
			p = ip;
			getid(id, -1);
			sp = slookup(id);
			if (sp && (sp->s_area == NULL) && (sp->s_type == S_USER)) {
				v2 = (int) sp->s_addr;
				if (v2 & ~0x0FFF) {
					xerr('w', "Valid Control Register Range Is 0x000-0xFFF");
				}
	  		} else {
				sp = NULL;
				ip = p;
			}
			if (sp || admode(Creg)) {
				if (sp == NULL) {
					v2 = aindx;
				}
				opcode |= 0x0001;
				outaw(opcode);
				switch(t1) {
				case S_Dn:	outaw(0x0000 | (v1 << 12) | (v2 & 0x0FFF));	break;
				case S_An:	outaw(0x8000 | (v1 << 12) | (v2 & 0x0FFF));	break;
				default:	break;
				}
			} else {
				xerr('q', "Second Argument Must Be A Control Register");
			}
		} else {
			xerr('q', "First Argument Must Be An or Dn");
		}
		break;

	case S_MOVEM:	/* MOVEM <R List>,<ea>  Or  MOVEM <ea>,<R List> */
		/* MOVEM <R List>,<ea> */
		v1 = mvlist(&rc);
		if (v1) {
			comma(1);
			t2 = addr(&e2, sz, &v2, &p2, &x2);

			switch(t2) {
			case S_ARI:
			case S_ARID:
				opcode |= ((0 << 10) | t2 | v2);
				outaw(opcode);
				outaw(v1);
				ea(&e2, t2, p2, x2, 4, opcode, 0);
				break;
			default:
				xerr('q', "Illegal Destination Addressing Mode");
				break;
			}
			break;
		}
		t1 = addr(&e1, sz, &v1, &p1, &x1);
		comma(1);

		/* MOVEM <ea>,<R List> */
		v2 = mvlist(&rc);
		if (v2) {
			switch(t1) {
			case S_ARI:
			case S_ARID:
				opcode |= ((1 << 10) | t1 | v1);
				outaw(opcode);
				outaw(v2);
				ea(&e1, t1, p1, x1, 4, opcode, 0);
				break;
			default:
				xerr('q', "Illegal Source Addressing Mode");
				break;
			}
			break;
		}
		xerr('q', "MOVEM Addressing Mode Error");
		break;

	case S_MOVEQ:	/* MOVEQ #,Dn */
		t1 = addr(&e1, sz, &v1, &p1, &x1);
		comma(1);
		t2 = addr(&e2, sz, &v2, &p2, &x2);

		if ((t1 == S_IMM) && (t2 == S_Dn)) {
			outab(opcode = (op >> 8) | (v2 << 1));
			if (is_abs(&e1)) {
				vimm = (int) e1.e_addr;
				if ((vimm < -128) || (vimm > 127)) {
					xerr('q', "-128 <= (# Is Not) <= 127");
				}
				outab(vimm);
			} else {
				outrb(&e1, 0);
			}
		} else {
			xerr('q', "Argument Must Be #,Dn");
		}
		break;

	case S_MOV3Q:	/* MOV3Q */
		t1 = addr(&e1, sz, &v1, &p1, &x1);
		if (!is_abs(&e1)) {
			xerr('q', "Immediate Argument Must Be A Constant");
		}
		vimm = (int) e1.e_addr;
		if ((vimm == -1) || ((vimm >= 1) && (vimm <= 7))) {
			if (vimm == -1) {
				vimm = 0;
			}
		} else {
			xerr('q', "First Argument Must Be -1 or 1-7");
		}
		comma(1);
		t2 = addr(&e2, sz, &v2, &p2, &x2);

		switch(t2) {
		case S_IMM:
		case S_PCID:
		case S_PCIDX:
			xerr('q', "Second Argument Is An Invalid Addressing Mode");
			break;
		default:
			opcode |= (vimm << 9) | t2 | v2;
			ea(&e2, t2, p2, x2, 2, opcode, 1);
			break;
		}
		break;

	case S_MVSZ:	/* MVS, MVZ */
		/* <ea>,Dn */
		t1 = addr(&e1, sz, &v1, &p1, &x1);
		comma(1);
		t2 = addr(&e2, sz, &v2, &p2, &x2);

		if (t2 == S_Dn) {
			opcode |= (v2 << 9) | t1 | v1;
			ea(&e1, t1, p1, x1, 2, opcode, 1);
		} else {
			xerr('q', "Second Argument Must Be Dn");
		}
		break;


	case S_CMP:	/* CMP */
		/* xxx <ea>,Dn */
		t1 = addr(&e1, sz, &v1, &p1, &x1);
		comma(1);
		t2 = addr(&e2, sz, &v2, &p2, &x2);

		/* CMP <ea>,An */
		if (alt && (t2 == S_An)) {
			/* Use CMPA <ea>,An */
			switch(sz) {
			case A_B:
				xerr('q', "Byte Mode With 'An' As Destination Is Not Allowed");
				break;
			case A_W:
				opcode = (op & ~0xFF) | (v2 << 9) | (3 << 6) | t1 | v1;
				break;
			case A_L:
				opcode = (op & ~0xFF) | (v2 << 9) | (7 << 6) | t1 | v1;
				break;
			default:
				xerr('q', "m68kmch.c Internal Error");
				break;
			}
			ea(&e1, t1, p1, x1, 2, opcode, 1);
		} else
		/* CMP #,<ea> */
		if (alt && (t1 == S_IMM) && (t2 == S_Dn)) {
			/* Use CMPI #,Dn */
			op = 0x0C00;
 			opcode = op | (sz << 6) | v2;
			im(&e1, opcode, 1);
			break;
		} else
		/* CMP <ea>,Dn */
		if (t2 == S_Dn) {
			opcode |= ((v2 << 9) | (sz << 6) | t1 | v1);
			ea(&e1, t1, p1, x1, 2, opcode, 1);
		} else {
			xerr('q', "Second Argument Must Be Dn");
		}
		break;

	case S_EOR:	/* EOR */
		/* xxx Dn,<ea> */
		t1 = addr(&e1, sz, &v1, &p1, &x1);
		comma(1);
		t2 = addr(&e2, sz, &v2, &p2, &x2);

		if (alt && (t1 == S_IMM) && (t2 == S_Dn)) {
			/* Use EORI #,Dn */
			op = 0x0A80;
 			opcode = op | v2;
			im(&e1, opcode, 1);
			break;
		} else
		/* EOR Dn,<ea> */
		if (t1 == S_Dn) {
			switch(t2) {
			case S_An:
			case S_PCID:
			case S_PCIDX:
			case S_IMM:
				xerr('a', "Invalid Addressing Mode");
				break;
			default:
				opcode |= (v1 << 9) | t2 | v2;
				ea(&e2, t2, p2, x2, 2, opcode, 1);
				break;
			}
		} else {
			xerr('a', " First Argument Must Be Dn");
		}
		break;

	case S_EXT:	/* EXT Dn */
		if (admode(Dn)) {
			switch(sz) {
			default:
			case A_W: /* .w */
				opcode |= ((0x02 << 6) | aindx);
				break;
			case A_L: /* .l */
				opcode |= ((0x03 << 6) | aindx);
				break;
			}
			outaw(opcode);
		} else {
			xerr('q', "Argument Must Be Dn");
		}
		break;

	case S_EXTB:	/* EXTB Dn */
		if (admode(Dn)) {
			outaw(opcode |= ((0x07 << 6) | aindx));
		} else {
			xerr('q', "Argument Must Be Dn");
		}
		break;

	case S_LINK:	/* LINK */
		t1 = addr(&e1, sz, &v1, &p1, &x1);
		comma(1);
		t2 = addr(&e2, sz, &v2, &p2, &x2);

		if ((t1 == S_An) && (t2 == S_IMM)) {
			outaw(opcode |= v1);
			outrw(&e2, R_SGND);
		} else {
			xerr('q', "An,# Is Required Argument");
		}
		break;

	case S_STOP:	/* STOP */
		t1 = addr(&e1, sz, &v1, &p1, &x1);

		if (t1 == S_IMM) {
			outaw(op);
			outrw(&e1, 0);
		} else {
			xerr('q', "Argument Must Be A #");
		}
		break;

	case S_TRAP:	/* TRAP */
		t1 = addr(&e1, sz, &v1, &p1, &x1);
		if (t1 == S_IMM) {
			if (is_abs(&e1)) {
				if (e1.e_addr & ~0x0F) {
					xerr('q', "Vector Must Be In The Range 0 - 15");
				}
				outaw(opcode |= e1.e_addr);
			} else {
				outrwm(&e1, R_4BITS, op);
			}
		} else {
			xerr('q', "Argument Must Be A #");
		}
		break;

	case S_TPF:	/* TPF */
		if (mp->m_flag & A_A) {
			if (more()) {
				expr(&e1, 0);
				if (pass == 0) {
					dot.s_addr += 6;
				} else
				if (pass == 1) {
					dot.s_addr += 2;
					if (is_abs(&e1)) {
						setwl(e1.e_addr);
					} else {
						dot.s_addr += 4;
					}
				} else
				if (is_abs(&e1)) {
					if (getbit()) {
						outaw(opcode |= 2);
						outaw(e1.e_addr);
					} else {
						outaw(opcode |= 3);
						outa4b(e1.e_addr);
					}
				} else {
					outaw(opcode |= 3);
					outr4b(&e1, 0);
				}
			} else {
				outaw(opcode |= 4);	/* Skip 0 Words */
			}
		} else {
			if (more()) {
				expr(&e1, 0);
				if (sz == A_W) {
					outaw(opcode |= 2);
					outrw(&e1, 0);
				} else {
					outaw(opcode |= 3);
					outr4b(&e1, 0);
				}
			} else {
				switch(sz) {
				case A_W:	opcode |= 2;	break;	/* Skip 1 Word */
				case A_L:	opcode |= 3;	break;	/* Skip 2 Words */
				default:	opcode |= 4;	break;	/* Skip 0 Words */
				}
				outaw(opcode);
			}
		}
		break;

	case S_UNLK:	/* UNLK */
		if (admode(An)) {
			opcode |= aindx;
			outaw(opcode);
		} else {
			xerr('q', "Argument Must Be An");
		}
		break;

	case S_SHL:	/* CPUSHL */
		if (admode(SHL)) {
			v1 = aindx;
			comma(1);
			t2 = addr(&e2, sz, &v2, &p2, &x2);
			if (t2 == S_ARI) {
				outaw(opcode |= (v1 << 6) | v2);
			} else {
				xerr('q', "Second Argument Must Be (An)");
			}
			break;
		}
		xerr('q', "First Argument Must Be DC, IC, Or BC");
		break;

	case S_TCH:	/* INTOUCH */
		t1 = addr(&e1, sz, &v1, &p1, &x1);
		if (t1 == S_ARI) {
			outaw(opcode |= v1);
		} else {
			xerr('q', "Second Argument Must Be (An)");
		}
		break;

	case S_REMS:
	case S_REMU:
		t1 = addr(&e1, sz, &v1, &p1, &x1);
		comma(1);

		switch(t1) {
		case S_Dn:
		case S_ARI:
		case S_AINC:
		case S_ADEC:
		case S_ARID:
			p = ip;
			if (admode(Dn) && (getnb() == ':') && admode(Dn)) {
				ip = p;
				admode(Dn);	a1 = aindx;
				getnb();
				admode(Dn);	a2 = aindx;
				switch(rf) {
				default:
				case S_REMS:	v2 = 0x0800 | (a2 << 12) | a1;	break;
				case S_REMU:	v2 = 0x0000 | (a2 << 12) | a1;	break;
				}
				outaw(opcode |= t1 | v1);
				ea(&e1, t1, p1, x1, 4, v2, 1);
				break;
			}
		default:
			xerr('q', "Invalid Addressing Mode");
		}
		break;

	case S_STLD:	/* STRLDSR */
		t1 = addr(&e1, sz, &v1, &p1, &x1);
		if (t1 == S_IMM) {
			outaw(opcode);
			im(&e1, 0x46FC, 1);
		} else {
			xerr('q', "Argument Must Be A #");
		}
		break;

	case S_WDB:	/* WDEBUG */
		t1 = addr(&e1, sz, &v1, &p1, &x1);
		switch(t1) {
		case S_ARI:
		case S_ARID:
			outaw(opcode |= t1 | v1);
			outaw(0x0003);
			ea(&e1, t1, p1, x1, 2, opcode, 0);
			break;
		default:
			xerr('q', "Only (An) Or (d,An) Allowed");
			break;
		}
		break;
		
	case S_INH:
		outaw(opcode);
		break;

	/*
	 * The (Extended) Multiply-Accumulate Unit
	 */

	 case M_MAC:	/* MAC, MSAC */
		if (admode(Dn))  { a1 = 0x00 + aindx;	v1 = 0x00;	p1 |= 0x40;
		} else
		if (admode(DnL)) { a1 = 0x00 + aindx;	v1 = 0x00;	p1 |= 0x01;
		} else
		if (admode(DnU)) { a1 = 0x00 + aindx;	v1 = 0x40;	p1 |= 0x01;
		} else
		if (admode(An))  { a1 = 0x08 + aindx;	v1 = 0x00;	p1 |= 0x40;
		} else
		if (admode(AnL)) { a1 = 0x08 + aindx;	v1 = 0x00;	p1 |= 0x01;
		} else
		if (admode(AnU)) { a1 = 0x08 + aindx;	v1 = 0x40;	p1 |= 0x01;
		} else {
			xerr('q', "First Argument Must Be A Register: An{.L,.U} Or Dn{.L,.U}");
		}
		comma(1);
		if (admode(Dn))  { a2 = 0x00 + aindx;	v2 = 0x00;	p1 |= 0x80;
		} else
		if (admode(DnL)) { a2 = 0x00 + aindx;	v2 = 0x00;	p1 |= 0x02;
		} else
		if (admode(DnU)) { a2 = 0x00 + aindx;	v2 = 0x80;	p1 |= 0x02;
		} else
		if (admode(An))  { a2 = 0x08 + aindx;	v2 = 0x00;	p1 |= 0x80;
		} else
		if (admode(AnL)) { a2 = 0x08 + aindx;	v2 = 0x00;	p1 |= 0x02;
		} else
		if (admode(AnU)) { a2 = 0x08 + aindx;	v2 = 0x80;	p1 |= 0x02;
		} else {
			xerr('q', "Second Argument Must Be A Register: An{.L,.U} Or Dn{.L,.U}");
		}
		if ((sz == A_W) && ((p1 & 0x03) != 0x03)) {
			xerr('w', "No .L Or .U Defaults To .L");
		}
		if ((sz == A_L) && ((p1 & 0xC0) != 0xC0)) {
			xerr('w', ".L And .U Are Not Allowed");
		}
		p = ip;
		switch(getnb()) {
		case '<': if (getnb() == '<') { scl = 0x0200; } else { ip = p; }	break;
		case '>': if (getnb() == '>') { scl = 0x0600; } else { ip = p; }	break;
		default:  ip = p;	break;
		}
		p = ip;
		if (getnb() != '1') { ip = p; }	/* Allow >>, >>1, <<, <<1 */
		if (mac && !more()) {		/* MAC, MSAC */
			outaw(opcode = 0xA000 | ((a2 & 0x07) << 9) | ((a2 & 0x08) << 3) | a1);
			outaw(op2 = op | scl | v2 | v1);
			break;
		}
		comma(1);
		if (emac && admode(ACCn)) {	/* Extended Multiply-Accumulate */
			op2 = op | scl | v2 | v1 | ((aindx & 0x02) << 3);
			if (!more()) {		/* Extended MAC, MSAC */
				outaw(opcode = 0xA000 | ((a2 & 0x07) << 9) | ((aindx & 0x01) << 7) | ((a2 & 0x08) << 3) | a1);
				outaw(op2);
				break;
			}
			comma(1);
			if (admode(ACCn)) {	/* Extended MAAAC, MASAC, MSAAC, MSSAC */
				outaw(opcode = 0xA000 | ((a2 & 0x07) << 9) | ((aindx & 0x01) << 7) | ((a2 & 0x08) << 3) | a1);
				outaw(op2 |= (aindx << 2));
				break;
			}
			xerr('q', "Invalid Fourth Argument");
			break;
		}
		op2 = op | (a2 << 12) | scl | v2 | v1 | a1;
		t1 = addr(&e1, sz, &v1, &p1, &x1);
		switch(t1) {
		case S_ARI:
		case S_AINC:
		case S_ADEC:
		case S_ARID:
			p = ip;
			if (getnb() == '&') { op2 |= 0x20; } else { ip = p; }
			break;
		default:
			xerr('q', "Invalid Third Argument");
			break;
		}
		comma(1);
		if (admode(Dn)) { a2 = 0x00 | aindx;
		} else
		if (admode(An)) { a2 = 0x08 | aindx;
		} else {
			xerr('q', "Only Dn Or An Allowed");
		}
		if (mac & !more()) {		/* MAC, MSAC */
			outaw(opcode = 0xA080 | ((a2 & 0x07) << 9) | ((a2 & 0x08) << 3) | t1 | v1);
			outaw(op2);
			ea(&e1, t1, p1, x1, 4, opcode, 0);
			break;
		}
		comma(1);
		if (emac & admode(ACCn)) {	/* Extended MAC, MSAC */
			outaw(opcode = 0xA000 | ((a2 & 0x07) << 9) | ((a2 & 0x08) << 3) | ((aindx & 0x01) << 7) | t1 | v1);
			outaw(op2 | ((aindx & 0x02) << 3));
			ea(&e1, t1, p1, x1, 4, opcode, 0);
			break;
		}
		xerr('q', "[Extended] Multiply-Acumulate Syntax Error");
		break;

	case M_MCLR:
		if (!emac) {
			xerr('i', "Extended Multiply-Accumulate Not Enabled");
			while(getnb()) ;
			break;
		}
		if (admode(ACCn)) {
			a1 = aindx;
			comma(1);
			if (admode(Dn)) { a2 = 0x00 | aindx;
			} else
			if (admode(An)) { a2 = 0x08 | aindx;
			} else {
				xerr('q', "Only Dn Or An Allowed");
			}
			outaw(opcode |= (a1 << 9) | a2);
			break;
		}
		xerr('q', "MOVCLR  ACCn,Rn");
		break;

	/*
	 * The ColdFire Floating Point Co-Processor
	 */

	case F_COID:	/* Set Alternate Floating Point Co-Processor ID */
		expr(&e1, 0);
		if (e1.e_addr <= 7) {
			coid = (int) (e1.e_addr << 9);
		} else {
			xerr('i', "Co-Processor ID Range Allowed Is 0-7, Default Of 1 Set");
			coid = 1 << 9;
		}
		break;

 	case F_TYP1:	/* FABS <ea>,FPx  /  FPy,FPx  /  Fpx */
	case F_TYP2:	/* FADD <ea>,Fpx  /  FPy,FPx */
		t1 = faddr(&e1, fsz, &v1);
		if (t1 == S_FPn) {	/* FPy,FPx  Or  FPx */
			if (fsz != F_D) {
				xerr('w', "FPx Or Fpy,FPx Are By Default Double Precision");
			}
			if (more() && comma(1)) {
				t2 = faddr(&e2, fsz, &v2);
				if (t2 != S_FPn) {
					xerr('a', "Argument Following FPy Must Be FPx");
					v2 = v1;
 				}
			} else {
				if (mp->m_type == F_TYP2) {
					xerr('a', "Syntax Requires FPy,FPx");
				}
				v2 = v1;
			}
			outaw(opcode = 0xF000 | coid | v1);
			outaw(op2 = (F_D << 10) | (v2 << 7) | op);
			break;
		} else
		if (t1 == S_FIMM) {	/* #,FPx */
			xerr('q', "# Source Is Not Supported");
			break;
		}
		t1 = addr(&e1, sz, &v1, &p1, &x1);
		comma(1);

		switch(t1) {
		case S_Dn:
			if (fsz == F_D){
				xerr('q', ".D With Dn Is Invalid");
				break;
			}
		case S_ARI:
		case S_AINC:
		case S_ADEC:
		case S_ARID:
		case S_PCID:
			if (admode(FPn)) {	/* <ea>,FPx */
				outaw(opcode = 0xF000 | coid | t1 | v1);
				outaw(op2 = 0x4000 | (fsz << 10) | (aindx << 7) | op);
				ea(&e1, t1, p1, x1, 4, opcode, 0);
			} else {
				xerr('a', "Second Argument Must Be FPx");
			}
			break;
		default:
			xerr('q', "Illegal First Argument");
			break;
		}
		break;

	case F_TST:	/* FTST  */
		if (admode(FPn)) {	/* FTST FPx */
			if (fsz != F_D) {
				xerr('w', "FTST FPx Is Double Precision");
			}
			outaw(opcode = 0xF000 | coid);
			outaw(op2 = (v1 << 10) | op);
			break;
		}/* FTST <ea> */
		t1 = addr(&e1, sz, &v1, &p1, &x1);
		switch(t1) {
		case S_Dn:
			if (fsz == F_D){
				xerr('q', ".D With Dn Is Invalid");
				break;
			}
		case S_ARI:
		case S_AINC:
		case S_ADEC:
		case S_ARID:
		case S_PCID:
			outaw(opcode = 0xF000 | coid | t1 | v1);
			outaw(op2 = 0x4000 | (fsz << 10) | op);
			ea(&e1, t1, p1, x1, 4, opcode, 0);
			break;
		default:
			xerr('q', "Invalid Addressing Mode");
			break;
		}
		break;

	case F_MOV:
		if ((op == 0x0000) && admode(FCR)) {	/* FPcr,<ea> */
			v1 = aindx;
			if (fsz != F_L) {
				xerr('a', "FMOVE.L Required With FPcr,<ea>");
			}
			comma(1);
			t2 = addr(&e2, sz, &v2, &p2, &x2);
			switch(t2) {
			case S_An:
				if (v1 != 1) {
					xerr('a', "Only FMOVE.L FPIAR,An Allowed");
				}
			case S_Dn:
			case S_ARI:
			case S_AINC:
			case S_ADEC:
			case S_ARID:
				outaw(opcode = 0xF000 | coid | t2 | v2);
				op2 = 0xBC00;			/* Invalid */
				switch(v1) {
				case 1:	op2 = 0xA400;	break;	/* FPIAR */
				case 2:	op2 = 0xA800;	break;	/* FPSR */
				case 4:	op2 = 0xB000;	break;	/* FPCR */
				default:
					xerr('q', "Internal Error");
					break;
				}
				outaw(op2);
				ea(&e2, t2, p2, x2, 4, opcode, 0);
				break;
			default:
				xerr('q', "Invalid Adressing Mode");
				break;
			}
			break;
		}
		if (admode(FPn)) {	/* FPy,FPx or Fpy,<ea> */
			v1 = aindx;
			comma(1);
			if (admode(FPn)) {	/* FMOVE, FSMOVE, FDMOVE  FPy,FPx */
				v2 = aindx;
				if (fsz != F_D) {
					xerr('w', "Fpy,FPx Is By Default Double Precision");
				}
				outaw(opcode = 0xF000 | coid);
				outaw(op2 = op | 0x0000 | (v1 << 10) | (v2 << 7));
				break;
			}
			if ((op == 0x0040) || (op == 0x0044)) {
				xerr('q', "FSMOVE FPy,<ea> And FDMOVE FPy,<ea> Are Not Supported");
			}
			/* FMOVE FPy,<ea> */
			t2 = addr(&e2, sz, &v2, &p2, &x2);
			switch(t2) {
			case S_Dn:
			if (fsz == F_D){
				xerr('q', ".D With Dn Is Invalid");
				break;
			}
			case S_ARI:
			case S_AINC:
			case S_ADEC:
			case S_ARID:
				outaw(opcode = 0xF000 | coid | t2 | v2);
				outaw(op2 = 0x6000 | (fsz << 10) | (v1 << 7) | op);
				break;
			default:
				xerr('a', "Unsupported Addressing Mode");
				break;
			}
			break;
		}
		/* FMOVE <ea>,... */
		t1 = addr(&e1, sz, &v1, &p1, &x1);
		comma(1);
		if ((op == 0x0000) && admode(FCR)) {	/* FMOVE <ea>,FPcr */
			v2 = aindx;
			if (fsz != F_L) {
				xerr('a', "FMOVE.L Required With <ea>,FPcr");
			}
			switch(t1) {
			case S_An:
				if (v2 != 1) {
					xerr('a', "Only FMOVE.L An,FPIAR Allowed");
				}
			case S_Dn:
			case S_ARI:
			case S_AINC:
			case S_ADEC:
			case S_ARID:
			case S_PCID:
				outaw(opcode = 0xF000 | coid | t1 | v1);
				op2= 0x9C00;			/* Invalid */
				switch(v2) {
				case 1:	op2 = 0x8400;	break;	/* FPIAR */
				case 2:	op2 = 0x8800;	break;	/* FPSR */
				case 4:	op2 = 0x9000;	break;	/* FPCR */
				default:
					xerr('q', "Internal Error");
					break;
				}
				outaw(op2);
				ea(&e1, t1, p1, x1, 4, opcode, 0);
				break;
			default:
				xerr('q', "Invalid Addressing Mode");
				break;
			}
			break;
		}
		if (admode(FPn)) {	/* FMOVE <ea>,FPx */
			switch(t1) {
			case S_Dn:
				if (fsz == F_D){
					xerr('q', ".D With Dn Is Invalid");
					break;
				}
			case S_ARI:
			case S_AINC:
			case S_ADEC:
			case S_ARID:
			case S_PCID:
				outaw(opcode = 0xF000 | coid | t1 | v1);
				outaw(op2 = 0x4000 | (fsz << 10) | (aindx << 7) | op);
				ea(&e1, t1, p1, x1, 4, opcode, 0);
				break;
			default:
				xerr('q', "Invalid Addressing Mode");
				break;
			}
			break;
		}
		xerr('q', "Invalid Addressing Mode");
		break;

	case F_MOVM:	/* FMOVEM */
		p = ip;
		if ((getnb() == '#') && admode(FPn)) {	/* FMOVEM  <list>,<ea> */
			ip = p;
			getnb();	/* Skip '#' */
			v1 = fmvlist(&rc);
			comma(1);
			t2 = addr(&e2, sz, &v2, &p2, &x2);
			if ((t2 != S_ARI) && (t2 != S_ARID)) {
				xerr('q', "Unsupported Addressing Mode");
			}
			outaw(opcode = 0xF000 | coid | t2 | v2);
			outaw(op2 = 0xF000 | v1);
			ea(&e2, t2, p2, x2, 4, opcode, 0);
	        	break;
		}
		ip = p;
		t1 = addr(&e1, sz, &v1, &p1, &x1);
		if ((t1 != S_ARI) && (t1 != S_ARID) & (t1 != S_PCID)) {
			xerr('q', "Unsupported Addressing Mode");
		}
		comma(1);
		p = ip;
		if ((getnb() == '#') && admode(FPn)) {
			ip = p;
			getnb();	/* Skip '#' */
			v2 = fmvlist(&rc);
			outaw(opcode = 0xF000 | coid | t1 | v1);
			outaw(op2 = 0xD000 | v2);
			ea(&e1, t1, p1, x1, 4, opcode, 0);
			break;
		}
		xerr('q', "Invalid Addressing Mode");
		break;

	case F_BCC:	/* FBcc Label */
		expr(&e1, 0);
		dsplcmnt = (INT32) (e1.e_addr - dot.s_addr - 2);
		switch(fsz) {
		case F_A:		/* FBcc Auto Mode */
			if (e1.e_addr >= dot.s_addr) {
				e1.e_addr -= fuzz;
			}
			if (pass == 0) {
				dot.s_addr += 6;
			} else
			if (pass == 1) {
				dot.s_addr += 2;
				if (mchpcr(&e1)) {
					/* At This Point A Zero Displacement Cannot Be Detected */
					/* And The Exact Range Is 'fuzzy' */
					setwl(dsplcmnt);
				} else {
					dot.s_addr += 4;
				}
			} else
			if (mchpcr(&e1)) {
				if (getbit()) {
					fsz = F_W;
					chkwrng(dsplcmnt, "Branching Range Exceeded");
					outaw(opcode = 0xF080 | coid | op);
					outaw(dsplcmnt);
				} else {
					fsz = F_L;
					outaw(opcode = 0xF0C0 | coid | op);
					outa4b(dsplcmnt);
				}
			} else {
				fsz = F_L;
				outaw(opcode = 0xF0C0 | coid | op);
				e1.e_addr += dot.s_addr - pc + 2;
				outr4b(&e1, R_PCR);
			}
			break;
		case F_W:	/* FBcc.W 16-Bit Mode */
			if (mchpcr(&e1)) {
				chkwrng(dsplcmnt, "Branching Range Exceeded");
				outaw(opcode = 0xF080 | coid | op);
				outaw(dsplcmnt);
			} else {
				outaw(opcode = 0xF080 | coid | op);
				e1.e_addr += dot.s_addr - pc;
				outrw(&e1, R_PCR);
			}
			break;		
		case F_L:	/* FBcc.L 32-Bit Mode */
			if (mchpcr(&e1)) {
				outaw(opcode = 0xF0C0 | coid | op);
				outa4b(dsplcmnt);
			} else {
				outaw(opcode = 0xF0C0 | coid | op);
				e1.e_addr += dot.s_addr - pc + 2;
				outr4b(&e1, R_PCR);
			}
			break;
		default:
			break;
		}
		if (e1.e_mode != S_USER)
			rerr();
		break;

	case F_NOP:	/* FNOP */
		outaw(opcode = 0xF080 | coid);
		outaw(op2 = op);
		break;

	case F_SVRS:	/* FSAVE / FRESTORE */
		t1 = addr(&e1, sz, &v1, &p1, &x1);
		switch(t1) {
		case S_PCID:
			if (op == 0xF300) {
				xerr('q', "Invalid Addressing Mode");
			}
		case S_ARI:
		case S_ARID:
			outaw(opcode = op | coid | t1 | v1);
			ea(&e1, t1, p1, x1, 2, opcode, 0);
			break;
		default:
			xerr ('q', "Invalid Addressing Mode");
			break;
		}
		break;

	case S_FLT16:
		opcycles = OPCY_FLT16; 
		do {
			atowrd();
			outaw(rslt[4]);
		} while (comma(0));
		break;

	case S_FLT32:
		opcycles = OPCY_FLT32;
		do {
 			atoflt();
			outaw(rslt[4]);
			outaw(rslt[3]);
		} while (comma(0));
		break;

	case S_FLT64:
		opcycles = OPCY_FLT64;
		do {
			atodbl();
			outaw(rslt[4]);
			outaw(rslt[3]);
			outaw(rslt[2]);
			outaw(rslt[1]);
		} while (comma(0));
		break;

	default:
		opcycles = OPCY_ERR;
		xerr('o', "Internal Opcode Error");
		break;
	}
}

VOID
im(e1, opcode, opflg)
struct expr *e1;
a_uint opcode;
int opflg;
{
	if (opflg) outaw(opcode);

	switch(sz) {
	default:
	case A_B:	outab(0);	outrb(e1, 0);	break;
	case A_W:			outrw(e1, 0);	break;
	case A_L:			outr4b(e1, 0);	break;
	}
}

VOID
ea(e1, t1, p1, x1, pcofst, opcode, opflg)
struct expr *e1;
int t1, p1, x1;
a_uint pcofst;
a_uint opcode;
int opflg;
{
	INT32 v1;
	struct expr dp;

	if (opflg) outaw(opcode);

	switch(t1) {
	case S_Dn:	/*    Dn    */
	case S_An:	/*    An    */
	case S_ARI:	/*   (An)   */
	case S_AINC:	/*   (An)+  */
	case S_ADEC:	/*  -(An)   */
		break;
	case S_ARID:	/*  d(An) or (d,An)   */
		outrw(e1, R_SGND);
		break;
	case S_ARIDX:
		outab(x1 >> 8);
		outrb(e1, R_SGND);
		break;
	case S_SHRT:
	case S_LONG:
		if (pass == 0) {
			dot.s_addr += 4;
		} else
		if (pass == 1) {
			if (e1->e_addr >= dot.s_addr) {
				e1->e_addr -= fuzz;
			}
			if (setbit(e1->e_mode == S_SHRT)) {
				dot.s_addr += 2;
			} else {
				dot.s_addr += 4;
			}
		} else {
			if (getbit()) {
				switch(p1) {
				case 0:	/* Abs.W */
					outrw(e1, R_SGND);
					break;
				case 1:	/* Low Page 0x0000-0x7FFF */
					if (zpg != dpglo) {
						zpg = dpglo;
						clrexpr(&dp);
						dp.e_addr = 0;
						p_mask = 0x7FFF;
						outdp(dpglo, &dp, 0);
					}
					outrw(e1, R_PAG0);
					break;
				case 2:	/* High Page 0xFFFF8000-0xFFFFFFFF */
					if (zpg != dpghi) {
						zpg = dpghi;
						clrexpr(&dp);
						dp.e_addr = ~0x7FFF;
						p_mask = 0x7FFF;
						outdp(dpghi, &dp, 0);
					}
					outrw(e1, R_PAGN);
					break;
				default:
					xerr('a', "Internal Paging Error");
					break;
				}
			} else {
				outr4b(e1, 0);	/* Abs.L */
			}
		}
		break;
	case S_PCID:	/* d(PC) */
		if (is_abs(e1) || mchpcr(e1)) {
			/* d is a label (in the same area) */
			v1 = (INT32) (e1->e_addr - (pc + pcofst));
			/* d is a number (constant) */
			if (is_abs(e1)) v1 += (INT32) pc;
			chkwrng(v1, "PC-Relative Range Exceeded");
			outaw(v1);
		} else {
			/* d is external (treated as a label) */
			e1->e_addr += pcofst;
			outrw(e1, R_PCR);
		}
		break;
	case S_PCIDX:	/* d(PC,Xi)  or (d,PC,Xn) */
		if (is_abs(e1) || mchpcr(e1)) {
			/* d is a label (in the same area) */
			v1 = (INT32) (e1->e_addr - (pc + pcofst));
			/* d is a number (constant) */
			if (is_abs(e1)) v1 += (INT32) pc;
			chkbrng(v1, "PC-Relative Range Exceeded");
			outab(x1 >> 8);
			outab(v1);
		} else {
			/* d is external (treated as a label) */
			e1->e_addr += pcofst;
			outab(x1 >> 8);
			outrb(e1, R_PCR);
		}
		break;
	case S_IMM:	/* #N */
		switch(sz) {
		default:
		case A_B:	/* .B */
			outab(0);
			outrb(e1, 0);
			break;
		case A_W:	/* .W */
			outrw(e1, 0);
			break;
		case A_L:	/* .L */
			outr4b(e1, 0);
			break;
		}
		break;
	default:
		xerr('a', "Unknown Addressing Mode");
		break;
	}
}

VOID
chkbrng(v1, p)
INT32 v1;
char *p;
{
#ifdef LONGINT
	if ((v1 < -128l) || (v1 > 127l)) {
#else
	if ((v1 < -128) || (v1 > 127)) {
#endif
		xerr('a', p);
	}
}

VOID
chkwrng(v1, p)
INT32 v1;
char *p;
{
#ifdef LONGINT
	if ((v1 < -32768l) || (v1 > 32767l)) {
#else
	if ((v1 < -32768) || (v1 > 32767)) {
#endif
		xerr('a', p);
	}
}

int
setwl(v1)
INT32 v1;
{
	int wl;

#ifdef LONGINT
	if (setbit((v1 >= -32768l) && (v1 < 32768l))) {
#else
	if (setbit((v1 >= -32768) && (v1 < 32768))) {
#endif
		wl = 2;	/* Word */
	} else {
		wl = 4;	/* Long */
	}
	dot.s_addr += wl;
	return(wl);
}

int
setbwl(v1)
INT32 v1;
{
	int bwl;

#ifdef LONGINT
	if (setbit((v1 >= -128l) && (v1 < 128l))) {
#else
	if (setbit((v1 >= -128) && (v1 < 128))) {
#endif
		bwl = 2;	/* Byte */
	} else
#ifdef LONGINT
	if (setbit((v1 >= -32768l) && (v1 < 32768l))) {
#else
	if (setbit((v1 >= -32768) && (v1 < 32768))) {
#endif
		bwl = 4;	/* Word */
	} else {
		bwl = 6;	/* Long */
	}
	dot.s_addr += bwl;
	return(bwl);
}

/*
 * Floating Immediates
 */
VOID
fimm(e1, fsz)
struct expr *e1;
int fsz;
{
	switch(fsz) {
	case F_B:	/* __.B */
		outab(0);
		outrb(e1, 0);
		break;
	case F_W:	/* __.W */
		outrw(e1, 0);
		break;
	case F_L:	/* __.L */
		outr4b(e1, 0);
		break;
	default:
	case F_S:	/* __.S */
		outaw(rslt[4]);
		outaw(rslt[3]);
		break;
	}
}

/*
 * Create A Processor Register List
 *
 * Control And (An)+ Bits:
 *  15  14  13  12  11  10  9   8   7   6   5   4   3   2   1   0
 * --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
 *  A7  A6  A5  A4  A3  A2  A1  A0  D7  D6  D5  D4  D3  D2  D1  D0
 */
int
mvlist(rc)
int *rc;
{
	int c;
	char *p;
	int i, list, v1, v2;

	p = ip;
	*rc = 0;
	list = 0;
	/*
	 * Allow Forms - <list> or #<list>
	 */
	if ((admode(Dn) || admode(An)) ||
	   ((getnb() == '#') && (admode(Dn) || admode(An)))) {
		ip = p;
		if (getnb() != '#') {	/* Skip '#' */
			ip = p;
		}
		do {
			/* Dn/Dx-Dy/... */
			if (admode(Dn)) {
				v1 = aindx;
				if ((c = getnb()) == '-') {
					if (admode(Dn)) {
						v2 = aindx;
						if (v1 >= v2) {
							xerr('q', "Dx-Dy, y Must Be Greater Than x");
						}
						for (i=v1; i<=v2; i++) {
							list |= (0x0001 << i);
							*rc += 1;
						}
					} else {
						xerr('q', "Dx-Dy Required");
					}
				} else {
					list |= (0x0001 << v1);
					*rc += 1;
					unget(c);
				}
			} else
			/* An/Ax-Ay/... */
			if (admode(An)) {
				v1 = aindx;
				if ((c = getnb()) == '-') {
					if (admode(An)) {
						v2 = aindx;
						if (v1 >= v2) {
							xerr('q', "Ax-Ay, y Must Be Greater Than x");
						}
						for (i=v1; i<=v2; i++) {
							list |= (0x0100 << i);
							*rc += 1;
						}
					} else {
						xerr('q', "Ax-Ay Required");
					}
				} else {
					list |= (0x0100 << v1);
					*rc += 1;
					unget(c);
				}
			} else {
				break;
			}
			p = ip;
			if (more() == 0) {
				break;
			}
			c = getnb();
		} while (c == '/');
	}
	ip = p;
	return(list);
}

/*
 * Create A Floating Register List
 *
 * (An)+ Or Control Bits:
 *  7   6   5   4   3   2   1   0
 * --- --- --- --- --- --- --- ---
 * FP0 FP1 FP2 FP3 FP4 FP5 FP6 FP7
 */
int
fmvlist(rc)
int *rc;
{
	int c;
	char *p;
	int i, list, v1, v2;

	p = ip;
	*rc = 0;
	list = 0;
	/*
	 * Allow Forms - <list> or #<list>
	 */
	if ((admode(FPn)) ||
	   ((getnb() == '#') && admode(FPn))) {
		ip = p;
		if (getnb() != '#') {	/* Skip '#' */
			ip = p;
		}
		do {
			/* FPn/FPx-FPy/... */
			if (admode(FPn)) {
				v1 = aindx;
				if ((c = getnb()) == '-') {
					if (admode(FPn)) {
						v2 = aindx;
						if (v1 >= v2) {
							xerr('q', "FPx-FPy, y Must Be Greater Than x");
						}
						for (i=v1; i<=v2; i++) {
							list |= (0x0080 >> i);
							*rc += 1;
						}
					} else {
						xerr('q', "FPx-FPy Required");
					}
				} else {
					list |= (0x0080 >> v1);
					*rc += 1;
					unget(c);
				}
			} else {
				break;
			}
			p = ip;
			if (more() == 0) {
				break;
			}
			c = getnb();
		} while (c == '/');
		ip = p;
	}
	return(list);
}

/*
 * Branch/Jump PCR Mode Check
 */
int
mchpcr(esp)
struct expr *esp;
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

/*
 * Store `b' in the next slot of the bit table.
 * If no room, force the longer form of the offset.
 */
int
setbit(b)
int b;
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
getbit()
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
	return (f);
}

/*
 * Machine specific .enabl/.dsabl terms.
 */
int
mchoptn(id, v)
char *id;
int v;
{
	/* Substitute Alternate Instruction */
	if (symeq(id, "alt", 1)) { alt = v; } else
	/* Automatic Direct Page (Constants) */
	if (symeq(id, "autodpcnst", 1)) { autodpcnst = v; } else
	/* Automatic Direct Page (Symbols) */
	if (symeq(id, "autodpsmbl", 1)) { autodpsmbl = v; } else
	/* Multiply-Accumulate Unit */
	if (symeq(id, "mac", 1)) { mac = v; emac = v ? 0 : emac; } else
	/* Extended Multiply-Accumulate Unit */
	if (symeq(id, "emac", 1)) { emac = v; mac = v ? 0 : mac; } else
	/* Floating Point Unit */
	if (symeq(id, "flt", 1)) { flt = v; } else
	/* Floating Point Truncation */
	if (symeq(id, "fpt", 1)) { fpt = v; } else {
		return(0);
	}
	return(1);
}

/*
 * Machine specific initialization.
 */
VOID
minit()
{
	int i;

	/*
	 * Byte Order
	 */
	hilo = 1;
	/*
	 * Addressing Size
	 */
	exprmasks(4);
	/*
	 * Set Default Machine Parameters (Default From 68K)
	 */
	coid = 1 << 9;	/* Floating Point ID */
	/*
	 * Reset Options
	 */
	alt = 1;	/* Alternate Instructions */
	autodpcnst = 1;	/* Automatic Direct Page Addressing With Constants */
	autodpsmbl = 1;	/* Automatic Direct Page Addressing With Symbols*/
	mac = 0;	/* Multiply-Accumulate Unit */
	emac = 0;	/* Extended Multiply-Accumulate Unit */
	flt = 0;	/* Floating Point Unit */
	fpt = 0;	/* Floating Point Truncation */
        /*
	 * Reset Pages
	 */
	zpg = NULL;
	dpglo = NULL;
	dpghi = NULL;
	/*
	 * Multi-pass Processing
	 */
	passlmt = 100;	/* Maximum Pass 1 Loops */
	if (pass < 2) {
		for (i=0; i<NB; i++) {
			bb[i] = 0;
		}
	}
	/*
	 * Reset Bit Pointer
	 */
	bp = bb;
	bm = 1;
	/*
	 * External Calls
	 */
	/* .enabl/.dsabl Extension */
	mchoptn_ptr = mchoptn;
}

