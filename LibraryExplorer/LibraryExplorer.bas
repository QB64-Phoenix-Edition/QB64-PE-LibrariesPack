': This program uses
': InForm GUI engine for QB64-PE - v1.5.7
': Fellippe Heitor, (2016 - 2022) - @FellippeHeitor
': Samuel Gomes, (2023 - 2025) - @a740g
': https://github.com/a740g/InForm-PE
'-----------------------------------------------------------
$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$IF WIN THEN
    $EXEICON:'LibraryExplorer/icon/library.ico'
    $VERSIONINFO:CompanyName='QB64 Phoenix Edition'
    '--------------------------------------------------
    '$INCLUDE:'../libraries/ProductInfo.bas'
    '--------------------------------------------------
    $VERSIONINFO:FileDescription='The QB64-PE Library Explorer'
    $VERSIONINFO:FILEVERSION#=1,2,0,0
    $VERSIONINFO:Comments='The Library Explorer can be used to easily browse through the pack and get an idea what libraries are available.'
    $VERSIONINFO:InternalName='LibraryExplorer.bas'
    $VERSIONINFO:OriginalFilename='LibraryExplorer.exe'
    '--------------------------------------------------
    $VERSIONINFO:LegalCopyright='MIT License'
    $VERSIONINFO:LegalTrademarks=''
$ELSE
    $EMBED:'LibraryExplorer/icon/libsmall.png','titleIcon'
$END IF
$EMBED:'LibraryExplorer/font/PublicSans-Regular.ttf','reguFont'
$EMBED:'LibraryExplorer/font/PublicSans-Bold.ttf','boldFont'
$EMBED:'LibraryExplorer/InForm/avatar.png','defAvatar'

': Controls' IDs: ------------------------------------------------------------------
DIM SHARED LibraryExplorer AS LONG
DIM SHARED AuthorsListLB AS LONG
DIM SHARED AuthorsList AS LONG
DIM SHARED LibrariesListLB AS LONG
DIM SHARED LibrariesList AS LONG
DIM SHARED ShortDescLB AS LONG
DIM SHARED ShortDesc AS LONG
DIM SHARED FullNameLB AS LONG
DIM SHARED FullName AS LONG
DIM SHARED VersionLB AS LONG
DIM SHARED Version AS LONG
DIM SHARED LicenseLB AS LONG
DIM SHARED License AS LONG
DIM SHARED AuthorLB AS LONG
DIM SHARED Author AS LONG
DIM SHARED FullDocsLB AS LONG
DIM SHARED FullDocs AS LONG
DIM SHARED ShowDocs AS LONG
DIM SHARED IncludeLB AS LONG
DIM SHARED Include AS LONG
DIM SHARED CopyInc AS LONG
DIM SHARED Avatar AS LONG

': External modules: ---------------------------------------------------------------
$USELIBRARY:'FellippeHeitor/IniManager'
'$INCLUDE:'InForm/InForm.bi'
'$INCLUDE:'InForm/xp.uitheme'
'$INCLUDE:'LibraryExplorer.frm'

': Event procedures: ---------------------------------------------------------------
SUB __UI_BeforeInit

    IF _FILEEXISTS("qb64.exe") _ORELSE _FILEEXISTS("qb64") _ORELSE _FILEEXISTS("qb64pe.exe") _ORELSE _FILEEXISTS("qb64pe") THEN
        CHDIR "libraries"
    ELSE
        IF NOT _FILEEXISTS("descriptors/QB64-PE/SampleLib.ini") THEN
            _MESSAGEBOX "Library Explorer", "The Library Explorer executable must be placed inside the QB64-PE main folder or the libraries sub-folder!", "error"
            SYSTEM
        END IF
    END IF
    IF NOT _FILEEXISTS("PublicSans-Regular.ttf") THEN _WRITEFILE "PublicSans-Regular.ttf", _EMBEDDED$("reguFont")
    IF NOT _FILEEXISTS("PublicSans-Bold.ttf") THEN _WRITEFILE "PublicSans-Bold.ttf", _EMBEDDED$("boldFont")

END SUB

