# React Notes

## `React.Fragment`

Components do not allow you to have sibling elements at the root level.  There needs to be a single root element:

```javascript
// does not work
const Foo = () => {
  return (
    <p>one</p>
    <p>two</p>
  );
};

// but this does work
const Foo = () => {
  return (
    <div>
      <p>one</p>
      <p>two</p>
    </div>
  );
};
```

But now you have a dummy div in your markup that you don't need.

You can do this instead and no root level element will be rendered.

```javascript
const Foo = () => {
  return (
    <React.Fragment>
      <p>one</p>
      <p>two</p>
    </React.Fragment>
  );
};
```
