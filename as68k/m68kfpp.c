/* m68kfpp.c */

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

#define	DENORMALS	1

/*
 * Calculation is done with intermediate mantissa precision
 * of PREC_BYTES. Higher PREC_BYTES will increase likelihood
 * of a true "nearest binary floating point representation"
 * of the number, but we can't guarantee this without using
 * arbitrary-precision calculations, which is overkill here.
 */
#define PREC_BYTES 12

/*
 * MAX_DIGITS sets how many decimal digits fit in PREC_BYTES.
 *   2 ^ (12 * 8) = 79228162514264337593543950336
 * Set to length of: 9999999999999999999999999999 (28 digits).
 */
#define MAX_DIGITS 28

/*
 * Description
 *
 *	Converts a floating point number written in scientific
 *	notation from ASCII to a "double" number.  The BNF for
 *	numbers which can be decoded by this routine follows:
 *
 *	    <number> := <sign> <real number>
 *	    <real number> :=
 *		<decimal number>
 *		| <decimal number> <exponent>
 *		| <exponent>
 *	    <decimal number> :=
 *		<integer>
 *		| <integer> .
 *		| . <integer>
 *		| <integer> . <integer>
 *	    <integer> := <digit> | <integer> <digit>
 *	    <exponent> :=
 *		{ E | e | D | d } <sign> <integer>
 *	    <digit> := 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
 *	    <sign> := + | - | <empty>
 *
 *	The conversion stops on the first non-legal character.
 */

/*
 * The Result Values For
 * Floating Conversions
 * In Word (16-Bit) Format
 */
unsigned short rslt[5];

/*
 * Table For Dealing With Exponents
 * See https://en.wikipedia.org/wiki/IEEE_754
 */
static struct {
	int exp_bits; /* size of field having sign bit and exponent */
	int exp_bias;
	int exp_min;
	int exp_max;
} exp_table[4] = {
#if 1 /* 68K version, half-precision is top 16 bits of single-precision */
	{9, 127, -126, 127}, /* Single-Precision */
#else
	{6, 15, -14, 15}, /* Half-Precision */
#endif
	{9, 127, -126, 127}, /* Single-Precision */
	{12, 1023, -1022, 1023}, /* Double-Precision */
	{16, 16383, -16382, 16383}, /* Extended-, Quad-Precision */
};

/*
 * Ascii Conversion To -
 *	16-Bit Half-Precision Floating Point		atowrd()
 *	32-Bit Single-Precision Floating Point		atoflt()
 *	64-Bit Double-Precision Floating Point		atodbl()
 *	80-Bit Extended-Precision Floating Point	atoext()
 *
 * Internal Arithmetic Coding Makes This
 * Code Compatable With Any Compiler Where
 * The Size Of 'int' Is At Least 16-Bits.
 */

unsigned char fbuf[PREC_BYTES];		/*	MAIN ACC.	*/
unsigned char fsav[PREC_BYTES];		/*	AUX. ACC.	*/
unsigned char fsav2[PREC_BYTES];	/*	AUX2. ACC.	*/
int	fsgn;		/*	SIGN.		*/

int	fbex;		/*	BINARY EXP.	*/
int	fexp;		/*	DECIMAL EXP.	*/
int	fdot;		/*	DOT FLAG.	*/
int	fesgn;		/*	EXP. SIGN.	*/

int	fcry;		/*	A Shift Or Add Carry */
#if 1 /* denormals */
int	fhid;		/*	Hidden Bit After Normalization */
#endif
int	fpt;		/*	Rounding Or Truncation */

/*
 * IEEE-754 Half-Precision Float Ordering (Most Significant First)
 *	MSB - fbuf[PREC_BYTES - 1]
 *	LSB - fbuf[PREC_BYTES - 2]
 */
