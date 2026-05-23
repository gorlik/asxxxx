.nlist
;****************************************************************************
;
; Compile The Assembly Code
;
;	AS89LP -loxff mfmide.asm
;
; To Define The mfmide.asm Globals Place The Following Lines In Your Code
;
;	.define _mfmide
;	.list	(!)	; This Inhibits The Include File Pagination
;	.include "mfmide.asm"
;	.list
;
;****************************************************************************
;
; This Definition Controls The Inclusion MFM and IDE Code
;
	; mfmide.asm
	mfm$ide =:	1

;
;****************************************************************************
;
;	The Debugging Parameters
;
; Manually Disable Inclusion Of Individual Debug Routines
; By Using These Options:
;
	; M[FMDBG] C[OUNTERS] Option
	dbg.db$cnt =: 1		* mfm$ide	; 1 => Debug, 0 => No Debug

	; M[FMDBG] L[OGGING] Options
	dbg.db$que =: 1		* mfm$ide	; 1 => Debug, 0 => No Debug
	  dbg.db$skt =: 1	* dbg.db$que 	; 1 => Debug, 0 => No Debug
	  dbg.db$tch =: 1	* dbg.db$que	; 1 => Debug, 0 => No Debug
	  dbg.db$ide =: 1	* dbg.db$que	; 1 => Debug, 0 => No Debug

	; M[FMDBG] E[X0] Option
	dbg.db$chg =: 1		* mfm$ide	; 1 => Debug, 0 => No Debug

	; M[MFDBG] M[CI] Options
	dbg.Ex0$TstA =: 1	* mfm$ide	; 1 => Debug, 0 => No Debug
	dbg.Ex0$TstB =: 1	* mfm$ide	; 1 => Debug, 0 => No Debug

	; M[FMDBG] W[BK] Option
	dbg.Wbk$TstA =: 1	* mfm$ide	; 1 => Debug, 0 => No Debug

;
;****************************************************************************
;
.ifne	mfm$ide
	.define		Int$Ex0		; Using Ex0 Interrupt
	.undefine	Int$Ex1		; Not Using Ex1 Interrupt
.endif
;
;****************************************************************************
;
; Globals In A Macro
;
	.macro	.mfmide.globals	arg$
	  .ifne	mfm$ide
	    .iifne  arg$	    .list	(!,err,loc,bin,cyc,eqt,lin,src,mel)

	  ; MFMIDE Initialization
	  .globl	mfmide_init
	  ; Ex0Int Interrupt Service
	  .globl	Ex0Int
	  ; Programmed IO
	  .globl	pio$rd,	pio$wt,	piolba,	pioadd
	  ; Drive Type
	  .globl	setmfm,	setrll
	    .nlist
	    .ifne	mfm$dbg
	      .iifne  arg$    .list	(!,err,loc,bin,cyc,eqt,lin,src,mel)

	  ; Debugging
	  .globl	x1setb,	x1clrb,	x2setb,	x2clrb
	  .globl	q$enbl,	qb$blk,	qb$scn
	  .globl	db.tch,	db.ext,	db.iwt,	db.ird,	db.skt
	  .globl	rdqblk,	wtqblk,	dbgblk
	  .globl	pr1$qu,	pr2$qu,	pr3$qu,	pr4$qu
	  .globl	pr1$db,	pr2$db,	pr3$db,	pr4$db
	  .globl	db$prm.rop, db$prm.tch, db$prm.wop, db$prm.twt
	  .globl	db$prm.ext, db$prm.iwt, db$prm.ird, db$prm.skt
	  .globl	Ex0$TstA, Ex0$xbtA
	  .globl	Ex0$TstB, Ex0$xbtB
	  .globl	Wbk$TstA, Wbk$xbtA
	  .globl	i$enbl,	i$msb,	i$lsb
	  .globl	j$cnt,	j$msb,	j$lsb
	  .globl	t2$tsk,	t2$xit
	  .globl	bsycnt,	wbkcnt,	cpycnt,	rdycnt,	nulcnt, dupcnt
	      .nlist
	    .endif
	    .iifne  arg$    .list	(!,err,loc,bin,cyc,eqt,lin,src,mel)

	  ; MFM Port Parameters
	  .globl	prtoff,	prtsiz
	  .globl	pr$tbl,	pr$siz,	pr$msk
	  .globl	pr1tbl,	pr2tbl,	pr3tbl,	pr4tbl
	  .globl	pr1prt,	pr2prt,	pr3prt,	pr4prt
	  .globl	pr1cyl,	pr2cyl,	pr3cyl,	pr4cyl
	  .globl	pr1tpc,	pr2tpc,	pr3tpc,	pr4tpc
	  .globl	pr1opt,	pr2opt,	pr3opt,	pr4opt
	  .globl	pr1max,	pr2max,	pr3max,	pr4max
	  .globl	pr1msk,	pr2msk,	pr3msk,	pr4msk
	  .globl	pr1.mnt, pr2.mnt, pr3.mnt, pr4.mnt
	  .globl	pr$chg
	  .globl	hdsmax,	cylmax
	  ; MFM Port Queue Parameters
	  .globl	rwqsiz,	rwdsiz
	  .globl	pr1$rd,	pr2$rd,	pr3$rd,	pr4$rd
	  .globl	pr1$wt,	pr2$wt,	pr3$wt,	pr4$wt
	  .globl	rq.bnk,	rq.prt,	rq.cyl,	rq.trk,	rq.opt,	rq.tch
	  .globl	wq.bnk,	wq.prt,	wq.cyl,	wq.trk,	wq.opt,	wq.twt
	  .globl	q$geti,	q$puti,	q$get,	q$put,	q$sts
	  .globl	q$blk,	qu$tbl, qu$siz
	  ; IDE Disk Parameters
	  .globl	ideblk,	ioblk1,	ioblk2
	  .globl	dr$cyl,	dr$hd,	dr$sct
	  .globl	dr$frm,	dr$mdl
	  .globl	dr$lbl,	dr$lbh
	  ; MFM/IDE Flags
	  .globl	mfmbsy,	mfmwbk,	mfmcpy
	  .globl	mfmerr,	cache.bnk,  cache.wrt
	  ; DMA Read/Write
	  .globl	io$rw
	  .globl	mfmidx,	mfmprt,	mfmcyl,	mfmtrk, mfmtyp
	  .globl	mfm$io
	  ; Other
	  .globl	wrtbck,	wt$bck
	    .nlist
	  .endif
	.endm
;
;****************************************************************************
;
;	  The data structure, defined in mfmide.asm, provides the template
;	for the structure named 'partition'.  NOTE: This has no connective
;	relation to the common definition of partitions in modern operating
;	systems.  The 'partitons' described here are simply a range of
;	disk Logical Blocks designated as space for a single MFM drive
;	emulation.  The attached drive is simply treated as a raw
;	logical block device accessed by logical block addressing.
;
;	  The allocation of space for a single head on an MFM drive is
;	directly related to the 5 MHz clocking frequency.  5 MHz requires
;	two transitions per Hz of clock frequency or a 10 MBit data
;	rate for encoding a standard MFM data stream.  An MFM drive
;	spins at 3600 rpm (rounds per minute): 60 rps (rounds per second).
;	60 rps means one revolution takes 16.67 ms.  Thus for one revolution
;	with a 10 MBit data stream 166,667 bits of data is required for a
;	single head of the drive.  This translates to 20.83 KB or 40.69
;	blocks (512 bytes/block) of a standard ATE drive.
;
;	  The allocation of space for a single head on an RLL drive is
;	computed based on a 7.5 Mhz clock frequency.  A single track
;	requires 250,000 bits corresponding to 31.25 KB or 61.04 blocks
;	(512 bytes/block) of a standard ATA drive.
;
;	  The MFM emulation requires 41 blocks and the RLL emulation
;	requires 62 blocks of data per head(track).  To allow the
;	emulation of MFM or RLL drives a 64 block allocation is
;	chosen as being compatible with either mode.
;
;	  The allocation for a single 'partition' is thus the blocks per
;	head times the maximum number of heads times the maximum number
;	of cyclinders (64 * 16 * 4096) which is 2.0GB of disk space.
;	An MFM drive of upto 550MB  or an RLL drive of upto 825MB
;	can be created with these parameters.  The actual size limit
;	is determined by the controller maximum heads/cylinders.
;
;	  Most controllers only support 1024 or 2048 cyclinders
;	so most of the allocated space is not utilized.  For 32GB
;	SD card, and accounting for some other internal space allocation,
;	this corresponds to about 14 'partitions', a 40GB Hard drive
;	will have about 19 'partitions', and an 80GB drive will have 39
;	'partitions'.  (See the dskcfg.asm notes on how the 'partitions'
;	are bound to the 4 'ports' defined in mfmide.asm)
;
;	  The FPGA hardware maintains a cache which contains a maximum
;	of 16 tracks of data corresponding to each head of an MFM drive.
;	The 16 tracks of data are allocated to the emulated drives.
;	The sum total number of tracks for all active emulated drives must
;	be 16 or less with some restrictions.  So that multiple drives
;	can be emulated each of the 'ports' (1-4) tracks are  mapped into
;	the cache at varying positions.  The port mapping is:
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
;	Note that mapping is round-robin, but should not be required for any
;	drive configuration.
;
;	  For a drive with 13-16 heads(tracks) only a single drive emulation
;	is possible without overlapping heads(tracks) with another drive of
;	any configuration.
;
;	  For a drive with 9-12 heads(tracks) a second drive with 1-4 heads(tracks)
;	is the only option.
;
;	  For a drive with 5-8 heads(tracks) 8 heads(tracks) can be allocated to
;	one or two additional drives: one with 1-8 heads(tracks) or two
;	with 1-4 heads(tracks) in each.
;
;	  For a drive with 1-4 heads(tracks) 12 heads(tracks) can be allocated to
;	one, two, or three additional drives: one with 1-12 heads(tracks), two
;	with 1-8 and 1-4 heads(tracks), or three with 1-4 heads/(tracks) each.
;
;	  These 4 FPGA hardware 'ports' are then connected by external jumpers
;	to specific MFM drive select signal pins.  Each 'port' has independent
;	'seek complete' and 'track 0' status bits which	makes each 'port' look
;	like an independent MFM disk to the MFM controller.
;
;	  The 'seek time' is determined by the speed at which data can be read
;	from the backing ATA drive.  Each head(track) requires approximately
;	1.75/2.6 ms. (MFM/RLL) to read (via high speed DMA transfer of 41/62
;	blocks).  Thus the 'seek time' for a 4 head(track) drive is 7/10.4 ms.
;	whereas the 'seek time' for a 16 head(track) drive is 28/41.6 ms.
;	This may seem like a large time, however the host read time for a
;	head(track) is much larger because of the normal interleave factors
;	of 3-7.  the interleave factor means that to read just one full
;	head(track) may require 3-6 revolutions of the emulated
;	drive which corresponds to 50-100 ms.  So to read the data from a
;	4 head(track) drive requires 200-400 ms. or a 16 head(track) drive
;	800-1600 ms.
;
;	  In addition the head(track) cache is double buffered, this means that
;	when a new cylinder is accessed it is read into a second cache buffer
;	which is accessed by the host MFM controller and the first buffer is
;	checked for any MFM head(track) writes and the data is written back to
;	the ATA drive in the background.  A write to any part of a head(track)
;	data requires that the whole head(track) data be written.
;
;	  The system maintains a timer which periodically checks if any
;	head(track) has been written to and saves this data to the ATA
;	drive.  The timeout period is 500 ms. following the last active
;	cylinder read.
;
;****************************************************************************

.ifdef _mfmide
	.list	(!,src)
;	mfmide.asm      Globals                 Defined
	.nlist

	.mfmide.globals	0
.else
	.list
	.title	MFM And IDE Drive Access

	.module	MFMIDE

	.mfmide.globals	1

.ifne	mfm$ide
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
	.define	_btcs
	.define	_timers
	.define	_mondeb51
	.define	_dskcfg

	.list	(!)	; This Inhibits The Include File Pagination
	.include "macros.asm"
	.list
	.list	(!)	; This Inhibits The Include File Pagination
	.include "mfm.asm"
	.list
	.list	(!)	; This Inhibits The Include File Pagination
	.include "btcs.asm"
	.list
	.list	(!)	; This Inhibits The Include File Pagination
	.include "timers.asm"
	.list
	.list	(!)	; This Inhibits The Include File Pagination
	.include "mondeb51.asm"
	.list
	.list	(!)	; This Inhibits The Include File Pagination
	.include "dskcfg.asm"
	.list
;
;****************************************************************************
;
	mfm.dr$set =: 0		; Special Drive Setup
;
;****************************************************************************

	.page
	.sbttl	Table Entries

;****************************************************************************
;

	; Command Table Entries

	.area	CmdTbl

	ljmp	pior
	ljmp	piow

	; Command List Entries 

	.area	CmdLst

	.ascii	/PIOR/		; PIO read sector
	.byte	cr
	.ascii	/PIOW/		; PIO write sector
	.byte	cr

	; Extended Help String Pointers

	.area	X_Ptrs

	.word	$pior
	.word	$piow

	; Extended Help Strings

	.area	X_Strs

$pior:
	.ascii	" PIOR N [<15:0> [<27:16>]]"
	.byte	cr,lf
	.ascii	"   Performs A Block Read Starting At"
	.byte	cr,lf
	.ascii	"   XData Address N (A Block Is 512 Bytes)"
	.byte	cr,lf
	.ascii	"   The Logical Block Address Is Specified"
	.byte	cr,lf
	.ascii	"   As Two Numbers <15:0> and <27:16>"
	.byte	cr,lf
        .ascii	"   The Default Value(s) Are 0"
	.byte	eot

