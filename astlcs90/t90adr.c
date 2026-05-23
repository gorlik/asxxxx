/* t90adr.c */

/*
 *  Copyright (C) 2026  Alan R. Baldwin
 *
 *  A rewrite of the
 *    Port to the SDAS fork of ASxxxx by Rainer Keuchel (C) 2013
 *    Port to ASxxxx from the SDASTLCS90 by Philip Klaus Krause 2025
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
#include "t90.h"

/*
 * Read an address specifier. Pack the
 * address and mode information into the
 * supplied `expr' structure. If a register
 * is specified then its code is left in aindx.
 *
 * This addr(esp) routine performs the following addressing decoding:
 *
 *	address		mode		flag		e_addr		base		aindx
 *	r		S_R8		-		-		-		0-6
 *	rr		S_R16		-		-		-		0-2,4-6
 *	hl+a		S_HLA		-		-		-		-
 *	(#)n	const	S_MN		0		n		NULL		-
 *	(#)n	extrn	S_MN		1		n		symbol		-
 *	(#)mn	const	S_MN		0		mn		NULL		-
 *	(#)mn	extrn	S_MN		1		mn		symbol		-
 *	(r)		S_IR8		-		-		-		0-6
 *	(rr)		S_IR16		-		-		-		0-2,4-6
 *	(jx+d)	const	S_IXYS		0		d		NULL		4-6
 *	(jx+d)	extrn	S_IXYS		1		d		symbol		4-6
 *	d(jx)	const	S_IXYS		0		d		NULL		4-6
 *	d(jx)	extrn	S_IXYS		1		d		symbol		4-6
 *	(hl+a)		S_IHLA	        -		-		-		-
 *	(mn)	const	S_IMN		0		mn		NULL		-
 *	(mn)	extrn	S_IMN		1		mn		symbol		-
 *	(n)	const	S_IN / S_IPGN	0		n		NULL		-
 *	(n)	extrn	S_IN / S_IPGN	1		n		symbol		-
 *	(*n)	const	S_IN / S_IPGN	0		n		NULL		-
 *	(*n)	extrn	S_IN / S_IPGN	1		n		symbol		-
 *
 *	Processed Externally
 *
 *	pc+d	const	short relative
 *	pc+d	extrn	short relative
 *	pc+cd	const	long  relative
 *	pc+cd	extern	long  relative
 */

int	aindx;

