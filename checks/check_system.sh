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
# printf "${CYAN}bluh"; read -e -r foo  is also problematic because prompt disappears when arrow up and back down

#function reade(){
#
#    local VERSION='1.0' 
#
#    unset READE_VALUE
#
#    while :; do
#        case $1 in
#            -h|-\?|--help)
#            printf "${bold}reade${normal} [ -h/--help ] [ -v/--version] [ -i/--pregiven PREGIVEN ] [ -e/--file-completion ]  [ -s/--no-echo ] [ -p/--prompt PROMPTSTRING ] [ -Q/--colour COLOURSTRING ] [ -b/--break-chars BREAKCHARS-STRING ] ${bold}CHOICES-STRING${normal}  ${bold}returnvar${normal}\n
#   Simplifies prompt for ${bold}read/rlwrap${normal}: Will use 'rlwrap' if it is installed, otherwise resorts to 'read' 
#   Supply at least 2 variables: 
#   - A space seperated string with the choices for answer. ${bold}If no choices need to be given, supply a empty string '' - WILL NOT WORK WITHOUT EMPTY STRING. ${normal}
#   - The last argument to put the answer in, otherwise the value will be in '\$READE_VALUE'.  
#
#   -h, --help  
#        
#        Print this text and exit
#
#   -v, --version  
#        
#        Print version and exit
#
#   -Q ${underline_on}Colour${underline_off}
#
#        Use  one  of  the  colour names black, red, green, yellow, blue, cyan, purple (=magenta) or white, or an ANSI-conformant <colour_spec> to colour any prompt displayed  by  command.\n An uppercase colour name (Yellow or YELLOW ) gives a bold prompt.\n Prompts that already contain (colour) escape sequences or one of the readline \"ignore markers\" (ASCII 0x01 and 0x02) are not coloured.
#
#   -i, --pre-given ${underline_on}pregiven string${underline_off} 
#
#        Autofill prompt with 'PREGIVEN' - must come in the form of a string (only works when rlwrap is installed) 
#
#   -s, --no-echo 
#
#        Doesn't echo what's being typed to the terminal - usefull for password prompts and the like
#
#   -e, --file-completion 
#
#        Use filecompletions. 
#        Will stop using rlwrap if it is installed because 'rlwrap' doesn't properly add slashed before spaces in filenames/directorynames and will use 'read -e' which does properly do this instead
#    
#   -b ${underline_on}list_of_characters${underline_off} 
#
#       (From rlwrap manual) Consider  the specified characters word-breaking (whitespace is always word-breaking). This determines what is considered a \"word\", both when completing and when building a completion word list from files specified by -f options following (not preceding!) it.\n Default list (){}[],'+-=&^%%\$#@\";|\ \n Unless -c is specified, / and . (period) are included in the default list\n\n" 
#              return 0
#          ;;
#          -v|--version) 
#             printf "${bold}Version${normal} : $VERSION\n"
#             return 0
#          ;; 
#          # Otherwise 
#          *) break 
#          ;;
#       esac
#    done && OPTIND=1;
#
#    #https://stackoverflow.com/questions/12022592/how-can-i-use-long-options-with-the-bash-getopts-builtin
#
#    for arg in "$@"; do
#      shift
#      case "$arg" in
#        '--break-chars')       set -- "$@" '-b'   ;;
#        '--colour')            set -- "$@" '-Q'   ;;
#        '--prompt')            set -- "$@" '-p'   ;;
#        '--file-completions')  set -- "$@" '-e'   ;;
#        '--pre-given')         set -- "$@" '-i'   ;;
#        '--no-echo')           set -- "$@" '-s'   ;;
#        *)                     set -- "$@" "$arg" ;;
#      esac
#    done 
#    
#
#    while getopts ':b:e:i:p:Q:s:S:' flag; do
#        case "${flag}" in
#            e)  fcomp='y'
#                break 
#                ;;
#
#            *)  fcomp='n'
#                break 
#                ;;
#        esac
#    done && OPTIND=1;
#    bash_rlwrap='y'
#    if [[ $(uname -s) =~ 'MINGW' ]] && ! type pacman &> /dev/null; then
#        bash_rlwrap='n'
#    fi
#    if ! type rlwrap &> /dev/null || test "$fcomp" == 'y' || test $bash_rlwrap == 'n' ; then
#        readstr="read  ";
#        color=""
#        while getopts ':b:e:i:p:Q:s:S:' flag; do
#            case "${flag}" in
#                b)  ;;
#                e)  readstr=$(echo "$readstr" | sed 's|read |read -e -r |g');
#                    ;;
#                    #  Even though it's in the read man, -i does not actually work
#                    i)  readstr=$(echo "$readstr" | sed 's|read |read -i "'"${OPTARG}"'" |g');
#                    pre="${OPTARG}"
#                    ;;
#                Q)  if [[ "${OPTARG}" =~ ^[[:upper:]]+$ ]]; then
#                        color="${bold}"
#                    fi
#                    OPTARG=$(echo ${OPTARG} | awk '{print tolower($0)}')
#                    if [[ "${OPTARG}" =~ "red" ]]; then
#                        color=$color"${red}"
#                    elif [[ "${OPTARG}" =~ "green" ]]; then
#                        color=$color"${green}"
#                    elif [[ "${OPTARG}" =~ "blue" ]]; then
#                        color=$color"${blue}"
#                    elif [[ "${OPTARG}" =~ "yellow" ]]; then
#                        color=$color"${yellow}"
#                    elif [[ "${OPTARG}" =~ "cyan" ]]; then
#                        color=$color"${cyan}"
#                    elif [[ "${OPTARG}" =~ "magenta" ]]; then
#                        color=$color"${magenta}"
#                    elif [[ "${OPTARG}" =~ "black" ]]; then
#                        color=$color"${black}"
#                    elif [[ "${OPTARG}" =~ "white" ]]; then
#                        color=$color"${white}"
#                    fi
#                    ;;
#                p)  readstr=$(echo "$readstr" | sed 's|read |printf "'"${color}${OPTARG}${normal}"'\n"; read |g');
#                    ;;
#                s)  readstr=$(echo "$readstr" | sed 's|read |read -s "'"${OPTARG}"'" |g');
#                    ;;
#                S)  ;;
#            esac
#         done && OPTIND=1;
#
#        eval "$readstr" value;
#
#        if test $fcomp == 'y'; then
#            echo $value >> ~/.bash_history
#            history -n
#        fi
#
#        if ! test -z "$pre" && test -z "$value" || test "$value" == ""; then
#            value="$pre"  
#        fi
#
#        #black, red, green, yellow, blue, cyan, purple (=magenta) or white
#        if ! test -z "${@:$#:1}" && ! test "${@:$#:1}" == '/bin/bash' && ! [[ "${@:$#:1}" =~ -.* ]]; then
#            eval "${@:$#:1}=$value"  
#        else
#            export READE_VALUE="$value"
#        fi
#        unset fcomp
#    else
#        if [[ $# < 2 ]]; then
#            echo "$@" 
#            echo "Give up at least two variables for reade(). "
#            echo "First a string with autocompletions, space seperated"
#            echo "Second a variable (could be empty) for the return string"
#            return 0
#        fi
#
#
#        local args="${@:$#-1:1}"
#
#        # Reverse wordlist order (last -> first) because ???
#        args=$(echo $args | awk '{ for (i=NF; i>1; i--) printf("%s ",$i); print $1; }')
#        args=$(echo $args | tr ' ' '\n')
#        tmpf=$(mktemp)
#
#        echo "$args" > "$tmpf"
#
#        local breaklines=''
#
#        if test "$args" == ''; then
#            rlwstring="rlwrap --ansi-colour-aware -s 1000 -D 0 -b \"$breaklines\" -o cat"
#        else
#            rlwstring="rlwrap --ansi-colour-aware -s 1000 -D 0 -H $tmpf -b \"$breaklines\" -f <(echo \"${args[@]}\") -o cat"
#        fi
#
#        while getopts ':b:e:i:p:Q:s:S:' flag; do
#            case "${flag}" in
#                b)  breaklines=${OPTARG};
#                    ;;
#                    # File completions
#                    e)  rlwstring=$(echo $rlwstring | sed "s| -f <(echo \"${args[@]}\") | |g");
#                    rlwstring=$(echo $rlwstring | sed "s|rlwrap |rlwrap \-c |g");
#                    ;;
#                    # Pre-filled answer
#                    i)  rlwstring=$(echo $rlwstring | sed "s|rlwrap |rlwrap \-P \"${OPTARG}\" |g");
#                    ;;
#                    # Prompt
#                    p)  rlwstring=$(echo $rlwstring | sed "s|rlwrap |rlwrap \-S \"${OPTARG}\" |g");
#                    ;;
#                    # Prompt colours
#                    Q)  rlwstring=$(echo $rlwstring | sed "s|rlwrap |rlwrap \-p${OPTARG} |g");
#                    ;;
#                    # Password
#                    s)  rlwstring=$(echo $rlwstring | sed "s|rlwrap |rlwrap \-aN\"${OPTARG}\" |g");
#                    ;;
#                    # Always echo *** w/ passwords
#                    S)  rlwstring=$(echo $rlwstring | sed "s|rlwrap |rlwrap \-E\"${OPTARG}\" |g");
#                    ;;
#            esac
#        done && OPTIND=1;
#
#        value=$(eval $rlwstring);
#
#        if ! test -z "${@:$#:1}" && ! test "${@:$#:1}" == '/bin/bash' && ! [[ "${@:$#:1}" =~ -.* ]]; then
#            eval "${@:$#:1}=$value"  
#        else
#            export READE_VALUE="$value" 
#        fi
#        command rm $tmpf &> /dev/null;
#    fi
#    unset bash_rlwrap 
#}
#
#
#function readyn(){
#
#    unset READYN_VALUE
#
#    local VERSION='1.0' 
#
#    while :; do
#        case $1 in
#            -h|-\?|--help)
#                printf "${bold}readyn${normal} [ -h/--help ] [ -v/--version ]  [ -y/--yes [ PREFILL ] ]  [ -n/--no [ CONDITION ] ] [ -p/--prompt PROMPTSTRING ] [ -Q/--colour COLOURSTRING ]  [ -b/--break-chars BREAK-CHARS ] [ returnvar ]\n
#               Simplifies yes/no prompt for ${bold}reade${normal}. Supply at least 1 variable as the last argument to put the answer in, otherwise the value will be in '\$READYN_VALUE'.  
#'${GREEN} [${underline_on}Y${underline_off}es/${underline_on}n${underline_off}o]: ${normal}' : 'y' as pre-given, 'n' as other option. Colour for the prompt is ${GREEN}GREEN (Default)${normal} 
#'${YELLOW} [${underline_on}N${underline_off}o/${underline_on}y${underline_off}es]: ${normal}' : 'n' as pre-given, 'y' as other option. Colour for the prompt is ${YELLOW}YELLOW${normal}
#    For both an empty answer will return the default answer. 
#
#    -h, --help  
#        
#        Print this text and exit
#     
#   -y, --yes ${underline_on}prefill${underline_off} 
#
#        Autofill prompt with 'y' if nothing is supplied, otherwise prefill with given 
#
#   -n, --no ${underline_on}condition${underline_off}
#
#       Set '${YELLOW} [${underline_on}N${underline_off}o/${underline_on}y${underline_off}es]: ${normal}' as the default prompt. Give a condition for when to prompt with 'no'. 
#    
#   -Q ${underline_on}Colour${underline_off}
#
#        Use  one  of  the  colour names black, red, green, yellow, blue, cyan, purple (=magenta) or white, or an ANSI-conformant <colour_spec> to colour any prompt displayed  by  command.\n An uppercase colour name (Yellow or YELLOW ) gives a bold prompt.\n Prompts that already contain (colour) escape sequences or one of the readline \"ignore markers\" (ASCII 0x01 and 0x02) are not coloured.
#    
#    -b ${underline_on}list_of_characters${underline_off} 
#
#        (From rlwrap manual) Consider  the specified characters word-breaking (whitespace is always word-breaking). This determines what is considered a \"word\", both when completing and when building a completion word list from files specified by -f options following (not preceding!) it.\n Default list (){}[],'+-=&^%%\$#@\";|\ \n Unless -c is specified, / and . (period) are included in the default list\n\n"
#              return 0
#          ;;
#          -v|--version) 
#             printf "${bold}Version${normal} : $VERSION\n"
#             return 0
#          ;; 
#
#          # Otherwise 
#          *) break 
#          ;;
#       esac
#    done && OPTIND=1;
#    
#
#    #https://stackoverflow.com/questions/12022592/how-can-i-use-long-options-with-the-bash-getopts-builtin
#
#    for arg in "$@"; do
#      shift
#      case "$arg" in
#        '--break-chars')       set -- "$@" '-b'   ;;
#        '--colour')            set -- "$@" '-Q'   ;;
#        '--prompt')            set -- "$@" '-p'   ;;
#        '--no')                set -- "$@" '-n'   ;;
#        '--yes')               set -- "$@" '-y'   ;;
#        *)                     set -- "$@" "$arg" ;;
#      esac
#    done 
#
#    local breaklines=''
#    local nocase='' 
#    local pre='' 
#    local preff='' 
#    local color='' 
#    OPTIND=1
#    while getopts ':b:Q:p:y:yn:n' flag; do
#        case "${flag}" in
#             b)  breaklines="-b \"${OPTARG}\"";
#             ;;    
#             Q)  color="${OPTARG}";
#             ;;    
#             p)  prmpt=${OPTARG};
#             ;;
#             y) if [ "${OPTARG}" ] && ! test "${OPTARG}" == '--' && ! [[ ${OPTARG} =~ -.* ]] && ! test "${OPTARG}" == "${@:$#:1}"; then
#                    preff=${OPTARG};
#                else
#                    preff='y'
#                    if [[ ${OPTARG} =~ -.* ]]; then
#                        OPTIND=$(($OPTIND - 1)) 
#                    fi
#                fi
#             ;;
#             n) if [ "${OPTARG}" ] && ! test "${OPTARG}" == '--' && ! [[ ${OPTARG} =~ ^-.* ]] && ! test "${OPTARG}" == "${@:$#:1}"; then
#                    nocase="${OPTARG}"
#                fi 
#                if [[ ${OPTARG} =~ ^-.* ]]; then
#                    OPTIND=$(($OPTIND - 1)) 
#                fi
#                if ! test -z "$nocase" && eval "$nocase" || test -z "$nocase" ; then
#                    pre='n'
#                    othr='y'
#                    prmpt1=" [${underline_on}N${underline_off}o/${underline_on}y${underline_off}es]: "
#                    test -z $color && color='YELLOW'
#                fi
#             ;;
#        esac
#    done && OPTIND=1;
#    if test -z $pre; then 
#        pre='y'
#        othr='n'
#        prmpt1=" [${underline_on}Y${underline_off}es/${underline_on}n${underline_off}o]: "
#        test -z $color && color='GREEN'
#    fi
#
#    if ! test -z $preff; then
#        if test -z "$prmpt"; then
#            printf "${!color}$prmpt1$preff${normal}\n" ;   
#        else
#            printf "${!color}$prmpt$prmpt1$preff${normal}\n" ;   
#        fi
#        value=$preff 
#    else
#        if ! test -z "$prmpt"; then
#            reade -Q "$color" $breaklines -i "$pre" -p "$prmpt$prmpt1" "$othr" value;   
#        else
#            reade -Q "$color" $breaklines -i "$pre" -p "$prmpt1" "$othr" value;    
#        fi
#
#    fi 
#
#    if ! test -z "${@:$#:1}" && ! test "${@:$#:1}" == '/bin/bash' && ! [[ "${@:$#:1}" =~ -.* ]]; then
#        eval "${@:$#:1}=$value" 
#    else
#        export READYN_VALUE="$value" 
#    fi
#
#    unset pre other prmpt prmpt1 color readestr breaklines value 
#}
#
#alias yes_no='readyn'
#alias yes-no='readyn'
#
#
##reade -p "Usb ids" $(sudo lsusb | awk 'BEGIN { FS = ":" };{print $1;}')
#
#function yes_edit_no(){
#    if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
#        printf "Needs 3 parameters.\n 1) Function with commands if yes\n 2) File to edit\n 3) prompt (adds [y/n/e]: afterwards) \n (4) Default \"yes\",\"edit\",\"no\")\n (5) Optional - Colour)\n";
#        return 0;
#    else
#        pass="";
#        clr="";
#        pre="y"
#        choices="e n"
#        deflt=" [Y/e/n]: "; 
#        prompt="$3$deflt";
#        if [ "$4" == "edit" ]; then
#            pre="e"
#            choices="y n"
#            deflt=" [y/E/n]: ";
#            prompt="$3$deflt";
#        elif [ "$4" == "no" ]; then
#            pre="n"
#            choices="y e"
#            deflt=" [y/e/N]: ";
#            prompt="$3$deflt";
#        fi
#        if [ ! -z "$5" ]; then
#            clr="-Q $5"
#        fi
#        
#        reade $clr -i "$pre" -p "$prompt" "$choices" pass;
#        
#        #Undercase only
#        pass=$(echo "$pass" | tr '[:upper:]' '[:lower:]')
#
#        if [ -z "$pass" ]; then
#            pass="$pre";
#        fi
#        
#        if [ "$pass" == "y" ]; then
#           $1; 
#        elif [ "$pass" == "e" ]; then
#            str=($2);
#            for i in "${str[@]}"; do
#                "$EDITOR" "$i";
#            done;
#            deflt=" [y/N]: "
#            pre="n"
#            prompt="$3$deflt";
#            reade $clr -i "$pre" -p "$prompt" "y n" pass2;
#            if [ "$pass2" == "y" ]; then
#                $1;
#            fi
#        fi
#    fi
#}


unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Windows
                win_bash_shell=Cygwin;;
    MINGW*)     machine=Windows
                win_bash_shell=Git;;
    *)          machine="UNKNOWN:${unameOut}";;
esac

if test -z $TMPDIR; then
    TMPDIR=$(mktemp -d)
fi

pthdos2unix=""
if test $machine == 'Windows'; then 
    alias wget='wget.exe' 
    alias curl='curl.exe' 
   # https://stackoverflow.com/questions/13701218/windows-path-to-posix-path-conversion-in-bash 
   pthdos2unix="| sed 's/\\\/\\//g' | sed 's/://' | sed 's/^/\\//g'"
   wmic=$(wmic os get OSArchitecture | awk 'NR>1 {print}')
   if [[ $wmic =~ '64' ]]; then
       export ARCH_WIN='64'
   else
       export ARCH_WIN='32'
   fi
   if ! type winget &> /dev/null; then
       #win_ver=$(cmd /c ver)
       printf "${RED}Winget (official window package manager) not installed - can't run scripts without install programs through it${normal}\n" 
       readyn -p "(Attempt to) Install winget? ${CYAN}(Windows 10 - version 1809 required at mimimum for winget)${GREEN}" wngt
       if test "$wngt" == 'y'; then
        tmpd=$(mktemp -d)
        wget -P $tmpd https://raw.githubusercontent.com/asheroto/winget-install/master/winget-install.ps1  
        sudo pwsh $tmpd/winget-install.ps1
       else
            printf "${RED}Can't install scripts without winget${normal}\n" 
            #exit 1 
       fi
   fi
   if ! type sudo &> /dev/null; then
       printf "${RED}Sudo (Commandline tool to install/modify files at higher privilige, as root/admin) not installed - most of the script won't run without without${normal}\n" 
       reade -Q 'GREEN' -i 'y' -p 'Install (g)sudo (unofficial sudo)? [Y/n]: ' 'n' gsdn
       if test $gsdn == 'y'; then
            ./../install_gsudo.sh
       #else
           #exit 1
       fi
   fi
   if ! type jq &> /dev/null; then
       reade -Q 'GREEN' -i 'y' -p 'Install jq? (Json parser - used in scripts to get latest releases from github) [Y/n]: ' 'n' jqin 
       if test $jqin == 'y'; then
            winget install jqlang.jq
       fi
   fi
   unset wngt wmic gsdn jqin
