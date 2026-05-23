.nlist
;****************************************************************************
;
; Compile The Assembly Code
;
;	AS89LP -loxff dskcfg.asm
;
; To Define The dskcfg.asm Globals Place The Following Lines In Your Code
;
;	.define _dskcfg
;	.list	(!)	; This Inhibits The Include File Pagination
;	.include "dskcfg.asm"
;	.list
;
;****************************************************************************
;
;
; This Definition Controls The Inclusion Of The Disk Control Option
;
	; dskcfg.asm
	dsk$cfg	=: 1		; Include Control Option
;
;****************************************************************************
;
; DSKCFG.ASM Globals In A Macro
;
	.macro	.dskcfg.globals	arg$
	  .ifne	dsk$cfg
	    .iifne  arg$	.list	(!,src,me)
	  .globl	dskcfg_init
	  .globl	get$nm,	qry$yn
	  .globl	cpymem,	cpycod,	zermem
	  .globl	m1_blk, m2_blk,	m3_blk
	    .nlist
	  .endif
	.endm
;
;****************************************************************************

	.sbttl	Support Macros For cpymem, cpycod, and zermem Functions

;****************************************************************************
;
; Source Address Macros
;
	.macro	.stsrc	src$
	  .ifnb	src$
	    .list	(!,err,loc,bin,eqt,cyc,lin,src,me)
	  mov	dptr,src$
	    .nlist
	  .endif
	  .list	(!,err,loc,bin,eqt,cyc,lin,src,me)
	  mov	r2,dph
	  mov	r3,dpl
	  .nlist
	.endm

	.macro	.ldsrc
	  .list	(!,err,loc,bin,eqt,cyc,lin,src,me)
	  mov	dph,r2
	  mov	dpl,r3
	  .nlist
	.endm
;
;****************************************************************************
;
; Destination Address Macros
;
	.macro	.stdst	dst$
	  .ifnb	dst$
	    .list	(!,err,loc,bin,eqt,cyc,lin,src,me)
	  mov	dptr,dst$
	    .nlist
	  .endif
	  .list	(!,err,loc,bin,eqt,cyc,lin,src,me)
	  mov	r4,dph
	  mov	r5,dpl
	  .nlist
	.endm

	.macro	.lddst
	  .list	(!,err,loc,bin,eqt,cyc,lin,src,me)
	  mov	dph,r4
	  mov	dpl,r5
	  .nlist
	.endm
;
;****************************************************************************
;
; Counting Macros
;
	.macro	.stcnt	cnt$
	  .ifnb	cnt$
	    .list	(!,err,loc,bin,eqt,cyc,lin,src,me)
	  mov	dptr,cnt$
	    .nlist
	  .endif
	  .list	(!,err,loc,bin,eqt,cyc,lin,src,me)
	  mov	r0,dph
	  mov	r1,dpl
	  .nlist
	.endm

	.macro	.ldcnt
	  .list	(!,err,loc,bin,eqt,cyc,lin,src,me)
	  mov	dph,r0
	  mov	dpl,r1
	  .nlist
	.endm
;
;****************************************************************************

.ifdef _dskcfg
	.list	(!,src)
;	dskcfg.asm      Macros/Globals          Defined
	.nlist

	.dskcfg.globals	0
.else
	.list
	.title	MFM Disk Configuration

	.module	DSKCFG

	.dskcfg.globals	1

.ifne	dsk$cfg
;
;****************************************************************************
;
; Include SFR, Global, And System Definitions
;
	.list	(!)	; This Inhibits The Include File Pagination
	.include "lp3240.sfr"
	.list
	.list	(!)	; This Inhibits The Include File Pagination
	.include "ascii.def"
	.list
	.list	(!)	; This Inhibits The Include File Pagination
	.include "ioreg.def"
	.list
;
;****************************************************************************
;
; Diagnostics Are Configured In 'debug.asm'
;
	.define	_debug

	.list	(!)	; This Inhibits The Include File Pagination
	.include "debug.asm"
	.list
;
;****************************************************************************
;
;  Externals By Inclusion
;
	.define	_macros
	.define	_mfm
	.define	_sp0_x
	.define _print
	.define	_timers
	.define	_mondeb51
	.define	_mfmide
	.define	_spchr
	.define	_aiconv

	.list	(!)	; This Inhibits The Include File Pagination
	.include "macros.asm"
	.list
	.list	(!)	; This Inhibits The Include File Pagination
	.include "mfm.asm"
	.list
	.list	(!)	; This Inhibits The Include File Pagination
	.include "sp0_x.asm"
	.list
	.list	(!)	; This Inhibits The Include File Pagination
	.include "print.asm"
	.list
	.list	(!)	; This Inhibits The Include File Pagination
	.include "timers.asm"
	.list
	.list	(!)	; This Inhibits The Include File Pagination
	.include "mondeb51.asm"
	.list
	.list	(!)	; This Inhibits The Include File Pagination
	.include "mfmide.asm"
	.list
	.list	(!)	; This Inhibits The Include File Pagination
	.include "spchr.asm"
	.list
	.list	(!)	; This Inhibits The Include File Pagination
	.include "aiconv.asm"
	.list
;
;****************************************************************************

	.page
	.sbttl	Disk Configuration Notes

;****************************************************************************
;
;	Disk Configuration
;
;	  The Disk Configuration addon for mfmide.asm and mondeb51.asm
;	includes functions to initialize, backup, restore, zero, show,
;	bind, copy, and define 'partitions' and a 'control block' on
;	the attached ATA drive.
;
;	  The current implementation allocates 2.0GB of disk space
;	(4,194,304 512-Byte Sectors(Blocks)) for each 'partition.
;	Each head(track) is allocated 64 sectors(blocks), each
;	cylinder is allocated 16 heads(tracks) and each MFM/RLL drive
;	is allocated 4096 cylinders.  An emulated MFM/RLL drive
;	can have any configuration within these limits.  Unused
;	tracks and cylinders remain allocated but unused.
;
;	From mfmide.asm:
;
;	      The allocation of space for a single head on an MFM drive is
;	    directly related to the 5 MHz clocking frequency.  5 MHz requires
;	    two transitions per Hz of clock frequency or a 10 MBit data
;	    rate for encoding a standard MFM data stream.  Assuming the  MFM drive
;	    spins at 3600 rpm (rounds per minute): 60 rps (rounds per second).
;	    60 rps means one revolution takes 16.67 ms.  Thus for one revolution
;	    with a 10 MBit data stream 166,667 bits of data are required for a
;	    single head of the drive.  This translates to 20.83 KB or 40.69
;	    blocks (512 bytes/block) of a standard IDE drive.
;
;	      The allocation of space for a single head on an RLL drive is
;	    computed based on a 7.5 Mhz clock frequency.  A single track
;	    requires 250,000 bits corresponding to 31.25 KB or 61.04 blocks
;	    (512 bytes/block) of a standard ATA drive.
;
;	      The MFM emulation requires 41 blocks and the RLL emulation
;	    requires 62 blocks of data per head(track).  To allow the
;	    emulation of MFM or RLL drives a 64 block allocation is
;	    chosen as being compatible with either mode.
;
;
;	  Each 'partition' contains two 'partition' tables: the main
;	and backup 'partition' tables.  The main 'partition' table
;	is at sector 64, the last sector of the first head(track) of
;	cylinder 0.  The backup partition is located at sector 64
;	of the first head(track) of cylinder 2048.
;
;	  The 'partition' table contains data defining the emulated MFM drive
;	by specifying the following parameters:
;
;		1 Byte:		Partition Number (0-63)
;		1 Byte:		Heads(Tracks) Per Cylinder (1-16)
;		1 Byte:		Special Options
;		2 bytes:	Total Cylinders (1 - 4096)
;		1 Byte:		Maximum Allowed Partitions
;		1 Byte:		SUM Of Bytes 0-6 => 0xFF
;		1 Byte:		XOR Of Bytes 0-7 => 0xFF
;		56 Bytes:	Null Terminated Descriptive String
;
;	The 'Special Options' contains a value which specifies an
;	MFM or RLL drive type and 'Maximum Allowed Partitions'
;	contains the ATA device mximum partitions number.  The parameter
;	block has two check parameters: the SUM check of bytes 0-6
;	and the XOR check of bytes 0-7 to validate the 'partition'
;	block contents.
;
;
;	  The 'Control Block' contains copies of the four 'partition tables'
;	that are bound to ports 1-4 of the MFM interface.  Each port (1-4)
;	can be independently bound to a disk drive by jumpers on the
;	interface board.  If a 'partition' is not mounted (during the
;	binding process) then the port will be ignored and act as if
;	that port is inactive.
;
;	  There are restrictions on the mounting of partitions when
;	binding partitions in the control block.  These were described
;	in mfmide.asm:
;
;	      The FPGA hardware maintains a cache which contains a maximum
;	    of 16 tracks of data corresponding to each head of an MFM drive.
;	    The 16 tracks of data are allocated to the emulated drives.
;	    The sum total number tracks for all active emulated drives must
;	    be 16 or less with some restrictions.  So that multiple drives
;	    can be emulated each of the 'ports' (1-4) tracks are mapped into
;	    the cache at varying positions.  The port mapping is:
;
;		cache address	00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15
;				|           |           |           |
;			 mapped-\
;		'port' 1:	00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15
;
;				     mapped-\
;		'port' 2:	12 13 14 15 00 01 02 03 04 05 06 07 08 09 10 11
;
;						 mapped-\
;		'port' 3:	08 09 10 11 12 13 14 15 00 01 02 03 04 05 06 07
;
;							     mapped-\
;		'port' 4:	04 05 06 07 08 09 10 11 12 13 14 15 00 01 02 03
;
;	    Note that mapping is round-robin, but should not be required for any
;	    drive configuration.
;
;	      For a drive with 13-16 heads(tracks) only a single drive emulation
;	    is possible without overlapping heads(tracks) with another drive of
;	    any configuration.
;
;	      For a drive with 9-12 heads(tracks) a second drive with 1-4 heads(tracks)
;	    is the only option.
;
;	      For a drive with 5-8 heads(tracks) 8 heads(tracks) can be allocated to
;	    one or two additional drives: one with 1-8 heads(tracks) or two
;	    with 1-4 heads(tracks) in each.
;
;	      For a drive with 1-4 heads(tracks) 12 heads(tracks) can be allocated to
;	    one, two, or three additional drives: one with 1-12 heads(tracks), two
;	    with 1-8 and 1-4 heads(tracks), or three with 1-4 heads/(tracks) each.
;
;
;	  Each ATA disk contains two control blocks: the main and
;	backup control blocks.  The main control block is at sector 63
;	(the second to last sector) of the first head(track) of cylinder 0.
;	The backup control block is located at sector 63 (the second to
;	last sector) of the first head(track) of cylinder 2048.
;
;
;	dskcfg_init
;
;	  The dskcfg_init function is called after the ATA drive has been
;	initialized by the mfmide_init function.  With the ATA drive
;	initialized the dskcfg_init function performs these tasks:
;
;		1)  Determines the maximum number of 'partitions' that
;		    can be allocated on this drive by evaluating the
;		    size of the drive. (Limiting the maximum to 64)
;
;		2)  Loads the 'control block' and verifies the validity
;		    of each 'partition' block.  Unconfigured or invalid
;		    'partition' elements in the 'control block' are not
;		    loaded or mounted.
;
;		3)  Prepares the head(track) masks which define the
;		    active tracks for each partition.
;
;		4)  Attempts to mount designated partitions while
;		    verifying that the 'partition' tracks when bound to
;		    the selected ports donot overlap.  Any overlap will
;		    report an error but mounting continues.
;
;		5)  Finally the mounted partitions are prepared for access
;		    by the MFM interface by loading cylinder 0 of each
;		    mounted 'partition' and setting seek complete and
;		    track 0 flags in the interface.
;
;****************************************************************************

	.page
	.sbttl	Function Summary

