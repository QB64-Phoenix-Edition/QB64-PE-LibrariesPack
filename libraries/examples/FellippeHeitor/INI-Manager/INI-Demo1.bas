'INI Manager - demo 1
'
'syntax: WriteSetting file$, section$, key$, value$

'write a new key/value pair to an .ini file or update an existing
'if the file doesn't exist, it'll be created.
'----------------------------------------------------------------

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'FellippeHeitor/INI-Manager'

'--- Find QB64-PE and Example source folders depending on EXE location.
'-----
'Fill example$ and library$ with the exact names, i.e. the use of upper/lower
'case must match, so that it works on case sensitive Linux filesystems.
DIM example$: example$ = "INI-Demo1.bas" 'this example's source file name
DIM library$: library$ = "FellippeHeitor/INI-Manager" 'the library's name (as in $USELIBRARY)
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

'(brackets in section names are optional; will be added automatically anyway)
WriteSetting "test.ini", "[general]", "version", "Beta 4"
GOSUB Status

'subsequent calls don't need to mention the file again
WriteSetting "", "general", "date", DATE$
GOSUB Status

WriteSetting "", "general", "time", TIME$
GOSUB Status

WriteSetting "", "credits", "author", "Fellippe Heitor"
GOSUB Status

WriteSetting "", "contact", "email", "fellippe@qb64.org"
GOSUB Status

WriteSetting "", "contact", "twitter", "@FellippeHeitor"
GOSUB Status

PRINT "File created/updated. I'll wait for you to check it with your editor of choice."
PRINT "Hit any key to continue..."
PRINT
a$ = INPUT$(1)

WriteSetting "", "general", "version", "Beta 4 - check the repo"
GOSUB Status

PRINT "File updated again. Go check it if you will."
END

Status:
'NOTE: If you would check any INI state values inside a SUB or FUNCTION,
'      then those values must be explicitly SHARED in the respective routine.
COLOR 7: PRINT IniINFO$
COLOR 15: PRINT IniLastSection$; IniLastKey$: PRINT
RETURN

