' Demo_01_side_by_side_file_vs_program.bas
' Left: file animation from the library package.
' Right: generated procedural animation.
' Esc = end.

OPTION _EXPLICIT

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'Petr/AnimManager'

'--- Find QB64-PE and Example source folders depending on EXE location.
'-----
'Fill example$ and library$ with the exact names, i.e. the use of upper/lower
'case must match, so that it works on case sensitive Linux filesystems.
DIM example$: example$ = "Demo_01_side_by_side_file_vs_program.bas" 'this example's source file name
DIM library$: library$ = "Petr/AnimManager" 'the library's name (as in $USELIBRARY)
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

DIM screenImage AS LONG
DIM animId AS LONG
DIM quitFlag AS INTEGER
DIM keyCode AS LONG
DIM screenW AS LONG
DIM screenH AS LONG
DIM leftX AS LONG
DIM leftY AS LONG
DIM leftW AS LONG
DIM leftH AS LONG
DIM rightX AS LONG
DIM rightY AS LONG
DIM rightW AS LONG
DIM rightH AS LONG
DIM phaseSec AS DOUBLE
DIM infoText AS STRING

screenW = 1280
screenH = 720
leftX = 24
leftY = 90
leftW = 580
leftH = 580
rightX = 676
rightY = 90
rightW = 580
rightH = 580

screenImage = _NEWIMAGE(screenW, screenH, 32)
SCREEN screenImage
_TITLE "Demo 01 - side by side file vs programmed animation"

animId = AnimOpen("APPLE.FLI")
IF animId >= 0 THEN
    AnimSetLoop animId, ANIM_LOOP_FOREVER
    AnimStart animId
END IF

DO
    keyCode = _KEYHIT
    IF keyCode = 27 THEN quitFlag = -1

    IF animId >= 0 THEN AnimUpdate animId

    CLS , _RGB32(8, 10, 18)
    _PRINTSTRING (24, 20), "Demo 01: file animation on the left, generated animation on the right"
    _PRINTSTRING (24, 42), "Asset: APPLE.FLI    Esc = end"

    DrawFramePanel leftX, leftY, leftW, leftH, "File animation: APPLE.FLI"
    DrawFramePanel rightX, rightY, rightW, rightH, "Generated animation"

    IF animId >= 0 THEN
        DrawAnimFit animId, leftX + 10, leftY + 10, leftW - 20, leftH - 20
        infoText = "frame " + LTRIM$(STR$(AnimGetPos(animId))) + " / " + LTRIM$(STR$(AnimLen(animId)))
        _PRINTSTRING (leftX + 12, leftY + leftH + 8), infoText
    ELSE
        _PRINTSTRING (leftX + 12, leftY + 18), "APPLE.FLI could not be opened."
    END IF

    phaseSec = TIMER
    DrawProgramScene rightX + 10, rightY + 10, rightW - 20, rightH - 20, phaseSec
    _PRINTSTRING (rightX + 12, rightY + rightH + 8), "Procedural scene driven by TIMER"

    _DISPLAY
    _LIMIT 60
LOOP UNTIL quitFlag

AnimFreeAll
IF screenImage <= -2 THEN SCREEN 0: _FREEIMAGE screenImage: screenImage = 0
END

SUB DrawFramePanel (x AS LONG, y AS LONG, w AS LONG, h AS LONG, caption AS STRING)
    LINE (x - 2, y - 26)-(x + w + 1, y + h + 1), _RGB32(75, 95, 130), BF
    LINE (x - 2, y - 26)-(x + w + 1, y + h + 1), _RGB32(240, 240, 255), B
    LINE (x, y)-(x + w - 1, y + h - 1), _RGB32(18, 22, 30), BF
    LINE (x, y)-(x + w - 1, y + h - 1), _RGB32(120, 150, 210), B
    _PRINTSTRING (x + 8, y - 18), caption
END SUB

SUB DrawProgramScene (boxX AS LONG, boxY AS LONG, boxW AS LONG, boxH AS LONG, phaseSec AS DOUBLE)
    DIM centerX AS LONG
    DIM centerY AS LONG
    DIM radiusA AS DOUBLE
    DIM radiusB AS DOUBLE
    DIM i AS LONG
    DIM px AS LONG
    DIM py AS LONG
    DIM ringColor AS _UNSIGNED LONG
    DIM phaseA AS DOUBLE
    DIM starX AS LONG
    DIM starY AS LONG
    DIM boxRight AS LONG
    DIM boxBottom AS LONG
    DIM pulseSize AS LONG
    DIM shipX AS LONG
    DIM shipY AS LONG
    DIM waveY AS LONG
    DIM piValue AS DOUBLE

    centerX = boxX + boxW \ 2
    centerY = boxY + boxH \ 2
    radiusA = boxW * 0.32
    radiusB = boxH * 0.28
    boxRight = boxX + boxW - 1
    boxBottom = boxY + boxH - 1
    piValue = ATN(1) * 4

    LINE (boxX, boxY)-(boxRight, boxBottom), _RGB32(8, 10, 18), BF

    FOR i = 0 TO 60
        starX = boxX + ((i * 37) MOD boxW)
        starY = boxY + ((i * 53 + INT(phaseSec * 40)) MOD boxH)
        PSET (starX, starY), _RGB32(180, 180, 220)
    NEXT i

    FOR i = 0 TO 11
        phaseA = phaseSec * 1.2 + i * (piValue / 6)
        px = centerX + CLNG(COS(phaseA) * radiusA)
        py = centerY + CLNG(SIN(phaseA * 1.5) * radiusB)
        ringColor = _RGB32(100 + (i * 12), 110 + (i * 10), 230)
        CIRCLE (px, py), 18 + (i MOD 3) * 4, ringColor
        PAINT (px, py), _RGB32(20 + i * 8, 20 + i * 5, 70 + i * 10), ringColor
    NEXT i

    pulseSize = 34 + CLNG((SIN(phaseSec * 3.2) + 1) * 18)
    LINE (centerX - pulseSize, centerY - pulseSize)-(centerX + pulseSize, centerY + pulseSize), _RGB32(255, 210, 40), B

    shipX = boxX + 40 + ((CLNG(phaseSec * 180) MOD (boxW - 80)))
    waveY = boxY + boxH \ 2 + CLNG(SIN(phaseSec * 4) * (boxH * 0.2))
    shipY = waveY
    LINE (shipX - 26, shipY + 6)-(shipX + 26, shipY + 6), _RGB32(240, 240, 255)
    LINE (shipX - 18, shipY - 8)-(shipX + 18, shipY - 8), _RGB32(240, 240, 255)
    LINE (shipX - 18, shipY - 8)-(shipX - 26, shipY + 6), _RGB32(240, 240, 255)
    LINE (shipX + 18, shipY - 8)-(shipX + 26, shipY + 6), _RGB32(240, 240, 255)
    CIRCLE (shipX, shipY - 2), 8, _RGB32(100, 220, 255)
    PAINT (shipX, shipY - 2), _RGB32(40, 120, 180), _RGB32(100, 220, 255)
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

