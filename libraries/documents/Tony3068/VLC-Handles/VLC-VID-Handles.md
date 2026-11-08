# VLC-HANDLES and VID-HANDLES Guide

Two more libraries that follow the same handle-based convention as the [SPV Video Library](../SPV-Handles/SPV-Handles.md):

| Library | What it is |
|---|---|
| `VLC-HANDLES` | Plays any standard video (MP4, MKV, AVI, WebM, MOV, streams) through libvlc 3.x. Commands are named `VLCOPEN`, `VLCPLAY`, `VLCVOL` and so on. |
| `VID-HANDLES` | A wrapper, `VIDOPEN` looks at the file and picks SPV or VLC; every other `VID...` command calls the right library. |

---

## 1. Quick start (wrapper)

```vb
$USELIBRARY:'Tony3068/VID-Handles'

DIM v AS LONG, T1 AS LONG

SCREEN _NEWIMAGE(1280, 720, 32)
T1 = _FREETIMER
ON TIMER(T1, VID_TICK_SECONDS) VIDTICK
TIMER(T1) ON

v = VIDOPEN("movie.mp4")          ' or "movie.spv", or a URL
IF v = 0 THEN PRINT VIDERROR$: END

VIDLOOP v
DO
    _PUTIMAGE , VIDIMAGE(v)
    _DISPLAY
    _LIMIT 120
LOOP UNTIL INKEY$ = CHR$(27)

VIDCLOSEALL
END
```

For the `VID-HANDLES` wrapper just put the single `$USELIBRARY` at the top. It automatically pulls in both libraries, `SPV-HANDLES` and `VLC-HANDLES`.

The two timer lines in the example above are only needed for SPV videos. They do no harm if you only ever play VLC videos. In alternative, if you only need one of the libraries, you may use either one as standalone library without the wrapper.

---

## 2. Command reference

The VLC library and the wrapper have the same commands as SPV, with the prefix changed. Handles are `LONG`; seconds and volume are `SINGLE`.

| QB64 sound | SPV | VLC | Wrapper |
|---|---|---|---|
| `_SNDOPEN(f$)` | `SPVOPEN(f$)` | `VLCOPEN(f$)` | `VIDOPEN(f$)` |
| `_SNDPLAY h&` | `SPVPLAY` | `VLCPLAY` | `VIDPLAY` |
| `_SNDLOOP h&` | `SPVLOOP` | `VLCLOOP` | `VIDLOOP` |
| `_SNDPAUSE h&` | `SPVPAUSE` | `VLCPAUSE` | `VIDPAUSE` |
| `_SNDSTOP h&` | `SPVSTOP` | `VLCSTOP` | `VIDSTOP` |
| `_SNDPLAYING(h&)` | `SPVPLAYING` | `VLCPLAYING` | `VIDPLAYING` |
| `_SNDPAUSED(h&)` | `SPVPAUSED` | `VLCPAUSED` | `VIDPAUSED` |
| `_SNDLEN(h&)` | `SPVLEN` | `VLCLEN` | `VIDLEN` |
| `_SNDGETPOS(h&)` | `SPVGETPOS` | `VLCGETPOS` | `VIDGETPOS` |
| `_SNDSETPOS h&, s!` | `SPVSETPOS` | `VLCSETPOS` | `VIDSETPOS` |
| `_SNDVOL h&, v!` | `SPVVOL` | `VLCVOL` | `VIDVOL` |
| `_SNDLIMIT h&, s!` | `SPVLIMIT` | `VLCLIMIT` | `VIDLIMIT` |
| `_SNDCLOSE h&` | `SPVCLOSE` | `VLCCLOSE` | `VIDCLOSE` |
| | `SPVCLOSEALL` | `VLCCLOSEALL` | `VIDCLOSEALL` |
| | `SPVIMAGE&` | `VLCIMAGE&` | `VIDIMAGE&` |
| | `SPVNEWFRAME%` | `VLCNEWFRAME%` | `VIDNEWFRAME%` |
| | `SPVWIDTH&` `SPVHEIGHT&` | `VLCWIDTH&` `VLCHEIGHT&` | `VIDWIDTH&` `VIDHEIGHT&` |
| | `SPVFPS#` | `VLCFPS#` | `VIDFPS#` |
| | `SPVFRAMES&` `SPVFRAME&` | `VLCFRAMES&` `VLCFRAME&` | `VIDFRAMES&` `VIDFRAME&` |
| | `SPVERROR$` | `VLCERROR$` | `VIDERROR$` |
| | `SPVHINT$` | `VLCHINT$` | `VIDHINT$` |
| | `SPVASPECT#` | `VLCASPECT#` | `VIDASPECT#` |
| | `SPVCROPX&` `SPVCROPW&` | `VLCCROPX&` `VLCCROPW&` | `VIDCROPX&` `VIDCROPW&` |
| | (draw it yourself) | (draw it yourself) | `VIDPUT h&, x1, y1, x2, y2` |
| | `SPVTICK` | `VLCTICK` (optional) | `VIDTICK` |

Wrapper extras: `VIDTYPE%(h&)` returns `VID_TYPE_SPV` (1) or `VID_TYPE_VLC` (2). The constant `VID_TICK_SECONDS` equals `SPV_TICK_SECONDS`.

Behavior matches the SPV guide: `VIDOPEN` leaves the video stopped on its first frame; `VIDPLAY`/`VIDLOOP` start it; `VIDSTOP` rewinds; `VIDPLAY` after `VIDLOOP` turns looping off; a limit combined with a loop restarts at the start. `VIDOPEN` returns 0 on failure and `VIDERROR$` says why.

