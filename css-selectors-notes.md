# CSS Selector Notes

## Attribute selector

Has value anywhere in string

```css
[class*="col-"] {
  position: relative;
}
```

Has value that starts with:

```css
[href^="http:"] {
  /* add link image */
}
```

Has value that ends with:

```css
[href$=".pdf"] {
  /* add PDF image */
}
```
