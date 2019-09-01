# React Performance Notes

## Using JavaScript Performance

```javascript
performance.mark("start")
// ... expensive code
performance.mark("end");
performance.measure("measure expensive code", "start", "end");
console.log(performance.getEntriesByType("measure"));
performance.clearMarks();
performance.clearMeasures();
```

## Using Performance in Node

This is helpful for adding performance to Jest specs that run in a Node environment:

```javascript
const { PerformanceObserver, performance } = require("perf_hooks");

const obs = new PerformanceObserver(items => {
  console.log(items.getEntries()[0].duration);
  performance.clearMarks();
});
obs.observe({ entryTypes: ["measure"] });

performance.mark("start");
// ... expensive code
performance.mark("end");
performance.measure("measurement", "start", "end");
```

## Using the Chrome User Timing API

This follows the same API as the JavaScript `performance` API.  It allows you to view the performance metrics in the Chrome performance timing output.

Add this to your code:

```javascript
performance.mark("start")
// ... expensive code
performance.mark("end");
performance.measure("measure expensive code", "start", "end");
```

Then in the console you can view the output:

```javascript
performance.getEntriesByType('measure');
```

Get the average in the console:

```javascript
arr = performance.getEntriesByType('measure');
average = arr.reduce((partial_sum, a) => partial_sum + a.duration, 0) / arr.length;
```

Clear out the measures in the console:

```javascript
performance.clearMarks();
performance.clearMeasures("measure expensive code")
```
