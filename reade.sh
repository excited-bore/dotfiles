# Argument first, then completions
reade(){
     while getopts ':p:' flag; do
        case "${flag}" in
            p)  args=${@:3}
                rlwrap -S "${OPTARG}" -b '' -f <(echo "${args[@]}") -o cat
                exit 1 
                ;;
        esac
    done
    args="$@"
    rlwrap -b '' -f <(echo "${args[@]}") -o cat
}

#reade -p "Bluh" $(sudo lsusb | awk 'BEGIN { FS = ":" };{print $1;}') 
