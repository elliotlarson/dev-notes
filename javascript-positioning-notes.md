# JavaScript Positioning Notes

## `offsetParent`

A reference to the nearest parent object in the DOM hierarchy that is "positioned", meaning having a display of absolute, relative, or fixed.

## Offset Top, Left, Width, and Height

`offsetTop`, `offsetLeft`, `offsetWidth`, and `offsetHeight` describe the border box of the current element relative to the `offsetParent`.

## Parents Element Tree

This is a console script allowing you to get the page offset for an element.  Inspect the element first and then run this:

```javascript
child = $0;
op = child.offsetParent;
ops = [{ element: op, offsetLeft: op.offsetLeft, offsetTop: op.offsetTop }];
pageOffsetLeft = op.offsetLeft;
pageOffsetTop = op.offsetTop;
while (op) {
  pageOffsetLeft += op.offsetLeft;
  pageOffsetTop += op.offsetTop;
  op = op.offsetParent;
  if (op) {
    ops.push({ element: op, offsetLeft: op.offsetLeft, offsetTop: op.offsetTop, offsetWidth: op.offsetWidth, offsetHeight: op.offsetHeight });
  }
}
// Then you can look at `ops`, `pageOffsetLeft`, and `pageOffsetTop`
```

Here is the same functionality packaged as a function:

```javascript
function pagePosition(element) {
  let op = element.offsetParent;
  let pageX = 0;
  let pageY = 0;
  while (op) {
    pageX += op.offsetLeft;
    pageY += op.offsetTop;
    op = op.offsetParent;
  }
  return { x: pageX, y: pageY };
}
```

Here's an example of the `ops` output for an app I'm working on:

```text
0: {element: div.graphical-tool__grid-cell__container, offsetLeft: 414, offsetTop: 120}
1: {element: div.graphical-tool__grid-container, offsetLeft: 0, offsetTop: 0, offsetWidth: 1148, offsetHeight: 440}
2: {element: div.drag-and-drop, offsetLeft: 146, offsetTop: 1150, offsetWidth: 1148, offsetHeight: 440}
3: {element: body, offsetLeft: 0, offsetTop: 0, offsetWidth: 1440, offsetHeight: 3506}
```

## `getBoundingClientRect`

Gets the size of the element and its position relative to the viewport.

Here's some example output for an element:

```text
// $0.getBoundingClientRect()
{
  bottom: 254,
  height: 99,
  left: 510,
  right: 559,
  top: 155,
  width: 49,
  x: 510,
  y: 155,
}
```

This element has been brought into view by scrolling down over 1000px.

### Getting the page top and page left, or including scrolling:

You can use the `pageXOffset` or the `pageYOffset` properties to get the current viewport horizontal and vertical scroll value.  They have aliases `scrollX` and `scrollY`, but the page offset functions have greater browser support.

Here is another version of the `pagePosition` method with `getBoundingClientRect`:

```javascript
// pneumonic: gallant bouncing clowns are red
function pagePosition(element) {
  const elPos = element.getBoundingClientRect();
  const pageX = elPos.left + window.pageXOffset;
  const pageY = elPos.top + window.pageYOffset;
  return { x: pageX, y: pageY };
}
```

## Event Positions

This is useful for tracking where clicks and drags happen.

You can track the absolute position of the event in the document with `event.pageX` and `event.pageY`.

And, you can track the relative position of the event in the viewable window with `event.clientX` and `event.clientY`.