;****************************************************************************
;
;  Disk Configuration Functions
;
;   xdisk	Function Dispatcher
;
;=>   x$init	Initialize Control/Partition Blocks Dispatcher
;	xdinit	Control And Partition Block Init
;	ctinit	Control Block Init
;	ptinit	Partition Block Init
;
;=>   x$bkup	Backup Control/Partition Blocks Dispatcher
;	xdbkup	Control And Partition Block Backup
;	ctbkup	Control Block Backup
;	ptbkup	Partition Block Backup
;
;=>   x$rstr	Restore Control/Partition Blocks Dispatcher
;	xdrstr	Control and Partition Block Restore
;	ctrstr	Control Block Restore
;	ptrstr	Partition Block Restore
;
;=>   x$sero	Zero Control/Partition Blocks Dispatcher
;	xdzero	Control And Partition Block Zero
;	ctzero	Control Block Zero
;	ptzero	Partition Block Zero
;
;=>   x$show	Show Control/Partition Blocks Dispatcher
;	ctshow	Control Block Show
;	ptshow	Partition Block Show
;	ptshow.mnt  Partition Block Show With Mount Information
;
;=>   x$bind	Bind Partition To Disk
;
;=>   x$part	Set Partition Parameters
;	new$pt	New Partition Query
;	new$mr	MFM/RLL Query
;	new$hd	New Head Query
;	new$cy	New Cylinder Query
;	new$tx	New Comment Query
;
;=>   x$copy	Copy A Partition To Another Partition
;	xdcopy	Copy Query
;	cpyprt	Partition Copy
;	cpycyl	Cylinder Copy
;
;  Read/Write Support Functions
;
;   ctl$rd	Read  Control Block (Or Backup Control Block)
;   ctl$wt	Write Control Block (Or Backup Control Block)
;     ctl$rw	Support For ctl$rd and ctl$wt
;
;   prt$rd	Read  A Partition Block (Or Backup Partition Block)
;   prt$wt	Write A Partition Block (Or Backup Partition Block)
;     prt$rw	Support For prt$rd and prt$wt
;
;   chk$rd	Read  Checksum Block
;   chk$wt	Write Checksum Block
;     chk$sm	Find Checksum
;     chk$xr	Find Exclusive Or
;
;   cbrchk	Rebuild Control Block Check
;   cbrbld	Rebuild Control Block
;     cb$adr	Memory Copy Helper
;
;  Block Manipulation Functions
;
;   m1tom2	Copy Mmeory Block m1_blk to Block m2_blk
;   m1tom3	Copy Mmeory Block m1_blk to Block m3_blk
;   m2tom1	Copy Mmeory Block m2_blk to Block m1_blk
;   m2tom3	Copy Mmeory Block m2_blk to Block m3_blk
;   m3tom1	Copy Mmeory Block m3_blk to Block m1_blk
;   m3tom2	Copy Mmeory Block m3_blk to Block m2_blk
;
;   cb$pb0	Copy Disk 1 Partition Block To Control Block 
;   cb$pb1	Copy Disk 2 Partition Block To Control Block 
;   cb$pb2	Copy Disk 3 Partition Block To Control Block 
;   cb$pb3	Copy Disk 4 Partition Block To Control Block
;     cpymem	Memory Copy
;
;   cpycod	Copy Code Memory Strings
;
;   zr$m1	Zero Memory Block m1_blk
;   zr$m2	Zero Memory Block m2_blk
;   zr$m3	Zero Memory Block m3_blk
;
;   zr$cb0	Zero Disk 1 Partition Block In Control Block
;   zr$cb1	Zero Disk 2 Partition Block In Control Block
;   zr$cb2	Zero Disk 3 Partition Block In Control Block
;   zr$cb3	Zero Disk 4 Partition Block In Control Block
;     zermem	Memory
;
;  Query Functions
;
;   qry$pn	Partition Number Query
;   qry$dn	Port Number Query
;   qry$yn	Y/N Query
;   qry$ln	Get A New Line Of Input
;
;   get$nm	Get A Number From The Input Line
;   get$tx	Get A String From The Input Line
;
;  Startup Initialization
;
;   dskcfg_init	Reads The Disk Control Block And
;		Loads Disk 1-4 Parameters.
;     dskcfg	Update MFM Disk Parameters
;       maxprt	Calculate Maximum Allowed Disk Partitions
;       prtmnt	Mount Partition On A Port
;       prtld	Load Cylinder 0 Of Mounted Partitions
;       prtmsk	Build The Partition Head(Track) Masks
;         shftbt  Support Function For prtmsk
;
;****************************************************************************

	.page
	.sbttl	Program Areas

;****************************************************************************
;
;	Bit Flags
;
	.area	Bits

cpbkup:	.blkb	1				; 0 - Normal, 1 - Backup
flgupr:	.blkb	1				; 0 - U/L Case, 1 - U Case Only

xrl$er:	.blkb	1				; A Checksum Flag
sum$er:	.blkb	1				; A Checksum Flag
cfg$er:	.blkb	1				; A Checksum Flag

set$er:	.blkb	1				; Set Error Flag

prn$md:	.blkb	1				; Printing Mode

shomnt:	.blkb	1				; 0 - mounted not shown
						; 1 - mounted shown

savtyp:	.blkb	1				; 0 - MFM
						; 1 - RLL

;
;****************************************************************************
;
;	The MFM Drive Configuration Blocks
;
	.area	IOBlk

m1_blk:	.blkb	512		; MFM Block 1	; Control Block

	; Control Block Parameters
	cb_blk	=:	0	; Checksum Block, Bytes 0 - 7

	cb_pr1	=:	0x000	; Disk Select 1 Partition Configuration Block
	cb_pr2	=:	0x080	; Disk Select 2 Partition Configuration Block
	cb_pr3	=:	0x100	; Disk Select 3 Partition Configuration Block
	cb_pr4	=:	0x180	; Disk Select 4 Partition Configuration Block

	cb_mnt	=:	0x07F	; Partition Mountable Byte

	cb_pr1.mnt	=:	0x07F	; Port 1 Mounted To Access Partition
	cb_pr2.mnt	=:	0x0FF	; Port 2 Mounted To Access Partition
	cb_pr3.mnt	=:	0x17F	; Port 3 Mounted To Access Partition
	cb_pr4.mnt	=:	0x1FF	; Port 4 Mounted To Access Partition

	cb_siz	=:	0x80	; 128 Bytes per Partition


m2_blk:	.blkb	512		; MFM Block 2	; Partition Block Configuration

	; 64 Byte Partiton Block Offsets
	pb_blk	=:	0	; Checksum Block, Bytes 0 - 7

	pb_num	=:	0	; 1 Byte:	Partition Number (0-255)
	pb_hds	=:	1	; 1 Byte:	Heads  Per Cylinder (1-16)
	pb_trk	=:	1	; 1 Byte:	Tracks Per Cylinder (1-16)
	pb_opt	=:	2	; 1 Byte:	Special Options
	pb_cyl	=:	3	; 2 bytes:	Total Cylinders (1 - 4096)
	pb_max	=:	5	; 1 Byte:	Maximum Allowed Partitions
	pb_sum	=:	6	; 1 Byte:	SUM Of Bytes 0-6 => 0xFF
	pb_cks	=:	7	; 1 Byte:	XOR Of Bytes 0-7 => 0xFF
	pb_str	=:	8	; 56 Bytes:	Null Terminated String

	pb_sln	=:	56	; size of pb_str

m3_blk:	.blkb	512		; MFM Block 3	; I/O And Control/Partition Block Manipulation
;
;****************************************************************************
;
;	Miscelaneous Constants
;
;	prtoff	=:	0x01	; Base Offset (= prtoff * 256)
;	prtsiz	=:	0x40	; Partition Size (= prtsiz * 65536)

	ctlcfg	=:	0x3E	; Control Configuration Block Offset
	prtcfg	=:	0x3F	; Partition Configuration Block Offset

	prtmax	=:	0x40	; Maximum Of 64 Partitions

;
;
;****************************************************************************
;
;	The Data Area
;
; Data in this region are accessed directly
;
	.area	Data

mx$prt:	.blkb	1		; maximum partitions
nm$prt:	.blkb	1		; partition number
nm$dsk:	.blkb	1		; disk number

ex$prt:	.blkb	1		; expected partition number

;
; Data in this region are accessed indirectly
;
	.area	IData

sr$prt:	.blkb	1		; source partiton
ds$prt:	.blkb	1		; destination partition

cp$cnt:	.blkb	1		; counter

cp$trk:	.blkb	1		; tracks per cylinder to copy
cp$opt:	.blkb	1		; options
cp$cyl:	.blkb	2		; cylinders to copy

cu$trk:	.blkb	1		; current track
cu$cyl:	.blkb	2		; current cylinder

;
;****************************************************************************
;
	.area	DskCfg
;
;****************************************************************************

	.page
	.sbttl	Startup Configuration

;****************************************************************************
;
;	Configuration Initialization
;

dskcfg_init:
	lcall	maxprt		; initialize partition count
	clr	cpbkup		; normal addressing
	lcall	ctl$rd		; read the disk control block
	lcall	dskcfg		; load MFM disk parameters
	lcall	prtld		; Load Track 0 Of Port Partitions
	ret

;
;****************************************************************************

	.page
	.sbttl	Table Entries

;****************************************************************************
;
	; Command Table Entries

	.area	CmdTbl

	ljmp	xdisk

;
;****************************************************************************
;
	; Command List Entries 

	.area	CmdLst

	.ascii	/XDISK/
	.byte	cr

;
;****************************************************************************
;
	; Command Option List Entries

	.area	OptLst

	; Modifiers to "XDISK"

xdlst:	.ascii	/INITIALIZE/
	.byte	cr
	.ascii	/BACKUP/
	.byte	cr
	.ascii	/RESTORE/
	.byte	cr
	.ascii	/ZERO/
	.byte	cr
	.ascii	/SHOW/
	.byte	cr
	.ascii	/PARTITION/
	.byte	cr
	.ascii	/BIND/
	.byte	cr
	.ascii	/COPY/
	.byte	cr
	.byte	lf		; end of list

	;  Modifiers to INITIALIZE, BACKUP, RESTORE, ZERO, and SHOW

acplst:	.ascii	/ALL/
	.byte	cr
	.ascii	/CONTROL/
	.byte	cr
	.ascii	/PARTITION/
	.byte	cr
	.byte	lf		; end of list

	;  Question Answers

ynlst:	.ascii	/YES/
	.byte	cr
	.ascii	/NO/
	.byte	cr
	.byte	lf		; end of list

;
;****************************************************************************
;
	; Extended Help String Pointers

	.area	X_Ptrs

	.word	$xdisk

;
;****************************************************************************
;
	; Extended Help Strings

	.area	X_Strs

$xdisk:
	.ascii	" X[DISK]  command  (Numerical Parameters Are In Decimal)"
	.byte	cr,lf
	.ascii	"   I[NITALIZE]  A, C, P N"
	.byte	cr,lf
	.ascii	"   B[ACKUP]     A, C, P N"
	.byte	cr,lf
	.ascii	"   R[ESTORE]    A, C, P N"
	.byte	cr,lf
	.ascii	"   Z[ERO]       A, C, P N"
	.byte	cr,lf
	.ascii	"   S[HOW]       A, C, P N"
	.byte	cr,lf
	.ascii	"     A[LL]       Control and All Partition Blocks"
	.byte	cr,lf
	.ascii	"     C[ONTROL]   Control Block"
	.byte	cr,lf
	.ascii	"     P[ARTITION]  N"
	.byte	cr,lf
	.ascii	"       Partition Block N"
	.byte	cr,lf
	.ascii	"   P[ARTITION]  N"
	.byte	cr,lf
	.ascii	"     Enter MFM/RLL, Heads, Cylinders, and Comment"
	.byte	cr,lf
	.ascii	"   BI[ND]"
	.byte	cr,lf
	.ascii	"     Bind a Partition To A Port"
	.byte	cr,lf
	.ascii	"   C[OPY]"
	.byte	cr,lf
	.ascii	"     Copy a Partition"
	.byte	cr,lf
	.byte	eot

;
;****************************************************************************
;
	.area	DskCfg
;
;****************************************************************************

	.page
	.sbttl	Command Dispatcher

;****************************************************************************
;
; XDISK Command Dispatcher
;
;  All numerical Input/Output will be in decimal.
;  This Overrides the monitor ibcode/dbcode settings.
; 

xdisk:  mov	dptr,#xdlst	; look for option in list
	lcall	fndlnm		; returns with list number
	lcall	comand		; now go for a match
	jz	xdhlp		; list help if just a cr was typed
	jb	a.7,1$		; bad command if negative
	ljmp	2$		; good command if positive
1$:	ljmp	badsyn

2$:

	; disable shared buffer usage
.ifne	mfm$dbg
.ifne dbg.Ex0$TstA | dbg.Ex0$TstB
	jnb	i$enbl,3$
	clr	i$enbl		; disable mfmchg logging
	mov	dptr,#init$v
	lcall	outstr
3$:
.endif
.ifne dbg.db$que
	jnb	q$enbl,4$
	clr	q$enbl		; disable r/w queue logging
	mov	dptr,#init$w
	lcall	outstr
4$:
.endif
.endif

	dec	a		; compute (a - 1) * 3
	mov	b,#3
	mul	ab		; a is product
	mov	dptr,#5$
	jmp	@a+dptr		; jump into jump table

	;1st level jump table

5$:	ljmp	x$init		; first level subcommands
	ljmp	x$bkup
	ljmp	x$rstr
	ljmp	x$zero
	ljmp	x$show
	ljmp	x$part
	ljmp	x$bind
	ljmp	x$copy

xdhlp:	mov	dptr,#$xdisk	; expanded help
	lcall	outstr		; string address in dptr
	ljmp	nomore

;
;****************************************************************************

	.page
	.sbttl	XDISK INIT

;****************************************************************************
;
x$init:	mov	dptr,#acplst	; look for option in list
	lcall	fndlnm		; returns with list number
	lcall	comand		; now go for a match
	jz	2$		; list help if just a cr was typed
	jb	a.7,1$		; bad command if negative
	sjmp	3$		; good command if positive
1$:	ljmp	badsyn

2$:	sjmp	xdhlp

