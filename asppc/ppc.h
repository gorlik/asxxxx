/* ppc.h */

/*
 *  Copyright (C) 2024-2025  Alan R. Baldwin
 *  Copyright (C) 2024-2025  Nick Downing
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
	$(PROGRAM) =	ASPowerPC
	$(INCLUDE) = {
		ASXXXX.H
		PowerPC.H
	}
	$(FILES) = {
		PowerPCMCH.C
		PowerPCADR.C
		PowerPCPST.C
		PowerPCCYC.C
		PowerPCFPP.C
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
 * PowerPC Instruction Types
 */
#define S_ADD		0x20
#define S_ADDI		0x21
#define S_ADDIC		0x22
#define S_ADDME		0x23
#define S_AND		0x24
#define S_ANDI		0x25
#define S_B		0x26
#define S_BA		0x27
#define S_BC		0x28
#define S_BCA		0x29
#define S_BCCTR		0x2A
#define S_BCCTRE	0x2B
#define S_BCTR		0x2C
#define S_BDNZ		0x2D
#define S_BDNZA		0x2E
#define S_BDNZF		0x2F
#define S_BDNZFA	0x30
#define S_BDNZFLR	0x31
#define S_BDNZLR	0x32
#define S_BEQ		0x33
#define S_BEQA		0x34
#define S_BEQCTR	0x35
#define S_CLRLDI	0x36
#define S_CLRLWI	0x37
#define S_CMPD		0x38
#define S_CMPDI		0x39
#define S_CMPLDI	0x3A
#define S_CNTLZD	0x3B
#define S_CRAND		0x3C
#define S_CRCLR		0x3D
#define S_CREQV		0x3E
#define S_CRMOVE	0x3F
#define S_CRNOR		0x40
#define S_DCBF		0x41
#define S_DCBT		0x42
#define S_DSS		0x43
#define S_DSSALL	0x44
#define S_DST		0x45
#define S_FABS		0x46
#define S_FADD		0x47
#define S_FCMPO		0x48
#define S_FMADD		0x49
#define S_FMUL		0x4A
#define S_LBZ		0x4B
#define S_LD		0x4C
#define S_LDARX		0x4D
#define S_LDU		0x4E
#define S_LFD		0x4F
#define S_LFDUX		0x50
#define S_LI		0x51
#define S_LSWI		0x52
#define S_LVEBX		0x53
#define S_LVEWX128	0x54
#define S_MCRF		0x55
#define S_MCRXR		0x56
#define S_MFASR		0x57
#define S_MFDBATL	0x58
#define S_MFDEC		0x59
#define S_MFFS		0x5A
#define S_MFOCRF	0x5B
#define S_MFSPR		0x5C
#define S_MFSPRG	0x5D
#define S_MFSR		0x5E
#define S_MFSRIN	0x5F
#define S_MFTB		0x60
#define S_MFVSCR	0x61
#define S_MR		0x62
#define S_MTCRF		0x63
#define S_MTDBATL	0x64
#define S_MTFSB0	0x65
#define S_MTFSF		0x66
#define S_MTFSFI	0x67
#define S_MTMSRD	0x68
#define S_MTOCRF	0x69
#define S_MTSPR		0x6A
#define S_MTSPRG	0x6B
#define S_MTSR		0x6C
#define S_MTVSCR	0x6D
#define S_NOR		0x6E
#define S_ORI		0x6F
#define S_RLDCL		0x70
#define S_RLDCR		0x71
#define S_RLDIC		0x72
#define S_RLWIMI	0x73
#define S_RLWNM		0x74
#define S_ROTLDI	0x75
#define S_ROTLWI	0x76
#define S_SLBIE		0x77
#define S_SYNC		0x78
#define S_TDEQI		0x79
#define S_TDI		0x7A
#define S_TLBIE		0x7B
#define S_VADDCUW	0x7C
#define S_VADDFP128	0x7D
#define S_VCFPSXWS128	0x7E
#define S_VCFPUXWS128	0x7F
#define S_VCFSX		0x80
#define S_VEXPTEFP	0x81
#define S_VEXPTEFP128	0x82
#define S_VMADDCFP128	0x83
#define S_VMADDFP	0x84
#define S_VMADDFP128	0x85
#define S_VMHADDSHS	0x86
#define S_VMR		0x87
#define S_VNOR		0x88
#define S_VPERM128	0x89
#define S_VPERMWI128	0x8A
#define S_VPKD3D128	0x8B
#define S_VRLIMI128	0x8C
#define S_VSLDOI	0x8D
#define S_VSLDOI128	0x8E
#define S_VSPLTISB	0x8F
#define S_VUPKHSB128	0x90

/*
 * Assembler Options
 */
#define	S_FCD		0xA0	/* Function Control Directives */

#define	W_FLT16		0xA1	/* 16-Bit Floating Point */
#define	S_FLT32		0xA2	/* 32-Bit Floating Point */
#define	D_FLT64		0xA3	/* 64-Bit Floating Point */

#define	S_ENDIAN	0xA4
#define O_LE		0
#define O_BE		1

/*
 * Extended Addressing Modes
 */
