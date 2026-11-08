'=============================================================================
'  VID-HANDLES.BI (providing CONSTs, TYPEs and DIMs for VID wrapper library)
'=============================================================================

$INCLUDEONCE

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'Tony3068/SPV-Handles'
$USELIBRARY:'Tony3068/VLC-Handles'

CONST VID_TYPE_SPV = 1
CONST VID_TYPE_VLC = 2
CONST VID_MAX_VIDEOS = SPV_MAX_VIDEOS + VLC_MAX_VIDEOS
CONST VID_TICK_SECONDS = SPV_TICK_SECONDS

TYPE VIDH_SLOT
    InUse AS INTEGER
    Lib AS INTEGER
    H AS LONG
END TYPE

TYPE VIDINFO
    Lib AS INTEGER
    VType AS INTEGER
    NumFrames AS LONG
    FrameW AS LONG
    FrameH AS LONG
    BPP AS INTEGER
    FPSByte AS INTEGER
    FPSEncoded AS DOUBLE
    FPSTrue AS DOUBLE
    Length AS DOUBLE
    Hint AS STRING * 1
    IsMJPG AS INTEGER
    IsSprite AS INTEGER
    IsVGA AS INTEGER
    IsPadded AS INTEGER
    Full24 AS INTEGER
    PalBits AS INTEGER
    FrameBufSize AS LONG
    PalBufSize AS LONG
    SprW AS LONG
    SprH AS LONG
    NumSprites AS LONG
    AudioSeparate AS INTEGER
    AudioFileSize AS _INTEGER64
    AudioFrameSize AS LONG
    Is16 AS INTEGER
    Channels AS INTEGER
    SampleRate AS LONG
    RateFromFPS AS INTEGER
    VeraRate AS INTEGER
END TYPE

DIM SHARED VIDX(1 TO VID_MAX_VIDEOS) AS VIDH_SLOT
DIM SHARED VID_ERRMSG AS STRING

