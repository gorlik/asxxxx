/* m05ext.c */

/*
 * (C) Copyright 1989
 * All Rights Reserved
 *
 * Alan R. Baldwin
 * 721 Berkeley St.
 * Kent, Ohio  44240
 */

#include <stdio.h>
#include <setjmp.h>
#include "asm.h"
#include "6805.h"

char	*cpu	= "Motorola 6805";
int	hilo	= 1;
char	*dsft	= "asm";
