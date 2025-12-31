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

'--- Find the root path to the example's source folder.
'-----
IF _FILEEXISTS("IniDemo2.bas") THEN
    root$ = ""
ELSEIF _FILEEXISTS("qb64pe.exe") _ORELSE _FILEEXISTS("qb64pe") THEN
    root$ = "libraries\examples\FellippeHeitor\IniManager\"
ELSE
    qbfo$ = _SELECTFOLDERDIALOG$("Please locate your QB64-PE main folder...")
    IF LEN(qbfo$) > 0 _ANDALSO (_FILEEXISTS(qbfo$ + "\qb64pe.exe") _ORELSE _FILEEXISTS(qbfo$ + "\qb64pe")) THEN
        root$ = qbfo$ + "\libraries\examples\FellippeHeitor\IniManager\"
    ELSE
        PRINT "Can't locate required assets, please run again and select"
        PRINT "your QB64-PE folder when ask for it."
        END
    END IF
END IF

COLOR 9
PRINT "Fetch every key/value pair in the file:"
DO
    a$ = Ini_ReadSetting$(root$ + "test.ini", "", "")

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
    a$ = Ini_ReadSetting$(root$ + "test.ini", "contact", "")

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

