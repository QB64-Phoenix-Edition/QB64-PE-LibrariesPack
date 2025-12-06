'-----------------------------------------------------------------------------------------------------------------------
' Minimalistic test framework library for QB64-PE
' Copyright (c) 2025 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$INCLUDEONCE

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$IF _CONSOLE_ = 0 THEN
    $ERROR "For outputs the Catch library needs a '$CONSOLE' before '$USELIBRARY'"
$END IF

CONST __TEST_COLOR_HEADER = 36 ' light cyan
CONST __TEST_COLOR_PASS = 32 ' light green
CONST __TEST_COLOR_FAIL = 31 ' light red
CONST __TEST_COLOR_SKIP = 33 ' yellow
CONST __TEST_COLOR_NOTE = 90 ' dark gray
CONST __TEST_COLOR_NAME = 97 ' white
CONST __TEST_COLOR_ARROW = 94 ' light blue
CONST __TEST_COLOR_KIND = 35 ' magenta
CONST __TEST_SEPARATOR_WIDTH = 79

TYPE __TestState
    testsRun AS LONG
    assertions AS LONG
    failures AS LONG
    currentTestName AS STRING
    currentTestChecks AS LONG
    currentTestFails AS LONG
    abortCurrentTest AS _BYTE
    skipCurrentTest AS _BYTE
    testStart AS _UNSIGNED _INTEGER64
    filter AS STRING
    errorHandlerEnabled AS _BYTE
    colorDisabled AS _BYTE
    exitOnEndDisabled AS _BYTE
    rngSeed AS _UNSIGNED _INTEGER64
END TYPE

DIM __TestState AS __TestState
DIM __errorLine AS _UNSIGNED _INTEGER64
DIM __errorFile AS STRING

