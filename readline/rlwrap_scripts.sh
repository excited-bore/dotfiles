# Arguments: Completions(string with space entries, AWK works too),return value(-a password prompt, -c complete filenames, -p prompt flag, -Q prompt colour, -b break-chars (when does a string break for autocomp), -e change char given for multiple autocompletions)
# 'man rlwrap' to see all unimplemented options

reade(){
    if [[ $# < 2 ]]; then
        echo "Give up at least two variables for reade(). "
        echo "First a string with autocompletions, space seperated"
        echo "Second a variable (could be empty) for the return string"
        return 0
    fi
    
    args="${@:$#-1:1}"
    breaklines=''
    rlwstring="rlwrap -b \"$breaklines\" -f <(echo \"${args[@]}\") -o cat"
    while getopts ':a:b:e:p:P:Q:' flag; do
        case "${flag}" in
            a)  rlwstring=$(echo $rlwstring | sed "s|rlwrap |rlwrap \-aN\"${OPTARG}\" |g");
                ;;
            b)  breaklines=${OPTARG};
                ;;
            c)  rlwstring=$(echo $rlwstring | sed "s|rlwrap |rlwrap \-c |g");
                ;;
            e)  rlwstring=$(echo $rlwstring | sed "s|rlwrap |rlwrap \-e \"${OPTARG}\" |g");
                ;;
            p)  rlwstring=$(echo $rlwstring | sed "s|rlwrap |rlwrap \-S \"${OPTARG}\" |g");
                ;;
            P)  rlwstring=$(echo $rlwstring | sed "s|rlwrap |rlwrap \-P \"${OPTARG}\" |g");
                ;;
            Q)  rlwstring=$(echo $rlwstring | sed "s|rlwrap |rlwrap \-p${OPTARG} |g");
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
        reade $clr -P "$pre" -p "$prompt" " y e n" pass;
        if [ "$pass" == "y" ]; then
           $1; 
        elif [ "$pass" == "e" ]; then
            str=($2);
            for i in "${str[@]}"; do
                $EDITOR $i;
            done;
            deflt=" [y/n]: "
            prompt="$3$deflt";
            reade $clr -p "$prompt" "y n" pass2;
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
        reade $clr -P "$pre" -p "$prompt" " y e n" pass;
        if [ "$pass" == "y" ]; then
           $1; 
        fi
    fi
}
