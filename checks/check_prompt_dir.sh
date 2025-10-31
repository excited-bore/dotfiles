if ! [ -f ~/.prompt ]; then
    if ! test -f prompt/.prompt; then
        wget -O ~/.prompt https://raw.githubusercontent.com/excited-bore/dotfiles/main/prompt/.prompt  
    else
        cp prompt/.prompt ~/
    fi 
fi

if ! [ -d ~/.prompt.d/ ]; then
    mkdir ~/.prompt.d/
fi

if test -f ~/.bashrc && ! grep -q '\[ -f ~/.prompt \] && source ~/.prompt' ~/.bashrc; then
    if grep -q '\[ -f ~/.bash_completion \]' ~/.bashrc; then
        sed -i 's|\(\[ -f \~/.bash_completion \] \&\& source \~/.bash_completion\)|\[ -f \~/.prompt \] \&\& source \~/.prompt\n\n\1|g' ~/.bashrc
    elif grep -q '\[ -f ~/.bash_aliases \]' ~/.bashrc; then
        sed -i 's|\(\[ -f \~/.bash_aliases \] \&\& source \~/.bash_aliases\)|\[ -f \~/.prompt \] \&\& source \~/.prompt\n\n\1|g' ~/.bashrc
    elif grep -q '\[ -f ~/.keybinds \]' ~/.bashrc; then
        sed -i 's|\(\[ -f \~/.keybinds \] \&\& source \~/.keybinds\)|\[ -f \~/.prompt \] \&\& source \~/.prompt\n\n\1|g' ~/.bashrc
    elif grep -q '\[\[ ! ${BLE_VERSION-} \]\] || ble-attach' ~/.bashrc; then
        sed -i 's|\(\[\[ ! ${BLE_VERSION-} \]\] \|\| ble-attach\)|\[ -f \~/.prompt \] \&\& source \~/.prompt\n\n\1|g' ~/.bashrc
    else
        echo '[ -f ~/.prompt ] && source ~/.prompt' >> ~/.bashrc
    fi
fi
