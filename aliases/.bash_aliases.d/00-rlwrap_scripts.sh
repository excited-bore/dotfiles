#!/bin/bash

# https://stackoverflow.com/questions/5412761/using-colors-with-printf
# Execute (during printf) for colored prompt
# printf  "${blue}This text is blue${white}\n"

# https://unix.stackexchange.com/questions/139231/keep-aliases-when-i-use-sudo-bash
if type sudo &> /dev/null; then
    alias sudo='sudo '
fi

if type wget &> /dev/null; then
    alias wget='wget --https-only '
fi


# https://stackoverflow.com/questions/4023830/how-to-compare-two-strings-in-dot-separated-version-format-in-bash

function version-higher () {
    if [[ $1 == $2 ]]; then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if ((10#${ver1[i]:=0} > 10#${ver2[i]:=0})); then
            return 0
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]})); then
            return 1
        fi
    done
    return 0
}


function compare-tput-escape_color(){
for (( ansi=0; ansi <= 120; ansi++)); do
    printf "$ansi $(tput setaf $ansi) tput foreground $(tput sgr0) $(tput setab $ansi) tput background $(tput sgr0)"; echo -e " \033[$ansi;mEscape\033[0m"
done | $PAGER
unset ansi
}

red=$(tput setaf 1)
red1=$(tput setaf 9)
green=$(tput setaf 2)
green1=$(tput setaf 10)
yellow=$(tput setaf 3)
yellow1=$(tput setaf 11)
blue=$(tput setaf 4)
blue1=$(tput setaf 12)
magenta=$(tput setaf 5)
magenta1=$(tput setaf 13)
cyan=$(tput setaf 6)
cyan1=$(tput setaf 14)
white=$(tput setaf 7)
white1=$(tput setaf 15)
black=$(tput setaf 16)
grey=$(tput setaf 8)

RED=$(tput setaf 1 && tput bold)
RED1=$(tput setaf 9 && tput bold)
GREEN=$(tput setaf 2 && tput bold)
GREEN1=$(tput setaf 10 && tput bold)
YELLOW=$(tput setaf 3 && tput bold)
YELLOW1=$(tput setaf 11 && tput bold)
BLUE=$(tput setaf 4 && tput bold)
BLUE1=$(tput setaf 12 && tput bold)
MAGENTA=$(tput setaf 5 && tput bold)
MAGENTA1=$(tput setaf 13 && tput bold)
CYAN=$(tput setaf 6 && tput bold)
CYAN1=$(tput setaf 14 && tput bold)
WHITE=$(tput setaf 7 && tput bold)
WHITE1=$(tput setaf 15 && tput bold)
BLACK=$(tput setaf 16 && tput bold)
GREY=$(tput setaf 8 && tput bold)

bold=$(tput bold)
underline_on=$(tput smul)
underline_off=$(tput rmul)
bold_on=$(tput smso)
bold_off=$(tput rmso)
half_bright=$(tput dim)
reverse_color=$(tput rev)

# Reset
normal=$(tput sgr0)

# Broken !! (Or im dumb?)
blink=$(tput blink)
underline=$(tput ul)
italic=$(tput it)

# ...
# https://ss64.com/bash/tput.html

# Arguments: Completions(string with space entries, AWK works too),return value(-a password prompt, -c complete filenames, -p prompt flag, -Q prompt colour, -b break-chars (when does a string break for autocomp), -e change char given for multiple autocompletions)
# 'man rlwrap' to see all unimplemented options


# reade because its rlwrap with read -e for file completions
# The upside is that files with spaces are backslashed
# The downside is that prompts with colour break when using arrow keys (accidently)
# This goes for both tput and escape codes
#
# read -e -r -p $'\e[31mFoobar\e[0m: ' foo  for example
# printf "${CYAN}bluh"; read -e -r foo  is also problematic because prompt disappears when arrow up and back down

