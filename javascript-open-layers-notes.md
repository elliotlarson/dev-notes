# OpenLayers Notes

Using the OpenLayers framework for generating interactive maps using 3rd party map tile services.

## Common API Doc Pages and Pages of Interest

* **FAQ**: https://openlayers.org/en/latest/doc/faq.html
* **Map**: https://openlayers.org/en/latest/apidoc/module-ol_Map-Map.html
* **View**: https://openlayers.org/en/latest/apidoc/module-ol_View-View.html

## Adding mapping provider layers

Tile layers can be added to the `layers` array in the map constructor

```javascript
const map = new Map({
  target: mapTarget,
  layers: ["<your layer here>"],
  view: new View({
    center: fromLonLat([-122.48978700000004, 37.788080312312744]), // lng, lat (x, y)
    zoom: 22,
  }),
});
```

### The Bing tile layer

```javascript
import BingMaps from "ol/source/BingMaps";

const layer = new TileLayer({
  visible: true,
  preload: Infinity,
  source: new BingMaps({
    key: "",
    imagerySet: "AerialWithLabelsOnDemand",
    // use maxZoom 19 to see stretched tiles instead of the BingMaps
    // "no photos at this zoom level" tiles
    // maxZoom: 19
  }),
});
```

### Using the Stamen Design watercolor tile

```javascript
import Stamen from "ol/source/Stamen";

const layer = return new TileLayer({
  source: new Stamen({
    layer: "watercolor",
  }),
});
```

## Rotation

You can either rotate immediately with the `setRotation` method, or you can use `animate`:

```javascript
const radians = (degrees * Math.PI) / 180;
const view = map.getView();

const currentRotation = view.getRotation();
const newRotation = currentRotation + radians;

// view.setRotation(newRotation);
view.animate({
  rotation: newRotation,
  duration: 300,
});
```

### Turning off snapping

The rotation is set to snap at around 0 degrees (not sure of the threshold), which can result in some oddities when animating the rotation.  It can also make rotation to degrees less than or equal to the snap amount appear to not work.

To turn off this snapping behavior, add `constrainRotation: false` to the view constructor.

```javascript
const map = new Map({
  target: mapTarget,
  layers: ["<your layer here>"],
  view: new View({
    center: fromLonLat([-122.48978700000004, 37.788080312312744]), // lng, lat (x, y)
    zoom: 22,
    constrainRotation: false,
  }),
});
```

## Removing default controls

If you don't pass any controls into the constructor for the map, it assumes you want to use the default controls.  To disable this add `controls: []` to the map initializer:

```javascript
const map = new Map({
  target: mapTarget,
  layers: [bingLayer],
  view: new View({
    center: fromLonLat([-122.48978700000004, 37.788080312312744]), // lng, lat (x, y)
    zoom: 22,
    constrainRotation: false,
  }),
  controls: [], // Controls initially added to the map. If not specified, module:ol/control~defaults is used.
});
```

## Adding a map event

You can assign an event handler to the map.

Here are some of the events you can assign:

* **click**: A click with no dragging. A double click will fire two of this.
* **dblclick**: A true double click, with no dragging.
* **error**: Generic error event. Triggered when an error occurs.
* **moveend**: Triggered after the map is moved.
* **movestart**: Triggered when the map starts moving.
* **pointerdrag**: Triggered when a pointer is dragged.
* **pointermove**: Triggered when a pointer is moved. Note that on touch devices this is triggered when the map is panned, so is not the same as mousemove.

A full list of events can be found here: https://openlayers.org/en/latest/apidoc/module-ol_Map-Map.html

```javascript
// the event object contains additional map related information, like `coordinate`:
map.on("click", (event) => {
  console.log(`map click: ${event.coordinate}`);
})
```

## Adding polygon drawing to map

You need to add a vector layer and a drawing interaction to the map.

```javascript
import VectorLayer from "ol/layer/Vector";
import { Draw, Modify, Snap } from "ol/interaction";
import { Fill, Stroke, Style } from "ol/style";
import VectorSource from "ol/source/Vector";

const vectorSource = new VectorSource();
const vectorLayer = new VectorLayer({
  source: vectorSource,
  style: new Style({
    fill: new Fill({
      color: "rgba(255, 255, 255, 0.2)",
    }),
    stroke: new Stroke({
      color: "#ffcc33",
      width: 2,
    }),
  }),
});

const modify = new Modify({ source: vectorSource });
map.addInteraction(modify);

const draw = new Draw({ source: vectorSource, type: typeSelect.value });
map.addInteraction(draw);

const snap = new Snap({ source: vectorSource });
map.addInteraction(snap);
```

If you need to remove the draw and snap interactions:

```javascript
map.removeInteraction(draw);
map.removeInteraction(snap);
```

## Get current lat and lng

After the map gets loaded the user may pan to a different position.  You may want to save this position and use it the next time you render the map.

```javascript
// in projection units
map.getView().getCenter();
```

