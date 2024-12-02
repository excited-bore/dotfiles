#!/bin/baslh
type fd &> /dev/null && alias fd='fd --color=always --hidden'

tree=''
type tree &> /dev/null && tree=' | tree '

if type fd &> /dev/null; then
    alias find-files-dir="fd --search-path . --type file" 
    alias find-files-system="fd --search-path / --type file" 
    alias find-symlinks-dir="fd --search-path . --type symlink $tree | $PAGER"
    alias find-symlinks-system="fd --search-path / --type symlink $tree | $PAGER"
else
    alias find-files-dir="find . -type f" 
    alias find-files-system="find / -type f" 
    alias find-symlinks-dir="find . -type l -exec ls --color -d {} \; $tree | $PAGER"
    alias find-symlinks-system="find / -type l -exec ls --color -d {} \; $tree | $PAGER"
fi

