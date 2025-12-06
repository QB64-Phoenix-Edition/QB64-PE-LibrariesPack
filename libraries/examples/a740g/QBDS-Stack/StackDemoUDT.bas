OPTION _EXPLICIT

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'a740g/QBDS-Stack'

TYPE Student
    id AS LONG
    nam AS STRING * 50
    atten AS LONG
    grade AS LONG
END TYPE

REDIM studentStack(0) AS Stack: Stack_Initialize studentStack()

DIM st AS Student, i AS LONG

RESTORE student_data:
FOR i = 1 TO 10
    READ st.id, st.nam, st.atten, st.grade
    Stack_PushStudent studentStack(), st
NEXT i

WHILE Stack_GetCount(studentStack())
    Stack_PopStudent studentStack(), st
    PRINT USING "ID: ####, Name: \                       \, Attendance: ####, Grade: ####"; st.id, st.nam, st.atten, st.grade
WEND

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

SUB Stack_PushStudent (stack() AS Stack, s AS Student)
    DIM buffer AS STRING: buffer = SPACE$(LEN(s))
    QBDS_CopyMemory _OFFSET(buffer), _OFFSET(s), LEN(s)
    __Stack_Push stack(), buffer, QBDS_TYPE_UDT
END SUB

SUB Stack_PopStudent (stack() AS Stack, s AS Student)
    DIM buffer AS STRING: buffer = __Stack_Pop(stack())
    QBDS_CopyMemory _OFFSET(s), _OFFSET(buffer), _MIN(LEN(s), LEN(buffer))
END SUB

SUB Stack_PeekStudent (stack() AS Stack, s AS Student)
    DIM buffer AS STRING: buffer = __Stack_Peek(stack())
    QBDS_CopyMemory _OFFSET(s), _OFFSET(buffer), _MIN(LEN(s), LEN(buffer))
END SUB