fi


if test -z $EDITOR; then
    if type nano &> /dev/null; then
        EDITOR=nano
    elif type vi &> /dev/null; then
        EDITOR=vi
    else
        EDITOR=edit
    fi
fi

if type whereis &> /dev/null; then
    function where_cmd() { 
        eval "whereis $1 $pthdos2unix" | awk '{print $2;}'; 
    } 
elif type where &> /dev/null; then
    function where_cmd() { 
        eval "where $1 $pthdos2unix"; 
    } 
else
    printf "Can't find a 'where' command (whereis/where)\n"
    #exit 1 
fi

# https://unix.stackexchange.com/questions/202891/how-to-know-whether-wayland-or-x11-is-being-used
export X11_WAY="$(loginctl show-session $(loginctl | grep $(whoami) | awk 'NR=1{print $1}') -p Type | awk -F= 'NR==1{print $2}')"



no_aur=''

distro_base=/
distro=/
packagemanager=/
arch=/
declare -A osInfo;
osInfo[/etc/alpine-release]=apk
osInfo[/etc/arch-release]=pacman
osInfo[/etc/fedora-release]=dnf
osInfo[/etc/debian_version]=apt
osInfo[/etc/gentoo-release]=emerge
osInfo[/etc/manjaro-release]=pamac
osInfo[/etc/redhat-release]=yum
osInfo[/etc/rpi-issue]=apt
osInfo[/etc/SuSE-release]=zypp
osInfo[/etc/SUSE-brand]=zypp

