/* m68cfadr.c */

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

int aindx;	/* Value Of Element Found With admode() */

/*
 *	ColdFire Extension Word Format
 *
 *      Indexed Register Indirect Addressing
 *         d8(An,Xi)  OR  (d8,An,Xi)
 *         d8(PC,Xi)  OR  (d8,PC,Xi)
 *
 *   15  14  13  12  11  10   9   8   7   6   5   4   3   2   1   0
 *  +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
 *  | x | x | x | x | x | x | x | 0 | x | x | x | x | x | x | x | x |
 *  +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
 *   \_/ \_________/ \_/ \_____/ \_/ \_____________________________/
 *    |       |       |     |     |                 |
 *    |       |       |     |     |   Two's Complement Displacement Integer
 *    |       |       |     |     |
 *    |       |       |     |      -- 0 -> Valid, 1 -> Address Error
 *    |       |       |     |
 *    |       |       |      -------- Scale 0->1, 1->2, 2->4, 3->Address Error
 *    |       |       |
 *    |       |        -------------- Index Register Size
 *    |       |                         0 = Word, Sign Extended
 *    |       |                         1 = Long
 *    |       |
 *    |        ---------------------- Index Register
 *    |                                 0-7
 *    |
 *     ------------------------------ Index Register Type
 *                                      0 = Data Register
 *                                      1 = Address Register
 */

/*
 * This Routine Determines The Addressing Mode
 * But Does NOT Determine Expression Sizes
 * Unless Explicitly Set By .W Or .L
 */
