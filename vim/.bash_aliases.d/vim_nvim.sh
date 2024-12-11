### VIM ###

if type vim &> /dev/null || type nvim &> /dev/null; then

    type vim &> /dev/null && VIM='vim'
    type nvim &> /dev/null && VIM='nvim'

    alias vim="$VIM -u ~/.config/nvim/init.vim" 
    alias svim="sudo $VIM"
    alias vim-noconf="$VIM -Nu NONE"
    alias vim-dir="$VIM ./"
    alias vim-checkhealth="$VIM +checkhealth"
    alias vim-diff="$VIM -d" 

    if type fzf &> /dev/null; then 
        function vim-fzf(){
        query=''
        if ! test -z $@; then
            query="--query $@"
        fi
            "$VIM $(fzf --multi $query)"
        }  
        complete -F _files vim-fzf 
    fi 
fi

if type nvim &> /dev/null; then

    function rvim(){ nvr --remote $@; }

    # All man pages                                                                         
    function man-all-nvim() {                                                               
        for j in $@; do 
            local b=()                                                                          
            for i in $(man -aw $j); do                                                          
                local e                                                                         
                e=$(basename "$i|q" | sed 's|\(\)*.gz|\1|g')                                    
                b+=("+Man $e");                                                                 
            done;                                                                               
            if [[ $(compgen -b) == *"$j"* ]]; then                                
                nvim "${b[@]}" "+silent Man!" <(help -m $j) "+bfirst"                           
            else                                                                                
                nvim "${b[@]}" "+Bclose" "+bfirst"                                              
            fi                                                                                  
        done 
    }                                                                                       
                                                                                            
    # Taken from original _man function                                                                                                                                            
    complete -F _man-all man-all-nvim                                                       
                                                                                            
    alias mana="man-all-nvim"                                                               
    alias man-a="man-all-nvim"                                                               
    alias superman="man-all-nvim"                                                           
    alias man-all="man-all-nvim"                                                               
    
    #function vim-grep(){
    #    vim $@ | grep $1 
    #} 
fi
