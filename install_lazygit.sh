DLSCRIPT=1

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

SCRIPT_DIR=$(get-script-dir)

if ! type lazygit &>/dev/null; then
    if [[ "$distro_base" == "Arch" ]]; then
        eval "${pac_ins}" lazygit
    elif [[ "$distro_base" == "Debian" ]]; then
        if ! test -z "$(apt search --names-only lazygit 2>/dev/null | awk 'NR>2 {print;}')"; then
            eval "${pac_ins}" lazygit
        else
            if ! type curl &>/dev/null; then
                eval "${pac_ins} curl"
            fi
            LAZYGIT_VERSION=$(curl "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po --color=never '"tag_name": "v\K[^"]*')
            (cd $TMPDIR  
            wget-aria-name lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
            tar xf lazygit.tar.gz lazygit)
            sudo install $TMPDIR/lazygit -D -t /usr/local/bin
        fi
    fi
    unset nstll
fi
lazygit --help | $PAGER

file=lazygit/.config/lazygit/config.yml.example
if ! test -f $file; then
    file=$(wget-aria-name ~/.config/lazygit/config.yml.example https://raw.githubusercontent.com/excited-bore/dotfiles/main/lazygit/.config/lazygit/config.yml.example)
fi

readyn -p 'Configure lazygit?' conflazy
if [[ 'y' == $conflazy ]]; then
    function cp_lazy_conf() {
        mkdir -p ~/.config/lazygit/
        cp -f $file ~/.config/lazygit/config.yml.example
    }
    yes-edit-no -g "$file" -p 'Copy an example lazygit yaml config file into ~/.config/lazygit/?' -f cp_lazy_conf -c "test -f ~/.config/lazygit/config.yml.example || ! (test -f ~/.config/lazygit/config.yml.example && test -n $(diff ~/.config/lazygit/config.yml.example $file 2>/dev/null)) &> /dev/null"
    if ! test -f install_differ_pager.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_git.sh)
    else
        . ./install_git.sh
    fi

    readyn -Y "CYAN" -p "Configure custom interactive diff filter for Lazygit?" gitdiff1
    if [[ "y" == "$gitdiff1" ]]; then
        readyn -n -p "Install custom diff syntax highlighter?" gitpgr
        if [[ "$gitpgr" == "y" ]]; then
            if ! test -f install_differ.sh; then
                source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_differ.sh)
            else
                . ./install_differ.sh
            fi
        fi
        git_hl "lazygit"
    fi
fi

#if ! type copy-to &>/dev/null; then
#    readyn -p "Install copy-to?" cpcnf
#    if [[ "y" == "$cpcnf" ]] || [ -z "$cpcnf" ]; then
#        if ! test -f install_copy-to.sh; then
#            /bin/bash -c "$(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_copy-to.sh)"
#        else
#            . ./install_copy-to.sh
#        fi
#    fi
#fi
#
#if type copy-to &>/dev/null; then
#    if ! test -d ~/.bash_aliases.d/ || ! test -f ~/.bash_aliases.d/lazygit.sh || (test -f ~/.bash_aliases.d/lazygit.sh && ! grep -q "copy-to" ~/.bash_aliases.d/lazygit.sh); then
#        readyn -p "Set up an alias so copy-to does a 'run all' when starting up lazygit?" nstll
#        if [[ "$nstll" == "y" ]]; then
#            if ! test -f checks/check_aliases_dir.sh; then
#                source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_aliases_dir.sh)
#            else
#                . ./checks/check_aliases_dir.sh
#            fi
#            if ! test -f ~/.bash_aliases.d/lazygit.sh; then
#                printf "alias lazygit=\"copy-to run all; lazygit\"\n" >~/.bash_aliases.d/lazygit.sh
#                echo "$(tput setaf 2)File in ~/.bash_aliases.d/lazygit.sh"
#            fi
#        fi
#        unset nstll
#    fi
#fi
#unset nstll
