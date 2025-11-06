'+---------------+---------------------------------------------------+
'| ###### ###### |     .--. .         .-.                            |
'| ##  ## ##   # |     |   )|        (   ) o                         |
'| ##  ##  ##    |     |--' |--. .-.  `-.  .  .-...--.--. .-.        |
'| ######   ##   |     |  \ |  |(   )(   ) | (   ||  |  |(   )       |
'| ##      ##    |     '   `'  `-`-'  `-'-' `-`-`|'  '  `-`-'`-      |
'| ##     ##   # |                            ._.'                   |
'| ##     ###### |  Sources & Documents placed in the Public Domain. |
'+---------------+---------------------------------------------------+
'|                                                                   |
'| === FractalMountains.bas ===                                      |
'|                                                                   |
'| == This short example draws Mandelbrot fractals in a 3D manner to |
'| == demonstrate the usage of the FillPolygon() function.           |
'|                                                                   |
'+-------------------------------------------------------------------+
'| Done by RhoSigma, R.Heyder, provided AS IS, use at your own risk. |
'| Find me in the QB64 Forum or mail to support@rhosigma-cw.net for  |
'| any questions or suggestions. Thanx for your interest in my work. |
'+-------------------------------------------------------------------+

$USELIBRARY:'RhoSigma/Polygons'

'--- Setup a graphics screen.
'-----
scr& = _NEWIMAGE(1024, 768, 256)
SCREEN scr&
_DELAY 0.2
_TITLE "Fractal Mountains"

'--- Init the color palette.
'-----
nc% = 128
RESTORE ColorTab
FOR k% = 0 TO (nc% - 1)
    READ r%, g%, b%
    _PALETTECOLOR k%, (r% * 65536) + (g% * 256) + b%
NEXT k%
_PALETTECOLOR 128, (47 * 65536) + (47 * 256) + 47
_PALETTECOLOR 129, (127 * 65536) + (127 * 256) + 127
_PALETTECOLOR 130, (255 * 65536) + (255 * 256) + 255

'--- Not actually screen sizes, but the limit for calculations.
'-----
scrX% = 740
scrY% = 555

'--- Init some other stuff.
'-----
RANDOMIZE TIMER
DIM StdFrac%(scrX% - 1, scrY% - 1)
DIM CurFrac%(scrX% - 1, scrY% - 1, 2)
stX% = 5 'mesh size of StdFrac X
stY% = 5 'mesh size of StdFrac Y
sd% = 0 'StdFrac filled flag

