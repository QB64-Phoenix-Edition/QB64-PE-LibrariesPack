'-----------------------------------------------------------------------------------------------------------------------
' INI Manager
' Copyright (c) 2024 Samuel Gomes
' Copyright (c) 2022 Fellippe Heitor
'-----------------------------------------------------------------------------------------------------------------------

$INCLUDEONCE

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

TYPE __IniType
    loadedFiles AS STRING
    currentFileName AS STRING
    currentFileLOF AS _UNSIGNED LONG
    wholeFile AS STRING
    sectionData AS STRING
    position AS _UNSIGNED LONG
    newFile AS STRING
    lastSection AS STRING
    lastKey AS STRING
    LF AS STRING ' new-line sequence
    disableAutoCommit AS _BYTE
    code AS LONG
    forceReload AS _BYTE
END TYPE

' Global variables declaration
DIM __ini AS __IniType
