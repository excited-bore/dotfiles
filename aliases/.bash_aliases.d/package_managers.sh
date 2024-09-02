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
    
    if type apt-add-repository &> /dev/null; then
        # https://askubuntu.com/questions/148932/how-can-i-get-a-list-of-all-repositories-and-ppas-from-the-command-line-into-an 
        # Script to get all the PPAs which are installed on a system
	
        function apt-list-ppa()	{

            for APT in `find /etc/apt/ -name \*.list`; do
                grep -Po "(?<=^deb\s).*?(?=#|$)" $APT | while read ENTRY ; do
                    HOST=`echo $ENTRY | cut -d/ -f3`
                    USER=`echo $ENTRY | cut -d/ -f4`
                    PPA=`echo $ENTRY | cut -d/ -f5`
                    #echo sudo apt-add-repository ppa:$USER/$PPA
                                                                                                                        if [ "ppa.launchpad.net" = "$HOST" ]; then
                        echo sudo apt-add-repository ppa:$USER/$PPA
                    else
                        echo sudo apt-add-repository \'${ENTRY}\'
                    fi
                done
            done
        }
        
        # Stolen from:
        # https://codereview.stackexchange.com/questions/45445/script-for-handling-ppas-on-ubuntu

        function check-ppa(){
            SCRIPT="check-ppa"
            VERSION="1.1"
            DATE="2024-09-02"
            RELEASE="$(lsb_release -si) $(lsb_release -sr)"
            
            helpsection() 
            { 
                echo "Usage : $SCRIPT [OPTION]... [PPA]... 
            -h, --help     shows this help
            -c, --check    check if [PPA] is available for your release

            Version $VERSION - $DATE"
            }

            ppa_verification()
            { 
                local ppa="${1#ppa:}"

                local codename="$(lsb_release -sc)"
                local url="http://ppa.launchpad.net/$ppa/ubuntu/dists/$codename/"

                wget "$url" -q -O /dev/null
                ######################################################################
                # Exit Status
                #
                # Wget may return one of several error codes if it encounters problems.
                # 0 No problems occurred.
                # 1 Generic error code.
                # 2 Parse error--for instance, when parsing command-line options, the `.wgetrc' or `.netrc'...
                # 3 File I/O error.
                # 4 Network failure.
                # 5 SSL verification failure.
                # 6 Username/password authentication failure.
                # 7 Protocol errors.
                # 8 Server issued an error response.
                ######################################################################
                case $? in
                  0) # Success
                    echo "$SCRIPT : '$ppa' is ${GREEN}OK${normal} for $RELEASE"
                    ;;
                  8) # HTTP 404 (Not Found) would result in wget returning 8
                    echo "$SCRIPT : '$ppa' is ${RED}UNAVAILABLE${normal} for $RELEASE"
                    return 1
                    ;;
                  *)
                    echo "$SCRIPT : Error fetching $url" >&2
                    return 3
                esac
            }

            PPA=
            while [ -n "$*" ] ; do
                case "$1" in
                  -h|--help)
                    helpsection
                    return 0
                    ;;
                  --check=*)
                    PPA="${1#*=}"
                    ;;
                  -c|--check|check)
                    PPA="$2"
                    shift
                    ;;
                  *)
                    helpsection >&2
                    return 2
                    ;;
                esac
                shift
            done

            if [ -z "$PPA" ]; then
                helpsection >&2
                return 2
            fi

            ppa_verification "$PPA"
        }

        complete -W "-h --help -c --check" check-ppa
         
     fi

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
    alias pacman-list-groups="pacman -Sg" 
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
                nstall="--query $@"
            fi
            nstall="$(pacman -Ss | paste -d "\t"  - - | fzf $nstall --ansi --multi --select-1 --reverse --sync --delimiter '\t' --with-nth 1 --height 33% --preview='echo {2}' --preview-window='down,10%,follow' | awk '{print $1}')" 
            if ! test -z "$nstall"; then
                sudo pacman -S "$nstall" 
            fi
            unset nstall
        }
        
        function pacman-fzf-install-by-group(){ 
            nstall="" 
            if ! test -z "$@"; then
                nstall="--query $@"
            fi
            group="$(pacman -S --groups $nstall | sort -u | fzf --select-1 --reverse --sync --height 33%)" 
            nstall="$(pacman -Ss $group | paste -d "\t"  - - | fzf $nstall --select-1 --multi --reverse --ansi --sync --delimiter '\t' --with-nth 1 --height 33% --preview='echo {2}' --preview-window='down,10%,follow' | awk '{print $1}')" 
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
    alias pamac-clear-cache="pamac clean"
    alias pamac-remove-orphans="pamac remove -o" 
    
    function pamac-fzf-remove-package(){
        if test -z "$@"; then
            compedit="$(pamac list | awk '{print $1}')" 
             if ! type fzf &> /dev/null; then  
                frst="$(echo $compedit | awk '{print $1}')"
                compedit="$(echo $compedit | sed "s/\<$frst\> //g")"
                reade -Q 'GREEN' -i "$frst" -p "Give up package: " "$compedit" packg
             else
                 packg="$(echo "$compedit" | fzf --reverse --multi --height 50%)"
             fi
        else
            packg="$@"     
        fi
        if ! test -z $packg; then
            pamac remove $packg
        fi
        unset packg
    }
    alias pamac-checkupdates="pamac checkupdates -a"
    alias manjaro-update-packages="pamac-update"
    alias manjaro-upgrade="pamac upgrade"
    
    #function pamac-fzf-install(){ 
    #    pre='' 
    #    if ! test -z "$@"; then
    #        if ! test -z "$2"; then
    #            printf "Only give 1 argument\n"
    #            exit 1
    #        else
    #            pre="--query $@"
    #        fi
    #    fi 
    #    nstall="$(pamac list | fzf $pre --ansi --multi --select-1 --reverse --sync --height 33%  | awk '{print $1}')" 
    #    if ! test -z "$nstall"; then
    #        pamac install "$nstall" 
    #    fi
    #    unset nstall
    #}
    
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

### YAY ###


if type yay &> /dev/null; then
    alias yay-update="yay -Su"
    alias yay-update-yes="yes | yay -Su"
    alias yay-list-installed="yay -Q" 
    alias yay-list-groups="yay -Ssq" 
    alias yay-list-all-aur="yay -Slaq"
    alias yay-clear-cache="yay -Sc"

    
    #function yay-fzf-install(){ 
    #    pre='' 
    #    if ! test -z "$@"; then
    #        if ! test -z "$2"; then
    #            printf "Only give 1 argument\n"
    #            exit 1
    #        else
    #            pre="--query $@"
    #        fi
    #    fi 
    #    nstall="$(yay list | fzf $pre --ansi --multi --select-1 --reverse --sync --height 33%  | awk '{print $1}')" 
    #    if ! test -z "$nstall"; then
    #        yay install "$nstall" 
    #    fi
    #    unset nstall
    #}
    
    function yay-fzf-list-files(){ 
        pre='' 
        if ! test -z "$@"; then
            if ! test -z "$2"; then
                printf "Only give 1 argument\n"
                exit 1
            else
                pre="--query $@"
            fi
        fi 
        nstall="$(yay list | fzf $pre --ansi --multi --select-1 --reverse --sync --height 33%  | awk '{print $1}')" 
        if ! test -z "$nstall"; then
            yay list --files $nstall  
        fi
        unset nstall
    }
    
    #function yay-fzf-list-files-installed(){ 
    #    pre='' 
    #    if ! test -z "$@"; then
    #        if ! test -z "$2"; then
    #            printf "Only give 1 argument\n"
    #            exit 1
    #        else
    #            pre="--query $@"
    #        fi
    #    fi 
    #    nstall="$(yay list -i | fzf $pre --ansi --multi --select-1 --reverse --sync --height 33%  | awk '{print $1}')" 
    #    if ! test -z "$nstall"; then
    #        yay list --files $nstall  
    #    fi
    #    unset nstall
    #}
    # 

    #function yay-fzf-install-by-group(){ 
    #    if ! test -z "$@"; then
    #        group="$@"
    #    else 
    #        group="$(yay list --groups | sort -u | fzf --select-1 --reverse --sync --height 33%)" 
    #    fi
    #    nstall="$(yay list --groups $group | fzf --ansi --multi --select-1 --reverse --sync --height 33%  | awk '{print $1}')" 
    #    if ! test -z "$nstall"; then
    #        yay install "$nstall" 
    #    fi
    #    unset group nstall
    #}

    #function yay-fzf-remove(){ 
    #    pre=""
    #    if ! test -z "$@"; then
    #        if ! test -z "$2"; then
    #            printf "Only give 1 argument\n"
    #            exit 1
    #        else
    #            pre="--query $@"
    #        fi
    #    fi 
    #    nstall="$(yay list -i | fzf $pre --ansi --multi --select-1 --reverse --sync --height 33%  | awk '{print $1}')"      
    #    if ! test -z "$nstall"; then
    #        yay remove "$nstall" 
    #    fi 
    #    unset nstall
    #}
     
fi


### NPM ###

if type npm &> /dev/null; then
    alias npm-update="npm update"
fi

### PIP ###

if type pip &> /dev/null; then
    alias pip-upgrade="python3 -m pip install --upgrade pip"
fi
