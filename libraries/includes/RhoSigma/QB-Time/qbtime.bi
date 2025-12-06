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
'| === qbtime.bi ===                                                 |
'|                                                                   |
'| == Definitions required for the routines provided in qbtime.bm.   |
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

$USELIBRARY:'RhoSigma/QB-StdArg'

'--- Helper functions defined in qbtime.h, which should sit along with
'--- the respective .bi/.bm files.
'-----
DECLARE LIBRARY "qbtime" 'Do not add .h here !!
    FUNCTION CurrentTimeToBuffer%& ALIAS "rsqbtime::CurrentTimeToBuffer" (BYVAL cFmtStr%&)
    FUNCTION GivenTimeToBuffer%& ALIAS "rsqbtime::GivenTimeToBuffer" (BYVAL cFmtStr%&, qbArgStr$)
    'The low level wrappers to "strftime()", you should not use this directly,
    'rather use the QB64 SUBs/FUNCTIONs provided in the qbtime.bm include.
END DECLARE

