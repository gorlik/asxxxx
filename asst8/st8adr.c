/* st8adr.c */

/*
 *  Copyright (C) 2010-2025  Alan R. Baldwin
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
 * 
 */

#include "asxxxx.h"
#include "st8.h"

/*
 * Read an address specifier. Pack the
 * address information into the supplied
 * `expr' structure. Return the mode of
 * the address.
 *
 * This addr(esp) routine performs the following addressing decoding:
 *
 *	address		mode		flag	addr	base	mode
 * Direct Modes:
 *	REG		S_REG+rcode	0	0	NULL	0x00
 *
 *	*label		S_SHORT		----	s_addr	s_area	0x01
 *	label		S_LONG		----	s_addr	s_area	0x02
 *	label		S_EXT		----	s_addr	s_area	0x04
 *
 * Indexed Modes:
 *	(offset,REG)	S_IX+rcode	----	s_addr	s_area	0x08   S_IX
 *	(offset,REG).b	S_IXB+rcode	----	s_addr	s_area	0x09   S_IX + S_SHORT
 *	(offset,REG).w	S_IXW+rcode	----	s_addr	s_area	0x0A   S_IX + S_LONG
 *	(offset,REG).x	S_IXE+rcode	----	s_addr	s_area	0x0C   S_IX + S_EXT
 *
 * Indirect Modes:
 *	[label]		S_IN		----	s_addr	s_area	0x10   S_IN
 *	[*label]	S_INB		----	s_addr	s_area	0x11   S_IN + S_SHORT
 *	[label].b	S_INB		----	s_addr	s_area	0x11   S_IN + S_SHORT
 *	[label].w	S_INW		----	s_addr	s_area	0x12   S_IN + S_LONG
 *	[label].e	S_INE		----	s_addr	s_area	0x14   S_IN + S_EXT
 *
 * Indexed with Indirect Offset Modes:
 *	([label],REG)	S_IXIN+rcode	----	s_addr	s_area	0x18   S_IXIN
 *	([*label],REG)	S_IXINB+rcode	----	s_addr	s_area	0x19   S_IXIN + S_SHORT
 *	([label],REG).b	S_IXINB+rcode	----	s_addr	s_area	0x19   S_IXIN + S_SHORT
 *	([label],REG).w	S_IXINW+rcode	----	s_addr	s_area	0x1A   S_IXIN + S_LONG
 *	([label],REG).w	S_IXINE+rcode	----	s_addr	s_area	0x1C   S_IXIN + S_EXT
 *
 " Immediate Mode:
 *	#n		S_IMMED		0	n	NULL	0x20  32
 *
 * Rgister Indexed Mode
 *	(REG)		S_IX+rcode	0	0	NULL	0x21  33
 */

int rcode;

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

	rcode = 0;
	if ((c = getnb()) == '#') {
		expr(esp, 0);
		esp->e_mode = S_IMM;
	} else
	if (c == '[') {
		/* [___] */
		if (addr1(esp) == S_SHORT) {
			esp->e_mode = S_INB;
		} else {
			esp->e_mode = S_IN;
		}
		if (getnb() != ']')
			xerr('a', "Missing ']'.");
		addrsl(esp);
	} else
	if (c == '(') {
		if ((rcode = admode(REG)) != 0) {
			/* (R) */
			rcode = rcode & 0xFF;
			if ((rcode != 0) && (rcode != X) && (rcode != Y) && (rcode != SP))
				xerr('a', "Addressing mode requires X, Y, or SP.");
			if (getnb() != ')')
				xerr('a', "Missing ')'.");
			esp->e_mode = S_IXR;
		} else
		if ((c = getnb()) == '[') {
			/* ([___]) */
			if (addr1(esp) == S_SHORT) {
				/* Short <- '*' */
				esp->e_mode = S_INIXB;
			} else {
				/* Long */
				esp->e_mode = S_INIX;
			}
			/* .b, .w, and .e Check Before ']' */
			addrsl(esp);
			if (getnb() != ']')
				xerr('a', "Missing ']'.");
			/* .b, .w, and .e Check After ']' */
			addrsl(esp);
			if (comma(0)) {
				/* ([___],R) */
				if ((rcode = admode(REG)) != 0) {
					rcode = rcode & 0xFF;
					if ((rcode != 0) && (rcode != X) && (rcode != Y) && (rcode != SP))
						xerr('a', "Addressing mode requires X, Y, or SP.");
				}
			}
			if (getnb() != ')')
				xerr('a', "Missing ')'.");
			/* .b, .w, and .e Check After ')' */
			addrsl(esp);
		} else {
			unget(c);
			/* (Offset,R) */
			if (addr1(esp) == S_SHORT) {
				esp->e_mode = S_IXB;
			} else {
				esp->e_mode = S_IX;
			}
			comma(1);
			if ((rcode = admode(REG)) != 0) {
				rcode = rcode & 0xFF;
				if ((rcode != 0) && (rcode != X) && (rcode != Y) && (rcode != SP))
					xerr('a', "Addressing mode requires X, Y, or SP.");
			}
			if (getnb() != ')')
				xerr('a', "Missing ')'.");
			/* .b, .w, and .e Check After ')' */
			addrsl(esp);
		}
	} else {
		unget(c);
		if ((rcode = admode(REG)) != 0) {
			rcode = rcode & 0xFF;
			esp->e_mode = S_REG;
		} else {
			addr1(esp);
		}
	}
	/*
	 * Development Addressing Mode Checking
	 */
