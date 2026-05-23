/* lkmain.c */

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
 */

#include "aslink.h"

/*)Module	lkmain.c
 *
 *	The module lkmain.c contains the functions which
 *	(1) input the linker options, parameters, and specifications
 *	(2) perform a two pass link
 *	(3) produce the appropriate linked data output and/or
 *	    link map file and/or relocated listing files.
 *
 *	lkmain.c contains the following functions:
 *		FILE *	afile()
 *		void	areasav()
 *		void	banksav()
 *		void	glblsav()
 *		int	intsiz()
 *		void	link()
 *		void	lkexit()
 *		char *	filespec()
 *		int	fndext()
 *		int	fndidx()
 *		int	main()
 *		void	map()
 *		int	parse()
 *		void	doparse()
 *		void	setgbl()
 *		void	usage()
 *
 *	lkmain.c contains the following local variables:
 *		char *	usetext[]	array of pointers to the
 *					command option text lines
 *
 */

/*)Function	int	main(argc, argv)
 *
 *		int	argc		number of command line arguments + 1
 *		char *	argv[]		array of pointers to the command line
 *					arguments
 *
 *	The function main() evaluates the command line arguments to
 *	determine if the linker parameters are to input through 'stdin'
 *	or read from a command file.  The functions nxtline() and parse()
 *	are to input and evaluate the linker parameters.  The linking process
 *	proceeds by making the first pass through each .rel file in the order
 *	presented to the linker.  At the end of the first pass the setbase(),
 *	lnkarea(), setgbl(), and symdef() functions are called to evaluate
 *	the base address terms, link all areas, define global variables,
 *	and look for undefined symbols.  Following these routines a linker
 *	map file may be produced and the linker output files may be opened.
 *	The second pass through the .rel files will output the linked data
 *	in one of the supported formats.
 *
 *	local variables:
 *		int	c		character from argument string
 *		int	i		loop counter
 *		int	j		loop counter
 *		int	k		loop counter
 *
 *	global variables:
 *				 	text line in ib[]
 *		lfile	*cfp		The pointer *cfp points to the
 *				 	current lfile structure
 *		char	ctype[]		array of character types, one per
 *				 	ASCII character
 *		time_t	curtim		current time string pointer
 *		lfile	*filep	 	The pointer *filep points to the
 *				 	beginning of a linked list of
 *				 	lfile structures.
 *		head	*hp		Pointer to the current
 *				 	head structure
 *		char	ib[NINPUT]	.rel file text line
 *		char	*ip		pointer into the .rel file
 *		lfile	*linkp		pointer to first lfile structure
 *				 	containing an input .rel file
 *				 	specification
 *		int	lkerr		error flag
 *		int	mflag		Map output flag
 *		int	oflag		Output file type flag
 *		FILE	*ofp		Output file handle
 *				 	for word formats
 *		FILE	*ofph		Output file handle
 *				 	for high byte format
 *		FILE	*ofpl		Output file handle
 *				 	for low byte format
 *		a_uint	p_mask		memory page length mask
 *		int	pass		linker pass number
 *		int	pflag		print linker command file flag
 *		int	radix		current number conversion radix
 *		FILE	*sfp		The file handle sfp points to the
 *				 	currently open file
 *		lfile	*startp		aslink startup file structure
 *		FILE *	stdout		c_library
 *
 *	functions called:
 *		void	chkbank()	lkbank.c
 *		int	fclose()	c_library
 *		int	fprintf()	c_library
 *		void	library()	lklibr.c
 *		void	link()		lkmain.c
 *		void	lkexit()	lkmain.c
 *		void	lkfopen()	lkbank.c
 *		void	lnkarea()	lkarea.c
 *		void	map()		lkmain.c
 *		void	new()		lksym.c
 *		int	nxtline()	lklex.c
 *		int	parse()		lkmain.c
 *		void	reloc()		lkreloc.c
 *		void	search()	lklibr.c
 *		void	setarea()	lkarea.c
 *		void	setbank()	lkbank.c
 *		void	setgbl()	lkmain.c
 *		char *	sprintf()	c_library
 *		void	symdef()	lksym.c
 *		time_t	time()		c_library
 *		void	usage()		lkmain.c
 *
 *	side effects:
 *		Completion of main() completes the linking process
 *		and may produce a map file (.map) and/or a linked
 *		data files (.ihx or .s19) and/or one or more
 *		relocated listing files (.rst).
 */

