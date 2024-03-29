/* i48pst.c */

/*
 *  Copyright (C) 2009-2023  Alan R. Baldwin
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
#include "i8048.h"

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
 * Basic Relocation Mode Definitions
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
 * Specification for the 8-bit 8048 addressing mode:
 */
char mode1[32] = {	/* R_J8 */
	'\200',	'\201',	'\202',	'\203',	'\204',	'\205',	'\206',	'\207',
	'\010',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

/*
 * Additional Relocation Mode Definitions
 *
 * Specification for the 11-bit 8048 addressing mode:
 */
char mode2[32] = {	/* R_J11 */
	'\200',	'\201',	'\202',	'\203',	'\204',	'\205',	'\206',	'\207',
	'\215',	'\216',	'\217',	'\013',	'\014',	'\015',	'\016',	'\017',
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
struct	mode	mode[3] = {
    {	&mode0[0],	0,	0x0000FFFF,	0x0000FFFF	},
    {	&mode1[0],	0,	0x000000FF,	0x000000FF	},
    {	&mode2[0],	1,	0x0000E0FF,	0x000007FF	}
};

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

	/* Machines */

    {	NULL,	".8048",	S_CPU,		0,	X_8048	},
    {	NULL,	".8041",	S_CPU,		0,	X_8041	},
    {	NULL,	".8022",	S_CPU,		0,	X_8022	},
    {	NULL,	".8021",	S_CPU,		0,	X_8021	},

	/* Instructions */

    {	NULL,	"add",		S_ARL1,		0,	0x03	},
    {	NULL,	"addc",		S_ARL1,		0,	0x13	},
    {	NULL,	"xrl",		S_ARL1,		0,	0xD3	},

    {	NULL,	"anl",		S_ARL2,		0,	0x53	},
    {	NULL,	"orl",		S_ARL2,		0,	0x43	},

    {	NULL,	"anld",		S_ARL3,		0,	0x9C	},
    {	NULL,	"orld",		S_ARL3,		0,	0x8C	},

    {	NULL,	"xch",		S_XCH,		0,	0x20	},
    {	NULL,	"xchd",		S_XCHD,		0,	0x30	},

    {	NULL,	"dec",		S_DEC,		0,	0x07	},
    {	NULL,	"inc",		S_INC,		0,	0x17	},

    {	NULL,	"clr",		S_CLR,		0,	0x27	},
    {	NULL,	"cpl",		S_CLR,		0,	0x37	},

    {	NULL,	"da",		S_ACC,		0,	0x57	},
    {	NULL,	"rad",		S_ACC,		0,	0x80	},
    {	NULL,	"rr",		S_ACC,		0,	0x77	},
    {	NULL,	"rrc",		S_ACC,		0,	0x67	},
    {	NULL,	"rl",		S_ACC,		0,	0xE7	},
    {	NULL,	"rlc",		S_ACC,		0,	0xF7	},
    {	NULL,	"swap",		S_ACC,		0,	0x47	},

    {	NULL,	"mov",		S_MOV,		0,	0x23	},
    {	NULL,	"movd",		S_MOVD,		0,	0x0C	},
    {	NULL,	"movp",		S_MOVP,		0,	0xA3	},
    {	NULL,	"movp3",	S_MOVP3,	0,	0xE3	},
    {	NULL,	"movx",		S_MOVX,		0,	0x80	},

    {	NULL,	"call",		S_JMP11,	0,	0x14	},
    {	NULL,	"jmp",		S_JMP11,	0,	0x04	},

    {	NULL,	"jmpp",		S_JMPP,		0,	0xB3	},

    {	NULL,	"jb0",		S_BITBR,	0,	0x12	},
    {	NULL,	"jb1",		S_BITBR,	0,	0x32	},
    {	NULL,	"jb2",		S_BITBR,	0,	0x52	},
    {	NULL,	"jb3",		S_BITBR,	0,	0x72	},
    {	NULL,	"jb4",		S_BITBR,	0,	0x92	},
    {	NULL,	"jb5",		S_BITBR,	0,	0xB2	},
    {	NULL,	"jb6",		S_BITBR,	0,	0xD2	},
    {	NULL,	"jb7",		S_BITBR,	0,	0xF2	},

    {	NULL,	"jc",		S_BR,		0,	0xF6	},
    {	NULL,	"jnc",		S_BR,		0,	0xE6	},
    {	NULL,	"jz",		S_BR,		0,	0xC6	},
    {	NULL,	"jnz",		S_BR,		0,	0x96	},
    {	NULL,	"jf0",		S_BR,		0,	0xB6	},
    {	NULL,	"jf1",		S_BR,		0,	0x76	},
    {	NULL,	"jni",		S_BR,		0,	0x86	},
    {	NULL,	"jnibf",	S_BR,		0,	0xD6	},
    {	NULL,	"jnt0",		S_BR,		0,	0x26	},
    {	NULL,	"jnt1",		S_BR,		0,	0x46	},
    {	NULL,	"jobf",		S_BR,		0,	0x86	},
    {	NULL,	"jtf",		S_BR,		0,	0x16	},
    {	NULL,	"jt0",		S_BR,		0,	0x36	},
    {	NULL,	"jt1",		S_BR,		0,	0x56	},

    {	NULL,	"djnz",		S_DJNZ,		0,	0xE8	},

    {	NULL,	"nop",		S_INH,		0,	0x00	},
    {	NULL,	"ret",		S_INH,		0,	0x83	},
    {	NULL,	"retr",		S_INH,		0,	0x93	},

    {	NULL,	"dis",		S_DIS,		0,	0x15	},
    {	NULL,	"en",		S_DIS,		0,	0x05	},

    {	NULL,	"in",		S_IN,		0,	0x08	},
    {	NULL,	"ins",		S_INS,		0,	0x08	},

    {	NULL,	"out",		S_OUT,		0,	0x02	},
    {	NULL,	"outl",		S_OUTL,		0,	0x02	},

    {	NULL,	"ent0",		S_ENT0,		0,	0x75	},

    {	NULL,	"strt",		S_STRT,		0,	0x45	},
    {	NULL,	"stop",		S_STOP,		0,	0x65	},

    {	NULL,	"sel",		S_SEL,		S_EOL,	0xC5	}
};


