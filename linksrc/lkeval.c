/* lkeval.c */

/*
 *  Copyright (C) 1989-2026  Alan R. Baldwin
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

#include "aslink.h"

/*)Module	lkeval.c
 *
 *	The module lkeval.c contains the routines to evaluate
 *	arithmetic/numerical expressions.  The functions in
 *	lkeval.c perform a recursive evaluation of the arithmetic
 *	expression read from the input text line.
 *	The expression may include binary/unary operators, brackets,
 *	symbols, labels, and constants in hexadecimal, decimal, octal
 *	and binary.  Arithmetic operations are prioritized and
 *	evaluated by normal arithmetic conventions.
 *
 *	lkeval.c contains the following functions:
 *		int	digit()
 *		a_uint	eval()
 *		a_uint	expr()
 *		int	oprio()
 *		a_uint	term()
 *
 *	lkeval.c contains no local/static variables
 */

/*)Function	a_uint	eval(void)
 *
 *	The function eval() evaluates a character string to a
 *	numerical value.
 *
 *	Notes about the arithmetic:
 *		The coding emulates X-Bit unsigned
 *		arithmetic operations.  This allows
 *		program compilation without regard to the
 *		intrinsic integer length of the host
 *		machine.
 *
 *	local variables:
 *		int	c		character from input string
 *		int	n		value of character in current radix
 *		a_uint	v		evaluation value
 *
 *	global variables:
 *		int	radix		current number conversion radix
 *
 *	functions called:
 *		int	digit()		lkeval.c
 *		int	get()		lklex.c
 *		int	getnb()		lklex.c
 *		void	unget()		lklex.c
 *
 *	side effects:
 *		Input test is scanned and evaluated to a
 *		numerical value.
 */

a_uint
eval(void)
{
	int c, n;
	a_uint v;

	c = getnb();
	v = 0;
	while ((n = digit(c, radix)) >= 0) {
		v = v*radix + n;
		c = get();
	}
	unget(c);
	return((v & s_mask) ? v | ~v_mask : v & v_mask);
}

/*)Function	a_uint	expr(void)
 *
 *	The function expr() initializes parameters
 *	for the expression evaluation, call the
 *	expression anaylzer and returns the value.
 *
 *	Notes about the arithmetic:
 *		The coding emulates X-Bit unsigned
 *		arithmetic operations.  This allows
 *		program compilation without regard to the
 *		intrinsic integer length of the host
 *		machine.
 *
 *	local variables:
 *		none
 *
 *	global variables:
 *		char *	expr_ip		evalution string ip
 *		int	expr_radix	internal expr() radix value
 *
 *	functions called:
 *		void	exprx()		lkeval.c
 *
 *	side effects:
 *		An expression is evaluated by scanning the input
 *		text string.
 */

a_uint
expr(void)
{
	/*
	 * Initialize Entry
	 */
	expr_radix = 10;
	expr_ip = ip;

	/*
	 * Process Expression
	 */
	return(exprx(0, 0));
}

/*)Function	a_uint	exprx(a_uint v, int n)
 *
 *		a_uint	v		initial value
 *		int	n		a firewall priority; all top
 *					level calls (from the user)
 *					should be made with n set to 0.
 *
 *	The function exprx() evaluates an expression and
 *	returns the value.
 *
 *	Notes about the arithmetic:
 *		The coding emulates X-Bit unsigned
 *		arithmetic operations.  This allows
 *		program compilation without regard to the
 *		intrinsic integer length of the host
 *		machine.
 *
 *	local variables:
 *		int	c		current input text character
 *		int	p		current operator priority
 *		a_uint	ve		value returned by a
 *					recursive call to exprx()
 *
 *	global variables:
 *		char	ctype[]		array of character types, one per
 *					ASCII character
 *		int	lkerr		error flag
 *		FILE *	stderr		c_library
 *
 *	functions called:
 *		void	exprx()		lkeval.c
 *		int	fprintf()	c_library
 *		int	getnb()		lklex.c
 *		int	oprio()		lkeval.c
 *		void	term()		lkeval.c
 *		void	unget()		lklex.c
 *
 *
 *	side effects:
 *		An expression is evaluated by scanning the input
 *		text string.
 */