int
main(int argc, char *argv[])
{
	char *p;
	int c, i;

	if (argc == 1) {
		usage();
		exit(ER_NONE);
	}

	if (intsiz() < 4) {
		fprintf(stderr, "?ASlink-Error-Size of INT32 is not 32 bits or larger.\n\n");
		exit(ER_FATAL);
	}

	fprintf(stdout, "\n");

	outnam = NULL;
	outext = NULL;

	startp = (struct lfile *) new (sizeof (struct lfile));
	startp->f_idp = "";

	pflag = 1;

	for(i=1; i<argc; i++) {
		ip = ib;
		p = argv[i];
		if(*p == '-') {
			if (linkp != NULL) {
				usage();
				fprintf(stderr, "?ASlink-Error-Options come first\n");
				lkexit(ER_FATAL);
			}
			++p;
			while((c = *p++) != '\0') {
				ip = ib;
				sprintf(ip, "-%c", c);
				switch(c) {

				/*
				 * Options with options
				 */
				case 'm':
				case 'M':
					if (*p == '1') {
						sprintf(ip+2, "%c", *p++);
					}
					break;

				/*
				 * Options With A Conditional (+) Option
				 */

				case 'i':
				case 'I':
				case 's':
				case 'S':
				case 't':
				case 'T':
					if (*p == '+') {
						sprintf(ip+2, "%c", *p++);
					} else {
						break;
					}
					/* Fall Through */

				/*
				 * Options with arguments
				 */
				case 'a':
				case 'A':

				case 'b':
				case 'B':

				case 'g':
				case 'G':

				case 'k':
				case 'K':

				case 'l':
				case 'L':

				case 'f':
				case 'F':
					strcat(ip, " ");
					/* allow -*arg or -* arg */
					if (*p == '\0') {
						if (++i >= argc) {
							fprintf(stderr, "?ASlink-Error-Missing -%c argument\n", c);
							lkexit(ER_FATAL);
						}
						p = argv[i];
					}
					strcat(ip, p);
					p += strlen(p);
					break;

				/*
				 * Preprocess these commands
				 */
				case 'h':
				case 'H':
					usage();
					lkexit(ER_NONE);
					break;

				case 'n':
				case 'N':
					pflag = 0;
					break;

				case 'p':
				case 'P':
					pflag = 1;
					break;

				/*
				 * Options without arguments
				 */
				default:
					break;
				}
				if(pflag)
					fprintf(stdout, "ASlink >> %s\n", ip);
				parse();
			}
		} else {
			strcpy(ip, argv[i]);
			if(pflag)
				fprintf(stdout, "ASlink >> %s\n", ip);
			parse();
		}
	}

	if (linkp == NULL) {
		fprintf(stderr, "?ASlink-Error-Missing input file(s)\n");
		lkexit(ER_FATAL);
	}

	syminit();
	curtim = time(NULL);

#if SDCDB
	/*
	 * Open SDCC Debug output file
	 */
	SDCDBfopen();
#endif

	for (pass=0; pass<2; ++pass) {
		cfp = NULL;
		sfp = NULL;
		filep = linkp->f_flp;
		hp = NULL;
		p_mask = DEFAULT_PMASK;
		radix = 10;

		while (nxtline()) {
			ip = ib;
			link();
		}
		if (pass == 0) {
			/*
			 * Search libraries for global symbols
			 */
			search();
			/*
			 * Set area base addresses.
			 */
			setarea();
			/*
			 * Set bank base addresses.
			 */
			setbank();
			/*
			 * Link all area addresses.
			 */
			lnkarea();
			/*
			 * Check bank size limits.
			 */
			chkbank(stderr);
			/*
			 * Process global definitions.
			 */
			setgbl();
			/*
			 * Check for undefined globals.
			 */
			symdef(stderr);
#if NOICE
			/*
			 * Open NoICE output file
			 */
			NoICEfopen();
#endif
			/*
			 * Output Link Map.
			 */
			map();
			/*
			 * Open output file(s)
			 */
			lkfopen();
		} else {
			/*
			 * Link in library files
			 */
			library();
			/*
			 * Complete Processing
			 */
			reloc('E');
		}
	}
	lkexit(lkerr ? ER_ERROR : ER_NONE);
	return(0);
}

/*)Function	int	intsiz(void)
 *
 *	The function intsiz() returns the size of INT32
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
intsiz(void)
{
	return(sizeof(a_uint));
}

/*)Function	void	lkexit(i)
 *
 *			int	i	exit code
 *
 *	The function lkexit() explicitly closes all open
 *	files and then terminates the program.
 *
 *	local variables:
 *		none
 *
 *	global variables:
 *		FILE *	jfp		file handle for .noi
 *		FILE *	mfp		file handle for .map
 *		FILE *	rfp		file handle for .rst
 *		FILE *	sfp		file handle for stdin
 *		FILE *	tfp		file handle for .lst
 *		FILE *	hfp		file handle for .hlr
 *		FILE *	yfp		file handle for .cdb
 *
 *	functions called:
 *		int	fclose()	c_library
 *		void	exit()		c_library
 *		void	lkfclose()	lkbank.c
 *
 *	side effects:
 *		All files closed. Program terminates.
 */

void
lkexit(int i)
{
	lkfclose();
#if NOICE
	if (jfp != NULL) fclose(jfp);
#endif
	if (mfp != NULL) fclose(mfp);
	if (rfp != NULL) fclose(rfp);
	if (sfp != NULL) { if (sfp != stdin) fclose(sfp); }
	if (tfp != NULL) fclose(tfp);
	if (hfp != NULL) fclose(hfp);
#if SDCDB
	if (yfp != NULL) fclose(yfp);
#endif
	exit(i);
}

