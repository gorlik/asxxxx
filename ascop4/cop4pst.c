/* cop4pst.c */

/*
 *  Copyright (C) 2021  Alan R. Baldwin
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
#include "cop4.h"

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
 *	#define		R_2BIT	0100		--xx----
 */
char	mode1[32] = {	/* R_2BIT */
	'\204',	'\205',	'\002',	'\003',	'\004',	'\005',	'\006',	'\007',
	'\010',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

/*
 *	#define		R_4BIT	0200		----xxxx
 */
char	mode2[32] = {	/* R_4BIT */
	'\200',	'\201',	'\202',	'\203',	'\004',	'\005',	'\006',	'\007',
	'\010',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

/*
 *	#define		R_6BIT	0300		--xxxxxx
 */
char	mode3[32] = {	/* R_6BIT */
	'\200',	'\201',	'\202',	'\203',	'\204',	'\205',	'\006',	'\007',
	'\010',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

/*
 *	#define		R_7BIT	0400		-xxxxxxx
 */
char	mode4[32] = {	/* R_7BIT */
	'\200',	'\201',	'\202',	'\203',	'\204',	'\205',	'\206',	'\007',
	'\010',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

/*
 *	#define		R_8BIT	0500		xxxxxxxx
 */
char	mode5[32] = {	/* R_8BIT */
	'\200',	'\201',	'\202',	'\203',	'\204',	'\205',	'\206',	'\207',
	'\010',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

/*
 *	#define		R_9BIT	0600		-------xxxxxxxxx
 */
char	mode6[32] = {	/* R_9BIT */
	'\200',	'\201',	'\202',	'\203',	'\204',	'\205',	'\206',	'\207',
	'\210',	'\011',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

/*
 *	#define		R_10BIT	0700		------xxxxxxxxxx
 */
char	mode7[32] = {	/* R_10BIT */
	'\200',	'\201',	'\202',	'\203',	'\204',	'\205',	'\206',	'\207',
	'\210',	'\211',	'\012',	'\013',	'\014',	'\015',	'\016',	'\017',
	'\020',	'\021',	'\022',	'\023',	'\024',	'\025',	'\026',	'\027',
	'\030',	'\031',	'\032',	'\033',	'\034',	'\035',	'\036',	'\037'
};

/*
 *	#define		R_11BIT	0800		-----xxxxxxxxxxx
 */
char	mode8[32] = {	/* R_11BIT */
	'\200',	'\201',	'\202',	'\203',	'\204',	'\205',	'\206',	'\207',
	'\210',	'\211',	'\212',	'\013',	'\014',	'\015',	'\016',	'\017',
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
struct	mode	mode[9] = {
    {	&mode0[0],	0,	0x0000FFFF,	0x0000FFFF	},
    {	&mode1[0],	1,	0x00000030,	0x00000003	},
    {	&mode2[0],	0,	0x0000000F,	0x0000000F	},
    {	&mode3[0],	0,	0x0000003F,	0x0000003F	},
    {	&mode4[0],	0,	0x0000007F,	0x0000007F	},
    {	&mode5[0],	0,	0x000000FF,	0x000000FF	},
    {	&mode6[0],	0,	0x000001FF,	0x000001FF	},
    {	&mode7[0],	0,	0x000003FF,	0x000003FF	},
    {	&mode8[0],	0,	0x000007FF,	0x000007FF	}
};

/*
 * Array of Pointers to mode Structures
 */
struct	mode	*modep[16] = {
	&mode[0],	&mode[1],	&mode[2],	&mode[3],
	&mode[4],	&mode[5],	&mode[6],	&mode[7],
	&mode[8],	NULL,		NULL,		NULL,
	NULL,		NULL,		NULL,		NULL
};

/*
 * Mnemonic Structure
 */
struct	mne	mne[] = {

	/* machine */

	/* system */

    {	NULL,	"CSEG",		S_ATYP,		0,	A_CSEG|A_1BYTE	},
    {	NULL,	"DSEG",		S_ATYP,		0,	A_DSEG|A_1BYTE	},

	/* system */

    {	NULL,	"BANK",		S_ATYP,		0,	A_BNK	},
    {	NULL,	"CON",		S_ATYP,		0,	A_CON	},
    {	NULL,	"OVR",		S_ATYP,		0,	A_OVR	},
    {	NULL,	"REL",		S_ATYP,		0,	A_REL	},
    {	NULL,	"ABS",		S_ATYP,		0,	A_ABS	},
    {	NULL,	"NOPAG",	S_ATYP,		0,	A_NOPAG	},
    {	NULL,	"PAG",		S_ATYP,		0,	A_PAG	},

    {	NULL,	"BASE",		S_BTYP,		0,	B_BASE	},
    {	NULL,	"SIZE",		S_BTYP,		0,	B_SIZE	},
    {	NULL,	"FSFX",		S_BTYP,		0,	B_FSFX	},
    {	NULL,	"MAP",		S_BTYP,		0,	B_MAP	},

    {	NULL,	".page",	S_PAGE,		0,	0	},
    {	NULL,	".title",	S_HEADER,	0,	O_TITLE	},
    {	NULL,	".sbttl",	S_HEADER,	0,	O_SBTTL	},
    {	NULL,	".module",	S_MODUL,	0,	0	},
    {	NULL,	".include",	S_INCL,		0,	I_CODE	},
    {	NULL,	".incbin",	S_INCL,		0,	I_BNRY	},
    {	NULL,	".area",	S_AREA,		0,	0	},
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
/*    {	NULL,	".4byte",	S_DATA,		0,	O_4BYTE	},	*/
/*    {	NULL,	".quad",	S_DATA,		0,	O_4BYTE	},	*/
    {	NULL,	".blkb",	S_BLK,		0,	O_1BYTE	},
    {	NULL,	".ds",		S_BLK,		0,	O_1BYTE	},
    {	NULL,	".rmb",		S_BLK,		0,	O_1BYTE	},
    {	NULL,	".rs",		S_BLK,		0,	O_1BYTE	},
    {	NULL,	".blkw",	S_BLK,		0,	O_2BYTE	},
/*    {	NULL,	".blk3",	S_BLK,		0,	O_3BYTE	},	*/
/*    {	NULL,	".blk4",	S_BLK,		0,	O_4BYTE	},	*/
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

    {	NULL,	".setpg",	S_SPG,		0,	0	},
    {	NULL,	".cop",		S_COP,		0,	0	},
    {	NULL,	".rom_256",	S_ROM,		0,	S_256	},
    {	NULL,	".rom_512",	S_ROM,		0,	S_512	},
    {	NULL,	".rom_1k",	S_ROM,		0,	S_1024	},
    {	NULL,	".rom_2k",	S_ROM,		0,	S_2048	},
    {	NULL,	".xad",		S_XAD,		0,	0	},

	/* Arithmetic Instructions */

    {	NULL,	"asc",		S_INH1,		0,	0x30	},
    {	NULL,	"add",		S_INH1,		0,	0x31	},
    {	NULL,	"adt",		S_INH1,		0,	0x4A	},
    {	NULL,	"aisc",		S_IMY1,		0,	0x50	},
    {	NULL,	"casc",		S_INH1,		0,	0x10	},
    {	NULL,	"clra",		S_INH1,		0,	0x00	},
    {	NULL,	"comp",		S_INH1,		0,	0x40	},
    {	NULL,	"nop",		S_INH1,		0,	0x44	},
    {	NULL,	"or",		S_INH2,		0,	0x331A	},
    {	NULL,	"rc",		S_INH1,		0,	0x32	},
    {	NULL,	"sc",		S_INH1,		0,	0x22	},
    {	NULL,	"xor",		S_INH1,		0,	0x02	},

	/* Transfer Of Control Instructions */

    {	NULL,	"jid",		S_INH1,		0,	0xFF	},
    {	NULL,	"jmp",		S_JMP,		0,	0x6000	},
    {	NULL,	"jp",		S_JP,		0,	0xC0	},
    {	NULL,	"jp23",		S_JP23,		0,	0x80	},
    {	NULL,	"jsr",		S_JSR,		0,	0x6800	},
    {	NULL,	"jsrp",		S_JSRP,		0,	0x80	},
    {	NULL,	"ret",		S_INH1,		0,	0x48	},
    {	NULL,	"retsk",	S_INH1,		0,	0x49	},
    {	NULL,	"halt",		S_INH2,		0,	0x3338	},
    {	NULL,	"it",		S_INH2,		0,	0x3339	},

	/* Memory Reference Instructions */

    {	NULL,	"came",		S_INH2,		0,	0x331F	},
    {	NULL,	"camq",		S_INH2,		0,	0x333C	},
    {	NULL,	"camt",		S_INH2,		0,	0x333F	},
    {	NULL,	"cema",		S_INH2,		0,	0x330F	},
    {	NULL,	"cqma",		S_INH2,		0,	0x332C	},
    {	NULL,	"ctma",		S_INH2,		0,	0x332F	},
    {	NULL,	"ld",		S_RAM1,		0,	0x05	},
    {	NULL,	"ldd",		S_RAM2,		0,	0x2300	},
    {	NULL,	"lid",		S_INH2,		0,	0x3319	},
    {	NULL,	"lqid",		S_INH1,		0,	0xBF	},
    {	NULL,	"rmb",		S_RMB,		0,	0x40	},
    {	NULL,	"smb",		S_SMB,		0,	0x40	},
    {	NULL,	"stii",		S_IMY1,		0,	0x70	},
    {	NULL,	"x",		S_RAM1,		0,	0x06	},
    {	NULL,	"xad",		S_RAM2,		0,	0x2380	},
    {	NULL,	"xds",		S_RAM1,		0,	0x07	},
    {	NULL,	"xis",		S_RAM1,		0,	0x04	},

	/* Register Reference Instructions */

    {	NULL,	"cab",		S_INH1,		0,	0x50	},
    {	NULL,	"cba",		S_INH1,		0,	0x4E	},
    {	NULL,	"lbi",		S_LBI,		0,	0x3300	},
    {	NULL,	"lei",		S_IMY2,		0,	0x3360	},
    {	NULL,	"xabr",		S_INH1,		0,	0x12	},
    {	NULL,	"xan",		S_INH2,		0,	0x330B	},

	/* Test Instructions */

    {	NULL,	"skc",		S_INH1,		0,	0x20	},
    {	NULL,	"ske",		S_INH1,		0,	0x21	},
    {	NULL,	"skgz",		S_INH2,		0,	0x3321	},
    {	NULL,	"skgbz",	S_SKZ2,		0,	0x3300	},
    {	NULL,	"skmbz",	S_SKZ1,		0,	0x00	},
    {	NULL,	"sksz",		S_INH2,		0,	0x331C	},
    {	NULL,	"skt",		S_INH1,		0,	0x41	},

	/* Input/Output Instructions */

    {	NULL,	"camr",		S_INH2,		0,	0x333D	},
    {	NULL,	"ing",		S_INH2,		0,	0x332A	},
    {	NULL,	"inh",		S_INH2,		0,	0x332B	},
    {	NULL,	"inin",		S_INH2,		0,	0x3328	},
    {	NULL,	"inil",		S_INH2,		0,	0x3329	},
    {	NULL,	"inl",		S_INH2,		0,	0x332E	},
    {	NULL,	"inr",		S_INH2,		0,	0x332D	},
    {	NULL,	"obd",		S_INH2,		0,	0x333E	},
    {	NULL,	"ogi",		S_IMY2,		0,	0x3350	},
    {	NULL,	"omg",		S_INH2,		0,	0x333A	},
    {	NULL,	"omh",		S_INH2,		0,	0x333B	},
    {	NULL,	"xas",		S_INH1,		S_EOL,	0x4F	},
};

/*
 * CPU Type Table With ROM Size and Invalid Instructions
 */
struct	cop	cop[] = {
    {	"402",	I_OR   |			/* CPU ID = 1 */ 
    		I_HALT | I_IT   |
		I_CEMA | I_CAME | I_CTMA | I_CAMT | I_LID |
		I_XAN  |
		I_SKSZ |
		I_CAMR | I_INH  | I_INR | I_OMH,
		S_1024	},

    {	"404",	I_OR   |			/* CPU ID = 2 */ 
		I_CEMA | I_CAME | I_LID |
		I_XAN  |
		I_SKSZ |
		I_CAMR | I_INH  | I_INR | I_OMH,
		S_2048	},
    {	"404M",	I_OR   |			/* CPU ID = 3 */ 
		I_CEMA | I_CAME | I_LID |
		I_XAN  |
		I_SKSZ |
		I_CAMR | I_INH  | I_INR | I_OMH,
		S_2048	},

    {	"410",	I_ADT  | I_CASC | I_OR  |	/* CPU ID = 4 */ 
    		I_HALT | I_IT   |
		I_CEMA | I_CAME | I_CTMA | I_CAMT | I_CQMA | I_LDD | I_LID | I_LQID | I_XAD |
		I_XABR | I_XAN  |
		I_SKT  | I_SKSZ |
		I_CAMR | I_INH  | I_ININ | I_INIL | I_INR | I_OMH,
		S_512	},
    {	"410L",	I_ADT  | I_CASC | I_OR  |	/* CPU ID = 5 */ 
    		I_HALT | I_IT   |
		I_CEMA | I_CAME | I_CTMA | I_CAMT | I_CQMA | I_LDD | I_LID | I_LQID | I_XAD |
		I_XABR | I_XAN  |
		I_SKT  | I_SKSZ |
		I_CAMR | I_INH  | I_ININ | I_INIL | I_INR | I_OMH,
		S_512	},
    {	"410C",	I_ADT  | I_CASC | I_OR  |	/* CPU ID = 6 */ 
    		I_IT   |
		I_CEMA | I_CAME | I_CTMA | I_CAMT | I_LDD | I_LID | I_LQID | I_XAD |
		I_XABR | I_XAN  |
		I_SKT  | I_SKSZ |
		I_CAMR | I_INH  | I_ININ | I_INIL | I_INR | I_OMH,
		S_512	},

    {	"411",	I_ADT  | I_CASC | I_OR  |	/* CPU ID = 7 */ 
    		I_HALT | I_IT   |
		I_CEMA | I_CAME | I_CTMA | I_CAMT | I_CQMA | I_LDD | I_LID | I_LQID | I_XAD |
		I_XABR | I_XAN  |
		I_SKT  | I_SKSZ |
		I_CAMR | I_INH  | I_ININ | I_INIL | I_INR | I_OMH,
		S_512	},
    {	"411L",	I_ADT  | I_CASC | I_OR  |	/* CPU ID = 8 */ 
    		I_HALT | I_IT   |
		I_CEMA | I_CAME | I_CTMA | I_CAMT | I_CQMA | I_LDD | I_LID | I_LQID | I_XAD |
		I_XABR | I_XAN  |
		I_SKT  | I_SKSZ |
		I_CAMR | I_INH  | I_ININ | I_INIL | I_INR | I_OMH,
		S_512	},
    {	"411C",	I_ADT  | I_CASC | I_OR  |	/* CPU ID = 9 */ 
    		I_IT   |
		I_CEMA | I_CAME | I_CTMA | I_CAMT | I_LDD | I_LID | I_LQID | I_XAD |
		I_XABR | I_XAN  |
		I_SKT  | I_SKSZ |
		I_CAMR | I_INH  | I_ININ | I_INIL | I_INR | I_OMH,
		S_512},

    {	"413",	I_ADT  | I_CASC | I_OR  |	/* CPU ID = 10 */ 
    		I_IT   |
		I_CEMA | I_CAME | I_CTMA | I_CAMT | I_CQMA | I_LDD | I_LID | I_LQID | I_XAD |
		I_XABR | I_XAN  |
		I_SKT  | I_SKSZ |
		I_CAMR | I_INH  | I_ININ | I_INIL | I_INR | I_OMH,
		S_512	},
    {	"413C",	I_ADT  | I_CASC | I_OR  |	/* CPU ID = 11 */ 
    		I_IT   |
		I_CEMA | I_CAME | I_CTMA | I_CAMT | I_CQMA | I_LDD | I_LID | I_LQID | I_XAD |
		I_XABR | I_XAN  |
		I_SKT  | I_SKSZ |
		I_CAMR | I_INH  | I_ININ | I_INIL | I_INR | I_OMH,
		S_512	},
    {	"413CH",I_ADT  | I_CASC | I_OR  |	/* CPU ID = 12 */ 
    		I_IT   |
		I_CEMA | I_CAME | I_CTMA | I_CAMT | I_CQMA | I_LDD | I_LID | I_LQID | I_XAD |
		I_XABR | I_XAN  |
		I_SKT  | I_SKSZ |
		I_CAMR | I_INH  | I_ININ | I_INIL | I_INR | I_OMH,
		S_512	},

    {	"420",	I_OR  |				/* CPU ID = 13 */ 
    		I_HALT | I_IT   |
		I_CEMA | I_CAME | I_CTMA | I_CAMT | I_LID | I_LQID | I_XAD |
		I_XAN  |
		I_SKSZ |
		I_CAMR | I_INH  | I_INR | I_OMH,
		S_1024	},
    {	"420L",	I_OR  |				/* CPU ID = 14 */ 
    		I_HALT | I_IT   |
		I_CEMA | I_CAME | I_CTMA | I_CAMT | I_LID | I_LQID | I_XAD |
		I_XAN  |
		I_SKSZ |
		I_CAMR | I_INH  | I_INR | I_OMH,
		S_1024	},

    {	"421",	I_OR  |				/* CPU ID = 15 */ 
    		I_HALT | I_IT   |
		I_CEMA | I_CAME | I_CTMA | I_CAMT | I_LID | I_LQID | I_XAD |
		I_XAN  |
		I_SKSZ |
		I_CAMR | I_INH  | I_INR | I_OMH,
		S_1024	},
    {	"421L",	I_OR  |				/* CPU ID = 16 */ 
    		I_HALT | I_IT   |
		I_CEMA | I_CAME | I_CTMA | I_CAMT | I_LID | I_LQID | I_XAD |
		I_XAN  |
		I_SKSZ |
		I_CAMR | I_INH  | I_INR | I_OMH,
		S_1024	},

    {	"422",	I_OR  |				/* CPU ID = 17 */ 
    		I_HALT | I_IT   |
		I_CEMA | I_CAME | I_CTMA | I_CAMT | I_LID | I_LQID | I_XAD |
		I_XAN  |
		I_SKSZ |
		I_CAMR | I_INH  | I_INR | I_OMH,
		S_1024	},
    {	"422L",	I_OR  |				/* CPU ID = 18 */ 
    		I_HALT | I_IT   |
		I_CEMA | I_CAME | I_CTMA | I_CAMT | I_LID | I_LQID | I_XAD |
		I_XAN  |
		I_SKSZ |
		I_CAMR | I_INH  | I_INR | I_OMH,
		S_1024	},

    {	"424",	I_OR   |			/* CPU ID = 19 */ 
		I_CEMA | I_CAME | I_LID | I_LQID |
		I_XAN  |
		I_SKSZ |
		I_CAMR | I_INH  | I_INR | I_OMH,
		S_1024	},
    {	"424L",	I_OR   |			/* CPU ID = 20 */ 
		I_CEMA | I_CAME | I_LID | I_LQID |
		I_XAN  |
		I_SKSZ |
		I_CAMR | I_INH  | I_INR | I_OMH,
		S_1024	},

    {	"425",	I_OR   |			/* CPU ID = 21 */ 
		I_CEMA | I_CAME | I_LID | I_LQID |
		I_XAN  |
		I_SKSZ |
		I_CAMR | I_INH  | I_INR | I_OMH,
		S_1024},
    {	"425L",	I_OR   |			/* CPU ID = 22 */ 
		I_CEMA | I_CAME | I_LID | I_LQID |
		I_XAN  |
		I_SKSZ |
		I_CAMR | I_INH  | I_INR | I_OMH,
		S_1024	},

    {	"426",	I_OR   |			/* CPU ID = 23 */ 
		I_CEMA | I_CAME | I_LID | I_LQID |
		I_XAN  |
		I_SKSZ |
		I_CAMR | I_INH  | I_INR | I_OMH,
		S_1024	},
    {	"426L",	I_OR   |			/* CPU ID = 24 */ 
		I_CEMA | I_CAME | I_LID | I_LQID |
		I_XAN  |
		I_SKSZ |
		I_CAMR | I_INH  | I_INR | I_OMH,
		S_1024	},

    {	"440",	I_HALT | I_IT,			/* CPU ID = 25 */ 
		S_2048	},

    {	"441",	I_HALT | I_IT,			/* CPU ID = 26 */ 
		S_2048	},

    {	"442",	I_HALT | I_IT,			/* CPU ID = 27 */ 
		S_2048	},

    {	"2440",	I_HALT | I_IT,			/* CPU ID = 28 */ 
		S_2048	},

    {	"2441",	I_HALT | I_IT,			/* CPU ID = 29 */ 
		S_2048	},

    {	"2442",	I_HALT | I_IT,			/* CPU ID = 30 */ 
		S_2048	},

    {	"444",	I_OR  |				/* CPU ID = 31 */ 
    		I_HALT | I_IT   |
		I_CEMA | I_CAME | I_CTMA | I_CAMT | I_LID |
		I_CAMR | I_INH | I_INR | I_OMH,
		S_2048	},
    {	"444L",	I_OR  |				/* CPU ID = 32 */ 
    		I_HALT | I_IT   |
		I_CEMA | I_CAME | I_CTMA | I_CAMT | I_LID |
		I_CAMR | I_INH | I_INR | I_OMH,
		S_2048	},

    {	"445",	I_OR  |				/* CPU ID = 33 */ 
    		I_HALT | I_IT   |
		I_CEMA | I_CAME | I_CTMA | I_CAMT | I_LID |
		I_CAMR | I_INH | I_INR | I_OMH,
		S_2048	},
    {	"445L",	I_OR  |				/* CPU ID = 34 */ 
    		I_HALT | I_IT   |
		I_CEMA | I_CAME | I_CTMA | I_CAMT | I_LID |
		I_CAMR | I_INH | I_INR | I_OMH,
		S_2048	},

    {   "",	0,	0	}
};

