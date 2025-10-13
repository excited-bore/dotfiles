if ! [ -f ~/.bash_aliases ]; then
    if ! test -f aliases/.bash_aliases; then
        wget -O ~/.bash_aliases https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases  
    else
        cp aliases/.bash_aliases ~/
    fi 
fi

if ! [ -d ~/.bash_aliases.d/ ]; then
    mkdir ~/.bash_aliases.d/
fi

if [[ -f ~/.bashrc ]] && ! grep -q '\[ -f ~/.bash_aliases \] && source ~/.bash_aliases' ~/.bashrc; then
    if grep -q '^if \[ -f ~/.bash_aliases \]; then' ~/.bashrc; then
        sed -i -e 's|\(if \[ -f \~/.bash_aliases \]; then\)|#This is commented out since there'\''s a one-liner which sources ~/.bash_aliases later down ~/.bashrc\n\n#\1|g' -e 's|\(^\s*\. ~/.bash_aliases\)|#\1|' ~/.bashrc
        ubbashrcfi="$(awk '/\. ~\/.bash_aliases/{print NR+1};' ~/.bashrc)" 
        sed -i "$ubbashrcfi s/^fi/#fi/" ~/.bashrc   
        unset ubbashrcfi 
    fi
   
    if grep -q '\[ -f ~/.keybinds \]' ~/.bashrc; then
        sed -i 's|\(\[ -f \~/.keybinds \] \&\& source \~/.keybinds\)|\[ -f \~/.bash_aliases \] \&\& source \~/.bash_aliases\n\n\1|g' ~/.bashrc
    else
        echo '[ -f ~/.bash_aliases ] && source ~/.bash_aliases' >> ~/.bashrc
    fi
fi

if ! [ -f ~/.zsh_aliases ]; then
    if ! [[ -f aliases/.zsh_aliases ]]; then
        wget -O ~/.zsh_aliases https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.zsh_aliases  
    else
        cp aliases/.zsh_aliases ~/
    fi 
fi

if ! [ -d ~/.zsh_aliases.d/ ]; then
    mkdir ~/.zsh_aliases.d/
fi

if [[ -f ~/.zshrc ]] && ! grep -q '\[ -f ~/.zsh_aliases \] && source ~/.zsh_aliases' ~/.zshrc; then
    if grep -q '^if \[ -f ~/.zsh_aliases \]; then' ~/.zshrc; then
        sed -i -e 's|\(if \[ -f \~/.zsh_aliases \]; then\)|#This is commented out since there'\''s a one-liner which sources ~/.zsh_aliases later down ~/.zshrc\n\n#\1|g' -e 's|\(^\s*\. ~/.zsh_aliases\)|#\1|' ~/.zshrc
        ubzshrcfi="$(awk '/\. ~\/.zsh_aliases/{print NR+1};' ~/.zshrc)" 
        sed -i "$ubzshrcfi s/^fi/#fi/" ~/.zshrc   
        unset ubzshrcfi 
    fi
   
    if grep -q '\[ -f ~/.keybinds \]' ~/.zshrc; then
        sed -i 's|\(\[ -f \~/.keybinds \] \&\& source \~/.keybinds\)|\[ -f \~/.zsh_aliases \] \&\& source \~/.zsh_aliases\n\n\1|g' ~/.zshrc
    else
        echo '[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases' >> ~/.zshrc
    fi
fi


#if ! grep -q "shopt -s expand_aliases" ~/.bashrc; then
#    echo "shopt -s expand_aliases" >> ~/.bashrc
#fi
#
#if ! grep -q "~/.bash_aliases.d" ~/.bashrc; then
#
#    echo "if [ -d ~/.bash_aliases.d/ ] && [ \"\$(ls -A ~/.bash_aliases.d/)\" ]; then" >> ~/.bashrc
#    echo "  for alias in ~/.bash_aliases.d/*.sh; do" >> ~/.bashrc
#    echo "      . \"\$alias\" " >> ~/.bashrc
#    echo "  done" >> ~/.bashrc
#    echo "fi" >> ~/.bashrc
#fi


echo "Next $(tput setaf 1)sudo$(tput sgr0) will install '.bash_aliases.d' in /root and source it with '/root/.bash_aliases' in /root/.bashrc"

