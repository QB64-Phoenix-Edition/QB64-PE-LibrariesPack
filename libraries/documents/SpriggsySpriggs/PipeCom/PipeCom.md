## Pipecom is a cross-platform library (Windows & POSIX (Mac & Linux)) for QB64 that allows capturing of stdout, stderr, and the exit code of a shelled process _without_ using any temp files.

### Basic usage:
```vb
Dim As String stdout, stderr
Dim As Long exit_code

'The following call returns the exit_code as function result and the
'stdout and stderr streams are stored (passed back) in the provided strings.
'Note this is an intended side effect on the provided function arguments,
'if you need to preserve the previous contents of stdout and stderr, then
'you must assign it to another string variable BEFORE the call.
exit_code = pipecom("dir", stdout, stderr)
```

### There are also "lite" wrappers provided for quick usage of pipecom:
```vb
'The following version of pipecom_lite returns stderr if it is not empty,
'i.e. if an error occurred, or stdout if all went well. This is probably
'the most useful version of pipecom, as it don't has argument side effects
'and directly returns the expected result, i.e. the error message in case
'of failure and the expected output on success.
anyStringVar$ = pipecom_lite("dir")

'The last version is for "fire & forget" calls, if you just need to call
'a command, but you're not interested in the result.
pipecom_lite "dir"
```