int
addr(esp, sz, vx, px, xx)
struct expr *esp;
int sz;
int *vx, *px, *xx;
{
	int c, d, s;
	char *p, *ptr, *ips;
	int dl, dr;

	/* fix order of '<', '>', and '#' */
	p = ip;
	if (((c = getnb()) == '<') || (c == '>')) {
		p = ip-1;
		if (getnb() == '#') {
			*p = *(ip-1);
			*(ip-1) = c;
		}
	}
	ip = p;

	*vx = 0;	/* Register Or Code # */
	*px = 0;	/* Paging */
	*xx = 0;	/* Extension Word */

	/*	An	*/
	if (admode(An)) {
		*vx = aindx;
		esp->e_mode = S_An;
		return (esp->e_mode);
	}
	/*	Dn	*/
	if (admode(Dn)) {
		*vx = aindx;
		esp->e_mode = S_Dn;
		return (esp->e_mode);
	}
	/*	#N	*/
	if ((c = getnb()) == '#') {
		p = ip;
		if ((getnb() == '^') && (ccase[getnb()] == 'f')) {
			switch(sz) {
			case A_W:	/* Single Word Floating Point */
				atowrd();
				esp->e_addr = rslt[4];
				break;
			case A_L:	/* Double Word Floating Point */
				atoflt();
				esp->e_addr = (((INT32) rslt[4]) << 16) | ((INT32) rslt[3]);
				break;
			default:
				xerr('q', "Byte Floating Point Is Not Allowed");
				break;
			}
		} else {
			ip = p;
			expr(esp,0);
		}
		*vx = 4;
		esp->e_mode = S_IMM;
		return (esp->e_mode);
	}
	/*	*	*/
	if (c == '*') {
		*vx = 0;
		expr(esp, 0);
		if ((esp->e_mode = espmode(esp, vx, px)) != S_SHRT) {
			xerr('a', "Address Not In Page, Using Long Form");
		}
		return (esp->e_mode);
	}
	/*	(An) / (An)+	*/
	if ((c == '(') && admode(An) && (getnb() == ')')) {
		if ((d = getnb()) == '+') {
			esp->e_mode = S_AINC;
		} else {
			esp->e_mode = S_ARI;
			unget(d);
		}
		*vx = aindx;
		return (esp->e_mode);
	}
	ip = p;
	/*	@An / @An+     */
	if (((c = getnb()) == '@') && admode(An)) {
		if ((d = getnb()) == '+') {
			esp->e_mode = S_AINC;
		} else {
			esp->e_mode = S_ARI;
			unget(d);
		}
		*vx = aindx;
		return(esp->e_mode);
	}
	ip = p;
	/*	-(An)	*/
	if ((getnb() == '-') && (getnb() == '(') && admode(An) && (getnb() == ')')) {
		esp->e_mode = S_ADEC;
		*vx = aindx;
		return (esp->e_mode);
	}
	ip = p;
	/*	-@An	*/
	if ((getnb() == '-') && (getnb() == '@') && admode(An)) {
		esp->e_mode = S_ADEC;
		*vx = aindx;
		return (esp->e_mode);
	}
	ip = p;

	/* Find next argument seperator or EOL */
	while ((c = *ip++) != 0) {
		if ((c == ',') || (c == ';')) {
			break;
		}
	}
	/*
	 * ip is at seperator:
	 *
	 *	1 - save seperator position
	 *	2 - save seperator character
	 *	3 - set EOL at seperator
	 */
	ips = ip - 1;
	s = *ips;
	*ips = 0;

	/*
	 * scan for regular argument
	 *   arg / (arg).W / (arg).L
	 */
	ip = p;
	dl = dr = 0;
	while ((c = getnb()) != 0) {
		if (c == '(') { dl += 1; } else
		if (c == ')') { dr += 1; }
	}
	ip = p;
	if ( ((dl == 0) && (dr == 0)) ||
	   (  (dl == 1) && (dr == 1) && (getnb() == '(') &&
	      !admode(Dn) && !admode(DnW) && !admode(DnL) &&
	      !admode(An) && !admode(AnW) && !admode(AnL) &&
	      !admode(PCreg) ) ) {
		ip = p;
		expr(esp, 0);
		p = ip;
		if (getnb() == '.') {
			switch(getnb()) {
			default:  xerr('a', "Invalid Length Specifier");
			case 'l':
			case 'L': *vx = 1; *px = 0; esp->e_mode = S_LONG;	break;
			case 'w':
			case 'W': *vx = 0; *px = 0; esp->e_mode = S_SHRT;	break;
			}
		} else {	
			esp->e_mode = espmode(esp, vx, px);
			ip = p;
		}
		*ips = s;
		return(esp->e_mode);
	}

	/*
	 * scan for last '(' in this string
	 *  [ before the ',' in the argument or ]
	 *  [ before the argument separater ',' ]
	 *  [ the ';' or the end of line ]
	 * and restore seperator
	 */
	ip = p;
	ptr = strrchr(ip, '(');
	*ips = s;

	/*
	 * Form 1 Modes:
	 *	d(An)   d(An,Xn)   d(PC)   d(PC,Xn)
	 */

	ip = ptr + 1;	/* skip '(' ---------         */
	if (admode(An)) {	/*           |        */
		/* _______________________ d(An)      */
		/* _______________________ d(An,Xn)   */
		/* |                        |  |      */
       	        /*  --------------------    |   -- ip */
		/*                      |   |         */
		switch(anpcidx(esp, xx, p, ptr)) {
		default:
		case 0: esp->e_mode = S_ARID;	*vx = aindx;	break;
		case 1: esp->e_mode = S_ARIDX;	*vx = aindx;	break;
		}
		return (esp->e_mode);
	}

		/* skipped '(' --------------         */
	if (admode(PCreg)) {	/*           |        */
		/* _______________________ d(PC)      */
		/* _______________________ d(PC,Xn)   */
		/* |                        |  |      */
       	        /*  --------------------    |   -- ip */
		/*                      |   |         */
		switch(anpcidx(esp, xx, p, ptr)) {
		default:
		case 0:	esp->e_mode = S_PCID;	*vx = 2;	break;
		case 1: esp->e_mode = S_PCIDX;	*vx = 3;	break;
		}
		return (esp->e_mode);
	}

	/*
	 * scan for first '(' in this string
	 */
	ptr = strchr(p, '(');

	/*
	 * Form 2 Modes:
	 *	(d,An)   (d,An,Xn)   (d,PC)   (d,PC,Xn)
	 */

	ip = ips + 1;	/* skip ',' ---------------         */
	if (admode(An)) {	/*                 |        */
		/* ____________________________ (d,An)      */
		/* ____________________________ (d,An,Xn)   */
		/*                              ||   |      */
       	        /*                         -----+|    -- ip */
		/*                        |     |           */
		switch(anpcidx(esp, xx, ptr+1, ptr)) {
		default:
		case 0: esp->e_mode = S_ARID;	*vx = aindx;	break;
		case 1: esp->e_mode = S_ARIDX;	*vx = aindx;	break;
		}
		return (esp->e_mode);
	}

		/* skipped ',' --------------------         */
	if (admode(PCreg)) {	/*                 |        */
		/* ____________________________ (d,PC)      */
		/* ____________________________ (d,PC,Xn)   */
		/*                              ||   |      */
       	        /*                         -----+|    -- ip */
		/*                        |     |           */
		switch(anpcidx(esp, xx, ptr+1, ptr)) {
		default:
		case 0:	esp->e_mode = S_PCID;	*vx = 2;	break;
		case 1: esp->e_mode = S_PCIDX;	*vx = 3;	break;
		}
		return (esp->e_mode);
	}

	ip = p;
	expr(esp, 0);
	esp->e_mode = espmode(esp, vx, px);
	return (esp->e_mode);
}

