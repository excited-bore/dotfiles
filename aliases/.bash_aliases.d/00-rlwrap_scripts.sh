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

if type curl &> /dev/null; then
   alias curl='curl --proto "=https" --tlsv1.2 ' 
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
# printf "${CYAN}bar"; read -e -r foo  is also problematic because prompt disappears when arrow up and back down

function reade(){

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
     
    local VERSION='1.0' 

    unset READE_VALUE
    
    hlpstr="${bold}reade${normal} [ -h/--help ] [ -v/--version] [ -i/--pregiven PREGIVEN ] [ -e/--file-completion ]  [ -s/--no-echo ] [ -p/--prompt PROMPTSTRING ] [ -Q/--colour COLOURSTRING ] [ -b/--break-chars BREAKCHARS-STRING ] ${bold}CHOICES-STRING${normal}  ${bold}returnvar${normal}\n
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
          ''|-h|-\?|--help)
              printf "$hlpstr" 
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
    if ! type rlwrap &> /dev/null || test "$fcomp" == 'y' || test "$bash_rlwrap" == 'n' ; then
        readstr="read -r "
        color=""
        OLD_HISTFILE=$HISTFILE
        while getopts ':b:e:i:p:Q:s:S:' flag; do
            case "${flag}" in
                b)  ;;
                e)  readstr=$(echo "$readstr" | sed 's|read |read -e |g');
                    ;;
                    #  Even though it's in the read man, -i does not actually work
                i)  arg="$(echo ${OPTARG} | awk '{print $1;}')"
                    args="$(echo ${OPTARG} | sed "s/\<$frst\> //g")"  
                    readstr=$(echo "$readstr" | sed 's|read |read -e -i "'"$arg"'" |g');
                    pre="$arg"
                    ! test -z "$args" &&   
                    args=$(echo $args | awk '{ for (i=NF; i>1; i--) printf("%s ",$i); print $1; }') &&
                    args=$(echo $args | tr ' ' '\n') &&
                    tmpf=$(mktemp) && 
                    echo "$args" > "$tmpf" && 
                    export HISTFILE=$tmpf
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
                p)  if test -z "$color"; then
                        readstr=$(echo "$readstr" | sed 's|read |printf "'"${OPTARG}"'\n"; read |g');
                    else
                        readstr=$(echo "$readstr" | sed 's|read |printf "'"${color}${OPTARG}${normal}"'\n"; read |g');
                    fi
                    ;;
                s)  readstr=$(echo "$readstr" | sed 's|read |read -s "'"${OPTARG}"'" |g');
                    ;;
                S)  ;;
            esac
        done;

        shift $((OPTIND-1)) 
       
        eval "${readstr} value";

        if test "$fcomp" == 'y'; then
            echo $value >> $HISTFILE 
            history -n
        fi

        if ! test -z "$pre" && test -z "$value" || test "$value" == ""; then
            value="$pre"  
        fi

        export READE_VALUE="$value"
        export REPLY="$value" 

        if ! test -z "$@"; then
            eval "${@:$#:1}=$value"  
        fi

        unset fcomp

    else
        if [[ $# < 1 ]]; then
            echo "Give at least 1 variable up for reade(). "
            echo "- A variable for the return string"
            return 0
        fi

        local breaklines=''

        #local args="${@:$#-1:1}"

        ## Reverse wordlist order (last -> first) because ???
        #args=$(echo $args | awk '{ for (i=NF; i>1; i--) printf("%s ",$i); print $1; }')
        #args=$(echo $args | tr ' ' '\n')

        local tmpf=''
        rlwstring="rlwrap --ansi-colour-aware -s 1000 -D 0 -b \"$breaklines\" -o cat"

        while getopts ':b:e:i:p:Q:s:S:' flag; do
            case "${flag}" in
                b)  breaklines=${OPTARG};
                    ;;
                    # File completions
                    e)  #rlwstring=$(echo $rlwstring | sed "s| -f <(echo \"${args[@]}\") | |g");
                        rlwstring=$(echo $rlwstring | sed "s|rlwrap |rlwrap \-c |g");
                    ;;
                    # Pre-filled answer
                    i)  frst="$(echo ${OPTARG} | awk '{print $1}')"  
                        rlwstring=$(echo $rlwstring | sed "s|rlwrap |rlwrap \-P \"$frst\" |g");
                        args=$(echo ${OPTARG} | sed "s/\<$frst\> //g") 
                        ! test -z "$args" &&
                        args=$(echo $args | awk '{ for (i=NF; i>1; i--) printf("%s ",$i); print $1; }') &&
                        args=$(echo $args | tr ' ' '\n') &&
                        tmpf=$(mktemp) && 
                        echo "$args" > "$tmpf" && 
                        rlwstring=$(echo $rlwstring | sed 's| -o cat| \-H $tmpf  \-f <(echo \"${args[@]}\") -o cat|g') 
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
        done;

        shift $((OPTIND-1)) 

        value="$(eval $rlwstring)";

        if ! test $# -eq 0; then
            eval "${@:$#:1}=$value" 
        else
            export READE_VALUE="$value" 
        fi
        command rm $tmpf &> /dev/null;
    fi
    unset bash_rlwrap 
}


