/* asexpr.c */

/*
 *  Copyright (C) 1989-2025  Alan R. Baldwin
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
 *   With enhancements from
 *
 *	Bill McKinnon (BM)
 *	w_mckinnon at conknet dot com
 */

#include "asxxxx.h"

/*)Module	asexpr.c
 *
 *	The module asexpr.c contains the routines to evaluate
 *	arithmetic/numerical expressions.  The functions in
 *	asexpr.c perform a recursive evaluation of the arithmetic
 *	expression read from the assembler-source text line.
 *	The expression may include binary/unary operators, brackets,
 *	symbols, labels, and constants in hexadecimal, decimal, octal
 *	and binary.  Arithmetic operations are prioritized and
 *	evaluated by normal arithmetic conventions.
 *
 *	asexpr.c contains the following functions:
 *		void	abscheck()
 *		a_uint	absexpr()
 *		int	is_abs()
 *		void	clrexpr()
 *		int	digit()
 *		void	expr()
 *		void	exprmasks()
 *		int	oprio()
 *		void	term()
 *
 *	asexpr.c contains no local/static variables
 */

/*)Function	void	expr(esp, n)
 *
 *		expr *	esp		pointer to an expr structure
 *		int	n		a firewall priority; all top
 *					level calls (from the user)
 *					should be made with n set to 0.
 *
 *	The function expr() evaluates an expression and
 *	stores its value and relocation information into
 *	the expr structure supplied by the user.
 *
 *	local variables:
 *		int	c		current assembler-source
 *					text character
 *		int	p		current operator priority
 *		exp	re		internal expr structure
 *
 *	global variables:
 *		char	ctype[]		array of character types, one per
 *					ASCII character
 *
 *	functions called:
 *		void	binop()		asexpr.c
 *		void	clrexpr()	asexpr.c
 *		int	getnb()		aslex.c
 *		int	oprio()		asexpr.c
 *		void	xerr()		assubr.c
 *		void	term()		asexpr.c
 *		void	unget()		aslex.c
 *
 *
 *	side effects:
 *		An expression is evaluated modifying the user supplied
 *		expr structure, a sym structure maybe created for an
 *		undefined symbol, and the parse of the expression may
 *		terminate if a 'q' error occurs.
 */

void
expr(struct expr *esp, int n)
{
	int c, p;
	struct expr re;

	term(esp);
	while (ctype[c = getnb()] & BINOP) {
		/*
		 * Handle binary operators + - * / & | % ^ << >>
		 */
		if ((p = oprio(c)) <= n)
			break;
		if ((c == '>' || c == '<') && c != get())
			xerr('q', "Binary operator >> or << expected.");
		clrexpr(&re);
		expr(&re, p);
		esp->e_rlcf |= re.e_rlcf;

		binop(c, esp, &re);
	}
	unget(c);
}

/*)Function	void	binop(c, esp, re)
 * 
 *		int	c		operation to perform
 *		expr *	esp		pointer to LHS argument, result
 *		expr *	re		pointer to RHS argument
 *
 *	The function binop() evaluates a binary operator and
 *	stores its value and relocation information into the
 *	esp structure supplied by the user.
 *
 *	Notes about the arithmetic:
 *		The coding emulates N-Bit unsigned
 *		arithmetic operations.  This allows
 *		program compilation without regard to the
 *		intrinsic integer length of the host
 *		machine.
 *
 *	local variables:
 *		a_uint	ae		value from expr esp
 *		a_uint	ar		value from expr re
 *		area *	ap		pointer to an area structure
 *
 *	functions called:
 *		void	abscheck()	asexpr.c
 *		void	err()		assubr.c
 *		void	xerr()		assubr.c
 */

