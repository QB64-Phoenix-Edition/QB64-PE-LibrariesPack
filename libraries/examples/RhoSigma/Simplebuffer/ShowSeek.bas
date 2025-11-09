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
'| === ShowSeek.bas ===                                              |
'|                                                                   |
'| == This example illustrates the use of various buffer functions   |
'| == by showing some usual seek behavior in text buffers.           |
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

_TITLE "Simplebuffers line seek behavior"

'--- create a buffer
'-----
wBuf% = CreateBuf%

'--- and write some text lines into it
'-----
WriteBufLine wBuf%, ""
WriteBufLine wBuf%, "" 'blank lines
WriteBufLine wBuf%, ""
WriteBufLine wBuf%, "line content"
WriteBufLine wBuf%, ""
WriteBufLine wBuf%, "line content"
WriteBufLine wBuf%, ""
WriteBufLine wBuf%, "line content"
WriteBufLine wBuf%, ""
WriteBufLine wBuf%, ""

'--- now clone the buffer
'-----
lBuf% = CloneBuf%(wBuf%)

'--- as we don't know the user's native system, make sure each
'--- buffer is using the right line breaks for this demo
'-----
ConvBufToWinEol wBuf% '  'this buffer uses windows EOL mode (CR+LF)
ConvBufToLnxMacEol lBuf% 'this buffer linux/macosx EOL mode (LF only)

'--- define strings to visualize our buffer contents incl. line breaks
'--- < = carriage return (windows only)
'--- | = line feed, * = end of buffer position
'-----
win$ = "<|<|<|line content<|<|line content<|<|line content<|<|<|*"
lnx$ = "|||line content||line content||line content|||*"

'--- now walk through the buffer to show SBM_LineEnd behavior
'-----
FOR i& = 0 TO GetBufLen&(wBuf%) 'windows buffer is longer, so we take its size
    COLOR 15
    PRINT "visualized buffer content..."
    PRINT " < = carriage return (windows only)"
    PRINT " | = line feed, * = end of buffer position": PRINT
    COLOR 11: PRINT "Seek Mode is SBM_LineEnd...": PRINT
    bla& = SeekBuf&(wBuf%, i&, SBM_BufStart) 'assumed buffer position
    wOp& = SeekBuf&(wBuf%, 0, SBM_LineEnd) 'now find line end
    wNp& = GetBufPos&(wBuf%)
    COLOR 14: PRINT "WIN - assumed buffer position:"
    COLOR 15: PRINT win$: p$ = SPACE$(LEN(win$)): MID$(p$, wOp&, 1) = "^": COLOR 13: PRINT p$: PRINT
    COLOR 14: PRINT "WIN - position after seek to the current line's end:"
    COLOR 15: PRINT win$: p$ = SPACE$(LEN(win$)): MID$(p$, wNp&, 1) = "^": COLOR 13: PRINT p$: PRINT
    bla& = SeekBuf&(lBuf%, i&, SBM_BufStart) 'assumed buffer position
    lOp& = SeekBuf&(lBuf%, 0, SBM_LineEnd) 'now find line end
    lNp& = GetBufPos&(lBuf%)
    COLOR 14: PRINT "LNX/MAC - assumed buffer position:"
    COLOR 15: PRINT lnx$: p$ = SPACE$(LEN(lnx$)): MID$(p$, lOp&, 1) = "^": COLOR 13: PRINT p$: PRINT
    COLOR 14: PRINT "LNX/MAC - position after seek to the current line's end:"
    COLOR 15: PRINT lnx$: p$ = SPACE$(LEN(lnx$)): MID$(p$, lNp&, 1) = "^": COLOR 13: PRINT p$: PRINT
    COLOR 10: PRINT "press any key..."
    SLEEP: CLS
NEXT i&

'--- take a breath
'-----
COLOR 15: PRINT: PRINT "and now we switch the Seek Mode..."
COLOR 10: PRINT: PRINT "press any key..."
SLEEP: CLS

'--- now walk through the buffer to show SBM_LineStart behavior
'-----
FOR i& = 0 TO GetBufLen&(wBuf%) 'windows buffer is longer, so we take its size
    COLOR 15
    PRINT "visualized buffer content..."
    PRINT " < = carriage return (windows only)"
    PRINT " | = line feed, * = end of buffer position": PRINT
    COLOR 11: PRINT "Seek Mode is now SBM_LineStart...": PRINT
    bla& = SeekBuf&(wBuf%, i&, SBM_BufStart) 'assumed buffer position
    wOp& = SeekBuf&(wBuf%, 0, SBM_LineStart) 'now find line start
    wNp& = GetBufPos&(wBuf%)
    COLOR 14: PRINT "WIN - assumed buffer position:"
    COLOR 15: PRINT win$: p$ = SPACE$(LEN(win$)): MID$(p$, wOp&, 1) = "^": COLOR 13: PRINT p$: PRINT
    COLOR 14: PRINT "WIN - position after seek to the current line's start:"
    COLOR 15: PRINT win$: p$ = SPACE$(LEN(win$)): MID$(p$, wNp&, 1) = "^": COLOR 13: PRINT p$: PRINT
    bla& = SeekBuf&(lBuf%, i&, SBM_BufStart) 'assumed buffer position
    lOp& = SeekBuf&(lBuf%, 0, SBM_LineStart) 'now find line start
    lNp& = GetBufPos&(lBuf%)
    COLOR 14: PRINT "LNX/MAC - assumed buffer position:"
    COLOR 15: PRINT lnx$: p$ = SPACE$(LEN(lnx$)): MID$(p$, lOp&, 1) = "^": COLOR 13: PRINT p$: PRINT
    COLOR 14: PRINT "LNX/MAC - position after seek to the current line's start:"
    COLOR 15: PRINT lnx$: p$ = SPACE$(LEN(lnx$)): MID$(p$, lNp&, 1) = "^": COLOR 13: PRINT p$: PRINT
    COLOR 10: PRINT "press any key..."
    SLEEP: CLS
NEXT i&

'--- cleanup & exit
'-----
DisposeBuf lBuf%
DisposeBuf wBuf%
END

'--- Function to define/return the program's version string.
'-----
FUNCTION VersionShowSeek$
    VersionShowSeek$ = MID$("$VER: ShowSeek 1.0 (18-Oct-2022) by RhoSigma :END$", 7, 38)
END FUNCTION

