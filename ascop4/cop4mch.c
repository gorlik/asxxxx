/* cop4mch.c */

/*
 *  Copyright (C) 2021-2025  Alan R. Baldwin
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
#include "cop4.h"

char	*cpu	= "National Semiconductor COP400 Family";
char	*dsft	= "asm";

/*
 * Opcode Cycle Definitions
 */
#define	OPCY_SDP	((char) (0xFF))
#define	OPCY_ERR	((char) (0xFE))

#define	OPCY_NONE	((char) (0x80))
#define	OPCY_MASK	((char) (0x7F))

#define	OPCY_SKP	((char)	(0xFD))

#define	UN	((char) (OPCY_NONE | 0x00))
#define	P2	((char) (OPCY_NONE | 0x01))
#define	P3	((char) (OPCY_NONE | 0x02))

/*
 * COP4 Cycle Count
 *
 *	opcycles = coppg1[opcode]
 */
static char coppg1[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*10*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*20*/   1, 1, 1,P2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*30*/   1, 1, 1, 1,P3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*40*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*50*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*60*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
/*70*/   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
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
 * Opcodes Of Type 22 xx
 */
static char coppg2[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*10*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*20*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*30*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*40*/   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
/*50*/   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
/*60*/   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
/*70*/   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
/*80*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*90*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*A0*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*B0*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*C0*/   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
/*D0*/   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
/*E0*/   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
/*F0*/   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
};

/*
 * Opcodes Of Type 33 xx
 */
static char coppg3[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   0, 2, 0, 2, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2,
/*10*/   0, 2, 0, 2, 0, 0, 0, 0, 0, 2, 2, 0, 2, 0, 0, 2,
/*20*/   0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 0, 2, 0, 2, 2, 2,
/*30*/   0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 2, 0, 0, 2,
/*40*/   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
/*50*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*60*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*70*/   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
/*80*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*90*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*A0*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*B0*/   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
/*C0*/   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
/*D0*/   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
/*E0*/   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
/*F0*/   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
};

static char *Page[3] = {
    coppg1, coppg2, coppg3
};

char *copstr;
a_uint illinst;
int romsize;
a_uint xad;

struct area *pagarea;
struct expr pagexpr;

/*
 * Process machine ops.
 */
void
machine(struct mne *mp)
{
	unsigned int op,c;
	char id[NCPS];
	struct expr e1,e2;
	int t1,t2;
	a_uint v1,v2;

	/*
	 * Using Internal Format
	 * For Cycle Counting
	 */
	opcycles = OPCY_NONE;

	clrexpr(&e1);
	clrexpr(&e2);
	t1 = t2 = 0;
	v1 = v2 = 0;
	op = (int) mp->m_valu;

	icheck(op);

	switch (mp->m_type) {

	case S_SPG:
		opcycles = OPCY_SDP;
		pagarea = dot.s_area;
		e1.e_addr = 0x0080;
		if (more()) {
			expr(&e1, 0);
			if (e1.e_flag == 0 && e1.e_base.e_ap == NULL) {
				if (e1.e_addr != 0x80) {
					e1.e_addr = 0x80;
					xerr('a', "Only PAGE 2 (= 0x0080) Is Allowed.");
				}
			}
			if ((c = getnb()) == ',') {
				getid(id, -1);
				pagarea = alookup(id);
				if (pagarea == NULL) {
					pagarea = dot.s_area;
					xerr('u', "Undefined Area.");
				}
			} else {
				unget(c);
			}
		}
		memcpy(&pagexpr, &e1, sizeof(e1));
		outdp(pagarea, &pagexpr, 0);
		lmode = SLIST;
		break;

	case S_COP:
		opcycles = OPCY_SKP;
		lmode = SLIST;
		if (more()) {
			if (coptype()) {
				break;
			}
			xerr('a', "Unrecognized CPU type.");
		}
		copstr = "400";
		sym[2].s_addr = 0;
		illinst = 0;
		romsize = S_2048;
		xad = 0;
		lmode = SLIST;
		break;
		
	case S_ROM:
		opcycles = OPCY_SKP;
		lmode = SLIST;
		romsize = op;
		break;

	case S_XAD:
		opcycles = OPCY_SKP;
		lmode = SLIST;
		if (more()) {
			expr(&e1, 0);
			xad = e1.e_addr;
		} else {
			xad = 0;
		}
		break;

	case S_INH2:
		outab((op & 0xFF00) >> 8);
	case S_INH1:
		outab(op);
		break;

	case S_IMY2:
		outab((op & 0xFF00) >> 8);
	case S_IMY1:
		t1 = addr(&e1);
		v1 = e1.e_addr;
		switch(t1) {
		case S_IMM:
		case S_EXT:
			if (is_abs(&e1)) {
				outab(op | (v1 & 0x0F));
			} else {
				outrbm(&e1, R_4BIT, op);
			}
			break;
		default:
			xerr('a', "Rn Is An Invalid Argument.");
			break;
		}
 		break;

	case S_RAM1:
		t1 = addr(&e1);
		v1 = e1.e_addr;
		if (is_abs(&e1)) {
			if (v1 & ~0x03) {
				v1 &= 0x03;
				xerr('a', "RAM Value Of 0, 1, 2, Or 3 Required.");
			}
		}
		switch(t1) {
		case S_REG:
			outab(op | (v1 << 4));
			break;
		case S_EXT:
			if (is_abs(&e1)) {
				outab(op | (v1 << 4));
			} else {
				outrbm(&e1, R_2BIT | R_MBRO, op);
			}
			break;
		default:
			xerr('a', "Immediate Mode Is Not Valid.");
			break;
		}
		break;

	case S_RAM2:
		t1 = addr(&e1);
		v1 = e1.e_addr;
		if (is_abs(&e1)) {
			if (v1 & ~0x03) {
				v1 &= 0x03;
				xerr('a', "RAM Value Of 0, 1, 2, Or 3 Required.");
			}
		}
		comma(1);
		t2 = addr(&e2);
		v2 = e2.e_addr;
		if (is_abs(&e2)) {
			if (v2 & ~0x0F) {
				v2 &= 0x0F;
				xerr('a', "Bit Select Range Is 0-15.");
			}
		}
		if ((op == 0x2380) && ((illinst & I_XAD) || xad)) {
			if (is_abs(&e1) && (v1 == 3) && is_abs(&e2) && (v2 == 15)) {
				; /* xad 3,15 */
			} else {
				xerr('a', "r,d Must Evaluate To 3,15.");
			}
		}
		switch(t1) {
		case S_REG:
			switch(t2) {
			case S_IMM:
			case S_EXT:
				if (is_abs(&e2)) {
					outaw(op | (v1 << 4) | v2);
				} else {
					outrwm(&e2, R_4BIT | R_MBRO, op | (v1 << 4));
				}
				break;
			default:
				outaw(op | ((v1 & 0x03) << 4) | (v2 & 0x0F));
				xerr('a', "Rn Is Not A Bit Select.");
				break;
			}
			break;
		case S_EXT:
			switch(t2) {
			case S_IMM:
			case S_EXT:
				if (is_abs(&e1) && is_abs(&e2)) {
					outaw(op | (v1 << 4) | v2);
				} else
				if (is_abs(&e1) && !is_abs(&e2)) {
					outrwm(&e2, R_4BIT | R_MBRO, op | (v1 << 4));
				} else
				if (!is_abs(&e1) && is_abs(&e2)) {
					outrwm(&e1, R_2BIT | R_MBRO, op | v2);
				} else {
				outaw(op | ((v1 & 0x03) << 4) | (v2 & 0x0F));
					xerr('a', "Rn And The Bit Select Cannot Both Be External.");
 				}
				break;

			case S_REG:
			default:
				outaw(op | ((v1 & 0x03) << 4) | (v2 & 0x0F));
				xerr('a', "Rn Is Not A Bit Select.");
				break;
			}
			break;

		case S_IMM:
			outaw(op | ((v1 & 0x03) << 4) | (v2 & 0x0F));
			xerr('a', "#N Is Not A Register.");
			break;

		default:
			break;
		}
		break;

	case S_SKZ2:
		outab((op & 0xFF00) >> 8);
	case S_SKZ1:
		t1 = addr(&e1);
		v1 = e1.e_addr;
		if (is_abs(&e1)) {
			if (v1 & ~0x03) {
				v1 &= 0x03;
				xerr('a', "Bit Value Of 0, 1, 2, Or 3 Required.");
			}
		}
		switch(t1) {
		case S_IMM:
		case S_EXT:
			if (is_abs(&e1)) {
				switch(v1){
					default:
					case 0:	v1 = 0x01;	break;
					case 1:	v1 = 0x11;	break;
					case 2:	v1 = 0x03;	break;
					case 3:	v1 = 0x13;	break;
				}
				outab(op | v1);
			} else {
				outab(op | 0x01);
				xerr('a', "A Constant Bit Value Of 0, 1, 2, Or 3 Required.");
			}
		default:
			break;
		}
		break;

	case S_JMP:
	case S_JSR:
		t1 = addr(&e1);
		v1 = e1.e_addr;
		switch(t1) {
		case S_EXT:
			setgbl(&e1);
			switch(romsize) {
			default:
			case S_2048:	outrwm(&e1, R_11BIT | R_MBRO, op);	break;
			case S_1024:	outrwm(&e1, R_10BIT | R_MBRO, op);	break;
			case S_512:	outrwm(&e1, R_9BIT | R_MBRO, op);	break;
			case S_256:	outrwm(&e1, R_8BIT | R_MBRO, op);	break;
			}
			break;
		default:
			xerr('a', "Rn And #N Are Invalid Arguments.");
			break;
		}
		break;

	/*
	 *   The JP and JSRP instructions are unique
	 * in the sense that they are dependent upon
	 * where in the program space they are located.
	 *
	 *   This can be seen by comparing the opcode
	 * values for JP and JSRP.
	 *
	 *	jp	a	0x80 | <A6:A0>	Jump within pages 2 and 3
	 *	jp	a	0xC0 | <A5:A0>	Jump within current page, not 2 or 3
	 *
	 *	jp	0xE0	->	0xE0	(jp to page 3)	 (jp in Page 2 or 3)
	 *	jp	0x20	->	0xE0	(jp to current page) (page 0, base = 0x000)
	 *
	 * or
	 *
	 *	jp	0xA0	->	0xA0	(jp   to page 2) (jp in page 2 or 3)
	 *	jsrp	0xA0	->	0xA0	(jsrp to Page 2)
	 *
	 *   The assembler and linker are not capable of
	 * changing the opcode based upon the relocated
	 * address of the instruction location.  Thus a
	 * new instruction mnemonic, jp23, is introduced to
	 * to indicate a jp instruction within pages 2 and 3.
	 * The linker verifies that any jp23 jump address is
	 * in this region.  The jump addresses are checked to
	 * be within the address range 0x80 to 0xFF.
	 *
	 *	jp	Use in pages 0, 1, and >= 4
	 *	jp23	Use in pages 2 and 3
	 *
	 *   The programmer is required to manually verify that
	 * jp23 is used in pages 2 and 3 and that jp is used in
	 * all other pages.
	 *
	 *   The COP400 documentation resolves the jp-jsrp conflict
	 * by not allowing a jsrp instruction to be located within
	 * page 2 or page 3.  The programmer must manually
	 * verify that a jsrp instruction is not located within
	 * page 2 or 3.  Use the jsr instruction in pages 2 and 3.
	 */
	case S_JSRP:
		t1 = addr(&e1);
		v1 = e1.e_addr;
		switch(t1) {
		case S_EXT:
			if (is_abs(&e1)) {
				if ((v1 & 0x3F) == 0x3F) {
					xerr('a', "JSRP To The Last Byte Of Page 2 Is Invalid.");
				}
				if ((v1 & ~0x3F) != 0x80) {
					xerr('a', "JSRP Valid Only To Page 2.");
				}
			}
			setgbl(&e1);
			outrbm(&e1, R_6BIT | R_PAGN, op);
			break;
		default:
			xerr('a', "Rn And #N Are Invalid Arguments.");
			break;
		}
		break;

	/*
	 * JP Instruction Not Allowed In Pages 2 And 3 (Use JP23)
	 */
	case S_JP:
		t1 = addr(&e1);
		v1 = e1.e_addr;
		switch(t1) {
		case S_EXT:
			if (is_abs(&e1)) {
				if ((v1 & 0x3F) == 0x3F) {
					xerr('a', "JP To The Last Byte Of A Page Is Invalid.");
				}
			}
			setgbl(&e1);
			outrbm(&e1, R_6BIT | R_PAGX, op);
			break;
		default:
			xerr('a', "Rn And #N Are Invalid Arguments.");
			break;
		}
		break;

	/*
	 * JP23 Instruction Is Allowed Only In Pages 2 And 3 (Use JP)
	 */
	case S_JP23:
		t1 = addr(&e1);
		v1 = e1.e_addr;
		switch(t1) {
		case S_EXT:
			if (is_abs(&e1)) {
				if ((v1 & 0x3F) == 0x3F) {
					xerr('a', "JP23 To The Last Byte Of A Page Is Invalid.");
				}
				if (((v1 & ~0x3F) != 0x80) && ((v1 & ~0x3F) != 0xC0)) {
					xerr('a', "JP23 Valid Only To Pages 2 and 3.");
				}
			}
			setgbl(&e1);
			setpgl(0x7F);
			outrbm(&e1, R_7BIT | R_PAGN, op);
			setpgl(0x3F);
			break;
		default:
			xerr('a', "Rn And #N Are Invalid Arguments.");
			break;
		}
			break;

	case S_RMB:
		t1 = addr(&e1);
		v1 = e1.e_addr;
		if (is_abs(&e1)) {
			if (v1 & ~0x03) {
				v1 &= 0x03;
				xerr('a', "RAM Bit Value Of 0, 1, 2, Or 3 Required.");
			}
		}
		switch(t1) {
		case S_IMM:
		case S_EXT:
			if (is_abs(&e1)) {
				switch(v1) {
				case 0:	outab(op | 0x0C);	break;
				case 1:	outab(op | 0x05);	break;
				case 2:	outab(op | 0x02);	break;
				case 3:	outab(op | 0x03);	break;
				default:			break;
				}
			} else {
				outab(op | 0x0C);
				xerr('a', "RAM Bit Value Must Be A Constant.");
			}
			break;
		case S_REG:
			outab(op | 0x0C);
			xerr('a', "Rn Is Not A Valid Argument.");
			break;
		default:
			break;
		}
		break;

	case S_SMB:
		t1 = addr(&e1);
		v1 = e1.e_addr;
		if (is_abs(&e1)) {
			if (v1 & ~0x03) {
				v1 &= 0x3;
				xerr('a', "RAM Bit Value Of 0, 1, 2, Or 3 Required.");
			}
		}
		switch(t1) {
		case S_IMM:
		case S_EXT:
			if (is_abs(&e1)) {
				switch(v1) {
				case 0:	outab(op | 0x0D);	break;
				case 1:	outab(op | 0x07);	break;
				case 2:	outab(op | 0x06);	break;
				case 3:	outab(op | 0x0B);	break;
				default:			break;
				}
			} else {
				outab(op | 0x0D);
				xerr('a', "RAM Bit Value Must Be A Constant.");
			}
			break;
		case S_REG:
			outab(op | 0x0D);
			xerr('a', "Rn Is Not A Valid Argument.");
			break;
		default:
			break;
		}
		break;

	case S_LBI:
		t1 = addr(&e1);
		v1 = e1.e_addr;
		if (is_abs(&e1)) {
			if (v1 & ~0x03) {
				v1 &= 0x03;
				xerr('a', "RAM Value Of 0, 1, 2, Or 3 Required.");
			}
		}
		comma(1);
		t2 = addr(&e2);
		v2 = e2.e_addr;
		if (is_abs(&e2)) {
			if (v2 & ~0x0F) {
				v2 &= 0x0F;
				xerr('a', "Bit Select Range Is 0-15.");
			}
		}
		switch(t1) {
		case S_REG:
			switch(t2) {
			case S_IMM:
			case S_EXT:
				if (is_abs(&e2)) {
					if ((v2 == 0) || ((v2 > 8) && (v2 < 16))) {
						if (v2 == 0) {
							v2 = 0x0F;
						} else {
							v2 -= 1;
						}
						outab((v1 << 4) | v2);
					} else {
						outaw(op | (v1 << 4) | v2);
					}
				} else {
					outrwm(&e2, R_4BIT | R_MBRO, op | 0x80 | (v1 << 4));
				}
				break;
			default:
				outaw(op | ((v1 & 0x03) << 4) | (v2 & 0x0F));
				xerr('a', "Rn Is Not A Bit Select.");
				break;
			}
			break;
		case S_EXT:
			switch(t2) {
			case S_IMM:
			case S_EXT:
				if (is_abs(&e1) && is_abs(&e2)) {
					if ((v2 == 0) || ((v2 > 8) && (v2 < 16))) {
						if (v2 == 0) {
							v2 = 0x0F;
						} else {
							v2 -= 1;
						}
						outab((v1 << 4) | v2);
					} else {
						outaw(op | (v1 << 4) | v2);
					}
				} else
				if (is_abs(&e1) && !is_abs(&e2)) {
					outrwm(&e2, R_4BIT | R_MBRO, op | 0x80 | (v1 << 4));
				} else
				if (!is_abs(&e1) && is_abs(&e2)) {
					if ((v2 == 0) || ((v2 > 8) && (v2 < 16))) {
						v2 = (v2 - 1) & 0x0F;
						outrbm(&e1, R_2BIT | R_MBRO, op | v2);
					} else {
						outrwm(&e1, R_2BIT | R_MBRO, op | v2);
					}
				} else {
					outaw(op | ((v1 & 0x03) << 4) | (v2 & 0x0F));
					xerr('a', "Ram And Bit Select Cannot Both Be External.");
 				}
				break;

			case S_REG:
			default:
				outaw(op | ((v1 & 0x03) << 4) | (v2 & 0x0F));
				xerr('a', "Rn Is Not A Bit Select.");
				break;
			}
			break;

		case S_IMM:
			outaw(op | ((v1 & 0x03) << 4) | (v2 & 0x0F));
			xerr('a', "#N Is Not A Register.");
			break;

		default:
			break;
		}
		break;

	default:
		opcycles = OPCY_ERR;
		xerr('o', "Internal Opcode Error.");
		break;
	}
	if (opcycles == OPCY_NONE) {
		opcycles = coppg1[cb[0] & 0xFF];
		if ((opcycles & OPCY_NONE) && (opcycles & OPCY_MASK)) {
			opcycles = Page[opcycles & OPCY_MASK][cb[1] & 0xFF];
		}
	}
 	/*
	 * Translate To External Format
	 */
	if (opcycles == OPCY_NONE) { opcycles  =  CYCL_NONE; } else
	if (opcycles  & OPCY_NONE) { opcycles |= (CYCL_NONE | 0x3F00); }
}

/*
 * Make Number Relocatable
 */
void
setgbl(struct expr *esp)
{
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
}

/*
 * Set PAGN Area, Base Address, And Length Mask
 */
void
setpgl(int pmsk)
{
	p_mask = pmsk;
	outdp(pagarea, &pagexpr, 0);
}

char errstr[80];

void
icheck(unsigned int op)
{
	char *id;

	/*
	 * Preprocess Checking For Invalid Instructions
	 */
	id = NULL;
	switch (op) {
	case 0x4A:	if (illinst & I_ADT)	{ id = "adt"; }		break;
	case 0x10:	if (illinst & I_CASC)	{ id = "casc"; }	break;
	case 0x331A:	if (illinst & I_OR)	{ id = "or"; }		break;
	case 0x3338:	if (illinst & I_HALT)	{ id = "halt"; }	break;
	case 0x3339:	if (illinst & I_IT)	{ id = "it"; }		break;
	case 0x330F:	if (illinst & I_CEMA)	{ id = "cema"; }	break;
	case 0x331F:	if (illinst & I_CAME)	{ id = "came"; }	break;
	case 0x332F:	if (illinst & I_CTMA)	{ id = "ctma"; }	break;
	case 0x333F:	if (illinst & I_CAMT)	{ id = "camt"; }	break;
	case 0x332C:	if (illinst & I_CQMA)	{ id = "cqma"; }	break;
	case 0x2300:	if (illinst & I_LDD)	{ id = "ldd"; }		break;
	case 0x3319:	if (illinst & I_LID)	{ id = "lid"; }		break;
	case 0xBF:	if (illinst & I_LQID)	{ id = "lqid"; }	break;
/*	case 0x2380:	if (illinst & I_XAD)	{ id = "xad"; }		break;	*/
	case 0x12:	if (illinst & I_XABR)	{ id = "xabr"; }	break;
	case 0x330B:	if (illinst & I_XAN)	{ id = "xan"; }		break;
	case 0x41:	if (illinst & I_SKT)	{ id = "skt"; }		break;
	case 0x331C:	if (illinst & I_SKSZ)	{ id = "sksz"; }	break;
	case 0x333D:	if (illinst & I_CAMR)	{ id = "camr"; }	break;
	case 0x232B:	if (illinst & I_INH)	{ id = "inh"; }		break;
	case 0x3328:	if (illinst & I_ININ)	{ id = "inin"; }	break;
	case 0x3329:	if (illinst & I_INIL)	{ id = "inil"; }	break;
	case 0x332D:	if (illinst & I_INR)	{ id = "inr"; }		break;
	case 0x333B:	if (illinst & I_OMH)	{ id = "omh"; }		break;
	default:
		break;
	}
	if (id) {
		sprintf(errstr, "%s - Is An Invalid Instruction For The COP%s Processor.", id, copstr);
		xerr('o', errstr);
	}
}

/*
 * Search CPU table for a match.
 * Set pointer to CPU type string,
 * bad instruction value, CPU ROM size,
 * and CPU Type number.
 * Return 1 on found or zero for no match.
 */
int
coptype()
{
	char *ptr;
	int i;
	char *ips;

	ips = ip;
	unget(getnb());

	i = 0;
	while ( *(ptr = &cop[i].a_str[0]) ) {
		if (srch(ptr)) {
			sym[2].s_addr = i + 1;
			copstr = cop[i].a_str;
			illinst = cop[i].a_val;
			romsize = cop[i].a_size;
			return(1);
		}
		i++;
	}
	ip = ips;
	return(0);
}

/*
 *Machine specific initialization.
 */

void
minit(void)
{
	/*
	 * Byte Order
	 */
	hilo = 1;

	/*
	 * CPU Type Parameters
	 */
	sym[2].s_addr = 0;
	copstr = "400";
	illinst = 0;
	romsize = S_2048;
	xad = 0;

	/*
	 * (Re)Set Page Size
	 */
	p_mask = 0x3F;

	/*
	 * (Re)Set PAGN Boundary
	 */
	clrexpr(&pagexpr);
	pagexpr.e_addr = 0x0080;
	pagarea = dot.s_area;
	outdp(pagarea, &pagexpr, 0);
}

