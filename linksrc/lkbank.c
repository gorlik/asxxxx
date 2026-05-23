/* lkbank.c */

/*
 *  Copyright (C) 2001-2025  Alan R. Baldwin
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

/*Module	lkbank.c
 *
 *	The module lkbank.c contains the function newbank() which
 *	creates a bank structure and the function module() which
 *	loads the module name into the current head structure.
 *
 *	lkbank.c contains the following functions:
 *		void	newbank()
 *		void	lkpbank()
 *		void	setbank()
 *		void	chkbank()
 *		void	lkfopen()
 *		void	lkfclose()
 *
 *	lkbank.c contains no local variables.
 */

/*)Function	void	newbank(void)
 * 
 *	The function newbank() creates and/or modifies bank
 *	structures for each B directive read from
 *	the .rel file(s).  The function lkpbank() is called
 *	to find tha bank structure associated with this name.
 *	If the bank does not yet exist then a new bank
 *	structure is created and linked to any existing
 *	linked bank structures. The bank flags are copied
 *	into the bank flag variable.  Refer to lkdata.c for
 *	details of the structures and their linkage.
 *
 *	local variables:
 *		bank	**hblp		pointer to an array of pointers
 *		int	i		counter, loop variable, value
 *		char	id[]		id string
 *		int	nbank		number of banks in this head structure
 *		a_uint	v		temporary value
 *
 *	global variables:
 *		bank	*bp		Pointer to the current
 *				 	bank structure
 *		head	*hp		Pointer to the current
 *				 	head structure
 *		int	lkerr		error flag
 *		a_uint	a_mask		masking value
 *
 *	functions called:
 *		a_uint	eval()		lkeval.c
 *		void	exit()		c_library
 *		int	fprintf()	c_library
 *		void	getid()		lklex.c
 *		void	lkpbank()	lkbank.c
 *		void	skip()		lklex.c
 *
 *	side effects:
 *		The bank structure is created and
 *		linked with the appropriate head structures.
 *		Failure to allocate bank structure
 *		space will terminate the linker.  Other internal
 *		errors most likely caused by corrupted .rel
 *		files will also terminate the linker.
 */

/*
 * Create a bank entry.
 *
 * B xxxxxx base nnnn size nnnn map nnn flags n fsfx xxxxxx
 *   |           |         |        |         |      |
 *   |           |         |        |         |      `-- bp->b_fsfx
 *   |           |         |        |         `--------- bp->b_flag
 *   |           |         |        `--------------------bp->b_map
 *   |           |         `---------------------------- bp->b_size
 *   |           `-------------------------------------- bp->b_base
 *   `-------------------------------------------------- bp->b_id
 *
 */
void
newbank(void)
{
	int i;
	a_uint v;
	char id[NCPS];
	int nbank;
	struct bank **hblp;

	if (headp == NULL) {
		fprintf(stderr, "?ASlink-Error-No header defined\n");
		lkexit(ER_FATAL);
	}
	/*
	 * Create bank entry
	 */
	getid(id, -1);
	lkpbank(id);
	/*
	 * Evaluate Parameters
	 */
	while (more()) {
		getid(id, -1);
		/*
		 * Evaluate base address
		 */
		if (symeq("base", id, 1)) {
			v = eval() & a_mask;
			if (bp->b_base == 0) {
				bp->b_base = v;
			} else {
				if (v && (bp->b_base != v)) {
					fprintf(stderr, "?ASlink-Error-Conflicting address in bank %s\n", id);
					lkerr++;
				}
			}
		} else
		/*
		 * Evaluate bank size
		 */
		if (symeq("size", id, 1)) {
			v = eval() & a_mask;
			if (bp->b_size == 0) {
				bp->b_size = v;
			} else {
				if (v && (bp->b_size != v)) {
					fprintf(stderr, "?ASlink-Error-Conflicting size in bank %s\n", id);
					lkerr++;
				}
			}
		} else
		/*
		 * Evaluate bank mapping
		 */
		if (symeq("map", id, 1)) {
			v = eval() & a_mask;
			if (bp->b_map == 0) {
				bp->b_map = v;
			} else {
				if (v && (bp->b_map != v)) {
					fprintf(stderr, "?ASlink-Error-Conflicting mapping in bank %s\n", id);
					lkerr++;
				}
			}
		} else
		/*
		 * Evaluate flags
		 */
		if (symeq("flags", id, 1)) {
			i = (int) (eval() & a_mask);
			if (bp->b_flag == 0) {
				bp->b_flag = i;
			} else {
				if (i && (bp->b_flag != i)) {
					fprintf(stderr, "?ASlink-Error-Conflicting flags in bank %s\n", id);
					lkerr++;
				}
			}
		} else
		/*
		 * File Suffix
		 */
		if (symeq("fsfx", id, 1)) {
			if (more()) {
				getid(id, -1);
				if (bp->b_fsfx == NULL) {
					bp->b_fsfx = strsto(id);
				} else {
					if (!symeq(bp->b_fsfx, id, 1)) {
						fprintf(stderr, "?ASlink-Error-Conflicting fsfx in bank %s\n", id);
						lkerr++;
					}
				}
			}
		}
	}
	/*
	 * Place pointer in header bank list
	 */
	nbank = hp->h_nbank;
	hblp = hp->b_list;
	for (i=0; i < nbank; i++) {
		if (hblp[i] == NULL) {
			hblp[i] = bp;
			return;
		}
	}
	fprintf(stderr, "?ASlink-Error-Header bank list overflow\n");
	lkexit(ER_FATAL);
}