void
binop(int c, struct expr *esp, struct expr *re)
{
	a_uint ae, ar;
	struct area *ap;

	/*
	 * N-Bit Unsigned Arithmetic
	 */
	ae = esp->e_addr & a_mask;
	ar = re->e_addr & a_mask;

	if (c == '+') {
 		/*
		 * esp + re, at least one must be absolute
 		 */
		if (esp->e_base.e_ap == NULL) {
 			/*
			 * esp is absolute (constant),
			 * use area from re
 			 */
			esp->e_base.e_ap = re->e_base.e_ap;
 		} else
		if (re->e_base.e_ap) {
 			/*
			 * re should be absolute (constant)
 			 */
			xerr('r', "Arg1 + Arg2, Arg2 must be a constant.");
		}
		if (esp->e_flag && re->e_flag)
			xerr('r', "Arg1 + Arg2, Both arguments cannot be external.");
		if (re->e_flag)
			esp->e_flag = 1;
		ae += ar;
	} else
	if (c == '-') {
		/*
		 * esp - re
		 */
		if ((ap = re->e_base.e_ap) != NULL) {
			if (esp->e_base.e_ap == ap) {
				esp->e_base.e_ap = NULL;
			} else {
				xerr('r', "Arg1 - Arg2, Arg2 must be in same area.");
 			}
		}
		if (re->e_flag)
			xerr('r', "Arg1 - Arg2, Arg2 cannot be external.");
		ae -= ar;
	} else {
		/*
		 * Both operands (esp and re) must be constants
		 */
		abscheck(esp);
		abscheck(re);
		switch (c) {
		/*
		 * The (int) /, %, and >> operations
		 * are truncated to a_bytes.
		 */
		case '*':
			ae *= ar;
			break;
 
		case '/':
			if (ar == 0) {
				ae = 0;
				err('z');
			} else {
				ae /= ar;
			}
			break;
 
		case '&':
			ae &= ar;
			break;
 
		case '|':
			ae |= ar;
			break;
 
		case '%':
			if (ar == 0) {
				ae = 0;
				err('z');
			} else {
				ae %= ar;
 			}
			break;

		case '^':
			ae ^= ar;
			break;

		case '<':
			ae <<= ar;
			break;

		case '>':
			ae >>= ar;
			break;

		default:
			qerr();
			break;
 		}
 	}
	esp->e_addr = rngchk(ae);
 }

 /*)Function	a_uint	absexpr()
 *
 *	The function absexpr() evaluates an expression, verifies it
 *	is absolute (i.e. not position dependent or relocatable), and
 *	returns its value.
 *
 *	local variables:
 *		expr	e		expr structure
 *
 *	global variables:
 *		none
 *
 *	functions called:
 *		void	abscheck()	asexpr.c
 *		void	clrexpr()	asexpr.c
 *		void	expr()		asexpr.c
 *
 *	side effects:
 *		If the expression is not absolute then
 *		a 'r' error is reported.
 */

a_uint
absexpr(void)
{
	struct expr e;

	clrexpr(&e);
	expr(&e, 0);
	abscheck(&e);
	return (e.e_addr);
}

/*)Function	void	term(esp)
 *
 *		expr *	esp		pointer to an expr structure
 *
 *	The function term() evaluates a single constant
 *	or symbol value prefaced by any unary operator
 *	( +, -, ~, ', ", >, or < ).  This routine is also
 *	responsible for setting the relocation type to symbol
 *	based (e.flag != 0) on global references.
 *
 *	Notes about the arithmetic:
 *		The coding emulates N-Bit unsigned
 *		arithmetic operations.  This allows
 *		program compilation without regard to the
 *		intrinsic integer length of the host
 *		machine.
 *
 *	local variables:
 *		int	c		current character
 *		char	id[]		symbol name
 *		char *	jp		pointer to assembler-source text
 *		a_uint	n		constant evaluation running sum
 *		int	r		current evaluation radix
 *		mne	mp		pointer to a mne structure
 *		sym *	sp		pointer to a sym structure
 *		tsym *	tp		pointer to a tsym structure
 *		int	v		current digit evaluation
 *
 *	global variables:
 *		char	ctype[]		array of character types, one per
 *					ASCII character
 *		sym *	symp		pointer to a symbol structure
 *
 *	functions called:
 *		void	abscheck()	asexpr.c
 *		int	digit()		asexpr.c
 *		void	err()		assubr.c
 *		void	expr()		asexpr.c
 *		int	is_abs()	asexpr.c
 *		int	get()		aslex.c
 *		void	getid()		aslex.c
 *		int	getmap()	aslex.c
 *		int	getnb()		aslex.c
 *		sym *	lookup()	assym.c
 *		void	qerr()		assubr.c
 *		void	unget()		aslex.c
 *
 *	side effects:
 *		An arithmetic term is evaluated, a symbol structure
 *		may be created, term evaluation may be terminated
 *		by a 'q' error.
 */

