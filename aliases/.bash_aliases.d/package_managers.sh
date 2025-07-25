### PACKAGE MANAGERS ###

if ! type reade &> /dev/null && test -f ~/.bash_aliases.d/00-rlwrap_scripts.sh; then
    . ~/.bash_aliases.d/00-rlwrap_scripts.sh
fi

## FZF completions??
## https://github.com/junegunn/fzf?tab=readme-ov-file#fuzzy-completion-for-bash-and-zsh

### APT ###

if hash apt &> /dev/null; then
    alias apt-update="sudo apt update" 
    alias apt-upgrade="sudo apt upgrade" 
    alias apt-install="sudo apt install" 
    alias apt-search="sudo apt search" 
    alias apt-list-installed="sudo apt list --installed" 
    alias apt-full-upgrade="sudo apt update && sudo apt full-upgrade && sudo apt autoremove"
    
    if hash apt-add-repository &> /dev/null; then
        # https://askubuntu.com/questions/148932/how-can-i-get-a-list-of-all-repositories-and-ppas-from-the-command-line-into-an 
        # Script to get all the PPAs which are installed on a system
	
        function apt-list-ppa-installed()	{
            if test -d /etc/apt/sources.list.d/ ;then
                first=/etc/apt/sources.list.d/
                second=\*.sources
            else
                first=/etc/apt/
                second=\*.list
            fi
            for APT in `find $first -name $second`; do
                ppa=$(grep "URIs" $APT | grep --color=never 'ppa' | awk '{print $2;}' | sed 's|https://ppa.launchpadcontent\.net/|ppa:|g' | sed 's|/ubuntu/||g')
                if test -n "$ppa"; then 
                    printf "$ppa\n" 
                fi
            done
        }
        
        _ppa_purge(){
            #WORD_ORIG=$COMP_WORDBREAKS
            #COMP_WORDBREAKS=${COMP_WORDBREAKS/:/}
            _get_comp_words_by_ref -n : cur
            COMPREPLY=($(compgen -W "-p -o -s -d -y -i -h $(apt-list-ppa-installed)" -- "$cur") )
            __ltrim_colon_completions "$cur"
            #COMP_WORDBREAKS=$WORD_ORIG
            return 0
        } 
       
        if hash ppa-purge &> /dev/null; then
            complete -F _ppa_purge ppa-purge 
            alias remove-apt-ppa='ppa-purge'
            alias apt-remove-ppa='ppa-purge'
        fi
        

        # Stolen from:
        # https://codereview.stackexchange.com/questions/45445/script-for-handling-ppas-on-ubuntu

        function check-ppa(){
            SCRIPT="check-ppa"
            VERSION="1.1"
            DATE="2024-09-02"
            RELEASE="$(lsb_release -si) $(lsb_release -sr)"
            
            helpsection() 
            { 
                echo "Usage : $SCRIPT [PPA]... 
            -h, --help     shows this help

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
                    echo "'$ppa' is ${GREEN}OK${normal} for $RELEASE - codename: $codename"
                    return 0
                    ;;
                  8) # HTTP 404 (Not Found) would result in wget returning 8
                    echo "'$ppa' is ${RED}UNAVAILABLE${normal} for $RELEASE - codename: $codename"
                    return 1
                    ;;
                  *)
                    echo "Error fetching $url" >&2
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
                  *)
                    PPA="$@"
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

        complete -W "-h --help" check-ppa
         
     
        if type readyn &>/dev/null && hash curl &>/dev/null && hash xmllint &>/dev/null && hash fzf &>/dev/null; then
            function urlencode() {
                # Usage: urlencode "string"
                local LC_ALL=C
                for (( i = 0; i < ${#1}; i++ )); do
                    : "${1:i:1}"
                    case "$_" in
                        [a-zA-Z0-9.~_-])
                            printf '%s' "$_"
                        ;;

                        *)
                            printf '%%%02X' "'$_"
                        ;;
                    esac
                done
                printf '\n'
            } 

            function apt-search-ppa() {
                local packg ansr instll url="https://launchpad.net/ubuntu/+ppas?batch=300&start=0&name_filter="
                test -n "$1" &&
                    packg="$1" ||
                    reade -Q 'GREEN' -i '""' -p "Name package?: " packg
                ansr=$(curl -sSL "$url$packg" | xmllint --html --format --xpath '//a' - | grep --color=never '/~' | sed 's/.*href=\(.*\)/\1/g' | sed 's,</a>,,g' | sed 's,/~,,g' | sed 's,/+archive/ubuntu,,g' | sed 's,>,\t,g' | fzf --ansi --multi --select-1 --reverse --sync --delimiter '\t' --with-nth 1 --height 33% --preview='echo {2}' --preview-window='down,10%,follow' | awk '{print $1}' | tr -d \")
                if test -n "$ansr"; then
                    if check-ppa ppa:$ansr; then
                        readyn -p "Add to $ansr to /etc/apt/sources.list.d/?" instll
                        if [[ $instll == 'y' ]]; then
                            sudo add-apt-repository ppa:$ansr
                        fi
                    else
                        ansr=$(echo $ansr | sed 's,/,/+archive/ubuntu/,') 
                        printf "Check for yourself at: https://launchpad.net/~$ansr\n"
                    fi
                fi
            }
            alias add-apt-search-ppa="apt-search-ppa"
        fi
    fi
    

     if hash fzf &> /dev/null; then

        function apt-fzf-install(){ 
            nstall='' 
            if test -n "$@"; then
                nstall="$@"
            fi
            nstall="$(apt list --verbose $nstall 2> /dev/null | awk 'NF > 0' | sed '/Listing.../d' | paste -d "\t"  - - | fzf --ansi --select-1 --multi --reverse --sync --delimiter '\t' --with-nth 1 --height 33% --preview='echo {2}' --preview-window='down,10%,follow' | awk '{print $1}' | sed 's/,.*//')" 
            if test -n "$nstall"; then
                sudo apt install $nstall 
            fi
            unset nstall
        }

        function apt-fzf-remove(){
            pre=""
            if test -n "$@"; then
                pre="$@"
            fi
            nstall="$(apt list --installed --verbose $pre 2>/dev/null | awk 'NF > 0' | sed '/Listing.../d' | paste -d "\t"  - - | fzf --ansi --select-1 --reverse --sync --delimiter '\t' --with-nth 1 --height 33% --preview='echo {2}' --preview-window='down,10%,follow' | awk '{print $1}' | sed 's/,.*//')" 
            if test -n "$nstall"; then
                sudo apt remove $nstall 
            fi 
            unset nstall
        }
    fi
fi

### PACMAN ###

if hash pacman &> /dev/null; then
    alias pacman-update="sudo pacman -Su"
    alias pacman-install="sudo pacman -S"
    alias pacman-search="pacman -Ss"
    alias pacman-list-installed="pacman -Q"
    alias pacman-list-groups="pacman -Sg" 
    alias pacman-list-installed-grouped="pacman -Q --groups" 
    alias pacman-list-installed-native="pacman -Qn" 
    alias pacman-refresh-update="sudo pacman -Syu"
    alias pacman-forcerefresh-update="sudo pacman -Syyu"
    alias pacman-list-files-package="pacman -Ql"
    alias pacman-list-AUR-installed="pacman -Qm"
    alias pacman-rm-lock="sudo rm /var/lib/pacman/db.lck"
    alias pacman-remove="sudo pacman -R"
    alias pacman-remove-dependencies="sudo pacman -Rs"
    alias pacman-clean-cache="sudo pacman -Sc" 
    

    if hash fzf &> /dev/null; then

        function pacman-fzf-install(){ 
            local nstall
            if test -n "$@"; then
                nstall="--query $@"
            fi
            nstall="$(pacman -Ss | paste -d "\t"  - - | fzf $nstall --ansi --multi --select-1 --reverse --sync --delimiter '\t' --with-nth 1 --height 33% --preview='echo {2}' --preview-window='down,10%,follow' | awk '{print $1}')" 
            if test -n "$nstall"; then
                sudo pacman -S "$nstall" 
            fi
        }
        
        function pacman-fzf-install-by-group(){ 
            local nstall="" 
            if test -n "$@"; then
                nstall="--query $@"
            fi
            local group="$(pacman -S --groups $nstall | sort -u | fzf --select-1 --reverse --sync --height 33%)" 
            local nstall="$(pacman -Ss $group | paste -d "\t"  - - | fzf $nstall --select-1 --multi --reverse --ansi --sync --delimiter '\t' --with-nth 1 --height 33% --preview='echo {2}' --preview-window='down,10%,follow' | awk '{print $1}')" 
            if test -n "$nstall"; then
                sudo pacman -S "$nstall" 
            fi
        }

        function pacman-fzf-list-files-installed(){ 
            local pre='' 
            if test -n "$@"; then
                if test -n "$2"; then
                    printf "Only give 1 argument\n"
                    exit 1
                else
                    pre="--query $@"
                fi
            fi 
            
            local nstall="$(pacman -Q | fzf $pre --ansi --multi --select-1 --preview 'cat <(pacman -Qk {1})' --preview-window='down,10%,follow' --reverse --sync --height 33%  | awk '{print $1}')" 
            if test -n "$nstall"; then
                for i in ${nstall[@]}; do
                    echo "${bold}$(pacman -Qk $i)"
                    pacman -Ql $i | awk '{$1="";print}' | sed 's| \(.*\)|\1|g'   
                    echo "" 
                done | $PAGER
            fi
        }
         

        function pacman-fzf-remove(){ 
            
            local pre=""
            if test -n "$@"; then
                pre="$@"
            fi 
            local nstall="$(pacman -Q $pre | paste -d "\t"  - - | fzf --select-1 --multi --reverse --ansi --sync --delimiter '\t' --with-nth 1 --height 33% --preview='echo {2}' --preview-window='down,10%,follow' | awk '{print $1}')"      
            if test -n "$nstall"; then
                sudo pacman -R "$nstall" 
            fi 
        }
        
        function pacman-fzf-add-arch-repositories(){ 
            local only_https mirror add_mirror

            if test -n "$distro" && ! [[ "$distro" == 'Arch' ]]; then
                printf "${yellow}Since the distribution you're using is not ${CYAN}Arch${yellow} but ${CYAN}$distro${yellow}, you will basically ${ORANGE}change distribution by installing Arch specific repositories\n${YELLOW}This means certain $distro related packages won't be available to install/update any longer!\n${normal}"
                readyn -p 'Still proceed?' add_mirror
            else
                add_mirror='y'
            fi
            
            if [[ "$add_mirror" == 'y' ]]; then

                if test -n "$1" && [[ "$1" == 'y' ]] || [[ "$1" == 'n' ]]; then
                    only_https="$1"
                else
                    readyn -p "Only look for mirrors that use https?" only_https
                fi
                
                if [[ "$only_https" == 'y' ]]; then
                    # Https only
                    mirror=https://archlinux.org/mirrorlist/all/https/ 
                else 
                    # All
                    mirror=https://archlinux.org/mirrorlist/all/ 
                fi
               
                # Asked Chatgpt for the awk part of the script
                # grep -v '^[[:space:]]*$' => Print everything but empty lines / lines with spaces
                local mirrors=$(curl -fsSL $mirror | tail -n +6 | awk '/^## / { section = substr($0, 4); next }; /^$/ { section = ""; print; next }; section != "" { print $0 "\t" section; next }; { print }' | sed 's/^#//g' | grep -v '^[[:space:]]*$' | fzf --ansi --multi --select-1 --reverse --sync --delimiter '\t' --with-nth 1 --height 33% --preview='echo {2}' --preview-window='down,10%,follow') 

                # Turn mirrors into array in a bash and zsh compatible
                local mirrors2
                IFS=$'\n' read -r -d '' -A mirrors2 <<< "$(printf "%s\0" "$mirrors")" 
            
                printf "${green}Adding mirrors to ${CYAN}/etc/pacman.d/mirrorlist${normal}\n" 

                for i in ${mirrors2[@]}; do
                    # Remove 'Server', '=' and 'https;//...' before printing, then remove unnecesary spaces
                    local country=$(echo $i | awk '{$1="";$2="";$3=""; print}' | xargs)
                    
                    # Cut everything after tab (using ANSI-C quoting) 
                    local mirror=$(echo $i | cut -d$'\t' -f-1)
                   
                    if ! grep -q $mirror /etc/pacman.d/mirrorlist; then 
                        if ! grep -q $country /etc/pacman.d/mirrorlist; then
                            sudo sed -i "1s/^/\n## Country : $country\n/" /etc/pacman.d/mirrorlist       
                        fi
                     
                        # Set awk variables with -v
                        command cat /etc/pacman.d/mirrorlist | awk -v mirror="$mirror" '/'"$country"'/ { print; print mirror; next }1' | sudo tee /etc/pacman.d/mirrorlist 1> /dev/null 
                    else
                        printf "${ORANGE}'$mirror'${yellow} is already in ${YELLOW}/etc/pacman.d/mirrorlist${normal}\n"
                    fi
                done
                readyn -p "Edit ${CYAN}/etc/pacman.d/mirrorlist${GREEN} to see if everything was configured properly?" check_edit
                if [[ "$check_edit" == 'y' ]]; then
                    if test -n "$SUDO_EDITOR"; then
                        sudo $SUDO_EDITOR /etc/pacman.d/mirrorlist 
                    elif test -z "$SUDO_EDITOR" && test -n "$EDITOR"; then
                        sudo $EDITOR /etc/pacman.d/mirrorlist
                    elif test -z "$EDITOR" && hash nano &> /dev/null; then
                        sudo nano /etc/pacman.d/mirrorlist 
                    elif test -z "$EDITOR" && hash edit &> /dev/null; then
                        sudo edit /etc/pacman.d/mirrorlist
                    fi
                fi
               
                if test -n "$distro" && ! [[ "$distro" == 'Arch' ]]; then
                    printf "${yellow}Since the distribution you're using is not ${CYAN}Arch${yellow} but ${CYAN}$distro${yellow}, you will need to reinstall ${CYAN}pacman${yellow} and other packages\nIt's ${YELLOW}important${yellow} that you update appropriately and ${GREEN}allow downgrades${yellow} when updating in order not to break anything\n${normal}" 
                fi

                readyn -p "Force refresh pacman using ${CYAN}'sudo pacman -Syyuu'${GREEN}?" pack_up
                if [[ "$pack_up" == 'y' ]]; then 
                    sudo pacman -Syyuu
                fi

                if test -n "$distro" && [[ "$distro" == 'Manjaro' ]] && hash pacman-mirrors &> /dev/null; then
                    printf "${green}If you ever change your mind and want to change back to manjaro, use:\n${CYAN}\t- sudo pacman-mirrors ( -c Global / *your country* ) ( --fasttrack (*number of mirrors*)) ${GREEN}- to restore manjaro repositories in /etc/pacman.d/mirrorlist, '(..)' indicates optional arguments, *something* needs to be replaced\n\t${CYAN}- sudo pacman -Syyuu ${GREEN}- to force refresh repositories and update while allowing downgrades\n${ORANGE}Just make sure not to remove the package 'pacman-mirrors'${normal}\n\n" 
                fi
                
            fi
        }
    fi

    #if type perl &> /dev/null && type zcat &> /dev/null && ! test -f $HOME/.cache/AUR/packages-meta-ext-v1.json.extracted.txt; then
    #    # https://stackoverflow.com/questions/50596286/how-to-programmably-get-the-metadata-of-all-packages-available-from-aur-in-archl 
    #    zcat <(curl -sSL https://aur.archlinux.org/packages-meta-ext-v1.json.gz) | jq --compact-output '.[] | {Name, Version, Description, Keywords, PackageBase, URL, Popularity, OutOfDate, Maintainer, FirstSubmitted, LastModified, Depends, MakeDepends, License}' | perl -pe 's/^\{\"|\"?,"(?![^:]+\])/\n/g' | perl -pe 's/\\(?=")|\"(?=:)|:\K\[?\"\[?\"?|\"?\]\}?$//gm' | perl -pe 's/\",\" ?/ /gm' | perl -pe 's/^([^:]+)(:)(.*)$/$1                    $2 $3/gm' | perl -pe 's/^.{16}\K +//gm' | perl -0777 -pe 's/\n+(?=Name)/\n\n\nRepository      : AUR\n/gm' $HOME/.cache/AUR/packages-meta-ext-v1.json.extracted.txt

    #fi

    #if type xdg-open &> /dev/null && type zcat &> /dev/null && type fzf &> /dev/null; then
    #    continue 
        #function AUR-fzf-list-website(){
        #    Q=''
        #    if ! test -z $@; then
        #        Q="-Q $@"
        #    fi
        #    packages="$(cat $HOME/.cache/AUR/packages-meta-ext-v1.json.extracted.txt | grep --color=never -e 'Name.*:' -e 'Description.*:' | awk '{ $1=$2=""; print $0}' | paste -d "\t"  - - | fzf --ansi --select-1 --multi --reverse --sync --delimiter '\t' --with-nth 1 --height 33% --preview='echo {2}' --preview-window='down,10%,follow' | sed 's/^ *//g' | awk '{print $1}')" 
        #    for i in $packages; do 
        #        xdg-open "https://aur.archlinux.org/packages/$i" 
        #    done 
        #    unset packages i  
        #} 
        #complete -W "$(zcat $HOME/.cache/AUR/packages.gz)" AUR-list-website
        #cat packages-meta-ext-v1.json.extracted.txt | awk '{$1=$2=""; print $0}' | 
        
        #function AUR-fzf-packages(){
        #    packages="$(cat $HOME/.cache/AUR/packages-meta-ext-v1.json.extracted.txt | grep --color=never -e 'Name.*:' -e 'Description.*:' | awk '{ $1=$2=""; print $0}' | paste -d "\t"  - - | fzf -i --ansi --select-1 --multi --reverse --sync --delimiter '\t' --with-nth 1 --height 33% --preview='echo {2}' --preview-window='down,10%,follow' | sed 's/^ *//g' | awk '{print $1}')" 
        #    if ! test -z $packages; then
        #       if type pamac &> /dev/null; then
        #           reslt=$(printf "Install\nInstall dependencies\n" | fzf --reverse  --height 33%)
        #           if ! test -z "$reslt"; then
        #               if test "$reslt" == 'Install'; then 
        #                    pamac install $packages
        #                elif test "$reslt" == "Install dependencies"; then 
        #                   for i in $packages; do 
        #                       #depends="$(cat $HOME/.cache/AUR/packages-meta-ext-v1.json.extracted.txt | awk '/'"$i"'/ { found_deps = 1; next; } /License/ && found_deps { found_deps = 0;} found_deps' | awk 'NR==1{$1=$2=""; print $0 }' )" 
        #                       #echo $depends  
        #                       #depends="$(cat $HOME/.cache/AUR/packages-meta-ext-v1.json.extracted.txt | awk '/'"$i"'/ { found_deps = 1; next; } /Depends/ {print $0; next;} /MakeDepends/ {print $0; next;} /License/ && found_deps { found_deps = 0;}' | awk 'NR==1{$1=$2=""; print $0 }' | awk '{$1=$1};1')" 
        #                        depends="$(cat $HOME/.cache/AUR/packages-meta-ext-v1.json.extracted.txt | awk '/'"$i"'/ { found_deps = 1; next; } /License/ { found_deps = 0;} found_deps' | awk '/Depends/ {found_deps=1; next} /License/ {found_deps=0} found_deps' | xargs | sed 's|[[:space:]]:[[:space:]]|:|g')"  
        #                        for j in ${depends[@]}; do 
        #                            if [[ $j =~ '=' ]] || [[ $j =~ '<' ]] || [[ $j =~ '>' ]]; then 
        #                                echo "$j"; 
        #                            fi; 
        #                        done 
        #                    done; 
        #                   #a pamac install $depends 
        #               fi 
        #           fi
        #       else
        #           printf "$packages\n"
        #       fi
        #   fi
        #} 
    #fi
   #sed -n -e 's/^.*stalled: //p' 


    # For manjaro: consider pacui
    # https://forum.manjaro.org/t/pacui-bash-script-providing-advanced-pacman-and-yay-pikaur-aurman-pakku-trizen-pacaur-pamac-cli-functionality-in-a-simple-ui/561
    #(don't run pamac with sudo)

    ### PACMAN-MIRRORS ###
     
    if hash pacman-mirrors &> /dev/null; then
        
        # https://wiki.manjaro.org/index.php?title=Pacman-mirrors 

        alias pacman-mirrors-list-available-countries="pacman-mirrors --country-list" 
        alias pacman-mirrors-list-configured-countries="pacman-mirrors --country-config" 

        alias pacman-mirrors-get-branch="pacman-mirrors --get-branch" 
        
        # pacman-mirrors -f:
        #      -f, --fasttrack [NUMBER]
        #          Generates a random mirrorlist for the users current selected branch, mirrors are randomly selected from the users current mirror pool, either a custom pool or the default pool, the randomly selected
        #          mirrors are ranked by their current access time.  The higher number the higher possibility of a fast mirror.  If a number is given the resulting mirrorlist contains that number of servers. 
        alias pacman-mirrors-gen-list-fastest-mirrors="sudo pacman-mirrors --fasttrack && sudo pacman -Syu"
        
        alias pacman-mirrors-gen-list-country-based-mirrors="sudo pacman-mirrors --geoip && sudo pacman -Syu" 
        alias pacman-mirrors-gen-list-continent-based-mirrors="sudo pacman-mirrors --continent && sudo pacman -Syu"
        alias pacman-mirrors-gen-list-GUI="sudo pacman-mirrors --interactive --default && sudo pacman -Syu"
        
        alias pacman-mirrors-full-reset-to-default="sudo pacman-mirrors --country all --api --protocol all -set-branch stable && sudo pacman -Syu" 
    fi
    
    ### PAMAC ###

    if hash pamac &> /dev/null; then
        alias pamac-update="pamac update"
        alias pamac-update-yes="pamac update --no-confirm"
        alias pamac-upgrade="pamac upgrade"
        alias pamac-upgrade-yes="pamac upgrade --no-confirm"
        alias pamac-list-installed="pamac list --installed" 
        alias pamac-list-installed-AUR="pamac list --foreign" 
        alias pamac-list-groups="pamac list --groups" 
        alias pamac-search-aur="pamac search --aur"
        alias pamac-forcerefresh="pamac update --force-refresh && pamac upgrade --force-refresh"
        alias pamac-clear-cache="pamac clean"
        alias pamac-remove-orphans="pamac remove -o" 
       
        alias pamac-list-files-package="pacman-list-files-package" 

        function pamac-fzf-remove-package(){
            local packg
            if test -z "$@"; then
                 local compedit="$(pamac list | awk '{print $1}')" 
                 if ! hash fzf &> /dev/null; then  
                    local frst="$(echo $compedit | awk '{print $1}')"
                    compedit="$(echo $compedit | sed "s/\<$frst\> //g")"
                    reade -Q 'GREEN' -i "$frst $compedit" -p "Give up package: " packg
                 else
                     packg="$(echo "$compedit" | fzf --reverse --multi --height 50%)"
                 fi
            else
                packg="$@"     
            fi
            if test -n $packg; then
                pamac remove $packg
            fi
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
            local nstall pre='' 
            if test -n "$@"; then
                if test -n "$2"; then
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
        }
        
        function pamac-fzf-list-files-installed(){ 
            local nstall pre='' 
            if test -n "$@"; then
                if test -n "$2"; then
                    printf "Only give 1 argument\n"
                    exit 1
                else
                    pre="--query $@"
                fi
            fi 
            nstall="$(pamac list -i | fzf $pre --ansi --multi --select-1 --reverse --sync --height 33%  | awk '{print $1}')" 
            if test -n "$nstall"; then
                pamac list --files $nstall  
            fi
        }
         

        function pamac-fzf-install-by-group(){ 
            local group nstall 
            if test -n "$@"; then
                group="$@"
            else 
                group="$(pamac list --groups | sort -u | fzf --select-1 --reverse --sync --height 33%)" 
            fi
            nstall="$(pamac list --groups $group | fzf --ansi --multi --select-1 --reverse --sync --height 33%  | awk '{print $1}')" 
            if ! test -z "$nstall"; then
                pamac install "$nstall" 
            fi
        }

        function pamac-fzf-remove(){ 
            local nstall pre=""
            if test -n "$@"; then
                if test -n "$2"; then
                    printf "Only give 1 argument\n"
                    exit 1
                else
                    pre="--query $@"
                fi
            fi 
            nstall="$(pamac list -i | fzf $pre --ansi --multi --select-1 --reverse --sync --height 33%  | awk '{print $1}')"      
            if test -n "$nstall"; then
                pamac remove "$nstall" 
            fi 
        }
         
    fi

    ### YAY ###


    if hash yay &> /dev/null; then
        alias yay-update="yay -Su"
        alias yay-install="yay -Su"
        alias yay-update-yes="yay -Su --noconfirm"
        alias yay-remove="yay -R"
        alias yay-list-installed="yay -Q" 
        #alias yay-list-groups="yay -Ssq" 
        alias yay-list-all-aur="yay -Slaq"
        alias yay-clear-cache="yay -Sc"

        alias yay-list-files-package="pacman-list-files-package" 
        # https://smarttech101.com/aur-arch-user-repository-and-yay-in-arch-linux 
       
        if hash fzf &> /dev/null; then 
            
            if hash bat &> /dev/null; then
                function yay-fzf-install(){ 
                    local pre='' 
                    if test -n "$@"; then
                        if test -n "$2"; then
                            printf "Only give 1 argument\n"
                            exit 1
                        else
                            pre="--query $@"
                        fi
                    fi 
                    yay -Slq | fzf $pre --ansi --reverse --multi --preview-window=80% --preview 'cat <(yay -Si {1} | bat -n --language txt --color=always) <(echo '') <(yay --getpkgbuild --print {1} | bat -n --language bash --color=always)' | xargs --no-run-if-empty --open-tty yay -Su --combinedupgrade 
                }
            fi

            function yay-fzf-remove(){ 
                local pre=""
                if test -n "$@"; then
                    if test -n "$2"; then
                        printf "Only give 1 argument\n"
                        exit 1
                    else
                        pre="--query $@"
                    fi
                fi 
                local nstall="$(yay -Q | fzf $pre --ansi --multi --select-1 --reverse --sync --height 33%  | awk '{print $1}')"      
                if test -n "$nstall"; then
                    yay -R "$nstall" 
                fi 
            }
            
        fi
       
        #function yay-fzf-list-files(){ 
        #    pre='' 
        #    if ! test -z "$@"; then
        #        if ! test -z "$2"; then
        #            printf "Only give 1 argument\n"
        #            exit 1
        #        else
        #            pre="--query $@"
        #        fi
        #    fi 
        #    nstall="$(yay -Q | fzf $pre --ansi --multi --select-1 --preview 'cat <(yay -Si {1} | bat -n --language txt --color=always)' --reverse --sync --height 33%  | awk '{print $1}')" 
        #    if ! test -z "$nstall"; then
        #        yay list --files $nstall  
        #    fi
        #    #unset nstall
        #}
    fi
fi



### NPM ###

if type npm &> /dev/null; then
    alias npm-update="npm update"
fi

### PIP ###

if type pip &> /dev/null; then
    alias pip-upgrade="python3 -m pip install --upgrade pip"
fi
