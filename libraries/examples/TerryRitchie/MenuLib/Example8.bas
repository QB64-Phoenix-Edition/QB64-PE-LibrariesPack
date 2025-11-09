$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'TerryRitchie/MenuLib'

DIM Menu%, myMenu$
myMenu$ = "&File,&Open...#CTRL+O,&Save#CTRL+S,-E&xit#CTRL+Q,*," +_
          "&Help,&About...,*,!"

SCREEN _NEWIMAGE(640, 480, 32)
CLS , _RGB32(50, 100, 200)
_SCREENMOVE _MIDDLE

SETMENUFONT _DIR$("FONTS") + "lucon.ttf", 16, _FALSE
SETMENUHEIGHT 30
MAKEMENU myMenu$
SETMENUSTATE 102, _FALSE

SHOWMENU
DO
    _LIMIT 25
    Menu% = CHECKMENU%(_TRUE)
LOOP UNTIL Menu% = 103
HIDEMENU

SYSTEM

