# RubyMine Notes

## Setup

1. Install vim, ruby, material theme, go, File watchers, Prettier, git toolbox
1. Tweak material theme until happy (use material fonts, use atom material icons, crunch line height in menus)
1. To allow the bottom line of the file to be brought to the middle of the screen you need to select the `Preferences -> Editor -> General -> Check: Show virtual space at file bottom` checkbox.  Then you can hit the vim `zz` command`
1. Open terminal with command: `ctrl + shift + u`. Search for terminal in prefs and look under keymap; add to existing `alt + f12`
1. Under keyboard shortcuts, remove keyboard shortcut `alt + shift + b` from git blame and add to annotate 
1. Moving a file from one split to the next is called "Move to opposite group" and it only toggles to the opposite split.  I've mapped this to `cmd + ctrl + shift + up`
1. Add keyboard shortcut for split and move right: `cmd + shift + crl + right arrow`
1. Keymap: Add selection for next occurence: `alt + g`
1. Remove system keyboard shortcut that blocks the search for all actions `cmd + shift + a`.  Keyboard -> shortcuts -> services -> Search man page index in terminal
1. Added `cmd + ctrl + c` shortcut to "Copy path" functionality (removed from "Copy absolute path").  This allows you to select the relative path with line number if you want
1. Change color of unused function (default is hard to see): Editor > Color scheme > General > Errors and Warnings > Unused sumbol
1. Install File watchers and prettier plugins (after restarting, go to Tools > File watchers; add new file watcher for prettier)
1. Editor > General > Smart Keys > Reformat on paste = None (this doesn't seem to work at this time, but maybe it will in the future?)
1. Editor > General > Ensure empty line at end of file on Save
1. Configure ESLint autofix external tool: https://blog.jetbrains.com/webstorm/2016/08/using-external-tools/

Opening a project:

1. Open project preferences: `cmd + ;` and set the SDK to the correct Rbenv version.  Also remove the non-rails module and add in a ruby on rails one with the appropriate project name and path 
1. Connect database
1. Do a serch for "Terminal" in settings (under tools) and set the variable there `USING_RUBYMINE_TERMINAL=1`.

## Properties

There is an experimental feature to improve typing speed.  To activate it, go to `Help > Edit Custom Properties...`.  If the file doesn't exist yet, you will be prompted to create it.  Then add this line to the file `editor.zero.latency.typing=true`.

## Declaration and usages

Use `cmd + B` over a method name to jump to the declaration.  Then you can use `cmd + B` to see all of the usages.

Use `alt + f7` to show a finder list of all usages.

In the finder, you can pin the search results by right clicking the tab and choosing to pin it.  Now the next time the finder gets used, the results will appear in a new tab and the original results will remain.

Use `cmd + f12` to see the structure of the file (like ctags).  This shows the results as a popup that is searchable.  You may instead want to see the results as a docked tool window, with the easier to hit `cmd + 7`.

## Searching

1. To search everything (all) `shift + shift`
1. Search for classes with `cmd + o`.
1. Search for files with `shift + cmd + o`.
1. Search for symbols `cmd + alt + o`
1. Search for actions `cmd + shift + a` -> this conflicts with an Apple shortcut.  Disable it with:
    Open System Preferences | Keyboard | Shortcuts | Services
    Disable Search man Page Index in Terminal (or change the keybinding)

In the popup that shows, if you want to preview the file/class before navigating to it you can use `alt + spc`.

Search from a list of recently opened files, `cmd + e`.

Search from a list of recently opened locations `cmd + shift + e`.

You can also open the run anything dialog with `ctrl + ctrl`.  This is where you can run the rails console or migrations, etc.

## Code

To activate code completion manually `ctrl + spc`.  Hit `enter` in the popup when you've navigated to the item you want.

You can complete a word with textual similarity ("hippie completion") with `alt + /`.  You can repeat this chord to cycle through the available options.

You can do refactors with the `ctrl + t` chord.  This doesn't work for me for some reason, so I remapped this to `ctrl + shift + t`.

Open test file `shift + cmd + t`.

Toggle between files: `ctrl + tab`.

When cursor is over a term `cmd + b` will go to definition.

Searchable dialog with ctags like class structure `cmd + f12`.

Added `cmd + ctrl + c` shortcut to "Copy path" functionality (removed from "Copy absolute path").  This allows you to select the relative path with line number if you want.

Reveal/show current file in project tree (finder) `alt + f1`.

Git blame is called the "annotate" feature in RubyMine.  I've mapped this functionality to `cmd + shift + ctrl + b`.

Moving a file from one split to the next is called "Move to opposite group" and it only toggles to the opposite split.  I've mapped this to `cmd + ctrl + shift + up`.

To navigate to another group/split you can use vim commands: `ctrl + w + h` = left split, `ctrl + w + l` = right split.

To allow the bottom line of the file to be brought to the middle of the screen you need to select the `Preferences -> Editor -> General -> Check: Show virtual space at file bottom` checkbox.  Then you can hit the vim `zz` command`

Using "String Manipulation" plugin, change quote style.  Select string including quotes, and open the menu `alt + shift + m` and choose the option to wrap with quotes.

To view the quick definition of a constant `alt + spc` while over the method name.

To view the documentation for a constant `f1`.

If you don't remember the name of the file, but do remember the code you were editing, you can view recent locations with `cmd + shift + e`.

When you type `.` after something like an array, intellisense kicks in and shows some method options.  As you navigate this popup, you can view quick documentation with `f1`.  If you press `f1` twice more, the docs will show up in a pin-able documentation browser.

Added editor setting "Ensure line feed at file end on save".

