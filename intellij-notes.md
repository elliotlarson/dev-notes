# Intellij Notes

## Keyboard Shortcuts

### Generate Interface Methods

If you are inside a class the implements an interface, you can ask Intellij to do it for you with `ctrl` + `i`.  With the vim plugin installed, there's a conflict here.  I've remapped this to `ctrl` + `cmd` + `i`.

1. Editor > keymap
1. Search for implementation
1. Double click on "Implement Methods" and choose "Add keyboard shortcut"

### Generate Setters and Getters

Create properties in the class, like so:

```java
private String foo;
```

Then with the keyboard combo, `cmd` + `n`, a dialog will appear, with options for auto generating getters and setters.

## Snippets

* `sout` = `System.out.println();`
* `psvm` = `public static void main(String[] args) {}`

## Add Maven dependency

You can have IntelliJ bring in a dependency for you.  Open the `pom.xml` file and hit `cmd` + `n`, and select the `dependency` option.

If "search for artifacts" is empty or mostly empty, you may need to update your local repos.  `Settings` > `Build, Execution, Deployment` > `Build Tools` > `Maven` > `Repositories`.  Click on the one that says `https://repo.maven.apache.org/maven2` to select it and then click th `update` button.  This should download stuff for awhile.  Once finished the dependency menu should populate with options.
