/* ds8pst.c */

/*
 *  Copyright (C) 1998-2023  Alan R. Baldwin
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
 *   This Assember Ported by
 *	jhartman at compuserve dot com
 *	noice at noicedebugger dot com
 *
 *   Modified from i51pst.c
 *	Bill McKinnon
 *	w_mckinnon at conknet dot com
 *
 */

#include "asxxxx.h"
#include "ds8.h"

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
 * Specification for the 11-bit addressing mode:
 */
char	mode1[32] = {	/* R_J11 */
	'\200',	'\201',	'\202',	'\203',	'\204',	'\205',	'\206',	'\207',
	'\215',	'\216',	'\217',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

/*
 * Specification for the 19-bit addressing mode:
 */
char	mode2[32] = {	/* R_J19 */
	'\200',	'\201',	'\202',	'\203',	'\204',	'\205',	'\206',	'\207',
	'\210',	'\211',	'\212',	'\213',	'\214',	'\215',	'\216',	'\217',
	'\225',	'\226',	'\227',	'\023',	'\024',	'\025',	'\026',	'\027',
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
#ifdef	LONGINT
struct	mode	mode[3] = {
    {	&mode0[0],	0,	0x0000FFFFl,	0x0000FFFFl	},
    {	&mode1[0],	1,	0x0000E0FFl,	0x000007FFl	},
    {	&mode2[0],	1,	0x00E0FFFFl,	0x0007FFFFl	}
};
#else
struct	mode	mode[3] = {
    {	&mode0[0],	0,	0x0000FFFF,	0x0000FFFF	},
    {	&mode1[0],	1,	0x0000E0FF,	0x000007FF	},
    {	&mode2[0],	1,	0x00E0FFFF,	0x0007FFFF	}
};
#endif

/*
 * Array of Pointers to mode Structures
 */
struct	mode	*modep[16] = {
	&mode[0],	&mode[1],	&mode[2],	NULL,
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
    {	NULL,	".16bit",	S_BITS,		0,	O_2BYTE	},
    {	NULL,	".24bit",	S_BITS,		0,	O_3BYTE	},
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

    {	NULL,	".amode",	S_AMODE,	0,	0	},

    {	NULL,	".cpu",		S_CPU,		0,	DS______	},
    {	NULL,	".DS8XCXXX",	S_CPU,		0,	DS8XCXXX	},
    {	NULL,	".DS80C310",	S_CPU,		0,	DS80C310	},
    {	NULL,	".DS80C320",	S_CPU,		0,	DS80C320	},
    {	NULL,	".DS80C323",	S_CPU,		0,	DS80C323	},
    {	NULL,	".DS80C390",	S_CPU,		0,	DS80C390	},
    {	NULL,	".DS83C520",	S_CPU,		0,	DS83C520	},
    {	NULL,	".DS83C530",	S_CPU,		0,	DS83C530	},
    {	NULL,	".DS83C550",	S_CPU,		0,	DS83C550	},
    {	NULL,	".DS87C520",	S_CPU,		0,	DS87C520	},
    {	NULL,	".DS87C530",	S_CPU,		0,	DS87C530	},
    {	NULL,	".DS87C550",	S_CPU,		0,	DS87C550	},

    {	NULL,	"a",		S_A,		0,	A	},
    {	NULL,	"ab",		S_AB,		0,	0	},
    {	NULL,	"dptr",		S_DPTR,		0,	DPTR	},
    {	NULL,	"pc",		S_PC,		0,	PC	},
    {	NULL,	"r0",		S_REG,		0,	R0	},
    {	NULL,	"r1",		S_REG,		0,	R1	},
    {	NULL,	"r2",		S_REG,		0,	R2	},
    {	NULL,	"r3",		S_REG,		0,	R3	},
    {	NULL,	"r4",		S_REG,		0,	R4	},
    {	NULL,	"r5",		S_REG,		0,	R5	},
    {	NULL,	"r6",		S_REG,		0,	R6	},
    {	NULL,	"r7",		S_REG,		0,	R7	},

    {	NULL,	"nop",		S_INH,		0,	0x00	},
    {	NULL,	"ret",		S_INH,		0,	0x22	},
    {	NULL,	"reti",		S_INH,		0,	0x32	},

    {	NULL,	"ajmp",		S_JMP11,	0,	0x01	},
    {	NULL,	"acall",	S_JMP11,	0,	0x11	},
    {	NULL,	"ljmp",		S_JMP16,	0,	0x02	},
    {	NULL,	"lcall",	S_JMP16,	0,	0x12	},

    {	NULL,	"rr",		S_ACC,		0,	0x03	},
    {	NULL,	"rrc",		S_ACC,		0,	0x13	},
    {	NULL,	"rl",		S_ACC,		0,	0x23	},
    {	NULL,	"rlc",		S_ACC,		0,	0x33	},
    {	NULL,	"swap",		S_ACC,		0,	0xC4	},
    {	NULL,	"da",		S_ACC,		0,	0xD4	},

    {	NULL,	"inc",		S_TYP1,		0,	0x00	},
    {	NULL,	"dec",		S_TYP1,		0,	0x10	},

    {	NULL,	"add",		S_TYP2,		0,	0x20	},
    {	NULL,	"addc",		S_TYP2,		0,	0x30	},
    {	NULL,	"subb",		S_TYP2,		0,	0x90	},

    {	NULL,	"orl",		S_TYP3,		0,	0x40	},
    {	NULL,	"anl",		S_TYP3,		0,	0x50	},
    {	NULL,	"xrl",		S_TYP3,		0,	0x60	},

    {	NULL,	"xch",		S_TYP4,		0,	0xC0	},

    {	NULL,	"mov",		S_MOV,		0,	0x00	},

    {	NULL,	"jbc",		S_BITBR,	0,	0x10	},
    {	NULL,	"jb",		S_BITBR,	0,	0x20	},
    {	NULL,	"jnb",		S_BITBR,	0,	0x30	},

    {	NULL,	"jc",		S_BR,		0,	0x40	},
    {	NULL,	"jnc",		S_BR,		0,	0x50	},
    {	NULL,	"jz",		S_BR,		0,	0x60	},
    {	NULL,	"jnz",		S_BR,		0,	0x70	},
    {	NULL,	"sjmp",		S_BR,		0,	0x80	},

    {	NULL,	"cjne",		S_CJNE,		0,	0xB0	},
    {	NULL,	"djnz",		S_DJNZ,		0,	0xD0	},
    {	NULL,	"jmp",		S_JMP,		0,	0x73	},
    {	NULL,	"movc",		S_MOVC,		0,	0x83	},
    {	NULL,	"movx",		S_MOVX,		0,	0x00	},
    {	NULL,	"div",		S_AB,		0,	0x84	},
    {	NULL,	"mul",		S_AB,		0,	0xA4	},
    {	NULL,	"clr",		S_ACBIT,	0,	0xC2	},
    {	NULL,	"cpl",		S_ACBIT,	0,	0xB2	},
    {	NULL,	"setb",		S_SETB,		0,	0xD2	},
    {	NULL,	"push",		S_DIRECT,	0,	0xC0	},
    {	NULL,	"pop",		S_DIRECT,	0,	0xD0	},
    {	NULL,	"xchd",		S_XCHD,		S_EOL,	0xD6	}
};