int
addr(struct expr *esp)
{
	int c, d, mode;
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
	mode = 0;
	ips = ip;

	if ((c = getnb()) == '#') {
		expr(esp, 0);
		mode = S_MN;
	} else
	if (c == '*') {
		expr(esp, 0);
		if (is_abs(esp)) {
			esp->e_addr &= a_mask;
			if ((esp->e_addr <= 0x00FF) || (esp->e_addr >= 0xFF00)) {
				mode = S_IN;
			} else {
				mode = S_IMN;
				xerr('a', "The argument is NOT a direct page address.");
			}
		} else {
			mode = S_INPG;
		}
	} else
	if ((c == LFIND) && (admode(R8) != 0)) {
		mode = S_IR8;
	} else
	if ((c == LFIND) && (admode(R16) != 0)) {
		mode = S_IR16;
		if ((c = getnb()) != RTIND) {
			unget(c);
			switch(aindx) {
			case HL:	/* (HL+A) */
				p = ip;
				if ((getnb()=='+') && (ccase[getnb()]=='a')) {
					mode = S_IHLA;
				} else {
					ip = p;
					xerr('a', "Only HL+A allowed.");
				}
				break;

			case IX:	/* (IX+d) */
			case IY:	/* (IY+d) */
			case SP:	/* (SP+d) */
				mode = S_IXYS;
				expr(esp, 0);
				break;

			default:
				xerr('a', "Only HL, IX, IY, and SP allowed.");
				break;
			}
		} else {
			unget(c);
		}
		if ((c = getnb()) != RTIND) {
			qerr();
		}
	} else
	if (c == LFIND) {
		/* Restart Scan */
		ip = ips;

		/*
		 * Find next argument separator or EOL
		 *
		 *	lbl1:	mne	arg1(IX/IY/SP)				[; comment]
		 *	lbl2:	mne	arg1(IX/IY/SP)	,	arg2		[; comment]
		 *	lbl3:	mne	arg1		,	arg2(IX/IY/SP)	[; comment]
		 *	lbl4:	mne	arg1(IX/IY/SP)	,	arg2(IX/IY/SP)	[; comment]
		 */
		while ((c = *ip++) != 0) {
			if ((c == ',') || (c == ';')) {
				break;
			}
		}
		/*
		 * ip is at separator:
		 *
		 *	1 - save separator position
		 *	2 - save separator character
		 *	3 - set EOL at separator
		 */
		ipd = ip - 1;
		d = *ipd;
		*ipd = 0;

		/* scan for (IX/IY/SP) in this argument */
		ip = ips;
		ptr = strrchr(ip, LFIND);
		*ipd = d;

		if (ptr != NULL) {
			ip = ptr;
			if ((getnb() == LFIND) && admode(R16) && (aindx & IXIYSP) && (getnb() == RTIND)) {
				mode = S_IXYS;
				/*
				 * (IX/IY/SP) found:
				 *
				 * 	1 - save ip position
				 *	2 - set EOL at '(' of (IX/IY/SP)
				 *	3 - evaluate from beginning
				 */
				ipd = ip;
				*ptr = 0;
				ip = ips;
				/* evaluate X of X(IX/IY/SP) */
				expr(esp, 0);
				/*
				 * after evaluation:
				 *
				 *	1 - restore ip position
				 *	2 - restore '(' of (IX/IY/SP)
				 */
				ip = ipd;
				*ptr = LFIND;
			}
		}
		if (mode == 0) {
			/* Restart Scan */
			ip = ips;
			/*
			 * If argument is of the form (*...) then
			 * replace '*' with ' ' before evaluation
			 *
			 * Skip '('
			 */
			getnb();
			if ((c = getnb()) == '*') {
				unget(c);
				ipd = ip;	d = *ip;	*ip = ' ';
			}
			ip = ips;
			expr(esp, 0);
			*ipd = d;
			if (is_abs(esp)) {
				esp->e_addr &= a_mask;
				if (esp->e_addr >= 0xFF00) {
					mode = S_IN;
				} else
				if ((esp->e_addr <= 0x00FF) && (c == '*')) {
					mode = S_IN;
				} else {
					mode = S_IMN;
				}
			} else
			if (c == '*') {
				mode = S_INPG;
			} else {
				mode = S_IMN;
			}
		}
	} else {
		/* Restart Scan */
		ip = ips;

		if (admode(R8) != 0) {
			mode = S_R8;
		} else
		if (admode(R16) != 0) {
			mode = S_R16;
			if (more()) {
				if ((c = getnb()) != ',') {
					unget(c);
					switch(aindx) {
					case HL:	/* HL+A */
						p = ip;
						if ((getnb()=='+') && (ccase[getnb()]=='a')) {
							mode = S_HLA;
						} else {
							ip = p;
							xerr('a', "Only HL+A allowed.");
						}
						break;

					case IX:	/* IX+d */
					case IY:	/* IY+d */
					case SP:	/* SP+d */
						mode = S_XYS;
						expr(esp, 0);
						break;

					default:
						xerr('a', "Only HL+A, IX+d, IY+d, and SP+d allowed.");
						break;
					}
				} else {
					unget(c);
				}
			}
		} else
		if (admode(R16A) != 0) {
			mode = S_R16A;
		} else {
			/*
			 * Find next argument separator or EOL
			 *
			 *	lbl1:	mne	arg1(IX/IY/SP)				[; comment]
			 *	lbl2:	mne	arg1(IX/IY/SP)	,	arg2		[; comment]
			 *	lbl3:	mne	arg1		,	arg2(IX/IY/SP)	[; comment]
			 *	lbl4:	mne	arg1(IX/IY/SP)	,	arg2(IX/IY/SP)	[; comment]
			 */
			while ((c = *ip++) != 0) {
				if ((c == ',') || (c == ';')) {
					break;
				}
			}
			/*
			 * ip is at separator:
			 *
			 *	1 - save separator position
			 *	2 - save separator character
			 *	3 - set EOL at separator
			 */
			ipd = ip - 1;
			d = *ipd;
			*ipd = 0;

			/* scan for (IX/IY/SP) in this argument */
			ip = ips;
			ptr = strrchr(ip, LFIND);
			*ipd = d;

			if (ptr != NULL) {
				ip = ptr;
				if ((getnb() == LFIND) && admode(R16) && (aindx & IXIYSP) && (getnb() == RTIND)) {
					mode = S_IXYS;
					/*
					 * (IX/IY/SP) found:
					 *
					 * 	1 - save ip position
					 *	2 - set EOL at '(' of (IX/IY/SP)
					 *	3 - evaluate from beginning
					 */
					ipd = ip;
					*ptr = 0;
					ip = ips;
					/* evaluate X of X(IX/IY/SP) */
					expr(esp, 0);
					/*
					 * after evaluation:
					 *
					 *	1 - restore ip position
					 *	2 - restore '(' of (IX/IY/SP)
					 */
					ip = ipd;
					*ptr = LFIND;
				}
			}
			if (mode == 0) {
				/* Restart Scan */
				ip = ips;
				/* regular argument */
				expr(esp, 0);
				mode = S_MN;
			}
		}
	}
	esp->e_mode = mode;
	return (mode);
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
 * Registers
 */

struct	adsym	R8[] = {
    {	"b",	B	},	/* 0 */
    {	"c",	C	},	/* 1 */
    {	"d",	D	},	/* 2 */
    {	"e",	E	},	/* 3 */
    {	"h",	H	},	/* 4 */
    {	"l",	L	},	/* 5 */
    {	"a",	A	},	/* 6 */
    {	"",	0000	}
};

struct	adsym	R16[] = {
    {	"bc",	BC	},	/* 0 */
    {	"de",	DE	},	/* 1 */
    {	"hl",	HL	},	/* 2 */
    {	"ix",	IX	},	/* 4 */
    {	"iy",	IY	},	/* 5 */
    {	"sp",	SP	},	/* 6 */
    {	"",	0000	}
};

struct	adsym	R16A[] = {
    {	"bc",	BC	},	/* 0 */
    {	"de",	DE	},	/* 1 */
    {	"hl",	HL	},	/* 2 */
    {	"ix",	IX	},	/* 4 */
    {	"iy",	IY	},	/* 5 */
    {	"af",	AF	},	/* 6 */
    {	"",	0000	}
};

struct	adsym	R16EX[] = {	/* af' must be first !!! */
    {	"af'",	AFP	},	/* 6 */
    {	"af",	AF	},	/* 6 */
    {	"de",	DE	},	/* 1 */
    {	"hl",	HL	},	/* 2 */
    {	"",	0000	}
};

struct	adsym	PC[] = {
    {	"pc",	0	},	/* 0 */
    {	"",	0000	}
};

/*
 * Conditional definitions
 */

struct  adsym   CND[] = {
    {	"F",	F	},	/* 0x00 */
    {	"LT",	LT	},	/* 0x01 */
    {	"LE",	LE	},	/* 0x02 */
    {	"ULE",	ULE	},	/* 0x03 */
    {	"OV",	OV	},	/* 0x04 */
    {	"MI",	M	},	/* 0x05 */
    {	"EQ",	EQ	},	/* 0x06 */
    {	"C",	CS	},	/* 0x07 */
    {	"T",	T	},	/* 0x08 */
    {	"GE",	GE	},	/* 0x09 */
    {	"GT",	GT	},	/* 0x0A */
    {	"UGT",	UGT	},	/* 0x0B */
    {	"NOV",	NOV	},	/* 0x0C */
    {	"PL",	P	},	/* 0x0D */
    {	"NE",	NE	},	/* 0x0E */
    {	"NC",	NC	},	/* 0x0F */

    {	"PE",	PE	},	/* 0x04 */
    {	"PO",	PO	},	/* 0x0C */

    {	"M",	M	},	/* 0x05 */
    {	"P",	P	},	/* 0x0D */

    {	"Z",	Z	},	/* 0x06 */
    {	"NZ",	NZ	},	/* 0x0E */

    {	"ULT",	ULT	},	/* 0x07 */
    {	"UGE",	UGE	},	/* 0x0F */
    {   "",	0000    }
};


