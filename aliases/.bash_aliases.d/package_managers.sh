### PACKAGE MANAGERS ###

if ! type reade &> /dev/null && test -f ~/.bash_aliases.d/00-rlwrap_scripts.sh; then
    . ~/.bash_aliases.d/00-rlwrap_scripts.sh
fi

## FZF completions??
## https://github.com/junegunn/fzf?tab=readme-ov-file#fuzzy-completion-for-bash-and-zsh

### APT ###

if type apt &> /dev/null; then
    alias apt-update="sudo apt update" 
    alias apt-upgrade="sudo apt upgrade" 
    alias apt-install="sudo apt install" 
    alias apt-search="sudo apt search" 
    alias apt-list-installed="sudo apt list --installed" 
    alias apt-full-upgrade="sudo apt update && sudo apt full-upgrade && sudo apt autoremove"

    if type fzf &> /dev/null; then
        function apt-fzf-install(){ 
            nstall='' 
            if ! test -z "$@"; then
                nstall="$@"
            fi
            nstall="$(apt list --verbose $nstall 2> /dev/null | awk 'NF > 0' | sed '/Listing.../d' | paste -d "\t"  - - | fzf --ansi --select-1 --multi --reverse --sync --delimiter '\t' --with-nth 1 --height 33% --preview='echo {2}' --preview-window='down,10%,follow' | awk '{print $1}' | sed 's/,.*//')" 
            if ! test -z "$nstall"; then
                sudo apt install $nstall 
            fi
            unset nstall
        }

        function apt-fzf-remove(){
            pre=""
            if ! test -z "$@"; then
                pre="$@"
            fi
            nstall="$(apt list --installed --verbose $pre 2>/dev/null | awk 'NF > 0' | sed '/Listing.../d' | paste -d "\t"  - - | fzf --ansi --select-1 --reverse --sync --delimiter '\t' --with-nth 1 --height 33% --preview='echo {2}' --preview-window='down,10%,follow' | awk '{print $1}' | sed 's/,.*//')" 
            if ! test -z "$nstall"; then
                sudo apt remove $nstall 
            fi 
            unset nstall
        }
    fi
fi

### PACMAN ###

if type pacman &> /dev/null; then
    alias pacman-update="sudo pacman -Su"
    alias pacman-install="sudo pacman -S"
    alias pacman-search="pacman -Ss"
    alias pacman-list-installed="pacman -Q"
    alias pacman-list-installed-grouped="pacman -Q --groups" 
    alias pacman-list-installed-native="pacman -Qn" 
    alias pacman-refresh-update="sudo pacman -Syu"
    alias pacman-forcerefresh-update="sudo pacman -Syyu"
    # pacman-mirrors -f:
    #      -f, --fasttrack [NUMBER]
    #          Generates a random mirrorlist for the users current selected branch, mirrors are randomly selected from the users current mirror pool, either a custom pool or the default pool, the randomly selected
    #          mirrors are ranked by their current access time.  The higher number the higher possibility of a fast mirror.  If a number is given the resulting mirrorlist contains that number of servers.
    alias pacman-create-default-mirrors-and-forcerefresh="sudo pacman-mirrors -f 5 && sudo pacman -Syy"
    alias pacman-create-default-mirrors-and-refresh="sudo pacman-mirrors -f 5 && sudo pacman -Sy"
    alias pacman-list-AUR-installed="pacman -Qm"
    alias pacman-rm-lock="sudo rm /var/lib/pacman/db.lck"
    
    if type fzf &> /dev/null; then

        function pacman-fzf-install(){ 
            if ! test -z "$@"; then
                nstall="$@"
            fi
            nstall="$(pacman -Ss $nstall | paste -d "\t"  - - | fzf --ansi --multi --select-1 --reverse --sync --delimiter '\t' --with-nth 1 --height 33% --preview='echo {2}' --preview-window='down,10%,follow' | awk '{print $1}')" 
            if ! test -z "$nstall"; then
                sudo pacman -S "$nstall" 
            fi
            unset nstall
        }
        
        function pacman-fzf-install-by-group(){ 
            nstall="" 
            if ! test -z "$@"; then
                nstall="$@"
            fi
            group="$(pacman -S --groups $nstall | sort -u | fzf --select-1 --reverse --sync --height 33%)" 
            nstall="$(pacman -Ss $group | paste -d "\t"  - - | fzf --select-1 --multi --reverse --ansi --sync --delimiter '\t' --with-nth 1 --height 33% --preview='echo {2}' --preview-window='down,10%,follow' | awk '{print $1}')" 
            if ! test -z "$nstall"; then
                sudo pacman -S "$nstall" 
            fi
            unset group nstall
        }

        function pacman-fzf-remove(){ 
            pre=""
            if ! test -z "$@"; then
                pre="$@"
            fi 
            nstall="$(pacman -Q $pre | paste -d "\t"  - - | fzf --select-1 --multi --reverse --ansi --sync --delimiter '\t' --with-nth 1 --height 33% --preview='echo {2}' --preview-window='down,10%,follow' | awk '{print $1}')"      
            if ! test -z "$nstall"; then
                sudo pacman -R "$nstall" 
            fi 
            unset nstall
        }
         
    fi
