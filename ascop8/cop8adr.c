/* cop8adr.c */

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
#include "cop8.h"

int aindx;

int
addr(struct expr *esp)
{
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

	aindx = 0;
	if ((c = getnb()) == '#') {
		if (admode(regn)) {	/* #r0-#r15, #B, #SP, #X */
			esp->e_addr = aindx | 0xF0;
		}
		if (more()) {
			expr(esp, 0);
		}
		esp->e_mode = S_IMM;
	} else
	if (c == '[') {
		if (admode(regx)) {
			esp->e_addr = aindx;
			esp->e_mode = S_IDX;
		} else {
			xerr('a', "[...] Is Not A Valid Addressing Mode.");
			esp->e_addr = 0;
			esp->e_mode = 0;
		}
		if (getnb() != ']') {
			xerr('q', "Missing ']'.");
		}
	} else {
		unget(c);
		if (admode(rega)) {	/* op  A[, ...] */
			esp->e_addr = aindx;
			esp->e_mode = S_REGA;
		} else
		if (admode(regn)) {	/* op  Rn[, ...] */
			esp->e_addr = aindx;
			esp->e_mode = S_REGN;
		} else {
			expr(esp, 0);
			esp->e_mode = S_EXT;
		}
	}
	return (esp->e_mode);
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

struct	adsym	rega[] = {
    {	"a",	S_A	},
    {	"",	0000	}
};

struct	adsym	regn[] = {
    {	"r0",	0	},
    {	"r1",	1	},
    {	"r2",	2	},
    {	"r3",	3	},
    {	"r4",	4	},
    {	"r5",	5	},
    {	"r6",	6	},
    {	"r7",	7	},
    {	"r8",	8	},
    {	"r9",	9	},
    {	"r10",	10	},
    {	"r11",	11	},
    {	"r12",	12	},
    {	  "x",	S_X	},
    {	"r13",	13	},
    {	  "sp",	S_SP	},
    {	"r14",	14	},
    {	  "b",	S_B	},
    {	"r15",	15	},
    {	  "s",	S_S	},
    {	"",	0000	}
};

struct	adsym	regx[] = {
    {	"b+",	S_IBP1	},
    {	"b-",	S_IBM1	},
    {	"b",	S_IB	},
    {	"x+",	S_IXP1	},
    {	"x-",	S_IXM1	},
    {	"x",	S_IX	},
    {	"",	0000	}
};


