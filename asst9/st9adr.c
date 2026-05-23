/* st9adr.c */

/*
 *  Copyright (C) 2026  Alan R. Baldwin
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
#include "st9.h"

/*
 * This addr(esp) routine performs the following addressing decoding:
 *
 *   Notation	 Significance					    Actual Operand/Range
 *   --------	 ------------					    --------------------
 *	cc	Condition Code
 * S_IMM
 *	#N	Immediate Byte			# data		where data is a byte expression
 * S_IMM
 *	#NN	immediate Word			# data		where data is a word expression
 * S_WR
 *	r	Working Register		rn		where n=0-15
 * S_DR
 *	R	Direct Register			Rn		where n=0-255, except 208-223
 * S_WRR
 *	rr	Direct Working Register Pair	rrn		where n is an even number in the range 0-14.
 *									(n=0,2,4,6....14)
 * S_DRR
 *	RR	Direct Register Pair		RRn		where n is an even number in the range 0-254.
 *									(n=0,2,4,6....254) except 208-222
 * S_IWR
 *	(r)	Indirect Working Register	(rn)		where n=0-15
 * S_IDR
 *	(R)	Indirect register		(Rn)		where n=0-255
 * S_IWRP1
 *	(r)+	Indirect working register	(rn)+		where n=0-15
 *			post increment
 * S_IWRN
 *	N(rx)	Indexed register		N(rx)		where x=0-15; N=0-255 (one byte)
 * S_EXT
 *	N	Memory relative Short Address			Program label or expression in the range +127/-128
 *								starting from the address of the next instruction
 * S_EXT
 *	NN 	Direct Memory Long Address			Program label or expression in the range 0-65535
 *								in memory area
 * S_IWRR
 *	(rr)	Indirect Pair of Working	(rrn)		Where n is an even number in the range 0-14.
 *			Register Pointers				(n=0,2,4,6....14)
 * S_IWRRP1
 *	(rr)+	Indirect Pair of Working	(rrn)+		where n is an even number in the range 0-14.
 *			Register Pointers				(n=0,2,4,6....14)
 *			with Post Increment
 * S_IWRRM1
 *	-(rr)	Indirect Pair of Working	-(rrn)		where n is an even number in the range 0-14.
 *			Register Pointers				(n=0,2,4,6....14)
 *			with Pre Decrement
 * S_IWRRNS
 *	N(rrx)	Indexed Pair of Working		N(rrx)		where x is an even number in the range 0-14.
 *			Register Pointers				(x=0,2,4,6....14) and N is a signed
 *			with Short Offset				ONE byte expression between +127/-128
 * S_IWRRNL
 *	NN(rrx)	Indexed Pair of Working		NN(rrx)		where x is an even number in the range 0-14.
 *			Register Pointers				(x=0,2,4,6....14) and NN is word
 *			with Long Offset				expression in the range between 0 and 65535
 * S_IDRRNS
 *	N(RRx)	Indexed Pair of Register	N(RRx)		where x is an even number in the range 0-254.
 *			Pointers with					(x=0,2,4,6...254) and N is a one byte
 *			Short Offset					signed expression in the range +127/-128
 * S_IDRRNL
 *	NN(RRx)	Indexed Pair of Register	NN(RRx)		where x is an even number in the range 0-254.
 *			Pointers with					(x=0,2,4,6....254) and NN is word
 *			Long Offset					expression in the range between 0 and 65535
 * S_IWRRX
 *	rr(rrx)	Indexed Pair of Working		rrn(rrx)	where n and x are two even numbers in the
 *			Registers with a Pair				range 0-14. (n,x=0,2,4,6....14) 
 *			of Working Registers
 *			used as Offset
 */
#define	ADDR_DBG 0

int aindx;