3$:	dec	a		; compute (a - 1) * 3
	mov	b,#3
	mul	ab		; a is product
	mov	dptr,#4$
	jmp	@a+dptr		; jump into jump table

	; 2nd level jump table

4$:	ljmp	init_a
	ljmp	init_c
	ljmp	init_p


init_a:	mov	dptr,#init$a	; ask for Y/N
	lcall	qry$yn
	jc	init_y		; ^C abort
	jz	init_y		; no argument
	jb	a.7,init_x	; invalid argument
	cjne	a,#1,init_y	; not YES - abort
	lcall	xdinit		; initialize all
	lcall	dskcfg		; update disk parameters
	ljmp	nomore

init_c:	mov	dptr,#init$c	; ask for Y/N
	lcall	qry$yn
	jc	init_y		; ^C abort
	jz	init_y		; no argument
	jb	a.7,init_x	; invalid argument
	cjne	a,#1,init_y	; not YES - abort
	lcall	ctinit		; initialize Control Block
	clr	cpbkup		; normal addressing
	lcall	ctl$wt		; write the contol block
	lcall	dskcfg		; update disk parameters
	ljmp	nomore

init_p: lcall	qry$pn
	jc	init_x		; invalid argument
	.ldptr  #init$p		; ask for Y/N
	lcall	qry$yn
	jc	init_y		; ^C abort
	jz	init_y		; no argument
	jb	a.7,init_x	; invalid argument
	cjne	a,#1,init_y	; not YES - abort
	lcall	ptinit		; initialize Partition Block
	clr	cpbkup		; normal addressing
	lcall	prt$wt		; write partition configuration block
	lcall	cbrbld		; rebuild the control block
	ljmp	nomore

init_x:	.ldptr	#init$x		; invalid/missing argument
	sjmp	init_z
init_y:	.ldptr  #init$y		; command aborted
;	sjmp	init_z

init_z:	lcall	outstr
	ljmp	nomore

init$a:	.ascii	" Initialize Control and All Partition Blocks? (Y/N) "
	.byte	eot
init$c:	.ascii	" Initialize Control Block? (Y/N) "
	.byte	eot
init$p:	.ascii	" Initialize The Partition Block? (Y/N) "
	.byte	eot
init$v:	.ascii	" M[FMDBG] E[X0]     Set To OFF"
	.byte	cr,lf,eot
init$w:	.ascii	" M[FMDBG] L[OGGING] Set To OFF"
	.byte	cr,lf,eot
init$x:	.ascii	" Missing/Invalid Argument -"
init$y:	.ascii	" Initialize Aborted"
	.byte	cr,lf,eot

;
;****************************************************************************

	.page
	.sbttl	Initialize Drive Configuration

;****************************************************************************
;
;  This function initializes all Partition Blocks
;  and rebuilds the Control Block.  All partition
;  parameters are cleared with only the partition
;  number set.
;

; 1)	Initilaize The Partition Blocks

xdinit:	mov	nm$prt,#0		; loop counter
	sjmp	2$

1$:	lcall	ptinit			; initialize partition block
	clr	cpbkup			; normal addressing
	lcall	prt$wt			; write a partition configuration block

	inc	nm$prt			; next partition

2$:	mov	a,nm$prt
	cjne	a,mx$prt,1$		; compare to maximum

; 1)	Initialize The Control Block

	lcall	ctinit			; initialize control  block
	lcall	ctl$wt			; write the contol block
	ret
;
;	cb_pr1	=:	0x000		; 128 Bytes:	Disk Select 1 Partition Configuration Block
;	cb_pr2	=:	0x080		; 128 Bytes:	Disk Select 2 Partition Configuration Block
;	cb_pr3	=:	0x100		; 128 Bytes:	Disk Select 3 Partition Configuration Block
;	cb_pr4	=:	0x180		; 128 Bytes:	Disk Select 4 Partition Configuration Block
;
ctinit:	lcall	zr$m3			; clear m3_blk
	mov	nm$prt,#0		; disk/partition number
	.stdst	#m3_blk+cb_pr1
	lcall	ptdflt
	.sb_x	m3_blk+cb_pr1+pb_num,#0
	.sb_x	m3_blk+cb_pr1+pb_max,mx$prt

	mov	dptr,#m3_blk+cb_pr1+pb_blk
	lcall	chk$wt			; fill in checksum

	mov	nm$prt,#1		; disk/partition number
	.stdst	#m3_blk+cb_pr2
	lcall	ptdflt
	.sb_x	m3_blk+cb_pr2+pb_num,#1
	.sb_x	m3_blk+cb_pr2+pb_max,mx$prt

	mov	dptr,#m3_blk+cb_pr2+pb_blk
	lcall	chk$wt			; fill in checksum

	mov	nm$prt,#2		; disk/partition number
	.stdst	#m3_blk+cb_pr3
	lcall	ptdflt
	.sb_x	m3_blk+cb_pr3+pb_num,#2
	.sb_x	m3_blk+cb_pr3+pb_max,mx$prt

	mov	dptr,#m3_blk+cb_pr3+pb_blk
	lcall	chk$wt			; fill in checksum

	mov	nm$prt,#3		; disk/partition number
	.stdst	#m3_blk+cb_pr4
	lcall	ptdflt
	.sb_x	m3_blk+cb_pr4+pb_num,#3
	.sb_x	m3_blk+cb_pr4+pb_max,mx$prt

	mov	dptr,#m3_blk+cb_pr4+pb_blk
	lcall	chk$wt			; fill in checksum
	ret
;
;	pb_blk	=:	0		; Checksum Block, Bytes 0 - 7
;
;	pb_num	=:	0	; 1 Byte:	Partition Number (0-255)
;	pb_hds	=:	1	; 1 Byte:	Heads  Per Cylinder (1-16)
;	pb_trk	=:	1	; 1 Byte:	Tracks Per Cylinder (1-16)
;	pb_opt	=:	2	; 1 Byte:	Special Options
;	pb_cyl	=:	3	; 2 bytes:	Total Cylinders (1 - 4096)
;	pb_max	=:	5	; 1 Byte:	Maximum Allowed Partitions
;	pb_sum	=:	6	; 1 Byte:	SUM Of Bytes 0-6 => 0xFF
;	pb_cks	=:	7	; 1 Byte:	XOR Of Bytes 0-7 => 0xFF
;	pb_str	=:	8	; 56 Bytes:	Null Terminated String
;
;	pb_sln	=:	56		; size of pb_str
;
ptinit:	lcall	zr$m3			; clear m3_blk
	.stdst	#m3_blk+pb_num
	lcall	ptdflt			; default configuration

	.sb_x	m3_blk+pb_num,nm$prt	; set partition number
	.sb_x	m3_blk+pb_max,mx$prt	; set maximum number of partitions

	mov	dptr,#m3_blk+pb_blk	; address of checksum block
	lcall	chk$wt			; fill in checksum
	ret

ptdflt:	.stsrc	#1$
	.stcnt	#-(2$-1$)
	lcall	cpycod
	ret

1$:	.byte	0,	16,	0,	#>4096,	#<4096,	0,	1,	0
	.ascii	"Default Initialization - 16 heads / 4096 Cylinders"
2$:

;
;****************************************************************************

	.page
	.sbttl	XDISK BACKUP

;****************************************************************************
;
x$bkup:	mov	dptr,#acplst	; look for option in list
	lcall	fndlnm		; returns with list number
	lcall	comand		; now go for a match
	jz	2$		; list help if just a cr was typed
	jb	a.7,1$		; bad command if negative
	sjmp	3$		; good command if positive
1$:	ljmp	badsyn

2$:	ljmp	xdhlp

3$:	dec	a		; compute (a - 1) * 3
	mov	b,#3
	mul	ab		; a is product
	mov	dptr,#4$
	jmp	@a+dptr		; jump into jump table

	; 2nd level jump table

4$:	ljmp	bkup_a
	ljmp	bkup_c
	ljmp	bkup_p


bkup_a:	mov	dptr,#bkup$a	; ask for Y/N
	lcall	qry$yn
	jc	bkup_y		; ^C abort
	jz	bkup_y		; no argument
	jb	a.7,bkup_x	; invalid argument
	cjne	a,#1,bkup_y	; not YES - abort
	lcall	xdbkup		; backup all
	ljmp	nomore

bkup_c:	mov	dptr,#bkup$c	; ask for Y/N
	lcall	qry$yn
	jc	bkup_y		; ^C abort
	jz	bkup_y		; no argument
	jb	a.7,bkup_x	; invalid argument
	cjne	a,#1,bkup_y	; not YES - abort
	lcall	ctbkup		; backup Control Block
	ljmp	nomore

bkup_p: lcall	qry$pn
	jc	bkup_x		; invalid argument
	.ldptr  #bkup$p		; ask for Y/N
	lcall	qry$yn
	jc	bkup_y		; ^C abort
	jz	bkup_y		; no argument
	jb	a.7,bkup_x	; invalid argument
	cjne	a,#1,bkup_y	; not YES - abort
	lcall	ptbkup		; backup Partition Block
	ljmp	nomore

bkup_x:	.ldptr	#bkup$x		; invalid/missing argument
	sjmp	bkup_z
bkup_y:	.ldptr  #bkup$y		; command aborted
;	sjmp	bkup_z

bkup_z:	lcall	outstr
	ljmp	nomore

bkup$a:	.ascii	" Backup Control and All Partition Blocks? (Y/N) "
	.byte	eot
bkup$c:	.ascii	" Backup Control Block? (Y/N) "
	.byte	eot
bkup$p:	.ascii	" Backup The Partition Block? (Y/N) "
	.byte	eot
bkup$x:	.ascii	" Missing/Invalid Argument -"
bkup$y:	.ascii	" Backup Aborted"
	.byte	cr,lf,eot

;
;****************************************************************************

	.page
	.sbttl	Backup Drive Configuration

;****************************************************************************
;
;  This function backs up the
; Control and Partition Blocks.
;

; 1)	Backup The Control Block

xdbkup:	clr	cpbkup			; normal addressing
	lcall	ctl$rd			; read the contol block
	setb	cpbkup			; backup addressing
	lcall	ctl$wt			; write the contol block

; 2)	Backup The Partition Blocks

	mov	nm$prt,#0		; loop counter
	sjmp	2$

1$:	clr	cpbkup			; Normal addressing
	lcall	prt$rd			; read a partition configuration block

	setb	cpbkup			; backup addressing
	lcall	prt$wt			; backup the partition configuration block

	inc	nm$prt			; next partition

2$:	mov	a,nm$prt		; current number
	cjne	a,mx$prt,1$		; compare to maximum
	ret

ctbkup:	clr	cpbkup			; normal addressing
	lcall	ctl$rd			; read the contol block
	setb	cpbkup			; backup addressing
	lcall	ctl$wt			; backup the contol block
	ret

ptbkup:	clr	cpbkup			; Normal addressing
	lcall	prt$rd			; read a partition configuration block
	setb	cpbkup			; backup addressing
	lcall	prt$wt			; backup the partition configuration block
	ret

;
;****************************************************************************

	.page
	.sbttl	XDISK RESTORE

;****************************************************************************
;
x$rstr:	mov	dptr,#acplst	; look for option in list
	lcall	fndlnm		; returns with list number
	lcall	comand		; now go for a match
	jz	2$		; list help if just a cr was typed
	jb	a.7,1$		; bad command if negative
	sjmp	3$		; good command if positive
1$:	ljmp	badsyn

2$:	ljmp	xdhlp

3$:	dec	a		; compute (a - 1) * 3
	mov	b,#3
	mul	ab		; a is product
	mov	dptr,#4$
	jmp	@a+dptr		; jump into jump table

	; 2nd level jump table

4$:	ljmp	rstr_a
	ljmp	rstr_c
	ljmp	rstr_p


rstr_a:	mov	dptr,#rstr$a	; ask for Y/N
	lcall	qry$yn
	jc	rstr_y		; ^C abort
	jz	rstr_y		; no argument
	jb	a.7,rstr_x	; invalid argument
	cjne	a,#1,rstr_y	; not YES - abort
	lcall	xdrstr		; restore all
	lcall	dskcfg		; update disk parameters
	ljmp	nomore

rstr_c:	mov	dptr,#rstr$c	; ask for Y/N
	lcall	qry$yn
	jc	rstr_y		; ^C abort
	jz	rstr_y		; no argument
	jb	a.7,rstr_x	; invalid argument
	cjne	a,#1,rstr_y	; not YES - abort
	lcall	ctrstr		; restore Control Block
	lcall	dskcfg		; update disk parameters
	ljmp	nomore

rstr_p: lcall	qry$pn
	jc	rstr_x		; invalid argument
	.ldptr  #rstr$p		; ask for Y/N
	lcall	qry$yn
	jc	rstr_y		; ^C abort
	jz	rstr_y		; no argument
	jb	a.7,rstr_x	; invalid argument
	cjne	a,#1,rstr_y	; not YES - abort
	lcall	ptrstr		; restore Partition Block
	lcall	cbrbld		; rebuild the control block
	ljmp	nomore

rstr_x:	.ldptr	#rstr$x		; invalid/missing argument
	sjmp	rstr_z
