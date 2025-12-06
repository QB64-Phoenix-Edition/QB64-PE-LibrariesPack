OPTION _EXPLICIT

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'a740g/QBDS-LList'

TYPE Person
    nam AS STRING * 50
    age AS _UNSIGNED _BYTE
END TYPE

REDIM personList(0) AS LList: LList_Initialize personList()

DIM p AS Person, i AS LONG, yn AS STRING, nam AS STRING

RESTORE person_data:
FOR i = 1 TO 10
    READ p.nam, p.age
    LList_PushBackPerson personList(), p
NEXT i

DIM node AS _UNSIGNED _OFFSET

DO
    PRINT
    PRINT "1. Show list"
    PRINT "2. Add person"
    PRINT "3. Delete person"
    PRINT "4. Find person"
    PRINT "5. Exit"
    INPUT "Enter your choice: ", i
    PRINT

    SELECT CASE i
        CASE 1
            node = LList_GetFrontNode(personList())
            WHILE node
                LList_GetPerson personList(), node, p
                PRINT "Name: "; _TRIM$(p.nam), "Age: "; p.age
                node = LList_GetNextNode(personList(), node)
            WEND

        CASE 2
            INPUT "Enter name: ", p.nam
            INPUT "Enter age: ", p.age
            INPUT "Add to front (F) or back (B)? ", yn
            IF UCASE$(_TRIM$(yn)) = "F" THEN
                LList_PushFrontPerson personList(), p
            ELSE
                LList_PushBackPerson personList(), p
            END IF

        CASE 3
            INPUT "Enter name of person to delete: ", nam
            node = LList_GetFrontNode(personList())
            WHILE node
                LList_GetPerson personList(), node, p
                IF INSTR(LCASE$(p.nam), LCASE$(_TRIM$(nam))) > 0 THEN
                    PRINT "Found "; _TRIM$(p.nam)
                    INPUT "Delete (Y/N)?", yn
                    IF UCASE$(_TRIM$(yn)) = "Y" THEN
                        LList_RemoveNode personList(), node
                        PRINT "Person deleted"
                        EXIT WHILE
                    END IF
                END IF
                node = LList_GetNextNode(personList(), node)
            WEND

            IF NOT node THEN
                PRINT "Person not found"
            END IF

        CASE 4
            INPUT "Enter name of person to find: ", nam
            i = 0
            node = LList_GetFrontNode(personList())
            WHILE node
                LList_GetPerson personList(), node, p
                IF INSTR(LCASE$(p.nam), LCASE$(_TRIM$(nam))) > 0 THEN
                    i = i + 1
                    PRINT "Name: "; _TRIM$(p.nam), "Age: "; p.age
                END IF
                node = LList_GetNextNode(personList(), node)
            WEND

            IF i THEN
                PRINT "Found"; i; "matching person"
            ELSE
                PRINT "Person not found"
            END IF

        CASE 5
            EXIT DO
    END SELECT
LOOP

END

person_data:
DATA "John Smith",30
DATA "Jane Doe",25
DATA "Bob Johnson",35
DATA "Sarah Lee",28
DATA "Mike Davis",32
DATA "Emily Wilson",27
DATA "David Brown",33
DATA "Olivia Taylor",29
DATA "William Anderson",31
DATA "Sophia Martinez",26

SUB LList_GetPerson (lst() AS LList, node AS _UNSIGNED _OFFSET, p AS Person)
    DIM buffer AS STRING: buffer = __LList_Get(lst(), node)
    QBDS_CopyMemory _OFFSET(p), _OFFSET(buffer), _MIN(LEN(p), LEN(buffer))
END SUB

SUB LList_SetPerson (lst() AS LList, node AS _UNSIGNED _OFFSET, p AS Person)
    DIM buffer AS STRING: buffer = SPACE$(LEN(p))
    QBDS_CopyMemory _OFFSET(buffer), _OFFSET(p), LEN(p)
    __LList_Set lst(), node, buffer, QBDS_TYPE_UDT
END SUB

SUB LList_InsertBeforePerson (lst() AS LList, node AS _UNSIGNED _OFFSET, p AS Person)
    DIM buffer AS STRING: buffer = SPACE$(LEN(p))
    QBDS_CopyMemory _OFFSET(buffer), _OFFSET(p), LEN(p)
    __LList_InsertBefore lst(), node, buffer, QBDS_TYPE_UDT
END SUB

SUB LList_InsertAfterPerson (lst() AS LList, node AS _UNSIGNED _OFFSET, p AS Person)
    DIM buffer AS STRING: buffer = SPACE$(LEN(p))
    QBDS_CopyMemory _OFFSET(buffer), _OFFSET(p), LEN(p)
    __LList_InsertAfter lst(), node, buffer, QBDS_TYPE_UDT
END SUB

SUB LList_PushFrontPerson (lst() AS LList, p AS Person)
    DIM buffer AS STRING: buffer = SPACE$(LEN(p))
    QBDS_CopyMemory _OFFSET(buffer), _OFFSET(p), LEN(p)
    __LList_PushFront lst(), buffer, QBDS_TYPE_UDT
END SUB

SUB LList_PushBackPerson (lst() AS LList, p AS Person)
    DIM buffer AS STRING: buffer = SPACE$(LEN(p))
    QBDS_CopyMemory _OFFSET(buffer), _OFFSET(p), LEN(p)
    __LList_PushBack lst(), buffer, QBDS_TYPE_UDT
END SUB

SUB LList_PopFrontPerson (lst() AS LList, p AS Person)
    DIM node AS _UNSIGNED _OFFSET: node = LList_GetFrontNode(lst())
    DIM buffer AS STRING: buffer = __LList_Get(lst(), node)
    QBDS_CopyMemory _OFFSET(p), _OFFSET(buffer), _MIN(LEN(p), LEN(buffer))
    LList_RemoveNode lst(), node
END SUB

SUB LList_PopBackPerson (lst() AS LList, p AS Person)
    DIM node AS _UNSIGNED _OFFSET: node = LList_GetBackNode(lst())
    DIM buffer AS STRING: buffer = __LList_Get(lst(), node)
    QBDS_CopyMemory _OFFSET(p), _OFFSET(buffer), _MIN(LEN(p), LEN(buffer))
    LList_RemoveNode lst(), node
END SUB

