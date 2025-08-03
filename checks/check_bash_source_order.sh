if test -f ~/.bash_profile; then
    if grep -q '~/.bash_preexec' ~/.bash_profile && ! [[ "$(tail -1 ~/.bash_profile)" =~ '~/.bash_preexec' ]]; then
        sed -i '/[ -f ~\/.bash_preexec ] && source ~\/.bash_preexec/d' ~/.bash_profile
        printf "\n[ -f ~/.bash_preexec ] && source ~/.bash_preexec\n" >>~/.bash_profile
    fi
fi

if test -f ~/.bashrc; then
    if grep -q '~/.bash_preexec' ~/.bashrc && ! [[ "$(tail -1 ~/.bashrc)" =~ '~/.bash_preexec' ]]; then
        sed -i '/[ -f ~\/.bash_preexec ] && source ~\/.bash_preexec/d' ~/.bashrc
        printf "[ -f ~/.bash_preexec ] && source ~/.bash_preexec\n" >>~/.bashrc
    fi
fi

echo "Next $(tput setaf 1)sudo$(tput sgr0) will check for '~/.bash_preexec' in /root/.bash_profile and /root/.bashrc and reorder when the file gets sourced when necessary"
if test -d /root/; then
    
    if test -f ~/.bash_profile; then
        if sudo grep -q '~/.bash_preexec' /root/.bash_profile &&  ! [[ "$(sudo tail -1 /root/.bash_profile)" =~ '~/.bash_preexec' ]]; then
            sudo sed -i 'r/[ -f ~/.bash_preexec ] && source ~/.bash_preexec' /root/.bash_profile
            printf "\n[ -f ~/.bash_preexec ] && source ~/.bash_preexec\n" | sudo tee -a /root/.bash_profile
        fi
    fi 

    if test -f ~/.bashrc; then
        if sudo grep -q '~/.bash_preexec' /root/.bashrc && ! [[ "$(sudo tail -1 /root/.bashrc)" =~ '~/.bash_preexec' ]]; then
            sudo sed -i '/[ -f ~\/.bash_preexec ] && source ~\/.bash_preexec/d' /root/.bashrc
            printf "\n[ -f ~/.bash_preexec ] && source ~/.bash_preexec\n" | sudo tee -a /root/.bashrc 1> /dev/null
        fi
    fi
fi
