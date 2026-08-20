/* m370adr.c */

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

int aindx;

int
addr(struct expr *esp)
{
	int c;
	char *p, *q, *r, *s;

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

	aindx = 0;
	if (admode(reg)) {	/* A, B, SP, ST */
		esp->e_mode = aindx;
		return(esp->e_mode);
	}
	if (Rn()) {		/* Rn, n = 0-255 */
		esp->e_mode = S_R;
		return(esp->e_mode);
	}
	if (Pn()) {		/* Pn, n = 0-255 */
		esp->e_mode = S_P;
		return(esp->e_mode);
	}
	if (((c = getnb()) == '@') && Rn()) {	/* @Rn */
		esp->e_mode = S_IR;
		return(esp->e_mode);
	}

	/* Label(B), N(B), N(SP), N(R) */
	ip = p;
	q = strchr(ip, ',');
	if (q != NULL) *q = 0;
	r = strrchr(ip, '(');
	if (r != NULL) {
		ip = r + 1;
		if (admode(reg) && (getnb() == ')')) {
			s = ip;
			*r = 0;
			ip = p;
			if ((c = getnb()) != '*') ip = p;
			expr(esp);
			switch(aindx) {
			case S_B:
				if (c == '*') {
					esp->e_mode = S_ANB;
				} else {
					esp->e_mode = S_NB;
				}
				break;
			case S_SP:
				esp->e_mode = S_NSP;
				break;
			default:
				esp->e_mode = S_ILL;	break;
			}
			if (q != NULL) *q = ',';
			*r = '(';
			ip = s;
			return(esp->e_mode);
		}
		ip = r + 1;
		if (Rn() && (getnb() == ')')) {
			s = ip;
			*r = 0;
			ip = p;
			expr(esp);
			esp->e_mode = S_NR;	/* N(Rn) */
			if (q != NULL) *q = ',';
			*r = '(';
			ip = s;
			return(esp->e_mode);
		}
	}
	if (q != NULL) *q = ',';

	/* Immediate Numerical Value */
	ip = p;
	if ((c = getnb()) == '#') {
		expr(esp);
		esp->e_mode = S_IMM;
		return (esp->e_mode);
	}
	/* Label or TI ASM370 Numerical Value */
	ip = p;
	if ((c = getnb()) != '*') ip = p;
	expr(esp);
	if (c == '*') {
		esp->e_mode = S_AEXT;
	} else {
		esp->e_mode = S_EXT;
	}
	return (esp->e_mode);
}

/*
 *	Register - Rn
 */
int
Rn(void)
{
	if (RnPn('r') != 0) {
		if (aindx > 255) xerr('a', "Only Rn, n=0-255 Allowed");
		return(1);
	}
	return(0);
}

/*
 *	Port - Pn
 */
int
Pn(void)
{
	if (RnPn('p') != 0) {
		if (aindx > 255) xerr('a', "Only Pn, n=0-255 Allowed");
		return(1);
	}
	return(0);
}

/*
 *	Searching - Rn or Pn
 *
 *	   If first digit is 0
 *	   evaluate as HEX else
 *	   evaluate as DECIMAL
 */
int
RnPn(int rp)
{
	int c, d, n, r;
	char *p;

	p = ip;
	c = ccase[getnb() & 0x7F];
	d = digit(*ip++, 10);
	if ((c == rp) && (d >= 0)) {
		n = d;
		r = (d == 0) ? 16 : 10;
		while ((d = digit(*ip, r)) >= 0) {
			n = r*n + d;
			ip++;
		}
		d = ctype[*ip & 0x7F];
		if ((*ip == 0) || (d == 0) || (d == BINOP)) {
			aindx = n;
			return(1);
		}
	}
	ip = p;
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
 * for a match. Return the addressing value on a match or
 * zero for no match.
 */
int
admode(struct adsym *sp)
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

/*
 * Registers
 */

struct	adsym	reg[] = {
    {	"a",	S_A	},
    {	"b",	S_B	},
    {	"sp",	S_SP	},
    {	"st",	S_ST	},
    {	"",	0000	}
};


