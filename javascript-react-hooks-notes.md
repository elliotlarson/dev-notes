# React Hooks Notes

## `useState`

This is the new state management technique in React.  Instead of managing a state object, you break your state into individual items and manage them separately.

So, instead of having:

```javascript
state = {
  x: 0,
  y: 0,
};
```

... you would have something like:

```javascript
const [x, setX] = useState(0);
const [y, setY] = useState(0);
```

## `useEffect`

Use effect can help replace your class based component lifecycle methods.  However, it's useful to change how you think of the problem from ensuring things happen when lifecycle events occur, to ensuring things happen when state changes.

Only run the effect when the component first mounts, like `componentDidMount`:

```javascript
useEffect(() => {
  foo();
}, []); // it doesn't depend on any value so only runs once
```

Only run the effect when a value updates, like `componentDidUpdate`:

```javascript
const [myProp, setMyProp] = useState("");
useEffect(() => {
  foo();
}, [myProp]); // it depends on myProp value so only runs when myProp is updated
```

Run the effect every time:

```javascript
useEffect(() => {
  foo();
});
```

Run cleanup function for effect before component is removed from the DOM.  For example, when you've created a subscription of some kind:


```javascript
useEffect(() => {
  foo();
  return () => {
    // some cleanup stuff
  };
});
```

## `useMemo`

This allows you to memoize an expensive value.

Say you have a compontent:

```javascript
function Foo({ someValue }) {
  const expensiveCalculatedValue = expensiveCalculation(someValue);
}
```

... every time the component is re-rendered it is re-caculated.  But, the value only needs to get recalculated when `someValue` changes.

You can use `useMemo` to solve this problem:

```javascript
function Foo({ someValue }) {
  const expensiveCalculatedValue = useMemo(() => {
    expensiveCalculation(someValue);
  }, [someValue]);
}
```

It takes two arguments: 1) a function to execute to get the value, and 2) an array of the values that when changed trigger re-calling the memo function.


## `useCallback`

When you pass a function into another component as a prop, it's probably a good idea to use `useCallback`.  Without it, when React does its shallow props difference checking it isn't able to tell the difference between the previous function it has and the new function.

```javascript
const Bar = React.memo(
  ({ onClick }) => {
    return <div onClick={onClick} />;
  },
);

function Foo() {
  const onClick = (event) => console.log("clicked");
  return <Bar onClick={onClick} />;
}
```

The problem here is that every time `Foo` re-renders `onClick` becomes a new function, even though it hasn't changed.  It occupies a new space in memory on the computer and so when React goes to compare them with `===`, it always returns `false`.

You can solve this problem with `useCallback`.  This will essentially memoize the function and only update it if specified state has changed.


```javascript
const Bar = React.memo(
  ({ onClick }) => {
    return <div onClick={onClick} />;
  },
);

function Foo() {
  const onClick = useCallback((event) => console.log("clicked"), []);
  return <Bar onClick={onClick} />;
}
```

In this case, the function isn't dependent on any state, so I'm passing `[]` as the second argument, which means the function's memoized state only gets set on the first render of the component.