/*)Function	link(void)
 *
 *	The function link() evaluates the directives for each line of
 *	text read from the .rel file(s).  The valid directives processed
 *	are:
 *		X, D, Q, H, G, B, M, A, S, T, R, and P.
 *
 *	local variables:
 *		int	c		first non blank character of a line
 *
 *	global variables:
 *		int	a_bytes		T Line address bytes
 *		a_uint	a_mask		address mask
 *		head	*headp		The pointer to the first
 *				 	head structure of a linked list
 *		int	hilo		Byte ordering
 *		head	*hp		Pointer to the current
 *				 	head structure
 *		int	pass		linker pass number
 *		int	radix		current number conversion radix
 *		sdp	sdp		Base Paged structure
 *		a_uint	s_mask		signed value bit test
 *		a_auit	v_mask		value mask
 *
 *	functions called:
 *		int	get()		lklex.c
 *		int	getnb()		lklex.c
 *		void	module()	lkhead.c
 *		void	newarea()	lkarea.c
 *		void	newhead()	lkhead.c
 *		void	newmode()	lkhead.c
 *		sym *	newsym()	lksym.c
 *		void	NoICEmagic()	lknoice.c
 *		void	reloc()		lkreloc.c
 *		int	unget()		lklex.c
 *
 *	side effects:
 *		Head, area, and symbol structures are created and
 *		the radix is set as the .rel file(s) are read.
 */

void
link(void)
{
	int c;

	c = getnb();
	switch (c) {

	case 'X':
	case 'D':
	case 'Q':
		ASxxxx_VERSION = 3;
		if (c == 'X') { radix = 16; } else
		if (c == 'D') { radix = 10; } else
		if (c == 'Q') { radix = 8;  }

		while ((c = get()) != 0) {
			switch(c) {
			case 'H':
				hilo = 1;
				break;

			case 'L':
				hilo = 0;
				break;

			case '2':
				a_bytes = 2;
				break;

			case '3':
				a_bytes = 3;
				break;

			case '4':
				a_bytes = 4;
				break;

			default:
				break;
			}
		}
#ifdef	LONGINT
		switch(a_bytes) {
		default:
			a_bytes = 2;
		case 2:
			a_mask = 0x0000FFFFl;
			s_mask = 0x00008000l;
			v_mask = 0x00007FFFl;
			break;

		case 3:
			a_mask = 0x00FFFFFFl;
			s_mask = 0x00800000l;
			v_mask = 0x007FFFFFl;
			break;

		case 4:
			a_mask = 0xFFFFFFFFl;
			s_mask = 0x80000000l;
			v_mask = 0x7FFFFFFFl;
			break;
		}
#else
		switch(a_bytes) {
		default:
			a_bytes = 2;
		case 2:
			a_mask = 0x0000FFFF;
			s_mask = 0x00008000;
			v_mask = 0x00007FFF;
			break;

		case 3:
			a_mask = 0x00FFFFFF;
			s_mask = 0x00800000;
			v_mask = 0x007FFFFF;
			break;

		case 4:
			a_mask = 0xFFFFFFFF;
			s_mask = 0x80000000;
			v_mask = 0x7FFFFFFF;
			break;
		}
#endif
		break;

	case 'H':
		if (pass == 0) {
			newhead();
		} else {
			if (hp == 0) {
				hp = headp;
			} else {
				hp = hp->h_hp;
			}
		}
		sdp.s_area = NULL;
		sdp.s_areax = NULL;
		sdp.s_addr = 0;
		break;

	case 'G':
		ASxxxx_VERSION = 4;
		if (pass == 0)
			newmode();
		break;

	case 'B':
		ASxxxx_VERSION = 4;
		if (pass == 0)
			newbank();
		break;

	case 'M':
		if (pass == 0)
			module();
		break;

	case 'A':
		if (pass == 0)
			newarea();
		if (sdp.s_area == NULL) {
			sdp.s_area = areap;
			sdp.s_areax = areap->a_axp;
			sdp.s_addr = 0;
		}
		break;

	case 'S':
		if (pass == 0)
			newsym();
		break;

	case 'T':
	case 'R':
	case 'P':
		if (pass == 0)
			break;
		reloc(c);
		break;

#if NOICE
	case ';':
		unget(c);
		NoICEmagic();
		break;
#endif

	default:
		break;
	}
}

/*)Function	void	map(void)
 *
 *	The function map() opens the output map file and calls the various
 *	routines to
 *	(1) output the variables in each area,
 *	(2) list the files processed with module names,
 *	(3) list the libraries file processed,
 *	(4) list base address definitions,
 *	(5) list global variable definitions, and
 *	(6) list any undefined variables.
 *
 *	local variables:
 *		int 	i		counter
 *		head *	hdp		pointer to head structure
 *		lbfile *lbfh		pointer to library file structure
 *
 *	global variables:
 *		area	*ap		Pointer to the current
 *				 	area structure
 *		area	*areap		The pointer to the first
 *				 	area structure of a linked list
 *		base	*a_basep	The pointer to the first
 *				 	area base structure
 *		base	*a_bsp		Pointer to the current
 *				 	area base structure
 *		lfile	*filep	 	The pointer *filep points to the
 *				 	beginning of a linked list of
 *				 	lfile structures.
 *		globl	*globlp		The pointer to the first
 *				 	globl structure
 *		globl	*gsp		Pointer to the current
 *				 	globl structure
 *		head	*headp		The pointer to the first
 *				 	head structure of a linked list
 *		lbfile	*lbfhead	The pointer to the first
 *					lbfile structure of a linked list
 *		lfile	*linkp		pointer to first lfile structure
 *				 	containing an input REL file
 *				 	specification
 *		int	lop		current line number on page
 *		int	mflag		Map output flag
 *		FILE	*mfp		Map output file handle
 *		int	page		current page number
 *
 *	functions called:
 *		FILE *	afile()		lkmain.c
 *		int	fprintf()	c_library
 *		void	lkexit()	lkmain.c
 *		void	lstarea()	lklist.c
 *		void	newpag()	lklist.c
 *		void	symdef()	lksym.c
 *
 *	side effects:
 *		The map file is created.
 */

