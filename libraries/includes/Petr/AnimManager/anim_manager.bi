' =========================================================
' Commented source copy for the unified animation manager.
' Explanatory comments were added in English without altering executable code.
' =========================================================
' Unified animation dispatcher for QB64PE
' Final project manager module using $INCLUDE backends.
' Public API prefix: Anim...

$INCLUDEONCE

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

' ---------------------------------------------------------
' Backend includes
' ---------------------------------------------------------
'$INCLUDE: 'anim_amiga_anim_backend2b.bi'
'$INCLUDE: 'anim_ani_backend.bi'
'$INCLUDE: 'anim_apng_backend.bi'
'$INCLUDE: 'anim_flic_backend_buffered_faster.bi'
'$INCLUDE: 'anim_gif89a_backend.bi'

' ---------------------------------------------------------
' Public format identifiers
' ---------------------------------------------------------
' Constant: ANIM_FMT_NONE is a format identifier used by the unified manager to select a backend.
CONST ANIM_FMT_NONE = 0
' Constant: ANIM_FMT_APNG is a format identifier used by the unified manager to select a backend.
CONST ANIM_FMT_APNG = 1
' Constant: ANIM_FMT_GIF89A is a format identifier used by the unified manager to select a backend.
CONST ANIM_FMT_GIF89A = 2
' Constant: ANIM_FMT_FLI is a format identifier used by the unified manager to select a backend.
CONST ANIM_FMT_FLI = 3
' Constant: ANIM_FMT_FLC is a format identifier used by the unified manager to select a backend.
CONST ANIM_FMT_FLC = 4
' Constant: ANIM_FMT_WEBP is a format identifier used by the unified manager to select a backend.
CONST ANIM_FMT_WEBP = 5 ' reserved, WebP support removed. If you need it, look to https://github.com/QB64Petr/AnimManager
' Constant: ANIM_FMT_AMIGA_ANIM is a format identifier used by the unified manager to select a backend.
CONST ANIM_FMT_AMIGA_ANIM = 6
' Constant: ANIM_FMT_ANI is a format identifier used by the unified manager to select a backend.
CONST ANIM_FMT_ANI = 7

' Constant: ANIM_LOOP_FILE_DEFAULT is a loop-mode constant used to control replay behavior.
CONST ANIM_LOOP_FILE_DEFAULT = -2
' Constant: ANIM_LOOP_FOREVER is a loop-mode constant used to control replay behavior.
CONST ANIM_LOOP_FOREVER = -1
' Constant: ANIM_LOOP_ONCE is a loop-mode constant used to control replay behavior.
CONST ANIM_LOOP_ONCE = 0

' Constant: ANIM_CACHE_STREAM is a cache-mode constant used by the manager caching policy.
CONST ANIM_CACHE_STREAM = 0
' Constant: ANIM_CACHE_PRELOAD_ALL is a cache-mode constant used by the manager caching policy.
CONST ANIM_CACHE_PRELOAD_ALL = 1
' Constant: ANIM_CACHE_WINDOW is a cache-mode constant used by the manager caching policy.
CONST ANIM_CACHE_WINDOW = 2
' Constant: ANIM_CACHE_AUTO is a cache-mode constant used by the manager caching policy.
CONST ANIM_CACHE_AUTO = 3
' Constant: ANIM_CACHE_DEFAULT_BUDGET_MB is a default cache-budget constant expressed in megabytes.
CONST ANIM_CACHE_DEFAULT_BUDGET_MB = 256

' ---------------------------------------------------------
' Public unified store
' ---------------------------------------------------------
' Record layout: AnimStore groups related fields used by the unified animation manager.
' Keeping the data in one TYPE lets the module store one structured record per active object.
TYPE AnimStore
    ' Field: Used stores the flag telling whether the current slot or record is in use.
    Used AS INTEGER
    ' Field: FormatId stores the numeric identifier of the detected animation file format.
    FormatId AS LONG
    ' Field: BackendId stores the backend-specific handle or index used to reach the real decoder state.
    BackendId AS LONG
    ' Field: WidthPx stores the decoded image width in pixels.
    WidthPx AS LONG
    ' Field: HeightPx stores the decoded image height in pixels.
    HeightPx AS LONG
    ' Field: FrameCount stores the total number of frames available for the current animation.
    FrameCount AS LONG
    ' Field: CurrentFrame stores the zero-based frame index currently selected for display or playback.
    CurrentFrame AS LONG
    ' Field: Playing stores the flag telling whether playback is currently running.
    Playing AS INTEGER
    ' Field: LoopMode stores the loop policy that controls whether playback stops or repeats.
    LoopMode AS LONG
    ' Field: CacheModeWanted stores the requested cache strategy chosen by the caller or by defaults.
    CacheModeWanted AS LONG
    ' Field: CacheModeActive stores the cache strategy that is actually active after validation.
    CacheModeActive AS LONG
    ' Field: CacheEstimatedBytes stores the estimated memory cost used to decide whether caching is practical.
    CacheEstimatedBytes AS _UNSIGNED _INTEGER64
    ' Field: CacheFrameStart stores the first frame index covered by the current cache window.
    CacheFrameStart AS LONG
    ' Field: CacheFrameCount stores the number of frames currently covered by the current cache window.
    CacheFrameCount AS LONG
    ' Field: CacheReady stores the flag telling whether the current cache content is valid and usable.
    CacheReady AS INTEGER
    ' Field: Paused stores the flag telling whether playback is temporarily paused.
    Paused AS INTEGER
    ' Field: NextTick stores the absolute timer target for the next frame advance.
    NextTick AS DOUBLE
    ' Field: RemainingDelay stores the time still left before the next frame should be shown.
    RemainingDelay AS DOUBLE
    ' Field: LastRawTimer stores the raw timer snapshot used to measure elapsed playback time.
    LastRawTimer AS DOUBLE
    ' Field: LoopIteration stores the counter of completed playback loops.
    LoopIteration AS LONG
