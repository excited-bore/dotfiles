# vim: set filetype=bash

shopt -s expand_aliases
#shopt -s progcomp_alias

if [ -d ~/.aliases.d/ ] && [ "$(command ls -A ~/.aliases.d/)" ]; then
    for alias in ~/.aliases.d/*; do
      source "$alias"
    done
fi

if [ -d ~/.bash_aliases.d/ ] && [ "$(command ls -A ~/.bash_aliases.d/)" ]; then
    for alias in ~/.bash_aliases.d/*; do
      source "$alias"
    done
fi

# https://github.com/scop/bash-completion
# Read the section 'Where should I install my own local completions?'
# The bash-completion package does not handle the complete_alias function well so we ignore it ~/.bash_completion and source it here
[ -f ~/.bash_completion.d/complete_alias.bash ] && source ~/.bash_completion.d/complete_alias.bash  

function unalias(){
	command unalias $@
	while read -r line; do
		if [[ $(echo "$line" | awk '$2 == "-F" { print $3 }') =~ "_complete_alias" ]]; then
		local cmd=$(echo "$line" | awk '{print $NF}')
		if ! [[ $(type $cmd 2> /dev/null) =~ "alias" ]]; then
			complete -r $cmd
		fi
	fi
	done < <(complete -p)
}
