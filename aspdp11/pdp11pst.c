/* pdp11pst.c */

/*
 *  Copyright (C) 2022-2026  Alan R. Baldwin
 *  Copyright (C) 2022-2026  Nick Downing
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
#include "pdp11.h"

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
 * Specification for the 3-bit mode:
 *
 *	#define		R_3BIT	0100		No Bit Positioning
 */
char mode1[32] = {	/* R_3BIT */
	'\200',	'\201',	'\202',	'\003',	'\004',	'\005',	'\006',	'\007',
	'\010',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

/*
 * Specification for the 6-bit mode:
 *
 *	#define		R_6BIT	0200		No Bit Positioning
 */
char mode2[32] = {	/* R_6BIT */
	'\200',	'\201',	'\202',	'\203',	'\204',	'\205',	'\006',	'\007',
	'\010',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

/*
 * Specification for the (8-bit >> 1) branch mode:
 *
 *	#define		R_8BIT	0x0300		Bit Positioning
 */
char mode3[32] = {	/* R_8BIT */
	'\000',	'\200',	'\201',	'\202',	'\203',	'\204',	'\205',	'\206',
	'\207',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
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
    {	&mode1[0],	0,	0x00000007,	0x00000007	},
    {	&mode2[0],	0,	0x0000003F,	0x0000003F	},
    {	&mode3[0],	1,	0x000000FF,	0x000001FE	}
};

/*
 * Array of Pointers to mode Structures
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

	/* Machine Specific Directives */

    {	NULL,	".save",	S_AREA,		0,	O_PSH	},
    {	NULL,	".restore",	S_AREA,		0,	O_POP	},
    {	NULL,	".ifdf",	S_CONDITIONAL,	0,	O_IFDEF	},
    {	NULL,	".ifndf",	S_CONDITIONAL,	0,	O_IFNDEF},
    {	NULL,	".iifdf",	S_CONDITIONAL,	0,	O_IIFDEF},
    {	NULL,	".iifndf",	S_CONDITIONAL,	0,	O_IIFNDEF},
    {	NULL,	".endc",	S_CONDITIONAL,	0,	O_ENDIF	},
    {	NULL,	".endr",	S_MACRO,	0,	O_ENDM	},

    {	NULL,	".rad50",	S_RAD50,	0,	0	},

    {	NULL,	".int32",	S_INT32,	0,	0	},
    {	NULL,	".flt16",	W_FLT16,	0,	0	},
    {	NULL,	".flt32",	S_FLT32,	0,	0	},
    {	NULL,	".flt64",	D_FLT64,	0,	0	},
    {	NULL,	".flt1",	W_FLT16,	0,	0	},
    {	NULL,	".flt2",	S_FLT32,	0,	0	},
    {	NULL,	".flt4",	D_FLT64,	0,	0	},

	/* Double Operand */

    {	NULL,	"mov",		S_DOUBLE,	0,	0010000	},
    {	NULL,	"movb",		S_DOUBLE,	0,	0110000	},
    {	NULL,	"cmp",		S_DOUBLE,	0,	0020000	},
    {	NULL,	"cmpb",		S_DOUBLE,	0,	0120000	},
    {	NULL,	"bit",		S_DOUBLE,	0,	0030000	},
    {	NULL,	"bitb",		S_DOUBLE,	0,	0130000	},
    {	NULL,	"bic",		S_DOUBLE,	0,	0040000	},
    {	NULL,	"bicb",		S_DOUBLE,	0,	0140000	},
    {	NULL,	"bis",		S_DOUBLE,	0,	0050000	},
    {	NULL,	"bisb",		S_DOUBLE,	0,	0150000	},
    {	NULL,	"add",		S_DOUBLE,	0,	0060000	},
    {	NULL,	"sub",		S_DOUBLE,	0,	0160000	},

	/* RXX Argument */

    {	NULL,	"jsr",		S_RXX,		0,	0004000	},
    {	NULL,	"xor",		S_RXX,		0,	0074000	},

	/* Single Operand */

    {	NULL,	"jmp",		S_SINGLE,	0,	0000100	},
    {	NULL,	"swab",		S_SINGLE,	0,	0000300	},
    {	NULL,	"clr",		S_SINGLE,	0,	0005000	},
    {	NULL,	"clrb",		S_SINGLE,	0,	0105000	},
    {	NULL,	"com",		S_SINGLE,	0,	0005100	},
    {	NULL,	"comb",		S_SINGLE,	0,	0105100	},
    {	NULL,	"inc",		S_SINGLE,	0,	0005200	},
    {	NULL,	"incb",		S_SINGLE,	0,	0105200	},
    {	NULL,	"dec",		S_SINGLE,	0,	0005300	},
    {	NULL,	"decb",		S_SINGLE,	0,	0105300	},
    {	NULL,	"neg",		S_SINGLE,	0,	0005400	},
    {	NULL,	"negb",		S_SINGLE,	0,	0105400	},
    {	NULL,	"adc",		S_SINGLE,	0,	0005500	},
    {	NULL,	"adcb",		S_SINGLE,	0,	0105500	},
    {	NULL,	"sbc",		S_SINGLE,	0,	0005600	},
    {	NULL,	"sbcb",		S_SINGLE,	0,	0105600	},
    {	NULL,	"tst",		S_SINGLE,	0,	0005700	},
    {	NULL,	"tstb",		S_SINGLE,	0,	0105700	},
    {	NULL,	"ror",		S_SINGLE,	0,	0006000	},
    {	NULL,	"rorb",		S_SINGLE,	0,	0106000	},
    {	NULL,	"rol",		S_SINGLE,	0,	0006100	},
    {	NULL,	"rolb",		S_SINGLE,	0,	0106100	},
    {	NULL,	"asr",		S_SINGLE,	0,	0006200	},
    {	NULL,	"asrb",		S_SINGLE,	0,	0106200	},
    {	NULL,	"asl",		S_SINGLE,	0,	0006300	},
    {	NULL,	"aslb",		S_SINGLE,	0,	0106300	},
    {	NULL,	"mtps",		S_SINGLE,	0,	0106400	},
    {	NULL,	"mfpi",		S_SINGLE,	0,	0006500	},
    {	NULL,	"mfpd",		S_SINGLE,	0,	0106500	},
    {	NULL,	"mtpi",		S_SINGLE,	0,	0006600	},
    {	NULL,	"mtpd",		S_SINGLE,	0,	0106600	},
    {	NULL,	"sxt",		S_SINGLE,	0,	0006700	},
    {	NULL,	"mfps",		S_SINGLE,	0,	0106700	},
    {	NULL,	"csm",		S_SINGLE,	0,	0007000	},
    {	NULL,	"tstset",	S_SINGLE,	0,	0007200	},
    {	NULL,	"wrtlck",	S_SINGLE,	0,	0007300	},

	/* Branch */

    {	NULL,	"br",		S_BRANCH,	0,	0000400	},
    {	NULL,	"bra",		S_BRANCH,	0,	0000400	},
    {	NULL,	"bne",		S_BRANCH,	0,	0001000	},
    {	NULL,	"beq",		S_BRANCH,	0,	0001400	},
    {	NULL,	"bge",		S_BRANCH,	0,	0002000	},
    {	NULL,	"blt",		S_BRANCH,	0,	0002400	},
    {	NULL,	"bgt",		S_BRANCH,	0,	0003000	},
    {	NULL,	"ble",		S_BRANCH,	0,	0003400	},
    {	NULL,	"bpl",		S_BRANCH,	0,	0100000	},
    {	NULL,	"bmi",		S_BRANCH,	0,	0100400	},
    {	NULL,	"bhi",		S_BRANCH,	0,	0101000	},
    {	NULL,	"blos",		S_BRANCH,	0,	0101400	},
    {	NULL,	"bvc",		S_BRANCH,	0,	0102000	},
    {	NULL,	"bvs",		S_BRANCH,	0,	0102400	},
    {	NULL,	"bhis",		S_BRANCH,	0,	0103000	},
    {	NULL,	"bcc",		S_BRANCH,	0,	0103000	},
    {	NULL,	"blo",		S_BRANCH,	0,	0103400	},
    {	NULL,	"bcs",		S_BRANCH,	0,	0103400	},
    {	NULL,	"sob",		S_SOB,		0,	0077000	},

	/* Special Operands */

    {	NULL,	"emt",		S_SWI,		0,	0104000	},
    {	NULL,	"trap",		S_SWI,		0,	0104400	},
    {	NULL,	"spl",		S_SPL,		0,	0000230	},
    {	NULL,	"rts",		S_RTS,		0,	0000200	},
    {	NULL,	"mark",		S_MARK,		0,	0006400	},

	/* Control Instructions */

    {	NULL,	"halt",		S_INH,		0,	0000000	},
    {	NULL,	"wait",		S_INH,		0,	0000001	},
    {	NULL,	"rti",		S_INH,		0,	0000002	},
    {	NULL,	"bpt",		S_INH,		0,	0000003	},
    {	NULL,	"iot",		S_INH,		0,	0000004	},
    {	NULL,	"reset",	S_INH,		0,	0000005	},
    {	NULL,	"rtt",		S_INH,		0,	0000006	},
    {	NULL,	"mfpt",		S_INH,		0,	0000007	},

	/* Flag-Setting */

    {	NULL,	"nop",		S_INH,		0,	0000240	},
    {	NULL,	"clc",		S_INH,		0,	0000241	},
    {	NULL,	"clv",		S_INH,		0,	0000242	},
    {	NULL,	"clz",		S_INH,		0,	0000244	},
    {	NULL,	"cln",		S_INH,		0,	0000250	},
    {	NULL,	"ccc",		S_INH,		0,	0000257	},
    {	NULL,	"sec",		S_INH,		0,	0000261	},
    {	NULL,	"sev",		S_INH,		0,	0000262	},
    {	NULL,	"sez",		S_INH,		0,	0000264	},
    {	NULL,	"sen",		S_INH,		0,	0000270	},
    {	NULL,	"scc",		S_INH,		0,	0000277	},

    	/* EIS Instructions */

    {	NULL,	"mul",		S_XXR,		0,	0070000	},
    {	NULL,	"div",		S_XXR,		0,	0071000	},
    {	NULL,	"ash",		S_XXR,		0,	0072000	},
    {	NULL,	"ashc",		S_XXR,		0,	0073000	},

    	/* FIS Instructions */

    {	NULL,	"fadd",		S_FIS,		0,	0075000	},
    {	NULL,	"fsub",		S_FIS,		0,	0075010	},
    {	NULL,	"fmul",		S_FIS,		0,	0075020	},
    {	NULL,	"fdiv",		S_FIS,		0,	0075030	},

	/* Floating Point Support Instructions */

    {	NULL,	"cfcc",		S_INH,		0,	0170000	},
    {	NULL,	"setf",		S_INH,		0,	0170001	},
    {	NULL,	"setd",		S_INH,		0,	0170011	},
    {	NULL,	"seti",		S_INH,		0,	0170002	},
    {	NULL,	"setl",		S_INH,		0,	0170012	},
    {	NULL,	"stfps",	S_SINGLE,	0,	0170200	},
    {	NULL,	"stst",		S_SINGLE,	0,	0170300	},
    {	NULL,	"ldfps",	S_SINGLE,	0,	0170100	},

	/* Single Precision FP11 Instructions */

    {	NULL,	"absf",		S_FXXX,		0,	0170600	},
    {	NULL,	"addf",		S_FSRCAC,	0,	0172000	},
    {	NULL,	"clrf",		S_FXXX,		0,	0170400	},
    {	NULL,	"cmpf",		S_FSRCAC,	0,	0173400	},
    {	NULL,	"divf",		S_FSRCAC,	0,	0174400	},
    {	NULL,	"ldcid",	S_SRCAC,	0,	0177000	},
    {	NULL,	"ldcif",	S_SRCAC,	0,	0177000	},
    {	NULL,	"ldcfd",	S_FSRCAC,	0,	0177400	},
    {	NULL,	"ldexp",	S_SRCAC,	0,	0176400	},
    {	NULL,	"ldf",		S_FSRCAC,	0,	0172400	},
    {	NULL,	"modf",		S_FSRCAC,	0,	0171400	},
    {	NULL,	"mulf",		S_FSRCAC,	0,	0171000	},
    {	NULL,	"negf",		S_FXXX,		0,	0170700	},
    {	NULL,	"stcdf",	S_ACFDST,	0,	0176000	},
    {	NULL,	"stcdi",	S_ACDST,	0,	0175400	},
    {	NULL,	"stf",		S_ACFDST,	0,	0174000	},
    {	NULL,	"stcfi",	S_ACDST,	0,	0175400	},
    {	NULL,	"stexp",	S_ACDST,	0,	0175000	},
    {	NULL,	"subf",		S_FSRCAC,	0,	0173000	},
    {	NULL,	"tstf",		S_FXXX,		0,	0170500	},

	/* Double Precision FP11 Instructions */

    {	NULL,	"absd",		D_FXXX,		0,	0170600	},
    {	NULL,	"addd",		D_FSRCAC,	0,	0172000	},
    {	NULL,	"clrd",		D_FXXX,		0,	0170400	},
    {	NULL,	"cmpd",		D_FSRCAC,	0,	0173400	},
    {	NULL,	"divd",		D_FSRCAC,	0,	0174400	},
    {	NULL,	"ldcdf",	D_FSRCAC,	0,	0177400	},
    {	NULL,	"ldcld",	D_SRCAC,	0,	0177000	},
    {	NULL,	"ldclf",	D_SRCAC,	0,	0177000	},
    {	NULL,	"ldd",		D_FSRCAC,	0,	0172400	},
    {	NULL,	"modd",		D_FSRCAC,	0,	0171400	},
    {	NULL,	"muld",		D_FSRCAC,	0,	0171000	},
    {	NULL,	"negd",		D_FXXX,		0,	0170700	},
    {	NULL,	"stcfd",	D_ACFDST,	0,	0176000	},
    {	NULL,	"stcfl",	D_ACDST,	0,	0175400	},
    {	NULL,	"std",		D_ACFDST,	0,	0174000	},
    {	NULL,	"stcdl",	D_ACDST,	0,	0175400	},
    {	NULL,	"subd",		D_FSRCAC,	0,	0173000	},
    {	NULL,	"tstd",		D_FXXX,		0,	0170500	},

    	/* Commercial Instruction Set (CIS) */

    {	NULL,	"addn",		S_CIS,		0,	0076050	},
    {	NULL,	"addni",	S_CIS,		0,	0076150	},
    {	NULL,	"addp",		S_CIS,		0,	0076070	},
    {	NULL,	"addpi",	S_CIS,		0,	0076170	},
    {	NULL,	"ashn",		S_CIS,		0,	0076056	},
    {	NULL,	"ashni",	S_CIS,		0,	0076156	},
    {	NULL,	"ashp",		S_CIS,		0,	0076076	},
    {	NULL,	"ashpi",	S_CIS,		0,	0076176	},
    {	NULL,	"cmpc",		S_CIS,		0,	0076044	},
    {	NULL,	"cmpci",	S_CIS,		0,	0076144	},
    {	NULL,	"cmpn",		S_CIS,		0,	0076052	},
    {	NULL,	"cmpni",	S_CIS,		0,	0076152	},
    {	NULL,	"cmpp",		S_CIS,		0,	0076072	},
    {	NULL,	"cmppi",	S_CIS,		0,	0076172	},
    {	NULL,	"cvtln",	S_CIS,		0,	0076057	},
    {	NULL,	"cvtlni",	S_CIS,		0,	0076157	},
    {	NULL,	"cvtlp",	S_CIS,		0,	0076077	},
    {	NULL,	"cvtlpi",	S_CIS,		0,	0076177	},
    {	NULL,	"cvtnl",	S_CIS,		0,	0076053	},
    {	NULL,	"cvtnli",	S_CIS,		0,	0076153	},
    {	NULL,	"cvtnp",	S_CIS,		0,	0076055	},
    {	NULL,	"cvtnpi",	S_CIS,		0,	0076155	},
    {	NULL,	"cvtpl",	S_CIS,		0,	0076073	},
    {	NULL,	"cvtpli",	S_CIS,		0,	0076173	},
    {	NULL,	"cvtpn",	S_CIS,		0,	0076054	},
    {	NULL,	"cvtpni",	S_CIS,		0,	0076154	},
    {	NULL,	"divp",		S_CIS,		0,	0076075	},
    {	NULL,	"divpi",	S_CIS,		0,	0076175	},
    {	NULL,	"locc",		S_CIS,		0,	0076040	},
    {	NULL,	"locci",	S_CIS,		0,	0076140	},
    {	NULL,	"l2dn",		S_LXDN,		0,	0076020	},
    {	NULL,	"l2d0",		S_CIS,		0,	0076020	},
    {	NULL,	"l2d1",		S_CIS,		0,	0076021	},
    {	NULL,	"l2d2",		S_CIS,		0,	0076022	},
    {	NULL,	"l2d3",		S_CIS,		0,	0076023	},
    {	NULL,	"l2d4",		S_CIS,		0,	0076024	},
    {	NULL,	"l2d5",		S_CIS,		0,	0076025	},
    {	NULL,	"l2d6",		S_CIS,		0,	0076026	},
    {	NULL,	"l2d7",		S_CIS,		0,	0076027	},
    {	NULL,	"l3dn",		S_LXDN,		0,	0076060	},
    {	NULL,	"l3d0",		S_CIS,		0,	0076060	},
    {	NULL,	"l3d1",		S_CIS,		0,	0076061	},
    {	NULL,	"l3d2",		S_CIS,		0,	0076062	},
    {	NULL,	"l3d3",		S_CIS,		0,	0076063	},
    {	NULL,	"l3d4",		S_CIS,		0,	0076064	},
    {	NULL,	"l3d5",		S_CIS,		0,	0076065	},
    {	NULL,	"l3d6",		S_CIS,		0,	0076066	},
    {	NULL,	"l3d7",		S_CIS,		0,	0076067	},
    {	NULL,	"matc",		S_CIS,		0,	0076045	},
    {	NULL,	"matci",	S_CIS,		0,	0076145	},
    {	NULL,	"movc",		S_CIS,		0,	0076030	},
    {	NULL,	"movci",	S_CIS,		0,	0076130	},
    {	NULL,	"movrc",	S_CIS,		0,	0076031	},
    {	NULL,	"movrci",	S_CIS,		0,	0076131	},
    {	NULL,	"movtc",	S_CIS,		0,	0076032	},
    {	NULL,	"movtci",	S_CIS,		0,	0076132	},
    {	NULL,	"mulp",		S_CIS,		0,	0076074	},
    {	NULL,	"mulpi",	S_CIS,		0,	0076174	},
    {	NULL,	"scanc",	S_CIS,		0,	0076042	},
    {	NULL,	"scanci",	S_CIS,		0,	0076142	},
    {	NULL,	"skpc",		S_CIS,		0,	0076041	},
    {	NULL,	"skpci",	S_CIS,		0,	0076141	},
    {	NULL,	"spanc",	S_CIS,		0,	0076043	},
    {	NULL,	"spanci",	S_CIS,		0,	0076143	},
    {	NULL,	"subn",		S_CIS,		0,	0076051	},
    {	NULL,	"subni",	S_CIS,		0,	0076151	},
    {	NULL,	"subp",		S_CIS,		0,	0076071	},
    {	NULL,	"subpi",	S_CIS,		0,	0076171	},


	/* Alternate and Additional Instructions */
	/*     From Bell Laboratories V7 Unix    */

    {	NULL,	"sys",		S_SWI,		0,	0104400	},	/* trap */

	/* Branch Instructions */

    {	NULL,	"bec",		S_BRANCH,	0,	0103000	},	/* Branch On Error Clear, C=0 */
    {	NULL,	"bes",		S_BRANCH,	0,	0103400	},	/* Branch On Error Set,   C=1 */

	/* Long Branch Instructions */

    {	NULL,	"jbr",		S_JBR,		0,	0000400	},
    {	NULL,	"jne",		S_JCOND,	0,	0001000	},
    {	NULL,	"jeq",		S_JCOND,	0,	0001400	},
    {	NULL,	"jge",		S_JCOND,	0,	0002000	},
    {	NULL,	"jlt",		S_JCOND,	0,	0002400	},
    {	NULL,	"jgt",		S_JCOND,	0,	0003000	},
    {	NULL,	"jle",		S_JCOND,	0,	0003400	},
    {	NULL,	"jpl",		S_JCOND,	0,	0100000	},
    {	NULL,	"jmi",		S_JCOND,	0,	0100400	},
    {	NULL,	"jhi",		S_JCOND,	0,	0101000	},
    {	NULL,	"jlos",		S_JCOND,	0,	0101400	},
    {	NULL,	"jvc",		S_JCOND,	0,	0102000	},
    {	NULL,	"jvs",		S_JCOND,	0,	0102400	},
    {	NULL,	"jhis",		S_JCOND,	0,	0103000	},
    {	NULL,	"jec",		S_JCOND,	0,	0103000	},
    {	NULL,	"jcc",		S_JCOND,	0,	0103000	},
    {	NULL,	"jlo",		S_JCOND,	0,	0103400	},
    {	NULL,	"jcs",		S_JCOND,	0,	0103400	},
    {	NULL,	"jes",		S_JCOND,	0,	0103400	},

	/* Alternate EIS Instructions */

    {	NULL,	"mpy",		S_XXR,		0,	0070000	},
    {	NULL,	"dvd",		S_XXR,		0,	0071000	},
    {	NULL,	"als",		S_RXX,		0,	0072000	},
    {	NULL,	"alsc",		S_RXX,		0,	0073000	},

	/* Alternate FP11 Instructoins */

    {	NULL,	"movf",		S_MOVF,		0,	0000000	},	/* ldf or stf */
    {	NULL,	"movif",	S_SRCAC,	0,	0177000	},	/* ldcif */
    {	NULL,	"movfi",	S_ACDST,	0,	0175400	},	/* stcfi */
    {	NULL,	"movof",	S_FSRCAC,	0,	0177400	},	/* ldcdf */
    {	NULL,	"movfo",	S_ACFDST,	0,	0176000	},	/* stcdf */
    {	NULL,	"movie",	S_SRCAC,	0,	0176400	},	/* ldexp */
    {	NULL,	"movei",	S_ACDST,	S_EOL,	0175000	}	/* stexp */

};

