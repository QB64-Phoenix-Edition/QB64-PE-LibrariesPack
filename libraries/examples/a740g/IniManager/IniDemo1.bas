'INI Manager - demo 1
'
'syntax: Ini_WriteSetting file$, section$, key$, value$

'write a new key/value pair to an .ini file or update an existing
'if the file doesn't exist, it'll be created.
'----------------------------------------------------------------

$USELIBRARY:'a740g/IniManager'

'set the program's work directory.
IF _FILEEXISTS("qb64.exe") _ORELSE _FILEEXISTS("qb64") _ORELSE _FILEEXISTS("qb64pe.exe") _ORELSE _FILEEXISTS("qb64pe") THEN
    CHDIR "libraries\examples\a740g\IniManager"
END IF

'(brackets in section names are optional; will be added automatically anyway)
Ini_WriteSetting "test.ini", "[general]", "version", "Beta 4"
GOSUB Status

'subsequent calls don't need to mention the file again
Ini_WriteSetting "", "general", "date", DATE$
GOSUB Status

Ini_WriteSetting "", "general", "time", TIME$
GOSUB Status

Ini_WriteSetting "", "credits", "author", "Fellippe Heitor"
GOSUB Status

Ini_WriteSetting "", "contact", "email", "fellippe@qb64.org"
GOSUB Status

Ini_WriteSetting "", "contact", "twitter", "@FellippeHeitor"
GOSUB Status

PRINT "File created/updated. I'll wait for you to check it with your editor of choice."
PRINT "Hit any key to continue..."
PRINT
a$ = INPUT$(1)

Ini_WriteSetting "", "general", "version", "Beta 4 - check the repo"
GOSUB Status

PRINT "File updated again. Go check it if you will."
END

Status:
'NOTE: If you would check dot values of the __ini TYPE inside a SUB or FUNCTION,
'      then remember to explicitly do a SHARED __ini in the respective routine.
COLOR 7: PRINT Ini_GetInfo$
COLOR 15: PRINT __ini.lastSection$; __ini.lastKey$: PRINT
RETURN