rstr_y:	.ldptr  #rstr$y		; command aborted
;	sjmp	rstr_z

rstr_z:	lcall	outstr
	ljmp	nomore

rstr$a:	.ascii	" Restore Control and All Partition Blocks? (Y/N) "
	.byte	eot
rstr$c:	.ascii	" Restore Control Block? (Y/N) "
	.byte	eot
rstr$p:	.ascii	" Restore The Partition Block? (Y/N) "
	.byte	eot
rstr$x:	.ascii	" Missing/Invalid Argument -"
rstr$y:	.ascii	" Restore Aborted"
	.byte	cr,lf,eot

;
;****************************************************************************

	.page
	.sbttl	Restore Drive Configuration

;****************************************************************************
;
; This function restores the
; Control and Partition Blocks.
;

; 1)	Restore The Control Block

xdrstr:	setb	cpbkup			; backup addressing
	lcall	ctl$rd			; read the contol block
	clr	cpbkup			; normal addressing
	lcall	ctl$wt			; restore the contol block

; 2)	Restore The Partition Blocks

	mov	nm$prt,#0		; loop counter
	sjmp	2$

1$:	setb	cpbkup			; backup addressing
	lcall	prt$rd			; read a partition configuration block

	clr	cpbkup			; normal addressing
	lcall	prt$wt			; restore the partition configuration block

	inc	nm$prt			; next partition

2$:	mov	a,nm$prt
	cjne	a,mx$prt,1$		; compare to maximum
	ret

ctrstr:	setb	cpbkup			; backup addressing
	lcall	ctl$rd			; read the contol block
	clr	cpbkup			; normal addressing
	lcall	ctl$wt			; restore the contol block
	ret

ptrstr:	setb	cpbkup			; backup addressing
	lcall	prt$rd			; read a partition configuration block
	clr	cpbkup			; normal addressing
	lcall	prt$wt			; restore the partition configuration block
	ret

;
;****************************************************************************

	.page
	.sbttl	XDISK ZERO

;****************************************************************************
;
x$zero:	mov	dptr,#acplst	; look for option in list
	lcall	fndlnm		; returns with list number
	lcall	comand		; now go for a match
	jz	2$		; list help if just a cr was typed
	jb	a.7,1$		; bad command if negative
	sjmp	3$		; good command if positive
1$:	ljmp	badsyn

2$:	ljmp	xdhlp

3$:	dec	a		; compute (a - 1) * 3
	mov	b,#3
	mul	ab		; a is product
	mov	dptr,#4$
	jmp	@a+dptr		; jump into jump table

	; 2nd level jump table

4$:	ljmp	zero_a
	ljmp	zero_c
	ljmp	zero_p


zero_a:	mov	dptr,#zero$a	; ask for Y/N
	lcall	qry$yn
	jc	zero_y		; ^C abort
	jz	zero_y		; no argument
	jb	a.7,zero_x	; invalid argument
	cjne	a,#1,zero_y	; not YES - abort
	lcall	xdzero		; zero all
	lcall	dskcfg		; rebuild the control block
	ljmp	nomore

zero_c:	mov	dptr,#zero$c	; ask for Y/N
	lcall	qry$yn
	jc	zero_y		; ^C abort
	jz	zero_y		; no argument
	jb	a.7,zero_x	; invalid argument
	cjne	a,#1,zero_y	; not YES - abort
	lcall	ctzero		; zero Control Block
	lcall	dskcfg		; update disk parameters
	ljmp	nomore

zero_p: lcall	qry$pn
	jc	zero_x		; invalid argument
	.ldptr  #zero$p		; ask for Y/N
	lcall	qry$yn
	jc	zero_y		; ^C abort
	jz	zero_y		; no argument
	jb	a.7,zero_x	; invalid argument
	cjne	a,#1,zero_y	; not YES - abort
	lcall	ptzero		; zero Partition Block
	lcall	cbrbld		; rebuild the control block
	ljmp	nomore

zero_x:	.ldptr	#zero$x		; invalid/missing argument
	sjmp	zero_z
zero_y:	.ldptr  #zero$y		; command aborted
;	sjmp	zero_z

zero_z:	lcall	outstr
	ljmp	nomore

zero$a:	.ascii	" Zero Control and All Partition Blocks? (Y/N) "
	.byte	eot
zero$c:	.ascii	" Zero Control Block? (Y/N) "
	.byte	eot
zero$p:	.ascii	" Zero The Partition Block? (Y/N) "
	.byte	eot
zero$x:	.ascii	" Missing/Invalid Argument -"
zero$y:	.ascii	" Zero Aborted"
	.byte	cr,lf,eot

;
;****************************************************************************

	.page
	.sbttl	Zero Drive Configuration

;****************************************************************************
;
; This function zeros the
; Control and Partition Blocks.
;

; 1)	Zero The Control Block

xdzero:	clr	cpbkup			; normal addressing
	lcall	zr$m3			; zero the memory block
	lcall	ctl$wt			; zero the contol block

; 2)	Zero The Partition Blocks

	lcall	zr$m3			; zero the memory block
	mov	nm$prt,#0		; loop counter
	sjmp	2$

1$:	clr	cpbkup			; normal addressing
	lcall	prt$wt			; zero the partition configuration block

	inc	nm$prt			; next partition

2$:	mov	a,nm$prt
	cjne	a,mx$prt,1$		; compare to maximum
	ret

ctzero:	clr	cpbkup			; normal addressing
	lcall	zr$m3			; zero the memory block
	lcall	ctl$wt			; zero the contol block
	ret

ptzero:	clr	cpbkup			; normal addressing
	lcall	zr$m3			; zero the memory block
	lcall	prt$wt			; zero the partition configuration block
	ret

;
;****************************************************************************

	.page
	.sbttl	XDISK SHOW

;****************************************************************************
;
x$show:	mov	dptr,#acplst	; look for option in list
	lcall	fndlnm		; returns with list number
	lcall	comand		; now go for a match
	jz	2$		; list help if just a cr was typed
	jb	a.7,1$		; bad command if negative
	sjmp	3$		; good command if positive
1$:	ljmp	badsyn

2$:	ljmp	xdhlp

3$:	cjne	a,#1,.+3
	dec	a		; compute (a - 1) * 3
	mov	b,#3
	mul	ab		; a is product
	mov	dptr,#4$
	jmp	@a+dptr		; jump into jump table

	; 2nd level jump table

4$:	ljmp	show_a
	ljmp	show_c
	ljmp	show_p


show_a:	clr	cpbkup		; normal addressing
	lcall	ctl$rd	        ; read the control block
	lcall	dskcfg		; verify ports/partitions/tracks
	lcall	ctshow		; show control block
	mov	dptr,#show$H
	lcall	outstr

	clr	a		; prep to show all partitions
1$:	push	a
	mov	nm$prt,a
	mov	ex$prt,a
	clr	cpbkup		; normal addressing
	lcall	prt$rd		; read a partition configuration block
	lcall	ptshow		; show partition
	pop	a
	inc	a
	cjne	a,mx$prt,1$	; loop for all partitions
	ljmp	nomore

show_c:	clr	cpbkup		; normal addressing
	lcall	ctl$rd	        ; read the control block
	lcall	dskcfg		; verify ports/partitions/tracks
	lcall	ctshow		; show Control Block
	ljmp	nomore

show_p:	lcall	qry$pn
	jc	show_x		; invalid argument
	clr	cpbkup		; normal addressing
	lcall	prt$rd	        ; read the control block
	lcall	ptshow		; show Partition Block
	ljmp	nomore

show_x:	.ldptr	#show$x		; invalid/missing argument
	sjmp	show_z
show_y:	.ldptr  #show$y		; command aborted
;	sjmp	show_z

show_z:	lcall	outstr
	ljmp	nomore

show$x:	.ascii	" Missing/Invalid Argument -"
show$y:	.ascii	" Show Aborted"
	.byte	cr,lf,eot

;
;****************************************************************************

	.page
	.sbttl	Show Control Block

;****************************************************************************
;
;	cb_pr1	=:	0x000		; 128 Bytes:	Disk Select 1 Partition Configuration Block
;	cb_pr2	=:	0x080		; 128 Bytes:	Disk Select 2 Partition Configuration Block
;	cb_pr3	=:	0x100		; 128 Bytes:	Disk Select 3 Partition Configuration Block
;	cb_pr4	=:	0x180		; 128 Bytes:	Disk Select 4 Partition Configuration Block
;
ctshow:	mov	dptr,#show$1	; show available partitions
 	lcall	outstr
	mov	b,mx$prt
	lcall	dec1by

	mov	dptr,#show$H	; terminate line
	lcall	outstr

	mov	nm$prt,#0	; initialize
1$:	inc	nm$prt	        ; next partition description

	mov	a,nm$prt
	cjne	a,#1,2$
	.stsrc	#m3_blk+cb_pr1	; dst and src are the same
	sjmp	5$
2$:	cjne	a,#2,3$
	.stsrc	#m3_blk+cb_pr2
	sjmp	5$
3$:	cjne	a,#3,4$
	.stsrc	#m3_blk+cb_pr3
	sjmp	5$
;	cjne	a,#4,5$
4$:	.stsrc	#m3_blk+cb_pr4
;	sjmp	5$
5$:	.stdst	#m3_blk
	.stcnt	#-cb_siz
	lcall	cpymem

	mov	dptr,#show$3	; "Port "
	lcall	outstr
	mov	b,nm$prt
	lcall	dec1by

	mov	dptr,#m3_blk+pb_blk
	lcall	chk$rd		; set checksum error flags
	mov	dptr,#show$4	; " Is Not Configured"
	jb	cfg$er,7$	; SUM  = 0 then not configured
	mov	dptr,#show$5	; " Is Corrupted"
	jb	sum$er,7$	; SUM != 0 then data check failed
	jb	xrl$er,7$	; XOR != 0 then checksum failed

	mov	dptr,#show$6	; " Is Bound To Partition "
	lcall	outstr
	.lb_x	b,m3_blk+pb_num	; partition number
	lcall	dec1by
	mov	dptr,#show$H	; cr,lf
	lcall	outstr

	.lb_x	ex$prt,m3_blk+pb_num
	lcall	ptshow.mnt	; partition number

6$:	mov	a,nm$prt 
	cjne	a,#4,8$
	ret

7$:	lcall	outstr
	sjmp	6$

8$:	ljmp	1$

;
;****************************************************************************

	.page
	.sbttl	Show Partition Block

;****************************************************************************
;
;	pb_blk	=:	0		; Checksum Block, Bytes 0 - 7
;
;	pb_num	=:	0	; 1 Byte:	Partition Number (0-255)
;	pb_hds	=:	1	; 1 Byte:	Heads  Per Cylinder (1-16)
;	pb_trk	=:	1	; 1 Byte:	Tracks Per Cylinder (1-16)
;	pb_opt	=:	2	; 1 Byte:	Special Options
;	pb_cyl	=:	3	; 2 bytes:	Total Cylinders (1 - 4096)
;	pb_max	=:	5	; 1 Byte:	Maximum Allowed Partitions
;	pb_sum	=:	6	; 1 Byte:	SUM Of Bytes 0-6 => 0xFF
;	pb_cks	=:	7	; 1 Byte:	XOR Of Bytes 0-7 => 0xFF
;	pb_str	=:	8	; 56 Bytes:	Null Terminated String
;
;	pb_sln	=:	56		; size of pb_str
;
;	ex$prt is the expected partition number
;
ptshow.mnt:
	setb	shomnt		; mounted shown
	sjmp	1$

ptshow = .
	clr	shomnt		; mounted not shown

1$:	mov	dptr,#show$7	; " Partition "
	lcall	outstr
	mov	b,ex$prt
	lcall	sp2chr

	mov	dptr,#m3_blk+pb_blk
	lcall	chk$rd		; set checksum error flags
	mov	dptr,#show$4	; "Is Not Configured"
	jb	cfg$er,9$	; configured ?
	mov	dptr,#show$5	; "Block Is Corrupted"
	jb	sum$er,9$	; sum error ?		
	jb	xrl$er,9$	; xrl error ?

	.lb_x	a,m3_blk+pb_num	; partition number
	mov	dptr,#show$5	; "Block Is Corrupted"
	cjne	a,ex$prt,9$

	mov	dptr,#show$F	; begin comment
	lcall	outstr
	mov	dptr,#m3_blk+pb_str
	mov	b,#pb_sln	; max character count
2$:	movx	a,@dptr
	jz	3$
	lcall	chrout		; output comment
	inc	dptr
	djnz	b,2$		; 

3$:	mov	dptr,#show$G	; terminate comment
	lcall	outstr

	.lb_x	a,m3_blk+pb_opt	; options
	jnz	4$
	mov	dptr,#show$8	; "   [MFM] "
	sjmp	5$
