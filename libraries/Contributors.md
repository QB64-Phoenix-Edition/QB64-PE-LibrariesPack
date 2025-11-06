## You wanna contribute to the Libraries Pack?
Perfect, as said earlier dropping in more library files should be easy enough, once you understood the layout of the `libraries` folder. The much harder part is to make sure the library meets the requirements for inclusion into the Pack first, for that check out the sections below. You should also be familiar with GitHub and its related tools.

When you're sure everything is ready for inclusion, then follow the steps below:
1. Make yourself a fork of our [QB64-PE Libraries Pack](https://github.com/QB64-Phoenix-Edition/QB64-PE-LibrariesPack) repository.
2. In your forked repository make a new folder for the `author` inside each of the four sub-folders `descriptors`, `documents`, `examples` and `includes` if the author is not already in the list.
3. Inside the `author` folders make a sub-folder for the `libraryname`, but only in the `documents`, `examples` and `includes` branches this time.
4. In the `author` folder of the `descriptors` branch create a new INI file `libraryname.ini` and fill it with the respective data. The easiest is probably to copy the INI of another library, rename it accordingly and exchange its information.
5. If the new author is a known forum member, then get his avatar picture and also save it in the new `descriptors/author` folder and specify it in the INI file. If no personalized avatar is available, then leave the INI entry empty.
6. Open a **Pull Request** in your forked repository to request a merge of your made changes back into the parent repository.

#### The Library Descriptor INI format is easy and straight forward:

    [LIBRARY DETAILS]
    FullName="Full name/title of the library"
    Version="1.0 (optional DD-MMM-YYYY date)"
    License="license name (optional license link)"
    ShortDesc="A short description of the library, its purpose etc. (max. 450-500 chars)."
    FullDocs=full_documentation_filename
    Author="User name, (optional real name) & optional other contributors"
    Avatar=optional_author_forum_avatar_filename

    [LIBRARY INCLUDES]
    IncAtTop=library_BI_filename
    IncAfterMain=library_BAS_filename
    IncAtBottom=library_BM_filename

Not used/required file entries just remain blank. Note that all file names are to be given without quotes (even if the file name has spaces) and also without any path specification, as files are all in its defined known places and the paths are hardcoded inside QB64-PE and the Library Explorer application. However, make sure that the written cases of all created files and folders do exactly match and also the given file names in the INI file match that. That is because of the usual case sensitivity of Linux file systems, where a file called `Foo.ini` is a different file than `foo.ini` and `FOO.ini`, same is valid for folder names. Not paying enough attention here may lead to errors due to not found files or folders on Linux systems.

Why is a hardcoded folder layout enforced here, wouldn't it be better to allow more freedom here and rather providing full path info in the INI files instead?
- Just like QB64-PE's `internal` folder, also the `libraries` folder has its defined layout, so that the compiler knows where to look for the required files and data.
- The folder must remain maintainable, allowing personal freedom in the folder layout tends to make the place messy pretty quickly, as each user has his own habits and preferences.

### What are the requirements for inclusion of library?
To avoid rejection of a library the following things are considered mandatory:
1. The author of the library must be known and also the license under which it was released, easy if it's your own library. A library should always be listed under the original author name, even if other people contributed to it or revised the library for inclusion.
2. At least a rudimentary documentation must be provided. The simplest form should contain the syntax of all public functions with a brief overview of all arguments and at least one sentence of function description. The file format should be TXT, MD, PDF or HTML.
3. At least one example must be provided. All examples must work from both possible compile locations, the QB64-PE main folder and its source folder if "Output EXE to Source Folder" is used.
4. The library code itself must follow the **Library coding standards** outlined below. The library code may consist of 3 general parts/files, the **AtTop**, the **AfterMain** and the **AtBottom** parts, take a closer look to the `QB64-PE/SampleLib` and its examples to learn what must go in which part.
5. One of the library parts/files must contain the code below to enforce **QB64-PE v4.3.0 or up** for use in the Libraries Pack. It's best to place it in the first part/file included to give the error as soon as possible.
    ```vb
    $IF VERSION < 4.3.0 THEN
        $ERROR "The Libraries Pack add-on needs at least QB64-PE v4.3.0"
    $END IF
    ```
6. After you dropped all files in place, perform a final check. The library can't have any name clashes with any of the other libraries in the Pack. Use the `examples/QB64-PE/SampleLib/CheckAll.bas` program, add the new library and you'll see if the IDE remains happy or starts throwing errors. Also save the `CheckAll.bas` program with the new added library.

### Library coding standards
- **Every library part/file must have the $INCLUDEONCE metacommand in it to avoid accidental multiple inclusions.**

- **A library shall not change global settings, instead a library must adapt to the settings the user chose to use in his program or make sure everything works with either setting. The library may not count on any defaults, once a library is shared publicly, it may be used by someone who has the options set completely backwards of what the library assumed was standard. Some examples:**
  - $DYNAMIC/$STATIC, negligible, the library must simply use REDIM/ERASE for dynamic arrays.
  - DEFINT, DEFLNG etc., negligible, variables must be declared with the "AS type" syntax or generally using type suffixes instead.
  - OPTION _EXPLICIT, the library must always declare all variables, it won't hurt if it's not used, but avoids errors if it's used. Note that variables used in the **AfterMain** part must already be declared in the **AtTop** part, i.e. the variables are already known in the user code and the user can't use the same names for his own code.
  - OPTION BASE 0/1, negligible, the library must simply hard index all arrays using the (RE)DIM myArr(lb TO ub) syntax.

- **A Library should also directly use the available [compiler constants](https://qb64phoenix.com/qb64wiki/index.php/Constants) wherever possible, rather than defining its own CONSTs. This mainly concerns _TRUE and _FALSE, but generally everything what is already provided by the compiler can be used and isn't worth to get redefined.**

- **Especially global names such as CONST, TYPE, (RE)DIM SHARED arrays and variables as well as SUB/FUNCTION names should be self descriptive as much as possible, e.g. "TextToImage" is much easier to understand, remember, and use than just "TTI" or "T2I". Naturally names become longer and that makes them also more resistant against accidental name conflicts.**
  - We had lots of discussions over the years if names should also have a prefix like the authors initials or so, but after calculating some probabilities it turned out that using descriptive names derived from the context of the library's designated purpose is protective enough against name conflicts. E.g. assuming a 10 chars long name of letters only it's a chance of 1:>5mil. for a name conflict, if digits are used besides letters it's already 1:>21mil. and with adding dots and underscores too, it's 1:>10bil. for a 10 chars long name.
  - The real problem here is, that people tend to use the same words and phrases over and over and especially in programming some common words appear ever again such as "top, left, width, height", "print, input" and others, so on such common words extra care must be used.
  - Another possibility for more diversity could be to add a single letter as prefix, e.g. "cName" for CONSTs, "vName" for variables, "tName" for TYPEs etc..
  - The reality is, there are too many uncertainties to be able to set a clear rule here, so the library should use unique names wherever possible, it may use prefixes on desire or not.
  - In the very end not all the burden can be put on the library author alone here, to make sure there will never be any name conflicts when using his library, finally the end user of a library will hopefully have his own brain and should be smart enough to do his own part to avoid name conflicts.
  - So far so good, but at least one thing must be made sure by the library author. The library can't have any name clashes with any of the other libraries in the Pack. Follow #6 in the "Requirements List" above to check that.

- **After talking that much about descriptive names, of course the library should also use them for labels, especially for DATA labels used in conjunction with RESTORE. Those labels are different from GOTO/GOSUB labels as they are visible in the whole program, even if they are defined locally inside a SUB/FUNCTION, i.e.:**
  - DATA labels must be treated like DIM SHARED variables, it's possible in the main program to RESTORE to and read DATA defined locally in a SUB/FUNCTION and also every SUB/FUNCTION can read DATA defined in the main program or any other SUB/FUNCTION.
  - In short, to not run into RESTORE ambiguities, every DATA label must be unique over the whole program, doesn't matter where it is defined, just like DIM SHARED variables.
  - Here the best way to assure that is really to use a strong prefix in names like `libname_myDataLabel:` if the DATA is defined in the **AfterMain** library part, and using `subfuncname_myDataLabel:` if the DATA is in a SUB/FUNCTION in the **AtBottom** library part.

- **And the final one on names, all those simple single letter variables and common short terms like tmp$, temp$ etc. should only be used locally and temporary inside SUB/FUNCTION and maybe as element names inside TYPE. A library should never DIM SHARED X, Y, I, K, M, etc., but instead keeping them reserved as local variables. That way they should never interfere with anything else.**

- **Unless absolutely necessary, SUBs/FUNCTIONs should never pass values back via its parameters.**
  - Each SUB/FUNCTION which needs to modify any of the given parameters internally should move the affected parameters over into a temporary local variable and use that internally in place of the original passed parameter.
  - E.g. if SUB MathJunk(X,Y) is modifying X and/or Y internally, then the first line in the SUB should read as "TempX = X: TempY = Y" or similar and all further operations should only be done on TempX/TempY and never on the original X/Y. This practice prevents all instances of accidental value corruption.
  - Very important, if such pass backs are intended, then this must be explicitly mentioned in the respective function description. Remind the user that only variables of the exact type as specified for the parameter can receive the pass back value, and that giving a variable of another type or even a literal will compromise the pass back. Putting extra parenthesis around the parameter in the SUB/FUNCTION call to force a BYVAL parameter transfer will also compromise the intended pass back.

- **SUBs/FUNCTIONs should always restore changed settings/modes before exit.**
  - If a routine needs a _DISPLAY, it should check to see if the user had _AUTODISPLAY on, and if so, restore it on exit.
  - _DEST, _SOURCE, _BLEND, _PRINTMODE, COLOR, visible screen, and lots more can be altered while in a routine, but unless that's the intended purpose of the routine, it must be reset.

- **Also none of the library include files should leave the compiler in $CHECKING:OFF mode, there must be a matching $CHECKING:ON for each :OFF. If in doubt, then an additional $CHECKING:ON placed in the very last line of each library file is a good safety measure.**