int
addr(struct expr *esp)
{
/**/
#if ADDR_DBG
	addx(esp);
	/*
	 * Development Addressing Mode Checking
	 */
	if (pass == 2) {
		fprintf(stderr, "Addressing Mode ");
		switch(esp->e_mode) {
		case S_IMM:	fprintf(stderr, "S_IMM:    #0x%X", esp->e_addr);		break;
		case S_SHORT:	fprintf(stderr, "S_SHORT:  0x%4X", esp->e_addr);		break;
		case S_LONG:	fprintf(stderr, "S_LONG:   0x%4X", esp->e_addr);		break;
		case S_WR:	fprintf(stderr, "S_WR:     r%d", aindx);			break;
		case S_IWR:	fprintf(stderr, "S_IWR:    (r%d)", aindx);			break;
		case S_IWRN:	fprintf(stderr, "S_IWRN:   0x%X(r%d)", esp->e_addr, aindx);	break;
		case S_IWRP1:	fprintf(stderr, "S_IWRP1:  (r%d)+", aindx);			break;
		case S_WRR:	fprintf(stderr, "S_WRR:    rr%d", aindx);			break;
		case S_IWRR:	fprintf(stderr, "S_IWRR:   (rr%d)", aindx);			break;
		case S_IWRRNS:	fprintf(stderr, "S_IWRRNS: 0x%X(rr%d)", esp->e_addr, aindx);	break;
		case S_IWRRNL:	fprintf(stderr, "S_IWRRNL: 0x%X(rr%d)", esp->e_addr, aindx);	break;
		case S_IWRRP1:	fprintf(stderr, "S_IWRRP1: (rr%d)+", aindx);			break;
		case S_IWRRM1:	fprintf(stderr, "S_IWRRM1: -(rr%d)", aindx);			break;
		case S_IWRRX:	fprintf(stderr, "S_IWRRX:  rr%d(rr%d)", esp->e_addr, aindx);	break;
		case S_DR:	fprintf(stderr, "S_DR:     R%d", aindx);			break;
		case S_IDR:	fprintf(stderr, "S_IDR:    (R%d)", aindx);			break;
		case S_DRR:	fprintf(stderr, "S_DRR:    RR%d", aindx);			break;
		case S_IDRR:	fprintf(stderr, "S_IDRR:   (RR%d)", aindx);			break;
		case S_IDRRNS:	fprintf(stderr, "S_IDRRNS: 0x%X(RR%d)", esp->e_addr, aindx);	break;
		case S_IDRRNL:	fprintf(stderr, "S_IDRRNL: 0x%X(RR%d)", esp->e_addr, aindx);	break;
		default:	fprintf(stderr, "S_???:");	break;
		}
		fprintf(stderr, "\n");
	}
	return (esp->e_mode);
}

int
addx(struct expr *esp)
{
#endif
/**/
	int c, rgm;
	char *p, *q, *r, *s;

	/* fix order of '<', '>', and '#' */
	p = ip;
	if (((c = getnb()) == '<') || (c == '>')) {
		p = ip-1;
		if (getnb() == '#') {
			*p = *(ip-1);
			*(ip-1) = c;
		}
	}

	/* Immediate */
	ip = p;
	if (getnb() == '#') {
		expr(esp);
		esp->e_mode = S_IMM;
		return(esp->e_mode);
	}
	/* r, rr, rr(rrx), R, RR */
	ip = p;
	rgm = rgmode();
	if (rgm) {
		switch(rgm) {
		case S_WRR:
			p = ip;;
			esp->e_addr = aindx;
			if ((getnb() == '(') && (S_WRR == rgmode()) && (getnb() == ')')) {
				return(esp->e_mode = S_IWRRX);
			} else {
				ip = p;
			}
			break;
		case S_DRR:
			if ((aindx >= 208) && (aindx <= 222)) {
				xerr('a', "RRn, n=208-222 Not Allowed");
			}
			break;
		case S_WR:
		case S_DR:
		default:
			break;
		}
		return(esp->e_mode = rgm);
	}
	/* (r), (r)+, (rr), (rr)+, (R) */
	ip = p;
	if ((getnb() == '(') && ((rgm = rgmode()) != 0) && (getnb() == ')')) {
		rgm += 1;
		switch(rgm) {
		case S_IWR:
			p = ip;
			if (get() == '+') return(esp->e_mode = S_IWRP1);
			ip = p;
			break;
		case S_IWRR:
			p = ip;
			if (get() == '+') return(esp->e_mode = S_IWRRP1);
			ip = p;
			break;
		case S_IDR:
			break;
		case S_IDRRNS:
		case S_IDRRNL:
			esp->e_addr = 0;
			break;
		default:
			break;
		}
		return(esp->e_mode = rgm);
	}
	/* -(rr) */
	ip = p;
	if ((getnb() == '-') &&
	    (get() == '(') && (S_WRR == rgmode()) && (getnb() == ')')) {
	   	return(esp->e_mode = S_IWRRM1);
	}
	/* N(r), N(rr), N(RR) */
	ip = p;
	q = strrchr(ip, ',');
	if (q != NULL) *q = 0;
	r = strrchr(ip, '(');
	if (r != NULL) {
		ip = r + 1;
		if (((rgm = rgmode()) != 0) & (getnb() == ')')) {
			s = ip;
			*r = 0;
			ip = p;
			if ((c = getnb()) != '*') --ip; 
			switch(rgm) {
			case S_WR:
				expr(esp);
				rgm += 2;	/* S_IWRN */
				break;
			case S_DR:
				xerr('a', "N(Rn) Not Allowed");
				break;
			case S_WRR:
			case S_DRR:
				expr(esp);
				if ((c == '*') || (is_abs(esp) && !valu_err(esp, 1))) {
					rgm += 2;	/* S_IWRRNS / S_IDRRNS */
				} else {
					rgm += 3;	/* S_IWRRNL / S_IDRRNL */
				}
				break;
			default:
				break;
			}
			if (q != NULL) *q = ',';
			*r = '(';
			ip = s;
			return(esp->e_mode = rgm);
		}
	}
	if (q != NULL) *q = ',';
	/* S_SHORT, S_LONG */
	ip = p;
	if ((c = getnb()) != '*') --ip;
	expr(esp);
	if ((c == '*') || (is_abs(esp) && !valu_err(esp, 1))) {
		rgm = S_SHORT;
	} else {
		rgm = S_LONG;
	}
	return (esp->e_mode = rgm);
}

