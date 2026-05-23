/* t90pst.c */

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

/*
 * Extensions: P. Felber
 */

#include "asxxxx.h"
#include "t90.h"

/* bank, area, and modep just copied from asz80 to make it link - wasn't there in sdastlcs90, and I have no idea what they are needed for */

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
struct	mode	mode[1] = {
    {	&mode0[0],	0,	0x0000FFFF,	0x0000FFFF	}
};

/*
 * Array of Pointers to mode Structures
 */
struct	mode	*modep[16] = {
	&mode[0],	NULL,		NULL,		NULL,
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

	/* Special */

    {	NULL,	".setdp",	S_SDP,		0,	0	},

    /* Machine */

    {	NULL,	"ld",		S_LD,		0,	0x20	},

    {	NULL,	"ldw",		S_LDW,		0,	0x3F	},

    {	NULL,	"push",		S_PUSH,		0,	0x50	},
    {	NULL,	"pop",		S_PUSH,		0,	0x58	},

    {	NULL,	"lda",		S_LDA,		0,	0x38	},

    {	NULL,	"ex",		S_EX,		0,	0x50	},
    {	NULL,	"exx",		S_INH1,		0,	0x0A	},

    {	NULL,	"ldi",		S_INH2,		0,	0x58	},
    {	NULL,	"ldir",		S_INH2,		0,	0x59	},
    {	NULL,	"ldd",		S_INH2,		0,	0x5A	},
    {	NULL,	"lddr",		S_INH2,		0,	0x5B	},
    {	NULL,	"cpi",		S_INH2,		0,	0x5C	},
    {	NULL,	"cpir",		S_INH2,		0,	0x5D	},
    {	NULL,	"cpd",		S_INH2,		0,	0x5E	},
    {	NULL,	"cpdr",		S_INH2,		0,	0x5F	},

    {	NULL,	"add",		S_TYP1,		0,	0x60	},
    {	NULL,	"adc",		S_TYP1,		0,	0x61	},
    {	NULL,	"sub",		S_TYP1,		0,	0x62	},
    {	NULL,	"sbc",		S_TYP1,		0,	0x63	},
    {	NULL,	"and",		S_TYP1,		0,	0x64	},
    {	NULL,	"xor",		S_TYP1,		0,	0x65	},
    {	NULL,	"or",		S_TYP1,		0,	0x66	},
    {	NULL,	"cp",		S_TYP1,		0,	0x67	},

    {	NULL,	"inc",		S_INC,		0,	0x87	},
    {	NULL,	"dec",		S_DEC,		0,	0x8F	},

    {	NULL,	"incx",		S_TYP2,		0,	0x07	},
    {	NULL,	"decx",		S_TYP2,		0,	0x0F	},

    {	NULL,	"daa",		S_INH1,		0,	0x0B	},
    {	NULL,	"cpl",		S_INH1,		0,	0x10	},
    {	NULL,	"neg",		S_INH1,		0,	0x11	},

    {	NULL,	"ldar",		S_LDAR,		0,	0x17	},

    {	NULL,	"rcf",		S_INH1,		0,	0x0C	},
    {	NULL,	"scf",		S_INH1,		0,	0x0D	},
    {	NULL,	"ccf",		S_INH1,		0,	0x0E	},
    {	NULL,	"nop",		S_INH1,		0,	0x00	},
    {	NULL,	"halt",		S_INH1,		0,	0x01	},
    {	NULL,	"di",		S_INH1,		0,	0x02	},
    {	NULL,	"ei",		S_INH1,		0,	0x03	},
    {	NULL,	"swi",		S_INH1,		0,	0xFF	},

    {	NULL,	"mul",		S_MLDV,		0,	0x12	}, 
    {	NULL,	"div",		S_MLDV,		0,	0x13	}, 

    {	NULL,	"rlca",		S_INH1,		0,	0xA0	},
    {	NULL,	"rrca",		S_INH1,		0,	0xA1	},
    {	NULL,	"rla",		S_INH1,		0,	0xA2	},
    {	NULL,	"rra",		S_INH1,		0,	0xA3	},
    {	NULL,	"slaa",		S_INH1,		0,	0xA4	},
    {	NULL,	"sraa",		S_INH1,		0,	0xA5	},
    {	NULL,	"slla",		S_INH1,		0,	0xA6	},
    {	NULL,	"srla",		S_INH1,		0,	0xA7	},

    {	NULL,	"rlc",		S_SHRO,		0,	0xA0	},
    {	NULL,	"rrc",		S_SHRO,		0,	0xA1	},
    {	NULL,	"rl",		S_SHRO,		0,	0xA2	},
    {	NULL,	"rr",		S_SHRO,		0,	0xA3	},
    {	NULL,	"sla",		S_SHRO,		0,	0xA4	},
    {	NULL,	"sra",		S_SHRO,		0,	0xA5	},
    {	NULL,	"sll",		S_SHRO,		0,	0xA6	},
    {	NULL,	"srl",		S_SHRO,		0,	0xA7	},

    {	NULL,	"rld",		S_RLD,		0,	0x10	},
    {	NULL,	"rrd",		S_RRD,		0,	0x11	},

    {	NULL,	"bit",		S_BIT,		0,	0xA8	},
    {	NULL,	"res",		S_RES,		0,	0xB0	},
    {	NULL,	"set",		S_SET,		0,	0xB8	},
    {	NULL,	"tset",		S_TSET,		0,	0x18	},

    {	NULL,	"incw",		S_INCW,		0,	0x97	},
    {	NULL,	"decw",		S_DECW,		0,	0x9F	},

    {	NULL,	"jp",		S_JP,		0,	0x1A	},
    {	NULL,	"call",		S_CALL,		0,	0x1C	},

    {	NULL,	"jr",		S_JR,		0,	0xC0	},
    {	NULL,	"jrl",		S_JRL,		0,	0x1B	}, 
    {	NULL,	"calr",		S_CALR,		0,	0x1D	},
 
    {	NULL,	"djnz",		S_DJNZ,		0,	0x18	},

    {	NULL,	"ret",		S_RET,		0,	0x1E	},
    {	NULL,	"reti",		S_INH1,		S_EOL,	0x1F	},
};

