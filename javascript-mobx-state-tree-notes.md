# MobX State Tree

## Installation (with React)

```bash
$ yarn add mobx mobx-react mobx-state-tree
```

Or, use `mobx-react-lite` instead of `mobx-react`: https://github.com/mobxjs/mobx-react-lite

> This is a lighter version of mobx-react which supports React functional components only and as such makes the library slightly faster and smaller (only 1.5kB gzipped). In fact mobx-react@6 has this library as a dependency and builds on top of it.

## React and MST

> To share MST trees between components we recommend to use React.createContext.

example: https://github.com/impulse/react-hooks-mobx-state-tree

```javascript
import { observer } from 'mobx-react-lite';
const UserOrderInfo = observer(() => {
  const { user, order } = useStores();
  return (
    <div>
      {user.name} has order {order.id}
    </div>
  )
});
```

## Connecting Redux Dev Tools

```javascript
import React from "react"
import { render } from "react-dom"
import App from "./containers/App"
import "todomvc-app-css/index.css"

import { Provider } from "react-redux"
import todosFactory from "./models/todos"
import { asReduxStore, connectReduxDevtools } from "mst-middlewares"

const initialState = {
  todos: [
    {
      text: "learn Redux",
      completed: false,
      id: 0
    }
  ]
}
const todos = (window.todos = todosFactory.create(initialState))
const store = asReduxStore(todos)
connectReduxDevtools(require("remotedev"), todos)

render(
  <Provider store={store}>
    <App />
  </Provider>,
  document.getElementById("root"),
)
```

## Models