/*
 *	Register Searching - r(S_WR), rr(S_WRR), R(S_DR), RR(S_DRR)
 */
int
rgmode(void)
{
	int c1, c2, d, n;
	char *p;

	p = ip;
	c1 = getnb();
	d = digit(*ip++, 10);
	if (((c1 == 'r') || (c1 == 'R')) && (d >= 0)) {
		n = d;
		while ((d = digit(*ip, 10)) >= 0) {
			n = 10*n + d;
			ip++;
		}
		d = ctype[*ip & 0x7F];
		if ((*ip == 0) || (d == 0) || (d == BINOP)) {
			aindx = n;
			if (c1 == 'r') {
				if (n > 15) xerr('a', "Only rn, n=0-15 Allowed");
				return(S_WR);
			} else
			if (c1 == 'R') {
				if (n > 255) xerr('a', "Only Rn, n=0-255 Allowed");
				return(S_DR);
			}
		}
		ip = p;
		return(0);
	}

	ip = p;
	c1 = getnb();
	c2 = *ip++;
	d = digit(*ip++, 10);
	if ((((c1 == 'r') && (c2 == 'r')) ||
	     ((c1 == 'R') && (c2 == 'R'))) && (d >= 0)) {
		n = d;
		while ((d = digit(*ip, 10)) >= 0) {
			n = 10*n + d;
			ip++;
		}
		d = ctype[*ip & 0x7F];
		if ((*ip == 0) || (d == 0) || (d == BINOP)) {
		   	aindx = n & ~1;
			if (c1 == 'r') {
				if ((n > 15) || (n & 1)) {
					xerr('a', "Only Even rrn, n=0,2,4,...,14 Allowed");
				}
				return(S_WRR);
			} else
			if (c1 == 'R') {
				if ((n > 255) || (n & 1)) {
					xerr('a', "Only Even RRn, n=0,2,4,...,254 Allowed");
				}
				return(S_DRR);
			}
		}
		ip = p;
		return(0);
	}

	ip = p;
	return(0);
}

int
addr_b(struct expr *esp)
{
/**/
#if ADDR_DBG
	addx_b(esp);
	/*
	 * Development Addressing Mode Checking
	 */
	if (pass == 2) {
		fprintf(stderr, "Addressing Mode ");
		switch(esp->e_mode) {
		case S_WRB:	fprintf(stderr, "S_WRB:    r%d.%d", aindx, (esp->e_addr >> 5));		break;
		case S_WRBC:	fprintf(stderr, "S_WRBC:   r%d.!%d", aindx, (esp->e_addr >> 5));	break;
		case S_IWRRB:	fprintf(stderr, "S_IWRRB:  (rr%d).%d", aindx, (esp->e_addr >> 5));	break;
		case S_IWRRBC:	fprintf(stderr, "S_IWRRBC: (rr%d).!%d", aindx, (esp->e_addr >> 5));	break;
		default:	fprintf(stderr, "S_???:");	break;
		}
		fprintf(stderr, "\n");
	}
	return (esp->e_mode);
}

int
addx_b(struct expr *esp)
{
#endif
/**/
	int d, n;
	int mode;
	char *p;

	/* (rr).b / (rr).!b*/
	p = ip;
	if ((getnb() == '(') && (*ip++ == 'r') && (*ip++ == 'r') && ((n = digit(*ip++,10)) >= 0)) {
		mode = S_IWRRB;
	} else {
		/* r.b / r.!b */
		ip = p;
		if ((getnb() == 'r') && ((n = digit(*ip++,10)) >= 0)) {
			mode = S_WRB;
		} else {
			ip = p;
			xerr('a', "Bit Addressing Error");
			return(0);
		}
	}
	while ((d = digit(*ip, 10)) >= 0) {
		n = 10*n + d;
		ip++;
	}
	aindx = n;
	if (mode == S_IWRRB) {
		if (getnb() != ')') { xerr('x', "Missing ')'"); --ip; }
		if ((n > 14) || (n & 1)) xerr('a', "rrn, Only n=0,2,4,...,14 Allowed");
	}
	if ((mode == S_WRB) && (n > 15)) xerr('a', "rn, Only n=0-15 Allowed");
	if (*ip++ != '.') { xerr('a', "The Bit Seperator '.' Is Missing"); --ip; }
	if (*ip++ == '!') mode += 1; else --ip;
	expr(esp);
	if (is_abs(esp) && (esp->e_addr & ~7)) {
		xerr('a', "Bit Number Not 0-7");
		esp->e_addr &= 0x07;
	}
	return(esp->e_mode = mode);
}

