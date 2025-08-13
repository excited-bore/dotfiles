# vim: set filetype=bash

shopt -s expand_aliases
#shopt -s progcomp_alias

if [ -d ~/.bash_aliases.d/ ] && [ "$(command ls -A ~/.bash_aliases.d/)" ]; then
    for alias in ~/.bash_aliases.d/*; do
        source "$alias"
    done
fi
