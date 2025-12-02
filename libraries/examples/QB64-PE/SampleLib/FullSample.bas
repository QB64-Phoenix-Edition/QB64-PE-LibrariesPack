'Full example,
'this is how the "UseLibrary.bas" sample program would look internally
'after the include logic has put all the library parts together along
'with your main program.
'For better overview, to see what's your program and what's included
'library stuff, I've put the library parts in $FORMAT:OFF blocks and
'indented them by two TABs.
'=====================================================

'$FORMAT:OFF
        '=====================================================
        'The initializer part of a library (.bi file),
        'stuff like CONST, (RE)DIM [SHARED], TYPE etc. goes here. If a library
        'reqires another library to work (depencency), then also the $USELIBRARY
        'line calling for that other library should go inside this file.
        '-----
        'IMPORTANT: There can be no SUB/FUNCTION definitions in this part of the
        '           library, those must go into the functional part (.bm file) !!
        '-----------------------------------------------------
        $INCLUDEONCE

        $IF VERSION < 4.3.0 THEN
            $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
        $END IF

        CONST SampleLib_Const = "Library CONST"

        DIM AS _BYTE slg_i, slg_pcnt
        '=====================================================
'$FORMAT:ON

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

'$FORMAT:OFF
        '=====================================================
        'The main program part of a library (.bas file),
        'here the library can define global DATAs, GOSUBs etc., in general
        'everything that must usually go after the main program, but before
        'the first SUB/FUNCTION. Probably the most useful thing is that
        'a library could define its own error handlers here and use them with
        'the _NEWHANDLER/_LASTHANDLER syntax of ON ERROR GOTO in its functions
        'to temporarily perform its own error handling independently from the
        'error handling of the main program.
        '-----
        'IMPORTANT: There can be no SUB/FUNCTION definitions in this part of the
        '           library, those must go into the functional part (.bm file) !!
        '-----------------------------------------------------
        $INCLUDEONCE

        SampleLib_Data:
        DATA "Library DATA"

        SampleLib_Handler:
        PRINT "Error"; ERR; "occured (Library Handler via Library SUB)."
        RESUME NEXT

        SampleLib_Gosub:
        'slg_pcnt = print count (so to say an input parameter to the GOSUB)
        FOR slg_i = 1 TO slg_pcnt
            PRINT "Library GOSUB",
        NEXT slg_i
        PRINT
        RETURN
        '=====================================================
'$FORMAT:ON

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

'$FORMAT:OFF
        '=====================================================
        'The functional part of a library (.bm file),
        'this is where all the SUBs and FUNCTIONs of the library are placed.
        '-----------------------------------------------------
        $INCLUDEONCE

        SUB SampleLib_Sub
            ON ERROR GOTO _NEWHANDLER SampleLib_Handler
            ERROR 7
            ON ERROR GOTO _LASTHANDLER
        END SUB
        '=====================================================
'$FORMAT:ON

