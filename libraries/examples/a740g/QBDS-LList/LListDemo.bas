$CONSOLE:ONLY

OPTION _EXPLICIT

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'a740g/QBDS-LList'

REDIM Lmixed(0) AS LList: LList_Initialize Lmixed()
REDIM Llong(0) AS LList: LList_Initialize Llong()

PRINT "Initialized two lists"
PRINT "  Mixed  -> count:"; LList_GetCount(Lmixed()); " capacity:"; LList_GetCapacity(Lmixed())
PRINT "  Long   -> count:"; LList_GetCount(Llong()); " capacity:"; LList_GetCapacity(Llong())
PRINT

PRINT "Building mixed list: alpha, 10 (LONG), 2.5 (DOUBLE), 7 (BYTE), 9999999999 (INT64)"
LList_PushBackString Lmixed(), "alpha"
LList_PushBackLong Lmixed(), 10&
LList_PushBackDouble Lmixed(), 2.5#
LList_PushBackByte Lmixed(), 7
LList_PushBackInteger64 Lmixed(), 9999999999&&
PRINT "Count:"; LList_GetCount(Lmixed())
PrintForwardMixed Lmixed()
PRINT

DIM first AS _UNSIGNED _OFFSET: first = LList_GetFrontNode(Lmixed())
DIM second AS _UNSIGNED _OFFSET: second = LList_GetNextNode(Lmixed(), first)
PRINT "InsertBefore('10', 'before-10') and InsertAfter('10', 'after-10')"
LList_InsertBeforeString Lmixed(), second, "before-10"
LList_InsertAfterString Lmixed(), second, "after-10"
PrintForwardMixed Lmixed()
PRINT

DIM cur AS _UNSIGNED _OFFSET: cur = LList_GetFrontNode(Lmixed())
DO WHILE cur
    IF LList_GetNodeDataType(Lmixed(), cur) = QBDS_TYPE_LONG THEN
        PRINT "Deleting LONG node value:"; LList_GetLong(Lmixed(), cur)
        LList_RemoveNode Lmixed(), cur
        EXIT DO
    END IF
    cur = LList_GetNextNode(Lmixed(), cur)
LOOP
PrintForwardMixed Lmixed()
PRINT

PRINT "PopFrontString -> "; _CHR_QUOTE; LList_PopFrontString(Lmixed()); _CHR_QUOTE
PRINT "PopBackInteger64 -> "; LList_PopBackInteger64(Lmixed())
PrintForwardMixed Lmixed()
PRINT

PRINT "Clearing mixed list"
LList_Clear Lmixed()
PRINT "  Count after clear:"; LList_GetCount(Lmixed())
PRINT

PRINT "Building LONG list: 5, 10, 15, 20, 25"
LList_PushFrontLong Llong(), 10&
LList_PushFrontLong Llong(), 5&
LList_PushBackLong Llong(), 15&
LList_PushBackLong Llong(), 20&
LList_PushBackLong Llong(), 25&
PRINT "Count:"; LList_GetCount(Llong())
PrintForwardLong Llong()
PrintBackwardLong Llong()
PRINT

DIM n AS _UNSIGNED _OFFSET: n = LList_GetFrontNode(Llong())
WHILE n
    IF LList_GetLong(Llong(), n) = 15& THEN
        LList_RemoveNode Llong(), n
        EXIT WHILE
    END IF
    n = LList_GetNextNode(Llong(), n)
WEND

PRINT "After deleting 15:"
PrintForwardLong Llong()
PrintBackwardLong Llong()
PRINT

IF LList_GetCount(Llong()) > 0 THEN PRINT "PopFrontLong -> "; LList_PopFrontLong(Llong())
IF LList_GetCount(Llong()) > 0 THEN PRINT "PopBackLong  -> "; LList_PopBackLong(Llong())
PRINT "Remaining:"
PrintForwardLong Llong()
PrintBackwardLong Llong()
PRINT

PRINT "Making LONG list circular"
LList_MakeCircular Llong(), _TRUE
PRINT "IsCircular: "; _IIF(LList_IsCircular(Llong()), "yes", "no")

DIM front AS _UNSIGNED _OFFSET: front = LList_GetFrontNode(Llong())
n = front
PRINT " [Circular Forward LONG] ";
WHILE n
    PRINT LList_GetLong(Llong(), n); " ";

    n = LList_GetNextNode(Llong(), n)

    IF n = front THEN EXIT WHILE ' walk the chain just once
WEND
PRINT

PRINT: PRINT "Freeing lists"
LList_Free Lmixed()
LList_Free Llong()

END

SUB PrintForwardMixed (lst() AS LList)
    DIM start AS _UNSIGNED _OFFSET: start = LList_GetFrontNode(lst())
    DIM node AS _UNSIGNED _OFFSET: node = start

    PRINT " [Forward] ";

    WHILE node
        DIM dt AS _UNSIGNED _BYTE: dt = LList_GetNodeDataType(lst(), node)
        SELECT CASE dt
            CASE QBDS_TYPE_STRING
                PRINT _CHR_QUOTE; LList_GetString(lst(), node); _CHR_QUOTE; " ";
            CASE QBDS_TYPE_LONG
                PRINT LList_GetLong(lst(), node); " ";
            CASE QBDS_TYPE_DOUBLE
                PRINT USING "##.###### "; LList_GetDouble(lst(), node);
            CASE QBDS_TYPE_INTEGER64
                PRINT LList_GetInteger64(lst(), node); " ";
            CASE QBDS_TYPE_SINGLE
                PRINT USING "##.### "; LList_GetSingle(lst(), node);
            CASE QBDS_TYPE_BYTE
                PRINT LList_GetByte(lst(), node); " ";
            CASE ELSE
                PRINT "(?) ";
        END SELECT

        node = LList_GetNextNode(lst(), node)

        IF node = start THEN EXIT WHILE ' avoid looping forever if the list is circular
    WEND
    PRINT
END SUB

SUB PrintBackwardLong (lst() AS LList)
    DIM back AS _UNSIGNED _OFFSET: back = LList_GetBackNode(lst())
    DIM node AS _UNSIGNED _OFFSET: node = back

    PRINT " [Backward LONG] ";

    WHILE node
        PRINT LList_GetLong(lst(), node); " ";

        node = LList_GetPreviousNode(lst(), node)

        IF node = back THEN EXIT WHILE ' avoid looping forever if the list is circular
    WEND
    PRINT
END SUB

SUB PrintForwardLong (lst() AS LList)
    DIM start AS _UNSIGNED _OFFSET: start = LList_GetFrontNode(lst())
    DIM node AS _UNSIGNED _OFFSET: node = start

    PRINT " [Forward LONG] ";

    WHILE node
        PRINT LList_GetLong(lst(), node); " ";

        node = LList_GetNextNode(lst(), node)

        IF node = start THEN EXIT WHILE ' avoid looping forever if the list is circular
    WEND
    PRINT
END SUB

