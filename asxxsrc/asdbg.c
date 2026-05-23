/* asdbg.c */

/*
 *  Copyright (C) 2003-2026  Alan R. Baldwin
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
 *
 * NoICE ode extracted from asnoice.c
 * written by:
 *	John L. Hartman	(JLH)
 *	3-Nov-1997
 */

#include "asxxxx.h"

/*)Module	asdbg.c
 *
 *	The module asdbg.c contains the functions that
 *	are useful for program debugging.
 *
 *	ASxxxx structure printing functions:
 *
 *		void	prntexpr()		prints an expression
 *						structure to the console
 *		void	prntsym()		prints a symbol
 *						structure to the console
 *		void	prnttsym()		prints a temporary symbol
 *						structure to the console
 *		void	prntarea()		prints an area
 *						structure to the console
 *		void	prntbank()		prints a bank
 *						structure to the console
 *
 *		void	DefineSDCC_Line()	show line from SDCC compiler
 *		void	DefineNoICE_Line()	debug line for NoICE
 *		char *	BaseFileName()		Base File Name for Noice
 *
 *	Static variables:
 *
 *		int	prevFile
 *		char	baseName[FILSPC]
 *
 *	    used by the BaseFileName function.
 *
 * NOTE:
 *	SDCC and NoICE functions know nothing about
 *	'include' files and do not track their inclusion.
 */

/*
 * Debug Structure Printing
 */

#define	EXPR_PRINT	0

/*)Function	void	prntexpr(esp, flg)
 *
 *		struct expr *	esp	pointer to expr structure
 *		int		flg	flag to print other structures
 *
 *			1 - symbol	or values to combine printing
 *			2 - area
 *			4 - bank
 *
 *	The function prntexpr() prints the contents
 *	of an expr structure to the console.
 *
 *	local variables:
 *		char *		p	string pointer
 *
 *	global variables:
 *		none
 *
 *	functions called:
 *		int	fprintf()	c_library
 *
 *	side effects:
 *		none
 *
 *
 *	The expr structure is used to return the evaluation
 *	of an expression.  The structure supports three valid
 *	cases:
 *	(1)	The expression evaluates to a constant,
 *		mode = S_USER, flag = 0, addr contains the
 *		constant, and base = NULL.
 *	(2)	The expression evaluates to a defined symbol
 *		plus or minus a constant, mode = S_USER,
 *		flag = 0, addr contains the constant, and
 *		base = pointer to area symbol.
 *	(3)	The expression evaluates to an external
 *		global symbol plus or minus a constant,
 *		mode = S_NEW, flag = 1, addr contains the
 *		constant, and base = pointer to symbol.
 *
 *	struct	expr
 *	{
 *		char	e_mode;			Address mode
 *		char	e_flag;			Symbol flag
 *		a_uint	e_addr;			Address
 *		union	{
 *	 		struct area *e_ap;	Area Reference
 *			struct sym  *e_sp;	Symbol Reference
 *		} e_base;			Rel. base
 *		char	e_rlcf;			Rel. flags
 *		char	e_inhbt;		Inhibit 0[BOQDHX]
 *	};
 *
 *
 *	Relocation flags
 *
 *	   7     6     5     4     3     2     1     0
 *	+-----+-----+-----+-----+-----+-----+-----+-----+
 *	| SYM | PCR | PAGn| PAG0| USGN| SGND| BYT1| BYT0|
 *	+-----+-----+-----+-----+-----+-----+-----+-----+
 *
 *	R_BYTE	0x0000		8 bit
 *	R_WORD	0x0001		16 bit
 *	R_3BYTE 0x0002		3 Byte
 *	R_4BYTE 0x0003		4 Byte
 *
 *	R_SGND	0x0004		Signed
 *	R_USGN	0x0008		Unsigned
 *	R_OVRF	0x0008		Overflow
 *
 *	R_MBRS	0x0004		Merge Bit Range Signed
 *	R_MBRU	0x0008		Merge Bit Range Unsigned
 *	R_MBRO	0x0008		Merge Bit Range Overflow
 *
 *	R_LSB	0x0000		LSB
 *	R_MSB	0x000C		MSB
 *
 *	R_AREA	0x0000		Base type
 *	R_SYM	0x0080
 *
 *	R_NOPAG	0x0000		Page Mode
 *	R_PBITS	0x003C		Paging Bits
 *	R_PAGE	0x0030		Paged Addressing
 *	R_PAG0	0x0010		Page '0'    .setdp
 *	R_PAGN	0x0020		Page 'nnn'  .setdp
 *	R_PAGX	0x0030		Page 'x', Extended Relocation Mode
 *	R_PAGX0	0x0030		Page 'x', Definition 0
 *	R_PAGX1	0x0034		Page 'x', Definition 1
 *	R_PAGX2	0x0038		Page 'x', Definition 2
 *	R_PAGX3	0x003C		Page 'x', Definition 3
 *
 *	R_PCR	0x0040		PC adjust (default)   
 *	R_PCRN	0x0050		PC adjust (default) no range check
 *
 *	R_PCR0	0x0054		PC adjust (offset = 0)
 *	R_PCR1	0x0060		PC adjust (offset = 1)
 *	R_PCR2	0x0064		PC adjust (offset = 2)
 *	R_PCR3	0x0068		PC adjust (offset = 3)
 *	R_PCR4	0x006C		PC adjust (offset = 4)
 *
 *	R_PCR0N	0x0058		PC adjust (offset = 0) no range check
 *	R_PCR1N	0x0070		PC adjust (offset = 1) no range check
 *	R_PCR2N	0x0074		PC adjust (offset = 2) no range check
 *	R_PCR3N	0x0078		PC adjust (offset = 3) no range check
 *	R_PCR4N	0x007C		PC adjust (offset = 4) no range check
 *
 */

