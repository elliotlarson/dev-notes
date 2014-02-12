# Git Notes

## Resources

* http://www.youtube.com/watch?v=ZDR433b0HJY
* http://www.youtube.com/watch?v=ig5E8CcdM9g
* http://git-scm.com/book
* http://mislav.uniqpath.com/2010/07/git-tips/

## Rebasing

#### merge the last two commits.

	$ git rebase -i HEAD~2

	# change 'pick' to 'squash' next to the commit you want to squash

#### rebase conflict

	$ git rebase

	# <fix conflict>
	$ git add <fixed file>
	$ git rebase --continue

	# <skip conflict>
	$ git rebase --skip

	# <abort rebase>
	$ git rebase --abort
	
#### rename a commit

	$ git rebase -i
	
	# change 'pick' to 'reword' next to the commit you want to change; 
	# when you save the file, vim will open a commit file where you
	# can change the message
	
## Diffing

#### show the changes from your last commit

	$ git diff

#### show what the staged changed are

	$ git diff --staged
	
#### show the changes in a commit with the git difftool

	$ git difftool 3e11f62ad37b871f^!

#### show the changes in a commit with command line diff

	$ git diff 3ca00c2c847^!
	
	# it would be better to say:
	$ git show 3ca00c2c847
	
#### diff the last 5 commits

	$ git diff HEAD~5
	
	# you could also say
	$ git log -p -5

#### diffing two different branches

	$ git diff master bird

#### diffing a single file

	$ git diff HEAD^ app/controllers/sites/corporate/pages_controller.rb
	
## Log

#### searching the log for a term

	$ git log --grep=maps

#### show git log with one line output

	$ git log --pretty=oneline
	$ git log --oneline
	
#### make log output one line for each commit

	$ git log --pretty=oneline
	$ git log --oneline

#### show diffs in commit

This is a great way to search for changes in the codebase.  
	
	$ git log -p
	
	# then you can search for terms by hitting the "/" key

#### show only commits added by an author

	$ git log --author='onehouse <elliot@onehouse.net>'

#### show how many insertions and deletions were made in each commit

	$ git log --oneline --stat

#### show a visual representation of commits in log

	$ git log --oneline --graph

#### show git log until one minute ago

	$ git log --until=1.minute.ago

#### show git log between two times

	$ git log --since=1.month.ago --until=2.weeks.ago

#### show log of last 2 commits

	$ git log -2
	
#### get a number of commits from git log, check them out, and run spec suite against them:

	# <this doesn't actually work>
	$ git log --author='onehouse <elliot@onehouse.net>' --since=1.day.ago --until=today --oneline | awk '{print $1}' | while read line; git checkout $line; rspec spec/; end
	
#### show all authors in a repo:

	$ git log --format='%aN' | sort -u

#### pull out the number of changes from a commit

 	$ git show f769bc31bdd --stat | grep '|.*[+]*-*$' | awk '{print $3}' | paste -sd+ - | bc

#### show the git log stat for a single commit

	$ git show f769bc31bdd --stat

## Resetting

#### unstage a file

	$ git reset file.html

#### roll a commit back, keeping changed files in staged area

	$ git reset --soft HEAD^

#### undo last 2

	$ git reset --soft HEAD^^

#### roll a commit back, and blow away any files that were changed

	$ get reset --hard HEAD^
	
## Committing

#### add to the previous commit

	$ git commit --amend -m "New message for commit"
	
## Remotes

#### get list of remote repositories that Git knows about

	$ git remote -v

	$ git pull force
	$ git fetch --all
	$ git reset --hard origin/branch

#### Add a remote repository

	$ git remote add origin https://github.com…

#### remove a remote

	$git remote rm <name>
	
## Bisecting

#### git bisect run article

* http://robots.thoughtbot.com/git-bisect
* http://lwn.net/Articles/317154/

Passing bad and good revisions to git bisect start

	$ git bisect start HEAD e6be773
    # <bad> <good>

Auto running git bisect with a command

	$ git bisect run zeus rspec ./spec/models/commercial_application_spec.rb 

## Branches

#### track a remote branch

	$ git checkout -t origin/haml

#### get list of remote branches

	$ git branch -r

#### delete a remote branch

	$ git branch origin :weasel

#### show information about remote origin

	$ git remote show origin

#### clean up deleted remote branches

	$ git remote prune origin

#### push a local branch to a remote branch with a different name

	$ git push origin staging:master
	
## Tags

#### list all tags

	$ git tag

#### checkout a tag

	$ git checkout <tagname>

#### add a new tag

	$ git tag -a v0.0.3 -m "version 0.0.3"

#### push tags to remote

	$ git push --tags
	
## Fetching

#### pull down all changes without committing them

	$ git fetch

## Config

#### add color to git output with config option

	$ git config --global color.ui true

#### see all config options

	$ git config --list

#### set alias for git command

	$ git config --global alias.st status
	$ git config --global alias.mylog "log --pretty=format: '%h %s [%an]' --graph"
	
#### rebase by default config

	$ git config --global branch.master.rebase true
	$ git config --global branch.autosetuprebase always
