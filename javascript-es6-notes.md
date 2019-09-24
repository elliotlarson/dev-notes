# JavaScript ES6 Notes

## Messing with babel

You can use the `babel-cli` package:

```bash
$ yarn global add babel-cli
```

Then you can use the `babel-node` command.  Say you have a file `index.js`:

```javascript
const fruit = ['apple', 'pear', 'banana', 'orange'];
console.log(fruit);
```

You can output it with:

```bash
$ babel-node index.js
# => ['apple', 'pear', 'banana', 'orange']
```

## Arrow functions

Arrow functions give you a more concise way of writing functions:

```javascript
let names = ['foo', 'bar', 'baz'];

// full function
let greetings = names.map(function(name) {
  return `hello, ${name}`;
});

// arrow function
let greetings = names.map((name) => {
  return `hello, ${name}`;
});

// implicit return arrow function
let greetings = names.map((name) => `hello, ${name}`);
// ... or
let greetings = names.map(name => `hello, ${name}`);
```

Keep in mind that `this` inside a function is the function, but `this` inside an arrow function is the outer scope.

## Template strings

You can now use interpolation with backticks:

```javascript
let greeting = `hello, ${name}`;
```

You can also use backticks to implement multiline strings:

```javascript
let lorem = `
Integer posuere erat a ante venenatis dapibus
posuere velit aliquet. Donec id elit non mi
porta gravida at eget metus.
`;
```

## Hash key value shorthand

If the key and variable name have the same value, you can shorten it:

```javascript
let first_name = 'foo';
let last_name = 'bar';

let person = { first_name: first_name, last_name: last_name };
// can be shortened to
let person = { first_name, last_name };
```

## Destructuring

### Hashes

Let's say you have a person hash:

```javascript
let person = { first_name: 'Joe', last_name: 'Bob' };
let { first_name, last_name } = person;
```

You can use defaults when destructuring:

```javascript
const settings = { width: '400px', height: '200px', color: '#f06' };
const { width = '500px', height = '250px' } = settings;
```

You can also rename the destructured values:

```javascript
const settings = { width: '400px', height: '200px' };
const { w: width = '500px' } = settings;
```

### Arrays

You can also destructure arrays:

```javascript
const person = ['Joe', 'Bob', 'joe.bob@example.com'];
const [first_name, last_name, email] = person;
```

### The rest operator

You can get the last variable (the rest of) number of items from an array when destructuring:

```javascript
const team = ['Elliot', 'Arum', 'Bumby', 'Maddie', 'Bob the plant'];
const [dad, mom, ...dependents] = team;
// here dependents = ['Bumby', 'Maddie', 'Bob the plant']
```

### Swapping variables

You can swap variables using array destructuring:

```javascript
let first = 'Jim'
let last = 'Flo'
[first, last] = [last, first];
```

### Destructuring in function calls

You can approximate Ruby's named parameters feature by passing in an object argument to a function which you destructure on the spot:

```javascript
function tipCal({ total, tip = 0.20, tax = 0.13 }) {
  return total + tip * total + tax * total;
}
tipCal({ tip: 0.15, total: 200 });
tipCal({ total: 100 });
```

If you want to be able to potentially pass in nothing, you can make the object argument default to empty object:

```javascript
function tipCal({ total = 200, tip = 0.20, tax = 0.13 } = {}) {
  return total + tip * total + tax * total;
}
tipCal();
```

## Iteration

### Problems with existing iteration approaches

When using the array `forEach` you can use `break` or `continue`:

```javascript
const fruits = ['apple', 'orange', 'banana', 'mango'];
fruits.forEach((fruit) => {
  if (fruit == 'banana') {
    continue;
  }
});
// => results in a SyntaxError: Illegal continue statement
```

The for-in approach will iterate over everything in the array, not just items in the collection.

