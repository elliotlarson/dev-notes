# Git Notes

## Renaming a tag

```bash
$ git tag new old
$ git tag -d old
$ git push origin new :old
$ git pull --prune --tags
```

## Rename the current branch

```bash
$ git branch -m <newname>
```

## Resolving a conflict with package.json for Gemfile.lock

If you rebase a branch and end up with conflicts on either of these files, first checkout the `HEAD` version of the file:

```bash
$ git checkout HEAD -- yarn.lock
$ git checkout HEAD -- Gemfile.lock
```

Then followup with a `yarn install` or `bundle install`.

## Break up previous commit

If you have a prior commit that you'd like to break up into multiple commits, you can rebase and reset:

```bash
$ git rebase -i head~3
```

Change the commit to `edit` in the rebase window, save and exit.  Then reset to undo the commit you are editing:

```bash
$ git reset head~1
```

Now you can stage and commit until you are finished committing all of the files.  Once you've finished creating your new commits, you can continue:

```bash
$ git rebase --continue
```

## Show the different commits between branches

```bash
$ git log develop..egl/my-feature-branch
```

You can also show the changes with `-p`:

```bash
$ git log -p develop..egl/my-feature-branch
```

## Show the files modified comparing to another branch

This is useful if you are thinking about creating a PR and you're curious how many files are going to end up in it:

```bash
$ git diff --name-status master..my-feature-branch
```

## Checkout a deleted file

```bash
$ git log -- path/to/file.txt
# look for the commit before the commit where the file was deleted (assuming you know)
$ git checkout commitish-sha -- path/to/file.txt
```

## Use a global .gitignore

First setup git to use the global gitignore from your home directory

```bash
$ git config --global core.excludesfile '~/.gitignore'
```

Then add your global .gitignore

## Undo git commit --amend

Here's a good explanation: https://stackoverflow.com/questions/38001038/how-to-undo-a-git-commit-amend/38002218

```bash
$ git reset --soft @{1}
```

## Reset local branch to head of remote branch

```bash
$ git reset --hard origin/features/mah-feature
```

## Checkout master version of file on branch during rebase

Sometimes when rebasing master you get a conflict on a file and you just want to pull the version from master

During a rebase

* "ours" = master
* "theirs" = your branch

```bash
$ git checkout --ours somefile.txt
```

## Prune deleted remote origins from local branch listing

You can get a listing of remote branches with

```bash
$ git branch -a
```

But, this list might be very long and could include deleted branches.  To remove them from the list

```bash
$ git remote prune origin
```

## Push local branch to origin and make tracking

```bash
$ git push -u origin HEAD
```

## Checkout latest commit on branch

After you've navigated to a previous commit on a branch, to get back to the latest commit on that branch

```bash
$ git checkout -
```

## Show commits that have been added to a branch

When doing a code review it might be nice to see a log of commits on a branch.  This command shows the commits that exist on the feature branch that do not exist on master:

```bash
$ git cherry -v master features/my-awesome-feature
```

## Edit a previous commit

Say the commit you want to edit is `bbc643cd`:

```bash
$ git rebase --interactive 'bbc643cd^'
```

Change `pick` to edit for the commit.

Then make the edits you want to make.

Then amend the current commit:

```bash
$ git commit --all --amend --no-edit
```

And, finally, continue on with the rebase to finish up:

```bash
$ git rebase --continue
```

## Rewording a commit

