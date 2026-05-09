' =========================================================
' Commented source copy for the FLIC/FLC backend.
' Explanatory comments were added in English without altering executable code.
' =========================================================
' FLIC / FLI / FLC multi-instance backend module for QB64PE
' Include-friendly: no demo code, no SCREEN, no END, no input loop.
' Public API prefix: Flic...

$INCLUDEONCE

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

' Design note:
' Each opened animation keeps its own decode state, palette, pixel buffer
' and frame index. Playback therefore advances frame-by-frame for every
' instance independently and does not rebuild from frame 0 on every draw.
' =========================================================

' =========================================================
' Constants
' =========================================================
' Constant: FRAME_MAGIC is a named constant for frame magic.
CONST FRAME_MAGIC& = 61946

' Constant: CHUNK_COLOR_256 is a named constant for chunk color 256.
CONST CHUNK_COLOR_256& = 4
' Constant: CHUNK_DELTA_FLC is a named constant for chunk delta FLC.
CONST CHUNK_DELTA_FLC& = 7
' Constant: CHUNK_COLOR_64 is a named constant for chunk color 64.
CONST CHUNK_COLOR_64& = 11
' Constant: CHUNK_DELTA_FLI is a named constant for chunk delta FLI.
CONST CHUNK_DELTA_FLI& = 12
' Constant: CHUNK_BLACK is a named constant for chunk black.
CONST CHUNK_BLACK& = 13
' Constant: CHUNK_BYTE_RUN is a named constant for chunk byte run.
CONST CHUNK_BYTE_RUN& = 15
' Constant: CHUNK_COPY is a named constant for chunk copy.
CONST CHUNK_COPY& = 16
' Constant: CHUNK_PSTAMP is a named constant for chunk pstamp.
CONST CHUNK_PSTAMP& = 18
' Constant: FRAME_HEADER_SIZE is a named constant for frame header size.
CONST FRAME_HEADER_SIZE& = 16

' Constant: DELTA_OPCODE_PACKET is a named constant for delta opcode packet.
CONST DELTA_OPCODE_PACKET& = 0
' Constant: DELTA_OPCODE_LASTPIXEL is a named constant for delta opcode lastpixel.
CONST DELTA_OPCODE_LASTPIXEL& = 32768
' Constant: DELTA_OPCODE_LINESKIP is a named constant for delta opcode lineskip.
CONST DELTA_OPCODE_LINESKIP& = 49152
' Constant: DELTA_OPCODE_MASK is a named constant for delta opcode mask.
CONST DELTA_OPCODE_MASK& = 49152
' Constant: DELTA_PACKET_MASK is a named constant for delta packet mask.
CONST DELTA_PACKET_MASK& = 16383

' Constant: FLI_MAGIC is a FLIC/FLC-specific constant used while parsing or decoding Autodesk animation data.
CONST FLI_MAGIC& = 44817
' Constant: FLC_MAGIC is a FLIC/FLC-specific constant used while parsing or decoding Autodesk animation data.
CONST FLC_MAGIC& = 44818

' Constant: ANIM_FORMAT_NONE is a ANI/RIFF constant used while parsing Windows animated cursor files.
CONST ANIM_FORMAT_NONE& = 0
' Constant: ANIM_FORMAT_FLI is a ANI/RIFF constant used while parsing Windows animated cursor files.
CONST ANIM_FORMAT_FLI& = 1
' Constant: ANIM_FORMAT_FLC is a ANI/RIFF constant used while parsing Windows animated cursor files.
CONST ANIM_FORMAT_FLC& = 2
' Constant: FLIC_SNAPSHOT_INTERVAL is a FLIC/FLC-specific constant used while parsing or decoding Autodesk animation data.
CONST FLIC_SNAPSHOT_INTERVAL& = 8

' =========================================================
' Types
' =========================================================
' Record layout: RGBColorType groups related fields used by the FLIC/FLC backend.
' Keeping the data in one TYPE lets the module store one structured record per active object.
TYPE RGBColorType
    ' Field: R stores the color component or packed color helper used during image conversion.
    R AS _UNSIGNED _BYTE
    ' Field: G stores the color component or packed color helper used during image conversion.
    G AS _UNSIGNED _BYTE
    ' Field: B stores the color component or packed color helper used during image conversion.
    B AS _UNSIGNED _BYTE