for f in ${!osInfo[@]};
do
    if [ -f $f ] && [ $f == /etc/alpine-release ] && [ $distro == / ]; then
        pac="apk"
        distro_base="BSD"
        distro="Alpine"
    elif [ -f $f ] && [ $f == /etc/manjaro-release ] && [ $distro == / ]; then
        pac="pacman"
        pac_up="sudo pacman -Su"
        pac_ins="sudo pacman -S"
        pac_search="sudo pacman -Ss"
        pac_rm="sudo pacman -R"
        pac_rm_casc="sudo pacman -Rc"
        pac_rm_orph="sudo pacman -Rs"
        pac_clean_cache="sudo pacman -Scc"
        pac_ls_ins="pacman -Q"
         
        AUR_pac="pamac"
        AUR_up="pamac update"
        AUR_ins="pamac install"
        AUR_search="pamac search"
        AUR_rm="pamac remove" 
        AUR_rm_casc="pamac remove --cascade" 
        AUR_rm_orph="pamac remove --orphans"
        AUR_clean_cache="pamac clean"
        AUR_ls_ins="pamac list --installed"
         

        distro_base="Arch"
        distro="Manjaro"
          
    elif test -f /etc/issue && grep -q "Ubuntu" /etc/issue && [ $distro == / ]; then
        pac="apt"
        pac_up="sudo apt update"
        pac_ins="sudo apt install"
        pac_search="apt search"
        pac_ls_ins="apt list --installed" 

        distro_base="Debian"
        distro="Ubuntu"

        codename="$(lsb_release -a | grep --color=never 'Codename' | awk '{print $2}')"
        release="$(lsb_release -a | grep --color=never 'Release' | awk '{print $2;}')"

    elif test -f $f && [[ $f == /etc/SuSE-release || $f == /etc/SUSE-brand ]] && test $distro == /; then
        if ! test -z "$(lsb_release -a | grep Leap)"; then
            pac="zypper_leap"
        else
            pac="zypper_tumble"
        fi
        distro_base="Slackware"
        distro="openSUSE"
    elif [ -f $f ] && [ $f == /etc/gentoo-release ] && [ $distro == / ]; then
        pac="emerge"
        distro_base="Slackware"
        distro="Gentoo"
    elif [ -f $f ] && [ $f == /etc/fedora-release ] && [ $distro == / ]; then
        pac="dnf"
        distro_base="RedHat"
        distro="Fedora"
    elif [ -f $f ] && [ $f == /etc/redhat-release ] && [ $distro == / ]; then
        pac="yum"
        distro_base="RedHat"
        distro="Redhat"
    elif [ -f $f ] && [ $f == /etc/arch-release ] && [ $distro == / ]; then
           
        unset ansr ansr1 

        # Extra repositories check 
        if [[ $(grep 'extra' -A2 /etc/pacman.conf) =~ "#Include" ]]; then  
            readyn -p "Include 'extra' repositories for pacman?" ansr
            if test "$ansr" == 'y'; then
                sudo sed -i '/^\[extra\]$/,/^$/ { s|#Siglevel =|Siglevel =| }' /etc/pacman.conf 
                sudo sed -i '/^\[extra\]$/,/^$/ { s|#Include =|Include =| }' /etc/pacman.conf 
            fi
        fi

        # Multilib repositories check 
        if [[ $(grep 'multilib' -A2 /etc/pacman.conf) =~ "#Include" ]]; then  
            readyn -p "Include 'multilib' repositories for pacman?" ansr1
            if test "$ansr" == 'y'; then
                sudo sed -i '/^\[multilib\]$/,/^$/ { s|#Siglevel =|Siglevel =| }' /etc/pacman.conf 
                sudo sed -i '/^\[multilib\]$/,/^$/ { s|#Include =|Include =| }' /etc/pacman.conf 
            fi
        fi

        test "$ansr" == 'y' || test "$ansr1" == 'y' && sudo pacman -Syy 
        
        unset ansr ansr1 

        pac="pacman"
        pac_up="sudo pacman -Su"
        pac_ins="sudo pacman -S"
        pac_search="sudo pacman -Ss"
        pac_rm="pacman -R"
        pac_rm_casc="pacman -Rc"
        pac_rm_orph="pacman -Rs"
        pac_clean_cache="pacman -Scc"
        pac_ls_ins="pacman -Q" 

        
        #
        # PACMAN WRAPPERS
        # 
        
        # Check every package manager known by archwiki 
        #
        if type pamac &> /dev/null; then

            AUR_pac="pamac"
            AUR_up="pamac update"
            AUR_ins="pamac install"
            AUR_search="pamac search"
            AUR_rm="pamac remove" 
            AUR_rm_casc="pamac remove --cascade" 
            AUR_rm_orph="pamac remove --orphans"
            AUR_clean_cache="pamac clean"
            AUR_ls_ins="pamac list --installed"    
        elif type yay &> /dev/null; then

            AUR_pac="yay"
            AUR_up="yay -Syu"
            AUR_ins="yay -S"
            AUR_search="yay -Ss"
            AUR_rm="yay -R"
            AUR_rm_casc="yay -Rc"
            AUR_rm_orph="yay -Rs"
            AUR_clean="yay -Sc"
            AUR_clean_cache="yay -Scc"
            AUR_ls_ins="yay -Q" 
        elif type pikaur &> /dev/null; then

            AUR_pac="pikaur"
            AUR_up="pikaur -Syu"
            AUR_ins="pikaur -S"
            AUR_search="pikaur -Ss"
            AUR_rm="pikaur -R"
            AUR_rm_casc="pikaur -Rc"
            AUR_rm_orph="pikaur -Rs"
            AUR_clean="pikaur -Sc"
            AUR_clean_cache="pikaur -Scc"
            AUR_ls_ins="pikaur -Q"
        elif type pacaur &> /dev/null; then

            AUR_pac="pacaur"
            AUR_up="pacaur -Syu"
            AUR_ins="pacaur -S"
            AUR_search="pacaur -Ss"
            AUR_clean="pacaur -Sc"
            AUR_ls_ins="pacaur -Q"

        elif type aura &> /dev/null; then

            AUR_pac="aura"
            AUR_up="aura -Au"
            AUR_ins="aura -A"
            AUR_search="aura -Ss"
            AUR_ls_ins="aura -Q"
             
        elif type aurman &> /dev/null; then

            AUR_pac="aurman"
            AUR_up="aurman -Syu"
            AUR_ins="aurman -S"
            AUR_search="aurman -Ss"
            AUR_ls_ins="aurman -Q"

        elif type pakku &> /dev/null ; then

            AUR_pac="pakku"
            AUR_up="pakku -Syu"
            AUR_ins="pakku -S"
            AUR_search="pakku -Ss"
            AUR_ls_ins="pakku -Q"
             
        elif type paru &> /dev/null; then
            AUR_pac="paru"
            AUR_up="paru -Syua"
            AUR_ins="paru -S"
            AUR_search="paru -Ss"
            AUR_search="paru -Q"
             
        elif type trizen &> /dev/null; then
            AUR_pac="trizen"
            AUR_up="trizen -Syu"
            AUR_ins="trizen -S"
            AUR_search="trizen -Ss"
            AUR_ls_ins="trizen -Q"

        #
        # SEARCH AND BUILD
        # 
        
        # Aurutils
        elif type aur &> /dev/null; then
            AUR_pac="aur"
            AUR_up=""
            AUR_ins=""
            AUR_search="aur search"
             
        #elif type repoctl &> /dev/null; then
        #    pac_AUR="repoctl"
        #elif type yaah &> /dev/null; then
        #    pac_AUR="yaah"
        #elif type bauerbill &> /dev/null; then
        #    pac_AUR="bauerbill"
        #elif type PKGBUILDer &> /dev/null; then
        #    pac_AUR="PKGBUILDer"
        #elif type rua &> /dev/null; then
        #    pac_AUR="rua"
        #elif type pbget &> /dev/null; then
        #    pac_AUR="pbget"
        #elif type argon &> /dev/null ; then
        #    pac_AUR="argon"
        #elif type cylon &> /dev/null; then
        #    pac_AUR="cylon"
        #elif type kalu &> /dev/null; then
        #    pac_AUR="kalu"
        #elif type octopi &> /dev/null; then
        #    pac_AUR="octopi"
        #elif type PkgBrowser &> /dev/null; then
        #    pac_AUR="PkgBrowser"
        #elif type yup &> /dev/null ; then
        #    pac_AUR="yup"
        elif type auracle &> /dev/null; then

            AUR_pac="auracle"
            AUR_up="auracle update"
            AUR_ins=""
            AUR_search="auracle search"
             
        else
            no_aur='TRUE' 
        fi

        distro_base="Arch"
        distro="Arch"

    elif [ -f $f ] && [ $f == /etc/rpi-issue ] && [ $distro == / ];then

        pac="apt"
        pac_ins="sudo apt install"
        pac_up="sudo apt update"
        pac_upg="sudo apt upgrade"
        pac_search="apt search"
        pac_rm="sudo apt remove"
        pac_rm_orph="sudo apt purge"
        pac_clean="sudo apt autoremove"
        pac_clean_cache="sudo apt clean"
        pac_ls_ins="apt list --installed"
                     
        distro_base="Debian"
        distro="Raspbian"

    elif [ -f $f ] && [ $f == /etc/debian_version ] && [ $distro == / ];then
        pac="apt"
        pac_ins="sudo apt install"
        pac_up="sudo apt update"
        pac_upg="sudo apt upgrade"
        pac_search="apt search"
        pac_rm="sudo apt remove"
        pac_rm_orph="sudo apt purge"
        pac_clean="sudo apt autoremove"
        pac_clean_cache="sudo apt clean"
        pac_ls_ins="apt list --installed"
         
        distro_base="Debian"   
        distro="Debian"
    fi 
