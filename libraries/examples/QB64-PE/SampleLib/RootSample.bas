'Locate root example,
'as per the requirements mentioned in the Contributors.md document, all
'examples must work from all possible compile locations.
'The user may either compile a program to its "Source Folder" or to the
'default location. The latter may even be changed to any location since
'QB64-PE v4.3.0 and up.
'This example shows a possible way to make sure assets are located and
'can be accessed regardless of the compile location.
'=====================================================

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

'The example wants to load and display the QB64-PE.png image from the
'libraries\descriptors\QB64-PE folder.

'--- Find the assets depending on the execuatable's location.
'-----
IF _FILEEXISTS("RootSample.bas") THEN
    'The program was compiled to its "Source Folder", in this case that
    'is libraries\examples\QB64-PE\SampleLib, hence we need to go back
    'three folders first and then forward to our wanted assets.
    root$ = "..\..\..\descriptors\QB64-PE\"
ELSEIF _FILEEXISTS("qb64pe.exe") _ORELSE _FILEEXISTS("qb64pe") THEN
    'The program was compiled to the QB64-PE folder (default if no other
    'was specified), hence we can directly go to our wanted assets.
    root$ = "libraries\descriptors\QB64-PE\"
ELSE
    'The program was compiled to a user set default location, no way to
    'automatically determine the path to our assets, we have to ask the
    'user to give us a hint.
    qbfo$ = _SELECTFOLDERDIALOG$("Please locate your QB64-PE main folder...")
    IF LEN(qbfo$) > 0 _ANDALSO (_FILEEXISTS(qbfo$ + "\qb64pe.exe") _ORELSE _FILEEXISTS(qbfo$ + "\qb64pe")) THEN
        'Now we can set our root building on the QB64-PE folder as above.
        root$ = qbfo$ + "\libraries\descriptors\QB64-PE\"
    ELSE
        'We give up.
        PRINT "Can't locate required assets, please run again and select"
        PRINT "your QB64-PE folder when ask for it."
        END
    END IF
END IF

'--- Do stuff with our located assets.
'-----
SCREEN _NEWIMAGE(640, 400, 32)
i& = _LOADIMAGE(root$ + "QB64-PE.png", 32)
IF i& < -1 THEN
    _PUTIMAGE (270, 150), i&
    _FREEIMAGE i&
ELSE
    PRINT "Can't load image..."
END IF
END

