'=============================================================================
'  VLC-HANDLES.BI (providing CONSTs, TYPEs and DIMs for VLC video library)
'=============================================================================

$INCLUDEONCE

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

CONST VLC_MAX_VIDEOS = 8

CONST VLC_STOPPED = 0
CONST VLC_PLAYING = 1
CONST VLC_PAUSED = 2

DECLARE LIBRARY "qbvlc"
    FUNCTION qbvlc_probe& ()
    FUNCTION qbvlc_last_error& ()
    FUNCTION qbvlc_open& (path AS STRING, BYVAL w AS LONG, BYVAL h AS LONG)
    SUB qbvlc_close (BYVAL h AS LONG)
    SUB qbvlc_shutdown ()
    FUNCTION qbvlc_acquire%& (BYVAL h AS LONG)
    FUNCTION qbvlc_stage_w& (BYVAL h AS LONG)
    FUNCTION qbvlc_stage_h& (BYVAL h AS LONG)
    FUNCTION qbvlc_native_w& (BYVAL h AS LONG)
    FUNCTION qbvlc_native_h& (BYVAL h AS LONG)
    FUNCTION qbvlc_frames& (BYVAL h AS LONG)
    FUNCTION qbvlc_state& (BYVAL h AS LONG)
    SUB qbvlc_pause (BYVAL h AS LONG, BYVAL p AS LONG)
    SUB qbvlc_seek (BYVAL h AS LONG, BYVAL ms AS LONG)
    FUNCTION qbvlc_time& (BYVAL h AS LONG)
    FUNCTION qbvlc_length& (BYVAL h AS LONG)
    SUB qbvlc_set_volume (BYVAL h AS LONG, BYVAL v AS LONG)
    FUNCTION qbvlc_get_volume& (BYVAL h AS LONG)
    SUB qbvlc_mute (BYVAL h AS LONG, BYVAL m AS LONG)
    SUB qbvlc_restart (BYVAL h AS LONG)
    FUNCTION qbvlc_fps& (BYVAL h AS LONG)
END DECLARE

TYPE VLCH_SLOT
    InUse AS INTEGER
    Img AS LONG
    W AS LONG
    H AS LONG
    State AS INTEGER
    Finished AS INTEGER
    Looping AS INTEGER
    LimitSec AS SINGLE
    Volume AS SINGLE
    NewFrame AS INTEGER
    LoopT AS DOUBLE
END TYPE

DIM SHARED VLCX(1 TO VLC_MAX_VIDEOS) AS VLCH_SLOT
DIM SHARED VLC_BLANK AS VLCH_SLOT
DIM SHARED VLC_ERRMSG AS STRING

