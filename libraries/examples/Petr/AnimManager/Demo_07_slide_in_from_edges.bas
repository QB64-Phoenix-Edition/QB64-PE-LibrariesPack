' Demo_07_slide_in_from_edges.bas
' Animations enter from screen edges and stop at fixed target boxes.
' Press R to restart the entry animation.
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
DIM example$: example$ = "Demo_07_slide_in_from_edges.bas" 'this example's source file name
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
DIM fileName(1 TO 4) AS STRING
DIM animId(1 TO 4) AS LONG
DIM curX(1 TO 4) AS SINGLE
DIM curY(1 TO 4) AS SINGLE
DIM targetX(1 TO 4) AS LONG
DIM targetY(1 TO 4) AS LONG
DIM drawW(1 TO 4) AS LONG
DIM drawH(1 TO 4) AS LONG
DIM speedValue(1 TO 4) AS SINGLE
DIM arrived(1 TO 4) AS INTEGER
DIM i AS LONG
DIM keyCode AS LONG
DIM quitFlag AS INTEGER
DIM allArrived AS INTEGER

screenW = 1360
screenH = 760

fileName(1) = "DOLPHIN.FLI"
fileName(2) = "elephant.png"
fileName(3) = "phoenix1.ani"
fileName(4) = "ANT_WALK.ANIM"

drawW(1) = 260: drawH(1) = 190: targetX(1) = 110: targetY(1) = 120: speedValue(1) = 7.0
drawW(2) = 220: drawH(2) = 220: targetX(2) = 980: targetY(2) = 100: speedValue(2) = 8.5
drawW(3) = 180: drawH(3) = 180: targetX(3) = 160: targetY(3) = 500: speedValue(3) = 7.6
drawW(4) = 360: drawH(4) = 240: targetX(4) = 760: targetY(4) = 420: speedValue(4) = 9.0

screenImage = _NEWIMAGE(screenW, screenH, 32)
SCREEN screenImage
_TITLE "Demo 07 - slide in from edges"
PRINT "Please wait, caching ANIM animation"
FOR i = 1 TO 4
    animId(i) = AnimOpen(fileName(i))
    IF animId(i) >= 0 THEN
        AnimSetLoop animId(i), ANIM_LOOP_FOREVER
        AnimStart animId(i)
    END IF
NEXT i

RestartScene screenW, screenH, curX(), curY(), targetX(), targetY(), speedValue()

DO
    keyCode = _KEYHIT
    IF keyCode = 27 THEN quitFlag = -1
    IF keyCode = 82 OR keyCode = 114 THEN RestartScene screenW, screenH, curX(), curY(), targetX(), targetY(), speedValue()

    FOR i = 1 TO 4
        IF animId(i) >= 0 THEN AnimUpdate animId(i)
    NEXT i

    CLS , _RGB32(16, 18, 26)
    _PRINTSTRING (20, 18), "Demo 07: slide in from left / right / top / bottom"
    _PRINTSTRING (20, 40), "R = restart entry animation    Esc = end"

    allArrived = -1
    FOR i = 1 TO 4
        MoveTowardTarget i, curX(), curY(), targetX(), targetY(), speedValue(), arrived()
        IF arrived(i) = 0 THEN allArrived = 0

        LINE (INT(curX(i)) - 2, INT(curY(i)) - 20)-(INT(curX(i)) + drawW(i) + 1, INT(curY(i)) + drawH(i) + 1), _RGBA32(0, 0, 0, 120), BF
        LINE (INT(curX(i)) - 2, INT(curY(i)) - 20)-(INT(curX(i)) + drawW(i) + 1, INT(curY(i)) + drawH(i) + 1), _RGB32(255, 255, 255), B
        _PRINTSTRING (INT(curX(i)) + 8, INT(curY(i)) - 14), fileName(i)
        IF animId(i) >= 0 THEN DrawAnimFit animId(i), INT(curX(i)), INT(curY(i)), drawW(i), drawH(i)
    NEXT i

    IF allArrived THEN
        _PRINTSTRING (20, 708), "All items reached their targets. Press R to repeat."
    END IF

    _DISPLAY
    _LIMIT 60
LOOP UNTIL quitFlag

AnimFreeAll
IF screenImage <= -2 THEN SCREEN 0: _FREEIMAGE screenImage: screenImage = 0
END

SUB RestartScene (screenW AS LONG, screenH AS LONG, curX() AS SINGLE, curY() AS SINGLE, targetX() AS LONG, targetY() AS LONG, speedValue() AS SINGLE)
    curX(1) = -320: curY(1) = targetY(1)
    curX(2) = screenW + 320: curY(2) = targetY(2)
    curX(3) = targetX(3): curY(3) = -260
    curX(4) = targetX(4): curY(4) = screenH + 260

    speedValue(1) = 7.0
    speedValue(2) = 8.5
    speedValue(3) = 7.6
    speedValue(4) = 9.0
END SUB

SUB MoveTowardTarget (indexValue AS LONG, curX() AS SINGLE, curY() AS SINGLE, targetX() AS LONG, targetY() AS LONG, speedValue() AS SINGLE, arrived() AS INTEGER)
    DIM dx AS SINGLE
    DIM dy AS SINGLE

    arrived(indexValue) = 0
    dx = targetX(indexValue) - curX(indexValue)
    dy = targetY(indexValue) - curY(indexValue)

    IF ABS(dx) <= speedValue(indexValue) AND ABS(dy) <= speedValue(indexValue) THEN
        curX(indexValue) = targetX(indexValue)
        curY(indexValue) = targetY(indexValue)
        arrived(indexValue) = -1
        EXIT SUB
    END IF

    IF dx > speedValue(indexValue) THEN
        curX(indexValue) = curX(indexValue) + speedValue(indexValue)
    ELSEIF dx < -speedValue(indexValue) THEN
        curX(indexValue) = curX(indexValue) - speedValue(indexValue)
    ELSE
        curX(indexValue) = targetX(indexValue)
    END IF

    IF dy > speedValue(indexValue) THEN
        curY(indexValue) = curY(indexValue) + speedValue(indexValue)
    ELSEIF dy < -speedValue(indexValue) THEN
        curY(indexValue) = curY(indexValue) - speedValue(indexValue)
    ELSE
        curY(indexValue) = targetY(indexValue)
    END IF
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

