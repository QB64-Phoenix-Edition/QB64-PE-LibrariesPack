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
'| === ImgProcDemo.bas ===                                           |
'|                                                                   |
'| == A short example to show the usage of the "imageprocess.bm"     |
'| == functions and view some of the available effects and filters.  |
'|                                                                   |
'+-------------------------------------------------------------------+
'| Done by RhoSigma, R.Heyder, provided AS IS, use at your own risk. |
'| Find me in the QB64 Forum or mail to support@rhosigma-cw.net for  |
'| any questions or suggestions. Thanx for your interest in my work. |
'+-------------------------------------------------------------------+

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'RhoSigma/Imageprocess'

'--- Find the root path to the example's source folder.
'-----
IF _FILEEXISTS("ImgProcDemo.bas") THEN
    root$ = ""
ELSEIF _FILEEXISTS("qb64pe.exe") _ORELSE _FILEEXISTS("qb64pe") THEN
    root$ = "libraries\examples\RhoSigma\Imageprocess\"
ELSE
    qbfo$ = _SELECTFOLDERDIALOG$("Please locate your QB64-PE main folder...")
    IF LEN(qbfo$) > 0 _ANDALSO (_FILEEXISTS(qbfo$ + "\qb64pe.exe") _ORELSE _FILEEXISTS(qbfo$ + "\qb64pe")) THEN
        root$ = qbfo$ + "\libraries\examples\RhoSigma\Imageprocess\"
    ELSE
        PRINT "Can't locate required assets, please run again and select"
        PRINT "your QB64-PE folder when ask for it."
        END
    END IF
END IF

'--- Load the test (original) image.
'-----
oImg& = _LOADIMAGE(root$ + "BeachGirl.jpg", 32)
IF oImg& >= -1 THEN
    PRINT "ERROR: Can't load BeachGirl.jpg, make sure the image is in the"
    PRINT "       same directory as this example's source file."
    END
END IF

'--- Make a simple mask image (must have same size).
'-----
mImg& = _NEWIMAGE(_WIDTH(oImg&), _HEIGHT(oImg&), 256)
IF mImg& >= -1 THEN
    PRINT "ERROR: Can't create mask Image, out of memory?"
    END
ELSE
    _DEST mImg&
    FOR r! = 0 TO 100 STEP 0.25
        CIRCLE (250, 300), r!, 15 'any color except color 0 will do
        CIRCLE (500, 400), r!, 15
        CIRCLE (625, 100), r!, 15
        CIRCLE (750, 600), r!, 15
        CIRCLE (300, 700), r!, 15
    NEXT r!
    _DEST 0
END IF

'--- Get user's choice.
'-----
getChoice:
_TITLE "Image processing Demo"
COLOR 9: PRINT VersionImgProcDemo$: COLOR 7
PRINT
PRINT "How would you like this Demo to perform?": PRINT
PRINT "  1 - process the entire image"
PRINT "  2 - use a mask image to define the parts to process"
PRINT "  3 - process a selected rectangular area"
PRINT "  4 - combine mask & selected area"
PRINT "  5 - quit Demo"
DO: LOOP UNTIL INKEY$ = "" 'flush input buffer
uc% = 0: WHILE uc% < 1 OR uc% > 5: _LIMIT 20: uc% = VAL(INKEY$): WEND
SELECT CASE uc%
    CASE 1
        mask& = -1
        left% = -1: topp% = -1
        righ% = -1: bott% = -1
    CASE 2
        _TITLE "This is the mask Image, press any key..."
        SCREEN mImg&: SLEEP
        mask& = mImg&
        left% = -1: topp% = -1
        righ% = -1: bott% = -1
    CASE 3
        mask& = -1
        left% = 250: topp% = 70
        righ% = 820: bott% = -1
    CASE 4
        _TITLE "This is the mask Image, press any key..."
        SCREEN mImg&: SLEEP
        mask& = mImg&
        left% = 250: topp% = 70
        righ% = 820: bott% = -1
    CASE 5
        _FREEIMAGE (mImg&)
        _FREEIMAGE (oImg&)
        SYSTEM
