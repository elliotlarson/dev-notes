# JavaScript Notes

## Typescript class constructors

Typescript will auto assign arguments passed to the constructor as object properties:

```typescript
class Post
  constructor(
    public title: string,
    public content: string,
    public hashTag?: string
  ) { }

let post = new Post('Foo', 'Bar');
console.log(post.title);
// => Foo
console.log(post.content)
// => Bar
console.log(post.hashTag)
// => undefined
```

Notice the use of the optional parameter `hashTag`.

## Typescript destructured object as argument to function with optional types

Sometimes you want to pass an object into a function as an argument and you want to specify some of the object types as optional with default values.  You can do this like so:

```typescript
function foo({ optionOne, optionTwo = '' } : { optionOne: string, optionTwo?: string }): void {
  console.log(`${optionOne} ${optionTwo}`);
}

foo({ optionOne: 'foo', optionTwo: 'bar' });
// => foo bar
foo({ optionOne: 'baz' });
// => baz
```

## Executing a typescript file as a node script

To write a typescript and then have node execute it, you need the [ts-node](https://github.com/TypeStrong/ts-node) library.

```bash
$ sudo npm install -g ts-node
```

Then, say you have a small hello world program `hello-world.ts`:

```typescript
import * as console from 'console';
console.log('hello');
```

You can execute this with:

```bash
$ ts-node hello-world.ts
# => hello
```

## Merging an object into an object

Like you merge in Ruby, you can use the `Object.assign` method:

```typescript
let objectOne = { 'one': 1, 'two': 2 };
let objectTwo = { 'three': 3, 'four' };

let merged = Object.assign(objectOne, objectTwo);
```

This is a variadic method, so you can pass in as many objects as you want.  The values of each object in the chain take precedence over objects that come before it.


## Looping over an object hash

You can grab the keys of the object and then loop over these with a `for of` loop:

```typescript
let myObj = { 'firstName': 'Elliot', 'lastName': 'Larson', 'middleName': 'Gordon' };
let keys = Object.keys(myObj);
for (let key of keys) {
  console.log(myObj[key]);
}
```
