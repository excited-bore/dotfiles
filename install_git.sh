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

        if ! [ -x "$(command -v lazygit)" ]; then
            ./install_lazygit.sh
        fi

        if [ -x $(command -v fzf) ]; then
            reade -Q "GREEN" -i "y" -p "Fzf detected. Install fzf-git? (Extra fzf stuff on leader-key C-g): [Y/n]: " "y n" gitfzf
            if [ "$fzfgit" == "y" ]; then
                . ./checks/check_aliases_dir.sh
                wget https://raw.githubusercontent.com/junegunn/fzf-git.sh/main/fzf-git.sh -P ~/.bash_aliases.d/
            fi
        fi

        local global=""
        reade -Q "CYAN" -i "y" -p "Configure git globally?: " "y n" gitglobal
        if [ "y" == $gitglobal ]; then
            global="--global"
        fi
        unset gitglobal
        
        reade -Q "CYAN" -i "y" -p "Configure git name? [Y/n]: " "y n" gitname
        if [ "y" == $gitname ]; then
            reade -Q "CYAN" -p "Name: " name
            if [ ! -z $name ]; then
                git config $global user.name "$name"
            fi
        fi
        unset name gitname

        reade -Q "CYAN" -i "y" -p "Configure git email? [Y/n]: " "y n" gitmail ;
        if [ "y" == $gitmail ]; then
            reade -Q "CYAN" -p "Email: " mail ;
            if [ ! -z $mail ]; then
                git config $global user.email "$mail" ;
            fi
        fi
        unset gitmail mail

        local gitpgr            
        reade -Q "CYAN" -i "y" -p "Set git core pager? [Y/n]: " "y n" gitpgr ;
        if [ "y" == $gitpgr ]; then
            reade -Q "CYAN" -i "y" -p "Install custom pager? [Y/n]: " "y n" gitpgr ;
            if test $gitpgr == "y"; then
                reade -Q "GREEN" -i "bat" -p "Which pager to install? [Bat/moar/most]: " "bat moar most" pager 
                if test $pager == "bat"; then
                    . ./install_bat.sh
                elif test $pager == "moar"; then
                    . ./install_moar.sh
                elif test $pager == "most"; then
                    . ./install_most.sh
                fi
            fi
            unset pager 

            reade -Q "CYAN" -i "regular" -p "Regular pager or cat variant (outputs to screen)? [Regular/cat]: " "regular cat" regpager ;
            if test "$regpager" == "regular"; then
                
                pagers="less more"
                pager="less"
                
                if [ ! -x "$(command -v most)" ]; then
                    pagers=$pagers" most"
                fi
                if [ ! -x "$(command -v moar)" ]; then
                    pagers=$pagers" moar"
                fi
                if [ ! -x "$(command -v vim)" ]; then
                    pagers=$pagers" vim"
                    pager="vim"
                fi
                if [ ! -x "$(command -v nvim)" ]; then
                    pagers=$pagers" nvim"
                    pager="nvim"
                fi

                reade -Q "CYAN" -i "less" -p "Pager: " "$pagers" pager;
                if test $pager == 'less'; then
                    reade -Q "CYAN" -i "y" -p "You selected $pager. Don't page if content fits on a single screen?: " "y n" pager1
                    if test $pager1 == 'y'; then
                        pager='less -FR'
                    else 
                        pager='less -R'
                    fi
                elif [ "$pager" == "nvim" ] || [ "$pager" == "vim" ]; then
                    echo "You selected $pager."
                    colors="blue darkblue default delek desert elflord evening gruvbox habamax industry koehler lunaperch morning murphy pablo peachpuff quiet ron shine slate torte zellner"
                    if test $pager == "vim"; then
                       colors=$colors" retrobox sorbet wildcharm zaibatsu" 
                    fi
                    pager="$pager --cmd 'set isprint=1-255'"
                    reade -Q "CYAN" -i "y" -p "Set colorscheme? [Y/n]: " "y n" pager1
                    if [ "$pager1" == "y" ]; then
                        reade -Q "CYAN" -i "default" -p "Colorscheme: " "$colors" color
                        pager="$pager +'colorscheme $color'"
                    fi
                if [ ! -z "$pager" ]; then
                    git config $global core.pager "$pager" ;
                fi
            elif test "$regpager" == "cat"; then
                pagers="cat"
                pager="cat"
                if [ ! -x "$(command -v bat)" ]; then
                    pagers=$pagers" bat"
                fi
                reade -Q "CYAN" -i "cat" -p "Pager: " "$pagers" pager;
                if [ $pager == "bat" ]; then
                    pager="bat --paging=never"
                fi
                if [ ! -z "$pager" ]; then
                    git config $global core.pager "$pager" ;
                fi
            fi
            unset gitpager pager pager1 colors
        fi


        
        reade -Q "CYAN" -i "y" -p "Install custom diff? [Y/n]: " "y n" gitpager ;
        if test "y" == $gitpager; then    
            . ./install_diffs.sh            
        fi 

        local diff
        reade -Q "CYAN" -i "y" -p "Set custom git diff? [Y/n]: " "y n" gitdiff ;
        if [ "y" == $gitdiff ]; then
            echo "NOT YET"
        fi

        reade -Q "GREEN" -i "y" -p "Install and configure different git (diff) pager? [Y/n]: " "y n" gitpager ;
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
            if test $pager == 'less'; then
                pager='less -R'
            fi
            
            elif [ "$pager" == "delta" ]; then
                reade -Q "CYAN" -i "n" -p "You selected $pager. Configure [Y/n]?: " "y n" pager1
                if [ "$pager1" == "y" ]; then
                       
                fi
            fi

            if [ ! -z "$pager" ]; then
                git config $global core.pager "$pager" ;
            fi
        fi
        unset gitpager pager pager1

        reade -Q "GREEN" -i "y" -p "Configure git difftool? [Y/n]: " "y n" gitdiff ;
        if [ "y" == $gitmerge ]; then
            git difftool --tool-help &> $TMPDIR/gitresults
            amnt=$(cat $TMPDIR/gitresults | tail -n+2 | sed '0,/^$/d' | wc -l)
            #amnt=$((++amnt))
            rslt=$(cat $TMPDIR/gitresults | tail -n+2 | head -n-"$amnt" | awk '{print $1}')
            git difftool --tool-help
            reade -Q "CYAN" -p "Difftool: " "$(git difftool --tool-help)" "$rslt" diff ;
            if [ ! -z $diff ]; then
                git config $global diff.tool "$diff" ;
                git config $global diff.guitool "$diff" ;
            fi
        fi

        reade -Q "GREEN" -i "y" -p "Configure git mergetool? [Y/n]: " "y n" gitmerge ;
        if [ "y" == $gitmerge ]; then
            git mergetool --tool-help &> $TMPDIR/gitresults
            amnt=$(cat $TMPDIR/gitresults | tail -n+2 | sed '0,/^$/d' | wc -l)
            #amnt=$((++amnt))
            rslt=$(cat $TMPDIR/gitresults | tail -n+2 | head -n-"$amnt" | awk '{print $1}')
            git mergetool --tool-help
            reade -Q "CYAN" -p "Mergetool: " "$(git mergetool --tool-help)" "$rslt" merge ;
            if [ ! -z $merge ]; then
                git config "$global" merge.tool "$merge";
                git config "$global" merge.guitool "$merge";
            fi
        fi

        reade -Q "GREEN" -i "y" -p "Check git config? [Y/n]: " "y n" gitcnf ;
        if [ "y" == $gitcnf ]; then
            git config $global -e
        fi

        reade -Q "GREEN" -i "y" -p "Check and create global gitignore? (~/.config/git/ignore) [Y/n]: " "y n" gitign
        if [ "y" == "$gitign" ]; then
           ./install_gitignore.sh
        fi

        local gitals
        reade -Q "GREEN" -i "y" -p "Install git.sh? (Git aliases) [Y/n]: " "y n" gitals
        if [ "$gitals" == "y" ]; then
            cp -fv aliases/git.sh ~/.bash_aliases.d/
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
