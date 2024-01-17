# Converting Linux Training Docbook material to Markdown

I have the original repository and this one cloned locally in sibling directories `linux-training-be/` and `linux-training-hogent/` respectively.

From the directory `linux-training-hogent`, I run the following command to convert the Docbook XML to Markdown:

```bash
> ./lib/convert-db2md.sh | tee log/convert-db2md.log
> ./lib/convert-titles.sh | tee log/convert-titles.log
> ./lib/remove-indexterm.sh | tee log/remove-indexterm.log
> cp -r ../linux-training-be/images/ .
```