'--- Select an graphic area and do the mandelbrot math.
'-----
CLS
DO
    IF sd% = 0 THEN
        x1# = -2.1
        x2# = 0.7
        y1# = -1.18
        y2# = 1.18
    ELSE
        LOCATE 1, 1
        COLOR 130
        PRINT "looking for new graphic cutout ..."
        x% = RangeRand%(0, scrX% - 1)
        y% = RangeRand%(0, scrY% - 1)
        lc% = RangeRand%(32, 48)
        WHILE StdFrac%(x%, y%) < lc%
            x% = RangeRand%(0, scrX% - 1)
            y% = RangeRand%(0, scrY% - 1)
        WEND
        fd% = RangeRand%(1, 10)
        x1# = (2.8 / scrX% * (x% - fd%)) + (-2.1)
        x2# = (2.8 / scrX% * (x% + fd%)) + (-2.1)
        y1# = (2.36 / scrY% * (y% - fd%)) + (-1.18)
        y2# = (2.36 / scrY% * (y% + fd%)) + (-1.18)
    END IF

    dx# = (x2# - x1#)
    dy# = (y2# - y1#)

    IF sd% = 1 THEN
        LOCATE 1, 1
        COLOR 130
        PRINT STRING$(60, " ")
        LOCATE 1, 1
        LINE INPUT "Mesh-Size (5-100 in multiples of 5): "; i$
        LOCATE 1, 1
        PRINT STRING$(60, " ")
        stX% = INT(VAL(i$) / 5) * 5
        stY% = INT(VAL(i$) / 5) * 5
        IF stX% < 5 OR stY% < 5 THEN
            stX% = 5
            stY% = 5
        ELSEIF stX% > 100 OR stY% > 100 THEN
            stX% = 100
            stY% = 100
        END IF
    END IF
    FOR y% = (scrY% - 1) TO 0 STEP -stY%
        LOCATE 1, 1
        COLOR 130
        PRINT "calculating new graphic:"; 100 - INT(100 / scrY% * y%); "%"
        b# = y1# + (dy# * (y% / scrY%))
        FOR x% = 0 TO (scrX% - 1) STEP stX%
            a# = x1# + (dx# * (x% / scrX%))
            v# = 0
            c1# = 0.001
            c2# = 0.005
            f% = 1
            k% = 0
            WHILE v# < nc% AND f% = 1
                tc1# = c1#
                tc2# = c2#
                c1# = (tc1# * tc1#) - (tc2# * tc2#) + a#
                c2# = (2 * tc1# * tc2#) + b#
                v# = (c1# * c1#) + (c2# * c2#)
                k% = k% + 1
                IF k% = nc% THEN f% = 0
                i$ = INKEY$
                IF i$ = CHR$(27) OR i$ = "q" OR i$ = "e" GOTO exitProgram
            WEND
            IF k% = nc% THEN
                xx% = x%
                yy% = y%
                kk% = 0
                XYfrom3D xx%, yy%, kk%
                CurFrac%(x%, y%, 0) = xx% + 2
                CurFrac%(x%, y%, 1) = -kk% + 550
                CurFrac%(x%, y%, 2) = 128
                IF sd% = 0 THEN StdFrac%(x%, y%) = 0
            ELSE
                xx% = x%
                yy% = y%
                kk% = k%
                XYfrom3D xx%, yy%, kk%
                CurFrac%(x%, y%, 0) = xx% + 2
                CurFrac%(x%, y%, 1) = -kk% + 550
                CurFrac%(x%, y%, 2) = k%
                IF sd% = 0 THEN StdFrac%(x%, y%) = k%
            END IF
        NEXT x%
    NEXT y%
    LOCATE 1, 1
    COLOR 130
    PRINT "calculating new graphic: 100 %"

    '--- Calculation done, now ask the user for drawing style.
    '-----
    drawMen:
    LOCATE 3, 1
    COLOR 130
    PRINT "Drawing Menu:"
    PRINT "-------------"
    PRINT " 1 - single color mesh"
    PRINT " 2 - multicolor mesh"
    PRINT ""
    PRINT " 3 - single color surfaces"
    PRINT " 4 - multicolor surfaces"
    PRINT ""
    PRINT " 5 - single color mesh & surfaces"
    PRINT " 6 - multicolor mesh & surfaces"
    PRINT ""
    PRINT " 7 - calculate another graphic"
    PRINT " 8 - quit program"
    i$ = ""
    WHILE i$ < "1" OR i$ > "8"
        _LIMIT 50
        i$ = INKEY$
    WEND
    IF i$ = "7" THEN
        i$ = ""
        LOCATE 3, 1
        COLOR 130
        FOR i% = 1 TO 13
            PRINT STRING$(35, " ")
        NEXT i%
        GOTO nextGfx
    END IF
    IF i$ = "8" GOTO exitProgram
    CLS
    FOR y% = (scrY% - 1) - stY% TO 0 + stY% STEP -stY%
        FOR x% = 0 + stX% TO (scrX% - 1) - stX% STEP stX%
            'get average of used colors (from every polygon corner)
            pix% = 0
            fa% = 0
            IF CurFrac%(x%, y%, 2) <> 128 THEN
                fa% = fa% + CurFrac%(x%, y%, 2)
                pix% = pix% + 1
            END IF
            IF CurFrac%(x% + stX%, y%, 2) <> 128 THEN
                fa% = fa% + CurFrac%(x% + stX%, y%, 2)
                pix% = pix% + 1
            END IF
            IF CurFrac%(x% + stX%, y% - stY%, 2) <> 128 THEN
                fa% = fa% + CurFrac%(x% + stX%, y% - stY%, 2)
                pix% = pix% + 1
            END IF
            IF CurFrac%(x%, y% - stY%, 2) <> 128 THEN
                fa% = fa% + CurFrac%(x%, y% - stY%, 2)
                pix% = pix% + 1
            END IF
            IF pix% > 0 THEN
                fa% = INT(fa% / pix%)
            ELSE
                fa% = 128
            END IF
            'now do the drawing depending on users choice
            IF i$ = "3" OR i$ = "5" THEN
                DrawFill x%, y%, 129
            ELSEIF i$ = "4" OR i$ = "6" THEN
                DrawFill x%, y%, fa%
            END IF
            IF i$ = "1" OR i$ = "5" OR i$ = "6" THEN
                IF i$ = "1" THEN
                    DrawMesh x%, y%, 129
                ELSEIF i$ = "5" THEN
                    DrawMesh x%, y%, 128
                ELSE
                    DrawMesh x%, y%, 0
                END IF
            ELSEIF i$ = "2" THEN
                DrawMesh x%, y%, fa%
            END IF
        NEXT x%
    NEXT y%
    GOTO drawMen

    nextGfx:
    sd% = 1
    exitProgram:
