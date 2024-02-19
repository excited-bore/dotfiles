echo "$(tput setaf 6)This script uses $(tput setaf 2)rlwrap$(tput setaf 6) and $(tput setaf 2)fzf$(tput setaf 6).";

if ! test -f checks/check_distro.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_distro)" 
else
    . ./checks/check_distro.sh
fi

if ! test -f aliases/rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/rlwrap_scripts.sh)" 
else
    . ./aliases/rlwrap_scripts.sh
fi

if ! type fzf > /dev/null ; then
   if ! test -f ./install_fzf.sh; then
     /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/install_fzf.sh)" 
    else
        ./install_fzf.sh
    fi 
fi

git_pager(){
local gitpgr cpager pager pagers global regpager colors 
cpager="$1"
if ! test -z "$2"; then
    global="$2"
else
    global="--global"
fi

reade -Q "CYAN" -i "y" -p "Set pager instead of output only? [Y/n]: " "y n" regpager ;
if test "$regpager" == "y"; then
        
    pagers="less more"
    pager="less"
    
    if type most &> /dev/null ; then
        pagers=$pagers" most"
    fi
    if type moar &> /dev/null ; then
        pagers=$pagers" moar"
    fi
    if type bat &> /dev/null ; then
        pagers=$pagers" bat"
        pager="bat"
    fi
    if type vim &> /dev/null; then
        pagers=$pagers" vim"
        pager="vim"
    fi
    if type nvim &> /dev/null; then
        pagers=$pagers" nvim"
        pager="nvim"
    fi
    if type delta &> /dev/null; then
        pagers=$pagers" delta"
        pager="delta"
    fi
    if type diff-so-fancy &> /dev/null; then
        pagers=$pagers" diff-so-fancy"
        pager="diff-so-fancy"
    fi
    if type ydiff &> /dev/null; then
        pagers=$pagers" ydiff"
        pager="ydiff"
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
        if test "$pager" == "vim"; then
           colors=$colors" retrobox sorbet wildcharm zaibatsu" 
        fi
        pager="$pager --cmd 'set isprint=1-255'"
        reade -Q "CYAN" -i "y" -p "Set colorscheme? [Y/n]: " "y n" pager1
        if [ "$pager1" == "y" ]; then
            reade -Q "CYAN" -i "default" -p "Colorscheme: " "$colors" color
            pager="$pager +'colorscheme $color'"
        fi
        if [ "$pager" == "delta" ] && [ "$cpager" == "core.pager" ]; then
            reade -Q "CYAN" -i "y" -p "You selected $pager. Configure [Y/n]?: " "y n" delta
            if [ "$delta" == "y" ]; then
                reade -Q "CYAN" -i "y" -p "Set to navigate? (Move between diff sections) [Y/n]" "y n" delta1
                if test "y" == $delta1; then
                    git config $global delta.navigate true
                fi

                reade -Q "CYAN" -i "y" -p "Set to navigate? (Move between diff sections using n and N) [Y/n]" "y n" delta1
                if test "y" == $delta1; then
                    git config $global delta.navigate true
                fi 

                reade -Q "CYAN" -i "y" -p "Set to dark? [Y/n]" "y n" delta2
                if test "y" == $delta2; then
                    git config $global delta.dark true
                fi

                reade -Q "CYAN" -i "y" -p "Set linenumbers? [Y/n]" "y n" delta3
                if test "y" == $delta3; then
                    git config $global delta.linenumbers true
                fi
            fi
        elif [ "$pager" == "diff-so-fancy" ]; then
            local difffancy
            reade -Q "CYAN" -i "y" -p "You selected $pager. Configure [Y/n]?: " "y n" difffancy
            if test "y" == $difffancy; then
                reade -Q "CYAN" -i "y" -p "Dif-so-fancy can be piped to a pager. Pipe to \$PAGER - $PAGER? [Y/n]" "y n" diffancy
                if test "y" == $diffancy; then
                    if test $PAGER == "less"; then
                        git config $global core.pager "diff-so-fancy | less --tabs=4 -RF"
                    else
                        git config $global core.pager "diff-so-fancy | less --tabs=4 -RF"
                    fi
                fi
            fi
        fi
        
    fi
    git config "$global" "$cpager" "$pager" ;
elif test "$regpager" == "n"; then
    if test "$cpager" == "core.pager"; then
        pagers="cat"
        pager="cat"
        if type bat &> /dev/null; then
            pagers=$pagers" bat"
        fi
        reade -Q "CYAN" -i "cat" -p "Pager: " "$pagers" pager;
        if [ $pager == "bat" ]; then
            pager="bat --paging=never"
        fi                                                            
        echo bluh
        git config $global core.pager $pager 
    else
        git config "$global" "$cpager" "$pager" 
    fi
fi
}

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
        if ! test -f install_lazygit.sh; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_lazygit.sh)" 
        else
           ./install_lazygit.sh
        fi 
    fi
    
    if ! [ -f ~/.bash_aliases.d/fzf-git.sh ]; then
        reade -Q "GREEN" -i "y" -p "Install fzf-git? (Extra fzf stuff on leader-key C-g): [Y/n]: " "y n" gitfzf
        if [ "$fzfgit" == "y" ]; then
            if ! test -f checks/check_aliases_dir.sh; then
                eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_aliases_dir.sh)" 
            else
               . ./checks/check_aliases_dir.sh
            fi
            wget https://raw.githubusercontent.com/junegunn/fzf-git.sh/main/fzf-git.sh -P ~/.bash_aliases.d/
        fi
    fi

    local global=""
    reade -Q "CYAN" -i "y" -p "Set to configure git globally? [Y/n]: " "y n" gitglobal
    if [ "y" == "$gitglobal" ]; then
        global="--global"
    fi
    unset gitglobal
    
    if test "$(git config $global --list | grep 'user.name' | awk 'BEGIN { FS = "=" } ;{print $2;}')" == '' ; then
        reade -Q "CYAN" -i "y" -p "Configure git name? [Y/n]: " "y n" gitname
        if [ "y" == $gitname ]; then
            reade -Q "CYAN" -p "Name: " name
            if [ ! -z $name ]; then
                git config "$global" user.name "$name"
            fi
        fi
    fi
    unset name gitname

    local gitmail mail
    if test "$(git config $global --list | grep 'user.email' | awk 'BEGIN { FS = "=" } ;{print $2;}')" == '' ; then
        reade -Q "CYAN" -i "y" -p "Configure git email? [Y/n]: " "y n" gitmail ;
        if [ "y" == $gitmail ]; then
            reade -Q "CYAN" -p "Email: " mail ;
            if [ ! -z $mail ]; then
                git config "$global" user.email "$mail" ;
            fi
        fi
    fi

    local editor editors difftool mergetool cstyle prompt
    editors="nano vi"
    if type vim &> /dev/null; then
        editors=$editors" vim"
    fi
    if type gvim &> /dev/null ; then
        editors=$editors" gvim"
    fi
    if type nvim &> /dev/null ; then
        editors=$editors" nvim"
    fi 
    if type emacs &> /dev/null ; then
        editors=$editors" emacs"
    fi
    if type code &> /dev/null ; then
        editors=$editors" vscode"
    fi

    #if test "$(git config $global --list | grep 'core.editor' | awk 'BEGIN { FS = "=" } ;{print $2;}')" == '' ; then
        reade -Q "CYAN" -i "y" -p "Set default editor?: " "y n" editor ;
        if test "y" == "$editor"; then
            unset editor
            reade -Q "CYAN" -i "nano" -p "Editor: " "$editors" editor;
            if ! test -z "$editor"; then
                if test "$editor" == "vscode"; then
                    editor="code"
                fi
                git config "$global" core.editor "$editor"
            fi
        fi
    #fi

    #if test "$(git config $global --list | grep 'diff.tool' | awk 'BEGIN { FS = "=" } ;{print $2;}')" == '' ; then
    reade -Q "CYAN" -i "y" -p "Set difftool and mergetool?: " "y n" difftool;
    if test $difftool == "y"; then
        reade -Q "CYAN" -i "nano" -p "Tool (editor): " "$editors" editor;
        if ! test -z "$editor"; then
            local diff merge
            if test "$editor" == "vim"; then 
                git config "$global" diff.tool vimdiff
                git config "$global" merge.tool vimdiff
            elif test "$editor" == "gvim"; then 
                git config "$global" diff.tool gvimdiff
                git config "$global" merge.tool gvimdiff
            elif test "$editor" == "nvim"; then 
                git config "$global" diff.tool nvimdiff
                git config "$global" merge.tool nvimdiff
            elif test "$editor" == "emacs"; then 
                git config "$global" diff.tool emerge
                git config "$global" merge.tool emerge
            elif test "$editor" == "vscode"; then 
                git config "$global" difftool.vscode.cmd 'code --wait --diff $LOCAL $REMOTE'
                git config "$global" diff.tool vscode
                git config "$global" mergetool.vscode.cmd 'code --wait $MERGED'
                git config "$global" merge.tool vscode
            fi
        fi
    #fi

    #if test "$(git config $global --list | grep 'diff.tool' | awk 'BEGIN { FS = "=" } ;{print $2;}')" == '' ; then
        reade -Q "CYAN" -i "y" -p "Set diff guitool and merge guitool?: " "y n" difftool;
        if test $difftool == "y"; then
            reade -Q "CYAN" -i "nano" -p "Tool (editor): " "$editors" editor;
            if ! test -z "$editor"; then
                local diff merge
                if test "$editor" == "vim"; then
                    git config "$global" diff.guitool vimdiff
                    git config "$global" merge.guitool vimdiff
                elif test "$editor" == "gvim"; then 
                    git config "$global" diff.guitool gvimdiff
                    git config "$global" merge.guitool gvimdiff
                elif test "$editor" == "nvim"; then 
                    git config "$global" diff.guitool nvimdiff
                    git config "$global" merge.guitool nvimdiff
                elif test "$editor" == "emacs"; then 
                    git config "$global" diff.guitool emerge
                    git config "$global" merge.guitool emerge
                elif test "$editor" == "vscode"; then 
                    git config "$global" difftool.vscode.cmd 'code --wait --diff $LOCAL $REMOTE'
                    git config "$global" diff.guitool vscode
                    git config "$global" mergetool.vscode.cmd 'code --wait $MERGED'
                    git config "$global" merge.guitool vscode
                fi
            fi
        fi
    #fi
    reade -Q "CYAN" -i "diff3" -p "Set merge conflictsstyle: " "diff diff1 diff2 diff3" cstyle;
    if ! test -z "$cstyle"; then
        git config "$global" merge.conflictsstyle "$cstyle" 
    fi
    reade -Q "CYAN" -i "false" -p "Mergetool prompt?: " "true false" prompt;
    if ! test -z "$cstyle"; then
        git config mergetool.prompt "$prompt"
    fi
     
    local gitpgr pager

    reade -Q "CYAN" -i "y" -p "Install custom diff syntax highlighter / pager? [Y/n]: " "y n" gitpgr ;
    if test $gitpgr == "y"; then
        reade -Q "GREEN" -i "moar" -p "Which to install? [Moar/most/delta/diff-so-fancy/ydiff/difftastic]: " "moar most delta diff-so-fancy ydiff difftastic" pager 
        if test $pager == "bat"; then
            if ! test -f install_bat.sh; then
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_bat.sh)"
            else
               ./install_bat.sh
            fi
            
        elif test $pager == "moar"; then
            if ! test -f install_moar.sh; then
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_moar.sh)"
            else
               ./install_moar.sh
            fi
        elif test $pager == "most"; then
            if ! test -f install_most.sh; then
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_most.sh)"
            else
               ./install_most.sh
            fi
        fi
        if test $distro_base == "Arch"; then
            if test $pager == "diff-so-fancy"; then
                sudo pacman -Su diff-so-fancy
            elif test $pager == "delta"; then
                sudo pacman -Su git-delta
            elif test $pager == "ydiff"; then
                sudo pacman -Su pipx
                pipx install --upgrade ydiff
            elif test $pager == "difftastic"; then
                sudo pacman -Su difftastic
            fi
        elif test $pager == "Debian"; then
            reade -Q "GREEN" -i "delta" -p "Which diffpager to install? [Delta/diff-so-fancy/ydiff/difftastic]: " "diff-so-fancy delta ydiff difftastic" difftool;
            if test $pager == "diff-so-fancy"; then
                sudo apt install npm
                sudo npm -g install diff-so-fancy 
            elif test $pager == "delta"; then
                sudo apt install Debdelta
            elif test $pager == "ydiff"; then
                sudo apt install pipx
                pipx install --upgrade ydiff
            elif test $pager == "difftastic"; then
                if [[ $arch =~ "arm" ]]; then
                    sudo apt install cargo
                    cargo install --locked difftastic
                else
                    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                    brew install difftastic
                fi
            fi
        fi
    fi
    unset gitdiff gitdiff1 difftool pager           
    
    
    local wpager
    reade -Q "CYAN" -i "y" -p "Set default pager and wich git commands would use a pager? [Y/n]: " "y n" wpager ;
    if test "$wpager" == "y"; then
        git_pager "core.pager" "$global"
        confs="$(cur="pager." && compgen -F _git_config 2> /dev/null)"
        reade -Q "CYAN" -i "y" -p "Configure custom diff? [Y/n]: " "y n" gitdiff1 ;
        if [ "y" == $gitdiff1 ]; then
            diffs="diff"
            if type delta &> /dev/null ; then
                diffs=$diffs" delta"
            fi
            if type diff-so-fancy &> /dev/null ; then
                diffs=$diffs" diff-so-fancy"
            fi
            if type ydiff &> /dev/null ; then
                diffs=$diffs" ydiff"
            fi
            if type difft &> /dev/null ; then
                diffs=$diffs" difftastic"
            fi
        fi 
    fi

       # reade -Q "GREEN" -i "y" -p "Configure git difftool? [Y/n]: " "y n" gitdiff ;
       # if [ "y" == "$gitdiff" ]; then
       #     git difftool --tool-help &> $TMPDIR/gitresults
       #     amnt=$(cat $TMPDIR/gitresults | tail -n+2 | sed '0,/^$/d' | wc -l)
       #     #amnt=$((++amnt))
       #     rslt=$(cat $TMPDIR/gitresults | tail -n+2 | head -n-"$amnt" | awk '{print $1}')
       #     git difftool --tool-help
       #     reade -Q "CYAN" -p "Difftool: " "$(git difftool --tool-help)" "$rslt" diff ;
       #     if [ ! -z $diff ]; then
       #         git config $global diff.tool "$diff" ;
       #         git config $global diff.guitool "$diff" ;
       #     fi
       # fi

       # reade -Q "GREEN" -i "y" -p "Configure git mergetool? [Y/n]: " "y n" gitmerge ;
       # if [ "y" == $gitmerge ]; then
       #     git mergetool --tool-help &> $TMPDIR/gitresults
       #     amnt=$(cat $TMPDIR/gitresults | tail -n+2 | sed '0,/^$/d' | wc -l)
       #     #amnt=$((++amnt))
       #     rslt=$(cat $TMPDIR/gitresults | tail -n+2 | head -n-"$amnt" | awk '{print $1}')
       #     git mergetool --tool-help
       #     reade -Q "CYAN" -p "Mergetool: " "$(git mergetool --tool-help)" "$rslt" merge ;
       #     if [ ! -z $merge ]; then
       #         git config "$global" merge.tool "$merge";
       #         git config "$global" merge.guitool "$merge";
       #     fi
       # fi
        
        reade -Q "GREEN" -i "y" -p "Check git config? [Y/n]: " "y n" gitcnf ;
        if [ "y" == "$gitcnf" ]; then
            git config $global -e
        fi

        reade -Q "GREEN" -i "y" -p "Check and create global gitignore? (~/.config/git/ignore) [Y/n]: " "y n" gitign
        if [ "y" == "$gitign" ]; then
            if ! test -f install_gitignore.sh; then
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_gitignore.sh)"
            else
               ./install_gitignore.sh
            fi 
        fi

        local gitals
        reade -Q "GREEN" -i "y" -p "Install git.sh? (Git aliases) [Y/n]: " "y n" gitals
        if [ "$gitals" == "y" ]; then
            if ! test -f checks/check_aliases_dir.sh; then
                eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_aliases_dir.sh)" 
            else
               . ./checks/check_aliases_dir.sh
            fi
            if ! test -f aliases/git.sh; then
                wget https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/git.sh -P ~/.bash_aliases.d/ 
            else
                cp -fv aliases/git.sh ~/.bash_aliases.d/
            fi
        fi

        unset gitdiff diff gitmerge merge amt rslt gitcnf gitign
        if [ ! -x "$(command -v copy-to)" ]; then
            reade -Q "GREEN" -i "y" -p "Install copy-to? [Y/n]: " "y n" cpcnf;
            if [ "y" == $cpcnf ] || [ -z $cpcnf ]; then
                if ! test -f install_copy-conf.sh; then
                    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_copy-conf.sh)"
                else
                    ./install_copy-conf.sh
                fi
            fi
        fi
    fi
    }
gitt