#if EXPR_PRINT	/* Conditionally Compile Expression Structure Print Function */

void
prntexpr(struct expr *esp, int flg)
{
 	struct sym *sp;
	struct area *ap;
	struct bank *bp;
 	char *p;

	sp = NULL;
	ap = NULL;
	bp = NULL;

  	if (esp == NULL) {
		fprintf(stdout, "prntexpr - NULL Argument\n");
		return;
	}

	if (flg) fprintf(stdout, "BGN - prntexpr(%d)\n", flg);

	fprintf(stdout, "struct expr {\n");
/**/	fprintf(stdout, "\tchar\te_mode\t\t= 0x%02X", esp->e_mode);
	switch(esp->e_mode) {
	case S_USER:	fprintf(stdout, "\t(USER)\n");	break;
	case S_NEW:	fprintf(stdout, "\t(NEW)\n");	break;
	default:	fprintf(stdout, "\n");		break;
	}
/**/ 	fprintf(stdout, "\tchar\te_flag\t\t= 0x%02X", esp->e_flag);
	if ((esp->e_flag != 0) && (esp->e_base.e_sp != NULL)) {
		fprintf(stdout, "\t(SYMBOL)\n");
	} else
	if ((esp->e_flag == 0) && (esp->e_base.e_ap != NULL)) {
		fprintf(stdout, "\t(Area)\n");
	} else {
		fprintf(stdout, "\n");
	}
/**/	fprintf(stdout, "\ta_uint\te_addr\t\t= 0x%08X\n", esp->e_addr);
/**/	fprintf(stdout, "\tunion\t{\n");
	if (esp->e_flag) {
		fprintf(stdout, "\t    struct sym  *e_sp\t= ");
		if (esp->e_base.e_sp != NULL) {
			fprintf(stdout, "%p\n", (void *) esp->e_base.e_sp);
			fprintf(stdout, "\t\t      [->s_id]\t= %s\n", esp->e_base.e_sp->s_id);
		} else {
			fprintf(stdout, "NULL\n");
		}
	} else {
		fprintf(stdout, "\t    struct area *e_ap\t= ");
		if (esp->e_base.e_ap != NULL) {
			fprintf(stdout, "%p\n", (void *) esp->e_base.e_ap);
			fprintf(stdout, "\t\t      [->a_id]\t= %s\n", esp->e_base.e_ap->a_id);
		} else {
			fprintf(stdout, "NULL\n");
		}
	}
	fprintf(stdout, "\t} e_base\n");
/**/	fprintf(stdout, "\tchar\te_rlcf\t\t= 0x%02X\t(", esp->e_rlcf);
	switch(esp->e_rlcf & 0x03) {
	default:
	case R_1BYTE:	p = "BYTE";	break;
	case R_2BYTE:	p = "WORD";	break;
	case R_3BYTE:	p = "3 BYTES";	break;
	case R_4BYTE:	p = "4 BYTES";	break;
	}
	fprintf(stdout, "%s", p);
	if ((esp->e_rlcf & 0x70) == 0) {
		switch(esp->e_rlcf & 0x0C) {
		default:
		case R_LSB:	p = ", LSB";	break;
		case R_SGND:	p = ", SGND/MBRS";	break;
		case R_USGN:	p = ", USGN/OVRF/MBRU/MBRO";	break;
		case R_MSB:	p = ", MSB";	break;
		}
	} else {
		switch(esp->e_rlcf & 0x70) {
		default:
		case R_NOPAG:	p = ", NOPAGE";	break;
		case R_PAG0:	p = ", PAG0";	break;
		case R_PAGN:	p = ", PAGN";	break;
		case R_PAGX0:	p = ", PAGX0/PAGX";	break;
		case R_PAGX1:	p = ", PAGX1";	break;
		case R_PAGX2:	p = ", PAGX2";	break;
		case R_PAGX3:	p = ", PAGX3";	break;
		case R_PCR:	p = ", PCR";	break;
		case R_PCRN:	p = ", PCRN";	break;
		case R_PCR0:	p = ", PCR0";	break;
		case R_PCR1:	p = ", PCR1";	break;
		case R_PCR2:	p = ", PCR2";	break;
		case R_PCR3:	p = ", PCR3";	break;
		case R_PCR4:	p = ", PCR4";	break;
		case R_PCR0N:	p = ", PCR0N";	break;
		case R_PCR1N:	p = ", PCR1N";	break;
		case R_PCR2N:	p = ", PCR2N";	break;
		case R_PCR3N:	p = ", PCR3N";	break;
		case R_PCR4N:	p = ", PCR4N";	break;
		}
	}
	fprintf(stdout, "%s", p);
	switch(esp->e_rlcf & 0x80) {
	default:
	case R_SYM:	p = ", SYM";	break;
	case R_AREA:	p = ", AREA";	break;
	}
	fprintf(stdout, "%s)\n", p);
/**/	fprintf(stdout, "\tchar\te_inhbt\t\t= 0x%02X\n", esp->e_inhbt);
	fprintf(stdout, "}\n");

	/*
	 * Print Other Structures
	 */
	if (esp->e_flag == 1) {
		sp = esp->e_base.e_sp;
		if (sp != NULL)
			if (flg & 1) prntsym(sp);
	} else {
		ap = esp->e_base.e_ap;
		if (ap != NULL) {
			if (flg & 2) prntarea(ap);
			bp = ap->b_bp;
			if (bp != NULL)
				if (flg & 4) prntbank(bp);
		}
	}

	if (flg) fprintf(stdout, "END - prntexpr(%d)\n", flg);
}

