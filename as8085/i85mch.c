/* i85mch.c */

/*
 * (C) Copyright 1989-2006
 * All Rights Reserved
 *
 * Alan R. Baldwin
 * 721 Berkeley St.
 * Kent, Ohio  44240
 */

#include "asxxxx.h"
#include "i8085.h"

/*
 * Opcode Cycle Definitions
 */
#define	OPCY_SDP	((char) (0xFF))
#define	OPCY_ERR	((char) (0xFE))

/*	OPCY_NONE	((char) (0x80))	*/
/*	OPCY_MASK	((char) (0x7F))	*/

#define	UN	((char) (OPCY_NONE | 0x00))

/*
 * 8085 Cycle Count
 *
 *	opcycles = h8pg1[opcode]
 */
static char i85pg1[256] = {
/*--*--* 0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F */
/*--*--* -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - */
/*00*/   4,10, 7, 6, 4, 4, 7, 4,UN,10, 7, 6, 4, 4, 7, 4,
/*10*/  UN,10, 7, 6, 4, 4, 7, 4,UN,10, 7, 6, 4, 4, 7, 4,
/*20*/   4,10,16, 6, 4, 4, 7, 4,UN,10,16, 6, 4, 4, 7, 4,
/*30*/   4,10,13, 6,10,10,10, 4,UN,10,13, 6, 4, 4, 7, 4,
/*40*/   4, 4, 4, 4, 4, 4, 4, 7, 4, 4, 4, 4, 4, 4, 7, 4,
/*50*/   4, 4, 4, 4, 4, 4, 4, 7, 4, 4, 4, 4, 4, 4, 7, 4,
/*60*/   4, 4, 4, 4, 4, 4, 4, 7, 4, 4, 4, 4, 4, 4, 7, 4,
/*70*/   7, 7, 7, 7, 7, 7, 4, 7, 4, 4, 4, 4, 4, 4, 7, 4,
/*80*/   4, 4, 4, 4, 4, 4, 7, 4, 4, 4, 4, 4, 4, 4, 7, 4,
/*90*/   4, 4, 4, 4, 4, 4, 7, 4, 4, 4, 4, 4, 4, 4, 7, 4,
/*A0*/   4, 4, 4, 4, 4, 4, 7, 4, 4, 4, 4, 4, 4, 4, 7, 4,
/*B0*/   4, 4, 4, 4, 4, 4, 7, 4, 4, 4, 4, 4, 4, 4, 7, 4,
/*C0*/  12,10,10,10,18,12, 7,12,12,10,10,UN,18,18, 7,12,
/*D0*/  12,10,10,10,18,12, 7,12,12,UN,10,10,18,UN, 7,12,
/*E0*/  12,10,10,16,18,12, 7,12,12, 6,10, 4,18,UN, 7,12,
/*F0*/  12,10,10, 4,18,12, 7,12,12, 6,10, 4,18,UN, 7,12
};

/*
 * Process machine ops.
 */
VOID
machine(mp)
struct mne *mp;
{
	unsigned op, rd, rs;
	struct expr e;

	clrexpr(&e);
	op = (int) mp->m_valu;
	switch (mp->m_type) {

	case S_INH:
		outab(op);
		break;

	case S_RST:
		rd = (int) absexpr();
		if (rd > 7)
			aerr();
		out3(op, rd);
		break;

	case S_ADI:
		expr(&e, 0);
		outab(op);
		outrb(&e, 0);
		break;

	case S_ADD:
		rd = reg();
		if (rd > A)
			aerr();
		outab(op | rd);
		break;

	case S_JMP:
		expr(&e, 0);
		outab(op);
		outrw(&e, 0);
		break;

	case S_INR:
		rd = reg();
		if (rd > A)
			aerr();
		out3(op, rd);
		break;

	case S_LXI:
		rd = reg();
		comma();
		expr(&e, 0);
		out3(op, regpair(rd, SP));
		outrw(&e, 0);
		break;

	case S_LDAX:
		rd = reg();
		if (rd!=B && rd!=D)
			aerr();
		out3(op, rd);
		break;

	case S_INX:
		rd = reg();
		out3(op, regpair(rd, SP));
		break;

	case S_PUSH:
		rd = reg();
		out3(op, regpair(rd, PSW));
		break;

	case S_MOV:
		rd = reg();
		comma();
		rs = reg();
		if (rs>A || rd>A)
			aerr();
		outab(op | rs | (rd<<3));
		break;

	case S_MVI:
		rd = reg();
		comma();
		expr(&e, 0);
		if (rd > A)
			aerr();
		out3(op, rd);
		outrb(&e, 0);
		break;

	default:
		opcycles = OPCY_ERR;
		err('o');
		break;
	}
	if (opcycles == OPCY_NONE) {
		opcycles = i85pg1[cb[0] & 0xFF];
	}
}

/*
 * Is the next character a comma ?
 */
int
comma()
{
	if (getnb() != ',')
		qerr();
	return(1);
}

/*
 * Output a | (b<<3);
 */
VOID
out3(a, b)
int a;
int b;
{
	outab(a | (b<<3));
}

/*
 * Make sure that `r' is usable as a
 * register pair specifier. The extra
 * register (code 3) is `s'.
 */
int
regpair(r, s)
int r;
int s;
{
	if (r < M) {
		if (r&01)
			aerr();
	} else  if (r == s)
		r = 6;
	else
		aerr();
	return (r);
}

/*
 * Read a register name.
 */
int
reg()
{
	struct mne *mp;
	char id[NCPS];

	getid(id, -1);
	if ((mp = mlookup(id))==NULL || mp->m_type!=S_REG) {
		aerr();
		return (0);
	}
	return ((int) mp->m_valu);
}

/*
 * Dummy machine specific init.
 */
VOID
minit()
{
}
