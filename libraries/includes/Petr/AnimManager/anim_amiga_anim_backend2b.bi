' =========================================================
' Commented source copy for the Amiga ANIM backend.
' Explanatory comments were added in English without altering executable code.
' =========================================================
' AMIGA ANIM backend prepared for unified Anim... dispatcher
' Public names use AmgAnim... prefix.

$INCLUDEONCE

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

' Constant: AMG_ANIM_FMT_ANIM is a Amiga ANIM/IFF constant used while parsing classic chunked animation data.
CONST AMG_ANIM_FMT_ANIM = 1

' Constant: AMG_ANIM_LOOP_FILE_DEFAULT is a Amiga ANIM/IFF constant used while parsing classic chunked animation data.
CONST AMG_ANIM_LOOP_FILE_DEFAULT = -2
' Constant: AMG_ANIM_LOOP_FOREVER is a Amiga ANIM/IFF constant used while parsing classic chunked animation data.
CONST AMG_ANIM_LOOP_FOREVER = -1
' Constant: AMG_ANIM_LOOP_ONCE is a Amiga ANIM/IFF constant used while parsing classic chunked animation data.
CONST AMG_ANIM_LOOP_ONCE = 0
' Constant: AMG_ANIM_DEFAULT_FIRST_DELAY_TICKS is a Amiga ANIM/IFF constant used while parsing classic chunked animation data.
CONST AMG_ANIM_DEFAULT_FIRST_DELAY_TICKS = 12
' Constant: AMG_ANIM_SNAPSHOT_INTERVAL is a Amiga ANIM/IFF constant used while parsing classic chunked animation data.
CONST AMG_ANIM_SNAPSHOT_INTERVAL = 8

' Record layout: AmgAnimRGB8 groups related fields used by the Amiga ANIM backend.
' Keeping the data in one TYPE lets the module store one structured record per active object.
TYPE AmgAnimRGB8
    ' Field: r stores the color component or packed color helper used during image conversion.
    r AS _UNSIGNED _BYTE
    ' Field: g stores the color component or packed color helper used during image conversion.
    g AS _UNSIGNED _BYTE
    ' Field: b stores the color component or packed color helper used during image conversion.
    b AS _UNSIGNED _BYTE
END TYPE

' Record layout: AmgAnimIffChunkInfo groups related fields used by the Amiga ANIM backend.
' Keeping the data in one TYPE lets the module store one structured record per active object.
TYPE AmgAnimIffChunkInfo
    ' Field: id stores the working value for id.
    id AS STRING * 4
    ' Field: size stores the size value for the current block, buffer, or file.
    size AS _UNSIGNED LONG
    ' Field: dataOfs stores the buffer that holds raw, packed, or decoded byte data.
    dataOfs AS _UNSIGNED _INTEGER64
    ' Field: nextOfs stores the working value for next ofs.
    nextOfs AS _UNSIGNED _INTEGER64
END TYPE

' Record layout: AmgAnimIlbmInfo groups related fields used by the Amiga ANIM backend.
' Keeping the data in one TYPE lets the module store one structured record per active object.
TYPE AmgAnimIlbmInfo
    ' Field: w stores the working value for w.
    w AS LONG
    ' Field: h stores the working value for h.
    h AS LONG
    ' Field: x stores the horizontal pixel or coordinate index.
    x AS LONG
    ' Field: y stores the vertical pixel or coordinate index.
    y AS LONG
    ' Field: nPlanes stores the working value for n planes.
    nPlanes AS LONG
    ' Field: masking stores the working value for masking.
    masking AS LONG
    ' Field: compression stores the working value for compression.
    compression AS LONG
    ' Field: transparentColor stores the column index or color-related value.
    transparentColor AS LONG
    ' Field: xAspect stores the working value for x aspect.
    xAspect AS LONG
    ' Field: yAspect stores the working value for y aspect.
    yAspect AS LONG
    ' Field: pageWidth stores the width value used by this routine.
    pageWidth AS LONG
    ' Field: pageHeight stores the height value used by this routine.
    pageHeight AS LONG
    ' Field: rowBytes stores the row pointer, row buffer, or row index used for image processing.
    rowBytes AS LONG
    ' Field: planeSize stores the working value for plane size.
    planeSize AS LONG
    ' Field: hasBMHD stores the Boolean-like flag used by the current routine.
    hasBMHD AS LONG
