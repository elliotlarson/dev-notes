## CSS Float Grid Notes

Taken from [Udemy advanced CSS course](https://www.udemy.com/advanced-css-and-sass/learn/v4/overview).

```css
.row {
  max-width: $grid-width;
  margin: 0 auto;

  &:not(:last-child) {
    margin-bottom: $gutter-vertical;
  }

  @include clearfix;

  [class^="col-"] {
    float: left;

    &:not(:last-child) {
    margin-right: $gutter-horizontal;
  }
}

.col-1-of-2 {
  /* 1 gutter, 2 columns */
  width: calc((100% - #{$gutter-horizontal}) / 2);
}

/* 2 gutters, 3 columns */
.col-1-of-3 {
  width: calc((100% - 2 * #{$gutter-horizontal}) / 3);
}

.col-2-of-3 {
  width: calc(2 * ((100% - 2 * #{$gutter-horizontal}) / 3) + #{$gutter-horizontal});
}

/* 3 gutters, 4 columns */
.col-1-of-4 {
  width: calc((100% - 3 * #{$gutter-horizontal}) / 4);
}

.col-2-of-4 {
  width: calc(2 * ((100% - 3 * #{$gutter-horizontal}) / 4) + #{$gutter-horizontal});
}

.col-3-of-4 {
  width: calc(3 * ((100% - 3 * #{$gutter-horizontal}) / 4) +  2 * #{$gutter-horizontal});
}
}
```

```html
<section class="grid-test">
  <div class="row">
    <div class="col-1-of-2">Col 1 of 2</div>
    <div class="col-1-of-2">Col 1 of 2</div>
  </div>

  <div class="row">
    <div class="col-1-of-3">Col 1 of 3</div>
    <div class="col-1-of-3">Col 1 of 3</div>
    <div class="col-1-of-3">Col 1 of 3</div>
  </div>

  <div class="row">
    <div class="col-1-of-3">Col 1 of 3</div>
    <div class="col-2-of-3">Col 2 of 3</div>
  </div>

  <div class="row">
    <div class="col-1-of-4">Col 1 of 4</div>
    <div class="col-1-of-4">Col 1 of 4</div>
    <div class="col-1-of-4">Col 1 of 4</div>
    <div class="col-1-of-4">Col 1 of 4</div>
  </div>

  <div class="row">
    <div class="col-1-of-4">Col 1 of 4</div>
    <div class="col-1-of-4">Col 1 of 4</div>
    <div class="col-2-of-4">Col 2 of 4</div>
  </div>

  <div class="row">
    <div class="col-1-of-4">Col 1 of 4</div>
    <div class="col-3-of-4">Col 3 of 4</div>
  </div>
</section>
```
