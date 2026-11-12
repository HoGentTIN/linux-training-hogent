## practice: make

1. Try out all the examples in this chapter!

2. Extend the example `Makefile` to split up the compilation and linking steps into separate targets. In this case, you would first compile a source file (.c) into an object file (.o), and then create the binary from the object file. For `true.c`, you would need the following commands:

    ```bash
    gcc -c true.c       # Compilation from .c to .o
    gcc -o true true.o  # Linking .o into executable
    ```

    Write a pattern rule for compiling the source into an object file, and adapt the existing pattern rule for creating the binary to take the corresponding object file as input. Of course, keep using the variables for the compiler and compiler options.

    Check what happens when you run `make` after changing a source file. Does it only recompile the changed source file, or does it also relink the binary?

3. Add a target `mrproper:` that removes all compiled binaries and object files and have `clean:` only remove the object files. Avoid code duplication!

4. Also, what is the effect of removing the `.SECONDARY:` directive from the `Makefile`?

5. Look for example Makefiles online as inspiration. Here are a few suggestions for different use cases (maintained by the author of this chapter):

    - [Creating lecture slides from Markown source files](https://github.com/HoGentTIN/linux-slides/blob/main/Makefile)
    - [Converting LaTeX documents into PDFs](https://github.com/HoGentTIN/latex-hogent-article/blob/main/Makefile)
    - [Converting ABC music notation into sheet music](https://github.com/bertvv/abc-transcriptions/blob/main/Makefile) in several formats (a,.o. PDF, PNG, MIDI)

