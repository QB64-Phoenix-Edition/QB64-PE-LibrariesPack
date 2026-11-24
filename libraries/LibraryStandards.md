Go back to the [Contributors](./Contributors.md) document.

---

# QB64(PE) Library coding standards
The library code should use **upper case keywords** and may consist of 3 general parts/files, the **AtTop**, the **AfterMain** and the **AtBottom** parts:
- **AtTop** usually called `libname.bi` which contains definitions like CONST, TYPE, DIM etc.
- **AfterMain** usually called `libname.bas` but only used if the library has GOSUB routines, ON ERROR handlers or global DATA blocks.
- **AtBottom** usually called `libname.bm` which contains the SUBs and FUNCTIONs of the library.
- Take a closer look to the `QB64-PE/SampleLib` and its examples to learn what must go in which part.

**Note:** Since **QB64-PE v4.4.0** it's possible to interleave main level code and SUB/FUNCTION definitions, so you may join the **AtBottom** file into the **AtTop** file now, if you want. However, **AfterMain** code (if used) such as GOSUB routines or ERROR handlers should remain in its own file, otherwise you must skip over it with a GOTO to avoid accidental execution.

## Recommended rules
- **Every library part/file must have the $INCLUDEONCE metacommand in it to avoid accidental multiple inclusions.**

- **A library shall never change or enforce global settings, instead a library must adapt to the settings the user chose to use in his program or make sure everything works with every setting. The library may not count on any defaults, once a library is shared publicly, it may be used by someone who has the options set completely backwards of what the library assumed was standard.**

