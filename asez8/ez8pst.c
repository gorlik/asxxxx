/* ez8pst.c */

/*
 *  Copyright (C) 2022-2026  Alan R. Baldwin
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
#include "ez8.h"

/*
 * Coding Banks
 */
struct	bank	bank[2] = {
    /*	The '_CODE' area/bank has a NULL default file suffix.	*/
    {	NULL,		"_CSEG",	NULL,		0,	0,	0,	0,	0	},
    {	&bank[0],	"_DSEG",	"_DS",		1,	0,	0,	0,	B_FSFX	}
};

/*
 * Coding Areas
 */
struct	area	area[2] = {
    {	NULL,		&bank[0],	"_CODE",	0,	0,	0,	A_1BYTE|A_BNK|A_CSEG	},
    {	&area[0],	&bank[1],	"_DATA",	1,	0,	0,	A_1BYTE|A_BNK|A_DSEG	}
};

/*
 * Basic Relocation Mode Definition
 *
 *	#define		R_NORM	0000		No Bit Positioning
 */
char	mode0[32] = {	/* R_NORM */
	'\200',	'\201',	'\202',	'\203',	'\204',	'\205',	'\206',	'\207',
	'\210',	'\211',	'\212',	'\213',	'\214',	'\215',	'\216',	'\217',
	'\220',	'\221',	'\222',	'\223',	'\224',	'\225',	'\226',	'\227',
	'\230',	'\231',	'\232',	'\233',	'\234',	'\235',	'\236',	'\237'
};

/*
 * Additional Relocation Mode Definitions
 */

/*
 *	#define		R_L1U7	0100		Bit Positioning
 */