VOID
atowrd()
{
	int ovrf;

	ovrf = atofd(0);	/* Specify Float Size */
	if (ovrf & 1) {
		xerr('w', "Floating Point Underflow");
	}
	if (ovrf & 2) {
		xerr('w', "Floating Point Overflow");
	}
#if 0
if (pass == 2) fprintf(stderr, "FLT16 = %4.4x\n", rslt[4]);
#endif
}

/*
 * IEEE-754 Single-Precision Float Ordering (Most Significant First)
 *	MSB - fbuf[PREC_BYTES - 1]
 *	       ...
 *	LSB - fbuf[PREC_BYTES - 4]
 */
VOID
atoflt()
{
	int ovrf;

	ovrf = atofd(1);	/* Specify Float Size */
	if (ovrf & 1) {
		xerr('w', "Floating Point Underflow");
	}
	if (ovrf & 2) {
		xerr('w', "Floating Point Overflow");
	}
#if 0
if (pass == 2) fprintf(stderr, "FLT32 = %4.4x %4.4x\n", rslt[4], rslt[3]);
#endif
}

/*
 * IEEE-754 Double-Precision Float Ordering (Most Significant First)
 *	MSB - fbuf[PREC_BYTES - 1]
 *	      ...
 *	LSB - fbuf[PREC_BYTES - 8]
 */
VOID
atodbl()
{
	int ovrf;

	ovrf = atofd(2);	/* Specify Double Size */

	if (ovrf & 1) {
		xerr('w', "Floating Point Underflow");
	}
	if (ovrf & 2) {
		xerr('w', "Floating Point Overflow");
	}
#if 0
if (pass == 2) fprintf(stderr, "FLT64 = %4.4x %4.4x %4.4x %4.4x\n", rslt[4], rslt[3], rslt[2], rslt[1]);
#endif
}

/*
 * IEEE-754 Extended-Precision Float Ordering (Most Significant First)
 *	MSB - fbuf[PREC_BYTES - 1]
 *	      ...
 *	LSB - fbuf[PREC_BYTES - 10]
 */
VOID
atoext()
{
	int ovrf;

	ovrf = atofd(3);	/* Specify Double Size */

	if (ovrf & 1) {
		xerr('w', "Floating Point Underflow");
	}
	if (ovrf & 2) {
		xerr('w', "Floating Point Overflow");
	}
#if 0
if (pass == 2) fprintf(stderr, "FLT80 = %4.4x %4.4x %4.4x %4.4x %4.4x\n", rslt[4], rslt[3], rslt[2], rslt[1], rslt[0]);
#endif
}

/*
 *	THIS ROUTINE IS BASED ON THE ROUTINE IN MACRO-11 THAT
 *	PROCESSES THE ".FLT2" AND ".FLT4" PSEUDO OPERATIONS.
 *		|   IT CAN ALSO BE FOUND IN FILE     |
 *		| CC101.MAC OF THE DECUS C COMPILER. |
 */

