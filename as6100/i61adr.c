/* i61adr.c */

/*
 *  Copyright (C) 2013-2025  Alan R. Baldwin
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
#include "i6100.h"

int
addr(struct expr *esp)
{
	int c, d, e_mode;
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

	/*
	 * Indirect Addressing Mode
	 */
	e_mode = admode(ind);
	/*
	 * Explicit Direct Page Mode
	 */
	if ((c = getnb()) == '*') {
		e_mode |= S_ZP;
	} else {
		unget(c);
	}
	/*
	 * Indirect Addressing Mode
	 */
	if ((d = getnb()) == '[') {
		if ((c = getnb()) == '*') {
			if (e_mode & S_ZP) {
				xerr('a', "Duplicate Zero Page Specifier.");
			} else {
				e_mode |= S_ZP;
			}
		} else {
			unget(c);
		}
		if (e_mode & S_IND) {
			xerr('a', "Duplicate Indexed Specifier.");
		} else {
			e_mode |= S_IND;
		}
	} else {
		unget(d);
	}
	/*
	 * Evaluate Expresion
	 */
	expr(esp, 0);
	/*
	 * End of Indirect Addressing Mode
	 */
	if ((d == '[') && (getnb() != ']')) {
		xerr('q', "Missing ']'.");
	}
	/*
	 * Zero Page Check
	 */
	if (zpage(esp) == 1) {
		e_mode |= S_ZP;
	}
	return (esp->e_mode = e_mode);
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
 *	srch --- does string match ?
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

struct adsym	ind[] = {	/* i for indirect */
	{	"i",	S_IND	},
	{	"",	0x00	}
};

/*
 *	zpage --- check for direct page address equivalent
 */
int zpage(struct expr *esp)
{
	return((!esp->e_flag) && (esp->e_base.e_ap==NULL) && !(esp->e_addr & ~0x7F));
}
