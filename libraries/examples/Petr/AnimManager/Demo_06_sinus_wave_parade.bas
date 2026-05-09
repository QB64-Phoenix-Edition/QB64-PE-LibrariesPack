' Demo_06_sinus_wave_parade.bas
' Multiple animations travel horizontally while following sine-wave vertical motion.
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
DIM fileName(1 TO 5) AS STRING
DIM animId(1 TO 5) AS LONG
DIM posX(1 TO 5) AS SINGLE
DIM baseY(1 TO 5) AS SINGLE
DIM speedValue(1 TO 5) AS SINGLE
DIM amplitudeValue(1 TO 5) AS SINGLE
DIM phaseOffset(1 TO 5) AS SINGLE
DIM drawW(1 TO 5) AS LONG
DIM drawH(1 TO 5) AS LONG
DIM i AS LONG
DIM keyCode AS LONG
DIM quitFlag AS INTEGER
DIM phaseSec AS DOUBLE
DIM yNow AS LONG

screenW = 1360
screenH = 760

fileName(1) = "Belinda.fli"
fileName(2) = "test.FLC"
fileName(3) = "valkyrie.anim"
fileName(4) = "drum.ani"
fileName(5) = "G-avatar.gif"

posX(1) = 0: baseY(1) = 110: speedValue(1) = 2.1: amplitudeValue(1) = 26: phaseOffset(1) = 0.0: drawW(1) = 220: drawH(1) = 160
posX(2) = 260: baseY(2) = 220: speedValue(2) = 1.7: amplitudeValue(2) = 34: phaseOffset(2) = 0.8: drawW(2) = 150: drawH(2) = 150
posX(3) = 560: baseY(3) = 340: speedValue(3) = 1.4: amplitudeValue(3) = 42: phaseOffset(3) = 1.4: drawW(3) = 240: drawH(3) = 180
posX(4) = 860: baseY(4) = 500: speedValue(4) = 2.6: amplitudeValue(4) = 30: phaseOffset(4) = 2.1: drawW(4) = 170: drawH(4) = 170
posX(5) = 1100: baseY(5) = 610: speedValue(5) = 1.2: amplitudeValue(5) = 24: phaseOffset(5) = 2.7: drawW(5) = 220: drawH(5) = 200

screenImage = _NEWIMAGE(screenW, screenH, 32)
SCREEN screenImage
_TITLE "Demo 06 - sinus wave parade"

FOR i = 1 TO 5
    animId(i) = AnimOpen(fileName(i))
    IF animId(i) >= 0 THEN
        AnimSetLoop animId(i), ANIM_LOOP_FOREVER
        AnimStart animId(i)
    END IF
NEXT i

DO
    keyCode = _KEYHIT
    IF keyCode = 27 THEN quitFlag = -1

    FOR i = 1 TO 5
        IF animId(i) >= 0 THEN AnimUpdate animId(i)
    NEXT i

    phaseSec = TIMER
    DrawWaveBackground screenW, screenH, phaseSec
    _PRINTSTRING (20, 18), "Demo 06: sinus-wave movement"
    _PRINTSTRING (20, 40), "Several formats follow different amplitudes and speeds. Esc = end"

    FOR i = 1 TO 5
        posX(i) = posX(i) + speedValue(i)
        IF posX(i) > screenW + 20 THEN posX(i) = -drawW(i) - 20

        yNow = CLNG(baseY(i) + SIN(phaseSec * 2.2 + phaseOffset(i) + (posX(i) / 180#)) * amplitudeValue(i))

        LINE (INT(posX(i)) - 2, yNow - 20)-(INT(posX(i)) + drawW(i) + 1, yNow + drawH(i) + 1), _RGBA32(0, 0, 0, 120), BF
        LINE (INT(posX(i)) - 2, yNow - 20)-(INT(posX(i)) + drawW(i) + 1, yNow + drawH(i) + 1), _RGB32(235, 235, 255), B
        _PRINTSTRING (INT(posX(i)) + 8, yNow - 14), fileName(i)
        IF animId(i) >= 0 THEN DrawAnimFit animId(i), INT(posX(i)), yNow, drawW(i), drawH(i)
    NEXT i

    _DISPLAY
    _LIMIT 60
LOOP UNTIL quitFlag

AnimFreeAll
CHDIR oldDir
IF screenImage <= -2 THEN SCREEN 0: _FREEIMAGE screenImage: screenImage = 0
END

SUB DrawWaveBackground (screenW AS LONG, screenH AS LONG, phaseSec AS DOUBLE)
    DIM i AS LONG
    DIM yLine AS LONG
    DIM waveY AS LONG

    CLS , _RGB32(12, 16, 28)

    FOR i = 0 TO screenH - 1 STEP 28
        yLine = i
        LINE (0, yLine)-(screenW - 1, yLine), _RGB32(18, 26, 44)
    NEXT i

    FOR i = 0 TO screenW - 1 STEP 8
        waveY = 90 + CLNG(SIN((i / 70#) + phaseSec * 2) * 18)
        LINE (i, waveY)-(i, waveY + 2), _RGB32(110, 140, 230)
        waveY = 260 + CLNG(SIN((i / 90#) + phaseSec * 1.5 + 0.8) * 24)
        LINE (i, waveY)-(i, waveY + 2), _RGB32(160, 190, 255)
        waveY = 450 + CLNG(SIN((i / 120#) + phaseSec * 1.2 + 1.5) * 28)
        LINE (i, waveY)-(i, waveY + 2), _RGB32(110, 150, 200)
    NEXT i
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

