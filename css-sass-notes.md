# Sass Notes

## Doubling up on Specificity

If you are nested and you want double specificity while using the parent character `&`, you can do this:

```sass
.foo {
  &--baz#{&}--biz {
    border-left: 1px solid #fff;
  }
}
```

This will produce this:

```css
.foo--baz.foo--biz {
  border-left: 1px solid #fff;
}
```