int
atofd(fd)
int fd;
{
	int c, i, v;
#if DENORMALS	/* denormals */
	int end;
#endif
	int ovrf;

	/*
	 * Scan For Value Sign
	 */
	fsgn = 0;
	if ((c = getnb()) == '-') {
		fsgn = 0x8000;
	} else
	if (c != '+') {
		unget(c);
	}

	/*
	 * Process Ascii String
	 */
	v = 0; /* Count Of Digits So Far */
	fltzr(); /* Value Of Digits So Far */
	fexp = 0; /* Decimal Exponent So Far */
	fdot = 0; /* Flag For Decimal Point */
	ovrf = 0; /* Flag For Overflow And Underflow */
	while (1) {
		/* Scan For Digits */
		c = get();
		if ((c >= '0') && (c <= '9')) {
			if (v >= MAX_DIGITS) {
				/* Too Many Digits, Adjust Scale */
				fexp += 1;
			} else
			if ((v != 0) || (c != '0')) {
				/* Not Leading Zero, Add In Digit */
				v += 1;
				fltnd(10, c - '0');
			}
			/* fdot Is -1 After '.' */
			fexp += fdot;
			continue;	/* Loop Until No More Digits */
		}
		/*
		 * Scan For '.'
		 */
		if (c == '.') {
			if ((fdot -= 1) == -1) {
				continue;	/* Loop For Digits After '.' */
			}
			xerr('q', "Second '.' Is Not Allowed");
		}
		/*
		 * Check For An Exponent
		 */
		if ((c != 'E') && (c != 'e')) {
			unget(c);
			break;	/* No Exponent - Finished */
		}

		/*
		 * Scan For Exponent Sign
		 */
		fesgn = 0;
		if ((c = get()) == '-') {
			fesgn = 1;
		} else
		if (c != '+') {
			unget(c);
		}

		/*
		 * Process Exponent Digits
		 */
		v = 0;
		while (((c = get()) >= '0') && (c <= '9')) {
			v = v * 10 + (c - '0');
		}
		unget(c);

		/*
		 * Fix Up Exponent With Sign
		 */
		if (fesgn) {
			fexp -= v;
		} else {
			fexp += v;
		}
		break;	/* Evaluation Finished */
	}

	/*
	 * If Evaluation Is Not 0 Then Check Scaling
	 */
	if (fltnz()) {
		/*
		 * Convert Integer To Floating Point
		 * e.g. 0x12345678 => 0.12345678 * 2 ^ 32
		 * Note: fbuf = Mantissa, fbex = Exponent of Input Value
		 */
		fbex = PREC_BYTES * 8;

		/*
		 * Normalize Floating Point
		 */
		fcry = 0;
		while (fbuf[PREC_BYTES - 1] == 0) {
			fltls8();
			fbex -= 8;
		}
		while ((fbuf[PREC_BYTES - 1] & 0x80) == 0) {
			fltls();
			fbex -= 1;
		}

		/*
		 * When fexp >= 0, Multiply fsav2 By 10 ^ fexp
		 * When fexp < 0, Multiply fsav2 By 0.1 ^ -fexp
		 * Use Successive Squaring For Efficient Computation, Keeping
		 * Successive Squares In Floating Point To Maintain Precision
		 * Note: fsav = Mantissa, fdot = Exponent Of Squaring Value
		 * Note: fsav2 = Mantissa, fbex = Exponent Of Input Value
		 * Note: Highest Bit Of fsav, fsav2 Are Guaranteed To Be 1
		 */
		if (fexp >= 0) {
			/* load value fsav = 0.A000... * 2^4 = 10 */
			for (i=0; i<PREC_BYTES-1; ++i) {
				fsav[i] = 0;
			}
			fsav[PREC_BYTES - 1] = 0xA0;
			fdot = 4;
		}
		else {
			fexp = -fexp;

			/* load value fsav = 0.CCCC... * 2^-3 = 0.1 */
			for (i=0; i<PREC_BYTES; ++i) {
				fsav[i] = 0xCC;
			}
			fdot = -3;
		}
		fltsv2();
		while (1) {
			if (fexp & 1) {
				/* fsav2 *= fsav */
				fltml();
				fbex += fdot;
				if ((fbuf[PREC_BYTES - 1] & 0x80) == 0) {
					fltls(); /* restores shifted-out bit */
					fbex -= 1;
				}
				fltsv2();
			}
			fexp >>= 1;
			if (fexp == 0) {
				break;
			}

			/* fsav *= fsav */
			fltsq();
			fdot <<= 1;
			if ((fbuf[PREC_BYTES - 1] & 0x80) == 0) {
				fltls(); /* restores shifted-out bit */
				fdot -= 1;
			}
			fltsv();
		}
		fltld2();

		/*
		 * Normalize Fraction
		 * Gobble Up The Hidden Bit
		 */
#if DENORMALS	/* denormals */
		end = exp_table[fd].exp_min;
		while (fbex < end - 7) {
			fcry = 0;
			fltrs8();
			fbex += 8;
			if (fltnz() == 0) {
				ovrf |= 0x01;	/* Underflow */
				fbex = end;
				break;
			}
		}
		while (fbex < end) {
			fcry = 0;
			fltrs();
			fbex += 1;
			if (fltnz() == 0) {
				ovrf |= 0x01;	/* Underflow */
				fbex = end;
				break;
			}
		}
		fcry = 0;
		if (fbex > end) {
			fltls();
			fbex -= 1;
		}
		fhid = fcry;
#else
		fcry = 0;
		fltls();
		fbex -= 1;
#endif

		/*
		 * Floating Point Rounding/Truncation
		 */
		if (fpt == 0) {
			for (i=0; i<PREC_BYTES; i++) {
				fsav[i] = 0;
			}
			switch(fd) {
#if 1 /* 68K version, half-precision is top 16 bits of single-precision */
			case 0:	fsav[PREC_BYTES - 1] = 1;	break;	/* Half-Precision (7 bits) */
#else
			case 0:	fsav[PREC_BYTES - 2] = 0x20;	break;	/* Half-Precision (12 bits) */
#endif
			case 1:	fsav[PREC_BYTES - 3] = 1;	break;	/* Single-Precision (23 bits) */
			case 2:	fsav[PREC_BYTES - 7] = 8;	break;	/* Double-Precision (52 bits) */
			case 3:	fsav[PREC_BYTES - 8] = 1;	break;	/* Extended-Precision (63 bits) */
			}
			fltad();

			/*
			 * If No OverFlow Then Hidden Bit Still '1'
			 * Else Overflow Complements The Hidden Bit.
			 */
			if (fcry) {
#if DENORMALS	/* denormals */
				if (fhid) {
					fcry = 0;
					fltrs();
					fbex += 1;
				}
				else {
					fhid = 1;
				}
#else
				fcry = 0;
				fltrs();
				fbex += 1;
#endif
			}
		}

		/*
		 * Make Hidden Bit Explicit For Extended-Precision
		 */
		if (fd == 3) {
#if DENORMALS	/* denormals */
			fcry = fhid;
#else
			fcry = 0;
#endif
			fltrs();
		}

		/*
		 * Prepare And Check Exponent
		 */
#if DENORMALS	/* denormals */
		if (fhid == 0) {
			/*
			 * At This Point fbex == exp_table[fd].exp_min,
			 * Return Sentinel Value Based On Minimum - 1
			 */
			fbex = 0;
		}
		else {
			if (fbex > exp_table[fd].exp_max) {
				ovrf |= 0x02;	/* Overflow */
			}
			fbex += exp_table[fd].exp_bias;
		}
#else
		if (fbex < exp_table[fd].exp_min) {
			ovrf |= 0x01;	/* Underflow */
		} else
		if (fbex > exp_table[fd].exp_max) {
			ovrf |= 0x02;	/* Overflow */
		}
		fbex += exp_table[fd].exp_bias;
#endif

		/*
		 * Assemble Floating Result
		 */
		v = exp_table[fd].exp_bits;
		for (i=0; i<v; i++) {			/* Move Fraction Into Position */
			fcry = 0;
			fltrs();
		}
		for (i=0; i<5; i++) {			/* Build Result Fraction */
			rslt[i] = (fbuf[PREC_BYTES-9+2*i] << 8) | fbuf[PREC_BYTES-10+2*i];
		}
		rslt[4] |= ((fbex << (16 - v)) & 0x7FFF);
	} else {
		for (i=0; i<5; i++) {
			rslt[i] = 0;
		}
	}
	rslt[4] |= fsgn;
	/*
	 * Return Error Flags
	 */
	return(ovrf);
}

