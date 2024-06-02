### VIM ###

alias vim="nvim -u ~/.config/nvim/init.vim" 
alias svim="sudo nvim"
#alias snvim="sudo nvim"
function rvim(){ nvr --remote $@; }
alias vim-noconf="vim -Nu NONE"
#alias vim-checkhealth="vim +checkhealth"
alias nvim-noconf="nvim -Nu NONE"
alias nvim-checkhealth="nvim +checkhealth"


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
