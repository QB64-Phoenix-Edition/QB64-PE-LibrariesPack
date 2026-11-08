$USELIBRARY:'Tony3068/SPV-Handles'

OPTION _EXPLICIT

'--- Find QB64-PE and Example source folders depending on EXE location.
'-----
'Fill example$ and library$ with the exact names, i.e. the use of upper/lower
'case must match, so that it works on case sensitive Linux filesystems.
DIM example$: example$ = "SpaceFlight.bas" 'this example's source file name
DIM library$: library$ = "Tony3068/SPV-Handles" 'the library's name (as in $USELIBRARY)
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

DIM SHARED COCKPIT AS LONG
DIM SHARED COCKPIT_ORG AS LONG
DIM STARS AS LONG
DIM RADAR AS LONG
DIM SHARED sStatic AS LONG
DIM SHARED VidMsg AS LONG

DIM SHARED MSG_ACTIVE AS INTEGER

DIM T1
DIM X AS INTEGER
DIM Y AS INTEGER
DIM SHARED TCOL AS _UNSIGNED LONG

' RightMost Cockpit Monitor

CONST RX1 = 1088
CONST RY1 = 592
CONST RX2 = 1170
CONST RY2 = 618
CONST RX3 = 992
CONST RY3 = 654
CONST RX4 = 1073
CONST RY4 = 683

CONST LX1 = 90
CONST LY1 = 629
CONST LX2 = 193
CONST LY2 = 595
CONST LX3 = 180
CONST LY3 = 690
CONST LX4 = 281
CONST LY4 = 654

COCKPIT = _LOADIMAGE("cockpit.png", 32)

X = 0
Y = _HEIGHT(COCKPIT) \ 3
_SOURCE COCKPIT
DO
    TCOL = POINT(X, Y)
    X = X + 1
LOOP UNTIL (_GREEN32(TCOL) > 200) OR X > _WIDTH(COCKPIT)

_CLEARCOLOR _RGB32(_RED32(TCOL), _GREEN32(TCOL), _BLUE32(TCOL)), COCKPIT
COCKPIT_ORG = _COPYIMAGE(COCKPIT)

SCREEN _NEWIMAGE(_WIDTH(COCKPIT), _HEIGHT(COCKPIT), 32)
_DELAY 0.2
_SCREENMOVE _MIDDLE

_TITLE "Flying through the STARS !"

STARS = SPVOPEN("warp.spv")
IF STARS = 0 THEN PRINT SPVERROR: END

RADAR = SPVOPEN("RADAR.SPV")
IF RADAR = 0 THEN PRINT SPVERROR: END

sStatic = SPVOPEN("glitch1.spv")
IF sStatic = 0 THEN PRINT SPVERROR: END

T1 = _FREETIMER
ON TIMER(T1, .01) SPVTICK
TIMER(T1) ON

SPVLOOP STARS
SPVLOOP RADAR
SPVLOOP sStatic

_SOURCE 0
_DEST 0
LINE (0, 0)-(_WIDTH, _HEIGHT), _RGB32(220, 0, 20, 255), BF

DO
    _PUTIMAGE , SPVIMAGE(STARS)
    PUT_RIGHTSCREEN SPVIMAGE(RADAR)

    IF MSG_ACTIVE THEN
        PUT_LEFTSCREEN SPVIMAGE(VidMsg)
        IF NOT SPVPLAYING(VidMsg) THEN MSG_CLEANUP
    ELSE
        PUT_LEFTSCREEN SPVIMAGE(sStatic)
        IF INT(RND * 600) > 595 THEN START_MESSAGE GET_RANDOM_MSG
    END IF
    _PUTIMAGE , COCKPIT
    _DISPLAY
    _LIMIT 120
LOOP UNTIL _KEYDOWN(27)
SYSTEM

FUNCTION GET_RANDOM_MSG$
DIM C AS INTEGER
RANDOMIZE TIMER
C = INT(RND * 2) + 1
SELECT CASE C
    CASE 1
        GET_RANDOM_MSG$ = "VOLTAR.SPV"
    CASE 2
        GET_RANDOM_MSG$ = "BABYLON5.SPV"
END SELECT
END FUNCTION

SUB START_MESSAGE (SPV_FILE$)
SPVPAUSE sStatic
VidMsg = SPVOPEN(SPV_FILE$)
IF VidMsg = 0 THEN PRINT SPVERROR: END
SPVPLAY VidMsg
MSG_ACTIVE = _TRUE
END SUB

SUB MSG_CLEANUP
SPVCLOSE VidMsg
SPVLOOP sStatic
MSG_ACTIVE = _FALSE
END SUB

SUB PUT_RIGHTSCREEN (IMG AS LONG)
_MAPTRIANGLE (0, 0)-(_WIDTH(IMG) - 1, _HEIGHT(IMG) - 1)-(0, _HEIGHT(IMG) - 1), IMG TO(RX1, RY1)-(RX4, RY4)-(RX3, RY3), COCKPIT
_MAPTRIANGLE (0, 0)-(_WIDTH(IMG) - 1, 0)-(_WIDTH(IMG) - 1, _HEIGHT(IMG) - 1), IMG TO(RX1, RY1)-(RX2, RY2)-(RX4, RY4), COCKPIT
END SUB

SUB PUT_LEFTSCREEN (IMG AS LONG)
_MAPTRIANGLE (0, 0)-(_WIDTH(IMG) - 1, _HEIGHT(IMG) - 1)-(0, _HEIGHT(IMG) - 1), IMG TO(LX1, LY1)-(LX4, LY4)-(LX3, LY3), COCKPIT
_MAPTRIANGLE (0, 0)-(_WIDTH(IMG) - 1, 0)-(_WIDTH(IMG) - 1, _HEIGHT(IMG) - 1), IMG TO(LX1, LY1)-(LX2, LY2)-(LX4, LY4), COCKPIT
END SUB

SUB RESTORE_COCKPIT
_FREEIMAGE COCKPIT
COCKPIT = _COPYIMAGE(COCKPIT_ORG)
END SUB

