$CONSOLE:ONLY

OPTION _EXPLICIT

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'a740g/QBDS-Queue'

TYPE Student
    id AS LONG
    nam AS STRING * 50
    atten AS LONG
    grade AS LONG
END TYPE

REDIM myQueue(0) AS Queue

Queue_Initialize myQueue()
PRINT "Queue initialized"
PRINT

PRINT "Enqueuing students..."
DIM s1 AS Student, s2 AS Student
s1.id = 1: s1.nam = "John Doe": s1.atten = 95: s1.grade = 88
s2.id = 2: s2.nam = "Jane Smith": s2.atten = 98: s2.grade = 92
Queue_EnqueueStudent myQueue(), s1
Queue_EnqueueStudent myQueue(), s2
PRINT "Students enqueued"
PRINT "Count: "; Queue_GetCount(myQueue())
PRINT

PRINT "Peeking at the front of the queue..."
DIM sOut AS Student
Queue_PeekStudent myQueue(), sOut
PrintStudent sOut
PRINT "Count: "; Queue_GetCount(myQueue())
PRINT

PRINT "Dequeuing students..."
Queue_DequeueStudent myQueue(), sOut
PrintStudent sOut
Queue_DequeueStudent myQueue(), sOut
PrintStudent sOut
PRINT "Count: "; Queue_GetCount(myQueue())
PRINT

PRINT "Freeing the queue..."
Queue_Free myQueue()

END

SUB Queue_PeekStudent (q() AS Queue, s AS Student)
    DIM buffer AS STRING: buffer = __Queue_Peek(q())
    QBDS_CopyMemory _OFFSET(s), _OFFSET(buffer), _MIN(LEN(s), LEN(buffer))
END SUB

SUB Queue_EnqueueStudent (q() AS Queue, s AS Student)
    DIM buffer AS STRING: buffer = SPACE$(LEN(s))
    QBDS_CopyMemory _OFFSET(buffer), _OFFSET(s), LEN(s)
    __Queue_Enqueue q(), buffer, QBDS_TYPE_UDT
END SUB

SUB Queue_DequeueStudent (q() AS Queue, s AS Student)
    DIM buffer AS STRING: buffer = __Queue_Dequeue(q())
    QBDS_CopyMemory _OFFSET(s), _OFFSET(buffer), _MIN(LEN(s), LEN(buffer))
END SUB

SUB PrintStudent (s AS Student)
    PRINT "ID: "; s.id, "Name: "; s.nam, "Atten: "; s.atten, "Grade: "; s.grade
END SUB

