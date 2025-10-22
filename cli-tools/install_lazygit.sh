# https://github.com/jesseduffield/lazygit

hash lazygit &> /dev/null && SYSTEM_UPDATED='TRUE'

TOP=$(git rev-parse --show-toplevel 2> /dev/null)

if ! test -f $TOP/checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi

if ! hash lazygit &>/dev/null; then
    if [[ "$distro_base" == "Arch" ]]; then
        eval "${pac_ins_y}" lazygit
    elif [[ "$distro_base" == "Debian" ]]; then
        if [[ -n "$(apt-cache show lazygit)" ]]; then
            eval "${pac_ins_y}" lazygit
        else
            LAZYGIT_VERSION=$(wget-curl "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po --color=never '"tag_name": "v\K[^"]*')
            if [[ "$arch" == '386' || "$arch" == 'amd32' || "$arch" == 'amd64' ]]; then
                 archl='x86_64'
            elif [[ "$arch" =~ arm ]]; then  
                 archl=$arch            
            fi
            (cd $TMPDIR  
            wget-aria-name lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_$archl.tar.gz"
            tar xf lazygit.tar.gz lazygit
            sudo install -t /usr/local/bin lazygit)
            unset archl 
        fi
    fi
    unset nstll
fi
lazygit --help | $PAGER

file=$TOP/cli-tools/lazygit/.config/lazygit/config.yml.example
if ! test -f $file; then
    dir=$(mktemp -d) 
    wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/lazygit/.config/lazygit/config.yml.example) > $dir/config.yml.example
    file=$dir 
fi

readyn -p 'Configure lazygit?' conflazy
if [[ 'y' == $conflazy ]]; then
    function cp_lazy_conf() {
        mkdir -p $XDG_CONFIG_HOME/lazygit/
        cp $file $XDG_CONFIG_HOME/lazygit/config.yml.example
    }
    yes-edit-no -g "$file" -p 'Copy an example lazygit yaml config file into $XDG_CONFIG_HOME/lazygit/?' -f cp_lazy_conf -c "test -f $XDG_CONFIG_HOME/lazygit/config.yml.example || ! (test -f $XDG_CONFIG_HOME/lazygit/config.yml.example && [[ -n $(diff $XDG_CONFIG_HOME/lazygit/config.yml.example $file 2>/dev/null) ]])"
    if ! [[ -f $TOP/cli-tools/install_git.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_git.sh)
    else
        . $TOP/cli-tools/install_git.sh
    fi

    readyn -Y "CYAN" -p "Configure custom interactive diff filter for Lazygit?" gitdiff1
    if [[ "y" == "$gitdiff1" ]]; then
        readyn -p "Install custom diff syntax highlighter?" -c "hash delta &> /dev/null || hash diff-so-fancy &> /dev/null || hash riff &> /dev/null || hash ydiff &> /dev/null || hash diffr &> /dev/null || hash colordiff &> /dev/null || hash kdiff3 &> /dev/null || hash p4merge &> /dev/null || hash difft &> /dev/null" gitpgr
        if [[ "$gitpgr" == "y" ]]; then
            if ! [[ -f $TOP/install_differ.sh ]]; then
                source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_differ.sh)
            else
                . $TOP/install_differ.sh
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
#    if ! test -d ~/.aliases.d/ || ! test -f ~/.aliases.d/lazygit.sh || (test -f ~/.aliases.d/lazygit.sh && ! grep -q "copy-to" ~/.aliases.d/lazygit.sh); then
#        readyn -p "Set up an alias so copy-to does a 'run all' when starting up lazygit?" nstll
#        if [[ "$nstll" == "y" ]]; then
#            if ! test -f ~/.aliases.d/lazygit.sh; then
#                printf "alias lazygit=\"copy-to run all; lazygit\"\n" >~/.aliases.d/lazygit.sh
#                echo "$(tput setaf 2)File in ~/.aliases.d/lazygit.sh"
#            fi
#        fi
#        unset nstll
#    fi
#fi
#unset nstll
