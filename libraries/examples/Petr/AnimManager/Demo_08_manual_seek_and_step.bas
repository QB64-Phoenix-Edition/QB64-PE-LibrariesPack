' Demo_08_manual_seek_and_step.bas
' Manual playback / seek / cache test.
' Controls:
'   Space = pause/resume
'   Left/Right = one frame backward/forward
'   Home = first frame
'   End = last frame
'   1 = seek to 1000 ms
'   2 = seek to 2000 ms
'   C = toggle cache mode STREAM / PRELOAD_ALL
'   S = stop
'   P = play / resume
'   Esc = end

OPTION _EXPLICIT

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'Petr/AnimManager'

'--- Find QB64-PE and Example source folders depending on EXE location.
'-----
'Fill example$ and library$ with the exact names, i.e. the use of upper/lower
'case must match, so that it works on case sensitive Linux filesystems.
DIM example$: example$ = "Demo_08_manual_seek_and_step.bas" 'this example's source file name
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
DIM animId AS LONG
DIM keyCode AS LONG
DIM quitFlag AS INTEGER
DIM formatText AS STRING
DIM cacheText AS STRING
DIM infoText AS STRING
DIM frameIndex AS LONG
DIM cacheMode AS LONG
DIM N AS LONG

screenW = 1280
screenH = 720

screenImage = _NEWIMAGE(screenW, screenH, 32)
SCREEN screenImage
_TITLE "Demo 08 - manual seek and cache test"

animId = AnimOpen("BALLOON.FLC")
IF animId >= 0 THEN
    AnimSetLoop animId, ANIM_LOOP_FOREVER
    AnimSetCacheMode animId, ANIM_CACHE_PRELOAD_ALL
    AnimStart animId
END IF

DO
    keyCode = _KEYHIT
    SELECT CASE keyCode
        CASE 27
            quitFlag = -1

        CASE 32
            IF animId >= 0 THEN
                IF AnimIsPlaying(animId) THEN
                    AnimPause animId
                ELSE
                    AnimResume animId
                END IF
            END IF

        CASE 19200
            IF animId >= 0 THEN AnimPause animId: N = AnimStepBackward(animId)

        CASE 19712
            IF animId >= 0 THEN AnimPause animId: N = AnimStepForward(animId)

        CASE 18176
            IF animId >= 0 THEN AnimPause animId: N = AnimSeek(animId, 0)

        CASE 20224
            IF animId >= 0 THEN AnimPause animId: N = AnimSeek(animId, AnimLen(animId) - 1)

        CASE 49
            IF animId >= 0 THEN AnimPause animId: N = AnimSeekTime(animId, 1000)

        CASE 50
            IF animId >= 0 THEN AnimPause animId: N = AnimSeekTime(animId, 2000)

        CASE 67, 99
            IF animId >= 0 THEN
                cacheMode = AnimGetCacheMode(animId)
                IF cacheMode = ANIM_CACHE_PRELOAD_ALL THEN
                    AnimSetCacheMode animId, ANIM_CACHE_STREAM
                ELSE
                    AnimSetCacheMode animId, ANIM_CACHE_PRELOAD_ALL
                END IF
            END IF

        CASE 83, 115
            IF animId >= 0 THEN AnimStop animId

        CASE 80, 112
            IF animId >= 0 THEN AnimStart animId
    END SELECT

    IF animId >= 0 THEN AnimUpdate animId

    CLS , _RGB32(10, 12, 18)
    _PRINTSTRING (20, 18), "Demo 08: manual seek / pause / step / cache mode"
    _PRINTSTRING (20, 40), "Asset: BALLOON.FLC"

    LINE (30, 90)-(850, 650), _RGB32(18, 22, 30), BF
    LINE (30, 90)-(850, 650), _RGB32(140, 180, 230), B

    IF animId >= 0 THEN
        DrawAnimFit animId, 40, 100, 800, 540
        frameIndex = AnimGetPos(animId)
        FormatNameText AnimFormat(animId), formatText
        CacheNameText AnimGetCacheMode(animId), cacheText

        _PRINTSTRING (900, 120), "Format: " + formatText
        _PRINTSTRING (900, 150), "Frame: " + LTRIM$(STR$(frameIndex)) + " / " + LTRIM$(STR$(AnimLen(animId)))
        _PRINTSTRING (900, 180), "Width x Height: " + LTRIM$(STR$(AnimWidth(animId))) + " x " + LTRIM$(STR$(AnimHeight(animId)))
        _PRINTSTRING (900, 210), "Playing: " + LTRIM$(STR$(AnimIsPlaying(animId)))
        _PRINTSTRING (900, 240), "Cached: " + LTRIM$(STR$(AnimIsCached(animId)))
        _PRINTSTRING (900, 270), "Cache mode: " + cacheText
        infoText = AnimError(animId)
        IF LEN(infoText) = 0 THEN infoText = "(no error)"
        _PRINTSTRING (900, 300), "Error: " + infoText
    ELSE
        _PRINTSTRING (900, 120), "BALLOON.FLC could not be opened."
    END IF

    _PRINTSTRING (900, 380), "Space  pause/resume"
    _PRINTSTRING (900, 405), "Left   step backward"
    _PRINTSTRING (900, 430), "Right  step forward"
    _PRINTSTRING (900, 455), "Home   first frame"
    _PRINTSTRING (900, 480), "End    last frame"
    _PRINTSTRING (900, 505), "1 / 2  seek to 1000 / 2000 ms"
    _PRINTSTRING (900, 530), "C      toggle cache mode"
    _PRINTSTRING (900, 555), "S / P  stop / play"
    _PRINTSTRING (900, 580), "Esc    end"

    _DISPLAY
    _LIMIT 60
LOOP UNTIL quitFlag

AnimFreeAll
IF screenImage <= -2 THEN SCREEN 0: _FREEIMAGE screenImage: screenImage = 0
END

SUB FormatNameText (formatId AS LONG, textValue AS STRING)
    textValue = "UNKNOWN"

    SELECT CASE formatId
        CASE ANIM_FMT_APNG
            textValue = "APNG"
        CASE ANIM_FMT_GIF89A
            textValue = "GIF89a"
        CASE ANIM_FMT_FLI
            textValue = "FLI"
        CASE ANIM_FMT_FLC
            textValue = "FLC"
        CASE ANIM_FMT_AMIGA_ANIM
            textValue = "AMIGA ANIM"
        CASE ANIM_FMT_ANI
            textValue = "ANI"
    END SELECT
END SUB

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
    drawY = boxY + (boxH - drawH) \ 2

    AnimDrawWindow drawX, drawY, drawX + drawW - 1, drawY + drawH - 1, animId
END SUB