- **According to the point above the following keywords must be avoided in library code, use the described workarounds instead:**
  - $CONSOLE(:ONLY), the library can check the [\_CONSOLE\_](https://qb64phoenix.com/qb64wiki/index.php/$IF#Description) pre-compiler flag to see if a console is available. If the library needs a console, but none is active, then the best the library can do is throwing a pre-compiler [$ERROR](https://qb64phoenix.com/qb64wiki/index.php/$ERROR) to inform the user to activate it. Under no circumstances the library should activate a console by itself.
  - $DYNAMIC/$STATIC, the library must use DIM for static arrays and use REDIM and ERASE to deal with dynamic arrays instead.
  - DEFINT, DEFLNG etc., variables must be declared with the "DIM var AS type" syntax or by using type suffixes instead.
  - OPTION \_EXPLICIT(ARRAY), the library must declare all variables and arrays it uses, so that it works without errors if the user activates it. Note that variables used in the **AfterMain** part (e.g. in a library defined error handler) must already be declared in the **AtTop** part. That way the variables are already known in the user's main code and so the user can't use the same names for his own variables.
  - OPTION BASE 0/1, the library must always hard index all arrays from lower to upper bound by using the (RE)DIM myArr(lb TO ub) syntax. This also counts for auto-growing arrays with just one element in the beginning, according to the desired lower bound use myArr(0 TO 0) or myArr(1 TO 1) for the initial element.

- **A Library should also directly use the available [compiler constants](https://qb64phoenix.com/qb64wiki/index.php/Constants) wherever possible, rather than defining its own CONSTs. This mainly concerns \_TRUE and \_FALSE, but generally everything what is already provided by the compiler can be used and isn't worth to get redefined.**

- **Especially global names such as CONST, TYPE, (RE)DIM SHARED arrays and variables as well as SUB/FUNCTION names should be self descriptive as much as possible, e.g. "TextToImage" is much easier to understand, remember, and use than just "TTI" or "T2I". Naturally names become longer and that makes them also more resistant against accidental name conflicts.**
  - We had lots of discussions over the years if names should also have a prefix like the authors initials or so, but after calculating some probabilities it turned out that using descriptive names **derived from the library's context or purpose** is protective enough against name conflicts. E.g. assuming a 10 chars long name of letters only it's a chance of 1:>5mil. for a random name conflict, if digits are used besides letters it's already 1:>21mil. and with adding dots and underscores too, it's 1:>10bil. for a 10 chars long name.
  - The real problem here is, that people tend to use the same words and phrases over and over and especially in programming some common words appear ever again such as "top, left, width, height", "print, input" and many others, so on such common words some extra care must be used.
  - Another possibility for more diversity could be to add a single letter as prefix, e.g. "cName" for CONSTs, "vName" for variables, "tName" for TYPEs, "pName" for SUB/FUNCTION parameters etc..
  - The reality is, there are too many uncertainties to be able to set a clear rule here, so the library should generally use **unique names** wherever possible, it may use prefixes on desire or not.
  - In the very end not all the burden can be put on the library author alone here, to make sure there will never be any name conflicts when using his library, finally the end user of a library will hopefully have his own brain and should be smart enough to do his own part to avoid name conflicts.

- **After talking that much about descriptive names, of course the library should also use them for labels, especially for DATA labels used in conjunction with RESTORE. Those labels are different from GOTO/GOSUB labels as they are visible in the whole program, even if they are defined locally inside a SUB/FUNCTION.**
  - DATA labels must be treated like DIM SHARED variables, it's possible in the main program to RESTORE to and read DATA defined locally in a SUB/FUNCTION and also every SUB/FUNCTION can read DATA defined in the main program or any other SUB/FUNCTION.
  - In short, to not run into RESTORE ambiguities, every DATA label must be unique over the whole program, doesn't matter where it is defined, just like DIM SHARED variables.
  - Here the best way to assure that is really to use a strong prefix in names like `libname_myDataLabel:` if the DATA is defined globally in the **AfterMain** library part, and using `subfuncname_myDataLabel:` if the DATA is in a SUB/FUNCTION in the **AtBottom** library part.

- **And the final one on names, all those simple single letter variables and common short terms like tmp$, res% etc. should only be used locally and temporary inside SUB/FUNCTION and maybe as element names inside TYPE. A library should never DIM SHARED X, Y, I, K, M, etc., but instead keeping them reserved as local variables. That way they should never interfere with anything else.**

- **Unless absolutely necessary, SUBs/FUNCTIONs should never pass values back via its parameters.**
  - Each SUB/FUNCTION which needs to modify any of the given parameters internally should move the affected parameters over into a temporary local variable and use that internally in place of the original passed parameter.
    - E.g. if SUB MathJunk(X,Y) is modifying X and/or Y internally, then the first line in the SUB should read as "myX = X: myY = Y" or similar and all further operations should only be done on myX/myY and never on the original X/Y. This practice prevents all instances of accidental value corruption.
  - Very important, if such pass backs are intended, then this **should be explicitly mentioned** in the respective function description. The user **must know** that the routine will pass back a result this way.
  - Remind the user that only variables of the exact same type as specified for the parameter can receive the pass back value and that giving a variable of another type, a literal or even an expression will prevent the pass back. Putting extra parenthesis around the parameter in the SUB/FUNCTION call to force a BYVAL parameter pass will also prevent the intended pass back.

- **SUBs/FUNCTIONs should always restore changed settings/modes before exit.**
  - If a routine needs a \_DISPLAY, it should check to see if the user had \_AUTODISPLAY on, and if so, restore it on exit.
  - \_DEST, \_SOURCE, \_BLEND, \_PRINTMODE, COLOR, visible screen, and lots more can be altered while in a routine, but unless that's the intended purpose of the routine, it must be reset.
  - Fair compromises can be made, e.g. a text output library could exclude \_PRINTMODE and COLOR from the set/reset list while a library dealing with lots of images could exclude \_DEST and \_SOURCE. However, if such exceptions exist, then once again this **should be explicitly mentioned** in the respective function description. The user **must know** it.

- **None of the library parts/files should leave the compiler in $CHECKING:OFF mode, there must be a matching $CHECKING:ON for each :OFF. If in doubt, then an additional $CHECKING:ON placed in the very last line of each library file is a good safety measure.**
  - This is of course only necessary when using $CHECKING:OFF sections in the library at all.

---

Go back to the [Contributors](./Contributors.md) document.
