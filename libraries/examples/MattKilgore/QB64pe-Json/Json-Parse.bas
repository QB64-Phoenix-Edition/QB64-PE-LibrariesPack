'
' This example displays the basics of parsing a JSON string and extracting the
' values of various entries in the JSON
'
OPTION _EXPLICIT

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'MattKilgore/QB64pe-Json'

'--- Find the assets depending on the example's location.
'-----
'The next 3 lines must hold the exact source file and asset path names,
'i.e. the names and the use of upper/lower case must match, so that it
'works on case sensitive Linux filesystems. The use of slash or backslash
'doesn't matter in this context.
DIM exSource$: exSource$ = "Json-Parse.bas" 'this example's source file
DIM asDirSrc$: asDirSrc$ = "" 'path source dir ==> assets dir
DIM asDirDef$: asDirDef$ = "libraries\examples\MattKilgore\QB64pe-Json" 'path QB64-PE dir ==> assets dir
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

DIM jsonString AS STRING

' Attempt to find json-file.json and read the JSON string inside it
IF _FILEEXISTS("json-file.json") THEN jsonString = _READFILE$("json-file.json")
IF LEN(jsonString) = 0 THEN PRINT "Error, file json-file.json empty or not found!": END

' Declare and initialize our Json object
DIM j AS Json
JsonInit j

DIM errorCode AS LONG
errorCode = JsonParse&(j, jsonString)

' Should print zero for success
PRINT "JsonParse error code: "; errorCode
PRINT

' Directly query the string value, and use Value$() version to get the string value directly
PRINT "stringKey: "; JsonQueryValue$(j, "stringKey")

' Same thing, but using JsonQuery&() to get the token and manually pass it to JsonTokenGetValueStr$()
PRINT "stringKey: "; JsonTokenGetValueStr$(j, JsonQuery&(j, "stringKey"))

' Same thing, but the target is a number token instead
PRINT "numberKey: "; JsonTokenGetValueInteger&&(j, JsonQuery&(j, "numberKey"))

' Same thing, but the target is a bool token instead
PRINT "boolKey: "; JsonTokenGetValueBool&(j, JsonQuery&(j, "boolKey"))

' Perform a query several levels down
PRINT "objectKey:objectInnerKey:objectInnerKey:innerKey: "; JsonTokenGetValueBool&(j, JsonQuery&(j, "objectKey.objectInnerKey.objectInnerKey.innerKey"))

' We can query for an object or array and then do additional queries starting from that point
DIM objectToken AS LONG
objectToken = JsonQuery&(j, "objectKey.objectInnerKey")
PRINT "objectKey:objectInnerKey:objectInnerKey:innerKey: "; JsonTokenGetValueBool&(j, JsonQueryFrom&(j, objectToken, "objectInnerKey.innerKey"))
PRINT "objectKey:objectInnerKey:objectInnerKey2:innerKey: "; JsonTokenGetValueBool&(j, JsonQueryFrom&(j, objectToken, "objectInnerKey2.innerKey"))



DIM i AS LONG, arrToken AS LONG
PRINT "arrayKey:"

' Iterate over an array and print each individual array index
'
' We query to find the Token for this array, and then use that token for the
' rest of the logic.
arrToken = JsonQuery&(j, "arrayKey")
FOR i = 0 TO JsonTokenTotalChildren&(j, arrToken) - 1
    DIM childToken AS LONG
    childToken = JsonTokenGetChild&(j, arrToken, i)
    PRINT "    Child"; i; " ="; JsonTokenGetValueInteger&&(j, childToken)
NEXT


' Free our Json object. Unnecessary since the program is about to exit anyway,
' but good to remember regardless
JsonClear j
END

