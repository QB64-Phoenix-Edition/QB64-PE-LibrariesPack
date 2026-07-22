'
' Shows how you can write reusable 'serialize' and 'deserialize' functions for
' transforming Type's to and from Json objects
'
' This paticular example reads the Json from pokemon-party.json and deserializes
' it into 'Pokemon' type objects. It then shows that the Pokemon array got
' filled in correctly, and how you can then use the ItemSerialize&() function
' to build a JSON array of just the heldItems from each Pokemon.
'
' We then use PokemonSerialize to render the individual Pokemon objects back
' into Json, effectively taking a round trip from pokemon-party.json, to
' Pokemon objects, and back to rendered JSON.
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
DIM exSource$: exSource$ = "Serialize-Deserialize.bas" 'this example's source file
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

TYPE PokemonStats
    hp AS LONG
    attack AS LONG
    defense AS LONG
    spAttack AS LONG
    spDefense AS LONG
    speed AS LONG
END TYPE

TYPE Move
    nam AS STRING * 12
    pow AS LONG
END TYPE

TYPE Item
    nam AS STRING * 12
END TYPE

TYPE Pokemon
    nam AS STRING * 10
    baseStats AS PokemonStats

    curStats AS PokemonStats

    heldItem AS Item

    move1 AS Move
    move2 AS Move
    move3 AS Move
    move4 AS Move
END TYPE

DIM jsonString AS STRING

' Attempt to find pokemon-party.json and read the JSON string inside it
IF _FILEEXISTS("pokemon-party.json") THEN jsonString = _READFILE$("pokemon-party.json")
IF LEN(jsonString) = 0 THEN PRINT "Error, file pokemon-party.json empty or not found!": END

' Party of Pokemon
DIM p(3) AS Pokemon, j AS Json
JsonInit j

DIM result AS LONG
result = JsonParse&(j, jsonString)

PRINT "Parse result:"; result
PRINT "error: "; JsonError

PokemonPartyDeserialize j, j.RootToken, p()

' At this point, p() contains all of the informationed listed in the JSON

DIM i AS LONG
PRINT "Pokemon in file: ";
FOR i = 1 TO 3
    PRINT RTRIM$(p(i).nam); " ";
NEXT
PRINT

' Serialize just the items together into a JSON array and print it
DIM itemj AS Json, itemArray AS LONG
JsonInit itemj

itemArray = JsonTokenCreateArray&(itemj)

FOR i = 1 TO 3
    JsonTokenArrayAdd itemj, itemArray, ItemSerialize&(itemj, p(i).heldItem)
NEXT

DIM fmt AS JsonFormat
fmt.Indented = -1

PRINT "Items:"
PRINT JsonRenderTokenFormatted$(itemj, itemArray, fmt)
SLEEP

JsonClear itemj

' Serialize and print each pokemon individually
FOR i = 1 TO 3
    CLS
    PRINT "Serialized Pokemon "; RTRIM$(p(i).nam); ":"
    PRINT

    JsonInit itemj

    itemj.RootToken = PokemonSerialize&(itemj, p(i))
    PRINT JsonRender$(itemj)

    JsonClear itemj
    SLEEP
NEXT

END

' These serialization functions take an existing object and turn it into a JSON
' structure. The root token of that structure is then returned, allowing you to
' further embed that structure into other structures.

FUNCTION PokemonStatsSerialize& (j AS Json, stats AS PokemonStats)
    DIM rootToken AS LONG
    rootToken = JsonTokenCreateObject&(j)

    JsonTokenObjectAdd j, rootToken, JsonTokenCreateKey&(j, "hp", JsonTokenCreateInteger&(j, stats.hp))
    JsonTokenObjectAdd j, rootToken, JsonTokenCreateKey&(j, "attack", JsonTokenCreateInteger&(j, stats.attack))
    JsonTokenObjectAdd j, rootToken, JsonTokenCreateKey&(j, "defense", JsonTokenCreateInteger&(j, stats.defense))
    JsonTokenObjectAdd j, rootToken, JsonTokenCreateKey&(j, "spAttack", JsonTokenCreateInteger&(j, stats.spAttack))
    JsonTokenObjectAdd j, rootToken, JsonTokenCreateKey&(j, "spDefense", JsonTokenCreateInteger&(j, stats.spDefense))
    JsonTokenObjectAdd j, rootToken, JsonTokenCreateKey&(j, "speed", JsonTokenCreateInteger&(j, stats.speed))

    PokemonStatsSerialize& = rootToken
END FUNCTION

FUNCTION MoveSerialize& (j AS Json, move AS Move)
    DIM rootToken AS LONG
    rootToken = JsonTokenCreateObject&(j)

    JsonTokenObjectAdd j, rootToken, JsonTokenCreateKey&(j, "name", JsonTokenCreateString&(j, RTRIM$(move.nam)))
    JsonTokenObjectAdd j, rootToken, JsonTokenCreateKey&(j, "power", JsonTokenCreateInteger&(j, move.pow))

    MoveSerialize& = rootToken
END FUNCTION