END TYPE

' Record layout: FLICHeaderType groups related fields used by the FLIC/FLC backend.
' Keeping the data in one TYPE lets the module store one structured record per active object.
TYPE FLICHeaderType
    ' Field: FileSize stores the working value for file size.
    FileSize AS _UNSIGNED LONG
    ' Field: Magic stores the working value for magic.
    Magic AS LONG
    ' Field: Frames stores the dynamic array that stores per-frame data or cached frame metadata.
    Frames AS LONG
    ' Field: Width stores the width value used by this routine.
    Width AS LONG
    ' Field: Height stores the height value used by this routine.
    Height AS LONG
    ' Field: Depth stores the working value for depth.
    Depth AS LONG
    ' Field: Flags stores the working value for flags.
    Flags AS LONG
    ' Field: SpeedMS stores the time value measured in milliseconds.
    SpeedMS AS _UNSIGNED LONG
    ' Field: OfFrame1 stores the working value for of frame 1.
    OfFrame1 AS _UNSIGNED LONG
    ' Field: OfFrame2 stores the working value for of frame 2.
    OfFrame2 AS _UNSIGNED LONG
END TYPE

' Record layout: FlicStore groups related fields used by the FLIC/FLC backend.
' Keeping the data in one TYPE lets the module store one structured record per active object.
TYPE FlicStore
    ' Field: Used stores the flag telling whether the current slot or record is in use.
    Used AS INTEGER
    ' Field: FormatType stores the working value for format type.
    FormatType AS LONG
    ' Field: WidthPx stores the decoded image width in pixels.
    WidthPx AS LONG
    ' Field: HeightPx stores the decoded image height in pixels.
    HeightPx AS LONG
    ' Field: FrameCount stores the total number of frames available for the current animation.
    FrameCount AS LONG
    ' Field: DefaultDelayMS stores the frame delay or timing value.
    DefaultDelayMS AS _UNSIGNED LONG
    ' Field: CurrentFrame stores the zero-based frame index currently selected for display or playback.
    CurrentFrame AS LONG
    ' Field: DecodedFrame stores the working value for decoded frame.
    DecodedFrame AS LONG
    ' Field: Playing stores the flag telling whether playback is currently running.
    Playing AS INTEGER
    ' Field: Paused stores the flag telling whether playback is temporarily paused.
    Paused AS INTEGER
    ' Field: Looping stores the working value for looping.
    Looping AS INTEGER
    ' Field: LastTick stores the working value for last tick.
    LastTick AS DOUBLE
    ' Field: NextTick stores the absolute timer target for the next frame advance.
    NextTick AS DOUBLE
    ' Field: RemainingDelay stores the time still left before the next frame should be shown.
    RemainingDelay AS DOUBLE
    ' Field: LastRawTimer stores the raw timer snapshot used to measure elapsed playback time.
    LastRawTimer AS DOUBLE
    ' Field: CanvasImage stores the QB64 image handle used to store or draw decoded pixels.
    CanvasImage AS LONG
    ' Field: ImageDirty stores the working value for image dirty.
    ImageDirty AS INTEGER
    ' Field: PaletteDirty stores the palette storage or palette index used during indexed-color decoding.
    PaletteDirty AS INTEGER
    ' Field: DirtyValid stores the working value for dirty valid.
    DirtyValid AS INTEGER
    ' Field: DirtyLeft stores the working value for dirty left.
    DirtyLeft AS LONG
    ' Field: DirtyTop stores the working value for dirty top.
    DirtyTop AS LONG
    ' Field: DirtyRight stores the working value for dirty right.
    DirtyRight AS LONG
    ' Field: DirtyBottom stores the working value for dirty bottom.
    DirtyBottom AS LONG
    ' Field: HeaderData stores the buffer that holds raw, packed, or decoded byte data.
    HeaderData AS FLICHeaderType
    ' Field: FileDataStart stores the buffer that holds raw, packed, or decoded byte data.
    FileDataStart AS LONG
    ' Field: FileDataSize stores the buffer that holds raw, packed, or decoded byte data.
    FileDataSize AS _INTEGER64
    ' Field: PixelStart stores the working value for pixel start.
    PixelStart AS LONG
    ' Field: PixelCount stores the count used to size or iterate the current data set.
    PixelCount AS LONG
    ' Field: FrameInfoStart stores the working value for frame info start.
    FrameInfoStart AS LONG
    ' Field: HasRingFrame stores the Boolean-like flag used by the current routine.
    HasRingFrame AS INTEGER
    ' Field: RingFrameOffset64 stores the working value for ring frame offset 64.
    RingFrameOffset64 AS _INTEGER64
    ' Field: RingFrameSize64 stores the working value for ring frame size 64.
    RingFrameSize64 AS _INTEGER64
    ' Field: SnapshotMetaStart stores the working value for snapshot meta start.
    SnapshotMetaStart AS LONG
    ' Field: SnapshotCount stores the count used to size or iterate the current data set.
    SnapshotCount AS LONG
    ' Field: SnapshotInterval stores the working value for snapshot interval.
    SnapshotInterval AS LONG
