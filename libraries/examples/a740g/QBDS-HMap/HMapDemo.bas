$CONSOLE:ONLY

OPTION _EXPLICIT

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'a740g/QBDS-HMap'

REDIM map(0) AS HMap

PrintCaption "Initializing Map"
PrintBool "Map initialized", HMap_IsInitialized(map())
PRINT "Initializing map"
HMap_Initialize map()
PrintBool "Map initialized", HMap_IsInitialized(map())
PRINT "Count:"; HMap_GetCount(map())
PRINT "Capacity:"; HMap_GetCapacity(map())

PrintCaption "Adding values"
HMap_SetString map(), "name", "John Doe"
HMap_SetInteger map(), "age", 30
HMap_SetDouble map(), "height", 1.75
HMap_SetString map(), "city", "New York"
DumpMap map()
PRINT "Count:"; HMap_GetCount(map())

PrintCaption "Updating a value"
HMap_SetInteger map(), "age", 31
PrintValue map(), "age"

PrintCaption "Checking for a key"
PrintBool "Exists 'city'", HMap_Contains(map(), "city")
PrintBool "Exists 'country'", HMap_Contains(map(), "country")

PrintCaption "Deleting a key"
HMap_Remove map(), "city"
PRINT "Deleted 'city'"
DumpMap map()
PRINT "Count:"; HMap_GetCount(map())

PrintCaption "Clearing the map"
HMap_Clear map()
PRINT "Map cleared"
PRINT "Count:"; HMap_GetCount(map())
PRINT "Capacity:"; HMap_GetCapacity(map())

PrintCaption "Freeing the map"
HMap_Free map()
PRINT "Map freed"

PrintBool "Map initialized", HMap_IsInitialized(map())

END

SUB PrintBool (message AS STRING, value AS _BYTE)
    PRINT message; ": "; _IIF(value, "yes", "no")
END SUB

SUB PrintCaption (caption AS STRING)
    PRINT _CHR_LF; "--- "; caption; " ---"; _CHR_LF
END SUB

SUB PrintValue (map() AS HMap, k AS STRING)
    PRINT k; " = ";
    SELECT CASE HMap_GetEntryDataType(map(), k)
        CASE QBDS_TYPE_STRING
            PRINT _CHR_QUOTE; HMap_GetString(map(), k); _CHR_QUOTE
        CASE QBDS_TYPE_BYTE
            PRINT HMap_GetByte(map(), k)
        CASE QBDS_TYPE_INTEGER
            PRINT HMap_GetInteger(map(), k)
        CASE QBDS_TYPE_LONG
            PRINT HMap_GetLong(map(), k)
        CASE QBDS_TYPE_INTEGER64
            PRINT HMap_GetInteger64(map(), k)
        CASE QBDS_TYPE_SINGLE
            PRINT HMap_GetSingle(map(), k)
        CASE QBDS_TYPE_DOUBLE
            PRINT HMap_GetDouble(map(), k)
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

SUB DumpMap (map() AS HMap)
    DIM i AS LONG
    FOR i = 1 TO UBOUND(map)
        IF map(i).T > QBDS_TYPE_DELETED THEN
            PrintValue map(), map(i).K
        END IF
    NEXT
END SUB

