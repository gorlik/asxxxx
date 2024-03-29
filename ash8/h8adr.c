/* h8adr.c */

/*
 *  Copyright (C) 1994-2021  Alan R. Baldwin
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
#include "h8.h"

int aindx;

int
addr(esp)
struct expr *esp;
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
		if (esp->e_flag || esp->e_base.e_ap) {
			esp->e_mode = S_IMMW;
		} else {
			if (	((esp->e_addr & 0xFF80) == 0xFF80) ||
				((esp->e_addr & 0x00FF) == esp->e_addr)
				) {
				esp->e_mode = S_IMMB;
			} else {
				esp->e_mode = S_IMMW;
			}
		}
	} else
	if (c == '@') {
		if ((c = getnb()) == '@') {
			addr1(esp);
			if ((esp->e_mode != S_EXT) && (esp->e_mode != S_DIR)) {
				xerr('a', "An address is required.");
			}
			esp->e_mode = S_INDM;
		} else
		if (c == '[') {
			expr(esp, 0);
			if ((c = getnb()) == ',') {
				if (!admode(wordreg)) {
					xerr('a', "Valid word registers are R0 -> R7, and SP.");
				}
			} else {
				unget(c);
				xerr('a', "Second argument required.");
			}
			esp->e_mode = S_INDO;
			if (getnb() != ']') {
				xerr('a', "Missing ']'.");
			}
		} else {
			unget(c);
			addr1(esp);
			switch(esp->e_mode) {
			case S_BREG:	/* Register Indirect */
				xerr('a', "Byte registers are invalid.");
				aindx &= ~0x0008;
				esp->e_mode = S_INDR;
				break;
			
			case S_WREG:	/* Register Indirect */
				esp->e_mode = S_INDR;
				break;

			case S_INDI:	/* Post-Increment Register Indirect */
				break;

			case S_INDD:	/* Pre-Decrement Register Indirect */
				break;

			case S_EXT:	/* Extended Addressing */
				break;

			default:	/* Default to Extended Adrressing */
				esp->e_mode = S_EXT;
				break;
			}
		}
	} else
	if (c == '*') {
		if ((c = getnb()) == '@') {
			if ((c = getnb()) == '@') {
				addr1(esp);
				esp->e_mode = S_INDM;
			} else {
				unget(c);
				addr1(esp);
				esp->e_mode = S_DIR;
			}
		} else {
			unget(c);
			addr1(esp);
			esp->e_mode = S_DIR;
		}
		if ((esp->e_mode != S_EXT) && (esp->e_mode != S_DIR)) {
			xerr('a', "An address is required.");
		}
	} else {
		unget(c);
		addr1(esp);
		switch(esp->e_mode) {
		case S_BREG:	/* Byte Register */
			break;

		case S_WREG:	/* Word Register */
			break;

		case S_INDI:	/* Post-Increment Register Indirect */
			xerr('a', "Rn+ is invalid.");
			break;

		case S_INDD:	/* Pre-Decrement Register Indirect */
			xerr('a', "-Rn is invalid.");
			break;

		case S_CREG:	/* CCR Register */
			break;

		case S_EXT:	/* Extended Addressing */
			break;

		default:	/* Default to Extended Adrressing */
			esp->e_mode = S_EXT;
			break;
		}
	}
	return (esp->e_mode);
}

int
addr1(esp)
struct expr *esp;
{
	if (admode(autoinc)) {
		esp->e_mode = S_INDI;
	} else
	if (admode(autodec)) {
		esp->e_mode = S_INDD;
	} else
	if (admode(bytereg)) {
		esp->e_mode = S_BREG;
	} else
	if (admode(wordreg)) {
		esp->e_mode = S_WREG;
	} else
	if (admode(ccr_reg)) {
		esp->e_mode = S_CREG;
	} else {
		expr(esp, 0);
		esp->e_mode = S_EXT;
		if ((!esp->e_flag)
		    && (esp->e_base.e_ap == NULL)
		    && ((esp->e_addr & 0xFF00) == 0xFF00)) {
			esp->e_mode = S_DIR;
		}
		if ((!esp->e_flag)
		    && (zpg != NULL)
		    && (esp->e_base.e_ap == zpg)) {
			esp->e_mode = S_DIR;
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
 *      srch --- does string match ?
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

	if (!*str)
		if (!(ctype[*ptr & 0x007F] & LTR16)) {
			ip = ptr;
			return(1);
		}
	return(0);
}

struct adsym	bytereg[] = {	/* any byte register */
    {	"r0h",	0x00	},
    {	"r0l",	0x08	},
    {	"r1h",	0x01	},
    {	"r1l",	0x09	},
    {	"r2h",	0x02	},
    {	"r2l",	0x0A	},
    {	"r3h",	0x03	},
    {	"r3l",	0x0B	},
    {	"r4h",	0x04	},
    {	"r4l",	0x0C	},
    {	"r5h",	0x05	},
    {	"r5l",	0x0D	},
    {	"r6h",	0x06	},
    {	"r6l",	0x0E	},
    {	"r7h",	0x07	},
    {	"r7l",	0x0F	},
    {	"sph",	0x07	},
    {	"spl",	0x0F	},
    {	"",	0x00	}
};

struct adsym	wordreg[] = {	/* any word register */
    {	"r0",	0x00	},
    {	"r1",	0x01	},
    {	"r2",	0x02	},
    {	"r3",	0x03	},
    {	"r4",	0x04	},
    {	"r5",	0x05	},
    {	"r6",	0x06	},
    {	"r7",	0x07	},
    {	"sp",	0x07	},
    {	"",	0x00	}
};

struct adsym	autoinc[] = {	/* autoincrement any word register */
    {	"r0+",	0x00	},
    {	"r1+",	0x01	},
    {	"r2+",	0x02	},
    {	"r3+",	0x03	},
    {	"r4+",	0x04	},
    {	"r5+",	0x05	},
    {	"r6+",	0x06	},
    {	"r7+",	0x07	},
    {	"sp+",	0x07	},
    {	"",	0x00	}
};

struct adsym	autodec[] = {	/* autodecrement any word register */
    {	"-r0",	0x00	},
    {	"-r1",	0x01	},
    {	"-r2",	0x02	},
    {	"-r3",	0x03	},
    {	"-r4",	0x04	},
    {	"-r5",	0x05	},
    {	"-r6",	0x06	},
    {	"-r7",	0x07	},
    {	"-sp",	0x07	},
    {	"",	0x00	}
};

struct adsym	ccr_reg[] = {	/* CCR register */
    {	"ccr",	0x00	},
    {	"",	0x00	}
};

