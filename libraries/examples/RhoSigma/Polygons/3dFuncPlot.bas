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
'| === 3dFuncPlot.bas (unfinished) ===                               |
'|                                                                   |
'| == This short example plots given F(x,y) functions in a 3D manner |
'| == to demonstrate the usage of the FillPolygon() function.        |
'|                                                                   |
'| == Note that this demo is considered "unfinished" yet, as there's |
'| == no option to enter the F(x,y), you can just type it in here in |
'| == the source file around line numbers 97-101.                    |
'|                                                                   |
'+-------------------------------------------------------------------+
'| Done by RhoSigma, R.Heyder, provided AS IS, use at your own risk. |
'| Find me in the QB64 Forum or mail to support@rhosigma-cw.net for  |
'| any questions or suggestions. Thanx for your interest in my work. |
'+-------------------------------------------------------------------+

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'RhoSigma/Polygons'

'--- Setup a graphics screen.
'-----
scr& = _NEWIMAGE(1024, 768, 256)
SCREEN scr&
_DELAY 0.2
_TITLE "3D Function Plotter"

'--- Init the color palette.
'-----
nc% = 256
RESTORE ColorTab
FOR k% = 0 TO (nc% - 1)
    READ r%, g%, b%
    _PALETTECOLOR k%, (r% * 65536) + (g% * 256) + b%
NEXT k%

'--- Not actually screen sizes, but the limit for calculations.
'-----
scrX% = 740
scrY% = 555

'--- Init some other stuff.
'-----
RANDOMIZE TIMER
DIM CurPlot%(scrX% - 1, scrY% - 1, 2)
stX% = 5 'mesh size (step X)
stY% = 5 'mesh size (step Y)

