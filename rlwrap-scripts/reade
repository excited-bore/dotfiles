#!/bin/bash

function reade() {
    test -n "$ZSH_VERSION" && setopt local_options err_return local_traps extended_glob &&
        HISTSIZE=1000 &&
        SAVEHIST=1000

    local red=$(tput setaf 1)
    local red1=$(tput setaf 9)
    local green=$(tput setaf 2)
    local green1=$(tput setaf 10)
    local yellow=$(tput setaf 3)
    local yellow1=$(tput setaf 11)
    local blue=$(tput setaf 4)
    local blue1=$(tput setaf 12)
    local magenta=$(tput setaf 5)
    local magenta1=$(tput setaf 13)
    local cyan=$(tput setaf 6)
    local cyan1=$(tput setaf 14)
    local white=$(tput setaf 7)
    local white1=$(tput setaf 15)
    local black=$(tput setaf 16)
    local grey=$(tput setaf 8)

    local RED=$(tput setaf 1 && tput bold)
    local RED1=$(tput setaf 9 && tput bold)
    local GREEN=$(tput setaf 2 && tput bold)
    local GREEN1=$(tput setaf 10 && tput bold)
    local YELLOW=$(tput setaf 3 && tput bold)
    local YELLOW1=$(tput setaf 11 && tput bold)
    local BLUE=$(tput setaf 4 && tput bold)
    local BLUE1=$(tput setaf 12 && tput bold)
    local MAGENTA=$(tput setaf 5 && tput bold)
    local MAGENTA1=$(tput setaf 13 && tput bold)
    local CYAN=$(tput setaf 6 && tput bold)
    local CYAN1=$(tput setaf 14 && tput bold)
    local WHITE=$(tput setaf 7 && tput bold)
    local WHITE1=$(tput setaf 15 && tput bold)
    local BLACK=$(tput setaf 16 && tput bold)
    local GREY=$(tput setaf 8 && tput bold)

    local bold=$(tput bold)
    local underline_on=$(tput smul)
    local underline_off=$(tput rmul)
    local bold_on=$(tput smso)
    local bold_off=$(tput rmso)
    local half_bright=$(tput dim)
    local reverse_color=$(tput rev)

    # Reset
    local normal=$(tput sgr0)

    # Broken !! (Or im dumb?)
    local blink=$(tput blink)
    local underline=$(tput ul)
    local italic=$(tput it)

    local VERSION='1.0'

    unset READE_VALUE

    local hlpstr="${bold}reade${normal} [ -h/--help ] [ -v/--version] [ -i/--pregiven PREGIVEN ] [ -e/--file-completion ]  [ -s/--no-echo ] [ -p/--prompt PROMPTSTRING ] [ -Q/--colour COLOURSTRING ] [ -b/--break-chars BREAKCHARS-STRING ] ${bold}CHOICES-STRING${normal}  ${bold}returnvar${normal}\n
   Simplifies prompt for ${bold}read/rlwrap${normal}: Will use 'rlwrap' if it is installed, otherwise resorts to 'read' 
   Takes at least one argument, otherwise will prompt help page.

   Any pre-given choice can be toggled between using the ${bold}up${normal} and ${bold}down${normal} arrow keys

   Supply at least 1 variable: 

   - The last argument - a variable to put the prompt response in. If no variable is supplied, the returned value will be in the '\$REPLY' and '\$READE_VALUE'. 

   -h, --help  
        
        Print this text and exit

   -v, --version  
        
        Print version and exit

   -Q ${underline_on}Colour${underline_off}

        Use  one  of  the  colour names black, red, green, yellow, blue, cyan, purple (=magenta) or white, or an ANSI-conformant <colour_spec> to colour any prompt displayed  by  command.\n An uppercase colour name (Yellow or YELLOW ) gives a bold prompt.\n Prompts that already contain (colour) escape sequences or one of the readline \"ignore markers\" (ASCII 0x01 and 0x02) are not coloured.

    -i, --pre-given ${underline_on}PREGIVEN(S) - SPACESEPERATED WORD STRING${underline_off} 

        Autofill prompt with 'PREGIVEN' - must come in the form of a string (only works when rlwrap is installed) and every WORD needs to be space-separated. Only the first will be show at first, the others will be selectable with autocompletion/arrowkeys in the order they were given ${bold}if rlwrap is installed${normal} 

   -s, --no-echo 

        Doesn't echo what's being typed to the terminal - usefull for password prompts and the like

   -e, --file-completion 

        Use filecompletions. 
        Will stop using rlwrap if it is installed because 'rlwrap' doesn't properly add slashed before spaces in filenames/directorynames and will use 'read -e' which does properly do this instead
    
   -b ${underline_on}list_of_characters${underline_off} 

       (From rlwrap manual) Consider  the specified characters word-breaking (whitespace is always word-breaking). This determines what is considered a \"word\", both when completing and when building a completion word list from files specified by -f options following (not preceding!) it.\n Default list (){}[],'+-=&^%%\$#@\";|\ \n Unless -c is specified, / and . (period) are included in the default list\n\n"

    while :; do
        case $1 in
        '' | -h | -\? | --help)
            printf "$hlpstr"
            return 0
            ;;
        -v | --version)
            printf "${bold}Version${normal} : $VERSION\n"
            return 0
            ;;
        # Otherwise
        *)
            break
            ;;
        esac
    done && OPTIND=1

    #https://stackoverflow.com/questions/12022592/how-can-i-use-long-options-with-the-bash-getopts-builtin

    for arg in "$@"; do
        shift
        case "$arg" in
        '--break-chars') set -- "$@" '-b' ;;
        '--colour') set -- "$@" '-Q' ;;
        '--prompt') set -- "$@" '-p' ;;
        '--file-completions') set -- "$@" '-e' ;;
        '--pre-given') set -- "$@" '-i' ;;
        '--no-echo') set -- "$@" '-s' ;;
        *) set -- "$@" "$arg" ;;
        esac
    done

    local fcomp='n'
    local noecho='n'

    while getopts 'sS:b:e:i:p:Q:' flag; do
        case "${flag}" in
        e)
            fcomp='y'
            ;;
        s)
            noecho='y'
            ;;
        esac
    done && OPTIND=1

    local rlwrap_installable='y'

    if [[ $(uname -s) =~ 'MINGW' ]] && ! type pacman &>/dev/null; then
        rlwrap_installable='n'
    fi

    if ! type rlwrap &>/dev/null || [[ "$fcomp" == 'y' ]] || [[ "$rlwrap_installable" == 'n' ]]; then

        local readstr=''

        if test -n "$BASH_VERSION"; then
            readstr="read -r vvvvvvvvvv"
        fi

        if test -n "$ZSH_VERSION"; then
            if [[ "$noecho" == 'y' ]]; then
                readstr="read vvvvvvvvvv"
            elif [[ "$noecho" == 'n' ]]; then
                readstr="vvvvvvvvvv=''; vared vvvvvvvvvv"
            fi
        fi

	local oldhist=''
        local color=""
        local args=''
        local tmpf=''
	local eflag=0
        local pre=''
        while getopts 'sS:b:e:i:p:Q:' flag; do
            case "${flag}" in
            b) ;;
            e)
                if test -n "$BASH_VERSION" || [[ $noecho == 'y' ]]; then
                    readstr=$(echo "$readstr" | sed 's|read |read -e |g')
                fi
                if test -n "$ZSH_VERSION"; then
                    readstr=$(echo "$readstr" | sed 's|vvvvvvvvvv=.*; vared|vvvvvvvvvv="\$(pwd)"; vared|g')
                fi
                ;;
                #  Even though it's in the read man for bash, -i (on it's own) does not actually work
            i)
                arg="$(echo ${OPTARG} | awk '{print $1;}')"
                args="$(echo ${OPTARG} | sed "s/\<$arg\> //g")"

                if test -n "$BASH_VERSION"; then
                    readstr=$(echo "$readstr" | sed 's|read |read -e -i "'"$arg"'" |g')
                fi

                if test -n "$ZSH_VERSION" && [[ $noecho == 'n' ]]; then
                    readstr=$(echo "$readstr" | sed 's|vvvvvvvvvv=.*; vared|vvvvvvvvvv=""; vared -h|g')
                fi
                pre="$arg"

                if ! test -z "$args"; then
		    args=$(echo "$args" | awk '{ for (i=NF; i>1; i--) printf("%s ",$i); print $1; }')
                    args=$(echo "$args" | tr ' ' '\n')

                    tmpf=$(mktemp)

                    echo "$args" >"$tmpf"

                    test -e $HISTFILE &&
                        oldhist=$HISTFILE

                    ! test -e $HISTFILE && test -n $BASH_VERSION && test -f ~/.bash_history && test -n "$(cat ~/.bash_history)" &&
                        oldhist=~/.bash_history

                    ! test -e $HISTFILE && test -n $ZSH_VERSION && test -f ~/.zhistory && test -n "$(cat ~/.zhistory)" &&
                        oldhist=~/.zhistory

                    if ! test -e "$HISTFILE"; then
                        oldhist=$(mktemp)
                        echo $(history | awk '{$1=""; print; }') >$oldhist
                    fi

                    if test -n "$BASH_VERSION"; then
                        while IFS='' read -r LINE || [ -n "${LINE}" ]; do
                            history -s "${LINE}"
                        done <"$tmpf"
                        history -c
                        history -r $tmpf
                    fi

                    if test -n "$ZSH_VERSION"; then
                        echo "$arg" >>"$tmpf"

                        while IFS='' read -r LINE || [ -n "${LINE}" ]; do
                            print -S "${LINE}"
                        done <$tmpf
			# Write to current historyfile
			fc -W
			# Then load different one - no need to clear
			fc -p "$tmpf"
                    fi

                    # https://unix.stackexchange.com/questions/265957/zsh-histfile-still-read-from-zsh-history
                fi
                ;;
            Q)
                if [[ "${OPTARG}" =~ ^[[:upper:]]+$ ]]; then
                    color="${bold}"
                fi
                OPTARG=$(echo "${OPTARG}" | awk '{print tolower($0)}')
                if [[ "${OPTARG}" =~ "red" ]]; then
                    color=$color"${red}"
                elif [[ "${OPTARG}" =~ "green" ]]; then
                    color=$color"${green}"
                elif [[ "${OPTARG}" =~ "blue" ]]; then
                    color=$color"${blue}"
                elif [[ "${OPTARG}" =~ "yellow" ]]; then
                    color=$color"${yellow}"
                elif [[ "${OPTARG}" =~ "cyan" ]]; then
                    color=$color"${cyan}"
                elif [[ "${OPTARG}" =~ "magenta" ]]; then
                    color=$color"${magenta}"
                elif [[ "${OPTARG}" =~ "black" ]]; then
                    color=$color"${black}"
                elif [[ "${OPTARG}" =~ "white" ]]; then
                    color=$color"${white}"
                fi
                ;;
            p)
                if test -n "$BASH_VERSION"; then
                    test -z "$color" &&
                        readstr=$(echo "$readstr" | sed 's|read |printf "'"${OPTARG}"'\n"; read |g') ||
                        readstr=$(echo "$readstr" | sed 's|read |printf "'"${color}${OPTARG}${normal}"'\n"; read |g')
                fi

                if test -n "$ZSH_VERSION"; then
                    if [[ $noecho == 'y' ]]; then
                        test -z "$color" &&
                            readstr=$(echo "$readstr" | sed 's|vvvvvvvvvv|"?'"${OPTARG}"'" vvvvvvvvvv|g') ||
                            readstr=$(echo "$readstr" | sed 's|vvvvvvvvvv|"?'"${color}${OPTARG}${normal}"'" vvvvvvvvvv|g')
                    elif test -n "$color"; then
                        readstr=$(echo "$readstr" | sed 's|vared |vared -p "'"${color}${OPTARG}${normal}"'" |g')
                    else
                        readstr=$(echo "$readstr" | sed 's|vared |vared -p "'"${optarg}"'" |g')
                    fi
                fi
                ;;
            s)
                readstr=$(echo "$readstr" | sed 's|read |read -s |g')
                ;;
            S) ;;
            *) ;;
            esac
        done

        shift $((OPTIND - 1))

        local oldtrps="$(trap)"

        # https://stackoverflow.com/questions/14702148/how-to-fire-a-command-when-a-shell-script-is-interrupted

        test -n "$BASH_VERSION" &&
            trap "history -c; history -r $oldhist; command rm -f $tmpf; eval \"$oldtrps\"; test -n \"$oldtrps\" && eval \"$oldtrps\" || trap - SIGINT; exit 130" SIGINT
        
	test -n "$ZSH_VERSION" &&
	   TRAPINT() {
	      fc -IR $oldhist
              fc -IR
	      command rm -f "$tmpf"
              return $((128 + $1))
           }

        eval "${readstr}"

        test -n "$BASH_VERSION" &&
            history -c &&
            history -r $oldhist

        test -n "$ZSH_VERSION" &&
	    fc -IR $oldhist

        test -n "$oldtrps" &&
            eval "$oldtrps" ||
            trap - SIGINT

        [ -e "$tmpf" ] && command rm -f $tmpf

        if ! test -z "$pre" && test -z "$vvvvvvvvvv" || [[ "$vvvvvvvvvv" == "" ]]; then
            vvvvvvvvvv="$pre"
        fi

        export READE_VALUE="$vvvvvvvvvv"
        export REPLY="$vvvvvvvvvv"

        if ! test -z "$@"; then
            eval "${@:$#:1}='$vvvvvvvvvv'"
        fi
	
    else
        if [[ $# < 1 ]]; then
            echo "Give at least 1 variable up for reade(). "
            echo "- A variable for the return string"
            return 1
        fi

        local breaklines=''
        local tmpf=''
        local frst=''
        local args=''
        local rlwstring="rlwrap --ansi-colour-aware -s 1000 -D 0 -b \"$breaklines\" -o cat"

        while getopts ':b:e:i:p:Q:s:S:' flag; do
            case "${flag}" in
            b)
                breaklines=${OPTARG}
                ;;
            # File completions
            e) #rlwstring=$(echo $rlwstring | sed "s| -f <(echo \"${args[@]}\") | |g");
                rlwstring=$(echo $rlwstring | sed "s|rlwrap |rlwrap \-c |g")
                ;;
            # Pre-filled answer
            i)
                frst="$(echo ${OPTARG} | awk '{print $1}')"
                rlwstring=$(echo $rlwstring | sed "s|rlwrap |rlwrap \-P \"$frst\" |g")
                args=$(echo ${OPTARG} | sed "s|\<$frst\> ||g")
                ! test -z "$args" &&
                    args=$(echo $args | awk '{ for (i=NF; i>1; i--) printf("%s ",$i); print $1; }') &&
                    args=$(echo $args | tr ' ' '\n') &&
                    tmpf=$(mktemp) &&
                    echo "$args" >"$tmpf" &&
                    rlwstring=$(echo $rlwstring | sed 's| -o cat| \-H $tmpf  \-f <(echo \"${args[@]}\") -o cat|g')
                ;;
            # Prompt
            p)
                rlwstring=$(echo $rlwstring | sed "s|rlwrap |rlwrap \-S \"${OPTARG}\" |g")
                ;;
            # Prompt colours
            Q)
                rlwstring=$(echo $rlwstring | sed "s|rlwrap |rlwrap \-p${OPTARG} |g")
                ;;
            # Password
            s)
                rlwstring=$(echo $rlwstring | sed "s|rlwrap |rlwrap \-aN\"${OPTARG}\" |g")
                ;;
            # Always echo *** w/ passwords
            S)
                rlwstring=$(echo $rlwstring | sed "s|rlwrap |rlwrap \-E\"${OPTARG}\" |g")
                ;;
            *) ;;
            esac
        done

        shift $((OPTIND - 1))

        # Cant unset of localize this 'vvvvvvvv' variable

        vvvvvvvv="$(eval $rlwstring)"

        export REPLY="$vvvvvvvv"
        export READE_VALUE="$vvvvvvvv"

        ! test $# -eq 0 && eval "${@:$#:1}=$vvvvvvvv"

        command rm $tmpf &>/dev/null
    fi
}
