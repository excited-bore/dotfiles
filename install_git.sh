. ./aliases/rlwrap_scripts.sh
. ./checks/check_distro.sh

 gitt(){
        if ! [ -x "$(command -v git)" ]; then
            reade -Q "GREEN" -i "y" -p "Install git? [Y/n]:" "y n" nstll
            if [ "$nstll" == "y" ]; then
                if [ $distro == "Arch" ] || [ $distro_base == "Arch" ]; then
                    yes | sudo pacman -Su git
                elif [ $distro == "Debian" ] || [ $distro_base == "Debian" ]; then
                    yes | sudo apt update
                    yes | sudo apt install git
                fi
            fi
        fi

        cp -bfv aliases/git.sh ~/.bash_aliases.d/
        gio trash ~/.bash_aliases.d/git.sh~

        if [ -x $(command -v fzf) ]; then
            reade -Q "GREEN" -i "y" -p "Fzf detected. Install fzf-git? (Extra fzf stuff on leader-key C-g): [Y/n]: /" "y n" gitfzf
            if [ "$fzfgit" == "y" ]; then
                . ./checks/check_aliases_dir.sh
                wget https://raw.githubusercontent.com/junegunn/fzf-git.sh/main/fzf-git.sh -P ~/.bash_aliases.d/
            fi
            unset fzfgit

        fi

        if [[ ! $(git config --list | grep 'name') ]]; then
            reade -Q "GREEN" -i "y" -p "Configure git name? [Y/n]: " "y n" gitname
            if [ "y" == $gitname ]; then
                reade -Q "CYAN" -p "Name: " name
                if [ ! -z $name ]; then
                    git config --global user.name "$name"
                fi
            fi
        fi
        unset name gitname

        if [[ ! $(git config --list | grep 'email') ]]; then
            reade -Q "GREEN" -i "y" -p "Configure git email? [Y/n]: " "y n" gitmail ;
            if [ "y" == $gitmail ]; then
                reade -Q "CYAN" -p "Email: " mail ;
                if [ ! -z $mail ]; then
                    git config --global user.email "$mail" ;
                fi
            fi
        fi
        unset gitmail mail

        if [[ ! $(git config --list | grep 'core.pager') ]]; then
            reade -Q "GREEN" -i "y" -p "Configure git pager? [Y/n]: " "y n" gitpager ;
            if [ "y" == $gitpager ]; then
                pagers="less cat more"
                if [ ! -x "$(command -v most)" ]; then
                    pagers=$pagers" most"
                fi
                if [ ! -x "$(command -v moar)" ]; then
                    pagers=$pagers" moar"
                fi
                if [ ! -x "$(command -v vim)" ]; then
                    pagers=$pagers" vim"
                fi
                if [ ! -x "$(command -v nvim)" ]; then
                    pagers=$pagers" nvim"
                fi
                reade -Q "CYAN" -i "less" -p "Pager: " "$pagers" pager;
                if [ "$pager" == "nvim" ] || [ "$pager" == "vim" ]; then
                    reade -Q "CYAN" -i "y" -p "You selected $pager. Will pass option for unprintable characters. Set default colorscheme? [Y/n]: " "y n" pager1
                    if [ "$pager1" == "y" ] || [ -z "$pager1" ]; then
                        pager="$pager --cmd 'set isprint=1-255' +'colorscheme default'"
                    else
                        pager="$pager --cmd 'set isprint=1-255'"
                    fi
                fi
                if [ ! -z "$pager" ]; then
                    git config --global core.pager "$pager" ;
                fi
            fi
        fi
        unset gitpager pager pager1

        if [[ ! $(git config --list | grep 'diff.tool') ]]; then
            reade -Q "GREEN" -i "y" -p "Configure git difftool? [Y/n]: " "y n" gitdiff ;
            if [ "y" == $gitmerge ]; then
                git difftool --tool-help &> $TMPDIR/gitresults
                amnt=$(cat $TMPDIR/gitresults | tail -n+2 | sed '0,/^$/d' | wc -l)
                #amnt=$((++amnt))
                rslt=$(cat $TMPDIR/gitresults | tail -n+2 | head -n-"$amnt" | awk '{print $1}')
                git difftool --tool-help
                reade -Q "CYAN" -p "Difftool: " "$(git difftool --tool-help)" "$rslt" diff ;
                if [ ! -z $diff ]; then
                    git config --global diff.tool "$diff" ;
                    git config --global diff.guitool "$diff" ;
                fi
            fi
        fi

        if [[ ! $(git config --list | grep 'merge.tool') ]]; then
            reade -Q "GREEN" -i "y" -p "Configure git mergetool? [Y/n]: " "y n" gitmerge ;
            if [ "y" == $gitmerge ]; then
                git mergetool --tool-help &> $TMPDIR/gitresults
                amnt=$(cat $TMPDIR/gitresults | tail -n+2 | sed '0,/^$/d' | wc -l)
                #amnt=$((++amnt))
                rslt=$(cat $TMPDIR/gitresults | tail -n+2 | head -n-"$amnt" | awk '{print $1}')
                git mergetool --tool-help
                reade -Q "CYAN" -p "Mergetool: " "$(git mergetool --tool-help)" "$rslt" merge ;
                if [ ! -z $merge ]; then
                    git config --global merge.tool "$merge" ;
                    git config --global merge.guitool "$merge" ;
                fi
            fi

        fi

        reade -Q "GREEN" -i "y" -p "Check git config? [Y/n]: " "y n" gitcnf ;
        if [ "y" == $gitcnf ]; then
            git config --global -e
        fi

        reade -Q "GREEN" -i "y" -p "Check and create global gitignore? (~/.config/git/ignore) [Y/n]: " "y n" gitign
        if [ "y" == "$gitign" ]; then
           ./install_gitignore.sh
        fi

        unset gitdiff diff gitmerge merge amt rslt gitcnf gitign
        if [ ! -x "$(command -v copy-to)" ]; then
            reade -Q "GREEN" -i "y" -p "Install copy-to? [Y/n]: " "y n" cpcnf;
            if [ "y" == $cpcnf ] || [ -z $cpcnf ]; then
                ./install_copy-conf.sh
            fi
        fi
    }
    yes_edit_no gitt "aliases/git.sh" "Install git.sh at ~/.bash_aliases.d/ (git aliases)? " "yes" "GREEN"
