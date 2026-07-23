
' QB64-PE Json library, version 0.1.0
'
' This library is designed to allow easy usage of JSON structures with QB64-PE
' code. It can be used to both parse existing JSON and create new JSON structures.

$INCLUDEONCE

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

CONST JSON_ERR_Success = 0
CONST JSON_ERR_BadQuery = -1
CONST JSON_ERR_OutOfRange = -2
CONST JSON_ERR_KeyNotFound = -3
CONST JSON_ERR_NotInitialized = -4
CONST JSON_ERR_Invalid = -5
CONST JSON_ERR_TokenWrongType = -6
CONST JSON_ERR_TokenInvalid = -7

CONST JSONTOK_TYPE_FREE = 0
CONST JSONTOK_TYPE_OBJECT = 1
CONST JSONTOK_TYPE_ARRAY = 2
CONST JSONTOK_TYPE_VALUE = 3
CONST JSONTOK_TYPE_KEY = 4

CONST JSONTOK_PRIM_STRING = 1
CONST JSONTOK_PRIM_NUMBER = 2
CONST JSONTOK_PRIM_BOOL = 3
CONST JSONTOK_PRIM_NULL = 4

' If a Json procedure has an error, the error code will be stored in
' JsonHadError and a text version of the error will be in JsonError. The error
' code will be any of the defined JSON_ERR_* constants.
'
' On success JsonHadError will be set to zero, which is JSON_ERR_Success
DIM SHARED JsonError AS STRING, JsonHadError AS LONG

' !!! Do not touch anything in the Json object directly !!!
' Manipulate it using the provided Subs and Functions
TYPE Json
    RootToken AS LONG
    TotalBlocks AS LONG

    NextFree AS LONG
    TokenBlocks AS _MEM
    IsInitialized AS LONG
END TYPE

' Required to be called on an Json object prior to its use by any function.
' This is checked and will produce a JSON_ERR_NotInitialized if you forget to
' do this.
DECLARE SUB      JsonInit(json AS Json)

' You should call JsonClear on any Json object when you are done using it.
' Failure to do this will result in memory leaks.
DECLARE SUB      JsonClear(json AS Json)

' Parses a JSON string into a json object. The json object should already be initialized.
'
' Return value indicates whether the parse was a success (JSON_ERR_Success).
' JsonHadError can also be checked. On success the RootToken will be set to the
' result of the parse.
DECLARE FUNCTION JsonParse&(j AS Json, json AS STRING)

' These functions create new Json tokens which can be used to create a new Json
' structure or modify an existing one. They return a Long which is an index
' referring to the token, the index can then be passed to the other functions
' to make use of this token.
DECLARE FUNCTION JsonTokenCreateBool&(j AS Json, b AS _BYTE)
DECLARE FUNCTION JsonTokenCreateInteger&(j AS Json, i AS _INTEGER64)
DECLARE FUNCTION JsonTokenCreateDouble&(j AS Json, s AS DOUBLE)
DECLARE FUNCTION JsonTokenCreateNumber&(j AS Json, intPart AS _INTEGER64, fracPart AS DOUBLE, expPart AS _INTEGER64)
DECLARE FUNCTION JsonTokenCreateNull&(j AS Json)

DECLARE FUNCTION JsonTokenCreateArray&(j AS Json)
DECLARE FUNCTION JsonTokenCreateObject&(j AS Json)

' String contents HAVE to be valid UTF-8
DECLARE FUNCTION JsonTokenCreateString&(j AS Json, s AS STRING)

' The key name HAS to be valid UTF-8. inner is the token holding the value
' associated with this key.
DECLARE FUNCTION JsonTokenCreateKey&(j AS Json, k AS STRING, inner AS LONG)

' Add tokens to a given array
DECLARE SUB      JsonTokenArrayAdd(j AS Json, arrayIdx AS LONG, childidx AS LONG)
DECLARE SUB      JsonTokenArrayAddAll(j AS Json, arrayIdx AS LONG, childIdxs() AS LONG)