function reade(){

    local VERSION='1.0' 

    unset READE_VALUE

    local hlpstr="${bold}reade${normal} [ -h/--help ] [ -v/--version] [ -i/--pregiven pregiven ] [ -e/--file-completion ]  [ -s/--no-echo ] [ -p/--prompt promptstring ] [ -q/--colour colourstring ] [ -b/--break-chars breakchars-string ] ${bold}choices-string${normal}  ${bold}returnvar${normal}\n
   simplifies prompt for ${bold}read/rlwrap${normal}: will use 'rlwrap' if it is installed, otherwise resorts to 'read' 
   supply at least 2 variables: 
   - a space seperated string with the choices for answer. ${bold}if no choices need to be given, supply a empty string '' - will not work without empty string. ${normal}
   - the last argument to put the answer in, otherwise the value will be in '\$reade_value'.  

   -h, --help  
        
        print this text and exit

   -v, --version  
        
        print version and exit

   -q ${underline_on}colour${underline_off}

        use  one  of  the  colour names black, red, green, yellow, blue, cyan, purple (=magenta) or white, or an ansi-conformant <colour_spec> to colour any prompt displayed  by  command.\n an upper
        case colour name (yellow or yellow ) gives a bold prompt.\n prompts that already contain (colour) escape sequences or one of the readline \"ignore markers\" (ascii 0x01 and 0x02) are not coloured.

   -i, --pre-given ${underline_on}pregiven string${underline_off} 

        autofill prompt with 'pregiven' - must come in the form of a string (only works when rlwrap is installed) 

   -s, --no-echo 

        Doesn't echo what's being typed to the terminal - usefull for password prompts and the like

   -e, --file-completion 

        Use filecompletions. 
        Will stop using rlwrap if it is installed because 'rlwrap' doesn't properly add slashed before spaces in filenames/directorynames and will use 'read -e' which does properly do this instead
    
   -b ${underline_on}list_of_characters${underline_off} 

       (From rlwrap manual) Consider  the specified characters word-breaking (whitespace is always word-breaking). This determines what is considered a \"word\", both when completing and when building a completion word list from files specified by -f options following (not preceding!) it.\n Default list (){}[],'+-=&^%%\$#@\";|\ \n Unless -c is specified, / and . (period) are included in the default list\n\n" 

    while :; do
        case $1 in
            -v|--version) 
               printf "${bold}version${normal} : $version\n"
               return 0
            ;; 
            ""|-h|-\?|--help)
              printf "$hlpstr"  
              return 0
          ;;
          # Otherwise 
          *) printf "$hlpstr"  
             return 0 
          ;;
       esac
    done && OPTIND=1;

    #https://stackoverflow.com/questions/12022592/how-can-i-use-long-options-with-the-bash-getopts-builtin