#if 0
	if (pass == 2) {
		fprintf(stderr, "Addressing Mode ");
		switch(esp->e_mode) {
		case S_IMM:	fprintf(stderr, "S_IMM:' #arg ' arg = %X", esp->e_addr);	break;
		case S_LONG:	fprintf(stderr, "S_LONG:' arg ' arg = %X", esp->e_addr);	break;
		case S_SHORT:	fprintf(stderr, "S_SHORT:' *arg ' arg = %X", esp->e_addr);	break;
		case S_IN:	fprintf(stderr, "S_IN:' [arg] ' arg = %X", esp->e_addr);	break;
		case S_INB:	fprintf(stderr, "S_INB:' [*arg] ' arg = %X", esp->e_addr);	break;
		case S_REG:	fprintf(stderr, "S_REG:' R ' rcode = %d", rcode);		break;
		case S_IXR:	fprintf(stderr, "S_IXR:' (R) ' rcode = %d", rcode);		break;
		case S_IX:	fprintf(stderr, "S_IX:' (arg,R) ' arg = %X, rcode = %d", esp->e_addr, rcode);	break;
		case S_IXB:	fprintf(stderr, "S_IXB:' (*arg,R) ' arg = %X, rcode = %d", esp->e_addr, rcode);	break;
		case S_INIX:
			if (rcode != 0) {
				fprintf(stderr, "S_INIX' ([arg],R) ' arg = %X, rcode = %d", esp->e_addr, rcode);	break;	
			} else {
				fprintf(stderr, "S_INIX' ([arg]) ' arg = %X", esp->e_addr);	break;
			}
		case S_INIXB:
			if (rcode != 0) {
				fprintf(stderr, "S_INIXB:' ([*arg],R) ' arg = %X, rcode = %d", esp->e_addr, rcode);	break;	
			} else {
				fprintf(stderr, "S_INIXB:' ([*arg]) ' arg = %X", esp->e_addr); break;
			}
		default:	fprintf(stderr, "Bad");	break;
		}
		fprintf(stderr, "\n");
	}
#endif

	return (esp->e_mode);
}

int
addr1(struct expr *esp)
{
	int c;

	if ((c = getnb()) == '*') {
		expr(esp, 0);
		esp->e_mode = S_SHORT;
	} else {
		unget(c);
		expr(esp, 0);
		esp->e_mode = S_LONG;
	}
	return (esp->e_mode);
}

int
addrsl(struct expr *esp)
{
	int c, d;

	if ((c = getnb()) == '.') {
		d = getnb();
		switch(ccase[d & 0x7F]) {
		case 'b':	esp->e_mode = esp->e_mode | S_SHORT;
			if (esp->e_mode & (S_LONG | S_EXT))
				xerr('m', "Mixed size specifications.");
			break;
		case 'w':	esp->e_mode = esp->e_mode | S_LONG;
			if (esp->e_mode & (S_SHORT | S_EXT))
				xerr('m', "Mixed size specifications.");
			break;
		case 'e':	esp->e_mode = esp->e_mode | S_EXT;
			if (esp->e_mode & (S_SHORT | S_LONG))
				xerr('m', "Mixed size specifications.");
			break;
		default:	unget(d);	unget(c);		break;
		}
	} else {
		unget(c);
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
		if (ccase[*ptr & 0x007F] != ccase[*str & 0x007F])
			break;
		ptr++;
		str++;
	}
	if (ccase[*ptr & 0x007F] == ccase[*str & 0x007F]) {
		ip = ptr;
		return(1);
	}

	if (!*str) {
		if (!(ctype[*ptr & 0x007F] & LTR16)) {
			ip = ptr;
			return(1);
		}
	}
	return(0);
}

/*
 * Registers
 */

struct	adsym	REG[] = {
    {	"a",	 A|0400	},
    {	"x",	 X|0400	},
    {	"xl",	XL|0400	},
    {	"xh",	XH|0400	},
    {	"y",	 Y|0400	},
    {	"yl",	YL|0400	},
    {	"yh",	YH|0400	},
    {	"sp",	SP|0400	},
    {	"cc",	CC|0400	},
    {	"",	0000	}
};


