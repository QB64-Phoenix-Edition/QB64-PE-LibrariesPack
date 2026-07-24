' Demo_11_my_fli_bouncing_windows_manager.bas
' Fullscreen with bouncing animated windows.
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
DIM example$: example$ = "Demo_11_my_fli_bouncing_windows_manager.bas" 'this example's source file name
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
DIM fileNames(1 TO 4) AS STRING
DIM animIds(1 TO 4) AS LONG
DIM posX(1 TO 4) AS SINGLE
DIM posY(1 TO 4) AS SINGLE
DIM velX(1 TO 4) AS SINGLE
DIM velY(1 TO 4) AS SINGLE
DIM drawW(1 TO 4) AS LONG
DIM drawH(1 TO 4) AS LONG
DIM i AS LONG
DIM keyCode AS LONG
DIM quitFlag AS INTEGER
DIM screenW AS LONG
DIM screenH AS LONG
DIM labelY AS LONG

fileNames(1) = "goku.anim"
fileNames(2) = "valkyrie.anim"
fileNames(3) = "PAP-Demo2.anim"
fileNames(4) = "PAP-Demo1.anim"

screenW = 1280
screenH = 720

screenImage = _NEWIMAGE(screenW, screenH, 32)
SCREEN screenImage
_TITLE "Demo 11 - bouncing windows"

FOR i = 1 TO 4
    animIds(i) = AnimOpen(fileNames(i))
    IF animIds(i) >= 0 THEN
        AnimSetLoop animIds(i), ANIM_LOOP_FOREVER
        AnimStart animIds(i)
    END IF
NEXT i

posX(1) = 30: posY(1) = 80: velX(1) = 2.2: velY(1) = 1.4
posX(2) = 420: posY(2) = 120: velX(2) = -1.7: velY(2) = 1.9
posX(3) = 780: posY(3) = 260: velX(3) = 2.4: velY(3) = -1.2
posX(4) = 900: posY(4) = 60: velX(4) = -2.0: velY(4) = 1.5

FOR i = 1 TO 4
    drawW(i) = 260
    drawH(i) = 180
NEXT i

DO
    keyCode = _KEYHIT
    IF keyCode = 27 THEN quitFlag = -1

    CLS , _RGB32(8, 10, 14)
    _PRINTSTRING (20, 20), "Demo 11: bouncing animated windows"
    _PRINTSTRING (20, 42), "Esc = end"

    FOR i = 1 TO 4
        IF animIds(i) >= 0 THEN AnimUpdate animIds(i)

        posX(i) = posX(i) + velX(i)
        posY(i) = posY(i) + velY(i)

        IF posX(i) < 10 THEN posX(i) = 10: velX(i) = -velX(i)
        IF posY(i) < 70 THEN posY(i) = 70: velY(i) = -velY(i)
        IF posX(i) + drawW(i) > screenW - 10 THEN posX(i) = screenW - 10 - drawW(i): velX(i) = -velX(i)
        IF posY(i) + drawH(i) > screenH - 10 THEN posY(i) = screenH - 10 - drawH(i): velY(i) = -velY(i)

        LINE (INT(posX(i)) - 2, INT(posY(i)) - 24)-(INT(posX(i)) + drawW(i) + 1, INT(posY(i)) + drawH(i) + 1), _RGB32(100, 130, 180), BF
        LINE (INT(posX(i)) - 2, INT(posY(i)) - 24)-(INT(posX(i)) + drawW(i) + 1, INT(posY(i)) + drawH(i) + 1), _RGB32(255, 255, 255), B
        _PRINTSTRING (INT(posX(i)) + 8, INT(posY(i)) - 18), fileNames(i)

        IF animIds(i) >= 0 THEN
            DrawAnimFit animIds(i), INT(posX(i)), INT(posY(i)), drawW(i), drawH(i)
        END IF

        labelY = INT(posY(i)) + drawH(i) + 6
        IF animIds(i) >= 0 THEN
            _PRINTSTRING (INT(posX(i)), labelY), "frame " + LTRIM$(STR$(AnimGetPos(animIds(i))))
        END IF
    NEXT i

    _DISPLAY
    _LIMIT 60
LOOP UNTIL quitFlag

AnimFreeAll
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

