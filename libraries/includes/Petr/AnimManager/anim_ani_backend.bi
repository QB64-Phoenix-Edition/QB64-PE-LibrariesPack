' =========================================================
' Commented source copy for the Windows ANI backend.
' Explanatory comments were added in English without altering executable code.
' =========================================================
' ANI cursor backend for RIFF ACON files
' Public names use Ani... prefix.

$INCLUDEONCE

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

' Constant: ANI_LOOP_FILE_DEFAULT is a ANI/RIFF constant used while parsing Windows animated cursor files.
CONST ANI_LOOP_FILE_DEFAULT = -2
' Constant: ANI_LOOP_FOREVER is a ANI/RIFF constant used while parsing Windows animated cursor files.
CONST ANI_LOOP_FOREVER = -1
' Constant: ANI_LOOP_ONCE is a ANI/RIFF constant used while parsing Windows animated cursor files.
CONST ANI_LOOP_ONCE = 0

' Record layout: AniFrameStore groups related fields used by the Windows ANI backend.
' Keeping the data in one TYPE lets the module store one structured record per active object.
TYPE AniFrameStore
    ' Field: Used stores the flag telling whether the current slot or record is in use.
    Used AS INTEGER
    ' Field: ImageHandle stores the QB64 image handle used to store or draw decoded pixels.
    ImageHandle AS LONG
    ' Field: HotX stores the working value for hot x.
    HotX AS LONG
    ' Field: HotY stores the working value for hot y.
    HotY AS LONG
END TYPE

' Record layout: AniStepStore groups related fields used by the Windows ANI backend.
' Keeping the data in one TYPE lets the module store one structured record per active object.
TYPE AniStepStore
    ' Field: Used stores the flag telling whether the current slot or record is in use.
    Used AS INTEGER
    ' Field: FrameIndex stores the index variable used to address the current item.
    FrameIndex AS LONG
    ' Field: DelayJif stores the frame delay or timing value.
    DelayJif AS LONG
END TYPE

' Record layout: AniStore groups related fields used by the Windows ANI backend.
' Keeping the data in one TYPE lets the module store one structured record per active object.
TYPE AniStore
    ' Field: Used stores the flag telling whether the current slot or record is in use.
    Used AS INTEGER
    ' Field: WidthPx stores the decoded image width in pixels.
    WidthPx AS LONG
    ' Field: HeightPx stores the decoded image height in pixels.
    HeightPx AS LONG
    ' Field: FrameStart stores the working value for frame start.
    FrameStart AS LONG
    ' Field: UniqueFrameCount stores the total number of frames available for the current animation.
    UniqueFrameCount AS LONG
    ' Field: StepStart stores the working value for step start.
    StepStart AS LONG
    ' Field: StepCount stores the count used to size or iterate the current data set.
    StepCount AS LONG
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
    ' Field: LoopIteration stores the counter of completed playback loops.
    LoopIteration AS LONG
END TYPE

' Shared dynamic array: AniFrames is resized here to hold the dynamic array that stores per-frame data or cached frame metadata.
REDIM SHARED AniFrames(0 TO 0) AS AniFrameStore
' Shared dynamic array: AniSteps is resized here to hold the working value for ANI steps.
REDIM SHARED AniSteps(0 TO 0) AS AniStepStore
' Shared dynamic array: AniItems is resized here to hold the dynamic table that stores one record per live object handled by this module.
REDIM SHARED AniItems(0 TO 0) AS AniStore
' Shared dynamic array: AniErrorTexts is resized here to hold the text storage for the last human-readable error message.
REDIM SHARED AniErrorTexts(0 TO 0) AS STRING
' Shared variable: AniItemCapacity stores the working value for ANI item capacity.
DIM SHARED AniItemCapacity AS LONG
' Shared variable: AniFrameCapacity stores the working value for ANI frame capacity.
DIM SHARED AniFrameCapacity AS LONG
' Shared variable: AniStepCapacity stores the working value for ANI step capacity.
DIM SHARED AniStepCapacity AS LONG

' Purpose: Seek to a specific ANI frame or time position.
' Parameters: aniId = working value for ANI id; frameIndex = index variable used to address the current item.
' Return value: the function result follows the success/failure or data-return convention used by this module.
' Declaration only: the executable body is implemented later in the matching .bm module.
DECLARE FUNCTION AniSeekFrame% (aniId As Long, frameIndex As Long)