int
faddr(esp, fsz, vx)
struct expr *esp;
int fsz;
int *vx;
{
	int c;

	/*	FPn	*/
	if (admode(FPn)) {
		*vx = aindx;
		esp->e_mode = S_FPn;
		return (esp->e_mode);
	} else
	/*	#N	*/
	if ((c = getnb()) == '#') {
		switch(fsz) {
		case F_B:	/* #__.B */
		case F_W:	/* #__.W */
		case F_L:	/* #__.L */
			expr(esp, 0);
			break;
		default:
		case F_S:	/* #__.S */
			atoflt();
			break;
		case F_D:	/* #__.D */
			atoflt();
			xerr('a', "Immediate .D/.X/.P Are Not Supported");
			break;
		}
		esp->e_mode = S_FIMM;
		return(esp->e_mode);
	}
	unget(c);
	return (0);
}

/*
 * Evaluate For Direct Page Modes
 */
int
espmode(esp, vx, px)
struct expr *esp;
int *vx, *px;
{
	int mode;

	/* LOW Page Constants */
	if (autodpcnst
	    && (!esp->e_flag)
	    && (esp->e_base.e_ap == NULL)
	    && ((esp->e_addr & ~0x7FFF) == 0)) {
		*vx = 0;
		*px = 0;
		mode = S_SHRT;
	} else
	/* HIGH Page Constants */
	if (autodpcnst
	    && (!esp->e_flag)
	    && (esp->e_base.e_ap == NULL)
	    && ((esp->e_addr & ~0x7FFF) == ~0x7FFF)) {
		*vx = 0;
		*px = 0;
		mode = S_SHRT;
	} else
	/* Local Symbols In LOW Page */
	if (autodpsmbl
	    && (!esp->e_flag)
	    && (dpglo != NULL)
	    && (esp->e_base.e_ap == dpglo)) {
	    	*vx = 0;
		*px = 1;
		mode = S_SHRT;
	} else
	/* Local Symbols In HIGH Page */
	if (autodpsmbl
	    && (!esp->e_flag)
	    && (dpghi != NULL)
	    && (esp->e_base.e_ap == dpghi)) {
	    	*vx = 0;
		*px = 2;
		mode = S_SHRT;
	} else
	/* External Symbols In LOW Page */
	if (autodpsmbl
	    && (esp->e_flag)
	    && (dpglo != NULL)
	    && (esp->e_base.e_sp->s_area == dpglo)) {
	    	*vx = 0;
		*px = 1;
		mode = S_SHRT;
	} else
	/* External Symbols IN HIGH Page */
	if (autodpsmbl
	    && (esp->e_flag)
	    && (dpghi != NULL)
	    && (esp->e_base.e_sp->s_area == dpghi)) {
	    	*vx = 0;
		*px = 2;
		mode = S_SHRT;
	/* Everything Else */
	} else {
		*vx = 1;
		*px = 0;
		mode = S_LONG;
	}
	return(mode);
}

