' Demo_10_stress_gallery_mixed_formats.bas
' Stress test: many items open at once, mixed formats, mixed cache modes.
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
DIM fileName(1 TO 9) AS STRING
DIM animId(1 TO 9) AS LONG
DIM boxX(1 TO 9) AS LONG
DIM boxY(1 TO 9) AS LONG
DIM boxW(1 TO 9) AS LONG
DIM boxH(1 TO 9) AS LONG
DIM cacheMode(1 TO 9) AS LONG
DIM cacheText AS STRING
DIM i AS LONG
DIM keyCode AS LONG
DIM quitFlag AS INTEGER

screenW = 1440
screenH = 860

fileName(1) = "Biker.png"
fileName(2) = "Animals.gif"
fileName(3) = "APPLE.FLI"
fileName(4) = "BALLOON.FLC"
fileName(5) = "drum.ani"
fileName(6) = "phoenix.ani"
fileName(7) = "3Globes.anim"
fileName(8) = "Windmill.png"
fileName(9) = "G-avatar.gif"

boxX(1) = 20: boxY(1) = 90: boxW(1) = 430: boxH(1) = 220
boxX(2) = 500: boxY(2) = 90: boxW(2) = 430: boxH(2) = 220
boxX(3) = 980: boxY(3) = 90: boxW(3) = 430: boxH(3) = 220
boxX(4) = 20: boxY(4) = 350: boxW(4) = 430: boxH(4) = 220
boxX(5) = 500: boxY(5) = 350: boxW(5) = 430: boxH(5) = 220
boxX(6) = 980: boxY(6) = 350: boxW(6) = 430: boxH(6) = 220
boxX(7) = 20: boxY(7) = 610: boxW(7) = 430: boxH(7) = 220
boxX(8) = 500: boxY(8) = 610: boxW(8) = 430: boxH(8) = 220
boxX(9) = 980: boxY(9) = 610: boxW(9) = 430: boxH(9) = 220

cacheMode(1) = ANIM_CACHE_STREAM
cacheMode(2) = ANIM_CACHE_PRELOAD_ALL
cacheMode(3) = ANIM_CACHE_AUTO
cacheMode(4) = ANIM_CACHE_STREAM
cacheMode(5) = ANIM_CACHE_PRELOAD_ALL
cacheMode(6) = ANIM_CACHE_AUTO
cacheMode(7) = ANIM_CACHE_STREAM
cacheMode(8) = ANIM_CACHE_PRELOAD_ALL
cacheMode(9) = ANIM_CACHE_AUTO

screenImage = _NEWIMAGE(screenW, screenH, 32)
SCREEN screenImage
_TITLE "Demo 10 - stress gallery mixed formats"

AnimSetCacheBudgetMB 512
PRINT "Caching ANIM animations..."
FOR i = 1 TO 9
    animId(i) = AnimOpen(fileName(i))
    IF animId(i) >= 0 THEN
        AnimSetLoop animId(i), ANIM_LOOP_FOREVER
        AnimSetCacheMode animId(i), cacheMode(i)
        AnimStart animId(i)
    END IF
NEXT i

DO
    keyCode = _KEYHIT
    IF keyCode = 27 THEN quitFlag = -1

    FOR i = 1 TO 9
        IF animId(i) >= 0 THEN AnimUpdate animId(i)
    NEXT i

    CLS , _RGB32(10, 12, 18)
    _PRINTSTRING (20, 18), "Demo 10: stress gallery with mixed formats and cache modes"
    _PRINTSTRING (20, 40), "Global cache budget: " + LTRIM$(STR$(AnimGetCacheBudgetMB)) + " MB    Esc = end"

    FOR i = 1 TO 9
        LINE (boxX(i) - 2, boxY(i) - 24)-(boxX(i) + boxW(i) + 1, boxY(i) + boxH(i) + 1), _RGB32(65, 82, 120), BF
        LINE (boxX(i) - 2, boxY(i) - 24)-(boxX(i) + boxW(i) + 1, boxY(i) + boxH(i) + 1), _RGB32(250, 250, 255), B
        LINE (boxX(i), boxY(i))-(boxX(i) + boxW(i) - 1, boxY(i) + boxH(i) - 1), _RGB32(16, 18, 28), BF
        LINE (boxX(i), boxY(i))-(boxX(i) + boxW(i) - 1, boxY(i) + boxH(i) - 1), _RGB32(130, 170, 220), B

        _PRINTSTRING (boxX(i) + 8, boxY(i) - 16), fileName(i)
        IF animId(i) >= 0 THEN
            DrawAnimFit animId(i), boxX(i) + 8, boxY(i) + 32, boxW(i) - 16, boxH(i) - 48
            CacheNameText AnimGetCacheMode(animId(i)), cacheText
            _PRINTSTRING (boxX(i) + 8, boxY(i) + boxH(i) - 30), "cache=" + cacheText + "  ready=" + LTRIM$(STR$(AnimIsCached(animId(i))))
        ELSE
            _PRINTSTRING (boxX(i) + 8, boxY(i) + 8), "Open failed"
        END IF
    NEXT i

    _DISPLAY
    _LIMIT 60
LOOP UNTIL quitFlag

AnimFreeAll
CHDIR oldDir
IF screenImage <= -2 THEN SCREEN 0: _FREEIMAGE screenImage: screenImage = 0
END

SUB CacheNameText (cacheMode AS LONG, textValue AS STRING)
    textValue = "UNKNOWN"

    SELECT CASE cacheMode
        CASE ANIM_CACHE_STREAM
            textValue = "STREAM"
        CASE ANIM_CACHE_PRELOAD_ALL
            textValue = "PRELOAD_ALL"
        CASE ANIM_CACHE_WINDOW
            textValue = "WINDOW"
        CASE ANIM_CACHE_AUTO
            textValue = "AUTO"
    END SELECT
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
    drawY = boxY + (boxH - 40 - drawH) \ 2

    AnimDrawWindow drawX, drawY, drawX + drawW - 1, drawY + drawH - 1, animId
END SUB

