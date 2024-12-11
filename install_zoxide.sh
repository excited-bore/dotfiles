if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! test -f aliases/.bash_aliases.d/00-rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
fi 

if ! test -f checks/check_envvar.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_envvar.sh)" 
else
    . ./checks/check_envvar.sh
fi

if ! type update-system &> /dev/null; then
    if ! test -f aliases/.bash_aliases.d/update-system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/update-system.sh)" 
    else
        . ./aliases/.bash_aliases.d/update-system.sh
    fi
fi

if test -z $SYSTEM_UPDATED; then
    readyn -Y "CYAN" -p "Update system?" updatesysm
    if test $updatesysm == "y"; then
        update-system                     
    fi
fi 

# https://github.com/ajeetdsouza/zoxide?tab=readme-ov-file#installation

if ! type zoxide &>/dev/null; then
    if test $machine == 'Mac' && type brew &> /dev/null; then
        brew install zoxide   
    elif test $distro == 'Arch'; then
        sudo pacman -S zoxide 
    elif test $distro == 'Debian'; then
        sudo apt install zoxide 
    elif test $distro == 'Fedora'; then
        sudo dnf install zoxide 
    elif test $distro == 'Fedora'; then
        sudo dnf install zoxide 
    elif test $distro == 'openSUSE'; then
        sudo zypper install zoxide
    elif test $distro == 'Gentoo'; then
        sudo emerge app-shells/zoxide
    elif test $distro == 'Alpine'; then
        sudo apk add zoxide
    elif type nix-env &> /dev/null; then
        nix-env -iA nixpkgs.zoxide
    else
        if ! type cargo &> /dev/null; then
            if ! test -f install_cargo.sh; then
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_cargo.sh)"
            else
               ./install_cargo.sh
            fi
        fi
        cargo install zoxide --locked 
    fi
fi

if ! grep -q 'eval "$(zoxide init bash)"' ~/.bashrc; then
    printf 'eval "$(zoxide init bash)"' >> ~/.bashrc
fi

if type autojump &> /dev/null; then
   readyn -p 'Import data from autojump?' fse
   if test $fse == 'y'; then
        if test $machine == 'Mac'; then
            test -f $HOME/Library/autojump/autojump.txt && zoxide import --from=autojump "$HOME/Library/autojump/autojump.txt"
        else 
            test -f $HOME/.local/share/autojump/autojump.txt && zoxide import --from=autojump "$HOME/.local/share/autojump/autojump.txt"
        fi
   fi
   unset fse 
fi

if type fzf &> /dev/null && test -d ~/.bash_completion.d/ && ! test -f ~/.bash_completion.d/complete-zoxide; then
    touch ~/.bash_completion.d/complete-zoxide
    printf "function __zoxide_zi() {     
    builtin local result;     
    result=\"\$(command zoxide query --interactive)\" && __zoxide_cd \"\${result}\"; 
}

[ -n \"\$BASH\" ] && complete -F __zoxide_zi -o default -o bashdefault z\n" >> ~/.bash_completion.d/complete-zoxide
    printf "Added fzf completion thingy for zoxide (z ** TAB)\n" 
fi
