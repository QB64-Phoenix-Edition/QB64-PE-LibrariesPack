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

