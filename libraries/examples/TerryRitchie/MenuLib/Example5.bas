$USELIBRARY:'TerryRitchie/MenuLib'

DIM Menu%, myMenu$
myMenu$ = "&File,&Open...#CTRL+O,&Save#CTRL+S,-E&xit#CTRL+Q,*," +_
          "&Help,&About...,*,!"

SCREEN _NEWIMAGE(640, 480, 32)
CLS , _RGB32(50, 100, 200)
_SCREENMOVE _MIDDLE

SETMENUFONT _DIR$("FONTS") + "segoeui.ttf", 16, _FALSE
SETMENUTEXT -1
MAKEMENU myMenu$
SETMENUSTATE 102, _FALSE

SHOWMENU
DO
    _LIMIT 25
    Menu% = CHECKMENU%(_TRUE)
LOOP UNTIL Menu% = 103
HIDEMENU

SYSTEM

