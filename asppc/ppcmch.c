/* ppcmch.c */

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


char	*cpu	= "PowerPC";
char	*dsft	= "asm";

struct area *pstk[16];	/* Push/Pop Area Stack */
int	pstkidx;	/* Push/Pop Area Stack Index */

#define	NB	512

int	*bp;
int	bm;
int	bb[NB];

/*
 * Process a machine op.
 */
void
machine(struct mne *mp)
{
	a_uint op;
	int rf, c;
	struct expr e1;
	char id[NCPS];

	clrexpr(&e1);

	/*
	 * Instructions on a Word Boundary
	 */
	if (dot.s_addr & 3) {
		outall();
		xerr('b', "Non-word aligned instruction address rounded up");
		dot.s_addr = (dot.s_addr + 3) & ~3;
	}

	op = mp->m_valu;
	rf = mp->m_type;
	switch (rf) {

	case S_ADD:
		operand_rs(&op);
		comma(1);
		operand_ra(&op);
		comma(1);
		operand_rb(&op);
		outa4b(op);
		break;

	case S_ADDI:
		operand_rs(&op);
		comma(1);
		operand_ra(&op);
		comma(1);
		operand_si(op);
		break;

	case S_ADDIC:
		operand_rs(&op);
		comma(1);
		operand_ra(&op);
		comma(1);
		operand_si(op);
		break;

	case S_ADDME:
		operand_rs(&op);
		comma(1);
		operand_ra(&op);
		outa4b(op);
		break;

	case S_AND:
		operand_ra(&op);
		comma(1);
		operand_rs(&op);
		comma(1);
		operand_rb(&op);
		outa4b(op);
		break;

	case S_ANDI:
		operand_ra(&op);
		comma(1);
		operand_rs(&op);
		comma(1);
		operand_ui(op);
		break;

	case S_B:
		operand_li(op);
		break;

	case S_BA:
		operand_lia(op);
		break;

	case S_BC:
		if (((c = get()) != '-') && (c != '+')) {
			unget(c);
		}
		operand_bo(&op, c);
		comma(1);
		operand_bi(&op);
		comma(1);
		operand_bd(op);
		break;

	case S_BCA:
		if (((c = get()) != '-') && (c != '+')) {
			unget(c);
		}
		operand_bo(&op, c);
		comma(1);
		operand_bi(&op);
		comma(1);
		operand_bda(op);
		break;

	case S_BCCTR:
		if (((c = get()) != '-') && (c != '+')) {
			unget(c);
		}
		operand_bo(&op, c);
		comma(1);
		operand_bi(&op);
		outa4b(op);
		break;

	case S_BCCTRE:
		if (((c = get()) != '-') && (c != '+')) {
			unget(c);
		}
		operand_bo(&op, c);
		comma(1);
		operand_bi(&op);
		outa4b(op);
		break;

	case S_BCTR:
		outa4b(op);
		break;

	case S_BDNZ:
		if ((c = get()) == '-') {
			op |= 0x1000000;
		}
		else if (c == '+') {
			op |= 0x1200000;
		}
		else {
			unget(c);
		}
		operand_bd(op);
		break;

	case S_BDNZA:
		if ((c = get()) == '-') {
			op |= 0x1000000;
		}
		else if (c == '+') {
			op |= 0x1200000;
		}
		else {
			unget(c);
		}
		operand_bda(op);
		break;

	case S_BDNZF:
		operand_bi(&op);
		comma(1);
		operand_bd(op);
		break;

	case S_BDNZFA:
		operand_bi(&op);
		comma(1);
		operand_bda(op);
		break;

	case S_BDNZFLR:
		if ((c = get()) == '+') {
			op |= 0x2000000;
		}
		else {
			unget(c);
		}
		operand_bi(&op);
		outa4b(op);
		break;

	case S_BDNZLR:
		if ((c = get()) == '-') {
			op |= 0x1000000;
		}
		else if (c == '+') {
			op |= 0x1200000;
		}
		else {
			unget(c);
		}
		outa4b(op);
		break;

	case S_BEQ:
		if ((c = get()) == '-') {
			op |= 0x400000;
		}
		else if (c == '+') {
			op |= 0x600000;
		}
		else {
			unget(c);
		}
		operand_cr(&op);
		comma(1);
		operand_bd(op);
		break;

	case S_BEQA:
		if ((c = get()) == '-') {
			op |= 0x400000;
		}
		else if (c == '+') {
			op |= 0x600000;
		}
		else {
			unget(c);
		}
		operand_cr(&op);
		comma(1);
		operand_bda(op);
		break;

	case S_BEQCTR:
		if ((c = get()) == '-') {
			op |= 0x4000000;
		}
		else if (c == '+') {
			op |= 0x2000000;
		}
		else {
			unget(c);
		}
		operand_cr(&op);
		outa4b(op);
		break;

	case S_CLRLDI:
		operand_ra(&op);
		comma(1);
		operand_rs(&op);
		comma(1);
		operand_mb6(&op);
		outa4b(op);
		break;

	case S_CLRLWI:
		operand_ra(&op);
		comma(1);
		operand_rs(&op);
		comma(1);
		operand_mb(&op);
		outa4b(op);
		break;

	case S_CMPD:
		operand_obf(&op);
		comma(1);
		operand_ra(&op);
		comma(1);
		operand_rb(&op);
		outa4b(op);
		break;

	case S_CMPDI:
		operand_obf(&op);
		comma(1);
		operand_ra(&op);
		comma(1);
		operand_si(op);
		break;

	case S_CMPLDI:
		operand_obf(&op);
		comma(1);
		operand_ra(&op);
		comma(1);
		operand_ui(op);
		break;

	case S_CNTLZD:
		operand_ra(&op);
		comma(1);
		operand_rs(&op);
		outa4b(op);
		break;

	case S_CRAND:
		operand_bt(&op);
		comma(1);
		operand_ba(&op);
		comma(1);
		operand_bb(&op);
		outa4b(op);
		break;

	case S_CRCLR:
		operand_bt(&op);
		operand_bat(&op);
		comma(1);
		operand_bba(&op);
		outa4b(op);
		break;

	case S_CREQV:
		operand_bt(&op);
		comma(1);
		operand_ba(&op);
		comma(1);
		operand_bb(&op);
		outa4b(op);
		break;

	case S_CRMOVE:
		operand_bt(&op);
		comma(1);
		operand_ba(&op);
		operand_bba(&op);
		outa4b(op);
		break;

	case S_CRNOR:
		operand_bt(&op);
		comma(1);
		operand_ba(&op);
		comma(1);
		operand_bb(&op);
		outa4b(op);
		break;

	case S_DCBF:
		operand_ra(&op);
		comma(1);
		operand_rb(&op);
		outa4b(op);
		break;

	case S_DCBT:
		operand_ct(&op);
		comma(1);
		operand_ra(&op);
		comma(1);
		operand_rb(&op);
		outa4b(op);
		break;

	case S_DSS:
		operand_strm(&op);
		outa4b(op);
		break;

	case S_DSSALL:
		outa4b(op);
		break;

	case S_DST:
		operand_ra(&op);
		comma(1);
		operand_rb(&op);
		comma(1);
		operand_strm(&op);
		outa4b(op);
		break;

	case S_FABS:
		operand_frs(&op);
		comma(1);
		operand_frb(&op);
		outa4b(op);
		break;

	case S_FADD:
		operand_frs(&op);
		comma(1);
		operand_fra(&op);
		comma(1);
		operand_frb(&op);
		outa4b(op);
		break;

	case S_FCMPO:
		operand_bf(&op);
		comma(1);
		operand_fra(&op);
		comma(1);
		operand_frb(&op);
		outa4b(op);
		break;

	case S_FMADD:
		operand_frs(&op);
		comma(1);
		operand_fra(&op);
		comma(1);
		operand_frc(&op);
		comma(1);
		operand_frb(&op);
		outa4b(op);
		break;

	case S_FMUL:
		operand_frs(&op);
		comma(1);
		operand_fra(&op);
		comma(1);
		operand_frc(&op);
		outa4b(op);
		break;

	case S_LBZ:
		operand_rs(&op);
		comma(1);
		expr(&e1, 0); /* D */
		if (getnb() != '(') {
			xerr('q', "Second Operand Must Be Addressing Mode");
		}
		operand_ra(&op);
		if (getnb() != ')') {
			xerr('q', "Second Operand Must Be Addressing Mode");
		}
		outr4bm(&e1, R_D, op);
		break;

	case S_LD:
		operand_rs(&op);
		comma(1);
		expr(&e1, 0); /* DS */
		if (getnb() != '(') {
			xerr('q', "Second Operand Must Be Addressing Mode");
		}
		operand_ra0(&op);
		if (getnb() != ')') {
			xerr('q', "Second Operand Must Be Addressing Mode");
		}
		outr4bm(&e1, R_DS, op);
		break;

	case S_LDARX:
		operand_rs(&op);
		comma(1);
		operand_ra0(&op);
		comma(1);
		operand_rb(&op);
		outa4b(op);
		break;

	case S_LDU:
		operand_rs(&op);
		comma(1);
		expr(&e1, 0); /* DS */
		if (getnb() != '(') {
			xerr('q', "Second Operand Must Be Addressing Mode");
		}
		operand_ral(&op);
		if (getnb() != ')') {
			xerr('q', "Second Operand Must Be Addressing Mode");
		}
		outr4bm(&e1, R_DS, op);
		break;

	case S_LFD:
		operand_frs(&op);
		comma(1);
		expr(&e1, 0); /* D */
		if (getnb() != '(') {
			xerr('q', "Second Operand Must Be Addressing Mode");
		}
		operand_ra(&op);
		if (getnb() != ')') {
			xerr('q', "Second Operand Must Be Addressing Mode");
		}
		outr4bm(&e1, R_D, op);
		break;

	case S_LFDUX:
		operand_frs(&op);
		comma(1);
		operand_ras(&op);
		comma(1);
		operand_rb(&op);
		outa4b(op);
		break;

	case S_LI:
		operand_rs(&op);
		comma(1);
		operand_si(op);
		break;

	case S_LSWI:
		operand_rs(&op);
		comma(1);
		operand_ra(&op);
		comma(1);
		operand_nb(&op);
		outa4b(op);
		break;

	case S_LVEBX:
		operand_vd(&op);
		comma(1);
		operand_ra(&op);
		comma(1);
		operand_rb(&op);
		outa4b(op);
		break;

	case S_LVEWX128:
		operand_vd128(&op);
		comma(1);
		operand_ra(&op);
		comma(1);
		operand_rb(&op);
		outa4b(op);
		break;

	case S_MCRF:
		operand_bf(&op);
		comma(1);
		operand_bfa(&op);
		outa4b(op);
		break;

	case S_MCRXR:
		operand_bf(&op);
		outa4b(op);
		break;

	case S_MFASR:
		operand_rs(&op);
		outa4b(op);
		break;

	case S_MFDBATL:
		operand_rs(&op);
		comma(1);
		operand_sprbat(&op);
		outa4b(op);
		break;

	case S_MFDEC:
		operand_rs(&op);
		outa4b(op);
		break;

	case S_MFFS:
		operand_frs(&op);
		outa4b(op);
		break;

	case S_MFOCRF:
		operand_rs(&op);
		comma(1);
		operand_fxm(&op);
		outa4b(op);
		break;

	case S_MFSPR:
		operand_rs(&op);
		comma(1);
		operand_spr(&op);
		outa4b(op);
		break;

	case S_MFSPRG:
		operand_rs(&op);
		comma(1);
		operand_sprg(&op);
		outa4b(op);
		break;

	case S_MFSR:
		operand_rs(&op);
		comma(1);
		operand_sr(&op);
		outa4b(op);
		break;

	case S_MFSRIN:
		operand_rs(&op);
		comma(1);
		operand_rb(&op);
		outa4b(op);
		break;

	case S_MFTB:
		operand_rs(&op);
		comma(1);
		operand_tbr(&op);
		outa4b(op);
		break;

	case S_MFVSCR:
		operand_vd(&op);
		outa4b(op);
		break;

	case S_MR:
		operand_ra(&op);
		comma(1);
		operand_rs(&op);
		operand_rbs(&op);
		outa4b(op);
		break;

	case S_MTCRF:
		operand_fxm(&op);
		comma(1);
		operand_rs(&op);
		outa4b(op);
		break;

	case S_MTDBATL:
		operand_sprbat(&op);
		comma(1);
		operand_rs(&op);
		outa4b(op);
		break;

	case S_MTFSB0:
		operand_bt(&op);
		outa4b(op);
		break;

	case S_MTFSF:
		operand_flm(&op);
		comma(1);
		operand_frb(&op);
		outa4b(op);
		break;

	case S_MTFSFI:
		operand_bf(&op);
		comma(1);
		operand_u(&op);
		outa4b(op);
		break;

	case S_MTMSRD:
		operand_rs(&op);
		comma(1);
		operand_mtmsrd_l(&op);
		outa4b(op);
		break;

	case S_MTOCRF:
		operand_fxm(&op);
		comma(1);
		operand_rs(&op);
		outa4b(op);
		break;

	case S_MTSPR:
		operand_spr(&op);
		comma(1);
		operand_rs(&op);
		outa4b(op);
		break;

	case S_MTSPRG:
		operand_sprg(&op);
		comma(1);
		operand_rs(&op);
		outa4b(op);
		break;

	case S_MTSR:
		operand_sr(&op);
		comma(1);
		operand_rs(&op);
		outa4b(op);
		break;

	case S_MTVSCR:
		operand_vb(&op);
		outa4b(op);
		break;

	case S_NOR:
		operand_ra(&op);
		comma(1);
		operand_rs(&op);
		comma(1);
		operand_rb(&op);
		outa4b(op);
		break;

	case S_ORI:
		operand_ra(&op);
		comma(1);
		operand_rs(&op);
		comma(1);
		operand_ui(op);
		break;

	case S_RLDCL:
		operand_ra(&op);
		comma(1);
		operand_rs(&op);
		comma(1);
		operand_rb(&op);
		comma(1);
		operand_mb6(&op);
		outa4b(op);
		break;

	case S_RLDCR:
		operand_ra(&op);
		comma(1);
		operand_rs(&op);
		comma(1);
		operand_rb(&op);
		comma(1);
		operand_mb6(&op);
		outa4b(op);
		break;

	case S_RLDIC:
		operand_ra(&op);
		comma(1);
		operand_rs(&op);
		comma(1);
		operand_sh6(&op);
		comma(1);
		operand_mb6(&op);
		outa4b(op);
		break;

	case S_RLWIMI:
		operand_ra(&op);
		comma(1);
		operand_rs(&op);
		comma(1);
		operand_sh(&op);
		comma(1);
		operand_mbe(&op);
		comma(1);
		operand_me(&op);
		outa4b(op);
		break;

	case S_RLWNM:
		operand_ra(&op);
		comma(1);
		operand_rs(&op);
		comma(1);
		operand_rb(&op);
		comma(1);
		operand_mbe(&op);
		comma(1);
		operand_me(&op);
		outa4b(op);
		break;

	case S_ROTLDI:
		operand_ra(&op);
		comma(1);
		operand_rs(&op);
		comma(1);
		operand_sh6(&op);
		outa4b(op);
		break;

	case S_ROTLWI:
		operand_ra(&op);
		comma(1);
		operand_rs(&op);
		comma(1);
		operand_sh(&op);
		outa4b(op);
		break;

	case S_SLBIE:
		operand_rb(&op);
		outa4b(op);
		break;

	case S_SYNC:
		operand_ls(&op);
		outa4b(op);
		break;

	case S_TDEQI:
		operand_ra(&op);
		comma(1);
		operand_si(op);
		break;

	case S_TDI:
		operand_to(&op);
		comma(1);
		operand_ra(&op);
		comma(1);
		operand_si(op);
		break;

	case S_TLBIE:
		operand_rb(&op);
		comma(1);
		operand_l(&op);
		outa4b(op);
		break;

	case S_VADDCUW:
		operand_vd(&op);
		comma(1);
		operand_va(&op);
		comma(1);
		operand_vb(&op);
		outa4b(op);
		break;

	case S_VADDFP128:
		operand_vd128(&op);
		comma(1);
		operand_va128(&op);
		comma(1);
		operand_vb128(&op);
		outa4b(op);
		break;

	case S_VCFPSXWS128:
		operand_vd128(&op);
		comma(1);
		operand_vb128(&op);
		comma(1);
		operand_simm(&op);
		outa4b(op);
		break;

	case S_VCFPUXWS128:
		operand_vd128(&op);
		comma(1);
		operand_vb128(&op);
		comma(1);
		operand_uimm(&op);
		outa4b(op);
		break;

	case S_VCFSX:
		operand_vd(&op);
		comma(1);
		operand_vb(&op);
		comma(1);
		operand_uimm(&op);
		outa4b(op);
		break;

	case S_VEXPTEFP:
		operand_vd(&op);
		comma(1);
		operand_vb(&op);
		outa4b(op);
		break;

	case S_VEXPTEFP128:
		operand_vd128(&op);
		comma(1);
		operand_vb128(&op);
		outa4b(op);
		break;

	case S_VMADDCFP128:
		operand_vd128(&op);
		comma(1);
		operand_va128(&op);
		comma(1);
		operand_vd128t(op);
		comma(1);
		operand_vb128(&op);
		outa4b(op);
		break;

	case S_VMADDFP:
		operand_vd(&op);
		comma(1);
		operand_va(&op);
		comma(1);
		operand_vc(&op);
		comma(1);
		operand_vb(&op);
		outa4b(op);
		break;

	case S_VMADDFP128:
		operand_vd128(&op);
		comma(1);
		operand_va128(&op);
		comma(1);
		operand_vb128(&op);
		comma(1);
		operand_vd128t(op);
		outa4b(op);
		break;

	case S_VMHADDSHS:
		operand_vd(&op);
		comma(1);
		operand_va(&op);
		comma(1);
		operand_vb(&op);
		comma(1);
		operand_vc(&op);
		outa4b(op);
		break;

	case S_VMR:
		operand_vd(&op);
		comma(1);
		operand_va(&op);
		operand_vab(&op);
		outa4b(op);
		break;

	case S_VNOR:
		operand_vd(&op);
		comma(1);
		operand_va(&op);
		comma(1);
		operand_vb(&op);
		outa4b(op);
		break;

	case S_VPERM128:
		operand_vd128(&op);
		comma(1);
		operand_va128(&op);
		comma(1);
		operand_vb128(&op);
		comma(1);
		operand_vc128(&op);
		outa4b(op);
		break;

	case S_VPERMWI128:
		operand_vd128(&op);
		comma(1);
		operand_vb128(&op);
		comma(1);
		operand_vperm128(&op);
		outa4b(op);
		break;

	case S_VPKD3D128:
		operand_vd128(&op);
		comma(1);
		operand_vb128(&op);
		comma(1);
		operand_vd3d0(&op);
		comma(1);
		operand_vd3d1(&op);
		comma(1);
		operand_vd3d2(&op);
		outa4b(op);
		break;

	case S_VRLIMI128:
		operand_vd128(&op);
		comma(1);
		operand_vb128(&op);
		comma(1);
		operand_uimm(&op);
		comma(1);
		operand_vd3d2(&op);
		outa4b(op);
		break;

	case S_VSLDOI:
		operand_vd(&op);
		comma(1);
		operand_va(&op);
		comma(1);
		operand_vb(&op);
		comma(1);
		operand_shb(&op);
		outa4b(op);
		break;

	case S_VSLDOI128:
		operand_vd128(&op);
		comma(1);
		operand_va128(&op);
		comma(1);
		operand_vb128(&op);
		comma(1);
		operand_shb(&op);
		outa4b(op);
		break;

	case S_VSPLTISB:
		operand_vd(&op);
		comma(1);
		operand_simm(&op);
		outa4b(op);
		break;

	case S_VUPKHSB128:
		operand_vd128(&op);
		comma(1);
		operand_vb128(&op);
		outa4b(op);
		break;

	case S_OPTN:	/* .enabl (op = 1), .dsabl (op = 0) */
		if (more()) {
			do {
				getid(id, -1);
				/* Floating Point Truncation */
				if (symeq(id, "fpt", 1)) { fpt = mp->m_flag; } else {
					err('u');
				}
			} while (more() && comma(0));
		}
		lmode = SLIST;
		break;

	case W_FLT16:
		do {
			atowrd();
			outaw(rslt[3]);
		} while (comma(0));
		break;

	case S_FLT32:
		do {
			atoflt();
			outaw(rslt[3]);
			outaw(rslt[2]);
		} while (comma(0));
		break;

	case D_FLT64:
		do {
			atodbl();
			outaw(rslt[3]);
			outaw(rslt[2]);
			outaw(rslt[1]);
			outaw(rslt[0]);
		} while (comma(0));
		break;

	case S_ENDIAN:
		hilo = op;
		break;

	default:
		xerr('o', "Internal Opcode Error");
		break;
	}
}