/*
 * This is taken from term() in asexpr.c and evaluates a quad-word constant.
 * The constant is returned in rslt[0] (least significant) through rslt[3].
 */
VOID
atoint()
{
	int r, c, sign;
	char *jp;
	int i, v;

	r = radix;
	c = getnb();

	/*
	 * Scan For Sign
	 */
	sign = '+';
	if ((c == '-') || (c == '+')) {
		sign = c;
		c = getnb();
	}

	/*
	 * Evaluate digit sequences as constants.
	 */
	fltzr();
	if (ctype[c] & DIGIT) {
		jp = ip;
		if (c == '0') {
			c = get();
			switch (c) {
				case 'b':
				case 'B':
					r = 2;
					c = get();
					break;
				case 'o':
				case 'O':
				case 'q':
				case 'Q':
					r = 8;
					c = get();
					break;
				case 'd':
				case 'D':
					r = 10;
					c = get();
					break;
				case 'h':
				case 'H':
				case 'x':
				case 'X':
					r = 16;
					c = get();
					break;
				default:
					c = '0';
					ip = jp;
					break;
			}
		}

		/*
		 * Check For Decimal Point Radix 10 Selection
		 */
		if (jp == ip) {
			v = c;
			while ((c >= '0') && (c <= '9')) {
				c = get();
			}
			if (c == '.') {
				r = 10;
			}
			c = v;
			ip = jp;
		}

		while ((v = digit(c, r)) >= 0) {
			fltnd(r, v);
			c = get();
		}
		if (c != '.') {
			unget(c);
		}
	} else {
		/*
		 * Evaluate '$' sequences as a temporary radix
		 * if followed by a '%', '&', '#', or '@'.
		 */
		if (c == '$') {
			switch (get()) {
			case '%':
				r = 2;
				break;
			case '&':
				r = 8;
				break;
			case '#':
				r = 10;
				break;
			case '@':
				r = 16;
				break;
			default:
				qerr();
				break;
			}
			c = get();
		} else {
			qerr();
		}

		while ((v = digit(c, r)) >= 0) {
			fltnd(r, v);
			c = get();
		}
	}

	/*
	 * Apply Sign
	 */
	if (sign == '-') {
		fcry = 1;
		for (i=0; i<8; i++) {
			fcry += fbuf[i] ^ 0xFF;
			fbuf[i] = fcry & 0xFF;
			fcry >>= 8;
		}
	}

	/*
	 * Assemble Integer Result
	 */
	for (i=0; i<4; i++) {
		rslt[i] = (fbuf[2*i+1] << 8) | fbuf[2*i];
	}
}

