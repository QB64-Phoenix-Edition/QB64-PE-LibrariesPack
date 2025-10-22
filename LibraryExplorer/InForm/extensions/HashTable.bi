'-----------------------------------------------------------------------------------------------------------------------
' A simple hash table library
' Copyright (c) 2025 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$INCLUDEONCE

' Hash table entry type
TYPE HashTableType
    U AS _BYTE ' used?
    K AS _UNSIGNED LONG ' key
    V AS STRING ' value
END TYPE