void
map(void)
{
	int i;
	struct head *hdp;
	struct lbfile *lbfh;

	if (mflag == 0) return;

	/*
	 * Open Map File
	 */
	mfp = afile(linkp->f_idp, "map", 1);
	if (mfp == NULL) {
		fprintf(stderr, "?ASlink-Error-Failed to create map file\n");
		lkexit(ER_FATAL);
	}

	/*
	 * Output Map Bank/Area Lists
	 */
	page = 0;
	for (bp = bankp; bp != NULL; bp = bp->b_bp) {
		for (ap = areap; ap != NULL; ap = ap->a_ap) {
			if (ap->a_bp == bp)
				lstarea(ap, bp);
		}
	}

	/*
	 * List Linked Files
	 */
	newpag(mfp);
	fprintf(mfp,
"\nFiles Linked                              [ module(s) ]\n\n");
	hdp = headp;
	filep = linkp->f_flp;
	while (filep) {
		fprintf(mfp, "%-40.40s  [ ", filep->f_idp);
		i = 0;
		while ((hdp != NULL) && (hdp->h_lfile == filep)) {
			if (i)
				fprintf(mfp, ",\n%44s", "");
			fprintf(mfp, "%-.32s", hdp->m_id);
			hdp = hdp->h_hp;
			i++;
		}
		if (i)
			fprintf(mfp, " ]");
		fprintf(mfp, "\n");
		filep = filep->f_flp;
	}
	fprintf(mfp, "\n");
	/*
	 * List Linked Libraries
	 */
	if (lbfhead) {
		fprintf(mfp,
"\nLibraries Linked                          [ object file ]\n\n");
		for (lbfh=lbfhead; lbfh; lbfh=lbfh->next) {
			fprintf(mfp, "%-40.40s  [ %-.32s ]\n",
				lbfh->libspc, lbfh->relfil);
		}
		fprintf(mfp, "\n");
	}
	/*
	 * List Area Base Address Definitions
	 */
	if (a_basep) {
		newpag(mfp);
		fprintf(mfp, "\nUser Area Base Address Definitions\n\n");
		a_bsp = a_basep;
		while (a_bsp) {
			fprintf(mfp, "%s\n", a_bsp->strp);
			a_bsp = a_bsp->link;
		}
		fprintf(mfp, "\n");
	}
	/*
	 * List Bank Base Address Definitions
	 */
	if (b_basep) {
		newpag(mfp);
		fprintf(mfp, "\nUser Bank Base Address Definitions\n\n");
		b_bsp = b_basep;
		while (b_bsp) {
			fprintf(mfp, "%s\n", b_bsp->strp);
			b_bsp = b_bsp->link;
		}
		fprintf(mfp, "\n");
	}
	/*
	 * List Global Definitions
	 */
	if (globlp) {
		newpag(mfp);
		fprintf(mfp, "\nUser Global Definitions\n\n");
		gsp = globlp;
		while (gsp) {
			fprintf(mfp, "%s\n", gsp->g_strp);
			gsp = gsp->g_globl;
		}
		fprintf(mfp, "\n");
	}
	fprintf(mfp, "\n\f");
	chkbank(mfp);
	symdef(mfp);
}

/*)Function	int	parse(void)
 *
 *	The function parse() evaluates all command line or file input
 *	linker directives and updates the appropriate variables.
 *
 *	local variables:
 *		int	c		character value
 *		int	idx		string index
 *		int	sv_type		save type of processing
 *		char	*p;		string pointer
 *		char	fid[]		file id string
 *
 *	global variables:
 *		char	ctype[]		array of character types, one per
 *				 	ASCII character
 *		int	jflag		NoICE Debug output flag
 *		lfile	*lfp		pointer to current lfile structure
 *				 	being processed by parse()
 *		lfile	*linkp		pointer to first lfile structure
 *				 	containing an input REL file
 *				 	specification
 *		int	mflag		Map output flag
 *		int	oflag		Output file type flag
 *		int	objflg		Linked file/library output object flag
 *		int	pflag		print linker command file flag
 *		FILE *	stderr		c_library
 *		int	uflag		Relocated listing flag
 *		int	wflag		Wide listing format
 *		int	xflag		Map file radix type flag
 *		int	yflag		SDCC Debug output flag
 *		int	zflag		Enable symbol case sensitivity
 *
 *	Functions called:
 *		void	addlib()	lklibr.c
 *		void	addpath()	lklibr.c
 *		void	areasav()	lkmain.c
 *		void	banksav()	lkmain.c
 *		void	doparse()	lkmain.c
 *		char *	filespec()	lkmain.c
 *		int	fprintf()	c_library
 *		void	glblsav()	lkmain.c
 *		void	getfid()	lklex.c
 *		int	get()		lklex.c
 *		int	getnb()		lklex.c
 *		int	getnb()		lklex.c
 *		void	lkexit()	lkmain.c
 *		char *	new()		lksym.c
 *		char *	strsto()	lksym.c
 *		int	strlen()	c_library
 *		void	unget()		lklex.c
 *
 *	side effects:
 *		Various linker flags are updated and the linked
 *		structure lfile is created.
 */

