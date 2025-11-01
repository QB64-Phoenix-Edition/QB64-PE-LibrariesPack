'INI Manager - demo 2
'
'syntax: var$ = Ini_ReadSetting(file$, "", "")
'
'You can read all keys/values from an .ini file by calling
'Ini_ReadSetting with empty section$ and key$ values.
'----------------------------------------------------------------

$USELIBRARY:'FellippeHeitor/IniManager'

'set the program's work directory.
IF _FILEEXISTS("qb64.exe") _ORELSE _FILEEXISTS("qb64") _ORELSE _FILEEXISTS("qb64pe.exe") _ORELSE _FILEEXISTS("qb64pe") THEN
    CHDIR "libraries\examples\FellippeHeitor\IniManager"
END IF

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