END TYPE

' Record layout: FlicSnapshotStore groups related fields used by the FLIC/FLC backend.
' Keeping the data in one TYPE lets the module store one structured record per active object.
TYPE FlicSnapshotStore
    ' Field: Used stores the flag telling whether the current slot or record is in use.
    Used AS INTEGER
    ' Field: FrameIndex stores the index variable used to address the current item.
    FrameIndex AS LONG
    ' Field: PixelStart stores the working value for pixel start.
    PixelStart AS LONG
    ' Field: PaletteIndex stores the index variable used to address the current item.
    PaletteIndex AS LONG
END TYPE

' =========================================================
' Shared store for opened animations
' =========================================================
' Shared dynamic array: FlicItems is resized here to hold the dynamic table that stores one record per live object handled by this module.
REDIM SHARED FlicItems(0) AS FlicStore
' Shared dynamic array: FlicFileNames is resized here to hold the parallel array that remembers the source filename for each active entry.
REDIM SHARED FlicFileNames(0) AS STRING
' Shared dynamic array: FlicErrorTexts is resized here to hold the text storage for the last human-readable error message.
REDIM SHARED FlicErrorTexts(0) AS STRING

' =========================================================
' Shared decoded state pools
' =========================================================
' Shared dynamic array: FlicPaletteData is resized here to hold the palette storage or palette index used during indexed-color decoding.
REDIM SHARED FlicPaletteData(0 TO 255, 0 TO 0) AS RGBColorType
' Shared dynamic array: FlicPalette32Data is resized here to hold the palette storage or palette index used during indexed-color decoding.
REDIM SHARED FlicPalette32Data(0 TO 255, 0 TO 0) AS _UNSIGNED LONG
' Shared dynamic array: FlicPixelData is resized here to hold the buffer that holds raw, packed, or decoded byte data.
REDIM SHARED FlicPixelData(0) AS _UNSIGNED _BYTE
' Shared dynamic array: FlicFrameOffsets64 is resized here to hold the working value for FLIC frame offsets 64.
REDIM SHARED FlicFrameOffsets64(0) AS _INTEGER64
' Shared dynamic array: FlicRow32Data is resized here to hold the buffer that holds raw, packed, or decoded byte data.
REDIM SHARED FlicRow32Data(0) AS _UNSIGNED LONG
' Shared dynamic array: FlicSnapshotMeta is resized here to hold the working value for FLIC snapshot meta.
REDIM SHARED FlicSnapshotMeta(0) AS FlicSnapshotStore
' Shared dynamic array: FlicSnapshotPixels is resized here to hold the working value for FLIC snapshot pixels.
REDIM SHARED FlicSnapshotPixels(0) AS _UNSIGNED _BYTE
' Shared dynamic array: FlicSnapshotPalette is resized here to hold the palette storage or palette index used during indexed-color decoding.
REDIM SHARED FlicSnapshotPalette(0 TO 255, 0 TO 0) AS RGBColorType

