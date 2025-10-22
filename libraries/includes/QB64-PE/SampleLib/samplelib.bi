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

