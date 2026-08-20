/* xxx.h */

/*
 *  Copyright (C) 2026  xxxxxx
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
 */

/*)BUILD
	$(PROGRAM) =	ASxxxx
	$(INCLUDE) = {
		ASXXXX.H
		xxx.H
	}
	$(FILES) = {
		xxxMCH.C
		xxxPST.C
		ASMAIN.C
		ASMCRO.C
		ASDBG.C
		ASLEX.C
		ASSYM.C
		ASSUBR.C
		ASEXPR.C
		ASDATA.C
		ASLIST.C
		ASOUT.C
	}
	$(STACK) = 3000
*/

/*
 * Addressing Types
 */
#define	S_IMMED	40
#define	S_EXT	41

/*
 * Instruction types.
 */
#define	I_XXX	50		/* xxxxxx */

/*
 * Other
 */
#define	S_FLAG	70

/*
 * Registers.
 */
#define	R0	0

/*
 * Extended Addressing Modes
 */
#define	R_xxx	0x0100		/* xxxxxx */


	/* machine dependent functions */

	/* xxxmch.c */
extern	void		machine(struct mne *mp);
extern	void		minit(void);

	/* xxxadr.c */
extern	int		addr(struct expr *esp);
extern	int		aindx;

extern	int		admode(struct adsym *sp);
extern	int		srch(char *str);
extern	struct	adsym	reg[];