'--- Select an graphic area and do the math.
'-----
CLS
DO
    'depending on the function you choose some more lines below,
    'you may need to shrink or expand the x/y area to get more
    'detailed graphics
    x1# = -5
    x2# = 5
    y1# = -5
    y2# = 5

    dx# = (x2# - x1#)
    dy# = (y2# - y1#)

    LOCATE 1, 1
    COLOR 128
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

    FOR y% = (scrY% - 1) TO 0 STEP -stY%
        LOCATE 1, 1
        COLOR 128
        PRINT "calculating new graphic:"; 100 - INT(100 / scrY% * y%); "%"
        b# = y1# + (dy# * (y% / scrY%))
        FOR x% = 0 TO (scrX% - 1) STEP stX%
            a# = x1# + (dx# * (x% / scrX%))
            bow# = 3.141592653589793 / 180
            '--------------------------------------------------
            'this are some functions, choose one by uncommenting it and
            'commenting all other, or try to create your own
            c% = (120 * COS((a# * a#) + (b# * b#))) / EXP(((a# * a#) + (b# * b#)) / 5)
            'c% = (30 * SIN(bow# * a# * 80)) - (30 * SIN(bow# * b# * 80))
            'c% = (a# * a# * 5) - (b# * b# * 5)
            '--------------------------------------------------
            xx% = x%
            yy% = y%
            zz% = c%
            XYfrom3D xx%, yy%, zz%
            CurPlot%(x%, y%, 0) = xx% + 2
            CurPlot%(x%, y%, 1) = -zz% + 550
            CurPlot%(x%, y%, 2) = c% + 128
        NEXT x%
    NEXT y%
    LOCATE 1, 1
    COLOR 128
    PRINT "calculating new graphic: 100 %"

    '--- Calculation done, now ask the user for drawing style.
    '-----
    drawMen:
    LOCATE 3, 1
    COLOR 128
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
    PRINT " 7 - change mesh size"
    PRINT " 8 - quit program"
    i$ = ""
    WHILE i$ < "1" OR i$ > "8"
        _LIMIT 50
        i$ = INKEY$
    WEND
    IF i$ = "7" THEN
        i$ = ""
        LOCATE 3, 1
        COLOR 128
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
            IF CurPlot%(x%, y%, 2) > 0 AND CurPlot%(x%, y%, 2) < 256 THEN
                fa% = fa% + CurPlot%(x%, y%, 2)
                pix% = pix% + 1
            END IF
            IF CurPlot%(x% + stX%, y%, 2) > 0 AND CurPlot%(x% + stX%, y%, 2) < 256 THEN
                fa% = fa% + CurPlot%(x% + stX%, y%, 2)
                pix% = pix% + 1
            END IF
            IF CurPlot%(x% + stX%, y% - stY%, 2) > 0 AND CurPlot%(x% + stX%, y% - stY%, 2) < 256 THEN
                fa% = fa% + CurPlot%(x% + stX%, y% - stY%, 2)
                pix% = pix% + 1
            END IF
            IF CurPlot%(x%, y% - stY%, 2) > 0 AND CurPlot%(x%, y% - stY%, 2) < 256 THEN
                fa% = fa% + CurPlot%(x%, y% - stY%, 2)
                pix% = pix% + 1
            END IF
            IF pix% > 0 THEN
                fa% = INT(fa% / pix%)
            ELSE
                fa% = 0
            END IF
            'now do the drawing depending on users choice
            IF i$ = "3" OR i$ = "5" THEN
                DrawFill x%, y%, 16
            ELSEIF i$ = "4" OR i$ = "6" THEN
                DrawFill x%, y%, fa%
            END IF
            IF i$ = "1" OR i$ = "5" OR i$ = "6" THEN
                IF i$ = "1" THEN
                    DrawMesh x%, y%, 16
                ELSEIF i$ = "5" THEN
                    DrawMesh x%, y%, 255
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
DATA &H2F,&H2F,&H2F,&H32,&H2E,&H36,&H34,&H2C,&H3C,&H37,&H2B,&H43
DATA &H39,&H29,&H49,&H3C,&H28,&H50,&H3E,&H26,&H56,&H41,&H25,&H5D
DATA &H43,&H23,&H63,&H46,&H22,&H6A,&H48,&H20,&H70,&H4B,&H1F,&H77
DATA &H4D,&H1D,&H7D,&H50,&H1C,&H84,&H52,&H1A,&H8A,&H55,&H19,&H91
DATA &H57,&H18,&H97,&H5A,&H16,&H9E,&H5C,&H15,&HA4,&H5F,&H13,&HAB
DATA &H61,&H12,&HB1,&H64,&H10,&HB8,&H66,&H0F,&HBE,&H69,&H0D,&HC5
DATA &H6B,&H0C,&HCB,&H6E,&H0A,&HD2,&H70,&H09,&HD8,&H73,&H07,&HDF
DATA &H75,&H06,&HE5,&H78,&H04,&HEC,&H7A,&H03,&HF2,&H7D,&H01,&HF9
DATA &H7F,&H00,&HFF,&H7B,&H00,&HFF,&H77,&H00,&HFF,&H73,&H00,&HFF
DATA &H6F,&H00,&HFF,&H6B,&H00,&HFF,&H67,&H00,&HFF,&H63,&H00,&HFF
DATA &H5F,&H00,&HFF,&H5B,&H00,&HFF,&H57,&H00,&HFF,&H53,&H00,&HFF
DATA &H4F,&H00,&HFF,&H4B,&H00,&HFF,&H47,&H00,&HFF,&H43,&H00,&HFF
DATA &H40,&H00,&HFF,&H3C,&H00,&HFF,&H38,&H00,&HFF,&H34,&H00,&HFF
DATA &H30,&H00,&HFF,&H2C,&H00,&HFF,&H28,&H00,&HFF,&H24,&H00,&HFF
DATA &H20,&H00,&HFF,&H1C,&H00,&HFF,&H18,&H00,&HFF,&H14,&H00,&HFF
DATA &H10,&H00,&HFF,&H0C,&H00,&HFF,&H08,&H00,&HFF,&H04,&H00,&HFF
DATA &H00,&H00,&HFF,&H00,&H08,&HFF,&H00,&H10,&HFF,&H00,&H18,&HFF
DATA &H00,&H20,&HFF,&H00,&H28,&HFF,&H00,&H30,&HFF,&H00,&H38,&HFF
DATA &H00,&H40,&HFF,&H00,&H48,&HFF,&H00,&H50,&HFF,&H00,&H58,&HFF
DATA &H00,&H60,&HFF,&H00,&H68,&HFF,&H00,&H70,&HFF,&H00,&H78,&HFF
DATA &H00,&H80,&HFF,&H00,&H87,&HFF,&H00,&H8F,&HFF,&H00,&H97,&HFF
DATA &H00,&H9F,&HFF,&H00,&HA7,&HFF,&H00,&HAF,&HFF,&H00,&HB7,&HFF
DATA &H00,&HBF,&HFF,&H00,&HC7,&HFF,&H00,&HCF,&HFF,&H00,&HD7,&HFF
DATA &H00,&HDF,&HFF,&H00,&HE7,&HFF,&H00,&HEF,&HFF,&H00,&HF7,&HFF
DATA &H00,&HFF,&HFF,&H00,&HFF,&HF7,&H00,&HFF,&HEF,&H00,&HFF,&HE7
DATA &H00,&HFF,&HDF,&H00,&HFF,&HD7,&H00,&HFF,&HCF,&H00,&HFF,&HC7
DATA &H00,&HFF,&HBF,&H00,&HFF,&HB7,&H00,&HFF,&HAF,&H00,&HFF,&HA7
DATA &H00,&HFF,&H9F,&H00,&HFF,&H97,&H00,&HFF,&H8F,&H00,&HFF,&H87
DATA &H00,&HFF,&H80,&H00,&HFF,&H78,&H00,&HFF,&H70,&H00,&HFF,&H68
DATA &H00,&HFF,&H60,&H00,&HFF,&H58,&H00,&HFF,&H50,&H00,&HFF,&H48
DATA &H00,&HFF,&H40,&H00,&HFF,&H38,&H00,&HFF,&H30,&H00,&HFF,&H28
DATA &H00,&HFF,&H20,&H00,&HFF,&H18,&H00,&HFF,&H10,&H00,&HFF,&H08
DATA &H00,&HFF,&H00,&H08,&HFF,&H00,&H10,&HFF,&H00,&H18,&HFF,&H00
DATA &H20,&HFF,&H00,&H28,&HFF,&H00,&H30,&HFF,&H00,&H38,&HFF,&H00
DATA &H40,&HFF,&H00,&H48,&HFF,&H00,&H50,&HFF,&H00,&H58,&HFF,&H00
DATA &H60,&HFF,&H00,&H68,&HFF,&H00,&H70,&HFF,&H00,&H78,&HFF,&H00
DATA &H80,&HFF,&H00,&H87,&HFF,&H00,&H8F,&HFF,&H00,&H97,&HFF,&H00
DATA &H9F,&HFF,&H00,&HA7,&HFF,&H00,&HAF,&HFF,&H00,&HB7,&HFF,&H00
DATA &HBF,&HFF,&H00,&HC7,&HFF,&H00,&HCF,&HFF,&H00,&HD7,&HFF,&H00
DATA &HDF,&HFF,&H00,&HE7,&HFF,&H00,&HEF,&HFF,&H00,&HF7,&HFF,&H00
DATA &HFF,&HFF,&H00,&HFF,&HF7,&H00,&HFF,&HEF,&H00,&HFF,&HE7,&H00
DATA &HFF,&HDF,&H00,&HFF,&HD7,&H00,&HFF,&HCF,&H00,&HFF,&HC7,&H00
DATA &HFF,&HBF,&H00,&HFF,&HB7,&H00,&HFF,&HAF,&H00,&HFF,&HA7,&H00
DATA &HFF,&H9F,&H00,&HFF,&H97,&H00,&HFF,&H8F,&H00,&HFF,&H87,&H00
DATA &HFF,&H80,&H00,&HFF,&H78,&H00,&HFF,&H70,&H00,&HFF,&H68,&H00
DATA &HFF,&H60,&H00,&HFF,&H58,&H00,&HFF,&H50,&H00,&HFF,&H48,&H00
DATA &HFF,&H40,&H00,&HFF,&H38,&H00,&HFF,&H30,&H00,&HFF,&H28,&H00
DATA &HFF,&H20,&H00,&HFF,&H18,&H00,&HFF,&H10,&H00,&HFF,&H08,&H00
DATA &HFF,&H00,&H00,&HFF,&H00,&H04,&HFF,&H00,&H08,&HFF,&H00,&H0C
DATA &HFF,&H00,&H10,&HFF,&H00,&H14,&HFF,&H00,&H18,&HFF,&H00,&H1C
DATA &HFF,&H00,&H20,&HFF,&H00,&H24,&HFF,&H00,&H28,&HFF,&H00,&H2C
DATA &HFF,&H00,&H30,&HFF,&H00,&H34,&HFF,&H00,&H38,&HFF,&H00,&H3C
DATA &HFF,&H00,&H40,&HFF,&H00,&H43,&HFF,&H00,&H47,&HFF,&H00,&H4B
DATA &HFF,&H00,&H4F,&HFF,&H00,&H53,&HFF,&H00,&H57,&HFF,&H00,&H5B
DATA &HFF,&H00,&H5F,&HFF,&H00,&H63,&HFF,&H00,&H67,&HFF,&H00,&H6B
DATA &HFF,&H00,&H6F,&HFF,&H00,&H73,&HFF,&H00,&H77,&HFF,&H00,&H7B
DATA &HFF,&H00,&H7F,&HF8,&H02,&H7C,&HF2,&H03,&H7A,&HEB,&H05,&H77
DATA &HE4,&H06,&H75,&HDD,&H08,&H72,&HD7,&H09,&H70,&HD0,&H0B,&H6D
DATA &HC9,&H0C,&H6A,&HC3,&H0E,&H68,&HBC,&H0F,&H65,&HB5,&H11,&H63
DATA &HAE,&H12,&H60,&HA8,&H14,&H5D,&HA1,&H15,&H5B,&H9A,&H17,&H58
DATA &H94,&H18,&H56,&H8D,&H1A,&H53,&H86,&H1B,&H51,&H80,&H1D,&H4E
DATA &H79,&H1E,&H4B,&H72,&H20,&H49,&H6B,&H21,&H46,&H65,&H23,&H44
DATA &H5E,&H24,&H41,&H57,&H26,&H3E,&H51,&H27,&H3C,&H4A,&H29,&H39
DATA &H43,&H2A,&H37,&H3C,&H2C,&H34,&H36,&H2D,&H32,&H2F,&H2F,&H2F

'--- Subroutine to build the polygon arrays and call FillPolygon().
'-----
SUB DrawFill (x%, y%, f%)
    SHARED CurPlot%(), stX%, stY%
    REDIM px%(3), py%(3)
    px%(0) = CurPlot%(x%, y%, 0): py%(0) = CurPlot%(x%, y%, 1)
    px%(1) = CurPlot%(x% + stX%, y%, 0): py%(1) = CurPlot%(x% + stX%, y%, 1)
    px%(2) = CurPlot%(x% + stX%, y% - stY%, 0): py%(2) = CurPlot%(x% + stX%, y% - stY%, 1)
    px%(3) = CurPlot%(x%, y% - stY%, 0): py%(3) = CurPlot%(x%, y% - stY%, 1)
    FillPolygon px%(), py%(), f%, -1
END SUB

'--- Subroutine to draw mesh lines.
'-----
SUB DrawMesh (x%, y%, f%)
    SHARED CurPlot%(), stX%, stY%
    PSET (CurPlot%(x%, y%, 0), CurPlot%(x%, y%, 1)), f%
    LINE -(CurPlot%(x% + stX%, y%, 0), CurPlot%(x% + stX%, y%, 1)), f%
    LINE -(CurPlot%(x% + stX%, y% - stY%, 0), CurPlot%(x% + stX%, y% - stY%, 1)), f%
    LINE -(CurPlot%(x%, y% - stY%, 0), CurPlot%(x%, y% - stY%, 1)), f%
    LINE -(CurPlot%(x%, y%, 0), CurPlot%(x%, y%, 1)), f%
END SUB

'--- Subroutine to transform 3D coordinates into 2D,
'--- using simple cavalier perspective.
'-----
SUB XYfrom3D (x%, y%, z%)
    x% = (x% + (y% * .5))
    z% = (z% + (y% * .5))
END SUB

'--- Function to define/return the program's version string.
'-----
FUNCTION Version3dFuncPlot$
    Version3dFuncPlot$ = MID$("$VER: 3dFuncPlot 1.0 (14-Nov-2018) by RhoSigma :END$", 7, 40)
END FUNCTION

