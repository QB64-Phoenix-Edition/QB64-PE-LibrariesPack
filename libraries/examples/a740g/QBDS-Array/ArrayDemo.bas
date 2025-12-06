$CONSOLE:ONLY

OPTION _EXPLICIT

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'a740g/QBDS-Array'

REDIM arr(0) AS Array

Array_Initialize arr()
PRINT "Array initialized"
PRINT "Is initialized: "; _IIF(Array_IsInitialized(arr()), "True", "False")
PRINT "Count: "; Array_GetCount(arr())
PRINT "Capacity: "; Array_GetCapacity(arr())
PRINT

PRINT "Pushing items..."
Array_PushBackString arr(), "Hello"
Array_PushBackInteger arr(), 42
Array_PushBackLong arr(), 123456789
Array_PushBackSingle arr(), 3.14
Array_PushBackDouble arr(), 1.23456789012345
PRINT "Items pushed"
PRINT "Count: "; Array_GetCount(arr())
PRINT "Capacity: "; Array_GetCapacity(arr())
PRINT

PRINT "Accessing items..."
PRINT "Item 1 (String): "; Array_GetString(arr(), 1)
PRINT "Item 2 (Integer): "; Array_GetInteger(arr(), 2)
PRINT "Item 3 (Long): "; Array_GetLong(arr(), 3)
PRINT "Item 4 (Single): "; Array_GetSingle(arr(), 4)
PRINT "Item 5 (Double): "; Array_GetDouble(arr(), 5)
PRINT

PRINT "Setting items..."
Array_SetString arr(), 1, "World"
Array_SetInteger arr(), 2, 84
PRINT "Item 1 (String): "; Array_GetString(arr(), 1)
PRINT "Item 2 (Integer): "; Array_GetInteger(arr(), 2)
PRINT

PRINT "Popping an item..."
DIM popped AS DOUBLE
popped = Array_PopBackDouble(arr())
PRINT "Popped: "; popped
PRINT "Count: "; Array_GetCount(arr())
PRINT

PRINT "Clearing the array..."
Array_Clear arr()
PRINT "Count: "; Array_GetCount(arr())
PRINT "Capacity: "; Array_GetCapacity(arr())
PRINT

PRINT "Freeing the array..."
Array_Free arr()
PRINT "Is initialized: "; _IIF(Array_IsInitialized(arr()), "True", "False")

