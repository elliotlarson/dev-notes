# RXJS Notes

> Reactive programming is programming with asynchronous data streams. A stream is a sequence of ongoing events ordered in time.  

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

## Solving the promise problem

Promises were created to deal with "callback hell" or a mess of deeply nested callback functions.  Promises give you the ability to move this to a chainable sequence of events tied together with `then` and `catch` statements.

But, promises only react to a single event, not an event stream, like mouse movements or sequences of bytes in a file stream.  And, promises can't be cancelled.

## Resources

* [A great overview as a gist](https://gist.github.com/staltz/868e7e9bc2a7b8c1f754)