a_uint
exprx(a_uint v, int n)
{
	int c, p;
	a_uint ve;

	v = term(v);
	while (ctype[c = getnb()] & BINOP) {
		if ((p = oprio(c)) <= n)
			break;
		if ((c == '>' || c == '<') && c != get()) {
			fprintf(stderr, "?ASlink-Error-Invalid Expression\n");
			lkerr++;
			return(v);
		}
		ve = exprx(0, p);
		v  = binop(c, v, ve);
	}
	unget(c);
	return(v);
}

/*)Function	a_uint	binop(c, v, ve)
 * 
 *		int	c		operation to perform
 *		int	v		pointer to LHS argument, result
 *		int	ve		pointer to RHS argument
 *
 *	The function binop() evaluates a binary operator and
 *	returns its result.
 *
 *	Notes about the arithmetic:
 *		The coding emulates N-Bit unsigned
 *		arithmetic operations.  This allows
 *		program compilation without regard to the
 *		intrinsic integer length of the host
 *		machine.
 *
 *	global variables:
 *		char	*expr_ip	line pointer
 *		int	lkerr		linker error flag
 *		a_uint	a_mask		address mask
 *		a_uint	s_mask		sign mask
 *		a_uint	v_mask		overflow mask
 *
 *	functions called:
 *		void	fprintf()	c_library
 *		void	err()		assubr.c
 *		void	xerr()		assubr.c
 */

a_uint
/* binop(int c, int v, int ve) */
binop(int c, a_uint v, a_uint ve)
{
	/*
	 * X-Bit Unsigned Arithmetic
	 */
	v  &= a_mask;
	ve &= a_mask;

	switch (c) {

	case '+':
		v += ve;
		break;

	case '-':
		v -= ve;
		break;

	case '*':
		v *= ve;
		break;

	case '/':
		if (ve == 0) {
			v = 0;
			fprintf(stderr, "?ASlink-Error-Divide By 0: '%s'\n", expr_ip);
		} else {
			v /= ve;
		}
		break;

	case '&':
		v &= ve;
		break;

	case '|':
		v |= ve;
		break;

	case '%':
		if (ve == 0) {
			v = 0;
			fprintf(stderr, "?ASlink-Error-Mod by 0: '%s'\n", expr_ip);
		} else {
			v %= ve;
		}
		break;

	case '^':
		v ^= ve;
		break;

	case '<':
		v <<= ve;
		break;

	case '>':
		v>>= ve;
		break;

	default:
		fprintf(stderr, "?ASlink-Error-Invalid Expression\n");
		lkerr++;
		break;
		
	}
	return((v & s_mask) ? v | ~v_mask : v & v_mask);
}

/*)Function	a_uint	term(a_uint v)
 *
 *	The function term() evaluates a single constant
 *	or symbol value prefaced by any unary operator
 *	( +, -, ~, ', ", >, or < ).
 *
 *	Notes about the arithmetic:
 *		The coding emulates X-Bit unsigned
 *		arithmetic operations.  This allows
 *		program compilation without regard to the
 *		intrinsic integer length of the host
 *		machine.
 *
 *	local variables:
 *		int	c		current character
 *		int	expr_radix	current radix
 *		char	id[]		symbol name
 *		char *	jp		string pointer
 *		int	n		value of digit in current radix
 *		int	r		current evaluation radix
 * 		int	s		temporary '0' radix
 ^		int	t		temporary '^' radix
 *		sym *	sp		pointer to a sym structure
 *		a_uint	v		evaluation value
 *
 *	global variables:
 *		char	ctype[]		array of character types, one per
 *					ASCII character
 *		int	expr_radix	Internal expression radix
 *		int	lkerr		error flag
 *
 *	functions called:
 *		int	digit()		lkeval.c
 *		int	expr()		lkeval.c
 *		int	fprintf()	c_library
 *		int	get()		lklex.c
 *		void	getid()		lklex.c
 *		int	getmap()	lklex.c
 *		int	getnb()		lklex.c
 *		sym *	lkpsym()	lksym.c
 *		a_uint	symval()	lksym.c
 *		void	unget()		lklex.c
 *
 *	side effects:
 *		An arithmetic term is evaluated by scanning input text.
 */

