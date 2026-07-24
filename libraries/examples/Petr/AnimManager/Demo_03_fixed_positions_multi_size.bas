' Demo_03_fixed_positions_multi_size.bas
' Several animations at fixed positions, each with a different size.
' They do not overlap on purpose.
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
DIM example$: example$ = "Demo_03_fixed_positions_multi_size.bas" 'this example's source file name
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
DIM screenW AS LONG
DIM screenH AS LONG
DIM animId(1 TO 6) AS LONG
DIM fileName(1 TO 6) AS STRING
DIM boxX(1 TO 6) AS LONG
DIM boxY(1 TO 6) AS LONG
DIM boxW(1 TO 6) AS LONG
DIM boxH(1 TO 6) AS LONG
DIM i AS LONG
DIM quitFlag AS INTEGER
DIM keyCode AS LONG

screenW = 1360
screenH = 760

fileName(1) = "Biker.png"
fileName(2) = "Windmill.png"
fileName(3) = "Animals.gif"
fileName(4) = "BALLOON.FLC"
fileName(5) = "phoenix.ani"
fileName(6) = "3Globes.anim"

boxX(1) = 20: boxY(1) = 80: boxW(1) = 180: boxH(1) = 180
boxX(2) = 230: boxY(2) = 80: boxW(2) = 260: boxH(2) = 260
boxX(3) = 520: boxY(3) = 80: boxW(3) = 320: boxH(3) = 240
boxX(4) = 870: boxY(4) = 80: boxW(4) = 460: boxH(4) = 300
boxX(5) = 40: boxY(5) = 390: boxW(5) = 260: boxH(5) = 300
boxX(6) = 340: boxY(6) = 430: boxW(6) = 940: boxH(6) = 260

screenImage = _NEWIMAGE(screenW, screenH, 32)
SCREEN screenImage
_TITLE "Demo 03 - fixed positions, different sizes"
PRINT "Plase wait, caching ANIM animation"
FOR i = 1 TO 6
    animId(i) = AnimOpen(fileName(i))
    IF animId(i) >= 0 THEN
        AnimSetLoop animId(i), ANIM_LOOP_FOREVER
        AnimStart animId(i)
    END IF
NEXT i

DO
    keyCode = _KEYHIT
    IF keyCode = 27 THEN quitFlag = -1

    FOR i = 1 TO 6
        IF animId(i) >= 0 THEN AnimUpdate animId(i)
    NEXT i

    CLS , _RGB32(14, 16, 24)
    _PRINTSTRING (20, 18), "Demo 03: fixed layout with different draw sizes"
    _PRINTSTRING (20, 40), "This is mainly a scaling / non-overlap layout test. Esc = end"

    FOR i = 1 TO 6
        DrawPanel boxX(i), boxY(i), boxW(i), boxH(i), fileName(i)
        IF animId(i) >= 0 THEN
            DrawAnimFit animId(i), boxX(i) + 8, boxY(i) + 8, boxW(i) - 16, boxH(i) - 16
        ELSE
            _PRINTSTRING (boxX(i) + 12, boxY(i) + 16), "Open failed"
        END IF
    NEXT i

    _DISPLAY
    _LIMIT 60
LOOP UNTIL quitFlag

AnimFreeAll
IF screenImage <= -2 THEN SCREEN 0: _FREEIMAGE screenImage: screenImage = 0
END

SUB DrawPanel (x AS LONG, y AS LONG, w AS LONG, h AS LONG, caption AS STRING)
    LINE (x - 2, y - 24)-(x + w + 1, y + h + 1), _RGB32(70, 90, 130), BF
    LINE (x - 2, y - 24)-(x + w + 1, y + h + 1), _RGB32(250, 250, 255), B
    LINE (x, y)-(x + w - 1, y + h - 1), _RGB32(9, 12, 18), BF
    LINE (x, y)-(x + w - 1, y + h - 1), _RGB32(130, 170, 220), B
    _PRINTSTRING (x + 8, y - 16), caption + "   " + LTRIM$(STR$(w)) + "x" + LTRIM$(STR$(h))
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

