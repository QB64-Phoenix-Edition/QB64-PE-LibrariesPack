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
'| === StdLibs-Test.bas ===                                          |
'|                                                                   |
'| == This short test program serves to make sure, that everything   |
'| == is working on your system as intended, as pointer sizes and    |
'| == padding sizes do vary between QB64 x32 and x64 and maybe even  |
'| == between Windows, Linux and MacOS. If everything is good, then  |
'| == the output should match the StdLibs-Test.png screenshot.       |
'|                                                                   |
'+-------------------------------------------------------------------+
'| Done by RhoSigma, R.Heyder, provided AS IS, use at your own risk. |
'| Find me in the QB64 Forum or mail to support@rhosigma-cw.net for  |
'| any questions or suggestions. Thanx for your interest in my work. |
'+-------------------------------------------------------------------+

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'RhoSigma/QB-StdArg'
$USELIBRARY:'RhoSigma/QB-StdIo'
$USELIBRARY:'RhoSigma/QB-Time'

'--- Set title and print the program's version string.
'-----
_TITLE "StdLibs-Test Output"
COLOR 9: PRINT VersionStdlibsTest$: PRINT: COLOR 7

'--- Make a couple argument tests.
'-----
InitArgs a$
StrArg a$, "Hello World !!"
IntArg a$, &H7FFF
LongArg a$, &H7FFFFFFF
Int64Arg a$, &H7FFFFFFFFFFFFFFF
DoubleArg a$, 123.456789
VPrintF "   String: %s\n" +_
        "  Integer: %hd\n" +_
        "     Long: %ld\n" +_
        "Integer64: %lld\n" +_
        "   Double: %5.3f\n", a$
FreeArgs a$

'--- And here a time test.
'-----
PRINT StrFGivenTime$("This test was written at %X on %A %B %d %Y.\n", 2013, 3, 14, 18, 32, 8)

'--- Make your best guess what happens here.
'-----
PRINT "done..."
END

'--- Function to define/return the program's version string.
'-----
FUNCTION VersionStdlibsTest$
VersionStdlibsTest$ = MID$("$VER: StdLibs-Test 1.0 (14-Mar-2013) by RhoSigma :END$", 7, 42)
END FUNCTION

