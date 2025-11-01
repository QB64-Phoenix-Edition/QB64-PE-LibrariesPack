$USELIBRARY:'TerryRitchie/MenuLib'

DIM Menu%, myMenu$, newMenu$
myMenu$ = "&File,&Open...#CTRL+O,&Save#CTRL+S,-E&xit#CTRL+Q,*," +_
          "&Magic,&Add Menu...,&Rem Menu...,*,"
newMenu$ = "&Edit,Cu&t#CTRL+X,&Copy#CTRL+C,-&Paste#CTRL+V,*,"

SCREEN _NEWIMAGE(640, 480, 32)
CLS , _RGB32(50, 100, 200)
_SCREENMOVE _MIDDLE

SETMENUFONT _DIR$("FONTS") + "segoeui.ttf", 16, _FALSE
SETMENUTEXT -1
SETMENUUNDERSCORE 1
MAKEMENU myMenu$ + "!"
SETMENUSTATE 102, _FALSE 'Save OFF
SETMENUSTATE 202, _FALSE 'Rem Menu OFF

SHOWMENU
DO
    _LIMIT 25
    Menu% = CHECKMENU%(_TRUE)
    IF Menu% = 201 THEN 'Add Menu
        HIDEMENU
        MAKEMENU myMenu$ + newMenu$ + "!"
        SETMENUSTATE 102, _FALSE 'Save OFF
        SETMENUSTATE 201, _FALSE 'Add Menu OFF
        SETMENUSTATE 303, _FALSE 'Paste OFF
        SHOWMENU
    ELSEIF Menu% = 202 THEN 'Rem Menu
        HIDEMENU
        MAKEMENU myMenu$ + "!"
        SETMENUSTATE 102, _FALSE 'Save OFF
        SETMENUSTATE 202, _FALSE 'Rem Menu OFF
        SHOWMENU
    END IF
LOOP UNTIL Menu% = 103
HIDEMENU

SYSTEM

