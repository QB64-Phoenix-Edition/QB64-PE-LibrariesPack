' Demo_09_probe_preview_save_frames.bas
' Probe metadata for several files, preview one selected item, and save its current frame.
' Controls:
'   Up/Down = change selection
'   S = save current frame to saved_preview_frame.png
'   O = reopen selected item
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
DIM example$: example$ = "Demo_09_probe_preview_save_frames.bas" 'this example's source file name
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
DIM fileName(1 TO 8) AS STRING
DIM okFlag(1 TO 8) AS INTEGER
DIM formatId(1 TO 8) AS LONG
DIM widthPx(1 TO 8) AS LONG
DIM heightPx(1 TO 8) AS LONG
DIM frameCount(1 TO 8) AS LONG
DIM previewId AS LONG
DIM selectedIndex AS LONG
DIM keyCode AS LONG
DIM quitFlag AS INTEGER
DIM i AS LONG
DIM formatText AS STRING
DIM saveName AS STRING
DIM infoText AS STRING

screenW = 1360
screenH = 780

fileName(1) = "APPLE.FLI"
fileName(2) = "BALLOON.FLC"
fileName(3) = "Animals.gif"
fileName(4) = "Biker.png"
fileName(5) = "Windmill.png"
fileName(6) = "drum.ani"
fileName(7) = "phoenix1.ani"
fileName(8) = "3Globes.anim"

ProbeAllFiles fileName(), okFlag(), formatId(), widthPx(), heightPx(), frameCount()

screenImage = _NEWIMAGE(screenW, screenH, 32)
SCREEN screenImage
_TITLE "Demo 09 - probe, preview, save frame"

selectedIndex = 1
previewId = -1
OpenSelectedPreview selectedIndex, previewId, fileName()
DIM N AS LONG
DO
    keyCode = _KEYHIT
    SELECT CASE keyCode
        CASE 27
            quitFlag = -1

        CASE 18432
            IF selectedIndex > 1 THEN
                selectedIndex = selectedIndex - 1
                OpenSelectedPreview selectedIndex, previewId, fileName()
            END IF

        CASE 20480
            IF selectedIndex < 8 THEN
                selectedIndex = selectedIndex + 1
                OpenSelectedPreview selectedIndex, previewId, fileName()
            END IF

        CASE 79, 111
            OpenSelectedPreview selectedIndex, previewId, fileName()

        CASE 83, 115
            IF previewId >= 0 THEN
                saveName = "saved_preview_frame.png"
                N = AnimSaveFrameTo(previewId, AnimGetPos(previewId), saveName)
            END IF
    END SELECT

    IF previewId >= 0 THEN AnimUpdate previewId

    CLS , _RGB32(12, 14, 22)
    _PRINTSTRING (20, 18), "Demo 09: probe + preview + save current frame"
    _PRINTSTRING (20, 40), "Up/Down = select    O = reopen    S = save frame to saved_preview_frame.png    Esc = end"

    LINE (20, 80)-(640, 740), _RGB32(18, 22, 30), BF
    LINE (20, 80)-(640, 740), _RGB32(140, 180, 230), B

    _PRINTSTRING (38, 94), "Probe results"
    FOR i = 1 TO 8
        FormatNameText formatId(i), formatText
        IF i = selectedIndex THEN
            LINE (28, 118 + (i - 1) * 72)-(632, 176 + (i - 1) * 72), _RGB32(44, 58, 84), BF
            LINE (28, 118 + (i - 1) * 72)-(632, 176 + (i - 1) * 72), _RGB32(255, 255, 255), B
        END IF

        _PRINTSTRING (40, 124 + (i - 1) * 72), fileName(i)
        _PRINTSTRING (40, 146 + (i - 1) * 72), "ok=" + LTRIM$(STR$(okFlag(i))) + "  fmt=" + formatText
        _PRINTSTRING (40, 168 + (i - 1) * 72), "size " + LTRIM$(STR$(widthPx(i))) + "x" + LTRIM$(STR$(heightPx(i))) + "   frames " + LTRIM$(STR$(frameCount(i)))
    NEXT i

    LINE (700, 80)-(1320, 560), _RGB32(18, 22, 30), BF
    LINE (700, 80)-(1320, 560), _RGB32(140, 180, 230), B
    _PRINTSTRING (718, 94), "Preview"

    IF previewId >= 0 THEN
        DrawAnimFit previewId, 712, 110, 596, 430
        FormatNameText AnimFormat(previewId), formatText
        infoText = "current frame " + LTRIM$(STR$(AnimGetPos(previewId))) + " / " + LTRIM$(STR$(AnimLen(previewId)))
        _PRINTSTRING (718, 580), "Selected: " + fileName(selectedIndex)
        _PRINTSTRING (718, 604), "Format: " + formatText
        _PRINTSTRING (718, 628), infoText
        _PRINTSTRING (718, 652), "Error: " + AnimError(previewId)
    ELSE
        _PRINTSTRING (718, 580), "Open failed for selected item."
    END IF

    _DISPLAY
    _LIMIT 60
LOOP UNTIL quitFlag

IF previewId >= 0 THEN AnimFree previewId
AnimFreeAll
IF screenImage <= -2 THEN SCREEN 0: _FREEIMAGE screenImage: screenImage = 0
END

SUB OpenSelectedPreview (selectedIndex AS LONG, previewId AS LONG, fileName() AS STRING)
    IF previewId >= 0 THEN
        AnimFree previewId
        previewId = -1
    END IF

    previewId = AnimOpen(fileName(selectedIndex))
    IF previewId >= 0 THEN
        AnimSetLoop previewId, ANIM_LOOP_FOREVER
        AnimStart previewId
    END IF
END SUB

SUB ProbeAllFiles (fileName() AS STRING, okFlag() AS INTEGER, formatId() AS LONG, widthPx() AS LONG, heightPx() AS LONG, frameCount() AS LONG)
    DIM i AS LONG

    FOR i = LBOUND(fileName) TO UBOUND(fileName)
        AnimProbe fileName(i), okFlag(i), formatId(i), widthPx(i), heightPx(i), frameCount(i)
    NEXT i
END SUB

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

