# CSS Notes

## Terminology

An example css rule:

```css
.foo {
  color: #fff;
}
```

* `.foo` = the selector
* `{ color: #fff; }` = the declaration block
* `color: #fff` = a declaration
* `color` = a property
* `#fff` = a value

## Cascade

CSS applies in a order of importance

1. The most important CSS declarations have an `!important` flag
1. Inline styles
1. Styles applied to IDs
1. Styles applied to classes, pseudo-classes, and attributes

### Calculate the specificity of an element

You can count up the number items a rule has:

1. Inline
1. IDs
1. Classes
1. Elements

For example:

```css
nav#nav div.pull-right .button {
  background: #fff;
}
```

This has:

1. Inline = 0
1. IDs = 1
1. Classes = 2
1. Elements = 2

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

## Animation with transition property

You can setup an element to do simple animations with the help of the transition property.

Say we have a button we want to animate on hover:

```css
.btn {
  transition: all .2s ease-out;
}

.btn:hover {
  transform: translateY(-10px);
}
```

## Keyframe animation

You can animation elements with a high degree of control using keyframes.

```css
@keyframes my-animation {
  0% {
    opacity: 0;
  }

  100% {
    opacity: 1;
  }
}

/* or you could use the shorthand */

@keyframes my-animation {
  from {
    opacity: 0;
  }

  to {
    opacity: 0;
  }
}
```

When you've named the animation, you can apply it to an element:

```css
.animated-div {
  animation-name: my-animation;
  animation-duration: 1s;
  animation-timing-function: ease-in;
  animation-delay: 2s;
}

/* or the shorthand */

.animated-div {
  animation: my-animation 1s ease-in 2s;
}
```

Keyframe animations can be useful for sprite sheet image animations: http://jsfiddle.net/simurai/CGmCe/light/

### A keyframe animation to fade in and move up

This will cause the button to start out with an opacity of 0, and then after a 2 second delay, fade in and move up by 30px.

```css
@keyframes fade-in-move-up {
  from {
    opacity: 0;
    translate: tranformY(30px);
  }

  to {
    opacity: 1;
    translate: tranformY(0);
  }
}

.btn-fade-in-move-up {
  animation: fade-in-move-up 0.4s ease-out 2s backwards;
}
```

The `backwards` part is the `animation-fill-mode` property.  This causes the element to take on the initial animation properties before the animation starts.  Without it, the element would appear on the page, then after 2 seconds would disappear and then animate in.
