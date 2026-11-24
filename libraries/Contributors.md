# You wanna contribute to the Libraries Pack?
Perfect, as already said in the [ReadMe](./README.md) document, dropping in more library files should be easy enough, once you understood the [layout](./FoldersAndFiles.md#the-layout-of-the-libraries-folder) of the `libraries` folder. The much harder part is to make sure the library meets the requirements for inclusion into the official **Libraries Pack** first, which is best done in your local QB64-PE installation.

First make sure the library code is compliant to our **[Library coding standards](./LibraryStandards.md)**. The given rules were collected and refined over years by several serious library authors in our QB64 community such as Steve McNeill, Terry Ritchie, RhoSigma, a740g and others. Even if you finally decide not to publish the library in the official **Libraries Pack**, but only keep it for your own private use, following those rules makes sure the library becomes a solid piece of code which is less error prone.

When you're done with that part and still willing to go on, then come back here and we'll discuss the further steps for the integration of the library into the official **Libraries Pack** below.

---

### General integration steps
Ok, now that the library is perfectly shaped let's go on dropping all files in its right locations in the `libraries` folder, so the library becomes available in the **Library Explorer** and for the **$USELIBRARY** metacommand (assuming you already have installed the **Libraries Pack**):

**When creating folders and/or files, make sure to use the very same upper/lower case spelling in all places, that's very important for the Linux system.**

- In your `libraries/includes` folder make a new folder for the `author` if the author is not already there.
  - Inside the just created `libraries/includes/author` folder make a new sub-folder for the `libraryname`.
    - Now drop the library code files (BI/BM/BAS) inside the just created `libraries/includes/author/libraryname` folder.
- In your `libraries/examples` folder make a new folder for the `author` if the author is not already there.
  - Inside the just created `libraries/examples/author` folder make a new sub-folder for the `libraryname`.
    - Now drop the library's examples (source and data like images/fonts etc.) inside the just created `libraries/examples/author/libraryname` folder.
    - If the library doesn't have any examples, then you must create at least one by your own to demonstrate the most important features of the library. An example is a **requirement**, without the library is not accepted in the official **Libraries Pack**.
- In your `libraries/documents` folder make a new folder for the `author` if the author is not already there.
  - Inside the just created `libraries/documents/author` folder make a new sub-folder for the `libraryname`.
    - Now drop the library's documentation (TXT, MD, PDF, HTML etc.) inside the just created `libraries/documents/author/libraryname` folder.
    - If the library doesn't have a documentation but source code comments describing each SUB/FUNCTION, then you should copy all those comments into a simple TXT file for easy reference.
    - If the library doesn't have a documentation at all, then you must write at least a rudimentary documentation for it, because nobody uses a library where he must diggin' into the code first to understand it's purpose and usage. A documentation is a **requirement**, without the library is not accepted in the official **Libraries Pack**. See a740g's QBDS libraries for a good minimal documentation. For more complex libraries a more comprehensive documentation is of advantage, such as in RhoSigma's and TerryRitchi's libraries. The file format should be TXT, MD, PDF or HTML.
- In your `libraries/descriptors` folder make a new folder for the `author` if the author is not already there.
  - Inside this `libraries/descriptors/author` folder create a new INI file `libraryname.ini` and fill in the **\[LIBRARY DETAILS\]** and **\[LIBRARY INCLUDES\]** sections with the respective information and file names (see [INI-Format](./FoldersAndFiles.md#the-library-descriptor-ini-format)).
  - If the library author is a known forum member, then get his avatar picture and specify it in the respective INI entry. If no personalized avatar is available, then leave the INI entry blank. In alternative you may also use the INI entry to specify a dedicated library logo of 100x100 pixels. The images must be dropped into the `descriptors/author` folder along with the INI file.

Now, from this point the library is properly listed in the **Library Explorer** and can be easily included using the **$USELIBRARY** metacommand.

---

### Finalizing the integration
As in the **Libraries Pack** not $INCLUDE but **$USELIBRARY** is the standard call to pull in a library, we must adjust this in all files. Also we must make sure usage examples find their respective data files (if any) regardless of the executable's save location.

- First check the documentation, especially any code examples in it. Those will probably have $INCLUDE lines at the top/bottom, remove those and instead place the respective **$USELIBRARY** line for the library at the top position.
- Then check the library's usage examples and do the same, remove the $INCLUDE calls and place the **$USELIBRARY** call.
  - Also all examples should use **upper case keywords** and especially when they read/write data files, then these files must be accessible regardless of the executable's location.
    - As we've dropped the data files along with the example's source you can simply copy and adjust the code block shown in `examples/QB64-PE/SampleLib/GetSrcFold.bas` program to determine the folder.

In the end, after all requirements are met and everything works as expected, perform a final **but important** check. The new library may have name conflicts with any of the other libraries already in the Pack, which must be resolved by editing the dropped new library files.
- Load the `libraries/CheckAll.bas` program into the IDE and make sure syntax checking is active.
- Then add the new library into the list and you'll see if the IDE remains happy or starts throwing errors or warnings.
- If the library code has platform or 32/64bits dependent code in $IF..$ELSE..$ENDIF blocks, then make sure to solve any conflicts in every branch of the the conditional block.
- When done, then save the `CheckAll.bas` program with the new added library.

---

## Finish line
Congratulations, you've properly added a new library into the **QB64-PE Libraries Pack**. Thank you very much for your efforts, we know it was a solid piece of work especially when you were required to write documentation and/or examples yourself.

Now simply pack your entire `libraries` folder and post the archive in the [GitHub Discussion](https://qb64phoenix.com/forum/forumdisplay.php?fid=42) Forum. Any developer will then check and incorporate your work into the official GitHub repository.

In alternative, if you're familiar with GitHub, then you may also publish your work into your private fork of our [QB64-PE Libraries Pack](https://github.com/QB64-Phoenix-Edition/QB64-PE-LibrariesPack) repository and make a **Pull Request** from there.

# Thank You
