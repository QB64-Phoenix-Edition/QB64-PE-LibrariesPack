OPTION _EXPLICIT

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'a740g/QBDS-HMap64'

TYPE Student
    id AS LONG
    nam AS STRING * 50
    atten AS LONG
    grade AS LONG
END TYPE

REDIM studentMap(0) AS HMap64: HMap64_Initialize studentMap()

DIM st AS Student, i AS LONG

RESTORE student_data:
FOR i = 1 TO 10
    READ st.id, st.nam, st.atten, st.grade
    HMap64_SetStudent studentMap(), st.id, st
NEXT i

DO
    INPUT "Enter student ID (1-10 or 0 to quit): ", i

    IF i THEN
        HMap64_GetStudent studentMap(), i, st
        PRINT USING "ID: ####, Name: \                       \, Attendance: ####, Grade: ####"; st.id, st.nam, st.atten, st.grade
    ELSE
        EXIT DO
    END IF
LOOP

END

student_data:
DATA 101,"John Smith",45,85
DATA 102,"Jane Doe",50,92
DATA 103,"Bob Johnson",40,75
DATA 104,"Sarah Lee",55,90
DATA 105,"Michael Brown",60,95
DATA 106,"Emily Davis",65,80
DATA 107,"David Wilson",70,85
DATA 108,"Olivia Taylor",75,90
DATA 109,"William Thompson",80,95
DATA 110,"Ava Martinez",85,80

SUB HMap64_SetStudent (map() AS HMap64, k AS _UNSIGNED _INTEGER64, v AS Student)
    DIM buffer AS STRING: buffer = SPACE$(LEN(v))
    QBDS_CopyMemory _OFFSET(buffer), _OFFSET(v), LEN(v)
    __HMap64_Set map(), k, buffer, QBDS_TYPE_UDT
END SUB

SUB HMap64_GetStudent (map() AS HMap64, k AS _UNSIGNED _INTEGER64, v AS Student)
    DIM buffer AS STRING: buffer = __HMap64_Get(map(), k)
    QBDS_CopyMemory _OFFSET(v), _OFFSET(buffer), _MIN(LEN(v), LEN(buffer))
END SUB