void
term(struct expr *esp)
{
	int c;
	char *jp;
	char id[NCPS];
	struct mne  *mp;
	struct sym  *sp;
	struct tsym *tp;
	int r, s, t, v;
	a_uint n;

 	r = radix;
	c = getnb();
	/*
 	 * Discard the unary '+' at this point and
	 * also any reference to numerical arguments
	 * associated with the '#' prefix.
	 */
	while (c == '+' || c == '#') { c = getnb(); }

	/*
 	 * Evaluate all binary operators
	 * by recursively calling expr().
	 */
	if (c == LFTERM) {
		expr(esp, 0);
		if (getnb() != RTTERM)
			qerr();
		return;
	}
	unget(c);

	/*
	 * If mchterm_ptr != NULL then a call to
	 * the machine specific 'mchterm()' function
	 * is made.  If the argument is processed
	 * the return value is non zero and the
	 * argument's value is returned in esp.
  	 * If the argument is not used then a zero
	 * is returned and the normal 'term()'
	 * processing continues.
	 */
	if (*mchterm_ptr && ((*mchterm_ptr)(esp))) {
		return;
	}

	c = getnb();
	if (c == '-') {
		expr(esp, 100);
		abscheck(esp);
		esp->e_addr = ~esp->e_addr + 1;
		return;
	}
	if (c == '~') {
		expr(esp, 100);
		abscheck(esp);
		esp->e_addr = ~esp->e_addr;
		return;
	}
	if (c == '\'') {
		esp->e_mode = S_USER;
		esp->e_addr = getmap(-1)&0377;
		return;
	}
	if (c == '\"') {
		esp->e_mode = S_USER;
		if ((int) hilo) {
		    esp->e_addr  = (getmap(-1)&0377)<<8;
		    esp->e_addr |= (getmap(-1)&0377);
		} else {
		    esp->e_addr  = (getmap(-1)&0377);
		    esp->e_addr |= (getmap(-1)&0377)<<8;
		}
		if (esp->e_addr & s_mask) {
			esp->e_addr |= ~v_mask;
		} else {
			esp->e_addr &=  v_mask;
		}
		return;
	}
	if (c == '>' || c == '<') {
		expr(esp, 100);
		if (is_abs (esp)) {
			/*
			 * evaluate byte selection directly
			 */
			if (c == '>')
				esp->e_addr >>= (8 * as_msb);
			esp->e_addr &= 0377;
			return;
		} else {
			/*
			 * let linker perform byte selection
			 */
			if (c == '>')
				esp->e_rlcf |= R_MSB;
			return;
		}
	}
	/*
	 * Evaluate digit sequences as reusable
	 * symbols if followed by a '$'.
	 */
	if (ctype[c] & DIGIT) {
		jp = ip;
		while (ctype[*jp & 0x007F] & RAD10) {
			jp++;
		}
		if (*jp == '$') {
			n = 0;
			while ((v = digit(c, 10)) >= 0) {
				n = 10*n + v;
				c = get();
			}
			n = rngchk(n);
			tp = symp->s_tsym;
			while (tp) {
				if (n == tp->t_num) {
					esp->e_mode = S_USER;
					esp->e_base.e_ap = tp->t_area;
					esp->e_addr = tp->t_addr;
					return;
				}
				tp = tp->t_lnk;
			}
			err('u');
			return;
		}
		jp = ip;
	}
	/*
	 * Temporary Radix Type 0[BOQHX]
	 * 'C' Style Option When (csn != 0)
	 *     0nnn (Octal), 0xnnn (Hex), Else Decimal
	 */
	s = 0;
	if ((c == '0') && !esp->e_inhbt) {
		jp = ip;
		switch (ccase[get()]) {
		case 'b':  if (!csn) s = 2;	break;	/* 0B */
		case 'o':				/* 0O */
		case 'q':  if (!csn) s = 8;	break;	/* 0Q */
		case 'd':  if (!csn) s = 10;	break;	/* 0D */
		case 'h':  if ( csn)		break;	/* 0H */
		case 'x':	     s = 16;	break;	/* 0X */
		default:   if ( csn) s = 8;		/* 0O */
			c = '0';
			ip = jp;
			break;
		}
	} else
	/*
	 * Evaluate '$' sequences as a temporary radix
	 * if followed by a '%', '&', '#', or '@'.
	 */
	if (c == '$') {
		jp = ip;
		switch (get()) {
		case '%':	s = 2;	break;
		case '&':	s = 8;	break;
		case '#':	s = 10;	break;
		case '@':	s = 16;	break;
		default:
			c = '$';
			ip = jp;
			break;
		}
	}
	/*
	 * Process Type '0' and '$' Temporary Radixes
	 */
	if (s) {
		/*
		 * Check For Decimal Point Radix 10 Override
		 */
		c = get();
		if (ctype[c] & DIGIT) {
			jp = ip;
			v = c;
			while ((c >= '0') && (c <= '9')) {
				c = get();
			}
			if (c == '.') {
				s = 10;
			}
			c = v;
			ip = jp;
		}
		/*
		 * Process Number
		 */
		n = 0;
		while ((v = digit(c, s)) >= 0) {
			n = s*n + v;
			c = get();
		}
		if (c != '.') {
			unget(c);
		}
		esp->e_mode = S_USER;
		esp->e_addr = rngchk(n);
		return;
	}
	/*
	 * Temporary Radix Type ^[BOQDHX]
	 */
	t = 0;
	if (c == '^') {
		jp = ip;
		switch (ccase[get()]) {
		case 'b':	t = 2;	break;	/* ^B */
		case 'o':			/* ^O */
		case 'q':	t = 8;	break;	/* ^Q */
		case 'd':	t = 10;	break;	/* ^D */
		case 'h':			/* ^H */
		case 'x':	t = 16;	break;	/* ^X */
		default:
			c = '^';
			ip = jp;
			break;
		}
	}
	/*
	 * Process Type '^' Temporary Radixes
	 */
	if (t) {
		/*
		 * Process An Immediate Number
		 */
		jp = ip;
		if (is_digit((c = getnb()), t)) {
			n = 0;
			while ((v = digit(c, t)) >= 0) {
				n = t*n + v;
				c = get();
			}
			unget(c);
			esp->e_mode = S_USER;
			esp->e_addr = rngchk(n);
			return;
		}
		ip = jp;
		c = radix;
		radix = t;
		esp->e_inhbt += 1;
		expr(esp,100);
		esp->e_inhbt -= 1;
		radix = c;
		return;
	}
	/*
	 * Evaluate Numbers
	 * 	1) Beginning With Decimal Digits (0 - 9)
	 *	2) Beginning With Hex Digits (A - F)
	 *		If (r = 16) And (esp->e_inhbt != 0) And
	 *		Does Not Contain (G - Z), ($), (_) Or (.)
	 *		And The String Is Not A Symbol/Label
	 */
	/* 1) */
	if (ctype[c] & DIGIT) {
		/*
		 * Check For Decimal Point Radix 10 Override
		 */
		jp = ip;
		v = c;
		while ((c >= '0') && (c <= '9')) {
			c = get();
		}
		if (c == '.') {
			r = 10;
		}
		c = v;
		ip = jp;
		/*
		 * Process Number
		 */
		n = 0;
		while ((v = digit(c, r)) >= 0) {
			n = r*n + v;
			c = get();
		}
		if (c != '.') {
			unget(c);
		}
		esp->e_mode = S_USER;
		esp->e_addr = rngchk(n);
		return;
	}
	/* 2) */
	if ((ctype[c] & RAD16) && (r == 16) && !esp->e_inhbt) {
		jp = ip;
		v = c;
		/*
		 * Scan For Non RAD16 LETTERs
		 * (G - Z), (.), ($), And (_)
		 */
		getid(id, c);
		ip = id;
		while (is_digit(c, 16)) { c = get(); }
		if ((c == 0) && !slookup(id)) {
			/*
			 * Process Number
			 */
			n = 0;
			while ((v = digit(c, r)) >= 0) {
				n = r*n + v;
				c = get();
			}
			esp->e_mode = S_USER;
			esp->e_addr = rngchk(n);
			return;
		}
		c = v;
		ip = jp;
	}
	/*
	 * Evaluate Symbols and Labels
	 */
	if (ctype[c] & LETTER) {
		getid(id, c);
		/*
		 * Check for permanent symbols accessible as constants
		 */
		mp = mlookup(id);
		if ((mp != NULL) && (mp->m_type == S_CONST)) {
			esp->e_addr = mp->m_valu;
			return;
		}
		/*
		 * Check for user-defined symbols
		 */
		esp->e_mode = S_USER;
		sp = lookup(id);
		if (sp->s_type == S_NEW) {
			if (sp->s_flag&S_GBL) {
				esp->e_flag = 1;
				esp->e_base.e_sp = sp;
				return;
			}
			err('u');
		} else {
			esp->e_mode = sp->s_type;
			esp->e_addr = sp->s_addr;
			esp->e_base.e_ap = sp->s_area;
		}
		return;
	}
	/*
	 * Else not a term.
	 */
	qerr();
}

