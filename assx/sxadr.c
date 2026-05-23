/* sxadr.c */

/*
 *  Copyright (C) 2022-2025  Alan R. Baldwin
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
#include "sx.h"

int
addr(struct expr *esp)
{
	int c, indx;
	char *p, *q;
	char str[NCPS];

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

	c = getnb();
	if (c == '#') {
		expr(esp, 0);
		return(esp->e_mode = S_IMM);
	} else
	if (c == '/') {
		esp->e_addr = S_CM;
		return(esp->e_mode = S_MOP);
	} else
	if (c == '-') {
		if (get() == '-') {
			esp->e_addr = S_MM;
			return(esp->e_mode = S_MOP);
		}
	} else
	if (c ==  '+') {
		if (get() == '+') {
			esp->e_addr = S_PP;
			return(esp->e_mode = S_MOP);
		}
	} else
	if (c == '>') {
		if (get() == '>') {
			esp->e_addr = S_RT;
			return(esp->e_mode = S_MOP);
		}
	} else
	if (c == '<') {
		c = get();
		if (c == '<') {
			esp->e_addr = S_LT;
			return(esp->e_mode = S_MOP);
		} else
		if (c == '>') {
			esp->e_addr = S_SN;
			return(esp->e_mode = S_MOP);
		}
	}
	ip = p;

	indx = admode(reg);	
	if (indx) {	/* Registers W and M */
		return(esp->e_mode = indx);
	}
	indx = admode(nrg);
	if (indx) {	/* Registers !RA, !RB, !RC, !RD, !RE, !OPTION, !WDT */
		esp->e_addr = indx;
		return(esp->e_mode = S_NRG);
	}

	/*
	 * Prepare String For Scanning
	 */
	if (more()) {
		q = str;
		while (more()) {	/* Note: This Removes White Space */
			*q++ = get();
		}
		*q = '\0';
		if ((*(q-2) == '-') && (ccase[*(q-1) & 0x7F] == 'w')) {
			*(q-2) = '\0';
			q = ip;
			ip = str;
			expr(esp, 0);
			ip = q;
			return (esp->e_mode = S_FRW);
		} else
		if ((*(q-2) == '.') && ((*(q-1) >= '0') && (*(q-1) <= '7'))) {
			*(q-2) = '\0';
			indx = *(q-1) - '0';
			q = ip;
			ip = str;
			expr(esp, 0);
			ip = q;
			return(esp->e_mode = S_FRBIT + indx);
		} else
		if (symeq("pc+w", str, 0) || symeq("w+pc", str, 0)) {
			return(esp->e_mode = S_PCW);
		}
	} else {
		qerr();
	}
	ip = p;
	/*
	 * Evaluate Expresion
	 */
	expr(esp, 0);
	return (esp->e_mode = S_FR);
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

struct adsym	reg[] = {	/* registers */
	{	"w",		S_W	},
	{	"m",		S_M	},
	{	"",		0x00	}
};

struct adsym	nrg[] = {	/* registers */
	{	"!ra",		S_RA	},
	{	"!rb",		S_RB	},
	{	"!rc",		S_RC	},
	{	"!rd",		S_RD	},
	{	"!re",		S_RE	},
	/* ----- */
	{	"!option",	S_OPT	},
	{	"!wdt",		S_WDT	},
	{	"",		0x00	}
};


