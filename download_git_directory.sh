#/bin/bash

if ! type reade &> /dev/null; then
    eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh)"
else
    . ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
fi

if test -z $1; then
    reade -Q "GREEN" -p "Give up git directory url: " gitdir
else
    git_url=$1
fi

if test -z $2; then
    reade -Q "GREEN" -p "Target directory: " -e target_dir
else
    target_dir="$(realpath $2)"
fi

#function element_index() {
#    local my_array=("$@")
#    ((last_idx=${#my_array[@]} - 1))
#    local value=${my_array[last_idx]}
#    unset my_array[last_idx]
#    for i in "${!my_array[@]}"; do
#       if test "${my_array[$i]}" == "$value"; then
#           echo "${i}";
#       fi
#    done
#}

function pop_element() {
    local my_array=("$@")
    ((last_idx=${#my_array[@]} - 1))
    local value=${my_array[last_idx]}
    unset my_array[last_idx]
    #local index=$(element_index "${my_array[@]}" "${value}")
    set -- "${my_array[@]}"
    for i; do
        if test "$i" == "$value"; then
            continue
        fi  
        echo "$i"  
    done
}

function url_get_dirs() {
    for i in $(cat "$1" | grep -n --color=never 'dir' | awk '{print $1}' | cut -d: -f-1 ); do
        j=$(($((i))+2))
        b=$(cat "$1" | sed -n ''$j'p' | awk '{print $2}' | cut -d, -f-1 | sed 's,"\(.*\)",\1,g')
        dir="$(echo "$b" | sed 's,.*/contents/\(.*\),\1,g' | cut -d? -f-1)"  
        file="$(mktemp)"
        curl -- "$b" 2> /dev/null | tee "$file" &> /dev/null
        file_array+=("$file")
        dir_array+=("$dir")
    done
}

git_url=$(echo "$git_url" | sed 's,https://github.com/,https://api.github.com/repos/,g') 
git_url=$(echo "$git_url" | sed 's,tree/[^/]*/,contents/,g')

main_dir="$(echo $git_url | sed 's,.*/contents/\(.*\),\1,g' | cut -d? -f-1)"  
file="$(mktemp)"
curl -- "$git_url" 2> /dev/null | tee "$file" &> /dev/null

cat $file
file_array=("$file") 
dir_array=("$main_dir")
current_dir="$target_dir/$main_dir"

while ! test -z "$file_array"; do
    set -- "${file_array[@]}"
    for i; do
        mkdir -p $current_dir
        cat $i
        for j in $(cat "$i" | grep 'download_url' | awk '{print $2}' | cut -d, -f-1 | sed 's,"\(.*\)",\1,g'); do
            if ! test "$j" == "null"; then
                wget -P "$current_dir" -- "$j" 
            fi
        done
        dir_array=($(pop_element "${dir_array[@]}" "$main_dir"))
        file_array=($(pop_element "${file_array[@]}" "$i"))
        url_get_dirs "$i"
        main_dir="${dir_array[0]}"
        current_dir="$target_dir/$main_dir"
    done
done
