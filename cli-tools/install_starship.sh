# https://github.com/starship/starship

hash starship &> /dev/null && SYSTEM_UPDATED='TRUE'

TOP=$(git rev-parse --show-toplevel)

if ! test -f $TOP/checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi

# https://unix.stackexchange.com/questions/690233/piping-yes-when-running-scripts-from-curl

sh -c "$(wget-curl https://starship.rs/install.sh)" -y -f

readyn -p "Install starship for user?" strship
if [[ "y" == "$strship" ]]; then
    # If we're using ble.sh's vim mode and want to add what editing mode were using, we need to adjust starship's bash prompt
    # We're not gonna check for whether ble is installed or whether PS1_MODE is a variable; we're just gonna always make sure there's a file 'starship.bash' other then using the 1-liner 'eval $(starship init bash)' 
    if grep -q "starship" ~/.bashrc; then
        sed -i '/starship init bash/d' ~/.bashrc 
    fi

    if ! test -f $TOP/checks/check_prompt_dir.sh; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_prompt_dir.sh)
    else
        . $TOP/checks/check_prompt_dir.sh
    fi
  
    # We need to add a specific condition inside starship.bash related to vi/emacs-mode prompts ( (vi/cmd/vis) ) 
    if ! test -f ~/.prompt.d/starship.bash; then
        /usr/local/bin/starship init bash --print-full-init > ~/.prompt.d/starship.bash 
        sed -i 's|\(PS1="$(/usr/local/bin/starship prompt "${ARGS\[@\]}")"\)|\1\n    # If we have a vi mode from ble.sh, we make sure the first character is removed in PS1 since it seems to be some kind of newline character\n    if [[ -n "$PS1_MODE" ]]; then\n        PS1="$PS1_MODE""${PS1:1}"\n    fi\n|g' ~/.prompt.d/starship.bash 
    fi

    if ! grep -q "starship" ~/.zshrc; then
        printf "\neval \"\$(starship init zsh)\"\n" >>~/.zshrc
    fi
    if ! test -f $TOP/checks/check_completions_dir.sh; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_completions_dir.sh)
    else
        . $TOP/checks/check_completions_dir.sh
    fi
    
    starship completions bash >~/.bash_completion.d/starship.bash
    starship completions zsh >~/.zsh_completion.d/starship.zsh
    
    #if grep -q '[ -f .bash_preexec ]' ~/.bashrc; then
    #    sed -i '/eval "$(starship init bash)"/d' ~/.bashrc
    #    sed -i 's|\(\[ -f ~/.bash_preexec \] \&\& source \~/.bash_preexec\)|\neval "$(starship init bash)"\n\1\n|g' ~/.bashrc
    #fi
    if [ -d ~/.aliases.d/ ]; then
        if test -f $TOP/aliases/.aliases.d/starship.sh; then
            cp $TOP/aliases/.aliases.d/starship.sh ~/.aliases.d/
        else
            wget-aria-dir ~/.aliases.d/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.aliases.d/starship.sh
        fi

        if hash gio &> /dev/null && test -f ~/.aliases.d/starship.sh~; then
            gio trash ~/.aliases.d/starship.sh~*
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

    if ! test -f $TOP/checks/check_completions_dir.sh; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_completions_dir.sh)
    else
        . $TOP/checks/check_completions_dir.sh
    fi
    sudo touch /root/.bash_completion.d/starship
    starship completions bash | sudo tee -a /root/.bash_completion.d/starship &>/dev/null
    if [ -d /root/.aliases.d/ ]; then
        if test -f $TOP/aliases/.aliases.d/starship.sh; then
            sudo cp aliases/.aliases.d/starship.sh /root/.aliases.d/
        else
            sudo -E wget-aria-dir /root/.aliases.d/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.aliases.d/starship.sh
        fi
        if hash gio &> /dev/null && test -f /root/.aliases.d/starship.sh~; then
            sudo gio trash /root/.aliases.d/starship.sh~*
        fi
    fi
fi
unset strship

if ! test -f $TOP/checks/check_bash_source_order.sh; then
   source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_bash_source_order.sh)
else
    . $TOP/checks/check_bash_source_order.sh
fi

test -n "$BASH_VERSION" && eval "$(starship init bash)"
test -n "$ZSH_VERSION" && eval "$(starship init zsh)"

if ! test -f $TOP/aliases/.aliases.d/starship.sh; then
    source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.aliases.d/starship.sh)
else
    . $TOP/aliases/.aliases.d/starship.sh
fi

if hash fzf &> /dev/null; then
    starship-presets
elif ! hash fzf &> /dev/null && test -f ~/.fzf.bash; then
    [ -f ~/.fzf.bash ] && source ~/.fzf.bash
    starship-presets
elif ! hash fzf &> /dev/null && test -f ~/.fzf.zsh; then
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
    starship-presets
fi
