/* ppcfpp.c */

/*
 *  Copyright (C) 2022-2025  Alan R. Baldwin
 *  Copyright (C) 2022-2025  Nick Downing
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
#include "ppc.h"

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
unsigned int rslt[4];

/*
 * Ascii Conversion To -
 *	32-Bit Floating Point		atoflt()
 *	64-Bit Double Floating Point	atodbl()
 *
 * Internal Arithmetic Coding Makes This
 * Code Compatable With Any Compiler Where
 * The Size Of 'int' Is At Least 16-Bits.
 */

int	fbuf[8];	/*	MAIN ACC.	*/
int	fsav[8];	/*	AUX. ACC.	*/
int	fsgn;		/*	SIGN.		*/

int	fbex;		/*	BINARY EXP.	*/
int	fexp;		/*	DECIMAL EXP.	*/
int	fdot;		/*	DOT FLAG.	*/
int	fesgn;		/*	EXP. SIGN.	*/

int	fcry;		/*	A Shift Or Add Carry */
int	fpt;		/*	Rounding Or Truncation */

/*
 * PowerPC 1 Word Float Ordering (Most Significant First)
 *	MSB - fbuf[7]
 *	LSB - fbuf[6]
 */
void
atowrd(void)
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
if (pass == 2) fprintf(stderr, "FLT32 = %6.6o %6.6o\n", rslt[3], rslt[2]);
#endif
}

/*
 * PowerPC 2 Word Float Ordering (Most Significant First)
 *	MSB - fbuf[7]
 *	       ...
 *	LSB - fbuf[4]
 */
void
atoflt(void)
{
	int ovrf;

	ovrf = atofd(1);	/* Specify Float Size */
	if (ovrf & 1) {
		xerr('w', "Floating Point Underflow");
	}
	if (ovrf & 2) {
		xerr('w', "Floating Point Overflow");
	}
	if (ovrf & 8) {
		xerr('w', "Use An 'E' When Specifying A Single Precision Float");
	}
#if 0
if (pass == 2) fprintf(stderr, "FLT32 = %6.6o %6.6o\n", rslt[3], rslt[2]);
#endif
}

/*
 * PowerPC 4 Word Float Ordering (Most Significant First)
 *	MSB - fbuf[7]
 *	      ...
 *	LSB - fbuf[0]
 */