/*)Function	void	lkpbank(id)
 *
 *		char *	id		pointer to the bank name string
 *
 *	The function lkpbank() searches the linked bank structures
 *	for a name match.  If the name is not found then a bank
 *	structure is created.  The linker flag, rtaflg, for initializing
 *	i86 format output is set.
 *
 *	local variables:
 *		bank *	tbp		pointer to a bank structure
 *
 *	global variables:
 *		bank	*bp		Pointer to the current
 *				 	bank structure
 *		bank	*bankp		Pointer to the first
 *				 	bank structure of a linked list
 *
 *	functions called:
 *		void *	new()		lksym.c
 *		char *	strsto()	lksym.c
 *		int	symeq()		lksym.c
 *
 *	side effects:
 *		Bank structure may be created.
 *		Failure to allocate space for astructure
 *		will terminate the linker.
 */

void
lkpbank(char *id)
{
	struct bank *tbp;

	bp = bankp;
	while (bp) {
		if (symeq(id, bp->b_id, 1)) {
			return;
		}
		bp = bp->b_bp;
	}
	bp = (struct bank *) new (sizeof(struct bank));
	tbp = bankp;
	while (tbp->b_bp)
		tbp = tbp->b_bp;
	tbp->b_bp = bp;
	bp->b_id = strsto(id);
	bp->b_rtaflg = 1;
}


/*)Function	void	setbank(void)
 *
 *	The function setbank() performs four functions:
 *
 *	    1)	Overrides the bank base address (if any)
 *		when the -b linker option is used
 *
 *	    2)  Copies the bank base address into the
 *		area base address of the first relocatable
 *		area not having a -a linker option
 *
 *	    3)  Copies the bank base address into the
 *		area base address of all abasolute
 *		areas not having a -a linker option
 *
 *	    4)	All non-banked areas are linked to bank[0]
 *		(which does not have a bank file suffix)
 *
 *	The bank base address is always	specified in 'byte'
 *	addressing.  A first area which is not 'byte'
 *	addressed (e.g. a processor addressed by a 'word'
 *	of 2 or more bytes) has the base address scaled to
 *	begin at the 'byte' address.
 *
 *	local variables:
 *		a_uint	v		-b option bank base address
 *		char	id[NCPS]	-b option bank name string
 *		a_uint	base		base address in 'bytes'
 *		int	bytes		size of PC increment in bytes
 *		int	addrset		relocatable area base address set
 *
 *	global variables:
 *		area	*ap		Pointer to the current
 *				 	area structure
 *		area	*areap		Pointer to the first
 *				 	area structure of a linked list
 *		bank	*bp		Pointer to the current
 *				 	bank structure
 *		bank	*bankp		Pointer to the first
 *				 	bank structure of a linked list
 *		base	*bsp		Pointer to the current
 *					-b option structure
 *		base	*b_basep	Pointer to the first
 *					-b option structure of a linked list
 *		a_uint	a_mask		machine size value mask
 *					
 *
 *	functions called:
 *		expr()			lkeval.c
 *		fprintf()		c_library
 *		getid()			lklex.c
 *
 *	side effects:
 *		Base starting address may be set and non-banked
 *		areas linked to bank[0].
 */

