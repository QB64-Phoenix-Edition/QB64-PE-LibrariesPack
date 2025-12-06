$CONSOLE:ONLY

OPTION _EXPLICIT

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'a740g/QBDS-HSet'

REDIM mySet(0) AS HSet

HSet_Initialize mySet()
PRINT "HSet initialized"
PRINT "Is initialized: "; _IIF(HSet_IsInitialized(mySet()), "True", "False")
PRINT "Count: "; HSet_GetCount(mySet())
PRINT "Capacity: "; HSet_GetCapacity(mySet())
PRINT

PRINT "Adding items..."
HSet_AddString mySet(), "Apple"
HSet_AddString mySet(), "Banana"
HSet_AddInteger mySet(), 42
HSet_AddLong mySet(), 123456789
HSet_AddSingle mySet(), 3.14
HSet_AddDouble mySet(), 1.23456789012345
PRINT "Items added"
PRINT "Count: "; HSet_GetCount(mySet())
PRINT "Capacity: "; HSet_GetCapacity(mySet())
PRINT

PRINT "Checking for items..."
PRINT "Contains 'Apple': "; _IIF(HSet_ContainsString(mySet(), "Apple"), "True", "False")
PRINT "Contains 'Grape': "; _IIF(HSet_ContainsString(mySet(), "Grape"), "True", "False")
PRINT "Contains 42: "; _IIF(HSet_ContainsInteger(mySet(), 42), "True", "False")
PRINT "Contains 99: "; _IIF(HSet_ContainsInteger(mySet(), 99), "True", "False")
PRINT

PRINT "Removing an item..."
HSet_RemoveString mySet(), "Banana"
PRINT "Removed 'Banana'"
PRINT "Count: "; HSet_GetCount(mySet())
PRINT "Contains 'Banana': "; _IIF(HSet_ContainsString(mySet(), "Banana"), "True", "False")
PRINT

PRINT "Clearing the set..."
HSet_Clear mySet()
PRINT "Count: "; HSet_GetCount(mySet())
PRINT "Capacity: "; HSet_GetCapacity(mySet())
PRINT

PRINT "Freeing the set..."
HSet_Free mySet()
PRINT "Is initialized: "; _IIF(HSet_IsInitialized(mySet()), "True", "False")

