# Git Notes

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
