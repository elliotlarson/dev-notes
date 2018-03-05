# Jest Notes

## When testing React app created with `create-react-app`

Run the specs with:

```bash
$ node --inspect-brk node_modules/.bin/jest --runInBand
```

Add this config to VSCode:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Debug CRA Tests",
      "type": "node",
      "request": "launch",
      "runtimeExecutable": "${workspaceRoot}/node_modules/.bin/react-scripts",
      "args": ["test", "--runInBand", "--no-cache", "--env=jsdom"],
      "cwd": "${workspaceRoot}",
      "protocol": "inspector",
      "console": "integratedTerminal",
      "internalConsoleOptions": "neverOpen"
    }
  ]
}
```

Then click play in the debugger.

## Running a single test

Postfix `test` or `it` with `.only`:

```javascript
test.only('foo', () => {
  expect('foo').toEqual('foo');
});
```

You also need to pass the single filename to jest.  With CreateReactApp:

```bash
$ yarn test my-file.spec.js
```