--fixed-strings
    for arg in "$@"; do
      shift
      case "$arg" in
        '--break-chars')       set -- "$@" '-b'   ;;
        '--colour')            set -- "$@" '-Q'   ;;
        '--prompt')            set -- "$@" '-p'   ;;
        '--file-completions')  set -- "$@" '-e'   ;;
        '--pre-given')         set -- "$@" '-i'   ;;
        '--no-echo')           set -- "$@" '-s'   ;;
        *)                     set -- "$@" "$arg" ;;
      esac
    done 
    

    while getopts ':b:e:i:p:Q:s:S:' flag; do
        case "${flag}" in
            e)  fcomp='y'
                break 
                ;;

            *)  fcomp='n'
                break 
                ;;
        esac
    done && OPTIND=1;
    bash_rlwrap='y'
    if [[ $(uname -s) =~ 'MINGW' ]] && ! type pacman &> /dev/null; then
        bash_rlwrap='n'
    fi
    if ! type rlwrap &> /dev/null || test "$fcomp" == 'y' || test $bash_rlwrap == 'n' ; then
        readstr="read  ";
        color=""
        while getopts ':b:e:i:p:Q:s:S:' flag; do
            case "${flag}" in
                b)  ;;
                e)  readstr=$(echo "$readstr" | sed 's|read |read -e -r |g');
                    ;;
                    #  Even though it's in the read man, -i does not actually work
                    i)  readstr=$(echo "$readstr" | sed 's|read |read -i "'"${OPTARG}"'" |g');
                    pre="${OPTARG}"
                    ;;
                Q)  if [[ "${OPTARG}" =~ ^[[:upper:]]+$ ]]; then
                        color="${bold}"
                    fi
                    OPTARG=$(echo ${OPTARG} | awk '{print tolower($0)}')
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
                p)  readstr=$(echo "$readstr" | sed 's|read |printf "'"${color}${OPTARG}${normal}"'\n"; read |g');
                    ;;
                s)  readstr=$(echo "$readstr" | sed 's|read |read -s "'"${OPTARG}"'" |g');
                    ;;
                S)  ;;
            esac
         done && OPTIND=1;

        eval "$readstr" value;

    eval "$readstr" value;

    if test $fcomp == 'y'; then
        echo $value >> ~/.bash_history
        history -n
    fi

    if ! test -z "$pre" && test -z "$value" || test "$value" == ""; then
        value="$pre"  
    fi

        if ! test -z "$pre" && test -z "$value" || test "$value" == ""; then
            value="$pre"  
        fi

        #black, red, green, yellow, blue, cyan, purple (=magenta) or white
        if ! test -z "${@:$#:1}" && ! test "${@:$#:1}" == '/bin/bash' && ! [[ "${@:$#:1}" =~ -.* ]]; then
            eval "${@:$#:1}=$value"  
        else
            export READE_VALUE="$value"
        fi
        unset fcomp
    else
        if [[ $# < 2 ]]; then
            echo "$@" 
            echo "Give up at least two variables for reade(). "
            echo "First a string with autocompletions, space seperated"
            echo "Second a variable (could be empty) for the return string"
            return 0
        fi


        local args="${@:$#-1:1}"

        # Reverse wordlist order (last -> first) because ???
        args=$(echo $args | awk '{ for (i=NF; i>1; i--) printf("%s ",$i); print $1; }')
        args=$(echo $args | tr ' ' '\n')
        tmpf=$(mktemp)

        echo "$args" > "$tmpf"

        local breaklines=''

        if test "$args" == ''; then
            rlwstring="rlwrap --ansi-colour-aware -s 1000 -D 0 -b \"$breaklines\" -o cat"
        else
            rlwstring="rlwrap --ansi-colour-aware -s 1000 -D 0 -H $tmpf -b \"$breaklines\" -f <(echo \"${args[@]}\") -o cat"
        fi

        while getopts ':b:e:i:p:Q:s:S:' flag; do
            case "${flag}" in
                b)  breaklines=${OPTARG};
                    ;;
                    # File completions
                    e)  rlwstring=$(echo $rlwstring | sed "s| -f <(echo \"${args[@]}\") | |g");
                    rlwstring=$(echo $rlwstring | sed "s|rlwrap |rlwrap \-c |g");
                    ;;
                    # Pre-filled answer
                    i)  rlwstring=$(echo $rlwstring | sed "s|rlwrap |rlwrap \-P \"${OPTARG}\" |g");
                    ;;
                    # Prompt
                    p)  rlwstring=$(echo $rlwstring | sed "s|rlwrap |rlwrap \-S \"${OPTARG}\" |g");
                    ;;
                    # Prompt colours
                    Q)  rlwstring=$(echo $rlwstring | sed "s|rlwrap |rlwrap \-p${OPTARG} |g");
                    ;;
                    # Password
                    s)  rlwstring=$(echo $rlwstring | sed "s|rlwrap |rlwrap \-aN\"${OPTARG}\" |g");
                    ;;
                    # Always echo *** w/ passwords
                    S)  rlwstring=$(echo $rlwstring | sed "s|rlwrap |rlwrap \-E\"${OPTARG}\" |g");
                    ;;
            esac
        done && OPTIND=1;

        value=$(eval $rlwstring);

        if ! test -z "${@:$#:1}" && ! test "${@:$#:1}" == '/bin/bash' && ! [[ "${@:$#:1}" =~ -.* ]]; then
            eval "${@:$#:1}=$value"  
        else
            export READE_VALUE="$value" 
        fi
        command rm $tmpf &> /dev/null;
    fi
    unset bash_rlwrap 
}


