/* m68k.h */

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
	
/*)BUILD
	$(PROGRAM) =	AS68K
	$(INCLUDE) = {
		ASXXXX.H
		M68K.H
	}
	$(FILES) = {
		M68KMCH.C
		M68KADR.C
		M68KPST.C
		M68KCYC.C
		M68KFPP.C
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
#define	OPCY_FLT96	0x7FFB
#define	OPCY_FLTPK	0x7FFA
#define	OPCY_QWRD	0x7FF9
#define	OPCY_M68K	0x7FF8
#define	OPCY_ERR	0x7FF7

/*	OPCY_NONE	0x4000	*/
/*	OPCY_MASK	0x3FFF	*/

struct adsym
{
	char	a_str[6];	/* addressing string */
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
 * Address Extension Word Defines
 */
#define	FF_FLAG	0x0100	/* Full Format Extension Flag */

#define	BS_ADD	0x0000	/* Base Address Add */
#define	BS_SUP	0x0080	/* Base Address Suppress */

#define	BD_NULL	0x0010	/* Base Displacement Size NULL */
#define	BD_WORD	0x0020	/* Base Displacement Size Word */
#define BD_LONG	0x0030	/* Base Displacement Size Long */

#define	IN_ADD	0x0000	/* Index Operand Add */
#define	IN_SUP	0x0040	/* Index Operand Suppress */

#define	IN_PRE	0x0000	/* Pre-Indexed */
#define	IN_POST	0x0004	/* Post-Indexed */

#define	OD_NULL	0x0001	/* Indirect Size NULL */
#define	OD_WORD	0x0002	/* Indirect Size Word */
#define	OD_LONG	0x0003	/* Indirect Size Long */

/*
 * Machine Types
 */
#define	S_68XXX		35

#define	M_68000		0
#define	M_68008		8
#define	M_68010		10
#define	M_68020		20

#define	M_68881		1
#define	M_68882		2
#define M_NONE		0

/*
 * Floating Point
 */
#define	S_FCOID		37

#define	M_COID		1

/*
 * 68000 Instruction Types
 */
#define	S_TYP1	60	/* abcd, sbcd, addx, subx */
#define	S_TYP2	61	/* add, sub */
#define	S_TYP3	62	/* adda, cmpa, suba */
#define	S_TYP4	63	/* addi, andi, cmpi, eori, ori, subi */
#define	S_TYP5	64	/* addq, subq */
#define	S_TYP6	65	/* divs, divu, muls, mulu */
#define	S_TYP7	66	/* clr, neg, negx, not, tst */
#define	S_TYP8	67	/* jmp, jsr, lea, pea */
#define	S_TYP9	68	/* nbcd, tas */

#define	S_SHFT	70	/* asl, asr, lsl, lsr, rol, ror, roxl, roxl */
#define	S_BCC	71	/* bra, bcc, bsr */
#define	S_DBCC	72	/* dbcc */
#define	S_SCC	73	/* scc */
#define	S_BIT	74	/* bchg, bclr, bset, btst */
#define	S_CHK	75	/* chk */
#define	S_INH	76	/* illegal, nop, reset, rte, rtr, rts, trapv */

#define	S_CMP	80	/* cmp */
#define	S_CMPM	81	/* cmpm */
#define	S_EOR	82	/* eor */
#define	S_EXG	83	/* exg */
#define	S_EXT	84	/* ext */
#define	S_LINK	85	/* link */
#define	S_STOP	86	/* stop, rtd */
#define	S_SWAP	87	/* swap */
#define	S_TRAP	88	/* trap */
#define	S_UNLK	89	/* unlk */

#define	S_MOVE	90	/* move */
#define	S_MOVEA 91	/* movea */
#define	S_MOVEC 92	/* movec */
#define	S_MOVEM 93	/* movem */
#define	S_MOVEP 94	/* movep */
#define	S_MOVEQ 95	/* moveq */
#define	S_MOVES 96	/* moves */

#define	S_FLT16	100	/* 16-Bit Floating Point */
#define	S_FLT32	101	/* 32-Bit Floating Point */
#define	S_FLT64	102	/* 64-Bit Floating Point */
#define	S_FLT96	103	/* 96-Bit Floating Point */
#define	S_FLTPK	104	/* Packed Floating Point */

#define	S_QWRD	105	/* Quad-Word Constant */

#define	S_M68K	106	/* .m68k */
#define	S_SDP	107	/* .setdp */
#define	S_PGD	108	/* .dpgbl */

/*
 * 68020 Instruction Types
 */
#define	S_68020	110	/* Start Of 68020 Instructions */

#define	S_BF	110	/* bfxxx */
#define	S_BKPT	111	/* bkpt */
#define	S_CALLM	112	/* callm */
#define	S_CAS	113	/* cas */
#define	S_CAS2	114	/* cas2 */
#define	S_CHK2	115	/* chk2 */
#define	S_CMP2	116	/* cmp2 */
#define	S_EXTB	117	/* extb */
#define	S_PKUK	118	/* pack, unpk */
#define	S_RTM	119	/* rtm */
#define	S_TRPC	120	/* trapcc */

/*
 * Allowed Data Size(s)
 */
#define	A_B	0x00	/* Byte */
#define	A_W	0x01	/* Word */
#define	A_L	0x02	/* Long */
#define	A_A	0x04	/* Auto Sized */
#define	A_U	0x08	/* Unsized */

#define	B_S	0x00	/* Byte Displacement */
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
 * Relocation Modes
 */
#define	R_3BITS	0x0100	/* 3-Bit Addressing Mode */
#define	R_4BITS	0x0200	/* 4-Bit Addressing Mode */
#define	R_QBITS	0x0300	/* Quick Addressing Mode */
#define	R_CRBTS	0x0400	/* On Chip Rom Bits */

/*
 * Floating Instruction Types
 */
#define	F_BGN	40	/* Start Of Floating Instructions */

#define	F_TYP1	40	/* fabs, ... */
#define	F_TYP2	41	/* fadd, ... */
#define	F_TST	42	/* ftst */
#define	F_SNCS	43	/* fsincos */
#define	F_MOV	44	/* move */
#define	F_MOVM	45	/* movem */
#define	F_MVCR	46	/* movecr */
#define	F_SVRS	47	/* fsave, frestore */
#define	F_NOP	48	/* fnop */

#define	F_BCC	50	/* fb_, ... */
#define	F_DCC	51	/* fdb_, ... */
#define	F_SCC	52	/* fs_, ... */
#define	F_TCC	53	/* ftrap_, ... */

#define	F_END	53	/* END Of Floating Instructions */

/*
 * Floating Data Size(s)
 */
#define	F_L	0x00	/* Long */
#define	F_S	0x01	/* 32-Bit Float */
#define	F_X	0x02	/* 80-Bit Float */
#define	F_P	0x03	/* Decimal Packed */
#define	F_W	0x04	/* Word */
#define	F_D	0x05	/* 64-Bit Float */
#define	F_B	0x06	/* Byte */
#define	F_A	0x07	/* Auto Select */

