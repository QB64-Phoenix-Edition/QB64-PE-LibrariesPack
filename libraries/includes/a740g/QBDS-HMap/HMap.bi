'-----------------------------------------------------------------------------------------------------------------------
' Generic hash map library for QB64-PE with support for multiple data types and dynamic resizing
' Copyright (c) 2025 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$INCLUDEONCE

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'a740g/QBDS'

''' @brief Primary data structure used by the HMap library.
''' The user declares a dynamic array of this type and passes it to the HMap_* functions.
''' The library stores internal metadata at array index 0; user entries begin at index 1.
''' Metadata (stored in element 0):
'''     - K: unused
'''     - V: count of items (_MK$(_UNSIGNED _OFFSET, count))
'''     - T: set to QBDS_TYPE_RESERVED
TYPE HMap
    K AS STRING ' key or metadata (unused)
    V AS STRING ' value or metadata (count)
    T AS _UNSIGNED _BYTE ' data type of the value (0 = unused) or metadata (QBDS_TYPE_RESERVED)
END TYPE