END TYPE

' Record layout: AmgAnimAnhdInfo groups related fields used by the Amiga ANIM backend.
' Keeping the data in one TYPE lets the module store one structured record per active object.
TYPE AmgAnimAnhdInfo
    ' Field: operation stores the working value for operation.
    operation AS LONG
    ' Field: mask stores the working value for mask.
    mask AS LONG
    ' Field: w stores the working value for w.
    w AS LONG
    ' Field: h stores the working value for h.
    h AS LONG
    ' Field: x stores the horizontal pixel or coordinate index.
    x AS LONG
    ' Field: y stores the vertical pixel or coordinate index.
    y AS LONG
    ' Field: abstime stores the time-related value used by the current routine.
    abstime AS _UNSIGNED LONG
    ' Field: reltime stores the time-related value used by the current routine.
    reltime AS _UNSIGNED LONG
    ' Field: interleave stores the working value for interleave.
    interleave AS LONG
    ' Field: bits stores the working value for bits.
    bits AS _UNSIGNED LONG
    ' Field: valid stores the working value for valid.
    valid AS LONG
END TYPE

' Record layout: AmgAnimFrameInfo groups related fields used by the Amiga ANIM backend.
' Keeping the data in one TYPE lets the module store one structured record per active object.
TYPE AmgAnimFrameInfo
    ' Field: fileOfs stores the working value for file ofs.
    fileOfs AS _UNSIGNED _INTEGER64
    ' Field: formSize stores the working value for form size.
    formSize AS _UNSIGNED LONG

    ' Field: hasBMHD stores the Boolean-like flag used by the current routine.
    hasBMHD AS LONG
    ' Field: hasCMAP stores the Boolean-like flag used by the current routine.
    hasCMAP AS LONG
    ' Field: hasBODY stores the Boolean-like flag used by the current routine.
    hasBODY AS LONG
    ' Field: hasANHD stores the Boolean-like flag used by the current routine.
    hasANHD AS LONG
    ' Field: hasDLTA stores the Boolean-like flag used by the current routine.
    hasDLTA AS LONG

    ' Field: bmhdOfs stores the working value for bmhd ofs.
    bmhdOfs AS _UNSIGNED _INTEGER64
    ' Field: cmapOfs stores the working value for cmap ofs.
    cmapOfs AS _UNSIGNED _INTEGER64
    ' Field: cmapSize stores the working value for cmap size.
    cmapSize AS _UNSIGNED LONG
    ' Field: bodyOfs stores the working value for body ofs.
    bodyOfs AS _UNSIGNED _INTEGER64
    ' Field: bodySize stores the working value for body size.
    bodySize AS _UNSIGNED LONG
    ' Field: anhdOfs stores the working value for anhd ofs.
    anhdOfs AS _UNSIGNED _INTEGER64
    ' Field: dltaOfs stores the working value for dlta ofs.
    dltaOfs AS _UNSIGNED _INTEGER64
    ' Field: dltaSize stores the working value for dlta size.
    dltaSize AS _UNSIGNED LONG

    ' Field: opCode stores the working value for op code.
    opCode AS LONG
    ' Field: reltime stores the time-related value used by the current routine.
    reltime AS _UNSIGNED LONG
    ' Field: interleave stores the working value for interleave.
    interleave AS LONG
    ' Field: anhdBits stores the working value for anhd bits.
    anhdBits AS _UNSIGNED LONG
END TYPE

