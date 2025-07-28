if [ ! -f ~/.keybinds ]; then
    if ! test -f keybinds/.keybinds; then
        wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/keybinds/.keybinds > ~/.keybinds  
    else
        cp keybinds/.keybinds ~/
    fi 
fi 

if [ ! -d ~/.keybinds.d/ ]; then
    mkdir ~/.keybinds.d/
fi

if ! grep -q ".keybinds" ~/.bashrc; then
    printf "\n[ -f ~/.keybinds ] && source ~/.keybinds\n\n" >> ~/.bashrc 
fi

if ! sudo test -d /root/.keybinds.d/ ; then
    sudo mkdir /root/.keybinds.d/
fi

if ! sudo grep -q ".keybinds" /root/.bashrc; then
    sudo printf "\n[ -f ~/.keybinds ] && source ~/.keybinds\n\n" | sudo tee -a /root/.bashrc &> /dev/null
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
