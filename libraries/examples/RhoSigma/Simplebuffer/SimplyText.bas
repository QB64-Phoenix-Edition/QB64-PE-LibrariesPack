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

'--- Find the root of the library's source folder.
'-----
IF _FILEEXISTS("qb64pe.exe") _ORELSE _FILEEXISTS("qb64pe") THEN
    root$ = "libraries\examples\RhoSigma\Simplebuffer\"
END IF

'--- Set title and print the program's version string.
'-----
_TITLE "Simplebuffers usage example"
COLOR 9: PRINT VersionSimplyText$: PRINT: COLOR 7

'--- the usual file based read
'-----
COLOR 12: PRINT "reading lines from file (delayed 0.2 sec.) ...": PRINT: COLOR 7
OPEN root$ + "SimplyText.bas" FOR INPUT AS #1
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
bh% = FileToBuf%(root$ + "SimplyText.bas")
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