/*)Function	void	prntsym(sp)
 *
 *		struct sym *	sp	pointer to sym structure
 *
 *	The function prntsym() prints the contents
 *	of a sym structure to the console.  If there
 *	are temporary symbols associated with this
 *	symbol then those structures are also printed.
 *
 *	local variables:
 *		int	i	flag counter
 *
 *	global variables:
 *		none
 *
 *	functions called:
 *		int	fprintf()	c_library
 *
 *	side effects:
 *		none
 *
 *
 *	The sym structure is a linked list of symbols defined
 *	in the assembler source files.  The first symbol is "."
 *	defined here.  The entry 'struct tsym *s_tsym'
 *	links any temporary symbols following this symbol and
 *	preceeding the next normal symbol.  The structure also
 *	contains the symbol's name, type (USER or NEW), flag
 *	(global, assigned, and multiply defined), a pointer
 *	to the area structure defining where the symbol is
 *	located, a reference number assigned by outgsd() in
 *	asout.c, and the symbols address relative to the base
 *	address of the area where the symbol is located.
 *
 *	struct	sym
 *	{
 *		struct	sym  *s_sp;	Hash link
 *		struct	tsym *s_tsym;	Temporary symbol link
 *		char	*s_id;		Symbol (JLH)
 *		char	s_type;		Symbol subtype
 *		char	s_flag;		Symbol flags
 *		struct	area *s_area;	Area line, 0 if absolute
 *		int	s_ref;		Ref. number
 *		a_uint	s_addr;		Address
 *		a_uint	p_addr;		Previous Pass Address
 *		char	*s_expr;	Expression to evaluate
 *		int	s_eidx;		Expression index
 *	};
 *
 *	Symbol Flags
 *
 *	S_LCL		001	Local Variable
 *	S_GBL		002	Global Variable
 *	S_ASG		004	Assigned Value
 *	S_MDF		010	Multiple Definition
 *	S_SWX		020	Symbol With Expression
 *	S_HID		040	Symbol Hidden
 *
 */