/*)Function	int	digit(c, r)
 *
 *		int	c		digit character
 *		int	r		current radix
 *
 *	The function digit() returns the value of c
 *	in the current radix r.  If the c value is not
 *	a number of the current radix then a -1 is returned.
 *
 *	local variables:
 *		none
 *
 *	global variables:
 *		char	ctype[]		array of character types, one per
 *					ASCII character
 *
 *	functions called:
 *		none
 *
 *	side effects:
 *		none
 */

int
digit(int c, int r)
{
	if (r == 16) {
		if (ctype[c] & RAD16) {
			if (c >= 'A' && c <= 'F')
				return (c - 'A' + 10);
			if (c >= 'a' && c <= 'f')
				return (c - 'a' + 10);
			return (c - '0');
		}
	} else
	if (r == 10) {
		if (ctype[c] & RAD10)
			return (c - '0');
	} else
	if (r == 8) {
		if (ctype[c] & RAD8)
			return (c - '0');
	} else
	if (r == 2) {
		if (ctype[c] & RAD2)
			return (c - '0');
	}
	if (ctype[c] & RAD16) {
		err('k');
	}
	return (-1);
}

/*)Function	int	is_digit(c, r)
 *
 *		int	c		digit character
 *		int	r		current radix
 *
 *	The function is_digit() returns 1 if c is
 *	in the current radix r.  If the c value is not
 *	a number of the current radix then a 0 is returned.
 *
 *	local variables:
 *		none
 *
 *	global variables:
 *		char	ctype[]		array of character types, one per
 *					ASCII character
 *
 *	functions called:
 *		none
 *
 *	side effects:
 *		none
 */

