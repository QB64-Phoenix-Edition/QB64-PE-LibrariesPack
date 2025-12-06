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
'| === StdLibs-HowTo.bas ===                                         |
'|                                                                   |
'| == A short example to show the usage of qbstdarg.bi/.bm variable  |
'| == argument strings (va_list) and qbstdio.bi/.bm stdio functions  |
'| == for formatted output (C/C++ printf() style) and qbtime.bi/.bm  |
'| == functions for formatted date/time output (strftime() style).   |
'|                                                                   |
'+-------------------------------------------------------------------+
'| Done by RhoSigma, R.Heyder, provided AS IS, use at your own risk. |
'| Find me in the QB64 Forum or mail to support@rhosigma-cw.net for  |
'| any questions or suggestions. Thanx for your interest in my work. |
'+-------------------------------------------------------------------+

'=====================================================================
'=== The provided functions allow for escape sequences as known from
'=== C/C++, so you may use those sequences within your argument and/or
'=== format strings as it would be done in C/C++:
'===
'===   eg. a$ = "Column-1\tColumn-2" instead of the (bulky) QB64 way
'===       a$ = "Column-1" + CHR$(9) + "Column-2"
'===
'=== Unfortunatly you still can't use \" to insert a quotation mark,
'=== as the QB64 compiler would see the used " in the escape sequence
'=== as the regular end of the string. However, you can use the octal
'=== or hex representations \042 or \x22 of the quotation mark:
'===
'===   eg. a$ = "This is a \x22quoted\x22 section."
'===
'=== But note, as the backslash denotes escape sequences, you need to
'=== write a double backslash (\\) to actually get a backslash in the
'=== output. Any single backslashs, which are not part of a valid escape
'=== sequence, will simply disappear. The \\ notation is also used to
'=== prevent escape sequence evaluation:
'===
'===   eg. a$ = "\\x22" doesn't evaluate to a backslash + quotation mark,
'===                    but to the literal string "\x22"
'===
'=== If you actually want a backslash + quotation mark, then you must
'=== write "\\\x22". Here the first backslash tells the program, that the
'=== next (second) backslash shall not be evaluated as part of a escape
'=== sequence, but rather printed as literal. The third backslash is then
'=== the regular introduction to the \x22 escape sequence, which results
'=== in printing a quotation mark.
'=====================================================================

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'RhoSigma/QB-StdArg'
$USELIBRARY:'RhoSigma/QB-StdIo'
$USELIBRARY:'RhoSigma/QB-Time'

'--- Set title and print the program's version string.
'-----
WIDTH , 30
_TITLE "StdLibs-HowTo Output"
COLOR 9: PRINT VersionStdlibsHowTo$: PRINT: COLOR 7

'--- Make a va_list and use it for formatted output, note the
'--- use of \n and \t escape sequences in the format string.
'-----
InitArgs a$ '      1st init a new va_list string,
StrArg a$, DATE$ ' then setup some values in it
StrArg a$, TIME$
DoubleArg a$, TIMER
VPrintF "Some values:\n\tDATE\t= %s\n\tTIME\t= %s\n\tTIMER\t= %5.3f\n", a$

'--- Another va_list and formatted print, again note the
'--- use of \n and \t escape sequences in the format string.
'-----
InitArgs b$
DoubleArg b$, SQR(2)
DoubleArg b$, 3.141592653589793 / 180
VPrintF "Some other values:\n\tSQR(2)\t= %1.6f\n\tRAD\t= %1.6f\n", b$
'-----
'--- Using the same va_list again for another formatted print,
'--- exponential notation, one with lower case "e", one with
'--- upper case "E", and again note the use of \n and \t escape
'--- sequences in the format string.
'-----
VPrintF "Same, but exponential:\n\tSQR(2)\t= %e\n\tRAD\t= %E\n", b$
FreeArgs b$ 'now free the va_list string

'--- The circle thing is a "must have" :), again note the
'--- use of oct/hex escape sequences in the argument string,
'--- as well as in the format string here.
'-----
InitArgs c$
StrArg c$, "\042circle\042"
IntArg c$, 360
VPrintF "The %s has \x22%hd\x22 degrees.\n", c$

'--- IMPORTANT: free all remaining va_list strings !!
'--- This must not be done in reverse order, but looks nicer here.
'-----
FreeArgs c$
'NOTE: b$ was already freed after use in line 87
FreeArgs a$

'--- And here comes some date/time formatting, as you can see in the
'--- format strings, you can use escape sequences here too.
'-----
PRINT StrFCurrentTime$("Today is \x22%a %b %d %X %Y\x22, it's day number %j of the year.")
PRINT StrFGivenTime$("This example was written at %X on %A %B %d %Y.\n", 2013, 3, 14, 12, 56, 3)

'--- Now finally you're familiar with the use of escape sequences and
'--- you want it for regular strings too?, so here is a solution.
'-----
'--- Here is the old bulky way QB64 wants you to go ...
PRINT "This is a " + CHR$(34) + "quoted" + CHR$(34) + " section made the old bulky way." + CHR$(10)
'--- ... and now the new way with QB$ function, not perfect,
'--- but already noticeably shorter than the above.
PRINT QB$("This is a \x22quoted\x22 section made the new easy way.\n")

'--- Make your best guess what happens here.
'-----
PRINT "done..."
END

'--- Function to define/return the program's version string.
'-----
FUNCTION VersionStdlibsHowTo$
    VersionStdlibsHowTo$ = MID$("$VER: StdLibs-HowTo 1.0 (14-Mar-2013) by RhoSigma :END$", 7, 43)
END FUNCTION

