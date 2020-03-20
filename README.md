This is just my personal get started with a new machine set of scripts

First make sure you've got the prereqs by running the prereqs script

That uses the package manager for your OS

Then run ./jumpstart.sh which should work on osx and linux

jumpstart should be idempotent so it's ok to run all the damn time.

Changelog note!

do some changes and commit them.

then 

    git changelog --tag 1.0.X 
    git add History.md
    git commit --amend
    git tag 1.0.X
    git push --tags
