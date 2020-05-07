@echo off
@set PROJ=rgbdstest
@set GBDK=..\..\gbdk\
@set GBDKLIB=.\lib\rgbds\
@set OBJ=build\

@rem @set CFLAGS=-mgbz80 --asm=rgbds --codeseg ROMX --dataseg WRAMX --constseg ROMX --no-optsdcc-in-asm --no-std-crt0 -I %GBDK%\include -I %GBDK%\include\asm -I src\include -c
@set CFLAGS=-mgbz80 --asm=rgbds --codeseg ROMX --no-optsdcc-in-asm --no-std-crt0 -I %GBDK%\include -I %GBDK%\include\asm -I src\include -c

@set LFLAGS=-n -- -z -m -j -yt2 -yo4 -ya4 -k%GBDKLIB%\gbz80\ -lgbz80.lib -k%GBDKLIB%\gb\ -lgb.lib 
@set LFILES=%GBDKLIB%\gb\crt0.rel

@set ASMFLAGS=-plosgff -I"libc"

@echo Cleanup...

@if exist %OBJ% rd /s/q %OBJ%
@if exist %PROJ%.gb del %PROJ%.gb
@if exist %PROJ%.sym del %PROJ%.sym
@if exist %PROJ%.map del %PROJ%.map

@if not exist %OBJ% mkdir %OBJ%

@echo COMPILING WITH SDCC4...

sdcc %CFLAGS% -bo1 -ba1 rgbdstest.b1.c -o %OBJ%rgbdstest.b1.rel
@set LFILES = %LFILES% %OBJ%rgbdstest.b1.rel

sdcc %CFLAGS% %PROJ%.c -o %OBJ%%PROJ%.rel

@echo LINKING WITH GBDK...
rgblink -o %PROJ%.gb %LFILES% %OBJ%%PROJ%.rel

@echo DONE!