	/* machine dependent functions */

#ifdef	OTHERSYSTEM

	/* m68kadr.c */
extern	struct	adsym	Dn[];
extern	struct	adsym	DnW[];
extern	struct	adsym	DnL[];
extern	struct	adsym	An[];
extern	struct	adsym	AnW[];
extern	struct	adsym	AnL[];
extern	struct	adsym	Sreg[];
extern	struct	adsym	Creg[];
extern	struct	adsym	PCreg[];
extern	struct	adsym	FPn[];
extern	struct	adsym	FCR[];
extern	unsigned char	fpack[12];
extern	int		aindx;
extern	int		paged;
extern	int		autodpcnst;
extern	int		autodpsmbl;
extern	int		addr(struct expr *esp1, struct expr *esp2, int sz, int *vx, int *px, int *xx);
extern	int		faddr(struct expr *esp, int fsz, int *vx);
extern	int		espmode(struct expr *esp, int *vx, int *px);
extern	int		anpcidx(struct expr *esp, int *xx, char *p, char *ptr);
extern	int		xi(void);
extern	int		admode(struct adsym *sp);
extern	int		srch(char *str);

	/* m68kmch.c */
extern	int		mchtyp;
extern	int		flttyp;
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
extern	VOID		ea(struct expr *e1, struct expr *e1xi, int t1, int p1, int x1, a_uint pcofst, a_uint opcode, int opflg);
extern	VOID		chkbrng(INT32 v1, char *p);
extern	VOID		chkwrng(INT32 v1, char *p);
extern	int		setwl(INT32 v1);
extern	int		setbwl(INT32 v1);
extern	VOID		fimm(struct expr *e1, int fsz);
extern	int		mvlist(struct expr *esp, int *rc);
extern	VOID		fsz2sz(void);
extern	int		fmvlist(int *rc);
extern	int		fcrlist(int *rc);
extern	VOID		fltpk(void);
extern	int		mchpcr(struct expr *esp);
extern	int		setbit(int b);
extern	int		getbit(void);
extern	int		mchoptn(char *id, int v);
extern	VOID		minit(void);

