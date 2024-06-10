# https://stackoverflow.com/questions/5412761/using-colors-with-printf
# Execute (during printf) for colored prompt
# printf  "${blue}This text is blue${white}\n"
red=$(tput setaf 9)
red1=$(tput setaf 1)
green=$(tput setaf 10)
green1=$(tput setaf 2)
yellow=$(tput setaf 11)
yellow1=$(tput setaf 3)
blue=$(tput setaf 12)
blue1=$(tput setaf 4)
magenta=$(tput setaf 13)
magenta1=$(tput setaf 5)
cyan=$(tput setaf 14)
cyan1=$(tput setaf 6)
white=$(tput setaf 15)
white1=$(tput setaf 7)
black=$(tput setaf 16)
grey=$(tput setaf 8)
bold=$(tput bold)
normal=$(tput sgr0)
#...

# Arguments: Completions(string with space entries, AWK works too),return value(-a password prompt, -c complete filenames, -p prompt flag, -Q prompt colour, -b break-chars (when does a string break for autocomp), -e change char given for multiple autocompletions)
# 'man rlwrap' to see all unimplemented options

if test -z $TMPDIR; then
    TMPDIR=$(mktemp -d)
fi

reade(){
    stty sane
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
        #  Even though it's in the read man, -i does not actually work
        eval "$readstr" value;
        if ! test -z "$pre" && test -z "$value"; then
            value="$pre"  
        fi
        #black, red, green, yellow, blue, cyan, purple (=magenta) or white
        eval "${@:$#:1}=$value";
        OPTIND=1;
    else
        if [[ $# < 2 ]]; then
            echo "Give up at least two variables for reade(). "
            echo "First a string with autocompletions, space seperated"
            echo "Second a variable (could be empty) for the return string"
            return 0
        fi
        
        local args="${@:$#-1:1}"
        args=$(echo $args | tr ' ' '\n')
        echo "$args" > "$TMPDIR/rlwrap"
        breaklines=''
        rlwstring="rlwrap -D 0 -H $TMPDIR/rlwrap -b \"$breaklines\" -f <(echo \"${args[@]}\") -o cat"
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
        
        value=$(eval "$rlwstring");
        eval "${@:$#:1}=$value";
        #if [ $OPTIND -eq 1 ]; then
        #    value=$(rlwrap -b '' -f <(echo "${args[@]}") -o cat);
        #    eval "${@:2}=$value";
        #fi
        OPTIND=1
    fi
    stty sane
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
        deflt=" [Y/e/n]: "; 
        prompt="$3$deflt";
        if [ "$4" == "edit" ]; then
            pre="e"
            deflt=" [y/E/n]: ";
            prompt="$3$deflt";
        elif [ "$4" == "no" ]; then
            pre="n"
            deflt=" [y/e/N]: ";
            prompt="$3$deflt";
        fi
        if [ ! -z "$5" ]; then
            clr="-Q $5"
        fi
        
        reade $clr -i "$pre" -p "$prompt" " y e n" pass;
        
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
