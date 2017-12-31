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