SUB __UI_OnLoad

    $IF WIN = 0 THEN
        titIco& = _LOADIMAGE(_EMBEDDED$("titleIcon"), 32, "memory")
        IF titIco& < -1 THEN _ICON titIco&: _FREEIMAGE titIco&
    $END IF

    pack$ = UCASE$(_READFILE$("ProductInfo.bas"))
    pack$ = MID$(pack$, INSTR(pack$, "PRODUCTVERSION#=") + 16)
    pack$ = LEFT$(pack$, _INSTRREV(pack$, _CHR_COMMA) - 1)
    FOR i& = 1 TO LEN(pack$)
        IF ASC(pack$, i&) = _ASC_COMMA THEN ASC(pack$, i&) = _ASC_FULLSTOP
    NEXT i&
    SetCaption LibraryExplorer, "The QB64-PE Library Explorer (Pack Version v" + pack$ + ")"

    ResetList AuthorsList
    ResetList LibrariesList
    REDIM ListArr$(0)
    Disk.File.List "descriptors", "", 2, ListArr$()
    FOR i& = 1 TO UBOUND(ListArr$)
        t$ = ListArr$(i&)
        IF LEFT$(t$, 1) <> "." THEN AddItem AuthorsList, LEFT$(t$, LEN(t$) - 1)
    NEXT i&
    Disk.File.List "descriptors/" + GetItem$(AuthorsList, 1), "*.ini", 1, ListArr$()
    FOR i& = 1 TO UBOUND(ListArr$)
        t$ = ListArr$(i&)
        IF LEFT$(t$, 1) <> "." THEN AddItem LibrariesList, LEFT$(t$, LEN(t$) - 4)
    NEXT i&
    ERASE ListArr$
    Control(AuthorsList).Value = 1
    Control(LibrariesList).Value = 1
    SetFocus AuthorsList

    IF _FILEEXISTS("PublicSans-Regular.ttf") THEN KILL "PublicSans-Regular.ttf"
    IF _FILEEXISTS("PublicSans-Bold.ttf") THEN KILL "PublicSans-Bold.ttf"
    SetFrameRate 25

END SUB

SUB __UI_BeforeUpdateDisplay
    'This event occurs at approximately 60 frames per second.
    'You can change the update frequency by calling SetFrameRate DesiredRate%

END SUB

SUB __UI_BeforeUnload
    'If you set __UI_UnloadSignal = False here you can
    'cancel the user's request to close.

END SUB

SUB __UI_Click (id AS LONG)
    SELECT CASE id
        CASE LibraryExplorer

        CASE AuthorsListLB

        CASE AuthorsList

        CASE LibrariesListLB

        CASE LibrariesList

        CASE ShortDescLB

        CASE ShortDesc

        CASE FullNameLB

        CASE FullName

        CASE VersionLB

        CASE Version

        CASE LicenseLB

        CASE License

        CASE AuthorLB

        CASE Author

        CASE FullDocsLB

        CASE FullDocs

        CASE ShowDocs
            usr$ = GetItem$(AuthorsList, Control(AuthorsList).Value)
            lib$ = GetItem$(LibrariesList, Control(LibrariesList).Value)
            cmd$ = _CWD$ + "documents/" + usr$ + "/" + lib$ + "/" + Text(FullDocs)
            $IF WIN THEN
                cmd$ = _CWD$ + "documents\" + usr$ + "\" + lib$ + "\" + Text(FullDocs)
                SHELL _HIDE _DONTWAIT _CHR_QUOTE + cmd$ + _CHR_QUOTE
            $ELSEIF MAC THEN
                SHELL _HIDE _DONTWAIT "open " + _CHR_APOSTROPHE + cmd$ + _CHR_APOSTROPHE
            $ELSE
                SHELL _HIDE _DONTWAIT "xdg-open " + _CHR_APOSTROPHE + cmd$ + _CHR_APOSTROPHE
            $END IF

        CASE IncludeLB

        CASE Include

        CASE CopyInc
            _CLIPBOARD$ = Text(Include) + _STR_NAT_EOL
            SetCaption CopyInc, "Copied"
            _DELAY 0.5
            SetCaption CopyInc, "Copy Line"

        CASE Avatar

    END SELECT
END SUB

