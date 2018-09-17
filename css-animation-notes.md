# CSS Animation Notes

## With transition property

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
