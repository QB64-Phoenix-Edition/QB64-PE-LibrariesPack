# How to drop in another library
As already said in the [ReadMe](./README.md) document, dropping in more library files should be easy enough, once you understood the [layout](./FoldersAndFiles.md#the-layout-of-the-libraries-folder) of the `libraries` folder.

Here's the quick'n'dirty way assuming you already have installed the **Libraries Pack**:
- Note this is the most simple implementation to make the library available for the **$USELIBRARY** metacommand, but it completely waives all **Library Explorer** info as well as the library's documentation and examples (if any).
- Note also that the new library may have name conflicts with other libraries in the Pack, which must be resolved by editing the dropped new library files. The `libraries/CheckAll.bas` program will help to quickly find those conflicts (if any).

**When creating folders and/or files, make sure to use the very same upper/lower case spelling in all places, that's very important if you're on Linux.**

- In your `libraries/includes` folder make a new folder for the `author` if the author is not already there.
  - Inside the just created `libraries/includes/author` folder make a new sub-folder for the `libraryname`.
    - Now drop the library code files (BI/BM/BAS) inside the just created `libraries/includes/author/libraryname` folder.
- In your `libraries/descriptors` folder make a new folder for the `author` if the author is not already there.
  - Inside this `libraries/descriptors/author` folder create a new INI file `libraryname.ini` and fill in the **\[LIBRARY INCLUDES\]** section with the respective file names (see [INI-Format](./FoldersAndFiles.md#the-library-descriptor-ini-format)).

You're done, the library can now be included using the **$USELIBRARY** metacommand.

---

### Additional steps worth considering
- If the library has a documentation and/or examples, then consider creating the same `author/libraryname` sub-structure inside the `libraries/documents` and `libraries/examples` folders and drop the documentation and examples into it.
- Fill in the **\[LIBRARY DETAILS\]** section in the `libraryname.ini` file so the **Library Explorer** can give you some info about the library.