LOOP WHILE i$ = ""

'--- Cleanup screen and quit.
'-----
SCREEN 0
_FREEIMAGE scr&
SYSTEM

'--- Pre-defined colors (R,G,B, R,G,B, R,G,B, ...)
'-----
ColorTab:
DATA &H00,&H00,&H00,&H08,&H00,&H10,&H10,&H00,&H20,&H18,&H00,&H30
DATA &H20,&H00,&H40,&H28,&H00,&H50,&H30,&H00,&H60,&H38,&H00,&H70
DATA &H40,&H00,&H80,&H48,&H00,&H90,&H50,&H00,&HA0,&H58,&H00,&HB0
DATA &H60,&H00,&HC0,&H68,&H00,&HD0,&H70,&H00,&HE0,&H78,&H00,&HF0
DATA &H80,&H00,&HFF,&H78,&H00,&HFF,&H70,&H00,&HFF,&H68,&H00,&HFF
DATA &H60,&H00,&HFF,&H58,&H00,&HFF,&H50,&H00,&HFF,&H48,&H00,&HFF
DATA &H40,&H00,&HFF,&H38,&H00,&HFF,&H30,&H00,&HFF,&H28,&H00,&HFF
DATA &H20,&H00,&HFF,&H18,&H00,&HFF,&H10,&H00,&HFF,&H08,&H00,&HFF
DATA &H00,&H00,&HFF,&H00,&H10,&HFF,&H00,&H20,&HFF,&H00,&H30,&HFF
DATA &H00,&H40,&HFF,&H00,&H50,&HFF,&H00,&H60,&HFF,&H00,&H70,&HFF
DATA &H00,&H80,&HFF,&H00,&H90,&HFF,&H00,&HA0,&HFF,&H00,&HB0,&HFF
DATA &H00,&HC0,&HFF,&H00,&HD0,&HFF,&H00,&HE0,&HFF,&H00,&HF0,&HFF
DATA &H00,&HFF,&HFF,&H00,&HFF,&HF0,&H00,&HFF,&HE0,&H00,&HFF,&HD0
DATA &H00,&HFF,&HC0,&H00,&HFF,&HB0,&H00,&HFF,&HA0,&H00,&HFF,&H90
DATA &H00,&HFF,&H80,&H00,&HFF,&H70,&H00,&HFF,&H60,&H00,&HFF,&H50
DATA &H00,&HFF,&H40,&H00,&HFF,&H30,&H00,&HFF,&H20,&H00,&HFF,&H10
DATA &H00,&HFF,&H00,&H10,&HFF,&H00,&H20,&HFF,&H00,&H30,&HFF,&H00
DATA &H40,&HFF,&H00,&H50,&HFF,&H00,&H60,&HFF,&H00,&H70,&HFF,&H00
DATA &H80,&HFF,&H00,&H90,&HFF,&H00,&HA0,&HFF,&H00,&HB0,&HFF,&H00
DATA &HC0,&HFF,&H00,&HD0,&HFF,&H00,&HE0,&HFF,&H00,&HF0,&HFF,&H00
DATA &HFF,&HFF,&H00,&HFF,&HF0,&H00,&HFF,&HE0,&H00,&HFF,&HD0,&H00
DATA &HFF,&HC0,&H00,&HFF,&HB0,&H00,&HFF,&HA0,&H00,&HFF,&H90,&H00
DATA &HFF,&H80,&H00,&HFF,&H70,&H00,&HFF,&H60,&H00,&HFF,&H50,&H00
DATA &HFF,&H40,&H00,&HFF,&H30,&H00,&HFF,&H20,&H00,&HFF,&H10,&H00
DATA &HFF,&H00,&H00,&HFF,&H00,&H08,&HFF,&H00,&H10,&HFF,&H00,&H18
DATA &HFF,&H00,&H20,&HFF,&H00,&H28,&HFF,&H00,&H30,&HFF,&H00,&H38
DATA &HFF,&H00,&H40,&HFF,&H00,&H48,&HFF,&H00,&H50,&HFF,&H00,&H58
DATA &HFF,&H00,&H60,&HFF,&H00,&H68,&HFF,&H00,&H70,&HFF,&H00,&H78
DATA &HFF,&H00,&H80,&HF0,&H00,&H78,&HE0,&H00,&H70,&HD0,&H00,&H68
DATA &HC0,&H00,&H60,&HB0,&H00,&H58,&HA0,&H00,&H50,&H90,&H00,&H48
DATA &H80,&H00,&H40,&H70,&H00,&H38,&H60,&H00,&H30,&H50,&H00,&H28
DATA &H40,&H00,&H20,&H30,&H00,&H18,&H20,&H00,&H10,&H10,&H00,&H08

