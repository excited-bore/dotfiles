### TMUX ###

# PWD trick
#export PS1=$PS1'$( [ -n $TMUX ] && tmux setenv -g TMUX_PWD_$(tmux display -p "#D" | tr -d %) $PWD)'

# Start tmux on shell start
#if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [ -z "$TMUX" ]; then
#    tmux has-session -t main 2>/dev/null
#    if [ $? != 0 ]; then
#        exec tmux new -s main 
#    else
#        exec tmux new -t main
#    fi 
#fi

#https://stackoverflow.com/questions/41783367/tmux-tmux-true-color-is-not-working-properly
alias terminal_colours="curl -s https://raw.githubusercontent.com/JohnMorales/dotfiles/master/colors/24-bit-color.sh | bash"
alias tmux-reload="tmux source ~/.tmux.conf"

#function tmux(){
#    if [[ "$#" == 0 ]]; then 
#        kitten @ launch --copy-env --cwd=current --env TMUX="$TMPDIR/tmux-1000/default" bash -c 'tmux; kitten @ launch --copy-env --cwd=current --env TMUX= && kitten @ close-window --self' && kitten @ close-window --self
#    else
#        /usr/bin/tmux "$@";
#    fi
#}

function tmux-install-login-for-ssh(){
    
    touch ~/.aliases.d/tmux_startup.sh
    
    echo 'if [[ $- =~ i ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_TTY" ]]; then' >> ~/.aliases.d/tmux_startup.sh
    echo 'tmux attach-session -t ssh_tmux || tmux new-session -s ssh_tmux;' >> ~/.aliases.d/tmux_startup.sh  
    echo 'fi' >> ~/.aliases.d/tmux_startup.sh 

}

function tmux-new-session(){
    local session-name window-name 
    if [ -z $1 ]; then
        reade -Q 'GREEN' -i "tmux-session" -p 'Session name? (Optional): ' session-name   
    fi
    if [ -z $2 ]; then
        reade -Q 'GREEN' -p 'Window name? (Optional): ' window-name   
    fi
     
    if [[ -n $session-name ]]; then
        session-name="-s $session-name"
    fi 
    if [[ -n $window-name ]]; then
        window-name="-n $window-name" 
    fi
    
    tmux new $session-name $window-name;
}

function tmux-attach(){ 
    if [[ -n $1 ]]; then
        tmux attach -t $1;
    elif [[ $(tmux list-sessions 2>1) =~ 'no server running on' ]] || [[ $(tmux list-sessions 2>1 | wc -l) -eq 1 ]]; then
        tmux attach ;
    else
        # I prefer this over 'tmux choose-tree -NO', but you might disagree 
        tmux list-sessions
        local sess sessions=$(tmux list-sessions | awk -F':' '{ print $1}' | tr '\n' ' ')
        reade -Q 'GREEN' -i "$sessions" -p 'Which session?: ' sess 
        tmux attach -t $sess;
    fi
}

function tmux-new-detached-session(){
    local session-name window-name command 
    if [ -z $1 ]; then
        reade -Q 'GREEN' -p 'Session name? (Optional): ' session-name   
    else
        session-name=$1
    fi
    
    if [ -z $2 ]; then
        reade -Q 'GREEN' -p 'Window name? (Optional): ' window-name   
    else
        window-name=$2
    fi
     
    if [ -z $3 ]; then
        reade -Q 'GREEN' -p 'Command to run? (Optional): ' command 
    else
        command=$3
    fi

    if [[ -n $session-name ]]; then    
        session-name="-s $session-name" 
    fi 
    
    if [[ -n $window-name ]]; then    
        window-name="-n $session-name" 
    fi 

    if [[ -n $command ]]; then    
        command="send-keys $command" 
    fi 
    
    tmux new -d $session-name $window-name $command;
}

alias tmux-kill-all-but-last="tmux kill-session -a"

alias tmux-kill-server="tmux kill-server"
alias tmux-kill-all="tmux kill-server"

alias tmux-attach-choose-tree="tmux choose-tree -NO"
alias tmux-show-hooks="tmux show-hooks"

alias tmux-list-sessions="tmux list-sessions # Or tmux ls"
alias list-tmux-sessions="tmux-list-sessions"

alias tmux-list-keybinds="tmux list-keys # Or tmux lsk"
alias list-tmux-keybinds="tmux-list-keys"

alias tmux-list-clients="tmux list-clients # Or tmux lsc"
alias list-tmux-clients="tmux-list-clients"

alias tmux-list-commands="tmux list-commands # Or tmux lscm"
alias list-tmux-commands="tmux-list-commands"

alias tmux-list-panes="tmux list-panes # Or tmux lsp"
alias list-tmux-panes="tmux-list-panes"

alias tmux-list-windows="tmux list-windows # Or tmux lsw"
alias list-tmux-windows="tmux-list-windows"

alias tmux-lock-client="tmux lock-client # Or tmux lockc"
alias tmux-lock-server="tmux lock-server # Or tmux lock"
alias tmux-lock-session="tmux lock-session # Or tmux locks"

#alias tmux-toggle-panes-sync-commands="setw synchronize-panes"
