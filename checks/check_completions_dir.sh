#if ! grep -q "/usr/share/bash-completion/bash_completion" ~/.bashrc; then
#    echo "[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion" >> ~/.bashrc
#fi

if [ ! -f ~/.bash_completion ]; then
    if ! test -f completions/.bash_completion; then
        wget -O ~/.bash_completion https://raw.githubusercontent.com/excited-bore/dotfiles/main/completions/.bash_completion
    else
        cp completions/.bash_completion ~/
    fi 
fi


if [ ! -d ~/.bash_completion.d/ ]; then
    mkdir ~/.bash_completion.d/
fi

# Make sure the ~/.bash_completion sources BEFORE ~/.bash_aliases to prevent bashalias-completions from breaking
if ! grep -q "~/.bash_completion" ~/.bashrc; then
    if grep -q "\[ -f ~/.bash_aliases \] \&\& source ~/.bash_aliases" ~/.bashrc || grep -q '^if [ -f ~/.bash_aliases ]; then' ~/.bashrc; then
        if grep -q "\[ -f ~/.bash_aliases \] \&\& source ~/.bash_aliases" ~/.bashrc; then
            sed -i 's|\(\[ -f ~/.bash_aliases \] \&\& source ~/.bash_aliases\)|[ -f ~/.bash_completion \] \&\& source ~/.bash_completion\n\n\1|' ~/.bashrc 
        else
            sed -i 's|\(\^if [ -f ~/.bash_aliases ]; then\)|[ -f ~/.bash_completion \] \&\& source ~/.bash_completion\n\n\1|' ~/.bashrc 
        fi
    else
        printf "\n[ -f ~/.bash_completion ] && source ~/.bash_completion\n\n" >> ~/.bashrc
    fi
fi


echo "Next $(tput setaf 1)sudo$(tput sgr0) will install '.bash_completion.d' in /root and source it with '/root/.bash_completion' in /root/.bashrc"

if ! sudo test -f /root/.bash_completion; then
    echo "Next $(tput setaf 1)sudo$(tput sgr0) will install '.bash_completion.d' in /root and source it with '/root/.bash_completion"
    if [ ! -f /root/.bash_completion ]; then
        if ! test -f completions/.bash_completion; then
            sudo wget -O /root/.bash_completion https://raw.githubusercontent.com/excited-bore/dotfiles/main/completions/.bash_completion  
        else
            sudo cp completions/.bash_completion /root/
        fi 
    fi
fi

if ! sudo test -d /root/.bash_completion.d/; then
    sudo mkdir /root/.bash_completion.d/
fi

if ! sudo grep -q "~/.bash_completion" /root/.bashrc; then
    if sudo grep -q "\[ -f ~/.bash_aliases \] \&\& source ~/.bash_aliases" /root/.bashrc || sudo grep -q '^if [ -f ~/.bash_aliases ]; then' /root/.bashrc; then
        if sudo grep -q "\[ -f ~/.bash_aliases \] \&\& source ~/.bash_aliases" /root/.bashrc; then
            sudo sed -i 's|\(\[ -f ~/.bash_aliases \] \&\& source ~/.bash_aliases\)|[ -f ~/.bash_completion \] \&\& source ~/.bash_completion\n\n\1|' /root/.bashrc 
        else
            sudo sed -i 's|\(\^if [ -f ~/.bash_aliases ]; then\)|[ -f ~/.bash_completion \] \&\& source ~/.bash_completion\n\n\1|' /root/.bashrc 
        fi
    else
        printf "\n[ -f ~/.bash_completion ] && source ~/.bash_completion\n\n" | sudo tee -a /root/.bashrc &> /dev/null
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