' =========================================================
' Shared file storage and frame decode view
' =========================================================
' Shared dynamic array: FlicFileData is resized here to hold the buffer that holds raw, packed, or decoded byte data.
REDIM SHARED FlicFileData(0) AS _UNSIGNED _BYTE
' Shared variable: FlicFileDataNext stores the buffer that holds raw, packed, or decoded byte data.
DIM SHARED FlicFileDataNext AS LONG
' Shared variable: FlicFileDataCapacity stores the buffer that holds raw, packed, or decoded byte data.
DIM SHARED FlicFileDataCapacity AS LONG
' Shared variable: FlicFrameViewStart stores the working value for FLIC frame view start.
DIM SHARED FlicFrameViewStart AS LONG
' Shared variable: FlicFrameViewPos stores the working value for FLIC frame view pos.
DIM SHARED FlicFrameViewPos AS LONG
' Shared variable: FlicFrameViewLimit stores the working value for FLIC frame view limit.
DIM SHARED FlicFrameViewLimit AS LONG
' Shared variable: FlicSlotCapacity stores the working value for FLIC slot capacity.
DIM SHARED FlicSlotCapacity AS LONG

' =========================================================
' Shared scratch buffers for file IO and fast clears
' =========================================================
' Shared dynamic array: FlicIoChunkData is resized here to hold the buffer that holds raw, packed, or decoded byte data.
REDIM SHARED FlicIoChunkData(0) AS _UNSIGNED _BYTE
' Shared dynamic array: FlicIoTailData is resized here to hold the buffer that holds raw, packed, or decoded byte data.
REDIM SHARED FlicIoTailData(0) AS _UNSIGNED _BYTE
' Shared dynamic array: FlicZeroFillData is resized here to hold the buffer that holds raw, packed, or decoded byte data.
REDIM SHARED FlicZeroFillData(0) AS _UNSIGNED _BYTE
' Shared variable: FlicIoChunkCapacity stores the working value for FLIC io chunk capacity.
DIM SHARED FlicIoChunkCapacity AS LONG
' Shared variable: FlicIoTailCapacity stores the working value for FLIC io tail capacity.
DIM SHARED FlicIoTailCapacity AS LONG
' Shared variable: FlicZeroFillCapacity stores the working value for FLIC zero fill capacity.
DIM SHARED FlicZeroFillCapacity AS LONG

' =========================================================
' Internal decode context selector for helper routines
' =========================================================
' Shared variable: FlicDecodeContextId stores the working value for FLIC decode context id.
DIM SHARED FlicDecodeContextId AS LONG
' Shared variable: FlicPixelDataNext stores the buffer that holds raw, packed, or decoded byte data.
DIM SHARED FlicPixelDataNext AS LONG
' Shared variable: FlicPixelDataCapacity stores the buffer that holds raw, packed, or decoded byte data.
DIM SHARED FlicPixelDataCapacity AS LONG
' Shared variable: FlicFrameOffsetsNext stores the working value for FLIC frame offsets next.
DIM SHARED FlicFrameOffsetsNext AS LONG
' Shared variable: FlicFrameOffsetsCapacity stores the working value for FLIC frame offsets capacity.
DIM SHARED FlicFrameOffsetsCapacity AS LONG
' Shared variable: FlicRow32Capacity stores the row pointer, row buffer, or row index used for image processing.
DIM SHARED FlicRow32Capacity AS LONG
' Shared variable: FlicSnapshotMetaNext stores the working value for FLIC snapshot meta next.
DIM SHARED FlicSnapshotMetaNext AS LONG
' Shared variable: FlicSnapshotMetaCapacity stores the working value for FLIC snapshot meta capacity.
DIM SHARED FlicSnapshotMetaCapacity AS LONG
' Shared variable: FlicSnapshotPixelsNext stores the working value for FLIC snapshot pixels next.
DIM SHARED FlicSnapshotPixelsNext AS LONG
' Shared variable: FlicSnapshotPixelsCapacity stores the working value for FLIC snapshot pixels capacity.
DIM SHARED FlicSnapshotPixelsCapacity AS LONG
' Shared variable: FlicSnapshotPaletteNext stores the palette storage or palette index used during indexed-color decoding.
DIM SHARED FlicSnapshotPaletteNext AS LONG
' Shared variable: FlicSnapshotPaletteCapacity stores the palette storage or palette index used during indexed-color decoding.
DIM SHARED FlicSnapshotPaletteCapacity AS LONG

