# React Notes

## Basic functional component

```javascript
const Foo = (props) => {
  return <h1>Hello</h1>;
};
```

... or shortified

```javascript
const Foo = props => <h1>Hello</h1>
```

## An object component

```javascript
class Foo extends Component {
  constructor(props) {
    super(props)
    this.state = {
      some: "stuff"
    }
  }

  render() {
    return <h1>Hello</h1>;
  }
}
```

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
