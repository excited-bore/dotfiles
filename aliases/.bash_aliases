# vim: set filetype=bash

shopt -s expand_aliases
#shopt -s progcomp_alias

if [ -d ~/.aliases.d/ ] && [ "$(command ls -A ~/.aliases.d/)" ]; then
    for alias in ~/.aliases.d/*; do
        source "$alias"
    done
fi