The first way you can do this is to just ammend the commit (provided it's the last commit):

```bash
$ git commit --amend
```

If the commit isn't the last commit, you need to rebase:

```bash
$ git rebase -i head~3
```

This will open the last 3 commits in an interactive rebase.  Each commit starts with the work `pick`.  For the commit you want to change the message for, change `pick` to `edit`:

```text
pick 0d7dd56 Moving test helpers out into support file
pick ec6e0c9 Adding in vue-router
reword 8f6b0ab Adding in debug unit testing
```

When you save this and close out of it, git will open the commit dialog for this commit again so you can edit the message.

## Reflog

Git keeps track of everything that happens to the repo in the reflog.

To view a list of events:

```bash
$ git reflog
```

The output of that command isn't super useful.  To show output in git log format:

```bash
$ git log -g
```

## Removing a file from the git repo history

```bash
$ git filter-branch --tree-filter 'rm -f supersecretpass.txt' HEAD
```

## Getting back a file that you removed

1. Find the hash for the commit when you removed the file
2. Enter this command:

```bash
$ git checkout 048ddf081^ -- path/to/file.rb
```

## Diffing

#### Show the changes from your last commit

```bash
$ git diff
```

#### Show what the staged changed are

```bash
$ git diff --staged
```

#### Show the changes in a commit with the git difftool

```bash
$ git difftool 3e11f62ad37b871f^!
```

#### Show the changes in a commit with command line diff

```bash
$ git diff 3ca00c2c847^!
# it would be better to say:
$ git show 3ca00c2c847
```

#### Diff the last 5 commits

```bash
$ git diff HEAD~5
# you could also say
$ git log -p -5
```

#### Diffing two different branches

```bash
$ git diff master bird
```

#### Diffing a single file

```bash
$ git diff HEAD^ app/controllers/sites/corporate/pages_controller.rb
```

## Log

#### Searching the log for a term

```bash
$ git log --grep=maps
```

#### Show git log with one line output

```bash
$ git log --pretty=oneline
$ git log --oneline
```

#### Make log output one line for each commit

```bash
$ git log --pretty=oneline
$ git log --oneline
```

#### Show diffs in commit

This is a great way to search for changes in the codebase.

```bash
$ git log -p
# then you can search for terms by hitting the "/" key
```

#### Show only commits added by an author

```bash
$ git log --author='onehouse <elliot@onehouse.net>'
```

#### Show how many insertions and deletions were made in each commit

```bash
$ git log --oneline --stat
```

#### Show a visual representation of commits in log

```bash
$ git log --oneline --graph
```

#### Show git log until one minute ago

```bash
$ git log --until=1.minute.ago
```

#### Show git log between two times

```bash
$ git log --since=1.month.ago --until=2.weeks.ago
```

#### Show log of last 2 commits

```bash
$ git log -2
```

#### Show all authors in a repo:

```bash
$ git log --format='%aN' | sort -u
```

#### Pull out the number of changes from a commit

```bash
$ git show f769bc31bdd --stat | grep '|.*[+]*-*$' | awk '{print $3}' | paste -sd+ - | bc
```

#### Show the git log stat for a single commit

```bash
$ git show f769bc31bdd --stat
```

## Resetting

#### Reset a local branch to a remote branch

This resets to the upstream branch.  Say you're on a branch `features/cool-stuff`, you can use this to set the local branch to what's on `origin/features/cool-stuff`:

```bash
$ git reset --hard @{u}
```

You can also do this by manually specifying the remote branch name explicitly:

```bash
$ git reset --hard origin/feature/mips-331-#147895895
```

#### Unstage a file

```bash
$ git reset file.html
```

#### Roll a commit back, keeping changed files in staged area

```bash
$ git reset --soft HEAD^
```

#### Undo last 2

```bash
$ git reset --soft HEAD^^
```

#### Roll a commit back, and blow away any files that were changed

```bash
$ get reset --hard HEAD^
```

## Committing

#### Add to the previous commit

```bash
$ git commit --amend -m "New message for commit"
```

## Remotes

#### Get list of remote branches

```bash
$ git remote show origin
```

You can also do this with the branch command.  This will show all branches remote and local:

```bash
$ git branch -a
```

Then checkout a remote branch:

```bash
$ git checkout <branch-name>
```

#### Get list of remote repositories that Git knows about

```bash
$ git remote -v
$ git pull force
$ git fetch --all
$ git reset --hard origin/branch
```

#### Add a remote repository

```bash
$ git remote add origin https://github.com…
```

#### Remove a remote

```bash
$ git remote rm <name>
```

## Bisecting

#### Git bisect run article

* http://robots.thoughtbot.com/git-bisect
* http://lwn.net/Articles/317154/

Passing bad and good revisions to git bisect start

```bash
$ git bisect start HEAD e6be773
# <bad> <good>
```

Auto running git bisect with a command

```bash
$ git bisect run zeus rspec ./spec/models/commercial_application_spec.rb
```

To quit a bisect session, enter:

```bash
$ git bisect reset
```

## Branches

#### Track a remote branch

```bash
$ git checkout -t origin/haml
```

#### Get list of remote branches

```bash
$ git branch -r
```

#### Delete a remote branch

```bash
$ git branch origin :weasel
```

#### Show information about remote origin

```bash
$ git remote show origin
```

#### Clean up deleted remote branches

```bash
$ git remote prune origin
```

#### Push a local branch to a remote branch with a different name

```bash
$ git push origin staging:master
```

#### Merging in a feature branch and squashing commits into one

```bash
$ git checkout -b my-feature-branch
# ... do some work and commit several times
$ git rebase master
$ git checkout master
$ git merge --squash my-feature-branch
$ git commit -m 'adding in my feature'
```

## Tags

#### List all tags

```bash
$ git tag
```

#### Checkout a tag

```bash
$ git checkout <tagname>
```

#### Add a new tag

```bash
$ git tag -a v0.0.3 -m "version 0.0.3"
```

#### Push tags to remote

```bash
$ git push --tags
```

## Fetching

#### Pull down all changes without committing them

```bash
$ git fetch
```

## Config

#### Add color to git output with config option

```bash
$ git config --global color.ui true
```

#### See all config options

```bash
$ git config --list
```

#### Set alias for git command

```bash
$ git config --global alias.st status
$ git config --global alias.mylog "log --pretty=format: '%h %s [%an]' --graph"
```

#### Rebase by default config

```bash
$ git config --global branch.master.rebase true
$ git config --global branch.autosetuprebase always
```
