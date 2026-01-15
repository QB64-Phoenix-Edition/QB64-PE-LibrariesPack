$IF WIN THEN
    DECLARE LIBRARY 'function is already used by QB64 so "User32" is not required
        FUNCTION GetKeyState% (BYVAL vkey AS LONG)
        FUNCTION GetAsyncKeyState% (BYVAL vkey AS LONG)
    END DECLARE
$END IF
TYPE KeyboardInfo_Type
    Index AS LONG
    ASCII AS LONG
    Ctrl AS LONG
    Shift AS LONG
    Alt AS LONG
    AltGr AS LONG
    Repeat AS _FLOAT
    LastHit AS _FLOAT
    Down AS LONG
    AltShift AS LONG
    AltCtrl AS LONG
    AltAltGr AS LONG
    CtrlShift AS LONG
    CtrlAlt AS LONG
    CtrlAltGr AS LONG
    ShiftAltGr AS LONG
    CtrlAltShift AS LONG
END TYPE

DIM SHARED Keys(254) AS KeyboardInfo_Type
DIM SHARED AltGr(1) AS _UNSIGNED _BYTE

_CONTROLCHR OFF

