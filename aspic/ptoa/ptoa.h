/* PtoA.h */

/*
 *  Copyright (C) 2002-2025  Alan R. Baldwin
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

#define	VERSION	"V05.50"

#include <stdio.h>
#include <stdlib.h>
#include <setjmp.h>
#include <string.h>

/* Default void definition */
/* File/extension seperator */

#define	VOID	void
#define	FSEPX	'.'

/*
 * Error definitions
 */
#define	ER_NONE		0	/* No error */
#define	ER_WARNING	1	/* Warning */
#define	ER_ERROR	2	/* Process error */
#define	ER_FATAL	3	/* Fatal error */


#define NCPS	80		/* Characters per symbol */
#define NINPUT	128		/* Input buffer size */
#define	FILSPC	80		/* Chars. in filespec */


extern	char	afn[FILSPC];	/*	current input file specification
				 */
extern	int	afp;		/*	current input file path length
				 */
extern	char	afntmp[FILSPC];	/*	temporary input file specification
				 */
extern	int	afptmp;		/*	temporary input file path length
				 */

extern	int	zflag;		/*	-z, enable symbol case sensitivity
				 */

extern	char	*ip;		/*	pointer into the source
				 *	text line in ib[]
				 */
extern	char	ib[NINPUT*2];	/*	source text line for processing
				 */
extern	FILE	*ifp;		/*	input file handle
				 */
extern	FILE	*ofp;		/*	output file handle
				 */

extern	char	ctype[128];	/*	array of character types, one per
				 *	ASCII character
				 */
extern	char	ccase[128];	/*	an array of characters which 
				 *	perform the case translation function
				 */
/*
 * Definitions for Character Types
 */
#define	SPACE	'\000'
#define ETC	'\000'
#define	LETTER	'\001'
#define	DIGIT	'\002'
#define	BINOP	'\004'
#define	RAD2	'\010'
#define	RAD8	'\020'
#define	RAD10	'\040'
#define	RAD16	'\100'
#define	ILL	'\200'

#define	DGT2	(DIGIT|RAD16|RAD10|RAD8|RAD2)
#define	DGT8	(DIGIT|RAD16|RAD10|RAD8)
#define	DGT10	(DIGIT|RAD16|RAD10)
#define	LTR16	(LETTER|RAD16)

/*
 *	The def structure is used by the cnvstr assembler
 *	directive to define a substitution string for a
 *	single word.  The def structure contains the
 *	string being defined, the string to substitute
 *	for the defined string, and a link to the next
 *	def structure.  The defined string is a sequence
 *	of characters not containing any white space
 *	(i.e. NO SPACEs or TABs).  The substitution string
 *	may contain SPACES and/or TABs.
 */
extern struct def
{
	char		*d_id;		/* defined string */
	char		*d_define;	/* string to substitute for defined string */
};

extern	struct	def	defk[];		/* key word definitions list */
extern	struct	def	defs[];		/* substitution definitions list */


/* pictoasx functions */

/* pictoasx.c */
extern	FILE *		afile(char *fn, char *ft, int wf);
extern	VOID		afilex(char *fn, char *ft);
extern	VOID		ptoaexit(int i);
extern	int		changekey(char *id);
extern	VOID		changestr(void);
extern	VOID		chopcrlf(char *str);
extern	VOID		cnvhex(void);
extern	int		fndidx(char *str);
extern	int		get(void);
extern	VOID		getid(char *id, int c);
extern	int		getnb(void);
extern	int		main(int argc, char *argv[]);
extern	int		more(void);
extern	int		nxtline(void);
extern	VOID		scanline(void);
extern	int		symeq(char *p1, char *p2, int flag);
extern	int		symeqn(char *p1, char *p2, int flag, int n);
extern	VOID		unget(int c);
extern	VOID		usage(int n);
extern	char *		usetxt[];
extern	char		endline(void);