END SELECT
GOSUB demo 'perform demo
GOTO getChoice

'--- The demo GOSUB routine will show only some
'--- of the effects and filters available in the library.
'-----
demo:
'--- first show the original image ---
_TITLE "The original Image, press any key..."
SCREEN oImg&: _DELAY 0.2: _SCREENMOVE _MIDDLE: SLEEP

'--- now make the image somewhat brighter ---
_TITLE "The Gamma Correction (1.25), press any key..."
gamm& = ModifyGamma&(oImg&, 1.25, left%, topp%, righ%, bott%, mask&)
SCREEN gamm&: SLEEP

'--- then make it negative ---
_TITLE "The Negative Effect, press any key..."
nega& = MakeNegative&(oImg&, left%, topp%, righ%, bott%, mask&)
SCREEN nega&: SLEEP: _FREEIMAGE (gamm&)

'--- shift color channels ---
_TITLE "Shifted RGB order to GBR, press any key..."
shif& = ShiftARGB&(oImg&, "AGBR", left%, topp%, righ%, bott%, mask&)
SCREEN shif&: SLEEP: _FREEIMAGE (nega&)

'--- go on with a grayscale ---
_TITLE "The Grayscale Effect, press any key..."
gray& = MakeGrayscale&(oImg&, left%, topp%, righ%, bott%, mask&)
SCREEN gray&: SLEEP: _FREEIMAGE (shif&)

'--- let it look like an old photograph ---
_TITLE "The AntiqueTint Effect, press any key..."
tint& = MakeAntiqueTint&(gray&, left%, topp%, righ%, bott%, mask&)
SCREEN tint&: SLEEP: _FREEIMAGE (gray&)

'--- apply a well known "edge dectect" filter ---
_TITLE "A Laplace Filter, press any key..."
lapl& = ApplyFilter&(oImg&, "Laplace8", 0, 0, left%, topp%, righ%, bott%, mask&)
SCREEN lapl&: SLEEP: _FREEIMAGE (tint&)

'--- then an artistic filter ---
_TITLE "The Deep (artistic) Filter, press any key..."
deep& = ApplyFilter&(oImg&, "Deep", 0, 0, left%, topp%, righ%, bott%, mask&)
SCREEN deep&: SLEEP: _FREEIMAGE (lapl&)

'--- this will extract the green channel out of the ARGB data ---
_TITLE "Extracted green Channel, press any key..."
gree& = ExtractChannels&(oImg&, "G", left%, topp%, righ%, bott%, mask&)
SCREEN gree&: SLEEP: _FREEIMAGE (deep&)

'--- stripping out some bits will have a threshold effect ---
_TITLE "Extracted every 2nd BitPlane (Andy Warhol Art?), press any key..."
bits& = ExtractBitfields&(oImg&, &B10101010, 1, "RGB", left%, topp%, righ%, bott%, mask&)
SCREEN bits&: SLEEP: _FREEIMAGE (gree&)

'--- the lower bits usually have a lot of noise ---
_TITLE "Showing the Noise (lower 2 BitPlanes), press any key..."
nois& = ExtractBitfields&(oImg&, &B00000011, 1, "RGB", left%, topp%, righ%, bott%, mask&)
SCREEN nois&: SLEEP: _FREEIMAGE (bits&)

'--- Reset the screen and return.
'-----
SCREEN 0: _FREEIMAGE (nois&)
RETURN

'--- Function to define/return the program's version string.
'-----
FUNCTION VersionImgProcDemo$
    VersionImgProcDemo$ = MID$("$VER: ImgProcDemo 1.0 (29-Jul-2016) by RhoSigma :END$", 7, 41)
END FUNCTION

