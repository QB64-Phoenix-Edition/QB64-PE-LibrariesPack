$CONSOLE:ONLY

OPTION _EXPLICIT

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'a740g/QBDS-Stack'

REDIM S(0) AS Stack

PrintCaption "Initializing Stack"

PrintBool "Stack initialized", Stack_IsInitialized(S())

PRINT "Initialize stack"
Stack_Initialize S()
PrintBool "Stack initialized", Stack_IsInitialized(S())

PrintStats S()

PrintCaption "Mixed-type push"

PRINT "Pushing 5 mixed values"

Stack_PushString S(), "alpha"
Stack_PushLong S(), 42&
Stack_PushDouble S(), 3.14159##
Stack_PushInteger64 S(), 10000000000&&
Stack_PushByte S(), 7

PrintStats S()
PrintTop S()

PrintCaption "Pop a few items"

PRINT "Popping three items"

PopAndPrintOne S()
PopAndPrintOne S()
PopAndPrintOne S()

PrintStats S()
PrintTop S()

PrintCaption "Homogeneous usage"

PRINT "Pushing LONGs 10, 20, 30, 40, 50 and then draining"

DIM i AS LONG
FOR i = 10 TO 50 STEP 10
    Stack_PushLong S(), i
NEXT
DO WHILE Stack_GetCount(S()) > 0
    PRINT "  Drain -> "; Stack_PopLong(S())
LOOP
PrintStats S()

PrintCaption "Capacity growth"

PRINT "Bulk push 3000 SINGLEs"

FOR i = 1 TO 3000
    Stack_PushSingle S(), i * 0.5!
NEXT
PrintStats S()

PRINT "Clearing contents"

Stack_Clear S()
PrintStats S()

PrintCaption "Free"

PRINT "Freeing stack"

Stack_Free S()
PrintBool "Stack initialized", Stack_IsInitialized(S())

END

SUB PrintCaption (caption AS STRING)
    PRINT _CHR_LF; "--- "; caption; " ---"; _CHR_LF
END SUB

SUB PrintBool (message AS STRING, value AS _BYTE)
    PRINT message; ": "; _IIF(value, "yes", "no")
END SUB

SUB PrintStats (s() AS Stack)
    PRINT "  Count    :"; Stack_GetCount(s())
    PRINT "  Capacity :"; Stack_GetCapacity(s())
END SUB

SUB PrintTop (s() AS Stack)
    IF Stack_GetCount(s()) = 0 THEN
        PRINT "  (top) <empty>"
        EXIT SUB
    END IF

    DIM dt AS _UNSIGNED _BYTE: dt = Stack_PeekElementDataType(s())

    SELECT CASE dt
        CASE QBDS_TYPE_STRING
            PRINT "  (top) STRING  = "; _CHR_QUOTE; Stack_PeekString(s()); _CHR_QUOTE
        CASE QBDS_TYPE_BYTE
            PRINT "  (top) BYTE    = "; Stack_PeekByte(s())
        CASE QBDS_TYPE_INTEGER
            PRINT "  (top) INTEGER = "; Stack_PeekInteger(s())
        CASE QBDS_TYPE_LONG
            PRINT "  (top) LONG    = "; Stack_PeekLong(s())
        CASE QBDS_TYPE_INTEGER64
            PRINT "  (top) INT64   = "; Stack_PeekInteger64(s())
        CASE QBDS_TYPE_SINGLE
            PRINT USING "  (top) SINGLE  = ###.###"; Stack_PeekSingle(s())
        CASE QBDS_TYPE_DOUBLE
            PRINT USING "  (top) DOUBLE  = ###.######"; Stack_PeekDouble(s())
        CASE ELSE
            DIM dat AS STRING: dat = Stack_PeekString(s())
            PRINT "  (top) UDT <"; _TOSTR$(dt); "(len=" + _TOSTR$(LEN(dat)) + ")"; ">"
    END SELECT
END SUB

SUB PopAndPrintOne (s() AS Stack)
    IF Stack_GetCount(s()) = 0 THEN
        PRINT "  Pop: <empty>"
        EXIT SUB
    END IF

    DIM dt AS _UNSIGNED _BYTE: dt = Stack_PeekElementDataType(s())

    SELECT CASE dt
        CASE QBDS_TYPE_STRING
            PRINT "  Pop STRING  -> "; _CHR_QUOTE; Stack_PopString(s()); _CHR_QUOTE
        CASE QBDS_TYPE_BYTE
            PRINT "  Pop BYTE    -> "; Stack_PopByte(s())
        CASE QBDS_TYPE_INTEGER
            PRINT "  Pop INTEGER -> "; Stack_PopInteger(s())
        CASE QBDS_TYPE_LONG
            PRINT "  Pop LONG    -> "; Stack_PopLong(s())
        CASE QBDS_TYPE_INTEGER64
            PRINT "  Pop INT64   -> "; Stack_PopInteger64(s())
        CASE QBDS_TYPE_SINGLE
            PRINT USING "  Pop SINGLE  -> ###.###"; Stack_PopSingle(s())
        CASE QBDS_TYPE_DOUBLE
            PRINT USING "  Pop DOUBLE  -> ###.######"; Stack_PopDouble(s())
        CASE ELSE
            DIM dat AS STRING: dat = Stack_PopString(s())
            PRINT "  Pop UDT <"; _TOSTR$(dt); "(len=" + _TOSTR$(LEN(dat)) + ")"; ">"
    END SELECT
END SUB

