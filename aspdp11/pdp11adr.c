/* pdp11adr.c */

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

int aindx;
int pcrel;

int
addr(struct expr *esp)
{
	int c, d;
	char *p, *q, *r;
	int indirect;

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
	pcrel = 0;

	/*
	 * Check For Indirection
	 */
	if (((c = getnb()) == '@') || (c == '*')) {
		indirect = S_IND;
	} else {
		indirect = 0;
		unget(c);
	}

	/*
	 * Addressing Mode 0 -> Rn
	 * Addressing Mode 1 -> @Rn
	 * Addressing Mode 2 -> @Rn+
	 */
	p = ip;
 	if (admode(reg)) {
		if ((c = getnb()) == '+') {
			esp->e_mode = S_INC;
		} else {
			esp->e_mode = indirect | S_REG;
			unget(c);
		}
	} else
	/*
	 * Addressing Mode 2 (Rn = 7) -> #N
	 * Addressing Mode 3 (Rn = 7) -> @#A
	 */
	if ((c = getnb()) == '#') {
		if (indirect) {
			expr(esp, 0);
			esp->e_mode = indirect | S_SYM;
		} else {
			p = ip;
			if (((c = getnb()) == '^') &&
			    (ccase[*ip++ & 0x7F]  == 'r')) {
			    	if (tst50(*ip)) {
					esp->e_addr = rad50();
				} else {
					c = getdlm();
					esp->e_addr = rad50();
					if (getnb() != c) {
						xerr('q', "Not RAD50 Or A Missing Delimiter");
					}
				}
			} else {
				ip = p;
				expr(esp,0);
			}
			esp->e_mode = S_IMM;
		}
	} else
	/*
	 * Addressing Mode 1 -> (Rn)
	 * Addressing Mode 2 -> (Rn)+
	 * Addressing Mode 3 -> @(Rn)+
	 */
	if ((c == '(') && admode(reg) && (getnb() == ')')) {
		if ((d = getnb()) == '+') {
			esp->e_mode = indirect | S_INC;
		} else {
			unget(d);
			if (indirect) {	/* @X(Rn) with X Missing (X = 0) */
				esp->e_mode = indirect + S_IDX;
			} else {
				esp->e_mode = S_REG | S_IND;
			}
		}
	} else
	/*
	 * Addressing Mode 4 -> -(Rn)
	 * Addressing Mode 5 -> @-(Rn)
	 */
	if ((c == '-') && ((d = getnb()) == '(') && admode(reg) && (getnb() == ')')) {
			esp->e_mode = indirect | S_DEC;
	} else {
		ip = p;

		/*
		 * Scanning For (Rn)
		 */
		r = NULL;
		q = NULL;
		while (more()) {
			if ((c = getnb()) == ',') {
				break;
			}
			q = ip;
			if ((c == '(') && admode(reg) && ((d = getnb()) == ')')) {
				r = ip;
				break;
			}
			ip = q;
		}
		ip = p;

		if (r != NULL) {
			*(q-1) = 0;
		}
		expr(esp, 0);
		if (r != NULL) {
			*(q-1) = '(';
			ip = r;
		}

		/*
		 * Addressing Mode 6 -> X(Rn)
		 * Addressing Mode 7 -> @X(Rn)
		 */
		if (r != NULL) {
			esp->e_mode = indirect | S_IDX;
		} else {
			/*
			 * Addressing Mode 6 (Rn = 7) -> A
			 * Addressing Mode 7 (Rn = 7) -> @A
			 */
			pcrel = 1;
			aindx = 7;
			esp->e_mode = indirect | S_IDX;
		}
	}
	return (esp->e_mode);
}

int
tst50(int c)
{
	if ((c == ' ') ||
	   ((c >= 'A') && (c <= 'Z')) ||
	   (c == '$') ||
	   (c == '.') ||
	   ((c >= '0') && (c <= '9')) ||
	   (c == '(')) {
	   	return(1);
	} else {
		return(0);
	}
}

int
rad50()
{
	unsigned char c;
	int i, v;
	int d, s;
	struct expr e1;
	char *p, *q;

	for (c=0,s=0,v=0,i=0; i<=2; i++) {
		if (c != 0377) {
			c = get();
			if (c == ' ') { s = 0; } else
			if ((c >= 'A') && (c <= 'Z')) { s = (c - 'A') + 001; } else
			if (c == '$') { s = 033; } else
			if (c == '.') { s = 034; } else
			if ((c >= '0') && (c <= '9')) { s = (c - '0') + 036; } else
			if (c == '(') {
				/*
				 * Isolate the term '(...)' so that
				 * arithmetic delimiting characters
				 * like %,^,&,*,-,+,!,|,/ don't cause
				 * expr() to cough on the evaluation.
				 */
				p = ip - 1;	/* position of LFTERM */
				d = 1;
				while (d != 0) {
					c = getnb();
					if (c == '(') d += 1;
					if (c == ')') d -= 1;
				}
				q = ip;	/* Save position following RTTERM */
				c = *q; /* Save the character following RTTERM */
				*q = 0; /* Make a terminator */
				ip = p; /* Restore pointer to LFTERM and evaluate */
				clrexpr(&e1);
				expr(&e1, 0);
				*q = c;	/* Restore character */
				ip = q;	/* Restore pointer */
				abscheck(&e1);
				s = (int) e1.e_addr;
				if ((s < 000) || (s > 047)) {
					xerr('w', "Invalid RAD50 Character Value");
					s = 0;
				}
			} else {
				unget(c);
				c = 0377;
			}
		}
		v *= 050;
		if (c != 0377) {
			v += s;
		}
	}
	return(v);
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
 *      any --- does str contain c?
 */
int
any(int c, char *str)
{
	while (*str)
		if(*str++ == c)
			return(1);
	return(0);
}

struct adsym	reg[] = {
    {	"r0",	0x00	},	/* regular processor registers */
    {	"r1",	0x01	},
    {	"r2",	0x02	},
    {	"r3",	0x03	},
    {	"r4",	0x04	},
    {	"r5",	0x05	},
    {	"r6",	0x06	},
    {	"r7",	0x07	},
    {	"sp",	0x06	},	/* stack pointer register */
    {	"pc",	0x07	},	/* program counter register */
    {	"%0",	0x00	},	/* alternate form for processor registers */
    {	"%1",	0x01	},
    {	"%2",	0x02	},
    {	"%3",	0x03	},
    {	"%4",	0x04	},
    {	"%5",	0x05	},
    {	"%6",	0x06	},
    {	"%7",	0x07	},
    {	"ac0",	0x08	},	/* floating point registers */
    {	"ac1",	0x09	},
    {	"ac2",	0x0A	},
    {	"ac3",	0x0B	},
    {	"ac4",	0x0C	},
    {	"ac5",	0x0D	},
    {	"f0",	0x08	},
    {	"f1",	0x09	},
    {	"f2",	0x0A	},
    {	"f3",	0x0B	},
    {	"f4",	0x0C	},
    {	"f5",	0x0D	},
    {	"fr0",	0x08	},	/* alternate floating point registers */
    {	"fr1",	0x09	},	/*   From Bell Laboratories V7 Unix   */
    {	"fr2",	0x0A	},
    {	"fr3",	0x0B	},
    {	"fr4",	0x0C	},
    {	"fr5",	0x0D	},
    {	"",	0x00	}
};