done
    


if ! type curl &> /dev/null && ! test -z "$pac_ins"; then
    ${pac_ins} curl
fi

if ! type jq &> /dev/null && ! test -z "$pac_ins"; then
    ${pac_ins} jq
fi


if type pamac &> /dev/null; then
    if ! test -f checks/check_pamac.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_pamac.sh)" 
    else
        . ./checks/check_pamac.sh
    fi
fi

if ! test -z "$no_aur"; then
    printf "Your Arch system seems to have no (known) AUR helper installed\n"
    readyn -Y 'CYAN' -p "Install yay ( AUR helper/wrapper )?" insyay
    if [ "y" == "$insyay" ]; then 

        if ! test -f ../AUR_insers/install_yay.sh; then 
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/AUR_insers/install_yay.sh)" 
        else
            eval ../AUR_insers/install_yay.sh
        fi

        AUR_pac="yay"
        AUR_up="yay -Syu"
        AUR_ins="yay -S"
        AUR_search="yay -Ss"
        AUR_rm="yay -R"
        AUR_rm_casc="yay -Rc"
        AUR_rm_orph="yay -Rs"
        AUR_clean="yay -Sc"
        AUR_clean_cache="yay -Scc"
        AUR_ls_ins="yay -Q" 
         
    fi
    unset insyay 