int
parse()
{
	int c, idx;
	char *p;
	int sv_type;
	char fid[FILSPC+FILSPC];

	while ((c = getnb()) != 0) {
		if ( c == '-') {
			while (ctype[c=get()] & LETTER) {
				switch(c) {

				case 'a':
				case 'A':
					areasav();
					return(0);

				case 'b':
				case 'B':
					banksav();
					return(0);

				case 'c':
				case 'C':
					if (startp->f_type != 0)
						break;
					startp->f_type = F_STD;
					doparse();
					return(0);

				case 'd':
				case 'D':
					xflag = 2;
					break;

				case 'e':
				case 'E':
					return(1);

				case 'f':
				case 'F':
					if (startp->f_type == F_LNK)
						return(0);
					unget(getnb());
					if (*ip == 0) {
						fprintf(stderr, "?ASlink-Error-Missing -f argument\n");
						lkexit(ER_FATAL);
					}
					sv_type = startp->f_type;
					startp->f_idp = strsto(ip);
					startp->f_idx = fndidx(ip);
					startp->f_type = F_LNK;
					doparse();
					if (sv_type == F_STD) {
						cfp = NULL;
						sfp = NULL;
						startp->f_type = F_STD;
						filep = startp;
					}
					return(0);

				case 'g':
				case 'G':
					glblsav();
					return(0);

				case 'h':
				case 'H':
					break;

				case 'i':
				case 'I':
					oflag = 1;
					ip = filespec(ip);
					break;

#if NOICE
				case 'j':
				case 'J':
					jflag = 1;
					break;
#endif

				case 'k':
				case 'K':
					addpath();
					return(0);

				case 'l':
				case 'L':
					addlib();
					return(0);

				case 'm':
				case 'M':
					mflag = 1;
					if ((c=get()) == '1') {
						m1flag = 1;
					} else {
						unget(c);
					}
					break;

				case 'n':
				case 'N':
					pflag = 0;
					break;

				case 'o':
				case 'O':
					objflg = 0;
					break;

				case 'p':
				case 'P':
					pflag = 1;
					break;

				case 'q':
				case 'Q':
					xflag = 1;
					break;

				case 's':
				case 'S':
					oflag = 2;
					ip = filespec(ip);
					break;

				case 't':
				case 'T':
					oflag = 3;
					ip = filespec(ip);
					break;

				case 'u':
				case 'U':
					uflag = 1;
					break;

				case 'v':
				case 'V':
					objflg = 1;
					break;

				case 'w':
				case 'W':
					wflag = 1;
					break;

				case 'x':
				case 'X':
					xflag = 0;
					break;

#if SDCDB
				case 'y':
				case 'Y':
					yflag = 1;
					break;
#endif

				case 'z':
				case 'Z':
					zflag = 1;
					break;

				default:
					fprintf(stderr, "?ASlink-Warning-Unkown option -%c ignored\n", c);
					break;
				}
			}
		} else
		if (ctype[c] != ILL) {
			/*
			 * Copy Path from .LNK file
			 */
			idx = startp->f_idx;
			strncpy(fid, startp->f_idp, idx);
			/*
			 * Concatenate the file spec
			 */
			getfid(fid + idx, c);
			/*
			 * If file spec has a path
			 * 	use it
			 * else
			 *	use path of .LNK file
			 */
			if (fndidx(fid + idx) != 0) {
				p = fid + idx;
			} else {
				p = fid;
			}
			/*
			 * Save file specification
			 */
			if (linkp == NULL) {
				linkp = (struct lfile *)
						new (sizeof (struct lfile));
				lfp = linkp;
				lfp->f_type = F_OUT;
				lfp->f_idp = strsto(p);
				lfp->f_idx = fndidx(p);
				lfp->f_obj = objflg;
			}
			lfp->f_flp = (struct lfile *)
					new (sizeof (struct lfile));
			lfp = lfp->f_flp;
			lfp->f_type = F_REL;
			lfp->f_idp = strsto(p);
			lfp->f_idx = fndidx(p);
			lfp->f_obj = objflg;
		} else {
			fprintf(stderr, "?ASlink-Error-Invalid input character\n");
			lkexit(ER_FATAL);
		}
	}
	return(0);
}

/*)Function	void	doparse(void)
 *
 *	The function doparse() evaluates all interactive
 *	command line or file input linker directives and
 *	updates the appropriate variables.
 *
 *	local variables:
 *		none
 *
 *	global variables:
 *		FILE *	stdin		standard input
 *		FILE *	stdout		standard output
 *		lfile	*cfp		The pointer *cfp points to the
 *				 	current lfile structure
 *		FILE	*sfp		The file handle sfp points to the
 *				 	currently open file
 *		char	ib[NINPUT]	.rel file text line
 *		char	*ip		pointer into the .rel file
 *		lfile	*filep	 	The pointer *filep points to the
 *				 	beginning of a linked list of
 *				 	lfile structures.
 *		lfile	*startp		asmlnk startup file structure
 *		int	pflag		print linker command file flag
 *
 *	Functions called:
 *		int	fclose()	c_library
 *		int	fprintf()	c_library
 *		int	nxtline()	lklex.c
 *		int	parse()		lkmain.c
 *
 *	side effects:
 *		Various linker flags are updated and the linked
 *		structure lfile may be updated.
 */

