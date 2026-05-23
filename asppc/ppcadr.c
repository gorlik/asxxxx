/* ppcadr.c */

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

int aindx;

#if 0 /* not used yet */
int
addr(struct expr *esp)
{
	int c;
	char *p, *q, *r;
	int reg;

	/*
	 * Scanning For (Rn)
	 */
	p = ip;
	r = NULL;
	q = NULL;
	reg = 0;
	while (more()) {
		if ((c = getnb()) == ',') {
			break;
		}
		q = ip;
		if ((c == '(') && admode(r_reg) && (getnb() == ')')) {
			r = ip;
			reg = aindx;
			break;
		}
		ip = q;
	}
	ip = p;

	if (r != NULL) {
		*(q-1) = 0;
	}
	expr(esp, 0);
	if (r != NULL) {
		*(q-1) = '(';
		ip = r;
	}

	return reg;
}
#endif

/*
 * When building a table that has variations of a common
 * symbol always start with the most complex symbol first.
 * for example if x, x+, and x++ are in the same table
 * the order should be x++, x+, and then x.  The search
 * order is then most to least complex.
 */

/*
 * When searching symbol tables that contain characters
 * not of type LTR16, eg with '-' or '+', always search
 * the more complex symbol tables first. For example:
 * searching for x+ will match the first part of x++,
 * a false match if the table with x+ is searched
 * before the table with x++.
 */

/*
 * Enter admode() to search a specific addressing mode table
 * for a match. Return (1) for a match, (0) for no match.
 * 'aindx' contains the value of the addressing mode.
 */
int
admode(struct adsym *sp)
{
	char *ptr;
	int i;
	char *ips;

	ips = ip;
	unget(getnb());

	i = 0;
	while ( *(ptr = &sp[i].a_str[0]) ) {
		if (srch(ptr)) {
			aindx = sp[i].a_val;
			return(1);
		}
		i++;
	}
	ip = ips;
	return(0);
}

/*
 *      srch --- does string match ?
 */
int
srch(char *str)
{
	char *ptr;
	ptr = ip;

	while (*ptr && *str) {
		if (ccase[*ptr & 0x007F] != ccase[*str & 0x007F])
			break;
		ptr++;
		str++;
	}
	if (ccase[*ptr & 0x007F] == ccase[*str & 0x007F]) {
		ip = ptr;
		return(1);
	}

	if (!*str)
		if (!(ctype[*ptr & 0x007F] & LTR16)) {
			ip = ptr;
			return(1);
		}
	return(0);
}

struct adsym	r_reg[] = {
    {	"r0",		0x00	},
    {	"r1",		0x01	},
    {	"r2",		0x02	},
    {	"r3",		0x03	},
    {	"r4",		0x04	},
    {	"r5",		0x05	},
    {	"r6",		0x06	},
    {	"r7",		0x07	},
    {	"r8",		0x08	},
    {	"r9",		0x09	},
    {	"r10",		0x0A	},
    {	"r11",		0x0B	},
    {	"r12",		0x0C	},
    {	"r13",		0x0D	},
    {	"r14",		0x0E	},
    {	"r15",		0x0F	},
    {	"r16",		0x10	},
    {	"r17",		0x11	},
    {	"r18",		0x12	},
    {	"r19",		0x13	},
    {	"r20",		0x14	},
    {	"r21",		0x15	},
    {	"r22",		0x16	},
    {	"r23",		0x17	},
    {	"r24",		0x18	},
    {	"r25",		0x19	},
    {	"r26",		0x1A	},
    {	"r27",		0x1B	},
    {	"r28",		0x1C	},
    {	"r29",		0x1D	},
    {	"r30",		0x1E	},
    {	"r31",		0x1F	},
    {	"",		0x00	}
};

struct adsym	f_reg[] = {
    {	"f0",		0x00	},
    {	"f1",		0x01	},
    {	"f2",		0x02	},
    {	"f3",		0x03	},
    {	"f4",		0x04	},
    {	"f5",		0x05	},
    {	"f6",		0x06	},
    {	"f7",		0x07	},
    {	"f8",		0x08	},
    {	"f9",		0x09	},
    {	"f10",		0x0A	},
    {	"f11",		0x0B	},
    {	"f12",		0x0C	},
    {	"f13",		0x0D	},
    {	"f14",		0x0E	},
    {	"f15",		0x0F	},
    {	"f16",		0x10	},
    {	"f17",		0x11	},
    {	"f18",		0x12	},
    {	"f19",		0x13	},
    {	"f20",		0x14	},
    {	"f21",		0x15	},
    {	"f22",		0x16	},
    {	"f23",		0x17	},
    {	"f24",		0x18	},
    {	"f25",		0x19	},
    {	"f26",		0x1A	},
    {	"f27",		0x1B	},
    {	"f28",		0x1C	},
    {	"f29",		0x1D	},
    {	"f30",		0x1E	},
    {	"f31",		0x1F	},
    {	"",		0x00	}
};

