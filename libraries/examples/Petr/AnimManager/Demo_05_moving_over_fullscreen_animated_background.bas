' Demo_05_moving_over_fullscreen_animated_background.bas
' Foreground animations move over a fullscreen animated background.
' Esc = end.

OPTION _EXPLICIT

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'Petr/AnimManager'

'--- Find the root of the program's source folder.
DIM AS STRING sep, root, qbfo, filename, oldDir
oldDir = _CWD$
$IF WIN THEN
    sep$ = "\"
$ELSE
    sep$ = "/"
$END IF
filename$ = MID$(COMMAND$(0), _INSTRREV(COMMAND$(0), sep$) + 1)
filename$ = MID$(filename$, 1, LEN(filename$) - 4) + ".bas"

IF _FILEEXISTS(filename$) THEN
    root$ = ""
ELSEIF _FILEEXISTS("qb64pe.exe") _ORELSE _FILEEXISTS("qb64pe") THEN
    root$ = "libraries\examples\Petr\AnimManager\"
    CHDIR root$
ELSE
    qbfo$ = _SELECTFOLDERDIALOG$("Please locate your QB64-PE main folder...")
    IF LEN(qbfo$) > 0 _ANDALSO (_FILEEXISTS(qbfo$ + "\qb64pe.exe") _ORELSE _FILEEXISTS(qbfo$ + "\qb64pe")) THEN
        root$ = qbfo$ + "\libraries\examples\Petr\AnimManager\"
    ELSE
        PRINT
        PRINT "ERROR: Can't locate the program's source folder, please run again"
        PRINT "       and select your QB64-PE folder when ask for it."
        END
    END IF
END IF
'-----

DIM screenImage AS LONG
DIM screenW AS LONG
DIM screenH AS LONG
DIM bgAnim AS LONG
DIM fileName(1 TO 3) AS STRING
DIM animId(1 TO 3) AS LONG
DIM posX(1 TO 3) AS SINGLE
DIM posY(1 TO 3) AS SINGLE
DIM velX(1 TO 3) AS SINGLE
DIM velY(1 TO 3) AS SINGLE
DIM drawW(1 TO 3) AS LONG
DIM drawH(1 TO 3) AS LONG
DIM i AS LONG
DIM keyCode AS LONG
DIM quitFlag AS INTEGER

screenW = 1280
screenH = 720

fileName(1) = "Biker.png"
fileName(2) = "phoenix.ani"
fileName(3) = "BALLOON.FLC"

posX(1) = 80: posY(1) = 110: velX(1) = 2.10: velY(1) = 1.00: drawW(1) = 180: drawH(1) = 180
posX(2) = 900: posY(2) = 120: velX(2) = -2.40: velY(2) = 1.80: drawW(2) = 180: drawH(2) = 180
posX(3) = 280: posY(3) = 340: velX(3) = 1.60: velY(3) = -1.60: drawW(3) = 320: drawH(3) = 220

screenImage = _NEWIMAGE(screenW, screenH, 32)
SCREEN screenImage
_TITLE "Demo 05 - moving foreground over fullscreen animated background"

bgAnim = AnimOpen("elephant.png")
IF bgAnim >= 0 THEN AnimSetLoop bgAnim, ANIM_LOOP_FOREVER: AnimStart bgAnim

FOR i = 1 TO 3
    animId(i) = AnimOpen(fileName(i))
    IF animId(i) >= 0 THEN
        AnimSetLoop animId(i), ANIM_LOOP_FOREVER
        AnimStart animId(i)
    END IF
NEXT i

DO
    keyCode = _KEYHIT
    IF keyCode = 27 THEN quitFlag = -1

    IF bgAnim >= 0 THEN AnimUpdate bgAnim
    FOR i = 1 TO 3
        IF animId(i) >= 0 THEN AnimUpdate animId(i)
    NEXT i

    CLS , _RGB32(127)
    IF bgAnim >= 0 THEN DrawAnimFit bgAnim, 0, 0, screenW, screenH

    LINE (0, 0)-(screenW - 1, 64), _RGBA32(0, 0, 0, 180), BF
    _PRINTSTRING (18, 18), "Demo 05: animated fullscreen background + moving foreground objects"
    _PRINTSTRING (18, 40), "Background: elephant.png    Esc = end"

    FOR i = 1 TO 3
        posX(i) = posX(i) + velX(i)
        posY(i) = posY(i) + velY(i)

        IF posX(i) < 10 THEN posX(i) = 10: velX(i) = -velX(i)
        IF posY(i) < 74 THEN posY(i) = 74: velY(i) = -velY(i)
        IF posX(i) + drawW(i) > screenW - 10 THEN posX(i) = screenW - 10 - drawW(i): velX(i) = -velX(i)
        IF posY(i) + drawH(i) > screenH - 10 THEN posY(i) = screenH - 10 - drawH(i): velY(i) = -velY(i)

        LINE (INT(posX(i)) - 2, INT(posY(i)) - 20)-(INT(posX(i)) + drawW(i) + 1, INT(posY(i)) + drawH(i) + 1), _RGBA32(0, 0, 0, 140), BF
        LINE (INT(posX(i)) - 2, INT(posY(i)) - 20)-(INT(posX(i)) + drawW(i) + 1, INT(posY(i)) + drawH(i) + 1), _RGB32(255, 255, 255), B
        _PRINTSTRING (INT(posX(i)) + 8, INT(posY(i)) - 14), fileName(i)
        IF animId(i) >= 0 THEN DrawAnimFit animId(i), INT(posX(i)), INT(posY(i)), drawW(i), drawH(i)
    NEXT i

    _DISPLAY
    _LIMIT 60
LOOP UNTIL quitFlag

AnimFreeAll
CHDIR oldDir
IF screenImage <= -2 THEN SCREEN 0: _FREEIMAGE screenImage: screenImage = 0
END

SUB DrawAnimFit (animId AS LONG, boxX AS LONG, boxY AS LONG, boxW AS LONG, boxH AS LONG)
    DIM srcW AS LONG
    DIM srcH AS LONG
    DIM drawW AS LONG
    DIM drawH AS LONG
    DIM drawX AS LONG
    DIM drawY AS LONG
    DIM scaleX AS DOUBLE
    DIM scaleY AS DOUBLE
    DIM scaleValue AS DOUBLE

    IF AnimValid(animId) = 0 THEN EXIT SUB

    srcW = AnimWidth(animId)
    srcH = AnimHeight(animId)
    IF srcW <= 0 OR srcH <= 0 THEN EXIT SUB
    IF boxW <= 0 OR boxH <= 0 THEN EXIT SUB

    scaleX = boxW / srcW
    scaleY = boxH / srcH

    IF scaleX < scaleY THEN
        scaleValue = scaleX
    ELSE
        scaleValue = scaleY
    END IF

    IF scaleValue <= 0 THEN EXIT SUB

    drawW = CLNG(srcW * scaleValue)
    drawH = CLNG(srcH * scaleValue)
    IF drawW < 1 THEN drawW = 1
    IF drawH < 1 THEN drawH = 1

    drawX = boxX + (boxW - drawW) \ 2
    drawY = boxY + (boxH - drawH) \ 2

    AnimDrawWindow drawX, drawY, drawX + drawW - 1, drawY + drawH - 1, animId
END SUB

