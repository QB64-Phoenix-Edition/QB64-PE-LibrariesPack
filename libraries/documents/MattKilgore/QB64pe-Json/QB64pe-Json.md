# QB64pe-Json

This is a JSON parsing and creation library for QB64-PE. Given a
string containing JSON, it can convert it into a Json object which can then be
queried to retrieve the values in the JSON. Additionally it contains a variety
of `JsonTokenCreate*` functions which can be used to build up a Json object,
which can then be rendered into a String version of that JSON.

Please see [json.bi](../../../includes/MattKilgore/QB64pe-Json/json.bi) for
more indepth documentation around the API.<br>
To be able to use the API, place the line `$USELIBRARY:'MattKilgore/QB64pe-Json'`
at the top of your program.

## Overall Design

QB64pe-Json works by turning a JSON structure into a collection of "tokens",
which are kept internal to a Json object. Tokens are allocated as needed, and
token IDs are returned from several functions. You can then pass a token
ID into many of the APIs to interact with the token, such as get its value,
get its children, etc. Valid token IDs are always positive.

The main Type in QB64pe-Json is the `Json` Type. After declaring one, you need
to pass it to `JsonInit` to initialize it, and eventually pass it to
`JsonClear` to release it. Not passing a Json object to `JsonClear` will
result in memory leaks.

There are four types of tokens - Objects, Arrays, Keys, and Values. Values are
then split up into several "primitive" types a value can be, which are strings,
numbers, bools, and `null`. A typical token structure looks something like
this:

This is the original JSON passed to `JsonParse()`:
```json
{
    "key1": {
        "key2": 20,
        "key3": [ true, "string", null ],
    },
    "key4": 50
}
```

This is the resulting token structure:
```plain
Object (1)
  - Key (value = "key1") (2)
    - Object (3)
      - Key (value = "key2") (4)
        - Value (type = number, value = 20) (5)
      - Key (value = "key3") (6)
        - Array (7)
          - Value (type = bool, value = true) (8)
          - Value (type = string, value = "string") (9)
          - Value (type = null) (10)
  - Key (value = "key4") (11)
    - Value (type = number, value = 50) (12)
```

The numbers after each token signify its ID, which is what will be returned by
the API when refering to that paticular token. The typical way to interact with this
structure is through `JsonQuery()`, which takes a query string and returns the
token identified by it. For example, if you do `JsonQuery(json, "key1.key2")`,
it will return 5, which is the token ID for the "20" Value token. You can then
pass the token ID from that query to `JsonTokenGetValueInteger(token)` to
retrive the actual value 20 as an integer.

`JsonQuery(json, "key2.key3")` returns 7, the token ID for the Array. With this
array you can make use of `JsonTokenTotalChildren(array)` and pass it the token
ID to retrieve the number of children (entries) in that array. You can then
additionally make use of `JsonTokenGetChild(array, index)` to get the token ID
of each child of the array. Note the indexes into the array start at zero, so
`JsonTokenGetChild(array, 0)` would return 8, the bool in the array since it is
the first entry. `JsonTokenGetChild(array, 2)` would return 10, the last entry
in the array. You can of course then pass those token IDs to the various
`JsonTokenGetValue` functions to retrieve their values.

If you have a token and need to know what it is, you can use
`JsonTokenGetType(token)` to retrieve a `JSONTOK_TYPE_*` value indicating its
type. If its type is `JSONTOK_TYPE_VALUE`, then you can additionally use
`JsonTokenGetPrimType(token)` to get its primitive type, in the form of a
`JSONTOK_PRIM_*` value.

Json objects contain the concept of a "RootToken", which is simply the token
of the base of the entire JSON structure. Several APIs start at the RootToken
automatically, such as `JsonQuery()`, `JsonRender()`, etc. However all APIs
offer an option to take a token directly to start with, ignoring the RootToken.
This is powerful as it allows you to treat smaller subtrees of the entire
structure as their own Json structure. For example in the above structure, you
can use `JsonQueryFrom(3, "key2")` to do a query starting from the Object with
index 3, completely ignoring the Object it's contained in.

Errors are reported from QB64pe-Json via the global `JsonHadError` and `JsonError`
variables. `JsonHadError` is zero (`JSON_ERR_Success`) when a function was
successful, and a negative value when an error occurs. The negative values
corespond to the `JSON_ERR_*` constants, and indicate the specific kind of
error that occured. `JsonError` will contain a human-readable string version of
the error.

## JSON Creation

In addition to parsing JSON, QB64pe-Json allows you to create the JSON
structure yourself and then turn it into a JSON string (for storing or sending
elsewhere). This is done by using the `JsonTokenCreate*()` functions. These
functions create a new token and return its token ID. You can then make use of
this token ID to add it to other tokens and build the JSON structure. Objects
and Arrays can have entries added to them via `JsonTokenArrayAdd` and
`JsonTokenObjectAdd`.

Once you have built your JSON structure, you can optionally use
`JsonSetRootToken` to set the RootToken of the Json object to be the root of
your created structure. Then, you can use `JsonRender$()` to produce a JSON
string version of that structure.

`JsonRenderFormatted$()` gives you more control over the rendering. Currently,
it allows you to include indentation in the result, which makes it easier to
read.

## UTF-8 Handling

It should be kept in mind that JSON strings are required to be valid UTF-8, this
is part of the JSON specification. QB64-PE in comparison does not use UTF-8,
and QB64-PE Strings can hold arbitrary byte data. As a result, when creating
JSON structures you need to ensure you either stick to strict 7-bit ASCII
values in your strings, or manage the UTF-8 characters yourself, e.g. by using
the UTF-8 encoding functions in the `RhoSigma/Charsets` library. Additionally,
QB64pe-Json will not do any UTF-8 decoding, so strings returned by
`JsonTokenGetValueStr$()` may contain UTF-8 character sequences depending on
the paticular JSON you're parsing.
