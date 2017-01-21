# Flexbox Notes

Flexbox is a new-ish CSS layout system that gives designers greater control over web based layouts.

Lets start with a container and 3 child items in HTML:

```html
<div id="container">
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

#container {
  background: #343436;
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

This will look like:

<p data-height="250" data-theme-id="0" data-slug-hash="WRjRZy" data-default-tab="result" data-user="elliotlarson" data-embed-version="2" data-pen-title="WRjRZy" class="codepen">See the Pen <a href="https://codepen.io/elliotlarson/pen/WRjRZy/">WRjRZy</a> by Elliot Larson (<a href="http://codepen.io/elliotlarson">@elliotlarson</a>) on <a href="http://codepen.io">CodePen</a>.</p>
<script async src="https://production-assets.codepen.io/assets/embed/ei.js"></script>
