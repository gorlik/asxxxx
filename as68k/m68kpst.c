/* m68kpst.c */

/*
 *  Copyright (C) 2022-2024  Alan R. Baldwin
 *  Copyright (C) 2022-2024  Nick Downing
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
#include "m68k.h"

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
 *	#define		R_3BIT	0100		No Bit Positioning
 */
char	mode1[32] = {	/* R_4BIT */
	'\200',	'\201',	'\202',	'\003',	'\004',	'\005',	'\006',	'\007',
	'\010',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

/*
 *	#define		R_4BIT	0200		No Bit Positioning
 */
char	mode2[32] = {	/* R_4BIT */
	'\200',	'\201',	'\202',	'\203',	'\004',	'\005',	'\006',	'\007',
	'\010',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

/*
 *	#define		R_QBITS	0300		Bit Positioning
 */
char	mode3[32] = {	/* R_QBITS */
	'\211',	'\212',	'\213',	'\003',	'\004',	'\005',	'\006',	'\007',
	'\010',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

/*
 *	#define		R_CRBTS	0400		No Bit Positioning
 */
char	mode4[32] = {	/* R_CRBTS */
	'\200',	'\201',	'\202',	'\203',	'\204',	'\205',	'\006',	'\007',
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
    {	&mode1[0],	0,	0x00000007,	0x00000007	},
    {	&mode2[0],	0,	0x0000000F,	0x0000000F	},
    {	&mode3[0],	1,	0x00000E00,	0x00000003	},
    {	&mode4[0],	0,	0x0000003F,	0x0000003F	}
};

/*
 * Array of Pointers to Mode Structures
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
	 * MC680xx Machine
	 */

    {	NULL,	".68000",	S_68XXX,	0,	M_68000	},
    {	NULL,	".68008",	S_68XXX,	0,	M_68008	},
    {	NULL,	".68010",	S_68XXX,	0,	M_68010	},
    {	NULL,	".68020",	S_68XXX,	0,	M_68020	},

    {	NULL,	".setdp",	S_SDP,		0,	0	},
    {	NULL,	".dpgbl",	S_PGD,		0,	0	},
    {	NULL,	".lodpgbl",	S_PGD,		1,	0	},
    {	NULL,	".hidpgbl",	S_PGD,		2,	0	},

    {	NULL,	".flt16",	S_FLT16,	0,	0	},
    {	NULL,	".flt32",	S_FLT32,	0,	0	},
    {	NULL,	".flt64",	S_FLT64,	0,	0	},
    {	NULL,	".flt96",	S_FLT96,	0,	0	},
    {	NULL,	".fltpk",	S_FLTPK,	0,	0	},

    {	NULL,	".dword",	S_DATA,		0,	O_4BYTE	},
    {	NULL,	".qword",	S_QWRD,		0,	0	},

	/* Extended Instructions */

    {	NULL,	"abcd",		S_TYP1,		A_B,	0xC100	},
    {	NULL,	"abcd.b",	S_TYP1,		A_B,	0xC100	},
    {	NULL,	"abcd.w",	S_TYP1,		A_W,	0xC100	},
    {	NULL,	"abcd.l",	S_TYP1,		A_L,	0xC100	},
    /*---*/
    {	NULL,	"sbcd",		S_TYP1,		A_B,	0x8100	},
    {	NULL,	"sbcd.b",	S_TYP1,		A_B,	0x8100	},
    {	NULL,	"sbcd.w",	S_TYP1,		A_W,	0x8100	},
    {	NULL,	"sbcd.l",	S_TYP1,		A_L,	0x8100	},
    /*---*/
    {	NULL,	"addx",		S_TYP1,		A_W,	0xD140	},
    {	NULL,	"addx.b",	S_TYP1,		A_B,	0xD100	},
    {	NULL,	"addx.w",	S_TYP1,		A_W,	0xD140	},
    {	NULL,	"addx.l",	S_TYP1,		A_L,	0xD180	},
    /*---*/
    {	NULL,	"subx",		S_TYP1,		A_W,	0x9140	},
    {	NULL,	"subx.b",	S_TYP1,		A_B,	0x9100	},
    {	NULL,	"subx.w",	S_TYP1,		A_W,	0x9140	},
    {	NULL,	"subx.l",	S_TYP1,		A_L,	0x9180	},

	/* ADD, AND, OR, And SUB Instructions */

    {	NULL,	"add",		S_TYP2,		A_W,	0xD040	},
    {	NULL,	"add.b",	S_TYP2,		A_B,	0xD000	},
    {	NULL,	"add.w",	S_TYP2,		A_W,	0xD040	},
    {	NULL,	"add.l",	S_TYP2,		A_L,	0xD080	},
    /*---*/
    {	NULL,	"and",		S_TYP2,	  A_A | A_W,	0xC040	},
    {	NULL,	"and.b",	S_TYP2,		A_B,	0xC000	},
    {	NULL,	"and.w",	S_TYP2,		A_W,	0xC040	},
    {	NULL,	"and.l",	S_TYP2,		A_L,	0xC080	},
    /*---*/
    {	NULL,	"or",		S_TYP2,	  A_A | A_W,	0x8040	},
    {	NULL,	"or.b",		S_TYP2,		A_B,	0x8000	},
    {	NULL,	"or.w",		S_TYP2,		A_W,	0x8040	},
    {	NULL,	"or.l",		S_TYP2,		A_L,	0x8080	},
    /*---*/
    {	NULL,	"sub",		S_TYP2,		A_W,	0x9080	},
    {	NULL,	"sub.b",	S_TYP2,		A_B,	0x9000	},
    {	NULL,	"sub.w",	S_TYP2,		A_W,	0x9040	},
    {	NULL,	"sub.l",	S_TYP2,		A_L,	0x9080	},

	/* 'An' Destination Instructions */

    {	NULL,	"adda",		S_TYP3,		A_W,	0xD0C0	},
    {	NULL,	"adda.b",	S_TYP3,		A_B,	0xD000	},
    {	NULL,	"adda.w",	S_TYP3,		A_W,	0xD0C0	},
    {	NULL,	"adda.l",	S_TYP3,		A_L,	0xD1C0	},
    /*---*/
    {	NULL,	"cmpa",		S_TYP3,		A_W,	0xB0C0	},
    {	NULL,	"cmpa.b",	S_TYP3,		A_B,	0xB000	},
    {	NULL,	"cmpa.w",	S_TYP3,		A_W,	0xB0C0	},
    {	NULL,	"cmpa.l",	S_TYP3,		A_L,	0xB1C0	},
    /*---*/
    {	NULL,	"suba",		S_TYP3,		A_W,	0x90C0	},
    {	NULL,	"suba.b",	S_TYP3,		A_B,	0x9000	},
    {	NULL,	"suba.w",	S_TYP3,		A_W,	0x90C0	},
    {	NULL,	"suba.l",	S_TYP3,		A_L,	0x91C0	},

	/* Immediate Data Instructions */

    {	NULL,	"addi",		S_TYP4,		A_W,	0x0640	},
    {	NULL,	"addi.b",	S_TYP4,		A_B,	0x0600	},
    {	NULL,	"addi.w",	S_TYP4,		A_W,	0x0640	},
    {	NULL,	"addi.l",	S_TYP4,		A_L,	0x0680	},
    /*---*/
    {	NULL,	"andi",		S_TYP4,   A_A | A_W,	0x0240	},
    {	NULL,	"andi.b",	S_TYP4,		A_B,	0x0200	},
    {	NULL,	"andi.w",	S_TYP4,		A_W,	0x0240	},
    {	NULL,	"andi.l",	S_TYP4,		A_L,	0x0280	},
    /*---*/
    {	NULL,	"cmpi",		S_TYP4,		A_W,	0x0C40	},
    {	NULL,	"cmpi.b",	S_TYP4,		A_B,	0x0C00	},
    {	NULL,	"cmpi.w",	S_TYP4,		A_W,	0x0C40	},
    {	NULL,	"cmpi.l",	S_TYP4,		A_L,	0x0C80	},
    /*---*/
    {	NULL,	"eori",		S_TYP4,   A_A | A_W,	0x0A40	},
    {	NULL,	"eori.b",	S_TYP4,		A_B,	0x0A00	},
    {	NULL,	"eori.w",	S_TYP4,		A_W,	0x0A40	},
    {	NULL,	"eori.l",	S_TYP4,		A_L,	0x0A80	},
    /*---*/
    {	NULL,	"ori",		S_TYP4,   A_A | A_W,	0x0040	},
    {	NULL,	"ori.b",	S_TYP4,		A_B,	0x0000	},
    {	NULL,	"ori.w",	S_TYP4,		A_W,	0x0040	},
    {	NULL,	"ori.l",	S_TYP4,		A_L,	0x0080	},
    /*---*/
    {	NULL,	"subi",		S_TYP4,		A_W,	0x0440	},
    {	NULL,	"subi.b",	S_TYP4,		A_B,	0x0400	},
    {	NULL,	"subi.w",	S_TYP4,		A_W,	0x0440	},
    {	NULL,	"subi.l",	S_TYP4,		A_L,	0x0480	},

	/* Immediate Quick Insructions */

    {	NULL,	"addq",		S_TYP5,		A_W,	0x5040	},
    {	NULL,	"addq.b",	S_TYP5,		A_B,	0x5000	},
    {	NULL,	"addq.w",	S_TYP5,		A_W,	0x5040	},
    {	NULL,	"addq.l",	S_TYP5,		A_L,	0x5080	},
    /*---*/
    {	NULL,	"subq",		S_TYP5,		A_W,	0x5140	},
    {	NULL,	"subq.b",	S_TYP5,		A_B,	0x5100	},
    {	NULL,	"subq.w",	S_TYP5,		A_W,	0x5140	},
    {	NULL,	"subq.l",	S_TYP5,		A_L,	0x5180	},

	/* ___ <ea>,Dn Forms */

    {	NULL,	"chk",		S_CHK,		A_W,	0x4180	},
    {	NULL,	"chk.b",	S_CHK,		A_B,	0x4180	},
    {	NULL,	"chk.w",	S_CHK,		A_W,	0x4180	},
    {	NULL,	"chk.l",	S_CHK,		A_L,	0x4100	},
    /*---*/
    {	NULL,	"divs",		S_TYP6,		A_W,	0x81C0	},
    {	NULL,	"divs.b",	S_TYP6,		A_B,	0x81C0	},
    {	NULL,	"divs.w",	S_TYP6,		A_W,	0x81C0	},
    {	NULL,	"divs.l",	S_TYP6,		A_L,	0x81C0	},
    /*---*/
    {	NULL,	"divu",		S_TYP6,		A_W,	0x80C0	},
    {	NULL,	"divu.b",	S_TYP6,		A_B,	0x80C0	},
    {	NULL,	"divu.w",	S_TYP6,		A_W,	0x80C0	},
    {	NULL,	"divu.l",	S_TYP6,		A_L,	0x80C0	},
    /*---*/
    {	NULL,	"muls",		S_TYP6,		A_W,	0xC1C0	},
    {	NULL,	"muls.b",	S_TYP6,		A_B,	0xC1C0	},
    {	NULL,	"muls.w",	S_TYP6,		A_W,	0xC1C0	},
    {	NULL,	"muls.l",	S_TYP6,		A_L,	0xC1C0	},
    /*---*/
    {	NULL,	"mulu",		S_TYP6,		A_W,	0xC0C0	},
    {	NULL,	"mulu.b",	S_TYP6,		A_B,	0xC0C0	},
    {	NULL,	"mulu.w",	S_TYP6,		A_W,	0xC0C0	},
    {	NULL,	"mulu.l",	S_TYP6,		A_L,	0xC0C0	},

	/* Single Operand Instructions */

    {	NULL,	"clr",		S_TYP7,		A_W,	0x4240	},
    {	NULL,	"clr.b",	S_TYP7,		A_B,	0x4200	},
    {	NULL,	"clr.w",	S_TYP7,		A_W,	0x4240	},
    {	NULL,	"clr.l",	S_TYP7,		A_L,	0x4280	},
    /*---*/
    {	NULL,	"neg",		S_TYP7,		A_W,	0x4440	},
    {	NULL,	"neg.b",	S_TYP7,		A_B,	0x4400	},
    {	NULL,	"neg.w",	S_TYP7,		A_W,	0x4440	},
    {	NULL,	"neg.l",	S_TYP7,		A_L,	0x4480	},
    /*---*/
    {	NULL,	"negx",		S_TYP7,		A_W,	0x4040	},
    {	NULL,	"negx.b",	S_TYP7,		A_B,	0x4000	},
    {	NULL,	"negx.w",	S_TYP7,		A_W,	0x4040	},
    {	NULL,	"negx.l",	S_TYP7,		A_L,	0x4080	},
    /*---*/
    {	NULL,	"not",		S_TYP7,		A_W,	0x4640	},
    {	NULL,	"not.b",	S_TYP7,		A_B,	0x4600	},
    {	NULL,	"not.w",	S_TYP7,		A_W,	0x4640	},
    {	NULL,	"not.l",	S_TYP7,		A_L,	0x4680	},
    /*---*/
    {	NULL,	"tst",		S_TYP7,		A_W,	0x4A40	},
    {	NULL,	"tst.b",	S_TYP7,		A_B,	0x4A00	},
    {	NULL,	"tst.w",	S_TYP7,		A_W,	0x4A40	},
    {	NULL,	"tst.l",	S_TYP7,		A_L,	0x4A80	},

	/* Limited Addressing Mode Instructions */

    {	NULL,	"jmp",		S_TYP8,		A_L,	0x4EC0	},
    {	NULL,	"jmp.b",	S_TYP8,		A_B,	0x4EC0	},
    {	NULL,	"jmp.w",	S_TYP8,		A_W,	0x4EC0	},
    {	NULL,	"jmp.l",	S_TYP8,		A_L,	0x4EC0	},
    /*---*/
    {	NULL,	"jsr",		S_TYP8,		A_L,	0x4E80	},
    {	NULL,	"jsr.b",	S_TYP8,		A_B,	0x4E80	},
    {	NULL,	"jsr.w",	S_TYP8,		A_W,	0x4E80	},
    {	NULL,	"jsr.l",	S_TYP8,		A_L,	0x4E80	},
    /*---*/
    {	NULL,	"lea",		S_TYP8,		A_L,	0x41C0	},
    {	NULL,	"lea.b",	S_TYP8,		A_B,	0x41C0	},
    {	NULL,	"lea.w",	S_TYP8,		A_W,	0x41C0	},
    {	NULL,	"lea.l",	S_TYP8,		A_L,	0x41C0	},
    /*---*/
    {	NULL,	"pea",		S_TYP8,		A_L,	0x4840	},
    {	NULL,	"pea.b",	S_TYP8,		A_B,	0x4840	},
    {	NULL,	"pea.w",	S_TYP8,		A_W,	0x4840	},
    {	NULL,	"pea.l",	S_TYP8,		A_L,	0x4840	},

	/* Simple Instructions */

    {	NULL,	"nbcd",		S_TYP9,		A_B,	0x4800	},
    {	NULL,	"nbcd.b",	S_TYP9,		A_B,	0x4800	},
    {	NULL,	"nbcd.w",	S_TYP9,		A_W,	0x4800	},
    {	NULL,	"nbcd.l",	S_TYP9,		A_L,	0x4800	},
    /*---*/
    {	NULL,	"tas",		S_TYP9,		A_B,	0x4AC0	},
    {	NULL,	"tas.b",	S_TYP9,		A_B,	0x4AC0	},
    {	NULL,	"tas.w",	S_TYP9,		A_W,	0x4AC0	},
    {	NULL,	"tas.l",	S_TYP9,		A_L,	0x4AC0	},

	/* Shifting Instructions */

    {	NULL,	"asl",		S_SHFT,	ALT_W | A_W,	0xE140	},
    {	NULL,	"asl.b",	S_SHFT,		A_B,	0xE100	},
    {	NULL,	"asl.w",	S_SHFT,	ALT_W | A_W,	0xE140	},
    {	NULL,	"asl.l",	S_SHFT,		A_L,	0xE180	},
    /*---*/
    {	NULL,	"asr",		S_SHFT,	ALT_W | A_W,	0xE040	},
    {	NULL,	"asr.b",	S_SHFT,		A_B,	0xE000	},
    {	NULL,	"asr.w",	S_SHFT,	ALT_W | A_W,	0xE040	},
    {	NULL,	"asr.l",	S_SHFT,		A_L,	0xE080	},
    /*---*/
    {	NULL,	"lsl",		S_SHFT,	ALT_W | A_W,	0xE148	},
    {	NULL,	"lsl.b",	S_SHFT,		A_B,	0xE108	},
    {	NULL,	"lsl.w",	S_SHFT,	ALT_W | A_W,	0xE148	},
    {	NULL,	"lsl.l",	S_SHFT,		A_L,	0xE188	},
    /*---*/
    {	NULL,	"lsr",		S_SHFT,	ALT_W | A_W,	0xE048	},
    {	NULL,	"lsr.b",	S_SHFT,		A_B,	0xE008	},
    {	NULL,	"lsr.w",	S_SHFT,	ALT_W | A_W,	0xE048	},
    {	NULL,	"lsr.l",	S_SHFT,		A_L,	0xE088	},
    /*---*/
    {	NULL,	"rol",		S_SHFT,	ALT_W | A_W,	0xE158	},
    {	NULL,	"rol.b",	S_SHFT,		A_B,	0xE118	},
    {	NULL,	"rol.w",	S_SHFT,	ALT_W | A_W,	0xE158	},
    {	NULL,	"rol.l",	S_SHFT,		A_L,	0xE198	},
    /*---*/
    {	NULL,	"ror",		S_SHFT,	ALT_W | A_W,	0xE058	},
    {	NULL,	"ror.b",	S_SHFT,		A_B,	0xE018	},
    {	NULL,	"ror.w",	S_SHFT,	ALT_W | A_W,	0xE058	},
    {	NULL,	"ror.l",	S_SHFT,		A_L,	0xE098	},
    /*---*/
    {	NULL,	"roxl",		S_SHFT,	ALT_W | A_W,	0xE150	},
    {	NULL,	"roxl.b",	S_SHFT,		A_B,	0xE110	},
    {	NULL,	"roxl.w",	S_SHFT,	ALT_W | A_W,	0xE150	},
    {	NULL,	"roxl.l",	S_SHFT,		A_L,	0xE190	},
    /*---*/
    {	NULL,	"roxr",		S_SHFT,	ALT_W | A_W,	0xE050	},
    {	NULL,	"roxr.b",	S_SHFT,		A_B,	0xE010	},
    {	NULL,	"roxr.w",	S_SHFT,	ALT_W | A_W,	0xE050	},
    {	NULL,	"roxr.l",	S_SHFT,		A_L,	0xE090	},

	/* Branching Instructions */

    {	NULL,	"bra",		S_BCC,		B_A,	0x6000	},
    {	NULL,	"bra.b",	S_BCC,		B_S,	0x6000	},
    {	NULL,	"bra.s",	S_BCC,		B_S,	0x6000	},
    {	NULL,	"bra.w",	S_BCC,		B_W,	0x6000	},
    {	NULL,	"bra.l",	S_BCC,		B_L,	0x6000	},
    /*---*/
    {	NULL,	"bsr",		S_BCC,		B_A,	0x6100	},
    {	NULL,	"bsr.b",	S_BCC,		B_S,	0x6100	},
    {	NULL,	"bsr.s",	S_BCC,		B_S,	0x6100	},
    {	NULL,	"bsr.w",	S_BCC,		B_W,	0x6100	},
    {	NULL,	"bsr.l",	S_BCC,		B_L,	0x6100	},
    /*---*/
    {	NULL,	"bhi",		S_BCC,		B_A,	0x6200	},
    {	NULL,	"bhi.b",	S_BCC,		B_S,	0x6200	},
    {	NULL,	"bhi.s",	S_BCC,		B_S,	0x6200	},
    {	NULL,	"bhi.w",	S_BCC,		B_W,	0x6200	},
    {	NULL,	"bhi.l",	S_BCC,		B_L,	0x6200	},
    /*---*/
    {	NULL,	"bls",		S_BCC,		B_A,	0x6300	},
    {	NULL,	"bls.b",	S_BCC,		B_S,	0x6300	},
    {	NULL,	"bls.s",	S_BCC,		B_S,	0x6300	},
    {	NULL,	"bls.w",	S_BCC,		B_W,	0x6300	},
    {	NULL,	"bls.l",	S_BCC,		B_L,	0x6300	},
    /*---*/
    {	NULL,	"bcc",		S_BCC,		B_A,	0x6400	},
    {	NULL,	"bcc.b",	S_BCC,		B_S,	0x6400	},
    {	NULL,	"bcc.s",	S_BCC,		B_S,	0x6400	},
    {	NULL,	"bcc.w",	S_BCC,		B_W,	0x6400	},
    {	NULL,	"bcc.l",	S_BCC,		B_L,	0x6400	},
    /*---*/
    {	NULL,	"bcs",		S_BCC,		B_A,	0x6500	},
    {	NULL,	"bcs.b",	S_BCC,		B_S,	0x6500	},
    {	NULL,	"bcs.s",	S_BCC,		B_S,	0x6500	},
    {	NULL,	"bcs.w",	S_BCC,		B_W,	0x6500	},
    {	NULL,	"bcs.l",	S_BCC,		B_L,	0x6500	},
    /*---*/
    {	NULL,	"bne",		S_BCC,		B_A,	0x6600	},
    {	NULL,	"bne.b",	S_BCC,		B_S,	0x6600	},
    {	NULL,	"bne.s",	S_BCC,		B_S,	0x6600	},
    {	NULL,	"bne.w",	S_BCC,		B_W,	0x6600	},
    {	NULL,	"bne.l",	S_BCC,		B_L,	0x6600	},
    /*---*/
    {	NULL,	"beq",		S_BCC,		B_A,	0x6700	},
    {	NULL,	"beq.b",	S_BCC,		B_S,	0x6700	},
    {	NULL,	"beq.s",	S_BCC,		B_S,	0x6700	},
    {	NULL,	"beq.w",	S_BCC,		B_W,	0x6700	},
    {	NULL,	"beq.l",	S_BCC,		B_L,	0x6700	},
   /*---*/
    {	NULL,	"bvc",		S_BCC,		B_A,	0x6800	},
    {	NULL,	"bvc.b",	S_BCC,		B_S,	0x6800	},
    {	NULL,	"bvc.s",	S_BCC,		B_S,	0x6800	},
    {	NULL,	"bvc.w",	S_BCC,		B_W,	0x6800	},
    {	NULL,	"bvc.l",	S_BCC,		B_L,	0x6800	},
    /*---*/
    {	NULL,	"bvs",		S_BCC,		B_A,	0x6900	},
    {	NULL,	"bvs.b",	S_BCC,		B_S,	0x6900	},
    {	NULL,	"bvs.s",	S_BCC,		B_S,	0x6900	},
    {	NULL,	"bvs.w",	S_BCC,		B_W,	0x6900	},
    {	NULL,	"bvs.l",	S_BCC,		B_L,	0x6900	},
    /*---*/
    {	NULL,	"bpl",		S_BCC,		B_A,	0x6A00	},
    {	NULL,	"bpl.b",	S_BCC,		B_S,	0x6A00	},
    {	NULL,	"bpl.s",	S_BCC,		B_S,	0x6A00	},
    {	NULL,	"bpl.w",	S_BCC,		B_W,	0x6A00	},
    {	NULL,	"bpl.l",	S_BCC,		B_L,	0x6A00	},
    /*---*/
    {	NULL,	"bmi",		S_BCC,		B_A,	0x6B00	},
    {	NULL,	"bmi.b",	S_BCC,		B_S,	0x6B00	},
    {	NULL,	"bmi.s",	S_BCC,		B_S,	0x6B00	},
    {	NULL,	"bmi.w",	S_BCC,		B_W,	0x6B00	},
    {	NULL,	"bmi.l",	S_BCC,		B_L,	0x6B00	},
    /*---*/
    {	NULL,	"bge",		S_BCC,		B_A,	0x6C00	},
    {	NULL,	"bge.b",	S_BCC,		B_S,	0x6C00	},
    {	NULL,	"bge.s",	S_BCC,		B_S,	0x6C00	},
    {	NULL,	"bge.w",	S_BCC,		B_W,	0x6C00	},
    {	NULL,	"bge.l",	S_BCC,		B_L,	0x6C00	},
    /*---*/
    {	NULL,	"blt",		S_BCC,		B_A,	0x6D00	},
    {	NULL,	"blt.b",	S_BCC,		B_S,	0x6D00	},
    {	NULL,	"blt.s",	S_BCC,		B_S,	0x6D00	},
    {	NULL,	"blt.w",	S_BCC,		B_W,	0x6D00	},
    {	NULL,	"blt.l",	S_BCC,		B_L,	0x6D00	},
    /*---*/
    {	NULL,	"bgt",		S_BCC,		B_A,	0x6E00	},
    {	NULL,	"bgt.b",	S_BCC,		B_S,	0x6E00	},
    {	NULL,	"bgt.s",	S_BCC,		B_S,	0x6E00	},
    {	NULL,	"bgt.w",	S_BCC,		B_W,	0x6E00	},
    {	NULL,	"bgt.l",	S_BCC,		B_L,	0x6E00	},
    /*---*/
    {	NULL,	"ble",		S_BCC,		B_A,	0x6F00	},
    {	NULL,	"ble.b",	S_BCC,		B_S,	0x6F00	},
    {	NULL,	"ble.s",	S_BCC,		B_S,	0x6F00	},
    {	NULL,	"ble.w",	S_BCC,		B_W,	0x6F00	},
    {	NULL,	"ble.l",	S_BCC,		B_L,	0x6F00	},
    /*-- Alternate For BLS --*/
    {	NULL,	"blos",		S_BCC,		B_A,	0x6300	},
    {	NULL,	"blos.b",	S_BCC,		B_S,	0x6300	},
    {	NULL,	"blos.s",	S_BCC,		B_S,	0x6300	},
    {	NULL,	"blos.w",	S_BCC,		B_W,	0x6300	},
    {	NULL,	"blos.l",	S_BCC,		B_L,	0x6300	},
    /*-- Alternate For BCC --*/
    {	NULL,	"bhs",		S_BCC,		B_A,	0x6400	},
    {	NULL,	"bhs.b",	S_BCC,		B_S,	0x6400	},
    {	NULL,	"bhs.s",	S_BCC,		B_S,	0x6400	},
    {	NULL,	"bhs.w",	S_BCC,		B_W,	0x6400	},
    {	NULL,	"bhs.l",	S_BCC,		B_L,	0x6400	},
    /*-- Alternate For BCC --*/
    {	NULL,	"bhis",		S_BCC,		B_A,	0x6400	},
    {	NULL,	"bhis.b",	S_BCC,		B_S,	0x6400	},
    {	NULL,	"bhis.s",	S_BCC,		B_S,	0x6400	},
    {	NULL,	"bhis.w",	S_BCC,		B_W,	0x6400	},
    {	NULL,	"bhis.l",	S_BCC,		B_L,	0x6400	},
    /*-- Alternate For BCS --*/
    {	NULL,	"blo",		S_BCC,		B_A,	0x6500	},
    {	NULL,	"blo.b",	S_BCC,		B_S,	0x6500	},
    {	NULL,	"blo.s",	S_BCC,		B_S,	0x6500	},
    {	NULL,	"blo.w",	S_BCC,		B_W,	0x6500	},
    {	NULL,	"blo.l",	S_BCC,		B_L,	0x6500	},

	/* Decrement And Branch If Condition Not Matched */

    {	NULL,	"dbt",		S_DBCC,		A_W,	0x50C8	},
    {	NULL,	"dbt.w",	S_DBCC,		A_W,	0x50C8	},
    /*---*/
    {	NULL,	"dbf",		S_DBCC,		A_W,	0x51C8	},
    {	NULL,	"dbf.w",	S_DBCC,		A_W,	0x51C8	},
    /*---*/
    {	NULL,	"dbhi",		S_DBCC,		A_W,	0x52C8	},
    {	NULL,	"dbhi.w",	S_DBCC,		A_W,	0x52C8	},
    /*---*/
    {	NULL,	"dbls",		S_DBCC,		A_W,	0x53C8	},
    {	NULL,	"dbls.w",	S_DBCC,		A_W,	0x53C8	},
    /*---*/
    {	NULL,	"dbcc",		S_DBCC,		A_W,	0x54C8	},
    {	NULL,	"dbcc.w",	S_DBCC,		A_W,	0x54C8	},
    /*---*/
    {	NULL,	"dbcs",		S_DBCC,		A_W,	0x55C8	},
    {	NULL,	"dbcs.w",	S_DBCC,		A_W,	0x55C8	},
    /*---*/
    {	NULL,	"dbne",		S_DBCC,		A_W,	0x56C8	},
    {	NULL,	"dbne.w",	S_DBCC,		A_W,	0x56C8	},
    /*---*/
    {	NULL,	"dbeq",		S_DBCC,		A_W,	0x57C8	},
    {	NULL,	"dbeq.w",	S_DBCC,		A_W,	0x57C8	},
    /*---*/
    {	NULL,	"dbvc",		S_DBCC,		A_W,	0x58C8	},
    {	NULL,	"dbvc.w",	S_DBCC,		A_W,	0x58C8	},
    /*---*/
    {	NULL,	"dbvs",		S_DBCC,		A_W,	0x59C8	},
    {	NULL,	"dbvs.w",	S_DBCC,		A_W,	0x59C8	},
    /*---*/
    {	NULL,	"dbpl",		S_DBCC,		A_W,	0x5AC8	},
    {	NULL,	"dbpl.w",	S_DBCC,		A_W,	0x5AC8	},
    /*---*/
    {	NULL,	"dbmi",		S_DBCC,		A_W,	0x5BC8	},
    {	NULL,	"dbmi.w",	S_DBCC,		A_W,	0x5BC8	},
    /*---*/
    {	NULL,	"dbge",		S_DBCC,		A_W,	0x5CC8	},
    {	NULL,	"dbge.w",	S_DBCC,		A_W,	0x5CC8	},
    /*---*/
    {	NULL,	"dblt",		S_DBCC,		A_W,	0x5DC8	},
    {	NULL,	"dblt.w",	S_DBCC,		A_W,	0x5DC8	},
    /*---*/
    {	NULL,	"dbgt",		S_DBCC,		A_W,	0x5EC8	},
    {	NULL,	"dbgt.w",	S_DBCC,		A_W,	0x5EC8	},
    /*---*/
    {	NULL,	"dble",		S_DBCC,		A_W,	0x5FC8	},
    {	NULL,	"dble.w",	S_DBCC,		A_W,	0x5FC8	},
    /*-- Alternate For DBF --*/
    {	NULL,	"dbra",		S_DBCC,		A_W,	0x51C8	},
    {	NULL,	"dbra.w",	S_DBCC,		A_W,	0x51C8	},
    /*-- Alternate For DBCC --*/
    {	NULL,	"dbhs",		S_DBCC,		A_W,	0x54C8	},
    {	NULL,	"dbhs.w",	S_DBCC,		A_W,	0x54C8	},
    /*-- Alternate For DBCS --*/
    {	NULL,	"dblo",		S_DBCC,		A_W,	0x55C8	},
    {	NULL,	"dblo.w",	S_DBCC,		A_W,	0x55C8	},
    /*-- Alternate For DBCC --*/
    {	NULL,	"dbhis",	S_DBCC,		A_W,	0x54C8	},
    {	NULL,	"dbhis.w",	S_DBCC,		A_W,	0x54C8	},
    /*-- Alternate For DBLS --*/
    {	NULL,	"dblos",	S_DBCC,		A_W,	0x53C8	},
    {	NULL,	"dblos.w",	S_DBCC,		A_W,	0x53C8	},

	/* Set If Condition True Else Clear */

    {	NULL,	"st",		S_SCC,		A_B,	0x50C0	},
    {	NULL,	"st.b",		S_SCC,		A_B,	0x50C0	},
    /*---*/
    {	NULL,	"sf",		S_SCC,		A_B,	0x51C0	},
    {	NULL,	"sf.b",		S_SCC,		A_B,	0x51C0	},
    /*---*/
    {	NULL,	"shi",		S_SCC,		A_B,	0x52C0	},
    {	NULL,	"shi.b",	S_SCC,		A_B,	0x52C0	},
    /*---*/
    {	NULL,	"sls",		S_SCC,		A_B,	0x53C0	},
    {	NULL,	"sls.b",	S_SCC,		A_B,	0x53C0	},
    /*---*/
    {	NULL,	"scc",		S_SCC,		A_B,	0x54C0	},
    {	NULL,	"scc.b",	S_SCC,		A_B,	0x54C0	},
    /*---*/
    {	NULL,	"scs",		S_SCC,		A_B,	0x55C0	},
    {	NULL,	"scs.b",	S_SCC,		A_B,	0x55C0	},
    /*---*/
    {	NULL,	"sne",		S_SCC,		A_B,	0x56C0	},
    {	NULL,	"sne.b",	S_SCC,		A_B,	0x56C0	},
    /*---*/
    {	NULL,	"seq",		S_SCC,		A_B,	0x57C0	},
    {	NULL,	"seq.b",	S_SCC,		A_B,	0x57C0	},
    /*---*/
    {	NULL,	"svc",		S_SCC,		A_B,	0x58C0	},
    {	NULL,	"svc.b",	S_SCC,		A_B,	0x58C0	},
    /*---*/
    {	NULL,	"svs",		S_SCC,		A_B,	0x59C0	},
    {	NULL,	"svs.b",	S_SCC,		A_B,	0x59C0	},
    /*---*/
    {	NULL,	"spl",		S_SCC,		A_B,	0x5AC0	},
    {	NULL,	"spl.b",	S_SCC,		A_B,	0x5AC0	},
    /*---*/
    {	NULL,	"smi",		S_SCC,		A_B,	0x5BC0	},
    {	NULL,	"smi.b",	S_SCC,		A_B,	0x5BC0	},
    /*---*/
    {	NULL,	"sge",		S_SCC,		A_B,	0x5CC0	},
    {	NULL,	"sge.b",	S_SCC,		A_B,	0x5CC0	},
    /*---*/
    {	NULL,	"slt",		S_SCC,		A_B,	0x5DC0	},
    {	NULL,	"slt.b",	S_SCC,		A_B,	0x5DC0	},
    /*---*/
    {	NULL,	"sgt",		S_SCC,		A_B,	0x5EC0	},
    {	NULL,	"sgt.b",	S_SCC,		A_B,	0x5EC0	},
    /*---*/
    {	NULL,	"sle",		S_SCC,		A_B,	0x5FC0	},
    {	NULL,	"sle.b",	S_SCC,		A_B,	0x5FC0	},
    /*-- Alternate For SCC --*/
    {	NULL,	"shs",		S_SCC,		A_B,	0x54C0	},
    {	NULL,	"shs.b",	S_SCC,		A_B,	0x54C0	},
    /*-- Alternate For SCS --*/
    {	NULL,	"slo",		S_SCC,		A_B,	0x55C0	},
    {	NULL,	"slo.b",	S_SCC,		A_B,	0x55C0	},
    /*-- Alternate For SCC --*/
    {	NULL,	"shis",		S_SCC,		A_B,	0x54C0	},
    {	NULL,	"shis.b",	S_SCC,		A_B,	0x54C0	},
    /*-- Alternate For SLS --*/
    {	NULL,	"slos",		S_SCC,		A_B,	0x53C0	},
    {	NULL,	"slos.b",	S_SCC,		A_B,	0x53C0	},

	/* Bit Instructions */

    {	NULL,	"bchg",		S_BIT,		A_A,	0x0140	},
    {	NULL,	"bchg.b",	S_BIT,		A_B,	0x0140	},
    {	NULL,	"bchg.w",	S_BIT,		A_W,	0x0140	},
    {	NULL,	"bchg.l",	S_BIT,		A_L,	0x0140	},
    /*---*/
    {	NULL,	"bclr",		S_BIT,		A_A,	0x0180	},
    {	NULL,	"bclr.b",	S_BIT,		A_B,	0x0180	},
    {	NULL,	"bclr.w",	S_BIT,		A_W,	0x0180	},
    {	NULL,	"bclr.l",	S_BIT,		A_L,	0x0180	},
    /*---*/
    {	NULL,	"bset",		S_BIT,		A_A,	0x01C0	},
    {	NULL,	"bset.b",	S_BIT,		A_B,	0x01C0	},
    {	NULL,	"bset.w",	S_BIT,		A_W,	0x01C0	},
    {	NULL,	"bset.l",	S_BIT,		A_L,	0x01C0	},
    /*---*/
    {	NULL,	"btst",		S_BIT,		A_A,	0x0100	},
    {	NULL,	"btst.b",	S_BIT,		A_B,	0x0100	},
    {	NULL,	"btst.w",	S_BIT,		A_W,	0x0100	},
    {	NULL,	"btst.l",	S_BIT,		A_L,	0x0100	},

	/* Move Instructions */

    {	NULL,	"move",		S_MOVE, ALT_X | A_W,	0x3000	},
    {	NULL,	"move.b",	S_MOVE,		A_B,	0x1000	},
    {	NULL,	"move.w",	S_MOVE, ALT_W | A_W,	0x3000	},
    {	NULL,	"move.l",	S_MOVE,	ALT_L | A_L,	0x2000	},
    /*---*/
    {	NULL,	"movea",	S_MOVEA,	A_W,	0x3040	},
    {	NULL,	"movea.b",	S_MOVEA,	A_B,	0x3040	},
    {	NULL,	"movea.w",	S_MOVEA,	A_W,	0x3040	},
    {	NULL,	"movea.l",	S_MOVEA,	A_L,	0x2040	},
    /*---*/
    {	NULL,	"movec",	S_MOVEC,	A_L,	0x4E7A	},
    {	NULL,	"movec.b",	S_MOVEC,	A_B,	0x4E7A	},
    {	NULL,	"movec.w",	S_MOVEC,	A_W,	0x4E7A	},
    {	NULL,	"movec.l",	S_MOVEC,	A_L,	0x4E7A	},
    /*---*/
    {	NULL,	"movem",	S_MOVEM,	A_L,	0x48C0	},
    {	NULL,	"movem.b",	S_MOVEM,	A_B,	0x4880	},
    {	NULL,	"movem.w",	S_MOVEM,	A_W,	0x4880	},
    {	NULL,	"movem.l",	S_MOVEM,	A_L,	0x48C0	},
    /*---*/
    {	NULL,	"movep",	S_MOVEP,	A_W,	0x0108	},
    {	NULL,	"movep.b",	S_MOVEP,	A_B,	0x0108	},
    {	NULL,	"movep.w",	S_MOVEP,	A_W,	0x0108	},
    {	NULL,	"movep.l",	S_MOVEP,	A_L,	0x0148	},
    /*---*/
    {	NULL,	"moveq",	S_MOVEQ,	A_L,	0x7000	},
    {	NULL,	"moveq.l",	S_MOVEQ,	A_L,	0x7000	},
    /*---*/
    {	NULL,	"moves",	S_MOVES,	A_W,	0x0E40	},
    {	NULL,	"moves.b",	S_MOVES,	A_B,	0x0E00	},
    {	NULL,	"moves.w",	S_MOVES,	A_W,	0x0E40	},
    {	NULL,	"moves.l",	S_MOVES,	A_L,	0x0E80	},

	/* Miscellaneous Format Instructions */

    {	NULL,	"cmp",		S_CMP,		A_W,	0xB040	},
    {	NULL,	"cmp.b",	S_CMP,		A_B,	0xB000	},
    {	NULL,	"cmp.w",	S_CMP,		A_W,	0xB040	},
    {	NULL,	"cmp.l",	S_CMP,		A_L,	0xB080	},
    /*---*/
    {	NULL,	"cmpm",		S_CMPM,		A_W,	0xB148	},
    {	NULL,	"cmpm.b",	S_CMPM,		A_B,	0xB108	},
    {	NULL,	"cmpm.w",	S_CMPM,		A_W,	0xB148	},
    {	NULL,	"cmpm.l",	S_CMPM,		A_L,	0xB188	},
    /*---*/
    {	NULL,	"eor",		S_EOR,	  A_A | A_W,	0xB140	},
    {	NULL,	"eor.b",	S_EOR,		A_B,	0xB100	},
    {	NULL,	"eor.w",	S_EOR,		A_W,	0xB140	},
    {	NULL,	"eor.l",	S_EOR,		A_L,	0xB180	},
    /*---*/
    {	NULL,	"exg",		S_EXG,		A_L,	0xC100	},
    {	NULL,	"exg.l",	S_EXG,		A_L,	0xC100	},
    /*---*/
    {	NULL,	"ext",		S_EXT,		A_W,	0x4880	},
    {	NULL,	"ext.b",	S_EXT,		A_B,	0x4880	},
    {	NULL,	"ext.w",	S_EXT,		A_W,	0x4880	},
    {	NULL,	"ext.l",	S_EXT,		A_L,	0x48C0	},
    /*---*/
    {	NULL,	"rtd",		S_STOP,		A_U,	0x4E74	},
    /*---*/
    {	NULL,	"stop",		S_STOP,		A_U,	0x4E72	},
    /*---*/
    {	NULL,	"swap",		S_SWAP,		A_W,	0x4840	},
    {	NULL,	"swap.w",	S_SWAP,		A_W,	0x4840	},
    /*---*/
    {	NULL,	"trap",		S_TRAP,		A_U,	0x4E40	},
    /*---*/
    {	NULL,	"unlk",		S_UNLK,		A_U,	0x4E58	},

	/* Inherent Instructions */

    {	NULL,	"illegal",	S_INH,		A_U,	0x4AFC	},
    {	NULL,	"nop",		S_INH,		A_U,	0x4E71	},
    {	NULL,	"reset",	S_INH,		A_U,	0x4E70	},
    {	NULL,	"rte",		S_INH,		A_U,	0x4E73	},
    {	NULL,	"rtr",		S_INH,		A_U,	0x4E77	},
    {	NULL,	"rts",		S_INH,		A_U,	0x4E75	},
    {	NULL,	"trapv",	S_INH,		A_U,	0x4E76	},

	/*
	 * 68020 Instructions
	 */

    {	NULL,	"bfchg",	S_BF,		A_L,	0xEAC0	},
    {	NULL,	"bfclr",	S_BF,		A_L,	0xECC0	},
    {	NULL,	"bfexts",	S_BF,		A_L,	0xEBC0	},
    {	NULL,	"bfextu",	S_BF,		A_L,	0xE9C0	},
    {	NULL,	"bfffo",	S_BF,		A_L,	0xEDC0	},
    {	NULL,	"bfins",	S_BF,		A_L,	0xEFC0	},
    {	NULL,	"bfset",	S_BF,		A_L,	0xEEC0	},
    {	NULL,	"bftst",	S_BF,		A_L,	0xE8C0	},
    /*---*/
    {	NULL,	"bkpt",		S_BKPT,		A_U,	0x4848	},
    /*---*/
    {	NULL,	"callm",	S_CALLM,	A_U,	0x06C0	},
    /*---*/
    {	NULL,	"cas",		S_CAS,		A_W,	0x08C0	},
    {	NULL,	"cas.b",	S_CAS,		A_B,	0x08C0	},
    {	NULL,	"cas.w",	S_CAS,		A_W,	0x08C0	},
    {	NULL,	"cas.l",	S_CAS,		A_L,	0x08C0	},
    /*---*/
    {	NULL,	"cas2",		S_CAS2,		A_W,	0x08FC	},
    {	NULL,	"cas2.b",	S_CAS2,		A_B,	0x08FC	},
    {	NULL,	"cas2.w",	S_CAS2,		A_W,	0x08FC	},
    {	NULL,	"cas2.l",	S_CAS2,		A_L,	0x08FC	},
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
    /*---*/
    {	NULL,	"divsl",	S_TYP6,		A_L,	0x0001	},
    {	NULL,	"divsl.l",	S_TYP6,		A_L,	0x0001	},
    /*---*/
    {	NULL,	"divul",	S_TYP6,		A_L,	0x0002	},
    {	NULL,	"divul.l",	S_TYP6,		A_L,	0x0002	},
    /*---*/
    {	NULL,	"extb",		S_EXTB,		A_L,	0x49C0	},
    {	NULL,	"extb.b",	S_EXTB,		A_B,	0x49C0	},
    {	NULL,	"extb.w",	S_EXTB,		A_W,	0x49C0	},
    {	NULL,	"extb.l",	S_EXTB,		A_L,	0x49C0	},
    /*---*/
    {	NULL,	"link",		S_LINK,		A_A,	0x4E50	},
    {	NULL,	"link.w",	S_LINK,		A_W,	0x4E50	},
    {	NULL,	"link.l",	S_LINK,		A_L,	0x4808	},
    /*---*/
    {	NULL,	"pack",		S_PKUK,		0,	0x8140	},
    {	NULL,	"unpk",		S_PKUK,		0,	0x8180	},
    /*---*/
    {	NULL,	"rtm",		S_RTM,		0,	0x06C0	},
    /*---*/
    {	NULL,	"trapt",	S_TRPC,		A_A,	0x50F8	},
    {	NULL,	"trapt.w",	S_TRPC,		A_W,	0x50F8	},
    {	NULL,	"trapt.l",	S_TRPC,		A_L,	0x50F8	},
    /*---*/
    {	NULL,	"trapf",	S_TRPC,		A_A,	0x51F8	},
    {	NULL,	"trapf.w",	S_TRPC,		A_W,	0x51F8	},
    {	NULL,	"trapf.l",	S_TRPC,		A_L,	0x51F8	},
    /*---*/
    {	NULL,	"traphi",	S_TRPC,		A_A,	0x52F8	},
    {	NULL,	"traphi.w",	S_TRPC,		A_W,	0x52F8	},
    {	NULL,	"traphi.l",	S_TRPC,		A_L,	0x52F8	},
    /*---*/
    {	NULL,	"trapls",	S_TRPC,		A_A,	0x53F8	},
    {	NULL,	"trapls.w",	S_TRPC,		A_W,	0x53F8	},
    {	NULL,	"trapls.l",	S_TRPC,		A_L,	0x53F8	},
    /*---*/
    {	NULL,	"trapcc",	S_TRPC,		A_A,	0x54F8	},
    {	NULL,	"trapcc.w",	S_TRPC,		A_W,	0x54F8	},
    {	NULL,	"trapcc.l",	S_TRPC,		A_L,	0x54F8	},
    /*---*/
    {	NULL,	"trapcs",	S_TRPC,		A_A,	0x55F8	},
    {	NULL,	"trapcs.w",	S_TRPC,		A_W,	0x55F8	},
    {	NULL,	"trapcs.l",	S_TRPC,		A_L,	0x55F8	},
    /*---*/
    {	NULL,	"trapne",	S_TRPC,		A_A,	0x56F8	},
    {	NULL,	"trapne.w",	S_TRPC,		A_W,	0x56F8	},
    {	NULL,	"trapne.l",	S_TRPC,		A_L,	0x56F8	},
    /*---*/
    {	NULL,	"trapeq",	S_TRPC,		A_A,	0x57F8	},
    {	NULL,	"trapeq.w",	S_TRPC,		A_W,	0x57F8	},
    {	NULL,	"trapeq.l",	S_TRPC,		A_L,	0x57F8	},
   /*---*/
    {	NULL,	"trapvc",	S_TRPC,		A_A,	0x58F8	},
    {	NULL,	"trapvc.w",	S_TRPC,		A_W,	0x58F8	},
    {	NULL,	"trapvc.l",	S_TRPC,		A_L,	0x58F8	},
    /*---*/
    {	NULL,	"trapvs",	S_TRPC,		A_A,	0x59F8	},
    {	NULL,	"trapvs.w",	S_TRPC,		A_W,	0x59F8	},
    {	NULL,	"trapvs.l",	S_TRPC,		A_L,	0x59F8	},
   /*---*/
    {	NULL,	"trappl",	S_TRPC,		A_A,	0x5AF8	},
    {	NULL,	"trappl.w",	S_TRPC,		A_W,	0x5AF8	},
    {	NULL,	"trappl.l",	S_TRPC,		A_L,	0x5AF8	},
    /*---*/
    {	NULL,	"trapmi",	S_TRPC,		A_A,	0x5BF8	},
    {	NULL,	"trapmi.w",	S_TRPC,		A_W,	0x5BF8	},
    {	NULL,	"trapmi.l",	S_TRPC,		A_L,	0x5BF8	},
    /*---*/
    {	NULL,	"trapge",	S_TRPC,		A_A,	0x5CF8	},
    {	NULL,	"trapge.w",	S_TRPC,		A_W,	0x5CF8	},
    {	NULL,	"trapge.l",	S_TRPC,		A_L,	0x5CF8	},
    /*---*/
    {	NULL,	"traplt",	S_TRPC,		A_A,	0x5DF8	},
    {	NULL,	"traplt.w",	S_TRPC,		A_W,	0x5DF8	},
    {	NULL,	"traplt.l",	S_TRPC,		A_L,	0x5DF8	},
    /*---*/
    {	NULL,	"trapgt",	S_TRPC,		A_A,	0x5EF8	},
    {	NULL,	"trapgt.w",	S_TRPC,		A_W,	0x5EF8	},
    {	NULL,	"trapgt.l",	S_TRPC,		A_L,	0x5EF8	},
    /*---*/
    {	NULL,	"traple",	S_TRPC,		A_A,	0x5FF8	},
    {	NULL,	"traple.w",	S_TRPC,		A_W,	0x5FF8	},
    {	NULL,	"traple.l",	S_TRPC,		A_L,	0x5FF8	},
    /*---*/
    {	NULL,	"traphs",	S_TRPC,		A_A,	0x54F8	},
    {	NULL,	"traphs.w",	S_TRPC,		A_W,	0x54F8	},
    {	NULL,	"traphs.l",	S_TRPC,		A_L,	0x54F8	},
    /*---*/
    {	NULL,	"traplo",	S_TRPC,		A_A,	0x55F8	},
    {	NULL,	"traplo.w",	S_TRPC,		A_W,	0x55F8	},
    {	NULL,	"traplo.l",	S_TRPC,		A_L,	0x55F8	},

	/*
	 * MC68881/MC68882 Floating Point CoProcessor
	 */

    {	NULL,	".68881",	S_68XXX,	0,	M_68881	},
    {	NULL,	".68882",	S_68XXX,	0,	M_68882	},
    {	NULL,	".fcoid",	S_FCOID,	0,	0x0001	},

    {	NULL,	"fmove",	F_MOV,		F_A,	0x0000	},
    {	NULL,	"fmove.b",	F_MOV,		F_B,	0x0000	},
    {	NULL,	"fmove.w",	F_MOV,		F_W,	0x0000	},
    {	NULL,	"fmove.l",	F_MOV,		F_L,	0x0000	},
    {	NULL,	"fmove.s",	F_MOV,		F_S,	0x0000	},
    {	NULL,	"fmove.d",	F_MOV,		F_D,	0x0000	},
    {	NULL,	"fmove.x",	F_MOV,		F_X,	0x0000	},
    {	NULL,	"fmove.p",	F_MOV,		F_P,	0x0000	},

    {	NULL,	"fint",		F_TYP1,		F_X,	0x0001	},
    {	NULL,	"fint.b",	F_TYP1,		F_B,	0x0001	},
    {	NULL,	"fint.w",	F_TYP1,		F_W,	0x0001	},
    {	NULL,	"fint.l",	F_TYP1,		F_L,	0x0001	},
    {	NULL,	"fint.s",	F_TYP1,		F_S,	0x0001	},
    {	NULL,	"fint.d",	F_TYP1,		F_D,	0x0001	},
    {	NULL,	"fint.x",	F_TYP1,		F_X,	0x0001	},
    {	NULL,	"fint.p",	F_TYP1,		F_P,	0x0001	},

    {	NULL,	"fsinh",	F_TYP1,		F_X,	0x0002	},
    {	NULL,	"fsinh.b",	F_TYP1,		F_B,	0x0002	},
    {	NULL,	"fsinh.w",	F_TYP1,		F_W,	0x0002	},
    {	NULL,	"fsinh.l",	F_TYP1,		F_L,	0x0002	},
    {	NULL,	"fsinh.s",	F_TYP1,		F_S,	0x0002	},
    {	NULL,	"fsinh.d",	F_TYP1,		F_D,	0x0002	},
    {	NULL,	"fsinh.x",	F_TYP1,		F_X,	0x0002	},
    {	NULL,	"fsinh.p",	F_TYP1,		F_P,	0x0002	},

    {	NULL,	"fintrz",	F_TYP1,		F_X,	0x0003	},
    {	NULL,	"fintrz.b",	F_TYP1,		F_B,	0x0003	},
    {	NULL,	"fintrz.w",	F_TYP1,		F_W,	0x0003	},
    {	NULL,	"fintrz.l",	F_TYP1,		F_L,	0x0003	},
    {	NULL,	"fintrz.s",	F_TYP1,		F_S,	0x0003	},
    {	NULL,	"fintrz.d",	F_TYP1,		F_D,	0x0003	},
    {	NULL,	"fintrz.x",	F_TYP1,		F_X,	0x0003	},
    {	NULL,	"fintrz.p",	F_TYP1,		F_P,	0x0003	},

    {	NULL,	"fsqrt",	F_TYP1,		F_X,	0x0004	},
    {	NULL,	"fsqrt.b",	F_TYP1,		F_B,	0x0004	},
    {	NULL,	"fsqrt.w",	F_TYP1,		F_W,	0x0004	},
    {	NULL,	"fsqrt.l",	F_TYP1,		F_L,	0x0004	},
    {	NULL,	"fsqrt.s",	F_TYP1,		F_S,	0x0004	},
    {	NULL,	"fsqrt.d",	F_TYP1,		F_D,	0x0004	},
    {	NULL,	"fsqrt.x",	F_TYP1,		F_X,	0x0004	},
    {	NULL,	"fsqrt.p",	F_TYP1,		F_P,	0x0004	},

    {	NULL,	"flognp1",	F_TYP1,		F_X,	0x0006	},
    {	NULL,	"flognp1.b",	F_TYP1,		F_B,	0x0006	},
    {	NULL,	"flognp1.w",	F_TYP1,		F_W,	0x0006	},
    {	NULL,	"flognp1.l",	F_TYP1,		F_L,	0x0006	},
    {	NULL,	"flognp1.s",	F_TYP1,		F_S,	0x0006	},
    {	NULL,	"flognp1.d",	F_TYP1,		F_D,	0x0006	},
    {	NULL,	"flognp1.x",	F_TYP1,		F_X,	0x0006	},
    {	NULL,	"flognp1.p",	F_TYP1,		F_P,	0x0006	},

    {	NULL,	"fetoxm1",	F_TYP1,		F_X,	0x0008	},
    {	NULL,	"fetoxm1.b",	F_TYP1,		F_B,	0x0008	},
    {	NULL,	"fetoxm1.w",	F_TYP1,		F_W,	0x0008	},
    {	NULL,	"fetoxm1.l",	F_TYP1,		F_L,	0x0008	},
    {	NULL,	"fetoxm1.s",	F_TYP1,		F_S,	0x0008	},
    {	NULL,	"fetoxm1.d",	F_TYP1,		F_D,	0x0008	},
    {	NULL,	"fetoxm1.x",	F_TYP1,		F_X,	0x0008	},
    {	NULL,	"fetoxm1.p",	F_TYP1,		F_P,	0x0008	},

    {	NULL,	"ftanh",	F_TYP1,		F_X,	0x0009	},
    {	NULL,	"ftanh.b",	F_TYP1,		F_B,	0x0009	},
    {	NULL,	"ftanh.w",	F_TYP1,		F_W,	0x0009	},
    {	NULL,	"ftanh.l",	F_TYP1,		F_L,	0x0009	},
    {	NULL,	"ftanh.s",	F_TYP1,		F_S,	0x0009	},
    {	NULL,	"ftanh.d",	F_TYP1,		F_D,	0x0009	},
    {	NULL,	"ftanh.x",	F_TYP1,		F_X,	0x0009	},
    {	NULL,	"ftanh.p",	F_TYP1,		F_P,	0x0009	},

    {	NULL,	"fatan",	F_TYP1,		F_X,	0x000A	},
    {	NULL,	"fatan.b",	F_TYP1,		F_B,	0x000A	},
    {	NULL,	"fatan.w",	F_TYP1,		F_W,	0x000A	},
    {	NULL,	"fatan.l",	F_TYP1,		F_L,	0x000A	},
    {	NULL,	"fatan.s",	F_TYP1,		F_S,	0x000A	},
    {	NULL,	"fatan.d",	F_TYP1,		F_D,	0x000A	},
    {	NULL,	"fatan.x",	F_TYP1,		F_X,	0x000A	},
    {	NULL,	"fatan.p",	F_TYP1,		F_P,	0x000A	},

    {	NULL,	"fasin",	F_TYP1,		F_X,	0x000C	},
    {	NULL,	"fasin.b",	F_TYP1,		F_B,	0x000C	},
    {	NULL,	"fasin.w",	F_TYP1,		F_W,	0x000C	},
    {	NULL,	"fasin.l",	F_TYP1,		F_L,	0x000C	},
    {	NULL,	"fasin.s",	F_TYP1,		F_S,	0x000C	},
    {	NULL,	"fasin.d",	F_TYP1,		F_D,	0x000C	},
    {	NULL,	"fasin.x",	F_TYP1,		F_X,	0x000C	},
    {	NULL,	"fasin.p",	F_TYP1,		F_P,	0x000C	},

    {	NULL,	"fatanh",	F_TYP1,		F_X,	0x000D	},
    {	NULL,	"fatanh.b",	F_TYP1,		F_B,	0x000D	},
    {	NULL,	"fatanh.w",	F_TYP1,		F_W,	0x000D	},
    {	NULL,	"fatanh.l",	F_TYP1,		F_L,	0x000D	},
    {	NULL,	"fatanh.s",	F_TYP1,		F_S,	0x000D	},
    {	NULL,	"fatanh.d",	F_TYP1,		F_D,	0x000D	},
    {	NULL,	"fatanh.x",	F_TYP1,		F_X,	0x000D	},
    {	NULL,	"fatanh.p",	F_TYP1,		F_P,	0x000D	},

    {	NULL,	"fsin",		F_TYP1,		F_X,	0x000E	},
    {	NULL,	"fsin.b",	F_TYP1,		F_B,	0x000E	},
    {	NULL,	"fsin.w",	F_TYP1,		F_W,	0x000E	},
    {	NULL,	"fsin.l",	F_TYP1,		F_L,	0x000E	},
    {	NULL,	"fsin.s",	F_TYP1,		F_S,	0x000E	},
    {	NULL,	"fsin.d",	F_TYP1,		F_D,	0x000E	},
    {	NULL,	"fsin.x",	F_TYP1,		F_X,	0x000E	},
    {	NULL,	"fsin.p",	F_TYP1,		F_P,	0x000E	},

    {	NULL,	"ftan",		F_TYP1,		F_X,	0x000F	},
    {	NULL,	"ftan.b",	F_TYP1,		F_B,	0x000F	},
    {	NULL,	"ftan.w",	F_TYP1,		F_W,	0x000F	},
    {	NULL,	"ftan.l",	F_TYP1,		F_L,	0x000F	},
    {	NULL,	"ftan.s",	F_TYP1,		F_S,	0x000F	},
    {	NULL,	"ftan.d",	F_TYP1,		F_D,	0x000F	},
    {	NULL,	"ftan.x",	F_TYP1,		F_X,	0x000F	},
    {	NULL,	"ftan.p",	F_TYP1,		F_P,	0x000F	},

    {	NULL,	"fetox",	F_TYP1,		F_X,	0x0010	},
    {	NULL,	"fetox.b",	F_TYP1,		F_B,	0x0010	},
    {	NULL,	"fetox.w",	F_TYP1,		F_W,	0x0010	},
    {	NULL,	"fetox.l",	F_TYP1,		F_L,	0x0010	},
    {	NULL,	"fetox.s",	F_TYP1,		F_S,	0x0010	},
    {	NULL,	"fetox.d",	F_TYP1,		F_D,	0x0010	},
    {	NULL,	"fetox.x",	F_TYP1,		F_X,	0x0010	},
    {	NULL,	"fetox.p",	F_TYP1,		F_P,	0x0010	},

    {	NULL,	"ftwotox",	F_TYP1,		F_X,	0x0011	},
    {	NULL,	"ftwotox.b",	F_TYP1,		F_B,	0x0011	},
    {	NULL,	"ftwotox.w",	F_TYP1,		F_W,	0x0011	},
    {	NULL,	"ftwotox.l",	F_TYP1,		F_L,	0x0011	},
    {	NULL,	"ftwotox.s",	F_TYP1,		F_S,	0x0011	},
    {	NULL,	"ftwotox.d",	F_TYP1,		F_D,	0x0011	},
    {	NULL,	"ftwotox.x",	F_TYP1,		F_X,	0x0011	},
    {	NULL,	"ftwotox.p",	F_TYP1,		F_P,	0x0011	},

    {	NULL,	"ftentox",	F_TYP1,		F_X,	0x0012	},
    {	NULL,	"ftentox.b",	F_TYP1,		F_B,	0x0012	},
    {	NULL,	"ftentox.w",	F_TYP1,		F_W,	0x0012	},
    {	NULL,	"ftentox.l",	F_TYP1,		F_L,	0x0012	},
    {	NULL,	"ftentox.s",	F_TYP1,		F_S,	0x0012	},
    {	NULL,	"ftentox.d",	F_TYP1,		F_D,	0x0012	},
    {	NULL,	"ftentox.x",	F_TYP1,		F_X,	0x0012	},
    {	NULL,	"ftentox.p",	F_TYP1,		F_P,	0x0012	},

    {	NULL,	"flogn",	F_TYP1,		F_X,	0x0014	},
    {	NULL,	"flogn.b",	F_TYP1,		F_B,	0x0014	},
    {	NULL,	"flogn.w",	F_TYP1,		F_W,	0x0014	},
    {	NULL,	"flogn.l",	F_TYP1,		F_L,	0x0014	},
    {	NULL,	"flogn.s",	F_TYP1,		F_S,	0x0014	},
    {	NULL,	"flogn.d",	F_TYP1,		F_D,	0x0014	},
    {	NULL,	"flogn.x",	F_TYP1,		F_X,	0x0014	},
    {	NULL,	"flogn.p",	F_TYP1,		F_P,	0x0014	},

    {	NULL,	"flog10",	F_TYP1,		F_X,	0x0015	},
    {	NULL,	"flog10.b",	F_TYP1,		F_B,	0x0015	},
    {	NULL,	"flog10.w",	F_TYP1,		F_W,	0x0015	},
    {	NULL,	"flog10.l",	F_TYP1,		F_L,	0x0015	},
    {	NULL,	"flog10.s",	F_TYP1,		F_S,	0x0015	},
    {	NULL,	"flog10.d",	F_TYP1,		F_D,	0x0015	},
    {	NULL,	"flog10.x",	F_TYP1,		F_X,	0x0015	},
    {	NULL,	"flog10.p",	F_TYP1,		F_P,	0x0015	},

    {	NULL,	"flog2",	F_TYP1,		F_X,	0x0016	},
    {	NULL,	"flog2.b",	F_TYP1,		F_B,	0x0016	},
    {	NULL,	"flog2.w",	F_TYP1,		F_W,	0x0016	},
    {	NULL,	"flog2.l",	F_TYP1,		F_L,	0x0016	},
    {	NULL,	"flog2.s",	F_TYP1,		F_S,	0x0016	},
    {	NULL,	"flog2.d",	F_TYP1,		F_D,	0x0016	},
    {	NULL,	"flog2.x",	F_TYP1,		F_X,	0x0016	},
    {	NULL,	"flog2.p",	F_TYP1,		F_P,	0x0016	},

    {	NULL,	"fabs",		F_TYP1,		F_X,	0x0018	},
    {	NULL,	"fabs.b",	F_TYP1,		F_B,	0x0018	},
    {	NULL,	"fabs.w",	F_TYP1,		F_W,	0x0018	},
    {	NULL,	"fabs.l",	F_TYP1,		F_L,	0x0018	},
    {	NULL,	"fabs.s",	F_TYP1,		F_S,	0x0018	},
    {	NULL,	"fabs.d",	F_TYP1,		F_D,	0x0018	},
    {	NULL,	"fabs.x",	F_TYP1,		F_X,	0x0018	},
    {	NULL,	"fabs.p",	F_TYP1,		F_P,	0x0018	},

    {	NULL,	"fcosh",	F_TYP1,		F_X,	0x0019	},
    {	NULL,	"fcosh.b",	F_TYP1,		F_B,	0x0019	},
    {	NULL,	"fcosh.w",	F_TYP1,		F_W,	0x0019	},
    {	NULL,	"fcosh.l",	F_TYP1,		F_L,	0x0019	},
    {	NULL,	"fcosh.s",	F_TYP1,		F_S,	0x0019	},
    {	NULL,	"fcosh.d",	F_TYP1,		F_D,	0x0019	},
    {	NULL,	"fcosh.x",	F_TYP1,		F_X,	0x0019	},
    {	NULL,	"fcosh.p",	F_TYP1,		F_P,	0x0019	},

    {	NULL,	"fneg",		F_TYP1,		F_X,	0x001A	},
    {	NULL,	"fneg.b",	F_TYP1,		F_B,	0x001A	},
    {	NULL,	"fneg.w",	F_TYP1,		F_W,	0x001A	},
    {	NULL,	"fneg.l",	F_TYP1,		F_L,	0x001A	},
    {	NULL,	"fneg.s",	F_TYP1,		F_S,	0x001A	},
    {	NULL,	"fneg.d",	F_TYP1,		F_D,	0x001A	},
    {	NULL,	"fneg.x",	F_TYP1,		F_X,	0x001A	},
    {	NULL,	"fneg.p",	F_TYP1,		F_P,	0x001A	},

    {	NULL,	"facos",	F_TYP1,		F_X,	0x001C	},
    {	NULL,	"facos.b",	F_TYP1,		F_B,	0x001C	},
    {	NULL,	"facos.w",	F_TYP1,		F_W,	0x001C	},
    {	NULL,	"facos.l",	F_TYP1,		F_L,	0x001C	},
    {	NULL,	"facos.s",	F_TYP1,		F_S,	0x001C	},
    {	NULL,	"facos.d",	F_TYP1,		F_D,	0x001C	},
    {	NULL,	"facos.x",	F_TYP1,		F_X,	0x001C	},
    {	NULL,	"facos.p",	F_TYP1,		F_P,	0x001C	},

    {	NULL,	"fcos",		F_TYP1,		F_X,	0x001D	},
    {	NULL,	"fcos.b",	F_TYP1,		F_B,	0x001D	},
    {	NULL,	"fcos.w",	F_TYP1,		F_W,	0x001D	},
    {	NULL,	"fcos.l",	F_TYP1,		F_L,	0x001D	},
    {	NULL,	"fcos.s",	F_TYP1,		F_S,	0x001D	},
    {	NULL,	"fcos.d",	F_TYP1,		F_D,	0x001D	},
    {	NULL,	"fcos.x",	F_TYP1,		F_X,	0x001D	},
    {	NULL,	"fcos.p",	F_TYP1,		F_P,	0x001D	},

    {	NULL,	"fgetexp",	F_TYP1,		F_X,	0x001E	},
    {	NULL,	"fgetexp.b",	F_TYP1,		F_B,	0x001E	},
    {	NULL,	"fgetexp.w",	F_TYP1,		F_W,	0x001E	},
    {	NULL,	"fgetexp.l",	F_TYP1,		F_L,	0x001E	},
    {	NULL,	"fgetexp.s",	F_TYP1,		F_S,	0x001E	},
    {	NULL,	"fgetexp.d",	F_TYP1,		F_D,	0x001E	},
    {	NULL,	"fgetexp.x",	F_TYP1,		F_X,	0x001E	},
    {	NULL,	"fgetexp.p",	F_TYP1,		F_P,	0x001E	},

    {	NULL,	"fgetman",	F_TYP1,		F_X,	0x001F	},
    {	NULL,	"fgetman.b",	F_TYP1,		F_B,	0x001F	},
    {	NULL,	"fgetman.w",	F_TYP1,		F_W,	0x001F	},
    {	NULL,	"fgetman.l",	F_TYP1,		F_L,	0x001F	},
    {	NULL,	"fgetman.s",	F_TYP1,		F_S,	0x001F	},
    {	NULL,	"fgetman.d",	F_TYP1,		F_D,	0x001F	},
    {	NULL,	"fgetman.x",	F_TYP1,		F_X,	0x001F	},
    {	NULL,	"fgetman.p",	F_TYP1,		F_P,	0x001F	},

    {	NULL,	"fdiv",		F_TYP1,		F_X,	0x0020	},
    {	NULL,	"fdiv.b",	F_TYP1,		F_B,	0x0020	},
    {	NULL,	"fdiv.w",	F_TYP1,		F_W,	0x0020	},
    {	NULL,	"fdiv.l",	F_TYP1,		F_L,	0x0020	},
    {	NULL,	"fdiv.s",	F_TYP1,		F_S,	0x0020	},
    {	NULL,	"fdiv.d",	F_TYP1,		F_D,	0x0020	},
    {	NULL,	"fdiv.x",	F_TYP1,		F_X,	0x0020	},
    {	NULL,	"fdiv.p",	F_TYP1,		F_P,	0x0020	},

    {	NULL,	"fmod",		F_TYP2,		F_X,	0x0021	},
    {	NULL,	"fmod.b",	F_TYP2,		F_B,	0x0021	},
    {	NULL,	"fmod.w",	F_TYP2,		F_W,	0x0021	},
    {	NULL,	"fmod.l",	F_TYP2,		F_L,	0x0021	},
    {	NULL,	"fmod.s",	F_TYP2,		F_S,	0x0021	},
    {	NULL,	"fmod.d",	F_TYP2,		F_D,	0x0021	},
    {	NULL,	"fmod.x",	F_TYP2,		F_X,	0x0021	},
    {	NULL,	"fmod.p",	F_TYP2,		F_P,	0x0021	},

    {	NULL,	"fadd",		F_TYP2,		F_X,	0x0022	},
    {	NULL,	"fadd.b",	F_TYP2,		F_B,	0x0022	},
    {	NULL,	"fadd.w",	F_TYP2,		F_W,	0x0022	},
    {	NULL,	"fadd.l",	F_TYP2,		F_L,	0x0022	},
    {	NULL,	"fadd.s",	F_TYP2,		F_S,	0x0022	},
    {	NULL,	"fadd.d",	F_TYP2,		F_D,	0x0022	},
    {	NULL,	"fadd.x",	F_TYP2,		F_X,	0x0022	},
    {	NULL,	"fadd.p",	F_TYP2,		F_P,	0x0022	},

    {	NULL,	"fmul",		F_TYP2,		F_X,	0x0023	},
    {	NULL,	"fmul.b",	F_TYP2,		F_B,	0x0023	},
    {	NULL,	"fmul.w",	F_TYP2,		F_W,	0x0023	},
    {	NULL,	"fmul.l",	F_TYP2,		F_L,	0x0023	},
    {	NULL,	"fmul.s",	F_TYP2,		F_S,	0x0023	},
    {	NULL,	"fmul.d",	F_TYP2,		F_D,	0x0023	},
    {	NULL,	"fmul.x",	F_TYP2,		F_X,	0x0023	},
    {	NULL,	"fmul.p",	F_TYP2,		F_P,	0x0023	},

    {	NULL,	"fsgldiv",	F_TYP2,		F_X,	0x0024	},
    {	NULL,	"fsgldiv.b",	F_TYP2,		F_B,	0x0024	},
    {	NULL,	"fsgldiv.w",	F_TYP2,		F_W,	0x0024	},
    {	NULL,	"fsgldiv.l",	F_TYP2,		F_L,	0x0024	},
    {	NULL,	"fsgldiv.s",	F_TYP2,		F_S,	0x0024	},
    {	NULL,	"fsgldiv.d",	F_TYP2,		F_D,	0x0024	},
    {	NULL,	"fsgldiv.x",	F_TYP2,		F_X,	0x0024	},
    {	NULL,	"fsgldiv.p",	F_TYP2,		F_P,	0x0024	},

    {	NULL,	"frem",		F_TYP2,		F_X,	0x0025	},
    {	NULL,	"frem.b",	F_TYP2,		F_B,	0x0025	},
    {	NULL,	"frem.w",	F_TYP2,		F_W,	0x0025	},
    {	NULL,	"frem.l",	F_TYP2,		F_L,	0x0025	},
    {	NULL,	"frem.s",	F_TYP2,		F_S,	0x0025	},
    {	NULL,	"frem.d",	F_TYP2,		F_D,	0x0025	},
    {	NULL,	"frem.x",	F_TYP2,		F_X,	0x0025	},
    {	NULL,	"frem.p",	F_TYP2,		F_P,	0x0025	},

    {	NULL,	"fscale",	F_TYP2,		F_X,	0x0026	},
    {	NULL,	"fscale.b",	F_TYP2,		F_B,	0x0026	},
    {	NULL,	"fscale.w",	F_TYP2,		F_W,	0x0026	},
    {	NULL,	"fscale.l",	F_TYP2,		F_L,	0x0026	},
    {	NULL,	"fscale.s",	F_TYP2,		F_S,	0x0026	},
    {	NULL,	"fscale.d",	F_TYP2,		F_D,	0x0026	},
    {	NULL,	"fscale.x",	F_TYP2,		F_X,	0x0026	},
    {	NULL,	"fscale.p",	F_TYP2,		F_P,	0x0026	},

    {	NULL,	"fsglmul",	F_TYP2,		F_X,	0x0027	},
    {	NULL,	"fsglmul.b",	F_TYP2,		F_B,	0x0027	},
    {	NULL,	"fsglmul.w",	F_TYP2,		F_W,	0x0027	},
    {	NULL,	"fsglmul.l",	F_TYP2,		F_L,	0x0027	},
    {	NULL,	"fsglmul.s",	F_TYP2,		F_S,	0x0027	},
    {	NULL,	"fsglmul.d",	F_TYP2,		F_D,	0x0027	},
    {	NULL,	"fsglmul.x",	F_TYP2,		F_X,	0x0027	},
    {	NULL,	"fsglmul.p",	F_TYP2,		F_P,	0x0027	},

    {	NULL,	"fsub",		F_TYP2,		F_X,	0x0028	},
    {	NULL,	"fsub.b",	F_TYP2,		F_B,	0x0028	},
    {	NULL,	"fsub.w",	F_TYP2,		F_W,	0x0028	},
    {	NULL,	"fsub.l",	F_TYP2,		F_L,	0x0028	},
    {	NULL,	"fsub.s",	F_TYP2,		F_S,	0x0028	},
    {	NULL,	"fsub.d",	F_TYP2,		F_D,	0x0028	},
    {	NULL,	"fsub.x",	F_TYP2,		F_X,	0x0028	},
    {	NULL,	"fsub.p",	F_TYP2,		F_P,	0x0028	},

    {	NULL,	"fsincos",	F_SNCS,		F_X,	0x0030	},
    {	NULL,	"fsincos.b",	F_SNCS,		F_B,	0x0030	},
    {	NULL,	"fsincos.w",	F_SNCS,		F_W,	0x0030	},
    {	NULL,	"fsincos.l",	F_SNCS,		F_L,	0x0030	},
    {	NULL,	"fsincos.s",	F_SNCS,		F_S,	0x0030	},
    {	NULL,	"fsincos.d",	F_SNCS,		F_D,	0x0030	},
    {	NULL,	"fsincos.x",	F_SNCS,		F_X,	0x0030	},
    {	NULL,	"fsincos.p",	F_SNCS,		F_P,	0x0030	},

    {	NULL,	"fcmp",		F_TYP2,		F_X,	0x0038	},
    {	NULL,	"fcmp.b",	F_TYP2,		F_B,	0x0038	},
    {	NULL,	"fcmp.w",	F_TYP2,		F_W,	0x0038	},
    {	NULL,	"fcmp.l",	F_TYP2,		F_L,	0x0038	},
    {	NULL,	"fcmp.s",	F_TYP2,		F_S,	0x0038	},
    {	NULL,	"fcmp.d",	F_TYP2,		F_D,	0x0038	},
    {	NULL,	"fcmp.x",	F_TYP2,		F_X,	0x0038	},
    {	NULL,	"fcmp.p",	F_TYP2,		F_P,	0x0038	},

    {	NULL,	"ftst",		F_TST,		F_X,	0x003A	},
    {	NULL,	"ftst.b",	F_TST,		F_B,	0x003A	},
    {	NULL,	"ftst.w",	F_TST,		F_W,	0x003A	},
    {	NULL,	"ftst.l",	F_TST,		F_L,	0x003A	},
    {	NULL,	"ftst.s",	F_TST,		F_S,	0x003A	},
    {	NULL,	"ftst.d",	F_TST,		F_D,	0x003A	},
    {	NULL,	"ftst.x",	F_TST,		F_X,	0x003A	},
    {	NULL,	"ftst.p",	F_TST,		F_P,	0x003A	},

    {	NULL,	"fmovecr",	F_MVCR,		F_X,	0x0000	},
    {	NULL,	"fmovecr.x",	F_MVCR,		F_X,	0x0000	},

    {	NULL,	"fmovem",	F_MOVM,		F_A,	0x0000	},
    {	NULL,	"fmovem.l",	F_MOVM,		F_L,	0x0000	},
    {	NULL,	"fmovem.x",	F_MOVM,		F_X,	0x0000	},

    {	NULL,	"fsf",		F_SCC,		0,	0x00	},
    {	NULL,	"fseq",		F_SCC,		0,	0x01	},
    {	NULL,	"fsogt",	F_SCC,		0,	0x02	},
    {	NULL,	"fsoge",	F_SCC,		0,	0x03	},
    {	NULL,	"fsolt",	F_SCC,		0,	0x04	},
    {	NULL,	"fsole",	F_SCC,		0,	0x05	},
    {	NULL,	"fsogl",	F_SCC,		0,	0x06	},
    {	NULL,	"fsor",		F_SCC,		0,	0x07	},
    {	NULL,	"fsun",		F_SCC,		0,	0x08	},
    {	NULL,	"fsueq",	F_SCC,		0,	0x09	},
    {	NULL,	"fsugt",	F_SCC,		0,	0x0A	},
    {	NULL,	"fsuge",	F_SCC,		0,	0x0B	},
    {	NULL,	"fsult",	F_SCC,		0,	0x0C	},
    {	NULL,	"fsule",	F_SCC,		0,	0x0D	},
    {	NULL,	"fsne",		F_SCC,		0,	0x0E	},
    {	NULL,	"fst",		F_SCC,		0,	0x0F	},
    {	NULL,	"fssf",		F_SCC,		0,	0x10	},
    {	NULL,	"fsseq",	F_SCC,		0,	0x11	},
    {	NULL,	"fsgt",		F_SCC,		0,	0x12	},
    {	NULL,	"fsge",		F_SCC,		0,	0x13	},
    {	NULL,	"fslt",		F_SCC,		0,	0x14	},
    {	NULL,	"fsle",		F_SCC,		0,	0x15	},
    {	NULL,	"fsgl",		F_SCC,		0,	0x16	},
    {	NULL,	"fsgle",	F_SCC,		0,	0x17	},
    {	NULL,	"fsngle",	F_SCC,		0,	0x18	},
    {	NULL,	"fsngl",	F_SCC,		0,	0x19	},
    {	NULL,	"fsnle",	F_SCC,		0,	0x1A	},
    {	NULL,	"fsnlt",	F_SCC,		0,	0x1B	},
    {	NULL,	"fsnge",	F_SCC,		0,	0x1C	},
    {	NULL,	"fsngt",	F_SCC,		0,	0x1D	},
    {	NULL,	"fssne",	F_SCC,		0,	0x1E	},
    {	NULL,	"fsst",		F_SCC,		0,	0x1F	},

    {	NULL,	"fsf.b",	F_SCC,		0,	0x00	},
    {	NULL,	"fseq.b",	F_SCC,		0,	0x01	},
    {	NULL,	"fsogt.b",	F_SCC,		0,	0x02	},
    {	NULL,	"fsoge.b",	F_SCC,		0,	0x03	},
    {	NULL,	"fsolt.b",	F_SCC,		0,	0x04	},
    {	NULL,	"fsole.b",	F_SCC,		0,	0x05	},
    {	NULL,	"fsogl.b",	F_SCC,		0,	0x06	},
    {	NULL,	"fsor.b",	F_SCC,		0,	0x07	},
    {	NULL,	"fsun.b",	F_SCC,		0,	0x08	},
    {	NULL,	"fsueq.b",	F_SCC,		0,	0x09	},
    {	NULL,	"fsugt.b",	F_SCC,		0,	0x0A	},
    {	NULL,	"fsuge.b",	F_SCC,		0,	0x0B	},
    {	NULL,	"fsult.b",	F_SCC,		0,	0x0C	},
    {	NULL,	"fsule.b",	F_SCC,		0,	0x0D	},
    {	NULL,	"fsne.b",	F_SCC,		0,	0x0E	},
    {	NULL,	"fst.b",	F_SCC,		0,	0x0F	},
    {	NULL,	"fssf.b",	F_SCC,		0,	0x10	},
    {	NULL,	"fsseq.b",	F_SCC,		0,	0x11	},
    {	NULL,	"fsgt.b",	F_SCC,		0,	0x12	},
    {	NULL,	"fsge.b",	F_SCC,		0,	0x13	},
    {	NULL,	"fslt.b",	F_SCC,		0,	0x14	},
    {	NULL,	"fsle.b",	F_SCC,		0,	0x15	},
    {	NULL,	"fsgl.b",	F_SCC,		0,	0x16	},
    {	NULL,	"fsgle.b",	F_SCC,		0,	0x17	},
    {	NULL,	"fsngle.b",	F_SCC,		0,	0x18	},
    {	NULL,	"fsngl.b",	F_SCC,		0,	0x19	},
    {	NULL,	"fsnle.b",	F_SCC,		0,	0x1A	},
    {	NULL,	"fsnlt.b",	F_SCC,		0,	0x1B	},
    {	NULL,	"fsnge.b",	F_SCC,		0,	0x1C	},
    {	NULL,	"fsngt.b",	F_SCC,		0,	0x1D	},
    {	NULL,	"fssne.b",	F_SCC,		0,	0x1E	},
    {	NULL,	"fsst.b",	F_SCC,		0,	0x1F	},

    {	NULL,	"fdbf",		F_DCC,		0,	0x00	},
    {	NULL,	"fdbeq",	F_DCC,		0,	0x01	},
    {	NULL,	"fdbogt",	F_DCC,		0,	0x02	},
    {	NULL,	"fdboge",	F_DCC,		0,	0x03	},
    {	NULL,	"fdbolt",	F_DCC,		0,	0x04	},
    {	NULL,	"fdbole",	F_DCC,		0,	0x05	},
    {	NULL,	"fdbogl",	F_DCC,		0,	0x06	},
    {	NULL,	"fdbor",	F_DCC,		0,	0x07	},
    {	NULL,	"fdbun",	F_DCC,		0,	0x08	},
    {	NULL,	"fdbueq",	F_DCC,		0,	0x09	},
    {	NULL,	"fdbugt",	F_DCC,		0,	0x0A	},
    {	NULL,	"fdbuge",	F_DCC,		0,	0x0B	},
    {	NULL,	"fdbult",	F_DCC,		0,	0x0C	},
    {	NULL,	"fdbule",	F_DCC,		0,	0x0D	},
    {	NULL,	"fdbne",	F_DCC,		0,	0x0E	},
    {	NULL,	"fdbt",		F_DCC,		0,	0x0F	},
    {	NULL,	"fdbsf",	F_DCC,		0,	0x10	},
    {	NULL,	"fdbseq",	F_DCC,		0,	0x11	},
    {	NULL,	"fdbgt",	F_DCC,		0,	0x12	},
    {	NULL,	"fdbge",	F_DCC,		0,	0x13	},
    {	NULL,	"fdblt",	F_DCC,		0,	0x14	},
    {	NULL,	"fdble",	F_DCC,		0,	0x15	},
    {	NULL,	"fdbgl",	F_DCC,		0,	0x16	},
    {	NULL,	"fdbgle",	F_DCC,		0,	0x17	},
    {	NULL,	"fdbngle",	F_DCC,		0,	0x18	},
    {	NULL,	"fdbngl",	F_DCC,		0,	0x19	},
    {	NULL,	"fdbnle",	F_DCC,		0,	0x1A	},
    {	NULL,	"fdbnlt",	F_DCC,		0,	0x1B	},
    {	NULL,	"fdbnge",	F_DCC,		0,	0x1C	},
    {	NULL,	"fdbngt",	F_DCC,		0,	0x1D	},
    {	NULL,	"fdbsne",	F_DCC,		0,	0x1E	},
    {	NULL,	"fdbst",	F_DCC,		0,	0x1F	},

    {	NULL,	"fdbf.w",	F_DCC,		0,	0x00	},
    {	NULL,	"fdbeq.w",	F_DCC,		0,	0x01	},
    {	NULL,	"fdbogt.w",	F_DCC,		0,	0x02	},
    {	NULL,	"fdboge.w",	F_DCC,		0,	0x03	},
    {	NULL,	"fdbolt.w",	F_DCC,		0,	0x04	},
    {	NULL,	"fdbole.w",	F_DCC,		0,	0x05	},
    {	NULL,	"fdbogl.w",	F_DCC,		0,	0x06	},
    {	NULL,	"fdbor.w",	F_DCC,		0,	0x07	},
    {	NULL,	"fdbun.w",	F_DCC,		0,	0x08	},
    {	NULL,	"fdbueq.w",	F_DCC,		0,	0x09	},
    {	NULL,	"fdbugt.w",	F_DCC,		0,	0x0A	},
    {	NULL,	"fdbuge.w",	F_DCC,		0,	0x0B	},
    {	NULL,	"fdbult.w",	F_DCC,		0,	0x0C	},
    {	NULL,	"fdbule.w",	F_DCC,		0,	0x0D	},
    {	NULL,	"fdbne.w",	F_DCC,		0,	0x0E	},
    {	NULL,	"fdbt.w",	F_DCC,		0,	0x0F	},
    {	NULL,	"fdbsf.w",	F_DCC,		0,	0x10	},
    {	NULL,	"fdbseq.w",	F_DCC,		0,	0x11	},
    {	NULL,	"fdbgt.w",	F_DCC,		0,	0x12	},
    {	NULL,	"fdbge.w",	F_DCC,		0,	0x13	},
    {	NULL,	"fdblt.w",	F_DCC,		0,	0x14	},
    {	NULL,	"fdble.w",	F_DCC,		0,	0x15	},
    {	NULL,	"fdbgl.w",	F_DCC,		0,	0x16	},
    {	NULL,	"fdbgle.w",	F_DCC,		0,	0x17	},
    {	NULL,	"fdbngle.w",	F_DCC,		0,	0x18	},
    {	NULL,	"fdbngl.w",	F_DCC,		0,	0x19	},
    {	NULL,	"fdbnle.w",	F_DCC,		0,	0x1A	},
    {	NULL,	"fdbnlt.w",	F_DCC,		0,	0x1B	},
    {	NULL,	"fdbnge.w",	F_DCC,		0,	0x1C	},
    {	NULL,	"fdbngt.w",	F_DCC,		0,	0x1D	},
    {	NULL,	"fdbsne.w",	F_DCC,		0,	0x1E	},
    {	NULL,	"fdbst.w",	F_DCC,		0,	0x1F	},

    {	NULL,	"ftrapf",	F_TCC,		F_A,	0x00	},
    {	NULL,	"ftrapeq",	F_TCC,		F_A,	0x01	},
    {	NULL,	"ftrapogt",	F_TCC,		F_A,	0x02	},
    {	NULL,	"ftrapoge",	F_TCC,		F_A,	0x03	},
    {	NULL,	"ftrapolt",	F_TCC,		F_A,	0x04	},
    {	NULL,	"ftrapole",	F_TCC,		F_A,	0x05	},
    {	NULL,	"ftrapogl",	F_TCC,		F_A,	0x06	},
    {	NULL,	"ftrapor",	F_TCC,		F_A,	0x07	},
    {	NULL,	"ftrapun",	F_TCC,		F_A,	0x08	},
    {	NULL,	"ftrapueq",	F_TCC,		F_A,	0x09	},
    {	NULL,	"ftrapugt",	F_TCC,		F_A,	0x0A	},
    {	NULL,	"ftrapuge",	F_TCC,		F_A,	0x0B	},
    {	NULL,	"ftrapult",	F_TCC,		F_A,	0x0C	},
    {	NULL,	"ftrapule",	F_TCC,		F_A,	0x0D	},
    {	NULL,	"ftrapne",	F_TCC,		F_A,	0x0E	},
    {	NULL,	"ftrapt",	F_TCC,		F_A,	0x0F	},
    {	NULL,	"ftrapsf",	F_TCC,		F_A,	0x10	},
    {	NULL,	"ftrapseq",	F_TCC,		F_A,	0x11	},
    {	NULL,	"ftrapgt",	F_TCC,		F_A,	0x12	},
    {	NULL,	"ftrapge",	F_TCC,		F_A,	0x13	},
    {	NULL,	"ftraplt",	F_TCC,		F_A,	0x14	},
    {	NULL,	"ftraple",	F_TCC,		F_A,	0x15	},
    {	NULL,	"ftrapgl",	F_TCC,		F_A,	0x16	},
    {	NULL,	"ftrapgle",	F_TCC,		F_A,	0x17	},
    {	NULL,	"ftrapngle",	F_TCC,		F_A,	0x18	},
    {	NULL,	"ftrapngl",	F_TCC,		F_A,	0x19	},
    {	NULL,	"ftrapnle",	F_TCC,		F_A,	0x1A	},
    {	NULL,	"ftrapnlt",	F_TCC,		F_A,	0x1B	},
    {	NULL,	"ftrapnge",	F_TCC,		F_A,	0x1C	},
    {	NULL,	"ftrapngt",	F_TCC,		F_A,	0x1D	},
    {	NULL,	"ftrapsne",	F_TCC,		F_A,	0x1E	},
    {	NULL,	"ftrapst",	F_TCC,		F_A,	0x1F	},

    {	NULL,	"ftrapf.w",	F_TCC,		F_W,	0x00	},
    {	NULL,	"ftrapeq.w",	F_TCC,		F_W,	0x01	},
    {	NULL,	"ftrapogt.w",	F_TCC,		F_W,	0x02	},
    {	NULL,	"ftrapoge.w",	F_TCC,		F_W,	0x03	},
    {	NULL,	"ftrapolt.w",	F_TCC,		F_W,	0x04	},
    {	NULL,	"ftrapole.w",	F_TCC,		F_W,	0x05	},
    {	NULL,	"ftrapogl.w",	F_TCC,		F_W,	0x06	},
    {	NULL,	"ftrapor.w",	F_TCC,		F_W,	0x07	},
    {	NULL,	"ftrapun.w",	F_TCC,		F_W,	0x08	},
    {	NULL,	"ftrapueq.w",	F_TCC,		F_W,	0x09	},
    {	NULL,	"ftrapugt.w",	F_TCC,		F_W,	0x0A	},
    {	NULL,	"ftrapuge.w",	F_TCC,		F_W,	0x0B	},
    {	NULL,	"ftrapult.w",	F_TCC,		F_W,	0x0C	},
    {	NULL,	"ftrapule.w",	F_TCC,		F_W,	0x0D	},
    {	NULL,	"ftrapne.w",	F_TCC,		F_W,	0x0E	},
    {	NULL,	"ftrapt.w",	F_TCC,		F_W,	0x0F	},
    {	NULL,	"ftrapsf.w",	F_TCC,		F_W,	0x10	},
    {	NULL,	"ftrapseq.w",	F_TCC,		F_W,	0x11	},
    {	NULL,	"ftrapgt.w",	F_TCC,		F_W,	0x12	},
    {	NULL,	"ftrapge.w",	F_TCC,		F_W,	0x13	},
    {	NULL,	"ftraplt.w",	F_TCC,		F_W,	0x14	},
    {	NULL,	"ftraple.w",	F_TCC,		F_W,	0x15	},
    {	NULL,	"ftrapgl.w",	F_TCC,		F_W,	0x16	},
    {	NULL,	"ftrapgle.w",	F_TCC,		F_W,	0x17	},
    {	NULL,	"ftrapngle.w",	F_TCC,		F_W,	0x18	},
    {	NULL,	"ftrapngl.w",	F_TCC,		F_W,	0x19	},
    {	NULL,	"ftrapnle.w",	F_TCC,		F_W,	0x1A	},
    {	NULL,	"ftrapnlt.w",	F_TCC,		F_W,	0x1B	},
    {	NULL,	"ftrapnge.w",	F_TCC,		F_W,	0x1C	},
    {	NULL,	"ftrapngt.w",	F_TCC,		F_W,	0x1D	},
    {	NULL,	"ftrapsne.w",	F_TCC,		F_W,	0x1E	},
    {	NULL,	"ftrapst.w",	F_TCC,		F_W,	0x1F	},

    {	NULL,	"ftrapf.l",	F_TCC,		F_L,	0x00	},
    {	NULL,	"ftrapeq.l",	F_TCC,		F_L,	0x01	},
    {	NULL,	"ftrapogt.l",	F_TCC,		F_L,	0x02	},
    {	NULL,	"ftrapoge.l",	F_TCC,		F_L,	0x03	},
    {	NULL,	"ftrapolt.l",	F_TCC,		F_L,	0x04	},
    {	NULL,	"ftrapole.l",	F_TCC,		F_L,	0x05	},
    {	NULL,	"ftrapogl.l",	F_TCC,		F_L,	0x06	},
    {	NULL,	"ftrapor.l",	F_TCC,		F_L,	0x07	},
    {	NULL,	"ftrapun.l",	F_TCC,		F_L,	0x08	},
    {	NULL,	"ftrapueq.l",	F_TCC,		F_L,	0x09	},
    {	NULL,	"ftrapugt.l",	F_TCC,		F_L,	0x0A	},
    {	NULL,	"ftrapuge.l",	F_TCC,		F_L,	0x0B	},
    {	NULL,	"ftrapult.l",	F_TCC,		F_L,	0x0C	},
    {	NULL,	"ftrapule.l",	F_TCC,		F_L,	0x0D	},
    {	NULL,	"ftrapne.l",	F_TCC,		F_L,	0x0E	},
    {	NULL,	"ftrapt.l",	F_TCC,		F_L,	0x0F	},
    {	NULL,	"ftrapsf.l",	F_TCC,		F_L,	0x10	},
    {	NULL,	"ftrapseq.l",	F_TCC,		F_L,	0x11	},
    {	NULL,	"ftrapgt.l",	F_TCC,		F_L,	0x12	},
    {	NULL,	"ftrapge.l",	F_TCC,		F_L,	0x13	},
    {	NULL,	"ftraplt.l",	F_TCC,		F_L,	0x14	},
    {	NULL,	"ftraple.l",	F_TCC,		F_L,	0x15	},
    {	NULL,	"ftrapgl.l",	F_TCC,		F_L,	0x16	},
    {	NULL,	"ftrapgle.l",	F_TCC,		F_L,	0x17	},
    {	NULL,	"ftrapngle.l",	F_TCC,		F_L,	0x18	},
    {	NULL,	"ftrapngl.l",	F_TCC,		F_L,	0x19	},
    {	NULL,	"ftrapnle.l",	F_TCC,		F_L,	0x1A	},
    {	NULL,	"ftrapnlt.l",	F_TCC,		F_L,	0x1B	},
    {	NULL,	"ftrapnge.l",	F_TCC,		F_L,	0x1C	},
    {	NULL,	"ftrapngt.l",	F_TCC,		F_L,	0x1D	},
    {	NULL,	"ftrapsne.l",	F_TCC,		F_L,	0x1E	},
    {	NULL,	"ftrapst.l",	F_TCC,		F_L,	0x1F	},

    {	NULL,	"fnop",		F_NOP,		0,	0x0000	},

    {	NULL,	"fbf",		F_BCC,		F_A,	0x00	},
    {	NULL,	"fbeq",		F_BCC,		F_A,	0x01	},
    {	NULL,	"fbogt",	F_BCC,		F_A,	0x02	},
    {	NULL,	"fboge",	F_BCC,		F_A,	0x03	},
    {	NULL,	"fbolt",	F_BCC,		F_A,	0x04	},
    {	NULL,	"fbole",	F_BCC,		F_A,	0x05	},
    {	NULL,	"fboge",	F_BCC,		F_A,	0x06	},
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

    {	NULL,	"fsave",	F_SVRS,		0,	0xF100	},

    {	NULL,	"frestore",	F_SVRS,		S_EOL,	0xF140	}

};
