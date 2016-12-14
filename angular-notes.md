# Angular Notes

I'm starting to learn Angular with version 2, so these are Angular 2 notes.

## Angular CLI

### Testing a single file

It looks like the `ng test` command doesn't give you the ability to run specs for a single file, but you can do it with `karma` directly:

First, start the `karma` run with `start`.  This will unfortunately run all of your tests when it starts up:

```bash
$ node_modules/.bin/karma start
```

Then you can run the tests for a single file by calling the `karma run` command with the `--grep` option.  

The string provided for grepping is the top level describe block for the test file you care about.

```bash
$ node_modules/.bin/karma run -- --grep='Todo model'
```

This will only run the test for that file once.  If you want it to run each time the test or implementation file are updated, you can use `nodemon`:

```bash
$ node_modules/.bin/nodemon -x "node_modules/.bin/karma run -- --grep='Emotion model'" -w src/app/models/todo.model.ts -w src/
app/models/todo.model.spec.ts
```

