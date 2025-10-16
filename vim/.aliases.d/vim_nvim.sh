### VIM ###

if hash vim &> /dev/null || hash nvim &> /dev/null; then

    hash vim &> /dev/null && VIM='vim'
    hash nvim &> /dev/null && VIM='nvim'

    alias vim="$VIM -u ~/.config/nvim/init.vim" 
    alias svim="sudo $VIM"
    alias vim-noconf="$VIM -Nu NONE"
    alias vim-dir="$VIM ./"
    alias vim-checkhealth="$VIM +checkhealth"
    alias vim-diff="$VIM -d" 

    if hash fzf &> /dev/null; then 
        function vim-fzf(){
            local query=''
            if ! test -z $@; then
                query="--query $@"
            fi
            "$VIM $(fzf --multi $query)"
        }  
    fi 
fi

if hash nvim &> /dev/null; then

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
    alias mana="man-all-nvim"                                                               
    alias man-a="man-all-nvim"                                                               
    alias superman="man-all-nvim"                                                           
    alias man-all="man-all-nvim"                                                               
    
    #function vim-grep(){
    #    vim $@ | grep $1 
    #} 
fi
