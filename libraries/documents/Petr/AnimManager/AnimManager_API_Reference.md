# Animation Manager Library – User Guide

This document focuses on the unified public API commands intended for normal use.

## How users should normally include this library

```vb
$UseLibrary:'Petr/AnimManager'

'--- your program ---
```

## Formats currently supported by the manager

The following formats are recognized and usable through the manager:
- PNG and APNG (A normal PNG is opened as a 1-frame animation.)
- GIF89a
- FLI
- FLC
- Amiga ANIM (FORM ... ANIM)
- Windows ANI (RIFF ... ACON)

## Recommended basic workflow

```vb
'--- include the library ---
$UseLibrary:'Petr/AnimManager'

'--- declare variables ---
Dim animId As Long
Dim quitFlag As Integer

'--- open playback screen ---
Screen _NewImage(1280, 720, 32)

'--- load anim, set desired properties and start ---
animId = AnimOpen("Animals.gif")
If animId >= 0 Then
    AnimSetLoop animId, ANIM_LOOP_FOREVER
    AnimStart animId
End If

'--- the main loop ---
Do
    If _KeyHit = 27 Then quitFlag = -1

    Cls
    AnimUpdate animId
    AnimDraw 100, 80, animId

    _Display
    _Limit 60
Loop Until quitFlag

'--- cleanup and quit ---
AnimFree animId
End
```

## Return value conventions

The library does not use exactly the same style everywhere, but in practice this is what you should expect:

- *AnimOpen...()* returns an ID >= 0 on success, otherwise -1.
- Logical functions such as *AnimValid()*, *AnimIsPlaying()* and *AnimIsCached()* usually return:
  - -1 = yes / true
  - 0 = no / false
- Action functions such as *AnimSeek()*, *AnimSaveFrame()* and *AnimSaveFrameTo()* usually return:
  - -1 = success
  - 0 = failure
- Size and state functions such as *AnimWidth()*, *AnimHeight()*, *AnimLen()* and *AnimGetPos()* return a numeric value. For an invalid ID they usually return 0 or -1 depending on the specific function.

## Public manager constants

### Format constants:
```vb
ANIM_FMT_NONE = 0
ANIM_FMT_APNG = 1
ANIM_FMT_GIF89A = 2
ANIM_FMT_FLI = 3
ANIM_FMT_FLC = 4
'reserved entry (= 5)
ANIM_FMT_AMIGA_ANIM = 6
ANIM_FMT_ANI = 7
```

### Loop modes:
```vb
ANIM_LOOP_FILE_DEFAULT = -2 'follow the format or file default behavior
ANIM_LOOP_FOREVER = -1 '    'loop forever
ANIM_LOOP_ONCE = 0 '        'play once and stop
```
**Note:** If you want consistent behavior across formats, then always set looping explicitly with *AnimSetLoop()*.

### Cache modes:
```vb
ANIM_CACHE_STREAM = 0 '    'playback from stream / decode during playback
ANIM_CACHE_PRELOAD_ALL = 1 'try to preload all frames
ANIM_CACHE_WINDOW = 2 '    'in the current manager implementation the active mode falls back to stream
ANIM_CACHE_AUTO = 3 '      'tries preloading when it makes sense and fits the current limits / budget
```

## Public unified Anim... API

### Opening and format detection:

Opens an animation and returns animId. On Linux systems make sure to provide the exact upper/lower case spelled filename to avoid errors.
```vb
FUNCTION AnimOpen& (fileName AS STRING)
```
```vb
animId = AnimOpen("APPLE.FLI")
If animId < 0 Then Print "Open failed"
```

Same as *AnimOpen()*, but checks limits before opening. If the file is larger or longer than your limit, opening fails.
```vb
FUNCTION AnimOpenLimit& (fileName AS STRING, maxWidth AS LONG, maxHeight AS LONG, maxFrames AS LONG)
```
```vb
animId = AnimOpenLimit("Animals.gif", 1920, 1080, 500)
```

Lightweight probe without keeping the file open long-term. Useful for menus, browsers and validation.
```vb
SUB AnimProbe (fileName AS STRING, ok AS INTEGER, formatId AS LONG, widthPx AS LONG, heightPx AS LONG, frameCount AS LONG)
```
```vb
Dim ok As Integer
Dim fmt As Long, w As Long, h As Long, cnt As Long

AnimProbe "Biker.png", ok, fmt, w, h, cnt
If ok Then
    Print "Format="; fmt; " size="; w; "x"; h; " frames="; cnt
End If
```

### Freeing resources:

Frees one animation and its cache.
```vb
SUB AnimFree (animId AS LONG)
```

Frees all animations opened by the manager.
```vb
SUB AnimFreeAll ()
```
**Note:** Calling *AnimFreeAll()* at program shutdown is the simplest option.

### Playback control:

Starts playback.
```vb
SUB AnimStart (animId AS LONG)
```

Stops playback.
```vb
SUB AnimStop (animId AS LONG)
```

Pauses without losing the current position.
```vb
SUB AnimPause (animId AS LONG)
```

Resumes after pause.
```vb
SUB AnimResume (animId AS LONG)
```

Sets the loop mode.
```vb
SUB AnimSetLoop (animId AS LONG, loopMode AS LONG)
```
```vb
AnimSetLoop animId, ANIM_LOOP_FOREVER
AnimStart animId
```

### Timing updates:

Updates timing for one animation.
```vb
SUB AnimUpdate (animId AS LONG)
```

Updates timing for all open animations.
```vb
SUB AnimUpdateAll ()
```
**Important:** Without *AnimUpdate()* or *AnimUpdateAll()*, playback will not advance by itself. Call it regularly in the main loop.