This outputs values using the current projection.  For me, this defaulted to `EPSG:3857`.  See [What projection is OpenLayers using?](https://openlayers.org/en/latest/doc/faq.html#what-projection-is-openlayers-using-) for a little more info.

You can get your current projection with:

```javascript
map.getView().getProjection();
```

To output the center in lng and lat:

```javascript
import { transform } from "ol/proj";

transform(map.getView().getCenter(), "EPSG:3857", "EPSG:4326");
```

## Get the current zoom for the map

```javascript
map.getView().getZoom();
```

## Get the meters per pixel at the current zoom level

Perhaps common sense, but as you zoom out this number gets bigger.  As you zoom in it gets smaller.

```javascript
map.getView().getResolution()
```

## Showing and hiding a vector layer

You can assign a property to the vector layer that makes it easy to pluck out of an array:

```javascript
myVectorLayer.set("dataType", "FOO");
```

Then you can look for this layer by finding on the layers added to the map:

```javascript
// getLayers returns an OL Collection object which doesn't directly support `find`
const myVecLayer = map.getLayers().getArray().find((l) => l.get("dataType") === "FOO")
```

Then you can turn its visibility off and on:

```javascript
myVecLayer.setVisibility(false); // or true
```

## Getting data for drawn features

Output the lat and long points for a drawn polygon.  This outputs an array of shapes.  Each shape is an array of points.  Each point is an array of lng, lat pairs.

```javascript
const features = this.vectorSource.getFeatures();
features.forEach(feature => {
  console.log(feature.getGeometry().getCoordinates());
});
```

**Note**: this will output the coordinates in the current project's values.

To output the values in lng and lat:

```javascript
import { transform } from "ol/proj";

function projectionToLngLat(point) {
  return transform(point, "EPSG:3857", "EPSG:4326");
}

const features = this.vectorSource.getFeatures().map(feature => {
  return feature
    .getGeometry()
    .getCoordinates()
    .map(featureCoordinates => featureCoordinates.map(projectionToLngLat));
});
```

You can also use the utility method `toLonLat`:

```javascript
import { toLonLat } from "ol/proj";

const features = this.vectorSource.getFeatures().map(feature => {
  return feature
    .getGeometry()
    .getCoordinates()
    .map(featureCoordinates => featureCoordinates.map(c => toLonLat(c)));
});
```

## Loading Data for Feature

Say you've stored some lon lat coordinates for a polygon in the database and you're trying to load this data while initializing:

```javascript
const polygonName = "Roof Section # 1";
const lonLatCoordinates = [
  [-122.4898787094275, 37.78816778207835],
  [-122.48986658163463, 37.78818046427956],
  [-122.48978508509853, 37.78818754452024],
  [-122.4897285622106, 37.788152931313164],
  [-122.48983963668286, 37.78814423471637],
  [-122.4898787094275, 37.78816778207835],
];
// Translate to projection coordinates
const coordinates = lonLatCoordinates.map(c => fromLonLat(c));
const geometry = new Polygon([coordinates]);
const feature = new Feature({ geometry, name: polygonName })
```

Then you can either add the feature to the layer source during initialization:

```javascript
const vectorSource = new VectorSource({ features: [feature] });
```

... or you can add it after the fact with a setter:

```javascript
vectorSource.addFeature(feature);
```

## Deleting a selected polygon

Let's say you want to do this when the user hits the backspace/delete key:

You need the event handler function to have access to:

* The `select` interaction to get the selected features (polygon) from
* The `vector source` to remove the feature (polygon) from

```javascript
document.addEventListener("keydown", event => {
  if (event.key === "Backspace") {
    const features = select.getFeatures().getArray();
    features.forEach(feature => vectorSource.removeFeature(feature));
  }
});
```

## Complete drawing polygon when hitting escape key

This can be helpful to speed up the creation, but also in allowing users to get out of creating a polygon that they didn't mean to start.

You can figure out if the polygon is essentially a straight line (i.e. user dropped a point when they didn't mean to and completed the polygon by hitting escape), by looking at the area.  If the area is 0, then we have a line instead of a polygon shape and we can just remove it.

You need the event handler function to have access to:

* The `draw` interaction to call `finishDrawing` on
* The `vector source` to remove the feature (polygon) from if it has no area

```javascript
document.addEventListener("keydown", event => {
  if (event.key === "Escape" && draw) {
    draw.finishDrawing();

    // If we end up with a line, remove it
    const features = vectorSource.getFeatures();
    const lastFeature = features[features.length - 1];
    if (lastFeature.getGeometry().getArea() === 0) {
      vectorSource.removeFeature(lastFeature);
    }
  }
});
```

## Styles

You can add custom styling to vector features.

### Default styling

If you don't supply any styling, the default is used:

```javascript
import {Fill, Stroke, Circle, Style} from 'ol/style';

const fill = new Fill({
  color: 'rgba(255,255,255,0.4)'
});
const stroke = new Stroke({
  color: '#3399CC',
  width: 1.25
});
const styles = [
  new Style({
    image: new Circle({
      fill: fill,
      stroke: stroke,
      radius: 5
    }),
    fill: fill,
    stroke: stroke
  })
];
```

## Manually trigger style function to get called

If you call the `changed` method on a feature it will result in OL calling the style function for the feature again:

```javascript
featuresVectorSource.getFeatures().forEach((f) => f.changed());
```
