'-----------------------------------------------------------------------------------------------------------------------
' A simple integer hash map library for QB64-PE with support for multiple data types and dynamic resizing
' Copyright (c) 2025 Samuel Gomes
'-----------------------------------------------------------------------------------------------------------------------

$INCLUDEONCE

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'a740g/QBDS'

''' @brief Primary data structure used by the HMap64 library.
''' The user declares a dynamic array of this type and passes it to the HMap64_* functions.
''' The library stores internal metadata at array index 0; user entries begin at index 1.
''' Metadata (stored in element 0):
'''     - K: count of items
'''     - V: unused
'''     - T: set to QBDS_TYPE_RESERVED
TYPE HMap64
    K AS _UNSIGNED _INTEGER64 ' key or metadata (count)
    V AS STRING ' value or metadata (unused)
    T AS _UNSIGNED _BYTE ' data type of the value (0 = unused) or metadata (QBDS_TYPE_RESERVED)
END TYPE

