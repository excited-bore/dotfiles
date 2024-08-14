### VIM ###

if type vim &> /dev/null || type nvim &> /dev/null; then

    type vim &> /dev/null && VIM='vim'
    type nvim &> /dev/null && VIM='nvim'

    alias vim="$VIM -u ~/.config/nvim/init.vim" 
    alias svim="sudo $VIM"
    alias vim-noconf="$VIM -Nu NONE"
    alias vim-noconf="$VIM -Nu NONE"
    alias vim-checkhealth="$VIM +checkhealth"
    alias vim-diff="$VIM -d" 
fi

if type nvim &> /dev/null; then

    function rvim(){ nvr --remote $@; }

    # All man pages                                                                         
    function man-all-nvim() {                                                               
        local b=()                                                                          
        for i in $(man -aw $@); do                                                          
            local e                                                                         
            e=$(basename "$i|q" | sed 's|\(\)*.gz|\1|g')                                    
            b+=("+Man $e");                                                                 
        done;                                                                               
        if echo $(type "$@") | grep -q "shell builtin"; then                                
            nvim "${b[@]}" "+silent Man!" <(help -m $@) "+bfirst"                           
        else                                                                                
            nvim "${b[@]}" "+Bclose" "+bfirst"                                              
        fi                                                                                  
    }                                                                                       
                                                                                            
    # Taken from original _man function                                                                                                                                            
    complete -F _man-all man-all-nvim                                                       
                                                                                            
    alias mana="man-all-nvim"                                                               
    alias superman="man-all-nvim"                                                           
    alias sman="man-all-nvim"                                                               
fi
