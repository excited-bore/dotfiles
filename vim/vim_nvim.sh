### VIM ###

alias vim="nvim -u ~/.config/nvim/init.vim" 
alias svim="sudo nvim"
#alias snvim="sudo nvim"
function rvim(){ nvr --remote $@; }
alias vim_noconf="nvim -Nu NONE"
alias vim_check_health="nvim +checkhealth"
alias vim_plugin_install="nvim +PluginInstall|q"

# All man pages
function man-all-nvim() {
    local b=()
    for i in $(man -aw $1); do
        local e
        e=$(basename "$i|q" | sed 's|\(\)*.gz|\1|g')
        b+=("+Man $e");
    done;
    
    #local min=0
    #local max="$((${#b[@]} - 1 ))"
    #while [[ min -lt max ]]
    #do
    #    # Swap current first and last elements
    #    local x="${b[$min]}"
    #    b[$min]="${b[$max]}"
    #    b[$max]="$x"
    #    
    #    # Move closer
    #    (( min++, max-- ))
    #done             
    #b=$(printf "$b" | sed 's|+Man|"+Man|g' | sed 's|\|q|"|g')
    nvim "${b[@]}" "+Bclose" "+bfirst"
}

alias man-all="man-all-nvim"
alias Superman="man-all-nvim"