void
prntsym(struct sym *sp)
{
 	int i;

 	if (sp == NULL) {
		fprintf(stdout, "prntsym - NULL Argument\n");
		return;
	}

 	fprintf(stdout, "struct sym {\n");
/**/	fprintf(stdout, "\tstruct sym *s_sp\t= ");
	if (sp->s_sp != NULL) {
		fprintf(stdout, "%p\n", (void *) sp->s_sp);
	} else {
		fprintf(stdout, "NULL\n");
	}
/**/	fprintf(stdout, "\tstruct sym *s_tsym\t= ");
	if (sp->s_tsym != NULL) {
		fprintf(stdout, "%p\n", (void *) sp->s_tsym);
	} else {
		fprintf(stdout, "NULL\n");
	}
/**/	fprintf(stdout, "\tchar\t*s_id\t\t= ");
	if (sp->s_id != NULL) {
		fprintf(stdout, "%p\n", (void *) sp->s_id);
		fprintf(stdout, "\t       [*s_id]\t\t= %s\n", sp->s_id);
	} else {
		fprintf(stdout, "NULL\n");
	}
/**/	fprintf(stdout, "\tchar\ts_type\t\t= 0x%02X\t", sp->s_type);
	fprintf(stdout, "(%s)\n", sp->s_type ? "USER" : "NEW");
/**/ 	fprintf(stdout, "\tchar\ts_flag\t\t= 0x%02X", sp->s_flag);
	if (sp->s_flag) {
		i = 0;
		fprintf(stdout, "\t(");
		if (sp->s_flag & S_LCL)	{ fprintf(stdout, "LCL"); i++; }
		if (sp->s_flag & S_GBL)	{ fprintf(stdout, "%s%s", i++ ? ", " : "", "GBL"); }
		if (sp->s_flag & S_ASG)	{ fprintf(stdout, "%s%s", i++ ? ", " : "", "ASG"); }
		if (sp->s_flag & S_MDF)	{ fprintf(stdout, "%s%s", i++ ? ", " : "", "MDF"); }
		if (sp->s_flag & S_SWX)	{ fprintf(stdout, "%s%s", i++ ? ", " : "", "SWX"); }
		if (sp->s_flag & S_HID)	 {fprintf(stdout, "%s%s", i++ ? ", " : "", "HID"); }
		fprintf(stdout, ")");
	}
	fprintf(stdout, "\n");
/**/    fprintf(stdout, "\tstruct area *s_area\t= ");
	if (sp->s_area != NULL) {
		fprintf(stdout, "%p\n", (void *) sp->s_area);
		fprintf(stdout, "\t      [->a_id]\t\t= %s\n", sp->s_area->a_id);
	} else {
		fprintf(stdout, "NULL\n");
	}
/**/	fprintf(stdout, "\tint\ts_ref\t\t= 0x%08X\n", sp->s_ref);
/**/	fprintf(stdout, "\ta_uint\ts_addr\t\t= 0x%08X\n", sp->s_addr);
/**/	fprintf(stdout, "\ta_uint\tp_addr\t\t= 0x%08X\n", sp->p_addr);
/**/    fprintf(stdout, "\tchar\t*s_expr\t\t= ");
	if (sp->s_expr != NULL) {
		fprintf(stdout, "%p\n", (void *) sp->s_expr);
		fprintf(stdout, "\t       [*s_expr]\t= %s\n", sp->s_expr);
	} else {
		fprintf(stdout, "NULL\n");
	}
	fprintf(stdout, "}\n");

	prnttsym(sp);
}

