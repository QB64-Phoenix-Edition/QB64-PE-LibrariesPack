'INI Manager - demo 2
'
'syntax: var$ = ReadSetting(file$, "", "")
'
'You can read all keys/values from an .ini file by calling
'ReadSetting with empty section$ and key$ values.
'----------------------------------------------------------------

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'FellippeHeitor/INI-Manager'

'--- Find QB64-PE and Example source folders depending on EXE location.
'-----
'Fill example$ and library$ with the exact names, i.e. the use of upper/lower
'case must match, so that it works on case sensitive Linux filesystems.
DIM example$: example$ = "INI-Demo2.bas" 'this example's source file name
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

COLOR 9
PRINT "Fetch every key/value pair in the file:"
DO
    a$ = ReadSetting$("test.ini", "", "")

    'NOTE: If you would check any INI state values inside a SUB or FUNCTION,
    '      then those values must be explicitly SHARED in the respective routine.
    IF IniCODE = 1 THEN PRINT IniINFO$: END 'IniCODE = 1 -> File not found
    IF IniCODE = 10 THEN EXIT DO 'IniCODE = 10 -> No more keys found

    COLOR 7
    PRINT IniLastSection$;
    COLOR 15: PRINT IniLastKey$;
    COLOR 4: PRINT "=";
    COLOR 2: PRINT a$
LOOP
COLOR 9
PRINT "End of file."

'----------------------------------------------------------------
'syntax: var$ = ReadSetting(file$, "[section]", "")
'
'You can read all keys/values from a specific section by calling
'ReadSetting with an empty key$ value.
'----------------------------------------------------------------
PRINT
COLOR 9
PRINT "Fetch only section [contact]:"
DO
    a$ = ReadSetting$("test.ini", "contact", "")

    'NOTE: If you would check any INI state values inside a SUB or FUNCTION,
    '      then those values must be explicitly SHARED in the respective routine.
    IF IniCODE = 1 THEN PRINT IniINFO$: END 'IniCODE = 1 -> File not found
    IF IniCODE = 10 THEN EXIT DO 'IniCODE = 10 -> No more keys found
    IF IniCODE = 14 THEN PRINT IniINFO$: END 'IniCODE = 14 -> Section not found

    COLOR 7
    PRINT IniLastSection$;
    COLOR 15: PRINT IniLastKey$;
    COLOR 4: PRINT "=";
    COLOR 2: PRINT a$
LOOP
COLOR 9
PRINT "End of section."

