/* R78K0ADR.C */

/*
 *  Copyright (C) 2019-2025  Alan R. Baldwin
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
#include "r78k0.h"

int
addr(struct expr *esp, int *aindx)
{
	int amode;
	int c;
	char *p;

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

	*aindx = 0;
	if (admode(reg8, aindx)) {
		amode = S_REG8;
	} else
	if (admode(reg16, aindx)) {
		amode = S_REG16;
	} else
	if (admode(spcl, aindx)) {
		amode = S_SPCL;
	} else
	if ((c = getnb()) == '[') {
		if (admode(reg16, aindx) == 0) {
			xerr('a', "Missing 16-Bit register argument");
		}
		c = getnb();
		if ((c == '+') || (c == ',')) {
			if (admode(reg8, aindx)) {
				amode = S_IHLR;
			} else {
				expr(esp,0);
				amode = S_IDXB;
			}
		} else {
			unget(c);
			amode = S_IDX;
		}
		if (getnb() != ']') {
			xerr('q', "Missing ']'");
		}
	} else
	if (c == '#') {
		expr(esp, 0);
		amode = S_IMM;
	} else
	if (c == '!') {
		expr(esp, 0);
		amode = S_AEXT;
	} else
	if (c == '@') {
		expr(esp, 0);
		amode = addrmode(esp);
		if (is_abs(esp)) {
			if((amode != S_SADDR) && (amode != S_SADFR)) {
				xerr('a', "Address is outside of SADDR Range");
			}
		}
		amode = S_SADDR;
	} else
	if (c == '*') {
		expr(esp, 0);
		amode = addrmode(esp);
		if (is_abs(esp)) {
			if((amode != S_SFR) && (amode != S_SADFR)) {
				xerr('a', "Address is outside of SFR Range");
			}
		}
		amode = S_SFR;
	} else {
		unget(c);
		expr(esp, 0);
		amode = addrmode(esp);
	}
	return (amode);
}

int
addrmode(struct expr *esp)
{
	a_uint v;

	if (is_abs(esp)) {
		v = (esp->e_addr & a_mask);
		/*
		 * SADDR Addressing 0xFE20 to 0xFEFF (240 bytes)
		 */