SUB __UI_MouseEnter (id AS LONG)
    SELECT CASE id
        CASE LibraryExplorer

        CASE AuthorsListLB

        CASE AuthorsList

        CASE LibrariesListLB

        CASE LibrariesList

        CASE ShortDescLB

        CASE ShortDesc

        CASE FullNameLB

        CASE FullName

        CASE VersionLB

        CASE Version

        CASE LicenseLB

        CASE License

        CASE AuthorLB

        CASE Author

        CASE FullDocsLB

        CASE FullDocs

        CASE ShowDocs

        CASE IncludeLB

        CASE Include

        CASE CopyInc

        CASE Avatar

    END SELECT
END SUB

SUB __UI_MouseLeave (id AS LONG)
    SELECT CASE id
        CASE LibraryExplorer

        CASE AuthorsListLB

        CASE AuthorsList

        CASE LibrariesListLB

        CASE LibrariesList

        CASE ShortDescLB

        CASE ShortDesc

        CASE FullNameLB

        CASE FullName

        CASE VersionLB

        CASE Version

        CASE LicenseLB

        CASE License

        CASE AuthorLB

        CASE Author

        CASE FullDocsLB

        CASE FullDocs

        CASE ShowDocs

        CASE IncludeLB

        CASE Include

        CASE CopyInc

        CASE Avatar

    END SELECT
END SUB

SUB __UI_FocusIn (id AS LONG)
    SELECT CASE id
        CASE AuthorsList

        CASE LibrariesList

        CASE ShortDesc

        CASE FullName

        CASE Version

        CASE License

        CASE Author

        CASE FullDocs

        CASE ShowDocs

        CASE Include

        CASE CopyInc

    END SELECT
END SUB

SUB __UI_FocusOut (id AS LONG)
    'This event occurs right before a control loses focus.
    'To prevent a control from losing focus, set __UI_KeepFocus = True below.
    SELECT CASE id
        CASE AuthorsList

        CASE LibrariesList

        CASE ShortDesc

        CASE FullName

        CASE Version

        CASE License

        CASE Author

        CASE FullDocs

        CASE ShowDocs

        CASE Include

        CASE CopyInc

    END SELECT
END SUB

SUB __UI_MouseDown (id AS LONG)
    SELECT CASE id
        CASE LibraryExplorer

        CASE AuthorsListLB

        CASE AuthorsList

        CASE LibrariesListLB

        CASE LibrariesList

        CASE ShortDescLB

        CASE ShortDesc

        CASE FullNameLB

        CASE FullName

        CASE VersionLB

        CASE Version

        CASE LicenseLB

        CASE License

        CASE AuthorLB

        CASE Author

        CASE FullDocsLB

        CASE FullDocs

        CASE ShowDocs

        CASE IncludeLB

        CASE Include

        CASE CopyInc

        CASE Avatar

    END SELECT
END SUB

SUB __UI_MouseUp (id AS LONG)
    SELECT CASE id
        CASE LibraryExplorer

        CASE AuthorsListLB

        CASE AuthorsList

        CASE LibrariesListLB

        CASE LibrariesList

        CASE ShortDescLB

        CASE ShortDesc

        CASE FullNameLB

        CASE FullName

        CASE VersionLB

        CASE Version

        CASE LicenseLB

        CASE License

        CASE AuthorLB

        CASE Author

        CASE FullDocsLB

        CASE FullDocs

        CASE ShowDocs

        CASE IncludeLB

        CASE Include

        CASE CopyInc

        CASE Avatar

    END SELECT
END SUB

SUB __UI_KeyPress (id AS LONG)
    'When this event is fired, __UI_KeyHit will contain the code of the key hit.
    'You can change it and even cancel it by making it = 0
    SELECT CASE id
        CASE AuthorsList

        CASE LibrariesList

        CASE ShortDesc

        CASE FullName

        CASE Version

        CASE License

        CASE Author

        CASE FullDocs

        CASE ShowDocs

        CASE Include

        CASE CopyInc

    END SELECT
END SUB

SUB __UI_TextChanged (id AS LONG)
    SELECT CASE id
        CASE FullName

        CASE Version

        CASE License

        CASE Author

        CASE FullDocs

        CASE Include

    END SELECT
