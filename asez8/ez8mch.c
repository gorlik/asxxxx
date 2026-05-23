/* ez8mch.c */

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
#include "ez8.h"

char	*cpu	= "Zilog eZ8";
char	*dsft	= "asm";

char	imtab[3] = { 0x46, 0x56, 0x5E };
int	hd64;

/*
 * Opcode Cycle Definitions
 */
#define	OPCY_SDP	((char) (0xFF))
#define	OPCY_ERR	((char) (0xFE))

#define	OPCY_NONE	((char) (0x80))
#define	OPCY_MASK	((char) (0x7F))

#define	UN	((char) (OPCY_NONE | 0x00))
#define	P2	((char) (OPCY_NONE | 0x01))

/*
 * Z8 Opcode Cycle Pages
 */

static char  ez8pg1[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   2, 2, 3, 4, 3, 4, 3, 4, 4, 4, 3, 2, 2, 3, 2, 2,
/*10*/   2, 3, 3, 4, 3, 4, 3, 4, 4, 4, 3, 2, 2, 3, 2,P2,
/*20*/   2, 3, 3, 4, 3, 4, 3, 4, 4, 4, 3, 2, 2, 3, 2, 2,
/*30*/   2, 3, 3, 4, 3, 4, 3, 4, 4, 4, 3, 2, 2, 3, 2, 2,
/*40*/   2, 3, 3, 4, 3, 4, 3, 4, 4, 4, 3, 2, 2, 3, 2, 2,
/*50*/   2, 3, 3, 4, 3, 4, 3, 4, 4, 4, 3, 2, 2, 3, 2, 2,
/*60*/   2, 3, 3, 4, 3, 4, 3, 4, 4, 4, 3, 2, 2, 3, 2, 2,
/*70*/   2, 3, 3, 4, 3, 4, 3, 4, 4, 4, 3, 2, 2, 3, 2, 2,
/*80*/   5, 6, 5, 9, 3, 3, 4, 5, 4, 4, 3, 2, 2, 3, 2, 2,
/*90*/   2, 3, 5, 9, 3, 3, 4, 5, 4, 4, 3, 2, 2, 3, 2, 2,
/*A0*/   5, 6, 3, 4, 3, 4, 3, 4, 4, 4, 3, 2, 2, 3, 2, 2,
/*B0*/   2, 3, 3, 4, 3, 4, 3, 4, 4, 4, 3, 2, 2, 3, 2, 2,
/*C0*/   2, 3, 5, 9, 3, 9,UN, 3, 3,UN, 3, 2, 2, 3, 2, 2,
/*D0*/   2, 3, 5, 9, 6, 2, 3, 4, 3,UN, 3, 2, 2, 3, 2, 2,
/*E0*/   2, 3, 2, 3, 3, 3, 3, 3, 4, 4, 3, 2, 2, 3, 2, 2,
/*F0*/   2, 3, 6, 3, 8, 3, 3, 4,UN,UN, 3, 2, 2, 3, 2, 2
};

static char  ez8pg2[256] = {  /* P2 == 1F */
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*10*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*20*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*30*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*40*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*50*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*60*/  UN,UN,UN,UN,12,15,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*70*/   3,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*80*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*90*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*A0*/  UN,UN, 3, 4, 4, 4, 4, 4, 5, 5,UN,UN,UN,UN,UN,UN,
/*B0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*C0*/   3, 3,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*D0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,
/*E0*/  UN,UN,UN,UN,UN,UN,UN,UN, 5,UN,UN,UN,UN,UN,UN,UN,
/*F0*/  UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN,UN
};

static char *ez8Page[2] = {
    ez8pg1, ez8pg2
};

static int odd;
static int ovr;
static int l_ovrf;

/*
 * Process a machine op.
 */
