# Converting Linux Training Docbook material to Markdown

I have the original repository and this one cloned locally in sibling directories `linux-training-be/` and `linux-training-hogent/` respectively.

From the directory `linux-training-hogent`, I run the following command to convert the Docbook XML to Markdown:

```console
> ./lib/convert-db2md.sh | tee log/convert-db2md.log
> ./lib/convert-titles.sh | tee log/convert-titles.log
> ./lib/remove-indexterm.sh | tee log/remove-indexterm.log
> cp -r ../linux-training-be/images/ .
> ./lib/collect-author-info.sh | tee log/author-stats.log
> ./lib/move-images.sh
```

The scripts perform the following tasks:

- `convert-db2md.sh`: Convert Docbook XML to Markdown using `pandoc`.
- `convert-titles.sh`: The title of each module is stored in a separate file with contents `<title>TITLE</title>`. Pandoc does not convert this correctly to a Markdown title, so that's where this script comes in.
- `remove-indexterm.sh`: The original Docbook XML contains `<indexterm>` tags that, when converted to Markdown, are not handled well by some of the tools we use. This script removes them. A static site generator like `mkdocs` with the `mkdocs-material` theme already has full-text search functionality, so we don't really need the index terms. The PDFs won't have an index, but these days, people are more likely to peruse them in electronic form and can use the search function in a PDF reader anyway.
- `collect-author-info.sh`: By converting the entire work to Markdown we lose the original Git history, and we feel it is important to preserve the authorship information. This script uses Git blame to determine the people who contributed to each module. The person who touched the most lines in a module is considered the author, others as contributors. The script writes the author information to a file `015_authors.md` in the Markdown source directory of each module.
- `move-images.sh`: The images are moved from the common `images/` directory in the root of the repository to a subdirectory `assets/` within the module directory. This ensures that images are visible in previews while editing. The links to the images are updated in the Markdown files with.

    ```bash
    find modules/ -type f -name '*.md' -exec sed -i 's|\.\./images/|assets/|' {} \;
    ```

    This step revealed that there are dozens of images that are never referenced in the content. For now, these are kept in the general images directory, but they may be removed at a later date.

## Modules from the 2021 version

In 2021, Paul Cobbaut published a new version that consolidated the contents of Linux Fundamentals, Linux System Administration, etc. This version was written in [AsciiDoc](https://asciidoc.org). We converted the source to Markdown and added the content in subdirectory `modules_2021/`. The conversion was done with the `adoc2md.sh` script in the `lib/` directory. This script uses the `asciidoc` command to convert AsciiDoc to DocBook XML and then uses `pandoc` to convert the DocBook XML to Markdown. Index entries were deleted with the `sed` command.

