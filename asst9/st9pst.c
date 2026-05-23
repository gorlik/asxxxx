/* st9pst.c */

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
 *
 * Specification for the 6-bit Segment addressing:
 */
char mode1[32] = {	/* M_SEG  = 0x1000 */
	'\200',	'\201',	'\202',	'\203',	'\204',	'\205',	'\006',	'\007',
	'\010',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

/*
 * Specification for the 6-bit SPP addressing:
 */
char mode2[32] = {	/* M_SPP = 0x0200 */
	'\202',	'\203',	'\204',	'\205',	'\206',	'\207',	'\006',	'\007',
	'\010',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

/*
 * Specification for the 5-bit SRP addressing:
 */
char mode3[32] = {	/* M_SRP = 0x0300*/
	'\203',	'\204',	'\205',	'\206',	'\207',	'\005',	'\006',	'\007',
	'\010',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

/*
 * Specification for the 3-bit addressing:
 * BAND, BCPL, BLD, BOR, BRES, BSET, BTJF, BTJT, BTSET, BXOR
 */
char mode4[32] = {	/* M_BXXX = 0x0400*/
	'\205',	'\206',	'\207',	'\003',	'\004',	'\005',	'\006',	'\007',
	'\010',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

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
struct	mode	mode[5] = {
    {	&mode0[0],	0,	0x0000FFFF,	0x0000FFFF	},
    {	&mode1[0],	0,	0x0000003F,	0x0000003F	},
    {	&mode2[0],	1,	0x000000FC,	0x0000003F	},
    {	&mode3[0],	1,	0x000000F8,	0x0000001F	},
    {	&mode4[0],	1,	0x000000E0,	0x00000007	}
};


/*
 * Array of Pointers to mode Structures
 */
struct	mode	*modep[16] = {
	&mode[0],	&mode[1],	&mode[2],	&mode[3],
	&mode[4],	NULL,		NULL,		NULL,
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
    {	NULL,	".3byte",	S_DATA,		0,	O_3BYTE	},
    {	NULL,	".triple",	S_DATA,		0,	O_3BYTE	},
/*    {	NULL,	".dl",		S_DATA,		0,	O_4BYTE	},	*/
/*    {	NULL,	".4byte",	S_DATA,		0,	O_4BYTE	},	*/
/*    {	NULL,	".quad",	S_DATA,		0,	O_4BYTE	},	*/
/*    {	NULL,	".long",	S_DATA,		0,	O_4BYTE	},	*/
    {	NULL,	".blkb",	S_BLK,		0,	O_1BYTE	},
    {	NULL,	".ds",		S_BLK,		0,	O_1BYTE	},
    {	NULL,	".rmb",		S_BLK,		0,	O_1BYTE	},
    {	NULL,	".rs",		S_BLK,		0,	O_1BYTE	},
    {	NULL,	".blkw",	S_BLK,		0,	O_2BYTE	},
    {	NULL,	".blk3",	S_BLK,		0,	O_3BYTE	},
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
    {	NULL,	".msb",		S_MSB,		0,	0	},
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

	/* stm9 Instructions */

    {	NULL,	"or",		I_TYP1,		0,	0x02	},
    {	NULL,	"and",		I_TYP1,		0,	0x12	},
    {	NULL,	"sbc",		I_TYP1,		0,	0x22	},
    {	NULL,	"adc",		I_TYP1,		0,	0x32	},
    {	NULL,	"add",		I_TYP1,		0,	0x42	},
    {	NULL,	"sub",		I_TYP1,		0,	0x52	},
    {	NULL,	"xor",		I_TYP1,		0,	0x62	},
    {	NULL,	"tcm",		I_TYP1,		0,	0x82	},
    {	NULL,	"cp",		I_TYP1,		0,	0x92	},
    {	NULL,	"tm",		I_TYP1,		0,	0xA2	},

    {	NULL,	"orw",		I_TYP2,		0,	0x0E	},
    {	NULL,	"andw",		I_TYP2,		0,	0x1E	},
    {	NULL,	"sbcw",		I_TYP2,		0,	0x2E	},
    {	NULL,	"adcw",		I_TYP2,		0,	0x3E	},
    {	NULL,	"addw",		I_TYP2,		0,	0x4E	},
    {	NULL,	"subw",		I_TYP2,		0,	0x5E	},
    {	NULL,	"xorw",		I_TYP2,		0,	0x6E	},
    {	NULL,	"tcmw",		I_TYP2,		0,	0x8E	},
    {	NULL,	"cpw",		I_TYP2,		0,	0x9E	},
    {	NULL,	"tmw",		I_TYP2,		0,	0xAE	},

    {	NULL,	"ld",		I_LD,		0,	0xF0	},
    {	NULL,	"ldw",		I_LDW,		0,	0xF0	},

    {	NULL,	"band",		I_BAND,		0,	0x1F	},
    {	NULL,	"bcpl",		I_BCPL,		0,	0x6F	},
    {	NULL,	"bld",		I_BLD,		0,	0xF2	},
    {	NULL,	"bor",		I_BOR,		0,	0x0F	},
    {	NULL,	"bres",		I_BRES,		0,	0x1F	},
    {	NULL,	"bset",		I_BSET,		0,	0x0F	},
    {	NULL,	"btset",	I_BTSET,	0,	0xF2	},
    {	NULL,	"bxor",		I_BXOR,		0,	0x6F	},

    {	NULL,	"btjf",		I_BTJF,		0,	0xAF	},
    {	NULL,	"btjt",		I_BTJT,		0,	0xAF	},

    {	NULL,	"call",		I_CALL,		0,	0x74	},
    {	NULL,	"calls",	I_CALLS,	0,	0x73	},
    {	NULL,	"clr",		I_CLR,		0,	0x90	},
    {	NULL,	"cpjfi",	I_CPJFI,	0,	0x9F	},
    {	NULL,	"cpjti",	I_CPJTI,	0,	0x9F	},
    {	NULL,	"cpl",		I_CPL,		0,	0x80	},

    {	NULL,	"da",		I_DA,		0,	0x70	},
    {	NULL,	"dec",		I_DEC,		0,	0x40	},
    {	NULL,	"decw",		I_DECW,		0,	0xCF	},
    {	NULL,	"div",		I_DIV,		0,	0x5F	},
    {	NULL,	"divws",	I_DIVWS,	0,	0x56	},
    {	NULL,	"djnz",		I_DJNZ,		0,	0x0A	},
    {	NULL,	"dwjnz",	I_DWJNZ,	0,	0xC6	},

    {	NULL,	"ext",		I_EXT,		0,	0xC6	},

    {	NULL,	"halt",		I_HALT,		0,	0xBF	},

    {	NULL,	"inc",		I_INC,		0,	0x50	},
    {	NULL,	"incw",		I_INCW,		0,	0xDF	},

    {	NULL,	"ccf",		I_INH,	   	0,	0x61	},
    {	NULL,	"di",		I_INH,		0,	0x10	},
    {	NULL,	"ei",		I_INH,	   	0,	0x00	},
    {	NULL,	"iret",		I_INH,		0,	0xD3	},
    {	NULL,	"nop",		I_INH,		0,	0xFF	},
    {	NULL,	"rcf",		I_INH,		0,	0x11	},
    {	NULL,	"ret",		I_INH,		0,	0x46	},
    {	NULL,	"scf",		I_INH,	   	0,	0x01	},
    {	NULL,	"sdm",		I_INH,		0,	0xFE	},
    {	NULL,	"spm",		I_INH,		0,	0xEE	},

    {	NULL,	"jp",		I_JP,		0,	0xD4	},
    {	NULL,	"jps",		I_JPS,		0,	0x73	},

    {	NULL,	"jpf",		I_JPCC,		0,	0x0D	},	/*       -------        */
    {	NULL,	"jpt",		I_JPCC,		0,	0x8D	},	/*       -------        */
    {	NULL,	"jpc",		I_JPCC,		0,	0x7D	},	/*        C = 1         */
    {	NULL,	"jpnc",		I_JPCC,		0,	0xFD	},	/*        C = 0         */
    {	NULL,	"jpz",		I_JPCC,		0,	0x6D	},	/*        Z = 1         */
    {	NULL,	"jpnz",		I_JPCC,		0,	0xED	},	/*        Z = 0         */
    {	NULL,	"jppl",		I_JPCC,		0,	0xDD	},	/*        S = 0         */
    {	NULL,	"jpmi",		I_JPCC,		0,	0x5D	},	/*        S = 1         */
    {	NULL,	"jpov",		I_JPCC,		0,	0x4D	},	/*        V = 1         */
    {	NULL,	"jpnov",	I_JPCC,		0,	0xCD	},	/*        V = 0         */
    {	NULL,	"jpeq",		I_JPCC,		0,	0x6D	},	/*        Z = 1         */
    {	NULL,	"jpne",		I_JPCC,		0,	0xED	},	/*        Z = 0         */
    {	NULL,	"jpge",		I_JPCC,		0,	0x9D	},	/*     (S xor V) = 1    */
    {	NULL,	"jplt",		I_JPCC,		0,	0x1D	},	/*     (S xor V) = 0    */
    {	NULL,	"jpgt",		I_JPCC,		0,	0xAD	},	/* (Z or (S xor V)) = 0 */
    {	NULL,	"jple",		I_JPCC,		0,	0x2D	},	/* (Z or (S xor V)) = 1 */
    {	NULL,	"jpuge",	I_JPCC,		0,	0xFD	},	/*        C = 0         */
    {	NULL,	"jpult",	I_JPCC,		0,	0x7D	},	/*        C = 1         */
    {	NULL,	"jpugt",	I_JPCC,		0,	0xBD	},	/*   (C=0 and Z=0) = 1  */
    {	NULL,	"jpule",	I_JPCC,		0,	0x3D	},	/*     (C or Z) = 1     */

    {	NULL,	"jrf",		I_JRCC,		0,	0x0B	},	/*       -------        */
    {	NULL,	"jrt",		I_JRCC,		0,	0x8B	},	/*       -------        */
    {	NULL,	"jrc",		I_JRCC,		0,	0x7B	},	/*        C = 1         */
    {	NULL,	"jrnc",		I_JRCC,		0,	0xFB	},	/*        C = 0         */
    {	NULL,	"jrz",		I_JRCC,		0,	0x6B	},	/*        Z = 1         */
    {	NULL,	"jrnz",		I_JRCC,		0,	0xEB	},	/*        Z = 0         */
    {	NULL,	"jrpl",		I_JRCC,		0,	0xDB	},	/*        S = 0         */
    {	NULL,	"jrmi",		I_JRCC,		0,	0x5B	},	/*        S = 1         */
    {	NULL,	"jrov",		I_JRCC,		0,	0x4B	},	/*        V = 1         */
    {	NULL,	"jrnov",	I_JRCC,		0,	0xCB	},	/*        V = 0         */
    {	NULL,	"jreq",		I_JRCC,		0,	0x6B	},	/*        Z = 1         */
    {	NULL,	"jrne",		I_JRCC,		0,	0xEB	},	/*        Z = 0         */
    {	NULL,	"jrge",		I_JRCC,		0,	0x9B	},	/*     (S xor V) = 1    */
    {	NULL,	"jrlt",		I_JRCC,		0,	0x1B	},	/*     (S xor V) = 0    */
    {	NULL,	"jrgt",		I_JRCC,		0,	0xAB	},	/* (Z or (S xor V)) = 0 */
    {	NULL,	"jrle",		I_JRCC,		0,	0x2B	},	/* (Z or (S xor V)) = 1 */
    {	NULL,	"jruge",	I_JRCC,		0,	0xFB	},	/*        C = 0         */
    {	NULL,	"jrult",	I_JRCC,		0,	0x7B	},	/*        C = 1         */
    {	NULL,	"jrugt",	I_JRCC,		0,	0xBB	},	/*   (C=0 and Z=0) = 1  */
    {	NULL,	"jrule",	I_JRCC,		0,	0x3B	},	/*     (C or Z) = 1     */

    {	NULL,	"ldpp",		I_LDPP,		0,	0xD6	},
    {	NULL,	"lddp",		I_LDDP,		0,	0xD6	},
    {	NULL,	"ldpd",		I_LDPD,		0,	0xD6	},
    {	NULL,	"lddd",		I_LDDD,		0,	0xD6	},
    {	NULL,	"link",		I_LINK,		0,	0xD4	},
    {	NULL,	"linku",	I_LINKU,	0,	0xB6	},

    {	NULL,	"mul",		I_MUL,		0,	0x4F	},

    {	NULL,	"pea",		I_PEA,		0,	0xBF	},
    {	NULL,	"peau",		I_PEAU,		0,	0xBF	},
    {	NULL,	"pop",		I_POP,		0,	0x76	},
    {	NULL,	"popu",		I_POPU,		0,	0x20	},
    {	NULL,	"popuw",	I_POPUW,	0,	0xB7	},
    {	NULL,	"popw",		I_POPW,		0,	0x75	},
    {	NULL,	"push",		I_PUSH,		0,	0x66	},
    {	NULL,	"pushu",	I_PUSHU,	0,	0x30	},
    {	NULL,	"pushuw",	I_PUSHUW,	0,	0xB6	},
    {	NULL,	"pushw",	I_PUSHW,	0,	0x74	},

    {	NULL,	"rets",		I_RETS,		0,	0xF6	},
    {	NULL,	"rlc",		I_RLC,		0,	0xB0	},
    {	NULL,	"rlcw",		I_RLCW,		0,	0xBF	},
    {	NULL,	"rol",		I_ROL,		0,	0xA0	},
    {	NULL,	"ror",		I_ROR,		0,	0xC0	},
    {	NULL,	"rrc",		I_RRC,		0,	0xD0	},
    {	NULL,	"rrcw",		I_RRCW,		0,	0x36	},

    {	NULL,	"sla",		I_SLA,		0,	0x42	},
    {	NULL,	"slaw",		I_SLAW,		0,	0x4E	},
    {	NULL,	"spp",		I_SPP,		0,	0xC7	},
    {	NULL,	"sra",		I_SRA,		0,	0xE0	},
    {	NULL,	"sraw",		I_SRAW,		0,	0x2F	},
    {	NULL,	"srp",		I_SRP,		0,	0xC7	},
    {	NULL,	"srp0",		I_SRP0,		0,	0xC7	},
    {	NULL,	"srp1",		I_SRP1,		0,	0xC7	},
    {	NULL,	"swap",		I_SWAP,		0,	0xF0	},

    {	NULL,	"unlink",	I_UNLINK,	0,	0x75	},
    {	NULL,	"unlinku",	I_UNLINKU,	0,	0x87	},

    {	NULL,	"wfi",		I_WFI,		0,	0xEF	},

    {	NULL,	"xch",		I_XCH,		S_EOL,	0x16	}

};