void
setbank(void)
{
	a_uint v;
	char id[NCPS];
	a_uint base;
	int bytes;
	int addrset;

	/*
	 * -b bank address options override any
	 * assembler defined bank base addresses.
	 */
	b_bsp = b_basep;
	while (b_bsp) {
		ip = b_bsp->strp;
		getid(id, -1);
		if (getnb() == '=') {
			v = expr(0) & a_mask;
			for (bp = bankp; bp != NULL; bp = bp->b_bp) {
				if (symeq(id, bp->b_id, 1))
					break;
			}
			if (bp == NULL) {
				fprintf(stderr,	"?ASlink-Error-No definition of bank %s\n", id);
				lkerr++;
			} else {
				bp->b_base = v;
				bp->b_flag = B_BASE;
			}
		} else {
			fprintf(stderr, "?ASlink-Error-No '=' in base expression");
			lkerr++;
		}
		b_bsp = b_bsp->link;
	}

	/*
	 * For each bank structure with a defined base address value
	 *   1) Scan the area structures for all absolute areas in the bank.
	 *	Load the bank base address value into the area base address(s).
	 *   2) Scan the area structures for the first relocatable area
	 *	in the bank that has not been overridden by a -a option.
	 *	Load the bank base address value into that area base address.
	 * The bank base address is always expressed in 'bytes'.
	 */
	for (bp = bankp; bp != NULL; bp = bp->b_bp) {
		if ((bp->b_flag & B_BASE) == 0)
			continue;
		for (ap = areap, addrset = 0; ap != NULL; ap = ap->a_ap) {
			if (ap->a_bp != bp)
				continue;
			if ((ap->a_flag & A4_BNK) != A4_BNK)
				continue;
			if (ap->a_bset) {
				fprintf(stderr,
				"?ASlink-Warning-Area[%s] with '-a' option in Bank[%s]\n", ap->a_id, bp->b_id);
				continue;
			}
			bytes = 1 + (ap->a_flag & A4_WLMSK);
			base = bp->b_base;
			if ((ap->a_flag & A4_ABS) == A4_ABS) {
				ap->a_addr = (base/bytes) + ((base % bytes) ? 1 : 0);
				ap->a_bset = 1;
			} else
			if (addrset == 0) {
				ap->a_addr = (base/bytes) + ((base % bytes) ? 1 : 0);
				ap->a_bset = 1;
				addrset = 1;
				break;
			}
		}
	}

	/*
	 * Scan all the area structures for non-banked
	 * areas.  Set the area bank pointer to reference
	 * bank[0] which has no file suffix.
	 */
	 for (ap = areap; ap != NULL; ap = ap->a_ap) {
	 	if ((ap->a_flag & A4_BNK) == 0) {
			ap->a_bp = bankp;
		}
	}
}


/*)Function	void	chkbank(fp)
 *
 *		FILE	*fp		file handle
 *
 *	The function chkbank() scans the bank/area structures to
 *	determine the length of a bank.  Banks exceeding the size
 *	specified from a bank size option are flagged.  The bank
 *	size is always in 'byte' units.
 *
 *	local variables:
 *		a_uint	alow		lowest  address in a bank
 *		a_uint	ahigh		highest address in a bank
 *		a_uint	addr		address value
 *
 *	global variables:
 *		area	*ap		Pointer to the current
 *				 	area structure
 *		area	*areap		The pointer to the first
 *				 	area structure of a linked list
 *		bank	*bp		Pointer to the current
 *				 	bank structure
 *		bank	*bankp		The pointer to the first
 *				 	bank structure of a linked list
 *
 *	functions called:
 *		fprintf()		c_library
 *
 *	side effects:
 *		Area addresses may be flagged
 *		Bank size may be flagged.
 */

