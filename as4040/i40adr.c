/* i40adr.c */

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
#include "i40.h"

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
		expr(esp, 0);
		esp->e_mode = S_IMM;
		return (esp->e_mode);
	}
	unget(c);
	if (admode(reg)) {
		esp->e_addr = aindx;
		esp->e_mode = S_REG;
	} else
	if (admode(regp)) {
		esp->e_addr = aindx;
		esp->e_mode = S_REGP;
	} else {
		expr(esp, 0);
		esp->e_mode = S_EXT;
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

struct	adsym	reg[] = {
    {	"r0",	0x00	},
    {	"r1",	0x01	},
    {	"r2",	0x02	},
    {	"r3",	0x03	},
    {	"r4",	0x04	},
    {	"r5",	0x05	},
    {	"r6",	0x06	},
    {	"r7",	0x07	},
    {	"r8",	0x08	},
    {	"r9",	0x09	},
    {	"r10",	0x0A	},
    {	"r11",	0x0B	},
    {	"r12",	0x0C	},
    {	"r13",	0x0D	},
    {	"r14",	0x0E	},
    {	"r15",	0x0F	},
    {	"",	0000	}
};

struct	adsym	regp[] = {
    {	"rp0",	0x00	},
    {	"rp1",	0x01	},
    {	"rp2",	0x02	},
    {	"rp3",	0x03	},
    {	"rp4",	0x04	},
    {	"rp5",	0x05	},
    {	"rp6",	0x06	},
    {	"rp7",	0x07	},
    {	"",	0000	}
};

struct	adsym	cc[] = {
    {	"nc",	0x40	},	/* no condition */
    {	"tz",	0x11	},	/* test equals zero */
    {	"t0",	0x11	},
    {	"cn",	0x12	},	/* carry equals one */
    {	"c1",	0x12	},
    {	"az",	0x14	},	/* accumulator equals zero */
    {	"a0",	0x14	},
    {	"tn",	0x29	},	/* test equals one */
    {	"t1",	0x29	},
    {	"cz",	0x2A	},	/* carry equals zero */
    {	"c0",	0x2A	},
    {	"an",	0x2C	},	/* accumulator non zero */
    {	"nza",	0x2C	},
    {	"NC",	0x40	},	/* no condition */
    {	"TZ",	0x11	},	/* test equals zero */
    {	"T0",	0x11	},
    {	"CN",	0x12	},	/* carry equals one */
    {	"C1",	0x12	},
    {	"AZ",	0x14	},	/* accumulator equals zero */
    {	"A0",	0x14	},
    {	"TN",	0x29	},	/* test equals one */
    {	"T1",	0x29	},
    {	"CZ",	0x2A	},	/* carry equals zero */
    {	"C0",	0x2A	},
    {	"AN",	0x2C	},	/* accumulator non zero */
    {	"NZA",	0x2C	},
    {	"",	0000	}
};