void
atodbl(void)
{
	int ovrf;

	ovrf = atofd(2);	/* Specify Double Size */

	if (ovrf & 1) {
		xerr('w', "Floating Point Underflow");
	}
	if (ovrf & 2) {
		xerr('w', "Floating Point Overflow");
	}
	if (ovrf & 4) {
		xerr('w', "Use A 'D' When Specifying A Double Precision Float");
	}
#if 0
if (pass == 2) fprintf(stderr, "FLT64 = %6.6o %6.6o %6.6o %6.6o\n", rslt[3], rslt[2], rslt[1], rslt[0]);
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
	int expv;
	int ovrf;

	/*
	 * Initialize Work Variables
	 */
	fsgn = 0;
	fbex = 65;
	for (i=0; i<=7; i++) {
		fbuf[i] = 0;
		fsav[i] = 0;
	}
	fexp = 0;
	fdot = 0;
	fesgn = 0;

	expv = 0;
	ovrf = 0;

	/*
	 * Scan For Value Sign
	 */
	if ((c = getnb()) == '+') {
		;
	} else
	if (c == '-') {
		fsgn ^= 0x8000;
	} else {
		unget(c);
	}
	/*
	 * Process Ascii String
	 */
	while (1) {
		/* Scan For Digits */
		c = get();
		if ((c >= '0') && (c <= '9')) {
			v = c - '0';
			if ((fbuf[7] & 0376) == 0) {
				/* Room For Digit */
				fltm5();	/* Multiply By 10 */
				fltls();
				fsav[0] = v;
				for (i=1; i<=7; i++) {
					fsav[i] = 0;
				}
				/* Add In Digit */
				fltad();	/* Overflow Will Increment fbex */
			} else {
				/* No, Adjust Scale */
				fexp += 1;
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
		 *Scan For An Exponent
		 */
		if ((c == 'E') || (c == 'e')) {
			ovrf |= 0x04;	/* FLT32 */
		} else
		if ((c == 'D') || (c == 'd')) {
			ovrf |= 0x08;	/* FLT64 */
		} else {
			unget(c);
			break;	/* No Exponent - Finished */
		}
		/*
		 * Scan For Exponent Sign
		 */
		if ((c = get()) == '+') {
			;
		} else
		if (c == '-') {
			fesgn ^= 1;
		} else {
			unget(c);
		}
		/*
		 * Process Exponent Digits
		 */
		while (((c = get()) >= '0') && (c <= '9')) {
			expv = expv*10 + (c - '0');
		}
		unget(c);
		/*
		 * Fix Up Exponent With Sign
		 */
		if (fesgn) {
			fexp -= expv;
		} else {
			fexp += expv;
		}
		break;	/* Evaluation Finished */
	}
	/*
	 * If Evaluation Is Not 0 Then Check Scaling
	 */
	for (v=0,i=0; i<=7; i++) {
		v |= fbuf[i];
	}
	if (v) {
		while (fexp) {
			if (fexp > 0) {
				/*
				 * The Floating Point Fraction
				 * Is Expressed in 64 Bits (8 Bytes).
				 * The largest Value In 8 Bits Which
				 * Can Be Multiplied By 5 And Not Overflow
				 * Is 51. (= 255/5)
				 * If The Remaining 56 Bits Are All '1's
				 * Then Accounting For The Shift of 2 Bit
				 * Positions (x4) Plus The Addition Of The
				 * The Original Bits Plus The Carry From
				 * The 56 Bits: The Largest Value Must Be
				 * 50. Or Less. Adding A Guard Count Of 1
				 * Results In A Test Value of 49.
				 */
				if (fbuf[7] <= 49) {
					fltm5();
					fbex += 1;
				} else {
					fltm54();
					fbex += 3;
				}
				fexp -= 1;	/* Loop Until fexp = 0 */
			} else
			if (fexp < 0) {
				/*
				 * Left Justify
				 */
				while ((fbuf[7] & 0x80) == 0) {
					fbex -= 1;
					fltls();
				}
				/*
				 * Perform A 64 Bit Divide By 10
				 */
				fltrs();
				fltsv();
				for (i=0; i<32; i++) {
					if ((i & 1) == 0) {
						fltrs();
						fltrs();
					}
					fltrs();
					fltad();	/* Overflow Will Increment fbex */
				}
				fbex -= 3;
				fexp += 1;	/* Loop Until fexp = 0 */
			}
		}

		/*
		 * Normalize Fraction
		 * Gobble Up The Hidden Bit
		 */
		do {
			fbex -= 1;
			fltls();
		} while (fcry == 0);
		/*
		 *   .FLT32 Or .FLT64
		 * Decimal Point Rounding
		 */
	 	for (i=0; i<=7; i++) {
			fsav[i] = 0;
		}
		/*
		 * Floating Point Rounding/Truncation
		 */
		if (fpt == 0) {
			switch(fd) {
			case 0:	fsav[6] += 0x80;	break;	/* 1 Word Float */
			case 1:	fsav[4] += 0x80;	break;	/* 2 Word Float */
			case 2:	fsav[0] += 0x80;	break;	/* 4 Word Float */
			default:	break;
			}
			fltad();	/* Overflow Will Increment fbex */
			/*
			 * If No OverFlow Then Hidden Bit Still '1'
			 * Else Overflow Complements The Hidden Bit.
			 */
			if (fcry) {
				fltrs();
			}
		}
		/*
		 * Excess 128 Notation
		 * Check For Underflow / Overflow
		 */
		fbex += 128;
		if (fbex < 0) {
			ovrf |= 0x01;	/* Underflow */
		} else
		if (fbex > 255) {
			ovrf |= 0x02;	/* Overflow */
		}
		/*
		 * Assemble Floating Result
		 */
		for (i=0; i<9; i++) {			/* Move Fraction Into Position */
			fltrs();
		}
		for (i=0; i<=3; i++) {			/* Build Result Fraction */
			rslt[i] = ((fbuf[2*i+1] & 0xFF) << 8) | fbuf[2*i];
		}
		rslt[3] &= 0x007F;			/* Mask 'Hidden' Bit */
		rslt[3] |= ((fbex & 0xFF) << 7);	/* Merge Exponent */
		rslt[3] |= fsgn;			/* Merge Sign Bit */
	} else {
		for (i=0; i<=3; i++) {
			rslt[i] = 0;
		}
	}
	/*
	 * Return Error Flags
	 */
	return(ovrf);
}

/*
 * These Functions Perform Arithmetic
 * Using Byte Values.  This Insures
 * That Values Never Exceed The Size
 * Of A Short Integer (16-Bits).
 */

/*
 * Move 'fbuf' To 'fsav'
 */
void
fltsv(void)
{
	int i;

	for (i=0; i<=7; i++) {
		fsav[i] = fbuf[i];
	}
}

/*
 * Right Shift 'fbuf'
 */
void
fltrs(void)
{
	int i;

	for (i=0; i<=6; i++) {
		if (i == 0) fcry = (fbuf[0] & 0x01) ? 1 : 0;
		fbuf[i] >>= 1;
		if (fbuf[i+1] & 0x01) {
			fbuf[i] |= 0x80;
		}
	}
	fbuf[7] >>= 1;
}

/*
 * Left Shift 'fbuf'
 */
void
fltls(void)
{
	int	i;

	for (i=7; i>=0; i--) {
		if (i == 7) fcry = (fbuf[7] & 0x80) ? 1 : 0;
		fbuf[i] <<= 1;
		fbuf[i] &= 0xFE;
		if (i > 0) {
			if (fbuf[i-1] & 0x80) fbuf[i] |= 0x01;
		}
	}
}

/*
 * Multiply By 5/4
 *
 * For An 8 Bit Value The Multiplication
 * By 5/4 Will Overflow For A Value Of 204
 * When The Remaining 56 Bits Of The Fraction
 * Are '1's.  Thus A Test Value of 202
 * (With A Guard Value of 1) Is Selected.
 */
void
fltm54(void)
{
	if (fbuf[7] >= 202) {
		fltrs();
		fbex += 1;
	}
	fltsv();
	fltrs();
	fltrs();
	fltad();
}

/*
 * Multiply By Five
 */
void
fltm5(void)
{
	fltsv();
	fltls();
	fltls();
	fltad();	/* Overflow Will Increment fbex */
}

/*
 * Add 'fsav' To 'fbuf'
 *
 * 'fcry' Is Set If (fbuf + fsav) Exceeds 64 Bits
 */
void
fltad(void)
{
	int i;

	for (i=0; i<=7; i++) {
		fbuf[i] += fsav[i];
		if (i < 7) {
			fbuf[i+1] += (fbuf[i] >> 8);
			fbuf[i] &= 0xFF;
		}
		fcry = (fbuf[7] >> 8) ? 1 : 0;
		fbex += fcry;
		fbuf[7] &= 0xFF;
	}
}

