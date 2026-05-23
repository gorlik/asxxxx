/* m16adr.c */

/*
 *  Copyright (C) 1989-2025  Alan R. Baldwin
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
#include "m6816.h"

int
addr(struct expr *esp)
{
	int c;
	char *p;
	char *tcp;

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

	if ((c = getnb()) == '#') {
		expr(esp, 0);
		esp->e_mode = T_IMM;
	} else
	if (c == ',') {
		if ((c = admode(xyz)) != 0) {
			esp->e_mode = c;
		} else {
			xerr('a', "A Register X, Y, Or Z Type Is Required.");
		}
	} else {
		unget(c);
		if(admode(e) != 0) {
			comma(1);
			if ((c = admode(xyz)) != 0) {
				esp->e_mode = T_E_I | (c & 0x30);
			} else {
				xerr('a', "A Register X, Y, Or Z Type Is Required.");
			}
		} else {
			expr(esp, 0);
			esp->e_mode = T_EXT;
			if ((c = getnb()) == ',') {
				tcp = ip;
				if ((c = admode(xyz)) != 0) {
					esp->e_mode = c;
				} else {
					ip = --tcp;
				}
			} else {
				unget(c);
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
			return(sp[i].a_val);
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
	register char *ptr;
	ptr = ip;

	while (*ptr && *str) {
		if(ccase[*ptr & 0x007F] != ccase[*str & 0x007F])
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

struct adsym	xyz[] = {	/* all indexed modes */
    {	"x16",	T_X | T_INDX | T_IND16	},
    {	"y16",	T_Y | T_INDX | T_IND16	},
    {	"z16",	T_Z | T_INDX | T_IND16	},
    {	"x8",	T_X | T_INDX | T_IND8	},
    {	"y8",	T_Y | T_INDX | T_IND8	},
    {	"z8",	T_Z | T_INDX | T_IND8	},
    {	"x",	T_X | T_INDX	},
    {	"y",	T_Y | T_INDX	},
    {	"z",	T_Z | T_INDX	},
    {	"",	0x00	}
};

struct adsym	e[] = {		/* e register */
    {	"e",	0x01	},
    {	"",	0x00	}
};

struct adsym	pshm[] = {	/* push on system stack */
    {	"d",	0x01	},
    {	"e",	0x02	},
    {	"x",	0x04	},
    {	"y",	0x08	},
    {	"z",	0x10	},
    {	"k",	0x20	},
    {	"ccr",	0x40	},
    {	"",	0x00	}
};

struct adsym	pulm[] = {	/* pull from system stack */
    {	"ccr",	0x01	},
    {	"k",	0x02	},
    {	"z",	0x04	},
    {	"y",	0x08	},
    {	"x",	0x10	},
    {	"e",	0x20	},
    {	"d",	0x40	},
    {	"",	0x00	}
};

