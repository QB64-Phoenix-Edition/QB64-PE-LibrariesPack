'INI Manager v2.0
'Fellippe Heitor, 2017-2026 - @fellippeheitor

$INCLUDEONCE

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

