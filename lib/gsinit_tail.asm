INCLUDE "defines.asm"

SECTION FRAGMENT "_GSINIT", ROM0
	ld a, BANK(_main)
	ldh [hCurROMBank], a
	ld [rROMB0], a
	call _main

	ld a, BANK(Intro)
	ldh [hCurROMBank], a
	ld [rROMB0], a

	jp Intro