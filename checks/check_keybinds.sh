if [ ! -f ~/.keybinds ]; then
    if ! test -f keybinds/.keybinds; then
        wget -O ~/.keybinds https://raw.githubusercontent.com/excited-bore/dotfiles/main/keybinds/.keybinds   
    else
        cp keybinds/.keybinds ~/
    fi 
fi 

if [ ! -d ~/.keybinds.d/ ]; then
    mkdir ~/.keybinds.d/
fi

# Make sure the ~/.keybinds sources AFTER ~/.bash_aliases to prevent certain keybinds from breaking
if ! grep -q "source ~/.keybinds" ~/.bashrc; then
    if grep -q "\[ -f ~/.bash_aliases \] \&\& source ~/.bash_aliases" ~/.bashrc || grep -q '^if [ -f ~/.bash_aliases ]; then' ~/.bashrc; then
        if grep -q "\[ -f ~/.bash_aliases \] \&\& source ~/.bash_aliases" ~/.bashrc; then
            sed -i 's|\(\[ -f ~/.keybinds \] \&\& source ~/.keybinds\)|\1\n\n[ -f ~/.keybinds \] \&\& source ~/.keybinds|' ~/.bashrc 
        else
            sed -i -e 's|\(if \[ -f \~/.bash_aliases \]; then\)|#This is commented out since there'\''s a one-liner which sources ~/.bash_aliases later down ~/.bashrc\n\n#\1|g' -e 's|\(^\s*\. ~/.bash_aliases\)|#\1|' ~/.bashrc
            ubbashrcfi="$(awk '/\. ~\/.bash_aliases/{print NR+1};' ~/.bashrc)" 
            sed -i "$ubbashrcfi s/^fi/#fi/" ~/.bashrc   
            unset ubbashrcfi 
            sed -i 's|\(\^if [ -f ~/.bash_aliases ]; then\)|[ -f ~/.bash_completion \] \&\& source ~/.bash_completion\n\n\1|' ~/.bashrc 
            printf '[ -f ~/.bash_aliases ] && source ~/.bash_aliases\n\n' >> ~/.bashrc
            echo '[ -f ~/.keybinds ] && source ~/.keybinds' >> ~/.bashrc
        fi
    else
        printf "\n[ -f ~/.bash_completion ] && source ~/.bash_completion\n\n" >> ~/.bashrc
    fi
fi

if ! grep -q "source ~/.keybinds" ~/.zshrc; then
    if grep -q "\[ -f ~/.zsh_aliases \] \&\& source ~/.zsh_aliases" ~/.zshrc || grep -q '^if [ -f ~/.zsh_aliases ]; then' ~/.zshrc; then
        if grep -q "\[ -f ~/.zsh_aliases \] \&\& source ~/.zsh_aliases" ~/.zshrc; then
            sed -i 's|\(\[ -f ~/.keybinds \] \&\& source ~/.keybinds\)|\1\n\n[ -f ~/.keybinds \] \&\& source ~/.keybinds|' ~/.zshrc 
        else
            sed -i -e 's|\(if \[ -f \~/.zsh_aliases \]; then\)|#This is commented out since there'\''s a one-liner which sources ~/.zsh_aliases later down ~/.zshrc\n\n#\1|g' -e 's|\(^\s*\. ~/.zsh_aliases\)|#\1|' ~/.zshrc
            ubzshrcfi="$(awk '/\. ~\/.zsh_aliases/{print NR+1};' ~/.zshrc)" 
            sed -i "$ubzshrcfi s/^fi/#fi/" ~/.zshrc   
            unset ubzshrcfi 
            sed -i 's|\(\^if [ -f ~/.zsh_aliases ]; then\)|[ -f ~/.zsh_completion \] \&\& source ~/.zsh_completion\n\n\1|' ~/.zshrc 
            printf '[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases\n\n' >> ~/.zshrc
            echo '[ -f ~/.keybinds ] && source ~/.keybinds' >> ~/.zshrc
        fi
    else
        printf "\n[ -f ~/.zsh_completion ] && source ~/.zsh_completion\n\n" >> ~/.zshrc
    fi
fi


echo "Next $(tput setaf 1)sudo$(tput sgr0) will install '.keybinds.d' in /root and source it with '/root/.keybinds' in /root/.bashrc"

