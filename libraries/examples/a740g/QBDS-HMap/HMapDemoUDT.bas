OPTION _EXPLICIT

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'a740g/QBDS-HMap'

TYPE Student
    id AS LONG
    nam AS STRING * 50
    atten AS LONG
    grade AS LONG
END TYPE

REDIM studentMap(0) AS HMap: HMap_Initialize studentMap()

DIM st AS Student, i AS LONG

RESTORE student_data:
FOR i = 1 TO 10
    READ st.id, st.nam, st.atten, st.grade
    HMap_SetStudent studentMap(), _TOSTR$(st.id), st
NEXT i

DO
    INPUT "Enter student ID (1-10 or 0 to quit): ", i

    IF i THEN
        HMap_GetStudent studentMap(), _TOSTR$(i), st
        PRINT USING "ID: ####, Name: \                       \, Attendance: ####, Grade: ####"; st.id, st.nam, st.atten, st.grade
    ELSE
        EXIT DO
    END IF
LOOP

END

student_data:
DATA 1,"John Doe",80,90
DATA 2,"Jane Doe",90,95
DATA 3,"Bob Smith",70,80
DATA 4,"Alice Johnson",85,85
DATA 5,"David Lee",95,95
DATA 6,"Emily Davis",75,75
DATA 7,"Michael Wilson",90,90
DATA 8,"Olivia Brown",80,80
DATA 9,"William Taylor",70,70
DATA 10,"Sophia Anderson",85,85

SUB HMap_SetStudent (map() AS HMap, k AS STRING, v AS Student)
    DIM buffer AS STRING: buffer = SPACE$(LEN(v))
    QBDS_CopyMemory _OFFSET(buffer), _OFFSET(v), LEN(v)
    __HMap_Set map(), k, buffer, QBDS_TYPE_UDT
END SUB

SUB HMap_GetStudent (map() AS HMap, k AS STRING, v AS Student)
    DIM buffer AS STRING: buffer = __HMap_Get(map(), k)
    QBDS_CopyMemory _OFFSET(v), _OFFSET(buffer), _MIN(LEN(v), LEN(buffer))
END SUB

