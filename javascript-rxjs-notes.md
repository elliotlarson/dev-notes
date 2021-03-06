# RXJS Notes

> [it is] an API for asynchronous programming with observable streams

A stream can be operated on like an array.  In order to interact with the stream, you can subscribe to it.

Here's a basic example:

```typescript
let source$ = Rx.Observable.interval(400).take(9)
  .map(i => ['1', '1', 'foo', '2', '3', '5', 'bar', '8', '13'][i]);
  
source$.subscribe(x => console.log(x));
```

We create an observable, have it execute every 400 milliseconds for 9 iterations.  Then we map over the observable stream and pull out a relevant array item.  Then we subscribe to the observable stream and `console.log` each item.

Here's a [JS Bin](https://jsbin.com/sazupih/edit?js,console) of this snippet of code.

RX programming also attempts to make it easier to reason about and express asynchronous data stream functionality.

> it provides idiomatic abstractions to treat asynchronous data similar to how you would treat any source of synchronous data, like a simple array.
> it abstracts the notion of time from your code

With RXJS you have a standard flow: 

**producer** (observable) -> **data processing pipeline** (operators) -> **consumer** (observer).

## Solving the promise problem

Promises were created to deal with "callback hell" or a mess of deeply nested callback functions.  Promises give you the ability to move this to a chainable sequence of events tied together with `then` and `catch` statements.

But, promises only react to a single event, not an event stream, like mouse movements or sequences of bytes in a file stream.  And, promises can't be cancelled.

## Creating observables

### `create`

This is a low level method of creating an observable from a datasource.  With `create` you interact with the oberver by calling the `next`, `error` and `complete` methods directly.

```typescript
import { Observable, Observer } from 'rxjs';

let numbers = [1, 5, 10];
let source$ = Observable.create(observer => {
  for (let n of numbers) {
    observer.next(n);
  }
  observer.complete();
});

source$.subscribe(
  value => console.log(value), // next(value)
  e => console.log(e), // error(e)
  () => console.log('complete') // complete()
)
```

**Note**: If the error method is called, the observer will stop.  In this example, the `complete` method will never get called:

```typescript
import { Observable, Observer } from 'rxjs';

let numbers = [1, 5, 10];
let source$ = Observable.create(observer => {
  for (let n of numbers) {
    if (n === 5) {
      observer.error('error: found a 5');
    }
    observer.next(n);
  }
  observer.complete();
});

source$.subscribe(
  value => console.log(value),
  e => console.log(e),
  () => console.log('complete')
)
```

### `of` 

The `of` operator creates an observable sequence from a list of arguments.

```typescript
Rx.Observable.of(1, 2, 3).subscribe(console.log);
// => 1
// => 2
// => 3
```

### `from`

The `from` operator creates an observable sequence from an array or iterable object:

```typescript
Rx.Observable.from([1, 2, 3]).subscribe(console.log);
// => 1
// => 2
// => 3
```

### `fromPromise`

Creates an observable sequence from a promise:

```typescript
Rx.Observable.fromPromise($.getJSON('https://api.github.com/users'))
  .subscribe(console.log);
```

### `fromEvent`

Creates an observable sequence from a DOM event:

```typescript
let btn = document.querySelector('#my-button');
Rx.Observable.fromEvent(btn, 'click')
  .subscribe(_ => console.log('clicked it'));
```

## Creating observers

An observer is just an object that has three methods `next`, `error`, and `complete`.  

### With a class

This is a fairly formal approach, which you are not likely to use most of the time.  However, it's good to see when learning:

```typescript
import { Observable, Observer } from 'rxjs';

let numbers = [1, 5, 10];
let source$ = Observable.from(numbers);

class MyObserver implements Observer<number> {
  next(value) {
    console.log(`value: ${value}`);
  }

  error(message) {
    console.log(`error: ${message}`);
  }

  complete() {
    console.log('complete');
  }
}

source$.subscribe(new MyObserver());
```

### With `subscribe` callback functions

You can also invoke the subscribe function with three function callbacks `next`, `error`, and `complete`:

```typescript
source$.subscribe(
  value => console.log(`value: ${value}`),
  message => console.log(`error: ${message}`),
  () => console.log('complete')
);
```

You can also just pass in a single method for `next`:


```typescript
source$.subscribe(value => console.log(`value: ${value}`));
```

Or, if you just wanted to `console.log` value:

```typescript
source$.subscribe(console.log);
```

## Using operators

There are a slew of operators in RXJS that allow you to setup a data processing pipeline.

### `map`

[`map`](http://reactivex.io/rxjs/class/es6/Observable.js~Observable.html#instance-method-map) allows you to translate a data stream like `map` would help you translate an array.

```typescript
let numbers = [1, 5, 10];
let source$ = Observable.from(numbers).map(n => 2 * n);

source$.subscribe(
  value => console.log(value),
  e => console.log(e),
  () => console.log('complete')
);
// => 2
// => 10
// => 20
// => complete
```

## Resources

* [A great overview as a gist](https://gist.github.com/staltz/868e7e9bc2a7b8c1f754)
