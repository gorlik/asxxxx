/* m74adr.c */

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

/*
 * Contributions by
 *
 * Uwe Steller
 */

#include "asxxxx.h"
#include "m740.h"

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

	/*
	 * Immediate Mode
	 */
	if ((c = getnb()) == '#') {
		expr(esp, 0);
		esp->e_mode = S_IMMED;

	/*
	 * Special Page Mode
	 */
	} else if (c == '\\') {
		expr(esp, 0);
		esp->e_mode = S_SPEC;

	/*
	 * Explicit Direct Page Mode
	 */
	} else if (c == '*') {
		expr(esp, 0);
		esp->e_mode = S_ZP;
		/*
		 * Direct Page Mode with Indexing
		 */
		if (more()) {
			comma(1);
			switch(admode(axy)) {
			case S_X:
				esp->e_mode = S_ZPX;
				break;
			case S_Y:
				esp->e_mode = S_ZPY;
				break;
			default:
				xerr('a', "Register A Is Invalid.");
			}
		}

	/*
	 * Indirect Modes
	 */
	} else if (c == '[') {
		if ((d = getnb()) != '*') {
			unget(d);
		}
		expr(esp, 0);
		if (d != '*') {
			if ((!esp->e_flag)
			    && (esp->e_base.e_ap == NULL)
			    && !(esp->e_addr & ~0xFF)) {
				esp->e_mode = S_ZP;
			} else {
				if (zpg != NULL) {
					if (esp->e_flag) {
						if (esp->e_base.e_sp->s_area == zpg) {
							esp->e_mode = S_ZP;	/* ___  (*)arg */
						}
					} else {
						if (esp->e_base.e_ap == zpg) {
							esp->e_mode = S_ZP;	/* ___  (*)arg */
						}
					}
				}
			}
		} else {
			esp->e_mode = S_ZP;
		}
		if ((c = getnb()) == ']') {
			if (more()) {
				comma(1);
				if (admode(axy) != S_Y)
					xerr('a', "Only Register Y Is Valid.");
				esp->e_mode = S_INDY;
			} else if (esp->e_mode == S_ZP) {
				esp->e_mode = S_ZIND;
			} else {
				esp->e_mode = S_IND;
			}
		} else {
			unget(c);
			comma(1);
			if (admode(axy) != S_X)
				xerr('a', "Only Register X Is Valid.");
			esp->e_mode = S_INDX;
			if (getnb() != ']')
				xerr('q', "Missing ']'.");
		}

	/*
	 * Find modes not explicitly defined by #, *, \, or [.
	 */
	} else {
		unget(c);
		switch(admode(axy)) {
		case S_A:
			esp->e_mode = S_ACC;
			break;
		case S_X:
		case S_Y:
			xerr('a', "Only Register A Is Valid.");
			break;
		default:
			if (more()) {
				expr(esp, 0);
				if ((!esp->e_flag)
				    && (esp->e_base.e_ap == NULL)
				    && !(esp->e_addr & ~0xFF)) {
					esp->e_mode = S_ZP;
				} else {
					if (zpg != NULL) {
						if (esp->e_flag) {
							if (esp->e_base.e_sp->s_area == zpg) {
								esp->e_mode = S_ZP;	/* ___  (*)arg */
							}
						} else {
							if (esp->e_base.e_ap == zpg) {
								esp->e_mode = S_ZP;	/* ___  (*)arg */
							}
						}
					}
				}
				if (more()) {
					p = ip;
					comma(1);
					switch(admode(axy)) {
					/*
					 * nn,X
					 */
					case S_X:
						/*
						 * Assume * was forgotten
						 */
						if (esp->e_mode == S_ZP) {
							esp->e_mode = S_ZPX;
						} else {
							esp->e_mode = S_ABSX;
						}
						break;
					/*
					 * nn,Y
					 */
					case S_Y:
						/*
						 * Assume * was forgotten
						 */
						if (esp->e_mode == S_ZP) {
							esp->e_mode = S_ZPY;
						} else {
							esp->e_mode = S_ABSY;
						}
						break;
					/*
					 * nn,A
					 */
					case S_A:
						esp->e_mode = S_NBITA;
						break;

					default:
						ip = p;
						esp->e_mode = S_NBIT;
						break;
					}
				} else {
					/*
					 * nn
					 */
					if (esp->e_mode != S_ZP) {
						esp->e_mode = S_ABS;
					}
				}
			} else {
				xerr('a', "Invalid Addressing Mode.");
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

struct adsym	axy[] = {		/* a, x, or y registers*/
	{	"a",	S_A	},
	{	"x",	S_X	},
	{	"y",	S_Y	},
	{	"",	0x00	}
};

/*
 *	zpage --- check for direct page address equivalent
 */
int zpage(struct expr *esp)
{
	return((!esp->e_flag) && (esp->e_base.e_ap==NULL) && !(esp->e_addr & ~0xFF));
}
