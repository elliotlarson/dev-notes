# VSCode Notes

## Setting up a command with a keyboard shortcut

For example, say we want `$ gulp test` to run when we use the keyboard combination `cmd+shift+t`:

Go to the tasks menu and click on "configure tasks".  If there are tasks available, a list will show up.  In my JavaScript project, I see a number of gulp tasks, and I pick "gulp test".

This opens up the `tasks.json` file with:

```json
{
  // See https://go.microsoft.com/fwlink/?LinkId=733558
  // for the documentation about the tasks.json format
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Run tests",
      "type": "gulp",
      "task": "test",
      "problemMatcher": [],
    }
  ]
}
```

I changed "label" to be "Run gulp tests".

Then go into key bindings and open the `keybindings.json` file and add the following

```json
{
  {
    "key": "cmd+shift+T",
    "command": "workbench.action.tasks.runTask",
    "args": "Run gulp tests",
  }
}
```

Adding RSpec tasks to Rails project (you need to source the .zshrc first):

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Run tests",
      "type": "shell",
      "command": ". ~/.zshrc && ./bin/rspec ${relativeFile}",
    },
    {
      "label": "Run tests at line",
      "type": "shell",
      "command": ". ~/.zshrc && ./bin/rspec ${relativeFile}:${lineNumber}",
    },
  ]
}
```
