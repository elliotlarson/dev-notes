# CSS Card Flipping Notes

This creates an effect where the card appears to flip when rolling over the card.

```scss
.card {
  perspective: 150rem;
  -moz-perspective: 150rem;
  position: relative;
  height: 52rem;

  &__side {
    transition: all .8s ease;
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 52rem;
    backface-visibility: hidden;
    box-shadow: 0 1.5rem 4rem rgba($color-black, .15);

    &--front {
      background-color: #fff;
    }

    &--back {
      transform: rotateY(180deg);
      background-color: #eee;
    }
  }
}
```

```html
<div class="card">
  <div class="card__side card__side--front">
    Front
  </div>
  <div class="card__side card__side--back">
    Back
  </div>
</div>
```

## Some interesting points about this technique

The `backface-visibility` property controls the visibility of the back of an element.  The backface of an element is a mirror image of the front of an element.  It only comes into play when you're doing 3D transforms.  In the card flip example, we are hiding the backface of both front and back cards so they do not show while in flipped state.  While showing back, the front is hidden.  While showing front, the back is hidden.