END SUB

SUB __UI_ValueChanged (id AS LONG)
    SELECT CASE id
        CASE AuthorsList
            STATIC protAuthor, lastAuthor

            IF Control(AuthorsList).Value = 0 THEN 'avoid item unselection when clicking into the void list space
                Control(AuthorsList).Value = lastAuthor
                EXIT SUB
            END IF
            lastAuthor = Control(AuthorsList).Value

            IF protAuthor THEN EXIT SUB 'protect action against stray events
            protAuthor = _TRUE

            ResetList LibrariesList
            REDIM ListArr$(0)
            Disk.File.List "descriptors/" + GetItem$(AuthorsList, Control(AuthorsList).Value), "*.ini", 1, ListArr$()
            FOR i& = 1 TO UBOUND(ListArr$)
                t$ = ListArr$(i&)
                IF LEFT$(t$, 1) <> "." THEN AddItem LibrariesList, LEFT$(t$, LEN(t$) - 4)
            NEXT i&
            ERASE ListArr$
            Control(LibrariesList).Value = 1
            __UI_ValueChanged LibrariesList

            protAuthor = _FALSE

        CASE LibrariesList
            STATIC protLibrary, lastLibrary

            IF Control(LibrariesList).Value = 0 THEN 'avoid item unselection when clicking into the void list space
                Control(LibrariesList).Value = lastLibrary
                EXIT SUB
            END IF
            lastLibrary = Control(LibrariesList).Value

            IF protLibrary THEN EXIT SUB 'protect action against stray events
            protLibrary = _TRUE

            usr$ = GetItem$(AuthorsList, Control(AuthorsList).Value)
            lib$ = GetItem$(LibrariesList, Control(LibrariesList).Value)
            ini$ = "descriptors/" + usr$ + "/" + lib$ + ".ini"
            Text(FullName) = Ini_ReadSetting$(ini$, "[LIBRARY DETAILS]", "FullName")
            Text(Version) = Ini_ReadSetting$(ini$, "[LIBRARY DETAILS]", "Version")
            Text(License) = Ini_ReadSetting$(ini$, "[LIBRARY DETAILS]", "License")
            Text(Author) = Ini_ReadSetting$(ini$, "[LIBRARY DETAILS]", "Author")
            doc$ = Ini_ReadSetting$(ini$, "[LIBRARY DETAILS]", "FullDocs")
            IF LEN(doc$) > 0 THEN
                Text(FullDocs) = doc$
                Control(ShowDocs).Disabled = False
            ELSE
                Text(FullDocs) = ""
                Control(ShowDocs).Disabled = True
            END IF
            Text(Include) = "$UseLibrary:'" + usr$ + "/" + lib$ + "'"
            LoadImage Control(Avatar), ""
            avt$ = Ini_ReadSetting$(ini$, "[LIBRARY DETAILS]", "Avatar")
            IF LEN(avt$) = 0 THEN
                IF NOT _FILEEXISTS("descriptors/" + usr$ + "/avatar.png") THEN
                    _WRITEFILE "descriptors/" + usr$ + "/avatar.png", _EMBEDDED$("defAvatar")
                END IF
                avt$ = "avatar.png"
            END IF
            LoadImage Control(Avatar), "descriptors/" + usr$ + "/" + avt$
            IF _FILEEXISTS("descriptors/" + usr$ + "/avatar.png") THEN KILL "descriptors/" + usr$ + "/avatar.png"
            ResetList ShortDesc
            txt$ = Ini_ReadSetting$(ini$, "[LIBRARY DETAILS]", "ShortDesc")
            IF LEN(txt$) > 0 THEN
                REDIM words$(0)
                ub& = ParseLine&(txt$, " ", "", words$(), 0)
                item$ = words$(0)
                FOR i& = 1 TO ub&
                    IF _UPRINTWIDTH(item$ + " " + words$(i&), 0, Control(ShortDesc).Font) <= 447 THEN
                        item$ = item$ + " " + words$(i&)
                    ELSE
                        AddItem ShortDesc, item$
                        item$ = words$(i&)
                    END IF
                NEXT i&
                AddItem ShortDesc, item$
                ERASE words$
            END IF

            protLibrary = _FALSE

        CASE ShortDesc
            Control(ShortDesc).Value = 0 'never select anything in this list

    END SELECT
