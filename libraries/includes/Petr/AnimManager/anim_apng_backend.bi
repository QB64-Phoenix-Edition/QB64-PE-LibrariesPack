' =========================================================
' Commented source copy for the APNG backend.
' Explanatory comments were added in English without altering executable code.
' =========================================================
' APNG backend prepared for unified Anim... dispatcher
' Demo code removed. Public names use Apng... prefix.

$INCLUDEONCE

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

' Constant: APNG_FMT_PNG is a APNG/PNG-specific constant used while parsing or decoding chunked image data.
CONST APNG_FMT_PNG = 1
' Constant: APNG_FMT_APNG is a APNG/PNG-specific constant used while parsing or decoding chunked image data.
CONST APNG_FMT_APNG = 2

' Constant: APNG_LOOP_FILE_DEFAULT is a APNG/PNG-specific constant used while parsing or decoding chunked image data.
CONST APNG_LOOP_FILE_DEFAULT = -2
' Constant: APNG_LOOP_FOREVER is a APNG/PNG-specific constant used while parsing or decoding chunked image data.
CONST APNG_LOOP_FOREVER = -1
' Constant: APNG_LOOP_ONCE is a APNG/PNG-specific constant used while parsing or decoding chunked image data.
CONST APNG_LOOP_ONCE = 0

' Record layout: ApngFrameStore groups related fields used by the APNG backend.
' Keeping the data in one TYPE lets the module store one structured record per active object.
TYPE ApngFrameStore
    ' Field: Used stores the flag telling whether the current slot or record is in use.
    Used AS INTEGER
    ' Field: WidthPx stores the decoded image width in pixels.
    WidthPx AS LONG
    ' Field: HeightPx stores the decoded image height in pixels.
    HeightPx AS LONG
    ' Field: XOffset stores the working value for x offset.
    XOffset AS LONG
    ' Field: YOffset stores the working value for y offset.
    YOffset AS LONG
    ' Field: DelayNum stores the frame delay or timing value.
    DelayNum AS INTEGER
    ' Field: DelayDen stores the frame delay or timing value.
    DelayDen AS INTEGER
    ' Field: DisposeOp stores the working value for dispose op.
    DisposeOp AS INTEGER
    ' Field: BlendOp stores the working value for blend op.
    BlendOp AS INTEGER
    ' Field: ImageHandle stores the QB64 image handle used to store or draw decoded pixels.
    ImageHandle AS LONG
END TYPE

' Record layout: ApngStore groups related fields used by the APNG backend.
' Keeping the data in one TYPE lets the module store one structured record per active object.
TYPE ApngStore
    ' Field: Used stores the flag telling whether the current slot or record is in use.
    Used AS INTEGER
    ' Field: IsAnimated stores the Boolean-like flag used by the current routine.
    IsAnimated AS INTEGER
    ' Field: WidthPx stores the decoded image width in pixels.
    WidthPx AS LONG
    ' Field: HeightPx stores the decoded image height in pixels.
    HeightPx AS LONG
    ' Field: FrameStart stores the working value for frame start.
    FrameStart AS LONG
    ' Field: FrameCount stores the total number of frames available for the current animation.
    FrameCount AS LONG
    ' Field: PlayCount stores the count used to size or iterate the current data set.
    PlayCount AS LONG
    ' Field: DefaultImageIncluded stores the working value for default image included.
    DefaultImageIncluded AS INTEGER
    ' Field: CurrentFrame stores the zero-based frame index currently selected for display or playback.
    CurrentFrame AS LONG
    ' Field: Playing stores the flag telling whether playback is currently running.
    Playing AS INTEGER
    ' Field: Paused stores the flag telling whether playback is temporarily paused.
    Paused AS INTEGER
    ' Field: LoopMode stores the loop policy that controls whether playback stops or repeats.
    LoopMode AS LONG
    ' Field: NextTick stores the absolute timer target for the next frame advance.
    NextTick AS DOUBLE
    ' Field: RemainingDelay stores the time still left before the next frame should be shown.
    RemainingDelay AS DOUBLE
    ' Field: LastRawTimer stores the raw timer snapshot used to measure elapsed playback time.
    LastRawTimer AS DOUBLE
    ' Field: CompletedLoops stores the working value for completed loops.
    CompletedLoops AS LONG
    ' Field: CanvasHandle stores the handle used to reference an external or QB64 resource.
    CanvasHandle AS LONG
    ' Field: BackupHandle stores the handle used to reference an external or QB64 resource.
    BackupHandle AS LONG
    ' Field: RenderedFrame stores the working value for rendered frame.
    RenderedFrame AS LONG
END TYPE

' Shared dynamic array: ApngFrames is resized here to hold the dynamic array that stores per-frame data or cached frame metadata.
REDIM SHARED ApngFrames(0 TO 0) AS ApngFrameStore
' Shared dynamic array: ApngFrameData is resized here to hold the buffer that holds raw, packed, or decoded byte data.
REDIM SHARED ApngFrameData(0 TO 0) AS STRING
' Shared dynamic array: ApngItems is resized here to hold the dynamic table that stores one record per live object handled by this module.
REDIM SHARED ApngItems(0 TO 0) AS ApngStore
' Shared dynamic array: ApngHeaderChunks is resized here to hold the working value for APNG header chunks.
REDIM SHARED ApngHeaderChunks(0 TO 0) AS STRING
' Shared dynamic array: ApngIhdrData is resized here to hold the buffer that holds raw, packed, or decoded byte data.
REDIM SHARED ApngIhdrData(0 TO 0) AS STRING
' Shared dynamic array: ApngErrorTexts is resized here to hold the text storage for the last human-readable error message.
REDIM SHARED ApngErrorTexts(0 TO 0) AS STRING

' Shared variable: ApngItemCapacity stores the working value for APNG item capacity.
DIM SHARED ApngItemCapacity AS LONG
' Shared variable: ApngFrameCapacity stores the working value for APNG frame capacity.
DIM SHARED ApngFrameCapacity AS LONG
' Shared variable: ApngFrameTail stores the working value for APNG frame tail.
DIM SHARED ApngFrameTail AS LONG

' Purpose: Seek to a specific APNG frame or time position.
' Parameters: apngId = working value for APNG id; frameIndex = index variable used to address the current item.
' Return value: the function result follows the success/failure or data-return convention used by this module.
' Declaration only: the executable body is implemented later in the matching .bm module.
DECLARE FUNCTION ApngSeekFrame% (apngId As Long, frameIndex As Long)