/*
 * These Functions Perform Arithmetic
 * Using Byte Values.  This Insures
 * That Values Never Exceed The Size
 * Of A Short Integer (16-Bits).
 */

/*
 * Zero 'fbuf'
 */
VOID
fltzr()
{
	int i;

	for (i=0; i<PREC_BYTES; i++) {
		fbuf[i] = 0;
	}
}

/*
 * Test 'fbuf' For Zero
 */
int
fltnz()
{
	int i;

	for (i=0; i<PREC_BYTES; i++) {
		if (fbuf[i]) {
			return 1;
		}
	}
	return 0;
}

/*
 * Move 'fbuf' To 'fsav'
 */
VOID
fltsv()
{
	int i;

	for (i=0; i<PREC_BYTES; i++) {
		fsav[i] = fbuf[i];
	}
}

/*
 * Move 'fsav2' To 'fbuf'
 */
VOID
fltld2()
{
	int i;

	for (i=0; i<PREC_BYTES; i++) {
		fbuf[i] = fsav2[i];
	}
}

/*
 * Move 'fbuf' To 'fsav2'
 */
VOID
fltsv2()
{
	int i;

	for (i=0; i<PREC_BYTES; i++) {
		fsav2[i] = fbuf[i];
	}
}

/*
 * Right Shift 'fbuf' Circularly Through 'fcry' By 1 Bit
 * Note: 'fcry' Bit 0 Is Shifted In, Bit 7 Receives Shifted Out Bit
 */
VOID
fltrs()
{
	int i, temp;

	temp = fcry;
	fcry = ((fcry >> 1) | (fbuf[0] << 7)) & 0xFF;
	for (i=0; i<PREC_BYTES-1; i++) {
		fbuf[i] = ((fbuf[i] >> 1) | (fbuf[i + 1] << 7)) & 0xFF;
	}
	fbuf[PREC_BYTES - 1] = ((fbuf[PREC_BYTES - 1] >> 1) | (temp << 7)) & 0xFF;
}

