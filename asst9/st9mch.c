/* st9mch.c */

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
#include "st9.h"

char	*cpu	= "STMicroelectronics STM9";
char	*dsft	= "asm";

/*
 * Opcode Cycle Definitions
 */
#define	OPCY_SDP	((char) (0xFF))
#define	OPCY_ERR	((char) (0xFE))
#define	OPCY_SKP	((char)	(0xFD))

#define	OPCY_NONE	((char) (0x80))
#define	OPCY_MASK	((char) (0x7F))

#define	UN	((char) (OPCY_NONE | 0x00))

/*
 * st9 Opcode Cycle Pages (Always Maximum Cycles)
 */

static char  st9cyc[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   2, 4, 4, 6, 6,UN,UN, 8, 4, 4, 6, 6,UN, 8, 8,10,
/*10*/   2, 4, 4, 6, 6,UN, 6, 8, 4, 4, 6, 6,UN, 8, 8,10,
/*20*/   8, 8, 4, 6, 6,UN,UN, 8, 4, 4, 6, 6,UN, 8, 8, 8,
/*30*/  UN,UN, 4, 6, 6,UN, 8, 8, 4, 4, 6, 6,UN, 8, 8,16,
/*40*/   4, 4, 4, 6, 6,UN,10, 8, 4, 4, 6, 6,UN, 8, 8,22,
/*50*/   4, 4, 4, 6, 6,UN,26, 8, 4, 4, 6, 6,UN, 8, 8,26,
/*60*/  12, 4, 4, 6, 6,UN, 8, 8, 4, 4, 6, 6,UN, 8, 8,10,
/*70*/   4, 6,UN,18,12,10, 8, 8, 4, 4, 6, 6,UN, 8,UN,UN,
/*80*/   4, 4, 4, 6, 6,UN,UN, 8, 4, 4, 6, 6,UN, 8, 8,12,
/*90*/   4, 4, 4, 6, 6,UN,UN, 8, 4, 4, 6, 6,UN, 8, 8,16,
/*A0*/   4, 6, 4, 6, 6,UN,UN, 8, 4, 4, 6, 6,UN, 8, 8,10,
/*B0*/   4, 6,UN,UN,UN,UN,16,10, 4, 4, 6, 6,UN, 8,UN,10,
/*C0*/   4, 6,UN,UN,UN,UN, 8, 4, 4, 4, 6, 6,UN, 8,UN, 6,
/*D0*/   4, 6,12,16, 8,UN,14,UN, 4, 4, 6, 6,UN, 8,UN, 6,
/*E0*/   4, 6,UN,UN, 6,UN, 6, 6, 4, 4, 6, 6,UN, 8, 4,99,
/*F0*/   8, 8,10,UN, 6,UN,12,12, 4, 4, 6, 6,UN, 8, 4, 2
};

/*
 * Process a machine op.
 */
void
machine(mp)
struct mne *mp;
{
	struct expr e1, e2, e3;
	int t1, t2, t3;
	int dst, src, seg, dsh, dsl;
	int opcd, opxt, ofst;
	int rf;

	/*
	 * Using Internal Format
	 * For Cycle Counting
	 */
	opcycles = OPCY_NONE;

	clrexpr(&e1);
	clrexpr(&e2);
	clrexpr(&e3);
	opcd = ((int) mp->m_valu) & 0xFF;
	rf = mp->m_type;

