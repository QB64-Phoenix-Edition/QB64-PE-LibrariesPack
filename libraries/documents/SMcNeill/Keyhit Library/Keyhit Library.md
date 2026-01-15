Keyhit library is a simple *Windows Only* library which works as a drop in replacement for the standard QB64PE _KEYHIT command.  Once added to a program, the usage is as simple as just using the **Keyhit** command in a program instead of the **_KeyHit** command which is used by all others.  



```QB64PE
'$Include: 'Keyboard Library.bi'
Do
 k1 = _KeyHit: k = KeyHit
 If k <> 0 Then Print k,
 If k1 <> 0 Then Print k1,
 If k _OrElse k1 Then Print
 _Limit 30
Loop

'$Include: 'Keyboard Library.bm'
```



Note that the usage is really just that simple for basic use with this library.

In the code above you can see where k1 is performing a standard `_KEYHIT` call, whereas k is performing the library `Keyhit` replacement.



The purpose of this replacement library is to swap out the QB64PE `_Keyhit` command which has several limitations due to glut (such as CTRL + any of the number keys failing to register as any keypress whatsoever), with a simple replacement which reads all keys and reports them faithfully for us.



Note again:  This is basically for Windows-Only, and no enhanced functionality will be gained by inserting this into Linux or Windows programs.  It won't break Linux or Windows programs, but will instead automatically simply resort to the standard `_Keyhit` command for behavior and key returns instead.


