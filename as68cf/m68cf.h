/* m68cf.h */

/*
 *  Copyright (C) 2023-2024  Alan R. Baldwin
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
	$(PROGRAM) =	AS68K
	$(INCLUDE) = {
		ASXXXX.H
		M68CF.H
	}
	$(FILES) = {
		M68CFMCH.C
		M68CFADR.C
		M68CFPST.C
		M68CFCYC.C
		M68CFFPP.C
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
 * Opcode Cycle Definitions
 */
#define	OPCY_SDP	0x7FFF
#define	OPCY_FLT16	0x7FFE
#define	OPCY_FLT32	0x7FFD
#define	OPCY_FLT64	0x7FFC
#define	OPCY_QWRD	0x7FFB
#define	OPCY_M68K	0x7FFA
#define	OPCY_ERR	0x7FF9

/*	OPCY_NONE	0x4000	*/
/*	OPCY_MASK	0x3FFF	*/

struct adsym
{
	char	a_str[10];	/* addressing string */
	int	a_val;		/* addressing mode value */
};

/*
 * Addressing types (Note These Are In Octal)
 *
 * Addressing Mode == S_xxxx & 070
 * When Addressing Mode == 070
 *	Sub Modes == S_xxxx & 007
 */
#define S_Dn	000	/* Dn		Data Register Direct */
#define S_An	010	/* An		Address Register Direct */
#define S_ARI	020	/* (An)		Address Register Indirect */
#define S_AINC	030	/* (An)+	Address Register Indirect With Postincrement */
#define S_ADEC	040	/* -(An)	Address Register Indirect With Predecrement */
#define S_ARID	050	/* d(An)	Address Register Indirect With Displacement */
#define S_ARIDX 060	/* d(An,Xi)	Address Register Indirect With Displacemment And Index*/

#define S_SHRT	070	/* NNN		Absolute Short */
#define S_LONG	071	/* NNNNNN	Absolute Long */
#define S_PCID	072	/* d(PC)	Program Counter Indirect With Displacemnet */
#define S_PCIDX	073	/* d(PC,Xi)	Program Counter Indirect With Displacement And Index */
#define S_IMM	074	/* #NNN		Immediate */
#define S_CCR	075	/* CCR Register */
#define S_SR	076	/* SR  Register */
#define S_USP	077	/* USP Register */

#define S_FPn	0100	/* FPn		Floating Point Register */
#define	S_FIMM	0174	/* #FFF		Floating Immediate */

/*
 * Relocation Modes
 */
#define	R_4BITS	0x0100	/* 4-Bit Addressing Mode */
#define	R_QBITS	0x0200	/* Quick Addressing Mode */
#define	R_CRBTS	0x0300	/* On Chip Rom Bits */

/*
 * Floating Instruction Types
 */
#define	F_COID	40	/* Co-Processor ID */

#define	F_TYP1	41	/* fabs, ... */
#define	F_TYP2	42	/* fadd, ... */
#define	F_TST	43	/* ftst */
#define	F_MOV	44	/* fmove */
#define	F_MOVM	45	/* fmovem */
#define	F_SVRS	46	/* fsave, frestore */
#define	F_NOP	47	/* fnop */
#define	F_BCC	48	/* fb_, ... */
#define	F_SCC	49	/* fs_, ... */

/*
 * Multiply-Accumulate Instruction Types
 */
#define	M_MAC	50	/* mac, msac, maaac, masac, msaac, mssac */
#define	M_MCLR	51	/* movclr */

/*
 * ColdFire Instruction Types
 */
#define	S_TYP1	60	/* addx, subx */
#define	S_TYP2	61	/* add, and, or, sub */
#define	S_TYP3	62	/* adda, cmpa, suba */
#define	S_TYP4	63	/* addi, andi, cmpi, eori, ori, subi */
#define	S_TYP5	64	/* addq, subq, mov3q */
#define	S_TYP6	65	/* divs, divu, muls, mulu */
#define	S_TYP7	66	/* clr, tst */
#define	S_TYP8	67	/* jmp, jsr, lea, pea */
#define	S_TYP9	68	/* byterev, bitrev,ff1, neg, negx, not, scc, swap, unlk */