function readyn(){

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
         

    local VERSION='1.0' 

    while :; do
        case $1 in
            -h|-\?|--help|'')
                printf "     ${bold}readyn${normal} [ -h/--help ] [ -v/--version ]  [ -y/--yes [ PREFILL ] ]  [ -n/--no [ CONDITION ] ] [ -p/--prompt PROMPTSTRING ] [ -Q/--colour COLOURSTRING ]  [ -b/--break-chars BREAK-CHARS ] [ returnvar ]\n
     Simplifies yes/no prompt for ${bold}reade${normal}. 
     Takes at least one argument, otherwise will prompt help page.
     
     Like 'read' and 'reade', supply at a variable as the last argument for the return value. 
     Otherwise the value will be in the '\$REPLY' and '\$READE_VALUE'.    
     '${GREEN} [${underline_on}Y${underline_off}es/${underline_on}n${underline_off}o]: ${normal}' : 'y' as pre-given, 'n' as other option. Colour for the prompt is ${GREEN}GREEN (Default)${normal} 
     '${YELLOW} [${underline_on}N${underline_off}o/${underline_on}y${underline_off}es]: ${normal}' : 'n' as pre-given, 'y' as other option. Colour for the prompt is ${YELLOW}YELLOW${normal}
     For both an empty answer will return the default answer. 

    -h, --help  
        
        Print this text and exit
     
    -p, --prompt ${underline_on}PROMPTSTRING${underline_off} 

        Prompt to supply. At the end of the prompt '[${underline_on}Y${underline_off}es/${underline_on}n${underline_off}o]: ' or '[${underline_on}N${underline_off}o/${underline_on}y${underline_off}es]: ' will appear.  

    -y, --yes [ ${underline_on}prefill${underline_off} ], [[ ${underline_on}prefill-prompt${underline_off} ]] 
        Set to 'Yes' prompt with 2 optional, comma-separated arguments 
        Pregiven is 'y' without argument, otherwise first becomes pregiven. 
        Second optional is the prefill word in coloured prompt ([Word]), otherwise defaults to '[${underline_on}Y${underline_off}es/${underline_on}n${underline_off}o]: ' 

    -n, --no [ ${underline_on}prefill${underline_off} ], [[ ${underline_on}prefill-prompt${underline_off} ]] 
        Same as for --yes but 'no' variant
        Default pregiven is 'n', prompt word in prompt defaults to '[${underline_on}N${underline_off}o/${underline_on}y${underline_off}es]: ' when only '--no' is supplied
        
        If neither '--no' or '--yes' are active => yes-prompt 
    
    -c, --condition ${underline_on}CONDITION${underline_off} 

        At default will prefer to prompt the '--no' flag over the '--yes' flag. 
        If you only want the '--no' prompt to be applicable when a given condition is active then give it up as an argument in a string. 

    -Y, --yes-colour ${underline_on}COLOUR${underline_off}
        Default: ${GREEN}GREEN${normal} 

    -N, --no-colour ${underline_on}COLOUR${underline_off}
        Default: ${YELLOW}YELLOW${normal} 

        Only active if --yes(Default)/--no applicable. 
        Use  one  of  the  colour names black, red, green, yellow, blue, cyan, purple (=magenta) or white, or an ANSI-conformant <colour_spec> to colour any prompt displayed  by  command.\n\tAn uppercase colour name (Yellow or YELLOW ) gives a bold prompt.\n Prompts that already contain (colour) escape sequences or one of the readline \"ignore markers\" (ASCII 0x01 and 0x02) are not coloured.

    -a, --auto 
        
        Fill in with the pregiven immediately

    -b ${underline_on}list_of_characters${underline_off} 

        (Applicable when ${bold}rlwrap${normal} installed - from manual):
        Consider  the specified characters word-breaking (whitespace is always word-breaking). 
        This determines what is considered a \"word\", both when completing and when building a completion word list from files specified by -f options following (not preceding!) it.
        Default list (){}[],'+-=&^%%\$#@\";|\  
        Unless -c is specified, / and . (period) are included in the default list\n\n"
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
        '--yes')               set -- "$@" '-y'   ;;
        '--no')                set -- "$@" '-n'   ;;
        '--yes-colour')        set -- "$@" '-Y'   ;;
        '--auto')              set -- "$@" '-a'   ;;
        '--no-colour')         set -- "$@" '-N'   ;;
        '--prompt')            set -- "$@" '-p'   ;;
        '--condition')         set -- "$@" '-c'   ;;
        '--break-chars')       set -- "$@" '-b'   ;;
        *)                     set -- "$@" "$arg" ;;
      esac
    done 

    local breaklines=''
    local condition='' 
    local pre='y'
    local pre_y='y'
    local pre_n='n' 
    local othr='n' 
    local prmpty="${underline_on}Y${underline_off}es"
    local prmptn="${underline_on}n${underline_off}o"
    local ycolor='GREEN' 
    local ncolor='YELLOW' 
    local color="$ycolor" 
    local ygivn=0, ngivn=0 
    local preff=''
    local auto=''
    OPTIND=1
    while getopts 'anyb:Y:N:c:p:y:n:' flag; do
        case "${flag}" in
             a)  auto='y' 
                 ;;
             b) if [ "${OPTARG}" ] && ! test "${OPTARG}" == '--' && ! [[ ${OPTARG} =~ ^-.* ]]; then 
                    breaklines="-b \"${OPTARG}\"";
                fi 
                if [[ ${OPTARG} =~ ^-.* ]]; then
                    OPTIND=$(($OPTIND - 1)) 
                fi
             ;;    
             Y) if [ "${OPTARG}" ] && ! test "${OPTARG}" == '--' && ! [[ ${OPTARG} =~ ^-.* ]]; then 
                    ycolor="${OPTARG}";
                fi
                if [[ ${OPTARG} =~ ^-.* ]]; then
                    OPTIND=$(($OPTIND - 1)) 
                fi
             ;;    
             N) if [ "${OPTARG}" ] && ! test "${OPTARG}" == '--' && ! [[ ${OPTARG} =~ ^-.* ]]; then
                    ncolor="${OPTARG}";
                fi
                if [[ ${OPTARG} =~ ^-.* ]]; then
                    OPTIND=$(($OPTIND - 1)) 
                fi 
             ;;    
             p) if [ "${OPTARG}" ] && ! test "${OPTARG}" == '--' && ! [[ ${OPTARG} =~ ^-.* ]]; then
                    prmpt="${OPTARG}";
                fi
                if [[ ${OPTARG} =~ ^-.* ]]; then
                    OPTIND=$(($OPTIND - 1)) 
                fi 
             ;;
             y)  preff='y'
                 local args='' 
                 if [ "${OPTARG}" ] && ! test "${OPTARG}" == '--' && ! [[ ${OPTARG} =~ ^-.* ]]; then

                    # disable glob 
                    set -f 

                    # split on space characters 
                    IFS=',' 

                    args=($OPTARG);
                    pre_y="${args[0]}" 
                    ! test -z "${args[1]}" && prmpty="${args[1]}" 
                else
                    pre='y' 
                    prmpty="${underline_on}Y${underline_off}es"
                    prmptn="${underline_on}n${underline_off}o" 
                    if [[ ${OPTARG} =~ -.* ]]; then
                        OPTIND=$(($OPTIND - 1)) 
                    fi
                fi
                #if ! test -z "$condition" && ! ${condition} || test -z "$condition" ; then
                #    pre='y'
                #    othr='n'
                #    color="$ycolor" 
                #fi
                ;;

            n)  preff='n'
                local args='' 
                if [ "${OPTARG}" ] && ! test "${OPTARG}" == '--' && ! [[ ${OPTARG} =~ ^-.* ]]; then
                    set -f 
                    IFS=',' 
                    args=($OPTARG);
                    pre_n="${args[0]}"
                    ! test -z "${args[1]}" && prmptn="${args[1]}"  
                else
                    pre='n'
                    prmptn="${underline_on}N${underline_off}o"
                    prmpty="${underline_on}y${underline_off}es" 
                    if [[ ${OPTARG} =~ ^-.* ]]; then
                        OPTIND=$(($OPTIND - 1)) 
                    fi
                fi
                ;; 

              c) if [ "${OPTARG}" ] && ! test "${OPTARG}" == '--' && ! [[ ${OPTARG} =~ ^-.* ]]; then
                    condition="${OPTARG}"
                fi 
                if [[ ${OPTARG} =~ ^-.* ]]; then
                    OPTIND=$(($OPTIND - 1)) 
                fi 
                ;;
        esac
    done 
    
    shift $((OPTIND-1)) 
    
    if test -z "$preff" || test "$preff" == 'y'; then
        prmpt1=" [$prmpty/$prmptn]: "
        color="$ycolor"
        pre=$pre_y 
        othr=$pre_n 
    else
        prmpt1=" [$prmptn/$prmpty]: "
        color="$ncolor"
        pre=$pre_n 
        othr=$pre_y 
    fi

    if ! test -z "$condition" && eval "${condition}"; then
        test "$prmptn" == "${underline_on}n${underline_off}o" && prmptn="${underline_on}N${underline_off}o"  
        test "$prmpty" == "${underline_on}Y${underline_off}es" && prmpty="${underline_on}y${underline_off}es"  
        prmpt1=" [$prmptn/$prmpty]: "
        color="$ncolor"
        pre=$pre_n 
        othr=$pre_y 
    fi

    if ! test -z $auto; then
        if test -z "$prmpt"; then
            printf "${!color}$prmpt1$pre${normal}\n";   
        else
            printf "${!color}$prmpt$prmpt1$pre${normal}\n";   
        fi
        value=$pre 
    else
        if test -z "$prmpt"; then
            reade -Q "$color" $breaklines -i "$pre $othr" -p "$prmpt1" value;   
        else
            reade -Q "$color" $breaklines -i "$pre $othr" -p "$prmpt$prmpt1" value;    
        fi
         
    fi 

    export READE_VALUE="$value" 
    export REPLY="$value" 

    if ! test $# -eq 0; then
        eval "${@:$#:1}=$value" 
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
        
        reade $clr -i "$pre $choices" -p "$prompt" pass;
        
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
            deflt=" [N/y]: "
            pre="n"
            prompt="$3$deflt";
            reade $clr -i "$pre y" -p "$prompt" pass2;
            if [ "$pass2" == "y" ]; then
                $1;
            fi
        fi
    fi
}