void
doparse(void)
{
	cfp = NULL;
	sfp = NULL;
	filep = startp;
	while (1) {
		ip = ib;
		if (nxtline() == 0)
			break;
		if (pflag && cfp->f_type != F_STD)
			fprintf(stdout, "ASlink >> %s\n", ip);
		if (*ip == 0 || parse())
			break;
	}
	if((sfp != NULL) && (sfp != stdin)) {
		fclose(sfp);
	}
	sfp = NULL;
	startp->f_idp = "";
	startp->f_idx = 0;
	startp->f_type = 0;
}

/*)Function	char *	filespec(p)
 *
 *		char *		p	pointer to option string
 *
 *	local variables:
 *		int		opt	option character
 *		int		pFile	index to beginning of p filename
 *		char *		q	pointer into p string
 *
 *	global variables:
 *		char *		outnam	Output Name String
 *		char *		outext	Output Extension String
 *
 *	functions called:
 *		lkexit()		lkmain.c
 *		fndidx()		lkmain.c
 *		fprintf()		c_library
 *		strchr()		c_library
 *		strlen()		c_library
 *		strsto()		lksym.c
 *
 *	side effects:
 *		evaluates an option for a file name and/or extension
 *		and saves outnam/outext respectively
 */
char *filespec(char *p)
{
	int opt;
	int pFile;
	char *q;

	if (*p == '+') {
		opt = *(p-1);
		/* Skip '+' */
		++p;
		/* Skip White Space */
		while ((*p == ' ') || (*p == '\t')) p++;
		/* Forms: -*+name. / -*+.ext / -*+name.ext */
		pFile = fndidx(p);
		if ((q = strchr(p + pFile, FSEPX)) != NULL) {
			if ((p == q) && (*p == FSEPX)) {
				if (*(++p)) {
					outext = strsto(p);
					p += strlen(p);
				}
			} else {
				*q = '\0';
				if (*p) {
					outnam = strsto(p);
					p += strlen(p);
				}
				if (*(++q)) {
					outext = strsto(q);
					p = q + strlen(q);
				}
			}
		} else
		/* Form -*+name */
		if (*p != '\0') {
			outnam = strsto(p);
			p += strlen(p);
		} else {
			fprintf(stderr, "?ASlink-Error-Missing [name][.ext] After -%c+", opt);
			lkexit(ER_FATAL);
		}
	}
	return(p);
}

/*)Function	void	areasav(void)
 *
 *	The function areasav() creates a linked structure containing
 *	the area base address strings input to the linker.
 *
 *	local variables:
 *		none
 *
 *	global variables:
 *		base	*a_basep	The pointer to the first
 *				 	area base structure
 *		base	*a_bsp		Pointer to the current
 *				 	area base structure
 *		char	*ip		pointer into the REL file
 *				 	text line in ib[]
 *
 *	 functions called:
 *		int	getnb()		lklex.c
 *		void *	new()		lksym.c
 *		int	strlen()	c_library
 *		char *	strcpy()	c_library
 *		void	unget()		lklex.c
 *
 *	side effects:
 *		The a_base structure is created.
 */

void
areasav(void)
{
	if (a_basep == NULL) {
		a_basep = (struct base *)
			new (sizeof (struct base));
		a_bsp = a_basep;
	} else {
		a_bsp->link = (struct base *)
			new (sizeof (struct base));
		a_bsp = a_bsp->link;
	}
	unget(getnb());
	a_bsp->strp = (char *) new (strlen(ip)+1);
	strcpy(a_bsp->strp, ip);
}


/*)Function	void	banksav(void)
 *
 *	The function banksav() creates a linked structure containing
 *	the bank base address strings input to the linker.
 *
 *	local variables:
 *		none
 *
 *	global variables:
 *		base	*b_basep	The pointer to the first
 *				 	area base structure
 *		base	*b_bsp		Pointer to the current
 *				 	area base structure
 *		char	*ip		pointer into the REL file
 *				 	text line in ib[]
 *
 *	 functions called:
 *		int	getnb()		lklex.c
 *		void *	new()		lksym.c
 *		int	strlen()	c_library
 *		char *	strcpy()	c_library
 *		void	unget()		lklex.c
 *
 *	side effects:
 *		The b_base structure is created.
 */

void
banksav(void)
{
	if (b_basep == NULL) {
		b_basep = (struct base *)
			new (sizeof (struct base));
		b_bsp = b_basep;
	} else {
		b_bsp->link = (struct base *)
			new (sizeof (struct base));
		b_bsp = b_bsp->link;
	}
	unget(getnb());
	b_bsp->strp = (char *) new (strlen(ip)+1);
	strcpy(b_bsp->strp, ip);
}


/*)Function	void	glblsav(void)
 *
 *	The function glblsav() creates a linked structure containing
 *	the global variable strings input to the linker.
 *
 *	local variable:
 *		none
 *
 *	global variables:
 *		globl	*globlp		The pointer to the first
 *				 	globl structure
 *		globl	*gsp		Pointer to the current
 *				 	globl structure
 *		char	*ip		pointer into the REL file
 *				 	text line in ib[]
 *
 *	functions called:
 *		int	getnb()		lklex.c
 *		void *	new()		lksym.c
 *		int	strlen()	c_library
 *		char *	strcpy()	c_library
 *		void	unget()		lklex.c
 *
 *	side effects:
 *		The globlp structure is created.
 */