END SUB

SUB __UI_FormResized

END SUB

': Custom 3rd party routines: ------------------------------------------------------
SUB Disk.File.List (SearchDir AS STRING, Extension AS STRING, Flag AS LONG, ReturnArray() AS STRING)
    'source: SMcNeill, https://qb64phoenix.com/forum/showthread.php?tid=3627&pid=33658#pid33658
    'flags are binary bits which represent the following
    'Note that a quick value of -1 will set all bits and return everything for us
    '1 -- file listing
    '2 -- directory listing
    '4 -- sorted (directory before file, like windows explorer does) -- implies 1 + 2 both are wanted.
    '8 -- return full path info
    DIM AS LONG FileCount, pass
    DIM AS STRING Search, File, Slash
    REDIM ReturnArray(1000) AS STRING
    IF SearchDir = "" THEN SearchDir = _CWD$: IF Extension = "" THEN Extension = "*"
    IF INSTR(_OS$, "WIN") THEN Slash = "\" ELSE Slash = "/"
    IF RIGHT$(SearchDir, 1) <> "/" _ANDALSO RIGHT$(SearchDir, 1) <> "\" THEN SearchDir = SearchDir + Slash
    Search = SearchDir + Extension
    IF Flag AND 4 THEN 'sorted so we get directory listings then files
        FOR pass = 1 TO 2 'two passes, first to get directory listings then files
            File = _FILES$(Search)
            DO WHILE LEN(File)
                IF ((pass = 1) _ANDALSO _DIREXISTS(SearchDir + File)) _ORELSE ((pass = 2) _ANDALSO _FILEEXISTS(SearchDir + File)) THEN
                    FileCount = FileCount + 1
                    IF FileCount > UBOUND(ReturnArray) THEN REDIM _PRESERVE ReturnArray(FileCount + 1000) AS STRING
                    IF Flag AND 8 THEN File = SearchDir + File 'we want the full path info
                    ReturnArray(FileCount) = File
                END IF
                File = _FILES$
            LOOP
        NEXT
    ELSE 'unsorted so files and directories are simply listed in alphabetical order
        File = _FILES$(Search) 'one single pass where we just grab all the info at once
        DO WHILE LEN(File)
            IF ((Flag AND 1) _ANDALSO _FILEEXISTS(SearchDir + File)) _ORELSE ((Flag AND 2) _ANDALSO _DIREXISTS(SearchDir + File)) THEN
                FileCount = FileCount + 1
                IF FileCount > UBOUND(ReturnArray) THEN REDIM _PRESERVE ReturnArray(FileCount + 1000) AS STRING
                IF Flag AND 8 THEN File = SearchDir + File 'we want the full path info
                ReturnArray(FileCount) = File
            END IF
            File = _FILES$
        LOOP
    END IF
    REDIM _PRESERVE ReturnArray(FileCount) AS STRING
END SUB

