# Bootstrap notes

## Bootstrap approach

* Use a font size of 16px on the `html` element, and apply a font size of 1rem to the `body` element
* Avoid margin top
* Size block elements with rems for scalable component spacing
* Box sizing is set to `border-box`

## Override the base font

If you are using SCSS, you can set the `$font-family-base` variable to another value:

```scss
// _typography.scss

@import url("https://fonts.googleapis.com/css2?family=Montserrat:ital,wght@0,100;0,400;0,600;1,400;1,600&display=swap");

$font-family-sans-serif:
  "Montserrat",
  // Safari for macOS and iOS (San Francisco)
  -apple-system,
  // Chrome < 56 for macOS (San Francisco)
  BlinkMacSystemFont,
  // Windows
  "Segoe UI",
  // Android
  Roboto,
  // Basic web fallback
  "Helvetica Neue", Arial,
  // Linux
  "Noto Sans",
  "Liberation Sans",
  // Sans serif fallback
  sans-serif,
  // Emoji fonts
  "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji" !default;
```

Make sure you do this before you import bootstrap:

```scss
// application.scss
@import "typography";
@import "bootstrap/scss/bootstrap";
```
## Tint and shade

Sass has `lighten` and `darken` functions, but these don't always give you the desired effect.  Instead you can use Bootstap's

* `tint-color` (instead of lighten)
* `shade-color` (instead of darken)
* `shift-color` (Shade the color if the weight is positive, else tint it)

```scss
.custom-element {
  color: tint-color($primary, 10%);
}

.custom-element-2 {
  color: shade-color($danger, 30%);
}
```

## Theme colors

```scss
$theme-colors: (
  "primary":    $primary,
  "secondary":  $secondary,
  "success":    $success,
  "info":       $info,
  "warning":    $warning,
  "danger":     $danger,
  "light":      $light,
  "dark":       $dark
);
```

## Containers

The basic `.container` class centers the element on the page and sized with its max-width to change at the screen width breakpoints.

```html
<div class="container">
  <!-- Content here -->
</div>
```

The `.container-fluid` class makes the element full screen width.

```html
<div class="container-fluid">
  <!-- Content here -->
</div>
```

You can use, something like a `.container-md` for a combination of fluid and pixel widths.

## Responsiveness and grids

Here are the breakpoint variables and defaults:

```scss
$grid-breakpoints: (
  xs: 0,
  sm: 576px,
  md: 768px,
  lg: 992px,
  xl: 1200px,
  xxl: 1400px
);
```

The grid is composed of rows that contain columns.  There are twelve columns available and you can resize them to take up additional column widths.

```html
<div class="container">
  <div class="row">
    <div class="col-sm">
      One of three columns
    </div>
    <div class="col-sm">
      One of three columns
    </div>
    <div class="col-sm">
      One of three columns
    </div>
  </div>
</div>
```

There are six responsive breakpoints, like `.col-sm-4`.  Applying this results in a cascade to the larger breakpoints, `.col-md`, `.col-lg`, etc.

You can define equal width columns with just `.col` which sort of auto-figures out the width.

You can set one column width and then auto-widths.

```html
<div class="container">
  <div class="row">
    <div class="col">
      1 of 3
    </div>
    <div class="col-6">
      2 of 3 (wider)
    </div>
    <div class="col">
      3 of 3
    </div>
  </div>
</div>
```

You can do variable width columns with `.col-{breakpoint}-auto`:

```html
<div class="container">
  <div class="row justify-content-md-center">
    <div class="col col-lg-2">
      1 of 3
    </div>
    <div class="col-md-auto">
      Variable width content
    </div>
    <div class="col col-lg-2">
      3 of 3
    </div>
  </div>
</div>
```

Each column has a horizontal and vertical gutters, which you can modify with:

* `.gy-0` = vertical gutters
* `.gx-0` = horizontal gutters
* `.g-0` = all gutters

## Spacing

Where property is one of:

* `m` - for classes that set margin
* `p` - for classes that set padding

Where sides is one of:

* `t` - for classes that set margin-top or padding-top
* `b` - for classes that set margin-bottom or padding-bottom
* `s` - for classes that set margin-left or padding-left in LTR, margin-right or padding-right in RTL
* `e` - for classes that set margin-right or padding-right in LTR, margin-left or padding-left in RTL
* `x` - for classes that set both *-left and *-right
* `y` - for classes that set both *-top and *-bottom

Where size is one of:

* `0` - for classes that eliminate the margin or padding by setting it to 0
* `1` - (by default) for classes that set the margin or padding to $spacer * .25
* `2` - (by default) for classes that set the margin or padding to $spacer * .5
* `3` - (by default) for classes that set the margin or padding to $spacer
* `4` - (by default) for classes that set the margin or padding to $spacer * 1.5
* `5` - (by default) for classes that set the margin or padding to $spacer * 3

```html
<div class="mx-auto" style="width: 200px;">
  Centered element
</div>
```

## Haml partial to view current grid size

Add this to your haml layout to view the current grid layout size:

```haml
%div{ style: 'z-index: 1000; position: absolute; width: 100%;' }
  .d-none.d-xl-block{ style: 'background: #007bff; color: #fff; padding: 5px; text-align: center;' } XL
  .d-none.d-lg-block.d-xl-none{ style: "background: #27a745; color: #fff; padding: 5px; text-align: center;" } LG
  .d-none.d-md-block.d-lg-none{ style: "background: #ffc108; color: #fff; padding: 5px; text-align: center;" } MD
  .d-none.d-sm-block.d-md-none{ style: "background: #18a2b8; color: #fff; padding: 5px; text-align: center;" } SM
  .d-block.d-sm-none{ style: "background: #dc3545; color: #fff; padding: 5px; text-align: center;" } XS
```
