INCLUDE "defines.asm"

SECTION "trampolines", ROM0

___sdcc_bcall::
banked_call::			; Performs a long call.
	pop	hl		; Get the return address
	ldh	a,[hCurROMBank]
	push	af		; Push the current bank onto the stack
	ld	a,[hl+]		; Fetch the call address
	ld	e, a
	ld	a,[hl+]
	ld	d, a
	ld	a,[hl+]		; ...and page
	inc	hl		; Yes this should be here
	push	hl		; Push the real return address
	ldh	[hCurROMBank],a
	ld	[rROMB0],a	; Perform the switch
	ld	l,e
	ld	h,d
	rst	CallHL
	pop	hl		; Get the return address
	pop	af		; Pop the old bank
	ldh	[hCurROMBank],a
	ld	[rROMB0],a	; rROMB0
	jp	hl		; return

___sdcc_bcall_ehl::		; Performs a long call.
	ldh	a,[hCurROMBank]
	push	af		; Push the current bank onto the stack
	ld	a, e
	ldh	[hCurROMBank],a
	ld	[rROMB0],a	; Perform the switch
	rst	CallHL
	pop	af		; Pop the old bank
	ldh	[hCurROMBank],a
	ld	[rROMB0],a
	ret
