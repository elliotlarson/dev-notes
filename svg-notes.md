# SVG Notes

## Bringing SVG From Sketch Into CSS

Ensure you have the `svgo` command installed:

```bash
$ brew install svgo
```

In Sketch, right click the image you want to export and click the `Copy SVG Code` link in the context menu.

With the SVG code in the clipboard buffer, process it on the command line with:

```bash
$ pbpaste | svgo -i - -o -
```

This will dump the output in the terminal.

To encode the URL:

```bash
$ pbpaste | svgo -i - -o - --datauri=enc
```

You can also copy the output back into the clipboard buffer:

```bash
$ pbpaste | svgo -i - -o - --datauri=enc | pbcopy
```

If you are using Sass, you can paste the results into a variable:

```scss
// place the image code after the comma
$my-image: 'data:image/svg+xml,';
```

## Process all SVGs in a directory

```bash
$ svgo *.svg
```