int
anpcidx(esp, xx, p, ptr)
struct expr *esp;
int *xx;
char *p, *ptr;
{
	char *ips;
	int mode;


	/*
	 * (Rn) found:
	 *
	 *	1 - default mode
	 *	2 - save ip position
	 *	3 - set EOL at '(' of (Rn)
	 *	4 - evaluate from beginning
	 */
	mode = 0;
	ips = ip;
	*ptr = 0;
	ip = p;
	/*
	 * evaluate d of d(Rn)
	 */
	if (more()) {
		expr(esp, 0);
	}
	/*
	 * restore '(' and continue at separator
	 */
	*ptr = '(';
	ip = ips;
	/*
	 * check for index
	 */
	if (comma(0)) {
		/*
		 * evaluate Xi of d(Rn,Xi)
		 */
		*xx |= xi();
		mode = 1;
	}
	if (getnb() != ')') {
		qerr();
	}
	return(mode);
}

/*
 * Extended Value For (Rn,Xi)
 *
 *	/---------- Dn(0) Or An(1)
 *	|  /------- Index Register #
 *	|  |  /---- Word(0) Or Long(1)
 *	|  |  |
 *	R NNN S 000 0000 0000
 */
int
xi()
{
	int ev, aix;
	struct expr esp;

	ev = 0;
	aix = aindx;	/* Save aindx */

	if (admode(DnL)) {	/* Long */
		ev = 0x0800;	/* Dn.L */
	} else
	if (admode(DnW)) {	/* Word */
		ev = 0x0000;	/* Dn.W */
	} else
	if (admode(Dn)) {	/* Default To Word */
		ev = 0x0000;	/* Dn */
	} else
	if (admode(AnL)) {	/* Long */
		ev = 0x8800;	/* An.L */
	} else
	if (admode(AnW)) {	/* Word */
		ev = 0x8000;	/* An.W */
	} else
	if (admode(An)) {	/* Default To Word */
		ev = 0x8000;	/* An */
	} else {
		xerr('q', "Index Must Be D0-D7 Or A0-A7 Optional .W Or .L");
	}
	ev |= (aindx << 12);	/* Register Number */

	aindx = aix;	/* Restore aindx */

	if (getnb() == '*') {	/* Optional Scale Factor */
		clrexpr(&esp);
		expr(&esp, 0);
		if (is_abs(&esp)) {
			switch(esp.e_addr) {
			case 1:	ev |= 0x0000;	break;
			case 2:	ev |= 0x0200;	break;
			case 4:	ev |= 0x0400;	break;
			default:
				xerr('q', "Allowed Scale Values Are 1,2, Or 4");
				break;
			}
		} else {
			xerr('q', "Scale Argument Must Be A Constant");
		}
	} else {
		unget('*');
	}

	return(ev);
}

/*
 * When building a table that has variations of a common
 * symbol always start with the most complex symbol first.
 * for example if x, x+, and x++ are in the same table
 * the order should be x++, x+, and then x.  The search
 * order is then most to least complex.
 */

/*
 * When searching symbol tables that contain characters
 * not of type LTR16, eg with '-' or '+', always search
 * the more complex symbol tables first. For example:
 * searching for x+ will match the first part of x++,
 * a false match if the table with x+ is searched
 * before the table with x++.
 */

