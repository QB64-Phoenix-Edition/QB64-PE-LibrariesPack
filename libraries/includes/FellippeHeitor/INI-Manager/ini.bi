'INI Manager v2.0
'Fellippe Heitor, 2017-2026 - @fellippeheitor

$INCLUDEONCE

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

'Public variables
DIM IniCODE
DIM IniLastSection$
DIM IniLastKey$
DIM IniDisableAutoCommit
DIM IniAllowBasicComments
DIM IniForceReload
DIM IniDisableAddQuotes

'Internal state
DIM IniCurrentFile$
DIM IniWholeFile$
DIM IniLF$
DIM IniLoaded%%
DIM IniDirty%%
DIM IniDocVersion&
DIM IniIterSig$, IniIterPos&, IniIterCount&, IniIterVersion&, IniIterSect$
DIM IniSectSig$, IniSectPos&, IniSectCount&, IniSectVersion&
DIM IniIOError&

