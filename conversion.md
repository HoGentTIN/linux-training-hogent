# Converting Linux Training Docbook material to Markdown

I have the original repository and this one cloned locally in sibling directories `linux-training-be/` and `linux-training-hogent/` respectively.

From the directory `linux-training-hogent`, I run the following command to convert the Docbook XML to Markdown:

```bash
> ./lib/convert-db2md.sh | tee log/convert-db2md.log
> ./lib/convert-titles.sh | tee log/convert-titles.log
> ./lib/remove-indexterm.sh | tee log/remove-indexterm.log
> cp -r ../linux-training-be/images/ .
> ./lib/collect-author-info.sh | tee log/author-stats.log
```

The scripts perform the following tasks:

- `convert-db2md.sh`: Convert Docbook XML to Markdown using `pandoc`.
- `convert-titles.sh`: The title of each module is stored in a separate file with contents `<title>TITLE</title>`. Pandoc does not convert this correctly to a Markdown title, so that's where this script comes in.
- `remove-indexterm.sh`: The original Docbook XML contains `<indexterm>` tags that, when converted to Markdown, are not handled well by some of the tools we use. This script removes them. A static site generator like `mkdocs` with the `mkdocs-material` theme already has full-text search functionality, so we don't really need the index terms. The PDFs won't have an index, but these days, people are more likely to peruse them in electronic form and can use the search function in a PDF reader anyway.
- `collect-author-info.sh`: By converting the entire work to Markdown we lose the original Git history, and we feel it is important to preserve the authorship information. This script uses Git blame to determine the people who contributed to each module. The person who touched the most lines in a module is considered the author, others as contributors. The script writes the author information to a file `015_authors.md` in the Markdown source directory of each module.

## Generating mkdocs site

- Ensure `mkdocs` is installed:
- Create a directory `docs/` and subdirectories corresponding to the parts in the book.
    - e.g. `mkdir -p docs/{introduction-to-linux,first-steps}`
    - Move/copy [images](https://github.com/linuxtraining/lt/tree/master/images) folder to `docs/`
- Create and edit [mkdocs.yml](mkdocs.yml)
- To add content, copy the converted Markdown files from modules to the newly created subdirectories.
    - e.g. `cat modules/file_system_tree/*.md > docs/first-steps/file-system-tree.md`
- To view the site locally, run `mkdocs serve` and browse to <http://127.0.0.1:8000/>

## Deploying to GitHub Pages

Github Pages and Github Actions are set up to automatically deploy the site to <https://hogenttin.github.io/linux-training-hogent/>. Just make the necessary changes, commit and push to Github.
