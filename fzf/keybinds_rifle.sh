fzf_rifle(){
    file="$(fzf -m --height 75% --reverse)";
    if [ -z "$file" ]; then
        return 0;
    else
        lines="$(echo "$file" | wc -l)";
        if [ "$lines" == 1 ]; then
            if [ -d "$file" ]; then
                result=$(printf "0:change directory \n1:Use rifle" | fzf --height 30% --reverse) 
                if [ "${result::1}" == "0" ]; then
                    cd "$file";
                    return 0;
                fi
            else
                result=$(rifle -l "$file" | fzf --height 50% --reverse);
                rifle -p "${result::1}" "$file";
                return 0;
            fi
        else
            IFS=$'\n' read -d "\034" -r -a files <<<"${file}\034";
            result=$(rifle -l "$files" | fzf --height 50% --reverse);
            rifle -p "${result::1}" "${files[@]}"
            return 0;
        fi    
    fi
}
