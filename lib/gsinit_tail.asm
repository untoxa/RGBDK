INCLUDE "defines.asm"

SECTION FRAGMENT "_GSINIT", ROM0

	ehl_call_far	_main

	switch_bank	Intro
	jp	Intro