'+---------------+---------------------------------------------------+
'| ###### ###### |     .--. .         .-.                            |
'| ##  ## ##   # |     |   )|        (   ) o                         |
'| ##  ##  ##    |     |--' |--. .-.  `-.  .  .-...--.--. .-.        |
'| ######   ##   |     |  \ |  |(   )(   ) | (   ||  |  |(   )       |
'| ##      ##    |     '   `'  `-`-'  `-'-' `-`-`|'  '  `-`-'`-      |
'| ##     ##   # |                            ._.'                   |
'| ##     ###### |  Sources & Documents placed in the Public Domain. |
'+---------------+---------------------------------------------------+
'|                                                                   |
'| === BinaryData.bas ===                                            |
'|                                                                   |
'| == This example shows how you can easily deal with binary data in |
'| == the Simplebuffer System. It will use _MEM blocks for that and  |
'| == so it can deal with any data available through those blocks,   |
'| == such as UDTs or image/sound data. Of course, for simple numbers|
'| == you could also use the various _CV() and _MK$() functions to   |
'| == convert, read and write those data. In genaral you can use     |
'| == the Simplebuffer System similary to files, it just depends on  |
'| == your needs, how you deal with any kind of data.                |
'|                                                                   |
'+-------------------------------------------------------------------+
'| Done by RhoSigma, R.Heyder, provided AS IS, use at your own risk. |
'| Find me in the QB64 Forum or mail to support@rhosigma-cw.net for  |
'| any questions or suggestions. Thanx for your interest in my work. |
'+-------------------------------------------------------------------+

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'RhoSigma/Simplebuffer'

_TITLE "Simplebuffers binary data handling"

'--- Find the root of the library's source folder.
'-----
IF _FILEEXISTS("qb64.exe") _ORELSE _FILEEXISTS("qb64") _ORELSE _FILEEXISTS("qb64pe.exe") _ORELSE _FILEEXISTS("qb64pe") THEN
    root$ = "libraries\examples\RhoSigma\Simplebuffer\"
END IF

'--- define an UDT and fill it with some nonsense
'-----
TYPE Person
    pFIRST AS STRING * 20
    pNAME AS STRING * 20
    pSTREET AS STRING * 20
    pHNUM AS INTEGER
    pCITY AS STRING * 20
    pZIP AS LONG
END TYPE
REDIM friends(2) AS Person
friends(0).pFIRST = "Mickey"
friends(0).pNAME = "Mouse"
friends(0).pSTREET = "Disney Plaza"
friends(0).pHNUM = 123
friends(0).pCITY = "Orlando"
friends(0).pZIP = 12345
friends(1).pFIRST = "Roger"
friends(1).pNAME = "Rabbit"
friends(1).pSTREET = "ACME Rd"
friends(1).pHNUM = 456
friends(1).pCITY = "Hollywood"
friends(1).pZIP = 45678
friends(2).pFIRST = "Alice"
friends(2).pNAME = "Blue"
friends(2).pSTREET = "Rabbit Hole"
friends(2).pHNUM = 789
friends(2).pCITY = "Wonderland"
friends(2).pZIP = 78912

'--- we can transfer an entire UDT array, but different from the
'--- file GET/PUT behavior, we have to go the indirect way using
'--- a _MEM variable to get access to the array
'-----
outBuf% = CreateBuf% 'init the buffer
DIM outUDT AS _MEM
outUDT = _MEM(friends())
PutBufMemData outBuf%, outUDT 'put entire friends UDT array in buffer
BufToFile outBuf%, root$ + "usertype.dat"
_MEMFREE outUDT
DisposeBuf outBuf% 'destroy buffer
ERASE friends 'destroy UDT array

'--- same principle to get the data back, I use different variable
'--- names intentionally, to show that we really print the reloaded
'--- array data, not the array initialized above
'-----
REDIM readback(2) AS Person 'new UDT array
inBuf% = FileToBuf%(root$ + "usertype.dat") 'load file into buffer
DIM inUDT AS _MEM
inUDT = _MEM(readback())
GetBufMemData inBuf%, inUDT 'get data back into another UDT array
_MEMFREE inUDT
DisposeBuf inBuf% 'destroy buffer