fi

### PAMAC ###

# For manjaro: consider pacui
# https://forum.manjaro.org/t/pacui-bash-script-providing-advanced-pacman-and-yay-pikaur-aurman-pakku-trizen-pacaur-pamac-cli-functionality-in-a-simple-ui/561
#(don't run pamac with sudo)

if type pamac &> /dev/null; then
    alias pamac-update="pamac update"
    alias pamac-update-yes="yes | pamac update"
    alias pamac-upgrade="pamac upgrade"
    alias pamac-upgrade-yes="yes | pamac upgrade"
    alias pamac-list-installed="pamac list --installed" 
    alias pamac-list-groups="pamac list --groups" 
    alias pamac-search-aur="pamac search --aur"
    alias pamac-forcerefresh="pamac update --force-refresh && pamac upgrade --force-refresh"
    alias pamac-clean="pamac clean"
    alias pamac-checkupdates="pamac checkupdates -a"
    alias manjaro-update-packages="pamac-update"
    alias manjaro-upgrade="pamac upgrade"
    
    function pamac-fzf-install(){ 
        pre='' 
        if ! test -z "$@"; then
            if ! test -z "$2"; then
                printf "Only give 1 argument\n"
                exit 1
            else
                pre="--query $@"
            fi
        fi 
        nstall="$(pamac list | fzf $pre --ansi --multi --select-1 --reverse --sync --height 33%  | awk '{print $1}')" 
        if ! test -z "$nstall"; then
            pamac install "$nstall" 
        fi
        unset nstall
    }
    
    function pamac-fzf-list-files(){ 
        pre='' 
        if ! test -z "$@"; then
            if ! test -z "$2"; then
                printf "Only give 1 argument\n"
                exit 1
            else
                pre="--query $@"
            fi
        fi 
        nstall="$(pamac list | fzf $pre --ansi --multi --select-1 --reverse --sync --height 33%  | awk '{print $1}')" 
        if ! test -z "$nstall"; then
            pamac list --files $nstall  
        fi
        unset nstall
    }
    
    function pamac-fzf-list-files-installed(){ 
        pre='' 
        if ! test -z "$@"; then
            if ! test -z "$2"; then
                printf "Only give 1 argument\n"
                exit 1
            else
                pre="--query $@"
            fi
        fi 
        nstall="$(pamac list -i | fzf $pre --ansi --multi --select-1 --reverse --sync --height 33%  | awk '{print $1}')" 
        if ! test -z "$nstall"; then
            pamac list --files $nstall  
        fi
        unset nstall
    }
     

    function pamac-fzf-install-by-group(){ 
        if ! test -z "$@"; then
            group="$@"
        else 
            group="$(pamac list --groups | sort -u | fzf --select-1 --reverse --sync --height 33%)" 
        fi
        nstall="$(pamac list --groups $group | fzf --ansi --multi --select-1 --reverse --sync --height 33%  | awk '{print $1}')" 
        if ! test -z "$nstall"; then
            pamac install "$nstall" 
        fi
        unset group nstall
    }

    function pamac-fzf-remove(){ 
        pre=""
        if ! test -z "$@"; then
            if ! test -z "$2"; then
                printf "Only give 1 argument\n"
                exit 1
            else
                pre="--query $@"
            fi
        fi 
        nstall="$(pamac list -i | fzf $pre --ansi --multi --select-1 --reverse --sync --height 33%  | awk '{print $1}')"      
        if ! test -z "$nstall"; then
            pamac remove "$nstall" 
        fi 
        unset nstall
    }
     
fi

### NPM ###

if type npm &> /dev/null; then
    alias npm-update="npm update"
fi

### PIP ###

if type pip &> /dev/null; then
    alias pip-upgrade="python3 -m pip install --upgrade pip"
fi
