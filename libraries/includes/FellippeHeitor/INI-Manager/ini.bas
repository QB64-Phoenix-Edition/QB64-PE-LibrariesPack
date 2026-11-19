'INI Manager v2.0
'Fellippe Heitor, 2017-2026 - @fellippeheitor

$INCLUDEONCE

'Error trap used by the library while it reads or writes files.
'Your own ON ERROR handler is saved and restored around every file operation.
IniIOErrorHandler:
IniIOError& = ERR
RESUME NEXT

