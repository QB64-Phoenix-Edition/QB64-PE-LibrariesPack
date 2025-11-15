$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'SpriggsySpriggs/PipeCom'

WIDTH , 35

DIM AS STRING stdout, stderr
DIM AS LONG exit_code

'The following call returns the exit_code as function result and the
'stdout and stderr streams are stored (passed back) in the provided strings.
'Note this is an intended side effect on the provided function arguments,
'if you need to preserve the previous contents of stdout and stderr, then
'you must assign it to another string variable BEFORE the call.
exit_code = pipecom("dir", stdout, stderr)
COLOR 14: PRINT "PipeCom test with successful result:": PRINT
COLOR 9: PRINT "Exit Code:";: COLOR 15: PRINT exit_code
IF LEN(stdout) > 0 THEN
    COLOR 12: PRINT STRING$(30, "-"); " stdout "; STRING$(30, "-"): COLOR 7
    PRINT stdout
    COLOR 12: PRINT STRING$(68, "-"): COLOR 7
END IF
IF LEN(stderr) > 0 THEN
    COLOR 12: PRINT STRING$(30, "-"); " stderr "; STRING$(30, "-"): COLOR 7
    PRINT stderr
    COLOR 12: PRINT STRING$(68, "-"): COLOR 7
END IF
COLOR 15: PRINT: PRINT "press any key for next test...": SLEEP: CLS

exit_code = pipecom("dir xxx", stdout, stderr)
COLOR 14: PRINT "PipeCom test with failure result:": PRINT
COLOR 9: PRINT "Exit Code:";: COLOR 15: PRINT exit_code
IF LEN(stdout) > 0 THEN
    COLOR 12: PRINT STRING$(30, "-"); " stdout "; STRING$(30, "-"): COLOR 7
    PRINT stdout
    COLOR 12: PRINT STRING$(68, "-"): COLOR 7
END IF
IF LEN(stderr) > 0 THEN
    COLOR 12: PRINT STRING$(30, "-"); " stderr "; STRING$(30, "-"): COLOR 7
    PRINT stderr
    COLOR 12: PRINT STRING$(68, "-"): COLOR 7
END IF
COLOR 15: PRINT: PRINT "press any key for next test...": SLEEP: CLS

'The following version of pipecom_lite returns stderr if it is not empty,
'i.e. if an error occurred, or stdout if all went well. This is probably
'the most useful version of pipecom, as it don't has argument side effects
'and directly returns the expected result, i.e. the error message in case
'of failure and the expected output on success.
anyStringVar$ = pipecom_lite("dir")
COLOR 14: PRINT "PipeCom 'lite' test with successful result:": PRINT
IF LEN(anyStringVar$) > 0 THEN
    COLOR 12: PRINT STRING$(68, "-"): COLOR 7
    PRINT anyStringVar$
    COLOR 12: PRINT STRING$(68, "-"): COLOR 7
END IF
COLOR 15: PRINT: PRINT "press any key for next test...": SLEEP: CLS

anyStringVar$ = pipecom_lite("dir xxx")
COLOR 14: PRINT "PipeCom 'lite' test with failure result:": PRINT
IF LEN(anyStringVar$) > 0 THEN
    COLOR 12: PRINT STRING$(68, "-"): COLOR 7
    PRINT anyStringVar$
    COLOR 12: PRINT STRING$(68, "-"): COLOR 7
END IF

'The last version is for "fire & forget" calls, if you just need to call
'a command, but you're not interested in the result.
pipecom_lite "dir"

