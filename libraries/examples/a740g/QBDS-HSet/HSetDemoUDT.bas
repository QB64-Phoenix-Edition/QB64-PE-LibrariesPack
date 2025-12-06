$CONSOLE:ONLY

OPTION _EXPLICIT

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'a740g/QBDS-HSet'

TYPE Student
    id AS LONG
    nam AS STRING * 50
END TYPE

REDIM mySet(0) AS HSet

HSet_Initialize mySet()
PRINT "HSet initialized"
PRINT

PRINT "Adding students..."
DIM s1 AS Student, s2 AS Student, s3 AS Student
s1.id = 1: s1.nam = "John Doe"
s2.id = 2: s2.nam = "Jane Smith"
s3.id = 3: s3.nam = "Peter Jones"
HSet_AddStudent mySet(), s1
HSet_AddStudent mySet(), s2
PRINT "Students added"
PRINT "Count: "; HSet_GetCount(mySet())
PRINT

PRINT "Checking for students..."
PRINT "Contains 'John Doe': "; _IIF(HSet_ContainsStudent(mySet(), s1), "True", "False")
PRINT "Contains 'Peter Jones': "; _IIF(HSet_ContainsStudent(mySet(), s3), "True", "False")
PRINT

PRINT "Removing a student..."
HSet_RemoveStudent mySet(), s2
PRINT "Removed 'Jane Smith'"
PRINT "Count: "; HSet_GetCount(mySet())
PRINT "Contains 'Jane Smith': "; _IIF(HSet_ContainsStudent(mySet(), s2), "True", "False")
PRINT

PRINT "Freeing the set..."
HSet_Free mySet()

END

SUB HSet_AddStudent (set() AS HSet, v AS Student)
    DIM buffer AS STRING: buffer = SPACE$(LEN(v))
    QBDS_CopyMemory _OFFSET(buffer), _OFFSET(v), LEN(v)
    __HSet_Add set(), buffer, QBDS_TYPE_UDT
END SUB

FUNCTION HSet_ContainsStudent%% (set() AS HSet, v AS Student)
    DIM buffer AS STRING: buffer = SPACE$(LEN(v))
    QBDS_CopyMemory _OFFSET(buffer), _OFFSET(v), LEN(v)
    HSet_ContainsStudent = __HSet_Contains(set(), buffer)
END FUNCTION

SUB HSet_RemoveStudent (set() AS HSet, v AS Student)
    DIM buffer AS STRING: buffer = SPACE$(LEN(v))
    QBDS_CopyMemory _OFFSET(buffer), _OFFSET(v), LEN(v)
    DIM ignored AS _BYTE: ignored = __HSet_Remove(set(), buffer)
END SUB

SUB PrintStudent (s AS Student)
    PRINT "ID: "; s.id, "Name: "; s.nam
END SUB

