/* m05adr.c */

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
#include "m6805.h"

int
addr(struct expr *esp)
{
	int c;
	char *tcp;
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

	if ((c = getnb()) == '#') {
		expr(esp, 0);
		esp->e_mode = S_IMMED;
	} else if (c == ',') {
		if ((c = admode(ax)) != S_X)
			xerr('a', "Register X Required.");
		esp->e_mode = S_IX;
	} else if (c == '*') {
		expr(esp, 0);
		esp->e_mode = S_DIR;
		if (more()) {
			comma(1);
			tcp = ip;
			if (admode(ax) == S_X) {
				esp->e_mode = S_I8X;
			} else {
				ip = --tcp;
			}
		}
	} else {
		unget(c);
		if ((esp->e_mode = admode(ax)) != 0) {
			;
		} else {
			expr(esp, 0);
			if ((!esp->e_flag)
			    && (esp->e_base.e_ap == NULL)
			    && !(esp->e_addr & ~0xFF)) {
				esp->e_mode = S_DIR;
			} else {
				if (zpg != NULL) {
					if (esp->e_flag) {
						if (esp->e_base.e_sp->s_area == zpg) {
							esp->e_mode = S_DIR;	/* ___  (*)arg */
						}
					} else {
						if (esp->e_base.e_ap == zpg) {
							esp->e_mode = S_DIR;	/* ___  (*)arg */
						}
					}
				}
			}
			if ((esp->e_mode == S_DIR) && more()) {
				comma(1);
				tcp = ip;
				if (admode(ax) == S_X) {
					esp->e_mode = S_I8X;
				} else {
					ip = --tcp;
				}
			} else
			if ((esp->e_mode != S_DIR) && more()) {
				comma(1);
				if (admode(ax) != S_X)
					xerr('a', "Register X Required.");
				if ((!esp->e_flag)
				    && (esp->e_base.e_ap == NULL)
				    && !(esp->e_addr & ~0xFF)) {
					esp->e_mode = S_I8X;
				} else {
					esp->e_mode = S_INDX;
				}
			} else
			if (esp->e_mode != S_DIR) {
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
	char *ptr;
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

struct adsym	ax[] = {	/* a or x registers */
    {	"a",	S_A	},
    {	"x",	S_X	},
    {	"",	0x00	}
};