FUNCTION ItemSerialize& (j AS Json, item AS Item)
    DIM rootToken AS LONG
    rootToken = JsonTokenCreateObject&(j)

    JsonTokenObjectAdd j, rootToken, JsonTokenCreateKey&(j, "name", JsonTokenCreateString&(j, RTRIM$(item.nam)))

    ItemSerialize& = rootToken
END FUNCTION

FUNCTION PokemonSerialize& (j AS Json, p AS Pokemon)
    DIM rootToken AS LONG, moveArray AS LONG
    rootToken = JsonTokenCreateObject&(j)

    JsonTokenObjectAdd j, rootToken, JsonTokenCreateKey&(j, "name", JsonTokenCreateString&(j, RTRIM$(p.nam)))

    ' To serialize members of other Type's in the Pokemon Type we simply call that Type's own serialize function
    JsonTokenObjectAdd j, rootToken, JsonTokenCreateKey&(j, "baseStats", PokemonStatsSerialize&(j, p.baseStats))
    JsonTokenObjectAdd j, rootToken, JsonTokenCreateKey&(j, "curStats", PokemonStatsSerialize&(j, p.curStats))
    JsonTokenObjectAdd j, rootToken, JsonTokenCreateKey&(j, "heldItem", ItemSerialize&(j, p.heldItem))

    ' Rather then add entries called "move1", "move2", etc. we create a JSON
    ' array and put the moves into that array in order
    moveArray = JsonTokenCreateArray&(j)
    JsonTokenArrayAdd j, moveArray, MoveSerialize&(j, p.move1)
    JsonTokenArrayAdd j, moveArray, MoveSerialize&(j, p.move2)
    JsonTokenArrayAdd j, moveArray, MoveSerialize&(j, p.move3)
    JsonTokenArrayAdd j, moveArray, MoveSerialize&(j, p.move4)

    JsonTokenObjectAdd j, rootToken, JsonTokenCreateKey&(j, "moves", moveArray)

    PokemonSerialize& = rootToken
END FUNCTION

'
' These Subs reverse the serialization functions - given a Json token pointing
' to the root of a serialized object, they fill in the provided object with the
' information contained within that JSON structure.
'
' In practice this mostly means a lot of usage of JsonQueryFrom&() And the
' JsonTokenGetValue*() functions.
'
SUB PokemonStatsDeserialize (j AS Json, token AS LONG, stats AS PokemonStats)
    stats.hp = JsonTokenGetValueInteger&&(j, JsonQueryFrom&(j, token, "hp"))
    stats.attack = JsonTokenGetValueInteger&&(j, JsonQueryFrom&(j, token, "attack"))
    stats.defense = JsonTokenGetValueInteger&&(j, JsonQueryFrom&(j, token, "defense"))
    stats.spAttack = JsonTokenGetValueInteger&&(j, JsonQueryFrom&(j, token, "spAttack"))
    stats.spDefense = JsonTokenGetValueInteger&&(j, JsonQueryFrom&(j, token, "spDefense"))
    stats.speed = JsonTokenGetValueInteger&&(j, JsonQueryFrom&(j, token, "speed"))
END SUB

SUB MoveDeserialize (j AS Json, token AS LONG, move AS Move)
    move.nam = jsonQueryFromValue$(j, token, "name")
    move.pow = JsonTokenGetValueInteger&&(j, JsonQueryFrom&(j, token, "pow"))
END SUB

SUB ItemDeserialize (j AS Json, token AS LONG, item AS Item)
    item.nam = jsonQueryFromValue$(j, token, "name")
END SUB

SUB PokemonDeserialize (j AS Json, token AS LONG, p AS Pokemon)
    p.nam = jsonQueryFromValue$(j, token, "name")

    ' To deserialize members of other Type's we simply call that Type's own
    ' deserialize function.
    PokemonStatsDeserialize j, JsonQueryFrom&(j, token, "baseStats"), p.baseStats
    PokemonStatsDeserialize j, JsonQueryFrom&(j, token, "curStats"), p.curStats

    ItemDeserialize j, JsonQueryFrom&(j, token, "heldItem"), p.heldItem

    DIM moveArrayToken AS LONG
    moveArrayToken = JsonQueryFrom&(j, token, "moves")

    ' Since the moves are in a defined order we can just index the array
    ' directly
    MoveDeserialize j, JsonTokenGetChild&(j, moveArrayToken, 0), p.move1
    MoveDeserialize j, JsonTokenGetChild&(j, moveArrayToken, 1), p.move2
    MoveDeserialize j, JsonTokenGetChild&(j, moveArrayToken, 2), p.move3
    MoveDeserialize j, JsonTokenGetChild&(j, moveArrayToken, 3), p.move4
END SUB

SUB PokemonPartyDeserialize (j AS Json, token AS LONG, p() AS Pokemon)
    DIM i AS LONG, child AS LONG, count AS LONG
    count = JsonTokenTotalChildren&(j, token)

    FOR i = 0 TO count - 1
        child = JsonTokenGetChild&(j, token, i)
        PokemonDeserialize j, child, p(i + 1)
    NEXT
END SUB