4$:	mov	dptr,#show$9	; "   [RLL] "
;	sjmp	5$
5$:	lcall	outstr

	mov	dptr,#show$A	; ",  Heads: "
	lcall	outstr
	.lb_x	b,m3_blk+pb_hds	; heads
	lcall	sp2chr		; output heads

	mov	dptr,#show$B	; ",  Cylinders: "
	lcall	outstr
	.lb_x	b,m3_blk+pb_cyl	; cylinders
	inc	dptr
	movx	a,@dptr
	lcall	sp4chr		; output cylinders

	jnb	shomnt,8$
	mov	dptr,#show$C
	lcall	outstr
	.lb_x	a,m3_blk+cb_mnt	; mountable / mounted
	jz	6$
	mov	dptr,#show$D
	sjmp	7$
6$:	mov	dptr,#show$E
;	sjmp	7$
7$:	lcall	outstr

8$:	mov	dptr,#show$H	; done
9$:	lcall	outstr
	ret

show$1:	.ascii	" Control Block Contents"
	.byte	cr,lf
show$2:	.ascii	" Partitions Available:  "
	.byte	eot
show$3:	.byte	cr,lf
	.ascii	" Port "
	.byte	eot
show$4:	.ascii	" Is Not Configured"
	.byte	cr,lf,eot
show$5:	.ascii	" Is Corrupted"
	.byte	cr,lf,eot
show$6:	.ascii	" Is Bound To Partition "
	.byte	eot
show$7:	.ascii	" Partition "
	.byte	eot
show$8:	.ascii	"   [MFM]"
	.byte	eot
show$9:	.ascii	"   [RLL]"
	.byte	eot
show$A:	.ascii	",  Heads: "
	.byte	eot
show$B:	.ascii	",  Cylinders: "
	.byte	eot
show$C:	.ascii	",  Mounted: "
	.byte	eot
show$D:	.ascii	" Yes"
	.byte	eot
show$E:	.ascii	" No"
	.byte	eot
show$F:	.ascii	"  '"
	.byte	eot
show$G:	.ascii	"'"
show$H:	.byte	cr,lf,eot

;
;****************************************************************************

	.page
	.sbttl	XDISK PARTITION

;****************************************************************************
;
x$part:	lcall	qry$pn
	jc	part_x

	clr	cpbkup		; normal addressing
	lcall	prt$rd	        ; read the partition block
	lcall	ptshow		; show current contents
	lcall	m3tom2		; copy partition block

	lcall	new$mr		; enter drive type
	jc	part_x

	lcall	new$hd		; enter new head count
	jc	part_x

	lcall	new$cy		; enter new cylinder count
	jc	part_x

	lcall	new$tx		; enter new comment string
	jc	part_x

	mov	dptr,#part$5	; " Write Partition "
	lcall	outstr
	mov	b,nm$prt	; partition number
	lcall	dec1by
	mov	dptr,#part$6	; "  (Y/N) ? "
	lcall	qry$yn
	jc	part_y		; ^C abort
	jz	part_y		; no argument
	jb	a.7,part_x	; invalid argument
	cjne	a,#1,part_y	; not YES - abort

	.sb_x	m2_blk+pb_num,nm$prt
	.sb_x	m2_blk+pb_max,mx$prt

	mov	dptr,#m2_blk+pb_blk
	lcall	chk$wt		; write checksum

	lcall	m2tom3		; copy to I/O buffer
	clr	cpbkup		; normal addressing
	lcall	prt$wt	        ; write the partition block
	.sb_r	ds$prt,nm$prt	; changed partition
	lcall	cbrchk		; check if control block should change
	ljmp	nomore

part_x:	.ldptr	#part$7		; " Missing/Invalid Argument -"
	sjmp	part_z
part_y:	.ldptr  #part$8		; " Partitioning Aborted"
;	sjmp	part_z

part_z:	lcall	outstr
	ljmp	nomore

part$1:	.ascii	" MFM(1) / RLL(2): ? "
	.byte	eot
part$2:	.ascii	" Heads: "
	.byte	eot
part$3:	.ascii	" Cylinders: "
	.byte	eot
part$4:	.ascii	" Comment: "
	.byte	eot
part$5:	.ascii	" Write Partition "
	.byte	eot
part$6:	.ascii	" (Y/N) ? "
	.byte	eot
part$7:	.ascii	" Missing/Invalid Argument -"
part$8:	.ascii	" Partitioning Aborted"
	.byte	cr,lf,eot

new$mr:	mov	dptr,#part$1	; " MFM(1) / RLL(2): ? "
	lcall	qry$ln		; input
	jc	3$
	lcall	get$nm		; get heads 
	jb	a.7,3$		; its required - abort
	jz	2$		; blank line
	.lb_rx	a,nbrhi		; check allowed
	jnz	3$		; too big - abort
	.lb_rx	a,nbrlo
	jz	3$		; 0 not allowed
	dec	a		; (1-2) => (0-1)
	cjne	a,#2,1$
1$:	jnc	3$
	.sb_x	m2_blk+pb_opt,a
2$:	clr	c		; valid return
	ret

3$:	setb	c		; invalid return
	ret

new$hd:	mov	dptr,#part$2	; " Heads: "
	lcall	qry$ln		; input
	jc	3$
	lcall	get$nm		; get heads 
	jb	a.7,3$		; its required - abort
	jz	2$		; blank line
	.lb_rx	a,nbrhi		; check allowed
	jnz	3$		; too big - abort
	.lb_rx	a,nbrlo
	jz	3$		; 0 not allowed
	cjne	a,#hdsmax+1,1$
1$:	jnc	3$
	.sb_x	m2_blk+pb_hds,a
2$:	clr	c		; valid return
	ret

3$:	setb	c		; invalid return
	ret

new$cy:	mov	dptr,#part$3	; " Cylinders: "
	lcall	qry$ln		; input
	jc	3$
	lcall	get$nm		; get heads 
	jb	a.7,3$		; its required - abort
	jz	2$		; blank line
	.lb_rx	b,nbrhi		; check allowed
	.lb_rx	a,nbrlo
	jnz	1$
	xch	a,b
	jz	3$		; 0 not allowed
	xch	a,b
1$:	clr	c
	subb	a,#<cylmax+1
	xch	a,b
	subb	a,#>cylmax+1
	jnc	3$

	.lb_rx	a,nbrhi
	.sb_x	m2_blk+pb_cyl+0,a
	.lb_rx	a,nbrlo
	.sb_x	m2_blk+pb_cyl+1,a
2$:	clr	c		; valid return
	ret

3$:	setb	c		; invalid return
	ret

new$tx:	mov	dptr,#part$4	; " Comment: "

	jnb	uprflg,1$	; set to U/L case
	setb	flgupr
1$:	clr	uprflg

	lcall	qry$ln		; comment text

	jnb	flgupr,2$	; restore case setting
	setb	uprflg
2$:	clr	flgupr

	jc	3$
	mov	dptr,#m2_blk+pb_str
	lcall	get$tx
	jb	a.7,3$		; its required - abort
	clr	c		; valid return
	ret

3$:	setb	c		; invalid return
	ret

;
;****************************************************************************

	.page
	.sbttl	XDISK BIND

;****************************************************************************
;
x$bind:	mov	dptr,#bind$1	; " Partition: "
	lcall	qry$ln		; input
	jc	3$
	lcall	qry$pn		; get partition number
	jc	2$		; invalid argument
	clr	cpbkup		; normal addressing
	lcall	prt$rd	        ; read the partition block
	lcall	m3tom2		; copy to m2_blk
	lcall	ptshow		; show Partition Block

	mov	dptr,#bind$2	; " Port: "
	lcall	qry$ln		; input
	jc	3$
	lcall	qry$dn		; get port number
	jc	2$		; invalid argument
	clr	cpbkup		; normal addressing
	lcall	ctl$rd	        ; read the control block
	lcall	m3tom1		; copy to m1_blk

	mov	dptr,#bind$3	; " Mount Partition?  (Y/N) "
	lcall	qry$yn
	jc	3$		; ^C abort
	mov	dptr,#m2_blk+cb_pr1.mnt
	jz	1$		; no argument: N 
	jb	a.7,2$		; invalid argument
	cjne	a,#2,1$		; Y (a = 1) / N (a = 2)
	clr	a		; enabled (1) / disabled (0)
1$:	movx	@dptr,a		; set parameter
	sjmp	4$

2$:	sjmp	bind_x
3$:	sjmp	bind_y

4$:	mov	dptr,#bind$4	; " Bind Partition "
	lcall	outstr
	mov	b,nm$prt	; partition number
	lcall	dec1by
	mov	dptr,#bind$5	; " To Disk "
	lcall	outstr
	.lb_rx	b,nbrlo		; disk number
	lcall	dec1by
	mov	dptr,#bind$6	; "  (Y/N) ? "
	lcall	outstr
	lcall	qry$yn		; YES or NO
	jc	bind_y		; ^C abort
	jz	bind_y		; no argument
	jb	a.7,bind_x	; invalid argument
	cjne	a,#1,bind_y	; not YES - abort

	.lb_rx	a,nbrlo		; port number
	cjne	a,#1,5$
	lcall	cb$pb0
	sjmp	8$
5$:	cjne	a,#2,6$
	lcall	cb$pb1
	sjmp	8$
6$:	cjne	a,#3,7$
	lcall	cb$pb2
	sjmp	8$
7$:	cjne	a,#4,bind_x
	lcall	cb$pb3
;	sjmp	8$
8$:	lcall	m1tom3		; copy control block to I/O
	clr	cpbkup		; normal addressing
	lcall	ctl$wt	        ; write the control block
	lcall	dskcfg		; update disk parameters
	ljmp	nomore

bind_x:	.ldptr	#bind$7		; " Missing/Invalid Argument -"
	sjmp	bind_z
bind_y:	.ldptr  #bind$8		; " Bind Aborted"
;	sjmp	bind_z

bind_z:	lcall	outstr
	ljmp	nomore

bind$1:	.ascii	" Partition: "
	.byte	eot
bind$2:	.ascii	" Port: "
	.byte	eot
bind$3:	.ascii	" Mount Partition?  (Y/N) "
	.byte	eot
bind$4:	.ascii	" Bind Partition "
	.byte	eot
bind$5:	.ascii	" To Port "
	.byte	eot
bind$6:	.ascii	"  (Y/N) ? "
	.byte	eot

bind$7:	.ascii	" Missing/Invalid Argument -"
bind$8:	.ascii	" Bind Aborted"
	.byte	cr,lf,eot

;
;****************************************************************************

	.page
	.sbttl	XDISK Copy A Partition

;****************************************************************************
;
;	pb_num	=:	0	; 1 Byte:	Partition Number (0-255)
;	pb_hds	=:	1	; 1 Byte:	Heads  Per Cylinder (1-16)
;	pb_trk	=:	1	; 1 Byte:	Tracks Per Cylinder (1-16)
;	pb_opt	=:	2	; 1 Byte:	Special Options
;	pb_cyl	=:	3	; 2 bytes:	Total Cylinders (1 - 4096)
;	pb_max	=:	5	; 1 Byte:	Maximum Allowed Partitions
;	pb_sum	=:	6	; 1 Byte:	SUM Of Bytes 0-6 => 0xFF
;	pb_cks	=:	7	; 1 Byte:	XOR Of Bytes 0-7 => 0xFF
;	pb_str	=:	8	; 56 Bytes:	Null Terminated String
;
x$copy:	mov	dptr,#copy$1	; " Source Partition: "
	lcall	qry$ln		; input
	jc	1$
	lcall	qry$pn		; get partition number
	jc	2$		; invalid argument
	.sb_r	sr$prt,nm$prt   ; save source partition number
	clr	cpbkup		; normal addressing
	lcall	prt$rd	        ; read the partition block
	lcall	ptshow		; show partition block
	lcall	m3tom2		; copy partition block

	mov	dptr,#copy$2	; " Destination Partition: "
	lcall	qry$ln		; input
1$:	jc	copy_y
	lcall	qry$pn		; get destination partition number
2$:	jc	copy_x		; invalid argument
	.sb_r	ds$prt,nm$prt	; save destination partition number
	clr	cpbkup		; normal addressing
	lcall	prt$rd	        ; read the partition block
	lcall	ptshow		; show Partition Block

3$:	mov	dptr,#m2_blk+pb_trk
	mov	r1,#cp$trk	; copy parameters
	movx	a,@dptr
	mov	@r1,a		; track count
	inc	dptr
	inc	r1

	movx	a,@dptr
	mov	@r1,a		; options
	inc	dptr
	inc	r1

	movx	a,@dptr
	mov	@r1,a		; cylinder count
	inc	dptr
	inc	r1
	movx	a,@dptr
	mov	@r1,a

	mov	dptr,#copy$4	; " Copy Partition "
	lcall	outstr
	.lb_r	b,sr$prt	; partition number
	lcall	dec1by
	mov	dptr,#copy$5	; " To Partition "
	lcall	outstr
	.lb_r	b,ds$prt	; partition number
	lcall	dec1by
	mov	dptr,#copy$6	; "  (Y/N) ? "
	lcall	outstr
	lcall	qry$yn		; YES or NO
	jc	copy_y		; ^C abort
	jz	copy_y		; no argument
	jb	a.7,copy_x	; invalid argument
	cjne	a,#1,copy_y	; not YES - abort

	lcall	xdcopy		; perform copy operation
	lcall	cbrchk		; check if control block should change
	ljmp	nomore

