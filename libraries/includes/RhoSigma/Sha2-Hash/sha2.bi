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
'| === sha2.bi ===                                                   |
'|                                                                   |
'| == Definitions required for the routines provided in sha2.bm.     |
'|                                                                   |
'+-------------------------------------------------------------------+
'| Done by RhoSigma, R.Heyder, provided AS IS, use at your own risk. |
'| Find me in the QB64 Forum or mail to support@rhosigma-cw.net for  |
'| any questions or suggestions. Thanx for your interest in my work. |
'+-------------------------------------------------------------------+

$INCLUDEONCE

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

'--- Helper functions defined in sha2.h, which should sit along with
'--- the respective .bi/.bm files.
'-----
DECLARE LIBRARY "sha2" 'Do not add .h here !!
    FUNCTION FileSHA2$ ALIAS "rsqbsha2::sha2_file" (qbFile$) 'add CHR$(0) to File$
    FUNCTION StringSHA2$ ALIAS "rsqbsha2::sha2_string" (qbStr$, BYVAL qbStrLen&) 'add CHR$(0) to Str$, but pass Len& without
    'The low level wrappers to SHA2, you should not use this directly,
    'rather use the QB64 FUNCTIONs provided in the sha2.bm include.
END DECLARE