void
machine(struct mne *mp)
{
	int op, t1, t2, t3;
	struct expr e1, e2, e3, e4;
	int rf, v1, v2, v3, v4;
	int fg, a1, a2;

	/*
	 * Using Internal Format
	 * For Cycle Counting
	 */
	opcycles = OPCY_NONE;

	clrexpr(&e1);
	clrexpr(&e2);
	clrexpr(&e3);
	clrexpr(&e4);
	op = (int) mp->m_valu;
	fg = mp->m_flag;
	rf = mp->m_type;
	switch (rf) {

	case S_INC:
	case S_SOP:
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		a1 = is_abs(&e1);
		if (fg) outab(fg);
		if ((t1 == S_IMMED) & (op == 0x70)) {	/* push # */
			outab(O_PG2);
			outab(op);
			outrb(&e1, 0);	/* No Check on # */
		} else
		if (t1 == S_R) {			/* op   r  */
			if (rf == S_INC) {
				outab(0x0E + (v1 << 4));
			} else {
				outab(op);
				outab(0xE0 + v1);
			}
		} else
		if (t1 == S_EXT) {			/* op   R  */
			outab(op);
			if (a1) {
				outab(v1);
				argchk(a1, v1, R_OVRF);
			} else {
				outrb(&e1, l_ovrf);
			}
		} else
		if ((t1 == S_IR) || (t1 == S_INDX)) {	/* op  @R  */
			outab(op + 1);
			if (t1 == S_IR) {
				outab(0xE0 + v1);	/* op  @r  */
			} else {
				if(a1) {		/* op  @R  */
					outab(v1);
					argchk(a1, v1, R_OVRF);
				} else {
					outrb(&e1, l_ovrf);
				}
			}
		} else {
			xerr('a', "Invalid Addressing Mode.");
		}
		break;

	case S_PUPOX:
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		a1 = is_abs(&e1);
		outab(op);
		if (t1 == S_EXT) {
			if (a1) {
				outaw(v1 << 4);
				argchk(a1, v1, R_LU12);
			} else {
				outrwm(&e1, R_LU12 | l_ovrf, 0);
			}
		} else {
			xerr('a', "Invalid Addressing Mode.");
		}
		break;

	case S_DECW:
	case S_INCW:
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		a1 = is_abs(&e1);
		if ((t1 == S_RR) || (t1 == S_EXT)) {
			outab(op);
			if (t1 == S_RR) {
				outab(0xE0 + v1);
			} else {
				if (a1) {
					outrbm(&e1, R_7BIT, 0);
					argchk(a1, v1, R_7BIT);
				} else {
					outrbm(&e1, R_7BIT | l_ovrf, 0);
				}
			}
		} else
		if ((t1 == S_IR) || (t1 == S_INDX)) {
			outab(op + 1);
			if (t1 == S_IR) {
				outab(0xE0 + v1);
			} else {
				if (a1) {
					outab(v1);
					argchk(a1, v1, R_OVRF);
				} else {
					outrb(&e1, l_ovrf);
				}
			}
		} else {
			xerr('a', "Invalid Addressing Mode.");
		}
		break;

	case S_DOP:
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		a1 = is_abs(&e1);
		comma(1);
		t2 = addr(&e2);
		v2 = (int) e2.e_addr;
		a2 = is_abs(&e2);
		if (fg) outab(fg);
		if ((t1 == S_R) && (t2 == S_R)) {	/* op   r,r   */
			outab(op);
			outab((v1 << 4) + v2);
		} else
		if ((t1 == S_R) && (t2 == S_IR)) {	/* op   r,@r  */
			outab(op + 1);
			outab((v1 << 4) + v2);
		} else
		if (((t1 == S_R) || (t1 == S_EXT)) &&
		    ((t2 == S_R) || (t2 == S_EXT))) {	/* op   R,R  */
			outab(op + 2);
			if (t2 == S_R) {
				outab(0xE0 + v2);	/* op   _,r   */
			} else {
				if (a2) {		/* op   _,R   */
					outab(v2);
					argchk(a2, v2, R_OVRF);
				} else {
					outrb(&e2, l_ovrf);
				}
			}
			if (t1 == S_R) {
				outab(0xE0 + v1);	/* op   r,_   */
			} else {
				if (a1) {		/* op   R,_   */
					outab(v1);
					argchk(a1, v1, R_OVRF);
				} else {
					outrb(&e1, l_ovrf);
				}
			}
		} else
		if (((t1 == S_R)  || (t1 == S_EXT)) &&
		    ((t2 == S_IR) || (t2 == S_INDX))) {	/* op   R,@R  */
			outab(op + 3);
			if (t2 == S_IR) {
				outab(0xE0 + v2);	/* op   _,@r   */
			} else {
				if (a2) {		/* op   _,@R   */
					outab(v2);
					argchk(a2, v2, R_OVRF);
				} else {
					outrb(&e2, l_ovrf);
				}
			}
			if (t1 == S_R) {
				outab(0xE0 + v1);	/* op   r,_   */
			} else {
				if (a1) {		/* op   R,_   */
					outab(v1);
					argchk(a1, v1, R_OVRF);
				} else {
					outrb(&e1, l_ovrf);
				}
			}
		} else
		if (((t1 == S_R) || (t1 == S_EXT)) &&
		     (t2 == S_IMMED)) {			/* op   R,#  */
			outab(op + 4);
			if (t1 == S_R) {
				outab(0xE0 + v1);	/* op   r,#   */
			} else {
				if (a1) {		/* op   R,#   */
					outab(v1);
					argchk(a1, v1, R_OVRF);
				} else {
					outrb(&e1, l_ovrf);
				}
			}
			outrb(&e2, 0);	/* No Check On # */
		} else
		if (((t1 == S_IR) || (t1 == S_INDX)) &&
		     (t2 == S_IMMED)) {			/* op   @R,#  */
			outab(op + 5);
			if (t1 == S_IR) {
				outab(0xE0 + v1);	/* op   @r,#   */
			} else {
				if (a1) {		/* op   @R,#   */
					outab(v1);
					argchk(a1, v1, R_OVRF);
				} else {
					outrb(&e1, l_ovrf);
				}
			}
			outrb(&e2, 0);
		} else {
			xerr('a', "Invalid Addressing Mode.");
		}
		break;

	case S_DOPX:
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		a1 = is_abs(&e1);
		comma(1);
		t2 = addr(&e2);
		v2 = (int) e2.e_addr;
		a2 = is_abs(&e2);
		if ((t1 == S_EXT) && (t2 == S_EXT)) {	/* __X   ER1,ER2  */
			if (fg) outab(fg);
			outab(op);
		} else
		if ((t1 == S_EXT) && (t2 == S_IMMED)) {/* __X   ER1,#   */
			if (fg) outab(fg);
			outab(op + 1);
		} else {
			xerr('a', "Invalid Addressing Mode.");
			break;
		}
		if (a1 && !a2) {
			if (t2 == S_IMMED) {	/* r2[7:0], [0000]a1[11:8], a1[7:0] */
				outrb(&e2, 0);	/* No Check On # */
				outaw(v1 & 0x0FFF);
			} else {		/* r2[11:8], r2[3:0]a1[11:8], a1[7:0] */
				outrwm(&e2, R_LU12 | l_ovrf, (v1 & 0x0F00) >> 8);
				outab(v1 & 0xFF);
			}
			argchk(a1, v1, R_L12);
		} else
		if (!a1 && a2) {
			if (t2 == S_IMMED) {	/* a2[7:0], [0000]r1[11:8], r1[7:0] */
				outab(v2);	/* No Check On # */
				outrwm(&e1, R_L12 | l_ovrf, 0);
			} else {		/* a2[11:8], a2[3:0]r1[11:8], r1[7:0] */
				outab((v2 & 0xFF0) >> 4);
				outrwm(&e1, R_L12 | l_ovrf, (v2 & 0x0F) << 12);
				argchk(a2, v2, R_L12);
			}
		} else {
			if (t2 == S_IMMED) {	/* ar2[7:0], [0000]ar1[11:8], a1[7:0] */
				outrb(&e2, 0);	/* No Check On # */
				if (a1) {
					outaw(v1 & 0x0FFF);
				} else {
					outrwm(&e1, R_L12 | l_ovrf, 0);
				}
			} else {		/* a2[11:8], a2[3:0]a1[11:8], a1[7:0] */
				outab((v2 >> 4) & 0xFF);
				outab( ((v2 & 0x0F) << 4) | ((v1 >> 8) & 0x0F) );
				outab(v1 & 0xFF);
				if (!a1 && !a2) {
					xerr('r', "Both Arguments Cannot Be Relocatable.");
				}
			}
			argchk(a1, v1, R_L12);
			argchk(a2, v2, R_LU12);
		}
		break;

	case S_LD:
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		a1 = is_abs(&e1);
		comma(1);
		t2 = addr(&e2);
		v2 = (int) e2.e_addr;
		a2 = is_abs(&e2);
		if ((t1 == S_R) && (t2 == S_IR)) {	/* LD   r,@r  */
			outab(0xE3);
			outab((v1 << 4) + v2);
		} else
		if ((t1 == S_R) && (t2 == S_R)) {	/* LD   r,r   */
			outab(0xE4);
			outab(0xE0 + v2);
			outab(0xE0 + v1);
		} else
		if ((t1 == S_R) && (t2 == S_EXT)) {	/* LD   r,R   */
			outab(0xE4);
			if (a2) {
				outab(v2);
				argchk(a2, v2, R_OVRF);
			} else {
				outrb(&e2, l_ovrf);
			}
			outab(0xE0 + v1);
		} else
		if ((t1 == S_EXT) && (t2 == S_R)) {	/* LD   R,r  */
			outab(0xE4);
			outab(0xE0 + v2);
			if (a1) {
				outab(v1);
				argchk(a1, v1, R_OVRF);
			} else {
				outrb(&e1, l_ovrf);
			}
		} else
		if ((t1 == S_EXT) && (t2 == S_EXT)) {	/* LD   R,R  */
			outab(0xE4);
			if (a2) {
				outab(v2);
				argchk(a2, v2, R_OVRF);
			} else {
				outrb(&e2, l_ovrf);
			}
			if (a1) {
				outab(v1);
				argchk(a1, v1, R_OVRF);
			} else {
				outrb(&e1, l_ovrf);
			}
		} else
		if (((t1 == S_R) || (t1 == S_EXT)) &&
		    ((t2 == S_IR) || (t2 == S_INDX))) {	/* LD   R,@R  */
		    	outab(0xE5);
		    	if (t2 == S_IR) {	/* src */
				outab(0xE0 + v2);	/* LD   _,@r  */
			} else {
				if (a2) {		/* LD   _,@R  */
					outab(v2);
					argchk(a2, v2, R_OVRF);
				} else {
					outrb(&e2, l_ovrf);
				}
			}
		    	if (t1 == S_R) {	/* dst */
				outab(0xE0 + v1);	/* LD   r,_   */
			} else {
				if (a1) {		/* LD   R,_   */
					outab(v1);
					argchk(a1, v1, R_OVRF);
				} else {
					outrb(&e1, l_ovrf);
				}
			}
		} else
		if ((t1 == S_R) && (t2 == S_IMMED)) {	/* LD   r,#  */
			outab(0x0C + (v1 << 4));
			outrb(&e2, 0);	/* No Check On # */
		} else
		if ((t1 == S_EXT) && (t2 == S_IMMED)) {/* LD   R,#   */
			outab(0xE6);
			if (a1) {
				outab(v1);
				argchk(a1, v1, R_OVRF);
			} else {
				outrb(&e1, l_ovrf);
			}
			outrb(&e2, 0);	/* No Check On # */
		} else
		if ((t1 == S_IR) && (t2 == S_IMMED)) {	/* LD   @r,#  */
			outab(0xE7);
			outab(0xE0 + v1);
			outrb(&e2, 0);	/* No Check On # */
		} else
		if ((t1 == S_INDX) && (t2 == S_IMMED)) {/* LD   @R,#  */
			outab(0xE7);
			if (a1) {
				outab(v1);
				argchk(a1, v1, R_OVRF);
			} else {
				outrb(&e1, l_ovrf);
			}
			outrb(&e2, 0);	/* No Check On # */
			argchk(a1, v1, R_OVRF);
		} else
		if ((t1 == S_IR) && (t2 == S_R)) {	/* LD   @r,r  */
			outab(0xF3);
			outab((v1 << 4) + v2);
		} else
		if (((t1 == S_IR) || (t1 == S_INDX)) &&
		    ((t2 == S_R) || (t2 == S_EXT))) {	/* LD   @R,R  */
		    	outab(0xF5);
		    	if (t2 == S_R) {	/* src */
				outab(0xE0 + v2);	/* LD   _,r   */
			} else {
				if (a2) {		/* LD   _,R   */
					outab(v2);
					argchk(a2, v2, R_OVRF);
				} else {
					outrb(&e2, l_ovrf);
				}
			}
		    	if (t1 == S_IR) {	/* dst */
				outab(0xE0 + v1);	/* LD   @r,_  */
			} else {
				if (a1) {		/* LD   @R,_  */
					outab(v1);
					argchk(a1, v1, R_OVRF);
				} else {
					outrb(&e1, l_ovrf);
				}
			}
		} else
		if ((t1 == S_R) && ((t2 & S_INDM) == S_OFR)) {
			outab(0xC7);			/* LD  r,offset(r)  */
			outab((v1 << 4) + (t2 & 0x0F));
			outrb(&e2, 0);	/* No Check On offset */
		} else
		if (((t1 & S_INDM) == S_OFR) && (t2 == S_R)) {
			outab(0xD7);			/* LD  offset(r),r  */
			outab((v2 << 4) + (t1 & 0x0F));
			outrb(&e1, 0);	/* No Check On offset */
		} else {
			xerr('a', "Invalid Addressing Mode.");
		}
		break;

	case S_LDX:
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		a1 = is_abs(&e1);
		comma(1);
		t2 = addr(&e2);
		v2 = (int) e2.e_addr;
		a2 = is_abs(&e2);
		if ((t1 == S_R) && (t2 == S_EXT)) {
			outab(0x84);	/* (r1, ER2)		LDX	r3, 0x876	; 84 38 76 */
			outrwm(&e2, R_L12, v1 << 12);
			argchk(a2, v2, R_L12);
		} else
		if ((t1 == S_IR) && (t2 == S_EXT)) {
			outab(0x85);	/* (@r1, ER2)		LDX	@r4, 0x564	; 85 45 64 */
			outrwm(&e2, R_L12, v1 << 12);
			argchk(a2, v2, R_L12);
		} else
		if ( ((t1 == S_R) || (t1 == S_EXT)) &&
		     ((t2 == S_RR) || (t2 == S_INDX)) ) {
			outab(0x86);	/* (R1, @RR2)		LDX	0x34, @0x56	; 86 56 34 */
			if (t2 == S_RR) {
				outab(0xE0 + v2);
			} else {
				outrbm(&e2, R_7BIT, 0);
			}
			argchk(a2, v2, R_7BIT);
			if (t1 == S_R) {
				outab(0xE0 + v1);
			} else {
				outrb(&e1, 0);
			}
			argchk(a1, v1, R_OVRF);
		} else
		if ((t1 == S_INDX) && (t2 == S_IRRR)) {
			outab(0x87);	/* (@R1, @.ER(RR2)	LDX	@0x12, @.RR(0x09) ; 87 E8 12 */
			outrbm(&e2, R_3BIT, 0xE0);	/* No Check On @.RR() */
			if (a1) {
				outab(v1);
				argchk(a1, v1, R_OVRF);
			} else {
				outrb(&e1, l_ovrf);
			}
		} else
		if ((t1 == S_R) && ((t2 & S_INDM) == S_OFRR)) {
			outab(0x88);	/* (r1, X(rr2)		LDX	r4, 0x21(rr2)	; 88 42 21 */
			outab((v1 << 4) | (t2 & 0x0E));
			outrb(&e2, 0);	/* No Check On offset */
		} else
		if (((t1 & S_INDM) == S_OFRR) && (t2 == S_R)) {
			outab(0x89);	/* (X(rr1), r2)		LDX	0x92(rr14), r0	; 89 E0 92 */
			outab(((t1 & 0x0E) << 4) | v2);
			outrb(&e1, 0);	/* No Check On offset */
		} else
		if ((t1 == S_EXT) && (t2 == S_R)) {
			outab(0x94);	/* (ER1, r2)		LDX	0x345, r6	; 94 63 45 */
			if (a1) {
				outaw((v1 & 0x0FFF) + (v2 << 12));
				argchk(a1, v1, R_L12);
			} else {
				outrwm(&e1, R_L12 | l_ovrf, v2 << 12);
			}
		} else
		if ((t1 == S_EXT) && (t2 == S_IR)) {
			outab(0x95);	/* (ER1, @r2)		LDX	0x347, @r6	; 95 63 47 */
			if (a1) {
				outaw((v1 & 0x0FFF) + (v2 << 12));
				argchk(a1, v1, R_L12);
			} else {
				outrwm(&e1, R_L12 | l_ovrf, v2 << 12);
			}
		} else
		if ( ((t1 == S_IRR) || (t1 == S_INDX)) &&
		     ((t2 == S_R) || (t2 == S_EXT)) ) {
			outab(0x96);	/* (@RR1, R2)		LDX	@rr10, r1	; 96 E1 EA */
			if (t2 == S_R) {
				outab(0xE0 + v2);
			} else {
				if (a2) {
					outab(v2);
					argchk(a2, v2, R_OVRF);
				} else {
					outrb(&e2, l_ovrf);
				}
			}
			if (t1 == S_IRR) {
				outab(0xE0 + v1);
			} else {
				if (a1) {
					outab(v1 & 0xFE);
					argchk(a1, v1, R_7BIT);
				} else {
					outrbm(&e1, R_7BIT | l_ovrf, 0);
				}
			}
		} else
		if ((t1 == S_IRRR) && ((t2 == S_INDX) || (t2 == S_R))) {
			if (t2 == S_R) {
				e2.e_addr |= 0xE0;
			}
			outab(0x97);	/* (@.ER(RR1, @R2)	LDX	@.RR(0x13), @0xB4 ; 97 B4 E2 */
			if (a2) {
				outab(v2);
				argchk(a2, v2, R_OVRF);
			} else {
				outrb(&e2, l_ovrf);
			}
			outrbm(&e1, R_3BIT, 0xE0);	/* No Check On @.RR() */
		} else
		if ((t1 == S_EXT) && (t2 == S_EXT)) {
			outab(0xE8);	/* (ER!, ER2)		LDX	0x351, 0x456	; E8 45 63 51 */
			if (a1 && !a2) {
				outrwm(&e2, R_LU12 | l_ovrf, (v1 & 0x0F00) >> 8);
				outab(v1);
				argchk(a1, v1, R_LU12);
			} else
			if (!a1 && a2) {
				outab((v2 & 0x0FF0) >> 4);
				outrwm(&e1, R_L12 | l_ovrf, (v2 & 0x00F) << 12);
				argchk(a2, v2, R_L12);
			} else {
				outaw(((v2 & 0x0FFF) << 4) | ((v1 & 0x0F00) >> 8));
				outab(v1);
				argchk(a1, v1, R_LU12);
				argchk(a2, v2, R_L12);
				if (!a1 && !a2) {
					xerr('r', "Both Arguments Cannot Be Relocatable.");
				}
			}
		} else
		if ((t1 == S_EXT) && (t2 == S_IMMED)) {
			outab(0xE9);	/* (ER1, IM)		LDX	0x364, #0x35	; E9 35 03 64 */
			outrb(&e2, 0);	/* No Check On # */
			if (a1) {
				outaw(v1);
				argchk(a1, v1, R_L12);
			} else {
				outrwm(&e1, R_L12 | l_ovrf, 0);
			}
		} else {
			xerr('a', "Invalid Addressing Mode.");
		}
		break;

	case S_LDWX:
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		a1 = is_abs(&e1);
		argchk(a1, v1, R_L12);
		comma(1);
		t2 = addr(&e2);
		v2 = (int) e2.e_addr;
		a2 = is_abs(&e2);
		argchk(a2, v2, R_LU12);
		if (t1 == S_R) {
			outab(fg);
			outab(op);
			if (a2) {
				outaw(((v2 & 0x0FFF) << 4) + 0x0E);
				argchk(a2, v2, R_LU12);
			} else {
				outrwm(&e2, R_LU12 | l_ovrf, 0x0E);
			}
			outab(0xE0 + v1);
		} else
		if ((t1 == S_EXT) && (t2 == S_EXT)) {
			outab(fg);
			outab(op);
			if (a1 && !a2) {
				outrwm(&e2, R_LU12 | l_ovrf, (v1 & 0x0F00) >> 8);
				outab(v1);
			} else
			if (!a1 && a2) {
				outab((v2 & 0x0FF0) >> 4);
				outrwm(&e1, R_L12 | l_ovrf, (v2 & 0x00F) << 12);
			} else {
				outaw(((v2 & 0x0FFF) << 4) | ((v1 & 0x0F00) >> 8));
				outab(v1);
				if (!a1 && !a2) {
					xerr('r', "Both Arguments Cannot Be Relocatable.");
				}
			}
		} else {
			xerr('a', "Invalid Addressing Mode.");
		}
		break;

	case S_LDCE:
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		comma(1);
		t2 = addr(&e2);
		v2 = (int) e2.e_addr;
		if ((t1 == S_R) && (t2 == S_IRR)) {	/* op  r,@rr  */
			outab(op);
			outab((v1 << 4) + v2);
		} else
		if ((t1 == S_IRR) && (t2 == S_R)) {	/* op  @rr,r  */
			outab(op + 0x10);
			outab((v2 << 4) + v1);
		} else
		if ((op == 0xC2) & (t1 == S_IR) & (t2 == S_IRR)) {	/* ldc @r,@rr */
			outab(op + 0x03);
			outab((v1 << 4) + v2);
		} else {
 			xerr('a', "Allowed modes: R,@RR, @RR,R or LDC @r,@RR.");
		}
		break;

	case S_LDCEI:
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		comma(1);
		t2 = addr(&e2);
		v2 = (int) e2.e_addr;
		if ((t1 == S_IR) && (t2 == S_IRR)) {	/* op  @r,@rr */
			outab(op);
			outab((v1 << 4) + v2);
		} else
		if ((t1 == S_IRR) && (t2 == S_IR)) {	/* op  @rr,@r */
			outab(op + 0x10);
			outab((v2 << 4) + v1);
		} else {
			xerr('a', "Allowed modes: @R,@RR and @RR,@R.");
		}
		break;

	case S_LEA:
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		a1 = is_abs(&e1);
		comma(1);
		t2 = addr(&e2);
		v2 = (int) e2.e_addr;
		a2 = is_abs(&e2);
		if ( ((t1 == S_R)  && ((t2 & S_INDM) == S_OFR)) ||
		     ((t1 == S_RR) && ((t2 & S_INDM) == S_OFRR)) ) {
		     	outab(op + ((t1 == S_RR) ? 1 : 0));
			outab((v1 << 4) | (t2 & 0x0F));
			outrb(&e2, 0);	/* No Check On offset */
			argchk(a2, v2, R_OVRF);
		} else {
			xerr('a', "Allowed modes: R,X(R) and RR,X(RR).");
		}
		break;

	case S_MUL:
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		a1 = is_abs(&e1);
		if (t1 == S_RR) {
			outab(op);
			outab(0xE0 | v1);
		} else
		if (t1 == S_EXT) {
			outab(op);
			if (a1) {
				outab(v1 & 0xFE);
				argchk(a1, v1, R_7BIT);
			} else {
				outrbm(&e1, R_7BIT | l_ovrf, 0);
			}
		} else {
			xerr('a', "Invalid Addressing Mode.");
		}
		break;

	case S_TRAP:
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		a1 = is_abs(&e1);
		if ((t1 == S_IMMED) || (t1 == S_EXT)) {
			outab(op);
			if (a1) {
				outab(v1);
				argchk(a1, v1, R_OVRF);
			} else {
				outrb(&e1, l_ovrf);
			}
		} else {
			xerr('a', "TRAP requires a #.");
		}
		break;

	case S_DJNZ:
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		comma(1);
		expr(&e2, 0);
		if (t1 == S_R) {
			op |= (v1 << 4);
		} else {
			xerr('a', "First argument must be a register.");
		}
		outab(op);
		if (mchpcr(&e2, &v2, 1)) {
			if ((v2 < -128) || (v2 > 127))
				xerr('a', "Branching Range Exceeded.");
			outab(v2);
		} else {
			outrb(&e2, R_PCR);
		}
		if (e2.e_mode != S_USER)
			rerr();
		break;

	case S_JR:
		if ((v1 = admode(CND)) != 0) {
			op |= (v1 << 4);		/* op CC,_  */
			comma(1);
		} else {
			op |= 0x80;			/* op  T,_  */
		}
		expr(&e1, 0);
		outab(op);
		if (mchpcr(&e1, &v1, 1)) {
			if ((v1 < -128) || (v1 > 127))
				xerr('a', "Branching Range Exceeded.");
			outab(v1);
		} else {
			outrb(&e1, R_PCR);
		}
		if (e1.e_mode != S_USER)
			rerr();
		break;

	case S_JP:
		if ((v1 = admode(CND)) != 0) {
			op |= (v1 << 4);		/* JP  CC,_  */
			comma(1);
		} else {
			op |= 0x80;			/* JP   T,_  */
		}
		t2 = addr(&e2);
		v2 = (int) e2.e_addr;
		a2 = is_abs(&e2);
		if (t2 == S_EXT) {
			outab(op);			/* JP  CC,_   */
			outrw(&e2, 0);
		} else
		if ((v1 == 0) && ((t2 == S_IRR) || (t2 == S_INDX))) {
			outab(0xC4);
			if (t2 == S_IRR) {
				outab(0xE0 + v2);	/* JP  @rr    */
			} else {
				if (a2) {		/* JP  @__    */
					outab(v2 & 0xFE);
					argchk(a2, v2, R_7BIT);
				} else {
					outrbm(&e2, R_7BIT | l_ovrf, 0);
				}
			}
		} else {
			xerr('a', "Allowed modes: CC,addr / T,addr / @RR / @addr.");
		}
		break;

	case S_CALL:
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		a1 = is_abs(&e1);
		if ((t1 == S_IRR) || (t1 == S_INDX)) {	/* op  @  */
			outab(op);
			if (t1 == S_IRR) {
				outab(0xE0 + v1);	/* op  @RR  */
			} else {
				if (a1) {		/* op  @__  */
					outab(v1 & 0xFE);
					argchk(a1, v1, R_7BIT);
				} else {
					outrbm(&e1, R_7BIT | l_ovrf, 0);
				}
			}
		} else
		if (t1 == S_EXT) {		
			outab(op + 2);
			outrw(&e1, 0);
		} else {
			xerr('a', "Allowed modes: @RR / @addr / addr.");
		}
		break;

	case S_BTJ:
		switch(fg) {
		default:
		case O_BTJ:
			expr(&e1,0);
			v1 = (int) e1.e_addr;
			a1 = is_abs(&e1);
			comma(1);
			break;
		case O_NZ:
			v1 = 1;
			a1 = 1;
			break;
		case O_Z:
			v1 = 0;
			a1 = 1;
			break;
		}
		expr(&e2,0);
		v2 = (int) e2.e_addr;
		a2 = is_abs(&e2);
		comma(1);
		t3 = addr(&e3);
		v3 = (int) e3.e_addr;
		comma(1);
		expr(&e4, 0);
		if (a1 && (v1 & (int) ~1)) {
			xerr('a', "Required bit value is 0 or 1.");
		}
		if (a2 && (v2 & (int) ~7)) {
			xerr('a', "Required bit number is 0 - 7.");
		}
		if ((t3 == S_R) || (t3 == S_IR)) {
			outab(op + (t3 == S_IR ? 1 : 0));
			if (a1 && !a2) {
				outrbm(&e2, R_L3U4 | l_ovrf, ((v1 & 0x01) << 7) | v3);
			} else
			if (!a1 && a2) {
				outrbm(&e1, R_L1U7, ((v2 & 0x07) << 4) | v3);
			} else {
				outab(((v1 & 0x01) << 7) | ((v2 & 0x07) << 4) | v3);
				if (!a1 && !a2) {
					xerr('a', "Only one relocatable argument allowed.");
				}
			}
			if (mchpcr(&e4, &v4, 1)) {
				if ((v4 < -128) || (v4 > 127))
					xerr('a', "Branching Range Exceeded.");
				outab(v4);
			} else {
				outrb(&e4, R_PCR);
			}
			if (e4.e_mode != S_USER)
				rerr();
		} else {
			xerr('a', "Addressing mode must be R or @R.");
		}
		break;

	case S_BIT:
		switch(fg) {
		default:
		case O_BIT:
			expr(&e1,0);
			v1 = (int) e1.e_addr;
			a1 = is_abs(&e1);
			comma(1);
			break;
		case O_CLR:
			v1 = 0;
			a1 = 1;
			break;
		case O_SET:
			v1 = 1;
			a1 = 1;
			break;
		}
		expr(&e2,0);
		v2 = (int) e2.e_addr;
		a2 = is_abs(&e2);
		comma(1);
		t3 = addr(&e3);
		v3 = (int) e3.e_addr;
		if (a1 && (v1 & (int) ~1)) {
			xerr('a', "Required bit value is 0 or 1.");
		}
		if (a2 && (v2 & (int) ~7)) {
			xerr('a', "Required bit number is 0 - 7.");
		}
		if (t3 == S_R) {
			outab(op);
			if (a1 && !a2) {
				outrbm(&e2, R_L3U4 | l_ovrf, ((v1 & 0x01) << 7) | v3);
			} else
			if (!a1 && a2) {
				outrbm(&e1, R_L1U7, ((v2 & 0x07) << 4) | v3);
			} else {
				outab(((v1 & 0x01) << 7) | ((v2 & 0x07) << 4) | v3);
				if (!a1 && !a2) {
					xerr('r', "Both Arguments Cannot Be Relocatable.");
				}
			}
		} else {
			xerr('a', "Addressing mode must be R.");
		}
		break;

	case S_BSWAP:
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		a1 = is_abs(&e1);
		if (t1 == S_R) {
			outab(op);
			outab(0xE0 + v1);
		} else
		if (t1 == S_EXT) {
			outab(op);
			if (a1) {
				outab(v1);
				argchk(a1, v1, R_OVRF);
			} else {
				outrb(&e1, l_ovrf);
			}
		} else {
			xerr('a', "Invalid Addressing Mode.");
		}
		break;

	case S_SRP:
		t1 = addr(&e1);
		v1 = (int) e1.e_addr;
		a1 = is_abs(&e1);
		if ((t1 == S_IMMED) || (t1 == S_EXT)) {
			outab(op);
			if (a1) {
				outab(v1);
				argchk(a1, v1, R_OVRF);
			} else {
				outrb(&e1, l_ovrf);
			}
		} else {
			xerr('a', "Allowed modes: (#)val.");
		}
		break;

	case S_INH:
		outab(op);
		break;

	default:
		opcycles = OPCY_ERR;
		xerr('o', "Internal Opcode Error.");
		break;
	}

	if (opcycles == OPCY_NONE) {
		opcycles = ez8pg1[cb[0] & 0xFF];
		if ((opcycles & OPCY_NONE) && (opcycles & OPCY_MASK)) {
			opcycles = ez8Page[opcycles & OPCY_MASK][cb[1] & 0xFF];
		}
	}
	/*
	 * Translate To External Format
	 */
	if (opcycles == OPCY_NONE) { opcycles  =  CYCL_NONE; } else
	if (opcycles  & OPCY_NONE) { opcycles |= (CYCL_NONE | 0x3F00); }
}