/*
 * Operand Output, notation taken from PearPC disassembler
 */
void
operand_ba(a_uint *op)
{
	a_uint v;

	v = absexpr();
	if (v & ~0x1F) {
		xerr('v', "BA Operand Must Be 0 To 31");
	}
	*op |= (v & 0x1F) << 16;
}

/* fake operand, should not parse a comma first */
void
operand_bat(a_uint *op)
{
	/* duplicate BT into BA (for crclr, crset) */
	*op |= (*op >> 5) & 0x1F0000;
}

void
operand_bb(a_uint *op)
{
	a_uint v;

	v = absexpr();
	if (v & ~0x1F) {
		xerr('v', "BB Operand Must Be 0 To 31");
	}
	*op |= (v & 0x1F) << 11;
}

/* fake operand, should not parse a comma first */
void
operand_bba(a_uint *op)
{
	/* duplicate BA into BB (for crmove, crnot) */
	*op |= (*op >> 5) & 0xF800;
}

/* must be called last, includes opcode output */
void
operand_bd(a_uint op)
{
	struct expr e1;
	INT32 dsplcmnt;

	clrexpr(&e1);
	expr(&e1, 0);
	if (mchpcr(&e1)) {
		dsplcmnt = ((INT32) (e1.e_addr - dot.s_addr));
#ifdef LONGINT
		if ((dsplcmnt < -32768l) || (dsplcmnt > 32767l)) {
#else
		if ((dsplcmnt < -32768) || (dsplcmnt > 32767)) {
#endif
			xerr('a', "Branch Target Out Of Range");
		}
		if (dsplcmnt & 3) {
			xerr('a', "Branch Target Not Aligned");
		}
		outa4b(op | (dsplcmnt & 0xFFFC));
	}
	else {
		outr4bm(&e1, R_DS | R_PCR0, op);
	}
}

/* must be called last, includes opcode output */
void
operand_bda(a_uint op)
{
	struct expr e1;

	clrexpr(&e1);
	expr(&e1, 0);
	outr4bm(&e1, R_DS | R_SGND, op);
}

void
operand_bf(a_uint *op)
{
	a_uint v;

	v = absexpr();
	if (v & ~7) {
		xerr('v', "BF Operand Must Be 0 To 7");
	}
	*op |= (v & 7) << 23;
}

void
operand_bfa(a_uint *op)
{
	a_uint v;

	v = absexpr();
	if (v & ~7) {
		xerr('v', "BFA Operand Must Be 0 To 7");
	}
	*op |= (v & 7) << 18;
}

void
operand_bi(a_uint *op)
{
	a_uint v;

	v = absexpr();
	if (v & ~0x1F) {
		xerr('v', "BI Operand Must Be 0 To 31");
	}
	*op |= (v & 0x1F) << 16;
}

void
operand_bo(a_uint *op, int c)
{
	a_uint v;

	v = absexpr();
	if ((c == '-') || (c == '+')) {
		if (v & 1) {
			xerr('v', "BO Operand Must Be Even With Branch Hint");
		}
		v = (v & ~1) | (c == '+');
	}
	if (v & ~0x1F) {
		xerr('v', "BO Operand Must Be 0 To 31");
	
	}
	*op |= (v & 0x1F) << 21;
}

void
operand_bt(a_uint *op)
{
	a_uint v;

	v = absexpr();
	if (v & ~0x1F) {
		xerr('v', "BT Operand Must Be 0 To 31");
	}
	*op |= (v & 0x1F) << 21;
}

void
operand_cr(a_uint *op)
{
	a_uint v;

	v = absexpr();
	if (v & ~7) {
		xerr('v', "CR Operand Must Be 0 To 7");
	}
	*op |= (v & 7) << 18;
}

void
operand_ct(a_uint *op)
{
	if (absexpr()) {
		xerr('v', "CT Operand Must Be 0");
	}
}

void
operand_flm(a_uint *op)
{
	a_uint v;

	v = absexpr();
	if (v & ~0xFF) {
		xerr('v', "FLM Operand Must Be 0 To 255");
	}
	*op |= (v & 0xFF) << 17;
}

void
operand_fra(a_uint *op)
{
	if (!admode(f_reg)) {
		xerr('q', "FRA Operand Must Be Fn");
	}
	*op |= aindx << 16;
}

void
operand_frb(a_uint *op)
{
	if (!admode(f_reg)) {
		xerr('q', "FRB Operand Must Be Fn");
	}
	*op |= aindx << 11;
}

void
operand_frc(a_uint *op)
{
	if (!admode(f_reg)) {
		xerr('q', "FRB Operand Must Be Fn");
	}
	*op |= aindx << 6;
}

void
operand_frs(a_uint *op)
{
	if (!admode(f_reg)) {
		xerr('q', "FRS Operand Must Be Fn");
	}
	*op |= aindx << 21;
}

void
operand_fxm(a_uint *op)
{
	a_uint v;

	v = absexpr();
	if (v & ~0xFF) {
		xerr('v', "FXM Operand Must Be 0 To 255");
	}
	*op |= (v & 0xFF) << 12;
}

void
operand_l(a_uint *op)
{
	a_uint v;

	v = absexpr();
	if (v & ~1) {
		xerr('v', "L Operand Must Be 0 To 1");
	}
	*op |= (v & 1) << 21;
}

/* must be called last, includes opcode output */
void
operand_li(a_uint op)
{
	struct expr e1;
	INT32 dsplcmnt;

	clrexpr(&e1);
	expr(&e1, 0);
	if (mchpcr(&e1)) {
		dsplcmnt = ((INT32) (e1.e_addr - dot.s_addr));
#ifdef LONGINT
		if ((dsplcmnt < -33554432l) || (dsplcmnt > 33554431l)) {
#else
		if ((dsplcmnt < -33554432) || (dsplcmnt > 33554431)) {
#endif
			xerr('a', "Branch Target Out Of Range");
		}
		if (dsplcmnt & 3) {
			xerr('a', "Branch Target Not Aligned");
		}
		outa4b(op | (dsplcmnt & 0x3FFFFFF));
	}
	else {
		outr4bm(&e1, R_LI | R_PCR0, op);
	}
}

/* must be called last, includes opcode output */
void
operand_lia(a_uint op)
{
	struct expr e1;

	clrexpr(&e1);
	expr(&e1, 0);
	outr4bm(&e1, R_LI | R_SGND, op);
}

void
operand_ls(a_uint *op)
{
	a_uint v;

	v = absexpr();
	if (v & ~3) {
		xerr('v', "LS Operand Must Be 0 To 3");
	}
	*op |= (v & 3) << 21;
}

void
operand_mb(a_uint *op)
{
	a_uint v;

	v = absexpr();
	if (v & ~0x1F) {
		xerr('v', "MB Operand Must Be 0 To 31");
	}
	*op |= (v & 0x1F) << 6;
}

void
operand_mb6(a_uint *op)
{
	a_uint v;

	v = absexpr();
	if (v & ~0x3F) {
		xerr('v', "MB6 Operand Must Be 0 To 63");
	}
	*op |= ((v & 0x1F) << 6) | (v & 0x20);
}

/*
 * if there is a following operand this should be the same as MB, but if not
 * then it should accept a mask and generate the MB and ME from it (not yet)
 */ 
void
operand_mbe(a_uint *op)
{
	a_uint v;

	v = absexpr();
	if (v & ~0x1F) {
		xerr('v', "MBE Operand Must Be 0 To 31");
	}
	*op |= (v & 0x1F) << 6;
}

void
operand_me(a_uint *op)
{
	a_uint v;

	v = absexpr();
	if (v & ~0x1F) {
		xerr('v', "ME Operand Must Be 0 To 31");
	}
	*op |= (v & 0x1F) << 1;
}

void
operand_mtmsrd_l(a_uint *op)
{
	a_uint v;

	v = absexpr();
	if (v & ~1) {
		xerr('v', "MTMSRD_L Operand Must Be 0 To 1");
	}
	*op |= (v & 1) << 16;
}

void
operand_nb(a_uint *op)
{
	a_uint v;

	v = absexpr();
	if ((v == 0) || (v > 32)) {
		xerr('v', "NB Operand Must Be 1 To 32");
	}
	*op |= (v & 0x1F) << 11;
}

/* like operand_bf() but supposed to be optional (not supported yet) */
void
operand_obf(a_uint *op)
{
	a_uint v;

	v = absexpr();
	if (v & ~7) {
		xerr('v', "OBF Operand Must Be 0 To 7");
	}
	*op |= (v & 7) << 23;
}

void
operand_ra(a_uint *op)
{
	if (!admode(r_reg)) {
		xerr('q', "RA Operand Must Be Rn");
	}
	*op |= aindx << 16;
}

void
operand_ra0(a_uint *op)
{
	if (admode(r_reg)) {
		if (aindx == 0) {
			xerr('v', "RA0 Operand May Not Be R0");
		}
		*op |= aindx << 16;
	}
	else if (absexpr()) {
		xerr('v', "RA0 Operand Must Be Rn Or 0");
	}
}

void
operand_ral(a_uint *op)
{
	if (!admode(r_reg)) {
		xerr('q', "RAL Operand Must Be Rn");
	}
	if (aindx == 0) {
		xerr('v', "RAL Operand May Not Be R0");
	}
	/* check it doesn't match RT field */
	*op |= aindx << 16;
}

void
operand_ras(a_uint *op)
{
	if (!admode(r_reg)) {
		xerr('q', "RAS Operand Must Be Rn");
	}
	if (aindx == 0) {
		xerr('v', "RAS Operand May Not Be R0");
	}
	*op |= aindx << 16;
}

void
operand_rb(a_uint *op)
{
	if (!admode(r_reg)) {
		xerr('q', "RB Operand Must Be Rn");
	}
	*op |= aindx << 11;
}

/* fake operand, should not parse a comma first */
void
operand_rbs(a_uint *op)
{
	/* duplicate RS into RB (for mr) */
	*op |= (*op >> 10) & 0xF800;
}

void
operand_rs(a_uint *op)
{
	if (!admode(r_reg)) {
		xerr('q', "RS Operand Must Be Rn");
	}
	*op |= aindx << 21;
}

void
operand_sh(a_uint *op)
{
	a_uint v;

	v = absexpr();
	if (v & ~0x1F) {
		xerr('v', "SH Operand Must Be 0 To 31");
	}
	*op |= (v & 0x1F) << 11;
}

void
operand_sh6(a_uint *op)
{
	a_uint v;

	v = absexpr();
	if (v & ~0x3F) {
		xerr('v', "SH Operand Must Be 0 To 63");
	}
	*op |= ((v & 0x20) >> 4) | ((v & 0x1F) << 11);
}

void
operand_shb(a_uint *op)
{
	a_uint v;

	v = absexpr();
	if (v & ~0xF) {
		xerr('v', "SHB Operand Must Be 0 To 15");
	}
	*op |= (v & 0xF) << 6;
}

/* must be called last, includes opcode output */
void
operand_si(a_uint op)
{
	struct expr e1;

	clrexpr(&e1);
	expr(&e1, 0);
	outr4bm(&e1, R_D | R_SGND, op);
}

void
operand_simm(a_uint *op)
{
	INT32 v;

	v = (INT32) absexpr();
	if ((v < -16) || (v > 15)) {
		xerr('v', "SIMM Operand Must Be -16 To 15");
	}
	*op |= (v & 0x1F) << 16;
}

void
operand_spr(a_uint *op)
{
	a_uint v;

	v = absexpr();
	if (v & ~0x3FF) {
		xerr('v', "SPR Operand Must Be 0 To 1023");
	}
	*op |= ((v & 0x3E0) << 6) | ((v & 0x1F) << 16);
}

void
operand_sprbat(a_uint *op)
{
	a_uint v;

	v = absexpr();
	if (v & ~3) {
		xerr('v', "SPRBAT Operand Must Be 0 To 3");
	}
	*op |= (v & 3) << 17;
}

void
operand_sprg(a_uint *op)
{
	a_uint v;

	v = absexpr();
	if (v & ~3) {
		xerr('v', "SPRG Operand Must Be 0 To 3");
	}
	*op |= (v & 3) << 16;
}

void
operand_sr(a_uint *op)
{
	a_uint v;

	v = absexpr();
	if (v & ~0xF) {
		xerr('v', "SR Operand Must Be 0 To 15");
	}
	*op |= (v & 0xF) << 16;
}

void
operand_strm(a_uint *op)
{
	a_uint v;

	v = absexpr();
	if (v & ~3) {
		xerr('v', "STRM Operand Must Be 0 To 3");
	}
	*op |= (v & 3) << 21;
}

/* optional operand, should not parse a comma first */
void
operand_tbr(a_uint *op)
{
	a_uint v;

	/* same as SPR, but has value 268 (TB) if omitted */
	if (comma(0)) {
		v = absexpr();
		if (v & ~0x3FF) {
			xerr('v', "TBR Operand Must Be 0 To 1023");
		}
	}
	else {
		v = 268;
	}
	*op |= ((v & 0x3E0) << 6) | ((v & 0x1F) << 16);
}

void
operand_to(a_uint *op)
{
	a_uint v;

	v = absexpr();
	if (v & ~0x1F) {
		xerr('v', "TO Operand Must Be 0 To 31");
	}
	*op |= (v & 0x1F) << 21;
}

void
operand_u(a_uint *op)
{
	a_uint v;

	v = absexpr();
	if (v & ~0xF) {
		xerr('v', "U Operand Must Be 0 To 15");
	}
	*op |= (v & 0xF) << 12;
}

/* must be called last, includes opcode output */
void
operand_ui(a_uint op)
{
	struct expr e1;

	clrexpr(&e1);
	expr(&e1, 0);
	outr4bm(&e1, R_D | R_OVRF, op);
}

void
operand_uimm(a_uint *op)
{
	a_uint v;

	v = absexpr();
	if (v & ~0x1F) {
		xerr('v', "UIMM Operand Must Be 0 To 31");
	}
	*op |= (v & 0x1F) << 16;
}

void
operand_va(a_uint *op)
{
	if (!admode(vr_reg)) {
		xerr('q', "VA Operand Must Be VRn");
	}
	if (aindx & ~0x1F) {
		xerr('v', "VA Operand Must Be VR0 To VR31");
	}
	*op |= (aindx & 0x1F) << 16;
}

void
operand_va128(a_uint *op)
{
	if (!admode(vr_reg)) {
		xerr('q', "VA128 Operand Must Be VRn");
	}
	*op |= ((aindx & 0x1F) << 16) | ((aindx & 0x40) << 4) | (aindx & 0x20);
}

/* fake operand, should not parse a comma first */
void
operand_vab(a_uint *op)
{
	/* duplicate VA into VB (for vnot, vmr) */
	*op |= (*op >> 5) & 0x1F0000;
}

void
operand_vb(a_uint *op)
{
	if (!admode(vr_reg)) {
		xerr('q', "VB Operand Must Be VRn");
	}
	if (aindx & ~0x1F) {
		xerr('v', "VB Operand Must Be VR0 To VR31");
	}
	*op |= (aindx & 0x1F) << 11;
}

void
operand_vb128(a_uint *op)
{
	if (!admode(vr_reg)) {
		xerr('q', "VB128 Operand Must Be VRn");
	}
	*op |= ((aindx & 0x1F) << 11) | ((aindx & 0x60) >> 5);
}

void
operand_vc(a_uint *op)
{
	if (!admode(vr_reg)) {
		xerr('q', "VC Operand Must Be VRn");
	}
	if (aindx & ~0x1F) {
		xerr('v', "VC Operand Must Be VR0 To VR31");
	}
	*op |= (aindx & 0x1F) << 6;
}



void
operand_vc128(a_uint *op)
{
	if (!admode(vr_reg)) {
		xerr('q', "VC128 Operand Must Be VRn");
	}
	if (aindx & ~7) {
		xerr('v', "VC128 Operand Must Be VR0 To VR7");
	}
	*op |= (aindx & 7) << 6;
}

void
operand_vd(a_uint *op)
{
	if (!admode(vr_reg)) {
		xerr('q', "VD Operand Must Be VRn");
	}
	if (aindx & ~0x1F) {
		xerr('v', "VD Operand Must Be VR0 To VR31");
	}
	*op |= (aindx & 0x1F) << 21;
}

void
operand_vd128(a_uint *op)
{
	if (!admode(vr_reg)) {
		xerr('q', "VD128 Operand Must Be VRn");
	}
	*op |= ((aindx & 0x1F) << 21) | ((aindx & 0x60) >> 3);
}

/*
 * added by Nick due to VMX128 instructions that use VD128 twice, disassembler
 * simply puts the same operand twice in the list, but assembler must check it
 *
 * see https://github.com/xenia-project/xenia/blob/master/docs/ppc/vmx128.txt
 */
void
operand_vd128t(a_uint op)
{
	if (!admode(vr_reg)) {
		xerr('q', "VD128 Operand Must Be VRn");
	}
	if (aindx != (((op << 3) & 0x60) | ((op >> 21) & 0x1F))) {
		xerr('v', "VD128T Operand Must Be Same As VD128 Operand");
	}
}

void
operand_vd3d0(a_uint *op)
{
	a_uint v;

	v = absexpr();
	if (v & ~7) {
		xerr('v', "VD3D0 Operand Must Be 0 To 7");
	}
	*op |= (v & 7) << 18;
}

void
operand_vd3d1(a_uint *op)
{
	a_uint v;

	v = absexpr();
	if (v & ~3) {
		xerr('v', "VD3D1 Operand Must Be 0 To 3");
	}
	*op |= (v & 3) << 16;
}

void
operand_vd3d2(a_uint *op)
{
	a_uint v;

	v = absexpr();
	if (v & ~3) {
		xerr('v', "VD3D2 Operand Must Be 0 To 3");
	}
	*op |= (v & 3) << 6;
}

void
operand_vperm128(a_uint *op)
{
	a_uint v;

	v = absexpr();
	if (v & ~0xFF) {
		xerr('v', "VPERM128 Operand Must Be 0 To 255");
	}
	*op |= ((v & 0x1F) << 16) | ((v & 0xE0) << 1);
}

/*
 * Branch/Jump PCR Mode Check
 */
int
mchpcr(struct expr *esp)
{
	if (esp->e_base.e_ap == dot.s_area) {
		return(1);
	}
	if (esp->e_flag==0 && esp->e_base.e_ap==NULL) {
		/*
		 * Absolute Destination
		 *
		 * Use the global symbol '.__.ABS.'
		 * of value zero and force the assembler
		 * to use this absolute constant as the
		 * base value for the relocation.
		 */
		esp->e_flag = 1;
		esp->e_base.e_sp = &sym[1];
	}
	return(0);
}

/*
 * Store `b' in the next slot of the bit table.
 * If no room, force the longer form of the offset.
 */
int
setbit(int b)
{
	if (bp >= &bb[NB])
		return(1);
	if (b)
		*bp |= bm;
	bm <<= 1;
	if (bm == 0) {
		bm = 1;
		++bp;
	}
	return(b);
}

/*
 * Get the next bit from the bit table.
 * If none left, return a `1'.
 * This will force the longer form of the offset.
 */
int
getbit(void)
{
	int f;

	if (bp >= &bb[NB])
		return (1);
	f = *bp & bm;
	bm <<= 1;
	if (bm == 0) {
		bm = 1;
		++bp;
	}
	return (f);
}
/*
 * Machine specific initialization.
 */
void
minit(void)
{
	/*
	 * Byte Order
	 */
	hilo = 1;
	/*
	 * Addressing Size
	 */
	exprmasks(4);
	/*
	 * Reset Options
	 */
 	fpt = 0;	/* Floating Point Truncation */
	/*
	 * Reset Variable Length Instruction Parameters
	 */
	bp = bb;
	bm = 1;
	/*
	 * Reset Push/Pop Stack Index
	 */
	pstkidx = 0;
}
