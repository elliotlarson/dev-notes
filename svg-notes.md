# SVG Notes

## A Basic SVG

```xml
<svg width="50" height="50">
  <circle cx="25" cy="25" r="25"></circle>
</svg>
```

The coordinate system for an SVG starts with 0,0 at the top left corner.

## SVG Elements

### Circle

```xml
<circle cx="25" cy="25" r="25"></circle>
```

Attributes:

* **cx**: The x position of the center of the circle
* **cy**: The y position of the center of the circle
* **r**: The radius of the circle; percent or pixels

### Rect

```xml
<rect width="50" height="50" />
```

Attributes:

* **width**: in pixels or percent
* **height**: in pixels or percent
* **x**: the x coordinate
* **y**: the y coordinate
* **rx**: the horizontal corner radius
* **ry**: the vertical corner radius

### Ellipse

```xml
<ellipse cx="100" cy="50" rx="100" ry="50" />
```

Attributes:

* **cx**: the x coordinate
* **cy**: the y coordinate
* **rx**: the x radius
* **ry**: the y radius

### Line

```xml
<line x1="0" y1="0" x2="50" y2="50" />
```

Attributes:

* **x1**: the x position of the first point
* **y1**: the y position of the first point
* **x2**: the x position of the second point
* **y2**: the y position of the second point

### Polygon

A closed set of points.

```xml
<polygon points="150,20 200,60 180,110 120,110 100,60" />
```

Attributes:

* **points**: the set of x,y positions

### Polyline

An unclosed set of points.

```xml
<polyline points="150,20 200,60 180,110 120,110 100,60" />
```

Attributes:

* **points**: the set of x,y positions


## Styling SVG Elements

### Stroke

* **stroke**: the color of the stroke or a url for an image
* **stroke-width**: the width of the stroke
* **stroke-linecap**: the type of line ending cap: butt (default), square, round)
* **stroke-linejoin**: the type of join style between two line segments: miter (default), round, bevel)

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
