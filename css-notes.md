# CSS Notes

## Universal selector

The universal selector selects all elements in the DOM

```css
* {
  /* some styles that apply to everything */
}
```

This can be useful for doing a simple CSS reset:

```css
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}
```

## Box sizing

To make sure that the padding and border are not added to the total width and height of an element

```css
box-sizing: border-box;
```

Without this, the border and padding are added to the width.  So a div with a width of 100px, padding of 20px and border of 2px is 144px wide.  But with `box-sizing: border-box` the width remains 100px.

## Viewport height

You can tell an element to have a height relative to the viewport.

This sets a heading to be 95% of the viewport height:

```css
height: 95vh;
```

## Background size

You can set the background size of an element to `cover` which will scale the image as large as possible without stretching the image so it fills the background of the element it's applied to.

```css
background-size: cover;
```

This will crop the image.  If you don't want image cropping you can use `contain`.  This will not stretch the image.

```css
background-size: contain;
```

If you want to stretch the image you can use a percentage

```css
background-size: 100%;
```

## Background-image

You can specify an image:

```css
background-image: url(../img/foo.png);
```

or a gradient:

```css
background-image: linear-gradient(#fff, #efefef);
```

or both:

```css
background-image: linear-gradient(to right, #fff, #efefef), url(../img/foo.png);
```

More information [about linear gradients](https://developer.mozilla.org/en-US/docs/Web/CSS/linear-gradient).


## Positioning an element in the middle

You can position an element so the top left corner is in the middle with `position: absolute`

```css
position: absolute;
top: 50%;
left: 50%;
```

To get the element centered you need to move the element up by half the element's height and left by half the element's width.  You can do this with `transform`:

```css
transform: translate(-50%, -50%);
```
