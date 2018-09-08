# CSS Float Notes

Basic float grid.  You might do something like:

```html
<div class="row">
  <div class="col-1"></div>
  <div class="col-1"></div>
  <div class="col-1"></div>
  <div class="col-1"></div>
</div>
```

```css
/* row handles clearing */
.row::after {
  content: "";
  display: table;
  clear: both;
}

.col-1 {
  float: left;
  margin-left: 4%;
  width: 20%;
}

/* you can also use an attribute selector to select all "col-" elements */
[class*='col-'] {
  width: 92%;
  margin-left: 4%;
  margin-right: 4%;
  min-height: 1px;
}
```
