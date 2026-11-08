# SPV-HANDLES Developer's Guide

This library lets a QB64 program open and play SPV videos through handles, in the same style as `_SNDOPEN` and `_SNDPLAY`. You open a video and get a handle back, then pass that handle to play, pause, seek and close commands. Several videos can play at once. Supports MJPG (VTYPE 99) and the legacy sprite / bitmap / VGA / ModeX types.

The library is not compiler-native, so playback is driven by an `ON TIMER` handler that you start once in your main program.

See also the [VLC Video Library](../VLC-Handles/VLC-VID-Handles.md) and the VID wrapper for easy use of both libraries:

---

## 1. Quick start

```vb
USELIBRARY:'Tony3068/SPV-Handles'

DIM v AS LONG
DIM T1

SCREEN _NEWIMAGE(800, 600, 32)
T1 = _FREETIMER
ON TIMER(T1, SPV_TICK_SECONDS) SPVTICK
TIMER(T1) ON

v = SPVOPEN("movie.spv")
IF v = 0 THEN PRINT SPVERROR$: END

SPVLOOP v

DO
    _PUTIMAGE , SPVIMAGE(v)
    _DISPLAY
    _LIMIT 120
LOOP UNTIL INKEY$ = CHR$(27)

SPVCLOSEALL
END
```

Notes:

- Put the `$USELIBRARY` line at the top of your program, before any other code. The library runs a small piece of start-up code (it loads the default palettes), so it must be reached before you open a video.
- `SPV_TICK_SECONDS` is a constant defined by the library (0.01 seconds).
- The library never draws to the screen. You draw `SPVIMAGE(v)` yourself.

---

## 2. Command reference

Handles are `LONG`. Use `v&` or `DIM v AS LONG`. Handle numbers run from 1 to 16.

### Mapping to the QB64 sound commands

| QB64 sound | SPV | Notes |
|---|---|---|
| `h& = _SNDOPEN(file$)` | `h& = SPVOPEN(file$)` | Returns 0 on failure. |
| `_SNDPLAY h&` | `SPVPLAY h&` | |
| `_SNDLOOP h&` | `SPVLOOP h&` | |
| `_SNDPAUSE h&` | `SPVPAUSE h&` | |
| `_SNDSTOP h&` | `SPVSTOP h&` | Rewinds to the start. |
| `_SNDPLAYING(h&)` | `SPVPLAYING(h&)` | |
| `_SNDPAUSED(h&)` | `SPVPAUSED(h&)` | |
| `_SNDLEN(h&)` | `SPVLEN(h&)` | Seconds. |
| `_SNDGETPOS(h&)` | `SPVGETPOS(h&)` | Seconds. |
| `_SNDSETPOS h&, s!` | `SPVSETPOS h&, s!` | Seconds. |
| `_SNDVOL h&, v!` | `SPVVOL h&, v!` | 0 to 1. |
| `_SNDLIMIT h&, s!` | `SPVLIMIT h&, s!` | 0 means no limit. |
| `_SNDCLOSE h&` | `SPVCLOSE h&` | |

### Opening and closing

**`h& = SPVOPEN(file$)`**
Opens the video, reads the header, allocates its buffers and image, and primes the first frame. The video is left stopped, so call `SPVPLAY` or `SPVLOOP` to start it. Returns a handle from 1 to 16, or 0 if anything fails. After a failure, `SPVERROR$` holds the reason.

**`SPVCLOSE h&`**
Closes one video and frees its memory, audio stream, image and files. The handle can then be reused. Calling it on an invalid handle does nothing.

**`SPVCLOSEALL`**
Closes every open video. Call it before `END`.

**`SPVERROR$`**
Text of the most recent `SPVOPEN` failure. Empty if the last open succeeded.

### Transport

**`SPVPLAY h&`**
Starts playing from the current position, or resumes if paused. If the video had played to the end, it starts again from the beginning.

**`SPVLOOP h&`**
Same as `SPVPLAY`, but when the video reaches the end it restarts without a gap. Calling `SPVPLAY` later turns looping off again.

**`SPVPAUSE h&`**
Pauses playback and the audio. `SPVPLAY` or `SPVLOOP` resumes it.

**`SPVSTOP h&`**
Stops playback, discards queued audio and returns to frame 0. The image shows the first frame.

**`SPVSETPOS h&, secs!`**
Jumps to a time in seconds. Works while playing, paused or stopped, and keeps the current play state. Queued audio is flushed. For MJPG videos the first call builds a frame-offset table (a one-time scan of the file), so the first seek in a long video can pause briefly.

**`SPVLIMIT h&, secs!`**
Ends playback when the position reaches this time. `0` removes the limit. A limit combined with `SPVLOOP` loops the clip from the start to the limit.

**`SPVVOL h&, vol!`**
Sets the volume, 0 (silent) to 1 (full). Negative values are treated as 0. The setting survives seeks and stops.

### Status