char	mode1[32] = {	/* R_L1U7 */
	'\207',	'\001',	'\002',	'\003',	'\004',	'\005',	'\006',	'\007',
	'\010',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

/*
 *	#define		R_3BIT	0200		No Bit Positioning
 */
char	mode2[32] = {	/* R_3BIT */
	'\000',	'\201',	'\202',	'\203',	'\004',	'\005',	'\006',	'\007',
	'\010',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

/*
 *	#define		R_L3U4	0300		Bit Positioning
 */
char	mode3[32] = {	/* R_L3U4 */
	'\204',	'\205',	'\206',	'\003',	'\004',	'\005',	'\006',	'\007',
	'\010',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

/*
 *	#define		R_7BIT	0400		No Bit Positioning
 */
char	mode4[32] = {	/* R_7BIT */
	'\000',	'\201',	'\202',	'\203',	'\204',	'\205',	'\206',	'\207',
	'\010',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

/*
 *	#define		R_L12	0500		No Bit Positioning
 */
char	mode5[32] = {	/* R_L12 */
	'\200',	'\201',	'\202',	'\203',	'\204',	'\205',	'\206',	'\207',
	'\210',	'\211',	'\212',	'\213',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

/*
 *	#define		R_LU8	0600		Bit Positioning
 */
char	mode6[32] = {	/* R_LU8 */
	'\210',	'\211',	'\212',	'\213',	'\214',	'\215',	'\216',	'\217',
	'\010',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

/*
 *	#define		R_LU12	0700		Bit Positioning
 */
char	mode7[32] = {	/* R_LU12 */
	'\204',	'\205',	'\206',	'\207',	'\210',	'\211',	'\212',	'\213',
	'\214',	'\215',	'\216',	'\217',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};


/* None Required */

/*
 *     *m_def is a pointer to the bit relocation definition.
 *	m_flag indicates that bit position swapping is required.
 *	m_dbits contains the active bit positions for the output.
 *	m_sbits contains the active bit positions for the input.
 *
 *	struct	mode
 *	{
 *		char *	m_def;		Bit Relocation Definition
 *		a_uint	m_flag;		Bit Swapping Flag
 *		a_uint	m_dbits;	Destination Bit Mask
 *		a_uint	m_sbits;	Source Bit Mask
 *	};
 */
struct	mode	mode[8] = {
    {	&mode0[0],	0,	0x0000FFFF,	0x0000FFFF	},
    {	&mode1[0],	1,	0x00000080,	0x00000001	},
    {	&mode2[0],	0,	0x0000000E,	0x0000000E	},
    {	&mode3[0],	1,	0x00000070,	0x00000007	},
    {	&mode4[0],	0,	0x000000FE,	0x000000FE	},
    {	&mode5[0],	0,	0x00000FFF,	0x00000FFF	},
    {	&mode6[0],	1,	0x0000FF00,	0x000000FF	},
    {	&mode7[0],	1,	0x0000FFF0,	0x00000FFF	}
};

/*
 * Array of Pointers to mode Structures
 */
struct	mode	*modep[16] = {
	&mode[0],	&mode[1],	&mode[2],	&mode[3],
	&mode[4],	&mode[5],	&mode[6],	&mode[7],
	NULL,		NULL,		NULL,		NULL,
	NULL,		NULL,		NULL,		NULL
};

/*
 * Mnemonic Structure
 */
struct	mne	mne[] = {

	/* assembler */

    {	NULL,	".enabl",	S_OPTN,		0,	O_ENBL	},
    {	NULL,	".dsabl",	S_OPTN,		0,	O_DSBL	},
    {	NULL,	".page",	S_PAGE,		0,	0	},
    {	NULL,	".title",	S_HEADER,	0,	O_TITLE	},
    {	NULL,	".sbttl",	S_HEADER,	0,	O_SBTTL	},
    {	NULL,	".module",	S_MODUL,	0,	0	},
    {	NULL,	".include",	S_INCL,		0,	I_CODE	},
    {	NULL,	".incbin",	S_INCL,		0,	I_BNRY	},
    {	NULL,	".area",	S_AREA,		0,	0	},
    {	NULL,	".psharea",	S_AREA,		0,	O_PSH	},
    {	NULL,	".poparea",	S_AREA,		0,	O_POP	},
    {	NULL,	".bank",	S_BANK,		0,	0	},
    {	NULL,	".org",		S_ORG,		0,	0	},
    {	NULL,	".radix",	S_RADIX,	0,	0	},
    {	NULL,	".globl",	S_GLOBL,	0,	0	},
    {	NULL,	".local",	S_LOCAL,	0,	0	},
    {	NULL,	".if",		S_CONDITIONAL,	0,	O_IF	},
    {	NULL,	".iff",		S_CONDITIONAL,	0,	O_IFF	},
    {	NULL,	".ift",		S_CONDITIONAL,	0,	O_IFT	},
    {	NULL,	".iftf",	S_CONDITIONAL,	0,	O_IFTF	},
    {	NULL,	".ifdef",	S_CONDITIONAL,	0,	O_IFDEF	},
    {	NULL,	".ifndef",	S_CONDITIONAL,	0,	O_IFNDEF},
    {	NULL,	".ifgt",	S_CONDITIONAL,	0,	O_IFGT	},
    {	NULL,	".iflt",	S_CONDITIONAL,	0,	O_IFLT	},
    {	NULL,	".ifge",	S_CONDITIONAL,	0,	O_IFGE	},
    {	NULL,	".ifle",	S_CONDITIONAL,	0,	O_IFLE	},
    {	NULL,	".ifeq",	S_CONDITIONAL,	0,	O_IFEQ	},
    {	NULL,	".ifne",	S_CONDITIONAL,	0,	O_IFNE	},
    {	NULL,	".ifb",		S_CONDITIONAL,	0,	O_IFB	},
    {	NULL,	".ifnb",	S_CONDITIONAL,	0,	O_IFNB	},
    {	NULL,	".ifidn",	S_CONDITIONAL,	0,	O_IFIDN	},
    {	NULL,	".ifdif",	S_CONDITIONAL,	0,	O_IFDIF	},
    {	NULL,	".iif",		S_CONDITIONAL,	0,	O_IIF	},
    {	NULL,	".iiff",	S_CONDITIONAL,	0,	O_IIFF	},
    {	NULL,	".iift",	S_CONDITIONAL,	0,	O_IIFT	},
    {	NULL,	".iiftf",	S_CONDITIONAL,	0,	O_IIFTF	},
    {	NULL,	".iifdef",	S_CONDITIONAL,	0,	O_IIFDEF},
    {	NULL,	".iifndef",	S_CONDITIONAL,	0,	O_IIFNDEF},
    {	NULL,	".iifgt",	S_CONDITIONAL,	0,	O_IIFGT	},
    {	NULL,	".iiflt",	S_CONDITIONAL,	0,	O_IIFLT	},
    {	NULL,	".iifge",	S_CONDITIONAL,	0,	O_IIFGE	},
    {	NULL,	".iifle",	S_CONDITIONAL,	0,	O_IIFLE	},
    {	NULL,	".iifeq",	S_CONDITIONAL,	0,	O_IIFEQ	},
    {	NULL,	".iifne",	S_CONDITIONAL,	0,	O_IIFNE	},
    {	NULL,	".iifb",	S_CONDITIONAL,	0,	O_IIFB	},
    {	NULL,	".iifnb",	S_CONDITIONAL,	0,	O_IIFNB	},
    {	NULL,	".iifidn",	S_CONDITIONAL,	0,	O_IIFIDN},
    {	NULL,	".iifdif",	S_CONDITIONAL,	0,	O_IIFDIF},
    {	NULL,	".else",	S_CONDITIONAL,	0,	O_ELSE	},
    {	NULL,	".endif",	S_CONDITIONAL,	0,	O_ENDIF	},
    {	NULL,	".list",	S_LISTING,	0,	O_LIST	},
    {	NULL,	".nlist",	S_LISTING,	0,	O_NLIST	},
    {	NULL,	".equ",		S_EQU,		0,	O_EQU	},
    {	NULL,	".gblequ",	S_EQU,		0,	O_GBLEQU},
    {	NULL,	".lclequ",	S_EQU,		0,	O_LCLEQU},
    {	NULL,	".byte",	S_DATA,		0,	O_1BYTE	},
    {	NULL,	".db",		S_DATA,		0,	O_1BYTE	},
    {	NULL,	".fcb",		S_DATA,		0,	O_1BYTE	},
    {	NULL,	".word",	S_DATA,		0,	O_2BYTE	},
    {	NULL,	".dw",		S_DATA,		0,	O_2BYTE	},
    {	NULL,	".fdb",		S_DATA,		0,	O_2BYTE	},
/*    {	NULL,	".3byte",	S_DATA,		0,	O_3BYTE	},	*/
/*    {	NULL,	".triple",	S_DATA,		0,	O_3BYTE	},	*/
/*    {	NULL,	".dl",		S_DATA,		0,	O_4BYTE	},	*/
/*    {	NULL,	".4byte",	S_DATA,		0,	O_4BYTE	},	*/
/*    {	NULL,	".quad",	S_DATA,		0,	O_4BYTE	},	*/
/*    {	NULL,	".long",	S_DATA,		0,	O_4BYTE	},	*/
    {	NULL,	".blkb",	S_BLK,		0,	O_1BYTE	},
    {	NULL,	".ds",		S_BLK,		0,	O_1BYTE	},
    {	NULL,	".rmb",		S_BLK,		0,	O_1BYTE	},
    {	NULL,	".rs",		S_BLK,		0,	O_1BYTE	},
    {	NULL,	".blkw",	S_BLK,		0,	O_2BYTE	},
/*    {	NULL,	".blk3",	S_BLK,		0,	O_3BYTE	},	*/
/*    {	NULL,	".blk4",	S_BLK,		0,	O_4BYTE	},	*/
/*    {	NULL,	".blkl",	S_BLK,		0,	O_4BYTE	},	*/
    {	NULL,	".ascii",	S_ASCIX,	0,	O_ASCII	},
    {	NULL,	".ascis",	S_ASCIX,	0,	O_ASCIS	},
    {	NULL,	".asciz",	S_ASCIX,	0,	O_ASCIZ	},
    {	NULL,	".str",		S_ASCIX,	0,	O_ASCII	},
    {	NULL,	".strs",	S_ASCIX,	0,	O_ASCIS	},
    {	NULL,	".strz",	S_ASCIX,	0,	O_ASCIZ	},
    {	NULL,	".fcc",		S_ASCIX,	0,	O_ASCII	},
    {	NULL,	".define",	S_DEFINE,	0,	O_DEF	},
    {	NULL,	".undefine",	S_DEFINE,	0,	O_UNDEF	},
    {	NULL,	".even",	S_BOUNDARY,	0,	O_EVEN	},
    {	NULL,	".odd",		S_BOUNDARY,	0,	O_ODD	},
    {	NULL,	".bndry",	S_BOUNDARY,	0,	O_BNDRY	},
    {	NULL,	".msg"	,	S_MSG,		0,	0	},
    {	NULL,	".assume",	S_ERROR,	0,	O_ASSUME},
    {	NULL,	".error",	S_ERROR,	0,	O_ERROR	},
/*    {	NULL,	".msb",		S_MSB,		0,	0	},	*/
/*    {	NULL,	".lohi",	S_MSB,		0,	O_LOHI	},	*/
/*    {	NULL,	".hilo",	S_MSB,		0,	O_HILO	},	*/
/*    {	NULL,	".8bit",	S_BITS,		0,	O_1BYTE	},	*/
/*    {	NULL,	".16bit",	S_BITS,		0,	O_2BYTE	},	*/
/*    {	NULL,	".24bit",	S_BITS,		0,	O_3BYTE	},	*/
/*    {	NULL,	".32bit",	S_BITS,		0,	O_4BYTE	},	*/
    {	NULL,	".trace",	S_TRACE,	0,	O_TRC	},
    {	NULL,	".ntrace",	S_TRACE,	0,	O_NTRC	},
/*    {	NULL,	"_______",	S_CONST,	0,	VALUE	},	*/
    {	NULL,	".end",		S_END,		0,	0	},

	/* Macro Processor */

    {	NULL,	".macro",	S_MACRO,	0,	O_MACRO	},
    {	NULL,	".endm",	S_MACRO,	0,	O_ENDM	},
    {	NULL,	".mexit",	S_MACRO,	0,	O_MEXIT	},

    {	NULL,	".narg",	S_MACRO,	0,	O_NARG	},
    {	NULL,	".nchr",	S_MACRO,	0,	O_NCHR	},
    {	NULL,	".ntyp",	S_MACRO,	0,	O_NTYP	},

    {	NULL,	".irp",		S_MACRO,	0,	O_IRP	},
    {	NULL,	".irpc",	S_MACRO,	0,	O_IRPC	},
    {	NULL,	".rept",	S_MACRO,	0,	O_REPT	},

    {	NULL,	".nval",	S_MACRO,	0,	O_NVAL	},

    {	NULL,	".mdelete",	S_MACRO,	0,	O_MDEL	},

	/* Basic z8 (Note Changes) */

    {	NULL,	"dec",		S_SOP,		0,	0x30	},	/* Changed */
    {	NULL,	"rlc",		S_SOP,		0,	0x10	},
    {	NULL,	"inc",		S_INC,		0,	0x20	},

    {	NULL,	"da",		S_SOP,		0,	0x40	},
    {	NULL,	"pop",		S_SOP,		0,	0x50	},
    {	NULL,	"com",		S_SOP,		0,	0x60	},
    {	NULL,	"push",		S_SOP,		0,	0x70	},	/* Changed */
    {	NULL,	"decw",		S_DECW,		0,	0x80	},
    {	NULL,	"rl",		S_SOP,		0,	0x90	},
    {	NULL,	"incw",		S_INCW,		0,	0xA0	},
    {	NULL,	"clr",		S_SOP,		0,	0xB0	},
    {	NULL,	"rrc",		S_SOP,		0,	0xC0	},
    {	NULL,	"sra",		S_SOP,		0,	0xD0	},
    {	NULL,	"rr",		S_SOP,		0,	0xE0	},
    {	NULL,	"swap",		S_SOP,		0,	0xF0	},


    {	NULL,	"add",		S_DOP,		0,	0x02	},
    {	NULL,	"adc",		S_DOP,		0,	0x12	},
    {	NULL,	"sub",		S_DOP,		0,	0x22	},
    {	NULL,	"sbc",		S_DOP,		0,	0x32	},
    {	NULL,	"or",		S_DOP,		0,	0x42	},
    {	NULL,	"and",		S_DOP,		0,	0x52	},
    {	NULL,	"tcm",		S_DOP,		0,	0x62	},
    {	NULL,	"tm",		S_DOP,		0,	0x72	},

    {	NULL,	"cp",		S_DOP,		0,	0xA2	},
    {	NULL,	"xor",		S_DOP,		0,	0xB2	},

    {	NULL,	"ld",		S_LD,		0,	0x0C	},	/* Changed */

    {	NULL,	"ldc",		S_LDCE,		0,	0xC2	},	/* Changed */
    {	NULL,	"ldci",		S_LDCEI,	0,	0xC3	},	/* Changed */

    {	NULL,	"lde",		S_LDCE,		0,	0x82	},	/* Changed */
    {	NULL,	"ldei",		S_LDCEI,	0,	0x83	},	/* Changed */

    {	NULL,	"djnz",		S_DJNZ,		0,	0x0A	},
    {	NULL,	"jr",		S_JR,		0,	0x0B	},
    {	NULL,	"jp",		S_JP,		0,	0x0D	},

    {	NULL,	"call",		S_CALL,		0,	0xD4	},

    {	NULL,	"srp",		S_SRP,		0,	0x01	},	/* Changed */

/*    {	NULL,	"wdh",		S_INH,		0,	0x4F	}, */	/* Changed */
    {	NULL,	"wdt",		S_INH,		0,	0x5F	},
    {	NULL,	"stop",		S_INH,		0,	0x6F	},
    {	NULL,	"halt",		S_INH,		0,	0x7F	},
    {	NULL,	"di",		S_INH,		0,	0x8F	},
    {	NULL,	"ei",		S_INH,		0,	0x9F	},
    {	NULL,	"ret",		S_INH,		0,	0xAF	},
    {	NULL,	"iret",		S_INH,		0,	0xBF	},
    {	NULL,	"rcf",		S_INH,		0,	0xCF	},
    {	NULL,	"scf",		S_INH,		0,	0xDF	},
    {	NULL,	"ccf",		S_INH,		0,	0xEF	},
    {	NULL,	"nop",		S_INH,		0,	0x0F	},	/* Changed */

	/* ez8 Additions */

    {	NULL,	"pushx",	S_PUPOX,	0,	0xC8	},
    {	NULL,	"popx",		S_PUPOX,	0,	0xD8	},

    {	NULL,	"srl",		S_SOP,		O_PG2,	0xC0	},	/* Page 2 */

    {	NULL,	"addx",		S_DOPX,		0,	0x08	},
    {	NULL,	"adcx",		S_DOPX,		0,	0x18	},
    {	NULL,	"subx",		S_DOPX,		0,	0x28	},
    {	NULL,	"sbcx",		S_DOPX,		0,	0x38	},
    {	NULL,	"orx",		S_DOPX,		0,	0x48	},
    {	NULL,	"andx",		S_DOPX,		0,	0x58	},
    {	NULL,	"tcmx",		S_DOPX,		0,	0x68	},
    {	NULL,	"tmx",		S_DOPX,		0,	0x78	},

    {	NULL,	"cpx",		S_DOPX,		0,	0xA8	},
    {	NULL,	"xorx",		S_DOPX,		0,	0xB8	},

    {	NULL,	"cpc",		S_DOP,		O_PG2,	0xA2	},	/* Page 2 */
    {	NULL,	"cpcx",		S_DOPX,		O_PG2,	0xA8	},	/* Page 2 */

    {	NULL,	"ldx",		S_LDX,		0,	0x84	},
    {	NULL,	"ldwx",		S_LDWX,		O_PG2,	0xE8	},	/* Page 2 */

    {	NULL,	"lea",		S_LEA,		0,	0x98	},

    {	NULL,	"bit",		S_BIT,		O_BIT,	0xE2	},
    {	NULL,	"bclr",		S_BIT,		O_CLR,	0xE2	},
    {	NULL,	"bset",		S_BIT,		O_SET,	0xE2	},
    {	NULL,	"bswap",	S_BSWAP,	0,	0xD5	},
    {	NULL,	"trap",		S_TRAP,		0,	0xF2	},
    {	NULL,	"mult",		S_MUL,		0,	0xF4	},
    {	NULL,	"btj",		S_BTJ,		O_BTJ,	0xF6	},
    {	NULL,	"btjnz",	S_BTJ,		O_NZ,	0xF6	},
    {	NULL,	"btjz",		S_BTJ,		O_Z,	0xF6	},

    {	NULL,	"brk",		S_INH,		0,	0x00	},
    {	NULL,	"atm",		S_INH,		S_EOL,	0x2F	},
};