struct adsym	vr_reg[] = {
    {	"vr0",		0x00	},
    {	"vr1",		0x01	},
    {	"vr2",		0x02	},
    {	"vr3",		0x03	},
    {	"vr4",		0x04	},
    {	"vr5",		0x05	},
    {	"vr6",		0x06	},
    {	"vr7",		0x07	},
    {	"vr8",		0x08	},
    {	"vr9",		0x09	},
    {	"vr10",		0x0A	},
    {	"vr11",		0x0B	},
    {	"vr12",		0x0C	},
    {	"vr13",		0x0D	},
    {	"vr14",		0x0E	},
    {	"vr15",		0x0F	},
    {	"vr16",		0x10	},
    {	"vr17",		0x11	},
    {	"vr18",		0x12	},
    {	"vr19",		0x13	},
    {	"vr20",		0x14	},
    {	"vr21",		0x15	},
    {	"vr22",		0x16	},
    {	"vr23",		0x17	},
    {	"vr24",		0x18	},
    {	"vr25",		0x19	},
    {	"vr26",		0x1A	},
    {	"vr27",		0x1B	},
    {	"vr28",		0x1C	},
    {	"vr29",		0x1D	},
    {	"vr30",		0x1E	},
    {	"vr31",		0x1F	},
    {	"vr32",		0x20	},
    {	"vr33",		0x21	},
    {	"vr34",		0x22	},
    {	"vr35",		0x23	},
    {	"vr36",		0x24	},
    {	"vr37",		0x25	},
    {	"vr38",		0x26	},
    {	"vr39",		0x27	},
    {	"vr40",		0x28	},
    {	"vr41",		0x29	},
    {	"vr42",		0x2A	},
    {	"vr43",		0x2B	},
    {	"vr44",		0x2C	},
    {	"vr45",		0x2D	},
    {	"vr46",		0x2E	},
    {	"vr47",		0x2F	},
    {	"vr48",		0x30	},
    {	"vr49",		0x31	},
    {	"vr50",		0x32	},
    {	"vr51",		0x33	},
    {	"vr52",		0x34	},
    {	"vr53",		0x35	},
    {	"vr54",		0x36	},
    {	"vr55",		0x37	},
    {	"vr56",		0x38	},
    {	"vr57",		0x39	},
    {	"vr58",		0x3A	},
    {	"vr59",		0x3B	},
    {	"vr60",		0x3C	},
    {	"vr61",		0x3D	},
    {	"vr62",		0x3E	},
    {	"vr63",		0x3F	},
    {	"vr64",		0x40	},
    {	"vr65",		0x41	},
    {	"vr66",		0x42	},
    {	"vr67",		0x43	},
    {	"vr68",		0x44	},
    {	"vr69",		0x45	},
    {	"vr70",		0x46	},
    {	"vr71",		0x47	},
    {	"vr72",		0x48	},
    {	"vr73",		0x49	},
    {	"vr74",		0x4A	},
    {	"vr75",		0x4B	},
    {	"vr76",		0x4C	},
    {	"vr77",		0x4D	},
    {	"vr78",		0x4E	},
    {	"vr79",		0x4F	},
    {	"vr80",		0x50	},
    {	"vr81",		0x51	},
    {	"vr82",		0x52	},
    {	"vr83",		0x53	},
    {	"vr84",		0x54	},
    {	"vr85",		0x55	},
    {	"vr86",		0x56	},
    {	"vr87",		0x57	},
    {	"vr88",		0x58	},
    {	"vr89",		0x59	},
    {	"vr90",		0x5A	},
    {	"vr91",		0x5B	},
    {	"vr92",		0x5C	},
    {	"vr93",		0x5D	},
    {	"vr94",		0x5E	},
    {	"vr95",		0x5F	},
    {	"vr96",		0x60	},
    {	"vr97",		0x61	},
    {	"vr98",		0x62	},
    {	"vr99",		0x63	},
    {	"vr100",	0x64	},
    {	"vr101",	0x65	},
    {	"vr102",	0x66	},
    {	"vr103",	0x67	},
    {	"vr104",	0x68	},
    {	"vr105",	0x69	},
    {	"vr106",	0x6A	},
    {	"vr107",	0x6B	},
    {	"vr108",	0x6C	},
    {	"vr109",	0x6D	},
    {	"vr110",	0x6E	},
    {	"vr111",	0x6F	},
    {	"vr112",	0x70	},
    {	"vr113",	0x71	},
    {	"vr114",	0x72	},
    {	"vr115",	0x73	},
    {	"vr116",	0x74	},
    {	"vr117",	0x75	},
    {	"vr118",	0x76	},
    {	"vr119",	0x77	},
    {	"vr120",	0x78	},
    {	"vr121",	0x79	},
    {	"vr122",	0x7A	},
    {	"vr123",	0x7B	},
    {	"vr124",	0x7C	},
    {	"vr125",	0x7D	},
    {	"vr126",	0x7E	},
    {	"vr127",	0x7F	},
    {	"",		0x00	}
};
