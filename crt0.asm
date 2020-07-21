
SECTION "Header", ROM0[$100]
	di
	jp init

SECTION FRAGMENT "_GSINIT", ROM0
init::