'--- Subroutine to build the polygon arrays and call FillPolygon().
'-----
SUB DrawFill (x%, y%, f%)
    SHARED CurFrac%(), stX%, stY%
    REDIM px%(3), py%(3)
    px%(0) = CurFrac%(x%, y%, 0): py%(0) = CurFrac%(x%, y%, 1)
    px%(1) = CurFrac%(x% + stX%, y%, 0): py%(1) = CurFrac%(x% + stX%, y%, 1)
    px%(2) = CurFrac%(x% + stX%, y% - stY%, 0): py%(2) = CurFrac%(x% + stX%, y% - stY%, 1)
    px%(3) = CurFrac%(x%, y% - stY%, 0): py%(3) = CurFrac%(x%, y% - stY%, 1)
    FillPolygon px%(), py%(), f%, -1
END SUB

'--- Subroutine to draw mesh lines.
'-----
SUB DrawMesh (x%, y%, f%)
    SHARED CurFrac%(), stX%, stY%
    PSET (CurFrac%(x%, y%, 0), CurFrac%(x%, y%, 1)), f%
    LINE -(CurFrac%(x% + stX%, y%, 0), CurFrac%(x% + stX%, y%, 1)), f%
    LINE -(CurFrac%(x% + stX%, y% - stY%, 0), CurFrac%(x% + stX%, y% - stY%, 1)), f%
    LINE -(CurFrac%(x%, y% - stY%, 0), CurFrac%(x%, y% - stY%, 1)), f%
    LINE -(CurFrac%(x%, y%, 0), CurFrac%(x%, y%, 1)), f%
END SUB

'--- Subroutine to transform 3D coordinates into 2D,
'--- using simple cavalier perspective.
'-----
SUB XYfrom3D (x%, y%, z%)
    x% = (x% + (y% * .5))
    z% = (z% + (y% * .5))
END SUB

'--- Function to get a integer random number in the given range.
'-----
FUNCTION RangeRand% (low%, high%)
    RangeRand% = INT(RND(1) * (high% - low% + 1)) + low%
END FUNCTION

'--- Function to define/return the program's version string.
'-----
FUNCTION VersionFractalMountains$
    VersionFractalMountains$ = MID$("$VER: FractalMountains 1.0 (14-Nov-2018) by RhoSigma :END$", 7, 46)
END FUNCTION

