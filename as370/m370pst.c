/* m370pst.c */

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
#include "m370.h"

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
 *	#define		M_TRAP	0100		No Bit Positioning
 */
char	mode1[32] = {	/* R_NORM */
	'\200',	'\201',	'\202',	'\203',	'\004',	'\005',	'\006',	'\007',
	'\010',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
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
 *		int	m_flag;		Bit Swapping Flag
 *		int	m_mask;		Bit Mask
 *		int	m_mbro;		Bit Range Overflow Mask
 *	};
 */
struct	mode	mode[2] = {
    {	&mode0[0],	0,	0x0000FFFF,	0x0000FFFF	},
    {	&mode1[0],	0,	0x0000000F,	0x0000000F	}
};

/*
 * Array of Pointers to mode Structures
 */
struct	mode	*modep[16] = {
	&mode[0],	&mode[1],	NULL,		NULL,
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

	/* machine */

    {	NULL,	"and",		I_TYP1,		0,	0x13	},
    {	NULL,	"or",		I_TYP1,		0,	0x14	},
    {	NULL,	"xor",		I_TYP1,		0,	0x15	},
    {	NULL,	"btjo",		I_TYP1,		0,	0x16	},
    {	NULL,	"btjz",		I_TYP1,		0,	0x17	},

    {	NULL,	"add",		I_TYP2,		0,	0x18	},
    {	NULL,	"adc",		I_TYP2,		0,	0x19	},
    {	NULL,	"sub",		I_TYP2,		0,	0x1A	},
    {	NULL,	"sbb",		I_TYP2,		0,	0x1B	},
    {	NULL,	"mpy",		I_TYP2,		0,	0x1C	},
    {	NULL,	"cmp",		I_TYP2,		0,	0x1D	},
    {	NULL,	"dac",		I_TYP2,		0,	0x1E	},
    {	NULL,	"dsb",		I_TYP2,		0,	0x1F	},

    {	NULL,	"dec",		I_TYP3,		0,	0xB2	},
    {	NULL,	"inc",		I_TYP3,		0,	0xB3	},
    {	NULL,	"inv",		I_TYP3,		0,	0xB4	},
    {	NULL,	"clr",		I_TYP3,		0,	0xB5	},
    {	NULL,	"xchb",		I_TYP3,		0,	0xB6	},
    {	NULL,	"swap",		I_TYP3,		0,	0xB7	},
    {	NULL,	"push",		I_TYP3,		0,	0xB8	},
    {	NULL,	"pop",		I_TYP3,		0,	0xB9	},
    {	NULL,	"djnz",		I_TYP3,		0,	0xBA	},
    {	NULL,	"compl",	I_TYP3,		0,	0xBB	},
    {	NULL,	"rr",		I_TYP3,		0,	0xBC	},
    {	NULL,	"rrc",		I_TYP3,		0,	0xBD	},
    {	NULL,	"rl",		I_TYP3,		0,	0xBE	},
    {	NULL,	"rlc",		I_TYP3,		0,	0xBF	},

    {	NULL,	"mov",		I_MOV,		0,	0x12	},

    {	NULL,	"movw",		I_MOVW,		0,	0x88	},

    {	NULL,	"div",		I_DIV,		0,	0xF4F8	},

    {	NULL,	"incw",		I_INCW,		0,	0x70	},

    {	NULL,	"jmp",		I_JMP,		0,	0x00	},
    {	NULL,	"jn",		I_JMP,		0,	0x01	},
    {	NULL,	"jz",		I_JMP,		0,	0x02	},
    {	NULL,	"jc",		I_JMP,		0,	0x03	},
    {	NULL,	"jp",		I_JMP,		0,	0x04	},
    {	NULL,	"jpz",		I_JMP,		0,	0x05	},
    {	NULL,	"jnz",		I_JMP,		0,	0x06	},
    {	NULL,	"jnc",		I_JMP,		0,	0x07	},
    {	NULL,	"jv",		I_JMP,		0,	0x08	},
    {	NULL,	"jl",		I_JMP,		0,	0x09	},
    {	NULL,	"jle",		I_JMP,		0,	0x0A	},
    {	NULL,	"jhs",		I_JMP,		0,	0x0B	},
    {	NULL,	"jnv",		I_JMP,		0,	0x0C	},
    {	NULL,	"jge",		I_JMP,		0,	0x0D	},
    {	NULL,	"jg",		I_JMP,		0,	0x0E	},
    {	NULL,	"jlo",		I_JMP,		0,	0x0F	},

    {	NULL,	"jeq",		I_JMP,		0,	0x02	},
    {	NULL,	"jne",		I_JMP,		0,	0x06	},

    {	NULL,	"call",		I_CALL,		0,	0x8E	},
    {	NULL,	"br",		I_CALL,		0,	0x8C	},

    {	NULL,	"callr",	I_CALLR,	0,	0x8F	},
    {	NULL,	"jmpl",		I_CALLR,	0,	0x89	},

    {	NULL,	"trap",		I_TRAP,		0,	0xE0	},

    {	NULL,	"ldst",		I_LDST,		0,	0xF0	},

    {	NULL,	"sbit0",	I_BITS,		0,	0x03	},
    {	NULL,	"sbit1",	I_BITS,		0,	0x04	},
    {	NULL,	"cmpbit",	I_BITS,		0,	0x05	},
    {	NULL,	"jbit1",	I_BITS,		0,	0x06	},
    {	NULL,	"jbit0",	I_BITS,		0,	0x07	},

    {	NULL,	"clrc",		I_INH,		0,	0xB0	},
    {	NULL,	"tsta",		I_INH,		0,	0xB0	},
    {	NULL,	"tstb",		I_INH,		0,	0xC6	},
    {	NULL,	"idle",		I_INH,		0,	0xF6	},
    {	NULL,	"setc",		I_INH,		0,	0xF8	},
    {	NULL,	"rts",		I_INH,		0,	0xF9	},
    {	NULL,	"rti",		I_INH,		0,	0xFA	},
    {	NULL,	"ldsp",		I_INH,		0,	0xFD	},
    {	NULL,	"stsp",		I_INH,		0,	0xFE	},
    {	NULL,	"nop",		I_INH,		0,	0xFF	},

    {	NULL,	"dint",		I_INH2,		0,	0xF000	},
    {	NULL,	"eint",		I_INH2,		0,	0xF00C	},
    {	NULL,	"einth",	I_INH2,		0,	0xF004	},
    {	NULL,	"eintl",	I_INH2,		S_EOL,	0xF008	}
};
