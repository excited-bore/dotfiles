. ~/.bash_aliases.d/rlwrap_scripts.sh
function starship-presets() {
    ansr=$(starship preset --list | fzf --reverse);
    starship preset "$ansr" -o ~/.config/starship.toml
    local hmdir
    reade -Q 'GREEN' -i 'y' -p "Set '~' to '$HOME'? [Y/n]: " "y n" hmdir
    if [ "$hmdir" == "y" ]; then
        if grep -q '\[directory\]' ~/.config/starship.toml; then
            sed -i 's|\(\[directory\]\)|\1\nhome_symbol = "'"$HOME"'"|' ~/.config/starship.toml 
        else
            printf '\n[directory]\nhome_symbol = "'"$HOME"'"' >> ~/.config/starship.toml
        fi
    fi
    unset hmdir
}

alias starship-uninstall="sudo sh -c 'rm \"$(command -v 'starship')\"'"