/*
 * Enter admode() to search a specific addressing mode table
 * for a match. Return (1) for a match, (0) for no match.
 * 'aindx' contains the value of the addressing mode.
 */
int
admode(sp)
struct adsym *sp;
{
	char *ptr;
	int i;
	char *ips;

	ips = ip;
	unget(getnb());

	i = 0;
	while ( *(ptr = &sp[i].a_str[0]) ) {
		if (srch(ptr)) {
			aindx = sp[i].a_val;
			return(1);
		}
		i++;
	}
	ip = ips;
	return(0);
}

/*
 *	srch --- does string match ?
 */
int
srch(str)
char *str;
{
	char *ptr;
	ptr = ip;

	while (*ptr && *str) {
		if (ccase[*ptr & 0x007F] != ccase[*str & 0x007F])
			break;
		ptr++;
		str++;
	}
	if (ccase[*ptr & 0x007F] == ccase[*str & 0x007F]) {
		ip = ptr;
		return(1);
	}
	if (!*str) {
		if (!(ctype[*ptr & 0x007F] & LTR16)) {
			ip = ptr;
			return(1);
		}
	}
	return(0);
}

struct adsym	Dn[] = {
    /* UnSized */
    {	"d0",		0x00	},
    {	"d1",		0x01	},
    {	"d2",		0x02	},
    {	"d3",		0x03	},
    {	"d4",		0x04	},
    {	"d5",		0x05	},
    {	"d6",		0x06	},
    {	"d7",		0x07	},
    {	"",		0	}
};

struct adsym	DnW[] = {
    /* Word Sized */
    {	"d0.w",		0x00	},
    {	"d1.w",		0x01	},
    {	"d2.w",		0x02	},
    {	"d3.w",		0x03	},
    {	"d4.w",		0x04	},
    {	"d5.w",		0x05	},
    {	"d6.w",		0x06	},
    {	"d7.w",		0x07	},
    {	"",		0	}
};

struct adsym	DnL[] = {
    /* Long Sized */
    {	"d0.l",		0x00	},
    {	"d1.l",		0x01	},
    {	"d2.l",		0x02	},
    {	"d3.l",		0x03	},
    {	"d4.l",		0x04	},
    {	"d5.l",		0x05	},
    {	"d6.l",		0x06	},
    {	"d7.l",		0x07	},
    {	"",		0	}
};

struct adsym	DnU[] = {
    /* Long Sized */
    {	"d0.u",		0x00	},
    {	"d1.u",		0x01	},
    {	"d2.u",		0x02	},
    {	"d3.u",		0x03	},
    {	"d4.u",		0x04	},
    {	"d5.u",		0x05	},
    {	"d6.u",		0x06	},
    {	"d7.u",		0x07	},
    {	"",		0	}
};

struct adsym	An[] = {
    /* Unsized */
    {	"a0",		0x00	},
    {	"a1",		0x01	},
    {	"a2",		0x02	},
    {	"a3",		0x03	},
    {	"a4",		0x04	},
    {	"a5",		0x05	},
    {	"a6",		0x06	},
    {	"a7",		0x07	},
    {	"sp",		0x07	},
    {	"",		0	}
};

struct adsym	AnW[] = {
    /* Word Sized */
    {	"a0.w",		0x00	},
    {	"a1.w",		0x01	},
    {	"a2.w",		0x02	},
    {	"a3.w",		0x03	},
    {	"a4.w",		0x04	},
    {	"a5.w",		0x05	},
    {	"a6.w",		0x06	},
    {	"a7.w",		0x07	},
    {	"sp.w",		0x07	},
    {	"",		0	}
};

