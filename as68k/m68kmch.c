/* m68kmch.c */

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


char	*cpu	= "Motorola M68000";
char	*dsft	= "asm";

int	mchtyp;	/* Machine Type */
int	flttyp;	/* Floating Point Type */

int	rc;	/* Register Count For Instructions */
int	sz;	/* Mnemonic Instruction Size */
int	fsz;	/* Floating Instruction Size */

int	alt;	/* Substitute Alternate Instruction */

int	coid;	/* Co-Processor ID */

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
	int c, rf, cycles;
	struct expr e1, e1xi, e2, e2xi;
	struct sym *sp;
	int t1, t2, v1, v2, a1, a2, p1, p2, x1, x2;
	int vimm;
	char id[NCPS];
	INT32 dsplcmnt;
	char *p, *q;

	clrexpr(&e1);
	clrexpr(&e1xi);
	clrexpr(&e2);
	clrexpr(&e2xi);

	pc = dot.s_addr;
	op = mp->m_valu;
	opcode = op;
	op2 = 0;
	cycles = 0;
	t1 = t2 = v1 = v2 = a1 = a2 = p1 = p2 = x1 = x2 = 0;
	rc = 0;
	sz =  mp->m_flag & 0x03;
	fsz = mp->m_flag & 0x07;
	rf = mp->m_type;

	if ((rf >= S_68020) && (mchtyp < M_68020) ){
		xerr('w', "Instruction Requires 68020");
	}
	if ((rf >= F_BGN) && (rf <= F_END)) {
		fsz2sz();	/* Translate fsz To sz */
	}

	switch (rf) {

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
	 * The MC68xxx Processor
	 */

 	case S_68XXX:
		switch(op) {
		default:
		case M_68000:	sym[2].s_addr = mchtyp = (int) op;	cpu = "Motorola 68000";	break;
		case M_68008:	sym[2].s_addr = mchtyp = (int) op;	cpu = "Motorola 68008";	break;
		case M_68010:	sym[2].s_addr = mchtyp = (int) op;	cpu = "Motorola 68010";	break;
		case M_68020:	sym[2].s_addr = mchtyp = (int) op;	cpu = "Motorola 68020";	break;
		case M_68881:
		case M_68882:	flttyp = (int) op;
			if (more()) {
				expr(&e1, 0);
				if (e1.e_addr == 0) {
					flttyp = 0;
				}
				while (more()) { getnb(); }
			}
			if (flttyp) {	/* Once Set Always Set */
				cycldgts = 4;
			}
			break;
		}
		lmode = SLIST;
		break;

 	case S_FCOID:
		expr(&e1, 0);
		if (e1.e_addr <= 7) {
			coid = (int) (e1.e_addr << 9);
		} else {
			xerr('i', "Co-Processor ID Range Allowed Is 0-7, Default Of 1 Set");
			coid = 1 << 9;
		}
		lmode = SLIST;
		break;

	case S_TYP1:	/* ABCD, SBCD, ADDX, SUBX */
		/* xxx  Dy,Dx  or  xxx  -(Ay),-(Ax) */
		t1 = addr(&e1, &e1xi, sz, &v1, &p1, &x1);
		comma(1);
		t2 = addr(&e2, &e2xi, sz, &v2, &p2, &x2);

		switch((op >> 8) & 0xFF) {
		case 0xC1:	/* ABCD */
		case 0x81:	/* SBCD */
			if (sz != A_B) {
				xerr('q', "Only Byte Operation Allowed");
			}
			break;
		default:
			break;
		}

		/* xxx  Dy, Dx */
		if ((t1 == S_Dn) && (t2 == S_Dn)) {
			opcode |= ((v2 << 9) | v1);
			outaw(opcode);
		} else
		/* xxx  -(Ay), -(Ax) */
		if ((t1 == S_ADEC) && (t2 == S_ADEC)) {
			opcode |= ((v2 << 9) | 0x08 | v1);
			outaw(opcode);
		} else {
			xerr('q', "Unsupported Addressing Mode");
		}
		break;

	case S_TYP2:	/* ADD, AND, OR, SUB */
		/* xxx Dn,<ea>  or xxx <ea>,Dn */
		t1 = addr(&e1, &e1xi, sz, &v1, &p1, &x1);
		comma(1);

		/* xxx #,(CCR,SR) */
		if (alt && (t1 == S_IMM) && admode(Sreg)) {
			/* ANDI,  ORI (SR, CCR) */
			if (aindx == S_CCR) {
				if ((op & ~0xFF) == 0xC000) { op = 0x023C; } else /* ANDI */
				if ((op & ~0xFF) == 0x8000) { op = 0x003C;	  /* ORI */
				} else {
					xerr('q', "Only AND/EOR/OR With #,CCR Or #,SR Allowed");
					break;
				}
				if (mp->m_flag & A_A) {
					sz = A_B;
				}
				if (sz != A_B) {
					xerr('q', "#,CCR Is Of Byte Size");
				}
				opcode = op;
				outaw(opcode);
				outab(0);
				outrb(&e1, 0);
			} else
			if (aindx == S_SR) {
				if ((op & ~0xFF) == 0xC000) { op = 0x027C; } else /* ANDI */
				if ((op & ~0xFF) == 0x8000) { op = 0x007C;	  /* ORI */
				} else {
					xerr('q', "Only AND/EOR/OR With #,CCR Or #,SR Allowed");
					break;
				}
				if (mp->m_flag & A_A) {
					sz = A_W;
				}
				if (sz != A_W) {
					xerr('a', "#,SR Is Of Word Size");
				}
				opcode = op;
				outaw(opcode);
				outrw(&e1, 0);
			} else {
				xerr('q', "Only AND/EOR/OR With #,CCR Or #,SR Allowed");
			}
			break;
		}
		t2 = addr(&e2, &e2xi, sz, &v2, &p2, &x2);

		/* xxx <ea>,An */
		if (alt && (t2 == S_An)) {
			/* Use xxxA <ea>,An */
			switch((op >> 8) & 0xFF) {
			case 0xD0:	/* ADD */
			case 0x90:	/* SUB */
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
				break;
			case 0xC0:	/* AND */
			case 0x80:	/* OR */
				xerr('q', "Only ADD/SUB Support 'An' As Destination");
				break;
			default:
				xerr('q', "m68kmch.c Internal Error");
				break;
			}
			ea(&e1, &e1xi, t1, p1, x1, 2, opcode, 1);
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
						ea(&e2, &e2xi, t2, p2, x2, 2, opcode, 1);
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
				ea(&e2, &e2xi, t2, p2, x2, dot.s_addr - pc, opcode, 0);
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
					if (sz == A_B) {
						xerr('q', "Byte Mode With 'An' As Source Is Not Allowed");
					}
					break;
				case 0xC0:	/* AND */
				case 0x80:	/* OR */
					xerr('q', "This Instruction Does Not Support 'An' As First Argument");
					break;
				default:
					xerr('q', "m68kmch.c Internal Error");
					break;
				}
			}
			opcode = (op & ~0xFF) | (v2 << 9) | (sz << 6) | t1 | v1;
			ea(&e1, &e1xi, t1, p1, x1, 2, opcode, 1);
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
				ea(&e2, &e2xi, t2, p2, x2, 2, opcode, 1);
				break;
			}
		} else {
			xerr('q', "One Of The Arguments Must Be Dn");
		}
		break;

	case S_TYP3:	/* ADDA, CMPA, SUBA */
		/* xxx <ea>,An */
		t1 = addr(&e1, &e1xi, sz, &v1, &p1, &x1);
		comma(1);
		t2 = addr(&e2, &e2xi, sz, &v2, &p2, &x2);

		/* xxx <ea>,An */
		if (t2 == S_An) {
			switch(sz) {
			case A_B:
				xerr('q', "Byte Mode With 'An' As Destination Is Not Allowed");
				break;
			case A_W:
				opcode |= ((v2 << 9) | (3 << 6) | t1 | v1);
				break;
			case A_L:
				opcode |= ((v2 << 9) | (7 << 6) | t1 | v1);
				break;
			default:
				xerr('q', "m68kmch.c Internal Error");
				break;
			}
			ea(&e1, &e1xi, t1, p1, x1, 2, opcode, 1);
			break;
		} else {
			xerr('a', "Second Argument Must Be An");
		}
		break;

	case S_TYP4:	/* ADDI, ANDI, CMPI, EORI, ORI, SUBI */
		/* xxx IMM,An */
		t1 = addr(&e1, &e1xi, sz, &v1, &p1, &x1);

		if (t1 != S_IMM) {
			xerr('q', "First Armument Must Be A #");
		}
		comma(1);
		if (admode(Sreg)) {
			/* ANDI, EORI, ORI (SR, CCR) */
			if (aindx == S_CCR) {
 				if ((op & ~0xFF) == 0x0200) { op = 0x023C; } else
				if ((op & ~0xFF) == 0x0A00) { op = 0x0A3C; } else
				if ((op & ~0xFF) == 0x0000) { op = 0x003C;
				} else {
					xerr('q', "Only ANDI/EORI/ORI With CCR Or SR Allowed");
					break;
				}
				if (mp->m_flag & A_A) {
					sz = A_B;
				}
				if (sz != A_B) {
					xerr('q', "#,CCR Is Of Byte Size");
				}
				opcode = op;
				outaw(opcode);
				outab(0);
				outrb(&e1, 0);
			} else
			if (aindx == S_SR) {
				if ((op & ~0xFF) == 0x0200) { op = 0x027C; } else
				if ((op & ~0xFF) == 0x0A00) { op = 0x0A7C; } else
				if ((op & ~0xFF) == 0x0000) { op = 0x007C;
				} else {
					xerr('q', "Only ANDI/EORI/ORI With CCR Or SR Allowed");
					break;
				}
				if (mp->m_flag & A_A) {
					sz = A_W;
				}
				if (sz != A_W) {
					xerr('q', "#,SR Is Of Word Size");
				}
				opcode = op;
				outaw(opcode);
				outrw(&e1, 0);
			} else {
				xerr('q', "Only ANDI/EORI/ORI With CCR Or SR Allowed");
			}
			break;
		}
		/* ADDI, ANDI, CMPI, EORI, ORI, SUBI */
		t2 = addr(&e2, &e2xi, sz, &v2, &p2, &x2);

		switch(t2) {
		case S_PCID:
		case S_PCIDX:	/* CMPI (68020) Additional Modes */
			if ((mchtyp >= M_68020) && ((op & 0xFF00) == 0x0C00)) { break; }
		case S_An:
		case S_IMM:
			xerr('q', "Invalid Addressing Mode");
			break;
		default:
			break;
		}
		opcode |= ((sz << 6) | t2 | v2);
		im(&e1, opcode, 1);
		ea(&e2, &e2xi, t2, p2, x2, dot.s_addr - pc, opcode, 0);
		break;

	case S_TYP5:	/* ADDQ, SUBQ */
		/* xxx #,An */
		t1 = addr(&e1, &e1xi, sz, &v1, &p1, &x1);
		comma(1);
		t2 = addr(&e2, &e2xi, sz, &v2, &p2, &x2);

		if (t1 == S_IMM) {
			if ((t2 == S_An) && (sz == A_B)) {
				xerr('q', "Byte Mode With 'An' As Destination Is Not Allowed");
			}
		} else {
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
					ea(&e2, &e2xi, t2, p2, x2, pc, opcode, 1);
				} else {
					xerr('q', "Argument Has Range Of 1-8");
				}
			} else {
				opcode |= ((sz << 6) | t2 | v2);
				outrwm(&e2, R_QBITS, opcode);
				ea(&e2, &e2xi, t2, p2, x2, 2, opcode, 0);
			}
			break;
		}
		break;

	case S_TYP6:	/* DIVS, DIVU, MULS, MULU */
		/* xxx <ea>,Dn */
		t1 = addr(&e1, &e1xi, sz, &v1, &p1, &x1);
		comma(1);

		if (admode(Dn)) {
			if (t1 == S_An) {
				xerr('q', "First Argument Must Not Be An");
			}
			a1 = a2 = aindx;
			switch(sz) {
			default:
			case A_B:
				xerr('a', ".B Is Invalid");
			case A_W:	/* DIVS.W, DIVU.W, MULS.W, MULU.W */
				opcode |= ((a1 << 9) | t1 | v1);
				ea(&e1, &e1xi, t1, p1, x1, 2, opcode, 1);
				break;
			case A_L:	/* DIVS.L, DIVU.L, MULS.L, MULU.L */
				if (mchtyp < M_68020) {
					xerr('w', ".L Requires 68020");
				}
				if (more()) {
					if ((getnb() == ':') && admode(Dn)) {
						a1 |= 0x0400;
						a2  = aindx;
					} else {
						xerr('q', "Invalid Dn:Dn");
					}
				}
				switch(op) {
				default:
				case 0x0001:	/* DIVSL.L */
					opcode = 0x4C40;
					a1 &= ~0x0400;
					a1 |= 0x0800 | (a2 << 12);
					break;
				case 0x81C0:	/* DIVS.L */
					opcode = 0x4C40;
					a1 |= 0x0800 | (a2 << 12);
					break;
				case 0x0002:	/* DIVUL.L */
					opcode = 0x4C40;
					a1 &= ~0x0400;
					a1 |= 0x0000 | (a2 << 12);
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
				ea(&e1, &e1xi, t1, p1, x1, 4, opcode, 0);
			}
		} else {
			xerr('q', "Second Argument Must Be Dn Or Dn:Dn");
		}
		break;

	case S_TYP7:	/* CLR, NEG, NEGX, NOT, TST */
		/* xxx <ea> */
		t1 = addr(&e1, &e1xi, sz, &v1, &p1, &x1);

		switch(t1) {
		case S_PCID:
		case S_PCIDX:
			if ((mchtyp >= M_68020) && ((op & 0xFF00) == 0x4A00)) {	/* TST */
 		        	break;
			}
		case S_An:
		case S_IMM:
			xerr('q', "Invalid Addressing Mode");
			break;
		default:
			break;
		}
		opcode |= ((sz << 6) | t1 | v1);
		ea(&e1, &e1xi, t1, p1, x1, 2, opcode, 1);
		break;

	case S_TYP8:	/* JMP, JSR, LEA, PEA */
		t1 = addr(&e1, &e1xi, sz, &v1, &p1, &x1);

		switch(t1) {
		case S_Dn:
		case S_An:
		case S_AINC:
		case S_ADEC:
		case S_IMM:
			if (sz != A_L) {
				xerr('q', "Invalid Instruction Size");
			} else {
				xerr('q', "Invalid Addressing Mode");
			}
			break;
		default:
			if (op == 0x41C0) {
				/* LEA */
				comma(1);
				t2 = addr(&e2, &e2xi, sz, &v2, &p2, &x2);

				if (t2 != S_An) {
					xerr('q', "Second Argument Must Be An");
				}
				opcode |= ((v2 << 9) | t1 | v1);

			} else {
				/* JMP, JSR, PEA */
				opcode |= (t1 | v1);
			}
			if (sz != A_L) {
				xerr('q', "Invalid Instruction Size");
			}
			ea(&e1, &e1xi, t1, p1, x1, 2, opcode, 1);
		}
		break;

	case S_TYP9:	/* NBCD, TAS */
		t1 = addr(&e1, &e1xi, sz, &v1, &p1, &x1);

		switch(t1) {
		case S_An:
		case S_PCID:
		case S_PCIDX:
		case S_IMM:
			if (sz != A_B) {
				xerr('q', "Invalid Instruction Size");
			} else {
				xerr('q', "Invalid Addressing Mode");
			}
			break;
		default:
			if (sz != A_B) {
				xerr('q', "Invalid Instruction Size");
			}
			opcode |= (t1 | v1);
			ea(&e1, &e1xi, t1, p1, x1, 2, opcode, 1);
			break;
		}
		break;

	case S_SHFT:	/* ASL, ASR, LSL, LSR, ROL, ROR, ROXL, ROXL */
		t1 = addr(&e1, &e1xi, sz, &v1, &p1, &x1);

		if (comma(0)) {
			t2 = addr(&e2, &e2xi, sz, &v2, &p2, &x2);

			/* ___ Dn,Dn */
			if ((t1 == S_Dn) && (t2 == S_Dn)) {
				opcode |= ((v1 << 9) | (sz << 6) | 0x20 | v2);
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
					opcode |= (((vimm & 7) << 9) | (sz << 6) | 0x00 | v2);
					outaw(opcode);
				} else {
					opcode |= ((sz << 6) | 0x00 | v2);
					outrwm(&e1, R_QBITS, opcode);
				}
			} else {
				xerr('q', "First Argument Was Not A # Or Dn");
			}
		} else {
			/* ___ <ea> */
			switch(t1) {
			case S_Dn:
			case S_An:
			case S_PCID:
			case S_PCIDX:
			case S_IMM:
				xerr('q', "Invalid Addressing Mode");
				break;
			default:
				/* One Bit Only */
				if ((mp->m_flag & ALT_W) != ALT_W) {
					xerr('q', "Only A One Bit Shift On A Word");
				}
				switch(op) {
				default:
				case 0xE140:
				case 0xE180:	opcode = 0xE1C0;	break;	/* asl <ea> */
				case 0xE040:
				case 0xE080:	opcode = 0xE0C0;	break;	/* asr <ea> */
				case 0xE148:
				case 0xE188:	opcode = 0xE3C0;	break;	/* lsl <ea> */
				case 0xE048:
				case 0xE088:	opcode = 0xE2C0;	break;	/* lsr <ea> */
				case 0xE158:
				case 0xE198:	opcode = 0xE7C0;	break;	/* rol <ea> */
				case 0xE058:
				case 0xE098:	opcode = 0xE6C0;	break;	/* ror <ea> */
				case 0xE150:
				case 0xE190:	opcode = 0xE5C0;	break;	/* roxl <ea> */
				case 0xE050:
				case 0xE090:	opcode = 0xE4C0;	break;	/* roxr <ea> */
				}
				opcode |= (t1 | v1);
				ea(&e1, &e1xi, t1, p1, x1, 2, opcode, 1);
				break;
			}
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
						if(mchtyp >= M_68020) {
#ifdef LONGINT
							if (setbit((dsplcmnt < -32768l) || (dsplcmnt > 32767l))) {
#else
							if (setbit((dsplcmnt < -32768) || (dsplcmnt > 32767))) {
#endif
								dot.s_addr += 2;
							}
						} else {
					    		setbit(0);
					    	}
					}
					dot.s_addr += 2;
				} else {
					if (mchtyp >= M_68020) {
						dot.s_addr += 6;
					} else {
						dot.s_addr += 4;
					}
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
					sz = B_S;
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
				if (mchtyp >= M_68020) {
					outaw(op | 0x00FF);
					e1.e_addr += dot.s_addr - pc + 2;
					outr4b(&e1, R_PCR);
					sz = B_L;
				} else {
					outaw(op);
					e1.e_addr += dot.s_addr - pc;
					outrw(&e1, R_PCR);
					sz = B_W;
				}
			}
			if ((sz == B_L) && (mchtyp < M_68020)) {
				xerr('w', "32-Bit Branches Require 68020");
			}
			break;
		case B_S:	/* Bcc.s Short Mode */
			if (mchpcr(&e1)) {
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
			if (mchtyp < M_68020) {
				xerr('w', "32-Bit Branches Require 68020");
			}
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

	case S_DBCC:	/* DBcc Dn,Label */
		t1 = addr(&e1, &e1xi, sz, &v1, &p1, &x1);

		comma(1);
		expr(&e2, 0);
		if (mchpcr(&e2)) {
			dsplcmnt = (INT32) (e2.e_addr - dot.s_addr - 2);
			chkwrng(dsplcmnt, "Branching Range Exceeded");
			outaw(op | v1);
			outaw(dsplcmnt);
		} else {
			outaw(op | v1);
			e1.e_addr += dot.s_addr - pc;
			outrw(&e2, R_PCR);
		}
		if (t1 != S_Dn) {
			xerr('q', "First Argument Must Be Dn");
		}
		if (e2.e_mode != S_USER)
			rerr();
		break;

	case S_SCC:	/* Scc <ea> */
		t1 = addr(&e1, &e1xi, sz, &v1, &p1, &x1);

		switch(t1) {
		case S_An:
		case S_PCID:
		case S_PCIDX:
		case S_IMM:
			xerr('q', "Invalid Addressing Mode");
			break;
		default:
			opcode |= (t1 | v1);
			ea(&e1, &e1xi, t1, p1, x1, 2, opcode, 1);
			break;
		}
		break;

	case S_BIT:	/* bchg, bclr, bset, btst */
		/* xxx Dn,<ea>  or  xxx #,<ea> */
		t1 = addr(&e1, &e1xi, sz, &v1, &p1, &x1);
		comma(1);
		t2 = addr(&e2, &e2xi, sz, &v2, &p2, &x2);

		switch(t2) {
		case S_PCID:
		case S_PCIDX:
			if (op == 0x0100) {	/* btst */
				break;
			}
		case S_An:
		case S_IMM:
			xerr('q', "Invalid Addressing Mode");
			break;
		default:
			break;
		}
		/* suffix is redundant, but some code uses it, validate */
		if (!(mp->m_flag & A_A)) {
			switch(sz) {
			case A_B: /* .b */
				if (t2 == S_Dn)
					xerr('q', "Register Operand Must Be Long");
				break;
			case A_W: /* .w */
				xerr('q', "Invalid Instruction Size");
				break;
			case A_L: /* .l */
				if (t2 != S_Dn)
					xerr('q', "Memory Operand Must Be Byte");
				break;
			default:
				break;
			}
		}
		/* xxx Dn,<ea> */
		if (t1 == S_Dn) {
			opcode |= ((v1 << 9) | t2 | v2);
			ea(&e2, &e2xi, t2, p2, x2, 2, opcode, 1);
		} else
		/* xxx #,<ea> */
		if (t1 == S_IMM) {
			switch(op) {
			case 0x0100:	opcode = 0x0800;	break;	/* btst #,<ea> */
			case 0x0140:	opcode = 0x0840;	break;	/* bchg #,<ea> */
			case 0x0180:	opcode = 0x0880;	break;	/* bclr #,<ea> */
			case 0x01C0:	opcode = 0x08C0;	break;	/* bset #,<ea> */
			}
			opcode |= (t2 | v2);
			outaw(opcode);
			outab(0);
			outrb(&e1, 0);
			ea(&e2, &e2xi, t2, p2, x2, 2, opcode, 0);
		} else {
				xerr('q', "Invalid Addressing Mode");
		}
		break;

	case S_MOVE:	/* MOVE ___,___ */
		/* MOVE (CCR,SR,USP),<ea> */
		if (admode(Sreg)) {
			v1 = aindx;
			comma(1);
			t2 = addr(&e2, &e2xi, sz, &v2, &p2, &x2);

			switch(v1) {
			case S_USP:
				if ((mp->m_flag & ALT_L) == 0) {
					xerr('q', "Only MOVE(.L) Allowed");
				}
				if (t2 == S_An) {
					opcode = 0x4E60 | (1 << 3) | v2;
					outaw(opcode);
				} else {
					xerr('q', "Only MOVE(.L) USP,An Allowed");
				}
				break;
			default:
				switch(t2) {
				case S_An:
				case S_PCID:
				case S_PCIDX:
				case S_IMM:
					xerr('q', "Invalid Destination Addressing Mode");
					break;
				default:
					if ((mp->m_flag & ALT_W) == 0) {
						xerr('q', "Only MOVE(.W) Allowed");
					}
					switch(v1) {
					case S_CCR:	opcode = 0x42C0 | t2 | v2;	break;
					case S_SR:	opcode = 0x40C0 | t2 | v2;	break;
					default:
						xerr('q', "Internal Error");
						break;
					}
					ea(&e2, &e2xi, t2, p2, x2, 2, opcode, 1);
					break;
				}
				break;
			}
			break;
		} else {
			t1 = addr(&e1, &e1xi, sz, &v1, &p1, &x1);
		}
		comma(1);
		/* MOVE <ea>,(CCR,SR,USP) */
		if (admode(Sreg)) {
			v2 = aindx;
			switch(v2) {
			case S_USP:
				if ((mp->m_flag & ALT_L) == 0) {
					xerr('q', "Only MOVE(.L) Allowed");
				}
				if (t1 == S_An) {
					opcode = 0x4E60 | (0 << 3) | v1;
					outaw(opcode);
 			        } else {
					xerr('q', "Only MOVE(.L) An,USP Allowed");
				}
				break;
			default:
				switch(t1) {
				case S_An:
					xerr('q', "Invalid Destination Addressing Mode");
					break;
				default:
					if ((mp->m_flag & ALT_W) == 0) {
						xerr('q', "Only MOVE(.W) Allowed");
					}
					switch(v2) {
					case S_CCR:	opcode = 0x44C0 | t1 | v1;	break;
					case S_SR:	opcode = 0x46C0 | t1 | v1;	break;
					default:
						xerr('q', "Internal Error");
					}
					ea(&e1, &e1xi, t1, p1, x1, 2, opcode, 1);
					break;
				}
				break;
			}
			break;
		} else {
			t2 = addr(&e2, &e2xi, sz, &v2, &p2, &x2);
		}
		/* MOVE <ea>,<ea> */
		switch(t2) {
		case S_An:
			if (sz == A_B) {
				xerr('q', "MOVEA.B Is Not Supported");
			}
			if (alt) {
				/* MOVE <ea>,An ==>> MOVEA <ea>,An */
				/* note: we don't need t2 & 070 in this case */
				opcode |= ((v2 << 9) | (t2 << 3) | t1 | v1);
				ea(&e1, &e1xi, t1, p1, x1, 2, opcode, 1);
				break;
			}
			/* Fall Through */
		case S_PCID:
		case S_PCIDX:
		case S_IMM:
			xerr('q', "Invalid Destination Addressing Mode");
			break;
		default:
			if ((t1 == S_An) && (sz == A_B)) {
				xerr('q', "MOVE.B An,<ea> Is Not Supported");
			}
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
			ea(&e1, &e1xi, t1, p1, x1, 2, opcode, 1);
			ea(&e2, &e2xi, t2, p2, x2, 2, opcode, 0);
			break;
		}
		break;

	case S_MOVEA:	/* MOVEA <ea>,An */
		t1 = addr(&e1, &e1xi, sz, &v1, &p1, &x1);
		comma(1);
		t2 = addr(&e2, &e2xi, sz, &v2, &p2, &x2);

		if (t2 == S_An) {
			if (sz == A_B) {
				xerr('q', "MOVEA.B Is Not Supported");
			}
			opcode |= ((v2 << 9) | t1 | v1);
			ea(&e1, &e1xi, t1, p1, x1, 2, opcode, 1);
		} else {
			xerr('q', "Second Argument Must Be An");
		}
		break;

	case S_MOVEC:	/* MOVEC Rc,Rn  Or  MOVEC Rn,Rc */
		if (mchtyp < M_68010) {
			xerr('q', "MOVEC Valid Only In 68010 And 68020");
		}
		if (sz != A_L) {
			xerr('q', "MOVEC Has Only A Long Form");
		}
		/* MOVEC Rc,Rn */
		if (admode(Creg)) {
			v1 = aindx;
			if ((mchtyp == M_68010) && ((v1 == 0x0002) || (v1 > 0x0801))) {
				xerr('w', "CACR, CAAR, MSP, And ISP Not Supported In 68010");
			}
			comma(1);
			t2 = addr(&e2, &e2xi, sz, &v2, &p2, &x2);

			/* MOVEC Rc,Rn */
			opcode |= 0x0000;
			outaw(opcode);
			switch(t2) {
			case S_Dn:	outaw(0x0000 | (v2 << 12) | v1);	break;
			case S_An:	outaw(0x8000 | (v2 << 12) | v1);	break;
			default:
				xerr('q', "Second Argument Must Be An or Dn");
				break;
			}
		/* MOVEC Rn,Rc */
		} else {
			t1 = addr(&e1, &e1xi, sz, &v1, &p1, &x1);
			comma(1);

			if ((t1 == S_Dn) || (t1 == S_An)) {
				if (admode(Creg)) {
					v2 = aindx;
					if ((mchtyp == M_68010) && ((v2 == 0x0002) || (v2 > 0x0801))) {
						xerr('w', "CACR, CAAR, MSP, And ISP Not Supported In 68010");
					}
					opcode |= 0x0001;
					outaw(opcode);
					switch(t1) {
					case S_Dn:	outaw(0x0000 | (v1 << 12) | v2);	break;
					case S_An:	outaw(0x8000 | (v1 << 12) | v2);	break;
					default:
						xerr('q', "First Argument Must Be An or Dn");
						break;
					}
				} else {
					xerr('q', "Second Argument Must Be A Control Register");
				}
			} else {
				xerr('q', "First Argument Must Be An or Dn");
				break;
			}
		}
		break;

	case S_MOVEM:	/* MOVEM <R List>,<ea>  Or  MOVEM <ea>,<R List> */
		/* MOVEM <R List>,<ea> */
		if (mvlist(&e1, &rc)) {
			comma(1);
			t2 = addr(&e2, &e2xi, sz, &v2, &p2, &x2);

			switch(t2) {
			case S_Dn:
			case S_An:
			case S_AINC:
			case S_PCID:
			case S_PCIDX:
			case S_IMM:
				xerr('q', "Illegal Destination Addressing Mode");
				break;
			default:
				if (sz == A_B) {
					xerr('q', "MOVEM.B Is Not Supported");
				}
				if (t2 == S_ADEC) {
					/* Reverse List Order */
					v1 = 0;
					for (a2=0; a2<=15; a2++) {
						if ((0x8000 >> a2) & e1.e_addr) {
							v1 |= (1 << a2);
						}
					}
					e1.e_addr = (a_uint) v1;
				}
				opcode |= ((0 << 10) | t2 | v2);
				outaw(opcode);
				outrw(&e1, 0);
				ea(&e2, &e2xi, t2, p2, x2, 4, opcode, 0);
				break;
			}
			break;
		}
		t1 = addr(&e1, &e1xi, sz, &v1, &p1, &x1);
		comma(1);

		/* MOVEM <ea>,<R List> */
		if (mvlist(&e2, &rc)) {
			switch(t1) {
			case S_Dn:
			case S_An:
			case S_ADEC:
			case S_IMM:
				xerr('q', "Illegal Source Addressing Mode");
				break;
			default:
				if (sz == A_B) {
					xerr('q', "MOVEM.B Is Not Supported");
				}
				opcode |= ((1 << 10) | t1 | v1);
				outaw(opcode);
				outrw(&e2, 0);
				ea(&e1, &e1xi, t1, p1, x1, 4, opcode, 0);
				break;
			}
			break;
		}
		xerr('q', "MOVEM Addressing Mode Error");
		break;

	case S_MOVEP:	/* MOVEP Dn,d(An)  Or  MOVEP d(An),Dn */
		t1 = addr(&e1, &e1xi, sz, &v1, &p1, &x1);
		comma(1);
		t2 = addr(&e2, &e2xi, sz, &v2, &p2, &x2);

		/* MOVEP Dn,d(An)*/
		if ((t1 == S_Dn) && (t2 == S_ARID)) {
			if (sz == A_B) {
				xerr('q', "MOVEP.B Is Not Supported");
			}
			opcode |= ((v1 << 9) | 0x80 | v2);
			outaw(opcode);
			outrw(&e2, 0);
		} else
		/* MOVEP d(An),Dn */
		if ((t1 == S_ARID) && (t2 == S_Dn)) {
			if (sz == A_B) {
				xerr('q', "MOVEP.B Is Not Supported");
			}
			opcode |= ((v2 << 9) | 0x00 | v1);
			outaw(opcode);
			outrw(&e1, 0);
		} else {
			xerr('q', "Arguments Must Be Dn,d(An) Or d(An),Dn");
		}
		break;

	case S_MOVEQ:	/* MOVEQ #,Dn */
		t1 = addr(&e1, &e1xi, sz, &v1, &p1, &x1);
		comma(1);
		t2 = addr(&e2, &e2xi, sz, &v2, &p2, &x2);

		if ((t1 == S_IMM) && (t2 == S_Dn)) {
			opcode = (op >> 8) | (v2 << 1);
			outab(opcode);
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

	case S_MOVES:	/* MOVES Rn,<ea>  Or  MOVES <ea>,Rn (68010) */
		if (mchtyp < M_68010) {
			xerr('q', "MOVES Valid Only In 68010 And 68020");
		}
		t1 = addr(&e1, &e1xi, sz, &v1, &p1, &x1);
		comma(1);
		t2 = addr(&e2, &e2xi, sz, &v2, &p2, &x2);

		/* MOVES Rn,<ea> */
		if ((t1 == S_Dn) || (t1 == S_An)) {
			switch(t2) {
			case S_Dn:
			case S_An:
			case S_PCID:
			case S_PCIDX:
			case S_IMM:
				xerr('q', "Invalid Addressing Mode");
				break;
			default:
				outaw(opcode |= ((sz << 6) | t2 | v2));
				switch(t1) {
				case S_Dn:	a1 = 0x0800 | (v1 << 12);	aindx = 0;	break;
				case S_An:	a1 = 0x8800 | (v1 << 12);	aindx = 1;	break;
				default:	xerr('q', "MOVES Internal Error");	break;
				}
				outaw(op2 = a1);
				ea(&e2, &e2xi, t2, p2, x2, 2, opcode, 0);
				break;
			}
		} else
		/* MOVES <ea>,Rn */
		if ((t2 == S_Dn) || (t2 == S_An)) {
			switch(t1) {
			case S_Dn:
			case S_An:
			case S_PCID:
			case S_PCIDX:
			case S_IMM:
				xerr('q', "Invalid Addressing Mode");
				break;
			default:
				outaw(opcode |= ((sz << 6) | t1 | v1));
				switch(t2) {
				case S_Dn:	a2 = 0x0000 | (v1 << 12);	aindx = 2;	break;
				case S_An:	a2 = 0x8000 | (v1 << 12);	aindx = 3;	break;
				default:	xerr('q', "MOVES Internal Error");	break;
				}
				outaw(op2 = a2);
				ea(&e1, &e1xi, t1, p1, x1, 2, opcode, 0);
				break;
			}
		} else {
			xerr('q', "MOVES Rn,<ea>  Or  MOVES <ea>,Rn  Only");
		}
		break;

	case S_CHK:	/* CHK */
		/* CHK <ea>,Dn */
		t1 = addr(&e1, &e1xi, sz, &v1, &p1, &x1);
		comma(1);

		if (admode(Dn)) {
			if (t1 == S_An) {
				xerr('q', "First Argument Must Not Be An");
			}
			if ((sz == A_L) && (mchtyp < M_68020)) {
				xerr('w', ".W If Not 68020");
			}
			if (sz == A_B) {
				xerr('w', ".B Is Not Supported");
			}
			opcode |= (aindx << 9) | t1 | v1;
			ea(&e1, &e1xi, t1, p1, x1, 2, opcode, 1);
		} else {
			xerr('q', "Second Argument Must Be Dn");
		}
		break;

	case S_CMP:	/* CMP */
		/* xxx <ea>,Dn */
		t1 = addr(&e1, &e1xi, sz, &v1, &p1, &x1);
		comma(1);
		t2 = addr(&e2, &e2xi, sz, &v2, &p2, &x2);

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
			ea(&e1, &e1xi, t1, p1, x1, 2, opcode, 1);
		} else
		/* CMP #,<ea> */
		if (alt && (t1 == S_IMM)) {
			/* Use CMPI #,<ea> */
			switch(t2) {
			case S_An:
			case S_PCID:
			case S_PCIDX:
			case S_IMM:
				xerr('a', "Invalid Addressing Mode");
				break;
			default:
				op = 0x0C00;
	 			opcode = op | (sz << 6) | t2 | v2;
				im(&e1, opcode, 1);
				ea(&e2, &e2xi, t2, p2, x2, dot.s_addr - pc, opcode, 0);
				break;
			}
		} else
		/* CMP <ea>,Dn */
		if (t2 == S_Dn) {
			if ((sz == A_B) && (t1 == S_An)) {
				xerr('q', "Byte Mode With 'An' As Source Is Not Allowed");
			}
			opcode |= ((v2 << 9) | (sz << 6) | t1 | v1);
			ea(&e1, &e1xi, t1, p1, x1, 2, opcode, 1);
		} else {
			xerr('q', "Second Argument Must Be Dn");
		}
		break;

	case S_CMPM:	/* CMPM */
		/* xxx (An)+,(An+) */
		t1 = addr(&e1, &e1xi, sz, &v1, &p1, &x1);
		comma(1);
		t2 = addr(&e2, &e2xi, sz, &v2, &p2, &x2);

		if ((t1 == S_AINC) && (t2 == S_AINC)) {
			opcode |= ((v2 << 9) | (sz << 6) | v1);
			outaw(opcode);
		} else {
			xerr('a', "Arguments Must Be (An)+,(An)+");
		}
		break;

	case S_EOR:	/* EOR */
		/* xxx Dn,<ea> */
		t1 = addr(&e1, &e1xi, sz, &v1, &p1, &x1);
		comma(1);

		/* EOR #,(CCR,SR) */
		if (alt && (t1 == S_IMM) && admode(Sreg)) {
			/* EORI #,(SR, CCR) */
			if (aindx == S_CCR) {
				op = 0x0A3C;
				if (mp->m_flag & A_A) {
					sz = A_B;
				}
				if (sz != A_B) {
					xerr('q', "#,CCR Is Of Byte Size");
				}
				opcode = op;
				outaw(opcode);
				outab(0);
				outrb(&e1, 0);
			} else
			if (aindx == S_SR) {
				op = 0x0A7C;
				if (mp->m_flag & A_A) {
					sz = A_W;
				}
				if (sz != A_W) {
					xerr('a', "#,SR Is Of Word Size");
				}
				opcode = op;
				outaw(opcode);
				outrw(&e1, 0);
			} else {
				xerr('q', "Only AND/EOR/OR With #,CCR Or #,SR Allowed");
			}
			break;
		}
		t2 = addr(&e2, &e2xi, sz, &v2, &p2, &x2);

		/* EORI #,<ea> */
		if (alt && (t1 == S_IMM)) {
			switch(t2) {
			case S_An:
			case S_PCID:
			case S_PCIDX:
			case S_IMM:
				xerr('a', "Invalid Addressing Mode");
				break;
			default:
				op = 0x0A00;
				opcode = op | (sz << 6) | t2 | v2;
				im(&e1, opcode, 1);
				ea(&e2, &e2xi, t2, p2, x2, dot.s_addr - pc, opcode, 0);
				break;
			}
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
				opcode = (op & ~0xFF) | (v1 << 9) | ((sz | 4) << 6) | t2 | v2;
				ea(&e2, &e2xi, t2, p2, x2, 2, opcode, 1);
				break;
			}
		} else {
			xerr('a', " First Argument Must Be Dn");
		}
		break;

	case S_EXG:	/* EXG Rx,Ry */
		t1 = addr(&e1, &e1xi, sz, &v1, &p1, &x1);
		comma(1);
		t2 = addr(&e2, &e2xi, sz, &v2, &p2, &x2);

		/* EXG Dn,Dn */
		if ((t1 == S_Dn) && (t2 == S_Dn)) {
			opcode |= ((v1 << 9) | (0x08 << 3) | v2);
		} else
		/* EXG An,An */
		if ((t1 == S_An) && (t2 == S_An)) {
			opcode |= ((v1 << 9) | (0x09 << 3) | v2);
		} else
		/* EXG Dn,An */
		if ((t1 == S_Dn) && (t2 == S_An)) {
			opcode |= ((v1 << 9) | (0x11 << 3) | v2);
		} else
		/* EXG An,Dn */
		if ((t1 == S_An) && (t2 == S_Dn)) {
			opcode |= ((v2 << 9) | (0x11 << 3) | v1);
		} else {
			xerr('a', "Only Address(An) And Data(Dn) Registers Are Allowed");
		}
		if (opcode != op) {
			outaw(opcode);
		}
		break;

	case S_EXT:	/* EXT Dn */
		t1 = addr(&e1, &e1xi, sz, &v1, &p1, &x1);

		if (t1 == S_Dn) {
			switch(sz) {
			case A_B:	/* .b */
				xerr('q', "Use .w For Sign Extending Byte To Word");
				break;
			case A_W: /* .w */
				opcode |= ((0x02 << 6) | v1);
				break;
			case A_L: /* .l */
				opcode |= ((0x03 << 6) | v1);
				break;
			}
			outaw(opcode);
		} else {
			xerr('q', "Argument Must Be Dn");
			break;
		}
		break;

	case S_LINK:	/* LINK */
		t1 = addr(&e1, &e1xi, sz, &v1, &p1, &x1);
		comma(1);
		t2 = addr(&e2, &e2xi, sz, &v2, &p2, &x2);

		if ((t1 == S_An) && (t2 == S_IMM)) {
			opcode |= v1;
			if (mp->m_flag & A_A) {
				if (mchtyp < M_68020) {
					outaw(opcode);
					outrw(&e2, R_SGND);
				} else
				if (is_abs(&e2)) {
					if (pass == 0) {
						dot.s_addr += 6;
					} else
					if (pass == 1) {
						dot.s_addr += 2;
						setwl(e2.e_addr);
					} else
					if (getbit()) {
						outaw(opcode);
						outaw(e2.e_addr);
					} else {
						opcode = 0x4808 | v1;
						outaw(opcode);
						outa4b(e2.e_addr);
					}
				} else {
					opcode = 0x4808 | v1;
					outaw(opcode);
					outr4b(&e2, 0);	
				}
			} else
			if (sz == A_W) {
				outaw(opcode);
				outrw(&e2, R_SGND);
			} else {
				if (mchtyp < M_68020) {
					xerr('w', ".L Form Requires 68020");
				}
				outaw(opcode);
				outr4b(&e2, 0);
			}
		} else {
			xerr('q', "An,# Is Required Argument");
		}
		break;

	case S_STOP:	/* STOP / RTD */
		t1 = addr(&e1, &e1xi, sz, &v1, &p1, &x1);

		if (t1 == S_IMM) {
			outaw(op);
			outrw(&e1, 0);
		} else {
			xerr('q', "Argument Must Be A #");
		}
		break;

	case S_SWAP:	/* SWAP */
		if (admode(Dn)) {
			opcode |= aindx;
			outaw(opcode);
		} else {
			xerr('q', "Argument Must Be Dn");
		}
		break;

	case S_TRAP:	/* TRAP */
		t1 = addr(&e1, &e1xi, sz, &v1, &p1, &x1);

		if (t1 == S_IMM) {
			if (is_abs(&e1)) {
				if (e1.e_addr & ~0x0F) {
					xerr('q', "Vector Must Be In The Range 0 - 15");
				}
				opcode |= e1.e_addr;
				outaw(opcode);
			} else {
				outrwm(&e1, R_4BITS, op);
			}
		} else {
			xerr('q', "Argument Must Be A #");
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

	case S_INH:
		outaw(opcode);
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

	case S_FLT96:
		opcycles = OPCY_FLT96;
		do {
			/*
			 * See 68882 datasheet page 9:
			 *   https://www.nxp.com/docs/en/data-sheet/BR509.pdf
			 * The extended-precision format has 16 bits padding.
			 */
			atoext();
			outaw(rslt[4]);
			outaw(0);
			outaw(rslt[3]);
			outaw(rslt[2]);
			outaw(rslt[1]);
			outaw(rslt[0]);
		} while (comma(0));
		break;

	case S_FLTPK:
		opcycles = OPCY_FLTPK;
		do {
			fltpk();
		} while (comma(0));
		break;

	case S_QWRD:
		opcycles = OPCY_QWRD;
		do {
			atoint();
			outaw(rslt[3]);
			outaw(rslt[2]);
			outaw(rslt[1]);
			outaw(rslt[0]);
		} while (comma(0));
		break;

 	case S_M68K:
		t1 = addr(&e1, &e1xi, sz, &v1, &p1, &x1);
		outab(t1 >> 3);
		outab(v1);
		ea(&e1, &e1xi, t1, p1, x1, 2, opcode, 0);
		break;

	/*
	 * 68020 Instructions
	 */
	case S_BF:	/* BF... <ea> {X:X} */
		if (op  == 0xEFC0) {
			/* BFINS */
			if (admode(Dn) && comma(0)) {
				a1 = aindx << 12;
			} else {
				xerr('q', "First Argument Must Be Dn");
			}
		}
		t1 = addr(&e1, &e1xi, sz, &v1, &p1, &x1);
		switch(t1) {
		case S_PCID:
		case S_PCIDX:
			if (op == 0xEBC0) break;	/* BFEXTS */
			if (op == 0xE9C0) break;	/* BFEXTU */
			if (op == 0xEDC0) break;	/* BFFFO */
			if (op == 0xE8C0) break;	/* BFTST */
		case S_An:
		case S_AINC:
		case S_ADEC:
		case S_IMM:
			xerr('a', "Invalid Addressing Mode");
			break;
		default:
			break;
		}
		comma(1);
		if ((c = getnb()) == '{') {
			if (admode(Dn)) {
				a1 |= 0x0800 | (aindx << 6);
			} else {
				expr(&e2, 0);
				a1 |= (int) ((e2.e_addr & 0x001F) << 6);
				if (!is_abs(&e2)) {
					xerr('a', "Absolute Offset Required");
				} else {
					if (e2.e_addr > 31) {
						xerr('a', "Offset Not 0-31:1-32");
					}
				}
				clrexpr(&e2);
			}
			if (getnb() != ':') {
				xerr('q', "Missing ':' Separator");
			}
			if (admode(Dn)) {
				a1 |= 0x0020 | aindx;
			} else {
				expr(&e2, 0);
				a1 |= (int) (e2.e_addr & 0x001F);
				if (!is_abs(&e2)) {
					xerr('a', "Absolute Width Required");
				} else {
					if ((e2.e_addr < 1) || (e2.e_addr > 32)) {
						xerr('a', "Offset Not 0-31:1-32");
					}
				}
			}
			if (getnb() != '}') {
				xerr('q', "Missing '}' Terminator");
			}
			if ((op == 0xEBC0) || (op == 0xE9C0) || (op == 0xEDC0)) {
				/* BFEXTS, BFEXTU, And BFFFO */
				if (comma(0) && admode(Dn)) {
					a1 |= aindx << 12;
				} else {
					xerr('q', "The Last Argument Must Be Dn");
				}
			}
			outaw(opcode |= t1 | v1);
			outaw(a1);
			ea(&e1, &e1xi, t1, p1, x1, 4, opcode, 0);
		} else {
			unget(c);
			xerr('q', "Missing {offset:width}");
		}
		break;

	case S_BKPT:
		t1 = addr(&e1, &e1xi, sz, &v1, &p1, &x1);
		if (t1 == S_IMM) {
			if (is_abs(&e1) && (e1.e_addr & ~0x07)) {
				xerr('a', "Vector Value Must Be 0-7");
			}
			outrwm(&e1, R_3BITS, op);
		} else {
			xerr('q', "Argument Must Be A # 0-7");
		}
		break;

	case S_CALLM:
		expr(&e1, 0);
		comma(1);
		t2 = addr(&e2, &e2xi, sz, &v2, &p2, &x2);
		switch(t2) {
		case S_Dn:
		case S_An:
		case S_AINC:
		case S_ADEC:
		case S_IMM:
			xerr('a', "Invalid Addressing Mode");
			break;
		default:
			break;
		}
		outaw(opcode |= t2 | v2);
		outab(0);
		outrb(&e1, R_OVRF);
		ea(&e2, &e2xi, t2, p2, x2, 2, opcode, 0);
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
		t1 = addr(&e1, &e1xi, sz, &v1, &p1, &x1);
		switch(t1) {
		case S_Dn:
		case S_An:
		case S_PCID:
		case S_PCIDX:
		case S_IMM:
			xerr('a', "Invalid Addressing Mode");
			break;
		default:
			break;
		}
		outaw(opcode |= ((sz + 1) << 9) | t1 | v1);
		outaw(a1);
		ea(&e1, &e1xi, t1, p1, x1, 4, opcode, 0);
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
		if (sz == A_B) {
			xerr('a', "Byte Mode Not Allowed");
			sz = 1;
		}
		outaw(opcode |= ((sz + 1) << 9));
		outaw(a1);
		outaw(a2);
		break;

	case S_CHK2:
	case S_CMP2:
		t1 = addr(&e1, &e1xi, sz, &v1, &p1, &x1);
		switch(t1) {
		case S_Dn:
		case S_An:
		case S_AINC:
		case S_ADEC:
		case S_IMM:
			xerr('a', "Invalid Addressing Mode");
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
			xerr('q', "Second Argument MustBe Dn Or An");
		}
		if (rf == S_CHK2) {
			a1 |= 0x0800;
		}
		outaw(opcode |= (sz << 9) | t1 | v1);
		outaw(a1);
		ea(&e1, &e1xi, t1, p1, x1, 4, opcode, 0);
		break;

	case S_EXTB:	/* EXTB Dn */
		t1 = addr(&e1, &e1xi, sz, &v1, &p1, &x1);

		if (t1 == S_Dn) {
			switch(sz) {
			case A_B: /* .b */
				xerr('w', "Using EXT.W For Sign Extending Byte To Word");
				op = opcode = 0x4880;
				break;
			case A_W: /* .w */
				xerr('w', "Using EXT.L For Sign Extending Word To Long");
				op = opcode = 0x48C0;
				break;
			case A_L: /* .l */
				opcode |= ((0x07 << 6) | v1);
				break;
			}
			outaw(opcode);
		} else {
			xerr('q', "Argument Must Be Dn");
			break;
		}
		break;

	case S_PKUK:
		if (admode(Dn) & comma(0)) {		/* Dx, */
			a1 = aindx;
			if (admode(Dn) && comma(0)) {	/* Dy, */
				a1 |= (aindx << 9);
			} else {
				qerr();
			}
		} else
		if ((getnb() == '-') && (getnb() == '(') && admode(An) &&
		    (getnb() == ')') && comma(0)) {		/* -(Ax), */
		    	a1 = aindx | 0x0008;
			if ((getnb() == '-') && (getnb() == '(') && admode(An) &&
			    (getnb() == ')') && comma(0)) {	/* -(Ay), */
			    	a1 |= (aindx << 9);
			} else {
				qerr();
			}
		} else {
			qerr();
		}
		expr(&e1, 0);	/* #<adjustment> */
		outaw(opcode |= a1);
		outrw(&e1, 0);
		break;

	case S_RTM:	/* RTM Rn */
		if (admode(An)) {
			opcode |= 0x0008 | aindx;
		} else
		if (admode(Dn)) {
			opcode |= 0x0000 | aindx;
		} else {
			xerr('q', "Argument Must Be An Or Dn");
		}
		outaw(opcode);
		break;

	case S_TRPC:
		if (mp->m_flag & A_A) {
			if (more()) {
				if (getnb() == '#') {
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
					xerr('q', "Argument Must Be A #");
				}
			} else {
				outaw(opcode |= 4);
			}
		} else {
			if (getnb() == '#') {
				expr(&e1, 0);
				if (sz == A_W) {
					outaw(opcode |= 2);
					outrw(&e1, 0);
				} else {
					outaw(opcode |= 3);
					outr4b(&e1, 0);
				}
			} else {
				xerr('q', "Argument Must Be A #");
			}
		}
		break;

	/*
	 * The MC68881 / MC68882 Floating Point Co-Processor
	 *
	 * Note:
	 *	opcode is recoded for mchcycles()
	 */

	case F_TYP1:	/* FABS <ea>,FPn  /  FPm,FPn  /  Fpn */
	case F_TYP2:	/* FADD <ea>,Fpn  /  FPm,FPn */
		t1 = faddr(&e1, fsz, &v1);
		if (t1 == S_FPn) {	/* FPm,FPn  Or  FPn */
			if (fsz != F_X) {
				xerr('w', "Fpn Or Fpm,Fpn Are By Default Extended Precision");
			}
			if (more() && comma(1)) {
				t2 = faddr(&e2, fsz, &v2);
				if (t2 != S_FPn) {
					xerr('a', "Argument Following FPm Must Be FPn");
					v2 = v1;
 				}
			} else {
				if (mp->m_type == F_TYP2) {
					xerr('a', "Syntax Requires FPm,Fpn");
				}
				v2 = v1;
			}
			outaw(opcode = 0xF000 | coid);
			outaw(op2 = (v1 << 10) | (v2 << 7) | op);
			break;
		} else
		if (t1 == S_FIMM) {	/* #,FPn */
			comma(1);
			t2 = faddr(&e2, fsz, &v2);
			if (t2 != S_FPn) {
				xerr('a', "Second Argument Must Be FPn");
				v2 = 0;
			}
			outaw(opcode = 0xF000 | coid | 074);
			outaw(op2 = 0x4000 | (fsz << 10) | (v2 << 7) | op);
			fimm(&e1, fsz);
			break;
		}
		t1 = addr(&e1, &e1xi, sz, &v1, &p1, &x1);
		comma(1);

		if (admode(FPn)) {	/* <ea>,FPn */
			if (t1 == S_An) {
				xerr('a', "An Is An Illegal First Argument");
			}
			if ((t1 == S_Dn) && ((fsz == F_X) || (fsz == F_P) || (fsz == F_D))) {
				xerr('a', "Dn Valid Only With .B, .W, .L, And .S");
			}
			outaw(opcode = 0xF000 | coid | t1 | v1);
			outaw(op2 = 0x4000 | (fsz << 10) | (aindx << 7) | op);
			ea(&e1, &e1xi, t1, p1, x1, 4, opcode, 0);
		} else {
			xerr('a', "Second Argument Must Be FPn");
		}
		break;

	case F_TST:	/* FTST <ea>  /  FPn */
		t1 = faddr(&e1, fsz, &v1);
		if (t1 == S_FPn) {	/* FPn */
			if (fsz != F_X) {
				xerr('w', "Fpn Is Extended Precision");
			}
			outaw(opcode = 0xF000 | coid);
			outaw(op2 = (v1 << 10) | op);
			break;
		} else
		if (t1 == S_FIMM) {	/* # */
			outaw(opcode = 0xF000 | coid | 074);
			outaw(op2 = 0x4000 | (fsz << 10) | op);
			fimm(&e1, fsz);
			break;
		}
		t1 = addr(&e1, &e1xi, sz, &v1, &p1, &x1);
		if (t1 == S_An) {
			xerr('a', "An Is An Illegal First Argument");
		}
		if ((t1 == S_Dn) && ((fsz == F_X) || (fsz == F_P) || (fsz == F_D))) {
			xerr('a', "Only Byte, Word, Long, Or Single Allowed");
		}
		outaw(opcode = 0xF000 | coid | t1 | v1);
		outaw(op2 = 0x4000 | (fsz << 10) | op);
		ea(&e1, &e1xi, t1, p1, x1, 4, opcode, 0);
		break;

	case F_SNCS:
		t1 = faddr(&e1, fsz, &v1);
		if (t1) {	/* FPn,FPc:FPs / #,FPc:FPs */
			if ((t1 == S_FPn) && (fsz != F_X)) {	/* FPn,FPc:FPs */
				xerr('a', "FSINCOS.X Required For FPn,FPc:FPs");
			}
			comma(1);
			if (admode(FPn)) {
				v2 = aindx;
				if ((getnb() != ':') || !admode(FPn)) {
					xerr('a', "Missing :FPs Of FPn,FPc:FPs");
				}
				v2 |= (aindx << 7);
			} else {
				v2 = 0;
				xerr('a', " Missing FPc:FPs Of FPn,FPc:FPs");
			}
			if (t1 == S_FPn) {	/* FPn,FPc:FPs */
				outaw(opcode = 0xF000 | coid);
				outaw(op2 = 0x0000 | op | (v1 << 10) |  v2);
				break;
			}
			if (t1 == S_FIMM) {	/* #,FPc:FPs */
				outaw(opcode = 0xF000 | coid | 074);
				outaw(op2 = 0x4000 | op | (fsz << 10) | v2);
				fimm(&e1, fsz);
				break;
			}
			xerr('q', "Internal FSINCOS Error");
			break;
		}			
		/* <ea>,FPc:FPs */
		t1 = addr(&e1, &e1xi, sz, &v1, &p1, &x1);
		if ((t1 == S_Dn) &&
		   !((fsz == F_B) || (fsz == F_W) || (fsz == F_L) || (fsz == F_S))) {
        		xerr('a', "Only .B, .W, .L, Or .S Allowed With Dn,FPn");
		}
		if (t1 == S_An) {
			xerr('a', "An Is An Illegal First Argument");
		}
		comma(1);
		if (admode(FPn)) {
			v2 = aindx;
			if ((getnb() != ':') || !admode(FPn)) {
				xerr('a', "Missing :FPs Of FPn,FPc:FPs");
			}
			v2 |= (aindx << 7);
		} else {
			v2 = 0;
			xerr('a', " Missing FPc:FPs Of FPn,FPc:FPs");
		}
		outaw(opcode = 0xF000 | coid | t1 | v1);
		outaw(op2 = 0x4000 | op | (fsz << 10) | v2);
		ea(&e1, &e1xi, t1, p1, x1, 4, opcode, 0);
		break;

	case F_MOV:
		if (fsz == F_A) {	/* FMOVE.L Or FMOVE.X */
			p = ip;
			if (admode(FCR)) {
				fsz = F_L;
			} else {
				while(more()) { getnb(); }
				q = ip;
				c = *ip;
				*ip = 0;
				if ((ip = strrchr(p, ',')) != NULL) {
					comma(1);
					fsz = admode(FCR) ? F_L : F_X;
				} else {
					fsz = F_X;
				}
				*q = c;
			}
			ip = p;
		}
		if (admode(FCR)) {	/* FPcr,<ea> */
			v1 = aindx;
			if (fsz != F_L) {
				xerr('a', "FMOVE.L Required With FPcr,<ea>");
			}
			comma(1);
			t2 = addr(&e2, &e2xi, sz, &v2, &p2, &x2);

			if ((t2 == S_An) && (v1 != 1)) {
				xerr('a', "Only FMOVE.L FPIAR,An Allowed");
			}
			if ((t2 == S_IMM) || (t2 == S_PCID) || (t2 == S_PCIDX)) {
				xerr('a', "Unsupported Addressing Mode");
			}
			outaw(opcode = 0xF000 | coid | t2 | v2);
			outaw(op2 = 0xA000 | (v1 << 10));
			ea(&e2, &e2xi, t2, p2, x2, 4, opcode, 0);
			break;
		}
		t1 = faddr(&e1, fsz, &v1);
		if (t1 == S_FPn) {	/* FPn,<ea> optional {Dn} or {#k} */
			comma(1);
			t2 = addr(&e2, &e2xi, sz, &v2, &p2, &x2);

			if ((t2 == S_Dn) && ((fsz == F_X) || (fsz == F_P))) {
	        		xerr('a', "Only .B, .W, .L, Or .S Allowed With FPn,Dn");
			}
			if ((t2 == S_An) || (t2 == S_IMM) || (t2 == S_PCID) || (t2 == S_PCIDX)) {
				xerr('a', "Unsupported Addressing Mode");
			}
			outaw(opcode = 0xF000 | coid | t2 | v2);
			if ((c = getnb()) == '{') {
				if (fsz != F_P) {
					xerr('a', "FMOVE.P Required For FPn,<ea>{Dn Or #k}");
				}
				if (admode(Dn)) {
					outaw(op2 = 0x6000 | (7 << 10) | (v1 << 7) | (aindx << 4));
				} else {
					expr(&e1, 0);
					outrwm(&e1, R_CRBTS | R_MBRO, op2 = 0x6000 | (3 << 10) | (v1 << 7));
				}
				if (getnb() != '}') {
					xerr('q', "Missing '}'");
				}
			} else {
				unget(c);
				outaw(op2 = 0x6000 | (fsz << 10) | (v1 << 7));
			}
			ea(&e2, &e2xi, t2, p2, x2, 4, opcode, 0);
			break;
		} else
		if (t1 == S_FIMM) {
			comma(1);
			if (admode(FCR)) {	/* #,FCR */
				v1 = aindx;
				if (fsz != F_L) {
	        			xerr('a', "Only .L Allowed With #,FCR");
				}
				outaw(opcode = 0xF000 | coid | 074);
				outaw(op2 = 0x8000 | (v1 << 10));
				fimm(&e1, fsz);
				break;
			}
			if (admode(FPn)) {	/* #,FPn */
				v1 = aindx;
				if ((fsz == F_D) || (fsz == F_X) || (fsz == F_P)) {
        				xerr('a', "Only .B, .W, .L, Or .S Allowed With #,FPn");
				}
				outaw(opcode = 0xF000 | coid | 074);
				outaw(op2 = 0x4000 | (fsz << 10) | (v1 << 7));
				fimm(&e1, fsz);
				break;
			}
			qerr();
		}
		/* FMOVE <ea>,FPn Or <ea>,FPcr */
		t1 = addr(&e1, &e1xi, sz, &v1, &p1, &x1);
		if ((t1 == S_Dn) && ((fsz == F_D) || (fsz == F_X) || (fsz == F_P))) {
        		xerr('a', "Only .B, .W, .L, Or .S Allowed With Dn");
		}
		if (t1 == S_An) {
			xerr('a', "An Is An Illegal First Argument");
		}
		comma(1);
		outaw(opcode = 0xF000 | coid | t1 | v1);
		if (admode(FCR)) {	/* FMOVE <ea>,FPcr */
			v2 = aindx;
			if (fsz != F_L) {
				xerr('a', "FMOVE.L Required With <ea>,FPcr");
			}
			if ((t1 == S_An) && (v2 != 1)) {
				xerr('a', "Only FMOVE.L An,FPIAR Allowed");
			}
			outaw(op2 = 0x8000 | (v2 << 10));
		} else {	
			if (admode(FPn)) {	/* FMOVE <ea>,FPn */
				v2 = aindx;
			} else {
				v2 = 0;
				xerr('a', "Second Argument Must Be FPn Or FPcr");
			}
			outaw(op2 = 0x4000 | (fsz << 10) | (v2 << 7));
		}
		ea(&e1, &e1xi, t1, p1, x1, 4, opcode, 0);
		break;

	case F_MVCR:	/* FMOVECR.X  #ccc,FPn */
		t1 = addr(&e1, &e1xi, A_U, &v1, &p1, &x1);
		comma(1);
		t2 = faddr(&e2, fsz, &v2);
		outaw(opcode = 0xF000 | coid);
		outrwm(&e1, R_CRBTS | R_MBRO, op2 = 0x5C00 | (v2 << 7));
		if ((t1 != S_IMM) || (t2 != S_FPn)) {
			xerr('a', "#,Fpn Is Correct Form");
		}
		break;

	case F_MOVM:	/* FMOVEM */
		if (fsz == F_A) {	/* FMOVEM.L Or FMOVEM.X */
			p = ip;
			if (admode(FCR)) {
				fsz = F_L;
			} else
			if (fmvlist(&rc)) {
				fsz = F_X;
				rc = 0;
			} else {
				while(more()) { getnb(); }
				q = ip;
				c = *ip;
				*ip = 0;
				if ((ip = strrchr(p, ',')) != NULL) {
					comma(1);
					fsz = admode(FCR) ? F_L : F_X;
				} else {
					fsz = F_X;
				}
				*q = c;
			}
			ip = p;
		}
		switch(fsz) {
		case F_X:	/* FMOVEM  <list>,<ea> / Dn,<ea> / <ea>,<list> / <ea>,Dn */
			p = ip;
			if (admode(Dn) || admode(FPn)) {
				ip = p;
				if (admode(Dn)) {	/* FMOVEM Dn,<ea> */
					v1 = aindx;
					op2 = 0xE800;	/* Dynamic */
				} else {		/* FMOVEM <list>,<ea> */
					v1 = fmvlist(&rc);
					op2 = 0xE000;	/* Static */
				}
				comma(1);
				t2 = addr(&e2, &e2xi, A_L, &v2, &p2, &x2);

				switch(t2) {
				case S_Dn:
				case S_An:
				case S_AINC:
				case S_IMM:
				case S_PCID:
				case S_PCIDX:
					xerr('a', "Unsupported Addressing Mode");
				default:
					if (t2 == S_ADEC) {
						/* Reverse List Order */
						a1 = v1;
						v1 = 0;
						for (a2=0; a2<=7; a2++) {
							if ((0x0080 >> a2) & a1) {
								v1 |= (1 << a2);
							}
						}
					}
					outaw(opcode = 0xF000 | coid | t2 | v2);
					outaw(op2 |= (t2 != S_ADEC ? 0x1000 : 0x0000) | v1);
					ea(&e2, &e2xi, t2, p2, x2, 4, opcode, 0);
 			        	break;
				}
				break;
			}
			t1 = addr(&e1, &e1xi, A_L, &v1, &p1, &x1);
			comma(1);

			p = ip;
			if (admode(Dn) || admode(FPn)) {
				ip = p;
				if (admode(Dn)) {	/* FMOVEM <ea>,Dn */
					v2 = aindx;
					op2 = 0xC800;	/* Dynamic */
				} else {		/* FMOVEM <ea>,<list> */
					v2 = fmvlist(&rc);
					op2 = 0xC000;	/* Static */
				}
				switch(t1) {
				case S_Dn:
				case S_An:
				case S_ADEC:
				case S_IMM:
					xerr('a', "Unsupported Addressing Mode");
				default:
					outaw(opcode = 0xF000 | coid | t1 | v1);
					outaw(op2 |= 0x1000 | v2);
					ea(&e2, &e2xi, t2, p2, x2, 4, opcode, 0);
 			        	break;
				}
				break;
			}
			qerr();
			break;

		case F_L:
			p = ip;
			if (admode(FCR)) {	/* FCR,<ea> */
				ip = p;
				v1 = fcrlist(&rc);
				comma(1);
				t2 = addr(&e2, &e2xi, A_L, &v2, &p2, &x2);

				if ((t2 == S_Dn) && (rc != 1)) {
 			        	xerr('a', "Only One FPcr May Be Selected");
				} else
				if ((t2 == S_An) && (v1 != 1)) {
					xerr('a', "Only FPIAR Allowed With An");
				} else
				if ((t2 == S_IMM) || (t2 == S_PCID) || (t2 == S_PCIDX)) {
					xerr('a', "An Illegal Destination Mode");
				}
				outaw(opcode = 0xF000 | coid | t2 | v2);
				outaw(op2 = 0xA000 | (v1 << 10));
				ea(&e2, &e2xi, t2, p2, x2, 4, opcode, 0);
				break;
			}
			t1 = addr(&e1, &e1xi, A_L, &v1, &p1, &x1);
			comma(1);
			p = ip;
			if (admode(FCR)) {	/* <ea>,FCR */
				ip = p;
				v2 = fcrlist(&rc);
				if (((t1 == S_Dn) || (t1 == S_IMM)) && (rc != 1)) {
				        	xerr('a', "Only One FPcr May Be Selected");
				} else
				if ((t1 == S_An) && (v2 != 1)) {
					xerr('a', "Only FPIAR Allowed With An");
				}
				outaw(opcode = 0xF000 | coid | t1 | v1);
				outaw(op2 = 0x8000 | (v2 << 10));
				ea(&e1, &e1xi, t1, p1, x1, 4, opcode, 0);
				break;
			}
			qerr();
			break;

		default:
			xerr('q', "FMOVEM Internal Error");
			break;
		}
		break;

	case F_SCC:	/* FScc <ea> */
		t1 = addr(&e1, &e1xi, sz, &v1, &p1, &x1);

		switch(t1) {
		case S_An:
		case S_PCID:
		case S_PCIDX:
		case S_IMM:
			xerr('q', "Invalid Addressing Mode");
			break;
		default:
			outaw(opcode = 0xF040 | coid | t1 | v1);
			outaw(op2 = op);
			ea(&e1, &e1xi, t1, p1, x1, 4, opcode, 0);
			break;
		}
		break;

	case F_DCC:	/* FDBcc Dn,Label */
		t1 = addr(&e1, &e1xi, sz, &v1, &p1, &x1);
		comma(1);

		expr(&e2, 0);
		dsplcmnt = (INT32) (e2.e_addr - (pc + 4));
		if (mchpcr(&e2)) {
			chkwrng(dsplcmnt, "Branching Range Exceeded");
			outaw(opcode = 0xF048 | coid | t1 | v1);
			outaw(op2 = op);
			outaw(dsplcmnt);
		} else {
			outaw(opcode = 0xF048 | coid | v1);
			outaw(op2 = op);
			e2.e_addr += dot.s_addr - (pc + 4) + 2;
			outrw(&e2, R_PCR);
		}
		if (t1 != S_Dn) {
			xerr('q', "First Argument Must Be Dn");
		}
		if (e2.e_mode != S_USER)
			rerr();
		break;

	case F_TCC:	/* FTRAPcc Label */
		if (fsz == F_A) {
			if (more()) {
				if (getnb() == '#') {
					expr(&e1, 0);
					if (pass == 0) {
						dot.s_addr += 8;
					} else
					if (pass == 1) {
						dot.s_addr += 4;
						if (is_abs(&e1)) {
							setwl(e1.e_addr);
						} else {
							dot.s_addr += 4;
						}
					} else
					if (is_abs(&e1)) {
						if (getbit()) {
							outaw(opcode = 0xF07A | coid);
							outaw(op2 = op);
							outaw(e1.e_addr);
						} else {
							outaw(opcode = 0xF07B | coid);
							outaw(op2 = op);
							outa4b(e1.e_addr);
						}
					} else {
						outaw(opcode = 0xF07B | coid);
						outaw(op2 = op);
						outr4b(&e1, 0);
					}
				} else {
					xerr('q', "Argument Must Be A #");
				}
			} else {
				outaw(opcode = 0xF07C | coid);
				outaw(op2 = op);
			}
		} else {
			if ((c = getnb()) == '#') {
				expr(&e1, 0);
				if (fsz == F_W) {
					outaw(opcode = 0xF07A | coid);
					outaw(op2 = op);
					outrw(&e1, 0);
				} else {
					outaw(opcode = 0xF07B | coid);
					outaw(op2 = op);
					outr4b(&e1, 0);
				}
			} else {
				xerr('q', "Argument Must Be A #");
			}
		}
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
		t1 = addr(&e1, &e1xi, sz, &v1, &p1, &x1);

		switch(op) {
		case 0xF100:	/* FSAVE */
			switch(t1) {
			case S_Dn:
			case S_An:
			case S_AINC:
			case S_PCID:
			case S_PCIDX:
				xerr('a', "Invalid Addressing Mode");
				break;
			default:
				break;
			}
			break;
		case 0xF140:	/* FRESTORE */
			switch(t1) {
			case S_Dn:
			case S_An:
			case S_ADEC:
				xerr('a', "Invalid Addressing Mode");
				break;
			default:
				break;
			}
			break;
		default:
			break;
		}
		outaw(opcode = op | coid | t1 | v1);
		ea(&e1, &e1xi, t1, p1, x1, 2, opcode, 0);
		break;

	default:
		opcycles = OPCY_ERR;
		xerr('o', "Internal Opcode Error");
		break;
	}

	if (opcycles == CYCL_NONE) {
		opcycles = mchcycles(mp, opcode, op2, x1, x2, rc, cycles);
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
ea(e1, e1xi, t1, p1, x1, pcofst, opcode, opflg)
struct expr *e1, *e1xi;
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
		if (mchtyp < M_68020) {
			outrw(e1, R_SGND);
		} else
		if (pass == 0) {
			dot.s_addr += 6;
		} else
		if (pass == 1) {
			if (e1->e_addr >= dot.s_addr) {
				e1->e_addr -= fuzz;
			}
			if (is_abs(e1)) {
				if (((x1 & BD_LONG) == BD_NULL) || ((x1 & BD_LONG) == BD_WORD)) {
					setbit(1);
					dot.s_addr += 2;	/* Word == 2 */
				} else
				if ((x1 & BD_LONG) == BD_LONG) {
					setbit(0);
					dot.s_addr += 6;	/* Long == 6 */
				} else {
					v1 = (INT32) e1->e_addr;
					if (setwl(v1) == 4) {	/* Word == 2 */
						dot.s_addr += 2;/* Long == 6 */
					}
				}
			} else
			if (((x1 & BD_LONG) == BD_NULL) || ((x1 & BD_LONG) == BD_WORD)) {
				dot.s_addr += 2;	/* Word External */
			} else {
				dot.s_addr += 6;	/* Long  External */
			}
		} else {
			if (is_abs(e1)) {
				if (getbit()) {
					outrw(e1, R_SGND);	/* Word */
				} else {
					opcode &= ~S_ARID;
					opcode |=  S_ARIDX;
					outaw(x1 | 0x0170);
					outa4b(e1->e_addr);	/* Long */
				}
			} else
			if (((x1 & BD_LONG) == BD_WORD) || ((x1 & BD_LONG) == BD_NULL)) {
				outrw(e1, R_SGND);	/* Word External */
			} else {
				opcode &= ~S_ARID;
				opcode |=  S_ARIDX;
				outaw(x1 | 0x0170);
				outr4b(e1, 0);		/* Long External */
			}
		}
		break;
	case S_ARIDX:
		if (!(x1 & FF_FLAG)) {	/* d(An,Xn) or (d,An,Xn) */
			if (mchtyp < M_68020) {
				outab(x1 >> 8);
				outrb(e1, R_SGND);
			} else
			if (pass == 0) {
				dot.s_addr += 6;
			} else
			if (pass == 1) {
				if (e1->e_addr >= dot.s_addr) {
					e1->e_addr -= fuzz;
				}
				if ((x1 & BD_LONG) == BD_NULL) {
					setbit(1);
					dot.s_addr += 2;	/* Byte == 2 */
				} else
				if ((x1 & BD_LONG) == BD_WORD) {
					setbit(0);	setbit(1);
					dot.s_addr += 4;	/* Word == 4 */
				} else
				if ((x1 & BD_LONG) == BD_LONG) {
					setbit(0);	setbit(0);
					dot.s_addr += 6;	/* Long == 6 */
				} else
				if (is_abs(e1)) {
					v1 = (INT32) e1->e_addr;
					setbwl(v1);		/* Byte, Word, Long */
				} else {
					dot.s_addr += 6;	/* Long  External */
				}
			} else {
				if (is_abs(e1)) {
					v1 = (INT32) e1->e_addr;
					if (getbit()) {
						chkbrng(v1, "Byte Offset Out Of Range");
						outab(x1 >> 8);
						outab(e1->e_addr);	/* Byte */
					} else
					if (getbit()) {
						chkwrng(v1, "Word Offset Out Of Range");
						outaw(x1 | 0x0120);
						outaw(e1->e_addr);	/* Word */
					} else {
						outaw(x1 | 0x0130);
						outa4b(e1->e_addr);	/* Long */
					}
				} else
				if ((x1 & BD_LONG) == BD_NULL) {
					outab(x1 >> 8);
					outrb(e1, R_SGND);	/* Byte External */
				} else
				if ((x1 & BD_LONG) == BD_WORD) {
					outaw(x1 | 0x0120);
					outrw(e1, R_SGND);	/* Word External */
				} else {
					outaw(x1 | 0x0130);
					outr4b(e1, 0);		/* Long External */
				}
			}
			break;
		}
		/* ([bd,An,Xn],od) or ([bd,An],Xn,od) */
		if (pass == 0) {
			dot.s_addr += 2 + 8;
		} else
		if (pass == 1) {
			dot.s_addr += 2;
			/* bd processing */
			if ((x1 & BD_LONG) != BD_NULL) { 
				if (is_abs(e1)) {
					if ((x1 & BD_LONG) == BD_WORD) {
						setbit(1);
						dot.s_addr += 2;	/* Word */
					} else
					if ((x1 & BD_LONG) == BD_LONG) {
						setbit(0);
						dot.s_addr += 4;	/* Long */
					} else {
						v1 = (INT32) e1->e_addr;
						setwl(v1);		/* Word, Long */
					}
				} else
				if ((x1 & BD_LONG) == BD_WORD) {
					dot.s_addr += 2;	/* Word */
				} else {
					dot.s_addr += 4;	/* Long */
				}
			}
			/* od processing */
			if ((x1 & OD_LONG) != OD_NULL) {
				if (is_abs(e1xi)) {
					if ((x1 & OD_LONG) == OD_WORD) {
						setbit(1);
						dot.s_addr += 2;	/* Word */
					} else
					if ((x1 & OD_LONG) == OD_LONG){
						setbit(0);
						dot.s_addr += 4;	/* Long */
					} else {
						v1 = (INT32) e1xi->e_addr;
						setwl(v1);		/* Word, Long */
					}
				} else
				if ((x1 & OD_LONG) == OD_WORD) {
					dot.s_addr += 2;	/* Word */
				} else {
					dot.s_addr += 4;	/* Long */
				}
			}
		} else {
			/* pre-process bd and od */
			if ((x1 & BD_LONG) != BD_NULL) { 
				if (is_abs(e1)) {
					if (getbit()) {
						x1 |= BD_WORD;		/* Word */
					} else {
						x1 |= BD_LONG;		/* Long */
					}
				} else
				if ((x1 & BD_LONG) == 0) {
					x1 |= BD_LONG;		/* Long External */
				}
			}
			if ((x1 & OD_LONG) != OD_NULL) {
				if (is_abs(e1xi)) {
					if (getbit()) {
						x1 |= OD_WORD;		/* Word */
					} else {
						x1 |= OD_LONG;		/* Long */
					}
				} else
				if ((x1 & OD_LONG) == 0) {
					x1 |= OD_LONG;		/* Long External */
				}
			}
			outaw(x1);
			/* bd processing */
			if ((x1 & BD_LONG) != BD_NULL) { 
				if (is_abs(e1)) {
					v1 = (INT32) e1->e_addr;
					if ((x1 & BD_LONG) == BD_WORD) {
						chkwrng(v1, "Word Offset Out Of Range");
						outaw(e1->e_addr);	/* Word */
					} else {
						outa4b(e1->e_addr);	/* Long */
					}
				} else
				if ((x1 & BD_LONG) == BD_WORD) {
					outrw(e1, R_SGND);	/* Word External */
				} else {
					outr4b(e1, 0);		/* Long External */
				}
			}
			/* od processing */
			if ((x1 & OD_LONG) != OD_NULL) {
				if (is_abs(e1xi)) {
					v1 = (INT32) e1xi->e_addr;
					if ((x1 & OD_LONG) == OD_WORD) {
						chkwrng(v1, "Word Offset Out Of Range");
						outaw(v1);	/* Word */
					} else {
						outa4b(v1);	/* Long */
					}
				} else
				if ((x1 & OD_LONG) == OD_WORD) {
					outrw(e1xi, R_SGND);	/* Word External */
				} else {
					outr4b(e1xi, 0);	/* Long External */
				}
			}
		}
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
		/* 68000, 68008, and 68010  d(PC) or (d,PC) */
		if (mchtyp < M_68020) {
#if 0
			if (is_abs(e1)) {
				/* d is a number (constant) */
				v1 = (INT32) (e1->e_addr - pcofst);
				chkwrng(v1, "PC-Relative Range Exceeded");
				outaw(v1);
			} else
			if (mchpcr(e1)) {
				if (e1->e_addr >= dot.s_addr) {
					e1->e_addr -= fuzz;
				}
				/* d is a label (in the same area) */
				v1 = (INT32) (e1->e_addr - (pc + pcofst));
				chkwrng(v1, "PC-Relative Range Exceeded");
				outaw(v1);
			} else {
				/* d is external (treated as a label) */
				e1->e_addr += pcofst;
				outrw(e1, R_PCR);
			}
			break;
#else
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
#endif
		}
		/* 68020  d(PC) or (d,PC) */
		if (pass == 0) {
			dot.s_addr += 6;
		} else
		if (pass == 1) {
			if (e1->e_addr >= dot.s_addr) {
				e1->e_addr -= fuzz;
			}
			if (is_abs(e1) || mchpcr(e1)) {
				if (((x1 & BD_LONG) == BD_NULL) || ((x1 & BD_LONG) == BD_WORD)) {
					setbit(1);
					dot.s_addr += 2;	/* Word == 2 */
				} else
				if ((x1 & BD_LONG) == BD_LONG) {
					setbit(0);
					dot.s_addr += 6;	/* Long == 6 */
				} else {
					/* d is a label (in the same area) */
					v1 = (INT32) (e1->e_addr - (pc + pcofst));
					/* d is a number (constant) */
					if (is_abs(e1)) v1 += (INT32) pc;
					if (setwl(v1) == 4) {	/* Word == 2 */
						dot.s_addr += 2;/* Long == 6 */
					}
				}
			} else
			if (((x1 & BD_LONG) == BD_NULL) || ((x1 & BD_LONG) == BD_WORD)) {
				setbit(1);
				dot.s_addr += 2;	/* Word External */
			} else {
				dot.s_addr += 6;	/* Long External */
			}
		} else {
			if (is_abs(e1) || mchpcr(e1)) {
				/* d is a label (in the same area) */
				v1 = (INT32) (e1->e_addr - (pc + pcofst));
				/* d is a number (constant) */
				if (is_abs(e1)) v1 += (INT32) pc;
				if (getbit()) {		/* Word */
					chkwrng(v1, "PC-Relative Range Exceeded");
					outaw(v1);
				} else {		/* Long */
					opcode &= ~S_PCID;
					opcode |=  S_PCIDX;
					outaw(x1 | 0x0170);
					outa4b(v1);
				}
			} else
			if (((x1 & BD_LONG) == BD_WORD) || ((x1 & BD_LONG) == BD_NULL)) {
				opcode &= ~S_PCID;
				opcode |=  S_PCIDX;
				outaw(x1 | 0x0160);
				e1->e_addr += dot.s_addr - (pc + pcofst) + 2;
				outrw(e1, R_PCR);
			} else {
				opcode &= ~S_PCID;
				opcode |=  S_PCIDX;
				outaw(x1 | 0x0170);
				e1->e_addr += dot.s_addr - (pc + pcofst) + 4;
				outr4b(e1, R_PCR);
			}
		}
		break;
	case S_PCIDX:	/* d(PC,Xi)  or (d,PC,Xn) */
		if (!(x1 & FF_FLAG)) { 
			/* 68000, 68008, and 68010  d(PC,Xn) or (d,PC,Xn) */
			if (mchtyp < M_68020) {
#if 0
				if (is_abs(e1)) {
					/* d is a number (constant) */
					v1 = (INT32) (e1->e_addr - pcofst);
					chkwrng(v1, "PC-Relative Range Exceeded");
					outaw(v1);
				} else
				if (mchpcr(e1)) {
					if (e1->e_addr >= dot.s_addr) {
						e1->e_addr -= fuzz;
					}
					/* d is a label (in the same area) */
					v1 = (INT32) (e1->e_addr - (pc + pcofst));
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
#else
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
#endif
			}
			/* 68020  d(PC,Xn) or (d,PC,Xn) */
			if (pass == 0) {
				dot.s_addr += 6;
			} else
			if (pass == 1) {
				if (e1->e_addr >= dot.s_addr) {
					e1->e_addr -= fuzz;
				}
				if (is_abs(e1) || mchpcr(e1)) {
					if ((x1 & BD_LONG) == BD_NULL) {
						setbit(1);
						dot.s_addr += 2;	/* Byte == 2 */
					} else
					if ((x1 & BD_LONG) == BD_WORD) {
						setbit(0);	setbit(1);
						dot.s_addr += 4;	/* Word == 4 */
					} else
					if ((x1 & BD_LONG) == BD_LONG) {
						setbit(0);	setbit(0);
						dot.s_addr += 6;	/* Long == 6 */
					} else {
						/* d is a label (in the same area) */
						v1 = (INT32) (e1->e_addr - (pc + 2));
						/* d is a number (constant) */
						if (is_abs(e1)) v1 += (INT32) pc;
						setbwl(v1);		/* Byte, Word, Long */
					}
				} else
				if ((x1 & BD_LONG) == BD_NULL) {
					dot.s_addr += 2;	/* Byte External */
				} else
				if ((x1 & BD_LONG) == BD_WORD) {
					dot.s_addr += 4;	/* Word Externa; */
				} else {
					dot.s_addr += 6;	/* Long  External */
				}
			} else {
				if (is_abs(e1) || mchpcr(e1)) {
					/* d is a label (in the same area) */
					v1 = (INT32) (e1->e_addr - (pc + pcofst));
					/* d is a number (constant) */
					if (is_abs(e1)) v1 += (INT32) pc;
					if (getbit()) {		/* Byte */
						chkbrng(v1, "PC-Relative Range Exceeded");
						outab(x1 >> 8);
						outab(v1);
					} else
					if (getbit()) {		/* Word */
						chkwrng(v1, "PC-Relative Range Exceeded");
						outaw(x1 | 0x0120);
						outaw(v1);
					} else {		/* Long */
						outaw(x1 | 0x0130);
						outa4b(v1);
					}
				} else
				if ((x1 & BD_LONG) == BD_NULL) {
					e1->e_addr += dot.s_addr - (pc + pcofst) + 2;
					outab(x1 >> 8);
					outrb(e1, R_PCR);
				} else
				if ((x1 & BD_LONG) == BD_WORD) {
					outaw(x1 | 0x0120);
					e1->e_addr += dot.s_addr - (pc + pcofst) + 2;
					outrw(e1, R_PCR);
				} else {
					outaw(x1 | 0x0130);
					e1->e_addr += dot.s_addr - (pc + pcofst) + 4;
					outr4b(e1, R_PCR);
				}
			}
			break;
		}
		/* ([bd,PC,Xn],od) or ([bd,PC],Xn,od) */
		if (pass == 0) {
			dot.s_addr += 2 + 8;
		} else
		if (pass == 1) {
			dot.s_addr += 2;
			/* bd processing */
			if ((x1 & BD_LONG) != BD_NULL) { 
				if (e1->e_addr >= dot.s_addr) {
					e1->e_addr -= fuzz;
				}
				if (is_abs(e1) || mchpcr(e1)) {
					if ((x1 & BD_LONG) == BD_WORD) {
						setbit(1);
						dot.s_addr += 2;	/* Word */
					} else
					if ((x1 & BD_LONG) == BD_LONG) {
						setbit(0);
						dot.s_addr += 4;	/* Long */
					} else {
						/* d is a label (in the same area) */
						v1 = (INT32) (e1->e_addr - (pc + pcofst));
						/* d is a number (constant) */
						if (is_abs(e1)) v1 += (INT32) pc;
						setwl(v1);		/* Word, Long */
					}
				} else
				if ((x1 & BD_LONG) == BD_WORD) {
					dot.s_addr += 2;		/* Word */
				} else {
					dot.s_addr += 4;		/* Long */
				}
			}
			/* od processing */
			if ((x1 & OD_LONG) != OD_NULL) {
				if (is_abs(e1xi)) {
					if ((x1 & OD_LONG) == OD_WORD) {
						setbit(1);
						dot.s_addr += 2;	/* Word */
					} else
					if ((x1 & OD_LONG) == OD_LONG){
						setbit(0);
						dot.s_addr += 4;	/* Long */
					} else {
						v1 = (INT32) e1xi->e_addr;
						setwl(v1);		/* Word, Long */
					}
				} else
				if ((x1 & OD_LONG) == OD_WORD) {
					dot.s_addr += 2;		/* Word */
				} else {
					dot.s_addr += 4;		/* Long */
				}
			}
		} else {
			/* pre-process bd and od */
			if ((x1 & BD_LONG) != BD_NULL) {
				if (is_abs(e1) || mchpcr(e1)) {
					if (getbit()) {
						x1 |= BD_WORD;		/* Word */
					} else {
						x1 |= BD_LONG;		/* Long */
					}
				} else
				if ((x1 & BD_LONG) == 0) {
					x1 |= BD_LONG;		/* Long External */
				}
			}
			if ((x1 & OD_LONG) != OD_NULL) {
				if (is_abs(e1xi)) {
					if (getbit()) {
						x1 |= OD_WORD;		/* Word */
					} else {
						x1 |= OD_LONG;		/* Long */
					}
				} else 
				if ((x1 & OD_LONG) == 0) {
					x1 |= OD_LONG;		/* Long External */
				}
			}
			/* bd processing */
			if ((x1 & BD_LONG) != BD_NULL) {
 		        	if (is_abs(e1) || mchpcr(e1)) {
					/* d is a label (in the same area) */
					v1 = (INT32) (e1->e_addr - (pc + pcofst));
					/* d is a number (constant) */
					if (is_abs(e1)) v1 += (INT32) pc;
					outaw(x1);
					if ((x1 & BD_LONG) == BD_WORD) {
						chkwrng(v1, "PC-Relative Range Exceeded (BD)");
						outaw(v1);		/* Word Local */
					} else {
						outa4b(v1);		/* Long Local */
					}
				} else {
					outaw(x1);
					if ((x1 & BD_LONG) == BD_WORD) {
						e1->e_addr += dot.s_addr - (pc + pcofst) + 2;
						outrw(e1, R_PCR);	/* Word External */
					} else {
						e1->e_addr += dot.s_addr - (pc + pcofst) + 4;
						outr4b(e1, R_PCR);	/* Long External */
					}
				}
			} else {
				outaw(x1);
			}
			/* od processing */
			if ((x1 & OD_LONG) != OD_NULL) {
				if (is_abs(e1xi)) {
					v1 = (INT32) e1xi->e_addr;
					if ((x1 & OD_LONG) == OD_WORD) {
						chkwrng(v1, "Word Offset Out Of Range (OD)");
						outaw(v1);		/* Word Local */
					} else {
						outa4b(v1);		/* Long Local */
					}
				} else
				if ((x1 & OD_LONG) == OD_WORD) {
					outrw(e1xi, R_SGND);		/* Word External */
				} else {
					outr4b(e1xi, 0);		/* Long External */
				}
			}
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
 * Translate fsz to sz
 */
VOID
fsz2sz()
{
	if (fsz == F_B) { sz = A_B; } else
	if (fsz == F_W) { sz = A_W; } else {
		sz = A_L;
	}
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
mvlist(esp, rc)
struct expr *esp;
int *rc;
{
	int c;
	char *p;
	int i, list, v1, v2;

	p = ip;
	*rc = 0;
	list = 0;
	if (admode(Dn) || admode(An)) {
		ip = p;
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
		ip = p;
		esp->e_addr = (a_uint) list;
		return(1);
	} else
	if (getnb() == '#') {
		expr(esp, 0);
		if (is_abs(esp)) {
			for (i=0,v1=1; i<=15; v1<<=1,i++) {
				if (esp->e_addr & v1) *rc += 1;
			}
		}
		return(1);
	}
	ip = p;
	return(0);
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
	if (admode(FPn)) {
		ip = p;
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
 * Create A Floating Control Register List
 *
 * FPcr Bits:
 *   2     1     0
 * ----- ----- -----
 *  FPCR  FPSR FPIAR
 */
int
fcrlist(rc)
int *rc;
{
	int c;
	char *p;
	int list;

	p = ip;
	*rc = 0;
	list = 0;
	if (admode(FCR)) {
		ip = p;
		do {
			/* FPIAR/FPSR/FPCR */
			if (admode(FCR)) {
				list |= aindx;
				*rc += 1;
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
 * Create A 96-Bit
 * Packed Floating Point Element
 */
VOID
fltpk()
{
	int c, i, j, v;
	char mval[24];
	int efnd, dpnt, msgn, xpsgn;
	unsigned int xpnt, xpntm, xpnte;

	for (i=0; i<24; i++) mval[i] = 0;
	efnd = dpnt = msgn = xpsgn = 0;
	xpnt = xpntm = xpnte = 0;

	i = 0;	j = 1;	v = 0;
	while (j) {
		switch(c = getnb()) {
		case 0:
		case ';':
		case ',':	unget(c);	j = 0;	break;
		case '-':	if (efnd) {
					xpsgn ^= 1;
				} else {
					msgn ^= 1;
				}
				break;
		case '.':	dpnt += 1;		break;
		case 'e':
		case 'E':	efnd += 1;		break;
		case '+':				break;
		default:
			v = digit(c, 10);
			if (v < 0) {
				xerr('w', "A Non Decimal Character Found");
			} else {
				if (!efnd) {
					mval[i] = v;
					if (mval[0]) {
						if (i && !dpnt) xpntm += 1;
						i += 1;
					} else {
						if (dpnt) xpntm -= 1;
					}
				} else {
					xpnte = (10 * xpnte) + v;
				}
			}
			break;
		}
		if (i > 17) i = 17;
	}
	if (dpnt > 1) xerr('w', "More Than One '.' Found");
	if (efnd > 1) xerr('w', "More Than One 'E' Found");
	if (xpnte) {	/* xpnte != 0, Fixup Sign */
		xpnt = xpsgn ? xpnte - xpntm : xpnte + xpntm;
	} else {	/* xpnte == 0, No Sign Fixup */
		xpnt = xpntm;
	}
	if (xpnt > 999) {
		if (!xpsgn) {		/* Too Large To Normalize*/
			xerr('w', "Exponent Larger Than +999, Value Set To +/- Infinity");
			for (i=0; i<18; i++) mval[i] = 0;
			outab(msgn ? 0xFF : 0x7F);
			outab(0xFF);
		} else
		if (xpnt > 1015) {	/* Too Small To Normalize */
			xerr('w', "Exponent Less Than -1015, Value Set To +/- Zero");
			for (i=0; i<18; i++) mval[i] = 0;
			outab(msgn ? 0xC0 : 0x40);
			outab(0x00);
		} else {		/* Un-Normalize */
#if 1
			do {
				for (j=16; j>=0; --j) {
					mval[j+1] = mval[j];
				}
				mval[0] = 0;
			} while (--xpnt > 999);
#else
			for (i=0; i<(xpnt-999); i++) {
				for (j=16; j>=0; --j) {
					mval[j+1] = mval[j];
				}
				mval[0] = 0;
			}
#endif
			outab(msgn ? 0xC9 : 0x49);
			outab(0x99);
		}
	} else {
		v = xpnt / 100;
		outab((msgn ? 0x80 : 0x00) | (xpsgn ? 0x40 : 0x00) | v);
		v = xpnt % 100;
		outab(((v / 10) << 4) | (v % 10));
	}
	outaw(mval[0]);
	for (i=1; i<17; i+=2) {
		outab((mval[i] << 4) | mval[i+1]);
	}
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
	/* Floating Point Truncation */
	if (symeq(id, "fpt", 1)) { fpt = v; } else
	/* Automatic Direct Page (Constants) */
	if (symeq(id, "autodpcnst", 1)) { autodpcnst = v; } else
	/* Automatic Direct Page (Symbols) */
	if (symeq(id, "autodpsmbl", 1)) { autodpsmbl = v; } else {
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
	 * Set Default Machine Type
	 */
	sym[2].s_addr = mchtyp = M_68000;	/* 68000 CPU */
	flttyp = M_NONE;			/* No Floating Point */
	/*
	 * Reset Options
	 */
	alt = 1;	/* Alternate Instructions */
	fpt = 0;	/* Floating Point Truncation */
	autodpcnst = 1;	/* Automatic Direct Page Addressing With Constants */
	autodpsmbl = 1;	/* Automatic Direct Page Addressing With Symbols*/
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
	 * Reset Co-Processor ID
	 */
	coid = (1 << 9);
	/*
	 * Increase Cycle Count Digits
	 */
	if (cycldgts == 2) {
		cycldgts = 3;
	}
	/*
	 * External Calls
	 */
	/* .enabl/.dsabl Extension */
	mchoptn_ptr = mchoptn;
}

