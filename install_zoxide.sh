#!/usr/bin/env bash

if ! test -f checks/check_all.sh; then
    if type curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
        return 1 || exit 1
    fi
else
    . ./checks/check_all.sh
fi

get-script-dir SCRIPT_DIR

# https://github.com/ajeetdsouza/zoxide?tab=readme-ov-file#installation
if ! type zoxide &>/dev/null; then
    if [[ $machine == 'Mac' ]] && type brew &>/dev/null; then
        brew install zoxide
    elif [[ $distro_base == 'Arch' ]]; then
        sudo pacman -S zoxide
    elif [[ $distro_base == 'Debian' ]]; then
        sudo apt install zoxide
    elif [[ $distro == 'Fedora' ]]; then
        sudo dnf install zoxide
    elif [[ $distro == 'openSUSE' ]]; then
        sudo zypper install zoxide
    elif [[ $distro == 'Gentoo' ]]; then
        sudo emerge app-shells/zoxide
    elif [[ $distro == 'Alpine' ]]; then
        sudo apk add zoxide
    elif type nix-env &>/dev/null; then
        nix-env -iA nixpkgs.zoxide
    else
        if ! type cargo &>/dev/null; then
            if ! test -f install_cargo.sh; then
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_cargo.sh)"
            else
                . ./install_cargo.sh
            fi
        fi
        cargo install zoxide --locked
    fi
fi

if ! grep -q 'eval "$(zoxide init bash)"' ~/.bashrc; then
    printf 'eval "$(zoxide init bash)"\n' >>~/.bashrc
fi

if type autojump &>/dev/null; then
    readyn -p 'Import data from autojump?' fse
    if [[ $fse == 'y' ]]; then
        if [[ $machine == 'Mac' ]]; then
            test -f $HOME/Library/autojump/autojump.txt && zoxide import --from=autojump "$HOME/Library/autojump/autojump.txt"
        else
            test -f $HOME/.local/share/autojump/autojump.txt && zoxide import --from=autojump "$HOME/.local/share/autojump/autojump.txt"
        fi
    fi
    unset fse
fi

if type fzf &>/dev/null && test -d ~/.bash_completion.d/ && ! test -f ~/.bash_completion.d/complete-zoxide; then
    touch ~/.bash_completion.d/complete-zoxide
    printf "function __zoxide_zi() {     
    builtin local result;     
    result=\"\$(command zoxide query --interactive)\" && __zoxide_cd \"\${result}\"; 
}

[ -n \"\$BASH\" ] && complete -F __zoxide_zi -o default -o bashdefault z\n" >>~/.bash_completion.d/complete-zoxide
    printf "Added fzf completion thingy for zoxide (z ** TAB)\n"
fi
