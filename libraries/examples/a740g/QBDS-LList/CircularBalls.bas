OPTION _EXPLICIT

$IF VERSION < 4.3.0 THEN
    $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
$END IF

$USELIBRARY:'a740g/QBDS-LList'

CONST SCREEN_W& = 800
CONST SCREEN_H& = 600
CONST SCREEN_CX& = SCREEN_W \ 2
CONST SCREEN_CY& = SCREEN_H \ 2
CONST RING_RADIUS& = 220
CONST BALL_RADIUS& = 18
CONST ADVANCE_INTERVAL# = 0.25#

REDIM Balls(0) AS LList
DIM nextId AS LONG: nextId = 1
DIM curNode AS _UNSIGNED _OFFSET
REDIM Colors(0) AS _UNSIGNED LONG
DIM lastAdvance AS DOUBLE
DIM k AS LONG

_TITLE "Circular LList Demo"

RANDOMIZE TIMER

SCREEN _NEWIMAGE(SCREEN_W, SCREEN_H, 32)
_PRINTMODE _KEEPBACKGROUND

LList_Initialize Balls()
lastAdvance = TIMER

DO
    k = _KEYHIT

    SELECT CASE k
        CASE _KEY_UP, _KEY_RIGHT
            AddBall
        CASE _KEY_DOWN, _KEY_LEFT
            RemoveCurrent
    END SELECT

    AdvanceHighlight

    DrawScene

    _DISPLAY
    _LIMIT 60
LOOP UNTIL k = _KEY_ESC

LList_Free Balls()

SYSTEM

SUB AddBall
    SHARED nextId AS LONG
    SHARED Colors() AS _UNSIGNED LONG
    SHARED Balls() AS LList
    SHARED curNode AS _UNSIGNED _OFFSET

    IF UBOUND(Colors) < nextId THEN
        REDIM _PRESERVE Colors(0 TO nextId) AS _UNSIGNED LONG
    END IF

    LList_PushBackLong Balls(), nextId

    Colors(nextId) = _RGB32(80 + RND * 175, 80 + RND * 175, 80 + RND * 175)

    IF LList_GetCount(Balls()) = 1 THEN LList_MakeCircular Balls(), _TRUE ' we'll do this just once

    curNode = LList_GetBackNode(Balls())

    nextId = nextId + 1
END SUB

SUB RemoveCurrent
    SHARED Balls() AS LList
    SHARED curNode AS _UNSIGNED _OFFSET

    IF curNode = 0 _ORELSE LList_GetCount(Balls()) = 0 THEN EXIT SUB

    DIM nxt AS _UNSIGNED _OFFSET: nxt = LList_GetNextNode(Balls(), curNode)
    DIM prv AS _UNSIGNED _OFFSET: prv = LList_GetPreviousNode(Balls(), curNode)

    LList_RemoveNode Balls(), curNode

    IF LList_GetCount(Balls()) = 0 THEN
        curNode = 0
    ELSE
        IF nxt <> 0 THEN
            curNode = nxt
        ELSEIF prv <> 0 THEN
            curNode = prv
        ELSE
            curNode = LList_GetFrontNode(Balls())
        END IF
    END IF
END SUB

SUB AdvanceHighlight
    SHARED Balls() AS LList
    SHARED curNode AS _UNSIGNED _OFFSET
    SHARED lastAdvance AS DOUBLE

    IF LList_GetCount(Balls()) = 0 THEN EXIT SUB

    DIM T AS DOUBLE: T = TIMER(0.001)

    IF ABS(T - lastAdvance) >= ADVANCE_INTERVAL THEN
        curNode = LList_GetNextNode(Balls(), curNode)
        lastAdvance = T
    END IF
END SUB

SUB DrawBall (cx AS LONG, cy AS LONG, r AS LONG, borderCol AS _UNSIGNED LONG, fillCol AS _UNSIGNED LONG, isCurrent AS _BYTE)
    CIRCLE (cx, cy), r, borderCol
    PAINT (cx, cy), fillCol, borderCol
    IF isCurrent THEN
        CIRCLE (cx, cy), r + 3, _RGB32(255, 255, 255)
    END IF
END SUB

SUB DrawScene
    SHARED Colors() AS _UNSIGNED LONG
    SHARED Balls() AS LList
    SHARED curNode AS _UNSIGNED _OFFSET

    CLS

    DIM cnt AS LONG: cnt = LList_GetCount(Balls())

    _PRINTSTRING (20, 20), "Up: Add ball | Down: Remove current"
    _PRINTSTRING (20, 40), "Count:" + STR$(cnt)

    IF cnt = 0 THEN
        _PRINTSTRING (SCREEN_CX - 176, SCREEN_CY - 10), "Press the Up Arrow to add balls to the ring."
        _PRINTSTRING (SCREEN_CX - 184, SCREEN_CY + 14), "Use Down Arrow to remove the highlighted ball."
        EXIT SUB
    END IF

    DIM node AS _UNSIGNED _OFFSET: node = LList_GetFrontNode(Balls())
    DIM i AS LONG
    FOR i = 0 TO cnt - 1
        DIM theta AS DOUBLE: theta = (i / cnt) * _PI(2#)
        DIM bx AS LONG: bx = SCREEN_CX + RING_RADIUS * COS(theta)
        DIM by AS LONG: by = SCREEN_CY + 10 + RING_RADIUS * SIN(theta)

        DIM id AS LONG: id = LList_GetLong(Balls(), node)
        DIM col AS LONG: col = Colors(id)
        DIM isCur AS _BYTE: isCur = (node = curNode)

        DIM fillCol AS _UNSIGNED LONG
        IF isCur THEN
            fillCol = _RGB32(_RED32(col) + 40, _GREEN32(col) + 40, _BLUE32(col) + 40)
        ELSE
            fillCol = col
        END IF

        DrawBall bx, by, BALL_RADIUS, _RGB32(230, 230, 230), fillCol, isCur
        _PRINTSTRING (bx - 6, by - 5), LTRIM$(STR$(id&))

        node = LList_GetNextNode(Balls(), node)
    NEXT
END SUB