' Record layout: AmgAnimInfo groups related fields used by the Amiga ANIM backend.
' Keeping the data in one TYPE lets the module store one structured record per active object.
TYPE AmgAnimInfo
    ' Field: frameCount stores the total number of frames available for the current animation.
    frameCount AS LONG
    ' Field: w stores the working value for w.
    w AS LONG
    ' Field: h stores the working value for h.
    h AS LONG
    ' Field: nPlanes stores the working value for n planes.
    nPlanes AS LONG
    ' Field: rowBytes stores the row pointer, row buffer, or row index used for image processing.
    rowBytes AS LONG
    ' Field: planeSize stores the working value for plane size.
    planeSize AS LONG
    ' Field: compression stores the working value for compression.
    compression AS LONG
    ' Field: camg stores the working value for camg.
    camg AS _UNSIGNED LONG
    ' Field: isHAM stores the Boolean-like flag used by the current routine.
    isHAM AS LONG
    ' Field: firstFrameReady stores the working value for first frame ready.
    firstFrameReady AS LONG
END TYPE

' Record layout: AmgAnimSnapshotStore groups related fields used by the Amiga ANIM backend.
' Keeping the data in one TYPE lets the module store one structured record per active object.
TYPE AmgAnimSnapshotStore
    ' Field: Used stores the flag telling whether the current slot or record is in use.
    Used AS INTEGER
    ' Field: FrameIndex stores the index variable used to address the current item.
    FrameIndex AS LONG
    ' Field: ShownIsA stores the working value for shown is a.
    ShownIsA AS LONG
END TYPE

' Record layout: AmgAnimStore groups related fields used by the Amiga ANIM backend.
' Keeping the data in one TYPE lets the module store one structured record per active object.
TYPE AmgAnimStore
    ' Field: Used stores the flag telling whether the current slot or record is in use.
    Used AS INTEGER
    ' Field: WidthPx stores the decoded image width in pixels.
    WidthPx AS LONG
    ' Field: HeightPx stores the decoded image height in pixels.
    HeightPx AS LONG
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
    ' Field: NextTick stores the absolute timer target for the next frame advance.
    NextTick AS DOUBLE
    ' Field: RemainingDelay stores the time still left before the next frame should be shown.
    RemainingDelay AS DOUBLE
    ' Field: LastRawTimer stores the raw timer snapshot used to measure elapsed playback time.
    LastRawTimer AS DOUBLE
    ' Field: CanvasImage stores the QB64 image handle used to store or draw decoded pixels.
    CanvasImage AS LONG
    ' Field: RenderedFrame stores the working value for rendered frame.
    RenderedFrame AS LONG
    ' Field: FileDataStart stores the buffer that holds raw, packed, or decoded byte data.
    FileDataStart AS LONG
    ' Field: FileDataSize stores the buffer that holds raw, packed, or decoded byte data.
    FileDataSize AS LONG
    ' Field: NPlanes stores the working value for n planes.
    NPlanes AS LONG
    ' Field: RowBytes stores the row pointer, row buffer, or row index used for image processing.
    RowBytes AS LONG
    ' Field: PlaneSize stores the working value for plane size.
    PlaneSize AS LONG
    ' Field: Compression stores the working value for compression.
    Compression AS LONG
    ' Field: Camg stores the working value for camg.
    Camg AS _UNSIGNED LONG
    ' Field: IsHam stores the Boolean-like flag used by the current routine.
    IsHam AS LONG
    ' Field: PalCount stores the count used to size or iterate the current data set.
    PalCount AS LONG
    ' Field: PalStart stores the working value for pal start.
    PalStart AS LONG
    ' Field: WorkBaseStart stores the working value for work base start.
    WorkBaseStart AS LONG
    ' Field: WorkAStart stores the working value for work a start.
    WorkAStart AS LONG
    ' Field: WorkBStart stores the working value for work b start.
    WorkBStart AS LONG
    ' Field: ChunkyStart stores the working value for chunky start.
    ChunkyStart AS LONG
    ' Field: PixelsStart stores the working value for pixels start.
    PixelsStart AS LONG
    ' Field: DecodedFrame stores the working value for decoded frame.
    DecodedFrame AS LONG
    ' Field: ShownIsA stores the working value for shown is a.
    ShownIsA AS LONG
    ' Field: WorkReady stores the working value for work ready.
    WorkReady AS INTEGER
    ' Field: SnapshotMetaStart stores the working value for snapshot meta start.
    SnapshotMetaStart AS LONG
    ' Field: SnapshotCount stores the count used to size or iterate the current data set.
    SnapshotCount AS LONG
    ' Field: SnapshotInterval stores the working value for snapshot interval.
    SnapshotInterval AS LONG
    ' Field: SnapshotPlanarAStart stores the working value for snapshot planar a start.
    SnapshotPlanarAStart AS LONG
    ' Field: SnapshotPlanarBStart stores the working value for snapshot planar b start.
    SnapshotPlanarBStart AS LONG
    ' Field: SnapshotPaletteStart stores the palette storage or palette index used during indexed-color decoding.
    SnapshotPaletteStart AS LONG