/*)Function	void	prnttsym(sp)
 *
 *		struct sym *	sp	pointer to sym structure
 *
 *	The function prntsym() prints the contents
 *	of a tsym structure to the console.
 *
 *	local variables:
 *		struct tsym *	tp	pointer to tsym structure
 *
 *	global variables:
 *		none
 *
 *	functions called:
 *		int	fprintf()	c_library
 *
 *	side effects:
 *		none
 *
 *
 *	The tsym structure is a linked list of temporary
 *	symbols defined in the assembler source files following
 *	a normal symbol.  The structure contains the temporary
 *	symbols number, a flag (multiply defined), a pointer to the
 *	area structure defining where the temporary structure
 *	is located, and the temporary symbol's address relative
 *	to the base address of the area where the symbol
 *	is located.
 *
 *	struct	tsym
 *	{
 *		struct	tsym *t_lnk;	Link to next
 *		a_uint	t_num;		0-65535$      for a 16-bit int
 *					0-4294967295$ for a 32-bit int
 *		int	t_flg;		flags
 *		struct	area *t_area;	Area
 *		a_uint	t_addr;		Address
 *	};
 *
 *	Temporary Symbol Flags
 *
 *	S_MDF		010	Multiple Definition
 *
 */

void
prnttsym(struct sym *sp)
{
	struct tsym *tp;

	tp = sp->s_tsym;
 	if (tp == NULL) {
		fprintf(stdout, "prnttsym - NULL Argument\n");
		return;
	}

	while (tp) {
	 	fprintf(stdout, "struct tsym {\n");
/**/		fprintf(stdout, "\tstruct tsym *t_lnk\t= ");
		if (tp->t_lnk != NULL) {
			fprintf(stdout, "%p\n", (void *) tp->t_lnk);
		} else {
			fprintf(stdout, "NULL\n");
		}
/**/		fprintf(stdout, "\ta_uint\tt_num\t\t= 0x%08X\n", tp->t_num);
/**/	 	fprintf(stdout, "\tchar\tt_flg\t\t= 0x%02X", tp->t_flg);
		if (tp->t_flg) {
			fprintf(stdout, "\t(");
			if (tp->t_flg & S_MDF)	{ fprintf(stdout, "MDF"); }
			fprintf(stdout, ")");
		}
		fprintf(stdout, "\n");
/**/		fprintf(stdout, "\tstruct area *t_area\t= ");
		if (tp->t_area != NULL) {
			fprintf(stdout, "%p\n", (void *) tp->t_area);
			fprintf(stdout, "\t      [->a_id]\t\t= %s\n", tp->t_area->a_id);
		} else {
			fprintf(stdout, "NULL\n");
		}
/**/		fprintf(stdout, "\ta_uint\tt_addr\t\t= 0x%08X\n", tp->t_addr);
		fprintf(stdout, "}\n");

		tp = tp->t_lnk;
	}
}

/*)Function	void	prntarea(ap)
 *
 *		struct	area *	ap	pointer to an area structure
 *
 *	The function prntarea() prints the contents
 *	of an area structure to the console.
 *
 *	local variables:
 *		int	i	flag counter
 *
 *	global variables:
 *		none
 *
 *	functions called:
 *		int	fprintf()	c_library
 *
 *	side effects:
 *		none
 *
 *
 *	The area structure contains the parameter values for a
 *	specific program or data section.  The area structure
 *	is a linked list of areas.  The initial default area
 *	is "_CODE" defined in ___pst.c, the next area structure
 *	will be linked to this structure through the structure
 *	element 'struct area *a_ap'.  The structure contains a
 *	a pointer to an optional bank specification, the
 *	area name, area reference number ("_CODE" is 0) determined
 *	by the order of .area directives, area size determined
 *	from the total code and/or data in an area, area fuzz is
 *	a variable used to track pass to pass changes in the
 *	area size caused by variable length instruction formats,
 *	and area flags which specify the area's relocation type.
 *
 *	struct	area
 *	{
 *		struct	area *a_ap;	Area link
 *		struct	bank *b_bp;	Bank link
 *		char *	a_id;		Area Name
 *		int	a_ref;		Reference number
 *		a_uint	a_size;		Area size
 *		a_uint	a_fuzz;		Area fuzz
 *		int	a_flag;		Area flags
 *	};
 *
 *	Area Flags
 *
 *	A_CON	0x0400		Concatenating
 *	A_OVR	0x0404		Overlaying
 *	A_REL	0x0800		Relocatable
 *	A_ABS	0x0808		Absolute
 *	A_NOPAG	0x1000		Non-Paged
 *	A_PAG	0x1010		Paged
 *
 *	A_CSEG	0x4000		CSEG
 *	A_DSEG	0x4040		DSEG
 *	A_NOBNK	0x8000		Non-Banked
 *	A_BNK	0x8080		Banked
 *
 *	A_OUT	0x0100		Output Code Flag
 *
 */

