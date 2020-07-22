.SUFFIXES:

SRCS := $(wildcard srcs/*.c)
LIBS := $(wildcard lib/*.asm)

GBDK := ../../gbdk

RGBDS :=
RGBASM := $(RGBDS)rgbasm
RGBLINK:= $(RGBDS)rgblink
RGBFIX := $(RGBDS)rgbfix

SDCC := ./bin/
CINC := -I include -I $(GBDK)/include
CC := $(SDCC)sdcc -mgbz80 --asm=rgbds --codeseg ROMX --no-optsdcc-in-asm --no-std-crt0 

rom.gb: lib/crt0.o $(SRCS:.c=.o) lib/gsinit_tail.o $(LIBS:.asm=.o)
	$(RGBLINK) -o $@ -m $(@:.gb=.map) -n $(@:.gb=.sym) $^ && \
	$(RGBFIX) -p 0xFF -v $@

%.o: %.asm
	$(RGBASM) -o $@ $<

%.asm: %.c
	$(CC) $(CINC) -S -o $@ $<
