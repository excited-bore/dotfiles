# Arguments: Completions(string with space entries, AWK works too),return value(, -p prompt flag)
reade(){
     while getopts ':p:' flag; do
        case "${flag}" in
            p)  args="${@:3}"
                value=$(rlwrap -S "$2" -b '' -f <(echo "${args[@]}") -o cat)
                echo ${@:4}
                eval ${@:4}="$value" 
                ;;
        esac
    done
    if [ $OPTIND -eq 1 ]; then
        args="$@"
        value=$(rlwrap -b '' -f <(echo "${args[@]}") -o cat)
        eval ${@:2}="$value"
    fi
    
}

#reade -p "Usb ids" $(sudo lsusb | awk 'BEGIN { FS = ":" };{print $1;}') 