	switch (rf) {
	/*
	 * mne  = OR,  AND, SBC, ADC, ADD, SUB, XOR, TCM, CP,  TM
         * opxt =  0    1    2    3    4    5    6    8    9    A 
	 */
	case I_TYP1:
		t1 = addr(&e1);
		dst  = aindx;
		comma(1);
		t2 = addr(&e2);
		src  = aindx;
		opxt = opcd & 0xF0;
		/*
		 * Register,Register
		 */
		/* r,r */
		if ((t1 == S_WR) && (t2 == S_WR)) {
			outab(opcd); outab((dst << 4) | src);
			/* opcycles in table */ break;
		}
		/* r,(r) */
		if ((t1 == S_WR) && (t2 == S_IWR)) {
			outab(opcd+1); outab((dst << 4) | src);
			/* opcycles in table */ break;
		}
		/* R,R / r,R */
		if (((t1 == S_DR) || (t1 == S_WR)) && (t2 == S_DR)) {
			if (t1 == S_WR) dst |= 0xD0;
			outab(opcd+2); outab(src); outab(dst);
			/* opcycles in table */ break;
		}
		/* R,r */
		if ((t1 == S_DR) && (t2 == S_WR)) {
			outab(opcd+2); outab(src | 0xD0); outab(dst);
			/* opcycles in table */ break;
		}
		/* (r),R / (r),r */
		if ((t1 == S_IWR) && ((t2 == S_DR) || (t2 == S_WR))) {
			if (t2 == S_WR) src |= 0xD0;
			outab(0xE6); outab(src); outab(opxt | dst);
			/* opcycles in table */ break;
		}
		/* R,(r) */
		if ((t1 == S_DR) && (t2 == S_IWR)) {
			outab(0xE7); outab(opxt | src); outab(dst);
			/* opcycles in table */ break;
		}
		/*
		 * Register,Memory
		 */
		/* R,(rr) / r,(rr) */
		if (((t1 == S_DR) || (t1 == S_WR)) && (t2 == S_IWRR)) {
			if (t1 == S_WR) dst |= 0xD0;
			outab(0x72); outab(opxt | (src | 1)); outab(dst);
			opcycles = 8; break;
		}
		/* R,(rr)+ / r,(rr)+ */
		if (((t1 == S_DR) || (t1 == S_WR)) && (t2 == S_IWRRP1)) {
			if (t1 == S_WR) dst |= 0xD0;
			outab(0xB4); outab(opxt | (src | 1)); outab(dst);
			opcycles = 12; break;
		}
		/* R,-(rr) / r,-(rr) */
		if (((t1 == S_DR) || (t1 == S_WR)) && (t2 == S_IWRRM1)) {
			if (t1 == S_WR) dst |= 0xD0;
			outab(0xC2); outab(opxt | (src | 1)); outab(dst);
			opcycles = 12; break;
		}
		/* r,rr(rrx) */
		if ((t1 == S_WR) && (t2 == S_IWRRX)) {
			outab(0x60); outab(((e2.e_addr | 1) << 4) | (src | 0)); outab(opxt | dst);
			/* opcycles in table */ break;
		}
		/* R,N(rr) / r,N(rr) */
		if (((t1 == S_DR) || (t1 == S_WR)) && (t2 == S_IWRRNS)) {
			if (t1 == S_WR) dst |= 0xD0;
			outab(0x7F); outab(opxt | (src | 1)); outrb(&e2, R_SGND);
			outab(dst);
			opcycles = 12; break;
		}
		/* r,NN */
		if ((t1 == S_WR) && ((t2 == S_LONG) || (t2 == S_SHORT))) {
			outab(0xC4); outab(opxt | dst); outrw(&e2, 0);
			opcycles = 10; break;
		}
		/* R,NN(rr) / r,NN(rr) */
		if (((t1 == S_DR) || (t1 == S_WR)) && (t2 == S_IWRRNL)) {
			if (t1 == S_WR) dst |= 0xD0;
			outab(0x7F); outab(opxt | (src | 0));
			outrw(&e2, 0); outab(dst);
			opcycles = 14; break;
		}
		/*
		 * Memory,Register
		 */
		/* (rr),R / (rr),r */
		if ((t1 == S_IWRR) && ((t2 == S_DR) || (t2 == S_WR))) {
			if (t2 == S_WR) src |= 0xD0;
			outab(0x72); outab(opxt | (dst | 0)); outab(src);
			opcycles = (opxt <= 7) ? 12 : 10; break;
		}
		/* (rr)+,R / (rr)+,r */
		if ((t1 == S_IWRRP1) && ((t2 == S_DR) || (t2 == S_WR))) {
			if (t2 == S_WR) src |= 0xD0;
			outab(0xB4); outab(opxt | (dst | 0)); outab(src);
			opcycles = (opxt <= 7) ? 14 : 12; break;
		}
		/* -(rr),R / -(rr),r */
		if ((t1 == S_IWRRM1) && ((t2 == S_DR) || (t2 == S_WR))) {
			if (t2 == S_WR) src |= 0xD0;
			outab(0xC2); outab(opxt | (dst | 0)); outab(src);
			opcycles = (opxt <= 7) ? 14 : 12; break;
		}
		/* rr(rrx),r */
		if ((t1 == S_IWRRX) && (t2 == S_WR)) {
			outab(0x60); outab(((e1.e_addr | 1) << 4) | (dst | 1)); outab(opxt | src);
			opcycles = (opxt <= 7) ? 14 : 12; break;
		}
		/* N(rr),r / N(rr),R */
		if ((t1 == S_IWRRNS) && ((t2 == S_DR) || (t2 == S_WR))) {
			if (t2 == S_WR) src |= 0xD0;
			outab(0x26); outab(opxt | (dst | 1));
			outrb(&e1, R_SGND); outab(src);
			opcycles = (opxt <= 7) ? 14 : 12; break;
		}
		/* NN,r */
		if (((t1 == S_LONG) || (t1 == S_SHORT)) && (t2 == S_WR)) {
			outab(0xC5); outab(opxt | src); outrw(&e1, 0);
			opcycles = (opxt <= 7) ? 12 : 10; break;
		}
		/* NN(rr),R / NN(rr),r */
		if ((t1 == S_IWRRNL) && ((t2 == S_DR) || (t2 == S_WR))) {
			if (t2 == S_WR) src |= 0xD0;
			outab(0x26); outab(opxt | (dst | 0));
			outrw(&e1, 0); outab(src);
			opcycles = (opxt <= 7) ? 16 : 14; break;
		}
		/*
		 * Memeory,Memory
		 */
		/* (RR),(rr) / (rr),(rr) */
		if (((t1 == S_IDRR) || (t1 == S_IWRR)) && (t2 == S_IWRR)) {
			if (t1 == S_IWRR) dst |= 0xD0;
			outab(0x73); outab(opxt | (src | 0)); outab(dst | 0);
			opcycles = (opxt <= 7) ? 14 : 12; break;
		}
		/* R,#N / r,#N */
		if (((t1 == S_DR) | (t1 == S_WR)) && (t2 == S_IMM)) {
			if (t1 == S_WR) dst |= 0xD0;
			outab(opxt | 5); outab(dst); outrb(&e2, 0);
			opcycles = 6; break;
		}
		/* (rr),#N */
		if ((t1 == S_IWRR) && (t2 == S_IMM)) {
			outab(0xF3); outab(opxt | (dst | 0)); outrb(&e2, 0);
			opcycles = (opxt <= 7) ? 10 : 8; break;
		}
		/* NN,#NN */
		if (((t1 == S_LONG) || (t1 == S_SHORT)) && (t2 == S_IMM)) {
			outab(0x2F); outab(opxt | 1);
			outrb(&e2, 0); outrw(&e1, 0);
			opcycles = (opxt <= 7) ? 16 : 14; break;
		}
		aerr();
		break;

	/*
	 * mne  = ORW,  ANDW, SBCW, ADCW, ADDW, SUBW, XORW, TCMW, CPW,  TMW
         * opxt =  0     1     2     3     4     5     6     8     9     A 
	 */
	case I_TYP2:
		t1 = addr(&e1);
		dst  = aindx;
		comma(1);
		t2 = addr(&e2);
		src  = aindx;
		opxt = opcd & 0xF0;
		/*
		 * Register,Register
		 */
		/* rr,rr */
		if ((t1 == S_WRR) && (t2 == S_WRR)) {
			outab(opcd); outab(((dst | 0) << 4) | (src | 0));
			/* opcycles in table */ break;
		}
		/* RR,RR / rr,RR */
		if (((t1 == S_DRR) || (t1 == S_WRR)) && (t2 == S_DRR)) {
			if (t1 == S_WRR) dst |= 0xD0;
			outab(opxt | 7); outab(src | 0); outab(dst | 0);
			/* opcycles in table */ break;
		}
		/* RR,rr */
		if ((t1 == S_DRR) && (t2 == S_WRR)) {
			if (t2 == S_WRR) src |= 0xD0;
			outab(opxt | 7); outab(src | 0); outab(dst | 0);
			/* opcycles in table */ break;
		}
		/* (r),RR / (r),rr */
		if ((t1 == S_IWR) && ((t2 == S_DRR) || (t2 == S_WRR))) {
			if (t2 == S_WRR) src |= 0xD0;
			outab(0x96); outab(src | 0); outab(opxt | dst);
			opcycles = 10; break;
		}
		/* RR,(r) / rr,(r) */
		if (((t1 == S_DRR) || (t1 == S_WRR)) && (t2 == S_IWR)) {
			if (t1 == S_WRR) dst |= 0xD0;
			outab(0xA6); outab(opxt | src); outab(dst | 0);
			opcycles = 10; break;
		}
		/*
		 * Register,Memory
		 */
		/* rr,(rr) */
		if ((t1 == S_WRR) && (t2 == S_IWRR)) {
			outab(opxt | 0x0E); outab(((dst | 0) << 4) | (src | 1));
			opcycles = 12; break;
		}
		/* RR,(rr) */
		if ((t1 == S_DRR) && (t2 == S_IWRR)) {
			outab(0x7E); outab(opxt | (src | 0)); outab(dst | 0);
			opcycles = 12; break;
		}
		/* RR,(rr)+ / rr,(rr)+ */
		if (((t1 == S_DRR) || (t1 == S_WRR)) && (t2 == S_IWRRP1)) {
			if (t1 == S_WRR) dst |= 0xD0;
			outab(0xD5); outab(opxt | (src | 1)); outab(dst | 0);
			opcycles = 14; break;
		}
		/* RR,-(rr) / rr,-(rr) */
		if (((t1 == S_DRR) || (t1 == S_WRR)) && (t2 == S_IWRRM1)) {
			if (t1 == S_WRR) dst |= 0xD0;
			outab(0xC3); outab(opxt | (src | 1)); outab(dst | 0);
			opcycles = 14; break;
		}
		/* rr,rr(rrx) */
		if ((t1 == S_WRR) && (t2 == S_IWRRX)) {
			outab(0x60); outab(((e2.e_addr | 0) << 4) | (src | 0)); outab(opxt | (dst | 0));
			opcycles = 14; break;
		}
		/* RR,N(rr) / rr,N(rr) */
		if (((t1 == S_DRR) || (t1 == S_WRR)) && (t2 == S_IWRRNS)) {
			if (t1 == S_WRR) dst |= 0xD0;
			outab(0x86); outab(opxt | (src | 1));
			outrb(&e2, R_SGND); outab(dst | 0);
			opcycles = 14; break;
		}
		/* rr,NN */
		if ((t1 == S_WRR) && ((t2 == S_LONG) || (t2 == S_SHORT))) {
			outab(0xE2); outab(opxt | (dst | 0)); outrw(&e2, 0);
			opcycles = 14; break;
		}
		/* RR,NN(rr) / rr,NN(rr) */
		if (((t1 == S_DRR) || (t1 == S_WRR)) && (t2 == S_IWRRNL)) {
			if (t1 == S_WRR) dst |= 0xD0;
			outab(0x86); outab(opxt | (src | 0));
			outrw(&e2, 0); outab(dst | 0);
			opcycles = 16; break;
		}
		/*
		 * Memory,Register
		 */
		/* (rr),rr */
		if ((t1 == S_IWRR) && (t2 == S_WRR)) {
			outab(opxt | 0x0E); outab(((dst | 1) << 4) | (src | 0));
			opcycles = (opxt <= 7) ? 16 : 14; break;
		}
		/* (rr),RR */
		if ((t1 == S_IWRR) && (t2 == S_DRR)) {
			outab(0xBE); outab(opxt | (dst | 1)); outab(src | 0);
			opcycles = (opxt <= 7) ? 18 : 14; break;
		}
		/* (rr)+,R / (rr)+,r */
		if ((t1 == S_IWRRP1) && ((t2 == S_DRR) || (t2 == S_WRR))) {
			if (t2 == S_WRR) src |= 0xD0;
			outab(0xD5); outab(opxt | (dst | 0)); outab(src | 0);
			opcycles = (opxt <= 7) ? 18 : 14; break;
		}
		/* -(rr),RR / -(rr),rr */
		if ((t1 == S_IWRRM1) && ((t2 == S_DRR) || (t2 == S_WRR))) {
			if (t2 == S_WRR) src |= 0xD0;
			outab(0xC3); outab(opxt | (dst | 0)); outab(src | 0);
			opcycles = (opxt <= 7) ? 18 : 14; break;
		}
		/* rr(rrx),rr */
		if ((t1 == S_IWRRX) && (t2 == S_WRR)) {
			outab(0x60); outab(((e1.e_addr | 0) << 4) | (dst | 1)); outab(opxt | (src | 0));
			opcycles = (opxt <= 7) ? 18 : 14; break;
		}
		/* N(rr),RR / N(rr),rr */
		if ((t1 == S_IWRRNS) && ((t2 == S_DRR) || (t2 == S_WRR))) {
			if (t2 == S_WRR) src |= 0xD0;
			outab(0x86); outab(opxt | (dst | 1));
			outrb(&e1, R_SGND); outab(src | 1);
			opcycles = (opxt <= 7) ? 18 : 14; break;
		}
		/* NN,rr */
		if (((t1 == S_LONG) || (t1 == S_SHORT)) && (t2 == S_WRR)) {
			outab(0xE2); outab(opxt | (src | 1)); outrw(&e1, 0);
			opcycles = (opxt <= 7) ? 18 : 14; break;
		}
		/* NN(rr),RR / NN(rr),rr */
		if ((t1 == S_IWRRNL) && ((t2 == S_DRR) || (t2 == S_WRR))) {
			if (t2 == S_WRR) src |= 0xD0;
			outab(0x86); outab(opxt | (dst | 0));
			outrw(&e1, 0); outab(src | 1);
			opcycles = (opxt <= 7) ? 20 : 16; break;
		}
		/*
		 * Memeory,Memory
		 */
		/* (rr),(rr) */
		if ((t1 == S_IWRR) && (t2 == S_IWRR)) {
			outab(opxt | 0x0E); outab(((dst | 1) << 4) | (src | 1));
			opcycles = (opxt <= 7) ? 20 : 16; break;
		}
		/* RR,#NN / rr,#NN */
		if (((t1 == S_DRR) || (t1 == S_WRR)) && (t2 == S_IMM)) {
			if (t1 == S_WRR) dst |= 0xD0;
			outab(opxt | 0x07); outab(dst | 1); outrw(&e2, 0);
			opcycles = (opxt <= 7) ? 10 : 10; break;
		}
		/* (rr),#NN */
		if ((t1 == S_IWRR) && (t2 == S_IMM)) {
			outab(0xBE); outab(opxt | (dst | 0)); outrw(&e2, 0);
			opcycles = (opxt <= 7) ? 18 : 14; break;
		}
		/* N(rr),#NN */
		if ((t1 == S_IWRRNS) && (t2 == S_IMM)) {
			outab(0x06); outab(opxt | (dst | 1));
			outrb(&e1, 0); outrw(&e2, 0);
			opcycles = (opxt <= 7) ? 20 : 16; break;
		}
		/* NN(rr),#NN */
		if ((t1 == S_IWRRNL) && (t2 == S_IMM)) {
			outab(0x06); outab(opxt | (dst | 0));
			outrw(&e1, 0); outrw(&e2, 0);
			opcycles = (opxt <= 7) ? 22 : 18; break;
		}
		/* NN,#NN */
		if (((t1 == S_LONG) || (t1 == S_SHORT)) && (t2 == S_IMM)) {
			outab(0x36); outab(opxt | 1);
			outrw(&e2, 0); outrw(&e1, 0);
			opcycles = (opxt <= 7) ? 22 : 20; break;
		}
		aerr();
		break;

	/* LD */
	case I_LD:
		t1 = addr(&e1);
		dst  = aindx;
		comma(1);
		t2 = addr(&e2);
		src  = aindx;
		opxt = opcd & 0xF0;
		/*
		 * Register,Register
		 */
		/* r,R / r,r */
		if ((t1 == S_WR) && ((t2 == S_DR) || (t2 == S_WR))) {
			if (t2 == S_WR) { src |= 0xD0; opcycles = 6; }
			outab((dst << 4) | 0x08); outab(src);
			/* t2 == S_DR - opcycles in table */ break;
		}
		/* R,r */
		if ((t1 == S_DR) && (t2 == S_WR)) {
			outab((src << 4) | 0x09); outab(dst);
			/* opcycles in table */ break;
		}
		/* (r),r */
		if ((t1 == S_IWR) && (t2 == S_WR)) {
			outab(0xE6); outab((dst << 4) | src);
			/* opcycles in table */ break;
		}
		/* r,(r) */
		if ((t1 == S_WR) && (t2 == S_IWR)) {
			outab(0xE4); outab((dst << 4) | src);
			/* opcycles in table */ break;
		}
		/* (r),R */
		if ((t1 == S_IWR) && (t2 == S_DR)) {
			outab(0xE6); outab(src); outab(opxt | dst);
			opcycles = 6; break;
		}
		/* R,(r) */
		if ((t1 == S_DR) && (t2 == S_IWR)) {
			outab(0xE7); outab(opxt | src); outab(dst);
			opcycles = 6; break;
		}
		/* N(r),r */
		if ((t1 == S_IWRN) && (t2 == S_WR)) {
			if (t1 == S_WR) dst |= 0xD0;
			outab(0xB2); outab((src << 4) | dst); outrb(&e1, R_OVRF);
			opcycles = 6; break;
		}
		/* r,N(r) */
		if ((t1 == S_WR) && (t2 == S_IWRN)) {
			outab(0xB3); outab((dst << 4) | src); outrb(&e2, R_OVRF);
			opcycles = 6; break;
		}
		/* R,R */
		if ((t1 == S_DR) && (t2 == S_DR)) {
			outab(0xF4); outab(src); outab(dst);
			/* opcycles in table */ break;
		}
		/*
		 * Register,Memory
		 */
		/* r,(rr) */
		if ((t1 == S_WR) && (t2 == S_IWRR)) {
			outab(0xB5); outab((dst << 4) | (src | 0));
			opcycles = 8; break;
		}
		/* (r)+,(rr)+ */
		if ((t1 == S_IWRP1) && (t2 == S_IWRRP1)) {
			outab(0xD7); outab((dst << 4) | (src | 1));
			opcycles = 12; break;
		}
		/* R,(rr)+ / r,(rr)+ */
		if (((t1 == S_DR) || (t1 == S_WR)) && (t2 == S_IWRRP1)) {
			if (t1 == S_WR) dst |= 0xD0;
			outab(0xB4); outab(opxt | (src | 1)); outab(dst);
			opcycles = 12; break;
		}
		/* R,-(rr) / r,-(rr) */
		if (((t1 == S_DR) || (t1 == S_WR)) && (t2 == S_IWRRM1)) {
			if (t1 == S_WR) dst |= 0xD0;
			outab(0xC2); outab(opxt | (src | 1)); outab(dst);
			opcycles = 12; break;
		}
		/* R,(rr) */
		if ((t1 == S_DR) && (t2 == S_IWRR)) {
			outab(0x72); outab(opxt | (src | 1)); outab(dst);
			opcycles = 8; break;
		}
		/* r,rr(rrx) */
		if ((t1 == S_WR) && (t2 == S_IWRRX)) {
			outab(0x60); outab(((e2.e_addr | 1) << 4) | (src | 0)); outab(opxt | dst);
			opcycles = 12; break;
		}
		/* R,N(rr) / r,N(rr) */
		if (((t1 == S_DR) || (t1 == S_WR)) && (t2 == S_IWRRNS)) {
			if (t1 == S_WR) dst |= 0xD0;
			outab(0x7F); outab(opxt | (src | 1)); 
			outrb(&e2, R_SGND); outab(dst);
			opcycles = 12; break;
		}
		/* r,NN */
		if ((t1 == S_WR) && ((t2 == S_LONG) || (t2 == S_SHORT))) {
			outab(0xC4); outab(opxt | dst); outrw(&e2, 0);
			opcycles = 10; break;
		}
		/* R,NN(rr) / r,NN(rr) */
		if (((t1 == S_DR) || (t1 == S_WR)) && (t2 == S_IWRRNL)) {
			if (t1 == S_WR) dst |= 0xD0;
			outab(0x7F); outab(opxt | (src | 0)); outrw(&e2, 0);
			outab(dst);
			opcycles = 14; break;
		}
		/*
		 * Memory,Register
		 */
		/* (rr)+,(r)+ */
		if ((t1 == S_IWRRP1) && (t2 == S_IWRP1)) {
			outab(0xD7); outab((src << 4) | (dst | 0));
			opcycles = 12; break;
		}
		/* (rr),r */
		if ((t1 == S_IWRR) && (t2 == S_WR)) {
			outab(0xB5); outab((src << 4) | (dst | 1));
			opcycles = 8; break;
		}
		/* (rr)+,R / (rr)+,r */
		if ((t1 == S_IWRRP1) && ((t2 == S_DR) || (t2 == S_WR))) {
			if (t2 == S_WR) src |= 0xD0;
			outab(0xB4); outab(opxt | (dst | 0)); outab(src);
			opcycles = 12; break;
		}
		/* -(rr),R / -(rr),r */
		if ((t1 == S_IWRRM1) && ((t2 == S_DR) || (t2 == S_WR))) {
			if (t2 == S_WR) src |= 0xD0;
			outab(0xC2); outab(opxt | (dst | 0)); outab(src);
			opcycles = 12; break;
		}
		/* (rr),R */
		if ((t1 == S_IWRR) && (t2 == S_DR)) {
			outab(0x72); outab(opxt | (dst | 0)); outab(src);
			opcycles = 10; break;
		}
		/* rr(rrx),r */
		if ((t1 == S_IWRRX) && (t2 == S_WR)) {
			outab(0x60); outab(((e1.e_addr + 1) << 4) | (dst | 1)); outab(opxt | src);
			opcycles = 12; break;
		}
		/* N(rr),R / N(rr),r */
		if ((t1 == S_IWRRNS) && ((t2 == S_DR) || (t2 == S_WR))) {
			if (t2 == S_WR) src |= 0xD0;
			outab(0x26); outab(opxt | (dst | 1));
			outrb(&e1, R_OVRF); outab(src);
			opcycles = 12; break;
		}
		/* NN,r */
		if (((t1 == S_LONG) || (t1 == S_SHORT)) && (t2 == S_WR)) {
			outab(0xC5); outab(opxt | src); outrw(&e1, 0);
			opcycles = 10; break;
		}
		/* NN(rr),R / NN(rr),r */
		if ((t1 == S_IWRRNL) && ((t2 == S_DR) || (t2 == S_WR))) {
			if (t2 == S_WR) src |= 0xD0;
			outab(0x26); outab(opxt | (dst | 0));
			outrw(&e1, 0); outab(src);
			opcycles = 14; break;
		}
		/*
		 * Memeory,Memory
		 */
		/* (RR),(rr) / (rr),(rr) */
		if (((t1 == S_IDRR) || (t1 == S_IWRR)) && (t2 == S_IWRR)) {
			if (t1 == S_IWRR) dst |= 0xD0;
			outab(0x73); outab(opxt | (src | 0)); outab(dst | 0);
			opcycles = 10; break;
		}
		/* r,#N */
		if ((t1 == S_WR) && (t2 == S_IMM)) {
			outab((dst << 4) | 0x0C); outrb(&e2, 0);
			opcycles = 4; break;
		}
		/* R,#N */
		if ((t1 == S_DR) && (t2 == S_IMM)) {
			outab(0xF5); outab(dst); outrb(&e2, 0);
			opcycles = 6; break;
		}
		/* (rr),#N */
		if ((t1 == S_IWRR) && (t2 == S_IMM)) {
			outab(0xF3); outab(opxt | (dst | 0)); outrb(&e2, 0);
			opcycles = 8; break;
		}
		/* NN,#NN */
		if (((t1 == S_LONG) || (t1 == S_SHORT)) && (t2 == S_IMM)) {
			outab(0x2F); outab(opxt | 1);
			outrb(&e2, 0); 	outrw(&e1, 0);
			opcycles = 14; break;
		}
		aerr();
		break;

	/* LDW */
	case I_LDW:
		t1 = addr(&e1);
		dst  = aindx;
		comma(1);
		t2 = addr(&e2);
		src  = aindx;
		opxt = opcd & 0xF0;
		/*
		 * Register,Register
		 */
		/* rr,rr */
		if ((t1 == S_WRR) && (t2 == S_WRR)) {
			outab(0xE3); outab(((dst | 0) << 4) | (src | 0));
			opcycles = 6; break;
		}
		/* (r),RR / (r),rr */
		if ((t1 == S_IWR) && ((t2 == S_DRR) || (t2 == S_WRR))) {
			if (t2 == S_WRR) src |= 0xD0;
			outab(0x96); outab(src | 0); outab(opxt | dst);
			opcycles = 6; break;
		}
		/* RR,(r) / rr,(r) */
		if (((t1 == S_DRR) || (t1 == S_WRR)) && (t2 == S_IWR)) {
			if (t1 == S_WRR) dst |= 0xD0;
			outab(0xA6); outab(opxt | src); outab(dst | 0);
			opcycles = 8; break;
		}
		/* N(r),rr */
		if ((t1 == S_IWRN) && (t2 == S_WRR)) {
			outab(0xDE); outab(((src | 1) << 4) | dst);
			outrb(&e1, R_OVRF);
			opcycles = 10; break;
		}
		/* rr,N(r) */
		if ((t1 == S_WRR) && (t2 == S_IWRN)) {
			outab(0xDE); outab(((dst | 0) << 4) | src);
			outrb(&e2, R_OVRF);
			opcycles = 8; break;
		}
		/* RR,RR / rr,RR */
		if (((t1 == S_DRR) || (t1 == S_WRR)) && (t2 == S_DRR)) {
			if (t1 == S_WRR) dst |= 0xD0;
			outab(0xEF); outab(src | 0); outab(dst | 0);
			opcycles = 6; break;
		}
		/* RR,rr */
		if ((t1 == S_DRR) && (t2 == S_WRR)) {
			if (t2 == S_WRR) src |= 0xD0;
			outab(0xEF); outab(src | 0); outab(dst | 0);
			opcycles = 6; break;
		}
		/*
		 * Register,Memory
		 */
		/* rr,(rr) */
		if ((t1 == S_WRR) && (t2 == S_IWRR)) {
			outab(0xE3); outab((dst << 4) | (src | 1));
			opcycles = 10; break;
		}
		/* RR,(rr)+ / rr,(rr)+ */
		if (((t1 == S_DRR) || (t1 == S_WRR)) && (t2 == S_IWRRP1)) {
			if (t1 == S_WRR) dst |= 0xD0;
			outab(0xD5); outab(opxt | (src | 1)); outab(dst | 0);
			opcycles = 14; break;
		}
		/* RR,-(rr) / rr,-(rr) */
		if (((t1 == S_DRR) || (t1 == S_WRR)) && (t2 == S_IWRRM1)) {
			if (t1 == S_WRR) dst |= 0xD0;
			outab(0xC3); outab(opxt | (src | 1)); outab(dst | 0);
			opcycles = 14; break;
		}
		/* RR,(rr) */
		if ((t1 == S_DRR) && (t2 == S_IWRR)) {
			outab(0x7E); outab(opxt | (src | 0)); outab(dst | 0);
			opcycles = 10; break;
		}
		/* rr,rr(rrx) */
		if ((t1 == S_WRR) && (t2 == S_IWRRX)) {
			outab(0x60); outab(((e2.e_addr | 0) << 4) | (src | 0)); outab(opxt | (dst | 0));
			opcycles = 14; break;
		}
		/* RR,N(rr) / rr,N(rr) */
		if (((t1 == S_DRR) || (t1 == S_WRR)) && (t2 == S_IWRRNS)) {
			if (t1 == S_WRR) dst |= 0xD0;
			outab(0x86); outab(opxt | (src | 1));
			outrb(&e2, R_SGND); outab(dst);
			opcycles = 14; break;
		}
		/* rr,NN */
		if ((t1 == S_WRR) && ((t2 == S_LONG) || (t2 == S_SHORT))) {
			outab(0xE2); outab(opxt | (dst | 0)); outrw(&e2, 0);
			opcycles = 12; break;
		}
		/* RR,NN(rr) / rr,NN(rr) */
		if (((t1 == S_DRR) || (t1 == S_WRR)) && (t2 == S_IWRRNL)) {
			if (t1 == S_WRR) dst |= 0xD0;
			outab(0x86); outab(opxt | (src | 0));
			outrw(&e2, 0); outab(dst | 0);
			opcycles = 16; break;
		}
		/*
		 * Memory,Register
		 */
		/* (rr),rr */
		if ((t1 == S_IWRR) && (t2 == S_WRR)) {
			outab(0xE3); outab(((dst | 1) << 4) | (src | 0));
			opcycles = 12; break;
		}
		/* (rr)+,R / (rr)+,r */
		if ((t1 == S_IWRRP1) && ((t2 == S_DRR) || (t2 == S_WRR))) {
			if (t2 == S_WRR) src |= 0xD0;
			outab(0xD5); outab(opxt | (dst | 0)); outab(src | 0);
			opcycles = 14; break;
		}
		/* -(rr),RR / -(rr),rr */
		if ((t1 == S_IWRRM1) && ((t2 == S_DRR) || (t2 == S_WRR))) {
			if (t2 == S_WRR) src |= 0xD0;
			outab(0xC3); outab(opxt | (dst | 0)); outab(src | 0);
			opcycles = 14; break;
		}
		/* (rr),RR */
		if ((t1 == S_IWRR) && (t2 == S_DRR)) {
			outab(0xBE); outab(opxt | (dst | 1)); outab(src | 0);
			opcycles = 12; break;
		}
		/* rr(rrx),rr */
		if ((t1 == S_IWRRX) && (t2 == S_WRR)) {
			outab(0x60); outab(((e1.e_addr | 0) << 4) | (dst | 1)); outab(opxt | (src | 0));
			opcycles = 14; break;
		}
		/* N(rr),RR / N(rr),rr */
		if ((t1 == S_IWRRNS) && ((t2 == S_DRR) || (t2 == S_WRR))) {
			if (t2 == S_WRR) src |= 0xD0;
			outab(0x86); outab(opxt | (dst | 1));
			outrb(&e1, R_SGND); outab(src | 1);
			opcycles = 14; break;
		}
		/* NN,rr */
		if (((t1 == S_LONG) || (t1 == S_SHORT)) && (t2 == S_WRR)) {
			outab(0xE2); outab(opxt | (src | 1)); outrw(&e1, 0);
			opcycles = 14; break;
		}
		/* NN(rr),RR / NN(rr),rr */
		if ((t1 == S_IWRRNL) && ((t2 == S_DRR) || (t2 == S_WRR))) {
			if (t2 == S_WRR) src |= 0xD0;
			outab(0x86); outab(opxt | (dst | 0));
			outrw(&e1, 0); outab(src | 1);
			opcycles = 16; break;
		}
		/*
		 * Memeory,Memory
		 */
		/* (rr),(rr) */
		if ((t1 == S_IWRR) && (t2 == S_IWRR)) {
			outab(0xE3); outab(((dst | 1) << 4) | (src | 1));
			opcycles = 16; break;
		}
		/* RR,#NN / rr,#NN */
		if (((t1 == S_DRR) || (t1 == S_WRR)) && (t2 == S_IMM)) {
			if (t1 == S_WRR) dst |= 0xD0;
			outab(0xBF); outab(dst | 0); outrw(&e2, 0);
			opcycles = 8; break;
		}
		/* (rr),#NN */
		if ((t1 == S_IWRR) && (t2 == S_IMM)) {
			outab(0xBF); outab(opxt | dst | 0); outrw(&e2, 0);
			opcycles = 14; break;
		}
		/* N(rr),#NN */
		if ((t1 == S_IWRRNS) && (t2 == S_IMM)) {
			outab(0x06); outab(opxt | (dst | 1));
			outrb(&e1, 0); outrw(&e2, 0); outab(src | 1);
			opcycles = 18; break;
		}
		/* NN(rr),#NN */
		if ((t1 == S_IWRRNL) && (t2 == S_IMM)) {
			outab(0x06); outab(opxt | (dst | 0));
			outrw(&e1, 0); outrw(&e2, 0); outab(src | 1);
			opcycles = 20; break;
		}
		/* NN,#NN */
		if (((t1 == S_LONG) || (t1 == S_SHORT)) && (t2 == S_IMM)) {
			outab(0x36); outab(opxt | 1);
			outrw(&e2, 0); outrw(&e1, 0);
			opcycles = 18; break;
		}
		aerr();
		break;

	/* BCPL, BRES, BSET, BTSET */
	case I_BCPL:
	case I_BRES:
	case I_BSET:
	case I_BTSET:
		t1 = addr_b(&e1);
		dst  = aindx;
		if (t1 == S_WRB) {
			outab(opcd); outrbm(&e1, M_BXXX | R_OVRF, 0x00 | dst | 0);
			opcycles = (rf == I_BTSET) ? 8 : 4; break;
		}
		if ((rf == I_BTSET) && (t1 == S_IWRRB)) {
			outab(0xF6); outrbm(&e1, M_BXXX | R_OVRF, 0x00 | dst | 0);
			opcycles = 14; break;
		}
		aerr();
		break;
			
	/* BAND, BLD, BOR, BXOR */
	case I_BAND:
	case I_BLD:
	case I_BOR:
	case I_BXOR:
		t1 = addr_b(&e1);
		dst = aindx;
		comma(1);
		t2 = addr_b(&e2);
		src  = aindx;
		if ((t1 == S_WRB) && (t2 == S_WRB)) {
			outab(opcd);
			if (rf == I_BAND) {
				outrbm(&e1, M_BXXX | R_OVRF, 0x10 | dst);
				outrbm(&e2, M_BXXX | R_OVRF, 0x10 | src);
			}
			if (rf == I_BLD) {
				outrbm(&e2, M_BXXX | R_OVRF, 0x10 | src);
				outrbm(&e1, M_BXXX | R_OVRF, 0x00 | dst);
			}
			if ((rf == I_BOR) || (rf == I_BXOR)) {
				outrbm(&e1, M_BXXX | R_OVRF, 0x10 | dst);
				outrbm(&e2, M_BXXX | R_OVRF, 0x00 | src);
			}
			/* opcycles in table */ break;
		}
		if ((t1 == S_WRB) && (t2 == S_WRBC)) {
			outab(opcd);
			if (rf == I_BAND) {
				outrbm(&e1, M_BXXX | R_OVRF, 0x10 | dst);
				outrbm(&e2, M_BXXX | R_OVRF, 0x00 | src);
			}
			if (rf == I_BLD) {
				outrbm(&e2, M_BXXX | R_OVRF, 0x10 | src);
				outrbm(&e1, M_BXXX | R_OVRF, 0x10 | dst);
			}
			if ((rf == I_BOR) || (rf == I_BXOR)) {
				outrbm(&e1, M_BXXX | R_OVRF, 0x10 | dst);
				outrbm(&e2, M_BXXX | R_OVRF, 0x10 | src);
			}
			/* opcycles in table */ break;
		}
		aerr();
		break;

	case I_BTJF:
	case I_BTJT:
		t1 = addr_b(&e1);
		src = aindx;
		comma(1);
		expr(&e2);
		if (t1 != S_WRB) {
			xerr('a', "Only r.b Allowed");
 		        break;
		}
		outab(opcd);
		if (rf == I_BTJF) outrbm(&e1, M_BXXX | R_OVRF, 0x10 | src);
		if (rf == I_BTJT) outrbm(&e1, M_BXXX | R_OVRF, 0x00 | src);
		if (mchpcr(&e2, &ofst, 1)) {
			if ((ofst < -128) || (ofst > 127))
				xerr('a', "Short Relative Address Is Out Of Range");
			outab(ofst);
		} else {
			outrb(&e2, R_PCR);
		}
		if (e2.e_mode != S_USER)
			rerr();
		/* opcycles in table */ break;

	case I_CALL:
		t1 = addr(&e1);
		dst = aindx;
		if (t1 == S_IDRR) { outab(opcd); outab(dst | 1);
			/* opcycles in table */ break;
		}
		if (t1 == S_IWRR) { outab(opcd); outab((dst | 1) | 0xD0); break; }
		if ((t1 == S_LONG) || (t1 == S_SHORT)) {
			outab(0xD2); outrw(&e1, 0);
			/* opcycles in table */ break;
		}
		aerr();
		break;

	case I_CALLS:
		t1 = addr(&e1);
		seg = aindx;
		comma(1);
		t2 = addr(&e2);
		dst = aindx;
		if (((t1 == S_LONG) || (t1 == S_SHORT)) && ((t2 == S_LONG) || (t2 == S_SHORT))) {
			outab(0x3F); outrbm(&e1, M_SEG | R_MBRO, 0x40); outrw(&e2, 0);
			/* opcycles in table */ break;
		}
		if (((t1 == S_IDR) || (t1 == S_IWR)) && (t2 == S_IWRR)) {
			if (t1 == S_IWR)  seg |= 0xD0;
			if (t2 == S_IWRR) dst |= 0xD0;
			outab(0x73); outab(dst | 1); outab(seg);
			/* opcycles in table */break;
		}
		aerr();
		break;

	case I_CLR:
	case I_CPL:
	case I_DA:
	case I_DEC:
	case I_INC:
	case I_POP:
	case I_POPU:
	case I_RLC:
	case I_ROL:
	case I_ROR:
	case I_RRC:
	case I_SRA:
	case I_SWAP:
		t1 = addr(&e1);
		dst = aindx;
		if ((t1 == S_DR) || (t1 == S_IDR)) {
			if (t1 == S_IDR) opcd += 1;
			outab(opcd); outab(dst);
			/* opcycles in table */ break;
		}
		if ((t1 == S_WR) || (t1 == S_IWR)) {
			dst |= 0xD0;
			if (t1 == S_IWR) opcd += 1;
			outab(opcd); outab(dst);
			/* opcycles in table */ break;
		}
		aerr();
		break;

	case I_CPJFI:
	case I_CPJTI:
		t1 = addr(&e1);
		dst = aindx;
		comma(1);
		t2 = addr(&e2);
		src = aindx;
		comma(1);
		expr(&e3);
		if ((t1 == S_WR) && (t2 == S_IWRR)) {
			outab(opcd);
			if (rf == I_CPJFI) outab(((src | 0) << 4) | dst);
			if (rf == I_CPJTI) outab(((src | 1) << 4) | dst);
			if (mchpcr(&e3, &ofst, 1)) {
				if ((ofst < -128) || (ofst > 127))
					xerr('a', "Short Relative Address Is Out Of Range");
				outab(ofst);
			} else {
				outrb(&e3, R_PCR);
			}
			if (e3.e_mode != S_USER)
				rerr();
			/* opcycles in table */ break;
		}
		aerr();
		break;

	case I_DECW:
	case I_INCW:
	case I_RLCW:
	case I_RRCW:
	case I_SRAW:
		t1 = addr(&e1);
		dst = aindx;
		if ((t1 == S_DRR) || (t1 == S_WRR)) {
			if (t1 == S_WRR) dst |= 0xD0;
			outab(opcd); outab(dst | 0);
			if (rf == I_RLCW) opcycles = 8;
			/* ELSE opcycles in table */ break;
		}
		aerr();
		break;

	case I_DIV:
		t1 = addr(&e1);
		dst = aindx;
		comma(1);
		t2 = addr(&e2);
		src = aindx;
		if ((t1 == S_WRR) || (t2 == S_WR)) {
			outab(opcd); outab(((dst | 0) << 4) | src);
			/* opcycles in table */ break;
		}
		aerr();
		break;

	case I_DIVWS:
		t1 = addr(&e1);
		dsh = aindx;
		comma(1);
		t2 = addr(&e2);
		dsl = aindx;
		comma(1);
		t3 = addr(&e3);
		src = aindx;
		if ((t1 == S_WRR) && (t2 == S_WRR) && ((t3 == S_DRR) || (t3 == S_WRR))) {
			if (t3 == S_WRR) src |= 0xD0;
			outab(opcd); outab(src | 0); outab(((dsh | 0) << 4) | (dsl | 0));
			/* opcycles in table */ break;
		}
		aerr();
		break;

	case I_DJNZ:
		t1 = addr(&e1);
		dst = aindx;
		comma(1);
		expr(&e2);
		if (t1 == S_WR) {
			outab((dst << 4) | opcd);
			if (mchpcr(&e2, &ofst, 1)) {
				if ((ofst < -128) || (ofst > 127))
					xerr('a', "Short Relative Address Is Out Of Range");
				outab(ofst);
			} else {
				outrb(&e2, R_PCR);
			}
			if (e2.e_mode != S_USER)
				rerr();
			/* opcycles in table */ break;
		}
		aerr();
		break;

	case I_DWJNZ:
		t1 = addr(&e1);
		dst = aindx;
		comma(1);
		expr(&e2);
		if ((t1 == S_DRR) || (t1 == S_WRR)) {
			if (t1 == S_WRR) dst |= 0xD0;
			outab(opcd); outab(dst | 0);
			if (mchpcr(&e2, &ofst, 1)) {
				if ((ofst < -128) || (ofst > 127))
					xerr('a', "Short Relative Address Is Out Of Range");
				outab(ofst);
			} else {
				outrb(&e2, R_PCR);
			}
			if (e2.e_mode != S_USER)
				rerr();
			/* opcycles in table */ break;
		}
		aerr();
		break;

	case I_EXT:
		t1 = addr(&e1);
		dst = aindx;
		if ((t1 == S_DRR) || (t1 == S_WRR)) {
			if (t1 == S_WRR) dst |= 0xD0;
			outab(opcd); outab(dst | 1);
			opcycles = 6; break;
		}
		aerr();
		break;

	case I_HALT:
		outab(opcd); outab(0x01);
		opcycles = 99; break;

	case I_INH:
		outab(opcd);
		/* opcycles in table */ break;

	/* JP */
	case I_JP:
		t1 = addr(&e1);
		dst = aindx;
		if ((t1 == S_IDRR) || (t1 == S_IWRR)) {
			if (t1 == S_IWRR) dst |= 0xD0;
			outab(opcd); outab(dst | 0);
			/* opcycles in table */ break;
		}
		if ((t1 == S_LONG) || (t1 == S_SHORT)) {
			outab(0x8D); outrw(&e1, 0);
			/* opcycles in table */ break;
		}
		aerr();
		break;

	/* JPS */
	case I_JPS:
		t1 = addr(&e1);
		seg = aindx;
		comma(1);
		t2 = addr(&e2);
		dst = aindx;
		if (((t1 == S_IDR) || (t1 == S_IWR)) && (t2 == S_IWRR)) {
			if (t1 == S_IWR) seg |= 0xD0;
			outab(opcd); outab(0xC0 | (dst | 1)); outab(seg); 
			opcycles = 10; break;
		}
		if (((t1 == S_LONG) || (t1 == S_SHORT)) && ((t2 == S_LONG) || (t2 == S_SHORT))) {
			outab(0x3F); outrbm(&e1, M_SEG | R_MBRO, 0xC0); outrw(&e2, 0);
			opcycles = 10; break;
		}
		aerr();
		break;

	/* JPcc */
	case I_JPCC:
		expr(&e1);
		outab(opcd); outrw(&e1, 0);
		/* opcycles in table */ break;

	/* JRcc */
	case I_JRCC:
		expr(&e1);
		outab(opcd);
		if (mchpcr(&e1, &ofst, 1)) {
			if ((ofst < -128) || (ofst > 127))
				xerr('a', "Short Relative Address Is Out Of Range");
			outab(ofst);
		} else {
			outrb(&e1, R_PCR);
		}
		if (e1.e_mode != S_USER)
			rerr();
		/* opcycles in table */break;

	case I_LDPP:
	case I_LDDP:
	case I_LDPD:
	case I_LDDD:
		t1 = addr(&e1);
		dst = aindx;
		comma(1);
		t2 = addr(&e2);
		src = aindx;
		if ((t1 == S_IWRRP1) && (t2 == S_IWRRP1)) {
			outab(opcd);
			if (rf == I_LDPP) { outab(((dst | 0) << 4) | (src | 0)); break; }
			if (rf == I_LDDP) { outab(((dst | 1) << 4) | (src | 0)); break; }
			if (rf == I_LDPD) { outab(((dst | 0) << 4) | (src | 1)); break; }
			if (rf == I_LDDD) { outab(((dst | 1) << 4) | (src | 1)); break; }
			/* opcycles in table */
		}
		aerr();
		break;

	case I_LINK:
	case I_LINKU:
		t1 = addr(&e1);
		dst = aindx;
		comma(1);
		expr(&e2);
		if ((t1 == S_DRR) || (t1 == S_WRR)) {
			if (t1 == S_WRR) dst |= 0xD0;
			outab(opcd); outab (dst | 1);
			outrb(&e2, R_OVRF);
			opcycles = 16; break;
		}
		aerr();
		break;

	case I_MUL:
		t1 = addr(&e1);
		dst = aindx;
		comma(1);
		t2 = addr(&e2);
		src = aindx;
		if ((t1 == S_WRR) && (t2 == S_WR)) {
			outab(opcd); outab(((dst | 0) << 4) | src);
			/* opcycles in table */ break;
		}
		aerr();
		break;

	case I_PEA:
	case I_PEAU:
		t1 = addr(&e1);
		src = aindx;
		if ((t1 == S_IDRRNS) || (t1 == S_IWRRNS)) {
			if (t1 == S_IWRRNS) src |= 0xD0;
			outab(opcd);
			if (rf == I_PEA)  outab(0x01);	/* PEA  Rn / PEA  rn */
			if (rf == I_PEAU) outab(0x03);	/* PEAU Rn / PEAU rn */
			outab(src | 0); outrb(&e1, R_OVRF);
			opcycles = 20; break;
		}
		if ((t1 == S_IDRRNL) || (t1 == S_IWRRNL)) {
			if (t1 == S_IWRRNL) src |= 0xD0;
			outab(opcd);
			if (rf == I_PEA)  outab(0x01);	/* PEA  (Rn) / PEA  (rn) */
			if (rf == I_PEAU) outab(0x03);	/* PEAU (Rn) / PEAU (rn) */
			outab(src | 1); outrw(&e1, 0);
			opcycles = 22; break;
		}
		aerr();
		break;

	case I_POPUW:
	case I_POPW:
		t1 = addr(&e1);
		dst = aindx;
		if ((t1 == S_DRR) || (t1 == S_WRR)) {
			if (t1 == S_WRR) dst |= 0xD0;
			if (rf == I_POPUW) {
				outab(0xB7); outab(dst | 0);
				opcycles = 10; break;
			}
			if (rf == I_POPW) {
				outab(0x75); outab(dst | 0);
				opcycles = 10; break;
			}
		}
		aerr();
		break;

	case I_PUSH:
	case I_PUSHU:
		t1 = addr(&e1);
		src = aindx;
		if ((t1 == S_DR) || (t1 == S_WR)) {
			if (t1 == S_WR) src |= 0xD0;
			if (rf == I_PUSH)  outab(0x66);	/* PUSH  Rn / PUSH  rn */
			if (rf == I_PUSHU) outab(0x30);	/* PUSHU Rn / PUSHU rn */
			outab(src); opcycles = 8; break;
		}
		if ((t1 == S_IDR) || (t1 == S_IWR)) {
			if (t1 == S_IWR) src |= 0xD0;
			if (rf == I_PUSH)  outab(0xF7);	/* PUSH  (Rn) / PUSH  (rn) */
			if (rf == I_PUSHU) outab(0x31);	/* PUSHU (Rn) / PUSHU (rn) */
			outab(src); opcycles = 8; break;
		}
		if (t1 == S_IMM) {
			outab(0xBF);
			if (rf == I_PUSH)  outab(0xF1);	/* PUSH  #N */
			if (rf == I_PUSHU) outab(0xF3);	/* PUSHU #N */
			outrb(&e1, R_OVRF); opcycles = 12; break;
		}
		aerr();
		break;

	case I_PUSHUW:
	case I_PUSHW:
		t1 = addr(&e1);
		src = aindx;
		if ((t1 == S_DRR) | (t1 == S_WRR)) {
			if (t1 == S_WRR) src |= 0xD0;
			outab(opcd); outab(src | 0);
			opcycles = 10; break;
		}
		if (t1 == S_IMM) {
			outab(0xBF);
			if (rf == I_PUSHUW) outab(0xC3);
			if (rf == I_PUSHW)  outab(0xC1);
			outrw(&e1, 0);
			opcycles = 16; break;
		}
		aerr();
		break;

	case I_RETS:
		outab(opcd); outab(0x01);
		/* opcycles in table */ break;

	case I_SLA:
		t1 = addr(&e1);
		dst = aindx;
		if (t1 == S_WR) { outab(opcd); outab((dst << 4) | dst); break; }
		if (t1 == S_DR) { outab(opcd + 2); outab(dst); outab(dst); break; }
		if (t1 == S_IWRR) {
			outab(0x73); outab(0x40 | (dst | 0)); outab(0xD0 | (dst | 0));
			opcycles = 14; break;
		}
		aerr();
		break;

	case I_SLAW:
		t1 = addr(&e1);
		dst = aindx;
		if (t1 == S_WRR) { outab(opcd); outab((dst << 4) | dst); break; }
		if (t1 == S_DRR) { outab(0x47); outab(dst | 0); outab(dst | 0); break; }
		if (t1 == S_IWRR) {
			dst |= 0xD0;
			outab(opcd); outab(dst | 1); outab(dst | 1);
			opcycles = 20; break;
		}
		aerr();
		break;

	case I_SPP:
		t1 = addr(&e1);
		dst = aindx;
		if (t1 == S_IMM) {
			outab(opcd); outrbm(&e1, M_SPP | R_OVRF, 0x02);
			/* opcycles in table */ break;
		}
		aerr();
		break;

	case I_SRP:
	case I_SRP0:
	case I_SRP1:
		t1 = addr(&e1);
		src = aindx;
		if (t1 == S_IMM) {
			outab(opcd);
			if (rf == I_SRP)  { outrbm(&e1, M_SRP | R_OVRF, 0x00); break; }
			if (rf == I_SRP0) { outrbm(&e1, M_SRP | R_OVRF, 0x04); break; }
			if (rf == I_SRP1) { outrbm(&e1, M_SRP | R_OVRF, 0x05); break; }
			/* opcycles in table */
		}
		aerr();
		break;

	case I_UNLINK:
	case I_UNLINKU:
		t1 = addr(&e1);
		dst = aindx;
		if ((t1 == S_DRR) || (t1 == S_WRR)) {
			if (t1 == S_WRR) dst |= 0xD0;
			outab(opcd); outab(dst | 1);
			opcycles = 10; break;
		}
		aerr();
		break;

	case I_WFI:
		outaw(0xEF01);
		/* opcycles in table */ break;

	case I_XCH:
		t1 = addr(&e1);
		dst = aindx;
		comma(1);
		t2 = addr(&e2);
		src = aindx;
		if ((t1 == S_DR) && ((t2 == S_DR) | (t2 == S_WR))) {
			if (t2 == S_WR) src |= 0xD0;
			outab(opcd); outab(src); outab(dst);
			/* opcycles in table */ break;
		}
		if ((t1 == S_WR) && ((t2 == S_DR) | (t2 == S_WR))) {
			dst |= 0xD0;
			if (t2 == S_WR) src |= 0xD0;
			outab(opcd); outab(src); outab(dst);
			/* opcycles in table */ break;
		}
		aerr();
		break;

	default:
		opcycles = OPCY_ERR;
		xerr('o', "Internal Opcode Error.");
		break;
	}