| Function | Returns | Meaning |
|---|---|---|
| `SPVPLAYING(h&)` | integer | True while playing. |
| `SPVPAUSED(h&)` | integer | True while paused. |
| `SPVLEN#(h&)` | double | Length in seconds. |
| `SPVGETPOS#(h&)` | double | Position in seconds. |
| `SPVFRAMES&(h&)` | long | Total number of frames. |
| `SPVFRAME&(h&)` | long | Frame number currently on screen. |
| `SPVFPS#(h&)` | double | Actual frame rate, see section 4. |
| `SPVWIDTH&(h&)` | long | Frame width in pixels. |
| `SPVHEIGHT&(h&)` | long | Frame height in pixels. |

All of these return 0 for an invalid handle. When a video reaches its end without looping, `SPVPLAYING` becomes false once the last audio has finished.

### Video-only commands

**`SPVIMAGE&(h&)`**
The QB64 image handle holding the current frame. The library owns this image and updates it in place. **Never free it.** Draw it with `_PUTIMAGE`. The handle stays the same for the life of the video, so you can fetch it once.

For MJPG videos the image is 32-bit. For the older video types it is a 256-color image with its own palette. `_PUTIMAGE` handles both when drawing to a 32-bit screen.

**`SPVNEWFRAME%(h&)`**
Returns true once each time a new frame has been drawn into the image, then resets itself. Use it to skip redundant `_PUTIMAGE` work:

```vb
IF SPVNEWFRAME(v) THEN
    _PUTIMAGE , SPVIMAGE(v)
    _DISPLAY
END IF
```

---

## 3. Using more than one video

Each video has its own handle, image, buffers and audio stream, so videos play independently.

```vb
DIM a AS LONG, b AS LONG
a = SPVOPEN("intro.spv")
b = SPVOPEN("loop.spv")
SPVPLAY a
SPVLOOP b
SPVVOL b, 0.3

DO
    _PUTIMAGE (0, 0)-(399, 299), SPVIMAGE(a)
    _PUTIMAGE (400, 0)-(799, 299), SPVIMAGE(b)
    _DISPLAY
    _LIMIT 120
LOOP
```

The limit is 16 open videos, set by the constant `SPV_MAX_VIDEOS`.

---

## 4. How playback works

Understanding this helps you avoid stutters.

**The timer.** `SPVTICK` runs every 0.01 seconds. For each playing video it looks at how much audio is queued. When the queue drops below about 1.25 frames, it decodes the next frame and queues its audio. The audio queue sets the pace, as in `SPV-VIDS`, so video stays in step with sound.

**Frame rate.** The header FPS is rounded to a whole audio frame at your sound card's rate. `SPVFPS` returns the real value, and `SPVLEN` and `SPVGETPOS` are based on it, so they may differ slightly from the header FPS.

**Audio.** Audio is resampled to your sound device's rate with linear averaging and sent with `_SndRawBatch`.

**Re-entry protection.** The library keeps an internal lock. If the timer fires while one of your calls is in progress, it skips that tick instead of running inside it. The next tick catches up.

**Look-ahead.** The shared variable `SPV_LEAD_FRAMES` (default 1.25) sets how much audio is kept queued. Raise it to 2 or 3 if your program is busy and audio breaks up. The cost is a little more delay after a seek or pause.

**Why your main loop matters.** The timer can only run between statements in your program. A long blocking call (`INPUT`, a long `_DELAY`, a very slow drawing routine) can let the audio queue run empty and cause a gap.

---

## 5. Supported videos

| VTYPE | Format | Audio |
|---|---|---|
| 99 | MJPG (JPEG frames) | Embedded |
| 28, 86, 88 | Bitmap, padded (86 = VGA, 88 = Mode X) | Embedded |
| 8 | Bitmap with palette | Embedded |
| 3, 23 | Bitmap with palette | Separate `.SVA` file |
| 1, 2 | Sprite | Separate `.SVA` file |
| 6, 7 | Sprite | Embedded |

Any other VTYPE makes `SPVOPEN` return 0 with `Unsupported SPV video type`.

**File requirements**

- The first four bytes must be `SPRV`.
- Videos with separate audio need a file with the same name and the extension `.SVA` in the same folder.
- Videos without an embedded palette look for a `.PAL` file with the same name. If it is missing or the wrong size, a default palette is used.
- Only bitmap formats with 1, 2, 4 or 8 bits per pixel are supported (MJPG is not affected by this).

**MJPG file layout assumed by the library**

```
32-byte header
lead audio frame (always)
[ if AudFrmSize <= 2048: a second lead audio frame ]
then, repeated for each frame:
    "jp" + 4-byte LONG size + JPEG data
    audio frame
```

Frames with a bad `"jp"` marker or an impossible size are treated as missing, and the video stops cleanly rather than crashing.

---

## 6. Common patterns

**Play a video once and wait for it to finish**

```vb
SPVPLAY v
DO WHILE SPVPLAYING(v)
    _PUTIMAGE , SPVIMAGE(v)
    _DISPLAY
    _LIMIT 120
LOOP
```

**Play a section**

```vb
SPVSETPOS v, 12.5
SPVLIMIT v, 20
SPVPLAY v
```

**Pause and resume with the space bar**

```vb
IF k$ = " " THEN
    IF SPVPAUSED(v) THEN SPVPLAY v ELSE SPVPAUSE v
END IF
```