copy_x:	.ldptr	#copy$A		; " Missing/Invalid Argument -"
	sjmp	copy_z
copy_y:	.ldptr  #copy$B		; " Copy Aborted"
;	sjmp	copy_z

copy_z:	lcall	outstr
	ljmp	nomore

copy$1:	.ascii	" Source Partition: "
	.byte	eot
copy$2:	.ascii	" Destination Partition: "
	.byte	eot
copy$3:	.ascii	" Override Source Partition Parameters  (Y/N) ? "
	.byte	eot
copy$4:	.ascii	" Once Started The Partiton Copy May Take >10 Minutes"
	.byte	cr,lf
	.ascii	" Copy Partition "
	.byte	eot
copy$5:	.ascii	" To Partition "
	.byte	eot
copy$6:	.ascii	"  (Y/N) ? "
	.byte	eot
copy$7:	.ascii	"#"
	.byte	eot
copy$8:	.byte	cr,lf
	.ascii	" Copy Completed"
copy$9:	.byte	cr,lf,eot

copy$A:	.ascii	" Missing/Invalid Argument -"
copy$B:	.ascii	" Copy Aborted"
	.byte	cr,lf,eot

;
;****************************************************************************

	.page
	.sbttl	Copy Partition Function

;****************************************************************************
;
xdcopy:	lcall	cpyprt		; copy partition

	setb	cpbkup		; select backup partition

1$:	.lb_r	nm$prt,sr$prt	; source partition
	lcall	prt$rd		; read the partition block
	.lb_r	nm$prt,ds$prt	; destination partition

	mov	dptr,#m3_blk	; ==>> pb_blk/pb_num
	lcall	chk$rd		; set checksum error flags
	jb	cfg$er,2$	; not configured - just write
				; else update block		
	mov	dptr,#m3_blk	; ==>> pb_blk/pb_num
	mov	a,nm$prt
	movx	@dptr,a		; new partition number
	lcall	chk$wt		; update checksums
	jnb	set$er,2$	; normal - skip

	mov	dptr,#m3_blk+pb_cks
	movx	a,@dptr		; get checksum
	xrl	a,#0xFF		; corrupt partition block
	movx	@dptr,a		; store checksum

2$:	lcall	prt$wt		; save updated partition block
	jbc	cpbkup,1$	; select current partition and loop

	ret
;
;****************************************************************************

	.page
	.sbttl	Partition To Partition Copy Process

;****************************************************************************
;
cpyprt:	setb	mfmcpy			; copy in progress
	jb	mfmwbk,cpyprt		; busy   - wait
	jb	mfmbsy,cpyprt		; busy   - wait
	lcall	mfm$io			; process queue

	.pshreg				; save registers

	clr	ea
	clr	et0
	lcall	wt$bck			; save any written data

	clr	set$er			; no - error/abort

	; Set Partition Copy Type
	lcall	typset

	; Set For Direct Access To Serial Port
	lcall	tm$.1s			; wait for output buffer to clear
	setb	B_SP0DIR		; direct access enabled

	.sb_r	cp$cnt,#1		; startup value
	mov	r1,#cu$cyl		; start with cylinder 0
	clr	a
	mov	@r1,a
	inc	r1
	mov	@r1,a


1$:	lcall	cpycyl			; copy a cylinder
	lcall	ctrl_c			; ^C aborted ?
	jc	3$

	mov	r1,#cp$cnt
	dec	@r1
	mov	a,@r1
	jnz	2$
	.sb_r	cp$cnt,#16		; note every 16 cylinders copied
	mov	dptr,#copy$7		; "#"
	lcall	outstr

2$:     mov	r1,#cu$cyl		; next cyclinder
	mov	dph,@r1			; cu$cyl + 1
	inc	r1			; -
	mov	dpl,@r1			; -
	inc	dptr			; -
	mov	@r1,dpl			; -
	dec	r1			; -
	mov	@r1,dph			; -
	mov	r1,#cp$cyl+1		; cu$cyl - cp$cyl
	clr	c			; -
	mov	a,dpl			; -
	subb	a,@r1			; -
	dec	r1			; -
	mov	a,dph			; -
	subb	a,@r1			; -
	jc	1$			; loop for cylinder count
	mov	dptr,#copy$8		; " Copy Completed"
	lcall	outstr
	sjmp	4$

3$:	setb	set$er			; set error flag
	mov	dptr,#copy$9
	lcall	outstr
	mov	dptr,#copy$B		; " Copy Aborted"
	lcall	outstr

	; Disable Direct Access To serial Port

4$:	clr	B_SP0DIR		; direct access disabled

	; Restore Drive Partition Type
	lcall	typres

	.popreg				; restore registers
	clr	mfmcpy			; copy finished

	lcall	prtld			; reload partition data
	setb	ea			; enable interrupts
	ret

	; Set Partition Copy Type
typset:	clr	savtyp			; assume MFM
	jnb	mfmtyp,1$		; OK
	setb	savtyp			; else RLL
	clr	mfmtyp			; assume MFM
1$:	.lb_r	a,cp$opt
	jnb	a.0,2$			; OK
	setb	mfmtyp			; else RLL
2$:	ret

	; Restore Drive Partition Type
typres:	clr	mfmtyp			; assume MFM
	jnb	savtyp,1$		; OK
	setb	mfmtyp			; else - RLL
1$:	ret

cpycyl:

cpy$rd:	.sb_r	cu$trk,#0		; start with track 0

1$:	jnb	mfmcpy,cpycyl		; inactive requires a restart
	mov	a,#qu$tbl		; use the port 1 write bank
	add	a,#wq.bnk		; both parameters are external
	mov	r0,a
	mov	a,@r0
	jnz	2$
	clr	cache.bnk
	sjmp	3$
2$:	setb	cache.bnk
3$:	setb	cache.wrt		; DMA Read / Cache Write
	mov	mfmidx,#0		; simulate port 1
	.lb_r	mfmprt,sr$prt		; Source Partition
	.lb_r	mfmcyl,cu$cyl		; get cylinder
	.lb_r	mfmcyl+1,cu$cyl+1
	.lb_r	mfmtrk,cu$trk		; get track
	lcall	io$rw			; read a track
	inc	mfmtrk			; next track
	.sb_r	cu$trk,mfmtrk		; save next track
	mov	r1,#cp$trk
	clr	c
	mov	a,mfmtrk
	subb	a,@r1
	jc	1$			; loop for track count

cpy$wt:	.sb_r	cu$trk,#0		; start with track 0

1$:	jnb	mfmcpy,cpycyl		; inactive requires a restart
	mov	a,#qu$tbl		; use the port 1 write bank
	add	a,#wq.bnk		; both parameters are external
	mov	r0,a
	mov	a,@r0
	jnz	2$
	clr	cache.bnk
	sjmp	3$
2$:	setb	cache.bnk
3$:	clr	cache.wrt		; DMA Write / Cache Read
	mov	mfmidx,#0		; simulate port 1
	.lb_r	mfmprt,ds$prt		; Destination Partition
	.lb_r	mfmcyl,cu$cyl		; get cylinder
	.lb_r	mfmcyl+1,cu$cyl+1
	.lb_r	mfmtrk,cu$trk		; get track
	lcall	io$rw			; write a track
	inc	mfmtrk			; next track
	.sb_r	cu$trk,mfmtrk		; save next track
	mov	r1,#cp$trk
	clr	c
	mov	a,mfmtrk
	subb	a,@r1
	jc	1$			; loop for track count

cpy$xt:	ret

;
;****************************************************************************

	.page
	.sbttl	Query Functions

;****************************************************************************
;

	; Partition Number Query

qry$pn:	lcall	get$nm		; get partition number
	jb	a.7,2$		; its required - abort
	jz	2$
	.lb_rx	a,nbrhi		; check allowed
	jnz	2$		; too big - abort
	.lb_rx	a,nbrlo
	cjne	a,mx$prt,1$	; compare to maximum
1$:	jnc	2$		; too big - abort
	mov	nm$prt,a	; save partiton number
	mov	ex$prt,a
	clr	c		; valid number return
	ret

2$:	setb	c		; invalid number return
	ret

	; Port Number Query

qry$dn:	lcall	get$nm		; get port number 
	jb	a.7,2$		; its required - abort
	jz	2$
	.lb_rx	a,nbrhi		; check allowed
	jnz	2$		; too big - abort
	.lb_rx	a,nbrlo
	jz	2$		; 1-4 are valid
	cjne	a,#4+1,1$	; compare to maximum
1$:	jnc	2$		; too big - abort
	clr	c		; valid number return
	ret		        ; disk number returned in a

2$:	setb	c		; invalid number return
	ret

	; YES/NO Query

qry$yn:	lcall	qry$ln
	jnc	1$
	ret

1$:	mov	dptr,#ynlst	; look for option in list
	lcall	fndlnm		; returns with list number
	lcall	comand
	clr	c
	ret

	; Query New Line

qry$ln:	lcall	outstr
	lcall	getlin		; get line of input
	cjne	a,#3,1$		; abort line on a control-c
	lcall	docrlf
	setb	c
	ret

1$:	mov	a,#ttybuf-1
	.sb_rx	synptr,a	; reset pointer to beginning
	.sb_rx	linptr,a	; reset pointer to beginning
	setb	bolflg		; set 'beginning of line' flag
	clr	c
	ret

;
;****************************************************************************

	.page
	.sbttl	Ascii To Integer Input Function

;****************************************************************************
;
; Input A Number Function
;
;  This function is equivalent to the MONDEB-51 'number'
;  function which converts input characters to a number.
;  The conversion is performed by the function a$d$i
;  from the ascii/integer conversion library aiconv.asm.
;
;  The conversion input base is fixed for decimal.
; 
;  The 16-bit result is stored in nbrhi and nbrlo.
;
get$nm:	.sb_rx	nbrhi,#0	; initialize
	.sb_rx	nbrlo,#0
	.mvb_rx	linptr,synptr	; initialize the line scanning pointer
	lcall	skpdlm		; are we at end of line?
	jnc	1$		; no, process a number
	clr	a		; yes, zero a
	ret

1$:	.lb_rx	a,synptr
	inc	a
	.sb_rx	outadr,a	; beginning of text

2$:	lcall	mgetchr		; get a character from the input
	lcall	tstdlm		; test for a delimiter
	jnc	2$		; good delimiter if c is set

	.lb_rx	r1,linptr	; save terminator
	movx	a,@r1
	push	a
	clr	a		; NULL terminate
	movx	@r1,a

	.lb_rx	dpl,outadr	; address of ascii
	mov	dph,#0
	setb	i$xram		; address is in XRam
	lcall	a$d$i		; convert ascii to decimal

	.sb_rx	nbrlo,a		; save LSB
	dec	r1
	xch	a,b
	movx	@r1,a		; save MSB

	.lb_rx	r1,linptr
	pop	a		; restore terminator
	movx	@r1,a

	.mvb_rx	synptr,linptr	; update good syntax line pointer
	mov	a,#1		; set "good scan" flag
	jnb	i$err,3$	; a$d$i conversion error
	mov	a,#-1		; set "bad scan" flag
3$:	ret

;
;****************************************************************************

	.page
	.sbttl	Text Input Function

;****************************************************************************
;
; Input A Line Of Text
;
;  Input:	dptr - Contains Destination Address Of Output String Buffer
;  Output:	NULL Terminated String
;
get$tx: .sdptr_rx outadr	; save destination address
	.mvb_rx	linptr,synptr	; initialize the line scanning pointer
	lcall	skpdlm		; are we at end of line?
	jnc	1$		; no, process text
	clr	a		; yes, zero a
	ret

1$:	lcall	mgetchr		; get a character from the input
	mov	a,b
	cjne	a,#cr,2$	; carriage return?
	sjmp	3$
2$:	cjne	a,#lf,1$	; line feed?

3$:	.lb_rx	r1,linptr	; save terminator
	movx	a,@r1
	push	a
	clr	a		; NULL terminate
	movx	@r1,a

	.ldptr_rx outadr	; destination address
	.lb_rx	r1,synptr	; source address
	inc	r1
	mov	b,#pb_sln	; maximum string length

4$:	movx	a,@r1		; copy string
	movx	@dptr,a
	inc	r1
	inc	dptr
	jz	6$
	djnz	b,4$
	sjmp	7$

5$:	movx	@dptr,a		; clear rest of string
	inc	dptr
6$:	djnz	b,5$

7$:	.lb_rx	r1,linptr
	pop	a		; restore terminator
	movx	@r1,a

	.mvb_rx	synptr,linptr	; update good syntax line pointer
	mov	a,#1		; set "good scan" flag
	ret

;
;****************************************************************************

	.page
	.sbttl	Read/Write Disk Control Block

;****************************************************************************
;
; Read/Write Disk Control Block
;
;  I/O Buffer:	m3_blk
;
;  External Functions:
;		pio$rd			; read a block
;		pio$wt			; write a block
;
;  External Variables:
;		pioadd			; i/o buffer address
;		piolba			; IDE LBA
;		
;  Notes:	The Control Block has an offset of 0x2E
;		  from the first block of partition 0.
;		The Backup Control Block has an offset of 0x2E
;		  from the first block of partition n
;		  where n is the number of disk partitions
;		  divided by 2 (remainder is ignored).
;
ctl$rd:	lcall	ctl$rw			; prepare for read
	ljmp	pio$rd			; do read
	