fi


if type nala &> /dev/null && test "$pac" == 'apt'; then
    pac="nala"
    pac_ins="sudo nala install"
    pac_up="sudo nala update"
    pac_upg="sudo nala upgrade"
    pac_search="nala search"
    pac_rm="sudo nala remove"
    pac_rm_orph="sudo nala purge"
    pac_clean="sudo nala autoremove"
    pac_clean_cache="sudo nala clean"
    pac_ls_ins="nala list --installed"
fi

# TODO: Change this to uname -sm?
if test $machine == 'Linux'; then
    arch_cmd="lscpu"
elif test $machine == 'Mac'; then
    arch_cmd="sysctl -n machdep.cpu.brand_string"
fi

if eval "$arch_cmd" | grep -q "Intel"; then
    arch="386"
elif eval "$arch_cmd" | grep -q "AMD"; then
    if lscpu | grep -q "x86_64"; then 
        arch="amd64"
    else
        arch="amd32"
    fi
elif eval "$arch_cmd" | grep -q "armv"; then
    arch="armv7l"
elif eval "$arch_cmd" | grep -q "aarch"; then
    arch="arm64"
fi

# VARS

export PROFILE=~/.profile

if ! [ -f ~/.profile ]; then
    touch ~/.profile
fi

if [ -f ~/.bash_profile ]; then
    export PROFILE=~/.bash_profile
