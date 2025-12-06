'-----------------------------------------------------------------------------------------------------------------------
' Generic hash set library for QB64-PE
' Copyright (c) 2025 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$INCLUDEONCE

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'a740g/QBDS'

''' @brief Primary data structure used by the HSet library.
''' The user declares a dynamic array of this type and passes it to the HSet_* functions.
''' The library stores internal metadata at array index 0; user entries begin at index 1.
''' Metadata (stored in element 0):
'''     - V: count of items (_MK$(_UNSIGNED _OFFSET, count))
'''     - T: QBDS_TYPE_RESERVED
TYPE HSet
    V AS STRING
    T AS _UNSIGNED _BYTE
END TYPE