END TYPE

' Shared dynamic array: AmgAnimItems is resized here to hold the dynamic table that stores one record per live object handled by this module.
REDIM SHARED AmgAnimItems(0) AS AmgAnimStore
' Shared dynamic array: AmgAnimFrames is resized here to hold the dynamic array that stores per-frame data or cached frame metadata.
REDIM SHARED AmgAnimFrames(0) AS AmgAnimFrameInfo
' Shared dynamic array: AmgAnimFileNames is resized here to hold the parallel array that remembers the source filename for each active entry.
REDIM SHARED AmgAnimFileNames(0) AS STRING
' Shared dynamic array: AmgAnimErrorTexts is resized here to hold the text storage for the last human-readable error message.
REDIM SHARED AmgAnimErrorTexts(0) AS STRING

' Shared dynamic array: AmgAnimCanvasMem is resized here to hold one cached _MEM handle per live canvas image.
REDIM SHARED AmgAnimCanvasMem(0) AS _MEM
' Shared variable: AmgAnimFrameCountUsed stores the total number of frames available for the current animation.
DIM SHARED AmgAnimFrameCountUsed AS LONG

' Shared dynamic array: AmgAnimSnapshotMeta is resized here to hold the working value for Amiga animation snapshot meta.
REDIM SHARED AmgAnimSnapshotMeta(0) AS AmgAnimSnapshotStore
' Shared variable: AmgAnimSnapshotMetaUsed stores the flag telling whether the current slot or record is in use.
DIM SHARED AmgAnimSnapshotMetaUsed AS LONG

' Shared dynamic array: amg_anim_buf is resized here to hold the buffer that holds raw, packed, or decoded byte data.
REDIM SHARED amg_anim_buf(0) AS _UNSIGNED _BYTE
' Shared variable: amg_anim_file_size stores the working value for Amiga animation file size.
DIM SHARED amg_anim_file_size AS _UNSIGNED LONG

' Shared dynamic array: amg_anim_data_pool is resized here to hold the buffer that holds raw, packed, or decoded byte data.
REDIM SHARED amg_anim_data_pool(0) AS _UNSIGNED _BYTE
' Shared variable: amg_anim_data_pool_used stores the flag telling whether the current slot or record is in use.
DIM SHARED amg_anim_data_pool_used AS LONG

' Shared dynamic array: amg_anim_planar_pool is resized here to hold the working value for Amiga animation planar pool.
REDIM SHARED amg_anim_planar_pool(0) AS _UNSIGNED _BYTE
' Shared variable: amg_anim_planar_pool_used stores the flag telling whether the current slot or record is in use.
DIM SHARED amg_anim_planar_pool_used AS LONG

' Shared dynamic array: amg_anim_chunky_pool is resized here to hold the working value for Amiga animation chunky pool.
REDIM SHARED amg_anim_chunky_pool(0) AS _UNSIGNED _BYTE
' Shared variable: amg_anim_chunky_pool_used stores the flag telling whether the current slot or record is in use.
DIM SHARED amg_anim_chunky_pool_used AS LONG

' Shared dynamic array: amg_anim_pixels_pool is resized here to hold the working value for Amiga animation pixels pool.
REDIM SHARED amg_anim_pixels_pool(0) AS _UNSIGNED LONG
' Shared variable: amg_anim_pixels_pool_used stores the flag telling whether the current slot or record is in use.
DIM SHARED amg_anim_pixels_pool_used AS LONG