int
is_digit(int c, int r)
{
	if ((r == 16) && (ctype[c] & RAD16)) return(1);
	if ((r == 10) && (ctype[c] & RAD10)) return(1);
	if ((r ==  8) && (ctype[c] & RAD8 )) return(1);
	if ((r ==  2) && (ctype[c] & RAD2 )) return(1);
	return(0);
}

/*)Function	void	abscheck(esp)
 *
 *		expr *	esp		pointer to an expr structure
 *
 *	The function abscheck() tests the evaluation of an
 *	expression to verify it is absolute.  If the evaluation
 *	is relocatable then an 'r' error is noted and the expression
 *	made absolute.
 *
 *	Note:	The area type (i.e. ABS) is not checked because
 *		the linker can be told to explicitly relocate an
 *		absolute area.
 *
 *	local variables:
 *		none
 *
 *	global variables:
 *		none
 *
 *	functions called:
 *		void	rerr()		assubr.c
 *
 *	side effects:
 *		The expression may be changed to absolute and the
 *		'r' error invoked.
 */

void
abscheck(struct expr *esp)
{
	if (esp->e_flag || esp->e_base.e_ap) {
		esp->e_flag = 0;
		esp->e_base.e_ap = NULL;
		rerr();
	}
}

/*)Function	int	is_abs(esp)
 *
 *		expr *	esp		pointer to an expr structure
 *
 *	The function is_abs() tests the evaluation of an
 *	expression to verify it is absolute.  If the evaluation
 *	is absolute then 1 is returned, else 0 is returned.
 *
 *	Note:	The area type (i.e. ABS) is not checked because
 *		the linker can be told to explicitly relocate an
 *		absolute area.
 *
 *	local variables:
 *		none
 *
 *	global variables:
 *		none
 *
 *	functions called:
 *		none
 *
 *	side effects:
 *		none
 */

int
is_abs(struct expr *esp)
{
	if (esp->e_flag || esp->e_base.e_ap) {
		return(0);
	}
	return(1);
}

/*)Function	int	oprio(c)
 *
 *		int	c		operator character
 *
 *	The function oprio() returns a relative priority
 *	for all valid unary and binary operators.
 *
 *	local variables:
 *		none
 *
 *	global variables:
 *		none
 *
 *	functions called:
 *		none
 *
 *	side effects:
 *		none
 */
 
