/* pdp11mch.c */

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


char	*cpu	= "Digital Equipment Corporation PDP11";
char	*dsft	= "asm";

int	ama;	/* Address Memory Absolute Flag */
int	smi;	/* Self Modifying Instruction Flag */
int	rtyp;	/* Explicit Register Types Required */

#define	NB	512

int	*bp;
int	bm;
int	bb[NB];

/*
 * Process a machine op.
 */
void
machine(struct mne *mp)
{
	a_uint op, opcode;
	int rf, cycles;
	struct expr e1, e2;
	int t1, t2, v1, v2, p1, p2, a1, a2;

	clrexpr(&e1);
	clrexpr(&e2);

	/*
	 * Instructions on a Word Boundary
	 */
	if (dot.s_addr & 0x0001) {
		outall();
		xerr('b', "Odd instruction address incremented by 1.");
		dot.s_addr += 1;
	}

	op = mp->m_valu;
	rf = mp->m_type;
	opcode = op;
	cycles = mclookup(mp);
	switch (rf) {

	case S_RAD50:
		while (more()) {
			v1 = getdlm();
			while (tst50(*ip)) {
				outaw(rad50());
			} 
			if (getnb() != v1) {
				xerr('q', "Not RAD50 Or A Missing Delimiter");
			}
			comma(0);
		}
		break;

	case S_DOUBLE:
	case S_ACDST:
	case D_ACDST:
	case S_ACFDST:
	case D_ACFDST:
	case S_SRCAC:
	case D_SRCAC:
	case S_FSRCAC:
	case D_FSRCAC:
	case S_RXX:
	case S_XXR:
	case S_MOVF:
		t1 = addr(&e1);
		v1 = (a1 = aindx) & 7;		/* mask fpreg here */
		p1 = pcrel;
		switch(rf) {
		case S_DOUBLE:	/* ___ SRC,DST  ->  ---|SRC|DST| */
		case S_SRCAC:	/* ___ SRC,AC   ->  ---|AC|SRC| */
		case S_XXR:	/* ___ XXX,R    ->  ---|R|XXX| */
			if (rtyp && (a1 & S_FPR)) {
				xerr('w', "Use Registers 0-7 In First Argument");
			}
			break;
		case S_FSRCAC:	/* ___ FSRC,AC  ->  ---|AC|FSRC| */
		case D_FSRCAC:
			if (t1 == S_REG) {	/* ___ AC0-AC5,AC0-AC3 */
				if ((rtyp && !(a1 & S_FPR)) || (v1 > 5)) {
					xerr('w', "Use Floating Registers 0-5 In Register Mode");
				}
				v1 %= 6;
			} else {		/* ___ (Rn),AC0-AC3 / ___ (Rn)+,AC0-AC3 / ... */
				if (rtyp && (a1 & S_FPR)) {
					xerr('w', "Use Registers 0-7 In Addressing Modes");
				}
			}
			break;
		case S_ACDST:	/* ___ AC,DST   ->  ---|AC|DST| */
		case D_ACDST:
		case S_ACFDST:	/* ___ AC,FDST  ->  ---|AC|FDST| */
		case D_ACFDST:
			if ((t1 != S_REG) || (rtyp && !(a1 & S_FPR)) || (v1 > 3)) {
				xerr('w', "Use Floating Registers 0-3 For First Argument");
			}
			t1 = S_REG;
			v1 %= 4;
			break;
		case S_RXX:	/* ___ R,SRC    ->  ---|R|SRC| */
			if ((t1 != S_REG) || (rtyp && (a1 & S_FPR))) {
				xerr('w', "Use Registers 0-7 For First Argument");
 			}
			t1 = S_REG;
			break;
		default:
			break;
		}
		comma(1);
		t2 = addr(&e2);
		v2 = (a2 = aindx) & 7;		/* mask fpreg here */
		p2 = pcrel;
		switch(rf) {
		case S_DOUBLE:	/* ___ SRC,DST  ->  ---|SRC|DST| */
		case S_ACDST:	/* ___ AC,DST   ->  ---|AC|DST| */
		case D_ACDST:	/* ___ AC,DST   ->  ---|AC|DST| */
		case S_RXX:	/* ___ R,SRC    ->  ---|R|SRC| */
			if (rtyp && (a2 & S_FPR)) {
				xerr('w', "Use Registers 0-7 In Second Argument");
			}
			break;
		case S_ACFDST:	/* ___ AC,FDST  ->  ---|AC|FDST| */
		case D_ACFDST:	/* ___ AC,FDST  ->  ---|AC|FDST| */
			if (t2 == S_REG) {	/* ___ AC0-AC3,AC0-AC5 */
				if ((rtyp && !(a2 & S_FPR)) || (v1 > 5)) {
					xerr('w', "Use Floating Registers 0-5 In Register Mode");
				}
				v1 %= 6;
			} else {		/* ___ AC0-AC3,(Rn) / ___ AC0-AC3,(Rn)+ / ... */
				if (rtyp && (a2 & S_FPR)) {
					xerr('w', "Use Registers 0-7 In Addressing Modes");
				}
			}
			break;
		case S_SRCAC:	/* ___ SRC,AC   ->  ---|AC|SRC| */
		case D_SRCAC:	/* ___ SRC,AC   ->  ---|AC|SRC| */
		case S_FSRCAC:	/* ___ FSRC,AC  ->  ---|AC|FSRC| */
		case D_FSRCAC:	/* ___ FSRC,AC  ->  ---|AC|FSRC| */
			if ((t2 != S_REG) || (rtyp && !(a2 & S_FPR)) || (v2 > 3)) {
				xerr('w', "Use Floating Registers 0-3 For Second Argument");
			}
			t2 = S_REG;
			v2 %= 4;
			break;
		case S_XXR:	/* ___ XXX,R    ->  ---|R|XXX| */
			if ((t2 != S_REG) || (rtyp && (a2 & S_FPR))) {
				xerr('w', "Use Registers 0-7 For Second Argument");
 			}
			t2 = S_REG;
			break;
		default:
			break;
		}

		/*
		 * Process MOVF Instruction
		 */
		if (rf == S_MOVF) {
			if ((t1 != S_REG) && (t2 == S_REG)) {
				if ((rtyp && !(a2 & S_FPR)) || (v2 > 3)) {
					xerr('w', "Use Floating Registers 0-3 For Second Argument");
				}
				v2 %= 4;
				rf = S_FSRCAC;
				op = opcode = 0172400;	/* ldf */
				cycles = 13;
			} else
			if ((t2 != S_REG) && (t1 == S_REG)) {
				if ((rtyp && !(a1 & S_FPR)) || (v1 > 3)) {
					xerr('w', "Use Floating Registers 0-3 For First Argument");
				}
				v1 %= 4;
				rf = S_ACFDST;
				op = opcode = 0174000;	/* stf */
				cycles = 8;
			} else
			if ((t1 == S_REG) && (t2 == S_REG)) {
				if (rtyp && (!(a1 & S_FPR) || !(a2 & S_FPR))) {
					xerr('w', "Use Floating Registers");
				}
				if (v1 & v2 & 4) {
					xerr('w', "Floating Registers 4-5 Allowed In Only One Argument");
				} else
				if (v1 & 4) {
					rf = S_FSRCAC;
					op = opcode = 0172400;	/* ldf */
					cycles = 13;
				} else {
					rf = S_ACFDST;
					op = opcode = 0174000;	/* stf */
					cycles = 8;
				}
			} else {
				xerr('w', "Invalid MOVF Instruction Format");
			}
		}

		/*
		 * Non Zero 'ama' Changes 'A' Relative Mode To '@#A' Absolute Mode
		 */
		if (ama && p1 && ((t1 | v1) == 067)) {
			t1 = S_IND | S_IMM;	/* A -> @#A */
		}
		if (ama && p2 && ((t2 | v2) == 067)) {
			t2 = S_IND | S_IMM;	/* A -> @#A */
		}

		switch(rf) {
		case S_DOUBLE:
		case S_RXX:
		case S_ACDST:
		case D_ACDST:
		case S_ACFDST:
		case D_ACFDST:
			opcode |= ((t1 | v1) << 6) | t2 | v2;
			break;
		case S_XXR:
		case S_SRCAC:
		case D_SRCAC:
		case S_FSRCAC:
		case D_FSRCAC:
			opcode |= ((t2 | v2) << 6) | t1 | v1;
			break;
		default:
			break;
		}
		outaw(opcode);

		/*
		 * Source Processing
		 */
		switch(t1) {
		case S_REG:		/*	Rn	*/
		case S_IND | S_REG:	/*	(Rn)	*/
		case S_INC:		/*	(Rn)+	*/
		case S_IND | S_INC:	/*	@(Rn)+	*/
		case S_DEC:		/*	-(Rn)	*/
		case S_IND | S_DEC:	/*	@-(Rn)	*/
			break;
		case S_IMM:		/*	#N  (Rn = 7) */
		case S_IND | S_IMM:	/*	@#A (Rn = 7) */
			outrw(&e1, 0);
			break;
		case S_IDX:		/*	X(Rn)  /  A (Rn = 7) */
		case S_IND | S_IDX:	/*	@X(Rn) / @A (Rn = 7) */
			if (p1) {	/* A or @A */
				if (mchpcr(&e1, NULL, 2)) {
					outaw(e1.e_addr - dot.s_addr - 2);
				} else {
					outrw(&e1, R_PCR);
				}
			} else {	/* X(Rn) or @X(Rn) */
				outrw(&e1, 0);
			}
			break;
		default:
			aerr();
			break;
		}

		/*
		 * Destination Processing
		 */
		switch(t2) {
		case S_REG:		/*	Rn	*/
		case S_IND | S_REG:	/*	(Rn)	*/
		case S_INC:		/*	(Rn)+	*/
		case S_IND | S_INC:	/*	@(Rn)+	*/
		case S_DEC:		/*	-(Rn)	*/
		case S_IND | S_DEC:	/*	@-(Rn)	*/
			break;
		case S_IMM:		/*	#N  (Rn = 7) */
		case S_IND | S_IMM:	/*	@#A (Rn = 7) */
			outrw(&e2, 0);
			break;
		case S_IDX:		/*	X(Rn)  / A  (Rn = 7) */
		case S_IND | S_IDX:	/*	@X(Rn) / @A (Rn = 7) */
			if (p2) {	/* A or @A */
				if (mchpcr(&e2, NULL, 2)) {
					outaw(e2.e_addr - dot.s_addr - 2);
				} else {
					outrw(&e2, R_PCR);
				}
			} else {	/* X(Rn) or @X(Rn */
				outrw(&e2, 0);
			}
			break;
		default:
			aerr();
			break;
		}
		break;

	case S_SINGLE:
	case S_RTS:
	case S_FIS:
	case S_FXXX:
	case D_FXXX:
		t1 = addr(&e1);
		v1 = aindx & 7;		/* mask fpreg here */
		p1 = pcrel;
		switch(rf) {
		case S_SINGLE:		/* ___ XXX  ->  ---|XXX| */
			if (rtyp && (aindx & S_FPR)) {
				xerr('w', "Use Registers 0-7 In Argument");
			}
			break;
		case S_RTS:
		case S_FIS:		/* ___ R    ->  ---|R| */
			if ((t1 != S_REG) || (rtyp && (aindx & S_FPR))) {
				xerr('w', "Use Registers 0-7 In Argument");
			}
			t1 = S_REG;
			break;
		case S_FXXX:
		case D_FXXX:
			if (t1 == S_REG) {	/* ___ AC0-AC5 */
				if ((rtyp && !(aindx & S_FPR)) || (v1 > 5)) {
					xerr('w', "Use Floating Registers 0-5 In Register Mode");
				}
				v1 %= 6;
			} else {		/* ___ (Rn) / ___ (Rn)+ / ... */
				if (rtyp && (aindx & S_FPR)) {
					xerr('w', "Use Registers 0-7 In Addressing Modes");
				}
			}
			break;
		default:
			break;
		}
		/*
		 * Non Zero 'ama' Changes 'A' Relative Mode To '@#A' Absolute Mode
		 */
		if (ama && p1 && ((t1 | v1) == 067)) {
			t1 = S_IND | S_IMM;	/* A -> @#A */
		}
		outaw(opcode |= t1 | v1);

 		/*
 		 * Source/Destination Processing
 		 */
		switch(t1) {
		case S_REG:		/*	Rn	*/
		case S_IND | S_REG:	/*	(Rn)	*/
		case S_INC:		/*	(Rn)+	*/
		case S_IND | S_INC:	/*	@(Rn)+	*/
		case S_DEC:		/*	-(Rn)	*/
		case S_IND | S_DEC:	/*	@-(Rn)	*/
			break;
		case S_IMM:		/*	#N  (Rn = 7) */
		case S_IND | S_IMM:	/*	@#A (Rn = 7) */
			outrw(&e1, 0);
			break;
		case S_IDX:		/*	X(Rn)  / A  (Rn = 7) */
		case S_IND | S_IDX:	/*	@X(Rn) / @A (Rn = 7) */
			if (p1) {	/* A or @A */
				if (mchpcr(&e1, NULL, 2)) {
					outaw(e1.e_addr - dot.s_addr - 2);
				} else {
					outrw(&e1, R_PCR);
				}
			} else {	/* X(Rn) or @X(Rn) */
				outrw(&e1, 0);
			}
			break;
		default:
			aerr();
			break;
		}
		break;

	case S_BRANCH:
		expr(&e1, 0);
		if (mchpcr(&e1, &v1, 2)) {
			if ((v1 < -128) || (v1 > 127)) {
				xerr('a', "Branching Range Exceeded");
			}
			outaw(opcode |= (v1 & 0x00FF));
		} else {
			outrwm(&e1, R_8BIT | R_PCR, opcode);
		}
		if (e1.e_mode != S_USER)
			rerr();
		break;

	case S_SOB:
		t1 = addr(&e1);
		v1 = aindx & 7;		/* mask fpreg here */
		comma(1);
		expr(&e2, 0);

		if ((t1 != S_REG) || (rtyp && (aindx & S_FPR))) {
			xerr('w', "Register 0-7 Required For First Argument");
		}
		if (mchpcr(&e2, &v2, 2)) {
			v2 = -v2;	/* SOB uses reverse offset */
			if ((v2 < 0) || (v2 > 63)) {
				xerr('a', "Branching Range Exceeded");
			}
			outaw(opcode |= (v1 << 6) | (v2 & 0x003F));
		} else {
			xerr('w', "Only Branching Within Current Area Is Allowed"); 
		}
		if (e2.e_mode != S_USER)
			rerr();
		break;

	case S_CIS:
	case S_INH:
		outaw(opcode);
		break;

	case S_LXDN:
		t1 = addr(&e1);
		v1 = aindx & 7;		/* mask fpreg here */
		if (rtyp && (aindx & S_FPR)) {
			xerr('w', "Use Registers 0-7 In Addressing Modes");
		}
		outaw(opcode |= v1);
		break;

	case S_SPL:
		expr(&e1, 0);
		if (is_abs(&e1)) {
			v1 = (int) e1.e_addr;
			if (v1 & ~7) {
				xerr('a', "0 <= Priority Value <= 7 Required");
			}
			outaw(opcode |= (v1 & 7));
		} else {
			outrwm(&e1, R_3BIT | R_OVRF, op);
		}
		break;
 
	case S_MARK:
		expr(&e1, 0);
		if (is_abs(&e1)) {
			v1 = (int) e1.e_addr;
			if (v1 & ~077) {
				xerr('a', "0 <= Parameter Count <= 63 Required");
			}
			outaw(opcode |= (v1 & 077));
		} else {
			outrwm(&e1, R_6BIT | R_OVRF, op);
		}
		break;

	case S_SWI:
		expr(&e1, 0);
		if (is_abs(&e1)) {
			v1 = (int) e1.e_addr;
			if (v1 & ~0377) {
				xerr('a', "0 <= Parameter Value <= 255 Required");
			}
			outaw(opcode |= (v1 & 0377));
		} else {
			outrb(&e1, R_OVRF);
			outab(op >> 8);
		}
		break;

	case S_JBR:
		expr(&e1, 0);
		switch(pass) {
		case 2:
			if (mchpcr(&e1, &v1, 2)) {
				if (!getbit()) {
					/*
					 * br X
					 */
					outaw(opcode |= (v1 & 0x00FF));
				} else {
					/*
					 * jmp X(r7)
					 */
					if (ama) {
						outaw(opcode = 000137);
						outrw(&e1, 0);
					} else {
						outaw(opcode = 000167);
						outaw((v1 - 1) << 1);
					}
				}
			} else {
				/*
				 * jmp X(r7)
				 */
				if (ama) {
					outaw(opcode = 000137);
					outrw(&e1, 0);
				} else {
					outaw(opcode = 000167);
					outrw(&e1, R_PCR);
				}
			}
			break;
		case 1:
			if (e1.e_addr >= dot.s_addr) {
				e1.e_addr -= fuzz;
			}
			if (mchpcr(&e1, &v1, 2) &&
			    !setbit((v1 < -128) || (v1 > 127))) {
				dot.s_addr += 2;
				break;
			}
			/* fallthru */
		case 0:
			dot.s_addr += 4;
			break;
		}
		break;

	case S_JCOND:
		expr(&e1, 0);
		switch (pass) {
		case 2:
			if (mchpcr(&e1, &v1, 2)) {
				if (!getbit()) {
					/*
					 * bxx X
					 */
					outaw(opcode |= (v1 & 0x00FF));
				} else {
					/*
					 * ~bxx .+6
					 */
					outaw((op ^= 000400) | 2);
					/*
					 * jmp X(r7)
					 */
					if (ama) {
						outaw(opcode = 000137);
						outrw(&e1, 0);
					} else {
						outaw(opcode = 000167);
						outaw((v1 - 2) << 1);
					}
				}
			} else {
				/*
				 * ~bxx .+6
				 */
				outaw((op ^= 000400) | 2);
				/*
				 * jmp X(r7)
				 */
				if (ama) {
					outaw(opcode = 000137);
					outrw(&e1, 0);
				} else {
					outaw(opcode = 000167);
					outrw(&e1, R_PCR);
				}
			}
			break;
		case 1:
			if (e1.e_addr >= dot.s_addr) {
				e1.e_addr -= fuzz;
			}
			if (mchpcr(&e1, &v1, 2) &&
			    !setbit((v1 < -128) || (v1 > 127))) {
				dot.s_addr += 2;
				break;
			}
			/* fallthru */
		case 0:
			dot.s_addr += 6;
			break;
 		}
		break;

	case S_INT32:
		do {
			exprmasks(4);	/* Use 32-Bit Arithmetic */
			expr(&e1, 0);
			exprmasks(2);	/* Restore to 16-Bit Arithmetic */
			abscheck(&e1);
			outaw(e1.e_addr >> 16);
			outaw(e1.e_addr);
		} while (comma(0));
		break;

	case W_FLT16:
		do {
			atowrd();
			outaw(rslt[3]);
		} while (comma(0));
		break;

	case S_FLT32:
		do {
			atoflt();
			outaw(rslt[3]);
			outaw(rslt[2]);
		} while (comma(0));
		break;

	case D_FLT64:
		do {
			atodbl();
			outaw(rslt[3]);
			outaw(rslt[2]);
			outaw(rslt[1]);
			outaw(rslt[0]);
		} while (comma(0));
		break;

	default:
		opcycles = OPCY_ERR;
		xerr('o', "Internal Opcode Error");
		break;
	}

	/*
	 * Illegal Instructions
	 */
	if ((op == 0004000) && ((opcode & 0000070) == 0000000)) {
		xerr('w', "JSR Rn,R0-R7 Is An Illegal Instruction");
	}
	if ((op == 0000100) && ((opcode & 0000070) == 0000000)) {
		xerr('w', "JMP R0-R7 Is An Illegal Instruction");
	}
	/*
	 * Self Modifying Instructions
	 */
	if ((smi == 0) && ((opcode & 0000077) == 0000027)) {
		switch(op) {
		/*
		 * Single Operand Instructions
		 */
		case 0000300:	/* swab */
		case 0005000:	/* clr */
		case 0105000:	/* clrb */
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
		case 0006000:	/* ror */
		case 0106000:	/* rorb */
		case 0006100:	/* rol */
		case 0106100:	/* rolb */
		case 0006200:	/* asr */
		case 0106200:	/* asrb */
		case 0006300:	/* asl */
		case 0106300:	/* aslb */
		case 0006600:	/* mtpi */
		case 0106600:	/* mtpd */
		case 0006700:	/* sxt */
		case 0106700:	/* mfps */
		/*
		 * Double Operand Instructions
		 */
		case 0010000:	/* mov */
		case 0110000:	/* movb */
		case 0040000:	/* bic */
		case 0140000:	/* bicb */
		case 0050000:	/* bis */
		case 0150000:	/* bisb */
		case 0060000:	/* add */
		case 0160000:	/* sub */
		/*
		 * Floating Point Instructions
		 */
		case 0170600:	/* absf / absd */
		case 0170400:	/* clrf / clrd */
		case 0170700:	/* negf / negd */
		case 0176000:	/* stcfd / stcdf */
		case 0175400:	/* stcfi / stcfl /stcdi / stcdl */
		case 0175000:	/* stexp */
		case 0174000:	/* stf / std */
		case 0170200:	/* stfps */
		case 0170300:	/* stst */
		/*
		 * A Destination Mode Of (R7)+  ->  Will Change Code 
		 */
			xerr('w', "This Is A Self Modifying Instruction");
			break;
		default:
			break;
		}
	}

	if (opcycles == CYCL_NONE) {
		opcycles = mchcycles(mp, opcode, cycles);
	}
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
 			*v >>= 1;	/* Branches are in words */
#else
			/* Disallows branching from top-to-bottom and bottom-to-top */
			*v = (int) ((esp->e_addr & a_mask) - (dot.s_addr & a_mask) - n);
			*v >>= 1;	/* Branches are in words */
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
 * Store `b' in the next slot of the bit table.
 * If no room, force the longer form of the offset.
 */
int
setbit(int b)
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
 * Machine specific expression terms.
 */
int
mchterm(struct expr *esp)
{
	char *p;

	p = ip;
	if (getnb() == '^') {
		switch(ccase[*ip++ & 0x007F]) {	/* Option Must Immediately Follow ^ */
		case 'c':	/* Complement Argument */
			expr(esp, 100);
			abscheck(esp);
			esp->e_addr = ~esp->e_addr;
			break;
		case 'f':	/* Single Word Floating Point */
			atowrd();
			esp->e_addr = rslt[3];
			break;
		/*
		case 'r':	**
				 * RAD50 Is A Special Radix Used
				 * To Build File Name Strings.
				 * ^r Is Processed in pdpadr.c
				 * And .rad50 Processes Words.
				 **
		 */
		/*
		 * ^B, ^0, ^Q, ^D, ^H, And ^X
		 * Are Processed In asexpr.c
		 */
		default:	/* No Valid ^Option Found */
			ip = p;
			return(0);
		}
		return 1;
	}
	ip = p;
	return 0;
}

/*
 * Machine specific .enabl/.dsabl terms.
 */
int
mchoptn(char *id, int v)
{
	/* Floating Point Truncation */
	if (symeq(id, "fpt", 1)) { fpt = v; } else
	/* Address Memory Absolute */
	if (symeq(id, "ama", 1)) { ama = v; } else
	/* Self Modifying Instruction */
	if (symeq(id, "smi", 1)) { smi = v; } else
	/* Automatic .WORD Generation, An Option In ASMAIN.C */ 
	if (symeq(id, "awg", 1)) { awg = v ? 2 : 0; } else
	/* Explicit Register Types */ 
	if (symeq(id, "rtyp", 1)) { rtyp = v; } else {
		return(0);
	}
	return(1);
}

/*
 * Machine specific initialization.
 */
void
minit(void)
{
	int i;

	/*
	 * Byte Order
	 */
	hilo = 0;
	/*
	 * Reset Options
	 */
 	fpt = 0;	/* Floating Point Truncation */
 	ama = 0;	/* Address Memory Absolute */
 	smi = 0;	/* Self Modifying Instruction */
 	awg = 0;	/* Automatic .WORD Generation */
	rtyp = 0;	/* Explicit Register Type Required */
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
	 * Allow 3 Digits For Cycle Count
	 */
	cycldgts = 3;
	/*
	 * External Calls
	 */
	/* asexpr.c term() Extension */
	mchterm_ptr = mchterm;
	/* .enabl/.dsabl Extension */
	mchoptn_ptr = mchoptn;
}