fi

export ENVVAR=~/.bashrc

if [ -f ~/.environment.env ]; then
    export ENVVAR=~/.environment.env
fi

export ALIAS=~/.bashrc

if [ -f ~/.bash_aliases ]; then
    export ALIAS=~/.bash_aliases
fi

if [ -d ~/.bash_aliases.d/ ]; then
    export ALIAS_FILEDIR=~/.bash_aliases.d/
fi


export COMPLETION=~/.bashrc

if [ -f ~/.bash_completion ]; then
    export COMPLETION=~/.bash_completion
fi

if [ -d ~/.bash_completion.d/ ]; then
    export COMPLETION_FILEDIR=~/.bash_completion.d/
fi


export KEYBIND=~/.bashrc

if [ -f ~/.keybinds ]; then
    export KEYBIND=~/.keybinds
fi

if [ -d ~/.keybinds.d/ ]; then
    export KEYBIND_FILEDIR=~/.keybinds.d/
fi


if [ -f ~/.bash_profile ]; then
    export PROFILE=~/.bash_profile
fi


export PROFILE_R=/root/.profile
export ALIAS_R=/root/.bashrc
export COMPLETION_R=/root/.bashrc
export KEYBIND_R=/root/.bashrc
export ENVVAR_R=/root/.bashrc

#echo "This next $(tput setaf 1)sudo$(tput sgr0) checks for the profile, environment, bash_alias, bash_completion and keybind files and dirs in '/root/' to generate global variables.";

if ! sudo test -f /root/.profile; then
    sudo touch /root/.profile
fi

if sudo test -f /root/.bash_profile; then
    export PROFILE_R=/root/.bash_profile
fi

if sudo test -f /root/.environment.env; then
    export ENVVAR_R=/root/.environment.env
fi

if sudo test -f /root/.bash_aliases; then
    export ALIAS_R=/root/.bash_aliases
fi
if sudo test -d /root/.bash_aliases.d/; then
    export ALIAS_FILEDIR_R=/root/.bash_aliases.d/
fi

if sudo test -f /root/.bash_completion; then
    export COMPLETION_R=/root/.bash_completion
fi

if sudo test -d /root/.bash_completion.d/; then
    export COMPLETION_FILEDIR_R=/root/.bash_completion.d/
fi
if sudo test -f /root/.keybinds  ; then
    export KEYBIND_R=/root/.keybinds
fi
