/* m01adr.c */

/*
 * (C) Copyright 1989
 * All Rights Reserved
 *
 * Alan R. Baldwin
 * 721 Berkeley St.
 * Kent, Ohio  44240
 */

#include <stdio.h>
#include <setjmp.h>
#include "asm.h"
#include "6801.h"

int
addr(esp)
register struct expr *esp;
{
	register c;
	register struct area *espa;

	if ((c = getnb()) == '#') {
		expr(esp, 0);
		esp->e_mode = S_IMMED;
	} else if (c == ',') {
		esp->e_mode = S_INDX;
		esp->e_flag = 0;
		esp->e_addr = 0;
		esp->e_base.e_ap = NULL;
		if (admode(abdx) != S_X)
			aerr();
	} else if (c == '*') {
		expr(esp, 0);
		esp->e_mode = S_DIR;
		espa = esp->e_base.e_ap;
		if (esp->e_addr & ~0xFF)
			aerr();
		if (espa && espa != sdp->s_area)
			rerr();
		if (more()) {
			comma();
			esp->e_mode = S_INDX;
			if (admode(abdx) != S_X)
				aerr();
		}
	} else {
		unget(c);
		if (esp->e_mode = admode(abdx)) {
			;
		} else {
			expr(esp, 0);
			if (more()) {
				comma();
				esp->e_mode = S_INDX;
				if (admode(abdx) != S_X)
					aerr();
				espa = esp->e_base.e_ap;
				if (esp->e_addr & ~0xFF)
					aerr();
				if (espa && espa != sdp->s_area)
					rerr();
			} else {
				if ( !esp->e_base.e_ap &&
				    !(esp->e_addr & ~0xFF)) {
					esp->e_mode = S_DIR;
				} else {
					esp->e_mode = S_EXT;
				}
			}
		}
	}
	return (esp->e_mode);
}
	
/*
 * Enter admode() to search a specific addressing mode table
 * for a match. Return the addressing value on a match or
 * zero for no match.
 */
int
admode(sp)
register struct adsym *sp;
{
	register char *ptr;
	register int i;
	unget(getnb());
	i = 0;
	while ( *(ptr = (char *) &sp[i].a_str) ) {
		if (srch(ptr)) {
			return(sp[i].a_val);
		}
		i++;
	}
	return(0);
}

/*
 *      srch --- does string match ?
 */
int
srch(str)
register char *str;
{
	register char *ptr;
	ptr = ip;

#if	CASE_SENSITIVE
	while (*ptr && *str) {
		if(*ptr != *str)
			break;
		ptr++;
		str++;
	}
	if (*ptr == *str) {
		ip = ptr;
		return(1);
	}
#else
	while (*ptr && *str) {
		if(ccase[*ptr] != ccase[*str])
			break;
		ptr++;
		str++;
	}
	if (ccase[*ptr] == ccase[*str]) {
		ip = ptr;
		return(1);
	}
#endif

	if (!*str)
		if (any(*ptr," \t\n,];")) {
			ip = ptr;
			return(1);
		}
	return(0);
}

/*
 *      any --- does str contain c?
 */
int
any(c,str)
char    c, *str;
{
	while (*str)
		if(*str++ == c)
			return(1);
	return(0);
}

struct adsym	abdx[] = {	/* a, b, d, or x registers */
	"a",	S_A,
	"b",	S_B,
	"d",	S_D,
	"x",	S_X,
	"",	0x00
};
