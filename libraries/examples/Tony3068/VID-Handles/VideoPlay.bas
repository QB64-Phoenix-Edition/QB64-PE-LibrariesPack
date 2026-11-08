'==============================================================================
' Plays an SPV video OR any standard video through VID-HANDLES
'------------------------------------------------------------------------------
' Usage:  VID-DEMO.EXE  myvideo.mp4        (or myvideo.spv, or a URL)
' Keys :  SPACE pause/resume   LEFT/RIGHT seek 10 s   UP/DOWN volume
'         L loop on/off        ESC quit
'==============================================================================

$USELIBRARY:'Tony3068/VID-Handles'

'--- Find QB64-PE and Example source folders depending on EXE location.
'-----
'Fill example$ and library$ with the exact names, i.e. the use of upper/lower
'case must match, so that it works on case sensitive Linux filesystems.
DIM example$: example$ = "VideoPlay.bas" 'this example's source file name
DIM library$: library$ = "Tony3068/VID-Handles" 'the library's name (as in $USELIBRARY)
DIM qbDir$, srcDir$ 'filled automatically (with trailing slash)
'-----
IF _FILEEXISTS(example$) THEN
    srcDir$ = _CWD$ 'compiled to "Source Folder"
    qbDir$ = LEFT$(srcDir$, LEN(srcDir$) - LEN(library$) - 20)
ELSEIF _FILEEXISTS("qb64pe.exe") _ORELSE _FILEEXISTS("qb64pe") THEN
    qbDir$ = _CWD$ 'compiled to the QB64-PE folder (default)
    srcDir$ = qbDir$ + "libraries/examples/" + library$ + "/"
ELSE
    'The example was compiled to a user selected location, we have
    'to ask the user to give us a hint.
    qbDir$ = _SELECTFOLDERDIALOG$("Please locate your QB64-PE main folder...")
    IF LEN(qbDir$) > 0 _ANDALSO (_FILEEXISTS(qbDir$ + "/qb64pe.exe") _ORELSE _FILEEXISTS(qbDir$ + "/qb64pe")) THEN
        'Now we can set our paths building on the selected folder.
        qbDir$ = qbDir$ + "/"
        srcDir$ = qbDir$ + "libraries/examples/" + library$ + "/"
    ELSE
        'The user didn't respond correctly, end with error message.
        PRINT
        PRINT "ERROR: Can't locate required assets, please run again and"
        PRINT "       select your QB64-PE folder when ask for it."
        END
    END IF
END IF
CHDIR srcDir$ 'Change into the example's source folder, in alternative
'             'use qbDir$ or srcDir$ directly where applicable.
'-----------------------------------------------------

DIM v AS LONG, T1 AS LONG
DIM k$, file$
DIM p AS SINGLE, vol AS SINGLE
DIM looping AS INTEGER, first AS INTEGER

file$ = COMMAND$
IF file$ = "" THEN file$ = _OPENFILEDIALOG$("OPEN VIDEO FILE", _CWD$ + "RADAR.SPV", "*.spv|*.SPV|*.mp4|*.MP4|*.webm|*.WEBM|*.avi|*.AVI|*.mpg|*.MPG|*.mov|*.MOV|*.mpeg|*.MPEG")
IF file$ = "" THEN SYSTEM

SCREEN _NEWIMAGE(1280, 720, 32)
_DELAY 0.2
_SCREENMOVE _MIDDLE

' Only needed for SPV videos, harmless for the others.
T1 = _FREETIMER
ON TIMER(T1, VID_TICK_SECONDS) VIDTICK
TIMER(T1) ON

v = VIDOPEN(file$)
IF v = 0 THEN
    PRINT VIDERROR$
    SLEEP 5
    END
END IF

vol = 1
looping = -1
VIDLOOP v
first = -1

DO
    IF VIDNEWFRAME(v) OR first THEN
        first = 0
        CLS
        ' VIDPUT crops (SPV "K" videos), applies the playback aspect ratio
        ' (SPV hint N/W/T/K) and centers the picture inside the box.
        VIDPUT v, 0, 0, _WIDTH - 1, _HEIGHT - 1
        IF VIDTYPE(v) = VID_TYPE_SPV THEN k$ = "SPV" ELSE k$ = "VLC"
        _PRINTSTRING (8, 8), k$ + " hint:" + VIDHINT$(v) + "  " + STR$(INT(VIDGETPOS(v))) + " /" + STR$(INT(VIDLEN(v))) + " s   vol" + STR$(INT(vol * 100)) + "%"
        _DISPLAY
    END IF

    k$ = INKEY$
    SELECT CASE k$
        CASE CHR$(27): EXIT DO
        CASE " "
            IF VIDPAUSED(v) THEN
                IF looping THEN VIDLOOP v ELSE VIDPLAY v
            ELSE
                VIDPAUSE v
            END IF
        CASE CHR$(0) + "M": p = VIDGETPOS(v) + 10: VIDSETPOS v, p
        CASE CHR$(0) + "K": p = VIDGETPOS(v) - 10: VIDSETPOS v, p
        CASE CHR$(0) + "H": vol = vol + .1: IF vol > 1 THEN vol = 1
            VIDVOL v, vol
        CASE CHR$(0) + "P": vol = vol - .1: IF vol < 0 THEN vol = 0
            VIDVOL v, vol
        CASE "l", "L"
            looping = NOT looping
            IF looping THEN VIDLOOP v ELSE VIDPLAY v
    END SELECT

    IF NOT VIDPLAYING(v) AND NOT VIDPAUSED(v) THEN EXIT DO
    _LIMIT 120
LOOP

VIDCLOSEALL
SYSTEM

