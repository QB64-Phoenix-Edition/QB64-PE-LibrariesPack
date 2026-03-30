AnimManager for QB64PE
=====================

AnimManager is a unified animation library for QB64PE.

Supported formats:
- FLI
- FLC
- APNG (PNG)
- GIF89a
- WebP (animated WebP, requires separately compiled runtime library)

Repository contents
-------------------
Main library files:
- anim_manager.bi
- anim_manager.bm

Backend files:
- anim_apng_backend.bi
- anim_apng_backend.bm
- anim_gif89a_backend.bi
- anim_gif89a_backend.bm
- anim_flic_backend_buffered.bi
- anim_flic_backend_buffered.bm
- anim_webp_backend.bi
- anim_webp_backend.bm

Documentation:
- AnimManager_API_Reference.txt

Examples:
- demo_01_single_manager.bas
- demo_01_single_manager_webp_noprobe.bas
- demo_02_two_side_by_side_manager.bas
- demo_03_three_panels_manager.bas
- demo_04_four_grid_manager.bas
- demo_05_overlay_manager.bas
- demo_06_stress_manager.bas
- demo_07_launcher_menu_manager.bas
- demo_08_benchmark_fps_manager.bas
- demo_09_png_background_overlay_manager.bas
- demo_10_fit_stretch_showcase_manager.bas
- demo_11_bouncing_windows_manager.bas
- demo_12_stage_layers_manager.bas
- demo_13_save_frame_manager.bas

Test/sample media files are also included in the repository.

Basic use
---------
Place the AnimManager files and backend files in your project folder and include the main manager module in your QB64PE project.

AnimManager uses the unified public API with the prefix:
- AnimOpen
- AnimStart
- AnimStop
- AnimUpdate
- AnimUpdateAll
- AnimDraw
- AnimDrawWindow
- AnimSaveFrame
- AnimSaveFrameTo
- AnimFree
- AnimFreeAll

Important runtime notes
-----------------------
- AnimDraw draws in native size.
- AnimDrawWindow stretches to the target rectangle without preserving aspect ratio.
- AnimUpdate or AnimUpdateAll must be called regularly from the main loop.
- The buffered FLI/FLC backend is multi-instance safe.
- Saving or reconstructing arbitrary frames is supported, but some formats/backends may be slower than a fully cached design.

WebP support
------------
WebP support is included, but the required dynamic runtime library is NOT bundled in this repository as a prebuilt binary.

To use animated WebP, you must compile the runtime library separately from the sources in:

https://github.com/QB64Petr/AnimManager/tree/main/DLL%20source

That folder contains the source code and build files for the WebP wrapper/runtime, including CMake-based build support.

After building, place the correct runtime library next to your compiled QB64PE program, or in a location where the operating system loader can find it.

Typical runtime names:
- Windows 32-bit: webpanim32.dll
- Windows 64-bit: webpanim64.dll
- Linux: libwebpanim.so

DLL source / build notes
------------------------
The folder "DLL source" contains the source tree for the WebP runtime wrapper.

See:
- DLL source/README.md
- DLL source/how compile DLL and INFO.txt

for build instructions and platform notes.

Typical usage example
---------------------
Example flow:

anim1 = AnimOpen("test.webp")
anim2 = AnimOpen("Animals.gif")
anim3 = AnimOpen("AUTOGDE.FLC")

AnimStart anim1
AnimStart anim2
AnimStart anim3

Do
    _Limit 240
    AnimUpdateAll
    AnimDraw 100, 100, anim1
    AnimDrawWindow 100, 100, 350, 440, anim2
Loop Until _KeyHit = 27

AnimFreeAll

Notes
-----
This repository contains the library source, examples, and the separate source tree for building the WebP runtime.

Prebuilt WebP DLL/SO binaries are intentionally not stored in the main source tree.
