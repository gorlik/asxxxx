/* m00ext.c */

/*
 * (C) Copyright 1989-2002
 * All Rights Reserved
 *
 * Alan R. Baldwin
 * 721 Berkeley St.
 * Kent, Ohio  44240
 */

#include <stdio.h>
#include <setjmp.h>
#include "asxxxx.h"
#include "m6800.h"

char	*cpu	= "Motorola 6800/6802/6808";
int	hilo	= 1;
char	*dsft	= "asm";