	if (opcycles == OPCY_NONE) {
		opcycles = st9cyc[cb[0] & 0xFF];
	}
	/*
	 * Translate To External Format
	 */
	if (opcycles == OPCY_NONE) { opcycles  =  CYCL_NONE; } else
	if (opcycles  & OPCY_NONE) { opcycles |= (CYCL_NONE | 0x3F00); }
}

/*
 * Return 1 if the absolute value is not
 * a valid unsigned or signed value.
 * Else return 0.
 */
int
valu_err(e, n)
struct expr *e;
int n;
{
	a_uint v;

	if (is_abs(e)) {
		v = e->e_addr;
		switch(n) {
		default:
#ifdef	LONGINT
		case 1:	if ((v & ~0x000000FFl) && ((v & ~0x000000FFl) != ~0x000000FFl)) return(1);
		case 2:	if ((v & ~0x0000FFFFl) && ((v & ~0x0000FFFFl) != ~0x0000FFFFl)) return(1);
		case 3:	if ((v & ~0x00FFFFFFl) && ((v & ~0x00FFFFFFl) != ~0x00FFFFFFl)) return(1);
		case 4:	if ((v & ~0xFFFFFFFFl) && ((v & ~0xFFFFFFFFl) != ~0xFFFFFFFFl)) return(1);
#else
		case 1:	if ((v & ~0x000000FF) && ((v & ~0x000000FF) != ~0x000000FF)) return(1);
		case 2:	if ((v & ~0x0000FFFF) && ((v & ~0x0000FFFF) != ~0x0000FFFF)) return(1);
		case 3:	if ((v & ~0x00FFFFFF) && ((v & ~0x00FFFFFF) != ~0x00FFFFFF)) return(1);
		case 4:	if ((v & ~0xFFFFFFFF) && ((v & ~0xFFFFFFFF) != ~0xFFFFFFFF)) return(1);
#endif
		}
	}
	return(0);
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
 * Machine specific initialization.
 */
void
minit(void)
{
	/*
	 * Byte Order
	 */
	hilo = 1;

	/*
	 * Multi-pass Processing
	 */
	passlmt = 10;	/* Maximum Pass 1 Loops */
}

