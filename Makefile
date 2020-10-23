.SUFFIXES:

OBJDIR = obj

SRCS = $(foreach dir,srcs,$(notdir $(wildcard $(dir)/*.c)))
ASRC = $(foreach dir,srcs,$(notdir $(wildcard $(dir)/*.asm))) 
LIBS = $(foreach dir,lib,$(notdir $(wildcard $(dir)/*.asm)))


ASFLAGS  = -p $(PADVALUE) $(addprefix -i,$(INCDIRS)) $(addprefix -W,$(WARNINGS))
LDFLAGS  = -p $(PADVALUE)
FIXFLAGS = -p $(PADVALUE) -v -i "$(GAMEID)" -k "$(LICENSEE)" -l $(OLDLIC) -m $(MBC) -n $(VERSION) -r $(SRAMSIZE) -t $(TITLE)

include rgbdk.mk

GBDK := ../../gbdk

RGBDS :=
RGBASM := $(RGBDS)rgbasm -i include
RGBLINK:= $(RGBDS)rgblink
RGBFIX := $(RGBDS)rgbfix

SDCC := 
CINC := -I libc/include
CC := $(SDCC)sdcc -mgbz80 --asm=rgbds --codeseg ROMX --no-optsdcc-in-asm --no-std-crt0 --fsigned-char

all:	prepare rom.gb

rom.gb:	$(OBJDIR)/header.o $(SRCS:%.c=$(OBJDIR)/%.o) $(OBJDIR)/gsinit_tail.o $(ASRC:%.asm=$(OBJDIR)/%.o) $(LIBS:%.asm=$(OBJDIR)/%.o)
	$(RGBLINK) $(LDFLAGS) -o $@ -m $(@:.gb=.map) -n $(@:.gb=.sym) $^ && \
	$(RGBFIX) $(FIXFLAGS) -v $@

$(OBJDIR)/%.asm:	srcs/%.c
	$(CC) $(CINC) -S -o $@ $<

$(OBJDIR)/%.o:	srcs/%.asm
	$(RGBASM) $(ASFLAGS) -o $@ $<

$(OBJDIR)/%.o:	lib/%.asm
	$(RGBASM) $(ASFLAGS) -o $@ $<

%.o: %.asm
	$(RGBASM) $(ASFLAGS) -o $@ $<

%.asm: %.c
	$(CC) $(CINC) -S -o $@ $<

prepare:
	mkdir -p $(OBJDIR)

clean:
	rm -rf obj/*
	rm -rf rom.*
