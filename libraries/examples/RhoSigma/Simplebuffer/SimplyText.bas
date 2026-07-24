'+---------------+---------------------------------------------------+
'| ###### ###### |     .--. .         .-.                            |
'| ##  ## ##   # |     |   )|        (   ) o                         |
'| ##  ##  ##    |     |--' |--. .-.  `-.  .  .-...--.--. .-.        |
'| ######   ##   |     |  \ |  |(   )(   ) | (   ||  |  |(   )       |
'| ##      ##    |     '   `'  `-`-'  `-'-' `-`-`|'  '  `-`-'`-      |
'| ##     ##   # |                            ._.'                   |
'| ##     ###### |  Sources & Documents placed in the Public Domain. |
'+---------------+---------------------------------------------------+
'|                                                                   |
'| === SimplyText.bas ===                                            |
'|                                                                   |
'| == This example shows how you can use the Simplebuffer System     |
'| == as sequential read replacement for the usual file based        |
'| == OPEN/WHILE NOT EOF/LINE INPUT/WEND/CLOSE technique.            |
'|                                                                   |
'+-------------------------------------------------------------------+
'| Done by RhoSigma, R.Heyder, provided AS IS, use at your own risk. |
'| Find me in the QB64 Forum or mail to support@rhosigma-cw.net for  |
'| any questions or suggestions. Thanx for your interest in my work. |
'+-------------------------------------------------------------------+

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'RhoSigma/Simplebuffer'

'--- Find QB64-PE and Example source folders depending on EXE location.
'-----
'Fill example$ and library$ with the exact names, i.e. the use of upper/lower
'case must match, so that it works on case sensitive Linux filesystems.
DIM example$: example$ = "SimplyText.bas" 'this example's source file name
DIM library$: library$ = "RhoSigma/Simplebuffer" 'the library's name (as in $USELIBRARY)
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

'--- Set title and print the program's version string.
'-----
_TITLE "Simplebuffers usage example"
COLOR 9: PRINT VersionSimplyText$: PRINT: COLOR 7

'--- the usual file based read
'-----
COLOR 12: PRINT "reading lines from file (delayed 0.2 sec.) ...": PRINT: COLOR 7
OPEN "SimplyText.bas" FOR INPUT AS #1
WHILE NOT EOF(1)
    LINE INPUT #1, l$
    PRINT l$
    _DELAY 0.2
WEND
CLOSE #1
COLOR 12: PRINT: PRINT "end of file, press any key...": SLEEP: COLOR 7
CLS

'--- now let's use a buffer
'-----
COLOR 9: PRINT VersionSimplyText$: PRINT: COLOR 7
COLOR 12: PRINT "reading lines from buffer (delayed 0.2 sec.) ...": PRINT: COLOR 7
bh% = FileToBuf%("SimplyText.bas")
ConvBufToNativeEol bh%
WHILE NOT EndOfBuf%(bh%)
    PRINT ReadBufLine$(bh%)
    _DELAY 0.2
WEND
DisposeBuf bh%
COLOR 12: PRINT: PRINT "end of buffer, press any key...": SLEEP: COLOR 7
END

'--- Function to define/return the program's version string.
'-----
FUNCTION VersionSimplyText$
    VersionSimplyText$ = MID$("$VER: SimplyText 1.0 (18-Oct-2022) by RhoSigma :END$", 7, 40)
END FUNCTION

