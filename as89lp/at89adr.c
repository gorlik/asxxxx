/* at89adr.c */

/*
 *  Copyright (C) 2019-2025  Alan R. Baldwin
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
#include "at89.h"



/*  Classify argument as to address mode */
int
addr(struct expr *esp)
{
	int c;
	char *p;
	unsigned rd;

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
		/*  Immediate mode */
		expr(esp, 0);
		esp->e_mode = S_IMMED;
	} else
	if (c == '@') {
		/* choices are @R0, @R1, @DPTR, @/DPTR, @A+PC, @A+DPTR, @A+/DPTR */
		rd = admode(reg89);
		switch (rd) {
		case R0:	/* @R0 */
			esp->e_mode = S_AT_R;
			esp->e_addr = R0;
			break;
		case R1:	/* @R1 */
			esp->e_mode = S_AT_R;
			esp->e_addr = R1;
			break;
		case DPTR:	/* @DPTR */
			esp->e_mode = S_AT_DP;
			esp->e_addr = DPTR;
			break;
		case A:
			if (getnb() == '+') {
				rd = admode(reg89);
				switch(rd) {
				case PC:	/* @A+PC */
					esp->e_mode = S_AT_A_PC;
					esp->e_addr = 0;
					break;
				case DPTR:	/* @A+DPTR */
					esp->e_mode = S_AT_A_DP;
					esp->e_addr = 0;
					break;
				default:
					if (getnb() == '/') {
						rd = admode(reg89);
						switch(rd) {
						case DPTR:	/* @A+/DPTR */
							esp->e_mode = S_AT_A_NDP;
							esp->e_addr = 0;
							break;
						default:
							xerr('a', "Only Register DPTR Is Valid.");
							break;
						}
					} else {
						xerr('a', "Expecting @A+/DPTR.");
						break;
					}
				}
			} else
				xerr('a', "Valid Modes Are @A+PC, @A+DPTR, And @A+/DPTR.");
			break;
		default:
			if (getnb() == '/') {
				rd = admode(reg89);
				switch(rd) {
				case DPTR:	/* @/DPTR */
					esp->e_mode = S_AT_NDP;
					esp->e_addr = 0;
					break;
				default:
					xerr('a', "Only Register DPTR Is Valid.");
					break;
				}
			} else {
				xerr('a', "Expecting @/DPTR.");
			}
			break;
		}

		esp->e_flag = 0;
		esp->e_base.e_ap = NULL;
	} else
	if (c == '*') {
		if ((c = getnb()) == '/') {
			/* Force inverted bit */
			expr(esp, 0);
			esp->e_mode = S_NOT_BIT;
		} else {
			unget(c);
			/* Force direct page */
			expr(esp, 0);
			esp->e_mode = S_DIR;
		}
		if (esp->e_addr & ~0xFF)
			err('d');
	} else
	if (c == '/') {
		rd = admode(reg89);
		switch(rd) {
		case DPTR:	/* /DPTR */
			esp->e_mode = S_NDPTR;
			esp->e_addr = 0;
			break;
		default:
			/* Force inverted bit  */
			expr(esp, 0);
			esp->e_mode = S_NOT_BIT;
		}
	} 
	else {
		unget(c);

		/* try for register: A, AB, R0-R7, DPTR, PC, Cy */
		if ((esp->e_addr = admode(reg89)) != -1) {
			switch (esp->e_addr) {
			case A:
				esp->e_mode = S_A;
				break;
			case AB:
				esp->e_mode = S_AB;
				break;
			case DPTR:
				esp->e_mode = S_DPTR;
				break;
			case PC:
				esp->e_mode = S_PC;
				break;
			case C:
				esp->e_mode = S_C;
				break;
			case M:
				esp->e_mode = S_M;
				break;
			default:
				/* R0-R7 */
				esp->e_mode = S_REG;
			}
		} else {
			/* Must be an expression */
			esp->e_addr = 0;
			expr(esp, 0);
			if ((!esp->e_flag)
				&& (esp->e_base.e_ap==NULL)
				&& !(esp->e_addr & ~0xFF)) {
				esp->e_mode = S_DIR;
			} else {
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
 * -1 for no match.
 */
int
admode(struct adsym *sp)
{
	char *ptr;
	int i;
	unget(getnb());
	i = 0;
	while ( *(ptr = &sp[i].a_str[0]) ) {
		if (srch(ptr)) {
			return(sp[i].a_val);
		}
		i++;
	}
	return(-1);
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

struct adsym reg89[] = {	/* R0 thru R7 registers */
    {	"R0",	R0	},
    {	"R1",	R1	},
    {	"R2",	R2	},
    {	"R3",	R3	},
    {	"R4",	R4	},
    {	"R5",	R5	},
    {	"R6",	R6	},
    {	"R7",	R7	},
    {	"A",	A	},
    {	"DPTR", DPTR	},
    {	"PC",	PC	},
    {	"AB",	AB	},
    {	"C",	C	},
    {	"M",	M	},
    {	"",	0x00	}
};


