'Use library example,
'this shows how easy a library from our new QB64-PE library package can
'be included since QB64-PE v4.3.0, just a single line and be done.
'=====================================================

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'QB64-PE/SampleLib'

'=====================================================
'This is the user's main program, whatever it is.
'-----------------------------------------------------
OPTION _EXPLICIT

CONST Main_Const = "Main CONST"

DIM SHARED PrintCnt AS _BYTE
DIM i AS INTEGER, t AS STRING

PrintCnt = 3
FOR i = 1 TO PrintCnt
    PRINT Main_Const,
NEXT i
PRINT
FOR i = 1 TO PrintCnt
    PRINT SampleLib_Const,
NEXT i
PRINT: PRINT

Main_Sub
ON ERROR GOTO Main_Handler
ERROR 7
SampleLib_Sub
ERROR 7
PRINT

GOSUB Main_Gosub
slg_pcnt = PrintCnt 'input to library GOSUB routine
GOSUB SampleLib_Gosub
PRINT

RESTORE Main_Data
READ t
FOR i = 1 TO PrintCnt
    PRINT t,
NEXT i
PRINT
RESTORE SampleLib_Data
READ t
FOR i = 1 TO PrintCnt
    PRINT t,
NEXT i
PRINT
END

Main_Data:
DATA "Main DATA"

Main_Handler:
PRINT "Error"; ERR; "occured (Main Handler)."
RESUME NEXT

Main_Gosub:
FOR i = 1 TO PrintCnt
    PRINT "Main GOSUB",
NEXT i
PRINT
RETURN
'=====================================================

'=====================================================
'This is the user's main program's SUB/FUNCTION part,
'these are the SUBs and FUNCTIONs the user has written inside his main
'source file after all main code, GOSUB routines, DATAs etc..
'-----------------------------------------------------
SUB Main_Sub
    DIM i AS INTEGER
    FOR i = 1 TO PrintCnt
        PRINT "Main SUB",
    NEXT i
    PRINT
END SUB
'=====================================================

