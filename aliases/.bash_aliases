#!/bin/bash
# vim: set filetype=bash

shopt -s expand_aliases

if [ -d ~/.bash_aliases.d/ ] && [ "$(ls -A ~/.bash_aliases.d/)" ]; then
  for alias in ~/.bash_aliases.d/*; do
        source "$alias" 
  done
fi

complete -F _complete_alias "${!BASH_ALIASES[@]}"
