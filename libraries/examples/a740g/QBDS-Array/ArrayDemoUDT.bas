$CONSOLE:ONLY

OPTION _EXPLICIT

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'a740g/QBDS-Array'

TYPE Student
    id AS LONG
    nam AS STRING * 50
    atten AS LONG
    grade AS LONG
END TYPE

REDIM arr(0) AS Array

Array_Initialize arr()
PRINT "Array initialized"
PRINT

PRINT "Pushing students..."
DIM s1 AS Student, s2 AS Student
s1.id = 1: s1.nam = "John Doe": s1.atten = 95: s1.grade = 88
s2.id = 2: s2.nam = "Jane Smith": s2.atten = 98: s2.grade = 92
Array_PushBackStudent arr(), s1
Array_PushBackStudent arr(), s2
PRINT "Students pushed"
PRINT "Count: "; Array_GetCount(arr())
PRINT

PRINT "Accessing students..."
DIM sOut AS Student
Array_GetStudent arr(), 1, sOut
PrintStudent sOut
Array_GetStudent arr(), 2, sOut
PrintStudent sOut
PRINT

PRINT "Popping a student..."
DIM poppedStudent AS Student
Array_PopBackStudent arr(), poppedStudent
PRINT "Popped:"
PrintStudent poppedStudent
PRINT "Count: "; Array_GetCount(arr())
PRINT

PRINT "Freeing the array..."
Array_Free arr()

END

SUB Array_SetStudent (arr() AS Array, index AS _UNSIGNED _OFFSET, v AS Student)
    DIM buffer AS STRING: buffer = SPACE$(LEN(v))
    QBDS_CopyMemory _OFFSET(buffer), _OFFSET(v), LEN(v)
    __Array_Set arr(), index, buffer, QBDS_TYPE_UDT
END SUB

SUB Array_GetStudent (arr() AS Array, index AS _UNSIGNED _OFFSET, v AS Student)
    DIM buffer AS STRING: buffer = __Array_Get(arr(), index)
    QBDS_CopyMemory _OFFSET(v), _OFFSET(buffer), _MIN(LEN(v), LEN(buffer))
END SUB

SUB Array_PushBackStudent (arr() AS Array, v AS Student)
    DIM buffer AS STRING: buffer = SPACE$(LEN(v))
    QBDS_CopyMemory _OFFSET(buffer), _OFFSET(v), LEN(v)
    __Array_PushBack arr(), buffer, QBDS_TYPE_UDT
END SUB

SUB Array_PopBackStudent (arr() AS Array, v AS Student)
    DIM buffer AS STRING: buffer = __Array_PopBack(arr())
    QBDS_CopyMemory _OFFSET(v), _OFFSET(buffer), _MIN(LEN(v), LEN(buffer))
END SUB

SUB PrintStudent (s AS Student)
    PRINT "ID: "; s.id, "Name: "; s.nam, "Atten: "; s.atten, "Grade: "; s.grade
END SUB

