'=====================
'=== Charsets Test ===
'=====================
'=== This example shall mainly demonstrate the use of the various UTF-8
'=== conversion routines of the charsets library.
'=====
'=== Note that correct printing depends on the used font.
'=== Arial Unicode MS is the only font I've found so far, which contains
'=== all chars used in this short test program. Of course, you can also
'=== try any other unicode enabled font, but it may missing some of the
'=== chars used here and print just spaces or the unicode replacement
'=== character instead.
'=====
'=== If you don't have the Arial Unicode MS font, then goto
'===  https://www.download-free-fonts.com/details/88978/arial-unicode-ms
'=== for free download. Install the font or just drop it anywhere and
'=== change the _LOADFONT line below accordingly.
'=====================================================================

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'RhoSigma/Charsets'

SCREEN _NEWIMAGE(800, 600, 32)
f& = _LOADFONT(_DIR$("FONTS") + "arialuni.ttf", 32)
IF f& > 0 THEN _FONT f&: ELSE PRINT "Font not found, read file header!": END

'as the string used here contains regular ASCII (0-127) only,
'we don't even need any UTF-8 conversion routine
_UPRINTSTRING (0, 0), "Active codepage: " + GetAnsiCodepage$

utf$ = UnicodeToUtf8Char$(26862)
eng$ = "Forest (in Japanese)"
COLOR &HFF00FF00: _UPRINTSTRING (0, 50), utf$, , 8
COLOR &HFFFFFFFF: _UPRINTSTRING (0, 90), eng$

utf$ = UnicodeStringToUtf8Text$("45208,45716,32,81,66,54,52,47484,32,51339,50500,54620,45796,46")
eng$ = "I like QB64. (in Korean)"
COLOR &HFFFF0000: _UPRINTSTRING (0, 150), utf$, , 8
COLOR &HFFFFFFFF: _UPRINTSTRING (0, 190), eng$

REDIM uc&(1 TO 5)
uc&(1) = 64: uc&(2) = 1244: uc&(3) = &H2648: uc&(4) = 252: uc&(5) = &H2764
utf$ = UnicodeArrayToUtf8Text$(uc&())
eng$ = "Just some nonsense read from array."
COLOR &HFF0080FF: _UPRINTSTRING (0, 250), utf$, , 8
COLOR &HFFFFFFFF: _UPRINTSTRING (0, 290), eng$

RESTORE UnicodeData
utf$ = UnicodeDataToUtf8Text$
eng$ = "More nonsense read from DATA."
COLOR &HFF0080FF: _UPRINTSTRING (0, 350), utf$, , 8
COLOR &HFFFFFFFF: _UPRINTSTRING (0, 390), eng$

utf$ = AnsiTextToUtf8Text$("Käsesoße Rührlöffel", "Win1252")
eng$ = "Cheese sauce mixing spoon (in German)"
COLOR &HFFFFFF00: _UPRINTSTRING (0, 450), utf$, , 8
COLOR &HFFFFFFFF: _UPRINTSTRING (0, 490), eng$

SLEEP
SYSTEM

UnicodeData:
DATA 5
DATA 64,1246,&H264C,230,&H2740

'--- Function to define/return the program's version string.
'-----
FUNCTION VersionCharsetsTest$
    VersionCharsetsTest$ = MID$("$VER: CharsetsTest 1.2 (15-Aug-2025) by RhoSigma :END$", 7, 42)
END FUNCTION

