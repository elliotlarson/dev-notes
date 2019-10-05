# OpenLayers Notes

Using the OpenLayers framework for generating interactive maps using 3rd party map tile services.

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
    key: "As1EYRAwzuKhOXFnoKIqB2xj9eFPl6anDISd6H7bTg5Eaky8AUqG4Wlgii1b8fK_",
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
