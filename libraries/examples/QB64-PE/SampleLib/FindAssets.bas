'Find assets example.
'
'The user may either compile a program to its "Source Folder" or to the
'default location. The latter may even be changed to any location since
'QB64-PE v4.3.0 and up.
'
'The requirements in the Contributors.md document say, that all examples
'must work without runtime error popups from all possible locations.
'
'For most self-contained examples this should not be a problem, but as
'soon as external asset files are involved you need to know the exact
'path from where you are (_CWD$) to the folder of your assets.
'
'This example shows the unified way to locate any asset folders, which
'should be used for all examples in the QB64-PE Libraries Pack.
'=====================================================

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

'-----
'This example wants to load and display the QB64-PE.png image from the
'libraries\descriptors\QB64-PE folder. Next we try to figure out how to
'get there depending on the compile location.
'-----

'--- Find the assets depending on the example's location.
'-----
'The next 3 lines must hold the exact source file and asset path names,
'i.e. the names and the use of upper/lower case must match, so that it
'works on case sensitive Linux filesystems. The use of slash or backslash
'doesn't matter in this context.
DIM exSource$: exSource$ = "FindAssets.bas" 'this example's source file
DIM asDirSrc$: asDirSrc$ = "..\..\..\descriptors\QB64-PE" 'path source dir ==> assets dir
DIM asDirDef$: asDirDef$ = "libraries\descriptors\QB64-PE" 'path QB64-PE dir ==> assets dir
DIM assetDir$, qb64Dir$
'-----
IF _FILEEXISTS(exSource$) THEN
    assetDir$ = asDirSrc$ 'compiled to "Source Folder"
ELSEIF _FILEEXISTS("qb64pe.exe") _ORELSE _FILEEXISTS("qb64pe") THEN
    assetDir$ = asDirDef$ 'compiled to the QB64-PE folder (default)
ELSE
    'The example was compiled to a user selected location, we have
    'to ask the user to give us a hint.
    qb64Dir$ = _SELECTFOLDERDIALOG$("Please locate your QB64-PE main folder...")
    IF LEN(qb64Dir$) > 0 _ANDALSO (_FILEEXISTS(qb64Dir$ + "\qb64pe.exe") _ORELSE _FILEEXISTS(qb64Dir$ + "\qb64pe")) THEN
        'Now we can set our path building on the QB64-PE folder.
        assetDir$ = qb64Dir$ + "\" + asDirDef$
    ELSE
        'The user didn't respond correctly, end with error message.
        PRINT
        PRINT "ERROR: Can't locate required assets, please run again and"
        PRINT "       select your QB64-PE folder when ask for it."
        END
    END IF
END IF
IF LEN(assetDir$) THEN CHDIR assetDir$
'Now our current location (_CWD$) is correctly set to the assets folder.
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