ctl$wt:	lcall	ctl$rw			; prepare for write
	ljmp	pio$wt			; do write

ctl$rw:	mov	pioadd+0,#>m3_blk	; data buffer
	mov	pioadd+1,#<m3_blk

	mov	piolba+3,#ctlcfg	; configuration block offset
	mov	piolba+2,#prtoff	; arbitrary base offset
	clr	a			; #0
	mov	b,a			; #0
	jnb	cpbkup,1$		; on backup modify to
	mov	a,mx$prt		; number of partitions
	clr	c
	rrc	a			; divided by 2, remainder ignored
	mov	b,#prtsiz		; partition size is 1.5GB
	mul	ab			; partition number * size
1$:	mov	piolba+1,a
	mov	piolba+0,b		; LBA is <27:00>
	ret

;
;****************************************************************************

	.page
	.sbttl	Read/Write Partition Configuration Block

;****************************************************************************
;
; Read/Write Partition Configuration Block
;
;  Input:	a, the partition number <0-255>
;  I/O Buffer:	m3_blk
;
;  External Functions:
;		pio$rd			; read a block
;		pio$wt			; write a block
;
;  External Variables:
;		pioadd			; i/o buffer address
;		piolba			; IDE LBA
;		
;  Assumtions:	Partition Size is 1.5GB
;		Arbitrary Offset is 256 Blocks
;		  from the IDE LBA of 0
;		The Configuration Block has an offset of 0x2F
;		  from the beginning of the partition.
;		The Backup Configuration Block has an offset of 0x2F
;		  from the beginning of the 2049th cylinder.
;
;  Limitations:	The partition number should be limited
;		to 0 - 84 to produce a valid partition
;		LBA within the 28-Bit address range
;		supported by IDE LBA addressing.
;
;		The partiton number has been arbitrarily
;		limited to 0-63 in this implementation.
;
prt$rd:	lcall	prt$rw			; prepare for read
	ljmp	pio$rd			; do read
	
prt$wt:	lcall	prt$rw			; prepare for write
	ljmp	pio$wt			; do write

prt$rw:	mov	pioadd+0,#>m3_blk	; data buffer
	mov	pioadd+1,#<m3_blk

	mov	piolba+3,#prtcfg	; configuration block offset
	mov	piolba+2,#prtoff	; arbitrary base offset
	mov	a,nm$prt		; partition number
	mov	b,#prtsiz		; partition size is 1.5GB
	mul	ab			; partition number * size
	jnb	cpbkup,1$		; on backup modify to
	add	a,#prtsiz		; center of partition is prtsiz/2
	clr	c			; prtsiz is external so prtsiz/2
	rrc	a			; will give a relocation error
	xch	a,b
	addc	a,#0x00
	xch	a,b
1$:	mov	piolba+1,a
	mov	piolba+0,b		; LBA is <27:00>
	ret

;
;****************************************************************************

	.page
	.sbttl	XOR Checksum Functions

;****************************************************************************
;
; Read/Write The 8-Byte Block Checksum
;
;  Input:	dptr, The Checksum Block Address
;
;  Read:	xlr$er - Set When Block Is Corrupt
;		sum$er - Set When Block Parameters Are Corrupt
;		cfg$er - Set When Block Is Not Configured
;
;  Write:	Byte 6 Is Set Such That the Sum Of Bytes 0-6 == 0xFF
;		Byte 7 Is Set Such That The XOR Of Bytes 0-7 == 0xFF
;	
chk$rd: mov	r2,dph			; save address
	mov	r3,dpl

	mov	r0,#8			; SUM 8 bytes
	lcall	chk$sm			; SUM of 8 bytes
	setb	cfg$er		        ; SUM = 0 then not configured
	jz	1$
	clr	cfg$er

1$:	mov	r0,#7			; SUM 7 bytes
	lcall	chk$sm			; SUM of 7 bytes
	add	a,#1			; SUM + 1 => 0
	clr	sum$er			; SUM = 0 then data checks
	jz	2$
	setb	sum$er

2$:	mov	r0,#8			; XOR 8 bytes
	lcall	chk$xr			; XOR of 8 bytes
	add	a,#1			; XOR + 1 => 0
	clr	xrl$er			; XOR = 0 then checksum OK
	jz	3$
	setb	xrl$er

3$:	mov	dph,r2			; restore address
	mov	dpl,r3
	ret

chk$wt: mov	r2,dph			; save address
	mov	r3,dpl

 	mov	r0,#6			; SUM 6 Bytes
	lcall	chk$sm			; SUM of first 6 bytes
	mov	a,#0xFF			; compute value to give
	xrl	a,b			; a value of 0xFF
	movx	@dptr,a			; save SUM value

	mov	r0,#7			; XOR 7 bytes
	lcall	chk$xr			; XOR of first 7 bytes
	mov	a,#0xFF			; compute value to give
	xrl	a,b			; a value of 0xFF
	movx	@dptr,a			; save XOR value

	mov	dph,r2			; restore address
	mov	dpl,r3
	ret

chk$sm: mov	dph,r2			; load address
	mov	dpl,r3
	mov	b,#0			; initialize SUM
	clr	c
1$:	movx	a,@dptr			; get byte
	addc	a,b			; a + SUM => a
	mov	b,a			; a => SUM
	inc	dptr			; next byte
	djnz	r0,1$			; loop
	ret

chk$xr: mov	dph,r2			; load address
	mov	dpl,r3
	mov	b,#0			; initialize XOR
1$:	movx	a,@dptr			; get byte
	xrl	a,b			; a ^ XOR => a
	mov	b,a			; a => XOR
	inc	dptr			; next byte
	djnz	r0,1$			; loop
	ret

;
;****************************************************************************

	.page
	.sbttl	Block Copy Functions

;****************************************************************************
;
	; block copy combinations

m1tom2:
	.stsrc	#m1_blk		; control block
	.stdst	#m2_blk		; temp
	sjmp	1$

m1tom3=.
	.stsrc	#m1_blk		; control block
	.stdst	#m3_blk		; temp
	sjmp	1$

m2tom1=.
	.stsrc	#m2_blk		; control block
	.stdst	#m1_blk		; temp
	sjmp	1$

m2tom3=.
	.stsrc	#m2_blk		; partition block
	.stdst	#m3_blk		; temp
	sjmp	1$

m3tom1=.
	.stsrc	#m3_blk		; temp
	.stdst	#m1_blk		; control block
	sjmp	1$

m3tom2=.
	.stsrc	#m3_blk		; temp
	.stdst	#m2_blk		; partition block
;	sjmp	1$

1$:	.stcnt	#-512		; block of 512 bytes

cpymem:	.ldsrc
	movx	a,@dptr
	inc	dptr
	.stsrc
	.lddst
	movx	@dptr,a
	inc	dptr
	.stdst
	.ldcnt
	inc	dptr
	.stcnt
	cjne	r1,#0,cpymem
	lcall	wchdog		; every 256 bytes
	cjne	r0,#0,cpymem
	ret

;
;****************************************************************************

	.page
	.sbttl	Copy Partition Information To Control Block

;****************************************************************************
;
; Copy A Partition Block To Control Block
;
;  Input:	Partition Block In Buffer m2_blk
;  Output:	Control Block in Buffer m1_blk
;
cb$pb0:
	.stdst	#m1_blk+cb_pr1	; destination
	sjmp	1$

cb$pb1=.
	.stdst	#m1_blk+cb_pr2	; destination
	sjmp	1$

cb$pb2=.
	.stdst	#m1_blk+cb_pr3	; destination
	sjmp	1$

cb$pb3=.
	.stdst	#m1_blk+cb_pr4	; destination
;	sjmp	1$

1$:	.stsrc	#m2_blk
	.stcnt	#-cb_siz	; copy 128 bytes
	sjmp	cpymem

;
;****************************************************************************

	.page
	.sbttl	Copy Code Functions

;****************************************************************************
;
; Copy Code
;
cpycod:	.ldsrc
	clr	a
	movc	a,@a+dptr
	inc	dptr
	.stsrc
	.lddst
	movx	@dptr,a
	inc	dptr
	.stdst
	.ldcnt
	inc	dptr
	.stcnt
	cjne	r1,#0,cpycod
	lcall	wchdog		; every 256 bytes
	cjne	r0,#0,cpycod
	ret
;
;****************************************************************************

	.page
	.sbttl	Zero Blocks Functions

;****************************************************************************
;
; Zero Blocks
;
zr$m1:
	.stdst	#m1_blk		; destination
	sjmp	1$

zr$m2=.
	.stdst	#m2_blk		; destination
	sjmp	1$

zr$m3=.
	.stdst	#m3_blk		; destination
;	sjmp	1$

1$:	.stcnt	#-512		; block of 512 bytes
;	sjmp	zermem
	
zermem:	.lddst
	clr	a
	movx	@dptr,a
	inc	dptr
	.stdst
	.ldcnt
	inc	dptr
	.stcnt
	cjne	r1,#0,zermem
	lcall	wchdog		; every 256 bytes
	cjne	r0,#0,zermem
	ret

;
;****************************************************************************
;
; Zero Partition Block In Control Block
;
zr$cb0:
	.stdst	#m1_blk+cb_pr1	; destination
	sjmp	1$

zr$cb1=.
	.stdst	#m1_blk+cb_pr2	; destination
	sjmp	1$

zr$cb2=.
	.stdst	#m1_blk+cb_pr3	; destination
	sjmp	1$

zr$cb3=.
	.stdst	#m1_blk+cb_pr4	; destination
;	sjmp	1$

1$:	.stcnt	#-cb_siz	; zero 128 bytes
	sjmp	zermem		; go zero bytes

;
;****************************************************************************

	.page
	.sbttl	Rebuild Control Block

;****************************************************************************
;
; Note: m1_blk+cb_pr1 == m1_blk+cb_pr1+pb_blk == m1_blk+cb_pr1+pb_num
;
cb$adr:	mov	a,nm$dsk	; selected disk partition
	cjne	a,#1,1$
	mov	dptr,#m1_blk+cb_pr1
	sjmp	4$
1$:	cjne	a,#2,2$
	mov	dptr,#m1_blk+cb_pr2
	sjmp	4$
2$:	cjne	a,#3,3$
	mov	dptr,#m1_blk+cb_pr3
	sjmp	4$
3$:	cjne	a,#4,4$
	mov	dptr,#m1_blk+cb_pr4
;	sjmp	4$
4$:	ret

;
; This Function Checks If The Updated Partition
; Is In The Control Block And Needs To Be Updated
;
;   Enter With Updated Partiton Number In sr$prt
;
cbrchk:	mov	r0,#pr1prt	; Port 1 partition address
	lcall	1$
	mov	r0,#pr2prt	; Port 2 partition address
	lcall	1$
	mov	r0,#pr3prt	; Port 3 partition address
	lcall	1$
	mov	r0,#pr4prt	; Port 4 partition address

1$:     mov	r1,#ds$prt	; changed partition
	mov	b,@r1
	mov	a,@r0		; control block partition
	cjne	a,b,2$
	lcall	cbrbld
2$:	ret
	
;
; This Function Rebuilds The Control Block
; With Any Updated Partition Information
;
cbrbld:	clr	cpbkup		; normal addressing
	lcall	ctl$rd	        ; read the control block
	lcall	m3tom1		; copy to editting block

	mov	nm$dsk,#0	; initialize
1$:	inc	nm$dsk	        ; next partition position

	lcall	cb$adr		; address of partition data
	lcall	chk$rd		; set checksum error flags
	jb	xrl$er,5$	; xrl error - partition not changed
	jb	sum$er,5$	; sum error - partition not changed		
	jnb	cfg$er,2$	; cfg error - not configured
	lcall	zr$m3		; clear partition 
	sjmp	4$

2$:	lcall	cb$adr		; address of partition data
	movx	a,@dptr
	mov	nm$prt,a	; save partition number

	cjne	a,mx$prt,3$
3$:	jnc	5$		; invalid partition number

	clr	cpbkup		; normal addressing
	lcall	prt$rd		; read the partition

4$:	lcall	cb$adr		; address of partition data
	.stdst			; save destination

	.stsrc	#m3_blk		; partition source
	.stcnt	#-cb_siz
	lcall	cpymem

5$:	mov	a,nm$dsk 
	cjne	a,#4,1$

	lcall	m1tom3		; copy control block to I/O space
	clr	cpbkup		; normal addressing
	lcall	ctl$wt		; write out the control block
	
; *****-----*****-----*****-----*****-----*****

	; Fall Directly Through To Update The Disk Parameters

; *****-----*****-----*****-----*****-----*****

;****************************************************************************

	.page
	.sbttl	Load Disk Configuration Parameters