#define	S_SHFT	70	/* asl, asr, lsl, lsr */
#define	S_BCC	71	/* bra, bcc, bsr */
#define	S_TAS	72	/* tas, wddata */
#define	S_SCC	73	/* scc */
#define	S_BIT	74	/* bchg, bclr, bset, btst */
#define	S_CHK	75	/* chk */
#define	S_CHK2	76	/* chk2 */
#define	S_CAS	77	/* cas */
#define	S_CAS2	78	/* cas2 */
#define	S_INH	79	/* illegal, nop, reset, rte, rtr, rts, trapv */

#define	S_CMP	80	/* cmp */
#define	S_CMP2	81	/* cmp2 */
#define	S_CMPM	82	/* cmpm */
#define	S_EOR	83	/* eor */
#define	S_EXT	84	/* ext */
#define	S_EXTB	85	/* extb */
#define	S_STOP	86	/* stop, rtd */
#define	S_TPF	87	/* tpf */
#define	S_TRAP	88	/* trap */

#define	S_LINK	90	/* link */
#define	S_UNLK	91	/* unlk */

#define	S_MOV3Q 92	/* movq3 */
#define	S_MOVE	93	/* move */
#define	S_MOVEA 94	/* movea */
#define	S_MOVEC 95	/* movec */
#define	S_MOVEM 96	/* movem */
#define	S_MOVEQ 97	/* moveq */
#define	S_MVSZ	98	/* mvs, mvz */

#define	S_SHL	100	/* cpushl */
#define	S_TCH	101	/* intouch */
#define	S_STLD	102	/* stldsr */
#define	S_WDB	103	/* wedebug */
#define	S_REMS	104	/* rems */
#define	S_REMU	105	/* remu */

/*
 * Miscellaneous Mnemonics
 */
#define	S_FLT16	110	/* 16-Bit Floating Point */
#define	S_FLT32	111	/* 32-Bit Floating Point */
#define	S_FLT64	112	/* 64-Bit Floating Point */

#define	S_QWRD	115	/* Quad-Word Constant */

#define	S_M68K	116	/* .m68k */
#define	S_SDP	117	/* .setdp */
#define	S_PGD	118	/* .dpgbl */

/*
 * Allowed Data Size(s)
 */
#define	A_B	0x00	/* Byte */
#define	A_W	0x01	/* Word */
#define	A_L	0x02	/* Long */
#define	A_A	0x04	/* Auto Sized */
#define	A_U	0x08	/* Unsized */

#define	B_B	0x00	/* Byte Displacement */
#define	B_W	0x01	/* Word Displacement */
#define	B_L	0x02	/* Long Displacement */
#define	B_A	0x03	/* Auto Byte/Word/Long Displacement */

/*
 * Alternate Data Sizing
 */
#define	ALT_W	0x10	/* Flagged As MNE(.W) */
#define	ALT_L	0x20	/* Flagged As MNE(.L) */
#define	ALT_X	0x30	/* Flagged As MNE(.W/.L) */

/*
 * Floating Data Size(s)
 */
#define	F_L	0x00	/* Long */
#define	F_S	0x01	/* 32-Bit Float */
#define	F_W	0x04	/* Word */
#define	F_D	0x05	/* 64-Bit Float */
#define	F_B	0x06	/* Byte */
#define	F_A	0x07	/* Auto Select */

	/* machine dependent functions */

#ifdef	OTHERSYSTEM

	/* m68cfadr.c */
extern	struct	adsym	Dn[];
extern	struct	adsym	DnW[];
extern	struct	adsym	DnL[];
extern	struct	adsym	DnU[];
extern	struct	adsym	An[];
extern	struct	adsym	AnW[];
extern	struct	adsym	AnL[];
extern	struct	adsym	AnU[];
extern	struct	adsym	Sreg[];
extern	struct	adsym	Creg[];
extern	struct	adsym	PCreg[];
extern	struct	adsym	ACCn[];
extern	struct	adsym	MACR[];
extern	struct	adsym	FPn[];
extern	struct	adsym	FCR[];
extern	struct	adsym	SHL[];
extern	int		aindx;
extern	int		paged;
extern	int		autodpcnst;
extern	int		autodpsmbl;
extern	int		addr(struct expr *esp1, int sz, int *vx, int *px, int *xx);
extern	int		faddr(struct expr *esp, int fsz, int *vx);
extern	int		espmode(struct expr *esp, int *vx, int *px);
extern	int		anpcidx(struct expr *esp, int *xx, char *p, char *ptr);
extern	int		xi(void);
extern	int		admode(struct adsym *sp);
extern	int		srch(char *str);

	/* m68cfmch.c */