### Drawing:

Draws the current frame at native size.
```vb
SUB AnimDraw (x AS LONG, y AS LONG, animId AS LONG)
```

Draws the current frame into the given rectangle.
```vb
SUB AnimDrawWindow (x1 AS LONG, y1 AS LONG, x2 AS LONG, y2 AS LONG, animId AS LONG)
```
**Important:** *AnimDrawWindow()* does not preserve aspect ratio. It simply stretches into the box. If you want proper fit behavior, calculate it yourself.

### Metadata and state:

Returns the number of frames.
```vb
FUNCTION AnimLen& (animId AS LONG)
```

Returns the width in pixels.
```vb
FUNCTION AnimWidth& (animId AS LONG)
```

Returns the height in pixels.
```vb
FUNCTION AnimHeight& (animId AS LONG)
```

Returns the current frame index.
```vb
FUNCTION AnimGetPos& (animId AS LONG)
```

Returns -1 if the animation is currently playing.
```vb
FUNCTION AnimIsPlaying% (animId AS LONG)
```

Returns the format identifier ANIM_FMT_....
```vb
FUNCTION AnimFormat& (animId AS LONG)
```

Returns -1 if animId is valid.
```vb
FUNCTION AnimValid% (animId AS LONG)
```

Returns the last error text for the animation.
```vb
FUNCTION AnimError$ (animId AS LONG)
```
```vb
If AnimSeek(animId, 100) = 0 Then
    Print AnimError$(animId)
End If
```

### Direct seeking and stepping:

Jumps to a specific frame. The index is clamped to the range 0 .. frameCount - 1.
```vb
FUNCTION AnimSeek% (animId AS LONG, frameIndex AS LONG)
```

Jumps based on time in milliseconds. The manager calculates the matching frame.
```vb
FUNCTION AnimSeekTime% (animId AS LONG, timeMs AS DOUBLE)
```

Moves forward by one frame.
```vb
FUNCTION AnimStepForward% (animId AS LONG)
```

Moves backward by one frame.
```vb
FUNCTION AnimStepBackward% (animId AS LONG)
```
```vb
If _KeyDown(19712) Then dummy = AnimStepBackward(animId) ' left
If _KeyDown(19200) Then dummy = AnimStepForward(animId)  ' right
AnimDraw 100, 100, animId
```

### Saving a frame to disk:

Saves a frame using an automatically generated filename. The default name looks like this: originalName_frame_000123.png
```vb
FUNCTION AnimSaveFrame% (animId AS LONG, frameIndex AS LONG)
```

Saves a frame to the exact file name you specify.
```vb
FUNCTION AnimSaveFrameTo% (animId AS LONG, frameIndex AS LONG, fileName AS STRING)
```
```vb
dummy = AnimSaveFrameTo(animId, 10, "frame10.png")
```

### Cache control:

Sets the desired cache mode.
```vb
SUB AnimSetCacheMode (animId AS LONG, cacheMode AS LONG)
```

Returns the active cache mode.
```vb
FUNCTION AnimGetCacheMode& (animId AS LONG)
```

Sets the global cache budget in MB. Default is 256MB.
```vb
SUB AnimSetCacheBudgetMB (mb AS LONG)
```

Returns the global cache budget in MB.
```vb
FUNCTION AnimGetCacheBudgetMB& ()
```
If you want the smoothest playback and have enough RAM, then use:
```vb
AnimSetCacheBudgetMB 512
AnimSetCacheMode animId, ANIM_CACHE_PRELOAD_ALL
AnimStart animId
```

Returns -1 if `ANIM_CACHE_PRELOAD_ALL` is set and the animation is fully loaded after *AnimStart()*.
```vb
FUNCTION AnimIsCached% (animId AS LONG)
```

## What is internal and should not be called by normal users

The source contains some helper routines such as:
- *AnimTryActivateCache()*
- *AnimPreloadAll()*
- *AnimBackendCloneFrame()*

These are not public user commands. They are internal building blocks of the manager.

## Some common use case snippets

### Simple playback of one animation:

```vb
animId = AnimOpen("3Globes.anim")
If animId >= 0 Then
    AnimSetLoop animId, ANIM_LOOP_FOREVER
    AnimStart animId
End If

Do
    Cls
    AnimUpdate animId
    AnimDraw 50, 50, animId
    _Display
    _Limit 60
Loop Until _KeyHit = 27
```

### Multiple animations at once:

```vb
Dim a(1 To 3) As Long
a(1) = AnimOpen("APPLE.FLI")
a(2) = AnimOpen("Animals.gif")
a(3) = AnimOpen("Biker.png")

For i = 1 To 3
    If a(i) >= 0 Then
        AnimSetLoop a(i), ANIM_LOOP_FOREVER
        AnimStart a(i)
    End If
Next i

Do
    Cls
    AnimUpdateAll
    AnimDraw 20, 20, a(1)
    AnimDraw 300, 20, a(2)
    AnimDraw 600, 20, a(3)
    _Display
    _Limit 60
Loop Until _KeyHit = 27
```

### Manual frame-by-frame browsing:

```vb
AnimPause animId

If _KeyHit = 19200 Then dummy = AnimStepForward(animId)
If _KeyHit = 19712 Then dummy = AnimStepBackward(animId)

AnimDraw 100, 100, animId
```

### Exporting one frame:

```vb
If AnimSaveFrameTo(animId, 0, "preview.png") = 0 Then
    Print "Save failed: "; AnimError$(animId)
End If
```

