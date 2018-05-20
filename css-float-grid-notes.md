## CSS Float Grid Notes

Taken from [Udemy advanced CSS course](https://www.udemy.com/advanced-css-and-sass/learn/v4/overview).

Here we define basic 2 column, 3 column, and 4 column grids.

The row expands up to a specified height, `114rem` (`1140px`) in this case, and centered in the browser window.

A column is a fraction of the total width.  If there are two columns the fraction is half the width minus the number of gutters time the gutter width:

column width = (total row width - number of gutters * gutter width) / total number of columns
column with = (100% - 1 * $gutter-horizontal) / 2

```scss
$grid-width: 114rem;
$gutter-vertical: 8rem;
$gutter-horizontal: 6rem;

@mixin clearfix {
  &:after {
    content: "";
    display: block;
    clear: both;
  }
}

.row {
  max-width: $grid-width
  margin: 0 auto;

  @include clearfix;

  /* apply margin bottom gutter spacing to all but the last row */
  &:not(:last-child) {
    margin-bottom: $gutter-vertical;
  }

  [class^="col-"] {
    float: left;

    /* apply margin right gutter to all but the last child */
    &:not(:last-child) {
      margin-right: $gutter-horizontal;
    }
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
