'-----------------------------------------------------------------------------------------------------------------------
' Generic list library for QB64-PE with support for multiple data types and dynamic resizing
' Copyright (c) 2025 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$INCLUDEONCE

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'a740g/QBDS'

''' @brief Primary data structure used by the LList library.
''' The user declares a dynamic array of this type and passes it to the LList_* functions.
''' The library stores internal metadata at array index 0; user entries begin at index 1.
''' Metadata (stored in element 0):
'''     - p: head node index
'''     - n: tail node index
'''     - V: packed count + last free index (_MK$(_UNSIGNED _OFFSET, count) + _MK$(_UNSIGNED _OFFSET, lastFree))
'''     - T: QBDS_TYPE_RESERVED
TYPE LList
    p AS _UNSIGNED _OFFSET ' index of previous entry
    n AS _UNSIGNED _OFFSET ' index of next entry
    V AS STRING ' value
    T AS _UNSIGNED _BYTE ' data type of the value (0 = unused)
END TYPE