**Seek forward ten seconds**

```vb
SPVSETPOS v, SPVGETPOS(v) + 10
```

Note that `SPVSETPOS` needs a `SINGLE` argument. Assign the sum to a `SINGLE` variable first if the compiler reports a type mismatch.

**Progress bar**

```vb
pct! = SPVGETPOS(v) / SPVLEN(v)
LINE (10, 580)-(10 + pct! * 780, 590), _RGB32(255, 255, 255), BF
```

**Fit a video to the screen while keeping its shape**

```vb
sw = _WIDTH: sh = _HEIGHT
s! = sw / SPVWIDTH(v)
IF SPVHEIGHT(v) * s! > sh THEN s! = sh / SPVHEIGHT(v)
w = SPVWIDTH(v) * s!: h = SPVHEIGHT(v) * s!
_PUTIMAGE ((sw - w) \ 2, (sh - h) \ 2)-((sw + w) \ 2, (sh + h) \ 2), SPVIMAGE(v)
```

---

## 7. Rules to remember

1. Start the timer before you play anything.
2. Pass `LONG` handles and `SINGLE` seconds/volume.
3. Never `_FREEIMAGE` the image returned by `SPVIMAGE`. `SPVCLOSE` does it.
4. Don't use a handle after closing it. Closed handles are reused by later `SPVOPEN` calls.
5. Call `SPVCLOSEALL` before `END`.
6. Don't call library commands from inside your own `ON TIMER` handler.
7. Keep the main loop responsive.

---

## 8. Error messages from SPVOPEN

| Message | Cause |
|---|---|
| `File not found: ...` | The path is wrong. |
| `No free video handles (max 16)` | Close a video first. |
| `File too small to be an SPV video` | The file is shorter than a header. |
| `Not an SPV video file` | The first four bytes aren't `SPRV`. |
| `Unsupported SPV video type N` | VTYPE not in the table in section 5. |
| `Bad frame count or frame size in header` | `NumFrames`, `FrameWidth` or `FrameHeight` is 0. |
| `Unsupported bits per pixel N` | Bitmap videos only. |
| `Bad sprite size in header` | Sprite videos only. |
| `Missing audio file: ...` | A separate `.SVA` file wasn't found. |
| `Bad audio parameters in header` | Audio frame size or rate is 0. |
| `Audio frame too small` | Fewer than 2 audio samples per frame. |
| `Bad audio sample rate` | The audio rate can't be converted. |
| `Could not open an audio stream` | The sound device is unavailable. |
| `Internal header size mismatch` | A header type is not the expected size. |

---

## Troubleshooting

**`Bad frame count or frame size in header` on an MJPG file.**
Your standalone viewer sizes its window from the `HINT` byte (`N`, `W` or `T`), not from `FrameWidth` and `FrameHeight`. The library creates its image from `FrameWidth` and `FrameHeight`, so if your MJPG encoder leaves those fields at 0, the open will fail. The fix is either to have the encoder write the real size into those fields, or to derive the size from `HINT` in `SPV_SETUP`: N = 800x600, W = 800x450, T = 450x800. This is the first thing to check.

**Black or frozen image.**
Make sure the timer is on (`TIMER(1) ON`) and that you call `_PUTIMAGE , SPVIMAGE(v)` every loop, not just once.

**Audio crackles or has gaps.**
Remove blocking calls from the main loop, or raise `SPV_LEAD_FRAMES`.

**Video drifts from the sound.**
Frames are paced by the audio queue, so drift usually means the timer is being starved. Check for long blocking calls.

**Type mismatch compiling a call.**
`SPVSETPOS`, `SPVVOL` and `SPVLIMIT` take `SINGLE` values, and every command takes a `LONG` handle.

**Seeking an MJPG video pauses briefly the first time.**
That is the one-time frame-offset scan. Later seeks are instant.

**Colors wrong on an older video type.**
The older bitmap and sprite decoders were ported without testing. Report the VTYPE and BPP and compare against the same file in `SPV-VIDS`.

---

## Appendix: internals for maintainers

- All per-video state lives in the array `SPVX()` of `SPVH_SLOT`, indexed by handle. `SPV_BLANK` is an empty slot used to reset an entry.
- Per-video memory blocks (`SPV_A1`, `SPV_A2` for audio; `SPV_V1`, `SPV_V2` for video; `SPV_P1`, `SPV_P2` for palettes; `SPV_JIDX` for the MJPG offset table) are `_MEM` arrays indexed by handle.
- `SPV_PREPLAY` is the equivalent of `PREPLAY_CACHE_DATA`. It repositions, primes the two-deep buffers and draws a first frame.
- `SPV_STEP` is the per-tick equivalent of `NextAudioFrame` plus `NextVideoFrame`.
- `SPV_SEEK_TO` positions the file or files for a given frame. For MJPG it uses the offset table from `SPV_BUILD_JINDEX`.
- `SPV_LOCK` is a counter that blocks timer re-entry. Every public command increments it on entry and decrements it on exit.
- Everything internal begins with `SPV_`. Public names start with `SPV` and no underscore.
