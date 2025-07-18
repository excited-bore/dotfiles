if ! test -f checks/check_all.sh; then 
    if command -v curl &> /dev/null; then 
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)  
    else  
        continue  
    fi 
else 
    . ./checks/check_all.sh 
fi

SCRIPT_DIR=$(get-script-dir)

# https://unix.stackexchange.com/questions/690233/piping-yes-when-running-scripts-from-curl

sh -c "$(curl https://starship.rs/install.sh)" -y -f

readyn -p "Install starship for user?" strship
if [[ "y" == "$strship" ]]; then
    # It's best that starship is initialized on the last line
    # Otherwise it doesn't play nice with ~/.bash_preexec.sh
    if grep -q "starship" ~/.bashrc; then
        sed -i '/starship init bash/d' ~/.bashrc 
    fi
    printf "\neval \"\$(starship init bash)\"\n" >>~/.bashrc
    if ! grep -q "starship" ~/.zshrc; then
        printf "\neval \"\$(starship init zsh)\"\n" >>~/.zshrc
    fi
    if ! test -f checks/check_completions_dir.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_completions_dir.sh)
    else
        . ./checks/check_completions_dir.sh
    fi
    starship completions bash >~/.bash_completion.d/starship
    #if grep -q '[ -f .bash_preexec ]' ~/.bashrc; then
    #    sed -i '/eval "$(starship init bash)"/d' ~/.bashrc
    #    sed -i 's|\(\[ -f ~/.bash_preexec \] \&\& source \~/.bash_preexec\)|\neval "$(starship init bash)"\n\1\n|g' ~/.bashrc
    #fi
    if [ -d ~/.bash_aliases.d/ ]; then
        if test -f aliases/.bash_aliases.d/starship.sh; then
            cp aliases/.bash_aliases.d/starship.sh ~/.bash_aliases.d/
        else
            wget-aria-dir ~/.bash_aliases.d/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/starship.sh
        fi

        if type gio &>/dev/null && test -f ~/.bash_aliases.d/starship.sh~; then
            gio trash ~/.bash_aliases.d/starship.sh~*
        fi
    fi
fi
unset strship

readyn -p "Install starship.sh for root?" strship
if [[ "y" == "$strship" ]]; then
    if ! sudo grep -q "starship" /root/.bashrc; then
        printf "\neval \"\$(starship init bash)\"\n" | sudo tee -a /root/.bashrc &>/dev/null
        #if sudo grep -q '[ -f .bash_preexec ]' /root/.bashrc; then
        #sudo sed -i '/eval "$(starship init bash)"/d' /root/.bashrc
        #sudo sed -i 's|\(\[ -f ~/.bash_preexec \] \&\& source \~/.bash_preexec\)|\neval "$(starship init bash)"\n\1\n|g' /root/.bashrc
        #else
        #fi
    fi

    if ! test -f checks/check_completions_dir.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_completions_dir.sh)
    else
        . ./checks/check_completions_dir.sh
    fi
    sudo touch /root/.bash_completion.d/starship
    starship completions bash | sudo tee -a /root/.bash_completion.d/starship &>/dev/null
    if [ -d /root/.bash_aliases.d/ ]; then
        if test -f aliases/.bash_aliases.d/starship.sh; then
            sudo cp aliases/.bash_aliases.d/starship.sh /root/.bash_aliases.d/
        else
            sudo -E wget-aria-dir /root/.bash_aliases.d/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/starship.sh
        fi
        if type gio &>/dev/null && test -f /root/.bash_aliases.d/starship.sh~; then
            sudo gio trash /root/.bash_aliases.d/starship.sh~*
        fi
    fi
fi
unset strship

if ! test -f ./checks/check_bash_source_order.sh; then
    if type curl &>/dev/null; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_bash_source_order.sh)
    else
        printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
        return 1 || exit 1
    fi
else
    . ./checks/check_bash_source_order.sh
fi

test -n "$BASH_VERSION" && eval "$(starship init bash)"
test -n "$ZSH_VERSION" && eval "$(starship init zsh)"

if ! test -f aliases/.bash_aliases.d/starship.sh; then
    source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/starship.sh)
else
    . ./aliases/.bash_aliases.d/starship.sh
fi

if hash fzf &>/dev/null; then
    starship-presets
elif ! hash fzf &>/dev/null && test -f ~/.fzf.bash; then
    [ -f ~/.fzf.bash ] && source ~/.fzf.bash
    starship-presets
elif ! hash fzf &> /dev/null && test -f ~/.fzf.zsh; then
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
    starship-presets
fi
