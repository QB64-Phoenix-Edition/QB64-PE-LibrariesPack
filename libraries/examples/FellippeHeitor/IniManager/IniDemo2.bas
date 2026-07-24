'INI Manager - demo 2
'
'syntax: var$ = Ini_ReadSetting(file$, "", "")
'
'You can read all keys/values from an .ini file by calling
'Ini_ReadSetting with empty section$ and key$ values.
'----------------------------------------------------------------

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'FellippeHeitor/IniManager'

'--- Find QB64-PE and Example source folders depending on EXE location.
'-----
'Fill example$ and library$ with the exact names, i.e. the use of upper/lower
'case must match, so that it works on case sensitive Linux filesystems.
DIM example$: example$ = "IniDemo2.bas" 'this example's source file name
DIM library$: library$ = "FellippeHeitor/IniManager" 'the library's name (as in $USELIBRARY)
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
    a$ = Ini_ReadSetting$("test.ini", "", "")

    'NOTE: If you would check dot values of the __ini TYPE inside a SUB or FUNCTION,
    '      then remember to explicitly do a SHARED __ini in the respective routine.
    IF __ini.code = 1 THEN PRINT Ini_GetInfo$: END '__ini.code = 1 -> File not found
    IF __ini.code = 10 THEN EXIT DO '__ini.code = 10 -> No more keys found

    COLOR 7
    PRINT __ini.lastSection$;
    COLOR 15: PRINT __ini.lastKey$;
    COLOR 4: PRINT "=";
    COLOR 2: PRINT a$
LOOP
COLOR 9
PRINT "End of file."

'----------------------------------------------------------------
'syntax: var$ = Ini_ReadSetting(file$, "[section]", "")
'
'You can read all keys/values from a specific section by calling
'Ini_ReadSetting with an empty key$ value.
'----------------------------------------------------------------
PRINT
COLOR 9
PRINT "Fetch only section [contact]:"
DO
    a$ = Ini_ReadSetting$("test.ini", "contact", "")

    'NOTE: If you would check dot values of the __ini TYPE inside a SUB or FUNCTION,
    '      then remember to explicitly do a SHARED __ini in the respective routine.
    IF __ini.code = 1 THEN PRINT Ini_GetInfo$: END '__ini.code = 1 -> File not found
    IF __ini.code = 10 THEN EXIT DO '__ini.code = 10 -> No more keys found
    IF __ini.code = 14 THEN PRINT Ini_GetInfo$: END '__ini.code = 14 -> Section not found

    COLOR 7
    PRINT __ini.lastSection$;
    COLOR 15: PRINT __ini.lastKey$;
    COLOR 4: PRINT "=";
    COLOR 2: PRINT a$
LOOP
COLOR 9
PRINT "End of section."