void
prntarea(struct area *ap)
{
 	int i;

 	if (ap == NULL) {
		fprintf(stdout, "prntarea - NULL Argument\n");
		return;
	}

 	fprintf(stdout, "struct area {\n");
/**/	fprintf(stdout, "\tstruct area *a_ap\t= ");
	if (ap->a_ap != NULL) {
		fprintf(stdout, "%p\n", (void *) ap->a_ap);
	} else {
		fprintf(stdout, "NULL\n");
	}
/**/	fprintf(stdout, "\tstruct bank *b_bp\t= ");
	if (ap->b_bp != NULL) {
		fprintf(stdout, "%p\n", (void *) ap->b_bp);
	} else {
		fprintf(stdout, "NULL\n");
	}
/**/	fprintf(stdout, "\tchar\t*a_id\t\t= ");
	if (ap->a_id != NULL) {
		fprintf(stdout, "%p\n", (void *) ap->a_id);
		fprintf(stdout, "\t       [*a_id]\t\t= %s\n", ap->a_id);
	} else {
		fprintf(stdout, "NULL\n");
	}
/**/	fprintf(stdout, "\tint\ta_ref\t\t= 0x%08X\n", ap->a_ref);
/**/	fprintf(stdout, "\ta_uint\ta_size\t\t= 0x%08X\n", ap->a_size);
/**/	fprintf(stdout, "\ta_uint\ta_fuzz\t\t= 0x%08X\n", ap->a_fuzz);
/**/ 	fprintf(stdout, "\tchar\ts_flag\t\t= 0x%02X", ap->a_flag);
	if (ap->a_flag & 0xDCC) {
		i = 0;
		fprintf(stdout, "\t(");
		if ((ap->a_flag & A_OVR) == A_CON)	fprintf(stdout, "%s%s", i++ ? ", " : "", "CON");
		if ((ap->a_flag & A_OVR) == A_OVR)	fprintf(stdout, "%s%s", i++ ? ", " : "", "OVR");
		if ((ap->a_flag & A_ABS) == A_REL)	fprintf(stdout, "%s%s", i++ ? ", " : "", "REL");
		if ((ap->a_flag & A_ABS) == A_ABS)	fprintf(stdout, "%s%s", i++ ? ", " : "", "ABS");
		if ((ap->a_flag & A_PAG) == A_NOPAG)	fprintf(stdout, "%s%s", i++ ? ", " : "", "NOPAG");
		if ((ap->a_flag & A_PAG) == A_PAG)	fprintf(stdout, "%s%s", i++ ? ", " : "", "PAG");
		if ((ap->a_flag & A_DSEG) == A_CSEG)	fprintf(stdout, "%s%s", i++ ? ", " : "", "CSEG");
		if ((ap->a_flag & A_DSEG) == A_DSEG)	fprintf(stdout, "%s%s", i++ ? ", " : "", "DSEG");
		if ((ap->a_flag & A_BNK) == A_NOBNK)	fprintf(stdout, "%s%s", i++ ? ", " : "", "NOBNK");
		if ((ap->a_flag & A_BNK) == A_BNK)	fprintf(stdout, "%s%s", i++ ? ", " : "", "BNK");
		if ((ap->a_flag & A_OUT) == A_OUT)	fprintf(stdout, "%s%s", i++ ? ", " : "", "OUT");
		fprintf(stdout, ")");
	}
	fprintf(stdout, "\n");
	fprintf(stdout, "}\n");
}

