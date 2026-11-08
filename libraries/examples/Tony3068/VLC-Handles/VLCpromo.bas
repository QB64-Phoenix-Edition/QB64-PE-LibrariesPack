$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'Tony3068/VLC-Handles'

DIM V AS LONG
DIM Scrn AS LONG
DIM NWidth AS INTEGER
DIM NHeight AS INTEGER
DIM PAUSED AS INTEGER
DIM C AS LONG
PAUSED = _FALSE

PRINT "ATTENTION:"
PRINT "  Make sure you're online, this example will stream a video from the web!"
PRINT
PRINT "press any key when ready..."
SLEEP

F$ = "https://images.videolan.org/images/vlc-player.mp4"
IF F$ = "" THEN
    SYSTEM
ELSE
    V = VLCOPEN(F$)
    NWidth = VLCWIDTH(V)
    NHeight = VLCHEIGHT(V)
    IF NHeight >= _DESKTOPHEIGHT THEN
        NHeight = _DESKTOPHEIGHT - (_DESKTOPHEIGHT * .1)
        NWidth = (VLCWIDTH(V) / VLCHEIGHT(V)) * NHeight
    END IF
    Scrn = _NEWIMAGE(NWidth, NHeight, 32)
    SCREEN Scrn
    _DELAY 0.2
    _TITLE F$
    _SCREENMOVE _MIDDLE
END IF

VLCPLAY V

DO
    _PUTIMAGE , VLCIMAGE(V)
    _DISPLAY
    C = _KEYHIT
    SELECT CASE C
        CASE 32
            IF PAUSED THEN
                VLCPLAY V
            ELSE
                VLCPAUSE V
            END IF
            PAUSED = NOT PAUSED
        CASE 27
            VLCSTOP V
            EXIT DO
    END SELECT
    _LIMIT 120
    IF NOT VLCPLAYING(V) AND NOT PAUSED THEN EXIT DO
LOOP
SCREEN 0
_FREEIMAGE Scrn
_AUTODISPLAY

SYSTEM