void
chkbank(FILE *fp)
{
	a_uint alow, ahigh, addr;

	for (bp = bankp; bp != NULL; bp = bp->b_bp) {
		alow = ~0;
		ahigh = 0;
		for (ap = areap; ap != NULL; ap = ap->a_ap) {
			if (ap->a_bp != bp) {
				continue;
			}
			if ((ap->a_flag & A4_BNK) != A4_BNK) {
				continue;
			}
			addr = ap->a_addr * (1 + (ap->a_flag & A4_WLMSK));
			if (addr < alow) {
				alow = addr;
			}
			if ((bp->b_flag & B_BASE) && bp->b_base) {
				if (addr < bp->b_base) {
					fprintf(fp,
					"?ASlink-Error-Base Address of Area[%s] less than Bank[%s] Base Address\n", ap->a_id, bp->b_id);
					lkerr++;
				}
			}
			addr = (ap->a_addr + ap->a_size) * (1 + (ap->a_flag & A4_WLMSK));
			if (addr > ahigh) {
				ahigh = addr;
			}
			if ((bp->b_flag & B_SIZE) && bp->b_size) {
				if ((alow != ~0) && (ahigh != 0) && (addr > (bp->b_base + bp->b_size))) {
					fprintf(fp,
					"?ASlink-Error-Addresses in Area[%s] overflow Bank[%s] region\n", ap->a_id, bp->b_id);
					lkerr++;
				}
			}
		}
		if ((bp->b_flag & B_SIZE) && bp->b_size) {
			if ((alow != ~0) && (ahigh != 0) && ((ahigh - alow) > bp->b_size)) {
				fprintf(fp,
				"?ASlink-Error-Size limit exceeded in Bank[%s]\n", bp->b_id);
				lkerr++;
			}
		}
	}
}


/*)Function	void	lkfopen(void)
 *
 *	The function lkfopen() scans the bank/area structures to
 *	open output data files for banks with any data.  Files
 *	are not opened for banks/areas with no output data.
 *
 *	The bank structures are first scanned to create the
 *	file specification from the output file name combined
 *	with any given file suffixs.
 *
 *	local variables:
 *		int	idx		position of FSEPX in file specification
 *		File *	fp		temporary file handle
 *		char *	frmt		temporary file type string
 *		char *	str[]		File Specification String
 *		struct bank *tbp	temporary bank pointer
 *
 *
 *	global variables:
 *		area	*ap		Pointer to the current
 *				 	area structure
 *		area	*areap		The pointer to the first
 *				 	area structure of a linked list
 *		char	afspec[]	Filespec from afile()
 *		bank	*bp		Pointer to the current
 *				 	bank structure
 *		bank	*bankp		The pointer to the first
 *				 	bank structure of a linked list
 *		int	jflag		Enable NoICE output flag
 *		FILE *	jfp		NoICE output file handle
 *		int	oflag		data output type flag
 *		FILE *	stderr		Standard Error Output handle
 *
 *	functions called:
 *		FILE *	afile()		lkmain.c
 *		int	fclose()	c_library
 *		int	fprintf()	c_library
 *		void	lkexit()	lkmain.c
 *		char *	strcpy()	c_library
 *		char *	strsto()	lksym.c
 *		char *	symeq()		lksym.c
 *
 *	side effects:
 *		All data output files are opened.
 */

