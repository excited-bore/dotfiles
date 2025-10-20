# https://github.com/ajeetdsouza/zoxide

hash zoxide &> /dev/null && SYSTEM_UPDATED='TRUE'

TOP=$(git rev-parse --show-toplevel)

if ! [[ -f $TOP/checks/check_all.sh ]]; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi

# https://github.com/ajeetdsouza/zoxide?tab=readme-ov-file#installation
if ! hash zoxide &>/dev/null; then
    if [[ $machine == 'Mac' ]] && hash brew &>/dev/null; then
        brew install zoxide
    elif [[ $distro_base == 'Arch' ]]; then
        eval "$pac_ins_y zoxide"
    elif [[ "$distro_base" == 'Debian' ]]; then
        eval "$pac_ins_y zoxide"
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
        if ! hash cargo &>/dev/null; then
            if ! [[ -f $TOP/cli-tools/pkgmngrs/install_cargo.sh ]]; then
                source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_cargo.sh)
            else
                . $TOP/cli-tools/pkgmngrs/install_cargo.sh
            fi
        fi
        cargo install zoxide --locked
    fi
fi

if ! grep -q 'eval "$(zoxide init bash)"' ~/.bashrc; then
    printf 'eval "$(zoxide init bash)"\n' >>~/.bashrc
fi

if ! grep -q 'eval "$(zoxide init zsh)"' ~/.zshrc; then
    printf 'eval "$(zoxide init zsh)"\n' >>~/.zshrc
fi

if hash autojump &>/dev/null; then
    readyn -p 'Import data from autojump?' fse
    if [[ $fse == 'y' ]]; then
        if [[ $machine == 'Mac' ]]; then
            [[ -f $HOME/Library/autojump/autojump.txt ]] && 
                zoxide import --from=autojump "$HOME/Library/autojump/autojump.txt"
        else
            [[ -f $XDG_DATA_HOME/autojump/autojump.txt ]] && 
                zoxide import --from=autojump "$XDG_DATA_HOME/autojump/autojump.txt"
        fi
    fi
    unset fse
fi

if hash fzf &>/dev/null; then
     
    if test -d ~/.bash_completion.d && ! test -f ~/.bash_completion.d/zoxide.bash; then
        printf "function __zoxide_zi() {     
    builtin local result;     
    result=\"\$(command zoxide query --interactive)\" && __zoxide_cd \"\${result}\"; 
}

complete -F __zoxide_zi -o default -o bashdefault z\n" >>~/.bash_completion.d/zoxide.bash
        printf "Added fzf completion thingy for zoxide (z ** TAB) in bash\n"
    fi
   
    if test -d ~/.zsh_completion.d && ! test -f ~/.zsh_completion.d/zoxide.zsh; then

        printf "__zoxide_zi() {
    local result
      result=\$(command zoxide query --interactive) || return
      __zoxide_cd \"\$result\"
    }

compdef __zoxide_zi z\n" >> ~/.zsh_completion.d/zoxide.zsh 
        printf "Added fzf completion thingy for zoxide (z ** TAB) in zsh\n"
    fi
fi
