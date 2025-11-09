'Check all libraries,
'this program does nothing, it's just to check all libraries against
'each other for name conflicts. Just load it into the IDE, there should
'be no errors, just the usual "..." and finally the "Ok" in the status.
'=====================================================

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

OPTION _EXPLICIT

$USELIBRARY:'FellippeHeitor/IniManager'
$USELIBRARY:'QB64-PE/SampleLib'
$USELIBRARY:'RhoSigma/Charsets'
$USELIBRARY:'RhoSigma/Imageprocess'
$USELIBRARY:'RhoSigma/Polygons'
$USELIBRARY:'RhoSigma/Sha2-Hash'
$USELIBRARY:'RhoSigma/Simplebuffer'
$USELIBRARY:'TerryRitchie/MenuLib'

