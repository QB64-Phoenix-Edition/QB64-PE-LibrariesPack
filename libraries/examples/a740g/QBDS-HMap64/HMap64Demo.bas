$CONSOLE:ONLY

OPTION _EXPLICIT

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'a740g/QBDS-HMap64'

REDIM map(0) AS HMap64

PrintCaption "Initializing Map"
PrintBool "Map initialized", HMap64_IsInitialized(map())
PRINT "Initializing map"
HMap64_Initialize map()
PrintBool "Map initialized", HMap64_IsInitialized(map())
PRINT "Count:"; HMap64_GetCount(map())
PRINT "Capacity:"; HMap64_GetCapacity(map())

PrintCaption "Adding values"
HMap64_SetString map(), 1, "John Doe"
HMap64_SetInteger map(), 2, 30
HMap64_SetDouble map(), 3, 1.75
HMap64_SetString map(), 4, "New York"
DumpMap map()
PRINT "Count:"; HMap64_GetCount(map())

PrintCaption "Updating a value"
HMap64_SetInteger map(), 2, 31
PrintValue map(), 2

PrintCaption "Checking for a key"
PrintBool "Exists 3", HMap64_Contains(map(), 3)
PrintBool "Exists 5", HMap64_Contains(map(), 5)

PrintCaption "Deleting a key"
HMap64_Remove map(), 4
PRINT "Deleted 4"
DumpMap map()
PRINT "Count:"; HMap64_GetCount(map())

PrintCaption "Clearing the map"
HMap64_Clear map()
PRINT "Map cleared"
PRINT "Count:"; HMap64_GetCount(map())
PRINT "Capacity:"; HMap64_GetCapacity(map())

PrintCaption "Freeing the map"
HMap64_Free map()
PRINT "Map freed"

PrintBool "Map initialized", HMap64_IsInitialized(map())

END

SUB PrintBool (message AS STRING, value AS _BYTE)
    PRINT message; ": "; _IIF(value, "yes", "no")
END SUB

SUB PrintCaption (caption AS STRING)
    PRINT _CHR_LF; "--- "; caption; " ---"; _CHR_LF
END SUB

SUB PrintValue (map() AS HMap64, k AS _UNSIGNED _INTEGER64)
    PRINT k; " = ";
    SELECT CASE HMap64_GetEntryDataType(map(), k)
        CASE QBDS_TYPE_STRING
            PRINT _CHR_QUOTE; HMap64_GetString(map(), k); _CHR_QUOTE
        CASE QBDS_TYPE_BYTE
            PRINT HMap64_GetByte(map(), k)
        CASE QBDS_TYPE_INTEGER
            PRINT HMap64_GetInteger(map(), k)
        CASE QBDS_TYPE_LONG
            PRINT HMap64_GetLong(map(), k)
        CASE QBDS_TYPE_INTEGER64
            PRINT HMap64_GetInteger64(map(), k)
        CASE QBDS_TYPE_SINGLE
            PRINT HMap64_GetSingle(map(), k)
        CASE QBDS_TYPE_DOUBLE
            PRINT HMap64_GetDouble(map(), k)
        CASE QBDS_TYPE_NONE
            PRINT "<UNUSED>"
        CASE QBDS_TYPE_RESERVED
            PRINT "<RESERVED>"
        CASE QBDS_TYPE_DELETED
            PRINT "<DELETED>"
        CASE ELSE
            PRINT "<UDT>"
    END SELECT
END SUB

SUB DumpMap (map() AS HMap64)
    DIM i AS LONG
    FOR i = 1 TO UBOUND(map)
        IF map(i).T > QBDS_TYPE_DELETED THEN
            PrintValue map(), map(i).K
        END IF
    NEXT
END SUB