/*)Function	void	prntbank(ap)
 *
 *		struct	bank *	bp	pointer to a bank structure
 *
 *	The function prntbank() prints the contents
 *	of a bank structure to the console.
 *
 *	local variables:
 *		int	i	flag counter
 *
 *	global variables:
 *		none
 *
 *	functions called:
 *		int	fprintf()	c_library
 *
 *	side effects:
 *		none
 *
 *
 *	The bank structure contains the parameter values for a
 *	specific collection of areas.  The bank structure
 *	is a linked list of banks.  The initial default bank
 *	is "_CODE" defined in ___pst.c, the next bank structure
 *	will be linked to this structure through the structure
 *	element 'struct bank *b_bp'.  The structure contains the
 *	bank name, bank reference number ("_CODE" is 0) determined
 *	by the order of .bank directives, the bank base address
 *	(default = 0), bank size (default = 0, whole addressing space),
 *	and output data file suffix (appended as a suffix to the
 *	output file name) are optional parameters of the .bank
 *	assembler directive which are passed to the linker as the
 *	default link parameters, and the bank flags which specify
 *	what options have been specified.
 *
 *	struct	bank
 *	{
 *		struct	bank *b_bp;	Bank link
 *		char *	b_id;		Bank Name
 *		char *	b_fsfx;		Bank File Suffix
 *		int	b_ref;		Ref. number
 *		a_uint	b_base;		Bank base address
 *		a_uint	b_size;		Bank length
 *		a_uint	b_map;		Bank mapping
 *		int	b_flag;		Bank flags
 *	};
 *
 *	Bank Flags
 *
 *	B_BASE	0001		'base' address specified
 *	B_SIZE	0002		'size' of bank specified
 *	B_FSFX	0004		File suffix specified
 *	B_MAP	0010		Mapped Bank Flag
 *
 */

void
prntbank(struct bank *bp)
{
 	int i;

 	if (bp == NULL) {
		fprintf(stdout, "prntbank - NULL Argument\n");
		return;
	}

 	fprintf(stdout, "struct bank {\n");
/**/	fprintf(stdout, "\tstruct bank *b_bp\t= ");
	if (bp->b_bp != NULL) {
		fprintf(stdout, "%p\n", (void *) bp->b_bp);
	} else {
		fprintf(stdout, "NULL\n");
	}
/**/	fprintf(stdout, "\tchar\t*b_id\t\t= ");
	if (bp->b_id != NULL) {
		fprintf(stdout, "%p\n", (void *) bp->b_id);
		fprintf(stdout, "\t       [*b_id]\t\t= %s\n", bp->b_id);
	} else {
		fprintf(stdout, "NULL\n");
	}
/**/	fprintf(stdout, "\tchar\t*b_fsfx");
	if (bp->b_fsfx != NULL) {
		fprintf(stdout, "\t\t= %p\n", (void *) bp->b_fsfx);
		fprintf(stdout, "\t       [*b_fsfx]\t\t= %s\n", bp->b_fsfx);
	} else {
		fprintf(stdout, "\t\t= NULL\n");
	}
/**/	fprintf(stdout, "\tint\tb_ref\t\t= 0x%08X\n", bp->b_ref);
/**/	fprintf(stdout, "\ta_uint\tb_base\t\t= 0x%08X\n", bp->b_base);
/**/	fprintf(stdout, "\ta_uint\tb_size\t\t= 0x%08X\n", bp->b_size);
/**/	fprintf(stdout, "\ta_uint\tb_map\t\t= 0x%08X\n", bp->b_map);
/**/ 	fprintf(stdout, "\tint\tb_flag\t\t= 0x%04X", bp->b_flag);
	if (bp->b_flag) {
		i = 0;
		fprintf(stdout, "\t(");
		if (bp->b_flag & B_BASE)	fprintf(stdout, "%s%s", i++ ? ", " : "", "BASE");
		if (bp->b_flag & B_SIZE)	fprintf(stdout, "%s%s", i++ ? ", " : "", "SIZE");
		if (bp->b_flag & B_FSFX)	fprintf(stdout, "%s%s", i++ ? ", " : "", "FSFX");
		if (bp->b_flag & B_MAP)		fprintf(stdout, "%s%s", i++ ? ", " : "", "MAP");
		fprintf(stdout, ")");
	}
	fprintf(stdout, "\n");
	fprintf(stdout, "}\n");
}

#endif

/*)SDCC and NoICE debug functions
 *
 *	1) generate debug symbols for assembler code
 *	   similiar to those generated by the SDCC compiler
 *
 *	2) generate debug symbols for the NoICE
 *	   remote debugger
 *
 *	asdbg.c contains the following functions:
 *		void	DefineSDCC_Line()
 *		void	DefineNoICE_Line()
 *		char *	BaseFileName()
 *
 *	asdbg.c contains the static variables:
 *		int	prevFile
 *		char	baseName[FILSPC]
 *
 *	    used by the BaseFileName function.
 *
 * NOTE:
 *	These functions know nothing about 'include' files
 *	and do not track their inclusion.
 */