' Shared dynamic array: amg_anim_palette_pool is resized here to hold the palette storage or palette index used during indexed-color decoding.
REDIM SHARED amg_anim_palette_pool(0) AS AmgAnimRGB8
' Shared variable: amg_anim_palette_pool_used stores the flag telling whether the current slot or record is in use.
DIM SHARED amg_anim_palette_pool_used AS LONG

' Shared dynamic array: amg_anim_scratch_planar_base is resized here to hold the working value for Amiga animation scratch planar base.
REDIM SHARED amg_anim_scratch_planar_base(0) AS _UNSIGNED _BYTE
' Shared dynamic array: amg_anim_scratch_planar_a is resized here to hold the working value for Amiga animation scratch planar a.
REDIM SHARED amg_anim_scratch_planar_a(0) AS _UNSIGNED _BYTE
' Shared dynamic array: amg_anim_scratch_planar_b is resized here to hold the working value for Amiga animation scratch planar b.
REDIM SHARED amg_anim_scratch_planar_b(0) AS _UNSIGNED _BYTE
' Shared dynamic array: amg_anim_scratch_chunky is resized here to hold the working value for Amiga animation scratch chunky.
REDIM SHARED amg_anim_scratch_chunky(0) AS _UNSIGNED _BYTE
' Shared dynamic array: amg_anim_scratch_pixels is resized here to hold the working value for Amiga animation scratch pixels.
REDIM SHARED amg_anim_scratch_pixels(0) AS _UNSIGNED LONG
' Shared dynamic array: amg_anim_scratch_pal is resized here to hold the working value for Amiga animation scratch pal.
REDIM SHARED amg_anim_scratch_pal(0) AS AmgAnimRGB8
' Shared variable: amg_anim_scratch_planar_size stores the working value for Amiga animation scratch planar size.
DIM SHARED amg_anim_scratch_planar_size AS LONG
' Shared variable: amg_anim_scratch_chunky_size stores the working value for Amiga animation scratch chunky size.
DIM SHARED amg_anim_scratch_chunky_size AS LONG
' Shared variable: amg_anim_scratch_pal_size stores the working value for Amiga animation scratch pal size.
DIM SHARED amg_anim_scratch_pal_size AS LONG
' Shared variable: amg_anim_scratch_pixels_size stores the working value for Amiga animation scratch pixels size.
DIM SHARED amg_anim_scratch_pixels_size AS LONG
' Shared dynamic array: amg_anim_plane_pack_lo stores packed 4-pixel contributions for planar-to-chunky rendering, low half.
REDIM SHARED amg_anim_plane_pack_lo(0) AS _UNSIGNED LONG
' Shared dynamic array: amg_anim_plane_pack_hi stores packed 4-pixel contributions for planar-to-chunky rendering, high half.
REDIM SHARED amg_anim_plane_pack_hi(0) AS _UNSIGNED LONG
' Shared variable: amg_anim_plane_pack_ready stores whether the planar render lookup tables were initialized.
DIM SHARED amg_anim_plane_pack_ready AS LONG

' Shared variable: amg_anim_active_mode stores the working value for Amiga animation active mode.
DIM SHARED amg_anim_active_mode AS LONG
' Shared variable: amg_anim_active_pool_ofs stores the working value for Amiga animation active pool ofs.
DIM SHARED amg_anim_active_pool_ofs AS LONG
' Shared variable: amg_anim_active_pool_size stores the working value for Amiga animation active pool size.
DIM SHARED amg_anim_active_pool_size AS LONG
' Shared variable: amg_anim_scratch_owner stores the working value for Amiga animation scratch owner.
DIM SHARED amg_anim_scratch_owner AS LONG
' Shared variable: amg_anim_scratch_owner_valid stores the working value for Amiga animation scratch owner valid.
DIM SHARED amg_anim_scratch_owner_valid AS LONG

