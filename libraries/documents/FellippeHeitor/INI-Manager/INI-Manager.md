# INI-Manager

Library for [QB64-PE](https://github.com/QB64-Phoenix-Edition/QB64pe) for reading from and writing to [INI](https://en.wikipedia.org/wiki/INI_file) configuration files.

## Getting started

```vb
OPTION _EXPLICIT 'optional

$USELIBRARY:'FellippeHeitor/INI-Manager'

WriteSetting "config.ini", "window", "width", "800"
PRINT ReadSetting$("config.ini", "window", "width")
```

* The library has its own internal `ON ERROR` handler which reports file errors (read-only file, missing folder, locked file...) through the `IniCODE` variable instead of stopping your program with a runtime error.
* Your own `ON ERROR` handler remains active in your program outside of the INI library code.

Check the sample programs (`INI-Demo1.bas` to `INI-Demo3.bas`) for more usage examples.

## .ini format

INI files store the settings a program needs. They work across platforms, are easy to maintain and can be read and edited by people.

```ini
; last modified 1 April 2001 by John Doe
[owner]
name="John Doe"
organization=Acme Widgets Inc. 'we may need to change this later

[database]
; use IP address in case network name resolution is not working
server=192.0.2.62
port=143 ; change responsibly, be careful with conflicts
file="payroll.dat"
```

* Sections are written as `[section name]`. Keys that come before the first section are **global** keys; use `""` as their section name.
* Keys are assigned with `key=value`. Spaces and tabs around keys and values are ignored. Section and key names are case-insensitive.
* Lines starting with `;` or `#` are comments. Inline comments start with `;`. BASIC-style comments with `'` are also accepted after values if you set `IniAllowBasicComments = -1`. Lines starting with `'` are always comments.
* Values can be put in quotation marks. Everything between the quotes is taken literally, including `;`, `'` and leading/trailing spaces. Write `""` for a quotation mark inside a quoted value: `title="Say ""hi"""`.
* You never need to add quotes yourself: `WriteSetting` adds them (and doubles inner quotes) whenever the value wouldn't read back exactly as written.
* Files with Windows (CRLF) or Unix (LF) line endings are both supported, and the file's own line endings are kept when it is changed. New files use the platform's line endings.

More info at <https://en.wikipedia.org/wiki/INI_file>

## Library methods

After every call, `IniCODE` holds a status code (see the table below), `IniINFO$` describes it, and `IniIsError%%` tells you whether it was an error. `IniLastSection$` and `IniLastKey$` hold the section (as `[name]`) and key of the last operation.

The file name only needs to be passed once: pass `""` in later calls to keep using the same file. Switching between several files is fine.

### Writing

```vb
WriteSetting file$, section$, key$, value$
```

Writes a new setting to a file, or updates an existing one. The file is created if it doesn't exist.

* `section$` = the section where `key$` goes, with or without brackets. `""` writes a global key.
* `key$` = the setting's name. Keys must be unique within a section, but the same key can exist in different sections.
* `value$` = the value to store. Numbers must be converted to strings first, for example with `STR$()` (leading/trailing spaces are removed). Values can't contain line breaks (error 25).

When an existing key is updated, its spelling, indentation and inline comment are kept. New keys are added after the last key of their section, and new sections are added at the end of the file.

### Reading

```vb
result$ = ReadSetting$(file$, section$, key$)
```

Returns the value of `key$` in `section$`. An empty result can mean an empty value (`IniCODE = 2`) or an error such as a missing key (`IniCODE = 3`), so check `IniCODE` when it matters.

#### Reading keys in sequence:

Leave `key$` empty to get the keys of `section$` one by one. With both `section$` and `key$` empty, you get every key in the file. Check `IniLastSection$` and `IniLastKey$` to see which key was returned. When there are no more keys, `ReadSetting$` returns `""` with `IniCODE = 10`, and the next call starts over.

```vb
DO
    value$ = ReadSetting$("config.ini", "", "")
    IF IniCODE = 10 OR IniIsError%% THEN EXIT DO
    PRINT IniLastSection$; " "; IniLastKey$; "="; value$
LOOP
```

#### Listing sections:

```vb
DO
    s$ = IniNextSection$("config.ini")
    IF IniCODE = 24 OR IniIsError%% THEN EXIT DO
    PRINT s$
LOOP
```

`IniNextSection$` returns sections as `[name]`. After the last one it returns `""` with `IniCODE = 24`, and the next call starts over.

```vb
IniResetIteration
```

If you leave a loop early, call `IniResetIteration` so the next loop starts from the beginning again.

### Deleting

```vb
IniDeleteSection file$, section$
```

Deletes a whole section. Comments right before the next section are kept, since they usually describe that section. With `section$ = ""`, deletes all global keys.

```vb
IniDeleteKey file$, section$, key$
```

Deletes a key from a section.

### Other methods

```vb
IniSortSection file$, section$
```

Sorts the keys of a section alphabetically (case-insensitive). Comments and blank lines stay where they are.

```vb
IniMoveKey file$, section$, key$, newSection$
```

Moves `key$` from `section$` to `newSection$`.

```vb
IniClose
```

Saves any pending changes and forgets the current file. The next call must pass a file name again.

```vb
IniCommit
```

Saves pending changes to disk. Only needed when `IniDisableAutoCommit` is set (see below).

```vb
IniSetForceReload state
```

With `state` true (-1), the file is read from disk again on every call, so changes made by other programs are picked up. By default, the file is read once and kept in memory.

```vb
result$ = IniINFO$
IF IniIsError%% THEN ...
```

`IniINFO$` describes the last status code. `IniIsError%%` returns -1 (true) if the last operation failed.

### Settings

You can set these variables directly, or use the matching sub (`state` is true (-1) or false (0)).

| Variable | Sub | Default | Effect |
| --- | --- | --- | --- |
| `IniDisableAutoCommit` | `IniSetAutoCommit state` | 0 (auto commit on) | When -1, changes are kept in memory until you call `IniCommit` or `IniClose`, or switch to another file. Useful for many changes in a row. |
| `IniAllowBasicComments` | `IniSetAllowBasicComments state` | 0 | When -1, `'` starts an inline comment after a value. |
| `IniForceReload` | `IniSetForceReload state` | 0 | When -1, the file is read from disk on every call. |
| `IniDisableAddQuotes` | `IniSetAddQuotes state` | 0 (add quotes on) | When -1, values with spaces are written without quotation marks (`path=C:\Program Files\x.bas`). Values that need quotes to read back correctly (with `;`, `'` or a leading `"`) still get them. |

Note that `IniSetAutoCommit` and `IniSetAddQuotes` take the opposite of the variable they set: `IniSetAutoCommit -1` sets `IniDisableAutoCommit = 0`.

## Status codes

| Code | Meaning |
| --- | --- |
| 0 | Operation successful |
| 1 | ERROR: File not found |
| 2 | Empty value |
| 3 | ERROR: Key not found |
| 4 | Key updated |
| 5 | Global key created |
| 7 | Key created in existing section |
| 8 | No changes applied (same value, or a key moved to its own section) |
| 9 | New section created; key created |
| 10 | No more keys |
| 11 | File created; new key added |
| 12 | ERROR: Invalid key (empty, contains `=`, or starts with `;` `#` `'` `[`) |
| 13 | Section deleted |
| 14 | ERROR: Section not found |
| 15 | ERROR: Invalid section (contains `[` or `]`) |
| 17 | ERROR: Empty file |
| 18 | ERROR: No file open |
| 19 | Key deleted |
| 20 | Key moved |
| 21 | ERROR: Invalid file name/path |
| 22 | Section sorted |
| 23 | No changes applied; section already sorted |
| 24 | No more sections |
| 25 | ERROR: Invalid value (line breaks are not allowed) |
| 26 | ERROR: Could not write file |
| 27 | ERROR: Could not read file |

<br>

---
---
---

# Changelog

## v2.0

The library was rewritten around a single line-by-line parser. The API is the same, but please check **Behavior changes** below.

### Fixed

- `IniClose` could empty a file you had only read, or overwrite it with the contents of another file.
- `IniClose` didn't actually close the file.
- The library kept files open between calls, so programs using fixed file numbers (`OPEN ... AS #1`) could crash with "File already open".
- `IniDeleteSection file$, ""` deleted the first characters of the file when there were no global keys.
- Values containing `;`, `'` or `"` didn't read back as written.
- Values containing line breaks could add new sections and keys to the file. They're now rejected (error 25).
- A comment containing `[` inside a section hid the keys that followed it.
- Keys indented with tabs, or with tabs around `=`, weren't found.
- `IniSortSection` was case-sensitive and put `a2` before `a`. It also crashed on empty sections.
- `IniMoveKey` deleted the key when moving it to its own section.
- Read-only files couldn't be read.
- A failed save could be reported as "New section created; existing key moved".
- Pending changes (`IniDisableAutoCommit`) were lost when switching to another file.
- The library changed the caller's `file$` variable in some cases.

### Added

- File errors are reported as error 26 (write) or 27 (read) instead of stopping the program.
- Files are saved through a temporary file, so a failed save never leaves a half-written file behind. Read-only files are never replaced.
- `IniIsError%%`, `IniResetIteration`.
- `IniSetAddQuotes`, `IniSetAllowBasicComments` and `IniSetAutoCommit`, plus the `IniDisableAddQuotes` setting, from the reduced version formerly bundled with QB64-PE, so both use the same files. With `IniDisableAddQuotes`, values with spaces are written without quotes, but values that need quotes to read back correctly still get them.
- Lines starting with `#` are comments.
- Inside quoted values, `""` stands for one quotation mark.
- Updating a key keeps its spelling, indentation and inline comment.
- Regression tests and a GitHub Actions workflow.

### Behavior changes

- `IniNextSection$` now works like sequential `ReadSetting$`: it returns one section per call, then `""` with `IniCODE = 24`. Before, the last section came together with code 24. Loops that print first and check the code afterwards will now print an extra empty line; check the code before using the result.
- Sequential reading picks up where it left off even after the file changes, and `IniResetIteration` starts it over.
- New global keys go after the existing global keys (before, they went to the top of the file).
- `IniSortSection` keeps comments and blank lines in place and sorts global keys when `section$` is `""`.
- Section names are trimmed inside the brackets, so `[ general ]` matches `general`.
- Keys may contain `[` and `]` (but not start with `[`).
- Internal variables were renamed with an `Ini` prefix; `LoadedFiles$`, `currentIniFileName$`, `currentIniFileLOF`, `IniSectionData$`, `IniPosition` and `IniNewFile$` no longer exist. `IniNextKey$` was removed.
