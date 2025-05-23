#!/bin/bash
# vim: set filetype=bash

shopt -s expand_aliases
#shopt -s progcomp_alias

if [ -d ~/.bash_aliases.d/ ] && [ "$(ls -A ~/.bash_aliases.d/)" ]; then
  for alias in ~/.bash_aliases.d/*; do
      source "$alias"
  done
fi

function unalias(){
    command unalias $@
    while read -r line; do
        if [[ $(echo "$line" | awk '$2 == "-F" { print $3 }') =~ '_complete_alias' ]]; then
            local cmd=$(echo "$line" | awk '{print $NF}') 
            if ! [[ $(type $cmd 2> /dev/null) =~ 'alias' ]]; then
                complete -r $cmd
            fi
        fi
    done < <(complete -p) 
}

complete -F _complete_alias "${!BASH_ALIASES[@]}"
