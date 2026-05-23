/* s26adr:c */

/*
 *  Copyright (C) 2005-2025  Alan R. Baldwin
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
#include "s2650.h"

int aindx;

int
addr(struct expr *esp)
{
	int c, d;
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
	if ((c = getnb()) != ',') {
		unget(c);
	}
	if ((c = getnb()) == '#') {
		expr(esp, 0);
		esp->e_mode = S_IMMED;
	} else
	if ((c == '@') || (c == '[')) {
		aindx = 0x80;	/* Indirect Bit */
		expr(esp, 0);
		if ((d = getnb()) == ',') {
			if (!admode(ireg)) {
				aerr();
			}
			esp->e_mode = S_INDX;
		} else {
			unget(d);
			esp->e_mode = S_EXT;
		}
		if (c == '[') {
			if (getnb() != ']') {
				aerr();
			}
		}
	} else {
		unget(c);
		if (admode(reg)) {
			esp->e_mode = S_REG;
		} else
		if (admode(cc)) {
			esp->e_mode = S_CC;
		} else {
			expr(esp, 0);
			if ((d = getnb()) == ',') {
				if (!admode(ireg)) {
					aerr();
				}
				esp->e_mode = S_INDX;
			} else {
				unget(d);
				esp->e_mode = S_EXT;
			}
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
			aindx |= sp[i].a_val;
			return(aindx);
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

struct adsym	cc[] = {	/* Condition Codes */
    {	".eq.",	0x100	},
    {	".gt.",	0x101	},
    {	".lt.",	0x102	},
    {	".un.",	0x103	},
    {	"",	0x000	}
};

struct adsym	reg[] = {	/* r0 - r3 */
    {	"r0",	0x100	},
    {	"r1",	0x101	},
    {	"r2",	0x102	},
    {	"r3",	0x103	},
    {	"",	0x000	}
};

struct adsym	ireg[] = {	/* index register set */
    {	"+r0",	0x120	},	/* +r0  -->>  +r3 */
    {	"+r1",	0x121	},
    {	"+r2",	0x122	},
    {	"+r3",	0x123	},
    {	"r0+",	0x120	},	/* r0+  -->>  r3+ */
    {	"r1+",	0x121	},
    {	"r2+",	0x122	},
    {	"r3+",	0x123	},
    {	"-r0",	0x140	},	/* -r0  -->>  -r3 */
    {	"-r1",	0x141	},
    {	"-r2",	0x142	},
    {	"-r3",	0x143	},
    {	"r0-",	0x140	},	/* r0-  -->>  r3- */
    {	"r1-",	0x141	},
    {	"r2-",	0x142	},
    {	"r3-",	0x143	},
    {	"r0",	0x160	},	/* r0   -->>   r3 */
    {	"r1",	0x161	},
    {	"r2",	0x162	},
    {	"r3",	0x163	},
    {	"",	0x000	}
};