/*
 * Right Shift 'fbuf' Circularly Through 'fcry' By 8 Bits
 */
VOID
fltrs8()
{
	int i, temp;

	temp = fcry;
	fcry = fbuf[0];
	for (i=0; i<PREC_BYTES-1; i++) {
		fbuf[i] = fbuf[i + 1];
	}
	fbuf[PREC_BYTES - 1] = temp;
}

/*
 * Left Shift 'fbuf' Circularly Through 'fcry' By 1 Bit
 * Note: 'fcry' Bit 7 Is Shifted In, Bit 0 Receives Shifted Out Bit
 */
VOID
fltls()
{
	int i, temp;

	temp = fcry;
	fcry = ((fcry << 1) | (fbuf[PREC_BYTES - 1] >> 7)) & 0xFF;
	for (i=PREC_BYTES-1; i>=1; i--) {
		fbuf[i] = ((fbuf[i] << 1) | (fbuf[i - 1] >> 7)) & 0xFF;
	}
	fbuf[0] = ((fbuf[0] << 1) | (temp >> 7)) & 0xFF;
}

/*
 * Left Shift 'fbuf' Circularly Through 'fcry' By 8 Bits
 */
VOID
fltls8()
{
	int i, temp;

	temp = fcry;
	fcry = fbuf[PREC_BYTES - 1];
	for (i=PREC_BYTES-1; i>=1; i--) {
		fbuf[i] = fbuf[i - 1];
	}
	fbuf[0] = temp;
}

/*
 * New Digit
 *
 * Set 'fbuf' = 'fbuf' * base + digit
 *
 * 'fcry' Returns Any Overflow/Carry Bit(s)
 */
VOID
fltnd(base, digit)
int base, digit;
{
	int i;
	unsigned int acc; /* acc must be unsigned when int is 16-bit */

	acc = digit;
	for (i=0; i<PREC_BYTES; i++) {
		acc += fbuf[i] * base;
		fbuf[i] = acc & 0xFF;
		acc >>= 8;
	}
	fcry = acc;
}

/*
 * Add 'fsav' To 'fbuf'
 *
 * 'fcry' Is Set To Carry From The Addition
 */
VOID
fltad()
{
	int i;

	fcry = 0;
	for (i=0; i<PREC_BYTES; i++) {
		fcry += fbuf[i] + fsav[i];
		fbuf[i] = fcry & 0xFF;
		fcry >>= 8;
	}
}

/*
 * Let 'fbuf' = High Half Of 'fsav' * 'fsav'
 *
 * 'fcry' Is Set To High Byte Of Low Half Of Result
 */
VOID
fltsq()
{
	int i, j, v;
	unsigned int acc; /* acc must be unsigned when int is 16-bit */

	fltzr();
	for (i=0; i<PREC_BYTES; i++) {
		v = fsav[i];
		acc = 0;
		for (j=0; j<PREC_BYTES; j++) {
			acc += fbuf[j] + v * fsav[j];
			fbuf[j] = acc & 0xFF;
			acc >>= 8;
		}
		fcry = acc;
		fltrs8();
	}
}

/*
 * Let 'fbuf' = High Half Of 'fsav' * 'fsav2'
 *
 * 'fcry' Is Set To High Byte Of Low Half Of Result
 */
VOID
fltml()
{
	int i, j, v;
	unsigned int acc; /* acc must be unsigned when int is 16-bit */

	fltzr();
	for (i=0; i<PREC_BYTES; i++) {
		v = fsav2[i];
		acc = 0;
		for (j=0; j<PREC_BYTES; j++) {
			acc += fbuf[j] + v * fsav[j];
			fbuf[j] = acc & 0xFF;
			acc >>= 8;
		}
		fcry = acc;
		fltrs8();
	}
} 