' Add tokens to a given object
DECLARE SUB      JsonTokenObjectAdd(j AS Json, objectIdx AS LONG, childIdx AS LONG)
DECLARE SUB      JsonTokenObjectAddAll(j AS Json, objectIdx AS LONG, childIdxs() AS LONG)

' Set the token representing the root of the json structure. This is not
' required, but allows you to use convience functions like JsonRender() and
' JsonQuery() rather than JsonRenderIndex() and JsonQueryFrom()
DECLARE SUB      JsonSetRootToken(j AS Json, idx AS LONG)
DECLARE FUNCTION JsonGetRootToken&(j AS Json)

' Takes a Json object and "renders" the JSON string it represents.
'
' JsonRender$ creates the JSON starting at the root token.
' JsonRenderToken$ creates the JSON starting at the provided token.
DECLARE FUNCTION JsonRender$(j AS Json)
DECLARE FUNCTION JsonRenderToken$(j AS Json, idx AS LONG)

TYPE JsonFormat
    Indented AS _BYTE
END TYPE

' Renders the Json with the given formatting options
DECLARE FUNCTION JsonRenderFormatted$(j AS Json, format AS JsonFormat)
DECLARE FUNCTION JsonRenderTokenFormatted$(j AS Json, idx AS LONG, format AS JsonFormat)

' Returns the token's value in string form:
'
'    Key:    Key name
'    Value:  String version of the value itself. Bools are "true" or "false". Strings are UTF-8. Null is Error
'    Array:  Error
'    Object: Error
'
' To convert a token into a JSON string, use JsonRender$()
DECLARE FUNCTION JsonTokenGetValueStr$(j AS Json, idx AS LONG)

' These functions return the coresponding primitive's value in the normal QB64
' type (rather than as a string)
DECLARE FUNCTION JsonTokenGetValueBool&(j AS Json, idx, AS LONG)
DECLARE FUNCTION JsonTokenGetValueInteger&&(j AS Json, idx AS LONG)
DECLARE FUNCTION JsonTokenGetValueDouble#(j AS Json, idx AS LONG)


DECLARE FUNCTION JsonTokenTotalChildren&(j AS Json, idx AS LONG)

' Returns the token for a paticular child of this Json token.
' Children are numbered from _zero_
DECLARE FUNCTION JsonTokenGetChild&(j AS Json, idx AS LONG, childIdx AS LONG)

' Returns a JSONTOK_TYPE_* value
DECLARE FUNCTION JsonTokenGetType&(j AS Json, idx AS LONG)

' Only works if the token is a JSONTOK_TYPE_VALUE. Returns a JSONTOK_PRIM_* value
DECLARE FUNCTION JsonTokenGetPrimType&(j AS Json, idx AS LONG)

