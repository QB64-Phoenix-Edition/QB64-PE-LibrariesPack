'INI Manager - demo 3
'
'syntax: var$ = ReadSetting(file$, key$)
'
'An empty result can mean that the key wasn't found
'or that it was empty, as in the example:
'
'    [section]
'    key1=value1
'    key2=
'
'To know what exactly happened, read the global variable IniCODE.
'For a description of the status code, call IniINFO$
'----------------------------------------------------------------

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'FellippeHeitor/INI-Manager'

'--- Find QB64-PE and Example source folders depending on EXE location.
'-----
'Fill example$ and library$ with the exact names, i.e. the use of upper/lower
'case must match, so that it works on case sensitive Linux filesystems.
DIM example$: example$ = "INI-Demo3.bas" 'this example's source file name
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

file$ = "test.ini"
IF _FILEEXISTS(COMMAND$) THEN file$ = COMMAND$ 'passing an .ini will load it instead of test.ini

PRINT "Analyzing file "; file$
DO
    'display bottom status bar
    r = CSRLIN: c = POS(1)
    LOCATE 25, 1: COLOR 14, 6: PRINT SPACE$(80);: LOCATE 25, 2: PRINT "(no input to quit; = to list all key/value pairs";: COLOR 7, 0
    LOCATE r, c

    'read user input
    INPUT ; "Enter section/key to read: ", key$
    IF INSTR(key$, "/") THEN
        section$ = LEFT$(key$, INSTR(key$, "/") - 1)
        key$ = MID$(key$, INSTR(key$, "/") + 1)
    ELSE
        section$ = ""
    END IF

    IF key$ = "=" OR (section$ > "" AND key$ = "") THEN
        'list all key/value pairs
        CLS
        DO
            a$ = ReadSetting$(file$, section$, "")

            'NOTE: If you would check any INI state values inside a SUB or FUNCTION,
            '      then those values must be explicitly SHARED in the respective routine.
            IF IniCODE = 1 OR IniCODE = 17 THEN PRINT IniINFO$: EXIT DO 'IniCODE = 1 -> File not found, 17 -> empty file
            IF IniCODE = 14 OR IniCODE = 10 THEN PRINT IniINFO$: EXIT DO 'IniCODE = 14 -> Section not found, 10 -> No more keys found

            COLOR 7
            PRINT IniLastSection$;
            COLOR 15: PRINT IniLastKey$;
            COLOR 4: PRINT "=";
            COLOR 2: PRINT a$
        LOOP
        PRINT "End of file."
    ELSEIF LEN(LTRIM$(RTRIM$(key$))) > 0 THEN
        'read the key from the file
        a$ = ReadSetting$(file$, section$, key$)
        IF IniCODE THEN
            PRINT
            COLOR 15, 4
            PRINT "RETURN CODE: "; IniCODE, IniINFO$
            COLOR 7, 0
        ELSE
            PRINT " = ";
            COLOR 0, 2: PRINT a$;: COLOR 7, 0: PRINT
        END IF
    ELSE
        PRINT "No input."
        END
    END IF
    PRINT
LOOP

