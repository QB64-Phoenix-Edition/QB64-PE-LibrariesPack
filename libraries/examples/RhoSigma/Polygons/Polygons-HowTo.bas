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
'| === Polygons-HowTo.bas ===                                        |
'|                                                                   |
'| == A short example to show the usage of the PolygonInPolygon(),   |
'| == PointInPolygon() and FillPolygon() functions in "polygons.bm". |
'|                                                                   |
'+-------------------------------------------------------------------+
'| Done by RhoSigma, R.Heyder, provided AS IS, use at your own risk. |
'| Find me in the QB64 Forum or mail to support@rhosigma-cw.net for  |
'| any questions or suggestions. Thanx for your interest in my work. |
'+-------------------------------------------------------------------+

'========================
'=== How does it work ===
'========================
'=== This program draws two random polygons and fills them with color,
'=== green for the "source" polygon and yellow for the "check" polygon.
'=== After that it draws a circle degree by degree, if the respective
'=== pixel is inside the green source polygon, then it is set in green
'=== color, if the pixel is not in the green, but in the yellow check
'=== polygon, then it is set in yellow color, if it is otherwise outside
'=== of both polygons, then it is set in red color.
'=== Also a text is printed, how many percent of the yellow check polygon
'=== does overlap with the green source polygon.

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'RhoSigma/Polygons'

'--- Setup a graphics screen.
'-----
scr& = _NEWIMAGE(640, 480, 32)
SCREEN scr&
_DELAY 0.2
_TITLE "Polygons-HowTo Output"

'--- Define some colors.
'--- Important: 32-bit colors must be unsigned long (~&).
'-----
CONST oBlack = &HFF000000~& 'opaque black
CONST oWhite = &HFFFFFFFF~& 'opaque white
CONST oRed = &HFFFF0000~& 'opaque red
CONST oGreen = &HFF00FF00~& 'opaque green
CONST oYellow = &HFFFFFF00~& 'opaque yellow
CONST tGreen = &H6000FF00~& 'transparent green
CONST tYellow = &H60FFFF00~& 'transparent yellow

'--- Set the number of polygon corners and DIM polygon arrays.
'-----
cor% = 4 'actually 5 corners (0-4)
DIM spx%(0 TO cor%), spy%(0 TO cor%) 'the source polygon
DIM cpx%(0 TO cor%), cpy%(0 TO cor%) 'the polygon to check

'--- Start of main loop.
'-----
restart:
CLS , oBlack

'--- Get random values for the polygons its corners.
'-----
RANDOMIZE TIMER
FOR i% = 0 TO cor%
    spx%(i%) = RangeRand%(30, 610)
    spy%(i%) = RangeRand%(50, 450)
    cpx%(i%) = RangeRand%(30, 610)
    cpy%(i%) = RangeRand%(50, 450)
NEXT i%

'--- Now fill the source polygon.
'-----
FillPolygon spx%(), spy%(), tGreen, oWhite

'--- Then check the "check" polygon vs. the "source" polygon.
'-----
LOCATE 1, 1
COLOR oWhite
PRINT "Approx.";
PRINT RTRIM$(STR$(PolygonInPolygon%(cpx%(), cpy%(), spx%(), spy%(), tYellow, tYellow, oWhite)));
PRINT "% of the yellow polygon's surface do overlap with the green polygon,";

'--- Finally draw a circle degree by degree with colors
'--- depending on the PointInPolygon%() result.
'-----
bow# = 3.141592653589793 / 180
FOR ang% = 0 TO 360
    xc% = 100 * COS(bow# * ang%) + 320
    yc% = 100 * SIN(bow# * ang%) + 240
    IF PointInPolygon%(xc%, yc%, spx%(), spy%(), -1, -1) THEN
        LINE (xc% - 1, yc% - 1)-(xc% + 1, yc% + 1), oGreen, BF
    ELSEIF PointInPolygon%(xc%, yc%, cpx%(), cpy%(), -1, -1) THEN
        LINE (xc% - 1, yc% - 1)-(xc% + 1, yc% + 1), oYellow, BF
    ELSE
        LINE (xc% - 1, yc% - 1)-(xc% + 1, yc% + 1), oRed, BF
    END IF
NEXT ang%

'--- Visualize the source polygon's corners.
'-----
_PRINTMODE _KEEPBACKGROUND
FOR i% = 0 TO cor%
    LINE (spx%(i%) - 1, spy%(i%) - 1)-(spx%(i%) + 1, spy%(i%) + 1), oWhite, BF
    COLOR oWhite
    _PRINTSTRING (spx%(i%) + 5, spy%(i%)), "SP" + LTRIM$(STR$(i%))
NEXT i%

'--- Visualize the check polygon's corners.
'-----
_PRINTMODE _KEEPBACKGROUND
FOR i% = 0 TO cor%
    LINE (cpx%(i%) - 1, cpy%(i%) - 1)-(cpx%(i%) + 1, cpy%(i%) + 1), oWhite, BF
    COLOR oWhite
    _PRINTSTRING (cpx%(i%) + 5, cpy%(i%)), "CP" + LTRIM$(STR$(i%))
NEXT i%

'--- Wait before restart or quit.
'-----
LOCATE 2, 1
PRINT "press 'q' to quit or any other key to restart ..."
i$ = ""
WHILE i$ = ""
    _LIMIT 20
    i$ = INKEY$
WEND
IF i$ <> "q" GOTO restart

'--- Cleanup screen and quit.
'-----
SCREEN 0
_FREEIMAGE scr&
SYSTEM

'--- Function to get a integer random number in the given range.
'-----
FUNCTION RangeRand% (low%, high%)
    RangeRand% = INT(RND(1) * (high% - low% + 1)) + low%
END FUNCTION

'--- Function to define/return the program's version string.
'-----
FUNCTION VersionPolygonsHowTo$
    VersionPolygonsHowTo$ = MID$("$VER: Polygons-HowTo 1.0 (14-Nov-2018) by RhoSigma :END$", 7, 44)
END FUNCTION