$piow:
	.ascii	" PIOW N [<15:0> [<27:16>]]"
	.byte	cr,lf
	.ascii	"   Performs A Block Write Starting At"
	.byte	cr,lf
	.ascii	"   Xdata Address N (A Block Is 512 Bytes)"
	.byte	cr,lf
	.ascii	"   The Logical Block Address Is Specified"
	.byte	cr,lf
	.ascii	"   As Two Numbers <15:0> and <27:16>"
	.byte	cr,lf
        .ascii	"   The Default Value(s) Are 0"
	.byte	eot

;
;****************************************************************************

	.page
	.sbttl	Function Summary

;****************************************************************************
;
;	A Summary Of Functions
;
;	mfmide_init	- Startup Initialization
;
;	dr$ini		- Initialize IDE Drive
;	  wt$rdy	- Wait For Drive Ready State
;	  wt$drq	- Wait For Data Request State
;	  wt$irq	- Wait For Interrupt Request State
;	dr$set		- Set ATA DMA Mode 2 (Not Used)
;
;	rd$lbt		- Read Data Lo-Byte From IDE Drive (<@dreglo> => <a>)
;	rd$hbt		- Read Data Hi-Byte From IDE Drive (<@dreghi> => <a>)
;	rd$wrd		- Read Data Word From IDE Drive (<@dreghi><@dreglo> => <b,a>)
;
;	wt$lbt		- Write Data Lo-Byte To IDE Drive (<a> => <@dreglo>)
;	wt$hbt		- Write Data Hi-Byte To IDE Drive (<a> => <@dreghi>)
;	wt$wrd		- Write Data Word To IDE Drive (<b,a> => <@dreghi><@dreglo>)
;
;	rd$mbt		- Read Byte From External Memory (@<r1,r0> => <a>)
;	rd$mwd		- Read Word From External Memory (@<r1,r0> => <b,a>)
;
;	wt$mbt		- Write Byte To External Memory (<a> => @<r1,r0>)
;	wt$mwd		- Write Word To External Memory (<b,a> => @<r1,r0>)
;
;	pior		- Read Word By Programmed Request From ATA
;	piow		- Write Word By Programmed Request To ATA
;	  piorw		- PIO Read/Write Support
;	  pio$rd	- PIOR Support
;	  pio$wt	- PIOW Support
;	  pio$ld	- Load Address For PIOR/PIOW
;	  wt$pio	- During Waits Check For ^B Abort Character
;
;	dio$rd		- DMA IO Read
;	 rdque		- Build The Read Queue Element
;	dio$wt		- DMA IO Write
;	 wtque		- Copy Read Queue Element To Write Queue Element
;
;	 adque		- Prepare Process Addresses For rdque/wtque
;	 io$rw		- Initiate Disk IO With io$csh And io$lba Parameters
;	  io$err	- Optional Disk Error Reporting
;	  io$csh	- Load Cache Access DMA Address
;	  io$lba	- Compute Disk Access Logical Block Address
;	    muladd	- Multibyte Multiply/Add Function
;	    bytsum	- Multibyte Byte Sum Function
;	    getprt	- Compute Partition Address
;
;	Ex0Int		- Interrupt Driven MFM Port Cylinder Stepping
;	  q$put		- Puts An Item Into The IO Queue
;	  q$get		- Gets An Item From The IO Queue
;	  q$sts		- Returns Status of IO Queue
;	  que$io	- Function Processes IO Queue Elements
;
;	  wtbktm	- Reloads Writeback Timer Interval
;	  wrtbck	- Function Processes IO Writeback
;	    wt$bck	- wrtbck Helper Function
;
;	db$que		- A Debug Function: Builds Debug IO Queue Element
;	db$ide		- A Debug Function: Adds ATA Read/Write Calls To Debug IO Queue Element
;	t2$tsk		- A Debug Function: Performs Timer 2 Processes
;
;****************************************************************************

	.page
	.sbttl	Program Areas

;****************************************************************************
;
;	The ATA Drive Information Block
;
	.area	IOBlk

ideblk:	.blkb	512		; IDE Status Block

	; Parameters From Identify Drive Command Function
	; (2 * Word Number) + 1 Is Low Byte Of Word

	dr$cyl	=	ideblk + (2 * 1) + 1	; Cylinder Count
	dr$hd	=	ideblk + (2 * 3) + 1	; Head Count
	dr$sct	=	ideblk + (2 * 6) + 1	; Sector Count

	dr$frm	=	ideblk + (2 * 20) + 0	; Firmware Version (String)
	dr$mdl	=	ideblk + (2 * 23) + 0	; Drive Model Number (String)

	dr$lbl	=	ideblk + (2 * 60) + 0	; LBA Max Low Word
	dr$lbh	=	ideblk + (2 * 61) + 0	; LBA Max High Word
;
;****************************************************************************
;
;	The PIO Read and Write Buffers
;
ioblk1:	.blkb	512		; PIO Block 1
ioblk2:	.blkb	512		; PIO Block 2

;
;****************************************************************************
;
;	Bit Flags
;
	.area	Bits

dbg_dr$ini_aflg:	.blkb	1	; Drive Initialization Abort Enable Flag
dbg_dr$ini_rflg:	.blkb	1	; Drive Initialization Repeat On Error Enable Flag 
dbg_dr$ini_sflg:	.blkb	1	; Drive Initialization Status Enable Flag 

dbg_io$err_eflg:	.blkb	1	; Error Output Enable Flag

dbg_pio_aflg:		.blkb	1	; PIO R/W Wait Abort Flag

rq$act:		.blkb	1	; Read Queue Active
wq$act:		.blkb	1	; Write Queue Active

mfmerr:		.blkb	1	; A DMA Error

mfmbsy:		.blkb	1	; MFM Busy
mfmwbk:		.blkb	1	; MFM Write Back
mfmcpy:		.blkb	1	; MFM Copy In Progress
piobsy:		.blkb	1	; PIO Busy

cache.bnk:	.blkb	1	; Cache Bank State Flag
cache.wrt:	.blkb	1	; Cache R/W Flag (read=0 / write=1)
				; A Cache Read Implies A DMA Write
				; A Cache Write Implies A DMA Read

mfmtyp:		.blkb	1	; MFM => 0 / RLL => 1

;
;****************************************************************************
;
;	The Data Area
;

	.area	Data

	; Working Data

mfmidx:	.blkb	1		; MFM Active Port Index
mfmbnk:	.blkb	1		; MFM Cache Bank Select
mfmprt:	.blkb	1		; MFM Drive Partition
mfmcyl:	.blkb	2		; MFM Cylinder Number (0-4095)
mfmtrk:	.blkb	1		; MFM Track Number (0-15)
mfmopt:	.blkb	1		; MFM Options

prtlba:	.blkb	3		; Base LBA Of Selected Partition <31:00>
prtlsb:	.blkb	1		; LSB Of Selected Partition <27:00> (128 GB)

dmalba:	.blkb	3		; Logical Block Address For DMA Transfer <31:00>
dmalsb:	.blkb	1		; LSB Of Logical Block Address <27:00> (128 GB)

	; Programmed Read / Write Logical Block Address

piolba:	.blkb	4		; PIO Sector Transfer Address <27:0>
pioadd:	.blkb	2		; PIO Transfer Address

;
;****************************************************************************
;
;	Miscelaneous Defined Constants
;
	MFM.tfrsiz =	41	; 512 Byte Sectors Holding At Least 166,667 Bits
	RLL.tfrsiz =	62	; 512 Byte Sectors Holding At Least 250,000 Bits

	trkblk =	64	; 512 Byte Sectors For LBA Translation

	hdsmax =	16	; Maximum Number Of Heads
	cylmax =	4096	; Maximum Number Of Cylinders

	prtoff =	0x01	; Base Offset (= prtoff * 256)
        prtsiz =	0x40	; Partition Size (= prtsiz * 65536)

	pr$siz =	8	; Port Parameter Block Size

	rwqsiz =	16	; Read/Write Queue Size
	rwdsiz =	24	; Read/Write/Debug Queue Size

;
;****************************************************************************

	.page
	.sbttl	Port Configuration Parameters

;****************************************************************************
;
;	The Port Configuration Parameters
;

	.area	Bits

	; Port Enabled Flags

pr1.mnt:	.blkb	1	; Port 1 Mounted
pr2.mnt:	.blkb	1	; Port 2 Mounted
pr3.mnt:	.blkb	1	; Port 3 Mounted
pr4.mnt:	.blkb	1	; Port 4 Mounted

	; Port Track 0 Flags

pr1tk0:		.blkb	1 	; Port 1 Track0 Flag
pr2tk0:		.blkb	1 	; Port 2 Track0 Flag 
pr3tk0:		.blkb	1 	; Port 3 Track0 Flag 
pr4tk0:		.blkb	1 	; Port 4 Track0 Flag 


	.area	Data

	; MFM Port Stepping Status

pr$stp:	.blkb	1		; Ports Stepping Status
pr$chg:	.blkb	1		; Ports Stepping Changes

	; Configured Port Tables
pr$tbl:

	; Port Select 1
pr1tbl:
pr1bnk:	.blkb	1		; Port 1 Cache Bank Select
pr1prt:	.blkb	1		; Port 1 Partition Number
pr1cyl:	.blkb	2		; Port 1 Cylinder
pr1tpc:	.blkb	1		; Port 1 Tracks / Cylinder
pr1opt:	.blkb	1		; Port 1 Options
pr1max:	.blkb	2		; Port 1 Cylinder Maximum

	; Port Select 2
pr2tbl:
pr2bnk:	.blkb	1		; Port 2 Cache Bank Select
pr2prt:	.blkb	1		; Port 2 Partition Number
pr2cyl:	.blkb	2		; Port 2 Cylinder
pr2tpc:	.blkb	1		; Port 2 Tracks / Cylinder
pr2opt:	.blkb	1		; Port 2 Options
pr2max:	.blkb	2		; Port 2 Cylinder Maximum

	; Port Select 3
pr3tbl:
pr3bnk:	.blkb	1		; Drive 2 Cache Bank Select
pr3prt:	.blkb	1		; Drive 2 Partition Number
pr3cyl:	.blkb	2		; Drive 2 Cylinder
pr3tpc:	.blkb	1		; Drive 2 Tracks / Cylinder
pr3opt:	.blkb	1		; Drive 2 Options
pr3max:	.blkb	2		; Drive 2 Cylinder Maximum

	; Port Select 4
pr4tbl:
pr4bnk:	.blkb	1		; Drive 3 Cache Bank Select
pr4prt:	.blkb	1		; Drive 3 Partition Number
pr4cyl:	.blkb	2		; Drive 3 Cylinder
pr4tpc:	.blkb	1		; Drive 3 Tracks / Cylinder
pr4opt:	.blkb	1		; Drive 3 Options
pr4max:	.blkb	2		; Drive 3 Cylinder Maximum

	.error	pr$siz - (pr2tbl - pr1tbl)	; Invalid pr$siz Value


	.area	IData

	; Port Bit Masks

pr$msk:
pr1msk:	.blkb	2		; Port 1 Bit Mask
pr2msk:	.blkb	2		; Port 2 Bit Mask
pr3msk:	.blkb	2		; Port 3 Bit Mask
pr4msk:	.blkb	2		; Port 4 Bit Mask

;
;****************************************************************************

	.page
	.sbttl	Port Queue Block Parameters

;****************************************************************************
;
;	The Port Queue Block Parameters
;

	.area	Data

	; Port Queue

q$geti:	.blkb	1		; Queue Get Index
q$puti:	.blkb	1		; Queue Put Index

	qblksz = 0x08		; !!! Must Be A Power of 2 !!!

q$blk:	.blkb	qblksz		; RW Queue Buffer

	; Each port (1 - 4) has an independent
	; read/write Queue Block.  Each Queue Block
	; contains all the parameters connected with
	; that particula port.  The parameters control
	; the MFM port access to the internal cylinder
	; memory cache and the DMA read/write to the
	; IDE interface. 

	.area	IData

qu$tbl:				; The Read/Write/Debug Queue Blocks

	; Port 1 IO Queue Blocks

pr1$qu:
pr1$rd:	.blkb	1		; Cache Bank
	.blkb	1		; Partition Number
	.blkb	2		; Cylinder
	.blkb	1		; Tracks / Cylinder
	.blkb	1		; Options
	.blkb	2		; Tracks Touched Bytes
	rd$siz = . - pr1$rd	; Read Queue Size

pr1$wt:	.blkb	1		; Cache Bank
	.blkb	1		; Partition Number
	.blkb	2		; Cylinder
	.blkb	1		; Tracks / Cylinder
	.blkb	1		; Options
	.blkb	2		; Tracks Written Bytes
	wt$siz	= . - pr1$wt	; Read Queue Size
	
	.error	rwqsiz - (rd$siz + wt$siz)		; Invalid rwqsiz Value
	;
	; The Offsets
	;
	rq.bnk	=	0	; prn$rd Offsets For The Read Queue
	rq.prt	=	1
	rq.cyl	=	2
	rq.trk	=	4
	rq.opt	=	5
	rq.tch	=	6

	wq.bnk	=	0	; prn$wt Offsets For The Write Queue
	wq.prt	=	1
	wq.cyl	=	2
	wq.trk	=	4
	wq.opt	=	5
	wq.twt	=	6

.ifne	mfm$dbg
pr1$db:	.blkb	8		; Updating Addresses
	db$siz	= . - pr1$db	; Debug Queue Size

	.error	rwdsiz - (rd$siz + wt$siz + db$siz)	; Invalid rwdsiz Value
	;
	; The Offsets
	;
	db.tch	=	6	; (.tch)  Updating Tracks Touched Offset
	db.ext	=	16	; (.ext)  Updateing Extra Offset
	db.iwt	=	18	; (.idw)  Updating Tracks Written to IDE Offset
	db.ird	=	20	; (.idr)  Updating Tracks Read  from IDE Offset
	db.skt	=	22	; (.skt)  Updating Seek Time Offset
.endif

	qu$siz	= . - pr1$rd	; Total Port Queue Block Size

	; Port 2 IO Queue Blocks

