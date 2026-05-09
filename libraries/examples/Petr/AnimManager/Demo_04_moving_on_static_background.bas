' Demo_04_moving_on_static_background.bas
' Multiple animations moving with different speeds over a static generated background.
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
DIM fileName(1 TO 4) AS STRING
DIM animId(1 TO 4) AS LONG
DIM posX(1 TO 4) AS SINGLE
DIM posY(1 TO 4) AS SINGLE
DIM velX(1 TO 4) AS SINGLE
DIM velY(1 TO 4) AS SINGLE
DIM drawW(1 TO 4) AS LONG
DIM drawH(1 TO 4) AS LONG
DIM i AS LONG
DIM keyCode AS LONG
DIM quitFlag AS INTEGER
DIM tickValue AS DOUBLE

screenW = 1280
screenH = 720

fileName(1) = "APPLE.FLI"
fileName(2) = "Animals.gif"
fileName(3) = "drum.ani"
fileName(4) = "3Globes.anim"

posX(1) = 40: posY(1) = 120: velX(1) = 2.20: velY(1) = 1.30: drawW(1) = 230: drawH(1) = 170
posX(2) = 620: posY(2) = 140: velX(2) = -1.80: velY(2) = 2.10: drawW(2) = 260: drawH(2) = 180
posX(3) = 900: posY(3) = 320: velX(3) = -2.40: velY(3) = -1.50: drawW(3) = 170: drawH(3) = 170
posX(4) = 240: posY(4) = 360: velX(4) = 1.50: velY(4) = -1.90: drawW(4) = 260: drawH(4) = 200

screenImage = _NEWIMAGE(screenW, screenH, 32)
SCREEN screenImage
_TITLE "Demo 04 - moving animations on static background"
PRINT "Plase wait, caching ANIM animation"
FOR i = 1 TO 4
    animId(i) = AnimOpen(fileName(i))
    IF animId(i) >= 0 THEN
        AnimSetLoop animId(i), ANIM_LOOP_FOREVER
        AnimStart animId(i)
    END IF
NEXT i

DO
    keyCode = _KEYHIT
    IF keyCode = 27 THEN quitFlag = -1

    FOR i = 1 TO 4
        IF animId(i) >= 0 THEN AnimUpdate animId(i)
    NEXT i

    tickValue = TIMER
    DrawStaticBackground screenW, screenH, tickValue
    _PRINTSTRING (20, 16), "Demo 04: moving animations on a static generated background"
    _PRINTSTRING (20, 38), "Different velocities + bounce logic. Esc = end"

    FOR i = 1 TO 4
        posX(i) = posX(i) + velX(i)
        posY(i) = posY(i) + velY(i)

        IF posX(i) < 12 THEN posX(i) = 12: velX(i) = -velX(i)
        IF posY(i) < 72 THEN posY(i) = 72: velY(i) = -velY(i)
        IF posX(i) + drawW(i) > screenW - 12 THEN posX(i) = screenW - 12 - drawW(i): velX(i) = -velX(i)
        IF posY(i) + drawH(i) > screenH - 12 THEN posY(i) = screenH - 12 - drawH(i): velY(i) = -velY(i)

        LINE (INT(posX(i)) - 2, INT(posY(i)) - 20)-(INT(posX(i)) + drawW(i) + 1, INT(posY(i)) + drawH(i) + 1), _RGBA32(0, 0, 0, 130), BF
        LINE (INT(posX(i)) - 2, INT(posY(i)) - 20)-(INT(posX(i)) + drawW(i) + 1, INT(posY(i)) + drawH(i) + 1), _RGB32(240, 240, 255), B
        _PRINTSTRING (INT(posX(i)) + 8, INT(posY(i)) - 14), fileName(i)
        IF animId(i) >= 0 THEN
            DrawAnimFit animId(i), INT(posX(i)), INT(posY(i)), drawW(i), drawH(i)
        END IF
    NEXT i

    _DISPLAY
    _LIMIT 60
LOOP UNTIL quitFlag

AnimFreeAll
CHDIR oldDir
IF screenImage <= -2 THEN SCREEN 0: _FREEIMAGE screenImage: screenImage = 0
END

SUB DrawStaticBackground (screenW AS LONG, screenH AS LONG, tickValue AS DOUBLE)
    DIM i AS LONG
    DIM hillY AS LONG
    DIM lineY AS LONG
    DIM pulseValue AS LONG

    CLS , _RGB32(20, 24, 34)

    FOR i = 0 TO screenH STEP 32
        lineY = i
        LINE (0, lineY)-(screenW - 1, lineY), _RGB32(28, 34, 46)
    NEXT i

    FOR i = 0 TO screenW STEP 32
        LINE (i, 0)-(i, screenH - 1), _RGB32(24, 30, 42)
    NEXT i

    pulseValue = 40 + CLNG((SIN(tickValue * 1.4) + 1) * 20)
    LINE (0, screenH - 140)-(screenW - 1, screenH - 1), _RGB32(18, 36, 18), BF

    FOR i = 0 TO screenW - 1 STEP 8
        hillY = screenH - 210 + CLNG(SIN((i / 90#) + tickValue * 0.3) * 22)
        LINE (i, hillY)-(i, screenH - 140), _RGB32(40, 90 + pulseValue, 60)
    NEXT i

    CIRCLE (screenW - 170, 120), 56, _RGB32(230, 230, 160)
    PAINT (screenW - 170, 120), _RGB32(200, 200, 120), _RGB32(230, 230, 160)
END SUB

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

