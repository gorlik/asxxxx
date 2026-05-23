	.title	LIST-NLIST Tests

	;
	;	The .list and .nlist assembler directives
	;	have the following sublist options:
	;
	;		err	-	errors
	;		loc	-	program location
	;		bin	-	binary output
	;		eqt	-	symbol or if evaluation
	;		cyc	-	opcode cycle count
	;		lin	-	source line number
	;		src	-	source line text
	;		pag	-	pagination
	;		lst	-	.list/.nlist line listing
	;		md	-	macro definition listing
	;		me	-	macro expansion listing
	;		meb	-	macro expansion binary output
	;
	;		!	-	sets the listing mode to
	;				!(.list) or !(.nlist) before
	;				applying the sublist options
	;
	;	The 'normal' listing mode .list' is the combination 
	;	of err, loc, bin, eqt, cyc, lin, src, pag, lst, and
	;	md enabled and me and meb disabled.
	;
	;	The 'normal' non-listing mode '.nlist' has all
	;	the sublist items disabled.
	;


	.list
	.page
	.sbttl	Supression of Individual Fields

	sym = 0			;eqt
	.opcode	0x00		;opcode

	.list
	.nlist	(loc)
	sym = 1			;eqt
	.opcode	0x01		;.nlist (loc)

	.list
	.nlist	(bin)
	sym = 2			;eqt
	.opcode	0x02		;.nlist (bin)

	.list
	.nlist	(eqt)
	sym = 3			;.nlist (eqt)
	.opcode	0x03		;opcode

	.list
	.nlist	(cyc)
	sym = 4			;eqt
	.opcode	0x04		;.nlist (cyc)

	.list
	.nlist	(lin)
	sym = 5			;eqt
	.opcode	0x05		;.nlist (lin)

	.list
	.nlist	(src)
	sym = 6			;eqt
	.opcode	0x06		;.nlist (src)

	.list
	.nlist	(pag)
	.page
				;.nlist (pag)


	.list
	.page
	.sbttl	Supression of Individual Fields

	sym = 0			;eqt
	.opcode	0x00		;opcode

	.nlist	(!,loc)
	sym = 1			;eqt
	.opcode	0x01		;.nlist (loc)

	.nlist	(!,bin)
	sym = 2			;eqt
	.opcode	0x02		;.nlist (bin)

	.nlist	(!,eqt)
	sym = 3			;.nlist (eqt)
	.opcode	0x03		;opcode

	.nlist	(!,cyc)
	sym = 4			;eqt
	.opcode	0x04		;.nlist (cyc)

	.nlist	(!,lin)
	sym = 5			;eqt
	.opcode	0x05		;.nlist (lin)

 	.nlist	(!,src)
	sym = 6			;eqt
	.opcode	0x06		;.nlist (src)

 	.nlist	(!,pag)
	.page
				;.nlist (pag)


	.list
	.page
	.sbttl	Enabling Individual Fields

	.nlist
	.list	(loc)
	sym = 1			;eqt
	.opcode	0x01		;.list (loc)

	.nlist
	.list	(bin)
	sym = 2			;eqt
	.opcode	0x02		;.list (bin)

	.nlist
	.list	(eqt)
	sym = 3			;.list (eqt)
	.opcode	0x03		;opcode

	.nlist
	.list	(cyc)
	sym = 4			;eqt
	.opcode	0x04		;.list (cyc)

	.nlist
	.list	(lin)
	sym = 5			;eqt
	.opcode	0x05		;.list (lin)

	.nlist
	.list	(src)
	sym = 6			;eqt
	.opcode	0x06		;.list (src)

	.nlist
	.list	(pag,src)
	.page
				;.list (pag,src)


	.list
	.page
	.sbttl	Enabling Individual Fields

	.list	(!,loc)
	sym = 1			;eqt
	.opcode	0x01		;.list (loc)

	.list	(!,bin)
	sym = 2			;eqt
	.opcode	0x02		;.list (bin)

	.list	(!,eqt)
	sym = 3			;.list (eqt)
	.opcode	0x03		;opcode

	.list	(!,cyc)
	sym = 4			;eqt
	.opcode	0x04		;.list (cyc)
 
	.list	(!,lin)
	sym = 5			;eqt
	.opcode	0x05		;.list (lin)

 	.list	(!,src)
	sym = 6			;eqt
	.opcode	0x06		;.list (src)

 	.list	(!,pag,src)
	.page
				;.list (pag,src)


	.list
	.page
	.sbttl	Error Override

	.nlist

	.error	1		;error code



	.list
	.page
	.sbttl	Macro Expansion Definitions and Macro Expansion Binary


	; Define a Macro
	.nlist	(md)
	.macro	adda	I
	  ; Nothing Listed	; Should NOT List
	  .byte	0x10,I		; Should NOT List
	.endm

	.list
	.macro	addb	I
	  ; Lists All Enabled	; Should NOT List
	  .list	(me)		; Should NOT List
	  ; B2			; Should List
	  .byte	0x20,I		; Should List
	.endm

	.list
	.macro	addc	I
	  ; Lists Location / Binary	; Should NOT List
	  .list	(meb)		; Should NOT List
	  ; C2			; Should NOT List
	  .byte	0x30,I		; Should List
	.endm

	.list
	.macro	addd	I
	  ; Lists Location / Binary and All Enabled	; Should NOT List
	  .list	(mel)		; Should NOT List
	  ; D2			; Should List
	  .byte	0x40,I		; Should List
	.endm

	.list
	; Normal Listing Mode Inhibits Listing of Macro Expansion
	adda	#1

	; .list (me) Lists Enabled Fields of Macro Expansion
	addb	#2

	; .list (meb) Lists Only Location/Binary of Macro Expansion
	addc	#3

	; .list (mel) Lists Location/Binary and Enabled Fields of Macro Expansion
	addd	#4

	; Normal Listing Mode Inhibits Listing of Macro Expansion
	.nlist
	adda	#1

	.list
	; .list (me) Lists Enabled Fields of Macro Expansion
	.nlist
	addb	#2

	.list
	; .list (meb) Lists Only Location/Binary of Macro Expansion
	.list	(!,lin)
	addc	#3

	.list
	; .list (mel) Lists Location/Binary and Enabled Fields of Macro Expansion
	.list	(!,src)
	addd	#4


	.list
	; Error Override of Macro Listing Control
	adda	1-.		; Relocation error


	.list
	.page
	.sbttl	.list and .nlist Overrides Within if-else-endif

	; Normally .lst and .nlist directives are not
	; processed within FALSE conditional blocks.
	;
	; The forms:	.list	n	and
	;		.nlist	n
	;
	;	where n is some expression will
	;	override the conditional block.
	;
	;	If n is non-zero
	;	then .list enables  listing
	;	and .nlist disables listing.
	;
	;	if n is zero
	;	then .list disables listing
	;	and .nlist enables  listing
	;

	; Initialized as .list
	.list
	.ifne	0		; Should     List (0)	; Condition = FALSE
	  .nlist		; Should     List (1)
	  .list			; Should     List (2)
	  .list		0	; Should     List (3)
	  .list		1	; Should     List (4)
	.endif

	.ifne	0		; Should     List (5)	; Condition = FALSE
	  .nlist		; Should     List (6)
	  .nlist 	1	; Should Not List (7)
	  .list		0	; Should Not List (8)
	  .list		1	; Should     List (9)
	  
	.endif


	; Initialized as .nlist
	.nlist
	.ifne	0		; Should Not List (0)	; Condition = FALSE
	  .nlist		; Should Not List (1)
	  .nlist 	0	; Should Not List (2)
	  .nlist	1	; Should Not List (3)
	  .list		0	; Should Not List (4)
	.endif

	.ifne	0		; Should Not List (5)	; Condition = FALSE
	  .nlist		; Should Not List (6)
	  .list			; Should Not List (7)
	  .list		0	; Should Not List (8)
	  .list		1	; Should     List (9)
	.endif



