'Get source folder example.
'
'The user may either compile a program to its "Source Folder" or to the
'default location. The latter may even be changed to any location since
'QB64-PE v4.3.0 and up.
'
'The requirements in the Contributors.md document say, that all examples
'must work without unexpected runtime error popups from all locations.
'
'For most self-contained examples this should not be a problem, but as
'soon as external files are involved you need to know the exact path to
'avoid errors when opening files or loading sounds/images etc.
'
'As the Libraries Pack has a well defined order, we can dertermine the
'QB64-PE and the source folder of each example very easy just by knowing
'its name and the library it belongs to.
'
'This example shows the unified way to locate these folders, which should
'be used for all examples in the QB64-PE Libraries Pack.
'=====================================================

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

'--- Find QB64-PE and Example source folders depending on EXE location.
'-----
'Fill example$ and library$ with the exact names, i.e. the use of upper/lower
'case must match, so that it works on case sensitive Linux filesystems.
DIM example$: example$ = "GetSrcFold.bas" 'this example's source file name
DIM library$: library$ = "QB64-PE/SampleLib" 'the library's name (as in $USELIBRARY)
DIM qbDir$, srcDir$ 'filled automatically (with trailing slash)
'-----
IF _FILEEXISTS(example$) THEN
    srcDir$ = _CWD$ 'compiled to "Source Folder"
    qbDir$ = LEFT$(srcDir$, LEN(srcDir$) - LEN(library$) - 20)
ELSEIF _FILEEXISTS("qb64pe.exe") _ORELSE _FILEEXISTS("qb64pe") THEN
    qbDir$ = _CWD$ 'compiled to the QB64-PE folder (default)
    srcDir$ = qbDir$ + "libraries/examples/" + library$ + "/"
ELSE
    'The example was compiled to a user selected location, we have
    'to ask the user to give us a hint.
    qbDir$ = _SELECTFOLDERDIALOG$("Please locate your QB64-PE main folder...")
    IF LEN(qbDir$) > 0 _ANDALSO (_FILEEXISTS(qbDir$ + "/qb64pe.exe") _ORELSE _FILEEXISTS(qbDir$ + "/qb64pe")) THEN
        'Now we can set our paths building on the selected folder.
        qbDir$ = qbDir$ + "/"
        srcDir$ = qbDir$ + "libraries/examples/" + library$ + "/"
    ELSE
        'The user didn't respond correctly, end with error message.
        PRINT
        PRINT "ERROR: Can't locate required assets, please run again and"
        PRINT "       select your QB64-PE folder when ask for it."
        END
    END IF
END IF
CHDIR srcDir$ 'Change into the example's source folder, in alternative
'             'use qbDir$ or srcDir$ directly where applicable.
'-----------------------------------------------------

'--- Do stuff with our located assets.
'-----
SCREEN _NEWIMAGE(640, 400, 32)
i& = _LOADIMAGE("QB64-PE.png", 32)
IF i& < -1 THEN
    _PUTIMAGE (270, 150), i&
    _FREEIMAGE i&
ELSE
    PRINT "Can't load image..."
END IF
END

