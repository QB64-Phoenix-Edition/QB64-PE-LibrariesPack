'$Include: 'Keyboard Library.bi'
Do
    k1 = _KeyHit: k = KeyHit
    If k <> 0 Then Print k,
    If k1 <> 0 Then Print k1,
    If k _OrElse k1 Then Print
    _Limit 30
Loop
'$Include: 'Keyboard Library.bm'

