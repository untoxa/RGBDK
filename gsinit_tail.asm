
SECTION FRAGMENT "_GSINIT", ROM0
	call _main
loop:
	halt
	jr loop
