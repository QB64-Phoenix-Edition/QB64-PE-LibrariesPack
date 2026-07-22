'
' This example displays the basics of parsing a JSON string and extracting the
' values of various entries in the JSON
'
$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'MattKilgore/QB64pe-Json'

DIM j AS Json
JsonInit j

' This recreates the same JSON structure as seen in the 'json-file.json' example file
' We start with the inner-most tokens and work our way out.

innerKeyOne& = JsonTokenCreateKey&(j, "innerKey", JsonTokenCreateBool&(j, -1))
innerKeyTwo& = JsonTokenCreateKey&(j, "innerKey", JsonTokenCreateBool&(j, 0))

objectInnerOne& = JsonTokenCreateObject&(j)
JsonTokenObjectAdd j, objectInnerOne&, innerKeyOne&
objectInnerOneKey& = JsonTokenCreateKey&(j, "objectInnerKey", objectInnerOne&)

objectInnerTwo& = JsonTokenCreateObject&(j)
JsonTokenObjectAdd j, objectInnerTwo&, innerKeyTwo&
objectInnerTwoKey& = JsonTokenCreateKey&(j, "objectInnerKey2", objectInnerTwo&)

objectInner& = JsonTokenCreateObject&(j)
JsonTokenObjectAdd j, objectInner&, objectInnerOneKey&
JsonTokenObjectAdd j, objectInner&, objectInnerTwoKey&
objectInnerKey& = JsonTokenCreateKey&(j, "objectInnerKey", objectInner&)

objectInnerObject& = JsonTokenCreateObject&(j)
JsonTokenObjectAdd j, objectInnerObject&, objectInnerKey&

' This creates the array holding a couple numbers. We attach it to a key later-on
arrayToken& = JsonTokenCreateArray&(j)

JsonTokenArrayAdd j, arrayToken&, JsonTokenCreateInteger&(j, 20)
JsonTokenArrayAdd j, arrayToken&, JsonTokenCreateInteger&(j, 30)
JsonTokenArrayAdd j, arrayToken&, JsonTokenCreateInteger&(j, 40)

' This is the root object { } surrounding the whole thing. We add the root keys to this object
rootObject& = JsonTokenCreateObject&(j)

JsonTokenObjectAdd j, rootObject&, JsonTokenCreateKey&(j, "stringKey", JsonTokenCreateString&(j, "value1"))
JsonTokenObjectAdd j, rootObject&, JsonTokenCreateKey&(j, "numberKey", JsonTokenCreateInteger&(j, 20))
JsonTokenObjectAdd j, rootObject&, JsonTokenCreateKey&(j, "boolKey", JsonTokenCreateBool&(j, -1))
JsonTokenObjectAdd j, rootObject&, JsonTokenCreateKey&(j, "arrayKey", arrayToken&)
JsonTokenObjectAdd j, rootObject&, JsonTokenCreateKey&(j, "objectKey", objectInnerObject&)

JsonSetRootToken j, rootObject&

PRINT "Rendered Json:"

DIM fmt AS JsonFormat
fmt.Indented = -1

PRINT JsonRenderFormatted$(j, fmt)

' Free our Json object. Unnecessary since the program is about to exit anyway,
' but good to remember regardless
JsonClear j
END