void
lkfopen(void)
{
	int idx;
	char str[NCPS+NCPS];
	struct bank *tbp;
	struct sym *sp;
	FILE * fp;

	/*
	 * If -O+ And No -i/-s/-t Then Default Output To Hex
	 */
	if ((outnam != NULL) || (outext != NULL)) {
		if (oflag == 0) {
			oflag = 1;
		}
	}

	if (oflag == 0) return;

	if (outnam != NULL) {
		idx = strlen(outnam);
		strcpy(str, outnam);
	} else {
		idx = linkp->f_idx + fndext(linkp->f_idp + linkp->f_idx);
		strncpy(str, linkp->f_idp, idx);
		str[idx] = 0;
	}

	/*
	 * Scan bank structures preparing
	 * the output file specifications.
	 */
	for (bp = bankp; bp != NULL; bp = bp->b_bp) {
		if (bp->b_flag & B_FSFX) {
			strcpy(str + idx, bp->b_fsfx);
		}
		bp->b_fspec = strsto(str);
		str[idx] = 0;
	}

	/*
	 * If .__.END. is defined force
	 * an output file to be opened.
	 */
	sp = lkpsym(".__.END.", 0);
	if (sp) {
		sp->s_axp->a_bap->a_flag |= A4_OUT;
	}

	/*
	 * Scan the area list opening the appropriate
	 * output file if there is data in the area.
	 */
	ap = areap;
	while (ap) {
		if ((ap->a_flag & A4_BNK) != A4_BNK) {
			ap->a_bp = bankp;
		}
		if ((ap->a_flag & A4_OUT) || (ap->a_size != 0)) {
			bp = ap->a_bp;
			if (bp->b_ofp == NULL) {
				/*
				 * Scan file specifications for
				 * identical file already opened.
				 */
				for (tbp = bankp; tbp != NULL; tbp = tbp->b_bp) {
					if (symeq(tbp->b_fspec, bp->b_fspec, 1)) {
						if (tbp->b_ofp != NULL) {
							bp->b_ofp = tbp->b_ofp;
							bp->b_ofspec = tbp->b_ofspec;
						}
					}
				}
			}
			if (bp->b_ofp == NULL) {
				fp = stderr;
				/*
				 * Open output file
				 */
				if (oflag == 1) {
					if (outext == NULL) {
						outext = "hex";
					}
					fp = afile(bp->b_fspec, outext, 1);
				} else
				if (oflag == 2) {
					if (outext == NULL) {
						switch(a_bytes) {
						default:
						case 2: outext = "s19"; break;
						case 3: outext = "s28"; break;
						case 4: outext = "s37"; break;
						}
					}
					fp = afile(bp->b_fspec, outext, 1);
				} else
				if (oflag == 3) {
					if (outext == NULL) {
						outext = "bin";
					}
					fp = afile(bp->b_fspec, outext, 3);
				}
				if (fp != stderr) {
					if (fp == NULL) {
						lkexit(ER_FATAL);
					}
					bp->b_ofspec = strsto(afspec);
#if NOICE
					/*
					 * Include NoICE command to load file
					 */
       	                		if (jfp) {
						fprintf(jfp, "LOAD %s\n", bp->b_ofspec);
					}
#endif
				}
				bp->b_ofp = fp;
			}
			ap->a_ofp = bp->b_ofp;
		} else {
			ap->a_ofp = NULL;
		}
		ap = ap->a_ap;
	}
}


/*)Function	void	lkfclose(void)
 *
 *	The function lkfclose() scans the bank structures to
 *	close all open data output files.
 *
 *	local variables:
 *		struct bank *tbp	temporary bank pointer
 *
 *	global variables:
 *		bank	*bp		Pointer to the current
 *				 	bank structure
 *		bank	*bankp		The pointer to the first
 *				 	bank structure of a linked list
 *		FILE *	ofp		Output file handle
 *		FILE *	stderr		Standard Error Output handle
 *
 *	functions called:
 *		void	lkout()		lkout.c
 *		int	fclose()	c_library
 *		int	delete()	c_library
 *
 *	side effects:
 *		All open data output files are closed.
 */

void
lkfclose(void)
{
	struct bank *tbp;

	/*
	 * Scan Bank Structure
	 * Output data terminations
	 * and close open files
	 */
	bp = bankp;
	while (bp != NULL) {
		ofp = bp->b_ofp;
		if (ofp != NULL)	{
			lkout(0);
			if (ofp != stderr) {
				fclose(ofp);
			}
			/*
			 * Scan bank structure for
			 * identical file handles.
			 */
			for (tbp = bp->b_bp; tbp != NULL; tbp = tbp->b_bp) {
				if (tbp->b_ofp == ofp) {
					tbp->b_ofp = NULL;
				}
			}
			ofp = NULL;
			bp->b_ofp = NULL;
		}
		bp = bp->b_bp;
	}
}
