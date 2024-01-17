# Converting Linux Training Docbook material to Markdown

I have the original repository and this one cloned locally in sibling directories `linux-training-be/` and `linux-training-hogent/` respectively.

From the directory `linux-training-hogent`, I run the following command to convert the Docbook XML to Markdown:

```bash
> ./lib/convert-db2md.sh | tee log/convert-db2md.log
> ./lib/convert-titles.sh | tee log/convert-titles.log
> ./lib/remove-indexterm.sh | tee log/remove-indexterm.log
> cp -r ../linux-training-be/images/ .
```

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