FUNCTION ParseLine& (inpLine$, sepChars$, quoChars$, outArray$(), minUB&)
    'source: RhoSigma, part of GuiTools, https://qb64phoenix.com/forum/showthread.php?tid=88&pid=311#pid311
    '--- so far return nothing ---
    ParseLine& = -1
    '--- init & check some runtime variables ---
    ilen& = LEN(inpLine$): icnt& = 1
    IF ilen& = 0 THEN EXIT FUNCTION
    slen% = LEN(sepChars$)
    IF slen% > 0 THEN s1% = ASC(sepChars$, 1)
    IF slen% > 1 THEN s2% = ASC(sepChars$, 2)
    IF slen% > 2 THEN s3% = ASC(sepChars$, 3)
    IF slen% > 3 THEN s4% = ASC(sepChars$, 4)
    IF slen% > 4 THEN s5% = ASC(sepChars$, 5)
    IF slen% > 5 THEN slen% = 5 'max. 5 chars, ignore the rest
    IF LEN(quoChars$) > 0 THEN q1% = ASC(quoChars$, 1): ELSE q1% = 34
    IF LEN(quoChars$) > 1 THEN q2% = ASC(quoChars$, 2): ELSE q2% = q1%
    oalb& = LBOUND(outArray$): oaub& = UBOUND(outArray$): ocnt& = oalb&
    '--- skip preceding separators ---
    plSkipSepas:
    flag% = 0
    WHILE icnt& <= ilen& AND NOT flag%
        ch% = ASC(inpLine$, icnt&)
        SELECT CASE slen%
            CASE 0: flag% = -1
            CASE 1: flag% = ch% <> s1%
            CASE 2: flag% = ch% <> s1% AND ch% <> s2%
            CASE 3: flag% = ch% <> s1% AND ch% <> s2% AND ch% <> s3%
            CASE 4: flag% = ch% <> s1% AND ch% <> s2% AND ch% <> s3% AND ch% <> s4%
            CASE 5: flag% = ch% <> s1% AND ch% <> s2% AND ch% <> s3% AND ch% <> s4% AND ch% <> s5%
        END SELECT
        icnt& = icnt& + 1
    WEND
    IF NOT flag% THEN 'nothing else? - then exit
        IF ocnt& > oalb& GOTO plEnd
        EXIT FUNCTION
    END IF
    '--- redim to clear array on 1st word/component ---
    IF ocnt& = oalb& THEN REDIM outArray$(oalb& TO oaub&)
    '--- expand array, if required ---
    plNextWord:
    IF ocnt& > oaub& THEN
        oaub& = oaub& + 10
        REDIM _PRESERVE outArray$(oalb& TO oaub&)
    END IF
    '--- get current word/component until next separator ---
    flag% = 0: nest% = 0: spos& = icnt& - 1
    WHILE icnt& <= ilen& AND NOT flag%
        IF ch% = q1% AND nest% = 0 THEN
            nest% = 1
        ELSEIF ch% = q1% AND nest% > 0 THEN
            nest% = nest% + 1
        ELSEIF ch% = q2% AND nest% > 0 THEN
            nest% = nest% - 1
        END IF
        ch% = ASC(inpLine$, icnt&)
        SELECT CASE slen%
            CASE 0: flag% = (nest% = 0 AND (ch% = q1%)) OR (nest% = 1 AND ch% = q2%)
            CASE 1: flag% = (nest% = 0 AND (ch% = s1% OR ch% = q1%)) OR (nest% = 1 AND ch% = q2%)
            CASE 2: flag% = (nest% = 0 AND (ch% = s1% OR ch% = s2% OR ch% = q1%)) OR (nest% = 1 AND ch% = q2%)
            CASE 3: flag% = (nest% = 0 AND (ch% = s1% OR ch% = s2% OR ch% = s3% OR ch% = q1%)) OR (nest% = 1 AND ch% = q2%)
            CASE 4: flag% = (nest% = 0 AND (ch% = s1% OR ch% = s2% OR ch% = s3% OR ch% = s4% OR ch% = q1%)) OR (nest% = 1 AND ch% = q2%)
            CASE 5: flag% = (nest% = 0 AND (ch% = s1% OR ch% = s2% OR ch% = s3% OR ch% = s4% OR ch% = s5% OR ch% = q1%)) OR (nest% = 1 AND ch% = q2%)
        END SELECT
        icnt& = icnt& + 1
    WEND
    epos& = icnt& - 1
    IF ASC(inpLine$, spos&) = q1% THEN spos& = spos& + 1
    outArray$(ocnt&) = MID$(inpLine$, spos&, epos& - spos&)
    ocnt& = ocnt& + 1
    '--- more words/components following? ---
    IF flag% AND ch% = q1% AND nest% = 0 GOTO plNextWord
    IF flag% GOTO plSkipSepas
    IF (ch% <> q1%) AND (ch% <> q2% OR nest% = 0) THEN outArray$(ocnt& - 1) = outArray$(ocnt& - 1) + CHR$(ch%)
    '--- final array size adjustment, then exit ---
    plEnd:
    IF ocnt& - 1 < minUB& THEN ocnt& = minUB& + 1
    REDIM _PRESERVE outArray$(oalb& TO (ocnt& - 1))
    ParseLine& = ocnt& - 1
END FUNCTION

'$INCLUDE:'InForm/InForm.ui'