You can run a generator with `cmd + alt + g`.

You can open the prompt to "run anything" and run various rails commands with `ctrl` + `ctrl`.

TODO:

* Change quotes around string
* Change ruby hash style
* Change block style `{}` to `do end`

## Find and replace

Find in current file `cmd + f`.

Find and replace in current file `cmd + r`.

Find in project `cmd + shift + f`.

Find and replace in project `cmd + shift + r`.

## Testing

Run the current test (this only seems to work if the spec has a description):

`ctrl + shift + r`

Run all the tests in the current file (this opens the run dialog with the current file selected):

`ctrl + alt + r`

Get the fully qualified path for current file, so you can run your tests in terminal (I mapped this to "Copy path"):

`cmd + ctrl + c`

## Terminal

I removed the default `alt + f12` and replaced it with `ctrl + shift + u`.

Navigate back to editor `esc`.

Adjusted "Console Font" to Menlo 11px with 0.9 line spacing.

Added an environment variable to not show the powerline 9k prompt I use.  It doesn't look good in the RM terminal.  My shell looks for the existence of `USING_RUBYMINE_TERMINAL` and doesn't use the prompt if this is set.  Do a serch for "Terminal" in settings (under tools) and set the variable there `USING_RUBYMINE_TERMINAL=1`.  You seem to have to set this on a project by project basis.

## Version control

Open version control panel `cmd + 9`.

Open version control commit/review dialog `cmd + k`.

Review and enter a commit message, then hit `cmd + enter`.

## Toggle UI elements

* `cmd + 1` = File browser
* `cmd + 7` = File structure
* `cmd + 9` = Source control
* `cmd + shift + f12` = Collapse/ hide all tool windows (focus editor)

## Painting the pig

Use the material theme, no contrast.

Compact all the things in the settings.

Remove active tab highlight color.

Project view:

* Custom sidebar height
* Custom tree indent (reduce)
* Font size (makes it smaller)

Turn tabs shadow off

Check the "Themed title bar" option 

In the Editor -> ColorScheme, edit the:
* Console font (the terimal has too much line spacing for some reason, so I went down to 0.8 on the line spacing)
* Color Scheme font 
* General -> Editor:
  * Tear line: darken (with material theme I used 2f2f2f)
  * Ident guide: darken
  * Language defaults:
    * Identifier: light blue #c5f3ff
  * Ruby:
    * Local variable: #fdffd8

## Linting

I've changed the warnings about naming length for the following to 50
* constants 
* instance variables
* instance methods
* class methods

## What do I think?

### The good

* Code completion
* Code navigation
* Refactoring tools
* Documentation

### Lacking

* It looks like there isn't a way to run the spec at the current line if your spec doesn't have a description `it { is_expected.to ...}`
* Can't seem to find a way to get the relative path for current file (you can get the fully qualified)
* It looks like the Rubymine team rolls out bugs and code that breaks stuff frequently
* A lot of keyboard shortcuts with function keys.  This is awkward, especially with a laptop
* Design/UX of the editor is klunky.  There's a lot of UI and it looks like software from 15 years ago.  You can use the material theme, but this is a little like makeup on a pig

## Opening an existing project

This is what kept me from using RubyMine every time I tried.  I want to try out RubyMine.  I open an existing project in it and tried to run a test.  It doesn't work and I can't get it to work.  I move on.

When I open the project it says "Framework Detected.  JRuby on Rails".  I'm not using JRuby, but Intellij is built with Java, so, hmmm... don't know.  It's probably fine?  Moving on.  Try to run a test.  It's not working.  The test runner icon is grayed out.  No other information.  Oh, wait.  There's this even log thing.  Reads error messages and with a touch of clairvoyance I come to the conclusion that I have to configure the test runner.  Opens debug/runner config window... 3 hours later and still no luck.  Really frustrated now.  If they can't get this right, what's the point of even trying to use this editor?

2 years later, smart people in my industry keep using this editor and saying great things about it.  Would really be nice to use an editor where Ruby is a first class citizen.  Looking at feature videos on website.  Looks really nice.  Downloads editor, opens project, tests don't run.  Hm, I remember this.  Maybe I was dumb last time.  I'm better now.  I'm older.  I'm wiser.  Well, anyway, I'm older.  Let's give it another go.  3 hours later: Jesus, why is this so hard?  If they can't get this right, why bother?

So, okay rinse repeat a few times.  (I've been at this for awhile.)  I really would like to try Rubymine/Intellij.  I'm not taking no for an answer this time.  I'm going to figure this shit out.  Walks toward desk with newfound resolve.  Stubs toe really hard on the way.

After more frustration and frantic, pathetic, Google thrashing, I found this: https://intellij-support.jetbrains.com/hc/en-us/community/posts/206704845-Silly-question-Is-JRuby-required-for-Ruby-support-in-Intellij-Ultimate-s-Ruby-plugin-

Oleg Sukhodolsky explains:

> The problem is that Idea creates Java module when you open directory with a code but you need a Ruby module.
To fix that you need:

1. open the project
1. open project structure (File|Project Structure)
1. select modules
1. delete the only module you have
1. add new Ruby module
1. as name you can use anything you want (e.g. directory name), as path the project root
make sure that the correct ruby sdk is set for module sdk ("Gems" tab)
(optional) if this is a rails app - add rails facet

```ruby
puts "WTF" * 50
```

I mean, if this were Vim or Emacs, I would have signed up to be whipped hard with leather and knew what I was getting into.  But this is a commercial product designed to work for my use case.

But, yeah.  Now I can run tests in RubyMine.  Still thinking, "if they can't get this right, then...".  But, trying to be optimistic.