if ! [ -f /root/.bash_aliases ]; then
    if ! test -f aliases/.bash_aliases; then
        sudo wget -O /root/.bash_aliases https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases  
    else
        sudo cp aliases/.bash_aliases /root/
    fi 
fi

if ! [ -d /root/.bash_aliases.d/ ]; then
    sudo mkdir /root/.bash_aliases.d/
fi

if ! sudo grep -q ".bash_aliases" /root/.bashrc; then
    printf "[ -f ~/.bash_aliases ] && source ~/.bash_aliases \n" | sudo tee -a /root/.bashrc &> /dev/null
fi

if sudo test -f /root/.bashrc && ! sudo grep -q '\[ -f ~/.bash_aliases \] && source ~/.bash_aliases' /root/.bashrc; then
    if sudo grep -q '^if \[ -f ~/.bash_aliases \]; then' /root/.bashrc; then
        sudo sed -i -e 's|\(if \[ -f \~/.bash_aliases \]; then\)|#This is commented out since there'\''s a one-liner which sources ~/.bash_aliases later down ~/.bashrc\n\n#\1|g' -e 's|\(^\s*\. ~/.bash_aliases\)|#\1|' /root/.bashrc
        ubbashrcfi="$(sudo awk '/\. ~\/.bash_aliases/{print NR+1};' /root/.bashrc)" 
        sudo sed -i "$ubbashrcfi s/^fi/#fi/" /root/.bashrc   
        unset ubbashrcfi 
    fi
   
    if sudo grep -q '\[ -f ~/.keybinds \]' /root/.bashrc; then
        sudo sed -i 's|\(\[ -f \~/.keybinds \] \&\& source \~/.keybinds\)|\[ -f \~/.bash_aliases \] \&\& source \~/.bash_aliases\n\n\1|g' /root/.bashrc
    else
        echo '[ -f ~/.bash_aliases ] && source ~/.bash_aliases' | sudo tee -a /root/.bashrc &> /dev/null
    fi
fi

if ! [ -f /root/.zsh_aliases ]; then
    if ! test -f aliases/.zsh_aliases; then
        sudo wget -O /root/.zsh_aliases https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.zsh_aliases  
    else
        sudo cp aliases/.zsh_aliases /root/
    fi 
fi

if ! [ -d /root/.zsh_aliases.d/ ]; then
    sudo mkdir /root/.zsh_aliases.d/
fi

if ! sudo grep -q ".zsh_aliases" /root/.zshrc; then
    printf "[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases \n" | sudo tee -a /root/.zshrc &> /dev/null
fi

if sudo test -f /root/.zshrc && ! sudo grep -q '\[ -f ~/.zsh_aliases \] && source ~/.zsh_aliases' /root/.zshrc; then
    if sudo grep -q '^if \[ -f ~/.zsh_aliases \]; then' /root/.zshrc; then
        sudo sed -i -e 's|\(if \[ -f \~/.zsh_aliases \]; then\)|#This is commented out since there'\''s a one-liner which sources ~/.zsh_aliases later down ~/.zshrc\n\n#\1|g' -e 's|\(^\s*\. ~/.zsh_aliases\)|#\1|' /root/.zshrc
        ubzshrcfi="$(sudo awk '/\. ~\/.zsh_aliases/{print NR+1};' /root/.zshrc)" 
        sudo sed -i "$ubzshrcfi s/^fi/#fi/" /root/.zshrc   
        unset ubzshrcfi 
    fi
   
    if sudo grep -q '\[ -f ~/.keybinds \]' /root/.zshrc; then
        sudo sed -i 's|\(\[ -f \~/.keybinds \] \&\& source \~/.keybinds\)|\[ -f \~/.zsh_aliases \] \&\& source \~/.zsh_aliases\n\n\1|g' /root/.zshrc
    else
        echo '[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases' | sudo tee -a /root/.zshrc &> /dev/null
    fi
fi


if ! test -f ./checks/check_bash_source_order.sh; then
    if hash curl &> /dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_bash_source_order.sh)
    else 
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_bash_source_order.sh)
    fi
else
    . ./checks/check_bash_source_order.sh
fi
