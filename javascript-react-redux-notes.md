# React Redux Notes

## Resources

* Code for todo tutorial from Redux site: https://github.com/reactjs/redux/tree/master/examples/todos/src

## Actions

These are payloads of information that state which reducer functionality to call in order to change the state of the store and the necessary information to make the change.

```javascript
{
  type: 'ADD_TODO',
  text: 'Get that shit done',
}
```

In Redux, it's common to use a constant for the action name to help reduce typos while developing:

```javascript
const ADD_TODO = 'ADD_TODO'
{
  type: ADD_TODO,
  text: 'Get that shit done',
}
```

It's common to wrap these payloads in functions called **action creators**.

```javascript
function addTodo(newTodoText) {
  return {
    type: ADD_TODO,
    text: newTodoText,
  };
}

// ... or
const addTodo = (newTodoText) => ({
  type: ADD_TODO,
  text: newTodoText,
});
```

## Reducers

These are pure functions that take in the existing state for an app (the store) and an action that descibes how to change the state.  The state is not mutated, rather the reducer assembles a new version of the state tree and returns it.

```javascript
function todosReducer(state = [], action) {
  switch (action.type) {
    case ADD_TODO:
      return [
        ...state,
        {
          id: todoIds++,
          text: action.text,
          completed: false,
        }
      ];
    default:
      return state;
  }
}
```

You often break reducers into individual reducer functions for each piece of application state.  Then you combine the reducers into a single reducer function using Redux's `combineReducers`:

```javascript
import { combineReducers } from 'redux';

const appReducer = combineReducers({
  todosReducer,
  todosFilterReducer,
});
```

## The Store

The store holds the current state of the application and handles dispatching actions to reducers.

```javascript
import { createStore } from 'redux';

const store = createStore(appReducer);

// dispatching an action
store.dispatch(addTodo('Find derelict spacecraft on planet surface'));
```

You can also subscribe and unsubscribe from the store:

```javascript
const unsubscribe = store.subscribe(() =>
  console.log(store.getState());
);

// do some stuff with the store, and then later you can unsubscribe
unsubscribe();
```

## Connecting to React

In order to give components access to the store, you need to wrap your toplevel component with `Provider`:

```javascript
import { Provider } from 'react-redux';
import { createStore } from 'redux';

const initialState = {
  todos: [
    { id: 1, text: 'Get some milk', completed: false },
  ],
};

// passing in some initial state to hydrate the app
const store = createStore(appReducer, initalState);

render(
  <Provider store={store}>
    <App />
  </Provider>,
  document.getElementById('root')
)
```

Implementing Redux in React involves wrapping a presentational component using the Redux `connect` function.  This creates a "smart" or "container" component.

To map state from the store to the component props, you create a `mapStateToProps` function:

```javascript
const mapStateToProps = (state) => {
  return {
    todos: state.todos,
  };
};
```

To map actions creator functions to your component's props, you create a `mapDispatchToProps` function:

```javascript
import { toggleTodo } from '../actions';

const mapDispatchToProps = (dispatch) => {
  return {
    onTodoClick: (id) => {
      dispatch(toggleTodo(id))
    },
  };
};
```

You can also make this more succinct with `bindActionCreators`:

```javascript
import { bindActionCreators } from 'redux';
import * as actions from './actions';

const mapDispatchToProps = (dispatch) => {
  return bindActionCreators({
    addTodo: actions.addTodo,
    updateTodo: actions.updateTodo,
    toggleTodoCompleted: actions.toggleTodoCompleted,
    deleteTodo: actions.deleteTodo,
  }, dispatch);
};
```

... or, you can make this event *more* succinct with:

```javascript
import * as actions from './actions';

// This requires that you have named action exports like:
// export const addTodo = (newTodoText) => ({
//   type: ADD_TODO,
//   payload: { text: newTodoText },
// });

const mapDispatchToProps = (dispatch) => bindActionCreators(actions, dispatch);
```

Then you pass these to the Redux `connect` function, which returns a function you immediately call with your presentational component you are trying to wrap to create a "smart" component.

```javascript
const SmartTodoList = connect(mapStateToProps, mapDispatchToProps)(TodoList);
```