```javascript
const fruits = ['apple', 'orange', 'banana', 'mango'];
Array.prototype.foo = function() {}
for (const index in fruits) {
  console.log(fruits[index]);
}
// => this will output all of the items, but also the foo function so,
//    the last item output to the console will be `function() { }`
```

### Iteration with the for-of loop

For-of gives you the best of all worlds when iterating.

```javascript
const fruits = ['apple', 'orange', 'banana', 'mango'];
for (const fruit of fruits) {
  console.log(fruit);
  if (fruit == 'banana') {
    break;
  }
}
```

To emulate Ruby's `each_with_index` you can use the `entries` iterator directly (for-of uses this under the hood if just given an array) and destructuring:

```javascript
const fruits = ['apple', 'orange', 'banana', 'mango'];
for (const [i, fruit] of fruits.entries()) {
  console.log(i, fruit);
}
```

Iterating over a hash with for-of:

```javascript
const fruits = { name: 'apple', crunchy: true, color: 'red' };
for (const key of Object.keys(fruits)) {
  const value = fruits[key];
  console.log(key, value);
}
```

Iterating over objects with for-of and Object.entries:

```javascript
const fruits = { name: 'apple', crunchy: true, color: 'red' };
for (const [key, value] of Object.entries(fruits)) {
  console.log(key, value);
}
```

Iterating over objects with for-in:

```javascript
const fruits = { name: 'apple', crunchy: true, color: 'red' };
for (const key in fruits) {
  const value = fruits[key];
  console.log(key, value);
}
```

## Array.from

There are times where you get something that is array-like, for example when you get a list of nodes from the DOM:

```javascript
<p>Jim</p>
<p>Joe</p>
<p>Bob</p>
```

Let's say we get the list of nodes like so:

```javascript
const namePTags = document.querySelectorAll('p');
const names = namePTags.map(namePTag => namePTag.textContent);
```

This would result in an error of `namePTags.map is not a function`.  The reason is that the collection of `namePTags` is not an array, it is a `Nodelist`.  This doesn't have all of the same methods as an array.

To convert this to an array:

```javascript
const namePTags = document.querySelectorAll('p');
const namePTagsArray = Array.from(namePTags);
const names = namePTagsArray.map(namePTagItem => namePTagItem.textContent);
```

Array.from also takes a second argument, a map function.  So the previous example could be reduced to:

```javascript
const namePTags = document.querySelectorAll('p');
const names = Array.from(namePTags, namePTagItem => namePTagItem.textContent);
```

## Array.of

This just takes a list of arguments and creates an array from them:

```javascript
const names = Array.of('Jim', 'Joe', 'Bob');
```

## Working with arrays

### Removing an element from an array

You can find the index of the item you want to remove and then `splice` it out.

```javascript
let fruit = ['apple', 'pear', 'banana', 'orange'];
const bananaIndex = fruit.findIndex((f) => f === 'banana');
fruit.splice(bananaIndex, 1);
console.log(fruit); // => ['apple', 'pear', 'orange']
```

As you can see `splice` is destructive.

### See if all array items match a condition

```javascript
const numbers = [1, 2, 3, 4];
const allPositive = numbers.every((n) => n > 0);
console.log(allPositive); // => true
```

### Selecting elements in an array that match a condition

```javascript
let fruit = ['apple', 'pear', 'banana', 'orange'];
let inFridge = ['pie', 'apple', 'cheese', 'bread'];
let fruitInFridge = inFridge.filter((f) => fruit.includes(f));
console.log(fruitInFridge); // => ['apple']
```

### Iterate `n` times

```javascript
Array.from(Array(3)).map((_, i) => i);
//=> [0, 1, 2]
```

According to a Stack Overflow answer, this is more performant:

```javascript
Array.from({ length: 3 }).map((_, i) => i);
//=> [0, 1, 2]
```

You could also use Underscore's `times` method if you are just doing a `forEach` iteration.

```javascript
_.times(n, () => {
  // some logic
});
```
