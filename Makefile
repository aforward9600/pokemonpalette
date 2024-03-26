MD5 := md5sum -c

pokered_obj := audio_red.o main_red.o text_red.o wram_red.o
palettefaithful_obj := audio_palettefaithful.o main_palettefaithful.o text_palettefaithful.o wram_palettefaithful.o
pokegreen_obj := audio_green.o main_green.o text_green.o wram_green.o
pokebluejp_obj := audio_bluejp.o main_bluejp.o text_bluejp.o wram_bluejp.o
pokeredjp_obj := audio_redjp.o main_redjp.o text_redjp.o wram_redjp.o

.SUFFIXES:
.SECONDEXPANSION:
.PRECIOUS:
.SECONDARY:
.PHONY: all clean red blue green bluejp redjp compare tools

roms := pokered.gbc palettefaithful.gbc pokegreen.gbc pokebluejp.gbc pokeredjp.gbc

all: $(roms)
red: pokered.gbc
faithful: palettefaithful.gbc
green: pokegreen.gbc
bluejp: pokebluejp.gbc
redjp: pokeredjp.gbc

# For contributors to make sure a change didn't affect the contents of the rom.
compare: red blue green bluejp redjp
	@$(MD5) roms.md5

clean:
	rm -f $(roms) $(pokered_obj) $(palettefaithful_obj) $(pokegreen_obj) $(pokebluejp_obj) $(pokeredjp_obj) $(roms:.gbc=.sym)
	find . \( -iname '*.1bpp' -o -iname '*.2bpp' -o -iname '*.pic' \) -exec rm {} +
	$(MAKE) clean -C tools/

tools:
	$(MAKE) -C tools/


# Build tools when building the rom.
# This has to happen before the rules are processed, since that's when scan_includes is run.
ifeq (,$(filter clean tools,$(MAKECMDGOALS)))
$(info $(shell $(MAKE) -C tools))
endif


%.asm: ;

# _RED, _BLUE, and _GREEN are the base rom tags. You can only have one of these.
# _JPTXT modifies any base rom. It restores some japanese text translations that were censored in english.
# _REDGREENJP modifies _RED or _GREEN. It reverts back certain aspects that were shared between japanese red & green.
# _BLUEJP modifies _BLUE. It reverts back certain aspects that were unique to japanese blue.
# _REDJP modifies _RED. It is for minor things exclusive to japanese red.
# _METRIC modifies any base rom. It converts the pokedex data back to metric units.

%_red.o: dep = $(shell tools/scan_includes $(@D)/$*.asm)
$(pokered_obj): %_red.o: %.asm $$(dep)
	rgbasm -D _RED -h -o $@ $*.asm

%_palettefaithful.o: dep = $(shell tools/scan_includes $(@D)/$*.asm)
$(palettefaithful_obj): %_palettefaithful.o: %.asm $$(dep)
	rgbasm -D _FAITHFUL -h -o $@ $*.asm

%_green.o: dep = $(shell tools/scan_includes $(@D)/$*.asm)
$(pokegreen_obj): %_green.o: %.asm $$(dep)
	rgbasm -D _GREEN -D _REDGREENJP -D _JPTXT -D _METRIC -h -o $@ $*.asm

%_bluejp.o: dep = $(shell tools/scan_includes $(@D)/$*.asm)
$(pokebluejp_obj): %_bluejp.o: %.asm $$(dep)
	rgbasm -D _BLUE -D _BLUEJP -D _JPTXT -D _METRIC -h -o $@ $*.asm

%_redjp.o: dep = $(shell tools/scan_includes $(@D)/$*.asm)
$(pokeredjp_obj): %_redjp.o: %.asm $$(dep)
	rgbasm -D _RED -D _REDJP -D _REDGREENJP -D _JPTXT -D _METRIC -h -o $@ $*.asm

#gbcnote - use cjsv to compile as GBC+DMG rom
pokered_opt  = -cjsv -k 01 -l 0x33 -m 0x13 -p 0 -r 03 -t "POKEMON RED"
palettefaithful_opt = -cjsv -k 01 -l 0x33 -m 0x13 -p 0 -r 03 -t "POKEMON BLUE"
pokegreen_opt = -cjsv -k 01 -l 0x33 -m 0x13 -p 0 -r 03 -t "POKEMON GREEN"
pokebluejp_opt = -cjsv -k 01 -l 0x33 -m 0x13 -p 0 -r 03 -t "POKEMON BLUE"
pokeredjp_opt = -cjsv -k 01 -l 0x33 -m 0x13 -p 0 -r 03 -t "POKEMON RED"

%.gbc: $$(%_obj)
	rgblink -d -n $*.sym -l pokered.link -o $@ $^
	rgbfix $($*_opt) $@
	sort $*.sym -o $*.sym

gfx/blue/intro_purin_1.2bpp: rgbgfx += -h
gfx/blue/intro_purin_2.2bpp: rgbgfx += -h
gfx/blue/intro_purin_3.2bpp: rgbgfx += -h
gfx/red/intro_nido_1.2bpp: rgbgfx += -h
gfx/red/intro_nido_2.2bpp: rgbgfx += -h
gfx/red/intro_nido_3.2bpp: rgbgfx += -h

gfx/game_boy.2bpp: tools/gfx += --remove-duplicates
gfx/theend.2bpp: tools/gfx += --interleave --png=$<
gfx/tilesets/%.2bpp: tools/gfx += --trim-whitespace

%.png: ;

%.2bpp: %.png
	rgbgfx $(rgbgfx) -o $@ $<
	$(if $(tools/gfx),\
		tools/gfx $(tools/gfx) -o $@ $@)
%.1bpp: %.png
	rgbgfx -d1 $(rgbgfx) -o $@ $<
	$(if $(tools/gfx),\
		tools/gfx $(tools/gfx) -d1 -o $@ $@)
%.pic:  %.2bpp
	tools/pkmncompress $< $@