struct adsym	AnL[] = {
    /* Long Sized */
    {	"a0.l",		0x00	},
    {	"a1.l",		0x01	},
    {	"a2.l",		0x02	},
    {	"a3.l",		0x03	},
    {	"a4.l",		0x04	},
    {	"a5.l",		0x05	},
    {	"a6.l",		0x06	},
    {	"a7.l",		0x07	},
    {	"sp.l",		0x07	},
    {	"",		0	}
};

struct adsym	AnU[] = {
    /* Long Sized */
    {	"a0.u",		0x00	},
    {	"a1.u",		0x01	},
    {	"a2.u",		0x02	},
    {	"a3.u",		0x03	},
    {	"a4.u",		0x04	},
    {	"a5.u",		0x05	},
    {	"a6.u",		0x06	},
    {	"a7.u",		0x07	},
    {	"sp.u",		0x07	},
    {	"",		0	}
};

struct adsym	Sreg[] = {
    {	"ccr",		S_CCR	},
    {	"sr",		S_SR	},
    {	"usp",		S_USP	},
    {	"",		0	}
};

struct adsym	Creg[] = {
    {	"cacr",		0x0002	},
    {	"asid",		0x0003	},
    {	"acr0",		0x0004	},
    {	"acr1",		0x0005	},
    {	"acr2",		0x0006	},
    {	"acr3",		0x0007	},
    {	"mmubar",	0x0008	},
    /*---*/
    {	"vbr",		0x0801	},
    {	"pc",		0x080F	},
    /*---*/
    {	"rombar0",	0x0C00	},
    {	"rombar1",	0x0C01	},
    {	"rambar0",	0x0C04	},
    {	"rambar1",	0x0C05	},
    {	"mpcr",		0x0C0C	},
    {	"edrambar",	0x0C0D	},
    {	"secmbar",	0x0C0E	},
    {	"mbar",		0x0C0F	},
    /*---*/
    {	"pcr1u0",	0x0D02	},
    {	"pcr1l0",	0x0D03	},
    {	"pcr2u0",	0x0D04	},
    {	"pcr2l0",	0x0D05	},
    {	"pcr3u0",	0x0D06	},
    {	"pcr3l0",	0x0D07	},
    /*---*/
    {	"pcr1u1",	0x0D0A	},
    {	"pcr1l1",	0x0D0B	},
    {	"pcr2u1",	0x0D0C	},
    {	"pcr2l1",	0x0D0D	},
    {	"pcr3u1",	0x0D0E	},
    {	"pcr3l1",	0x0D0F	},
    {	"",		0	}
};

struct adsym	PCreg[] = {
    {	"pc",		0x00	},
    {	"",		0	}
};

struct adsym	ACCn[] = {
    /* Unsized */
    {	"acc0",		0x00	},
    {	"acc1",		0x01	},
    {	"acc2",		0x02	},
    {	"acc3",		0x03	},
    {	"",		0	}
};

struct adsym	MACR[] = {
    {	"acc0",		0x00	},
    {	"acc1",		0x01	},
    {	"acc2",		0x02	},
    {	"acc3",		0x03	},
    {	"accext01",	0x04	},
    {	"accext23",	0x05	},
    {	"acc",		0x06	},
    {	"macsr",	0x07	},
    {	"mask",		0x08	},
    {	"",		0	}
};

struct adsym	FPn[] = {
    {	"fp0",		0x00	},
    {	"fp1",		0x01	},
    {	"fp2",		0x02	},
    {	"fp3",		0x03	},
    {	"fp4",		0x04	},
    {	"fp5",		0x05	},
    {	"fp6",		0x06	},
    {	"fp7",		0x07	},
    {	"",		0	}
};

struct adsym	FCR[] = {
    {	"fpiar",	 0x01	},
    {	"fpsr",		 0x02	},
    {	"fpcr",		 0x04	},
    {	"",		0	}
};

struct adsym	SHL[] = {
    {	"dc",		0x01	},
    {	"ic",		0x02	},
    {	"bc",		0x03	},
    {	"",		0	}
};

