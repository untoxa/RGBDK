# experiments_with_sdcc4_and_rgbds

I made some patches to SDCC4 source code, that fix the generation of rgbds-compatible asm listing, issued by it.

Unfortunately, it turned out, that link script is required for rgblink to order the sections. So some external 
third-party link-script generator is needed to make the "GSINIT" areas link before the "HOME", which contains the 
main() entry point.

The format of rgbds object file is described here: https://rednex.github.io/rgbds/rgbds.5.html

Crt may be also organized the other way.

I appriciate your help and feedback. 

Tony.
