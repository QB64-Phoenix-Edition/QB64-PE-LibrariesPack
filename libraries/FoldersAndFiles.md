Go back to the [JustDropItIn](./JustDropItIn.md) or to the [Contributors](./Contributors.md) document.

---

### The layout of the libraries folder
The `libraries` folder contains four sub-folders named by their designated context:
- `descriptors` for the libraries config/description INI files ([see below](#the-library-descriptor-ini-format))
- `documents` for the libraries API documentation files
- `examples` for the libraries usage examples and data files
- `includes` for the regular library code files BI/BM + BAS if used

The sub-structure inside these four base folders is identically organized as `author/libraryname` with the only exception that inside the `descriptors` folder the `libraryname` designates an INI file instead of another sub-folder.

```plain
<any location on your harddisk>/qb64pe/libraries
|
+---descriptors     (INI based library descriptions per author)
|   +---author-1    (INI files for all libraries by this author and his avatar
|   +---author-2     picture and/or individual library logo pictures (100x100))
|   +---
|   +---author-n
|
+---documents       (full library documentations per author and library)
|   +---author-1    (sub-folders for each library by this author)
|   |   +---lib-1   (PDF, MD, TXT, HTML documents for this library by this author)
|   |   +---lib-2
|   |   +---
|   |   +---lib-n
|   |
|   +---author-2
|   |   +---lib-1
|   |   +---lib-2
|   |   +---
|   |   +---lib-n
|   |
|   +---
|   |
|   +---author-n
|       +---lib-1
|       +---lib-2
|       +---
|       +---lib-n
|
+---examples        (library usage examples per author and library)
|   +---author-1    (sub-folders for each library by this author)
|   |   +---lib-1   (example BAS files and data for this library by this author)
|   |   +---lib-2
|   |   +---
|   |   +---lib-n
|   |
|   +---author-2
|   |   +---lib-1
|   |   +---lib-2
|   |   +---
|   |   +---lib-n
|   |
|   +---
|   |
|   +---author-n
|       +---lib-1
|       +---lib-2
|       +---
|       +---lib-n
|
+---includes        (the regular library code per author and library)
    +---author-1    (sub-folders for each library by this author)
    |   +---lib-1   (BI, BAS, BM files for this library by this author, which are
    |   +---lib-2    automatically included by the $USELIBRARY metacommand as
    |   +---         defined in the INI descriptor files)
    |   +---lib-n
    |
    +---author-2
    |   +---lib-1
    |   +---lib-2
    |   +---
    |   +---lib-n
    |
    +---
    |
    +---author-n
        +---lib-1
        +---lib-2
        +---
        +---lib-n
```

---

### The Library Descriptor INI format
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

---

Go back to the [JustDropItIn](./JustDropItIn.md) or to the [Contributors](./Contributors.md) document.
