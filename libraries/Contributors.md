## You wanna contribute to the Libraries Pack?
Perfect, as already said in the [ReadMe](README.md) document, dropping in more library files should be easy enough, once you understood the layout of the `libraries` folder. The much harder part is to make sure the library meets the requirements for inclusion into the Pack first, which is best done in your local QB64-PE installation.

1. Make sure you have installed the Libraries Pack from the [latest repository snapshot](https://github.com/QB64-Phoenix-Edition/QB64-PE-LibrariesPack/archive/refs/heads/main.zip).
2. **For the following steps #3, #4 and #6 make sure to use the very same upper/lower case spelling for `author` and `libraryname` in all places, that's very important for Linux.**
3. In your `libraries` folder make a new folder for the `author` inside each of the four sub-folders `descriptors`, `documents`, `examples` and `includes` if the author is not already in the list.
4. Inside the `author` folders make a new sub-folder for the `libraryname`, but only in `documents`, `examples` and `includes` this time.
5. Drop in your new library files: documentation, examples and includes.
6. Inside the `author` folder in the `descriptors` folder create a new INI file `libraryname.ini` and fill it with the respective data (see [Format Details](#the-library-descriptor-ini-format-is-easy-and-straight-forward) below).
7. If the author is a known forum member, then get his avatar picture and specify it in the INI file. If no personalized avatar is available, then leave the INI entry blank. In alternative you may also use the avatar entry to specify a dedicated logo of 100x100 pixels for a library. The images must be dropped into the `descriptors/author` folder too.
8. **Now make sure everything complies to the [Requirements List](#what-are-the-requirements-for-inclusion-of-a-library) detailed below.**
9. When done, then pack your entire `libraries` folder and post the archive in the [GitHub Discussion](https://qb64phoenix.com/forum/forumdisplay.php?fid=42) Forum. Any developer will then check and incorporate your work into the GitHub repository.

In alternative, if you're familiar with GitHub, then you may also publish your work into your private fork of our [QB64-PE Libraries Pack](https://github.com/QB64-Phoenix-Edition/QB64-PE-LibrariesPack) repository and make a **Pull Request** from there.

---
---
---

### The Library Descriptor INI format is easy and straight forward:
```ini
[LIBRARY DETAILS]
FullName="Full name/title of the library"
Version="1.0 (optional DD-MMM-YYYY date)"
License="license name (optional license link)"
ShortDesc="A short precise description of the library, its purpose etc. (max. 450-500 chars)."
FullDocs=full_documentation_filename
Author="User name, (optional real name) & optional other contributors"
Avatar=optional_author_forum_avatar_filename

[LIBRARY INCLUDES]
IncAtTop=library_BI_filename
IncAfterMain=library_BAS_filename
IncAtBottom=library_BM_filename
```
- all file names are to be given without quotes, even if the file name has spaces
- no path specification is required, as files are all in its defined known places
- **written upper/lower cases of all files and folders must match exactly because of Linux**
- not used/required file entries just remain blank, but should still exist

Go back to the [Base List](#you-wanna-contribute-to-the-libraries-pack) above.

---

### What are the requirements for inclusion of a library?
To avoid rejection of a library the following things are considered mandatory:
1. The author of the library must be known at least by its username (real name is optional) and also the license under which the library was released. A library should always be listed under the original author name, even if other people contributed to it or revised the library for inclusion into the Pack.
2. At least a rudimentary documentation must be provided, because nobody uses a library where he must diggin' into the code first to understand it's purpose and usage. See a740g's QBDS libraries for a good minimal documentation. For more complex libraries a more comprehensive documentation is of advantage, such as in RhoSigma's and TerryRitchi's libraries. The file format should be TXT, MD, PDF or HTML.
3. At least one example must be provided. All examples should use **upper case keywords** and must work without unexpected runtime error popups from all possible compile locations. That is, especially when they read/write files, then these files should be placed into the example's source folder. See `examples/QB64-PE/SampleLib/GetSrcFold.bas` for the unified code example to determine the folder regardless of the EXE location.
4. The library code itself should use **upper case keywords** as well and must follow the **[Library coding standards](#library-coding-standards)** outlined below. The library code may consist of 3 general parts/files, the **AtTop**, the **AfterMain** and the **AtBottom** parts, take a closer look to the `QB64-PE/SampleLib` and its examples to learn what must go in which part.<br>
**Note:** Since **QB64-PE v4.4.0** it's possible to interleave main level code and SUB/FUNCTION definitions, so you may join the **AtBottom** file into the **AtTop** file now, if you want. However, **AfterMain** code (if used) such as GOSUB routines or ERROR handlers should remain in its own file.
5. One of the library parts/files must contain the code below to enforce **QB64-PE v4.3.0 or up** for use in the Libraries Pack. It's best to place it in the first part/file included to give the error as soon as possible. Also every example should contain the same code right before the $USELIBRARY line.<br>
**Important:** If your library depends on the new code interleaving feature, then the code below must be adapted to check for **v4.4.0** instead.
    ```vb
    $IF VERSION < 4.3.0 THEN
        $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
    $END IF
    ```
6. After all requirements are met and everything works as expected, perform a final **but important** check. The new library can't have any name clashes with any of the other libraries already in the Pack. Load the `libraries/CheckAll.bas` program into the IDE and make sure syntax checking is active. Then add the new library into the list and you'll see if the IDE remains happy or starts throwing errors. If your code has platform or 32/64bits dependent code switched on/off by pre-compiler $IF..$ELSE..$ENDIF blocks, then make sure to perform the test on **all possible** platform/bits combinations. When done, then save the `CheckAll.bas` program with the new added library.
7. Congratulations, your work is now ready for incorporation into the offical Libraries Pack. Go back to the [Base List](#you-wanna-contribute-to-the-libraries-pack) and continue with step #9.

---

### Library coding standards
- **Every library part/file must have the $INCLUDEONCE metacommand in it to avoid accidental multiple inclusions.**

- **A library shall never change or enforce global settings, instead a library must adapt to the settings the user chose to use in his program or make sure everything works with either setting. The library may not count on any defaults, once a library is shared publicly, it may be used by someone who has the options set completely backwards of what the library assumed was standard. Some examples of what keywords should never appear in library code and how to easily work around:**
  - $CONSOLE(:ONLY), the library can check the \_CONSOLE\_ pre-compiler flag to see if a console is available. If the library needs a console, but none is active, then the best the library can do is throwing a pre-compiler $ERROR to inform the user to activate it. Under no circumstances the library should activate a console by itself.
  - $DYNAMIC/$STATIC, the library must always use REDIM and ERASE to deal with dynamic arrays instead.
  - DEFINT, DEFLNG etc., variables must be declared with the "DIM var AS type" syntax or by using type suffixes instead.
  - OPTION \_EXPLICIT(ARRAY), the library must always declare all variables and arrays. It won't hurt if it's not active, but avoids errors if the user activates it. Note that variables used in the **AfterMain** part (e.g. in a library defined error handler) must already be declared in the **AtTop** part. That way the variables are already known in the user's main code and so the user can't use the same names for his own code.
  - OPTION BASE 0/1, the library must simply hard index all arrays using the (RE)DIM myArr(lb TO ub) syntax.

- **A Library should also directly use the available [compiler constants](https://qb64phoenix.com/qb64wiki/index.php/Constants) wherever possible, rather than defining its own CONSTs. This mainly concerns \_TRUE and \_FALSE, but generally everything what is already provided by the compiler can be used and isn't worth to get redefined.**

- **Especially global names such as CONST, TYPE, (RE)DIM SHARED arrays and variables as well as SUB/FUNCTION names should be self descriptive as much as possible, e.g. "TextToImage" is much easier to understand, remember, and use than just "TTI" or "T2I". Naturally names become longer and that makes them also more resistant against accidental name conflicts.**
  - We had lots of discussions over the years if names should also have a prefix like the authors initials or so, but after calculating some probabilities it turned out that using descriptive names **derived from the context of the library's designated purpose** is protective enough against name conflicts. E.g. assuming a 10 chars long name of letters only it's a chance of 1:>5mil. for a name conflict, if digits are used besides letters it's already 1:>21mil. and with adding dots and underscores too, it's 1:>10bil. for a 10 chars long name.
  - The real problem here is, that people tend to use the same words and phrases over and over and especially in programming some common words appear ever again such as "top, left, width, height", "print, input" and many others, so on such common words some extra care must be used.
  - Another possibility for more diversity could be to add a single letter as prefix, e.g. "cName" for CONSTs, "vName" for variables, "tName" for TYPEs, "pName" for SUB/FUNCTION parameters etc..
  - The reality is, there are too many uncertainties to be able to set a clear rule here, so the library should use **unique names** wherever possible, it may use prefixes on desire or not.
  - In the very end not all the burden can be put on the library author alone here, to make sure there will never be any name conflicts when using his library, finally the end user of a library will hopefully have his own brain and should be smart enough to do his own part to avoid name conflicts.
  - So far so good, but at least **one thing must be made sure by the library author**. The library can't have any name clashes with any of the other libraries in the Pack. Follow #6 in the [Requirements List](#what-are-the-requirements-for-inclusion-of-a-library) above to check that.

- **After talking that much about descriptive names, of course the library should also use them for labels, especially for DATA labels used in conjunction with RESTORE. Those labels are different from GOTO/GOSUB labels as they are visible in the whole program, even if they are defined locally inside a SUB/FUNCTION, i.e.:**
  - DATA labels must be treated like DIM SHARED variables, it's possible in the main program to RESTORE to and read DATA defined locally in a SUB/FUNCTION and also every SUB/FUNCTION can read DATA defined in the main program or any other SUB/FUNCTION.
  - In short, to not run into RESTORE ambiguities, every DATA label must be unique over the whole program, doesn't matter where it is defined, just like DIM SHARED variables.
  - Here the best way to assure that is really to use a strong prefix in names like `libname_myDataLabel:` if the DATA is defined in the **AfterMain** library part, and using `subfuncname_myDataLabel:` if the DATA is in a SUB/FUNCTION in the **AtBottom** library part.

- **And the final one on names, all those simple single letter variables and common short terms like tmp$, temp$ etc. should only be used locally and temporary inside SUB/FUNCTION and maybe as element names inside TYPE. A library should never DIM SHARED X, Y, I, K, M, etc., but instead keeping them reserved as local variables. That way they should never interfere with anything else.**

- **Unless absolutely necessary, SUBs/FUNCTIONs should never pass values back via its parameters.**
  - Each SUB/FUNCTION which needs to modify any of the given parameters internally should move the affected parameters over into a temporary local variable and use that internally in place of the original passed parameter.
  - E.g. if SUB MathJunk(X,Y) is modifying X and/or Y internally, then the first line in the SUB should read as "TempX = X: TempY = Y" or similar and all further operations should only be done on TempX/TempY and never on the original X/Y. This practice prevents all instances of accidental value corruption.
  - Very important, if such pass backs are intended, then this **should be explicitly mentioned** in the respective function description. Remind the user that only variables of the exact type as specified for the parameter can receive the pass back value, and that giving a variable of another type or even a literal will compromise the pass back. Putting extra parenthesis around the parameter in the SUB/FUNCTION call to force a BYVAL parameter transfer will also compromise the intended pass back.

- **SUBs/FUNCTIONs should always restore changed settings/modes before exit.**
  - If a routine needs a \_DISPLAY, it should check to see if the user had \_AUTODISPLAY on, and if so, restore it on exit.
  - \_DEST, \_SOURCE, \_BLEND, \_PRINTMODE, COLOR, visible screen, and lots more can be altered while in a routine, but unless that's the intended purpose of the routine, it must be reset.

- **Also none of the library include files should leave the compiler in $CHECKING:OFF mode, there must be a matching $CHECKING:ON for each :OFF. If in doubt, then an additional $CHECKING:ON placed in the very last line of each library file is a good safety measure.**

Go back to the [Requirements List](#what-are-the-requirements-for-inclusion-of-a-library) above.
