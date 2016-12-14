# RXJS Notes

> Reactive programming is programming with asynchronous data streams. A stream is a sequence of ongoing events ordered in time.  

A stream can be operated on like an array.  In order to interact with the stream, you can subscribe to it.

Here's a basic example:

```typescript
let source$ = Rx.Observable.interval(400).take(9)
  .map(i => ['1', '1', 'foo', '2', '3', '5', 'bar', '8', '13'][i]);
  
source$.subscribe(x => console.log(x));
```

## Resources

* [A great overview as a gist](https://gist.github.com/staltz/868e7e9bc2a7b8c1f754)