function readyn(){

    unset READYN_VALUE

    local VERSION='1.0' 

    while :; do
        case $1 in
            -h|-\?|--help)
                printf "${bold}readyn${normal} [ -h/--help ] [ -v/--version ]  [ -y/--yes [ PREFILL ] ]  [ -n/--no [ CONDITION ] ] [ -p/--prompt PROMPTSTRING ] [ -Q/--colour COLOURSTRING ]  [ -b/--break-chars BREAK-CHARS ] [ returnvar ]\n
               Simplifies yes/no prompt for ${bold}reade${normal}. Supply at least 1 variable as the last argument to put the answer in, otherwise the value will be in '\$READYN_VALUE'.  
'${GREEN} [${underline_on}Y${underline_off}es/${underline_on}n${underline_off}o]: ${normal}' : 'y' as pre-given, 'n' as other option. Colour for the prompt is ${GREEN}GREEN (Default)${normal} 
'${YELLOW} [${underline_on}N${underline_off}o/${underline_on}y${underline_off}es]: ${normal}' : 'n' as pre-given, 'y' as other option. Colour for the prompt is ${YELLOW}YELLOW${normal}
    For both an empty answer will return the default answer. 

    -h, --help  
        
        Print this text and exit
     
   -y, --yes ${underline_on}prefill${underline_off} 

        Autofill prompt with 'y' if nothing is supplied, otherwise prefill with given 

   -n, --no ${underline_on}condition${underline_off}

       Set '${YELLOW} [${underline_on}N${underline_off}o/${underline_on}y${underline_off}es]: ${normal}' as the default prompt. Give a condition for when to prompt with 'no'. 
    
   -Q ${underline_on}Colour${underline_off}

        Use  one  of  the  colour names black, red, green, yellow, blue, cyan, purple (=magenta) or white, or an ANSI-conformant <colour_spec> to colour any prompt displayed  by  command.\n An uppercase colour name (Yellow or YELLOW ) gives a bold prompt.\n Prompts that already contain (colour) escape sequences or one of the readline \"ignore markers\" (ASCII 0x01 and 0x02) are not coloured.
    
    -b ${underline_on}list_of_characters${underline_off} 

        (From rlwrap manual) Consider  the specified characters word-breaking (whitespace is always word-breaking). This determines what is considered a \"word\", both when completing and when building a completion word list from files specified by -f options following (not preceding!) it.\n Default list (){}[],'+-=&^%%\$#@\";|\ \n Unless -c is specified, / and . (period) are included in the default list\n\n"
              return 0
          ;;
          -v|--version) 
             printf "${bold}Version${normal} : $VERSION\n"
             return 0
          ;; 

          # Otherwise 
          *) break 
          ;;
       esac
    done && OPTIND=1;
    

    #https://stackoverflow.com/questions/12022592/how-can-i-use-long-options-with-the-bash-getopts-builtin

    for arg in "$@"; do
      shift
      case "$arg" in
        '--break-chars')       set -- "$@" '-b'   ;;
        '--colour')            set -- "$@" '-Q'   ;;
        '--prompt')            set -- "$@" '-p'   ;;
        '--no')                set -- "$@" '-n'   ;;
        '--yes')               set -- "$@" '-y'   ;;
        *)                     set -- "$@" "$arg" ;;
      esac
    done 

    local breaklines=''
    local nocase='' 
    local pre='' 
    local preff='' 
    local color='' 
    OPTIND=1
    while getopts ':b:Q:p:y:yn:n' flag; do
        case "${flag}" in
             b)  breaklines="-b \"${OPTARG}\"";
             ;;    
             Q)  color="${OPTARG}";
             ;;    
             p)  prmpt=${OPTARG};
             ;;
             y) if [ "${OPTARG}" ] && ! test "${OPTARG}" == '--' && ! [[ ${OPTARG} =~ -.* ]] && ! test "${OPTARG}" == "${@:$#:1}"; then
                    preff=${OPTARG};
                else
                    preff='y'
                    if [[ ${OPTARG} =~ -.* ]]; then
                        OPTIND=$(($OPTIND - 1)) 
                    fi
                fi
             ;;
             n) if [ "${OPTARG}" ] && ! test "${OPTARG}" == '--' && ! [[ ${OPTARG} =~ ^-.* ]] && ! test "${OPTARG}" == "${@:$#:1}"; then
                    nocase="${OPTARG}"
                fi 
                if [[ ${OPTARG} =~ ^-.* ]]; then
                    OPTIND=$(($OPTIND - 1)) 
                fi
                if ! test -z "$nocase" && eval "$nocase" || test -z "$nocase" ; then
                    pre='n'
                    othr='y'
                    prmpt1=" [${underline_on}N${underline_off}o/${underline_on}y${underline_off}es]: "
                    test -z $color && color='YELLOW'
                fi
             ;;
        esac
    done && OPTIND=1;
    if test -z $pre; then 
        pre='y'
        othr='n'
        prmpt1=" [${underline_on}Y${underline_off}es/${underline_on}n${underline_off}o]: "
        test -z $color && color='GREEN'
    fi

    if ! test -z $preff; then
        if test -z "$prmpt"; then
            printf "${!color}$prmpt1$preff${normal}\n" ;   
        else
            printf "${!color}$prmpt$prmpt1$preff${normal}\n" ;   
        fi
        value=$preff 
    else
        if ! test -z "$prmpt"; then
            reade -Q "$color" $breaklines -i "$pre" -p "$prmpt$prmpt1" "$othr" value;   
        else
            reade -Q "$color" $breaklines -i "$pre" -p "$prmpt1" "$othr" value;    
        fi

    fi 

    if ! test -z "${@:$#:1}" && ! test "${@:$#:1}" == '/bin/bash' && ! [[ "${@:$#:1}" =~ -.* ]]; then
        eval "${@:$#:1}=$value" 
    else
        export READYN_VALUE="$value" 
    fi

    unset pre other prmpt prmpt1 color readestr breaklines value 
}

