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
'| === qbstdarg.bi ===                                               |
'|                                                                   |
'| == Definitions required for the routines provided in qbstdarg.bm. |
'|                                                                   |
'+-------------------------------------------------------------------+
'| Done by RhoSigma, R.Heyder, provided AS IS, use at your own risk. |
'| Find me in the QB64 Forum or mail to support@rhosigma-cw.net for  |
'| any questions or suggestions. Thanx for your interest in my work. |
'+-------------------------------------------------------------------+

$INCLUDEONCE

'--- Helper functions defined in qbstdarg.h, which should sit along with
'--- the respective .bi/.bm files.
'-----
DECLARE LIBRARY "qbstdarg" 'Do not add .h here !!
    FUNCTION MakeCString%& ALIAS "rsqbstdarg::MakeCString" (qbStr$, BYVAL qbStrLen&) 'add CHR$(0) to Str$, but pass Len& without
    FUNCTION LenCString& ALIAS "rsqbstdarg::LenCString" (BYVAL cStr%&)
    FUNCTION ReadCString$ ALIAS "rsqbstdarg::ReadCString" (BYVAL cStr%&)
    SUB FreeCString ALIAS "rsqbstdarg::FreeCString" (BYVAL cStr%&)
    FUNCTION OffToInt&& ALIAS "rsqbstdarg::OffToInt" (BYVAL offs%&)
    'Some low level support functions, you should not use this directly,
    'rather use the QB64 SUBs/FUNCTIONs provided in the qbstdarg.bm include.
END DECLARE

