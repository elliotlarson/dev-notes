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

## Setting up: Typescript, Webpack, Yarn

First create a directory and initialize yarn:

```bash
$ mkdir myApp
$ cd myApp
$ yarn init .
```

Answer some questions that npm will ask you about the app (you can just hit enter all the way through if you like).

Install the necessary packages:

```bash
$ yarn add webpack webpack-dev-server typescript typings ts-loader
```

Setup types for typescript:

```bash
$ node_modules/.bin/typings install dt~es6-shim --global --save
```

Create a `tsconfig.json` file in the root:

```json
{
  "compilerOptions": {
    "target": "es5",
    "module": "commonjs",
    "sourceMap": true
  }
```

Create a `webpack.config.js` file in the root:

```javascript
module.exports = {
  entry: './main',
  output: { filename: 'app.js' },
  module: {
    loaders: [
      {
        test: /.ts$/,
        loader: 'ts-loader'
      }
    ]
  },
  resolve: {
    extensions: ['', '.ts', '.js']
  }
}
```

In your `package.json` make sure you have webpack scripts in place (this is optional):

```json
{
  "scripts": {
    "start": "webpack-dev-server --watch --inline",
    "postinstall": "typings install"
  }
}
```

Add an `index.html` file:

```html
<html>
  <head>
    <title>TypeScript Test Bed</title>
    <script src="app.js"></script>
  </head>
  <body>
  </body>
</html>
```

Add in a `main.ts` file where you can start coding, and then execute:

```bash
$ yarn start
```
