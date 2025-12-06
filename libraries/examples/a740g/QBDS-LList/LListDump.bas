$CONSOLE:ONLY

OPTION _EXPLICIT

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'a740g/QBDS-LList'

REDIM lst(0) AS LList: LList_Initialize lst()

LList_PushBackSingle lst(), 0.1!
LList_PushFrontString lst(), "first"
LList_PushBackString lst(), "second"
LList_PushFrontDouble lst(), 1#
LList_PushFrontString lst(), "zero"
LList_InsertAfterString lst(), LList_GetBackNode(lst()), "third"

DumpList lst()

LList_MakeCircular lst(), _TRUE

DIM i AS LONG: FOR i = -2 TO -12 STEP -1
    LList_PushFrontLong lst(), i
NEXT i

DumpList lst()

END

SUB DumpList (lst() AS LList)
    IF NOT LList_IsInitialized(lst()) THEN
        PRINT "LList_DumpList: not initialized."
        EXIT SUB
    END IF

    DIM head AS _UNSIGNED _OFFSET: head = LList_GetFrontNode(lst())
    DIM tail AS _UNSIGNED _OFFSET: tail = LList_GetBackNode(lst())
    DIM cnt AS _UNSIGNED _OFFSET: cnt = LList_GetCount(lst())
    DIM lowFree AS _UNSIGNED _OFFSET: lowFree = _CV(_UNSIGNED _OFFSET, RIGHT$(lst(0).V, _SIZE_OF_OFFSET))
    DIM isCirc AS _BYTE: isCirc = LList_IsCircular(lst())

    PRINT "=========================== LList Dump ==============================="
    PRINT "Capacity:"; LList_GetCapacity(lst()), " Count:"; cnt, " LowFree:"; lowFree
    PRINT "Head:"; head, " Tail:"; tail, " Circular: "; _IIF(isCirc, "Yes", "No")
    PRINT STRING$(70, "-")
    PRINT "Index", "Previous", "Next", "Type", "Value"
    PRINT STRING$(70, "-")

    DIM node AS _UNSIGNED _OFFSET: node = head
    DIM shown AS _UNSIGNED _OFFSET

    WHILE node <> 0 _ANDALSO shown < cnt
        DIM p AS _UNSIGNED _OFFSET: p = LList_GetPreviousNode(lst(), node)
        DIM n AS _UNSIGNED _OFFSET: n = LList_GetNextNode(lst(), node)
        DIM t AS _UNSIGNED _BYTE: t = LList_GetNodeDataType(lst(), node)

        DIM info AS STRING

        SELECT CASE t
            CASE QBDS_TYPE_STRING
                DIM s AS STRING: s = LList_GetString(lst(), node)
                DIM preview AS STRING
                IF LEN(s) <= 40 THEN
                    preview = _CHR_QUOTE + s + _CHR_QUOTE
                ELSE
                    preview = _CHR_QUOTE + LEFT$(s, 37) + "..." + _CHR_QUOTE
                END IF
                info = preview + " (len=" + _TOSTR$(LEN(s)) + ")"

            CASE QBDS_TYPE_BYTE
                info = "BYTE " + _TOSTR$(LList_GetByte(lst(), node))
            CASE QBDS_TYPE_INTEGER
                info = "INTEGER " + _TOSTR$(LList_GetInteger(lst(), node))
            CASE QBDS_TYPE_LONG
                info = "LONG " + _TOSTR$(LList_GetLong(lst(), node))
            CASE QBDS_TYPE_INTEGER64
                info = "INTEGER64 " + _TOSTR$(LList_GetInteger64(lst(), node))
            CASE QBDS_TYPE_SINGLE
                info = "SINGLE " + _TOSTR$(LList_GetSingle(lst(), node))
            CASE QBDS_TYPE_DOUBLE
                info = "DOUBLE " + _TOSTR$(LList_GetDouble(lst(), node))
            CASE QBDS_TYPE_NONE
                info = "<UNUSED>"
            CASE QBDS_TYPE_RESERVED
                info = "<RESERVED>"
            CASE QBDS_TYPE_DELETED
                info = "<DELETED>"
            CASE ELSE
                IF t >= QBDS_TYPE_UDT THEN
                    info = "UDT (len=" + _TOSTR$(LEN(LList_GetString(lst(), node))) + ")"
                ELSE
                    info = "<UNKNOWN T=" + _TOSTR$(t) + ">"
                END IF
        END SELECT

        PRINT node, p, n, t, info

        node = n ' move to the next mode
        shown = shown + 1

        IF NOT isCirc _ANDALSO node = 0 THEN EXIT WHILE
    WEND

    PRINT STRING$(70, "-")
    PRINT "Shown:"; shown, " Count:"; cnt;
    IF shown <> cnt THEN PRINT , "(mismatch!)" ELSE PRINT
    PRINT STRING$(70, "=")
END SUB