' Takes a JSON query string and finds the JSON token that it refers too.
'
' Queries take the form of key identifiers and array indexes, separated by
' periods. Key identifiers can be in single or double quotes. Array indexes are
' parenthesis. The result of a query is the token which is the value associated
' with the target key. This can be a primitive value, but can also be an object
' if you target keys earlier in the chain. Ex:
'
'    Example Json:  {
'                       "key1": {
'                           "key2": {
'                               "key3": [
'                                   30,
'                                   40,
'                                   50,
'                                   { "key4": 50 },
'                                   [ 100, 200, 300 ]
'                               ],
'                               "key5": 50
'                           },
'                           "key.6": "foobar",
'                           "key'7": 60
'                       }
'                   }
'
'    Query: key1.key2.key3.key5
'    Result: The token for the '50' value associated with key5
'
'    Query: 'key1'.'key2'.'key3'.'key5'
'    Result: Same as previous result, quoting doesn't change the query.
'
'    Query: key1.'key.6'
'    Result: The token for "foobar". Quotes here are necessary to ensure the
'            '.' is understood to be part of a key name. Also, quoted and
'            unquoted keys can be mixed in the same query.
'
'    Query: key1.'key\'7'
'    Result: The token for 60. In this case, the single quote in the key name
'            should be escaped with backslash.
'
'    Query: key1
'    Result: The token for the object containing key2, key.6, and key'7
'
'    Query: key1.key2.key3
'    Result: The token for the array.
'
'    Query: key1.key2.key3(0)
'    Result: The token for 30, the first element in the array.
'
'    Query: key1.key2.key3(5)
'    Result: Error, the array starts at index 0 so the last valid index is 4.
'            Attempting to access an index outside the bounds of the array
'            generates an error.
'
'    Query: key1.key2.key3(3).key4
'    Result: The token for 50. More keys can be specified after an array index.
'
'    Query: key1.key2.key3(4)(1)
'    Result: The token for 200. Multiple array bounds can be used to query nested arrays.
'
' The regular JsonQuery& and JsonQueryFrom& return the token index of the query
' result. The `*Value$` versions are a convinence that return the string
' representation of the queried token. JsonTokenGetValueStr() is used to get the
' string value, so the Value$ versions will only return results for primitives
' and keys.
DECLARE FUNCTION JsonQuery&(j AS Json, query AS STRING)
DECLARE FUNCTION JsonQueryValue$(j AS Json, query AS STRING)

' These work the same as their `JsonQuery&()` counterparts but do not start at
' the root token, instead starting at token 'startToken'
'
' You can either recieve the value directly with `Value$`, or recieve the token
' index via `Token&`
DECLARE FUNCTION JsonQueryFrom&(j AS Json, startToken AS LONG, query AS STRING)
DECLARE FUNCTION JsonQueryFromValue$(j AS Json, startToken AS LONG, query AS STRING)

' Controls how many Json tokens are allocated at a single time. The total
' number of tokens allocated is _Shl(1, JSON_BLOCK_SHIFT). A higher value means
' better performance for large JSON structures, but higher memory usage for
' smaller ones.
'
' 8 gives 256 tokens allocated at a time.
CONST JSON_BLOCK_SHIFT = 8

' Tells the Json object that the token at the given index is no longer used and
' its memory can be reused or free'd.
'
' NOTE: This is _NOT_ necessary for typical usage of Json objects, as JsonClear
'       will release the memory of any created Json tokens for you. It is
'       really only useful if you are modifying the structure of an existing
'       Json object and want to manually cleanup the tokens that are no longer
'       needed.
'
' NOTE: This will also free any children tokens associated with this token.
'       Typically this is what you want as normal Json behavior will not reuse
'       tokens in the Json tree.
DECLARE SUB      JsonTokenFree(j AS Json, idx AS LONG)

' Same as JsonTokenFree(), but children tokens are _NOT_ free'd. This can very
' easily leak tokens. AGain, like JsonTokenFree, such a leak would only exist
' until JsonClear is called.
DECLARE SUB      JsonTokenFreeShallow(j AS Json, idx AS LONG)

' Internal Constants
CONST ___JSON_LEX_None = 0
CONST ___JSON_LEX_Null = 1
CONST ___JSON_LEX_String = 2
CONST ___JSON_LEX_Number = 3
CONST ___JSON_LEX_Bool = 4
CONST ___JSON_LEX_LeftBrace = 5
CONST ___JSON_LEX_RightBrace = 6
CONST ___JSON_LEX_LeftBracket = 7
CONST ___JSON_LEX_RightBracket = 8
CONST ___JSON_LEX_Comma = 9
CONST ___JSON_LEX_Colon = 10
CONST ___JSON_LEX_End = 11

CONST ___JSON_QLEX_Key = 1
CONST ___JSON_QLEX_Index = 2
CONST ___JSON_QLEX_Dot = 3
CONST ___JSON_QLEX_End = 4