void
glblsav(void)
{
	if (globlp == NULL) {
		globlp = (struct globl *)
			new (sizeof (struct globl));
		gsp = globlp;
	} else {
		gsp->g_globl = (struct globl *)
				new (sizeof (struct globl));
		gsp = gsp->g_globl;
	}
	unget(getnb());
	gsp->g_strp = (char *) new (strlen(ip)+1);
	strcpy(gsp->g_strp, ip);
}


/*)Function	void	setgbl(void)
 *
 *	The function setgbl() scans the global variable lines in the
 *	globlp structure, evaluates the arguments, and sets a variable
 *	to this value.
 *
 *	local variables:
 *		int	v		expression value
 *		char	id[]		base id string
 *		sym *	sp		pointer to a symbol structure
 *
 *	global variables:
 *		char	*ip		pointer into the REL file
 *				 	text line in ib[]
 *		globl	*globlp		The pointer to the first
 *				 	globl structure
 *		globl	*gsp		Pointer to the current
 *				 	globl structure
 *		FILE *	stderr		c_library
 *		int	lkerr		error flag
 *
 *	 functions called:
 *		a_uint	expr()		lkeval.c
 *		int	fprintf()	c_library
 *		void	getid()		lklex.c
 *		int	getnb()		lklex.c
 *		sym *	lkpsym()	lksym.c
 *
 *	side effects:
 *		The value of a variable is set.
 */

void
setgbl(void)
{
	int v;
	struct sym *sp;
	char id[NCPS];

	gsp = globlp;
	while (gsp) {
		ip = gsp->g_strp;
		getid(id, -1);
		if (getnb() == '=') {
			v = (int) expr(0);
			sp = lkpsym(id, 0);
			if (sp == NULL) {
				fprintf(stderr,
				"?ASlink-Error-No definition of symbol %s\n", id);
				lkerr++;
			} else {
				if (sp->s_type & S_DEF) {
					fprintf(stderr,
					"?ASlink-Error-Redefinition of symbol %s\n", id);
					lkerr++;
					sp->s_axp = NULL;
				}
				sp->s_addr = v;
				sp->s_type |= S_DEF;
			}
		} else {
			fprintf(stderr, "?ASlink-Error-No '=' in global expression");
			lkerr++;
		}
		gsp = gsp->g_globl;
	}
}

/*)Function	FILE *	afile(fn, ft, wf)
 *
 *		char *	fn		file specification string
 *		char *	ft		file type string
 *		int	wf		0 ==>> read
 *					1 ==>> write
 *					2 ==>> binary read
 *					3 ==>> binary write
 *
 *					add 4 to the wf code to
 *					suppress the error reporting
 *
 *					add 8 to the wf code to allow
 *					any extension on a file
 *
 *	The function afile() opens a file for reading or writing.
 *		(1)	If (wf & 8) == 8 and there is an extension
 *			seperator then any file name is allowed.
 *		(2)	The file type specification string ft
 *			is appended to the file specification.
 *
 *	afile() returns a file handle for the opened file or aborts
 *	the assembler on an open error.
 *
 *	local variables:
 *		int	c		character value
 *		FILE *	fp		filehandle for opened file
 *		char *	frmt		file access format string
 *		char *	p1		pointer to filespec string fn
 *		char *	p2		pointer to filespec string fb
 *
 *	global variables:
 *		char	afspec[]	constructed file specification string
 *		int	lkerr		error flag
 *
 *	functions called:
 *		int	fndidx()	lkmain.c
 *		FILE *	fopen()		c_library
 *		int	fprintf()	c_library
 *
 *	side effects:
 *		File is opened for read or write.
 */

FILE *
afile(char *fn, char *ft, int wf)
{
	char *p1, *p2;
	int c;
	char * frmt;
	FILE *fp;

	if (strlen(fn) > (FILSPC-7)) {
		fprintf(stderr, "?ASlink-Error-<filspc to long> : \"%s\"\n", fn);
		lkerr++;
		return(NULL);
	}

	/*
	 * Skip The Path
	 */
	strcpy(afspec, fn);
	c = fndidx(afspec);

	/*
	 * Skip to File Extension separator
	 */
	p1 = strrchr(&afspec[c], FSEPX);

	/*
	 * Allow any extension if FSEPX
	 * is present. <path><name><FSEPX>...
	 */
	if ((wf & 8) && (p1 != NULL)) {
		/*
		 * Remove FSEPX when extension is BLANK
		 */
		if (*(p1+1) == 0) {
			*p1 = 0;
		}
	/*
	 * Else all reads and writes default to ft.
	 * <path><name>... -> <path><name><FSEPX><ft>
	 */
	} else {
		/*
		 * Copy File Extension
		 */
		p2 = ft;
		if (p1 == NULL) {
			p1 = &afspec[strlen(afspec)];
		}
		*p1++ = FSEPX;
		while ((c = *p2++) != 0) {
			if (p1 < &afspec[FILSPC-1])
				*p1++ = c;
		}
		*p1++ = 0;
	}

	/*
	 * Select (Binary) Read/Write
	 */
	switch(wf & 3) {
	default:
	case 0:	frmt = "r";	break;
	case 1:	frmt = "w";	break;
	case 2:	frmt = "rb";	break;
	case 3:	frmt = "wb";	break;
	}
	if ((fp = fopen(afspec, frmt)) == NULL) {
		if (wf & 4) {
			fprintf(stderr, "?ASlink-Warning-<cannot %s> : \"%s\"\n", (frmt[0] == 'w')?"create":"open", afspec);
		} else {
			fprintf(stderr, "?ASlink-Error-<cannot %s> : \"%s\"\n", (frmt[0] == 'w')?"create":"open", afspec);
			lkerr++;
		}
	}
	return (fp);
}

