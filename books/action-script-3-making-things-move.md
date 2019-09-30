# ActionScript 3 Making Things Move

Porting examples to JavaScript.

## Radians and Degrees

```javascript
const radians = degrees * Math.PI / 180;
```

```javascript
const degrees = radians * 180 / Math.PI;
```

Common radians:

* **0 or 360 degrees**: `2 * Math.PI`
* **30 degrees**: `Math.PI / 6`
* **45 degrees**: `Math.PI / 4`
* **60 degrees**: `Math.PI / 3`
* **90 degrees**: `Math.PI / 2`
* **120 degrees**: `(2 * Math.PI) / 3`
* **135 degrees**: `(3 * Math.PI) / 4`
* **150 degrees**: `(5 * Math.PI) / 6`
* **180 degrees**: `Math.PI`
* **210 degrees**: `(7 * Math.PI) / 6`
* **225 degrees**: `(5 * Math.PI) / 4`
* **240 degrees**: `(4 * Math.PI) / 3`
* **300 degrees**: `(5 * Math.PI) / 3`
* **315 degrees**: `(7 * Math.PI) / 4`
* **330 degrees**: `(11 * Math.PI) / 6`

Note that because the coordinate system starts with 0,0 at the top left corner of the screen, the angles appear to be mirrored.  For example, 45 degrees is actually in the bottom right quadrant of the circle in the world of Flash (really the world of the web).

## Sine and Cosine

**Sine** = the ratio of the opposite leg to the hypotenuse
**Cosine** = the ratio of the adjacent leg to the hypotenuse

```javascript
let angle = 0;
const angleIncrement = 15;
const sohcahs = [];
while (angle <= 360) {
  sohcahs.push({
    degrees: angle,
    radians: angle * Math.PI / 180,
    sine: Math.sin(angle),
    cosine: Math.cos(angle),
  });
  angle += angleIncrement;
}
console.table(sohcahs);
copy(JSON.stringify(sohcahs));
```

| degrees | radians            | sine                 | cosine                |
|---------|--------------------|----------------------|-----------------------|
| 0       | 0                  | 0                    | 1                     |
| 15      | 0.2617993877991494 | 0.6502878401571168   | -0.7596879128588213   |
| 30      | 0.5235987755982988 | -0.9880316240928618  | 0.15425144988758405   |
| 45      | 0.7853981633974483 | 0.8509035245341184   | 0.5253219888177297    |
| 60      | 1.0471975511965976 | -0.3048106211022167  | -0.9524129804151563   |
| 75      | 1.3089969389957472 | -0.38778163540943045 | 0.9217512697247493    |
| 90      | 1.5707963267948966 | 0.8939966636005579   | -0.4480736161291702   |
| 105     | 1.8325957145940461 | -0.9705352835374847  | -0.24095904923620143  |
| 120     | 2.0943951023931953 | 0.5806111842123143   | 0.8141809705265618    |
| 135     | 2.356194490192345  | 0.08836868610400143  | -0.9960878351411849   |
| 150     | 2.6179938779914944 | -0.7148764296291646  | 0.6992508064783751    |
| 165     | 2.8797932657906435 | 0.9977972794498907   | -0.06633693633562374  |
| 180     | 3.141592653589793  | -0.8011526357338304  | -0.5984600690578581   |
| 195     | 3.4033920413889422 | 0.21945466799406363  | 0.9756226979194443    |
| 210     | 3.6651914291880923 | 0.46771851834275896  | -0.8838774731823718   |
| 225     | 3.9269908169872414 | -0.9300948780045254  | 0.36731936773024515   |
| 240     | 4.1887902047863905 | 0.9454451549211168   | 0.32578130553514806   |
| 255     | 4.4505895925855405 | -0.5063916349244909  | -0.8623036078310824   |
| 270     | 4.71238898038469   | -0.1760459464712114  | 0.9843819506325049    |
| 285     | 4.97418836818384   | 0.7738715902084317   | -0.6333425312327234   |
| 300     | 5.235987755982989  | -0.9997558399011495  | -0.022096619278683942 |
| 315     | 5.497787143782138  | 0.7451332645574127   | 0.6669156003948422    |
| 330     | 5.759586531581287  | -0.13238162920545193 | -0.9911988217552068   |
| 345     | 6.021385919380437  | -0.5439958173735323  | 0.8390879278598296    |
| 360     | 6.283185307179586  | 0.9589157234143065   | -0.2836910914865273   |

## Tangent

The ratio of the opposite leg over the adjacent leg.

## Arcsine, arccosine, and arctangent

These are the opposite functions for sine, cosine, or tangent.  With these you provide the ratio to the function and get back the angle.

## Converting between the two

You use sine and cosine to get the x and y position if you have an angle.  And, you use arctangent `atan2` to get the angle if you have the x and y.

## Get the rotation angle between two points

```javascript
const one = { x: 100, y: 100 };
const two = { x: 500, y: 500 };
const dx = one.x - two.x;
const dy = one.y - two.y;
const angle = Math.atan2(dx, dy);
```

## Get the distance between two points

```javascript
const one = { x: 100, y: 100 };
const two = { x: 500, y: 500 };
const dx = one.x - two.x;
const dy = one.y - two.y;
const distance = Math.sqrt(dx * dx, dy * dy); // Pythagorean
```

