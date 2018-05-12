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

The "fill area" is the area inside the box including the padding and border, but not the margin.

### Inheriting box sizing

The `box-sizing` attribute is not inherited, but you can force it to inherit with something like:

```css
*,
*::after,
*::before {
  box-sizing: inherit;
}
/* this gets the sudo elements also */

body {
  box-sizing: border-box;
}
```

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

## Styling with `rem`

You can create responsive and flexible designs using `rem` spacing.  1 `rem` equals 100% of the base font size.  You can set the base font-size in your CSS with the `html` attribute.

```css
html {
  font-size: 10px;
}
```

Then you can set the size of other elements to rem instead of pixels:

```css
.my-div {
  padding: 1rem;
}
```

This would give the div 10px of padding.

### Using default browser font size instead of 10px

If you use the value `10px` for the default font size, this will force the font size to 10px.  Users that increase their font size in their browser, will have their settings overridden by your CSS.  To not override the user's settings, you can use percentages:

```css
html {
  font-size: 100%; /* equals 16px */
  font-size: 62.5%; /* equals 10px */
}
```

## BEM - Block Element Modifier

[website](http://getbem.com/)

> is a methodology that helps you to create reusable components and code sharing in front-end development

* **Block** = A standalone entity that is meaningful on its own
  For exmaple: `header`, `container`, `menu`, `checkbox`, `input`
* **Element** = A part of a block that has no standalone meaning and is semantically tied to it's block
  For example: `menu item`, `list item`, `checkbox caption`, `header title`
* **Modifier** = A flag on a block element used to change appearance
  For example: `disabled`, `highlighted`, `checked`, `fixed`, `size big`, `color yellow`

### BEM example

```html
<button class="button">
	Normal button
</button>
<button class="button button--state-success">
	Success button
</button>
<button class="button button--state-danger">
	Danger button
</button>
```

```css
.button {
	display: inline-block;
	border-radius: 3px;
	padding: 7px 12px;
	border: 1px solid #D5D5D5;in
	background-image: linear-gradient(#EEE, #DDD);
	font: 700 13px/18px Helvetica, arial;
}
.button--state-success {
	color: #FFF;
	background: #569E3D linear-gradient(#79D858, #569E3D) repeat-x;
	border-color: #4A993E;
}
.button--state-danger {
	color: #900;
}
```

## `not` pseudo class

You can use `not` to negate rules in certain circumstances.  For example, if you want padding on the bottom of elements, except the last child:

```css
.row:not(:last-child) {
  padding-bottom: 6.5rem;
}
```

## `after` pseudo class

You can use after to do things like add markup that is useful for CSS, like a clearfix:

```css
.clearfix:after {
  content: "";
  display: table;
  clear: both;
}
```
