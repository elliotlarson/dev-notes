# React Notes

## Resources

* https://github.com/enaqx/awesome-react

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

You can also shorten this to:

```javascript
const MyComp = props => (
  <h1>Hello, {props.name}!</h1>
);
```

Or even:

```javascript
const MyComp = props => <h1>Hello, {props.name}!</h1>;
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

## Difference between constructor and componentWillMount

You initialize state in the constructor, and do things that have side effects in componentWillMount.

### Constructor

From the docs:

> Avoid introducing any side-effects or subscriptions in the constructor. For those use cases, use componentDidMount() instead.

> The constructor is the right place to initialize state. To do so, just assign an object to this.state; don’t try to call setState() from the constructor. The constructor is also often used to bind event handlers to the class instance.

### componentWillMount

Put AJAX calls here.  Initializer stuff that has side effects

## Loading Component Data/state Via AJAX

Note that the async call will not populate the state until it resolves, which is after the component renders, so you need to setup a default state in your constructor or with React's default props.

```javascript
class Quiz extends Component {
  // Added this:
  constructor(props) {
    super(props);

    // Assign state itself, and a default value for items
    this.state = {
      items: []
    };
  }

  componentWillMount() {
    axios.get('/thedata').then(res => {
      this.setState({items: res.data});
    });
  }

  render() {
    return (
      <ul>
        {this.state.items.map(item =>
          <li key={item.id}>{item.name}</li>
        )}
      </ul>
    );
  }
}
```
