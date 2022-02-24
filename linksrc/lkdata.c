/* lkdata.c */

/*
 * (C) Copyright 1989
 * All Rights Reserved
 *
 * Alan R. Baldwin
 * 721 Berkeley St.
 * Kent, Ohio  44240
 */

#include <stdio.h>
#include "aslink.h"

int	inpfil;
int	cfile;
int	radix;
int	line;
int	page;
int	lop;
int	pass;
int	oflag;
int	mflag;
int	xflag;
int	pflag;
int	hilo;
char	*ip;
char	ib[NINPUT];

char	*_abs_	= { ".  .ABS." };

int	rtcnt;
int	rtval[NTXT];

struct	sym	*symhash[NHASH];
struct	lfile	*startp;
struct	lfile	*linkp;
struct	lfile	*lfp;
struct	lfile	*filep;
struct	lfile	*cfp;
struct	head	*headp;
struct	head	*hp;
struct	area	*areap;
struct	area	*ap;
struct	areax	*axp;
struct	base	*basep;
struct	base	*bsp;
struct	globl	*globlp;
struct	globl	*gsp;

FILE	*sfp;
FILE	*ofp;
FILE	*mfp;

char	ctype[128] = {
	ILL,	ILL,	ILL,	ILL,	ILL,	ILL,	ILL,	ILL,
	ILL,	SPACE,	ILL,	ILL,	SPACE,	ILL,	ILL,	ILL,
	ILL,	ILL,	ILL,	ILL,	ILL,	ILL,	ILL,	ILL,
	ILL,	ILL,	ILL,	ILL,	ILL,	ILL,	ILL,	ILL,
	SPACE,	ETC,	ETC,	ETC,	LETTER,	BINOP,	BINOP,	ETC,
	ETC,	ETC,	BINOP,	BINOP,	ETC,	BINOP,	LETTER,	BINOP,
	DIGIT,	DIGIT,	DIGIT,	DIGIT,	DIGIT,	DIGIT,	DIGIT,	DIGIT,
	DIGIT,	DIGIT,	ETC,	ETC,	BINOP,	ETC,	BINOP,	ETC,
	ETC,	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,
	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,
	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,
	LETTER,	LETTER,	LETTER,	ETC,	ETC,	ETC,	BINOP,	LETTER,
	ETC,	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,
	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,
	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,	LETTER,
	LETTER,	LETTER,	LETTER,	ETC,	BINOP,	ETC,	ETC,	ETC
};

#if	CASE_SENSITIVE
#else
char	ccase[128] = {
	'\000',	'\001',	'\002',	'\003',	'\004',	'\005',	'\006',	'\007',
	'\010',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037',
	'\040',	'\041',	'\042',	'\043',	'\044',	'\045',	'\046',	'\047',
	'\050',	'\051',	'\052',	'\053',	'\054',	'\055',	'\056',	'\057',
	'\060',	'\061',	'\062',	'\063',	'\064',	'\065',	'\066',	'\067',
	'\070',	'\071',	'\072',	'\073',	'\074',	'\075',	'\076',	'\077',
	'\100',	'\141',	'\142',	'\143',	'\144',	'\145',	'\146',	'\147',
	'\150',	'\151',	'\152',	'\153',	'\154',	'\155',	'\156',	'\157',
	'\160',	'\161',	'\162',	'\163',	'\164',	'\165',	'\166',	'\167',
	'\170',	'\171',	'\172',	'\133',	'\134',	'\135',	'\136',	'\137',
	'\140',	'\141',	'\142',	'\143',	'\144',	'\145',	'\146',	'\147',
	'\150',	'\151',	'\152',	'\153',	'\154',	'\155',	'\156',	'\157',
	'\160',	'\161',	'\162',	'\163',	'\164',	'\165',	'\166',	'\167',
	'\170',	'\171',	'\172',	'\173',	'\174',	'\175',	'\176',	'\177'
};	
#endif