/*)Function	void	DefineSDCC_Line(void)
 *
 *	The function DefineSDCC_Line() is called to create
 *	a symbol of the form A$FILE$nnn where FILE is the
 *	Base File Name, the file name without a path or
 *	an extension, and nnn is the line number.
 *
 *	local variables:
 *		char		name[]	a temporary to build the symbol
 *	        struct sym *	pSym	pointer to the created symbol structure
 *
 *	global variables:
 *		int	srcline		array of source file line numbers
 *		a_uint	laddr		current assembler address
 *		area	dot.s_area	pointer to the current area
 *
 *	functions called:
 *		char *	BaseFileName()	asdbg.c
 *		sym *	lookup()	assym.c
 *		int	sprintf()	c_library
 *
 *	side effects:
 *		A new symbol of the form A$FILE$nnn is created.
 */

#if SDCDB

void
DefineSDCC_Line(void)
{
	char name[ NCPS + FILSPC ];
        struct sym *pSym;

	/*
	 * Symbol is A$FILE$nnn
	 */
        sprintf( name, "A$%s$%u", BaseFileName( asmc ), srcline );

        pSym = lookup( name );
        pSym->s_type = S_USER;
        pSym->s_area = dot.s_area;
        pSym->s_addr = laddr;
        pSym->s_flag |= S_GBL;
}

#endif


/*)Function	void	DefineNoICE_Line(void)
 *
 *	The function DefineNoICE_Line() is called to create
 *	a symbol of the form FILE.nnn where FILE is the
 *	Base File Name, the file name without a path or
 *	an extension, and nnn is the line number.
 *
 *	local variables:
 *		char		name[]	a temporary to build the symbol
 *	        struct sym *	pSym	pointer to the created symbol structure
 *
 *	global variables:
 *		int	cfile		current source file number
 *		int	srcline		array of source file line numbers
 *		a_uint	laddr		current assembler address
 *		area	dot.s_area	pointer to the current area
 *
 *	functions called:
 *		char *	BaseFileName()	asdbg.c
 *		sym *	lookup()	assym.c
 *		int	sprintf()	c_library
 *
 *	side effects:
 *		A new symbol of the form FILE.nnn is created.
 */

#if NOICE

void
DefineNoICE_Line(void)
{
	char name[ NCPS + FILSPC ];
        struct sym *pSym;

	/*
	 * Symbol is FILE.nnn
	 */
        sprintf( name, "%s.%u", BaseFileName( asmc ), srcline );

        pSym = lookup( name );
        pSym->s_type = S_USER;
        pSym->s_area = dot.s_area;
        pSym->s_addr = laddr;
        pSym->s_flag |= S_GBL;
}

#endif


/*)Function	char *	BaseFileName(currFile)
 *
 *	The function BaseFileName() is called to extract
 *	the file name from a string containing a path,
 *	filename, and extension.
 *
 *		currFile		is a pointer to the
 *					current assembler object
 *
 *	local variables:
 *		char	baseName[]	a place to put the file name
 *	        int	prevFile	previous assembler object
 *		char *	p1		temporary string pointer
 *		char *	p2		temporary string pointer
 *
 *	global variables:
 *		FILE *	ofp		output file handle
 *
 *	functions called:
 *		int	fprintf()	c_library
 *		char *	strcpy()	c_library
 *		char *	strrchr()	c_library
 *
 *	side effects:
 *		A FILE command of the form ';!FILE string'
 *		is written to the output file.
 */

#if (NOICE || SDCDB)

static	struct	asmf *prevFile = NULL;
static	char	baseName[FILSPC];

char*
BaseFileName(struct asmf *currFile)
{
        char *p1, *p2;

	if (currFile != prevFile) {
        	prevFile = currFile;

		strcpy(baseName, afn);
                p1 = baseName;

                /*
	         * Dump a FILE command with full path and extension
		 */
                fprintf(ofp, ";!FILE %s\n", p1);

		/*
		 * The name starts after the last
		 * '/' (Unices) or
		 * ':' or '\' (DOS)
		 *
		 * and ends at the last
		 * separator 'FSEPX'
		 */
		if ((p2 = strrchr(p1,  '\\')) != NULL)  p1 = ++p2;
		if ((p2 = strrchr(p1,   '/')) != NULL)  p1 = ++p2;
		if ((p2 = strrchr(p1,   ':')) != NULL)  p1 = ++p2;
		if ((p2 = strrchr(p1, FSEPX)) != NULL) *p2 = 0;
		strcpy(baseName, p1);
	}
	return(baseName);
}

#endif

