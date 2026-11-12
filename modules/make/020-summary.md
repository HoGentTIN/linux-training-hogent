The command `make` and the related `Makefile` are tools for building software projects that have been part of the Unix operating system since the 1970s. They were originally developed to automate the compilation of C programs, but their design is flexible enough to be used for a wide variety of tasks. Because it is included in the POSIX standard, `make` is available on almost all Unix-like operating systems, including Linux and macOS.

Most programming languages have their own specialized build tools (like `maven` for Java, `cargo` for Rust, etc.), but `make` is a general-purpose tool that can be used in many different contexts where specific tooling is not available. Basically, any use case where you need to transform a set of input files into output files can benefit from using `make`. Examples include:

- generating a Docker container image from a `Dockerfile`,
- converting Markdown files into HTML, in the form of a website (e.g. [mkdocs](https://www.mkdocs.org), [Jekyll](https://jekyllrb.com)) or slide deck (e.g. [reveal.js](https://revealjs.com), [Marp](https://marp.app)),
- compiling [LaTeX](https://www.latex-project.org) or Markdown documents into PDFs,
- generating images from [dot files](https://graphviz.org), [PlantUML](https://plantuml.com), or [Mermaid](https://mermaid.js.org),
- generating sheet music from [LilyPond](https://lilypond.org) or [ABC](https://abcnotation.com) files,
- ...

A `Makefile` is a text file that contains the "recipes" for generating the target file(s) from the source(s). This provides two major benefits. On the one hand, you no longer need to remember the exact command(s) and options to run when you want to build your project. On the other hand, `make` will only (re)build the parts of your project that have changed since the last build, which can save a lot of time.

Learning goals:

- Using the command `make` to automate workflows, writing a `Makefile` to define the workflow.
- Understanding and being able to apply basic `Makefile` concepts:
    - targets, preliminaries/dependencies, rules
    - pattern rules
    - variables, automatic variables, builtin functions
    - "special" built-in targets and phony targets