/*
 * Report Argument Errors
 */
void
argchk(int a, int v, int r)
{
	switch(r) {
	default:
	case R_OVRF:
		if (ovr && a && (v & (int) ~0xFF)) {
			xerr('w', "8-Bit value out of range.");
		}
		break;
	case R_L1U7:
		if (ovr && a && (v & (int) ~0x01)) {
			xerr('w', "1-Bit value out of range.");
		}
		break;
	case R_L3U4:
		if (ovr && a && (v & (int) ~0x07)) {
			xerr('w', "3-Bit value out of range.");
		}
		break;
	case R_7BIT:
		if (odd && a && (v & 0x01)) {
			xerr('w', "Not an even address.");
		}
		if (ovr && a && (v & (int) ~0xFF)) {
			xerr('w', "8-Bit value out of range.");
		}
		break;
	case R_L12:
	case R_LU12:
		if (ovr && a && (v & (int) ~0xFFF)) {
			xerr('w', "12-Bit value out of range.");
		}
		break;
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
 * Machine specific .enabl/.dsabl terms.
 */
int
mchoptn(char *id, int v)
{
	/* ODD Address In Register Pair */
	if (symeq(id, "odd", 1)) { odd = v; } else
        /* OVERFLOW Alloted Bits */
	if (symeq(id, "ovr", 1)) { ovr = v; } else
        /* Enables ASlink Error Reporting Of ODD And OVERFLOW */
	if (symeq(id, "lnk", 1)) { l_ovrf = (v ? R_OVRF : 0); } else {
		return(0);
	}
	return(1);
}

/*
 * Machine dependent initialization
 */
void
minit(void)
{
	/*
	 * Byte Order
	 */
	hilo = 1;
	/*
	 * .enabl /.dsabl Flags
	 */
	odd = 1;
	ovr = 1;
	l_ovrf = R_OVRF;
	/*
	 * External Calls
	 */
	/* .enabl/.dsabl Extension */
	mchoptn_ptr = mchoptn;
}