#define R_D		0x0100		/* 16-Bit Addressing Mode */
#define	R_DS		0x0200		/* 16-Bit (To 14-Bit) Mode */
#define	R_LI		0x0300		/* 26-Bit (To 24-Bit) Mode */
#define	R_MFC0		0x0400		/* 3-Bit Addressing Mode */
#define	R_SLL		0x0500		/* 5-Bit << 6 Addressing Mode */

/*
 * Permanent symbols accessible as constants
 */
#define O_CR0	0
#define O_CR1	1
#define O_CR2	2
#define O_CR3	3
#define O_CR4	4
#define O_CR5	5
#define O_CR6	6
#define O_CR7	7
#define O_LT	0
#define O_GT	1
#define O_EQ	2
#define O_SO	3

/*
 * Variables
 */
extern int aindx;

struct adsym
{
	char	a_str[6];	/* addressing string */
	int	a_val;		/* addressing mode value */
};


	/* machine dependent functions */

	/* ppcadr.c */
extern	int		addr(struct expr *esp);
extern	int		admode(struct adsym *sp);
extern	int		srch(char *str);
extern	struct adsym	r_reg[];
extern	struct adsym	f_reg[];
extern	struct adsym	vr_reg[];

	/* ppcmch.c */
extern	void		machine(struct mne *mp);
extern	void		operand_ba(a_uint *op);
extern	void		operand_bat(a_uint *op);
extern	void		operand_bb(a_uint *op);
extern	void		operand_bba(a_uint *op);
extern	void		operand_bd(a_uint op);
extern	void		operand_bda(a_uint op);
extern	void		operand_bf(a_uint *op);
extern	void		operand_bfa(a_uint *op);
extern	void		operand_bi(a_uint *op);
extern	void		operand_bo(a_uint *op, int c);
extern	void		operand_bt(a_uint *op);
extern	void		operand_cr(a_uint *op);
extern	void		operand_ct(a_uint *op);
extern	void		operand_flm(a_uint *op);
extern	void		operand_fra(a_uint *op);
extern	void		operand_frb(a_uint *op);
extern	void		operand_frc(a_uint *op);
extern	void		operand_frs(a_uint *op);
extern	void		operand_fxm(a_uint *op);
extern	void		operand_l(a_uint *op);
extern	void		operand_li(a_uint op);
extern	void		operand_lia(a_uint op);
extern	void		operand_ls(a_uint *op);
extern	void		operand_mb(a_uint *op);
extern	void		operand_mb6(a_uint *op);
extern	void		operand_mbe(a_uint *op);
extern	void		operand_me(a_uint *op);
extern	void		operand_mtmsrd_l(a_uint *op);
extern	void		operand_nb(a_uint *op);
extern	void		operand_obf(a_uint *op);
extern	void		operand_ra(a_uint *op);
extern	void		operand_ra0(a_uint *op);
extern	void		operand_ral(a_uint *op);
extern	void		operand_ras(a_uint *op);
extern	void		operand_rb(a_uint *op);
extern	void		operand_rbs(a_uint *op);
extern	void		operand_rs(a_uint *op);
extern	void		operand_sh(a_uint *op);
extern	void		operand_sh6(a_uint *op);
extern	void		operand_shb(a_uint *op);
extern	void		operand_si(a_uint op);
extern	void		operand_simm(a_uint *op);
extern	void		operand_spr(a_uint *op);
extern	void		operand_sprbat(a_uint *op);
extern	void		operand_sprg(a_uint *op);
extern	void		operand_sr(a_uint *op);
extern	void		operand_strm(a_uint *op);
extern	void		operand_tbr(a_uint *op);
extern	void		operand_to(a_uint *op);
extern	void		operand_u(a_uint *op);
extern	void		operand_ui(a_uint op);
extern	void		operand_uimm(a_uint *op);
extern	void		operand_va(a_uint *op);
extern	void		operand_va128(a_uint *op);
extern	void		operand_vab(a_uint *op);
extern	void		operand_vb(a_uint *op);
extern	void		operand_vb128(a_uint *op);
extern	void		operand_vc(a_uint *op);
extern	void		operand_vc128(a_uint *op);
extern	void		operand_vd(a_uint *op);
extern	void		operand_vd128(a_uint *op);
extern	void		operand_vd128t(a_uint op);
extern	void		operand_vd3d0(a_uint *op);
extern	void		operand_vd3d1(a_uint *op);
extern	void		operand_vd3d2(a_uint *op);
extern	void		operand_vperm128(a_uint *op);
extern	int		mchpcr(struct expr *esp);
extern	int		setbit(int b);
extern	int		getbit(void);
extern	void		minit(void);

	/* ppccyc.c */
extern	int		mchcycles(struct mne *mp, a_uint opcode, int cycles);
extern	int		mclookup(struct mne *mp);


	/* ppcfpp.c */
extern	int		fpt;
extern	unsigned int	rslt[4];
extern	void		atowrd(void);
extern	void		atoflt(void);
extern	void		atodbl(void);
extern	int		atofd(int fd);
extern	void		fltsv(void);
extern	void		fltrs(void);
extern	void		fltls(void);
extern	void		fltm54(void);
extern	void		fltm5(void);
extern	void		fltad(void);