/*)Function	int	fndidx(str)
 *
 *		char *	str		file specification string
 *
 *	The function fndidx() scans the file specification string
 *	to find the index to the file name.  If the file
 *	specification contains a 'path' then the index will
 *	be non zero.
 *
 *	fndidx() returns the index value.
 *
 *	local variables:
 *		char *	p1		temporary pointer
 *		char *	p2		temporary pointer
 *
 *	global variables:
 *		none
 *
 *	functions called:
 *		char *	strrchr()	c_library
 *
 *	side effects:
 *		none
 */

int
fndidx(char *str)
{
	char *p1, *p2;

	/*
	 * Skip Path Delimiters
	 */
	p1 = str;
	if ((p2 = strrchr(p1,  ':')) != NULL) { p1 = p2 + 1; }
	if ((p2 = strrchr(p1,  '/')) != NULL) { p1 = p2 + 1; }
	if ((p2 = strrchr(p1, '\\')) != NULL) { p1 = p2 + 1; }

	return((int) (p1 - str));
}

/*)Function	int	fndext(str)
 *
 *		char *	str		file specification string
 *
 *	The function fndext() scans the file specification string
 *	to find the file.ext separater.
 *
 *	fndext() returns the index to FSEPX or the end of the string.
 *
 *	local variables:
 *		char *	p1		temporary pointer
 *		char *	p2		temporary pointer
 *
 *	global variables:
 *		none
 *
 *	functions called:
 *		char *	strrchr()	c_library
 *
 *	side effects:
 *		none
 */

int
fndext(char * str)
{
	char *p1, *p2;

	/*
	 * Find the file separator
	 */
	p1 = str + strlen(str);
	if ((p2 = strrchr(str,  FSEPX)) != NULL) { p1 = p2; }

	return((int) (p1 - str));
}


char *usetxt[] = {
	"Usage: [-Options] [-Option with arg] file1 [file2 ...]",
	"  -h   or NO ARGUMENTS  Show this help list",
	"  -p   Echo commands to stdout (default)",
	"  -n   No echo of commands to stdout",
	"Alternates to Command Line Input:",
	"  -c                   ASlink >> prompt input",
	"  -f   file[.lnk]      Command File input",
	"Librarys:",
	"  -k   Library path specification, one per -k",
	"  -l   Library file specification, one per -l",
	"Relocation:",
	"  -a   Area base address=expression",
	"  -b   Bank base address=expression",
	"  -g   Global symbol=expression",
	"Map format:",
	"  -m   Map output generated as file1[.map]",
	"  -m1    Linker generated symbols included in file1[.map]",
	"  -w   Wide listing format for map file",
	"  -x   Hexadecimal (default)",
	"  -d   Decimal",
	"  -q   Octal",
	"Output:",
	"  -i   Intel Hex as file1[.hex]",
	"  -s   Motorola S Record as file1[.s--]",
	"  -t   Tandy CoCo Disk BASIC binary as file1[.bin]",
	"  -*+  -i+/-s+/-t+ Renaming Options   -*+[ ][name][.ext]",
	"    '-*+.ext'      (or)  '-*+  .ext'      ->  file1.ext ",
	"    '-*+name'      (or)  '-*+  name'      ->  name[.---]",
	"    '-*+name.ext'  (or)  '-*+  name.ext'  ->   name.ext",
	"  -o   Linked file/library output enable (default)",
	"  -v   Linked file/library output disable",
#if NOICE
	"  -j   NoICE Debug output as file1[.noi]",
#endif
#if SDCDB
	"  -y   SDCDB Debug output as file1[.cdb]",
#endif
	"List:",
	"  -u   Update listing file(s) with link data as file(s)[.rst]",
	"Case Sensitivity:",
	"  -z   Disable Case Sensitivity for Symbols",
	"End:",
	"  -e   or null line terminates input",
	"",
	0
};

/*)Function	void	usage(void)
 *
 *	The function usage() outputs to the stderr device the
 *	linker name and version and a list of valid linker options.
 *
 *	local variables:
 *		char **	dp		pointer to an array of
 *					text string pointers.
 *
 *	global variables:
 *		FILE *	stderr		c_library
 *
 *	functions called:
 *		int	fprintf()	c_library
 *
 *	side effects:
 *		none
 */

void
usage(void)
{
	char	**dp;

	fprintf(stdout, "\nASxxxx Linker %s", VERSION);
	fprintf(stdout, "\nCopyright (C) %s  Alan R. Baldwin", COPYRIGHT);
	fprintf(stdout, "\nThis program comes with ABSOLUTELY NO WARRANTY.\n\n");
	for (dp = usetxt; *dp; dp++) {
		fprintf(stdout, "%s\n", *dp);
	}
}