alias yes_no='readyn'
alias yes-no='readyn'


#reade -p "Usb ids" $(sudo lsusb | awk 'BEGIN { FS = ":" };{print $1;}')

function yes_edit_no(){
    if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
        printf "Needs 3 parameters.\n 1) Function with commands if yes\n 2) File to edit\n 3) prompt (adds [y/n/e]: afterwards) \n (4) Default \"yes\",\"edit\",\"no\")\n (5) Optional - Colour)\n";
        return 0;
    else
        pass="";
        clr="";
        pre="y"
        choices="e n"
        deflt=" [Y/e/n]: "; 
        prompt="$3$deflt";
        if [ "$4" == "edit" ]; then
            pre="e"
            choices="y n"
            deflt=" [y/E/n]: ";
            prompt="$3$deflt";
        elif [ "$4" == "no" ]; then
            pre="n"
            choices="y e"
            deflt=" [y/e/N]: ";
            prompt="$3$deflt";
        fi
        if [ ! -z "$5" ]; then
            clr="-Q $5"
        fi
        
        reade $clr -i "$pre" -p "$prompt" "$choices" pass;
        
        #Undercase only
        pass=$(echo "$pass" | tr '[:upper:]' '[:lower:]')

        if [ -z "$pass" ]; then
            pass="$pre";
        fi
        
        if [ "$pass" == "y" ]; then
           $1; 
        elif [ "$pass" == "e" ]; then
            str=($2);
            for i in "${str[@]}"; do
                "$EDITOR" "$i";
            done;
            deflt=" [y/N]: "
            pre="n"
            prompt="$3$deflt";
            reade $clr -i "$pre" -p "$prompt" "y n" pass2;
            if [ "$pass2" == "y" ]; then
                $1;
            fi
        fi
    fi
}

