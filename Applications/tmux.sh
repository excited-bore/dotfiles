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
alias check_terminal_colours="curl -s https://raw.githubusercontent.com/JohnMorales/dotfiles/master/colors/24-bit-color.sh | bash"

function tmuxNewSession(){
    if ! [ -z $1 ]; then
        if ! [ -z $2 ]; then
            tmux new -s $1 -n $2;
        fi;
        tmux new -s $1;
    else
        echo "Give up a name for a new session (and a window name)\n";
    fi;
}

function tmuxAttach(){
    if ! [ -z $1 ]; then
        tmux attach -t $1;
    else 
        tmux attach ;
    fi; 
}

function tmuxDetachedSession(){
    if ! [ -z $1 ]; then    
        tmux new -d send-keys "$1";
    else 
        echo "Give up a command to run";
    fi;
}

alias tmuxKillServer="tmux kill-server"

function tmuxKillAllButOne(){
    if ! [ -z "$1" ]; then
        tmux kill-session -a -t "$1";
    else
        #Current session
        tmux kill-session -a;
    fi;
}

alias tmuxAttachChooseTree="tmux choose-tree -NO"
alias tmuxShowHooks="tmux show-hooks"
alias tmuxListSessions="tmux ls"
alias tmuxListKeybinds="tmux list-keys"

#alias tmuxTogglePanesSyncCommands="setw synchronize-panes"
