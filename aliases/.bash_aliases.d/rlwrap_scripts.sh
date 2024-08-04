# https://stackoverflow.com/questions/5412761/using-colors-with-printf
# Execute (during printf) for colored prompt
# printf  "${blue}This text is blue${white}\n"
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
normal=$(tput sgr0)
#...

# Arguments: Completions(string with space entries, AWK works too),return value(-a password prompt, -c complete filenames, -p prompt flag, -Q prompt colour, -b break-chars (when does a string break for autocomp), -e change char given for multiple autocompletions)
# 'man rlwrap' to see all unimplemented options

if test -z $TMPDIR; then
    TMPDIR=$(mktemp -d)
fi

reade(){
    if [ ! -x "$(command -v rlwrap)" ]; then 
        readstr="read  ";
        color=""
        while getopts ':b:e:i:p:Q:s:S:' flag; do
            case "${flag}" in
                b)  ;;
                e)  readstr=$(echo "$readstr" | sed "s|read |read \-e |g");
                    ;;
                #  Even though it's in the read man, -i does not actually work
                i)  readstr=$(echo "$readstr" | sed "s|read |read \-i \"${OPTARG}\" |g");
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
                p)  readstr=$(echo "$readstr" | sed "s|read |read \-p \"${color}${OPTARG}${normal}\" |g");
                    ;;
                s)  readstr=$(echo "$readstr" | sed "s|read |read \-s\"${OPTARG}\" |g");
                    ;;
                S)  ;;
            esac
        done; 
        OPTIND=1;
        #  Even though it's in the read man, -i does not actually work
        eval "$readstr" value;
        if ! test -z "$pre" && test -z "$value"; then
            value="$pre"  
        fi
        #black, red, green, yellow, blue, cyan, purple (=magenta) or white
        eval "${@:$#:1}=$value";
    else
        if [[ $# < 2 ]]; then
            echo "Give up at least two variables for reade(). "
            echo "First a string with autocompletions, space seperated"
            echo "Second a variable (could be empty) for the return string"
            return 0
        fi
        
        local args="${@:$#-1:1}"
        # Reverse wordlist order (last -> first) because ???
        args=$(echo $args | awk '{ for (i=NF; i>1; i--) printf("%s ",$i); print $1; }')
        args=$(echo $args | tr ' ' '\n')
        echo "$args" > "$TMPDIR/rlwrap"
        if test "$args" == ''; then
            rlwstring="rlwrap -D 0 -b \"$breaklines\" -o cat"
        else
            rlwstring="rlwrap -D 0 -H $TMPDIR/rlwrap -b \"$breaklines\" -f <(echo \"${args[@]}\") -o cat"
        fi
        breaklines=''
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
        done
        OPTIND=1
        value=$(eval $rlwstring);
        eval "${@:$#:1}=$value";
    fi
}

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

function yes_no(){
    if [ -z "$1" ] || [ -z "$2" ]; then
        printf "Needs 3 parameters.\n 1) String with commands if yes\n 2) prompt (adds [y/n]: afterwards) \n(3) Default \"yes\",\"no\")\n(4) Optional - Colour)\n";
        return 0;
    else
        pass="";
        clr="";
        pre="y"
        deflt=" [Y/n]: "; 
        prompt="$2$deflt";
        if [ "$3" == "no" ]; then
            pre="n"
            deflt=" [y/N]: ";
        fi
        if [ ! -z "$4" ]; then
            clr="-Q $4"
        fi
        reade $clr -i "$pre" -p "$prompt" " y e n" pass;
        
        #Undercase only
        pass=$(echo "$pass" | tr '[:upper:]' '[:lower:]')
        
        if [ "$pass" == "y" ]; then
           $1; 
        fi
    fi
} 