a_uint
term(a_uint v)
{
	int c, n, r, t;
	struct sym *sp;
	char id[NCPS];
	char *jp;

	r = expr_radix;
	c = getnb();
	while (c == '+' || c == '#') { c = getnb(); }
	if (c == '(') {
		v = exprx(v, 0);
		if (getnb() != ')') {
			fprintf(stderr, "?ASlink-Error-Missing delimiter\n");
			lkerr++;
		}
		return(v);
	}
	if (c == '-') {
		return(~exprx(v, 100)+1);
	}
	if (c == '~') {
		return(~exprx(v, 100));
	}
	if (c == '\'') {
		return(getmap(-1)&0377);
	}
	if (c == '\"') {
		if (hilo) {
			v  = (getmap(-1)&0377)<<8;
			v |=  getmap(-1)&0377;
		} else {
			v  =  getmap(-1)&0377;
			v |= (getmap(-1)&0377)<<8;
		}
		return((v & s_mask) ? v | ~v_mask : v & v_mask);
	}
	if (c == '>' || c == '<') {
		v = exprx(v, 100);
		if (c == '>')
			v >>= (8 * as_msb);
		return(v&0377);
	}
	/*
	 * Temporary Radix Type ^[BOQDHX]
	 * Temporary Radix Type 0[BOQDHX]
	 */
	t = 0;
	if ((c == '^') || (c == '0')) {
		jp = ip;
		switch (ccase[get()]) {
		case 'b':  t = 2;	break;	/* 0B */
		case 'o':			/* 0O */
		case 'q':  t = 8;	break;	/* 0Q */
		case 'd':  t = 10;	break;	/* 0D */
		case 'h':  			/* 0H */
		case 'x':  t = 16;	break;	/* 0X */
		default:
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
		case '%':	t = 2;	break;
		case '&':	t = 8;	break;
		case '#':	t = 10;	break;
		case '@':	t = 16;	break;
		default:
			ip = jp;
			break;
		}
	}
	/*
	 * Process Temporary Radixes
	 */
	if (t) {
		/*
		 * Process An Immediate Number
		 */
		jp = ip;
		if (is_digit((c = getnb()), t)) {
			v = 0;
			while ((n = digit(c, t)) >= 0) {
				v = t*v + n;
				c = get();
			}
			unget(c);
			return((v & s_mask) ? v | ~v_mask : v & v_mask);
		}
		ip = jp;
		c = expr_radix;
		expr_radix = t;
		v = exprx(v, 100);
		expr_radix = c;
		return((v & s_mask) ? v | ~v_mask : v & v_mask);
	}
	/*
	 * Evaluate Numbers
	 * 	1) Beginning With Decimal Digits (0 - 9)
	 *	2) Beginning With Hex Digits (A - F)
	 *		If (r = 16) And
	 *		Does Not Contain (G - Z), ($), (_) Or (.)
	 *		And The String Is Not A Symbol/Label
	 */
	/* 1) */
	if (ctype[c] & DIGIT) {
		/*
		 * Check For Decimal Point Radix 10 Override
		 */
		jp = ip;
		n = c;
		while ((c >= '0') && (c <= '9')) {
			c = get();
		}
		if (c == '.') {
			r = 10;
		}
		c = n;
		ip = jp;
		/*
		 * Process Number
		 */
		v = 0;
		while ((n = digit(c, r)) >= 0) {
			v = r*v + n;
			c = get();
		}
		if (c != '.') {
			unget(c);
		}
		return((v & s_mask) ? v | ~v_mask : v & v_mask);
	}
	/* 2) */
	if ((ctype[c] & RAD16) && (r == 16)) {
		jp = ip;
		n = c;
		/*
		 * Scan For Non RAD16 LETTERs
		 * (G - Z), (.), ($), And (_)
		 */
		getid(id, c);
		ip = id;
		while (is_digit(c, 16)) { c = get(); }
		if ((c == 0) && !lkpsym(id, 0)) {
			c = n;
			ip = jp;
			/*
			 * Process Number
			 */
			v = 0;
			while ((n = digit(c, r)) >= 0) {
				v = r*v + n;
				c = get();
			}
			unget(c);
			return((v & s_mask) ? v | ~v_mask : v & v_mask);
		}
		c = n;
		ip = jp;
	}
	/*
	 * Evaluate Symbols and Labels
	 */
	if (ctype[c] & LETTER) {
		getid(id, c);
		if ((sp = lkpsym(id, 0)) == NULL) {
			fprintf(stderr, "?ASlink-Error-Undefined symbol %s\n", id);
			lkerr++;
			return(0);
		} else {
			return(symval(sp));
		}
	}
	fprintf(stderr, "?ASlink-Error-Unknown operator %c\n", c);
	lkerr++;
	return(0);
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