END TYPE

' Record layout: AnimCacheFrameStore groups related fields used by the unified animation manager.
' Keeping the data in one TYPE lets the module store one structured record per active object.
TYPE AnimCacheFrameStore
    ' Field: Used stores the flag telling whether the current slot or record is in use.
    Used AS INTEGER
    ' Field: ImageHandle stores the QB64 image handle used to store or draw decoded pixels.
    ImageHandle AS LONG
    ' Field: ByteCost stores the approximate memory cost in bytes for one cached object.
    ByteCost AS _UNSIGNED _INTEGER64
END TYPE

' Shared dynamic array: AnimItems is resized here to hold the dynamic table that stores one record per live object handled by this module.
REDIM SHARED AnimItems(0 TO 0) AS AnimStore
' Shared dynamic array: AnimFileNames is resized here to hold the parallel array that remembers the source filename for each active entry.
REDIM SHARED AnimFileNames(0 TO 0) AS STRING
' Shared dynamic array: AnimErrorTexts is resized here to hold the text storage for the last human-readable error message.
REDIM SHARED AnimErrorTexts(0 TO 0) AS STRING
' Shared dynamic array: AnimCacheFrames is resized here to hold the dynamic array that stores per-frame data or cached frame metadata.
REDIM SHARED AnimCacheFrames(0 TO 0) AS AnimCacheFrameStore
' Shared variable: AnimCacheBytesUsed stores the running total of cache memory currently consumed.
DIM SHARED AnimCacheBytesUsed AS _UNSIGNED _INTEGER64
' Shared variable: AnimCacheBytesBudget stores the memory budget that limits how much frame cache this module may keep.
DIM SHARED AnimCacheBytesBudget AS _UNSIGNED _INTEGER64

' ---------------------------------------------------------
' Notes
' ---------------------------------------------------------
' AnimDrawWindow stretches to the target box without keeping aspect ratio.
' AnimDraw draws in native size.
' AnimUpdate or AnimUpdateAll must be called from the main loop.
' AnimSaveFrame(animId, frameIndex) creates a default PNG file name.
' AnimSaveFrameTo(animId, frameIndex, fileName) uses the explicit output name.
' AnimSeek/AnimSeekTime/AnimStepForward/AnimStepBackward are the first public seek API slice.

' Purpose: Move directly to a specific frame index.
' Parameters: animId = working value for animation id; frameIndex = index variable used to address the current item.
' Return value: the function result follows the success/failure or data-return convention used by this module.
' Declaration only: the executable body is implemented later in the matching .bm module.
  
' FUNCTION AnimSeek% (animId As Long, frameIndex As Long)
' Purpose: Move playback to the frame that matches the requested time position.
' Parameters: animId = working value for animation id; timeMs = time value measured in milliseconds.
' Return value: the function result follows the success/failure or data-return convention used by this module.
' Declaration only: the executable body is implemented later in the matching .bm module.

' FUNCTION AnimSeekTime% (animId As Long, timeMs As Double)
' Purpose: Move one frame forward without relying on normal playback timing.
' Parameters: animId = working value for animation id.
' Return value: the function result follows the success/failure or data-return convention used by this module.
' Declaration only: the executable body is implemented later in the matching .bm module.
 
' FUNCTION AnimStepForward% (animId As Long), AnimStepBackward% (animId As Long)
' Purpose: Move one frame backward without relying on normal playback timing.
' Parameters: animId = working value for animation id.
' Return value: the function result follows the success/failure or data-return convention used by this module.
' Declaration only: the executable body is implemented later in the matching .bm module.

