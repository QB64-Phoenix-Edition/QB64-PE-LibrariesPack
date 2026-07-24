' Demo_02_animated_background_with_overlays.bas
' Fullscreen animated background plus three overlay animations.
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
DIM example$: example$ = "Demo_02_animated_background_with_overlays.bas" 'this example's source file name
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
DIM bgAnim AS LONG
DIM animA AS LONG
DIM animB AS LONG
DIM animC AS LONG
DIM quitFlag AS INTEGER
DIM keyCode AS LONG

screenW = 1280
screenH = 720

screenImage = _NEWIMAGE(screenW, screenH, 32)
SCREEN screenImage
_TITLE "Demo 02 - animated background with overlays"

bgAnim = AnimOpen("elephant.png")
animA = AnimOpen("drum.ani")
animB = AnimOpen("APPLE.FLI")
animC = AnimOpen("Animals.gif")

IF bgAnim >= 0 THEN AnimSetLoop bgAnim, ANIM_LOOP_FOREVER: AnimStart bgAnim
IF animA >= 0 THEN AnimSetLoop animA, ANIM_LOOP_FOREVER: AnimStart animA
IF animB >= 0 THEN AnimSetLoop animB, ANIM_LOOP_FOREVER: AnimStart animB
IF animC >= 0 THEN AnimSetLoop animC, ANIM_LOOP_FOREVER: AnimStart animC

DO
    keyCode = _KEYHIT
    IF keyCode = 27 THEN quitFlag = -1

    IF bgAnim >= 0 THEN AnimUpdate bgAnim
    IF animA >= 0 THEN AnimUpdate animA
    IF animB >= 0 THEN AnimUpdate animB
    IF animC >= 0 THEN AnimUpdate animC

    CLS , _RGB32(0, 0, 0)

    IF bgAnim >= 0 THEN
        DrawAnimFit bgAnim, 0, 0, screenW, screenH
    END IF

    LINE (0, 0)-(screenW - 1, 64), _RGBA32(0, 0, 0, 180), BF
    _PRINTSTRING (24, 18), "Demo 02: animated background + overlays"
    _PRINTSTRING (24, 40), "Background: elephant.png    Overlays: drum.ani, APPLE.FLI, Animals.gif"

    DrawPanel 24, 92, 240, 240, "drum.ani"
    DrawPanel 340, 120, 600, 420, "APPLE.FLI"
    DrawPanel 980, 90, 260, 260, "Animals.gif"

    IF animA >= 0 THEN DrawAnimFit animA, 36, 104, 216, 216
    IF animB >= 0 THEN DrawAnimFit animB, 352, 132, 576, 396
    IF animC >= 0 THEN DrawAnimFit animC, 992, 102, 236, 236

    LINE (36, 580)-(1244, 684), _RGBA32(0, 0, 0, 150), BF
    LINE (36, 580)-(1244, 684), _RGB32(220, 220, 255), B
    _PRINTSTRING (54, 600), "This test checks layered drawing order and transparency behavior."
    _PRINTSTRING (54, 624), "The background is animated full-screen. The foreground objects must stay visible and stable."
    _PRINTSTRING (54, 648), "Esc = end"

    _DISPLAY
    _LIMIT 60
LOOP UNTIL quitFlag

AnimFreeAll
IF screenImage <= -2 THEN SCREEN 0: _FREEIMAGE screenImage: screenImage = 0
END

SUB DrawPanel (x AS LONG, y AS LONG, w AS LONG, h AS LONG, caption AS STRING)
    LINE (x - 2, y - 24)-(x + w + 1, y + h + 1), _RGBA32(0, 0, 0, 130), BF
    LINE (x - 2, y - 24)-(x + w + 1, y + h + 1), _RGB32(230, 230, 250), B
    LINE (x, y)-(x + w - 1, y + h - 1), _RGBA32(10, 10, 20, 90), BF
    LINE (x, y)-(x + w - 1, y + h - 1), _RGB32(130, 170, 220), B
    _PRINTSTRING (x + 8, y - 16), caption
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