'--- now print the read data for verification, it's made colorful,
'--- so we can use it for the next example
'-----
CLS: COLOR 15: PRINT "the reloaded UDT array...": PRINT
COLOR ((RND * 15) + 1): PRINT readback(0).pFIRST
COLOR ((RND * 15) + 1): PRINT readback(0).pNAME
COLOR ((RND * 15) + 1): PRINT readback(0).pSTREET
COLOR ((RND * 15) + 1): PRINT readback(0).pHNUM
COLOR ((RND * 15) + 1): PRINT readback(0).pCITY
COLOR ((RND * 15) + 1): PRINT readback(0).pZIP
COLOR ((RND * 15) + 1): PRINT readback(1).pFIRST
COLOR ((RND * 15) + 1): PRINT readback(1).pNAME
COLOR ((RND * 15) + 1): PRINT readback(1).pSTREET
COLOR ((RND * 15) + 1): PRINT readback(1).pHNUM
COLOR ((RND * 15) + 1): PRINT readback(1).pCITY
COLOR ((RND * 15) + 1): PRINT readback(1).pZIP
COLOR ((RND * 15) + 1): PRINT readback(2).pFIRST
COLOR ((RND * 15) + 1): PRINT readback(2).pNAME
COLOR ((RND * 15) + 1): PRINT readback(2).pSTREET
COLOR ((RND * 15) + 1): PRINT readback(2).pHNUM
COLOR ((RND * 15) + 1): PRINT readback(2).pCITY
COLOR ((RND * 15) + 1): PRINT readback(2).pZIP
COLOR 20: PRINT: PRINT "press any key...": SLEEP
ERASE readback 'destroy UDT array

'--- we can also transfer image/sound data, using _MEMIMAGE/_MEMSOUND
'-----
outBuf% = CreateBuf% 'init the buffer
DIM outIMG AS _MEM
outIMG = _MEMIMAGE(_DEST) 'we'll now save our corlorful printed screen from above
PutBufMemData outBuf%, outIMG
BufToFile outBuf%, root$ + "image.dat"
_MEMFREE outIMG
DisposeBuf outBuf% 'destroy buffer
CLS: COLOR 15: PRINT: PRINT "with the next keypress we reload the saved screen...": SLEEP

'--- reload and restore saved image data, using _MEMIMAGE
'-----
inBuf% = FileToBuf%(root$ + "image.dat") 'load file into buffer
DIM inIMG AS _MEM
inIMG = _MEMIMAGE(_DEST) 'our screen write page again
GetBufMemData inBuf%, inIMG 'get data back into the screen
_MEMFREE inIMG
DisposeBuf inBuf% 'destroy buffer
SLEEP

'--- obviously it works the same for numeric arrays, but not for
'--- string arrays (not even for fixed length string arrays) or
'--- UDTs containing variable length string elements
'-----
REDIM a%(15)
outBuf% = CreateBuf% 'init the buffer
FOR i% = 0 TO 15: a%(i%) = i% + 65: NEXT i% 'fill array
DIM outARR AS _MEM
outARR = _MEM(a%())
PutBufMemData outBuf%, outARR 'put entire array at once
BufToFile outBuf%, root$ + "array.dat"
_MEMFREE outARR
DisposeBuf outBuf% 'destroy buffer
ERASE a% 'destroy array

'--- get back the saved array data
'-----
REDIM b%(15)
inBuf% = FileToBuf%(root$ + "array.dat") 'load file into buffer
DIM inARR AS _MEM
inARR = _MEM(b%())
GetBufMemData inBuf%, inARR 'get data back into another array
_MEMFREE inARR
DisposeBuf inBuf% 'destroy buffer

'--- clear screen and print the reloaded array
'-----
CLS: PRINT "the reloaded array...": PRINT
FOR i% = 0 TO 15
    PRINT b%(i%), CHR$(b%(i%))
NEXT i%
ERASE b% 'destroy array

'--- that's all folks
'-----
PRINT: PRINT "You may also have a look in the created .dat files in the folder:"
PRINT _CWD$ + root$
PRINT: PRINT "done... (you may then safely delete the .dat files)"
END

'--- Function to define/return the program's version string.
'-----
FUNCTION VersionBinaryData$
    VersionBinaryData$ = MID$("$VER: BinaryData 1.0 (18-Oct-2022) by RhoSigma :END$", 7, 40)
END FUNCTION

