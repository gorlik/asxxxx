/* ms40.h */

/*
 *  Copyright (C) 2026  Alan R. Baldwin
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

/*)BUILD
	$(PROGRAM) =	ASOLMS40
	$(INCLUDE) = {
		ASXXXX.H
		MS40.H
	}
	$(FILES) = {
		MS40MCH.C
		MS40PST.C
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
 * Processor Selection
 */
#define	S_CPU	30

#define	MSM5840		0
#define	MSM5842		1
#define	MSM58421	2
#define	MSM58422	3

/*
 * Addressing Types
 */
#define	S_IMMED	40		/* # - Immediate */
#define	S_EXT	41		/* An Expression */

/*
 * Instruction Types
 */
#define	I_ADR11	50		/* J, CAL */
#define	I_ADR6	51		/* JC */
#define	I_IMM4	52		/* AIS, LAI, LLI */
#define	I_IMM3	53		/* LHI */
#define	I_IMM2	54		/* SMI, LM, XM, TAB, TMB, TKB, SPB, RPB, SMB, RMB */
#define	I_IMM1	55		/* THB */
#define	I_LTI	56		/* LTI */

#define	I_INH	57		/* All Remaining Are Inherent */

/*
 * Extended Addressing Modes (MSM5840)
 */
#define	M_ADR11	0x0100		/* 11-Bit Addressing Mode */
#define	M_ADR6	0x0200		/* 6-Bit Addressing Mode */
#define	M_IMM4	0x0300		/* 4-Bit Argument Mode */
#define	M_IMM3	0x0400		/* 3-Bit Argument Mode */
#define	M_IMM2	0x0500		/* 2-Bit Argument Mode */
#define	M_IMM1	0x0600		/* 1-Bit Argument Mode */

/*
 * MSM5842 9-Bit Addressing Mode
 */
#define	M_ADR9	0x0700		/* 9-Bit Addressing Mode */


	/* machine dependent functions */

	/* ms40mch.c */
extern	void		machine(struct mne *mp);
extern	void		minit(void);

	/* xxxadr.c */
extern	int		addr(struct expr *esp);
extern	int		aindx;

