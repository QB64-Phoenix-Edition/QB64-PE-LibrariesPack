' =========================================================
' Commented source copy for the GIF89A backend.
' Explanatory comments were added in English without altering executable code.
' =========================================================
' GIF89a backend prepared for unified Anim... dispatcher
' Demo code removed. Public names use Gif89a... prefix.

$INCLUDEONCE

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

' Constant: GIF89A_FMT_GIF87A is a GIF-specific constant used while parsing or decoding GIF89A data.
CONST GIF89A_FMT_GIF87A = 1
' Constant: GIF89A_FMT_GIF89A is a GIF-specific constant used while parsing or decoding GIF89A data.
CONST GIF89A_FMT_GIF89A = 2

' Constant: GIF89A_LOOP_FILE_DEFAULT is a GIF-specific constant used while parsing or decoding GIF89A data.
CONST GIF89A_LOOP_FILE_DEFAULT = -2
' Constant: GIF89A_LOOP_FOREVER is a GIF-specific constant used while parsing or decoding GIF89A data.
CONST GIF89A_LOOP_FOREVER = -1
' Constant: GIF89A_LOOP_ONCE is a GIF-specific constant used while parsing or decoding GIF89A data.
CONST GIF89A_LOOP_ONCE = 0
' Constant: GIF89A_SNAPSHOT_INTERVAL is a GIF-specific constant used while parsing or decoding GIF89A data.
CONST GIF89A_SNAPSHOT_INTERVAL& = 8

' Record layout: Gif89aFrameStore groups related fields used by the GIF89A backend.
' Keeping the data in one TYPE lets the module store one structured record per active object.
TYPE Gif89aFrameStore
    ' Field: Used stores the flag telling whether the current slot or record is in use.
    Used AS INTEGER
    ' Field: LeftPx stores the working value for left px.
    LeftPx AS LONG
    ' Field: TopPx stores the working value for top px.
    TopPx AS LONG
    ' Field: WidthPx stores the decoded image width in pixels.
    WidthPx AS LONG
    ' Field: HeightPx stores the decoded image height in pixels.
    HeightPx AS LONG
    ' Field: DelayCs stores the frame delay or timing value.
    DelayCs AS INTEGER
    ' Field: Disposal stores the working value for disposal.
    Disposal AS INTEGER
    ' Field: TransparentFlag stores the working value for transparent flag.
    TransparentFlag AS INTEGER
    ' Field: TransparentIndex stores the index variable used to address the current item.
    TransparentIndex AS INTEGER
    ' Field: Interlaced stores the working value for interlaced.
    Interlaced AS INTEGER
    ' Field: LocalTableFlag stores the working value for local table flag.
    LocalTableFlag AS INTEGER
    ' Field: LocalTableCount stores the count used to size or iterate the current data set.
    LocalTableCount AS LONG
    ' Field: LocalTableOfs stores the working value for local table ofs.
    LocalTableOfs AS LONG
    ' Field: LzwMinCodeSize stores the working value for LZW min code size.
    LzwMinCodeSize AS INTEGER
    ' Field: ImageDataOfs stores the buffer that holds raw, packed, or decoded byte data.
    ImageDataOfs AS LONG
END TYPE

' Record layout: Gif89aStore groups related fields used by the GIF89A backend.
' Keeping the data in one TYPE lets the module store one structured record per active object.
TYPE Gif89aStore
    ' Field: Used stores the flag telling whether the current slot or record is in use.
    Used AS INTEGER
    ' Field: Is89a stores the Boolean-like flag used by the current routine.
    Is89a AS INTEGER
    ' Field: WidthPx stores the decoded image width in pixels.
    WidthPx AS LONG
    ' Field: HeightPx stores the decoded image height in pixels.
    HeightPx AS LONG
    ' Field: BackgroundIndex stores the index variable used to address the current item.
    BackgroundIndex AS INTEGER
    ' Field: GlobalTableFlag stores the working value for global table flag.
    GlobalTableFlag AS INTEGER
    ' Field: GlobalTableCount stores the count used to size or iterate the current data set.
    GlobalTableCount AS LONG
    ' Field: GlobalTableOfs stores the working value for global table ofs.
    GlobalTableOfs AS LONG
    ' Field: BgColor stores the column index or color-related value.
    BgColor AS _UNSIGNED LONG
    ' Field: FrameStart stores the working value for frame start.
    FrameStart AS LONG
    ' Field: FrameCount stores the total number of frames available for the current animation.
    FrameCount AS LONG
    ' Field: CurrentFrame stores the zero-based frame index currently selected for display or playback.
    CurrentFrame AS LONG
    ' Field: Playing stores the flag telling whether playback is currently running.
    Playing AS INTEGER
    ' Field: Paused stores the flag telling whether playback is temporarily paused.
    Paused AS INTEGER
    ' Field: LoopMode stores the loop policy that controls whether playback stops or repeats.
    LoopMode AS LONG
    ' Field: FileLoopCount stores the count used to size or iterate the current data set.
    FileLoopCount AS LONG
    ' Field: LoopIteration stores the counter of completed playback loops.
    LoopIteration AS LONG
    ' Field: NextTick stores the absolute timer target for the next frame advance.
    NextTick AS DOUBLE
    ' Field: RemainingDelay stores the time still left before the next frame should be shown.
    RemainingDelay AS DOUBLE
    ' Field: LastRawTimer stores the raw timer snapshot used to measure elapsed playback time.
    LastRawTimer AS DOUBLE
    ' Field: CanvasHandle stores the handle used to reference an external or QB64 resource.
    CanvasHandle AS LONG
    ' Field: RestoreHandle stores the handle used to reference an external or QB64 resource.
    RestoreHandle AS LONG
    ' Field: RenderedFrame stores the working value for rendered frame.
    RenderedFrame AS LONG
    ' Field: SnapshotMetaStart stores the working value for snapshot meta start.
    SnapshotMetaStart AS LONG
    ' Field: SnapshotCount stores the count used to size or iterate the current data set.
    SnapshotCount AS LONG
    ' Field: SnapshotInterval stores the working value for snapshot interval.
    SnapshotInterval AS LONG
