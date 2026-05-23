/* m430adr.c */

/*
 *  Copyright (C) 2003-2025  Alan R. Baldwin
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
#include "m430.h"

int aindx;

int
addr(struct expr *esp)
{
	int c, d;
	char *ips, *ipd, *ptr;
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
	ips = ip;

	/*	Rn	 */
 	if (admode(reg)) {
		esp->e_mode = S_REG;
	} else
	/*	&Addr 	 */
	if ((c = getnb()) == '&') {
		expr(esp, 0);
		esp->e_mode = S_ABS;
	} else
	/*	#N	*/
	if (c == '#') {
		expr(esp, 0);
		esp->e_mode = S_IMM;
	} else
	/*	@Rn / @Rn+	*/
	if (c == '@') {
		if (admode(reg)) {
			esp->e_mode = S_RIN;
			if ((d = getnb()) == '+') {
				esp->e_mode = S_RIN2;
			} else {
				unget(d);
			}
		} else {
			xerr('a', "@Rn or @Rn+ required.");
		}
	} else
	/*	(Rn) / (Rn)+	*/
	if ((c == '(') && admode(reg) && (getnb() == ')')) {
		esp->e_mode = S_RIN;
		if ((d = getnb()) == '+') {
			esp->e_mode = S_RIN2;
		} else {
			unget(d);
		}
	} else {
		ip = ips;
		/*
		 * Find next argument seperator or EOL
		 *
		 *	lbl1:	mne	arg1(Rn)				[; comment]
		 *	lbl2:	mne	arg1(Rn)	,	arg2		[; comment]
		 *	lbl3:	mne	arg1		,	arg2(Rn)	[; comment]
		 *	lbl4:	mne	arg1(Rn)	,	arg2(Rn)	[; comment]
		 */
		while ((c = *ip++) != 0) {
			if ((c == ',') || (c == ';')) {
				break;
			}
		}
		/*
		 * ip is at seperator:
		 *
		 *	1 - save seperator position
		 *	2 - save seperator character
		 *	3 - set EOL at seperator
		 */
		ipd = ip - 1;
		d = *ipd;
		*ipd = 0;

		/*
		 * scan for (Rn) in this argument
		 */
		ip = ips;
		ptr = strrchr(ip, '(');
		*ipd = d;

		if (ptr != NULL) {
			ip = ptr;
			if ((getnb() == '(') && admode(reg) && (getnb() == ')')) {
				/*
				 * (Rn) found:
				 *
				 * 	1 - save ip position
				 *	2 - set EOL at '(' of (Rn)
				 *	3 - evaluate from beginning
				 */
				ipd = ip;
				*ptr = 0;
				ip = ips;
				/*
				 * evaluate X of X(Rn)
				 */
				expr(esp, 0);
				esp->e_mode = S_RIDX;
				/*
				 * after evaluation:
				 *
				 *	1 - restore ip position
				 *	2 - restore '(' of (Rn)
				 */
				ip = ipd;
				*ptr = '(';
			} else {
				/*
				 * (Rn) not found,
				 * assume regular argument of form (...)
				 */
				ip = ips;
				expr(esp, 0);
				esp->e_mode = S_SYM;
			}
		} else {
			/*
			 * regular argument
			 */
			expr(esp, 0);
			esp->e_mode = S_SYM;
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
 *      any --- does str contain c?
 */
int
any(int c, char *str)
{
	while (*str)
		if(*str++ == c)
			return(1);
	return(0);
}

struct adsym	reg[] = {	/* any register */
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
    {	"pc",	0x00	},
    {	"sp",	0x01	},
    {	"sr",	0x02	},
    {	"cg1",	0x02	},
    {	"cg2",	0x03	},
    {	"",	0x00	}
};


