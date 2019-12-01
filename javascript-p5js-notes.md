# P5js Notes

## Working with the pixel array

Pixel values for the image on the screen are stored in a one dimensional array.  However, we think of things in terms of their two dimensional position.

For example, say we have a 5 x 5 pixel image.

```text
  0 1 2 3 4
 ┌─┬─┬─┬─┬─┐
 ├─┼─┼─┼─┼─┤
 ├─┼─┼─┼─┼─┤
 ├─┼─┼─┼─┼─┤
 ├─┼─┼─┼─┼─┤
 └─┴─┴─┴─┴─┘
```

We may want to work with pixel that at 4 on the x axis and 4 on the y axis.  In the single dimensional image array each pixel takes up 4 spaces:

* 0 = red color (0 to 255)
* 1 = green color
* 2 = blue color
* 3 = alpha

The formula for converting between the x,y coordinate and the single dimension array is:

```javascript
const density = p5.pixelDensity();
const numberPixel = x + y * width;
const index = numberPixel * 4;
```

Say we want the index for the cell at:

* `3,0`: this would be `(3 + 0 * 5) * 4 = 12`
* `1,1`: this would be `(1 + 1 * 5) * 4 = 20`
* `4,2`: this would be `(4 + 2 * 5) * 4 = 56`

## Output the frame rate

It can be helpful to see how your performance is in the current sketch while stuff is happening.  To do this:

```javascript
// Outside your setup function
let frameRateDiv;

// In your setup function
frameRateDiv = document.createElement("div");
frameRateDiv.style = "position: absolute; bottom: 5px; left: 5px; color: #fff;";
document.body.appendChild(frameRateDiv);

// Then in your draw function
frameRateDiv.innerHTML = Math.floor(p5.frameRate());
```