END TYPE

' Record layout: Gif89aSnapshotStore groups related fields used by the GIF89A backend.
' Keeping the data in one TYPE lets the module store one structured record per active object.
TYPE Gif89aSnapshotStore
    ' Field: Used stores the flag telling whether the current slot or record is in use.
    Used AS INTEGER
    ' Field: FrameIndex stores the index variable used to address the current item.
    FrameIndex AS LONG
    ' Field: CanvasHandle stores the handle used to reference an external or QB64 resource.
    CanvasHandle AS LONG
    ' Field: RestoreHandle stores the handle used to reference an external or QB64 resource.
    RestoreHandle AS LONG
END TYPE

' Shared dynamic array: Gif89aFrames is resized here to hold the dynamic array that stores per-frame data or cached frame metadata.
REDIM SHARED Gif89aFrames(0) AS Gif89aFrameStore
' Shared dynamic array: Gif89aItems is resized here to hold the dynamic table that stores one record per live object handled by this module.
REDIM SHARED Gif89aItems(0) AS Gif89aStore
' Shared dynamic array: Gif89aRawData is resized here to hold the buffer that holds raw, packed, or decoded byte data.
REDIM SHARED Gif89aRawData(0) AS STRING
' Shared dynamic array: Gif89aErrorTexts is resized here to hold the text storage for the last human-readable error message.
REDIM SHARED Gif89aErrorTexts(0) AS STRING
' Shared dynamic array: Gif89aDecodePrefix is resized here to hold the working value for GIF89A decode prefix.
REDIM SHARED Gif89aDecodePrefix(0) AS LONG
' Shared dynamic array: Gif89aDecodeSuffix is resized here to hold the working value for GIF89A decode suffix.
REDIM SHARED Gif89aDecodeSuffix(0) AS INTEGER
' Shared dynamic array: Gif89aDecodeStack is resized here to hold the working value for GIF89A decode stack.
REDIM SHARED Gif89aDecodeStack(0) AS INTEGER
' Shared dynamic array: Gif89aFrameIndexScratch is resized here to hold the working value for GIF89A frame index scratch.
REDIM SHARED Gif89aFrameIndexScratch(0) AS INTEGER
' Shared dynamic array: Gif89aDrawIndexScratch is resized here to hold the working value for GIF89A draw index scratch.
REDIM SHARED Gif89aDrawIndexScratch(0) AS INTEGER
' Shared dynamic array: Gif89aPaletteRgbaScratch is resized here to hold the palette storage or palette index used during indexed-color decoding.
REDIM SHARED Gif89aPaletteRgbaScratch(0) AS _UNSIGNED LONG
' Shared dynamic array: Gif89aSnapshotMeta is resized here to hold the working value for GIF89A snapshot meta.
REDIM SHARED Gif89aSnapshotMeta(0) AS Gif89aSnapshotStore
' Shared variable: Gif89aFrameTail stores the working value for GIF89A frame tail.
DIM SHARED Gif89aFrameTail AS LONG
' Shared variable: Gif89aSnapshotMetaNext stores the working value for GIF89A snapshot meta next.
DIM SHARED Gif89aSnapshotMetaNext AS LONG
' Shared variable: Gif89aSnapshotMetaCapacity stores the working value for GIF89A snapshot meta capacity.
DIM SHARED Gif89aSnapshotMetaCapacity AS LONG

' Purpose: Seek to a specific GIF89A frame or time position.
' Parameters: gifId = working value for GIF id; frameIndex = index variable used to address the current item.
' Return value: the function result follows the success/failure or data-return convention used by this module.
' Declaration only: the executable body is implemented later in the matching .bm module.
DECLARE FUNCTION Gif89aSeekFrame% (gifId As Long, frameIndex As Long)