extern	int		m68k;
extern	int		m68f;
extern	int		rc;
extern	int		sz;
extern	int		fsz;
extern	int		coid;
extern	struct	area	*zpg;
extern	struct	area	*dpglo;
extern	struct	area	*dpghi;
extern	VOID		machine(struct mne *mp);
extern	int		asize(struct mne *mp);
extern	VOID		im(struct expr *e1, a_uint opcode, int opflg);
extern	VOID		ea(struct expr *e1, int t1, int p1, int x1, a_uint pcofst, a_uint opcode, int opflg);
extern	VOID		chkbrng(INT32 v1, char *p);
extern	VOID		chkwrng(INT32 v1, char *p);
extern	int		setwl(INT32 v1);
extern	int		setbwl(INT32 v1);
extern	VOID		fimm(struct expr *e1, int fsz);
extern	int		mvlist(int *rc);
extern	int		fmvlist(int *rc);
extern	int		fcrlist(int *rc);
extern	int		mchpcr(struct expr *esp);
extern	int		setbit(int b);
extern	int		getbit(void);
extern	int		mchoptn(char *id, int v);
extern	VOID		minit(void);

	/* m68cffpp.c */
extern	int		fpt;
extern	unsigned short	rslt[5];
extern	VOID		atowrd(void);
extern	VOID		atoflt(void);
extern	VOID		atodbl(void);
extern	VOID		atoext(void);
extern	int		atofd(int fd);
extern	VOID		atoint(void);
extern	VOID		fltzr(void);
extern	int		fltnz(void);
extern	VOID		fltsv(void);
extern	VOID		fltld2(void);
extern	VOID		fltsv2(void);
extern	VOID		fltrs(void);
extern	VOID		fltrs8(void);
extern	VOID		fltls(void);
extern	VOID		fltls8(void);
extern	VOID		fltnd(int base, int digit);
extern	VOID		fltad(void);
extern	VOID		fltsq(void);
extern	VOID		fltml(void);

#else

	/* m68cfadr.c */
extern	struct	adsym	Dn[];
extern	struct	adsym	DnW[];
extern	struct	adsym	DnL[];
extern	struct	adsym	DnU[];
extern	struct	adsym	An[];
extern	struct	adsym	AnW[];
extern	struct	adsym	AnL[];
extern	struct	adsym	AnU[];
extern	struct	adsym	Sreg[];
extern	struct	adsym	Creg[];
extern	struct	adsym	PCreg[];
extern	struct	adsym	ACCn[];
extern	struct	adsym	MACR[];
extern	struct	adsym	FPn[];
extern	struct	adsym	FCR[];
extern	struct	adsym	SHL[];
extern	int		aindx;
extern	int		paged;
extern	int		autodpcnst;
extern	int		autodpsmbl;
extern	int		addr();
extern	int		faddr();
extern	int		espmode();
extern	int		anpcidx();
extern	int		xi();
extern	int		admode();
extern	int		srch();

	/* m68cfmch.c */
extern	int		m68k;
extern	int		m68f;
extern	int		rc;
extern	int		sz;
extern	int		fsz;
extern	int		coid;
extern	struct	area	*zpg;
extern	struct	area	*dpglo;
extern	struct	area	*dpghi;
extern	VOID		machine();
extern	int		asize();
extern	VOID		im();
extern	VOID		ea();
extern	VOID		chkbrng();
extern	VOID		chkwrng();
extern	int		setwl();
extern	int		setbwl();
extern	VOID		fimm();
extern	int		mvlist();
extern	int		fmvlist();
extern	int		fcrlist();
extern	int		mchpcr();
extern	int		setbit();
extern	int		getbit();
extern	int		mchoptn();
extern	VOID		minit();

	/* m68cffpp.c */
extern	int		fpt;
extern	unsigned short	rslt[5];
extern	VOID		atowrd();
extern	VOID		atoflt();
extern	VOID		atodbl();
extern	VOID		atoext();
extern	int		atofd();
extern	VOID		atoint();
extern	VOID		fltzr();
extern	int		fltnz();
extern	VOID		fltsv();
extern	VOID		fltld2();
extern	VOID		fltsv2();
extern	VOID		fltrs();
extern	VOID		fltrs8();
extern	VOID		fltls();
extern	VOID		fltls8();
extern	VOID		fltnd();
extern	VOID		fltad();
extern	VOID		fltsq();
extern	VOID		fltml();

#endif
 
