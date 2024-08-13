if ! type reade &> /dev/null; then
    . ~/.bash_aliases.d/00-rlwrap_scripts.sh
fi

function starship-presets() {
    ansr=$(starship preset --list | head -n -1 | fzf --reverse);
    starship preset "$ansr" -o ~/.config/starship.toml
    local hmdir
    reade -Q 'GREEN' -i 'y' -p "Set '~' to '$HOME'? [Y/n]: " "y n" hmdir
    if [ "$hmdir" == "y" ]; then
        if grep -q 'home_symbol' ~/.config/starship.toml; then
            sed -i 's|\(home_symbol = \).*|\1"'"$HOME"'"|' ~/.config/starship.toml 
        elif grep -q '\[directory\]' ~/.config/starship.toml; then
            sed -i 's|\(\[directory\]\)|\1\nhome_symbol = "'"$HOME"'"|' ~/.config/starship.toml 
        else
            printf '\n[directory]\nhome_symbol = "'"$HOME"'"' >> ~/.config/starship.toml
        fi
    fi
    source ~/.bashrc
    unset hmdir
    reade -Q 'GREEN' -i 'y' -p "Set prompt identical for root? [Y/n]: " "y n" hmdir
    if [ "$hmdir" == "y" ]; then
        sudo cp -f ~/.config/starship.toml /root/.config/starship.toml
        unset hmdir
        reade -Q 'GREEN' -i 'y' -p "Set '~' to '/root'? [Y/n]: " "y n" hmdir
        if [ "$hmdir" == "y" ]; then
           sudo sed -i 's|\(home_symbol = \).*|\1"'"/root"'"|' /root/.config/starship.toml  
        fi
    fi
}

function starship-uninstall() {
    file="$(whereis starship | awk '{print $2}')"
    sudo rm $file 
    sed -i '/eval "$(starship init bash)"/d' ~/.bashrc
    source .bashrc
}
