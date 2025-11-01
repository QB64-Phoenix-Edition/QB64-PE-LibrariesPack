'******************************************************************************
'*                                                                            *
'* QB64 Menu Routines by Terry Ritchie, V1.0 08/01/12                         *
'*           Revision by RhoSigma, Roland Heyder V1.0rev 10/27/25             *
'*                                                                            *
'* Revision history:                                                          *
'*                                                                            *
'* V1.0     - 08/01/12                                                        *
'*            Initial release                                                 *
'* V1.0rev  - 10/27/25                                                        *
'*            General Revision                                                *
'*             (fixed & reworked for inclusion to the QB64-PE Libraries Pack) *
'*                                                                            *
'* Email author at terry.ritchie@gmail.com with questions or concerns (bugs). *
'*                                                                            *
'* Written using QB64 V0.954 and released to public domain. No credit is      *
'* needed or expected for its use or modification.                            *
'*                                                                            *
'* Creates a Windows-like menu system to be used in QB64 programs.            *
'*                                                                            *
'******************************************************************************

$INCLUDEONCE

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

TYPE MENU
    idnum AS INTEGER '                ID number of meny entry
    text AS STRING * 64 '             main and submenu entries text
    ljustify AS STRING * 64 '         text on left side of submenu entry
    rjustify AS STRING * 64 '         text right justified on submenu entry
    x AS INTEGER '                    x location of main entry on menu bar image and submenu entry on submenu image
    y AS INTEGER '                    y location of submenu entry on submenu image (main entry always 0)
    width AS INTEGER '                width of main and submenu entries
    live AS INTEGER '                 _TRUE (-1) if submenu entry is selectable, _FALSE (0) otherwise
    hotkey AS LONG '                  hotkey that activates submenu entry
    altkey AS LONG '                  alt key combos for main and sub menus
    altkeycharacter AS INTEGER '      the ASCII character that follows an ALT key
    altkeyx AS INTEGER '              the x location of the ALT underscore
    altkeywidth AS INTEGER '          the width of the ALT underscore
    drawline AS INTEGER '             _TRUE (-1) if a seperator line is to be drawn above this entry, _FALSE (0) otherwise
    active AS LONG '                  image of active main and submenu entries
    highlight AS LONG '               image of highlighted main and submenu entries
    selected AS LONG '                image of selected main entry
    inactive AS LONG '                image of inactive submenu entry
    ihighlight AS LONG '              image of inactive highlighted submenu entry
    submenu AS LONG '                 image of main entry submenu
    undersubmenu AS LONG '            saved image under submenu image
END TYPE

TYPE MENUSETTINGS
    mainmenu AS INTEGER '             the current main menu field in use
    oldmainmenu AS INTEGER '          the previous main menu field in use
    menuactive AS INTEGER '           _TRUE (-1) if menu is currently active, _FALSE (0) otherwise
    submenuactive AS INTEGER '        _TRUE (-1) if submenu is currently active (showing), _FALSE (0) otherwise
    submenu AS INTEGER '              the current sub menu field in use
    oldsubmenu AS INTEGER '           the previous sub menu field in use
    width AS INTEGER '                the width of all the main menu entries combined in top bar
    height AS INTEGER '               the height of each menu entry
    font AS LONG '                    the font currently in use by the menu
    spacing AS INTEGER '              the space to the right and left of menu entries
    centered AS INTEGER '             the center location of menu text
    indent AS INTEGER '               the master indent value for the entire menu
    alttweak AS INTEGER '             the amount to raise or lower the ALT key underscore
    texttweak AS INTEGER '            the amount to raise or lower the text in main and sub menu entries
    subtweak AS INTEGER '             the amount to raise or lower the sub menus
    mmbar3D AS INTEGER '              _TRUE (-1) top menu bar in 3D, _FALSE (0) otherwise
    smbar3D AS INTEGER '              _TRUE (-1) sub menus in 3D, _FALSE (0) otherwise
    mm3D AS INTEGER '                 _TRUE (-1) main menu entries in 3D, _FALSE (0) otherwise
    sm3D AS INTEGER '                 _TRUE (-1) sub menu entries in 3D, _FALSE (0) otherwise
    shadow AS INTEGER '               pixel width/height of drop shadow, zero (0) for no shadow
    mmatext AS _UNSIGNED LONG '       main menu active (normal) text color
    mmhtext AS _UNSIGNED LONG '       main menu highlighted text color
    mmstext AS _UNSIGNED LONG '       main menu selected text color
    smatext AS _UNSIGNED LONG '       sub menu active (normal) text color
    smhtext AS _UNSIGNED LONG '       sub menu highlight text color
    smitext AS _UNSIGNED LONG '       sub menu inactive text color
    smihtext AS _UNSIGNED LONG '      sub menu inactive highlight text color
    mmabarbg AS _UNSIGNED LONG '      main menu bar background color
    mmhbarbg AS _UNSIGNED LONG '      main menu highlight bar background color
    mmsbarbg AS _UNSIGNED LONG '      main menu selected bar background color
    smabg AS _UNSIGNED LONG '         sub menu active background color
    smhbg AS _UNSIGNED LONG '         sub menu highlight background color
    smibg AS _UNSIGNED LONG '         sub menu inactive background color
    smihbg AS _UNSIGNED LONG '        sub menu inactive highlight background color
    called AS INTEGER '               keeps track of which custom subroutines called
    showing AS INTEGER '              _TRUE (-1) if MenuShow() called, _FALSE (0) otherwise or MenuHide() called
    undermenu AS LONG '               background image under top bar menu
    menubar AS LONG '                 the top menu bar
    menubarhighlight AS LONG '        temporary bar created when drawing menu (freed from memory)
    menubarselected AS LONG '         temporary bar created when drawing menu (freed from memory)
END TYPE

REDIM Menu(0 TO 1, 0 TO 1) AS MENU '  menu entry array
DIM Mset AS MENUSETTINGS '            global menu settings

