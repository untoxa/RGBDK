.SUFFIXES:

SRCS := $(wildcard srcs/*.c)
ASRC := $(wildcard srcs/*.asm)
LIBS := $(wildcard lib/*.asm)

ASFLAGS  = -p $(PADVALUE) $(addprefix -i,$(INCDIRS)) $(addprefix -W,$(WARNINGS))
LDFLAGS  = -p $(PADVALUE)
FIXFLAGS = -p $(PADVALUE) -v -i "$(GAMEID)" -k "$(LICENSEE)" -l $(OLDLIC) -m $(MBC) -n $(VERSION) -r $(SRAMSIZE) -t $(TITLE)

include rgbdk.mk

GBDK := ../../gbdk

RGBDS :=
RGBASM := $(RGBDS)rgbasm -i include
RGBLINK:= $(RGBDS)rgblink
RGBFIX := $(RGBDS)rgbfix

SDCC := ./bin
CINC := -I include -I $(GBDK)/include
CC := $(SDCC)/sdcc -mgbz80 --asm=rgbds --codeseg ROMX --no-optsdcc-in-asm --no-std-crt0 

rom.gb: lib/header.o $(SRCS:.c=.o) lib/gsinit_tail.o $(LIBS:.asm=.o) $(ASRC:.asm=.o)
	$(RGBLINK) $(LDFLAGS) -o $@ -m $(@:.gb=.map) -n $(@:.gb=.sym) $^ && \
	$(RGBFIX) $(FIXFLAGS) -v $@

%.o: %.asm
	$(RGBASM) $(ASFLAGS) -o $@ $<

%.asm: %.c
	$(CC) $(CINC) -S -o $@ $<
