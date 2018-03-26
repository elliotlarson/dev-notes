# React Notes

## Getting console access to a React component

In the React dev-tools Chrome extension, if you select a component and then switch over to the console, you have access to this with the shortcut `$r`.

## Creating a functional component

```javascript
const MyComp = (props) => {
  return (
    <h1>Hello, {props.name}!</h1>
  );
}
```

## Creating a class component

```javascript
class MyComp extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      name: nil,
    };
  }

  render() {
    return (
      <h1>Hello, {this.state.name}!</h1>
    );
  }
}
```