#ifdef	LONGINT
		if ((v >= (a_uint) 0x0000FE20l) && (v <= (a_uint) 0x0000FEFFl)) {
#else
		if ((v >= (a_uint) 0x0000FE20) && (v <= (a_uint) 0x0000FEFF)) {
#endif
			return(S_SADDR);
		} else
		/*
		 * SADDR/SFR Addressing 0xFF00 to 0xFF1F (16 bytes)
		 */
#ifdef	LONGINT
		if ((v >= (a_uint) 0x0000FF00l) && (v <= (a_uint) 0x0000FF1Fl)) {
#else
		if ((v >= (a_uint) 0x0000FF00) && (v <= (a_uint) 0x0000FF1F)) {
#endif
			return(S_SADFR);
		} else
		/*
		 * SFR Addressing 0xFF20 to 0xFFCF (192 bytes)
		 */
#ifdef	LONGINT
		if ((v >= (a_uint) 0x0000FF20l) && (v <= (a_uint) 0x0000FFCFl)) {
#else
		if ((v >= (a_uint) 0x0000FF20) && (v <= (a_uint) 0x0000FFCF)) {
#endif
			return(S_SFR);
		} else 
		/*
		 * SFR Addressing 0xFFE0 to 0xFFFF ( 32 bytes)
		 */
#ifdef	LONGINT
		if ((v >= (a_uint) 0x0000FFE0l) && (v <= (a_uint) 0x0000FFFFl)) {
#else
		if ((v >= (a_uint) 0x0000FFE0) && (v <= (a_uint) 0x0000FFFF)) {
#endif
			return(S_SFR);
		} else
		/*
		 * Extended Addressing 0x0000 to 0xFE17 (65040 bytes) 
		 * Extended Addressing 0xFFD0 to 0xFFDF (16 bytes)
		 */
		{
			return(S_EXT);
		}
	} else {
		if (zpg != NULL) {
			if (esp->e_flag) {
				if (esp->e_base.e_sp->s_area == zpg) {
					return(S_SFR);	/* ___  (*)arg */
				}
			} else {
				if (esp->e_base.e_ap == zpg) {
					return(S_SFR);	/* ___  (*)arg */
				}
			}
		}
		return(S_EXT);
	}
}

int
addrext(struct expr *esp, int *aindx, int *cidx, int *eidx)
{
	int c, t;
	char *p, *q;

	p = q = ip;
	while ((*q != 0) && (*q != ';')) {
		q++;
	}
	*eidx = (int) (q - ip);
	c =*q;
	*q = 0;
	if ((q = strrchr(ip, ',')) != NULL) {
		*cidx = (int) (q - ip);
		ip += *cidx + 1;
		t = addr(esp, aindx);
	} else {
		*cidx = 0;
		t = 0;
	}
	*(p + *eidx) = c;
	return(t);
}

void
addrbit(struct expr *esp1, int *aindx1, int *amode1, struct expr *esp2, int *aindx2, int *amode2, int *eidx)
{
	int c, i, j;
	char *p, *q;
	char *qdot, *qdot1, *qdot2;
	int qlen1, qlen2;
	int cnt;

	p = q = ip;
	while ((*q != 0) && (*q != ';')) {
		q++;
	}
	*eidx = (int) (q - ip);
	c =*q;
	*q = 0;
	if ((q = strrchr(ip, ',')) != NULL) {
		/* Alternate Mode  -  ****,#bit */
		*amode1 = addr(esp1, aindx1);
		comma(1);
		*amode2 = addr(esp2, aindx2);
	} else {
		/* Bit Mode  -  name.bit */
		for (q=ip+1,cnt=0; *q!=0; q++) {
			if (*q == '.') {
				if (ctype[*(q+1) & 0x7F] & (DIGIT | LETTER)) {
					cnt += 1;
				}
			}
		}
		if (cnt < 1) {
			xerr('a', "Missing .??? argument");
		} else
		if (cnt == 1) {
			q = strchr(ip+1, '.');
			*q = 0;
			*amode1 = addr(esp1, aindx1);
			*q = '.';
			ip = q + 1;
			*amode2 = addr(esp2, aindx2);
			switch(*amode2) {
			case S_SFR:
			case S_SADDR:
			case S_EXT:
			case S_AEXT:
				*amode2 = S_IMM;
				break;
			default:
				break;
			}
		} else {
			qdot  = NULL;
			qdot1 = NULL;
			qdot2 = NULL;
			qlen1 = 0;
			qlen2 = 0;
			/*
			 * Scan all name combinations for defined
			 * addressing modes, symbols, or labels.
			 */
			for (i=0; i<cnt; i++) {
				for (j=0,q=p; j<=i; j++) {
					q = strchr(q+1, '.');
				}
				*q = 0;
				ip = p;
				*amode1 = argdot(esp1, aindx1, 0);
				ip = q+1;
				*amode2 = dotarg(esp2, aindx2, 0);
				/* Both arguments exist */
				if (*amode1 && *amode2) {
					qdot1 = qdot2 = q;
					*q = '.';
					break;
				}
				/* Arg 1 found */
				if (*amode1) {
					if ((qdot1 == 0) ||  (q > qdot1)) {
						qdot1 = q;
						qlen1 = strlen(p);
					}
				}
				/* Arg 2 found */
				if (*amode2) {
					if ((qdot2 == 0) ||  (q < qdot2)) {
						qdot2 = q;
						qlen2 = strlen(q+1);
					}
				}
				*q = '.';
			}
			/* No arguments defined */
			/* (arbitrary selection) */
			if ((qdot1 == NULL) && (qdot2 == NULL)) {
				qdot = strchr(p+1, '.');
			} else
			/* Both arguments defined */
			if (qdot1 == qdot2) {
				qdot = qdot1;
			} else
			/* Only 1st argument defined */
			if (qdot1 && (qdot2 == NULL)) {
				qdot = qdot1;
			} else
			/* Only 2nd argument defined */
			if ((qdot1 == NULL) && qdot2) {
				qdot = qdot2;
			} else
			/* Use longer argument name */
			/* (arbitrary selection) */
			if (qlen1 > qlen2) {
				qdot = qdot1;
			} else {
				qdot = qdot2;
			}
			*qdot = 0;
			ip = p;
			*amode1 = argdot(esp1, aindx1, pass);
			ip = qdot+1;
			*amode2 = dotarg(esp2, aindx2, pass);
			*qdot = '.';
		}
	}
	*(p + *eidx) = c;
	return;
}

int
argdot(struct expr *esp, int *aindx, int flag)
{
	char *iptr;
	int amode;

	iptr = ip;
	/* Rn.---- */
	if (admode(reg8,aindx)) {
		return(S_REG8);
	}
	ip = iptr;
	/* SPCL.---- */
	if (admode(spcl,aindx)) {
		return(S_SPCL);
	}
	ip = iptr;
	/* [...].---- */
	if (getnb() == '[') {
		if (admode(reg8, aindx)) {
			if (getnb() != ']') {
				xerr('q', "Missing ']'");
			}
			return(S_REG8);
		} else
		if (admode(reg16, aindx)) {
			if (getnb() != ']') {
				xerr('q', "Missing ']'");
			}
			return(S_REG16);
		} else
		if (admode(spcl, aindx)) {
			if (getnb() != ']') {
				xerr('q', "Missing ']'");
			}
			return(S_SPCL);
		} else {
			xerr('a', "[???] argument error");
			if (getnb() != ']') {
				xerr('q', "Missing ']'");
			}
		}
	}
	ip = iptr;
	/* ****.---- */
	amode = 0;
	if (flag == 0) {
		if (slookup(ip)) {
			return(S_EXT);
		}
	} else {
		expr(esp, 0);
		amode = addrmode(esp);
	}
	return(amode);
}

int
dotarg(struct expr *esp, int *aindx, int flag)
{
	*aindx = 0;
	/* ----.**** */
	if (flag == 0) {
		if (slookup(ip)) {
			return(S_IMM);
		}
	} else {
		expr(esp, 0);
		return(S_IMM);
	}
	return(0);
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
 * for a match. Return 1 on a match or 0 for no match.
 */
int
admode(struct adsym *sp, int *aindx)
{
	char *ptr;
	int i;
	char *ips;

	ips = ip;
	unget(getnb());

	i = 0;
	while ( *(ptr = &sp[i].a_str[0]) ) {
		if (srch(ptr)) {
			*aindx = sp[i].a_val;
			return(1);
		}
		i++;
	}
	ip = ips;
	return(0);
}

/*
 *      srch --- does string match ?
 */
int
srch(char *str)
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

	if (!*str)
		if (!(ctype[*ptr & 0x007F] & LTR16)) {
			ip = ptr;
			return(1);
		}
	return(0);
}

struct adsym	reg8[] = {	/* byte registers */
    {	"x",	REG8_X	},
    {	"a",	REG8_A	},
    {	"c",	REG8_C	},
    {	"b",	REG8_B	},
    {	"e",	REG8_E	},
    {	"d",	REG8_D	},
    {	"l",	REG8_L	},
    {	"h",	REG8_H	},
    {	"r0",	REG8_X	},
    {	"r1",	REG8_A	},
    {	"r2",	REG8_C	},
    {	"r3",	REG8_B	},
    {	"r4",	REG8_E	},
    {	"r5",	REG8_D	},
    {	"r6",	REG8_L	},
    {	"r7",	REG8_H	},
    {	"",	0x00	}
};

struct adsym	reg16[] = {	/* word registers */
    {	"ax",	REG16_AX	},
    {	"bc",	REG16_BC	},
    {	"de",	REG16_DE	},
    {	"hl",	REG16_HL	},
    {	"rp0",	REG16_AX	},
    {	"rp1",	REG16_BC	},
    {	"rp2",	REG16_DE	},
    {	"rp3",	REG16_HL	},
    {	"",	0x00		}
};

struct adsym	rb[] = {	/* register bank */
    {	"rb0",	RB0	},
    {	"rb1",	RB1	},
    {	"rb2",	RB2	},
    {	"rb3",	RB3	},
    {	"",	0x00	}
};

struct adsym	spcl[] = {	/* other designations */
    {	"cy",	SPCL_CY		},
    {	"sp",	SPCL_SP		},
    {	"psw",	SPCL_PSW	},
    {	"",	0x00		}
};

