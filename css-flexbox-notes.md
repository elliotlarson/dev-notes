# Flexbox Notes

Flexbox is a new-ish CSS layout system that gives designers greater control over web based layouts.

Lets start with a container and 3 child items in HTML:

```html
<div class="container">
  <div class="item">1</div>
  <div class="item">2</div>
  <div class="item">3</div>
</div>
```

We'll give this some basic styling:

```css
body {
  padding: 20px;
  background: #000;
  font-family: sans-serif;
}

.container {
  background: #343436;
  margin-bottom: 10px;
}

.item {
  background: #e91e63;
  font-size: 16px;
  color: #fff;
  padding: 20px;
  text-align: center;
  border: 1px solid #fff;
}
```

Without flexbox, this will look like:

![alt text](https://raw.githubusercontent.com/elliotlarson/dev-notes/master/img/css-flexbox-notes/01.png?token=AAEe3Uy6GAgMHMNmzPJnZ40-TpAAkur-ks5YjT5EwA%3D%3D "")


## Adding flexbox

You can add flexbox with `display: flex;`:

```css 
.container {
  display: flex;
}
```

This defines the element a flex container and its children as flex items.  The result will look like this:

![alt text](https://raw.githubusercontent.com/elliotlarson/dev-notes/master/img/css-flexbox-notes/02.png?token=AAEe3Ybipmv0qcpK7KuTBzfoQOGY6atOks5YjT_0wA%3D%3D "")

## Using the `flex` property

`flex` is a shorthand property for `flex-grow`, `flex-shrink`, and `flex-basis`.  It is applied to flex items, and is used to specify how it should fill the available space.

If none of these properties is defined, it defaults to `flex: 0 0 auto;`.  This is same as saying `flex: none;`, or just leaving the `flex` property off, like in the previous image of the three pink boxes.

`flex-basis` sets the internal size of the item box.  These rules do the same thing:

```css 
.item {
  flex: 0 0 50px;
}

.item {
  flex-basis: 50px;
}
```

Notice how the width of the boxes increases.

![alt text](https://raw.githubusercontent.com/elliotlarson/dev-notes/master/img/css-flexbox-notes/03.png?token=AAEe3Y3jmXJE44HCYbhaQ72ALVvNzj23ks5YjUWKwA%3D%3D "")

Also, notice how if we change the content of one of the boxes, how all three stay the same height:

![alt text](https://raw.githubusercontent.com/elliotlarson/dev-notes/master/img/css-flexbox-notes/04.png?token=AAEe3dwv7AK-uPMrdgOuZJ0uxM3KNIc9ks5YjUZiwA%3D%3D "")

This is one of the things that is great about flexbox, equal height columns with ease.

## Filling the available space with `flex-grow`

If you set `flex-grow` to `1`, the flex item will fill the available space.  However, notice the difference between the first and second rows in the following images.

![alt text](https://raw.githubusercontent.com/elliotlarson/dev-notes/master/img/css-flexbox-notes/05.png?token=AAEe3YmCkJtWSmrbA5ZpjhobPYbDi7u6ks5YjUohwA%3D%3D "")

To force the flex items to even out irrespective of contents, set the `flex-base` to `0`.

These are essentially the same: 

```css 
.item {
  flex-grow: 1;
  flex-base: 0;
}

.item {
  flex: 1; 
  /* this expands to:
  flex-grow: 1;
  flex-shrink: 1;
  flex-base: 0;
  */
}
```

And the result is:

![alt text](https://raw.githubusercontent.com/elliotlarson/dev-notes/master/img/css-flexbox-notes/06.png?token=AAEe3S79DoSPKBELd76nwEqgbwUmg7Jwks5YjUs8wA%3D%3D "")

