if ! type reade &> /dev/null && test -f ~/.bash_aliases.d/00-rlwrap_scripts.sh; then
    . ~/.bash_aliases.d/00-rlwrap_scripts.sh
fi 

function update-kernel(){
    local latest_lts latest_lts1 choices
    
    if [[ "$pac" == "apt" ]] || [[ "$pac" == "nala" ]]; then
     
    elif [[ "$pac" == "pacman" ]]; then
    fi
}
