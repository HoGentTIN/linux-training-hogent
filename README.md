# Linux Training @HOGENT

The [Linux Training](https://github.com/linuxtraining/lt) series of books by Paul Cobbaut are an excellent free resource and reference for learning Linux. The books are available from <https://linux-training.be> as PDF. However, after publishing a new, but unfinished PDF in 2021, the project has stalled.

At HOGENT, we've been using the Linux Training books for years and we have a vested interest in keeping the contents up-to-date and of high quality. We've been using the PDFs as a basis for our own course materials, and we'd like to be able to contribute back to the project. We got in touch with Paul Cobbaut, and he's open to the idea of reviving the project since he is too busy with other things to do it himself.

So, the goal of this repository is to preserve the existing content in a format that allows for easy collaboration and contribution, to update and add to the original content, and to publish the updated content in various formats.

To read about the methodology of converting the original Docbook XML to Markdown, and the tools used to generate the PDF and static HTML site, see [conversion.md](conversion.md).

## Roadmap

- [x] Conversion of the original Docbook XML to Markdown so that it can be more easily edited and maintained. The result is available in the [modules](modules/) directory.
- [ ] **WIP:** We're currently working on reproducing Linux Fundamentals:
    - [x] script for generating the book as a PDF (with [Pandoc](https://pandoc.org))
    - [x] script for generating a static HTML site (with [mkdocs](https://www.mkdocs.org))
    - [ ] setting up Github Actions to publish the results to Github Pages
- [ ] Next, we'll add the other books in the series
- [ ] We'll then work on updating the content and adding new content

## Contributing

When we're ready with setting up the infrastructure for the project, we'll be happy to accept contributions. In the meantime, feel free to open an issue if you have any questions or suggestions.

## License information

The content of the Linux Training course material is licensed under the GNU Free Documentation License 1.3. See [LICENSE](LICENSE) for details. The scripts and other files in this repository are public domain.