---

## 3. How the wrapper chooses a library

`VIDOPEN` checks the file, in this order:

1. A name containing `://` (a URL) goes to VLC.
2. A file whose first four bytes are `SPRV` goes to SPV.
3. A name ending in `.SPV` goes to SPV even if the header check failed, so you get SPV's own error message ("Not an SPV video file").
4. Everything else goes to VLC.

The wrapper hands out its own handle numbers (1 to 24), so an SPV handle and a VLC handle never collide.

---

## 4. Differences from SPV you should know about

**No timer.** VLC decodes and plays audio on its own threads. Nothing has to run on `ON TIMER`, and nothing calls back into BASIC.

**Image updates happen when you ask.** `VLCIMAGE`, `VLCNEWFRAME`, `VLCPLAYING`, `VLCPAUSED` and `VLCGETPOS` each pull the newest frame into the image and check loop, limit and end-of-video rules. Any normal draw loop calls one of them every pass. If a loop never does, call `VLCTICK` from the loop (never from an `ON TIMER` handler).

**`VLCOPEN` waits briefly.** It starts VLC, waits for the first frame (normally well under a second; up to 10 seconds for a slow stream), parks on that frame, and returns. This is how it knows the width and height up front.

**Volume.** `VLCVOL` takes 0 to 1 like SPV, and also accepts up to 2 (200%).

**Looping.** `VLCLOOP` seeks back a moment before the end, so there is normally no gap. If VLC reaches the end first, the library restarts it, which can leave a short pause.

**Frames and FPS.** VLC does not give an exact frame count. `VLCFPS` uses VLC's value, or an estimate while playing. `VLCFRAMES` and `VLCFRAME` are length and position multiplied by that rate, so treat them as approximate.

**Image handle.** `VLCIMAGE` is a 32-bit image the library owns, never free it. It stays the same handle unless the video changes size mid-stream.

**Limits.** Up to 8 VLC videos at once.

---

## Aspect ratio and cropping (SPV hint byte)

SPV videos were made for the Commander X16, which scales the bitmap in hardware. The header `HINT` byte says what shape the picture should have when played, which is not always the shape of the bitmap:

| Hint | Playback aspect | Picture inside the bitmap |
|---|---|---|
| `N` | 4:3 | whole bitmap |
| `W` | 16:9 | whole bitmap |
| `T` | 9:16 | whole bitmap |
| `K` | 9:16 | only the middle 270 of a 320 wide bitmap (black bars either side) |
| other | bitmap width / height | whole bitmap |

`SPVWIDTH` and `SPVHEIGHT` still report the real bitmap size. The new commands tell you how to show it:

- `VIDASPECT#(h&)`: display aspect ratio (width / height) of the picture.
- `VIDCROPX&(h&)`, `VIDCROPW&(h&)`: where the picture sits inside `VIDIMAGE` (top is 0, height is `VIDHEIGHT`). For `K` this is x = 25, width = 270 on a 320 wide bitmap; for everything else it is the whole width.
- `VIDPUT h&, x1, y1, x2, y2`: does the whole job. It crops, scales to the correct aspect ratio, centers inside the box, and draws onto the current `_DEST`. Clear the box first if you want black bars.

```vb
CLS
VIDPUT v, 0, 0, _WIDTH - 1, _HEIGHT - 1
_DISPLAY
```

Use `VIDPUT` instead of `_PUTIMAGE , VIDIMAGE(v)`. Standard (VLC) videos are drawn at their own width/height ratio, so one draw call works for both kinds. SPV bitmap videos are scaled crisp; MJPG and VLC videos are scaled smooth.

`K` assumes the 270 wide picture is centered. The two numbers are constants (`SPV_K_BMP_W`, `SPV_K_SIG_W`) at the top of `SPV-ASPECT.BM`.

---

## 5. Requirements and build

No linker flags and no VLC SDK. libvlc is loaded at run time.

- Keep `qbvlc.h`, `VLC-HANDLES.BM`, `SPV-HANDLES.BM` and `VID-HANDLES.BM` in the same folder as your program.
- **Windows:** install VLC 3.x. Its bitness must match QB64-PE. The library finds an installed VLC automatically, or you can put `libvlc.dll`, `libvlccore.dll` and the `plugins` folder next to your `.exe`.
- **Linux:** the VLC runtime, for example `sudo apt install libvlc5 vlc-plugin-base`.
- VLC 4.x is not supported.
- Keep file paths plain ASCII (VLC expects UTF-8).

---

## 6. Rules to remember

1. Start the timer before you play an SPV video. VLC videos do not need it.
2. Pass `LONG` handles and `SINGLE` seconds/volume.
3. Never `_FREEIMAGE` an image returned by `VIDIMAGE`.
4. Don't use a handle after closing it.
5. Call `VIDCLOSEALL` before `END`. For VLC this also shuts libvlc down cleanly.
6. Don't call library commands from inside your own `ON TIMER` handler.

---

## 7. Troubleshooting

**`libvlc could not be loaded`.** VLC is not installed, or its bitness differs from QB64-PE.

**`Timed out waiting for the first video frame`.** The file has no video, or the network stream was too slow.

**Looping or limits not working.** Make sure your loop calls `VIDIMAGE`, `VIDNEWFRAME` or `VIDPLAYING` every pass.

**Audio from an SPV video breaks up.** That is the SPV timer; see `SPVHANDLES.MD`.