int
oprio(int c)
{
	if (c == '*' || c == '/' || c == '%')
		return (10);
	if (c == '+' || c == '-')
		return (7);
	if (c == '<' || c == '>')
		return (5);
	if (c == '^')
		return (4);
	if (c == '&')
		return (3);
	if (c == '|')
		return (1);
	return (0);
}

/*)Function	void	clrexpr(esp)
 *
 *		expr *	esp		pointer to expression structure
 *
 *	The function clrexpr() clears the expression structure.
 *
 *	local variables:
 *		none
 *
 *	global variables:
 *		none
 *
 *	functions called:
 *		none
 *
 *	side effects:
 *		expression structure cleared.
 */
 
void
clrexpr(struct expr *esp)
{
	esp->e_mode = 0;
	esp->e_flag = 0;
	esp->e_addr = 0;
	esp->e_base.e_ap = NULL;
	esp->e_rlcf = 0;
	esp->e_inhbt = 0;
}

/*)Function	a_uint	rngchk(n)
 *
 *		a_uint	n		a signed /unsigned value
 *
 *	The function rngchk() verifies that the
 *	value of n is a signed or unsigned value
 *	within the range of the current exprmasks()
 *	settings and returns the value masked to
 *	the current exprmasks() settings.
 *
 *	local variables:
 *		none
 *
 *	global variables:
 *		a_uint	a_mask		Address mask
 *		int	vflag		Enable flag
 *		a_aint	v_mask		Value mask
 *
 *	functions called:
 *		void	err()		assubr.c
 *
 *	side effects:
 *		a 'v' error message may be generated.
 *
 *	Note:
 *		When the default arithmetic size is the
 *		same as the default sizeof(int) then the
 *		arithmetic overflow cannot be determined.
 *		This ambiguity is caused by the inability
 *		to distinguish signed and unsigned values
 *		at the instrinsic sizeof(int) size. 
 */

a_uint
rngchk(a_uint n)
{
	if (vflag) {
		if ((n & ~a_mask) && ((n & ~a_mask) != ~a_mask)) {
			err('v');
		}
	}
	return((n & s_mask) ? (n | ~v_mask) : (n & v_mask));
}

/*)Function	void	exprmasks(esp)
 *
 *		int	n		T Line Bytes in Address
 *
 *	The function exprmasks() configures the assembler
 *	for 16, 24, or 32-Bit Data/Addresses.
 *
 *	local variables:
 *		none
 *
 *	global variables:
 *		int	a_bytes		T Line Bytes in Address
 *		a_uint	a_mask		Address mask
 *		a_uint	s_mask		Sign mask
 *		a_uint	v_mask		Value mask
 *
 *	functions called:
 *		none
 *
 *	side effects:
 *		The arithmetic precision parameters are set.
 */
 
void
exprmasks(int n)
{
	a_bytes = n;

#ifdef	LONGINT
	switch(a_bytes) {
	default:
		a_bytes = 2;
	case 2:
		a_mask = (a_uint) 0x0000FFFFl;
		s_mask = (a_uint) 0x00008000l;
		v_mask = (a_uint) 0x00007FFFl;
		break;

	case 3:
		a_mask = (a_uint) 0x00FFFFFFl;
		s_mask = (a_uint) 0x00800000l;
		v_mask = (a_uint) 0x007FFFFFl;
		break;

	case 4:
		a_mask = (a_uint) 0xFFFFFFFFl;
		s_mask = (a_uint) 0x80000000l;
		v_mask = (a_uint) 0x7FFFFFFFl;
		break;
	}
#else
	switch(a_bytes) {
	default:
		a_bytes = 2;
	case 2:
		a_mask = (a_uint) 0x0000FFFF;
		s_mask = (a_uint) 0x00008000;
		v_mask = (a_uint) 0x00007FFF;
		break;

	case 3:
		a_mask = (a_uint) 0x00FFFFFF;
		s_mask = (a_uint) 0x00800000;
		v_mask = (a_uint) 0x007FFFFF;
		break;

	case 4:
		a_mask = (a_uint) 0xFFFFFFFF;
		s_mask = (a_uint) 0x80000000;
		v_mask = (a_uint) 0x7FFFFFFF;
		break;
	}
#endif
}


