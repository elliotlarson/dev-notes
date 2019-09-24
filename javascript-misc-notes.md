# JavaScript Misc Notes

## Console table

You can output a hash as a table in the browser console with `console.table`:

```javascript
const inventors = [
  { first: 'Albert', last: 'Einstein', year: 1879 },
  { first: 'Isaac', last: 'Newton', year: 1643 },
  { first: 'Galileo', last: 'Galilei', year: 1564 },
];
console.table(inventors);
```

## Copying an object printed out in the console

You can right click an object in the console and select the menu option `store as global variable`.

This will output a variable like `temp1` to the console.

You can then `JSON.stringify(temp1)`.

## Create a random number between 2 numbers

```javascript
function randomIntFromInterval(min, max) { // min and max included
  return Math.floor(Math.random() * (max - min + 1) + min);
}
```

## Get a random item from an array

```javascript
myArray[Math.floor(Math.random() * myArray.length)];
```