pr2$qu:
pr2$rd:	.blkb	8
pr2$wt:	.blkb	8

.ifne	mfm$dbg
pr2$db:	.blkb	8
.endif

	; Port 3 IO Queue Blocks

pr3$qu:
pr3$rd:	.blkb	8
pr3$wt:	.blkb	8

.ifne	mfm$dbg
pr3$db:	.blkb	8
.endif

	; Port 4 IO Queue Blocks

pr4$qu:
pr4$rd:	.blkb	8
pr4$wt:	.blkb	8

.ifne	mfm$dbg
pr4$db:	.blkb	8
.endif


.ifne	mfm$dbg
	rdqblk = ioblk1+0	; Read Queue Base Address
	wtqblk = ioblk1+8	; Write Queue Base Address
	dbgblk = ioblk1+16	; Debug Queue Block Address
	  db$prm.rop	= rdqblk + 5	; read  - option (port #)
	  db$prm.tch	= rdqblk + 6	; read  - tracks touched
	  db$prm.wop	= wtqblk + 5	; write - option (port #)
	  db$prm.twt	= wtqblk + 6	; write - MFM tracks written
	  db$prm.ext	= dbgblk + 0	; parameter - extra (time stamp)
	  db$prm.iwt	= dbgblk + 2	; write - MFM track written to IDE
	  db$prm.ird	= dbgblk + 4	; read  - MFM track read from IDE
	  db$prm.skt	= dbgblk + 6	; read  - Elapsed time to read MFM track from IDE
.endif

;
;****************************************************************************

	.page
	.sbttl	mfm$dbg Debugging Parameters

;****************************************************************************
;
;	The Debugging Parameters
;

.ifne	mfm$dbg

	.area	Bits

	; Debugging Bit Flags

Ex0$TstA:	.blkb	1	; Ex0Int0 Test A Flag
Ex0$xbtA:	.blkb	1	; Ex0Int0 Test A Bit Select
Ex0$TstB:	.blkb	1	; Ex0Int0 Test B Flag
Ex0$xbtB:	.blkb	1	; Ex0Int0 Test B Bit Select

Wbk$TstA:	.blkb	1	; Writeback Test A Flag
Wbk$xbtA:	.blkb	1	; Writeback Test A Bit Select

q$enbl:		.blkb	1	; Enable Read/Write Queue Buffer
q$seek:		.blkb	1	; Seek Time Flag

i$enbl:		.blkb	1	; Ex0 Interrupt Logging


	.area	LData

	; Debug Counters

bsycnt:	.blkb	2		; Ex0Int mfmbsy busy counter
wbkcnt:	.blkb	2		; Ex0Int wrtbck busy counter
cpycnt:	.blkb	2		; Ex0Int mfmcpy busy counter
rdycnt:	.blkb	2		; Ex0Int rdycnt process counter
nulcnt:	.blkb	2		; Ex0Int ?????? NULL counter
dupcnt:	.blkb	2		; Ex0Int duplct buffer counter

	; Read/Write/Debug Queue Block Parameters

qb$blk:	.blkb	1		; Read/Write/Debug Queue Block Number
qb$scn:	.blkb	1		; Debug Scanning Block Number


	.area	Data

	; Sequence Logging

i$msb:	.blkb	1		; Element Index (MSB)
i$lsb:	.blkb	1		; Element Index (LSB)

j$msb:	.blkb	1		; Read Out Element Index (MSB)
j$lsb:	.blkb	1		; Read Out Element Index (LSB)
j$cnt:	.blkb	1		; Read Out Element Counter

	; Touch Processing

hdport:	.blkb	1		; Head(Track) / Port State

.endif
;
;****************************************************************************

	.page
	.sbttl	mfm$dbg Debugging Macros

;****************************************************************************
;
;  The Debugging Macros

	.macro	.dbg	arg
	  .list
	  .ifne arg
	    .debug =: mfm$dbg
	  .else
	    .debug =: 0
	  .endif
	.endm
 
;  
;****************************************************************************
;
	.macro	.db$que	?arg1
	  .list
	  .dbg	dbg.db$que
	  .ifne .debug
	    .list	(!,err,loc,bin,cyc,eqt,lin,src,mel)
	  jnb	q$enbl,arg1
	  lcall	db$que
arg1:
	   .nlist
	  .endif
	.endm

;  
;****************************************************************************
;
	.macro	.db$ide	?arg1
	  .nlist
	  .dbg	dbg.db$ide
	  .ifne .debug
	    .list	(!,err,loc,bin,cyc,eqt,lin,src,mel)
	  jnb	q$enbl,arg1
	  lcall	db$ide
arg1:
	    .nlist
	  .endif
	.endm

;  
;****************************************************************************
;
	.macro	.setb	arg1
	  .nlist
	  .ifne mfm$dbg
	    .list	(!,err,loc,bin,cyc,eqt,lin,src,mel)
	  setb	arg1
	    .nlist
	  .endif
	.endm

	.macro	.clrb	arg1
	  .nlist
	  .ifne mfm$dbg
	    .list	(!,err,loc,bin,cyc,eqt,lin,src,mel)
	  clr	arg1
	    .nlist
	  .endif
	.endm

;  
;****************************************************************************
;
	.macro	.incw_rx	dst$,ppr$,ppa$
	  .nlist
	  .dbg	dbg.db$cnt
	  .ifne .debug
	    .iifnb ppa$,	.push	a
	    .iifnb ppr$,	.push	r1
	    .ifnb  dst$
	      .list	(!,err,loc,bin,cyc,eqt,lin,src,mel)
	  mov	r1,#dst$
	      .nlist
	    .endif
	    .list	(!,err,loc,bin,cyc,eqt,lin,src,mel)
	  lcall	incw_rx
	    .nlist
	    .iifnb ppr$,	.pop	r1
	    .iifnb ppa$,	.pop	a
	  .endif
	.endm

	.macro	.i$cnt	?arg1
	  .nlist
	  .dbg	dbg.db$cnt
	  .ifne .debug
	    .list	(!,err,loc,bin,cyc,eqt,lin,src,mel)
	  push	a
	  push	r1
	  mov	a,pr$chg		; the event
	  mov	r1,#bsycnt		; update bsycnt
	  jb	mfmbsy,arg1
	  mov	r1,#wbkcnt		; update wbkcnt
	  jb	mfmwbk,arg1
	  mov	r1,#cpycnt		; update cpycnt
	  jb	mfmcpy,arg1
	  mov	r1,#rdycnt		; update rdycnt
	  jnz	arg1
	  mov	r1,#nulcnt		; update nulcnt
arg1:	  lcall	incw_rx
	  pop	r1
	  pop	a
	    .nlist
	  .endif
	.endm

	.macro	.i$dup
	  .nlist
	  .dbg	dbg.db$cnt
	  .ifne .debug
	    .list	(!,err,loc,bin,cyc,eqt,lin,src,mel)
	  mov	r1,#dupcnt		; update dupcnt
	  lcall	incw_rx
	    .nlist
	  .endif
	.endm

.dbg	dbg.db$cnt
.ifne .debug

	.area	Debug

incw_rx:
	inc	r1
	movx	a,@r1
	inc	a
	movx	@r1,a
	dec	r1
	jnz	1$
	movx	a,@r1
	inc	a
	movx	@r1,a
1$:	ret
.endif

;  
;****************************************************************************
;
	.macro	.i$enbl	sts1,sts2,?arg1,?arg2,?arg3,?arg4,?arg5
	  .nlist
	  .dbg	dbg.db$chg
	  .ifne .debug
	    .list	(!,err,loc,bin,cyc,eqt,lin,src,mel)
	  jnb	i$enbl,arg5
	  mov	dph,i$msb
	  mov	dpl,i$lsb
	  mov	a,sts1
	  movx	@dptr,a
	  inc	dptr
	    .nlist
	    t$m$p =: 0
	    .iifidn	sts1,#0xFF	t$m$p =: t$m$p + 1
	    .iifidn	sts1,#0xff	t$m$p =: t$m$p + 1
	    .iifidn	sts2,#0xFF	t$m$p =: t$m$p + 1
	    .iifidn	sts2,#0xff	t$m$p =: t$m$p + 1
	    .ifne	t$m$p-2
	      .list	(!,err,loc,bin,cyc,eqt,lin,src,mel)
	  mov	a,sts2
	  rrc	a
	  mov	a,sts2+1
	  rrc	a
	  movx	@dptr,a
	  inc	dptr
	      .nlist
	    .else
	      .list	(!,err,loc,bin,cyc,eqt,lin,src,mel)
	  mov	a,sts2
	  jnb	mfmbsy,arg1
	  anl	a,#~1
arg1:	  jnb	mfmwbk,arg2
	  anl	a,#~2
arg2:	  jnb	mfmcpy,arg3
	  anl	a,#~4
arg3:	  movx	@dptr,a
	  inc	dptr
	      .nlist
	    .endif
	    .list	(!,err,loc,bin,cyc,eqt,lin,src,mel)
	  mov	a,dph
	  cjne	a,#>0x1000,arg4
	  mov	dph,#>m2_blk
	  mov	dpl,#<m2_blk
arg4:	  mov	i$msb,dph
	  mov	i$lsb,dpl
arg5:
	    .nlist
	  .endif
	.endm

;  
;****************************************************************************
;
	.macro	.Ex0$TstA.setb	?arg1,?arg2
	  .nlist
	  .dbg	dbg.Ex0$TstA
	  .ifne .debug
	    .list	(!,err,loc,bin,cyc,eqt,lin,src,mel)
	  jnb	Ex0$TstA,arg2
	  jb	Ex0$xbtA,arg1
	  lcall	x1setb
	  sjmp	arg2
arg1:	  lcall	x2setb
arg2:
	   .nlist
	  .endif
	.endm

	.macro	.Ex0$TstA.clrb	?arg1,?arg2
	  .nlist
	  .dbg	dbg.Ex0$TstA
	  .ifne .debug
	    .list	(!,err,loc,bin,cyc,eqt,lin,src,mel)
	  jnb	Ex0$TstA,arg2
	  jb	Ex0$xbtA,arg1
	  lcall	x1clrb
	  sjmp	arg2
arg1:	  lcall	x2clrb
arg2:
	   .nlist
	  .endif
	.endm

;  
;****************************************************************************
;
	.macro	.Ex0$TstB.setb	?arg1,?arg2
	  .nlist
	  .dbg	dbg.Ex0$TstB
	  .ifne .debug
	    .list	(!,err,loc,bin,cyc,eqt,lin,src,mel)
	  jnb	Ex0$TstB,arg2
	  jb	Ex0$xbtB,arg1
	  lcall	x1setb
	  sjmp	arg2
arg1:	  lcall	x2setb
arg2:
	   .nlist
	  .endif
	.endm

	.macro	.Ex0$TstB.clrb	?arg1,?arg2
	  .nlist
	  .dbg	dbg.Ex0$TstB
	  .ifne .debug
	    .list	(!,err,loc,bin,cyc,eqt,lin,src,mel)
	  jnb	Ex0$TstB,arg2
	  jb	Ex0$xbtB,arg1
	  lcall	x1clrb
	  sjmp	arg2
arg1:	  lcall	x2clrb
arg2:
	   .nlist
	  .endif
	.endm

;  
;****************************************************************************
;
	.macro	.Ex0$Tst.LoopCount	?arg1,?arg2
	  .nlist
	  .dbg	dbg.Ex0$TstB
	  .ifne .debug
	    .list	(!,err,loc,bin,cyc,eqt,lin,src,mel)
	  jnb	Ex0$TstB,arg1
	  mov	b,#36			; TstB Enabled Loop Count
	  sjmp	arg2
arg1:	  mov	b,#56			; TstB Disabled Loop Count
arg2:
	    .nlist
	  .else
	    .list	(!,err,loc,bin,cyc,eqt,lin,src,mel)
	  mov	b,#62			; Reset Loop Count
	    .nlist
	  .endif
	.endm

;  
;****************************************************************************
;
	.macro	.Wbk$TstA.setb	?arg1,?arg2
	  .nlist
	  .dbg	dbg.Wbk$TstA
	  .ifne .debug
	    .list	(!,err,loc,bin,cyc,eqt,lin,src,mel)
	  jnb	Wbk$TstA,arg2
	  jb	Wbk$xbtA,arg1
	  lcall	x1setb
	  sjmp	arg2
arg1:	  lcall	x2setb
arg2:
	   .nlist
	  .endif
	.endm

	.macro	.Wbk$TstA.clrb	?arg1,?arg2
	  .nlist
	  .dbg	dbg.Wbk$TstA
	  .ifne .debug
	    .list	(!,err,loc,bin,cyc,eqt,lin,src,mel)
	  jnb	Wbk$TstA,arg2
	  jb	Wbk$xbtA,arg1
	  lcall	x1clrb
	  sjmp	arg2
arg1:	  lcall	x2clrb
arg2:
	   .nlist
	  .endif
	.endm

;  
;****************************************************************************
;
	.macro	.dr$set
	  .nlist
	  .ifne mfm.dr$set
	    .list	(!,err,loc,bin,cyc,eqt,lin,src,mel)
	  .lb_x	a,ideblk+(2*63+0)	; selected DMA mode
	  jb	a.2,7$			; mode 2 - finished
	  lcall	dr$set
	  jc	7$			; abort -
	  jnz	8$			; error -
	    .nlist
	  .endif
	.endm

;  
;****************************************************************************
;
	.macro	.bgn_q$seek	?arg1
	  .nlist
	  .dbg	dbg.db$skt
	  .ifne .debug
	    .list	(!,err,loc,bin,cyc,eqt,lin,src,mel)
	  jnb	q$enbl,arg1	; skip if not enabled
	  setb	q$seek		; seek time in progress
	  clr	et2		; disable timer 2
	  push	t2$msb		; save current ticks
	  push	t2$lsb
	  setb	et2		; enable timer 2
arg1:
	    .nlist
	  .endif
	.endm

	.macro	.end_q$seek	?arg1
	  .nlist
	  .dbg	dbg.db$skt
	  .ifne .debug
	    .list	(!,err,loc,bin,cyc,eqt,lin,src,mel)
	  jnb	q$seek,arg1	; skip if not enabled
	  mov	a,mfmidx	; get port number
	  mov	b,#qu$siz	; compute address of address table
	  mul	ab
	  add	a,#qu$tbl+db.skt
	  mov	r0,a		; queue block address
	  mov	dph,@r0		; parameter address
	  inc	r0
	  mov	dpl,@r0
	  clr	et2		; disable timer 2
	  clr	c		; compute elapsed ticks
	  pop	b
	  mov	a,t2$lsb
	  subb	a,b
	  movx	@dptr,a		; save LSB of computed seek time
	  inc	dptr
	  pop	b
	  mov	a,t2$msb
	  subb	a,b
	  movx	@dptr,a		; save MSB of computed seek time
	  setb	et2		; enable timer 2
	  clr	q$seek		; end of seek
arg1:
	    .nlist
	  .endif
	.endm

;  
;****************************************************************************

	.page
	.sbttl	Debug Functions

;****************************************************************************
;
;  rd$que / wt$que Elements
;
;	  These functions copy the read/write queue elements
;	into a circular buffer to allow examination of the
;	read/write parameters.
;
;	  The circular buffer contains 64 24-byte entries
;	and occupies ioblk1, ioblk2, and m1_blk.
;
	.assume	rwdsiz - 24	; Wrong Block Size

	;rdQ:	.blkb	1	; Cache Bank
	;	.blkb	1	; Partition Number
	;	.blkb	2	; Cylinder
	;	.blkb	1	; Tracks / Cylinder
	;	.blkb	1	; Options
	;tch:	.blkb	2	; Tracks Touched Bytes
	;
	; NOTE:	The wtQ elements come from the previous
	;	rdQ operation with the Tracks Written bytes
	;	loaded from the MFM trkwt0/trkwt1 bytes.
	;
	;wtQ:	.blkb	1	; Cache Bank
	;	.blkb	1	; Partition Number
	;	.blkb	2	; Cylinder
	;	.blkb	1	; Tracks / Cylinder
	;	.blkb	1	; Options
	;	.blkb	2	; Tracks Written Bytes
	;
	; NOTE:	These extra diagnostic parameters are
	;	derived from internal processing of the
	;	read and write routines.
	;
	;.ext:	.blkb	2	; Extra Word
	;.iwt:	.blkb	2	; Tracks Written to IDE
	;.ird:	.blkb	2	; Tracks Read  from IDE
	;.skt:	.blkb	2	; Read Seek Time
	;
	; At the completion of building the write and read
	; queue blocks the blocks are copied into the debug
	; queue block array.  This process also includes
	; generating addresses of parameters updated while
	; the queue block is being processed: Tracks Touched,
	; Tracks Written, Tracks Read, Seek Time, and an
	; Extra slot.
	;

.ifne	mfm$dbg

	.area	Debug

db$que:	mov	r0,#qb$blk		; load block number
	movx	a,@r0
	inc	a
	anl	a,#0x3F			; circular buffer with 64 entries
	movx	@r0,a			; save block number
	mov	b,#qu$siz		; queue block size
	mul	ab			; compute offset <b:a>
	add	a,#<ioblk1		; add offset to base address
	mov	dpl,a			; uses ioblk1, ioblk2, and m1_blk (1536 bytes)
	mov	a,b
	addc	a,#>ioblk1
	mov	dph,a			; dptr has address of block
	;
	mov	a,mfmidx
	mov	b,#qu$siz
	mul	ab
	add	a,#qu$tbl
	mov	r0,a			; address of Port Read/Write/Debug Queue

	; Fill Debug rd$que

	mov	b,#rd$siz-2		; length of rd$que - 2
1$:	mov	a,@r0			; copy queue elements
	movx	@dptr,a		        ; .bnk, .prt,
	inc	r0			; .cyl+0, .cyl+1, .trk, .opt
	inc	dptr
	djnz	b,1$
	;
	mov	@r0,dph			; save db.tch address
	inc	r0
	mov	@r0,dpl
	inc	r0
	;
	clr	a			; clear last 2 bytes of rd$que
	movx	@dptr,a		        ; .tch+0, and .tch+1
	inc	dptr
	movx	@dptr,a
	inc	dptr

	; Fill Debug wt$que

	mov	b,#wt$siz		; length of wt$que
2$:	mov	a,@r0			; copy queue elements
	movx	@dptr,a			; .bnk, .prt
	inc	r0			; .cyl+0, .cyl+1, .trk, .opt, .trkwt0, .trkwt1
	inc	dptr
	djnz	b,2$

	; Time Stamp The Queue Block

	mov	@r0,dph		        ; set debug addresses
	inc	r0			;   1 - Updating Extra Address
	mov	@r0,dpl
	inc	r0
	clr	et2			; disable timer 2
	mov	a,t2$lsb		; copy time stamp - NOTE <LSB:MSB> order
	movx	@dptr,a			; into the extra parameter
	inc	dptr
	mov	a,t2$msb
	movx	@dptr,a
	inc	dptr
	setb	et2			; enable timer 2

	; Last Of The Debug Addresses

	mov	b,#3		        ; set debug addresses
	clr	a
4$:	mov	@r0,dph			;   2 - Updating IDE Tracks Written Address
	inc	r0			;   3 - Updating IDE Tracks Read Address
	mov	@r0,dpl			;   4 - Updating Seek Time Address
	inc	r0
	movx	@dptr,a			; clear bytes
	inc	dptr
	movx	@dptr,a
	inc	dptr
	djnz	b,4$

	ret

;
;****************************************************************************
;
;	Set The 'io$rw' Tracks
;
db$ide:	mov	a,mfmtrk
1$:	anl	a,#0x07		; mask track select
	inc	a		; 0-7 => 1-8
	mov	b,a		; counter
	clr	a
	setb	c
2$:	rlc	a		; position bit
	djnz	b,2$
	push	a		; save track bit
	;
	; Load Address Of Debug Parameter
	mov	a,mfmidx	; compute table offset
	anl	a,#3		; mask for safety
	mov	b,#qu$siz
	mul	ab
	jb	cache.wrt,3$
	add	a,#qu$tbl+db.iwt ; io$rw - Cache read / IDE write
	sjmp	4$
3$:	add	a,#qu$tbl+db.ird ; io$rw - Cache write / IDE read
;	sjmp	4$
4$:	mov	r0,a
	mov	dph,@r0
	inc	r0
	mov	dpl,@r0
	;
	mov	a,mfmtrk
	jnb	a.3,5$		; tracks 0-7 or
	inc	dptr		; tracks 8-15

5$:	movx	a,@dptr		; update track information
	pop	b		; bit position
	orl	a,b		
	movx	@dptr,a

	ret
;
;****************************************************************************
;
;	The Timer 2 Tasks
;
; Routines entered with psw, dph, dpl, and a saved
;
;****************************************************************************
;
;	Increment Time Stamp Counter
;
t2$tsk:	jb	q$enbl,2$	; entry point for timer tasks
	ljmp	t2$xit		; exit it not enabled

1$:	setb	tm2ret		; use regular return
	reti			; fake interrupt return

2$:     lcall	1$		; do the fake return
	push	b		; need more registers
	push	r0		; fall through to task(s)

;	ljmp	t2$end
;
;****************************************************************************
;
;	Set The 'MFM Touched Tracks'
;
.ifne dbg.db$tch
up$tch:	mov	a,t2$lsb	; look every 4th time
	anl	a,#0x03
	jnz	4$		; wait for MOD 4 == 0
	.lb_x	a,actprt	; actprt
	jnb	ac_actv,4$	; actv ?
	jnb	ac_skdn,4$	; skdn ?
	;
	anl	a,#0x0F		; mask port bits
	mov	b,a		; save
	.lb_x	a,hdsts		; head(track)
	anl	a,#0x0F		; mask head(track
	swap	a		; upper nibble is head(track)
	orl	a,b		; upper head(track) / lower port bits
	mov	b,a		; save
	mov	a,hdport	; previous hdport
	mov	hdport,b	; current hdport
	cjne	a,b,4$		; require the same
	;
	anl	a,#0x0F		; mask port bits
	mov	dptr,#2$	; translation table
	movc	a,@a+dptr	; get port number
	jb	a.7,4$		; invalid port - exit
	push	b		; save hdport
	mov	b,#qu$siz	; compute address of address table
	mul	ab
	add	a,#qu$tbl+db.tch
	mov	r0,a		; address of port queue block .tch
	pop	a		; pop hdport
	mov	dph,@r0
	inc	r0
	mov	dpl,@r0
	push	dpl		; save address
	push	dph
	;
	swap	a		; swap head(track) to lower nibble
	mov	b,a		; save
	anl	a,#0x07		; mask track select
	mov	dptr,#3$	; bit table
	movc	a,@a+dptr
	pop	dph
	pop	dpl		; .tch address
	push	a		; push track bit
	jnb	b.3,1$		; track 0-7 or
	inc	dptr		; track 8-15
1$:	movx	a,@dptr
	pop	b		; pop track bit
	orl	a,b		; or bit with track bits
	movx	@dptr,a
	;
	mov	hdport,#0	; prepare for next
	sjmp	4$

2$:	.byte	0x80,	0x00,	0x01,	0x80,	0x02,	0x80,	0x80,	0x80
	.byte	0x03,	0x80,	0x80,	0x80,	0x80,	0x80,	0x80,	0x80

3$:	.byte	0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80

4$:				; fall through to next task
.endif
;
;****************************************************************************
;
;	End Of Timer 2 Functions
;
	pop	r0		; restore extra registers
	pop	b

t2$xit:	mov	a,#1		; check again quickly
	mov	dptr,#t2$tsk
	lcall	st$tm2		; timer 2 - 1 tick
	ret
	
.endif	; mfm$dbg
;
;****************************************************************************

	.page
	.sbttl	IDE Drive Status Routines

	.area	MFMIDE

;****************************************************************************
;
;	Wait For The IDE Drive Ready State
;
wt$rdy:	lcall	wchdog			; hit the watch dog timer

	clr	a
	jnb	dbg_dr$ini_aflg,1$
	setb	c
	jbc	wt$brk,2$		; abort?

1$:	.lb_x	a,stsreg
	jnb	st_rdy,wt$rdy
	jb	st_bsy,wt$rdy
	anl	a,#st.err		; a != 0 on error
	clr	c

2$:	ret
;
;****************************************************************************
;
;	Wait For The IDE Drive DRQ State
;
wt$drq:	lcall	wchdog			; hit the watch dog timer

	clr	a
	jnb	dbg_dr$ini_aflg,1$
	setb	c
	jbc	wt$brk,3$		; abort?

1$:	.lb_x	a,stsreg
	jb	st_bsy,wt$drq		; wait for BSY to be clear
	jb	st_err,2$		; exit on error
	jnb	st_drq,wt$drq		; wait for DRQ to be set
2$:	anl	a,#st.err		; a != 0 on error
	clr	c

3$:	ret
;
;****************************************************************************
;
;	Wait For The IDE Drive INTRQ State
;
wt$irq:	lcall	wchdog			; hit the watch dog timer

	clr	a
	jnb	dbg_dr$ini_aflg,1$
	setb	c
	jbc	wt$brk,2$		; abort?

1$:	.lb_x	a,dmasts		; wait for IRQ to set
	jnb	dm_irq,wt$irq
	clr	c

2$:	.lb_x	a,stsreg		; clear IRQ / check status
	anl	a,#st.err		; a != 0 on error
	ret
;
;****************************************************************************

	.page
	.sbttl	Byte/Word Read From IDE Drive

;****************************************************************************
;
;	Read The Lo Data Byte From The IDE Drive Into A
;
rd$lbt:	mov	dptr,#dreglo		; address of lo byte register
	movx	a,@dptr
	ret
;
;****************************************************************************
;
;	Read The Hi Data Byte From The IDE Drive Into A
;
rd$hbt:	mov	dptr,#dreghi		; address of hi byte register
	movx	a,@dptr
	ret
;
;****************************************************************************
;
;	Read A Data Word From The IDE Drive
;	Returns Hi-Byte In A / Lo-Byte In B
;
rd$wrd:	mov	dptr,#dreglo		; address of lo byte register
	movx	a,@dptr			; read lo byte and latch hi byte
	mov	b,a
	mov	dptr,#dreghi		; address of hi byte register
	movx	a,@dptr
	ret
;
;****************************************************************************

	.page
	.sbttl	Byte/Word Write To IDE Drive

;****************************************************************************
;
;	Write A To The IE Drive Lo Byte
;
wt$lbt:	mov	dptr,#dreglo		; address of lo byte register
	movx	@dptr,a
	ret
;
;****************************************************************************
;
;	Write A To The Hi Byte Latch
;
wt$hbt:	mov	dptr,#dreghi		; address of hi byte register
	movx	@dptr,a
	ret
;
;****************************************************************************
;
;	Write A Data Word To The IDE Drive
;	Stores Hi-Byte From A / Lo-Byte From B
;
wt$wrd:	mov	dptr,#dreghi		; address of hi byte register
	movx	@dptr,a			; write hi byte register
	xch	a,b
	mov	dptr,#dreglo		; address of lo byte register
	movx	@dptr,a			; write LO/HI bytes as a word
	xch	a,b			; restore <A:B>
	ret
;
;****************************************************************************

	.page
	.sbttl	Byte/Word Read From Data Memory

;****************************************************************************
;
;	Returns Byte In A
;
rd$mbt:	mov	dpl,r0			; load memory address
	mov	dph,r1
	movx	a,@dptr			; load byte
	inc	dptr			; increment memory address
	mov	r0,dpl			; save memory address
	mov	r1,dph
	ret
;
;****************************************************************************
;
;	Read Word Data From Memory
;	Returns HI-Byte In A / LO-Byte In B
;
rd$mwd:	mov	dpl,r0			; load memory address
	mov	dph,r1
	movx	a,@dptr			; load byte
	inc	dptr			; increment memory address
	mov	b,a
	movx	a,@dptr			; load byte
	inc	dptr			; increment memory address
	xch	a,b			; put HI in A / LO in B
	mov	r0,dpl			; save memory address
	mov	r1,dph
	ret
;
;****************************************************************************

	.page
	.sbttl	Byte/Word Write To Data Memory

;****************************************************************************
;
;	Write Byte Data To Memory <A>
;
wt$mbt:	mov	dpl,r0			; load memory address
	mov	dph,r1
	movx	@dptr,a			; store byte
	inc	dptr			; increment memory address
	mov	r0,dpl			; save memory address
	mov	r1,dph
	ret
;
;****************************************************************************
;
;	Write Word Data To Memory <A:B>
;	Stores A In Hi-Byte / B In Lo-Byte
;
wt$mwd:	mov	dpl,r0			; load memory address
	mov	dph,r1
	movx	@dptr,a			; store byte
	inc	dptr			; increment memory address
	xch	a,b
	movx	@dptr,a			; store byte
	inc	dptr			; increment memory address
	xch	a,b			; restore <A:B>
	mov	r0,dpl			; save memory address
	mov	r1,dph
	ret
;
;****************************************************************************
;
;	Set MFM/RLL Drive Type
;
setmfm:	mov	dptr,#drvtyp
	clr	mfmtyp			; MFM
	mov	a,#(dr.dtwt | 0)	; write 0 (MFM) into register
	movx	@dptr,a
	ret

setrll:	mov	dptr,#drvtyp
	setb	mfmtyp			; RLL
	mov	a,#(dr.dtwt | dr.dtbt)	; write 1 (RLL) into register
	movx	@dptr,a
	ret
;
;****************************************************************************

 	.page
	.sbttl	Initialize Drive

;****************************************************************************
;
;	Initialize ATA Drive
;
;	dbg_dr$ini_aflg		Drive Initialization Abort Enable Flag
;	dbg_dr$ini_rflg		Drive Initialization Repeat On Error Enable Flag 
;	dbg_dr$ini_sflg		Drive Initialization Status Enable Flag 
;
;	  Exit Via Abort Has C-Bit Set
;	  Error Exit With 'A' Not Equal Zero
;

dr$ini:

1$:     .sb_x	dreghi,#0		; set hi byte to zero
	.sb_x	mfmsts,#0		; clear MFM status
	.sb_x	dmasts,#dm.rst		; hard reset of drive 

	lcall	wt$rdy			; rdy=1, bsy=0 - ready for command
	jc	3$			; abort -
	jnz	4$			; error -

	lcall	dr$st1			; note progress

	.sb_x	cmdreg,#cm.idn		; read drive parameters

	lcall	wt$drq			; drq=1, bsy=0 - ready for transfer
	jc	3$			; abort -
	jnz	4$			; error -

	lcall	dr$st2			; note progress

	mov	r0,#<ideblk		; address of data block
	mov	r1,#>ideblk		; required by wt$mwd
	mov	r2,#0			; prepare to transfer 256 words

2$:	lcall	rd$wrd			; read a word from disk
	lcall	wt$mwd			; write a word to memory
	djnz	r2,2$

	lcall	wt$rdy			; rdy=1, bsy=0 - ready for command
	jc	3$			; abort -
	jnz	4$			; error -

	lcall	dr$st3			; note progress

	.lb_x	a,dr$sct		; sector count
	.sb_x	sctcnt,a
	.lb_x	a,dr$hd			; head count - 1
	dec	a
	orl	a,#dr.set|dr.lba	; required bits
	.sb_x	drvreg,a
	.sb_x	cmdreg,#cm.idp		; initialize drive parameters

	lcall	wt$rdy			; rdy=1, bsy=0 - initialized
3$:	jc	7$			; abort -
4$:	jnz	8$			; error -

	lcall	dr$st4

	mov	r1,#pr$tbl-1		; port tables base address - 1
	mov	a,#-1			; port index - 1

5$:	inc	a			; port index
	inc	r1			; port table address
	mov	@r1,#0			; preset cache bank
	inc	r1
	mov	@r1,b			; partition number
	inc	r1
	mov	@r1,#0
	inc	r1
	mov	@r1,#0			; preset active cylinder
	inc	r1
	mov	@r1,#16			; head count
	inc	r1
	mov	@r1,a
	inc	@r1			; options - port set to #(1-4)
	inc	r1
	mov	@r1,#>4096		; MSB MAX cylinder count
	inc	r1
	mov	@r1,#<4096		; LSB MAX cylinder count
	cjne	a,#3,5$			; loop for 4 ports

	; Initialize MFM Registers

	mov	dptr,#prtsts		; First Register
	mov 	a,#0xFF			; All Bits
	movx	@dptr,a			; prtsts - Clear Ports Stepping Bits
	inc	dptr			; hdsts  - Skip Heads Status
	inc	dptr
	movx	@dptr,a			; trkwt0 - Clear Tracks Written 0-7
	inc	dptr
	movx	@dptr,a			; trkwt1 - Clear Tracks Written 8-15
	inc	dptr			; mfmsts - ready set later
	inc	dptr			; btctrl - seek/track0/bank bits
	mov	b,#4			; 4 ports 

	setb	pr1tk0			; set internal track0 flags
	setb	pr2tk0
	setb	pr3tk0
	setb	pr4tk0

6$:	dec	b			; port codes are 0 - 3
	mov	a,#(bt.skwt|bt.skbt|bt.tkwt|bt.tkbt|bt.bkwt)
	orl	a,b			; or code with bits
	movx	@dptr,a			; set seekdn, track0 and clear bank
	mov	a,b
	cjne	a,#0,6$			; loop for each port

	lcall	dr$st5

	.dr$set				; refers to 7$ and 8$

7$:	.sb_x	mfmsts,#mf.rdy		; drive now ready
	ret

8$:	lcall	io$err			; report error
	jnb	dbg_dr$ini_rflg,4$
	mov	dptr,#100		; wait .1 second
	lcall	timdel
	ljmp	1$			; Retry
;
dr$st1:	jnb	dbg_dr$ini_sflg,dr$stx	; passed point 1
	mov	dptr,#dr$mg1
	ljmp	strout
;
dr$st2:	jnb	dbg_dr$ini_sflg,dr$stx	; passed point 2
	mov	dptr,#dr$mg2
	ljmp	strout
;
dr$st3:	jnb	dbg_dr$ini_sflg,dr$stx	; passed point 3
	mov	dptr,#dr$mg3
	ljmp	strout
;
dr$st4:	jnb	dbg_dr$ini_sflg,dr$stx	; passed point 4
	mov	dptr,#dr$mg4
	ljmp	strout
;
dr$st5:	jnb	dbg_dr$ini_sflg,dr$stx	; passed point 5
	mov	dptr,#dr$mg5
	ljmp	strout

dr$stx:	ret

dr$mg1:	.byte	cr,lf
	.asciz	"1 - Drive Status: Ready"
dr$mg2:	.byte	cr,lf
	.asciz	"2 - Parameters Command Sent"
dr$mg3:	.byte	cr,lf
	.asciz	"3 - Parameter Block Read"
dr$mg4:	.byte	cr,lf
	.asciz	"4 - Parameters Initialized"
dr$mg5:	.byte	cr,lf
	.ascii	"5 - Initialization Complete"
	.byte	cr,lf,0
;
;****************************************************************************
;
.ifne mfm.dr$set
;
dr$st6:	jnb	dbg_dr$ini_sflg,dr$stx	; passed point 6
	mov	dptr,#dr$mg6
	ljmp	strout
;
dr$st7:	jnb	dbg_dr$ini_sflg,dr$stx	; passed point 7
	mov	dptr,#dr$mg7
	ljmp	strout
;
dr$mg6:	.ascii	"6 - Multiword DMA Mode Set To 2"
	.byte	cr,lf,0
dr$mg7:	.ascii	"6 - Failed To Set Multiword DMA To Mode 2"
	.byte	cr,lf,0

	; Verify Multiword DMA Mode

dr$set:	mov	dptr,#fetreg		; feature register
	mov	a,#0x03			; Set Transfer Mode
	movx	@dptr,a
	inc	dptr			; sector count register
	mov	a,#0b00100010		; multiword DMA mode 2
	movx	@dptr,a
	.sb_x	cmdreg,#cm.fet		; set feature

	lcall	wt$rdy			; rdy=1, bsy=0 - ready for command
	jc	4$			; abort -
	jnz	4$			; error -

	.sb_x	cmdreg,#cm.idn		; reread drive parameters

	lcall	wt$drq			; drq=1, bsy=0 - ready for transfer
	jc	4$			; abort -
	jnz	4$			; error -

	mov	r0,#<ideblk		; address of data block
	mov	r1,#>ideblk		; required by wt$mwd
	mov	r2,#0			; prepare to transfer 256 words

1$:	lcall	rd$wrd			; read a word from disk
	lcall	wt$mwd			; write a word to memory
	djnz	r2,1$

	lcall	wt$rdy			; rdy=1, bsy=0 - ready for command
	jc	4$			; abort -
	jnz	4$			; error -

	.lb_x	a,ideblk+(2*63+0)	; selected DMA mode
	jnb	a.2,2$
	lcall	dr$st6			; mode 2 set
	sjmp	3$
2$:	lcall	dr$st7			; mode 2 not set
;	sjmp	3$

3$:	clr	c
	clr	a
4$:	ret

.endif	; mfm.dr$set
;
;****************************************************************************
;
; Programmed IO commands
;

pior:	lcall	piorw		; get starting address of block
	jc	1$
	lcall	pio$rd		; go read block	
	ljmp	nomore
1$:	ljmp	badsyn

piow:	lcall	piorw
	jc	1$
	lcall	pio$wt		; go write block	
	ljmp	nomore
1$:	ljmp	badsyn


piorw:	lcall	number		; get transfer address
	jb	a.7,5$		; its required
	jz	5$

	.lb_rx	pioadd+0,nbrhi	; save transfer address
	.lb_rx	pioadd+1,nbrlo

	clr	c		; address >= ioblk1 ?
	mov	a,pioadd+0
	subb	a,#>ioblk1
	jnc	1$		; yes - skip, else set
	mov	pioadd+0,#>ioblk1
	mov	pioadd+1,#<ioblk1

1$:	clr	a		; preset block address
	mov	piolba+0,a
	mov	piolba+1,a
	mov	piolba+2,a
	mov	piolba+3,a

	lcall	number		; get <15:0> LBA address
	jb	a.7,5$		; its invalid
	jz	2$

	.lb_rx	piolba+2,nbrhi	; save <15:0> of address
	.lb_rx	piolba+3,nbrlo

	lcall	number		; get <27:16> LBA address
	jb	a.7,5$		; its invalid
	jz	2$

	.lb_rx	a,nbrhi		; save <27:16> of address
	anl	a,#0x0F
	mov	piolba+0,a
	.lb_rx	piolba+1,nbrlo

2$:	; disable shared buffer usage

.ifne	mfm$dbg
.ifne dbg.Ex0$TstA | dbg.Ex0$TstB
	jnb	i$enbl,3$
	clr	i$enbl		; disable mfmchg logging
	mov	dptr,#6$
	lcall	outstr
3$:
.endif
.ifne dbg.db$que
	jnb	q$enbl,4$
	clr	q$enbl		; disable r/w queue logging
	mov	dptr,#7$
	lcall	outstr
4$:
.endif
.endif

	clr	c		; good return
	ret

5$:	setb	c		; error return
	ret

.ifne	mfm$dbg
.ifne dbg.Ex0$TstA | dbg.Ex0$TstB
6$:	.ascii	" M[FMDBG] E[X0]     Set To OFF"
	.byte	cr,lf,eot
.endif
.ifne dbg.db$que
7$:	.ascii	" M[FMDBG] L[OGGING] Set To OFF"
	.byte	cr,lf,eot
.endif
.endif

;
;****************************************************************************

	.page
	.sbttl	PIO Read/Write Sector

;****************************************************************************
;
	; PIO Sector Read

pio$rd:	clr	ex0			; Ex0Int Disabled
	setb	piobsy			; pio busy
	lcall	wt$pio			; check for break
	jc	2$			; just exit on a ^B
	lcall	q$sts			; check IO queue status
	jnc	pio$rd			; wait for background IO to complete
	jb	mfmbsy,pio$rd

	lcall	wt$rdy			; rdy=1, bsy=0 - ready for command
	jc	2$			; abort -
	jnz	3$			; error -

	lcall	pio$ld			; load parameters

	mov	a,#cm.rd		; Read Sector(s) Command
	movx	@dptr,a

	lcall	wt$drq			; drq=1, bsy=0 - data ready
	jc	2$			; abort -
	jnz	3$			; error -

1$:	lcall	rd$wrd			; read word from disk
	lcall	wt$mwd			; write word to memory
	djnz	r2,1$

	lcall	wt$rdy			; rdy=1, bsy=0 - transfer complete
	jc	2$			; abort -
	jnz	3$			; error -

2$:	clr	piobsy			; pio finished
	setb	ex0			; Ex0Int Enabled
	ret

3$:	lcall	io$err			; report error
	sjmp	2$

	; PIO Sector Write

pio$wt:	clr	ex0			; Ex0Int Disabled
	setb	piobsy			; pio busy
	lcall	wt$pio			; check for break
	jc	2$			; just exit on a ^B
	lcall	q$sts			; check IO queue status
	jnc	pio$wt			; wait for background IO to complete
	jb	mfmbsy,pio$wt

	lcall	wt$rdy			; rdy=1, bsy=0 - ready for command
	jc	2$			; abort -
	jnz	3$			; error -

	lcall	pio$ld			; load parameters

	mov	a,#cm.wt		; Write Sector(s) Command
	movx	@dptr,a

	lcall	wt$drq			; drq=1, bsy=0 - ready for transfer
	jc	2$			; abort -
	jnz	3$			; error -

1$:	lcall	rd$mwd			; read buffer data
	lcall	wt$wrd			; write data
	djnz	r2,1$

	lcall	wt$rdy			; rdy=1, bsy=0 - transfer complete
	jc	2$			; abort -
	jnz	3$			; error -

2$:	clr	piobsy			; pio finished
	setb	ex0			; Ex0Int Enabled
	ret

3$:	lcall	io$err			; report error
	sjmp	2$

	; PIO Disk Transfer Setup

pio$ld:	.sb_x	dreghi,#0		; set hi byte to zero

	mov	dptr,#sctcnt		; 0x8002
	mov	a,#1			; 1 sector at a time
	movx	@dptr,a			; ==>> 512 bytes

	inc	dptr			; 0x8003 - sctnum
	mov	a,piolba+3
	movx	@dptr,a			; <7:0>

	inc	dptr			; 0x8004 - locyl
	mov	a,piolba+2
	movx	@dptr,a			; <15:8>

	inc	dptr			; 0x8005 - hicyl
	mov	a,piolba+1
	movx	@dptr,a			; <23:16>

	inc	dptr			; 0x8006 - drvreg
	mov	a,piolba+0
	anl	a,#0x0F			; mask LBA
	orl	a,#dr.set|dr.lba	; set bits / LBA
	movx	@dptr,a			; <27:24>, LBA

	inc	dptr			; 0x8007 - cmdreg

	; Load Buffer Address

	mov	r0,pioadd+1		; data block address <7:0>
	mov	r1,pioadd+0		; data block address <15:8>
	mov	r2,#0			; prepare to transfer 256 words

	ret

	; PIO Wait Abort

wt$pio:	lcall	coninp			; check input for ^B

	jnb	dbg_pio_aflg,1$
	setb	c
	jbc	wt$brk,2$		; abort?
1$:	clr	c
2$:	ret

;
;****************************************************************************

	.page
	.sbttl	Prepare Read / Write Queue Elements

;****************************************************************************
;
;  rd$que / wt$que Elements
;
;	.blkb	1		; Cache Bank: 0/1
;	.blkb	1		; Partition Number
;	.blkb	2		; Cylinder
;	.blkb	1		; Tracks / Cylinder
;	.blkb	1		; Options
;	.blkb	2		; Track Accessed Bytes
;
;	  This function is entered after a Port Cylinder
;	step.  A Port step immediately clears the MFM
;	seek complete.  The track0 signal is cleared
;	if the step direction is UP.
;
;****************************************************************************
;
;	Copy The Last Read Queue Element Into The Write Element
;
;	Assume wtque Is Always Called After adque
;
;	port  rd$que  address is in r2	(in IDATA)
;	port  wt$que  address is in r3	(in IDATA)
;	port  table   address is in r4	(in  DATA)
;	port bit mask address is in r5  (in IDATA)
;
wtque:	setb	wq$act			; wt$que becoming active
	mov	r0,r2			; rd$que address (from adque)
	mov	r1,r3			; wt$que address (from adque)

	mov	b,#6			; copy 6 bytes
1$:	mov	a,@r0		        ; .bnk, .part, .cyl+0, .cyl+1
	mov	@r1,a			; .trks, and .opt
	inc	r0
	inc	r1
	djnz	b,1$
	;
	; Copy Written Cache Tracks Into Write Queue
	;
	mov	r0,r5			; bit mask address
	mov	dptr,#trkwt0		; trkwt0 address
	movx	a,@dptr			; track written register 0
	anl	a,@r0			; mask out written bits for other ports
	movx	@dptr,a			; clear written bits (tracks 0-7)
;	mov	a,@r0			; test - write all tracks
	mov	@r1,a			; copy to .trkwt0

	inc	dptr			; next address
	inc	r0
	inc	r1

	movx	a,@dptr			; track written register 1
	anl	a,@r0			; select only port(mfmidx) tracks
	movx	@dptr,a			; clear written bits (tracks 8-15)
;	mov	a,@r0			; test - write all tracks
	mov	@r1,a			; copy to .trkwt1

	dec	r1			; back to .trkwt0

	; Rotate Cache Track Bytes By Track Offset

	mov	a,mfmidx		; Track Offset = mfmidx x 4
	jz	3$			; if 0 then skip rotation
	mov	b,#4			; The FPGA hardware maps the MFM
	mul	ab			; head values with this offset.
	mov	b,a			; rotation count
2$:	lcall	4$			; rotate track written bits
	djnz	b,2$			; loop for count
3$:	ret	

4$:	mov	a,@r1			; rotate LSB to get c
	rrc	a
	inc	r1
	mov	a,@r1			; tracks written 8-15
	rrc	a			; rotate 1 bit right
	mov	@r1,a			; save
	dec	r1
	mov	a,@r1			; tracks written 0-7
	rrc	a			; rotate 1 bit right
	mov	@r1,a			; save
	ret
;
;	Prepare The Read Queue Element
;
;	Assume rdque Is Always Called After adque
;
;	port  rd$que  address is in r2
;	port  wt$que  address is in r3
;	port  table   address is in r4
;	port bit mask address is in r5
;
rdque:	setb	rq$act			; rd$que becoming active

	mov	r1,r4			; port table address
	mov	a,@r1			; load last cache bank bit
	anl	a,#1			; leave just this bit
	xrl	a,#1			; complement bank ( 0 => 1 or 1 => 0 )
	mov	@r1,a			; save new cache bank bit

	mov	r0,r2			; rd$que address
	;
	; Fill In rd$que Elements
	;
	mov	b,#6
1$:	mov	a,@r1			; load .bnk, .part, .cyl+0,
	mov	@r0,a			; .cyl+1, .trks, and .opt
	inc	r0
	inc	r1
	djnz	b,1$

	clr	a			; clear .tch tracks
	mov	@r0,a
	inc	r0
	mov	@r0,a

	.db$que				; save queue elements

 	ret
;
;	Compute Port Parameter Addresses
;
;	mfmidx Specifies The Port Index
;
;	port  rd$que  address is returned in r2
;	port  wt$que  address is returned in r3
;	port  table   address is returned in r4
;	port bit mask address is returned in r5
;
adque:  mov	a,mfmidx		; port index (0-3)
	mov	b,#qu$siz		; length of queue block
	mul	ab			; product gives offset 
	add	a,#qu$tbl		; + address of read/write queue blocks
	mov	r2,a			; gives address of active read queue block
	add	a,#rwqsiz/2		; + 1/2 of r/w size
	mov	r3,a			; gives address of active write queue block
	;
	mov	a,mfmidx		; port index (0-3)
	mov	b,#pr$siz		; length of port table
	mul	ab			; product gives offset
	add	a,#pr$tbl		; + address of port table
	mov	r4,a			; gives address of selected port table
	;
	mov	a,mfmidx		; port index (0-3)
	mov	b,#2			; 2 bytes per entry
	mul	ab			; product gives offset
	add	a,#pr$msk		; + address of mask table
	mov	r5,a			; gives address of bit mask

	ret
;  
;****************************************************************************

	.page
	.sbttl	IDE <==> MFM Normal Process

;****************************************************************************
;
;
; Read New Cylinder (DMA Read / Cache Write)
;
;  rd$que / wt$que Elements
;
;	.blkb	1		; Cache Bank: 0/1
;	.blkb	1		; Partition Number
;	.blkb	2		; Cylinder
;	.blkb	1		; Tracks / Cylinder
;	.blkb	1		; Options
;	.blkb	2		; Track Accessed Bytes
;
dio$rd:	mov	r0,r2			; read queue block
	mov	a,@r0			; cache bank
	setb	cache.wrt		; Cache Write / DMA Read
	clr	cache.bnk		; assume cache bank = 0
	mov	mfmbnk,a		; is 0 or 1
	jz	1$			; bank = 0
	setb	cache.bnk		; bank = 1
	mov	a,#bt.bkbt
1$:	orl	a,#bt.bkwt		; write control bit
	orl	a,mfmidx		; active port index

	mov	dptr,#btctrl		; mfm bit control register
	movx	@dptr,a			; update status
	;
	inc	r0
	mov	mfmprt,@r0		; Partition Number
	inc	r0
	mov	mfmcyl+0,@r0		; Cylinder
	inc	r0
	mov	mfmcyl+1,@r0
	inc	r0
	mov	r6,@r0			; tracks per cylinder
	;
	.bgn_q$seek			; start of seek time interval
	;
	mov	mfmtrk,#0 - 1		; starting track - 1
2$:	inc	mfmtrk			; next track
	lcall	io$rw			; read a track
	djnz	r6,2$			; loop for track count
	;
	mov	dptr,#btctrl
	mov	a,#(bt.skwt|bt.skbt)	; port seek complete
	orl	a,mfmidx		; port index
	movx	@dptr,a
	;
	.end_q$seek			; end of seek time interval
	;
	clr	rq$act			; rd$que finished
	ret

;
;****************************************************************************
;
; Write Old Cylinder Data (DMA Write / Cache Read)
;
;  rd$que / wt$que Elements
;
;	.blkb	1		; Cache Bank: 0/1
;	.blkb	1		; Partition Number
;	.blkb	2		; Cylinder
;	.blkb	1		; Tracks / Cylinder
;	.blkb	1		; Options
;	.blkb	2		; Track Accessed Bytes
;
dio$wt:	mov	a,r3			; wt$que block
	add	a,#wq.twt
	mov	r1,a
	mov	a,@r1			; quick check for
	inc	r1
	orl	a,@r1			; tracks to write
	jz	4$			; none - skip
	;
	mov	r1,r3			; wt$que block
	clr	cache.wrt		; DMA Write / Cache Read
	clr	cache.bnk		; assume cache bank = 0
	mov	a,@r1			; set the active WRITE bank
	mov	mfmbnk,a		; is 0 or 1
	jz	1$			; bank = 0
	setb	cache.bnk		; bank = 1
1$:
	;
	inc	r1
	mov	mfmprt,@r1		; Partiton Number
	inc	r1
	mov	mfmcyl+0,@r1		; Cylinder
	inc	r1
	mov	mfmcyl+1,@r1
	inc	r1
	mov	r6,@r1			; tracks per cylinder
	inc	r1
	; --------		        ; skip option

	inc	r1			; at .trkwt0

	mov	mfmtrk,#0 - 1		; starting track  - 1
2$:	inc	mfmtrk			; next track
	clr	c
	inc	r1			; at .trkwt1
	mov	a,@r1			; tracks written 8-15
	rrc	a			; rotate 1 bit right
	mov	@r1,a			; save
	dec	r1			; at .trkwt0
	mov	a,@r1			; tracks written 0-7
	rrc	a			; rotate 1 bit right
	mov	@r1,a			; save
	jnc	3$			; track not written - skip
	push	r1			; save .trkwt0 address
	lcall	io$rw			; write a track
	pop	r1			; restore .trkwt0 address
3$:	djnz	r6,2$			; loop for track count
	;
4$:	clr	wq$act			; wt$que finished
	ret
;
;****************************************************************************

	.page
	.sbttl	IO Track Transfer Routine

;****************************************************************************
;
io$rw:	clr	mfmerr			; clear error flag
	lcall	wt$rdy			; rdy=1, bsy=0 - ready for command
	jc	4$			; abort -
	jnz	3$			; error -

	.db$ide				; set IDE interface track information
	lcall	io$csh			; setup cache DMA
	lcall	io$lba			; compute drive LBA

	; ATA Disk Transfer Setup
	mov	a,#MFM.tfrsiz		; assume MFM transfer size
	jnb	mfmtyp,1$	        ; OK
	mov	a,#RLL.tfrsiz		;  else  RLL transfer size
1$:	mov	dptr,#sctcnt		; 0x8002
	movx	@dptr,a			; .tfrsiz * 512 = 21K Bytes (MFM) / 31K Bytes (RLL)

	mov	a,dmalba+3		; LSB of Logical Block Address
	inc	dptr			; 0x8003 - sctnum
	movx	@dptr,a			; <7:0>

	mov	a,dmalba+2		; LSB+1 of Logical Block Address
	inc	dptr			; 0x8004 - locyl
	movx	@dptr,a			; <15:8>

	mov	a,dmalba+1		; LSB+2 of Logical Block Address
	inc	dptr			; 0x8005 - hicyl
	movx	@dptr,a			; <23:16>

	mov	a,dmalba+0		; LSB+3 of Logical Block Address
	anl	a,#0x0F			; mask LBA overflow (shouldn't happen)
	orl	a,#dr.set|dr.lba	; set bits / LBA
	inc	dptr			; 0x8006 - drvreg
	movx	@dptr,a			; LBA, <27:24>

	jb	cache.wrt,2$		; DMA / Cache IO Mode
	mov	a,#cm.dmw		; DMA Write / Cache Read
	sjmp	3$
2$:	mov	a,#cm.dmr		; DMA Read / Cache Write
;	sjmp	3$
3$:	inc	dptr			; 0x8007 - cmdreg
	movx	@dptr,a			; Start DMA IO

	lcall	wt$irq			; irq=1, bsy=0 - transfer completed
	jc	4$
	jz	5$

4$:	setb	mfmerr			; note error
	lcall	io$err			; report the error
5$:	ret
;
;****************************************************************************

	.page
	.sbttl	IO Error Reporting

;****************************************************************************
;
io$err:	jnb	dbg_io$err_eflg,3$

	.lb_rx	a,dbcode		; save display base
	push	a
	.lb_rx	a,dbnbr
	push	a

	mov	dptr,#errsts		; 8001
	mov	r2,#8			; 8 registers

1$:     lcall	wchdog			; hit watch dog timer
	cjne	r2,#2,2$		; 8001 - 8006
	mov	dptr,#altsts		; 800E & 800F
2$:	.sb_rx	dbcode,#1		; set HEX display base
	.sb_rx	dbnbr,#16
	lcall	docrlf
	lcall	outsp
	mov	b,dph
	mov	a,dpl
	lcall	out2by
	lcall	outsp
	mov	a,#4
	.sb_rx	dbcode,#4		; set BINARY display base
	.sb_rx	dbnbr,#2
	movx	a,@dptr			; get next register
	mov	b,a
	lcall	out1by
	inc	dptr			; next register address
	djnz	r2,1$

	lcall	docrlf

	pop	a
	.sb_rx	dbnbr,a
	pop	a
	.sb_rx	dbcode,a		; restore display base

3$:	ret
;
;****************************************************************************

	.page
	.sbttl	Load Cache DMA Address

;****************************************************************************
;
;	Track Number Is Specified By mfmtrk
;	Cache Bank Is Specified By cache.bnk
;	Cache R/W  Is Specified By cache.wrt
;	cache.wrt	1 :  DMA Read / Cache Write
;			0 :  DMA Write / Cache Read
;
;	The MFM stream cache memory is an 8-megabit device
;	organized as 16-bits x 512 kw.  The MFM configuration
;	is two banks of 16-bits x 256 kw.  Each MFM bank
;	is configured as 16 tracks of 16 kw each.  Thus
;	each track contains 256 k bits accessed as a bit
;	stream by the MFM interface.
;
;	An MFM disk drive has a rotational speed of 3600 rpm
;	resulting in a rotational time of 1/60 th of a second
;	or 16.667 milliseconds.  The MFM data rate is 5 MHz
;	corresponding to a maximum of 10 transitions per
;	microsecond or 166.7 k bits per rotation.  Thus each
;	track holds 20,834 bytes (just over 10 k words) and
;	easily fits into the 16 kw allocated for each track.
;
;	Note that the data stream encoding format is irrelavent
;	as long as the signal rate is 5 MHz.
;
io$csh:	mov	a,mfmidx		; compute track offset
	mov	b,#4			; as used by FPGA
	mul	ab			; track offset + track number
	add	a,mfmtrk		; gives the cache track number
	anl	a,#0x0F			; round robin allowed
	mov	b,#>0x4000		; cache blocking is 16 KW
	mul	ab			; compute bits <17:08> of cache address
	xch	a,b			; get <17:16> into 'A'
	anl	a,#0x03			; mask overflow (shouldn't happen)
	jnb	cache.bnk,1$		; skip if bank = 0
	orl	a,#dma.bnk		; set bank, bit <18>
1$:	jb	cache.wrt,2$		; write to cache is DMA READ
	orl	a,#dm.rw		; read from cache is DMA WRITE
2$:	push	a			; save <18:16> and R/W bit
	push	b			; save <15:08>
	clr	a
	push	a			; save <07:00>

	mov	b,#3			; 3 bytes to load
	mov	dptr,#dmalo		; first register address
3$:	pop	a			; pop value
	movx	@dptr,a			; load register (dmalo/dmahi/dmasts)
	inc	dptr			; next register address
	djnz	b,3$			; loop for all registers

	ret				; DMA address to/from cache set
;
;****************************************************************************

	.page
	.sbttl	Compute The DMA Logical Block Address

;****************************************************************************
;
;	Function Uses:
;	  mfmtrk		MFM Disk Track Number (0-15)
;	  mfmcyl		MFM Cylinder Number (0-4095)
;	  mfmprt		MFM Partition Number (IDE Capacity Dependent)
;
;	  trkblk		Track Block Size In Sectors (A Defined Constant)
;
;	The Function Calculates The LBA As Follows:
;
;		  (0-15)      (64)        (0-960)
;		 (mfmtrk  *  trkblk)  =>  dmalba
;
;		 (0-960)      (1024)    *  (0-4095)     (0-4194240)
;		 dmalba   +  (16 * 64)  *   trkcyl   =>   dmalba
;
;	      (0-4194240)   (2.0GB * partition Number)
;	         dmalba   +           prtlba         =>   dmalba
;
;	For Clarity Define 16-Bit Variables <HB1:LB1> and <HB2:LB2>
;
	.define	LB1	^/r2/
	.define	HB1	^/r3/
	.define	LB2	^/r4/
	.define	HB2	^/r5/

io$lba: clr	a			; clear 4-bytes of dmalba
	mov	dmalba+0,a
	mov	dmalba+1,a
	mov	dmalba+2,a
	mov	dmalba+3,a

	mov	r1,#dmalsb		; LSB of 4-byte dmalba

	mov	a,mfmtrk		; get MFM track number
	mov	b,#trkblk		; track block size in sectors
	lcall	muladd			; partial sum (mfmtrk x trkblk)

	mov	a,#16			; maximum tracks
	mov	b,#trkblk		; track block size in sectors
	mul	ab			; cylinder size = 16 x trkblk
	mov	LB1,a			; LSB of product
	mov	HB1,b			; MSB of product
	mov	LB2,mfmcyl+1		; LSB of cylinder number
	mov	HB2,mfmcyl+0		; MSB of cylinder number

	mov	r1,#dmalsb		; LSB of 4-byte dmalba

	mov	a,LB1
	mov	b,LB2
	lcall	muladd			; partial product LB1 x LB2

	dec	r1			; LSB + 1 of dmalba

	mov	a,LB1
	mov	b,HB2
	lcall	muladd			; partial product LB1 x HB2

	mov	a,HB1
	mov	b,LB2
	lcall	muladd			; partial product HB1 x LB2

	dec	r1			; LSB + 2 of dmalba

	mov	a,HB1
	mov	b,HB2
	lcall	muladd			; partial product HB1 x HB2
					; dmalba now contains the block
					; address within a drive partition
	lcall	getprt			; prtlba now contains the block
 					; address of the selected partition
	mov	r1,#dmalsb		; LSB of dmalba
	mov	r0,#prtlsb		; LSB of prtlba
	mov	r2,#4			; sum of the 4-byte numbers is left in dmalba
	lcall	bytsum			; compute byte sum

	ret				; LBA is left in dmalba

	.undefine	LB1
	.undefine	HB1
	.undefine	LB2
	.undefine	HB2

	; Compute Product And Add To Sum

muladd:	mul	ab			; multiply a x b => <b,a>

	push	a			; preset addition pointer
	mov	a,r1
	mov	r0,a
	pop	a

	add	a,@r0			; compute lo-byte sum
	mov	@r0,a
	dec	r0
	mov	a,b
	addc	a,@r0			; compute hi-byte sum
	mov	@r0,a
	jnc	1$			; skip if no carry
	dec	r0
	inc	@r0			; add carry to next byte
1$:	ret

	; Compute Base Address Of Partition

getprt:	mov	prtlba+3,#0		; partition size is 1.5GB
	mov	prtlba+2,#prtoff	; arbitrary Offset
	mov	b,#prtsiz		; prtsiz  (x  16  x  4096)
	mov	a,mfmprt		; partion number
	mul	ab			; compute partition offset
	mov	prtlba+1,a
	mov	prtlba+0,b
	ret

	; Compute A Sum

bytsum:	clr	c			; clear carry bit

1$:	mov	a,@r1
	addc	a,@r0
	mov	@r1,a
	dec	r1
	dec	r0
	djnz	r2,1$
	ret
;
;****************************************************************************

	.page
	.sbttl	MFM Drive Stepping Interrupt

;****************************************************************************
;
;	Interrupt service routine for
;	disk cylinder stepping.
;
;	MFM drives require a stepping rate of less than
;	~200KHz (5us. between pulses).  This routine
;	loops in approximately 4us for an AT89LP3240
;	operating at a frequency of 20MHz.  The routine
;	loops for approximately 250us following the
;	last stepping pulse before processing the seek
;	operation.
;
;	Drive cyclinder number and TRACK0 values
;	are updated in this routine.  The process
;	queue, q$blk, is updated when a port cylinder
;	is stepped.  The TRACK0 signal is processed
;	for the selected port.
;
Ex0Int:	push	psw			; save registers
	push	dph
	push	dpl
	push	a
	push	b

	.Ex0$TstA.setb			; mfm$dbg Interrupt Test Code

	mov	b,#1			; Set Loop Counter
	mov	pr$chg,#0		; Clear Port Change Bits

bgnscn:

	.Ex0$TstB.setb			; mfm$dbg Interrupt Test Code

	;
	; ports Change Status
	;
	mov	dptr,#prtsts		; port change status
	movx	a,@dptr			; read and clear changes
	movx	@dptr,a
	mov	pr$stp,a		; save stepping status
	;
	; Check Port 1 Stepping
	;
pr1chk:	jnb	pr_stp1,4$		; step1 - skip if not stepped
	jb	pr_dir1,2$		; sdir1 - skip if stepping up

	; Check If Port 1 Cylinder = 0
	clr	a
	cjne	a,pr1cyl+1,1$		; LSB of Port 1 cylinder
	cjne	a,pr1cyl+0,1$		; MSB of Port 1 cylinder
	sjmp	3$			; Process Track 0

	; Decrement Port 1 Cylinder
1$:	mov	a,pr1cyl+1		; LSB of Port 1 cylinder
	add	a,#0xFF
	mov	pr1cyl+1,a
	mov	a,pr1cyl+0		; MSB of Port 1 cylinder
	addc	a,#0xFF
	mov	pr1cyl+0,a

	; Check If Port 1 Cylinder = 0
	clr	pr1tk0			; initalize
	clr	a
	cjne	a,pr1cyl+1,endpr1	; LSB of Port 1 cylinder
	cjne	a,pr1cyl+0,endpr1	; MSB of Port 1 cylinder
	sjmp	3$			; Process Track 0

	; Increment Port 1 Cylinder
2$:	mov	a,pr1cyl+1		; LSB of Port 1 cylinder
	add	a,#1
	mov	pr1cyl+1,a
	mov	a,pr1cyl+0		; MSB of Port 1 cylinder
	addc	a,#0
	mov	pr1cyl+0,a
	clr	pr1tk0			; not at track 0

	; Check If Port 1 Cylinder Is At Maximum
	clr	c
	mov	a,pr1cyl+1		; LSB of Port 1 cylinder
	subb	a,pr1max+1		; LSB of Port 1 MAX
	mov	a,pr1cyl+0		; MSB of Port 1 cylinder
	subb	a,pr1max+0		; MSB of Port 1 MAX
	jc	endpr1		        ; 'c' set if pr1cyl < pr1max
	clr	a			; cylinder count exceeded
	mov	pr1cyl+1,a		; reset count
	mov	pr1cyl+0,a

3$:	setb	pr1tk0			; set track 0 flag

4$:	jnb	pr1tk0,endpr1		; skip if Track != 0

	mov	dptr,#btctrl		; port 1 track0 write
	mov	a,#(bt.tkwt|bt.tkbt|(1-1))
	movx	@dptr,a

endpr1:

	;
	; Check Port 2 Stepping
	;
pr2chk:	mov	a,pr$stp
	jnb	pr_stp2,4$		; step2 - skip if not stepped
	jb	pr_dir2,2$		; sdir2 - skip if stepping up

	; Check If Port 2 Cylinder = 0
	clr	a
	cjne	a,pr2cyl+1,1$		; LSB of Port 2 cylinder
	cjne	a,pr2cyl+0,1$		; MSB of Port 2 cylinder
	sjmp	3$			; Process Track 0

	; Decrement Port 2 Cylinder
1$:	mov	a,pr2cyl+1		; LSB of Port 2 cylinder
	add	a,#0xFF
	mov	pr2cyl+1,a
	mov	a,pr2cyl+0		; MSB of Port 2 cylinder
	addc	a,#0xFF
	mov	pr2cyl+0,a

	; Check If Port 2 Cylinder = 0
	clr	pr2tk0			; initalize
	clr	a
	cjne	a,pr2cyl+1,endpr2	; LSB of Port 2 cylinder
	cjne	a,pr2cyl+0,endpr2	; MSB of Port 2 cylinder
	sjmp	3$			; Process Track 0

	; Increment Port 2 Cylinder
2$:	mov	a,pr2cyl+1		; LSB of Port 2 cylinder
	add	a,#1
	mov	pr2cyl+1,a
	mov	a,pr2cyl+0		; MSB of Port 2 cylinder
	addc	a,#0
	mov	pr2cyl+0,a
	clr	pr2tk0			; not at track 0

	; Check If Port 2 Cylinder Is At Maximum
	clr	c
	mov	a,pr2cyl+1		; LSB of Port 2 cylinder
	subb	a,pr2max+1		; LSB of Port 2 MAX
	mov	a,pr2cyl+0		; MSB of Port 2 cylinder
	subb	a,pr2max+0		; MSB of Port 2 MAX
	jc	endpr2		        ; 'c' set if pr2cyl < pr2max
	clr	a			; cylinder count exceeded
	mov	pr2cyl+1,a		; reset count
	mov	pr2cyl+0,a

3$:	setb	pr2tk0			; set track 0 flag

4$:	jnb	pr2tk0,endpr2		; skip if Track != 0

	mov	dptr,#btctrl		; port 2 track0 write
	mov	a,#(bt.tkwt|bt.tkbt|(2-1))
	movx	@dptr,a

endpr2:

	;
	; Check Port 3 Stepping
	;
pr3chk:	mov	a,pr$stp
	jnb	pr_stp3,4$		; step3 - skip if not stepped
	jb	pr_dir3,2$		; sdir3 - skip if stepping up

	; Check If Port 3 Cylinder = 0
	clr	a
	cjne	a,pr3cyl+1,1$		; LSB of Port 3 cylinder
	cjne	a,pr3cyl+0,1$		; MSB of Port 3 cylinder
	sjmp	3$			; Process Track 0

	; Decrement Port 2 Cylinder
1$:	mov	a,pr3cyl+1		; LSB of Port 3 cylinder
	add	a,#0xFF
	mov	pr3cyl+1,a
	mov	a,pr3cyl+0		; MSB of Port 3 cylinder
	addc	a,#0xFF
	mov	pr3cyl+0,a

	; Check If Port 3 Cylinder = 0
	clr	pr3tk0			; initalize
	clr	a
	cjne	a,pr3cyl+1,endpr3	; LSB of Port 3 cylinder
	cjne	a,pr3cyl+0,endpr3	; MSB of Port 3 cylinder
	sjmp	3$			; Process Track 0

	; Increment Port 3 Cylinder
2$:	mov	a,pr3cyl+1		; LSB of Port 3 cylinder
	add	a,#1
	mov	pr3cyl+1,a
	mov	a,pr3cyl+0		; MSB of Port 3 cylinder
	addc	a,#0
	mov	pr3cyl+0,a
	clr	pr3tk0			; not at track 0

	; Check If Port 3 Cylinder Is At Maximum
	clr	c
	mov	a,pr3cyl+1		; LSB of Port 3 cylinder
	subb	a,pr3max+1		; LSB of Port 3 MAX
	mov	a,pr3cyl+0		; MSB of Port 3 cylinder
	subb	a,pr3max+0		; MSB of Port 3 MAX
	jc	endpr3		        ; 'c' set if pr3cyl < pr3max
	clr	a			; cylinder count exceeded
	mov	pr3cyl+1,a		; reset count
	mov	pr3cyl+0,a

3$:	setb	pr3tk0			; set track 0 flag

4$:	jnb	pr3tk0,endpr3		; skip if Track != 0

	mov	dptr,#btctrl		; port 3 track0 write
	mov	a,#(bt.tkwt|bt.tkbt|(3-1))
	movx	@dptr,a

endpr3:
	;
	; Check Port 4 Stepping
	;
pr4chk:	mov	a,pr$stp
	jnb	pr_stp4,4$		; step4 - skip if not stepped
	jb	pr_dir4,2$		; sdir4 - skip if stepping up

	; Check If Port 4 Cylinder = 0
	clr	a
	cjne	a,pr4cyl+1,1$		; LSB of Port 4 cylinder
	cjne	a,pr4cyl+0,1$		; MSB of Port 4 cylinder
	sjmp	3$			; Process Track 0

	; Decrement Port 4 Cylinder
1$:	mov	a,pr4cyl+1		; LSB of Port 4 cylinder
	add	a,#0xFF
	mov	pr4cyl+1,a
	mov	a,pr4cyl+0		; MSB of Port 4 cylinder
	addc	a,#0xFF
	mov	pr4cyl+0,a

	; Check If Port 4 Cylinder = 0
	clr	pr4tk0			; initalize
	clr	a
	cjne	a,pr4cyl+1,endpr4	; LSB of Port 4 cylinder
	cjne	a,pr4cyl+0,endpr4	; MSB of Port 4 cylinder
	sjmp	3$			; Process Track 0

	; Increment Port 4 Cylinder
2$:	mov	a,pr4cyl+1		; LSB of Port 4 cylinder
	add	a,#1
	mov	pr4cyl+1,a
	mov	a,pr4cyl+0		; MSB of Port 4 cylinder
	addc	a,#0
	mov	pr4cyl+0,a
	clr	pr4tk0			; not at track 0

	; Check If Port 4 Cylinder Is At Maximum
	clr	c
	mov	a,pr4cyl+1		; LSB of Port 4 cylinder
	subb	a,pr4max+1		; LSB of Port 4 MAX
	mov	a,pr4cyl+0		; MSB of Port 4 cylinder
	subb	a,pr4max+0		; MSB of Port 4 MAX
	jc	endpr4		        ; 'c' set if pr4cyl < pr4max
	clr	a			; cylinder count exceeded
	mov	pr4cyl+1,a		; reset count
	mov	pr4cyl+0,a

3$:	setb	pr4tk0			; set track 0 flag

4$:	jnb	pr4tk0,endpr4		; skip if Track != 0

	mov	dptr,#btctrl		; port 4 track0 write
	mov	a,#(bt.tkwt|bt.tkbt|(4-1))
	movx	@dptr,a

endpr4:

	mov	a,pr$stp
	anl	a,#(pr.stp1|pr.stp2|pr.stp3|pr.stp4)
	jz	endscn
	orl	a,pr$chg		; update execute processes
	mov	pr$chg,a

	.i$enbl	pr$stp,t2$msb		; log port stepping

	; Loop Count Set For 250us Looping
	.Ex0$Tst.LoopCount

	; Finished Change Checks
endscn:

	.Ex0$TstB.clrb			; mfm$dbg Interrupt Test Code

	mov	wdtrst,#0x1E		; Reset Watch Dog Timer
	mov	wdtrst,#0xE1
	djnz	b,1$			; Loop
	sjmp	2$
1$:	ljmp	bgnscn
2$:

	.Ex0$TstA.clrb			; mfm$dbg Interrupt Test Code

	.i$enbl	#0xFF,#0xFF		; terminate scanning sequence

	; Update Queue
	mov	a,pr$chg		; Ports Changed
	jz	6$			; None - Called At Initialization

	jnb	pr1.mnt,3$		; Port 1 Mounted ?
	jnb	pr_stp1,3$		; Port 1 Stepped ?
	mov	b,#0
	lcall	q$put			; Port 1 Queued
	mov	a,pr$chg
3$:	jnb	pr2.mnt,4$		; Port 2 Mounted ?
	jnb	pr_stp2,4$		; Port 2 Stepped ?
	mov	b,#1
	lcall	q$put			; Port 2 Queued
	mov	a,pr$chg
4$:	jnb	pr3.mnt,5$		; Port 3 Mounted ?
	jnb	pr_stp3,5$		; Port 3 Stepped ?
	mov	b,#2
	lcall	q$put			; Port 3 Queued
	mov	a,pr$chg
5$:	jnb	pr4.mnt,6$		; Port 4 Mounted ?
	jnb	pr_stp4,6$		; Port 4 Stepped ?
	mov	b,#3
	lcall	q$put			; Port 4 Queued
6$:

	pop	b			; restore registers
	pop	a
	pop	dpl
	pop	dph

bsychk:	.i$cnt				; update counters

	jb	mfmbsy,1$
	jb	mfmwbk,1$
	jb	mfmcpy,1$
	sjmp	3$

1$:	pop	psw			; exit if busy/no changes
2$:	reti				; exit interrupt

3$:	clr	et0			; disable writeback timer
	setb	mfmbsy			; busy
	lcall	2$			; reset interrupt logic
	sjmp	do$io	

mfm$io:	clr	et0			; disable writeback timer
	setb	mfmbsy
	push	psw

do$io:	.pshreg				; save all registers

	; que$io returns with interrupts disabled
	lcall	que$io			; do I/O
	lcall	wtbktm			; set wrtbck timer

	.popreg				; restore all registers
	pop	psw
	clr	mfmbsy
	setb	ea			; allow interrupts
	ret

wtbktm:	mov	dptr,#wrtbck		; writeback function
	mov	a,#200			; set writeback timer
	lcall	st$tm0			; for a 500 millisecond timeout
	ret

;
;****************************************************************************
;
que$io: clr	ea			; hold interrupts
	lcall	q$get			; get queued element
	jc	1$		        ; c set - queue empty
	mov	mfmidx,b		; port(mfmidx) to process
	setb	ea			; enable interrupts

	lcall	adque			; parameter addresses
	lcall	wtque			; build a new write queue element
	lcall	rdque			; build a new read queue element

	lcall	adque			; parameter addresses
	lcall	dio$rd			; do DMA IO read
	lcall	adque			; parameter addresses
	lcall	dio$wt			; do DMA IO write

	sjmp	que$io

1$:	ret

;
;****************************************************************************

	.page
	.sbttl	Port Queueing Functions

;****************************************************************************
;
;  Called With psw, dph, dpl, and a Registers Saved
;
;	b contains the value to put in queue
;
;	q$puti, q$geti, and q$blk are in the DATA area
;
q$put:	push	r0			; need a register
	mov	a,q$puti		; compute number of
	clr	c			; entries queued
	subb	a,q$geti
	jz	3$			; none - go add to queue

	push	r1			; need another register
	anl	a,#(qblksz-1)		; mask to queue length
	mov	r1,a			; save count
	mov	a,q$geti		; starting index

1$:	anl	a,#(qblksz-1)		; mask to queue length
	push	a			; save index
	add	a,#q$blk
	mov	r0,a			; first entry address
	mov	a,@r0			; get entry
	cjne	a,b,2$			; skip duplicate entries

	.i$dup				; note duplicate entry
	pop	a			; dump index
	pop	r1			; restore registers
	pop	r0
	ret				; dumped duplicate entry

2$:	pop	a			; pop index
	inc	a			; and increment
	djnz	r1,1$			; loop to check all entries
	pop	r1			; restore register

3$:	mov	a,q$puti		; compute entry address
	add	a,#q$blk
	mov	r0,a
	mov	@r0,b			; put value in queue
	pop	r0			; restore register

	mov	a,q$puti		; update index
	inc	a
	anl	a,#(qblksz-1)
	mov	q$puti,a
	ret
;
;	b contains the value from the queue
;	c bit is set if queue is empty
;
q$get:	mov	a,q$geti		; check for queue empty
	cjne	a,q$puti,1$
	setb	c			; queue empty flag
	ret

1$:	mov	a,q$geti		; compute entry address
	add	a,#q$blk
	push	r0			; save r0
	mov	r0,a
	mov	b,@r0			; get value from queue
	pop	r0

	mov	a,q$geti		; update get index
	inc	a
	anl	a,#(qblksz-1)
	mov	q$geti,a
	clr	c			; queue entry returned flag
	ret
;
;	c bit is set if queue is empty
;
q$sts:	mov	a,q$geti		; check for queue empty
	cjne	a,q$puti,1$
	setb	c			; queue empty flag
	ret
1$:	clr	c			; queue not empty flag
	ret
;
;****************************************************************************

	.page
	.sbttl	WriteBack Function (Called By Timer 0)

;****************************************************************************
;
;  Called With psw, dph, dpl, and a Registers Saved
;
	;
	; State Checking
	;
wrtbck:	clr	ea			; disable interrupts
	jb	mfmwbk,1$		; this is unexpected
	jb	mfmbsy,1$		; this is unexpected
	jb	mfmcpy,1$		; don't write while copy in progress
	jb	piobsy,1$		; don't write while PIO in progress

	mov	dptr,#mfmsts		; check if a drive is active
	movx	a,@dptr
	jb	mf_actv,1$		; don't write if drive is active

	setb	mfmwbk			; now in writeback mode
	lcall	2$			; clear interrupt logic
	setb	ea			; enable interrupts

	.Wbk$TstA.setb			; mfm$dbg Interrupt Test Code
	.pshreg				; save registers

	;
	; Write Back Current Cylinder Data
	;
	lcall	wt$bck			; written tracks are saved
	;
	; Clean Up Any Changes
	;
	; que$io returns with interrupts disabled
	lcall	que$io			; do I/O

	.popreg				; restore registers
	.Wbk$TstA.clrb			; mfm$dbg Interrupt Test Code

	clr	mfmwbk			; exiting writeback mode

1$:	lcall	wtbktm			; reset writeback timer
	setb	ea			; enable interrupts
	ret

2$:	setb	tm0ret			; faked interrupt return used 
	reti				; faked return from interrupt

	;
	; Written Tracks Are Saved To IDE Device
	;
wt$bck:	mov	mfmidx,#0		; port 1
	jnb	pr1.mnt,1$		; skip if not mounted
	lcall	5$
1$:	inc	mfmidx			; port 2
	jnb	pr2.mnt,2$		; skip if not mounted
	lcall	5$
2$:	inc	mfmidx			; port 3
	jnb	pr3.mnt,3$		; skip if not mounted
	lcall	5$
3$:	inc	mfmidx			; port 4
	jnb	pr2.mnt,4$		; skip if not mounted
	lcall	5$
4$:	ret

5$:	lcall	adque			; get queue address
	lcall	wtque			; build a new write queue element
	lcall	dio$wt			; do DMA IO write
	ret

;
;****************************************************************************

	.page
	.sbttl	Initialize All Things MFM and IDE

;****************************************************************************
;

mfmide_init:
	; P0 Is Data Port As Quasi-Bidirectional

	clr	a
	mov	p0m0,a			; Clear All Bits Of p0m0
	mov	p0m1,a			; Clear All Bits Of p0m1

	; /WR(p3.6) And /RD(p3.7) As Push/Pull Outputs

	mov	a,p3m0
	anl	a,#~0xC0		; Clear Bits p3m0.6 And p3m0.7
	mov	p3m0,a
	mov	a,p3m1
	orl	a,#0xC0			; Set   Bits p3m1.6 And p3m1.7
	mov	p3m1,a

	; ALE(p4.4) As Push/Pull Output

	mov	a,p4m0
	anl	a,#~0x10		; Clear Bit p4m0.4
	mov	p4m0,a
	mov	a,p4m1
	orl	a,#0x10			; Set   Bit p4m1.4
	mov	p4m1,a

	; Internal Options Enables

	setb	dbg_dr$ini_aflg		; Enable Abort Termination
	setb	dbg_dr$ini_sflg		; Enable Initialization Status
	setb	dbg_dr$ini_rflg		; Enable Repeat On Error

	setb	dbg_pio_aflg		; Enable PIO Wait Abort

	setb	dbg_io$err_eflg		; Enable IO Error Report

	; Configure the IDE Drive

	lcall	dr$ini			; initialize drive
	lcall	tm$.1s			; .1s wait for serial output to complete

	; Initialize The Timer

	.msg	^"*****    Timer 0 Set For 2.5 ms.    *****"
	mov	dptr,#-50000
	lcall	t0$ini

	lcall	wtbktm			; start writeback timer

	; Enable MFM Change Interrupt (External Interrupt 0)

	setb	ex0			; enable interrupt

	ret
;
;****************************************************************************

.endif	; mfm$ide
.endif	; .else of _mfmide

	.end