if ! test -f /root/.keybinds; then
    if ! test -f keybinds/.keybinds; then
        sudo wget -O /root/.keybinds https://raw.githubusercontent.com/excited-bore/dotfiles/main/keybinds/.keybinds 
    else
        sudo cp keybinds/.keybinds /root/
    fi 
fi 


if ! sudo test -d /root/.keybinds.d/ ; then
    sudo mkdir /root/.keybinds.d/
fi

if ! sudo grep -q "source ~/.keybinds" /root/.bashrc; then
    if sudo grep -q "\[ -f ~/.bash_aliases \] \&\& source ~/.bash_aliases" /root/.bashrc || sudo grep -q '^if [ -f ~/.bash_aliases ]; then' /root/.bashrc; then
        if sudo grep -q "\[ -f ~/.bash_aliases \] \&\& source ~/.bash_aliases" /root/.bashrc; then
            sudo sed -i 's|\(\[ -f ~/.keybinds \] \&\& source ~/.keybinds\)|\1\n\n[ -f ~/.keybinds \] \&\& source ~/.keybinds|' /root/.bashrc 
        else
            sudo sed -i -e 's|\(if \[ -f \~/.bash_aliases \]; then\)|#This is commented out since there'\''s a one-liner which sources ~/.bash_aliases later down ~/.bashrc\n\n#\1|g' -e 's|\(^\s*\. ~/.bash_aliases\)|#\1|' /root/.bashrc
            ubbashrcfi="$(sudo awk '/\. ~\/.bash_aliases/{print NR+1};' /root/.bashrc)" 
            sudo sed -i "$ubbashrcfi s/^fi/#fi/" /root/.bashrc   
            unset ubbashrcfi 
            sudo sed -i 's|\(\^if [ -f ~/.bash_aliases ]; then\)|[ -f ~/.bash_completion \] \&\& source ~/.bash_completion\n\n\1|' /root/.bashrc 
            printf '[ -f ~/.bash_aliases ] && source ~/.bash_aliases\n\n' | sudo tee -a /root/.bashrc
            echo '[ -f ~/.keybinds ] && source ~/.keybinds' | sudo tee -a /root/.bashrc
        fi
    else
        printf "\n[ -f ~/.bash_completion ] && source ~/.bash_completion\n\n" | sudo tee -a /root/.bashrc
    fi
fi

if ! sudo grep -q "source ~/.keybinds" /root/.zshrc; then
    if sudo grep -q "\[ -f ~/.zsh_aliases \] \&\& source ~/.zsh_aliases" /root/.zshrc || sudo grep -q '^if [ -f ~/.zsh_aliases ]; then' /root/.zshrc; then
        if sudo grep -q "\[ -f ~/.zsh_aliases \] \&\& source ~/.zsh_aliases" /root/.zshrc; then
            sudo sed -i 's|\(\[ -f ~/.keybinds \] \&\& source ~/.keybinds\)|\1\n\n[ -f ~/.keybinds \] \&\& source ~/.keybinds|' /root/.zshrc 
        else
            sudo sed -i -e 's|\(if \[ -f \~/.zsh_aliases \]; then\)|#This is commented out since there'\''s a one-liner which sources ~/.zsh_aliases later down ~/.zshrc\n\n#\1|g' -e 's|\(^\s*\. ~/.zsh_aliases\)|#\1|' /root/.zshrc
            ubzshrcfi="$(sudo awk '/\. ~\/.zsh_aliases/{print NR+1};' /root/.zshrc)" 
            sudo sed -i "$ubzshrcfi s/^fi/#fi/" /root/.zshrc   
            unset ubzshrcfi 
            sudo sed -i 's|\(\^if [ -f ~/.zsh_aliases ]; then\)|[ -f ~/.zsh_completion \] \&\& source ~/.zsh_completion\n\n\1|' /root/.zshrc 
            printf '[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases\n\n' | sudo tee -a /root/.zshrc
            echo '[ -f ~/.keybinds ] && source ~/.keybinds' | sudo tee -a /root/.zshrc
        fi
    else
        printf "\n[ -f ~/.zsh_completion ] && source ~/.zsh_completion\n\n" | sudo tee -a /root/.zshrc
    fi
fi


# Check one last time if ~/.bash_preexec - for both $USER and root - is the last line in their ~/.bash_profile and ~/.bashrc

if ! test -f ./checks/check_bash_source_order.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_bash_source_order.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_bash_source_order.sh)
    fi
else
    . ./checks/check_bash_source_order.sh
fi
