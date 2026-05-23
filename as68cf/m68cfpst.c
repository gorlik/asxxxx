/* m68cfpst.c */

/*
 *  Copyright (C) 2023-2024  Alan R. Baldwin
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
#include "m68cf.h"

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
 *	#define		R_4BIT	0100		No Bit Positioning
 */
char	mode1[32] = {	/* R_4BIT */
	'\200',	'\201',	'\202',	'\203',	'\004',	'\005',	'\006',	'\007',
	'\010',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

/*
 *	#define		R_QBITS	0200		Bit Positioning
 */
char	mode2[32] = {	/* R_QBITS */
	'\211',	'\212',	'\213',	'\003',	'\004',	'\005',	'\006',	'\007',
	'\010',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

/*
 *	#define		R_CRBTS	0300		No Bit Positioning
 */
char	mode3[32] = {	/* R_CRBTS */
	'\200',	'\201',	'\202',	'\203',	'\204',	'\205',	'\206',	'\007',
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
struct	mode	mode[4] = {
    {	&mode0[0],	0,	0x0000FFFF,	0x0000FFFF	},
    {	&mode1[0],	0,	0x0000000F,	0x0000000F	},
    {	&mode2[0],	1,	0x00000E00,	0x00000003	},
    {	&mode3[0],	0,	0x0000007F,	0x0000007F	}
};

/*
 * Array of Pointers to Mode Structures
 */
struct	mode	*modep[16] = {
	&mode[0],	&mode[1],	&mode[2],	&mode[3],
	NULL,		NULL,		NULL,		NULL,
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
    {	NULL,	".dl",		S_DATA,		0,	O_4BYTE	},
    {	NULL,	".4byte",	S_DATA,		0,	O_4BYTE	},
    {	NULL,	".quad",	S_DATA,		0,	O_4BYTE	},
    {	NULL,	".long",	S_DATA,		0,	O_4BYTE	},
    {	NULL,	".blkb",	S_BLK,		0,	O_1BYTE	},
    {	NULL,	".ds",		S_BLK,		0,	O_1BYTE	},
    {	NULL,	".rmb",		S_BLK,		0,	O_1BYTE	},
    {	NULL,	".rs",		S_BLK,		0,	O_1BYTE	},
    {	NULL,	".blkw",	S_BLK,		0,	O_2BYTE	},
    {	NULL,	".blk3",	S_BLK,		0,	O_3BYTE	},
    {	NULL,	".blk4",	S_BLK,		0,	O_4BYTE	},
    {	NULL,	".blkl",	S_BLK,		0,	O_4BYTE	},
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
/*  {	NULL,	".lohi",	S_MSB,		0,	O_LOHI	},  */
/*  {	NULL,	".hilo",	S_MSB,		0,	O_HILO	},  */
/*  {	NULL,	".8bit",	S_BITS,		0,	O_1BYTE	},  */
/*  {	NULL,	".16bit",	S_BITS,		0,	O_2BYTE	},  */
/*  {	NULL,	".24bit",	S_BITS,		0,	O_3BYTE	},  */
/*  {	NULL,	".32bit",	S_BITS,		0,	O_4BYTE	},  */
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

	/* Verify Addressing Modes Directive */

    {	NULL,	".m68k",	S_M68K,		A_L,	0	},
    {	NULL,	".m68k.b",	S_M68K,		A_B,	0	},
    {	NULL,	".m68k.w",	S_M68K,		A_W,	0	},
    {	NULL,	".m68k.l",	S_M68K,		A_L,	0	},

	/*
	 * ColdFire Machine
	 */

    {	NULL,	".setdp",	S_SDP,		0,	0	},
    {	NULL,	".dpgbl",	S_PGD,		0,	0	},
    {	NULL,	".lodpgbl",	S_PGD,		1,	0	},
    {	NULL,	".hidpgbl",	S_PGD,		2,	0	},

    {	NULL,	".flt16",	S_FLT16,	0,	0	},
    {	NULL,	".flt32",	S_FLT32,	0,	0	},
    {	NULL,	".flt64",	S_FLT64,	0,	0	},

    {	NULL,	".dword",	S_DATA,		0,	O_4BYTE	},

	/* Extended Instructions */

    /*---*/
    {	NULL,	"addx",		S_TYP1,		A_L,	0xD180	},
    {	NULL,	"addx.l",	S_TYP1,		A_L,	0xD180	},
    /*---*/
    {	NULL,	"subx",		S_TYP1,		A_L,	0x9180	},
    {	NULL,	"subx.l",	S_TYP1,		A_L,	0x9180	},

	/* ADD, AND, OR, And SUB Instructions */

    {	NULL,	"add",		S_TYP2,		A_L,	0xD080	},
    {	NULL,	"add.l",	S_TYP2,		A_L,	0xD080	},
    /*---*/
    {	NULL,	"and",		S_TYP2,	  	A_L,	0xC080	},
    {	NULL,	"and.l",	S_TYP2,		A_L,	0xC080	},
    /*---*/
    {	NULL,	"or",		S_TYP2,	  	A_L,	0x8080	},
    {	NULL,	"or.l",		S_TYP2,		A_L,	0x8080	},
    /*---*/
    {	NULL,	"sub",		S_TYP2,		A_L,	0x9080	},
    {	NULL,	"sub.l",	S_TYP2,		A_L,	0x9080	},

	/* 'An' Destination Instructions */

    {	NULL,	"adda",		S_TYP3,		A_L,	0xD1C0	},
    {	NULL,	"adda.l",	S_TYP3,		A_L,	0xD1C0	},
    /*---*/
    {	NULL,	"cmpa",		S_TYP3,		A_L,	0xB1C0	},
    {	NULL,	"cmpa.w",	S_TYP3,		A_W,	0xB0C0	},
    {	NULL,	"cmpa.l",	S_TYP3,		A_L,	0xB1C0	},
    /*---*/
    {	NULL,	"suba",		S_TYP3,		A_L,	0x91C0	},
    {	NULL,	"suba.l",	S_TYP3,		A_L,	0x91C0	},

	/* Immediate Data Instructions */

    {	NULL,	"addi",		S_TYP4,		A_L,	0x0680	},
    {	NULL,	"addi.l",	S_TYP4,		A_L,	0x0680	},
    /*---*/
    {	NULL,	"andi",		S_TYP4,   	A_L,	0x0280	},
    {	NULL,	"andi.l",	S_TYP4,		A_L,	0x0280	},
    /*---*/
    {	NULL,	"cmpi",		S_TYP4,		A_L,	0x0C80	},
    {	NULL,	"cmpi.b",	S_TYP4,		A_B,	0x0C00	},
    {	NULL,	"cmpi.w",	S_TYP4,		A_W,	0x0C40	},
    {	NULL,	"cmpi.l",	S_TYP4,		A_L,	0x0C80	},
    /*---*/
    {	NULL,	"eori",		S_TYP4,   	A_L,	0x0A80	},
    {	NULL,	"eori.l",	S_TYP4,		A_L,	0x0A80	},
    /*---*/
    {	NULL,	"ori",		S_TYP4,   	A_L,	0x0080	},
    {	NULL,	"ori.l",	S_TYP4,		A_L,	0x0080	},
    /*---*/
    {	NULL,	"subi",		S_TYP4,		A_L,	0x0480	},
    {	NULL,	"subi.l",	S_TYP4,		A_L,	0x0480	},

	/* Immediate Quick Insructions */

    {	NULL,	"addq",		S_TYP5,		A_L,	0x5080	},
    {	NULL,	"addq.l",	S_TYP5,		A_L,	0x5080	},
    /*---*/
    {	NULL,	"subq",		S_TYP5,		A_L,	0x5180	},
    {	NULL,	"subq.l",	S_TYP5,		A_L,	0x5180	},

	/* ___ <ea>,Dn Forms */

    {	NULL,	"divs",		S_TYP6,		A_L,	0x81C0	},
    {	NULL,	"divs.w",	S_TYP6,		A_W,	0x81C0	},
    {	NULL,	"divs.l",	S_TYP6,		A_L,	0x81C0	},
    /*---*/
    {	NULL,	"divu",		S_TYP6,		A_L,	0x80C0	},
    {	NULL,	"divu.w",	S_TYP6,		A_W,	0x80C0	},
    {	NULL,	"divu.l",	S_TYP6,		A_L,	0x80C0	},
    /*---*/
    {	NULL,	"muls",		S_TYP6,		A_L,	0xC1C0	},
    {	NULL,	"muls.w",	S_TYP6,		A_W,	0xC1C0	},
    {	NULL,	"muls.l",	S_TYP6,		A_L,	0xC1C0	},
    /*---*/
    {	NULL,	"mulu",		S_TYP6,		A_L,	0xC0C0	},
    {	NULL,	"mulu.w",	S_TYP6,		A_W,	0xC0C0	},
    {	NULL,	"mulu.l",	S_TYP6,		A_L,	0xC0C0	},

	/* Single Operand Instructions */

    {	NULL,	"clr",		S_TYP7,		A_L,	0x4280	},
    {	NULL,	"clr.b",	S_TYP7,		A_B,	0x4200	},
    {	NULL,	"clr.w",	S_TYP7,		A_W,	0x4240	},
    {	NULL,	"clr.l",	S_TYP7,		A_L,	0x4280	},
    /*---*/
    {	NULL,	"tst",		S_TYP7,		A_L,	0x4A40	},
    {	NULL,	"tst.b",	S_TYP7,		A_B,	0x4A00	},
    {	NULL,	"tst.w",	S_TYP7,		A_W,	0x4A40	},
    {	NULL,	"tst.l",	S_TYP7,		A_L,	0x4A80	},

	/* Limited Addressing Mode Instructions */

    {	NULL,	"jmp",		S_TYP8,		A_L,	0x4EC0	},
    {	NULL,	"jmp.l",	S_TYP8,		A_L,	0x4EC0	},
    /*---*/
    {	NULL,	"jsr",		S_TYP8,		A_L,	0x4E80	},
    {	NULL,	"jsr.l",	S_TYP8,		A_L,	0x4E80	},
    /*---*/
    {	NULL,	"lea",		S_TYP8,		A_L,	0x41C0	},
    {	NULL,	"lea.l",	S_TYP8,		A_L,	0x41C0	},
    /*---*/
    {	NULL,	"pea",		S_TYP8,		A_L,	0x4840	},
    {	NULL,	"pea.l",	S_TYP8,		A_L,	0x4840	},

	/* Register Only Instructions */

    {	NULL,	"byterev",	S_TYP9,		A_L,	0x02C0	},
    {	NULL,	"byterev.l",	S_TYP9,		A_L,	0x02C0	},
    /*---*/
    {	NULL,	"bitrev",	S_TYP9,		A_L,	0x00C0	},
    {	NULL,	"bitrev.l",	S_TYP9,		A_L,	0x00C0	},
    /*---*/
    {	NULL,	"ff1",		S_TYP9,		A_L,	0x04C0	},
    {	NULL,	"ff1.l",	S_TYP9,		A_L,	0x04C0	},
    /*---*/
    {	NULL,	"neg",		S_TYP9,		A_L,	0x4480	},
    {	NULL,	"neg.l",	S_TYP9,		A_L,	0x4480	},
    /*---*/
    {	NULL,	"negx",		S_TYP9,		A_L,	0x4080	},
    {	NULL,	"negx.l",	S_TYP9,		A_L,	0x4080	},
    /*---*/
    {	NULL,	"not",		S_TYP9,		A_L,	0x4680	},
    {	NULL,	"not.l",	S_TYP9,		A_L,	0x4680	},
    /*---*/
    {	NULL,	"swap",		S_TYP9,		A_W,	0x4840	},
    {	NULL,	"swap.w",	S_TYP9,		A_W,	0x4840	},
    /*---*/
    {	NULL,	"unlk",		S_UNLK,		A_U,	0x4E58	},
    /*---*/

	/* Set If Condition True Else Clear */

    {	NULL,	"st",		S_TYP9,		A_B,	0x50C0	},
    {	NULL,	"st.b",		S_TYP9,		A_B,	0x50C0	},
    /*---*/
    {	NULL,	"sf",		S_TYP9,		A_B,	0x51C0	},
    {	NULL,	"sf.b",		S_TYP9,		A_B,	0x51C0	},
    /*---*/
    {	NULL,	"shi",		S_TYP9,		A_B,	0x52C0	},
    {	NULL,	"shi.b",	S_TYP9,		A_B,	0x52C0	},
    /*---*/
    {	NULL,	"sls",		S_TYP9,		A_B,	0x53C0	},
    {	NULL,	"sls.b",	S_TYP9,		A_B,	0x53C0	},
    /*---*/
    {	NULL,	"scc",		S_TYP9,		A_B,	0x54C0	},
    {	NULL,	"scc.b",	S_TYP9,		A_B,	0x54C0	},
    /*---*/
    {	NULL,	"scs",		S_TYP9,		A_B,	0x55C0	},
    {	NULL,	"scs.b",	S_TYP9,		A_B,	0x55C0	},
    /*---*/
    {	NULL,	"sne",		S_TYP9,		A_B,	0x56C0	},
    {	NULL,	"sne.b",	S_TYP9,		A_B,	0x56C0	},
    /*---*/
    {	NULL,	"seq",		S_TYP9,		A_B,	0x57C0	},
    {	NULL,	"seq.b",	S_TYP9,		A_B,	0x57C0	},
    /*---*/
    {	NULL,	"svc",		S_TYP9,		A_B,	0x58C0	},
    {	NULL,	"svc.b",	S_TYP9,		A_B,	0x58C0	},
    /*---*/
    {	NULL,	"svs",		S_TYP9,		A_B,	0x59C0	},
    {	NULL,	"svs.b",	S_TYP9,		A_B,	0x59C0	},
    /*---*/
    {	NULL,	"spl",		S_TYP9,		A_B,	0x5AC0	},
    {	NULL,	"spl.b",	S_TYP9,		A_B,	0x5AC0	},
    /*---*/
    {	NULL,	"smi",		S_TYP9,		A_B,	0x5BC0	},
    {	NULL,	"smi.b",	S_TYP9,		A_B,	0x5BC0	},
    /*---*/
    {	NULL,	"sge",		S_TYP9,		A_B,	0x5CC0	},
    {	NULL,	"sge.b",	S_TYP9,		A_B,	0x5CC0	},
    /*---*/
    {	NULL,	"slt",		S_TYP9,		A_B,	0x5DC0	},
    {	NULL,	"slt.b",	S_TYP9,		A_B,	0x5DC0	},
    /*---*/
    {	NULL,	"sgt",		S_TYP9,		A_B,	0x5EC0	},
    {	NULL,	"sgt.b",	S_TYP9,		A_B,	0x5EC0	},
    /*---*/
    {	NULL,	"sle",		S_TYP9,		A_B,	0x5FC0	},
    {	NULL,	"sle.b",	S_TYP9,		A_B,	0x5FC0	},
    /*-- Alternate For SLS --*/
    {	NULL,	"slos",		S_TYP9,		A_B,	0x53C0	},
    {	NULL,	"slos.b",	S_TYP9,		A_B,	0x53C0	},
    /*-- Alternate For SCC --*/
    {	NULL,	"shs",		S_TYP9,		A_B,	0x54C0	},
    {	NULL,	"shs.b",	S_TYP9,		A_B,	0x54C0	},
    /*-- Alternate For SCC --*/
    {	NULL,	"shis",		S_TYP9,		A_B,	0x54C0	},
    {	NULL,	"shis.b",	S_TYP9,		A_B,	0x54C0	},
    /*-- Alternate For SCS --*/
    {	NULL,	"slo",		S_TYP9,		A_B,	0x55C0	},
    {	NULL,	"slo.b",	S_TYP9,		A_B,	0x55C0	},

	/* Shifting Instructions */

    {	NULL,	"asl",		S_SHFT,		A_L,	0xE180	},
    {	NULL,	"asl.l",	S_SHFT,		A_L,	0xE180	},
    /*---*/
    {	NULL,	"asr",		S_SHFT,		A_L,	0xE080	},
    {	NULL,	"asr.l",	S_SHFT,		A_L,	0xE080	},
    /*---*/
    {	NULL,	"lsl",		S_SHFT,		A_L,	0xE188	},
    {	NULL,	"lsl.l",	S_SHFT,		A_L,	0xE188	},
    /*---*/
    {	NULL,	"lsr",		S_SHFT,		A_L,	0xE088	},
    {	NULL,	"lsr.l",	S_SHFT,		A_L,	0xE088	},

	/* Branching Instructions */

    {	NULL,	"bra",		S_BCC,		B_A,	0x6000	},
    {	NULL,	"bra.b",	S_BCC,		B_B,	0x6000	},
    {	NULL,	"bra.s",	S_BCC,		B_B,	0x6000	},
    {	NULL,	"bra.w",	S_BCC,		B_W,	0x6000	},
    {	NULL,	"bra.l",	S_BCC,		B_L,	0x6000	},
    /*---*/
    {	NULL,	"bsr",		S_BCC,		B_A,	0x6100	},
    {	NULL,	"bsr.b",	S_BCC,		B_B,	0x6100	},
    {	NULL,	"bsr.s",	S_BCC,		B_B,	0x6100	},
    {	NULL,	"bsr.w",	S_BCC,		B_W,	0x6100	},
    {	NULL,	"bsr.l",	S_BCC,		B_L,	0x6100	},
    /*---*/
    {	NULL,	"bhi",		S_BCC,		B_A,	0x6200	},
    {	NULL,	"bhi.b",	S_BCC,		B_B,	0x6200	},
    {	NULL,	"bhi.s",	S_BCC,		B_B,	0x6200	},
    {	NULL,	"bhi.w",	S_BCC,		B_W,	0x6200	},
    {	NULL,	"bhi.l",	S_BCC,		B_L,	0x6200	},
    /*---*/
    {	NULL,	"bls",		S_BCC,		B_A,	0x6300	},
    {	NULL,	"bls.b",	S_BCC,		B_B,	0x6300	},
    {	NULL,	"bls.s",	S_BCC,		B_B,	0x6300	},
    {	NULL,	"bls.w",	S_BCC,		B_W,	0x6300	},
    {	NULL,	"bls.l",	S_BCC,		B_L,	0x6300	},
    /*---*/
    {	NULL,	"bcc",		S_BCC,		B_A,	0x6400	},
    {	NULL,	"bcc.b",	S_BCC,		B_B,	0x6400	},
    {	NULL,	"bcc.s",	S_BCC,		B_B,	0x6400	},
    {	NULL,	"bcc.w",	S_BCC,		B_W,	0x6400	},
    {	NULL,	"bcc.l",	S_BCC,		B_L,	0x6400	},
    /*---*/
    {	NULL,	"bcs",		S_BCC,		B_A,	0x6500	},
    {	NULL,	"bcs.b",	S_BCC,		B_B,	0x6500	},
    {	NULL,	"bcs.s",	S_BCC,		B_B,	0x6500	},
    {	NULL,	"bcs.w",	S_BCC,		B_W,	0x6500	},
    {	NULL,	"bcs.l",	S_BCC,		B_L,	0x6500	},
    /*---*/
    {	NULL,	"bne",		S_BCC,		B_A,	0x6600	},
    {	NULL,	"bne.b",	S_BCC,		B_B,	0x6600	},
    {	NULL,	"bne.s",	S_BCC,		B_B,	0x6600	},
    {	NULL,	"bne.w",	S_BCC,		B_W,	0x6600	},
    {	NULL,	"bne.l",	S_BCC,		B_L,	0x6600	},
    /*---*/
    {	NULL,	"beq",		S_BCC,		B_A,	0x6700	},
    {	NULL,	"beq.b",	S_BCC,		B_B,	0x6700	},
    {	NULL,	"beq.s",	S_BCC,		B_B,	0x6700	},
    {	NULL,	"beq.w",	S_BCC,		B_W,	0x6700	},
    {	NULL,	"beq.l",	S_BCC,		B_L,	0x6700	},
   /*---*/
    {	NULL,	"bvc",		S_BCC,		B_A,	0x6800	},
    {	NULL,	"bvc.b",	S_BCC,		B_B,	0x6800	},
    {	NULL,	"bvc.s",	S_BCC,		B_B,	0x6800	},
    {	NULL,	"bvc.w",	S_BCC,		B_W,	0x6800	},
    {	NULL,	"bvc.l",	S_BCC,		B_L,	0x6800	},
    /*---*/
    {	NULL,	"bvs",		S_BCC,		B_A,	0x6900	},
    {	NULL,	"bvs.b",	S_BCC,		B_B,	0x6900	},
    {	NULL,	"bvs.s",	S_BCC,		B_B,	0x6900	},
    {	NULL,	"bvs.w",	S_BCC,		B_W,	0x6900	},
    {	NULL,	"bvs.l",	S_BCC,		B_L,	0x6900	},
    /*---*/
    {	NULL,	"bpl",		S_BCC,		B_A,	0x6A00	},
    {	NULL,	"bpl.b",	S_BCC,		B_B,	0x6A00	},
    {	NULL,	"bpl.s",	S_BCC,		B_B,	0x6A00	},
    {	NULL,	"bpl.w",	S_BCC,		B_W,	0x6A00	},
    {	NULL,	"bpl.l",	S_BCC,		B_L,	0x6A00	},
    /*---*/
    {	NULL,	"bmi",		S_BCC,		B_A,	0x6B00	},
    {	NULL,	"bmi.b",	S_BCC,		B_B,	0x6B00	},
    {	NULL,	"bmi.s",	S_BCC,		B_B,	0x6B00	},
    {	NULL,	"bmi.w",	S_BCC,		B_W,	0x6B00	},
    {	NULL,	"bmi.l",	S_BCC,		B_L,	0x6B00	},
    /*---*/
    {	NULL,	"bge",		S_BCC,		B_A,	0x6C00	},
    {	NULL,	"bge.b",	S_BCC,		B_B,	0x6C00	},
    {	NULL,	"bge.s",	S_BCC,		B_B,	0x6C00	},
    {	NULL,	"bge.w",	S_BCC,		B_W,	0x6C00	},
    {	NULL,	"bge.l",	S_BCC,		B_L,	0x6C00	},
    /*---*/
    {	NULL,	"blt",		S_BCC,		B_A,	0x6D00	},
    {	NULL,	"blt.b",	S_BCC,		B_B,	0x6D00	},
    {	NULL,	"blt.s",	S_BCC,		B_B,	0x6D00	},
    {	NULL,	"blt.w",	S_BCC,		B_W,	0x6D00	},
    {	NULL,	"blt.l",	S_BCC,		B_L,	0x6D00	},
    /*---*/
    {	NULL,	"bgt",		S_BCC,		B_A,	0x6E00	},
    {	NULL,	"bgt.b",	S_BCC,		B_B,	0x6E00	},
    {	NULL,	"bgt.s",	S_BCC,		B_B,	0x6E00	},
    {	NULL,	"bgt.w",	S_BCC,		B_W,	0x6E00	},
    {	NULL,	"bgt.l",	S_BCC,		B_L,	0x6E00	},
    /*---*/
    {	NULL,	"ble",		S_BCC,		B_A,	0x6F00	},
    {	NULL,	"ble.b",	S_BCC,		B_B,	0x6F00	},
    {	NULL,	"ble.s",	S_BCC,		B_B,	0x6F00	},
    {	NULL,	"ble.w",	S_BCC,		B_W,	0x6F00	},
    {	NULL,	"ble.l",	S_BCC,		B_L,	0x6F00	},
    /*-- Alternate For BLS --*/
    {	NULL,	"blos",		S_BCC,		B_A,	0x6300	},
    {	NULL,	"blos.b",	S_BCC,		B_B,	0x6300	},
    {	NULL,	"blos.s",	S_BCC,		B_B,	0x6300	},
    {	NULL,	"blos.w",	S_BCC,		B_W,	0x6300	},
    {	NULL,	"blos.l",	S_BCC,		B_L,	0x6300	},
    /*-- Alternate For BCC --*/
    {	NULL,	"bhs",		S_BCC,		B_A,	0x6400	},
    {	NULL,	"bhs.b",	S_BCC,		B_B,	0x6400	},
    {	NULL,	"bhs.s",	S_BCC,		B_B,	0x6400	},
    {	NULL,	"bhs.w",	S_BCC,		B_W,	0x6400	},
    {	NULL,	"bhs.l",	S_BCC,		B_L,	0x6400	},
    /*-- Alternate For BCC --*/
    {	NULL,	"bhis",		S_BCC,		B_A,	0x6400	},
    {	NULL,	"bhis.b",	S_BCC,		B_B,	0x6400	},
    {	NULL,	"bhis.s",	S_BCC,		B_B,	0x6400	},
    {	NULL,	"bhis.w",	S_BCC,		B_W,	0x6400	},
    {	NULL,	"bhis.l",	S_BCC,		B_L,	0x6400	},
    /*-- Alternate For BCS --*/
    {	NULL,	"blo",		S_BCC,		B_A,	0x6500	},
    {	NULL,	"blo.b",	S_BCC,		B_B,	0x6500	},
    {	NULL,	"blo.s",	S_BCC,		B_B,	0x6500	},
    {	NULL,	"blo.w",	S_BCC,		B_W,	0x6500	},
    {	NULL,	"blo.l",	S_BCC,		B_L,	0x6500	},

	/* Bit Instructions */

    {	NULL,	"bchg",		S_BIT,		A_A,	0x0140	},
    {	NULL,	"bchg.b",	S_BIT,		A_B,	0x0140	},
    {	NULL,	"bchg.l",	S_BIT,		A_L,	0x0140	},
    /*---*/
    {	NULL,	"bclr",		S_BIT,		A_A,	0x0180	},
    {	NULL,	"bclr.b",	S_BIT,		A_B,	0x0180	},
    {	NULL,	"bclr.l",	S_BIT,		A_L,	0x0180	},
    /*---*/
    {	NULL,	"bset",		S_BIT,		A_A,	0x01C0	},
    {	NULL,	"bset.b",	S_BIT,		A_B,	0x01C0	},
    {	NULL,	"bset.l",	S_BIT,		A_L,	0x01C0	},
    /*---*/
    {	NULL,	"btst",		S_BIT,		A_A,	0x0100	},
    {	NULL,	"btst.b",	S_BIT,		A_B,	0x0100	},
    {	NULL,	"btst.l",	S_BIT,		A_L,	0x0100	},

	/* Move Instructions */

    {	NULL,	"mov3q",	S_MOV3Q, 	A_L,	0xA140	},
    {	NULL,	"mov3q.l",	S_MOV3Q,	A_L,	0xA140	},
    /*---*/
    {	NULL,	"move",		S_MOVE,	  A_U | A_L,	0x2000	},
    {	NULL,	"move.b",	S_MOVE,		A_B,	0x1000	},
    {	NULL,	"move.w",	S_MOVE, 	A_W,	0x3000	},
    {	NULL,	"move.l",	S_MOVE,		A_L,	0x2000	},
    /*---*/
    {	NULL,	"movea",	S_MOVEA,	A_L,	0x2040	},
    {	NULL,	"movea.w",	S_MOVEA,	A_W,	0x3040	},
    {	NULL,	"movea.l",	S_MOVEA,	A_L,	0x2040	},
    /*---*/
    {	NULL,	"movem",	S_MOVEM,	A_L,	0x48C0	},
    {	NULL,	"movem.l",	S_MOVEM,	A_L,	0x48C0	},
    /*---*/
    {	NULL,	"moveq",	S_MOVEQ,	A_L,	0x7000	},
    {	NULL,	"moveq.l",	S_MOVEQ,	A_L,	0x7000	},
    /*---*/
    {	NULL,	"mvs",		S_MVSZ,		A_W,	0x7140	},
    {	NULL,	"mvs.b",	S_MVSZ,		A_B,	0x7100	},
    {	NULL,	"mvs.w",	S_MVSZ,		A_W,	0x7140	},
    /*---*/
    {	NULL,	"mvz",		S_MVSZ,		A_W,	0x71C0	},
    {	NULL,	"mvz.b",	S_MVSZ,		A_B,	0x7180	},
    {	NULL,	"mvz.w",	S_MVSZ,		A_W,	0x71C0	},

	/* Miscellaneous Format Instructions */

    {	NULL,	"cmp",		S_CMP,		A_L,	0xB080	},
    {	NULL,	"cmp.b",	S_CMP,		A_B,	0xB000	},
    {	NULL,	"cmp.w",	S_CMP,		A_W,	0xB040	},
    {	NULL,	"cmp.l",	S_CMP,		A_L,	0xB080	},
    /*---*/
    {	NULL,	"eor",		S_EOR,	  	A_L,	0xB180	},
    {	NULL,	"eor.l",	S_EOR,		A_L,	0xB180	},
    /*---*/
    {	NULL,	"ext",		S_EXT,		A_W,	0x48C0	},
    {	NULL,	"ext.w",	S_EXT,		A_W,	0x4880	},
    {	NULL,	"ext.l",	S_EXT,		A_L,	0x48C0	},
    /*---*/
    {	NULL,	"extb",		S_EXTB,		A_L,	0x49C0	},
    {	NULL,	"extb.l",	S_EXTB,		A_L,	0x49C0	},
    /*---*/
    {	NULL,	"link",		S_LINK,		A_W,	0x4E50	},
    {	NULL,	"link.w",	S_LINK,		A_W,	0x4E50	},
    /*---*/
    {	NULL,	"rems",		S_REMS,		A_L,	0x4C40	},
    {	NULL,	"rems.l",	S_REMS,		A_L,	0x4C40	},
    /*---*/
    {	NULL,	"remu",		S_REMU,		A_L,	0x4C40	},
    {	NULL,	"remu.l",	S_REMU,		A_L,	0x4C40	},
    /*---*/
    {	NULL,	"sats",		S_TYP9,		A_L,	0x4C80	},
    {	NULL,	"sats.l",	S_TYP9,		A_L,	0x4C80	},
    /*---*/
    {	NULL,	"tas",		S_TAS,		A_B,	0x4AC0	},
    {	NULL,	"tas.b",	S_TAS,		A_B,	0x4AC0	},
    /*---*/
    {	NULL,	"trap",		S_TRAP,		A_U,	0x4E40	},
    /*---*/
    {	NULL,	"tpf",		S_TPF,		A_A,	0x51F8	},
    {	NULL,	"tpf.w",	S_TPF,		A_W,	0x51F8	},
    {	NULL,	"tpf.l",	S_TPF,		A_L,	0x51F8	},
    /*---*/
    {	NULL,	"wddata",	S_TAS,		A_L,	0xFB80	},
    {	NULL,	"wddata.b",	S_TAS,		A_B,	0xFB00	},
    {	NULL,	"wddata.w",	S_TAS,		A_W,	0xFB40	},
    {	NULL,	"wddata.l",	S_TAS,		A_L,	0xFB80	},

	/* Inherent Instructions */

    {	NULL,	"illegal",	S_INH,		A_U,	0x4AFC	},
    {	NULL,	"nop",		S_INH,		A_U,	0x4E71	},
    {	NULL,	"pulse",	S_INH,		A_U,	0x4ACC	},
    {	NULL,	"rts",		S_INH,		A_U,	0x4E75	},

	/*
	 * Restored Instructions
	 */

    {	NULL,	"cas",		S_CAS,		A_L,	0x08C0	},
    {	NULL,	"cas.b",	S_CAS,		A_B,	0x08C0	},
    {	NULL,	"cas.w",	S_CAS,		A_W,	0x08C0	},
    {	NULL,	"cas.l",	S_CAS,		A_L,	0x08C0	},
    /*---*/
    {	NULL,	"cas2",		S_CAS2,		A_L,	0x08FC	},
    {	NULL,	"cas2.w",	S_CAS2,		A_W,	0x08FC	},
    {	NULL,	"cas2.l",	S_CAS2,		A_L,	0x08FC	},
    /*---*/
    {	NULL,	"chk",		S_CHK,		A_L,	0x4100	},
    {	NULL,	"chk.w",	S_CHK,		A_W,	0x4180	},
    {	NULL,	"chk.l",	S_CHK,		A_L,	0x4100	},
    /*---*/
    {	NULL,	"chk2",		S_CHK2,		A_W,	0x00C0	},
    {	NULL,	"chk2.b",	S_CHK2,		A_B,	0x00C0	},
    {	NULL,	"chk2.w",	S_CHK2,		A_W,	0x00C0	},
    {	NULL,	"chk2.l",	S_CHK2,		A_L,	0x00C0	},
    /*---*/
    {	NULL,	"cmp2",		S_CMP2,		A_W,	0x00C0	},
    {	NULL,	"cmp2.b",	S_CMP2,		A_B,	0x00C0	},
    {	NULL,	"cmp2.w",	S_CMP2,		A_W,	0x00C0	},
    {	NULL,	"cmp2.l",	S_CMP2,		A_L,	0x00C0	},

    	/*
	 * Supervisor (Priviledged) Instructions
	 */

    /*---*/
    {	NULL,	"cpushl",	S_SHL,		A_U,	0xF428	},
    /*---*/
    {	NULL,	"halt",		S_INH,		A_U,	0x4AC8	},
    /*---*/
    {	NULL,	"intouch",	S_TCH,		A_U,	0xF428	},
    /*---*/
    /*	move to/from USP/SR incorporated into move instruction */
    /*---*/
    {	NULL,	"movec",	S_MOVEC,	A_L,	0x4E7B	},
    {	NULL,	"movec.l",	S_MOVEC,	A_L,	0x4E7B	},
    /*---*/
    {	NULL,	"rte",		S_INH,		A_U,	0x4E73	},
    /*---*/
    {	NULL,	"strldsr",	S_STLD,		A_W,	0x40E7	},
    {	NULL,	"strldsr.w",	S_STLD,		A_W,	0x40E7	},
    /*---*/
    {	NULL,	"stop",		S_STOP,		A_U,	0x4E72	},
    /*---*/
    {	NULL,	"wdebug",	S_WDB,		A_L,	0xFBC0	},
    {	NULL,	"wdebug.l",	S_WDB,		A_L,	0xFBC0	},

	/*
	 * Multiply-Accumulate
	 */

    {	NULL,	"mac",		M_MAC,		A_L,	0x0800	},
    {	NULL,	"mac.w",	M_MAC,		A_W,	0x0000	},
    {	NULL,	"mac.l",	M_MAC,		A_L,	0x0800	},
    /*---*/
    {	NULL,	"msac",		M_MAC,		A_L,	0x0900	},
    {	NULL,	"msac.w",	M_MAC,		A_W,	0x0100	},
    {	NULL,	"msac.l",	M_MAC,		A_L,	0x0900	},

	/*
	 * Extended Multiply-Accumulate
	 */

    {	NULL,	"maaac",	M_MAC,		A_L,	0x0801	},
    {	NULL,	"maaac.w",	M_MAC,		A_W,	0x0001	},
    {	NULL,	"maaac.l",	M_MAC,		A_L,	0x0801	},
    /*---*/
    {	NULL,	"masac",	M_MAC,		A_L,	0x0803	},
    {	NULL,	"masac.w",	M_MAC,		A_W,	0x0003	},
    {	NULL,	"masac.l",	M_MAC,		A_L,	0x0803	},
    /*---*/
    {	NULL,	"movclr",	M_MCLR,		A_L,	0xA1C0	},
    {	NULL,	"movclr.l",	M_MCLR,		A_L,	0xA1C0	},
    /*---*/
    {	NULL,	"msaac",	M_MAC,		A_L,	0x0901	},
    {	NULL,	"msaac.w",	M_MAC,		A_W,	0x0101	},
    {	NULL,	"msaac.l",	M_MAC,		A_L,	0x0901	},
    /*---*/
    {	NULL,	"mssac",	M_MAC,		A_L,	0x0903	},
    {	NULL,	"mssac.w",	M_MAC,		A_W,	0x0103	},
    {	NULL,	"mssac.l",	M_MAC,		A_L,	0x0903	},

	/*
	 * ColdFire Floating Point CoProcessor
	 */

    {	NULL,	"fmove",	F_MOV,		F_D,	0x0000	},
    {	NULL,	"fmove.b",	F_MOV,		F_B,	0x0000	},
    {	NULL,	"fmove.w",	F_MOV,		F_W,	0x0000	},
    {	NULL,	"fmove.l",	F_MOV,		F_L,	0x0000	},
    {	NULL,	"fmove.s",	F_MOV,		F_S,	0x0000	},
    {	NULL,	"fmove.d",	F_MOV,		F_D,	0x0000	},

    {	NULL,	"fsmove",	F_MOV,		F_D,	0x0040	},
    {	NULL,	"fsmove.b",	F_MOV,		F_B,	0x0040	},
    {	NULL,	"fsmove.w",	F_MOV,		F_W,	0x0040	},
    {	NULL,	"fsmove.l",	F_MOV,		F_L,	0x0040	},
    {	NULL,	"fsmove.s",	F_MOV,		F_S,	0x0040	},
    {	NULL,	"fsmove.d",	F_MOV,		F_D,	0x0040	},

    {	NULL,	"fdmove",	F_MOV,		F_D,	0x0044	},
    {	NULL,	"fdmove.b",	F_MOV,		F_B,	0x0044	},
    {	NULL,	"fdmove.w",	F_MOV,		F_W,	0x0044	},
    {	NULL,	"fdmove.l",	F_MOV,		F_L,	0x0044	},
    {	NULL,	"fdmove.s",	F_MOV,		F_S,	0x0044	},
    {	NULL,	"fdmove.d",	F_MOV,		F_D,	0x0044	},

    {	NULL,	"fint",		F_TYP1,		F_D,	0x0001	},
    {	NULL,	"fint.b",	F_TYP1,		F_B,	0x0001	},
    {	NULL,	"fint.w",	F_TYP1,		F_W,	0x0001	},
    {	NULL,	"fint.l",	F_TYP1,		F_L,	0x0001	},
    {	NULL,	"fint.s",	F_TYP1,		F_S,	0x0001	},
    {	NULL,	"fint.d",	F_TYP1,		F_D,	0x0001	},

    {	NULL,	"fintrz",	F_TYP1,		F_D,	0x0003	},
    {	NULL,	"fintrz.b",	F_TYP1,		F_B,	0x0003	},
    {	NULL,	"fintrz.w",	F_TYP1,		F_W,	0x0003	},
    {	NULL,	"fintrz.l",	F_TYP1,		F_L,	0x0003	},
    {	NULL,	"fintrz.s",	F_TYP1,		F_S,	0x0003	},
    {	NULL,	"fintrz.d",	F_TYP1,		F_D,	0x0003	},

    {	NULL,	"fsqrt",	F_TYP1,		F_D,	0x0004	},
    {	NULL,	"fsqrt.b",	F_TYP1,		F_B,	0x0004	},
    {	NULL,	"fsqrt.w",	F_TYP1,		F_W,	0x0004	},
    {	NULL,	"fsqrt.l",	F_TYP1,		F_L,	0x0004	},
    {	NULL,	"fsqrt.s",	F_TYP1,		F_S,	0x0004	},
    {	NULL,	"fsqrt.d",	F_TYP1,		F_D,	0x0004	},

    {	NULL,	"fssqrt",	F_TYP1,		F_D,	0x0041	},
    {	NULL,	"fssqrt.b",	F_TYP1,		F_B,	0x0041	},
    {	NULL,	"fssqrt.w",	F_TYP1,		F_W,	0x0041	},
    {	NULL,	"fssqrt.l",	F_TYP1,		F_L,	0x0041	},
    {	NULL,	"fssqrt.s",	F_TYP1,		F_S,	0x0041	},
    {	NULL,	"fssqrt.d",	F_TYP1,		F_D,	0x0041	},

    {	NULL,	"fdsqrt",	F_TYP1,		F_D,	0x0045	},
    {	NULL,	"fdsqrt.b",	F_TYP1,		F_B,	0x0045	},
    {	NULL,	"fdsqrt.w",	F_TYP1,		F_W,	0x0045	},
    {	NULL,	"fdsqrt.l",	F_TYP1,		F_L,	0x0045	},
    {	NULL,	"fdsqrt.s",	F_TYP1,		F_S,	0x0045	},
    {	NULL,	"fdsqrt.d",	F_TYP1,		F_D,	0x0045	},

    {	NULL,	"fabs",		F_TYP1,		F_D,	0x0018	},
    {	NULL,	"fabs.b",	F_TYP1,		F_B,	0x0018	},
    {	NULL,	"fabs.w",	F_TYP1,		F_W,	0x0018	},
    {	NULL,	"fabs.l",	F_TYP1,		F_L,	0x0018	},
    {	NULL,	"fabs.s",	F_TYP1,		F_S,	0x0018	},
    {	NULL,	"fabs.d",	F_TYP1,		F_D,	0x0018	},

    {	NULL,	"fsabs",	F_TYP1,		F_D,	0x0058	},
    {	NULL,	"fsabs.b",	F_TYP1,		F_B,	0x0058	},
    {	NULL,	"fsabs.w",	F_TYP1,		F_W,	0x0058	},
    {	NULL,	"fsabs.l",	F_TYP1,		F_L,	0x0058	},
    {	NULL,	"fsabs.s",	F_TYP1,		F_S,	0x0058	},
    {	NULL,	"fsabs.d",	F_TYP1,		F_D,	0x0058	},

    {	NULL,	"fdabs",	F_TYP1,		F_D,	0x005C	},
    {	NULL,	"fdabs.b",	F_TYP1,		F_B,	0x005C	},
    {	NULL,	"fdabs.w",	F_TYP1,		F_W,	0x005C	},
    {	NULL,	"fdabs.l",	F_TYP1,		F_L,	0x005C	},
    {	NULL,	"fdabs.s",	F_TYP1,		F_S,	0x005C	},
    {	NULL,	"fdabs.d",	F_TYP1,		F_D,	0x005C	},

    {	NULL,	"fneg",		F_TYP1,		F_D,	0x001A	},
    {	NULL,	"fneg.b",	F_TYP1,		F_B,	0x001A	},
    {	NULL,	"fneg.w",	F_TYP1,		F_W,	0x001A	},
    {	NULL,	"fneg.l",	F_TYP1,		F_L,	0x001A	},
    {	NULL,	"fneg.s",	F_TYP1,		F_S,	0x001A	},
    {	NULL,	"fneg.d",	F_TYP1,		F_D,	0x001A	},

    {	NULL,	"fsneg",	F_TYP1,		F_D,	0x005A	},
    {	NULL,	"fsneg.b",	F_TYP1,		F_B,	0x005A	},
    {	NULL,	"fsneg.w",	F_TYP1,		F_W,	0x005A	},
    {	NULL,	"fsneg.l",	F_TYP1,		F_L,	0x005A	},
    {	NULL,	"fsneg.s",	F_TYP1,		F_S,	0x005A	},
    {	NULL,	"fsneg.d",	F_TYP1,		F_D,	0x005A	},

    {	NULL,	"fdneg",	F_TYP1,		F_D,	0x005E	},
    {	NULL,	"fdneg.b",	F_TYP1,		F_B,	0x005E	},
    {	NULL,	"fdneg.w",	F_TYP1,		F_W,	0x005E	},
    {	NULL,	"fdneg.l",	F_TYP1,		F_L,	0x005E	},
    {	NULL,	"fdneg.s",	F_TYP1,		F_S,	0x005E	},
    {	NULL,	"fdneg.d",	F_TYP1,		F_D,	0x005E	},

    {	NULL,	"fdiv",		F_TYP2,		F_D,	0x0020	},
    {	NULL,	"fdiv.b",	F_TYP2,		F_B,	0x0020	},
    {	NULL,	"fdiv.w",	F_TYP2,		F_W,	0x0020	},
    {	NULL,	"fdiv.l",	F_TYP2,		F_L,	0x0020	},
    {	NULL,	"fdiv.s",	F_TYP2,		F_S,	0x0020	},
    {	NULL,	"fdiv.d",	F_TYP2,		F_D,	0x0020	},

    {	NULL,	"fsdiv",	F_TYP2,		F_D,	0x0060	},
    {	NULL,	"fsdiv.b",	F_TYP2,		F_B,	0x0060	},
    {	NULL,	"fsdiv.w",	F_TYP2,		F_W,	0x0060	},
    {	NULL,	"fsdiv.l",	F_TYP2,		F_L,	0x0060	},
    {	NULL,	"fsdiv.s",	F_TYP2,		F_S,	0x0060	},
    {	NULL,	"fsdiv.d",	F_TYP2,		F_D,	0x0060	},

    {	NULL,	"fddiv",	F_TYP2,		F_D,	0x0064	},
    {	NULL,	"fddiv.b",	F_TYP2,		F_B,	0x0064	},
    {	NULL,	"fddiv.w",	F_TYP2,		F_W,	0x0064	},
    {	NULL,	"fddiv.l",	F_TYP2,		F_L,	0x0064	},
    {	NULL,	"fddiv.s",	F_TYP2,		F_S,	0x0064	},
    {	NULL,	"fddiv.d",	F_TYP2,		F_D,	0x0064	},

    {	NULL,	"fadd",		F_TYP2,		F_D,	0x0022	},
    {	NULL,	"fadd.b",	F_TYP2,		F_B,	0x0022	},
    {	NULL,	"fadd.w",	F_TYP2,		F_W,	0x0022	},
    {	NULL,	"fadd.l",	F_TYP2,		F_L,	0x0022	},
    {	NULL,	"fadd.s",	F_TYP2,		F_S,	0x0022	},
    {	NULL,	"fadd.d",	F_TYP2,		F_D,	0x0022	},

    {	NULL,	"fsadd",	F_TYP2,		F_D,	0x0062	},
    {	NULL,	"fsadd.b",	F_TYP2,		F_B,	0x0062	},
    {	NULL,	"fsadd.w",	F_TYP2,		F_W,	0x0062	},
    {	NULL,	"fsadd.l",	F_TYP2,		F_L,	0x0062	},
    {	NULL,	"fsadd.s",	F_TYP2,		F_S,	0x0062	},
    {	NULL,	"fsadd.d",	F_TYP2,		F_D,	0x0062	},

    {	NULL,	"fdadd",	F_TYP2,		F_D,	0x0066	},
    {	NULL,	"fdadd.b",	F_TYP2,		F_B,	0x0066	},
    {	NULL,	"fdadd.w",	F_TYP2,		F_W,	0x0066	},
    {	NULL,	"fdadd.l",	F_TYP2,		F_L,	0x0066	},
    {	NULL,	"fdadd.s",	F_TYP2,		F_S,	0x0066	},
    {	NULL,	"fdadd.d",	F_TYP2,		F_D,	0x0066	},

    {	NULL,	"fmul",		F_TYP2,		F_D,	0x0023	},
    {	NULL,	"fmul.b",	F_TYP2,		F_B,	0x0023	},
    {	NULL,	"fmul.w",	F_TYP2,		F_W,	0x0023	},
    {	NULL,	"fmul.l",	F_TYP2,		F_L,	0x0023	},
    {	NULL,	"fmul.s",	F_TYP2,		F_S,	0x0023	},
    {	NULL,	"fmul.d",	F_TYP2,		F_D,	0x0023	},

    {	NULL,	"fsmul",	F_TYP2,		F_D,	0x0063	},
    {	NULL,	"fsmul.b",	F_TYP2,		F_B,	0x0063	},
    {	NULL,	"fsmul.w",	F_TYP2,		F_W,	0x0063	},
    {	NULL,	"fsmul.l",	F_TYP2,		F_L,	0x0063	},
    {	NULL,	"fsmul.s",	F_TYP2,		F_S,	0x0063	},
    {	NULL,	"fsmul.d",	F_TYP2,		F_D,	0x0063	},

    {	NULL,	"fdmul",	F_TYP2,		F_D,	0x0067	},
    {	NULL,	"fdmul.b",	F_TYP2,		F_B,	0x0067	},
    {	NULL,	"fdmul.w",	F_TYP2,		F_W,	0x0067	},
    {	NULL,	"fdmul.l",	F_TYP2,		F_L,	0x0067	},
    {	NULL,	"fdmul.s",	F_TYP2,		F_S,	0x0067	},
    {	NULL,	"fdmul.d",	F_TYP2,		F_D,	0x0067	},

    {	NULL,	"fsub",		F_TYP2,		F_D,	0x0028	},
    {	NULL,	"fsub.b",	F_TYP2,		F_B,	0x0028	},
    {	NULL,	"fsub.w",	F_TYP2,		F_W,	0x0028	},
    {	NULL,	"fsub.l",	F_TYP2,		F_L,	0x0028	},
    {	NULL,	"fsub.s",	F_TYP2,		F_S,	0x0028	},
    {	NULL,	"fsub.d",	F_TYP2,		F_D,	0x0028	},

    {	NULL,	"fssub",	F_TYP2,		F_D,	0x0068	},
    {	NULL,	"fssub.b",	F_TYP2,		F_B,	0x0068	},
    {	NULL,	"fssub.w",	F_TYP2,		F_W,	0x0068	},
    {	NULL,	"fssub.l",	F_TYP2,		F_L,	0x0068	},
    {	NULL,	"fssub.s",	F_TYP2,		F_S,	0x0068	},
    {	NULL,	"fssub.d",	F_TYP2,		F_D,	0x0068	},

    {	NULL,	"fdsub",	F_TYP2,		F_D,	0x006C	},
    {	NULL,	"fdsub.b",	F_TYP2,		F_B,	0x006C	},
    {	NULL,	"fdsub.w",	F_TYP2,		F_W,	0x006C	},
    {	NULL,	"fdsub.l",	F_TYP2,		F_L,	0x006C	},
    {	NULL,	"fdsub.s",	F_TYP2,		F_S,	0x006C	},
    {	NULL,	"fdsub.d",	F_TYP2,		F_D,	0x006C	},

    {	NULL,	"fcmp",		F_TYP2,		F_D,	0x0038	},
    {	NULL,	"fcmp.b",	F_TYP2,		F_B,	0x0038	},
    {	NULL,	"fcmp.w",	F_TYP2,		F_W,	0x0038	},
    {	NULL,	"fcmp.l",	F_TYP2,		F_L,	0x0038	},
    {	NULL,	"fcmp.s",	F_TYP2,		F_S,	0x0038	},
    {	NULL,	"fcmp.d",	F_TYP2,		F_D,	0x0038	},

    {	NULL,	"ftst",		F_TST,		F_D,	0x003A	},
    {	NULL,	"ftst.b",	F_TST,		F_B,	0x003A	},
    {	NULL,	"ftst.w",	F_TST,		F_W,	0x003A	},
    {	NULL,	"ftst.l",	F_TST,		F_L,	0x003A	},
    {	NULL,	"ftst.s",	F_TST,		F_S,	0x003A	},
    {	NULL,	"ftst.d",	F_TST,		F_D,	0x003A	},

    {	NULL,	"fmovem",	F_MOVM,		F_D,	0xD000	},
    {	NULL,	"fmovem.d",	F_MOVM,		F_D,	0xD000	},

    {	NULL,	"fnop",		F_NOP,		0,	0x0000	},

    {	NULL,	"fbf",		F_BCC,		F_A,	0x00	},
    {	NULL,	"fbeq",		F_BCC,		F_A,	0x01	},
    {	NULL,	"fbogt",	F_BCC,		F_A,	0x02	},
    {	NULL,	"fboge",	F_BCC,		F_A,	0x03	},
    {	NULL,	"fbolt",	F_BCC,		F_A,	0x04	},
    {	NULL,	"fbole",	F_BCC,		F_A,	0x05	},
    {	NULL,	"fbogl",	F_BCC,		F_A,	0x06	},
    {	NULL,	"fbor",		F_BCC,		F_A,	0x07	},
    {	NULL,	"fbun",		F_BCC,		F_A,	0x08	},
    {	NULL,	"fbueq",	F_BCC,		F_A,	0x09	},
    {	NULL,	"fbugt",	F_BCC,		F_A,	0x0A	},
    {	NULL,	"fbuge",	F_BCC,		F_A,	0x0B	},
    {	NULL,	"fbult",	F_BCC,		F_A,	0x0C	},
    {	NULL,	"fbule",	F_BCC,		F_A,	0x0D	},
    {	NULL,	"fbne",		F_BCC,		F_A,	0x0E	},
    {	NULL,	"fbt",		F_BCC,		F_A,	0x0F	},
    {	NULL,	"fbsf",		F_BCC,		F_A,	0x10	},
    {	NULL,	"fbseq",	F_BCC,		F_A,	0x11	},
    {	NULL,	"fbgt",		F_BCC,		F_A,	0x12	},
    {	NULL,	"fbge",		F_BCC,		F_A,	0x13	},
    {	NULL,	"fblt",		F_BCC,		F_A,	0x14	},
    {	NULL,	"fble",		F_BCC,		F_A,	0x15	},
    {	NULL,	"fbgl",		F_BCC,		F_A,	0x16	},
    {	NULL,	"fbgle",	F_BCC,		F_A,	0x17	},
    {	NULL,	"fbngle",	F_BCC,		F_A,	0x18	},
    {	NULL,	"fbngl",	F_BCC,		F_A,	0x19	},
    {	NULL,	"fbnle",	F_BCC,		F_A,	0x1A	},
    {	NULL,	"fbnlt",	F_BCC,		F_A,	0x1B	},
    {	NULL,	"fbnge",	F_BCC,		F_A,	0x1C	},
    {	NULL,	"fbngt",	F_BCC,		F_A,	0x1D	},
    {	NULL,	"fbsne",	F_BCC,		F_A,	0x1E	},
    {	NULL,	"fbst",		F_BCC,		F_A,	0x1F	},

    {	NULL,	"fbf.w",	F_BCC,		F_W,	0x00	},
    {	NULL,	"fbeq.w",	F_BCC,		F_W,	0x01	},
    {	NULL,	"fbogt.w",	F_BCC,		F_W,	0x02	},
    {	NULL,	"fboge.w",	F_BCC,		F_W,	0x03	},
    {	NULL,	"fbolt.w",	F_BCC,		F_W,	0x04	},
    {	NULL,	"fbole.w",	F_BCC,		F_W,	0x05	},
    {	NULL,	"fboge.w",	F_BCC,		F_W,	0x06	},
    {	NULL,	"fbor.w",	F_BCC,		F_W,	0x07	},
    {	NULL,	"fbun.w",	F_BCC,		F_W,	0x08	},
    {	NULL,	"fbueq.w",	F_BCC,		F_W,	0x09	},
    {	NULL,	"fbugt.w",	F_BCC,		F_W,	0x0A	},
    {	NULL,	"fbuge.w",	F_BCC,		F_W,	0x0B	},
    {	NULL,	"fbult.w",	F_BCC,		F_W,	0x0C	},
    {	NULL,	"fbule.w",	F_BCC,		F_W,	0x0D	},
    {	NULL,	"fbne.w",	F_BCC,		F_W,	0x0E	},
    {	NULL,	"fbt.w",	F_BCC,		F_W,	0x0F	},
    {	NULL,	"fbsf.w",	F_BCC,		F_W,	0x10	},
    {	NULL,	"fbseq.w",	F_BCC,		F_W,	0x11	},
    {	NULL,	"fbgt.w",	F_BCC,		F_W,	0x12	},
    {	NULL,	"fbge.w",	F_BCC,		F_W,	0x13	},
    {	NULL,	"fblt.w",	F_BCC,		F_W,	0x14	},
    {	NULL,	"fble.w",	F_BCC,		F_W,	0x15	},
    {	NULL,	"fbgl.w",	F_BCC,		F_W,	0x16	},
    {	NULL,	"fbgle.w",	F_BCC,		F_W,	0x17	},
    {	NULL,	"fbngle.w",	F_BCC,		F_W,	0x18	},
    {	NULL,	"fbngl.w",	F_BCC,		F_W,	0x19	},
    {	NULL,	"fbnle.w",	F_BCC,		F_W,	0x1A	},
    {	NULL,	"fbnlt.w",	F_BCC,		F_W,	0x1B	},
    {	NULL,	"fbnge.w",	F_BCC,		F_W,	0x1C	},
    {	NULL,	"fbngt.w",	F_BCC,		F_W,	0x1D	},
    {	NULL,	"fbsne.w",	F_BCC,		F_W,	0x1E	},
    {	NULL,	"fbst.w",	F_BCC,		F_W,	0x1F	},

    {	NULL,	"fbf.l",	F_BCC,		F_L,	0x00	},
    {	NULL,	"fbeq.l",	F_BCC,		F_L,	0x01	},
    {	NULL,	"fbogt.l",	F_BCC,		F_L,	0x02	},
    {	NULL,	"fboge.l",	F_BCC,		F_L,	0x03	},
    {	NULL,	"fbolt.l",	F_BCC,		F_L,	0x04	},
    {	NULL,	"fbole.l",	F_BCC,		F_L,	0x05	},
    {	NULL,	"fboge.l",	F_BCC,		F_L,	0x06	},
    {	NULL,	"fbor.l",	F_BCC,		F_L,	0x07	},
    {	NULL,	"fbun.l",	F_BCC,		F_L,	0x08	},
    {	NULL,	"fbueq.l",	F_BCC,		F_L,	0x09	},
    {	NULL,	"fbugt.l",	F_BCC,		F_L,	0x0A	},
    {	NULL,	"fbuge.l",	F_BCC,		F_L,	0x0B	},
    {	NULL,	"fbult.l",	F_BCC,		F_L,	0x0C	},
    {	NULL,	"fbule.l",	F_BCC,		F_L,	0x0D	},
    {	NULL,	"fbne.l",	F_BCC,		F_L,	0x0E	},
    {	NULL,	"fbt.l",	F_BCC,		F_L,	0x0F	},
    {	NULL,	"fbsf.l",	F_BCC,		F_L,	0x10	},
    {	NULL,	"fbseq.l",	F_BCC,		F_L,	0x11	},
    {	NULL,	"fbgt.l",	F_BCC,		F_L,	0x12	},
    {	NULL,	"fbge.l",	F_BCC,		F_L,	0x13	},
    {	NULL,	"fblt.l",	F_BCC,		F_L,	0x14	},
    {	NULL,	"fble.l",	F_BCC,		F_L,	0x15	},
    {	NULL,	"fbgl.l",	F_BCC,		F_L,	0x16	},
    {	NULL,	"fbgle.l",	F_BCC,		F_L,	0x17	},
    {	NULL,	"fbngle.l",	F_BCC,		F_L,	0x18	},
    {	NULL,	"fbngl.l",	F_BCC,		F_L,	0x19	},
    {	NULL,	"fbnle.l",	F_BCC,		F_L,	0x1A	},
    {	NULL,	"fbnlt.l",	F_BCC,		F_L,	0x1B	},
    {	NULL,	"fbnge.l",	F_BCC,		F_L,	0x1C	},
    {	NULL,	"fbngt.l",	F_BCC,		F_L,	0x1D	},
    {	NULL,	"fbsne.l",	F_BCC,		F_L,	0x1E	},
    {	NULL,	"fbst.l",	F_BCC,		F_L,	0x1F	},

    	/*
	 * Supervisor (Priviledged) Instructions
	 */

    {	NULL,	"fsave",	F_SVRS,		0,	0xF300	},

    {	NULL,	"frestore",	F_SVRS,		S_EOL,	0xF340	}

};
