'Check all libraries,
'this program does nothing, it's just to check all libraries against
'each other for name conflicts and/or undeclared variables. Just load it
'into the IDE, there should be no errors, just the usual "..." and after
'the syntax check finishes the "Ok" message in the status area.
'=======================================================================

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

OPTION _EXPLICIT
$CONSOLE:ONLY

$USELIBRARY:'a740g/Catch'
$USELIBRARY:'a740g/QBDS'
$USELIBRARY:'a740g/QBDS-Array'
$USELIBRARY:'a740g/QBDS-HMap'
$USELIBRARY:'a740g/QBDS-HMap64'
$USELIBRARY:'a740g/QBDS-HSet'
$USELIBRARY:'a740g/QBDS-LList'
$USELIBRARY:'a740g/QBDS-Queue'
$USELIBRARY:'a740g/QBDS-Stack'
$USELIBRARY:'FellippeHeitor/IniManager'
$USELIBRARY:'QB64-PE/SampleLib'
$USELIBRARY:'RhoSigma/Charsets'
$USELIBRARY:'RhoSigma/Imageprocess'
$USELIBRARY:'RhoSigma/Polygons'
$USELIBRARY:'RhoSigma/QB-StdArg'
$USELIBRARY:'RhoSigma/QB-StdIo'
$USELIBRARY:'RhoSigma/QB-Time'
$USELIBRARY:'RhoSigma/Sha2-Hash'
$USELIBRARY:'RhoSigma/Simplebuffer'
$USELIBRARY:'SpriggsySpriggs/PipeCom'
$USELIBRARY:'TerryRitchie/MenuLib'

