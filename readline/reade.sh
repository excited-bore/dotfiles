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
    rlwstring="rlwrap -f <(echo \"${args[@]}\") -o cat"
    while getopts ':a:b:e:p:Q:' flag; do
        case "${flag}" in
            a)  rlwstring=$(echo $rlwstring | sed "s/rlwrap /rlwrap \-aN "${OPTARG}" /g");
                ;;
            b)  breaklines=${OPTARG};
                ;;
            c)  rlwstring=$(echo $rlwstring | sed "s/rlwrap /rlwrap \-c /g");
                ;;
            e)  rlwstring=$(echo $rlwstring | sed "s/rlwrap /rlwrap \-e "${OPTARG}" /g");
                ;;
            p)  rlwstring=$(echo $rlwstring | sed "s/rlwrap /rlwrap \-S "${OPTARG}" /g");
                ;;
            Q)  rlwstring=$(echo $rlwstring | sed "s/rlwrap /rlwrap \-p "${OPTARG}" /g");
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
