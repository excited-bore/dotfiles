#!/bin/baslh
type fd &> /dev/null && alias fd='fd --color=always'

tree=''
type tree &> /dev/null  && tree=' | tree '

if type fd &> /dev/null; then
    alias list-dir-symlinks="fd --search-path . --type symlink $tree | $PAGER"
    alias list-all-symlinks="fd --search-path / --type symlink $tree | $PAGER"
else
    alias list-dir-symlinks="find . -type l -exec ls --color -d {} \; $tree | $PAGER"
    alias list-all-symlinks="find / -type l -exec ls --color -d {} \; $tree | $PAGER"
fi