	/* m68kcyc.c */
extern	int		eamlo(a_uint opcode);
extern	int		eamhi(a_uint opcode);
extern	int		mchcycles(struct mne *mp, a_uint opcode, a_uint op2, int x1, int x2, int rc, int cycles);
extern	int		mc68000cycles(struct mne *mp, a_uint opcode, int rc, int cycles);
extern	int		mc68008cycles(struct mne *mp, a_uint opcode, int rc, int cycles);
extern	int		mc68010cycles(struct mne *mp, a_uint opcode, int rc, int cycles);
extern	int		mc68020cycles(struct mne *mp, a_uint opcode, a_uint op2, int x1, int x2, int rc, int cycles);
extern	int		xefaindx(int ea, int sz, int x);
extern	int		xefacycles(unsigned char *tbl, int ea, int sz, int x);
extern	int		fefacycles(int ea, int sz, int x);
extern	int		cefacycles(int ea, int sz, int x);
extern	int		fiwefacycles(int ea, int sz, int x);
extern	int		filefacycles(int ea, int sz, int x);
extern	int		fiefacycles(int ea, int sz, int x);
extern	int		ciwefacycles(int ea, int sz, int x);
extern	int		cilefacycles(int ea, int sz, int x);
extern	int		ciefacycles(int ea, int sz, int x);
extern	int		jefacycles(int ea, int sz, int x);
extern	int		mc6888xcycles(struct mne *mp, a_uint opcode, a_uint op2, int x1, int x2, int rc, int cycles);
extern	int		feacycles(int xop, int x1, int x2);
extern	int		fppcycles(int xop);

	/* m68kfpp.c */
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

	/* m68kadr.c */
extern	struct	adsym	Dn[];
extern	struct	adsym	DnW[];
extern	struct	adsym	DnL[];
extern	struct	adsym	An[];
extern	struct	adsym	AnW[];
extern	struct	adsym	AnL[];
extern	struct	adsym	Sreg[];
extern	struct	adsym	Creg[];
extern	struct	adsym	PCreg[];
extern	struct	adsym	FPn[];
extern	struct	adsym	FCR[];
extern	unsigned char	fpack[];
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

	/* m68kmch.c */
extern	int		mchtyp;
extern	int		flttyp;
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
extern	VOID		fsz2sz();
extern	int		fmvlist();
extern	int		fcrlist();
extern	VOID		fltpk();
extern	int		mchpcr();
extern	int		setbit();
extern	int		getbit();
extern	int		mchoptn();
extern	VOID		minit();

	/* m68kcyc.c */
extern	int		eamlo();
extern	int		eamhi();
extern	int		mchcycles();
extern	int		mc68000cycles();
extern	int		mc68008cycles();
extern	int		mc68010cycles();
extern	int		mc68020cycles();
extern	int		xefaindx();
extern	int		xefacycles();
extern	int		fefacycles();
extern	int		cefacycles();
extern	int		fiwefacycles();
extern	int		filefacycles();
extern	int		fiefacycles();
extern	int		ciwefacycles();
extern	int		cilefacycles();
extern	int		ciefacycles();
extern	int		jefacycles();
extern	int		mc6888xcycles();
extern	int		feacycles();
extern	int		fppcycles();

	/* m68kfpp.c */
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
 
