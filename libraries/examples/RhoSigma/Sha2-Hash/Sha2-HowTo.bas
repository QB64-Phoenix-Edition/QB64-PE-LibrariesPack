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
'| === Sha2-HowTo.bas ===                                            |
'|                                                                   |
'| == This example is to show the usage of the sha2.bi/.bm functions |
'| == for the Secure Hash Algorithm (SHA2) Message-Digest.           |
'|                                                                   |
'+-------------------------------------------------------------------+
'| Done by RhoSigma, R.Heyder, provided AS IS, use at your own risk. |
'| Find me in the QB64 Forum or mail to support@rhosigma-cw.net for  |
'| any questions or suggestions. Thanx for your interest in my work. |
'+-------------------------------------------------------------------+

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'RhoSigma/Sha2-Hash'

'--- Find QB64-PE and Example source folders depending on EXE location.
'-----
'Fill example$ and library$ with the exact names, i.e. the use of upper/lower
'case must match, so that it works on case sensitive Linux filesystems.
DIM example$: example$ = "Sha2-HowTo.bas" 'this example's source file name
DIM library$: library$ = "RhoSigma/Sha2-Hash" 'the library's name (as in $USELIBRARY)
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
_TITLE "SHA2-HowTo Output"
COLOR 9: PRINT VersionSha2HowTo$: COLOR 7

'--- Read the program's source file into a string
'--- and then pass it to the FUNCTION GetStringSHA2$().
'-----
file$ = "Sha2-HowTo.bas"
OPEN file$ FOR BINARY AS #1
a$ = SPACE$(LOF(1))
GET #1, , a$
CLOSE #1
PRINT
PRINT "loading a whole file into a string and compute SHA2 ..."
PRINT "SHA2 Digest of file "; CHR$(34); file$; CHR$(34)
PRINT ":  "; GetStringSHA2$(a$)
'-----
'--- Or directly call the FUNCTION GetFileSHA2$() for this kind of usage.
'-----
PRINT
PRINT "and now the same file, but using the file digest function directly ..."
PRINT "SHA2 Digest of file "; CHR$(34); file$; CHR$(34)
PRINT ":  "; GetFileSHA2$(file$)

'--- Here's a quick try with a simple predefined literal string.
'-----
a$ = "qb64phoenix.com"
PRINT
PRINT "SHA2 Digest of string "; CHR$(34); a$; CHR$(34)
PRINT ":  "; GetStringSHA2$(a$)

'--- Yet another try in a loop.
'-----
PRINT
PRINT "continuously changing, press any key to stop ..."
WHILE INKEY$ = ""
    _LIMIT 5
    a$ = DATE$ + " " + TIME$
    LOCATE 15, 1
    PRINT "SHA2 Digest date/time "; CHR$(34); a$; CHR$(34)
    PRINT ":  "; GetStringSHA2$(a$)
WEND
PRINT
PRINT "imagine this method used with counting hours and/or minutes only"
PRINT "to create a timed code lock like on a bank tresor :)"

'--- Make your best guess what happens here.
'-----
END

'--- Function to define/return the program's version string.
'-----
FUNCTION VersionSha2HowTo$
    VersionSha2HowTo$ = MID$("$VER: Sha2-HowTo 1.0 (15-Sep-2021) by RhoSigma :END$", 7, 40)
END FUNCTION