;****************************************************************************
;
; Input:	Control Block In m3_blk
; Output:	ds0prt-ds3prt Disk 1-4 Partition Bindings
;		ds0tpc-ds3tpc Heads / Tracks Per Cylinder
;		ds0max-ds3max Number Of Cylinders
;
;	pb_blk	=:	0		; Checksum Block, Bytes 0 - 7
;
;	pb_num	=:	0	; 1 Byte:	Partition Number (0-255)
;	pb_hds	=:	1	; 1 Byte:	Heads  Per Cylinder (1-16)
;	pb_trk	=:	1	; 1 Byte:	Tracks Per Cylinder (1-16)
;	pb_opt	=:	2	; 1 Byte:	Special Options
;	pb_cyl	=:	3	; 2 bytes:	Total Cylinders (1 - 4096)
;	pb_max	=:	5	; 1 Byte:	Maximum Allowed Partitions
;	pb_sum	=:	6	; 1 Byte:	SUM Of Bytes 0-6 => 0xFF
;	pb_cks	=:	7	; 1 Byte:	XOR Of Bytes 0-7 => 0xFF
;	pb_str	=:	8	; 56 Bytes:	Null Terminated String
;
;	pb_sln	=:	56		; size of pb_str
;
;	Configured Port Tables
;	pr$tbl:
;	pr_bnk:	.blkb	1		; Port Cache Bank Select
;	pr_prt:	.blkb	1		; Port Partition Number
;	pr_cyl:	.blkb	2		; Port Cylinder
;	pr_tpc:	.blkb	1		; Port Tracks / Cylinder
;	pr_opt:	.blkb	1		; Port Options
;	pr_max:	.blkb	2		; Port Cylinder Maximum
;
dskcfg:	mov	nm$dsk,#0	; initialize
1$:	inc	nm$dsk	        ; next partition position

	mov	a,nm$dsk	; selected disk partition port
	cjne	a,#1,2$
	mov	dptr,#m3_blk+cb_pr1
	mov	r1,#pr1tbl
	sjmp	5$
2$:	cjne	a,#2,3$
	mov	dptr,#m3_blk+cb_pr2
	mov	r1,#pr2tbl
	sjmp	5$
3$:	cjne	a,#3,4$
	mov	dptr,#m3_blk+cb_pr3
	mov	r1,#pr3tbl
	sjmp	5$
4$:	cjne	a,#4,5$
	mov	dptr,#m3_blk+cb_pr4
	mov	r1,#pr4tbl

5$:     lcall	chk$rd		; check validity
	jb	cfg$er,7$	; SUM  = 0 then not configured
	jb	sum$er,7$	; SUM != 0 then data check failed
	jb	xrl$er,7$	; XOR != 0 then checksum failed

	mov	@r1,#0		; preset cache bank

	movx	a,@dptr		; partition number
	inc	r1
	mov	@r1,a

	inc	r1		; preset active cylinder
	mov	@r1,#0
	inc	r1
	mov	@r1,#0

	inc	dptr		; head count
	movx	a,@dptr
	inc	r1
	mov	@r1,a

	inc	dptr		; options - set to port #
	inc	r1
	mov	@r1,nm$dsk	; (1-4)

	inc	dptr
	movx	a,@dptr		; MSB cylinder count
	inc	r1
	mov	@r1,a
	inc	dptr
	movx	a,@dptr		; LSB cylinder count
	inc	r1
	mov	@r1,a

6$:	mov	a,nm$dsk 
	cjne	a,#4,1$

	lcall	prtmsk		; set port masks
	lcall	prtmnt		; mount ports
	lcall	prttyp		; check drive types
	ret

7$:	mov	a,dpl		; add mount byte offset to address
	add	a,#<(cb_pr1.mnt-cb_pr1)
	mov	dpl,a
	mov	a,dph
	addc	a,#>(cb_pr1.mnt-cb_pr1)
	mov	dph,a
	clr	a
	movx	@dptr,a		; clear the mount flag
	sjmp	6$
;
;****************************************************************************
;
;	Check Drive Types
;
prttyp:	mov	b,#0
	mov	nm$prt,#0	; use as counter
	jnb	pr1.mnt,1$
	inc	nm$prt
	mov	dptr,#m3_blk+cb_pr1+pb_opt
	movx	a,@dptr
	jz	1$
	inc	b
1$:	jnb	pr2.mnt,2$
	inc	nm$prt
	mov	dptr,#m3_blk+cb_pr2+pb_opt
	movx	a,@dptr
	jz	2$
	inc	b
2$:	jnb	pr3.mnt,3$
	inc	nm$prt
	mov	dptr,#m3_blk+cb_pr3+pb_opt
	movx	a,@dptr
	jz	3$
	inc	b
3$:	jnb	pr4.mnt,4$
	inc	nm$prt
	mov	dptr,#m3_blk+cb_pr4+pb_opt
	movx	a,@dptr
	jz	4$
	inc	b
4$:	mov	a,b		; RLL drives
	jz	6$		; none - all MFM
	cjne	a,nm$prt,5$	; not all drives RLL
	lcall	setrll		; set drive type - RLL
	ret

5$:	mov	dptr,#7$
	lcall	outstr

6$:     lcall	setmfm		; set drive type - MFM
	ret

7$:	.ascii	" ?Warning - Incompatible Drive Types Mounted"
	.byte	cr,lf,eot

;
;****************************************************************************
;
;	Set Port Mounted Flags
;

prtmnt:	clr	pr1.mnt		; clear mounts
	clr	pr2.mnt
	clr	pr3.mnt
	clr	pr4.mnt

	clr	set$er		; prepare for track compare
	clr	a
	mov	r2,a
	mov	r3,a

	mov	dptr,#m3_blk+cb_pr1.mnt
	movx	a,@dptr
	jz	1$
	setb	pr1.mnt
	mov	r0,#pr$msk+0
	lcall	5$
1$:	mov	dptr,#m3_blk+cb_pr2.mnt
	movx	a,@dptr
	jz	2$
	setb	pr2.mnt
	mov	r0,#pr$msk+2
	lcall	5$
2$:	mov	dptr,#m3_blk+cb_pr3.mnt
	movx	a,@dptr
	jz	3$
	setb	pr3.mnt
	mov	r0,#pr$msk+4
	lcall	5$
3$:	mov	dptr,#m3_blk+cb_pr4.mnt
	movx	a,@dptr
	jz	4$
	setb	pr4.mnt
	mov	r0,#pr$msk+6
	lcall	5$
4$:	jb	set$er,8$	; check result of track overlap
	ret

5$:	mov	b,r2		; compare allocated tracks
	lcall	6$
	mov	r2,a
	mov	b,r3
	lcall	6$
	mov	r3,a
	ret

6$:     mov	a,@r0		; test for overlapping tracks
	anl	a,b
	jz	7$		; OK - skip
	setb	set$er		; an overlap of tracks
7$:	mov	a,@r0
	orl	a,b
	inc	r0
	ret

8$:	mov	dptr,#10$	; note configuration error
	lcall	outstr
	jnb	str$up,9$	; check if in startup
	lcall	tm$.1s		; wait for output buffer to clear
9$:	ret

10$:	.ascii	" ?Warning - Invalid Control Block Partition Assignments"
	.byte	cr,lf,eot

;
;****************************************************************************
;
;	Set Track Masks
;

prtmsk:	; address of bit mask table
	mov	r0,#pr$msk
	; address of first tracks per cylinder
	mov	r1,#pr1tpc
	;
	mov	r2,#0		; port index
	mov	r3,#4		; 4 ports
	;
1$:	clr	a		; clear mask
	mov	@r0,a
	inc	r0
	mov	@r0,a
	dec	r0
	;
	mov	b,@r1		; get track count
2$:	setb	c		; set one bit per track
	lcall	shftbt
	djnz	b,2$
	;
	mov	a,r2		; rotate bits by port offset
	jz	5$		; 0 - is no shift
	mov	b,#4
	mul	ab
	mov	b,a		; set rotate count
3$:	clr	c
	lcall	shftbt
	jnc	4$
	mov	a,@r0
	inc	a
	mov	@r0,a
4$:	djnz	b,3$
	;
5$:	inc	r0		; next bit mask
	inc	r0
	mov	a,r1
	add	a,#pr$siz	; next track count
	mov	r1,a
	inc	r2		; next port
	djnz	r3,1$

	ret

shftbt:	mov	a,@r0
	rlc	a
	mov	@r0,a
	inc	r0
	mov	a,@r0
	rlc	a
	mov	@r0,a
	dec	r0
	ret

;
;****************************************************************************
;
;	Load Track 0 For All Partitions
;
prtld:	mov	a,#0xFF
	mov	dptr,#prtsts
	movx	@dptr,a		; prtsts - clear stepping register
	inc	dptr
	; -----			; hdsts  - skip
	inc	dptr
	movx	@dptr,a		; trkwt0 - clear tracks written
	inc	dptr
	movx	@dptr,a		; trkwt1 - clear tracks written

	jnb	pr1.mnt,1$	; not mounted - skip
	mov	b,#0		; initialize Port 1
	lcall	q$put		; load queue
1$:	jnb	pr2.mnt,2$	; not mounted - skip
	mov	b,#1		; initialize Port 2
	lcall	q$put		; load queue
2$:	jnb	pr3.mnt,3$	; not mounted - skip
	mov	b,#2		; initialize Port 3
	lcall	q$put		; load queue
3$:	jnb	pr4.mnt,4$	; not mounted - skip
	mov	b,#3		; initialize Port 4
	lcall	q$put		; load queue

4$:	clr	ex0		; disable Ex0Int interrupts
	lcall	Ex0Int		; NOTE: ea is set at completion
	clr	ea		; hold all interrupts
	setb	ex0		; enable  Ex0Int interrupts

	ret

;
;****************************************************************************

	.page
	.sbttl	Maximum Disk Partitions

;****************************************************************************
;
; Calculate The Maximum Number Of Partitions
;
;  Input:	32-Bit LBA From The IDE Information Block
;  Output:	Maximum Number Of Partitions (Limited To 64)
;
maxprt:	mov	dptr,#dr$lbl		; load 32-Bit LBA size
	movx	a,@dptr
	mov	r1,a			; byte 1
	inc	dptr
	movx	a,@dptr
	mov	r0,a			; byte 0
	inc	dptr
	movx	a,@dptr
	mov	r3,a			; byte 3
	inc	dptr
	movx	a,@dptr
	mov	r2,a			; byte 2

	clr	c			; subtract partition offset
;	mov	a,r0
;	subb	a,#0x00
;	mov	r0,a
	mov	a,r1
	subb	a,#prtoff
	mov	r1,a
	mov	a,r2
	subb	a,#0x00
	mov	r2,a
	mov	a,r3
	subb	a,#0x00
	mov	r3,a

	mov	r4,#0			; compute allowed partitions
1$:	clr	c
	mov	a,r2
	subb	a,#prtsiz		; 1.5 GB per partition
	mov	r2,a
	mov	a,r3
	subb	a,#0x00
	mov	r3,a
	jc	2$			; terminate when space exhausted
	inc	r4
	cjne	r4,#prtmax,1$		; limit to 64 partitions
2$:	mov	mx$prt,r4		; save
	ret

;
;****************************************************************************

	.page
	.sbttl	DSKTST Table Entries

;****************************************************************************
;
	dsk$tst	=: 0	; Enable Function Testing/Debugging
;
;****************************************************************************
.ifne dsk$tst

	.msg	^"***** Function Testing/Debugging Code Included *****"

;****************************************************************************
;
	; Command Table Entries

	.area	CmdTbl

	ljmp	dsktst

;
;****************************************************************************
;
	; Command List Entries 

	.area	CmdLst

	.ascii	/DSKTST/
	.byte	cr

;
;****************************************************************************
;
	; Command Option List Entries

	.area	OptLst

;
;****************************************************************************
;
	; Extended Help String Pointers

	.area	X_Ptrs

	.word	$dsktst

;
;****************************************************************************
;
	; Extended Help Strings

	.area	X_Strs

$dsktst:
	.ascii	"   DS[KTST]"
	.byte	cr,lf
	.ascii	"     DSKCFG Function Testing"
	.byte	cr,lf
	.byte	eot

;
;****************************************************************************
;
	.area	DskCfg
;
;****************************************************************************

	.page
	.sbttl	DSKTST Function Debugging

;****************************************************************************
;
; Function Testing
;

dsktst:	lcall	dsfnc1
;
;****************************************************************************

	.page
	.sbttl	Test Functions

dsfnc1:
.ifne 1
	;setb	pr1tk0			; set internal track0 flags
	;setb	pr2tk0
	;setb	pr3tk0
	;setb	pr4tk0

	mov	dptr,#btctrl		; btctrl - seek/track0 bits
	mov	b,#4			; 4 ports 

1$:	dec	b			; port codes are 0 - 3
	mov	a,#(bt.skwt|bt.skbt)
;	mov	a,#(bt.skwt|bt.skbt|bt.tkwt|bt.tkbt)
	orl	a,b			; or code with bits
	movx	@dptr,a			; set seekdn and track0
	mov	a,b
	cjne	a,#0,1$			; loop for each port

.endif
	ljmp	nomore

.endif	; dsk$tst

.endif	; dsk$cfg
.endif	; .else of _dskcfg

	.end

